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

$arguments = @("nanobanana-mcp-server@latest")
if ($null -ne $ServerArgs -and $ServerArgs.Count -gt 0) {
    $arguments += $ServerArgs
}

Write-Output "Starting Nano Banana MCP server via uvx..."
Write-Output "Using GEMINI_API_KEY from environment."

& uvx @arguments
