# This PowerShell script will install Python and configure it to run Python files as a daemon.

# Step 1: Download and install Python
$pythonInstallerUrl = "https://www.python.org/ftp/python/3.9.7/python-3.9.7-amd64.exe"
$pythonInstallerPath = "$env:TEMP\python-installer.exe"

Invoke-WebRequest -Uri $pythonInstallerUrl -OutFile $pythonInstallerPath
Start-Process -Wait -FilePath $pythonInstallerPath -ArgumentList "/quiet", "PrependPath=1"

# Step 2: Set up Python file association with a daemon
$pythonExePath = (Get-Command python).Source
$pythonDaemonCode = @"
[System.Diagnostics.Process]::Start('$pythonExePath', '-c "import time; while True: time.sleep(1)" -u')
"@

Set-Content -Path "$env:TEMP\python_daemon.ps1" -Value $pythonDaemonCode

$registryPath = "HKCU:\Software\Classes\Applications\python.exe\shell\open\command"
Set-ItemProperty -Path $registryPath -Name "(default)" -Value "`"$pythonExePath`" `"$env:TEMP\python_daemon.ps1`" `%1`"" -Force
Write-Output "Python files will now be run as a daemon."

# Step 3: Clean up temporary files
Remove-Item -Path $pythonInstallerPath
Remove-Item -Path "$env:TEMP\python_daemon.ps1"
