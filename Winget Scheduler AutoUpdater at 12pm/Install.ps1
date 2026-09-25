$PackageName = "winget-updater"
$Version = 1

$Path_local = "C:\ProgramData\MrB\Winget"
$LogPath_install = "$Path_local\Log\$PackageName-install.log"
$LogPath_run = "$Path_local\Log\$PackageName-run.log"

# Ensure Log directory exists
New-Item -ItemType Directory -Path "$Path_local\Log" -Force | Out-Null

Start-Transcript -Path $LogPath_install -Force

# Upgrade Script Payload
$upgrade_script_path = "$Path_local\Data\$PackageName\$PackageName.ps1"

# We use a multi-line string with Start-Transcript to log scheduled task runs
$upgrade_script = @"
`$logPath = "$LogPath_run"

# Ensure log directory exists
`$logDir = Split-Path `$logPath
if (-not (Test-Path `$logDir)) { New-Item -ItemType Directory -Path `$logDir -Force | Out-Null }

Start-Transcript -Path `$logPath -Append -Force

try {
    Write-Host "[`$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Starting Winget automatic update..."

    # Resolve and navigate to winget
    `$Path_WingetAll = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe" -ErrorAction SilentlyContinue
    
    if (`$Path_WingetAll) {
        `$Path_Winget = `$Path_WingetAll[-1].Path
        Set-Location `$Path_Winget
        .\winget.exe upgrade --silent --force --accept-package-agreements --accept-source-agreements --all --include-unknown
    } else {
        Write-Error "Winget installation folder not found in WindowsApps."
    }
}
catch {
    Write-Error "An error occurred during execution: `$_"
}
finally {
    Write-Host "[`$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Finished Winget execution."
    Stop-Transcript
}
"@

# Create target script directory and save script file
New-Item -ItemType Directory -Path (Split-Path $upgrade_script_path) -Force | Out-Null
Set-Content -Path $upgrade_script_path -Value $upgrade_script -Force

# Scheduled Task for "Winget Upgrades"
$schtaskName = "Windows Package Manager - UPDATER"
$schtaskDescription = "Manages the Updates of the Windows Package Manager. V$($Version)"
$trigger1 = New-ScheduledTaskTrigger -AtStartup
$trigger2 = New-ScheduledTaskTrigger -Weekly -WeeksInterval 1 -DaysOfWeek Monday, Tuesday, Wednesday, Thursday, Friday -At 12PM
$principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File `"$upgrade_script_path`""
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

Register-ScheduledTask -TaskName $schtaskName -Trigger $trigger1,$trigger2 -Action $action -Principal $principal -Settings $settings -Description $schtaskDescription -Force

Stop-Transcript