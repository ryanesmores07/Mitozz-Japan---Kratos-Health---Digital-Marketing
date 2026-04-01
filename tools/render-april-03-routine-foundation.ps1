Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$outputDir = Join-Path $workspaceRoot "output/instagram/feed/ig-feed-2026-04-03-routine-foundation-v02/current"
if (-not (Test-Path -LiteralPath $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

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
        }
    }

    throw "Unable to load any requested font families: $($Families -join ', ')"
}

function New-RoundedRectPath {
    param(
        [float]$X,
        [float]$Y,
        [float]$Width,
        [float]$Height,
        [float]$Radius
    )

    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $diameter = $Radius * 2
    $path.AddArc($X, $Y, $diameter, $diameter, 180, 90)
    $path.AddArc($X + $Width - $diameter, $Y, $diameter, $diameter, 270, 90)
    $path.AddArc($X + $Width - $diameter, $Y + $Height - $diameter, $diameter, $diameter, 0, 90)
    $path.AddArc($X, $Y + $Height - $diameter, $diameter, $diameter, 90, 90)
    $path.CloseFigure()
    return $path
}

function Draw-LineBlock {
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

function Draw-RoundedBox {
    param(
        [System.Drawing.Graphics]$Graphics,
        [float]$X,
        [float]$Y,
        [float]$Width,
        [float]$Height,
        [float]$Radius,
        [System.Drawing.Color]$FillColor,
        [System.Drawing.Color]$StrokeColor
    )

    $path = New-RoundedRectPath -X $X -Y $Y -Width $Width -Height $Height -Radius $Radius
    $fill = New-Object System.Drawing.SolidBrush($FillColor)
    $stroke = New-Object System.Drawing.Pen($StrokeColor, 1)
    $Graphics.FillPath($fill, $path)
    $Graphics.DrawPath($stroke, $path)
    $fill.Dispose()
    $stroke.Dispose()
    $path.Dispose()
}

function Draw-HeaderBand {
    param(
        [System.Drawing.Graphics]$Graphics,
        [pscustomobject]$Slide
    )

    $bandX = 58
    $bandY = 58

    if ($Slide.PSObject.Properties.Match("Index").Count -gt 0) {
        Draw-RoundedBox -Graphics $Graphics -X $bandX -Y $bandY -Width 320 -Height 82 -Radius 41 `
            -FillColor ([System.Drawing.Color]::FromArgb(96, 236, 242, 246)) `
            -StrokeColor ([System.Drawing.Color]::FromArgb(58, 255, 255, 255))

        $Graphics.FillEllipse($badgeBrush, 72, 73, 54, 54)
        $Graphics.DrawString([string]$Slide.Index, $panelIndexFont, $kickerBrush, 85, 83)
        $Graphics.DrawString([string]$Slide.PanelKicker, $kickerFont, $kickerBrush, 146, 78)
        $Graphics.DrawString([string]$Slide.PanelEyebrow, $panelEyebrowFont, $softTextBrush, 146, 106)
    }
    else {
        Draw-RoundedBox -Graphics $Graphics -X $bandX -Y $bandY -Width 248 -Height 72 -Radius 36 `
            -FillColor ([System.Drawing.Color]::FromArgb(82, 236, 242, 246)) `
            -StrokeColor ([System.Drawing.Color]::FromArgb(50, 255, 255, 255))
        $Graphics.DrawString([string]$Slide.Kicker, $kickerFont, $kickerBrush, 82, 81)
    }
}

function Draw-SelectorTiles {
    param(
        [System.Drawing.Graphics]$Graphics,
        [pscustomobject]$Slide
    )

    $tileWidth = 214
    $tileHeight = 116
    $tileY = 844
    $tileXs = @(92, 356, 620)
    for ($i = 0; $i -lt 3; $i++) {
        $isFocus = ($Slide.PSObject.Properties.Match("FocusPanels").Count -gt 0) -and (@($Slide.FocusPanels) -contains ($i + 1))
        $fillColor = if ($isFocus) {
            [System.Drawing.Color]::FromArgb(104, 225, 234, 240)
        } else {
            [System.Drawing.Color]::FromArgb(64, 238, 242, 246)
        }
        Draw-RoundedBox -Graphics $Graphics -X $tileXs[$i] -Y $tileY -Width $tileWidth -Height $tileHeight -Radius 24 `
            -FillColor $fillColor `
            -StrokeColor ([System.Drawing.Color]::FromArgb(48, 214, 226, 233))

        $label = [string]$Slide.TileLabels[$i]
        $value = [string]$Slide.TileValues[$i]
        $Graphics.DrawString($label, $tileLabelFont, $kickerBrush, $tileXs[$i] + 20, $tileY + 18)
        $Graphics.DrawString($value, $tileValueFont, $textBrush, $tileXs[$i] + 20, $tileY + 52)
    }
}

function Draw-AnswerPanel {
    param(
        [System.Drawing.Graphics]$Graphics,
        [pscustomobject]$Slide
    )

    if ($Slide.Variant -eq "cover") {
        Draw-SelectorTiles -Graphics $Graphics -Slide $Slide
        return
    }

    if ($Slide.Variant -eq "close") {
        Draw-RoundedBox -Graphics $Graphics -X 92 -Y 830 -Width 744 -Height 164 -Radius 30 `
            -FillColor ([System.Drawing.Color]::FromArgb(60, 238, 242, 246)) `
            -StrokeColor ([System.Drawing.Color]::FromArgb(44, 214, 226, 233))
        $Graphics.DrawString([string]$Slide.CloseLabel, $tileLabelFont, $kickerBrush, 118, 858)
        $Graphics.DrawString([string]$Slide.CloseValue, $answerTitleFont, $textBrush, 118, 894)
        $Graphics.DrawLine($ctaAccentPen, 118, 954, 496, 954)
        return
    }

    Draw-RoundedBox -Graphics $Graphics -X 92 -Y 818 -Width 744 -Height 176 -Radius 28 `
        -FillColor ([System.Drawing.Color]::FromArgb(56, 238, 242, 246)) `
        -StrokeColor ([System.Drawing.Color]::FromArgb(40, 214, 226, 233))

    $Graphics.DrawString([string]$Slide.AnswerLabel, $tileLabelFont, $kickerBrush, 118, 848)
    $Graphics.DrawString([string]$Slide.AnswerTitle, $answerTitleFont, $textBrush, 118, 884)
    $Graphics.DrawLine($sectionPen, 118, 944, 810, 944)
    $Graphics.DrawString([string]$Slide.AnswerBody, $answerBodyFont, $softTextBrush, 118, 958)
}

$textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 52, 57, 63))
$softTextBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(196, 52, 57, 63))
$kickerBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(220, 111, 135, 148))
$badgeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(156, 223, 232, 238))
$mistBrushSoft = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(26, 220, 232, 238))
$whitePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(136, 255, 255, 255), 1)
$rulePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(92, 111, 135, 148), 2)
$sectionPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(72, 170, 186, 196), 2)
$ctaAccentPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(132, 244, 138, 90), 4)

$headlineFont = New-Font -Families @("Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI") -Size 66 -Style ([System.Drawing.FontStyle]::Bold)
$headlineCoverFont = New-Font -Families @("Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI") -Size 72 -Style ([System.Drawing.FontStyle]::Bold)
$bodyFont = New-Font -Families @("Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI") -Size 31 -Style ([System.Drawing.FontStyle]::Regular)
$kickerFont = New-Font -Families @("Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI") -Size 22 -Style ([System.Drawing.FontStyle]::Bold)
$noteFont = New-Font -Families @("Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI") -Size 22 -Style ([System.Drawing.FontStyle]::Bold)
$panelIndexFont = New-Font -Families @("Times New Roman", "Georgia", "Segoe UI") -Size 30 -Style ([System.Drawing.FontStyle]::Bold)
$panelEyebrowFont = New-Font -Families @("Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI") -Size 24 -Style ([System.Drawing.FontStyle]::Regular)
$tileLabelFont = New-Font -Families @("Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI") -Size 20 -Style ([System.Drawing.FontStyle]::Bold)
$tileValueFont = New-Font -Families @("Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI") -Size 28 -Style ([System.Drawing.FontStyle]::Bold)
$answerTitleFont = New-Font -Families @("Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI") -Size 28 -Style ([System.Drawing.FontStyle]::Bold)
$answerBodyFont = New-Font -Families @("Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI") -Size 21 -Style ([System.Drawing.FontStyle]::Regular)

$slides = @'
[
  {
    "File": "slide-01.png",
    "Variant": "cover",
    "Kicker": "DAILY FOUNDATION",
    "Note": "SAVE-WORTHY EDUCATION",
    "FocusPanels": [2],
    "TileLabels": ["\u7761\u7720", "\u98df\u4e8b", "\u904b\u52d5"],
    "TileValues": ["\u6574\u3048\u308b", "\u6e80\u305f\u3059", "\u52d5\u304b\u3059"],
    "Headline": [
      "\u7761\u7720 \u98df\u4e8b \u904b\u52d5\u3092",
      "\u30df\u30c8\u30b3\u30f3\u30c9\u30ea\u30a2\u8996\u70b9\u3067",
      "\u898b\u76f4\u3059"
    ],
    "Body": [
      "\u3070\u3089\u3070\u3089\u306b\u6574\u3048\u308b\u3088\u308a\u3001",
      "\u3072\u3068\u3064\u306e\u6d41\u308c\u3068\u3057\u3066\u898b\u3066\u307f\u308b\u3002"
    ]
  },
  {
    "File": "slide-02.png",
    "Variant": "body",
    "Index": "01",
    "PanelKicker": "REFRAME",
    "PanelEyebrow": "\u3072\u3068\u3064\u305a\u3064\u6574\u3048\u308b\u524d\u306b",
    "Note": "CONNECTED RHYTHM",
    "AnswerLabel": "POINT 01",
    "AnswerTitle": "\u3070\u3089\u3070\u3089\u3067\u306f\u306a\u304f\u3001\u3072\u3068\u3064\u306e\u6d41\u308c",
    "AnswerBody": "\u7fd2\u6163\u3092\u5206\u3051\u3066\u898b\u308b\u3088\u308a\u3001\u6bce\u65e5\u306e\u571f\u53f0\u3068\u3057\u3066\u3064\u306a\u304c\u308a\u3067\u6349\u3048\u308b\u3002",
    "Headline": [
      "\u5225\u3005\u306b\u6574\u3048\u308b\u3088\u308a\u3001",
      "\u3064\u306a\u304c\u308a\u3067\u898b\u308b\u3053\u3068\u304c",
      "\u5927\u5207\u3067\u3059\u3002"
    ],
    "Body": [
      "\u6bce\u65e5\u306e\u8abf\u5b50\u306f\u3001",
      "\u5358\u72ec\u306e\u7fd2\u6163\u3060\u3051\u3067\u6c7a\u307e\u308b\u3082\u306e\u3067\u306f\u3042\u308a\u307e\u305b\u3093\u3002"
    ]
  },
  {
    "File": "slide-03.png",
    "Variant": "body",
    "Index": "02",
    "PanelKicker": "FOUNDATION",
    "PanelEyebrow": "\u8996\u70b9\u3092\u3072\u3068\u3064\u306b\u307e\u3068\u3081\u308b",
    "Note": "MITOCHONDRIA-FIRST VIEW",
    "AnswerLabel": "POINT 02",
    "AnswerTitle": "\u7761\u7720\u3001\u98df\u4e8b\u3001\u904b\u52d5\u306f\u540c\u3058\u571f\u53f0\u306e\u8981\u7d20",
    "AnswerBody": "\u3072\u3068\u3064\u3060\u3051\u5f37\u304f\u3059\u308b\u767a\u60f3\u3088\u308a\u3001\u5168\u4f53\u306e\u30ea\u30ba\u30e0\u3092\u6574\u3048\u308b\u8996\u70b9\u306b\u7acb\u3064\u3002",
    "Headline": [
      "\u7761\u7720 \u98df\u4e8b \u904b\u52d5\u306f",
      "\u6bce\u65e5\u306e\u571f\u53f0\u3068\u3057\u3066",
      "\u3064\u306a\u304c\u3063\u3066\u3044\u307e\u3059\u3002"
    ],
    "Body": [
      "\u30df\u30c8\u30b3\u30f3\u30c9\u30ea\u30a2\u8996\u70b9\u3067\u898b\u308b\u3068\u3001",
      "\u305d\u308c\u305e\u308c\u304c\u5206\u65ad\u3057\u305f\u30bf\u30b9\u30af\u3067\u306f\u306a\u304f\u306a\u308a\u307e\u3059\u3002"
    ]
  },
  {
    "File": "slide-04.png",
    "Variant": "body",
    "Index": "03",
    "PanelKicker": "PRACTICAL",
    "PanelEyebrow": "\u7b54\u3048\u3092\u6025\u304c\u306a\u3044",
    "Note": "GENTLE REVIEW",
    "AnswerLabel": "POINT 03",
    "AnswerTitle": "\u5b8c\u74a7\u306b\u3084\u308b\u3088\u308a\u3001\u3069\u3053\u304c\u4e71\u308c\u3084\u3059\u3044\u304b\u3092\u77e5\u308b",
    "AnswerBody": "\u7761\u7720\u304b\u3001\u98df\u4e8b\u304b\u3001\u904b\u52d5\u304b\u3002\u81ea\u5206\u306e\u30dc\u30c8\u30eb\u30cd\u30c3\u30af\u3092\u9759\u304b\u306b\u898b\u3064\u3051\u308b\u3002",
    "Headline": [
      "\u5b8c\u74a7\u3055\u3088\u308a\u3001",
      "\u81ea\u5206\u306e\u30ea\u30ba\u30e0\u3092",
      "\u898b\u76f4\u3059\u3053\u3068\u304b\u3089\u3002"
    ],
    "Body": [
      "\u3067\u304d\u3066\u3044\u306a\u3044\u3053\u3068\u3092\u63a2\u3059\u3088\u308a\u3001",
      "\u65e5\u3005\u306e\u6d41\u308c\u3092\u3084\u3055\u3057\u304f\u6574\u7406\u3059\u308b\u611f\u899a\u3067\u3002"
    ]
  },
  {
    "File": "slide-05.png",
    "Variant": "close",
    "Index": "05",
    "PanelKicker": "SAVE",
    "PanelEyebrow": "ROUTINE NOTE",
    "Note": "FOR YOUR NEXT CHECK-IN",
    "CloseLabel": "CHECK YOUR ROUTINE",
    "CloseValue": "\u307e\u305a\u306f\u300c\u3064\u306a\u304c\u308a\u300d\u304b\u3089\u898b\u76f4\u3059",
    "Headline": [
      "\u4fdd\u5b58\u3057\u3066\u3001",
      "\u65e5\u3005\u306e\u898b\u76f4\u3057\u306b",
      "\u4f7f\u3063\u3066\u304f\u3060\u3055\u3044\u3002"
    ],
    "Body": [
      "\u30eb\u30fc\u30c6\u30a3\u30f3\u3092\u8cbc\u308a\u66ff\u3048\u308b\u524d\u306b\u3001",
      "\u307e\u305a\u306f\u3064\u306a\u304c\u308a\u3067\u898b\u3066\u307f\u308b\u3002"
    ]
  }
]
'@ | ConvertFrom-Json

foreach ($slide in $slides) {
    $width = 928
    $height = 1152
    $bitmap = New-Object System.Drawing.Bitmap($width, $height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $graphics.Clear([System.Drawing.Color]::FromArgb(234, 240, 244))

    $artboardBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        ([System.Drawing.Point]::new(0, 0)),
        ([System.Drawing.Point]::new(0, $height)),
        [System.Drawing.Color]::FromArgb(238, 244, 247),
        [System.Drawing.Color]::FromArgb(228, 237, 242)
    )
    $graphics.FillRectangle($artboardBrush, 0, 0, $width, $height)

    $cardPath = New-RoundedRectPath -X 14 -Y 14 -Width 900 -Height 1124 -Radius 48
    $cardBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        ([System.Drawing.Point]::new(14, 14)),
        ([System.Drawing.Point]::new(914, 1138)),
        [System.Drawing.Color]::FromArgb(252, 253, 254),
        [System.Drawing.Color]::FromArgb(246, 250, 252)
    )
    $graphics.FillPath($cardBrush, $cardPath)
    $graphics.DrawPath($whitePen, $cardPath)

    $graphics.FillEllipse($mistBrushSoft, 34, 34, 240, 140)
    Draw-HeaderBand -Graphics $graphics -Slide $slide
    Draw-AnswerPanel -Graphics $graphics -Slide $slide

    $headlineY = if ($slide.Variant -eq "cover") { 188 } elseif ($slide.Variant -eq "close") { 322 } else { 300 }
    $headlineX = 82
    $usedHeadlineFont = if ($slide.Variant -eq "cover") { $headlineCoverFont } else { $headlineFont }
    $afterHeadlineY = Draw-LineBlock -Graphics $graphics -Lines $slide.Headline -Font $usedHeadlineFont -Brush $textBrush -X $headlineX -Y $headlineY -LineHeight ($(if ($slide.Variant -eq "cover") { 82 } else { 76 }))
    $bodyY = $afterHeadlineY + 16
    [void](Draw-LineBlock -Graphics $graphics -Lines $slide.Body -Font $bodyFont -Brush $softTextBrush -X $headlineX -Y $bodyY -LineHeight 44)

    $graphics.DrawLine($rulePen, 92, 694, 836, 694)
    $graphics.DrawString([string]$slide.Note, $noteFont, $kickerBrush, 92, 1012)

    $outputPath = Join-Path $outputDir $slide.File
    $bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)

    $graphics.Dispose()
    $bitmap.Dispose()
    $artboardBrush.Dispose()
    $cardBrush.Dispose()
    $cardPath.Dispose()
}

Write-Output "Rendered April 3 routine foundation carousel to $outputDir"
