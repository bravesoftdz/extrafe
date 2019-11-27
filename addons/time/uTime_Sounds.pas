unit uTime_Sounds;

interface

uses
  System.Classes,
  BASS;

procedure uTime_Sounds_Load;
procedure uTime_Sounds_Free;

implementation

uses
  uDB_AUser,
  uLoad_AllTypes;

procedure uTime_Sounds_Load;
begin
  addons.time.Sound.Clock[0] := BASS_StreamCreateFile(False, PChar(uDB_AUser.Local.ADDONS.Time_D.Path.Sounds + 'a_t_tick.mp3'),
    0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE{$ENDIF});

  addons.time.Sound.Clock[1] := BASS_StreamCreateFile(False, PChar(uDB_AUser.Local.ADDONS.Time_D.Path.Sounds + 'a_t_tack.mp3'),
    0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE{$ENDIF});
end;

procedure uTime_Sounds_Free;
begin
  BASS_StreamFree(addons.time.Sound.Clock[0]);
  BASS_StreamFree(addons.time.Sound.Clock[1]);
end;

end.
