unit uEmu_Actions;

interface
uses
  System.Classes,
  System.UITypes,
  FMX.Forms;

procedure uEmu_LoadEmulator(vNum: Integer);
procedure uEmu_Actions_Exit;

procedure uEmu_Actions_VirtualKeyboard_SetKey(vKey: String);

procedure Search(vEmulator: String; vAction: Boolean);

procedure Key(vKey: String);

implementation
uses
  emu,
  uEmu_Emu,
  uLoad,
  uLoad_AllTypes,
  main,
  uMain_AllTypes,
  //Mame
  uEmu_Arcade_Mame,
  uEmu_Arcade_Mame_Actions,
  uEmu_Arcade_Mame_Keyboard;

procedure uEmu_Actions_VirtualKeyboard_SetKey(vKey: String);
begin
  case emulation.Active_Num of
    0 : uEmu_Arcade_Mame_Keyboard.VirtualKeyboard_SetKey(vKey);
  end;
end;

procedure uEmu_LoadEmulator(vNum: Integer);
begin
  Emu_Form.WindowState:= TWindowState.wsMaximized;
  case vNum of
    0: uEmu_Arcade_Mame.Load;
  end;
end;

procedure uEmu_Actions_Exit;
begin
  mainScene.Main.Down_Level_Ani.Name := 'Main_Down_Animation_Back';
  mainScene.Main.Down_Level_Ani.StartValue := 0.1;
  mainScene.Main.Down_Level_Ani.StopValue := 1;
  mainScene.Main.Down_Level_Ani.Duration := 1;
  mainScene.Main.Down_Level_Ani.Start;
  Emu_Form.Close;
  Main_Form.ShowModal;
end;

procedure Search(vEmulator: String; vAction: Boolean);
begin
  if vEmulator = 'mame' then
    uEmu_Arcade_Mame_Actions.Search(vAction);
end;

procedure Key(vKey: String);
begin
  uEmu_Emu.Key_View_Mode(vKey);
end;

end.
