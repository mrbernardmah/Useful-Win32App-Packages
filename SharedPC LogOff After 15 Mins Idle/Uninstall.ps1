# Define the task name
$taskName = "AutoLogoutAfter15MinsIdle"

# Check if the task exists
if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
    # Unregister the task
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    Write-Output "Scheduled task '$taskName' has been removed."
} else {
    Write-Output "Scheduled task '$taskName' does not exist."
}
