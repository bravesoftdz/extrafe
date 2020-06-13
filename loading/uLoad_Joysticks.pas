unit uLoad_Joysticks;

interface

uses
  System.Classes,
  System.SysUtils,
  FireDAC.Comp.Client;

procedure Get_Empty_Joy_Settings_MMSystem(vJoy_Num: Integer);
procedure Get_Values_Joy_Settings_MMSystem(vJoy_Num: Integer; vQuery: TFDQuery);

procedure Get_MMSystem_Joysticks;
procedure Get_Direct_Input_Joysticks;
procedure Get_X_Input_Joysticks;

implementation

uses
  uDB,
  uDB_AUser,
  uJoystick_mms;

procedure Get_Empty_Joy_Settings_MMSystem(vJoy_Num: Integer);
begin
  if vJoy_Num = 1 then
  begin
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Up := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Down := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Left := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Right := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_1 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_2 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_3 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_4 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_5 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_6 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_7 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_8 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_9 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_10 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_11 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_12 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_13 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_14 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_15 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_16 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Up := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Down := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Left := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Right := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_1 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_2 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_3 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_4 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_5 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_6 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_7 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_8 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_9 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_10 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_11 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_12 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_13 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_14 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_15 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_16 := '';
  end
  else if vJoy_Num = 2 then
  begin
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Up := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Down := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Left := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Right := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_1 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_2 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_3 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_4 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_5 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_6 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_7 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_8 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_9 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_10 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_11 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_12 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_13 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_14 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_15 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_16 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Up := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Down := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Left := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Right := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_1 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_2 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_3 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_4 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_5 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_6 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_7 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_8 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_9 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_10 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_11 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_12 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_13 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_14 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_15 := '';
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_16 := '';
  end;
end;

procedure Get_Values_Joy_Settings_MMSystem(vJoy_Num: Integer; vQuery: TFDQuery);
begin
  if vJoy_Num = 1 then
  begin
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Button_Num := vQuery.FieldByName('button_num').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.POV := vQuery.FieldByName('pov').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.ForceBack := vQuery.FieldByName('forceback').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Up := vQuery.FieldByName('up').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Down := vQuery.FieldByName('down').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Left := vQuery.FieldByName('left').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Right := vQuery.FieldByName('right').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_1 := vQuery.FieldByName('button_1').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_2 := vQuery.FieldByName('button_2').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_3 := vQuery.FieldByName('button_3').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_4 := vQuery.FieldByName('button_4').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_5 := vQuery.FieldByName('button_5').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_6 := vQuery.FieldByName('button_6').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_7 := vQuery.FieldByName('button_7').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_8 := vQuery.FieldByName('button_8').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_9 := vQuery.FieldByName('button_9').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_10 := vQuery.FieldByName('button_10').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_11 := vQuery.FieldByName('button_11').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_12 := vQuery.FieldByName('button_12').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_13 := vQuery.FieldByName('button_13').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_14 := vQuery.FieldByName('button_14').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_15 := vQuery.FieldByName('button_15').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.General.Button_16 := vQuery.FieldByName('button_16').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Up := vQuery.FieldByName('emu_up').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Down := vQuery.FieldByName('emu_down').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Left := vQuery.FieldByName('emu_left').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Right := vQuery.FieldByName('emu_right').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_1 := vQuery.FieldByName('emu_button_1').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_2 := vQuery.FieldByName('emu_button_2').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_3 := vQuery.FieldByName('emu_button_3').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_4 := vQuery.FieldByName('emu_button_4').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_5 := vQuery.FieldByName('emu_button_5').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_6 := vQuery.FieldByName('emu_button_6').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_7 := vQuery.FieldByName('emu_button_7').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_8 := vQuery.FieldByName('emu_button_8').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_9 := vQuery.FieldByName('emu_button_9').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_10 := vQuery.FieldByName('emu_button_10').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_11 := vQuery.FieldByName('emu_button_11').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_12 := vQuery.FieldByName('emu_button_12').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_13 := vQuery.FieldByName('emu_button_13').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_14 := vQuery.FieldByName('emu_button_14').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_15 := vQuery.FieldByName('emu_button_15').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Emulators.Button_16 := vQuery.FieldByName('emu_button_16').AsString;
  end
  else if vJoy_Num = 2 then
  begin
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Button_Num := vQuery.FieldByName('button_num').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.POV := vQuery.FieldByName('pov').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.ForceBack := vQuery.FieldByName('forceback').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Up := vQuery.FieldByName('up').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Down := vQuery.FieldByName('down').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Left := vQuery.FieldByName('left').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Right := vQuery.FieldByName('right').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_1 := vQuery.FieldByName('button_1').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_2 := vQuery.FieldByName('button_2').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_3 := vQuery.FieldByName('button_3').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_4 := vQuery.FieldByName('button_4').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_5 := vQuery.FieldByName('button_5').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_6 := vQuery.FieldByName('button_6').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_7 := vQuery.FieldByName('button_7').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_8 := vQuery.FieldByName('button_8').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_9 := vQuery.FieldByName('button_9').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_10 := vQuery.FieldByName('button_10').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_11 := vQuery.FieldByName('button_11').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_12 := vQuery.FieldByName('button_12').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_13 := vQuery.FieldByName('button_13').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_14 := vQuery.FieldByName('button_14').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_15 := vQuery.FieldByName('button_15').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.General.Button_16 := vQuery.FieldByName('button_16').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Up := vQuery.FieldByName('emu_up').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Down := vQuery.FieldByName('emu_down').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Left := vQuery.FieldByName('emu_left').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Right := vQuery.FieldByName('emu_right').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_1 := vQuery.FieldByName('emu_button_1').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_2 := vQuery.FieldByName('emu_button_2').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_3 := vQuery.FieldByName('emu_button_3').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_4 := vQuery.FieldByName('emu_button_4').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_5 := vQuery.FieldByName('emu_button_5').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_6 := vQuery.FieldByName('emu_button_6').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_7 := vQuery.FieldByName('emu_button_7').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_8 := vQuery.FieldByName('emu_button_8').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_9 := vQuery.FieldByName('emu_button_9').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_10 := vQuery.FieldByName('emu_button_10').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_11 := vQuery.FieldByName('emu_button_11').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_12 := vQuery.FieldByName('emu_button_12').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_13 := vQuery.FieldByName('emu_button_13').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_14 := vQuery.FieldByName('emu_button_14').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_15 := vQuery.FieldByName('emu_button_15').AsString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Emulators.Button_16 := vQuery.FieldByName('emu_button_16').AsString;
  end;
end;

procedure Get_MMSystem_Joysticks;
begin
  uJoystick_mms.Refresh_Joys;

  if uJoystick_mms.vJoy_mm_1.Joy_Connected then
  begin
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Name := uJoystick_mms.vJoy_mm_1.Joy_Name;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Manufacturer := uJoystick_mms.vJoy_mm_1.Manufacturer_Name;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Product := uJoystick_mms.vJoy_mm_1.Product_Name;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Reg := uJoystick_mms.vJoy_mm_1.Reg_KEY;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.OEM := uJoystick_mms.vJoy_mm_1.OEM_Name;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Button_Num := uJoystick_mms.vJoy_mm_1.ButtonCount.ToString;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.POV := uJoystick_mms.vJoy_mm_1.HasPOV.ToString;
    // uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.ForceBack := vQuery.FieldByName('forceback').AsString;

    uDB.ExtraFE_Query_Local.Close;
    uDB.ExtraFE_Query_Local.SQL.Clear;
    uDB.ExtraFE_Query_Local.SQL.Text := 'SELECT * FROM map_joystick_mmsystem WHERE manufacturer_name=''' +
      uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Manufacturer + ''' AND product_name=''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Product +
      ''' AND regkey=''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Reg + ''' AND szoem=''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.OEM +
      ''' AND user_id=''' + uDB_AUser.Local.USER.Num.ToString + ''' AND position=1 AND name=''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Name + '''';
    uDB.ExtraFE_Query_Local.Open;

    if uDB.ExtraFE_Query_Local.RecordCount = 0 then
    begin
      uDB.ExtraFE_Query_Local.Close;
      uDB.ExtraFE_Query_Local.SQL.Clear;
      uDB.ExtraFE_Query_Local.SQL.Add('INSERT INTO map_joystick_mmsystem (user_id, manufacturer_name, product_name, regkey, szoem, position, name) VALUES (''' +
        uDB_AUser.Local.USER.Num.ToString + ''', ''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Manufacturer + ''', ''' +
        uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Product + ''', ''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Reg + ''', ''' +
        uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.OEM + ''', "1", ''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Name + ''')');
      uDB.ExtraFE_Query_Local.ExecSQL;
      Get_Empty_Joy_Settings_MMSystem(1);
    end
    else
    begin
      uDB.ExtraFE_Query_Local.Close;
      uDB.ExtraFE_Query_Local.SQL.Clear;
      uDB.ExtraFE_Query_Local.SQL.Add('UPDATE map_joystick_mmsystem SET position=1 WHERE manufacturer_name=''' +
        uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Manufacturer + ''' AND product_name=''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Product +
        ''' AND regkey=''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Reg + ''' AND szoem=''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.OEM +
        ''' AND user_id=''' + uDB_AUser.Local.USER.Num.ToString + ''' AND name=''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Name + '''');
      uDB.ExtraFE_Query_Local.ExecSQL;

      uDB.ExtraFE_Query_Local.Close;
      uDB.ExtraFE_Query_Local.SQL.Clear;
      uDB.ExtraFE_Query_Local.SQL.Text := 'SELECT * FROM map_joystick_mmsystem WHERE manufacturer_name=''' +
        uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Manufacturer + ''' AND product_name=''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Product +
        ''' AND regkey=''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Reg + ''' AND szoem=''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.OEM +
        ''' AND user_id=''' + uDB_AUser.Local.USER.Num.ToString + ''' AND position=1 AND name=''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_1.Name + '''';
      uDB.ExtraFE_Query_Local.Open;
      Get_Values_Joy_Settings_MMSystem(1, uDB.ExtraFE_Query_Local);
    end;
  end;

  if uJoystick_mms.vJoy_mm_2.Joy_Connected then
  begin
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Name := uJoystick_mms.vJoy_mm_2.Joy_Name;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Manufacturer := uJoystick_mms.vJoy_mm_2.Manufacturer_Name;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Product := uJoystick_mms.vJoy_mm_2.Product_Name;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Reg := uJoystick_mms.vJoy_mm_2.Reg_KEY;
    uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.OEM := uJoystick_mms.vJoy_mm_2.OEM_Name;

    uDB.ExtraFE_Query_Local.Close;
    uDB.ExtraFE_Query_Local.SQL.Clear;
    uDB.ExtraFE_Query_Local.SQL.Text := 'SELECT * FROM map_joystick_mmsystem WHERE manufacturer_name=''' +
      uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Manufacturer + ''' AND product_name=''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Product +
      ''' AND regkey=''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Reg + ''' AND szoem=''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.OEM +
      ''' AND user_id=''' + uDB_AUser.Local.USER.Num.ToString + ''' AND position=2 AND name=''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Name + '''';
    uDB.ExtraFE_Query_Local.Open;

    if uDB.ExtraFE_Query_Local.RecordCount = 0 then
    begin
      uDB.ExtraFE_Query_Local.Close;
      uDB.ExtraFE_Query_Local.SQL.Clear;
      uDB.ExtraFE_Query_Local.SQL.Add('INSERT INTO map_joystick_mmsystem (user_id, manufacturer_name, product_name, regkey, szoem, position, name) VALUES (''' +
        uDB_AUser.Local.USER.Num.ToString + ''', ''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Manufacturer + ''', ''' +
        uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Product + ''', ''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Reg + ''', ''' +
        uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.OEM + ''', "2", ''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Name + ''')');
      uDB.ExtraFE_Query_Local.ExecSQL;
    end
    else
    begin
      uDB.ExtraFE_Query_Local.Close;
      uDB.ExtraFE_Query_Local.SQL.Clear;
      uDB.ExtraFE_Query_Local.SQL.Add('UPDATE map_joystick_mmsystem SET position=2 WHERE manufacturer_name=''' +
        uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Manufacturer + ''' AND product_name=''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Product +
        ''' AND regkey=''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Reg + ''' AND szoem=''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.OEM +
        ''' AND user_id=''' + uDB_AUser.Local.USER.Num.ToString + ''' AND name=''' + uDB_AUser.Local.MAP.Joystick.mmSystem.Joy_2.Name + '''');
      uDB.ExtraFE_Query_Local.ExecSQL;
    end;
  end;
end;

procedure Get_Direct_Input_Joysticks;
begin

end;

procedure Get_X_Input_Joysticks;
begin

end;

end.
