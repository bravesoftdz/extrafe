unit uSoundplayer_Player_Volume;

interface

uses
  System.Classes,
  System.SysUtils,
  Bass;

procedure uSoundplayer_Player_Volume_Mute;

procedure uSoundplayer_Player_Volume_Ani;
procedure uSoundplayer_Player_Volume_Show;
procedure uSoundplayer_Player_Volume_Update(mValue: single; vSpeaker: String);

procedure uSoundplayer_Player_Volume_Speakers_OnMouseAbove(vState: Boolean);

implementation

uses
  uLoad_AllTypes,
  uSoundplayer_AllTypes;

procedure uSoundplayer_Player_Volume_Mute;
begin
  if addons.soundplayer.Player.Mute = False then
  begin
    addons.soundplayer.Volume.Mute := addons.soundplayer.Volume.Vol;
    addons.soundplayer.Volume.Vol := 0;
    addons.soundplayer.Ini.Ini.WriteFloat('Volume', 'Master', 0);
    BASS_ChannelSetAttribute(sound.str_music[1], BASS_ATTRIB_VOL, 0);
    vSoundplayer.Player.Speaker_Left_Volume_Pos.Value := 0;
    vSoundplayer.Player.Speaker_Right_Volume_Pos.Value := 0;
    addons.soundplayer.Player.Mute := True;
    vSoundplayer.Player.Speaker_Left_Hue.Enabled := True;
    vSoundplayer.Player.Speaker_Right_Hue.Enabled := True;
  end
  else
  begin
    addons.soundplayer.Volume.Vol := addons.soundplayer.Volume.Mute;
    addons.soundplayer.Ini.Ini.WriteFloat('Volume', 'Master', addons.soundplayer.Volume.Vol / 100);
    BASS_ChannelSetAttribute(sound.str_music[1], BASS_ATTRIB_VOL, addons.soundplayer.Volume.Vol / 100);
    vSoundplayer.Player.Speaker_Left_Volume_Pos.Value := addons.soundplayer.Volume.Vol;
    vSoundplayer.Player.Speaker_Right_Volume_Pos.Value := addons.soundplayer.Volume.Vol;
    addons.soundplayer.Player.Mute := False;
    vSoundplayer.Player.Speaker_Left_Hue.Enabled := False;
    vSoundplayer.Player.Speaker_Right_Hue.Enabled := False;
  end;
end;

procedure uSoundplayer_Player_Volume_Show;
begin
  if addons.soundplayer.Volume.State = 'Master' then
  begin
    vSoundplayer.Player.Speaker_Left_Percent_Ani.Enabled := False;
    vSoundplayer.Player.Speaker_Right_Percent_Ani.Enabled := False;
    vSoundplayer.Player.Speaker_Left_Percent.Opacity := 1;
    vSoundplayer.Player.Speaker_Right_Percent.Opacity := 1;
  end;
end;

procedure uSoundplayer_Player_Volume_Ani;
begin
  if addons.soundplayer.Volume.State = 'Master' then
  begin
    vSoundplayer.Player.Speaker_Left_Percent_Ani.Enabled := True;
    vSoundplayer.Player.Speaker_Right_Percent_Ani.Enabled := True;
  end;
end;

procedure uSoundplayer_Player_Volume_Update(mValue: single; vSpeaker: String);
begin
  if extrafe.prog.State <> 'addon_soundplayer_loading' then
  begin
    if addons.soundplayer.Player.Volume_Changed = False then
    begin
      uSoundplayer_Player_Volume_Show;
      addons.soundplayer.Volume.Vol := mValue;
      // Set the maste volume of the song
      BASS_ChannelSetAttribute(sound.str_music[1], BASS_ATTRIB_VOL, addons.soundplayer.Volume.Vol / 100);
      // Write to init the volume
      addons.soundplayer.Ini.Ini.WriteFloat('Volume', 'Master', addons.soundplayer.Volume.Vol / 100);
      addons.soundplayer.Ini.Ini.WriteFloat('Volume', 'Left', addons.soundplayer.Volume.Vol / 100);
      addons.soundplayer.Ini.Ini.WriteFloat('Volume', 'Right', addons.soundplayer.Volume.Vol / 100);
      // Show the current text %
      vSoundplayer.Player.Speaker_Left_Percent.Text := FormatFloat('0', addons.soundplayer.Volume.Vol) + '%';
      vSoundplayer.Player.Speaker_Right_Percent.Text := FormatFloat('0', addons.soundplayer.Volume.Vol) + '%';
      // Change the mute stat if is muted
      if addons.soundplayer.Player.Mute = True then
        begin
          addons.soundplayer.Player.Mute := False;
          vSoundplayer.Player.Speaker_Left_Hue.Enabled:= False;
          vSoundplayer.Player.Speaker_Right_Hue.Enabled:= False;
        end;
      addons.soundplayer.Player.Volume_Changed := True;
    end;
  end
  else
  begin
    uSoundplayer_Player_Volume_Show;
    addons.soundplayer.Volume.Vol := mValue;
    // Set the maste volume of the song
    BASS_ChannelSetAttribute(sound.str_music[1], BASS_ATTRIB_VOL, addons.soundplayer.Volume.Vol / 100);
    // Show the current text %
    vSoundplayer.Player.Speaker_Left_Percent.Text := FormatFloat('0', addons.soundplayer.Volume.Vol) + '%';
    vSoundplayer.Player.Speaker_Right_Percent.Text := FormatFloat('0', addons.soundplayer.Volume.Vol) + '%';
  end;

  if vSpeaker = 'Both' then
  begin
    vSoundplayer.Player.Speaker_Right_Volume_Pos.Value := addons.soundplayer.Volume.Vol;
    vSoundplayer.Player.Speaker_Left_Volume_Pos.Value := addons.soundplayer.Volume.Vol;
    addons.soundplayer.Player.Volume_Changed := False;
  end
  else if vSpeaker = 'Left' then
  begin
    vSoundplayer.Player.Speaker_Right_Volume_Pos.Value := vSoundplayer.Player.Speaker_Left_Volume_Pos.Value;
    addons.soundplayer.Player.Volume_Changed := False;
  end
  else if vSpeaker = 'Right' then
  begin
    vSoundplayer.Player.Speaker_Left_Volume_Pos.Value := vSoundplayer.Player.Speaker_Right_Volume_Pos.Value;
    addons.soundplayer.Player.Volume_Changed := False;
  end;
  uSoundplayer_Player_Volume_Ani
end;

procedure uSoundplayer_Player_Volume_Speakers_OnMouseAbove(vState: Boolean);
begin
  if addons.soundplayer.Volume.State = 'Master' then
  begin
    if (vState and (addons.soundplayer.Volume.Vol <> 0)) then
    begin
      vSoundplayer.Player.Speaker_Left_Hue.Enabled := vState;
      vSoundplayer.Player.Speaker_Right_Hue.Enabled := vState;
    end
    else if ((vState = False) and (addons.soundplayer.Volume.Vol = 0)) then
    begin
      vSoundplayer.Player.Speaker_Left_Hue.Enabled := not vState;
      vSoundplayer.Player.Speaker_Right_Hue.Enabled := not vState;
    end
    else if vState = False then
    begin
      vSoundplayer.Player.Speaker_Left_Hue.Enabled := vState;
      vSoundplayer.Player.Speaker_Right_Hue.Enabled := vState;
    end;
  end
  else if addons.soundplayer.Volume.State = 'Left' then
  begin
    vSoundplayer.Player.Speaker_Left_Hue.Enabled := vState;
  end
  else if addons.soundplayer.Volume.State = 'Right' then
  begin
    vSoundplayer.Player.Speaker_Right_Hue.Enabled := vState;
  end;
end;

end.
