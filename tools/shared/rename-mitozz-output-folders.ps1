Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath "..\.."))
$outputRoot = Join-Path $workspaceRoot "output/instagram"

function Get-CanonicalFolderName {
    param(
        [Parameter(Mandatory = $true)][ValidateSet("feed", "stories", "reels")][string]$Category,
        [Parameter(Mandatory = $true)][string]$Name
    )

    if ($Category -eq "feed" -and $Name -match '^ig-feed-(\d{4}-\d{2}-\d{2})-(.+)$') {
        return "$($Matches[1])-feed-$($Matches[2])"
    }

    if ($Category -eq "stories" -and $Name -match '^ig-story-(\d{4}-\d{2}-\d{2})-(.+)$') {
        return "$($Matches[1])-story-$($Matches[2])"
    }

    if ($Category -eq "stories" -and $Name -match '^(\d{4}-\d{2}-\d{2})-(.+)$') {
        $date = $Matches[1]
        $rest = $Matches[2]
        if ($rest -notmatch '-v\d+$') {
            $rest = "${rest}-v01"
        }
        return "${date}-story-${rest}"
    }

    if ($Category -eq "reels" -and $Name -match '^(\d{4}-\d{2}-\d{2})-(.+)-reel$') {
        return "$($Matches[1])-reel-$($Matches[2])-v01"
    }

    if ($Category -eq "reels" -and $Name -match '^(\d{4}-\d{2}-\d{2})-(.+)$') {
        $date = $Matches[1]
        $rest = $Matches[2]
        if ($rest -notmatch '-v\d+$') {
            $rest = "${rest}-v01"
        }
        return "${date}-reel-${rest}"
    }

    return $Name
}

$results = New-Object System.Collections.Generic.List[object]

foreach ($category in @("feed", "stories", "reels")) {
    $categoryPath = Join-Path $outputRoot $category
    if (-not (Test-Path -LiteralPath $categoryPath)) {
        continue
    }

    $directories = Get-ChildItem -LiteralPath $categoryPath -Directory | Sort-Object Name
    foreach ($directory in $directories) {
        if ($directory.Name -eq "_render-test") {
            continue
        }

        $canonicalName = Get-CanonicalFolderName -Category $category -Name $directory.Name
        if ($canonicalName -eq $directory.Name) {
            continue
        }

        $targetPath = Join-Path $categoryPath $canonicalName
        if (Test-Path -LiteralPath $targetPath) {
            $sourceHasChildren = (Get-ChildItem -LiteralPath $directory.FullName -Force | Measure-Object).Count -gt 0
            $targetHasChildren = (Get-ChildItem -LiteralPath $targetPath -Force | Measure-Object).Count -gt 0

            if (-not $sourceHasChildren) {
                Remove-Item -LiteralPath $directory.FullName -Force
                $results.Add([pscustomobject]@{
                    category = $category
                    old_name = $directory.Name
                    new_name = $canonicalName
                    action = "removed-empty-conflict"
                })
                continue
            }

            if (-not $targetHasChildren) {
                Remove-Item -LiteralPath $targetPath -Force
            }
            else {
                throw "Target already exists and is not empty: $targetPath"
            }
        }

        Move-Item -LiteralPath $directory.FullName -Destination $targetPath
        $results.Add([pscustomobject]@{
            category = $category
            old_name = $directory.Name
            new_name = $canonicalName
            action = "renamed"
        })
    }
}

$results | ConvertTo-Json -Depth 4
