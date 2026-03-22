param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ResolverArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath ".."))
$resolverScript = Join-Path -Path $workspaceRoot -ChildPath "tools/resolve-template-mapping.py"

$pythonCommand = $null
foreach ($candidate in @("py", "python", "python3")) {
    $resolved = Get-Command $candidate -ErrorAction SilentlyContinue
    if ($null -ne $resolved) {
        $pythonCommand = $candidate
        break
    }
}

if ($null -eq $pythonCommand) {
    throw "No Python launcher was found. Install Python and make sure `py`, `python`, or `python3` is available on PATH."
}

& $pythonCommand $resolverScript @ResolverArgs
