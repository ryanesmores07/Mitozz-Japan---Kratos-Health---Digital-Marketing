Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Convert-HexToDrawingColor {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Hex,

        [int]$Alpha = 255
    )

    $normalized = $Hex.Trim().TrimStart('#')
    if ($normalized.Length -ne 6) {
        throw "Expected a 6-digit hex value, got '$Hex'."
    }

    $r = [Convert]::ToInt32($normalized.Substring(0, 2), 16)
    $g = [Convert]::ToInt32($normalized.Substring(2, 2), 16)
    $b = [Convert]::ToInt32($normalized.Substring(4, 2), 16)
    return [System.Drawing.Color]::FromArgb($Alpha, $r, $g, $b)
}

function Convert-TokenSpecToDrawingColor {
    param(
        [Parameter(Mandatory = $true)]
        [object]$Spec
    )

    if ($Spec -is [string]) {
        return Convert-HexToDrawingColor -Hex $Spec
    }

    if ($Spec -is [hashtable]) {
        $alpha = if ($Spec.ContainsKey('alpha')) { [int]$Spec.alpha } else { 255 }
        if ($Spec.ContainsKey('hex')) {
            return Convert-HexToDrawingColor -Hex ([string]$Spec.hex) -Alpha $alpha
        }
    }

    throw "Unsupported token color spec."
}

function Get-MitozzDesignTokens {
    param(
        [string]$Variant = 'default'
    )

    $workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..'))
    $tokensPath = Join-Path $workspaceRoot 'design-system/instagram/tokens/mitozz-steel-light.tokens.psd1'

    if (-not (Test-Path -LiteralPath $tokensPath)) {
        throw "Token file not found at $tokensPath"
    }

    $data = Import-PowerShellDataFile -Path $tokensPath
    if (-not $data.palette_variants.ContainsKey($Variant)) {
        throw "Unknown palette variant '$Variant'."
    }

    $mergedRoles = @{}
    foreach ($key in $data.base_roles.Keys) {
        $mergedRoles[$key] = $data.base_roles[$key]
    }

    $selectedVariant = $data.palette_variants[$Variant]
    foreach ($key in $selectedVariant.overrides.Keys) {
        $mergedRoles[$key] = $selectedVariant.overrides[$key]
    }

    $colors = [ordered]@{}
    foreach ($key in $mergedRoles.Keys) {
        $colors[$key] = Convert-TokenSpecToDrawingColor -Spec $mergedRoles[$key]
    }

    return [pscustomobject]@{
        SystemName = [string]$data.system_name
        Version = [string]$data.version
        Variant = $Variant
        VariantDescription = [string]$selectedVariant.description
        UsageGuidance = $data.usage_guidance
        ColorPrinciples = $data.color_principles
        AllowedCreativePlay = $data.allowed_creative_play
        Colors = [pscustomobject]$colors
        RawData = $data
    }
}
