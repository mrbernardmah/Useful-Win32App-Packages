## Script to install package from Winget in Machine Scope. If unavailable, will fallback to User Scope
## Package is case-sensitive
## Set install parameters if required

#Remove existing WindowsNotepad
Get-AppxPackage -AllUsers -Name Microsoft.CompanyPortal | Remove-AppxPackage -AllUsers

Start-Sleep -Seconds 5

## Set log path
$Path_local = "C:\ProgramData\MrBSOEWay"
Start-Transcript -Path "C:\ProgramData\MrBSOEWay\logs\CompanyPortal.log" -Force -Append

# Resolve winget_exe
$winget_exe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe"
if ($winget_exe.count -gt 1){
        $winget_exe = $winget_exe[-1].Path
}

if (!$winget_exe){Write-Error "Winget not installed"}

## Attempt install using Machine Scope
& $winget_exe install --exact --id 9WZDNCRFJ3PZ --silent --source msstore --accept-package-agreements --accept-source-agreements --scope=machine $param

## Check if app is installed, if not then attempt install using User Scope
$wingetPrg_Existing = & $winget_exe list --id $ProgramName --exact --accept-source-agreements
if ($wingetPrg_Existing -like "*9WZDNCRFJ3PZ*"){
        Write-Host "Found it!"
    }else{
& $winget_exe install --exact --id 9WZDNCRFJ3PZ --silent --source msstore --accept-package-agreements --accept-source-agreements $param
}

Stop-Transcript