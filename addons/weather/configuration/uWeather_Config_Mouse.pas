unit uWeather_Config_Mouse;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UiTypes,
  FMX.Objects,
  FMX.StdCtrls,
  BASS;

type
  TWEATHER_ADDON_CONFIG_TEXT = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TWEATHER_ADDON_CONFIG_BUTTON = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TWEATHER_ADDON_CONFIG_CHECKBOX = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TWEATHER_ADDON_CONFIG_PANEL = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TWEATHER_ADDON_CONFIG_IMAGE = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TWEATHER_ADDON_CONFIG_COMBOBOX = class(TObject)
    procedure OnChange(Sender: TObject);
  end;

type
  TWEATHER_CONFIG_MOUSE = record
    Text: TWEATHER_ADDON_CONFIG_TEXT;
    Button: TWEATHER_ADDON_CONFIG_BUTTON;
    Checkbox: TWEATHER_ADDON_CONFIG_CHECKBOX;
    Panel: TWEATHER_ADDON_CONFIG_PANEL;
    Image: TWEATHER_ADDON_CONFIG_IMAGE;
    Combobox: TWEATHER_ADDON_CONFIG_COMBOBOX;
  end;

implementation

uses
  uSnippets,
  uLoad_AllTypes,
  uWeather_AllTypes,
  uWeather_Config,
  uWeather_Config_Provider,
  uWeather_Config_Towns,
  uWeather_Config_Towns_Delete,
  uWeather_Config_Towns_Add,
  uWeather_Providers_Yahoo_Config,
  uWeather_Providers_OpenWeatherMap_Config;

{ TWEATHER_ADDON_TEXT }

procedure TWEATHER_ADDON_CONFIG_TEXT.OnMouseClick(Sender: TObject);
begin
  if addons.weather.Action.Provider = 'yahoo' then
  begin
    if TText(Sender).TextSettings.FontColor = TAlphaColorRec.Deepskyblue then
    begin
      if extrafe.prog.state = 'addon_weather_config' then
      begin
        if TText(Sender).Name = 'A_W_Config_Towns_Add' then
        begin
          TText(Sender).Cursor := crHourGlass;
          uWeather_Config_Towns_Add.Load;
          TText(Sender).Cursor := crDefault;
        end
        else if TText(Sender).Name = 'A_W_Config_Towns_Lock' then
          uWeather_Config_Towns_Edit(not addons.weather.Config.Edit_Lock)
        else if TImage(Sender).Name = 'A_W_Config_Towns_PosUp' then
          uWeather_Providers_Yahoo_Config.Towns_Go_To('up')
        else if TImage(Sender).Name = 'A_W_Config_Towns_PosDown' then
          uWeather_Providers_Yahoo_Config.Towns_Go_To('down')
        else if TImage(Sender).Name = 'A_W_Config_Towns_Delete' then
          uWeather_Providers_Yahoo_Config.Towns_Delete_Question
        else if TText(Sender).Name = 'A_W_Provider_Yahoo_Config_Iconsets_TextImage_' + TText(Sender).TagString + '_' + TText(Sender).Tag.ToString then
        begin
          if TText(Sender).Tag = 8 then
            uWeather_Providers_Yahoo_Config.Show_Full_Iconset_Preview(TText(Sender).TagString.ToInteger)
          else
            uWeather_Providers_Yahoo_Config.Select_Iconset(TText(Sender).TagString.ToInteger());
        end
        else if TText(Sender).Name = 'A_W_Provider_Yahoo_Config_Iconsets_Back' then
          uWeather_Providers_Yahoo_Config.Close_Full_Iconset_Preview
      end
      else if extrafe.prog.state = 'addon_weather_config_towns_add' then
      begin
        TText(Sender).Cursor := crHourGlass;
        if TText(Sender).Name = 'A_W_Config_Towns_Add_Search' then
          uWeather_Config_Towns_Add.FindTown(vWeather.Config.main.Right.Towns.Add.main.FindTown_V.Text);
        TText(Sender).Cursor := crDefault;
      end;
      BASS_ChannelPlay(ex_main.Sounds.mouse[0], False);
    end;
  end
  else if addons.weather.Action.Provider = 'openweathermap' then
  begin
    if TText(Sender).TextSettings.FontColor = TAlphaColorRec.Deepskyblue then
    begin
      if extrafe.prog.state = 'addon_weather_config' then
      begin
        if TText(Sender).Name = 'A_W_Config_Towns_Add' then
        begin
          TText(Sender).Cursor := crHourGlass;
          uWeather_Config_Towns_Add.Load;
          TText(Sender).Cursor := crDefault;
        end
        else if TText(Sender).Name = 'A_W_Config_Towns_Lock' then
          uWeather_Config_Towns_Edit(not addons.weather.Config.Edit_Lock)
        else if TImage(Sender).Name = 'A_W_Config_Towns_PosUp' then
          uWeather_Providers_Yahoo_Config.Towns_Go_To('up')
        else if TImage(Sender).Name = 'A_W_Config_Towns_PosDown' then
          uWeather_Providers_Yahoo_Config.Towns_Go_To('down')
        else if TImage(Sender).Name = 'A_W_Config_Towns_Delete' then
          uWeather_Providers_Yahoo_Config.Towns_Delete_Question
        else if TText(Sender).Name = 'A_W_Providers_OpenWeatherMap_Config_Options_API_Link' then
          uSnippets.Open_Link_To_Browser(TText(Sender).Text)
        else if TText(Sender).Name = 'A_W_Providers_OpenWeatherMap_Config_Options_API_Lock' then
          uWeather_Providers_OpenWeatherMap_Config.Options_Lock(addons.weather.Action.OWM.Options_Lock);
      end
      else if extrafe.prog.state = 'addon_weather_config_towns_add' then
      begin
        TText(Sender).Cursor := crHourGlass;
        if TText(Sender).Name = 'A_W_Config_Towns_Add_Search' then
          uWeather_Config_Towns_Add.FindTown(vWeather.Config.main.Right.Towns.Add.main.FindTown_V.Text);
        TText(Sender).Cursor := crDefault;
      end;
      BASS_ChannelPlay(ex_main.Sounds.mouse[0], False);
    end;
  end;
end;

procedure TWEATHER_ADDON_CONFIG_TEXT.OnMouseEnter(Sender: TObject);
var
  vi: Integer;
begin
  if TText(Sender).TextSettings.FontColor = TAlphaColorRec.Deepskyblue then
  begin
    if extrafe.prog.state = 'addon_weather_config' then
    begin
      if TText(Sender).Name = 'A_W_Config_Towns_Add' then
        vWeather.Config.main.Right.Towns.Add_Town_Glow.Enabled := True
      else if TText(Sender).Name = 'A_W_Config_Towns_Lock' then
        vWeather.Config.main.Right.Towns.EditLock_Glow.Enabled := True
      else if TText(Sender).Name = 'A_W_Config_Towns_PosUp' then
        vWeather.Config.main.Right.Towns.GoUp_Glow.Enabled := True
      else if TText(Sender).Name = 'A_W_Config_Towns_PosDown' then
        vWeather.Config.main.Right.Towns.GoDown_Glow.Enabled := True
      else if TText(Sender).Name = 'A_W_Config_Towns_Delete' then
        vWeather.Config.main.Right.Towns.Delete_Glow.Enabled := True
      else if TText(Sender).Name = 'A_W_Provider_Yahoo_Config_Iconsets_TextImage_' + TText(Sender).TagString + '_' + TText(Sender).Tag.ToString then
      begin
        if TText(Sender).Tag = 8 then
          vWeather.Config.main.Right.Iconsets.Mini[TText(Sender).TagString.ToInteger].Text_Image_Glow.Enabled := True;
        for vi := 0 to addons.weather.Action.Yahoo.Iconset_Count do
          vWeather.Config.main.Right.Iconsets.Mini[vi].Panel_Glow.Enabled := False;
        vWeather.Config.main.Right.Iconsets.Mini[TText(Sender).TagString.ToInteger].Panel_Glow.Enabled := True;
      end
      else if TText(Sender).Name = 'A_W_Provider_Yahoo_Config_Iconsets_Back' then
        vWeather.Config.main.Right.Iconsets.Full.Back_Glow.Enabled := True
      else if TText(Sender).Name = 'A_W_Providers_OpenWeatherMap_Config_Options_API_Lock' then
        vWeather.Config.main.Right.Options_OWM.API_Lock_Glow.Enabled := True;
    end
    else if extrafe.prog.state = 'addon_weather_config_towns_add' then
    begin
      if TText(Sender).Name = 'A_W_Config_Towns_Add_Search' then
        vWeather.Config.main.Right.Towns.Add.main.Search_Glow.Enabled := True;
    end;
    TText(Sender).Cursor := crHandPoint;
  end;
  if TText(Sender).Name = 'A_W_Providers_OpenWeatherMap_Config_Options_API_Link' then
    uSnippets.HyperLink_OnMouseOver(TText(Sender));
end;

procedure TWEATHER_ADDON_CONFIG_TEXT.OnMouseLeave(Sender: TObject);
begin
  if extrafe.prog.state = 'addon_weather_config' then
  begin
    if TText(Sender).Name = 'A_W_Config_Towns_Add' then
      vWeather.Config.main.Right.Towns.Add_Town_Glow.Enabled := False
    else if TText(Sender).Name = 'A_W_Config_Towns_Lock' then
      vWeather.Config.main.Right.Towns.EditLock_Glow.Enabled := False
    else if TText(Sender).Name = 'A_W_Config_Towns_PosUp' then
      vWeather.Config.main.Right.Towns.GoUp_Glow.Enabled := False
    else if TText(Sender).Name = 'A_W_Config_Towns_PosDown' then
      vWeather.Config.main.Right.Towns.GoDown_Glow.Enabled := False
    else if TImage(Sender).Name = 'A_W_Config_Towns_Delete' then
      vWeather.Config.main.Right.Towns.Delete_Glow.Enabled := False
    else if TText(Sender).Name = 'A_W_Provider_Yahoo_Config_Iconsets_TextImage_' + TText(Sender).TagString + '_' + TText(Sender).Tag.ToString then
    begin
      if TText(Sender).Tag = 8 then
        vWeather.Config.main.Right.Iconsets.Mini[TText(Sender).TagString.ToInteger].Text_Image_Glow.Enabled := False;
    end
    else if TText(Sender).Name = 'A_W_Provider_Yahoo_Config_Iconsets_Back' then
      vWeather.Config.main.Right.Iconsets.Full.Back_Glow.Enabled := False
    else if TText(Sender).Name = 'A_W_Providers_OpenWeatherMap_Config_Options_API_Lock' then
      vWeather.Config.main.Right.Options_OWM.API_Lock_Glow.Enabled := False;
  end
  else if extrafe.prog.state = 'addon_weather_config_towns_add' then
  begin
    if TText(Sender).Name = 'A_W_Config_Towns_Add_Search' then
      vWeather.Config.main.Right.Towns.Add.main.Search_Glow.Enabled := False;
  end;
  if TText(Sender).Name = 'A_W_Providers_OpenWeatherMap_Config_Options_API_Link' then
    uSnippets.HyperLink_OnMouseLeave(TText(Sender));
end;

///

{ TWEATHER_ADDON_CONFIG_BUTTON }

procedure TWEATHER_ADDON_CONFIG_BUTTON.OnMouseClick(Sender: TObject);
begin
  if extrafe.prog.state = 'addon_weather_config' then
  begin
    if TButton(Sender).Name = 'A_W_Config_Left_Button_' + TButton(Sender).Tag.ToString then
      uWeather_Config_ShowPanel(TButton(Sender).Tag);
  end;
  if addons.weather.Action.Provider = 'yahoo' then
  begin
    if extrafe.prog.state = 'addon_weather_config_towns_add' then
    begin
      if TButton(Sender).Name = 'A_W_Config_Towns_Add_Add' then
        uWeather_Config_Towns_Add.New_Town(vWeather.Config.main.Right.Towns.Add.main.Grid.Selected, False)
      else if TButton(Sender).Name = 'A_W_Config_Towns_Add_AddStay' then
        uWeather_Config_Towns_Add.New_Town(vWeather.Config.main.Right.Towns.Add.main.Grid.Selected, True)
      else if TButton(Sender).Name = 'A_W_Config_Towns_Add_Cancel' then
        uWeather_Config_Towns_Add.Free;
    end
    else if extrafe.prog.state = 'addon_weather_config_delete_town' then
    begin
      if TButton(Sender).Name = 'A_W_Providers_Yahoo_Question_Delete_Town_Delete' then
        uWeather_Providers_Yahoo_Config.Towns_Delete
      else if TButton(Sender).Name = 'A_W_Providers_Yahoo_Question_Delete_Town_Cancel' then
        uWeather_Providers_Yahoo_Config.Towns_Delete_Cancel;
    end;
    BASS_ChannelPlay(ex_main.Sounds.mouse[0], False);
  end
  else if addons.weather.Action.Provider = 'openweathermap' then
  begin
    if extrafe.prog.state = 'addon_weather_config_towns_add' then
    begin
      if TButton(Sender).Name = 'A_W_Config_Towns_Add_Add' then
        uWeather_Config_Towns_Add.New_Town(vWeather.Config.main.Right.Towns.Add.main.Grid.Selected, False)
      else if TButton(Sender).Name = 'A_W_Config_Towns_Add_AddStay' then
        uWeather_Config_Towns_Add.New_Town(vWeather.Config.main.Right.Towns.Add.main.Grid.Selected, True)
      else if TButton(Sender).Name = 'A_W_Config_Towns_Add_Cancel' then
        uWeather_Config_Towns_Add.Free;
    end
  end;
end;

procedure TWEATHER_ADDON_CONFIG_BUTTON.OnMouseEnter(Sender: TObject);
begin
  TButton(Sender).Cursor := crHandPoint;
end;

procedure TWEATHER_ADDON_CONFIG_BUTTON.OnMouseLeave(Sender: TObject);
begin

end;

{ TWEATHER_ADDON_CONFIG_CHECKBOX }

procedure TWEATHER_ADDON_CONFIG_CHECKBOX.OnMouseClick(Sender: TObject);
begin
  if TCheckBox(Sender).Name = 'A_W_Config_Provider_yahoo_CheckBox' then
    uWeather_Config_Provider.Check_Yahoo
  else if TCheckBox(Sender).Name = 'A_W_Config_Provider_openweathermap_CheckBox' then
    uWeather_Config_Provider.Check_OpenWeatherMap;
  if addons.weather.Action.Provider = 'yahoo' then
  begin
    if TCheckBox(Sender).Name = 'A_W_Provider_Yahoo_Config_Metric' then
      uWeather_Providers_Yahoo_Config.Options_Check_System_Type('metric')
    else if TCheckBox(Sender).Name = 'A_W_Provider_Yahoo_Config_Imperial' then
      uWeather_Providers_Yahoo_Config.Options_Check_System_Type('imperial');
  end
  else if addons.weather.Action.Provider = 'openweathermap' then
  begin
    if TCheckBox(Sender).Name = 'A_W_Providers_OpenWeatherMap_Config_Options_Metric_Checkbox' then
      uWeather_Providers_OpenWeatherMap_Config.Options_Check_System_Type('metric')
    else if TCheckBox(Sender).Name = 'A_W_Providers_OpenWeatherMap_Config_Options_Imperial_Checkbox' then
      uWeather_Providers_OpenWeatherMap_Config.Options_Check_System_Type('imperial');
  end;
end;

procedure TWEATHER_ADDON_CONFIG_CHECKBOX.OnMouseEnter(Sender: TObject);
begin
  TCheckBox(Sender).Cursor := crHandPoint;
end;

procedure TWEATHER_ADDON_CONFIG_CHECKBOX.OnMouseLeave(Sender: TObject);
begin

end;

{ TWEATHER_ADDON_CONFIG_PANEL }

procedure TWEATHER_ADDON_CONFIG_PANEL.OnMouseClick(Sender: TObject);
begin
  if addons.weather.Action.Provider = 'yahoo' then
  begin
    if TPanel(Sender).Name = 'A_W_Provider_Yahoo_Config_Towns_CityNum_Above_' + TPanel(Sender).Tag.ToString then
    begin
      if addons.weather.Config.Edit_Lock then
        uWeather_Providers_Yahoo_Config.Towns_Select(TPanel(Sender).Tag);
    end;
  end
  else if addons.weather.Action.Provider = 'openweathermap' then
  begin

  end;
end;

procedure TWEATHER_ADDON_CONFIG_PANEL.OnMouseEnter(Sender: TObject);
var
  vi: Integer;
begin
  if addons.weather.Action.Provider = 'yahoo' then
  begin
    if TPanel(Sender).Name = 'A_W_Provider_Yahoo_Config_Towns_CityNum_Above_' + TPanel(Sender).Tag.ToString then
      vWeather.Config.main.Right.Towns.Town[TPanel(Sender).Tag].Glow_Panel.Enabled := True
    else if TPanel(Sender).Name = 'A_W_Config_Provider_Yahoo_Iconsets_Mini_Preview_Panel_' + TPanel(Sender).TagString then
    begin
      for vi := 0 to addons.weather.Action.Yahoo.Iconset_Count do
        vWeather.Config.main.Right.Iconsets.Mini[vi].Panel_Glow.Enabled := False;
      vWeather.Config.main.Right.Iconsets.Mini[TPanel(Sender).TagString.ToInteger].Panel_Glow.Enabled := True;
    end
  end
  else if addons.weather.Action.Provider = 'openweathermap' then
  begin

  end;
  TPanel(Sender).Cursor := crHandPoint;
end;

procedure TWEATHER_ADDON_CONFIG_PANEL.OnMouseLeave(Sender: TObject);
begin
  if addons.weather.Action.Provider = 'yahoo' then
  begin
    if TPanel(Sender).Name = 'A_W_Provider_Yahoo_Config_Towns_CityNum_Above_' + TPanel(Sender).Tag.ToString then
    begin
      if vWeather.Config.main.Right.Towns.Town[TPanel(Sender).Tag].Glow_Panel.GlowColor = TAlphaColorRec.Deepskyblue then
        vWeather.Config.main.Right.Towns.Town[TPanel(Sender).Tag].Glow_Panel.Enabled := False
    end
    else if TPanel(Sender).Name = 'A_W_Config_Provider_Yahoo_Iconsets_Mini_Preview_Panel_' + TPanel(Sender).TagString then
      vWeather.Config.main.Right.Iconsets.Mini[TPanel(Sender).TagString.ToInteger].Panel_Glow.Enabled := False;
  end
  else if addons.weather.Action.Provider = 'openweathermap' then
  begin

  end;
end;

{ TWEATHER_ADDON_CONFIG_IMAGE }

procedure TWEATHER_ADDON_CONFIG_IMAGE.OnMouseClick(Sender: TObject);
begin
  if addons.weather.Action.Provider = 'yahoo' then
  begin
    if TImage(Sender).Name = 'A_W_Provider_Yahoo_Config_Iconsets_Mini_Preview_Image_' + TImage(Sender).TagString + '_' + TImage(Sender).Tag.ToString then
      uWeather_Providers_Yahoo_Config.Select_Iconset(TImage(Sender).TagString.ToInteger);
    BASS_ChannelPlay(ex_main.Sounds.mouse[0], False);
  end
  else if addons.weather.Action.Provider = 'openweathermap' then
  begin

  end;
end;

procedure TWEATHER_ADDON_CONFIG_IMAGE.OnMouseEnter(Sender: TObject);
var
  vi: Integer;
begin
  if addons.weather.Action.Provider = 'yahoo' then
  begin
    if TImage(Sender).Name = 'A_W_Provider_Yahoo_Config_Iconsets_Mini_Preview_Image_' + TImage(Sender).TagString + '_' + TImage(Sender).Tag.ToString then
    begin
      for vi := 0 to addons.weather.Action.Yahoo.Iconset_Count do
        vWeather.Config.main.Right.Iconsets.Mini[vi].Panel_Glow.Enabled := False;
      vWeather.Config.main.Right.Iconsets.Mini[TImage(Sender).TagString.ToInteger].Panel_Glow.Enabled := True;
      TImage(Sender).Cursor := crHandPoint;
    end;
  end
  else if addons.weather.Action.Provider = 'openweathermap' then
  begin

  end;
end;

procedure TWEATHER_ADDON_CONFIG_IMAGE.OnMouseLeave(Sender: TObject);
begin

end;

{ TWEATHER_ADDON_CONFIG_COMBOBOX }

procedure TWEATHER_ADDON_CONFIG_COMBOBOX.OnChange(Sender: TObject);
begin

end;

initialization

addons.weather.Input.mouse_config.Text := TWEATHER_ADDON_CONFIG_TEXT.Create;
addons.weather.Input.mouse_config.Button := TWEATHER_ADDON_CONFIG_BUTTON.Create;
addons.weather.Input.mouse_config.Checkbox := TWEATHER_ADDON_CONFIG_CHECKBOX.Create;
addons.weather.Input.mouse_config.Panel := TWEATHER_ADDON_CONFIG_PANEL.Create;
addons.weather.Input.mouse_config.Image := TWEATHER_ADDON_CONFIG_IMAGE.Create;
addons.weather.Input.mouse_config.Combobox := TWEATHER_ADDON_CONFIG_COMBOBOX.Create;

finalization

addons.weather.Input.mouse_config.Text.Free;
addons.weather.Input.mouse_config.Button.Free;
addons.weather.Input.mouse_config.Checkbox.Free;
addons.weather.Input.mouse_config.Panel.Free;
addons.weather.Input.mouse_config.Image.Free;
addons.weather.Input.mouse_config.Combobox.Free;

end.
