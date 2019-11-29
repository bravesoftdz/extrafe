unit uMain_Keyboard;

interface

uses
  System.Classes,
  System.SysUtils,
  System.StrUtils;

procedure SetKey(vKey: String);

implementation

uses
  uMain,
  uLoad_AllTypes,
  uMain_Actions,
  uMain_Config,
  uMain_Emulation,
  uMain_Config_Keyboard;

procedure SetKey(vKey: String);
begin
  if extrafe.prog.State = 'main' then
  begin
    if UpperCase(vKey) = 'RIGHT' then
      uMain_Emulation.Slide_Right
    else if UpperCase(vKey) = 'LEFT' then
      uMain_Emulation.Slide_Left
    else if UpperCase(vKey) = 'ENTER' then
    begin
      if extrafe.prog.State = 'main' then
        uMain_Emulation.Trigger_Click(emulation.Selection.TabIndex, False)
    end
    else if UpperCase(vKey) = 'ESC' then
    begin
      if emulation.Level <> 0 then
        uMain_Emulation.Trigger_Click(0, True)
      else
        uMain.Exit;
    end
    else if UpperCase(vKey) = 'S' then
      uMain_Config.ShowHide(extrafe.prog.State)
    else if UpperCase(vKey) = '1' then
      uMain_Actions.ShowHide_Addon(1000, extrafe.prog.State, 'time')
    else if UpperCase(vKey) = '2' then
      uMain_Actions.ShowHide_Addon(1001, extrafe.prog.State, 'calendar')
  end
  else if extrafe.prog.State = 'main_exit' then
  begin
    if UpperCase(vKey) = 'ESC' then
      uMain.Exit_Stay
  end
  else if ContainsText(extrafe.prog.State, 'main_config') then
    uMain_Config_Keyboard.Set_Key(vKey);
end;

end.
