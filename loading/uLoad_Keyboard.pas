unit uLoad_Keyboard;

interface

uses
  System.Classes,
  System.SysUtils,
  FMX.Objects,
  BASS;

procedure SetKey(vKey: String);

implementation

uses
  loading,
  uLoad,
  uLoad_AllTypes,
  uLoad_Login;

procedure SetKey(vKey: String);
var
  vStr: String;
begin
  BASS_ChannelStop(sound.str_fx.general[1]);
  BASS_ChannelSetPosition(sound.str_fx.general[1], 0, 0);
  BASS_ChannelStop(sound.str_fx.general[2]);
  BASS_ChannelSetPosition(sound.str_fx.general[2], 0, 0);
  if UpperCase(vKey) = 'SPACE' then
    BASS_ChannelPlay(sound.str_fx.general[1], false)
  else
    BASS_ChannelPlay(sound.str_fx.general[2], false);
  if extrafe.prog.State = 'load_login' then
  begin
    if UpperCase(vKey) = 'ENTER' then
    begin
      if ex_load.Login.User_V.IsFocused then
        ex_load.Login.Pass_V.SetFocus
      else if ex_load.Login.Pass_V.IsFocused then
        uLoad_Login.Login;
    end
    else if UpperCase(vKey) = 'CAPS LOCK' then
      ex_load.Login.CapsLock.Visible := not ex_load.Login.CapsLock.Visible
    else
  end
  else if extrafe.prog.State = 'load_register' then
  begin

  end
  else if extrafe.prog.State = 'load_forgat' then
  begin

  end;
end;

end.
