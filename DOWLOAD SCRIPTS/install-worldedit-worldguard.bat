@echo off
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-worldedit-worldguard.ps1"
echo.
pause
