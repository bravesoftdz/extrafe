unit uEmu_Arcade_Mame_Actions;

interface

uses
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  System.Zip,
  FMX.Objects,
  FMX.Types,
  FMX.Layouts,
  FMX.Graphics,
  FMX.Effects;

procedure Show_Media;

procedure Activate_Animation(vImagePath: String);
procedure Show_ImageNotFound;

var
  vMameVideoTimer: TTimer;

function uEmu_Arcade_Mame_Actions_LoadGameList(vGameSoundPath: String): TstringList;
procedure uEmu_Arcade_Mame_Actions_PlayGameMusic(vGameSoundPath: String);

procedure uEmu_Arcade_Mame_Actions_ChangeCategeroy(vDirection: String);
procedure uEmu_Arcade_Mame_Actions_ChangeSnapMode;
procedure Open_Filters;
procedure Open_Search;
procedure uEmu_Arcade_Mame_Actions_CloseTopicSearch;
procedure uEmu_Arcade_Mame_Actions_OpenGlobalConfiguration;

procedure Return;
procedure uEmu_Arcade_Mame_Actions_Enter;

procedure Search(vAction: Boolean);

var
  vMameGameMusicList: TstringList;

implementation

uses
  uDatabase_ActiveUser,
  uDatabase_SQLCommands,
  emu,
  uLoad_AllTypes,
  uEmu_Commands,
  uVirtual_Keyboard,
  uSnippet_Search,
  uEmu_Arcade_Mame,
  uEmu_Arcade_Mame_AllTypes,
  uEmu_Arcade_Mame_SetAll,
  uEmu_Arcade_Mame_Gamelist,
  uEmu_Arcade_Mame_Ini,
  uEmu_Arcade_Mame_Filters,
  uEmu_Arcade_Mame_Support_Files,
  uEmu_Arcade_Mame_Game_SetAll,
  uEmu_Arcade_Mame_Config;

procedure Activate_Animation(vImagePath: String);
begin
  vMame.Scene.Media.Image_Fade_Ani.Enabled := True;
  vMame.Scene.Media.Image_Fade.Target.LoadFromFile(vImagePath);
  if ((vMame.Scene.Media.Image_Fade.Target.Width > vMame.Scene.Media.Image_Fade.Target.Height) and (mame.Main.Snap_Old_Width <> 650)) or
    ((vMame.Scene.Media.Image_Fade.Target.Width < vMame.Scene.Media.Image_Fade.Target.Height) and (mame.Main.Snap_Old_Width <> 485)) then
  begin
    vMame.Scene.Media.Image_Width_Ani.StartValue := 0;
    vMame.Scene.Media.Image_Height_Ani.StartValue := 0;
    vMame.Scene.Media.Image_Y_Ani.StartValue := 55;
    vMame.Scene.Media.Image_X_Ani.StartValue := 275;
    if vMame.Scene.Media.Image_Fade.Target.Width > vMame.Scene.Media.Image_Fade.Target.Height then
    begin
      vMame.Scene.Media.Image_Width_Ani.StopValue := 650;
      vMame.Scene.Media.Image_Height_Ani.StopValue := 485;
      vMame.Scene.Media.Image_Y_Ani.StopValue := 55;
      vMame.Scene.Media.Image_X_Ani.StopValue := 50;
    end
    else
    begin
      vMame.Scene.Media.Image_Width_Ani.StopValue := 485;
      vMame.Scene.Media.Image_Height_Ani.StopValue := 650;
      vMame.Scene.Media.Image_Y_Ani.StopValue := 55;
      vMame.Scene.Media.Image_X_Ani.StopValue := 132;
    end;

    vMame.Scene.Media.Image_Width_Ani.Enabled := True;
    vMame.Scene.Media.Image_Height_Ani.Enabled := True;
    vMame.Scene.Media.Image_Y_Ani.Enabled := True;
    vMame.Scene.Media.Image_X_Ani.Enabled := True;
  end;

  mame.Main.Snap_Old_Width := vMame.Scene.Media.Image_Width_Ani.StopValue;
end;

procedure Show_ImageNotFound;
begin
  if not FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Snapshots + 'image_not_found.png') then
    vMame.Scene.Media.Image.Bitmap := nil
  else
    vMame.Scene.Media.Image.Bitmap.LoadFromFile(user_Active_Local.EMULATORS.Arcade_D.Media.Snapshots + 'image_not_found.png');
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
    if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Videos + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.mp4') then
    begin
      vMameVideoTimer := TTimer.Create(vMame.Scene.Main);
      vMameVideoTimer.Enabled := True;
      vMameVideoTimer.OnTimer := mame.Timers.Video.OnTimer;
      vMame.Scene.Media.Video.Visible := True;
      if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Snapshots + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
      begin
        vMame.Scene.Media.Video.PlayNormal(user_Active_Local.EMULATORS.Arcade_D.Media.Snapshots + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png');
      end
    end
    else
    begin
      if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Snapshots + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
      begin
        vMame.Scene.Media.Video.PlayNormal(user_Active_Local.EMULATORS.Arcade_D.Media.Snapshots + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png');
      end
      else
      begin
        vMame.Scene.Media.Video.PlayNormal(user_Active_Local.EMULATORS.Arcade_D.Media.Snapshots + 'imagenotfound.png');
      end;
    end;
  end
  else
  begin
    vImageExists := False;
    vMame.Scene.Media.Image_Reflaction.Enabled := False;
    case IndexStr(mame.Main.SnapCategory, ['Snapshots', 'Cabinets', 'Control Panels', 'Flyers', 'Marquees', 'Pcbs', 'Artwork Preview', 'Bosses', 'How To',
      'Logos', 'Scores', 'Selects', 'Titles', 'Versus', 'Game Over', 'Ends', 'Warnings']) of
      0:
        if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Snapshots + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(user_Active_Local.EMULATORS.Arcade_D.Media.Snapshots + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      1:
        if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Cabinets + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(user_Active_Local.EMULATORS.Arcade_D.Media.Cabinets + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      2:
        if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Control_Panels + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(user_Active_Local.EMULATORS.Arcade_D.Media.Control_Panels + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      3:
        if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Flyers + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(user_Active_Local.EMULATORS.Arcade_D.Media.Flyers + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      4:
        if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Marquees + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(user_Active_Local.EMULATORS.Arcade_D.Media.Marquees + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      5:
        if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Pcbs + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(user_Active_Local.EMULATORS.Arcade_D.Media.Pcbs + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      6:
        if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Artwork_Preview + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(user_Active_Local.EMULATORS.Arcade_D.Media.Artwork_Preview + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      7:
        if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Bosses + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(user_Active_Local.EMULATORS.Arcade_D.Media.Bosses + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      8:
        if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.How_To + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(user_Active_Local.EMULATORS.Arcade_D.Media.How_To + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      9:
        if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Logos + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(user_Active_Local.EMULATORS.Arcade_D.Media.Logos + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      10:
        if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Scores + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(user_Active_Local.EMULATORS.Arcade_D.Media.Scores + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      11:
        if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Selects + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(user_Active_Local.EMULATORS.Arcade_D.Media.Selects + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      12:
        if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Titles + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(user_Active_Local.EMULATORS.Arcade_D.Media.Titles + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      13:
        if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Versus + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(user_Active_Local.EMULATORS.Arcade_D.Media.Versus + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      14:
        if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Game_Over + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(user_Active_Local.EMULATORS.Arcade_D.Media.Game_Over + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      15:
        if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Ends + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(user_Active_Local.EMULATORS.Arcade_D.Media.Ends + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
        else
          Show_ImageNotFound;
      16:
        if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Warnings + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
          Activate_Animation(user_Active_Local.EMULATORS.Arcade_D.Media.Warnings + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png')
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

  if mame.Support.List_Active[0] then
    vMame.Scene.Gamelist.T_GamePlayers.Text := uEmu_Arcade_Mame_Support_Files_NPlayers_GetGame(mame.Gamelist.ListGames[mame.Gamelist.Selected]);
  if mame.Support.List_Active[1] then
    vMame.Scene.Gamelist.T_GameCategory.Text := uEmu_Arcade_Mame_Support_Files_Catver_GetGame(mame.Gamelist.ListGames[mame.Gamelist.Selected]);
end;

procedure uEmu_Arcade_Mame_Actions_PlayGameMusic(vGameSoundPath: String);
begin
  if FileExists(vGameSoundPath) then
    vMameGameMusicList := uEmu_Arcade_Mame_Actions_LoadGameList(vGameSoundPath);
end;

function uEmu_Arcade_Mame_Actions_LoadGameList(vGameSoundPath: String): TstringList;
var
  vZip: TZipFile;
  vLocalHeader: TZipHeader;
  vStream: TMemoryStream;
  vi: Integer;
  vString: String;
begin
  { if FileExists(vGameSoundPath) then
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
    Result:= nil; }
end;

/// /////////////////////////////////////////////////////////////////////////////
procedure Open_Filters;
begin
  uEmu_Arcade_Mame_Filters.Load;
end;

procedure Open_Search;
begin
  if user_Active_Local.OPTIONS.Visual.Virtual_Keyboard then
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

procedure uEmu_Arcade_Mame_Actions_CloseTopicSearch;
begin
  uSnippet_Search.vSearch.Scene.Edit.Text := '';
  vMame.Scene.Gamelist.Search_Edit.Width := 0;
  vMame.Scene.Gamelist.Listbox.SetFocus;
end;

procedure uEmu_Arcade_Mame_Actions_ChangeSnapMode;
begin
  if mame.Main.SnapMode = 'arcade' then
    mame.Main.SnapMode := 'frame'
  else
    mame.Main.SnapMode := 'arcade';
  uEmu_Arcade_Mame_Actions.Show_Media;
end;

procedure uEmu_Arcade_Mame_Actions_ChangeCategeroy(vDirection: String);
const
  cSnapCategory: array [0 .. 17] of string = ('Video Snaps', 'Snapshots', 'Cabinets', 'Control Panels', 'Flyers', 'Marquees', 'Pcbs', 'Artwork Preview',
    'Bosses', 'How To', 'Logos', 'Scores', 'Selects', 'Titles', 'Versus', 'Game Over', 'Ends', 'Warnings');
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

procedure uEmu_Arcade_Mame_Actions_OpenGlobalConfiguration;
var
  vi: Integer;
begin
  if not ContainsText(extrafe.Prog.State, 'mame_config') then
  begin
    uEmu_Arcade_Mame_Config_Load;
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
      vMame.Config.Scene.Header_Icon.Bitmap.LoadFromFile(user_Active_Local.EMULATORS.Arcade_D.Mame_D.p_Images + 'settings_green.png');
      vMame.Config.Scene.Header_Label.Text := 'Configuration for "' + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '" game rom.'
    end
    else
    begin
      vMame.Config.Scene.Header_Icon.Bitmap.LoadFromFile(user_Active_Local.EMULATORS.Arcade_D.Mame_D.p_Images + 'settings_blue.png');
      vMame.Config.Scene.Header_Label.Text := 'Mame Global configuratin file';
    end;

    extrafe.Prog.State := 'mame_config';
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

    if vMame.Scene.Settings.Tag = 1 then
      extrafe.Prog.State := 'mame'
    else if vMame.Scene.Settings.Tag = 2 then
      extrafe.Prog.State := 'mame_game';

    uEmu_Arcade_Mame_Config_Free;
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////
procedure Return;
begin
  if extrafe.Prog.State = 'mame_filters' then
    uEmu_Arcade_Mame_Filters.Free
  else if extrafe.Prog.State = 'mame_config' then
    uEmu_Arcade_Mame_Actions_OpenGlobalConfiguration
  else if extrafe.Prog.State = 'mame_game' then
    uEmu_Arcade_Mame_Game_Exit
  else if extrafe.Prog.State = 'mame' then
    uEmu_Arcade_Mame.Exit;
end;

procedure uEmu_Arcade_Mame_Actions_Enter;
begin
  uEmu_Arcade_Mame_SetAll.Free_Image_Scene;
  uEmu_Arcade_Mame_Game_SetAll_Set;
  extrafe.Prog.State := 'mame_game';
  vMame.Scene.Settings.Tag := 2;
  uEmu_Arcade_Mame_Gamelist_GlowSelected;
  Search(False);
end;

procedure Search(vAction: Boolean);
begin
  vMame.Scene.Gamelist.List_Blur.Enabled := vAction;
end;

end.
