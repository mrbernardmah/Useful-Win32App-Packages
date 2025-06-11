$taskName = "AutoLogoutAfter15MinsIdle"
$task = schtasks.exe /Query /TN $taskName 2>$null

if ($LASTEXITCODE -eq 0) {
    Write-Output "Installed"
    exit 0
} else {
    Write-Output "Not Installed"
    exit 1
}
