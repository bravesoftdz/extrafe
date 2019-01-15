unit uWeather_Config_Towns_Refresh;

interface

uses
  System.Classes,
  System.UiTypes,
  System.SysUtils,
  FMX.StdCtrls,
  FMX.OBjects,
  OXmlPDOM;

procedure uWeather_Config_Towns_Edit_Refresh_Show;
procedure uWeather_Config_Towns_Edit_Refresh_Free;

procedure uWeather_Config_Towns_Edit_Refresh(vNum: Integer);
procedure uWeather_Config_Towns_Edit_RefreshTown(vNum: Integer);

implementation

uses
  main,
  uLoad_AllTypes,
  uWeather_AllTypes,
  uWeather_SetAll,
  uWeather_Config_Towns;

procedure uWeather_Config_Towns_Edit_Refresh_Show;
begin
  extrafe.prog.State := 'addon_weather_config_towns_refresh';
  vWeather.Config.Panel_Blur.Enabled := True;

  vWeather.Config.main.Right.Towns.Refresh.Panel := TPanel.Create(vWeather.Scene.weather);
  vWeather.Config.main.Right.Towns.Refresh.Panel.name := 'A_W_Config_Towns_Refresh';
  vWeather.Config.main.Right.Towns.Refresh.Panel.Parent := vWeather.Scene.weather;
  vWeather.Config.main.Right.Towns.Refresh.Panel.Width := 500;
  vWeather.Config.main.Right.Towns.Refresh.Panel.Height := 140;
  vWeather.Config.main.Right.Towns.Refresh.Panel.Position.X := extrafe.res.Half_Width - 250;
  vWeather.Config.main.Right.Towns.Refresh.Panel.Position.Y := extrafe.res.Half_Height - 200;
  vWeather.Config.main.Right.Towns.Refresh.Panel.Visible := True;

  uLoad_SetAll_CreateHeader(vWeather.Config.main.Right.Towns.Refresh.Panel, 'A_W_Config_Towns_Refresh',
    addons.weather.Path.Images + 'w_refresh.png', 'Refresh.');

  vWeather.Config.main.Right.Towns.Refresh.main.Panel :=
    TPanel.Create(vWeather.Config.main.Right.Towns.Refresh.Panel);
  vWeather.Config.main.Right.Towns.Refresh.main.Panel.name := 'A_W_Config_Towns_Refresh_Main';
  vWeather.Config.main.Right.Towns.Refresh.main.Panel.Parent :=
    vWeather.Config.main.Right.Towns.Refresh.Panel;
  vWeather.Config.main.Right.Towns.Refresh.main.Panel.Width :=
    vWeather.Config.main.Right.Towns.Refresh.Panel.Width;
  vWeather.Config.main.Right.Towns.Refresh.main.Panel.Height :=
    vWeather.Config.main.Right.Towns.Refresh.Panel.Height - 30;
  vWeather.Config.main.Right.Towns.Refresh.main.Panel.Position.X := 0;
  vWeather.Config.main.Right.Towns.Refresh.main.Panel.Position.Y := 30;
  vWeather.Config.main.Right.Towns.Refresh.main.Panel.Visible := True;

  vWeather.Config.main.Right.Towns.Refresh.main.Choice1 :=
    TRadioButton.Create(vWeather.Config.main.Right.Towns.Refresh.main.Panel);
  vWeather.Config.main.Right.Towns.Refresh.main.Choice1.name := 'A_W_Config_Towns_Refresh_Choice1';
  vWeather.Config.main.Right.Towns.Refresh.main.Choice1.Parent :=
    vWeather.Config.main.Right.Towns.Refresh.main.Panel;
  vWeather.Config.main.Right.Towns.Refresh.main.Choice1.Width := 400;
  vWeather.Config.main.Right.Towns.Refresh.main.Choice1.Height := 24;
  vWeather.Config.main.Right.Towns.Refresh.main.Choice1.Position.X := 50;
  vWeather.Config.main.Right.Towns.Refresh.main.Choice1.Position.Y := 10;
  vWeather.Config.main.Right.Towns.Refresh.main.Choice1.Text := 'Refresh the data of the choosen town.';
  vWeather.Config.main.Right.Towns.Refresh.main.Choice1.Visible := True;

  vWeather.Config.main.Right.Towns.Refresh.main.Choice2 :=
    TRadioButton.Create(vWeather.Config.main.Right.Towns.Refresh.main.Panel);
  vWeather.Config.main.Right.Towns.Refresh.main.Choice2.name := 'A_W_Config_Towns_Refresh_Choice2';
  vWeather.Config.main.Right.Towns.Refresh.main.Choice2.Parent :=
    vWeather.Config.main.Right.Towns.Refresh.main.Panel;
  vWeather.Config.main.Right.Towns.Refresh.main.Choice2.Width := 400;
  vWeather.Config.main.Right.Towns.Refresh.main.Choice2.Height := 24;
  vWeather.Config.main.Right.Towns.Refresh.main.Choice2.Position.X := 50;
  vWeather.Config.main.Right.Towns.Refresh.main.Choice2.Position.Y := 36;
  vWeather.Config.main.Right.Towns.Refresh.main.Choice2.Text := 'Refresh the data of all the towns.';
  vWeather.Config.main.Right.Towns.Refresh.main.Choice2.Visible := True;

  vWeather.Config.main.Right.Towns.Refresh.main.Refresh :=
    TButton.Create(vWeather.Config.main.Right.Towns.Refresh.main.Panel);
  vWeather.Config.main.Right.Towns.Refresh.main.Refresh.name := 'A_W_Config_Refresh_Refresh';
  vWeather.Config.main.Right.Towns.Refresh.main.Refresh.Parent :=
    vWeather.Config.main.Right.Towns.Refresh.main.Panel;
  vWeather.Config.main.Right.Towns.Refresh.main.Refresh.Width := 100;
  vWeather.Config.main.Right.Towns.Refresh.main.Refresh.Height := 24;
  vWeather.Config.main.Right.Towns.Refresh.main.Refresh.Position.X := 80;
  vWeather.Config.main.Right.Towns.Refresh.main.Refresh.Position.Y :=
    vWeather.Config.main.Right.Towns.Refresh.main.Panel.Height - 34;
  vWeather.Config.main.Right.Towns.Refresh.main.Refresh.Text := 'Refresh';
  vWeather.Config.main.Right.Towns.Refresh.main.Refresh.OnClick :=
    addons.weather.Input.mouse.Button.OnMouseClick;
  vWeather.Config.main.Right.Towns.Refresh.main.Refresh.Visible := True;

  vWeather.Config.main.Right.Towns.Refresh.main.Cancel :=
    TButton.Create(vWeather.Config.main.Right.Towns.Refresh.main.Panel);
  vWeather.Config.main.Right.Towns.Refresh.main.Cancel.name := 'A_W_Config_Refresh_Cancel';
  vWeather.Config.main.Right.Towns.Refresh.main.Cancel.Parent :=
    vWeather.Config.main.Right.Towns.Refresh.main.Panel;
  vWeather.Config.main.Right.Towns.Refresh.main.Cancel.Width := 100;
  vWeather.Config.main.Right.Towns.Refresh.main.Cancel.Height := 24;
  vWeather.Config.main.Right.Towns.Refresh.main.Cancel.Position.X :=
    vWeather.Config.main.Right.Towns.Refresh.main.Panel.Width - 200;
  vWeather.Config.main.Right.Towns.Refresh.main.Cancel.Position.Y :=
    vWeather.Config.main.Right.Towns.Refresh.main.Panel.Height - 34;
  vWeather.Config.main.Right.Towns.Refresh.main.Cancel.Text := 'Cancel';
  vWeather.Config.main.Right.Towns.Refresh.main.Cancel.OnClick :=
    addons.weather.Input.mouse.Button.OnMouseClick;
  vWeather.Config.main.Right.Towns.Refresh.main.Cancel.Visible := True;
end;

procedure uWeather_Config_Towns_Edit_Refresh_Free;
begin
  extrafe.prog.State := 'addon_weather_config';
  vWeather.Config.Panel_Blur.Enabled := False;
  vWeather.Config.main.Right.Towns.Refresh_Glow.Enabled := False;
  FreeAndNil(vWeather.Config.main.Right.Towns.Refresh.Panel);
end;
///

procedure uWeather_Config_Towns_Edit_Refresh(vNum: Integer);
var
  vi: Integer;
begin
  if vWeather.Config.main.Right.Towns.Refresh.main.Choice1.IsChecked then
    uWeather_Config_Towns_Edit_RefreshTown(vNum)
  else if vWeather.Config.main.Right.Towns.Refresh.main.Choice2.IsChecked then
  begin
    for vi := 0 to addons.weather.Action.Active_Total do
      uWeather_Config_Towns_Edit_RefreshTown(vi)
  end;

  uWeather_Config_Towns_Edit_Refresh_Free;
end;

procedure uWeather_Config_Towns_Edit_RefreshTown(vNum: Integer);
var
  vForcast_Resutls: TStringList;
  vString_Provider: string;
  vString_Woeid: String;
  vString_Temp_Unit: WideString;
  viPos: Integer;
  vDegree: String;
begin
  vForcast_Resutls := TStringList.Create;

  vString_Provider := addons.weather.Ini.Ini.ReadString('Provider', 'Name', vString_Provider);
  vString_Woeid := addons.weather.Ini.Ini.ReadString(vString_Provider, IntToStr(vNum) + '_WoeID',
    vString_Woeid);
  viPos := Pos('{', vString_Woeid);
  vString_Woeid := Trim(Copy(vString_Woeid, 0, viPos - 1));

  if addons.weather.Action.Degree = 'Celcius' then
    vDegree := 'c'
  else if addons.weather.Action.Degree = 'Fahrenheit' then
    vDegree := 'f';

  vForcast_Resutls.Add(Main_Form.Main_IdHttp.Get
    ('http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%3D' +
    vString_Woeid + '%20and%20u%3D%27' + vDegree +
    '%27&format=xml&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys%20HTTP/1.1'));
  vForcast_Resutls.SaveToFile(extrafe.prog.Path + cTemp_Forcast);

  vNTXML := CreateXMLDoc;
  vNTXML.LoadFromFile(extrafe.prog.Path + cTemp_Forcast);
  vNTRoot := vNTXML.DocumentElement;
  vNTNode := nil;

  while vNTRoot.GetNextChild(vNTNode) do
    while vNTNode.GetNextChild(vNTNode_1) do
      while vNTNode_1.GetNextChild(vNTNode_2) do
      begin
        vNTAttribute := nil;
        if vNTNode_2.NodeName = 'yweather:units' then
        begin
          vNTNode_2.FindAttribute('temperature', vNTAttribute);
          vString_Temp_Unit := vNTAttribute.NodeValue;
        end
        else if vNTNode_2.NodeName = 'item' then
        begin
          while vNTNode_2.GetNextChild(vNTNode_3) do
          begin
            vNTAttribute := nil;
            if vNTNode_3.NodeName = 'yweather:condition' then
            begin
              vNTNode_3.FindAttribute('temp', vNTAttribute);
              vNTAttribute := nil;
              vNTNode_3.FindAttribute('date', vNTAttribute);
              vNTAttribute := nil;
              vNTNode_3.FindAttribute('code', vNTAttribute);
              vNTAttribute := nil;
              vNTNode_3.FindAttribute('text', vNTAttribute);
            end;
          end;
        end;
      end;
  DeleteFile(extrafe.prog.Path + cTemp_Forcast);
end;

end.
