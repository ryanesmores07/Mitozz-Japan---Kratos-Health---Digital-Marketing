param(
    [Parameter(Mandatory = $true)]
    [string]$DataDirectory,

    [Parameter(Mandatory = $true)]
    [string]$TemplatePath,

    [Parameter(Mandatory = $true)]
    [string]$OutputDirectory,

    [ValidateSet("winforms", "edge", "chrome", "auto")]
    [string]$Browser = "auto"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$renderScript = Join-Path $PSScriptRoot "render-instagram-template.ps1"
$dataItems = Get-ChildItem -LiteralPath $DataDirectory -Filter "*.json" | Sort-Object Name

if (-not $dataItems) {
    throw "No JSON data files found in $DataDirectory"
}

New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null

foreach ($item in $dataItems) {
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($item.Name)
    $htmlPath = Join-Path $OutputDirectory "$baseName.html"
    $pngPath = Join-Path $OutputDirectory "$baseName.png"

    powershell -STA -NoProfile -ExecutionPolicy Bypass -File $renderScript `
        -TemplatePath $TemplatePath `
        -DataPath $item.FullName `
        -HtmlOutputPath $htmlPath `
        -ImageOutputPath $pngPath `
        -Browser $Browser

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to render $($item.FullName)"
    }
}

Write-Output "Rendered $($dataItems.Count) template files to $OutputDirectory"
