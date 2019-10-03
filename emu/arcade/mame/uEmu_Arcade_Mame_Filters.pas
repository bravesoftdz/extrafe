unit uEmu_Arcade_Mame_Filters;

interface

uses
  System.Classes,
  System.UiTypes,
  System.SysUtils,
  System.Inifiles,
  FMX.Objects,
  FMX.Listbox,
  FMX.StdCtrls,
  FMX.Effects,
  FMX.Types;

type
  TEMU_ARCADE_MAME_FILTER_COMBOBOX = class(TObject)
    procedure OnChange(Sender: TObject);
  end;

type
  TEMU_ARCADE_MAME_FILTER_BUTTON = class(TObject)
    procedure OnClick(Sender: TObject);
  end;

procedure uEmu_Arcade_Mame_Filters_SetAll;

var
  vFilter_Panel: TImage;
  vFilter_Shandow: TShadowEffect;
  vFilter_Head: TText;
  vFilter_Combo: TComboBox;
  vFilter_Label_Info: TLabel;
  vFilter_Label_Info_2: TLabel;
  vFilter_Start: TButton;
  vFilter_Progress_Bar: TProgressBar;
  vFilter_OK: TButton;
  vFilter_Cancel: TButton;
  vFilter_Comp_Combobox: TEMU_ARCADE_MAME_FILTER_COMBOBOX;
  vFilter_Comp_Button: TEMU_ARCADE_MAME_FILTER_BUTTON;


procedure uEmu_Arcade_Mame_Filters_Free;

procedure uEmu_Arcade_Mame_Filters_SetFilter;

procedure uEmu_Arcade_Mame_Filters_ButtonOK_Standard;

procedure uEmu_Arcade_Mame_Filters_Load_Filter(vFilterName: String);

procedure uEmu_Arcade_Mame_Filters_Info(vItem: Integer; vFilterName: String);

{ procedure uEmu_Arcade_Mame_Filters_SetCurrentFilter_Load;


  procedure uEmu_Arcade_Mame_Filters_Create_All;
  procedure uEmu_Arcade_Mame_Filters_All_OK;

  procedure uEmu_Arcade_Mame_Filters_Create_Available;
  procedure uEmu_Arcade_Mame_Filters_Create_Available_Start;
  procedure uEmu_Arcade_Mame_Filters_Available_OK;

  procedure uEmu_Arcade_Mame_Filters_Create_Unavailable;
  procedure uEmu_Arcade_Mame_Filters_Create_Unavailable_Start;
  procedure uEmu_Arcade_Mame_Filters_Unavailable_OK;

  procedure uEmu_Arcade_Mame_Filters_Create_Working_Arcade;
  procedure uEmu_Arcade_Mame_Filters_Working_Arcade_OK;

  procedure uEmu_Arcade_Mame_Filters_Create_NotWorking_Arcade;
  procedure uEmu_Arcade_mame_Filters_NotWorking_Arcade_OK;

  procedure uEmu_Arcade_Mame_Filters_Create_Mechanical_Arcade;
  procedure uEmu_Arcade_Mame_Filters_Mechaniacal_Arcade_OK;

  procedure uEmu_Arcade_Mame_Filters_Create_NotMechanical_Arcade;
  procedure uEmu_Arcade_Mame_Filters_NotMechanical_Aracade_OK;

  procedure uEmu_Arcade_Mame_Filters_Create_Original_Arcade;
  procedure uEmu_Arcade_Mame_Filters_Create_Clones_Arcade;
  procedure uEmu_Arcade_Mame_Filters_Create_Manufacturer;
  procedure uEmu_Arcade_Mame_Filters_Create_Year;
  procedure uEmu_Arcade_Mame_Filters_Create_Best_Games_By_Users_Rating;
  procedure uEmu_Arcade_Mame_Filters_Create_Gerne;
  procedure uEmu_Arcade_Mame_Filters_Create_Series;
  procedure uEmu_Arcade_Mame_Filters_Create_Version;


  procedure uEmu_Arcade_Mame_Filters_Create_CustomFilters; }

implementation

uses
  uDatabase_ActiveUser,
  uDatabase_SQLCommands,
  uLoad_AllTypes,
  emu,
  uWindows,
  uEmu_Arcade_Mame,
  uEmu_Arcade_Mame_Gamelist,
  uEmu_Arcade_Mame_AllTypes,
  uEmu_Arcade_Mame_Ini;

procedure uEmu_Arcade_Mame_Filters_Load_Filter(vFilterName: String);
var
  vi, vk: Integer;
  vPos: Integer;
  vLine: String;
  vRomName: String;
  vGameName: String;
  vListRoms: Tstringlist;
  vListNames: Tstringlist;
  vList: Tstringlist;
begin
  vList := Tstringlist.Create;
{  if vFilterName = 'All_Unfiltered' then
    vList.LoadFromFile(user_Active_Local.EMULATORS.Arcade_D.Mame_D.p_Database+ 'gamelist.txt');

  SetLength(mame.Gamelist.List, 31);
  for vi := 0 to 30 do
    for vk := 0 to vList.Count - 1 do
      SetLength(mame.Gamelist.List[vi], vk);

  for vi := 0 to 30 do
    for vk := 0 to vList.Count - 1 do
      SetLength(mame.Gamelist.List[vi, vk], 2);

  vListRoms := Tstringlist.Create;
  vListNames := Tstringlist.Create;

  for vi := 0 to vList.Count - 1 do
  begin
    vLine := vList.Strings[vi];
    vPos := Pos(' ', vLine);
    vRomName := Trim(Copy(vLine, 0, vPos + 1));
    if vRomName <> 'Name:' then
    begin
      vListRoms.Add(vRomName);
      vGameName := Trim(Copy(vLine, vPos + 1, length(vLine) - (vPos - 1)));
      Delete(vGameName, 1, 1);
      Delete(vGameName, length(vGameName), 1);
      vListNames.Add(vGameName);
    end;
  end;

  vList.Clear;

  for vi := 0 to vListRoms.Count - 1 do
    vList.Add(vListNames[vi] + ' "' + vListRoms[vi] + '"');

  vList.Sort;

  vListRoms.Free;
  vListNames.Free;

  mame.Gamelist.Games_Count := vList.Count - 1;
  for vi := 0 to vList.Count - 1 do
  begin
    vLine := vList.Strings[vi];
    vPos := Pos('"', vLine);
    vGameName := Trim(Copy(vLine, 0, vPos - 1));
    vRomName := Trim(Copy(vLine, vPos + 1, length(vLine) - (vPos - 1)));
    Delete(vRomName, length(vRomName), 1);
    mame.Gamelist.List[0, vi, 0] := vRomName;
    mame.Gamelist.List[0, vi, 1] := vGameName;
  end;}
end;

/// /

procedure uEmu_Arcade_Mame_Filters_SetAll;
begin
  if vMame.Scene.Snap.Video.IsPlay then
    vMame.Scene.Snap.Video.Pause;
  extrafe.Prog.State := 'mame_filters';
  vMame.Scene.Left_Blur.Enabled := True;
  vMame.Scene.Right_Blur.Enabled := True;

  vMame.Scene.Settings_Ani.Enabled := False;

  vFilter_Panel := TImage.Create(vMame.Scene.Main);
  vFilter_Panel.Name := 'Filter_Panel';
  vFilter_Panel.Parent := vMame.Scene.Main;
  vFilter_Panel.Width := 550;
  vFilter_Panel.Height := 300;
  vFilter_Panel.Position.X := vMame.Scene.Left.Width - 275;
  vFilter_Panel.Position.Y := 250;
  vFilter_Panel.WrapMode := TImageWrapMode.Tile;
  vFilter_Panel.Visible := True;

  vFilter_Shandow := TShadowEffect.Create(vFilter_Panel);
  vFilter_Shandow.Name := 'Filter_Panel_Shandow';
  vFilter_Shandow.Parent := vFilter_Panel;
  vFilter_Shandow.Enabled := True;

  vFilter_Head := TText.Create(vFilter_Panel);
  vFilter_Head.Name := 'Filter_Head';
  vFilter_Head.Parent := vFilter_Panel;
  vFilter_Head.Width := 380;
  vFilter_Head.Height := 22;
  vFilter_Head.Position.X := 10;
  vFilter_Head.Position.Y := 10;
  vFilter_Head.Color := TAlphaColorRec.White;
  vFilter_Head.Text := 'Filters';
  vFilter_Head.Font.Family := 'Tahoma';
  vFilter_Head.Font.Style := vMame.Scene.Gamelist.T_MameVersion.Font.Style + [TFontStyle.fsBold];
  vFilter_Head.Font.Size := 20;
  vFilter_Head.HorzTextAlign := TTextAlign.Leading;
  vFilter_Head.Visible := True;

  vFilter_Combo := TComboBox.Create(vFilter_Panel);
  vFilter_Combo.Name := 'Filter_Combo';
  vFilter_Combo.Parent := vFilter_Panel;
  vFilter_Combo.Width := vFilter_Panel.Width - 20;
  vFilter_Combo.Height := 26;
  vFilter_Combo.Position.X := 10;
  vFilter_Combo.Position.Y := 70;
  vFilter_Combo.Items.Add('Choose Filter...');
  vFilter_Combo.Items.Add('All_Unfiltered');
  vFilter_Combo.Items.Add('Available');
  vFilter_Combo.Items.Add('Unavailable');
  vFilter_Combo.Items.Add('Working Arcade');
  vFilter_Combo.Items.Add('Not Working Arcade');
  vFilter_Combo.Items.Add('Mechanical Arcade');
  vFilter_Combo.Items.Add('Not Mechanical Arcade');
  vFilter_Combo.Items.Add('Original Arcade');
  vFilter_Combo.Items.Add('Clones Arcade');
  vFilter_Combo.Items.Add('Screenless');
  vFilter_Combo.Items.Add('Manufacturer');
  vFilter_Combo.Items.Add('Year');
  vFilter_Combo.Items.Add('Best Games By Users Rating');
  vFilter_Combo.Items.Add('Gerne');
  vFilter_Combo.Items.Add('Series');
  vFilter_Combo.Items.Add('Version');
  vFilter_Combo.Items.Add('Custom Filters');
  vFilter_Combo.ItemIndex := 0;
  vFilter_Combo.OnChange := vFilter_Comp_Combobox.OnChange;
  vFilter_Combo.Tag := 1;
  vFilter_Combo.Visible := True;

  vFilter_Label_Info := TLabel.Create(vFilter_Panel);
  vFilter_Label_Info.Name := 'Filter_Label_Info';
  vFilter_Label_Info.Parent := vFilter_Panel;
  vFilter_Label_Info.Width := vFilter_Panel.Width - 20;
  vFilter_Label_Info.Position.X := 10;
  vFilter_Label_Info.Position.Y := 105;
  vFilter_Label_Info.Text := 'Current Filter is : ' + vMame.Scene.Gamelist.T_Filters.Text;
  vFilter_Label_Info.WordWrap := True;
  vFilter_Label_Info.Visible := True;

  vFilter_Label_Info_2 := TLabel.Create(vFilter_Panel);
  vFilter_Label_Info_2.Name := 'Filter_Label_Info_2';
  vFilter_Label_Info_2.Parent := vFilter_Panel;
  vFilter_Label_Info_2.Width := vFilter_Panel.Width - 20;
  vFilter_Label_Info_2.Position.X := 10;
  vFilter_Label_Info_2.Position.Y := 125;
  vFilter_Label_Info_2.Text := '';
  vFilter_Label_Info_2.WordWrap := True;
  vFilter_Label_Info_2.Visible := True;

  vFilter_Start := TButton.Create(vFilter_Panel);
  vFilter_Start.Name := 'Filter_Start_Button';
  vFilter_Start.Parent := vFilter_Panel;
  vFilter_Start.Width := 100;
  vFilter_Start.Height := 30;
  vFilter_Start.Position.X := (vFilter_Panel.Width / 2) - 50;
  vFilter_Start.Position.Y := 165;
  vFilter_Start.Text := 'Start';
  vFilter_Start.OnClick := vFilter_Comp_Button.OnClick;
  vFilter_Start.Visible := False;

  vFilter_Progress_Bar := TProgressBar.Create(vFilter_Panel);
  vFilter_Progress_Bar.Name := 'Filter_Progress_Bar';
  vFilter_Progress_Bar.Parent := vFilter_Panel;
  vFilter_Progress_Bar.Width := vFilter_Panel.Width - 20;
  vFilter_Progress_Bar.Position.X := 10;
  vFilter_Progress_Bar.Position.Y := 165;
  vFilter_Progress_Bar.Height := 22;
  vFilter_Progress_Bar.Max := 100;
  vFilter_Progress_Bar.Min := 0;
  vFilter_Progress_Bar.Value := 20;
  vFilter_Progress_Bar.Visible := False;

  vFilter_OK := TButton.Create(vFilter_Panel);
  vFilter_OK.Name := 'Filter_OK_Button';
  vFilter_OK.Parent := vFilter_Panel;
  vFilter_OK.Width := 100;
  vFilter_OK.Height := 30;
  vFilter_OK.Position.X := 50;
  vFilter_OK.Position.Y := vFilter_Panel.Height - 40;
  vFilter_OK.Text := 'OK (Enter)';
  vFilter_OK.OnClick := vFilter_Comp_Button.OnClick;
  vFilter_OK.Visible := True;

  vFilter_Cancel := TButton.Create(vFilter_Panel);
  vFilter_Cancel.Name := 'Filter_Cancel_Button';
  vFilter_Cancel.Parent := vFilter_Panel;
  vFilter_Cancel.Width := 100;
  vFilter_Cancel.Height := 30;
  vFilter_Cancel.Position.X := 412;
  vFilter_Cancel.Position.Y := vFilter_Panel.Height - 40;
  vFilter_Cancel.Text := 'Cancel (Esc)';
  vFilter_Cancel.OnClick := vFilter_Comp_Button.OnClick;
  vFilter_Cancel.Visible := True;
end;

procedure uEmu_Arcade_Mame_Filters_Free;
begin
  extrafe.Prog.State := 'mame';
  FreeAndNil(vFilter_Panel);
  vMame.Scene.Left_Blur.Enabled := False;
  vMame.Scene.Right_Blur.Enabled := False;
  vMame.Scene.Settings_Ani.Enabled := True;
  if vMame.Scene.Snap.Video.IsPause then
    vMame.Scene.Snap.Video.Resume;
end;

//
procedure uEmu_Arcade_Mame_Filters_Info(vItem: Integer; vFilterName: String);
var
  vFilter_MameVer: String;
  vFilter_PathsCount: Integer;
  vFilter_RomPath_Names: array [0 .. 100] of string;
  vi: Integer;
  vOK: Boolean;
begin
  if vFilterName= 'All_Unfiltered' then
    vFilterName:= 'gameslist';

{  if not FileExists(mame.Prog.Data_Path + vFilterName + '.txt') then
  begin
    vFilter_Label_Info.Text := 'Filter "' + vFilterName + '" in not available yet.';
    vFilter_Label_Info_2.Text := 'Please press start button. This may take a while.';
    vFilter_Start.Visible := True;
  end
  else
  begin
  end;}
end;

procedure uEmu_Arcade_Mame_Filters_SetFilter;
begin
  { case vFilter_Combo.ItemIndex of
    1 : uEmu_Arcade_Mame_Filters_All_OK;
    2 : uEmu_Arcade_Mame_Filters_Available_OK;
    3 : uEmu_Arcade_Mame_Filters_Unavailable_OK;
    4 : uEmu_Arcade_Mame_Filters_Working_Arcade_OK;
    5 : uEmu_Arcade_Mame_Filters_NotWorking_Arcade_OK;
    6 : uEmu_Arcade_Mame_Filters_Mechaniacal_Arcade_OK;
    7 : uEmu_Arcade_Mame_Filters_NotMechanical_Aracade_OK;
    end; }
end;

procedure uEmu_Arcade_Mame_Filters_ButtonOK_Standard;
begin
  uEmu_Arcade_Mame_Display_Main;
  vMame.Scene.Gamelist.T_Filters.Text := 'Filter : ' + vFilter_Combo.Items.Strings[vFilter_Combo.ItemIndex];
  uEmu_Arcade_Mame_Filters_Free;
end;

/// /////////////////////////////////////////////////////////////////////////////
{ procedure uEmu_Arcade_Mame_Filters_SetCurrentFilter_Load;
  var
  vFilter_Name: String;
  begin
  mame.Prog.Ini_Filters:= TIniFile.Create(mame.Prog.Data_Path+ 'gamelist_filters.ini');
  vFilter_Name:= mame.Prog.Ini_Filters.ReadString('MASTER', 'Selected', vFilter_Name);
  mame.Gamelist.All_M.Roms.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_all.txt');
  mame.Gamelist.All_M.Names.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_all_n.txt');
  if vFilter_Name= 'All Unfiltered' then
  begin
  mame.Gamelist.Master.Roms:= mame.Gamelist.All_M.Roms;
  mame.Gamelist.Master.Names:= mame.Gamelist.All_M.Names;
  end
  else if vFilter_Name= 'Available' then
  begin
  mame.Gamelist.Available.Roms.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_available.txt');
  mame.Gamelist.Available.Names.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_available_n.txt');
  mame.Gamelist.Master.Roms:= mame.Gamelist.Available.Roms;
  mame.Gamelist.Master.Names:= mame.Gamelist.Available.Names;
  end
  else if vFilter_Name= 'Unvailable' then
  begin
  mame.Gamelist.Unavailable.Roms.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_unavailable.txt');
  mame.Gamelist.Unavailable.Names.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_unavailable_n.txt');
  mame.Gamelist.Master.Roms:= mame.Gamelist.Unavailable.Roms;
  mame.Gamelist.Master.Names:= mame.Gamelist.Unavailable.Names;
  end
  else if vFilter_Name= 'Working Arcade' then
  begin
  mame.Gamelist.Working_Arcade.Roms.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_working_arcade.txt');
  mame.Gamelist.Working_Arcade.Names.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_working_arcade_n.txt');
  mame.Gamelist.Master.Roms:= mame.Gamelist.Working_Arcade.Roms;
  mame.Gamelist.Master.Names:= mame.Gamelist.Working_Arcade.Names;
  end
  else if vFilter_Name= 'Not Working Arcade' then
  begin
  mame.Gamelist.Not_Working_Arcade.Roms.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_not_working_arcade.txt');
  mame.Gamelist.Not_Working_Arcade.Names.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_not_working_arcade_n.txt');
  mame.Gamelist.Master.Roms:= mame.Gamelist.Not_Working_Arcade.Roms;
  mame.Gamelist.Master.Names:= mame.Gamelist.Not_Working_Arcade.Names;
  end;
  end;


  ////////////////////////////////////////////////////////////////////////////////


  procedure uEmu_Arcade_Mame_Filters_WriteToIni(vFilter: String);
  var
  vi: Integer;
  begin
  mame.Prog.Ini_Filters.WriteString(vFilter, 'MameVer', mame.Emu.MameVer);
  mame.Prog.Ini_Filters.WriteString(vFilter, 'Created', 'OK');
  for vi := 0 to mame.Emu.Ini.CORE_SEARCH_rompath.Count - 1 do
  mame.Prog.Ini_Filters.WriteString(vFilter, 'Path_'+ IntToStr(vi), mame.Emu.Ini.CORE_SEARCH_rompath.Strings[vi]);
  mame.Prog.Ini_Filters.WriteString(vFilter, 'Paths_Count', IntToStr(vi));
  end;

  ////////////////////////////////////////////////////////////////////////////////
  procedure uEmu_Arcade_Mame_Filters_Create_All;
  begin
  if not FileExists(mame.Prog.Data_Path+ 'gamelist_mame_all.txt') then
  begin

  end
  else
  begin
  mame.Gamelist.All_M.Roms.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_all.txt');
  mame.Gamelist.All_M.Names.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_all_n.txt');
  vFilter_Label_Info.Text:= 'Selected filter : All Unfitered';
  vFilter_Label_Info_2.Text:= 'Press OK to accept this filter or cancel to use the previous one.';
  end;
  end;

  procedure uEmu_Arcade_Mame_Filters_All_OK;
  begin
  mame.Gamelist.Master.Roms:= mame.Gamelist.All_M.Roms;
  mame.Gamelist.Master.Names:= mame.Gamelist.All_M.Names;
  uEmu_Arcade_Mame_Filters_ButtonOK_Standard;
  end;
  ////////////////////////////////////////////////////////////////////////////////
  procedure uEmu_Arcade_Mame_Filters_Create_Available;
  var
  vFilter_MameVer: String;
  vFilter_PathsCount: Integer;
  vFilter_RomPath_Names: array [0..100] of string;
  vi: Integer;
  vOK: Boolean;
  begin
  if not FileExists(mame.Prog.Data_Path+ 'filter_available.txt') then
  begin
  vFilter_Label_Info.Text:= 'Filter "Available" in not available yet.';
  vFilter_Label_Info_2.Text:= 'Please press start button. This may take a while.';
  vFilter_Start.Visible:= True;
  end
  else
  begin
  if uEmu_Arcade_Mame_Filters_CheckVersion('AVAILABLE') then
  begin
  mame.Gamelist.Available.Roms.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_available.txt');
  mame.Gamelist.Available.Names.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_available_n.txt');
  vFilter_Label_Info.Text:= 'Selected filter : Available';
  vFilter_Label_Info_2.Text:= 'Press OK to accept this filter or cancel to use the previous one.';
  end
  else
  begin
  vFilter_Label_Info.Text:= 'Filter "Available" is not ment to be for this situation';
  vFilter_Label_Info_2.Text:= 'Please press start button to rebuild for better results. Please wait...';
  vFilter_Start.Visible:= True;
  end;
  end;
  end;

  procedure uEmu_Arcade_Mame_Filters_Create_Available_Start;
  var
  vi: Integer;
  begin
  vFilter_Start.Visible:= False;
  vFilter_Combo.Enabled:= False;
  vFilter_OK.Enabled:= False;
  vFilter_Cancel.Enabled:= False;
  uEmu_Arcade_Mame_Gamelist_Create_Available(mame.Gamelist.All_M.Roms, mame.Gamelist.All_M.Names, mame.Emu.Ini.CORE_SEARCH_rompath, False);
  mame.Gamelist.Available.Roms:= vMasterGameList;
  mame.Gamelist.Available.Names:= vMasterGameList_n;
  mame.Gamelist.Available.Roms.SaveToFile(mame.Prog.Data_Path+ 'gamelist_mame_available.txt');
  mame.Gamelist.Available.Names.SaveToFile(mame.Prog.Data_Path+ 'gamelist_mame_available_n.txt');
  uEmu_Arcade_Mame_Filters_WriteToIni('AVAILABLE');
  vFilter_Label_Info.Text:= 'Selected filter : Available';
  vFilter_Label_Info_2.Text:= 'Press OK to accept this filter or cancel to use the previous one.';
  vFilter_Combo.Enabled:= True;
  vFilter_OK.Enabled:= True;
  vFilter_Cancel.Enabled:= True;
  end;

  procedure uEmu_Arcade_Mame_Filters_Available_OK;
  begin
  mame.Gamelist.Master.Roms:= mame.Gamelist.Available.Roms;
  mame.Gamelist.Master.Names:= mame.Gamelist.Available.Names;
  uEmu_Arcade_Mame_Filters_ButtonOK_Standard;
  end;

  ////////////////////////////////////////////////////////////////////////////////
  procedure uEmu_Arcade_Mame_Filters_Create_Unavailable;
  var
  vFilter_MameVer: String;
  vFilter_PathsCount: Integer;
  vFilter_RomPath_Names: array [0..100] of string;
  vi: Integer;
  vOK: Boolean;
  begin
  if not FileExists(mame.Prog.Data_Path+ 'gamelist_mame_unavailable.txt') then
  begin
  vFilter_Label_Info.Text:= 'Filter "Unavailable" in not available yet.';
  vFilter_Label_Info_2.Text:= 'Please press start button. This may take a while.';
  vFilter_Start.Visible:= True;
  end
  else
  begin
  if uEmu_Arcade_Mame_Filters_CheckVersion('UNAVAILABLE') then
  begin
  mame.Gamelist.Unavailable.Roms.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_unavailable.txt');
  mame.Gamelist.Unavailable.Names.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_unavailable_n.txt');
  vFilter_Label_Info.Text:= 'Selected filter : Unavailable';
  vFilter_Label_Info_2.Text:= 'Press OK to accept this filter or cancel to use the previous one.';
  end
  else
  begin
  vFilter_Label_Info.Text:= 'Filter "Unavailable" is not ment to be for this situation';
  vFilter_Label_Info_2.Text:= 'Please press start button to rebuild for better results. Please wait...';
  vFilter_Start.Visible:= True;
  end;
  end;
  end;

  procedure uEmu_Arcade_Mame_Filters_Create_Unavailable_Start;
  var
  vi: Integer;
  begin
  vFilter_Start.Visible:= False;
  vFilter_Combo.Enabled:= False;
  vFilter_OK.Enabled:= False;
  vFilter_Cancel.Enabled:= False;
  uEmu_Arcade_Mame_Gamelist_Create_Available(mame.Gamelist.All_M.Roms, mame.Gamelist.All_M.Names, mame.Emu.Ini.CORE_SEARCH_rompath, True);
  mame.Gamelist.Unavailable.Roms:= vMasterGameList;
  mame.Gamelist.Unavailable.Names:= vMasterGameList_n;
  mame.Gamelist.Unavailable.Roms.SaveToFile(mame.Prog.Data_Path+ 'gamelist_mame_unavailable.txt');
  mame.Gamelist.Unavailable.Names.SaveToFile(mame.Prog.Data_Path+ 'gamelist_mame_unavailable_n.txt');
  uEmu_Arcade_Mame_Filters_WriteToIni('UNAVAILABLE');
  vFilter_Label_Info.Text:= 'Selected filter : Unavailable';
  vFilter_Label_Info_2.Text:= 'Press OK to accept this filter or cancel to use the previous one.';
  vFilter_Combo.Enabled:= True;
  vFilter_OK.Enabled:= True;
  vFilter_Cancel.Enabled:= True;
  end;

  procedure uEmu_Arcade_Mame_Filters_Unavailable_OK;
  begin
  mame.Gamelist.Master.Roms:= mame.Gamelist.Unavailable.Roms;
  mame.Gamelist.Master.Names:= mame.Gamelist.Unavailable.Names;
  uEmu_Arcade_Mame_Filters_ButtonOK_Standard;
  end;

  ////////////////////////////////////////////////////////////////////////////////

  procedure uEmu_Arcade_Mame_Filters_Create_Working_Arcade;
  begin
  if FileExists(mame.Emu.Media.Support_Files+ 'Working Arcade.ini') then
  begin
  if not FileExists(mame.Prog.Data_Path+ 'gamelist_mame_working_arcade.txt') then
  begin
  vFilter_OK.Enabled:= False;
  vFilter_Cancel.Enabled:= False;
  vFilter_Combo.Enabled:= False;
  vFilter_Progress_Bar.Visible:= True;
  uEmu_Arcade_Mame_Gemelist_Create_Filter(mame.Emu.Media.Support_Files+ 'Working Arcade.ini', 'Working Arcade');
  mame.Gamelist.Working_Arcade.Roms:= vMasterGameList;
  mame.Gamelist.Working_Arcade.Names:= vMasterGameList_n;
  mame.Gamelist.Working_Arcade.Roms.SaveToFile(mame.Prog.Data_Path+ 'gamelist_mame_working_arcade.txt');
  mame.Gamelist.Working_Arcade.Names.SaveToFile(mame.Prog.Data_Path+ 'gamelist_mame_working_arcade_n.txt');
  uEmu_Arcade_Mame_Filters_WriteToIni('WORKING_ARCADE');
  vFilter_Label_Info.Text:= 'Selected filter : Working Arcade';
  vFilter_Label_Info_2.Text:= 'Press OK to accept this filter or cancel to use the previous one.';
  vFilter_OK.Enabled:= True;
  vFilter_Cancel.Enabled:= True;
  vFilter_Combo.Enabled:= True;
  vFilter_Progress_Bar.Visible:= False;
  end
  else
  begin
  if uEmu_Arcade_Mame_Filters_CheckVersion('WORKING_ARCADE') then
  vFilter_Label_Info.Text:= 'Selected filter : Working Arcade'
  else
  vFilter_Label_Info.Text:= 'Selected filter : Working Arcade..."Warning somethings wrong maybe not working well"';
  vFilter_Label_Info_2.Text:= 'Press OK to accept this filter or cancel to use the previous one.';

  mame.Gamelist.Working_Arcade.Roms.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_working_arcade.txt');
  mame.Gamelist.Working_Arcade.Names.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_working_arcade_n.txt');
  end;
  end
  else
  begin
  vFilter_Label_Info.Text:= 'Working Arcade ini not found.';
  vFilter_Label_Info_2.Text:= 'Please add "Working Arcade.ini" to "Support Files" in your media path.';
  end;
  end;

  procedure uEmu_Arcade_Mame_Filters_Working_Arcade_OK;
  begin
  mame.Gamelist.Master.Roms:= mame.Gamelist.Working_Arcade.Roms;
  mame.Gamelist.Master.Names:= mame.Gamelist.Working_Arcade.Names;
  uEmu_Arcade_Mame_Filters_ButtonOK_Standard;
  end;
  ////////////////////////////////////////////////////////////////////////////////

  procedure uEmu_Arcade_Mame_Filters_Create_NotWorking_Arcade;
  begin
  if FileExists(mame.Emu.Media.Support_Files+ 'Not Working Arcade.ini') then
  begin
  if not FileExists(mame.Prog.Data_Path+ 'gamelist_mame_not_working_arcade.txt') then
  begin
  uEmu_Arcade_Mame_Gemelist_Create_Filter(mame.Emu.Media.Support_Files+ 'Not Working Arcade.ini', 'Not Working Arcade');
  mame.Gamelist.Not_Working_Arcade.Roms:= vMasterGameList;
  mame.Gamelist.Not_Working_Arcade.Names:= vMasterGameList_n;
  mame.Gamelist.Not_Working_Arcade.Roms.SaveToFile(mame.Prog.Data_Path+ 'gamelist_mame_not_working_arcade.txt');
  mame.Gamelist.Not_Working_Arcade.Names.SaveToFile(mame.Prog.Data_Path+ 'gamelist_mame_not_working_arcade_n.txt');
  uEmu_Arcade_Mame_Filters_WriteToIni('NOT_WORKING_ARCADE');
  vFilter_Label_Info.Text:= 'Selected filter : Not Working Arcade';
  vFilter_Label_Info_2.Text:= 'Press OK to accept this filter or cancel to use the previous one.';
  end
  else
  begin
  if uEmu_Arcade_Mame_Filters_CheckVersion('NOT_WORKING_ARCADE') then
  vFilter_Label_Info.Text:= 'Selected filter : Not Working Arcade'
  else
  vFilter_Label_Info.Text:= 'Selected filter : Not Working Arcade..."Warning somethings wrong maybe not working well"';
  vFilter_Label_Info_2.Text:= 'Press OK to accept this filter or cancel to use the previous one.';

  mame.Gamelist.Working_Arcade.Roms.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_not_working_arcade.txt');
  mame.Gamelist.Working_Arcade.Names.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_not_working_arcade_n.txt');
  end;
  end
  else
  begin
  vFilter_Label_Info.Text:= 'Not Working Arcade ini not found.';
  vFilter_Label_Info_2.Text:= 'Please add "Not Working Arcade.ini" to "Support Files" in your media path.';
  end;
  end;

  procedure uEmu_Arcade_mame_Filters_NotWorking_Arcade_OK;
  begin
  mame.Gamelist.Master.Roms:= mame.Gamelist.Not_Working_Arcade.Roms;
  mame.Gamelist.Master.Names:= mame.Gamelist.Not_Working_Arcade.Names;
  uEmu_Arcade_Mame_Filters_ButtonOK_Standard;
  end;

  ////////////////////////////////////////////////////////////////////////////////

  procedure uEmu_Arcade_Mame_Filters_Create_Mechanical_Arcade;
  begin
  if FileExists(mame.Emu.Media.Support_Files+ 'Mechanicals Arcade.ini') then
  begin
  if not FileExists(mame.Prog.Data_Path+ 'gamelist_mame_mechanicals_arcade.txt') then
  begin
  vFilter_OK.Enabled:= False;
  vFilter_Cancel.Enabled:= False;
  vFilter_Combo.Enabled:= False;
  vFilter_Progress_Bar.Visible:= True;
  uEmu_Arcade_Mame_Gemelist_Create_Filter(mame.Emu.Media.Support_Files+ 'Mechanicals Arcade.ini', 'Mechanicals Arcade');
  mame.Gamelist.Mechanical_Arcade.Roms:= vMasterGameList;
  mame.Gamelist.Mechanical_Arcade.Names:= vMasterGameList_n;
  mame.Gamelist.Mechanical_Arcade.Roms.SaveToFile(mame.Prog.Data_Path+ 'gamelist_mame_mechanicals_arcade.txt');
  mame.Gamelist.Mechanical_Arcade.Names.SaveToFile(mame.Prog.Data_Path+ 'gamelist_mame_mechanicals_arcade_n.txt');
  uEmu_Arcade_Mame_Filters_WriteToIni('MECHANICAL_ARCADE');
  vFilter_Label_Info.Text:= 'Selected filter : Mechanicals Arcade';
  vFilter_Label_Info_2.Text:= 'Press OK to accept this filter or cancel to use the previous one.';
  vFilter_OK.Enabled:= True;
  vFilter_Cancel.Enabled:= True;
  vFilter_Combo.Enabled:= True;
  vFilter_Progress_Bar.Visible:= False;
  end
  else
  begin
  if uEmu_Arcade_Mame_Filters_CheckVersion('MECHANICAL_ARCADE') then
  vFilter_Label_Info.Text:= 'Selected filter : Mechanicals Arcade'
  else
  vFilter_Label_Info.Text:= 'Selected filter : Mechanicacls..."Warning somethings wrong maybe not working well"';
  vFilter_Label_Info_2.Text:= 'Press OK to accept this filter or cancel to use the previous one.';

  mame.Gamelist.Working_Arcade.Roms.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_mechanicals_arcade.txt');
  mame.Gamelist.Working_Arcade.Names.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_mechanicals_arcade_n.txt');
  end;
  end
  else
  begin
  vFilter_Label_Info.Text:= 'Mechanicals Arcade ini not found.';
  vFilter_Label_Info_2.Text:= 'Please add "Mechanicals Arcade.ini" to "Support Files" in your media path.';
  end;
  end;

  procedure uEmu_Arcade_Mame_Filters_Mechaniacal_Arcade_OK;
  begin
  mame.Gamelist.Master.Roms:= mame.Gamelist.Mechanical_Arcade.Roms;
  mame.Gamelist.Master.Names:= mame.Gamelist.Mechanical_Arcade.Names;
  uEmu_Arcade_Mame_Filters_ButtonOK_Standard;
  end;

  ////////////////////////////////////////////////////////////////////////////////

  procedure uEmu_Arcade_Mame_Filters_Create_NotMechanical_Arcade;
  begin
  if FileExists(mame.Emu.Media.Support_Files+ 'Non Mechanicals Arcade.ini') then
  begin
  if not FileExists(mame.Prog.Data_Path+ 'gamelist_mame_non_mechanicals_arcade.txt') then
  begin
  vFilter_OK.Enabled:= False;
  vFilter_Cancel.Enabled:= False;
  vFilter_Combo.Enabled:= False;
  vFilter_Progress_Bar.Visible:= True;
  uEmu_Arcade_Mame_Gemelist_Create_Filter(mame.Emu.Media.Support_Files+ 'Non Mechanicals Arcade.ini', 'Non Mechanicals Arcade');
  mame.Gamelist.Not_Mechanical_Arcade.Roms:= vMasterGameList;
  mame.Gamelist.Not_Mechanical_Arcade.Names:= vMasterGameList_n;
  mame.Gamelist.Not_Mechanical_Arcade.Roms.SaveToFile(mame.Prog.Data_Path+ 'gamelist_mame_non_mechanicals_arcade.txt');
  mame.Gamelist.Not_Mechanical_Arcade.Names.SaveToFile(mame.Prog.Data_Path+ 'gamelist_mame_non_mechanicals_arcade_n.txt');
  uEmu_Arcade_Mame_Filters_WriteToIni('NOT_MECHANICAL_ARCADE');
  vFilter_Label_Info.Text:= 'Selected filter : Not Mechanicals Arcade';
  vFilter_Label_Info_2.Text:= 'Press OK to accept this filter or cancel to use the previous one.';
  vFilter_OK.Enabled:= True;
  vFilter_Cancel.Enabled:= True;
  vFilter_Combo.Enabled:= True;
  vFilter_Progress_Bar.Visible:= False;
  end
  else
  begin
  if uEmu_Arcade_Mame_Filters_CheckVersion('NOT_MECHANICAL_ARCADE') then
  vFilter_Label_Info.Text:= 'Selected filter : Not Mechanicals Arcade'
  else
  vFilter_Label_Info.Text:= 'Selected filter : Not Mechanicacls..."Warning somethings wrong maybe not working well"';
  vFilter_Label_Info_2.Text:= 'Press OK to accept this filter or cancel to use the previous one.';

  mame.Gamelist.Working_Arcade.Roms.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_non_mechanicals_arcade.txt');
  mame.Gamelist.Working_Arcade.Names.LoadFromFile(mame.Prog.Data_Path+ 'gamelist_mame_non_mechanicals_arcade_n.txt');
  end;
  end
  else
  begin
  vFilter_Label_Info.Text:= 'Not Mechanicals Arcade ini not found.';
  vFilter_Label_Info_2.Text:= 'Please add "Non Mechanicals Arcade.ini" to "Support Files" in your media path.';
  end;
  end;

  procedure uEmu_Arcade_Mame_Filters_NotMechanical_Aracade_OK;
  begin
  mame.Gamelist.Master.Roms:= mame.Gamelist.Not_Mechanical_Arcade.Roms;
  mame.Gamelist.Master.Names:= mame.Gamelist.Not_Mechanical_Arcade.Names;
  uEmu_Arcade_Mame_Filters_ButtonOK_Standard;
  end;

  ////////////////////////////////////////////////////////////////////////////////

  procedure uEmu_Arcade_Mame_Filters_Create_Original_Arcade;
  begin
  vFilter_Label_Info.Text:= 'Original filter is not ready yet';
  vFilter_Label_Info_2.Text:= 'This feature will come with next updates.';
  end;

  procedure uEmu_Arcade_Mame_Filters_Create_Clones_Arcade;
  begin
  vFilter_Label_Info.Text:= 'Clones filter is not ready yet';
  vFilter_Label_Info_2.Text:= 'This feature will come with next updates.';
  end;

  procedure uEmu_Arcade_Mame_Filters_Create_Manufacturer;
  begin
  vFilter_Label_Info.Text:= 'Manufacturer filter is not ready yet';
  vFilter_Label_Info_2.Text:= 'This feature will come with next updates.';
  end;

  procedure uEmu_Arcade_Mame_Filters_Create_Year;
  begin
  vFilter_Label_Info.Text:= 'Year filter is not ready yet';
  vFilter_Label_Info_2.Text:= 'This feature will come with next updates.';
  end;

  procedure uEmu_Arcade_Mame_Filters_Create_Best_Games_By_Users_Rating;
  begin
  vFilter_Label_Info.Text:= 'Save Supported filter is not ready yet';
  vFilter_Label_Info_2.Text:= 'This feature will come with next updates.';
  end;

  procedure uEmu_Arcade_Mame_Filters_Create_Gerne;
  begin
  vFilter_Label_Info.Text:= 'Not Save Supported filter is not ready yet';
  vFilter_Label_Info_2.Text:= 'This feature will come with next updates.';
  end;

  procedure uEmu_Arcade_Mame_Filters_Create_Series;
  begin
  vFilter_Label_Info.Text:= 'CHD Required filter is not ready yet';
  vFilter_Label_Info_2.Text:= 'This feature will come with next updates.';
  end;

  procedure uEmu_Arcade_Mame_Filters_Create_Version;
  begin
  vFilter_Label_Info.Text:= 'CHD Not Required filter is not ready yet';
  vFilter_Label_Info_2.Text:= 'This feature will come with next updates.';
  end;

  procedure uEmu_Arcade_Mame_Filters_Create_CustomFilters;
  begin
  vFilter_Label_Info.Text:= 'Custom filter is not ready yet';
  vFilter_Label_Info_2.Text:= 'This feature will come with next updates.';
  end; }

{ TEMU_ARCADE_MAME_FILTER_COMBOBOX }

procedure TEMU_ARCADE_MAME_FILTER_COMBOBOX.OnChange(Sender: TObject);
begin
  if TComboBox(Sender).Tag = 1 then
    uEmu_Arcade_Mame_Filters_Info(TComboBox(Sender).ItemIndex,
      TComboBox(Sender).Items.Strings[TComboBox(Sender).ItemIndex]); end;

    { TEMU_ARCADE_MAME_FILTER_BUTTON }

    procedure TEMU_ARCADE_MAME_FILTER_BUTTON.OnClick(Sender: TObject);
    begin if TButton(Sender).Text = 'Cancel (Esc)' then uEmu_Arcade_Mame_Filters_Free else if TButton(Sender)
      .Text = 'OK (Enter)' then uEmu_Arcade_Mame_Filters_SetFilter else if TButton(Sender).Text = 'Start'
    then begin
    { case vFilter_Combo.ItemIndex of
      2 : uEmu_Arcade_Mame_Filters_Create_Available_Start;
      3 : uEmu_Arcade_Mame_Filters_Create_Unavailable_Start;
      end; }
    end; end;

    initialization

      vFilter_Comp_Combobox := TEMU_ARCADE_MAME_FILTER_COMBOBOX.Create;
    vFilter_Comp_Button := TEMU_ARCADE_MAME_FILTER_BUTTON.Create;

    finalization

      vFilter_Comp_Combobox.Free; vFilter_Comp_Button.Free;

    end.
