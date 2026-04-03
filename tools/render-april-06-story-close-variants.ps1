param(
    [ValidateSet('default', 'cool_focus', 'warm_editorial')]
    [string]$PaletteVariant = 'cool_focus',
    [ValidateSet('mitozz_sans', 'humanist_sans', 'editorial_serif')]
    [string]$FontProfile = 'humanist_sans'
)

Add-Type -AssemblyName System.Drawing

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

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

    throw "Unable to create font."
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

function Draw-RoundedBox {
    param(
        [System.Drawing.Graphics]$Graphics,
        [float]$X,
        [float]$Y,
        [float]$Width,
        [float]$Height,
        [float]$Radius,
        [System.Drawing.Color]$FillColor,
        [System.Drawing.Color]$StrokeColor,
        [float]$StrokeWidth = 1
    )

    $path = New-RoundedPath -X $X -Y $Y -Width $Width -Height $Height -Radius $Radius
    $fill = New-Object System.Drawing.SolidBrush($FillColor)
    $stroke = New-Object System.Drawing.Pen($StrokeColor, $StrokeWidth)
    $Graphics.FillPath($fill, $path)
    $Graphics.DrawPath($stroke, $path)
    $fill.Dispose()
    $stroke.Dispose()
    $path.Dispose()
}

function Draw-TrackedLine {
    param(
        [System.Drawing.Graphics]$Graphics,
        [string]$Text,
        [System.Drawing.Font]$Font,
        [System.Drawing.Brush]$Brush,
        [float]$X,
        [float]$Y,
        [float]$Tracking = 0
    )

    $format = [System.Drawing.StringFormat]::GenericTypographic
    $enumerator = [System.Globalization.StringInfo]::GetTextElementEnumerator($Text)
    $currentX = $X

    while ($enumerator.MoveNext()) {
        $element = $enumerator.GetTextElement()
        $Graphics.DrawString($element, $Font, $Brush, $currentX, $Y, $format)
        $size = $Graphics.MeasureString($element, $Font, 2000, $format)
        $currentX += $size.Width + $Tracking
    }

    return $currentX
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
        [float]$Tracking = 0
    )

    $currentY = $Y
    foreach ($line in $Lines) {
        [void](Draw-TrackedLine -Graphics $Graphics -Text $line -Font $Font -Brush $Brush -X $X -Y $currentY -Tracking $Tracking)
        $currentY += $LineHeight
    }

    return $currentY
}

function Draw-Lines {
    param(
        [System.Drawing.Graphics]$Graphics,
        [string[]]$Lines,
        [System.Drawing.Font]$Font,
        [System.Drawing.Brush]$Brush,
        [float]$X,
        [float]$Y,
        [float]$LineHeight
    )

    $currentY = $Y
    foreach ($line in $Lines) {
        $Graphics.DrawString($line, $Font, $Brush, $X, $currentY)
        $currentY += $LineHeight
    }
}

function Draw-CenteredParagraph {
    param(
        [System.Drawing.Graphics]$Graphics,
        [string]$Text,
        [System.Drawing.Font]$Font,
        [System.Drawing.Brush]$Brush,
        [float]$X,
        [float]$Y,
        [float]$Width,
        [float]$Height
    )

    $format = New-Object System.Drawing.StringFormat
    $format.Alignment = [System.Drawing.StringAlignment]::Center
    $format.LineAlignment = [System.Drawing.StringAlignment]::Center
    $rect = New-Object System.Drawing.RectangleF($X, $Y, $Width, $Height)
    $Graphics.DrawString($Text, $Font, $Brush, $rect, $format)
    $format.Dispose()
}

function Draw-Paragraph {
    param(
        [System.Drawing.Graphics]$Graphics,
        [string]$Text,
        [System.Drawing.Font]$Font,
        [System.Drawing.Brush]$Brush,
        [float]$X,
        [float]$Y,
        [float]$Width,
        [float]$Height
    )

    $format = New-Object System.Drawing.StringFormat
    $format.Alignment = [System.Drawing.StringAlignment]::Near
    $format.LineAlignment = [System.Drawing.StringAlignment]::Near
    $rect = New-Object System.Drawing.RectangleF($X, $Y, $Width, $Height)
    $Graphics.DrawString($Text, $Font, $Brush, $rect, $format)
    $format.Dispose()
}

function Decode-UnicodeEscapes {
    param([string]$Value)
    return [regex]::Unescape($Value)
}

function Draw-BaseFrame {
    param(
        [System.Drawing.Graphics]$Graphics,
        [int]$Width,
        [int]$Height
    )

    $Graphics.Clear($canvasTop)

    $backgroundBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        ([System.Drawing.Point]::new(0, 0)),
        ([System.Drawing.Point]::new(0, $Height)),
        $canvasTop,
        $canvasBottom
    )
    $Graphics.FillRectangle($backgroundBrush, 0, 0, $Width, $Height)
    $backgroundBrush.Dispose()

    Draw-RoundedBox -Graphics $Graphics -X 18 -Y 18 -Width ($Width - 36) -Height ($Height - 36) -Radius 48 `
        -FillColor $cardWhite `
        -StrokeColor $mistBlueLine `
        -StrokeWidth 1

    $headerBrush = New-Object System.Drawing.SolidBrush($headerWash)
    $Graphics.FillRectangle($headerBrush, 18, 18, $Width - 36, 124)
    $headerBrush.Dispose()

    $Graphics.DrawString($metaLeft, $metaFont, $blueBrush, 58, 48)
    $Graphics.DrawString($metaRight, $metaFont, $blueBrush, 836, 48)

    $headlineBottom = Draw-TrackedLines -Graphics $Graphics -Lines $headlineLines -Font $headlineFont -Brush $textBrush -X 78 -Y 236 -LineHeight 98 -Tracking 0.3
    Draw-Lines -Graphics $Graphics -Lines $bodyLines -Font $bodyFont -Brush $softBrush -X 84 -Y ($headlineBottom + 20) -LineHeight 50
}

function Draw-Pill {
    param(
        [System.Drawing.Graphics]$Graphics,
        [float]$X,
        [float]$Y,
        [float]$Width,
        [float]$Height,
        [string]$Text
    )

    Draw-RoundedBox -Graphics $Graphics -X $X -Y $Y -Width $Width -Height $Height -Radius 20 `
        -FillColor $paper `
        -StrokeColor $mistBlueLine -StrokeWidth 1
    Draw-CenteredParagraph -Graphics $Graphics -Text $Text -Font $pillFont -Brush $blueBrush -X $X -Y $Y -Width $Width -Height $Height
}

function Draw-VariantA {
    param([System.Drawing.Graphics]$Graphics)

    Draw-Pill -Graphics $Graphics -X 120 -Y 884 -Width 196 -Height 58 -Text $stripLabels[0]
    Draw-Pill -Graphics $Graphics -X 442 -Y 884 -Width 196 -Height 58 -Text $stripLabels[1]
    Draw-Pill -Graphics $Graphics -X 764 -Y 884 -Width 196 -Height 58 -Text $stripLabels[2]

    Draw-RoundedBox -Graphics $Graphics -X 74 -Y 1050 -Width 932 -Height 402 -Radius 38 `
        -FillColor $mistBlueSoft -StrokeColor $mistBlueLine -StrokeWidth 1
    Draw-RoundedBox -Graphics $Graphics -X 126 -Y 1112 -Width 828 -Height 246 -Radius 30 `
        -FillColor $cardWhite -StrokeColor $mistBlueLine -StrokeWidth 1
    Draw-Pill -Graphics $Graphics -X 164 -Y 1148 -Width 186 -Height 52 -Text (Decode-UnicodeEscapes "\u4eca\u65e5\u306e\u6295\u7a3f\u3078")
    Draw-Paragraph -Graphics $Graphics -Text $closeTitle -Font $cardTitleFont -Brush $textBrush -X 166 -Y 1228 -Width 620 -Height 46
    $Graphics.DrawLine($accentPen, 168, 1298, 430, 1298)
    Draw-Paragraph -Graphics $Graphics -Text $closeBodyTwoLine -Font $cardBodyFont -Brush $softBrush -X 166 -Y 1326 -Width 612 -Height 80
}

function Draw-VariantB {
    param([System.Drawing.Graphics]$Graphics)

    $Graphics.DrawLine($rulePen, 160, 912, 920, 912)
    Draw-CenteredParagraph -Graphics $Graphics -Text (Decode-UnicodeEscapes "\u6574\u3048\u308b \u30fb \u3064\u306a\u3052\u308b \u30fb \u898b\u76f4\u3059") -Font $pillFont -Brush $blueBrush -X 210 -Y 878 -Width 660 -Height 52

    Draw-RoundedBox -Graphics $Graphics -X 84 -Y 1040 -Width 912 -Height 348 -Radius 36 `
        -FillColor $paper -StrokeColor $mistBlueLine -StrokeWidth 1
    Draw-RoundedBox -Graphics $Graphics -X 84 -Y 1040 -Width 188 -Height 348 -Radius 36 `
        -FillColor $mistBlueSoft -StrokeColor $mistBlueLine -StrokeWidth 1
    Draw-CenteredParagraph -Graphics $Graphics -Text (Decode-UnicodeEscapes "\u4eca\u65e5\u306e`n\u6295\u7a3f\u3078") -Font $pillFont -Brush $blueBrush -X 98 -Y 1154 -Width 160 -Height 96
    Draw-Paragraph -Graphics $Graphics -Text $closeTitle -Font $cardTitleFont -Brush $textBrush -X 322 -Y 1130 -Width 520 -Height 46
    $Graphics.DrawLine($accentPen, 324, 1202, 594, 1202)
    Draw-Paragraph -Graphics $Graphics -Text $closeBodyTwoLine -Font $cardBodyFont -Brush $softBrush -X 322 -Y 1242 -Width 516 -Height 82
}

function Draw-VariantC {
    param([System.Drawing.Graphics]$Graphics)

    if (Test-Path -LiteralPath $sourceImage) {
        $image = [System.Drawing.Image]::FromFile($sourceImage)
        try {
            $scale = [Math]::Max(1080 / $image.Width, 760 / $image.Height)
            $drawWidth = $image.Width * $scale
            $drawHeight = $image.Height * $scale
            $drawX = (1080 - $drawWidth) / 2
            $drawY = 980
            $Graphics.DrawImage($image, $drawX, $drawY, $drawWidth, $drawHeight)
        }
        finally {
            $image.Dispose()
        }

        $washBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(218, 247, 250, 252))
        $Graphics.FillRectangle($washBrush, 18, 980, 1044, 920)
        $washBrush.Dispose()
    }

    Draw-RoundedBox -Graphics $Graphics -X 176 -Y 1004 -Width 728 -Height 70 -Radius 24 `
        -FillColor ([System.Drawing.Color]::FromArgb(238, $cardWhite.R, $cardWhite.G, $cardWhite.B)) `
        -StrokeColor $mistBlueLine -StrokeWidth 1
    Draw-CenteredParagraph -Graphics $Graphics -Text (Decode-UnicodeEscapes "\u6574\u3048\u308b    \u3064\u306a\u3052\u308b    \u898b\u76f4\u3059") -Font $pillFont -Brush $blueBrush -X 176 -Y 1004 -Width 728 -Height 70

    Draw-RoundedBox -Graphics $Graphics -X 122 -Y 1132 -Width 836 -Height 286 -Radius 34 `
        -FillColor ([System.Drawing.Color]::FromArgb(236, 255, 255, 255)) `
        -StrokeColor $mistBlueLine -StrokeWidth 1
    Draw-CenteredParagraph -Graphics $Graphics -Text $closeTitle -Font $cardTitleFont -Brush $textBrush -X 170 -Y 1210 -Width 740 -Height 42
    $Graphics.DrawLine($accentPen, 410, 1290, 670, 1290)
    Draw-CenteredParagraph -Graphics $Graphics -Text $closeBodyTwoLine -Font $cardBodyFont -Brush $softBrush -X 188 -Y 1320 -Width 704 -Height 78
}

$designTokens = Get-MitozzDesignTokens -Variant $PaletteVariant
$typography = Get-MitozzTypographyTokens
$fontProfileConfig = Get-MitozzFontProfileConfig -Profile $FontProfile
$roles = $typography.roles
$tokenColors = $designTokens.Colors
$headlineFamilies = [string[]]$fontProfileConfig.headline_families
$bodyFamilies = [string[]]$fontProfileConfig.body_families

$canvasTop = $tokenColors.canvas_top
$canvasBottom = $tokenColors.canvas_bottom
$cardWhite = $tokenColors.card
$paper = $tokenColors.paper
$headerWash = $tokenColors.header_wash
$charcoal = $tokenColors.text_primary
$softCharcoal = $tokenColors.text_secondary
$mistBlue = $tokenColors.structure
$mistBlueSoft = $tokenColors.atmosphere
$mistBlueLine = $tokenColors.structure_line
$apricot = $tokenColors.accent_soft

$metaFont = New-Font -Families $bodyFamilies -Size ([float]$roles.meta.font_size) -Style ([System.Drawing.FontStyle]::Bold)
$headlineFont = New-Font -Families $headlineFamilies -Size 66 -Style ([System.Drawing.FontStyle]::Bold)
$bodyFont = New-Font -Families $bodyFamilies -Size ([float]$roles.cover_subline.font_size) -Style ([System.Drawing.FontStyle]::Regular)
$pillFont = New-Font -Families $bodyFamilies -Size 24 -Style ([System.Drawing.FontStyle]::Bold)
$cardTitleFont = New-Font -Families $headlineFamilies -Size 30 -Style ([System.Drawing.FontStyle]::Bold)
$cardBodyFont = New-Font -Families $bodyFamilies -Size 24 -Style ([System.Drawing.FontStyle]::Regular)

$textBrush = New-Object System.Drawing.SolidBrush($charcoal)
$softBrush = New-Object System.Drawing.SolidBrush($softCharcoal)
$blueBrush = New-Object System.Drawing.SolidBrush($mistBlue)
$rulePen = New-Object System.Drawing.Pen($mistBlueLine, 2)
$accentPen = New-Object System.Drawing.Pen($apricot, 4)

$metaLeft = Decode-UnicodeEscapes "\u4fdd\u5b58\u7248"
$metaRight = Decode-UnicodeEscapes "\u4eca\u65e5\u306e\u6295\u7a3f\u3078"
$headlineLines = @(
    (Decode-UnicodeEscapes "\u4eca\u65e5\u306e\u6295\u7a3f\u3067"),
    (Decode-UnicodeEscapes "\u898b\u65b9\u3092\u3084\u3055\u3057\u304f"),
    (Decode-UnicodeEscapes "\u6574\u7406\u3057\u3066\u3044\u307e\u3059\u3002")
)
$bodyLines = @(
    (Decode-UnicodeEscapes "\u8a00\u8449\u3060\u3051\u3067\u7d42\u308f\u3089\u305b\u305a\u3001"),
    (Decode-UnicodeEscapes "\u6bce\u65e5\u306e\u6761\u4ef6\u306b\u623b\u3057\u3066\u8003\u3048\u308b\u3002")
)
$stripLabels = @(
    (Decode-UnicodeEscapes "\u6574\u3048\u308b"),
    (Decode-UnicodeEscapes "\u3064\u306a\u3052\u308b"),
    (Decode-UnicodeEscapes "\u898b\u76f4\u3059")
)
$closeTitle = Decode-UnicodeEscapes "\u30d5\u30a3\u30fc\u30c9\u3067\u5168\u4f53\u3092\u898b\u308b"
$closeBodyTwoLine = Decode-UnicodeEscapes "\u30df\u30c8\u30b3\u30f3\u30c9\u30ea\u30a2\u3092\u652f\u3048\u308b\u610f\u5473\u3092`n\u65e5\u5e38\u306e\u8a00\u8449\u3067\u898b\u76f4\u3059\u3002"

$width = 1080
$height = 1920
$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$outputDir = Join-Path $workspaceRoot "output/_tmp/april-06-story-close-variants"
$sourceImage = Join-Path $workspaceRoot "output/instagram/stories/2026-04-06-story-supporting-mitochondria-mini-guide-v01/source/frame-01-plate-nanobanana-v01.jpg"
if (-not (Test-Path -LiteralPath $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

$variants = @(
    @{ File = 'variant-a-editorial-inset.png'; Draw = { param($g) Draw-VariantA -Graphics $g } },
    @{ File = 'variant-b-split-rail.png'; Draw = { param($g) Draw-VariantB -Graphics $g } },
    @{ File = 'variant-c-image-glass.png'; Draw = { param($g) Draw-VariantC -Graphics $g } }
)

foreach ($variant in $variants) {
    $bitmap = New-Object System.Drawing.Bitmap($width, $height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    Draw-BaseFrame -Graphics $graphics -Width $width -Height $height
    & $variant.Draw $graphics

    $outputPath = Join-Path $outputDir $variant.File
    $bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bitmap.Dispose()
}

$textBrush.Dispose()
$softBrush.Dispose()
$blueBrush.Dispose()
$rulePen.Dispose()
$accentPen.Dispose()

$metaFont.Dispose()
$headlineFont.Dispose()
$bodyFont.Dispose()
$pillFont.Dispose()
$cardTitleFont.Dispose()
$cardBodyFont.Dispose()

Write-Output "Rendered April 6 Story close variants to $outputDir"

