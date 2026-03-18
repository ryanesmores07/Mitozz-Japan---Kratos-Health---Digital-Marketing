param(
    [Parameter(Mandatory = $true)]
    [string]$PromptPath,

    [string]$OutputRoot = "output/instagram/test-runs",

    [ValidateRange(1, 10)]
    [int]$BatchSize = 3
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$WorkspaceRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath ".."))

function Resolve-WorkspacePath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PathValue
    )

    if ([System.IO.Path]::IsPathRooted($PathValue)) {
        return [System.IO.Path]::GetFullPath($PathValue)
    }

    return [System.IO.Path]::GetFullPath((Join-Path -Path $WorkspaceRoot -ChildPath $PathValue))
}

function Resolve-ReferencePath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PathValue
    )

    $absolute = Resolve-WorkspacePath -PathValue $PathValue
    if (Test-Path -LiteralPath $absolute) {
        return $absolute
    }

    $extension = [System.IO.Path]::GetExtension($absolute).ToLowerInvariant()
    $imageExtensions = @(".png", ".jpg", ".jpeg", ".webp")
    if ($imageExtensions -contains $extension) {
        $directory = Split-Path -Path $absolute -Parent
        $stem = [System.IO.Path]::GetFileNameWithoutExtension($absolute)
        if (-not (Test-Path -LiteralPath $directory)) {
            return $null
        }

        $fallback = Get-ChildItem -LiteralPath $directory -File |
            Where-Object { [System.IO.Path]::GetFileNameWithoutExtension($_.Name) -eq $stem } |
            Select-Object -First 1

        if ($null -ne $fallback) {
            return $fallback.FullName
        }
    }

    return $null
}

function Join-Bullets {
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [string[]]$Items,

        [string]$Prefix = "- "
    )

    if ($Items.Count -eq 0) {
        return ""
    }

    return ($Items | ForEach-Object { "$Prefix$_" }) -join [Environment]::NewLine
}

function Build-BasePrompt {
    param(
        [Parameter(Mandatory = $true)]
        [pscustomobject]$Prompt,

        [Parameter(Mandatory = $true)]
        [string[]]$ResolvedImageReferences
    )

    $slides = @()
    if ($null -ne $Prompt.text_overlay -and $null -ne $Prompt.text_overlay.slides_ja) {
        $slides = @($Prompt.text_overlay.slides_ja)
    }

    $headline = ""
    if ($null -ne $Prompt.text_overlay -and $null -ne $Prompt.text_overlay.headline_ja) {
        $headline = [string]$Prompt.text_overlay.headline_ja
    }

    $lines = @(
        "Create one Instagram $($Prompt.asset_type) image in aspect ratio $($Prompt.aspect_ratio).",
        "Brand mood: Steel Light. Soft science, clear skin, quiet confidence.",
        "Audience: $($Prompt.audience).",
        "Topic: $($Prompt.topic). Objective: $($Prompt.objective).",
        "Visual archetype: $($Prompt.asset_archetype).",
        "",
        "Creative intent:",
        (Join-Bullets -Items @($Prompt.visual_intent)),
        "",
        "Brand guardrails:",
        (Join-Bullets -Items @($Prompt.brand_guardrails)),
        "",
        "Composition goals:",
        (Join-Bullets -Items @($Prompt.composition)),
        "",
        "Reference strategy:",
        [string]$Prompt.reference_strategy,
        "",
        "Variation guardrails:",
        (Join-Bullets -Items @($Prompt.variation_guardrails)),
        "",
        "Negative prompts:",
        (Join-Bullets -Items @($Prompt.negative_prompts)),
        "",
        "Text overlay:",
        "- Allowed: $($Prompt.text_overlay.allowed)",
        "- Tone: $($Prompt.text_overlay.tone)",
        "- Font reference: $($Prompt.text_overlay.font_reference)",
        "- Headline (Japanese): $headline",
        (Join-Bullets -Items $slides -Prefix "- Slide copy (Japanese): "),
        "",
        "Image references to attach in ChatGPT:",
        (Join-Bullets -Items $ResolvedImageReferences)
    )

    if ($null -ne $Prompt.notes -and [string]::IsNullOrWhiteSpace([string]$Prompt.notes) -eq $false) {
        $lines += ""
        $lines += "Execution notes:"
        $lines += [string]$Prompt.notes
    }

    return (($lines | Where-Object { $_ -ne $null }) -join [Environment]::NewLine).Trim()
}

function Build-VariantInstruction {
    param(
        [Parameter(Mandatory = $true)]
        [int]$Index,

        [Parameter(Mandatory = $true)]
        [pscustomobject]$Prompt
    )

    $variantMap = @{
        1 = "Variant 1: use a centered composition with airy whitespace, a calmer camera distance, and a restrained glow treatment."
        2 = "Variant 2: use a slightly offset composition with a closer crop, softer foreground depth, and a slightly warmer apricot signal accent."
        3 = "Variant 3: use a more editorial angle with extra breathing room, a quieter focal treatment, and stronger text-safe spacing."
    }

    if ($variantMap.ContainsKey($Index)) {
        return $variantMap[$Index]
    }

    return "Variant ${Index}: keep the same references and overall brand fit, but change crop, camera distance, angle, and glow treatment so it stays fresh without breaking the system."
}

$promptAbsolutePath = Resolve-WorkspacePath -PathValue $PromptPath
if (-not (Test-Path -LiteralPath $promptAbsolutePath)) {
    throw "Prompt file not found: $promptAbsolutePath"
}

$promptRaw = Get-Content -LiteralPath $promptAbsolutePath -Raw -Encoding UTF8
$prompt = $promptRaw | ConvertFrom-Json

$resolvedImageReferences = @()
$missingImageReferences = @()
foreach ($reference in @($prompt.image_references)) {
    $resolved = Resolve-ReferencePath -PathValue $reference.path
    if ($null -ne $resolved) {
        $resolvedImageReferences += $resolved
    }
    else {
        $missingImageReferences += [string]$reference.path
    }
}

$resolvedReferenceFiles = @()
$missingReferenceFiles = @()
foreach ($referenceFile in @($prompt.reference_files)) {
    $resolved = Resolve-ReferencePath -PathValue $referenceFile
    if ($null -ne $resolved) {
        $resolvedReferenceFiles += $resolved
    }
    else {
        $missingReferenceFiles += [string]$referenceFile
    }
}

$basePrompt = Build-BasePrompt -Prompt $prompt -ResolvedImageReferences $resolvedImageReferences
$variantPrompts = @()
for ($i = 1; $i -le $BatchSize; $i++) {
    $variantPrompts += [pscustomobject]@{
        variant = $i
        instruction = Build-VariantInstruction -Index $i -Prompt $prompt
        full_prompt = ($basePrompt + [Environment]::NewLine + [Environment]::NewLine + (Build-VariantInstruction -Index $i -Prompt $prompt))
    }
}

$outputRootAbsolute = Resolve-WorkspacePath -PathValue $OutputRoot
if (-not (Test-Path -LiteralPath $outputRootAbsolute)) {
    New-Item -ItemType Directory -Path $outputRootAbsolute -Force | Out-Null
}

$promptStem = [System.IO.Path]::GetFileNameWithoutExtension($promptAbsolutePath)
$runDirectory = Join-Path -Path $outputRootAbsolute -ChildPath $promptStem
if (-not (Test-Path -LiteralPath $runDirectory)) {
    New-Item -ItemType Directory -Path $runDirectory -Force | Out-Null
}

$bundle = [ordered]@{
    generated_at = (Get-Date).ToString("s")
    mode = "chatgpt-dry-run"
    prompt_file = $promptAbsolutePath
    output_directory = $runDirectory
    asset_type = $prompt.asset_type
    aspect_ratio = $prompt.aspect_ratio
    batch_size = $BatchSize
    resolved_image_references = $resolvedImageReferences
    missing_image_references = $missingImageReferences
    resolved_reference_files = $resolvedReferenceFiles
    missing_reference_files = $missingReferenceFiles
    variants = $variantPrompts
}

$jsonOutputPath = Join-Path -Path $runDirectory -ChildPath "chatgpt-request-bundle.json"
$bundle | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $jsonOutputPath -Encoding UTF8

$summaryLines = @(
    '# ChatGPT Image Test Run',
    '',
    "- Prompt file: $promptAbsolutePath",
    "- Asset type: $($prompt.asset_type)",
    "- Aspect ratio: $($prompt.aspect_ratio)",
    "- Batch size: $BatchSize",
    "- Resolved image references: $($resolvedImageReferences.Count)",
    "- Missing image references: $($missingImageReferences.Count)",
    "- Resolved reference files: $($resolvedReferenceFiles.Count)",
    "- Missing reference files: $($missingReferenceFiles.Count)",
    '',
    '## How To Use',
    '',
    '1. Open ChatGPT image generation.',
    '2. Attach the image files listed under `resolved_image_references` from the JSON bundle.',
    '3. Paste one `full_prompt` value at a time to generate the batch.',
    '4. Score the outputs against `workflows/03-generate-and-approve.md`.',
    '',
    '## Notes'
)

if ($missingImageReferences.Count -gt 0) {
    $summaryLines += ""
    $summaryLines += 'Missing image references:'
    $summaryLines += Join-Bullets -Items $missingImageReferences
}

if ($missingReferenceFiles.Count -gt 0) {
    $summaryLines += ""
    $summaryLines += 'Missing reference files:'
    $summaryLines += Join-Bullets -Items $missingReferenceFiles
}

if ($missingImageReferences.Count -eq 0 -and $missingReferenceFiles.Count -eq 0) {
    $summaryLines += ""
    $summaryLines += 'All references resolved successfully.'
}

$summaryOutputPath = Join-Path -Path $runDirectory -ChildPath "README.md"
($summaryLines -join [Environment]::NewLine) | Set-Content -LiteralPath $summaryOutputPath -Encoding UTF8

Write-Output "Saved ChatGPT dry-run bundle to:"
Write-Output $jsonOutputPath
Write-Output $summaryOutputPath
