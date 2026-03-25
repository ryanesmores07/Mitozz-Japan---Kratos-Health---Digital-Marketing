param(
    [Parameter(Mandatory = $true)]
    [string]$CsvPath,

    [string]$SpreadsheetName,

    [string]$SpreadsheetId,

    [string]$DriveFolderId,

    [switch]$CreateLocalXlsx
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath ".."))
$reportingRoot = Join-Path -Path $workspaceRoot -ChildPath "brand/references/business-context/reporting"
$oauthClientPath = Join-Path -Path $reportingRoot -ChildPath "google-drive-oauth-client.local.json"
$oauthTokenPath = Join-Path -Path $reportingRoot -ChildPath "google-drive-oauth-token.local.json"
$destinationMapPath = Join-Path -Path $reportingRoot -ChildPath "google-drive-destination-map.json"
$sheetTabTitle = "Calendar"

function Resolve-WorkspacePath {
    param([Parameter(Mandatory = $true)][string]$PathValue)

    if ([System.IO.Path]::IsPathRooted($PathValue)) {
        return [System.IO.Path]::GetFullPath($PathValue)
    }

    [System.IO.Path]::GetFullPath((Join-Path -Path $workspaceRoot -ChildPath $PathValue))
}

function Get-OAuthClient {
    if (-not (Test-Path -LiteralPath $oauthClientPath)) {
        throw "OAuth client JSON not found at $oauthClientPath."
    }

    $raw = Get-Content -LiteralPath $oauthClientPath -Raw -Encoding UTF8 | ConvertFrom-Json
    if ($null -eq $raw.installed) {
        throw "OAuth client JSON at $oauthClientPath must contain an 'installed' object."
    }

    return $raw.installed
}

function Save-OAuthToken {
    param([Parameter(Mandatory = $true)][pscustomobject]$TokenPayload)

    Set-Content -LiteralPath $oauthTokenPath -Value ($TokenPayload | ConvertTo-Json -Depth 10) -Encoding UTF8
}

function Get-SavedOAuthToken {
    if (-not (Test-Path -LiteralPath $oauthTokenPath)) {
        throw "OAuth token not found at $oauthTokenPath."
    }

    Get-Content -LiteralPath $oauthTokenPath -Raw -Encoding UTF8 | ConvertFrom-Json
}

function Request-OAuthToken {
    param(
        [Parameter(Mandatory = $true)][pscustomobject]$Client,
        [Parameter(Mandatory = $true)][hashtable]$Body
    )

    $Body.client_id = $Client.client_id
    $Body.client_secret = $Client.client_secret

    Invoke-RestMethod -Method Post -Uri $Client.token_uri -Body $Body -ContentType "application/x-www-form-urlencoded"
}

function Get-UsableAccessToken {
    $client = Get-OAuthClient
    $savedToken = Get-SavedOAuthToken
    $expiresAt = [DateTime]::Parse($savedToken.expires_at_utc, $null, [System.Globalization.DateTimeStyles]::RoundtripKind)
    if ($expiresAt -gt (Get-Date).ToUniversalTime().AddMinutes(2)) {
        return [string]$savedToken.access_token
    }

    if ([string]::IsNullOrWhiteSpace([string]$savedToken.refresh_token)) {
        throw "Saved OAuth token does not contain a refresh token. Re-run OAuth setup."
    }

    $refreshResponse = Request-OAuthToken -Client $client -Body @{
        refresh_token = [string]$savedToken.refresh_token
        grant_type    = "refresh_token"
    }

    $updatedToken = [pscustomobject]@{
        access_token   = [string]$refreshResponse.access_token
        refresh_token  = [string]$savedToken.refresh_token
        token_type     = if ($null -ne $refreshResponse.token_type) { [string]$refreshResponse.token_type } else { [string]$savedToken.token_type }
        expires_at_utc = (Get-Date).ToUniversalTime().AddSeconds([int]$refreshResponse.expires_in).ToString("o")
        scope          = if ($null -ne $refreshResponse.scope) { [string]$refreshResponse.scope } else { [string]$savedToken.scope }
    }
    Save-OAuthToken -TokenPayload $updatedToken

    return [string]$updatedToken.access_token
}

function Invoke-DriveJson {
    param(
        [Parameter(Mandatory = $true)][ValidateSet("Get", "Post")][string]$Method,
        [Parameter(Mandatory = $true)][string]$Uri,
        [Parameter(Mandatory = $true)][string]$AccessToken,
        [object]$Body
    )

    $headers = @{ Authorization = "Bearer $AccessToken" }
    if ($PSBoundParameters.ContainsKey("Body")) {
        return Invoke-RestMethod -Method $Method -Uri $Uri -Headers $headers -Body ($Body | ConvertTo-Json -Depth 10 -Compress) -ContentType "application/json; charset=utf-8"
    }

    Invoke-RestMethod -Method $Method -Uri $Uri -Headers $headers
}

function Invoke-SheetsJson {
    param(
        [Parameter(Mandatory = $true)][ValidateSet("Get", "Post", "Put")][string]$Method,
        [Parameter(Mandatory = $true)][string]$Uri,
        [Parameter(Mandatory = $true)][string]$AccessToken,
        [object]$Body
    )

    $headers = @{ Authorization = "Bearer $AccessToken" }
    if ($PSBoundParameters.ContainsKey("Body")) {
        return Invoke-RestMethod -Method $Method -Uri $Uri -Headers $headers -Body ($Body | ConvertTo-Json -Depth 20 -Compress) -ContentType "application/json; charset=utf-8"
    }

    Invoke-RestMethod -Method $Method -Uri $Uri -Headers $headers
}

function Get-CalendarDriveFolderId {
    if (-not [string]::IsNullOrWhiteSpace($DriveFolderId)) {
        return $DriveFolderId
    }

    if (-not (Test-Path -LiteralPath $destinationMapPath)) {
        throw "Destination map not found at $destinationMapPath."
    }

    $map = Get-Content -LiteralPath $destinationMapPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $configuredId = [string]$map.content_calendars.root_folder_id
    if ([string]::IsNullOrWhiteSpace($configuredId)) {
        throw "content_calendars.root_folder_id is not configured in $destinationMapPath."
    }

    return $configuredId
}

function Find-DriveSpreadsheetByName {
    param(
        [Parameter(Mandatory = $true)][string]$ParentId,
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string]$AccessToken
    )

    $escapedName = $Name.Replace("'", "\'")
    $query = "name = '$escapedName' and '$ParentId' in parents and mimeType = 'application/vnd.google-apps.spreadsheet' and trashed = false"
    $uri = "https://www.googleapis.com/drive/v3/files?q=$([System.Uri]::EscapeDataString($query))&fields=files(id,name,webViewLink)&supportsAllDrives=true&includeItemsFromAllDrives=true"
    $response = Invoke-DriveJson -Method Get -Uri $uri -AccessToken $AccessToken
    $files = @($response.files)
    if ($files.Count -eq 0) {
        return $null
    }

    return $files[0]
}

function Get-CalendarSpreadsheetAliases {
    param([Parameter(Mandatory = $true)][string]$BaseName)

    $aliases = New-Object System.Collections.Generic.List[string]
    $aliases.Add($BaseName)

    if ($BaseName -match '^Mitozz Instagram Content Calendar - (\d{4}) - ([A-Za-z]+)$') {
        $year = $Matches[1]
        $month = $Matches[2]
        $aliases.Add("$month $year - Instagram Content Calendar - Launch Phase")
        $aliases.Add("$month $year - Instagram Content Calendar")
    }

    $aliases | Select-Object -Unique
}

function Ensure-Spreadsheet {
    param(
        [Parameter(Mandatory = $true)][string]$TargetName,
        [Parameter(Mandatory = $true)][string]$ParentId,
        [Parameter(Mandatory = $true)][string]$AccessToken,
        [string]$TargetSpreadsheetId
    )

    if (-not [string]::IsNullOrWhiteSpace($TargetSpreadsheetId)) {
        $uri = "https://www.googleapis.com/drive/v3/files/${TargetSpreadsheetId}?fields=id,name,webViewLink&supportsAllDrives=true"
        return Invoke-DriveJson -Method Get -Uri $uri -AccessToken $AccessToken
    }

    foreach ($alias in (Get-CalendarSpreadsheetAliases -BaseName $TargetName)) {
        $existing = Find-DriveSpreadsheetByName -ParentId $ParentId -Name $alias -AccessToken $AccessToken
        if ($null -ne $existing) {
            return $existing
        }
    }

    Invoke-DriveJson -Method Post -Uri "https://www.googleapis.com/drive/v3/files?fields=id,name,webViewLink&supportsAllDrives=true" -AccessToken $AccessToken -Body @{
        name     = $TargetName
        mimeType = "application/vnd.google-apps.spreadsheet"
        parents  = @($ParentId)
    }
}

function Get-SheetMetadata {
    param(
        [Parameter(Mandatory = $true)][string]$SpreadsheetId,
        [Parameter(Mandatory = $true)][string]$AccessToken
    )

    $uri = "https://sheets.googleapis.com/v4/spreadsheets/${SpreadsheetId}?fields=spreadsheetId,properties(title),sheets(properties(sheetId,title))"
    Invoke-SheetsJson -Method Get -Uri $uri -AccessToken $AccessToken
}

function Get-SheetRangeName {
    param([Parameter(Mandatory = $true)][string]$SheetTitle)

    "'{0}'!A1" -f $SheetTitle.Replace("'", "''")
}

function Get-SheetClearRange {
    param([Parameter(Mandatory = $true)][string]$SheetTitle)

    "'{0}'!A:ZZ" -f $SheetTitle.Replace("'", "''")
}

function Convert-CsvToValues {
    param([Parameter(Mandatory = $true)][string]$Path)

    $rows = Import-Csv -LiteralPath $Path -Encoding UTF8
    if ($rows.Count -eq 0) {
        throw "Calendar CSV has no data rows: $Path"
    }

    $headers = @($rows[0].PSObject.Properties.Name)
    $values = @()
    $values += ,@($headers)

    foreach ($row in $rows) {
        $valueRow = foreach ($header in $headers) {
            [string]$row.$header
        }
        $values += ,@($valueRow)
    }

    return @{
        Headers = $headers
        Values  = @($values)
    }
}

function Clear-SheetValues {
    param(
        [Parameter(Mandatory = $true)][string]$SpreadsheetId,
        [Parameter(Mandatory = $true)][string]$SheetTitle,
        [Parameter(Mandatory = $true)][string]$AccessToken
    )

    $range = [System.Uri]::EscapeDataString((Get-SheetClearRange -SheetTitle $SheetTitle))
    $uri = "https://sheets.googleapis.com/v4/spreadsheets/$SpreadsheetId/values/$range`:clear"
    Invoke-SheetsJson -Method Post -Uri $uri -AccessToken $AccessToken -Body @{}
}

function Write-SheetValues {
    param(
        [Parameter(Mandatory = $true)][string]$SpreadsheetId,
        [Parameter(Mandatory = $true)][string]$SheetTitle,
        [Parameter(Mandatory = $true)][object[]]$Values,
        [Parameter(Mandatory = $true)][string]$AccessToken
    )

    $range = [System.Uri]::EscapeDataString((Get-SheetRangeName -SheetTitle $SheetTitle))
    $uri = "https://sheets.googleapis.com/v4/spreadsheets/${SpreadsheetId}/values/${range}?valueInputOption=RAW"
    Invoke-SheetsJson -Method Put -Uri $uri -AccessToken $AccessToken -Body @{
        range          = Get-SheetRangeName -SheetTitle $SheetTitle
        majorDimension = "ROWS"
        values         = $Values
    } | Out-Null
}

function Format-Sheet {
    param(
        [Parameter(Mandatory = $true)][string]$SpreadsheetId,
        [Parameter(Mandatory = $true)][int]$SheetId,
        [Parameter(Mandatory = $true)][int]$ColumnCount,
        [Parameter(Mandatory = $true)][string]$AccessToken
    )

    $defaultWidths = @(90, 95, 60, 140, 260, 180, 120, 170, 240, 200, 150, 120, 280, 260)
    $widths = for ($i = 0; $i -lt $ColumnCount; $i++) {
        if ($i -lt $defaultWidths.Count) { $defaultWidths[$i] } else { 180 }
    }

    $requests = @(
        @{
            updateSheetProperties = @{
                properties = @{
                    sheetId = $SheetId
                    title = $sheetTabTitle
                    gridProperties = @{
                        frozenRowCount = 1
                    }
                }
                fields = "title,gridProperties.frozenRowCount"
            }
        },
        @{
            repeatCell = @{
                range = @{
                    sheetId = $SheetId
                    startRowIndex = 0
                    endRowIndex = 1
                    startColumnIndex = 0
                    endColumnIndex = $ColumnCount
                }
                cell = @{
                    userEnteredFormat = @{
                        backgroundColor = @{ red = 0.24; green = 0.36; blue = 0.43 }
                        horizontalAlignment = "CENTER"
                        verticalAlignment = "MIDDLE"
                        wrapStrategy = "WRAP"
                        textFormat = @{
                            foregroundColor = @{ red = 1; green = 1; blue = 1 }
                            bold = $true
                            fontSize = 10
                        }
                    }
                }
                fields = "userEnteredFormat(backgroundColor,textFormat,horizontalAlignment,verticalAlignment,wrapStrategy)"
            }
        },
        @{
            repeatCell = @{
                range = @{
                    sheetId = $SheetId
                    startRowIndex = 1
                    startColumnIndex = 0
                    endColumnIndex = $ColumnCount
                }
                cell = @{
                    userEnteredFormat = @{
                        verticalAlignment = "TOP"
                        wrapStrategy = "WRAP"
                        textFormat = @{
                            fontSize = 10
                        }
                    }
                }
                fields = "userEnteredFormat(verticalAlignment,wrapStrategy,textFormat.fontSize)"
            }
        },
        @{
            updateDimensionProperties = @{
                range = @{
                    sheetId = $SheetId
                    dimension = "ROWS"
                    startIndex = 0
                    endIndex = 1
                }
                properties = @{
                    pixelSize = 34
                }
                fields = "pixelSize"
            }
        },
        @{
            setBasicFilter = @{
                filter = @{
                    range = @{
                        sheetId = $SheetId
                        startRowIndex = 0
                        startColumnIndex = 0
                        endColumnIndex = $ColumnCount
                    }
                }
            }
        }
    )

    for ($i = 0; $i -lt $widths.Count; $i++) {
        $requests += @{
            updateDimensionProperties = @{
                range = @{
                    sheetId = $SheetId
                    dimension = "COLUMNS"
                    startIndex = $i
                    endIndex = $i + 1
                }
                properties = @{
                    pixelSize = $widths[$i]
                }
                fields = "pixelSize"
            }
        }
    }

    $uri = "https://sheets.googleapis.com/v4/spreadsheets/${SpreadsheetId}:batchUpdate"
    Invoke-SheetsJson -Method Post -Uri $uri -AccessToken $AccessToken -Body @{ requests = $requests } | Out-Null
}

$csvAbsolutePath = Resolve-WorkspacePath -PathValue $CsvPath
if (-not (Test-Path -LiteralPath $csvAbsolutePath)) {
    throw "Calendar CSV not found: $csvAbsolutePath"
}

$resolvedSpreadsheetName = if ([string]::IsNullOrWhiteSpace($SpreadsheetName)) {
    [System.IO.Path]::GetFileNameWithoutExtension($csvAbsolutePath)
}
else {
    $SpreadsheetName.Trim()
}

$accessToken = Get-UsableAccessToken
$calendarFolderId = Get-CalendarDriveFolderId
$spreadsheet = Ensure-Spreadsheet -TargetName $resolvedSpreadsheetName -ParentId $calendarFolderId -AccessToken $accessToken -TargetSpreadsheetId $SpreadsheetId
$metadata = Get-SheetMetadata -SpreadsheetId $spreadsheet.id -AccessToken $accessToken
$firstSheet = $metadata.sheets[0].properties
$currentSheetTitle = [string]$firstSheet.title
$sheetId = [int]$firstSheet.sheetId

$csvData = Convert-CsvToValues -Path $csvAbsolutePath
Clear-SheetValues -SpreadsheetId $spreadsheet.id -SheetTitle $currentSheetTitle -AccessToken $accessToken
Write-SheetValues -SpreadsheetId $spreadsheet.id -SheetTitle $currentSheetTitle -Values $csvData.Values -AccessToken $accessToken
Format-Sheet -SpreadsheetId $spreadsheet.id -SheetId $sheetId -ColumnCount $csvData.Headers.Count -AccessToken $accessToken

if ($CreateLocalXlsx) {
    powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path -Path $PSScriptRoot -ChildPath "export-csv-to-xlsx.ps1") -CsvPath $csvAbsolutePath | Out-Null
}

$link = if ($null -ne $spreadsheet.webViewLink) { [string]$spreadsheet.webViewLink } else { "https://docs.google.com/spreadsheets/d/$($spreadsheet.id)/edit" }
Write-Output "Calendar synced to Google Drive."
Write-Output "Spreadsheet name: $resolvedSpreadsheetName"
Write-Output "Spreadsheet ID: $($spreadsheet.id)"
Write-Output "Spreadsheet link: $link"
Write-Output "Local CSV: $csvAbsolutePath"
