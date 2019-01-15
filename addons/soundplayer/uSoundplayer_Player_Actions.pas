unit uSoundplayer_Player_Actions;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Layouts,
  FMX.Grid,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Effects,
  bass;

procedure uSoundplayer_Player_Actions_Refresh;
procedure uSoundplayer_Player_Actions_Refresh_GoTo(vGo: Integer; vPlay: Boolean);
procedure uSoundplayer_Player_Actions_Refresh_SetTheIcons(vPlay: Boolean);

procedure uSoundPlayer_Player_Actions_OnOver(vImage: TImage; vGlow: TGlowEffect);
procedure uSoundPlayer_Player_Actions_OnLeave(vImage: TImage; vGlow: TGlowEffect);

procedure uSoundPlayer_Player_Actions_StartOrPause;
procedure uSoundPlayer_Player_Actions_Stop;
procedure uSoundPlayer_Player_Actions_Previous;
procedure uSoundPlayer_Player_Actions_Next;

procedure uSoundplayer_Player_Actions_Out_Next;
procedure uSoundplayer_Player_Actions_Out_Previous;

procedure uSoundplayer_Player_Actions_SetRepeat(vCurrent: String);

procedure uSoundPlayer_Player_Actions_ShowTag(vSongName: String; vSongNum: Integer);

procedure uSoundplayer_Player_Actions_Title_Animation;

// Song position
procedure uSoundplayer_Player_Actions_UpdateSongPosition(Sender: TObject; mValue: single; vKeep: Boolean);

// Add new songs
procedure uSoundPlayer_Player_Actions_AddNewSongs;

// Add songs in playlist based types
procedure AddSongs_In_m3u(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string; mSongNum: SmallInt);
procedure AddSongs_In_pls(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string);
procedure AddSongs_In_asx(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string);
procedure AddSongs_In_xspf(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string);
procedure AddSongs_In_wpl(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string);
procedure AddSongs_In_expl(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string);

procedure uSoundPlayer_PAction_ShowTagDetails(mSongNum: SmallInt);

// Update last played song from the current playlist
procedure uSoundplayer_Player_Actions_UpdateLastPlayedSong(vNum: Integer);

implementation

uses
  main,
  uLoad,
  uLoad_AllTypes,
  uSnippet_Text,
  uMain,
  uWindows,
  uSoundplayer_SetAll,
  uSoundplayer_AllTypes,
  uSoundplayer_Playlist_Actions,
  uSoundplayer_Playlist_Create,
  uSoundplayer_Tag_Get,
  uSoundplayer_Tag_Mp3_SetAll,
  uSoundplayer_Tag_Mp3,
  uSoundplayer_Tag_Ogg_SetAll,
  uSoundplayer_Tag_Ogg,
  uTTrackbar;

procedure uSoundplayer_Player_Actions_Refresh;
var
  sCT, sFT: Real;
  vRand: Integer;
  viPos: Integer;
begin

  if addons.soundplayer.Player.Play then
  begin
    sCT := trunc(BASS_ChannelBytes2Seconds(sound.str_music[1], BASS_ChannelGetPosition(sound.str_music[1],
      BASS_POS_BYTE)));
    sFT := trunc(BASS_ChannelBytes2Seconds(sound.str_music[1], BASS_ChannelGetLength(sound.str_music[1],
      BASS_POS_BYTE)));

    viPos := Pos('addon_soundplayer', extrafe.prog.State);

    if viPos <> 0 then
      if addons.soundplayer.Player.Thumb_Active = False then
      begin
        if addons.soundplayer.Player.Time_Negative = False then
          vSoundplayer.Player.Song_PlayTime.Text :=
            FormatDateTime('hh:mm:ss', uWindows_ConvertSecondsFromTime(sCT))
        else
          vSoundplayer.Player.Song_PlayTime.Text := '-' + FormatDateTime('hh:mm:ss',
            uWindows_ConvertSecondsFromTime(sFT - sCT));
        vSoundplayer.Player.Song_Pos.Value := (sCT * 1000 / sFT);
        addons.soundplayer.Player.Song_State := vSoundplayer.Player.Song_Pos.Value;
      end;
    if BASS_ChannelGetPosition(sound.str_music[1], BASS_POS_BYTE) >= BASS_ChannelGetLength(sound.str_music[1],
      BASS_POS_BYTE) then
    begin
      if addons.soundplayer.Player.Suffle then
      begin
        repeat
          vRand := Random(addons.soundplayer.Playlist.List.Songs_Num);
        until vRand <> addons.soundplayer.Player.Playing_Now;
        addons.soundplayer.Player.Playing_Now := vRand;
        uSoundplayer_Player_Actions_Refresh_GoTo(addons.soundplayer.Player.Playing_Now, True);
      end
      else if addons.soundplayer.Player.VRepeat <> '' then
      begin
        if addons.soundplayer.Player.VRepeat = 'Song_1' then
        begin
          uSoundplayer_Player_Actions_SetRepeat('List_Inf');
          uSoundplayer_Player_Actions_Refresh_GoTo(addons.soundplayer.Player.Playing_Now, True);
        end
        else if addons.soundplayer.Player.VRepeat = 'Song_Inf' then
        begin
          uSoundplayer_Player_Actions_Refresh_GoTo(addons.soundplayer.Player.Playing_Now, True)
        end
        else if addons.soundplayer.Player.VRepeat = 'List_1' then
        begin
          if addons.soundplayer.Player.Playing_Now = addons.soundplayer.Playlist.List.Songs_Num then
          begin
            uSoundplayer_Player_Actions_SetRepeat('List_Inf');
            uSoundplayer_Player_Actions_Refresh_GoTo(0, True);
          end
          else
            uSoundPlayer_Player_Actions_Next;
        end
        else if addons.soundplayer.Player.VRepeat = 'List_Inf' then
        begin
          if addons.soundplayer.Player.Playing_Now = addons.soundplayer.Playlist.List.Songs_Num then
            uSoundplayer_Player_Actions_Refresh_GoTo(0, True)
          else
            uSoundPlayer_Player_Actions_Next;
        end;
      end
      else if addons.soundplayer.Player.HasNext_Track = True then
      begin
        if viPos <> 0 then
          uSoundPlayer_Player_Actions_Next
        else
          uSoundplayer_Player_Actions_Out_Next;
      end
      else
        uSoundplayer_Player_Actions_Refresh_GoTo(0, False);
    end;
  end;
end;

procedure uSoundplayer_Player_Actions_Refresh_SetTheIcons(vPlay: Boolean);
begin
  addons.soundplayer.Player.Play := vPlay;
  if (addons.soundplayer.Player.Playing_Now + 1 < addons.soundplayer.Playlist.List.Songs_Num) and
    (addons.soundplayer.Player.Playing_Now <> 0) then
  begin
    addons.soundplayer.Player.HasPrevious_Track := True;
    vSoundplayer.Player.Previous_Grey.Enabled := False;
    addons.soundplayer.Player.HasNext_Track := True;
    vSoundplayer.Player.Next_Grey.Enabled := False;
  end
  else if addons.soundplayer.Player.Playing_Now = 0 then
  begin
    addons.soundplayer.Player.HasPrevious_Track := False;
    vSoundplayer.Player.Previous_Grey.Enabled := True;
    addons.soundplayer.Player.HasNext_Track := True;
    vSoundplayer.Player.Next_Grey.Enabled := False;
  end
  else
  begin
    addons.soundplayer.Player.HasPrevious_Track := True;
    vSoundplayer.Player.Previous_Grey.Enabled := False;
    addons.soundplayer.Player.HasNext_Track := False;
    vSoundplayer.Player.Next_Grey.Enabled := True;
  end;
end;

procedure uSoundplayer_Player_Actions_Refresh_GoTo(vGo: Integer; vPlay: Boolean);
begin
  addons.soundplayer.Player.LastPlayed := vGo;
  addons.soundplayer.Player.Playing_Now := vGo;
  if extrafe.prog.State = 'addon_soundplayer' then
  begin
    vSoundplayer.Playlist.List.Selected := addons.soundplayer.Player.Playing_Now;
    uSoundPlayer_PAction_ShowTagDetails(addons.soundplayer.Player.Playing_Now);
    vSoundplayer.Playlist.List.Cells[1, addons.soundplayer.Player.Playing_Now] := '2';
  end;
  BASS_StreamFree(sound.str_music[1]);
  sound.str_music[1] := BASS_StreamCreateFile(False,
    PChar(addons.soundplayer.Playlist.List.Songs.Strings[addons.soundplayer.Player.Playing_Now]), 0, 0,
    BASS_SAMPLE_FLOAT {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
  BASS_ChannelSetPosition(sound.str_music[1], 0, 0);
  if addons.soundplayer.Player.Play then
    BASS_ChannelPlay(sound.str_music[1], False);
end;

// Click actions
procedure uSoundPlayer_Player_Actions_StartOrPause;
begin
  if vSoundplayer.Player.Play_Grey.Enabled = False then
  begin
    if sound.str_music[1] <> 0 then
      if (addons.soundplayer.Player.Play = False) or (addons.soundplayer.Player.Pause = True) then
      begin
        if addons.soundplayer.Player.Playing_Now <> vSoundplayer.Playlist.List.Selected then
          sound.str_music[1] := BASS_StreamCreateFile(False,
            PChar(addons.soundplayer.Playlist.List.Songs.Strings[addons.soundplayer.Player.Playing_Now]), 0,
            0, BASS_SAMPLE_FLOAT {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
        BASS_ChannelPlay(sound.str_music[1], False);
        BASS_ChannelSetAttribute(sound.str_music[1], BASS_ATTRIB_VOL, addons.soundplayer.Volume.Vol / 100);
        addons.soundplayer.Player.Play := True;
        addons.soundplayer.Player.Pause := False;
        vSoundplayer.Playlist.List.Cells[1, addons.soundplayer.Player.Playing_Now] := '0';
        vSoundplayer.timer.Song.Enabled := True;
        uSoundplayer_Player_Actions_UpdateLastPlayedSong(addons.soundplayer.Player.Playing_Now);
      end
      else
      begin
        BASS_ChannelPause(sound.str_music[1]);
        addons.soundplayer.Player.Pause := True;
        addons.soundplayer.Player.Play := False;
        vSoundplayer.Playlist.List.Cells[1, addons.soundplayer.Player.Playing_Now] := '2';
        vSoundplayer.timer.Song.Enabled := True;
      end;
  end;
end;

procedure uSoundPlayer_Player_Actions_Stop;
begin
  if vSoundplayer.Player.Stop_Grey.Enabled = False then
  begin
    if sound.str_music[1] <> 0 then
      if (addons.soundplayer.Player.Play = True) or (addons.soundplayer.Player.Pause = True) then
      begin
        BASS_ChannelStop(sound.str_music[1]);
        BASS_ChannelSetPosition(sound.str_music[1], 0, 0);
        vSoundplayer.Player.Song_Pos.Value := 0;
        addons.soundplayer.Player.Play := False;
        addons.soundplayer.Player.Pause := False;
        vSoundplayer.Playlist.List.Cells[1, addons.soundplayer.Player.Playing_Now] := '1';
      end;
  end;
end;

procedure uSoundPlayer_Player_Actions_Previous;
begin
  if vSoundplayer.Player.Previous_Grey.Enabled = False then
  begin
    if sound.str_music[1] <> 0 then
      if addons.soundplayer.Player.Playing_Now > 0 then
      begin
        vSoundplayer.Playlist.List.Cells[1, addons.soundplayer.Player.Playing_Now] := '3';
        Dec(addons.soundplayer.Player.Playing_Now, 1);
        uSoundplayer_Player_Actions_UpdateLastPlayedSong(addons.soundplayer.Player.Playing_Now);
        if addons.soundplayer.Player.Playing_Now = 0 then
        begin
          addons.soundplayer.Player.HasPrevious_Track := False;
          uSoundPlayer_Player_Actions_OnLeave(vSoundplayer.Player.Previous,
            vSoundplayer.Player.Previous_Glow);
          vSoundplayer.Player.Previous_Grey.Enabled := True;
          if addons.soundplayer.Playlist.Edit then
            vSoundplayer.Playlist.Songs_Edit.Up_Grey.Enabled := True;
        end;
        addons.soundplayer.Player.HasNext_Track := True;
        vSoundplayer.Player.Next_Grey.Enabled := False;
        if addons.soundplayer.Playlist.Edit then
          vSoundplayer.Playlist.Songs_Edit.Down_Grey.Enabled := False;
        BASS_ChannelStop(sound.str_music[1]);
        BASS_StreamFree(sound.str_music[1]);
        sound.str_music[1] := BASS_StreamCreateFile(False,
          PChar(addons.soundplayer.Playlist.List.Songs.Strings[addons.soundplayer.Player.Playing_Now]), 0, 0,
          BASS_SAMPLE_FLOAT {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
        BASS_ChannelSetAttribute(sound.str_music[1], BASS_ATTRIB_VOL, addons.soundplayer.Volume.Vol / 100);
        if (addons.soundplayer.Player.Play = True) then
        begin
          BASS_ChannelPlay(sound.str_music[1], False);
          vSoundplayer.Playlist.List.Cells[1, addons.soundplayer.Player.Playing_Now] := '0';
        end
        else if addons.soundplayer.Player.Stop = True then
        begin
          vSoundplayer.Playlist.List.Cells[1, addons.soundplayer.Player.Playing_Now] := '1';
          vSoundplayer.Player.Play.Bitmap.LoadFromFile(addons.soundplayer.Path.Images + 'sp_play.png');
        end;
        uSoundPlayer_PAction_ShowTagDetails(addons.soundplayer.Player.Playing_Now);
        vSoundplayer.Playlist.List.Selected := addons.soundplayer.Player.Playing_Now;
        vSoundplayer.info.Total_Songs.Text := IntToStr(addons.soundplayer.Player.Playing_Now + 1) + '/' +
          addons.soundplayer.Playlist.List.Songs_Num.ToString;
        vSoundplayer.info.Back_Left_Ani.Enabled := False;
        vSoundplayer.info.Back_Left.Position.X := 2;
        vSoundplayer.info.Back_Left_Ani.Enabled := True;
        vSoundplayer.info.Back_Right_Ani.Enabled := False;
        vSoundplayer.info.Back_Right.Position.X := vSoundplayer.scene.Back_Info.Width - 602;
        vSoundplayer.info.Back_Right_Ani.Enabled := True;
        uSoundplayer_Tag_LoadIcon;
      end;
  end;
end;

procedure uSoundplayer_Player_Actions_Out_Previous;
begin
  if addons.soundplayer.Player.Playing_Now > 0 then
  begin
    Dec(addons.soundplayer.Player.Playing_Now, 1);
    if addons.soundplayer.Player.Playing_Now = 0 then
      addons.soundplayer.Player.HasPrevious_Track := False;
    addons.soundplayer.Player.HasNext_Track := True;
    BASS_ChannelStop(sound.str_music[1]);
    BASS_StreamFree(sound.str_music[1]);
    sound.str_music[1] := BASS_StreamCreateFile(False,
      PChar(addons.soundplayer.Playlist.List.Songs.Strings[addons.soundplayer.Player.Playing_Now]), 0, 0,
      BASS_SAMPLE_FLOAT {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
    BASS_ChannelSetAttribute(sound.str_music[1], BASS_ATTRIB_VOL, addons.soundplayer.Volume.Vol / 100);
    if (addons.soundplayer.Player.Play = True) then
      BASS_ChannelPlay(sound.str_music[1], False);
  end;
end;

procedure uSoundPlayer_Player_Actions_Next;
begin
  if vSoundplayer.Player.Next_Grey.Enabled = False then
  begin
    if addons.soundplayer.Player.Playing_Now < vSoundplayer.Playlist.List.RowCount - 1 then
    begin
      vSoundplayer.Playlist.List.Cells[1, addons.soundplayer.Player.Playing_Now] := '3';
      Inc(addons.soundplayer.Player.Playing_Now, 1);
      uSoundplayer_Player_Actions_UpdateLastPlayedSong(addons.soundplayer.Player.Playing_Now);
      if addons.soundplayer.Player.Playing_Now = vSoundplayer.Playlist.List.RowCount - 1 then
      begin
        addons.soundplayer.Player.HasNext_Track := False;
        uSoundPlayer_Player_Actions_OnLeave(vSoundplayer.Player.Next, vSoundplayer.Player.Next_Glow);
        vSoundplayer.Player.Next_Grey.Enabled := True;
        if addons.soundplayer.Playlist.Edit then
          vSoundplayer.Playlist.Songs_Edit.Down_Grey.Enabled := True;
      end;
      addons.soundplayer.Player.HasPrevious_Track := True;
      vSoundplayer.Player.Previous_Grey.Enabled := False;
      if addons.soundplayer.Playlist.Edit then
        vSoundplayer.Playlist.Songs_Edit.Up_Grey.Enabled := False;
      BASS_ChannelStop(sound.str_music[1]);
      BASS_StreamFree(sound.str_music[1]);
      sound.str_music[1] := BASS_StreamCreateFile(False,
        PChar(addons.soundplayer.Playlist.List.Songs.Strings[addons.soundplayer.Player.Playing_Now]), 0, 0,
        BASS_SAMPLE_FLOAT {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
      BASS_ChannelSetAttribute(sound.str_music[1], BASS_ATTRIB_VOL, addons.soundplayer.Volume.Vol / 100);
      if (addons.soundplayer.Player.Play = True) then
      begin
        BASS_ChannelPlay(sound.str_music[1], False);
        vSoundplayer.Playlist.List.Cells[1, addons.soundplayer.Player.Playing_Now] := '0';
      end
      else if addons.soundplayer.Player.Stop = True then
      begin
        vSoundplayer.Playlist.List.Cells[1, addons.soundplayer.Player.Playing_Now] := '1';
        vSoundplayer.Player.Play.Bitmap.LoadFromFile(addons.soundplayer.Path.Images + 'sp_play.png');
      end;
      uSoundPlayer_PAction_ShowTagDetails(addons.soundplayer.Player.Playing_Now);
      vSoundplayer.Playlist.List.Selected := addons.soundplayer.Player.Playing_Now;
      vSoundplayer.info.Total_Songs.Text := IntToStr(addons.soundplayer.Player.Playing_Now + 1) + '/' +
        addons.soundplayer.Playlist.List.Songs_Num.ToString;
      vSoundplayer.info.Back_Left_Ani.Enabled := False;
      vSoundplayer.info.Back_Left.Position.X := 2;
      vSoundplayer.info.Back_Left_Ani.Enabled := True;
      vSoundplayer.info.Back_Right_Ani.Enabled := False;
      vSoundplayer.info.Back_Right.Position.X := vSoundplayer.scene.Back_Info.Width - 602;
      vSoundplayer.info.Back_Right_Ani.Enabled := True;
      uSoundplayer_Tag_LoadIcon;
    end;
  end;
end;

procedure uSoundplayer_Player_Actions_Out_Next;
begin
  if addons.soundplayer.Player.Playing_Now < addons.soundplayer.Playlist.List.Songs_Num - 1 then
  begin
    Inc(addons.soundplayer.Player.Playing_Now, 1);
    if addons.soundplayer.Player.Playing_Now = addons.soundplayer.Playlist.List.Songs_Num - 1 then
      addons.soundplayer.Player.HasNext_Track := False;
    addons.soundplayer.Player.HasPrevious_Track := True;
    BASS_ChannelStop(sound.str_music[1]);
    BASS_StreamFree(sound.str_music[1]);
    sound.str_music[1] := BASS_StreamCreateFile(False,
      PChar(addons.soundplayer.Playlist.List.Songs.Strings[addons.soundplayer.Player.Playing_Now]), 0, 0,
      BASS_SAMPLE_FLOAT {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
    BASS_ChannelSetAttribute(sound.str_music[1], BASS_ATTRIB_VOL, addons.soundplayer.Volume.Vol / 100);
    if (addons.soundplayer.Player.Play = True) then
      BASS_ChannelPlay(sound.str_music[1], False);
  end;
end;

procedure uSoundplayer_Player_Actions_SetRepeat(vCurrent: String);
begin
  if vCurrent = '' then
    addons.soundplayer.Player.VRepeat := 'Song_1'
  else if vCurrent = 'Song_1' then
    addons.soundplayer.Player.VRepeat := 'Song_Inf'
  else if vCurrent = 'Song_Inf' then
    addons.soundplayer.Player.VRepeat := 'List_1'
  else if vCurrent = 'List_1' then
    addons.soundplayer.Player.VRepeat := 'List_Inf'
  else if vCurrent = 'List_Inf' then
    addons.soundplayer.Player.VRepeat := '';

  if extrafe.prog.State = 'addon_soundplayer' then
  begin
    if addons.soundplayer.Player.VRepeat = '' then
    begin
      vSoundplayer.Player.Loop_State.Visible := False;
      vSoundplayer.Player.Loop_To.Visible := False;
      vSoundplayer.Player.Loop.RotationAngle := 360;
    end
    else if addons.soundplayer.Player.VRepeat = 'Song_1' then
    begin
      vSoundplayer.Player.Loop.RotationAngle := -72;
      vSoundplayer.Player.Loop_State.Visible := True;
      vSoundplayer.Player.Loop_State.Width := 12;
      vSoundplayer.Player.Loop_State.Height := 16;
      vSoundplayer.Player.Loop_State.Position.X := (vSoundplayer.Player.Loop.Position.X) +
        ((vSoundplayer.Player.Loop.Width / 2) - 4);
      vSoundplayer.Player.Loop_State.Position.Y := (vSoundplayer.Player.Loop.Position.Y) +
        ((vSoundplayer.Player.Loop.Height / 2) - 2);
      vSoundplayer.Player.Loop_State.Bitmap.LoadFromFile(addons.soundplayer.Path.Images + 'sp_loop_1.png');
      vSoundplayer.Player.Loop_To.Bitmap.LoadFromFile(addons.soundplayer.Path.Images + 'sp_loop_song.png');
      vSoundplayer.Player.Loop_To.Visible := True;
    end
    else if addons.soundplayer.Player.VRepeat = 'Song_Inf' then
    begin
      vSoundplayer.Player.Loop.RotationAngle := -144;
      vSoundplayer.Player.Loop_State.Visible := True;
      vSoundplayer.Player.Loop_State.Width := 20;
      vSoundplayer.Player.Loop_State.Height := 12;
      vSoundplayer.Player.Loop_State.Position.X := (vSoundplayer.Player.Loop.Position.X) +
        ((vSoundplayer.Player.Loop.Width / 2) - 6);
      vSoundplayer.Player.Loop_State.Position.Y := (vSoundplayer.Player.Loop.Position.Y) +
        ((vSoundplayer.Player.Loop.Height / 2) - 2);
      vSoundplayer.Player.Loop_State.Bitmap.LoadFromFile(addons.soundplayer.Path.Images + 'sp_loop_inf.png');
      vSoundplayer.Player.Loop_To.Bitmap.LoadFromFile(addons.soundplayer.Path.Images + 'sp_loop_song.png');
      vSoundplayer.Player.Loop_To.Visible := True;
    end
    else if addons.soundplayer.Player.VRepeat = 'List_1' then
    begin
      vSoundplayer.Player.Loop.RotationAngle := -216;
      vSoundplayer.Player.Loop_State.Visible := True;
      vSoundplayer.Player.Loop_State.Width := 12;
      vSoundplayer.Player.Loop_State.Height := 16;
      vSoundplayer.Player.Loop_State.Position.X := (vSoundplayer.Player.Loop.Position.X) +
        ((vSoundplayer.Player.Loop.Width / 2) - 2);
      vSoundplayer.Player.Loop_State.Position.Y := (vSoundplayer.Player.Loop.Position.Y) +
        ((vSoundplayer.Player.Loop.Height / 2) - 8);
      vSoundplayer.Player.Loop_State.Bitmap.LoadFromFile(addons.soundplayer.Path.Images + 'sp_loop_1.png');
      vSoundplayer.Player.Loop_To.Bitmap.LoadFromFile(addons.soundplayer.Path.Images + 'sp_loop_list.png');
      vSoundplayer.Player.Loop_To.Visible := True;
    end
    else if addons.soundplayer.Player.VRepeat = 'List_Inf' then
    begin
      vSoundplayer.Player.Loop.RotationAngle := -288;
      vSoundplayer.Player.Loop_State.Visible := True;
      vSoundplayer.Player.Loop_State.Width := 20;
      vSoundplayer.Player.Loop_State.Height := 12;
      vSoundplayer.Player.Loop_State.Position.X := (vSoundplayer.Player.Loop.Position.X) +
        ((vSoundplayer.Player.Loop.Width / 2) - 8);
      vSoundplayer.Player.Loop_State.Position.Y := (vSoundplayer.Player.Loop.Position.Y) +
        ((vSoundplayer.Player.Loop.Height / 2) - 6);
      vSoundplayer.Player.Loop_State.Bitmap.LoadFromFile(addons.soundplayer.Path.Images + 'sp_loop_inf.png');
      vSoundplayer.Player.Loop_To.Bitmap.LoadFromFile(addons.soundplayer.Path.Images + 'sp_loop_list.png');
      vSoundplayer.Player.Loop_To.Visible := True;
    end;
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////
// Song Position Trackbar
procedure uSoundplayer_Player_Actions_UpdateSongPosition(Sender: TObject; mValue: single; vKeep: Boolean);
var
  vPer_Song: single;
  vCurrent_Position_Song: single;
  sCT, sFT: Real;
begin
  sFT := trunc(BASS_ChannelBytes2Seconds(sound.str_music[1], BASS_ChannelGetLength(sound.str_music[1],
    BASS_POS_BYTE)));
  vCurrent_Position_Song := (sFT * mValue) / 1000;
  vSoundplayer.Player.Song_PlayTime.Text := FormatDateTime('hh:mm:ss',
    uWindows_ConvertSecondsFromTime(vCurrent_Position_Song));
  if vKeep then
  begin
    BASS_ChannelSetPosition(sound.str_music[1], BASS_ChannelSeconds2Bytes(sound.str_music[1],
      vCurrent_Position_Song), BASS_POS_BYTE);
    addons.soundplayer.Player.Thumb_Active := False;
  end;
end;

///
procedure AddSongs_In_m3u(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string; mSongNum: SmallInt);
var
  vss: string;
  vSongTime: string;
  vTag: Tstringlist;
  song_seconds: Real;
begin
  sound.str_music[2] := BASS_StreamCreateFile(False, PChar(mTrackPath + mTrackName), 0, 0, BASS_SAMPLE_FLOAT
{$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
  BASS_ChannelFlags(sound.str_music[2], BASS_MUSIC_POSRESET, 0);
  song_seconds := trunc(BASS_ChannelBytes2Seconds(sound.str_music[2],
    BASS_ChannelGetLength(sound.str_music[2], BASS_POS_BYTE)));
  vss := FloatToStr(song_seconds);
  vSongTime := FormatDateTime('hh:mm:ss', uWindows_ConvertSecondsFromTime(song_seconds));
  addons.soundplayer.Playlist.List.Playlist.Add('#EXTINF:' + vss + ',' + mTrackName);
  addons.soundplayer.Playlist.List.Playlist.Add(mTrackPath + mTrackName);
  addons.soundplayer.Playlist.List.Playlist.SaveToFile(addons.soundplayer.Path.Playlists +
    addons.soundplayer.Playlist.List.Name + '.m3u');
  addons.soundplayer.Playlist.List.Songs.Add(mTrackPath + mTrackName);
  uSoundPlayer_GetTag_Details(mTrackPath + mTrackName, addons.soundplayer.Playlist.Active, mSongNum,
    vSongTime);
  BASS_StreamFree(sound.str_music[2]);
end;

procedure AddSongs_In_pls(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string);
begin

end;

procedure AddSongs_In_asx(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string);
begin

end;

procedure AddSongs_In_xspf(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string);
begin

end;

procedure AddSongs_In_wpl(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string);
begin

end;

procedure AddSongs_In_expl(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string);
begin

end;

procedure uSoundPlayer_Player_Actions_AddNewSongs;
var
  vSongList: Tstringlist;
  vi: SmallInt;
  vSongsInPlaylist: SmallInt;
  vPlaylistName: string;
  vPlaylistNum: SmallInt;
  vPlaylistType: string;
  vPlaylistPlayingSong: SmallInt;
  vPlaylistRowsCount: SmallInt;
  vSongNum: SmallInt;
begin
  if vSoundplayer.scene.OpenDialog.FileName <> '' then
  begin
    // Needed data for playlist
    vPlaylistName := addons.soundplayer.Playlist.List.Name;
    if vPlaylistName = '' then
    begin
      vPlaylistName := 'temp';
      vPlaylistNum := 0;
      vPlaylistType := '.m3u';
      vSongsInPlaylist := 0;
      vPlaylistPlayingSong := 0;
    end
    else
    begin
      vPlaylistNum := addons.soundplayer.Playlist.Active;
      vPlaylistPlayingSong := addons.soundplayer.Player.LastPlayed;
      vSongsInPlaylist := addons.soundplayer.Ini.Ini.ReadInteger('Playlists', 'PL_' + IntToStr(vPlaylistNum) +
        '_Songs', vSongsInPlaylist);
      vPlaylistType := addons.soundplayer.Ini.Ini.ReadString('Playlists', 'PL_' + IntToStr(vPlaylistNum) +
        '_Type', vPlaylistType);
    end;
    // Add list of songs in stringlist
    vSongList := Tstringlist.Create;
    vSongList.AddStrings(vSoundplayer.scene.OpenDialog.Files);
    // Add rows in stringgrid
    if vSoundplayer.Playlist.List.Cells[0, 0] = '' then
      vSoundplayer.Playlist.List.RowCount := vSongList.Count
    else
      vSoundplayer.Playlist.List.RowCount := vSoundplayer.Playlist.List.RowCount + vSongList.Count;
    // Add songs in Playlist and Stringgrid
    if vPlaylistName = 'temp' then
    begin
      uSoundPlayer_Playlist_Create_NewPlaylist(vPlaylistName, vPlaylistType);
    end;
    addons.soundplayer.Playlist.List.Playlist.LoadFromFile(addons.soundplayer.Path.Playlists +
      addons.soundplayer.Playlist.List.Name + vPlaylistType);
    addons.soundplayer.Playlist.List.Songs := Tstringlist.Create;
    for vi := 0 to vSongList.Count - 1 do
    begin
      vSongNum := vSongsInPlaylist + vi;
      if vPlaylistType = '.m3u' then
        AddSongs_In_m3u(vPlaylistNum, ExtractFileName(vSongList.Strings[vi]),
          ExtractFilePath(vSongList.Strings[vi]), vSongNum)
        // AddSongs_In_pls
      else if vPlaylistType = 'pls' then
        // AddSongs_In_asx
      else if vPlaylistType = 'asx' then
        // AddSongs_In_xspf
      else if vPlaylistType = 'xspf' then
        // AddSongs_In_wpl
      else if vPlaylistType = 'wpl' then
        // AddSongs_In_expl;
      else if vPlaylistType = 'expl' then
      begin

      end;
      vSoundplayer.Playlist.List.Cells[0, vSongNum] := IntToStr(vSongNum + 1);
      vSoundplayer.Playlist.List.Cells[1, vSongNum] := '3';
      vSoundplayer.Playlist.List.Cells[2, vSongNum] := addons.soundplayer.Playlist.List.Song_Info
        [vSongNum].Title;
      vSoundplayer.Playlist.List.Cells[3, vSongNum] := addons.soundplayer.Playlist.List.Song_Info
        [vSongNum].Artist;
      vSoundplayer.Playlist.List.Cells[4, vSongNum] := addons.soundplayer.Playlist.List.Song_Info[vSongNum]
        .Track_Seconds;
      if addons.soundplayer.Playlist.List.Song_Info[vSongNum].Disk_Type = '.mp3' then
        vSoundplayer.Playlist.List.Cells[5, vSongNum] := '7'
      else
        vSoundplayer.Playlist.List.Cells[5, vSongNum] := '8'
    end;
    // update playlist config ini
    addons.soundplayer.Ini.Ini.WriteInteger('Playlists', 'PL_' + IntToStr(vPlaylistNum) + '_Songs',
      (vSongsInPlaylist + vSongList.Count));
    // update playlist array
    addons.soundplayer.Playlist.List.Songs_Num := vSongsInPlaylist + vSongList.Count;
    // update soundplayer face vars
    if vPlaylistPlayingSong <> -1 then
      addons.soundplayer.Player.Playing_Now := 0;
    vSoundplayer.info.Total_Songs.Text := IntToStr(addons.soundplayer.Player.Playing_Now) + '/' +
      IntToStr(addons.soundplayer.Playlist.List.Songs_Num);
    // Select the first song if playlist was empty and get tag details
    if vSongsInPlaylist = 0 then
    begin
      vSoundplayer.Playlist.List.Cells[1, 0] := '2';
      vSoundplayer.Playlist.List.SelectRow(0);
      uSoundPlayer_PAction_ShowTagDetails(0);
      sound.str_music[1] := BASS_StreamCreateFile(False, PChar(vSongList.Strings[0]), 0, 0, BASS_SAMPLE_FLOAT
{$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
      addons.soundplayer.Player.Stop := True;
      addons.soundplayer.Player.LastPlayed := 0;
      addons.soundplayer.Player.Playing_Now := addons.soundplayer.Player.LastPlayed;
    end;
    FreeAndNil(vSongList);
    vSoundplayer.Player.Song_Tag.Visible := True;

    vSoundplayer.Player.Play_Grey.Enabled := False;
    vSoundplayer.Player.Stop_Grey.Enabled := False;
    if addons.soundplayer.Player.Playing_Now > 1 then
      vSoundplayer.Player.Previous_Grey.Enabled := False
    else
      vSoundplayer.Player.Previous_Grey.Enabled := True;
    if addons.soundplayer.Playlist.List.Songs_Num > 1 then
      vSoundplayer.Player.Next_Grey.Enabled := False
    else
      vSoundplayer.Player.Next_Grey.Enabled := True;

    vSoundplayer.Player.Loop_Grey.Enabled := False;
    if addons.soundplayer.Playlist.List.Songs_Num > 1 then
      vSoundplayer.Player.Suffle_Grey.Enabled := False
    else
      vSoundplayer.Player.Suffle_Grey.Enabled := True;

    vSoundplayer.info.Back_Left_Ani.Enabled := True;
    vSoundplayer.info.Back_Left.Position.X := 2;
    vSoundplayer.info.Back_Right_Ani.Enabled := True;
    vSoundplayer.info.Back_Right.Position.X := vSoundplayer.scene.Back_Info.Width - 602;
  end;
end;

procedure uSoundPlayer_PAction_ShowTagDetails(mSongNum: SmallInt);
var
  vSong: string;
  vi: Integer;
begin
  vSoundplayer.Player.Song_Title.Text := '"' + addons.soundplayer.Playlist.List.Song_Info[mSongNum].Title +
    '" by "' + addons.soundplayer.Playlist.List.Song_Info[mSongNum].Artist + '"';
  if uTText_TextToPixels(vSoundplayer.Player.Song_Title) < 990 then
  begin
    vSoundplayer.Player.Song_Title_Ani.Stop;
    addons.soundplayer.Player.Title_Ani := False;
    vSoundplayer.Player.Song_Title.Position.X := extrafe.res.Half_Width - 800;
    vSoundplayer.Player.Song_Title.TextSettings.HorzAlign := TTextAlign.Center;
  end
  else
  begin
    vSoundplayer.Player.Song_Title.Position.X := 465;
    vSoundplayer.Player.Song_Title.TextSettings.HorzAlign := TTextAlign.Leading;
    addons.soundplayer.Player.Title_Ani := True;
    uSoundplayer_Player_Actions_Title_Animation;
  end;
  vSoundplayer.info.Song_Title.Text := addons.soundplayer.Playlist.List.Song_Info[mSongNum].Title;
  if uTText_TextToPixels(vSoundplayer.info.Song_Title) > 422 then
    vSoundplayer.info.Song_Title.Text := uTText_SetTextInGivenPixels(422, vSoundplayer.info.Song_Title);
  vSoundplayer.info.Artist_Name.Text := addons.soundplayer.Playlist.List.Song_Info[mSongNum].Artist;
  vSoundplayer.info.Year_Publish.Text := addons.soundplayer.Playlist.List.Song_Info[mSongNum].Year;
  vSoundplayer.info.Gerne_Kind.Text := addons.soundplayer.Playlist.List.Song_Info[mSongNum].Genre;
  vSoundplayer.info.Track_Num.Text := addons.soundplayer.Playlist.List.Song_Info[mSongNum].Track;
  vSoundplayer.Player.Song_Time.Text := addons.soundplayer.Playlist.List.Song_Info[mSongNum].Track_Seconds;

  if addons.soundplayer.Playlist.List.Song_Info[addons.soundplayer.Player.Playing_Now].Disk_Type = '.mp3' then
  begin
    for vi := 0 to 4 do
    begin
      vSoundplayer.Player.Rate[vi].Visible := True;
      vSoundplayer.Player.Rate_No.Visible := True;
    end;
    vSoundplayer.Player.Rate_No.Visible := True;
    if addons.soundplayer.Playlist.List.Song_Info[mSongNum].Rate <> '-1' then
    begin
      for vi := 0 to 4 do
        vSoundplayer.Player.Rate[vi].Visible := True;
      for vi := 0 to 4 do
        vSoundplayer.Player.Rate_Gray[vi].Enabled := True;
      for vi := 0 to addons.soundplayer.Playlist.List.Song_Info[mSongNum].Rate.ToInteger do
        vSoundplayer.Player.Rate_Gray[vi].Enabled := False;
      vSoundplayer.Player.Rate_No.Visible := False;
    end
    else
    begin
      for vi := 0 to 4 do
        vSoundplayer.Player.Rate[vi].Visible := False;
      vSoundplayer.Player.Rate_No.Visible := True;
    end;
  end
  else if addons.soundplayer.Playlist.List.Song_Info[addons.soundplayer.Player.Playing_Now].Disk_Type = '.ogg'
  then
  begin
    for vi := 0 to 4 do
    begin
      vSoundplayer.Player.Rate[vi].Visible := False;
      vSoundplayer.Player.Rate_No.Visible := False;
    end;
    vSoundplayer.Player.Rate_No.Visible := False;
  end;

  if addons.soundplayer.Playlist.List.Song_Info[addons.soundplayer.Player.Playing_Now].Disk_Type = '.mp3' then
    GetTags_MP3_Cover(mSongNum)
  else if addons.soundplayer.Playlist.List.Song_Info[addons.soundplayer.Player.Playing_Now].Disk_Type = '.ogg'
  then
    GetTags_OGG_Cover(mSongNum);
  vSong := addons.soundplayer.Playlist.List.Songs.Strings[mSongNum];
end;

/// /////////////////////////////////////////////////////////////////////////////
procedure uSoundPlayer_Player_Actions_ShowTag(vSongName: String; vSongNum: Integer);
begin
  if extrafe.prog.State = 'addon_soundplayer' then
  begin
    vSoundplayer.info.Back_Left_Ani.Stop;
    vSoundplayer.info.Back_Left.Position.X := -558;
    vSoundplayer.info.Back_Right_Ani.Stop;
    vSoundplayer.info.Back_Right.Position.X := vSoundplayer.scene.Back_Info.Width - 42;
    vSoundplayer.scene.Back_Blur.Enabled := True;

    if addons.soundplayer.Playlist.List.Song_Info[vSongNum].Disk_Type = '.mp3' then
    begin
      uSoundplayer_TagSet_Mp3;
      uSoundplayer_Tag_Mp3_GetMP3(vSongName, vSongNum);
    end
    else if addons.soundplayer.Playlist.List.Song_Info[vSongNum].Disk_Type = '.ogg' then
    begin
      uSoundplayer_TagSet_Opus;
      uSoundplayer_Tag_Ogg_GetOgg(vSongName);
    end;
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////
procedure uSoundPlayer_Player_Actions_OnOver(vImage: TImage; vGlow: TGlowEffect);
begin
  if vImage.Name = 'A_SP_Player_Play_Image' then
  begin
    if addons.soundplayer.Player.Play then
      vSoundplayer.Player.Play.Bitmap.LoadFromFile(addons.soundplayer.Path.Images + 'sp_pause.png')
    else
      vSoundplayer.Player.Play.Bitmap.LoadFromFile(addons.soundplayer.Path.Images + 'sp_play.png');
  end;
  vImage.Scale.X := 1.1;
  vImage.Scale.Y := 1.1;
  vImage.Position.X := vImage.Position.X - ((vImage.Width * 0.1) / 2);
  vImage.Position.Y := vImage.Position.Y - ((vImage.Height * 0.1) / 2);
  vGlow.Enabled := True;
end;

procedure uSoundPlayer_Player_Actions_OnLeave(vImage: TImage; vGlow: TGlowEffect);
begin
  if vImage.Name = 'A_SP_Player_Play_Image' then
  begin
    if addons.soundplayer.Player.Play then
      vSoundplayer.Player.Play.Bitmap.LoadFromFile(addons.soundplayer.Path.Images + 'sp_play.png')
    else
    begin
      if addons.soundplayer.Player.Stop and addons.soundplayer.Player.Pause = False then
        vSoundplayer.Player.Play.Bitmap.LoadFromFile(addons.soundplayer.Path.Images + 'sp_play.png')
      else
        vSoundplayer.Player.Play.Bitmap.LoadFromFile(addons.soundplayer.Path.Images + 'sp_pause.png');
    end;
  end;
  vImage.Scale.X := 1;
  vImage.Scale.Y := 1;
  vImage.Position.X := vImage.Position.X + ((vImage.Width * 0.1) / 2);
  vImage.Position.Y := vImage.Position.Y + ((vImage.Height * 0.1) / 2);
  vGlow.Enabled := False;
end;

procedure uSoundplayer_Player_Actions_UpdateLastPlayedSong(vNum: Integer);
begin
  addons.soundplayer.Player.LastPlayed := vNum;
  addons.soundplayer.Ini.Ini.WriteInteger('Song', 'LastPlayed', vNum);
end;

procedure uSoundplayer_Player_Actions_Title_Animation;
begin
  if addons.soundplayer.Player.Title_Ani then
  begin
    if addons.soundplayer.Player.Title_Ani_Left = False then
    begin
      vSoundplayer.Player.Song_Title_Ani.StartValue := 465;
      vSoundplayer.Player.Song_Title_Ani.StopValue :=
        465 - ((uTText_TextToPixels(vSoundplayer.Player.Song_Title) + 5) - 1000);
    end
    else if addons.soundplayer.Player.Title_Ani_Left then
    begin
      vSoundplayer.Player.Song_Title_Ani.StartValue := vSoundplayer.Player.Song_Title_Ani.StopValue;
      vSoundplayer.Player.Song_Title_Ani.StopValue := 465;
    end;
    vSoundplayer.Player.Song_Title_Ani.Start;
  end;
end;

end.
