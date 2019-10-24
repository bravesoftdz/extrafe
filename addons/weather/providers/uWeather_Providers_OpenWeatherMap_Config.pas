unit uWeather_Providers_OpenWeatherMap_Config;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UiTypes,
  System.Math,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Edit,
  FMX.Layouts,
  FMX.Effects,
  FMX.ListBox,
  FMX.Types,
  uWeather_Config_Towns,
  ALFMXObjects;

procedure Load;
procedure Load_Config;
procedure Load_Default_Config;

procedure Create_Towns;
procedure Towns_Add_New_Town(vNumPanel: Integer; vNewTown: TADDON_WEATHER_CONFIG_TOWNS_NEWTOWNPANEL);
procedure Towns_Go_To(vDirection: String);


procedure Create_Options;
procedure Options_Check_System_Type(vSystem_Type: String);
procedure Options_Lock(vLock: Boolean);

procedure Create_Iconsets;
procedure Create_MiniPreview(vNum: Integer);

implementation

uses
  uWindows,
  uLoad_AllTypes,
  uWeather_AllTypes,
  uWeather_Providers_OpenWeatherMap;

procedure Load;
begin
  addons.weather.Ini.Ini.WriteString('Provider', 'Name', 'openweathermap');
  addons.weather.Action.Provider := 'openweathermap';
  vWeather.Config.main.Right.Provider.Text.Text := 'Selected "Provider" : ' + UpperCase(addons.weather.Action.Provider);
  vWeather.Config.main.Left.Provider.Bitmap.LoadFromFile(addons.weather.Path.Images + 'w_provider_openweathermap.png');
  Load_Config;
end;

procedure Load_Config;
begin
  if addons.weather.Ini.Ini.ValueExists('openweathermap', 'total') then
    addons.weather.Action.OWM.Total_WoeID := addons.weather.Ini.Ini.ReadInteger('openweathermap', 'total', addons.weather.Action.OWM.Total_WoeID)
  else
  begin
    addons.weather.Action.OWM.Total_WoeID := -1;
    addons.weather.Ini.Ini.WriteInteger('openweathermap', 'total', addons.weather.Action.OWM.Total_WoeID);
  end;

  if addons.weather.Ini.Ini.ValueExists('openweathermap', 'selected_unit') then
    addons.weather.Action.OWM.Selected_Unit := addons.weather.Ini.Ini.ReadString('openweathermap', 'selected_unit', addons.weather.Action.OWM.Selected_Unit)
  else
  begin
    addons.weather.Action.OWM.Selected_Unit := 'imperial';
    addons.weather.Ini.Ini.WriteString('openweathermap', 'selected_unit', addons.weather.Action.OWM.Selected_Unit);
  end;

  addons.weather.Action.OWM.Iconset_Names := TStringList.Create;
  addons.weather.Action.OWM.Iconset_Names := uWindows_GetFolderNames(addons.weather.Path.Iconsets + 'openweathermap\');
  addons.weather.Action.OWM.Iconset_Names.Insert(0, 'default');
  if addons.weather.Ini.Ini.ValueExists('openweathermap', 'iconset_count') then
  begin
    addons.weather.Action.OWM.Iconset_Count := addons.weather.Ini.Ini.ReadInteger('openweathermap', 'iconset_count', addons.weather.Action.OWM.Iconset_Count);
    addons.weather.Action.OWM.Iconset_Selected := addons.weather.Ini.Ini.ReadInteger('openweathermap', 'iconset', addons.weather.Action.OWM.Iconset_Selected);
    addons.weather.Action.OWM.Iconset_Name := addons.weather.Ini.Ini.ReadString('openweathermap', 'iconset_name', addons.weather.Action.OWM.Iconset_Name);
  end
  else
  begin
    addons.weather.Action.OWM.Iconset_Count := 1;
    addons.weather.Action.OWM.Iconset_Selected := 0;
    addons.weather.Action.OWM.Iconset_Name := 'default';
    addons.weather.Ini.Ini.WriteInteger('openweathermap', 'iconset_count', addons.weather.Action.OWM.Iconset_Count);
    addons.weather.Ini.Ini.WriteInteger('openweathermap', 'iconset', addons.weather.Action.OWM.Iconset_Selected);
    addons.weather.Ini.Ini.WriteString('openweathermap', 'iconset_name', addons.weather.Action.OWM.Iconset_Name);
  end;

  if addons.weather.Ini.Ini.ValueExists('openweathermap', 'language') then
    addons.weather.Action.OWM.Language := addons.weather.Ini.Ini.ReadString('openweathermap', 'language', addons.weather.Action.OWM.Language)
  else
  begin
    addons.weather.Action.OWM.Language := 'en';
    addons.weather.Ini.Ini.WriteString('openweathermap', 'language', addons.weather.Action.OWM.Language);
  end;

  if addons.weather.Ini.Ini.ValueExists('openweathermap', 'selected_unit') then
    addons.weather.Action.OWM.Selected_Unit := addons.weather.Ini.Ini.ReadString('openweathermap', 'selected_unit', addons.weather.Action.OWM.Selected_Unit);

  uWeather_Providers_OpenWeatherMap.Woeid_List;
end;

procedure Load_Default_Config;
begin
  addons.weather.Action.OWM.Total_WoeID := -1;
  addons.weather.Action.OWM.Selected_Unit := 'metric';
  addons.weather.Action.OWM.Iconset_Count := 0;
  addons.weather.Action.OWM.Iconset_Selected := 0;
  addons.weather.Action.OWM.Iconset_Name := 'default';
  addons.weather.Action.OWM.Language := 'en'
end;

procedure Create_Towns;
var
  vi: Integer;
  vTown: TADDON_WEATHER_CONFIG_TOWNS_NEWTOWNPANEL;
begin
  if addons.weather.Action.OWM.Total_WoeID <> -1 then
  begin
    for vi := 0 to addons.weather.Action.OWM.Total_WoeID do
    begin
      // Get Data
      vTown.Time_Results := ConvertTime(addons.weather.Action.OWM.Data_Town[vi].Current.Date_Time, '').Full;
      vTown.Forecast_Image := Get_Icon_Text(addons.weather.Action.OWM.Data_Town[vi].Current.weather.ID,
      addons.weather.Action.OWM.Data_Town[vi].Current.weather.Icon);
      vTown.Temperature := addons.weather.Action.OWM.Data_Town[addons.weather.Action.OWM.Total_WoeID].Current.main.Temp;
      vTown.Temrerature_Unit := 'C';
      vTown.Temperature_Description := addons.weather.Action.OWM.Data_Town[vi].Current.weather.Description;
      vTown.City_Name := addons.weather.Action.OWM.Data_Town[vi].Current.Name;
      vTown.Country_Name := addons.weather.Action.OWM.Data_Town[vi].Current.sys.country;
      vTown.Country_Flag := Get_Flag(addons.weather.Action.OWM.Data_Town[vi].Five.city.country);
      // Set Data
      Towns_Add_New_Town(vi, vTown);
    end;
  end;
end;

procedure Towns_Add_New_Town(vNumPanel: Integer; vNewTown: TADDON_WEATHER_CONFIG_TOWNS_NEWTOWNPANEL);
begin
  SetLength(vWeather.Config.main.Right.Towns.Town, vNumPanel + 1);

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel := TPanel.Create(vWeather.Config.main.Right.Towns.CityList);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel.Name := 'A_W_Provider_OpenWeatherMap_Config_Towns_CityNum_' + vNumPanel.ToString;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel.Parent := vWeather.Config.main.Right.Towns.CityList;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel.SetBounds(6, 6 + (vNumPanel * 86), vWeather.Config.main.Right.Towns.CityList.Width - 34, 80);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel.Visible := True;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Glow_Panel := TGlowEffect.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Glow_Panel.Name := 'A_W_Provider_OpenWeatherMap_Config_Towns_CityNum_' + vNumPanel.ToString + '_Glow';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Glow_Panel.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Glow_Panel.GlowColor := TAlphaColorRec.Deepskyblue;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Glow_Panel.Opacity := 0.9;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Glow_Panel.Softness := 0.4;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Glow_Panel.Tag := vNumPanel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Glow_Panel.Enabled := False;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Date := TLabel.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Date.Name := 'A_W_Provider_OpenWeatherMap_Config_Towns_CityNum_' + vNumPanel.ToString + '_Date';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Date.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Date.SetBounds(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel.Width - 410, 3, 400, 22);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Date.Text := vNewTown.Time_Results;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Date.StyledSettings := vWeather.Config.main.Right.Towns.Town[vNumPanel].Date.StyledSettings -
    [TStyledSetting.Size];
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Date.Font.Size := 14;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Date.TextSettings.HorzAlign := TTextAlign.Trailing;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Date.Visible := True;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Image := TText.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Image.Name := 'A_W_Provider_OpenWeatherMap_Config_Towns_CityNum_' + vNumPanel.ToString + '_Image';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Image.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Image.SetBounds(6, 6, 60, 60);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Image.Font.Family := 'Weather Icons';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Image.Font.Size := 36;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Image.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Image.Text := vNewTown.Forecast_Image;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Image.Visible := True;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp := TLabel.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp.Name := 'A_W_Provider_OpenWeatherMap_Config_CityNum_' + vNumPanel.ToString + '_Temp';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp.SetBounds(60, 10, 60, 17);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp.Font.Size := 18;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp.Text := vNewTown.Temperature;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp.StyledSettings := vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp.StyledSettings -
    [TStyledSetting.Size];
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp.Visible := True;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Unit := TText.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Unit.Name := 'A_W_Provider_OpenWeatherMap_Config_Tonws_CityNum_' + vNumPanel.ToString + '_Temp_Unit';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Unit.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Unit.SetBounds(80, 8, 18, 18);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Unit.Font.Family := 'Weather Icons';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Unit.Font.Size := 18;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Unit.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Unit.Text := vNewTown.Temrerature_Unit;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Unit.Visible := True;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Comment := TLabel.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Comment.Name := 'A_W_Provider_OpenWeatherMap_Config_Towns_CityNum_' + vNumPanel.ToString +
    '_Temp_Comment';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Comment.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Comment.SetBounds(6, 56, 400, 22);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Comment.Font.Size := 16;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Comment.Text := vNewTown.Temperature_Description;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Comment.StyledSettings := vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Comment.StyledSettings -
    [TStyledSetting.Size];
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Comment.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Comment.Visible := True;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name := TLabel.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name.Name := 'A_W_Provider_OpenWeatherMap_Config_Towns_CityNum_' + vNumPanel.ToString + '_CityName';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name.SetBounds(106, 20, 100, 22);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name.Text := 'Town : ';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name.StyledSettings := vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name.StyledSettings -
    [TStyledSetting.FontColor, TStyledSetting.Size];
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name.Font.Size := 16;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name.Visible := True;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name_V := TLabel.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name_V.Name := 'A_W_Provider_OpenWeatherMap_Config_Towns_CityNum_V_' + vNumPanel.ToString + '_CityName';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name_V.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name_V.SetBounds(174, 20, 400, 22);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name_V.Text := vNewTown.City_Name;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name_V.StyledSettings := vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name_V.StyledSettings -
    [TStyledSetting.Size];
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name_V.Font.Size := 16;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name_V.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name_V.Visible := True;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name := TLabel.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name.Name := 'A_W_Provider_OpenWeatherMap_Config_Towns_CityNum_' + vNumPanel.ToString +
    '_CCountryName';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name.SetBounds(106, 40, 100, 22);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name.Text := 'Country : ';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name.StyledSettings := vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name.StyledSettings -
    [TStyledSetting.FontColor, TStyledSetting.Size];
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name.Font.Size := 16;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name.Visible := True;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name_V := TLabel.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name_V.Name := 'A_W_Provider_OpenWeatherMap_Config_Towns_CityNum_V_' + vNumPanel.ToString +
    '_CCountryName';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name_V.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name_V.SetBounds(174, 40, 400, 22);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name_V.Text := vNewTown.Country_Name;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name_V.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name_V.StyledSettings := vWeather.Config.main.Right.Towns.Town[vNumPanel]
    .Country_Name_V.StyledSettings - [TStyledSetting.Size];
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name_V.Font.Size := 16;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name_V.Visible := True;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Flag := TImage.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Flag.Name := 'A_W_Provider_OpenWeatherMap_Config_Towns_CityNum_' + vNumPanel.ToString +
    '_CountryFlag';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Flag.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Flag.SetBounds(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel.Width - 65,
    vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel.Height - 55, 60, 50);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Flag.Bitmap := vNewTown.Country_Flag;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Flag.Visible := True;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel_Above := TPanel.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel_Above.Name := 'A_W_Provider_OpenWeatherMap_Config_Towns_CityNum_Above_' + vNumPanel.ToString;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel_Above.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel_Above.SetBounds(0, 0, vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel.Width,
    vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel.Height);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel_Above.Opacity := 0;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel_Above.OnClick := addons.weather.Input.mouse_config.Panel.OnMouseClick;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel_Above.OnMouseEnter := addons.weather.Input.mouse_config.Panel.OnMouseEnter;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel_Above.OnMouseLeave := addons.weather.Input.mouse_config.Panel.OnMouseLeave;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel_Above.Tag := vNumPanel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel_Above.Visible := True;
end;

procedure Towns_Go_To(vDirection: String);
var
  vTemp_Pos: Integer;
  vTemp_Data_Town_1, vTemp_Data_Town_2: TADDON_WEATHER_PROVIDER_YAHOO_DATATOWN;
  vTemp_Ini_Town: String;
  vi: Integer;
  vCondition: Boolean;
begin
  if vDirection = 'up' then
    if uWeather_Config_Towns.vSelectedTown <> 0 then
      vCondition := True;

  if vDirection = 'down' then
    if uWeather_Config_Towns.vSelectedTown <> addons.weather.Action.Yahoo.Total_WoeID then
      vCondition := True;

  if vCondition then
  begin
    // Change the position in memory list
    vTemp_Pos := uWeather_Config_Towns.vSelectedTown;
    if vDirection = 'up' then
      Dec(vTemp_Pos, 1)
    else if vDirection = 'down' then
      Inc(vTemp_Pos, 1);

//    vTemp_Data_Town_1 := addons.weather.Action.OWM.Data_Town[uWeather_Config_Towns.vSelectedTown];
//    vTemp_Data_Town_2 := addons.weather.Action.OWM.Data_Town[vTemp_Pos];

//    addons.weather.Action.OWM.Data_Town[uWeather_Config_Towns.vSelectedTown] := vTemp_Data_Town_2;
//    addons.weather.Action.OWM.Data_Town[vTemp_Pos] := vTemp_Data_Town_1;

    // Change the position to ini
    // Change Woeid List
    vTemp_Ini_Town := addons.weather.Action.OWM.Woeid_List.Strings[uWeather_Config_Towns.vSelectedTown];
    addons.weather.Action.OWM.Woeid_List.Delete(uWeather_Config_Towns.vSelectedTown);
    addons.weather.Action.OWM.Woeid_List.Insert(vTemp_Pos, vTemp_Ini_Town);
    // Change Town List
    vTemp_Ini_Town := addons.weather.Action.OWM.Towns_List.Strings[uWeather_Config_Towns.vSelectedTown];
    addons.weather.Action.OWM.Towns_List.Delete(uWeather_Config_Towns.vSelectedTown);
    addons.weather.Action.OWM.Towns_List.Insert(vTemp_Pos, vTemp_Ini_Town);

    for vi := 0 to addons.weather.Action.OWM.Total_WoeID do
      addons.weather.Ini.Ini.DeleteKey('openweathermap', 'woeid_' + vi.ToString);
    for vi := 0 to addons.weather.Action.OWM.Total_WoeID do
      addons.weather.Ini.Ini.WriteString('openweathermap', 'woeid_' + vi.ToString, addons.weather.Action.Yahoo.Woeid_List[vi] + '_' +
        addons.weather.Action.OWM.Towns_List[vi]);

    // Change the position to main
//    uWeather_Providers_Yahoo.Apply_New_Forecast_To_Tonw(addons.weather.Action.Yahoo.Data_Town[vTemp_Pos], vTemp_Pos);
//    if vDirection = 'up' then
//      uWeather_Providers_Yahoo.Apply_New_Forecast_To_Tonw(addons.weather.Action.Yahoo.Data_Town[vTemp_Pos + 1], vTemp_Pos + 1)
//    else if vDirection = 'down' then
//      uWeather_Providers_Yahoo.Apply_New_Forecast_To_Tonw(addons.weather.Action.Yahoo.Data_Town[vTemp_Pos - 1], vTemp_Pos - 1);

    // Change the panel position
//    for vi := 0 to addons.weather.Action.Yahoo.Total_WoeID do
//    begin
//      vWeather.Config.main.Right.Towns.Town[vi].Date.Text := Convert_Time(addons.weather.Action.Yahoo.Data_Town[vi].Observation.LocalTime.TimeStamp,
//        addons.weather.Action.Yahoo.Data_Town[vi].Observation.LocalTime.WeekDay).Full;
//      vWeather.Config.main.Right.Towns.Town[vi].Image.Text := Get_Icon_From_Text(addons.weather.Action.Yahoo.Data_Town[vi].Observation.ConditionCode);
//      vWeather.Config.main.Right.Towns.Town[vi].Temp.Text := addons.weather.Action.Yahoo.Data_Town[vi].Observation.Tempreture.Now;
//      vWeather.Config.main.Right.Towns.Town[vi].Temp_Unit.Text := Get_Unit(addons.weather.Action.Yahoo.Data_Town[vi].vUnit);
//      vWeather.Config.main.Right.Towns.Town[vi].Temp_Comment.Text := addons.weather.Action.Yahoo.Data_Town[vi].Observation.ConditionDescription;
//      vWeather.Config.main.Right.Towns.Town[vi].City_Name_V.Text := addons.weather.Action.Yahoo.Data_Town[vi].Location.City_Name;
//      vWeather.Config.main.Right.Towns.Town[vi].Country_Name_V.Text := addons.weather.Action.Yahoo.Data_Town[vi].Location.Country_Name;
//      vWeather.Config.main.Right.Towns.Town[vi].Country_Flag.Bitmap := Get_Flag(addons.weather.Action.Yahoo.Data_Town[vi].Location.Country_Name);
//    end;
//
//    // Show Results
//    vWeather.Scene.Blur.Enabled := False;
//    vWeather.Scene.Blur.Enabled := True;
//    uWeather_Config_Towns.vSelectedTown := vTemp_Pos;
//    for vi := 0 to addons.weather.Action.Yahoo.Total_WoeID do
//    begin
//      vWeather.Config.main.Right.Towns.Town[vi].Glow_Panel.Enabled := False;
//      vWeather.Config.main.Right.Towns.Town[vi].Glow_Panel.GlowColor := TAlphaColorRec.Deepskyblue;
//    end;
//    vWeather.Config.main.Right.Towns.Town[uWeather_Config_Towns.vSelectedTown].Glow_Panel.Enabled := True;
//    vWeather.Config.main.Right.Towns.Town[uWeather_Config_Towns.vSelectedTown].Glow_Panel.GlowColor := TAlphaColorRec.Red;
//    Towns_Update_Arrows;
  end;
end;

/// /////////////
procedure Create_Options;
begin
  vWeather.Config.main.Right.Panels[2] := TPanel.Create(vWeather.Config.main.Right.Panel);
  vWeather.Config.main.Right.Panels[2].Name := 'Weather_Config_Panels_2';
  vWeather.Config.main.Right.Panels[2].Parent := vWeather.Config.main.Right.Panel;
  vWeather.Config.main.Right.Panels[2].Align := TAlignLayout.Client;
  vWeather.Config.main.Right.Panels[2].Visible := True;

  vWeather.Config.main.Right.Options_OWM.System_Type := TGroupBox.Create(vWeather.Config.main.Right.Panels[2]);
  vWeather.Config.main.Right.Options_OWM.System_Type.Name := 'A_W_Providers_OpenWeatherMap_Config_Options_Degree_Groupbox';
  vWeather.Config.main.Right.Options_OWM.System_Type.Parent := vWeather.Config.main.Right.Panels[2];
  vWeather.Config.main.Right.Options_OWM.System_Type.SetBounds(10, 10, vWeather.Config.main.Right.Panels[2].Width - 20, 100);
  vWeather.Config.main.Right.Options_OWM.System_Type.Text := 'Weather System Type';
  vWeather.Config.main.Right.Options_OWM.System_Type.Visible := True;

  vWeather.Config.main.Right.Options_OWM.Type_Text := TALText.Create(vWeather.Config.main.Right.Options_OWM.System_Type);
  vWeather.Config.main.Right.Options_OWM.Type_Text.Name := 'A_W_Provider_Yahoo_Config_System_Text';
  vWeather.Config.main.Right.Options_OWM.Type_Text.Parent := vWeather.Config.main.Right.Options_OWM.System_Type;
  vWeather.Config.main.Right.Options_OWM.Type_Text.SetBounds(20, 10, vWeather.Config.main.Right.Options_OWM.System_Type.Width - 40, 60);
  vWeather.Config.main.Right.Options_OWM.Type_Text.Text :=
    'Select <font color="#f21212"><b>Imperial</b></font> (Fahrenheit, inHG, Miles) or <font color="#f21212"><b>Metric</b></font> (Celcius, mb, Kmph) as a default start up system';
  vWeather.Config.main.Right.Options_OWM.Type_Text.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Config.main.Right.Options_OWM.Type_Text.TextIsHtml := True;
  vWeather.Config.main.Right.Options_OWM.Type_Text.WordWrap := True;
  vWeather.Config.main.Right.Options_OWM.Type_Text.Visible := True;

  vWeather.Config.main.Right.Options_OWM.Metric := TCheckBox.Create(vWeather.Config.main.Right.Options_OWM.System_Type);
  vWeather.Config.main.Right.Options_OWM.Metric.Name := 'A_W_Providers_OpenWeatherMap_Config_Options_Metric_Checkbox';
  vWeather.Config.main.Right.Options_OWM.Metric.Parent := vWeather.Config.main.Right.Options_OWM.System_Type;
  vWeather.Config.main.Right.Options_OWM.Metric.SetBounds(20, 70, 200, 20);
  vWeather.Config.main.Right.Options_OWM.Metric.Text := 'Metric';
  if addons.weather.Action.OWM.Selected_Unit = 'metric' then
    vWeather.Config.main.Right.Options_OWM.Metric.IsChecked := True;
  vWeather.Config.main.Right.Options_OWM.Metric.Font.Style := vWeather.Config.main.Right.Options_OWM.Metric.Font.Style + [TFontStyle.fsBold];
  vWeather.Config.main.Right.Options_OWM.Metric.OnClick := addons.weather.Input.mouse_config.Checkbox.OnMouseClick;
  vWeather.Config.main.Right.Options_OWM.Metric.OnMouseEnter := addons.weather.Input.mouse_config.Checkbox.OnMouseEnter;
  vWeather.Config.main.Right.Options_OWM.Metric.OnMouseLeave := addons.weather.Input.mouse_config.Checkbox.OnMouseLeave;
  vWeather.Config.main.Right.Options_OWM.Metric.Visible := True;

  vWeather.Config.main.Right.Options_OWM.Imperial := TCheckBox.Create(vWeather.Config.main.Right.Options_OWM.System_Type);
  vWeather.Config.main.Right.Options_OWM.Imperial.Name := 'A_W_Providers_OpenWeatherMap_Config_Options_Imperial_Checkbox';
  vWeather.Config.main.Right.Options_OWM.Imperial.Parent := vWeather.Config.main.Right.Options_OWM.System_Type;
  vWeather.Config.main.Right.Options_OWM.Imperial.SetBounds(vWeather.Config.main.Right.Options_OWM.System_Type.Width - 210, 70, 200, 20);
  vWeather.Config.main.Right.Options_OWM.Imperial.Text := 'Imperial';
  if addons.weather.Action.OWM.Selected_Unit = 'imperial' then
    vWeather.Config.main.Right.Options_OWM.Imperial.IsChecked := True;
  vWeather.Config.main.Right.Options_OWM.Imperial.Font.Style := vWeather.Config.main.Right.Options_OWM.Imperial.Font.Style + [TFontStyle.fsBold];
  vWeather.Config.main.Right.Options_OWM.Imperial.OnClick := addons.weather.Input.mouse_config.Checkbox.OnMouseClick;
  vWeather.Config.main.Right.Options_OWM.Imperial.OnMouseEnter := addons.weather.Input.mouse_config.Checkbox.OnMouseEnter;
  vWeather.Config.main.Right.Options_OWM.Imperial.OnMouseLeave := addons.weather.Input.mouse_config.Checkbox.OnMouseLeave;
  vWeather.Config.main.Right.Options_OWM.Imperial.Visible := True;

  vWeather.Config.main.Right.Options_OWM.MultiLanguage := TGroupBox.Create(vWeather.Config.main.Right.Panels[2]);
  vWeather.Config.main.Right.Options_OWM.MultiLanguage.Name := 'A_W_Providers_OpenWeatherMap_Config_MultiLanguage_Groupbox';
  vWeather.Config.main.Right.Options_OWM.MultiLanguage.Parent := vWeather.Config.main.Right.Panels[2];
  vWeather.Config.main.Right.Options_OWM.MultiLanguage.SetBounds(10, 130, vWeather.Config.main.Right.Panels[2].Width - 20, 100);
  vWeather.Config.main.Right.Options_OWM.MultiLanguage.Text := 'Language';
  vWeather.Config.main.Right.Options_OWM.MultiLanguage.Visible := True;

  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Text := TLabel.Create(vWeather.Config.main.Right.Options_OWM.MultiLanguage);
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Text.Name := 'A_W_Providers_OpenWeatherMap_Config_Options_MultiLanguage_Text';
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Text.Parent := vWeather.Config.main.Right.Options_OWM.MultiLanguage;
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Text.SetBounds(10, 30, 200, 20);
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Text.Text := 'Choose a language : ';
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Text.Visible := True;

  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select := TComboBox.Create(vWeather.Config.main.Right.Options_OWM.MultiLanguage);
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Name := 'A_W_Providers_OpenWeatherMap_Config_Options_MultiLanguage_Select';
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Parent := vWeather.Config.main.Right.Options_OWM.MultiLanguage;
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.SetBounds(10, 50, vWeather.Config.main.Right.Options_OWM.MultiLanguage.Width / 2, 30);
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Arabic');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Bulgarian');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Catalan');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Czech');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('German');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Ellinika');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('English');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Persian (Farsi)');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Finnish');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('French');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Galician');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Croatian');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Hungarian');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Italian');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Japanese');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Korean');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Latvian');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Lithuanian');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Skopje');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Dutch');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Polish');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Portuguese');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Romanian');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Russian');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Swedish');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Slovak');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Slovenian');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Spanish');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Turkish');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Ukrainian');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Vietnamese');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Chinese Simplified');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Items.Add('Chinese Traditional');
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.ItemIndex := uWeather_Providers_OpenWeatherMap.Get_Language_Num
    (addons.weather.Action.OWM.Language);
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.OnChange := addons.weather.Input.mouse_config.Combobox.OnChange;
  vWeather.Config.main.Right.Options_OWM.MultiLanguage_Select.Visible := True;

  vWeather.Config.main.Right.Options_OWM.API := TGroupBox.Create(vWeather.Config.main.Right.Panels[2]);
  vWeather.Config.main.Right.Options_OWM.API.Name := 'A_W_Providers_OpenWeatherMap_Config_Options_API_Groupbox';
  vWeather.Config.main.Right.Options_OWM.API.Parent := vWeather.Config.main.Right.Panels[2];
  vWeather.Config.main.Right.Options_OWM.API.SetBounds(10, 240, vWeather.Config.main.Right.Panels[2].Width - 20, 200);
  vWeather.Config.main.Right.Options_OWM.API.Text := 'API Configuration Key';
  vWeather.Config.main.Right.Options_OWM.API.Visible := True;

  vWeather.Config.main.Right.Options_OWM.API_Lock := TText.Create(vWeather.Config.main.Right.Options_OWM.API);
  vWeather.Config.main.Right.Options_OWM.API_Lock.Name := 'A_W_Providers_OpenWeatherMap_Config_Options_API_Lock';
  vWeather.Config.main.Right.Options_OWM.API_Lock.Parent := vWeather.Config.main.Right.Options_OWM.API;
  vWeather.Config.main.Right.Options_OWM.API_Lock.SetBounds(vWeather.Config.main.Right.Options_OWM.API.Width - 12, -6, 24, 24);
  vWeather.Config.main.Right.Options_OWM.API_Lock.Font.Family := 'IcoMoon-Free';
  vWeather.Config.main.Right.Options_OWM.API_Lock.Font.Size := 18;
  vWeather.Config.main.Right.Options_OWM.API_Lock.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Config.main.Right.Options_OWM.API_Lock.Text := #$e98f;
  vWeather.Config.main.Right.Options_OWM.API_Lock.OnClick := addons.weather.Input.mouse_config.Text.OnMouseClick;
  vWeather.Config.main.Right.Options_OWM.API_Lock.OnMouseEnter := addons.weather.Input.mouse_config.Text.OnMouseEnter;
  vWeather.Config.main.Right.Options_OWM.API_Lock.OnMouseLeave := addons.weather.Input.mouse_config.Text.OnMouseLeave;
  vWeather.Config.main.Right.Options_OWM.API_Lock.Visible := True;

  vWeather.Config.main.Right.Options_OWM.API_Lock_Glow := TGlowEffect.Create(vWeather.Config.main.Right.Options_OWM.API_Lock);
  vWeather.Config.main.Right.Options_OWM.API_Lock_Glow.Name := 'A_W_Providers_OpenWeatherMap_Config_Options_API_Lock_Glow';
  vWeather.Config.main.Right.Options_OWM.API_Lock_Glow.Parent := vWeather.Config.main.Right.Options_OWM.API_Lock;
  vWeather.Config.main.Right.Options_OWM.API_Lock_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vWeather.Config.main.Right.Options_OWM.API_Lock_Glow.Opacity := 0.9;
  vWeather.Config.main.Right.Options_OWM.API_Lock_Glow.Enabled := False;

  vWeather.Config.main.Right.Options_OWM.API_Text := TLabel.Create(vWeather.Config.main.Right.Options_OWM.API);
  vWeather.Config.main.Right.Options_OWM.API_Text.Name := 'A_W_Providers_OpenWeatherMap_Config_Options_API_Text';
  vWeather.Config.main.Right.Options_OWM.API_Text.Parent := vWeather.Config.main.Right.Options_OWM.API;
  vWeather.Config.main.Right.Options_OWM.API_Text.SetBounds(10, 36, 200, 20);
  vWeather.Config.main.Right.Options_OWM.API_Text.Text := 'User''s API Key : ';
  vWeather.Config.main.Right.Options_OWM.API_Text.Visible := True;

  vWeather.Config.main.Right.Options_OWM.API_Key := TEdit.Create(vWeather.Config.main.Right.Options_OWM.API);
  vWeather.Config.main.Right.Options_OWM.API_Key.Name := 'A_W_Providers_OpenWeatherMap_Config_Options_API_Key';
  vWeather.Config.main.Right.Options_OWM.API_Key.Parent := vWeather.Config.main.Right.Options_OWM.API;
  vWeather.Config.main.Right.Options_OWM.API_Key.SetBounds(100, 35, vWeather.Config.main.Right.Options_OWM.API.Width - 110, 22);
  vWeather.Config.main.Right.Options_OWM.API_Key.Enabled := False;
  vWeather.Config.main.Right.Options_OWM.API_Key.Visible := True;

  vWeather.Config.main.Right.Options_OWM.API_Desc := TALText.Create(vWeather.Config.main.Right.Options_OWM.API);
  vWeather.Config.main.Right.Options_OWM.API_Desc.Name := 'A_W_Providers_OpenWeatherMap_Config_Options_API_Desc';
  vWeather.Config.main.Right.Options_OWM.API_Desc.Parent := vWeather.Config.main.Right.Options_OWM.API;
  vWeather.Config.main.Right.Options_OWM.API_Desc.SetBounds(10, 70, vWeather.Config.main.Right.Options_OWM.API.Width - 20, 80);
  vWeather.Config.main.Right.Options_OWM.API_Desc.TextIsHtml := True;
  vWeather.Config.main.Right.Options_OWM.API_Desc.WordWrap := True;
  vWeather.Config.main.Right.Options_OWM.API_Desc.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Config.main.Right.Options_OWM.API_Desc.Text :=
    'The <font color="#ff63cbfc"><b>API Key</b></font> is used is provided by the creator of <font color="#ff63cbfc"><b>ExtraFE</b></font> personal key, so the calls to '
    + '<font color="#ffff7815"><b>openweathermap</b></font> provider is limited if all active users calls it.' + #13#10 +
    'The best way to have the full free personal expirience of <font color="#ffff7815"><b>openweathermap</b></font> provider is to go to the <font color="#fffb0000"><b>link</b></font> below and get your own personal '
    + '<font color="#ff63cbfc"><b>API Key</b></font> and paste it in the edit box above.';
  vWeather.Config.main.Right.Options_OWM.API_Desc.Enabled := False;
  vWeather.Config.main.Right.Options_OWM.API_Desc.Visible := True;

  addons.weather.Action.OWM.Options_Lock := True;

  vWeather.Config.main.Right.Options_OWM.API_Link := TText.Create(vWeather.Config.main.Right.Options_OWM.API);
  vWeather.Config.main.Right.Options_OWM.API_Link.Name := 'A_W_Providers_OpenWeatherMap_Config_Options_API_Link';
  vWeather.Config.main.Right.Options_OWM.API_Link.Parent := vWeather.Config.main.Right.Options_OWM.API;
  vWeather.Config.main.Right.Options_OWM.API_Link.SetBounds(10, 160, 200, 20);
  vWeather.Config.main.Right.Options_OWM.API_Link.Text := 'https://openweathermap.org/appid';
  vWeather.Config.main.Right.Options_OWM.API_Link.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Config.main.Right.Options_OWM.API_Link.HorzTextAlign := TTextAlign.Leading;
  vWeather.Config.main.Right.Options_OWM.API_Link.OnClick := addons.weather.Input.mouse_config.Text.OnMouseClick;
  vWeather.Config.main.Right.Options_OWM.API_Link.OnMouseEnter := addons.weather.Input.mouse_config.Text.OnMouseEnter;
  vWeather.Config.main.Right.Options_OWM.API_Link.OnMouseLeave := addons.weather.Input.mouse_config.Text.OnMouseLeave;
  vWeather.Config.main.Right.Options_OWM.API_Link.Enabled := False;
  vWeather.Config.main.Right.Options_OWM.API_Link.Visible := True;

  vWeather.Config.main.Right.Options_OWM.Selected_System_Type := TLabel.Create(vWeather.Config.main.Right.Panels[2]);
  vWeather.Config.main.Right.Options_OWM.Selected_System_Type.Name := 'A_W_Providers_OpenWeatherMap_Config_Options_Selected_System_Type';
  vWeather.Config.main.Right.Options_OWM.Selected_System_Type.Parent := vWeather.Config.main.Right.Panels[2];
  vWeather.Config.main.Right.Options_OWM.Selected_System_Type.SetBounds(10, vWeather.Config.main.Right.Panels[2].Height - 50, 300, 20);
  vWeather.Config.main.Right.Options_OWM.Selected_System_Type.Text := 'Selected System Type : ' + addons.weather.Action.OWM.Selected_Unit;
  vWeather.Config.main.Right.Options_OWM.Selected_System_Type.Visible := True;

  vWeather.Config.main.Right.Options_OWM.Selected_Language := TLabel.Create(vWeather.Config.main.Right.Panels[2]);
  vWeather.Config.main.Right.Options_OWM.Selected_Language.Name := 'A_W_Providers_OpenWeatherMap_Config_Options_Selected_Language';
  vWeather.Config.main.Right.Options_OWM.Selected_Language.Parent := vWeather.Config.main.Right.Panels[2];
  vWeather.Config.main.Right.Options_OWM.Selected_Language.SetBounds(10, vWeather.Config.main.Right.Panels[2].Height - 30, 300, 20);
  vWeather.Config.main.Right.Options_OWM.Selected_Language.Text := 'Selected Language : ' + uWeather_Providers_OpenWeatherMap.Get_Language_From_Short_Desc
    (addons.weather.Action.OWM.Language);
  vWeather.Config.main.Right.Options_OWM.Selected_Language.Visible := True;
end;

procedure Options_Check_System_Type(vSystem_Type: String);
begin
  if vSystem_Type = 'metric' then
  begin
    vWeather.Config.main.Right.Options_OWM.Imperial.IsChecked := False;
  end
  else if vSystem_Type = 'imperial' then
  begin
    vWeather.Config.main.Right.Options_OWM.Metric.IsChecked := False;
  end;
end;

procedure Options_Lock(vLock: Boolean);
begin
  if vLock then
    vWeather.Config.main.Right.Options_OWM.API_Lock.Text := #$e990
  else
    vWeather.Config.main.Right.Options_OWM.API_Lock.Text := #$e98f;
  vWeather.Config.main.Right.Options_OWM.API_Text.Enabled := vLock;
  vWeather.Config.main.Right.Options_OWM.API_Key.Enabled := vLock;
  vWeather.Config.main.Right.Options_OWM.API_Desc.Enabled := vLock;
  vWeather.Config.main.Right.Options_OWM.API_Link.Enabled := vLock;
  addons.weather.Action.OWM.Options_Lock := not vLock;
end;

///
procedure Create_Iconsets;
var
  vi, vl, vt: Integer;
begin
  if vWeather.Config.main.Right.Panels[3] <> nil then
    FreeAndNil(vWeather.Config.main.Right.Panels[3]);

  vWeather.Config.main.Right.Panels[3] := TPanel.Create(vWeather.Config.main.Right.Panel);
  vWeather.Config.main.Right.Panels[3].Name := 'Weather_Config_Panels_3';
  vWeather.Config.main.Right.Panels[3].Parent := vWeather.Config.main.Right.Panel;
  vWeather.Config.main.Right.Panels[3].Align := TAlignLayout.Client;
  vWeather.Config.main.Right.Panels[3].Visible := True;

  vWeather.Config.main.Right.Iconsets.Text := TLabel.Create(vWeather.Config.main.Right.Panels[3]);
  vWeather.Config.main.Right.Iconsets.Text.Name := 'A_W_Providers_OpenWeatherMap_Config_Iconsets_Text';
  vWeather.Config.main.Right.Iconsets.Text.Parent := vWeather.Config.main.Right.Panels[3];
  vWeather.Config.main.Right.Iconsets.Text.SetBounds(10, 10, 300, 20);
  vWeather.Config.main.Right.Iconsets.Text.Text := 'Iconsets preview';
  vWeather.Config.main.Right.Iconsets.Text.Font.Style := vWeather.Config.main.Right.Iconsets.Text.Font.Style + [TFontStyle.fsBold];
  vWeather.Config.main.Right.Iconsets.Text.Visible := True;

  vWeather.Config.main.Right.Iconsets.Full.Back := TText.Create(vWeather.Config.main.Right.Panels[3]);
  vWeather.Config.main.Right.Iconsets.Full.Back.Name := 'A_W_Providers_OpenWeatherMap_Config_Iconsets_Back';
  vWeather.Config.main.Right.Iconsets.Full.Back.Parent := vWeather.Config.main.Right.Panels[3];
  vWeather.Config.main.Right.Iconsets.Full.Back.SetBounds(vWeather.Config.main.Right.Panels[3].Width - 42, 7, 32, 32);
  vWeather.Config.main.Right.Iconsets.Full.Back.Font.Family := 'IcoMoon-Free';
  vWeather.Config.main.Right.Iconsets.Full.Back.Font.Size := 28;
  vWeather.Config.main.Right.Iconsets.Full.Back.Text := #$e967;
  vWeather.Config.main.Right.Iconsets.Full.Back.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Config.main.Right.Iconsets.Full.Back.OnClick := addons.weather.Input.mouse_config.Text.OnMouseClick;
  vWeather.Config.main.Right.Iconsets.Full.Back.OnMouseEnter := addons.weather.Input.mouse_config.Text.OnMouseEnter;
  vWeather.Config.main.Right.Iconsets.Full.Back.OnMouseLeave := addons.weather.Input.mouse_config.Text.OnMouseLeave;
  vWeather.Config.main.Right.Iconsets.Full.Back.Visible := False;

  vWeather.Config.main.Right.Iconsets.Full.Back_Glow := TGlowEffect.Create(vWeather.Config.main.Right.Iconsets.Full.Back);
  vWeather.Config.main.Right.Iconsets.Full.Back_Glow.Name := 'A_W_Providers_OpenWeatherMap_Config_Back_Glow';
  vWeather.Config.main.Right.Iconsets.Full.Back_Glow.Parent := vWeather.Config.main.Right.Iconsets.Full.Back;
  vWeather.Config.main.Right.Iconsets.Full.Back_Glow.Softness := 0.4;
  vWeather.Config.main.Right.Iconsets.Full.Back_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vWeather.Config.main.Right.Iconsets.Full.Back_Glow.Opacity := 0.9;
  vWeather.Config.main.Right.Iconsets.Full.Back_Glow.Enabled := False;

  vWeather.Config.main.Right.Iconsets.Box := TVertScrollBox.Create(vWeather.Config.main.Right.Panels[3]);
  vWeather.Config.main.Right.Iconsets.Box.Name := 'A_W_Providers_OpenWeatherMap_Config_Iconsets_Box';
  vWeather.Config.main.Right.Iconsets.Box.Parent := vWeather.Config.main.Right.Panels[3];
  vWeather.Config.main.Right.Iconsets.Box.SetBounds(10, 50, vWeather.Config.main.Right.Panels[3].Width - 20, vWeather.Config.main.Right.Panels[3].Height - 80);
  vWeather.Config.main.Right.Iconsets.Box.Visible := True;

  vWeather.Config.main.Right.Iconsets.Full.Panel := TPanel.Create(vWeather.Config.main.Right.Panels[3]);
  vWeather.Config.main.Right.Iconsets.Full.Panel.Name := 'A_W_Providers_OpenWeatherMap_Config_Iconsets_Full';
  vWeather.Config.main.Right.Iconsets.Full.Panel.Parent := vWeather.Config.main.Right.Panels[3];
  vWeather.Config.main.Right.Iconsets.Full.Panel.SetBounds(10, 40, vWeather.Config.main.Right.Panels[3].Width - 20,
    vWeather.Config.main.Right.Panels[3].Height - 60);
  vWeather.Config.main.Right.Iconsets.Full.Panel.Visible := False;

  for vi := 0 to 48 do
  begin
    vWeather.Config.main.Right.Iconsets.Full.Images[vi] := TImage.Create(vWeather.Config.main.Right.Iconsets.Full.Panel);
    vWeather.Config.main.Right.Iconsets.Full.Images[vi].Name := 'A_W_Providers_OpenWeatherMap_Config_Iconsets_Full_Image_' + IntToStr(vi);
    vWeather.Config.main.Right.Iconsets.Full.Images[vi].Parent := vWeather.Config.main.Right.Iconsets.Full.Panel;
    case vi of
      7:
        begin
          vt := 64;
          vl := 0;
        end;
      14:
        begin
          vt := 128;
          vl := 0;
        end;
      21:
        begin
          vt := 192;
          vl := 0;
        end;
      28:
        begin
          vt := 256;
          vl := 0;
        end;
      35:
        begin
          vt := 320;
          vl := 0;
        end;
      42:
        begin
          vt := 384;
          vl := 0;
        end;
    end;
    vWeather.Config.main.Right.Iconsets.Full.Images[vi].SetBounds((64 * vl), vt, 64, 64);
    vWeather.Config.main.Right.Iconsets.Full.Images[vi].Visible := True;
    Inc(vl, 1);
  end;

  vl := 0;
  vt := 0;
  for vi := 0 to 48 do
  begin
    vWeather.Config.main.Right.Iconsets.Full.Texts[vi] := TText.Create(vWeather.Config.main.Right.Iconsets.Full.Panel);
    vWeather.Config.main.Right.Iconsets.Full.Texts[vi].Name := 'A_W_Providers_OpenWeatherMap_Config_Iconsets_Full_Text_' + IntToStr(vi);
    vWeather.Config.main.Right.Iconsets.Full.Texts[vi].Parent := vWeather.Config.main.Right.Iconsets.Full.Panel;
    case vi of
      7:
        begin
          vt := 64;
          vl := 0;
        end;
      14:
        begin
          vt := 128;
          vl := 0;
        end;
      21:
        begin
          vt := 192;
          vl := 0;
        end;
      28:
        begin
          vt := 256;
          vl := 0;
        end;
      35:
        begin
          vt := 320;
          vl := 0;
        end;
      42:
        begin
          vt := 384;
          vl := 0;
        end;
    end;
    vWeather.Config.main.Right.Iconsets.Full.Texts[vi].SetBounds((64 * vl), vt, 64, 64);
    vWeather.Config.main.Right.Iconsets.Full.Texts[vi].Font.Family := 'Weather Icons';
    vWeather.Config.main.Right.Iconsets.Full.Texts[vi].Font.Size := 48;
    vWeather.Config.main.Right.Iconsets.Full.Texts[vi].TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    vWeather.Config.main.Right.Iconsets.Full.Texts[vi].Text := '';
    vWeather.Config.main.Right.Iconsets.Full.Texts[vi].Visible := True;
    Inc(vl, 1);
  end;

  for vi := 0 to addons.weather.Action.OWM.Iconset_Count do
    Create_MiniPreview(vi);

end;

procedure Create_MiniPreview(vNum: Integer);
var
  vi: Integer;
begin
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name := TLabel.Create(vWeather.Config.main.Right.Iconsets.Box);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.Name := 'A_W_Providers_OpenWeatherMap_Config_Iconsets_Preview_Name_' + vNum.ToString;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.Parent := vWeather.Config.main.Right.Iconsets.Box;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.SetBounds(10, 2 + (vNum * 68), 300, 20);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.Text := addons.weather.Action.Yahoo.Iconset_Names.Strings[vNum];
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.Font.Style := vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.Font.Style + [TFontStyle.fsBold];
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.Visible := True;

  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel := TPanel.Create(vWeather.Config.main.Right.Iconsets.Box);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.Name := 'A_W_Providers_OpenWeatherMap_Config_Iconsets_Mini_Preview_Panel_' + vNum.ToString;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.Parent := vWeather.Config.main.Right.Iconsets.Box;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.SetBounds(10, 20 + (vNum * 68), vWeather.Config.main.Right.Iconsets.Box.Width - 30, 54);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.OnClick := addons.weather.Input.mouse_config.Panel.OnMouseClick;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.OnMouseEnter := addons.weather.Input.mouse_config.Panel.OnMouseEnter;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.OnMouseLeave := addons.weather.Input.mouse_config.Panel.OnMouseLeave;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.TagString := vNum.ToString;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.Visible := True;

  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel_Glow := TGlowEffect.Create(vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel_Glow.Name := 'A_W_Providers_OpenWeatherMap_Config_Iconsets_Mini_Preview_Panel_Glow_' + vNum.ToString;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel_Glow.Parent := vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel_Glow.Opacity := 0.9;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel_Glow.Softness := 0.4;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel_Glow.Enabled := False;

  if vNum = 0 then
  begin
    for vi := 0 to 8 do
    begin
      vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi] := TText.Create(vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel);
      vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].Name := 'A_W_Providers_OpenWeatherMap_Config_Iconsets_TextImage_' + vNum.ToString + '_' +
        vi.ToString;
      vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].Parent := vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel;
      vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].SetBounds(50 * vi, 2, 50, 50);
      if vi in [0, 8] then
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].Font.Family := 'IcoMoon-Free'
      else
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].Font.Family := 'Weather Icons';
      vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].Font.Size := 32;
      if vi = 8 then
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].Text := #$e9ce
      else
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].Text := uWeather_Providers_OpenWeatherMap.Get_Icon_Text(RandomRange(0, 47).ToString, '');
      vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].Tag := vi;
      vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].TagString := vNum.ToString;
      vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].OnClick := addons.weather.Input.mouse_config.Text.OnMouseClick;
      vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].OnMouseEnter := addons.weather.Input.mouse_config.Text.OnMouseEnter;
      vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].OnMouseLeave := addons.weather.Input.mouse_config.Text.OnMouseLeave;
      vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].Visible := True;

      if vi = 8 then
      begin
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image_Glow := TGlowEffect.Create(vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[8]);
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image_Glow.Name := 'A_W_Providers_OpenWeatherMap_Config_Iconsets_Text_Image_' + vNum.ToString
          + '_Glow';
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image_Glow.Parent := vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[8];
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image_Glow.Opacity := 0.9;
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image_Glow.Softness := 0.4;
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image_Glow.Enabled := False;
      end;
    end;
  end
  else
  begin
    for vi := 0 to 8 do
    begin
      if vi in [0, 8] then
      begin
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi] := TText.Create(vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel);
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].Name := 'A_W_Providers_OpenWeatherMap_Config_Iconsets_TextImage_' + vNum.ToString + '_' +
          vi.ToString;
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].Parent := vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel;
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].SetBounds(50 * vi, 2, 50, 50);
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].Font.Family := 'IcoMoon-Free';
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].Font.Size := 32;
        if vi = 8 then
          vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].Text := #$e9ce
        else
          vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].Text := '';
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].Tag := vi;
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].TagString := vNum.ToString;
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].OnClick := addons.weather.Input.mouse_config.Text.OnMouseClick;
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].OnMouseEnter := addons.weather.Input.mouse_config.Text.OnMouseEnter;
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].OnMouseLeave := addons.weather.Input.mouse_config.Text.OnMouseLeave;
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].Visible := True;

        if vi = 8 then
        begin
          vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image_Glow := TGlowEffect.Create(vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi]);
          vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image_Glow.Name := 'A_W_Providers_OpenWeatherMap_Config_Iconsets_Text_Image_' + vNum.ToString
            + '_Glow';
          vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image_Glow.Parent := vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi];
          vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
          vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image_Glow.Opacity := 0.9;
          vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image_Glow.Softness := 0.4;
          vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image_Glow.Enabled := False;
        end;
      end
      else
      begin
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi] := TImage.Create(vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel);
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].Name := 'A_W_Providers_OpenWeatherMap_Config_Mini_Preview_Image_' + vNum.ToString + '_' +
          vi.ToString;
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].Parent := vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel;
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].SetBounds(50 * vi, 2, 50, 50);
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].Bitmap.LoadFromFile
          (addons.weather.Path.Iconsets + addons.weather.Action.Yahoo.Iconset_Names.Strings[vNum] + '\w_w_' + IntToStr(RandomRange(0, 49)) + '.png');
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].Tag := vi;
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].TagString := vNum.ToString;
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].OnClick := addons.weather.Input.mouse_config.Image.OnMouseClick;
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].OnMouseEnter := addons.weather.Input.mouse_config.Image.OnMouseEnter;
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].OnMouseLeave := addons.weather.Input.mouse_config.Image.OnMouseLeave;
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].Visible := True;
      end;
    end;
  end;

  if addons.weather.Action.Yahoo.Iconset_Selected = vNum then
    vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[0].Text := #$ea10;
end;

end.