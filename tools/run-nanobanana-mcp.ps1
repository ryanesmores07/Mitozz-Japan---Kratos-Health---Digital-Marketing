param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ServerArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath ".."))
$localMcpConfig = Join-Path -Path $workspaceRoot -ChildPath "mcp/nanobanana.cursor.local.json"

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

if (-not (Get-Command uvx -ErrorAction SilentlyContinue)) {
    throw "uvx is not installed or not available on PATH."
}

if ([string]::IsNullOrWhiteSpace($env:GEMINI_API_KEY)) {
    throw "GEMINI_API_KEY is not set. Set it in your environment before starting the Nano Banana MCP server."
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
    "nanobanana-pro-mcp-server"
}
else {
    $env:NANOBANANA_PACKAGE
}

$arguments = @($packageName)
if ($null -ne $ServerArgs -and $ServerArgs.Count -gt 0) {
    $arguments += $ServerArgs
}

& uvx @arguments
