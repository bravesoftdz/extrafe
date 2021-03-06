unit uEmu_Arcade_Mame_Config_Snap_Movie_Playback;

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

  procedure uEmu_Arcade_Mame_Config_Create_Snap_Movie_Playback_Panel;

  function uEmu_Arcade_Mame_Config_SMP_LoadSnapshotSnapView(vSnapView: string): integer;
  function uEmu_Arcade_Mame_Config_SMP_LoadPattern(vPattern: string): integer;
  function uEmu_Arcade_Mame_Config_SMP_LoadSnapSize(vSize: string): Boolean;

  procedure uEmu_Arcade_Mame_Config_SMP_SetSnapshotSnapView(vItemIndex: Integer);
  procedure uEmu_Arcade_Mame_Config_SMP_SetPattern(vItemIndex: Integer);
  procedure uEmu_Arcade_Mame_Config_SMP_SetSnapSize(vIsChecked: Boolean);

  procedure uEmu_Arcade_Mame_Config_SMP_CheckboxClick(vName: String);
  procedure uEmu_Arcade_Mame_Config_SMP_ComboboxOnChange(vName: String);

implementation
uses
  uEmu_Arcade_Mame_AllTypes;

procedure uEmu_Arcade_Mame_Config_Create_Snap_Movie_Playback_Panel;
begin
  vMame.Config.Panel.S_M_P.Labels[0]:= TLabel.Create(vMame.Config.Scene.Right_Panels[12]);
  vMame.Config.Panel.S_M_P.Labels[0].Name:= 'Mame_SMP_InfoLabel_1';
  vMame.Config.Panel.S_M_P.Labels[0].Parent:= vMame.Config.Scene.Right_Panels[12];
  vMame.Config.Panel.S_M_P.Labels[0].TextSettings.HorzAlign:= TTextAlign.Trailing;
  vMame.Config.Panel.S_M_P.Labels[0].Text:= 'Global Options';
  vMame.Config.Panel.S_M_P.Labels[0].Position.Y:= 5;
  vMame.Config.Panel.S_M_P.Labels[0].Position.X:= vMame.Config.Scene.Right_Panels[12].Width- vMame.Config.Panel.S_M_P.Labels[0].Width- 10;
  vMame.Config.Panel.S_M_P.Labels[0].Visible:= True;

  vMame.Config.Panel.S_M_P.Labels[1]:= TLabel.Create(vMame.Config.Scene.Right_Panels[12]);
  vMame.Config.Panel.S_M_P.Labels[1].Name:= 'Mame_SMP_InfoLabel_2';
  vMame.Config.Panel.S_M_P.Labels[1].Parent:= vMame.Config.Scene.Right_Panels[12];
  vMame.Config.Panel.S_M_P.Labels[1].TextSettings.HorzAlign:= TTextAlign.Trailing;
  vMame.Config.Panel.S_M_P.Labels[1].Text:= 'Default options used by all games';
  vMame.Config.Panel.S_M_P.Labels[1].Width:= 180;
  vMame.Config.Panel.S_M_P.Labels[1].Position.Y:= 22;
  vMame.Config.Panel.S_M_P.Labels[1].Position.X:= vMame.Config.Scene.Right_Panels[12].Width- vMame.Config.Panel.S_M_P.Labels[1].Width- 10;
  vMame.Config.Panel.S_M_P.Labels[1].Visible:= True;

  vMame.Config.Panel.S_M_P.Groupbox[0]:= TGroupBox.Create(vMame.Config.Scene.Right_Panels[12]);
  vMame.Config.Panel.S_M_P.Groupbox[0].Name:= 'Mame_SMP_Groupbox_SnapshotViewMode';
  vMame.Config.Panel.S_M_P.Groupbox[0].Parent:= vMame.Config.Scene.Right_Panels[12];
  vMame.Config.Panel.S_M_P.Groupbox[0].SetBounds(10,40,((vMame.Config.Scene.Right_Panels[12].Width/ 2)- 15),70);
  vMame.Config.Panel.S_M_P.Groupbox[0].Text:= 'Snapshot view mode';
  vMame.Config.Panel.S_M_P.Groupbox[0].Visible:= True;

  vMame.Config.Panel.S_M_P.Combobox[0]:= TComboBox.Create(vMame.Config.Panel.S_M_P.Groupbox[0]);
  vMame.Config.Panel.S_M_P.Combobox[0].Name:= 'Mame_SMP_Combobox_SnapshotViewMode';
  vMame.Config.Panel.S_M_P.Combobox[0].Parent:= vMame.Config.Panel.S_M_P.Groupbox[0];
  vMame.Config.Panel.S_M_P.Combobox[0].SetBounds(5,30,(vMame.Config.Panel.S_M_P.Groupbox[0].Width- 10),25);
  vMame.Config.Panel.S_M_P.Combobox[0].Items.Add('Auto');
  vMame.Config.Panel.S_M_P.Combobox[0].Items.Add('Internal');
  vMame.Config.Panel.S_M_P.Combobox[0].Items.Add('Standard');
  vMame.Config.Panel.S_M_P.Combobox[0].Items.Add('Pixel aspect');
  vMame.Config.Panel.S_M_P.Combobox[0].Items.Add('Cocktail');
  vMame.Config.Panel.S_M_P.Combobox[0].ItemIndex:= uEmu_Arcade_Mame_Config_SMP_LoadSnapshotSnapView(mame.Emu.Ini.CORE_STATE_snapview);
  vMame.Config.Panel.S_M_P.Combobox[0].OnChange:= mame.Config.Input.Mouse.Combobox.OnChange;
  vMame.Config.Panel.S_M_P.Combobox[0].Visible:= True;

  vMame.Config.Panel.S_M_P.Groupbox[1]:= TGroupBox.Create(vMame.Config.Scene.Right_Panels[12]);
  vMame.Config.Panel.S_M_P.Groupbox[1].Name:= 'Mame_SMP_Groupbox_SnapshotSize';
  vMame.Config.Panel.S_M_P.Groupbox[1].Parent:= vMame.Config.Scene.Right_Panels[12];
  vMame.Config.Panel.S_M_P.Groupbox[1].SetBounds(10,115,((vMame.Config.Scene.Right_Panels[12].Width/ 2)- 15),100);
  vMame.Config.Panel.S_M_P.Groupbox[1].Text:= 'Snapshot size';
  vMame.Config.Panel.S_M_P.Groupbox[1].Visible:= True;

  vMame.Config.Panel.S_M_P.Labels[2]:= TLabel.Create(vMame.Config.Panel.S_M_P.Groupbox[1]);
  vMame.Config.Panel.S_M_P.Labels[2].Name:= 'Mame_SMP_Label_Size';
  vMame.Config.Panel.S_M_P.Labels[2].Parent:= vMame.Config.Panel.S_M_P.Groupbox[1];
  vMame.Config.Panel.S_M_P.Labels[2].Position.X:= 10;
  vMame.Config.Panel.S_M_P.Labels[2].Position.Y:= 60;
  vMame.Config.Panel.S_M_P.Labels[2].Width:= 180;
  vMame.Config.Panel.S_M_P.Labels[2].Text:= 'Size';
  vMame.Config.Panel.S_M_P.Labels[2].Visible:= True;

  vMame.Config.Panel.S_M_P.Edit[0]:= TEdit.Create(vMame.Config.Panel.S_M_P.Groupbox[1]);
  vMame.Config.Panel.S_M_P.Edit[0].Name:= 'Mame_SMP_Edit_Size_X';
  vMame.Config.Panel.S_M_P.Edit[0].Parent:= vMame.Config.Panel.S_M_P.Groupbox[1];
  vMame.Config.Panel.S_M_P.Edit[0].SetBounds(50,60,50,20);
  vMame.Config.Panel.S_M_P.Edit[0].TextSettings.HorzAlign:= TTextAlign.Trailing;
  vMame.Config.Panel.S_M_P.Edit[0].Text:= '640';
  vMame.Config.Panel.S_M_P.Edit[0].Visible:= True;

  vMame.Config.Panel.S_M_P.Labels[3]:= TLabel.Create(vMame.Config.Panel.S_M_P.Groupbox[1]);
  vMame.Config.Panel.S_M_P.Labels[3].Name:= 'Mame_SMP_Label_SizeX';
  vMame.Config.Panel.S_M_P.Labels[3].Parent:= vMame.Config.Panel.S_M_P.Groupbox[1];
  vMame.Config.Panel.S_M_P.Labels[3].Position.X:= 110;
  vMame.Config.Panel.S_M_P.Labels[3].Position.Y:= 60;
  vMame.Config.Panel.S_M_P.Labels[3].Width:= 180;
  vMame.Config.Panel.S_M_P.Labels[3].Text:= 'X';
  vMame.Config.Panel.S_M_P.Labels[3].Visible:= True;

  vMame.Config.Panel.S_M_P.Edit[1]:= TEdit.Create(vMame.Config.Panel.S_M_P.Groupbox[1]);
  vMame.Config.Panel.S_M_P.Edit[1].Name:= 'Mame_SMP_Edit_Size_Y';
  vMame.Config.Panel.S_M_P.Edit[1].Parent:= vMame.Config.Panel.S_M_P.Groupbox[1];
  vMame.Config.Panel.S_M_P.Edit[1].SetBounds(130,60,50,20);
  vMame.Config.Panel.S_M_P.Edit[1].TextSettings.HorzAlign:= TTextAlign.Trailing;
  vMame.Config.Panel.S_M_P.Edit[1].Text:= '480';
  vMame.Config.Panel.S_M_P.Edit[1].Visible:= True;

  vMame.Config.Panel.S_M_P.Checkbox[0]:= TCheckBox.Create(vMame.Config.Panel.S_M_P.Groupbox[1]);
  vMame.Config.Panel.S_M_P.Checkbox[0].Name:= 'Mame_SMP_Checkbox_SnapshotAutoSize';
  vMame.Config.Panel.S_M_P.Checkbox[0].Parent:= vMame.Config.Panel.S_M_P.Groupbox[1];
  vMame.Config.Panel.S_M_P.Checkbox[0].SetBounds(5,25,180,19);
  vMame.Config.Panel.S_M_P.Checkbox[0].Text:= 'Auto size';
  vMame.Config.Panel.S_M_P.Checkbox[0].Font.Style:= vMame.Config.Panel.S_M_P.Checkbox[0].Font.Style+ [TFontStyle.fsBold];
  vMame.Config.Panel.S_M_P.Checkbox[0].IsChecked:= uEmu_Arcade_Mame_Config_SMP_LoadSnapSize(mame.Emu.Ini.CORE_STATE_snapsize);
  vMame.Config.Panel.S_M_P.Checkbox[0].OnClick:= mame.Config.Input.Mouse.Checkbox.onMouseClick;
  vMame.Config.Panel.S_M_P.Checkbox[0].Visible:= True;

  vMame.Config.Panel.S_M_P.Groupbox[2]:= TGroupBox.Create(vMame.Config.Scene.Right_Panels[12]);
  vMame.Config.Panel.S_M_P.Groupbox[2].Name:= 'Mame_SMP_Groupbox_Pattern';
  vMame.Config.Panel.S_M_P.Groupbox[2].Parent:= vMame.Config.Scene.Right_Panels[12];
  vMame.Config.Panel.S_M_P.Groupbox[2].SetBounds(10,220,(vMame.Config.Scene.Right_Panels[12].Width- 20),70);
  vMame.Config.Panel.S_M_P.Groupbox[2].Text:= 'Pattern';
  vMame.Config.Panel.S_M_P.Groupbox[2].Visible:= True;

  vMame.Config.Panel.S_M_P.Combobox[1]:= TComboBox.Create(vMame.Config.Panel.S_M_P.Groupbox[2]);
  vMame.Config.Panel.S_M_P.Combobox[1].Name:= 'Mame_SMP_Combobox_Pattern';
  vMame.Config.Panel.S_M_P.Combobox[1].Parent:= vMame.Config.Panel.S_M_P.Groupbox[2];
  vMame.Config.Panel.S_M_P.Combobox[1].SetBounds(5,30,(vMame.Config.Panel.S_M_P.Groupbox[2].Width- 10),25);
  vMame.Config.Panel.S_M_P.Combobox[1].Items.Add('Gamename');
  vMame.Config.Panel.S_M_P.Combobox[1].Items.Add('Gamename + increment');
  vMame.Config.Panel.S_M_P.Combobox[1].Items.Add('Gamename/gamename');
  vMame.Config.Panel.S_M_P.Combobox[1].Items.Add('Gamename/gamename + increment');
  vMame.Config.Panel.S_M_P.Combobox[1].Items.Add('Gamename/increment');
  vMame.Config.Panel.S_M_P.Combobox[1].ItemIndex:= uEmu_Arcade_Mame_Config_SMP_LoadPattern(mame.Emu.Ini.CORE_STATE_snapname);
  vMame.Config.Panel.S_M_P.Combobox[1].OnChange:= mame.Config.Input.Mouse.Combobox.OnChange;
  vMame.Config.Panel.S_M_P.Combobox[1].Visible:= True;

  vMame.Config.Panel.S_M_P.Checkbox[1]:= TCheckBox.Create(vMame.Config.Scene.Right_Panels[12]);
  vMame.Config.Panel.S_M_P.Checkbox[1].Name:= 'Mame_SMP_Checkbox_UseBilinearFilteringForMovieRecording';
  vMame.Config.Panel.S_M_P.Checkbox[1].Parent:= vMame.Config.Scene.Right_Panels[12];
  vMame.Config.Panel.S_M_P.Checkbox[1].SetBounds(10,300,280,19);
  vMame.Config.Panel.S_M_P.Checkbox[1].Text:= 'Use bilinear filtering for movie recording';
  vMame.Config.Panel.S_M_P.Checkbox[1].Font.Style:= vMame.Config.Panel.S_M_P.Checkbox[1].Font.Style+ [TFontStyle.fsBold];
  vMame.Config.Panel.S_M_P.Checkbox[1].IsChecked:= mame.Emu.Ini.CORE_STATE_snapbilinear;
  vMame.Config.Panel.S_M_P.Checkbox[1].OnClick:= mame.Config.Input.Mouse.Checkbox.onMouseClick;
  vMame.Config.Panel.S_M_P.Checkbox[1].Visible:= True;

  vMame.Config.Panel.S_M_P.Checkbox[2]:= TCheckBox.Create(vMame.Config.Scene.Right_Panels[12]);
  vMame.Config.Panel.S_M_P.Checkbox[2].Name:= 'Mame_SMP_Checkbox_CreateBurnInSnapshotsForEachScreen';
  vMame.Config.Panel.S_M_P.Checkbox[2].Parent:= vMame.Config.Scene.Right_Panels[12];
  vMame.Config.Panel.S_M_P.Checkbox[2].SetBounds(10,320,280,19);
  vMame.Config.Panel.S_M_P.Checkbox[2].Text:= 'Create burn-in snapshots for each screen';
  vMame.Config.Panel.S_M_P.Checkbox[2].Font.Style:= vMame.Config.Panel.S_M_P.Checkbox[2].Font.Style+ [TFontStyle.fsBold];
  vMame.Config.Panel.S_M_P.Checkbox[2].IsChecked:= mame.Emu.Ini.CORE_STATE_burnin;
  vMame.Config.Panel.S_M_P.Checkbox[2].OnClick:= mame.Config.Input.Mouse.Checkbox.onMouseClick;
  vMame.Config.Panel.S_M_P.Checkbox[2].Visible:= True;

  vMame.Config.Panel.S_M_P.Checkbox[3]:= TCheckBox.Create(vMame.Config.Scene.Right_Panels[12]);
  vMame.Config.Panel.S_M_P.Checkbox[3].Name:= 'Mame_SMP_Checkbox_ExitFromMAMEWhenINPPlaybackIsFinished';
  vMame.Config.Panel.S_M_P.Checkbox[3].Parent:= vMame.Config.Scene.Right_Panels[12];
  vMame.Config.Panel.S_M_P.Checkbox[3].SetBounds(10,340,280,19);
  vMame.Config.Panel.S_M_P.Checkbox[3].Text:= 'Exit from MAME when INP playback is finished';
  vMame.Config.Panel.S_M_P.Checkbox[3].Font.Style:= vMame.Config.Panel.S_M_P.Checkbox[1].Font.Style+ [TFontStyle.fsBold];
  vMame.Config.Panel.S_M_P.Checkbox[3].IsChecked:= mame.Emu.Ini.CORE_STATE_exit_after_playback;
  vMame.Config.Panel.S_M_P.Checkbox[3].OnClick:= mame.Config.Input.Mouse.Checkbox.onMouseClick;
  vMame.Config.Panel.S_M_P.Checkbox[3].Visible:= True;
end;


function uEmu_Arcade_Mame_Config_SMP_LoadSnapshotSnapView(vSnapView: string): integer;
begin
  if vSnapView= 'auto' then
    Result:= 0
  else if vSnapView= 'internal' then
    Result:= 1
  else if vSnapView= 'standard' then
    Result:= 2
  else if vSnapView= 'pixel' then
    Result:= 3
  else if vSnapView= 'cocktail' then
    Result:= 4;
end;

function uEmu_Arcade_Mame_Config_SMP_LoadPattern(vPattern: string): integer;
begin
  if vPattern= '%g' then
    Result:= 0
  else if vPattern= '%g%i' then
    Result:= 1
  else if vPattern= '%g/%g' then
    Result:= 2
  else if vPattern= '%g/%g%i' then
    Result:= 3
  else if vPattern= '%g/%i' then
    Result:= 4;
end;

function uEmu_Arcade_Mame_Config_SMP_LoadSnapSize(vSize: string): Boolean;
var
  iPos: Integer;
  vT,VT1: string;
begin
  if mame.Emu.Ini.CORE_STATE_snapsize= 'auto' then
    begin
      vMame.Config.Panel.S_M_P.Edit[0].Enabled:= False;
      vMame.Config.Panel.S_M_P.Edit[1].Enabled:= False;
      Result:= True;
    end
  else
    begin
      vMame.Config.Panel.S_M_P.Edit[0].Enabled:= True;
      vMame.Config.Panel.S_M_P.Edit[1].Enabled:= True;
      iPos:= Pos('x', vSize);
      vT:= Trim(Copy(vSize, 0, iPos- 1));
      VT1:= Trim(Copy(vSize, iPos+ 1, length(vSize)- (ipos+ 1) ));
      vMame.Config.Panel.S_M_P.Edit[0].Text:= vT;
      vMame.Config.Panel.S_M_P.Edit[1].Text:= vT1;
      Result:= False;
    end;
end;

procedure uEmu_Arcade_Mame_Config_SMP_SetSnapshotSnapView(vItemIndex: Integer);
begin
  case vItemIndex of
    0 : mame.Emu.Ini.CORE_STATE_snapview:= 'auto';
    1 : mame.Emu.Ini.CORE_STATE_snapview:= 'internal';
    2 : mame.Emu.Ini.CORE_STATE_snapview:= 'standard';
    3 : mame.Emu.Ini.CORE_STATE_snapview:= 'pixel';
    4 : mame.Emu.Ini.CORE_STATE_snapview:= 'cocktail';
  end;
end;

procedure uEmu_Arcade_Mame_Config_SMP_SetPattern(vItemIndex: Integer);
begin
  case vItemIndex of
    0 : mame.Emu.Ini.CORE_STATE_snapname:= '%g';
    1 : mame.Emu.Ini.CORE_STATE_snapname:= '%g%i';
    2 : mame.Emu.Ini.CORE_STATE_snapname:= '%g/%g';
    3 : mame.Emu.Ini.CORE_STATE_snapname:= '%g/%g%i';
    4 : mame.Emu.Ini.CORE_STATE_snapname:= '%g/%i';
  end;
end;

procedure uEmu_Arcade_Mame_Config_SMP_SetSnapSize(vIsChecked: Boolean);
begin
  if vIsChecked= True then
    begin
      vMame.Config.Panel.S_M_P.Edit[0].Enabled:= False;
      vMame.Config.Panel.S_M_P.Edit[1].Enabled:= False;
      mame.Emu.Ini.CORE_STATE_snapsize:= 'auto'
    end
  else
    begin
      vMame.Config.Panel.S_M_P.Edit[0].Enabled:= True;
      vMame.Config.Panel.S_M_P.Edit[1].Enabled:= True;
      mame.Emu.Ini.CORE_STATE_snapsize:= vMame.Config.Panel.S_M_P.Edit[0].Text+ 'x'+ vMame.Config.Panel.S_M_P.Edit[1].Text;
    end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure uEmu_Arcade_Mame_Config_SMP_CheckboxClick(vName: String);
begin
  if vName= 'Mame_SMP_Checkbox_SnapshotAutoSize' then
    uEmu_Arcade_Mame_Config_SMP_SetSnapSize(vMame.Config.Panel.S_M_P.Checkbox[0].IsChecked)
  else if vName= 'Mame_SMP_Checkbox_UseBilinearFilteringForMovieRecording' then
    mame.Emu.Ini.CORE_STATE_snapbilinear:= vMame.Config.Panel.S_M_P.Checkbox[1].IsChecked
  else if vName= 'Mame_SMP_Checkbox_CreateBurnInSnapshotsForEachScreen' then
    mame.Emu.Ini.CORE_STATE_burnin:= vMame.Config.Panel.S_M_P.Checkbox[2].IsChecked
  else if vName= 'Mame_SMP_Checkbox_ExitFromMAMEWhenINPPlaybackIsFinished' then
    mame.Emu.Ini.CORE_STATE_exit_after_playback:= vMame.Config.Panel.S_M_P.Checkbox[3].IsChecked;
end;

procedure uEmu_Arcade_Mame_Config_SMP_ComboboxOnChange(vName: String);
begin
  if vName= 'Mame_SMP_Combobox_SnapshotViewMode' then
    uEmu_Arcade_Mame_Config_SMP_SetSnapshotSnapView(vMame.Config.Panel.S_M_P.Combobox[0].ItemIndex)
  else if vName= 'Mame_SMP_Combobox_Pattern' then
    uEmu_Arcade_Mame_Config_SMP_SetPattern(vMame.Config.Panel.S_M_P.Combobox[1].ItemIndex);
end;

end.
