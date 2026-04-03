param(
    [Parameter(Mandatory = $true)]
    [string]$TemplatePath,

    [Parameter(Mandatory = $true)]
    [string]$DataPath,

    [Parameter(Mandatory = $true)]
    [string]$HtmlOutputPath,

    [string]$ImageOutputPath,

    [ValidateSet("winforms", "edge", "chrome", "auto")]
    [string]$Browser = "auto",

    [ValidateSet("default", "cool_focus", "warm_editorial")]
    [string]$PaletteVariant = "default",

    [ValidateSet('mitozz_sans', 'humanist_sans', 'editorial_serif')]
    [string]$FontProfile = 'mitozz_sans'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing
. (Join-Path $PSScriptRoot "shared/load-mitozz-design-tokens.ps1")
. (Join-Path $PSScriptRoot "shared/load-mitozz-typography-tokens.ps1")

function Resolve-BrowserPath {
    param([string]$RequestedBrowser)

    $edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    $chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
    $macEdgePath = "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
    $macChromePath = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

    if ($RequestedBrowser -eq "edge") {
        if (Test-Path $edgePath) { return $edgePath }
        if (Test-Path $macEdgePath) { return $macEdgePath }
        throw "Edge not found."
    }

    if ($RequestedBrowser -eq "chrome") {
        if (Test-Path $chromePath) { return $chromePath }
        if (Test-Path $macChromePath) { return $macChromePath }
        throw "Chrome not found."
    }

    if (Test-Path $edgePath) { return $edgePath }
    if (Test-Path $chromePath) { return $chromePath }
    if (Test-Path $macEdgePath) { return $macEdgePath }
    if (Test-Path $macChromePath) { return $macChromePath }

    throw "No supported browser found for headless rendering."
}

function Convert-PathToFileUri {
    param([string]$PathValue)
    $resolved = Resolve-Path -LiteralPath $PathValue
    return ([System.Uri]$resolved.Path).AbsoluteUri
}

function Render-WithWinForms {
    param(
        [string]$HtmlPath,
        [string]$OutputPath,
        [int]$Width,
        [int]$Height
    )

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $script:renderComplete = $false

    $form = New-Object System.Windows.Forms.Form
    $form.Width = $Width
    $form.Height = $Height
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::Manual
    $form.Location = New-Object System.Drawing.Point(-32000, -32000)
    $form.ShowInTaskbar = $false

    $browser = New-Object System.Windows.Forms.WebBrowser
    $browser.ScriptErrorsSuppressed = $true
    $browser.ScrollBarsEnabled = $false
    $browser.Width = $Width
    $browser.Height = $Height

    $browser.Add_DocumentCompleted({
        if ($browser.ReadyState -eq [System.Windows.Forms.WebBrowserReadyState]::Complete) {
            $script:renderComplete = $true
        }
    })

    $form.Controls.Add($browser)
    $form.Show()

    $htmlUri = ([System.Uri](Resolve-Path -LiteralPath $HtmlPath).Path).AbsoluteUri
    $browser.Navigate($htmlUri)

    $timeoutAt = (Get-Date).AddSeconds(15)
    while (-not $script:renderComplete) {
        [System.Windows.Forms.Application]::DoEvents()
        Start-Sleep -Milliseconds 50
        if ((Get-Date) -gt $timeoutAt) {
            throw "Timed out waiting for WebBrowser render."
        }
    }

    Start-Sleep -Milliseconds 250
    [System.Windows.Forms.Application]::DoEvents()

    $bitmap = New-Object System.Drawing.Bitmap($Width, $Height)
    $rectangle = New-Object System.Drawing.Rectangle(0, 0, $Width, $Height)
    $browser.DrawToBitmap($bitmap, $rectangle)
    $bitmap.Save((Resolve-Path -LiteralPath (Split-Path -Parent $OutputPath)).Path + "\" + (Split-Path -Leaf $OutputPath), [System.Drawing.Imaging.ImageFormat]::Png)

    $bitmap.Dispose()
    $browser.Dispose()
    $form.Close()
    $form.Dispose()
}

function Expand-DataPaths {
    param([object]$Node)

    if ($null -eq $Node) { return $Node }

    if ($Node -is [pscustomobject]) {
        foreach ($property in $Node.PSObject.Properties) {
            if ($property.Name -eq "path") {
                $pathValue = [string]$property.Value
                if (-not [string]::IsNullOrWhiteSpace($pathValue)) {
                    $uriValue = Convert-PathToFileUri -PathValue $pathValue
                    if ($Node.PSObject.Properties.Match("uri").Count -gt 0) {
                        $Node.uri = $uriValue
                    }
                    else {
                        $Node | Add-Member -NotePropertyName "uri" -NotePropertyValue $uriValue
                    }
                }
            }
            else {
                $property.Value = Expand-DataPaths -Node $property.Value
            }
        }

        return $Node
    }

    if ($Node -is [System.Collections.IDictionary]) {
        if ($Node.Contains("path")) {
            $pathValue = [string]$Node["path"]
            if (-not [string]::IsNullOrWhiteSpace($pathValue)) {
                $Node["uri"] = Convert-PathToFileUri -PathValue $pathValue
            }
        }

        foreach ($key in @($Node.Keys)) {
            $Node[$key] = Expand-DataPaths -Node $Node[$key]
        }
        return $Node
    }

    if ($Node -is [System.Collections.IEnumerable] -and -not ($Node -is [string])) {
        $items = New-Object System.Collections.ArrayList
        foreach ($item in $Node) {
            [void]$items.Add((Expand-DataPaths -Node $item))
        }
        return ,$items
    }

    return $Node
}

$templateFullPath = (Resolve-Path -LiteralPath $TemplatePath).Path
$dataFullPath = (Resolve-Path -LiteralPath $DataPath).Path
$cssFullPath = (Resolve-Path -LiteralPath "design-system/instagram/styles/system.css").Path

$templateHtml = Get-Content -LiteralPath $templateFullPath -Raw -Encoding UTF8
$tokenCss = Get-MitozzCssTokenBlock -Variant $PaletteVariant
$typographyCss = Get-MitozzTypographyCssTokenBlock -FontProfile $FontProfile
$inlineCss = $tokenCss + [Environment]::NewLine + $typographyCss + [Environment]::NewLine + (Get-Content -LiteralPath $cssFullPath -Raw -Encoding UTF8)
$dataObject = Get-Content -LiteralPath $dataFullPath -Raw -Encoding UTF8 | ConvertFrom-Json

if ($dataObject.PSObject.Properties.Match('font_profile').Count -gt 0 -and -not [string]::IsNullOrWhiteSpace([string]$dataObject.font_profile)) {
    $typographyCss = Get-MitozzTypographyCssTokenBlock -FontProfile ([string]$dataObject.font_profile)
    $inlineCss = $tokenCss + [Environment]::NewLine + $typographyCss + [Environment]::NewLine + (Get-Content -LiteralPath $cssFullPath -Raw -Encoding UTF8)
}

if ([string]::IsNullOrWhiteSpace($dataObject.template)) {
    throw "Data file must include 'template'."
}

if ([string]::IsNullOrWhiteSpace($dataObject.variant)) {
    throw "Data file must include 'variant'."
}

if ($null -eq $dataObject.copy -or $null -eq $dataObject.copy.headline_lines) {
    throw "Data file must include copy.headline_lines."
}

$expandedData = Expand-DataPaths -Node $dataObject
$jsonData = $expandedData | ConvertTo-Json -Depth 12 -Compress

$finalHtml = $templateHtml.Replace("__INLINE_CSS__", $inlineCss).Replace("__DATA_JSON__", $jsonData)

$htmlOutputDir = Split-Path -Parent $HtmlOutputPath
if (-not (Test-Path $htmlOutputDir)) {
    New-Item -ItemType Directory -Path $htmlOutputDir -Force | Out-Null
}

Set-Content -LiteralPath $HtmlOutputPath -Value $finalHtml -Encoding UTF8

if (-not [string]::IsNullOrWhiteSpace($ImageOutputPath)) {
    $imageOutputDir = Split-Path -Parent $ImageOutputPath
    if (-not (Test-Path $imageOutputDir)) {
        New-Item -ItemType Directory -Path $imageOutputDir -Force | Out-Null
    }

    $width = if ($dataObject.canvas.width) { [int]$dataObject.canvas.width } else { 928 }
    $height = if ($dataObject.canvas.height) { [int]$dataObject.canvas.height } else { 1152 }

    $resolvedOutput = Join-Path (Resolve-Path -LiteralPath $imageOutputDir).Path (Split-Path -Leaf $ImageOutputPath)

    $shouldRenderWithWinForms = $Browser -eq "winforms"
    $browserPath = $null

    if ($Browser -eq "auto") {
        try {
            $browserPath = Resolve-BrowserPath -RequestedBrowser "auto"
        }
        catch {
            $shouldRenderWithWinForms = $true
        }
    }
    elseif (-not $shouldRenderWithWinForms) {
        $browserPath = Resolve-BrowserPath -RequestedBrowser $Browser
    }

    if (-not $shouldRenderWithWinForms) {
        $htmlUri = ([System.Uri](Resolve-Path -LiteralPath $HtmlOutputPath).Path).AbsoluteUri
        $browserProfileDir = Join-Path (Resolve-Path ".").Path "output/_tmp/browser-render-profile"
        if (-not (Test-Path $browserProfileDir)) {
            New-Item -ItemType Directory -Path $browserProfileDir -Force | Out-Null
        }

        $arguments = @(
            "--headless=new",
            "--no-first-run",
            "--disable-crash-reporter",
            "--disable-crashpad-for-testing",
            "--disable-breakpad",
            "--disable-gpu",
            "--hide-scrollbars",
            "--allow-file-access-from-files",
            "--force-device-scale-factor=1",
            "--user-data-dir=$browserProfileDir",
            "--window-size=$width,$height",
            "--screenshot=$resolvedOutput",
            "--virtual-time-budget=1500",
            $htmlUri
        )

        & $browserPath $arguments | Out-Null
    }

    if ($shouldRenderWithWinForms) {
        Render-WithWinForms -HtmlPath $HtmlOutputPath -OutputPath $resolvedOutput -Width $width -Height $height
    }

    if (-not (Test-Path $resolvedOutput)) {
        throw "Renderer did not produce $resolvedOutput"
    }
}
