unit uTime_Time_SetAll;

interface

uses
  System.Classes,
  System.UiTypes,
  System.UiConsts,
  System.SysUtils,
  FMX.Objects,
  FMX.Effects,
  FMX.Colors,
  FMX.Edit,
  FMX.Ani,
  FMX.Graphics,
  FMX.Types,
  FMX.StdCtrls,
  FMX.TabControl,
  FMX.Listbox,
  Radiant.Shapes;

procedure Load;
procedure Free;

procedure Digital_Create;
procedure Digital_Free;

procedure Analog_Create;
procedure Analog_Free;

procedure Config_Load;
procedure Config_Free;
procedure Config_Show_General;
procedure Config_Show_Analog;
procedure Config_Show_Digital;

implementation

uses
  uWindows,
  uDB_AUser,
  uLoad_AllTypes,
  uTime_SetAll,
  uTime_AllTypes,
  uTime_Time_AllTypes,
  uTime_Time_Actions;

procedure Load;
begin
  addons.time.P_Time.Sound_Tick := False;

  vTime.P_Time.Back := Timage.Create(vTime.Back);
  vTime.P_Time.Back.Name := 'A_T_P_Time_Back';
  vTime.P_Time.Back.Parent := vTime.Back;
  vTime.P_Time.Back.SetBounds(0, 120, vTime.Back.Width, vTime.Back.Height - 220);
  vTime.P_Time.Back.Bitmap.LoadFromFile(uDB_AUser.Local.addons.Time_D.Path.Images + 't_back.png');
  vTime.P_Time.Back.Visible := True;

  vTime.P_Time.Settings := TText.Create(vTime.P_Time.Back);
  vTime.P_Time.Settings.Name := 'A_T_P_Time_Settings';
  vTime.P_Time.Settings.Parent := vTime.P_Time.Back;
  vTime.P_Time.Settings.SetBounds(vTime.P_Time.Back.Width - 60, vTime.P_Time.Back.Height - 20, 50, 50);
  vTime.P_Time.Settings.Font.Family := 'IcoMoon-Free';
  vTime.P_Time.Settings.Font.Size := 48;
  vTime.P_Time.Settings.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vTime.P_Time.Settings.Text := #$e994;
  vTime.P_Time.Settings.OnClick := addons.time.Input.mouse_time.Text.OnMouseClick;
  vTime.P_Time.Settings.OnMouseEnter := addons.time.Input.mouse_time.Text.OnMouseEnter;
  vTime.P_Time.Settings.OnMouseLeave := addons.time.Input.mouse_time.Text.OnMouseLeave;
  vTime.P_Time.Settings.Visible := True;

  vTime.P_Time.Settings_Glow := TGlowEffect.Create(vTime.P_Time.Settings);
  vTime.P_Time.Settings_Glow.Name := 'A_T_P_Time_Settings_Glow';
  vTime.P_Time.Settings_Glow.Parent := vTime.P_Time.Settings;
  vTime.P_Time.Settings_Glow.Softness := 0.4;
  vTime.P_Time.Settings_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vTime.P_Time.Settings_Glow.Opacity := 0.9;
  vTime.P_Time.Settings_Glow.Enabled := False;

  vTime.P_Time.Settings_Ani := TFloatAnimation.Create(vTime.P_Time.Settings);
  vTime.P_Time.Settings_Ani.Name := 'A_T_P_Time_Settings_Animation';
  vTime.P_Time.Settings_Ani.Parent := vTime.P_Time.Settings;
  vTime.P_Time.Settings_Ani.Duration := 4;
  vTime.P_Time.Settings_Ani.Loop := True;
  vTime.P_Time.Settings_Ani.PropertyName := 'RotationAngle';
  vTime.P_Time.Settings_Ani.StartValue := 0;
  vTime.P_Time.Settings_Ani.StopValue := 360;
  vTime.P_Time.Settings_Ani.Enabled := True;

  vTime.P_Time.Timer := TTimer.Create(vTime.P_Time.Back);
  vTime.P_Time.Timer.Name := 'A_T_P_Time_Timer';
  vTime.P_Time.Timer.Parent := vTime.P_Time.Back;
  vTime.P_Time.Timer.Interval := 10;
  vTime.P_Time.Timer.OnTimer := uTime_Time_Actions.Timer_Time.OnTimer;
  vTime.P_Time.Timer.Enabled := True;

  Digital_Create;
  Analog_Create;

  uTime_Time_Actions.General_ShowType(uDB_AUser.Local.addons.Time_D.time.vType);

end;

procedure Digital_Create;
begin
  vTime.P_Time.Digital.Back := Timage.Create(vTime.P_Time.Back);
  vTime.P_Time.Digital.Back.Name := 'A_T_P_Time_Digital_Back';
  vTime.P_Time.Digital.Back.Parent := vTime.P_Time.Back;
  vTime.P_Time.Digital.Back.SetBounds((vTime.P_Time.Back.Width / 2) - 300, (vTime.P_Time.Back.Height / 2) - 80, 600, 160);
  vTime.P_Time.Digital.Back.Visible := True;

  vTime.P_Time.Digital.Rect := TRadiantRectangle.Create(vTime.P_Time.Digital.Back);
  vTime.P_Time.Digital.Rect.Name := 'A_T_P_Time_Digital_Rect';
  vTime.P_Time.Digital.Rect.Parent := vTime.P_Time.Digital.Back;
  vTime.P_Time.Digital.Rect.SetBounds(0, 0, 600, 160);
  vTime.P_Time.Digital.Rect.Fill.Kind := TBrushKind.Solid;
  vTime.P_Time.Digital.Rect.Fill.Color := StringToColor(uDB_AUser.Local.addons.Time_D.time.Digital_Color);
  vTime.P_Time.Digital.Rect.Stroke.Thickness := 2;
  vTime.P_Time.Digital.Rect.Stroke.Color := StringToColor(uDB_AUser.Local.addons.Time_D.time.Digital_Color);

  vTime.P_Time.Digital.Hour := TText.Create(vTime.P_Time.Digital.Back);
  vTime.P_Time.Digital.Hour.Name := 'A_T_P_Time_Digital_Hour';
  vTime.P_Time.Digital.Hour.Parent := vTime.P_Time.Digital.Back;
  vTime.P_Time.Digital.Hour.SetBounds(40, 10, 0, 140);
  vTime.P_Time.Digital.Hour.Text := '11:';
  vTime.P_Time.Digital.Hour.Font.Family := uDB_AUser.Local.addons.Time_D.time.Digital_Font;
  vTime.P_Time.Digital.Hour.Font.Size := 72;
  vTime.P_Time.Digital.Hour.TextSettings.HorzAlign := TTextAlign.Center;
  vTime.P_Time.Digital.Hour.Font.Style := vTime.P_Time.Digital.Hour.Font.Style + [TFontStyle.fsBold];
  vTime.P_Time.Digital.Hour.TextSettings.FontColor := StringToColor(uDB_AUser.Local.addons.Time_D.time.Digital_Font_Color);
  vTime.P_Time.Digital.Hour.Visible := True;

  vTime.P_Time.Digital.Sep_1 := TText.Create(vTime.P_Time.Digital.Back);
  vTime.P_Time.Digital.Sep_1.Name := 'A_T_P_Time_Digital_Sep_1';
  vTime.P_Time.Digital.Sep_1.Parent := vTime.P_Time.Digital.Back;
  vTime.P_Time.Digital.Sep_1.SetBounds(100, 10, 0, 140);
  vTime.P_Time.Digital.Sep_1.Text := uDB_AUser.Local.addons.Time_D.time.Digital_Sep;
  vTime.P_Time.Digital.Sep_1.Font.Family := uDB_AUser.Local.addons.Time_D.time.Digital_Font;
  vTime.P_Time.Digital.Sep_1.Font.Size := 72;
  vTime.P_Time.Digital.Sep_1.TextSettings.HorzAlign := TTextAlign.Center;
  vTime.P_Time.Digital.Sep_1.TextSettings.FontColor := StringToColor(uDB_AUser.Local.addons.Time_D.time.Digital_Sep_Color);
  vTime.P_Time.Digital.Sep_1.Visible := True;

  vTime.P_Time.Digital.Sep_1_Ani := TFloatAnimation.Create(vTime.P_Time.Digital.Sep_1);
  vTime.P_Time.Digital.Sep_1_Ani.Name := 'A_T_P_Time_Digital_Sep_1_Animation';
  vTime.P_Time.Digital.Sep_1_Ani.Parent := vTime.P_Time.Digital.Sep_1;
  vTime.P_Time.Digital.Sep_1_Ani.PropertyName := 'Opacity';
  vTime.P_Time.Digital.Sep_1_Ani.StartValue := 1;
  vTime.P_Time.Digital.Sep_1_Ani.StopValue := 0.1;
  vTime.P_Time.Digital.Sep_1_Ani.Duration := 0.8;
  vTime.P_Time.Digital.Sep_1_Ani.Enabled := False;

  vTime.P_Time.Digital.Minutes := TText.Create(vTime.P_Time.Digital.Back);
  vTime.P_Time.Digital.Minutes.Name := 'A_T_P_Time_Digital_Minutes';
  vTime.P_Time.Digital.Minutes.Parent := vTime.P_Time.Digital.Back;
  vTime.P_Time.Digital.Minutes.SetBounds(230, 10, 0, 140);
  vTime.P_Time.Digital.Minutes.Text := '25:';
  vTime.P_Time.Digital.Minutes.Font.Family := uDB_AUser.Local.addons.Time_D.time.Digital_Font;
  vTime.P_Time.Digital.Minutes.Font.Size := 72;
  vTime.P_Time.Digital.Minutes.TextSettings.HorzAlign := TTextAlign.Center;
  vTime.P_Time.Digital.Minutes.Font.Style := vTime.P_Time.Digital.Minutes.Font.Style + [TFontStyle.fsBold];
  vTime.P_Time.Digital.Minutes.TextSettings.FontColor := StringToColor(uDB_AUser.Local.addons.Time_D.time.Digital_Font_Color);
  vTime.P_Time.Digital.Minutes.Visible := True;

  vTime.P_Time.Digital.Sep_2 := TText.Create(vTime.P_Time.Digital.Back);
  vTime.P_Time.Digital.Sep_2.Name := 'A_T_P_Time_Digital_Sep_2';
  vTime.P_Time.Digital.Sep_2.Parent := vTime.P_Time.Digital.Back;
  vTime.P_Time.Digital.Sep_2.SetBounds(100, 10, 0, 140);
  vTime.P_Time.Digital.Sep_2.Text := uDB_AUser.Local.addons.Time_D.time.Digital_Sep;
  vTime.P_Time.Digital.Sep_2.Font.Family := uDB_AUser.Local.addons.Time_D.time.Digital_Font;
  vTime.P_Time.Digital.Sep_2.Font.Size := 72;
  vTime.P_Time.Digital.Sep_2.TextSettings.HorzAlign := TTextAlign.Center;
  vTime.P_Time.Digital.Sep_2.TextSettings.FontColor := StringToColor(uDB_AUser.Local.addons.Time_D.time.Digital_Font_Color);
  vTime.P_Time.Digital.Sep_2.Visible := True;

  vTime.P_Time.Digital.Sep_2_Ani := TFloatAnimation.Create(vTime.P_Time.Digital.Sep_2);
  vTime.P_Time.Digital.Sep_2_Ani.Name := 'A_T_P_Time_Digital_Sep_2_Animation';
  vTime.P_Time.Digital.Sep_2_Ani.Parent := vTime.P_Time.Digital.Sep_2;
  vTime.P_Time.Digital.Sep_2_Ani.PropertyName := 'Opacity';
  vTime.P_Time.Digital.Sep_2_Ani.StartValue := 1;
  vTime.P_Time.Digital.Sep_2_Ani.StopValue := 0.1;
  vTime.P_Time.Digital.Sep_2_Ani.Duration := 0.8;
  vTime.P_Time.Digital.Sep_2_Ani.Enabled := False;

  vTime.P_Time.Digital.Seconds := TText.Create(vTime.P_Time.Digital.Back);
  vTime.P_Time.Digital.Seconds.Name := 'A_T_P_Time_Digital_Seocnds';
  vTime.P_Time.Digital.Seconds.Parent := vTime.P_Time.Digital.Back;
  vTime.P_Time.Digital.Seconds.SetBounds(420, 10, 0, 140);
  vTime.P_Time.Digital.Seconds.Text := '13';
  vTime.P_Time.Digital.Seconds.Font.Family := uDB_AUser.Local.addons.Time_D.time.Digital_Font;
  vTime.P_Time.Digital.Seconds.Font.Size := 72;
  vTime.P_Time.Digital.Seconds.TextSettings.HorzAlign := TTextAlign.Center;
  vTime.P_Time.Digital.Seconds.Font.Style := vTime.P_Time.Digital.Seconds.Font.Style + [TFontStyle.fsBold];
  vTime.P_Time.Digital.Seconds.HorzTextAlign := TTextAlign.Leading;
  vTime.P_Time.Digital.Seconds.TextSettings.FontColor := StringToColor(uDB_AUser.Local.addons.Time_D.time.Digital_Font_Color);
  vTime.P_Time.Digital.Seconds.Visible := True;
end;

procedure Digital_Free;
begin

end;

procedure Analog_Create;
var
  vi: Integer;
begin
  vTime.P_Time.Analog.Back := Timage.Create(vTime.P_Time.Back);
  vTime.P_Time.Analog.Back.Name := 'A_T_P_Time_Analog_Back';
  vTime.P_Time.Analog.Back.Parent := vTime.P_Time.Back;
  vTime.P_Time.Analog.Back.SetBounds((vTime.P_Time.Back.Width / 2) - 300, (vTime.P_Time.Back.Height / 2) - 300, 600, 600);
  vTime.P_Time.Analog.Back.Visible := True;

  vTime.P_Time.Analog.Circle := TRadiantRing.Create(vTime.P_Time.Analog.Back);
  vTime.P_Time.Analog.Circle.Name := 'A_T_P_Time_Analog_Circle';
  vTime.P_Time.Analog.Circle.Parent := vTime.P_Time.Analog.Back;
  vTime.P_Time.Analog.Circle.SetBounds(0, 0, 600, 600);
  vTime.P_Time.Analog.Circle.Fill.Color := TAlphaColorRec.Deepskyblue;
  vTime.P_Time.Analog.Circle.Fill.Kind := TBrushKind.Solid;
  vTime.P_Time.Analog.Circle.RingSize.Pixels := 10;
  vTime.P_Time.Analog.Circle.RingSize.Units := TRadiantDimensionUnits.Pixels;
  vTime.P_Time.Analog.Circle.Visible := True;

  for vi := 0 to 3 do
  begin
    vTime.P_Time.Analog.Quarters[vi] := TRadiantRectangle.Create(vTime.P_Time.Analog.Circle);
    vTime.P_Time.Analog.Quarters[vi].Name := 'A_T_P_Time_Analog_Quarter_Image_' + IntToStr(vi);
    vTime.P_Time.Analog.Quarters[vi].Parent := vTime.P_Time.Analog.Circle;
    vTime.P_Time.Analog.Quarters[vi].Width := 50;
    vTime.P_Time.Analog.Quarters[vi].Height := 10;
    case vi of
      0:
        begin
          vTime.P_Time.Analog.Quarters[vi].Position.Y := 30;
          vTime.P_Time.Analog.Quarters[vi].RotationAngle := 90;
          vTime.P_Time.Analog.Quarters[vi].Position.X := (vTime.P_Time.Analog.Circle.Width / 2) - 25;
        end;
      1:
        begin
          vTime.P_Time.Analog.Quarters[vi].Position.X := 10;
          vTime.P_Time.Analog.Quarters[vi].Position.Y := 295;
        end;
      2:
        begin
          vTime.P_Time.Analog.Quarters[vi].Position.X := 540;
          vTime.P_Time.Analog.Quarters[vi].Position.Y := 295;
        end;
      3:
        begin
          vTime.P_Time.Analog.Quarters[vi].Position.Y := 560;
          vTime.P_Time.Analog.Quarters[vi].RotationAngle := 90;
          vTime.P_Time.Analog.Quarters[vi].Position.X := (vTime.P_Time.Analog.Circle.Width / 2) - 25;
        end;
    end;
    vTime.P_Time.Analog.Quarters[vi].Fill.Bitmap.Bitmap.LoadFromFile(uDB_AUser.Local.addons.Time_D.Path.Clocks + 'default\t_analog_hour.png');
    vTime.P_Time.Analog.Quarters[vi].Fill.Bitmap.WrapMode := TWrapMode.TileOriginal;
    vTime.P_Time.Analog.Quarters[vi].Fill.Kind := TBrushKind.Bitmap;
    vTime.P_Time.Analog.Quarters[vi].Stroke.Thickness := 0;
    vTime.P_Time.Analog.Quarters[vi].Stroke.Color := TAlphaColorRec.White;
    vTime.P_Time.Analog.Quarters[vi].Visible := False;
  end;

  for vi := 0 to 7 do
  begin
    vTime.P_Time.Analog.Hours[vi] := TRadiantRectangle.Create(vTime.P_Time.Analog.Circle);
    vTime.P_Time.Analog.Hours[vi].Name := 'A_T_P_Time_Analog_Hour_Image_' + IntToStr(vi);
    vTime.P_Time.Analog.Hours[vi].Parent := vTime.P_Time.Analog.Circle;
    vTime.P_Time.Analog.Hours[vi].Width := 30;
    vTime.P_Time.Analog.Hours[vi].Height := 8;
    case vi of
      0:
        begin
          vTime.P_Time.Analog.Hours[vi].RotationAngle := 120;
          vTime.P_Time.Analog.Hours[vi].Position.X := 423;
          vTime.P_Time.Analog.Hours[vi].Position.Y := 57;
        end;
      1:
        begin
          vTime.P_Time.Analog.Hours[vi].RotationAngle := 150;
          vTime.P_Time.Analog.Hours[vi].Position.X := 524;
          vTime.P_Time.Analog.Hours[vi].Position.Y := 158;
        end;
      2:
        begin
          vTime.P_Time.Analog.Hours[vi].RotationAngle := 210;
          vTime.P_Time.Analog.Hours[vi].Position.X := 524;
          vTime.P_Time.Analog.Hours[vi].Position.Y := 434;
        end;
      3:
        begin
          vTime.P_Time.Analog.Hours[vi].RotationAngle := 240;
          vTime.P_Time.Analog.Hours[vi].Position.X := 423;
          vTime.P_Time.Analog.Hours[vi].Position.Y := 536;
        end;
      4:
        begin
          vTime.P_Time.Analog.Hours[vi].RotationAngle := 300;
          vTime.P_Time.Analog.Hours[vi].Position.X := 146;
          vTime.P_Time.Analog.Hours[vi].Position.Y := 536;
        end;
      5:
        begin
          vTime.P_Time.Analog.Hours[vi].RotationAngle := 330;
          vTime.P_Time.Analog.Hours[vi].Position.X := 47;
          vTime.P_Time.Analog.Hours[vi].Position.Y := 434;
        end;
      6:
        begin
          vTime.P_Time.Analog.Hours[vi].RotationAngle := 30;
          vTime.P_Time.Analog.Hours[vi].Position.X := 47;
          vTime.P_Time.Analog.Hours[vi].Position.Y := 158;
        end;
      7:
        begin
          vTime.P_Time.Analog.Hours[vi].RotationAngle := 60;
          vTime.P_Time.Analog.Hours[vi].Position.X := 146;
          vTime.P_Time.Analog.Hours[vi].Position.Y := 56;
        end;
    end;
    vTime.P_Time.Analog.Hours[vi].Fill.Bitmap.Bitmap.LoadFromFile(uDB_AUser.Local.addons.Time_D.Path.Clocks + 'default\t_analog_hour.png');
    vTime.P_Time.Analog.Hours[vi].Fill.Bitmap.WrapMode := TWrapMode.TileOriginal;
    vTime.P_Time.Analog.Hours[vi].Fill.Kind := TBrushKind.Bitmap;
    vTime.P_Time.Analog.Hours[vi].Stroke.Thickness := 0;
    vTime.P_Time.Analog.Hours[vi].Stroke.Color := TAlphaColorRec.White;
    vTime.P_Time.Analog.Hours[vi].Visible := False;
  end;

  vTime.P_Time.Analog.Hour := TRadiantRectangle.Create(vTime.P_Time.Analog.Circle);
  vTime.P_Time.Analog.Hour.Name := 'A_T_P_Time_Analog_Hour';
  vTime.P_Time.Analog.Hour.Parent := vTime.P_Time.Analog.Circle;
  vTime.P_Time.Analog.Hour.SetBounds((vTime.P_Time.Analog.Circle.Width / 2) - 5, 0, 10, 600);
  vTime.P_Time.Analog.Hour.Fill.Bitmap.Bitmap.LoadFromFile(uDB_AUser.Local.addons.Time_D.Path.Clocks + 'default\t_analog_hour_image.png');
  vTime.P_Time.Analog.Hour.Fill.Bitmap.WrapMode := TWrapMode.TileOriginal;
  vTime.P_Time.Analog.Hour.Fill.Kind := TBrushKind.Bitmap;
  vTime.P_Time.Analog.Hour.Stroke.Thickness := 0;
  vTime.P_Time.Analog.Hour.Stroke.Color := TAlphaColorRec.White;
  vTime.P_Time.Analog.Hour.Visible := True;

  vTime.P_Time.Analog.Minutes := TRadiantRectangle.Create(vTime.P_Time.Analog.Circle);
  vTime.P_Time.Analog.Minutes.Name := 'A_T_P_Time_Analog_Minutes';
  vTime.P_Time.Analog.Minutes.Parent := vTime.P_Time.Analog.Circle;
  vTime.P_Time.Analog.Minutes.SetBounds((vTime.P_Time.Analog.Circle.Width / 2) - 5, 0, 10, 600);
  vTime.P_Time.Analog.Minutes.Fill.Bitmap.Bitmap.LoadFromFile(uDB_AUser.Local.addons.Time_D.Path.Clocks + 'default\t_analog_minutes.png');
  vTime.P_Time.Analog.Minutes.Fill.Bitmap.WrapMode := TWrapMode.TileOriginal;
  vTime.P_Time.Analog.Minutes.Fill.Kind := TBrushKind.Bitmap;
  vTime.P_Time.Analog.Minutes.Stroke.Thickness := 0;
  vTime.P_Time.Analog.Minutes.Stroke.Color := TAlphaColorRec.White;
  vTime.P_Time.Analog.Minutes.Visible := True;

  vTime.P_Time.Analog.Seconds := TRadiantRectangle.Create(vTime.P_Time.Analog.Circle);
  vTime.P_Time.Analog.Seconds.Name := 'A_T_P_Time_Analog_Seconds';
  vTime.P_Time.Analog.Seconds.Parent := vTime.P_Time.Analog.Circle;
  vTime.P_Time.Analog.Seconds.SetBounds((vTime.P_Time.Analog.Circle.Width / 2) - 2, 0, 4, 600);
  vTime.P_Time.Analog.Seconds.Fill.Bitmap.Bitmap.LoadFromFile(uDB_AUser.Local.addons.Time_D.Path.Clocks + 'default\t_analog_seconds.png');
  vTime.P_Time.Analog.Seconds.Fill.Bitmap.WrapMode := TWrapMode.TileOriginal;
  vTime.P_Time.Analog.Seconds.Fill.Kind := TBrushKind.Bitmap;
  vTime.P_Time.Analog.Seconds.Stroke.Thickness := 0;
  vTime.P_Time.Analog.Seconds.Stroke.Color := TAlphaColorRec.White;
  vTime.P_Time.Analog.Seconds.Visible := True;
end;

procedure Analog_Free;
begin

end;

procedure Config_Load;
const
  cTab_Names: array [0 .. 2] of string = ('General', 'Analog', 'Digital');
var
  vi: Integer;
begin
  vTime.P_Time.Config.Panel := TPanel.Create(vTime.P_Time.Back);
  vTime.P_Time.Config.Panel.Name := 'A_T_P_Time_Config';
  vTime.P_Time.Config.Panel.Parent := vTime.P_Time.Back;
  vTime.P_Time.Config.Panel.SetBounds(vTime.P_Time.Back.Width - 362, 2, 360, vTime.P_Time.Back.Height - 160);
  vTime.P_Time.Config.Panel.Visible := True;

  CreateHeader(vTime.P_Time.Config.Panel, 'IcoMoon-Free', #$e994, TAlphaColorRec.DeepSkyBlue, 'Configuration', False, nil);

  vTime.P_Time.Config.Main.Panel := TPanel.Create(vTime.P_Time.Config.Panel);
  vTime.P_Time.Config.Main.Panel.Name := 'A_T_P_Time_Main';
  vTime.P_Time.Config.Main.Panel.Parent := vTime.P_Time.Config.Panel;
  vTime.P_Time.Config.Main.Panel.SetBounds(0, 30, vTime.P_Time.Config.Panel.Width, vTime.P_Time.Config.Panel.Height - 30);
  vTime.P_Time.Config.Main.Panel.Visible := True;

  vTime.P_Time.Config.Control := TTabControl.Create(vTime.P_Time.Config.Main.Panel);
  vTime.P_Time.Config.Control.Name := 'A_T_P_Time_Control';
  vTime.P_Time.Config.Control.Parent := vTime.P_Time.Config.Main.Panel;
  vTime.P_Time.Config.Control.Align := TAlignLayout.Client;
  vTime.P_Time.Config.Control.Visible := True;

  for vi := 0 to 2 do
  begin
    vTime.P_Time.Config.Tab[vi] := TTabItem.Create(vTime.P_Time.Config.Control);
    vTime.P_Time.Config.Tab[vi].Name := 'A_T_P_Time_TabItem_' + IntToStr(vi);
    vTime.P_Time.Config.Tab[vi].Parent := vTime.P_Time.Config.Control;
    vTime.P_Time.Config.Tab[vi].Text := cTab_Names[vi];
    vTime.P_Time.Config.Tab[vi].Width := vTime.P_Time.Config.Control.Width;
    vTime.P_Time.Config.Tab[vi].Height := vTime.P_Time.Config.Control.Height;
    vTime.P_Time.Config.Tab[vi].OnClick := addons.time.Input.mouse_time.TabItem.OnMouseClick;
    vTime.P_Time.Config.Tab[vi].Visible := True;
  end;
end;

procedure Config_Free;
begin
  if Assigned(vTime.P_Time.Config.General.Panel) then
    FreeAndNil(vTime.P_Time.Config.General.Panel);
  if Assigned(vTime.P_Time.Config.Analog.Panel) then
    FreeAndNil(vTime.P_Time.Config.Analog.Panel);
  if Assigned(vTime.P_Time.Config.Digital.Panel) then
    FreeAndNil(vTime.P_Time.Config.Digital.Panel);
  FreeAndNil(vTime.P_Time.Config.Panel);
end;

procedure Config_Show_General;
begin
  vTime.P_Time.Config.General.Panel := TPanel.Create(vTime.P_Time.Config.Tab[0]);
  vTime.P_Time.Config.General.Panel.Name := 'A_T_P_Time_General';
  vTime.P_Time.Config.General.Panel.Parent := vTime.P_Time.Config.Tab[0];
  vTime.P_Time.Config.General.Panel.SetBounds(0, 0, vTime.P_Time.Config.Control.Width, vTime.P_Time.Config.Control.Height);
  vTime.P_Time.Config.General.Panel.Visible := True;

  vTime.P_Time.Config.General.ShowType_L := TLabel.Create(vTime.P_Time.Config.General.Panel);
  vTime.P_Time.Config.General.ShowType_L.Name := 'A_T_P_Time_General_Type_Label';
  vTime.P_Time.Config.General.ShowType_L.Parent := vTime.P_Time.Config.General.Panel;
  vTime.P_Time.Config.General.ShowType_L.SetBounds(10, 20, 300, 24);
  vTime.P_Time.Config.General.ShowType_L.Text := 'Clock type';
  vTime.P_Time.Config.General.ShowType_L.Font.Style := vTime.P_Time.Config.General.ShowType_L.Font.Style + [TFontStyle.fsBold];
  vTime.P_Time.Config.General.ShowType_L.Visible := True;

  vTime.P_Time.Config.General.ShowType := TComboBox.Create(vTime.P_Time.Config.General.Panel);
  vTime.P_Time.Config.General.ShowType.Name := 'A_T_P_Time_General_Type';
  vTime.P_Time.Config.General.ShowType.Parent := vTime.P_Time.Config.General.Panel;
  vTime.P_Time.Config.General.ShowType.SetBounds(10, 40, vTime.P_Time.Config.General.Panel.Width - 20, 24);
  vTime.P_Time.Config.General.ShowType.Items.Add('Analog');
  vTime.P_Time.Config.General.ShowType.Items.Add('Digital');
  vTime.P_Time.Config.General.ShowType.Items.Add('Both');
  vTime.P_Time.Config.General.ShowType.OnChange := addons.time.Input.mouse_time.Combobox.OnChange;
  vTime.P_Time.Config.General.ShowType.Visible := True;

  vTime.P_Time.Config.General.ShowBothType_L := TLabel.Create(vTime.P_Time.Config.General.Panel);
  vTime.P_Time.Config.General.ShowBothType_L.Name := 'A_T_P_Time_General_Both_Type_Label';
  vTime.P_Time.Config.General.ShowBothType_L.Parent := vTime.P_Time.Config.General.Panel;
  vTime.P_Time.Config.General.ShowBothType_L.SetBounds(10, 80, 300, 24);
  vTime.P_Time.Config.General.ShowBothType_L.Text := 'Both visible type';
  vTime.P_Time.Config.General.ShowBothType_L.Font.Style := vTime.P_Time.Config.General.ShowBothType_L.Font.Style + [TFontStyle.fsBold];
  vTime.P_Time.Config.General.ShowBothType_L.Visible := False;

  vTime.P_Time.Config.General.ShowBothType := TComboBox.Create(vTime.P_Time.Config.General.Panel);
  vTime.P_Time.Config.General.ShowBothType.Name := 'A_T_P_Time_General_Both_Type';
  vTime.P_Time.Config.General.ShowBothType.Parent := vTime.P_Time.Config.General.Panel;
  vTime.P_Time.Config.General.ShowBothType.SetBounds(10, 100, vTime.P_Time.Config.General.Panel.Width - 20, 24);
  vTime.P_Time.Config.General.ShowBothType.Items.Add('Default');
  vTime.P_Time.Config.General.ShowBothType.Items.Add('Analog Up-Digital Down');
  vTime.P_Time.Config.General.ShowBothType.Items.Add('Analog Down-Digital Up');
  vTime.P_Time.Config.General.ShowBothType.Items.Add('Analog Middle Up-Digital Middle Down');
  vTime.P_Time.Config.General.ShowBothType.Items.Add('Analog Middle Down-Digital Middle Up');
  vTime.P_Time.Config.General.ShowBothType.Items.Add('Analog Boxed Left-Digital Boxed Right');
  vTime.P_Time.Config.General.ShowBothType.Items.Add('Analog Boxed Right-Digital Boxed Left');
  vTime.P_Time.Config.General.ShowBothType.ItemIndex := 0;
  vTime.P_Time.Config.General.ShowBothType.OnChange := addons.time.Input.mouse_time.Combobox.OnChange;
  vTime.P_Time.Config.General.ShowBothType.Visible := False;

  if uDB_AUser.Local.addons.Time_D.time.vType = 'Analog' then
    vTime.P_Time.Config.General.ShowType.ItemIndex := 0
  else if uDB_AUser.Local.addons.Time_D.time.vType = 'Digital' then
    vTime.P_Time.Config.General.ShowType.ItemIndex := 1
  else if uDB_AUser.Local.addons.Time_D.time.vType = 'Both' then
    vTime.P_Time.Config.General.ShowType.ItemIndex := 2
end;

procedure Config_Show_Analog;
begin
  vTime.P_Time.Config.Analog.Panel := TPanel.Create(vTime.P_Time.Config.Tab[1]);
  vTime.P_Time.Config.Analog.Panel.Name := 'A_T_P_Time_Analog';
  vTime.P_Time.Config.Analog.Panel.Parent := vTime.P_Time.Config.Tab[1];
  vTime.P_Time.Config.Analog.Panel.SetBounds(0, 0, vTime.P_Time.Config.Control.Width, vTime.P_Time.Config.Control.Height);
  vTime.P_Time.Config.Analog.Panel.Visible := True;

  vTime.P_Time.Config.Analog.Options := TGroupBox.Create(vTime.P_Time.Config.Analog.Panel);
  vTime.P_Time.Config.Analog.Options.Name := 'A_T_P_Time_Analog_Options';
  vTime.P_Time.Config.Analog.Options.Parent := vTime.P_Time.Config.Analog.Panel;
  vTime.P_Time.Config.Analog.Options.SetBounds(10, 20, vTime.P_Time.Config.Analog.Panel.Width - 20, 140);
  vTime.P_Time.Config.Analog.Options.Text := 'Options';
  vTime.P_Time.Config.Analog.Options.Visible := True;

  vTime.P_Time.Config.Analog.Options_ShowQuarters := TCheckBox.Create(vTime.P_Time.Config.Analog.Options);
  vTime.P_Time.Config.Analog.Options_ShowQuarters.Name := 'A_T_P_Time_Analog_Option_ShowQuarters';
  vTime.P_Time.Config.Analog.Options_ShowQuarters.Parent := vTime.P_Time.Config.Analog.Options;
  vTime.P_Time.Config.Analog.Options_ShowQuarters.SetBounds(10, 30, vTime.P_Time.Config.Analog.Options.Width - 20, 24);
  vTime.P_Time.Config.Analog.Options_ShowQuarters.Text := 'Show quarters images';
  vTime.P_Time.Config.Analog.Options_ShowQuarters.IsChecked := addons.time.P_Time.Analog_Img_Quarters_Show;
  vTime.P_Time.Config.Analog.Options_ShowQuarters.OnClick := addons.time.Input.mouse_time.Checkbox.OnMouseClick;
  vTime.P_Time.Config.Analog.Options_ShowQuarters.Visible := True;

  vTime.P_Time.Config.Analog.Options_ShowHours := TCheckBox.Create(vTime.P_Time.Config.Analog.Options);
  vTime.P_Time.Config.Analog.Options_ShowHours.Name := 'A_T_P_Time_Analog_Option_ShowHours';
  vTime.P_Time.Config.Analog.Options_ShowHours.Parent := vTime.P_Time.Config.Analog.Options;
  vTime.P_Time.Config.Analog.Options_ShowHours.SetBounds(10, 50, vTime.P_Time.Config.Analog.Options.Width - 20, 24);
  vTime.P_Time.Config.Analog.Options_ShowHours.Text := 'Show hour images';
  vTime.P_Time.Config.Analog.Options_ShowHours.IsChecked := addons.time.P_Time.Analog_Img_Hours_Show;
  vTime.P_Time.Config.Analog.Options_ShowHours.OnClick := addons.time.Input.mouse_time.Checkbox.OnMouseClick;
  vTime.P_Time.Config.Analog.Options_ShowHours.Visible := True;

  vTime.P_Time.Config.Analog.Options_ShowMinutes := TCheckBox.Create(vTime.P_Time.Config.Analog.Options);
  vTime.P_Time.Config.Analog.Options_ShowMinutes.Name := 'A_T_P_Time_Analog_Option_ShowMinutes';
  vTime.P_Time.Config.Analog.Options_ShowMinutes.Parent := vTime.P_Time.Config.Analog.Options;
  vTime.P_Time.Config.Analog.Options_ShowMinutes.SetBounds(10, 70, vTime.P_Time.Config.Analog.Options.Width - 20, 24);
  vTime.P_Time.Config.Analog.Options_ShowMinutes.Text := 'Show minutes images';
  vTime.P_Time.Config.Analog.Options_ShowMinutes.IsChecked := addons.time.P_Time.Analog_Img_Minutes_Show;
  vTime.P_Time.Config.Analog.Options_ShowMinutes.Visible := True;

  vTime.P_Time.Config.Analog.Options_ShowSecondsIndicator := TCheckBox.Create(vTime.P_Time.Config.Analog.Options);
  vTime.P_Time.Config.Analog.Options_ShowSecondsIndicator.Name := 'A_T_P_Time_Analog_Option_ShowSecondsIndicator';
  vTime.P_Time.Config.Analog.Options_ShowSecondsIndicator.Parent := vTime.P_Time.Config.Analog.Options;
  vTime.P_Time.Config.Analog.Options_ShowSecondsIndicator.SetBounds(10, 90, vTime.P_Time.Config.Analog.Options.Width - 20, 24);
  vTime.P_Time.Config.Analog.Options_ShowSecondsIndicator.Text := 'Show seconds indicator';
  vTime.P_Time.Config.Analog.Options_ShowSecondsIndicator.IsChecked := addons.time.P_Time.Analog_Seconds_Indicator;
  vTime.P_Time.Config.Analog.Options_ShowSecondsIndicator.OnClick := addons.time.Input.mouse_time.Checkbox.OnMouseClick;
  vTime.P_Time.Config.Analog.Options_ShowSecondsIndicator.Visible := True;

  // vTime.P_Time.Config.Analog.Analog_Full := TILAnalogClock.Create(vTime.P_Time.Config.Analog.Panel);
  // vTime.P_Time.Config.Analog.Analog_Full.Name := 'A_T_P_Time_Analog_Full';
  // vTime.P_Time.Config.Analog.Analog_Full.Parent:=   vTime.P_Time.Config.Analog.Panel;
  // vTime.P_Time.Config.Analog.Analog_Full.SetBounds(100, 100, 100, 100);
  // vTime.P_Time.Config.Analog.Analog_Full.Visible := True;

  vTime.P_Time.Config.Analog.Analog := TGroupBox.Create(vTime.P_Time.Config.Analog.Panel);
  vTime.P_Time.Config.Analog.Analog.Name := 'A_T_P_Time_Analog_Images';
  vTime.P_Time.Config.Analog.Analog.Parent := vTime.P_Time.Config.Analog.Panel;
  vTime.P_Time.Config.Analog.Analog.SetBounds(10, 170, vTime.P_Time.Config.Analog.Panel.Width - 20, 330);
  vTime.P_Time.Config.Analog.Analog.Text := 'Theme';
  vTime.P_Time.Config.Analog.Analog.Visible := True;

  vTime.P_Time.Config.Analog.Circle_Label := TLabel.Create(vTime.P_Time.Config.Analog.Analog);
  vTime.P_Time.Config.Analog.Circle_Label.Name := 'A_T_P_Time_Analog_Images_Circle_Label';
  vTime.P_Time.Config.Analog.Circle_Label.Parent := vTime.P_Time.Config.Analog.Analog;
  vTime.P_Time.Config.Analog.Circle_Label.SetBounds(10, 20, 300, 24);
  vTime.P_Time.Config.Analog.Circle_Label.Text := 'Clock round, background';
  vTime.P_Time.Config.Analog.Circle_Label.Font.Style := vTime.P_Time.Config.Analog.Circle_Label.Font.Style + [TFontStyle.fsBold];
  vTime.P_Time.Config.Analog.Circle_Label.Visible := True;

  vTime.P_Time.Config.Analog.Circle := TEdit.Create(vTime.P_Time.Config.Analog.Analog);
  vTime.P_Time.Config.Analog.Circle.Name := 'A_T_P_Time_Analog_Images_Circle';
  vTime.P_Time.Config.Analog.Circle.Parent := vTime.P_Time.Config.Analog.Analog;
  vTime.P_Time.Config.Analog.Circle.SetBounds(10, 40, vTime.P_Time.Config.Analog.Analog.Width - 60, 24);
  vTime.P_Time.Config.Analog.Circle.Text := addons.time.P_Time.Analog_Circle_Path;
  vTime.P_Time.Config.Analog.Circle.Visible := True;

  vTime.P_Time.Config.Analog.Circle_Search := TButton.Create(vTime.P_Time.Config.Analog.Analog);
  vTime.P_Time.Config.Analog.Circle_Search.Name := 'A_T_P_Time_Analog_Images_Circle_Button';
  vTime.P_Time.Config.Analog.Circle_Search.Parent := vTime.P_Time.Config.Analog.Analog;
  vTime.P_Time.Config.Analog.Circle_Search.SetBounds(vTime.P_Time.Config.Analog.Analog.Width - 40, 40, 30, 24);
  vTime.P_Time.Config.Analog.Circle_Search.Text := '...';
  vTime.P_Time.Config.Analog.Circle_Search.Visible := True;

  vTime.P_Time.Config.Analog.Hour_Label := TLabel.Create(vTime.P_Time.Config.Analog.Analog);
  vTime.P_Time.Config.Analog.Hour_Label.Name := 'A_T_P_Time_Analog_Images_Hour_Label';
  vTime.P_Time.Config.Analog.Hour_Label.Parent := vTime.P_Time.Config.Analog.Analog;
  vTime.P_Time.Config.Analog.Hour_Label.SetBounds(10, 70, 300, 24);
  vTime.P_Time.Config.Analog.Hour_Label.Text := 'Hour indicator';
  vTime.P_Time.Config.Analog.Hour_Label.Font.Style := vTime.P_Time.Config.Analog.Hour_Label.Font.Style + [TFontStyle.fsBold];
  vTime.P_Time.Config.Analog.Hour_Label.Visible := True;

  vTime.P_Time.Config.Analog.Hour := TEdit.Create(vTime.P_Time.Config.Analog.Analog);
  vTime.P_Time.Config.Analog.Hour.Name := 'A_T_P_Time_Analog_Images_Hour';
  vTime.P_Time.Config.Analog.Hour.Parent := vTime.P_Time.Config.Analog.Analog;
  vTime.P_Time.Config.Analog.Hour.SetBounds(10, 90, vTime.P_Time.Config.Analog.Analog.Width - 60, 24);
  vTime.P_Time.Config.Analog.Hour.Text := addons.time.P_Time.Analog_Hour_Indicator_Path;
  vTime.P_Time.Config.Analog.Hour.Visible := True;

  vTime.P_Time.Config.Analog.Hour_Search := TButton.Create(vTime.P_Time.Config.Analog.Analog);
  vTime.P_Time.Config.Analog.Hour_Search.Name := 'A_T_P_Time_Analog_Images_Hour_Button';
  vTime.P_Time.Config.Analog.Hour_Search.Parent := vTime.P_Time.Config.Analog.Analog;
  vTime.P_Time.Config.Analog.Hour_Search.SetBounds(vTime.P_Time.Config.Analog.Analog.Width - 40, 90, 30, 24);
  vTime.P_Time.Config.Analog.Hour_Search.Text := '...';
  vTime.P_Time.Config.Analog.Hour_Search.Visible := True;

  vTime.P_Time.Config.Analog.Minutes_Label := TLabel.Create(vTime.P_Time.Config.Analog.Analog);
  vTime.P_Time.Config.Analog.Minutes_Label.Name := 'A_T_P_Time_Analog_Images_Minutes_Label';
  vTime.P_Time.Config.Analog.Minutes_Label.Parent := vTime.P_Time.Config.Analog.Analog;
  vTime.P_Time.Config.Analog.Minutes_Label.SetBounds(10, 120, 300, 24);
  vTime.P_Time.Config.Analog.Minutes_Label.Text := 'Minutes indicator';
  vTime.P_Time.Config.Analog.Minutes_Label.Font.Style := vTime.P_Time.Config.Analog.Minutes_Label.Font.Style + [TFontStyle.fsBold];
  vTime.P_Time.Config.Analog.Minutes_Label.Visible := True;

  vTime.P_Time.Config.Analog.Minutes := TEdit.Create(vTime.P_Time.Config.Analog.Analog);
  vTime.P_Time.Config.Analog.Minutes.Name := 'A_T_P_Time_Analog_Images_Minutes';
  vTime.P_Time.Config.Analog.Minutes.Parent := vTime.P_Time.Config.Analog.Analog;
  vTime.P_Time.Config.Analog.Minutes.SetBounds(10, 140, vTime.P_Time.Config.Analog.Analog.Width - 60, 24);
  vTime.P_Time.Config.Analog.Minutes.Text := addons.time.P_Time.Analog_Minutes_Indicator_Path;
  vTime.P_Time.Config.Analog.Minutes.Visible := True;

  vTime.P_Time.Config.Analog.Minutes_Search := TButton.Create(vTime.P_Time.Config.Analog.Analog);
  vTime.P_Time.Config.Analog.Minutes_Search.Name := 'A_T_P_Time_Analog_Images_Minutes_Button';
  vTime.P_Time.Config.Analog.Minutes_Search.Parent := vTime.P_Time.Config.Analog.Analog;
  vTime.P_Time.Config.Analog.Minutes_Search.SetBounds(vTime.P_Time.Config.Analog.Analog.Width - 40, 140, 30, 24);
  vTime.P_Time.Config.Analog.Minutes_Search.Text := '...';
  vTime.P_Time.Config.Analog.Minutes_Search.Visible := True;

  vTime.P_Time.Config.Analog.Seconds_Label := TLabel.Create(vTime.P_Time.Config.Analog.Analog);
  vTime.P_Time.Config.Analog.Seconds_Label.Name := 'A_T_P_Time_Analog_Images_Seconds_Label';
  vTime.P_Time.Config.Analog.Seconds_Label.Parent := vTime.P_Time.Config.Analog.Analog;
  vTime.P_Time.Config.Analog.Seconds_Label.SetBounds(10, 170, 300, 24);
  vTime.P_Time.Config.Analog.Seconds_Label.Text := 'Seconds indicator';
  vTime.P_Time.Config.Analog.Seconds_Label.Font.Style := vTime.P_Time.Config.Analog.Seconds_Label.Font.Style + [TFontStyle.fsBold];
  vTime.P_Time.Config.Analog.Seconds_Label.Visible := True;

  vTime.P_Time.Config.Analog.Seconds := TEdit.Create(vTime.P_Time.Config.Analog.Analog);
  vTime.P_Time.Config.Analog.Seconds.Name := 'A_T_P_Time_Analog_Images_Seconds';
  vTime.P_Time.Config.Analog.Seconds.Parent := vTime.P_Time.Config.Analog.Analog;
  vTime.P_Time.Config.Analog.Seconds.SetBounds(10, 190, vTime.P_Time.Config.Analog.Analog.Width - 60, 24);
  vTime.P_Time.Config.Analog.Seconds.Text := addons.time.P_Time.Analog_Seconds_Indicator_Path;
  vTime.P_Time.Config.Analog.Seconds.Visible := True;

  vTime.P_Time.Config.Analog.Seconds_Search := TButton.Create(vTime.P_Time.Config.Analog.Analog);
  vTime.P_Time.Config.Analog.Seconds_Search.Name := 'A_T_P_Time_Analog_Images_Seconds_Button';
  vTime.P_Time.Config.Analog.Seconds_Search.Parent := vTime.P_Time.Config.Analog.Analog;
  vTime.P_Time.Config.Analog.Seconds_Search.SetBounds(vTime.P_Time.Config.Analog.Analog.Width - 40, 190, 30, 24);
  vTime.P_Time.Config.Analog.Seconds_Search.Text := '...';
  vTime.P_Time.Config.Analog.Seconds_Search.Visible := True;

  vTime.P_Time.Config.Analog.Hour_Image_Label := TLabel.Create(vTime.P_Time.Config.Analog.Analog);
  vTime.P_Time.Config.Analog.Hour_Image_Label.Name := 'A_T_P_Time_Analog_Images_Hour_Image_Label';
  vTime.P_Time.Config.Analog.Hour_Image_Label.Parent := vTime.P_Time.Config.Analog.Analog;
  vTime.P_Time.Config.Analog.Hour_Image_Label.SetBounds(10, 220, 300, 24);
  vTime.P_Time.Config.Analog.Hour_Image_Label.Text := 'Hour Image';
  vTime.P_Time.Config.Analog.Hour_Image_Label.Font.Style := vTime.P_Time.Config.Analog.Hour_Image_Label.Font.Style + [TFontStyle.fsBold];
  vTime.P_Time.Config.Analog.Hour_Image_Label.Visible := True;

  vTime.P_Time.Config.Analog.Hour_Image := TEdit.Create(vTime.P_Time.Config.Analog.Analog);
  vTime.P_Time.Config.Analog.Hour_Image.Name := 'A_T_P_Time_Analog_Images_Hour_Image';
  vTime.P_Time.Config.Analog.Hour_Image.Parent := vTime.P_Time.Config.Analog.Analog;
  vTime.P_Time.Config.Analog.Hour_Image.SetBounds(10, 240, vTime.P_Time.Config.Analog.Analog.Width - 60, 24);
  vTime.P_Time.Config.Analog.Hour_Image.Text := addons.time.P_Time.Analog_Hour_Path;
  vTime.P_Time.Config.Analog.Hour_Image.Visible := True;

  vTime.P_Time.Config.Analog.Hour_Image_Search := TButton.Create(vTime.P_Time.Config.Analog.Analog);
  vTime.P_Time.Config.Analog.Hour_Image_Search.Name := 'A_T_P_Time_Analog_Images_Hour_Image_Button';
  vTime.P_Time.Config.Analog.Hour_Image_Search.Parent := vTime.P_Time.Config.Analog.Analog;
  vTime.P_Time.Config.Analog.Hour_Image_Search.SetBounds(vTime.P_Time.Config.Analog.Analog.Width - 40, 240, 30, 24);
  vTime.P_Time.Config.Analog.Hour_Image_Search.Text := '...';
  vTime.P_Time.Config.Analog.Hour_Image_Search.Visible := True;

  vTime.P_Time.Config.Analog.Minutes_Image_Label := TLabel.Create(vTime.P_Time.Config.Analog.Analog);
  vTime.P_Time.Config.Analog.Minutes_Image_Label.Name := 'A_T_P_Time_Analog_Images_Minutes_Image_Label';
  vTime.P_Time.Config.Analog.Minutes_Image_Label.Parent := vTime.P_Time.Config.Analog.Analog;
  vTime.P_Time.Config.Analog.Minutes_Image_Label.SetBounds(10, 270, 300, 24);
  vTime.P_Time.Config.Analog.Minutes_Image_Label.Text := 'Minutes image';
  vTime.P_Time.Config.Analog.Minutes_Image_Label.Font.Style := vTime.P_Time.Config.Analog.Minutes_Image_Label.Font.Style + [TFontStyle.fsBold];
  vTime.P_Time.Config.Analog.Minutes_Image_Label.Visible := True;

  vTime.P_Time.Config.Analog.Minutes_Image := TEdit.Create(vTime.P_Time.Config.Analog.Analog);
  vTime.P_Time.Config.Analog.Minutes_Image.Name := 'A_T_P_Time_Analog_Images_Minutes_Image';
  vTime.P_Time.Config.Analog.Minutes_Image.Parent := vTime.P_Time.Config.Analog.Analog;
  vTime.P_Time.Config.Analog.Minutes_Image.SetBounds(10, 290, vTime.P_Time.Config.Analog.Analog.Width - 60, 24);
  vTime.P_Time.Config.Analog.Minutes_Image.Text := addons.time.P_Time.Analog_Minutes_Path;
  vTime.P_Time.Config.Analog.Minutes_Image.Visible := True;

  vTime.P_Time.Config.Analog.Minutes_Image_Search := TButton.Create(vTime.P_Time.Config.Analog.Analog);
  vTime.P_Time.Config.Analog.Minutes_Image_Search.Name := 'A_T_P_Time_Analog_Images_Minutes_Image_Button';
  vTime.P_Time.Config.Analog.Minutes_Image_Search.Parent := vTime.P_Time.Config.Analog.Analog;
  vTime.P_Time.Config.Analog.Minutes_Image_Search.SetBounds(vTime.P_Time.Config.Analog.Analog.Width - 40, 290, 30, 24);
  vTime.P_Time.Config.Analog.Minutes_Image_Search.Text := '...';
  vTime.P_Time.Config.Analog.Minutes_Image_Search.Visible := True;

  if uDB_AUser.Local.ADDONS.Time_D.Time.vType <> 'Both' then
    if uDB_AUser.Local.ADDONS.Time_D.Time.vType = 'Digital' then
      vTime.P_Time.Config.Analog.Panel.Enabled := False;
end;

procedure Config_Show_Digital;
var
  vFonts: TStringList;
begin
  vTime.P_Time.Config.Digital.Panel := TPanel.Create(vTime.P_Time.Config.Tab[2]);
  vTime.P_Time.Config.Digital.Panel.Name := 'A_T_P_Time_Digital';
  vTime.P_Time.Config.Digital.Panel.Parent := vTime.P_Time.Config.Tab[2];
  vTime.P_Time.Config.Digital.Panel.SetBounds(0, 0, vTime.P_Time.Config.Control.Width, vTime.P_Time.Config.Control.Height);
  vTime.P_Time.Config.Digital.Panel.Visible := True;

  vTime.P_Time.Config.Digital.Font_Label := TLabel.Create(vTime.P_Time.Config.Digital.Panel);
  vTime.P_Time.Config.Digital.Font_Label.Name := 'A_T_P_Time_Digital_Font_Label';
  vTime.P_Time.Config.Digital.Font_Label.Parent := vTime.P_Time.Config.Digital.Panel;
  vTime.P_Time.Config.Digital.Font_Label.SetBounds(10, 20, 300, 24);
  vTime.P_Time.Config.Digital.Font_Label.Text := 'Font name';
  vTime.P_Time.Config.Digital.Font_Label.Font.Style := vTime.P_Time.Config.Digital.Font_Label.Font.Style + [TFontStyle.fsBold];
  vTime.P_Time.Config.Digital.Font_Label.Visible := True;

  vTime.P_Time.Config.Digital.Font_Combo := TComboBox.Create(vTime.P_Time.Config.Digital.Panel);
  vTime.P_Time.Config.Digital.Font_Combo.Name := 'A_T_P_Time_Digital_Font';
  vTime.P_Time.Config.Digital.Font_Combo.Parent := vTime.P_Time.Config.Digital.Panel;
  vTime.P_Time.Config.Digital.Font_Combo.SetBounds(10, 40, vTime.P_Time.Config.Digital.Panel.Width - 20, 24);
  vTime.P_Time.Config.Digital.Font_Combo.Items.Add('Choose a font...');
  vTime.P_Time.Config.Digital.Font_Combo.ItemIndex := 0;
  vTime.P_Time.Config.Digital.Font_Combo.Visible := True;

  vFonts := TStringList.Create;
  uWindows.Fonts_Get(vFonts);
  vTime.P_Time.Config.Digital.Font_Combo.Items := vFonts;
  vTime.P_Time.Config.Digital.Font_Combo.ItemIndex := vTime.P_Time.Config.Digital.Font_Combo.Items.IndexOf(uDB_AUser.Local.addons.Time_D.time.Digital_Font);

  vTime.P_Time.Config.Digital.Color_Label := TLabel.Create(vTime.P_Time.Config.Digital.Panel);
  vTime.P_Time.Config.Digital.Color_Label.Name := 'A_T_P_Time_Digital_Color_Label';
  vTime.P_Time.Config.Digital.Color_Label.Parent := vTime.P_Time.Config.Digital.Panel;
  vTime.P_Time.Config.Digital.Color_Label.SetBounds(10, 70, 300, 24);
  vTime.P_Time.Config.Digital.Color_Label.Text := 'Font color';
  vTime.P_Time.Config.Digital.Color_Label.Font.Style := vTime.P_Time.Config.Digital.Color_Label.Font.Style + [TFontStyle.fsBold];
  vTime.P_Time.Config.Digital.Color_Label.Visible := True;

  vTime.P_Time.Config.Digital.Color_Combo := TColorComboBox.Create(vTime.P_Time.Config.Digital.Panel);
  vTime.P_Time.Config.Digital.Color_Combo.Name := 'A_T_P_Time_Digital_Color';
  vTime.P_Time.Config.Digital.Color_Combo.Parent := vTime.P_Time.Config.Digital.Panel;
  vTime.P_Time.Config.Digital.Color_Combo.SetBounds(10, 90, vTime.P_Time.Config.Digital.Panel.Width - 20, 24);
  vTime.P_Time.Config.Digital.Color_Combo.Color := TAlphaColor(StringToColor(uDB_AUser.Local.addons.Time_D.time.Digital_Font_Color));
  vTime.P_Time.Config.Digital.Color_Combo.OnChange := addons.time.Input.mouse_time.ColorCombobox.OnChange;
  vTime.P_Time.Config.Digital.Color_Combo.Visible := True;

  vTime.P_Time.Config.Digital.Sep_Label := TLabel.Create(vTime.P_Time.Config.Digital.Panel);
  vTime.P_Time.Config.Digital.Sep_Label.Name := 'A_T_P_Time_Digital_Sep_Label';
  vTime.P_Time.Config.Digital.Sep_Label.Parent := vTime.P_Time.Config.Digital.Panel;
  vTime.P_Time.Config.Digital.Sep_Label.SetBounds(10, 120, 300, 24);
  vTime.P_Time.Config.Digital.Sep_Label.Text := 'Seperation symbol';
  vTime.P_Time.Config.Digital.Sep_Label.Font.Style := vTime.P_Time.Config.Digital.Color_Label.Font.Style + [TFontStyle.fsBold];
  vTime.P_Time.Config.Digital.Sep_Label.Visible := True;

  vTime.P_Time.Config.Digital.Sep_Combo := TComboBox.Create(vTime.P_Time.Config.Digital.Panel);
  vTime.P_Time.Config.Digital.Sep_Combo.Name := 'A_T_P_Time_Digital_Sep_Symbol';
  vTime.P_Time.Config.Digital.Sep_Combo.Parent := vTime.P_Time.Config.Digital.Panel;
  vTime.P_Time.Config.Digital.Sep_Combo.SetBounds(10, 140, vTime.P_Time.Config.Digital.Panel.Width - 20, 24);
  vTime.P_Time.Config.Digital.Sep_Combo.Items.Add(':');
  vTime.P_Time.Config.Digital.Sep_Combo.Items.Add('/');
  vTime.P_Time.Config.Digital.Sep_Combo.Items.Add('\');
  vTime.P_Time.Config.Digital.Sep_Combo.Items.Add('.');
  vTime.P_Time.Config.Digital.Sep_Combo.Items.Add('#');
  vTime.P_Time.Config.Digital.Sep_Combo.ItemIndex := vTime.P_Time.Config.Digital.Sep_Combo.Items.IndexOf(uDB_AUser.Local.addons.Time_D.time.Digital_Sep);
  vTime.P_Time.Config.Digital.Sep_Combo.OnChange := addons.time.Input.mouse_time.Combobox.OnChange;
  vTime.P_Time.Config.Digital.Sep_Combo.Visible := True;

  vTime.P_Time.Config.Digital.Color_Back_Label := TLabel.Create(vTime.P_Time.Config.Digital.Panel);
  vTime.P_Time.Config.Digital.Color_Back_Label.Name := 'A_T_P_Time_Digital_Color_Back_Label';
  vTime.P_Time.Config.Digital.Color_Back_Label.Parent := vTime.P_Time.Config.Digital.Panel;
  vTime.P_Time.Config.Digital.Color_Back_Label.SetBounds(10, 170, 300, 24);
  vTime.P_Time.Config.Digital.Color_Back_Label.Text := 'Background color';
  vTime.P_Time.Config.Digital.Color_Back_Label.Font.Style := vTime.P_Time.Config.Digital.Color_Back_Label.Font.Style + [TFontStyle.fsBold];
  vTime.P_Time.Config.Digital.Color_Back_Label.Visible := True;

  vTime.P_Time.Config.Digital.Color_Back_Combo := TColorComboBox.Create(vTime.P_Time.Config.Digital.Panel);
  vTime.P_Time.Config.Digital.Color_Back_Combo.Name := 'A_T_P_Time_Digital_Color_Back';
  vTime.P_Time.Config.Digital.Color_Back_Combo.Parent := vTime.P_Time.Config.Digital.Panel;
  vTime.P_Time.Config.Digital.Color_Back_Combo.SetBounds(10, 190, vTime.P_Time.Config.Digital.Panel.Width - 20, 24);
  vTime.P_Time.Config.Digital.Color_Back_Combo.Color := TAlphaColor(StringToColor(uDB_AUser.Local.addons.Time_D.time.Digital_Color));
  vTime.P_Time.Config.Digital.Color_Back_Combo.OnChange := addons.time.Input.mouse_time.ColorCombobox.OnChange;
  vTime.P_Time.Config.Digital.Color_Back_Combo.Visible := True;

  vTime.P_Time.Config.Digital.Color_Back_Stroke_Label := TLabel.Create(vTime.P_Time.Config.Digital.Panel);
  vTime.P_Time.Config.Digital.Color_Back_Stroke_Label.Name := 'A_T_P_Time_Digital_Color_Back_Stroke_Label';
  vTime.P_Time.Config.Digital.Color_Back_Stroke_Label.Parent := vTime.P_Time.Config.Digital.Panel;
  vTime.P_Time.Config.Digital.Color_Back_Stroke_Label.SetBounds(10, 220, 300, 24);
  vTime.P_Time.Config.Digital.Color_Back_Stroke_Label.Text := 'Background stroke color';
  vTime.P_Time.Config.Digital.Color_Back_Stroke_Label.Font.Style := vTime.P_Time.Config.Digital.Color_Back_Stroke_Label.Font.Style + [TFontStyle.fsBold];
  vTime.P_Time.Config.Digital.Color_Back_Stroke_Label.Visible := True;

  vTime.P_Time.Config.Digital.Color_Back_Stroke_Combo := TColorComboBox.Create(vTime.P_Time.Config.Digital.Panel);
  vTime.P_Time.Config.Digital.Color_Back_Stroke_Combo.Name := 'A_T_P_Time_Digital_Color_Stroke_Back';
  vTime.P_Time.Config.Digital.Color_Back_Stroke_Combo.Parent := vTime.P_Time.Config.Digital.Panel;
  vTime.P_Time.Config.Digital.Color_Back_Stroke_Combo.SetBounds(10, 240, vTime.P_Time.Config.Digital.Panel.Width - 20, 24);
  vTime.P_Time.Config.Digital.Color_Back_Stroke_Combo.Color := TAlphaColor(StringToColor(uDB_AUser.Local.addons.Time_D.time.Digital_Color));
  vTime.P_Time.Config.Digital.Color_Back_Stroke_Combo.OnChange := addons.time.Input.mouse_time.ColorCombobox.OnChange;
  vTime.P_Time.Config.Digital.Color_Back_Stroke_Combo.Visible := True;

  vTime.P_Time.Config.Digital.Image_Label := TLabel.Create(vTime.P_Time.Config.Digital.Panel);
  vTime.P_Time.Config.Digital.Image_Label.Name := 'A_T_P_Time_Digital_Image_Label';
  vTime.P_Time.Config.Digital.Image_Label.Parent := vTime.P_Time.Config.Digital.Panel;
  vTime.P_Time.Config.Digital.Image_Label.SetBounds(10, 280, 300, 24);
  vTime.P_Time.Config.Digital.Image_Label.Text := 'Digits image path';
  vTime.P_Time.Config.Digital.Image_Label.Font.Style := vTime.P_Time.Config.Digital.Image_Label.Font.Style + [TFontStyle.fsBold];
  vTime.P_Time.Config.Digital.Image_Label.Visible := True;

  vTime.P_Time.Config.Digital.Image := TEdit.Create(vTime.P_Time.Config.Digital.Panel);
  vTime.P_Time.Config.Digital.Image.Name := 'A_T_P_Time_Digital_Image';
  vTime.P_Time.Config.Digital.Image.Parent := vTime.P_Time.Config.Digital.Panel;
  vTime.P_Time.Config.Digital.Image.SetBounds(10, 300, vTime.P_Time.Config.Control.Width - 60, 24);
  vTime.P_Time.Config.Digital.Image.Text := addons.time.P_Time.Digital_Img_Folder;
  vTime.P_Time.Config.Digital.Image.Visible := True;

  vTime.P_Time.Config.Digital.Image_Search := TButton.Create(vTime.P_Time.Config.Digital.Panel);
  vTime.P_Time.Config.Digital.Image_Search.Name := 'A_T_P_Time_Digital_Image_Button';
  vTime.P_Time.Config.Digital.Image_Search.Parent := vTime.P_Time.Config.Digital.Panel;
  vTime.P_Time.Config.Digital.Image_Search.SetBounds(vTime.P_Time.Config.Control.Width - 40, 300, 30, 24);
  vTime.P_Time.Config.Digital.Image_Search.Text := '...';
  vTime.P_Time.Config.Digital.Image_Search.Visible := True;

  vTime.P_Time.Config.Digital.Matrix_Label := TLabel.Create(vTime.P_Time.Config.Digital.Panel);
  vTime.P_Time.Config.Digital.Matrix_Label.Name := 'A_T_P_Time_Digital_Matrix_Label';
  vTime.P_Time.Config.Digital.Matrix_Label.Parent := vTime.P_Time.Config.Digital.Panel;
  vTime.P_Time.Config.Digital.Matrix_Label.SetBounds(10, 340, 300, 24);
  vTime.P_Time.Config.Digital.Matrix_Label.Text := 'Matrix background';
  vTime.P_Time.Config.Digital.Matrix_Label.Font.Style := vTime.P_Time.Config.Digital.Matrix_Label.Font.Style + [TFontStyle.fsBold];
  vTime.P_Time.Config.Digital.Matrix_Label.Visible := True;

  vTime.P_Time.Config.Digital.Matrix := TEdit.Create(vTime.P_Time.Config.Digital.Panel);
  vTime.P_Time.Config.Digital.Matrix.Name := 'A_T_P_Time_Digital_Matrix';
  vTime.P_Time.Config.Digital.Matrix.Parent := vTime.P_Time.Config.Digital.Panel;
  vTime.P_Time.Config.Digital.Matrix.SetBounds(10, 360, vTime.P_Time.Config.Control.Width - 60, 24);
  vTime.P_Time.Config.Digital.Matrix.Text := addons.time.P_Time.Digital_Matrix;
  vTime.P_Time.Config.Digital.Matrix.Visible := True;

  vTime.P_Time.Config.Digital.Matrix_Search := TButton.Create(vTime.P_Time.Config.Digital.Panel);
  vTime.P_Time.Config.Digital.Matrix_Search.Name := 'A_T_P_Time_Digital_Matrix_Button';
  vTime.P_Time.Config.Digital.Matrix_Search.Parent := vTime.P_Time.Config.Digital.Panel;
  vTime.P_Time.Config.Digital.Matrix_Search.SetBounds(vTime.P_Time.Config.Digital.Panel.Width - 40, 360, 30, 24);
  vTime.P_Time.Config.Digital.Matrix_Search.Text := '...';
  vTime.P_Time.Config.Digital.Matrix_Search.Visible := True;

  vTime.P_Time.Config.Digital.Font_Combo.OnChange := addons.time.Input.mouse_time.Combobox.OnChange;
  vTime.P_Time.Digital.Rect.Fill.Color := vTime.P_Time.Config.Digital.Color_Back_Combo.Color;
  vTime.P_Time.Digital.Hour.TextSettings.FontColor := vTime.P_Time.Config.Digital.Color_Combo.Color;
  vTime.P_Time.Digital.Minutes.TextSettings.FontColor := vTime.P_Time.Config.Digital.Color_Combo.Color;
  vTime.P_Time.Digital.Seconds.TextSettings.FontColor := vTime.P_Time.Config.Digital.Color_Combo.Color;
  vTime.P_Time.Digital.Rect.Stroke.Color := vTime.P_Time.Config.Digital.Color_Back_Stroke_Combo.Color;

  if uDB_AUser.Local.ADDONS.Time_D.Time.vType <> 'Both' then
    if uDB_AUser.Local.ADDONS.Time_D.Time.vType = 'Analog' then
      vTime.P_Time.Config.Digital.Panel.Enabled := False;
end;

procedure Free;
begin
  if Assigned(vTime.P_Time.Config.General.Panel) then
    FreeAndNil(vTime.P_Time.Config.General.Panel);
  if Assigned(vTime.P_Time.Config.Analog.Panel) then
    FreeAndNil(vTime.P_Time.Config.Analog.Panel);
  if Assigned(vTime.P_Time.Config.Digital.Panel) then
    FreeAndNil(vTime.P_Time.Config.Digital.Panel);
  if Assigned(vTime.P_Time.Config.Panel) then
    FreeAndNil(vTime.P_Time.Config.Panel);
  FreeAndNil(vTime.P_Time.Timer);
  FreeAndNil(vTime.P_Time.Back);
end;

end.
