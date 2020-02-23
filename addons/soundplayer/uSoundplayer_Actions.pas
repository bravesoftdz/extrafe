unit uSoundplayer_Actions;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UiTypes;

procedure Load;
procedure Free;

procedure Set_FirstTime;
procedure Set_WithActivePlaylist(vPlaylist: Integer);
procedure Set_WithActiveSong;

procedure Hide_Animations;
procedure Set_Animations;

procedure CheckFirst(vCheched: Boolean);

procedure Get_Data;

implementation

uses
  uDB,
  uDB_AUser,
  uLoad_AllTypes,
  uSoundplayer_SetAll,
  uSoundplayer_AllTypes,
  uSoundplayer_Sounds,
  uSoundplayer_Player,
  uSoundplayer_Playlist,
  uSoundplayer_Player_Volume,
  uSoundplayer_Tag_Get,
  uSoundplayer_Tag_Mp3;

procedure Load;
begin
  extrafe.prog.State := 'addon_soundplayer_loading';

  uSoundplayer_Sounds.Load;

  if soundplayer.player = sPlay then
    Set_WithActiveSong
  else
  begin
    if (uDB_AUser.Local.addons.Soundplayer_D.Playlist_Count <> -1) then
      Set_WithActivePlaylist(addons.Soundplayer.Playlist.Active)
    else
    begin
      Set_FirstTime;
      if uDB_AUser.Local.addons.Soundplayer_D.Playlist_Count = -1 then
        if uDB_AUser.Local.addons.Soundplayer_D.First_Pop then
          uSoundplayer_SetAll.Set_First;
    end;
  end;


  Set_Animations;
  extrafe.prog.State := 'addon_soundplayer';
  uSoundplayer_Player_Volume.Update(uDB_AUser.Local.addons.Soundplayer_D.Volume);
end;

procedure Free;
begin
  if Assigned(vSoundplayer.scene.Soundplayer) then
  begin
    if soundplayer.player = sPlay then
      uSoundplayer_Player_Volume.Adjust(True);
    uSoundplayer_Sounds.Free;
    FreeAndNil(vSoundplayer.scene.Soundplayer);
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////
procedure Set_FirstTime;
var
  vi, ki: Integer;
begin
  uSoundplayer_Playlist.State('First', -1);
  uSoundplayer_Player.State(False, False, False, False, False, '');
end;

procedure Set_WithActivePlaylist(vPlaylist: Integer);
begin
  soundplayer.player_actions.volume.Vol := soundplayer.player_actions.volume.Master * 100;
  soundplayer.player_actions.Song_State := 0;

  uSoundplayer_Playlist.State('Playlist', vPlaylist);
//  uSoundplayer_Player.State(soundplayer.player = sPlay, addons.Soundplayer.Player.Pause, addons.Soundplayer.Player.Stop, addons.Soundplayer.Player.Mute,
//    soundplayer.player_actions.Suffle, '');
end;

procedure Set_WithActiveSong;
var
  vi: Integer;
begin
  uSoundplayer_Playlist.State('Song', -1);
  vSoundplayer.info.Playlist_Name.Text := addons.Soundplayer.Playlist.List.Name;
  vSoundplayer.info.Playlist_Type_Kind.Text := addons.Soundplayer.Playlist.List.VType;
  vSoundplayer.info.Total_Songs.Text := (soundplayer.player_actions.Playing_Now + 1).ToString + '/' + addons.Soundplayer.Playlist.List.Songs_Num.ToString;
  vSoundplayer.info.Time_Total.Text := addons.Soundplayer.Playlist.List.Songs_Total_Time;
  vSoundplayer.timer.Song.Enabled := True;
  soundplayer.player_actions.Thumb_Active := False;
  if soundplayer.player_actions.Suffle then
  begin
    uSoundplayer_Player.Repeat_Back(soundplayer.player_actions.VRepeat);
    uSoundplayer_Player.Suffle_Back;
//    uSoundplayer_Player.Set_Play(addons.Soundplayer.Player.Play, addons.Soundplayer.Player.Pause, addons.Soundplayer.Player.Stop,
//      addons.Soundplayer.Player.Mute);
    uSoundplayer_Player.Set_Previous_Next;
  end;
//  else
//    uSoundplayer_Player.State(addons.Soundplayer.Player.Play, addons.Soundplayer.Player.Pause, addons.Soundplayer.Player.Stop, addons.Soundplayer.Player.Mute,
//      soundplayer.player_actions.Suffle, soundplayer.player_actions.VRepeat);
  uSoundplayer_Player_Volume.Adjust(False);
end;

procedure Set_Animations;
begin
  vSoundplayer.info.Back_Left.Position.X := 2;
  vSoundplayer.info.Back_Left_Ani.StartValue := 2;
  vSoundplayer.info.Back_Left_Ani.StopValue := -558;

  vSoundplayer.info.Back_Right.Position.X := 1318;
  vSoundplayer.info.Back_Right_Ani.StartValue := 1318;
  vSoundplayer.info.Back_Right_Ani.StopValue := 1878;

  vSoundplayer.info.Back_Left_Ani.Start;
  vSoundplayer.info.Back_Right_Ani.Start;

  addons.Soundplayer.info.isCoverInFullscreen := False;
end;

procedure Hide_Animations;
begin
  vSoundplayer.info.Back_Left_Ani.Stop;
  vSoundplayer.info.Back_Right_Ani.Stop;

  vSoundplayer.info.Back_Left.Position.X := -558;
  vSoundplayer.info.Back_Right.Position.X := 1878;

  addons.Soundplayer.info.isCoverInFullscreen := False;
end;

procedure CheckFirst(vCheched: Boolean);
begin
  addons.Soundplayer.Actions.First := vCheched;
  addons.Soundplayer.Ini.Ini.WriteBool('General', 'First', vCheched);
end;

procedure Get_Data;
var
  vQuery: String;
begin
  vQuery := 'SELECT * FROM ADDON_SOUNDPLAYER WHERE USER_ID=' + uDB_AUser.Local.USER.Num.ToString;
  uDB.ExtraFE_Query_Local.Close;
  uDB.ExtraFE_Query_Local.SQL.Clear;
  uDB.ExtraFE_Query_Local.SQL.Add(vQuery);
  uDB.ExtraFE_Query_Local.Open;
  uDB.ExtraFE_Query_Local.First;

  uDB_AUser.Local.addons.Soundplayer_D.Menu_Position := uDB.ExtraFE_Query_Local.FieldByName('MENU_POSITION').AsInteger;
  uDB_AUser.Local.addons.Soundplayer_D.First_Pop := uDB.ExtraFE_Query_Local.FieldByName('FIRST_POP').AsBoolean;
  uDB_AUser.Local.addons.Soundplayer_D.Volume := uDB.ExtraFE_Query_Local.FieldByName('VOLUME').AsInteger;
  uDB_AUser.Local.addons.Soundplayer_D.Last_Visit := uDB.ExtraFE_Query_Local.FieldByName('LAST_VISIT').AsString;
  uDB_AUser.Local.addons.Soundplayer_D.Last_Play_Song_Num := uDB.ExtraFE_Query_Local.FieldByName('LAST_PLAY_SONG_NUM').AsInteger;
  uDB_AUser.Local.addons.Soundplayer_D.Last_Playlist_Num := uDB.ExtraFE_Query_Local.FieldByName('LAST_PLAYLIST_NUM').AsInteger;
  uDB_AUser.Local.addons.Soundplayer_D.Playlist_Count := uDB.ExtraFE_Query_Local.FieldByName('PLAYLIST_COUNT').AsInteger;
  uDB_AUser.Local.addons.Soundplayer_D.Total_Play_Click := uDB.ExtraFE_Query_Local.FieldByName('TOTAL_PLAY_CLICK').AsInteger;
  uDB_AUser.Local.addons.Soundplayer_D.Total_Play_Time := uDB.ExtraFE_Query_Local.FieldByName('TOTAL_PLAY_TIME').AsString;
  uDB_AUser.Local.addons.Soundplayer_D.p_Images := uDB.ExtraFE_Query_Local.FieldByName('PATH_IMAGES').AsString;
  uDB_AUser.Local.addons.Soundplayer_D.p_Playlists := uDB.ExtraFE_Query_Local.FieldByName('PATH_PLAYLISTS').AsString;
  uDB_AUser.Local.addons.Soundplayer_D.p_Sounds := uDB.ExtraFE_Query_Local.FieldByName('PATH_SOUNDS').AsString;

  if uDB_AUser.Local.addons.Soundplayer_D.Menu_Position <> -1 then
  begin
    uDB_AUser.Local.addons.Names.Insert(uDB_AUser.Local.addons.Soundplayer_D.Menu_Position, 'soundplayer');
    uDB_AUser.Local.ADDONS.Names.Delete(uDB_AUser.Local.ADDONS.Soundplayer_D.Menu_Position + 1);
  end;

  soundplayer.player := sStop;
end;

end.
