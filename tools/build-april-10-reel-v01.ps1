param()

$root = "C:\Users\esmoresernieryanocam\Desktop\Workspace\Mitozz Japan"
$reelRoot = Join-Path $root "output\instagram\reels\2026-04-10-reel-aging-foundation-v01"
$sourceDir = Join-Path $reelRoot "source"
$editDir = Join-Path $reelRoot "edit"
$productionDir = Join-Path $reelRoot "production"
$framesDir = Join-Path $productionDir "frames-4x5"
$deliveryDir = Join-Path $reelRoot "delivery"
$specPath = Join-Path $reelRoot "edit\overlay-spec.v01.json"
$ffmpeg = Join-Path $root "node_modules\ffmpeg-static\ffmpeg.exe"

function Decode-B64([string]$Value) {
    return [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($Value))
}

New-Item -ItemType Directory -Path $editDir -Force | Out-Null
New-Item -ItemType Directory -Path $productionDir -Force | Out-Null
New-Item -ItemType Directory -Path $framesDir -Force | Out-Null
New-Item -ItemType Directory -Path $deliveryDir -Force | Out-Null

$spec = @{
    frames = @(
        @{
            input = (Join-Path $sourceDir "shot-01-opening-hook.png")
            output = (Join-Path $framesDir "shot-01-opening-hook-4x5.png")
            box = @{ x = 80; y = 78; minWidth = 660; minHeight = 208; maxWidth = 700; radius = 34 }
            paddingX = 34
            paddingY = 34
            headlineFontSize = 64
            bodyFontSize = 32
            lineGap = 4
            sectionGap = 10
            headlineLines = @(
                (Decode-B64 "5bm06b2i44KS6YeN44Gt44Gf5LuK44GT44Gd"),
                (Decode-B64 "5q+O5pel44Gu5Zyf5Y+w44KS6KaL55u044GZ")
            )
            bodyLines = @()
        },
        @{
            input = (Join-Path $sourceDir "shot-02-reframe.png")
            output = (Join-Path $framesDir "shot-02-reframe-4x5.png")
            box = @{ x = 96; y = 82; minWidth = 520; minHeight = 188; maxWidth = 560; radius = 32 }
            paddingX = 30
            paddingY = 30
            headlineFontSize = 58
            bodyFontSize = 30
            lineGap = 4
            sectionGap = 10
            headlineLines = @(
                (Decode-B64 "6Laz44GZ5YmN44Gr"),
                (Decode-B64 "5LuK44Gu5rWB44KM44KS6Kqt44KA")
            )
            bodyLines = @()
        },
        @{
            input = (Join-Path $sourceDir "shot-03-product-reveal.png")
            output = (Join-Path $framesDir "shot-03-product-reveal-4x5.png")
            box = @{ x = 82; y = 78; minWidth = 420; minHeight = 180; maxWidth = 500; radius = 32 }
            paddingX = 30
            paddingY = 30
            headlineFontSize = 52
            bodyFontSize = 30
            lineGap = 4
            sectionGap = 10
            headlineLines = @(
                (Decode-B64 "5pSv44GI44KL6KaW54K544KS"),
                (Decode-B64 "5q+O5pel44Gr")
            )
            bodyLines = @()
        },
        @{
            input = (Join-Path $sourceDir "shot-04-end-frame.png")
            output = (Join-Path $framesDir "shot-04-end-frame-4x5.png")
            box = @{ x = 84; y = 80; minWidth = 460; minHeight = 118; maxWidth = 540; radius = 30 }
            paddingX = 28
            paddingY = 24
            headlineFontSize = 50
            bodyFontSize = 28
            lineGap = 4
            sectionGap = 10
            headlineLines = @((Decode-B64 "5q+O5pel44Gu44Km44Kn44Or44ON44K544KS6Kqt44KA"))
            bodyLines = @()
        }
    )
}

$spec | ConvertTo-Json -Depth 8 | Set-Content -Path $specPath -Encoding UTF8

powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $root "tools\render-reel-frame-overlays.ps1") -SpecPath $specPath

Copy-Item (Join-Path $framesDir "shot-01-opening-hook-4x5.png") (Join-Path $editDir "overlay-01.png") -Force
Copy-Item (Join-Path $framesDir "shot-02-reframe-4x5.png") (Join-Path $editDir "overlay-02.png") -Force
Copy-Item (Join-Path $framesDir "shot-03-product-reveal-4x5.png") (Join-Path $editDir "overlay-03.png") -Force
Copy-Item (Join-Path $framesDir "shot-04-end-frame-4x5.png") (Join-Path $editDir "overlay-04.png") -Force

$finalMp4 = Join-Path $productionDir "April 10, 2026 - Mitozz Reel.mp4"
$altMp4 = Join-Path $productionDir "april-10-aging-foundation-reel-4x5-v01.mp4"
$deliveryMp4 = Join-Path $deliveryDir "2026-04-10-mitozz-feed-reel.mp4"
$filterGraph = "[0:v]scale=1188:1485,crop=1080:1350:x='54-16*(t/2.8)':y='67-8*(t/2.8)'[v0];[1:v]scale=1168:1460,crop=1080:1350:x='44+10*(t/2.4)':y='55-4*(t/2.4)'[v1];[2:v]scale=1188:1485,crop=1080:1350:x='54-10*(t/2.5)':y='67+4*(t/2.5)'[v2];[3:v]scale=1188:1485,crop=1080:1350:x='54+8*(t/3.0)':y='67-6*(t/3.0)'[v3];[v0][v1]xfade=transition=fade:duration=0.35:offset=2.45[x1];[x1][v2]xfade=transition=fade:duration=0.35:offset=4.50[x2];[x2][v3]xfade=transition=fade:duration=0.35:offset=6.65,format=yuv420p[v]"

& $ffmpeg -y `
    -loop 1 -t 2.8 -i (Join-Path $framesDir "shot-01-opening-hook-4x5.png") `
    -loop 1 -t 2.4 -i (Join-Path $framesDir "shot-02-reframe-4x5.png") `
    -loop 1 -t 2.5 -i (Join-Path $framesDir "shot-03-product-reveal-4x5.png") `
    -loop 1 -t 3.0 -i (Join-Path $framesDir "shot-04-end-frame-4x5.png") `
    -filter_complex $filterGraph `
    -map "[v]" `
    -r 30 `
    -c:v libx264 `
    -preset medium `
    -crf 18 `
    -movflags +faststart `
    $finalMp4

Copy-Item $finalMp4 $altMp4 -Force
Copy-Item $finalMp4 $deliveryMp4 -Force
