param(
    [ValidateSet('default', 'cool_focus', 'warm_editorial')]
    [string]$PaletteVariant = 'cool_focus',
    [ValidateSet('mitozz_sans', 'humanist_sans', 'editorial_serif')]
    [string]$FontProfile = 'humanist_sans'
)

Add-Type -AssemblyName System.Drawing

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'shared/load-mitozz-design-tokens.ps1')
. (Join-Path $PSScriptRoot 'shared/load-mitozz-typography-tokens.ps1')

function New-Font {
    param(
        [string[]]$Families,
        [float]$Size,
        [System.Drawing.FontStyle]$Style = [System.Drawing.FontStyle]::Regular
    )

    foreach ($family in $Families) {
        try {
            return New-Object System.Drawing.Font($family, $Size, $Style, [System.Drawing.GraphicsUnit]::Pixel)
        }
        catch {
            continue
        }
    }

    throw 'Unable to create font.'
}

function New-RoundedPath {
    param(
        [float]$X,
        [float]$Y,
        [float]$Width,
        [float]$Height,
        [float]$Radius
    )

    $diameter = $Radius * 2
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc($X, $Y, $diameter, $diameter, 180, 90)
    $path.AddArc($X + $Width - $diameter, $Y, $diameter, $diameter, 270, 90)
    $path.AddArc($X + $Width - $diameter, $Y + $Height - $diameter, $diameter, $diameter, 0, 90)
    $path.AddArc($X, $Y + $Height - $diameter, $diameter, $diameter, 90, 90)
    $path.CloseFigure()
    return $path
}

function Draw-RoundedGradientBox {
    param(
        [System.Drawing.Graphics]$Graphics,
        [float]$X,
        [float]$Y,
        [float]$Width,
        [float]$Height,
        [float]$Radius,
        [System.Drawing.Color]$TopColor,
        [System.Drawing.Color]$BottomColor,
        [System.Drawing.Color]$StrokeColor,
        [float]$StrokeWidth = 1
    )

    $path = New-RoundedPath -X $X -Y $Y -Width $Width -Height $Height -Radius $Radius
    $gradient = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        ([System.Drawing.PointF]::new($X, $Y)),
        ([System.Drawing.PointF]::new($X, ($Y + $Height))),
        $TopColor,
        $BottomColor
    )
    $Graphics.FillPath($gradient, $path)
    if ($StrokeWidth -gt 0 -and $StrokeColor.A -gt 0) {
        $stroke = New-Object System.Drawing.Pen($StrokeColor, $StrokeWidth)
        $Graphics.DrawPath($stroke, $path)
        $stroke.Dispose()
    }
    $gradient.Dispose()
    $path.Dispose()
}

function Draw-ImageCover {
    param(
        [System.Drawing.Graphics]$Graphics,
        [string]$ImagePath,
        [float]$X,
        [float]$Y,
        [float]$Width,
        [float]$Height,
        [float]$Radius
    )

    $image = [System.Drawing.Image]::FromFile($ImagePath)
    $scale = [Math]::Max($Width / $image.Width, $Height / $image.Height)
    $drawWidth = $image.Width * $scale
    $drawHeight = $image.Height * $scale
    $drawX = $X + (($Width - $drawWidth) / 2)
    $drawY = $Y + (($Height - $drawHeight) / 2)

    $state = $Graphics.Save()
    $path = New-RoundedPath -X $X -Y $Y -Width $Width -Height $Height -Radius $Radius
    $Graphics.SetClip($path)
    $Graphics.DrawImage($image, $drawX, $drawY, $drawWidth, $drawHeight)
    $Graphics.Restore($state)

    $path.Dispose()
    $image.Dispose()
}

function Draw-RightAlignedText {
    param(
        [System.Drawing.Graphics]$Graphics,
        [string]$Text,
        [System.Drawing.Font]$Font,
        [System.Drawing.Brush]$Brush,
        [float]$RightX,
        [float]$Y
    )

    $width = [float](Get-TrackedTextWidth -Graphics $Graphics -Text $Text -Font $Font -Tracking 0)
    $Graphics.DrawString($Text, $Font, $Brush, ($RightX - $width), $Y, $script:MitozzTypographicFormat)
}

function Decode-UnicodeEscapes {
    param([string]$Value)
    return [regex]::Unescape($Value)
}

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$promptPath = Join-Path $workspaceRoot 'prompts/instagram/stories/ig-story-2026-04-10-aging-foundation-support-v01.json'
$outputRoot = Join-Path $workspaceRoot 'output/instagram/stories/2026-04-10-story-aging-foundation-support-v01'
$currentDir = Join-Path $outputRoot 'current'
$sourceDir = Join-Path $outputRoot 'source'

foreach ($dir in @($outputRoot, $currentDir, $sourceDir)) {
    if (-not (Test-Path -LiteralPath $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

$prompt = Get-Content -LiteralPath $promptPath -Raw | ConvertFrom-Json
$frames = $prompt.text_overlay.frames_ja

$tokens = Get-MitozzDesignTokens -Variant $PaletteVariant
$typeTokens = Get-MitozzTypographyTokens
$fontProfileConfig = Get-MitozzFontProfileConfig -Profile $FontProfile

$headlineFamilies = @($fontProfileConfig.headline_families)
$bodyFamilies = @($fontProfileConfig.body_families)
$accentFamilies = @($fontProfileConfig.accent_families)

$metaFont = New-Font -Families $bodyFamilies -Size 34 -Style ([System.Drawing.FontStyle]::Regular)
$headlineFont = New-Font -Families $headlineFamilies -Size 78 -Style ([System.Drawing.FontStyle]::Bold)
$bodyFont = New-Font -Families $bodyFamilies -Size 40 -Style ([System.Drawing.FontStyle]::Regular)
$cardHeadlineFont = New-Font -Families $headlineFamilies -Size 64 -Style ([System.Drawing.FontStyle]::Bold)
$cardBodyFont = New-Font -Families $bodyFamilies -Size 38 -Style ([System.Drawing.FontStyle]::Regular)
$ctaTitleFont = New-Font -Families $headlineFamilies -Size 40 -Style ([System.Drawing.FontStyle]::Bold)
$ctaBodyFont = New-Font -Families $bodyFamilies -Size 33 -Style ([System.Drawing.FontStyle]::Regular)

$textBrush = New-Object System.Drawing.SolidBrush($tokens.Colors.text_primary)
$softTextBrush = New-Object System.Drawing.SolidBrush($tokens.Colors.text_secondary)
$whiteOverlayBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(245, 255, 255, 255))
$warmRuleBrush = New-Object System.Drawing.SolidBrush($tokens.Colors.accent_signal)

$width = 1080
$height = 1920
$radius = 44
$margin = 30
$metaTop = 44
$metaLeft = 54
$metaRight = $width - 54

$frame1Image = Join-Path $sourceDir 'frame-01-plate-nanobanana-v01.jpg'
$frame2Image = Join-Path $sourceDir 'frame-02-plate-nanobanana-v02.jpg'

for ($index = 0; $index -lt 2; $index++) {
    $bitmap = New-Object System.Drawing.Bitmap($width, $height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $graphics.Clear($tokens.Colors.canvas_top)

    if ($index -eq 0) {
        Draw-ImageCover -Graphics $graphics -ImagePath $frame1Image -X $margin -Y $margin -Width ($width - ($margin * 2)) -Height ($height - ($margin * 2)) -Radius $radius
        Draw-RoundedGradientBox -Graphics $graphics -X 34 -Y 34 -Width 724 -Height 860 -Radius 40 -TopColor ([System.Drawing.Color]::FromArgb(230, 255, 255, 255)) -BottomColor ([System.Drawing.Color]::FromArgb(212, 247, 250, 252)) -StrokeColor ([System.Drawing.Color]::FromArgb(0, 0, 0, 0)) -StrokeWidth 0

        $frame = $frames[0]
        $metaLeftText = Decode-UnicodeEscapes $frame.meta_left
        $metaRightText = Decode-UnicodeEscapes $frame.meta_right
        $headlineLines = @($frame.headline_lines | ForEach-Object { Decode-UnicodeEscapes $_ })
        $bodyLines = @($frame.body_lines | ForEach-Object { Decode-UnicodeEscapes $_ })

        $graphics.DrawString($metaLeftText, $metaFont, $softTextBrush, $metaLeft, $metaTop, $script:MitozzTypographicFormat)
        Draw-RightAlignedText -Graphics $graphics -Text $metaRightText -Font $metaFont -Brush $softTextBrush -RightX $metaRight -Y $metaTop
        [void](Draw-TrackedLines -Graphics $graphics -Lines $headlineLines -Font $headlineFont -Brush $textBrush -X 72 -Y 160 -LineHeight 92 -Tracking 0)
        [void](Draw-TrackedLines -Graphics $graphics -Lines $bodyLines -Font $bodyFont -Brush $softTextBrush -X 76 -Y 548 -LineHeight 56 -Tracking 0)
    }
    else {
        Draw-ImageCover -Graphics $graphics -ImagePath $frame2Image -X $margin -Y $margin -Width ($width - ($margin * 2)) -Height ($height - ($margin * 2)) -Radius $radius
        Draw-RoundedGradientBox -Graphics $graphics -X 44 -Y 208 -Width 992 -Height 822 -Radius 44 -TopColor ([System.Drawing.Color]::FromArgb(236, 255, 255, 255)) -BottomColor ([System.Drawing.Color]::FromArgb(216, 245, 249, 251)) -StrokeColor ([System.Drawing.Color]::FromArgb(0, 0, 0, 0)) -StrokeWidth 0
        $ctaBoxX = 112
        $ctaBoxY = 824
        $ctaBoxWidth = 856
        $ctaBoxHeight = 164
        Draw-RoundedGradientBox -Graphics $graphics -X $ctaBoxX -Y $ctaBoxY -Width $ctaBoxWidth -Height $ctaBoxHeight -Radius 34 -TopColor ([System.Drawing.Color]::FromArgb(230, 247, 236, 228)) -BottomColor ([System.Drawing.Color]::FromArgb(222, 241, 232, 223)) -StrokeColor ([System.Drawing.Color]::FromArgb(0, 0, 0, 0)) -StrokeWidth 0

        $frame = $frames[1]
        $metaLeftText = Decode-UnicodeEscapes $frame.meta_left
        $metaRightText = Decode-UnicodeEscapes $frame.meta_right
        $headlineLines = @($frame.headline_lines | ForEach-Object { Decode-UnicodeEscapes $_ })
        $bodyLines = @($frame.body_lines | ForEach-Object { Decode-UnicodeEscapes $_ })
        $ctaTitle = Decode-UnicodeEscapes $frame.cta_title
        $ctaBodyLines = @($frame.cta_body_lines | ForEach-Object { Decode-UnicodeEscapes $_ })

        $graphics.DrawString($metaLeftText, $metaFont, $softTextBrush, $metaLeft, $metaTop, $script:MitozzTypographicFormat)
        Draw-RightAlignedText -Graphics $graphics -Text $metaRightText -Font $metaFont -Brush $softTextBrush -RightX $metaRight -Y $metaTop
        [void](Draw-TrackedLines -Graphics $graphics -Lines $headlineLines -Font $cardHeadlineFont -Brush $textBrush -X ($width / 2) -Y 320 -LineHeight 80 -Tracking 0 -Alignment center)
        $graphics.FillRectangle($warmRuleBrush, 396, 606, 288, 4)
        [void](Draw-TrackedLines -Graphics $graphics -Lines $bodyLines -Font $cardBodyFont -Brush $softTextBrush -X ($width / 2) -Y 684 -LineHeight 52 -Tracking 0 -Alignment center)
        $ctaTitleLineHeight = 44
        $ctaBodyLineHeight = 40
        $ctaGap = 12
        $ctaContentHeight = $ctaTitleLineHeight + ($ctaBodyLineHeight * $ctaBodyLines.Count) + $ctaGap
        $ctaTop = [Math]::Round($ctaBoxY + (($ctaBoxHeight - $ctaContentHeight) / 2))
        [void](Draw-TrackedLines -Graphics $graphics -Lines @($ctaTitle) -Font $ctaTitleFont -Brush $textBrush -X ($width / 2) -Y $ctaTop -LineHeight $ctaTitleLineHeight -Tracking 0 -Alignment center)
        [void](Draw-TrackedLines -Graphics $graphics -Lines $ctaBodyLines -Font $ctaBodyFont -Brush $softTextBrush -X ($width / 2) -Y ($ctaTop + $ctaTitleLineHeight + $ctaGap) -LineHeight $ctaBodyLineHeight -Tracking 0 -Alignment center)
    }

    $outputPath = Join-Path $currentDir ('frame-{0:D2}.png' -f ($index + 1))
    $bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bitmap.Dispose()
}

$metaFont.Dispose()
$headlineFont.Dispose()
$bodyFont.Dispose()
$cardHeadlineFont.Dispose()
$cardBodyFont.Dispose()
$ctaTitleFont.Dispose()
$ctaBodyFont.Dispose()
$textBrush.Dispose()
$softTextBrush.Dispose()
$whiteOverlayBrush.Dispose()
$warmRuleBrush.Dispose()
