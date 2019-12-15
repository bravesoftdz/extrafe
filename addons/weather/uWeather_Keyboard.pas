unit uWeather_Keyboard;

interface

uses
  System.Classes,
  System.SysUtils;

procedure uWeather_Keyboard_SetKey(vKey: String);

implementation

uses
  uLoad,
  uLoad_AllTypes,
  uMain_Actions,
  uWeather_Actions,
  uWeather_MenuActions,
  uWeather_Config,
  uWeather_Config_Towns,
  uWeather_Config_Towns_Add,
  uWeather_AllTypes,
  uWeather_SetAll;

procedure uWeather_Keyboard_SetKey(vKey: String);
var
  vi: Integer;
begin
  if extrafe.prog.State = 'addon_weather_config_towns_add' then
  begin
    if UpperCase(vKey) = 'ESC' then
      uWeather_Config_Towns_Add.Free
    else if UpperCase(vKey) = 'ENTER' then
      uWeather_Config_Towns_Add.FindTown(vWeather.Config.Main.Right.Towns.Add.Main.FindTown_V.Text);
  end
  else if extrafe.prog.State = 'addon_weather_config' then
  begin
    if UpperCase(vKey) = 'S' then
      uWeather_Config_ShowHide(False)
    else if UpperCase(vKey) = 'UP' then
    begin
      if weather.Config.Edit_Lock then
        if weather.Config.Selected_Town <> 0 then
          uWeather_Config_Towns_Edit_SelectTown(weather.Config.Selected_Town - 1)
    end
    else if UpperCase(vKey) = 'DOWN' then
    begin
      if weather.Config.Edit_Lock then
        if weather.Config.Selected_Town <> weather.Action.Active_Total then
          uWeather_Config_Towns_Edit_SelectTown(weather.Config.Selected_Town + 1)
    end;
  end
  else if extrafe.prog.State = 'addon_weather' then
  begin
    vi := weather.Main_Menu_Position;
    if UpperCase(vKey) = 'LEFT' then
      uWeather_Actions.Control_Slide_Left
    else if UpperCase(vKey) = 'RIGHT' then
      uWeather_Actions.Control_Slide_Right
    else if UpperCase(vKey) = 'S' then
      uWeather_Config_ShowHide(True)
    else if UpperCase(vKey) = IntToStr(vi + 1) then
      uMain_Actions.ShowHide_Addon(1000 + vi, extrafe.prog.state, 'weather');
  end;
end;

end.
