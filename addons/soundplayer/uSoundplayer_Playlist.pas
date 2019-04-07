unit uSoundplayer_Playlist;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UiTypes,
  FMX.Controls,
  FMX.Graphics,
  FMX.Objects,
  FMX.Grid,
  FMX.Effects,
  FMX.StdCtrls,
  FMX.Edit,
  FMX.Listbox,
  FMX.Types,
  FMX.Filter.Effects,
  FMX.Dialogs,
  FMX.Menus,
  BASS;

procedure State(vPlaylist_State: String; vPlaylist_Num: Integer);

procedure SortPlaylistIni;

procedure EditPlaylist(vActive: Boolean);

procedure LoadPlaylists;

// Create playlist based types
procedure NewPlaylist_m3u(mPlaylistName: string; mNum: SmallInt);
procedure NewPlaylist_pls(mPlaylistName: string; mNum: SmallInt);
procedure NewPlaylist_asx(mPlaylistName: string; mNum: SmallInt);
procedure NewPlaylist_xspf(mPlaylistName: string; mNum: SmallInt);
procedure NewPlaylist_wpl(mPlaylistName: string; mNum: SmallInt);
procedure NewPlaylist_expl(mPlaylistName: string; mNum: SmallInt);

// Add songs in playlist from load
procedure uSoundplayer_Playlist_Actions_AddSongs_Load(mPlaylistType: string; mPL_Num: SmallInt);
procedure AddSongs_m3u(mPL_Num: SmallInt);
procedure AddSongs_pls(mPL_Num: SmallInt);
procedure AddSongs_asx(mPL_Num: SmallInt);
procedure AddSongs_xspf(mPL_Num: SmallInt);
procedure AddSongs_wpl(mPL_Num: SmallInt);
procedure AddSongs_expl(mPL_Num: SmallInt);

// Edit Playlist
procedure uSoundplyaer_Playlist_Actions_Row_In_M3u(vType, vSong: String);
procedure uSoundplyaer_Playlist_Actions_Row_In_Pls(vType: String);
procedure uSoundplyaer_Playlist_Actions_Row_In_Asx(vType: String);
procedure uSoundplyaer_Playlist_Actions_Row_In_Xspf(vType: String);
procedure uSoundplyaer_Playlist_Actions_Row_In_Wpl(vType: String);
procedure uSoundplyaer_Playlist_Actions_Row_In_expl(vType: String);

// Stringgrid
procedure OnSelectCell(Sender: TObject; const ACol, ARow: Integer; var CanSelect: Boolean);
procedure OnDoubleClick(const Column: TColumn; const Row: Integer);
procedure OnList_ShowPopup(Button: TMouseButton; X, Y: Single);
procedure OnRowActions(vType: String; vSelected: Integer);

// Songs edit
procedure Edit_MoveUp;
procedure Edit_MoveDown;
procedure Edit_SongInfo(vType: String; vSelected: Integer);
procedure Edit_Delete;
procedure Edit_Delete_Song;
procedure Edit_Delete_Cancel;

implementation

uses
  main,
  uLoad,
  uLoad_AllTypes,
  uWindows,
  uSoundplayer,
  uSoundplayer_Mouse,
  uSoundplayer_SetAll,
  uSoundplayer_AllTypes,
  uSoundplayer_Player,
  uSoundplayer_Playlist_Create,
  uSoundplayer_Tag_Get,
  uSoundplayer_Tag_Mp3;

procedure State(vPlaylist_State: String; vPlaylist_Num: Integer);
var
  vi, ki: Integer;
begin
  if vPlaylist_State = 'First' then
  begin
    for vi := 0 to vSoundplayer.Playlist.List.ColumnCount - 1 do
      for ki := 0 to vSoundplayer.Playlist.List.RowCount - 1 do
        vSoundplayer.Playlist.List.Cells[vi, ki] := '';
  end
  else if vPlaylist_State = 'Playlist' then
  begin
    addons.Soundplayer.Playlist.List.Num := vPlaylist_Num;

    addons.Soundplayer.Playlist.List.Playlist := TStringList.Create;
    addons.Soundplayer.Playlist.List.Songs := TStringList.Create;

    addons.Soundplayer.Playlist.List.Name := addons.Soundplayer.Ini.Ini.ReadString('Playlists', 'ActivePlaylistName', addons.Soundplayer.Playlist.List.Name);
    addons.Soundplayer.Playlist.List.vType := addons.Soundplayer.Ini.Ini.ReadString('Playlists', 'PL_' + IntToStr(addons.Soundplayer.Playlist.Active) + '_Type',
      addons.Soundplayer.Playlist.List.vType);
    addons.Soundplayer.Playlist.List.Songs_Num := addons.Soundplayer.Ini.Ini.ReadInteger('Playlists', 'PL_' + IntToStr(vPlaylist_Num) + '_Songs',
      addons.Soundplayer.Playlist.List.Songs_Num);

    addons.Soundplayer.Playlist.List.Playlist.LoadFromFile(addons.Soundplayer.Path.Playlists + addons.Soundplayer.Playlist.List.Name +
      addons.Soundplayer.Playlist.List.vType);

    uSoundplayer_Tag_Mp3.APICIndex := 0;
    if addons.Soundplayer.Playlist.List.Songs_Num > 0 then
    begin
      uSoundplayer_Playlist_Actions_AddSongs_Load(addons.Soundplayer.Playlist.List.vType, vPlaylist_Num);
      uSoundplayer_Player.Get_Tag(addons.Soundplayer.Player.Playing_Now);
      uSoundplayer_Tag_Get.Set_Icon;
    end
    else
      vSoundplayer.Player.Song_Tag.Visible := False;
  end
  else if vPlaylist_State = 'Song' then
  begin
    vSoundplayer.Playlist.List.RowCount := addons.Soundplayer.Playlist.List.Songs_Num;
    for vi := 0 to addons.Soundplayer.Playlist.List.Songs_Num - 1 do
    begin
      vSoundplayer.Playlist.List.Cells[0, vi] := IntToStr(vi + 1);
      vSoundplayer.Playlist.List.Cells[1, vi] := '3';
      vSoundplayer.Playlist.List.Cells[2, vi] := addons.Soundplayer.Playlist.List.Song_Info[vi].Title;
      vSoundplayer.Playlist.List.Cells[3, vi] := addons.Soundplayer.Playlist.List.Song_Info[vi].Artist;
      vSoundplayer.Playlist.List.Cells[4, vi] := addons.Soundplayer.Playlist.List.Song_Info[vi].Track_Seconds;
      if addons.Soundplayer.Playlist.List.Song_Info[vi].Disk_Type = '.mp3' then
        vSoundplayer.Playlist.List.Cells[5, vi] := '8'
      else if addons.Soundplayer.Playlist.List.Song_Info[vi].Disk_Type = '.ogg' then
        vSoundplayer.Playlist.List.Cells[5, vi] := '9'
      else
        vSoundplayer.Playlist.List.Cells[5, vi] := '10';
    end;
    if addons.Soundplayer.Player.Play then
      vSoundplayer.Playlist.List.Cells[1, addons.Soundplayer.Player.Playing_Now] := '0'
    else if addons.Soundplayer.Player.Stop then
      vSoundplayer.Playlist.List.Cells[1, addons.Soundplayer.Player.Playing_Now] := '1'
    else if addons.Soundplayer.Player.Pause then
      vSoundplayer.Playlist.List.Cells[1, addons.Soundplayer.Player.Playing_Now] := '2';
    vSoundplayer.Playlist.List.Selected := addons.Soundplayer.Player.Playing_Now;
    uSoundplayer_Tag_Mp3.APICIndex := 0;
    uSoundplayer_Player.Get_Tag(addons.Soundplayer.Player.Playing_Now);
    uSoundplayer_Tag_Get.Set_Icon;
  end;
  addons.Soundplayer.Playlist.Manage_Lock := False;
  addons.Soundplayer.Playlist.Edit := False;
  addons.Soundplayer.Player.Thumb_Active := False;
  vSoundplayer.Playlist.Manage_Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  if addons.Soundplayer.Playlist.Total > 0 then
    vSoundplayer.Playlist.Remove_Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue
  else
    vSoundplayer.Playlist.Remove_Icon.TextSettings.FontColor := TAlphaColorRec.Grey;
  vSoundplayer.Playlist.Create_Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  LoadPlaylists;
end;
/// /

procedure NewPlaylist_m3u(mPlaylistName: string; mNum: SmallInt);
begin
  addons.Soundplayer.Playlist.List.Playlist := TStringList.Create;
  addons.Soundplayer.Playlist.List.Playlist.Add('#EXTM3U');
  addons.Soundplayer.Playlist.List.Playlist.SaveToFile(addons.Soundplayer.Path.Playlists + mPlaylistName + '.m3u');
  addons.Soundplayer.Playlist.List.Name := mPlaylistName;
  addons.Soundplayer.Playlist.List.vType := '.m3u';
  addons.Soundplayer.Playlist.List.Num := mNum;
  addons.Soundplayer.Playlist.List.Played := 0;
  addons.Soundplayer.Playlist.List.Last_Played := DateTimeToStr(Now);
  addons.Soundplayer.Playlist.List.Songs_Num := 0;
  addons.Soundplayer.Playlist.List.Songs := TStringList.Create;

  addons.Soundplayer.Playlist.Total := mNum;
  addons.Soundplayer.Playlist.Active := mNum;
  addons.Soundplayer.Playlist.List.Name := mPlaylistName;

  addons.Soundplayer.Ini.Ini.WriteInteger('Playlists', 'TotalPlaylists', addons.Soundplayer.Playlist.Total);
  addons.Soundplayer.Ini.Ini.WriteInteger('Playlists', 'ActivePlaylist', addons.Soundplayer.Playlist.Active);
  addons.Soundplayer.Ini.Ini.WriteString('Playlists', 'ActivePlaylistName', addons.Soundplayer.Playlist.List.Name);
  addons.Soundplayer.Ini.Ini.WriteString('Playlists', 'PL_' + IntToStr(mNum) + '_Name', addons.Soundplayer.Playlist.List.Name);
  addons.Soundplayer.Ini.Ini.WriteString('Playlists', 'PL_' + IntToStr(mNum) + '_Path', addons.Soundplayer.Path.Playlists);
  addons.Soundplayer.Ini.Ini.WriteString('Playlists', 'PL_' + IntToStr(mNum) + '_Type', '.m3u');
  addons.Soundplayer.Ini.Ini.WriteInteger('Playlists', 'PL_' + IntToStr(mNum) + '_Songs', 0);
  addons.Soundplayer.Ini.Ini.WriteInteger('Playlists', 'Pl_' + IntToStr(mNum) + '_Played', 0);
  addons.Soundplayer.Ini.Ini.WriteString('Playlists', 'PL_' + IntToStr(mNum) + '_LastPlayed', DateTimeToStr(Now));

  vSoundplayer.info.Playlist_name.Text := mPlaylistName;
end;

procedure NewPlaylist_pls(mPlaylistName: string; mNum: SmallInt);
begin

end;

procedure NewPlaylist_asx(mPlaylistName: string; mNum: SmallInt);
begin

end;

procedure NewPlaylist_xspf(mPlaylistName: string; mNum: SmallInt);
begin

end;

procedure NewPlaylist_wpl(mPlaylistName: string; mNum: SmallInt);
begin

end;

procedure NewPlaylist_expl(mPlaylistName: string; mNum: SmallInt);
begin

end;

/// /////////////////////////////////////////////////////////////////////////////
// Add songs in playlist from load

procedure AddSongs_m3u(mPL_Num: SmallInt);
var
  vi, iPos, vk: Integer;
  vString: string;
  vsTF: Real;
  vfsTF: Real;
  vSong_Time: String;
begin
  vk := 0;
  vSoundplayer.Playlist.List.RowCount := addons.Soundplayer.Playlist.List.Songs_Num;
  vfsTF := 0;
  for vi := 0 to addons.Soundplayer.Playlist.List.Playlist.Count - 1 do
  begin
    vString := addons.Soundplayer.Playlist.List.Playlist.Strings[vi];
    iPos := Pos('#EXTINF', vString);
    if iPos <> 0 then
    begin
      vString := addons.Soundplayer.Playlist.List.Playlist.Strings[vi + 1];
      addons.Soundplayer.Playlist.List.Songs.Add(vString);
      sound.str_music[100] := BASS_StreamCreateFile(False, PChar(vString), 0, 0, BASS_SAMPLE_FLOAT
{$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
      vsTF := trunc(BASS_ChannelBytes2Seconds(sound.str_music[100], BASS_ChannelGetLength(sound.str_music[100], BASS_POS_BYTE)));
      vfsTF := vfsTF + vsTF;
      addons.Soundplayer.Playlist.List.Songs_Total_Time := FormatDateTime('hh:mm:ss', uWindows_ConvertSecondsFromTime(vfsTF));
      vSong_Time := FormatDateTime('hh:mm:ss', uWindows_ConvertSecondsFromTime(vsTF));
      uSoundPlayer_GetTag_Details(vString, mPL_Num, vk, vSong_Time);
      vSoundplayer.Playlist.List.Cells[0, vk] := IntToStr(vk + 1);
      vSoundplayer.Playlist.List.Cells[1, vk] := '3';
      vSoundplayer.Playlist.List.Cells[2, vk] := addons.Soundplayer.Playlist.List.Song_Info[vk].Title;
      vSoundplayer.Playlist.List.Cells[3, vk] := addons.Soundplayer.Playlist.List.Song_Info[vk].Artist;
      vSoundplayer.Playlist.List.Cells[4, vk] := addons.Soundplayer.Playlist.List.Song_Info[vk].Track_Seconds;
      if addons.Soundplayer.Playlist.List.Song_Info[vk].Disk_Type = '.mp3' then
        vSoundplayer.Playlist.List.Cells[5, vk] := '8'
      else if addons.Soundplayer.Playlist.List.Song_Info[vk].Disk_Type = '.ogg' then
        vSoundplayer.Playlist.List.Cells[5, vk] := '9'
      else
        vSoundplayer.Playlist.List.Cells[5, vk] := '10';
      BASS_StreamFree(sound.str_music[100]);
      Inc(vk, 1);
    end;
  end;

  vSoundplayer.Playlist.List.Selected := addons.Soundplayer.Player.LastPlayed;
  if addons.Soundplayer.Playlist.List.Songs.Count > 1 then
  begin
    addons.Soundplayer.Player.HasNext_Track := True;
    vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Grey;
  end
  else
  begin
    addons.Soundplayer.Player.HasNext_Track := False;
    vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  end;
  addons.Soundplayer.Player.HasPrevious_Track := False;
  vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Grey;
  vSoundplayer.info.Playlist_name.Text := addons.Soundplayer.Playlist.List.Name;
  vSoundplayer.Playlist.List.Selected := 0;
  vSoundplayer.info.Total_Songs.Text := '1/' + IntToStr(vk);
  vSoundplayer.info.Time_Total.Text := addons.Soundplayer.Playlist.List.Songs_Total_Time;
end;

procedure AddSongs_pls(mPL_Num: SmallInt);
begin

end;

procedure AddSongs_asx(mPL_Num: SmallInt);
begin

end;

procedure AddSongs_xspf(mPL_Num: SmallInt);
begin

end;

procedure AddSongs_wpl(mPL_Num: SmallInt);
begin

end;

procedure AddSongs_expl(mPL_Num: SmallInt);
begin

end;

procedure uSoundplayer_Playlist_Actions_AddSongs_Load(mPlaylistType: string; mPL_Num: SmallInt);
begin
  if mPlaylistType = '.m3u' then
    AddSongs_m3u(mPL_Num)
  else if mPlaylistType = 'pls' then
    AddSongs_pls(mPL_Num)
  else if mPlaylistType = 'asx' then
    AddSongs_asx(mPL_Num)
  else if mPlaylistType = 'xspf' then
    AddSongs_xspf(mPL_Num)
  else if mPlaylistType = 'wpl' then
    AddSongs_wpl(mPL_Num)
  else if mPlaylistType = 'expl' then
    AddSongs_expl(mPL_Num)
end;

// Stringgrid
procedure OnSelectCell(Sender: TObject; const ACol, ARow: Integer; var CanSelect: Boolean);
begin
  // vSoundplayer.Playlist.List_Popup.Visible:= True;
  // Main_Form.Label3.Text:= IntToStr(Main_Form.A_SP_Playlist.Selected);
  { if CanSelect= True then
    begin
    soundplayer_player.Playing_Now:= ARow;
    end; }
end;

procedure OnDoubleClick(const Column: TColumn; const Row: Integer);
begin
  if vSoundplayer.Playlist.List.Cells[2, Row] <> '' then
  begin
    vSoundplayer.Playlist.List.Cells[1, addons.Soundplayer.Player.Playing_Now] := '3';
    addons.Soundplayer.Player.Playing_Now := Row;
    uSoundplayer_Player.Update_Last_Song(addons.Soundplayer.Player.Playing_Now);
    BASS_ChannelStop(sound.str_music[1]);
    BASS_StreamFree(sound.str_music[1]);
    sound.str_music[1] := BASS_StreamCreateFile(False, PChar(addons.Soundplayer.Playlist.List.Songs.Strings[addons.Soundplayer.Player.Playing_Now]), 0, 0,
      BASS_SAMPLE_FLOAT {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
    BASS_ChannelSetAttribute(sound.str_music[1], BASS_ATTRIB_VOL, addons.Soundplayer.Volume.Vol / 100);
    vSoundplayer.info.Total_Songs.Text := IntToStr(addons.Soundplayer.Player.Playing_Now + 1) + '/' + addons.Soundplayer.Playlist.List.Songs_Num.ToString;
    if addons.Soundplayer.Player.Play = True then
    begin
      BASS_ChannelPlay(sound.str_music[1], False);
      addons.Soundplayer.Player.Play := True;
      addons.Soundplayer.Player.Pause := False;
      vSoundplayer.Playlist.List.Cells[1, addons.Soundplayer.Player.Playing_Now] := '0';
      uSoundplayer_Player.Get_Tag(addons.Soundplayer.Player.Playing_Now);
    end
    else if (addons.Soundplayer.Player.Pause = True) or (addons.Soundplayer.Player.Stop = True) or
      ((addons.Soundplayer.Player.Play = False) and (addons.Soundplayer.Player.Stop = False) and (addons.Soundplayer.Player.Pause = False)) then
    begin
      BASS_ChannelStop(sound.str_music[1]);
      BASS_ChannelSetPosition(sound.str_music[1], 0, 0);
      addons.Soundplayer.Player.Play := False;
      addons.Soundplayer.Player.Pause := False;
      vSoundplayer.Playlist.List.Cells[1, addons.Soundplayer.Player.Playing_Now] := '1';
      uSoundplayer_Player.Get_Tag(addons.Soundplayer.Player.Playing_Now);
    end;
    if (addons.Soundplayer.Playlist.List.Songs_Num - 1 <> Row) and (Row <> 0) then
    begin
      vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      addons.Soundplayer.Player.HasPrevious_Track := True;
      vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      addons.Soundplayer.Player.HasNext_Track := True;
      if addons.Soundplayer.Playlist.Edit then
      begin
        vSoundplayer.Playlist.Songs_Edit.Up.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
        vSoundplayer.Playlist.Songs_Edit.Down.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      end
    end
    else if Row = 0 then
    begin
      vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Grey;
      addons.Soundplayer.Player.HasPrevious_Track := False;
      vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      addons.Soundplayer.Player.HasNext_Track := True;
      if addons.Soundplayer.Playlist.Edit then
      begin
        vSoundplayer.Playlist.Songs_Edit.Up.TextSettings.FontColor := TAlphaColorRec.Grey;
        vSoundplayer.Playlist.Songs_Edit.Down.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      end;
    end
    else
    begin
      vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      addons.Soundplayer.Player.HasPrevious_Track := True;
      vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Grey;
      addons.Soundplayer.Player.HasNext_Track := False;
      if addons.Soundplayer.Playlist.Edit then
      begin
        vSoundplayer.Playlist.Songs_Edit.Up.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
        vSoundplayer.Playlist.Songs_Edit.Down.TextSettings.FontColor := TAlphaColorRec.Grey;
      end;
    end;
    vSoundplayer.info.Back_Left_Ani.Enabled := False;
    vSoundplayer.info.Back_Left.Position.X := 2;
    vSoundplayer.info.Back_Left_Ani.Enabled := True;
    vSoundplayer.info.Back_Right_Ani.Enabled := False;
    vSoundplayer.info.Back_Right.Position.X := vSoundplayer.scene.Back_Info.Width - 602;
    vSoundplayer.info.Back_Right_Ani.Enabled := True;
    uSoundplayer_Tag_Get.Set_Icon;
  end;
end;

///
procedure EditPlaylist(vActive: Boolean);
begin
  if addons.Soundplayer.Playlist.List.Songs_Num > 0 then
  begin
    if vActive then
    begin
      vSoundplayer.Playlist.Songs_Edit.Edit.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      if vSoundplayer.Playlist.List.Selected = 0 then
        vSoundplayer.Playlist.Songs_Edit.Up.TextSettings.FontColor := TAlphaColorRec.Grey
      else
        vSoundplayer.Playlist.Songs_Edit.Up.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      if vSoundplayer.Playlist.List.Selected = vSoundplayer.Playlist.List.RowCount - 1 then
        vSoundplayer.Playlist.Songs_Edit.Down.TextSettings.FontColor := TAlphaColorRec.Grey
      else
        vSoundplayer.Playlist.Songs_Edit.Down.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      vSoundplayer.Playlist.Songs_Edit.Delete.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      vSoundplayer.Playlist.Songs_Edit.Lock.Text := #$e990;
      BASS_ChannelPlay(addons.Soundplayer.sound.Effects[1], False);
    end
    else
    begin
      vSoundplayer.Playlist.Songs_Edit.Edit.TextSettings.FontColor := TAlphaColorRec.Grey;
      vSoundplayer.Playlist.Songs_Edit.Up.TextSettings.FontColor := TAlphaColorRec.Grey;
      vSoundplayer.Playlist.Songs_Edit.Down.TextSettings.FontColor := TAlphaColorRec.Grey;
      vSoundplayer.Playlist.Songs_Edit.Delete.TextSettings.FontColor := TAlphaColorRec.Grey;
      vSoundplayer.Playlist.Songs_Edit.Lock.Text := #$e98f;
      BASS_ChannelPlay(addons.Soundplayer.sound.Effects[0], False);
    end;
    addons.Soundplayer.Playlist.Edit := vActive;
  end;
end;

///

procedure SortPlaylistIni;
var
  vi: Integer;
begin
  if addons.Soundplayer.Playlist.Total <> -1 then
  begin
    // Delete all keys
    for vi := 0 to addons.Soundplayer.Playlist.Total do
    begin
      addons.Soundplayer.Ini.Ini.DeleteKey('Playlists', 'PL_' + vi.ToString + '_Name');
      addons.Soundplayer.Ini.Ini.DeleteKey('Playlists', 'PL_' + vi.ToString + '_Path');
      addons.Soundplayer.Ini.Ini.DeleteKey('Playlists', 'PL_' + vi.ToString + '_Type');
      addons.Soundplayer.Ini.Ini.DeleteKey('Playlists', 'PL_' + vi.ToString + '_Songs');
      addons.Soundplayer.Ini.Ini.DeleteKey('Playlists', 'PL_' + vi.ToString + '_Played');
      addons.Soundplayer.Ini.Ini.DeleteKey('Playlists', 'PL_' + vi.ToString + '_LastPlayed');
    end;
    // Rewrite the list
    for vi := 0 to addons.Soundplayer.Playlist.Total do
    begin
      addons.Soundplayer.Ini.Ini.WriteString('Playlists', 'PL_' + vi.ToString + '_Name', addons.Soundplayer.Playlist.List.Playlists[vi].Name);
      addons.Soundplayer.Ini.Ini.WriteString('Playlists', 'PL_' + vi.ToString + '_Path', addons.Soundplayer.Playlist.List.Playlists[vi].Path);
      addons.Soundplayer.Ini.Ini.WriteString('Playlists', 'PL_' + vi.ToString + '_Type', addons.Soundplayer.Playlist.List.Playlists[vi].vType);
      addons.Soundplayer.Ini.Ini.WriteInteger('Playlists', 'PL_' + vi.ToString + '_Songs', addons.Soundplayer.Playlist.List.Playlists[vi].Songs);
      addons.Soundplayer.Ini.Ini.WriteInteger('Playlists', 'PL_' + vi.ToString + '_Played', addons.Soundplayer.Playlist.List.Playlists[vi].Played);
      addons.Soundplayer.Ini.Ini.WriteString('Playlists', 'PL_' + vi.ToString + '_LastPlayed', addons.Soundplayer.Playlist.List.Playlists[vi].LastPlayed);
    end;
  end;
end;

procedure LoadPlaylists;
var
  vi: Integer;
  vPLInfo: TADDON_SOUNDPLAYER_PLAYLIST_PLAYLISTS;
begin
  if addons.Soundplayer.Playlist.Total <> -1 then
  begin
    SetLength(addons.Soundplayer.Playlist.List.Playlists, addons.Soundplayer.Playlist.Total + 1);
    for vi := 0 to addons.Soundplayer.Playlist.Total do
    begin
      vPLInfo.Name := addons.Soundplayer.Ini.Ini.ReadString('Playlists', 'PL_' + vi.ToString + '_Name', vPLInfo.Name);
      vPLInfo.vType := addons.Soundplayer.Ini.Ini.ReadString('Playlists', 'PL_' + vi.ToString + '_Type', vPLInfo.vType);
      vPLInfo.Path := addons.Soundplayer.Ini.Ini.ReadString('Playlists', 'PL_' + vi.ToString + '_Path', vPLInfo.Path);
      vPLInfo.Songs := addons.Soundplayer.Ini.Ini.ReadInteger('Playlists', 'PL_' + vi.ToString + '_Songs', vPLInfo.Songs);
      vPLInfo.Played := addons.Soundplayer.Ini.Ini.ReadInteger('Playlists', 'PL_' + vi.ToString + '_Played', vPLInfo.Played);
      vPLInfo.LastPlayed := addons.Soundplayer.Ini.Ini.ReadString('Playlists', 'PL_' + vi.ToString + '_LastPlayed', vPLInfo.LastPlayed);

      addons.Soundplayer.Playlist.List.Playlists[vi] := vPLInfo;
    end;
  end;
end;

procedure OnList_ShowPopup(Button: TMouseButton; X, Y: Single);
var
  vRowNum: Integer;
begin
  if addons.Soundplayer.Playlist.Edit then
  begin
    if Button = TMouseButton.mbRight then
    begin
      TThread.ForceQueue(nil,
        procedure
        begin
          vRowNum := vSoundplayer.Playlist.List.RowByPoint(X, Y);
          vSoundplayer.Playlist.List.Selected := vRowNum;
          if (Y + vSoundplayer.scene.Back_Playlist.Position.Y + 10) < 970 then
            vSoundplayer.Playlist.List_Popup_Memu.Popup(X, (Y + vSoundplayer.scene.Back_Playlist.Position.Y + 130))
          else
            vSoundplayer.Playlist.List_Popup_Memu.Popup(X, (Y + vSoundplayer.scene.Back_Playlist.Position.Y + 10));
        end);
      vRowNum := vSoundplayer.Playlist.List.RowByPoint(X, Y);
      if (addons.Soundplayer.Playlist.List.Songs_Num - 1 <> vRowNum) and (vRowNum <> 0) then
      begin
        vSoundplayer.Playlist.Songs_Edit.Up.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
        vSoundplayer.Playlist.Songs_Edit.Down.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      end
      else if vRowNum = 0 then
      begin
        vSoundplayer.Playlist.Songs_Edit.Up.TextSettings.FontColor := TAlphaColorRec.Grey;
        vSoundplayer.Playlist.Songs_Edit.Down.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      end
      else
      begin
        vSoundplayer.Playlist.Songs_Edit.Up.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
        vSoundplayer.Playlist.Songs_Edit.Down.TextSettings.FontColor := TAlphaColorRec.Grey;
      end;
    end
    else if Button = TMouseButton.mbLeft then
    begin

    end;
  end;
end;

procedure OnRowActions(vType: String; vSelected: Integer);
var
  vAct, vName, vArtist, vTime, vTag: String;
  vAct1, vName1, vArtist1, vTime1, vTag1: String;
  vi, vk: Integer;
begin
  if vType = 'delete' then
  begin
    with vSoundplayer.Playlist.List do
    begin
      for vi := vSelected to RowCount - 1 do
        for vk := 0 to ColumnCount - 1 do
        begin
          if vk = 0 then
          begin
            Cells[vk, vi] := (vi + 1).ToString;
          end
          else
            Cells[vk, vi] := Cells[vk, vi + 1];
        end;
      RowCount := RowCount - 1;
    end;
    Dec(addons.Soundplayer.Playlist.List.Songs_Num, 1);
    addons.Soundplayer.Ini.Ini.WriteInteger('Playlists', 'PL_' + addons.Soundplayer.Playlist.Active.ToString + '_Songs',
      addons.Soundplayer.Playlist.List.Songs_Num);

    if vSelected = addons.Soundplayer.Player.Playing_Now then
    begin
      if vSelected <> 0 then
        Dec(addons.Soundplayer.Player.Playing_Now, 1);
      BASS_ChannelStop(sound.str_music[1]);
      BASS_StreamFree(sound.str_music[1]);
      sound.str_music[1] := BASS_StreamCreateFile(False, PChar(addons.Soundplayer.Playlist.List.Songs.Strings[addons.Soundplayer.Player.Playing_Now]), 0, 0,
        BASS_SAMPLE_FLOAT {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
      BASS_ChannelSetAttribute(sound.str_music[1], BASS_ATTRIB_VOL, addons.Soundplayer.Volume.Vol / 100);
      uSoundplayer_Player.Get_Tag(addons.Soundplayer.Player.Playing_Now);
      if (addons.Soundplayer.Player.Play) then
      begin
        BASS_ChannelPlay(sound.str_music[1], False);
        vSoundplayer.Playlist.List.Cells[1, addons.Soundplayer.Player.Playing_Now] := '0';
      end
      else if addons.Soundplayer.Player.Pause then
      begin
        BASS_ChannelPause(sound.str_music[1]);
        vSoundplayer.Playlist.List.Cells[1, addons.Soundplayer.Player.Playing_Now] := '2';
      end
      else if addons.Soundplayer.Player.Stop then
      begin
        BASS_ChannelStop(sound.str_music[1]);
        vSoundplayer.Playlist.List.Cells[1, addons.Soundplayer.Player.Playing_Now] := '1';
      end;

      if addons.Soundplayer.Player.Playing_Now = 0 then
      begin
        vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Grey;
        vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      end
      else
      begin
        vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
        vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      end;
      vSoundplayer.Playlist.List.Selected := vSoundplayer.Playlist.List.Selected - 1;
    end;

  end
  else if vType = 'move_up' then
  begin
    if vSelected = addons.Soundplayer.Player.Playing_Now then
    begin
      Dec(addons.Soundplayer.Player.Playing_Now, 1);
      if addons.Soundplayer.Player.Playing_Now = 0 then
      begin
        vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Grey;
        vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      end
      else
      begin
        vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
        vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      end;
    end;
    vSoundplayer.Playlist.List.Selected := vSoundplayer.Playlist.List.Selected - 1;
    vAct := vSoundplayer.Playlist.List.Cells[1, vSelected];
    vName := vSoundplayer.Playlist.List.Cells[2, vSelected];
    vArtist := vSoundplayer.Playlist.List.Cells[3, vSelected];
    vTime := vSoundplayer.Playlist.List.Cells[4, vSelected];
    vTag := vSoundplayer.Playlist.List.Cells[5, vSelected];

    vAct1 := vSoundplayer.Playlist.List.Cells[1, vSelected - 1];
    vName1 := vSoundplayer.Playlist.List.Cells[2, vSelected - 1];
    vArtist1 := vSoundplayer.Playlist.List.Cells[3, vSelected - 1];
    vTime1 := vSoundplayer.Playlist.List.Cells[4, vSelected - 1];
    vTag1 := vSoundplayer.Playlist.List.Cells[5, vSelected - 1];

    vSoundplayer.Playlist.List.Cells[1, vSelected - 1] := vAct;
    vSoundplayer.Playlist.List.Cells[2, vSelected - 1] := vName;
    vSoundplayer.Playlist.List.Cells[3, vSelected - 1] := vArtist;
    vSoundplayer.Playlist.List.Cells[4, vSelected - 1] := vTime;
    vSoundplayer.Playlist.List.Cells[5, vSelected - 1] := vTag;

    vSoundplayer.Playlist.List.Cells[1, vSelected] := vAct1;
    vSoundplayer.Playlist.List.Cells[2, vSelected] := vName1;
    vSoundplayer.Playlist.List.Cells[3, vSelected] := vArtist1;
    vSoundplayer.Playlist.List.Cells[4, vSelected] := vTime1;
    vSoundplayer.Playlist.List.Cells[5, vSelected] := vTag1;
  end
  else if vType = 'move_down' then
  begin
    if vSelected = addons.Soundplayer.Player.Playing_Now then
    begin
      Inc(addons.Soundplayer.Player.Playing_Now, 1);
      if addons.Soundplayer.Player.Playing_Now = addons.Soundplayer.Playlist.List.Songs_Num - 1 then
      begin
        vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
        vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Grey;
      end
      else
      begin
        vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
        vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      end;
    end;
    vSoundplayer.Playlist.List.Selected := vSoundplayer.Playlist.List.Selected + 1;
    vAct := vSoundplayer.Playlist.List.Cells[1, vSelected];
    vName := vSoundplayer.Playlist.List.Cells[2, vSelected];
    vArtist := vSoundplayer.Playlist.List.Cells[3, vSelected];
    vTime := vSoundplayer.Playlist.List.Cells[4, vSelected];
    vTag := vSoundplayer.Playlist.List.Cells[5, vSelected];

    vAct1 := vSoundplayer.Playlist.List.Cells[1, vSelected + 1];
    vName1 := vSoundplayer.Playlist.List.Cells[2, vSelected + 1];
    vArtist1 := vSoundplayer.Playlist.List.Cells[3, vSelected + 1];
    vTime1 := vSoundplayer.Playlist.List.Cells[4, vSelected + 1];
    vTag1 := vSoundplayer.Playlist.List.Cells[5, vSelected + 1];

    vSoundplayer.Playlist.List.Cells[1, vSelected + 1] := vAct;
    vSoundplayer.Playlist.List.Cells[2, vSelected + 1] := vName;
    vSoundplayer.Playlist.List.Cells[3, vSelected + 1] := vArtist;
    vSoundplayer.Playlist.List.Cells[4, vSelected + 1] := vTime;
    vSoundplayer.Playlist.List.Cells[5, vSelected + 1] := vTag;

    vSoundplayer.Playlist.List.Cells[1, vSelected] := vAct1;
    vSoundplayer.Playlist.List.Cells[2, vSelected] := vName1;
    vSoundplayer.Playlist.List.Cells[3, vSelected] := vArtist1;
    vSoundplayer.Playlist.List.Cells[4, vSelected] := vTime1;
    vSoundplayer.Playlist.List.Cells[5, vSelected] := vTag1;
  end;
end;

///
procedure Edit_MoveUp;
var
  vLineSong: String;
begin
  // Change line in Playlist
  if addons.Soundplayer.Playlist.List.vType = '.m3u' then
    uSoundplyaer_Playlist_Actions_Row_In_M3u('move_up', addons.Soundplayer.Playlist.List.Songs.Strings[vSoundplayer.Playlist.List.Selected]);

  // Change line in Songs list
  Edit_SongInfo('move_up', vSoundplayer.Playlist.List.Selected);
  vLineSong := addons.Soundplayer.Playlist.List.Songs.Strings[vSoundplayer.Playlist.List.Selected];
  addons.Soundplayer.Playlist.List.Songs.Delete(vSoundplayer.Playlist.List.Selected);
  addons.Soundplayer.Playlist.List.Songs.Insert(vSoundplayer.Playlist.List.Selected - 1, vLineSong);

  // Change line is stringgrid
  OnRowActions('move_up', vSoundplayer.Playlist.List.Selected);

  if addons.Soundplayer.Player.Playing_Now = 0 then
  begin
    vSoundplayer.Playlist.Songs_Edit.Up_Glow.Enabled := False;
    vSoundplayer.Playlist.Songs_Edit.Up.TextSettings.FontColor := TAlphaColorRec.Grey;
    vSoundplayer.Playlist.Songs_Edit.Down.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  end
  else
  begin
    vSoundplayer.Playlist.Songs_Edit.Up.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    vSoundplayer.Playlist.Songs_Edit.Down.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  end;

  uSoundplayer_Player.Update_Last_Song(addons.Soundplayer.Player.Playing_Now);

end;

procedure Edit_MoveDown;
var
  vLineSong: String;
begin
  // Change line in Playlist
  if addons.Soundplayer.Playlist.List.vType = '.m3u' then
    uSoundplyaer_Playlist_Actions_Row_In_M3u('move_down', addons.Soundplayer.Playlist.List.Songs.Strings[vSoundplayer.Playlist.List.Selected]);

  // Change line in Songs list
  Edit_SongInfo('move_down', vSoundplayer.Playlist.List.Selected);
  vLineSong := addons.Soundplayer.Playlist.List.Songs.Strings[vSoundplayer.Playlist.List.Selected];
  addons.Soundplayer.Playlist.List.Songs.Delete(vSoundplayer.Playlist.List.Selected);
  addons.Soundplayer.Playlist.List.Songs.Insert(vSoundplayer.Playlist.List.Selected + 1, vLineSong);

  // Change line is stringgrid
  OnRowActions('move_down', vSoundplayer.Playlist.List.Selected);

  if addons.Soundplayer.Player.Playing_Now = addons.Soundplayer.Playlist.List.Songs.Count - 1 then
  begin
    vSoundplayer.Playlist.Songs_Edit.Up.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    vSoundplayer.Playlist.Songs_Edit.Down_Glow.Enabled := False;
    vSoundplayer.Playlist.Songs_Edit.Down.TextSettings.FontColor := TAlphaColorRec.Grey;
  end
  else
  begin
    vSoundplayer.Playlist.Songs_Edit.Up.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    vSoundplayer.Playlist.Songs_Edit.Down.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  end;

  uSoundplayer_Player.Update_Last_Song(addons.Soundplayer.Player.Playing_Now);

end;

procedure Edit_SongInfo(vType: String; vSelected: Integer);
var
  vSong1, vSong2: TADDON_SOUNDPLAYER_PLAYLIST_INFO_TAG;
  ALength: Cardinal;
  vi: Cardinal;
begin
  if vType = 'delete' then
  begin
    ALength := Length(addons.Soundplayer.Playlist.List.Song_Info);
    Assert(ALength > 0);
    Assert(vSelected < ALength);
    for vi := vSelected + 1 to ALength - 1 do
      addons.Soundplayer.Playlist.List.Song_Info[vi - 1] := addons.Soundplayer.Playlist.List.Song_Info[vi];
    SetLength(addons.Soundplayer.Playlist.List.Song_Info, ALength - 1);
  end
  else if vType = 'move_up' then
  begin
    vSong1 := addons.Soundplayer.Playlist.List.Song_Info[vSelected];
    vSong2 := addons.Soundplayer.Playlist.List.Song_Info[vSelected - 1];

    addons.Soundplayer.Playlist.List.Song_Info[vSelected - 1] := vSong1;
    addons.Soundplayer.Playlist.List.Song_Info[vSelected] := vSong2;
  end
  else if vType = 'move_down' then
  begin
    vSong1 := addons.Soundplayer.Playlist.List.Song_Info[vSelected];
    vSong2 := addons.Soundplayer.Playlist.List.Song_Info[vSelected + 1];

    addons.Soundplayer.Playlist.List.Song_Info[vSelected + 1] := vSong1;
    addons.Soundplayer.Playlist.List.Song_Info[vSelected] := vSong2;
  end;
end;

procedure Edit_Delete;
begin
  vSoundplayer.scene.Back_Blur.Enabled := True;
  extrafe.prog.State := 'addon_soundplayer_playlist_edit';

  uSoundplayer_SetAll.RemoveSong_Dialog;
end;

procedure Edit_Delete_Song;
begin
  // Delete from the playlist
  if addons.Soundplayer.Playlist.List.vType = '.m3u' then
    uSoundplyaer_Playlist_Actions_Row_In_M3u('delete', addons.Soundplayer.Playlist.List.Songs.Strings[vSoundplayer.Playlist.List.Selected]);

  // Delete from songs list
  Edit_SongInfo('delete', vSoundplayer.Playlist.List.Selected);
  addons.Soundplayer.Playlist.List.Songs.Delete(vSoundplayer.Playlist.List.Selected);

  // Delete from the stringgrid
  OnRowActions('delete', vSoundplayer.Playlist.List.Selected);

  if addons.Soundplayer.Player.Playing_Now = 0 then
  begin
    vSoundplayer.Playlist.Songs_Edit.Up_Glow.Enabled := False;
    vSoundplayer.Playlist.Songs_Edit.Up.TextSettings.FontColor := TAlphaColorRec.Grey;
    vSoundplayer.Playlist.Songs_Edit.Down.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  end
  else
  begin
    vSoundplayer.Playlist.Songs_Edit.Up.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    vSoundplayer.Playlist.Songs_Edit.Down.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  end;

  uSoundplayer_Player.Update_Last_Song(addons.Soundplayer.Player.Playing_Now);

  Edit_Delete_Cancel;
end;

procedure Edit_Delete_Cancel;
begin
  vSoundplayer.scene.Back_Blur.Enabled := False;
  uSoundplayer_Player.Text_OnLeave(vSoundplayer.Playlist.Songs_Edit.Delete, vSoundplayer.Playlist.Songs_Edit.Delete_Glow);
  extrafe.prog.State := 'addon_soundplayer';
  FreeAndNil(vSoundplayer.Playlist.Remove_Song.Remove);
end;

// Edit Playlist
procedure uSoundplyaer_Playlist_Actions_Row_In_M3u(vType, vSong: String);
var
  vStr, vStr1: String;
  vStr_, vStr_1: String;
  vi: Integer;
begin
  if vType = 'delete' then
  begin
    for vi := 0 to addons.Soundplayer.Playlist.List.Playlist.Count - 1 do
    begin
      vStr := addons.Soundplayer.Playlist.List.Playlist.Strings[vi];
      if vStr = vSong then
      begin
        vStr1 := addons.Soundplayer.Playlist.List.Playlist.Strings[vi - 1];
        addons.Soundplayer.Playlist.List.Playlist.Delete(vi);
        addons.Soundplayer.Playlist.List.Playlist.Delete(vi - 1);
        addons.Soundplayer.Playlist.List.Playlist.SaveToFile(addons.Soundplayer.Path.Playlists + addons.Soundplayer.Playlist.List.Name +
          addons.Soundplayer.Playlist.List.vType);
        break
      end;
    end;
  end
  else if vType = 'move_up' then
  begin
    for vi := 0 to addons.Soundplayer.Playlist.List.Playlist.Count - 1 do
    begin
      vStr := addons.Soundplayer.Playlist.List.Playlist.Strings[vi];
      if vStr = vSong then
      begin
        vStr1 := addons.Soundplayer.Playlist.List.Playlist.Strings[vi - 1];
        vStr_1 := addons.Soundplayer.Playlist.List.Playlist.Strings[vi - 2];
        vStr_ := addons.Soundplayer.Playlist.List.Playlist.Strings[vi - 3];
        addons.Soundplayer.Playlist.List.Playlist.Delete(vi - 2);
        addons.Soundplayer.Playlist.List.Playlist.Delete(vi - 3);
        addons.Soundplayer.Playlist.List.Playlist.Insert(vi - 1, vStr_);
        addons.Soundplayer.Playlist.List.Playlist.Insert(vi, vStr_1);
        addons.Soundplayer.Playlist.List.Playlist.SaveToFile(addons.Soundplayer.Path.Playlists + addons.Soundplayer.Playlist.List.Name +
          addons.Soundplayer.Playlist.List.vType);
        break
      end;
    end;
  end
  else if vType = 'move_down' then
  begin
    for vi := 0 to addons.Soundplayer.Playlist.List.Playlist.Count - 1 do
    begin
      vStr := addons.Soundplayer.Playlist.List.Playlist.Strings[vi];
      if vStr = vSong then
      begin
        vStr1 := addons.Soundplayer.Playlist.List.Playlist.Strings[vi - 1];
        vStr_1 := addons.Soundplayer.Playlist.List.Playlist.Strings[vi + 1];
        vStr_ := addons.Soundplayer.Playlist.List.Playlist.Strings[vi + 2];
        addons.Soundplayer.Playlist.List.Playlist.Delete(vi);
        addons.Soundplayer.Playlist.List.Playlist.Delete(vi - 1);
        addons.Soundplayer.Playlist.List.Playlist.Insert(vi + 1, vStr_1);
        addons.Soundplayer.Playlist.List.Playlist.Insert(vi + 2, vStr);
        addons.Soundplayer.Playlist.List.Playlist.SaveToFile(addons.Soundplayer.Path.Playlists + addons.Soundplayer.Playlist.List.Name +
          addons.Soundplayer.Playlist.List.vType);
        break
      end;
    end;
  end;
end;

procedure uSoundplyaer_Playlist_Actions_Row_In_Pls(vType: String);
begin

end;

procedure uSoundplyaer_Playlist_Actions_Row_In_Asx(vType: String);
begin

end;

procedure uSoundplyaer_Playlist_Actions_Row_In_Xspf(vType: String);
begin

end;

procedure uSoundplyaer_Playlist_Actions_Row_In_Wpl(vType: String);
begin

end;

procedure uSoundplyaer_Playlist_Actions_Row_In_expl(vType: String);
begin

end;

end.
