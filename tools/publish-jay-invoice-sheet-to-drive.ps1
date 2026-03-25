param(
    [string]$Month,
    [string]$InvoiceDataPath,
    [string]$SpreadsheetName,
    [string]$DriveFolderId,
    [string]$ReferenceSpreadsheetId,
    [string]$TargetSpreadsheetId,
    [switch]$InspectReferences,
    [switch]$PreviewReferenceLayout,
    [switch]$InitializeOAuth,
    [string]$AuthCode,
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath ".."))
$reportingRoot = Join-Path -Path $workspaceRoot -ChildPath "brand/references/business-context/reporting"
$oauthClientPath = Join-Path -Path $reportingRoot -ChildPath "google-drive-oauth-client.local.json"
$oauthTokenPath = Join-Path -Path $reportingRoot -ChildPath "google-drive-oauth-token.local.json"
$destinationMapPath = Join-Path -Path $reportingRoot -ChildPath "google-drive-destination-map.json"
$oauthRedirectUri = "http://localhost:53682/"
$oauthScope = "https://www.googleapis.com/auth/drive https://www.googleapis.com/auth/spreadsheets"
$oauthAuthBase = "https://accounts.google.com/o/oauth2/v2/auth"
$defaultHelperSheetTitle = "Codex Invoice Data"

Add-Type -AssemblyName System.Web

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

function New-OAuthState {
    [Guid]::NewGuid().ToString("N")
}

function Get-OAuthAuthorizationUrl {
    param(
        [Parameter(Mandatory = $true)][pscustomobject]$Client,
        [Parameter(Mandatory = $true)][string]$State
    )

    $query = @{
        client_id              = $Client.client_id
        redirect_uri           = $oauthRedirectUri
        response_type          = "code"
        scope                  = $oauthScope
        access_type            = "offline"
        prompt                 = "consent"
        state                  = $State
        include_granted_scopes = "true"
    }

    $pairs = foreach ($key in $query.Keys) {
        '{0}={1}' -f [System.Uri]::EscapeDataString($key), [System.Uri]::EscapeDataString([string]$query[$key])
    }
    "${oauthAuthBase}?$(($pairs -join '&'))"
}

function Save-OAuthToken {
    param([Parameter(Mandatory = $true)][pscustomobject]$TokenPayload)

    Set-Content -LiteralPath $oauthTokenPath -Value ($TokenPayload | ConvertTo-Json -Depth 10) -Encoding UTF8
}

function Get-SavedOAuthToken {
    if (-not (Test-Path -LiteralPath $oauthTokenPath)) {
        return $null
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

function Start-OAuthInitialization {
    $client = Get-OAuthClient
    $state = New-OAuthState
    $authUrl = Get-OAuthAuthorizationUrl -Client $client -State $state

    @(
        "OAuth setup is ready.",
        "1. Open this URL in your browser:",
        $authUrl,
        "",
        "2. Sign in to the Google account that can access Jay's invoice folder.",
        "3. Approve access.",
        "4. After Google redirects, copy the full URL from the browser address bar.",
        "5. Run this command with that full redirected URL:",
        "powershell -NoProfile -ExecutionPolicy Bypass -File 'tools/publish-jay-invoice-sheet-to-drive.ps1' -InitializeOAuth -AuthCode '<PASTE_FULL_REDIRECT_URL_HERE>'",
        "",
        "Expected redirect base:",
        $oauthRedirectUri,
        "",
        "State:",
        $state
    ) -join [Environment]::NewLine
}

function Complete-OAuthInitialization {
    param([Parameter(Mandatory = $true)][string]$ProvidedAuthCode)

    $client = Get-OAuthClient
    $codeValue = $ProvidedAuthCode

    if ($ProvidedAuthCode.StartsWith("http://", [System.StringComparison]::OrdinalIgnoreCase) -or $ProvidedAuthCode.StartsWith("https://", [System.StringComparison]::OrdinalIgnoreCase)) {
        $uri = [System.Uri]$ProvidedAuthCode
        $query = [System.Web.HttpUtility]::ParseQueryString($uri.Query)
        $codeValue = $query["code"]
        if ([string]::IsNullOrWhiteSpace($codeValue)) {
            throw "No 'code' parameter was found in the provided redirect URL."
        }
    }

    $tokenResponse = Request-OAuthToken -Client $client -Body @{
        code         = $codeValue
        grant_type   = "authorization_code"
        redirect_uri = $oauthRedirectUri
    }

    $expiresAt = (Get-Date).ToUniversalTime().AddSeconds([int]$tokenResponse.expires_in)
    $tokenPayload = [pscustomobject]@{
        access_token   = [string]$tokenResponse.access_token
        refresh_token  = [string]$tokenResponse.refresh_token
        token_type     = [string]$tokenResponse.token_type
        expires_at_utc = $expiresAt.ToString("o")
        scope          = [string]$tokenResponse.scope
    }
    Save-OAuthToken -TokenPayload $tokenPayload

    "OAuth token saved to $oauthTokenPath"
}

function Get-UsableAccessToken {
    $client = Get-OAuthClient
    $savedToken = Get-SavedOAuthToken
    if ($null -eq $savedToken) {
        throw "OAuth token not found at $oauthTokenPath. Run with -InitializeOAuth first."
    }

    $expiresAt = [DateTime]::Parse($savedToken.expires_at_utc, $null, [System.Globalization.DateTimeStyles]::RoundtripKind)
    if ($expiresAt -gt (Get-Date).ToUniversalTime().AddMinutes(2)) {
        return [string]$savedToken.access_token
    }

    if ([string]::IsNullOrWhiteSpace([string]$savedToken.refresh_token)) {
        throw "Saved OAuth token does not contain a refresh token. Re-run -InitializeOAuth and approve consent again."
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
        [Parameter(Mandatory = $true)][ValidateSet("Get", "Post", "Patch")][string]$Method,
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

function Get-JayInvoiceDriveFolderId {
    if (-not [string]::IsNullOrWhiteSpace($DriveFolderId)) {
        return $DriveFolderId.Trim()
    }

    if (-not (Test-Path -LiteralPath $destinationMapPath)) {
        throw "Destination map not found at $destinationMapPath."
    }

    $map = Get-Content -LiteralPath $destinationMapPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $configuredId = [string]$map.jay_invoice_sheets.root_folder_id
    if ([string]::IsNullOrWhiteSpace($configuredId)) {
        throw "jay_invoice_sheets.root_folder_id is not configured in $destinationMapPath."
    }

    return $configuredId
}

function Get-InvoiceSpreadsheetFiles {
    param(
        [Parameter(Mandatory = $true)][string]$ParentId,
        [Parameter(Mandatory = $true)][string]$AccessToken
    )

    $query = "'$ParentId' in parents and mimeType = 'application/vnd.google-apps.spreadsheet' and trashed = false"
    $uri = "https://www.googleapis.com/drive/v3/files?q=$([System.Uri]::EscapeDataString($query))&fields=files(id,name,webViewLink,createdTime,modifiedTime)&orderBy=modifiedTime desc&supportsAllDrives=true&includeItemsFromAllDrives=true"
    $response = Invoke-DriveJson -Method Get -Uri $uri -AccessToken $AccessToken
    @($response.files)
}

function Get-SpreadsheetById {
    param(
        [Parameter(Mandatory = $true)][string]$SpreadsheetId,
        [Parameter(Mandatory = $true)][string]$AccessToken
    )

    $uri = "https://www.googleapis.com/drive/v3/files/${SpreadsheetId}?fields=id,name,webViewLink,createdTime,modifiedTime&supportsAllDrives=true"
    Invoke-DriveJson -Method Get -Uri $uri -AccessToken $AccessToken
}

function Find-SpreadsheetByName {
    param(
        [Parameter(Mandatory = $true)][string]$ParentId,
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string]$AccessToken
    )

    $escapedName = $Name.Replace("'", "\'")
    $query = "name = '$escapedName' and '$ParentId' in parents and mimeType = 'application/vnd.google-apps.spreadsheet' and trashed = false"
    $uri = "https://www.googleapis.com/drive/v3/files?q=$([System.Uri]::EscapeDataString($query))&fields=files(id,name,webViewLink,createdTime,modifiedTime)&supportsAllDrives=true&includeItemsFromAllDrives=true"
    $response = Invoke-DriveJson -Method Get -Uri $uri -AccessToken $AccessToken
    $files = @($response.files)
    if ($files.Count -eq 0) {
        return $null
    }

    $files[0]
}

function Get-ReferenceSpreadsheet {
    param(
        [Parameter(Mandatory = $true)][string]$ParentId,
        [Parameter(Mandatory = $true)][string]$AccessToken,
        [string]$ExplicitReferenceSpreadsheetId
    )

    if (-not [string]::IsNullOrWhiteSpace($ExplicitReferenceSpreadsheetId)) {
        return Get-SpreadsheetById -SpreadsheetId $ExplicitReferenceSpreadsheetId -AccessToken $AccessToken
    }

    $files = Get-InvoiceSpreadsheetFiles -ParentId $ParentId -AccessToken $AccessToken
    if ($files.Count -eq 0) {
        throw "No Google Sheets were found in the target Jay invoice Drive folder."
    }

    $files[0]
}

function Get-SheetMetadata {
    param(
        [Parameter(Mandatory = $true)][string]$SpreadsheetId,
        [Parameter(Mandatory = $true)][string]$AccessToken
    )

    $uri = "https://sheets.googleapis.com/v4/spreadsheets/${SpreadsheetId}?fields=spreadsheetId,properties(title),sheets(properties(sheetId,title,index,gridProperties(rowCount,columnCount)))"
    Invoke-SheetsJson -Method Get -Uri $uri -AccessToken $AccessToken
}

function Get-SheetValues {
    param(
        [Parameter(Mandatory = $true)][string]$SpreadsheetId,
        [Parameter(Mandatory = $true)][string]$Range,
        [Parameter(Mandatory = $true)][string]$AccessToken
    )

    $uri = "https://sheets.googleapis.com/v4/spreadsheets/${SpreadsheetId}/values/$([System.Uri]::EscapeDataString($Range))"
    Invoke-SheetsJson -Method Get -Uri $uri -AccessToken $AccessToken
}

function Copy-SpreadsheetToFolder {
    param(
        [Parameter(Mandatory = $true)][string]$ReferenceSpreadsheetId,
        [Parameter(Mandatory = $true)][string]$NewName,
        [Parameter(Mandatory = $true)][string]$ParentId,
        [Parameter(Mandatory = $true)][string]$AccessToken
    )

    $uri = "https://www.googleapis.com/drive/v3/files/${ReferenceSpreadsheetId}/copy?fields=id,name,webViewLink&supportsAllDrives=true"
    Invoke-DriveJson -Method Post -Uri $uri -AccessToken $AccessToken -Body @{
        name    = $NewName
        parents = @($ParentId)
    }
}

function Ensure-HelperSheet {
    param(
        [Parameter(Mandatory = $true)][string]$SpreadsheetId,
        [Parameter(Mandatory = $true)][string]$SheetTitle,
        [Parameter(Mandatory = $true)][string]$AccessToken
    )

    $metadata = Get-SheetMetadata -SpreadsheetId $SpreadsheetId -AccessToken $AccessToken
    $existing = @($metadata.sheets | Where-Object { $_.properties.title -eq $SheetTitle })
    if ($existing.Count -gt 0) {
        return [int]$existing[0].properties.sheetId
    }

    $response = Invoke-SheetsJson -Method Post -Uri "https://sheets.googleapis.com/v4/spreadsheets/${SpreadsheetId}:batchUpdate" -AccessToken $AccessToken -Body @{
        requests = @(
            @{
                addSheet = @{
                    properties = @{
                        title = $SheetTitle
                    }
                }
            }
        )
    }

    [int]$response.replies[0].addSheet.properties.sheetId
}

function Clear-SheetValues {
    param(
        [Parameter(Mandatory = $true)][string]$SpreadsheetId,
        [Parameter(Mandatory = $true)][string]$SheetTitle,
        [Parameter(Mandatory = $true)][string]$AccessToken
    )

    $range = [System.Uri]::EscapeDataString("${SheetTitle}!A:Z")
    $uri = "https://sheets.googleapis.com/v4/spreadsheets/${SpreadsheetId}/values/${range}:clear"
    Invoke-SheetsJson -Method Post -Uri $uri -AccessToken $AccessToken -Body @{} | Out-Null
}

function Write-SheetValues {
    param(
        [Parameter(Mandatory = $true)][string]$SpreadsheetId,
        [Parameter(Mandatory = $true)][string]$SheetTitle,
        [Parameter(Mandatory = $true)][object[]]$Values,
        [Parameter(Mandatory = $true)][string]$AccessToken
    )

    $range = [System.Uri]::EscapeDataString("${SheetTitle}!A1")
    $uri = "https://sheets.googleapis.com/v4/spreadsheets/${SpreadsheetId}/values/${range}?valueInputOption=RAW"
    Invoke-SheetsJson -Method Put -Uri $uri -AccessToken $AccessToken -Body @{
        range          = "${SheetTitle}!A1"
        majorDimension = "ROWS"
        values         = $Values
    } | Out-Null
}

function Format-HelperSheet {
    param(
        [Parameter(Mandatory = $true)][string]$SpreadsheetId,
        [Parameter(Mandatory = $true)][int]$SheetId,
        [Parameter(Mandatory = $true)][string]$AccessToken
    )

    Invoke-SheetsJson -Method Post -Uri "https://sheets.googleapis.com/v4/spreadsheets/${SpreadsheetId}:batchUpdate" -AccessToken $AccessToken -Body @{
        requests = @(
            @{
                repeatCell = @{
                    range = @{
                        sheetId = $SheetId
                        startRowIndex = 0
                        endRowIndex = 1
                    }
                    cell = @{
                        userEnteredFormat = @{
                            backgroundColor = @{
                                red = 0.90
                                green = 0.95
                                blue = 0.98
                            }
                            textFormat = @{
                                bold = $true
                            }
                        }
                    }
                    fields = "userEnteredFormat(backgroundColor,textFormat.bold)"
                }
            },
            @{
                updateSheetProperties = @{
                    properties = @{
                        sheetId = $SheetId
                        gridProperties = @{
                            frozenRowCount = 1
                        }
                    }
                    fields = "gridProperties.frozenRowCount"
                }
            },
            @{
                autoResizeDimensions = @{
                    dimensions = @{
                        sheetId = $SheetId
                        dimension = "COLUMNS"
                        startIndex = 0
                        endIndex = 7
                    }
                }
            }
        )
    } | Out-Null
}

function Get-InvoiceData {
    param([string]$PathValue)

    if ([string]::IsNullOrWhiteSpace($PathValue)) {
        return $null
    }

    $resolvedPath = Resolve-WorkspacePath -PathValue $PathValue
    if (-not (Test-Path -LiteralPath $resolvedPath)) {
        throw "Invoice data JSON not found at $resolvedPath."
    }

    Get-Content -LiteralPath $resolvedPath -Raw -Encoding UTF8 | ConvertFrom-Json
}

function Get-TargetSpreadsheetName {
    param(
        [string]$TargetMonth,
        [string]$ProvidedName,
        [object]$InvoiceData
    )

    if (-not [string]::IsNullOrWhiteSpace($ProvidedName)) {
        return $ProvidedName.Trim()
    }

    if ($null -ne $InvoiceData -and -not [string]::IsNullOrWhiteSpace([string]$InvoiceData.sheet_name)) {
        return [string]$InvoiceData.sheet_name
    }

    if ([string]::IsNullOrWhiteSpace($TargetMonth)) {
        throw "Month is required unless SpreadsheetName or InvoiceData.sheet_name is provided."
    }

    "Jay Monthly Invoice - $TargetMonth"
}

function Convert-InvoiceDataToSheetRows {
    param([Parameter(Mandatory = $true)][object]$InvoiceData)

    $rows = New-Object System.Collections.Generic.List[object]
    $rows.Add(@("Month", [string]$InvoiceData.month))
    $rows.Add(@("Payee", [string]$InvoiceData.payee))
    $rows.Add(@("Currency", [string]$InvoiceData.currency))
    $rows.Add(@("Summary Notes", [string]$InvoiceData.summary_notes))
    $rows.Add(@())
    $rows.Add(@("Salary Description", "Salary Amount", "Salary Currency", "Salary Notes"))

    $salaryDescription = ""
    $salaryAmount = ""
    $salaryCurrency = ""
    $salaryNotes = ""
    if ($null -ne $InvoiceData.salary) {
        $salaryDescription = [string]$InvoiceData.salary.description
        if ($null -ne $InvoiceData.salary.amount) {
            $salaryAmount = [string]$InvoiceData.salary.amount
        }
        $salaryCurrency = [string]$InvoiceData.salary.currency
        $salaryNotes = [string]$InvoiceData.salary.notes
    }
    $rows.Add(@($salaryDescription, $salaryAmount, $salaryCurrency, $salaryNotes))
    $rows.Add(@())
    $rows.Add(@("Date", "Category", "Description", "Amount", "Currency", "Notes"))

    $expenses = @($InvoiceData.expenses)
    foreach ($expense in $expenses) {
        $amountValue = ""
        if ($null -ne $expense.amount) {
            $amountValue = [string]$expense.amount
        }

        $rows.Add(@(
            [string]$expense.date,
            [string]$expense.category,
            [string]$expense.description,
            $amountValue,
            [string]$expense.currency,
            [string]$expense.notes
        ))
    }

    $rows
}

if ($InitializeOAuth) {
    if ([string]::IsNullOrWhiteSpace($AuthCode)) {
        Write-Output (Start-OAuthInitialization)
        return
    }

    Write-Output (Complete-OAuthInitialization -ProvidedAuthCode $AuthCode)
    return
}

$accessToken = Get-UsableAccessToken
$folderId = Get-JayInvoiceDriveFolderId
$invoiceData = Get-InvoiceData -PathValue $InvoiceDataPath

if ($InspectReferences) {
    $files = Get-InvoiceSpreadsheetFiles -ParentId $folderId -AccessToken $accessToken
    if ($files.Count -eq 0) {
        Write-Output "No invoice spreadsheets found."
        return
    }

    $files | Select-Object id, name, modifiedTime, createdTime, webViewLink | Format-Table -AutoSize
    return
}

$referenceSpreadsheet = Get-ReferenceSpreadsheet -ParentId $folderId -AccessToken $accessToken -ExplicitReferenceSpreadsheetId $ReferenceSpreadsheetId

if ($PreviewReferenceLayout) {
    $metadata = Get-SheetMetadata -SpreadsheetId $referenceSpreadsheet.id -AccessToken $accessToken
    Write-Output "Reference spreadsheet: $($referenceSpreadsheet.name)"
    Write-Output "Reference spreadsheet ID: $($referenceSpreadsheet.id)"
    Write-Output "Reference spreadsheet link: $($referenceSpreadsheet.webViewLink)"
    Write-Output ""

    foreach ($sheet in @($metadata.sheets)) {
        $title = [string]$sheet.properties.title
        $preview = Get-SheetValues -SpreadsheetId $referenceSpreadsheet.id -Range "${title}!A1:F12" -AccessToken $accessToken
        Write-Output "=== Sheet: $title ==="
        foreach ($row in @($preview.values)) {
            Write-Output (($row | ForEach-Object { [string]$_ }) -join " | ")
        }
        Write-Output ""
    }
    return
}

$targetName = Get-TargetSpreadsheetName -TargetMonth $Month -ProvidedName $SpreadsheetName -InvoiceData $invoiceData

if (-not [string]::IsNullOrWhiteSpace($TargetSpreadsheetId)) {
    $targetSpreadsheet = Get-SpreadsheetById -SpreadsheetId $TargetSpreadsheetId -AccessToken $accessToken
} else {
    $targetSpreadsheet = Find-SpreadsheetByName -ParentId $folderId -Name $targetName -AccessToken $accessToken
}

if ($null -eq $targetSpreadsheet) {
    if ($DryRun) {
        Write-Output "Dry run only."
        Write-Output "Would copy reference spreadsheet: $($referenceSpreadsheet.name) [$($referenceSpreadsheet.id)]"
        Write-Output "Would create spreadsheet named: $targetName"
        Write-Output "Drive folder ID: $folderId"
        if ($null -ne $invoiceData) {
            Write-Output "Would write normalized data into helper sheet: $defaultHelperSheetTitle"
        }
        return
    }

    $targetSpreadsheet = Copy-SpreadsheetToFolder -ReferenceSpreadsheetId $referenceSpreadsheet.id -NewName $targetName -ParentId $folderId -AccessToken $accessToken
}

if ($null -ne $invoiceData) {
    $helperSheetId = Ensure-HelperSheet -SpreadsheetId $targetSpreadsheet.id -SheetTitle $defaultHelperSheetTitle -AccessToken $accessToken
    Clear-SheetValues -SpreadsheetId $targetSpreadsheet.id -SheetTitle $defaultHelperSheetTitle -AccessToken $accessToken
    $rows = Convert-InvoiceDataToSheetRows -InvoiceData $invoiceData
    Write-SheetValues -SpreadsheetId $targetSpreadsheet.id -SheetTitle $defaultHelperSheetTitle -Values $rows -AccessToken $accessToken
    Format-HelperSheet -SpreadsheetId $targetSpreadsheet.id -SheetId $helperSheetId -AccessToken $accessToken
}

$link = if ($null -ne $targetSpreadsheet.webViewLink) { [string]$targetSpreadsheet.webViewLink } else { "https://docs.google.com/spreadsheets/d/$($targetSpreadsheet.id)/edit" }
Write-Output "Reference spreadsheet: $($referenceSpreadsheet.name)"
Write-Output "Reference spreadsheet ID: $($referenceSpreadsheet.id)"
Write-Output "Spreadsheet name: $targetName"
Write-Output "Spreadsheet ID: $($targetSpreadsheet.id)"
Write-Output "Spreadsheet link: $link"
if ($null -ne $invoiceData) {
    Write-Output "Helper sheet updated: $defaultHelperSheetTitle"
}
