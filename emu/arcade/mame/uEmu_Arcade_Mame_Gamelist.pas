unit uEmu_Arcade_Mame_Gamelist;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UITypes,
  FMX.Forms,
  FMX.StdCtrls;

procedure uEmu_Arcade_Mame_Gamelist_Clear;
procedure uEmu_Arcade_Mame_Gamelist_GlowSelected;
procedure uEmu_Arcade_Mame_Gamelist_Refresh;

procedure uEmu_Arcade_Mame_Progress(vMax, vCurrent: Integer);

procedure uEmu_Arcade_Mame_Gamelist_PushDown;
procedure uEmu_Arcade_Mame_Gamelist_PushUp;
procedure uEmu_Arcade_Mame_Gamelist_PushLeft;
procedure uEmu_Arcade_Mame_Gamelist_PushRight;

procedure uEmu_Arcade_Mame_Gamelist_Create_Available(vList_Rom, vList_Name, vRomPath: Tstringlist; vRemove: Boolean);
procedure uEmu_Arcade_Mame_Gemelist_Create_Filter(vIniPath, vFilter: String);

function uEmu_Arcade_Mame_Gamelist_GameInfo(vRomName: String): Tstringlist;

var
  vMasterGameList: Tstringlist;
  vMasterGameList_n: Tstringlist;

implementation

uses
  uLoad_AllTypes,
  uSnippet_Text,
  uSnippet_Search,
  uWindows,
  uEmu_Arcade_Mame_AllTypes,
  uEmu_Arcade_Mame_Game_SetAll,
  uEmu_Arcade_Mame_Filters;

procedure uEmu_Arcade_Mame_Gamelist_Clear;
var
  vi: Integer;
begin
  for vi := 0 to 20 do
  begin
    vMame.Scene.Gamelist.List_Line[vi].Text.Text := '';
    vMame.Scene.Gamelist.List_Line[vi].Text.Color := TAlphaColorRec.White;
  end;
end;

procedure uEmu_Arcade_Mame_Gamelist_GlowSelected;
begin
  vMame.Scene.Gamelist.List_Selection_Glow.Enabled := False;
  vMame.Scene.Gamelist.List_Selection_Glow.Enabled := True;
end;

procedure uEmu_Arcade_Mame_Gamelist_Refresh;
var
  vi, ri, ki: Integer;
begin
  mame.Gamelist.Loading_Done := False;
  uEmu_Arcade_Mame_Gamelist_Clear;
  ri := mame.Gamelist.Selected - 10;
  for vi := 0 to 20 do
  begin
    if ((mame.Gamelist.Selected + 10) + vi < 20) or ((mame.Gamelist.Selected + 10) + vi > mame.Gamelist.Games_Count) then
    begin
      vMame.Scene.Gamelist.List_Line[vi].Text.Text := '';
      ri := -1;
    end
    else
    begin
      vMame.Scene.Gamelist.List_Line[vi].Text.Text := mame.Gamelist.ListGames.Strings[ri];
      if uSnippet_Text_ToPixels(vMame.Scene.Gamelist.List_Line[vi].Text) > 640 then
        vMame.Scene.Gamelist.List_Line[vi].Text.Text := uSnippet_Text_SetInGivenPixels(640, vMame.Scene.Gamelist.List_Line[vi].Text);
      for ki := 0 to mame.Emu.Ini.CORE_SEARCH_rompath.Count - 1 do
      begin
        if FileExists(mame.Emu.Ini.CORE_SEARCH_rompath.Strings[ki] + '\' + mame.Gamelist.ListRoms[ri] + '.zip') then
          vMame.Scene.Gamelist.List_Line[vi].Text.Color := TAlphaColorRec.White
        else
          vMame.Scene.Gamelist.List_Line[vi].Text.Color := TAlphaColorRec.Red;
      end;
    end;
    inc(ri, 1);
  end;
  uEmu_Arcade_Mame_Gamelist_GlowSelected;
  mame.Gamelist.Loading_Done := True;
  vMame.Scene.Gamelist.T_Games_Count_Info.Text := IntToStr(mame.Gamelist.Selected + 1) + '/' + IntToStr(mame.Gamelist.Games_Count);
end;

/// /////////////////////////////////////////////////////////////////////////////
procedure uEmu_Arcade_Mame_Progress(vMax, vCurrent: Integer);
var
  vProgressValue: Single;
begin
  Application.ProcessMessages;
  vProgressValue := (vCurrent * 100) / vMax;
  vFilter_Progress_Bar.Value := vProgressValue;
end;
/// /////////////////////////////////////////////////////////////////////////////

procedure uEmu_Arcade_Mame_Gamelist_Create_Available(vList_Rom, vList_Name, vRomPath: Tstringlist; vRemove: Boolean);
var
  Rec: TSearchRec;
  vi, vfi, vgi: Integer;
  vRom_ext: String;
  vRom: String;
  vRom_Paths: array [0 .. 100] of string;
  vFilesNum: Integer;
begin
  { vMasterGameList := Tstringlist.Create;
    vMasterGameList_n := Tstringlist.Create;
    if vRemove then
    begin
    for vi := 0 to vList_Rom.Count - 1 do
    begin
    vMasterGameList.Add(mame.Gamelist.All_M.Roms[vi]);
    vMasterGameList_n.Add(mame.Gamelist.All_M.Names[vi]);
    end;
    end
    else
    begin
    for vi := 0 to vList_Rom.Count do
    begin
    vMasterGameList.Add('');
    vMasterGameList_n.Add('');
    end;
    end;

    for vi := 0 to vRomPath.Count - 1 do
    begin
    vRom_Paths[vi] := vRomPath.Strings[vi];
    if vRom_Paths[0] = 'roms' then
    vRom_Paths[0] := mame.Emu.Path + 'roms';
    vFilter_Label_Info.Text :=
    'This happend only for the first time user changes the mame version or add a new rom directory.';
    vFilter_Label_Info_2.Text := ' Please wait... Accessing rom path : ' + vRom_Paths[vi];

    vFilesNum := uWindows_CountFilesOrFolders(vRom_Paths[vi], True, '.zip');
    vgi := 0;
    vFilter_Progress_Bar.Visible := True;
    if FindFirst(vRom_Paths[vi] + '\*.zip', faAnyFile, Rec) = 0 then
    repeat
    if ((Rec.Attr and faDirectory) <> faDirectory) then
    begin
    vRom_ext := ExtractFileExt(Rec.Name);
    vRom := Trim(Copy(Rec.Name, 0, length(Rec.Name) - length(vRom_ext)));
    if vList_Rom.IndexOf(vRom) <> -1 then
    begin
    vfi := vList_Rom.IndexOf(vRom);
    if vRemove then
    begin
    if vMasterGameList.Strings[vfi] <> '' then
    begin
    vMasterGameList.Delete(vfi);
    vMasterGameList.Insert(vfi, '');
    vMasterGameList_n.Delete(vfi);
    vMasterGameList_n.Insert(vfi, '');
    end;
    end
    else
    begin
    if vMasterGameList.Strings[vfi] = '' then
    begin
    vMasterGameList.Delete(vfi);
    vMasterGameList.Insert(vfi, vRom);
    vMasterGameList_n.Delete(vfi);
    vMasterGameList_n.Insert(vfi, vList_Name.Strings[vfi]);
    end;
    end;
    end;
    end;
    uEmu_Arcade_Mame_Progress(vFilesNum, vgi);
    inc(vgi, 1);
    until FindNext(Rec) <> 0;
    vFilter_Progress_Bar.Visible := False;
    end;

    for vi := vMasterGameList.Count - 1 downto 0 do
    begin
    if vMasterGameList.Strings[vi] = '' then
    begin
    vMasterGameList.Delete(vi);
    vMasterGameList_n.Delete(vi);
    end;
    end; }
end;

procedure uEmu_Arcade_Mame_Gemelist_Create_Filter(vIniPath, vFilter: String);
var
  vTextFile: TextFile;
  vText: String;
  vi, vl, vgi, vFilesCount: Integer;
  vFound_Root: Boolean;
  vRom, vName: String;
  vNumName: Integer;
begin
  { Application.ProcessMessages;
    vMasterGameList := Tstringlist.Create;
    vMasterGameList_n := Tstringlist.Create;

    vFound_Root := False;

    AssignFile(vTextFile, vIniPath);
    Reset(vTextFile);
    while not Eof(vTextFile) do
    begin
    Readln(vTextFile, vText);
    if vFound_Root then
    vMasterGameList.Add(vText);
    if vText = '[ROOT_FOLDER]' then
    vFound_Root := True
    end;
    CloseFile(vTextFile);

    vFilter_Label_Info.Text :=
    'This happend only for the first time user changes the mame version or add a new rom directory.';
    vFilter_Label_Info_2.Text := 'Please wait... loading filter.';

    vgi := 0;
    vFilesCount := vMasterGameList.Count;

    for vi := 0 to vMasterGameList.Count - 1 do
    begin
    vl := mame.Gamelist.All_M.Roms.IndexOf(vMasterGameList.Strings[vi]);
    if vl <> -1 then
    vMasterGameList_n.Add(mame.Gamelist.All_M.Names[vl])
    else
    vMasterGameList_n.Add('Not Supported');
    uEmu_Arcade_Mame_Progress(vFilesCount, vgi);
    inc(vgi, 1);
    end;

    vMasterGameList_n.Sort;

    vFilter_Label_Info_2.Text := 'Please wait... Sorting filter.';
    vgi := 0;
    vFilesCount := vMasterGameList_n.Count;

    for vi := 0 to vMasterGameList_n.Count - 1 do
    begin
    vName := vMasterGameList_n.Strings[vi];
    vNumName := mame.Gamelist.All_M.Names.IndexOf(vName);
    if vNumName <> -1 then
    vRom := mame.Gamelist.All_M.Roms.Strings[vNumName]
    else
    vRom := 'Not Supported';
    vMasterGameList.Delete(vi);
    vMasterGameList.Insert(vi, vRom);
    uEmu_Arcade_Mame_Progress(vFilesCount, vgi);
    inc(vgi, 1);
    end;
  }
end;

/// /////////////////////////////////////////////////////////////////////////////
function uEmu_Arcade_Mame_Gamelist_GameInfo(vRomName: String): Tstringlist;
begin

end;

/// /////////////////////////////////////////////////////////////////////////////
procedure uEmu_Arcade_Mame_Gamelist_PushDown;
var
  vi, ri: Integer;
begin
  if mame.Gamelist.Selected <> mame.Gamelist.Games_Count then
  begin
    if extrafe.prog.Virtual_Keyboard = False then
      if uSnippet_Search.vSearch.Actions.Active then
        uSnippet_Search.Clear;
    inc(mame.Gamelist.Selected, 1);
    uEmu_Arcade_Mame_Gamelist_Refresh;
    mame.Gamelist.Timer.Enabled := False;
    mame.Gamelist.Timer.Enabled := True;
  end;
end;

procedure uEmu_Arcade_Mame_Gamelist_PushUp;
begin
  if mame.Gamelist.Selected <> 0 then
  begin
    dec(mame.Gamelist.Selected, 1);
    uEmu_Arcade_Mame_Gamelist_Refresh;
    mame.Gamelist.Timer.Enabled := False;
    mame.Gamelist.Timer.Enabled := True;
  end;
end;

procedure uEmu_Arcade_Mame_Gamelist_PushLeft;
begin
  if mame.Gamelist.Loading_Done then
    if mame.Gamelist.Selected > 20 then
    begin
      dec(mame.Gamelist.Selected, 20);
      uEmu_Arcade_Mame_Gamelist_Refresh;
      mame.Gamelist.Timer.Enabled := False;
      mame.Gamelist.Timer.Enabled := True;
    end;
end;

procedure uEmu_Arcade_Mame_Gamelist_PushRight;
begin
  if mame.Gamelist.Loading_Done then
    if mame.Gamelist.Selected < mame.Gamelist.Games_Count - 20 then
    begin
      inc(mame.Gamelist.Selected, 20);
      uEmu_Arcade_Mame_Gamelist_Refresh;
      mame.Gamelist.Timer.Enabled := False;
      mame.Gamelist.Timer.Enabled := True;
    end;
end;

end.
