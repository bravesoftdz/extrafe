unit uSoundplayer_Equalizer;

interface

uses
  System.Classes,
  System.SysUtils,
  BASS;

function Update_Pan(vPan: Single): String;

implementation

uses
  uLoad_AllTypes,
  uSoundplayer_AllTypes;

function Update_Pan(vPan: Single): String;
begin
  if vPan = 0 then
    Result := 'Center'
  else if vPan < 0 then
    Result := 'Left : ' + (-vPan).ToString + '%'
  else if vPan > 0 then
    Result := 'Right : ' + vPan.ToString + '%';
  vSoundplayer.EQ.Pan_Metric.Text := Result;
  addons.soundplayer.Ini.Ini.WriteFloat('Equalizer', 'Pan', vPan);
  addons.soundplayer.Equalizer.Pan := vPan;
  if addons.soundplayer.Equalizer.Live_Preview then
    if addons.soundplayer.Player.Play then
      BASS_ChannelSetAttribute(sound.str_music[1], BASS_ATTRIB_PAN, (vPan / 100));
end;

end.
