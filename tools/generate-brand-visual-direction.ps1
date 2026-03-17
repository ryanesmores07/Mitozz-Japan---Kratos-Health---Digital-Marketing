param(
    [string]$SourcePath = "C:\Users\esmoresernieryanocam\Desktop\Workspace\Nano banana\brand\references\business-context\visual\Brand Visual Direction.md",
    [string]$OutputPdf = "C:\Users\esmoresernieryanocam\Desktop\Workspace\Nano banana\brand\references\business-context\visual\Brand Visual Direction.pdf"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function ConvertTo-PdfText {
    param([string]$Text)
    if ($null -eq $Text) { return "" }
    $escaped = $Text.Replace('\', '\\').Replace('(', '\(').Replace(')', '\)')
    return $escaped
}

function Add-Object {
    param(
        [System.Collections.Generic.List[string]]$Objects,
        [string]$Content
    )
    $Objects.Add($Content) | Out-Null
    return $Objects.Count
}

function New-TextLine {
    param(
        [double]$X,
        [double]$Y,
        [string]$Font,
        [double]$Size,
        [double[]]$Color,
        [string]$Text
    )
    $r = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.###}", $Color[0])
    $g = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.###}", $Color[1])
    $b = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.###}", $Color[2])
    $xFmt = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.##}", $X)
    $yFmt = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.##}", $Y)
    $sizeFmt = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.##}", $Size)
    return "BT /$Font $sizeFmt Tf $r $g $b rg 1 0 0 1 $xFmt $yFmt Tm (" + (ConvertTo-PdfText $Text) + ") Tj ET"
}

function New-FillRect {
    param(
        [double]$X,
        [double]$Y,
        [double]$Width,
        [double]$Height,
        [double[]]$Color
    )
    $vals = @($Color[0], $Color[1], $Color[2], $X, $Y, $Width, $Height) | ForEach-Object {
        [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.###}", $_)
    }
    return "$($vals[0]) $($vals[1]) $($vals[2]) rg $($vals[3]) $($vals[4]) $($vals[5]) $($vals[6]) re f"
}

function New-StrokeRect {
    param(
        [double]$X,
        [double]$Y,
        [double]$Width,
        [double]$Height,
        [double[]]$Color,
        [double]$LineWidth = 1
    )
    $vals = @($Color[0], $Color[1], $Color[2], $LineWidth, $X, $Y, $Width, $Height) | ForEach-Object {
        [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.###}", $_)
    }
    return "$($vals[3]) w $($vals[0]) $($vals[1]) $($vals[2]) RG $($vals[4]) $($vals[5]) $($vals[6]) $($vals[7]) re S"
}

function New-WrappedText {
    param(
        [string]$Text,
        [double]$X,
        [double]$Y,
        [double]$Width,
        [string]$Font,
        [double]$Size,
        [double]$Leading,
        [double[]]$Color
    )

    $maxChars = [Math]::Max(18, [Math]::Floor($Width / ($Size * 0.54)))
    $words = $Text -split '\s+'
    $lines = New-Object System.Collections.Generic.List[string]
    $current = ""

    foreach ($word in $words) {
        if ([string]::IsNullOrWhiteSpace($current)) {
            $candidate = $word
        } else {
            $candidate = "$current $word"
        }

        if ($candidate.Length -le $maxChars) {
            $current = $candidate
        } else {
            if (-not [string]::IsNullOrWhiteSpace($current)) {
                $lines.Add($current) | Out-Null
            }
            $current = $word
        }
    }

    if (-not [string]::IsNullOrWhiteSpace($current)) {
        $lines.Add($current) | Out-Null
    }

    $commands = New-Object System.Collections.Generic.List[string]
    $cursorY = $Y
    foreach ($line in $lines) {
        $commands.Add((New-TextLine -X $X -Y $cursorY -Font $Font -Size $Size -Color $Color -Text $line)) | Out-Null
        $cursorY -= $Leading
    }

    return @{
        Commands = $commands
        NextY = $cursorY
        Height = $Leading * $lines.Count
    }
}

function Add-Section {
    param(
        [System.Collections.Generic.List[string]]$Commands,
        [double]$PageWidth,
        [double]$Left,
        [ref]$Y,
        [string]$Title,
        [string[]]$BodyLines
    )

    $steel = @(0.435, 0.529, 0.580)
    $navy = @(0.137, 0.196, 0.231)
    $peach = @(0.969, 0.898, 0.863)
    $lineY = $Y.Value + 4
    $Commands.Add((New-FillRect -X $Left -Y ($lineY - 2) -Width 28 -Height 2 -Color $steel)) | Out-Null
    $Commands.Add((New-TextLine -X ($Left + 36) -Y $Y.Value -Font "F2" -Size 16 -Color $navy -Text $Title)) | Out-Null
    $Y.Value -= 24

    foreach ($line in $BodyLines) {
        if ($line.StartsWith("- ")) {
            $wrap = New-WrappedText -Text $line.Substring(2) -X ($Left + 14) -Y $Y.Value -Width ($PageWidth - $Left - 70) -Font "F1" -Size 11 -Leading 15 -Color $navy
            $Commands.Add((New-FillRect -X $Left -Y ($Y.Value + 3) -Width 6 -Height 6 -Color $peach)) | Out-Null
            foreach ($cmd in $wrap.Commands) { $Commands.Add($cmd) | Out-Null }
            $Y.Value = $wrap.NextY - 3
        } else {
            $wrap = New-WrappedText -Text $line -X $Left -Y $Y.Value -Width ($PageWidth - $Left - 56) -Font "F1" -Size 11 -Leading 15 -Color $navy
            foreach ($cmd in $wrap.Commands) { $Commands.Add($cmd) | Out-Null }
            $Y.Value = $wrap.NextY - 3
        }
    }

    $Y.Value -= 8
}

$pageWidth = 595
$pageHeight = 842
$white = @(0.969, 0.980, 0.988)
$mist = @(0.863, 0.910, 0.933)
$steel = @(0.435, 0.529, 0.580)
$navy = @(0.137, 0.196, 0.231)
$apricot = @(0.957, 0.541, 0.353)
$peach = @(0.969, 0.898, 0.863)
$silver = @(0.933, 0.949, 0.957)

$sourceText = Get-Content -LiteralPath $SourcePath -Raw

$pages = New-Object System.Collections.Generic.List[string]

# Page 1 cover
$cover = New-Object System.Collections.Generic.List[string]
$cover.Add((New-FillRect -X 0 -Y 0 -Width $pageWidth -Height $pageHeight -Color $white)) | Out-Null
$cover.Add((New-FillRect -X 40 -Y 738 -Width 190 -Height 64 -Color $mist)) | Out-Null
$cover.Add((New-FillRect -X 385 -Y 110 -Width 150 -Height 210 -Color $mist)) | Out-Null
$cover.Add((New-FillRect -X 425 -Y 150 -Width 90 -Height 150 -Color $apricot)) | Out-Null
$cover.Add((New-FillRect -X 455 -Y 86 -Width 80 -Height 18 -Color $peach)) | Out-Null
$cover.Add((New-TextLine -X 58 -Y 773 -Font "F2" -Size 13 -Color $steel -Text "Nano Banana / Instagram")) | Out-Null
$cover.Add((New-TextLine -X 58 -Y 660 -Font "F2" -Size 28 -Color $navy -Text "Brand Visual Direction")) | Out-Null
$cover.Add((New-TextLine -X 58 -Y 628 -Font "F3" -Size 18 -Color $apricot -Text "Steel light with warm vitamin energy")) | Out-Null
$coverWrap = New-WrappedText -Text "A lean visual guide for planning and executing premium, save-worthy Instagram creatives." -X 58 -Y 585 -Width 280 -Font "F1" -Size 13 -Leading 18 -Color $navy
foreach ($cmd in $coverWrap.Commands) { $cover.Add($cmd) | Out-Null }
$cover.Add((New-TextLine -X 58 -Y 120 -Font "F1" -Size 11 -Color $steel -Text "Soft science. Quiet confidence. Clear visual consistency.")) | Out-Null
$pages.Add(($cover -join "`n")) | Out-Null

# Page 2 direction
$p2 = New-Object System.Collections.Generic.List[string]
$p2.Add((New-FillRect -X 0 -Y 0 -Width $pageWidth -Height $pageHeight -Color $white)) | Out-Null
$p2.Add((New-FillRect -X 0 -Y 786 -Width $pageWidth -Height 56 -Color $mist)) | Out-Null
$p2.Add((New-TextLine -X 42 -Y 808 -Font "F2" -Size 22 -Color $navy -Text "01  Core Direction")) | Out-Null
$y2 = 744
Add-Section -Commands $p2 -PageWidth $pageWidth -Left 42 -Y ([ref]$y2) -Title "Brand Mood" -BodyLines @(
    "The references point to a restrained, luminous beauty language: pale cool backgrounds, soft product glow, editorial spacing, and a warm orange accent that feels active rather than loud.",
    "Recommended theme name: Steel Light.",
    "Mood sentence: Soft science, clear skin, quiet confidence."
)
Add-Section -Commands $p2 -PageWidth $pageWidth -Left 42 -Y ([ref]$y2) -Title "What The Feed Should Feel Like" -BodyLines @(
    "- airy",
    "- clinical but not cold",
    "- premium but not intimidating",
    "- modern Japanese skincare with editorial restraint",
    "- calm, luminous, and touchable"
)
Add-Section -Commands $p2 -PageWidth $pageWidth -Left 42 -Y ([ref]$y2) -Title "Key Decision" -BodyLines @(
    "Use steel-blue as the atmospheric base and apricot-orange as the energy signal. This is stronger than a pure blue direction because it adds memorability, warmth, and better product emphasis for organic social."
)
$pages.Add(($p2 -join "`n")) | Out-Null

# Page 3 palette and typography
$p3 = New-Object System.Collections.Generic.List[string]
$p3.Add((New-FillRect -X 0 -Y 0 -Width $pageWidth -Height $pageHeight -Color $white)) | Out-Null
$p3.Add((New-FillRect -X 0 -Y 786 -Width $pageWidth -Height 56 -Color $mist)) | Out-Null
$p3.Add((New-TextLine -X 42 -Y 808 -Font "F2" -Size 22 -Color $navy -Text "02  Palette + Typography")) | Out-Null
$p3.Add((New-TextLine -X 42 -Y 742 -Font "F2" -Size 16 -Color $navy -Text "Color System")) | Out-Null

$swatches = @(
    @{ Label = "Cloud White"; Hex = "#F7FAFC"; Color = $white; X = 42; Y = 668 },
    @{ Label = "Mist Blue"; Hex = "#DCE8EE"; Color = $mist; X = 170; Y = 668 },
    @{ Label = "Steel Blue"; Hex = "#6F8794"; Color = $steel; X = 298; Y = 668 },
    @{ Label = "Apricot Glow"; Hex = "#F48A5A"; Color = $apricot; X = 426; Y = 668 },
    @{ Label = "Mineral Navy"; Hex = "#22323B"; Color = $navy; X = 42; Y = 560 },
    @{ Label = "Soft Peach"; Hex = "#F7E5DC"; Color = $peach; X = 170; Y = 560 },
    @{ Label = "Frost Silver"; Hex = "#EEF2F4"; Color = $silver; X = 298; Y = 560 }
)

foreach ($swatch in $swatches) {
    $p3.Add((New-FillRect -X $swatch.X -Y $swatch.Y -Width 96 -Height 72 -Color $swatch.Color)) | Out-Null
    $p3.Add((New-StrokeRect -X $swatch.X -Y $swatch.Y -Width 96 -Height 72 -Color $mist -LineWidth 0.6)) | Out-Null
    $p3.Add((New-TextLine -X ($swatch.X) -Y ($swatch.Y - 16) -Font "F2" -Size 10 -Color $navy -Text $swatch.Label)) | Out-Null
    $p3.Add((New-TextLine -X ($swatch.X) -Y ($swatch.Y - 30) -Font "F1" -Size 10 -Color $steel -Text $swatch.Hex)) | Out-Null
}

$usageWrap = New-WrappedText -Text "Suggested use ratio: 60% white space, 20% mist blue atmosphere, 10% steel blue structure, 8% apricot highlights, 2% mineral navy anchors." -X 42 -Y 486 -Width 500 -Font "F1" -Size 11 -Leading 15 -Color $navy
foreach ($cmd in $usageWrap.Commands) { $p3.Add($cmd) | Out-Null }

$p3.Add((New-TextLine -X 42 -Y 414 -Font "F2" -Size 16 -Color $navy -Text "Typography")) | Out-Null
$typographyLines = @(
    "Keep the system to two families.",
    "Primary body and Japanese copy: Noto Sans JP Regular / Medium / Bold.",
    "Editorial accent for English titles and premium moments: Cormorant Garamond SemiBold / Italic.",
    "Use the serif only for short accents. Keep educational body copy in Noto Sans JP."
)
$y3 = 386
foreach ($line in $typographyLines) {
    $wrap = New-WrappedText -Text $line -X 42 -Y $y3 -Width 500 -Font "F1" -Size 11 -Leading 15 -Color $navy
    foreach ($cmd in $wrap.Commands) { $p3.Add($cmd) | Out-Null }
    $y3 = $wrap.NextY - 5
}
$p3.Add((New-TextLine -X 42 -Y 170 -Font "F3" -Size 18 -Color $apricot -Text "Elegant restraint beats decorative excess.")) | Out-Null
$pages.Add(($p3 -join "`n")) | Out-Null

# Page 4 instagram system
$p4 = New-Object System.Collections.Generic.List[string]
$p4.Add((New-FillRect -X 0 -Y 0 -Width $pageWidth -Height $pageHeight -Color $white)) | Out-Null
$p4.Add((New-FillRect -X 0 -Y 786 -Width $pageWidth -Height 56 -Color $mist)) | Out-Null
$p4.Add((New-TextLine -X 42 -Y 808 -Font "F2" -Size 22 -Color $navy -Text "03  Instagram Design System")) | Out-Null
$y4 = 744
Add-Section -Commands $p4 -PageWidth $pageWidth -Left 42 -Y ([ref]$y4) -Title "Three Visual Modes" -BodyLines @(
    "- cool product light",
    "- white editorial education",
    "- warm human or expert trust"
)
Add-Section -Commands $p4 -PageWidth $pageWidth -Left 42 -Y ([ref]$y4) -Title "Recommended Post Types" -BodyLines @(
    "- educational carousels",
    "- luminous product hero posts",
    "- expert credibility cards",
    "- ingredient explainers",
    "- routine and how-to posts",
    "- clean testimonial portraits"
)
Add-Section -Commands $p4 -PageWidth $pageWidth -Left 42 -Y ([ref]$y4) -Title "Cover Slide Rules" -BodyLines @(
    "- one headline only",
    "- one product or one supporting visual",
    "- large white or pale background",
    "- sparing accent color",
    "- promise should feel save-worthy, not salesy"
)
$pages.Add(($p4 -join "`n")) | Out-Null

# Page 5 composition and art direction
$p5 = New-Object System.Collections.Generic.List[string]
$p5.Add((New-FillRect -X 0 -Y 0 -Width $pageWidth -Height $pageHeight -Color $white)) | Out-Null
$p5.Add((New-FillRect -X 0 -Y 786 -Width $pageWidth -Height 56 -Color $mist)) | Out-Null
$p5.Add((New-TextLine -X 42 -Y 808 -Font "F2" -Size 22 -Color $navy -Text "04  Art Direction Rules")) | Out-Null
$y5 = 744
Add-Section -Commands $p5 -PageWidth $pageWidth -Left 42 -Y ([ref]$y5) -Title "Composition" -BodyLines @(
    "- use large margins",
    "- let product occupy 25% to 45% of the frame",
    "- centered or slightly offset layouts work best",
    "- use soft glow and subtle reflections",
    "- avoid hard drop shadows and visual clutter"
)
Add-Section -Commands $p5 -PageWidth $pageWidth -Left 42 -Y ([ref]$y5) -Title "People and Product" -BodyLines @(
    "- calm expressions and clean poses",
    "- natural makeup and quiet luxury styling",
    "- diffused daylight or soft studio light",
    "- minimal props and frosted surfaces",
    "- skin should look real, not over-retouched"
)
Add-Section -Commands $p5 -PageWidth $pageWidth -Left 42 -Y ([ref]$y5) -Title "Avoid" -BodyLines @(
    "- dark moody scenes",
    "- trend-collage graphics",
    "- crowded layouts",
    "- loud stickers, badges, or icons",
    "- aggressive before/after aesthetics"
)
$pages.Add(($p5 -join "`n")) | Out-Null

# Page 6 growth rules
$p6 = New-Object System.Collections.Generic.List[string]
$p6.Add((New-FillRect -X 0 -Y 0 -Width $pageWidth -Height $pageHeight -Color $white)) | Out-Null
$p6.Add((New-FillRect -X 0 -Y 786 -Width $pageWidth -Height 56 -Color $mist)) | Out-Null
$p6.Add((New-TextLine -X 42 -Y 808 -Font "F2" -Size 22 -Color $navy -Text "05  Organic Growth Guidance")) | Out-Null
$y6 = 744
Add-Section -Commands $p6 -PageWidth $pageWidth -Left 42 -Y ([ref]$y6) -Title "Content Mix" -BodyLines @(
    "- 70% education",
    "- 20% authority and trust",
    "- 10% conversion"
)
Add-Section -Commands $p6 -PageWidth $pageWidth -Left 42 -Y ([ref]$y6) -Title "What Drives Saves and Shares" -BodyLines @(
    "- start with a problem, payoff, or myth",
    "- keep each slide focused on one idea",
    "- make slides two to five genuinely useful",
    "- use recognizable layouts even without the logo",
    "- end with a light save or share prompt"
)
Add-Section -Commands $p6 -PageWidth $pageWidth -Left 42 -Y ([ref]$y6) -Title "Recommended Grid Rhythm" -BodyLines @(
    "Rotate educational white cards, cool product heroes, expert or human trust posts, ingredient explainers, and ritual visuals in a repeating nine-post sequence."
)
$p6.Add((New-FillRect -X 42 -Y 136 -Width 511 -Height 74 -Color $mist)) | Out-Null
$p6.Add((New-TextLine -X 58 -Y 182 -Font "F2" -Size 14 -Color $navy -Text "Working shorthand")) | Out-Null
$p6.Add((New-TextLine -X 58 -Y 158 -Font "F3" -Size 17 -Color $apricot -Text "Luminous clinical minimalism with warm vitamin energy.")) | Out-Null
$pages.Add(($p6 -join "`n")) | Out-Null

# Page 7 checklist
$p7 = New-Object System.Collections.Generic.List[string]
$p7.Add((New-FillRect -X 0 -Y 0 -Width $pageWidth -Height $pageHeight -Color $white)) | Out-Null
$p7.Add((New-FillRect -X 0 -Y 786 -Width $pageWidth -Height 56 -Color $mist)) | Out-Null
$p7.Add((New-TextLine -X 42 -Y 808 -Font "F2" -Size 22 -Color $navy -Text "06  Production Checklist")) | Out-Null
$checkLines = @(
    "- Does the frame breathe?",
    "- Is there only one main message?",
    "- Is the steel-blue atmosphere present?",
    "- Is apricot used as a signal, not a flood?",
    "- Is the product glow soft and premium?",
    "- Is the copy short enough for mobile?",
    "- Would someone save this for later?",
    "- Does it still look like the brand without relying on the logo?"
)
$y7 = 728
foreach ($line in $checkLines) {
    $p7.Add((New-FillRect -X 42 -Y ($y7 - 4) -Width 10 -Height 10 -Color $peach)) | Out-Null
    $wrap = New-WrappedText -Text $line.Substring(2) -X 62 -Y $y7 -Width 470 -Font "F1" -Size 12 -Leading 18 -Color $navy
    foreach ($cmd in $wrap.Commands) { $p7.Add($cmd) | Out-Null }
    $y7 = $wrap.NextY - 10
}
$p7.Add((New-TextLine -X 42 -Y 176 -Font "F2" -Size 16 -Color $navy -Text "Final Recommendation")) | Out-Null
$finalWrap = New-WrappedText -Text "Move forward with a steel-blue-led direction elevated by soft apricot warmth. It best matches the references while giving the brand scientific trust, premium clarity, and a distinctive organic social presence." -X 42 -Y 148 -Width 500 -Font "F1" -Size 11 -Leading 15 -Color $navy
foreach ($cmd in $finalWrap.Commands) { $p7.Add($cmd) | Out-Null }
$pages.Add(($p7 -join "`n")) | Out-Null

$objects = New-Object System.Collections.Generic.List[string]
$catalogId = 0
$pagesId = 0

$font1 = Add-Object -Objects $objects -Content "<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>"
$font2 = Add-Object -Objects $objects -Content "<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold >>"
$font3 = Add-Object -Objects $objects -Content "<< /Type /Font /Subtype /Type1 /BaseFont /Times-Italic >>"

$pageIds = New-Object System.Collections.Generic.List[int]

foreach ($pageContent in $pages) {
    $streamBytes = [System.Text.Encoding]::ASCII.GetBytes($pageContent)
    $streamId = Add-Object -Objects $objects -Content ("<< /Length " + $streamBytes.Length + " >>`nstream`n" + $pageContent + "`nendstream")
    $pageObj = "<< /Type /Page /Parent __PAGES__ 0 R /MediaBox [0 0 $pageWidth $pageHeight] /Resources << /Font << /F1 $font1 0 R /F2 $font2 0 R /F3 $font3 0 R >> >> /Contents $streamId 0 R >>"
    $pageId = Add-Object -Objects $objects -Content $pageObj
    $pageIds.Add($pageId) | Out-Null
}

$kids = ($pageIds | ForEach-Object { "$_ 0 R" }) -join " "
$pagesId = Add-Object -Objects $objects -Content "<< /Type /Pages /Count $($pageIds.Count) /Kids [ $kids ] >>"

for ($i = 0; $i -lt $objects.Count; $i++) {
    $objects[$i] = $objects[$i].Replace("__PAGES__", [string]$pagesId)
}

$catalogId = Add-Object -Objects $objects -Content "<< /Type /Catalog /Pages $pagesId 0 R >>"

$builder = New-Object System.Text.StringBuilder
[void]$builder.Append("%PDF-1.4`n")
$offsets = New-Object System.Collections.Generic.List[int]
$offsets.Add(0) | Out-Null

for ($i = 0; $i -lt $objects.Count; $i++) {
    $offsets.Add($builder.Length) | Out-Null
    [void]$builder.Append(($i + 1).ToString())
    [void]$builder.Append(" 0 obj`n")
    [void]$builder.Append($objects[$i])
    [void]$builder.Append("`nendobj`n")
}

$xrefStart = $builder.Length
[void]$builder.Append("xref`n")
[void]$builder.Append("0 ")
[void]$builder.Append(($objects.Count + 1).ToString())
[void]$builder.Append("`n")
[void]$builder.Append("0000000000 65535 f `n")
for ($i = 1; $i -lt $offsets.Count; $i++) {
    [void]$builder.Append(($offsets[$i].ToString("0000000000")))
    [void]$builder.Append(" 00000 n `n")
}
[void]$builder.Append("trailer`n")
[void]$builder.Append("<< /Size ")
[void]$builder.Append(($objects.Count + 1).ToString())
[void]$builder.Append(" /Root ")
[void]$builder.Append($catalogId.ToString())
[void]$builder.Append(" 0 R >>`n")
[void]$builder.Append("startxref`n")
[void]$builder.Append($xrefStart.ToString())
[void]$builder.Append("`n%%EOF")

[System.IO.File]::WriteAllBytes($OutputPdf, [System.Text.Encoding]::ASCII.GetBytes($builder.ToString()))

Write-Output "Created PDF: $OutputPdf"
