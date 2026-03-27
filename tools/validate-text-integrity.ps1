param(
    [Parameter(Mandatory = $true, Position = 0, ValueFromRemainingArguments = $true)]
    [string[]]$Paths
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$utf8Strict = [System.Text.UTF8Encoding]::new($false, $true)
$mojibakeRegex = [regex]'Ã.|Â.|â€.|â€™|â€œ|â€|ï¿½|�'
$replacementChar = [char]0xFFFD

$failures = New-Object System.Collections.Generic.List[string]
$scanned = 0

foreach ($inputPath in $Paths) {
    $resolvedItems = Get-ChildItem -Path $inputPath -File -ErrorAction SilentlyContinue
    if (-not $resolvedItems) {
        $single = Get-Item -LiteralPath $inputPath -ErrorAction SilentlyContinue
        if ($single -and -not $single.PSIsContainer) {
            $resolvedItems = @($single)
        }
    }

    if (-not $resolvedItems) {
        $failures.Add("Missing path: $inputPath")
        continue
    }

    foreach ($file in $resolvedItems) {
        $scanned += 1
        $bytes = [System.IO.File]::ReadAllBytes($file.FullName)

        try {
            $text = $utf8Strict.GetString($bytes)
        }
        catch {
            $failures.Add("$($file.FullName): invalid UTF-8 bytes")
            continue
        }

        if ($text.Contains($replacementChar)) {
            $failures.Add("$($file.FullName): contains replacement characters")
        }

        $matches = $mojibakeRegex.Matches($text)
        if ($matches.Count -gt 0) {
            $failures.Add("$($file.FullName): contains likely mojibake patterns ($($matches.Count) matches)")
        }
    }
}

if ($failures.Count -gt 0) {
    Write-Output "FAILED"
    foreach ($failure in $failures) {
        Write-Output $failure
    }
    exit 1
}

Write-Output "PASS ($scanned files scanned)"
