@echo off
:: ============================================
:: GitHub Dark Theme Installer
:: LinkUp Studio - Premium Windows Theme
:: ============================================

setlocal enabledelayedexpansion

echo ================================================
echo   GitHub Dark Theme - Installer
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

set "SCRIPT_DIR=%~dp0"
set "THEME_DIR=C:\Windows\Resources\Themes"
set "THEME_NAME=GitHubDark"
set "SOURCE_DIR=%SCRIPT_DIR%"

echo [INFO] Starting installation...
echo.

:: Create theme directory
echo [1/6] Creating theme directory...
if not exist "%THEME_DIR%\%THEME_NAME%" (
    mkdir "%THEME_DIR%\%THEME_NAME%"
)
if exist "%THEME_DIR%\%THEME_NAME%" (
    echo       - Theme directory created
) else (
    echo       - [ERROR] Could not create theme directory
)

:: Copy theme files
echo [2/6] Copying theme files...
if exist "%SOURCE_DIR%GitHubDark.theme" (
    copy /y "%SOURCE_DIR%GitHubDark.theme" "%THEME_DIR%\" >nul
    echo       - GitHubDark.theme copied
)

:: Copy MSSTYLES
if exist "%SOURCE_DIR%GitHubDark.msstyles" (
    copy /y "%SOURCE_DIR%GitHubDark.msstyles" "%THEME_DIR%\%THEME_NAME%\" >nul
    echo       - GitHubDark.msstyles copied
)

:: Copy wallpaper
echo [3/6] Copying wallpaper...
set "WALLPAPER_DIR=C:\Windows\Web\4K\Wallpaper\Windows"
if not exist "%WALLPAPER_DIR%" mkdir "%WALLPAPER_DIR%"
if exist "%SOURCE_DIR%assets\GitHubDark.png" (
    copy /y "%SOURCE_DIR%assets\GitHubDark.png" "%WALLPAPER_DIR%\" >nul
    echo       - Wallpaper copied
)
if exist "%SOURCE_DIR%assets\GitHubDark.jpg" (
    copy /y "%SOURCE_DIR%assets\GitHubDark.jpg" "%WALLPAPER_DIR%\" >nul
    echo       - Wallpaper (JPG) copied
)

:: Apply registry settings
echo [4/6] Applying registry settings...
if exist "%SOURCE_DIR%registry\activate-dark-mode.reg" (
    regedit /s "%SOURCE_DIR%registry\activate-dark-mode.reg"
    echo       - Registry settings applied
)

:: Set wallpaper
echo [5/6] Setting wallpaper...
set "WALLPAPER_PATH=%WALLPAPER_DIR%\GitHubDark.png"
if exist "%WALLPAPER_PATH%" (
    :: Set wallpaper using PowerShell
    powershell -Command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name Wallpaper -Value '%WALLPAPER_PATH%'"
    powershell -Command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name WallpaperStyle -Value 10"
    powershell -Command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name TileWallpaper -Value 0"
    :: Apply wallpaper
    rundll32.exe user32.dll, UpdatePerUserSystemParameters
    echo       - Wallpaper set
) else (
    echo       - [WARNING] Wallpaper file not found, skipping...
)

:: Refresh theme
echo [6/6] Refreshing theme settings...
:: Apply theme using PowerShell
powershell -Command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'ThemePage' -Value 'theme' -Type String"

:: Restart Explorer to apply changes
echo.
echo [INFO] Restarting Windows Explorer to apply changes...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

echo.
echo ================================================
echo   Installation Complete!
echo ================================================
echo.
echo   The GitHub Dark theme has been installed.
echo.
echo   Changes applied:
echo   - Theme files installed
echo   - Wallpaper set
echo   - System colors updated
echo   - Dark mode enabled
echo.
echo   NOTE: Some changes may require a restart
echo         to take full effect.
echo.
pause
exit /b 0