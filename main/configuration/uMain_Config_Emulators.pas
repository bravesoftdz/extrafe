unit uMain_Config_Emulators;

interface

uses
  System.SysUtils,
  System.UITypes,
  System.UIConsts,
  System.IniFiles,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Graphics,
  FMX.Objects,
  FMX.Platform,
  FMX.Layouts,
  FMX.Effects,
  FMX.Edit,
  FMX.Types,
  FMX.TabControl,
  FMX.ImgList,
  FMX.Filter.Effects,
  FMX.Controls,
  ALFMXObjects;

procedure uMain_Config_Emulators_Create;

procedure uMain_Config_Emulators_ShowCategory(vCategory: Integer);

procedure uMain_Config_Emulators_ShowArcade;
procedure uMain_Config_Emulators_CreateArcadePanel(vNum: Integer);

procedure uMain_Config_Emulators_ShowComputers;
procedure uMain_Config_Emulators_CreateComputersPanel(vNum: Integer);

procedure uMain_Config_Emulators_ShowConsoles;
procedure uMain_Config_Emulators_CreateConsolesPanel(vNum: Integer);

procedure uMain_Config_Emulators_ShowHandhelds;
procedure uMain_Config_Emulators_CreateHandheldsPanel(vNum: Integer);

procedure uMain_Config_Emulators_ShowPinballs;
procedure uMain_Config_Emulators_CreatePinballsPanel(vNum: Integer);

procedure uMain_Config_Emulators_Start_Emu_Wizard(vButton: TButton);

procedure uMain_Config_Emulators_Install_Emu(vEmu_Num: Integer; vEmu_Categorie: String);
procedure uMain_Config_Emulators_UnInstall_Emu(vEmu_Num: Integer; vEmu_Categorie: String);

implementation

uses
  uLoad,
  uLoad_AllTypes,
  uSnippet_Image,
  main,
  uMain_SetAll,
  uMain_AllTypes,
  uMain_Mouse,
  uMain_Config_Emulation_Arcade_Scripts_Mame_Install,
  uMain_Config_Emulation_Arcade_Scripts_Mame_Uninstall;

procedure uMain_Config_Emulators_Create;
const
  cImages_Names: array [0 .. 4] of string = ('config_arcade.png', 'config_computers.png',
    'config_consoles.png', 'config_handhelds.png', 'config_pinballs.png');
  cImages_Imagelist: array [0 .. 2] of string = ('config_computer.png', 'config_server.png',
    'config_internet.png');
var
  vi: Integer;
begin

  extrafe.prog.State:= 'main_config_emulators';

  mainScene.Config.main.R.Emulators.Panel := TPanel.Create(mainScene.Config.main.R.Panel[2]);
  mainScene.Config.main.R.Emulators.Panel.Name := 'Main_Config_Emulators_Main_Panel';
  mainScene.Config.main.R.Emulators.Panel.Parent := mainScene.Config.main.R.Panel[2];
  mainScene.Config.main.R.Emulators.Panel.Align := TAlignLayout.Client;
  mainScene.Config.main.R.Emulators.Panel.Visible := True;

  mainScene.Config.main.R.Emulators.Panel_Blur :=
    TGaussianBlurEffect.Create(mainScene.Config.main.R.Emulators.Panel);
  mainScene.Config.main.R.Emulators.Panel_Blur.Name := 'Main_Config_Emulators_Main_Blur';
  mainScene.Config.main.R.Emulators.Panel_Blur.Parent := mainScene.Config.main.R.Emulators.Panel;
  mainScene.Config.main.R.Emulators.Panel_Blur.BlurAmount := 0.2;
  mainScene.Config.main.R.Emulators.Panel_Blur.Enabled := False;

  mainScene.Config.main.R.Emulators.Groupbox := TGroupBox.Create(mainScene.Config.main.R.Emulators.Panel);
  mainScene.Config.main.R.Emulators.Groupbox.Name := 'Main_Config_Emulators_Groupbox';
  mainScene.Config.main.R.Emulators.Groupbox.Parent := mainScene.Config.main.R.Emulators.Panel;
  mainScene.Config.main.R.Emulators.Groupbox.Width := mainScene.Config.main.R.Emulators.Panel.Width - 20;
  mainScene.Config.main.R.Emulators.Groupbox.Height := 98;
  mainScene.Config.main.R.Emulators.Groupbox.Position.X := 10;
  mainScene.Config.main.R.Emulators.Groupbox.Position.Y := 10;
  mainScene.Config.main.R.Emulators.Groupbox.Text := 'Categories';
  mainScene.Config.main.R.Emulators.Groupbox.Visible := True;

  for vi := 0 to 4 do
  begin
    mainScene.Config.main.R.Emulators.Images[vi] := TImage.Create(mainScene.Config.main.R.Emulators.Groupbox);
    mainScene.Config.main.R.Emulators.Images[vi].Name := 'Main_Config_Emulators_Image_' + IntToStr(vi);
    mainScene.Config.main.R.Emulators.Images[vi].Parent := mainScene.Config.main.R.Emulators.Groupbox;
    mainScene.Config.main.R.Emulators.Images[vi].Width := 70;
    mainScene.Config.main.R.Emulators.Images[vi].Height := 70;
    mainScene.Config.main.R.Emulators.Images[vi].Position.X := 4 + (vi * 118);
    mainScene.Config.main.R.Emulators.Images[vi].Position.Y := 20;
    mainScene.Config.main.R.Emulators.Images[vi].Bitmap.LoadFromFile(ex_main.Paths.Config_Images +
      cImages_Names[vi]);
    mainScene.Config.main.R.Emulators.Images[vi].WrapMode := TImageWrapMode.Fit;
    mainScene.Config.main.R.Emulators.Images[vi].OnClick := ex_main.input.mouse_config.Image.OnMouseClick;
    mainScene.Config.main.R.Emulators.Images[vi].OnMouseEnter :=
      ex_main.input.mouse_config.Image.OnMouseEnter;
    mainScene.Config.main.R.Emulators.Images[vi].OnMouseLeave :=
      ex_main.input.mouse_config.Image.OnMouseLeave;
    mainScene.Config.main.R.Emulators.Images[vi].Tag := vi;
    mainScene.Config.main.R.Emulators.Images[vi].Visible := True;

    mainScene.Config.main.R.Emulators.Images_Glow[vi] :=
      TGlowEffect.Create(mainScene.Config.main.R.Emulators.Images[vi]);
    mainScene.Config.main.R.Emulators.Images_Glow[vi].Name := 'Main_Config_Emulators_Image_Glow_' +
      IntToStr(vi);
    mainScene.Config.main.R.Emulators.Images_Glow[vi].Parent := mainScene.Config.main.R.Emulators.Images[vi];
    mainScene.Config.main.R.Emulators.Images_Glow[vi].GlowColor := TAlphaColorRec.Deepskyblue;
    mainScene.Config.main.R.Emulators.Images_Glow[vi].Softness := 0.5;
    mainScene.Config.main.R.Emulators.Images_Glow[vi].Opacity := 0.9;
    mainScene.Config.main.R.Emulators.Images_Glow[vi].Enabled := False;
  end;

  mainScene.Config.main.R.Emulators.Dialog := TOpenDialog.Create(mainScene.Config.main.R.Emulators.Panel);
  mainScene.Config.main.R.Emulators.Dialog.Name := 'Main_Config_Emulators_Dialog';
  mainScene.Config.main.R.Emulators.Dialog.Parent := mainScene.Config.main.R.Emulators.Panel;
  mainScene.Config.main.R.Emulators.Dialog.FileName := '';
  mainScene.Config.main.R.Emulators.Dialog.OnClose := mainScene.Config.main.R.Emulators.Dialog_Object.OnClose;
end;

procedure uMain_Config_Emulators_ShowCategory(vCategory: Integer);
var
  vi: Integer;
begin
  for vi := 0 to 4 do
  begin
    if Assigned(mainScene.Config.main.R.Emulators.Panels[vi]) then
      FreeAndNil(mainScene.Config.main.R.Emulators.Panels[vi]);
  end;
  case vCategory of
    0:
      uMain_Config_Emulators_ShowArcade;
    1:
      uMain_Config_Emulators_ShowComputers;
    2:
      uMain_Config_Emulators_ShowConsoles;
    3:
      uMain_Config_Emulators_ShowHandhelds;
    4:
      uMain_Config_Emulators_ShowPinballs;
  end;
  ex_main.Config.Emulators_Active_Tab := vCategory;
end;

procedure uMain_Config_Emulators_CreateArcadePanel(vNum: Integer);
const
  cEmu_Names: array [0 .. 10] of string = ('Mame', 'Fba', 'Zinc', 'Daphne', 'Kronos', 'Raine', 'Model2',
    'SuperModel', 'Demul', '', '');
  cEmu_Image_Names: array [0 .. 10] of string = ('mame.png', 'fba.png', 'zinc.png', 'daphne.png',
    'kronos.png', 'raine.png', 'model2.png', 'supermodel.png', 'demul.png', '', '');
begin
  mainScene.Config.main.R.Emulators.Arcade[vNum].Panel :=
    TPanel.Create(mainScene.Config.main.R.Emulators.ScrollBox[0]);
  mainScene.Config.main.R.Emulators.Arcade[vNum].Panel.Name := 'Main_Config_Emulators_Arcade_' +
    cEmu_Names[vNum] + '_Panel';
  mainScene.Config.main.R.Emulators.Arcade[vNum].Panel.Parent :=
    mainScene.Config.main.R.Emulators.ScrollBox[0];
  mainScene.Config.main.R.Emulators.Arcade[vNum].Panel.Width := mainScene.Config.main.R.Emulators.ScrollBox[0]
    .Width - 25;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Panel.Height := 100;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Panel.Position.X := 5;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Panel.Position.Y := 20 + (vNum * 110);
  mainScene.Config.main.R.Emulators.Arcade[vNum].Panel.Visible := True;

  mainScene.Config.main.R.Emulators.Arcade[vNum].Panel_Image :=
    TPanel.Create(mainScene.Config.main.R.Emulators.Arcade[vNum].Panel);
  mainScene.Config.main.R.Emulators.Arcade[vNum].Panel_Image.Name := 'Main_Config_Emulators_Arcade_' +
    cEmu_Names[vNum] + '_Panel_Image';
  mainScene.Config.main.R.Emulators.Arcade[vNum].Panel_Image.Parent :=
    mainScene.Config.main.R.Emulators.Arcade[vNum].Panel;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Panel_Image.Width := 100;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Panel_Image.Height := 100;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Panel_Image.Position.X := 0;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Panel_Image.Position.Y := 0;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Panel_Image.Visible := True;

  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo :=
    TImage.Create(mainScene.Config.main.R.Emulators.Arcade[vNum].Panel_Image);
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo.Name := 'Main_Config_Emulators_Arcade_' +
    cEmu_Names[vNum] + '_Logo';
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo.Parent := mainScene.Config.main.R.Emulators.Arcade[vNum]
    .Panel_Image;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo.Width := 92;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo.Height := 92;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo.Position.X := 4;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo.Position.Y := 4;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo.Bitmap.LoadFromFile
    (ex_main.Paths.Config_Images + '\emu\arcade\' + cEmu_Image_Names[vNum]);
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo.OnClick :=
    ex_main.input.mouse_config.Image.OnMouseClick;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo.OnMouseEnter :=
    ex_main.input.mouse_config.Image.OnMouseEnter;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo.OnMouseLeave :=
    ex_main.input.mouse_config.Image.OnMouseLeave;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo.Visible := True;

  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Check :=
    TImage.Create(mainScene.Config.main.R.Emulators.Arcade[vNum].Logo);
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Check.Name := 'Main_Config_Emulators_Arcade_' +
    cEmu_Names[vNum] + '_Logo_Check';
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Check.Parent := mainScene.Config.main.R.Emulators.Arcade
    [vNum].Logo;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Check.Width := 34;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Check.Height := 34;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Check.Position.X := 2;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Check.Position.Y := 2;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Check.Bitmap.LoadFromFile
    (ex_main.Paths.Config_Images + 'config_check.png');
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Check.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Check.OnClick :=
    ex_main.input.mouse_config.Image.OnMouseClick;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Check.OnMouseEnter :=
    ex_main.input.mouse_config.Image.OnMouseEnter;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Check.OnMouseLeave :=
    ex_main.input.mouse_config.Image.OnMouseLeave;

  if emulation.Arcade[vNum].Active then
    mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Check.Visible := True
  else
    mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Check.Visible := False;

  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Glow :=
    TGlowEffect.Create(mainScene.Config.main.R.Emulators.Arcade[vNum].Logo);
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Glow.Name := 'Main_Config_Emulators_Arcade_' +
    cEmu_Names[vNum] + '_Logo_Glow';
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Glow.Parent := mainScene.Config.main.R.Emulators.Arcade
    [vNum].Logo;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Glow.Opacity := 0.9;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Glow.Softness := 0.4;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Glow.Enabled := False;

  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Gray :=
    TMonochromeEffect.Create(mainScene.Config.main.R.Emulators.Arcade[vNum].Logo);
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Gray.Name := 'Main_Config_Emulators_Arcade_' +
    cEmu_Names[vNum] + '_Logo_Gray';
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Gray.Parent := mainScene.Config.main.R.Emulators.Arcade
    [vNum].Logo;
  mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Gray.Enabled := not emulation.Arcade[0].Active;

  if emulation.Arcade[vNum].Installed then
  begin
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info :=
      TALText.Create(mainScene.Config.main.R.Emulators.Arcade[vNum].Panel);
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.Name := 'Main_Config_Emulators_' + cEmu_Names[vNum]
      + '_Info';
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.Parent := mainScene.Config.main.R.Emulators.Arcade
      [vNum].Panel;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.Width := mainScene.Config.main.R.Emulators.Arcade
      [vNum].Panel.Width - 100;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.Height := 40;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.Position.X := 110;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.Position.Y := 20;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.WordWrap := True;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.TextIsHtml := True;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.TextSettings.FontColor := TAlphaColorRec.White;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.TextSettings.Font.Size := 14;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.TextSettings.VertAlign := TTextAlign.Leading;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.Text := ' The emulator "<font color="#ff63cbfc">' +
      cEmu_Names[vNum] + '</font>" is installed in ExtraFE "<font color="#ff63cbfc">Successfully</font>".';
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.Visible := True;

    mainScene.Config.main.R.Emulators.Arcade[vNum].Action :=
      TButton.Create(mainScene.Config.main.R.Emulators.Arcade[vNum].Panel);
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Name := 'Main_Config_Emulators_' + cEmu_Names[vNum]
      + '_Action';;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Parent := mainScene.Config.main.R.Emulators.Arcade
      [vNum].Panel;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Width := 240;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Height := 34;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Position.X :=
      ((mainScene.Config.main.R.Emulators.Arcade[vNum].Panel.Width / 2) - 120) + 50;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Position.Y := 50;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Text := 'Uninstall';
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.TextSettings.FontColor := TAlphaColorRec.Red;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.StyledSettings :=
      mainScene.Config.main.R.Emulators.Arcade[vNum].Action.StyledSettings - [TStyledSetting.FontColor];
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.OnClick :=
      ex_main.input.mouse_config.Button.OnMouseClick;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.TagFloat := 1000;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Tag := vNum;
    if vNum <> 0 then
      mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Enabled := False
    else
      mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Enabled := True;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Visible := True;
  end
  else
  begin
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info :=
      TALText.Create(mainScene.Config.main.R.Emulators.Arcade[vNum].Panel);
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.Name := 'Main_Config_Emulators_' + cEmu_Names[vNum]
      + '_Info';
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.Parent := mainScene.Config.main.R.Emulators.Arcade
      [vNum].Panel;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.Width := mainScene.Config.main.R.Emulators.Arcade
      [vNum].Panel.Width - 100;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.Height := 40;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.Position.X := 110;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.Position.Y := 20;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.WordWrap := True;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.TextIsHtml := True;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.TextSettings.FontColor := TAlphaColorRec.White;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.TextSettings.Font.Size := 14;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.TextSettings.VertAlign := TTextAlign.Leading;
    if vNum <> 0 then
      mainScene.Config.main.R.Emulators.Arcade[vNum].Info.Text :=
        '"<font color="#ff63cbfc">WIP</font>" Script is not ready to install "<font color="#ff63cbfc">' +
        cEmu_Names[vNum] + '</font>" emulator.'
    else
      mainScene.Config.main.R.Emulators.Arcade[vNum].Info.Text :=
        ' Click to start "<font color="#ff63cbfc">Installing</font>" to ExtraFE then"<font color="#ff63cbfc">'
        + cEmu_Names[vNum] + '</font>" emulator.';
    mainScene.Config.main.R.Emulators.Arcade[vNum].Info.Visible := True;

    mainScene.Config.main.R.Emulators.Arcade[vNum].Action :=
      TButton.Create(mainScene.Config.main.R.Emulators.Arcade[vNum].Panel);
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Name := 'Main_Config_Emulators_' + cEmu_Names[vNum]
      + '_Action';;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Parent := mainScene.Config.main.R.Emulators.Arcade
      [vNum].Panel;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Width := 240;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Height := 34;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Position.X :=
      ((mainScene.Config.main.R.Emulators.Arcade[vNum].Panel.Width / 2) - 120) + 50;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Position.Y := 50;
    if vNum <> 0 then
      mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Text := 'Wait for update'
    else
      mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Text := 'Install';
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.TextSettings.FontColor :=
      TAlphaColorRec.Deepskyblue;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.StyledSettings :=
      mainScene.Config.main.R.Emulators.Arcade[vNum].Action.StyledSettings - [TStyledSetting.FontColor];
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.OnClick :=
      ex_main.input.mouse_config.Button.OnMouseClick;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.TagFloat := 1000;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Tag := vNum;
    if vNum <> 0 then
      mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Enabled := False
    else
      mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Enabled := True;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Action.Visible := True;
    mainScene.Config.main.R.Emulators.Arcade[vNum].Logo_Gray.Enabled := True;
  end;
end;

procedure uMain_Config_Emulators_ShowArcade;
var
  vi: Integer;
begin
  mainScene.Config.main.R.Emulators.Panels[0] :=
    TCalloutPanel.Create(mainScene.Config.main.R.Emulators.Panel);
  mainScene.Config.main.R.Emulators.Panels[0].Name := 'Main_Config_Emulators_CallPanel_' + IntToStr(0);
  mainScene.Config.main.R.Emulators.Panels[0].Parent := mainScene.Config.main.R.Emulators.Panel;
  mainScene.Config.main.R.Emulators.Panels[0].Width := mainScene.Config.main.R.Emulators.Panel.Width - 20;
  mainScene.Config.main.R.Emulators.Panels[0].Height := mainScene.Config.main.R.Emulators.Panel.Height - 120;
  mainScene.Config.main.R.Emulators.Panels[0].Position.X := 10;
  mainScene.Config.main.R.Emulators.Panels[0].Position.Y := 110;
  mainScene.Config.main.R.Emulators.Panels[0].CalloutOffset := 25;
  mainScene.Config.main.R.Emulators.Panels[0].Visible := True;

  mainScene.Config.main.R.Emulators.ScrollBox[0] :=
    TVertScrollBox.Create(mainScene.Config.main.R.Emulators.Panels[0]);
  mainScene.Config.main.R.Emulators.ScrollBox[0].Name := 'Main_Config_Emulators_Scrollbox_' + IntToStr(0);
  mainScene.Config.main.R.Emulators.ScrollBox[0].Parent := mainScene.Config.main.R.Emulators.Panels[0];
  mainScene.Config.main.R.Emulators.ScrollBox[0].Width := mainScene.Config.main.R.Emulators.Panels[0]
    .Width - 10;
  mainScene.Config.main.R.Emulators.ScrollBox[0].Height := mainScene.Config.main.R.Emulators.Panels[0]
    .Height - 10;
  mainScene.Config.main.R.Emulators.ScrollBox[0].Position.X := 5;
  mainScene.Config.main.R.Emulators.ScrollBox[0].Position.Y := 5;
  mainScene.Config.main.R.Emulators.ScrollBox[0].ShowScrollBars := True;
  mainScene.Config.main.R.Emulators.ScrollBox[0].Visible := True;

  for vi := 0 to 8 do
    uMain_Config_Emulators_CreateArcadePanel(vi);
end;

procedure uMain_Config_Emulators_CreateComputersPanel(vNum: Integer);
const
  cEmu_Names: array [0 .. 10] of string = ('Acorn Archimedes', 'Amiga 500/600/1000/4000', 'Amstrad 464/6128',
    'Atari 800XL', 'Atari ST/STE/TT/Falcon', 'Commodore 64', 'MsDOS', 'Old PC Windows', 'Scummvm', 'Spectrum',
    'x68000');
  cEmu_Panel_Names: array [0 .. 10] of string = ('Acorn_Archimedes', 'Amiga_500', 'Amstrad_6128',
    'Atari_800XL', 'Atari_ST', 'Commodore_64', 'MsDOS', 'Old_PC', 'Scummvm', 'Spectrum', 'x68000');
  cEmu_Image_Names: array [0 .. 10] of string = ('acorn_archimedes.png', 'amiga.png', 'amstrad_6128.png',
    'atari_800xl.png', 'atari_st.png', 'commodore_64.png', 'msdos.png', 'old_pc.png', 'scummvm.png',
    'spectrum.png', 'x68000.png');
begin
  mainScene.Config.main.R.Emulators.Computers[vNum].Panel :=
    TPanel.Create(mainScene.Config.main.R.Emulators.ScrollBox[1]);
  mainScene.Config.main.R.Emulators.Computers[vNum].Panel.Name := 'Main_Config_Emulators_Computers_' +
    cEmu_Panel_Names[vNum] + '_Panel';
  mainScene.Config.main.R.Emulators.Computers[vNum].Panel.Parent :=
    mainScene.Config.main.R.Emulators.ScrollBox[1];
  mainScene.Config.main.R.Emulators.Computers[vNum].Panel.Width := mainScene.Config.main.R.Emulators.ScrollBox
    [1].Width - 25;
  mainScene.Config.main.R.Emulators.Computers[vNum].Panel.Height := 100;
  mainScene.Config.main.R.Emulators.Computers[vNum].Panel.Position.X := 5;
  mainScene.Config.main.R.Emulators.Computers[vNum].Panel.Position.Y := 20 + (vNum * 110);
  mainScene.Config.main.R.Emulators.Computers[vNum].Panel.Visible := True;

  mainScene.Config.main.R.Emulators.Computers[vNum].Panel_Image :=
    TPanel.Create(mainScene.Config.main.R.Emulators.Computers[vNum].Panel);
  mainScene.Config.main.R.Emulators.Computers[vNum].Panel_Image.Name := 'Main_Config_Emulators_Computers_' +
    cEmu_Panel_Names[vNum] + '_Panel_Image';
  mainScene.Config.main.R.Emulators.Computers[vNum].Panel_Image.Parent :=
    mainScene.Config.main.R.Emulators.Computers[vNum].Panel;
  mainScene.Config.main.R.Emulators.Computers[vNum].Panel_Image.Width := 100;
  mainScene.Config.main.R.Emulators.Computers[vNum].Panel_Image.Height := 100;
  mainScene.Config.main.R.Emulators.Computers[vNum].Panel_Image.Position.X := 0;
  mainScene.Config.main.R.Emulators.Computers[vNum].Panel_Image.Position.Y := 0;
  mainScene.Config.main.R.Emulators.Computers[vNum].Panel_Image.Visible := True;

  mainScene.Config.main.R.Emulators.Computers[vNum].Logo :=
    TImage.Create(mainScene.Config.main.R.Emulators.Computers[vNum].Panel_Image);
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo.Name := 'Main_Config_Emulators_Computers_' +
    cEmu_Panel_Names[vNum] + '_Logo';
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo.Parent := mainScene.Config.main.R.Emulators.Computers
    [vNum].Panel_Image;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo.Width := 92;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo.Height := 92;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo.Position.X := 4;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo.Position.Y := 4;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo.Bitmap.LoadFromFile
    (ex_main.Paths.Config_Images + '\emu\computers\' + cEmu_Image_Names[vNum]);
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo.OnClick :=
    ex_main.input.mouse_config.Image.OnMouseClick;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo.OnMouseEnter :=
    ex_main.input.mouse_config.Image.OnMouseEnter;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo.OnMouseLeave :=
    ex_main.input.mouse_config.Image.OnMouseLeave;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo.Visible := True;

  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Check :=
    TImage.Create(mainScene.Config.main.R.Emulators.Computers[vNum].Logo);
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Check.Name := 'Main_Config_Emulators_Computers_' +
    cEmu_Panel_Names[vNum] + '_Logo_Check';
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Check.Parent :=
    mainScene.Config.main.R.Emulators.Computers[vNum].Logo;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Check.Width := 34;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Check.Height := 34;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Check.Position.X := 2;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Check.Position.Y := 2;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Check.Bitmap.LoadFromFile
    (ex_main.Paths.Config_Images + 'config_check.png');
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Check.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Check.OnClick :=
    ex_main.input.mouse_config.Image.OnMouseClick;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Check.OnMouseEnter :=
    ex_main.input.mouse_config.Image.OnMouseEnter;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Check.OnMouseLeave :=
    ex_main.input.mouse_config.Image.OnMouseLeave;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Check.Visible := False;

  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Glow :=
    TGlowEffect.Create(mainScene.Config.main.R.Emulators.Computers[vNum].Logo);
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Glow.Name := 'Main_Config_Emulators_Computers_' +
    cEmu_Panel_Names[vNum] + '_Logo_Glow';
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Glow.Parent :=
    mainScene.Config.main.R.Emulators.Computers[vNum].Logo;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Glow.Opacity := 0.9;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Glow.Softness := 0.4;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Glow.Enabled := False;

  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Gray :=
    TMonochromeEffect.Create(mainScene.Config.main.R.Emulators.Computers[vNum].Logo);
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Gray.Name := 'Main_Config_Emulators_Computers_' +
    cEmu_Panel_Names[vNum] + '_Logo_Gray';
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Gray.Parent :=
    mainScene.Config.main.R.Emulators.Computers[vNum].Logo;
  mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Gray.Enabled := not emulation.Computers[0].Active;

  if emulation.Computers[vNum].Installed then
  begin
    mainScene.Config.main.R.Emulators.Computers[vNum].Info :=
      TALText.Create(mainScene.Config.main.R.Emulators.Computers[vNum].Panel);
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.Name := 'Main_Config_Emulators_' + cEmu_Panel_Names
      [vNum] + '_Info';
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.Parent :=
      mainScene.Config.main.R.Emulators.Computers[vNum].Panel;
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.Width :=
      mainScene.Config.main.R.Emulators.Computers[vNum].Panel.Width - 100;
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.Height := 40;
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.Position.X := 110;
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.Position.Y := 20;
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.WordWrap := True;
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.TextIsHtml := True;
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.TextSettings.FontColor := TAlphaColorRec.White;
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.TextSettings.Font.Size := 14;
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.TextSettings.VertAlign := TTextAlign.Leading;
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.Text := ' The emulator "<font color="#ff63cbfc">' +
      cEmu_Names[vNum] + '</font>" is installed in ExtraFE "<font color="#ff63cbfc">Successfully</font>".';
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.Visible := True;

    mainScene.Config.main.R.Emulators.Computers[vNum].Action :=
      TButton.Create(mainScene.Config.main.R.Emulators.Computers[vNum].Panel);
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.Name := 'Main_Config_Emulators_' +
      cEmu_Panel_Names[vNum] + '_Action';;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.Parent :=
      mainScene.Config.main.R.Emulators.Computers[vNum].Panel;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.Width := 240;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.Height := 34;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.Position.X :=
      ((mainScene.Config.main.R.Emulators.Computers[vNum].Panel.Width / 2) - 120) + 50;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.Position.Y := 50;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.Text := 'Uninstall';
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.TextSettings.FontColor := TAlphaColorRec.Red;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.StyledSettings :=
      mainScene.Config.main.R.Emulators.Computers[vNum].Action.StyledSettings - [TStyledSetting.FontColor];
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.OnClick :=
      ex_main.input.mouse_config.Button.OnMouseClick;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.TagFloat := 1000;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.Tag := vNum;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.Enabled := True;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.Visible := True;
    mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Gray.Enabled := True;
  end
  else
  begin
    mainScene.Config.main.R.Emulators.Computers[vNum].Info :=
      TALText.Create(mainScene.Config.main.R.Emulators.Computers[vNum].Panel);
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.Name := 'Main_Config_Emulators_' + cEmu_Panel_Names
      [vNum] + '_Info';
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.Parent :=
      mainScene.Config.main.R.Emulators.Computers[vNum].Panel;
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.Width :=
      mainScene.Config.main.R.Emulators.Computers[vNum].Panel.Width - 100;
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.Height := 40;
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.Position.X := 110;
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.Position.Y := 20;
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.WordWrap := True;
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.TextIsHtml := True;
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.TextSettings.FontColor := TAlphaColorRec.White;
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.TextSettings.Font.Size := 14;
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.TextSettings.VertAlign := TTextAlign.Leading;
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.Text :=
      '"<font color="#ff63cbfc">WIP</font>" Script is not ready to install "<font color="#ff63cbfc">' +
      cEmu_Names[vNum] + '</font>" emulator.';
    mainScene.Config.main.R.Emulators.Computers[vNum].Info.Visible := True;

    mainScene.Config.main.R.Emulators.Computers[vNum].Action :=
      TButton.Create(mainScene.Config.main.R.Emulators.Computers[vNum].Panel);
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.Name := 'Main_Config_Emulators_' +
      cEmu_Panel_Names[vNum] + '_Action';;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.Parent :=
      mainScene.Config.main.R.Emulators.Computers[vNum].Panel;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.Width := 240;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.Height := 34;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.Position.X :=
      ((mainScene.Config.main.R.Emulators.Computers[vNum].Panel.Width / 2) - 120) + 50;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.Position.Y := 50;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.Text := 'Wait for update';
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.TextSettings.FontColor :=
      TAlphaColorRec.Deepskyblue;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.StyledSettings :=
      mainScene.Config.main.R.Emulators.Computers[vNum].Action.StyledSettings - [TStyledSetting.FontColor];
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.OnClick :=
      ex_main.input.mouse_config.Button.OnMouseClick;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.TagFloat := 1000;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.Tag := vNum;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.Enabled := False;
    mainScene.Config.main.R.Emulators.Computers[vNum].Action.Visible := True;
    mainScene.Config.main.R.Emulators.Computers[vNum].Logo_Gray.Enabled := True;
  end;
end;

procedure uMain_Config_Emulators_ShowComputers;
var
  vi: Integer;
begin
  mainScene.Config.main.R.Emulators.Panels[1] :=
    TCalloutPanel.Create(mainScene.Config.main.R.Emulators.Panel);
  mainScene.Config.main.R.Emulators.Panels[1].Name := 'Main_Config_Emulators_CallPanel_' + IntToStr(1);
  mainScene.Config.main.R.Emulators.Panels[1].Parent := mainScene.Config.main.R.Emulators.Panel;
  mainScene.Config.main.R.Emulators.Panels[1].Width := mainScene.Config.main.R.Emulators.Panel.Width - 20;
  mainScene.Config.main.R.Emulators.Panels[1].Height := mainScene.Config.main.R.Emulators.Panel.Height - 120;
  mainScene.Config.main.R.Emulators.Panels[1].Position.X := 10;
  mainScene.Config.main.R.Emulators.Panels[1].Position.Y := 110;
  mainScene.Config.main.R.Emulators.Panels[1].CalloutOffset := 154;
  mainScene.Config.main.R.Emulators.Panels[1].Visible := True;

  mainScene.Config.main.R.Emulators.ScrollBox[1] :=
    TVertScrollBox.Create(mainScene.Config.main.R.Emulators.Panels[1]);
  mainScene.Config.main.R.Emulators.ScrollBox[1].Name := 'Main_Config_Emulators_Scrollbox_' + IntToStr(1);
  mainScene.Config.main.R.Emulators.ScrollBox[1].Parent := mainScene.Config.main.R.Emulators.Panels[1];
  mainScene.Config.main.R.Emulators.ScrollBox[1].Width := mainScene.Config.main.R.Emulators.Panels[1]
    .Width - 10;
  mainScene.Config.main.R.Emulators.ScrollBox[1].Height := mainScene.Config.main.R.Emulators.Panels[1]
    .Height - 10;
  mainScene.Config.main.R.Emulators.ScrollBox[1].Position.X := 5;
  mainScene.Config.main.R.Emulators.ScrollBox[1].Position.Y := 5;
  mainScene.Config.main.R.Emulators.ScrollBox[1].ShowScrollBars := True;
  mainScene.Config.main.R.Emulators.ScrollBox[1].Visible := True;

  for vi := 0 to 10 do
    uMain_Config_Emulators_CreateComputersPanel(vi);
end;

procedure uMain_Config_Emulators_CreateConsolesPanel(vNum: Integer);
const
  cEmu_Names: array [0 .. 30] of string = ('3DO', 'Amiga CD32', 'Atari 2600', 'Atari 5200', 'Atari 7800',
    'Atari Jaguar', 'Neo Geo', 'Neo Geo CD', 'NES', 'Super NES', 'Nintendo 64', 'Gamecube', 'Wii', 'Wii U',
    'Nintendo Switch', 'Pc Engine', 'Pc Engine CD/Duo', 'PC FX', 'Playstation', 'Playstation 2',
    'Playstation 3', 'Sg 1000', 'Sega Master System', 'Mega Drive', 'Mega Drive 32X', 'Mega Drive CD',
    'Saturn', 'Dreamcast', 'XBOX', 'XBOX ONE', '');
  cEmu_Panel_Names: array [0 .. 30] of string = ('3DO', 'Amiga_CD32', 'Atari_2600', 'Atari_5200',
    'Atari_7800', 'Atari_Jaguar', 'Neo_Geo', 'Neo_Geo_CD', 'NES', 'Super_NES', 'Nintendo_64', 'Gamecube',
    'Wii', 'Wii_U', 'Nintendo_Switch', 'Pc_Engine', 'Pc_Engine_CD_Duo', 'PC_FX', 'Playstation',
    'Playstation_2', 'Playstation_3', 'Sg_1000', 'Sega_Master_System', 'Mega_Drive', 'Mega_Drive_32X',
    'Mega_Drive_CD', 'Saturn', 'Dreamcast', 'XBOX', 'XBOX_ONE', '');
  cEmu_Image_Names: array [0 .. 30] of string = ('3do.png', 'amiga_cd32.png', 'atari_2600.png',
    'atari_5200.png', 'atari_7800.png', 'atari_jaguar.png', 'neogeo.png', 'neogeo_cd.png', 'nintendo_nes.png',
    'nintendo_supernes.png', 'nintendo_64.png', 'nintendo_gamecube.png', 'nintendo_wii.png',
    'nintendo_wiiu.png', 'nintendo_switch.png', 'pc_engine.png', 'pc_engine_cd.png', 'pc_fx.png',
    'playstation_1.png', 'playstation_2.png', 'playstation_3.png', 'sega_sg1000.png',
    'sega_master_system.png', 'sega_megadrive.png', 'sega_megadrive_32x.png', 'sega_megadrive_cd.png',
    'sega_saturn.png', 'sega_dreamcast.png', 'xbox.png', 'xbox_one.png', '');
begin
  mainScene.Config.main.R.Emulators.Consoles[vNum].Panel :=
    TPanel.Create(mainScene.Config.main.R.Emulators.ScrollBox[2]);
  mainScene.Config.main.R.Emulators.Consoles[vNum].Panel.Name := 'Main_Config_Emulators_Consoles_' +
    cEmu_Panel_Names[vNum] + '_Panel';
  mainScene.Config.main.R.Emulators.Consoles[vNum].Panel.Parent :=
    mainScene.Config.main.R.Emulators.ScrollBox[2];
  mainScene.Config.main.R.Emulators.Consoles[vNum].Panel.Width := mainScene.Config.main.R.Emulators.ScrollBox
    [2].Width - 25;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Panel.Height := 100;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Panel.Position.X := 5;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Panel.Position.Y := 20 + (vNum * 110);
  mainScene.Config.main.R.Emulators.Consoles[vNum].Panel.Visible := True;

  mainScene.Config.main.R.Emulators.Consoles[vNum].Panel_Image :=
    TPanel.Create(mainScene.Config.main.R.Emulators.Consoles[vNum].Panel);
  mainScene.Config.main.R.Emulators.Consoles[vNum].Panel_Image.Name := 'Main_Config_Emulators_Consoles_' +
    cEmu_Panel_Names[vNum] + '_Panel_Image';
  mainScene.Config.main.R.Emulators.Consoles[vNum].Panel_Image.Parent :=
    mainScene.Config.main.R.Emulators.Consoles[vNum].Panel;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Panel_Image.Width := 100;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Panel_Image.Height := 100;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Panel_Image.Position.X := 0;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Panel_Image.Position.Y := 0;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Panel_Image.Visible := True;

  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo :=
    TImage.Create(mainScene.Config.main.R.Emulators.Consoles[vNum].Panel_Image);
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo.Name := 'Main_Config_Emulators_Consoles_' +
    cEmu_Panel_Names[vNum] + '_Logo';
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo.Parent := mainScene.Config.main.R.Emulators.Consoles
    [vNum].Panel_Image;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo.Width := 92;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo.Height := 92;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo.Position.X := 4;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo.Position.Y := 4;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo.Bitmap.LoadFromFile
    (ex_main.Paths.Config_Images + '\emu\consoles\' + cEmu_Image_Names[vNum]);
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo.OnClick :=
    ex_main.input.mouse_config.Image.OnMouseClick;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo.OnMouseEnter :=
    ex_main.input.mouse_config.Image.OnMouseEnter;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo.OnMouseLeave :=
    ex_main.input.mouse_config.Image.OnMouseLeave;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo.Visible := True;

  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Check :=
    TImage.Create(mainScene.Config.main.R.Emulators.Consoles[vNum].Logo);
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Check.Name := 'Main_Config_Emulators_Consoles_' +
    cEmu_Panel_Names[vNum] + '_Logo_Check';
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Check.Parent :=
    mainScene.Config.main.R.Emulators.Consoles[vNum].Logo;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Check.Width := 34;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Check.Height := 34;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Check.Position.X := 2;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Check.Position.Y := 2;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Check.Bitmap.LoadFromFile
    (ex_main.Paths.Config_Images + 'config_check.png');
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Check.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Check.OnClick :=
    ex_main.input.mouse_config.Image.OnMouseClick;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Check.OnMouseEnter :=
    ex_main.input.mouse_config.Image.OnMouseEnter;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Check.OnMouseLeave :=
    ex_main.input.mouse_config.Image.OnMouseLeave;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Check.Visible := False;

  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Glow :=
    TGlowEffect.Create(mainScene.Config.main.R.Emulators.Consoles[vNum].Logo);
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Glow.Name := 'Main_Config_Emulators_Consoles_' +
    cEmu_Panel_Names[vNum] + '_Logo_Glow';
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Glow.Parent :=
    mainScene.Config.main.R.Emulators.Consoles[vNum].Logo;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Glow.Opacity := 0.9;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Glow.Softness := 0.4;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Glow.Enabled := False;

  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Gray :=
    TMonochromeEffect.Create(mainScene.Config.main.R.Emulators.Consoles[vNum].Logo);
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Gray.Name := 'Main_Config_Emulators_Consoles_' +
    cEmu_Panel_Names[vNum] + '_Logo_Gray';
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Gray.Parent :=
    mainScene.Config.main.R.Emulators.Consoles[vNum].Logo;
  mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Gray.Enabled := not emulation.Consoles[0].Active;

  if emulation.Consoles[vNum].Installed then
  begin
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info :=
      TALText.Create(mainScene.Config.main.R.Emulators.Consoles[vNum].Panel);
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.Name := 'Main_Config_Emulators_' + cEmu_Panel_Names
      [vNum] + '_Info';
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.Parent := mainScene.Config.main.R.Emulators.Consoles
      [vNum].Panel;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.Width := mainScene.Config.main.R.Emulators.Consoles
      [vNum].Panel.Width - 100;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.Height := 40;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.Position.X := 110;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.Position.Y := 20;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.WordWrap := True;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.TextIsHtml := True;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.TextSettings.FontColor := TAlphaColorRec.White;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.TextSettings.Font.Size := 14;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.TextSettings.VertAlign := TTextAlign.Leading;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.Text := ' The emulator "<font color="#ff63cbfc">' +
      cEmu_Names[vNum] + '</font>" is installed in ExtraFE "<font color="#ff63cbfc">Successfully</font>".';
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.Visible := True;

    mainScene.Config.main.R.Emulators.Consoles[vNum].Action :=
      TButton.Create(mainScene.Config.main.R.Emulators.Consoles[vNum].Panel);
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.Name := 'Main_Config_Emulators_' +
      cEmu_Panel_Names[vNum] + '_Action';;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.Parent :=
      mainScene.Config.main.R.Emulators.Consoles[vNum].Panel;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.Width := 240;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.Height := 34;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.Position.X :=
      ((mainScene.Config.main.R.Emulators.Consoles[vNum].Panel.Width / 2) - 120) + 50;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.Position.Y := 50;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.Text := 'Uninstall';
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.TextSettings.FontColor := TAlphaColorRec.Red;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.StyledSettings :=
      mainScene.Config.main.R.Emulators.Consoles[vNum].Action.StyledSettings - [TStyledSetting.FontColor];
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.OnClick :=
      ex_main.input.mouse_config.Button.OnMouseClick;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.TagFloat := 1000;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.Tag := vNum;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.Enabled := True;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.Visible := True;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Gray.Enabled := True;
  end
  else
  begin
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info :=
      TALText.Create(mainScene.Config.main.R.Emulators.Consoles[vNum].Panel);
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.Name := 'Main_Config_Emulators_' + cEmu_Panel_Names
      [vNum] + '_Info';
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.Parent := mainScene.Config.main.R.Emulators.Consoles
      [vNum].Panel;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.Width := mainScene.Config.main.R.Emulators.Consoles
      [vNum].Panel.Width - 100;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.Height := 40;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.Position.X := 110;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.Position.Y := 20;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.WordWrap := True;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.TextIsHtml := True;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.TextSettings.FontColor := TAlphaColorRec.White;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.TextSettings.Font.Size := 14;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.TextSettings.VertAlign := TTextAlign.Leading;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.Text :=
      '"<font color="#ff63cbfc">WIP</font>" Script is not ready to install "<font color="#ff63cbfc">' +
      cEmu_Names[vNum] + '</font>" emulator.';
    mainScene.Config.main.R.Emulators.Consoles[vNum].Info.Visible := True;

    mainScene.Config.main.R.Emulators.Consoles[vNum].Action :=
      TButton.Create(mainScene.Config.main.R.Emulators.Consoles[vNum].Panel);
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.Name := 'Main_Config_Emulators_' +
      cEmu_Panel_Names[vNum] + '_Action';;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.Parent :=
      mainScene.Config.main.R.Emulators.Consoles[vNum].Panel;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.Width := 240;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.Height := 34;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.Position.X :=
      ((mainScene.Config.main.R.Emulators.Consoles[vNum].Panel.Width / 2) - 120) + 50;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.Position.Y := 50;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.Text := 'Wait for update';
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.TextSettings.FontColor :=
      TAlphaColorRec.Deepskyblue;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.StyledSettings :=
      mainScene.Config.main.R.Emulators.Consoles[vNum].Action.StyledSettings - [TStyledSetting.FontColor];
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.OnClick :=
      ex_main.input.mouse_config.Button.OnMouseClick;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.TagFloat := 1000;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.Tag := vNum;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.Enabled := False;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Action.Visible := True;
    mainScene.Config.main.R.Emulators.Consoles[vNum].Logo_Gray.Enabled := True;
  end;
end;

procedure uMain_Config_Emulators_ShowConsoles;
var
  vi: Integer;
begin
  mainScene.Config.main.R.Emulators.Panels[2] :=
    TCalloutPanel.Create(mainScene.Config.main.R.Emulators.Panel);
  mainScene.Config.main.R.Emulators.Panels[2].Name := 'Main_Config_Emulators_CallPanel_' + IntToStr(2);
  mainScene.Config.main.R.Emulators.Panels[2].Parent := mainScene.Config.main.R.Emulators.Panel;
  mainScene.Config.main.R.Emulators.Panels[2].Width := mainScene.Config.main.R.Emulators.Panel.Width - 20;
  mainScene.Config.main.R.Emulators.Panels[2].Height := mainScene.Config.main.R.Emulators.Panel.Height - 120;
  mainScene.Config.main.R.Emulators.Panels[2].Position.X := 10;
  mainScene.Config.main.R.Emulators.Panels[2].Position.Y := 110;
  mainScene.Config.main.R.Emulators.Panels[2].CalloutOffset := 262;
  mainScene.Config.main.R.Emulators.Panels[2].Visible := True;

  mainScene.Config.main.R.Emulators.ScrollBox[2] :=
    TVertScrollBox.Create(mainScene.Config.main.R.Emulators.Panels[2]);
  mainScene.Config.main.R.Emulators.ScrollBox[2].Name := 'Main_Config_Emulators_Scrollbox_' + IntToStr(2);
  mainScene.Config.main.R.Emulators.ScrollBox[2].Parent := mainScene.Config.main.R.Emulators.Panels[2];
  mainScene.Config.main.R.Emulators.ScrollBox[2].Width := mainScene.Config.main.R.Emulators.Panels[2]
    .Width - 10;
  mainScene.Config.main.R.Emulators.ScrollBox[2].Height := mainScene.Config.main.R.Emulators.Panels[2]
    .Height - 10;
  mainScene.Config.main.R.Emulators.ScrollBox[2].Position.X := 5;
  mainScene.Config.main.R.Emulators.ScrollBox[2].Position.Y := 5;
  mainScene.Config.main.R.Emulators.ScrollBox[2].ShowScrollBars := True;
  mainScene.Config.main.R.Emulators.ScrollBox[2].Visible := True;

  for vi := 0 to 29 do
    uMain_Config_Emulators_CreateConsolesPanel(vi);
end;

procedure uMain_Config_Emulators_CreateHandheldsPanel(vNum: Integer);
const
  cEmu_Names: array [0 .. 11] of string = ('Atari Lynx', 'NeoGeo Pocket', 'Game & Watch', 'Gameboy',
    'Gameboy Color', 'Gameboy VirtualBoy', 'Gameboy Advance', 'Nintendo DS', 'Nintendo 3DS', 'PSP',
    'PSP Vita', 'Wonderswan');
  cEmu_Panel_Names: array [0 .. 11] of string = ('Atari_Lynx', 'NeoGeo_Pocket', 'Game_Watch', 'Gameboy',
    'Gameboy_Color', 'Gameboy_VirtualBoy', 'Gameboy_Advance', 'Nintendo_DS', 'Nintendo_3DS', 'PSP',
    'PSP_Vita', 'Wonderswan');
  cEmu_Image_Names: array [0 .. 11] of string = ('lynx.png', 'neogeo_pocket.png', 'game_watch.png',
    'gameboy.png', 'gameboy_color.png', 'gameboy_virtualboy.png', 'gameboy_advance.png', 'nintendo_ds.png',
    'nintendo_3ds.png', 'psp.png', 'psp_vita.png', 'wonderswan.png');
begin
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel :=
    TPanel.Create(mainScene.Config.main.R.Emulators.ScrollBox[3]);
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel.Name := 'Main_Config_Emulators_Handhelds_' +
    cEmu_Panel_Names[vNum] + '_Panel';
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel.Parent :=
    mainScene.Config.main.R.Emulators.ScrollBox[3];
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel.Width := mainScene.Config.main.R.Emulators.ScrollBox
    [3].Width - 25;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel.Height := 100;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel.Position.X := 5;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel.Position.Y := 20 + (vNum * 110);
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel.Visible := True;

  mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel_Image :=
    TPanel.Create(mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel);
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel_Image.Name := 'Main_Config_Emulators_Handhelds_' +
    cEmu_Panel_Names[vNum] + '_Panel_Image';
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel_Image.Parent :=
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel_Image.Width := 100;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel_Image.Height := 100;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel_Image.Position.X := 0;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel_Image.Position.Y := 0;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel_Image.Visible := True;

  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo :=
    TImage.Create(mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel_Image);
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo.Name := 'Main_Config_Emulators_Handhelds_' +
    cEmu_Panel_Names[vNum] + '_Logo';
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo.Parent := mainScene.Config.main.R.Emulators.Handhelds
    [vNum].Panel_Image;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo.Width := 92;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo.Height := 92;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo.Position.X := 4;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo.Position.Y := 4;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo.Bitmap.LoadFromFile
    (ex_main.Paths.Config_Images + '\emu\handhelds\' + cEmu_Image_Names[vNum]);
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo.OnClick :=
    ex_main.input.mouse_config.Image.OnMouseClick;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo.OnMouseEnter :=
    ex_main.input.mouse_config.Image.OnMouseEnter;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo.OnMouseLeave :=
    ex_main.input.mouse_config.Image.OnMouseLeave;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo.Visible := True;

  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Check :=
    TImage.Create(mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo);
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Check.Name := 'Main_Config_Emulators_Handhelds_' +
    cEmu_Panel_Names[vNum] + '_Logo_Check';
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Check.Parent :=
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Check.Width := 34;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Check.Height := 34;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Check.Position.X := 2;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Check.Position.Y := 2;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Check.Bitmap.LoadFromFile
    (ex_main.Paths.Config_Images + 'config_check.png');
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Check.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Check.OnClick :=
    ex_main.input.mouse_config.Image.OnMouseClick;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Check.OnMouseEnter :=
    ex_main.input.mouse_config.Image.OnMouseEnter;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Check.OnMouseLeave :=
    ex_main.input.mouse_config.Image.OnMouseLeave;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Check.Visible := False;

  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Glow :=
    TGlowEffect.Create(mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo);
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Glow.Name := 'Main_Config_Emulators_Handhelds_' +
    cEmu_Panel_Names[vNum] + '_Logo_Glow';
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Glow.Parent :=
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Glow.Opacity := 0.9;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Glow.Softness := 0.4;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Glow.Enabled := False;

  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Gray :=
    TMonochromeEffect.Create(mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo);
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Gray.Name := 'Main_Config_Emulators_Handhelds_' +
    cEmu_Panel_Names[vNum] + '_Logo_Gray';
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Gray.Parent :=
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo;
  mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Gray.Enabled := not emulation.Computers[0].Active;

  if emulation.Handhelds[vNum].Installed then
  begin
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info :=
      TALText.Create(mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel);
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.Name := 'Main_Config_Emulators_' + cEmu_Panel_Names
      [vNum] + '_Info';
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.Parent :=
      mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.Width :=
      mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel.Width - 100;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.Height := 40;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.Position.X := 110;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.Position.Y := 20;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.WordWrap := True;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.TextIsHtml := True;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.TextSettings.FontColor := TAlphaColorRec.White;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.TextSettings.Font.Size := 14;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.TextSettings.VertAlign := TTextAlign.Leading;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.Text := ' The emulator "<font color="#ff63cbfc">' +
      cEmu_Names[vNum] + '</font>" is installed in ExtraFE "<font color="#ff63cbfc">Successfully</font>".';
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.Visible := True;

    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action :=
      TButton.Create(mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel);
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.Name := 'Main_Config_Emulators_' +
      cEmu_Panel_Names[vNum] + '_Action';
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.Parent :=
      mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.Width := 240;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.Height := 34;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.Position.X :=
      ((mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel.Width / 2) - 120) + 50;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.Position.Y := 50;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.Text := 'Uninstall';
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.TextSettings.FontColor := TAlphaColorRec.Red;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.StyledSettings :=
      mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.StyledSettings - [TStyledSetting.FontColor];
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.OnClick :=
      ex_main.input.mouse_config.Button.OnMouseClick;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.TagFloat := 1000;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.Tag := vNum;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.Enabled := True;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.Visible := True;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Gray.Enabled := True;
  end
  else
  begin
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info :=
      TALText.Create(mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel);
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.Name := 'Main_Config_Emulators_' + cEmu_Panel_Names
      [vNum] + '_Info';
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.Parent :=
      mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.Width :=
      mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel.Width - 100;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.Height := 40;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.Position.X := 110;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.Position.Y := 20;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.WordWrap := True;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.TextIsHtml := True;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.TextSettings.FontColor := TAlphaColorRec.White;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.TextSettings.Font.Size := 14;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.TextSettings.VertAlign := TTextAlign.Leading;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.Text :=
      '"<font color="#ff63cbfc">WIP</font>" Script is not ready to install "<font color="#ff63cbfc">' +
      cEmu_Names[vNum] + '</font>" emulator.';
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Info.Visible := True;

    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action :=
      TButton.Create(mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel);
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.Name := 'Main_Config_Emulators_' +
      cEmu_Panel_Names[vNum] + '_Action';
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.Parent :=
      mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.Width := 240;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.Height := 34;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.Position.X :=
      ((mainScene.Config.main.R.Emulators.Handhelds[vNum].Panel.Width / 2) - 120) + 50;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.Position.Y := 50;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.Text := 'Wait for update';
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.TextSettings.FontColor :=
      TAlphaColorRec.Deepskyblue;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.StyledSettings :=
      mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.StyledSettings - [TStyledSetting.FontColor];
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.OnClick :=
      ex_main.input.mouse_config.Button.OnMouseClick;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.TagFloat := 1000;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.Tag := vNum;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.Enabled := False;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Action.Visible := True;
    mainScene.Config.main.R.Emulators.Handhelds[vNum].Logo_Gray.Enabled := True;
  end;
end;

procedure uMain_Config_Emulators_ShowHandhelds;
var
  vi: Integer;
begin
  mainScene.Config.main.R.Emulators.Panels[3] :=
    TCalloutPanel.Create(mainScene.Config.main.R.Emulators.Panel);
  mainScene.Config.main.R.Emulators.Panels[3].Name := 'Main_Config_Emulators_CallPanel_' + IntToStr(3);
  mainScene.Config.main.R.Emulators.Panels[3].Parent := mainScene.Config.main.R.Emulators.Panel;
  mainScene.Config.main.R.Emulators.Panels[3].Width := mainScene.Config.main.R.Emulators.Panel.Width - 20;
  mainScene.Config.main.R.Emulators.Panels[3].Height := mainScene.Config.main.R.Emulators.Panel.Height - 120;
  mainScene.Config.main.R.Emulators.Panels[3].Position.X := 10;
  mainScene.Config.main.R.Emulators.Panels[3].Position.Y := 110;
  mainScene.Config.main.R.Emulators.Panels[3].CalloutOffset := 386;
  mainScene.Config.main.R.Emulators.Panels[3].Visible := True;

  mainScene.Config.main.R.Emulators.ScrollBox[3] :=
    TVertScrollBox.Create(mainScene.Config.main.R.Emulators.Panels[3]);
  mainScene.Config.main.R.Emulators.ScrollBox[3].Name := 'Main_Config_Emulators_Scrollbox_' + IntToStr(3);
  mainScene.Config.main.R.Emulators.ScrollBox[3].Parent := mainScene.Config.main.R.Emulators.Panels[3];
  mainScene.Config.main.R.Emulators.ScrollBox[3].Width := mainScene.Config.main.R.Emulators.Panels[3]
    .Width - 10;
  mainScene.Config.main.R.Emulators.ScrollBox[3].Height := mainScene.Config.main.R.Emulators.Panels[3]
    .Height - 10;
  mainScene.Config.main.R.Emulators.ScrollBox[3].Position.X := 5;
  mainScene.Config.main.R.Emulators.ScrollBox[3].Position.Y := 5;
  mainScene.Config.main.R.Emulators.ScrollBox[3].ShowScrollBars := True;
  mainScene.Config.main.R.Emulators.ScrollBox[3].Visible := True;

  for vi := 0 to 11 do
    uMain_Config_Emulators_CreateHandheldsPanel(vi);
end;

procedure uMain_Config_Emulators_CreatePinballsPanel(vNum: Integer);
const
  cEmu_Names: array [0 .. 1] of string = ('Visual Pinball X', 'Future Pinball');
  cEmu_Panel_Names: array [0 .. 1] of string = ('Visual_PinballX', 'Future_Pinball');
  cEmu_Image_Names: array [0 .. 1] of string = ('visual.png', 'future.png');
begin
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel :=
    TPanel.Create(mainScene.Config.main.R.Emulators.ScrollBox[4]);
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel.Name := 'Main_Config_Emulators_Pinballs_' +
    cEmu_Panel_Names[vNum] + '_Panel';
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel.Parent :=
    mainScene.Config.main.R.Emulators.ScrollBox[4];
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel.Width := mainScene.Config.main.R.Emulators.ScrollBox
    [4].Width - 25;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel.Height := 100;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel.Position.X := 5;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel.Position.Y := 20 + (vNum * 110);
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel.Visible := True;

  mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel_Image :=
    TPanel.Create(mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel);
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel_Image.Name := 'Main_Config_Emulators_Pinballs_' +
    cEmu_Panel_Names[vNum] + '_Panel_Image';
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel_Image.Parent :=
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel_Image.Width := 100;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel_Image.Height := 100;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel_Image.Position.X := 0;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel_Image.Position.Y := 0;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel_Image.Visible := True;

  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo :=
    TImage.Create(mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel_Image);
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo.Name := 'Main_Config_Emulators_Pinballs_' +
    cEmu_Panel_Names[vNum] + '_Logo';
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo.Parent := mainScene.Config.main.R.Emulators.Pinballs
    [vNum].Panel_Image;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo.Width := 92;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo.Height := 92;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo.Position.X := 4;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo.Position.Y := 4;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo.Bitmap.LoadFromFile
    (ex_main.Paths.Config_Images + '\emu\pinballs\' + cEmu_Image_Names[vNum]);
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo.OnClick :=
    ex_main.input.mouse_config.Image.OnMouseClick;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo.OnMouseEnter :=
    ex_main.input.mouse_config.Image.OnMouseEnter;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo.OnMouseLeave :=
    ex_main.input.mouse_config.Image.OnMouseLeave;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo.Visible := True;

  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Check :=
    TImage.Create(mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo);
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Check.Name := 'Main_Config_Emulators_Pinballs_' +
    cEmu_Panel_Names[vNum] + '_Logo_Check';
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Check.Parent :=
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Check.Width := 34;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Check.Height := 34;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Check.Position.X := 2;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Check.Position.Y := 2;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Check.Bitmap.LoadFromFile
    (ex_main.Paths.Config_Images + 'config_check.png');
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Check.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Check.OnClick :=
    ex_main.input.mouse_config.Image.OnMouseClick;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Check.OnMouseEnter :=
    ex_main.input.mouse_config.Image.OnMouseEnter;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Check.OnMouseLeave :=
    ex_main.input.mouse_config.Image.OnMouseLeave;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Check.Visible := False;

  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Glow :=
    TGlowEffect.Create(mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo);
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Glow.Name := 'Main_Config_Emulators_Pinballs_' +
    cEmu_Panel_Names[vNum] + '_Logo_Glow';
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Glow.Parent :=
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Glow.Opacity := 0.9;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Glow.Softness := 0.4;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Glow.Enabled := False;

  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Gray :=
    TMonochromeEffect.Create(mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo);
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Gray.Name := 'Main_Config_Emulators_Pinballs_' +
    cEmu_Panel_Names[vNum] + '_Logo_Gray';
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Gray.Parent :=
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo;
  mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Gray.Enabled := not emulation.Pinballs[0].Active;

  if emulation.Pinballs[vNum].Installed then
  begin
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info :=
      TALText.Create(mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel);
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.Name := 'Main_Config_Emulators_' + cEmu_Panel_Names
      [vNum] + '_Info';
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.Parent := mainScene.Config.main.R.Emulators.Pinballs
      [vNum].Panel;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.Width := mainScene.Config.main.R.Emulators.Pinballs
      [vNum].Panel.Width - 100;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.Height := 40;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.Position.X := 110;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.Position.Y := 20;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.WordWrap := True;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.TextIsHtml := True;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.TextSettings.FontColor := TAlphaColorRec.White;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.TextSettings.Font.Size := 14;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.TextSettings.VertAlign := TTextAlign.Leading;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.Text := ' The emulator "<font color="#ff63cbfc">' +
      cEmu_Names[vNum] + '</font>" is installed in ExtraFE "<font color="#ff63cbfc">Successfully</font>".';
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.Visible := True;

    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action :=
      TButton.Create(mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel);
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.Name := 'Main_Config_Emulators_' +
      cEmu_Panel_Names[vNum] + '_Action';
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.Parent :=
      mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.Width := 240;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.Height := 34;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.Position.X :=
      ((mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel.Width / 2) - 120) + 50;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.Position.Y := 50;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.Text := 'Uninstall';
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.TextSettings.FontColor := TAlphaColorRec.Red;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.StyledSettings :=
      mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.StyledSettings - [TStyledSetting.FontColor];
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.OnClick :=
      ex_main.input.mouse_config.Button.OnMouseClick;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.TagFloat := 1000;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.Tag := vNum;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.Enabled := True;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.Visible := True;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Gray.Enabled := True;
  end
  else
  begin
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info :=
      TALText.Create(mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel);
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.Name := 'Main_Config_Emulators_' + cEmu_Panel_Names
      [vNum] + '_Info';
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.Parent := mainScene.Config.main.R.Emulators.Pinballs
      [vNum].Panel;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.Width := mainScene.Config.main.R.Emulators.Pinballs
      [vNum].Panel.Width - 100;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.Height := 40;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.Position.X := 110;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.Position.Y := 20;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.WordWrap := True;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.TextIsHtml := True;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.TextSettings.FontColor := TAlphaColorRec.White;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.TextSettings.Font.Size := 14;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.TextSettings.VertAlign := TTextAlign.Leading;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.Text :=
      '"<font color="#ff63cbfc">WIP</font>" Script is not ready to install "<font color="#ff63cbfc">' +
      cEmu_Names[vNum] + '</font>" emulator.';
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Info.Visible := True;

    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action :=
      TButton.Create(mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel);
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.Name := 'Main_Config_Emulators_' +
      cEmu_Panel_Names[vNum] + '_Action';
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.Parent :=
      mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.Width := 240;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.Height := 34;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.Position.X :=
      ((mainScene.Config.main.R.Emulators.Pinballs[vNum].Panel.Width / 2) - 120) + 50;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.Position.Y := 50;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.Text := 'Wait for update';
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.TextSettings.FontColor :=
      TAlphaColorRec.Deepskyblue;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.StyledSettings :=
      mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.StyledSettings - [TStyledSetting.FontColor];
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.OnClick :=
      ex_main.input.mouse_config.Button.OnMouseClick;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.TagFloat := 1000;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.Tag := vNum;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.Enabled := False;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Action.Visible := True;
    mainScene.Config.main.R.Emulators.Pinballs[vNum].Logo_Gray.Enabled := True;
  end;

end;

procedure uMain_Config_Emulators_ShowPinballs;
var
  vi: Integer;
begin
  mainScene.Config.main.R.Emulators.Panels[4] :=
    TCalloutPanel.Create(mainScene.Config.main.R.Emulators.Panel);
  mainScene.Config.main.R.Emulators.Panels[4].Name := 'Main_Config_Emulators_CallPanel_' + IntToStr(4);
  mainScene.Config.main.R.Emulators.Panels[4].Parent := mainScene.Config.main.R.Emulators.Panel;
  mainScene.Config.main.R.Emulators.Panels[4].Width := mainScene.Config.main.R.Emulators.Panel.Width - 20;
  mainScene.Config.main.R.Emulators.Panels[4].Height := mainScene.Config.main.R.Emulators.Panel.Height - 120;
  mainScene.Config.main.R.Emulators.Panels[4].Position.X := 10;
  mainScene.Config.main.R.Emulators.Panels[4].Position.Y := 110;
  mainScene.Config.main.R.Emulators.Panels[4].CalloutOffset := 500;
  mainScene.Config.main.R.Emulators.Panels[4].Visible := True;

  mainScene.Config.main.R.Emulators.ScrollBox[4] :=
    TVertScrollBox.Create(mainScene.Config.main.R.Emulators.Panels[4]);
  mainScene.Config.main.R.Emulators.ScrollBox[4].Name := 'Main_Config_Emulators_Scrollbox_' + IntToStr(4);
  mainScene.Config.main.R.Emulators.ScrollBox[4].Parent := mainScene.Config.main.R.Emulators.Panels[4];
  mainScene.Config.main.R.Emulators.ScrollBox[4].Width := mainScene.Config.main.R.Emulators.Panels[4]
    .Width - 10;
  mainScene.Config.main.R.Emulators.ScrollBox[4].Height := mainScene.Config.main.R.Emulators.Panels[4]
    .Height - 10;
  mainScene.Config.main.R.Emulators.ScrollBox[4].Position.X := 5;
  mainScene.Config.main.R.Emulators.ScrollBox[4].Position.Y := 5;
  mainScene.Config.main.R.Emulators.ScrollBox[4].ShowScrollBars := True;
  mainScene.Config.main.R.Emulators.ScrollBox[4].Visible := True;
  for vi := 0 to 1 do
    uMain_Config_Emulators_CreatePinballsPanel(vi);
end;

procedure uMain_Config_Emulators_Install_Emu(vEmu_Num: Integer; vEmu_Categorie: String);
begin
  if vEmu_Categorie = 'Arcade' then
  begin
    case vEmu_Num of
      0:
        uEmulation_Arcade_Mame_Install; // Mame install script
    end;
  end;
end;

procedure uMain_Config_Emulators_UnInstall_Emu(vEmu_Num: Integer; vEmu_Categorie: String);
begin
  if vEmu_Categorie = 'Arcade' then
  begin
    case vEmu_Num of
      0:
        uEmulation_Arcade_Mame_Uninstall; // Mame uninstall script
    end;
  end;
end;

procedure uMain_Config_Emulators_Start_Emu_Wizard(vButton: TButton);
var
  vEmu_Tab: String;
begin
  mainScene.Footer.Back_Blur.Enabled:= True;
  case ex_main.Config.Emulators_Active_Tab of
    0:
      vEmu_Tab := 'Arcade';
    1:
      vEmu_Tab := 'Computers';
    2:
      vEmu_Tab := 'Consoles';
    3:
      vEmu_Tab := 'Handhelds';
    4:
      vEmu_Tab := 'Pinball';
  end;

  if vButton.Text = 'Install' then
    uMain_Config_Emulators_Install_Emu(vButton.Tag, vEmu_Tab)
  else if vButton.Text = 'Uninstall' then
    uMain_Config_Emulators_UnInstall_Emu(vButton.Tag, vEmu_Tab)
end;

end.
