param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ServerArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Get-Command uvx -ErrorAction SilentlyContinue)) {
    throw "uvx is not installed or not available on PATH."
}

if ([string]::IsNullOrWhiteSpace($env:GEMINI_API_KEY)) {
    throw "GEMINI_API_KEY is not set. Set it in your environment before starting the Nano Banana MCP server."
}

# Keep uv state inside the workspace when possible so MCP startup is more reliable
# across restricted environments and avoids user-profile cache issues.
if ([string]::IsNullOrWhiteSpace($env:UV_CACHE_DIR)) {
    $workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath ".."))
    $env:UV_CACHE_DIR = Join-Path -Path $workspaceRoot -ChildPath "mcp/uv-cache"
}

if (-not (Test-Path -LiteralPath $env:UV_CACHE_DIR)) {
    New-Item -ItemType Directory -Path $env:UV_CACHE_DIR -Force | Out-Null
}

if ([string]::IsNullOrWhiteSpace($env:UV_PYTHON_INSTALL_DIR)) {
    $workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath ".."))
    $env:UV_PYTHON_INSTALL_DIR = Join-Path -Path $workspaceRoot -ChildPath "mcp/uv-python"
}

if (-not (Test-Path -LiteralPath $env:UV_PYTHON_INSTALL_DIR)) {
    New-Item -ItemType Directory -Path $env:UV_PYTHON_INSTALL_DIR -Force | Out-Null
}

$packageName = if ([string]::IsNullOrWhiteSpace($env:NANOBANANA_PACKAGE)) {
    "nanobanana-pro-mcp-server"
}
else {
    $env:NANOBANANA_PACKAGE
}

$arguments = @($packageName)
if ($null -ne $ServerArgs -and $ServerArgs.Count -gt 0) {
    $arguments += $ServerArgs
}

Write-Output "Starting Nano Banana MCP server via uvx..."
Write-Output "Using GEMINI_API_KEY from environment."
Write-Output "Nano Banana package: $packageName"
if ([string]::IsNullOrWhiteSpace($env:NANOBANANA_MODEL)) {
    Write-Output "NANOBANANA_MODEL not set; server default will be used."
}
else {
    Write-Output "Requested Nano Banana model tier: $($env:NANOBANANA_MODEL)"
}

& uvx @arguments
