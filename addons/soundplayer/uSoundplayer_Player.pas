unit uSoundplayer_Player;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UITypes,
  FMX.Types,
  FMX.Objects,
  FMX.Effects,
  FMX.Graphics,
  FMX.Grid,
  FMX.Memo,
  bass;

procedure State(vPlay, vPause, vStop, vMute, vSuffle: Boolean; vRepeat: String);
procedure Set_Play(vPlay, vPause, vStop, vMute: Boolean);

procedure Refresh;
procedure Refresh_GoTo(vGo: Integer);

procedure Text_OnOver(vText: TText; vGlow: TGlowEffect);
procedure Text_OnLeave(vText: TText; vGlow: TGlowEffect);

procedure StartOrPause;
procedure Stop;
procedure Previous;
procedure Next;
procedure Set_Previous_Next;

procedure Repeat_Set(vCurrent: String);
procedure Repeat_Inc_LoopState;
procedure Repeat_Back(vRepeat: String);

procedure Suffle;
procedure Suffle_GoTo;
procedure Suffle_Create_List;
procedure Suffle_Back;

procedure Band_Info;
procedure Band_Info_Close;
procedure Lyrics;
procedure Lyrics_Close;
procedure Album;
procedure Album_Close;

procedure Show_Tag(vSongName: String; vSongNum: Integer);

procedure Title_Animation;
procedure Get_Tag(vSongNum: SmallInt);

// Song position
procedure Update_Thumb_Pos(Sender: TObject; vValue: Single; vKeep: Boolean);

// Add new songs
procedure Add_Songs;

// Add songs in playlist based types
procedure Add_Songs_m3u(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string; mSongNum: SmallInt);
procedure Add_Songs_pls(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string);
procedure Add_Songs_asx(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string);
procedure Add_Songs_xspf(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string);
procedure Add_Songs_wpl(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string);
procedure Add_Songs_expl(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string);

// Update last played song from the current playlist
procedure Update_Last_Song(vNum: Integer);

implementation

uses
  main,
  uLoad_AllTypes,
  uSnippet_Text,
  uInternet_Files,
  uWindows,
  uSnippet_Convert,
  uSoundplayer_Actions,
  uSoundplayer_AllTypes,
  uSoundplayer_SetAll,
  uSoundplayer_Playlist,
  uSoundplayer_Scrapers_LastFm,
  uSoundplayer_Playlist_Create,
  uSoundplayer_Tag_Get,
  uSoundplayer_Tag_Mp3_SetAll,
  uSoundplayer_Tag_Mp3,
  uSoundplayer_Tag_Ogg_SetAll,
  uSoundplayer_Tag_Ogg;

procedure State(vPlay, vPause, vStop, vMute, vSuffle: Boolean; vRepeat: String);
begin

  Set_Play(vPlay, vPause, vStop, vMute);
  Set_Previous_Next;

  if addons.soundplayer.Playlist.List.Songs_Num <= 0 then
  begin
    vSoundplayer.Player.Loop.TextSettings.FontColor := TAlphaColorRec.Grey;
    vSoundplayer.Player.Suffle.TextSettings.FontColor := TAlphaColorRec.Grey;
    vSoundplayer.Player.Equalizer.TextSettings.FontColor := TAlphaColorRec.Grey;
    vSoundplayer.Player.Lyrics.TextSettings.FontColor := TAlphaColorRec.Grey;
  end;
  if addons.soundplayer.Playlist.List.Songs_Num > 0 then
  begin
    Repeat_Back(vRepeat);
    if soundplayer.player_actions.VRepeat_Num = -1 then
    begin
      soundplayer.player_actions.Suffle := not vSuffle;
      Suffle;
    end;
  end;
  soundplayer.player_actions.Time_Negative := soundplayer.player_actions.Time_Negative;
end;

procedure Set_Play(vPlay, vPause, vStop, vMute: Boolean);
begin
  if addons.soundplayer.Playlist.List.Songs_Num <= 0 then
  begin
    vSoundplayer.Player.Stop.TextSettings.FontColor := TAlphaColorRec.Grey;
    vSoundplayer.Player.Play.TextSettings.FontColor := TAlphaColorRec.Grey;
  end
  else
  begin
    if soundplayer.Player = sStop then
    begin
      vSoundplayer.Player.Stop.TextSettings.FontColor := TAlphaColorRec.Red;
      vSoundplayer.Player.Play.Text := #$ea1c;
      vSoundplayer.Player.Play.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      vSoundplayer.Player.Play_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
      vSoundplayer.Playlist.List.Cells[1, soundplayer.player_actions.Playing_Now] := '2';
    end
    else
    begin
      if soundplayer.Player = sPlay then
      begin
        vSoundplayer.Player.Play.Text := #$ea1c;
        vSoundplayer.Player.Play.TextSettings.FontColor := TAlphaColorRec.Blueviolet;
        vSoundplayer.Player.Play_Glow.GlowColor := TAlphaColorRec.Blueviolet;
        vSoundplayer.Player.Stop.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
        vSoundplayer.Playlist.List.Cells[1, soundplayer.player_actions.Playing_Now] := '0';
      end
      else if soundplayer.Player = sPause then
      begin
        vSoundplayer.Player.Play.Text := #$ea1d;
        vSoundplayer.Player.Play.TextSettings.FontColor := TAlphaColorRec.Greenyellow;
        vSoundplayer.Player.Play_Glow.GlowColor := TAlphaColorRec.Greenyellow;
        vSoundplayer.Player.Stop.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
        vSoundplayer.Playlist.List.Cells[1, soundplayer.player_actions.Playing_Now] := '1';
      end
      else
      begin
        vSoundplayer.Player.Stop.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
        vSoundplayer.Player.Play.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      end;
    end;
  end;
end;

/// /////////////////////////////////////////////

procedure Refresh;
var
  sCT, sFT: Real;
  vRand: Integer;
  vRand_Str: String;
  viPos: Integer;
  vi: Integer;
begin
  if soundplayer.Player = sPlay then
  begin
    sCT := trunc(BASS_ChannelBytes2Seconds(sound.str_music[1], BASS_ChannelGetPosition(sound.str_music[1], BASS_POS_BYTE)));
    sFT := trunc(BASS_ChannelBytes2Seconds(sound.str_music[1], BASS_ChannelGetLength(sound.str_music[1], BASS_POS_BYTE)));

    viPos := Pos('addon_soundplayer', extrafe.prog.State);

    if viPos <> 0 then
      if soundplayer.player_actions.Thumb_Active = False then
      begin
        if soundplayer.player_actions.Time_Negative = False then
          vSoundplayer.Player.Song_PlayTime.Text := FormatDateTime('hh:mm:ss', uSnippet_Convert.Seconds_To_Time(sCT))
        else
          vSoundplayer.Player.Song_PlayTime.Text := '-' + FormatDateTime('hh:mm:ss', uSnippet_Convert.Seconds_To_Time(sFT - sCT));
        vSoundplayer.Player.Song_Pos.Value := (sCT * 1000 / sFT);
        soundplayer.player_actions.Song_State := vSoundplayer.Player.Song_Pos.Value;
      end;

    if BASS_ChannelGetPosition(sound.str_music[1], BASS_POS_BYTE) >= BASS_ChannelGetLength(sound.str_music[1], BASS_POS_BYTE) then
    begin
      if (soundplayer.player_actions.VRepeat = '') and (soundplayer.player_actions.Suffle = False) then
      begin
        if soundplayer.player_actions.HasNext_Track then
          uSoundplayer_Player.Next
        else
          Refresh_GoTo(0);
      end
      else if (soundplayer.player_actions.VRepeat = '') and (soundplayer.player_actions.Suffle) then
        Suffle_GoTo
      else if (soundplayer.player_actions.VRepeat <> '') and (soundplayer.player_actions.Suffle) then
      begin
        if soundplayer.player_actions.VRepeat = 'List_1' then
        begin
          if soundplayer.player_actions.Suffle_List.Count = 1 then
          begin
            if soundplayer.player_actions.VRepeat_Num = 1 then
              soundplayer.player_actions.VRepeat_Num := -1
            else
              Dec(soundplayer.player_actions.VRepeat_Num, 1);
          end;
          Suffle_GoTo;
        end
        else if soundplayer.player_actions.VRepeat = 'List_Inf' then
          Suffle_GoTo;
      end
      else if soundplayer.player_actions.VRepeat <> '' then
      begin
        if soundplayer.player_actions.VRepeat = 'Song_1' then
        begin
          if soundplayer.player_actions.VRepeat_Num = 1 then
            Repeat_Set('List_Inf')
          else
          begin
            Dec(soundplayer.player_actions.VRepeat_Num, 1);
            vSoundplayer.Player.Loop_State.Text := soundplayer.player_actions.VRepeat_Num.ToString;
          end;
          Refresh_GoTo(soundplayer.player_actions.Playing_Now);
        end
        else if soundplayer.player_actions.VRepeat = 'Song_Inf' then
          Refresh_GoTo(soundplayer.player_actions.Playing_Now)
        else if soundplayer.player_actions.VRepeat = 'List_1' then
        begin
          vSoundplayer.Playlist.List.Cells[1, soundplayer.player_actions.Playing_Now] := '3';
          if soundplayer.player_actions.VRepeat_Songs_Num = 0 then
          begin
            if soundplayer.player_actions.VRepeat_Num = 1 then
              Repeat_Set('List_Inf')
            else
            begin
              Dec(soundplayer.player_actions.VRepeat_Num, 1);
              vSoundplayer.Player.Loop_State.Text := soundplayer.player_actions.VRepeat_Num.ToString;
              soundplayer.player_actions.VRepeat_Songs_Num := addons.soundplayer.Playlist.List.Songs_Num - 1;
            end;
            soundplayer.player_actions.Playing_Now := 0;
          end
          else
          begin
            Inc(soundplayer.player_actions.Playing_Now, 1);
            Dec(soundplayer.player_actions.VRepeat_Songs_Num, 1);
          end;
          Refresh_GoTo(soundplayer.player_actions.Playing_Now);
        end
        else if soundplayer.player_actions.VRepeat = 'List_Inf' then
        begin
          vSoundplayer.Playlist.List.Cells[1, soundplayer.player_actions.Playing_Now] := '3';
          if soundplayer.player_actions.Playing_Now = addons.soundplayer.Playlist.List.Songs_Num - 1 then
            soundplayer.player_actions.Playing_Now := 0
          else
            Inc(soundplayer.player_actions.Playing_Now, 1);
          Refresh_GoTo(soundplayer.player_actions.Playing_Now);
        end;
      end;
    end;
  end;
end;

procedure Set_Previous_Next;
begin
  if addons.soundplayer.Playlist.List.Songs_Num <= 0 then
  begin
    vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Grey;
    vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Grey;
  end
  else
  begin
    if (soundplayer.player_actions.Playing_Now = 0) and (addons.soundplayer.Playlist.List.Songs_Num = 0) then
    begin
      soundplayer.player_actions.HasPrevious_Track := False;
      vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Grey;
      soundplayer.player_actions.HasNext_Track := False;
      vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Grey;
      if addons.soundplayer.Playlist.Edit then
      begin
        vSoundplayer.Playlist.Songs_Edit.Down.TextSettings.FontColor := TAlphaColorRec.Grey;
        vSoundplayer.Playlist.Songs_Edit.Up.TextSettings.FontColor := TAlphaColorRec.Grey;
      end;
    end
    else if (soundplayer.player_actions.Playing_Now + 1 < addons.soundplayer.Playlist.List.Songs_Num) and (soundplayer.player_actions.Playing_Now <> 0) then
    begin
      soundplayer.player_actions.HasPrevious_Track := True;
      vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      soundplayer.player_actions.HasNext_Track := True;
      vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      if addons.soundplayer.Playlist.Edit then
      begin
        vSoundplayer.Playlist.Songs_Edit.Down.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
        vSoundplayer.Playlist.Songs_Edit.Up.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      end;
    end
    else if soundplayer.player_actions.Playing_Now = 0 then
    begin
      soundplayer.player_actions.HasPrevious_Track := False;
      vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Grey;
      soundplayer.player_actions.HasNext_Track := True;
      vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      if addons.soundplayer.Playlist.Edit then
      begin
        vSoundplayer.Playlist.Songs_Edit.Down.TextSettings.FontColor := TAlphaColorRec.Grey;
        vSoundplayer.Playlist.Songs_Edit.Up.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      end;
    end
    else
    begin
      soundplayer.player_actions.HasPrevious_Track := True;
      vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      soundplayer.player_actions.HasNext_Track := False;
      vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Grey;
      if addons.soundplayer.Playlist.Edit then
      begin
        vSoundplayer.Playlist.Songs_Edit.Down.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
        vSoundplayer.Playlist.Songs_Edit.Up.TextSettings.FontColor := TAlphaColorRec.Grey;
      end;
    end;
  end;
end;

procedure Refresh_GoTo(vGo: Integer);
begin
  if extrafe.prog.State = 'addon_soundplayer' then
    vSoundplayer.Playlist.List.Cells[1, soundplayer.player_actions.Playing_Now] := '3';
  Update_Last_Song(soundplayer.player_actions.Playing_Now);
  soundplayer.player_actions.LastPlayed := vGo;
  soundplayer.player_actions.Playing_Now := vGo;
  if extrafe.prog.State = 'addon_soundplayer' then
  begin
    vSoundplayer.Playlist.List.Selected := soundplayer.player_actions.Playing_Now;
    uSoundplayer_Player.Get_Tag(soundplayer.player_actions.Playing_Now);
    uSoundplayer_Tag_Get.Set_Icon;
    vSoundplayer.Playlist.List.Cells[1, soundplayer.player_actions.Playing_Now] := '0';
  end;
  BASS_StreamFree(sound.str_music[1]);
  sound.str_music[1] := BASS_StreamCreateFile(False, PChar(addons.soundplayer.Playlist.List.Songs.Strings[soundplayer.player_actions.Playing_Now]), 0, 0,
    BASS_SAMPLE_FLOAT {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
  BASS_ChannelSetPosition(sound.str_music[1], 0, 0);
  BASS_ChannelSetAttribute(sound.str_music[1], BASS_ATTRIB_VOL, soundplayer.player_actions.volume.Vol / 100);
  if soundplayer.Player = sPlay then
    BASS_ChannelPlay(sound.str_music[1], False)
  else
  begin
    vSoundplayer.Player.Song_PlayTime.Text := '00:00:00';
    soundplayer.player_actions.Time_Negative := False;
    vSoundplayer.Player.Play.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    vSoundplayer.Player.Play_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  end;
  if extrafe.prog.State = 'addon_soundplayer' then
  begin
    vSoundplayer.Player.Song_Pos.Value := 0;
    soundplayer.player_actions.Song_State := vSoundplayer.Player.Song_Pos.Value;
  end;
  if soundplayer.player_actions.Suffle then
  begin

  end
  else
  begin
    if ((soundplayer.player_actions.VRepeat <> 'Song_1') and (soundplayer.player_actions.VRepeat <> 'Song_Inf')) then
      Set_Previous_Next;
  end;
end;

// Click actions
procedure StartOrPause;
begin
  if soundplayer.Player = sPause then
  begin
    if soundplayer.Player = sPause then
      BASS_ChannelPlay(sound.str_music[1], False)
    else
    begin
      Refresh_GoTo(soundplayer.player_actions.Playing_Now);
      vSoundplayer.Playlist.List.Cells[1, soundplayer.player_actions.Playing_Now] := '0';
    end;
    vSoundplayer.Player.Play.TextSettings.FontColor := TAlphaColorRec.Blueviolet;
    vSoundplayer.Player.Play_Glow.GlowColor := TAlphaColorRec.Blueviolet;
    vSoundplayer.Player.Stop.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    vSoundplayer.Player.Stop_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
    soundplayer.Player := sPlay;
    vSoundplayer.timer.Song.Enabled := True;
    uSoundplayer_Player.Update_Last_Song(soundplayer.player_actions.Playing_Now);
  end
  else
  begin
    BASS_ChannelPause(sound.str_music[1]);
    vSoundplayer.Player.Play.Text := #$ea1d;
    vSoundplayer.Player.Play.TextSettings.FontColor := TAlphaColorRec.Greenyellow;
    vSoundplayer.Player.Play_Glow.GlowColor := TAlphaColorRec.Greenyellow;
    vSoundplayer.Player.Stop.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    vSoundplayer.Player.Stop_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
    soundplayer.Player := sPause;
    vSoundplayer.Playlist.List.Cells[1, soundplayer.player_actions.Playing_Now] := '2';
    vSoundplayer.timer.Song.Enabled := True;
  end;
end;

procedure Stop;
begin
  if vSoundplayer.Player.Stop.TextSettings.FontColor = TAlphaColorRec.Deepskyblue then
  begin
    if sound.str_music[1] <> 0 then
      if soundplayer.Player = sPause then
      begin
        BASS_ChannelStop(sound.str_music[1]);
        BASS_ChannelSetPosition(sound.str_music[1], 0, 0);
        vSoundplayer.Player.Song_Pos.Value := 0;
        vSoundplayer.Player.Stop.TextSettings.FontColor := TAlphaColorRec.Red;
        vSoundplayer.Player.Play.Text := #$ea1c;
        vSoundplayer.Player.Play.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
        vSoundplayer.Player.Play_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
        soundplayer.player := sStop;
        uSoundplayer_Player.Text_OnLeave(vSoundplayer.Player.Stop, vSoundplayer.Player.Stop_Glow);
        vSoundplayer.Playlist.List.Cells[1, soundplayer.player_actions.Playing_Now] := '1';
      end;
  end;
end;

procedure Previous;
begin
  if vSoundplayer.Player.Previous.TextSettings.FontColor = TAlphaColorRec.Deepskyblue then
  begin
    if (soundplayer.player_actions.Suffle = False) and ((soundplayer.player_actions.VRepeat = '') or (soundplayer.player_actions.VRepeat = 'List_1') or
      (soundplayer.player_actions.VRepeat = 'List_Inf')) then
    begin
      if sound.str_music[1] <> 0 then
        if soundplayer.player_actions.Playing_Now > 0 then
        begin
          Refresh_GoTo(soundplayer.player_actions.Playing_Now - 1);
          if extrafe.prog.State = 'addon_soundplayer' then
          begin
            if soundplayer.player_actions.Playing_Now = 0 then
              uSoundplayer_Player.Text_OnLeave(vSoundplayer.Player.Previous, vSoundplayer.Player.Previous_Glow);
            vSoundplayer.info.Total_Songs.Text := IntToStr(soundplayer.player_actions.Playing_Now + 1) + '/' +
              addons.soundplayer.Playlist.List.Songs_Num.ToString;
            uSoundplayer_Actions.Set_Animations;
          end;
        end;
    end
    else if (soundplayer.player_actions.Suffle) then
    begin
      Suffle_GoTo;
      if soundplayer.player_actions.Suffle_List.Count = 1 then
        uSoundplayer_Player.Text_OnLeave(vSoundplayer.Player.Previous, vSoundplayer.Player.Previous_Glow);
    end;
  end;
end;

procedure Next;
begin
  if vSoundplayer.Player.Next.TextSettings.FontColor = TAlphaColorRec.Deepskyblue then
  begin
    if (soundplayer.player_actions.Suffle = False) and ((soundplayer.player_actions.VRepeat = '') or (soundplayer.player_actions.VRepeat = 'List_1') or
      (soundplayer.player_actions.VRepeat = 'List_Inf')) then
    begin
      if soundplayer.player_actions.Playing_Now < vSoundplayer.Playlist.List.RowCount - 1 then
      begin
        Refresh_GoTo(soundplayer.player_actions.Playing_Now + 1);
        if extrafe.prog.State = 'addon_soundplayer' then
        begin
          if soundplayer.player_actions.Playing_Now = vSoundplayer.Playlist.List.RowCount - 1 then
            uSoundplayer_Player.Text_OnLeave(vSoundplayer.Player.Next, vSoundplayer.Player.Next_Glow);
          vSoundplayer.info.Total_Songs.Text := IntToStr(soundplayer.player_actions.Playing_Now + 1) + '/' + addons.soundplayer.Playlist.List.Songs_Num.ToString;
          uSoundplayer_Actions.Set_Animations;
        end;
      end;
    end
    else if (soundplayer.player_actions.Suffle) then
    begin
      Suffle_GoTo;
      if soundplayer.player_actions.Suffle_List.Count = 1 then
        uSoundplayer_Player.Text_OnLeave(vSoundplayer.Player.Next, vSoundplayer.Player.Next_Glow);
    end;
  end
end;

procedure Repeat_Set(vCurrent: String);
begin
  if vSoundplayer.Player.Loop.TextSettings.FontColor <> TAlphaColorRec.Grey then
  begin
    if vCurrent = '' then
      soundplayer.player_actions.VRepeat := 'Song_1'
    else if vCurrent = 'Song_1' then
      soundplayer.player_actions.VRepeat := 'Song_Inf'
    else if vCurrent = 'Song_Inf' then
      soundplayer.player_actions.VRepeat := 'List_1'
    else if vCurrent = 'List_1' then
    begin
      soundplayer.player_actions.VRepeat := 'List_Inf';
      if soundplayer.player_actions.Suffle then
        Suffle;
    end
    else if vCurrent = 'List_Inf' then
    begin
      soundplayer.player_actions.VRepeat := '';
      if soundplayer.player_actions.Suffle then
        Suffle;
    end;

    if soundplayer.player_actions.VRepeat = '' then
    begin
      vSoundplayer.Player.Loop_State.Visible := False;
      vSoundplayer.Player.Loop_To.Visible := False;
      vSoundplayer.Player.Loop.RotationAngle := 360;
      vSoundplayer.Player.Loop.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      vSoundplayer.Player.Loop_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
      soundplayer.player_actions.VRepeat_Num := -1;
      soundplayer.player_actions.VRepeat_Songs_Num := -1;
      if addons.soundplayer.Playlist.List.Songs_Num = soundplayer.player_actions.Playing_Now then
        vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Grey
      else
        vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      if soundplayer.player_actions.Playing_Now = 0 then
        vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Grey
      else
        vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    end
    else if soundplayer.player_actions.VRepeat = 'Song_1' then
    begin
      vSoundplayer.Player.Loop.RotationAngle := -72;
      vSoundplayer.Player.Loop_State.Visible := True;
      if soundplayer.player_actions.VRepeat_Num = -1 then
        soundplayer.player_actions.VRepeat_Num := 1;
      soundplayer.player_actions.VRepeat_Num := soundplayer.player_actions.VRepeat_Num;
      vSoundplayer.Player.Loop_State.Text := soundplayer.player_actions.VRepeat_Num.ToString;
      vSoundplayer.Player.Loop_To.Text := #$e911;
      vSoundplayer.Player.Loop_To.Visible := True;
      vSoundplayer.Player.Loop.TextSettings.FontColor := TAlphaColorRec.Darkturquoise;
      vSoundplayer.Player.Loop_Glow.GlowColor := TAlphaColorRec.Darkturquoise;
      vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Grey;
      vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Grey;
      vSoundplayer.Player.Suffle.TextSettings.FontColor := TAlphaColorRec.Grey;
    end
    else if soundplayer.player_actions.VRepeat = 'Song_Inf' then
    begin
      vSoundplayer.Player.Loop.RotationAngle := -144;
      vSoundplayer.Player.Loop_State.Visible := True;
      vSoundplayer.Player.Loop_State.Text := #$ea2f;
      soundplayer.player_actions.VRepeat_Num := -1;
      vSoundplayer.Player.Loop_To.Text := #$e911;
      vSoundplayer.Player.Loop_To.Visible := True;
      vSoundplayer.Player.Loop.TextSettings.FontColor := TAlphaColorRec.Darkseagreen;
      vSoundplayer.Player.Loop_Glow.GlowColor := TAlphaColorRec.Darkseagreen;
      vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Grey;
      vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Grey;
    end
    else if soundplayer.player_actions.VRepeat = 'List_1' then
    begin
      vSoundplayer.Player.Loop.RotationAngle := -216;
      vSoundplayer.Player.Loop_State.Visible := True;
      if soundplayer.player_actions.VRepeat_Num = -1 then
      begin
        if soundplayer.player_actions.VRepeat_Songs_Num = -1 then
          soundplayer.player_actions.VRepeat_Songs_Num := (addons.soundplayer.Playlist.List.Songs_Num - 1) - soundplayer.player_actions.Playing_Now;
      end;
      soundplayer.player_actions.VRepeat_Songs_Num := soundplayer.player_actions.VRepeat_Songs_Num;
      if soundplayer.player_actions.VRepeat_Num = -1 then
        soundplayer.player_actions.VRepeat_Num := 1;
      soundplayer.player_actions.VRepeat_Num := soundplayer.player_actions.VRepeat_Num;
      vSoundplayer.Player.Loop_State.Text := soundplayer.player_actions.VRepeat_Num.ToString;
      vSoundplayer.Player.Loop_To.Text := #$e9bb;
      vSoundplayer.Player.Loop_To.Visible := True;
      vSoundplayer.Player.Loop.TextSettings.FontColor := TAlphaColorRec.Lightsalmon;
      vSoundplayer.Player.Loop_Glow.GlowColor := TAlphaColorRec.Lightsalmon;
      vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      vSoundplayer.Player.Suffle.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    end
    else if soundplayer.player_actions.VRepeat = 'List_Inf' then
    begin
      vSoundplayer.Player.Loop.RotationAngle := -288;
      vSoundplayer.Player.Loop_State.Visible := True;
      vSoundplayer.Player.Loop_State.Text := #$ea2f;
      soundplayer.player_actions.VRepeat_Num := -1;
      soundplayer.player_actions.VRepeat_Songs_Num := -1;
      vSoundplayer.Player.Loop_To.Text := #$e9bb;
      vSoundplayer.Player.Loop_To.Visible := True;
      vSoundplayer.Player.Loop.TextSettings.FontColor := TAlphaColorRec.Lightpink;
      vSoundplayer.Player.Loop_Glow.GlowColor := TAlphaColorRec.Lightpink;
      vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    end;
  end;
end;

procedure Repeat_Inc_LoopState;
begin
  if soundplayer.player_actions.VRepeat_Num <> -1 then
  begin
    if soundplayer.player_actions.VRepeat_Num = 9 then
      soundplayer.player_actions.VRepeat_Num := 0;
    Inc(soundplayer.player_actions.VRepeat_Num, 1);
    vSoundplayer.Player.Loop_State.Text := soundplayer.player_actions.VRepeat_Num.ToString;
  end;
end;

procedure Repeat_Back(vRepeat: String);
begin
  vSoundplayer.Player.Loop.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  if vRepeat = '' then
    Repeat_Set('List_Inf')
  else if vRepeat = 'Song_1' then
    Repeat_Set('')
  else if vRepeat = 'Song_Inf' then
    Repeat_Set('Song_1')
  else if vRepeat = 'List_1' then
    Repeat_Set('Song_Inf')
  else if vRepeat = 'List_Inf' then
    Repeat_Set('List_1');
  vSoundplayer.Player.Suffle.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
end;
/// //////////////////////////////////////

procedure Suffle;
var
  vi: Integer;
begin
  if (soundplayer.player_actions.VRepeat = 'Song_1') or (soundplayer.player_actions.VRepeat = 'Song_Inf') then
  begin
    vSoundplayer.Player.Suffle.TextSettings.FontColor := TAlphaColorRec.Grey;
    soundplayer.player_actions.Suffle := False;
  end;
  if vSoundplayer.Player.Suffle.TextSettings.FontColor <> TAlphaColorRec.Grey then
  begin
    if soundplayer.player_actions.Suffle then
    begin
      vSoundplayer.Player.Suffle.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      FreeAndNil(soundplayer.player_actions.Suffle_List);
      for vi := 0 to addons.soundplayer.Playlist.List.Songs_Num - 1 do
        vSoundplayer.Playlist.List.Cells[1, vi] := '3';
      vSoundplayer.Playlist.List.Cells[1, soundplayer.player_actions.Playing_Now] := '0';
    end
    else
    begin
      Suffle_Create_List;
      vSoundplayer.Player.Suffle.TextSettings.FontColor := TAlphaColorRec.Limegreen;
      if vSoundplayer.Player.Next.TextSettings.FontColor = TAlphaColorRec.Grey then
        vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      if vSoundplayer.Player.Previous.TextSettings.FontColor = TAlphaColorRec.Grey then
        vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    end;
    soundplayer.player_actions.Suffle := not soundplayer.player_actions.Suffle;
  end;
end;

procedure Suffle_GoTo;
var
  vRand_Str: String;
  vRand: Integer;
  vi: Integer;
begin
  vRand_Str := soundplayer.player_actions.Playing_Now.ToString;
  soundplayer.player_actions.Suffle_List.Delete(soundplayer.player_actions.Suffle_List.IndexOf(vRand_Str));
  if soundplayer.player_actions.Suffle_List.Count > 0 then
  begin
    vRand := Random(soundplayer.player_actions.Suffle_List.Count);
    vRand := soundplayer.player_actions.Suffle_List.Strings[vRand].ToInteger;
    if extrafe.prog.State = 'addon_soundplayer' then
      vSoundplayer.Playlist.List.Cells[1, soundplayer.player_actions.Playing_Now] := '12';
    soundplayer.player_actions.Playing_Now := vRand;
    Refresh_GoTo(soundplayer.player_actions.Playing_Now);
    if soundplayer.player_actions.Suffle_List.Count = 1 then
    begin
      vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Grey;
      vSoundplayer.Player.Next_Glow.Enabled := False;
      vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Grey;
      vSoundplayer.Player.Previous_Glow.Enabled := False;
    end;
  end
  else
  begin
    for vi := 0 to addons.soundplayer.Playlist.List.Songs_Num - 1 do
      vSoundplayer.Playlist.List.Cells[1, vi] := '3';
    if soundplayer.player_actions.VRepeat = 'List_1' then
    begin
      if soundplayer.player_actions.VRepeat_Num = -1 then
      begin
        Repeat_Set('List_Inf');
        Suffle;
        Set_Previous_Next;
      end
      else
      begin
        vSoundplayer.Player.Loop_State.Text := soundplayer.player_actions.VRepeat_Num.ToString;
        Suffle_Create_List;
        vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
        vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      end;
    end
    else if soundplayer.player_actions.VRepeat = 'List_Inf' then
    begin
      Suffle_Create_List;
      vSoundplayer.Player.Next.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      vSoundplayer.Player.Previous.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    end
    else
      Suffle;
    Refresh_GoTo(0);
  end;
end;

procedure Suffle_Create_List;
var
  vi: Integer;
begin
  if Assigned(soundplayer.player_actions.Suffle_List) then
    FreeAndNil(soundplayer.player_actions.Suffle_List);
  if not Assigned(soundplayer.player_actions.Suffle_List) then
  begin
    soundplayer.player_actions.Suffle_List := TStringList.Create;
    for vi := 0 to addons.soundplayer.Playlist.List.Songs_Num - 1 do
      soundplayer.player_actions.Suffle_List.Add(vi.ToString);
  end;
end;

procedure Suffle_Back;
var
  vi: Integer;
  list_num: String;
begin
  for vi := 0 to addons.soundplayer.Playlist.List.Songs_Num - 1 do
    vSoundplayer.Playlist.List.Cells[1, vi] := '12';
  for vi := 0 to soundplayer.player_actions.Suffle_List.Count - 1 do
  begin
    list_num := soundplayer.player_actions.Suffle_List.Strings[vi];
    vSoundplayer.Playlist.List.Cells[1, list_num.ToInteger] := '3';
  end;
  if soundplayer.Player = sPlay then
    vSoundplayer.Playlist.List.Cells[1, soundplayer.player_actions.Playing_Now] := '0';
  vSoundplayer.Player.Suffle.TextSettings.FontColor := TAlphaColorRec.Greenyellow;
end;

/// /////////////////////////////////////////////////////////////////////////////
// Song Position Trackbar
procedure Update_Thumb_Pos(Sender: TObject; vValue: Single; vKeep: Boolean);
var
  vCurrent_Position_Song: Single;
  sFT: Real;
begin
  sFT := trunc(BASS_ChannelBytes2Seconds(sound.str_music[1], BASS_ChannelGetLength(sound.str_music[1], BASS_POS_BYTE)));
  vCurrent_Position_Song := (sFT * vValue) / 1000;
  if soundplayer.player_actions.Time_Negative = False then
    vSoundplayer.Player.Song_PlayTime.Text := FormatDateTime('hh:mm:ss', uSnippet_Convert.Seconds_To_Time(vCurrent_Position_Song))
  else
    vSoundplayer.Player.Song_PlayTime.Text := '-' + FormatDateTime('hh:mm:ss', uSnippet_Convert.Seconds_To_Time(sFT - vCurrent_Position_Song));
  if vKeep then
  begin
    BASS_ChannelSetPosition(sound.str_music[1], BASS_ChannelSeconds2Bytes(sound.str_music[1], vCurrent_Position_Song), BASS_POS_BYTE);
    soundplayer.player_actions.Thumb_Active := False;
  end;
end;

///

procedure Add_Songs_m3u(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string; mSongNum: SmallInt);
var
  vss: string;
  vSongTime: string;
  song_seconds: Real;
begin
  sound.str_music[2] := BASS_StreamCreateFile(False, PChar(mTrackPath + mTrackName), 0, 0, BASS_SAMPLE_FLOAT
{$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
  BASS_ChannelFlags(sound.str_music[2], BASS_MUSIC_POSRESET, 0);
  song_seconds := trunc(BASS_ChannelBytes2Seconds(sound.str_music[2], BASS_ChannelGetLength(sound.str_music[2], BASS_POS_BYTE)));
  vss := FloatToStr(song_seconds);
  vSongTime := FormatDateTime('hh:mm:ss', uSnippet_Convert.Seconds_To_Time(song_seconds));
  addons.soundplayer.Playlist.List.Playlist.Add('#EXTINF:' + vss + ',' + mTrackName);
  addons.soundplayer.Playlist.List.Playlist.Add(mTrackPath + mTrackName);
  addons.soundplayer.Playlist.List.Playlist.SaveToFile(addons.soundplayer.Path.Playlists + addons.soundplayer.Playlist.List.Name + '.m3u');
  addons.soundplayer.Playlist.List.Songs.Add(mTrackPath + mTrackName);
  uSoundPlayer_GetTag_Details(mTrackPath + mTrackName, addons.soundplayer.Playlist.Active, mSongNum, vSongTime);
  BASS_StreamFree(sound.str_music[2]);
end;

procedure Add_Songs_pls(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string);
begin

end;

procedure Add_Songs_asx(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string);
begin

end;

procedure Add_Songs_xspf(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string);
begin

end;

procedure Add_Songs_wpl(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string);
begin

end;

procedure Add_Songs_expl(mPlaylistNum: SmallInt; mTrackName, mTrackPath: string);
begin

end;

procedure Add_Songs;
var
  vSongList: TStringList;
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
    vSongNum := soundplayer.player_actions.Playing_Now;
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
      vPlaylistPlayingSong := soundplayer.player_actions.LastPlayed;
      vSongsInPlaylist := addons.soundplayer.Ini.Ini.ReadInteger('Playlists', 'PL_' + IntToStr(vPlaylistNum) + '_Songs', vSongsInPlaylist);
      vPlaylistType := addons.soundplayer.Ini.Ini.ReadString('Playlists', 'PL_' + IntToStr(vPlaylistNum) + '_Type', vPlaylistType);
    end;
    // Add list of songs in stringlist
    vSongList := TStringList.Create;
    vSongList.AddStrings(vSoundplayer.scene.OpenDialog.Files);
    if vPlaylistName = 'temp' then
    begin
      uSoundplayer_Playlist_Create.New(vPlaylistName, vPlaylistType);
      addons.soundplayer.Playlist.List.Songs := TStringList.Create;
    end;

    for vi := 0 to vSongList.Count - 1 do
    begin
      vSongNum := vSongsInPlaylist + vi;
      if vPlaylistType = '.m3u' then
        Add_Songs_m3u(vPlaylistNum, ExtractFileName(vSongList.Strings[vi]), ExtractFilePath(vSongList.Strings[vi]), vSongNum)
        // AddSongs_In_pls
      else if vPlaylistType = 'pls' then
        // Add_Songs_asx
      else if vPlaylistType = 'asx' then
        // Add_Songs_xspf
      else if vPlaylistType = 'xspf' then
        // Add_Songs_wpl
      else if vPlaylistType = 'wpl' then
        // Add_Songs_expl;
      else if vPlaylistType = 'expl' then
      begin

      end;
    end;
    // update playlist config ini
    addons.soundplayer.Ini.Ini.WriteInteger('Playlists', 'PL_' + IntToStr(vPlaylistNum) + '_Songs', (vSongsInPlaylist + vSongList.Count));
    FreeAndNil(vSongList);
    uSoundplayer_Playlist.State('Playlist', vPlaylistNum);
    if soundplayer.Player = sPlay then
    begin
      vSoundplayer.Playlist.List.Cells[1, soundplayer.player_actions.Playing_Now] := '0';
    end;
    vSoundplayer.Playlist.List.Selected := soundplayer.player_actions.Playing_Now;
    Set_Previous_Next;
  end;
end;

procedure Get_Tag(vSongNum: SmallInt);
var
  vSong: string;
  vi, vk: Integer;
  vDescription: String;
  vImage: TBitmap;
  vPath: String;
begin
  vSoundplayer.Player.Song_Title.Text := '"' + addons.soundplayer.Playlist.List.Song_Info[vSongNum].Title + '" by "' +
    addons.soundplayer.Playlist.List.Song_Info[vSongNum].Artist + '"';
  if uSnippet_Text_ToPixels(vSoundplayer.Player.Song_Title) < 990 then
  begin
    vSoundplayer.Player.Song_Title_Ani.Stop;
    soundplayer.player_actions.Title_Ani := False;
    vSoundplayer.Player.Song_Title.Position.X := extrafe.res.Half_Width - 800;
    vSoundplayer.Player.Song_Title.TextSettings.HorzAlign := TTextAlign.Center;
  end
  else
  begin
    vSoundplayer.Player.Song_Title.Position.X := 465;
    vSoundplayer.Player.Song_Title.TextSettings.HorzAlign := TTextAlign.Leading;
    soundplayer.player_actions.Title_Ani := True;
    Title_Animation;
  end;
  vSoundplayer.info.Song_Title.Text := addons.soundplayer.Playlist.List.Song_Info[vSongNum].Title;
  if uSnippet_Text_ToPixels(vSoundplayer.info.Song_Title) > 422 then
    vSoundplayer.info.Song_Title.Text := uSnippet_Text_SetInGivenPixels(422, vSoundplayer.info.Song_Title);
  vSoundplayer.info.Artist_Name.Text := addons.soundplayer.Playlist.List.Song_Info[vSongNum].Artist;
  vSoundplayer.info.Year_Publish.Text := addons.soundplayer.Playlist.List.Song_Info[vSongNum].Year;
  vSoundplayer.info.Gerne_Kind.Text := addons.soundplayer.Playlist.List.Song_Info[vSongNum].Genre;
  vSoundplayer.info.Track_Num.Text := addons.soundplayer.Playlist.List.Song_Info[vSongNum].Track;
  vSoundplayer.Player.Song_Time.Text := addons.soundplayer.Playlist.List.Song_Info[vSongNum].Track_Seconds;

  if addons.soundplayer.Playlist.List.Song_Info[soundplayer.player_actions.Playing_Now].Disk_Type = '.mp3' then
  begin
    vk := 0;
    for vi := 0 to 4 do
    begin
      vSoundplayer.Player.Rate[vi].Text := #$e9d7;
      vSoundplayer.Player.Rate[vi].Visible := True;
    end;
    if addons.soundplayer.Playlist.List.Song_Info[vSongNum].Rate > IntToStr(0) then
    begin
      for vi := 0 to Round(((addons.soundplayer.Playlist.List.Song_Info[vSongNum].Rate.ToSingle) / 25.5)) - 1 do
      begin
        if not Odd(vi) then
          vSoundplayer.Player.Rate[vk].Text := #$e9d8
        else
        begin
          vSoundplayer.Player.Rate[vk].Text := #$e9d9;
          Inc(vk, 1);
        end;
      end;
    end;

    if addons.soundplayer.Playlist.List.Song_Info[vSongNum].Lyrics.Count - 1 > 1 then
      vSoundplayer.Player.Lyrics.TextSettings.FontColor := TAlphaColorRec.Deepskyblue
    else
      vSoundplayer.Player.Lyrics.TextSettings.FontColor := TAlphaColorRec.Grey;
  end
  else if addons.soundplayer.Playlist.List.Song_Info[soundplayer.player_actions.Playing_Now].Disk_Type = '.ogg' then
  begin

  end;

  if addons.soundplayer.Playlist.List.Song_Info[soundplayer.player_actions.Playing_Now].Disk_Type = '.mp3' then
  begin
    vPath := addons.soundplayer.Playlist.List.Song_Info[soundplayer.player_actions.Playing_Now].Disk_Path + addons.soundplayer.Playlist.List.Song_Info
      [soundplayer.player_actions.Playing_Now].Disk_Name + addons.soundplayer.Playlist.List.Song_Info[soundplayer.player_actions.Playing_Now].Disk_Type;
    uSoundplayer_Tag_Mp3.APICIndex := 0;
    if uSoundplayer_Tag_Mp3.Cover_Get_Image(vPath, vDescription, vImage) then
    begin
      vSoundplayer.info.Cover.Bitmap := vImage;
      vSoundplayer.info.Cover_Label.Text := vDescription;
    end
    else
    begin
      vSoundplayer.info.Cover.Bitmap := nil;
      vSoundplayer.info.Cover_Label.Text := '';
    end;
  end
  else if addons.soundplayer.Playlist.List.Song_Info[soundplayer.player_actions.Playing_Now].Disk_Type = '.ogg' then
    // This must be function and return boolean with out from function
    GetTags_OGG_Cover(vSongNum);
  vSong := addons.soundplayer.Playlist.List.Songs.Strings[vSongNum];
end;

/// /////////////////////////////////////////////////////////////////////////////
procedure Show_Tag(vSongName: String; vSongNum: Integer);
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
      uSoundplayer_Tag_Mp3_SetAll.Load;
      uSoundplayer_Tag_Mp3.Get(vSongName, vSongNum);
    end
    else if addons.soundplayer.Playlist.List.Song_Info[vSongNum].Disk_Type = '.ogg' then
    begin
      uSoundplayer_TagSet_Opus;
      uSoundplayer_Tag_Ogg_GetOgg(vSongName);
    end;
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////
procedure Text_OnOver(vText: TText; vGlow: TGlowEffect);
  procedure Text_ScaleUp;
  begin
    vText.Scale.X := 1.1;
    vText.Scale.Y := 1.1;
    vText.Position.X := vText.Position.X - ((vText.Width * 0.1) / 2);
    vText.Position.Y := vText.Position.Y - ((vText.Height * 0.1) / 2);
    vGlow.Enabled := True;
  end;

begin
  if vText.Name = 'A_SP_Player_Play' then
  begin
    if soundplayer.Player = sPlay then
    begin
      vGlow.GlowColor := TAlphaColorRec.Greenyellow;
      vText.Text := #$ea1d;
      vText.TextSettings.FontColor := TAlphaColorRec.Greenyellow;
    end
    else if soundplayer.Player = sPause then
    begin
      vGlow.GlowColor := TAlphaColorRec.Blueviolet;
      vText.Text := #$ea1c;
      vText.TextSettings.FontColor := TAlphaColorRec.Blueviolet;
    end
    else
    begin
      vGlow.GlowColor := TAlphaColorRec.Deepskyblue;
      vText.Text := #$ea1c;
      vText.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    end;
  end
  else if vText.Name = 'A_SP_Player_Suffle' then
  begin
    if soundplayer.player_actions.Suffle then
      vGlow.GlowColor := TAlphaColorRec.Limegreen
    else if soundplayer.player_actions.Suffle = False then
      vGlow.GlowColor := TAlphaColorRec.Deepskyblue;
  end;
  Text_ScaleUp;
  BASS_ChannelPlay(addons.soundplayer.sound.Effects[2], False);
end;

procedure Text_OnLeave(vText: TText; vGlow: TGlowEffect);
  procedure Text_ScaleDown;
  begin
    vText.Scale.X := 1;
    vText.Scale.Y := 1;
    vText.Position.X := vText.Position.X + ((vText.Width * 0.1) / 2);
    vText.Position.Y := vText.Position.Y + ((vText.Height * 0.1) / 2);
    vGlow.Enabled := False;
  end;

begin
  if vText.Name = 'A_SP_Player_Play' then
  begin
    if soundplayer.Player = sPlay then
    begin
      vText.Text := #$ea1c;
      vText.TextSettings.FontColor := TAlphaColorRec.Blueviolet;
    end
    else if soundplayer.Player = sPause then
    begin
      vText.Text := #$ea1d;
      vText.TextSettings.FontColor := TAlphaColorRec.Greenyellow;
    end
    else if soundplayer.player = sStop then
    begin
      vSoundplayer.Player.Stop_Glow.Enabled := False;
    end;
  end;
  Text_ScaleDown;
end;

/// ///////////////////////////////////////////////////////////////////////////////////////////
procedure Update_Last_Song(vNum: Integer);
begin
  soundplayer.player_actions.LastPlayed := vNum;
//  addons.soundplayer.Ini.Ini.WriteInteger('Song', 'LastPlayed', vNum);
end;

procedure Title_Animation;
begin
  if soundplayer.player_actions.Title_Ani then
  begin
    if soundplayer.player_actions.Title_Ani_Left = False then
    begin
      vSoundplayer.Player.Song_Title_Ani.StartValue := 465;
      vSoundplayer.Player.Song_Title_Ani.StopValue := 465 - ((uSnippet_Text_ToPixels(vSoundplayer.Player.Song_Title) + 5) - 1000);
    end
    else if soundplayer.player_actions.Title_Ani_Left then
    begin
      vSoundplayer.Player.Song_Title_Ani.StartValue := vSoundplayer.Player.Song_Title_Ani.StopValue;
      vSoundplayer.Player.Song_Title_Ani.StopValue := 465;
    end;
    vSoundplayer.Player.Song_Title_Ani.Start;
  end;
end;

/// Band Info Presentation
procedure Band_Info;
begin
  extrafe.prog.State := 'addon_soundplayer_player_band';

  Text_OnLeave(vSoundplayer.Player.Band_Info, vSoundplayer.Player.Band_Info_Glow);
  uSoundplayer_SetAll.Band_Information;

  uSoundplayer_Scrapers_LastFm.Artist_Company;
end;

procedure Band_Info_Close;
begin
  extrafe.prog.State := 'addon_soundplayer';
  FreeAndNil(vSoundplayer.Player.Band_Info_Press.Header);
  FreeAndNil(vSoundplayer.Player.Band_Info_Press.Name);
  FreeAndNil(vSoundplayer.Player.Band_Info_Press.Powered_By);
  FreeAndNil(vSoundplayer.Player.Band_Info_Press.Powered_Img);
  FreeAndNil(vSoundplayer.Player.Band_Info_Press.Close);
  FreeAndNil(vSoundplayer.Player.Band_Info_Press.Box);
  vSoundplayer.scene.Back_Blur.Enabled := False;
  vSoundplayer.scene.Back_Presentation.Visible := False;
end;

/// Lyrics Presentation
procedure Lyrics;
var
  vi: Integer;
begin
  extrafe.prog.State := 'addon_soundplayer_player_lyrics';
  Text_OnLeave(vSoundplayer.Player.Lyrics, vSoundplayer.Player.Lyrics_Glow);
  uSoundplayer_SetAll.Lyrics;

  vSoundplayer.Player.Lyrics_Press.Name.Text := addons.soundplayer.Playlist.List.Song_Info[soundplayer.player_actions.Playing_Now].Title;

  SetLength(vSoundplayer.Player.Lyrics_Press.Lyrics, addons.soundplayer.Playlist.List.Song_Info[soundplayer.player_actions.Playing_Now].Lyrics.Count + 1);

  for vi := 0 to addons.soundplayer.Playlist.List.Song_Info[soundplayer.player_actions.Playing_Now].Lyrics.Count do
  begin
    vSoundplayer.Player.Lyrics_Press.Lyrics[vi] := TText.Create(vSoundplayer.Player.Lyrics_Press.Box);
    vSoundplayer.Player.Lyrics_Press.Lyrics[vi].Name := 'A_SP_Lyrics_Lyrics_' + vi.ToString;
    vSoundplayer.Player.Lyrics_Press.Lyrics[vi].Parent := vSoundplayer.Player.Lyrics_Press.Box;
    vSoundplayer.Player.Lyrics_Press.Lyrics[vi].SetBounds(30, (vi * 34), vSoundplayer.Player.Lyrics_Press.Box.Width - 30, 34);
    vSoundplayer.Player.Lyrics_Press.Lyrics[vi].Font.Family := 'Tahoma';
    vSoundplayer.Player.Lyrics_Press.Lyrics[vi].TextSettings.FontColor := TAlphaColorRec.White;
    vSoundplayer.Player.Lyrics_Press.Lyrics[vi].Font.Size := 28;
    if vi = addons.soundplayer.Playlist.List.Song_Info[soundplayer.player_actions.Playing_Now].Lyrics.Count then
      vSoundplayer.Player.Lyrics_Press.Lyrics[vi].Text := ''
    else
      vSoundplayer.Player.Lyrics_Press.Lyrics[vi].Text := addons.soundplayer.Playlist.List.Song_Info[soundplayer.player_actions.Playing_Now].Lyrics.Strings[vi];
    vSoundplayer.Player.Lyrics_Press.Lyrics[vi].Visible := True;
  end;
end;

procedure Lyrics_Close;
begin
  extrafe.prog.State := 'addon_soundplayer';
  FreeAndNil(vSoundplayer.Player.Lyrics_Press.Header);
  FreeAndNil(vSoundplayer.Player.Lyrics_Press.Name);
  FreeAndNil(vSoundplayer.Player.Lyrics_Press.Close);
  FreeAndNil(vSoundplayer.Player.Lyrics_Press.Box);
  vSoundplayer.scene.Back_Blur.Enabled := False;
  vSoundplayer.scene.Back_Presentation.Visible := False;
end;

/// Album Presentation
procedure Album;
begin
  extrafe.prog.State := 'addon_soundplayer_player_album';

  Text_OnLeave(vSoundplayer.Player.Album_Info, vSoundplayer.Player.Album_Info_Glow);
  uSoundplayer_SetAll.Album_Information;

  uSoundplayer_Scrapers_LastFm.Album;
end;

procedure Album_Close;
begin
  extrafe.prog.State := 'addon_soundplayer';
  FreeAndNil(vSoundplayer.Player.Album_Info_Press.Powered_By);
  FreeAndNil(vSoundplayer.Player.Album_Info_Press.Powered_Img);
  FreeAndNil(vSoundplayer.Player.Album_Info_Press.Name);
  FreeAndNil(vSoundplayer.Player.Album_Info_Press.Box);
  FreeAndNil(vSoundplayer.Player.Album_Info_Press.Close);
  vSoundplayer.scene.Back_Blur.Enabled := False;
  vSoundplayer.scene.Back_Presentation.Visible := False;
end;

end.
