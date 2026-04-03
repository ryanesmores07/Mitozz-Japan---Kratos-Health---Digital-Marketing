param(
    [ValidateSet('default', 'cool_focus', 'warm_editorial')]
    [string]$PaletteVariant = 'default',
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

function Get-CenteredStackTop {
    param(
        [float]$ContainerY,
        [float]$ContainerHeight,
        [float]$ContentHeight
    )

    return [float]($ContainerY + (($ContainerHeight - $ContentHeight) / 2))
}

function Decode-UnicodeEscapes {
    param([string]$Value)
    return [regex]::Unescape($Value)
}

function Draw-StoryBase {
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
    $Graphics.FillRectangle($headerBrush, 18, 18, $Width - 36, 126)
    $headerBrush.Dispose()
}

$designTokens = Get-MitozzDesignTokens -Variant $PaletteVariant
$fontProfileConfig = Get-MitozzFontProfileConfig -Profile $FontProfile
$jpFamilies = [string[]]$fontProfileConfig.body_families
$accentFamilies = if ($fontProfileConfig.ContainsKey('accent_families')) { [string[]]$fontProfileConfig.accent_families } else { @("Hiragino Mincho ProN", "Yu Mincho", "MS PMincho", "Times New Roman") }
$tokenColors = $designTokens.Colors

$smallFont = New-Font -Families $jpFamilies -Size 24 -Style ([System.Drawing.FontStyle]::Bold)
$headlineFont = New-Font -Families $jpFamilies -Size 74 -Style ([System.Drawing.FontStyle]::Bold)
$headlineTightFont = New-Font -Families $jpFamilies -Size 64 -Style ([System.Drawing.FontStyle]::Bold)
$bodyFont = New-Font -Families $jpFamilies -Size 34 -Style ([System.Drawing.FontStyle]::Regular)
$bodySmallFont = New-Font -Families $jpFamilies -Size 28 -Style ([System.Drawing.FontStyle]::Regular)
$labelFont = New-Font -Families $jpFamilies -Size 24 -Style ([System.Drawing.FontStyle]::Bold)
$cardTitleFont = New-Font -Families $jpFamilies -Size 32 -Style ([System.Drawing.FontStyle]::Bold)
$cardBodyFont = New-Font -Families $jpFamilies -Size 26 -Style ([System.Drawing.FontStyle]::Regular)
$indexFont = New-Font -Families $accentFamilies -Size 38 -Style ([System.Drawing.FontStyle]::Bold)

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
$glassPanelTop = [System.Drawing.Color]::FromArgb(244, 250, 252, 253)
$glassPanelBottom = [System.Drawing.Color]::FromArgb(236, 235, 243, 248)
$glassPanelStroke = [System.Drawing.Color]::FromArgb(214, 207, 218, 226)
$white = $tokenColors.card
$mistGuide = [System.Drawing.Color]::FromArgb(84, $mistBlueLine.R, $mistBlueLine.G, $mistBlueLine.B)

$textBrush = New-Object System.Drawing.SolidBrush($charcoal)
$softBrush = New-Object System.Drawing.SolidBrush($softCharcoal)
$blueBrush = New-Object System.Drawing.SolidBrush($mistBlue)
$whiteBrush = New-Object System.Drawing.SolidBrush($white)
$mistBrush = New-Object System.Drawing.SolidBrush($mistBlueSoft)
$rulePen = New-Object System.Drawing.Pen($mistBlueLine, 2)
$accentPen = New-Object System.Drawing.Pen($apricot, 4)

$width = 1080
$height = 1920
$metaRightX = [float]($width - 58)
$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$storyRoot = Join-Path $workspaceRoot "output/instagram/stories/2026-04-03-story-routine-mini-guide-v01"
$sourceDir = Join-Path $storyRoot "source"
$productionDir = Join-Path $storyRoot "production"
$currentDir = Join-Path $storyRoot "current"
$sourceImage = Join-Path $sourceDir "frame-01-plate-nanobanana-v01.jpg"
foreach ($path in @($sourceDir, $productionDir, $currentDir)) {
    if (-not (Test-Path -LiteralPath $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }
}

$frames = @'
[
  {
    "File": "frame-01.png",
    "LeftMeta": "\u30d5\u30a3\u30fc\u30c9\u88dc\u8db3",
    "RightMeta": "\u3072\u3068\u308a\u3054\u3068\u30e1\u30e2",
    "Headline": [
      "\u5168\u90e8\u3061\u3083\u3093\u3068",
      "\u3057\u3088\u3046\u3068\u3059\u308b\u3068",
      "\u7d9a\u304d\u306b\u304f\u3044\u3002"
    ],
    "Body": [
      "\u307e\u305a\u306f\u4e00\u3064\u305a\u3064\u3067\u306f\u306a\u304f\u3001",
      "\u3064\u306a\u304c\u308a\u304b\u3089\u898b\u3066\u307f\u308b\u3002"
    ],
    "Type": "cover"
  },
  {
    "File": "frame-02.png",
    "LeftMeta": "\u3053\u3093\u306a\u6642",
    "RightMeta": "\u30bb\u30eb\u30d5\u30c1\u30a7\u30c3\u30af",
    "Headline": [
      "\u6700\u8fd1\u3001\u3053\u3093\u306a\u6d41\u308c\u306b",
      "\u306a\u3063\u3066\u3044\u307e\u305b\u3093\u304b\uff1f"
    ],
    "Body": [
      "\u5f53\u3066\u306f\u307e\u308b\u3082\u306e\u304c\u3042\u308c\u3070\u3001",
      "\u4eca\u65e5\u306e\u6295\u7a3f\u304c\u53c2\u8003\u306b\u306a\u308b\u304b\u3082\u3002"
    ],
    "Type": "body"
  },
  {
    "File": "frame-03.png",
    "LeftMeta": "\u4fdd\u5b58\u7248",
    "RightMeta": "\u4eca\u65e5\u306e\u6295\u7a3f\u3078",
    "Headline": [
      "\u4eca\u65e5\u306e\u6295\u7a3f\u3067",
      "3\u3064\u306e\u3064\u306a\u304c\u308a\u3092",
      "\u6574\u7406\u3057\u3066\u3044\u307e\u3059\u3002"
    ],
    "Body": [
      "\u7761\u7720\u3001\u98df\u4e8b\u3001\u904b\u52d5\u3092",
      "\u3072\u3068\u3064\u306e\u571f\u53f0\u3068\u3057\u3066\u898b\u76f4\u3059\u3002"
    ],
    "Type": "close"
  }
]
'@ | ConvertFrom-Json

for ($i = 0; $i -lt $frames.Count; $i += 1) {
    $frame = $frames[$i]
    $bitmap = New-Object System.Drawing.Bitmap($width, $height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    if ($frame.Type -eq "cover") {
        if (Test-Path -LiteralPath $sourceImage) {
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
                ([System.Drawing.Color]::FromArgb(222, 247, 250, 252)),
                ([System.Drawing.Color]::FromArgb(74, 247, 250, 252))
            )
            $graphics.FillRectangle($overlayBrush, 18, 18, 760, $height - 36)
            $overlayBrush.Dispose()

            $topWash = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(72, 255, 255, 255))
            $graphics.FillRectangle($topWash, 18, 18, $width - 36, 120)
            $topWash.Dispose()
        }
        else {
            Draw-StoryBase -Graphics $graphics -Width $width -Height $height
        }

        $graphics.DrawString([string]$frame.LeftMeta, $smallFont, $blueBrush, 58, 50)
        Draw-RightAlignedText -Graphics $graphics -Text ([string]$frame.RightMeta) -Font $smallFont -Brush $blueBrush -RightX $metaRightX -Y 50

        $headlineBottom = Draw-TrackedLines -Graphics $graphics -Lines $frame.Headline -Font $headlineFont -Brush $textBrush -X 78 -Y 224 -LineHeight 92 -Tracking 0.8
        [void](Draw-Lines -Graphics $graphics -Lines $frame.Body -Font $bodyFont -Brush $softBrush -X 84 -Y ($headlineBottom + 18) -LineHeight 50)

        $supportStripY = 762
        Draw-RoundedGradientBox -Graphics $graphics -X 126 -Y $supportStripY -Width 828 -Height 88 -Radius 24 `
            -TopColor $glassPanelTop -BottomColor $glassPanelBottom -StrokeColor $glassPanelStroke -StrokeWidth 1
        $supportCopy = Decode-UnicodeEscapes "\u3072\u3068\u3064\u305a\u3064\u3088\u308a\u3001\u6d41\u308c\u3067\u898b\u308b\u3068\u6574\u3048\u3084\u3059\u3044\u3002"
        Draw-CenteredParagraph -Graphics $graphics -Text $supportCopy -Font $bodySmallFont -Brush $softBrush -X 174 -Y ($supportStripY + 22) -Width 732 -Height 42

        $coverBandY = 948
        $coverBandHeight = 248
        Draw-RoundedGradientBox -Graphics $graphics -X 54 -Y $coverBandY -Width 972 -Height $coverBandHeight -Radius 32 `
            -TopColor $glassPanelTop -BottomColor $glassPanelBottom -StrokeColor $glassPanelStroke -StrokeWidth 1

        $labels = @(
            (Decode-UnicodeEscapes "\u7761\u7720"),
            (Decode-UnicodeEscapes "\u98df\u4e8b"),
            (Decode-UnicodeEscapes "\u904b\u52d5")
        )
        $values = @(
            (Decode-UnicodeEscapes "\u6574\u3048\u308b"),
            (Decode-UnicodeEscapes "\u6e80\u305f\u3059"),
            (Decode-UnicodeEscapes "\u52d5\u304b\u3059")
        )
        $columnWidth = 972 / 3
        for ($columnIndex = 0; $columnIndex -lt 3; $columnIndex += 1) {
            $columnLeft = 54 + ($columnWidth * $columnIndex)
            if ($columnIndex -gt 0) {
                $graphics.DrawLine($rulePen, $columnLeft, ($coverBandY + 32), $columnLeft, ($coverBandY + $coverBandHeight - 32))
            }
            Draw-CenteredParagraph -Graphics $graphics -Text $labels[$columnIndex] -Font $labelFont -Brush $blueBrush -X $columnLeft -Y 1006 -Width $columnWidth -Height 38
            Draw-CenteredParagraph -Graphics $graphics -Text $values[$columnIndex] -Font $cardTitleFont -Brush $textBrush -X $columnLeft -Y 1058 -Width $columnWidth -Height 48
        }

        Draw-RoundedBox -Graphics $graphics -X 120 -Y 1314 -Width 840 -Height 120 -Radius 28 `
            -FillColor $cardWhite -StrokeColor $mistBlueLine -StrokeWidth 1
        $coverFooter = Decode-UnicodeEscapes "\u307e\u305a\u306f\u300c\u3069\u3053\u304c\u4e71\u308c\u3066\u3044\u308b\u304b\u300d\u304b\u3089\u898b\u3066\u307f\u308b\u3002"
        Draw-CenteredParagraph -Graphics $graphics -Text $coverFooter -Font $cardBodyFont -Brush $softBrush -X 176 -Y 1350 -Width 728 -Height 44
    }
    else {
        Draw-StoryBase -Graphics $graphics -Width $width -Height $height
        $graphics.DrawString([string]$frame.LeftMeta, $smallFont, $blueBrush, 58, 50)
        Draw-RightAlignedText -Graphics $graphics -Text ([string]$frame.RightMeta) -Font $smallFont -Brush $blueBrush -RightX $metaRightX -Y 50
    }

    if ($frame.Type -eq "body") {
        $headlineBottom = Draw-TrackedLines -Graphics $graphics -Lines $frame.Headline -Font $headlineTightFont -Brush $textBrush -X 78 -Y 220 -LineHeight 84 -Tracking 0.6
        [void](Draw-Lines -Graphics $graphics -Lines $frame.Body -Font $bodyFont -Brush $softBrush -X 84 -Y ($headlineBottom + 18) -LineHeight 50)

        $rows = @'
[
  {
    "Index": "01",
    "Label": "\u7761\u7720",
            "Title": "\u671d\u304b\u3089\u3082\u3046\u91cd\u3044",
            "Body": "\u5bdd\u3066\u3082\u5207\u308a\u66ff\u308f\u3089\u305a\u3001\u65e5\u4e2d\u307e\u3067\u5f15\u304d\u305a\u308b\u3002"
  },
  {
    "Index": "02",
    "Label": "\u98df\u4e8b",
            "Title": "\u98df\u4e8b\u304c\u9069\u5f53\u306b\u306a\u308b",
            "Body": "\u629c\u3044\u305f\u308a\u6025\u3044\u3060\u308a\u3067\u3001\u6ce2\u304c\u5927\u304d\u304f\u306a\u308b\u3002"
  },
  {
    "Index": "03",
    "Label": "\u904b\u52d5",
            "Title": "\u52d5\u304f\u4f59\u88d5\u304c\u306a\u3044",
            "Body": "\u5ea7\u308a\u3063\u3071\u306a\u3057\u3067\u3001\u5de1\u308a\u304c\u6b62\u307e\u308a\u3084\u3059\u3044\u3002"
  }
]
'@ | ConvertFrom-Json

        $checkCopy = Decode-UnicodeEscapes "\u5f53\u3066\u306f\u307e\u308b\u5165\u53e3\u3092\u3072\u3068\u3064\u898b\u3064\u3051\u308b"
        Draw-RoundedBox -Graphics $graphics -X 146 -Y 648 -Width 788 -Height 86 -Radius 24 `
            -FillColor $cardWhite -StrokeColor $mistBlueLine -StrokeWidth 1
        Draw-CenteredParagraph -Graphics $graphics -Text $checkCopy -Font $bodySmallFont -Brush $softBrush -X 186 -Y 670 -Width 708 -Height 40

        $rowY = 786
        foreach ($row in $rows) {
            Draw-RoundedBox -Graphics $graphics -X 54 -Y $rowY -Width 972 -Height 188 -Radius 26 `
                -FillColor $white -StrokeColor $mistBlueLine -StrokeWidth 1
            Draw-RoundedBox -Graphics $graphics -X 54 -Y $rowY -Width 188 -Height 188 -Radius 26 `
                -FillColor $mistBlueSoft -StrokeColor $mistBlueLine -StrokeWidth 1
            Draw-CenteredParagraph -Graphics $graphics -Text ([string]$row.Label) -Font $cardTitleFont -Brush $blueBrush -X 54 -Y $rowY -Width 188 -Height 188
            $graphics.DrawString([string]$row.Title, $cardTitleFont, $textBrush, 280, $rowY + 42)
            Draw-Paragraph -Graphics $graphics -Text ([string]$row.Body) -Font $cardBodyFont -Brush $softBrush -X 280 -Y ($rowY + 92) -Width 640 -Height 62
            $rowY += 208
        }

        Draw-RoundedBox -Graphics $graphics -X 120 -Y 1446 -Width 840 -Height 112 -Radius 28 `
            -FillColor $mistBlueSoft -StrokeColor $mistBlueLine -StrokeWidth 1
        $bodyFooter = Decode-UnicodeEscapes "\u3072\u3068\u3064\u306e\u5165\u53e3\u304b\u3089\u898b\u76f4\u305b\u3070\u4e00\u6b69\u9032\u3081\u3084\u3059\u3044\u3002"
        Draw-CenteredParagraph -Graphics $graphics -Text $bodyFooter -Font $cardBodyFont -Brush $softBrush -X 168 -Y 1478 -Width 744 -Height 44
    }

    if ($frame.Type -eq "close") {
        $headlineHeight = [float]($frame.Headline.Count * 84)
        $bodyHeight = [float]($frame.Body.Count * 50)
        $closeStripHeight = 100.0
        $closeCardHeight = 248.0
        $headlineBodyGap = 18.0
        $bodyStripGap = 92.0
        $stripCardGap = 86.0
        $closeContentHeight = $headlineHeight + $headlineBodyGap + $bodyHeight + $bodyStripGap + $closeStripHeight + $stripCardGap + $closeCardHeight
        $closeBlockTop = Get-CenteredStackTop -ContainerY 220 -ContainerHeight 1280 -ContentHeight $closeContentHeight
        $headlineY = [float]$closeBlockTop
        $headlineBottom = Draw-TrackedLines -Graphics $graphics -Lines $frame.Headline -Font $headlineTightFont -Brush $textBrush -X 78 -Y $headlineY -LineHeight 84 -Tracking 0.6
        $bodyY = [float]($headlineY + $headlineHeight + $headlineBodyGap)
        [void](Draw-Lines -Graphics $graphics -Lines $frame.Body -Font $bodyFont -Brush $softBrush -X 84 -Y $bodyY -LineHeight 50)

        $closeStripY = [float]($bodyY + $bodyHeight + $bodyStripGap)
        Draw-RoundedBox -Graphics $graphics -X 138 -Y $closeStripY -Width 804 -Height 100 -Radius 24 `
            -FillColor $mistBlueSoft -StrokeColor $mistBlueLine -StrokeWidth 1

        $stripSleep = Decode-UnicodeEscapes "\u5206\u3051\u306a\u3044"
        $stripFood = Decode-UnicodeEscapes "\u3064\u306a\u3052\u308b"
        $stripMove = Decode-UnicodeEscapes "\u898b\u76f4\u3059"
        $stripLabels = @($stripSleep, $stripFood, $stripMove)
        $stripX = 138
        $stripWidth = 804
        $stripColumnWidth = $stripWidth / 3
        for ($t = 0; $t -lt 3; $t += 1) {
            if ($t -gt 0) {
                $separatorX = $stripX + ($stripColumnWidth * $t)
                $graphics.DrawLine($rulePen, $separatorX, ($closeStripY + 18), $separatorX, ($closeStripY + 82))
            }
            $columnLeft = $stripX + ($stripColumnWidth * $t)
            Draw-CenteredParagraph -Graphics $graphics -Text $stripLabels[$t] -Font $labelFont -Brush $blueBrush -X $columnLeft -Y ($closeStripY + 4) -Width $stripColumnWidth -Height 92
        }

        $dividerY = [float]($closeStripY + 154)
        $graphics.DrawLine($rulePen, 96, $dividerY, 984, $dividerY)

        $closeCardY = [float]($closeStripY + $closeStripHeight + $stripCardGap)
        Draw-RoundedBox -Graphics $graphics -X 84 -Y $closeCardY -Width 912 -Height 248 -Radius 34 `
            -FillColor $mistBlueSoft -StrokeColor $mistBlueLine -StrokeWidth 1

        $closeTitle = [string]([char]0x30d5)+[char]0x30a3+[char]0x30fc+[char]0x30c9+[char]0x3067+[char]0x5168+[char]0x4f53+[char]0x3092+[char]0x898b+[char]0x76f4+[char]0x3059
        $closeBody = [string]([char]0x7761)+[char]0x7720+[char]0x3001+[char]0x98df+[char]0x4e8b+[char]0x3001+[char]0x904b+[char]0x52d5+[char]0x306e+[char]0x3064+[char]0x306a+[char]0x304c+[char]0x308a+[char]0x3092+[char]0x3001+[char]0x4eca+[char]0x65e5+[char]0x306e+[char]0x6295+[char]0x7a3f+[char]0x3067+[char]0x6574+[char]0x7406+[char]0x3002
        $closeTitleHeight = 44.0
        $closeRuleGapTop = 28.0
        $closeRuleGapBottom = 28.0
        $closeBodyHeightInner = 64.0
        $closeInnerHeight = $closeTitleHeight + $closeRuleGapTop + $closeRuleGapBottom + $closeBodyHeightInner
        $closeInnerTop = Get-CenteredStackTop -ContainerY $closeCardY -ContainerHeight $closeCardHeight -ContentHeight $closeInnerHeight
        $closeTitleY = [float]$closeInnerTop
        $closeRuleY = [float]($closeTitleY + $closeTitleHeight + $closeRuleGapTop)
        $closeBodyY = [float]($closeRuleY + $closeRuleGapBottom)
        Draw-CenteredParagraph -Graphics $graphics -Text $closeTitle -Font $cardTitleFont -Brush $textBrush -X 124 -Y $closeTitleY -Width 832 -Height $closeTitleHeight
        $graphics.DrawLine($accentPen, 416, $closeRuleY, 664, $closeRuleY)
        Draw-CenteredParagraph -Graphics $graphics -Text $closeBody -Font $cardBodyFont -Brush $softBrush -X 134 -Y $closeBodyY -Width 812 -Height $closeBodyHeightInner
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
$mistBrush.Dispose()
$rulePen.Dispose()
$accentPen.Dispose()

$smallFont.Dispose()
$headlineFont.Dispose()
$headlineTightFont.Dispose()
$bodyFont.Dispose()
$bodySmallFont.Dispose()
$labelFont.Dispose()
$cardTitleFont.Dispose()
$cardBodyFont.Dispose()
$indexFont.Dispose()

Write-Output "Rendered April 3 routine mini guide story to $storyRoot"

