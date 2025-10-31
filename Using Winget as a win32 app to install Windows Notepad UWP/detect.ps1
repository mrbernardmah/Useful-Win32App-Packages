# Detection script for Notepad UWP app
$path = "C:\Program Files\WindowsApps\Microsoft.WindowsNotepad_*_x64__8wekyb3d8bbwe"

if (Test-Path $path) {
    Write-Host "Detected"
    exit 0
} else {
    Write-Host "Not Detected"
    exit 1
}
