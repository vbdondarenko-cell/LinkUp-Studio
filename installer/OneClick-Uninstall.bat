@echo off
:: ═══════════════════════════════════════════════════════════════════════════════════════
:: LinkUp Studio One-Click Uninstaller Launcher
:: ═══════════════════════════════════════════════════════════════════════════════════════
:: Run this file as Administrator for a one-click uninstallation
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
    echo   WARNING: Administrator privileges required for uninstallation
    echo  ═══════════════════════════════════════════════════════════════════════════════
    echo.
    echo  Requesting administrator privileges...
    echo.
    
    :: Relaunch as administrator
    powershell -Command "Start-Process cmd -ArgumentList '/c cd /d %SCRIPT_DIR% ^&^& powershell -ExecutionPolicy Bypass -File Install-LinkUpStudio.ps1 -Uninstall' -Verb RunAs"
    exit /b
)

:: ═══════════════════════════════════════════════════════════════════════════════════════
:: LinkUp Studio Uninstallation
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
echo  ║                  Premium Developer Environment - Uninstaller                   ║
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

:: Run the PowerShell uninstaller
echo  Starting uninstallation...
echo.
echo  You will be prompted to restore from a backup if one exists.
echo.
echo  Press any key to begin or close this window to cancel...
pause >nul

:: Change to script directory and run uninstaller
cd /d "%SCRIPT_DIR%"

powershell -ExecutionPolicy Bypass -NoProfile -Command "& { Set-Location '%SCRIPT_DIR%'; & '.\Install-LinkUpStudio.ps1' -Uninstall }"

:: Check exit code
if %errorLevel% neq 0 (
    echo.
    echo  ═══════════════════════════════════════════════════════════════════════════════
    echo   Uninstallation encountered issues. Please check the error messages above.
    echo  ═══════════════════════════════════════════════════════════════════════════════
) else (
    echo.
    echo  ═══════════════════════════════════════════════════════════════════════════════
    echo   Uninstallation completed! Check the messages above for details.
    echo  ═══════════════════════════════════════════════════════════════════════════════
)

echo.
pause

:: ═══════════════════════════════════════════════════════════════════════════════════════
:: LinkUp Studio One-Click Uninstaller Launcher
:: ═══════════════════════════════════════════════════════════════════════════════════════
