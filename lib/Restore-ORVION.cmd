@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Restore-ORVION.ps1" %*
set "ORVION_EXIT=%ERRORLEVEL%"
pause
exit /b %ORVION_EXIT%
