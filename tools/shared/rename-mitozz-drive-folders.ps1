Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath "..\.."))
$reportingRoot = Join-Path $workspaceRoot "brand/references/business-context/reporting"
$oauthClientPath = Join-Path $reportingRoot "google-drive-oauth-client.local.json"
$oauthTokenPath = Join-Path $reportingRoot "google-drive-oauth-token.local.json"
$calendarRoot = Join-Path $workspaceRoot "brand/references/business-context/content-planning"
$calendarPaths = @(
    (Join-Path $calendarRoot "Mitozz Instagram Content Calendar - 2026 - March.csv"),
    (Join-Path $calendarRoot "Mitozz Instagram Content Calendar - 2026 - April.csv")
) | Where-Object { Test-Path -LiteralPath $_ }

function Get-CanonicalFolderName {
    param([Parameter(Mandatory = $true)][string]$Name)

    if ($Name -match '^ig-feed-(\d{4}-\d{2}-\d{2})-(.+)$') {
        return "$($Matches[1])-feed-$($Matches[2])"
    }
    if ($Name -match '^ig-story-(\d{4}-\d{2}-\d{2})-(.+)$') {
        return "$($Matches[1])-story-$($Matches[2])"
    }
    if ($Name -match '^(\d{4}-\d{2}-\d{2})-(.+)-reel$') {
        return "$($Matches[1])-reel-$($Matches[2])-v01"
    }
    if ($Name -match '^(\d{4}-\d{2}-\d{2})-(.+)$' -and $Name -notmatch '^(\d{4}-\d{2}-\d{2})-(feed|story|reel)-') {
        $date = $Matches[1]
        $rest = $Matches[2]
        if ($rest -notmatch '-v\d+$') {
            $rest = "${rest}-v01"
        }
        return "${date}-reel-${rest}"
    }

    return $Name
}

function Get-OAuthClient {
    $raw = Get-Content -LiteralPath $oauthClientPath -Raw -Encoding UTF8 | ConvertFrom-Json
    return $raw.installed
}

function Save-OAuthToken {
    param([Parameter(Mandatory = $true)][pscustomobject]$TokenPayload)
    Set-Content -LiteralPath $oauthTokenPath -Value ($TokenPayload | ConvertTo-Json -Depth 10) -Encoding UTF8
}

function Get-SavedOAuthToken {
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
        [Parameter(Mandatory = $true)][ValidateSet("Get", "Patch")][string]$Method,
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

function Get-DriveFolderIdFromUrl {
    param([Parameter(Mandatory = $true)][string]$Url)
    if ($Url -match '/folders/([^/?]+)') {
        return $Matches[1]
    }
    return $null
}

$rowsById = @{}
foreach ($calendarPath in $calendarPaths) {
    $rows = Import-Csv -LiteralPath $calendarPath
    foreach ($row in $rows) {
        if ([string]::IsNullOrWhiteSpace($row.'Asset Link')) { continue }
        $id = Get-DriveFolderIdFromUrl -Url $row.'Asset Link'
        if (-not [string]::IsNullOrWhiteSpace($id)) {
            $category = if ($row.Format -eq 'Reel') {
                'reels'
            }
            elseif ($row.Section -eq 'Story') {
                'stories'
            }
            else {
                'feed'
            }

            $rowsById[$id] = [pscustomobject]@{
                date = [string]$row.'Publish Date'
                category = $category
            }
        }
    }
}

$accessToken = Get-UsableAccessToken
$results = New-Object System.Collections.Generic.List[object]
$localByDateCategory = @{}
foreach ($category in @('feed','stories','reels')) {
    $categoryPath = Join-Path $workspaceRoot "output/instagram/$category"
    if (-not (Test-Path -LiteralPath $categoryPath)) { continue }
    foreach ($directory in (Get-ChildItem -LiteralPath $categoryPath -Directory)) {
        if ($directory.Name -match '^(\d{4}-\d{2}-\d{2})-') {
            $key = "$category|$($Matches[1])"
            if (-not $localByDateCategory.ContainsKey($key)) {
                $localByDateCategory[$key] = @()
            }
            $localByDateCategory[$key] += $directory.Name
        }
    }
}

foreach ($id in $rowsById.Keys) {
    $file = Invoke-DriveJson -Method Get -Uri "https://www.googleapis.com/drive/v3/files/${id}?fields=id,name,webViewLink&supportsAllDrives=true" -AccessToken $accessToken
    $rowInfo = $rowsById[$id]
    $lookupKey = "$($rowInfo.category)|$($rowInfo.date)"
    $localMatches = @()
    if ($localByDateCategory.ContainsKey($lookupKey)) {
        $localMatches = @($localByDateCategory[$lookupKey])
    }

    if ($localMatches.Count -eq 1) {
        $newName = [string]$localMatches[0]
    }
    else {
        $newName = Get-CanonicalFolderName -Name ([string]$file.name)
    }

    if ($newName -eq $file.name) {
        $results.Add([pscustomobject]@{ id = $id; old_name = $file.name; new_name = $newName; action = "unchanged" })
        continue
    }

    [void](Invoke-DriveJson -Method Patch -Uri "https://www.googleapis.com/drive/v3/files/${id}?supportsAllDrives=true" -AccessToken $accessToken -Body @{ name = $newName })
    $results.Add([pscustomobject]@{ id = $id; old_name = $file.name; new_name = $newName; action = "renamed" })
}

$results | ConvertTo-Json -Depth 4
