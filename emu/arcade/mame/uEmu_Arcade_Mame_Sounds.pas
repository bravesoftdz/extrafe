unit uEmu_Arcade_Mame_Sounds;

interface
uses
  System.Classes,
  BASS;

procedure Load;
procedure Unload;

implementation
uses
  uLoad_AllTypes,
  uEmu_Arcade_Mame_AllTypes;

procedure Load;
begin
   mame.Sound.Effects[0] := BASS_StreamCreateFile(False,
    PChar(mame.Prog.Sounds+ 'wrong.mp3'), 0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE
{$ENDIF});
end;

procedure Unload;
begin
  BASS_StreamFree(mame.Sound.Effects[0]);
end;

end.