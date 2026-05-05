[Setup]
AppId={{9F3C2E1A-6B4D-4C91-9A7B-2D5F8E7C1234}
AppName=Examly Skavela
AppVersion=1.0
AppPublisher=AM PTI 2026
DefaultDirName={pf}\Examly Skavela
DefaultGroupName=Examly Skavela
OutputDir=output
OutputBaseFilename=Examly_Skavela_Installer
Compression=lzma
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
SetupIconFile=D:\Projects\skavela_app\windows\runner\resources\Logo.ico

[Files]
Source: "D:\Projects\skavela_app\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs ignoreversion

[Icons]
Name: "{group}\Examly Skavela"; Filename: "{app}\skavela_app.exe"
Name: "{commondesktop}\Examly Skavela"; Filename: "{app}\skavela_app.exe"

[Run]
Filename: "{app}\skavela_app.exe"; Description: "Jalankan Examly Skavela"; Flags: nowait postinstall skipifsilent