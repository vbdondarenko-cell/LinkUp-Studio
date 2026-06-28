@echo off
:: ═══════════════════════════════════════════════════════════════════════════════════════
:: LinkUp Studio One-Click Installer Launcher
:: ═══════════════════════════════════════════════════════════════════════════════════════
:: Run this file as Administrator for a one-click installation
:: ═══════════════════════════════════════════════════════════════════════════════════════

setlocal enabledelayedexpansion

:: Get script directory
set "SCRIPT_DIR=%~dp0"
set "INSTALLER_SCRIPT=%SCRIPT_DIR%Install-LinkUpStudio.ps1"

:: Check if running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo  ═══════════════════════════════════════════════════════════════════════════════
    echo   WARNING: Administrator privileges required
    echo  ═══════════════════════════════════════════════════════════════════════════════
    echo.
    echo  Requesting administrator privileges...
    echo.
    
    :: Relaunch as administrator
    powershell -Command "Start-Process cmd -ArgumentList '/c cd /d %SCRIPT_DIR% ^&^& powershell -ExecutionPolicy Bypass -File Install-LinkUpStudio.ps1' -Verb RunAs"
    exit /b
)

:: ═══════════════════════════════════════════════════════════════════════════════════════
:: LinkUp Studio Installation
:: ═══════════════════════════════════════════════════════════════════════════════

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
echo  ║              Premium Developer Environment - One-Click Installer             ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════════════╝
echo.

:: Check if installer script exists
if not exist "%INSTALLER_SCRIPT%" (
    echo  [ERROR] Installer script not found!
    echo.
    echo  Please ensure you're running this file from the LinkUp-Studio\installer folder.
    echo.
    pause
    exit /b 1
)

:: Run the PowerShell installer
echo  Starting installation...
echo.
echo  Press any key to begin or close this window to cancel...
pause >nul

:: Change to script directory and run installer
cd /d "%SCRIPT_DIR%"

powershell -ExecutionPolicy Bypass -NoProfile -Command "& { Set-Location '%SCRIPT_DIR%'; & '.\Install-LinkUpStudio.ps1' }"

:: Check exit code
if %errorLevel% neq 0 (
    echo.
    echo  ═══════════════════════════════════════════════════════════════════════════════
    echo   Installation encountered issues. Please check the error messages above.
    echo  ═══════════════════════════════════════════════════════════════════════════════
) else (
    echo.
    echo  ═══════════════════════════════════════════════════════════════════════════════
    echo   Installation completed! Check the messages above for next steps.
    echo  ═══════════════════════════════════════════════════════════════════════════════
)

echo.
pause

:: ═══════════════════════════════════════════════════════════════════════════════════════
:: LinkUp Studio One-Click Installer Launcher
:: ═══════════════════════════════════════════════════════════════════════════════════════
