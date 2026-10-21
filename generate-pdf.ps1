$ErrorActionPreference = 'Stop'

$root = $PSScriptRoot
$html = Join-Path $root 'index.html'
$target = Join-Path $root 'MichaelTrullasGarciaCV.pdf'
$temp = Join-Path $root 'cv_tmp.pdf'

if (-not (Test-Path -LiteralPath $html)) {
    Write-Error "index.html not found at: $html"
}

$candidates = @()
foreach ($pf in @($env:ProgramFiles, ${env:ProgramFiles(x86)})) {
    if (-not $pf) { continue }
    $candidates += Join-Path $pf 'Google\Chrome\Application\chrome.exe'
    $candidates += Join-Path $pf 'Microsoft\Edge\Application\msedge.exe'
}
$browser = $candidates | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
if (-not $browser) {
    Write-Error 'No Chrome or Edge browser found. Install one and re-run.'
}

$url = 'file:///' + ($root.Replace('\', '/')).Replace(' ', '%20') + '/index.html'
if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Force }

& $browser --headless --disable-gpu --no-pdf-header-footer --print-to-pdf=$temp $url

$deadline = (Get-Date).AddSeconds(60)
while (-not (Test-Path -LiteralPath $temp)) {
    if ((Get-Date) -gt $deadline) { Write-Error 'PDF was not created.' }
    Start-Sleep -Milliseconds 500
}

$size = -1
$stable = 0
while ($stable -lt 2) {
    if ((Get-Date) -gt $deadline) { break }
    Start-Sleep -Milliseconds 500
    $current = (Get-Item -LiteralPath $temp).Length
    if ($current -gt 0 -and $current -eq $size) { $stable++ } else { $stable = 0; $size = $current }
}
if ($size -le 0) { Write-Error 'PDF was not created.' }

$attempts = 0
while (Test-Path -LiteralPath $target) {
    try {
        Remove-Item -LiteralPath $target -Force
    }
    catch {
        $attempts++
        if ($attempts -ge 6) { throw }
        Start-Sleep -Seconds 2
    }
}
Move-Item -LiteralPath $temp -Destination $target
Write-Host "Generated $target ($size bytes)"
