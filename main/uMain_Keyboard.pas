unit uMain_Keyboard;

interface

uses
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  FMX.Objects;

procedure uMain_Keyboard_SetKey(vKey: String);

implementation

uses
  main,
  uLoad,
  uLoad_AllTypes,
  uMain_Actions,
  uMain_Config,
  uMain_Emulation,
  uMain_Config_Keyboard;

procedure uMain_Keyboard_SetKey(vKey: String);
begin
  if extrafe.prog.State = 'main' then
  begin
    if UpperCase(vKey) = 'RIGHT' then
      uMain_Emulation_Slide_Right
    else if UpperCase(vKey) = 'LEFT' then
      uMain_Emulation_Slide_Left
    else if UpperCase(vKey) = 'ENTER' then
    begin
      if extrafe.prog.State = 'main' then
        uMain_Emulation_Trigger_Click(emulation.Selection.TabIndex, False)
    end
    else if UpperCase(vKey) = 'BACKSPACE' then
    begin
      if extrafe.prog.State = 'main' then
        uMain_Emulation_Trigger_Click(0, True)
    end
    else if UpperCase(vKey) = 'S' then
      uMain_Config_ShowHide(extrafe.prog.State)
    else if UpperCase(vKey) = '1' then
      uMain_Actions_ShowHide_Addons(1000)
    else if UpperCase(vKey) = '2' then
      uMain_Actions_ShowHide_Addons(1001)
  end
  else if  ContainsText(extrafe.prog.State, 'main_config') then
    uMain_Config_Keyboard.Set_Key(vKey);
end;

end.
