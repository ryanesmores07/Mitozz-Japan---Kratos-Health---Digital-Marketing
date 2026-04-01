param(
    [ValidateSet('default', 'cool_focus', 'warm_editorial')]
    [string]$PaletteVariant = 'default'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

. (Join-Path $PSScriptRoot 'shared/load-mitozz-design-tokens.ps1')

. (Join-Path $PSScriptRoot 'shared/load-mitozz-design-tokens.ps1')

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$outputDir = Join-Path $workspaceRoot "output/instagram/feed/ig-feed-2026-04-03-routine-foundation-v04/current"

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

    throw "Unable to load requested font families: $($Families -join ', ')"
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
    $d = $Radius * 2
    $path.AddArc($X, $Y, $d, $d, 180, 90)
    $path.AddArc($X + $Width - $d, $Y, $d, $d, 270, 90)
    $path.AddArc($X + $Width - $d, $Y + $Height - $d, $d, $d, 0, 90)
    $path.AddArc($X, $Y + $Height - $d, $d, $d, 90, 90)
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

    $path = New-RoundedRectPath -X $X -Y $Y -Width $Width -Height $Height -Radius $Radius
    $fill = New-Object System.Drawing.SolidBrush($FillColor)
    $stroke = New-Object System.Drawing.Pen($StrokeColor, $StrokeWidth)
    $Graphics.FillPath($fill, $path)
    $Graphics.DrawPath($stroke, $path)
    $fill.Dispose()
    $stroke.Dispose()
    $path.Dispose()
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
        [float]$Height,
        [System.Drawing.StringFormat]$Format
    )

    $rect = New-Object System.Drawing.RectangleF($X, $Y, $Width, $Height)
    $Graphics.DrawString($Text, $Font, $Brush, $rect, $Format)
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

function Draw-BlockLines {
    param(
        [System.Drawing.Graphics]$Graphics,
        [object]$Lines,
        [System.Drawing.Font]$Font,
        [System.Drawing.Brush]$Brush,
        [float]$X,
        [float]$Y,
        [float]$LineHeight
    )

    if ($null -eq $Lines) {
        return $Y
    }

    if ($Lines -is [string]) {
        $lineArray = @([string]$Lines)
    }
    else {
        $lineArray = @($Lines)
    }

    return Draw-Lines -Graphics $Graphics -Lines $lineArray -Font $Font -Brush $Brush -X $X -Y $Y -LineHeight $LineHeight
}

$designTokens = Get-MitozzDesignTokens -Variant $PaletteVariant
$tokenColors = $designTokens.Colors

$designTokens = Get-MitozzDesignTokens -Variant 'default'
$tokenColors = $designTokens.Colors

$headlineCoverFont = New-Font -Families @("Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI") -Size 72 -Style ([System.Drawing.FontStyle]::Bold)
$headlineFont = New-Font -Families @("Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI") -Size 64 -Style ([System.Drawing.FontStyle]::Bold)
$sublineFont = New-Font -Families @("Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI") -Size 28 -Style ([System.Drawing.FontStyle]::Regular)
$bodyFont = New-Font -Families @("Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI") -Size 22 -Style ([System.Drawing.FontStyle]::Regular)
$closeBodyFont = New-Font -Families @("Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI") -Size 20 -Style ([System.Drawing.FontStyle]::Regular)
$smallFont = New-Font -Families @("Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI") -Size 18 -Style ([System.Drawing.FontStyle]::Bold)
$panelTitleFont = New-Font -Families @("Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI") -Size 30 -Style ([System.Drawing.FontStyle]::Bold)
$tileTitleFont = New-Font -Families @("Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI") -Size 20 -Style ([System.Drawing.FontStyle]::Bold)
$rowTitleFont = New-Font -Families @("Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI") -Size 24 -Style ([System.Drawing.FontStyle]::Bold)
$selectorTitleFont = New-Font -Families @("Yu Gothic UI", "Yu Gothic", "Meiryo", "Segoe UI") -Size 24 -Style ([System.Drawing.FontStyle]::Bold)

$charcoal = $tokenColors.text_primary
$softCharcoal = $tokenColors.text_secondary
$mistBlue = $tokenColors.structure
$mistBlueSoft = $tokenColors.atmosphere
$mistBlueLine = $tokenColors.structure_line
$mistBlueFaint = $tokenColors.structure_line_faint
$apricot = $tokenColors.accent_soft
$sand = $tokenColors.neutral_warm
$white = $tokenColors.card
$paper = $tokenColors.paper
$headerWash = $tokenColors.header_wash

$textBrush = New-Object System.Drawing.SolidBrush($charcoal)
$softBrush = New-Object System.Drawing.SolidBrush($softCharcoal)
$blueBrush = New-Object System.Drawing.SolidBrush($mistBlue)
$whiteBrush = New-Object System.Drawing.SolidBrush($white)
$mistBrush = New-Object System.Drawing.SolidBrush($mistBlueSoft)
$sandBrush = New-Object System.Drawing.SolidBrush($sand)
$paperBrush = New-Object System.Drawing.SolidBrush($paper)
$headerBrush = New-Object System.Drawing.SolidBrush($headerWash)
$rulePen = New-Object System.Drawing.Pen($mistBlueLine, 2)
$faintRulePen = New-Object System.Drawing.Pen($mistBlueFaint, 2)
$faintRulePen.DashPattern = @(3, 5)
$accentPen = New-Object System.Drawing.Pen($apricot, 4)
$format = New-Object System.Drawing.StringFormat
$format.Alignment = [System.Drawing.StringAlignment]::Near
$format.LineAlignment = [System.Drawing.StringAlignment]::Near
$centerFormat = New-Object System.Drawing.StringFormat
$centerFormat.Alignment = [System.Drawing.StringAlignment]::Center
$centerFormat.LineAlignment = [System.Drawing.StringAlignment]::Near
$centerMiddleFormat = New-Object System.Drawing.StringFormat
$centerMiddleFormat.Alignment = [System.Drawing.StringAlignment]::Center
$centerMiddleFormat.LineAlignment = [System.Drawing.StringAlignment]::Center

$slides = @'
[
  {
    "File": "slide-01.png",
    "Variant": "cover",
    "Section": "\u6bce\u65e5\u306e\u571f\u53f0",
    "Meta": "\u30df\u30c8\u30b3\u30f3\u30c9\u30ea\u30a2\u8996\u70b9",
    "Headline": ["\u7761\u7720 \u98df\u4e8b \u904b\u52d5\u3092", "\u30df\u30c8\u30b3\u30f3\u30c9\u30ea\u30a2\u8996\u70b9\u3067", "\u898b\u76f4\u3059"],
    "Subline": ["\u5225\u3005\u306b\u6574\u3048\u308b\u3088\u308a\u3001", "\u3072\u3068\u3064\u306e\u571f\u53f0\u3068\u3057\u3066\u898b\u3066\u307f\u308b\u3002"],
    "Tiles": [
      {"Label":"\u7761\u7720","Value":"\u6574\u3048\u308b"},
      {"Label":"\u98df\u4e8b","Value":"\u6e80\u305f\u3059"},
      {"Label":"\u904b\u52d5","Value":"\u52d5\u304b\u3059"}
    ]
  },
  {
    "File": "slide-02.png",
    "Variant": "answer",
    "Section": "\u8003\u3048\u65b9",
    "Meta": "\u3064\u306a\u304c\u308a\u3067\u898b\u308b",
    "Headline": ["\u5225\u3005\u306b\u6574\u3048\u308b\u3088\u308a\u3001", "\u3064\u306a\u304c\u308a\u3067\u898b\u308b\u3053\u3068\u304c", "\u5927\u5207\u3067\u3059\u3002"],
    "Subline": ["\u8abf\u5b50\u306e\u8a71\u306f\u3001", "\u4e00\u3064\u3060\u3051\u306e\u7fd2\u6163\u3067\u6c7a\u307e\u308b\u3082\u306e\u3067\u306f\u3042\u308a\u307e\u305b\u3093\u3002"],
    "CardTitleLines": ["\u3070\u3089\u3070\u3089\u3067\u306f\u306a\u304f\u3001", "\u3072\u3068\u3064\u306e\u571f\u53f0"],
    "CardBody": "\u7761\u7720\u3001\u98df\u4e8b\u3001\u904b\u52d5\u3092\u3064\u306a\u304c\u308a\u306e\u8996\u70b9\u3067\u898b\u308b\u3068\u3001\u6bce\u65e5\u306e\u6d41\u308c\u304c\u6574\u7406\u3057\u3084\u3059\u304f\u306a\u308a\u307e\u3059\u3002"
  },
  {
    "File": "slide-03.png",
    "Variant": "framework",
    "Section": "\u571f\u53f0",
    "Meta": "\u4e09\u3064\u306e\u8981\u7d20",
    "Headline": ["\u7761\u7720\u3001\u98df\u4e8b\u3001\u904b\u52d5\u306f", "\u6bce\u65e5\u3092\u652f\u3048\u308b", "\u540c\u3058\u571f\u53f0\u3067\u3059\u3002"],
    "Subline": ["\u4e09\u3064\u3092\u307e\u3068\u3081\u3066\u898b\u308b\u3068\u3001", "\u65e5\u3005\u306e\u6d41\u308c\u304c\u6574\u7406\u3057\u3084\u3059\u304f\u306a\u308a\u307e\u3059\u3002"],
    "Rows": [
      {"Label":"\u7761\u7720","TitleLines":["\u6d41\u308c\u3092\u6574\u3048\u308b", "\u571f\u53f0"],"Body":"\u7720\u308a\u65b9\u3092\u898b\u308b\u3068\u3001\u7fcc\u65e5\u306e\u571f\u53f0\u306e\u4e71\u308c\u304c\u898b\u3048\u3084\u3059\u304f\u306a\u308a\u307e\u3059\u3002"},
      {"Label":"\u98df\u4e8b","TitleLines":["\u6e80\u305f\u3057\u65b9\u3067", "\u5b89\u5b9a\u611f\u304c\u5909\u308f\u308b"],"Body":"\u4f55\u3092\u3069\u3046\u6e80\u305f\u3057\u3066\u3044\u308b\u304b\u3067\u3001\u6bcf\u65e5\u306e\u6d41\u308c\u306e\u5b89\u5b9a\u611f\u306f\u5909\u308f\u308a\u307e\u3059\u3002"},
      {"Label":"\u904b\u52d5","TitleLines":["\u5168\u4f53\u306e\u30ea\u30ba\u30e0\u3092", "\u652f\u3048\u308b"],"Body":"\u52d5\u304d\u65b9\u3082\u5358\u72ec\u306e\u52aa\u529b\u3067\u306f\u306a\u304f\u3001\u5168\u4f53\u306e\u6d41\u308c\u306e\u4e00\u90e8\u3068\u3057\u3066\u898b\u307e\u3059\u3002"}
    ]
  },
  {
    "File": "slide-04.png",
    "Variant": "selector",
    "Section": "\u898b\u76f4\u3057\u65b9",
    "Meta": "\u3069\u3053\u304b\u3089\u59cb\u3081\u308b\u304b",
    "Headline": ["\u5b8c\u74a7\u3055\u3088\u308a\u3001", "\u3069\u3053\u304b\u3089\u5d29\u308c\u3084\u3059\u3044\u304b\u3092", "\u77e5\u308b\u3053\u3068\u304b\u3089\u3002"],
    "Subline": ["\u4eca\u306e\u81ea\u5206\u306f\u3001", "\u3069\u3053\u304b\u3089\u898b\u76f4\u3059\u3068\u6574\u3044\u3084\u3059\u3044\u304b\u3002"],
    "Tiles": [
      {"Label":"\u7761\u7720","TitleLines":["\u5bdd\u3064\u304d\u3084", "\u8d77\u304d\u65b9\u304c\u4e0d\u5b89\u5b9a"],"BodyLines":["\u6700\u521d\u306b\u6574\u3048\u305f\u3044", "\u5165\u308a\u53e3\u3092\u898b\u3064\u3051\u308b\u3002"]},
      {"Label":"\u98df\u4e8b","TitleLines":["\u6e80\u305f\u3057\u65b9\u306b", "\u3080\u3089\u304c\u3042\u308b"],"BodyLines":["\u4eca\u306e\u6d41\u308c\u3092", "\u9759\u304b\u306b\u78ba\u8a8d\u3059\u308b\u3002"]},
      {"Label":"\u904b\u52d5","TitleLines":["\u52d5\u304f\u4f59\u767d\u304c", "\u53d6\u308a\u306b\u304f\u3044"],"BodyLines":["\u5b8c\u74a7\u3055\u3088\u308a", "\u9806\u756a\u3092\u6c7a\u3081\u308b\u3002"]}
    ]
  },
  {
    "File": "slide-05.png",
    "Variant": "close",
    "Section": "\u4fdd\u5b58\u7248",
    "Meta": "\u30eb\u30fc\u30c6\u30a3\u30f3\u30e1\u30e2",
    "Headline": ["\u4fdd\u5b58\u3057\u3066\u3001", "\u65e5\u3005\u306e\u898b\u76f4\u3057\u306b", "\u4f7f\u3063\u3066\u304f\u3060\u3055\u3044\u3002"],
    "Subline": ["\u307e\u305a\u306f\u300c\u3064\u306a\u304c\u308a\u300d\u304b\u3089", "\u898b\u3066\u307f\u308b\u3002"],
    "CardTitle": "\u307e\u305a\u306f\u300c\u3064\u306a\u304c\u308a\u300d\u304b\u3089\u898b\u76f4\u3059",
    "CardBody": "\u7761\u7720\u3001\u98df\u4e8b\u3001\u904b\u52d5\u3092\u3072\u3068\u3064\u306e\u6d41\u308c\u3068\u3057\u3066\u898b\u308b\u305f\u3081\u306e\u30e1\u30e2\u3002"
  }
]
'@ | ConvertFrom-Json

foreach ($slide in $slides) {
    $width = 928
    $height = 1152
    $bitmap = New-Object System.Drawing.Bitmap($width, $height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $graphics.Clear($white)
    $graphics.FillRectangle($headerBrush, 0, 0, $width, 92)
    $graphics.FillRectangle($paperBrush, 0, 92, $width, $height - 92)

    $graphics.DrawString([string]$slide.Section, $smallFont, $blueBrush, 58, 34)
    $graphics.DrawString([string]$slide.Meta, $smallFont, $blueBrush, 706, 34)

    if ($slide.Variant -eq "cover") {
        $headlineY = Draw-Lines -Graphics $graphics -Lines $slide.Headline -Font $headlineCoverFont -Brush $textBrush -X 66 -Y 164 -LineHeight 80
        [void](Draw-Lines -Graphics $graphics -Lines $slide.Subline -Font $sublineFont -Brush $softBrush -X 70 -Y ($headlineY + 10) -LineHeight 42)

        $graphics.DrawLine($faintRulePen, 188, 514, 188, 784)
        $graphics.DrawLine($faintRulePen, 464, 482, 464, 784)
        $graphics.DrawLine($faintRulePen, 740, 514, 740, 784)

        Draw-RoundedBox -Graphics $graphics -X 48 -Y 834 -Width 832 -Height 172 -Radius 28 -FillColor $mistBlueSoft -StrokeColor $mistBlueLine -StrokeWidth 1
        $graphics.DrawLine($rulePen, 325, 858, 325, 982)
        $graphics.DrawLine($rulePen, 603, 858, 603, 982)

        $coverTileXs = @(86, 370, 646)
        for ($i = 0; $i -lt $slide.Tiles.Count; $i++) {
            $graphics.DrawString([string]$slide.Tiles[$i].Label, $tileTitleFont, $blueBrush, $coverTileXs[$i], 872)
            $graphics.DrawString([string]$slide.Tiles[$i].Value, $panelTitleFont, $textBrush, $coverTileXs[$i], 906)
        }
    }
    elseif ($slide.Variant -eq "answer") {
        $headlineY = Draw-Lines -Graphics $graphics -Lines $slide.Headline -Font $headlineFont -Brush $textBrush -X 62 -Y 154 -LineHeight 74
        [void](Draw-Lines -Graphics $graphics -Lines $slide.Subline -Font $sublineFont -Brush $softBrush -X 66 -Y ($headlineY + 8) -LineHeight 40)

        Draw-RoundedBox -Graphics $graphics -X 56 -Y 560 -Width 816 -Height 380 -Radius 24 -FillColor $white -StrokeColor $mistBlueLine -StrokeWidth 1
        $graphics.FillRectangle($sandBrush, 56, 560, 86, 380)
        Draw-Paragraph -Graphics $graphics -Text "01" -Font $headlineFont -Brush $whiteBrush -X 56 -Y 560 -Width 86 -Height 380 -Format $centerMiddleFormat
        $cardTitleBottom = Draw-BlockLines -Graphics $graphics -Lines $slide.CardTitleLines -Font $panelTitleFont -Brush $textBrush -X 178 -Y 622 -LineHeight 36
        $graphics.DrawLine($accentPen, 178, ($cardTitleBottom + 14), 376, ($cardTitleBottom + 14))
        Draw-Paragraph -Graphics $graphics -Text ([string]$slide.CardBody) -Font $bodyFont -Brush $softBrush -X 178 -Y ($cardTitleBottom + 40) -Width 600 -Height 120 -Format $format
    }
    elseif ($slide.Variant -eq "framework") {
        $headlineY = Draw-Lines -Graphics $graphics -Lines $slide.Headline -Font $headlineFont -Brush $textBrush -X 62 -Y 154 -LineHeight 74
        [void](Draw-Lines -Graphics $graphics -Lines $slide.Subline -Font $sublineFont -Brush $softBrush -X 66 -Y ($headlineY + 8) -LineHeight 40)

        $rowYs = @(540, 694, 848)
        for ($i = 0; $i -lt $slide.Rows.Count; $i++) {
            $rowY = $rowYs[$i]
            Draw-RoundedBox -Graphics $graphics -X 54 -Y $rowY -Width 820 -Height 138 -Radius 22 -FillColor $white -StrokeColor $mistBlueLine
            $graphics.FillRectangle($mistBrush, 54, $rowY, 122, 138)
            Draw-Paragraph -Graphics $graphics -Text ([string]$slide.Rows[$i].Label) -Font $panelTitleFont -Brush $textBrush -X 54 -Y $rowY -Width 122 -Height 138 -Format $centerMiddleFormat
            $rowTitleBottom = Draw-BlockLines -Graphics $graphics -Lines $slide.Rows[$i].TitleLines -Font $rowTitleFont -Brush $textBrush -X 210 -Y ($rowY + 20) -LineHeight 29
            Draw-Paragraph -Graphics $graphics -Text ([string]$slide.Rows[$i].Body) -Font $bodyFont -Brush $softBrush -X 210 -Y ($rowTitleBottom + 10) -Width 590 -Height 52 -Format $format
        }
    }
    elseif ($slide.Variant -eq "selector") {
        $headlineY = Draw-Lines -Graphics $graphics -Lines $slide.Headline -Font $headlineFont -Brush $textBrush -X 62 -Y 154 -LineHeight 72
        [void](Draw-Lines -Graphics $graphics -Lines $slide.Subline -Font $sublineFont -Brush $softBrush -X 66 -Y ($headlineY + 8) -LineHeight 40)

        $tileXs = @(54, 339, 624)
        for ($i = 0; $i -lt $slide.Tiles.Count; $i++) {
            $tileX = $tileXs[$i]
            Draw-RoundedBox -Graphics $graphics -X $tileX -Y 612 -Width 250 -Height 276 -Radius 24 -FillColor $white -StrokeColor $mistBlueLine
            $graphics.FillRectangle($mistBrush, $tileX, 612, 250, 50)
            $graphics.DrawString([string]$slide.Tiles[$i].Label, $tileTitleFont, $blueBrush, $tileX + 22, 626)
            $tileTitleBottom = Draw-BlockLines -Graphics $graphics -Lines $slide.Tiles[$i].TitleLines -Font $selectorTitleFont -Brush $textBrush -X ($tileX + 24) -Y 684 -LineHeight 31
            [void](Draw-BlockLines -Graphics $graphics -Lines $slide.Tiles[$i].BodyLines -Font $bodyFont -Brush $softBrush -X ($tileX + 24) -Y ($tileTitleBottom + 18) -LineHeight 28)
        }
    }
    else {
        $headlineY = Draw-Lines -Graphics $graphics -Lines $slide.Headline -Font $headlineFont -Brush $textBrush -X 62 -Y 182 -LineHeight 74
        [void](Draw-Lines -Graphics $graphics -Lines $slide.Subline -Font $sublineFont -Brush $softBrush -X 66 -Y ($headlineY + 8) -LineHeight 40)

        Draw-RoundedBox -Graphics $graphics -X 54 -Y 734 -Width 820 -Height 210 -Radius 24 -FillColor $mistBlueSoft -StrokeColor $mistBlueLine
        Draw-Paragraph -Graphics $graphics -Text ([string]$slide.CardTitle) -Font $panelTitleFont -Brush $textBrush -X 96 -Y 792 -Width 736 -Height 40 -Format $centerFormat
        $graphics.DrawLine($accentPen, 300, 850, 628, 850)
        Draw-Paragraph -Graphics $graphics -Text ([string]$slide.CardBody) -Font $closeBodyFont -Brush $softBrush -X 94 -Y 868 -Width 740 -Height 28 -Format $centerFormat
    }

    $outputPath = Join-Path $outputDir $slide.File
    $bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bitmap.Dispose()
}

$textBrush.Dispose()
$softBrush.Dispose()
$blueBrush.Dispose()
$whiteBrush.Dispose()
$mistBrush.Dispose()
$sandBrush.Dispose()
$paperBrush.Dispose()
$headerBrush.Dispose()
$rulePen.Dispose()
$faintRulePen.Dispose()
$accentPen.Dispose()
$format.Dispose()
$centerFormat.Dispose()
$centerMiddleFormat.Dispose()
$headlineCoverFont.Dispose()
$headlineFont.Dispose()
$sublineFont.Dispose()
$bodyFont.Dispose()
$closeBodyFont.Dispose()
$smallFont.Dispose()
$panelTitleFont.Dispose()
$tileTitleFont.Dispose()
$rowTitleFont.Dispose()
$selectorTitleFont.Dispose()

Write-Output "Rendered April 3 routine foundation carousel to $outputDir"
