@echo off
:: ═══════════════════════════════════════════════════════════════════════════════════════
:: LinkUp Studio Windows Experience - One-Click Setup
:: ═══════════════════════════════════════════════════════════════════════════════════════

setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"

echo.
echo  ╔══════════════════════════════════════════════════════════════════════════════╗
echo  ║                                                                              ║
echo  ║    ██╗    ██╗  ██████╗  ██████╗  ██████╗     ███╗   ███╗ ██████╗ ██████╗   ║
echo  ║    ██║    ██║ ██╔════╝ ██╔════╝ ██╔═══██╗    ████╗ ████║██╔═══██╗██╔══██╗  ║
echo  ║    ██║ █╗ ██║ ██║  ███╗██║  ███╗██║   ██║    ██╔████╔██║██║   ██║██║  ██║  ║
echo  ║    ██║███╗██║ ██║   ██║██║   ██║██║   ██║    ██║╚██╔╝██║██║   ██║██║  ██║  ║
echo  ║    ╚██████╔╝ ╚██████╔╝╚██████╔╝╚██████╔╝    ██║ ╚═╝ ██║╚██████╔╝██████╔╝  ║
echo  ║     ╚═══██╔╝   ╚═════╝  ╚═════╝  ╚═════╝     ╚═╝     ╚═╝ ╚═════╝ ╚═════╝   ║
echo  ║                                                                              ║
echo  ║                    Windows Experience Setup                                    ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

:: Check for administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo  [!] Administrator privileges required
    echo.
    echo  Requesting elevation...
    powershell -Command "Start-Process cmd -ArgumentList '/c cd /d %SCRIPT_DIR% ^&^& scripts\Install-LinkUpStudio-Experience.ps1' -Verb RunAs
    exit /b
)

echo  [i] Starting LinkUp Studio Windows Experience setup...
echo.

:: Run the PowerShell installer
cd /d "%SCRIPT_DIR%"
powershell -ExecutionPolicy Bypass -NoProfile -Command "& { Set-Location '%SCRIPT_DIR%scripts'; & '.\Install-LinkUpStudio-Experience.ps1' }"

echo.
echo  [i] Setup complete!
echo.
pause

:: ═══════════════════════════════════════════════════════════════════════════════════════
:: LinkUp Studio Windows Experience - One-Click Setup
:: ═══════════════════════════════════════════════════════════════════════════════════════
