unit uMain;

interface
uses
  System.Classes,
  System.SysUtils,
  System.UITypes,
  FMX.Objects,
  FMX.Controls,
  FMX.Forms,
  uWindows,
  windows,
  uLoad;

  procedure uMain_Load;

  procedure uMain_Exit;
  procedure uMain_Exit_Exit;
  procedure uMain_Exit_SaveProgress;
  procedure uMain_Exit_Stay;
  procedure uMain_Exit_OnOverText(vButton_Text: String; vLeave: Boolean);

  procedure uMain_Minimized;

implementation
uses
  main,
  uLoad_AllTypes,
  load,
  uEmu_SetAll,
  emu,
  uDB,
  uMain_Emulation,
  uMain_SetAll,
  uMain_AllTypes,
  uMain_Actions,
  uMain_Config_Info,
  uMain_Config_Themes,
  uMain_Config_Profile,
  uSoundplayer_Actions;

procedure uMain_Load;
begin
  //Set the form state
  Main_Form.Width:= extrafe.res.Width;
  Main_Form.Height:= extrafe.res.Height;
  Main_Form.FullScreen:= extrafe.res.Fullscreen;
  //Set all the components
  uMain_SetAll_Set;
  //Set the standard values
  //Header
  ex_main.Settings.Header_Pos.X:= 0;
  ex_main.Settings.Header_Pos.Y:= 0;
  //Selection
  ex_main.Settings.MainSelection_Pos.X:= 0;
  ex_main.Settings.MainSelection_Pos.Y:= mainScene.Selection.Back.Position.Y;
  //Footer
  ex_main.Settings.Footer_Pos.X:= 0;
  ex_main.Settings.Footer_Pos.Y:= mainScene.Footer.Back.Position.Y;

  //Emulators Default
  uEmu_SetComponentsToRightPlace;
//  if emulation.Active then
//    if emulation.ShowCat then

  uMain_Emulation_Category(0);

  //extrafe state
  extrafe.prog.State:= 'main';
end;

procedure uMain_Exit;
begin
  uMain_SetAll_Exit;
end;

procedure uMain_Exit_SaveProgress;
begin
//  if extrafe.databases.online_connected then
//  begin
//    uDB.ExtraFE_DB.Disconnect;
//    FreeAndNil(uDB.ExtraFE_DB);
//  end;
//  uDB.ExtraFE_Query_Local.Close;
//  uDB.ExtraFE_DB_Local.Connected:= False;
//  FreeAndNil(uDB.ExtraFE_DB_Local);
end;

procedure uMain_Exit_Exit;
begin
  uMain_Exit_SaveProgress;
  //  ReportMemoryLeaksOnShutdown:= True;
  Main_Form.Close;
end;

procedure uMain_Exit_Stay;
begin
  mainScene.Header.Back_Blur.Enabled:= False;
  mainScene.Selection.Blur.Enabled:= False;
  mainScene.Footer.Back_Blur.Enabled:= False;
  FreeAndNil(mainScene.Main.Prog_Exit.Panel);
  extrafe.prog.State:= 'main';
end;

procedure uMain_Exit_OnOverText(vButton_Text: String; vLeave: Boolean);
begin
  if vLeave then
  begin
    if vButton_Text= 'Yes' then
      mainScene.Main.Prog_Exit.Main.Yes.Text:= 'Sorry, I have to go'
    else if vButton_Text= 'No' then
      mainScene.Main.Prog_Exit.Main.No.Text:= 'One minute more, please';
  end
  else
  begin
    if vButton_Text= 'Yes' then
      mainScene.Main.Prog_Exit.Main.Yes.Text:= 'No, no don''t push it'
    else if vButton_Text= 'No' then
      mainScene.Main.Prog_Exit.Main.No.Text:= 'Push it damn it';
  end;
end;

procedure uMain_Minimized;
begin
  Main_Form.FullScreen:= False;
  Main_Form.WindowState:= TWindowState.wsMinimized;
end;

end.
