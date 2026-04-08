Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$clientPath = "brand/references/business-context/reporting/google-drive-oauth-client.local.json"
$tokenPath = "brand/references/business-context/reporting/google-drive-oauth-token.local.json"
$fileId = "174I6iQME7k290GD7vmT_9WDt_omVX-aJzn2FwqcBQAQ"
$newName = "Jay Revels - March 2026 Monthly Retainer Invoice"

$client = (Get-Content $clientPath -Raw -Encoding UTF8 | ConvertFrom-Json).installed
$token = Get-Content $tokenPath -Raw -Encoding UTF8 | ConvertFrom-Json
$expiresAt = [datetime]::Parse($token.expires_at_utc, $null, [System.Globalization.DateTimeStyles]::RoundtripKind)
if ($expiresAt -le (Get-Date).ToUniversalTime().AddMinutes(2)) {
    $refresh = Invoke-RestMethod -Method Post -Uri $client.token_uri -Body @{
        client_id     = $client.client_id
        client_secret = $client.client_secret
        refresh_token = [string]$token.refresh_token
        grant_type    = "refresh_token"
    } -ContentType "application/x-www-form-urlencoded"

    $token.access_token = [string]$refresh.access_token
    $token.expires_at_utc = (Get-Date).ToUniversalTime().AddSeconds([int]$refresh.expires_in).ToString("o")
    $token | ConvertTo-Json -Depth 10 | Set-Content $tokenPath -Encoding UTF8
}

$accessToken = [string]$token.access_token
$patchUri = "https://www.googleapis.com/drive/v3/files/${fileId}?fields=id,name,webViewLink,modifiedTime&supportsAllDrives=true"
$body = @{ name = $newName } | ConvertTo-Json -Depth 5

$patched = Invoke-RestMethod -Method Patch -Uri $patchUri -Headers @{ Authorization = "Bearer $accessToken" } -Body $body -ContentType "application/json; charset=utf-8"
$current = Invoke-RestMethod -Method Get -Uri $patchUri -Headers @{ Authorization = "Bearer $accessToken" }

Write-Output "PATCH RESPONSE:"
Write-Output ($patched | ConvertTo-Json -Depth 5)
Write-Output "READ BACK:"
Write-Output ($current | ConvertTo-Json -Depth 5)
