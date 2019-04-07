unit uSoundplayer;

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

implementation

uses
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

  if addons.Soundplayer.Player.Play = False then
  begin
    if (addons.Soundplayer.Playlist.Total <> -1) and (addons.Soundplayer.Playlist.Active <> -1) then
      Set_WithActivePlaylist(addons.Soundplayer.Playlist.Active)
    else
    begin
      Set_FirstTime;
      if addons.Soundplayer.Playlist.Total = -1 then
        if addons.Soundplayer.Actions.First = False then
          uSoundplayer_SetAll.Set_First;
    end;
  end
  else
    Set_WithActiveSong;

  Set_Animations;
  extrafe.prog.State := 'addon_soundplayer';
  uSoundplayer_Player_Volume.Update(addons.Soundplayer.Volume.Vol);
end;

procedure Free;
begin
  if Assigned(vSoundplayer.scene.Soundplayer) then
  begin
    if addons.soundplayer.Player.Play then
      uSoundplayer_Player_Volume.Adjust(True);
    uSoundplayer_Sounds.Free;
    FreeAndNil(vSoundplayer.scene.ImgList);
    FreeAndNil(vSoundplayer.scene.Soundplayer);
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////
procedure Set_FirstTime;
var
  vi, ki: Integer;
begin
  addons.Soundplayer.Volume.Master := addons.Soundplayer.Ini.Ini.ReadFloat('Volume', 'Master', addons.Soundplayer.Volume.Master);
  addons.Soundplayer.Volume.Vol := addons.Soundplayer.Volume.Master * 100;
  addons.Soundplayer.Player.Song_State := 0;

  vSoundplayer.Player.Song_Pos.Value := 0;
  vSoundplayer.info.Cover.Bitmap := nil;

  uSoundplayer_Playlist.State('First', -1);
  uSoundplayer_Player.State(False, False, False, False, False, '');
end;

procedure Set_WithActivePlaylist(vPlaylist: Integer);
begin
  addons.Soundplayer.Volume.Vol := addons.Soundplayer.Volume.Master * 100;
  addons.Soundplayer.Player.Song_State := 0;

  uSoundplayer_Playlist.State('Playlist', vPlaylist);
  uSoundplayer_Player.State(addons.Soundplayer.Player.Play, addons.Soundplayer.Player.Pause, addons.Soundplayer.Player.Stop, addons.Soundplayer.Player.Mute,
    addons.Soundplayer.Player.Suffle, '');
end;

procedure Set_WithActiveSong;
var
  vi: Integer;
begin
  uSoundplayer_Playlist.State('Song', -1);
  vSoundplayer.info.Playlist_Name.Text := addons.Soundplayer.Playlist.List.Name;
  vSoundplayer.info.Playlist_Type_Kind.Text := addons.Soundplayer.Playlist.List.VType;
  vSoundplayer.info.Total_Songs.Text := (addons.Soundplayer.Player.Playing_Now + 1).ToString + '/' + addons.Soundplayer.Playlist.List.Songs_Num.ToString;
  vSoundplayer.info.Time_Total.Text := addons.Soundplayer.Playlist.List.Songs_Total_Time;
  vSoundplayer.timer.Song.Enabled := True;
  addons.Soundplayer.Player.Thumb_Active := False;
  if addons.soundplayer.Player.Suffle then
  begin
    uSoundplayer_Player.Repeat_Back(addons.soundplayer.Player.VRepeat);
    uSoundplayer_Player.Suffle_Back;
    uSoundplayer_Player.Set_Play(addons.soundplayer.Player.Play, addons.soundplayer.Player.Pause, addons.soundplayer.Player.Stop, addons.soundplayer.Player.Mute);
    uSoundplayer_Player.Set_Previous_Next;
  end
  else
  uSoundplayer_Player.State(addons.Soundplayer.Player.Play, addons.Soundplayer.Player.Pause, addons.Soundplayer.Player.Stop, addons.Soundplayer.Player.Mute,
    addons.Soundplayer.Player.Suffle, addons.Soundplayer.Player.VRepeat);
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

end.
