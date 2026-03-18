param(
    [Parameter(Mandatory = $true)]
    [string]$CsvPath,

    [string]$XlsxPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Resolve-WorkspacePath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$PathValue
    )

    $workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath ".."))

    if ([System.IO.Path]::IsPathRooted($PathValue)) {
        return [System.IO.Path]::GetFullPath($PathValue)
    }

    return [System.IO.Path]::GetFullPath((Join-Path -Path $workspaceRoot -ChildPath $PathValue))
}

function Get-ExcelColumnName {
    param(
        [Parameter(Mandatory = $true)]
        [int]$ColumnNumber
    )

    $name = ""
    while ($ColumnNumber -gt 0) {
        $modulo = ($ColumnNumber - 1) % 26
        $name = [char](65 + $modulo) + $name
        $ColumnNumber = [math]::Floor(($ColumnNumber - $modulo) / 26)
        $ColumnNumber--
    }

    return $name
}

function Escape-XmlText {
    param(
        [AllowNull()]
        [string]$Value
    )

    if ($null -eq $Value) {
        return ""
    }

    return [System.Security.SecurityElement]::Escape($Value)
}

$csvAbsolutePath = Resolve-WorkspacePath -PathValue $CsvPath
if (-not (Test-Path -LiteralPath $csvAbsolutePath)) {
    throw "CSV file not found: $csvAbsolutePath"
}

if ([string]::IsNullOrWhiteSpace($XlsxPath)) {
    $directory = Split-Path -Path $csvAbsolutePath -Parent
    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($csvAbsolutePath) + ".xlsx"
    $xlsxAbsolutePath = Join-Path -Path $directory -ChildPath $fileName
}
else {
    $xlsxAbsolutePath = Resolve-WorkspacePath -PathValue $XlsxPath
}

$rows = Import-Csv -LiteralPath $csvAbsolutePath -Encoding UTF8
if ($rows.Count -eq 0) {
    throw "CSV has no data rows: $csvAbsolutePath"
}

$headers = @($rows[0].PSObject.Properties.Name)
$allRows = @()
$allRows += ,$headers
foreach ($row in $rows) {
    $values = @()
    foreach ($header in $headers) {
        $values += [string]$row.$header
    }

    $allRows += ,$values
}

$sheetRows = New-Object System.Text.StringBuilder
for ($rowIndex = 0; $rowIndex -lt $allRows.Count; $rowIndex++) {
    $excelRowNumber = $rowIndex + 1
    [void]$sheetRows.Append("<row r=`"$excelRowNumber`">")

    $rowValues = @($allRows[$rowIndex])
    for ($columnIndex = 0; $columnIndex -lt $rowValues.Count; $columnIndex++) {
        $cellReference = "{0}{1}" -f (Get-ExcelColumnName -ColumnNumber ($columnIndex + 1)), $excelRowNumber
        $cellValue = Escape-XmlText -Value ([string]$rowValues[$columnIndex])
        [void]$sheetRows.Append("<c r=`"$cellReference`" t=`"inlineStr`"><is><t xml:space=`"preserve`">$cellValue</t></is></c>")
    }

    [void]$sheetRows.Append("</row>")
}

$worksheetXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
  <sheetViews>
    <sheetView workbookViewId="0"/>
  </sheetViews>
  <sheetFormatPr defaultRowHeight="15"/>
  <sheetData>$($sheetRows.ToString())</sheetData>
</worksheet>
"@

$workbookXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <sheets>
    <sheet name="Calendar" sheetId="1" r:id="rId1"/>
  </sheets>
</workbook>
"@

$workbookRelsXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
</Relationships>
"@

$rootRelsXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
</Relationships>
"@

$stylesXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
  <fonts count="1">
    <font>
      <sz val="11"/>
      <name val="Calibri"/>
      <family val="2"/>
    </font>
  </fonts>
  <fills count="2">
    <fill><patternFill patternType="none"/></fill>
    <fill><patternFill patternType="gray125"/></fill>
  </fills>
  <borders count="1">
    <border><left/><right/><top/><bottom/><diagonal/></border>
  </borders>
  <cellStyleXfs count="1">
    <xf numFmtId="0" fontId="0" fillId="0" borderId="0"/>
  </cellStyleXfs>
  <cellXfs count="1">
    <xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/>
  </cellXfs>
  <cellStyles count="1">
    <cellStyle name="Normal" xfId="0" builtinId="0"/>
  </cellStyles>
</styleSheet>
"@

$contentTypesXml = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
  <Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
  <Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>
</Types>
"@

$targetDirectory = Split-Path -Path $xlsxAbsolutePath -Parent
if (-not (Test-Path -LiteralPath $targetDirectory)) {
    New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null
}

$tempRoot = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath ("xlsx-export-" + [System.Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path -Path $tempRoot -ChildPath "_rels") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path -Path $tempRoot -ChildPath "xl") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path -Path $tempRoot -ChildPath "xl\_rels") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path -Path $tempRoot -ChildPath "xl\worksheets") -Force | Out-Null

[System.IO.File]::WriteAllText((Join-Path -Path $tempRoot -ChildPath "[Content_Types].xml"), $contentTypesXml, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText((Join-Path -Path $tempRoot -ChildPath "_rels\.rels"), $rootRelsXml, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText((Join-Path -Path $tempRoot -ChildPath "xl\workbook.xml"), $workbookXml, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText((Join-Path -Path $tempRoot -ChildPath "xl\_rels\workbook.xml.rels"), $workbookRelsXml, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText((Join-Path -Path $tempRoot -ChildPath "xl\worksheets\sheet1.xml"), $worksheetXml, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText((Join-Path -Path $tempRoot -ChildPath "xl\styles.xml"), $stylesXml, [System.Text.UTF8Encoding]::new($false))

if (Test-Path -LiteralPath $xlsxAbsolutePath) {
    Remove-Item -LiteralPath $xlsxAbsolutePath -Force
}

$zipPath = [System.IO.Path]::ChangeExtension($xlsxAbsolutePath, ".zip")
if (Test-Path -LiteralPath $zipPath) {
    Remove-Item -LiteralPath $zipPath -Force
}

Compress-Archive -Path (Join-Path -Path $tempRoot -ChildPath "*") -DestinationPath $zipPath -Force
Move-Item -LiteralPath $zipPath -Destination $xlsxAbsolutePath -Force
Remove-Item -LiteralPath $tempRoot -Recurse -Force

Write-Output "Saved XLSX to:"
Write-Output $xlsxAbsolutePath
