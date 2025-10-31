$Path_local = "C:\ProgramData\MrBSOEWay"
Start-Transcript -Path "C:\ProgramData\MrBSOEWay\logs\Uninstall-CompanyPortal.log" -Force -Append

# resolve winget_exe
$winget_exe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe"
if ($winget_exe.count -gt 1){
        $winget_exe = $winget_exe[-1].Path
}

if (!$winget_exe){Write-Error "Winget not installed"}

& $winget_exe uninstall --exact --id 9WZDNCRFJ3PZ --silent --accept-source-agreements
Get-AppxPackage -AllUsers -Name Microsoft.CompanyPortal | Remove-AppxPackage -AllUsers

Stop-Transcript