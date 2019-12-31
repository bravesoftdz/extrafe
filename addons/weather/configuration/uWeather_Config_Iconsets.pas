unit uWeather_Config_Iconsets;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UiTypes,
  System.Math,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Effects;

procedure Load;
procedure Free;

Procedure Create_Mini_Preview(vNum: Integer);

implementation

uses
  uDB_AUser,
  uWeather_AllTypes,
  uWeather_Providers_Yahoo_Config,
  uWeather_Providers_OpenWeatherMap_Config;

procedure Load;
begin
  if uDB_AUser.Local.ADDONS.Weather_D.Provider <> '' then
  begin
    if uDB_AUser.Local.ADDONS.Weather_D.Provider = 'yahoo' then
      uWeather_Providers_Yahoo_Config.Create_Iconsets
    else if uDB_AUser.Local.ADDONS.Weather_D.Provider = 'openweathermap' then
      uWeather_Providers_OpenWeatherMap_Config.Create_Iconsets;
  end;
end;

procedure Free;
begin
  FreeAndNil(vWeather.Config.main.Right.Panels[3]);
end;

Procedure Create_Mini_Preview(vNum: Integer);
var
  vi: Integer;
begin
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name := TLabel.Create(vWeather.Config.main.Right.Iconsets.Box);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.Name := 'Weather_Config_Iconsets_Preview_Name_' + IntToStr(vNum);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.Parent := vWeather.Config.main.Right.Iconsets.Box;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.SetBounds(10, 2 + (vNum * 68), 300, 20);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.Text := uDB_AUser.Local.ADDONS.Weather_D.Yahoo.Iconsets.Strings[vNum];
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.Font.Style := vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.Font.Style + [TFontStyle.fsBold];
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Name.Visible := True;

  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel := TPanel.Create(vWeather.Config.main.Right.Iconsets.Box);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.Name := 'Weather_Config_Iconsets_Mini_Preview_Panel_' + IntToStr(vNum);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.Parent := vWeather.Config.main.Right.Iconsets.Box;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.SetBounds(10, 20 + (vNum * 68), vWeather.Config.main.Right.Iconsets.Box.Width - 30, 54);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.OnClick := weather.Input.mouse.Panel.OnMouseClick;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.OnMouseEnter := weather.Input.mouse.Panel.OnMouseEnter;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.OnMouseLeave := weather.Input.mouse.Panel.OnMouseLeave;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.Tag := vNum;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.TagFloat := 100;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel.Visible := True;

  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel_Glow := TGlowEffect.Create(vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel_Glow.Name := 'Weather_Config_Iconsets_Mini_Preview_Panel_Glow_' + IntToStr(vNum);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel_Glow.Parent := vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel_Glow.Opacity := 0.9;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel_Glow.Softness := 0.4;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel_Glow.Enabled := False;

  for vi := 0 to 7 do
  begin
    vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi] := TImage.Create(vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel);
    vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].Name := 'Weather_Config_Iconsets_Mini_Preview_Image_' + IntToStr(vNum) + '_' + IntToStr(vi);
    vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].Parent := vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel;
    vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].SetBounds(50 * vi, 2, 50, 50);
    vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].Bitmap.LoadFromFile(uDB_AUser.Local.ADDONS.Weather_D.p_Icons +
      uDB_AUser.Local.ADDONS.Weather_D.Yahoo.Iconsets.Strings[vNum] + '\w_w_' + IntToStr(RandomRange(0, 49)) + '.png');
    vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].TagFloat := 100;
    vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].Tag := vNum;
    vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].OnClick := weather.Input.mouse.Image.OnMouseClick;
    vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].OnMouseEnter := weather.Input.mouse.Image.OnMouseEnter;
    vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].OnMouseLeave := weather.Input.mouse.Image.OnMouseLeave;
    vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[vi].Visible := True;
  end;

  if uDB_AUser.Local.ADDONS.Weather_D.Yahoo.Iconset = uDB_AUser.Local.ADDONS.Weather_D.Yahoo.Iconsets.Strings[vNum] then
    vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[0].Bitmap.LoadFromFile(uDB_AUser.Local.ADDONS.Weather_D.p_Images + 'w_check.png')
  else
    vWeather.Config.main.Right.Iconsets.Mini[vNum].Image[0].Bitmap := nil;

  vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview := TImage.Create(vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview.Name := 'A_W_Config_Iconsets_Mini_Priview_' + IntToStr(vNum);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview.Parent := vWeather.Config.main.Right.Iconsets.Mini[vNum].Panel;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview.SetBounds(50 * 8, 2, 40, 50);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview.Bitmap.LoadFromFile(uDB_AUser.Local.ADDONS.Weather_D.p_Images + 'w_preview.png');
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview.WrapMode := TImageWrapMode.Fit;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview.OnClick := weather.Input.mouse.Image.OnMouseClick;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview.OnMouseEnter := weather.Input.mouse.Image.OnMouseEnter;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview.OnMouseLeave := weather.Input.mouse.Image.OnMouseLeave;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview.TagFloat := 101;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview.Tag := vNum;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview.Visible := True;

  vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview_Glow := TGlowEffect.Create(vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview);
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview_Glow.Name := 'A_W_Config_Iconsets_Mini_Priview_Glow_' + vNum.ToString;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview_Glow.Parent := vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview_Glow.Softness := 0.4;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview_Glow.Opacity := 0.9;
  vWeather.Config.main.Right.Iconsets.Mini[vNum].Preview_Glow.Enabled := False;
end;

end.
