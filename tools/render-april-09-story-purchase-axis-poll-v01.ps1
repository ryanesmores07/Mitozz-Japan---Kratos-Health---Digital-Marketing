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

$metaFont = New-Font -Families $bodyFamilies -Size 22 -Style ([System.Drawing.FontStyle]::Bold)
$headlineLarge = New-Font -Families $headlineFamilies -Size 82 -Style ([System.Drawing.FontStyle]::Bold)
$headlineMedium = New-Font -Families $headlineFamilies -Size 74 -Style ([System.Drawing.FontStyle]::Bold)
$bodyFont = New-Font -Families $bodyFamilies -Size 34 -Style ([System.Drawing.FontStyle]::Regular)
$bodySmall = New-Font -Families $bodyFamilies -Size 30 -Style ([System.Drawing.FontStyle]::Regular)
$labelFont = New-Font -Families $bodyFamilies -Size 26 -Style ([System.Drawing.FontStyle]::Bold)
$cardTitleFont = New-Font -Families $bodyFamilies -Size 34 -Style ([System.Drawing.FontStyle]::Bold)
$cardBodyFont = New-Font -Families $bodyFamilies -Size 28 -Style ([System.Drawing.FontStyle]::Regular)

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
$sourceImageFrame01 = Join-Path $storyRoot "source/frame-01-plate-nanobanana-v03.jpg"
$sourceImageFrame02 = Join-Path $storyRoot "source/frame-02-plate-nanobanana-v01.jpg"
$metaRightX = [float]($width - 58)
foreach ($path in @($productionDir, $currentDir)) {
    if (-not (Test-Path -LiteralPath $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }
}

$frames = @(
    @{
        File = "frame-01.png"
        LeftMeta = Decode-UnicodeEscapes "\u4fe1\u983c\u306e\u5165\u53e3"
        RightMeta = Decode-UnicodeEscapes "1\u554f\u3060\u3051"
        Headline = @(
            (Decode-UnicodeEscapes "\u8cfc\u5165\u524d\u306b\u6c17\u306b\u306a\u308b\u306e\u306f\u3001"),
            (Decode-UnicodeEscapes "\u6210\u5206\u3067\u3059\u304b\u3002"),
            (Decode-UnicodeEscapes "\u30d6\u30e9\u30f3\u30c9\u3067\u3059\u304b\u3002")
        )
        Body = @(
            (Decode-UnicodeEscapes "\u307e\u305a\u8fd1\u3044\u307b\u3046\u3092\u3001"),
            (Decode-UnicodeEscapes "\u6c17\u8efd\u306b\u9078\u3093\u3067\u307f\u3066\u304f\u3060\u3055\u3044\u3002")
        )
        Type = "cover"
    },
    @{
        File = "frame-02.png"
        LeftMeta = Decode-UnicodeEscapes "\u4eca\u65e5\u306e\u8cea\u554f"
        RightMeta = Decode-UnicodeEscapes "\u6295\u7968"
        Headline = @(
            (Decode-UnicodeEscapes "\u8cfc\u5165\u524d\u306b\u307e\u305a\u898b\u308b\u306e\u306f"),
            (Decode-UnicodeEscapes "\u3069\u3061\u3089\u3067\u3059\u304b\u3002")
        )
        Body = @(
            (Decode-UnicodeEscapes "\u8fd1\u3044\u307b\u3046\u3092\u3001"),
            (Decode-UnicodeEscapes "\u3072\u3068\u3064\u9078\u3093\u3067\u304f\u3060\u3055\u3044\u3002")
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

        Draw-ImageCover -Graphics $graphics -ImagePath $sourceImageFrame01 -X 18 -Y 18 -Width ($width - 36) -Height ($height - 36) -Radius 48
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

        $headlineBottom = Draw-TrackedLines -Graphics $graphics -Lines $frame.Headline -Font $headlineLarge -Brush $textBrush -X 68 -Y 208 -LineHeight 122 -Tracking 0.12
        [void](Draw-Lines -Graphics $graphics -Lines $frame.Body -Font $bodyFont -Brush $softBrush -X 82 -Y ($headlineBottom + 42) -LineHeight 58)
    }
    elseif ($frame.Type -eq "body") {
        $graphics.Clear($canvasTop)
        Draw-ImageCover -Graphics $graphics -ImagePath $sourceImageFrame02 -X 18 -Y 18 -Width ($width - 36) -Height ($height - 36) -Radius 48
        $path = New-RoundedPath -X 18 -Y 18 -Width ($width - 36) -Height ($height - 36) -Radius 48
        $stroke = New-Object System.Drawing.Pen($mistBlueLine, 1)
        $graphics.DrawPath($stroke, $path)
        $stroke.Dispose()
        $path.Dispose()

        $bodyOverlay = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(178, 250, 252, 253))
        $graphics.FillRectangle($bodyOverlay, 18, 18, $width - 36, $height - 36)
        $bodyOverlay.Dispose()

        $topWash = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(76, 255, 255, 255))
        $graphics.FillRectangle($topWash, 18, 18, $width - 36, 120)
        $topWash.Dispose()

        $graphics.DrawString([string]$frame.LeftMeta, $metaFont, $blueBrush, 58, 48)
        Draw-RightAlignedText -Graphics $graphics -Text ([string]$frame.RightMeta) -Font $metaFont -Brush $blueBrush -RightX $metaRightX -Y 48

        $headlineBottom = Draw-TrackedLines -Graphics $graphics -Lines $frame.Headline -Font $headlineMedium -Brush $textBrush -X 72 -Y 214 -LineHeight 108 -Tracking 0.12
        $bodyBottom = Draw-Lines -Graphics $graphics -Lines $frame.Body -Font $bodyFont -Brush $softBrush -X 84 -Y ($headlineBottom + 34) -LineHeight 58

        $pollZoneY = $bodyBottom + 92
        $pollZoneHeight = 510
        Draw-RoundedGradientBox -Graphics $graphics -X 118 -Y $pollZoneY -Width 844 -Height $pollZoneHeight -Radius 38 `
            -TopColor ([System.Drawing.Color]::FromArgb(214, 250, 252, 253)) -BottomColor ([System.Drawing.Color]::FromArgb(192, 240, 246, 250)) -StrokeColor $glassPanelStroke -StrokeWidth 1

        $routeCardY = 1468
        Draw-RoundedGradientBox -Graphics $graphics -X 104 -Y $routeCardY -Width 872 -Height 188 -Radius 32 `
            -TopColor $warmPanelTop -BottomColor $warmPanelBottom -StrokeColor $warmPanelStroke -StrokeWidth 1
        $routeTitleHeight = 44
        $routeRuleGapTop = 22
        $routeRuleGapBottom = 22
        $routeBodyHeight = 70
        $routeContentTop = Get-CenteredStackTop -ContainerY $routeCardY -ContainerHeight 188 -ContentHeight ($routeTitleHeight + $routeRuleGapTop + $routeRuleGapBottom + $routeBodyHeight)
        $routeTitleY = $routeContentTop
        $routeRuleY = $routeTitleY + $routeTitleHeight + $routeRuleGapTop
        $routeBodyY = $routeRuleY + $routeRuleGapBottom
        Draw-CenteredParagraph -Graphics $graphics -Text (Decode-UnicodeEscapes "\u4eca\u65e5\u306e\u6295\u7a3f\u3092\u898b\u308b") -Font $cardTitleFont -Brush $textBrush -X 136 -Y $routeTitleY -Width 808 -Height $routeTitleHeight
        $graphics.DrawLine($accentPen, 410, $routeRuleY, 670, $routeRuleY)
        Draw-CenteredParagraph -Graphics $graphics -Text (Decode-UnicodeEscapes "\u898b\u305f\u76ee\u3060\u3051\u3067\u306f\u306a\u3044`n\u4fe1\u983c\u306e\u898b\u65b9\u3092\u6574\u7406\u3057\u3066\u3044\u307e\u3059\u3002") -Font $cardBodyFont -Brush $softBrush -X 146 -Y $routeBodyY -Width 788 -Height $routeBodyHeight
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

