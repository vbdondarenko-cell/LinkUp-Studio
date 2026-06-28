@echo off
:: ═══════════════════════════════════════════════════════════════════════════════════════
:: LinkUp Studio Startup Launcher
:: Launches startup script silently without showing PowerShell window
:: ═══════════════════════════════════════════════════════════════════════════════════════
:: Add this file to Windows Startup folder:
:: %APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\
:: ═══════════════════════════════════════════════════════════════════════════════════════

:: Get script directory
set "SCRIPT_DIR=%~dp0"

:: Set config file path
set "CONFIG_FILE=%LOCALAPPDATA%\LinkUpStudio\startup_config.json"

:: Run PowerShell silently
powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "%SCRIPT_DIRstartup.ps1" -ConfigFile "%CONFIG_FILE%"

:: Exit silently
exit