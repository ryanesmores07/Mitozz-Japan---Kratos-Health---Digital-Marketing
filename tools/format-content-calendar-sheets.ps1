Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$workspaceRoot = [System.IO.Path]::GetFullPath((Join-Path -Path $PSScriptRoot -ChildPath ".."))
$reportingRoot = Join-Path -Path $workspaceRoot -ChildPath "brand/references/business-context/reporting"
$oauthClientPath = Join-Path -Path $reportingRoot -ChildPath "google-drive-oauth-client.local.json"
$oauthTokenPath = Join-Path -Path $reportingRoot -ChildPath "google-drive-oauth-token.local.json"

function Refresh-AccessTokenIfNeeded {
    $client = Get-Content -Raw $oauthClientPath | ConvertFrom-Json
    $token = Get-Content -Raw $oauthTokenPath | ConvertFrom-Json
    $expires = [datetime]::Parse($token.expires_at_utc)

    if ($expires -lt (Get-Date).ToUniversalTime().AddMinutes(2)) {
        $body = @{
            client_id     = $client.installed.client_id
            client_secret = $client.installed.client_secret
            refresh_token = $token.refresh_token
            grant_type    = "refresh_token"
        }

        $resp = Invoke-RestMethod -Method Post -Uri $client.installed.token_uri -Body $body -ContentType "application/x-www-form-urlencoded"
        $token.access_token = $resp.access_token
        $token.expires_at_utc = (Get-Date).ToUniversalTime().AddSeconds([int]$resp.expires_in).ToString("o")
        Set-Content -Path $oauthTokenPath -Value ($token | ConvertTo-Json -Depth 10) -Encoding UTF8
    }

    return [string]$token.access_token
}

function Format-CalendarSheet {
    param(
        [Parameter(Mandatory = $true)][string]$SpreadsheetId,
        [Parameter(Mandatory = $true)][int]$SheetId,
        [Parameter(Mandatory = $true)][hashtable]$Headers
    )

    $widths = @(90, 95, 60, 140, 260, 180, 110, 170, 240, 180, 150, 120, 260)
    $requests = @()

    $requests += @{
        updateSheetProperties = @{
            properties = @{
                sheetId = $SheetId
                gridProperties = @{
                    frozenRowCount = 1
                }
            }
            fields = "gridProperties.frozenRowCount"
        }
    }

    $requests += @{
        repeatCell = @{
            range = @{
                sheetId = $SheetId
                startRowIndex = 0
                endRowIndex = 1
                startColumnIndex = 0
                endColumnIndex = 13
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
    }

    $requests += @{
        repeatCell = @{
            range = @{
                sheetId = $SheetId
                startRowIndex = 1
                startColumnIndex = 0
                endColumnIndex = 13
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
    }

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

    $requests += @{
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
    }

    $requests += @{
        setBasicFilter = @{
            filter = @{
                range = @{
                    sheetId = $SheetId
                    startRowIndex = 0
                    startColumnIndex = 0
                    endColumnIndex = 13
                }
            }
        }
    }

    $headers.Authorization = "Bearer $(Refresh-AccessTokenIfNeeded)"
    $uri = "https://sheets.googleapis.com/v4/spreadsheets/${SpreadsheetId}:batchUpdate"
    $json = @{ requests = $requests } | ConvertTo-Json -Depth 20 -Compress
    Invoke-RestMethod -Method Post -Uri $uri -Headers $Headers -Body $json -ContentType "application/json; charset=utf-8" | Out-Null
}

$headers = @{}
Format-CalendarSheet -SpreadsheetId "1DA_cNikaYp10pHvSlzMi6udFqxWjzlvlivwfjieKb0s" -SheetId 298323859 -Headers $headers
Format-CalendarSheet -SpreadsheetId "1CxljHMQXctOIBWDDxRIYBzWmhNkAuRXW1z_WNu-FHfU" -SheetId 912035703 -Headers $headers

Write-Output "March and April calendar sheets formatted."
