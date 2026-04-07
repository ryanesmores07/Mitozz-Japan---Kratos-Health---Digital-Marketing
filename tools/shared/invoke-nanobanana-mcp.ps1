param(
    [Parameter(Mandatory = $true)]
    [string]$ToolName,

    [string]$ArgumentsPath,

    [string]$ArgumentsJson,

    [int]$TimeoutSeconds = 240,

    [string]$OutputJsonPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($ArgumentsPath) -and [string]::IsNullOrWhiteSpace($ArgumentsJson)) {
    throw "Provide either -ArgumentsPath or -ArgumentsJson."
}

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath "..\.."))
$launcherPath = Join-Path -Path $workspaceRoot -ChildPath "tools/run-nanobanana-mcp.ps1"

if (-not (Test-Path -LiteralPath $launcherPath)) {
    throw "Nano Banana launcher not found: $launcherPath"
}

if (-not [string]::IsNullOrWhiteSpace($ArgumentsPath)) {
    $resolvedArgumentsPath = if ([System.IO.Path]::IsPathRooted($ArgumentsPath)) {
        [System.IO.Path]::GetFullPath($ArgumentsPath)
    }
    else {
        [System.IO.Path]::GetFullPath((Join-Path -Path $workspaceRoot -ChildPath $ArgumentsPath))
    }

    if (-not (Test-Path -LiteralPath $resolvedArgumentsPath)) {
        throw "Arguments JSON file not found: $resolvedArgumentsPath"
    }

    $ArgumentsJson = Get-Content -LiteralPath $resolvedArgumentsPath -Raw -Encoding UTF8
}

$argumentsObject = $ArgumentsJson | ConvertFrom-Json

$processInfo = New-Object System.Diagnostics.ProcessStartInfo
$processInfo.FileName = "C:\WINDOWS\System32\WindowsPowerShell\v1.0\powershell.exe"
$processInfo.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$launcherPath`""
$processInfo.WorkingDirectory = $workspaceRoot
$processInfo.RedirectStandardInput = $true
$processInfo.RedirectStandardOutput = $true
$processInfo.RedirectStandardError = $true
$processInfo.UseShellExecute = $false
$processInfo.CreateNoWindow = $true

$process = New-Object System.Diagnostics.Process
$process.StartInfo = $processInfo
$null = $process.Start()

$deadline = (Get-Date).AddSeconds($TimeoutSeconds)
$responseLine = $null
$initializeError = $null

function Wait-ForMcpResponse {
    param(
        [Parameter(Mandatory = $true)]
        [int]$ResponseId
    )

    $pendingReadTask = $null

    while ((Get-Date) -lt $deadline) {
        if ($null -eq $pendingReadTask) {
            $pendingReadTask = $process.StandardOutput.ReadLineAsync()
        }

        if (-not $pendingReadTask.Wait(200)) {
            if ($process.HasExited) {
                break
            }

            continue
        }

        $line = $pendingReadTask.Result
        $pendingReadTask = $null
        if ($null -eq $line) {
            if ($process.HasExited) {
                break
            }

            continue
        }

        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }

        try {
            $message = $line | ConvertFrom-Json

            if ($message.id -eq 1 -and $null -ne $message.error) {
                $initializeError = $line
            }

            if ($message.id -eq $ResponseId) {
                return $line
            }
        }
        catch {
        }
    }

    return $null
}

$requests = @(
    @{
        jsonrpc = "2.0"
        id = 1
        method = "initialize"
        params = @{
            protocolVersion = "2024-11-05"
            capabilities = @{}
            clientInfo = @{
                name = "mitozz-nanobanana-invoke"
                version = "1.0.0"
            }
        }
    },
    @{
        jsonrpc = "2.0"
        method = "notifications/initialized"
        params = @{}
    },
    @{
        jsonrpc = "2.0"
        id = 2
        method = "tools/call"
        params = @{
            name = $ToolName
            arguments = $argumentsObject
        }
    }
)

foreach ($request in $requests) {
    $process.StandardInput.WriteLine(($request | ConvertTo-Json -Compress -Depth 20))
}
$process.StandardInput.Flush()

$responseLine = Wait-ForMcpResponse -ResponseId 2

if ([string]::IsNullOrWhiteSpace($responseLine)) {
    if (-not $process.HasExited) {
        $process.Kill()
        $process.WaitForExit(5000) | Out-Null
    }

    $stderr = $process.StandardError.ReadToEnd().Trim()

    if (-not [string]::IsNullOrWhiteSpace($initializeError)) {
        throw "Nano Banana MCP initialize failed. $initializeError"
    }

    if (-not [string]::IsNullOrWhiteSpace($stderr)) {
        throw "Nano Banana MCP call failed. $stderr"
    }

    throw "Nano Banana MCP call timed out after $TimeoutSeconds seconds."
}

if (-not $process.HasExited) {
    $process.Kill()
}

if (-not [string]::IsNullOrWhiteSpace($OutputJsonPath)) {
    $resolvedOutputJsonPath = if ([System.IO.Path]::IsPathRooted($OutputJsonPath)) {
        [System.IO.Path]::GetFullPath($OutputJsonPath)
    }
    else {
        [System.IO.Path]::GetFullPath((Join-Path -Path $workspaceRoot -ChildPath $OutputJsonPath))
    }

    $outputDirectory = Split-Path -Path $resolvedOutputJsonPath -Parent
    if (-not (Test-Path -LiteralPath $outputDirectory)) {
        New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
    }

    $responseLine | Set-Content -LiteralPath $resolvedOutputJsonPath -Encoding UTF8
}

Write-Output $responseLine
