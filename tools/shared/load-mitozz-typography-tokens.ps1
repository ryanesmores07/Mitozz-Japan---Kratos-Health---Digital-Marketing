Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Get-Variable -Name MitozzTypographicFormat -Scope Script -ErrorAction SilentlyContinue)) {
    $script:MitozzTypographicFormat = [System.Drawing.StringFormat]::GenericTypographic.Clone()
}

function Get-MitozzTypographyTokens {
    param(
        [string]$TokenPath = (Join-Path $PSScriptRoot '..\..\design-system\instagram\tokens\mitozz-typography.tokens.psd1')
    )

    $resolvedPath = [System.IO.Path]::GetFullPath($TokenPath)
    if (-not (Test-Path -LiteralPath $resolvedPath)) {
        throw "Typography token file not found at $resolvedPath"
    }

    return Import-PowerShellDataFile -LiteralPath $resolvedPath
}

function Get-MitozzFontProfileConfig {
    param(
        [string]$Profile = 'mitozz_sans',
        [string]$TokenPath = (Join-Path $PSScriptRoot '..\..\design-system\instagram\tokens\mitozz-typography.tokens.psd1')
    )

    $tokens = Get-MitozzTypographyTokens -TokenPath $TokenPath
    if (-not $tokens.font_profiles.ContainsKey($Profile)) {
        throw "Unknown typography font profile '$Profile'."
    }

    return $tokens.font_profiles[$Profile]
}

function Get-MitozzTypographyCssTokenBlock {
    param(
        [string]$FontProfile = 'mitozz_sans',
        [string]$TokenPath = (Join-Path $PSScriptRoot '..\..\design-system\instagram\tokens\mitozz-typography.tokens.psd1')
    )

    $tokens = Get-MitozzTypographyTokens -TokenPath $TokenPath
    $profile = Get-MitozzFontProfileConfig -Profile $FontProfile -TokenPath $TokenPath

    $lines = New-Object System.Collections.Generic.List[string]
    [void]$lines.Add(':root {')
    [void]$lines.Add(("  --mitozz-font-headline: {0};" -f $profile.css_headline_stack))
    [void]$lines.Add(("  --mitozz-font-body: {0};" -f $profile.css_body_stack))
    [void]$lines.Add(("  --mitozz-font-accent: {0};" -f $profile.css_accent_stack))

    function Add-RoleCssVariables {
        param(
            [string]$Prefix,
            [hashtable]$Node
        )

        foreach ($key in $Node.Keys) {
            $value = $Node[$key]
            $cssKey = $key.Replace('_', '-')
            $childPrefix = if ([string]::IsNullOrWhiteSpace($Prefix)) { $cssKey } else { "$Prefix-$cssKey" }

            if ($value -is [hashtable]) {
                Add-RoleCssVariables -Prefix $childPrefix -Node $value
                continue
            }

            $cssValue = [string]$value
            if ($key -eq 'font_family') {
                switch ($cssValue) {
                    'headline' { $cssValue = 'var(--mitozz-font-headline)' }
                    'body' { $cssValue = 'var(--mitozz-font-body)' }
                    'accent' { $cssValue = 'var(--mitozz-font-accent)' }
                }
            }

            [void]$lines.Add(("  --mitozz-type-{0}: {1};" -f $childPrefix, $cssValue))
        }
    }

    Add-RoleCssVariables -Prefix '' -Node $tokens.template_roles
    [void]$lines.Add('}')

    return ($lines -join [Environment]::NewLine)
}

function Get-TrackedTextWidth {
    param(
        [System.Drawing.Graphics]$Graphics,
        [string]$Text,
        [System.Drawing.Font]$Font,
        [float]$Tracking = 0
    )

    if ([string]::IsNullOrEmpty($Text)) {
        return [float]0
    }

    $width = [float]0
    $chars = $Text.ToCharArray()
    for ($i = 0; $i -lt $chars.Length; $i++) {
        $charWidth = [float]$Graphics.MeasureString([string]$chars[$i], $Font, 1000, $script:MitozzTypographicFormat).Width
        $width += $charWidth
        if ($i -lt ($chars.Length - 1)) {
            $width += $Tracking
        }
    }

    return $width
}

function Draw-TrackedText {
    param(
        [System.Drawing.Graphics]$Graphics,
        [string]$Text,
        [System.Drawing.Font]$Font,
        [System.Drawing.Brush]$Brush,
        [float]$X,
        [float]$Y,
        [float]$Tracking = 0,
        [ValidateSet('left', 'center', 'right')]
        [string]$Alignment = 'left'
    )

    if ([string]::IsNullOrEmpty($Text)) {
        return [float]$X
    }

    $textWidth = Get-TrackedTextWidth -Graphics $Graphics -Text $Text -Font $Font -Tracking $Tracking
    $cursorX = [float]$X

    switch ($Alignment) {
        'center' { $cursorX = [float]($X - ($textWidth / 2)) }
        'right' { $cursorX = [float]($X - $textWidth) }
    }

    $chars = $Text.ToCharArray()
    foreach ($char in $chars) {
        $charText = [string]$char
        $Graphics.DrawString($charText, $Font, $Brush, $cursorX, $Y, $script:MitozzTypographicFormat)
        $cursorX += [float]$Graphics.MeasureString($charText, $Font, 1000, $script:MitozzTypographicFormat).Width + $Tracking
    }

    return $cursorX
}

function Draw-TrackedLines {
    param(
        [System.Drawing.Graphics]$Graphics,
        [string[]]$Lines,
        [System.Drawing.Font]$Font,
        [System.Drawing.Brush]$Brush,
        [float]$X,
        [float]$Y,
        [float]$LineHeight,
        [float]$Tracking = 0,
        [ValidateSet('left', 'center', 'right')]
        [string]$Alignment = 'left'
    )

    $currentY = [float]$Y
    foreach ($line in $Lines) {
        [void](Draw-TrackedText -Graphics $Graphics -Text $line -Font $Font -Brush $Brush -X $X -Y $currentY -Tracking $Tracking -Alignment $Alignment)
        $currentY += $LineHeight
    }

    return $currentY
}
