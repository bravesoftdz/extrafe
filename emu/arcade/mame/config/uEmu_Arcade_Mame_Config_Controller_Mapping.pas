unit uEmu_Arcade_Mame_Config_Controller_Mapping;

interface
uses
  System.Classes,
  System.UITypes,
  System.SysUtils,
  FMX.StdCtrls,
  FMX.Types,
  FMX.Edit,
  FMX.Listbox,
  FMX.Dialogs;

  procedure uEmu_Arcade_Mame_Config_Create_ControllerMapping_Panel;

  function uEmu_Arcade_Mame_Config_ControllerMapping_LoadContMapping(vType: String): integer;

  procedure uEmu_Arcade_Mame_Config_ControllerMapping_SetContMapping(vItemIndex, vDevice: integer);


implementation
uses
  uEmu_Arcade_Mame_AllTypes;

procedure uEmu_Arcade_Mame_Config_Create_ControllerMapping_Panel;
begin
  vMame.Config.Panel.Controls_Map.Labels[0]:= TLabel.Create(vMame.Config.Scene.Right_Panels[9]);
  vMame.Config.Panel.Controls_Map.Labels[0].Name:= 'Mame_ControllerMapping_InfoLabel_1';
  vMame.Config.Panel.Controls_Map.Labels[0].Parent:= vMame.Config.Scene.Right_Panels[9];
  vMame.Config.Panel.Controls_Map.Labels[0].TextSettings.HorzAlign:= TTextAlign.Trailing;
  vMame.Config.Panel.Controls_Map.Labels[0].Text:= 'Global Options';
  vMame.Config.Panel.Controls_Map.Labels[0].Position.Y:= 5;
  vMame.Config.Panel.Controls_Map.Labels[0].Position.X:= vMame.Config.Scene.Right_Panels[9].Width- vMame.Config.Panel.Controls_Map.Labels[0].Width- 10;
  vMame.Config.Panel.Controls_Map.Labels[0].Visible:= True;

  vMame.Config.Panel.Controls_Map.Labels[1]:= TLabel.Create(vMame.Config.Scene.Right_Panels[9]);
  vMame.Config.Panel.Controls_Map.Labels[1].Name:= 'Mame_ControllerMapping_InfoLabel_2';
  vMame.Config.Panel.Controls_Map.Labels[1].Parent:= vMame.Config.Scene.Right_Panels[9];
  vMame.Config.Panel.Controls_Map.Labels[1].TextSettings.HorzAlign:= TTextAlign.Trailing;
  vMame.Config.Panel.Controls_Map.Labels[1].Text:= 'Default options used by all games';
  vMame.Config.Panel.Controls_Map.Labels[1].Width:= 180;
  vMame.Config.Panel.Controls_Map.Labels[1].Position.Y:= 22;
  vMame.Config.Panel.Controls_Map.Labels[1].Position.X:= vMame.Config.Scene.Right_Panels[9].Width- vMame.Config.Panel.Controls_Map.Labels[1].Width- 10;
  vMame.Config.Panel.Controls_Map.Labels[1].Visible:= True;

  //left
  vMame.Config.Panel.Controls_Map.Groupbox[0]:= TGroupBox.Create(vMame.Config.Scene.Right_Panels[9]);
  vMame.Config.Panel.Controls_Map.Groupbox[0].Name:= 'Mame_ControllerMapping_Groupbox_PaddleDevice';
  vMame.Config.Panel.Controls_Map.Groupbox[0].Parent:= vMame.Config.Scene.Right_Panels[9];
  vMame.Config.Panel.Controls_Map.Groupbox[0].SetBounds(10,40,((vMame.Config.Scene.Right_Panels[9].Width/ 2)- 15),70);
  vMame.Config.Panel.Controls_Map.Groupbox[0].Text:= 'Paddle device';
  vMame.Config.Panel.Controls_Map.Groupbox[0].Visible:= True;

  vMame.Config.Panel.Controls_Map.Combobox[0]:= TComboBox.Create(vMame.Config.Panel.Controls_Map.Groupbox[0]);
  vMame.Config.Panel.Controls_Map.Combobox[0].Name:= 'Mame_ControllerMapping_Combobox_PaddleDevice';
  vMame.Config.Panel.Controls_Map.Combobox[0].Parent:= vMame.Config.Panel.Controls_Map.Groupbox[0];
  vMame.Config.Panel.Controls_Map.Combobox[0].SetBounds(5,25,(vMame.Config.Panel.Controls_Map.Groupbox[0].Width- 10),25);
  vMame.Config.Panel.Controls_Map.Combobox[0].Items.Add('None');
  vMame.Config.Panel.Controls_Map.Combobox[0].Items.Add('Keyboard');
  vMame.Config.Panel.Controls_Map.Combobox[0].Items.Add('Mouse');
  vMame.Config.Panel.Controls_Map.Combobox[0].Items.Add('Joystick');
  vMame.Config.Panel.Controls_Map.Combobox[0].Items.Add('Lightgun');
  vMame.Config.Panel.Controls_Map.Combobox[0].Tag:= 0;
  vMame.Config.Panel.Controls_Map.Combobox[0].ItemIndex:= uEmu_Arcade_Mame_Config_ControllerMapping_LoadContMapping(mame.Emu.Ini.CORE_INPUT_AUTOMATIC_paddle_device);
  vMame.Config.Panel.Controls_Map.Combobox[0].OnChange:= mame.Config.Input.Mouse.Combobox.OnChange;
  vMame.Config.Panel.Controls_Map.Combobox[0].Visible:= True;

  vMame.Config.Panel.Controls_Map.Groupbox[1]:= TGroupBox.Create(vMame.Config.Scene.Right_Panels[9]);
  vMame.Config.Panel.Controls_Map.Groupbox[1].Name:= 'Mame_ControllerMapping_Groupbox_ADStickDevice';
  vMame.Config.Panel.Controls_Map.Groupbox[1].Parent:= vMame.Config.Scene.Right_Panels[9];
  vMame.Config.Panel.Controls_Map.Groupbox[1].SetBounds(10,115,((vMame.Config.Scene.Right_Panels[9].Width/ 2)- 15),70);
  vMame.Config.Panel.Controls_Map.Groupbox[1].Text:= 'ADStick device';
  vMame.Config.Panel.Controls_Map.Groupbox[1].Visible:= True;

  vMame.Config.Panel.Controls_Map.Combobox[1]:= TComboBox.Create(vMame.Config.Panel.Controls_Map.Groupbox[1]);
  vMame.Config.Panel.Controls_Map.Combobox[1].Name:= 'Mame_ControllerMapping_Combobox_ADStickDevice';
  vMame.Config.Panel.Controls_Map.Combobox[1].Parent:= vMame.Config.Panel.Controls_Map.Groupbox[1];
  vMame.Config.Panel.Controls_Map.Combobox[1].SetBounds(5,25,(vMame.Config.Panel.Controls_Map.Groupbox[1].Width- 10),25);
  vMame.Config.Panel.Controls_Map.Combobox[1].Items.Add('None');
  vMame.Config.Panel.Controls_Map.Combobox[1].Items.Add('Keyboard');
  vMame.Config.Panel.Controls_Map.Combobox[1].Items.Add('Mouse');
  vMame.Config.Panel.Controls_Map.Combobox[1].Items.Add('Joystick');
  vMame.Config.Panel.Controls_Map.Combobox[1].Items.Add('Lightgun');
  vMame.Config.Panel.Controls_Map.Combobox[1].ItemIndex:= 0;
  vMame.Config.Panel.Controls_Map.Combobox[1].Tag:= 1;
  vMame.Config.Panel.Controls_Map.Combobox[1].ItemIndex:= uEmu_Arcade_Mame_Config_ControllerMapping_LoadContMapping(mame.Emu.Ini.CORE_INPUT_AUTOMATIC_adstick_device);
  vMame.Config.Panel.Controls_Map.Combobox[1].OnChange:= mame.Config.Input.Mouse.Combobox.OnChange;
  vMame.Config.Panel.Controls_Map.Combobox[1].Visible:= True;

  vMame.Config.Panel.Controls_Map.Groupbox[2]:= TGroupBox.Create(vMame.Config.Scene.Right_Panels[9]);
  vMame.Config.Panel.Controls_Map.Groupbox[2].Name:= 'Mame_ControllerMapping_Groupbox_PedalDevice';
  vMame.Config.Panel.Controls_Map.Groupbox[2].Parent:= vMame.Config.Scene.Right_Panels[9];
  vMame.Config.Panel.Controls_Map.Groupbox[2].SetBounds(10,190,((vMame.Config.Scene.Right_Panels[9].Width/ 2)- 15),70);
  vMame.Config.Panel.Controls_Map.Groupbox[2].Text:= 'Pedal device';
  vMame.Config.Panel.Controls_Map.Groupbox[2].Visible:= True;

  vMame.Config.Panel.Controls_Map.Combobox[2]:= TComboBox.Create(vMame.Config.Panel.Controls_Map.Groupbox[2]);
  vMame.Config.Panel.Controls_Map.Combobox[2].Name:= 'Mame_ControllerMapping_Combobox_PedalDevice';
  vMame.Config.Panel.Controls_Map.Combobox[2].Parent:= vMame.Config.Panel.Controls_Map.Groupbox[2];
  vMame.Config.Panel.Controls_Map.Combobox[2].SetBounds(5,25,(vMame.Config.Panel.Controls_Map.Groupbox[2].Width- 10),25);
  vMame.Config.Panel.Controls_Map.Combobox[2].Items.Add('None');
  vMame.Config.Panel.Controls_Map.Combobox[2].Items.Add('Keyboard');
  vMame.Config.Panel.Controls_Map.Combobox[2].Items.Add('Mouse');
  vMame.Config.Panel.Controls_Map.Combobox[2].Items.Add('Joystick');
  vMame.Config.Panel.Controls_Map.Combobox[2].Items.Add('Lightgun');
  vMame.Config.Panel.Controls_Map.Combobox[2].ItemIndex:= 0;
  vMame.Config.Panel.Controls_Map.Combobox[2].Tag:= 2;
  vMame.Config.Panel.Controls_Map.Combobox[2].ItemIndex:= uEmu_Arcade_Mame_Config_ControllerMapping_LoadContMapping(mame.Emu.Ini.CORE_INPUT_AUTOMATIC_pedal_device);
  vMame.Config.Panel.Controls_Map.Combobox[2].OnChange:= mame.Config.Input.Mouse.Combobox.OnChange;
  vMame.Config.Panel.Controls_Map.Combobox[2].Visible:= True;

  vMame.Config.Panel.Controls_Map.Groupbox[3]:= TGroupBox.Create(vMame.Config.Scene.Right_Panels[9]);
  vMame.Config.Panel.Controls_Map.Groupbox[3].Name:= 'Mame_ControllerMapping_Groupbox_MouseDevice';
  vMame.Config.Panel.Controls_Map.Groupbox[3].Parent:= vMame.Config.Scene.Right_Panels[9];
  vMame.Config.Panel.Controls_Map.Groupbox[3].SetBounds(10,265,((vMame.Config.Scene.Right_Panels[9].Width/ 2)- 15),70);
  vMame.Config.Panel.Controls_Map.Groupbox[3].Text:= 'Mouse device';
  vMame.Config.Panel.Controls_Map.Groupbox[3].Visible:= True;

  vMame.Config.Panel.Controls_Map.Combobox[3]:= TComboBox.Create(vMame.Config.Panel.Controls_Map.Groupbox[3]);
  vMame.Config.Panel.Controls_Map.Combobox[3].Name:= 'Mame_ControllerMapping_Combobox_MouseDevice';
  vMame.Config.Panel.Controls_Map.Combobox[3].Parent:= vMame.Config.Panel.Controls_Map.Groupbox[3];
  vMame.Config.Panel.Controls_Map.Combobox[3].SetBounds(5,25,(vMame.Config.Panel.Controls_Map.Groupbox[3].Width- 10),25);
  vMame.Config.Panel.Controls_Map.Combobox[3].Items.Add('None');
  vMame.Config.Panel.Controls_Map.Combobox[3].Items.Add('Keyboard');
  vMame.Config.Panel.Controls_Map.Combobox[3].Items.Add('Mouse');
  vMame.Config.Panel.Controls_Map.Combobox[3].Items.Add('Joystick');
  vMame.Config.Panel.Controls_Map.Combobox[3].Items.Add('Lightgun');
  vMame.Config.Panel.Controls_Map.Combobox[3].ItemIndex:= 0;
  vMame.Config.Panel.Controls_Map.Combobox[3].Tag:= 3;
  vMame.Config.Panel.Controls_Map.Combobox[3].ItemIndex:= uEmu_Arcade_Mame_Config_ControllerMapping_LoadContMapping(mame.Emu.Ini.CORE_INPUT_AUTOMATIC_mouse_device);
  vMame.Config.Panel.Controls_Map.Combobox[3].OnChange:= mame.Config.Input.Mouse.Combobox.OnChange;
  vMame.Config.Panel.Controls_Map.Combobox[3].Visible:= True;

  //right
  vMame.Config.Panel.Controls_Map.Groupbox[4]:= TGroupBox.Create(vMame.Config.Scene.Right_Panels[9]);
  vMame.Config.Panel.Controls_Map.Groupbox[4].Name:= 'Mame_ControllerMapping_Groupbox_DialDevice';
  vMame.Config.Panel.Controls_Map.Groupbox[4].Parent:= vMame.Config.Scene.Right_Panels[9];
  vMame.Config.Panel.Controls_Map.Groupbox[4].SetBounds(((vMame.Config.Scene.Right_Panels[9].Width/ 2)+ 5),40,((vMame.Config.Scene.Right_Panels[9].Width/ 2)- 15),70);
  vMame.Config.Panel.Controls_Map.Groupbox[4].Text:= 'Dial device';
  vMame.Config.Panel.Controls_Map.Groupbox[4].Visible:= True;

  vMame.Config.Panel.Controls_Map.Combobox[4]:= TComboBox.Create(vMame.Config.Panel.Controls_Map.Groupbox[4]);
  vMame.Config.Panel.Controls_Map.Combobox[4].Name:= 'Mame_ControllerMapping_Combobox_DialDevice';
  vMame.Config.Panel.Controls_Map.Combobox[4].Parent:= vMame.Config.Panel.Controls_Map.Groupbox[4];
  vMame.Config.Panel.Controls_Map.Combobox[4].SetBounds(5,25,(vMame.Config.Panel.Controls_Map.Groupbox[4].Width- 10),25);
  vMame.Config.Panel.Controls_Map.Combobox[4].Items.Add('None');
  vMame.Config.Panel.Controls_Map.Combobox[4].Items.Add('Keyboard');
  vMame.Config.Panel.Controls_Map.Combobox[4].Items.Add('Mouse');
  vMame.Config.Panel.Controls_Map.Combobox[4].Items.Add('Joystick');
  vMame.Config.Panel.Controls_Map.Combobox[4].Items.Add('Lightgun');
  vMame.Config.Panel.Controls_Map.Combobox[4].ItemIndex:= 0;
  vMame.Config.Panel.Controls_Map.Combobox[4].Tag:= 4;
  vMame.Config.Panel.Controls_Map.Combobox[4].ItemIndex:= uEmu_Arcade_Mame_Config_ControllerMapping_LoadContMapping(mame.Emu.Ini.CORE_INPUT_AUTOMATIC_dial_device);
  vMame.Config.Panel.Controls_Map.Combobox[4].OnChange:= mame.Config.Input.Mouse.Combobox.OnChange;
  vMame.Config.Panel.Controls_Map.Combobox[4].Visible:= True;

  vMame.Config.Panel.Controls_Map.Groupbox[5]:= TGroupBox.Create(vMame.Config.Scene.Right_Panels[9]);
  vMame.Config.Panel.Controls_Map.Groupbox[5].Name:= 'Mame_ControllerMapping_Groupbox_TrackballDevice';
  vMame.Config.Panel.Controls_Map.Groupbox[5].Parent:= vMame.Config.Scene.Right_Panels[9];
  vMame.Config.Panel.Controls_Map.Groupbox[5].SetBounds(((vMame.Config.Scene.Right_Panels[9].Width/ 2)+ 5),115,((vMame.Config.Scene.Right_Panels[9].Width/ 2)- 15),70);
  vMame.Config.Panel.Controls_Map.Groupbox[5].Text:= 'Trackball device';
  vMame.Config.Panel.Controls_Map.Groupbox[5].Visible:= True;

  vMame.Config.Panel.Controls_Map.Combobox[5]:= TComboBox.Create(vMame.Config.Panel.Controls_Map.Groupbox[5]);
  vMame.Config.Panel.Controls_Map.Combobox[5].Name:= 'Mame_ControllerMapping_Combobox_TrackballDevice';
  vMame.Config.Panel.Controls_Map.Combobox[5].Parent:= vMame.Config.Panel.Controls_Map.Groupbox[5];
  vMame.Config.Panel.Controls_Map.Combobox[5].SetBounds(5,25,(vMame.Config.Panel.Controls_Map.Groupbox[5].Width- 10),25);
  vMame.Config.Panel.Controls_Map.Combobox[5].Items.Add('None');
  vMame.Config.Panel.Controls_Map.Combobox[5].Items.Add('Keyboard');
  vMame.Config.Panel.Controls_Map.Combobox[5].Items.Add('Mouse');
  vMame.Config.Panel.Controls_Map.Combobox[5].Items.Add('Joystick');
  vMame.Config.Panel.Controls_Map.Combobox[5].Items.Add('Lightgun');
  vMame.Config.Panel.Controls_Map.Combobox[5].ItemIndex:= 0;
  vMame.Config.Panel.Controls_Map.Combobox[5].Tag:= 5;
  vMame.Config.Panel.Controls_Map.Combobox[5].ItemIndex:= uEmu_Arcade_Mame_Config_ControllerMapping_LoadContMapping(mame.Emu.Ini.CORE_INPUT_AUTOMATIC_trackball_device);
  vMame.Config.Panel.Controls_Map.Combobox[5].OnChange:= mame.Config.Input.Mouse.Combobox.OnChange;
  vMame.Config.Panel.Controls_Map.Combobox[5].Visible:= True;

  vMame.Config.Panel.Controls_Map.Groupbox[6]:= TGroupBox.Create(vMame.Config.Scene.Right_Panels[9]);
  vMame.Config.Panel.Controls_Map.Groupbox[6].Name:= 'Mame_ControllerMapping_Groupbox_LightgunDevice';
  vMame.Config.Panel.Controls_Map.Groupbox[6].Parent:= vMame.Config.Scene.Right_Panels[9];
  vMame.Config.Panel.Controls_Map.Groupbox[6].SetBounds(((vMame.Config.Scene.Right_Panels[9].Width/ 2)+ 5),190,((vMame.Config.Scene.Right_Panels[9].Width/ 2)- 15),70);
  vMame.Config.Panel.Controls_Map.Groupbox[6].Text:= 'Lightgun device';
  vMame.Config.Panel.Controls_Map.Groupbox[6].Visible:= True;

  vMame.Config.Panel.Controls_Map.Combobox[6]:= TComboBox.Create(vMame.Config.Panel.Controls_Map.Groupbox[6]);
  vMame.Config.Panel.Controls_Map.Combobox[6].Name:= 'Mame_ControllerMapping_Combobox_LightgunDevice';
  vMame.Config.Panel.Controls_Map.Combobox[6].Parent:= vMame.Config.Panel.Controls_Map.Groupbox[6];
  vMame.Config.Panel.Controls_Map.Combobox[6].SetBounds(5,25,(vMame.Config.Panel.Controls_Map.Groupbox[6].Width- 10),25);
  vMame.Config.Panel.Controls_Map.Combobox[6].Items.Add('None');
  vMame.Config.Panel.Controls_Map.Combobox[6].Items.Add('Keyboard');
  vMame.Config.Panel.Controls_Map.Combobox[6].Items.Add('Mouse');
  vMame.Config.Panel.Controls_Map.Combobox[6].Items.Add('Joystick');
  vMame.Config.Panel.Controls_Map.Combobox[6].Items.Add('Lightgun');
  vMame.Config.Panel.Controls_Map.Combobox[6].ItemIndex:= 0;
  vMame.Config.Panel.Controls_Map.Combobox[6].Tag:= 6;
  vMame.Config.Panel.Controls_Map.Combobox[6].ItemIndex:= uEmu_Arcade_Mame_Config_ControllerMapping_LoadContMapping(mame.Emu.Ini.CORE_INPUT_AUTOMATIC_lightgun_device);
  vMame.Config.Panel.Controls_Map.Combobox[6].OnChange:= mame.Config.Input.Mouse.Combobox.OnChange;
  vMame.Config.Panel.Controls_Map.Combobox[6].Visible:= True;

  vMame.Config.Panel.Controls_Map.Groupbox[7]:= TGroupBox.Create(vMame.Config.Scene.Right_Panels[9]);
  vMame.Config.Panel.Controls_Map.Groupbox[7].Name:= 'Mame_ControllerMapping_Groupbox_PositionalDevice';
  vMame.Config.Panel.Controls_Map.Groupbox[7].Parent:= vMame.Config.Scene.Right_Panels[9];
  vMame.Config.Panel.Controls_Map.Groupbox[7].SetBounds(((vMame.Config.Scene.Right_Panels[9].Width/ 2)+ 5),265,((vMame.Config.Scene.Right_Panels[9].Width/ 2)- 15),70);
  vMame.Config.Panel.Controls_Map.Groupbox[7].Text:= 'Positional device';
  vMame.Config.Panel.Controls_Map.Groupbox[7].Visible:= True;

  vMame.Config.Panel.Controls_Map.Combobox[7]:= TComboBox.Create(vMame.Config.Panel.Controls_Map.Groupbox[7]);
  vMame.Config.Panel.Controls_Map.Combobox[7].Name:= 'Mame_ControllerMapping_Combobox_PositionalDevice';
  vMame.Config.Panel.Controls_Map.Combobox[7].Parent:= vMame.Config.Panel.Controls_Map.Groupbox[7];
  vMame.Config.Panel.Controls_Map.Combobox[7].SetBounds(5,25,(vMame.Config.Panel.Controls_Map.Groupbox[7].Width- 10),25);
  vMame.Config.Panel.Controls_Map.Combobox[7].Items.Add('None');
  vMame.Config.Panel.Controls_Map.Combobox[7].Items.Add('Keyboard');
  vMame.Config.Panel.Controls_Map.Combobox[7].Items.Add('Mouse');
  vMame.Config.Panel.Controls_Map.Combobox[7].Items.Add('Joystick');
  vMame.Config.Panel.Controls_Map.Combobox[7].Items.Add('Lightgun');
  vMame.Config.Panel.Controls_Map.Combobox[7].ItemIndex:= 0;
  vMame.Config.Panel.Controls_Map.Combobox[7].Tag:= 7;
  vMame.Config.Panel.Controls_Map.Combobox[7].ItemIndex:= uEmu_Arcade_Mame_Config_ControllerMapping_LoadContMapping(mame.Emu.Ini.CORE_INPUT_AUTOMATIC_positional_device);
  vMame.Config.Panel.Controls_Map.Combobox[7].OnChange:= mame.Config.Input.Mouse.Combobox.OnChange;
  vMame.Config.Panel.Controls_Map.Combobox[7].Visible:= True;
end;

function uEmu_Arcade_Mame_Config_ControllerMapping_LoadContMapping(vType: String): integer;
begin
  if vType= 'none' then
    Result:= 0
  else if vType= 'keyboard' then
    Result:= 1
  else if vType= 'mouse' then
    Result:= 2
  else if vType= 'joystick' then
    Result:= 3
  else if vType= 'lightgun' then
    Result:= 4;
end;

procedure uEmu_Arcade_Mame_Config_ControllerMapping_SetContMapping(vItemIndex, vDevice: integer);
var
  vResult: String;
begin
  case vItemIndex of
    0 : vResult:= 'none';
    1 : vResult:= 'keyboard';
    2 : vResult:= 'mouse';
    3 : vResult:= 'joystick';
    4 : vResult:= 'lightgun';
  end;

  case vDevice of
    0 : mame.Emu.Ini.CORE_INPUT_AUTOMATIC_paddle_device:= vResult;
    1 : mame.Emu.Ini.CORE_INPUT_AUTOMATIC_adstick_device:= vResult;
    2 : mame.Emu.Ini.CORE_INPUT_AUTOMATIC_pedal_device:= vResult;
    3 : mame.Emu.Ini.CORE_INPUT_AUTOMATIC_mouse_device:= vResult;
    4 : mame.Emu.Ini.CORE_INPUT_AUTOMATIC_dial_device:= vResult;
    5 : mame.Emu.Ini.CORE_INPUT_AUTOMATIC_trackball_device:= vResult;
    6 : mame.Emu.Ini.CORE_INPUT_AUTOMATIC_lightgun_device:= vResult;
    7 : mame.Emu.Ini.CORE_INPUT_AUTOMATIC_positional_device:= vResult;
  end;

end;

end.
