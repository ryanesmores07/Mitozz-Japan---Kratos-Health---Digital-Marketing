Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath ".."))
$archiveRoot = Join-Path -Path $workspaceRoot -ChildPath "mcp/uv-cache/archive-v0"

if (-not (Test-Path -LiteralPath $archiveRoot)) {
    exit 0
}

function Replace-Text {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string]$OldValue,

        [Parameter(Mandatory = $true)]
        [string]$NewValue
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        return $false
    }

    $content = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    if ($content -notlike "*$OldValue*") {
        return $false
    }

    $updated = $content.Replace($OldValue, $NewValue)
    if ($updated -ne $content) {
        Set-Content -LiteralPath $Path -Value $updated -Encoding UTF8
        return $true
    }

    return $false
}

$patchedFiles = 0

$settingsFiles = Get-ChildItem -Path $archiveRoot -Recurse -File -Filter settings.py |
    Where-Object { $_.FullName -match 'nanobanana_mcp_server[\\/]+config[\\/]+settings\.py$' }

foreach ($file in $settingsFiles) {
    $changed = $false
    $changed = (Replace-Text -Path $file.FullName -OldValue 'FLASH = "flash"  # Speed-optimized (Gemini 2.5 Flash)' -NewValue 'FLASH = "flash"  # Speed-optimized (Gemini 3.1 Flash Image / Nano Banana 2)') -or $changed
    $changed = (Replace-Text -Path $file.FullName -OldValue '"""Gemini 2.5 Flash Image configuration (speed-optimized)."""' -NewValue '"""Gemini 3.1 Flash Image configuration (speed-optimized)."""') -or $changed
    $changed = (Replace-Text -Path $file.FullName -OldValue 'model_name: str = "gemini-2.5-flash-image"' -NewValue 'model_name: str = "gemini-3.1-flash-image-preview"') -or $changed

    if ($changed) {
        $patchedFiles++
    }
}

$selectorFiles = Get-ChildItem -Path $archiveRoot -Recurse -File -Filter model_selector.py |
    Where-Object { $_.FullName -match 'nanobanana_mcp_server[\\/]+services[\\/]+model_selector\.py$' }

foreach ($file in $selectorFiles) {
    $changed = $false
    $changed = (Replace-Text -Path $file.FullName -OldValue 'flash_service: Gemini 2.5 Flash Image service (speed-optimized)' -NewValue 'flash_service: Gemini 3.1 Flash Image service (speed-optimized)') -or $changed
    $changed = (Replace-Text -Path $file.FullName -OldValue '"name": "Gemini 2.5 Flash Image"' -NewValue '"name": "Gemini 3.1 Flash Image"') -or $changed
    $changed = (Replace-Text -Path $file.FullName -OldValue '"model_id": "gemini-2.5-flash-image"' -NewValue '"model_id": "gemini-3.1-flash-image-preview"') -or $changed

    if ($changed) {
        $patchedFiles++
    }
}

exit 0
