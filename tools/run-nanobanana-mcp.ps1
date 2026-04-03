param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ServerArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath ".."))
$localMcpConfig = Join-Path -Path $workspaceRoot -ChildPath "mcp/nanobanana.cursor.local.json"
$archiveRoot = Join-Path -Path $workspaceRoot -ChildPath "mcp/uv-cache/archive-v0"
$workspacePython = Join-Path -Path $workspaceRoot -ChildPath "mcp/uv-python/cpython-3.14.3-windows-x86_64-none/python.exe"

if (([string]::IsNullOrWhiteSpace($env:GEMINI_API_KEY) -or [string]::IsNullOrWhiteSpace($env:NANOBANANA_MODEL)) -and (Test-Path -LiteralPath $localMcpConfig)) {
    try {
        $localConfig = Get-Content -LiteralPath $localMcpConfig -Raw -Encoding UTF8 | ConvertFrom-Json
        $localEnv = $localConfig.mcpServers.nanobanana.env

        if ([string]::IsNullOrWhiteSpace($env:GEMINI_API_KEY) -and $null -ne $localEnv.GEMINI_API_KEY) {
            $env:GEMINI_API_KEY = [string]$localEnv.GEMINI_API_KEY
        }

        if ([string]::IsNullOrWhiteSpace($env:NANOBANANA_MODEL) -and $null -ne $localEnv.NANOBANANA_MODEL) {
            $env:NANOBANANA_MODEL = [string]$localEnv.NANOBANANA_MODEL
        }
    }
    catch {
        throw "Failed to read local Nano Banana config from $localMcpConfig. $($_.Exception.Message)"
    }
}

if ([string]::IsNullOrWhiteSpace($env:GEMINI_API_KEY)) {
    throw "GEMINI_API_KEY is not set. Set it in your environment before starting the Nano Banana MCP server."
}

# Default this workspace to the Nano Banana 2 lane unless a caller explicitly overrides it.
if ([string]::IsNullOrWhiteSpace($env:NANOBANANA_MODEL)) {
    $env:NANOBANANA_MODEL = "nb2"
}

$runtimePatchScript = Join-Path -Path $PSScriptRoot -ChildPath "patch-nanobanana-runtime.ps1"
if (Test-Path -LiteralPath $runtimePatchScript) {
    & $runtimePatchScript
}

# Keep uv state inside the workspace when possible so MCP startup is more reliable
# across restricted environments and avoids user-profile cache issues.
if ([string]::IsNullOrWhiteSpace($env:UV_CACHE_DIR)) {
    $env:UV_CACHE_DIR = Join-Path -Path $workspaceRoot -ChildPath "mcp/uv-cache"
}

if (-not (Test-Path -LiteralPath $env:UV_CACHE_DIR)) {
    New-Item -ItemType Directory -Path $env:UV_CACHE_DIR -Force | Out-Null
}

if ([string]::IsNullOrWhiteSpace($env:UV_PYTHON_INSTALL_DIR)) {
    $env:UV_PYTHON_INSTALL_DIR = Join-Path -Path $workspaceRoot -ChildPath "mcp/uv-python"
}

if (-not (Test-Path -LiteralPath $env:UV_PYTHON_INSTALL_DIR)) {
    New-Item -ItemType Directory -Path $env:UV_PYTHON_INSTALL_DIR -Force | Out-Null
}

if ([string]::IsNullOrWhiteSpace($env:UV_TOOL_DIR)) {
    $env:UV_TOOL_DIR = Join-Path -Path $workspaceRoot -ChildPath "mcp/uv-tools"
}

if (-not (Test-Path -LiteralPath $env:UV_TOOL_DIR)) {
    New-Item -ItemType Directory -Path $env:UV_TOOL_DIR -Force | Out-Null
}

if ([string]::IsNullOrWhiteSpace($env:XDG_DATA_HOME)) {
    $env:XDG_DATA_HOME = Join-Path -Path $workspaceRoot -ChildPath "mcp/xdg-data"
}

if (-not (Test-Path -LiteralPath $env:XDG_DATA_HOME)) {
    New-Item -ItemType Directory -Path $env:XDG_DATA_HOME -Force | Out-Null
}

if ([string]::IsNullOrWhiteSpace($env:FASTMCP_SHOW_SERVER_BANNER)) {
    $env:FASTMCP_SHOW_SERVER_BANNER = "false"
}

if ([string]::IsNullOrWhiteSpace($env:FASTMCP_LOG_ENABLED)) {
    $env:FASTMCP_LOG_ENABLED = "false"
}

if ([string]::IsNullOrWhiteSpace($env:FASTMCP_LOG_LEVEL)) {
    $env:FASTMCP_LOG_LEVEL = "ERROR"
}

if ([string]::IsNullOrWhiteSpace($env:FASTMCP_DEPRECATION_WARNINGS)) {
    $env:FASTMCP_DEPRECATION_WARNINGS = "false"
}

if ([string]::IsNullOrWhiteSpace($env:LOG_LEVEL)) {
    $env:LOG_LEVEL = "ERROR"
}

$packageName = if ([string]::IsNullOrWhiteSpace($env:NANOBANANA_PACKAGE)) {
    "nanobanana-mcp-server"
}
else {
    $env:NANOBANANA_PACKAGE
}

function Get-LocalNanoBananaEntrypoint {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ArchiveRoot
    )

    if (-not (Test-Path -LiteralPath $ArchiveRoot)) {
        return $null
    }

    function Find-CachedExe {
        $exeMatch = Get-ChildItem -Path $ArchiveRoot -Recurse -File -Filter "nanobanana-mcp-server.exe" -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending |
            Select-Object -First 1

        if ($null -ne $exeMatch) {
            return @{
                FilePath = $exeMatch.FullName
                Arguments = @()
                Mode = "exe"
            }
        }

        return $null
    }

    $sitePackagesServer = Get-ChildItem -Path $ArchiveRoot -Recurse -File -Filter "server.py" -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -match 'Lib[\\/]site-packages[\\/]nanobanana_mcp_server[\\/]server\.py$' } |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if ($null -ne $sitePackagesServer -and (Test-Path -LiteralPath $workspacePython)) {
        $sitePackagesRoot = Split-Path -Path $sitePackagesServer.FullName -Parent
        $sitePackagesRoot = Split-Path -Path $sitePackagesRoot -Parent

        return @{
            FilePath = $workspacePython
            Arguments = @("-m", "nanobanana_mcp_server.server")
            Mode = "python"
            PythonPaths = @(
                $sitePackagesRoot,
                (Join-Path -Path $sitePackagesRoot -ChildPath "win32"),
                (Join-Path -Path $sitePackagesRoot -ChildPath "win32/lib"),
                (Join-Path -Path $sitePackagesRoot -ChildPath "pywin32_system32")
            )
        }
    }

    $serverMatch = Get-ChildItem -Path $ArchiveRoot -Recurse -File -Filter "server.py" -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -match 'nanobanana_mcp_server[\\/]+server\.py$' } |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if ($null -eq $serverMatch) {
        return Find-CachedExe
    }

    $envRoot = $serverMatch.Directory.FullName
    while (-not [string]::IsNullOrWhiteSpace($envRoot)) {
        $scriptsDir = Join-Path -Path $envRoot -ChildPath "Scripts"
        if (Test-Path -LiteralPath $scriptsDir) {
            break
        }

        $parentDir = Split-Path -Path $envRoot -Parent
        if ([string]::IsNullOrWhiteSpace($parentDir) -or $parentDir -eq $envRoot) {
            $envRoot = $null
            break
        }

        $envRoot = $parentDir
    }

    if ([string]::IsNullOrWhiteSpace($envRoot)) {
        return Find-CachedExe
    }

    $exeCandidate = Join-Path -Path $envRoot -ChildPath "Scripts/nanobanana-mcp-server.exe"
    if (Test-Path -LiteralPath $exeCandidate) {
        return @{
            FilePath = $exeCandidate
            Arguments = @()
            Mode = "exe"
        }
    }

    $pythonCandidate = Join-Path -Path $envRoot -ChildPath "Scripts/python.exe"

    if (Test-Path -LiteralPath $pythonCandidate) {
        return @{
            FilePath = $pythonCandidate
            Arguments = @($serverMatch.FullName)
            Mode = "python"
        }
    }

    return Find-CachedExe
}

$localEntrypoint = Get-LocalNanoBananaEntrypoint -ArchiveRoot $archiveRoot

if ($null -ne $localEntrypoint) {
    if ($localEntrypoint.ContainsKey("PythonPaths") -and $null -ne $localEntrypoint.PythonPaths) {
        $pythonPathEntries = @($localEntrypoint.PythonPaths | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
        if (-not [string]::IsNullOrWhiteSpace($env:PYTHONPATH)) {
            $pythonPathEntries += $env:PYTHONPATH
        }
        $env:PYTHONPATH = ($pythonPathEntries -join [System.IO.Path]::PathSeparator)
    }

    $arguments = @($localEntrypoint.Arguments)
    if ($null -ne $ServerArgs -and $ServerArgs.Count -gt 0) {
        $arguments += $ServerArgs
    }

    & $localEntrypoint.FilePath @arguments
    exit $LASTEXITCODE
}

if (-not (Get-Command uvx -ErrorAction SilentlyContinue)) {
    throw "uvx is not installed or not available on PATH, and no local Nano Banana runtime was found."
}

$arguments = @($packageName)
if ($null -ne $ServerArgs -and $ServerArgs.Count -gt 0) {
    $arguments += $ServerArgs
}

& uvx @arguments
