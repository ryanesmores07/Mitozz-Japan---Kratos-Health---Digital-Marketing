param(
    [ValidateSet('default', 'cool_focus', 'warm_editorial')]
    [string]$PaletteVariant = 'default'
)

Add-Type -AssemblyName System.Drawing

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot 'shared/load-mitozz-design-tokens.ps1')

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

$jpFamilies = @("Hiragino Sans", "Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI")
$serifFamilies = @("Times New Roman", "Georgia", "Yu Mincho", "MS Mincho")
$designTokens = Get-MitozzDesignTokens -Variant $PaletteVariant
$tokenColors = $designTokens.Colors

$smallFont = New-Font -Families $jpFamilies -Size 24 -Style ([System.Drawing.FontStyle]::Bold)
$headlineFont = New-Font -Families $jpFamilies -Size 82 -Style ([System.Drawing.FontStyle]::Bold)
$headlineTightFont = New-Font -Families $jpFamilies -Size 70 -Style ([System.Drawing.FontStyle]::Bold)
$bodyFont = New-Font -Families $jpFamilies -Size 34 -Style ([System.Drawing.FontStyle]::Regular)
$bodySmallFont = New-Font -Families $jpFamilies -Size 28 -Style ([System.Drawing.FontStyle]::Regular)
$labelFont = New-Font -Families $jpFamilies -Size 24 -Style ([System.Drawing.FontStyle]::Bold)
$cardTitleFont = New-Font -Families $jpFamilies -Size 32 -Style ([System.Drawing.FontStyle]::Bold)
$cardBodyFont = New-Font -Families $jpFamilies -Size 26 -Style ([System.Drawing.FontStyle]::Regular)
$indexFont = New-Font -Families $serifFamilies -Size 38 -Style ([System.Drawing.FontStyle]::Bold)

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
$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$storyRoot = Join-Path $workspaceRoot "output/instagram/stories/ig-story-2026-04-03-routine-mini-guide-v01"
$productionDir = Join-Path $storyRoot "production"
$currentDir = Join-Path $storyRoot "current"
foreach ($path in @($productionDir, $currentDir)) {
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

    Draw-StoryBase -Graphics $graphics -Width $width -Height $height

    $graphics.DrawString([string]$frame.LeftMeta, $smallFont, $blueBrush, 58, 50)
    $graphics.DrawString([string]$frame.RightMeta, $smallFont, $blueBrush, 818, 50)

    if ($frame.Type -eq "cover") {
        $headlineBottom = Draw-TrackedLines -Graphics $graphics -Lines $frame.Headline -Font $headlineFont -Brush $textBrush -X 78 -Y 230 -LineHeight 102 -Tracking 2.0
        [void](Draw-Lines -Graphics $graphics -Lines $frame.Body -Font $bodyFont -Brush $softBrush -X 84 -Y ($headlineBottom + 10) -LineHeight 50)

        $guidePen = New-Object System.Drawing.Pen($mistGuide, 2)
        foreach ($guideX in @(312, 540, 768)) {
            $graphics.DrawLine($guidePen, $guideX, 700, $guideX, 1080)
        }
        $guidePen.Dispose()

        $supportCopy = Decode-UnicodeEscapes "\u3072\u3068\u3064\u305a\u3064\u3088\u308a\u3001\u6d41\u308c\u3067\u898b\u308b\u3068\u6574\u3048\u3084\u3059\u3044\u3002"
        Draw-CenteredParagraph -Graphics $graphics -Text $supportCopy -Font $bodySmallFont -Brush $softBrush -X 246 -Y 892 -Width 588 -Height 36
        $graphics.DrawLine($rulePen, 96, 910, 228, 910)
        $graphics.DrawLine($rulePen, 852, 910, 984, 910)

        Draw-RoundedBox -Graphics $graphics -X 54 -Y 1238 -Width 972 -Height 224 -Radius 30 `
            -FillColor $mistBlueSoft -StrokeColor $mistBlueLine -StrokeWidth 1

        $tileXs = @(96, 414, 732)
        $sleepLabel = ([string][char]0x7761) + [char]0x7720
        $foodLabel = ([string][char]0x98df) + [char]0x4e8b
        $moveLabel = ([string][char]0x904b) + [char]0x52d5
        $sleepValue = ([string][char]0x6574) + [char]0x3048 + [char]0x308b
        $foodValue = ([string][char]0x6e80) + [char]0x305f + [char]0x3059
        $moveValue = ([string][char]0x52d5) + [char]0x304b + [char]0x3059
        $tileLabels = @($sleepLabel, $foodLabel, $moveLabel)
        $tileValues = @($sleepValue, $foodValue, $moveValue)

        for ($t = 0; $t -lt 3; $t += 1) {
            if ($t -gt 0) {
                $graphics.DrawLine($rulePen, $tileXs[$t] - 30, 1268, $tileXs[$t] - 30, 1434)
            }
            $graphics.DrawString($tileLabels[$t], $labelFont, $blueBrush, $tileXs[$t], 1298)
            $graphics.DrawString($tileValues[$t], $cardTitleFont, $textBrush, $tileXs[$t], 1350)
        }
    }

    if ($frame.Type -eq "body") {
        $headlineBottom = Draw-TrackedLines -Graphics $graphics -Lines $frame.Headline -Font $headlineTightFont -Brush $textBrush -X 78 -Y 228 -LineHeight 90 -Tracking 1.8
        [void](Draw-Lines -Graphics $graphics -Lines $frame.Body -Font $bodyFont -Brush $softBrush -X 84 -Y ($headlineBottom + 14) -LineHeight 50)

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
        Draw-CenteredParagraph -Graphics $graphics -Text $checkCopy -Font $bodySmallFont -Brush $softBrush -X 264 -Y 692 -Width 552 -Height 34
        $graphics.DrawLine($rulePen, 96, 708, 252, 708)
        $graphics.DrawLine($rulePen, 828, 708, 984, 708)

        $rowY = 760
        foreach ($row in $rows) {
            Draw-RoundedBox -Graphics $graphics -X 54 -Y $rowY -Width 972 -Height 176 -Radius 26 `
                -FillColor $white -StrokeColor $mistBlueLine -StrokeWidth 1
            Draw-RoundedBox -Graphics $graphics -X 54 -Y $rowY -Width 170 -Height 176 -Radius 26 `
                -FillColor $mistBlueSoft -StrokeColor $mistBlueLine -StrokeWidth 1
            Draw-CenteredParagraph -Graphics $graphics -Text ([string]$row.Label) -Font $cardTitleFont -Brush $blueBrush -X 54 -Y $rowY -Width 170 -Height 176
            $graphics.DrawString([string]$row.Title, $cardTitleFont, $textBrush, 256, $rowY + 42)
            Draw-Paragraph -Graphics $graphics -Text ([string]$row.Body) -Font $cardBodyFont -Brush $softBrush -X 256 -Y ($rowY + 96) -Width 678 -Height 54
            $rowY += 196
        }

        Draw-RoundedBox -Graphics $graphics -X 120 -Y 1426 -Width 840 -Height 112 -Radius 28 `
            -FillColor $mistBlueSoft -StrokeColor $mistBlueLine -StrokeWidth 1
        $bodyFooter = Decode-UnicodeEscapes "\u3072\u3068\u3064\u306e\u5165\u53e3\u304b\u3089\u898b\u76f4\u305b\u3070\u4e00\u6b69\u9032\u3081\u3084\u3059\u3044\u3002"
        Draw-CenteredParagraph -Graphics $graphics -Text $bodyFooter -Font $cardBodyFont -Brush $softBrush -X 168 -Y 1456 -Width 744 -Height 44
    }

    if ($frame.Type -eq "close") {
        $headlineBottom = Draw-TrackedLines -Graphics $graphics -Lines $frame.Headline -Font $headlineTightFont -Brush $textBrush -X 78 -Y 266 -LineHeight 90 -Tracking 1.8
        [void](Draw-Lines -Graphics $graphics -Lines $frame.Body -Font $bodyFont -Brush $softBrush -X 84 -Y ($headlineBottom + 16) -LineHeight 50)

        $closeStripY = 830
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

        $graphics.DrawLine($rulePen, 96, 984, 984, 984)

        Draw-RoundedBox -Graphics $graphics -X 84 -Y 1034 -Width 912 -Height 286 -Radius 34 `
            -FillColor $mistBlueSoft -StrokeColor $mistBlueLine -StrokeWidth 1

        $closeTitle = [string]([char]0x30d5)+[char]0x30a3+[char]0x30fc+[char]0x30c9+[char]0x3067+[char]0x5168+[char]0x4f53+[char]0x3092+[char]0x898b+[char]0x76f4+[char]0x3059
        $closeBody = [string]([char]0x7761)+[char]0x7720+[char]0x3001+[char]0x98df+[char]0x4e8b+[char]0x3001+[char]0x904b+[char]0x52d5+[char]0x306e+[char]0x3064+[char]0x306a+[char]0x304c+[char]0x308a+[char]0x3092+[char]0x4eca+[char]0x65e5+[char]0x306e+[char]0x6295+[char]0x7a3f+[char]0x3067+[char]0x6574+[char]0x7406+[char]0x3002
        Draw-CenteredParagraph -Graphics $graphics -Text $closeTitle -Font $cardTitleFont -Brush $textBrush -X 124 -Y 1114 -Width 832 -Height 44
        $graphics.DrawLine($accentPen, 416, 1198, 664, 1198)
        Draw-CenteredParagraph -Graphics $graphics -Text $closeBody -Font $cardBodyFont -Brush $softBrush -X 134 -Y 1238 -Width 812 -Height 40
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
