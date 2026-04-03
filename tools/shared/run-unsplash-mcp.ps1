Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..'))
$serverRoot = Join-Path $workspaceRoot 'tools\unsplash-smart-mcp-server'
$tsxCli = Join-Path $serverRoot 'node_modules\tsx\dist\cli.mjs'

if (-not (Test-Path -LiteralPath $serverRoot)) {
    throw "Unsplash MCP server directory not found at $serverRoot"
}

if (-not (Test-Path -LiteralPath $tsxCli)) {
    throw "Unsplash MCP tsx CLI not found at $tsxCli"
}

$nodeCandidates = @(
    'C:\Users\esmoresernieryanocam\AppData\Local\Volta\tools\image\node\20.10.0\node.exe',
    ((Get-Command node -ErrorAction SilentlyContinue | Select-Object -First 1).Source)
) | Where-Object {
    $_ -and (Test-Path -LiteralPath $_)
} | Select-Object -Unique

if (-not $nodeCandidates -or $nodeCandidates.Count -eq 0) {
    throw 'Unable to find a usable Node runtime for the Unsplash MCP server.'
}

$nodeExe = [string]$nodeCandidates[0]

Push-Location $serverRoot
try {
    & $nodeExe $tsxCli 'src/server.ts'
}
finally {
    Pop-Location
}
