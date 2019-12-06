unit uSnippet_Convert;

interface
uses
  System.Classes,
  System.SysUtils,
  System.Inifiles,
  System.DateUtils,
  WinApi.Windows;

function Code_To_Country(vCode: String): String;
function Country_To_Code(vCountry: String): String;

function Time_To_TimeStamp: Int64;

function Seconds_To_Time(mTime: Real): TDateTime;


implementation
uses
  uLoad_AllTypes;

function Code_To_Country(vCode: String): String;
var
  vTempIni: TIniFile;
begin
  vTempIni:= TIniFile.Create(ex_main.Paths.Flags_Images+ 'en.ini');
  Result:= vTempIni.ReadString('COUNTRY', vCode, Result);
  FreeAndNil(vTempIni);
end;

function Country_To_Code(vCountry: String): String;
var
  vTextFile: TextFile;
  vKey, vValue: String;
  vIPos: Integer;
  vString: String;
begin
  AssignFile(vTextFile, ex_main.Paths.Flags_Images+ 'en.ini');
  Reset(vTextFile);
  while not EOF(vTextFile) do
  begin
    Readln(vTextFile, vString);
    vIPos:= Pos('=', vString);
    if vIPos<> 0 then
    begin
      vKey:= Trim(Copy(vString, 0, vIPos - 1));
      vValue:= Trim(Copy(vString, vIPos+ 1, Length(vString)- vIPos));
      if vValue= vCountry then
      begin
        Result:= vKey;
        Break
      end;
    end;
  end;
  CloseFile(vTextFile);
end;

function Time_To_TimeStamp: Int64;
var
  SystemTime: TSystemTime;
  NowUTC: TDateTime;
begin
  // get current time in UTC as a TDateTime...
  GetSystemTime(SystemTime);
  with SystemTime do
    NowUTC := EncodeDateTime(wYear, wMonth, wDay, wHour, wMinute, wSecond, wMilliseconds);

  // now calculate the difference from Jan 1 1970 UTC in seconds...
  Result := DateTimeToUnix(NowUTC);
end;

function Seconds_To_Time(mTime: Real): TDateTime;
var
  hours, min: Word;
begin
  hours := Trunc(mTime / 3600);
  mTime := mTime - (3600 * Trunc(mTime / 3600));
  min := Trunc(mTime / 60);
  mTime := mTime - (60 * Trunc(mTime / 60));

  Result := EncodeTime(hours, min, Trunc(mTime), 0);
end;

end.
