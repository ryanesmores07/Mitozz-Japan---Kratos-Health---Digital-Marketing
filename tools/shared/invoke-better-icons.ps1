param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Args
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..'))
$localCli = Join-Path $workspaceRoot 'tools/better-icons-cli/node_modules/better-icons/dist/index.js'
$directNode = 'C:\Users\esmoresernieryanocam\AppData\Local\Volta\tools\image\node\20.10.0\node.exe'

if (-not (Test-Path -LiteralPath $localCli)) {
    throw "Better Icons local CLI not found at $localCli"
}

if (-not (Test-Path -LiteralPath $directNode)) {
    throw "Direct node.exe not found at $directNode"
}

& $directNode $localCli @Args
