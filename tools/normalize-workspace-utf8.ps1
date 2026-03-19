Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath ".."))
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

$targets = @(
    @{ Path = "brand/references/business-context/content-planning"; Extensions = @(".csv", ".xlsx") ; Recurse = $false },
    @{ Path = "brand/references/business-context/creative-packages"; Extensions = @(".md") ; Recurse = $false },
    @{ Path = "prompts"; Extensions = @(".json", ".md") ; Recurse = $true },
    @{ Path = "workflows"; Extensions = @(".md") ; Recurse = $false },
    @{ Path = ".agents/skills"; Extensions = @(".md") ; Recurse = $true },
    @{ Path = "."; Extensions = @(".md", ".txt") ; Recurse = $false }
)

function Resolve-WorkspacePath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PathValue
    )

    if ([System.IO.Path]::IsPathRooted($PathValue)) {
        return [System.IO.Path]::GetFullPath($PathValue)
    }

    return [System.IO.Path]::GetFullPath((Join-Path -Path $workspaceRoot -ChildPath $PathValue))
}

$files = @()
foreach ($target in $targets) {
    $absolutePath = Resolve-WorkspacePath -PathValue $target.Path
    if (-not (Test-Path -LiteralPath $absolutePath -PathType Container)) {
        continue
    }

    $items = if ($target.Recurse) {
        Get-ChildItem -LiteralPath $absolutePath -Recurse -File
    }
    else {
        Get-ChildItem -LiteralPath $absolutePath -File
    }

    $files += $items | Where-Object { $target.Extensions -contains $_.Extension.ToLowerInvariant() }
}

$files = $files | Sort-Object FullName -Unique

foreach ($file in $files) {
    try {
        $content = [System.IO.File]::ReadAllText($file.FullName)
        $normalized = $content -replace "`r`n", "`n" -replace "`r", "`n"
        [System.IO.File]::WriteAllText($file.FullName, $normalized, $utf8NoBom)
    }
    catch {
        Write-Warning ("Skipped (permission or lock): " + $file.FullName)
    }
}

Write-Output "Normalized files to UTF-8 (no BOM):"
$files.FullName
