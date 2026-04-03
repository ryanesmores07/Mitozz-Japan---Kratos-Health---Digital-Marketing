param(
    [ValidateSet('default', 'cool_focus', 'warm_editorial')]
    [string]$PaletteVariant = 'cool_focus',
    [ValidateSet('mitozz_sans', 'humanist_sans', 'editorial_serif')]
    [string]$FontProfile = 'humanist_sans',
    [string]$OutputSubdir = 'current'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing

. (Join-Path $PSScriptRoot 'shared/load-mitozz-design-tokens.ps1')
. (Join-Path $PSScriptRoot 'shared/load-mitozz-typography-tokens.ps1')
. (Join-Path $PSScriptRoot 'shared/load-mitozz-feed-compositor-primitives.ps1')

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$outputDir = Join-Path $workspaceRoot ("output/instagram/feed/2026-04-06-feed-supporting-mitochondria-v03/{0}" -f $OutputSubdir)
$coverImagePath = Join-Path $workspaceRoot 'output/instagram/feed/2026-04-06-feed-supporting-mitochondria-v03/source/cover-plate-nanobanana-v01.jpg'

if (-not (Test-Path -LiteralPath $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

$designTokens = Get-MitozzDesignTokens -Variant $PaletteVariant
$tokenColors = $designTokens.Colors
$typography = Get-MitozzTypographyTokens
$fontProfileConfig = Get-MitozzFontProfileConfig -Profile $FontProfile
$safeArea = $typography.safe_area
$roles = $typography.roles
$headlineFamilies = [string[]]$fontProfileConfig.headline_families
$bodyFamilies = [string[]]$fontProfileConfig.body_families
$sizeAdjustments = $fontProfileConfig.size_adjustments
$headlineCoverSize = [float]($roles.cover_headline.font_size + $sizeAdjustments.cover_headline)
$headlineFeedSize = [float]($roles.feed_headline.font_size + $sizeAdjustments.feed_headline)
$sublineCoverSize = [float]$roles.cover_subline.font_size
$sublineFeedSize = [float]$roles.feed_subline.font_size
$panelTitleSize = [float]$roles.panel_title.font_size
$moduleLabelSize = [float]$roles.module_label.font_size
$moduleTitleSize = [float]$roles.module_title.font_size
$bodySize = [float]$roles.body.font_size
$metaSize = [float]$roles.meta.font_size
$closeTitleSize = [float]($roles.close_title.font_size + $sizeAdjustments.close_title)

$coverHeadlineFont = New-Font -Families $headlineFamilies -Size $headlineCoverSize -Style ([System.Drawing.FontStyle]::Bold)
$feedHeadlineFont = New-Font -Families $headlineFamilies -Size $headlineFeedSize -Style ([System.Drawing.FontStyle]::Bold)
$coverSublineFont = New-Font -Families $bodyFamilies -Size $sublineCoverSize -Style ([System.Drawing.FontStyle]::Regular)
$feedSublineFont = New-Font -Families $bodyFamilies -Size $sublineFeedSize -Style ([System.Drawing.FontStyle]::Regular)
$panelTitleFont = New-Font -Families $bodyFamilies -Size $panelTitleSize -Style ([System.Drawing.FontStyle]::Bold)
$moduleLabelFont = New-Font -Families $bodyFamilies -Size $moduleLabelSize -Style ([System.Drawing.FontStyle]::Bold)
$moduleTitleFont = New-Font -Families $bodyFamilies -Size $moduleTitleSize -Style ([System.Drawing.FontStyle]::Bold)
$bodyFont = New-Font -Families $bodyFamilies -Size $bodySize -Style ([System.Drawing.FontStyle]::Regular)
$metaFont = New-Font -Families $bodyFamilies -Size $metaSize -Style ([System.Drawing.FontStyle]::Bold)
$closeTitleFont = New-Font -Families $headlineFamilies -Size $closeTitleSize -Style ([System.Drawing.FontStyle]::Bold)

$headlineTrackingCover = [float]$roles.cover_headline.tracking
$headlineTrackingFeed = [float]$roles.feed_headline.tracking
$sublineTrackingCover = [float]$roles.cover_subline.tracking
$sublineTrackingFeed = [float]$roles.feed_subline.tracking
$panelTracking = [float]$roles.panel_title.tracking
$moduleLabelTracking = [float]$roles.module_label.tracking
$moduleTitleTracking = [float]$roles.module_title.tracking
$bodyTracking = [float]$roles.body.tracking
$metaTracking = [float]$roles.meta.tracking
$closeTracking = [float]$roles.close_title.tracking

$charcoal = $tokenColors.text_primary
$softCharcoal = $tokenColors.text_secondary
$structure = $tokenColors.structure
$atmosphere = $tokenColors.atmosphere
$structureLine = $tokenColors.structure_line
$structureLineFaint = $tokenColors.structure_line_faint
$card = $tokenColors.card
$paper = $tokenColors.paper
$headerWash = $tokenColors.header_wash
$accentSignal = $tokenColors.accent_signal

$textBrush = New-Object System.Drawing.SolidBrush($charcoal)
$softBrush = New-Object System.Drawing.SolidBrush($softCharcoal)
$structureBrush = New-Object System.Drawing.SolidBrush($structure)
$paperBrush = New-Object System.Drawing.SolidBrush($paper)
$headerBrush = New-Object System.Drawing.SolidBrush($headerWash)

$rulePen = New-Object System.Drawing.Pen($structureLine, 2)
$faintRulePen = New-Object System.Drawing.Pen($structureLineFaint, 2)
$faintRulePen.DashPattern = @(3, 5)
$accentPen = New-Object System.Drawing.Pen($accentSignal, 3)
$metaRightX = [float](928 - 58)

$slides = @'
[
  {
    "File": "slide-01.png",
    "Variant": "cover-image",
    "Section": "\u30df\u30c8\u30b3\u30f3\u30c9\u30ea\u30a2\u8996\u70b9",
    "Meta": "\u3084\u3055\u3057\u304f\u77e5\u308b",
    "Headline": [
      "\u30df\u30c8\u30b3\u30f3\u30c9\u30ea\u30a2\u3092",
      "\u652f\u3048\u308b\u3063\u3066",
      "\u3069\u3046\u3044\u3046\u3053\u3068\uff1f"
    ],
    "Subline": [
      "\u7279\u5225\u306a\u3053\u3068\u3092\u8db3\u3059\u524d\u306b\u3001",
      "\u307e\u305a\u306f\u571f\u53f0\u306e\u898b\u65b9\u3092\u6574\u3048\u308b\u3002"
    ],
    "BandLabels": [
      "\u4f11\u307f\u65b9",
      "\u6e80\u305f\u3057\u65b9",
      "\u52d5\u304d\u65b9"
    ],
    "BandValues": [
      "\u571f\u53f0\u3092\u898b\u308b",
      "\u6d41\u308c\u3092\u6574\u3048\u308b",
      "\u30ea\u30ba\u30e0\u3092\u652f\u3048\u308b"
    ]
  },
  {
    "File": "slide-02.png",
    "Variant": "definition",
    "Section": "\u8a00\u3044\u63db\u3048\u308b",
    "Meta": "\u307e\u305a\u3053\u3053\u304b\u3089",
    "RailLabel": "\u610f\u5473",
    "Headline": [
      "\u300c\u652f\u3048\u308b\u300d\u306f\u3001",
      "\u4f55\u304b\u3072\u3068\u3064\u3067\u5909\u3048\u308b",
      "\u3068\u3044\u3046\u610f\u5473\u3067\u306f",
      "\u3042\u308a\u307e\u305b\u3093\u3002"
    ],
    "Subline": [
      "\u8a00\u8449\u3092\u5927\u304d\u304f\u3059\u308b\u3088\u308a\u3001",
      "\u610f\u5473\u3092\u65e5\u5e38\u306b\u623b\u3057\u3066\u8003\u3048\u308b\u3002"
    ],
    "CardTitle": [
      "\u6761\u4ef6\u3092\u6574\u3048\u308b",
      "\u8996\u70b9\u3067\u3059"
    ],
    "CardBodyLines": [
      "\u7761\u7720\u3001\u98df\u4e8b\u3001\u904b\u52d5\u3001\u65e5\u3005\u306e\u30ea\u30ba\u30e0\u3002",
      "\u305d\u3046\u3057\u305f\u6761\u4ef6\u3092\u843d\u3061\u7740\u3044\u3066\u898b\u76f4\u3059\u3053\u3068\u304c\u3001",
      "\u3053\u3053\u3067\u8a00\u3046\u300c\u652f\u3048\u308b\u300d\u306b\u8fd1\u3044\u8003\u3048\u65b9\u3067\u3059\u3002"
    ]
  },
  {
    "File": "slide-03.png",
    "Variant": "model",
    "Section": "\u6761\u4ef6\u3067\u898b\u308b",
    "Meta": "\u65e5\u5e38\u306e\u571f\u53f0",
    "CenterLabel": "\u6574\u3048\u305f\u3044\u306e\u306f\u300c\u6761\u4ef6\u300d",
    "Headline": [
      "\u7761\u7720\u3001\u98df\u4e8b\u3001\u904b\u52d5\u306f",
      "\u540c\u3058\u571f\u53f0\u3092\u652f\u3048\u308b",
      "\u65e5\u5e38\u306e\u6761\u4ef6\u3067\u3059\u3002"
    ],
    "Subline": [
      "\u300c\u523a\u6fc0\u300d\u3088\u308a\u300c\u6761\u4ef6\u300d\u3067\u8003\u3048\u308b\u3068\u3001",
      "\u8a00\u8449\u306e\u610f\u5473\u304c\u3088\u308a\u73fe\u5b9f\u7684\u306b\u306a\u308a\u307e\u3059\u3002"
    ],
    "Columns": [
      {
        "Label": "\u7761\u7720",
        "Title": "\u4f11\u307f\u65b9\u3092\u898b\u308b",
        "BodyLines": [
          "\u7fcc\u65e5\u306e\u571f\u53f0\u3092",
          "\u8aad\u3080\u5165\u308a\u53e3"
        ]
      },
      {
        "Label": "\u98df\u4e8b",
        "Title": "\u6e80\u305f\u3057\u65b9\u3092\u898b\u308b",
        "BodyLines": [
          "\u5b89\u5b9a\u611f\u306e\u6d41\u308c\u3092",
          "\u6574\u3048\u308b\u898b\u65b9"
        ]
      },
      {
        "Label": "\u904b\u52d5",
        "Title": "\u52d5\u304d\u65b9\u3092\u898b\u308b",
        "BodyLines": [
          "\u5168\u4f53\u306e\u30ea\u30ba\u30e0\u3092",
          "\u652f\u3048\u308b\u8996\u70b9"
        ]
      }
    ]
  },
  {
    "File": "slide-04.png",
    "Variant": "reading",
    "Section": "\u8aad\u307f\u65b9",
    "Meta": "\u65e5\u5e38\u306b\u623b\u3059",
    "Headline": [
      "\u96e3\u3057\u3044\u4ed5\u7d44\u307f\u3092",
      "\u899a\u3048\u308b\u3088\u308a\u3001",
      "\u6bce\u65e5\u306e\u72b6\u614b\u3092",
      "\u3069\u3046\u8aad\u3080\u304b\u304c",
      "\u5148\u3067\u3059\u3002"
    ],
    "Subline": [
      "\u307e\u305a\u306f\u5909\u3048\u308b\u3053\u3068\u3088\u308a\u3001",
      "\u4eca\u306e\u6d41\u308c\u3092\u9759\u304b\u306b\u898b\u308b\u3002"
    ],
    "Rows": [
      {
        "Index": "01",
        "Title": "\u7761\u7720\u3092\u898b\u308b",
        "BodyLines": [
          "\u5bdd\u3064\u304d\u3001\u8d77\u304d\u65b9\u3001\u7fcc\u671d\u306e\u91cd\u3055\u3002",
          "\u307e\u305a\u306f\u6d41\u308c\u306e\u59cb\u307e\u308a\u3092\u78ba\u8a8d\u3059\u308b\u3002"
        ]
      },
      {
        "Index": "02",
        "Title": "\u98df\u4e8b\u3092\u898b\u308b",
        "BodyLines": [
          "\u4f55\u3092\u3069\u3046\u6e80\u305f\u3057\u3066\u3044\u308b\u304b\u3002",
          "\u3080\u3089\u3084\u629c\u3051\u3092\u9759\u304b\u306b\u898b\u76f4\u3059\u3002"
        ]
      },
      {
        "Index": "03",
        "Title": "\u904b\u52d5\u3092\u898b\u308b",
        "BodyLines": [
          "\u9811\u5f35\u308b\u91cf\u3088\u308a\u3001\u52d5\u304f\u4f59\u767d\u304c\u3042\u308b\u304b\u3092",
          "\u78ba\u304b\u3081\u308b\u3002"
        ]
      }
    ]
  },
  {
    "File": "slide-05.png",
    "Variant": "close",
    "Section": "\u4fdd\u5b58\u7248",
    "Meta": "\u30eb\u30fc\u30c6\u30a3\u30f3\u30e1\u30e2",
    "Headline": [
      "\u30df\u30c8\u30b3\u30f3\u30c9\u30ea\u30a2\u8996\u70b9\u306f\u3001",
      "\u65e5\u5e38\u306e\u571f\u53f0\u3092",
      "\u898b\u76f4\u3059\u305f\u3081\u306e",
      "\u8003\u3048\u65b9\u3067\u3059\u3002"
    ],
    "Subline": [
      "\u4fdd\u5b58\u3057\u3066\u3001",
      "\u3042\u3068\u3067\u3084\u3055\u3057\u304f\u898b\u8fd4\u3059\u3002"
    ],
    "CardTitle": "\u307e\u305a\u306f\u571f\u53f0\u306e\u898b\u65b9\u304b\u3089",
    "CardBodyLines": [
      "\u6bce\u65e5\u306e\u6761\u4ef6\u3092\u4e00\u3064\u306e\u6d41\u308c\u3068\u3057\u3066",
      "\u898b\u76f4\u3059\u305f\u3081\u306e\u9759\u304b\u306a\u30e1\u30e2\u3002"
    ]
  }
]
'@ | ConvertFrom-Json

foreach ($slide in $slides) {
    $bitmap = New-Object System.Drawing.Bitmap(928, 1152)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $graphics.Clear($card)

    if ([string]$slide.Variant -eq 'cover-image') {
        Draw-CoverImage -Graphics $graphics -ImagePath $coverImagePath -CanvasWidth 928 -CanvasHeight 1152
        $overlayRect = New-Object System.Drawing.RectangleF(0, 0, 928, 1152)
        $overlayBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
            $overlayRect,
            [System.Drawing.Color]::FromArgb(250, 251, 253, 255),
            [System.Drawing.Color]::FromArgb(152, 247, 250, 252),
            0.0
        )
        $graphics.FillRectangle($overlayBrush, 0, 0, 928, 1152)
        $overlayBrush.Dispose()
        $textZoneWash = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(84, 255, 255, 255))
        $graphics.FillRectangle($textZoneWash, 0, 0, 468, 1152)
        $textZoneWash.Dispose()
        $coolLiftBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(32, $atmosphere))
        $graphics.FillRectangle($coolLiftBrush, 430, 0, 498, 1152)
        $coolLiftBrush.Dispose()
        $headerTint = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(110, $headerWash))
        $graphics.FillRectangle($headerTint, 0, 0, 928, [int]$safeArea.top_band_height)
        $headerTint.Dispose()
    }
    else {
        $graphics.FillRectangle($headerBrush, 0, 0, 928, [int]$safeArea.top_band_height)
        $graphics.FillRectangle($paperBrush, 0, [int]$safeArea.top_band_height, 928, 1152 - [int]$safeArea.top_band_height)
    }

    [void](Draw-TrackedText -Graphics $graphics -Text ([string]$slide.Section) -Font $metaFont -Brush $structureBrush -X 58 -Y 34 -Tracking $metaTracking)
    [void](Draw-TrackedText -Graphics $graphics -Text ([string]$slide.Meta) -Font $metaFont -Brush $structureBrush -X $metaRightX -Y 34 -Tracking $metaTracking -Alignment right)

    switch ([string]$slide.Variant) {
        'cover' {
            $headlineBottom = Draw-TrackedLines -Graphics $graphics -Lines @($slide.Headline) -Font $coverHeadlineFont -Brush $textBrush -X 60 -Y 168 -LineHeight ([float]$roles.cover_headline.line_height) -Tracking $headlineTrackingCover
            [void](Draw-TrackedLines -Graphics $graphics -Lines @($slide.Subline) -Font $coverSublineFont -Brush $softBrush -X 64 -Y ($headlineBottom + 20) -LineHeight ([float]$roles.cover_subline.line_height) -Tracking $sublineTrackingCover)

            $graphics.DrawLine($faintRulePen, 154, 478, 154, 744)
            $graphics.DrawLine($faintRulePen, 464, 458, 464, 758)
            $graphics.DrawLine($faintRulePen, 774, 478, 774, 744)

            Draw-RoundedBox -Graphics $graphics -X 52 -Y 772 -Width 824 -Height 204 -Radius 28 -FillColor $atmosphere -StrokeColor $structureLine
            $graphics.DrawLine($rulePen, 326, 804, 326, 944)
            $graphics.DrawLine($rulePen, 602, 804, 602, 944)

            $centers = @(188, 464, 740)
            for ($i = 0; $i -lt 3; $i++) {
                [void](Draw-TrackedText -Graphics $graphics -Text ([string]$slide.BandLabels[$i]) -Font $moduleLabelFont -Brush $structureBrush -X $centers[$i] -Y 850 -Tracking $moduleLabelTracking -Alignment center)
                [void](Draw-TrackedText -Graphics $graphics -Text ([string]$slide.BandValues[$i]) -Font $moduleTitleFont -Brush $textBrush -X $centers[$i] -Y 904 -Tracking $moduleTitleTracking -Alignment center)
            }
        }
        'cover-image' {
            $headlineBottom = Draw-TrackedLines -Graphics $graphics -Lines @($slide.Headline) -Font $coverHeadlineFont -Brush $textBrush -X 62 -Y 168 -LineHeight ([float]$roles.cover_headline.line_height) -Tracking $headlineTrackingCover
            [void](Draw-TrackedLines -Graphics $graphics -Lines @($slide.Subline) -Font $coverSublineFont -Brush $softBrush -X 66 -Y ($headlineBottom + 22) -LineHeight ([float]$roles.cover_subline.line_height) -Tracking $sublineTrackingCover)

            $bandFill = [System.Drawing.Color]::FromArgb(212, $card)
            Draw-RoundedBox -Graphics $graphics -X 52 -Y 782 -Width 824 -Height 194 -Radius 28 -FillColor $bandFill -StrokeColor $structureLine
            $graphics.DrawLine($rulePen, 326, 814, 326, 942)
            $graphics.DrawLine($rulePen, 602, 814, 602, 942)

            $centers = @(188, 464, 740)
            $groupHeight = Get-StackHeight -LineCounts @(1, 1) -LineHeights @([float]$roles.module_label.line_height, [float]$roles.module_title.line_height) -Gaps @(24)
            $groupStartY = [float](782 + ((194 - $groupHeight) / 2) - 2)
            for ($i = 0; $i -lt 3; $i++) {
                [void](Draw-TrackedText -Graphics $graphics -Text ([string]$slide.BandLabels[$i]) -Font $moduleLabelFont -Brush $structureBrush -X $centers[$i] -Y $groupStartY -Tracking $moduleLabelTracking -Alignment center)
                [void](Draw-TrackedText -Graphics $graphics -Text ([string]$slide.BandValues[$i]) -Font $moduleTitleFont -Brush $textBrush -X $centers[$i] -Y ($groupStartY + [float]$roles.module_label.line_height + 24) -Tracking $moduleTitleTracking -Alignment center)
            }
        }
        'definition' {
            $headlineBottom = Draw-TrackedLines -Graphics $graphics -Lines @($slide.Headline) -Font $feedHeadlineFont -Brush $textBrush -X 60 -Y 154 -LineHeight ([float]$roles.feed_headline.line_height) -Tracking $headlineTrackingFeed
            [void](Draw-TrackedLines -Graphics $graphics -Lines @($slide.Subline) -Font $feedSublineFont -Brush $softBrush -X 64 -Y ($headlineBottom + 18) -LineHeight ([float]$roles.feed_subline.line_height) -Tracking $sublineTrackingFeed)

            Draw-RoundedBox -Graphics $graphics -X 60 -Y 542 -Width 808 -Height 340 -Radius 24 -FillColor $card -StrokeColor $structureLine
            $graphics.FillRectangle((New-Object System.Drawing.SolidBrush($atmosphere)), 60, 542, 96, 340)
            [void](Draw-TrackedText -Graphics $graphics -Text ([string]$slide.RailLabel) -Font $panelTitleFont -Brush $textBrush -X 108 -Y 684 -Tracking $panelTracking -Alignment center)
            $cardTitleBottom = Draw-TrackedLines -Graphics $graphics -Lines @($slide.CardTitle) -Font $panelTitleFont -Brush $textBrush -X 192 -Y 610 -LineHeight ([float]$roles.panel_title.line_height) -Tracking $panelTracking
            $graphics.DrawLine($accentPen, 192, ($cardTitleBottom + 18), 392, ($cardTitleBottom + 18))
            [void](Draw-TrackedLines -Graphics $graphics -Lines @($slide.CardBodyLines) -Font $bodyFont -Brush $softBrush -X 192 -Y ($cardTitleBottom + 44) -LineHeight ([float]$roles.body.line_height) -Tracking $bodyTracking)
        }
        'model' {
            $headlineBottom = Draw-TrackedLines -Graphics $graphics -Lines @($slide.Headline) -Font $feedHeadlineFont -Brush $textBrush -X 60 -Y 146 -LineHeight ([float]$roles.feed_headline.line_height) -Tracking $headlineTrackingFeed
            [void](Draw-TrackedLines -Graphics $graphics -Lines @($slide.Subline) -Font $feedSublineFont -Brush $softBrush -X 64 -Y ($headlineBottom + 18) -LineHeight ([float]$roles.feed_subline.line_height) -Tracking $sublineTrackingFeed)

            Draw-RoundedBox -Graphics $graphics -X 164 -Y 478 -Width 600 -Height 72 -Radius 18 -FillColor $atmosphere -StrokeColor $structureLine
            [void](Draw-TrackedText -Graphics $graphics -Text ([string]$slide.CenterLabel) -Font $panelTitleFont -Brush $textBrush -X 464 -Y 498 -Tracking $panelTracking -Alignment center)

            Draw-RoundedBox -Graphics $graphics -X 56 -Y 604 -Width 816 -Height 274 -Radius 24 -FillColor $card -StrokeColor $structureLine
            $graphics.DrawLine($rulePen, 328, 640, 328, 850)
            $graphics.DrawLine($rulePen, 600, 640, 600, 850)

            $columnCenters = @(192, 464, 736)
            for ($i = 0; $i -lt $slide.Columns.Count; $i++) {
                $column = $slide.Columns[$i]
                $columnHeight = Get-StackHeight -LineCounts @(1, 1, $column.BodyLines.Count) -LineHeights @([float]$roles.module_label.line_height, [float]$roles.module_title.line_height, [float]$roles.body.line_height) -Gaps @(26, 24)
                $columnStartY = [float](604 + ((274 - $columnHeight) / 2) - 6)
                [void](Draw-TrackedText -Graphics $graphics -Text ([string]$column.Label) -Font $moduleLabelFont -Brush $structureBrush -X $columnCenters[$i] -Y $columnStartY -Tracking $moduleLabelTracking -Alignment center)
                [void](Draw-TrackedText -Graphics $graphics -Text ([string]$column.Title) -Font $moduleTitleFont -Brush $textBrush -X $columnCenters[$i] -Y ($columnStartY + [float]$roles.module_label.line_height + 26) -Tracking $moduleTitleTracking -Alignment center)
                [void](Draw-TrackedLines -Graphics $graphics -Lines @($column.BodyLines) -Font $bodyFont -Brush $softBrush -X $columnCenters[$i] -Y ($columnStartY + [float]$roles.module_label.line_height + 26 + [float]$roles.module_title.line_height + 24) -LineHeight ([float]$roles.body.line_height) -Tracking $bodyTracking -Alignment center)
            }
        }
        'reading' {
            $headlineBottom = Draw-TrackedLines -Graphics $graphics -Lines @($slide.Headline) -Font $feedHeadlineFont -Brush $textBrush -X 60 -Y 146 -LineHeight ([float]$roles.feed_headline.line_height) -Tracking $headlineTrackingFeed
            [void](Draw-TrackedLines -Graphics $graphics -Lines @($slide.Subline) -Font $feedSublineFont -Brush $softBrush -X 64 -Y ($headlineBottom + 18) -LineHeight ([float]$roles.feed_subline.line_height) -Tracking $sublineTrackingFeed)

            $rowYs = @(566, 732, 898)
            for ($i = 0; $i -lt $slide.Rows.Count; $i++) {
                $row = $slide.Rows[$i]
                $rowY = [float]$rowYs[$i]
                Draw-RoundedBox -Graphics $graphics -X 58 -Y $rowY -Width 812 -Height 142 -Radius 22 -FillColor $card -StrokeColor $structureLine
                $graphics.FillRectangle((New-Object System.Drawing.SolidBrush($atmosphere)), 58, $rowY, 110, 142)
                [void](Draw-TrackedText -Graphics $graphics -Text ([string]$row.Index) -Font $panelTitleFont -Brush $textBrush -X 113 -Y ($rowY + 54) -Tracking $panelTracking -Alignment center)
                $rowBlockHeight = Get-StackHeight -LineCounts @(1, $row.BodyLines.Count) -LineHeights @([float]$roles.module_title.line_height, [float]$roles.body.line_height) -Gaps @(20)
                $rowBlockStartY = [float]($rowY + ((142 - $rowBlockHeight) / 2) - 4)
                [void](Draw-TrackedText -Graphics $graphics -Text ([string]$row.Title) -Font $moduleTitleFont -Brush $textBrush -X 208 -Y $rowBlockStartY -Tracking $moduleTitleTracking)
                [void](Draw-TrackedLines -Graphics $graphics -Lines @($row.BodyLines) -Font $bodyFont -Brush $softBrush -X 208 -Y ($rowBlockStartY + [float]$roles.module_title.line_height + 20) -LineHeight ([float]$roles.body.line_height) -Tracking $bodyTracking)
            }
        }
        'close' {
            $headlineBottom = Draw-TrackedLines -Graphics $graphics -Lines @($slide.Headline) -Font $feedHeadlineFont -Brush $textBrush -X 60 -Y 152 -LineHeight ([float]$roles.feed_headline.line_height) -Tracking $headlineTrackingFeed
            [void](Draw-TrackedLines -Graphics $graphics -Lines @($slide.Subline) -Font $feedSublineFont -Brush $softBrush -X 64 -Y ($headlineBottom + 20) -LineHeight ([float]$roles.feed_subline.line_height) -Tracking $sublineTrackingFeed)

            Draw-RoundedBox -Graphics $graphics -X 104 -Y 558 -Width 720 -Height 244 -Radius 28 -FillColor $card -StrokeColor $structureLine
            $closeBlockHeight = Get-StackHeight -LineCounts @(1, $slide.CardBodyLines.Count) -LineHeights @([float]$roles.close_title.line_height, [float]$roles.body.line_height) -Gaps @(34, 32)
            $closeBlockStartY = [float](558 + ((244 - $closeBlockHeight) / 2) - 6)
            [void](Draw-TrackedText -Graphics $graphics -Text ([string]$slide.CardTitle) -Font $closeTitleFont -Brush $textBrush -X 464 -Y $closeBlockStartY -Tracking $closeTracking -Alignment center)
            $ruleY = [float]($closeBlockStartY + [float]$roles.close_title.line_height + 34)
            $graphics.DrawLine($accentPen, 312, $ruleY, 616, $ruleY)
            [void](Draw-TrackedLines -Graphics $graphics -Lines @($slide.CardBodyLines) -Font $bodyFont -Brush $softBrush -X 464 -Y ($ruleY + 32) -LineHeight ([float]$roles.body.line_height) -Tracking $bodyTracking -Alignment center)
        }
    }

    $outputPath = Join-Path $outputDir ([string]$slide.File)
    $bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bitmap.Dispose()
}

$textBrush.Dispose()
$softBrush.Dispose()
$structureBrush.Dispose()
$paperBrush.Dispose()
$headerBrush.Dispose()
$rulePen.Dispose()
$faintRulePen.Dispose()
$accentPen.Dispose()
$coverHeadlineFont.Dispose()
$feedHeadlineFont.Dispose()
$coverSublineFont.Dispose()
$feedSublineFont.Dispose()
$panelTitleFont.Dispose()
$moduleLabelFont.Dispose()
$moduleTitleFont.Dispose()
$bodyFont.Dispose()
$metaFont.Dispose()
$closeTitleFont.Dispose()

Write-Output "Rendered April 6 feed v03 to $outputDir"

