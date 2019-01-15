unit uWeather_Config_Provider;

interface

uses
  System.Classes,
  System.UiTypes,
  System.SysUtils,
  FMX.StdCtrls,
  FMX.Types,
  FMX.Objects;

procedure uWeather_Config_Provider_Show;
procedure uWeather_Config_Provider_Free;

procedure uWeather_Config_Provider_YahooCheck;

implementation

uses
  uload,
  uLoad_AllTypes,
  main,
  uWeather_AllTypes,
  uWeather_SetAll;

procedure uWeather_Config_Provider_Show;
begin
  vWeather.Config.Main.Right.Panels[0] := TPanel.Create(vWeather.Config.Main.Right.Panel);
  vWeather.Config.Main.Right.Panels[0].Name := 'Weather_Config_Panels_0';
  vWeather.Config.Main.Right.Panels[0].Parent := vWeather.Config.Main.Right.Panel;
  vWeather.Config.Main.Right.Panels[0].Align := TAlignLayout.Client;
  vWeather.Config.Main.Right.Panels[0].Visible := True;

  vWeather.Config.Main.Right.Provider.Choose := TLabel.Create(vWeather.Config.Main.Right.Panels[0]);
  vWeather.Config.Main.Right.Provider.Choose.Name := 'Weather_Config_Provider_Choose_Label';
  vWeather.Config.Main.Right.Provider.Choose.Parent := vWeather.Config.Main.Right.Panels[0];
  vWeather.Config.Main.Right.Provider.Choose.Width := 300;
  vWeather.Config.Main.Right.Provider.Choose.Position.X := 10;
  vWeather.Config.Main.Right.Provider.Choose.Position.Y := 10;
  vWeather.Config.Main.Right.Provider.Choose.Text := 'Choose "Provider" from the list below.';
  vWeather.Config.Main.Right.Provider.Choose.Font.Style := vWeather.Config.Main.Right.Provider.Choose.Font.Style +
    [TFontStyle.fsBold];
  vWeather.Config.Main.Right.Provider.Choose.Visible := True;

  vWeather.Config.Main.Right.Provider.Yahoo_Icon := TImage.Create(vWeather.Config.Main.Right.Panels[0]);
  vWeather.Config.Main.Right.Provider.Yahoo_Icon.Name := 'Weather_Config_Provider_Yahoo_Image';
  vWeather.Config.Main.Right.Provider.Yahoo_Icon.Parent := vWeather.Config.Main.Right.Panels[0];
  vWeather.Config.Main.Right.Provider.Yahoo_Icon.Width := 97;
  vWeather.Config.Main.Right.Provider.Yahoo_Icon.Height := 50;
  vWeather.Config.Main.Right.Provider.Yahoo_Icon.Position.X := 10;
  vWeather.Config.Main.Right.Provider.Yahoo_Icon.Position.Y := 46;
  vWeather.Config.Main.Right.Provider.Yahoo_Icon.Bitmap.LoadFromFile(addons.Weather.Path.Images +
    'w_provider_yahoo.png');
  vWeather.Config.Main.Right.Provider.Yahoo_Icon.Visible := True;

  vWeather.Config.Main.Right.Provider.Yahoo_Check := TCheckBox.Create(vWeather.Config.Main.Right.Panels[0]);
  vWeather.Config.Main.Right.Provider.Yahoo_Check.Name := 'Weather_Config_Provider_Yahoo_CheckBox';
  vWeather.Config.Main.Right.Provider.Yahoo_Check.Parent := vWeather.Config.Main.Right.Panels[0];
  vWeather.Config.Main.Right.Provider.Yahoo_Check.Position.X := 120;
  vWeather.Config.Main.Right.Provider.Yahoo_Check.Position.Y := 61;
  vWeather.Config.Main.Right.Provider.Yahoo_Check.Width := 300;
  vWeather.Config.Main.Right.Provider.Yahoo_Check.Height := 20;
  vWeather.Config.Main.Right.Provider.Yahoo_Check.Text := 'Yahoo! Weather';
  vWeather.Config.Main.Right.Provider.Yahoo_Check.OnClick := addons.weather.Input.mouse.Checkbox.OnMouseClick;
  vWeather.Config.Main.Right.Provider.Yahoo_Check.OnMouseEnter := addons.weather.Input.mouse.Checkbox.OnMouseEnter;
  vWeather.Config.Main.Right.Provider.Yahoo_Check.OnMouseLeave := addons.weather.Input.mouse.Checkbox.OnMouseLeave;
  vWeather.Config.Main.Right.Provider.Yahoo_Check.Visible := True;

  vWeather.Config.Main.Right.Provider.Text := TLabel.Create(vWeather.Config.Main.Right.Panels[0]);
  vWeather.Config.Main.Right.Provider.Text.Name := 'Weather_Config_Provider_Label';
  vWeather.Config.Main.Right.Provider.Text.Parent := vWeather.Config.Main.Right.Panels[0];
  vWeather.Config.Main.Right.Provider.Text.Width := 300;
  vWeather.Config.Main.Right.Provider.Text.Position.X := 10;
  vWeather.Config.Main.Right.Provider.Text.Position.Y := vWeather.Config.Main.Right.Panels[0].Height - 30;
  vWeather.Config.Main.Right.Provider.Text.Text := 'Selected "Provider" : ' + addons.Weather.Action.Provider;
  vWeather.Config.Main.Right.Provider.Text.Font.Style := vWeather.Config.Main.Right.Provider.Text.Font.Style + [TFontStyle.fsBold];
  vWeather.Config.Main.Right.Provider.Text.Visible := True;

   if addons.Weather.Action.Provider = 'Yahoo' then
    vWeather.Config.Main.Right.Provider.Yahoo_Check.IsChecked := True;
end;

procedure uWeather_Config_Provider_Free;
begin
  FreeAndNil(vWeather.Config.Main.Right.Panels[0]);
end;

procedure uWeather_Config_Provider_YahooCheck;
begin
  if vWeather.Config.main.Right.Provider.Yahoo_Check.IsChecked = False then
  begin
    addons.weather.Ini.Ini.WriteString('Provider', 'Name', 'Yahoo');
    addons.weather.Action.Provider := 'Yahoo';
    vWeather.Config.main.Right.Provider.Text.Text := 'Selected "Provider" : ' +
      addons.weather.Action.Provider;
  end
  else
    vWeather.Config.main.Right.Provider.Yahoo_Check.IsChecked :=
      not vWeather.Config.main.Right.Provider.Yahoo_Check.IsChecked;
end;

end.
