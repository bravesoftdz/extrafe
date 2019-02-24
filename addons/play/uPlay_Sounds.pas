unit uPlay_Sounds;

interface

uses
  System.Classes,
  Bass;

procedure Load;
procedure Unload;

implementation
uses
  uLoad_AllTypes;

procedure Load;
begin
  //AzHung Voice
  addons.play.Sounds.Voices[0]:= BASS_StreamCreateFile(False,
    PChar(addons.play.Path.Sounds + 'a_azp_azhung.mp3'), 0, 0, 0
    {$IFDEF UNICODE} or BASS_UNICODE{$ENDIF});
  //AzMatch Voice
  addons.play.Sounds.Voices[1]:= BASS_StreamCreateFile(False,
    PChar(addons.play.Path.Sounds + 'a_azp_azmatch.mp3'), 0, 0, 0
    {$IFDEF UNICODE} or BASS_UNICODE{$ENDIF});
  //AzOng Voice
  addons.play.Sounds.Voices[2]:= BASS_StreamCreateFile(False,
    PChar(addons.play.Path.Sounds + 'a_azp_azong.mp3'), 0, 0, 0
    {$IFDEF UNICODE} or BASS_UNICODE{$ENDIF});
  //AzSuko Voice
  addons.play.Sounds.Voices[3]:= BASS_StreamCreateFile(False,
    PChar(addons.play.Path.Sounds + 'a_azp_azsuko.mp3'), 0, 0, 0
    {$IFDEF UNICODE} or BASS_UNICODE{$ENDIF});
  //AzType Voice
  addons.play.Sounds.Voices[4]:= BASS_StreamCreateFile(False,
    PChar(addons.play.Path.Sounds + 'a_azp_aztype.mp3'), 0, 0, 0
    {$IFDEF UNICODE} or BASS_UNICODE{$ENDIF});
  //Mouse Over
  addons.play.Sounds.Mouse[0] := BASS_StreamCreateFile(False,
    PChar(addons.play.Path.Sounds + 'a_azp_hover.mp3'), 0, 0, 0
    {$IFDEF UNICODE} or BASS_UNICODE{$ENDIF});
end;

procedure Unload;
begin
  BASS_StreamFree(addons.play.Sounds.Voices[0]);
  BASS_StreamFree(addons.play.Sounds.Voices[1]);
  BASS_StreamFree(addons.play.Sounds.Voices[2]);
  BASS_StreamFree(addons.play.Sounds.Voices[3]);
  BASS_StreamFree(addons.play.Sounds.Voices[4]);
  BASS_StreamFree(addons.play.Sounds.Mouse[0]);
end;

end.
