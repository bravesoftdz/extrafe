unit uEmu_Arcade_Mame_Actions;

interface

uses
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  System.UiTypes,
  System.Zip,
  FMX.Objects,
  FMX.Types,
  FMX.Layouts,
  FMX.Graphics,
  FMX.Effects;

procedure Show_Media;

procedure Activate_Animation(vImagePath: String);
procedure Show_ImageNotFound;

procedure Change_Categeroy(vDirection: String);
procedure Change_View_Mode(vMode: String);
procedure Open_Filters;
procedure Open_Lists;
procedure Open_Search;
procedure Open_Global_Configuration;

procedure Open_Favorites;
procedure Is_Favorites_Open;
procedure Is_Favorites_Closed;
procedure Add_To_Favorites;

procedure Return;
procedure Enter_Game_Menu;

procedure Search(vAction: Boolean);

var
  vMameVideoTimer: TTimer;

implementation

uses
  uDB,
  uDB_AUser,
  emu,
  uLoad_AllTypes,
  uVirtual_Keyboard,
  uSnippet_Search,
  uEmu_Arcade_Mame,
  uEmu_Arcade_Mame_AllTypes,
  uEmu_Arcade_Mame_SetAll,
  uEmu_Arcade_Mame_Gamelist,
  uEmu_Arcade_Mame_Ini,
  uEmu_Arcade_Mame_Filters,
  uEmu_Arcade_Mame_Lists,
  uEmu_Arcade_Mame_Game_SetAll,
  uEmu_Arcade_Mame_Config;

procedure Activate_Animation(vImagePath: String);
begin
  vMame.Scene.Media.T_Image.Image_Fade_Ani.Enabled := True;
  vMame.Scene.Media.T_Image.Image_Fade.Target.LoadFromFile(vImagePath);
  if ((vMame.Scene.Media.T_Image.Image_Fade.Target.Width > vMame.Scene.Media.T_Image.Image_Fade.Target.Height) and (mame.Main.Snap_Old_Width <> 650)) or
    ((vMame.Scene.Media.T_Image.Image_Fade.Target.Width < vMame.Scene.Media.T_Image.Image_Fade.Target.Height) and (mame.Main.Snap_Old_Width <> 485)) then
  begin
    vMame.Scene.Media.T_Image.Image_Width_Ani.StartValue := 0;
    vMame.Scene.Media.T_Image.Image_Height_Ani.StartValue := 0;
    vMame.Scene.Media.T_Image.Image_Y_Ani.StartValue := 55;
    vMame.Scene.Media.T_Image.Image_X_Ani.StartValue := 275;
    if vMame.Scene.Media.T_Image.Image_Fade.Target.Width > vMame.Scene.Media.T_Image.Image_Fade.Target.Height then
    begin
      vMame.Scene.Media.T_Image.Image_Width_Ani.StopValue := 650;
      vMame.Scene.Media.T_Image.Image_Height_Ani.StopValue := 485;
      vMame.Scene.Media.T_Image.Image_Y_Ani.StopValue := 55;
      vMame.Scene.Media.T_Image.Image_X_Ani.StopValue := 50;
    end
    else
    begin
      vMame.Scene.Media.T_Image.Image_Width_Ani.StopValue := 485;
      vMame.Scene.Media.T_Image.Image_Height_Ani.StopValue := 650;
      vMame.Scene.Media.T_Image.Image_Y_Ani.StopValue := 55;
      vMame.Scene.Media.T_Image.Image_X_Ani.StopValue := 132;
    end;

    // vMame.Scene.Media.Image_Height_Ani.Enabled := True;
    vMame.Scene.Media.T_Image.Image_Width_Ani.Enabled := True;
    vMame.Scene.Media.T_Image.Image_Y_Ani.Enabled := True;
    vMame.Scene.Media.T_Image.Image_X_Ani.Enabled := True;
  end;

  mame.Main.Snap_Old_Width := vMame.Scene.Media.T_Image.Image_Width_Ani.StopValue;
end;

procedure Show_ImageNotFound;
begin
  if not FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Snapshots + 'image_not_found.png') then
    vMame.Scene.Media.T_Image.Image.Bitmap := nil
  else
    vMame.Scene.Media.T_Image.Image.Bitmap.LoadFromFile(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Snapshots + 'image_not_found.png');
end;

procedure Show_Media;
var
  vImageExists: Boolean;
begin
  if mame.Main.SnapCategory = 'Video Snaps' then
  begin
    mame.Gamelist.Timer.Enabled := False;
    if Assigned(vMameVideoTimer) then
      FreeAndNil(vMameVideoTimer);
    vMame.Scene.Media.Video.Stop;
    if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Videos + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.mp4') then
    begin
      vMameVideoTimer := TTimer.Create(vMame.Scene.Main);
      vMameVideoTimer.Enabled := True;
      vMameVideoTimer.OnTimer := mame.Timers.Video.OnTimer;
      vMame.Scene.Media.Video.Visible := True;
      if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Snapshots + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
      begin
        vMame.Scene.Media.Video.PlayNormal(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Snapshots + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png');
      end
    end
    else
    begin
      if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Snapshots + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
      begin
        vMame.Scene.Media.Video.PlayNormal(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Snapshots + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png');
      end
      else
      begin
        vMame.Scene.Media.Video.PlayNormal(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Snapshots + 'imagenotfound.png');
      end;
    end;
  end
  else
  begin
    vImageExists := False;
    case IndexStr(mame.Main.SnapCategory, ['Snapshots', 'Cabinets', 'Control Panels', 'Flyers', 'Marquees', 'Pcbs', 'Artwork Preview', 'Bosses', 'How To', 'Logos', 'Scores', 'Selects', 'Titles',
      'Versus', 'Game Over', 'Ends', 'Warnings']) of
      0:
        if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Snapshots + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Snapshots + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      1:
        if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Cabinets + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Cabinets + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      2:
        if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Control_Panels + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Control_Panels + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      3:
        if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Flyers + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Flyers + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      4:
        if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Marquees + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Marquees + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      5:
        if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Pcbs + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Pcbs + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      6:
        if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Artwork_Preview + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Artwork_Preview + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      7:
        if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Bosses + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Bosses + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      8:
        if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.How_To + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(uDB_AUser.Local.EMULATORS.Arcade_D.Media.How_To + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      9:
        if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Logos + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Logos + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      10:
        if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Scores + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Scores + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      11:
        if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Selects + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Selects + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      12:
        if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Titles + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Titles + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      13:
        if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Versus + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Versus + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      14:
        if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Game_Over + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Game_Over + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      15:
        if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Ends + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Ends + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      16:
        if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Warnings + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Warnings + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
    end;
  end;

  { if mame.Main.SnapCategory = 'Video Snaps' then
    begin
    if mame.Main.SnapMode = 'frame' then
    begin
    if vMame.Scene.Media.Image.Bitmap.Width > vMame.Scene.Media.Image.Bitmap.Height then
    vMame.Scene.Media.Image.SetBounds((vMame.Scene.Right.Width / 2) - 315, 215, 630, 470)
    else
    vMame.Scene.Media.Image.SetBounds((vMame.Scene.Right.Width / 2) - 235, 55, 470, 630);
    end
    end }
end;

/// /////////////////////////////////////////////////////////////////////////////
procedure Open_Filters;
begin
  uEmu_Arcade_Mame_Filters.Load;
end;

procedure Open_Lists;
begin
  uEmu_Arcade_Mame_Lists.Load;
end;

procedure Open_Search;
begin
  if uDB_AUser.Local.OPTIONS.Visual.Virtual_Keyboard then
  begin
    mame.Gamelist.Search_Selected := mame.Gamelist.Selected;
    uVirtual_Keyboard.Create(Emu_Form, 'Search', 'Search for a game', vMame.Scene.Main);
  end
  else if uSnippet_Search.vSearch.Scene.Edit.Width = 0 then
  begin
    uSnippet_Search.vSearch.Scene.Edit_Ani.Start;
    Search(True);
  end;
end;

procedure Change_View_Mode(vMode: String);
begin
  { if mame.Main.SnapMode = 'arcade' then
    mame.Main.SnapMode := 'frame'
    else
    mame.Main.SnapMode := 'arcade';
    uEmu_Arcade_Mame_Actions.Show_Media; }
end;

procedure Change_Categeroy(vDirection: String);
const
  cSnapCategory: array [0 .. 17] of string = ('Video Snaps', 'Snapshots', 'Cabinets', 'Control Panels', 'Flyers', 'Marquees', 'Pcbs', 'Artwork Preview', 'Bosses', 'How To', 'Logos', 'Scores',
    'Selects', 'Titles', 'Versus', 'Game Over', 'Ends', 'Warnings');
begin
  if vDirection = 'left' then
  begin
    if mame.Main.SnapCategory_Num > 0 then
    begin
      dec(mame.Main.SnapCategory_Num, 1);
      mame.Main.SnapCategory := cSnapCategory[mame.Main.SnapCategory_Num];
    end;
  end
  else
  begin
    if mame.Main.SnapCategory_Num < 17 then
    begin
      inc(mame.Main.SnapCategory_Num, 1);
      mame.Main.SnapCategory := cSnapCategory[mame.Main.SnapCategory_Num];
    end;
  end;
  uEmu_Arcade_Mame_Actions.Show_Media;
end;

procedure Open_Global_Configuration;
var
  vi: Integer;
begin
  if not ContainsText(extrafe.Prog.State, 'mame_config') then
  begin
    uEmu_Arcade_Mame_Config.Load;
    vMame.Scene.Left_Anim.StartValue := 0;
    vMame.Scene.Left_Anim.StopValue := -460;

    vMame.Scene.Right_Anim.StartValue := 960;
    vMame.Scene.Right_Anim.StopValue := 1460;

    vMame.Scene.Left_Anim.Start;
    vMame.Scene.Right_Anim.Start;
    vMame.Scene.Left_Blur.Enabled := True;
    vMame.Scene.Right_Blur.Enabled := True;

    if mame.Main.SnapCategory = 'Video Snaps' then
      if vMame.Scene.Media.Video.IsPlay then
        vMame.Scene.Media.Video.Pause;

    if extrafe.Prog.State = 'mame_game' then
    begin
      vMame.Config.Scene.Header_Icon.Bitmap.LoadFromFile(uDB_AUser.Local.EMULATORS.Arcade_D.Mame_D.p_Images + 'settings_green.png');
      vMame.Config.Scene.Header_Label.Text := 'Configuration for "' + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '" game rom.';
      extrafe.Prog.State := 'mame_game_config';
    end
    else
    begin
      vMame.Config.Scene.Header_Icon.Bitmap.LoadFromFile(uDB_AUser.Local.EMULATORS.Arcade_D.Mame_D.p_Images + 'settings_blue.png');
      vMame.Config.Scene.Header_Label.Text := 'Mame Global configuratin file';
      extrafe.Prog.State := 'mame_config';
    end;
  end
  else
  begin
    vMame.Scene.Left_Anim.StartValue := -460;
    vMame.Scene.Left_Anim.StopValue := 0;

    vMame.Scene.Right_Anim.StartValue := 1460;
    vMame.Scene.Right_Anim.StopValue := 960;

    vMame.Scene.Left_Anim.Enabled := True;
    vMame.Scene.Right_Anim.Enabled := True;

    uEmu_Arcade_Mame_Ini.Save;

    vMame.Scene.Left_Blur.Enabled := False;
    vMame.Scene.Right_Blur.Enabled := False;

    if mame.Main.SnapCategory = 'Video Snaps' then
      if vMame.Scene.Media.Video.IsPause then
        vMame.Scene.Media.Video.Resume;

    for vi := 0 to 12 do
      vMame.Config.Scene.Right_Panels[vi].Visible := False;

    if extrafe.Prog.State = 'mame_game' then
      extrafe.Prog.State := 'mame'
    else if extrafe.Prog.State = 'mame_game_config' then
      extrafe.Prog.State := 'mame_config';

    uEmu_Arcade_Mame_Config.Free;
  end;
end;

procedure Return;
begin
  if extrafe.Prog.State = 'mame_filters' then
    uEmu_Arcade_Mame_Filters.Free
  else if (extrafe.Prog.State = 'mame_config') or (extrafe.Prog.State = 'mame_game_config') then
    uEmu_Arcade_Mame_Actions.Open_Global_Configuration
  else if extrafe.Prog.State = 'mame_game' then
    uEmu_Arcade_Mame_Game_SetAll.Free
  else if extrafe.Prog.State = 'mame' then
    uEmu_Arcade_Mame.Exit;
end;

procedure Enter_Game_Menu;
begin
  vMame.Scene.Media.Up_Back_Image.Visible := False;
  vMame.Scene.Media.T_Players.Layout.Visible := False;
  uEmu_Arcade_Mame_SetAll.Show_Image_Scene(False);
  uEmu_Arcade_Mame_Game_SetAll.Load;
  uEmu_Arcade_Mame_Gamelist.Glow_Selected;
  Search(False);
end;

procedure Search(vAction: Boolean);
begin
  vMame.Scene.Gamelist.List_Blur.Enabled := vAction;
end;

procedure Is_Favorites_Open;
var
  vQuery: String;
begin
  vQuery := 'SELECT gamename, romname FROM games ORDER BY gamename ASC';
  uDB.Arcade_Query.Close;
  uDB.Arcade_Query.SQL.Clear;
  uDB.Arcade_Query.SQL.Text := vQuery;
  uDB.Arcade_Query.DisableControls;
  uDB.Arcade_Query.Open;
  uDB.Arcade_Query.First;

  mame.Gamelist.ListRoms.Clear;
  mame.Gamelist.ListGames.Clear;

  try
    uDB.Arcade_Query.First;
    while not uDB.Arcade_Query.Eof do
    begin
      mame.Gamelist.ListGames.Add(uDB.Arcade_Query.FieldByName('gamename').AsString);
      mame.Gamelist.ListRoms.Add(uDB.Arcade_Query.FieldByName('romname').AsString);
      uDB.Arcade_Query.Next;
    end;
  finally
    uDB.Arcade_Query.EnableControls;
  end;

  mame.Gamelist.Games_Count := uDB.Query_Count(Arcade_Query, 'games', '', '');

  vMame.Scene.Media.Up_Favorites.TextSettings.FontColor := TAlphaColorRec.Grey;
  vMame.Scene.Media.Up_Favorites_Glow.GlowColor := TAlphaColorRec.Deepskyblue;

  vMame.Scene.Gamelist.T_Lists.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vMame.Scene.Gamelist.Filters.Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vMame.Scene.Gamelist.Filters.Text.Text := 'All';
end;

procedure Is_Favorites_Closed;
var
  vQuery: String;
begin
  vQuery := 'SELECT gamename, romname FROM mame_status WHERE favorites="1" order by gamename asc';
  uDB.Arcade_Query.Close;
  uDB.Arcade_Query.SQL.Clear;
  uDB.Arcade_Query.SQL.Text := vQuery;
  uDB.Arcade_Query.DisableControls;
  uDB.Arcade_Query.Open;
  uDB.Arcade_Query.First;

  mame.Gamelist.ListRoms.Clear;
  mame.Gamelist.ListGames.Clear;

  try
    uDB.Arcade_Query.First;
    while not uDB.Arcade_Query.Eof do
    begin
      mame.Gamelist.ListGames.Add(uDB.Arcade_Query.FieldByName('gamename').AsString);
      mame.Gamelist.ListRoms.Add(uDB.Arcade_Query.FieldByName('romname').AsString);
      uDB.Arcade_Query.Next;
    end;
  finally
    uDB.Arcade_Query.EnableControls;
  end;

  mame.Gamelist.Games_Count := uDB.Query_Count(Arcade_Query, 'mame_status', 'favorites', '1');

  vMame.Scene.Media.Up_Favorites.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vMame.Scene.Media.Up_Favorites_Glow.GlowColor := TAlphaColorRec.Grey;

  vMame.Scene.Gamelist.T_Lists.TextSettings.FontColor := TAlphaColorRec.Grey;
  vMame.Scene.Gamelist.Filters.Icon.TextSettings.FontColor := TAlphaColorRec.Grey;
  vMame.Scene.Gamelist.Filters.Text.Text := '';
end;

procedure Open_Favorites;
var
  vQuery: String;
  vi: Integer;
begin
  if mame.Favorites.Count > 0 then
  begin
    if mame.Favorites.Open then
      Is_Favorites_Open
    else
      Is_Favorites_Closed;
    uEmu_Arcade_Mame.Main;
    mame.Favorites.Open := not mame.Favorites.Open;
  end;
end;

procedure Add_To_Favorites;
begin
  if mame.Favorites.Open then
  begin
    uDB.Query_Update(uDB.Arcade_Query, 'mame_status', 'fav_id_' + uDB_AUser.Local.Num.ToString, '0', 'romname', mame.Gamelist.ListRoms[mame.Gamelist.Selected]);
    dec(mame.Favorites.Count, 1);
    Is_Favorites_Closed;
    uEmu_Arcade_Mame.Main;
  end
  else
  begin
    if vMame.Scene.Media.T_Players.Favorite.Visible then
    begin
      uDB.Query_Update(uDB.Arcade_Query, 'mame_status', 'fav_id_' + uDB_AUser.Local.Num.ToString, '0', 'romname', mame.Gamelist.ListRoms[mame.Gamelist.Selected]);
      dec(mame.Favorites.Count, 1);
    end
    else
    begin
      uDB.Query_Update(uDB.Arcade_Query, 'mame_status', 'fav_id_' + uDB_AUser.Local.Num.ToString, '1', 'romname', mame.Gamelist.ListRoms[mame.Gamelist.Selected]);
      inc(mame.Favorites.Count, 1);
    end;
    vMame.Scene.Media.T_Players.Favorite.Visible := not vMame.Scene.Media.T_Players.Favorite.Visible;
  end;
end;

end.

{ function uEmu_Arcade_Mame_Actions_LoadGameList(vGameSoundPath: String): TstringList;
  var
  vZip: TZipFile;
  vLocalHeader: TZipHeader;
  vStream: TMemoryStream;
  vi: Integer;
  vString: String;
  begin
  if FileExists(vGameSoundPath) then
  begin
  Result:= TStringList.Create;
  vZip:= TZipFile.Create;
  vZip.Open(vGameSoundPath, zmRead);
  vStream:= TMemoryStream.Create;
  for vi:= 0 to vZip.FileCount- 1 do
  begin
  if ExtractFileExt(vZip.FileName[vi])= '.mp3' then
  Result.Add(vZip.FileName[vi]);
  //          vString:= Result.Strings[vi];
  //          vZip.Read(vString, vStream, vLocalHeader);
  end;
  end
  else
  Result:= nil;
  end; }
