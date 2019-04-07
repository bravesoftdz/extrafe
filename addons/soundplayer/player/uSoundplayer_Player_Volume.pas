unit uSoundplayer_Player_Volume;

interface

uses
  System.Classes,
  System.SysUtils,
  Bass;

procedure Mute;

procedure Ani;
procedure Show;
procedure Update(mValue: single);

procedure Speakers_OnMouseAbove(vState: Boolean);

procedure Adjust(vLeave: Boolean);

implementation

uses
  uLoad_AllTypes,
  uSoundplayer_AllTypes;

procedure Mute;
begin
  if addons.soundplayer.Player.Mute = False then
  begin
    if addons.soundplayer.Volume.Mute = 0 then
    begin
      addons.soundplayer.Volume.Mute := addons.soundplayer.Volume.Vol;
      addons.soundplayer.Volume.Vol := 0;
      addons.soundplayer.Ini.Ini.WriteFloat('Volume', 'Master', 0);
      BASS_ChannelSetAttribute(sound.str_music[1], BASS_ATTRIB_VOL, 0);
    end;
    vSoundplayer.Player.Speaker_Left_Volume_Pos.Value := 0;
    vSoundplayer.Player.Speaker_Right_Volume_Pos.Value := 0;
    addons.soundplayer.Player.Mute := True;
    vSoundplayer.Player.Speaker_Left_Hue.Enabled := True;
    vSoundplayer.Player.Speaker_Right_Hue.Enabled := True;
  end
  else
  begin
    if addons.soundplayer.Volume.Mute <> 0 then
    begin
      addons.soundplayer.Volume.Vol := addons.soundplayer.Volume.Mute;
      addons.soundplayer.Ini.Ini.WriteFloat('Volume', 'Master', addons.soundplayer.Volume.Vol / 100);
      BASS_ChannelSetAttribute(sound.str_music[1], BASS_ATTRIB_VOL, addons.soundplayer.Volume.Vol / 100);
    end;
    vSoundplayer.Player.Speaker_Left_Volume_Pos.Value := addons.soundplayer.Volume.Vol;
    vSoundplayer.Player.Speaker_Right_Volume_Pos.Value := addons.soundplayer.Volume.Vol;
    addons.soundplayer.Player.Mute := False;
    vSoundplayer.Player.Speaker_Left_Hue.Enabled := False;
    vSoundplayer.Player.Speaker_Right_Hue.Enabled := False;
  end;
end;

procedure Show;
begin
  if addons.soundplayer.Volume.State = 'Master' then
  begin
    vSoundplayer.Player.Speaker_Left_Percent_Ani.Enabled := False;
    vSoundplayer.Player.Speaker_Right_Percent_Ani.Enabled := False;
    vSoundplayer.Player.Speaker_Left_Percent.Opacity := 1;
    vSoundplayer.Player.Speaker_Right_Percent.Opacity := 1;
  end;
end;

procedure Ani;
begin
  if addons.soundplayer.Volume.State = 'Master' then
  begin
    vSoundplayer.Player.Speaker_Left_Percent_Ani.Enabled := True;
    vSoundplayer.Player.Speaker_Right_Percent_Ani.Enabled := True;
  end
end;

procedure Update(mValue: single);
begin
  if extrafe.prog.State <> 'addon_soundplayer_loading' then
  begin
    if addons.soundplayer.Player.Volume_Changed = False then
    begin
      Show;
      addons.soundplayer.Volume.Vol := mValue;
      if addons.soundplayer.Volume.State = 'Master' then
      begin
        // Set the maste volume of the song
        BASS_ChannelSetAttribute(sound.str_music[1], BASS_ATTRIB_VOL, addons.soundplayer.Volume.Vol / 100);
        // Write to init the volume
        addons.soundplayer.Ini.Ini.WriteFloat('Volume', 'Master', addons.soundplayer.Volume.Vol / 100);
        addons.soundplayer.Ini.Ini.WriteFloat('Volume', 'Left', addons.soundplayer.Volume.Vol / 100);
        addons.soundplayer.Ini.Ini.WriteFloat('Volume', 'Right', addons.soundplayer.Volume.Vol / 100);
        // Show the current text %;
        vSoundplayer.Player.Speaker_Left_Percent.Text :=
          FormatFloat('0', addons.soundplayer.Volume.Vol) + '%';
        vSoundplayer.Player.Speaker_Right_Percent.Text :=
          FormatFloat('0', addons.soundplayer.Volume.Vol) + '%';
        // Change the mute stat if is muted
        if addons.soundplayer.Player.Mute = True then
        begin
          addons.soundplayer.Player.Mute := False;
          vSoundplayer.Player.Speaker_Left_Hue.Enabled := False;
          vSoundplayer.Player.Speaker_Right_Hue.Enabled := False;
        end
        else if addons.soundplayer.Volume.Vol = 0 then
          Mute;
        vSoundplayer.Player.Speaker_Right_Volume_Pos.Value := addons.soundplayer.Volume.Vol;
        vSoundplayer.Player.Speaker_Left_Volume_Pos.Value := addons.soundplayer.Volume.Vol;
        addons.soundplayer.Player.Volume_Changed := True;
      end;
    end;
    addons.soundplayer.Player.Volume_Changed := False;
    Ani;
  end;
end;

procedure Speakers_OnMouseAbove(vState: Boolean);
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
  end;
end;

procedure Adjust(vLeave: Boolean);
var
  vAdjust_Volume: Real;
begin
  if vLeave then
    vAdjust_Volume:= (addons.soundplayer.Volume.Vol / 100) / 2
  else
    vAdjust_Volume:= (addons.soundplayer.Volume.Vol / 100) * 2;
  BASS_ChannelSetAttribute(sound.str_music[1], BASS_ATTRIB_VOL, vAdjust_Volume);
end;

end.
