[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0, ValueFromRemainingArguments = $true)]
    [string[]]$Paths
)

$fullBleedTerms = @(
    'full-bleed',
    'white bars',
    'blank bars',
    'letterboxing',
    'pillarboxing',
    'floating card layout',
    'inset image inside vertical canvas',
    'blank top padding',
    'blank bottom padding'
)

$bottleLockTerms = @(
    'locked bottle workflow',
    'real bottle design intact',
    'do not redesign',
    'do not repaint',
    'do not recolor',
    'do not relabel'
)

$bottleNegativeTerms = @(
    'white bottle',
    'white cap',
    'unreadable label'
)

$lockedBottleWorkflow = 'brand/references/business-context/visual/Mitozz Locked Bottle Workflow.md'
$bottleSizeSpec = 'brand/references/business-context/visual/Mitozz Bottle Size Spec.md'

function Flatten-Strings {
    param([Parameter(ValueFromPipeline = $true)]$Value)

    $parts = New-Object System.Collections.Generic.List[string]

    function Add-Node {
        param($Node)

        if ($null -eq $Node) {
            return
        }

        if ($Node -is [string]) {
            $parts.Add($Node)
            return
        }

        if ($Node -is [System.Collections.IDictionary]) {
            foreach ($item in $Node.Values) {
                Add-Node $item
            }
            return
        }

        if ($Node -is [System.Collections.IEnumerable] -and -not ($Node -is [string])) {
            foreach ($item in $Node) {
                Add-Node $item
            }
        }
    }

    Add-Node $Value
    return ($parts -join "`n").ToLowerInvariant()
}

function Get-Value {
    param(
        $Data,
        [string]$Key
    )

    if ($null -eq $Data) {
        return $null
    }

    if ($Data -is [System.Collections.IDictionary]) {
        return $Data[$Key]
    }

    $property = $Data.PSObject.Properties[$Key]
    if ($null -ne $property) {
        return $property.Value
    }

    return $null
}

function Get-List {
    param(
        $Data,
        [string]$Key
    )

    $value = Get-Value -Data $Data -Key $Key
    if ($value -is [System.Collections.IEnumerable] -and -not ($value -is [string])) {
        return @($value)
    }
    return @()
}

function Has-Term {
    param(
        [string]$Haystack,
        [string[]]$Terms
    )

    foreach ($term in $Terms) {
        if ($Haystack.Contains($term.ToLowerInvariant())) {
            return $true
        }
    }
    return $false
}

function Test-BottleLed {
    param($Data)

    foreach ($ref in (Get-List -Data $Data -Key 'image_references')) {
        if ((Get-Value -Data $ref -Key 'role') -eq 'product-source') {
            return $true
        }
    }

    $text = Flatten-Strings @(
        (Get-Value -Data $Data -Key 'motion_role'),
        (Get-Value -Data $Data -Key 'topic'),
        (Get-Value -Data $Data -Key 'notes'),
        (Get-List -Data $Data -Key 'composition'),
        (Get-List -Data $Data -Key 'brand_guardrails')
    )
    return ($text -match '\bbottle\b') -or ($text -match '\bproduct\b')
}

function Validate-Prompt {
    param([System.IO.FileInfo]$File)

    $errors = New-Object System.Collections.Generic.List[string]
    $warnings = New-Object System.Collections.Generic.List[string]

    try {
        $raw = Get-Content -LiteralPath $File.FullName -Raw -Encoding utf8
        $jsonObject = $raw | ConvertFrom-Json
    } catch {
        $errors.Add("$($File.Name): invalid JSON ($($_.Exception.Message))")
        return @{
            Errors = @($errors)
            Warnings = @($warnings)
            Data = $null
        }
    }

    if ((Get-Value -Data $jsonObject -Key 'asset_archetype') -ne 'reel-source-frame') {
        $errors.Add("$($File.Name): asset_archetype must be 'reel-source-frame'")
    }

    if ((Get-Value -Data $jsonObject -Key 'aspect_ratio') -ne '9:16') {
        $errors.Add("$($File.Name): aspect_ratio must be '9:16'")
    }

    if ([string]::IsNullOrWhiteSpace([string](Get-Value -Data $jsonObject -Key 'shot_id'))) {
        $errors.Add("$($File.Name): shot_id is required")
    }

    if ([string]::IsNullOrWhiteSpace([string](Get-Value -Data $jsonObject -Key 'motion_role'))) {
        $errors.Add("$($File.Name): motion_role is required")
    }

    $continuityTokens = Get-List -Data $jsonObject -Key 'continuity_tokens'
    if ($continuityTokens.Count -eq 0) {
        $errors.Add("$($File.Name): continuity_tokens must be present for reel shots")
    }

    $fullBleedText = Flatten-Strings @(
        (Get-List -Data $jsonObject -Key 'composition'),
        (Get-List -Data $jsonObject -Key 'brand_guardrails'),
        (Get-List -Data $jsonObject -Key 'variation_guardrails'),
        (Get-List -Data $jsonObject -Key 'negative_prompts'),
        (Get-Value -Data $jsonObject -Key 'notes')
    )

    if (-not $fullBleedText.Contains('full-bleed')) {
        $errors.Add("$($File.Name): missing explicit full-bleed framing language")
    }

    if (-not (Has-Term -Haystack $fullBleedText -Terms $fullBleedTerms[1..($fullBleedTerms.Count - 1)])) {
        $errors.Add("$($File.Name): missing rejection language for padding or letterbox failure modes")
    }

    $referenceFiles = Get-List -Data $jsonObject -Key 'reference_files'
    $referenceText = Flatten-Strings $referenceFiles
    $negativeText = Flatten-Strings (Get-List -Data $jsonObject -Key 'negative_prompts')
    $bottleText = Flatten-Strings @(
        (Get-List -Data $jsonObject -Key 'brand_guardrails'),
        (Get-List -Data $jsonObject -Key 'composition'),
        (Get-List -Data $jsonObject -Key 'variation_guardrails'),
        (Get-Value -Data $jsonObject -Key 'notes')
    )

    if (Test-BottleLed -Data $jsonObject) {
        $hasProductSource = $false
        foreach ($ref in (Get-List -Data $jsonObject -Key 'image_references')) {
            if ((Get-Value -Data $ref -Key 'role') -eq 'product-source') {
                $hasProductSource = $true
                break
            }
        }

        if (-not $hasProductSource) {
            $errors.Add("$($File.Name): bottle-led shots must include a product-source image")
        }

        if (-not $referenceText.Contains($lockedBottleWorkflow.ToLowerInvariant())) {
            $errors.Add("$($File.Name): bottle-led shots must reference Mitozz Locked Bottle Workflow.md")
        }

        if (-not $referenceText.Contains($bottleSizeSpec.ToLowerInvariant())) {
            $errors.Add("$($File.Name): bottle-led shots must reference Mitozz Bottle Size Spec.md")
        }

        if (-not (Has-Term -Haystack $bottleText -Terms $bottleLockTerms)) {
            $errors.Add("$($File.Name): bottle-led shots must explicitly say the real bottle stays intact")
        }

        if (-not $bottleText.Contains('bottle size spec') -and -not $bottleText.Contains('locked size spec')) {
            $warnings.Add("$($File.Name): consider mentioning the bottle size spec directly in the prompt body")
        }

        $missingNegativeTerms = @()
        foreach ($term in $bottleNegativeTerms) {
            if (-not $negativeText.Contains($term.ToLowerInvariant())) {
                $missingNegativeTerms += $term
            }
        }
        if ($missingNegativeTerms.Count -gt 0) {
            $errors.Add("$($File.Name): missing bottle negative prompts: $($missingNegativeTerms -join ', ')")
        }
    }

    return @{
        Errors = @($errors)
        Warnings = @($warnings)
        Data = $jsonObject
    }
}

$resolvedFiles = New-Object System.Collections.Generic.List[System.IO.FileInfo]
foreach ($pattern in $Paths) {
    $matches = @(Get-ChildItem -Path $pattern -File -ErrorAction SilentlyContinue)
    if ($matches.Count -gt 0) {
        foreach ($match in $matches) {
            $resolvedFiles.Add($match)
        }
        continue
    }

    if (Test-Path -LiteralPath $pattern -PathType Leaf) {
        $resolvedFiles.Add((Get-Item -LiteralPath $pattern))
    } else {
        Write-Error "No files matched $pattern"
        exit 2
    }
}

$uniqueFiles = $resolvedFiles |
    Group-Object FullName |
    ForEach-Object { $_.Group[0] } |
    Sort-Object FullName

$allErrors = New-Object System.Collections.Generic.List[string]
$allWarnings = New-Object System.Collections.Generic.List[string]
$dataByFile = @()

foreach ($file in $uniqueFiles) {
    $result = Validate-Prompt -File $file
    foreach ($validationError in $result.Errors) {
        $allErrors.Add($validationError)
    }
    foreach ($warning in $result.Warnings) {
        $allWarnings.Add($warning)
    }
    $dataByFile += [PSCustomObject]@{
        File = $file
        Data = $result.Data
    }
}

$shotPositions = @{}
$shotIds = @{}
foreach ($item in $dataByFile) {
    if ($null -eq $item.Data) {
        continue
    }

    $shotPosition = Get-Value -Data $item.Data -Key 'shot_position'
    if ($shotPosition -is [int]) {
        if ($shotPositions.ContainsKey($shotPosition)) {
            $allErrors.Add("duplicate shot_position ${shotPosition}: $($shotPositions[$shotPosition].Name) and $($item.File.Name)")
        } else {
            $shotPositions[$shotPosition] = $item.File
        }
    } else {
        $allErrors.Add("$($item.File.Name): shot_position must be an integer")
    }

    $shotId = [string](Get-Value -Data $item.Data -Key 'shot_id')
    if (-not [string]::IsNullOrWhiteSpace($shotId)) {
        if ($shotIds.ContainsKey($shotId)) {
            $allErrors.Add("duplicate shot_id ${shotId}: $($shotIds[$shotId].Name) and $($item.File.Name)")
        } else {
            $shotIds[$shotId] = $item.File
        }
    }
}

if ($shotPositions.Count -gt 0) {
    $actual = @($shotPositions.Keys | Sort-Object)
    $expected = 1..$shotPositions.Count
    if (($actual -join ',') -ne ($expected -join ',')) {
        $allWarnings.Add("shot positions are not contiguous from 1..$($shotPositions.Count): $($actual -join ', ')")
    }
}

if ($allErrors.Count -gt 0) {
    Write-Output 'FAILED'
        foreach ($validationError in $allErrors) {
            Write-Output "- $validationError"
    }
    if ($allWarnings.Count -gt 0) {
        Write-Output 'WARNINGS'
        foreach ($warning in $allWarnings) {
            Write-Output "- $warning"
        }
    }
    exit 1
}

Write-Output 'PASS'
foreach ($file in $uniqueFiles) {
    Write-Output "- $($file.FullName)"
}

if ($allWarnings.Count -gt 0) {
    Write-Output 'WARNINGS'
    foreach ($warning in $allWarnings) {
        Write-Output "- $warning"
    }
}
