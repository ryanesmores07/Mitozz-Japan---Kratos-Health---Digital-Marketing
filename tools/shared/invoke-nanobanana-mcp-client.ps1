param(
    [Parameter(Mandatory = $true)]
    [string]$ToolName,

    [string]$ArgumentsPath,

    [string]$ArgumentsJson
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath "..\.."))
$pythonPath = Join-Path -Path $workspaceRoot -ChildPath "mcp/uv-python/cpython-3.14.3-windows-x86_64-none/python.exe"
$scriptPath = Join-Path -Path $workspaceRoot -ChildPath "tools/shared/invoke-nanobanana-mcp-client.py"

if (-not (Test-Path -LiteralPath $pythonPath)) {
    throw "Workspace Python runtime not found: $pythonPath"
}

if (-not (Test-Path -LiteralPath $scriptPath)) {
    throw "Nano Banana MCP client helper not found: $scriptPath"
}

$arguments = @($scriptPath, "--tool", $ToolName)

if (-not [string]::IsNullOrWhiteSpace($ArgumentsPath)) {
    $resolvedArgumentsPath = if ([System.IO.Path]::IsPathRooted($ArgumentsPath)) {
        [System.IO.Path]::GetFullPath($ArgumentsPath)
    }
    else {
        [System.IO.Path]::GetFullPath((Join-Path -Path $workspaceRoot -ChildPath $ArgumentsPath))
    }

    $arguments += @("--arguments-path", $resolvedArgumentsPath)
}
elseif (-not [string]::IsNullOrWhiteSpace($ArgumentsJson)) {
    $arguments += @("--arguments-json", $ArgumentsJson)
}

& $pythonPath @arguments
