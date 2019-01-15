unit uTime_SetAll;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UITypes,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Ani,
  FMX.Types,
  FMX.Effects,
  FMX.Graphics,
  FMX.TabControl,
  FMX.Edit,
  FMX.Listbox,
  FMX.Colors,
  Radiant.Shapes,
  uLoad_AllTypes;



procedure uTime_SetAll_Set;

procedure uTime_FreeTimePanel;


implementation

uses
  uWindows,
  uSnippets_Colors,
  uMain_SetAll,
  uMain_AllTypes,
  uTime_AllTypes,
  uTime_Mouse,
  uTime_Actions;

procedure uTime_SetAll_Set;
const
  cIcon_Name: array [0 .. 4] of string = ('t_clock.png', 't_alarm.png', 't_timer.png', 't_stopwatch.png',
    't_worldclock.png');
  cIcon_Text: array [0 .. 4] of string = ('Clock', 'Alarm', 'Timer', 'Stop watch', 'World Clock');
var
  vi: Integer;
begin
  vTime.Time := Timage.Create(mainScene.Main.Down_Level);
  vTime.Time.Name := 'A_Time';
  vTime.Time.Parent := mainScene.Main.Down_Level;
  vTime.Time.Width := extrafe.res.Width;
  vTime.Time.Height := extrafe.res.Height - 130;
  vTime.Time.Position.X := 0;
  vTime.Time.Position.Y := 130;
  vTime.Time.Bitmap.LoadFromFile(addons.Time.Path.Images + 't_back.png');
  vTime.Time.WrapMode := TImageWrapMode.Tile;
  vTime.Time.Visible := True;

  vTime.Time_Ani := TFloatAnimation.Create(vTime.Time);
  vTime.Time_Ani.Name := 'A_Time_Animation';
  vTime.Time_Ani.Parent := vTime.Time;
  vTime.Time_Ani.AnimationType := TAnimationType.&In;
  vTime.Time_Ani.Duration := 0.4;
  vTime.Time_Ani.PropertyName := 'Opacity';
  vTime.Time_Ani.StartValue := 1;
  vTime.Time_Ani.StopValue := 0;
  vTime.Time_Ani.Enabled := False;

  vTime.Back := Timage.Create(vTime.Time);
  vTime.Back.Name := 'A_T_Back_Image';
  vTime.Back.Parent := vTime.Time;
  vTime.Back.Width := vTime.Time.Width;
  vTime.Back.Height := vTime.Time.Height;
  vTime.Back.Position.X := 0;
  vTime.Back.Position.Y := 0;
  vTime.Back.Bitmap.LoadFromFile(addons.Time.Path.Images + 't_back.png');
  vTime.Back.WrapMode := TImageWrapMode.Tile;
  vTime.Back.Visible := True;

  vTime.UpLine := Timage.Create(vTime.Back);
  vTime.UpLine.Name := 'A_T_UpLine_Image';
  vTime.UpLine.Parent := vTime.Back;
  vTime.UpLine.Width := vTime.Back.Width;
  vTime.UpLine.Height := 10;
  vTime.UpLine.Position.X := 0;
  vTime.UpLine.Position.Y := 0;
  vTime.UpLine.Bitmap.LoadFromFile(addons.Time.Path.Images + 't_spot.png');
  vTime.UpLine.WrapMode := TImageWrapMode.Tile;
  vTime.UpLine.Visible := True;

  for vi := 0 to 4 do
  begin
    vTime.Tab[vi].Back := Timage.Create(vTime.Back);
    vTime.Tab[vi].Back.Name := 'A_T_Tab_' + IntToStr(vi);
    vTime.Tab[vi].Back.Parent := vTime.Back;
    vTime.Tab[vi].Back.Width := vTime.Back.Width / 5;
    vTime.Tab[vi].Back.Height := 100;
    vTime.Tab[vi].Back.Position.X := (vTime.Back.Width / 5) * vi;
    vTime.Tab[vi].Back.Position.Y := 10;
    vTime.Tab[vi].Back.Bitmap.LoadFromFile(addons.Time.Path.Images + 't_back.png');
    vTime.Tab[vi].Back.WrapMode := TImageWrapMode.Tile;
    vTime.Tab[vi].Back.OnClick :=  addons.time.Input.mouse.Image.OnMouseClick;
    vTime.Tab[vi].Back.OnMouseEnter := addons.time.Input.mouse.Image.OnMouseEnter;
    vTime.Tab[vi].Back.OnMouseLeave := addons.time.Input.mouse.Image.OnMouseLeave;
    vTime.Tab[vi].Back.Tag := vi;
    vTime.Tab[vi].Back.Visible := True;

    vTime.Tab[vi].Back_Glow := TInnerGlowEffect.Create(vTime.Tab[vi].Back);
    vTime.Tab[vi].Back_Glow.Name := 'A_T_Tab_Glow_' + IntToStr(vi);
    vTime.Tab[vi].Back_Glow.Parent := vTime.Tab[vi].Back;
    vTime.Tab[vi].Back_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
    vTime.Tab[vi].Back_Glow.Softness := 1;
    vTime.Tab[vi].Back_Glow.Opacity := 1;
    vTime.Tab[vi].Back_Glow.Enabled := False;

    vTime.Tab[vi].Icon := Timage.Create(vTime.Tab[vi].Back);
    vTime.Tab[vi].Icon.Name := 'A_T_Tab_Icon_' + IntToStr(vi);
    vTime.Tab[vi].Icon.Parent := vTime.Tab[vi].Back;
    vTime.Tab[vi].Icon.Width := 64;
    vTime.Tab[vi].Icon.Height := 64;
    vTime.Tab[vi].Icon.Position.X := (vTime.Tab[vi].Back.Width / 2) - 32;
    vTime.Tab[vi].Icon.Position.Y := (vTime.Tab[vi].Back.Height / 2) - 38;
    vTime.Tab[vi].Icon.Bitmap.LoadFromFile(addons.Time.Path.Images + cIcon_Name[vi]);
    vTime.Tab[vi].Icon.WrapMode := TImageWrapMode.Fit;
    vTime.Tab[vi].Icon.OnClick := addons.time.Input.mouse.Image.OnMouseClick;
    vTime.Tab[vi].Icon.OnMouseEnter := addons.time.Input.mouse.Image.OnMouseEnter;
    vTime.Tab[vi].Icon.OnMouseLeave := addons.time.Input.mouse.Image.OnMouseLeave;
    vTime.Tab[vi].Icon.Tag := vi;
    vTime.Tab[vi].Icon.Visible := True;

    vTime.Tab[vi].Text := TText.Create(vTime.Tab[vi].Back);
    vTime.Tab[vi].Text.Name := 'A_T_Tab_Label_' + IntToStr(vi);
    vTime.Tab[vi].Text.Parent := vTime.Tab[vi].Back;
    vTime.Tab[vi].Text.Width := vTime.Tab[vi].Back.Width;
    vTime.Tab[vi].Text.Height := 22;
    vTime.Tab[vi].Text.Position.X := 0;
    vTime.Tab[vi].Text.Position.Y := vTime.Tab[vi].Back.Height - 22;
    vTime.Tab[vi].Text.Text := cIcon_Text[vi];
    vTime.Tab[vi].Text.Font.Family := 'Tahoma';
    vTime.Tab[vi].Text.Font.Size := 20;
    vTime.Tab[vi].Text.Color := TAlphaColorRec.White;
    vTime.Tab[vi].Text.Font.Style := vTime.Tab[vi].Text.Font.Style + [TFontStyle.fsBold];
    vTime.Tab[vi].Text.TextSettings.HorzAlign := TTextAlign.Center;
    vTime.Tab[vi].Text.OnClick := addons.time.Input.mouse.Text.OnMouseClick;
    vTime.Tab[vi].Text.OnMouseEnter := addons.time.Input.mouse.Text.OnMouseEnter;
    vTime.Tab[vi].Text.OnMouseLeave := addons.time.Input.mouse.Text.OnMouseLeave;
    vTime.Tab[vi].Text.Tag := vi;
    vTime.Tab[vi].Text.Visible := True;
  end;

  vTime.MiddleLine := Timage.Create(vTime.Back);
  vTime.MiddleLine.Name := 'A_T_MiddleLine_Image';
  vTime.MiddleLine.Parent := vTime.Back;
  vTime.MiddleLine.Width := vTime.Back.Width;
  vTime.MiddleLine.Height := 10;
  vTime.MiddleLine.Position.X := 0;
  vTime.MiddleLine.Position.Y := 110;
  vTime.MiddleLine.Bitmap.LoadFromFile(addons.Time.Path.Images + 't_spot.png');
  vTime.MiddleLine.WrapMode := TImageWrapMode.Tile;
  vTime.MiddleLine.Visible := True;

  vTime.DownLine := Timage.Create(vTime.Back);
  vTime.DownLine.Name := 'A_T_DownLine_Image';
  vTime.DownLine.Parent := vTime.Back;
  vTime.DownLine.Width := vTime.Back.Width;
  vTime.DownLine.Height := 10;
  vTime.DownLine.Position.X := 0;
  vTime.DownLine.Position.Y := vTime.Back.Height - 10;
  vTime.DownLine.Bitmap.LoadFromFile(addons.Time.Path.Images + 't_spot.png');
  vTime.DownLine.WrapMode := TImageWrapMode.Tile;
  vTime.DownLine.Visible := True;

  vTime.Tab_Selected := -1;

end;

procedure uTime_SetTimePanel;
begin

end;

procedure uTime_FreeTimePanel;
begin

end;

end.
