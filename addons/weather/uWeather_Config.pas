unit uWeather_Config;

interface

uses
  System.classes;

procedure uWeather_Config_ShowHide(mShow: Boolean);
procedure uWeather_COnfig_ClearConfig;
procedure uWeather_Config_ShowPanel(mPanel: Byte);

implementation

uses
  uLoad_AllTypes,
  uWeather_AllTypes,
  uWeather_Config_Provider,
  uWeather_Config_Towns,
  uWeather_Config_Options,
  uWeather_Config_Iconsets;

procedure uWeather_Config_ShowHide(mShow: Boolean);
begin
  if mShow then
    extrafe.prog.State := 'addon_weather_config'
  else
    extrafe.prog.State := 'addon_weather';
  vWeather.Scene.Blur.Enabled := mShow;
  vWeather.Config.Panel.Visible := mShow;
  if mShow = False then
    uWeather_COnfig_ClearConfig;
  addons.weather.Config.Active_Panel:= -1;
end;

procedure uWeather_COnfig_ClearConfig;
begin
  if Assigned(vWeather.Config.main.Right.Panels[0]) then
    uWeather_Config_Provider_Free
  else if Assigned(vWeather.Config.main.Right.Panels[1]) then
    uWeather_Config_Towns_Free
  else if Assigned(vWeather.Config.main.Right.Panels[2]) then
    uWeather_Config_Options_Free
  else if Assigned(vWeather.Config.main.Right.Panels[3]) then
    uWeather_Config_Iconsets_Free;
end;

procedure uWeather_Config_ShowPanel(mPanel: Byte);
begin
  if addons.weather.Config.Active_Panel <> mPanel then
  begin
    uWeather_COnfig_ClearConfig;
    case mPanel of
      0:
        uWeather_Config_Provider_Show;
      1:
        uWeather_Config_Towns.Load;
      2:
        uWeather_Config_Options_Show;
      3:
        uWeather_Config_Iconsets_Show;
    end;
    addons.weather.Config.Active_Panel := mPanel;
  end;
end;

end.
