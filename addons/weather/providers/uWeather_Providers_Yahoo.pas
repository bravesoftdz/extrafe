unit uWeather_Providers_Yahoo;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UiTypes,
  FMX.Objects,
  FMX.Types,
  FMX.Ani,
  FMX.Layouts,
  FMX.Controls,
  ALFmxTabControl,
  uWeather_AllTypes;

procedure uWeather_Providers_Yahoo_Load;
procedure uWeather_Providers_Yahoo_Load_Config;

function uWeather_Provider_Yahoo_GerForcast(vNum: Integer; vWoeid, vCountry_Code: String)
  : TADDON_WEATHER_CHOOSENTOWN;

procedure uWeather_Provider_Yahoo_CreateTab(vTown: TADDON_WEATHER_CHOOSENTOWN; vTabNum: Integer);

//procedure uWeather_Providers_Yahoo_GetForecast(vTown: String);

implementation
uses
  uLoad_AllTypes,
  uSnippet_Text,
  uWeather_Convert,
  uWeather_MenuActions;


procedure uWeather_Providers_Yahoo_Load;
begin

end;

procedure uWeather_Providers_Yahoo_Load_Config;
begin

end;

function uWeather_Provider_Yahoo_GerForcast(vNum: Integer; vWoeid, vCountry_Code: String)
  : TADDON_WEATHER_CHOOSENTOWN;
begin

end;

procedure uWeather_Provider_Yahoo_CreateTab(vTown: TADDON_WEATHER_CHOOSENTOWN; vTabNum: Integer);
begin
  vWeather.Scene.Tab[vTabNum].Tab := TALTabItem.Create(vWeather.Scene.Control);
  vWeather.Scene.Tab[vTabNum].Tab.Name := 'A_W_WeatherTab_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Tab.Parent := vWeather.Scene.Control;
  vWeather.Scene.Tab[vTabNum].Tab.Visible := True;

  vWeather.Scene.Tab[vTabNum].General.Image := TImage.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].General.Image.Name := 'A_W_WeatherImage_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].General.Image.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].General.Image.SetBounds(50,60,150,150 );
  vWeather.Scene.Tab[vTabNum].General.Image.Bitmap.LoadFromFile(addons.Weather.Path.Iconsets +
    addons.Weather.Config.Iconset.Name + '\w_w_' + vTown.Code + '.png');
  vWeather.Scene.Tab[vTabNum].General.Image.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].General.Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].General.Town_and_Country := TText.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].General.Town_and_Country.Name := 'A_W_Weather_TownAndCountry_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].General.Town_and_Country.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].General.Town_and_Country.Font.Size := 42;
  vWeather.Scene.Tab[vTabNum].General.Town_and_Country.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].General.Town_and_Country.Text := vTown.City + ' - ' + vTown.Country;
  vWeather.Scene.Tab[vTabNum].General.Town_and_Country.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].General.Town_and_Country.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].General.Town_and_Country.Visible := True;
  vWeather.Scene.Tab[vTabNum].General.Town_and_Country.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].General.Town_and_Country);
  vWeather.Scene.Tab[vTabNum].General.Town_and_Country.Position.X :=
    (vWeather.Scene.Tab[vTabNum].Tab.Width / 2) -
    (vWeather.Scene.Tab[vTabNum].General.Town_and_Country.Width / 2);
  vWeather.Scene.Tab[vTabNum].General.Town_and_Country.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Tab.Height - 120;

  vWeather.Scene.Tab[vTabNum].General.Temprature := TText.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].General.Temprature.Name := 'A_W_WeatherTemprature_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].General.Temprature.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].General.Temprature.Font.Size := 56;
  vWeather.Scene.Tab[vTabNum].General.Temprature.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].General.Temprature.Position.X := 300;
  vWeather.Scene.Tab[vTabNum].General.Temprature.Position.Y := 60;
  vWeather.Scene.Tab[vTabNum].General.Temprature.Text := vTown.Temp_Condition;
  vWeather.Scene.Tab[vTabNum].General.Temprature.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].General.Temprature.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].General.Temprature.Visible := True;
  vWeather.Scene.Tab[vTabNum].General.Temprature.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].General.Temprature);

  vWeather.Scene.Tab[vTabNum].General.Temprature_Unit := TText.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].General.Temprature_Unit.Name := 'A_W_WeatherTempratureUnit_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].General.Temprature_Unit.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].General.Temprature_Unit.Font.Size := 18;
  vWeather.Scene.Tab[vTabNum].General.Temprature_Unit.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].General.Temprature_Unit.Position.X := 310 + vWeather.Scene.Tab[vTabNum]
    .General.Temprature.Width;
  vWeather.Scene.Tab[vTabNum].General.Temprature_Unit.Position.Y := 40;
  vWeather.Scene.Tab[vTabNum].General.Temprature_Unit.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].General.Temprature_Unit.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].General.Temprature_Unit.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].General.Temprature_Unit.Visible := True;

  vWeather.Scene.Tab[vTabNum].General.Condtition := TText.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].General.Condtition.Name := 'A_W_WeatherTextCondtition_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].General.Condtition.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].General.Condtition.Font.Size := 42;
  vWeather.Scene.Tab[vTabNum].General.Condtition.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].General.Condtition.Position.X := 300;
  vWeather.Scene.Tab[vTabNum].General.Condtition.Position.Y := 120;
  vWeather.Scene.Tab[vTabNum].General.Condtition.Text := vTown.Text_Condtition;
  vWeather.Scene.Tab[vTabNum].General.Condtition.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].General.Condtition.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].General.Condtition.Visible := True;
  vWeather.Scene.Tab[vTabNum].General.Condtition.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].General.Condtition);

  vWeather.Scene.Tab[vTabNum].Wind.Text := TText.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Wind.Text.Name := 'A_W_WeatherWind_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Wind.Text.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Wind.Text.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Wind.Text.Color := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab[vTabNum].Wind.Text.Position.X := 60;
  vWeather.Scene.Tab[vTabNum].Wind.Text.Position.Y := 280;
  vWeather.Scene.Tab[vTabNum].Wind.Text.Text := 'Wind';
  vWeather.Scene.Tab[vTabNum].Wind.Text.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Wind.Text.Font.Style := vWeather.Scene.Tab[vTabNum].Wind.Text.Font.Style +
    [TFontStyle.fsUnderline];
  vWeather.Scene.Tab[vTabNum].Wind.Text.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Wind.Text.Visible := True;
  vWeather.Scene.Tab[vTabNum].Wind.Text.Width := 80;

  vWeather.Scene.Tab[vTabNum].Wind.Speed := TText.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Wind.Speed.Name := 'A_W_WeatherWindSpeed' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Wind.Speed.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Wind.Speed.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Wind.Speed.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Wind.Speed.Position.X := 60;
  vWeather.Scene.Tab[vTabNum].Wind.Speed.Position.Y := 320;
  vWeather.Scene.Tab[vTabNum].Wind.Speed.Text := 'Speed : ' + vTown.Wind.Speed + ' ' + vTown.UnitV.Speed;
  vWeather.Scene.Tab[vTabNum].Wind.Speed.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Wind.Speed.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Wind.Speed.Visible := True;
  vWeather.Scene.Tab[vTabNum].Wind.Speed.Width := uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Wind.Speed);

  vWeather.Scene.Tab[vTabNum].Wind.Direction := TText.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Wind.Direction.Name := 'A_W_WeatherWindDiretion' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Wind.Direction.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Wind.Direction.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Wind.Direction.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Wind.Direction.Position.X := 60;
  vWeather.Scene.Tab[vTabNum].Wind.Direction.Position.Y := 350;
  vWeather.Scene.Tab[vTabNum].Wind.Direction.Text := 'Direction : ' + vTown.Wind.Direction;
  vWeather.Scene.Tab[vTabNum].Wind.Direction.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Wind.Direction.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Wind.Direction.Visible := True;
  vWeather.Scene.Tab[vTabNum].Wind.Direction.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Wind.Direction);

  vWeather.Scene.Tab[vTabNum].Wind.Direction_Degree :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Wind.Direction);
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Degree.Name := 'A_W_WeatherWindDiretionDegree' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Degree.Parent := vWeather.Scene.Tab[vTabNum].Wind.Direction;
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Degree.Font.Size := 10;
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Degree.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Degree.Position.X := vWeather.Scene.Tab[vTabNum]
    .Wind.Direction.Width + 3;
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Degree.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Wind.Direction.Height - 44;
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Degree.Text := 'o';
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Degree.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Degree.TextSettings.VertAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Degree.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Degree.Visible := True;

  vWeather.Scene.Tab[vTabNum].Wind.Direction_Arrow := TImage.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Arrow.Name := 'A_W_WeatherWindDirectionArrow' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Arrow.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Arrow.Width := 64;
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Arrow.Height := 64;
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Arrow.Position.X := 280;
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Arrow.Position.Y := 340;
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Arrow.WrapMode := TImageWrapMode.Fit;
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Arrow.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_wind_arrow.png');
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Arrow.RotationAngle := StrToFloat(vTown.Wind.Direction);
  vWeather.Scene.Tab[vTabNum].Wind.Direction_Arrow.Visible := True;

  vWeather.Scene.Tab[vTabNum].Wind.Chill := TText.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Wind.Chill.Name := 'A_W_WeatherWindChill' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Wind.Chill.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Wind.Chill.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Wind.Chill.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Wind.Chill.Position.X := 60;
  vWeather.Scene.Tab[vTabNum].Wind.Chill.Position.Y := 380;
  vWeather.Scene.Tab[vTabNum].Wind.Chill.Text := 'Chill : ' + vTown.Wind.Chill;
  vWeather.Scene.Tab[vTabNum].Wind.Chill.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Wind.Chill.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Wind.Chill.Visible := True;
  vWeather.Scene.Tab[vTabNum].Wind.Chill.Width := uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Wind.Chill);

  vWeather.Scene.Tab[vTabNum].Wind.Chill_Icon := TImage.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Wind.Chill_Icon.Name := 'A_W_WeatherWindChillIcon' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Wind.Chill_Icon.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Wind.Chill_Icon.Width := 24;
  vWeather.Scene.Tab[vTabNum].Wind.Chill_Icon.Height := 24;
  vWeather.Scene.Tab[vTabNum].Wind.Chill_Icon.Position.X := vWeather.Scene.Tab[vTabNum].Wind.Chill.Width + 70;
  vWeather.Scene.Tab[vTabNum].Wind.Chill_Icon.Position.Y := 392;
  vWeather.Scene.Tab[vTabNum].Wind.Chill_Icon.WrapMode := TImageWrapMode.Fit;
  vWeather.Scene.Tab[vTabNum].Wind.Chill_Icon.Bitmap.LoadFromFile(addons.Weather.Path.Images +
    'w_wind_chill.png');
  vWeather.Scene.Tab[vTabNum].Wind.Chill_Icon.Visible := True;

  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small_Stand := TImage.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small_Stand.Name := 'A_W_WeatherWindTurbineSmallStand_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small_Stand.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small_Stand.Width := 43;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small_Stand.Height := 52;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small_Stand.Position.X := 318;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small_Stand.Position.Y := 270;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small_Stand.WrapMode := TImageWrapMode.Fit;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small_Stand.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_stand.png');
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small_Stand.Visible := True;

  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small := TImage.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small.Name := 'A_W_WeatherWindSmallTurbine_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small.Width := 54;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small.Height := 54;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small.Position.X := 312;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small.Position.Y := 245;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small.WrapMode := TImageWrapMode.Stretch;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_turbine.png');
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small.Visible := True;

  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small_Animation :=
    TFloatAnimation.Create(vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small);
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small_Animation.Name := 'A_W_WeatherWindSmallTurbineAnimation_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small_Animation.Parent := vWeather.Scene.Tab[vTabNum]
    .Wind.Turbine_Small;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small_Animation.PropertyName := 'RotationAngle';
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small_Animation.Duration :=
    uWeather_Convert_WindSpeed(StrToFloat(vTown.Wind.Speed));
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small_Animation.StartValue := 0;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small_Animation.StopValue := 360;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small_Animation.Loop := True;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Small_Animation.Enabled := True;

  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Stand := TImage.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Stand.Name := 'A_W_WeatherWindTurbineStand_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Stand.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Stand.Width := 53;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Stand.Height := 64;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Stand.Position.X := 278;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Stand.Position.Y := 280;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Stand.WrapMode := TImageWrapMode.Fit;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Stand.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_stand.png');
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Stand.Visible := True;

  vWeather.Scene.Tab[vTabNum].Wind.Turbine := TImage.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Wind.Turbine.Name := 'A_W_WeatherWindTurbine_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Wind.Turbine.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine.Width := 64;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine.Height := 64;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine.Position.X := 272;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine.Position.Y := 243;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine.WrapMode := TImageWrapMode.Stretch;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine.Bitmap.LoadFromFile(addons.Weather.Path.Images + 'w_turbine.png');
  vWeather.Scene.Tab[vTabNum].Wind.Turbine.Visible := True;

  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Animation :=
    TFloatAnimation.Create(vWeather.Scene.Tab[vTabNum].Wind.Turbine);
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Animation.Name := 'A_W_WeatherWindTurbineAnimation_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Animation.Parent := vWeather.Scene.Tab[vTabNum].Wind.Turbine;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Animation.PropertyName := 'RotationAngle';
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Animation.Duration :=
    uWeather_Convert_WindSpeed(StrToFloat(vTown.Wind.Speed));
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Animation.StartValue := 0;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Animation.StopValue := 360;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Animation.Loop := True;
  vWeather.Scene.Tab[vTabNum].Wind.Turbine_Animation.Enabled := True;

  vWeather.Scene.Tab[vTabNum].Atmosphere.Text := TText.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Atmosphere.Text.Name := 'A_W_WeatherAtmosphere_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Atmosphere.Text.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Text.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Text.Color := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Text.Position.X := 60;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Text.Position.Y := 430;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Text.Text := 'Atmosphere';
  vWeather.Scene.Tab[vTabNum].Atmosphere.Text.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Text.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Text.Font.Style := vWeather.Scene.Tab[vTabNum]
    .Atmosphere.Text.Font.Style + [TFontStyle.fsUnderline];
  vWeather.Scene.Tab[vTabNum].Atmosphere.Text.Visible := True;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Text.Width := 120;

  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure := TText.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure.Name := 'A_W_WeatherAtmospherePressure' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure.Position.X := 60;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure.Position.Y := 470;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure.Text := 'Pressure : ' + vTown.Atmosphere.Pressure + ' ' +
    vTown.UnitV.Pressure;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure.Visible := True;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure);

  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure_Icon := TImage.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure_Icon.Name := 'A_W_WeatherAtmospherePresureIcon' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure_Icon.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure_Icon.Width := 24;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure_Icon.Height := 24;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure_Icon.Position.X := vWeather.Scene.Tab[vTabNum]
    .Atmosphere.Pressure.Width + 70;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure_Icon.Position.Y := 482;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure_Icon.WrapMode := TImageWrapMode.Fit;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure_Icon.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_presure.png');
  vWeather.Scene.Tab[vTabNum].Atmosphere.Pressure_Icon.Visible := True;

  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility := TText.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility.Name := 'A_W_WeatherAtmosphereVisibility' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility.Position.X := 60;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility.Position.Y := 500;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility.Text := 'Visibility : ' + vTown.Atmosphere.Visibility +
    ' ' + vTown.UnitV.Distance;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility.Visible := True;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility);

  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility_Icon := TImage.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility_Icon.Name := 'A_W_WeatherAtmosphereVisibilityIcon' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility_Icon.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility_Icon.Width := 24;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility_Icon.Height := 24;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility_Icon.Position.X := vWeather.Scene.Tab[vTabNum]
    .Atmosphere.Visibility.Width + 70;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility_Icon.Position.Y := 512;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility_Icon.WrapMode := TImageWrapMode.Fit;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility_Icon.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_visibility.png');
  vWeather.Scene.Tab[vTabNum].Atmosphere.Visibility_Icon.Visible := True;

  vWeather.Scene.Tab[vTabNum].Atmosphere.Rising := TText.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Atmosphere.Rising.Name := 'A_W_WeatherAtmosphereRising' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Atmosphere.Rising.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Rising.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Rising.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Rising.Position.X := 60;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Rising.Position.Y := 530;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Rising.Text := 'Rising : ' + vTown.Atmosphere.Rising;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Rising.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Rising.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Rising.Visible := True;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Rising.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Atmosphere.Rising);

  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity := TText.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity.Name := 'A_W_WeatherAtmosphereHumidity' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity.Position.X := 60;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity.Position.Y := 560;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity.Text := 'Humidity : ' + vTown.Atmosphere.Humidity + '%';
  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity.Visible := True;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity);

  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity_Icon := TImage.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity_Icon.Name := 'A_W_WeatherAtmosphereHumidityIcon_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity_Icon.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity_Icon.Width := 24;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity_Icon.Height := 24;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity_Icon.Position.X := 220;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity_Icon.Position.Y := 572;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity_Icon.WrapMode := TImageWrapMode.Fit;
  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity_Icon.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_humidity.png');
  vWeather.Scene.Tab[vTabNum].Atmosphere.Humidity_Icon.Visible := True;

  vWeather.Scene.Tab[vTabNum].Astronomy.Text := TText.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Astronomy.Text.Name := 'A_W_WeatherAstronomy_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Astronomy.Text.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Astronomy.Text.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Astronomy.Text.Color := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab[vTabNum].Astronomy.Text.Position.X := 60;
  vWeather.Scene.Tab[vTabNum].Astronomy.Text.Position.Y := 610;
  vWeather.Scene.Tab[vTabNum].Astronomy.Text.Text := 'Astronomy';
  vWeather.Scene.Tab[vTabNum].Astronomy.Text.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Astronomy.Text.Font.Style := vWeather.Scene.Tab[vTabNum]
    .Astronomy.Text.Font.Style + [TFontStyle.fsUnderline];
  vWeather.Scene.Tab[vTabNum].Astronomy.Text.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Astronomy.Text.Visible := True;
  vWeather.Scene.Tab[vTabNum].Astronomy.Text.Width := 120;

  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise := TText.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise.Name := 'A_W_WeatherAstronomySunrise_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise.Position.X := 60;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise.Position.Y := 650;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise.Text := 'Sunrise : ' + vTown.Astronomy.Sunrise;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise.Visible := True;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise);

  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise_Image := TImage.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise_Image.Name := 'A_W_WeatherAstronomySunriseImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise_Image.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise_Image.Width := 64;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise_Image.Height := 64;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise_Image.Position.X := vWeather.Scene.Tab[vTabNum]
    .Astronomy.Sunrise.Width + 100;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise_Image.Position.Y := 670;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise_Image.WrapMode := TImageWrapMode.Fit;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_sunrise.png');
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunrise_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset := TText.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset.Name := 'A_W_WeatherAstronomySunset_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset.Position.X := 60;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset.Position.Y := 680;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset.Text := 'Sunset : ' + vTown.Astronomy.Sunset;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset.Visible := True;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Astronomy.Sunset);

  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset_Image := TImage.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset_Image.Name := 'A_W_WeatherAstronomySunsetImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset_Image.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset_Image.Width := 64;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset_Image.Height := 64;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset_Image.Position.X := vWeather.Scene.Tab[vTabNum]
    .Astronomy.Sunrise.Width + 400;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset_Image.Position.Y := 670;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset_Image.WrapMode := TImageWrapMode.Fit;
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_sunset.png');
  vWeather.Scene.Tab[vTabNum].Astronomy.Sunset_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Astronomy.Spot := TImage.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot.Name := 'A_W_WeatherAstronomySpot_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot.Width := 24;
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot.Height := 24;
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot.Position.X := vWeather.Scene.Tab[vTabNum]
    .Astronomy.Sunrise.Width + 120;
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot.Position.Y := 670;
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot.WrapMode := TImageWrapMode.Fit;
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot.Bitmap.LoadFromFile(addons.Weather.Path.Images + 'w_sun.png');
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot.Visible := True;

  vWeather.Scene.Tab[vTabNum].Astronomy.Spot_Text := TText.Create(vWeather.Scene.Tab[vTabNum].Astronomy.Spot);
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot_Text.Name := 'A_W_Weather_Astronomy_Spot_Text_' +
    vTabNum.ToString;
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot_Text.Parent := vWeather.Scene.Tab[vTabNum].Astronomy.Spot;
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot_Text.Width := 100;
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot_Text.Height := 18;
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot_Text.Position.X := -38;
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot_Text.Position.Y := -16;
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot_Text.TextSettings.Font.Size := 10;
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot_Text.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot_Text.TextSettings.VertAlign := TTextAlign.Center;
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot_Text.Visible := True;

  vWeather.Scene.Tab[vTabNum].Astronomy.Spot_Ani :=
    TPathAnimation.Create(vWeather.Scene.Tab[vTabNum].Astronomy.Spot);
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot_Ani.Name := 'A_W_Weather_Astronomy_Spot_Animation';
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot_Ani.Parent := vWeather.Scene.Tab[vTabNum].Astronomy.Spot;
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot_Ani.Duration := 4;
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot_Ani.Delay := 0.5;
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot_Ani.OnFinish := vWeather_Animation.OnAniStop;
  vWeather.Scene.Tab[vTabNum].Astronomy.Spot_Ani.Enabled := False;

  vWeather.Scene.Tab[vTabNum].Server.LastUpDate := TText.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Server.LastUpDate.Name := 'A_W_WeatherLastUpDate_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Server.LastUpDate.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Server.LastUpDate.Font.Size := 16;
  vWeather.Scene.Tab[vTabNum].Server.LastUpDate.Color := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab[vTabNum].Server.LastUpDate.Position.X := 60;
  vWeather.Scene.Tab[vTabNum].Server.LastUpDate.Position.Y := 720;
  vWeather.Scene.Tab[vTabNum].Server.LastUpDate.Text := 'Last Update: ' +
    uWeather_Convert_Update(vTown.LastUpDate);
  vWeather.Scene.Tab[vTabNum].Server.LastUpDate.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Server.LastUpDate.Visible := True;
  vWeather.Scene.Tab[vTabNum].Server.LastUpDate.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Server.LastUpDate);

  vWeather.Scene.Tab[vTabNum].Server.Powered_By := TText.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Server.Powered_By.Name := 'A_W_WeatherPoweredBy_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Server.Powered_By.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Server.Powered_By.Font.Size := 16;
  vWeather.Scene.Tab[vTabNum].Server.Powered_By.Color := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Tab[vTabNum].Server.Powered_By.Position.Y := 710;
  vWeather.Scene.Tab[vTabNum].Server.Powered_By.Text := 'Powered by : ';
  vWeather.Scene.Tab[vTabNum].Server.Powered_By.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Server.Powered_By.Visible := True;
  vWeather.Scene.Tab[vTabNum].Server.Powered_By.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Server.Powered_By);
  vWeather.Scene.Tab[vTabNum].Server.Powered_By.Position.X := vWeather.Scene.Tab[vTabNum].Tab.Width -
    (vWeather.Scene.Tab[vTabNum].Server.Powered_By.Width + 70);

  vWeather.Scene.Tab[vTabNum].Server.Icon := TImage.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Server.Icon.Name := 'A_W_WeatherPoweredByYahoo_Icon_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Server.Icon.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Server.Icon.Width := 64;
  vWeather.Scene.Tab[vTabNum].Server.Icon.Height := 64;
  vWeather.Scene.Tab[vTabNum].Server.Icon.Position.X := vWeather.Scene.Tab[vTabNum].Tab.Width - 70;
  vWeather.Scene.Tab[vTabNum].Server.Icon.Position.Y := 700;
  vWeather.Scene.Tab[vTabNum].Server.Icon.WrapMode := TImageWrapMode.Fit;
  vWeather.Scene.Tab[vTabNum].Server.Icon.Bitmap.LoadFromFile(addons.Weather.Path.Images + 'w_yahoo.png');
  vWeather.Scene.Tab[vTabNum].Server.Icon.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Box := TVertScrollBox.Create(vWeather.Scene.Tab[vTabNum].Tab);
  vWeather.Scene.Tab[vTabNum].Forcast.Box.Name := 'A_W_WeatherForcastBox_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Box.Parent := vWeather.Scene.Tab[vTabNum].Tab;
  vWeather.Scene.Tab[vTabNum].Forcast.Box.Position.Y := 70;
  vWeather.Scene.Tab[vTabNum].Forcast.Box.Position.X := 800;
  vWeather.Scene.Tab[vTabNum].Forcast.Box.Width := 1000;
  vWeather.Scene.Tab[vTabNum].Forcast.Box.Height := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Box.ShowScrollBars := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Box.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Box.Visible := True;

  // 10 days Forcast
  // Current Day
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Layout :=
    TLayout.Create(vWeather.Scene.Tab[vTabNum].Forcast.Box);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Layout.Name := 'A_W_WeatherForcastCurrentDayPanel_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Layout.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Box;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Layout.Position.X := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Layout.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Layout.Width := vWeather.Scene.Tab[vTabNum]
    .Forcast.Box.Width - 50;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Layout.Height := 150;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Layout.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Layout.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Current.Text :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Current.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Text.Name := 'A_W_WeatherForcastCurrentDayDay_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Text.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Current.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Text.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Text.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Text.Position.X := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Text.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Text.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Text.Text := uWeather_Convert_Day(vTown.Current.Text) + ', ';
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Text.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Text.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Text.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Current.Text);

  vWeather.Scene.Tab[vTabNum].Forcast.Current.Date :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Current.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Date.Name := 'A_W_WeatherForcastCurrentDayDate_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Date.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Current.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Date.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Date.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Date.Position.X := 10 + vWeather.Scene.Tab[vTabNum]
    .Forcast.Current.Text.Width;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Date.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Date.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Date.Text := uWeather_Convert_Date(vTown.Current.Date);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Date.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Date.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Date.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Current.Date);

  vWeather.Scene.Tab[vTabNum].Forcast.Current.Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Current.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Image.Name := 'A_WeatherForcastCurrentDayImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Current.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Image.Width := 130;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Image.Height := 130;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Image.Position.X :=
    (vWeather.Scene.Tab[vTabNum].Forcast.Current.Layout.Width / 2) -
    (vWeather.Scene.Tab[vTabNum].Forcast.Current.Image.Width / 2);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Image.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Image.Bitmap.LoadFromFile(addons.Weather.Path.Iconsets +
    addons.Weather.Config.Iconset.Name + '\w_w_' + vTown.Current.Code + '.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Current.Condition :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Current.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Condition.Name := 'A_W_WeatherForcastCurrentDayText_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Condition.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Current.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Condition.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Condition.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Condition.Position.X := 150;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Condition.Position.Y := 70;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Condition.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Condition.Text := vTown.Current.Forcast;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Condition.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Condition.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Condition.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Current.Condition);

  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low_Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Current.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low_Image.Name := 'A_WeatherForcastCurrentDayLowImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low_Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Current.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low_Image.Width := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low_Image.Height := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low_Image.Position.X := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low_Image.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Current.Layout.Height - 58;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_temp_low.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Current.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low.Name := 'A_W_WeatherForcastCurrentDayLow_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Current.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low.Position.X := 644;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Current.Layout.Height - 49;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low.Text := vTown.Current.Low;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Current.Low);

  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low_TU :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Current.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low_TU.Name := 'A_W_WeatherForcastCurrentDayLowTU_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low_TU.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Current.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low_TU.Font.Size := 8;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low_TU.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low_TU.Position.X := vWeather.Scene.Tab[vTabNum]
    .Forcast.Current.Low.Position.X + vWeather.Scene.Tab[vTabNum].Forcast.Current.Low.Width + 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low_TU.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Current.Layout.Height - 66;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low_TU.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low_TU.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low_TU.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.Low_TU.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Current.High_Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Current.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High_Image.Name := 'A_WeatherForcastCurrentDayHighImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High_Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Current.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High_Image.Width := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High_Image.Height := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High_Image.Position.X := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High_Image.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_temp_high.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Current.High :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Current.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High.Name := 'A_W_WeatherForcastCurrentDayHigh_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Current.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High.Position.X := 644;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High.Position.Y := 19;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High.Text := vTown.Current.High;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Current.High);

  vWeather.Scene.Tab[vTabNum].Forcast.Current.High_TU :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Current.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High_TU.Name := 'A_W_WeatherForcastCurrentDayHighTU_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High_TU.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Current.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High_TU.Font.Size := 8;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High_TU.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High_TU.Position.X := vWeather.Scene.Tab[vTabNum]
    .Forcast.Current.High.Position.X + vWeather.Scene.Tab[vTabNum].Forcast.Current.High.Width + 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High_TU.Position.Y := 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High_TU.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High_TU.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High_TU.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Current.High_TU.Visible := True;

  // Day 1 after
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout := TLayout.Create(vWeather.Scene.Tab[vTabNum].Forcast.Box);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout.Name := 'A_W_WeatherForcastDay1Panel_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Box;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout.Position.X := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout.Position.Y := 170;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout.Width := vWeather.Scene.Tab[vTabNum]
    .Forcast.Box.Width - 50;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout.Height := 150;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Text :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Text.Name := 'A_W_WeatherForcastDay1Day_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Text.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Text.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Text.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Text.Position.X := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Text.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Text.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Text.Text := uWeather_Convert_Day(vTown.Day_1.Text) + ', ';
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Text.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Text.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Text.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Text);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Date :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Date.Name := 'A_W_WeatherForcastDay1Date_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Date.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Date.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Date.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Date.Position.X := 10 + vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_1.Text.Width;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Date.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Date.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Date.Text := uWeather_Convert_Date(vTown.Day_1.Date);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Date.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Date.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Date.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Date);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Image.Name := 'A_WeatherForcastDay1Image_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Image.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Image.Width := 130;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Image.Height := 130;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Image.Position.X :=
    (vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout.Width / 2) -
    (vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Image.Width / 2);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Image.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Image.Bitmap.LoadFromFile(addons.Weather.Path.Iconsets +
    addons.Weather.Config.Iconset.Name + '\w_w_' + vTown.Day_1.Code + '.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Condition :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Condition.Name := 'A_W_WeatherForcastDay1Text_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Condition.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_1.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Condition.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Condition.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Condition.Position.X := 150;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Condition.Position.Y := 70;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Condition.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Condition.Text := vTown.Day_1.Forcast;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Condition.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Condition.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Condition.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Condition);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low_Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low_Image.Name := 'A_WeatherForcastDay1LowImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low_Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_1.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low_Image.Width := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low_Image.Height := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low_Image.Position.X := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low_Image.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_1.Layout.Height - 58;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_temp_low.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low.Name := 'A_W_WeatherForcastDay1Low_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low.Position.X := 644;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_1.Layout.Height - 49;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low.Text := vTown.Day_1.Low;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low_TU :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low_TU.Name := 'A_W_WeatherForcastDay1LowTU_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low_TU.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low_TU.Font.Size := 8;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low_TU.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low_TU.Position.X := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_1.Low.Position.X + vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low.Width + 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low_TU.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_1.Layout.Height - 66;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low_TU.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low_TU.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low_TU.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Low_TU.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High_Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High_Image.Name := 'A_WeatherForcastDay1HighImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High_Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_1.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High_Image.Width := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High_Image.Height := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High_Image.Position.X := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High_Image.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_temp_high.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High.Name := 'A_W_WeatherForcastDay1High_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High.Position.X := 644;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High.Position.Y := 19;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High.Text := vTown.Day_1.High;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High_TU :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_1.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High_TU.Name := 'A_W_WeatherForcastDay1HighTU_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High_TU.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_1.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High_TU.Font.Size := 8;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High_TU.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High_TU.Position.X := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_1.High.Position.X + vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High.Width + 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High_TU.Position.Y := 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High_TU.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High_TU.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High_TU.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_1.High_TU.Visible := True;

  // Day 2 after
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout := TLayout.Create(vWeather.Scene.Tab[vTabNum].Forcast.Box);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout.Name := 'A_W_WeatherForcastDay2Panel_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Box;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout.Position.X := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout.Position.Y := 330;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout.Width := vWeather.Scene.Tab[vTabNum]
    .Forcast.Box.Width - 50;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout.Height := 150;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Text :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Text.Name := 'A_W_WeatherForcastDay2Day_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Text.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Text.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Text.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Text.Position.X := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Text.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Text.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Text.Text := uWeather_Convert_Day(vTown.Day_2.Text) + ', ';
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Text.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Text.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Text.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Text);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Date :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Date.Name := 'A_W_WeatherForcastDay2Date_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Date.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Date.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Date.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Date.Position.X := 10 + vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_2.Text.Width;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Date.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Date.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Date.Text := uWeather_Convert_Date(vTown.Day_2.Date);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Date.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Date.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Date.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Date);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Image.Name := 'A_WeatherForcastDay2Image_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Image.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Image.Width := 130;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Image.Height := 130;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Image.Position.X :=
    (vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout.Width / 2) -
    (vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Image.Width / 2);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Image.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Image.Bitmap.LoadFromFile(addons.Weather.Path.Iconsets +
    addons.Weather.Config.Iconset.Name + '\w_w_' + vTown.Day_2.Code + '.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Condition :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Condition.Name := 'A_W_WeatherForcastDay2Text_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Condition.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_2.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Condition.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Condition.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Condition.Position.X := 150;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Condition.Position.Y := 70;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Condition.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Condition.Text := vTown.Day_2.Forcast;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Condition.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Condition.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Condition.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Condition);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low_Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low_Image.Name := 'A_WeatherForcastDay2LowImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low_Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_2.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low_Image.Width := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low_Image.Height := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low_Image.Position.X := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low_Image.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_2.Layout.Height - 58;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_temp_low.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low.Name := 'A_W_WeatherForcastDay2Low_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low.Position.X := 644;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_2.Layout.Height - 49;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low.Text := vTown.Day_2.Low;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low_TU :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low_TU.Name := 'A_W_WeatherForcastDay2LowTU_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low_TU.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low_TU.Font.Size := 8;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low_TU.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low_TU.Position.X := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_2.Low.Position.X + vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low.Width + 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low_TU.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_2.Layout.Height - 66;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low_TU.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low_TU.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low_TU.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Low_TU.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High_Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High_Image.Name := 'A_WeatherForcastDay2HighImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High_Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_2.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High_Image.Width := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High_Image.Height := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High_Image.Position.X := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High_Image.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_temp_high.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High.Name := 'A_W_WeatherForcastDay2High_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High.Position.X := 644;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High.Position.Y := 19;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High.Text := vTown.Day_2.High;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High_TU :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_2.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High_TU.Name := 'A_W_WeatherForcastDay2HighTU_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High_TU.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_2.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High_TU.Font.Size := 8;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High_TU.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High_TU.Position.X := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_2.High.Position.X + vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High.Width + 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High_TU.Position.Y := 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High_TU.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High_TU.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High_TU.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_2.High_TU.Visible := True;

  // Day 3 after
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout := TLayout.Create(vWeather.Scene.Tab[vTabNum].Forcast.Box);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout.Name := 'A_W_WeatherForcastDay3Panel_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Box;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout.Position.X := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout.Position.Y := 490;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout.Width := vWeather.Scene.Tab[vTabNum]
    .Forcast.Box.Width - 50;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout.Height := 150;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Text :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Text.Name := 'A_W_WeatherForcastDay3Day_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Text.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Text.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Text.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Text.Position.X := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Text.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Text.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Text.Text := uWeather_Convert_Day(vTown.Day_3.Text) + ', ';
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Text.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Text.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Text.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Text);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Date :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Date.Name := 'A_W_WeatherForcastDay3Date_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Date.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Date.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Date.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Date.Position.X := 10 + vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_3.Text.Width;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Date.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Date.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Date.Text := uWeather_Convert_Date(vTown.Day_3.Date);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Date.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Date.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Date.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Date);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Image.Name := 'A_WeatherForcastDay3Image_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Image.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Image.Width := 130;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Image.Height := 130;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Image.Position.X :=
    (vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout.Width / 2) -
    (vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Image.Width / 2);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Image.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Image.Bitmap.LoadFromFile(addons.Weather.Path.Iconsets +
    addons.Weather.Config.Iconset.Name + '\w_w_' + vTown.Day_3.Code + '.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Condition :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Condition.Name := 'A_W_WeatherForcastDay3Text_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Condition.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_3.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Condition.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Condition.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Condition.Position.X := 150;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Condition.Position.Y := 70;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Condition.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Condition.Text := vTown.Day_3.Forcast;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Condition.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Condition.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Condition.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Condition);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low_Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low_Image.Name := 'A_WeatherForcastDay3LowImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low_Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_3.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low_Image.Width := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low_Image.Height := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low_Image.Position.X := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low_Image.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_3.Layout.Height - 58;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_temp_low.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low.Name := 'A_W_WeatherForcastDay3Low_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low.Position.X := 644;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_3.Layout.Height - 49;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low.Text := vTown.Day_3.Low;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low_TU :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low_TU.Name := 'A_W_WeatherForcastDay3LowTU_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low_TU.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low_TU.Font.Size := 8;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low_TU.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low_TU.Position.X := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_3.Low.Position.X + vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low.Width + 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low_TU.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_3.Layout.Height - 66;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low_TU.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low_TU.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low_TU.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Low_TU.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High_Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High_Image.Name := 'A_WeatherForcastDay3HighImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High_Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_3.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High_Image.Width := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High_Image.Height := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High_Image.Position.X := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High_Image.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_temp_high.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High.Name := 'A_W_WeatherForcastDay3High_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High.Position.X := 644;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High.Position.Y := 19;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High.Text := vTown.Day_3.High;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High_TU :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_3.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High_TU.Name := 'A_W_WeatherForcastDay3HighTU_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High_TU.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_3.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High_TU.Font.Size := 8;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High_TU.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High_TU.Position.X := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_3.High.Position.X + vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High.Width + 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High_TU.Position.Y := 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High_TU.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High_TU.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High_TU.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_3.High_TU.Visible := True;

  // Day 4 after
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout := TLayout.Create(vWeather.Scene.Tab[vTabNum].Forcast.Box);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout.Name := 'A_W_WeatherForcastDay4Panel_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Box;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout.Position.X := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout.Position.Y := 650;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout.Width := vWeather.Scene.Tab[vTabNum]
    .Forcast.Box.Width - 50;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout.Height := 150;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Text :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Text.Name := 'A_W_WeatherForcastDay4Day_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Text.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Text.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Text.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Text.Position.X := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Text.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Text.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Text.Text := uWeather_Convert_Day(vTown.Day_4.Text) + ', ';
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Text.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Text.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Text.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Text);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Date :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Date.Name := 'A_W_WeatherForcastDay4Date_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Date.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Date.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Date.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Date.Position.X := 10 + vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_4.Text.Width;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Date.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Date.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Date.Text := uWeather_Convert_Date(vTown.Day_4.Date);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Date.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Date.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Date.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Date);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Image.Name := 'A_WeatherForcastDay4Image_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Image.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Image.Width := 130;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Image.Height := 130;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Image.Position.X :=
    (vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout.Width / 2) -
    (vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Image.Width / 2);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Image.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Image.Bitmap.LoadFromFile(addons.Weather.Path.Iconsets +
    addons.Weather.Config.Iconset.Name + '\w_w_' + vTown.Day_4.Code + '.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Condition :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Condition.Name := 'A_W_WeatherForcastDay4Text_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Condition.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_4.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Condition.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Condition.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Condition.Position.X := 150;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Condition.Position.Y := 70;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Condition.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Condition.Text := vTown.Day_4.Forcast;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Condition.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Condition.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Condition.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Condition);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low_Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low_Image.Name := 'A_WeatherForcastDay4LowImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low_Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_4.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low_Image.Width := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low_Image.Height := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low_Image.Position.X := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low_Image.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_4.Layout.Height - 58;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_temp_low.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low.Name := 'A_W_WeatherForcastDay4Low_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low.Position.X := 644;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_4.Layout.Height - 49;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low.Text := vTown.Day_4.Low;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low_TU :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low_TU.Name := 'A_W_WeatherForcastDay4LowTU_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low_TU.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low_TU.Font.Size := 8;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low_TU.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low_TU.Position.X := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_4.Low.Position.X + vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low.Width + 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low_TU.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_4.Layout.Height - 66;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low_TU.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low_TU.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low_TU.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Low_TU.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High_Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High_Image.Name := 'A_WeatherForcastDay4HighImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High_Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_4.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High_Image.Width := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High_Image.Height := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High_Image.Position.X := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High_Image.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_temp_high.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High.Name := 'A_W_WeatherForcastDay4High_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High.Position.X := 644;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High.Position.Y := 19;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High.Text := vTown.Day_4.High;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High_TU :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_4.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High_TU.Name := 'A_W_WeatherForcastDay4HighTU_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High_TU.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_4.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High_TU.Font.Size := 8;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High_TU.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High_TU.Position.X := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_4.High.Position.X + vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High.Width + 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High_TU.Position.Y := 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High_TU.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High_TU.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High_TU.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_4.High_TU.Visible := True;

  // Day 5 after
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout := TLayout.Create(vWeather.Scene.Tab[vTabNum].Forcast.Box);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout.Name := 'A_W_WeatherForcastDay5Panel_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Box;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout.Position.X := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout.Position.Y := 810;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout.Width := vWeather.Scene.Tab[vTabNum]
    .Forcast.Box.Width - 50;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout.Height := 150;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Text :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Text.Name := 'A_W_WeatherForcastDay5Day_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Text.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Text.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Text.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Text.Position.X := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Text.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Text.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Text.Text := uWeather_Convert_Day(vTown.Day_5.Text) + ', ';
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Text.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Text.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Text.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Text);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Date :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Date.Name := 'A_W_WeatherForcastDay5Date_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Date.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Date.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Date.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Date.Position.X := 10 + vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_5.Text.Width;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Date.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Date.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Date.Text := uWeather_Convert_Date(vTown.Day_4.Date);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Date.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Date.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Date.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Date);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Image.Name := 'A_WeatherForcastDay5Image_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Image.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Image.Width := 130;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Image.Height := 130;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Image.Position.X :=
    (vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout.Width / 2) -
    (vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Image.Width / 2);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Image.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Image.Bitmap.LoadFromFile(addons.Weather.Path.Iconsets +
    addons.Weather.Config.Iconset.Name + '\w_w_' + vTown.Day_5.Code + '.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Condition :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Condition.Name := 'A_W_WeatherForcastDay5Text_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Condition.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_5.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Condition.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Condition.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Condition.Position.X := 150;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Condition.Position.Y := 70;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Condition.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Condition.Text := vTown.Day_4.Forcast;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Condition.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Condition.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Condition.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Condition);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low_Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low_Image.Name := 'A_WeatherForcastDay5LowImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low_Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_5.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low_Image.Width := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low_Image.Height := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low_Image.Position.X := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low_Image.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_5.Layout.Height - 58;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_temp_low.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low.Name := 'A_W_WeatherForcastDay5Low_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low.Position.X := 644;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_5.Layout.Height - 49;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low.Text := vTown.Day_5.Low;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low_TU :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low_TU.Name := 'A_W_WeatherForcastDay5LowTU_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low_TU.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low_TU.Font.Size := 8;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low_TU.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low_TU.Position.X := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_5.Low.Position.X + vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low.Width + 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low_TU.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_5.Layout.Height - 66;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low_TU.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low_TU.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low_TU.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Low_TU.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High_Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High_Image.Name := 'A_WeatherForcastDay5HighImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High_Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_5.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High_Image.Width := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High_Image.Height := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High_Image.Position.X := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High_Image.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_temp_high.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High.Name := 'A_W_WeatherForcastDay5High_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High.Position.X := 644;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High.Position.Y := 19;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High.Text := vTown.Day_5.High;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High_TU :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_5.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High_TU.Name := 'A_W_WeatherForcastDay5HighTU_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High_TU.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_5.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High_TU.Font.Size := 8;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High_TU.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High_TU.Position.X := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_5.High.Position.X + vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High.Width + 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High_TU.Position.Y := 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High_TU.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High_TU.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High_TU.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_5.High_TU.Visible := True;

  // Day 6 after
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout := TLayout.Create(vWeather.Scene.Tab[vTabNum].Forcast.Box);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout.Name := 'A_W_WeatherForcastDay6Panel_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Box;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout.Position.X := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout.Position.Y := 970;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout.Width := vWeather.Scene.Tab[vTabNum]
    .Forcast.Box.Width - 50;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout.Height := 150;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Text :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Text.Name := 'A_W_WeatherForcastDay6Day_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Text.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Text.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Text.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Text.Position.X := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Text.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Text.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Text.Text := uWeather_Convert_Day(vTown.Day_6.Text) + ', ';
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Text.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Text.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Text.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Text);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Date :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Date.Name := 'A_W_WeatherForcastDay6Date_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Date.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Date.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Date.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Date.Position.X := 10 + vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_6.Text.Width;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Date.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Date.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Date.Text := uWeather_Convert_Date(vTown.Day_6.Date);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Date.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Date.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Date.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Date);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Image.Name := 'A_WeatherForcastDay6Image_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Image.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Image.Width := 130;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Image.Height := 130;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Image.Position.X :=
    (vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout.Width / 2) -
    (vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Image.Width / 2);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Image.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Image.Bitmap.LoadFromFile(addons.Weather.Path.Iconsets +
    addons.Weather.Config.Iconset.Name + '\w_w_' + vTown.Day_6.Code + '.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Condition :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Condition.Name := 'A_W_WeatherForcastDay6Text_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Condition.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_6.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Condition.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Condition.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Condition.Position.X := 150;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Condition.Position.Y := 70;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Condition.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Condition.Text := vTown.Day_6.Forcast;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Condition.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Condition.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Condition.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Condition);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low_Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low_Image.Name := 'A_WeatherForcastDay6LowImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low_Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_6.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low_Image.Width := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low_Image.Height := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low_Image.Position.X := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low_Image.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_6.Layout.Height - 58;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_temp_low.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low.Name := 'A_W_WeatherForcastDay6Low_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low.Position.X := 644;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_6.Layout.Height - 49;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low.Text := vTown.Day_6.Low;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low_TU :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low_TU.Name := 'A_W_WeatherForcastDay6LowTU_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low_TU.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low_TU.Font.Size := 8;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low_TU.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low_TU.Position.X := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_6.Low.Position.X + vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low.Width + 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low_TU.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_6.Layout.Height - 66;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low_TU.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low_TU.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low_TU.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Low_TU.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High_Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High_Image.Name := 'A_WeatherForcastDay6HighImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High_Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_6.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High_Image.Width := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High_Image.Height := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High_Image.Position.X := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High_Image.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_temp_high.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High.Name := 'A_W_WeatherForcastDay6High_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High.Position.X := 644;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High.Position.Y := 19;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High.Text := vTown.Day_6.High;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High_TU :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_6.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High_TU.Name := 'A_W_WeatherForcastDay6HighTU_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High_TU.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_6.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High_TU.Font.Size := 8;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High_TU.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High_TU.Position.X := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_6.High.Position.X + vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High.Width + 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High_TU.Position.Y := 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High_TU.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High_TU.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High_TU.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_6.High_TU.Visible := True;

  // Day 7 after
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout := TLayout.Create(vWeather.Scene.Tab[vTabNum].Forcast.Box);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout.Name := 'A_W_WeatherForcastDay7Panel_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Box;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout.Position.X := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout.Position.Y := 1130;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout.Width := vWeather.Scene.Tab[vTabNum]
    .Forcast.Box.Width - 50;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout.Height := 150;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Text :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Text.Name := 'A_W_WeatherForcastDay7Day_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Text.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Text.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Text.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Text.Position.X := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Text.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Text.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Text.Text := uWeather_Convert_Day(vTown.Day_7.Text) + ', ';
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Text.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Text.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Text.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Text);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Date :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Date.Name := 'A_W_WeatherForcastDay7Date_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Date.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Date.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Date.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Date.Position.X := 10 + vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_7.Text.Width;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Date.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Date.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Date.Text := uWeather_Convert_Date(vTown.Day_7.Date);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Date.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Date.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Date.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Date);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Image.Name := 'A_WeatherForcastDay7Image_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Image.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Image.Width := 130;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Image.Height := 130;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Image.Position.X :=
    (vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout.Width / 2) -
    (vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Image.Width / 2);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Image.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Image.Bitmap.LoadFromFile(addons.Weather.Path.Iconsets +
    addons.Weather.Config.Iconset.Name + '\w_w_' + vTown.Day_7.Code + '.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Condition :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Condition.Name := 'A_W_WeatherForcastDay7Text_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Condition.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_7.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Condition.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Condition.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Condition.Position.X := 150;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Condition.Position.Y := 70;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Condition.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Condition.Text := vTown.Day_7.Forcast;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Condition.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Condition.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Condition.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Condition);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low_Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low_Image.Name := 'A_WeatherForcastDay7LowImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low_Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_7.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low_Image.Width := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low_Image.Height := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low_Image.Position.X := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low_Image.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_7.Layout.Height - 58;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_temp_low.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low.Name := 'A_W_WeatherForcastDay7Low_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low.Position.X := 644;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_7.Layout.Height - 49;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low.Text := vTown.Day_7.Low;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low_TU :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low_TU.Name := 'A_W_WeatherForcastDay7LowTU_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low_TU.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low_TU.Font.Size := 8;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low_TU.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low_TU.Position.X := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_7.Low.Position.X + vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low.Width + 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low_TU.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_7.Layout.Height - 66;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low_TU.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low_TU.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low_TU.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Low_TU.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High_Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High_Image.Name := 'A_WeatherForcastDay7HighImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High_Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_7.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High_Image.Width := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High_Image.Height := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High_Image.Position.X := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High_Image.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_temp_high.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High.Name := 'A_W_WeatherForcastDay7High_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High.Position.X := 644;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High.Position.Y := 19;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High.Text := vTown.Day_7.High;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High_TU :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_7.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High_TU.Name := 'A_W_WeatherForcastDay7HighTU_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High_TU.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_7.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High_TU.Font.Size := 8;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High_TU.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High_TU.Position.X := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_7.High.Position.X + vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High.Width + 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High_TU.Position.Y := 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High_TU.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High_TU.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High_TU.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_7.High_TU.Visible := True;

  // Day 8 after
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout := TLayout.Create(vWeather.Scene.Tab[vTabNum].Forcast.Box);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout.Name := 'A_W_WeatherForcastDay8Panel_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Box;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout.Position.X := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout.Position.Y := 1290;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout.Width := vWeather.Scene.Tab[vTabNum]
    .Forcast.Box.Width - 50;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout.Height := 150;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Text :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Text.Name := 'A_W_WeatherForcastDay8Day_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Text.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Text.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Text.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Text.Position.X := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Text.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Text.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Text.Text := uWeather_Convert_Day(vTown.Day_8.Text) + ', ';
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Text.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Text.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Text.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Text);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Date :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Date.Name := 'A_W_WeatherForcastDay8Date_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Date.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Date.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Date.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Date.Position.X := 10 + vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_8.Text.Width;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Date.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Date.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Date.Text := uWeather_Convert_Date(vTown.Day_8.Date);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Date.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Date.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Date.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Date);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Image.Name := 'A_WeatherForcastDay8Image_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Image.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Image.Width := 130;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Image.Height := 130;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Image.Position.X :=
    (vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout.Width / 2) -
    (vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Image.Width / 2);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Image.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Image.Bitmap.LoadFromFile(addons.Weather.Path.Iconsets +
    addons.Weather.Config.Iconset.Name + '\w_w_' + vTown.Day_8.Code + '.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Condition :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Condition.Name := 'A_W_WeatherForcastDay8Text_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Condition.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_8.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Condition.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Condition.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Condition.Position.X := 150;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Condition.Position.Y := 70;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Condition.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Condition.Text := vTown.Day_8.Forcast;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Condition.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Condition.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Condition.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Condition);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low_Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low_Image.Name := 'A_WeatherForcastDay8LowImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low_Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_8.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low_Image.Width := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low_Image.Height := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low_Image.Position.X := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low_Image.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_8.Layout.Height - 58;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_temp_low.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low.Name := 'A_W_WeatherForcastDay8Low_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low.Position.X := 644;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_8.Layout.Height - 49;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low.Text := vTown.Day_8.Low;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low_TU :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low_TU.Name := 'A_W_WeatherForcastDay8LowTU_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low_TU.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low_TU.Font.Size := 8;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low_TU.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low_TU.Position.X := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_8.Low.Position.X + vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low.Width + 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low_TU.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_8.Layout.Height - 66;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low_TU.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low_TU.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low_TU.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Low_TU.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High_Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High_Image.Name := 'A_WeatherForcastDay8HighImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High_Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_8.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High_Image.Width := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High_Image.Height := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High_Image.Position.X := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High_Image.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_temp_high.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High.Name := 'A_W_WeatherForcastDay8High_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High.Position.X := 644;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High.Position.Y := 19;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High.Text := vTown.Day_8.High;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High_TU :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_8.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High_TU.Name := 'A_W_WeatherForcastDay8HighTU_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High_TU.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_8.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High_TU.Font.Size := 8;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High_TU.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High_TU.Position.X := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_8.High.Position.X + vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High.Width + 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High_TU.Position.Y := 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High_TU.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High_TU.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High_TU.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_8.High_TU.Visible := True;

  // Day 9 after
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout := TLayout.Create(vWeather.Scene.Tab[vTabNum].Forcast.Box);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout.Name := 'A_W_WeatherForcastDay9Panel_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Box;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout.Position.X := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout.Position.Y := 1450;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout.Width := vWeather.Scene.Tab[vTabNum]
    .Forcast.Box.Width - 50;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout.Height := 150;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Text :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Text.Name := 'A_W_WeatherForcastDay9Day_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Text.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Text.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Text.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Text.Position.X := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Text.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Text.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Text.Text := uWeather_Convert_Day(vTown.Day_9.Text) + ', ';
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Text.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Text.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Text.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Text);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Date :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Date.Name := 'A_W_WeatherForcastDay9Date_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Date.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Date.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Date.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Date.Position.X := 10 + vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_9.Text.Width;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Date.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Date.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Date.Text := uWeather_Convert_Date(vTown.Day_9.Date);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Date.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Date.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Date.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Date);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Image.Name := 'A_WeatherForcastDay9Image_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Image.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Image.Width := 130;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Image.Height := 130;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Image.Position.X :=
    (vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout.Width / 2) -
    (vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Image.Width / 2);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Image.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Image.Bitmap.LoadFromFile(addons.Weather.Path.Iconsets +
    addons.Weather.Config.Iconset.Name + '\w_w_' + vTown.Day_9.Code + '.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Condition :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Condition.Name := 'A_W_WeatherForcastDay9Text_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Condition.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_9.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Condition.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Condition.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Condition.Position.X := 150;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Condition.Position.Y := 70;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Condition.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Condition.Text := vTown.Day_9.Forcast;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Condition.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Condition.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Condition.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Condition);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low_Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low_Image.Name := 'A_WeatherForcastDay9LowImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low_Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_9.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low_Image.Width := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low_Image.Height := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low_Image.Position.X := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low_Image.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_9.Layout.Height - 58;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_temp_low.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low.Name := 'A_W_WeatherForcastDay9Low_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low.Position.X := 644;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_9.Layout.Height - 49;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low.Text := vTown.Day_9.Low;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low_TU :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low_TU.Name := 'A_W_WeatherForcastDay9LowTU_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low_TU.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low_TU.Font.Size := 8;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low_TU.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low_TU.Position.X := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_9.Low.Position.X + vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low.Width + 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low_TU.Position.Y := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_9.Layout.Height - 66;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low_TU.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low_TU.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low_TU.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Low_TU.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High_Image :=
    TImage.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High_Image.Name := 'A_WeatherForcastDay9HighImage_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High_Image.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_9.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High_Image.Width := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High_Image.Height := 48;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High_Image.Position.X := 600;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High_Image.Position.Y := 10;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High_Image.Bitmap.LoadFromFile
    (addons.Weather.Path.Images + 'w_temp_high.png');
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High_Image.Visible := True;

  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High.Name := 'A_W_WeatherForcastDay9High_' + IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High.Parent := vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High.Font.Size := 22;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High.Position.X := 644;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High.Position.Y := 19;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High.Height := 30;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High.Text := vTown.Day_9.High;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High.Visible := True;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High.Width :=
    uSnippet_Text_ToPixels(vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High);

  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High_TU :=
    TText.Create(vWeather.Scene.Tab[vTabNum].Forcast.Day_9.Layout);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High_TU.Name := 'A_W_WeatherForcastDay9HighTU_' +
    IntToStr(vTabNum);
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High_TU.Parent := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_9.Layout;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High_TU.Font.Size := 8;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High_TU.Color := TAlphaColorRec.White;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High_TU.Position.X := vWeather.Scene.Tab[vTabNum]
    .Forcast.Day_9.High.Position.X + vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High.Width + 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High_TU.Position.Y := 4;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High_TU.Text := vTown.UnitV.Temperature;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High_TU.TextSettings.HorzAlign := TTextAlign.Leading;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High_TU.Tag := vTabNum;
  vWeather.Scene.Tab[vTabNum].Forcast.Day_9.High_TU.Visible := True;

  if addons.Weather.Action.Active_Total > 0 then
    vWeather.Scene.Arrow_Right.Visible := True;
end;

end.