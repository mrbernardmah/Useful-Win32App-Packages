$PackageName = "winget-updater"

$Path_local = "C:\ProgramData\MrB\Winget"
Start-Transcript -Path "$Path_local\Log\uninstall\$PackageName-uninstall.log" -Force

# Remove Task
$schtaskName = "Windows Package Manager - UPDATER"
Unregister-ScheduledTask -TaskName $schtaskName -Confirm:$false

# Remove local directory
Remove-Item "$Path_local\Data\$PackageName" -Force -Recurse

Stop-Transcript
