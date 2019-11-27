unit uWeather_Providers_OpenWeatherMap;

interface

uses
  System.Classes,
  System.SysUtils,
  System.DateUtils,
  System.UiTypes,
  System.JSON,
  FMX.Graphics,
  FMX.Types,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Ani,
  FMX.Controls,
  FMX.Dialogs,
  FMX.Effects,
  FMX.Layouts,
  FMX.Forms,
  IPPeerClient,
  REST.Client,
  REST.Types,
  Data.Bind.Components,
  Data.Bind.ObjectScope,
  ALFMXTabControl,
  Radiant.Shapes,
  uWeather_AllTypes;

type
  TWEATHER_PROVIDER_OPENWEATHERMAP_FIND_LIST = record
    woeid: string;
    country: string;
    country_code: string;
    city: string;
    text: string;
  end;

type
  TWEATHER_PROVIDER_OPENWEATHERMAP_TIME = record
    Full: String;
    Time: String;
    Date: String;
    DateTime_Delphi: String;
  end;

type
  TWEATHER_PROVIDER_OPENWEATHERMAP_ICON_TYPE = record
    text: String;
    bitmap: TBitmap;
  end;

const
  cAuthor_OWM_APPID = '5f1cc9b837706de78648b1de3443ccce';

procedure Main_Create_Towns;

procedure Main_Create_Town(vTown: TADDON_WEATHER_PROVIDER_OPENWEATHERMAP_DATATOWN; vTab: Integer);
procedure Main_Create_Five(vTown: TADDON_WEATHER_PROVIDER_OPENWEATHERMAP_DATATOWN; vTab: Integer);
procedure Show_Selected_Time_Forecast(vLine, vPlace: Integer);

function Get_Forecast(vNum: Integer; vWoeid: String): TADDON_WEATHER_PROVIDER_OPENWEATHERMAP_DATATOWN;

function Get_Language_Num(vLanguage: String): Integer;
function Get_Language_From_Short_Desc(vShort_Desk: String): String;
function ConvertTime(vUnixTime, Quotes: String): TWEATHER_PROVIDER_OPENWEATHERMAP_TIME;
function Get_Icon_Text(vCode_ID, vIcon: String): String;
function Get_Flag(vCountry: String): TBitmap;
function Get_Icon_Time(vTime: String): String;
function Convert_Wind(vWind: Integer): Single;
function Unit_Type: String;
function Unit_Type_Char: String;
Procedure Set_Lengauge_Text(vLanguage_Index: Integer);

procedure Woeid_List;
procedure Find_Woeid_Locations(vText: String);
procedure Show_Locations;
function Is_Town_Exists(vWoeid: String): Boolean;

procedure Add_NewTown(vNum: Integer);

procedure Show_Map(vTab_Num: String);

var
  vRESTClient: TRESTClient;
  vRESTRequest: TRESTRequest;
  vRESTResponse: TRESTResponse;
  vJSONValue: TJSONValue;

  vOpenWeatherMap_Find_List: array [0 .. 100] of TWEATHER_PROVIDER_OPENWEATHERMAP_FIND_LIST;
  vFound_Locations: Integer;
  vNA_Count: Integer;

implementation

uses
  uDB_AUser,
  uLoad_AllTypes,
  uSnippet_Text,
  uInternet_Files,
  uWeather_Config_Towns,
  uWeather_Convert,
  uWeather_MenuActions,
  uWeather_Actions,
  uWeather_Config_Towns_Add,
  uSnippet_Convert,
  uWeather_Providers_Yahoo,
  uWeather_Providers_OpenWeatherMap_Config;

procedure Find_Woeid_Locations(vText: String);
var
  vOutValue: String;
  vCount: String;
  vi: Integer;
begin
  vJSONValue := TJSONValue.Create;
  vJSONValue := uInternet_Files.JSONValue('OpenWeatherMap', 'http://api.geonames.org/searchJSON?name_equals=' + vText + '&username=azrael11',
    TRESTRequestMethod.rmGET);

  vCount := vJSONValue.GetValue<String>('totalResultsCount');
  vFound_Locations := vCount.ToInteger;

  for vi := 0 to vFound_Locations - 1 do
  begin
    vOpenWeatherMap_Find_List[vi].woeid := vJSONValue.GetValue<String>('geonames[' + vi.ToString + '].geonameId');
    vOpenWeatherMap_Find_List[vi].city := vJSONValue.GetValue<String>('geonames[' + vi.ToString + '].name');
    vOpenWeatherMap_Find_List[vi].country := vJSONValue.GetValue<String>('geonames[' + vi.ToString + '].countryName');
    vOpenWeatherMap_Find_List[vi].country_code := vJSONValue.GetValue<String>('geonames[' + vi.ToString + '].countryCode');
    vOpenWeatherMap_Find_List[vi].text := vJSONValue.GetValue<String>('geonames[' + vi.ToString + '].adminName1');
  end;

  // vJSONValue := uInternet_Files.JSONValue('OpenWeatherMap', 'http://api.openweathermap.org/data/2.5/find?q=' + vText + '&APPID=' + cAuthor_OWM_APPID, TRESTRequestMethod.rmGET);
  //
  // vFound_Locations := vJSONValue.GetValue<Integer>('count');
  //
  // for vi := 0 to vFound_Locations - 1 do
  // begin
  // vOpenWeatherMap_Find_List[vi].woeid := vJSONValue.GetValue<String>('list[' + vi.ToString + '].id');
  // vOpenWeatherMap_Find_List[vi].city := vJSONValue.GetValue<String>('list[' + vi.ToString + '].name');
  // vOpenWeatherMap_Find_List[vi].country := vJSONValue.GetValue<String>('list[' + vi.ToString + '].sys.country');
  // vOpenWeatherMap_Find_List[vi].country_code := vJSONValue.GetValue<String>('list[' + vi.ToString + '].sys.country');
  // vOpenWeatherMap_Find_List[vi].text := vJSONValue.GetValue<String>('list[' + vi.ToString + '].sys.country');
  // end;

end;

procedure Show_Locations;
var
  vi: Integer;
  vCodeFlag: Integer;
begin
  if vFound_Locations - 1 > -1 then
  begin
    for vi := 0 to vFound_Locations - 1 do
    begin
      vWeather.Config.main.Right.Towns.Add.main.Grid.Cells[0, vi] := (vi + 1).ToString;
      vCodeFlag := vCodes.IndexOf(LowerCase(vOpenWeatherMap_Find_List[vi].country_code) + '.png');
      vWeather.Config.main.Right.Towns.Add.main.Grid.Cells[1, vi] := vCodeFlag.ToString;
      vWeather.Config.main.Right.Towns.Add.main.Grid.Cells[2, vi] := vOpenWeatherMap_Find_List[vi].city;
      vWeather.Config.main.Right.Towns.Add.main.Grid.Cells[3, vi] := vOpenWeatherMap_Find_List[vi].text;
      vWeather.Config.main.Right.Towns.Add.main.Grid.Cells[4, vi] := vOpenWeatherMap_Find_List[vi].country;
    end;
    vWeather.Config.main.Right.Towns.Add.main.Grid.Selected := 0;
    DeleteFile(extrafe.prog.Path + cTemp_Towns);
    vWeather.Config.main.Right.Towns.Add.main.Add.Enabled := True;
    vWeather.Config.main.Right.Towns.Add.main.Add_Stay.Enabled := True;
  end
  else
  begin
    vWeather.Config.main.Right.Towns.Add.main.Add.Enabled := false;
    vWeather.Config.main.Right.Towns.Add.main.Add_Stay.Enabled := false;
  end;
  FreeAndNil(vJSONValue);
end;

procedure Main_Create_Towns;
var
  vi: Integer;
  vBackground: TImage;
  vProgress: TProgressBar;
  vProgress_Text: TText;
  vIcon: TText;
  vText: TText;
  vProgress_Num: Single;
begin
  if addons.weather.Action.OWM.Total_WoeID <> -1 then
  begin
    vBackground := TImage.Create(vWeather.Scene.Back);
    vBackground.Name := 'A_W_Providers_OpenWeatherMap_Loading_Background';
    vBackground.Parent := vWeather.Scene.Back;
    vBackground.SetBounds(0, 10, vWeather.Scene.Back.Width, vWeather.Scene.Back.Height);
    vBackground.bitmap.LoadFromFile(uDB_AUser.Local.ADDONS.Weather_D.p_Images + 'w_openweathermp_loading.png');
    vBackground.WrapMode := TImageWrapMode.Original;
    vBackground.Visible := True;

    vText := TText.Create(vWeather.Scene.Back);
    vText.Name := 'A_W_Providers_OpenWeatherMap_Loading_Please_Wait';
    vText.Parent := vWeather.Scene.Back;
    vText.SetBounds(50, 80, 400, 50);
    vText.Font.Family := 'Tahoma';
    vText.Font.Size := 38;
    vText.text := 'Please Wait...';
    vText.TextSettings.FontColor := TAlphaColorRec.White;
    vText.HorzTextAlign := TTextAlign.Center;
    vText.Visible := True;

    vIcon := TText.Create(vWeather.Scene.Back);
    vIcon.Name := 'A_W_Providers_OpenWeatherMap_Loading_Icon';
    vIcon.Parent := vWeather.Scene.Back;
    vIcon.SetBounds(extrafe.res.Half_Width - 40, vWeather.Scene.Back.Height - 400, 100, 100);
    vIcon.Font.Family := 'Weather Icons';
    vIcon.Font.Size := 72;
    vIcon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    vIcon.text := Get_Icon_Text(Random(47).ToString, '');
    vIcon.Visible := True;

    vProgress_Text := TText.Create(vWeather.Scene.Back);
    vProgress_Text.Name := 'A_W_Providers_OpenWeatherMap_Loading_Progress_Text';
    vProgress_Text.Parent := vWeather.Scene.Back;
    vProgress_Text.SetBounds(300, vWeather.Scene.Back.Height - 300, 1320, 50);
    vProgress_Text.Font.Family := 'Tahoma';
    vProgress_Text.Font.Size := 24;
    vProgress_Text.text := '';
    vProgress_Text.TextSettings.FontColor := TAlphaColorRec.White;
    vProgress_Text.HorzTextAlign := TTextAlign.Leading;
    vProgress_Text.Visible := True;

    vProgress := TProgressBar.Create(vWeather.Scene.Back);
    vProgress.Name := 'A_W_Providers_OpenWeatherMap_Loading_Progress';
    vProgress.Parent := vWeather.Scene.Back;
    vProgress.SetBounds(300, vWeather.Scene.Back.Height - 250, 1320, 30);
    vProgress.Max := 100;
    vProgress.Min := 0;
    vProgress.Value := 0;
    vProgress.Visible := True;

    vProgress_Num := 100 / addons.weather.Action.OWM.Total_WoeID;
    for vi := 0 to addons.weather.Action.OWM.Total_WoeID do
    begin
      SetLength(addons.weather.Action.OWM.Data_Town, addons.weather.Action.OWM.Total_WoeID + 1);
      vProgress_Text.text := 'Getting forecast for "' + addons.weather.Action.OWM.Towns_List.Strings[vi] + '"';
      Application.ProcessMessages;
      addons.weather.Action.OWM.Data_Town[vi] := Get_Forecast(vi, addons.weather.Action.OWM.Woeid_List.Strings[vi]);
      Main_Create_Town(addons.weather.Action.OWM.Data_Town[vi], vi);
      vProgress.Value := vProgress.Value + vProgress_Num;
      vIcon.text := uWeather_Providers_Yahoo.Get_Icon_From_Text(Random(47).ToString);
      Application.ProcessMessages;
    end;

    if addons.weather.Action.OWM.Total_WoeID > 0 then
      vWeather.Scene.Arrow_Right.Visible := True;

    FreeAndNil(vProgress);
    FreeAndNil(vProgress_Text);
    FreeAndNil(vText);
    FreeAndNil(vIcon);
    FreeAndNil(vBackground);
  end
  else
    vWeather.Scene.Back.bitmap.LoadFromFile(uDB_AUser.Local.ADDONS.Weather_D.p_Images + 'w_addtowns.png');
end;

procedure Show_Selected_Time_Forecast(vLine, vPlace: Integer);
var
  vList_Num: Integer;
begin
  extrafe.prog.State := 'addon_weather_owm_five_info';
  vWeather.Scene.Blur.TagString := 'addon_weather';
  vWeather.Scene.Blur.Enabled := True;

  vList_Num := ((vLine * 8) + vPlace) - vNA_Count;

  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel := TPanel.Create(vWeather.Scene.weather);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel.Name := 'A_W_Provider_OpenWeatherMap_Five_Info';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel.Parent := vWeather.Scene.weather;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel.SetBounds((vWeather.Scene.Back.Width / 2) - 375, 90, 750, 600);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel.Visible := True;

  CreateHeader(vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel, 'IcoMoon-Free', #$ea0c, 'Info for', True, vWeather.Scene.Blur);

  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Icon :=
    TText.Create(vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Icon.Name := 'A_W_Provider_OpenWeatherMap_Five_Info_Icon';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Icon.Parent := vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Icon.SetBounds(275, 120, 200, 200);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Icon.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Icon.Font.Size := 72;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Icon.text :=
    Get_Icon_Text(addons.weather.Action.OWM.Data_Town[vWeather.Scene.Control.TabIndex].Five.list[vList_Num].weather.ID,
    addons.weather.Action.OWM.Data_Town[vWeather.Scene.Control.TabIndex].Five.list[vList_Num].weather.Icon);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Icon.Visible := True;

  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Date_Time :=
    TText.Create(vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Date_Time.Name := 'A_W_Provider_OpenWeatherMap_Five_Info_Date_Time';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Date_Time.Parent := vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Date_Time.SetBounds(10, 35, 200, 20);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Date_Time.text := 'Forecast for ' +
    ConvertTime(addons.weather.Action.OWM.Data_Town[vWeather.Scene.Control.TabIndex].Five.list[vList_Num].dt, '').Full;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Date_Time.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Date_Time.Visible := True;

  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp :=
    TText.Create(vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp.Name := 'A_W_Provider_OpenWeatherMap_Five_Info_Temp';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp.Parent := vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp.SetBounds(90, 200, 100, 50);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp.Font.Size := 48;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp.HorzTextAlign := TTextAlign.Trailing;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp.text := addons.weather.Action.OWM.Data_Town[vWeather.Scene.Control.TabIndex].Five.list
    [vList_Num].main.Temp + ' ' + #$f042;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp.Visible := True;

  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Thermo :=
    TText.Create(vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Thermo.Name := 'A_W_Provider_OpenWeatherMap_Five_Info_Thermo';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Thermo.Parent := vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Thermo.SetBounds(500, 160, 50, 120);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Thermo.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Thermo.Font.Size := 72;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Thermo.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Thermo.HorzTextAlign := TTextAlign.Center;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Thermo.text := #$f055;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Thermo.Visible := True;

  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Min_Arrow :=
    TText.Create(vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Min_Arrow.Name := 'A_W_Provider_OpenWeatherMap_Five_Info_Temp_Min_Arrow';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Min_Arrow.Parent := vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex]
    .Five.Info.Panel;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Min_Arrow.SetBounds(560, 200, 50, 100);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Min_Arrow.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Min_Arrow.Font.Size := 24;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Min_Arrow.TextSettings.FontColor := TAlphaColorRec.Whitesmoke;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Min_Arrow.HorzTextAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Min_Arrow.text := #$f044;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Min_Arrow.Visible := True;

  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Min :=
    TText.Create(vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Min.Name := 'A_W_Provider_OpenWeatherMap_Five_Info_Temp_Min';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Min.Parent := vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Min.SetBounds(580, 230, 100, 30);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Min.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Min.Font.Size := 24;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Min.TextSettings.FontColor := TAlphaColorRec.Whitesmoke;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Min.HorzTextAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Min.text := addons.weather.Action.OWM.Data_Town[vWeather.Scene.Control.TabIndex]
    .Five.list[vList_Num].main.Temp_Min + ' ' + #$f042;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Min.Visible := True;

  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Max_Arrow :=
    TText.Create(vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Max_Arrow.Name := 'A_W_Provider_OpenWeatherMap_Five_Info_Temp_Max_Arrow';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Max_Arrow.Parent := vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex]
    .Five.Info.Panel;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Max_Arrow.SetBounds(560, 160, 100, 50);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Max_Arrow.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Max_Arrow.Font.Size := 24;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Max_Arrow.TextSettings.FontColor := TAlphaColorRec.Red;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Max_Arrow.HorzTextAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Max_Arrow.text := #$f058;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Max_Arrow.Visible := True;

  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Max :=
    TText.Create(vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Max.Name := 'A_W_Provider_OpenWeatherMap_Five_Info_Temp_Max';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Max.Parent := vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Max.SetBounds(580, 170, 100, 30);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Max.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Max.Font.Size := 24;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Max.TextSettings.FontColor := TAlphaColorRec.Red;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Max.HorzTextAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Max.text := addons.weather.Action.OWM.Data_Town[vWeather.Scene.Control.TabIndex]
    .Five.list[vList_Num].main.Temp_Max + ' ' + #$f042;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Temp_Max.Visible := True;

  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Description :=
    TText.Create(vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Description.Name := 'A_W_Provider_OpenWeatherMap_Five_Info_Temp_Description';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Description.Parent := vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex]
    .Five.Info.Panel;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Description.SetBounds(0, 300, 750, 40);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Description.Font.Size := 18;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Description.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Description.HorzTextAlign := TTextAlign.Center;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Description.text := addons.weather.Action.OWM.Data_Town[vWeather.Scene.Control.TabIndex]
    .Five.list[vList_Num].weather.Description;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Description.Visible := True;

  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Humidity_Icon :=
    TText.Create(vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Humidity_Icon.Name := 'A_W_Provider_OpenWeatherMap_Five_Info_Temp_Humidity_Icon';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Humidity_Icon.Parent := vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex]
    .Five.Info.Panel;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Humidity_Icon.SetBounds(40, 350, 50, 50);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Humidity_Icon.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Humidity_Icon.Font.Size := 28;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Humidity_Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Humidity_Icon.HorzTextAlign := TTextAlign.Center;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Humidity_Icon.text := #$f07a;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Humidity_Icon.Visible := True;

  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Humidity :=
    TText.Create(vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Humidity.Name := 'A_W_Provider_OpenWeatherMap_Five_Info_Temp_Humidity';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Humidity.Parent := vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Humidity.SetBounds(90, 358, 100, 40);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Humidity.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Humidity.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Humidity.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Humidity.HorzTextAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Humidity.text := addons.weather.Action.OWM.Data_Town[vWeather.Scene.Control.TabIndex]
    .Five.list[vList_Num].main.Humidity + ' %';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Humidity.Visible := True;

  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Pressure_Icon :=
    TText.Create(vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Pressure_Icon.Name := 'A_W_Provider_OpenWeatherMap_Five_Info_Temp_Pressure_Icon';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Pressure_Icon.Parent := vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex]
    .Five.Info.Panel;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Pressure_Icon.SetBounds(40, 400, 50, 50);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Pressure_Icon.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Pressure_Icon.Font.Size := 28;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Pressure_Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Pressure_Icon.HorzTextAlign := TTextAlign.Center;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Pressure_Icon.text := #$f079;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Pressure_Icon.Visible := True;

  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Pressure :=
    TText.Create(vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Pressure.Name := 'A_W_Provider_OpenWeatherMap_Five_Info_Temp_Pressure';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Pressure.Parent := vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Pressure.SetBounds(90, 408, 100, 40);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Pressure.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Pressure.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Pressure.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Pressure.HorzTextAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Pressure.text :=
    Round(addons.weather.Action.OWM.Data_Town[vWeather.Scene.Control.TabIndex].Five.list[vList_Num].main.Pressure.ToSingle).ToString;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Pressure.Visible := True;

  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_Icon :=
    TText.Create(vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_Icon.Name := 'A_W_Provider_OpenWeatherMap_Five_Info_Temp_Wind_Icon';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_Icon.Parent := vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_Icon.SetBounds(375, 350, 50, 50);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_Icon.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_Icon.Font.Size := 28;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_Icon.HorzTextAlign := TTextAlign.Center;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_Icon.text := #$f050;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_Icon.Visible := True;

  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_speed :=
    TText.Create(vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_speed.Name := 'A_W_Provider_OpenWeatherMap_Five_Info_Wind_speed';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_speed.Parent := vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex]
    .Five.Info.Panel;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_speed.SetBounds(425, 350, 100, 40);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_speed.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_speed.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_speed.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_speed.HorzTextAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_speed.text :=
    Round(StrToFloat(addons.weather.Action.OWM.Data_Town[vWeather.Scene.Control.TabIndex].Five.list[vList_Num].Wind.Speed)).ToString;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_speed.Visible := True;

  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_degree :=
    TText.Create(vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_degree.Name := 'A_W_Provider_OpenWeatherMap_Five_Info_Wind_degree';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_degree.Parent := vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex]
    .Five.Info.Panel;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_degree.SetBounds(425, 380, 100, 40);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_degree.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_degree.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_degree.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_degree.HorzTextAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_degree.text :=
    Round(addons.weather.Action.OWM.Data_Town[vWeather.Scene.Control.TabIndex].Five.list[vList_Num].Wind.degree.ToSingle).ToString;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Wind_degree.Visible := True;

  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Clouds_Icon :=
    TText.Create(vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Clouds_Icon.Name := 'A_W_Provider_OpenWeatherMap_Five_Info_Temp_Clouds_Icon';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Clouds_Icon.Parent := vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex]
    .Five.Info.Panel;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Clouds_Icon.SetBounds(40, 450, 50, 50);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Clouds_Icon.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Clouds_Icon.Font.Size := 28;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Clouds_Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Clouds_Icon.HorzTextAlign := TTextAlign.Center;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Clouds_Icon.text := #$f013;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Clouds_Icon.Visible := True;

  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Clouds :=
    TText.Create(vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Clouds.Name := 'A_W_Provider_OpenWeatherMap_Five_Info_Temp_Clouds';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Clouds.Parent := vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Panel;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Clouds.SetBounds(90, 458, 100, 40);
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Clouds.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Clouds.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Clouds.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Clouds.HorzTextAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Clouds.text := addons.weather.Action.OWM.Data_Town[vWeather.Scene.Control.TabIndex]
    .Five.list[vList_Num].Clouds.all + ' %';
  vWeather.Scene.Tab_OWM[vWeather.Scene.Control.TabIndex].Five.Info.Clouds.Visible := True;
end;

procedure Main_Create_Five(vTown: TADDON_WEATHER_PROVIDER_OPENWEATHERMAP_DATATOWN; vTab: Integer);
const
  cTime: array [0 .. 7] of string = ('00:00', '03:00', '06:00', '09:00', '12:00', '15:00', '18:00', '21:00');
var
  vi, vk, vl: Integer;
  vNA: Boolean;
  vTime: String;
begin
  vWeather.Scene.Tab_OWM[vTab].Five.Box := TVertScrollBox.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Five.Box.Name := 'A_W_Provider_OpenWeatherMap_Five_Box';
  vWeather.Scene.Tab_OWM[vTab].Five.Box.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Five.Box.SetBounds(500, 10, 1410, 750);
  vWeather.Scene.Tab_OWM[vTab].Five.Box.ShowScrollBars := false;
  vWeather.Scene.Tab_OWM[vTab].Five.Box.Visible := True;
  vl := 0;
  for vi := 0 to 5 do
  begin
    vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Panel := TLayout.Create(vWeather.Scene.Tab_OWM[vTab].Five.Box);
    vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Panel.Name := 'A_W_Provider_OpenWeatherMap_Five_Day_' + vi.ToString;
    vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Panel.Parent := vWeather.Scene.Tab_OWM[vTab].Five.Box;
    vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Panel.SetBounds(5, 5 + (125 * vi), 1400, 120);
    vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Panel.Visible := True;

    vNA_Count := 0;
    if vi <> 5 then
    begin
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Line := TRadiantLine.Create(vWeather.Scene.Tab_OWM[vTab].Five.Box);
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Line.Name := 'A_W_Provider_OpenWeatherMap_Five_Day_' + vi.ToString + '_Line';
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Line.Parent := vWeather.Scene.Tab_OWM[vTab].Five.Box;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Line.SetBounds(0, (125 * (vi + 1) + -10), 1165, 5);
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Line.LineSlope := TRadiantLineSlope.Horizontal;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Line.Stroke.Kind := TBrushKind.Solid;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Line.Stroke.Color := TAlphaColorRec.Deepskyblue;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Line.Stroke.Thickness := 5;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Line.Visible := True;
    end;

    vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Box_Date := TText.Create(vWeather.Scene.Tab_OWM[vTab].Five.Box);
    vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Box_Date.Name := 'A_W_Provider_OpenWeatherMap_Five_Day_' + vi.ToString + '_BoxDate';
    vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Box_Date.Parent := vWeather.Scene.Tab_OWM[vTab].Five.Box;
    vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Box_Date.SetBounds(-10, -5 + (125 * vi), 300, 20);
    vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Box_Date.Color := TAlphaColorRec.White;
    vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Box_Date.text := ConvertTime(vTown.Five.list[vl].dt, '-').Date;
    vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Box_Date.TextSettings.HorzAlign := TTextAlign.Leading;
    vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Box_Date.TextSettings.Font.Style := vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Box_Date.TextSettings.Font.Style +
      [TFontStyle.fsItalic, TFontStyle.fsUnderline];
    vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Box_Date.Visible := True;

    for vk := 0 to 7 do
    begin
      vNA := false;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel := TLayout.Create(vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Panel);
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel.Name := 'A_W_Provider_OpenWeatherMap_Five_Day_' + vi.ToString + '_Hour_' + vk.ToString;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel.Parent := vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Panel;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel.SetBounds(0 + (145 * vk), 0, 140, 120);
      if vNA then
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel.Tag := 1
      else
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel.Tag := 0;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel.Visible := True;

      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel_Glow := TGlowEffect.Create(vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel);
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel_Glow.Name := 'A_W_Provider_OpenWeatherMap_Five_Day_' + vi.ToString + '_Hour_' + vk.ToString
        + '_Glow';
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel_Glow.Parent := vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel_Glow.Softness := 0.9;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel_Glow.Enabled := false;

      if vl <= addons.weather.Action.OWM.Data_Town[vTab].Five.cnt.ToInteger - 1 then
      begin
        vTime := ConvertTime(vTown.Five.list[vl].dt, ':').Time;
        if vTime = cTime[vk] then
        begin
          vNA := True;
          Inc(vNA_Count, 1);
        end;
      end;

      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Icon := TText.Create(vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel);
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Icon.Name := 'A_W_Provider_OpenWeatherMap_Five_Day_' + vi.ToString + '_Hour_' + vk.ToString + '_Icon';
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Icon.Parent := vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Icon.SetBounds(40, 30, 60, 60);
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Icon.Font.Family := 'Weather Icons';
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Icon.Font.Size := 38;
      if vNA = false then
      begin
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Icon.text := #$f07b;
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Icon.TextSettings.FontColor := TAlphaColorRec.Grey;
      end
      else
      begin
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Icon.text := Get_Icon_Text(vTown.Five.list[vl].weather.ID, vTown.Five.list[vl].sys.pod);
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      end;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Icon.Visible := True;

      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Time := TText.Create(vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel);
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Time.Name := 'A_W_Provider_OpenWeatherMap_Five_Day_' + vi.ToString + '_Hour_' + vk.ToString + '_Time';
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Time.Parent := vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Time.SetBounds(2, 10, 140, 20);
      if vNA = false then
      begin
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Time.text := cTime[vk];
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Time.TextSettings.FontColor := TAlphaColorRec.Grey
      end
      else
      begin
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Time.text := ConvertTime(vTown.Five.list[vl].dt, ':').Time;
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Time.TextSettings.FontColor := TAlphaColorRec.White;
      end;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Time.Visible := True;

      if vNA then
      begin
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Temp := TText.Create(vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel);
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Temp.Name := 'A_W_Provider_OpenWeatherMap_Five_Day_' + vi.ToString + '_Hour_' + vk.ToString
          + '_Temp';
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Temp.Parent := vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel;
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Temp.SetBounds(100, 40, 40, 20);
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Temp.text := vTown.Five.list[vl].main.Temp + ' ' + #$f042;
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Temp.Font.Family := 'Weather Icons';
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Temp.TextSettings.FontColor := TAlphaColorRec.White;
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Temp.Visible := True;

        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Description := TText.Create(vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel);
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Description.Name := 'A_W_Provider_OpenWeatherMap_Five_Day_' + vi.ToString + '_Hour_' + vk.ToString +
          '_Description';
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Description.Parent := vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel;
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Description.SetBounds(5, 90, 130, 20);
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Description.text := vTown.Five.list[vl].weather.Description;
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Description.TextSettings.FontColor := TAlphaColorRec.White;
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Description.Visible := True;
      end;

      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel_Over := TPanel.Create(vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Panel);
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel_Over.Name := 'A_W_Provider_OpenWeatherMap_Five_Day_Over_Layout_' + vi.ToString + '_' +
        vk.ToString;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel_Over.Parent := vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Panel;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel_Over.SetBounds(0 + (145 * vk), 0, 140, 120);
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel_Over.Tag := vi;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel_Over.TagString := vk.ToString;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel_Over.TagFloat := vTab;
      if vNA then
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel_Over.Locked := false
      else
        vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel_Over.Locked := True;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel_Over.Opacity := 0;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel_Over.OnClick := addons.weather.Input.mouse.Panel.OnMouseClick;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel_Over.OnMouseEnter := addons.weather.Input.mouse.Panel.OnMouseEnter;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel_Over.OnMouseLeave := addons.weather.Input.mouse.Panel.OnMouseLeave;
      vWeather.Scene.Tab_OWM[vTab].Five.Day[vi].Hour[vk].Panel_Over.Visible := True;

      if vNA then
        Inc(vl, 1);
    end;
  end;

end;

procedure Main_Create_Town(vTown: TADDON_WEATHER_PROVIDER_OPENWEATHERMAP_DATATOWN; vTab: Integer);
var
  vTimeZone: String;
  vPos: Integer;
  vDateTime_T: TDateTime;
  vSunrise: String;
  vSunset: String;
begin
  vWeather.Scene.Tab_OWM[vTab].Tab := TALTabItem.Create(vWeather.Scene.Control);
  vWeather.Scene.Tab_OWM[vTab].Tab.Name := 'A_W_WeatherTab_' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Tab.Parent := vWeather.Scene.Control;
  vWeather.Scene.Tab_OWM[vTab].Tab.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F.Name := 'A_W_Provider_OpenWeatherMap_Unit_F';
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F.SetBounds(16, 90, 42, 42);
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F.Font.Size := 36;
  if addons.weather.Action.Yahoo.Selected_Unit = 'imperial' then
    vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F.Color := TAlphaColorRec.Deepskyblue
  else
    vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F.text := #$f045;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F.OnClick := addons.weather.Input.mouse.text.OnMouseClick;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F.OnMouseEnter := addons.weather.Input.mouse.text.OnMouseEnter;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F.OnMouseLeave := addons.weather.Input.mouse.text.OnMouseLeave;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F_Glow := TGlowEffect.Create(vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F);
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F_Glow.Name := 'A_W_Provider_OpenWeatherMap_Unit_F_Glow';
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F_Glow.Parent := vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F_Glow.Opacity := 0.9;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F_Glow.Softness := 0.4;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_F_Glow.Enabled := false;

  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C.Name := 'A_W_Provider_OpenWeatherMap_Unit_C';
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C.SetBounds(16, 140, 42, 42);
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C.Font.Size := 36;
  if addons.weather.Action.Yahoo.Selected_Unit = 'metric' then
    vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C.Color := TAlphaColorRec.Deepskyblue
  else
    vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C.text := #$f03c;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C.OnClick := addons.weather.Input.mouse.text.OnMouseClick;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C.OnMouseEnter := addons.weather.Input.mouse.text.OnMouseEnter;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C.OnMouseLeave := addons.weather.Input.mouse.text.OnMouseLeave;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C_Glow := TGlowEffect.Create(vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C);
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C_Glow.Name := 'A_W_Provider_OpenWeatherMap_C_Glow';
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C_Glow.Parent := vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C_Glow.Opacity := 0.9;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C_Glow.Softness := 0.4;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature_Unit_C_Glow.Enabled := false;

  vWeather.Scene.Tab_OWM[vTab].General.Date := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].General.Date.Name := 'A_W_Provider_OpenWeatherMap_Date_' + vTab.ToString;
  vWeather.Scene.Tab_OWM[vTab].General.Date.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].General.Date.SetBounds(16, 10, 300, 30);
  vWeather.Scene.Tab_OWM[vTab].General.Date.text := ConvertTime(vTown.Current.Date_Time, '/').Date;
  vWeather.Scene.Tab_OWM[vTab].General.Date.Font.Size := 18;
  vWeather.Scene.Tab_OWM[vTab].General.Date.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vTab].General.Date.HorzTextAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vTab].General.Date.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].General.Time := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].General.Time.Name := 'A_W_Provider_OpenWeatherMap_Time_' + vTab.ToString;
  vWeather.Scene.Tab_OWM[vTab].General.Time.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].General.Time.SetBounds(440, 10, 100, 30);
  vWeather.Scene.Tab_OWM[vTab].General.Time.text := FormatDateTime('hh:mm', Now);
  vWeather.Scene.Tab_OWM[vTab].General.Time.Font.Size := 18;
  vWeather.Scene.Tab_OWM[vTab].General.Time.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vTab].General.Time.HorzTextAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vTab].General.Time.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].General.Time_Icon := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].General.Time_Icon.Name := 'A_W_Provider_OpenWeatherMap_Time_Icon_' + vTab.ToString;
  vWeather.Scene.Tab_OWM[vTab].General.Time_Icon.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].General.Time_Icon.SetBounds(416, 10, 32, 32);
  vWeather.Scene.Tab_OWM[vTab].General.Time_Icon.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vTab].General.Time_Icon.text := Get_Icon_Time(FormatDateTime('hh', Now) + ':00');
  vWeather.Scene.Tab_OWM[vTab].General.Time_Icon.Font.Size := 24;
  vWeather.Scene.Tab_OWM[vTab].General.Time_Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vTab].General.Time_Icon.HorzTextAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vTab].General.Time_Icon.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].General.Text_Image := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].General.Text_Image.Name := 'A_W_Provider_OpenWeatherMap_Yahoo_Text_Image_' + vTab.ToString;
  vWeather.Scene.Tab_OWM[vTab].General.Text_Image.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].General.Text_Image.SetBounds(50, 60, 150, 150);
  vWeather.Scene.Tab_OWM[vTab].General.Text_Image.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vTab].General.Text_Image.Font.Size := 72;
  vWeather.Scene.Tab_OWM[vTab].General.Text_Image.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vTab].General.Text_Image.text := Get_Icon_Text(vTown.Current.weather.ID, vTown.Current.weather.Icon);
  vWeather.Scene.Tab_OWM[vTab].General.Text_Image.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].General.Temprature := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].General.Temprature.Name := 'A_W_Provider_OpenWeatherMap_Temprature_' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].General.Temprature.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature.SetBounds(220, 100, 120, 50);
  vWeather.Scene.Tab_OWM[vTab].General.Temprature.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vTab].General.Temprature.Font.Size := 48;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature.text := vTown.Current.main.Temp + ' ' + #$f042;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vTab].General.Temprature.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].General.Thermometer := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].General.Thermometer.Name := 'A_W_Provider_OpenWeatherMap_Thermometer';
  vWeather.Scene.Tab_OWM[vTab].General.Thermometer.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].General.Thermometer.SetBounds(320, 110, 60, 60);
  vWeather.Scene.Tab_OWM[vTab].General.Thermometer.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vTab].General.Thermometer.Font.Size := 48;
  vWeather.Scene.Tab_OWM[vTab].General.Thermometer.Color := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vTab].General.Thermometer.text := #$f055;
  vWeather.Scene.Tab_OWM[vTab].General.Thermometer.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].General.Low_Icon := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].General.Low_Icon.Name := 'A_W_Provider_OpenWeatherMap_Low_Icon';
  vWeather.Scene.Tab_OWM[vTab].General.Low_Icon.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].General.Low_Icon.SetBounds(350, 128, 60, 60);
  vWeather.Scene.Tab_OWM[vTab].General.Low_Icon.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vTab].General.Low_Icon.Font.Size := 24;
  vWeather.Scene.Tab_OWM[vTab].General.Low_Icon.Color := TAlphaColorRec.Whitesmoke;
  vWeather.Scene.Tab_OWM[vTab].General.Low_Icon.text := #$f044;
  vWeather.Scene.Tab_OWM[vTab].General.Low_Icon.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].General.Low := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].General.Low.Name := 'A_W_Provider_OpenWeatherMap_Low';
  vWeather.Scene.Tab_OWM[vTab].General.Low.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].General.Low.SetBounds(370, 142, 70, 30);
  vWeather.Scene.Tab_OWM[vTab].General.Low.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vTab].General.Low.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vTab].General.Low.Color := TAlphaColorRec.Whitesmoke;
  vWeather.Scene.Tab_OWM[vTab].General.Low.text := vTown.Five.list[0].main.Temp_Min + ' ' + #$f042;
  vWeather.Scene.Tab_OWM[vTab].General.Low.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].General.High_Icon := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].General.High_Icon.Name := 'A_W_Provider_OpenWeatherMap_High_Icon';
  vWeather.Scene.Tab_OWM[vTab].General.High_Icon.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].General.High_Icon.SetBounds(350, 90, 60, 60);
  vWeather.Scene.Tab_OWM[vTab].General.High_Icon.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vTab].General.High_Icon.Font.Size := 24;
  vWeather.Scene.Tab_OWM[vTab].General.High_Icon.Color := TAlphaColorRec.Red;
  vWeather.Scene.Tab_OWM[vTab].General.High_Icon.text := #$f058;
  vWeather.Scene.Tab_OWM[vTab].General.High_Icon.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].General.High := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].General.High.Name := 'A_W_Provider_OpenWeatherMap_High';
  vWeather.Scene.Tab_OWM[vTab].General.High.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].General.High.SetBounds(370, 104, 70, 30);
  vWeather.Scene.Tab_OWM[vTab].General.High.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vTab].General.High.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vTab].General.High.Color := TAlphaColorRec.Red;
  vWeather.Scene.Tab_OWM[vTab].General.High.text := vTown.Five.list[0].main.Temp_Max + ' ' + #$f042;
  vWeather.Scene.Tab_OWM[vTab].General.High.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].General.Condtition := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].General.Condtition.Name := 'A_W_Provider_OpenWeatherMap_Condtition_' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].General.Condtition.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].General.Condtition.SetBounds(60, 200, 600, 30);
  vWeather.Scene.Tab_OWM[vTab].General.Condtition.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vTab].General.Condtition.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vTab].General.Condtition.text := vTown.Current.weather.Description;
  vWeather.Scene.Tab_OWM[vTab].General.Condtition.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vTab].General.Condtition.Tag := vTab;
  vWeather.Scene.Tab_OWM[vTab].General.Condtition.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Wind.text := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Wind.text.Name := 'A_W_Provider_OpenWeatherMap_Wind_' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Wind.text.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Wind.text.SetBounds(160, 350, 32, 32);
  vWeather.Scene.Tab_OWM[vTab].Wind.text.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vTab].Wind.text.Font.Size := 26;
  vWeather.Scene.Tab_OWM[vTab].Wind.text.Color := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vTab].Wind.text.text := #$f050;
  vWeather.Scene.Tab_OWM[vTab].Wind.text.Visible := True;
  vWeather.Scene.Tab_OWM[vTab].Wind.text.Width := 80;

  vWeather.Scene.Tab_OWM[vTab].Wind.Speed := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Wind.Speed.Name := 'A_W_Provider_OpenWeatherMap_WindSpeed' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Wind.Speed.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Wind.Speed.SetBounds(130, 404, 200, 30);
  vWeather.Scene.Tab_OWM[vTab].Wind.Speed.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vTab].Wind.Speed.Color := TAlphaColorRec.White;
  // if addons.weather.Action.Yahoo.Selected_Unit = 'imperial' then
  // vWeather.Scene.Tab[vTab].Wind.Speed.Text := 'Speed : ' + vTown.Observation.WindSpeed + ' mph'
  // else if addons.weather.Action.Yahoo.Selected_Unit = 'metric' then
  vWeather.Scene.Tab_OWM[vTab].Wind.Speed.text := 'Speed : ' + vTown.Current.Wind.Speed + ' kmph';
  vWeather.Scene.Tab_OWM[vTab].Wind.Speed.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vTab].Wind.Speed.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Wind.Direction := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Wind.Direction.Name := 'A_W_Provider_OpenWeatherMap_WindDiretion' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Wind.Direction.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Wind.Direction.SetBounds(160, 380, 200, 30);
  vWeather.Scene.Tab_OWM[vTab].Wind.Direction.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vTab].Wind.Direction.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vTab].Wind.Direction.text := vTown.Current.Wind.degree;
  vWeather.Scene.Tab_OWM[vTab].Wind.Direction.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vTab].Wind.Direction.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Wind.Direction_Arrow := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Wind.Direction_Arrow.Name := 'A_W_Provider_OpenWeatherMap_WindDirection_Arrow' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Wind.Direction_Arrow.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Wind.Direction_Arrow.SetBounds(240, 360, 32, 32);
  vWeather.Scene.Tab_OWM[vTab].Wind.Direction_Arrow.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vTab].Wind.Direction_Arrow.Font.Size := 26;
  vWeather.Scene.Tab_OWM[vTab].Wind.Direction_Arrow.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vTab].Wind.Direction_Arrow.text := #$f0b1;
  if vTown.Current.Wind.degree > '' then
    vWeather.Scene.Tab_OWM[vTab].Wind.Direction_Arrow.RotationAngle := StrToFloat(vTown.Current.Wind.degree)
  else
    vWeather.Scene.Tab_OWM[vTab].Wind.Direction_Arrow.RotationAngle := 0;
  vWeather.Scene.Tab_OWM[vTab].Wind.Direction_Arrow.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small_Stand := TImage.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small_Stand.Name := 'A_W_Provider_OpenWeatherMap_Wind_Small_Turbine_Stand_' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small_Stand.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small_Stand.SetBounds(100, 360, 43, 52);
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small_Stand.WrapMode := TImageWrapMode.Fit;
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small_Stand.bitmap.LoadFromFile(uDB_AUser.Local.ADDONS.Weather_D.p_Images + 'w_stand.png');
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small_Stand.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small := TImage.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small.Name := 'A_W_Provider_OpenWeatherMap_Wind_Small_Turbine_' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small.SetBounds(94, 335, 54, 54);
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small.WrapMode := TImageWrapMode.Stretch;
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small.bitmap.LoadFromFile(uDB_AUser.Local.ADDONS.Weather_D.p_Images + 'w_turbine.png');
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small_Animation := TFloatAnimation.Create(vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small);
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small_Animation.Name := 'A_W_Provider_OpenWeatherMap_Wind_Small_Turbine_Animation_' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small_Animation.Parent := vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small;
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small_Animation.PropertyName := 'RotationAngle';
  if addons.weather.Action.Yahoo.Selected_Unit = 'imperial' then
    vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small_Animation.Duration := Convert_Wind((Round(StrToFloat(vTown.Current.Wind.Speed) * 1.8)))
  else if addons.weather.Action.Yahoo.Selected_Unit = 'metric' then
    vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small_Animation.Duration := Convert_Wind(Round(vTown.Current.Wind.Speed.ToSingle));
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small_Animation.StartValue := 0;
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small_Animation.StopValue := 360;
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small_Animation.Loop := True;
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Small_Animation.Enabled := True;

  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Stand := TImage.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Stand.Name := 'A_W_Provider_OpenWeatherMap_Wind_Turbine_Stand_' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Stand.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Stand.SetBounds(60, 370, 53, 64);
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Stand.WrapMode := TImageWrapMode.Fit;
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Stand.bitmap.LoadFromFile(uDB_AUser.Local.ADDONS.Weather_D.p_Images + 'w_stand.png');
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Stand.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine := TImage.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine.Name := 'A_W_Provider_OpenWeatherMap_Wind_Turbine_' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine.SetBounds(54, 335, 64, 64);
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine.WrapMode := TImageWrapMode.Stretch;
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine.bitmap.LoadFromFile(uDB_AUser.Local.ADDONS.Weather_D.p_Images + 'w_turbine.png');
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Animation := TFloatAnimation.Create(vWeather.Scene.Tab_OWM[vTab].Wind.Turbine);
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Animation.Name := 'A_W_Provider_OpenWeatherMap_Wind_Turbine_Animation_' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Animation.Parent := vWeather.Scene.Tab_OWM[vTab].Wind.Turbine;
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Animation.PropertyName := 'RotationAngle';
  if addons.weather.Action.Yahoo.Selected_Unit = 'imperial' then
    vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Animation.Duration := Convert_Wind((Round(StrToFloat(vTown.Current.Wind.Speed) * 1.8) - 1))
  else if addons.weather.Action.Yahoo.Selected_Unit = 'metric' then
    vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Animation.Duration := Convert_Wind(Round(vTown.Current.Wind.Speed.ToSingle));
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Animation.StartValue := 0;
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Animation.StopValue := 360;
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Animation.Loop := True;
  vWeather.Scene.Tab_OWM[vTab].Wind.Turbine_Animation.Enabled := True;

  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Pressure_Icon := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Pressure_Icon.Name := 'A_W_Provider_OpenWeatherMap_Atmosphere_Pressure_Icon' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Pressure_Icon.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Pressure_Icon.SetBounds(60, 470, 32, 32);
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Pressure_Icon.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Pressure_Icon.Font.Size := 26;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Pressure_Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Pressure_Icon.text := #$f079;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Pressure_Icon.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Pressure := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Pressure.Name := 'A_W_Provider_OpenWeatherMap_Atmosphere_Pressure' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Pressure.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Pressure.SetBounds(100, 470, 200, 30);
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Pressure.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Pressure.Color := TAlphaColorRec.White;
  if addons.weather.Action.Yahoo.Selected_Unit = 'imperial' then
    vWeather.Scene.Tab_OWM[vTab].Atmosphere.Pressure.text := vTown.Current.main.Pressure + ' inHg'
  else if addons.weather.Action.Yahoo.Selected_Unit = 'metric' then
    vWeather.Scene.Tab_OWM[vTab].Atmosphere.Pressure.text := vTown.Current.main.Pressure + ' mb';
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Pressure.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Pressure.Tag := vTab;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Pressure.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Humidity_Icon := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Humidity_Icon.Name := 'A_W_Provider_OpenWeatherMap_Atmosphere_Humidity_Icon_' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Humidity_Icon.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Humidity_Icon.SetBounds(60, 550, 32, 32);
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Humidity_Icon.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Humidity_Icon.Font.Size := 26;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Humidity_Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Humidity_Icon.text := #$f07a;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Humidity_Icon.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Humidity := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Humidity.Name := 'A_W_Provider_OpenWeatherMap_Atmosphere_Humidity' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Humidity.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Humidity.SetBounds(100, 550, 200, 30);
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Humidity.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Humidity.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Humidity.text := vTown.Current.main.Humidity + '%';
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Humidity.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.Humidity.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Atmosphere.UV := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.UV.Name := 'A_W_Provider_OpenWeatherMap_Atmosphere_Ultraviolet_' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.UV.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.UV.SetBounds(300, 470, 300, 30);
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.UV.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.UV.Color := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.UV.text := 'Ultraviolet (UV)';
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.UV.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.UV.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Atmosphere.UV_Index := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.UV_Index.Name := 'A_W_Provider_OpenWeatherMap_Atmosphere_Ultraviolet_Index' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.UV_Index.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.UV_Index.SetBounds(300, 490, 300, 30);
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.UV_Index.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.UV_Index.Color := TAlphaColorRec.White;;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.UV_Index.text := 'Index : ' + vTown.UV.Current.Value;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.UV_Index.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vTab].Atmosphere.UV_Index.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunrise_Image := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunrise_Image.Name := 'A_W_Provider_OpenWeatherMap_Astronomy_Sunrise_Image_' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunrise_Image.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunrise_Image.SetBounds(60, 710, 42, 42);
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunrise_Image.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunrise_Image.Font.Size := 36;
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunrise_Image.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunrise_Image.text := #$f051;
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunrise_Image.Visible := True;

  vTimeZone := ConvertTime(vTown.Current.timezone, ':').Time;
  vPos := Pos(':', vTimeZone);
  vTimeZone := Trim(Copy(vTimeZone, 0, vPos - 1));

  vPos := Pos('-', vTown.Current.timezone);
  if vPos <> 0 then
  begin
    vTimeZone := (24 - vTimeZone.ToInteger).ToString;
    { Sunrize }
    vDateTime_T := StrToDateTime(ConvertTime(vTown.Current.sys.Sunrise, ':').DateTime_Delphi);
    vDateTime_T := IncHour(vDateTime_T, -(vTimeZone.ToInteger));
    vSunrise := FormatDateTime('t', vDateTime_T);
    { Sunset }
    vDateTime_T := StrToDateTime(ConvertTime(vTown.Current.sys.Sunset, ':').DateTime_Delphi);
    vDateTime_T := IncHour(vDateTime_T, -(vTimeZone.ToInteger));
    vSunset := FormatDateTime('t', vDateTime_T);
  end
  else
  begin
    { Sunrize }
    vDateTime_T := StrToDateTime(ConvertTime(vTown.Current.sys.Sunrise, ':').DateTime_Delphi);
    vDateTime_T := IncHour(vDateTime_T, vTimeZone.ToInteger);
    vSunrise := FormatDateTime('t', vDateTime_T);
    { Sunset }
    vDateTime_T := StrToDateTime(ConvertTime(vTown.Current.sys.Sunset, ':').DateTime_Delphi);
    vDateTime_T := IncHour(vDateTime_T, vTimeZone.ToInteger);
    vSunset := FormatDateTime('t', vDateTime_T);
  end;

  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunrise := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunrise.Name := 'A_W_Provider_OpenWeatherMap_Astronomy_Sunrise_' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunrise.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunrise.SetBounds(60, 740, 100, 30);
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunrise.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunrise.Color := TAlphaColorRec.White;

  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunrise.text := vSunrise;
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunrise.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunrise.Tag := vTab;
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunrise.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunset_Image := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunset_Image.Name := 'A_W_Provider_OpenWeatherMap_Astronomy_Sunset_Image_' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunset_Image.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunset_Image.SetBounds(430, 710, 42, 42);
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunset_Image.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunset_Image.Font.Size := 36;
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunset_Image.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunset_Image.text := #$f052;
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunset_Image.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunset := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunset.Name := 'A_W_Provider_OpenWeatherMap_Astronomy_Sunset_' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunset.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunset.SetBounds(430, 740, 100, 30);
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunset.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunset.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunset.text := vSunset;
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunset.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunset.Tag := vTab;
  vWeather.Scene.Tab_OWM[vTab].Astronomy.Sunset.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Server.Powered_By := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Server.Powered_By.Name := 'A_W_Provider_OpenWeatherMap_Powered_By_' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Server.Powered_By.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Server.Powered_By.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vTab].Server.Powered_By.Color := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vTab].Server.Powered_By.Position.Y := 710;
  vWeather.Scene.Tab_OWM[vTab].Server.Powered_By.text := 'Powered by : ';
  vWeather.Scene.Tab_OWM[vTab].Server.Powered_By.Tag := vTab;
  vWeather.Scene.Tab_OWM[vTab].Server.Powered_By.Visible := True;
  vWeather.Scene.Tab_OWM[vTab].Server.Powered_By.Width := uSnippet_Text_ToPixels(vWeather.Scene.Tab_OWM[vTab].Server.Powered_By);
  vWeather.Scene.Tab_OWM[vTab].Server.Powered_By.Position.X := vWeather.Scene.Tab_OWM[vTab].Tab.Width -
    (vWeather.Scene.Tab_OWM[vTab].Server.Powered_By.Width + 70);

  vWeather.Scene.Tab_OWM[vTab].Server.Icon := TImage.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Server.Icon.Name := 'A_W_Provider_OpenWeatherMap_Powered_By_Yahoo_Icon_' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].Server.Icon.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Server.Icon.Width := 64;
  vWeather.Scene.Tab_OWM[vTab].Server.Icon.Height := 64;
  vWeather.Scene.Tab_OWM[vTab].Server.Icon.Position.X := vWeather.Scene.Tab_OWM[vTab].Tab.Width - 70;
  vWeather.Scene.Tab_OWM[vTab].Server.Icon.Position.Y := 700;
  vWeather.Scene.Tab_OWM[vTab].Server.Icon.WrapMode := TImageWrapMode.Fit;
  vWeather.Scene.Tab_OWM[vTab].Server.Icon.bitmap.LoadFromFile(uDB_AUser.Local.ADDONS.Weather_D.p_Images + 'w_openweathermap.png');
  vWeather.Scene.Tab_OWM[vTab].Server.Icon.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].country.LastUpDate := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].country.LastUpDate.Name := 'A_W_Provider_OpenWeatherMap_Last_UpDate';
  vWeather.Scene.Tab_OWM[vTab].country.LastUpDate.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].country.LastUpDate.SetBounds(extrafe.res.Half_Width - 200, vWeather.Scene.Tab_OWM[vTab].Tab.Height - 146, 400, 30);
  vWeather.Scene.Tab_OWM[vTab].country.LastUpDate.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vTab].country.LastUpDate.Color := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vTab].country.LastUpDate.text := 'Last Update: ' + ConvertTime(vTown.Current.Date_Time, '').Full;
  vWeather.Scene.Tab_OWM[vTab].country.LastUpDate.HorzTextAlign := TTextAlign.Center;
  vWeather.Scene.Tab_OWM[vTab].country.LastUpDate.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].country.Town_and_Country := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].country.Town_and_Country.Name := 'A_W_Provider_OpenWeatherMap_TownAndCountry_' + IntToStr(vTab);
  vWeather.Scene.Tab_OWM[vTab].country.Town_and_Country.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].country.Town_and_Country.SetBounds(0, vWeather.Scene.Tab_OWM[vTab].Tab.Height - 120, extrafe.res.Width, 50);
  vWeather.Scene.Tab_OWM[vTab].country.Town_and_Country.Font.Size := 42;
  vWeather.Scene.Tab_OWM[vTab].country.Town_and_Country.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vTab].country.Town_and_Country.text := vTown.Current.Name + ' - ' + vTown.Current.sys.country;
  vWeather.Scene.Tab_OWM[vTab].country.Town_and_Country.TextSettings.HorzAlign := TTextAlign.Center;
  vWeather.Scene.Tab_OWM[vTab].country.Town_and_Country.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].country.Latidute := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].country.Latidute.Name := 'A_W_Provider_OpenWeatherMap_CountryLatitude';
  vWeather.Scene.Tab_OWM[vTab].country.Latidute.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].country.Latidute.SetBounds(extrafe.res.Half_Width - 200, vWeather.Scene.Tab_OWM[vTab].Tab.Height - 60, 150, 30);
  vWeather.Scene.Tab_OWM[vTab].country.Latidute.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vTab].country.Latidute.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vTab].country.Latidute.text := 'Lat : ' + vTown.Current.coord.lat;
  vWeather.Scene.Tab_OWM[vTab].country.Latidute.HorzTextAlign := TTextAlign.Center;
  vWeather.Scene.Tab_OWM[vTab].country.Latidute.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].country.Earth := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].country.Earth.Name := 'A_W_Provider_OpenWeatherMap_Earth_' + vTab.ToString;
  vWeather.Scene.Tab_OWM[vTab].country.Earth.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].country.Earth.SetBounds(extrafe.res.Half_Width - 16, vWeather.Scene.Tab_OWM[vTab].Tab.Height - 60, 32, 32);
  vWeather.Scene.Tab_OWM[vTab].country.Earth.Font.Family := 'IcoMoon-Free';
  vWeather.Scene.Tab_OWM[vTab].country.Earth.Font.Size := 26;
  vWeather.Scene.Tab_OWM[vTab].country.Earth.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vTab].country.Earth.text := #$e9ca;
  vWeather.Scene.Tab_OWM[vTab].country.Earth.OnClick := addons.weather.Input.mouse.text.OnMouseClick;
  vWeather.Scene.Tab_OWM[vTab].country.Earth.OnMouseEnter := addons.weather.Input.mouse.text.OnMouseEnter;
  vWeather.Scene.Tab_OWM[vTab].country.Earth.OnMouseLeave := addons.weather.Input.mouse.text.OnMouseLeave;
  vWeather.Scene.Tab_OWM[vTab].country.Earth.HorzTextAlign := TTextAlign.Center;
  vWeather.Scene.Tab_OWM[vTab].country.Earth.TagString := vTab.ToString;
  vWeather.Scene.Tab_OWM[vTab].country.Earth.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].country.Earth_Glow := TGlowEffect.Create(vWeather.Scene.Tab_OWM[vTab].country.Earth);
  vWeather.Scene.Tab_OWM[vTab].country.Earth_Glow.Name := 'A_W_Provider_OpenWeatherMap_Earth_Glow';
  vWeather.Scene.Tab_OWM[vTab].country.Earth_Glow.Parent := vWeather.Scene.Tab_OWM[vTab].country.Earth;
  vWeather.Scene.Tab_OWM[vTab].country.Earth_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vTab].country.Earth_Glow.Opacity := 0.9;
  vWeather.Scene.Tab_OWM[vTab].country.Earth_Glow.Softness := 0.4;
  vWeather.Scene.Tab_OWM[vTab].country.Earth_Glow.Enabled := false;

  vWeather.Scene.Tab_OWM[vTab].country.Longidute := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].country.Longidute.Name := 'A_W_Provider_OpenWeatherMap_Country_Longidute';
  vWeather.Scene.Tab_OWM[vTab].country.Longidute.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].country.Longidute.SetBounds(extrafe.res.Half_Width + 50, vWeather.Scene.Tab_OWM[vTab].Tab.Height - 60, 150, 30);
  vWeather.Scene.Tab_OWM[vTab].country.Longidute.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vTab].country.Longidute.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vTab].country.Longidute.text := 'Long : ' + vTown.Current.coord.lon;
  vWeather.Scene.Tab_OWM[vTab].country.Longidute.HorzTextAlign := TTextAlign.Center;
  vWeather.Scene.Tab_OWM[vTab].country.Longidute.Visible := True;
  //
  Main_Create_Five(vTown, vTab);
  //
  vWeather.Scene.Tab_OWM[vTab].Moon.text := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Moon.text.Name := 'A_W_Provider_OpenWeatherMap_Moon';
  vWeather.Scene.Tab_OWM[vTab].Moon.text.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Moon.text.SetBounds(1690, 60, 200, 30);
  vWeather.Scene.Tab_OWM[vTab].Moon.text.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vTab].Moon.text.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vTab].Moon.text.text := 'Moon Phase ';
  vWeather.Scene.Tab_OWM[vTab].Moon.text.HorzTextAlign := TTextAlign.Center;
  vWeather.Scene.Tab_OWM[vTab].Moon.text.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Moon.Icon := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Moon.Icon.Name := 'A_W_Provider_OpenWeatherMap_Moon_Phase';
  vWeather.Scene.Tab_OWM[vTab].Moon.Icon.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Moon.Icon.SetBounds(1770, 90, 48, 48);
  vWeather.Scene.Tab_OWM[vTab].Moon.Icon.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vTab].Moon.Icon.Font.Size := 32;
  vWeather.Scene.Tab_OWM[vTab].Moon.Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  // vWeather.Scene.Tab[vTab].General.Moon_Phase.Text := Get_Moon_Phase(vTown.SunAndMoon.MoonPhase);
  vWeather.Scene.Tab_OWM[vTab].Moon.Icon.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Refresh.text := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Refresh.text.Name := 'A_W_Provider_OpenWeatherMap_Refresh_Text';
  vWeather.Scene.Tab_OWM[vTab].Refresh.text.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Refresh.text.SetBounds(1690, 200, 200, 30);
  vWeather.Scene.Tab_OWM[vTab].Refresh.text.Font.Size := 16;
  vWeather.Scene.Tab_OWM[vTab].Refresh.text.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Scene.Tab_OWM[vTab].Refresh.text.text := 'Refresh Current Town';
  vWeather.Scene.Tab_OWM[vTab].Refresh.text.HorzTextAlign := TTextAlign.Center;
  vWeather.Scene.Tab_OWM[vTab].Refresh.text.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Refresh.Icon := TText.Create(vWeather.Scene.Tab_OWM[vTab].Tab);
  vWeather.Scene.Tab_OWM[vTab].Refresh.Icon.Name := 'A_W_Provider_OpenWeatherMap_Refresh';
  vWeather.Scene.Tab_OWM[vTab].Refresh.Icon.Parent := vWeather.Scene.Tab_OWM[vTab].Tab;
  vWeather.Scene.Tab_OWM[vTab].Refresh.Icon.SetBounds(1770, 230, 48, 48);
  vWeather.Scene.Tab_OWM[vTab].Refresh.Icon.Font.Family := 'Weather Icons';
  vWeather.Scene.Tab_OWM[vTab].Refresh.Icon.Font.Size := 32;
  vWeather.Scene.Tab_OWM[vTab].Refresh.Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vTab].Refresh.Icon.text := #$f04c;
  vWeather.Scene.Tab_OWM[vTab].Refresh.Icon.OnClick := addons.weather.Input.mouse.text.OnMouseClick;
  vWeather.Scene.Tab_OWM[vTab].Refresh.Icon.OnMouseEnter := addons.weather.Input.mouse.text.OnMouseEnter;
  vWeather.Scene.Tab_OWM[vTab].Refresh.Icon.OnMouseLeave := addons.weather.Input.mouse.text.OnMouseLeave;
  vWeather.Scene.Tab_OWM[vTab].Refresh.Icon.Visible := True;

  vWeather.Scene.Tab_OWM[vTab].Refresh.Glow := TGlowEffect.Create(vWeather.Scene.Tab_OWM[vTab].Refresh.Icon);
  vWeather.Scene.Tab_OWM[vTab].Refresh.Glow.Name := 'A_W_Provider_OpenWeatherMap_Refresh_Glow';
  vWeather.Scene.Tab_OWM[vTab].Refresh.Glow.Parent := vWeather.Scene.Tab_OWM[vTab].Refresh.Icon;
  vWeather.Scene.Tab_OWM[vTab].Refresh.Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab_OWM[vTab].Refresh.Glow.Opacity := 0.9;
  vWeather.Scene.Tab_OWM[vTab].Refresh.Glow.Softness := 0.4;
  vWeather.Scene.Tab_OWM[vTab].Refresh.Glow.Enabled := false;

end;

function Is_Town_Exists(vWoeid: String): Boolean;
var
  vi: Integer;
begin
  Result := false;
  for vi := 0 to addons.weather.Action.OWM.Towns_List.Count - 1 do
  begin
    if addons.weather.Action.OWM.Woeid_List.Strings[vi] = vWoeid then
      Result := True;
  end;
end;

procedure Woeid_List;
var
  vi: Integer;
  vString: String;
  vIPos: Integer;
  vWoeid: String;
  vTown: String;
begin
  addons.weather.Action.OWM.Woeid_List := TStringList.Create;
  addons.weather.Action.OWM.Towns_List := TStringList.Create;

  if addons.weather.Action.OWM.Total_WoeID <> -1 then
  begin
    for vi := 0 to addons.weather.Action.OWM.Total_WoeID do
    begin
//      vString := addons.weather.Ini.Ini.ReadString('openweathermap', 'woeid_' + vi.ToString, vString);
      vIPos := Pos('_', vString);
      vWoeid := Trim(Copy(vString, 0, vIPos - 1));
      vTown := Trim(Copy(vString, vIPos + 1, Length(vString) - vIPos));
      addons.weather.Action.OWM.Woeid_List.Add(vWoeid);
      addons.weather.Action.OWM.Towns_List.Add(vTown);
    end;
  end;
end;

procedure Add_NewTown(vNum: Integer);
var
  vTemp_NewTown: TADDON_WEATHER_CONFIG_TOWNS_NEWTOWNPANEL;
begin
  if Is_Town_Exists(vOpenWeatherMap_Find_List[vNum].woeid) then
    ShowMessage('This town already exists in your list')
  else
  begin
    Inc(addons.weather.Action.OWM.Total_WoeID, 1);
    SetLength(addons.weather.Action.OWM.Data_Town, addons.weather.Action.OWM.Total_WoeID + 1);
    addons.weather.Action.OWM.Data_Town[addons.weather.Action.OWM.Total_WoeID] := Get_Forecast(addons.weather.Action.OWM.Total_WoeID,
      vOpenWeatherMap_Find_List[vNum].woeid);

    vTemp_NewTown.Time_Results := ConvertTime(addons.weather.Action.OWM.Data_Town[addons.weather.Action.OWM.Total_WoeID].Current.Date_Time, '').Full;
    vTemp_NewTown.Forecast_Image := Get_Icon_Text(addons.weather.Action.OWM.Data_Town[addons.weather.Action.OWM.Total_WoeID].Current.weather.ID,
      addons.weather.Action.OWM.Data_Town[addons.weather.Action.OWM.Total_WoeID].Current.weather.Icon);
    vTemp_NewTown.Temperature := addons.weather.Action.OWM.Data_Town[addons.weather.Action.OWM.Total_WoeID].Current.main.Temp;
    vTemp_NewTown.Temrerature_Unit := 'F';
    vTemp_NewTown.Temperature_Description := addons.weather.Action.OWM.Data_Town[addons.weather.Action.OWM.Total_WoeID].Current.weather.Description;
    vTemp_NewTown.City_Name := addons.weather.Action.OWM.Data_Town[addons.weather.Action.OWM.Total_WoeID].Current.Name;
    vTemp_NewTown.Country_Name := addons.weather.Action.OWM.Data_Town[addons.weather.Action.OWM.Total_WoeID].Current.sys.country;
    vTemp_NewTown.Country_Flag := Get_Flag(addons.weather.Action.OWM.Data_Town[addons.weather.Action.OWM.Total_WoeID].Five.city.country);

    uWeather_Providers_OpenWeatherMap_Config.Towns_Add_New_Town(addons.weather.Action.OWM.Total_WoeID, vTemp_NewTown);
    if addons.weather.Action.OWM.Total_WoeID = 0 then
      vWeather.Scene.Back.bitmap := nil;

//    { For OpenWeatherMap Ini }
//    addons.weather.Ini.Ini.WriteString('openweathermap', 'total', addons.weather.Action.OWM.Total_WoeID.ToString);
//    addons.weather.Ini.Ini.WriteString('openweathermap', 'woeid_' + addons.weather.Action.OWM.Total_WoeID.ToString,
//      vOpenWeatherMap_Find_List[vNum].woeid + '_' + vTemp_NewTown.City_Name);
//    addons.weather.Action.OWM.Woeid_List.Add(addons.weather.Action.OWM.Total_WoeID.ToString);
//    { For Global ini }
//    Inc(addons.weather.Action.Active_WOEID, 1);
//    addons.weather.Ini.Ini.WriteInteger('Active', 'Active_Woeid', addons.weather.Action.Active_WOEID);

    Main_Create_Town(addons.weather.Action.OWM.Data_Town[addons.weather.Action.OWM.Total_WoeID], addons.weather.Action.OWM.Total_WoeID);
    if addons.weather.Action.OWM.Total_WoeID > 0 then
      vWeather.Scene.Arrow_Right.Visible := True;
    vWeather.Scene.Blur.Enabled := false;
    vWeather.Scene.Blur.Enabled := True;
  end;
end;

function Get_Icon_Text(vCode_ID, vIcon: String): String;
var
  vState: String;
begin
  if vIcon = '' then
    vState := 'General'
  else if vIcon[Length(vIcon)] = 'd' then
    vState := 'Day'
  else
    vState := 'Night';

  if vCode_ID = '200' then
  begin
    if vState = 'General' then
      Result := #$f01e
    else if vState = 'Day' then
      Result := #$f010
    else
      Result := #$f02d;
  end
  else if vCode_ID = '201' then
  begin
    if vState = 'General' then
      Result := #$f01e
    else if vState = 'Day' then
      Result := #$f010
    else
      Result := #$f02d;
  end
  else if vCode_ID = '202' then
  begin
    if vState = 'General' then
      Result := #$f01e
    else if vState = 'Day' then
      Result := #$f010
    else
      Result := #$f02d;
  end
  else if vCode_ID = '210' then
  begin
    if vState = 'General' then
      Result := #$f016
    else if vState = 'Day' then
      Result := #$f005
    else
      Result := #$f025;
  end
  else if vCode_ID = '211' then
  begin
    if vState = 'General' then
      Result := #$f016
    else if vState = 'Day' then
      Result := #$f005
    else
      Result := #$f025;
  end
  else if vCode_ID = '212' then
  begin
    if vState = 'General' then
      Result := #$f016
    else if vState = 'Day' then
      Result := #$f005
    else
      Result := #$f025;
  end
  else if vCode_ID = '221' then
  begin
    if vState = 'General' then
      Result := #$f016
    else if vState = 'Day' then
      Result := #$f005
    else
      Result := #$f025;
  end
  else if vCode_ID = '230' then
  begin
    if vState = 'General' then
      Result := #$f01e
    else if vState = 'Day' then
      Result := #$f010
    else
      Result := #$f02d;
  end
  else if vCode_ID = '231' then
  begin
    if vState = 'General' then
      Result := #$f01e
    else if vState = 'Day' then
      Result := #$f010
    else
      Result := #$f02d;
  end
  else if vCode_ID = '232' then
  begin
    if vState = 'General' then
      Result := #$f01e
    else if vState = 'Day' then
      Result := #$f010
    else
      Result := #$f02d;
  end
  else if vCode_ID = '300' then
  begin
    if vState = 'General' then
      Result := #$f01c
    else if vState = 'Day' then
      Result := #$f00b
    else
      Result := #$f02b;
  end
  else if vCode_ID = '301' then
  begin
    if vState = 'General' then
      Result := #$f01c
    else if vState = 'Day' then
      Result := #$f00b
    else
      Result := #$f02b;
  end
  else if vCode_ID = '302' then
  begin
    if vState = 'General' then
      Result := #$f019
    else if vState = 'Day' then
      Result := #$f008
    else
      Result := #$f028;
  end
  else if vCode_ID = '310' then
  begin
    if vState = 'General' then
      Result := #$f017
    else if vState = 'Day' then
      Result := #$f008
    else
      Result := #$f028;
  end
  else if vCode_ID = '311' then
  begin
    if vState = 'General' then
      Result := #$f019
    else if vState = 'Day' then
      Result := #$f008
    else
      Result := #$f028;
  end
  else if vCode_ID = '312' then
  begin
    if vState = 'General' then
      Result := #$f019
    else if vState = 'Day' then
      Result := #$f008
    else
      Result := #$f028;
  end
  else if vCode_ID = '313' then
  begin
    if vState = 'General' then
      Result := #$f01a
    else if vState = 'Day' then
      Result := #$f008
    else
      Result := #$f028;
  end
  else if vCode_ID = '314' then
  begin
    if vState = 'General' then
      Result := #$f019
    else if vState = 'Day' then
      Result := #$f008
    else
      Result := #$f028;
  end
  else if vCode_ID = '321' then
  begin
    if vState = 'General' then
      Result := #$f01c
    else if vState = 'Day' then
      Result := #$f00b
    else
      Result := #$f02b;
  end
  else if vCode_ID = '500' then
  begin
    if vState = 'General' then
      Result := #$f01c
    else if vState = 'Day' then
      Result := #$f00b
    else
      Result := #$f02b;
  end
  else if vCode_ID = '501' then
  begin
    if vState = 'General' then
      Result := #$f019
    else if vState = 'Day' then
      Result := #$f008
    else
      Result := #$f028;
  end
  else if vCode_ID = '502' then
  begin
    if vState = 'General' then
      Result := #$f019
    else if vState = 'Day' then
      Result := #$f008
    else
      Result := #$f028;
  end
  else if vCode_ID = '503' then
  begin
    if vState = 'General' then
      Result := #$f019
    else if vState = 'Day' then
      Result := #$f008
    else
      Result := #$f028;
  end
  else if vCode_ID = '504' then
  begin
    if vState = 'General' then
      Result := #$f019
    else if vState = 'Day' then
      Result := #$f008
    else
      Result := #$f028;
  end
  else if vCode_ID = '511' then
  begin
    if vState = 'General' then
      Result := #$f017
    else if vState = 'Day' then
      Result := #$f006
    else
      Result := #$f026;
  end
  else if vCode_ID = '520' then
  begin
    if vState = 'General' then
      Result := #$f01a
    else if vState = 'Day' then
      Result := #$f009
    else
      Result := #$f029;
  end
  else if vCode_ID = '521' then
  begin
    if vState = 'General' then
      Result := #$f01a
    else if vState = 'Day' then
      Result := #$f009
    else
      Result := #$f029;
  end
  else if vCode_ID = '522' then
  begin
    if vState = 'General' then
      Result := #$f01a
    else if vState = 'Day' then
      Result := #$f009
    else
      Result := #$f029;
  end
  else if vCode_ID = '531' then
  begin
    if vState = 'General' then
      Result := #$f01d
    else if vState = 'Day' then
      Result := #$f00e
    else
      Result := #$f02c;
  end
  else if vCode_ID = '600' then
  begin
    if vState = 'General' then
      Result := #$f01b
    else if vState = 'Day' then
      Result := #$f00a
    else
      Result := #$f02a;
  end
  else if vCode_ID = '601' then
  begin
    if vState = 'General' then
      Result := #$f01b
    else if vState = 'Day' then
      Result := #$f0b2
    else
      Result := #$f0b4;
  end
  else if vCode_ID = '602' then
  begin
    if vState = 'General' then
      Result := #$f0b5
    else if vState = 'Day' then
      Result := #$f01b
    else
      Result := #$f02a;
  end
  else if vCode_ID = '611' then
  begin
    if vState = 'General' then
      Result := #$f017
    else if vState = 'Day' then
      Result := #$f006
    else
      Result := #$f026;
  end
  else if vCode_ID = '612' then
  begin
    if vState = 'General' then
      Result := #$f017
    else if vState = 'Day' then
      Result := #$f006
    else
      Result := #$f026;
  end
  else if vCode_ID = '615' then
  begin
    if vState = 'General' then
      Result := #$f017
    else if vState = 'Day' then
      Result := #$f006
    else
      Result := #$f026;
  end
  else if vCode_ID = '616' then
  begin
    if vState = 'General' then
      Result := #$f017
    else if vState = 'Day' then
      Result := #$f006
    else
      Result := #$f026;
  end
  else if vCode_ID = '620' then
  begin
    if vState = 'General' then
      Result := #$f017
    else if vState = 'Day' then
      Result := #$f006
    else
      Result := #$f026;
  end
  else if vCode_ID = '621' then
  begin
    if vState = 'General' then
      Result := #$f01b
    else if vState = 'Day' then
      Result := #$f00a
    else
      Result := #$f02a;
  end
  else if vCode_ID = '622' then
  begin
    if vState = 'General' then
      Result := #$f01b
    else if vState = 'Day' then
      Result := #$f00a
    else
      Result := #$f02a;
  end
  else if vCode_ID = '701' then
  begin
    if vState = 'General' then
      Result := #$f01a
    else if vState = 'Day' then
      Result := #$f009
    else
      Result := #$f029;
  end
  else if vCode_ID = '711' then
  begin
    if vState = 'General' then
      Result := #$f062
    else if vState = 'Day' then
      Result := #$f062
    else
      Result := #$f062;
  end
  else if vCode_ID = '721' then
  begin
    if vState = 'General' then
      Result := #$f0b6
    else if vState = 'Day' then
      Result := #$f0b6
    else
      Result := #$f0b6;
  end
  else if vCode_ID = '731' then
  begin
    if vState = 'General' then
      Result := #$f063
    else if vState = 'Day' then
      Result := #$f063
    else
      Result := #$f063;
  end
  else if vCode_ID = '741' then
  begin
    if vState = 'General' then
      Result := #$f014
    else if vState = 'Day' then
      Result := #$f003
    else
      Result := #$f04a;
  end
  else if vCode_ID = '761' then
  begin
    if vState = 'General' then
      Result := #$f063
    else if vState = 'Day' then
      Result := #$f063
    else
      Result := #$f063;
  end
  else if vCode_ID = '762' then
  begin
    if vState = 'General' then
      Result := #$f063
    else if vState = 'Day' then
      Result := #$f063
    else
      Result := #$f063;
  end
  else if vCode_ID = '771' then
  begin
    if vState = 'General' then
      Result := #$f011
    else if vState = 'Day' then
      Result := ''
    else
      Result := '';
  end
  else if vCode_ID = '781' then
  begin
    if vState = 'General' then
      Result := #$f056
    else if vState = 'Day' then
      Result := #$f056
    else
      Result := #$f056;
  end
  else if vCode_ID = '800' then
  begin
    if vState = 'General' then
      Result := #$f00d
    else if vState = 'Day' then
      Result := #$f00d
    else
      Result := #$f02e;
  end
  else if vCode_ID = '801' then
  begin
    if vState = 'General' then
      Result := #$f011
    else if vState = 'Day' then
      Result := #$f000
    else
      Result := #$f022;
  end
  else if vCode_ID = '802' then
  begin
    if vState = 'General' then
      Result := #$f011
    else if vState = 'Day' then
      Result := #$f000
    else
      Result := #$f022;
  end
  else if vCode_ID = '803' then
  begin
    if vState = 'General' then
      Result := #$f011
    else if vState = 'Day' then
      Result := #$f000
    else
      Result := #$f022;
  end
  else if vCode_ID = '804' then
  begin
    if vState = 'General' then
      Result := #$f013
    else if vState = 'Day' then
      Result := #$f00c
    else
      Result := #$f086;
  end
  else if vCode_ID = '900' then
  begin
    if vState = 'General' then
      Result := #$f056
    else if vState = 'Day' then
      Result := #$f056
    else
      Result := #$f056;
  end
  else if vCode_ID = '901' then
  begin
    if vState = 'General' then
      Result := #$f01d
    else if vState = 'Day' then
      Result := ''
    else
      Result := '';
  end
  else if vCode_ID = '902' then
  begin
    if vState = 'General' then
      Result := #$f073
    else if vState = 'Day' then
      Result := #$f073
    else
      Result := #$f073;
  end
  else if vCode_ID = '903' then
  begin
    if vState = 'General' then
      Result := #$f076
    else if vState = 'Day' then
      Result := #$f076
    else
      Result := #$f07;
  end
  else if vCode_ID = '904' then
  begin
    if vState = 'General' then
      Result := #$f072
    else if vState = 'Day' then
      Result := #$f072
    else
      Result := #$f072;
  end
  else if vCode_ID = '905' then
  begin
    if vState = 'General' then
      Result := #$f021
    else if vState = 'Day' then
      Result := ''
    else
      Result := '';
  end
  else if vCode_ID = '906' then
  begin
    if vState = 'General' then
      Result := #$f015
    else if vState = 'Day' then
      Result := #$f004
    else
      Result := #$f024;
  end
  else if vCode_ID = '957' then
  begin
    if vState = 'General' then
      Result := #$f050
    else if vState = 'Day' then
      Result := #$f050
    else
      Result := #$f050;
  end
end;

function Get_Flag(vCountry: String): TBitmap;
begin
  Result := TBitmap.Create;
  Result.LoadFromFile(ex_main.Paths.Flags_Images + LowerCase(vCountry) + '.png');
end;

function Unit_Type_Char: String;
begin
  if addons.weather.Action.OWM.Selected_Unit = 'Celcius' then
    Result := 'C'
  else if addons.weather.Action.OWM.Selected_Unit = 'Fahrenheit' then
    Result := 'F'
  else if addons.weather.Action.OWM.Selected_Unit = 'Kelvin' then
    Result := 'K';
end;

function Unit_Type: String;
begin
  if addons.weather.Action.OWM.Selected_Unit = 'Celcius' then
    Result := 'metric'
  else if addons.weather.Action.OWM.Selected_Unit = 'Fahrenheit' then
    Result := 'imperial'
  else if addons.weather.Action.OWM.Selected_Unit = 'Kelvin' then
    Result := 'default';
end;

function Get_Forecast(vNum: Integer; vWoeid: String): TADDON_WEATHER_PROVIDER_OPENWEATHERMAP_DATATOWN;
var
  vOutValue: String;
  vi: Integer;
  vLat, vLon: String;
  vStart_Time, vEnd_Time: String;
begin
  { Get the current day forecast data }
  vJSONValue := uInternet_Files.JSONValue('OpenWeatherMap', 'http://api.openweathermap.org/data/2.5/weather?id=' + vWoeid + '&APPID=' + cAuthor_OWM_APPID +
    '&units=' + addons.weather.Action.OWM.Selected_Unit + '&lang=' + addons.weather.Action.OWM.Language, TRESTRequestMethod.rmGET);

  Result.Current.coord.lon := vJSONValue.GetValue<String>('coord.lon');
  Result.Current.coord.lat := vJSONValue.GetValue<String>('coord.lat');
  Result.Current.weather.ID := vJSONValue.GetValue<String>('weather[0].id');
  Result.Current.weather.main := vJSONValue.GetValue<String>('weather[0].main');
  Result.Current.weather.Description := vJSONValue.GetValue<String>('weather[0].description');
  Result.Current.weather.Icon := vJSONValue.GetValue<String>('weather[0].icon');
  Result.Current.base := vJSONValue.GetValue<String>('base');
  Result.Current.main.Temp := vJSONValue.GetValue<String>('main.temp');
  Result.Current.main.Temp := Round(Result.Current.main.Temp.ToSingle).ToString;
  Result.Current.main.Pressure := vJSONValue.GetValue<String>('main.pressure');
  Result.Current.main.Humidity := vJSONValue.GetValue<String>('main.humidity');
  Result.Current.main.Min := vJSONValue.GetValue<String>('main.temp_min');
  Result.Current.main.Max := vJSONValue.GetValue<String>('main.temp_max');
  if vJSONValue.TryGetValue('main.sea_level', vOutValue) then
    Result.Current.main.sea_level := vOutValue;
  if vJSONValue.TryGetValue('main.grnd_level', vOutValue) then
    Result.Current.main.ground_level := vOutValue;
  Result.Current.Wind.Speed := vJSONValue.GetValue<String>('wind.speed');
  if vJSONValue.TryGetValue('wind.deg', vOutValue) then
    Result.Current.Wind.degree := vOutValue;
  Result.Current.Clouds.all := vJSONValue.GetValue<String>('clouds.all');
  if vJSONValue.TryGetValue('rain.1h', vOutValue) then
    Result.Current.rain.one_hour := vOutValue;
  if vJSONValue.TryGetValue('rain.3h', vOutValue) then
    Result.Current.rain.three_hours := vOutValue;
  if vJSONValue.TryGetValue('snow.1h', vOutValue) then
    Result.Current.snow.one_hour := vOutValue;
  if vJSONValue.TryGetValue('snow.2h', vOutValue) then
    Result.Current.snow.three_hours := vOutValue;
  Result.Current.Date_Time := vJSONValue.GetValue<String>('dt');
  Result.Current.sys.vtype := vJSONValue.GetValue<String>('sys.type');
  Result.Current.sys.ID := vJSONValue.GetValue<String>('sys.id');
  Result.Current.sys.vmessage := vJSONValue.GetValue<String>('sys.message');
  Result.Current.sys.country := vJSONValue.GetValue<String>('sys.country');
  Result.Current.sys.Sunrise := vJSONValue.GetValue<String>('sys.sunrise');
  Result.Current.sys.Sunset := vJSONValue.GetValue<String>('sys.sunset');
  Result.Current.timezone := vJSONValue.GetValue<String>('timezone');
  Result.Current.ID := vJSONValue.GetValue<String>('id');
  Result.Current.Name := vJSONValue.GetValue<String>('name');
  Result.Current.cod := vJSONValue.GetValue<String>('cod');

  FreeAndNil(vJSONValue);
  FreeAndNil(vRESTRequest);

  { Get the 5 days forecast data }
  vJSONValue := uInternet_Files.JSONValue('OpenWeatherMap', 'http://api.openweathermap.org/data/2.5/forecast?id=' + vWoeid + '&APPID=' + cAuthor_OWM_APPID +
    '&units=' + addons.weather.Action.OWM.Selected_Unit + '&lang=' + addons.weather.Action.OWM.Language, TRESTRequestMethod.rmGET);

  Result.Five.cod := vJSONValue.GetValue<String>('cod');
  Result.Five.vmessage := vJSONValue.GetValue<String>('message');
  Result.Five.cnt := vJSONValue.GetValue<String>('cnt');

  for vi := 0 to Result.Five.cnt.ToInteger - 1 do
  begin
    Result.Five.list[vi].dt := vJSONValue.GetValue<String>('list[' + vi.ToString + '].dt');
    Result.Five.list[vi].main.Temp := vJSONValue.GetValue<String>('list[' + vi.ToString + '].main.temp');
    Result.Five.list[vi].main.Temp := Round(Result.Five.list[vi].main.Temp.ToSingle).ToString;
    Result.Five.list[vi].main.Temp_Min := vJSONValue.GetValue<String>('list[' + vi.ToString + '].main.temp_min');
    Result.Five.list[vi].main.Temp_Min := Round(Result.Five.list[vi].main.Temp_Min.ToSingle).ToString;
    Result.Five.list[vi].main.Temp_Max := vJSONValue.GetValue<String>('list[' + vi.ToString + '].main.temp_max');
    Result.Five.list[vi].main.Temp_Max := Round(Result.Five.list[vi].main.Temp_Max.ToSingle).ToString;
    Result.Five.list[vi].main.Pressure := vJSONValue.GetValue<String>('list[' + vi.ToString + '].main.pressure');
    Result.Five.list[vi].main.sea_level := vJSONValue.GetValue<String>('list[' + vi.ToString + '].main.sea_level');
    Result.Five.list[vi].main.ground_level := vJSONValue.GetValue<String>('list[' + vi.ToString + '].main.grnd_level');
    Result.Five.list[vi].main.Humidity := vJSONValue.GetValue<String>('list[' + vi.ToString + '].main.humidity');
    Result.Five.list[vi].main.temp_kf := vJSONValue.GetValue<String>('list[' + vi.ToString + '].main.temp_kf');
    if vJSONValue.TryGetValue('list[' + vi.ToString + '].weather[0].id', vOutValue) then
      Result.Five.list[vi].weather.ID := vOutValue;
    if vJSONValue.TryGetValue('list[' + vi.ToString + '].weather[0].main', vOutValue) then
      Result.Five.list[vi].weather.main := vOutValue;
    if vJSONValue.TryGetValue('list[' + vi.ToString + '].weather[0].description', vOutValue) then
      Result.Five.list[vi].weather.Description := vOutValue;
    if vJSONValue.TryGetValue('list[' + vi.ToString + '].weather[0].icon', vOutValue) then
      Result.Five.list[vi].weather.Icon := vOutValue;
    Result.Five.list[vi].Clouds.all := vJSONValue.GetValue<String>('list[' + vi.ToString + '].clouds.all');
    Result.Five.list[vi].Wind.Speed := vJSONValue.GetValue<String>('list[' + vi.ToString + '].wind.speed');
    if vJSONValue.TryGetValue('list[' + vi.ToString + '].wind.deg', vOutValue) then
      Result.Five.list[vi].Wind.degree := vOutValue;
    if vJSONValue.TryGetValue('list[' + vi.ToString + '].rain.3h', vOutValue) then
      Result.Five.list[vi].rain.three_hours := vOutValue;
    if vJSONValue.TryGetValue('list[' + vi.ToString + '].snow.3h', vOutValue) then
      Result.Five.list[vi].snow.three_hours := vOutValue;
    Result.Five.list[vi].sys.pod := vJSONValue.GetValue<String>('list[' + vi.ToString + '].sys.pod');
    Result.Five.list[vi].Date_Time := vJSONValue.GetValue<String>('list[' + vi.ToString + '].dt_txt');
  end;

  Result.Five.city.ID := vJSONValue.GetValue<String>('city.id');
  Result.Five.city.Name := vJSONValue.GetValue<String>('city.name');
  Result.Five.city.coord.lon := vJSONValue.GetValue<String>('city.coord.lon');
  Result.Five.city.coord.lat := vJSONValue.GetValue<String>('city.coord.lat');
  Result.Five.city.country := vJSONValue.GetValue<String>('city.country');
  Result.Five.city.timezone := vJSONValue.GetValue<String>('city.timezone');

  FreeAndNil(vJSONValue);
  FreeAndNil(vRESTRequest);

  { Get UV forecast Data }
  vLat := Result.Current.coord.lat;
  vLon := Result.Current.coord.lon;
  vStart_Time := '';
  vEnd_Time := '';
  vJSONValue := uInternet_Files.JSONValue('OpenWeatherMap', 'http://api.openweathermap.org/data/2.5/uvi?lat=' + vLat + '&lon=' + vLon + '&APPID=' +
    cAuthor_OWM_APPID, TRESTRequestMethod.rmGET);

  Result.UV.Current.lat := vJSONValue.GetValue<String>('lat');
  Result.UV.Current.lon := vJSONValue.GetValue<String>('lon');
  Result.UV.Current.date_iso := vJSONValue.GetValue<String>('date_iso');
  Result.UV.Current.Date := vJSONValue.GetValue<String>('date');
  Result.UV.Current.Value := vJSONValue.GetValue<String>('value');

  FreeAndNil(vJSONValue);
  FreeAndNil(vRESTRequest);

  { Get the 8 days ahead UV Index forecast data }
  vJSONValue := uInternet_Files.JSONValue('OpenWeatherMap', 'http://api.openweathermap.org/data/2.5/uvi/forecast?lat=' + vLat + '&lon=' + vLon + '&APPID=' +
    cAuthor_OWM_APPID, TRESTRequestMethod.rmGET);

  for vi := 0 to 7 do
  begin
    if vJSONValue.TryGetValue<String>('[' + vi.ToString + '].lat', vOutValue) then
      Result.UV.ahead[vi].lat := vOutValue;
    if vJSONValue.TryGetValue<String>('[' + vi.ToString + '].lon', vOutValue) then
      Result.UV.ahead[vi].lon := vOutValue;
    if vJSONValue.TryGetValue<String>('[' + vi.ToString + '].date_iso', vOutValue) then
      Result.UV.ahead[vi].date_iso := vOutValue;
    if vJSONValue.TryGetValue<String>('[' + vi.ToString + '].date', vOutValue) then
      Result.UV.ahead[vi].Date := vOutValue;
    if vJSONValue.TryGetValue<String>('[' + vi.ToString + '].value', vOutValue) then
      Result.UV.ahead[vi].Value := vOutValue;
  end;

  FreeAndNil(vJSONValue);
  FreeAndNil(vRESTRequest);

  // Get the Historical UV Index forecast data (dates back = ?)
  // vJSONValue := uInternet_Files.JSONValue('OpenWeatherMap', 'http://api.openweathermap.org/data/2.5/uvi/history?lat=' + vLat + '&lon=' + vLon + '&start=' +
  // vStart_Time + '&end=' + vEnd_Time + '&APPID=' + cAuthor_OWM_APPID, TRESTRequestMethod.rmGET);
  //
  // for vi := 0 to 10 do
  // begin
  // Result.UV.historical[vi].lat := vJSONValue.GetValue<String>('lat');
  // Result.UV.historical[vi].lon := vJSONValue.GetValue<String>('lon');
  // Result.UV.historical[vi].date_iso := vJSONValue.GetValue<String>('date_iso');
  // Result.UV.historical[vi].date := vJSONValue.GetValue<String>('date');
  // Result.UV.historical[vi].Value := vJSONValue.GetValue<String>('value');
  // end;
  //
  // FreeAndNil(vJSONValue);
  // FreeAndNil(vRESTRequest);
end;

function ConvertTime(vUnixTime, Quotes: String): TWEATHER_PROVIDER_OPENWEATHERMAP_TIME;
var
  vDateTime: String;
  vIPos: Integer;
  vMonth: String;
  vDay: String;
  vYear: String;
  vTime: String;
begin
  vDateTime := FormatDateTime('dd+mm-yyyy/hh:mm', UnixToDateTime((vUnixTime.ToInt64)));
  vIPos := Pos('+', vDateTime);
  vMonth := Trim(Copy(vDateTime, vIPos + 1, 2));
  vDay := Trim(Copy(vDateTime, 1, 2));
  vIPos := Pos('-', vDateTime);
  vYear := Trim(Copy(vDateTime, vIPos + 1, 4));
  vIPos := Pos('/', vDateTime);
  vTime := Trim(Copy(vDateTime, vIPos + 1, 5));
  Result.DateTime_Delphi := vMonth + '/' + vDay + '/' + vYear + ' ' + vTime;
  vMonth := uWeather_Convert_Month(vMonth);
  Result.Date := vDay + Quotes + vMonth + Quotes + vYear;
  Result.Time := vTime;
  Result.Full := vDay + ', ' + vMonth + ' ' + vYear + ' at ' + vTime;
end;

Procedure Set_Lengauge_Text(vLanguage_Index: Integer);
const
  cLanguages: array [0 .. 32] of string = ('Arabic', 'Bulgarian', 'Catalan', 'Czech', 'German', 'Ellinika', 'English', 'Persian (Farsi)', 'Finnish', 'French',
    'Galician', 'Croatian', 'Hungarian', 'Italian', 'Japanese', 'Korean', 'Latvian', 'Lithuaniana', 'Skopje', 'Dutch', 'Polish', 'Portuguese', 'Romanian',
    'Russian', 'Swedish', 'Slovak', 'Slovenian', 'Spanish', 'Turkish', 'Ukrainian', 'Vietnamese', 'Chinese Simplified', 'Chinese Traditional');
  cLanguages_Ext: array [0 .. 32] of string = ('ar', 'bg', 'ca', 'cz', 'de', 'gr', 'en', 'fa', 'fi', 'fr', 'gl', 'hr', 'hu', 'it', 'ja', 'kr', 'la', 'lt', 'mk',
    'nl', 'pl', 'pt', 'ro', 'ru', 'se', 'sk', 'sl', 'es', 'tr', 'ua', 'vi', 'zh_cn', 'zh_tw');
begin
  addons.weather.Action.OWM.Language := cLanguages_Ext[vLanguage_Index];
//  addons.weather.Ini.Ini.WriteString('openweathermap', 'language', addons.weather.Action.OWM.Language);
end;

function Get_Language_Num(vLanguage: String): Integer;
const
  cLanguages: array [0 .. 32] of string = ('Arabic', 'Bulgarian', 'Catalan', 'Czech', 'German', 'Ellinika', 'English', 'Persian (Farsi)', 'Finnish', 'French',
    'Galician', 'Croatian', 'Hungarian', 'Italian', 'Japanese', 'Korean', 'Latvian', 'Lithuaniana', 'Skopje', 'Dutch', 'Polish', 'Portuguese', 'Romanian',
    'Russian', 'Swedish', 'Slovak', 'Slovenian', 'Spanish', 'Turkish', 'Ukrainian', 'Vietnamese', 'Chinese Simplified', 'Chinese Traditional');
  cLanguages_Ext: array [0 .. 32] of string = ('ar', 'bg', 'ca', 'cz', 'de', 'gr', 'en', 'fa', 'fi', 'fr', 'gl', 'hr', 'hu', 'it', 'ja', 'kr', 'la', 'lt', 'mk',
    'nl', 'pl', 'pt', 'ro', 'ru', 'se', 'sk', 'sl', 'es', 'tr', 'ua', 'vi', 'zh_cn', 'zh_tw');
var
  vi: Integer;
begin
  for vi := 0 to 32 do
    if cLanguages_Ext[vi] = vLanguage then
    begin
      Result := vi;
      Break
    end;
end;

function Get_Language_From_Short_Desc(vShort_Desk: String): String;
const
  cLanguages: array [0 .. 32] of string = ('Arabic', 'Bulgarian', 'Catalan', 'Czech', 'German', 'Ellinika', 'English', 'Persian (Farsi)', 'Finnish', 'French',
    'Galician', 'Croatian', 'Hungarian', 'Italian', 'Japanese', 'Korean', 'Latvian', 'Lithuaniana', 'Skopje', 'Dutch', 'Polish', 'Portuguese', 'Romanian',
    'Russian', 'Swedish', 'Slovak', 'Slovenian', 'Spanish', 'Turkish', 'Ukrainian', 'Vietnamese', 'Chinese Simplified', 'Chinese Traditional');
  cLanguages_Ext: array [0 .. 32] of string = ('ar', 'bg', 'ca', 'cz', 'de', 'gr', 'en', 'fa', 'fi', 'fr', 'gl', 'hr', 'hu', 'it', 'ja', 'kr', 'la', 'lt', 'mk',
    'nl', 'pl', 'pt', 'ro', 'ru', 'se', 'sk', 'sl', 'es', 'tr', 'ua', 'vi', 'zh_cn', 'zh_tw');
var
  vi: Integer;
begin
  for vi := 0 to 32 do
    if cLanguages_Ext[vi] = vShort_Desk then
      Break;
  Result := cLanguages[vi];
end;

function Get_Icon_Time(vTime: String): String;
begin
  if (vTime = '0:00') or (vTime = '0:00') or (vTime = '12:00') or (vTime = '24:00') then
    Result := #$f089
  else if (vTime = '01:00') or (vTime = '1:00') or (vTime = '13:00') then
    Result := #$f08a
  else if (vTime = '02:00') or (vTime = '2:00') or (vTime = '14:00') then
    Result := #$f08b
  else if (vTime = '03:00') or (vTime = '3:00') or (vTime = '15:00') then
    Result := #$f08c
  else if (vTime = '04:00') or (vTime = '4:00') or (vTime = '16:00') then
    Result := #$f08d
  else if (vTime = '05:00') or (vTime = '5:00') or (vTime = '17:00') then
    Result := #$f08e
  else if (vTime = '06:00') or (vTime = '6:00') or (vTime = '18:00') then
    Result := #$f08f
  else if (vTime = '07:00') or (vTime = '7:00') or (vTime = '19:00') then
    Result := #$f090
  else if (vTime = '08:00') or (vTime = '8:00') or (vTime = '20:00') then
    Result := #$f091
  else if (vTime = '09:00') or (vTime = '9:00') or (vTime = '21:00') then
    Result := #$f092
  else if (vTime = '10:00') or (vTime = '22:00') then
    Result := #$f093
  else if (vTime = '11:00') or (vTime = '23:00') then
    Result := #$f094
end;

function Convert_Wind(vWind: Integer): Single;
begin
  if vWind > 103 then
    Result := 0.1;
  case vWind of
    0 .. 1:
      Result := 0;
    2 .. 5:
      Result := 6;
    6 .. 11:
      Result := 5.2;
    12 .. 19:
      Result := 3.4;
    20 .. 28:
      Result := 2;
    29 .. 38:
      Result := 1.8;
    39 .. 49:
      Result := 1.4;
    50 .. 61:
      Result := 1;
    62 .. 74:
      Result := 0.7;
    75 .. 88:
      Result := 0.4;
    89 .. 102:
      Result := 0.2;
  end;
end;

procedure Show_Map(vTab_Num: String);
begin
  uWeather_Actions.Show_Map('openweathermap', addons.weather.Action.OWM.Data_Town[vTab_Num.ToInteger].Current.coord.lat,
    addons.weather.Action.OWM.Data_Town[vTab_Num.ToInteger].Current.coord.lon);
end;

end.
