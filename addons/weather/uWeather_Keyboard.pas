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
      uWeather_Config_Towns_Add_Free
    else if UpperCase(vKey) = 'ENTER' then
      uWeather_Config_Towns_Add_FindTown(vWeather.Config.Main.Right.Towns.Add.Main.FindTown_V.Text);
  end
  else if extrafe.prog.State = 'addon_weather_config' then
  begin
    if UpperCase(vKey) = 'S' then
      uWeather_Config_ShowHide(False)
    else if UpperCase(vKey) = 'UP' then
    begin
      if addons.weather.Config.Edit_Lock then
        if addons.weather.Config.Selected_Town <> 0 then
          uWeather_Config_Towns_Edit_SelectTown(addons.weather.Config.Selected_Town - 1)
    end
    else if UpperCase(vKey) = 'DOWN' then
    begin
      if addons.weather.Config.Edit_Lock then
        if addons.weather.Config.Selected_Town <> addons.weather.Action.Active_Total then
          uWeather_Config_Towns_Edit_SelectTown(addons.weather.Config.Selected_Town + 1)
    end;
  end
  else if extrafe.prog.State = 'addon_weather' then
  begin
    vi := addons.weather.Main_Menu_Position;
    if UpperCase(vKey) = 'LEFT' then
      uWeather_MenuActions_SlideLeft
    else if UpperCase(vKey) = 'RIGHT' then
      uWeather_MenuActions_SlideRight
    else if UpperCase(vKey) = 'S' then
      uWeather_Config_ShowHide(True)
    else if UpperCase(vKey) = IntToStr(vi + 1) then
      uMain_Actions_ShowHide_Addons(1000 + vi);
  end;
end;

end.
