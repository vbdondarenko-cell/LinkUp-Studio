; ═══════════════════════════════════════════════════════════════════════════════════════
; LinkUp Studio Installer Script for Inno Setup
; Build: iscc LinkUp-Studio.iss
; ═══════════════════════════════════════════════════════════════════════════════════════

#define MyAppName "LinkUp Studio"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "LinkUp Studio"
#define MyAppURL "https://github.com/vbdondarenko-cell/LinkUp-Studio"
#define MyAppExeName "LinkUp-Studio.exe"

[Setup]
; App information
AppId={{8F6B4E5D-2A3C-4B7D-9E1F-0A2B3C4D5E6F}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}

; Installation directories
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
AllowNoIcons=yes

; Output
OutputDir=Output
OutputBaseFilename=LinkUp-Studio-Setup-{#MyAppVersion}
SetupIconFile=..\windows-experience\icons\linkup-studio.ico
UninstallDisplayIcon={app}\{#MyAppExeName}

; Compression
Compression=lzma2/ultra64
SolidCompression=yes
LZMAUseSeparateProcess=yes
LZMANumBlockThreads=4

; Privileges
PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=dialog

; UI
WizardStyle=modern
WizardSizePercent=120
WizardImageFile=compiler:WizModernImage.bmp
WizardSmallImageFile=compiler:WizModernSmallImage.bmp

; Misc
ChangesAssociations=yes
DisableWelcomePage=no
DisableDirPage=no
DisableReadyPage=no
DisableFinishedPage=no
ShowLanguageDialog=no
DisableMemoText=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1; Check: not IsAdminInstallMode
Name: "startup"; Description: "Start automatically with Windows"; GroupDescription: "Startup:"; Flags: unchecked
Name: "terminal"; Description: "Configure Windows Terminal"; GroupDescription: "Additional options:"; Flags: checkedonce
Name: "profile"; Description: "Install PowerShell profile"; GroupDescription: "Additional options:"; Flags: checkedonce
Name: "cursors"; Description: "Install custom cursors"; GroupDescription: "Additional options:"; Flags: checkedonce
Name: "icons"; Description: "Install desktop icons"; GroupDescription: "Additional options:"; Flags: checkedonce

[Files]
; Main application files
Source: "..\..\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

; Note: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\Uninstall {#MyAppName}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Registry]
; Startup entry
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "LinkUpStudio"; ValueData: """{app}\startup.bat"""; Flags: uninsdeletevalue; Tasks: startup

; File associations
Root: HKA; Subkey: "Software\Classes\.linkup"; ValueType: string; ValueData: "LinkUpStudio.Project"; Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\LinkUpStudio.Project"; ValueType: string; ValueData: "LinkUp Studio Project"; Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\LinkUpStudio.Project\DefaultIcon"; ValueType: string; ValueData: "{app}\icons\linkup-studio.ico,0"
Root: HKA; Subkey: "Software\Classes\LinkUpStudio.Project\shell\open\command"; ValueType: string; ValueData: """{app}\{#MyAppExeName}"" ""%1"""

[Run]
; Launch after install
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

; Run terminal config
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File ""{app}\windows-terminal\install.ps1"""; Flags: runhidden; Tasks: terminal

[Code]
// ═══════════════════════════════════════════════════════════════════════════════════════
// Pascal Script for custom installation logic
// ═══════════════════════════════════════════════════════════════════════════════════════

var
  InstallPage: TOutputMsgWizardPage;

procedure InitializeWizard;
begin
  // Create custom welcome page
  InstallPage := CreateOutputMsgPage(wpWelcome,
    'Welcome to LinkUp Studio Setup',
    'LinkUp Studio is a premium developer environment inspired by GitHub, Linear, Raycast, and Arc Browser.' + #13#10 + #13#10 +
    'This setup will install:' + #13#10 +
    '  • GitHub Dark theme for Windows' + #13#10 +
    '  • Windows Terminal configuration' + #13#10 +
    '  • PowerShell profile with developer shortcuts' + #13#10 +
    '  • Custom cursors and icons' + #13#10 +
    '  • Auto-startup configuration' + #13#10 + #13#10 +
    'Click Next to continue, or Cancel to exit Setup.',
    'Click Next to continue.'
  );
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    // Post-installation tasks can be added here
  end;
end;

// Check if Windows Terminal is installed
function IsWindowsTerminalInstalled(): Boolean;
var
  TerminalPath: String;
begin
  TerminalPath := ExpandConstant('{localappdata}\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe');
  Result := DirExists(TerminalPath);
end;

// Check if running as admin
function IsAdminInstallMode(): Boolean;
begin
  Result := IsAdmin();
end;