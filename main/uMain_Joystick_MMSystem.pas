unit uMain_Joystick_MMSystem;

interface

uses
  System.Classes,
  System.StrUtils,
  uJoystick_MMSystem,
  FMX.Dialogs;

procedure Move_Joy(vAction: String);
procedure Do_Move_Action(vAction: String);

procedure Button_Down_Joy(myButtons: TJoyButtons);
procedure Do_Button_Action(vAction: String);

procedure Joy_1_Set_Move_Action(vAction: String);

procedure Joy_1_Set_Button_Down_Action(myButtons: TJoyButtons);
procedure Joy_1_Set_Button_Up_Action(myButtons: TJoyButtons);

implementation

uses
  uDB,
  uDB_AUser,
  uMain,
  uMain_Config,
  uMain_Emulation,
  uLoad_AllTypes,
  uMain_Config_General_Joystick,
  uMain_Config_General_Joystick_MMSystem;

procedure Move_Joy(vAction: String);
begin
  if vAction = 'center' then
    // mainScene.Config.main.R.General.Joystick.Generic.General.Place_dot.SetBounds(62, 62, 16, 16)
  else if vAction = 'up_left' then
  begin
    if (uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Up <> '') and (uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Left <> '') then
    begin

    end;
  end
  else if vAction = 'down_left' then
  begin
    if (uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Down <> '') and (uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Left <> '') then
    begin

    end;
  end
  else if vAction = 'up_right' then
  begin
    if (uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Up <> '') and (uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Right <> '') then
    begin

    end;
  end
  else if vAction = 'down_right' then
  begin
    if (uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Down <> '') and (uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Right <> '') then
    begin

    end;
  end
  else if vAction = 'up' then
  begin
    if uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Up <> '' then
    begin

    end;
  end
  else if vAction = 'down' then
  begin
    if uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Down <> '' then
    begin
    end;
  end
  else if vAction = 'left' then
  begin
    if uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Left <> '' then
      Do_Move_Action(uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Left);
  end
  else if vAction = 'right' then
  begin
    if uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Right <> '' then
      Do_Move_Action(uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Right);
  end;
end;

procedure Do_Move_Action(vAction: String);
begin
  if vAction = 'left' then
    uMain_Emulation.Slide_Left
  else if vAction = 'right' then
    uMain_Emulation.Slide_Right;
end;

procedure Button_Down_Joy(myButtons: TJoyButtons);
begin
  if uJoystick_MMSystem.TJoyButton.JoyBtn1 in myButtons then
    if uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_1 <> '' then
      Do_Button_Action(uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_1);

  if uJoystick_MMSystem.TJoyButton.JoyBtn2 in myButtons then
    if uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_2 <> '' then
      Do_Button_Action(uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_2);

  if uJoystick_MMSystem.TJoyButton.JoyBtn3 in myButtons then
    if uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_3 <> '' then
      Do_Button_Action(uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_3);

  if uJoystick_MMSystem.TJoyButton.JoyBtn4 in myButtons then
    if uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_4 <> '' then
      Do_Button_Action(uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_4);

  if uJoystick_MMSystem.TJoyButton.JoyBtn5 in myButtons then
    if uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_5 <> '' then
      Do_Button_Action(uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_5);

  if uJoystick_MMSystem.TJoyButton.JoyBtn6 in myButtons then
    if uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_6 <> '' then
      Do_Button_Action(uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_6);

  if uJoystick_MMSystem.TJoyButton.JoyBtn7 in myButtons then
    if uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_7 <> '' then
      Do_Button_Action(uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_7);

  if uJoystick_MMSystem.TJoyButton.JoyBtn8 in myButtons then
    if uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_8 <> '' then
      Do_Button_Action(uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_8);

  if uJoystick_MMSystem.TJoyButton.JoyBtn9 in myButtons then
    if uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_9 <> '' then
      Do_Button_Action(uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_9);

  if uJoystick_MMSystem.TJoyButton.JoyBtn10 in myButtons then
    if uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_10 <> '' then
      Do_Button_Action(uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_10);

  if uJoystick_MMSystem.TJoyButton.JoyBtn11 in myButtons then
    if uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_11 <> '' then
      Do_Button_Action(uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_11);

  if uJoystick_MMSystem.TJoyButton.JoyBtn12 in myButtons then
    if uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_12 <> '' then
      Do_Button_Action(uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_12);

  if uJoystick_MMSystem.TJoyButton.JoyBtn13 in myButtons then
    if uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_13 <> '' then
      Do_Button_Action(uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_13);

  if uJoystick_MMSystem.TJoyButton.JoyBtn14 in myButtons then
    if uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_14 <> '' then
      Do_Button_Action(uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_14);

  if uJoystick_MMSystem.TJoyButton.JoyBtn15 in myButtons then
    if uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_15 <> '' then
      Do_Button_Action(uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_15);

  if uJoystick_MMSystem.TJoyButton.JoyBtn16 in myButtons then
    if uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_16 <> '' then
      Do_Button_Action(uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_16);

  { if uJoystick_MMSystem.TJoyButton.JoyBtn17 in myButtons then
    vAction := 'button_17';
    if uJoystick_MMSystem.TJoyButton.JoyBtn18 in myButtons then
    vAction := 'button_18';
    if uJoystick_MMSystem.TJoyButton.JoyBtn19 in myButtons then
    vAction := 'button_19';
    if uJoystick_MMSystem.TJoyButton.JoyBtn20 in myButtons then
    vAction := 'button_20';
    if uJoystick_MMSystem.TJoyButton.JoyBtn21 in myButtons then
    vAction := 'button_21';
    if uJoystick_MMSystem.TJoyButton.JoyBtn22 in myButtons then
    vAction := 'button_22';
    if uJoystick_MMSystem.TJoyButton.JoyBtn23 in myButtons then
    vAction := 'button_23';
    if uJoystick_MMSystem.TJoyButton.JoyBtn24 in myButtons then
    vAction := 'button_24';
    if uJoystick_MMSystem.TJoyButton.JoyBtn25 in myButtons then
    vAction := 'button_25';
    if uJoystick_MMSystem.TJoyButton.JoyBtn26 in myButtons then
    vAction := 'button_26';
    if uJoystick_MMSystem.TJoyButton.JoyBtn27 in myButtons then
    vAction := 'button_27';
    if uJoystick_MMSystem.TJoyButton.JoyBtn28 in myButtons then
    vAction := 'button_28';
    if uJoystick_MMSystem.TJoyButton.JoyBtn29 in myButtons then
    vAction := 'button_29';
    if uJoystick_MMSystem.TJoyButton.JoyBtn30 in myButtons then
    vAction := 'button_30';
    if uJoystick_MMSystem.TJoyButton.JoyBtn31 in myButtons then
    vAction := 'button_31';
    if uJoystick_MMSystem.TJoyButton.JoyBtn32 in myButtons then
    vAction := 'button_32'; }
end;

procedure Do_Button_Action(vAction: String);
begin
  if vAction = 'Action' then
  begin
    if extrafe.prog.State = 'main' then
      uMain_Emulation.Trigger_Click(emulation.Selection.TabIndex)
  end
  else if vAction = 'Escape' then
  begin
    if emulation.Level <> 0 then
    begin
      emulation.Level := 0;
      uMain_Emulation.Category(emulation.Level, emulation.Category_Num);
    end
    else
      uMain.Exit;
  end
  else if vAction = 'Settings' then
    uMain_Config.ShowHide(extrafe.prog.State);
end;

procedure Joy_1_Set_Move_Action(vAction: String);
begin
  if ContainsText(extrafe.prog.State, 'main_config_general_joystick_mmsystem') then
    uMain_Config_General_Joystick.Move(vAction)
  else
    Move_Joy(vAction);
end;

procedure Joy_1_Set_Button_Down_Action(myButtons: TJoyButtons);
begin
  if ContainsText(extrafe.prog.State, 'main_config_general_joystick_mmsystem') then
    uMain_Config_General_Joystick.Button_Down(myButtons)
  else
    Button_Down_Joy(myButtons);
end;

procedure Joy_1_Set_Button_Up_Action(myButtons: TJoyButtons);
begin
  if ContainsText(extrafe.prog.State, 'main_config_general_joystick_mmsystem') then
    uMain_Config_General_Joystick.Button_Up(myButtons)
end;

end.
