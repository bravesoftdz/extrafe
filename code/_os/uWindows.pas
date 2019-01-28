unit uWindows;

interface

uses
{$IFDEF MACOS}
  MacApi.Appkit,
  MacApi.CoreFoundation,
  MacApi.Foundation,
{$ENDIF}
{$IFDEF MSWINDOWS}
  System.SysUtils,
  System.Classes,
  Winapi.ShellApi,
  Winapi.Windows,
  Winapi.Winsock,
  Winapi.WinInet,
  Winapi.Messages,
  ActiveX,
  comobj,
  FMX.Platform.Win,
  FMX.Graphics,
  FMX.Forms,
  scktComp;
{$ENDIF}

// Resolutions Type
type
  TMONITOR_RESOLUTION = record
    Horizontal: Integer;
    Vertical: Integer;
    Refresh_Rate: Integer;
    Bits_Per_Pixel: Integer;
  end;

  // program info build
function uWindows_GetVersionInfo(mFileName: string): TStringlist;
// windows monitor resolutions
function uWindows_GetCurrent_Monitor_Resolution: TMONITOR_RESOLUTION;

var
  vMonitor_Resolution: TMONITOR_RESOLUTION;
function uWindows_GetMonitor_Available_Resolutions: TStringlist;
function uWindows_GetMOnitor_Available_Refreshs: TStringlist;
// Convertions
function uWindows_ConvertSecondsFromTime(mTime: Real): TDateTime;
// Files and folders
function uWindows_CountFilesOrFolders(vDir: String; vKind: Boolean; vType: String): Integer;
function uWindows_GetFolderNames(vDir: String): TStringlist;
function uWindows_GetFileNames(vDir: String; vFileType: String): TStringlist;
procedure uWindows_DeleteDirectory(const DirName: string; vFileMask: String; vDelSubDirs: Boolean);

// function GetFileInUseInfo(const FileName : WideString) : IFileIsInUse;
// const
// IID_IFileIsInUse: TGUID = (D1: $64A1CBF0; D2: $3A1A; D3: $4461; D4: ($91, $58, $37, $69, $69, $69, $39, $50));
// IFileIsInUse = interface(IUnknown)['{64a1cbf0-3a1a-4461-9158-376969693950}']
function IsFileInUse(FileName: TFileName): Boolean;
// internet
function uWindows_IsConected_ToInternet: Boolean;
function uWindows_GetIPAddress: String;
// machine info
function uWindows_OsArchitectureToStr(Const vOsArch: TOSVersion.TArchitecture): String;
function uWindows_OsPlatformToStr(Const vOsPlatform: TOSVersion.TPlatform): String;
function uWindoes_OsPlatformPointerToInt: Integer;
// Fonts
function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric; FontType: Integer; Data: Pointer)
  : Integer; stdcall;
procedure uWindows_CollectFonts(FontList: TStringlist);

implementation

uses
  main,
  Loading;

// Dns server list const dll
const
{$IFDEF MSWINDOWS}
  iphlpapidll = 'iphlpapi.dll';
{$ENDIF}

  // Just gets the version info
function uWindows_GetVersionInfo(mFileName: string): TStringlist;
var
  VerInfoSize: Cardinal;
  VerValueSize: Cardinal;
  Dummy: Cardinal;
  PVerInfo: Pointer;
  PVerValue: PVSFixedFileInfo;
begin
  Result := TStringlist.Create;
  VerInfoSize := GetFileVersionInfoSize(PChar(mFileName), Dummy);
  GetMem(PVerInfo, VerInfoSize);
  try
    if GetFileVersionInfo(PChar(mFileName), 0, VerInfoSize, PVerInfo) then
      if VerQueryValue(PVerInfo, '\', Pointer(PVerValue), VerValueSize) then
        with PVerValue^ do
        begin
          Result.Add(FloatToStr(HiWord(dwFileVersionMS)));
          Result.Add(FloatToStr(LoWord(dwFileVersionMS)));
          Result.Add(FloatToStr(HiWord(dwFileVersionLS)));
          Result.Add(FloatToStr(LoWord(dwFileVersionLS)));
        end;
  finally
    FreeMem(PVerInfo, VerInfoSize);
  end;
end;

function uWindows_GetCurrent_Monitor_Resolution: TMONITOR_RESOLUTION;
var
  DC: THandle;
  Bits: Integer;
  Hor: Integer;
  Ver: Integer;
  RR: Integer;
  // DM: TDevMode;
  // ModeNum: LongInt;
begin
  DC := GetDC(FmxHandleToHWND(Loading_Form.Handle));
  Bits := GetDeviceCaps(DC, BITSPIXEL);
  Hor := GetDeviceCaps(DC, HORZRES);
  Ver := GetDeviceCaps(DC, VERTRES);
  RR := GetDeviceCaps(DC, VREFRESH);
  Result.Horizontal := Hor;
  Result.Vertical := Ver;
  Result.Refresh_Rate := RR;
  Result.Bits_Per_Pixel := Bits;
  ReleaseDC(FmxHandleToHWND(Loading_Form.Handle), DC);
  {
    // Show Current Resolution
    Edit1.Text := Format('%d bit, %d x %d', [Bits, HRes, VRes]);
    ReleaseDC(Handle, DC); // Show all modes available ModeNum := 0; // The 1st one
    EnumDisplaySettings(nil, ModeNum, DM);
    ListBox1.Items.Add(Format('%d bit, %d x %d bei %d Hz', [DM.dmBitsPerPel,
    DM.dmPelsWidth, DM.dmPelsHeight, Dm.dmDisplayFrequency]));
    Ok := True;
    while Ok do
    begin
    Inc(ModeNum); // Get next one
    Ok := EnumDisplaySettings(nil, ModeNum, DM);
    ListBox1.Items.Add(Format('%d bit, %d x %d bei %d Hz', [DM.dmBitsPerPel,
    DM.dmPelsWidth, DM.dmPelsHeight, Dm.dmDisplayFrequency]));
    end;
  }
end;

function uWindows_ConvertSecondsFromTime(mTime: Real): TDateTime;
var
  hours, min: Word;
begin
  hours := Trunc(mTime / 3600);
  mTime := mTime - (3600 * Trunc(mTime / 3600));
  min := Trunc(mTime / 60);
  mTime := mTime - (60 * Trunc(mTime / 60));

  Result := EncodeTime(hours, min, Trunc(mTime), 0);
end;

function uWindows_CountFilesOrFolders(vDir: String; vKind: Boolean; vType: String): Integer;
var
  Rec: TSearchRec;
  nFileCount: Integer;
begin
  nFileCount := 0;
  if vKind = True then // Count Folders
  begin
    if FindFirst(vDir + '\*' + vType, faAnyFile, Rec) { *Converted from FindFirst* } = 0 then
      repeat
        // Exclude directories from the list of files.
        if ((Rec.Attr and faDirectory) <> faDirectory) then
          Inc(nFileCount);
      until FindNext(Rec) { *Converted from FindNext* } <> 0;
    System.SysUtils.FindClose(Rec); { *Converted from FindClose* }
  end
  else if vKind = False then // Cound Files
  begin
    if FindFirst(vDir + '\' + vType, faArchive, Rec) { *Converted from FindFirst* } = 0 then
      repeat
        if (Rec.Name <> '.') and (Rec.Name <> '..') then
          Inc(nFileCount);
      until FindNext(Rec) { *Converted from FindNext* } <> 0;
    System.SysUtils.FindClose(Rec); { *Converted from FindClose* }
  end;
  Result := nFileCount;
end;

function uWindows_GetFolderNames(vDir: String): TStringlist;
var
  Rec: TSearchRec;
  // nFileCount: Integer;
begin
  Result := TStringlist.Create;
  if FindFirst(vDir + '\*.*', faDirectory, Rec) { *Converted from FindFirst* } = 0 then
    repeat
      if ((Rec.Attr and faDirectory) = faDirectory) then
        if (Rec.Name <> '.') and (Rec.Name <> '..') then
          Result.Add(Rec.Name);
    until FindNext(Rec) { *Converted from FindNext* } <> 0;
  System.SysUtils.FindClose(Rec); { *Converted from FindClose* }
end;

function uWindows_GetFileNames(vDir: String; vFileType: String): TStringlist;
var
  Rec: TSearchRec;
  // nFileCount: Integer;
begin
  Result := TStringlist.Create;
  if FindFirst(vDir + '\' + vFileType, faDirectory, Rec) { *Converted from FindFirst* } = 0 then
    repeat
      if ((Rec.Attr and faAnyFile) <> 16) then
        if (Rec.Name <> '.') and (Rec.Name <> '..') then
          Result.Add(Rec.Name);
    until FindNext(Rec) { *Converted from FindNext* } <> 0;
  System.SysUtils.FindClose(Rec); { *Converted from FindClose* }
end;

{ function GetFileInUseInfo(const FileName : WideString) : IFileIsInUse;
  var
  ROT : IRunningObjectTable;
  mFile, enumIndex, Prefix : IMoniker;
  enumMoniker : IEnumMoniker;
  MonikerType : LongInt;
  unkInt  : IInterface;
  begin
  result := nil;

  OleCheck(GetRunningObjectTable(0, ROT));
  OleCheck(CreateFileMoniker(PWideChar(FileName), mFile));

  OleCheck(ROT.EnumRunning(enumMoniker));

  while (enumMoniker.Next(1, enumIndex, nil) = S_OK) do
  begin
  OleCheck(enumIndex.IsSystemMoniker(MonikerType));
  if MonikerType = MKSYS_FILEMONIKER then
  begin
  if Succeeded(mFile.CommonPrefixWith(enumIndex, Prefix)) and
  (mFile.IsEqual(Prefix) = S_OK) then
  begin
  if Succeeded(ROT.GetObject(enumIndex, unkInt)) then
  begin
  if Succeeded(unkInt.QueryInterface(IID_IFileIsInUse, result)) then
  begin
  result := unkInt as IFileIsInUse;
  exit;
  end;
  end;
  end;
  end;
  end;
  end; }

function IsFileInUse(FileName: TFileName): Boolean;
var
  HFileRes: HFILE;
begin
  Result := False;
  if not FileExists(FileName) then
    Exit;
  HFileRes := CreateFile(PChar(FileName), GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL, 0);
  Result := (HFileRes = INVALID_HANDLE_VALUE);
  if not Result then
    CloseHandle(HFileRes);
end;

function uWindows_GetMonitor_Available_Resolutions: TStringlist;
var
  vi: Integer;
  DevMode: TDeviceMode;
begin
  Result := TStringlist.Create;
  vi := 0;
{$IFOPT R+}
{$DEFINE CKRANGE}
{$R-} // range-checking of
{$ENDIF}
  Result.Sorted := True;
  Result.Duplicates := dupIgnore;
  while EnumDisplaySettings(nil, vi, DevMode) do
  begin
    with DevMode do
      If (dmPelsWidth > 639) and (dmPelsHeight > 479) then
        if dmBitsperPel > 4 then
          Result.Add(Format('%dx%d', [dmPelsWidth, dmPelsHeight]));
    // {1 shr dmBitsperPel,}dmDisplayFrequency]));
    // %d bit depth of color in bit
    Inc(vi);
  end;
{$IFDEF CKRANGE}
{$UNDEF CKRANGE}
{$R+}  // range-checking on
{$ENDIF}
end;

function uWindows_GetMOnitor_Available_Refreshs: TStringlist;
var
  vi: Integer;
  DevMode: TDeviceMode;
begin
  Result := TStringlist.Create;
  vi := 0;
{$IFOPT R+}
{$DEFINE CKRANGE}
{$R-} // range-checking of
{$ENDIF}
  Result.Sorted := True;
  Result.Duplicates := dupIgnore;
  while EnumDisplaySettings(nil, vi, DevMode) do
  begin
    with DevMode do
      If (dmPelsWidth > 639) and (dmPelsHeight > 479) then
        if dmBitsperPel > 4 then
          Result.Add(Format('%d Hz', [dmDisplayFrequency]));
    // {1 shr dmBitsperPel,}]));
    // %d bit depth of color in bit
    Inc(vi);
  end;
{$IFDEF CKRANGE}
{$UNDEF CKRANGE}
{$R+}  // range-checking on
{$ENDIF}
end;

/// /////////////////////////////////////////////////////////////////////////////
// Internet
function uWindows_GetIPAddress: String;
type
  pu_long = ^u_long;
var
  varTWSAData: TWSAData;
  varPHostEnt: PHostEnt;
  varTInAddr: TInAddr;
  namebuf: Array [0 .. 255] of ansichar;
begin
  If WSAStartup($101, varTWSAData) <> 0 Then
    Result := 'No ip found'
  Else
  Begin
    gethostname(namebuf, sizeof(namebuf));
    varPHostEnt := gethostbyname(namebuf);
    varTInAddr.S_addr := u_long(pu_long(varPHostEnt^.h_addr_list^)^);
    Result := PChar(inet_ntoa(varTInAddr));
  End;
  WSACleanup;
end;

function uWindows_IsConected_ToInternet: Boolean;
const
  // Local system has a valid connection to the Internet, but it might or might
  // not be currently connected.
  INTERNET_CONNECTION_CONFIGURED = $40;
  // Local system uses a local area network to connect to the Internet.
  INTERNET_CONNECTION_LAN = $02;
  // Local system uses a modem to connect to the Internet
  INTERNET_CONNECTION_MODEM = $01;
  // Local system is in offline mode.
  INTERNET_CONNECTION_OFFLINE = $20;
  // Local system uses a proxy server to connect to the Internet
  INTERNET_CONNECTION_PROXY = $04;
  // Local system has RAS installed.
  INTERNET_RAS_INSTALLED = $10;
var
  InetState: DWORD;
  hHttpSession, hReqUrl: HInternet;
begin
  Result := InternetGetConnectedState(@InetState, 0);
  if (Result and (InetState and INTERNET_CONNECTION_CONFIGURED = INTERNET_CONNECTION_CONFIGURED)) then
  begin
    // so far we ONLY know there's a valid connection. See if we can grab some
    // known URL ...
    hHttpSession := InternetOpen(PChar(Application.Title), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
    try
      hReqUrl := InternetOpenURL(hHttpSession, PChar('http://www.google.com' { the URL to check } ),
        nil, 0, 0, 0);
      Result := hReqUrl <> nil;
      InternetCloseHandle(hReqUrl);
    finally
      InternetCloseHandle(hHttpSession);
    end;
  end
  else if (InetState and INTERNET_CONNECTION_OFFLINE = INTERNET_CONNECTION_OFFLINE) then
    Result := False; // we know for sure we are offline.
end;

/// /////////////////////////////////////////////////////////////////////////////
// Machine os
function uWindows_OsArchitectureToStr(Const vOsArch: TOSVersion.TArchitecture): String;
begin
  case vOsArch of
    arIntelX86:
      Result := 'Intel X86';
    arIntelX64:
      Result := 'Intel X64';
    arARM32:
      Result := 'ARM X32';
    arARM64:
      Result := 'ARM X64';
  else
    Result := 'UNKNOWN OS architecture';
  end;
end;

function uWindows_OsPlatformToStr(Const vOsPlatform: TOSVersion.TPlatform): String;
begin
  case vOsPlatform of
    pfWindows:
      Result := 'Windows';
    pfMacOS:
      Result := 'MacOSX';
    pfiOS:
      Result := 'IOS';
    pfAndroid:
      Result := 'Android';
    pfWinRT:
      Result := 'Windows CE';
    pfLinux:
      Result := 'Linux';
  else
    Result := 'Unknown';
  end

end;

function uWindoes_OsPlatformPointerToInt: Integer;
begin
  Result := sizeof(Pointer) * 8;
end;

{$IFDEF MSWINDOWS}

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric; FontType: Integer; Data: Pointer)
  : Integer; stdcall;
var
  S: TStrings;
  Temp: string;
begin
  S := TStrings(Data);
  Temp := LogFont.lfFaceName;
  if (S.Count = 0) or (AnsiCompareText(S[S.Count - 1], Temp) <> 0) then
    S.Add(Temp);
  Result := 1;
end;
{$ENDIF}

procedure uWindows_CollectFonts(FontList: TStringlist);
var
{$IFDEF MACOS}
  fManager: NsFontManager;
  list: NSArray;
  lItem: NSString;
{$ENDIF}
{$IFDEF MSWINDOWS}
  DC: HDC;
  LFont: TLogFont;
{$ENDIF}
  vi: Integer;
begin

{$IFDEF MACOS}
  fManager := TNsFontManager.Wrap(TNsFontManager.OCClass.sharedFontManager);
  list := fManager.availableFontFamilies;
  if (list <> nil) and (list.Count > 0) then
  begin
    for vi := 0 to list.Count - 1 do
    begin
      lItem := TNSString.Wrap(list.objectAtIndex(vi));
      FontList.Add(String(lItem.UTF8String))
    end;
  end;
{$ENDIF}
{$IFDEF MSWINDOWS}
  DC := GetDC(0);
  FillChar(LFont, sizeof(LFont), 0);
  LFont.lfCharset := DEFAULT_CHARSET;
  EnumFontFamiliesEx(DC, LFont, @EnumFontsProc, Winapi.Windows.LPARAM(FontList), 0);
  ReleaseDC(0, DC);
{$ENDIF}
end;

procedure uWindows_DeleteDirectory(const DirName: string; vFileMask: String; vDelSubDirs: Boolean);
var
  SourceLst: string;
  FOS: TSHFileOpStruct;
begin
  FillChar(FOS, sizeof(FOS), 0);
  FOS.Wnd := FmxHandleToHWND(Main_Form.Handle);
  FOS.wFunc := FO_DELETE;
  SourceLst := DirName + '\' + vFileMask + #0;
  FOS.pFrom := PChar(SourceLst);
  if not vDelSubDirs then
    FOS.fFlags := FOS.fFlags OR FOF_FILESONLY;
  // Remove the next line if you want a confirmation dialog box
  FOS.fFlags := FOS.fFlags OR FOF_NOCONFIRMATION;
  // Uncomment the next line for a "silent operation" (no progress box)
  // FOS.fFlags := FOS.fFlags OR FOF_SILENT;
  SHFileOperation(FOS);
end;

end.
