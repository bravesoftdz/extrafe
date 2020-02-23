unit uMain_Config_Emulation_Arcade_Scripts_Mame_Uninstall;

interface

uses
  System.Classes,
  System.IOUtils,
  System.SysUtils,
  System.UiTypes,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.TabControl,
  FMX.Types,
  ALFMXObjects;

type
  TEMU_MAME_UNINSTALL_MAIN_TAB1 = record
    Box: TGroupBox;
    Text: TALText;
  end;

type
  TEMU_MAME_UNINSTALL_MAIN_TAB2 = record
    Box: TGroupBox;
    Check_1: TCheckBox;
    Check_2: TCheckBox;
    Check_3: TCheckBox;
  end;

type
  TEMU_MAME_UNINSTALL_MAIN_TAB3 = record
    Box: TGroupBox;
    Line_1: TALText;
    Line_2: TALText;
    Line_3: TALText;
    Remove: TButton;
  end;

type
  TEMU_MAME_UNINSTALL_MAIN_TAB4 = record
    Box: TGroupBox;
    Line: TALText;
    Success: TButton;
  end;

type
  TEMU_MAME_UNINSTALL_MAIN = record
    Panel: TPanel;
    Control: TTabControl;
    Tabs: array [0 .. 3] of TTabItem;
    Tab1: TEMU_MAME_UNINSTALL_MAIN_TAB1;
    Tab2: TEMU_MAME_UNINSTALL_MAIN_TAB2;
    Tab3: TEMU_MAME_UNINSTALL_MAIN_TAB3;
    Tab4: TEMU_MAME_UNINSTALL_MAIN_TAB4;
    Cancel: TButton;
    Back: TButton;
    Next: TButton;
    Status: String;
  end;

type
  TEMU_MAME_UNINSTALL = record
    Panel: TPanel;
    Main: TEMU_MAME_UNINSTALL_MAIN;
  end;

procedure uEmulation_Arcade_Mame_Uninstall;
procedure uEmulation_Arcade_Mame_Uninstall_Free;

procedure uEmulation_Arcade_Mame_Uninstall_Slide_To_Next;
procedure uEmulation_Arcade_Mame_Uninstall_Slide_To_Previous;

procedure uEmulation_Arcade_Mame_Uninstall_Remove;
procedure uEmulation_Arcade_Mame_Uninstall_Final;

procedure CreateTab1;
procedure CreateTab2;
procedure CreateTab3;
procedure CreateTab4;

procedure ShowButtons;

var
  Script_Mame_Uninstall: TEMU_MAME_UNINSTALL;

implementation

uses
  uDB_AUser,
  uDB,
  uLoad_AllTypes,
  Main,
  uMain_Emulation,
  uMain_AllTypes,
  uMain_Config_Emulators,
  uMain_Config_Emulation_Arcade_Scripts_Mouse,
  uWindows,
  uLoad_Emulation;

procedure uEmulation_Arcade_Mame_Uninstall;
var
  vi: Integer;
begin
  extrafe.prog.State := 'main_config_uninstall';
  Script_Mame_Uninstall.Main.Status := 'phase_1';

  mainScene.Config.Main.Left_Blur.Enabled := True;
  mainScene.Config.Main.R.Emulators.Panel_Blur.Enabled := True;

  Script_Mame_Uninstall.Panel := TPanel.Create(Main_Form);
  Script_Mame_Uninstall.Panel.Name := 'Script_Mame_Uninstall';
  Script_Mame_Uninstall.Panel.Parent := Main_Form;
  Script_Mame_Uninstall.Panel.SetBounds(extrafe.res.Half_Width - 300, extrafe.res.Half_Height - 175, 600, 350);
  Script_Mame_Uninstall.Panel.Visible := True;

  CreateHeader(Script_Mame_Uninstall.Panel, 'IcoMoon-Free', #$e9a9, TAlphaColorRec.DeepSkyBlue, 'UnInstall  Mame emulator from ExtraFE', false, nil);

  Script_Mame_Uninstall.Main.Panel := TPanel.Create(Script_Mame_Uninstall.Panel);
  Script_Mame_Uninstall.Main.Panel.Name := 'Script_Mame_Uninstall_Main';
  Script_Mame_Uninstall.Main.Panel.Parent := Script_Mame_Uninstall.Panel;
  Script_Mame_Uninstall.Main.Panel.SetBounds(0, 30, Script_Mame_Uninstall.Panel.Width, Script_Mame_Uninstall.Panel.Height - 30);
  Script_Mame_Uninstall.Main.Panel.Visible := True;

  Script_Mame_Uninstall.Main.Control := TTabControl.Create(Script_Mame_Uninstall.Main.Panel);
  Script_Mame_Uninstall.Main.Control.Name := 'Script_Mame_Uninstall_Main_Control';
  Script_Mame_Uninstall.Main.Control.Parent := Script_Mame_Uninstall.Main.Panel;
  Script_Mame_Uninstall.Main.Control.Align := TAlignLayout.Client;
  Script_Mame_Uninstall.Main.Control.TabPosition := TTabPosition.None;
  Script_Mame_Uninstall.Main.Control.Visible := True;

  for vi := 0 to 3 do
  begin
    Script_Mame_Uninstall.Main.Tabs[vi] := TTabItem.Create(Script_Mame_Uninstall.Main.Control);
    Script_Mame_Uninstall.Main.Tabs[vi].Name := 'Script_Mame_Uninstall_Main_Tab_' + vi.ToString;
    Script_Mame_Uninstall.Main.Tabs[vi].Parent := Script_Mame_Uninstall.Main.Control;
    Script_Mame_Uninstall.Main.Tabs[vi].Width := Script_Mame_Uninstall.Main.Control.Width;
    Script_Mame_Uninstall.Main.Tabs[vi].Height := Script_Mame_Uninstall.Main.Control.Height;
    Script_Mame_Uninstall.Main.Tabs[vi].Visible := True;
  end;

  CreateTab1;
  CreateTab2;
  CreateTab3;
  CreateTab4;

  Script_Mame_Uninstall.Main.Next := TButton.Create(Script_Mame_Uninstall.Panel);
  Script_Mame_Uninstall.Main.Next.Name := 'Script_Mame_Uninstall_Main_Next';
  Script_Mame_Uninstall.Main.Next.Parent := Script_Mame_Uninstall.Panel;
  Script_Mame_Uninstall.Main.Next.SetBounds(Script_Mame_Uninstall.Main.Control.Width - 190, Script_Mame_Uninstall.Main.Control.Height - 50, 140, 40);
  Script_Mame_Uninstall.Main.Next.Text := 'Next';
  Script_Mame_Uninstall.Main.Next.OnClick := ex_main.Input.mouse_script_arcade.Button.OnMouseClick;
  Script_Mame_Uninstall.Main.Next.OnMouseEnter := ex_main.Input.mouse_script_arcade.Button.OnMouseEnter;
  Script_Mame_Uninstall.Main.Next.Visible := True;

  Script_Mame_Uninstall.Main.Back := TButton.Create(Script_Mame_Uninstall.Panel);
  Script_Mame_Uninstall.Main.Back.Name := 'Script_Mame_Uninstall_Main_Back';
  Script_Mame_Uninstall.Main.Back.Parent := Script_Mame_Uninstall.Panel;
  Script_Mame_Uninstall.Main.Back.SetBounds((Script_Mame_Uninstall.Main.Control.Width / 2) - 70, Script_Mame_Uninstall.Main.Control.Height - 50, 140, 40);
  Script_Mame_Uninstall.Main.Back.Text := 'Back';
  Script_Mame_Uninstall.Main.Back.OnClick := ex_main.Input.mouse_script_arcade.Button.OnMouseClick;
  Script_Mame_Uninstall.Main.Back.OnMouseEnter := ex_main.Input.mouse_script_arcade.Button.OnMouseEnter;
  Script_Mame_Uninstall.Main.Back.Visible := True;

  Script_Mame_Uninstall.Main.Cancel := TButton.Create(Script_Mame_Uninstall.Panel);
  Script_Mame_Uninstall.Main.Cancel.Name := 'Script_Mame_Uninstall_Main_Cancel';
  Script_Mame_Uninstall.Main.Cancel.Parent := Script_Mame_Uninstall.Panel;
  Script_Mame_Uninstall.Main.Cancel.SetBounds(50, Script_Mame_Uninstall.Main.Control.Height - 50, 140, 40);
  Script_Mame_Uninstall.Main.Cancel.Text := 'Cancel';
  Script_Mame_Uninstall.Main.Cancel.OnClick := ex_main.Input.mouse_script_arcade.Button.OnMouseClick;
  Script_Mame_Uninstall.Main.Cancel.OnMouseEnter := ex_main.Input.mouse_script_arcade.Button.OnMouseEnter;
  Script_Mame_Uninstall.Main.Cancel.Visible := True;

  ShowButtons;
end;

procedure CreateTab1;
begin
  Script_Mame_Uninstall.Main.Tab1.Box := TGroupBox.Create(Script_Mame_Uninstall.Main.Tabs[0]);
  Script_Mame_Uninstall.Main.Tab1.Box.Name := 'Script_Mame_Uninstall_Main_Tab1_Box';
  Script_Mame_Uninstall.Main.Tab1.Box.Parent := Script_Mame_Uninstall.Main.Tabs[0];
  Script_Mame_Uninstall.Main.Tab1.Box.SetBounds(10, 10, Script_Mame_Uninstall.Main.Control.Width - 20, 200);
  Script_Mame_Uninstall.Main.Tab1.Box.Text := 'Information.';
  Script_Mame_Uninstall.Main.Tab1.Box.Visible := True;

  Script_Mame_Uninstall.Main.Tab1.Text := TALText.Create(Script_Mame_Uninstall.Main.Tab1.Box);
  Script_Mame_Uninstall.Main.Tab1.Text.Name := 'Script_Mame_Uninstall_Main_Tab1_Text';
  Script_Mame_Uninstall.Main.Tab1.Text.Parent := Script_Mame_Uninstall.Main.Tab1.Box;
  Script_Mame_Uninstall.Main.Tab1.Text.SetBounds(10, 40, Script_Mame_Uninstall.Main.Tab1.Box.Width - 20, 60);
  Script_Mame_Uninstall.Main.Tab1.Text.WordWrap := True;
  Script_Mame_Uninstall.Main.Tab1.Text.TextIsHtml := True;
  Script_Mame_Uninstall.Main.Tab1.Text.TextSettings.FontColor := TAlphaColorRec.White;
  Script_Mame_Uninstall.Main.Tab1.Text.TextSettings.Font.Size := 14;
  Script_Mame_Uninstall.Main.Tab1.Text.TextSettings.VertAlign := TTextAlign.Leading;
  Script_Mame_Uninstall.Main.Tab1.Text.Text :=
    ' This action will "<font color="#ff63cbfc">uninstall mame</font>" from "<font color="#ff63cbfc">ExtraFE</font>".' + #13#10 +
    ' If you wish to continue press next else press cancel.';
  Script_Mame_Uninstall.Main.Tab1.Text.Visible := True;
end;

procedure CreateTab2;
begin
  Script_Mame_Uninstall.Main.Tab2.Box := TGroupBox.Create(Script_Mame_Uninstall.Main.Tabs[1]);
  Script_Mame_Uninstall.Main.Tab2.Box.Name := 'Script_Mame_Uninstall_Main_Tab2_Box';
  Script_Mame_Uninstall.Main.Tab2.Box.Parent := Script_Mame_Uninstall.Main.Tabs[1];
  Script_Mame_Uninstall.Main.Tab2.Box.SetBounds(10, 10, Script_Mame_Uninstall.Main.Control.Width - 20, 200);
  Script_Mame_Uninstall.Main.Tab2.Box.Text := 'Uninstall options.';
  Script_Mame_Uninstall.Main.Tab2.Box.Visible := True;

  Script_Mame_Uninstall.Main.Tab2.Check_1 := TCheckBox.Create(Script_Mame_Uninstall.Main.Tab2.Box);
  Script_Mame_Uninstall.Main.Tab2.Check_1.Name := 'Script_Mame_Uninstall_Main_Tab2_Check_1';
  Script_Mame_Uninstall.Main.Tab2.Check_1.Parent := Script_Mame_Uninstall.Main.Tab2.Box;
  Script_Mame_Uninstall.Main.Tab2.Check_1.SetBounds(20, 30, 400, 24);
  Script_Mame_Uninstall.Main.Tab2.Check_1.Text := 'Uninstall Mame emulator from ExtraFE.';
  Script_Mame_Uninstall.Main.Tab2.Check_1.IsChecked := True;
  Script_Mame_Uninstall.Main.Tab2.Check_1.Enabled := false;
  Script_Mame_Uninstall.Main.Tab2.Check_1.Visible := True;

  Script_Mame_Uninstall.Main.Tab2.Check_2 := TCheckBox.Create(Script_Mame_Uninstall.Main.Tab2.Box);
  Script_Mame_Uninstall.Main.Tab2.Check_2.Name := 'Script_Mame_Uninstall_Main_Tab2_Check_2';
  Script_Mame_Uninstall.Main.Tab2.Check_2.Parent := Script_Mame_Uninstall.Main.Tab2.Box;
  Script_Mame_Uninstall.Main.Tab2.Check_2.SetBounds(20, 60, 400, 24);
  Script_Mame_Uninstall.Main.Tab2.Check_2.Text := 'Remove favorites, play count, hidden games, e.t.c. from database.';
  Script_Mame_Uninstall.Main.Tab2.Check_2.Visible := True;

  Script_Mame_Uninstall.Main.Tab2.Check_3 := TCheckBox.Create(Script_Mame_Uninstall.Main.Tab2.Box);
  Script_Mame_Uninstall.Main.Tab2.Check_3.Name := 'Script_Mame_Uninstall_Main_Tab2_Check_3';
  Script_Mame_Uninstall.Main.Tab2.Check_3.Parent := Script_Mame_Uninstall.Main.Tab2.Box;
  Script_Mame_Uninstall.Main.Tab2.Check_3.SetBounds(20, 90, 300, 24);
  Script_Mame_Uninstall.Main.Tab2.Check_3.Text := 'Delete Mame folder and all subcategories.';
  Script_Mame_Uninstall.Main.Tab2.Check_3.IsChecked := false;
  Script_Mame_Uninstall.Main.Tab2.Check_3.Visible := True;
end;

procedure CreateTab3;
begin
  Script_Mame_Uninstall.Main.Tab3.Box := TGroupBox.Create(Script_Mame_Uninstall.Main.Tabs[2]);
  Script_Mame_Uninstall.Main.Tab3.Box.Name := 'Script_Mame_Uninstall_Main_Tab3_Box';
  Script_Mame_Uninstall.Main.Tab3.Box.Parent := Script_Mame_Uninstall.Main.Tabs[2];
  Script_Mame_Uninstall.Main.Tab3.Box.SetBounds(10, 10, Script_Mame_Uninstall.Main.Control.Width - 20, 200);
  Script_Mame_Uninstall.Main.Tab3.Box.Text := 'Final stage to uninstall "Mame".';
  Script_Mame_Uninstall.Main.Tab3.Box.Visible := True;

  Script_Mame_Uninstall.Main.Tab3.Line_1 := TALText.Create(Script_Mame_Uninstall.Main.Tab3.Box);
  Script_Mame_Uninstall.Main.Tab3.Line_1.Name := 'Script_Mame_Uninstall_Main_Tab3_Line_1';
  Script_Mame_Uninstall.Main.Tab3.Line_1.Parent := Script_Mame_Uninstall.Main.Tab3.Box;
  Script_Mame_Uninstall.Main.Tab3.Line_1.SetBounds(10, 40, Script_Mame_Uninstall.Main.Tab3.Box.Width - 20, 60);
  Script_Mame_Uninstall.Main.Tab3.Line_1.WordWrap := True;
  Script_Mame_Uninstall.Main.Tab3.Line_1.TextIsHtml := True;
  Script_Mame_Uninstall.Main.Tab3.Line_1.TextSettings.FontColor := TAlphaColorRec.White;
  Script_Mame_Uninstall.Main.Tab3.Line_1.TextSettings.Font.Size := 14;
  Script_Mame_Uninstall.Main.Tab3.Line_1.TextSettings.VertAlign := TTextAlign.Leading;
  Script_Mame_Uninstall.Main.Tab3.Line_1.Text := ' Press the "<font color="#ff63cbfc">Uninstall</font>" button below to Uninstall Mame from Extrafe';
  Script_Mame_Uninstall.Main.Tab3.Line_1.Visible := True;

  Script_Mame_Uninstall.Main.Tab3.Line_2 := TALText.Create(Script_Mame_Uninstall.Main.Tab3.Box);
  Script_Mame_Uninstall.Main.Tab3.Line_2.Name := 'Script_Mame_Uninstall_Main_Tab3_Line_2';
  Script_Mame_Uninstall.Main.Tab3.Line_2.Parent := Script_Mame_Uninstall.Main.Tab3.Box;
  Script_Mame_Uninstall.Main.Tab3.Line_2.SetBounds(10, 70, Script_Mame_Uninstall.Main.Tab3.Box.Width - 20, 60);
  Script_Mame_Uninstall.Main.Tab3.Line_2.WordWrap := True;
  Script_Mame_Uninstall.Main.Tab3.Line_2.TextIsHtml := True;
  Script_Mame_Uninstall.Main.Tab3.Line_2.TextSettings.FontColor := TAlphaColorRec.White;
  Script_Mame_Uninstall.Main.Tab3.Line_2.TextSettings.Font.Size := 14;
  Script_Mame_Uninstall.Main.Tab3.Line_2.TextSettings.VertAlign := TTextAlign.Leading;
  Script_Mame_Uninstall.Main.Tab3.Line_2.Text :=
    ' "<font color="#ff63cbfc">Warning...</font>" you have choosen to remove all favorites, play count, hidden games e.t.c. from database permanently';
  Script_Mame_Uninstall.Main.Tab3.Line_2.Visible := false;

  Script_Mame_Uninstall.Main.Tab3.Line_3 := TALText.Create(Script_Mame_Uninstall.Main.Tab3.Box);
  Script_Mame_Uninstall.Main.Tab3.Line_3.Name := 'Script_Mame_Uninstall_Main_Tab3_Line_3';
  Script_Mame_Uninstall.Main.Tab3.Line_3.Parent := Script_Mame_Uninstall.Main.Tab3.Box;
  Script_Mame_Uninstall.Main.Tab3.Line_3.SetBounds(10, 100, Script_Mame_Uninstall.Main.Tab3.Box.Width - 20, 60);
  Script_Mame_Uninstall.Main.Tab3.Line_3.WordWrap := True;
  Script_Mame_Uninstall.Main.Tab3.Line_3.TextIsHtml := True;
  Script_Mame_Uninstall.Main.Tab3.Line_3.TextSettings.FontColor := TAlphaColorRec.White;
  Script_Mame_Uninstall.Main.Tab3.Line_3.TextSettings.Font.Size := 14;
  Script_Mame_Uninstall.Main.Tab3.Line_3.TextSettings.VertAlign := TTextAlign.Leading;
  Script_Mame_Uninstall.Main.Tab3.Line_3.Text := ' "<font color="#ff63cbfc">Warning..</font>" you have choose to erase mame folder from your computer, completly.';
  Script_Mame_Uninstall.Main.Tab3.Line_3.Visible := false;

  Script_Mame_Uninstall.Main.Tab3.Remove := TButton.Create(Script_Mame_Uninstall.Main.Tab3.Box);
  Script_Mame_Uninstall.Main.Tab3.Remove.Name := 'Script_Mame_Uninstall_Main_Remove';
  Script_Mame_Uninstall.Main.Tab3.Remove.Parent := Script_Mame_Uninstall.Main.Tab3.Box;
  Script_Mame_Uninstall.Main.Tab3.Remove.SetBounds((Script_Mame_Uninstall.Main.Tab3.Box.Width / 2) - 80, 150, 160, 30);
  Script_Mame_Uninstall.Main.Tab3.Remove.Text := 'Uninstall "Mame"';
  Script_Mame_Uninstall.Main.Tab3.Remove.OnClick := ex_main.Input.mouse_script_arcade.Button.OnMouseClick;
  Script_Mame_Uninstall.Main.Tab3.Remove.OnMouseEnter := ex_main.Input.mouse_script_arcade.Button.OnMouseEnter;
  Script_Mame_Uninstall.Main.Tab3.Remove.Visible := True;
end;

procedure CreateTab4;
begin
  Script_Mame_Uninstall.Main.Tab4.Box := TGroupBox.Create(Script_Mame_Uninstall.Main.Tabs[3]);
  Script_Mame_Uninstall.Main.Tab4.Box.Name := 'Script_Mame_Uninstall_Main_Tab4_Box';
  Script_Mame_Uninstall.Main.Tab4.Box.Parent := Script_Mame_Uninstall.Main.Tabs[3];
  Script_Mame_Uninstall.Main.Tab4.Box.SetBounds(10, 10, Script_Mame_Uninstall.Main.Control.Width - 20, 200);
  Script_Mame_Uninstall.Main.Tab4.Box.Text := 'Mame no longer exists in ExtraFE menu.';
  Script_Mame_Uninstall.Main.Tab4.Box.Visible := True;

  Script_Mame_Uninstall.Main.Tab4.Line := TALText.Create(Script_Mame_Uninstall.Main.Tab4.Box);
  Script_Mame_Uninstall.Main.Tab4.Line.Name := 'Script_Mame_Uninstall_Main_Tab4_Line';
  Script_Mame_Uninstall.Main.Tab4.Line.Parent := Script_Mame_Uninstall.Main.Tab4.Box;
  Script_Mame_Uninstall.Main.Tab4.Line.SetBounds(10, 40, Script_Mame_Uninstall.Main.Tab4.Box.Width - 20, 60);
  Script_Mame_Uninstall.Main.Tab4.Line.WordWrap := True;
  Script_Mame_Uninstall.Main.Tab4.Line.TextIsHtml := True;
  Script_Mame_Uninstall.Main.Tab4.Line.TextSettings.FontColor := TAlphaColorRec.White;
  Script_Mame_Uninstall.Main.Tab4.Line.TextSettings.Font.Size := 14;
  Script_Mame_Uninstall.Main.Tab4.Line.TextSettings.VertAlign := TTextAlign.Leading;
  Script_Mame_Uninstall.Main.Tab4.Line.Text := 'You have unistall successfully from ExtraFE. Now press close and go to menu.';
  Script_Mame_Uninstall.Main.Tab4.Line.Visible := True;

  Script_Mame_Uninstall.Main.Tab4.Success := TButton.Create(Script_Mame_Uninstall.Main.Tab4.Box);
  Script_Mame_Uninstall.Main.Tab4.Success.Name := 'Script_Mame_Uninstall_Main_Final';
  Script_Mame_Uninstall.Main.Tab4.Success.Parent := Script_Mame_Uninstall.Main.Tab4.Box;
  Script_Mame_Uninstall.Main.Tab4.Success.SetBounds((Script_Mame_Uninstall.Main.Tab4.Box.Width / 2) - 70, 140, 140, 30);
  Script_Mame_Uninstall.Main.Tab4.Success.Text := 'Close';
  Script_Mame_Uninstall.Main.Tab4.Success.OnClick := ex_main.Input.mouse_script_arcade.Button.OnMouseClick;
  Script_Mame_Uninstall.Main.Tab4.Success.OnMouseEnter := ex_main.Input.mouse_script_arcade.Button.OnMouseEnter;
  Script_Mame_Uninstall.Main.Tab4.Success.Visible := True;
end;

procedure uEmulation_Arcade_Mame_Uninstall_Free;
begin
  extrafe.prog.State := 'main_config_emulators';
  mainScene.Config.Main.Left_Blur.Enabled := false;
  mainScene.Config.Main.R.Emulators.Panel_Blur.Enabled := false;
  FreeAndNil(Script_Mame_Uninstall.Panel);
  mainScene.Footer.Back_Blur.Enabled := false;
end;

procedure uEmulation_Arcade_Mame_Uninstall_Final;
begin
  FreeAndNil(mainScene.Config.Main.R.Emulators.Arcade[0].Panel);
  uMain_Config_Emulators.CreateArcadePanel(0);

  uEmulation_Arcade_Mame_Uninstall_Free;
end;

///

procedure uEmulation_Arcade_Mame_Uninstall_Remove;
begin
  Dec(uDB_AUser.Local.Emulators.Arcade_D.Count, 1);
  uDB_AUser.Local.Emulators.Arcade_D.Mame := false;
  Dec(uDB_AUser.Local.Emulators.Count, 1);
  if uDB_AUser.Local.Emulators.Count = -1 then
    uDB_AUser.Local.Emulators.Arcade := false;

  uDB_AUser.Local.Emulators.Arcade_D.Mame_D.Installed := false;
  uDB_AUser.Local.Emulators.Arcade_D.Mame_D.Position := -1;
  uDB_AUser.Local.Emulators.Arcade_D.Mame_D.Active := false;
  uDB_AUser.Local.Emulators.Arcade_D.Mame_D.p_Path := '';
  uDB_AUser.Local.Emulators.Arcade_D.Mame_D.p_Images := '';
  uDB_AUser.Local.Emulators.Arcade_D.Mame_D.p_Sounds := '';
  uDB_AUser.Local.Emulators.Arcade_D.Mame_D.p_Views := '';
  uDB_AUser.Local.Emulators.Arcade_D.Mame_D.Name := '';
  uDB_AUser.Local.Emulators.Arcade_D.Mame_D.Path := '';
  uDB_AUser.Local.Emulators.Arcade_D.Mame_D.Ini := '';
  uDB_AUser.Local.Emulators.Arcade_D.Mame_D.Version := '';

  { Clear from emulators table }
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'emulators', 'COUNT', uDB_AUser.Local.Emulators.Count.ToString, 'USER_ID', uDB_AUser.Local.USER.Num.ToString);
  if uDB_AUser.Local.Emulators.Arcade then
    uDB.Query_Update(uDB.ExtraFE_Query_Local, 'emulators', 'ARCADE', '1', 'USER_ID', uDB_AUser.Local.USER.Num.ToString)
  else
  begin
    uDB.Query_Update(uDB.ExtraFE_Query_Local, 'emulators', 'ARCADE', '0', 'USER_ID', uDB_AUser.Local.USER.Num.ToString);
    uDB_AUser.Local.Emulators.Arcade := false;
  end;

  { Clear from arcade table }
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'arcade', 'COUNT', uDB_AUser.Local.Emulators.Arcade_D.Count.ToString, 'USER_ID', uDB_AUser.Local.USER.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'arcade', 'MAME', '0', 'USER_ID', uDB_AUser.Local.USER.Num.ToString);

  { Clear mame table }
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'arcade_mame', 'INSTALLED', '0', 'USER_ID', uDB_AUser.Local.USER.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'arcade_mame', 'EMU_POSITION', '-1', 'USER_ID', uDB_AUser.Local.USER.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'arcade_mame', 'EMU_ACTIVE', '0', 'USER_ID', uDB_AUser.Local.USER.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'arcade_mame', 'EXTRAFE_MAME_PATH', '', 'USER_ID', uDB_AUser.Local.USER.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'arcade_mame', 'EXTRAFE_MAME_IMAGES', '', 'USER_ID', uDB_AUser.Local.USER.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'arcade_mame', 'EXTRAFE_MAME_SOUNDS', '', 'USER_ID', uDB_AUser.Local.USER.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'arcade_mame', 'EXTRAFE_MAME_VIEWS', '', 'USER_ID', uDB_AUser.Local.USER.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'arcade_mame', 'MAME_NAME', '', 'USER_ID', uDB_AUser.Local.USER.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'arcade_mame', 'MAME_PATH', '', 'USER_ID', uDB_AUser.Local.USER.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'arcade_mame', 'MAME_INI', '', 'USER_ID', uDB_AUser.Local.USER.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'arcade_mame', 'MAME_VERSION', '', 'USER_ID', uDB_AUser.Local.USER.Num.ToString);

  if Script_Mame_Uninstall.Main.Tab2.Check_2.IsChecked then
  begin
    { Delete specific user mame columns }
    uDB.Query_Delete_Column(uDB.Arcade, uDB.Arcade_Query, 'mame_status', 'fav_id_' + uDB_AUser.Local.USER.Num.ToString);
    uDB.Query_Delete_Column(uDB.Arcade, uDB.Arcade_Query, 'mame_status', 'play_count_id_' + uDB_AUser.Local.USER.Num.ToString);
    uDB.Query_Delete_Column(uDB.Arcade, uDB.Arcade_Query, 'games', 'hidden_id_' + uDB_AUser.Local.USER.Num.ToString);
  end;

  if Script_Mame_Uninstall.Main.Tab2.Check_3.IsChecked then
  begin
    {Delete mame folder and subdirecories}
  end;

  Dec(emulation.Unique_Num);
  Dec(emulation.Active_Num);

  emulation.Emu[0, 0] := 'nil';
  emulation.Arcade[0].Prog_Path := '';
  emulation.Arcade[0].Emu_Path := '';
  emulation.Arcade[0].Active := false;
  emulation.Arcade[0].Active_Place := -1;
  emulation.Arcade[0].Name := '';
  emulation.Arcade[0].Logo := '';
  emulation.Arcade[0].Background := '';
  emulation.Arcade[0].Menu_Image_Path := '';
  emulation.Arcade[0].Second_Level := -1;
  emulation.Arcade[0].Installed := false;
  emulation.Arcade[0].Unique_Num := -1;

  uMain_Emulation.Clear_Selection_Control;
  uMain_Emulation.Create_Selection_Control;
  uMain_Emulation.Category(0, 0);

  Script_Mame_Uninstall.Main.Control.SetActiveTabWithTransition(Script_Mame_Uninstall.Main.Tabs[3], TTabTransition.Slide);
  Script_Mame_Uninstall.Main.Status := 'phase_4';

  ShowButtons;
end;

procedure ShowButtons;
begin
  if Script_Mame_Uninstall.Main.Status = 'phase_1' then
  begin
    Script_Mame_Uninstall.Main.Cancel.Visible := True;
    Script_Mame_Uninstall.Main.Back.Visible := false;
    Script_Mame_Uninstall.Main.Next.Visible := True;
  end
  else if Script_Mame_Uninstall.Main.Status = 'phase_2' then
  begin
    Script_Mame_Uninstall.Main.Cancel.Visible := True;
    Script_Mame_Uninstall.Main.Back.Visible := True;
    Script_Mame_Uninstall.Main.Next.Visible := True;
  end
  else if Script_Mame_Uninstall.Main.Status = 'phase_3' then
  begin
    Script_Mame_Uninstall.Main.Cancel.Visible := True;
    Script_Mame_Uninstall.Main.Back.Visible := True;
    Script_Mame_Uninstall.Main.Next.Visible := false;
  end
  else if Script_Mame_Uninstall.Main.Status = 'phase_4' then
  begin
    Script_Mame_Uninstall.Main.Cancel.Visible := false;
    Script_Mame_Uninstall.Main.Back.Visible := false;
    Script_Mame_Uninstall.Main.Next.Visible := false;
  end
end;

procedure uEmulation_Arcade_Mame_Uninstall_Slide_To_Next;
begin
  if Script_Mame_Uninstall.Main.Status = 'phase_1' then
  begin
    Script_Mame_Uninstall.Main.Control.SetActiveTabWithTransition(Script_Mame_Uninstall.Main.Tabs[1], TTabTransition.Slide);
    Script_Mame_Uninstall.Main.Status := 'phase_2';
  end
  else if Script_Mame_Uninstall.Main.Status = 'phase_2' then
  begin
    Script_Mame_Uninstall.Main.Control.SetActiveTabWithTransition(Script_Mame_Uninstall.Main.Tabs[2], TTabTransition.Slide);
    Script_Mame_Uninstall.Main.Status := 'phase_3';
    if (Script_Mame_Uninstall.Main.Tab2.Check_2.IsChecked) and (Script_Mame_Uninstall.Main.Tab2.Check_3.IsChecked = False) then
      Script_Mame_Uninstall.Main.Tab3.Line_2.Visible := True
    else if (Script_Mame_Uninstall.Main.Tab2.Check_2.IsChecked) and (Script_Mame_Uninstall.Main.Tab2.Check_3.IsChecked) then
    begin
      Script_Mame_Uninstall.Main.Tab3.Line_2.Visible := True;
      Script_Mame_Uninstall.Main.Tab3.Line_3.Visible := True;
      Script_Mame_Uninstall.Main.Tab3.Line_2.Position.Y := 70;
      Script_Mame_Uninstall.Main.Tab3.Line_3.Position.Y := 110;
    end
    else if (Script_Mame_Uninstall.Main.Tab2.Check_2.IsChecked = False) and (Script_Mame_Uninstall.Main.Tab2.Check_3.IsChecked) then
    begin
      Script_Mame_Uninstall.Main.Tab3.Line_3.Visible := True;
      Script_Mame_Uninstall.Main.Tab3.Line_3.Position.Y := 70;
    end;
  end;
  ShowButtons;
end;

procedure uEmulation_Arcade_Mame_Uninstall_Slide_To_Previous;
begin
  if Script_Mame_Uninstall.Main.Status = 'phase_3' then
  begin
    Script_Mame_Uninstall.Main.Control.SetActiveTabWithTransition(Script_Mame_Uninstall.Main.Tabs[1], TTabTransition.Slide, TTabTransitionDirection.Reversed);
    Script_Mame_Uninstall.Main.Status := 'phase_2';
  end
  else if Script_Mame_Uninstall.Main.Status = 'phase_2' then
  begin
    Script_Mame_Uninstall.Main.Control.SetActiveTabWithTransition(Script_Mame_Uninstall.Main.Tabs[0], TTabTransition.Slide, TTabTransitionDirection.Reversed);
    Script_Mame_Uninstall.Main.Status := 'phase_1';
  end;
  ShowButtons;
end;

end.
