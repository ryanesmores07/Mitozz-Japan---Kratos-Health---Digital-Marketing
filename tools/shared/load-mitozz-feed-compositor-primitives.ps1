Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

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

    throw "Unable to load requested fonts: $($Families -join ', ')"
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

function Draw-CoverImage {
    param(
        [System.Drawing.Graphics]$Graphics,
        [string]$ImagePath,
        [int]$CanvasWidth,
        [int]$CanvasHeight,
        [float]$ScaleMultiplier = 1,
        [ValidateSet('center', 'right')]
        [string]$HorizontalAnchor = 'center'
    )

    if (-not (Test-Path -LiteralPath $ImagePath)) {
        return
    }

    $image = [System.Drawing.Image]::FromFile($ImagePath)
    try {
        $scale = [Math]::Max($CanvasWidth / $image.Width, $CanvasHeight / $image.Height) * $ScaleMultiplier
        $drawWidth = [float]($image.Width * $scale)
        $drawHeight = [float]($image.Height * $scale)
        if ($HorizontalAnchor -eq 'right') {
            $drawX = [float]($CanvasWidth - $drawWidth)
        }
        else {
            $drawX = [float](($CanvasWidth - $drawWidth) / 2)
        }
        $drawY = [float](($CanvasHeight - $drawHeight) / 2)
        $Graphics.DrawImage($image, $drawX, $drawY, $drawWidth, $drawHeight)
    }
    finally {
        $image.Dispose()
    }
}

function Get-StackHeight {
    param(
        [int[]]$LineCounts,
        [float[]]$LineHeights,
        [float[]]$Gaps
    )

    $total = [float]0
    for ($i = 0; $i -lt $LineCounts.Count; $i++) {
        if ($LineCounts[$i] -gt 0) {
            $total += [float]($LineCounts[$i] * $LineHeights[$i])
        }
        if ($i -lt $Gaps.Count) {
            $total += [float]$Gaps[$i]
        }
    }
    return $total
}
