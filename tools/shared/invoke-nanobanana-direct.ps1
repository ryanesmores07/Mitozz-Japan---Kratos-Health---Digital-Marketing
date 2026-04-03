param(
    [Parameter(Mandatory = $true)]
    [string]$RequestPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath "..\.."))
$pythonPath = Join-Path -Path $workspaceRoot -ChildPath "mcp/uv-python/cpython-3.14.3-windows-x86_64-none/python.exe"
$scriptPath = Join-Path -Path $workspaceRoot -ChildPath "tools/shared/generate-nanobanana-image.py"

if (-not (Test-Path -LiteralPath $pythonPath)) {
    throw "Workspace Python runtime not found: $pythonPath"
}

if (-not (Test-Path -LiteralPath $scriptPath)) {
    throw "Nano Banana direct helper not found: $scriptPath"
}

$resolvedRequestPath = if ([System.IO.Path]::IsPathRooted($RequestPath)) {
    [System.IO.Path]::GetFullPath($RequestPath)
}
else {
    [System.IO.Path]::GetFullPath((Join-Path -Path $workspaceRoot -ChildPath $RequestPath))
}

if (-not (Test-Path -LiteralPath $resolvedRequestPath)) {
    throw "Request file not found: $resolvedRequestPath"
}

& $pythonPath $scriptPath --request $resolvedRequestPath
