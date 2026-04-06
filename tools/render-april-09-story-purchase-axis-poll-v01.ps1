param(
    [ValidateSet('default', 'cool_focus', 'warm_editorial')]
    [string]$PaletteVariant = 'warm_editorial',
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
    $stroke = New-Object System.Drawing.Pen($StrokeColor, $StrokeWidth)
    $Graphics.FillPath($gradient, $path)
    $Graphics.DrawPath($stroke, $path)
    $gradient.Dispose()
    $stroke.Dispose()
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

    return $currentY
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

function Draw-RightAlignedText {
    param(
        [System.Drawing.Graphics]$Graphics,
        [string]$Text,
        [System.Drawing.Font]$Font,
        [System.Drawing.Brush]$Brush,
        [float]$RightX,
        [float]$Y
    )

    $format = New-Object System.Drawing.StringFormat
    $format.Alignment = [System.Drawing.StringAlignment]::Near
    $format.LineAlignment = [System.Drawing.StringAlignment]::Near
    $size = $Graphics.MeasureString($Text, $Font, 1000, $format)
    $Graphics.DrawString($Text, $Font, $Brush, ($RightX - $size.Width), $Y, $format)
    $format.Dispose()
}

function Decode-UnicodeEscapes {
    param([string]$Value)
    return [regex]::Unescape($Value)
}

function Get-CenteredStackTop {
    param(
        [float]$ContainerY,
        [float]$ContainerHeight,
        [float]$ContentHeight
    )

    return [float]($ContainerY + (($ContainerHeight - $ContentHeight) / 2))
}

function Draw-StoryCardBase {
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
}

$designTokens = Get-MitozzDesignTokens -Variant $PaletteVariant
$typography = Get-MitozzTypographyTokens
$fontProfileConfig = Get-MitozzFontProfileConfig -Profile $FontProfile
$tokenColors = $designTokens.Colors

$roles = $typography.roles
$headlineFamilies = [string[]]$fontProfileConfig.headline_families
$bodyFamilies = [string[]]$fontProfileConfig.body_families

$metaFont = New-Font -Families $bodyFamilies -Size ([float]$roles.meta.font_size) -Style ([System.Drawing.FontStyle]::Bold)
$headlineLarge = New-Font -Families $headlineFamilies -Size 74 -Style ([System.Drawing.FontStyle]::Bold)
$headlineMedium = New-Font -Families $headlineFamilies -Size 66 -Style ([System.Drawing.FontStyle]::Bold)
$bodyFont = New-Font -Families $bodyFamilies -Size ([float]$roles.cover_subline.font_size) -Style ([System.Drawing.FontStyle]::Regular)
$bodySmall = New-Font -Families $bodyFamilies -Size 28 -Style ([System.Drawing.FontStyle]::Regular)
$labelFont = New-Font -Families $bodyFamilies -Size 26 -Style ([System.Drawing.FontStyle]::Bold)
$cardTitleFont = New-Font -Families $bodyFamilies -Size 30 -Style ([System.Drawing.FontStyle]::Bold)
$cardBodyFont = New-Font -Families $bodyFamilies -Size 25 -Style ([System.Drawing.FontStyle]::Regular)

$canvasTop = $tokenColors.canvas_top
$canvasBottom = $tokenColors.canvas_bottom
$cardWhite = $tokenColors.card
$headerWash = $tokenColors.header_wash
$charcoal = $tokenColors.text_primary
$softCharcoal = $tokenColors.text_secondary
$mistBlue = $tokenColors.structure
$mistBlueSoft = $tokenColors.atmosphere
$mistBlueLine = $tokenColors.structure_line
$apricot = $tokenColors.accent_soft
$white = $tokenColors.card
$coolPanelTop = [System.Drawing.Color]::FromArgb(255, 232, 241, 247)
$coolPanelBottom = [System.Drawing.Color]::FromArgb(255, 216, 230, 239)
$coolPanelStroke = [System.Drawing.Color]::FromArgb(255, 198, 213, 222)
$glassPanelTop = [System.Drawing.Color]::FromArgb(244, 250, 252, 253)
$glassPanelBottom = [System.Drawing.Color]::FromArgb(236, 235, 243, 248)
$glassPanelStroke = [System.Drawing.Color]::FromArgb(214, 207, 218, 226)
$warmPanelTop = [System.Drawing.Color]::FromArgb(255, 242, 237, 233)
$warmPanelBottom = [System.Drawing.Color]::FromArgb(255, 233, 226, 219)
$warmPanelStroke = [System.Drawing.Color]::FromArgb(255, 217, 208, 200)

$textBrush = New-Object System.Drawing.SolidBrush($charcoal)
$softBrush = New-Object System.Drawing.SolidBrush($softCharcoal)
$blueBrush = New-Object System.Drawing.SolidBrush($mistBlue)
$whiteBrush = New-Object System.Drawing.SolidBrush($white)
$rulePen = New-Object System.Drawing.Pen($mistBlueLine, 2)
$accentPen = New-Object System.Drawing.Pen($apricot, 4)

$width = 1080
$height = 1920
$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$storyRoot = Join-Path $workspaceRoot "output/instagram/stories/2026-04-09-story-purchase-axis-poll-v01"
$productionDir = Join-Path $storyRoot "production"
$currentDir = Join-Path $storyRoot "current"
$sourceImage = Join-Path $storyRoot "source/frame-01-plate-nanobanana-v01.jpg"
$metaRightX = [float]($width - 58)
foreach ($path in @($productionDir, $currentDir)) {
    if (-not (Test-Path -LiteralPath $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }
}

$frames = @(
    @{
        File = "frame-01.png"
        LeftMeta = Decode-UnicodeEscapes "\u8cfc\u5165\u524d\u306e\u8996\u70b9"
        RightMeta = Decode-UnicodeEscapes "\u8efd\u3044\u30a2\u30f3\u30b1\u30fc\u30c8"
        Headline = @(
            (Decode-UnicodeEscapes "\u8cfc\u5165\u524d\u306b\u6c17\u306b\u306a\u308b\u306e\u306f\u3001"),
            (Decode-UnicodeEscapes "\u6210\u5206\u3067\u3059\u304b\u3002"),
            (Decode-UnicodeEscapes "\u30d6\u30e9\u30f3\u30c9\u3067\u3059\u304b\u3002")
        )
        Body = @(
            (Decode-UnicodeEscapes "\u307e\u305a\u76ee\u304c\u5411\u304f\u307b\u3046\u3092\u3001"),
            (Decode-UnicodeEscapes "\u6c17\u8efd\u306b\u9078\u3093\u3067\u307f\u3066\u304f\u3060\u3055\u3044\u3002")
        )
        Type = "cover"
    },
    @{
        File = "frame-02.png"
        LeftMeta = Decode-UnicodeEscapes "\u4eca\u65e5\u306e\u8cea\u554f"
        RightMeta = Decode-UnicodeEscapes "\u6295\u7968\u3057\u3066\u304f\u3060\u3055\u3044"
        Headline = @(
            (Decode-UnicodeEscapes "\u6700\u521d\u306b\u5b89\u5fc3\u611f\u3092\u6301\u3064\u306e\u306f"),
            (Decode-UnicodeEscapes "\u3069\u3061\u3089\u306b\u8fd1\u3044\u3067\u3059\u304b\u3002")
        )
        Body = @(
            (Decode-UnicodeEscapes "\u307e\u305a\u306f\u8fd1\u3044\u307b\u3046\u3092"),
            (Decode-UnicodeEscapes "\u6c17\u8efd\u306b\u9078\u3093\u3067\u307f\u3066\u304f\u3060\u3055\u3044\u3002")
        )
        Type = "body"
    }
)

foreach ($frame in $frames) {
    $bitmap = New-Object System.Drawing.Bitmap($width, $height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    if ($frame.Type -eq "cover") {
        $graphics.Clear($canvasTop)

        Draw-ImageCover -Graphics $graphics -ImagePath $sourceImage -X 18 -Y 18 -Width ($width - 36) -Height ($height - 36) -Radius 48
        $path = New-RoundedPath -X 18 -Y 18 -Width ($width - 36) -Height ($height - 36) -Radius 48
        $stroke = New-Object System.Drawing.Pen($mistBlueLine, 1)
        $graphics.DrawPath($stroke, $path)
        $stroke.Dispose()
        $path.Dispose()

        $overlayBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
            ([System.Drawing.Point]::new(0, 0)),
            ([System.Drawing.Point]::new(760, 0)),
            ([System.Drawing.Color]::FromArgb(220, 247, 250, 252)),
            ([System.Drawing.Color]::FromArgb(70, 247, 250, 252))
        )
        $graphics.FillRectangle($overlayBrush, 18, 18, 760, $height - 36)
        $overlayBrush.Dispose()

        $topWash = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(72, 255, 255, 255))
        $graphics.FillRectangle($topWash, 18, 18, $width - 36, 120)
        $topWash.Dispose()

        $graphics.DrawString([string]$frame.LeftMeta, $metaFont, $blueBrush, 58, 48)
        Draw-RightAlignedText -Graphics $graphics -Text ([string]$frame.RightMeta) -Font $metaFont -Brush $blueBrush -RightX $metaRightX -Y 48

        $headlineBottom = Draw-TrackedLines -Graphics $graphics -Lines $frame.Headline -Font $headlineLarge -Brush $textBrush -X 72 -Y 216 -LineHeight 112 -Tracking 0.15
        [void](Draw-Lines -Graphics $graphics -Lines $frame.Body -Font $bodyFont -Brush $softBrush -X 82 -Y ($headlineBottom + 30) -LineHeight 52)

        $coverBandY = 1296
        $coverBandHeight = 162
        Draw-RoundedGradientBox -Graphics $graphics -X 54 -Y $coverBandY -Width 972 -Height $coverBandHeight -Radius 30 `
            -TopColor $glassPanelTop -BottomColor $glassPanelBottom -StrokeColor $glassPanelStroke -StrokeWidth 1

        $labels = @(
            (Decode-UnicodeEscapes "\u6210\u5206"),
            (Decode-UnicodeEscapes "\u8996\u70b9"),
            (Decode-UnicodeEscapes "\u59ff\u52e2")
        )
        $values = @(
            (Decode-UnicodeEscapes "\u4f55\u304c\u5165\u3063\u3066\u3044\u308b\u304b"),
            (Decode-UnicodeEscapes "\u3069\u3053\u3092\u898b\u3066\u9078\u3076\u304b"),
            (Decode-UnicodeEscapes "\u3069\u3046\u5c4a\u3051\u7d9a\u3051\u308b\u304b")
        )
        $columnWidth = 972 / 3
        $labelHeight = 34
        $labelValueGap = 16
        $valueHeight = 40
        $columnContentTop = Get-CenteredStackTop -ContainerY $coverBandY -ContainerHeight $coverBandHeight -ContentHeight ($labelHeight + $labelValueGap + $valueHeight)
        for ($i = 0; $i -lt 3; $i += 1) {
            $columnLeft = 54 + ($columnWidth * $i)
            if ($i -gt 0) {
                $separatorX = $columnLeft
                $graphics.DrawLine($rulePen, $separatorX, ($coverBandY + 24), $separatorX, ($coverBandY + $coverBandHeight - 24))
            }
            Draw-CenteredParagraph -Graphics $graphics -Text $labels[$i] -Font $labelFont -Brush $blueBrush -X $columnLeft -Y $columnContentTop -Width $columnWidth -Height $labelHeight
            Draw-CenteredParagraph -Graphics $graphics -Text $values[$i] -Font $cardBodyFont -Brush $textBrush -X $columnLeft -Y ($columnContentTop + $labelHeight + $labelValueGap) -Width $columnWidth -Height $valueHeight
        }
    }
    elseif ($frame.Type -eq "body") {
        Draw-StoryCardBase -Graphics $graphics -Width $width -Height $height
        $graphics.DrawString([string]$frame.LeftMeta, $metaFont, $blueBrush, 58, 48)
        Draw-RightAlignedText -Graphics $graphics -Text ([string]$frame.RightMeta) -Font $metaFont -Brush $blueBrush -RightX $metaRightX -Y 48

        $headlineBottom = Draw-TrackedLines -Graphics $graphics -Lines $frame.Headline -Font $headlineMedium -Brush $textBrush -X 78 -Y 220 -LineHeight 98 -Tracking 0.15
        [void](Draw-Lines -Graphics $graphics -Lines $frame.Body -Font $bodyFont -Brush $softBrush -X 84 -Y ($headlineBottom + 28) -LineHeight 50)

        $pollZoneY = 930
        $pollZoneHeight = 470
        Draw-RoundedGradientBox -Graphics $graphics -X 104 -Y $pollZoneY -Width 872 -Height $pollZoneHeight -Radius 36 `
            -TopColor ([System.Drawing.Color]::FromArgb(140, 236, 243, 247)) -BottomColor ([System.Drawing.Color]::FromArgb(92, 228, 238, 244)) -StrokeColor $coolPanelStroke -StrokeWidth 1

        $pollHintY = 858
        Draw-CenteredParagraph -Graphics $graphics -Text (Decode-UnicodeEscapes "\u6295\u7968\u30b9\u30c6\u30a3\u30c3\u30ab\u30fc\u3067\u9078\u3093\u3067\u307f\u3066\u304f\u3060\u3055\u3044\u3002") -Font $bodySmall -Brush $softBrush -X 164 -Y $pollHintY -Width 752 -Height 42

        $optionStripY = 1428
        Draw-RoundedGradientBox -Graphics $graphics -X 138 -Y $optionStripY -Width 804 -Height 92 -Radius 24 `
            -TopColor ([System.Drawing.Color]::FromArgb(255, 244, 248, 250)) -BottomColor ([System.Drawing.Color]::FromArgb(255, 236, 243, 247)) -StrokeColor $mistBlueLine -StrokeWidth 1
        $stripLabels = @(
            (Decode-UnicodeEscapes "\u6210\u5206\u3092\u898b\u308b"),
            (Decode-UnicodeEscapes "\u30d6\u30e9\u30f3\u30c9\u59ff\u52e2\u3092\u898b\u308b")
        )
        $stripWidth = 804 / 2
        for ($i = 0; $i -lt 2; $i += 1) {
            $columnLeft = 138 + ($stripWidth * $i)
            if ($i -gt 0) {
                $graphics.DrawLine($rulePen, $columnLeft, ($optionStripY + 18), $columnLeft, ($optionStripY + 74))
            }
            Draw-CenteredParagraph -Graphics $graphics -Text $stripLabels[$i] -Font $labelFont -Brush $blueBrush -X $columnLeft -Y ($optionStripY + 1) -Width $stripWidth -Height 90
        }

        $routeCardY = 1570
        Draw-RoundedGradientBox -Graphics $graphics -X 84 -Y $routeCardY -Width 912 -Height 182 -Radius 32 `
            -TopColor $warmPanelTop -BottomColor $warmPanelBottom -StrokeColor $warmPanelStroke -StrokeWidth 1
        $routeTitleHeight = 40
        $routeRuleGapTop = 24
        $routeRuleGapBottom = 22
        $routeBodyHeight = 58
        $routeContentTop = Get-CenteredStackTop -ContainerY $routeCardY -ContainerHeight 182 -ContentHeight ($routeTitleHeight + $routeRuleGapTop + $routeRuleGapBottom + $routeBodyHeight)
        $routeTitleY = $routeContentTop
        $routeRuleY = $routeTitleY + $routeTitleHeight + $routeRuleGapTop
        $routeBodyY = $routeRuleY + $routeRuleGapBottom
        Draw-CenteredParagraph -Graphics $graphics -Text (Decode-UnicodeEscapes "\u4eca\u65e5\u306e\u6295\u7a3f\u3092\u898b\u308b") -Font $cardTitleFont -Brush $textBrush -X 126 -Y $routeTitleY -Width 828 -Height $routeTitleHeight
        $graphics.DrawLine($accentPen, 404, $routeRuleY, 676, $routeRuleY)
        Draw-CenteredParagraph -Graphics $graphics -Text (Decode-UnicodeEscapes "\u4fe1\u983c\u306e\u898b\u65b9\u3092\u3001`n\u3084\u3055\u3057\u304f\u6574\u7406\u3057\u3066\u3044\u307e\u3059\u3002") -Font $cardBodyFont -Brush $softBrush -X 136 -Y $routeBodyY -Width 808 -Height $routeBodyHeight
    }

    $prodPath = Join-Path $productionDir $frame.File
    $currentPath = Join-Path $currentDir $frame.File
    $bitmap.Save($prodPath, [System.Drawing.Imaging.ImageFormat]::Png)
    Copy-Item -LiteralPath $prodPath -Destination $currentPath -Force

    $graphics.Dispose()
    $bitmap.Dispose()
}

$textBrush.Dispose()
$softBrush.Dispose()
$blueBrush.Dispose()
$whiteBrush.Dispose()
$rulePen.Dispose()
$accentPen.Dispose()

$metaFont.Dispose()
$headlineLarge.Dispose()
$headlineMedium.Dispose()
$bodyFont.Dispose()
$bodySmall.Dispose()
$labelFont.Dispose()
$cardTitleFont.Dispose()
$cardBodyFont.Dispose()

Write-Output "Rendered April 9 purchase-axis poll story to $storyRoot"

