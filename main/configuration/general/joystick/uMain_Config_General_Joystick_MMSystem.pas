unit uMain_Config_General_Joystick_MMSystem;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UITypes,
  System.StrUtils,
  FMX.StdCtrls,
  FMX.TabControl,
  FMX.Types,
  FMX.ListBox,
  FMX.Objects,
  FMX.Layouts,
  FMX.Graphics,
  uJoystick_MMSystem,
  uJoystick_mms;

procedure Create_MMSystem;

procedure Create_MMSystem_General;
procedure Create_MMSystem_Emulators;

procedure Refresh_MMSystem_Joy(vType: Integer);

procedure Activate_Field(vActive: Boolean);
procedure Select_Joy(vNum: Integer);
function Check_If_Joy_In_Database(vMan, vPro, vName, vReg, vOEM: String): Boolean;

procedure Wait_To_Set_Key_Action(vKey_Action, vKey_Tag_Action: String);

var
  vSelect_List: array [0 .. 1] of TListBoxItem;
  vJoy_List: array [0 .. 2] of TListBoxItem;

implementation

uses
  uDB,
  uDB_AUser,
  main,
  uLoad_AllTypes,
  uMain_AllTypes,
  uMain_Config_General_Joystick;

procedure Create_MMSystem;
const
  cMMSystem_Item_Names: array [0 .. 1] of string = ('General', 'Emualtors');
var
  vI: Integer;
begin
  mainScene.Config.main.R.General.Joystick.Generic.Joy := TComboBox.Create(mainScene.Config.main.R.General.Joystick.Items[0]);
  mainScene.Config.main.R.General.Joystick.Generic.Joy.Name := 'Main_Config_General_Joystick_MMSystem_Joy';
  mainScene.Config.main.R.General.Joystick.Generic.Joy.Parent := mainScene.Config.main.R.General.Joystick.Items[0];
  mainScene.Config.main.R.General.Joystick.Generic.Joy.SetBounds(mainScene.Config.main.R.General.Joystick.Control.Width - 260, 20, 250, 25);
  mainScene.Config.main.R.General.Joystick.Generic.Joy.OnChange := ex_main.Input.mouse_config.ComboBox.OnChange;
  mainScene.Config.main.R.General.Joystick.Generic.Joy.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.Control := TTabControl.Create(mainScene.Config.main.R.General.Joystick.Items[0]);
  mainScene.Config.main.R.General.Joystick.Generic.Control.Name := 'Main_Config_General_Joystick_Generic_Control';
  mainScene.Config.main.R.General.Joystick.Generic.Control.Parent := mainScene.Config.main.R.General.Joystick.Items[0];
  mainScene.Config.main.R.General.Joystick.Generic.Control.SetBounds(0, 50, mainScene.Config.main.R.General.Joystick.Control.Width,
    mainScene.Config.main.R.General.Joystick.Control.Height - 50);
  mainScene.Config.main.R.General.Joystick.Generic.Control.Visible := True;

  for vI := 0 to 1 do
  begin
    mainScene.Config.main.R.General.Joystick.Generic.Items[vI] := TTabItem.Create(mainScene.Config.main.R.General.Joystick.Generic.Control);
    mainScene.Config.main.R.General.Joystick.Generic.Items[vI].Name := 'Main_Config_General_Joystick_Generic_Item_' + vI.ToString;
    mainScene.Config.main.R.General.Joystick.Generic.Items[vI].Parent := mainScene.Config.main.R.General.Joystick.Generic.Control;
    mainScene.Config.main.R.General.Joystick.Generic.Items[vI].Text := cMMSystem_Item_Names[vI];
    mainScene.Config.main.R.General.Joystick.Generic.Items[vI].OnClick := ex_main.Input.mouse_config.TabItem.OnMouseClick;
    mainScene.Config.main.R.General.Joystick.Generic.Items[vI].Visible := True;
  end;

  Create_MMSystem_General;
  Create_MMSystem_Emulators;
  Refresh_MMSystem_Joy(0);
end;

procedure Create_MMSystem_General;
var
  vI, vk, vr: Integer;
begin
  mainScene.Config.main.R.General.Joystick.Generic.General.Layout := TLayout.Create(mainScene.Config.main.R.General.Joystick.Generic.Items[0]);
  mainScene.Config.main.R.General.Joystick.Generic.General.Layout.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Layout';
  mainScene.Config.main.R.General.Joystick.Generic.General.Layout.Parent := mainScene.Config.main.R.General.Joystick.Generic.Items[0];
  mainScene.Config.main.R.General.Joystick.Generic.General.Layout.Align := TAlignLayout.Client;
  mainScene.Config.main.R.General.Joystick.Generic.General.Layout.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.General.Place := TRectangle.Create(mainScene.Config.main.R.General.Joystick.Generic.General.Layout);
  mainScene.Config.main.R.General.Joystick.Generic.General.Place.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Place';
  mainScene.Config.main.R.General.Joystick.Generic.General.Place.Parent := mainScene.Config.main.R.General.Joystick.Generic.General.Layout;
  mainScene.Config.main.R.General.Joystick.Generic.General.Place.SetBounds(40, 40, 140, 140);
  mainScene.Config.main.R.General.Joystick.Generic.General.Place.Fill.Kind := TBrushKind.Solid;
  mainScene.Config.main.R.General.Joystick.Generic.General.Place.Fill.Color := TAlphaColorRec.Grey;
  mainScene.Config.main.R.General.Joystick.Generic.General.Place.Stroke.Thickness := 1;
  mainScene.Config.main.R.General.Joystick.Generic.General.Place.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.General.Top := TRectangle.Create(mainScene.Config.main.R.General.Joystick.Generic.General.Layout);
  mainScene.Config.main.R.General.Joystick.Generic.General.Top.Name := 'Main_Config_General_Joystick_MMSystem_Generic_UP';
  mainScene.Config.main.R.General.Joystick.Generic.General.Top.Parent := mainScene.Config.main.R.General.Joystick.Generic.General.Layout;
  mainScene.Config.main.R.General.Joystick.Generic.General.Top.SetBounds(40, 20, 140, 18);
  mainScene.Config.main.R.General.Joystick.Generic.General.Top.Fill.Kind := TBrushKind.Solid;
  mainScene.Config.main.R.General.Joystick.Generic.General.Top.Fill.Color := TAlphaColorRec.Grey;
  mainScene.Config.main.R.General.Joystick.Generic.General.Top.Stroke.Thickness := 1;
  mainScene.Config.main.R.General.Joystick.Generic.General.Top.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.General.Top_Name := TText.Create(mainScene.Config.main.R.General.Joystick.Generic.General.Top);
  mainScene.Config.main.R.General.Joystick.Generic.General.Top_Name.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Button_Top_1000';
  mainScene.Config.main.R.General.Joystick.Generic.General.Top_Name.Parent := mainScene.Config.main.R.General.Joystick.Generic.General.Top;
  mainScene.Config.main.R.General.Joystick.Generic.General.Top_Name.Align := TAlignLayout.Client;
  mainScene.Config.main.R.General.Joystick.Generic.General.Top_Name.Text := 'UP';
  mainScene.Config.main.R.General.Joystick.Generic.General.Top_Name.TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.General.Joystick.Generic.General.Top_Name.Tag := 1000;
  mainScene.Config.main.R.General.Joystick.Generic.General.Top_Name.TagString := 'UP';
  mainScene.Config.main.R.General.Joystick.Generic.General.Top_Name.OnClick := ex_main.Input.mouse_config.Text.OnMouseClick;
  mainScene.Config.main.R.General.Joystick.Generic.General.Top_Name.OnMouseEnter := ex_main.Input.mouse_config.Text.OnMouseEnter;
  mainScene.Config.main.R.General.Joystick.Generic.General.Top_Name.OnMouseLeave := ex_main.Input.mouse_config.Text.OnMouseLeave;
  mainScene.Config.main.R.General.Joystick.Generic.General.Top_Name.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.General.Down := TRectangle.Create(mainScene.Config.main.R.General.Joystick.Generic.General.Layout);
  mainScene.Config.main.R.General.Joystick.Generic.General.Down.Name := 'Main_Config_General_Joystick_MMSystem_Generic_DOWN';
  mainScene.Config.main.R.General.Joystick.Generic.General.Down.Parent := mainScene.Config.main.R.General.Joystick.Generic.General.Layout;
  mainScene.Config.main.R.General.Joystick.Generic.General.Down.SetBounds(40, 182, 140, 18);
  mainScene.Config.main.R.General.Joystick.Generic.General.Down.Fill.Kind := TBrushKind.Solid;
  mainScene.Config.main.R.General.Joystick.Generic.General.Down.Fill.Color := TAlphaColorRec.Grey;
  mainScene.Config.main.R.General.Joystick.Generic.General.Down.Stroke.Thickness := 1;
  mainScene.Config.main.R.General.Joystick.Generic.General.Down.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.General.Down_Name := TText.Create(mainScene.Config.main.R.General.Joystick.Generic.General.Down);
  mainScene.Config.main.R.General.Joystick.Generic.General.Down_Name.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Button_Down_1000';
  mainScene.Config.main.R.General.Joystick.Generic.General.Down_Name.Parent := mainScene.Config.main.R.General.Joystick.Generic.General.Down;
  mainScene.Config.main.R.General.Joystick.Generic.General.Down_Name.Align := TAlignLayout.Client;
  mainScene.Config.main.R.General.Joystick.Generic.General.Down_Name.Text := 'DOWN';
  mainScene.Config.main.R.General.Joystick.Generic.General.Down_Name.TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.General.Joystick.Generic.General.Down_Name.Tag := 1000;
  mainScene.Config.main.R.General.Joystick.Generic.General.Down_Name.TagString := 'DOWN';
  mainScene.Config.main.R.General.Joystick.Generic.General.Down_Name.OnClick := ex_main.Input.mouse_config.Text.OnMouseClick;
  mainScene.Config.main.R.General.Joystick.Generic.General.Down_Name.OnMouseEnter := ex_main.Input.mouse_config.Text.OnMouseEnter;
  mainScene.Config.main.R.General.Joystick.Generic.General.Down_Name.OnMouseLeave := ex_main.Input.mouse_config.Text.OnMouseLeave;
  mainScene.Config.main.R.General.Joystick.Generic.General.Down_Name.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.General.Left := TRectangle.Create(mainScene.Config.main.R.General.Joystick.Generic.General.Layout);
  mainScene.Config.main.R.General.Joystick.Generic.General.Left.Name := 'Main_Config_General_Joystick_MMSystem_Generic_LEFT';
  mainScene.Config.main.R.General.Joystick.Generic.General.Left.Parent := mainScene.Config.main.R.General.Joystick.Generic.General.Layout;
  mainScene.Config.main.R.General.Joystick.Generic.General.Left.SetBounds(20, 40, 18, 140);
  mainScene.Config.main.R.General.Joystick.Generic.General.Left.Fill.Kind := TBrushKind.Solid;
  mainScene.Config.main.R.General.Joystick.Generic.General.Left.Fill.Color := TAlphaColorRec.Grey;
  mainScene.Config.main.R.General.Joystick.Generic.General.Left.Stroke.Thickness := 1;
  mainScene.Config.main.R.General.Joystick.Generic.General.Left.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.General.Left_Name := TText.Create(mainScene.Config.main.R.General.Joystick.Generic.General.Left);
  mainScene.Config.main.R.General.Joystick.Generic.General.Left_Name.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Button_Left_1000';
  mainScene.Config.main.R.General.Joystick.Generic.General.Left_Name.Parent := mainScene.Config.main.R.General.Joystick.Generic.General.Left;
  mainScene.Config.main.R.General.Joystick.Generic.General.Left_Name.SetBounds(-61, 60, 140, 18);
  mainScene.Config.main.R.General.Joystick.Generic.General.Left_Name.Text := 'LEFT';
  mainScene.Config.main.R.General.Joystick.Generic.General.Left_Name.TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.General.Joystick.Generic.General.Left_Name.RotationAngle := 90;
  mainScene.Config.main.R.General.Joystick.Generic.General.Left_Name.Tag := 1000;
  mainScene.Config.main.R.General.Joystick.Generic.General.Left_Name.TagString := 'LEFT';
  mainScene.Config.main.R.General.Joystick.Generic.General.Left_Name.OnClick := ex_main.Input.mouse_config.Text.OnMouseClick;
  mainScene.Config.main.R.General.Joystick.Generic.General.Left_Name.OnMouseEnter := ex_main.Input.mouse_config.Text.OnMouseEnter;
  mainScene.Config.main.R.General.Joystick.Generic.General.Left_Name.OnMouseLeave := ex_main.Input.mouse_config.Text.OnMouseLeave;
  mainScene.Config.main.R.General.Joystick.Generic.General.Left_Name.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.General.Right := TRectangle.Create(mainScene.Config.main.R.General.Joystick.Generic.General.Layout);
  mainScene.Config.main.R.General.Joystick.Generic.General.Right.Name := 'Main_Config_General_Joystick_MMSystem_Generic_RIGHT';
  mainScene.Config.main.R.General.Joystick.Generic.General.Right.Parent := mainScene.Config.main.R.General.Joystick.Generic.General.Layout;
  mainScene.Config.main.R.General.Joystick.Generic.General.Right.SetBounds(182, 40, 18, 140);
  mainScene.Config.main.R.General.Joystick.Generic.General.Right.Fill.Kind := TBrushKind.Solid;
  mainScene.Config.main.R.General.Joystick.Generic.General.Right.Fill.Color := TAlphaColorRec.Grey;
  mainScene.Config.main.R.General.Joystick.Generic.General.Right.Stroke.Thickness := 1;
  mainScene.Config.main.R.General.Joystick.Generic.General.Right.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.General.Right_Name := TText.Create(mainScene.Config.main.R.General.Joystick.Generic.General.Right);
  mainScene.Config.main.R.General.Joystick.Generic.General.Right_Name.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Button_Right_1000';
  mainScene.Config.main.R.General.Joystick.Generic.General.Right_Name.Parent := mainScene.Config.main.R.General.Joystick.Generic.General.Right;
  mainScene.Config.main.R.General.Joystick.Generic.General.Right_Name.SetBounds(-61, 60, 140, 18);
  mainScene.Config.main.R.General.Joystick.Generic.General.Right_Name.Text := 'RIGHT';
  mainScene.Config.main.R.General.Joystick.Generic.General.Right_Name.TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.General.Joystick.Generic.General.Right_Name.RotationAngle := 90;
  mainScene.Config.main.R.General.Joystick.Generic.General.Right_Name.Tag := 1000;
  mainScene.Config.main.R.General.Joystick.Generic.General.Right_Name.TagString := 'RIGHT';
  mainScene.Config.main.R.General.Joystick.Generic.General.Right_Name.OnClick := ex_main.Input.mouse_config.Text.OnMouseClick;
  mainScene.Config.main.R.General.Joystick.Generic.General.Right_Name.OnMouseEnter := ex_main.Input.mouse_config.Text.OnMouseEnter;
  mainScene.Config.main.R.General.Joystick.Generic.General.Right_Name.OnMouseLeave := ex_main.Input.mouse_config.Text.OnMouseLeave;
  mainScene.Config.main.R.General.Joystick.Generic.General.Right_Name.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.General.Place_Circle := TCircle.Create(mainScene.Config.main.R.General.Joystick.Generic.General.Place);
  mainScene.Config.main.R.General.Joystick.Generic.General.Place_Circle.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Circle';
  mainScene.Config.main.R.General.Joystick.Generic.General.Place_Circle.Parent := mainScene.Config.main.R.General.Joystick.Generic.General.Place;
  mainScene.Config.main.R.General.Joystick.Generic.General.Place_Circle.SetBounds(0, 0, 140, 140);
  mainScene.Config.main.R.General.Joystick.Generic.General.Place_Circle.Fill.Kind := TBrushKind.Solid;
  mainScene.Config.main.R.General.Joystick.Generic.General.Place_Circle.Fill.Color := TAlphaColorRec.Grey;
  mainScene.Config.main.R.General.Joystick.Generic.General.Place_Circle.Stroke.Color := TAlphaColorRec.Black;
  mainScene.Config.main.R.General.Joystick.Generic.General.Place_Circle.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.General.Place_dot := TCircle.Create(mainScene.Config.main.R.General.Joystick.Generic.General.Place);
  mainScene.Config.main.R.General.Joystick.Generic.General.Place_dot.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Dot';
  mainScene.Config.main.R.General.Joystick.Generic.General.Place_dot.Parent := mainScene.Config.main.R.General.Joystick.Generic.General.Place;
  mainScene.Config.main.R.General.Joystick.Generic.General.Place_dot.SetBounds(62, 62, 16, 16);
  mainScene.Config.main.R.General.Joystick.Generic.General.Place_dot.Fill.Kind := TBrushKind.Solid;
  mainScene.Config.main.R.General.Joystick.Generic.General.Place_dot.Fill.Color := TAlphaColorRec.Red;
  mainScene.Config.main.R.General.Joystick.Generic.General.Place_dot.Stroke.Thickness := 1;
  mainScene.Config.main.R.General.Joystick.Generic.General.Place_dot.Visible := True;

  vk := 0;
  vr := 0;
  for vI := 0 to 15 do
  begin
    mainScene.Config.main.R.General.Joystick.Generic.General.Buttons[vI] := TCircle.Create(mainScene.Config.main.R.General.Joystick.Generic.General.Layout);
    mainScene.Config.main.R.General.Joystick.Generic.General.Buttons[vI].Name := 'Main_Config_General_Joystick_MMSystem_Generic_Button_' + vI.ToString;
    mainScene.Config.main.R.General.Joystick.Generic.General.Buttons[vI].Parent := mainScene.Config.main.R.General.Joystick.Generic.General.Layout;
    mainScene.Config.main.R.General.Joystick.Generic.General.Buttons[vI].SetBounds(270 + (vr * 72), 40 + (vk * 65), 35, 35);
    mainScene.Config.main.R.General.Joystick.Generic.General.Buttons[vI].Fill.Kind := TBrushKind.Solid;
    mainScene.Config.main.R.General.Joystick.Generic.General.Buttons[vI].Fill.Color := TAlphaColorRec.Grey;
    mainScene.Config.main.R.General.Joystick.Generic.General.Buttons[vI].Visible := True;

    mainScene.Config.main.R.General.Joystick.Generic.General.Buttons_Names[vI] :=
      TText.Create(mainScene.Config.main.R.General.Joystick.Generic.General.Buttons[vI]);
    mainScene.Config.main.R.General.Joystick.Generic.General.Buttons_Names[vI].Name := 'Main_Config_General_Joystick_MMSystem_Generic_Button_Name_' +
      vI.ToString;
    mainScene.Config.main.R.General.Joystick.Generic.General.Buttons_Names[vI].Parent := mainScene.Config.main.R.General.Joystick.Generic.General.Buttons[vI];
    mainScene.Config.main.R.General.Joystick.Generic.General.Buttons_Names[vI].Align := TAlignLayout.Client;
    mainScene.Config.main.R.General.Joystick.Generic.General.Buttons_Names[vI].TextSettings.FontColor := TAlphaColorRec.White;
    mainScene.Config.main.R.General.Joystick.Generic.General.Buttons_Names[vI].Text := (vI + 1).ToString;
    mainScene.Config.main.R.General.Joystick.Generic.General.Buttons_Names[vI].Tag := vI;
    mainScene.Config.main.R.General.Joystick.Generic.General.Buttons_Names[vI].TagString := 'button_' + (vI + 1).ToString;
    mainScene.Config.main.R.General.Joystick.Generic.General.Buttons_Names[vI].OnClick := ex_main.Input.mouse_config.Text.OnMouseClick;
    mainScene.Config.main.R.General.Joystick.Generic.General.Buttons_Names[vI].OnMouseEnter := ex_main.Input.mouse_config.Text.OnMouseEnter;
    mainScene.Config.main.R.General.Joystick.Generic.General.Buttons_Names[vI].OnMouseLeave := ex_main.Input.mouse_config.Text.OnMouseLeave;
    mainScene.Config.main.R.General.Joystick.Generic.General.Buttons_Names[vI].Visible := True;

    if vr = 3 then
    begin
      inc(vk);
      vr := 0;
    end
    else
      inc(vr);
  end;

  mainScene.Config.main.R.General.Joystick.Generic.General.Info := TGroupBox.Create(mainScene.Config.main.R.General.Joystick.Generic.General.Layout);
  mainScene.Config.main.R.General.Joystick.Generic.General.Info.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Info';
  mainScene.Config.main.R.General.Joystick.Generic.General.Info.Parent := mainScene.Config.main.R.General.Joystick.Generic.General.Layout;
  mainScene.Config.main.R.General.Joystick.Generic.General.Info.SetBounds(15, 300, mainScene.Config.main.R.General.Joystick.Generic.General.Layout.Width
    - 30, 80);
  mainScene.Config.main.R.General.Joystick.Generic.General.Info.Text := 'Information';
  mainScene.Config.main.R.General.Joystick.Generic.General.Info.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.General.Info_Current := TText.Create(mainScene.Config.main.R.General.Joystick.Generic.General.Info);
  mainScene.Config.main.R.General.Joystick.Generic.General.Info_Current.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Info_Current';
  mainScene.Config.main.R.General.Joystick.Generic.General.Info_Current.Parent := mainScene.Config.main.R.General.Joystick.Generic.General.Info;
  mainScene.Config.main.R.General.Joystick.Generic.General.Info_Current.SetBounds(10, 25, mainScene.Config.main.R.General.Joystick.Generic.General.Info.Width
    - 20, 20);
  mainScene.Config.main.R.General.Joystick.Generic.General.Info_Current.TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.General.Joystick.Generic.General.Info_Current.Text := '';
  mainScene.Config.main.R.General.Joystick.Generic.General.Info_Current.HorzTextAlign := TTextAlign.Leading;
  mainScene.Config.main.R.General.Joystick.Generic.General.Info_Current.Visible := False;

  mainScene.Config.main.R.General.Joystick.Generic.General.Info_Standard := TText.Create(mainScene.Config.main.R.General.Joystick.Generic.General.Info);
  mainScene.Config.main.R.General.Joystick.Generic.General.Info_Standard.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Info_Standard';
  mainScene.Config.main.R.General.Joystick.Generic.General.Info_Standard.Parent := mainScene.Config.main.R.General.Joystick.Generic.General.Info;
  mainScene.Config.main.R.General.Joystick.Generic.General.Info_Standard.SetBounds(10, 50, mainScene.Config.main.R.General.Joystick.Generic.General.Info.Width
    - 20, 20);
  mainScene.Config.main.R.General.Joystick.Generic.General.Info_Standard.TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.General.Joystick.Generic.General.Info_Standard.Text := 'Click to change the state of this action';
  mainScene.Config.main.R.General.Joystick.Generic.General.Info_Standard.HorzTextAlign := TTextAlign.Leading;
  mainScene.Config.main.R.General.Joystick.Generic.General.Info_Standard.Visible := False;

end;

procedure Create_MMSystem_Emulators;
var
  vI, vk, vr: Integer;
begin
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Layout := TLayout.Create(mainScene.Config.main.R.General.Joystick.Generic.Items[1]);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Layout.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Layout_Emulators';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Layout.Parent := mainScene.Config.main.R.General.Joystick.Generic.Items[1];
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Layout.Align := TAlignLayout.Client;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Layout.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place := TRectangle.Create(mainScene.Config.main.R.General.Joystick.Generic.Emulators.Layout);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Emulators_Place';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place.Parent := mainScene.Config.main.R.General.Joystick.Generic.Emulators.Layout;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place.SetBounds(40, 40, 140, 140);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place.Fill.Kind := TBrushKind.Solid;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place.Fill.Color := TAlphaColorRec.Grey;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place.Stroke.Thickness := 1;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top := TRectangle.Create(mainScene.Config.main.R.General.Joystick.Generic.Emulators.Layout);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Emulators_UP';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top.Parent := mainScene.Config.main.R.General.Joystick.Generic.Emulators.Layout;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top.SetBounds(40, 20, 140, 18);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top.Fill.Kind := TBrushKind.Solid;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top.Fill.Color := TAlphaColorRec.Grey;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top.Stroke.Thickness := 1;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top_Name := TText.Create(mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top_Name.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Emulators_Button_Top_1000';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top_Name.Parent := mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top_Name.Align := TAlignLayout.Client;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top_Name.Text := 'UP';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top_Name.TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top_Name.Tag := 1000;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top_Name.TagString := 'UP';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top_Name.OnClick := ex_main.Input.mouse_config.Text.OnMouseClick;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top_Name.OnMouseEnter := ex_main.Input.mouse_config.Text.OnMouseEnter;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top_Name.OnMouseLeave := ex_main.Input.mouse_config.Text.OnMouseLeave;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top_Name.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down := TRectangle.Create(mainScene.Config.main.R.General.Joystick.Generic.Emulators.Layout);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Emulators_DOWN';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down.Parent := mainScene.Config.main.R.General.Joystick.Generic.Emulators.Layout;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down.SetBounds(40, 182, 140, 18);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down.Fill.Kind := TBrushKind.Solid;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down.Fill.Color := TAlphaColorRec.Grey;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down.Stroke.Thickness := 1;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down_Name := TText.Create(mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down_Name.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Emulators_Button_Down_1000';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down_Name.Parent := mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down_Name.Align := TAlignLayout.Client;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down_Name.Text := 'DOWN';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down_Name.TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down_Name.Tag := 1000;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down_Name.TagString := 'DOWN';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down_Name.OnClick := ex_main.Input.mouse_config.Text.OnMouseClick;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down_Name.OnMouseEnter := ex_main.Input.mouse_config.Text.OnMouseEnter;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down_Name.OnMouseLeave := ex_main.Input.mouse_config.Text.OnMouseLeave;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down_Name.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left := TRectangle.Create(mainScene.Config.main.R.General.Joystick.Generic.Emulators.Layout);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Emulators_LEFT';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left.Parent := mainScene.Config.main.R.General.Joystick.Generic.Emulators.Layout;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left.SetBounds(20, 40, 18, 140);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left.Fill.Kind := TBrushKind.Solid;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left.Fill.Color := TAlphaColorRec.Grey;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left.Stroke.Thickness := 1;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left_Name := TText.Create(mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left_Name.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Emulators_Button_Left_1000';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left_Name.Parent := mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left_Name.SetBounds(-61, 60, 140, 18);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left_Name.Text := 'LEFT';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left_Name.TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left_Name.RotationAngle := 90;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left_Name.Tag := 1000;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left_Name.TagString := 'LEFT';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left_Name.OnClick := ex_main.Input.mouse_config.Text.OnMouseClick;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left_Name.OnMouseEnter := ex_main.Input.mouse_config.Text.OnMouseEnter;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left_Name.OnMouseLeave := ex_main.Input.mouse_config.Text.OnMouseLeave;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left_Name.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right := TRectangle.Create(mainScene.Config.main.R.General.Joystick.Generic.Emulators.Layout);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Emulators_RIGHT';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right.Parent := mainScene.Config.main.R.General.Joystick.Generic.Emulators.Layout;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right.SetBounds(182, 40, 18, 140);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right.Fill.Kind := TBrushKind.Solid;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right.Fill.Color := TAlphaColorRec.Grey;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right.Stroke.Thickness := 1;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right_Name := TText.Create(mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right_Name.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Emulators_Button_Right_1000';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right_Name.Parent := mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right_Name.SetBounds(-61, 60, 140, 18);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right_Name.Text := 'RIGHT';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right_Name.TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right_Name.RotationAngle := 90;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right_Name.Tag := 1000;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right_Name.TagString := 'RIGHT';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right_Name.OnClick := ex_main.Input.mouse_config.Text.OnMouseClick;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right_Name.OnMouseEnter := ex_main.Input.mouse_config.Text.OnMouseEnter;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right_Name.OnMouseLeave := ex_main.Input.mouse_config.Text.OnMouseLeave;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right_Name.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place_Circle := TCircle.Create(mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place_Circle.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Emulators_Circle';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place_Circle.Parent := mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place_Circle.SetBounds(0, 0, 140, 140);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place_Circle.Fill.Kind := TBrushKind.Solid;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place_Circle.Fill.Color := TAlphaColorRec.Grey;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place_Circle.Stroke.Color := TAlphaColorRec.Black;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place_Circle.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place_dot := TCircle.Create(mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place_dot.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Emulators_Dot';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place_dot.Parent := mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place_dot.SetBounds(62, 62, 16, 16);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place_dot.Fill.Kind := TBrushKind.Solid;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place_dot.Fill.Color := TAlphaColorRec.Red;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place_dot.Stroke.Thickness := 1;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place_dot.Visible := True;

  vk := 0;
  vr := 0;
  for vI := 0 to 15 do
  begin
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons[vI] := TCircle.Create(mainScene.Config.main.R.General.Joystick.Generic.Emulators.Layout);
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons[vI].Name := 'Main_Config_General_Joystick_MMSystem_Generic_Emulators_Button_' +
      vI.ToString;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons[vI].Parent := mainScene.Config.main.R.General.Joystick.Generic.Emulators.Layout;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons[vI].SetBounds(270 + (vr * 72), 40 + (vk * 65), 35, 35);
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons[vI].Fill.Kind := TBrushKind.Solid;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons[vI].Fill.Color := TAlphaColorRec.Grey;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons[vI].Visible := True;

    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons_Names[vI] :=
      TText.Create(mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons[vI]);
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons_Names[vI].Name := 'Main_Config_General_Joystick_MMSystem_Generic_Emulators_Button_Name_'
      + vI.ToString;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons_Names[vI].Parent :=
      mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons[vI];
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons_Names[vI].Align := TAlignLayout.Client;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons_Names[vI].TextSettings.FontColor := TAlphaColorRec.White;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons_Names[vI].Text := (vI + 1).ToString;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons_Names[vI].Tag := vI;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons_Names[vI].TagString := 'button_' + (vI + 1).ToString;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons_Names[vI].OnClick := ex_main.Input.mouse_config.Text.OnMouseClick;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons_Names[vI].OnMouseEnter := ex_main.Input.mouse_config.Text.OnMouseEnter;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons_Names[vI].OnMouseLeave := ex_main.Input.mouse_config.Text.OnMouseLeave;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons_Names[vI].Visible := True;

    if vr = 3 then
    begin
      inc(vk);
      vr := 0;
    end
    else
      inc(vr);
  end;

  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info := TGroupBox.Create(mainScene.Config.main.R.General.Joystick.Generic.Emulators.Layout);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Emulators_Info';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info.Parent := mainScene.Config.main.R.General.Joystick.Generic.Emulators.Layout;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info.SetBounds(15, 300, mainScene.Config.main.R.General.Joystick.Generic.Emulators.Layout.Width
    - 30, 80);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info.Text := 'Information';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info.Visible := True;

  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info_Current := TText.Create(mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info_Current.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Emulators_Info_Current';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info_Current.Parent := mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info_Current.SetBounds(10, 25,
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info.Width - 20, 20);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info_Current.TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info_Current.Text := '';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info_Current.HorzTextAlign := TTextAlign.Leading;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info_Current.Visible := False;

  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info_Standard := TText.Create(mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info_Standard.Name := 'Main_Config_General_Joystick_MMSystem_Generic_Emulators_Info_Standard';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info_Standard.Parent := mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info_Standard.SetBounds(10, 50,
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info.Width - 20, 20);
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info_Standard.TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info_Standard.Text := 'Click to change the state of this action';
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info_Standard.HorzTextAlign := TTextAlign.Leading;
  mainScene.Config.main.R.General.Joystick.Generic.Emulators.Info_Standard.Visible := False;
end;

procedure Refresh_MMSystem_Joy(vType: Integer);
var
  vI: Integer;
begin

  if vType = 0 then
  begin
    mainScene.Config.main.R.General.Joystick.Generic.Joy.Clear;

    vJoy_List[0] := TListBoxItem.Create(mainScene.Config.main.R.General.Joystick.Generic.Joy);
    vJoy_List[0].Name := 'Joy_Select_0';
    vJoy_List[0].Parent := mainScene.Config.main.R.General.Joystick.Generic.Joy;
    vJoy_List[0].Text := 'Choose Joystick';
    vJoy_List[0].Visible := True;

    for vI := 1 to 2 do
    begin
      vJoy_List[vI] := TListBoxItem.Create(mainScene.Config.main.R.General.Joystick.Generic.Joy);
      vJoy_List[vI].Name := 'Joy_Select_' + vI.ToString;
      vJoy_List[vI].Parent := mainScene.Config.main.R.General.Joystick.Generic.Joy;
      if vI = 1 then
      begin
        if uJoystick_mms.vJoy_mm_1.Joy_Connected then
        begin
          if uJoystick_mms.vJoy_mm_1.Manufacturer_Name = '' then
            vJoy_List[vI].Text := uJoystick_mms.vJoy_mm_1.Manufacturer_Name
          else
            vJoy_List[vI].Text := uJoystick_mms.vJoy_mm_1.Joy_Name;
        end
        else
          vJoy_List[vI].Text := 'Not Connected';
      end
      else
      begin
        if uJoystick_mms.vJoy_mm_2.Joy_Connected then
        begin
          if uJoystick_mms.vJoy_mm_2.Manufacturer_Name = '' then
            vJoy_List[vI].Text := uJoystick_mms.vJoy_mm_2.Manufacturer_Name
          else
            vJoy_List[vI].Text := uJoystick_mms.vJoy_mm_2.Joy_Name;
        end
        else
          vJoy_List[vI].Text := 'Not Connected';
      end;
      vJoy_List[vI].Visible := True;
    end;
    mainScene.Config.main.R.General.Joystick.Generic.Joy.ItemIndex := 0;
  end;
end;

procedure Activate_Field(vActive: Boolean);
var
  vI: Integer;
begin
  if vActive then
  begin
    { General }
    mainScene.Config.main.R.General.Joystick.Generic.General.Place.Fill.Color := TAlphaColorRec.Deepskyblue;
    mainScene.Config.main.R.General.Joystick.Generic.General.Top.Fill.Color := TAlphaColorRec.Deepskyblue;
    mainScene.Config.main.R.General.Joystick.Generic.General.Down.Fill.Color := TAlphaColorRec.Deepskyblue;
    mainScene.Config.main.R.General.Joystick.Generic.General.Left.Fill.Color := TAlphaColorRec.Deepskyblue;
    mainScene.Config.main.R.General.Joystick.Generic.General.Right.Fill.Color := TAlphaColorRec.Deepskyblue;
    mainScene.Config.main.R.General.Joystick.Generic.General.Place_Circle.Fill.Color := TAlphaColorRec.Deepskyblue;
    for vI := 0 to 15 do
    begin
      mainScene.Config.main.R.General.Joystick.Generic.General.Buttons[vI].Fill.Color := TAlphaColorRec.Deepskyblue;
      mainScene.Config.main.R.General.Joystick.Generic.General.Buttons[vI].Visible := False;
    end;
    for vI := 0 to uJoystick_mms.vJoy_mm_1.ButtonCount - 1 do
      mainScene.Config.main.R.General.Joystick.Generic.General.Buttons[vI].Visible := True;
    { Emulators }
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place.Fill.Color := TAlphaColorRec.Deepskyblue;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top.Fill.Color := TAlphaColorRec.Deepskyblue;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down.Fill.Color := TAlphaColorRec.Deepskyblue;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left.Fill.Color := TAlphaColorRec.Deepskyblue;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right.Fill.Color := TAlphaColorRec.Deepskyblue;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place_Circle.Fill.Color := TAlphaColorRec.Deepskyblue;
    for vI := 0 to 15 do
    begin
      mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons[vI].Fill.Color := TAlphaColorRec.Deepskyblue;
      mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons[vI].Visible := False;
    end;
    for vI := 0 to uJoystick_mms.vJoy_mm_1.ButtonCount - 1 do
      mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons[vI].Visible := True;
  end
  else
  begin
    { General }
    mainScene.Config.main.R.General.Joystick.Generic.General.Place.Fill.Color := TAlphaColorRec.Grey;
    mainScene.Config.main.R.General.Joystick.Generic.General.Top.Fill.Color := TAlphaColorRec.Grey;
    mainScene.Config.main.R.General.Joystick.Generic.General.Down.Fill.Color := TAlphaColorRec.Grey;
    mainScene.Config.main.R.General.Joystick.Generic.General.Left.Fill.Color := TAlphaColorRec.Grey;
    mainScene.Config.main.R.General.Joystick.Generic.General.Right.Fill.Color := TAlphaColorRec.Grey;
    mainScene.Config.main.R.General.Joystick.Generic.General.Place_Circle.Fill.Color := TAlphaColorRec.Grey;
    for vI := 0 to 15 do
    begin
      mainScene.Config.main.R.General.Joystick.Generic.General.Buttons[vI].Fill.Color := TAlphaColorRec.Grey;
      mainScene.Config.main.R.General.Joystick.Generic.General.Buttons[vI].Visible := True;
    end;
    { Emulators }
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place.Fill.Color := TAlphaColorRec.Grey;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Top.Fill.Color := TAlphaColorRec.Grey;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Down.Fill.Color := TAlphaColorRec.Grey;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Left.Fill.Color := TAlphaColorRec.Grey;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Right.Fill.Color := TAlphaColorRec.Grey;
    mainScene.Config.main.R.General.Joystick.Generic.Emulators.Place_Circle.Fill.Color := TAlphaColorRec.Grey;
    for vI := 0 to 15 do
    begin
      mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons[vI].Fill.Color := TAlphaColorRec.Grey;
      mainScene.Config.main.R.General.Joystick.Generic.Emulators.Buttons[vI].Visible := True;
    end;
  end;
end;

procedure Select_Joy(vNum: Integer);
begin
  if ((vNum = 1) and (uJoystick_mms.vJoy_mm_1.Joy_Connected)) or ((vNum = 2) and (uJoystick_mms.vJoy_mm_2.Joy_Connected)) then
    Activate_Field(True)
  else
    Activate_Field(False);
  uMain_Config_General_Joystick.vSelected := vNum;
end;

function Check_If_Joy_In_Database(vMan, vPro, vName, vReg, vOEM: String): Boolean;
begin
  Result := False;
  uDB.ExtraFE_Query_Local.Close;
  uDB.ExtraFE_Query_Local.SQL.Clear;
  uDB.ExtraFE_Query_Local.SQL.Text := 'SELECT * FROM map_joystick_mmsystem WHERE manufacturer_name="' + vMan + '" AND product_name="' + vPro + '" AND name="' +
    vName + '" AND regkey="' + vReg + '" AND szoem="' + vOEM + '" AND user_id="' + uDB_AUser.Local.USER.Num.ToString + '" ';
  uDB.ExtraFE_Query_Local.Open;

  if uDB.ExtraFE_Query_Local.RecordCount > 0 then
    Result := True;
end;

procedure Wait_To_Set_Key_Action(vKey_Action, vKey_Tag_Action: String);
var
  vInt: Integer;
begin
  if (vKey_Tag_Action <> 'UP') and (vKey_Tag_Action <> 'DOWN') and (vKey_Tag_Action <> 'LEFT') and (vKey_Tag_Action <> 'RIGHT') then
  begin
    vInt := vKey_Action.ToInteger;
    inc(vInt);
    Show_Options(True, 'Select action for "' + vInt.ToString + '" button')
  end
  else
    Show_Options(False, 'Move joystick to "' + vKey_Tag_Action + '" direction');

  vSelected_joy_Timer := TTimer.Create(mainScene.Config.main.R.General.Joystick.Image);
  vSelected_joy_Timer.Name := 'Main_Config_General_Keyboard_Timer';
  vSelected_joy_Timer.Parent := mainScene.Config.main.R.General.Joystick.Image;
  vSelected_joy_Timer.Interval := 500;
  vSelected_joy_Timer.OnTimer := vTimer_joy.OnTimer;
  vSelected_joy_Timer.Enabled := True;

  vTimes_joy := 0;
  vDots_joy := 2;
  uMain_Config_General_Joystick.vJoy_Mapping := True;
end;

end.