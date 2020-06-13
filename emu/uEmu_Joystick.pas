unit uEmu_Joystick;

interface
uses
  System.Classes,
  uJoystick_mmsystem;

procedure Joy_1_Set_Move_Action(vAction: String);
procedure Joy_1_Set_Buttons_Down(myButtons: TJoyButtons);
procedure Joy_1_Set_Buttons_Up(myButtons: TJoyButtons);


implementation
uses
  uEmu_Actions,
  uDB_AUser,
  uView_Mode_Default_Joy_MMSystem;

procedure Joy_1_Set_Move_Action(vAction: String);
begin
  if uEmu_Actions.vCurrent_View_Mode = 'default' then
    uView_Mode_Default_Joy_MMSystem.Move(vAction);
  
end;

procedure Joy_1_Set_Buttons_Down(myButtons: TJoyButtons);
begin
  if uEmu_Actions.vCurrent_View_Mode = 'default' then
    uView_Mode_Default_Joy_MMSystem.Buttons_Down(myButtons);
end;

procedure Joy_1_Set_Buttons_Up(myButtons: TJoyButtons);
begin
  if uEmu_Actions.vCurrent_View_Mode = 'default' then
    uView_Mode_Default_Joy_MMSystem.Buttons_Up(myButtons);
end;

end.
