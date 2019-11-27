unit uWeather_Providers_Yahoo_Config;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UiTypes,
  System.Math,
  FMX.Forms,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Types,
  FMX.Edit,
  FMX.Effects,
  FMX.Layouts,
  uWeather_Config_Towns,
  ALFmxObjects;

procedure Load;

procedure Load_Config;

procedure Create_Towns;
procedure Towns_Add_New_Town(vNumPanel: Integer; vNewTown: TADDON_WEATHER_CONFIG_TOWNS_NEWTOWNPANEL);
procedure Towns_Update_Arrows;
procedure Towns_Select(vSelected: Integer);
procedure Towns_Go_To(vDirection: String);
procedure Towns_Delete_Question;
procedure Towns_Delete;
procedure Towns_Delete_Cancel;

procedure Create_Options;
procedure Options_Check_System_Type(vType: String);

procedure Create_Iconsets;
procedure Create_MiniPreview(vNum: Integer);
procedure Show_Full_Iconset_Preview(vPreview_Num: Integer);
procedure Close_Full_Iconset_Preview;
procedure Set_New_Iconset_Check(vSelected: Integer);
procedure New_Iconset_Reload(vSelectd: Integer);
procedure Select_Iconset(vSelected: Integer);

procedure Get_Data;

implementation

uses
  uDB,
  uDB_AUser,
  uLoad_AllTypes,
  uWindows,
  uWeather_SetAll,
  uWeather_Providers_Yahoo,
  uWeather_AllTypes,
  uSnippets;

procedure Load;
var
  vi: Integer;
begin
  // Set the values in weather.ini
  // addons.weather.Ini.Ini.WriteString('Provider', 'Name', 'yahoo');
  // addons.weather.Action.Provider := 'yahoo';
  // vWeather.Config.main.Right.Provider.Text.Text := 'Selected "Provider" : ' + UpperCase(addons.weather.Action.Provider);
  // vWeather.Config.main.Left.Provider.Bitmap.LoadFromFile(uDB_AUser.Local.ADDONS.Weather_D.p_Images + 'w_provider_yahoo.png');
  // if yahoo have towns load towns else load default
  Load_Config;
end;

procedure Load_Config;
begin
  { if addons.weather.Ini.Ini.ValueExists('yahoo', 'total') then
    addons.weather.Action.Yahoo.Total_WoeID := addons.weather.Ini.Ini.ReadInteger('yahoo', 'total', addons.weather.Action.Yahoo.Total_WoeID)
    else
    begin
    addons.weather.Action.Yahoo.Total_WoeID := -1;
    addons.weather.Ini.Ini.WriteInteger('yahoo', 'total', addons.weather.Action.Yahoo.Total_WoeID);
    end;
    if addons.weather.Ini.Ini.ValueExists('yahoo', 'selected_unit') then
    addons.weather.Action.Yahoo.Selected_Unit := addons.weather.Ini.Ini.ReadString('yahoo', 'Selected_Unit', addons.weather.Action.Yahoo.Selected_Unit)
    else
    begin
    addons.weather.Action.Yahoo.Selected_Unit := 'imperial';
    addons.weather.Ini.Ini.WriteString('yahoo', 'selected_unit', addons.weather.Action.Yahoo.Selected_Unit);
    end;
    addons.weather.Action.Yahoo.Iconset_Names := TStringList.Create;
    addons.weather.Action.Yahoo.Iconset_Names := uWindows_GetFolderNames(uDB_AUser.Local.ADDONS.Weather_D.p_Icons + 'yahoo');
    addons.weather.Action.Yahoo.Iconset_Names.Insert(0, 'default');
    if addons.weather.Ini.Ini.ValueExists('yahoo', 'iconset_count') then
    begin
    addons.weather.Action.Yahoo.Iconset_Count := addons.weather.Ini.Ini.ReadInteger('yahoo', 'iconset_count', addons.weather.Action.Yahoo.Iconset_Count);
    addons.weather.Action.Yahoo.Iconset_Selected := addons.weather.Ini.Ini.ReadInteger('yahoo', 'iconset', addons.weather.Action.Yahoo.Iconset_Selected);
    addons.weather.Action.Yahoo.Iconset_Name := addons.weather.Ini.Ini.ReadString('yahoo', 'iconset_name', addons.weather.Action.Yahoo.Iconset_Name);
    end
    else
    begin
    addons.weather.Action.Yahoo.Iconset_Count := 3;
    addons.weather.Action.Yahoo.Iconset_Selected := 0;
    addons.weather.Action.Yahoo.Iconset_Name := 'default';
    addons.weather.Ini.Ini.WriteInteger('yahoo', 'iconset_count', 3);
    addons.weather.Ini.Ini.WriteInteger('yahoo', 'iconset', 0);
    addons.weather.Ini.Ini.WriteString('yahoo', 'icoset_name', addons.weather.Action.Yahoo.Iconset_Name);
    end; }
  uWeather_Providers_Yahoo.Woeid_List;
end;

procedure Create_Towns;
var
  vi: Integer;
  vTown: TADDON_WEATHER_CONFIG_TOWNS_NEWTOWNPANEL;
begin
  if uDB_AUser.Local.ADDONS.Weather_D.Yahoo.Towns_Count <> -1 then
  begin
    for vi := 0 to uDB_AUser.Local.ADDONS.Weather_D.Yahoo.Towns_Count do
    begin
      vTown.Time_Results := Convert_Time(addons.weather.Action.Yahoo.Data_Town[vi].Observation.Time.TimeStamp,
        addons.weather.Action.Yahoo.Data_Town[vi].Observation.Time.WeekDay).Full;
      vTown.Forecast_Image := Get_Icon_From_Text(addons.weather.Action.Yahoo.Data_Town[vi].Observation.ConditionCode);
      vTown.Temperature := addons.weather.Action.Yahoo.Data_Town[vi].Observation.Tempreture.Now;
      vTown.Temrerature_Unit := Get_Unit(addons.weather.Action.Yahoo.Data_Town[vi].vUnit);
      vTown.Temperature_Description := addons.weather.Action.Yahoo.Data_Town[vi].Observation.ConditionDescription;
      vTown.City_Name := addons.weather.Action.Yahoo.Data_Town[vi].Location.City_Name;
      vTown.Country_Name := addons.weather.Action.Yahoo.Data_Town[vi].Location.Country_Name;
      vTown.Country_Flag := Get_Flag(addons.weather.Action.Yahoo.Data_Town[vi].Location.Country_Name);
      // Set Data
      Towns_Add_New_Town(vi, vTown);
    end;
  end
  else

end;

procedure Towns_Update_Arrows;
begin
  vWeather.Config.main.Right.Towns.GoUp.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Config.main.Right.Towns.GoDown.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;

  if uWeather_Config_Towns.vSelectedTown = 0 then
    vWeather.Config.main.Right.Towns.GoUp.TextSettings.FontColor := TAlphaColorRec.Grey;
  if uWeather_Config_Towns.vSelectedTown = addons.weather.Action.Yahoo.Total_WoeID then
    vWeather.Config.main.Right.Towns.GoDown.TextSettings.FontColor := TAlphaColorRec.Grey;
end;

procedure Towns_Select(vSelected: Integer);
var
  vi: Integer;
begin
  if vSelected <> uWeather_Config_Towns.vSelectedTown then
  begin
    for vi := 0 to addons.weather.Action.Yahoo.Total_WoeID do
    begin
      vWeather.Config.main.Right.Towns.Town[vi].Glow_Panel.GlowColor := TAlphaColorRec.Deepskyblue;
      vWeather.Config.main.Right.Towns.Town[vi].Glow_Panel.Enabled := False;
    end;

    vWeather.Config.main.Right.Towns.Town[vSelected].Glow_Panel.GlowColor := TAlphaColorRec.Red;
    vWeather.Config.main.Right.Towns.Town[vSelected].Glow_Panel.Enabled := True;

    uWeather_Config_Towns.vSelectedTown := vSelected;
    Towns_Update_Arrows;
  end;
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

    vTemp_Data_Town_1 := addons.weather.Action.Yahoo.Data_Town[uWeather_Config_Towns.vSelectedTown];
    vTemp_Data_Town_2 := addons.weather.Action.Yahoo.Data_Town[vTemp_Pos];

    addons.weather.Action.Yahoo.Data_Town[uWeather_Config_Towns.vSelectedTown] := vTemp_Data_Town_2;
    addons.weather.Action.Yahoo.Data_Town[vTemp_Pos] := vTemp_Data_Town_1;

    // Change the position to ini
    // Change Woeid List
    vTemp_Ini_Town := addons.weather.Action.Yahoo.Woeid_List.Strings[uWeather_Config_Towns.vSelectedTown];
    addons.weather.Action.Yahoo.Woeid_List.Delete(uWeather_Config_Towns.vSelectedTown);
    addons.weather.Action.Yahoo.Woeid_List.Insert(vTemp_Pos, vTemp_Ini_Town);
    // Change Town List
    vTemp_Ini_Town := addons.weather.Action.Yahoo.Towns_List.Strings[uWeather_Config_Towns.vSelectedTown];
    addons.weather.Action.Yahoo.Towns_List.Delete(uWeather_Config_Towns.vSelectedTown);
    addons.weather.Action.Yahoo.Towns_List.Insert(vTemp_Pos, vTemp_Ini_Town);

    { for vi := 0 to addons.weather.Action.Yahoo.Total_WoeID do
      addons.weather.Ini.Ini.DeleteKey('yahoo', 'woeid_' + vi.ToString);
      for vi := 0 to addons.weather.Action.Yahoo.Total_WoeID do
      addons.weather.Ini.Ini.WriteString('yahoo', 'woeid_' + vi.ToString, addons.weather.Action.Yahoo.Woeid_List[vi] + '_' +
      addons.weather.Action.Yahoo.Towns_List[vi]); }

    // Change the position to main
    uWeather_Providers_Yahoo.Apply_New_Forecast_To_Tonw(addons.weather.Action.Yahoo.Data_Town[vTemp_Pos], vTemp_Pos);
    if vDirection = 'up' then
      uWeather_Providers_Yahoo.Apply_New_Forecast_To_Tonw(addons.weather.Action.Yahoo.Data_Town[vTemp_Pos + 1], vTemp_Pos + 1)
    else if vDirection = 'down' then
      uWeather_Providers_Yahoo.Apply_New_Forecast_To_Tonw(addons.weather.Action.Yahoo.Data_Town[vTemp_Pos - 1], vTemp_Pos - 1);

    // Change the panel position
    for vi := 0 to addons.weather.Action.Yahoo.Total_WoeID do
    begin
      vWeather.Config.main.Right.Towns.Town[vi].Date.Text := Convert_Time(addons.weather.Action.Yahoo.Data_Town[vi].Observation.LocalTime.TimeStamp,
        addons.weather.Action.Yahoo.Data_Town[vi].Observation.LocalTime.WeekDay).Full;
      vWeather.Config.main.Right.Towns.Town[vi].Image.Text := Get_Icon_From_Text(addons.weather.Action.Yahoo.Data_Town[vi].Observation.ConditionCode);
      vWeather.Config.main.Right.Towns.Town[vi].Temp.Text := addons.weather.Action.Yahoo.Data_Town[vi].Observation.Tempreture.Now;
      vWeather.Config.main.Right.Towns.Town[vi].Temp_Unit.Text := Get_Unit(addons.weather.Action.Yahoo.Data_Town[vi].vUnit);
      vWeather.Config.main.Right.Towns.Town[vi].Temp_Comment.Text := addons.weather.Action.Yahoo.Data_Town[vi].Observation.ConditionDescription;
      vWeather.Config.main.Right.Towns.Town[vi].City_Name_V.Text := addons.weather.Action.Yahoo.Data_Town[vi].Location.City_Name;
      vWeather.Config.main.Right.Towns.Town[vi].Country_Name_V.Text := addons.weather.Action.Yahoo.Data_Town[vi].Location.Country_Name;
      vWeather.Config.main.Right.Towns.Town[vi].Country_Flag.Bitmap := Get_Flag(addons.weather.Action.Yahoo.Data_Town[vi].Location.Country_Name);
    end;

    // Show Results
    vWeather.Scene.Blur.Enabled := False;
    vWeather.Scene.Blur.Enabled := True;
    uWeather_Config_Towns.vSelectedTown := vTemp_Pos;
    for vi := 0 to addons.weather.Action.Yahoo.Total_WoeID do
    begin
      vWeather.Config.main.Right.Towns.Town[vi].Glow_Panel.Enabled := False;
      vWeather.Config.main.Right.Towns.Town[vi].Glow_Panel.GlowColor := TAlphaColorRec.Deepskyblue;
    end;
    vWeather.Config.main.Right.Towns.Town[uWeather_Config_Towns.vSelectedTown].Glow_Panel.Enabled := True;
    vWeather.Config.main.Right.Towns.Town[uWeather_Config_Towns.vSelectedTown].Glow_Panel.GlowColor := TAlphaColorRec.Red;
    Towns_Update_Arrows;
  end;
end;

procedure Towns_Delete_Question;
begin
  vWeather.Config.Panel_Blur.Enabled := True;
  extrafe.prog.State := 'addon_weather_config_delete_town';

  vWeather.Config.main.Right.Towns.Delete.Panel := TPanel.Create(vWeather.Scene.weather);
  vWeather.Config.main.Right.Towns.Delete.Panel.Name := 'A_W_Providers_Yahoo_Question_Delete_Town';
  vWeather.Config.main.Right.Towns.Delete.Panel.Parent := vWeather.Scene.weather;
  vWeather.Config.main.Right.Towns.Delete.Panel.SetBounds(vWeather.Config.Panel.Position.X + 100, vWeather.Config.Panel.Position.Y + 200, 500, 140);
  vWeather.Config.main.Right.Towns.Delete.Panel.Visible := True;

  CreateHeader(vWeather.Config.main.Right.Towns.Delete.Panel, 'IcoMoon-Free', #$e9ac, 'Delete town "' + addons.weather.Action.Yahoo.Towns_List.Strings
    [uWeather_Config_Towns.vSelectedTown] + '"', False, nil);

  vWeather.Config.main.Right.Towns.Delete.main.Panel := TPanel.Create(vWeather.Config.main.Right.Towns.Delete.Panel);
  vWeather.Config.main.Right.Towns.Delete.main.Panel.Name := 'A_W_Providers_Yahoo_Question_Delete_Town_Main';
  vWeather.Config.main.Right.Towns.Delete.main.Panel.Parent := vWeather.Config.main.Right.Towns.Delete.Panel;
  vWeather.Config.main.Right.Towns.Delete.main.Panel.SetBounds(0, 30, vWeather.Config.main.Right.Towns.Delete.Panel.Width,
    vWeather.Config.main.Right.Towns.Delete.Panel.Height - 30);
  vWeather.Config.main.Right.Towns.Delete.main.Panel.Visible := True;

  vWeather.Config.main.Right.Towns.Delete.main.Icon := TImage.Create(vWeather.Config.main.Right.Towns.Delete.main.Panel);
  vWeather.Config.main.Right.Towns.Delete.main.Icon.Name := 'A_W_Providers_Yahoo_Question_Delete_Town_Main_Icon';
  vWeather.Config.main.Right.Towns.Delete.main.Icon.Parent := vWeather.Config.main.Right.Towns.Delete.main.Panel;
  vWeather.Config.main.Right.Towns.Delete.main.Icon.SetBounds(30, 14, 36, 36);
  vWeather.Config.main.Right.Towns.Delete.main.Icon.Bitmap.LoadFromFile(uDB_AUser.Local.addons.Weather_D.p_Images + 'w_warning.png');
  vWeather.Config.main.Right.Towns.Delete.main.Icon.Visible := True;

  vWeather.Config.main.Right.Towns.Delete.main.Line_1 := TLabel.Create(vWeather.Config.main.Right.Towns.Delete.main.Panel);
  vWeather.Config.main.Right.Towns.Delete.main.Line_1.Name := 'A_W_Providers_Yahoo_Question_Delete_Town_Line_1';
  vWeather.Config.main.Right.Towns.Delete.main.Line_1.Parent := vWeather.Config.main.Right.Towns.Delete.main.Panel;
  vWeather.Config.main.Right.Towns.Delete.main.Line_1.SetBounds(100, 10, 300, 24);
  vWeather.Config.main.Right.Towns.Delete.main.Line_1.Text := 'This action will delete from the list the selected town';
  vWeather.Config.main.Right.Towns.Delete.main.Line_1.Visible := True;

  vWeather.Config.main.Right.Towns.Delete.main.Line_2 := TLabel.Create(vWeather.Config.main.Right.Towns.Delete.main.Panel);
  vWeather.Config.main.Right.Towns.Delete.main.Line_2.Name := 'A_W_Providers_Yahoo_Question_Delete_Town_Line_2';
  vWeather.Config.main.Right.Towns.Delete.main.Line_2.Parent := vWeather.Config.main.Right.Towns.Delete.main.Panel;
  vWeather.Config.main.Right.Towns.Delete.main.Line_2.SetBounds(100, 30, 300, 24);
  vWeather.Config.main.Right.Towns.Delete.main.Line_2.Text := 'Do you want to delete town "' + addons.weather.Action.Yahoo.Towns_List.Strings
    [uWeather_Config_Towns.vSelectedTown] + '"';
  vWeather.Config.main.Right.Towns.Delete.main.Line_2.Visible := True;

  vWeather.Config.main.Right.Towns.Delete.main.Delete := TButton.Create(vWeather.Config.main.Right.Towns.Delete.main.Panel);
  vWeather.Config.main.Right.Towns.Delete.main.Delete.Name := 'A_W_Providers_Yahoo_Question_Delete_Town_Delete';
  vWeather.Config.main.Right.Towns.Delete.main.Delete.Parent := vWeather.Config.main.Right.Towns.Delete.main.Panel;
  vWeather.Config.main.Right.Towns.Delete.main.Delete.SetBounds(100, vWeather.Config.main.Right.Towns.Delete.main.Panel.Height - 34, 100, 24);
  vWeather.Config.main.Right.Towns.Delete.main.Delete.Text := 'Delete';
  vWeather.Config.main.Right.Towns.Delete.main.Delete.OnClick := addons.weather.Input.mouse_config.Button.OnMouseClick;
  vWeather.Config.main.Right.Towns.Delete.main.Delete.OnMouseEnter := addons.weather.Input.mouse_config.Button.OnMouseEnter;
  vWeather.Config.main.Right.Towns.Delete.main.Delete.Visible := True;

  vWeather.Config.main.Right.Towns.Delete.main.Cancel := TButton.Create(vWeather.Config.main.Right.Towns.Delete.main.Panel);
  vWeather.Config.main.Right.Towns.Delete.main.Cancel.Name := 'A_W_Providers_Yahoo_Question_Delete_Town_Cancel';
  vWeather.Config.main.Right.Towns.Delete.main.Cancel.Parent := vWeather.Config.main.Right.Towns.Delete.main.Panel;
  vWeather.Config.main.Right.Towns.Delete.main.Cancel.SetBounds(vWeather.Config.main.Right.Towns.Delete.main.Panel.Width - 200,
    vWeather.Config.main.Right.Towns.Delete.main.Panel.Height - 34, 100, 24);
  vWeather.Config.main.Right.Towns.Delete.main.Cancel.Text := 'Cancel';
  vWeather.Config.main.Right.Towns.Delete.main.Cancel.OnClick := addons.weather.Input.mouse_config.Button.OnMouseClick;
  vWeather.Config.main.Right.Towns.Delete.main.Cancel.OnMouseEnter := addons.weather.Input.mouse_config.Button.OnMouseEnter;
  vWeather.Config.main.Right.Towns.Delete.main.Cancel.Visible := True;
end;

procedure Towns_Delete;
var
  vSelected: Integer;
  vi: Integer;
begin
  vSelected := uWeather_Config_Towns.vSelectedTown;
  // Delete woeid from list
  addons.weather.Action.Yahoo.Woeid_List.Delete(vSelected);
  // Delete town from list
  addons.weather.Action.Yahoo.Towns_List.Delete(vSelected);
  // Delete from ini reorganizend ini
  { for vi := 0 to addons.weather.Action.Yahoo.Total_WoeID do
    addons.weather.Ini.Ini.DeleteKey('yahoo', 'woeid_' + vi.ToString); }

  { Dec(addons.weather.Action.Yahoo.Total_WoeID, 1);
    addons.weather.Ini.Ini.WriteInteger('yahoo', 'total', addons.weather.Action.Yahoo.Total_WoeID);
    for vi := 0 to addons.weather.Action.Yahoo.Total_WoeID do
    addons.weather.Ini.Ini.WriteString('yahoo', 'woeid_' + vi.ToString, addons.weather.Action.Yahoo.Woeid_List[vi] + '_' +
    addons.weather.Action.Yahoo.Towns_List[vi]); }
  // Delete town form main reorganizend main
  for vi := 0 to addons.weather.Action.Yahoo.Total_WoeID + 1 do
  begin
    if vi = addons.weather.Action.Yahoo.Total_WoeID + 1 then
      SetLength(addons.weather.Action.Yahoo.Data_Town, addons.weather.Action.Yahoo.Total_WoeID + 1)
    else if vi >= vSelected then
      addons.weather.Action.Yahoo.Data_Town[vi] := addons.weather.Action.Yahoo.Data_Town[vi + 1];
  end;
  FreeAndNil(vWeather.Scene.Control);
  uWeather_SetAll.Control;
  SetLength(addons.weather.Action.Yahoo.Data_Town, addons.weather.Action.Yahoo.Total_WoeID + 1);
  for vi := 0 to addons.weather.Action.Yahoo.Total_WoeID do
  begin
    Main_Create_Town(addons.weather.Action.Yahoo.Data_Town[vi], vi);
    addons.weather.Action.Yahoo.Data_Town[vi].Photos.Picture_Used_Num := vBest_Img_Num;
  end;
  vWeather.Scene.Control.TabIndex := 0;

  // vWeather.Scene.Control.Delete(vSelected);
  // vWeather.Scene.Control.Tabs[vSelected].DeleteChildren;
  // vWeather.Scene.Control.Tabs[vSelected].Free;

  // Set selected first and blur color first red
  for vi := 0 to addons.weather.Action.Yahoo.Total_WoeID + 1 do
  begin
    if vi = addons.weather.Action.Yahoo.Total_WoeID + 1 then
      FreeAndNil(vWeather.Config.main.Right.Towns.Town[vi])
    else
      FreeAndNil(vWeather.Config.main.Right.Towns.Town[vi].Panel);
  end;

  SetLength(vWeather.Config.main.Right.Towns.Town, 0);
  // uSnippets.Array_Delete_Element(addons.weather.Action.Yahoo.Data_Town, vSelected);
  Create_Towns;
  //
  Dec(addons.weather.Action.Active_WOEID, 1);
  // addons.weather.Ini.Ini.WriteInteger('Active', 'Active_Woeid', addons.weather.Action.Active_WOEID);
  // Check Arrows
  uWeather_Config_Towns.vSelectedTown := 0;
  vWeather.Config.main.Right.Towns.Town[0].Glow_Panel.GlowColor := TAlphaColorRec.Red;
  vWeather.Config.main.Right.Towns.Town[0].Glow_Panel.Enabled := True;
  Towns_Update_Arrows;
  Towns_Delete_Cancel;
end;

procedure Towns_Delete_Cancel;
begin
  vWeather.Config.Panel_Blur.Enabled := False;
  extrafe.prog.State := 'addon_weather_config';
  vWeather.Config.main.Right.Towns.Delete_Glow.Enabled := False;
  FreeAndNil(vWeather.Config.main.Right.Towns.Delete.Panel);
end;

procedure Towns_Add_New_Town(vNumPanel: Integer; vNewTown: TADDON_WEATHER_CONFIG_TOWNS_NEWTOWNPANEL);
begin
  SetLength(vWeather.Config.main.Right.Towns.Town, vNumPanel + 1);

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel := TPanel.Create(vWeather.Config.main.Right.Towns.CityList);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel.Name := 'A_W_Provider_Yahoo_Config_Towns_CityNum_' + vNumPanel.ToString;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel.Parent := vWeather.Config.main.Right.Towns.CityList;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel.SetBounds(6, 6 + (vNumPanel * 86), vWeather.Config.main.Right.Towns.CityList.Width - 34, 80);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel.Visible := True;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Glow_Panel := TGlowEffect.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Glow_Panel.Name := 'A_W_Provider_Yahoo_Config_Towns_CityNum_' + vNumPanel.ToString + '_Glow';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Glow_Panel.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Glow_Panel.GlowColor := TAlphaColorRec.Deepskyblue;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Glow_Panel.Opacity := 0.9;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Glow_Panel.Softness := 0.4;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Glow_Panel.Tag := vNumPanel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Glow_Panel.Enabled := False;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Date := TLabel.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Date.Name := 'A_W_Provider_Yahoo_Config_Towns_CityNum_' + vNumPanel.ToString + '_Date';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Date.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Date.SetBounds(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel.Width - 410, 3, 400, 22);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Date.Text := vNewTown.Time_Results;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Date.StyledSettings := vWeather.Config.main.Right.Towns.Town[vNumPanel].Date.StyledSettings -
    [TStyledSetting.Size];
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Date.Font.Size := 14;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Date.TextSettings.HorzAlign := TTextAlign.Trailing;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Date.Visible := True;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Image := TText.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Image.Name := 'A_W_Provider_Yahoo_Config_Towns_CityNum_' + vNumPanel.ToString + '_Image';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Image.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Image.SetBounds(6, 6, 60, 60);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Image.Font.Family := 'Weather Icons';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Image.Font.Size := 36;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Image.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Image.Text := vNewTown.Forecast_Image;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Image.Visible := True;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp := TLabel.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp.Name := 'A_W_Provider_Yahoo_Config_CityNum_' + vNumPanel.ToString + '_Temp';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp.SetBounds(60, 10, 60, 17);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp.Font.Size := 18;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp.Text := vNewTown.Temperature;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp.StyledSettings := vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp.StyledSettings -
    [TStyledSetting.Size];
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp.Visible := True;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Unit := TText.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Unit.Name := 'A_W_Provider_Yahoo_Config_Tonws_CityNum_' + vNumPanel.ToString + '_Temp_Unit';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Unit.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Unit.SetBounds(80, 8, 18, 18);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Unit.Font.Family := 'Weather Icons';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Unit.Font.Size := 18;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Unit.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Unit.Text := vNewTown.Temrerature_Unit;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Unit.Visible := True;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Comment := TLabel.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Comment.Name := 'A_W_Provider_Yahoo_Config_Towns_CityNum_' + vNumPanel.ToString + '_Temp_Comment';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Comment.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Comment.SetBounds(6, 56, 400, 22);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Comment.Font.Size := 16;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Comment.Text := vNewTown.Temperature_Description;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Comment.StyledSettings := vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Comment.StyledSettings -
    [TStyledSetting.Size];
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Comment.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Temp_Comment.Visible := True;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name := TLabel.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name.Name := 'A_W_Provider_Yahoo_Config_Towns_CityNum_' + vNumPanel.ToString + '_CityName';
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
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name_V.Name := 'A_W_Provider_Yahoo_Config_Towns_CityNum_V_' + vNumPanel.ToString + '_CityName';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name_V.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name_V.SetBounds(174, 20, 400, 22);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name_V.Text := vNewTown.City_Name;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name_V.StyledSettings := vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name_V.StyledSettings -
    [TStyledSetting.Size];
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name_V.Font.Size := 16;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name_V.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].City_Name_V.Visible := True;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name := TLabel.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name.Name := 'A_W_Provider_Yahoo_Config_Towns_CityNum_' + vNumPanel.ToString + '_CCountryName';
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
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name_V.Name := 'A_W_Provider_Yahoo_Config_Towns_CityNum_V_' + vNumPanel.ToString + '_CCountryName';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name_V.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name_V.SetBounds(174, 40, 400, 22);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name_V.Text := vNewTown.Country_Name;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name_V.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name_V.StyledSettings := vWeather.Config.main.Right.Towns.Town[vNumPanel]
    .Country_Name_V.StyledSettings - [TStyledSetting.Size];
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name_V.Font.Size := 16;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Name_V.Visible := True;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Flag := TImage.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Flag.Name := 'A_W_Provider_Yahoo_Config_Towns_CityNum_' + vNumPanel.ToString + '_CountryFlag';
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Flag.Parent := vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Flag.SetBounds(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel.Width - 65,
    vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel.Height - 55, 60, 50);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Flag.Bitmap := vNewTown.Country_Flag;
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Country_Flag.Visible := True;

  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel_Above := TPanel.Create(vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel);
  vWeather.Config.main.Right.Towns.Town[vNumPanel].Panel_Above.Name := 'A_W_Provider_Yahoo_Config_Towns_CityNum_Above_' + vNumPanel.ToString;
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

procedure Options_Check_System_Type(vType: String);
begin
  if vType <> addons.weather.Action.Yahoo.Selected_Unit then
  begin
    if vType = 'metric' then
    begin
      if vWeather.Config.main.Right.Options_Yahoo.Metric.IsChecked = False then
      begin
        vWeather.Config.main.Right.Options_Yahoo.Imperial.IsChecked := False;
        uDB_AUser.Local.addons.Weather_D.Yahoo.System := 'metric';
        uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_WEATHER', 'YAHOO_SYSTEM', 'metric', 'USER_ID', uDB_AUser.Local.Num.ToString);
        uWeather_Providers_Yahoo.Use_Metric;
      end;
    end
    else if vType = 'imperial' then
    begin
      if vWeather.Config.main.Right.Options_Yahoo.Imperial.IsChecked = False then
      begin
        vWeather.Config.main.Right.Options_Yahoo.Metric.IsChecked := False;
        uDB_AUser.Local.addons.Weather_D.Yahoo.System := 'imperial';
        uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_WEATHER', 'YAHOO_SYSTEM', 'imperial', 'USER_ID', uDB_AUser.Local.Num.ToString);
        uWeather_Providers_Yahoo.Use_Imperial;
      end;
    end;
  end;
end;

procedure Create_Options;
begin
  if vWeather.Config.main.Right.Panels[2] <> nil then
    FreeAndNil(vWeather.Config.main.Right.Panels[2]);

  vWeather.Config.main.Right.Panels[2] := TPanel.Create(vWeather.Config.main.Right.Panel);
  vWeather.Config.main.Right.Panels[2].Name := 'Weather_Config_Panels_2';
  vWeather.Config.main.Right.Panels[2].Parent := vWeather.Config.main.Right.Panel;
  vWeather.Config.main.Right.Panels[2].Align := TAlignLayout.Client;
  vWeather.Config.main.Right.Panels[2].Visible := True;

  vWeather.Config.main.Right.Options_Yahoo.System_Type := TGroupBox.Create(vWeather.Config.main.Right.Panels[2]);
  vWeather.Config.main.Right.Options_Yahoo.System_Type.Name := 'A_W_Provider_Yahoo_Config_System_Type';
  vWeather.Config.main.Right.Options_Yahoo.System_Type.Parent := vWeather.Config.main.Right.Panels[2];
  vWeather.Config.main.Right.Options_Yahoo.System_Type.SetBounds(10, 10, vWeather.Config.main.Right.Panels[2].Width - 20, 100);
  vWeather.Config.main.Right.Options_Yahoo.System_Type.Text := 'Weather system type';
  vWeather.Config.main.Right.Options_Yahoo.System_Type.Visible := True;

  vWeather.Config.main.Right.Options_Yahoo.Type_Text := TALText.Create(vWeather.Config.main.Right.Options_Yahoo.System_Type);
  vWeather.Config.main.Right.Options_Yahoo.Type_Text.Name := 'A_W_Provider_Yahoo_Config_System_Text';
  vWeather.Config.main.Right.Options_Yahoo.Type_Text.Parent := vWeather.Config.main.Right.Options_Yahoo.System_Type;
  vWeather.Config.main.Right.Options_Yahoo.Type_Text.SetBounds(20, 20, vWeather.Config.main.Right.Options_Yahoo.System_Type.Width - 40, 60);
  vWeather.Config.main.Right.Options_Yahoo.Type_Text.Text :=
    'Select <font color="#f21212">Imperial</font> (Fahrenheit, inHG, Miles) or <font color="#f21212">Metric</font> (Celcius, mb, Kmph) as a default start up system';
  vWeather.Config.main.Right.Options_Yahoo.Type_Text.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Config.main.Right.Options_Yahoo.Type_Text.TextIsHtml := True;
  vWeather.Config.main.Right.Options_Yahoo.Type_Text.WordWrap := True;
  vWeather.Config.main.Right.Options_Yahoo.Type_Text.Visible := True;

  vWeather.Config.main.Right.Options_Yahoo.Metric := TCheckBox.Create(vWeather.Config.main.Right.Options_Yahoo.System_Type);
  vWeather.Config.main.Right.Options_Yahoo.Metric.Name := 'A_W_Provider_Yahoo_Config_Metric';
  vWeather.Config.main.Right.Options_Yahoo.Metric.Parent := vWeather.Config.main.Right.Options_Yahoo.System_Type;
  vWeather.Config.main.Right.Options_Yahoo.Metric.SetBounds(20, 70, 200, 20);
  vWeather.Config.main.Right.Options_Yahoo.Metric.Text := 'Metric';
  if uDB_AUser.Local.addons.Weather_D.Yahoo.System = 'metric' then
    vWeather.Config.main.Right.Options_Yahoo.Metric.IsChecked := True;
  vWeather.Config.main.Right.Options_Yahoo.Metric.Font.Style := vWeather.Config.main.Right.Options_Yahoo.Metric.Font.Style + [TFontStyle.fsBold];
  vWeather.Config.main.Right.Options_Yahoo.Metric.OnClick := addons.weather.Input.mouse_config.Checkbox.OnMouseClick;
  vWeather.Config.main.Right.Options_Yahoo.Metric.OnMouseEnter := addons.weather.Input.mouse_config.Checkbox.OnMouseEnter;
  vWeather.Config.main.Right.Options_Yahoo.Metric.Visible := True;

  vWeather.Config.main.Right.Options_Yahoo.Imperial := TCheckBox.Create(vWeather.Config.main.Right.Options_Yahoo.System_Type);
  vWeather.Config.main.Right.Options_Yahoo.Imperial.Name := 'A_W_Provider_Yahoo_Config_Imperial';
  vWeather.Config.main.Right.Options_Yahoo.Imperial.Parent := vWeather.Config.main.Right.Options_Yahoo.System_Type;
  vWeather.Config.main.Right.Options_Yahoo.Imperial.SetBounds(vWeather.Config.main.Right.Options_Yahoo.System_Type.Width - 210, 70, 200, 20);
  if uDB_AUser.Local.addons.Weather_D.Yahoo.System = 'imperial' then
    vWeather.Config.main.Right.Options_Yahoo.Imperial.IsChecked := True;
  vWeather.Config.main.Right.Options_Yahoo.Imperial.Text := 'Imperial';
  vWeather.Config.main.Right.Options_Yahoo.Imperial.Font.Style := vWeather.Config.main.Right.Options_Yahoo.Imperial.Font.Style + [TFontStyle.fsBold];
  vWeather.Config.main.Right.Options_Yahoo.Imperial.OnClick := addons.weather.Input.mouse_config.Checkbox.OnMouseClick;
  vWeather.Config.main.Right.Options_Yahoo.Imperial.OnMouseEnter := addons.weather.Input.mouse_config.Checkbox.OnMouseEnter;
  vWeather.Config.main.Right.Options_Yahoo.Imperial.Visible := True;
end;

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
  vWeather.Config.main.Right.Iconsets.Text.Name := 'A_W_Provider_Yahoo_Config_Iconsets_Text';
  vWeather.Config.main.Right.Iconsets.Text.Parent := vWeather.Config.main.Right.Panels[3];
  vWeather.Config.main.Right.Iconsets.Text.SetBounds(10, 10, 300, 20);
  vWeather.Config.main.Right.Iconsets.Text.Text := 'Iconsets preview';
  vWeather.Config.main.Right.Iconsets.Text.Font.Style := vWeather.Config.main.Right.Iconsets.Text.Font.Style + [TFontStyle.fsBold];
  vWeather.Config.main.Right.Iconsets.Text.Visible := True;

  vWeather.Config.main.Right.Iconsets.Full.Back := TText.Create(vWeather.Config.main.Right.Panels[3]);
  vWeather.Config.main.Right.Iconsets.Full.Back.Name := 'A_W_Provider_Yahoo_Config_Iconsets_Back';
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
  vWeather.Config.main.Right.Iconsets.Full.Back_Glow.Name := 'A_W_Provider_Yahoo_Config_Back_Glow';
  vWeather.Config.main.Right.Iconsets.Full.Back_Glow.Parent := vWeather.Config.main.Right.Iconsets.Full.Back;
  vWeather.Config.main.Right.Iconsets.Full.Back_Glow.Softness := 0.4;
  vWeather.Config.main.Right.Iconsets.Full.Back_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vWeather.Config.main.Right.Iconsets.Full.Back_Glow.Opacity := 0.9;
  vWeather.Config.main.Right.Iconsets.Full.Back_Glow.Enabled := False;

  vWeather.Config.main.Right.Iconsets.Box := TVertScrollBox.Create(vWeather.Config.main.Right.Panels[3]);
  vWeather.Config.main.Right.Iconsets.Box.Name := 'A_W_Provider_Yahoo_Config_Iconsets_Box';
  vWeather.Config.main.Right.Iconsets.Box.Parent := vWeather.Config.main.Right.Panels[3];
  vWeather.Config.main.Right.Iconsets.Box.SetBounds(10, 50, vWeather.Config.main.Right.Panels[3].Width - 20, vWeather.Config.main.Right.Panels[3].Height - 80);
  vWeather.Config.main.Right.Iconsets.Box.Visible := True;

  vWeather.Config.main.Right.Iconsets.Full.Panel := TPanel.Create(vWeather.Config.main.Right.Panels[3]);
  vWeather.Config.main.Right.Iconsets.Full.Panel.Name := 'A_W_Provider_Yahoo_Config_Iconsets_Full';
  vWeather.Config.main.Right.Iconsets.Full.Panel.Parent := vWeather.Config.main.Right.Panels[3];
  vWeather.Config.main.Right.Iconsets.Full.Panel.SetBounds(10, 40, vWeather.Config.main.Right.Panels[3].Width - 20,
    vWeather.Config.main.Right.Panels[3].Height - 60);
  vWeather.Config.main.Right.Iconsets.Full.Panel.Visible := False;

  vl := 0;
  vt := 0;
  for vi := 0 to 48 do
  begin
    vWeather.Config.main.Right.Iconsets.Full.Images[vi] := TImage.Create(vWeather.Config.main.Right.Iconsets.Full.Panel);
    vWeather.Config.main.Right.Iconsets.Full.Images[vi].Name := 'A_W_Provider_Yahoo_Config_Iconsets_Full_Image_' + IntToStr(vi);
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
    vWeather.Config.main.Right.Iconsets.Full.Texts[vi].Name := 'A_W_Provider_Yahoo_Config_Iconsets_Full_Text_' + IntToStr(vi);
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

  for vi := 0 to uDB_AUser.Local.ADDONS.Weather_D.Yahoo.Iconset_Count do
    Create_MiniPreview(vi);
end;

procedure Create_MiniPreview(vNum: Integer);
var
  vi: Integer;
begin
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name := TLabel.Create(vWeather.Config.main.Right.Iconsets.Box);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.Name := 'A_W_Provider_Yahoo_Config_Iconsets_Preview_Name_' + vNum.ToString;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.Parent := vWeather.Config.main.Right.Iconsets.Box;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.SetBounds(10, 2 + (vNum * 68), 300, 20);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.Text := uDB_AUser.Local.ADDONS.Weather_D.Yahoo.Iconsets.Strings[vNum];
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.Font.Style := vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.Font.Style + [TFontStyle.fsBold];
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.Visible := True;

  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel := TPanel.Create(vWeather.Config.main.Right.Iconsets.Box);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.Name := 'A_W_Provider_Yahoo_Config_Iconsets_Mini_Preview_Panel_' + vNum.ToString;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.Parent := vWeather.Config.main.Right.Iconsets.Box;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.SetBounds(10, 20 + (vNum * 68), vWeather.Config.main.Right.Iconsets.Box.Width - 30, 54);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.OnClick := addons.weather.Input.mouse_config.Panel.OnMouseClick;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.OnMouseEnter := addons.weather.Input.mouse_config.Panel.OnMouseEnter;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.OnMouseLeave := addons.weather.Input.mouse_config.Panel.OnMouseLeave;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.TagString := vNum.ToString;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.Visible := True;

  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel_Glow := TGlowEffect.Create(vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel_Glow.Name := 'A_W_Provider_Yahoo_Config_Iconsets_Mini_Preview_Panel_Glow_' + vNum.ToString;
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
      vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].Name := 'A_W_Provider_Yahoo_Config_Iconsets_TextImage_' + vNum.ToString + '_' + vi.ToString;
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
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].Text := uWeather_Providers_Yahoo.Get_Icon_From_Text(RandomRange(0, 47).ToString);
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
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image_Glow.Name := 'A_W_Provider_Yahoo_Config_Iconsets_Text_Image_' + vNum.ToString + '_Glow';
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
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image[vi].Name := 'A_W_Provider_Yahoo_Config_Iconsets_TextImage_' + vNum.ToString + '_' +
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
          vWeather.Config.main.Right.Iconsets.Mini[vNum].Text_Image_Glow.Name := 'A_W_Provider_Yahoo_Config_Iconsets_Text_Image_' + vNum.ToString + '_Glow';
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
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].Name := 'A_W_Provider_Yahoo_Config_Iconsets_Mini_Preview_Image_' + vNum.ToString + '_' +
          vi.ToString;
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].Parent := vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel;
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].SetBounds(50 * vi, 2, 50, 50);
        vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].Bitmap.LoadFromFile(uDB_AUser.Local.addons.Weather_D.p_Icons + 'yahoo\' +
          uDB_AUser.Local.ADDONS.Weather_D.Yahoo.Iconsets.Strings[vNum] + '\w_w_' + IntToStr(RandomRange(0, 49)) + '.png');
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

procedure Show_Full_Iconset_Preview(vPreview_Num: Integer);
var
  vi: Integer;
  vPath: String;
begin
  vWeather.Config.main.Right.Iconsets.Box.Visible := False;
  vWeather.Config.main.Right.Iconsets.Full.Panel.Visible := True;
  vWeather.Config.main.Right.Iconsets.Full.Back.Visible := True;
  vPath := uDB_AUser.Local.addons.Weather_D.Yahoo.Iconsets.Strings[vPreview_Num];
  vPath := uDB_AUser.Local.addons.Weather_D.p_Icons + 'yahoo\' + vPath + '\';
  if vPreview_Num <> 0 then
  begin
    for vi := 0 to 48 do
      vWeather.Config.main.Right.Iconsets.Full.Texts[vi].Visible := False;
    for vi := 0 to 48 do
    begin
      vWeather.Config.main.Right.Iconsets.Full.Images[vi].Visible := True;
      vWeather.Config.main.Right.Iconsets.Full.Images[vi].Bitmap.LoadFromFile(vPath + 'w_w_' + IntToStr(vi) + '.png');
    end;
  end
  else
  begin
    for vi := 0 to 48 do
      vWeather.Config.main.Right.Iconsets.Full.Images[vi].Visible := False;
    for vi := 0 to 48 do
    begin
      vWeather.Config.main.Right.Iconsets.Full.Texts[vi].Visible := True;
      if vi = 48 then
        vWeather.Config.main.Right.Iconsets.Full.Texts[vi].Text := uWeather_Providers_Yahoo.Get_Icon_From_Text('3200')
      else
        vWeather.Config.main.Right.Iconsets.Full.Texts[vi].Text := uWeather_Providers_Yahoo.Get_Icon_From_Text(vi.ToString);
    end;
  end;
end;

procedure Close_Full_Iconset_Preview;
begin
  vWeather.Config.main.Right.Iconsets.Box.Visible := True;
  vWeather.Config.main.Right.Iconsets.Full.Panel.Visible := False;
  vWeather.Config.main.Right.Iconsets.Full.Back.Visible := False;
end;

procedure Set_New_Iconset_Check(vSelected: Integer);
var
  vi: Integer;
begin
  for vi := 0 to addons.weather.Action.Yahoo.Iconset_Count do
    vWeather.Config.main.Right.Iconsets.Mini[vi].Text_Image[0].Text := '';
  vWeather.Config.main.Right.Iconsets.Mini[vSelected].Text_Image[0].Text := #$ea10;
end;

procedure New_Iconset_Reload(vSelectd: Integer);
var
  vi: Integer;
  vk: Integer;
begin
  if vSelectd = 0 then
  begin
    // Free Items
    for vi := 0 to addons.weather.Action.Yahoo.Total_WoeID do
    begin
      FreeAndNil(vWeather.Scene.Tab_Yahoo[vi].General.Image);
      for vk := 0 to 24 do
      begin
        if Assigned(vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Icon) then
          FreeAndNil(vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Icon);
      end;
      for vk := 0 to 10 do
      begin
        if Assigned(vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Icon) then
          FreeAndNil(vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Icon);
      end;
    end;
    // Create items
    for vi := 0 to addons.weather.Action.Yahoo.Total_WoeID do
    begin
      vWeather.Scene.Tab_Yahoo[vi].General.Text_Image := TText.Create(vWeather.Scene.Tab_Yahoo[vi].Tab);
      vWeather.Scene.Tab_Yahoo[vi].General.Text_Image.Name := 'A_W_Provider_Yahoo_Text_Image_' + vi.ToString;
      vWeather.Scene.Tab_Yahoo[vi].General.Text_Image.Parent := vWeather.Scene.Tab_Yahoo[vi].Tab;
      vWeather.Scene.Tab_Yahoo[vi].General.Text_Image.SetBounds(50, 60, 150, 150);
      vWeather.Scene.Tab_Yahoo[vi].General.Text_Image.Font.Family := 'Weather Icons';
      vWeather.Scene.Tab_Yahoo[vi].General.Text_Image.Font.Size := 72;
      vWeather.Scene.Tab_Yahoo[vi].General.Text_Image.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      vWeather.Scene.Tab_Yahoo[vi].General.Text_Image.Text := Get_Icon_From_Text(addons.weather.Action.Yahoo.Data_Town[vi].Observation.ConditionCode);
      vWeather.Scene.Tab_Yahoo[vi].General.Text_Image.Visible := True;
      for vk := 0 to 24 do
      begin
        vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Text_Icon := TText.Create(vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Layout);
        vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Text_Icon.Name := 'A_W_Provider_Yahoo_Hourly_Info_Text_Image_' + vk.ToString;
        vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Text_Icon.Parent := vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Layout;
        vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Text_Icon.SetBounds(15, 25, 90, 90);
        vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Text_Icon.Font.Family := 'Weather Icons';
        vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Text_Icon.Font.Size := 48;
        vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Text_Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
        vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Text_Icon.Text :=
          Get_Icon_From_Text(addons.weather.Action.Yahoo.Data_Town[vi].Forcasts.Hourly[vk].ConditionCode);
        vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Text_Icon.Visible := True;
      end;
      for vk := 0 to 10 do
      begin
        vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Text_Icon := TText.Create(vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Layout);
        vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Text_Icon.Name := 'A_W_Provider_Yahoo_Daily_Icon_' + vk.ToString;
        vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Text_Icon.Parent := vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Layout;
        vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Text_Icon.SetBounds(5, 5, 100, 100);
        vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Text_Icon.Font.Family := 'Weather Icons';
        vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Text_Icon.Font.Size := 56;
        vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Text_Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
        vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Text_Icon.Text :=
          Get_Icon_From_Text(addons.weather.Action.Yahoo.Data_Town[vi].Forcasts.Daily[vk].ConditionCode);
        vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Text_Icon.Visible := True;
      end;
    end;
  end
  else
  begin
    // Free items if nessecery
    if Assigned(vWeather.Scene.Tab_Yahoo[0].General.Text_Image) then
    begin
      // Free
      for vi := 0 to addons.weather.Action.Yahoo.Total_WoeID do
      begin
        FreeAndNil(vWeather.Scene.Tab_Yahoo[vi].General.Text_Image);
        for vk := 0 to 24 do
          FreeAndNil(vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Text_Icon);
        for vk := 0 to 10 do
          FreeAndNil(vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Text_Icon);
      end;
      // Create
      for vi := 0 to addons.weather.Action.Yahoo.Total_WoeID do
      begin
        vWeather.Scene.Tab_Yahoo[vi].General.Image := TImage.Create(vWeather.Scene.Tab_Yahoo[vi].Tab);
        vWeather.Scene.Tab_Yahoo[vi].General.Image.Name := 'A_W_Provider_Yahoo_Image_' + IntToStr(vi);
        vWeather.Scene.Tab_Yahoo[vi].General.Image.Parent := vWeather.Scene.Tab_Yahoo[vi].Tab;
        vWeather.Scene.Tab_Yahoo[vi].General.Image.SetBounds(50, 60, 150, 150);
        vWeather.Scene.Tab_Yahoo[vi].General.Image.Bitmap.LoadFromFile(uDB_AUser.Local.addons.Weather_D.p_Icons + 'yahoo\' +
          addons.weather.Action.Yahoo.Iconset_Names.Strings[vSelectd] + '\w_w_' + addons.weather.Action.Yahoo.Data_Town[vi].Observation.ConditionCode + '.png');
        vWeather.Scene.Tab_Yahoo[vi].General.Image.Tag := vi;
        vWeather.Scene.Tab_Yahoo[vi].General.Image.Visible := True;
        for vk := 0 to 24 do
        begin
          vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Icon := TImage.Create(vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Layout);
          vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Icon.Name := 'A_W_Provider_Yahoo_Hourly_Info_Image_' + vk.ToString;
          vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Icon.Parent := vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Layout;
          vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Icon.SetBounds(15, 25, 90, 90);
          vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Icon.Bitmap.LoadFromFile(uDB_AUser.Local.addons.Weather_D.p_Icons + 'yahoo\' +
            addons.weather.Action.Yahoo.Iconset_Names.Strings[vSelectd] + '\w_w_' + addons.weather.Action.Yahoo.Data_Town[vi].Forcasts.Hourly[vk].ConditionCode
            + '.png');
          vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Icon.WrapMode := TImageWrapMode.Fit;
          vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Icon.Visible := True;
        end;
        for vk := 0 to 10 do
        begin
          vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Icon := TImage.Create(vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Layout);
          vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Icon.Name := 'A_W_Provider_Yahoo_Daily_Icon_' + vk.ToString;
          vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Icon.Parent := vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Layout;
          vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Icon.SetBounds(5, 5, 100, 100);
          vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Icon.Bitmap.LoadFromFile(uDB_AUser.Local.addons.Weather_D.p_Icons + 'yahoo\' +
            addons.weather.Action.Yahoo.Iconset_Names.Strings[vSelectd] + '\w_w_' + addons.weather.Action.Yahoo.Data_Town[vi].Forcasts.Daily[vk].ConditionCode
            + '.png');
          vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Icon.WrapMode := TImageWrapMode.Fit;
          vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Icon.Visible := True;
        end;
      end;
    end
    else
    begin
      for vi := 0 to addons.weather.Action.Yahoo.Total_WoeID do
      begin
        vWeather.Scene.Tab_Yahoo[vi].General.Image.Bitmap.LoadFromFile(uDB_AUser.Local.addons.Weather_D.p_Icons + 'yahoo\' +
          addons.weather.Action.Yahoo.Iconset_Names.Strings[vSelectd] + '\w_w_' + addons.weather.Action.Yahoo.Data_Town[vi].Observation.ConditionCode + '.png');
        for vk := 0 to 24 do
        begin
          vWeather.Scene.Tab_Yahoo[vi].Forecast_Hourly.Hourly[vk].Icon.Bitmap.LoadFromFile(uDB_AUser.Local.addons.Weather_D.p_Icons + 'yahoo\' +
            addons.weather.Action.Yahoo.Iconset_Names.Strings[vSelectd] + '\w_w_' + addons.weather.Action.Yahoo.Data_Town[vi].Forcasts.Hourly[vk].ConditionCode
            + '.png');
        end;
        for vk := 0 to 10 do
        begin
          vWeather.Scene.Tab_Yahoo[vi].Forecast_Daily.Daily[vk].Icon.Bitmap.LoadFromFile(uDB_AUser.Local.addons.Weather_D.p_Icons + 'yahoo\' +
            addons.weather.Action.Yahoo.Iconset_Names.Strings[vSelectd] + '\w_w_' + addons.weather.Action.Yahoo.Data_Town[vi].Forcasts.Daily[vi].ConditionCode
            + '.png');
        end;
      end;
    end;
  end;
end;

procedure Select_Iconset(vSelected: Integer);
begin
  if vSelected <> addons.weather.Action.Yahoo.Iconset_Selected then
  begin
    Set_New_Iconset_Check(vSelected);
    New_Iconset_Reload(vSelected);
    addons.weather.Action.Yahoo.Iconset_Selected := vSelected;
    if vSelected = 0 then
      addons.weather.Action.Yahoo.Iconset_Name := 'default'
    else
      addons.weather.Action.Yahoo.Iconset_Name := addons.weather.Action.Yahoo.Iconset_Names.Strings[vSelected];
    // addons.weather.Ini.Ini.WriteInteger('yahoo', 'iconset', addons.weather.Action.Yahoo.Iconset_Selected);
    // addons.weather.Ini.Ini.WriteString('yahoo', 'iconset_name', addons.weather.Action.Yahoo.Iconset_Name);
    vWeather.Scene.Blur.Enabled := False;
    vWeather.Scene.Blur.Enabled := True;
  end;
end;

procedure Get_Data;
var
  vi: Integer;
  vQuery: String;
begin
  vQuery := 'SELECT * FROM ADDON_WEATHER_YAHOO';
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := vQuery;
  ExtraFE_Query_Local.Open;
  ExtraFE_Query_Local.First;

  for vi := 0 to uDB_AUser.Local.addons.Weather_D.Yahoo.Towns_Count do
  begin
    SetLength(uDB_AUser.Local.addons.Weather_D.Yahoo.Towns, vi + 2);
    uDB_AUser.Local.addons.Weather_D.Yahoo.Towns[vi].Name := ExtraFE_Query_Local.FieldByName('TOWN_NAME').AsString;
    uDB_AUser.Local.addons.Weather_D.Yahoo.Towns[vi].Num := ExtraFE_Query_Local.FieldByName('TOWN_NUM').AsInteger;
    uDB_AUser.Local.addons.Weather_D.Yahoo.Towns[vi].Woeid := ExtraFE_Query_Local.FieldByName('TOWN_WOEID').AsInteger;
    ExtraFE_Query_Local.Next;
  end;

end;

end.
