param(
    [Parameter(Mandatory = $true)]
    [string]$SpecPath
)

Add-Type -AssemblyName System.Drawing

$spec = Get-Content $SpecPath -Raw | ConvertFrom-Json
$targetWidth = 1080
$targetHeight = 1350

function New-RoundedRectanglePath {
    param(
        [System.Drawing.RectangleF]$Rect,
        [float]$Radius
    )

    $diameter = $Radius * 2
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $arc = New-Object System.Drawing.RectangleF($Rect.X, $Rect.Y, $diameter, $diameter)
    $path.AddArc($arc, 180, 90)
    $arc.X = $Rect.Right - $diameter
    $path.AddArc($arc, 270, 90)
    $arc.Y = $Rect.Bottom - $diameter
    $path.AddArc($arc, 0, 90)
    $arc.X = $Rect.X
    $path.AddArc($arc, 90, 90)
    $path.CloseFigure()
    return $path
}

foreach ($frame in $spec.frames) {
    $imagePath = $frame.input
    $outputPath = $frame.output
    $sourceBitmap = [System.Drawing.Bitmap]::FromFile($imagePath)
    $bitmap = New-Object System.Drawing.Bitmap($targetWidth, $targetHeight)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $graphics.DrawImage($sourceBitmap, 0, 0, $targetWidth, $targetHeight)

    $headlineLines = @()
    if ($frame.headlineLines) {
        $headlineLines = @($frame.headlineLines)
    }
    $bodyLines = @()
    if ($frame.bodyLines) {
        $bodyLines = @($frame.bodyLines)
    }

    $headlineFont = New-Object System.Drawing.Font("Yu Gothic UI Semibold", [float]$frame.headlineFontSize, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
    $bodyFont = New-Object System.Drawing.Font("Yu Gothic UI", [float]$frame.bodyFontSize, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
    $headlineBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(250, 44, 50, 58))
    $bodyBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(238, 66, 74, 82))
    $lineGap = [float]$frame.lineGap
    $sectionGap = [float]$frame.sectionGap
    $paddingX = [float]$frame.paddingX
    $paddingY = [float]$frame.paddingY

    $headlineHeight = 0.0
    $headlineMaxWidth = 0.0
    foreach ($line in $headlineLines) {
        $size = $graphics.MeasureString($line, $headlineFont)
        if ($size.Width -gt $headlineMaxWidth) { $headlineMaxWidth = $size.Width }
        $headlineHeight += $headlineFont.GetHeight($graphics) + $lineGap
    }
    if ($headlineLines.Count -gt 0) {
        $headlineHeight -= $lineGap
    }

    $bodyHeight = 0.0
    $bodyMaxWidth = 0.0
    foreach ($line in $bodyLines) {
        $size = $graphics.MeasureString($line, $bodyFont)
        if ($size.Width -gt $bodyMaxWidth) { $bodyMaxWidth = $size.Width }
        $bodyHeight += $bodyFont.GetHeight($graphics) + $lineGap
    }
    if ($bodyLines.Count -gt 0) {
        $bodyHeight -= $lineGap
    }

    $contentWidth = [Math]::Max($headlineMaxWidth, $bodyMaxWidth)
    $contentHeight = $headlineHeight + $bodyHeight
    if ($headlineLines.Count -gt 0 -and $bodyLines.Count -gt 0) {
        $contentHeight += $sectionGap
    }

    $box = $frame.box
    $rectWidth = $contentWidth + ($paddingX * 2)
    $rectHeight = $contentHeight + ($paddingY * 2)
    if ($box.minWidth) {
        $rectWidth = [Math]::Max($rectWidth, [float]$box.minWidth)
    }
    if ($box.minHeight) {
        $rectHeight = [Math]::Max($rectHeight, [float]$box.minHeight)
    }
    if ($box.maxWidth) {
        $rectWidth = [Math]::Min($rectWidth, [float]$box.maxWidth)
    }

    $rect = New-Object System.Drawing.RectangleF(
        [float]$box.x,
        [float]$box.y,
        [float][Math]::Ceiling($rectWidth),
        [float][Math]::Ceiling($rectHeight)
    )

    $shadowRect = New-Object System.Drawing.RectangleF(
        [float]$rect.X,
        [float]($rect.Y + 8),
        [float]$rect.Width,
        [float]$rect.Height
    )
    $shadowPath = New-RoundedRectanglePath -Rect $shadowRect -Radius ([float]$box.radius)
    $shadowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(34, 18, 24, 31))
    $graphics.FillPath($shadowBrush, $shadowPath)

    $panelPath = New-RoundedRectanglePath -Rect $rect -Radius ([float]$box.radius)
    $panelBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(236, 247, 250, 252))
    $graphics.FillPath($panelBrush, $panelPath)
    $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(194, 255, 255, 255), 2)
    $graphics.DrawPath($borderPen, $panelPath)

    $left = $rect.X + $paddingX
    $top = $rect.Y + [float][Math]::Max($paddingY, (($rect.Height - $contentHeight) / 2.0))

    foreach ($line in $headlineLines) {
        $graphics.DrawString($line, $headlineFont, $headlineBrush, $left, $top)
        $top += $headlineFont.GetHeight($graphics) + $lineGap
    }

    if ($bodyLines.Count -gt 0) {
        $top += $sectionGap
        foreach ($line in $bodyLines) {
            $graphics.DrawString($line, $bodyFont, $bodyBrush, $left, $top)
            $top += $bodyFont.GetHeight($graphics) + $lineGap
        }
    }

    $bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)

    $headlineFont.Dispose()
    $bodyFont.Dispose()
    $headlineBrush.Dispose()
    $bodyBrush.Dispose()
    $panelBrush.Dispose()
    $shadowBrush.Dispose()
    $borderPen.Dispose()
    $panelPath.Dispose()
    $shadowPath.Dispose()
    $graphics.Dispose()
    $bitmap.Dispose()
    $sourceBitmap.Dispose()
}
