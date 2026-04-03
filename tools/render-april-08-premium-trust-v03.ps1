param(
    [ValidateSet('default', 'cool_focus', 'warm_editorial')]
    [string]$PaletteVariant = 'warm_editorial',
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
$outputDir = Join-Path $workspaceRoot ("output/instagram/feed/2026-04-08-feed-premium-trust-v03/{0}" -f $OutputSubdir)
$coverImagePath = Join-Path $workspaceRoot 'output/instagram/feed/2026-04-08-feed-premium-trust-v03/source/cover-plate-nanobanana-v03.jpg'

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
$accentPeach = $tokenColors.accent_peach
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
    "Section": "\u4fe1\u983c\u3067\u898b\u308b",
    "Meta": "\u30d7\u30ec\u30df\u30a2\u30e0\u306e\u57fa\u6e96",
    "Headline": [
      "\u30d7\u30ec\u30df\u30a2\u30e0\u306f\u3001",
      "\u898b\u305f\u76ee\u3060\u3051\u3067\u306f",
      "\u6c7a\u307e\u308a\u307e\u305b\u3093\u3002"
    ],
    "Subline": [
      "\u4e0a\u8cea\u3055\u306f\u3001\u8aac\u660e\u306e\u3057\u304b\u305f\u3084",
      "\u7a4d\u307f\u91cd\u306d\u308b\u59ff\u52e2\u306b\u3082\u8868\u308c\u307e\u3059\u3002"
    ],
    "BandLabels": [
      "\u8aac\u660e",
      "\u57fa\u6e96",
      "\u59ff\u52e2"
    ],
    "BandValues": [
      "\u4f55\u3092\u4f1d\u3048\u308b\u304b",
      "\u3069\u3046\u5b88\u308b\u304b",
      "\u3069\u3046\u7d9a\u3051\u308b\u304b"
    ]
  },
  {
    "File": "slide-02.png",
    "Variant": "definition",
    "Section": "\u898b\u65b9\u3092\u5909\u3048\u308b",
    "Meta": "\u307e\u305a\u3053\u3053\u304b\u3089",
    "RailLabel": "\u8996\u70b9",
    "Headline": [
      "\u898b\u305f\u76ee\u306f\u3001",
      "\u304d\u3063\u304b\u3051\u306b\u306f\u306a\u3063\u3066\u3082",
      "\u4fe1\u983c\u305d\u306e\u3082\u306e\u3067\u306f",
      "\u3042\u308a\u307e\u305b\u3093\u3002"
    ],
    "Subline": [
      "\u5b89\u5fc3\u3057\u3066\u9078\u3079\u308b\u304b\u3069\u3046\u304b\u306f\u3001",
      "\u898b\u3048\u306a\u3044\u90e8\u5206\u306e\u6574\u3044\u65b9\u3067\u6c7a\u307e\u308a\u307e\u3059\u3002"
    ],
    "CardTitle": [
      "\u4fe1\u983c\u304c",
      "\u4e0a\u8cea\u3055\u3092\u3064\u304f\u308b"
    ],
    "CardBodyLines": [
      "\u4f55\u304c\u5165\u3063\u3066\u3044\u308b\u304b\u3002",
      "\u3069\u3046\u9078\u3093\u3067\u3044\u308b\u304b\u3002",
      "\u3069\u3046\u5c4a\u3051\u7d9a\u3051\u308b\u304b\u3002",
      "\u305d\u3046\u3057\u305f\u8aac\u660e\u8cac\u4efb\u304c\u3001\u5370\u8c61\u3092\u652f\u3048\u307e\u3059\u3002"
    ]
  },
  {
    "File": "slide-03.png",
    "Variant": "proof-stack",
    "Section": "\u57fa\u6e96\u3067\u898b\u308b",
    "Meta": "\u4fe1\u983c\u306e3\u3064",
    "CenterLabel": "\u4fe1\u983c\u3067\u898b\u308b3\u3064\u306e\u57fa\u6e96",
    "Headline": [
      "\u4e0a\u8cea\u3055\u306f\u3001",
      "\u8aac\u660e\u30fb\u57fa\u6e96\u30fb\u59ff\u52e2\u306e",
      "\u7a4d\u307f\u91cd\u306d\u304b\u3089\u751f\u307e\u308c\u307e\u3059\u3002"
    ],
    "Subline": [
      "\u83ef\u3084\u304b\u3055\u3088\u308a\u3001\u7d0d\u5f97\u3067\u304d\u308b\u7406\u7531\u304c\u3042\u308b\u304b\u3002",
      "\u305d\u306e\u8996\u70b9\u3067\u898b\u308b\u3068\u5224\u65ad\u3057\u3084\u3059\u304f\u306a\u308a\u307e\u3059\u3002"
    ],
    "Stacks": [
      {
        "Label": "\u8aac\u660e",
        "Title": "\u4f55\u304c\u5165\u3063\u3066\u3044\u308b\u304b",
        "BodyLines": [
          "\u6210\u5206\u3084\u80cc\u666f\u3092",
          "\u4f1d\u3048\u308b\u5165\u308a\u53e3"
        ]
      },
      {
        "Label": "\u57fa\u6e96",
        "Title": "\u3069\u3046\u9078\u3093\u3067\u3044\u308b\u304b",
        "BodyLines": [
          "\u54c1\u8cea\u3078\u306e\u8003\u3048\u65b9\u304c",
          "\u898b\u3048\u308b\u57fa\u6e96"
        ]
      },
      {
        "Label": "\u59ff\u52e2",
        "Title": "\u3069\u3046\u7d9a\u3051\u308b\u304b",
        "BodyLines": [
          "\u5c4a\u3051\u65b9\u3068\u4e00\u8cab\u6027\u306b",
          "\u8868\u308c\u308b\u5370\u8c61"
        ]
      }
    ]
  },
  {
    "File": "slide-04.png",
    "Variant": "reading",
    "Section": "\u8aad\u307f\u65b9",
    "Meta": "\u30d6\u30e9\u30f3\u30c9\u306e\u898b\u65b9",
    "Headline": [
      "\u30d6\u30e9\u30f3\u30c9\u3092\u898b\u308b\u3068\u304d\u306f\u3001",
      "\u898b\u305f\u76ee\u3088\u308a",
      "\u4e2d\u8eab\u306e\u6574\u3044\u65b9\u3092\u898b\u308b\u3002"
    ],
    "Subline": [
      "\u6d3e\u624b\u3055\u3088\u308a\u3001\u843d\u3061\u7740\u3044\u3066\u8aac\u660e\u3067\u304d\u3066\u3044\u308b\u304b\u3002",
      "\u305d\u306e\u5dee\u304c\u4fe1\u983c\u611f\u306b\u306a\u308a\u307e\u3059\u3002"
    ],
    "Rows": [
      {
        "Index": "01",
        "Title": "\u8aac\u660e\u304c\u3042\u308b\u304b",
        "BodyLines": [
          "\u4f55\u3092\u9078\u3073\u3001\u306a\u305c\u305d\u3046\u3057\u3066\u3044\u308b\u304b\u304c",
          "\u898b\u3048\u308b\u3068\u5b89\u5fc3\u611f\u304c\u751f\u307e\u308c\u307e\u3059\u3002"
        ]
      },
      {
        "Index": "02",
        "Title": "\u8a00\u8449\u304c\u8aa0\u5b9f\u304b",
        "BodyLines": [
          "\u5927\u304d\u306a\u7d04\u675f\u3088\u308a\u3001",
          "\u4e01\u5be7\u306b\u4f1d\u3048\u308b\u59ff\u52e2\u304c\u898b\u3048\u308b\u304b\u3002"
        ]
      },
      {
        "Index": "03",
        "Title": "\u7d9a\u3051\u65b9\u304c\u4e00\u8cab\u3057\u3066\u3044\u308b\u304b",
        "BodyLines": [
          "\u4eca\u65e5\u3060\u3051\u306e\u898b\u305b\u65b9\u3067\u306a\u304f\u3001",
          "\u7a4d\u307f\u91cd\u306d\u308b\u59ff\u52e2\u304c\u3042\u308b\u304b\u3092\u898b\u308b\u3002"
        ]
      }
    ]
  },
  {
    "File": "slide-05.png",
    "Variant": "close",
    "Section": "\u4fdd\u5b58\u7248",
    "Meta": "\u4fe1\u983c\u306e\u898b\u65b9",
    "Headline": [
      "\u4e0a\u8cea\u3055\u306f\u3001",
      "\u898b\u305b\u65b9\u3088\u308a",
      "\u7a4d\u307f\u91cd\u306d\u3067\u3059\u3002"
    ],
    "Subline": [
      "Mitozz\u306e\u57fa\u6e96\u3092\u77e5\u308b",
      "\u3072\u3068\u3064\u306e\u8996\u70b9\u3068\u3057\u3066\u3002"
    ],
    "CardTitle": "\u307e\u305a\u306f\u4fe1\u983c\u306e\u898b\u65b9\u304b\u3089",
    "CardBodyLines": [
      "\u898b\u305f\u76ee\u306e\u5370\u8c61\u3060\u3051\u3067\u306a\u304f\u3001",
      "\u8aac\u660e\u8cac\u4efb\u3068\u59ff\u52e2\u307e\u3067\u9759\u304b\u306b\u898b\u308b\u3002"
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
            [System.Drawing.Color]::FromArgb(246, 251, 252, 253),
            [System.Drawing.Color]::FromArgb(150, 248, 243, 238),
            0.0
        )
        $graphics.FillRectangle($overlayBrush, 0, 0, 928, 1152)
        $overlayBrush.Dispose()
        $textZoneWash = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(98, 255, 255, 255))
        $graphics.FillRectangle($textZoneWash, 0, 0, 468, 1152)
        $textZoneWash.Dispose()
        $warmLiftBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, $accentPeach))
        $graphics.FillRectangle($warmLiftBrush, 430, 0, 498, 1152)
        $warmLiftBrush.Dispose()
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

            $bandFill = [System.Drawing.Color]::FromArgb(224, $card)
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
            $definitionBodyBlockHeight = Get-StackHeight -LineCounts @($slide.CardTitle.Count, $slide.CardBodyLines.Count) -LineHeights @([float]$roles.panel_title.line_height, [float]$roles.body.line_height) -Gaps @(34)
            $definitionBodyStartY = [float](542 + ((340 - $definitionBodyBlockHeight) / 2) - 6)
            $cardTitleBottom = Draw-TrackedLines -Graphics $graphics -Lines @($slide.CardTitle) -Font $panelTitleFont -Brush $textBrush -X 192 -Y $definitionBodyStartY -LineHeight ([float]$roles.panel_title.line_height) -Tracking $panelTracking
            $graphics.DrawLine($accentPen, 192, ($cardTitleBottom + 16), 392, ($cardTitleBottom + 16))
            [void](Draw-TrackedLines -Graphics $graphics -Lines @($slide.CardBodyLines) -Font $bodyFont -Brush $softBrush -X 192 -Y ($cardTitleBottom + 42) -LineHeight ([float]$roles.body.line_height) -Tracking $bodyTracking)
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
        'proof-stack' {
            $headlineBottom = Draw-TrackedLines -Graphics $graphics -Lines @($slide.Headline) -Font $feedHeadlineFont -Brush $textBrush -X 60 -Y 146 -LineHeight ([float]$roles.feed_headline.line_height) -Tracking $headlineTrackingFeed
            [void](Draw-TrackedLines -Graphics $graphics -Lines @($slide.Subline) -Font $feedSublineFont -Brush $softBrush -X 64 -Y ($headlineBottom + 18) -LineHeight ([float]$roles.feed_subline.line_height) -Tracking $sublineTrackingFeed)

            $pillY = 464
            $pillHeight = 92
            Draw-RoundedBox -Graphics $graphics -X 170 -Y $pillY -Width 588 -Height $pillHeight -Radius 20 -FillColor $atmosphere -StrokeColor $structureLine
            $pillTextY = [float]($pillY + (($pillHeight - [float]$roles.panel_title.line_height) / 2) - 2)
            [void](Draw-TrackedText -Graphics $graphics -Text ([string]$slide.CenterLabel) -Font $panelTitleFont -Brush $textBrush -X 464 -Y $pillTextY -Tracking $panelTracking -Alignment center)

            $stackHeight = 138
            $stackYs = @(586, 744, 902)
            for ($i = 0; $i -lt $slide.Stacks.Count; $i++) {
                $stack = $slide.Stacks[$i]
                $stackY = [float]$stackYs[$i]
                Draw-RoundedBox -Graphics $graphics -X 78 -Y $stackY -Width 772 -Height $stackHeight -Radius 22 -FillColor $card -StrokeColor $structureLine
                $graphics.FillRectangle((New-Object System.Drawing.SolidBrush($atmosphere)), 78, $stackY, 136, $stackHeight)

                $labelBlockHeight = [float]$roles.module_label.line_height
                $labelStartY = [float]($stackY + (($stackHeight - $labelBlockHeight) / 2) - 3)
                [void](Draw-TrackedText -Graphics $graphics -Text ([string]$stack.Label) -Font $moduleLabelFont -Brush $structureBrush -X 146 -Y $labelStartY -Tracking $moduleLabelTracking -Alignment center)

                $rightBlockHeight = Get-StackHeight -LineCounts @(1, $stack.BodyLines.Count) -LineHeights @([float]$roles.module_title.line_height, [float]$roles.body.line_height) -Gaps @(18)
                $rightBlockStartY = [float]($stackY + (($stackHeight - $rightBlockHeight) / 2) - 4)
                [void](Draw-TrackedText -Graphics $graphics -Text ([string]$stack.Title) -Font $moduleTitleFont -Brush $textBrush -X 250 -Y $rightBlockStartY -Tracking $moduleTitleTracking)
                [void](Draw-TrackedLines -Graphics $graphics -Lines @($stack.BodyLines) -Font $bodyFont -Brush $softBrush -X 250 -Y ($rightBlockStartY + [float]$roles.module_title.line_height + 18) -LineHeight ([float]$roles.body.line_height) -Tracking $bodyTracking)
            }
        }
        'reading' {
            $headlineBottom = Draw-TrackedLines -Graphics $graphics -Lines @($slide.Headline) -Font $feedHeadlineFont -Brush $textBrush -X 60 -Y 146 -LineHeight ([float]$roles.feed_headline.line_height) -Tracking $headlineTrackingFeed
            [void](Draw-TrackedLines -Graphics $graphics -Lines @($slide.Subline) -Font $feedSublineFont -Brush $softBrush -X 64 -Y ($headlineBottom + 18) -LineHeight ([float]$roles.feed_subline.line_height) -Tracking $sublineTrackingFeed)

            $rowHeight = 158
            $rowYs = @(560, 740, 920)
            for ($i = 0; $i -lt $slide.Rows.Count; $i++) {
                $row = $slide.Rows[$i]
                $rowY = [float]$rowYs[$i]
                Draw-RoundedBox -Graphics $graphics -X 58 -Y $rowY -Width 812 -Height $rowHeight -Radius 22 -FillColor $card -StrokeColor $structureLine
                $graphics.FillRectangle((New-Object System.Drawing.SolidBrush($atmosphere)), 58, $rowY, 110, $rowHeight)
                $indexBlockHeight = [float]$roles.panel_title.line_height
                $indexStartY = [float]($rowY + (($rowHeight - $indexBlockHeight) / 2) - 4)
                [void](Draw-TrackedText -Graphics $graphics -Text ([string]$row.Index) -Font $panelTitleFont -Brush $textBrush -X 113 -Y $indexStartY -Tracking $panelTracking -Alignment center)
                $rowBlockHeight = Get-StackHeight -LineCounts @(1, $row.BodyLines.Count) -LineHeights @([float]$roles.module_title.line_height, [float]$roles.body.line_height) -Gaps @(18)
                $rowBlockStartY = [float]($rowY + (($rowHeight - $rowBlockHeight) / 2) - 5)
                [void](Draw-TrackedText -Graphics $graphics -Text ([string]$row.Title) -Font $moduleTitleFont -Brush $textBrush -X 208 -Y $rowBlockStartY -Tracking $moduleTitleTracking)
                [void](Draw-TrackedLines -Graphics $graphics -Lines @($row.BodyLines) -Font $bodyFont -Brush $softBrush -X 208 -Y ($rowBlockStartY + [float]$roles.module_title.line_height + 18) -LineHeight ([float]$roles.body.line_height) -Tracking $bodyTracking)
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

Write-Output "Rendered April 8 feed v03 to $outputDir"

