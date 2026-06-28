@echo off
:: ═══════════════════════════════════════════════════════════════════════════════════════
:: LinkUp Studio Startup Configuration Launcher
:: ═══════════════════════════════════════════════════════════════════════════════════════
:: Run as Administrator for startup registration
:: ═══════════════════════════════════════════════════════════════════════════════════════

setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "CONFIG_SCRIPT=%SCRIPT_DIR%Configure-Startup.ps1"

:: Check if running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo  ═══════════════════════════════════════════════════════════════════════════════
    echo   Administrator privileges required
    echo  ═══════════════════════════════════════════════════════════════════════════════
    echo.
    echo  Requesting administrator privileges...
    echo.
    
    :: Relaunch as administrator
    powershell -Command "Start-Process cmd -ArgumentList '/c cd /d %SCRIPT_DIR% ^&^& Configure-Startup.bat' -Verb RunAs"
    exit /b
)

:: ═══════════════════════════════════════════════════════════════════════════════════════
:: Startup Configuration
:: ═══════════════════════════════════════════════════════════════════════════════════════

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
echo  ║                    Windows Startup Configuration                              ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

:: Check if script exists
if not exist "%CONFIG_SCRIPT%" (
    echo  [ERROR] Configuration script not found!
    echo.
    echo  Please ensure you're running from the installer\startup folder.
    echo.
    pause
    exit /b 1
)

:: Run the PowerShell configuration script
echo  Starting startup configuration...
echo.
echo  This will:
echo    1. Launch Windows Terminal with LinkUp Studio
echo    2. Launch OpenHands
echo    3. Open browser (after 500ms for services)
echo    4. Open previous project (if configured)
echo.
echo  Target: Under 10 seconds
echo.

powershell -ExecutionPolicy Bypass -NoProfile -Command "& { Set-Location '%SCRIPT_DIR%'; & '.\Configure-Startup.ps1' }"

echo.
pause

:: ═══════════════════════════════════════════════════════════════════════════════════════
:: LinkUp Studio Startup Configuration Launcher
:: ═══════════════════════════════════════════════════════════════════════════════════════
