unit uMain_Config_General_Joystick;

interface

uses
  System.Classes,
  System.UITypes,
  FMX.StdCtrls,
  FMX.Listbox,
  FMX.Objects,
  FMX.Graphics,
  DirectInput;

procedure Load;

var
  vSelect_List: array [0 .. 1] of TListBoxItem;
  vI: TDIDeviceObjectInstanceA;

implementation

uses
  uLoad_AllTypes,
  uMain_AllTypes;

procedure Load;
var
  vJoystick_Num: Integer;
begin
  mainScene.Config.Main.R.General.Joystick.Image := TImage.Create(mainScene.Config.Main.R.General.Tab_Item[4]);
  mainScene.Config.Main.R.General.Joystick.Image.Name := 'Main_Config_General_Joystick_Image';
  mainScene.Config.Main.R.General.Joystick.Image.Parent := mainScene.Config.Main.R.General.Tab_Item[4];
  mainScene.Config.Main.R.General.Joystick.Image.Bitmap.LoadFromFile(ex_main.Paths.Config_Images + 'general\joystick.png');
  mainScene.Config.Main.R.General.Joystick.Image.SetBounds(mainScene.Config.Main.R.General.Contol.Width - 76, 6, 56, 56);
  mainScene.Config.Main.R.General.Joystick.Image.WrapMode := TImageWrapMode.Stretch;
  mainScene.Config.Main.R.General.Joystick.Image.Visible := True;

  mainScene.Config.Main.R.General.Joystick.Panel := TPanel.Create(mainScene.Config.Main.R.General.Tab_Item[4]);
  mainScene.Config.Main.R.General.Joystick.Panel.Name := 'Main_Config_General_Joystick_Panel';
  mainScene.Config.Main.R.General.Joystick.Panel.Parent := mainScene.Config.Main.R.General.Tab_Item[4];
  mainScene.Config.Main.R.General.Joystick.Panel.SetBounds(10, 66, mainScene.Config.Main.R.General.Contol.Width - 20,
    mainScene.Config.Main.R.General.Contol.Height - 100);
  mainScene.Config.Main.R.General.Joystick.Panel.Visible := True;

  mainScene.Config.Main.R.General.Joystick.Place := TRectangle.Create(mainScene.Config.Main.R.General.Joystick.Panel);
  mainScene.Config.Main.R.General.Joystick.Place.Name := 'Main_Config_General_Joystick_Place';
  mainScene.Config.Main.R.General.Joystick.Place.Parent := mainScene.Config.Main.R.General.Joystick.Panel;
  mainScene.Config.Main.R.General.Joystick.Place.SetBounds(20, 20, 140, 140);
  mainScene.Config.Main.R.General.Joystick.Place.Fill.Kind := TBrushKind.Solid;
  mainScene.Config.Main.R.General.Joystick.Place.Fill.Color := TAlphaColorRec.Deepskyblue;
  mainScene.Config.Main.R.General.Joystick.Place.Stroke.Thickness := 1;
  mainScene.Config.Main.R.General.Joystick.Place.Visible := True;

  mainScene.Config.Main.R.General.Joystick.Place_Circle := TCircle.Create(mainScene.Config.Main.R.General.Joystick.Place);
  mainScene.Config.Main.R.General.Joystick.Place_Circle.Name := 'Main_Config_General_Joystick_Circle';
  mainScene.Config.Main.R.General.Joystick.Place_Circle.Parent := mainScene.Config.Main.R.General.Joystick.Place;
  mainScene.Config.Main.R.General.Joystick.Place_Circle.SetBounds(0, 0, 140, 140);
  mainScene.Config.Main.R.General.Joystick.Place_Circle.Fill.Kind := TBrushKind.Solid;
  mainScene.Config.Main.R.General.Joystick.Place_Circle.Fill.Color := TAlphaColorRec.Deepskyblue;
  mainScene.Config.Main.R.General.Joystick.Place_Circle.Stroke.Color := TAlphaColorRec.Black;
  mainScene.Config.Main.R.General.Joystick.Place_Circle.Visible := True;

  mainScene.Config.Main.R.General.Joystick.Place_dot := TCircle.Create(mainScene.Config.Main.R.General.Joystick.Place);
  mainScene.Config.Main.R.General.Joystick.Place_dot.Name := 'Main_Config_General_Joystick_Dot';
  mainScene.Config.Main.R.General.Joystick.Place_dot.Parent := mainScene.Config.Main.R.General.Joystick.Place;
  mainScene.Config.Main.R.General.Joystick.Place_dot.SetBounds(62, 62, 16, 16);
  mainScene.Config.Main.R.General.Joystick.Place_dot.Fill.Kind := TBrushKind.Solid;
  mainScene.Config.Main.R.General.Joystick.Place_dot.Fill.Color := TAlphaColorRec.Red;
  mainScene.Config.Main.R.General.Joystick.Place_dot.Stroke.Thickness := 1;
  mainScene.Config.Main.R.General.Joystick.Place_dot.Visible := True;

end;

end.
