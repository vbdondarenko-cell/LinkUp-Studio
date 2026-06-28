@echo off
:: ============================================
:: GitHub Dark Theme Uninstaller
:: LinkUp Studio - Premium Windows Theme
:: ============================================

setlocal enabledelayedexpansion

echo ================================================
echo   GitHub Dark Theme - Uninstaller
echo   LinkUp Studio - Premium Windows Theme
echo ================================================
echo.

:: Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Please run this script as Administrator
    echo Right-click and select "Run as administrator"
    pause
    exit /b 1
)

set "THEME_DIR=C:\Windows\Resources\Themes"
set "THEME_NAME=GitHubDark"

echo [INFO] Starting uninstallation...
echo.

:: Remove theme files
echo [1/4] Removing theme files...
if exist "%THEME_DIR%\%THEME_NAME%\GitHubDark.msstyles" (
    del /f /q "%THEME_DIR%\%THEME_NAME%\GitHubDark.msstyles"
    echo       - MSSTYLES removed
)
if exist "%THEME_DIR%\%THEME_NAME%" (
    rmdir /s /q "%THEME_DIR%\%THEME_NAME%"
    echo       - Theme directory removed
)
if exist "%THEME_DIR%\GitHubDark.theme" (
    del /f /q "%THEME_DIR%\GitHubDark.theme"
    echo       - Theme file removed
)

:: Revert registry settings
echo [2/4] Reverting registry settings...
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /f >nul 2>&1
echo       - Theme preferences reset

:: Restore default colors
echo [3/4] Restoring default colors...
reg add "HKCU\Control Panel\Colors" /v "ActiveBorder" /t REG_SZ /d "212 212 212" /f >nul 2>&1
reg add "HKCU\Control Panel\Colors" /v "ActiveTitle" /t REG_SZ /d "0 114 198" /f >nul 2>&1
reg add "HKCU\Control Panel\Colors" /v "Background" /t REG_SZ /d "0 74 144" /f >nul 2>&1
reg add "HKCU\Control Panel\Colors" /v "ButtonFace" /t REG_SZ /d "240 240 240" /f >nul 2>&1
reg add "HKCU\Control Panel\Colors" /v "ButtonText" /t REG_SZ /d "0 0 0" /f >nul 2>&1
reg add "HKCU\Control Panel\Colors" /v "Hilight" /t REG_SZ /d "0 120 215" /f >nul 2>&1
reg add "HKCU\Control Panel\Colors" /v "HilightText" /t REG_SZ /d "255 255 255" /f >nul 2>&1
reg add "HKCU\Control Panel\Colors" /v "Window" /t REG_SZ /d "255 255 255" /f >nul 2>&1
reg add "HKCU\Control Panel\Colors" /v "WindowText" /t REG_SZ /d "0 0 0" /f >nul 2>&1
echo       - Colors restored

:: Restart Explorer
echo [4/4] Restarting Windows Explorer...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

echo.
echo ================================================
echo   Uninstallation Complete!
echo ================================================
echo.
echo   The GitHub Dark theme has been removed.
echo.
echo   NOTE: You may need to manually switch to
echo         a different theme in Settings.
echo.
pause
exit /b 0