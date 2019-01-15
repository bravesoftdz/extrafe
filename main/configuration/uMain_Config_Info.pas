unit uMain_Config_Info;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UiTypes,
  FMX.StdCtrls,
  FMX.Types,
  FMX.TabControl,
  FMX.Memo,
  FMX.Objects,
  FMX.Effects,
  FMX.Layouts,
  ALFMXObjects;

procedure uMain_Config_Info_Create;

procedure uMain_Config_Info_ExtraFE;
procedure uMain_Config_Info_Credits;

// Info Emulators
procedure Config_Info_Emulator_Mame_ShowHistory;

implementation

uses
  main,
  uLoad,
  uLoad_AllTypes,
  uMain_SetAll,
  uMain_AllTypes,
  uMain_Mouse,
  uMain_Config_Info_Actions;

procedure uMain_Config_Info_Create;
const
  cTab_Names: array [0 .. 4] of string = ('ExtraFE', 'Emulators', 'Multimedia', 'Others', 'Credits');
var
  vi: Integer;
begin
  mainScene.Config.Main.R.Info.Panel := TPanel.Create(mainScene.Config.Main.R.Panel[6]);
  mainScene.Config.Main.R.Info.Panel.Name := 'Main_Config_Info_Main_Panel';
  mainScene.Config.Main.R.Info.Panel.Parent := mainScene.Config.Main.R.Panel[6];
  mainScene.Config.Main.R.Info.Panel.Align := TAlignLayout.Client;
  mainScene.Config.Main.R.Info.Panel.Visible := True;

  mainScene.Config.Main.R.Info.TabControl := TTabControl.Create(mainScene.Config.Main.R.Info.Panel);
  mainScene.Config.Main.R.Info.TabControl.Name := 'Main_Config_Info_TabContol';
  mainScene.Config.Main.R.Info.TabControl.Parent := mainScene.Config.Main.R.Info.Panel;
  mainScene.Config.Main.R.Info.TabControl.Align := TAlignLayout.Client;
  mainScene.Config.Main.R.Info.TabControl.Visible := True;

  for vi := 0 to 4 do
  begin
    mainScene.Config.Main.R.Info.TabItem[vi] := TTabItem.Create(mainScene.Config.Main.R.Info.TabControl);
    mainScene.Config.Main.R.Info.TabItem[vi].Name := 'Main_Config_Profile_Main_TabItem_' + IntToStr(vi);
    mainScene.Config.Main.R.Info.TabItem[vi].Parent := mainScene.Config.Main.R.Info.TabControl;
    mainScene.Config.Main.R.Info.TabItem[vi].Text := cTab_Names[vi];
    mainScene.Config.Main.R.Info.TabItem[vi].Width := mainScene.Config.Main.R.Info.TabControl.Width;
    mainScene.Config.Main.R.Info.TabItem[vi].Height := mainScene.Config.Main.R.Info.TabControl.Height;
    mainScene.Config.Main.R.Info.TabItem[vi].Visible := True;
  end;

  uMain_Config_Info_ExtraFE;
  uMain_Config_Info_Credits;
end;

procedure uMain_Config_Info_ExtraFE;
begin
  mainScene.Config.Main.R.Info.Extrafe.Creator := TLabel.Create(mainScene.Config.Main.R.Info.TabItem[0]);
  mainScene.Config.Main.R.Info.Extrafe.Creator.Name := 'Main_Config_Info_ExtraFE_Creator';
  mainScene.Config.Main.R.Info.Extrafe.Creator.Parent := mainScene.Config.Main.R.Info.TabItem[0];
  mainScene.Config.Main.R.Info.Extrafe.Creator.Width := 100;
  mainScene.Config.Main.R.Info.Extrafe.Creator.Height := 24;
  mainScene.Config.Main.R.Info.Extrafe.Creator.Position.X := 10;
  mainScene.Config.Main.R.Info.Extrafe.Creator.Position.Y := 40;
  mainScene.Config.Main.R.Info.Extrafe.Creator.Text := 'Creator : ';
  mainScene.Config.Main.R.Info.Extrafe.Creator.Visible := True;

  mainScene.Config.Main.R.Info.Extrafe.Creator_V := TLabel.Create(mainScene.Config.Main.R.Info.TabItem[0]);
  mainScene.Config.Main.R.Info.Extrafe.Creator_V.Name := 'Main_Config_Info_ExtraFE_Creator_V';
  mainScene.Config.Main.R.Info.Extrafe.Creator_V.Parent := mainScene.Config.Main.R.Info.TabItem[0];
  mainScene.Config.Main.R.Info.Extrafe.Creator_V.Width := 400;
  mainScene.Config.Main.R.Info.Extrafe.Creator_V.Height := 24;
  mainScene.Config.Main.R.Info.Extrafe.Creator_V.Position.X := 120;
  mainScene.Config.Main.R.Info.Extrafe.Creator_V.Position.Y := 40;
  mainScene.Config.Main.R.Info.Extrafe.Creator_V.Text := 'Nikos Kordas AKA(Azrael11)';
  mainScene.Config.Main.R.Info.Extrafe.Creator_V.Visible := True;

  mainScene.Config.Main.R.Info.Extrafe.Desc := TLabel.Create(mainScene.Config.Main.R.Info.TabItem[0]);
  mainScene.Config.Main.R.Info.Extrafe.Desc.Name := 'Main_Config_Info_ExtraFE_Description';
  mainScene.Config.Main.R.Info.Extrafe.Desc.Parent := mainScene.Config.Main.R.Info.TabItem[0];
  mainScene.Config.Main.R.Info.Extrafe.Desc.Width := 100;
  mainScene.Config.Main.R.Info.Extrafe.Desc.Height := 24;
  mainScene.Config.Main.R.Info.Extrafe.Desc.Position.X := 10;
  mainScene.Config.Main.R.Info.Extrafe.Desc.Position.Y := 70;
  mainScene.Config.Main.R.Info.Extrafe.Desc.Text := 'Description : ';
  mainScene.Config.Main.R.Info.Extrafe.Desc.Visible := True;

  mainScene.Config.Main.R.Info.Extrafe.Desc_V := TLabel.Create(mainScene.Config.Main.R.Info.TabItem[0]);
  mainScene.Config.Main.R.Info.Extrafe.Desc_V.Name := 'Main_Config_Info_ExtraFE_Description_V';
  mainScene.Config.Main.R.Info.Extrafe.Desc_V.Parent := mainScene.Config.Main.R.Info.TabItem[0];
  mainScene.Config.Main.R.Info.Extrafe.Desc_V.Width := 400;
  mainScene.Config.Main.R.Info.Extrafe.Desc_V.Height := 24;
  mainScene.Config.Main.R.Info.Extrafe.Desc_V.Position.X := 120;
  mainScene.Config.Main.R.Info.Extrafe.Desc_V.Position.Y := 70;
  mainScene.Config.Main.R.Info.Extrafe.Desc_V.Text := 'Frontend for emulatos/games with great addons';
  mainScene.Config.Main.R.Info.Extrafe.Desc_V.Visible := True;

  mainScene.Config.Main.R.Info.Extrafe.Stable := TLabel.Create(mainScene.Config.Main.R.Info.TabItem[0]);
  mainScene.Config.Main.R.Info.Extrafe.Stable.Name := 'Main_Config_Info_ExtraFE_Stable';
  mainScene.Config.Main.R.Info.Extrafe.Stable.Parent := mainScene.Config.Main.R.Info.TabItem[0];
  mainScene.Config.Main.R.Info.Extrafe.Stable.Width := 100;
  mainScene.Config.Main.R.Info.Extrafe.Stable.Height := 24;
  mainScene.Config.Main.R.Info.Extrafe.Stable.Position.X := 10;
  mainScene.Config.Main.R.Info.Extrafe.Stable.Position.Y := 100;
  mainScene.Config.Main.R.Info.Extrafe.Stable.Text := 'Stable version : ';
  mainScene.Config.Main.R.Info.Extrafe.Stable.Visible := True;

  mainScene.Config.Main.R.Info.Extrafe.Stable_V := TLabel.Create(mainScene.Config.Main.R.Info.TabItem[0]);
  mainScene.Config.Main.R.Info.Extrafe.Stable_V.Name := 'Main_Config_Info_ExtraFE_Stable_V';
  mainScene.Config.Main.R.Info.Extrafe.Stable_V.Parent := mainScene.Config.Main.R.Info.TabItem[0];
  mainScene.Config.Main.R.Info.Extrafe.Stable_V.Width := 100;
  mainScene.Config.Main.R.Info.Extrafe.Stable_V.Height := 24;
  mainScene.Config.Main.R.Info.Extrafe.Stable_V.Position.X := 120;
  mainScene.Config.Main.R.Info.Extrafe.Stable_V.Position.Y := 100;
  mainScene.Config.Main.R.Info.Extrafe.Stable_V.Text := extrafe.prog.Version.Major + '.' + extrafe.prog.Version.Minor +
    '.' + extrafe.prog.Version.Realeash;
  mainScene.Config.Main.R.Info.Extrafe.Stable_V.Visible := True;

  mainScene.Config.Main.R.Info.Extrafe.Stable_Left := TImage.Create(mainScene.Config.Main.R.Info.TabItem[0]);
  mainScene.Config.Main.R.Info.Extrafe.Stable_Left.Name := 'Main_Config_Info_ExtraFE_Stable_Left';
  mainScene.Config.Main.R.Info.Extrafe.Stable_Left.Parent := mainScene.Config.Main.R.Info.TabItem[0];
  mainScene.Config.Main.R.Info.Extrafe.Stable_Left.Width := 20;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Left.Height := 20;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Left.Position.X := 200;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Left.Position.Y := 160;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Left.Bitmap.LoadFromFile(ex_main.Paths.Config_Images +
    'config_previous.png');
  mainScene.Config.Main.R.Info.Extrafe.Stable_Left.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Left.OnClick := ex_main.input.mouse_config.Image.OnMouseClick;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Left.OnMouseEnter := ex_main.input.mouse_config.Image.OnMouseEnter;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Left.OnMouseLeave := ex_main.input.mouse_config.Image.OnMouseLeave;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Left.Visible := True;

  mainScene.Config.Main.R.Info.Extrafe.Stable_Left_Glow := TGlowEffect.Create(mainScene.Config.Main.R.Info.Extrafe.Stable_Left);
  mainScene.Config.Main.R.Info.Extrafe.Stable_Left_Glow.Name := 'Main_Config_Info_ExtraFE_Stable_Left_Glow';
  mainScene.Config.Main.R.Info.Extrafe.Stable_Left_Glow.Parent := mainScene.Config.Main.R.Info.Extrafe.Stable_Left;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Left_Glow.Softness := 0.5;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Left_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Left_Glow.Enabled := False;

  mainScene.Config.Main.R.Info.Extrafe.Stable_Right := TImage.Create(mainScene.Config.Main.R.Info.TabItem[0]);
  mainScene.Config.Main.R.Info.Extrafe.Stable_Right.Name := 'Main_Config_Info_ExtraFE_Stable_Right';
  mainScene.Config.Main.R.Info.Extrafe.Stable_Right.Parent := mainScene.Config.Main.R.Info.TabItem[0];
  mainScene.Config.Main.R.Info.Extrafe.Stable_Right.Width := 20;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Right.Height := 20;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Right.Position.X := 268;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Right.Position.Y := 160;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Right.Bitmap.LoadFromFile(ex_main.Paths.Config_Images +
    'config_next.png');
  mainScene.Config.Main.R.Info.Extrafe.Stable_Right.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Right.OnClick := ex_main.input.mouse_config.Image.OnMouseClick;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Right.OnMouseEnter := ex_main.input.mouse_config.Image.OnMouseEnter;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Right.OnMouseLeave := ex_main.input.mouse_config.Image.OnMouseLeave;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Right.Visible := True;

  mainScene.Config.Main.R.Info.Extrafe.Stable_Right_Glow := TGlowEffect.Create(mainScene.Config.Main.R.Info.Extrafe.Stable_Right);
  mainScene.Config.Main.R.Info.Extrafe.Stable_Right_Glow.Name := 'Main_Config_Info_ExtraFE_Stable_Right_Glow';
  mainScene.Config.Main.R.Info.Extrafe.Stable_Right_Glow.Parent := mainScene.Config.Main.R.Info.Extrafe.Stable_Right;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Right_Glow.Softness := 0.5;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Right_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  mainScene.Config.Main.R.Info.Extrafe.Stable_Right_Glow.Enabled := False;

  mainScene.Config.Main.R.Info.Extrafe.Stable_History_Num := TLabel.Create(mainScene.Config.Main.R.Info.TabItem[0]);
  mainScene.Config.Main.R.Info.Extrafe.Stable_History_Num.Name := 'Main_Config_Info_ExtraFE_Stable_History';
  mainScene.Config.Main.R.Info.Extrafe.Stable_History_Num.Parent := mainScene.Config.Main.R.Info.TabItem[0];
  mainScene.Config.Main.R.Info.Extrafe.Stable_History_Num.Width := 100;
  mainScene.Config.Main.R.Info.Extrafe.Stable_History_Num.Height := 24;
  mainScene.Config.Main.R.Info.Extrafe.Stable_History_Num.Position.X := 230;
  mainScene.Config.Main.R.Info.Extrafe.Stable_History_Num.Position.Y := 160;
  mainScene.Config.Main.R.Info.Extrafe.Stable_History_Num.Text := extrafe.prog.Version.Major + '.' +
    extrafe.prog.Version.Minor + '.' + extrafe.prog.Version.Realeash;
  mainScene.Config.Main.R.Info.Extrafe.Stable_History_Num.Visible := True;

  mainScene.Config.Main.R.Info.Extrafe.LastBuild := TLabel.Create(mainScene.Config.Main.R.Info.TabItem[0]);
  mainScene.Config.Main.R.Info.Extrafe.LastBuild.Name := 'Main_Config_Info_ExtraFE_LastBuild';
  mainScene.Config.Main.R.Info.Extrafe.LastBuild.Parent := mainScene.Config.Main.R.Info.TabItem[0];
  mainScene.Config.Main.R.Info.Extrafe.LastBuild.Width := 100;
  mainScene.Config.Main.R.Info.Extrafe.LastBuild.Height := 24;
  mainScene.Config.Main.R.Info.Extrafe.LastBuild.Position.X := 10;
  mainScene.Config.Main.R.Info.Extrafe.LastBuild.Position.Y := 130;
  mainScene.Config.Main.R.Info.Extrafe.LastBuild.Text := 'Last build version : ';
  mainScene.Config.Main.R.Info.Extrafe.LastBuild.Visible := True;

  mainScene.Config.Main.R.Info.Extrafe.LastBuild_V := TLabel.Create(mainScene.Config.Main.R.Info.TabItem[0]);
  mainScene.Config.Main.R.Info.Extrafe.LastBuild_V.Name := 'Main_Config_Info_ExtraFE_LastBuild_V';
  mainScene.Config.Main.R.Info.Extrafe.LastBuild_V.Parent := mainScene.Config.Main.R.Info.TabItem[0];
  mainScene.Config.Main.R.Info.Extrafe.LastBuild_V.Width := 100;
  mainScene.Config.Main.R.Info.Extrafe.LastBuild_V.Height := 24;
  mainScene.Config.Main.R.Info.Extrafe.LastBuild_V.Position.X := 120;
  mainScene.Config.Main.R.Info.Extrafe.LastBuild_V.Position.Y := 130;
  mainScene.Config.Main.R.Info.Extrafe.LastBuild_V.Text := extrafe.prog.Version.Build;
  mainScene.Config.Main.R.Info.Extrafe.LastBuild_V.Visible := True;

  mainScene.Config.Main.R.Info.Extrafe.Build_Left := TImage.Create(mainScene.Config.Main.R.Info.TabItem[0]);
  mainScene.Config.Main.R.Info.Extrafe.Build_Left.Name := 'Main_Config_Info_ExtraFE_LastBuild_Left';
  mainScene.Config.Main.R.Info.Extrafe.Build_Left.Parent := mainScene.Config.Main.R.Info.TabItem[0];
  mainScene.Config.Main.R.Info.Extrafe.Build_Left.Width := 20;
  mainScene.Config.Main.R.Info.Extrafe.Build_Left.Height := 20;
  mainScene.Config.Main.R.Info.Extrafe.Build_Left.Position.X := 350;
  mainScene.Config.Main.R.Info.Extrafe.Build_Left.Position.Y := 160;
  mainScene.Config.Main.R.Info.Extrafe.Build_Left.Bitmap.LoadFromFile(ex_main.Paths.Config_Images +
    'config_previous.png');
  mainScene.Config.Main.R.Info.Extrafe.Build_Left.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.Main.R.Info.Extrafe.Build_Left.OnClick := ex_main.input.mouse_config.Image.OnMouseClick;
  mainScene.Config.Main.R.Info.Extrafe.Build_Left.OnMouseEnter := ex_main.input.mouse_config.Image.OnMouseEnter;
  mainScene.Config.Main.R.Info.Extrafe.Build_Left.OnMouseLeave := ex_main.input.mouse_config.Image.OnMouseLeave;
  mainScene.Config.Main.R.Info.Extrafe.Build_Left.Visible := True;

  mainScene.Config.Main.R.Info.Extrafe.Build_Left_Glow := TGlowEffect.Create(mainScene.Config.Main.R.Info.Extrafe.Build_Left);
  mainScene.Config.Main.R.Info.Extrafe.Build_Left_Glow.Name := 'Main_Config_Info_ExtraFE_Build_Left_Glow';
  mainScene.Config.Main.R.Info.Extrafe.Build_Left_Glow.Parent := mainScene.Config.Main.R.Info.Extrafe.Build_Left;
  mainScene.Config.Main.R.Info.Extrafe.Build_Left_Glow.Softness := 0.5;
  mainScene.Config.Main.R.Info.Extrafe.Build_Left_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  mainScene.Config.Main.R.Info.Extrafe.Build_Left_Glow.Enabled := False;

  mainScene.Config.Main.R.Info.Extrafe.Build_Right := TImage.Create(mainScene.Config.Main.R.Info.TabItem[0]);
  mainScene.Config.Main.R.Info.Extrafe.Build_Right.Name := 'Main_Config_Info_ExtraFE_LastBuild_Right';
  mainScene.Config.Main.R.Info.Extrafe.Build_Right.Parent := mainScene.Config.Main.R.Info.TabItem[0];
  mainScene.Config.Main.R.Info.Extrafe.Build_Right.Width := 20;
  mainScene.Config.Main.R.Info.Extrafe.Build_Right.Height := 20;
  mainScene.Config.Main.R.Info.Extrafe.Build_Right.Position.X := 408;
  mainScene.Config.Main.R.Info.Extrafe.Build_Right.Position.Y := 160;
  mainScene.Config.Main.R.Info.Extrafe.Build_Right.Bitmap.LoadFromFile(ex_main.Paths.Config_Images +
    'config_next.png');
  mainScene.Config.Main.R.Info.Extrafe.Build_Right.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.Main.R.Info.Extrafe.Build_Right.OnClick := ex_main.input.mouse_config.Image.OnMouseClick;
  mainScene.Config.Main.R.Info.Extrafe.Build_Right.OnMouseEnter := ex_main.input.mouse_config.Image.OnMouseEnter;
  mainScene.Config.Main.R.Info.Extrafe.Build_Right.OnMouseLeave := ex_main.input.mouse_config.Image.OnMouseLeave;
  mainScene.Config.Main.R.Info.Extrafe.Build_Right.Visible := True;

  mainScene.Config.Main.R.Info.Extrafe.Build_Right_Glow := TGlowEffect.Create(mainScene.Config.Main.R.Info.Extrafe.Build_Right);
  mainScene.Config.Main.R.Info.Extrafe.Build_Right_Glow.Name := 'Main_Config_Info_ExtraFE_Build_Right_Glow';
  mainScene.Config.Main.R.Info.Extrafe.Build_Right_Glow.Parent := mainScene.Config.Main.R.Info.Extrafe.Build_Right;
  mainScene.Config.Main.R.Info.Extrafe.Build_Right_Glow.Softness := 0.5;
  mainScene.Config.Main.R.Info.Extrafe.Build_Right_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  mainScene.Config.Main.R.Info.Extrafe.Build_Right_Glow.Enabled := False;

  mainScene.Config.Main.R.Info.Extrafe.Build_History_Num := TLabel.Create(mainScene.Config.Main.R.Info.TabItem[0]);
  mainScene.Config.Main.R.Info.Extrafe.Build_History_Num.Name := 'Main_Config_Info_ExtraFE_LastBuild_History';
  mainScene.Config.Main.R.Info.Extrafe.Build_History_Num.Parent := mainScene.Config.Main.R.Info.TabItem[0];
  mainScene.Config.Main.R.Info.Extrafe.Build_History_Num.Width := 100;
  mainScene.Config.Main.R.Info.Extrafe.Build_History_Num.Height := 24;
  mainScene.Config.Main.R.Info.Extrafe.Build_History_Num.Position.X := 380;
  mainScene.Config.Main.R.Info.Extrafe.Build_History_Num.Position.Y := 160;
  mainScene.Config.Main.R.Info.Extrafe.Build_History_Num.Text := extrafe.prog.Version.Build;
  mainScene.Config.Main.R.Info.Extrafe.Build_History_Num.Visible := True;

  mainScene.Config.Main.R.Info.Extrafe.History := TLabel.Create(mainScene.Config.Main.R.Info.TabItem[0]);
  mainScene.Config.Main.R.Info.Extrafe.History.Name := 'Main_Config_Info_ExtraFE_History';
  mainScene.Config.Main.R.Info.Extrafe.History.Parent := mainScene.Config.Main.R.Info.TabItem[0];
  mainScene.Config.Main.R.Info.Extrafe.History.Width := 200;
  mainScene.Config.Main.R.Info.Extrafe.History.Height := 24;
  mainScene.Config.Main.R.Info.Extrafe.History.Position.X := mainScene.Config.Main.R.Info.TabControl.Width - 210;
  mainScene.Config.Main.R.Info.Extrafe.History.Position.Y := 160;
  mainScene.Config.Main.R.Info.Extrafe.History.Text := 'History build';
  mainScene.Config.Main.R.Info.Extrafe.History.TextSettings.HorzAlign := TTextAlign.Trailing;
  mainScene.Config.Main.R.Info.Extrafe.History.Visible := True;

  mainScene.Config.Main.R.Info.Extrafe.History_Info := TMemo.Create(mainScene.Config.Main.R.Info.TabItem[0]);
  mainScene.Config.Main.R.Info.Extrafe.History_Info.Name := 'Main_Config_Info_ExtraFE_HistoryInfo';
  mainScene.Config.Main.R.Info.Extrafe.History_Info.Parent := mainScene.Config.Main.R.Info.TabItem[0];
  mainScene.Config.Main.R.Info.Extrafe.History_Info.Width := mainScene.Config.Main.R.Info.TabControl.Width - 20;
  mainScene.Config.Main.R.Info.Extrafe.History_Info.Height := 370;
  mainScene.Config.Main.R.Info.Extrafe.History_Info.Position.X := 10;
  mainScene.Config.Main.R.Info.Extrafe.History_Info.Position.Y := 190;
  mainScene.Config.Main.R.Info.Extrafe.History_Info.ReadOnly := True;
  mainScene.Config.Main.R.Info.Extrafe.History_Info.Visible := True;

  Config_Info_Read_Build((extrafe.prog.Version.Major + '.' + extrafe.prog.Version.Minor + '.' +
    extrafe.prog.Version.Realeash), extrafe.prog.Version.Build);
  vConfig_Info_Major := StrToInt(extrafe.prog.Version.Major);
  vConfig_Info_Minor := StrToInt(extrafe.prog.Version.Minor);
  vConfig_Info_Realeash := StrToInt(extrafe.prog.Version.Realeash);
  vConfig_Info_Build := StrToInt(extrafe.prog.Version.Build);
end;

procedure uMain_Config_Info_Credits;
begin
  mainScene.Config.Main.R.Info.Credits.Groupbox := TGroupBox.Create(mainScene.Config.Main.R.Info.TabItem[4]);
  mainScene.Config.Main.R.Info.Credits.Groupbox.Name := 'Main_Config_Info_Credits_Groupbox';
  mainScene.Config.Main.R.Info.Credits.Groupbox.Parent := mainScene.Config.Main.R.Info.TabItem[4];
  mainScene.Config.Main.R.Info.Credits.Groupbox.Width := mainScene.Config.Main.R.Info.TabControl.Width - 20;
  mainScene.Config.Main.R.Info.Credits.Groupbox.Height := 80;
  mainScene.Config.Main.R.Info.Credits.Groupbox.Position.X := 10;
  mainScene.Config.Main.R.Info.Credits.Groupbox.Position.Y := 10;
  mainScene.Config.Main.R.Info.Credits.Groupbox.Text := '-------------------------';
  mainScene.Config.Main.R.Info.Credits.Groupbox.Visible := True;

  mainScene.Config.Main.R.Info.Credits.Text := TALText.Create(mainScene.Config.Main.R.Info.Credits.Groupbox);
  mainScene.Config.Main.R.Info.Credits.Text.Name := 'Main_Config_Info_Credits_Text';
  mainScene.Config.Main.R.Info.Credits.Text.Parent := mainScene.Config.Main.R.Info.Credits.Groupbox;
  mainScene.Config.Main.R.Info.Credits.Text.Width := mainScene.Config.Main.R.Info.Credits.Groupbox.Width - 20;
  mainScene.Config.Main.R.Info.Credits.Text.Height := 60;
  mainScene.Config.Main.R.Info.Credits.Text.Position.X := 10;
  mainScene.Config.Main.R.Info.Credits.Text.Position.Y := 20;
  mainScene.Config.Main.R.Info.Credits.Text.WordWrap := True;
  mainScene.Config.Main.R.Info.Credits.Text.TextIsHtml := True;
  mainScene.Config.Main.R.Info.Credits.Text.TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.Main.R.Info.Credits.Text.TextSettings.Font.Size := 14;
  mainScene.Config.Main.R.Info.Credits.Text.TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.Main.R.Info.Credits.Text.Text :=
    ' First i want to thank for my heart my Son "<font color="#ff63cbfc">Vaggelis Kordas</font>" and my Wife "<font color="#ff63cbfc">Vouli Mpakatsi</font>" for the all time support and my missing dog "<font color="#ff63cbfc">Sokrates</font>"'
    + ' when he comes to my house then i start develop the <b>ExtraFE</b>.';
  mainScene.Config.Main.R.Info.Credits.Text.Visible := True;

  mainScene.Config.Main.R.Info.Credits.Left_Box := TVertScrollBox.Create(mainScene.Config.Main.R.Info.TabItem[4]);
  mainScene.Config.Main.R.Info.Credits.Left_Box.Name := 'Main_Config_Info_Credits_LeftBox';
  mainScene.Config.Main.R.Info.Credits.Left_Box.Parent := mainScene.Config.Main.R.Info.TabItem[4];
  mainScene.Config.Main.R.Info.Credits.Left_Box.Width := 100;
  mainScene.Config.Main.R.Info.Credits.Left_Box.Height := mainScene.Config.Main.R.Info.TabControl.Height - 110;
  mainScene.Config.Main.R.Info.Credits.Left_Box.Position.X := 10;
  mainScene.Config.Main.R.Info.Credits.Left_Box.Position.Y := 100;
  mainScene.Config.Main.R.Info.Credits.Left_Box.Visible := True;

  mainScene.Config.Main.R.Info.Credits.Groupbox_Other := TGroupBox.Create(mainScene.Config.Main.R.Info.TabItem[4]);
  mainScene.Config.Main.R.Info.Credits.Groupbox_Other.Name := 'Main_Config_Info_Credits_Groupbox_Others';
  mainScene.Config.Main.R.Info.Credits.Groupbox_Other.Parent := mainScene.Config.Main.R.Info.TabItem[4];
  mainScene.Config.Main.R.Info.Credits.Groupbox_Other.Width := mainScene.Config.Main.R.Info.TabControl.Width - 20;
  mainScene.Config.Main.R.Info.Credits.Groupbox_Other.Height :=
    mainScene.Config.Main.R.Info.TabControl.Height - 120;
  mainScene.Config.Main.R.Info.Credits.Groupbox_Other.Position.X := 10;
  mainScene.Config.Main.R.Info.Credits.Groupbox_Other.Position.Y := 90;
  mainScene.Config.Main.R.Info.Credits.Groupbox_Other.Text := '-------------------------';
  mainScene.Config.Main.R.Info.Credits.Groupbox_Other.Visible := True;

  mainScene.Config.Main.R.Info.Credits.Left_Box :=
    TVertScrollBox.Create(mainScene.Config.Main.R.Info.Credits.Groupbox_Other);
  mainScene.Config.Main.R.Info.Credits.Left_Box.Name := 'Main_Config_Info_Credits_VBox_Left';
  mainScene.Config.Main.R.Info.Credits.Left_Box.Parent := mainScene.Config.Main.R.Info.Credits.Groupbox_Other;
  mainScene.Config.Main.R.Info.Credits.Left_Box.Width := 100;
  mainScene.Config.Main.R.Info.Credits.Left_Box.Height := mainScene.Config.Main.R.Info.Credits.Groupbox_Other.Height;
  mainScene.Config.Main.R.Info.Credits.Left_Box.Position.X := 0;
  mainScene.Config.Main.R.Info.Credits.Left_Box.Position.Y := 0;
  mainScene.Config.Main.R.Info.Credits.Left_Box.Visible := True;

  mainScene.Config.Main.R.Info.Credits.Comps_Image[0] := TImage.Create(mainScene.Config.Main.R.Info.Credits.Left_Box);
  mainScene.Config.Main.R.Info.Credits.Comps_Image[0].Name := 'Main_Config_Info_Credits_Image_0';
  mainScene.Config.Main.R.Info.Credits.Comps_Image[0].Parent := mainScene.Config.Main.R.Info.Credits.Left_Box;
  mainScene.Config.Main.R.Info.Credits.Comps_Image[0].Width := 80;
  mainScene.Config.Main.R.Info.Credits.Comps_Image[0].Height := 40;
  mainScene.Config.Main.R.Info.Credits.Comps_Image[0].Position.X := 10;
  mainScene.Config.Main.R.Info.Credits.Comps_Image[0].Position.Y := 10;
  mainScene.Config.Main.R.Info.Credits.Comps_Image[0].Bitmap.LoadFromFile(ex_main.Paths.Config_Images +
    'config_emb.png');
  mainScene.Config.Main.R.Info.Credits.Comps_Image[0].WrapMode := TImageWrapMode.Fit;
  mainScene.Config.Main.R.Info.Credits.Comps_Image[0].Visible := True;

  mainScene.Config.Main.R.Info.Credits.Right_Box[0] :=
    TVertScrollBox.Create(mainScene.Config.Main.R.Info.Credits.Groupbox_Other);
  mainScene.Config.Main.R.Info.Credits.Right_Box[0].Name := 'Main_Config_Info_Credits_VBox_Right';
  mainScene.Config.Main.R.Info.Credits.Right_Box[0].Parent := mainScene.Config.Main.R.Info.Credits.Groupbox_Other;
  mainScene.Config.Main.R.Info.Credits.Right_Box[0].Width :=
    mainScene.Config.Main.R.Info.Credits.Groupbox_Other.Width - 100;
  mainScene.Config.Main.R.Info.Credits.Right_Box[0].Height :=
    mainScene.Config.Main.R.Info.Credits.Groupbox_Other.Height;
  mainScene.Config.Main.R.Info.Credits.Right_Box[0].Position.X := 100;
  mainScene.Config.Main.R.Info.Credits.Right_Box[0].Position.Y := 0;
  mainScene.Config.Main.R.Info.Credits.Right_Box[0].Visible := True;

  mainScene.Config.Main.R.Info.Credits.Paragraphs[0] :=
    TALText.Create(mainScene.Config.Main.R.Info.Credits.Right_Box[0]);
  mainScene.Config.Main.R.Info.Credits.Paragraphs[0].Name := 'Main_Config_Info_Credits_Parag_0';
  mainScene.Config.Main.R.Info.Credits.Paragraphs[0].Parent := mainScene.Config.Main.R.Info.Credits.Right_Box[0];
  mainScene.Config.Main.R.Info.Credits.Paragraphs[0].Width := mainScene.Config.Main.R.Info.Credits.Right_Box[0]
    .Width - 20;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[0].Height:= 100;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[0].WordWrap := True;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[0].Position.X := 10;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[0].Position.Y := 10;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[0].TextSettings.FontColor:= TAlphaColorRec.White;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[0].TextSettings.Font.Size := 14;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[0].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[0].TextIsHtml:= True;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[0].Text :=
    '   <b><font color="#ff63cbfc">ExtraFE</font></b> created, builded with <font color="#f21212">"Delphi Community Edition"</font> from <b>Embracedero</b> company.'
    + 'This IDE tool for pascal language with many new features and new style pascal is free with a restricted lincesce.'
    + 'Go to <b>Embarcadero''s</b> web site and dowloading for <b><font color="#ff63cbfc">free</font></b> and create fabulus applications.';
  mainScene.Config.Main.R.Info.Credits.Paragraphs[0].Visible := True;

  mainScene.Config.Main.R.Info.Credits.Paragraphs[1] :=
    TALText.Create(mainScene.Config.Main.R.Info.Credits.Right_Box[0]);
  mainScene.Config.Main.R.Info.Credits.Paragraphs[1].Name := 'Main_Config_Info_Credits_Parag_1';
  mainScene.Config.Main.R.Info.Credits.Paragraphs[1].Parent := mainScene.Config.Main.R.Info.Credits.Right_Box[0];
  mainScene.Config.Main.R.Info.Credits.Paragraphs[1].Width := mainScene.Config.Main.R.Info.Credits.Right_Box[0]
    .Width - 20;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[1].Height:= 140;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[1].WordWrap := True;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[1].Position.X := 10;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[1].Position.Y := 110;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[1].TextSettings.FontColor:= TAlphaColorRec.White;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[1].TextSettings.Font.Size := 14;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[1].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[1].Text :=
    '   Embarcadero tools are built for elite developers who build and maintain the world�s most critical applications.'
    + ' Our customers choose Embarcadero because we are the champion of developers, and we help them build more secure and '
    + 'scalable enterprise applications faster than any other tools on the market. In fact, ninety of the Fortune 100 and an'
    + ' active community of more than three million users worldwide have relied on Embarcadero'' s award-winning products for'
    + ' over 30 years.';
  mainScene.Config.Main.R.Info.Credits.Paragraphs[1].Visible := True;

  mainScene.Config.Main.R.Info.Credits.Paragraphs[2] :=
    TALText.Create(mainScene.Config.Main.R.Info.Credits.Right_Box[0]);
  mainScene.Config.Main.R.Info.Credits.Paragraphs[2].Name := 'Main_Config_Info_Credits_Parag_2';
  mainScene.Config.Main.R.Info.Credits.Paragraphs[2].Parent := mainScene.Config.Main.R.Info.Credits.Right_Box[0];
  mainScene.Config.Main.R.Info.Credits.Paragraphs[2].Width := mainScene.Config.Main.R.Info.Credits.Right_Box[0]
    .Width - 20;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[2].Height:= 120;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[2].WordWrap := True;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[2].Position.X := 10;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[2].Position.Y := 250;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[2].TextSettings.FontColor:= TAlphaColorRec.White;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[2].TextSettings.Font.Size := 14;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[2].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[2].Text :=
    '   If you�re trying to build a business-critical application in a demanding vertical, Embarcadero is for'
    + ' you. If you�re looking to write steadfast code quickly that will pass stringent code reviews faster than any other,'
    + ' Embarcadero is for you. We�re here to support elite developers who understand the scalability and stability of C++'
    + ' and Delphi and depend on the decades of innovation those languages bring to development.';
  mainScene.Config.Main.R.Info.Credits.Paragraphs[2].Visible := True;

  mainScene.Config.Main.R.Info.Credits.Paragraphs[3] :=
    TALText.Create(mainScene.Config.Main.R.Info.Credits.Right_Box[0]);
  mainScene.Config.Main.R.Info.Credits.Paragraphs[3].Name := 'Main_Config_Info_Credits_Parag_3';
  mainScene.Config.Main.R.Info.Credits.Paragraphs[3].Parent := mainScene.Config.Main.R.Info.Credits.Right_Box[0];
  mainScene.Config.Main.R.Info.Credits.Paragraphs[3].Width := mainScene.Config.Main.R.Info.Credits.Right_Box[0]
    .Width - 20;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[3].Height:= 30;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[3].WordWrap := True;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[3].Position.X := 10;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[3].Position.Y := 370;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[3].TextSettings.FontColor:= TAlphaColorRec.White;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[3].TextSettings.Font.Size := 14;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[3].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[3].Text :=
    '   We invite you to try our products for free and see for yourself.';
  mainScene.Config.Main.R.Info.Credits.Paragraphs[3].Visible := True;

  mainScene.Config.Main.R.Info.Credits.Paragraphs[4] :=
    TALText.Create(mainScene.Config.Main.R.Info.Credits.Right_Box[0]);
  mainScene.Config.Main.R.Info.Credits.Paragraphs[4].Name := 'Main_Config_Info_Credits_Parag_4';
  mainScene.Config.Main.R.Info.Credits.Paragraphs[4].Parent := mainScene.Config.Main.R.Info.Credits.Right_Box[0];
  mainScene.Config.Main.R.Info.Credits.Paragraphs[4].Width := mainScene.Config.Main.R.Info.Credits.Right_Box[0]
    .Width - 20;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[4].Height:= 200;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[4].WordWrap := True;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[4].Position.X := 10;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[4].Position.Y := 400;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[4].TextSettings.FontColor:= TAlphaColorRec.White;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[4].TextSettings.Font.Size := 14;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[4].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.Main.R.Info.Credits.Paragraphs[4].Text :=
    '   Embarcadero is an Idera, Inc. company. Idera, Inc. is the parent company of'
    + ' global B2B software productivity brands whose solutions enable technical users to do more with less, faster. Idera, '
    + 'Inc. brands span three divisions � Database Tools, Developer Tools, and Test Management Tools � with products that are'
    + ' evangelized by millions of community members and more than 50,000 customers worldwide, including some of the world�s largest'
    + ' healthcare, financial services, retail, and technology companies.';
  mainScene.Config.Main.R.Info.Credits.Paragraphs[4].Visible := True;
end;

/// /////////////////////////////////////////////////////////////////////////////
// Info ExtraFE

// Info Emulators
procedure Config_Info_Emulator_Mame_ShowHistory;
begin
  // Main_Form.Info_Emulators_Information.Lines.Clear;
  // Main_Form.Info_Emulators_Information.Lines.LoadFromFile(extrafe.prog.Path+ 'emu\arcade\mame\history.txt');
end;

end.
