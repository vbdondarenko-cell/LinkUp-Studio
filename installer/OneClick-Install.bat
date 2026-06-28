@echo off
:: ═══════════════════════════════════════════════════════════════════════════════════════
:: LinkUp Studio One-Click Installer v2.0
:: Run as Administrator to install
:: ═══════════════════════════════════════════════════════════════════════════════════════

:: Check for admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ╔═══════════════════════════════════════════════════════════════╗
    echo ║  Administrator privileges required!                             ║
    echo ║  Please right-click and select "Run as administrator"        ║
    echo ╚═══════════════════════════════════════════════════════════════╝
    echo.
    pause
    exit /b 1
)

echo.
echo ╔═══════════════════════════════════════════════════════════════╗
echo ║  LinkUp Studio v2.0 - One-Click Installer                     ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.

:: Get script directory
set "SCRIPT_DIR=%~dp0"

:: Run PowerShell installer
echo [i] Starting PowerShell installer...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command "& '%SCRIPT_DIR%LinkUp-Studio-OneClick-Installer.ps1'"

:: Check result
if %errorlevel% neq 0 (
    echo.
    echo [E] Installation failed!
    echo.
    pause
    exit /b 1
)

echo.
echo [i] Installation complete!
echo.
pause