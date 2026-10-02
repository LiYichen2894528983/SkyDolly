#ifndef PackageDir
  #error PackageDir must be provided with /DPackageDir=...
#endif
#ifndef OutputDir
  #define OutputDir "."
#endif

[Setup]
AppId={{C647D82B-7DCD-4585-A35A-17A7E771322A}
AppName=Sky Dolly 简体中文版
AppVersion=0.20.0
AppPublisher=Sky Dolly
AppPublisherURL=https://github.com/LiYichen2894528983/SkyDolly
DefaultDirName={localappdata}\Programs\SkyDolly-zh_CN
DefaultGroupName=Sky Dolly 简体中文版
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
OutputDir={#OutputDir}
OutputBaseFilename=SkyDolly-0.20.0-zh_CN-Setup
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
UninstallDisplayIcon={app}\SkyDolly.exe
LicenseFile={#PackageDir}\LICENSE
CloseApplications=no
RestartApplications=no

[Languages]
Name: "chinesesimp"; MessagesFile: "ChineseSimplified.isl"

[Tasks]
Name: "desktopicon"; Description: "创建桌面快捷方式"; GroupDescription: "快捷方式："; Flags: unchecked

[Files]
Source: "{#PackageDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Sky Dolly 简体中文版"; Filename: "{app}\SkyDolly.exe"; WorkingDir: "{app}"
Name: "{autodesktop}\Sky Dolly 简体中文版"; Filename: "{app}\SkyDolly.exe"; WorkingDir: "{app}"; Tasks: desktopicon

[Run]
Filename: "{app}\SkyDolly.exe"; Description: "启动 Sky Dolly"; Flags: nowait postinstall skipifsilent
