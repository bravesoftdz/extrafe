unit uSoundplayer_Scrapers_AZLyrics;

interface
uses
  System.Classes,
  System.SysUtils,
  uInternet_files;


function Correct(vName: String): String;
function Get_From_Page(vPath: String): TStringList;
function Lyrics(vSong, vArtist: String): TStringList;

implementation
uses
  uLoad_AllTypes,
  uSoundplayer_AllTypes;

function Correct(vName: String): String;
begin
  Result:= vName.Trim(['.' ,'/', '\', '''', '?', '#']);
  Result:= Trim(Result);
  Result:= StringReplace(Result, ' ', '', [rfReplaceAll]);
  Result:= LowerCase(Result);
end;

function Get_From_Page(vPath: String): TStringList;
const
  vStart = '<!-- Usage of azlyrics.com content by any third-party lyrics provider is prohibited by our licensing agreement. Sorry about that. -->';
  vStop = '<!-- MxM banner -->';
var
  vTextFile: TextFile;
  vString: String;
  vi: Integer;
  vStart_Add: Boolean;
  vTemp_List: TStringList;
begin
  Result:= TStringList.Create;
  vTemp_List:= TStringList.Create;
  vStart_Add:= False;
  AssignFile(vTextFile, vPath);
  Reset(vTextFile);
  while not eof(vTextFile) do
  begin
    Readln(vTextFile, vString);
    if vString= vStart then
      vStart_Add:= True;
    if vStart_Add then
    begin
      if vString= vStop then
        Break
      else
        vTemp_List.Add(vString);
    end;
  end;
  CloseFile(vTextFile);

  for vi := 0 to vTemp_List.Count - 1 do
  begin
    vString:= vTemp_List.Strings[vi];
    if (vString= vStart) or (vString = '</div>') then
      vString := ''
    else
      vString:= StringReplace(vString, '<br>', ' ', [rfReplaceAll]);
    Result.Add(vString);
  end;
  FreeAndNil(vTemp_List);
end;

function Lyrics(vSong, vArtist: String): TStringList;
var
  vSong_Name, vArtist_Name, vTemp_Path : String;
begin
  vTemp_Path := addons.soundplayer.Path.Files + 'temp_int_lyrics.txt';
  vSong_Name:= Correct(vSong);
  vArtist_Name:= Correct(vArtist);
  Result:= TStringList.Create;
  Result.Add(uInternet_files.GetPage('https://www.azlyrics.com/lyrics/'+ vArtist_Name + '/'+ vSong_Name +'.html'));
  Result.SaveToFile(vTemp_Path);
  Result:= Get_From_Page(vTemp_Path);
  DeleteFile(vTemp_Path);
  vSoundplayer.Tag.mp3.Lyrics_Int.Add.Enabled:= True;
end;

end.
