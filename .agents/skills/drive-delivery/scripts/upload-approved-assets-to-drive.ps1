param(
    [ValidateSet("stories", "reels", "feed", "captions")]
    [string]$AssetType,

    [string]$SourcePath,

    [string]$ProjectName,

    [string]$RemoteSubfolder,

    [switch]$DryRun,

    [switch]$InitializeOAuth,

    [string]$AuthCode
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $scriptRoot -ChildPath "..\..\..\.."))
$reportingRoot = Join-Path -Path $workspaceRoot -ChildPath "brand/references/business-context/reporting"
$oauthClientPath = Join-Path -Path $reportingRoot -ChildPath "google-drive-oauth-client.local.json"
$oauthTokenPath = Join-Path -Path $reportingRoot -ChildPath "google-drive-oauth-token.local.json"
$destinationMapPath = Join-Path -Path $reportingRoot -ChildPath "google-drive-destination-map.json"
$receiptRoot = Join-Path -Path $reportingRoot -ChildPath "delivery-receipts"
$oauthRedirectUri = "http://localhost:53682/"
$oauthScope = "https://www.googleapis.com/auth/drive"
$oauthAuthBase = "https://accounts.google.com/o/oauth2/v2/auth"

$allowedExtensions = @(
    ".png", ".jpg", ".jpeg", ".webp",
    ".mp4", ".mov",
    ".txt", ".md", ".docx", ".pdf",
    ".csv", ".xlsx", ".srt", ".json"
)

Add-Type -AssemblyName System.Web

function Get-MimeType {
    param([Parameter(Mandatory = $true)][string]$Path)

    switch ([System.IO.Path]::GetExtension($Path).ToLowerInvariant()) {
        ".png" { "image/png" }
        ".jpg" { "image/jpeg" }
        ".jpeg" { "image/jpeg" }
        ".webp" { "image/webp" }
        ".mp4" { "video/mp4" }
        ".mov" { "video/quicktime" }
        ".txt" { "text/plain" }
        ".md" { "text/markdown" }
        ".pdf" { "application/pdf" }
        ".docx" { "application/vnd.openxmlformats-officedocument.wordprocessingml.document" }
        ".csv" { "text/csv" }
        ".xlsx" { "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }
        ".srt" { "application/x-subrip" }
        ".json" { "application/json" }
        default { "application/octet-stream" }
    }
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
        "2. Sign in to the Google account that owns the destination Drive folders.",
        "3. Approve access.",
        "4. After Google redirects, copy the full URL from the browser address bar.",
        "5. Run this command with that full redirected URL:",
        "powershell -NoProfile -ExecutionPolicy Bypass -File '.agents/skills/drive-delivery/scripts/upload-approved-assets-to-drive.ps1' -InitializeOAuth -AuthCode '<PASTE_FULL_REDIRECT_URL_HERE>'",
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
        return Invoke-RestMethod -Method $Method -Uri $Uri -Headers $headers -Body ($Body | ConvertTo-Json -Depth 10 -Compress) -ContentType "application/json; charset=utf-8"
    }

    Invoke-RestMethod -Method $Method -Uri $Uri -Headers $headers
}

function Find-DriveItemByName {
    param(
        [Parameter(Mandatory = $true)][string]$ParentId,
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string]$AccessToken,
        [string]$MimeType
    )

    $escapedName = $Name.Replace("'", "\'")
    $queryParts = @("name = '$escapedName'", "'$ParentId' in parents", "trashed = false")
    if (-not [string]::IsNullOrWhiteSpace($MimeType)) {
        $queryParts += "mimeType = '$MimeType'"
    }

    $query = [string]::Join(" and ", $queryParts)
    $uri = "https://www.googleapis.com/drive/v3/files?q=$([System.Uri]::EscapeDataString($query))&fields=files(id,name,mimeType,webViewLink)&supportsAllDrives=true&includeItemsFromAllDrives=true"
    $response = Invoke-DriveJson -Method Get -Uri $uri -AccessToken $AccessToken
    $files = @($response.files)
    if ($files.Count -eq 0) {
        return $null
    }

    return $files[0]
}

function Ensure-DriveFolder {
    param(
        [Parameter(Mandatory = $true)][string]$ParentId,
        [Parameter(Mandatory = $true)][string]$FolderName,
        [Parameter(Mandatory = $true)][string]$AccessToken
    )

    $folderMimeType = "application/vnd.google-apps.folder"
    $existing = Find-DriveItemByName -ParentId $ParentId -Name $FolderName -AccessToken $AccessToken -MimeType $folderMimeType
    if ($null -ne $existing) {
        return $existing
    }

    Invoke-DriveJson -Method Post -Uri "https://www.googleapis.com/drive/v3/files?supportsAllDrives=true" -AccessToken $AccessToken -Body @{
        name     = $FolderName
        mimeType = $folderMimeType
        parents  = @($ParentId)
    }
}

function Ensure-DriveFolderPath {
    param(
        [Parameter(Mandatory = $true)][string]$ParentId,
        [Parameter(Mandatory = $true)][string]$FolderPath,
        [Parameter(Mandatory = $true)][string]$AccessToken
    )

    $currentParentId = $ParentId
    $segments = $FolderPath -split '[\\/]+' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    foreach ($segment in $segments) {
        $folder = Ensure-DriveFolder -ParentId $currentParentId -FolderName $segment -AccessToken $AccessToken
        $currentParentId = $folder.id
    }

    return $folder
}

function New-DriveFile {
    param(
        [Parameter(Mandatory = $true)][string]$ParentId,
        [Parameter(Mandatory = $true)][string]$FileName,
        [Parameter(Mandatory = $true)][string]$AccessToken
    )

    Invoke-DriveJson -Method Post -Uri "https://www.googleapis.com/drive/v3/files?supportsAllDrives=true" -AccessToken $AccessToken -Body @{
        name    = $FileName
        parents = @($ParentId)
    }
}

function Set-DriveFileContent {
    param(
        [Parameter(Mandatory = $true)][string]$FileId,
        [Parameter(Mandatory = $true)][string]$LocalPath,
        [Parameter(Mandatory = $true)][string]$AccessToken
    )

    $headers = @{ Authorization = "Bearer $AccessToken" }
    Invoke-RestMethod -Method Patch `
        -Uri "https://www.googleapis.com/upload/drive/v3/files/${FileId}?uploadType=media&supportsAllDrives=true" `
        -Headers $headers `
        -InFile $LocalPath `
        -ContentType (Get-MimeType -Path $LocalPath) | Out-Null
}

function Resolve-DeliverySelection {
    param(
        [Parameter(Mandatory = $true)][string]$RequestedPath,
        [Parameter(Mandatory = $true)][string]$SelectedAssetType,
        [string]$RequestedProjectName
    )

    $resolved = Resolve-Path -LiteralPath $RequestedPath | Select-Object -ExpandProperty Path
    $item = Get-Item -LiteralPath $resolved
    $selectionRoot = $resolved

    if ($item.PSIsContainer -and ($SelectedAssetType -eq "stories" -or $SelectedAssetType -eq "reels" -or $SelectedAssetType -eq "feed")) {
        $currentPath = Join-Path -Path $resolved -ChildPath "current"
        if (Test-Path -LiteralPath $currentPath) {
            $selectionRoot = $currentPath
        }
    }

    $files = if ((Get-Item -LiteralPath $selectionRoot).PSIsContainer) {
        Get-ChildItem -LiteralPath $selectionRoot -Recurse -File |
            Where-Object {
                $_.Name -ne ".gitkeep" -and
                ($allowedExtensions -contains $_.Extension.ToLowerInvariant()) -and
                $_.FullName -notmatch '[\\/](rejected)[\\/]'
            } |
            Sort-Object FullName
    }
    else {
        Get-Item -LiteralPath $selectionRoot
    }

    if (@($files).Count -eq 0) {
        throw "No approved files were found under $selectionRoot."
    }

    $projectFolderName = if (-not [string]::IsNullOrWhiteSpace($RequestedProjectName)) {
        $RequestedProjectName
    }
    elseif ((Get-Item -LiteralPath $selectionRoot).PSIsContainer) {
        $folderLeaf = Split-Path -Path $selectionRoot -Leaf
        if ($folderLeaf -eq "current") {
            Split-Path -Path (Split-Path -Path $selectionRoot -Parent) -Leaf
        }
        else {
            $folderLeaf
        }
    }
    else {
        [System.IO.Path]::GetFileNameWithoutExtension($selectionRoot)
    }

    [pscustomobject]@{
        RequestedPath = $resolved
        SelectionRoot = $selectionRoot
        ProjectFolder = $projectFolderName
        Files         = @($files)
    }
}

function Write-DeliveryReceipt {
    param(
        [Parameter(Mandatory = $true)][pscustomobject]$Destination,
        [Parameter(Mandatory = $true)][pscustomobject]$Selection,
        [Parameter(Mandatory = $true)][System.Collections.Generic.List[object]]$UploadResults,
        [Parameter(Mandatory = $true)][bool]$WasDryRun,
        [string]$RemoteProjectFolderId
    )

    if (-not (Test-Path -LiteralPath $receiptRoot)) {
        New-Item -ItemType Directory -Path $receiptRoot -Force | Out-Null
    }

    $timestamp = Get-Date -Format "yyyy-MM-dd-HHmmss"
    $receiptPath = Join-Path -Path $receiptRoot -ChildPath "$timestamp-$AssetType-drive-delivery.md"
    $remoteFolderUrl = if ([string]::IsNullOrWhiteSpace($RemoteProjectFolderId)) {
        "https://drive.google.com/drive/folders/$($Destination.root_folder_id)"
    }
    else {
        "https://drive.google.com/drive/folders/$RemoteProjectFolderId"
    }

    $lines = @(
        "# Drive Delivery Receipt",
        "",
        ('- `Timestamp`: `{0}`' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')),
        ('- `Asset type`: `{0}`' -f $AssetType),
        ('- `Dry run`: `{0}`' -f $(if ($WasDryRun) { 'yes' } else { 'no' })),
        ('- `Requested source`: `{0}`' -f $Selection.RequestedPath),
        ('- `Selected source root`: `{0}`' -f $Selection.SelectionRoot),
        ('- `Project folder`: `{0}`' -f $Selection.ProjectFolder),
        ('- `Remote subfolder`: `{0}`' -f $(if ([string]::IsNullOrWhiteSpace($RemoteSubfolder)) { "-" } else { $RemoteSubfolder })),
        ('- `Drive root`: `{0}`' -f $Destination.root_name),
        ('- `Drive root folder id`: `{0}`' -f $Destination.root_folder_id),
        ('- `Remote folder`: {0}' -f $remoteFolderUrl),
        "",
        "## Files",
        ""
    )

    foreach ($file in $Selection.Files) {
        $matching = $UploadResults | Where-Object { $_.Name -eq $file.Name } | Select-Object -First 1
        $action = if ($null -ne $matching) { $matching.Action } else { "selected" }
        $lines += ('- `{0}` (`{1}`)' -f $file.Name, $action)
    }

    $lines += @("", "## Notes", "", ('- Destination rule: {0}' -f $Destination.local_rule))
    Set-Content -LiteralPath $receiptPath -Value $lines -Encoding UTF8
    return $receiptPath
}

if ($InitializeOAuth) {
    if ([string]::IsNullOrWhiteSpace($AuthCode)) {
        Start-OAuthInitialization
        exit 0
    }

    Complete-OAuthInitialization -ProvidedAuthCode $AuthCode
    exit 0
}

if ([string]::IsNullOrWhiteSpace($AssetType) -or [string]::IsNullOrWhiteSpace($SourcePath)) {
    throw "AssetType and SourcePath are required unless -InitializeOAuth is used."
}

if (-not (Test-Path -LiteralPath $destinationMapPath)) {
    throw "Drive destination map not found at $destinationMapPath."
}

$destinationMap = Get-Content -LiteralPath $destinationMapPath -Raw -Encoding UTF8 | ConvertFrom-Json
$destination = $destinationMap.$AssetType
if ($null -eq $destination) {
    throw "Asset type '$AssetType' is not configured in $destinationMapPath."
}

$selection = Resolve-DeliverySelection -RequestedPath $SourcePath -SelectedAssetType $AssetType -RequestedProjectName $ProjectName
$uploadResults = [System.Collections.Generic.List[object]]::new()
$remoteProjectFolderId = ""

if (-not $DryRun) {
    $accessToken = Get-UsableAccessToken
    $projectFolder = Ensure-DriveFolder -ParentId $destination.root_folder_id -FolderName $selection.ProjectFolder -AccessToken $accessToken
    $targetFolder = if ([string]::IsNullOrWhiteSpace($RemoteSubfolder)) {
        $projectFolder
    }
    else {
        Ensure-DriveFolderPath -ParentId $projectFolder.id -FolderPath $RemoteSubfolder -AccessToken $accessToken
    }
    $remoteProjectFolderId = $targetFolder.id

    foreach ($file in $selection.Files) {
        $existing = Find-DriveItemByName -ParentId $remoteProjectFolderId -Name $file.Name -AccessToken $accessToken
        if ($null -ne $existing) {
            Set-DriveFileContent -FileId $existing.id -LocalPath $file.FullName -AccessToken $accessToken
            $uploadResults.Add([pscustomobject]@{
                Name   = $file.Name
                Action = "replaced"
                FileId = $existing.id
            })
        }
        else {
            $newRemoteFile = New-DriveFile -ParentId $remoteProjectFolderId -FileName $file.Name -AccessToken $accessToken
            Set-DriveFileContent -FileId $newRemoteFile.id -LocalPath $file.FullName -AccessToken $accessToken
            $uploadResults.Add([pscustomobject]@{
                Name   = $file.Name
                Action = "uploaded"
                FileId = $newRemoteFile.id
            })
        }
    }
}
else {
    foreach ($file in $selection.Files) {
        $uploadResults.Add([pscustomobject]@{
            Name   = $file.Name
            Action = "dry-run"
            FileId = ""
        })
    }
}

$receiptPath = Write-DeliveryReceipt -Destination $destination -Selection $selection -UploadResults $uploadResults -WasDryRun ([bool]$DryRun) -RemoteProjectFolderId $remoteProjectFolderId

[pscustomobject]@{
    asset_type       = $AssetType
    dry_run          = [bool]$DryRun
    source_root      = $selection.SelectionRoot
    project_folder   = $selection.ProjectFolder
    destination_root = $destination.root_name
    file_count       = @($selection.Files).Count
    receipt_path     = $receiptPath
    auth_mode        = if ($DryRun) { "none" } else { "oauth" }
} | ConvertTo-Json -Depth 5
