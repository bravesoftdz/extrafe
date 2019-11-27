unit uMain_Config_General_Visual;

interface

uses
  System.Classes,
  System.SysUtils,
  FMX.StdCtrls;

procedure Create;

procedure Update_Virtual_Keyboard(vState: Boolean);

implementation

uses
  uLoad_AllTypes,
  uMain_AllTypes,
  uDB_AUser,
  uDB;

procedure Create;
begin
  mainScene.Config.Main.R.General.Visual.Keyboard_Group :=
    TGroupBox.Create(mainScene.Config.Main.R.General.Tab_Item[0]);
  mainScene.Config.Main.R.General.Visual.Keyboard_Group.Name := 'Main_Config_General_Visoual_Keyboard_Group';
  mainScene.Config.Main.R.General.Visual.Keyboard_Group.Parent :=
    mainScene.Config.Main.R.General.Tab_Item[0];
  mainScene.Config.Main.R.General.Visual.Keyboard_Group.SetBounds(10, 10,
    mainScene.Config.Main.R.General.Contol.Width - 20, 160);
  mainScene.Config.Main.R.General.Visual.Keyboard_Group.Text:= 'Keyboard';
  mainScene.Config.Main.R.General.Visual.Keyboard_Group.Visible := True;

  mainScene.Config.Main.R.General.Visual.Virtual_Keyboard :=
    TCheckBox.Create(mainScene.Config.Main.R.General.Visual.Keyboard_Group);
  mainScene.Config.Main.R.General.Visual.Virtual_Keyboard.Name :=
    'Main_Config_General_Visual_VirtualKeyboard';
  mainScene.Config.Main.R.General.Visual.Virtual_Keyboard.Parent :=
    mainScene.Config.Main.R.General.Visual.Keyboard_Group;
  mainScene.Config.Main.R.General.Visual.Virtual_Keyboard.SetBounds(20, 20, 300, 24);
  mainScene.Config.Main.R.General.Visual.Virtual_Keyboard.Text := 'Enable virtual keyboard';
  mainScene.Config.Main.R.General.Visual.Virtual_Keyboard.IsChecked:= uDB_AUser.Local.OPTIONS.Visual.Virtual_Keyboard;
  mainScene.Config.Main.R.General.Visual.Virtual_Keyboard.OnClick:= ex_main.Input.mouse_config.Checkbox.OnMouseClick;
  mainScene.Config.Main.R.General.Visual.Virtual_Keyboard.Visible := True;
end;

procedure Update_Virtual_Keyboard(vState: Boolean);
begin
  uDB_AUser.Local.OPTIONS.Visual.Virtual_Keyboard:= vState;
  if vState then
    uDB.Query_Update(uDB.ExtraFE_Query_Local, 'options','virtual_keyboard', '1', 'USER_ID', uDB_AUser.Local.Num.ToString)
  else
    uDB.Query_Update(uDB.ExtraFE_Query_Local, 'options','virtual_keyboard', '0', 'USER_ID', uDB_AUser.Local.Num.ToString);
end;

end.
