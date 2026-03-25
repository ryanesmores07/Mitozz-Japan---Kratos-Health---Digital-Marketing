param(
    [Parameter(Mandatory = $true)]
    [int]$Year,

    [Parameter(Mandatory = $true)]
    [string]$Month,

    [switch]$CreateLocalXlsx
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath ".."))
$contentPlanningRoot = Join-Path -Path $workspaceRoot -ChildPath "brand/references/business-context/content-planning"

function Get-NormalizedMonthName {
    param([Parameter(Mandatory = $true)][string]$MonthValue)

    $trimmed = $MonthValue.Trim()
    if ([string]::IsNullOrWhiteSpace($trimmed)) {
        throw "Month cannot be blank."
    }

    try {
        return ([System.Globalization.CultureInfo]::InvariantCulture.DateTimeFormat.GetMonthName([int]$trimmed))
    }
    catch {
        return ([System.Globalization.CultureInfo]::InvariantCulture.TextInfo.ToTitleCase($trimmed.ToLowerInvariant()))
    }
}

function Get-CalendarCsvPath {
    param(
        [Parameter(Mandatory = $true)][int]$TargetYear,
        [Parameter(Mandatory = $true)][string]$TargetMonth
    )

    $monthName = Get-NormalizedMonthName -MonthValue $TargetMonth
    Join-Path -Path $contentPlanningRoot -ChildPath ("Mitozz Instagram Content Calendar - {0} - {1}.csv" -f $TargetYear, $monthName)
}

function Get-HeaderTemplatePath {
    $candidates = Get-ChildItem -LiteralPath $contentPlanningRoot -Filter "Mitozz Instagram Content Calendar - *.csv" -File |
        Sort-Object Name

    if ($candidates.Count -eq 0) {
        throw "No existing calendar CSV was found in $contentPlanningRoot to use as a header template."
    }

    return $candidates[0].FullName
}

function Ensure-CalendarCsvExists {
    param([Parameter(Mandatory = $true)][string]$CsvPath)

    if (Test-Path -LiteralPath $CsvPath) {
        return $false
    }

    $templatePath = Get-HeaderTemplatePath
    $headerLine = Get-Content -LiteralPath $templatePath -Encoding UTF8 -TotalCount 1
    if ([string]::IsNullOrWhiteSpace($headerLine)) {
        throw "Template calendar header is empty: $templatePath"
    }

    Set-Content -LiteralPath $CsvPath -Value $headerLine -Encoding UTF8
    return $true
}

function Get-DataRowCount {
    param([Parameter(Mandatory = $true)][string]$CsvPath)

    $lines = @(Get-Content -LiteralPath $CsvPath -Encoding UTF8)
    if ($lines.Count -le 1) {
        return 0
    }

    return ($lines.Count - 1)
}

$csvPath = Get-CalendarCsvPath -TargetYear $Year -TargetMonth $Month
$created = Ensure-CalendarCsvExists -CsvPath $csvPath
$rowCount = Get-DataRowCount -CsvPath $csvPath

if ($rowCount -gt 0) {
    $publishArgs = @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-File", (Join-Path -Path $PSScriptRoot -ChildPath "publish-content-calendar-to-drive.ps1"),
        "-CsvPath", $csvPath
    )

    if ($CreateLocalXlsx) {
        $publishArgs += "-CreateLocalXlsx"
    }

    & powershell @publishArgs
}
else {
    Write-Output "Calendar scaffold is ready locally but was not published because it has no data rows yet."
}

Write-Output "Local CSV: $csvPath"
Write-Output ("Created new file: {0}" -f ($(if ($created) { "yes" } else { "no" })))
Write-Output ("Data rows: {0}" -f $rowCount)
