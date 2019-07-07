unit uMain_Config_Keyboard;

interface
uses
  System.Classes,
  System.SysUtils,
  System.StrUtils;

procedure Set_Key(vKey: String);

implementation
uses
  uLoad_AllTypes,
  uMain_Config;

procedure Set_Key(vKey: String);
begin
  if ContainsText(extrafe.prog.State, 'main_config') then
  begin
    if UpperCase(vKey)= 'ESC' then
      uMain_Config_ShowHide(extrafe.prog.State)
    else if vKey= '1' then
      uMain_Config_ShowPanel(0)
    else if vKey= '2' then
      uMain_Config_ShowPanel(1)
    else if vKey= '3' then
      uMain_Config_ShowPanel(2)
    else if vKey= '4' then
      uMain_Config_ShowPanel(3)
    else if vKey= '5' then
      uMain_Config_ShowPanel(4)
    else if vKey= '6' then
      uMain_Config_ShowPanel(5)
    else if vKey= '7' then
      uMain_Config_ShowPanel(6)
  end;
end;

end.