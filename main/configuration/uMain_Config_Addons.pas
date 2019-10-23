unit uMain_Config_Addons;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UITypes,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.Effects,
  FMX.Types,
  FMX.Filter.Effects,
  ALFMXObjects,
  bass;

const
  cFist_Group_Images: array [0 .. 4] of string = ('config_time.png', 'config_calendar.png', 'config_weather.png', 'config_soundplayer.png', 'config_play.png');

procedure Icons(vStart: Integer);
procedure Icons_Free;

procedure Create;

procedure ShowInfo(vAddon_Num: Integer);

procedure Time(vIndex: Integer);
procedure Calendar(vIndex: Integer);
procedure Weather(vIndex: Integer);
procedure Soundplayer(vIndex: Integer);
procedure AzPlay(vIndex: Integer);

implementation

uses
  uDatabase_ActiveUser,
  uMain_AllTypes,
  uLoad_AllTypes;

procedure Icons_Free;
var
  vi: Integer;
begin
  for vi := 0 to 3 do
    FreeAndNil(mainScene.Config.main.R.Addons.Icons[vi]);
end;

procedure Icons(vStart: Integer);
var
  vi: Integer;
begin
  for vi := 0 to 3 do
  begin
    mainScene.Config.main.R.Addons.Icons[vi] := TImage.Create(mainScene.Config.main.R.Addons.Groupbox);
    mainScene.Config.main.R.Addons.Icons[vi].Name := 'Main_Config_Addons_Groupbox_0_Image_' + IntToStr(vStart + vi);
    mainScene.Config.main.R.Addons.Icons[vi].Parent := mainScene.Config.main.R.Addons.Groupbox;
    mainScene.Config.main.R.Addons.Icons[vi].SetBounds(74 + (vi * 118), 20, 70, 70);
    mainScene.Config.main.R.Addons.Icons[vi].Bitmap.LoadFromFile(ex_main.Paths.Config_Images + cFist_Group_Images[vStart + vi]);
    mainScene.Config.main.R.Addons.Icons[vi].WrapMode := TImageWrapMode.Fit;
    mainScene.Config.main.R.Addons.Icons[vi].OnClick := ex_main.input.mouse_config.Image.OnMouseClick;
    mainScene.Config.main.R.Addons.Icons[vi].OnMouseEnter := ex_main.input.mouse_config.Image.OnMouseEnter;
    mainScene.Config.main.R.Addons.Icons[vi].OnMouseLeave := ex_main.input.mouse_config.Image.OnMouseLeave;
    mainScene.Config.main.R.Addons.Icons[vi].Tag := vStart + vi;
    mainScene.Config.main.R.Addons.Icons[vi].Visible := True;

    mainScene.Config.main.R.Addons.Icons_Glow[vStart + vi] := TGlowEffect.Create(mainScene.Config.main.R.Addons.Icons[vStart + vi]);
    mainScene.Config.main.R.Addons.Icons_Glow[vStart + vi].Name := 'Main_Config_Addons_Groupbox_0_Image_Glow_' + (vStart + vi).ToString;
    mainScene.Config.main.R.Addons.Icons_Glow[vStart + vi].Parent := mainScene.Config.main.R.Addons.Icons[vi];
    mainScene.Config.main.R.Addons.Icons_Glow[vStart + vi].GlowColor := TAlphaColorRec.Deepskyblue;
    mainScene.Config.main.R.Addons.Icons_Glow[vStart + vi].Softness := 0.5;
    mainScene.Config.main.R.Addons.Icons_Glow[vStart + vi].Opacity := 0.9;
    mainScene.Config.main.R.Addons.Icons_Glow[vStart + vi].Enabled := False;
  end;
end;

procedure ShowInfo(vAddon_Num: Integer);
var
  vi: Integer;
  vPos_Num: Integer;
begin
  for vi := 0 to 5 do
    if Assigned(mainScene.Config.main.R.Addons.Icons_Panel[vi]) then
      FreeAndNil(mainScene.Config.main.R.Addons.Icons_Panel[vi]);

  mainScene.Config.main.R.Addons.Icons_Panel[vAddon_Num] := TCalloutPanel.Create(mainScene.Config.main.R.Addons.Panel);
  mainScene.Config.main.R.Addons.Icons_Panel[vAddon_Num].Name := 'Main_Config_Addons_Addon_Panel';
  mainScene.Config.main.R.Addons.Icons_Panel[vAddon_Num].Parent := mainScene.Config.main.R.Addons.Panel;
  mainScene.Config.main.R.Addons.Icons_Panel[vAddon_Num].SetBounds(10, 110, mainScene.Config.main.R.Addons.Groupbox.Width,
    mainScene.Config.main.R.Addons.Panel.Height - 118);

  vPos_Num := vAddon_Num - ex_main.Config.Addons_Tab_First;

  case vPos_Num of
    0:
      mainScene.Config.main.R.Addons.Icons_Panel[vAddon_Num].CalloutOffset := 97;
    1:
      mainScene.Config.main.R.Addons.Icons_Panel[vAddon_Num].CalloutOffset := 212;
    2:
      mainScene.Config.main.R.Addons.Icons_Panel[vAddon_Num].CalloutOffset := 330;
    3:
      mainScene.Config.main.R.Addons.Icons_Panel[vAddon_Num].CalloutOffset := 454;
  end;

  mainScene.Config.main.R.Addons.Icons_Panel[vAddon_Num].Visible := True;

  case vAddon_Num of
    0:
      Time(vPos_Num);
    1:
      Calendar(vPos_Num);
    2:
      Weather(vPos_Num);
    3:
      Soundplayer(vPos_Num);
    4:
      AzPlay(vPos_Num);
  end;

  ex_main.Config.Addons_Active_Tab := vAddon_Num;
end;

procedure Create;
var
  vi: Integer;
begin
  extrafe.prog.State := 'main_config_addons';

  mainScene.Config.main.R.Addons.Panel := TPanel.Create(mainScene.Config.main.R.Panel[4]);
  mainScene.Config.main.R.Addons.Panel.Name := 'Main_Config_Addons_Panel';
  mainScene.Config.main.R.Addons.Panel.Parent := mainScene.Config.main.R.Panel[4];
  mainScene.Config.main.R.Addons.Panel.Align := TAlignLayout.Client;
  mainScene.Config.main.R.Addons.Panel.Visible := True;

  mainScene.Config.main.R.Addons.Panel_Blur := TGaussianBlurEffect.Create(mainScene.Config.main.R.Addons.Panel);
  mainScene.Config.main.R.Addons.Panel_Blur.Name := 'Main_Config_Addons_Panel_Blur';
  mainScene.Config.main.R.Addons.Panel_Blur.Parent := mainScene.Config.main.R.Addons.Panel;
  mainScene.Config.main.R.Addons.Panel_Blur.BlurAmount := 0.5;
  mainScene.Config.main.R.Addons.Panel_Blur.Enabled := False;

  mainScene.Config.main.R.Addons.Groupbox := TGroupBox.Create(mainScene.Config.main.R.Addons.Panel);
  mainScene.Config.main.R.Addons.Groupbox.Name := 'Main_Config_Addons_Groupbox_0';
  mainScene.Config.main.R.Addons.Groupbox.Parent := mainScene.Config.main.R.Addons.Panel;
  mainScene.Config.main.R.Addons.Groupbox.SetBounds(10, 10, mainScene.Config.main.R.Addons.Panel.Width - 20, 98);
  mainScene.Config.main.R.Addons.Groupbox.Text := 'Addons';
  mainScene.Config.main.R.Addons.Groupbox.Visible := True;

  mainScene.Config.main.R.Addons.Arrow_Left := TImage.Create(mainScene.Config.main.R.Addons.Groupbox);
  mainScene.Config.main.R.Addons.Arrow_Left.Name := 'Main_Config_Addons_Arrow_Left';
  mainScene.Config.main.R.Addons.Arrow_Left.Parent := mainScene.Config.main.R.Addons.Groupbox;
  mainScene.Config.main.R.Addons.Arrow_Left.SetBounds(4, 20, 70, 70);
  mainScene.Config.main.R.Addons.Arrow_Left.Bitmap.LoadFromFile(ex_main.Paths.Config_Images + 'config_previous.png');
  mainScene.Config.main.R.Addons.Arrow_Left.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.main.R.Addons.Arrow_Left.OnClick := ex_main.input.mouse_config.Image.OnMouseClick;
  mainScene.Config.main.R.Addons.Arrow_Left.OnMouseEnter := ex_main.input.mouse_config.Image.OnMouseEnter;
  mainScene.Config.main.R.Addons.Arrow_Left.OnMouseLeave := ex_main.input.mouse_config.Image.OnMouseLeave;
  mainScene.Config.main.R.Addons.Arrow_Left.Visible := True;

  mainScene.Config.main.R.Addons.Arrow_Left_Gray := TMonochromeEffect.Create(mainScene.Config.main.R.Addons.Arrow_Left);
  mainScene.Config.main.R.Addons.Arrow_Left_Gray.Name := 'Main_Config_Addons_Arrow_Left_Gray';
  mainScene.Config.main.R.Addons.Arrow_Left_Gray.Parent := mainScene.Config.main.R.Addons.Arrow_Left;
  mainScene.Config.main.R.Addons.Arrow_Left_Gray.Enabled := True;

  mainScene.Config.main.R.Addons.Arrow_Left_Glow := TGlowEffect.Create(mainScene.Config.main.R.Addons.Arrow_Left);
  mainScene.Config.main.R.Addons.Arrow_Left_Glow.Name := 'Main_Config_Addons_Arrow_Left_Glow';
  mainScene.Config.main.R.Addons.Arrow_Left_Glow.Parent := mainScene.Config.main.R.Addons.Arrow_Left;
  mainScene.Config.main.R.Addons.Arrow_Left_Glow.Softness := 0.4;
  mainScene.Config.main.R.Addons.Arrow_Left_Glow.Opacity := 0.9;
  mainScene.Config.main.R.Addons.Arrow_Left_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  mainScene.Config.main.R.Addons.Arrow_Left_Glow.Enabled := False;

  mainScene.Config.main.R.Addons.Left_Num := TText.Create(mainScene.Config.main.R.Addons.Groupbox);
  mainScene.Config.main.R.Addons.Left_Num.Name := 'Main_Config_Addons_Left_Num';
  mainScene.Config.main.R.Addons.Left_Num.Parent := mainScene.Config.main.R.Addons.Groupbox;
  mainScene.Config.main.R.Addons.Left_Num.SetBounds(-10, 76, 50, 20);
  mainScene.Config.main.R.Addons.Left_Num.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  mainScene.Config.main.R.Addons.Left_Num.TextSettings.Font.Size := 12;
  mainScene.Config.main.R.Addons.Left_Num.Text := '';
  mainScene.Config.main.R.Addons.Left_Num.Visible := False;

  mainScene.Config.main.R.Addons.Arrow_Right := TImage.Create(mainScene.Config.main.R.Addons.Groupbox);
  mainScene.Config.main.R.Addons.Arrow_Right.Name := 'Main_Config_Addons_Arrow_Right';
  mainScene.Config.main.R.Addons.Arrow_Right.Parent := mainScene.Config.main.R.Addons.Groupbox;
  mainScene.Config.main.R.Addons.Arrow_Right.SetBounds(mainScene.Config.main.R.Addons.Groupbox.Width - 74, 20, 70, 70);
  mainScene.Config.main.R.Addons.Arrow_Right.Bitmap.LoadFromFile(ex_main.Paths.Config_Images + 'config_next.png');
  mainScene.Config.main.R.Addons.Arrow_Right.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.main.R.Addons.Arrow_Right.OnClick := ex_main.input.mouse_config.Image.OnMouseClick;
  mainScene.Config.main.R.Addons.Arrow_Right.OnMouseEnter := ex_main.input.mouse_config.Image.OnMouseEnter;
  mainScene.Config.main.R.Addons.Arrow_Right.OnMouseLeave := ex_main.input.mouse_config.Image.OnMouseLeave;
  mainScene.Config.main.R.Addons.Arrow_Right.Visible := True;

  mainScene.Config.main.R.Addons.Arrow_Right_Gray := TMonochromeEffect.Create(mainScene.Config.main.R.Addons.Arrow_Right);
  mainScene.Config.main.R.Addons.Arrow_Right_Gray.Name := 'Main_Config_Addons_Arrow_Right_Gray';
  mainScene.Config.main.R.Addons.Arrow_Right_Gray.Parent := mainScene.Config.main.R.Addons.Arrow_Right;
  mainScene.Config.main.R.Addons.Arrow_Right_Gray.Enabled := True;

  mainScene.Config.main.R.Addons.Arrow_Right_Glow := TGlowEffect.Create(mainScene.Config.main.R.Addons.Arrow_Right);
  mainScene.Config.main.R.Addons.Arrow_Right_Glow.Name := 'Main_Config_Addons_Arrow_Right_Glow';
  mainScene.Config.main.R.Addons.Arrow_Right_Glow.Parent := mainScene.Config.main.R.Addons.Arrow_Right;
  mainScene.Config.main.R.Addons.Arrow_Right_Glow.Softness := 0.4;
  mainScene.Config.main.R.Addons.Arrow_Right_Glow.Opacity := 0.9;
  mainScene.Config.main.R.Addons.Arrow_Right_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  mainScene.Config.main.R.Addons.Arrow_Right_Glow.Enabled := False;

  mainScene.Config.main.R.Addons.Right_Num := TText.Create(mainScene.Config.main.R.Addons.Groupbox);
  mainScene.Config.main.R.Addons.Right_Num.Name := 'Main_Config_Addons_Right_Num';
  mainScene.Config.main.R.Addons.Right_Num.Parent := mainScene.Config.main.R.Addons.Groupbox;
  mainScene.Config.main.R.Addons.Right_Num.SetBounds(mainScene.Config.main.R.Addons.Groupbox.Width - 40, 76, 50, 20);
  mainScene.Config.main.R.Addons.Right_Num.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  mainScene.Config.main.R.Addons.Right_Num.TextSettings.Font.Size := 12;
  mainScene.Config.main.R.Addons.Right_Num.Text := '';
  mainScene.Config.main.R.Addons.Right_Num.Visible := True;

  ex_main.Config.Addons_Active_Tab := -1;
  ex_main.Config.Addons_Tab_First := 0;
  ex_main.Config.Addons_Tab_Last := 3;

  Icons(ex_main.Config.Addons_Tab_First);

  if user_Active_Local.ADDONS.Active > 3 then
  begin
    mainScene.Config.main.R.Addons.Arrow_Right_Gray.Enabled := False;
    mainScene.Config.main.R.Addons.Right_Num.Visible := True;
    mainScene.Config.main.R.Addons.Right_Num.Text := (user_Active_Local.ADDONS.Active - 3).ToString;
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////
procedure Time(vIndex: Integer);
begin
  mainScene.Config.main.R.Addons.Icons_Info[0].Header := TLabel.Create(mainScene.Config.main.R.Addons.Icons_Panel[0]);
  mainScene.Config.main.R.Addons.Icons_Info[0].Header.Name := 'Main_Config_Addons_Addon_Time_Header';
  mainScene.Config.main.R.Addons.Icons_Info[0].Header.Parent := mainScene.Config.main.R.Addons.Icons_Panel[0];
  mainScene.Config.main.R.Addons.Icons_Info[0].Header.SetBounds(10, 20, 300, 28);
  mainScene.Config.main.R.Addons.Icons_Info[0].Header.Text := 'This addon is : ';
  mainScene.Config.main.R.Addons.Icons_Info[0].Header.Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[0].Activeted := TText.Create(mainScene.Config.main.R.Addons.Icons_Panel[0]);
  mainScene.Config.main.R.Addons.Icons_Info[0].Activeted.Name := 'Main_Config_Addons_Addon_Time_Active';
  mainScene.Config.main.R.Addons.Icons_Info[0].Activeted.Parent := mainScene.Config.main.R.Addons.Icons_Panel[0];
  mainScene.Config.main.R.Addons.Icons_Info[0].Activeted.SetBounds(90, 20, 200, 28);
  mainScene.Config.main.R.Addons.Icons_Info[0].Activeted.Color := TAlphaColorRec.Lime;
  mainScene.Config.main.R.Addons.Icons_Info[0].Activeted.Text := 'Active';
  mainScene.Config.main.R.Addons.Icons_Info[0].Activeted.TextSettings.HorzAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[0].Activeted.Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[0].TextBox := TVertScrollBox.Create(mainScene.Config.main.R.Addons.Icons_Panel[0]);
  mainScene.Config.main.R.Addons.Icons_Info[0].TextBox.Name := 'Main_Config_Addons_Addon_Time_TextBox';
  mainScene.Config.main.R.Addons.Icons_Info[0].TextBox.Parent := mainScene.Config.main.R.Addons.Icons_Panel[0];
  mainScene.Config.main.R.Addons.Icons_Info[0].TextBox.SetBounds(10, 50, mainScene.Config.main.R.Addons.Icons_Panel[0].Width - 20,
    mainScene.Config.main.R.Addons.Icons_Panel[0].Height - 100);
  mainScene.Config.main.R.Addons.Icons_Info[0].TextBox.Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[0] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[0].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[0].Name := 'Main_Config_Addons_Time_Paragraph_' + IntToStr(0);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[0].Parent := mainScene.Config.main.R.Addons.Icons_Info[0].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[0].SetBounds(10, 10, mainScene.Config.main.R.Addons.Icons_Info[0].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[0].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[0].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[0].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[0].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[0].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[0].Text :=
    ' This addon is <font color="#ff8de93a">enabled</font> by defalt. User can''t <b>deactivate</b> it.';
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[0].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[1] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[0].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[1].Name := 'Main_Config_Addons_Time_Paragraph_' + IntToStr(1);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[1].Parent := mainScene.Config.main.R.Addons.Icons_Info[0].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[1].SetBounds(10, 30, mainScene.Config.main.R.Addons.Icons_Info[0].TextBox.Width - 40, 60);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[1].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[1].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[1].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[1].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[1].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[1].Text :=
    ' It provides the user information about time <b>local</b> and <b>global</b>, user can add <b>alarm clocks</b> for any task, user olso use the <b>timer</b> or the <b>watch clock</b> to count rounds or everything else she/he wants.';
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[1].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[2] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[0].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[2].Name := 'Main_Config_Addons_Time_Paragraph_' + IntToStr(2);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[2].Parent := mainScene.Config.main.R.Addons.Icons_Info[0].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[2].SetBounds(10, 88, mainScene.Config.main.R.Addons.Icons_Info[0].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[2].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[2].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[2].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[2].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[2].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[2].Text := ' It has <font color="#fff21212">five</font> subcategories.';
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[2].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[3] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[0].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[3].Name := 'Main_Config_Addons_Time_Paragraph_' + IntToStr(3);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[3].Parent := mainScene.Config.main.R.Addons.Icons_Info[0].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[3].SetBounds(10, 108, mainScene.Config.main.R.Addons.Icons_Info[0].TextBox.Width - 40, 60);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[3].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[3].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[3].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[3].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[3].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[3].Text :=
    ' <font color="#fff21212">*</font> Clock: User can see time in two forms <b><font color="#ff63cbfc">analog</font></b> and <b><font color="#ff63cbfc">digital</font></b>.'
    + 'User can make changes of the feel and look of clocks or select from the defaults themes.';
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[3].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[4] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[0].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[4].Name := 'Main_Config_Addons_Time_Paragraph_' + IntToStr(4);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[4].Parent := mainScene.Config.main.R.Addons.Icons_Info[0].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[4].SetBounds(10, 148, mainScene.Config.main.R.Addons.Icons_Info[0].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[4].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[4].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[4].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[4].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[4].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[4].Text := ' <font color="#fff21212">*</font> Alarm: This is <b>WIP</b>.';
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[4].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[5] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[0].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[5].Name := 'Main_Config_Addons_Time_Paragraph_' + IntToStr(5);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[5].Parent := mainScene.Config.main.R.Addons.Icons_Info[0].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[5].SetBounds(10, 168, mainScene.Config.main.R.Addons.Icons_Info[0].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[5].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[5].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[5].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[5].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[5].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[5].Text := ' <font color="#fff21212">*</font> Timer: This is <b>WIP</b>.';
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[5].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[6] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[0].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[6].Name := 'Main_Config_Addons_Time_Paragraph_' + IntToStr(6);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[6].Parent := mainScene.Config.main.R.Addons.Icons_Info[0].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[6].SetBounds(10, 188, mainScene.Config.main.R.Addons.Icons_Info[0].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[6].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[6].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[6].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[6].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[6].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[6].Text := ' <font color="#fff21212">*</font> Stop Watch: This is <b>WIP</b>.';
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[6].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[7] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[0].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[7].Name := 'Main_Config_Addons_Time_Paragraph_' + IntToStr(7);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[7].Parent := mainScene.Config.main.R.Addons.Icons_Info[0].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[7].SetBounds(10, 208, mainScene.Config.main.R.Addons.Icons_Info[0].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[7].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[7].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[7].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[7].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[7].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[7].Text := ' <font color="#fff21212">*</font> World Clock: This is <b>WIP</b>.';
  mainScene.Config.main.R.Addons.Icons_Info[0].Paragraphs[7].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[0].Athour := TLabel.Create(mainScene.Config.main.R.Addons.Icons_Panel[0]);
  mainScene.Config.main.R.Addons.Icons_Info[0].Athour.Name := 'Main_Config_Addons_Addon_Time_Author';
  mainScene.Config.main.R.Addons.Icons_Info[0].Athour.Parent := mainScene.Config.main.R.Addons.Icons_Panel[0];
  mainScene.Config.main.R.Addons.Icons_Info[0].Athour.SetBounds(10, mainScene.Config.main.R.Addons.Icons_Panel[0].Height - 40, 300, 28);
  mainScene.Config.main.R.Addons.Icons_Info[0].Athour.Text := 'Creator: Nikos Kordas';
  mainScene.Config.main.R.Addons.Icons_Info[0].Athour.Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[0].Action := TButton.Create(mainScene.Config.main.R.Addons.Icons_Panel[0]);
  mainScene.Config.main.R.Addons.Icons_Info[0].Action.Name := 'Main_Config_Addons_Addon_Time_Action';
  mainScene.Config.main.R.Addons.Icons_Info[0].Action.Parent := mainScene.Config.main.R.Addons.Icons_Panel[0];
  mainScene.Config.main.R.Addons.Icons_Info[0].Action.SetBounds(mainScene.Config.main.R.Addons.Icons_Panel[0].Width - 160,
    mainScene.Config.main.R.Addons.Icons_Panel[0].Height - 40, 150, 30);
  mainScene.Config.main.R.Addons.Icons_Info[0].Action.Text := 'Nothing to do';
  mainScene.Config.main.R.Addons.Icons_Info[0].Action.Enabled := False;
  mainScene.Config.main.R.Addons.Icons_Info[0].Action.Visible := True;
end;

procedure Calendar(vIndex: Integer);
begin
  mainScene.Config.main.R.Addons.Icons_Info[1].Header := TLabel.Create(mainScene.Config.main.R.Addons.Icons_Panel[1]);
  mainScene.Config.main.R.Addons.Icons_Info[1].Header.Name := 'Main_Config_Addons_Addon_Calendar_Header';
  mainScene.Config.main.R.Addons.Icons_Info[1].Header.Parent := mainScene.Config.main.R.Addons.Icons_Panel[1];
  mainScene.Config.main.R.Addons.Icons_Info[1].Header.SetBounds(10, 20, 300, 28);
  mainScene.Config.main.R.Addons.Icons_Info[1].Header.Text := 'This addon is : ';
  mainScene.Config.main.R.Addons.Icons_Info[1].Header.Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[1].Activeted := TText.Create(mainScene.Config.main.R.Addons.Icons_Panel[1]);
  mainScene.Config.main.R.Addons.Icons_Info[1].Activeted.Name := 'Main_Config_Addons_Addon_Calendar_Active';
  mainScene.Config.main.R.Addons.Icons_Info[1].Activeted.Parent := mainScene.Config.main.R.Addons.Icons_Panel[1];
  mainScene.Config.main.R.Addons.Icons_Info[1].Activeted.SetBounds(90, 20, 200, 28);
  mainScene.Config.main.R.Addons.Icons_Info[1].Activeted.Color := TAlphaColorRec.Lime;
  mainScene.Config.main.R.Addons.Icons_Info[1].Activeted.Text := 'Active';
  mainScene.Config.main.R.Addons.Icons_Info[1].Activeted.TextSettings.HorzAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[1].Activeted.Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[1].TextBox := TVertScrollBox.Create(mainScene.Config.main.R.Addons.Icons_Panel[1]);
  mainScene.Config.main.R.Addons.Icons_Info[1].TextBox.Name := 'Main_Config_Addons_Addon_Calendar_TextBox';
  mainScene.Config.main.R.Addons.Icons_Info[1].TextBox.Parent := mainScene.Config.main.R.Addons.Icons_Panel[1];
  mainScene.Config.main.R.Addons.Icons_Info[1].TextBox.SetBounds(10, 50, mainScene.Config.main.R.Addons.Icons_Panel[1].Width - 20,
    mainScene.Config.main.R.Addons.Icons_Panel[1].Height - 100);
  mainScene.Config.main.R.Addons.Icons_Info[1].TextBox.Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[0] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[1].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[0].Name := 'Main_Config_Addons_Calendar_Paragraph_' + IntToStr(0);
  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[0].Parent := mainScene.Config.main.R.Addons.Icons_Info[1].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[0].SetBounds(10, 10, mainScene.Config.main.R.Addons.Icons_Info[1].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[0].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[0].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[0].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[0].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[0].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[0].Text :=
    ' This addon is <font color="#ff8de93a">enabled</font> by defalt. User can''t <b>deactivate</b> it.';
  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[0].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[1] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[1].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[1].Name := 'Main_Config_Addons_Calendar_Paragraph_' + IntToStr(1);
  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[1].Parent := mainScene.Config.main.R.Addons.Icons_Info[1].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[1].SetBounds(10, 30, mainScene.Config.main.R.Addons.Icons_Info[1].TextBox.Width - 40, 60);
  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[1].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[1].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[1].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[1].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[1].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[1].Text := ' This addons is <b>WIP</b>.';
  mainScene.Config.main.R.Addons.Icons_Info[1].Paragraphs[1].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[1].Athour := TLabel.Create(mainScene.Config.main.R.Addons.Icons_Panel[1]);
  mainScene.Config.main.R.Addons.Icons_Info[1].Athour.Name := 'Main_Config_Addons_Addon_Calendar_Author';
  mainScene.Config.main.R.Addons.Icons_Info[1].Athour.Parent := mainScene.Config.main.R.Addons.Icons_Panel[1];
  mainScene.Config.main.R.Addons.Icons_Info[1].Athour.SetBounds(10, mainScene.Config.main.R.Addons.Icons_Panel[1].Height - 40, 300, 28);
  mainScene.Config.main.R.Addons.Icons_Info[1].Athour.Text := 'Creator: Nikos Kordas';
  mainScene.Config.main.R.Addons.Icons_Info[1].Athour.Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[1].Action := TButton.Create(mainScene.Config.main.R.Addons.Icons_Panel[1]);
  mainScene.Config.main.R.Addons.Icons_Info[1].Action.Name := 'Main_Config_Addons_Addon_Calendar_Action';
  mainScene.Config.main.R.Addons.Icons_Info[1].Action.Parent := mainScene.Config.main.R.Addons.Icons_Panel[1];
  mainScene.Config.main.R.Addons.Icons_Info[1].Action.SetBounds(mainScene.Config.main.R.Addons.Icons_Panel[1].Width - 160,
    mainScene.Config.main.R.Addons.Icons_Panel[1].Height - 40, 150, 30);
  mainScene.Config.main.R.Addons.Icons_Info[1].Action.Text := 'Nothing to do';
  mainScene.Config.main.R.Addons.Icons_Info[1].Action.Enabled := False;
  mainScene.Config.main.R.Addons.Icons_Info[1].Action.Visible := True;
end;

procedure Weather(vIndex: Integer);
begin
  mainScene.Config.main.R.Addons.Icons_Info[2].Header := TLabel.Create(mainScene.Config.main.R.Addons.Icons_Panel[2]);
  mainScene.Config.main.R.Addons.Icons_Info[2].Header.Name := 'Main_Config_Addons_Addon_Weather_Header';
  mainScene.Config.main.R.Addons.Icons_Info[2].Header.Parent := mainScene.Config.main.R.Addons.Icons_Panel[2];
  mainScene.Config.main.R.Addons.Icons_Info[2].Header.SetBounds(10, 20, 300, 28);
  mainScene.Config.main.R.Addons.Icons_Info[2].Header.Text := 'This addon is : ';
  mainScene.Config.main.R.Addons.Icons_Info[2].Header.Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[2].Activeted := TText.Create(mainScene.Config.main.R.Addons.Icons_Panel[2]);
  mainScene.Config.main.R.Addons.Icons_Info[2].Activeted.Name := 'Main_Config_Addons_Addon_Weather_Active';
  mainScene.Config.main.R.Addons.Icons_Info[2].Activeted.Parent := mainScene.Config.main.R.Addons.Icons_Panel[2];
  mainScene.Config.main.R.Addons.Icons_Info[2].Activeted.SetBounds(90, 20, 200, 28);
  mainScene.Config.main.R.Addons.Icons_Info[2].Activeted.TextSettings.HorzAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[2].Activeted.Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[2].TextBox := TVertScrollBox.Create(mainScene.Config.main.R.Addons.Icons_Panel[2]);
  mainScene.Config.main.R.Addons.Icons_Info[2].TextBox.Name := 'Main_Config_Addons_Addon_Weather_TextBox';
  mainScene.Config.main.R.Addons.Icons_Info[2].TextBox.Parent := mainScene.Config.main.R.Addons.Icons_Panel[2];
  mainScene.Config.main.R.Addons.Icons_Info[2].TextBox.SetBounds(10, 50, mainScene.Config.main.R.Addons.Icons_Panel[2].Width - 20,
    mainScene.Config.main.R.Addons.Icons_Panel[2].Height - 100);
  mainScene.Config.main.R.Addons.Icons_Info[2].TextBox.Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[0] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[2].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[0].Name := 'Main_Config_Addons_Weather_Paragraph_' + IntToStr(0);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[0].Parent := mainScene.Config.main.R.Addons.Icons_Info[2].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[0].SetBounds(10, 10, mainScene.Config.main.R.Addons.Icons_Info[2].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[0].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[0].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[0].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[0].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[0].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[0].Text := ' This addon provide information about global or local weather forecast.';
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[0].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[1] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[2].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[1].Name := 'Main_Config_Addons_Weather_Paragraph_' + IntToStr(1);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[1].Parent := mainScene.Config.main.R.Addons.Icons_Info[2].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[1].SetBounds(10, 30, mainScene.Config.main.R.Addons.Icons_Info[2].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[1].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[1].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[1].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[1].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[1].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[1].Text := ' User can add up to <b>255</b> locations and get specific and detail forecast numbers.';
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[1].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[2] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[2].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[2].Name := 'Main_Config_Addons_Weather_Paragraph_' + IntToStr(2);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[2].Parent := mainScene.Config.main.R.Addons.Icons_Info[2].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[2].SetBounds(10, 50, mainScene.Config.main.R.Addons.Icons_Info[2].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[2].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[2].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[2].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[2].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[2].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[2].Text := ' Weather addon gets forecast from the down providers.';
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[2].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[3] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[2].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[3].Name := 'Main_Config_Addons_Weather_Paragraph_' + IntToStr(3);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[3].Parent := mainScene.Config.main.R.Addons.Icons_Info[2].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[3].SetBounds(10, 70, mainScene.Config.main.R.Addons.Icons_Info[2].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[3].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[3].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[3].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[3].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[3].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[3].Text := ' <font color="#fff21212">*</font> Yahooo! (via XML).';
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[3].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[4] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[2].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[4].Name := 'Main_Config_Addons_Weather_Paragraph_' + IntToStr(4);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[4].Parent := mainScene.Config.main.R.Addons.Icons_Info[2].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[4].SetBounds(10, 90, mainScene.Config.main.R.Addons.Icons_Info[2].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[4].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[4].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[4].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[4].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[4].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[4].Text := ' <font color="#fff21212">*</font> Yahooo! (via JSON). <b>WIP</b>';
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[4].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[5] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[2].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[5].Name := 'Main_Config_Addons_Weather_Paragraph_' + IntToStr(5);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[5].Parent := mainScene.Config.main.R.Addons.Icons_Info[2].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[5].SetBounds(10, 110, mainScene.Config.main.R.Addons.Icons_Info[2].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[5].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[5].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[5].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[5].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[5].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[5].Text := ' <font color="#fff21212">*</font> Openweathermap. <b>WIP</b>';
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[5].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[6] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[2].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[6].Name := 'Main_Config_Addons_Weather_Paragraph_' + IntToStr(6);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[6].Parent := mainScene.Config.main.R.Addons.Icons_Info[2].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[6].SetBounds(10, 140, mainScene.Config.main.R.Addons.Icons_Info[2].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[6].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[6].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[6].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[6].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[6].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[6].Text := ' <font color="#fff21212">Warning</font> This addon needs an active internet connection.';
  mainScene.Config.main.R.Addons.Icons_Info[2].Paragraphs[6].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[2].Athour := TLabel.Create(mainScene.Config.main.R.Addons.Icons_Panel[2]);
  mainScene.Config.main.R.Addons.Icons_Info[2].Athour.Name := 'Main_Config_Addons_Addon_Weather_Author';
  mainScene.Config.main.R.Addons.Icons_Info[2].Athour.Parent := mainScene.Config.main.R.Addons.Icons_Panel[2];
  mainScene.Config.main.R.Addons.Icons_Info[2].Athour.SetBounds(10, mainScene.Config.main.R.Addons.Icons_Panel[2].Height - 40, 300, 28);
  mainScene.Config.main.R.Addons.Icons_Info[2].Athour.Text := 'Creator: Nikos Kordas';
  mainScene.Config.main.R.Addons.Icons_Info[2].Athour.Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[2].Action := TButton.Create(mainScene.Config.main.R.Addons.Icons_Panel[2]);
  mainScene.Config.main.R.Addons.Icons_Info[2].Action.Name := 'Main_Config_Addons_Addon_Weather_Action';
  mainScene.Config.main.R.Addons.Icons_Info[2].Action.Parent := mainScene.Config.main.R.Addons.Icons_Panel[2];
  mainScene.Config.main.R.Addons.Icons_Info[2].Action.SetBounds(mainScene.Config.main.R.Addons.Icons_Panel[2].Width - 160,
    mainScene.Config.main.R.Addons.Icons_Panel[2].Height - 40, 150, 30);
  mainScene.Config.main.R.Addons.Icons_Info[2].Action.OnClick := ex_main.input.mouse_config.Button.OnMouseClick;
  mainScene.Config.main.R.Addons.Icons_Info[2].Action.Visible := True;

  if user_Active_Local.ADDONS.Weather then
  begin
    mainScene.Config.main.R.Addons.Icons_Info[2].Activeted.Text := 'Active';
    mainScene.Config.main.R.Addons.Icons_Info[2].Activeted.Color := TAlphaColorRec.Lime;
    mainScene.Config.main.R.Addons.Icons_Info[2].Action.Text := 'Deactivate';
  end
  else
  begin
    mainScene.Config.main.R.Addons.Icons_Info[2].Activeted.Text := 'Inactive';
    mainScene.Config.main.R.Addons.Icons_Info[2].Activeted.Color := TAlphaColorRec.Red;
    mainScene.Config.main.R.Addons.Icons_Info[2].Action.Text := 'Activate';
  end;
end;

procedure Soundplayer(vIndex: Integer);
begin
  mainScene.Config.main.R.Addons.Icons_Info[3].Header := TLabel.Create(mainScene.Config.main.R.Addons.Icons_Panel[3]);
  mainScene.Config.main.R.Addons.Icons_Info[3].Header.Name := 'Main_Config_Addons_Addon_Soundplayer_Header';
  mainScene.Config.main.R.Addons.Icons_Info[3].Header.Parent := mainScene.Config.main.R.Addons.Icons_Panel[3];
  mainScene.Config.main.R.Addons.Icons_Info[3].Header.SetBounds(10, 20, 300, 28);
  mainScene.Config.main.R.Addons.Icons_Info[3].Header.Text := 'This addon is : ';
  mainScene.Config.main.R.Addons.Icons_Info[3].Header.Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].Activeted := TText.Create(mainScene.Config.main.R.Addons.Icons_Panel[3]);
  mainScene.Config.main.R.Addons.Icons_Info[3].Activeted.Name := 'Main_Config_Addons_Addon_Soundplayer_Active';
  mainScene.Config.main.R.Addons.Icons_Info[3].Activeted.Parent := mainScene.Config.main.R.Addons.Icons_Panel[3];
  mainScene.Config.main.R.Addons.Icons_Info[3].Activeted.SetBounds(90, 20, 200, 28);
  mainScene.Config.main.R.Addons.Icons_Info[3].Activeted.TextSettings.HorzAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[3].Activeted.Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].TextBox := TVertScrollBox.Create(mainScene.Config.main.R.Addons.Icons_Panel[3]);
  mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.Name := 'Main_Config_Addons_Addon_Soundplayer_TextBox';
  mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.Parent := mainScene.Config.main.R.Addons.Icons_Panel[3];
  mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.SetBounds(10, 50, mainScene.Config.main.R.Addons.Icons_Panel[3].Width - 20,
    mainScene.Config.main.R.Addons.Icons_Panel[3].Height - 100);
  mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[0] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[3].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[0].Name := 'Main_Config_Addons_Soundplayer_Paragraph_' + IntToStr(0);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[0].Parent := mainScene.Config.main.R.Addons.Icons_Info[3].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[0].SetBounds(10, 10, mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[0].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[0].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[0].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[0].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[0].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[0].Text := ' This addon provide a simple but yet powerfull audio player.';
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[0].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[1] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[3].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[1].Name := 'Main_Config_Addons_Soundplayer_Paragraph_' + IntToStr(1);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[1].Parent := mainScene.Config.main.R.Addons.Icons_Info[3].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[1].SetBounds(10, 30, mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.Width - 40, 60);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[1].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[1].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[1].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[1].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[1].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[1].Text :=
    ' The <font color="#ff63cbfc">soundplayer</font> addon is in early stages of development so it has many bugs and support of media files is limited via "<font color="#ff63cbfc">BASS audio Library</font>".';
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[1].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[2] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[3].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[2].Name := 'Main_Config_Addons_Soundplayer_Paragraph_' + IntToStr(2);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[2].Parent := mainScene.Config.main.R.Addons.Icons_Info[3].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[2].SetBounds(10, 70, mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[2].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[2].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[2].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[2].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[2].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[2].Text :=
    ' <font color="#ff63cbfc">Soundplayer</font> addon currently support or under development this audio file types.';
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[2].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[3] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[3].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[3].Name := 'Main_Config_Addons_Soundplayer_Paragraph_' + IntToStr(3);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[3].Parent := mainScene.Config.main.R.Addons.Icons_Info[3].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[3].SetBounds(10, 90, mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[3].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[3].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[3].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[3].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[3].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[3].Text :=
    ' <font color="#fff21212">*</font> Mp3 with full edit tags in both versions ID3v1 and ID3v2. Rating system.';
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[3].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[4] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[3].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[4].Name := 'Main_Config_Addons_Soundplayer_Paragraph_' + IntToStr(4);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[4].Parent := mainScene.Config.main.R.Addons.Icons_Info[3].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[4].SetBounds(10, 110, mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[4].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[4].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[4].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[4].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[4].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[4].Text := ' <font color="#fff21212">*</font> Ogg with full edit tags';
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[4].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[5] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[3].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[5].Name := 'Main_Config_Addons_Soundplayer_Paragraph_' + IntToStr(5);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[5].Parent := mainScene.Config.main.R.Addons.Icons_Info[3].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[5].SetBounds(10, 130, mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[5].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[5].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[5].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[5].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[5].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[5].Text := ' <font color="#fff21212">*</font> WAV <b>WIP</b>';
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[5].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[6] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[3].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[6].Name := 'Main_Config_Addons_Soundplayer_Paragraph_' + IntToStr(6);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[6].Parent := mainScene.Config.main.R.Addons.Icons_Info[3].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[6].SetBounds(10, 150, mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[6].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[6].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[6].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[6].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[6].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[6].Text := ' <font color="#fff21212">*</font> MP4 <b>WIP</b>';
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[6].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[7] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[3].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[7].Name := 'Main_Config_Addons_Soundplayer_Paragraph_' + IntToStr(7);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[7].Parent := mainScene.Config.main.R.Addons.Icons_Info[3].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[7].SetBounds(10, 170, mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[7].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[7].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[7].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[7].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[7].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[7].Text := ' <font color="#fff21212">*</font> Flac <b>WIP</b>';
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[7].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[8] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[3].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[8].Name := 'Main_Config_Addons_Soundplayer_Paragraph_' + IntToStr(8);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[8].Parent := mainScene.Config.main.R.Addons.Icons_Info[3].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[8].SetBounds(10, 200, mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.Width - 40, 60);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[8].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[8].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[8].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[8].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[8].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[8].Text :=
    ' <font color="#ff63cbfc">Soundplayer</font> addon currently support or under development this playlist file types.';
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[8].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[9] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[3].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[9].Name := 'Main_Config_Addons_Soundplayer_Paragraph_' + IntToStr(9);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[9].Parent := mainScene.Config.main.R.Addons.Icons_Info[3].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[9].SetBounds(10, 220, mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[9].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[9].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[9].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[9].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[9].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[9].Text :=
    ' <font color="#fff21212">*</font> M3U, can create, remove, edit supported to other soundplayers apps';
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[9].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[10] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[3].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[10].Name := 'Main_Config_Addons_Soundplayer_Paragraph_' + IntToStr(10);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[10].Parent := mainScene.Config.main.R.Addons.Icons_Info[3].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[10].SetBounds(10, 240, mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[10].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[10].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[10].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[10].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[10].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[10].Text := ' <font color="#fff21212">*</font> PLS <b>WIP</b>';
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[10].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[11] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[3].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[11].Name := 'Main_Config_Addons_Soundplayer_Paragraph_' + IntToStr(11);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[11].Parent := mainScene.Config.main.R.Addons.Icons_Info[3].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[11].SetBounds(10, 260, mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[11].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[11].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[11].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[11].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[11].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[11].Text := ' <font color="#fff21212">*</font> ASX <b>WIP</b>';
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[11].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[12] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[3].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[12].Name := 'Main_Config_Addons_Soundplayer_Paragraph_' + IntToStr(12);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[12].Parent := mainScene.Config.main.R.Addons.Icons_Info[3].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[12].SetBounds(10, 280, mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[12].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[12].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[12].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[12].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[12].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[12].Text := ' <font color="#fff21212">*</font> WPL <b>WIP</b>';
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[12].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[13] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[3].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[13].Name := 'Main_Config_Addons_Soundplayer_Paragraph_' + IntToStr(13);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[13].Parent := mainScene.Config.main.R.Addons.Icons_Info[3].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[13].SetBounds(10, 300, mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[13].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[13].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[13].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[13].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[13].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[13].Text := ' <font color="#fff21212">*</font> XSPF <b>WIP</b>';
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[13].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[14] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[3].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[14].Name := 'Main_Config_Addons_Soundplayer_Paragraph_' + IntToStr(14);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[14].Parent := mainScene.Config.main.R.Addons.Icons_Info[3].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[14].SetBounds(10, 320, mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[14].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[14].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[14].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[14].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[14].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[14].Text := ' <font color="#fff21212">*</font> EXPL <b>WIP</b>';
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[14].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[15] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[3].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[15].Name := 'Main_Config_Addons_Soundplayer_Paragraph_' + IntToStr(15);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[15].Parent := mainScene.Config.main.R.Addons.Icons_Info[3].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[15].SetBounds(10, 340, mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.Width - 40, 60);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[15].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[15].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[15].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[15].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[15].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[15].Text :=
    '<font color="#fff21212"> NEW </font> Now you can remove add change places and positions for the playlists and the songs inside them';
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[15].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[16] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[3].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[16].Name := 'Main_Config_Addons_Soundplayer_Paragraph_' + IntToStr(16);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[16].Parent := mainScene.Config.main.R.Addons.Icons_Info[3].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[16].SetBounds(10, 380, mainScene.Config.main.R.Addons.Icons_Info[3].TextBox.Width - 40, 60);
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[16].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[16].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[16].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[16].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[16].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[16].Text :=
    ' To start you only need to create a playlist and add audio files in it. In this time no need for internet connection but soon it automatically download files like covers, lyrics, fan arts etc.';
  mainScene.Config.main.R.Addons.Icons_Info[3].Paragraphs[16].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].Athour := TLabel.Create(mainScene.Config.main.R.Addons.Icons_Panel[3]);
  mainScene.Config.main.R.Addons.Icons_Info[3].Athour.Name := 'Main_Config_Addons_Addon_Soundplayer_Author';
  mainScene.Config.main.R.Addons.Icons_Info[3].Athour.Parent := mainScene.Config.main.R.Addons.Icons_Panel[3];
  mainScene.Config.main.R.Addons.Icons_Info[3].Athour.SetBounds(10, mainScene.Config.main.R.Addons.Icons_Panel[3].Height - 40, 300, 28);
  mainScene.Config.main.R.Addons.Icons_Info[3].Athour.Text := 'Creator: Nikos Kordas';
  mainScene.Config.main.R.Addons.Icons_Info[3].Athour.Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[3].Action := TButton.Create(mainScene.Config.main.R.Addons.Icons_Panel[3]);
  mainScene.Config.main.R.Addons.Icons_Info[3].Action.Name := 'Main_Config_Addons_Addon_Soundplayer_Action';
  mainScene.Config.main.R.Addons.Icons_Info[3].Action.Parent := mainScene.Config.main.R.Addons.Icons_Panel[3];
  mainScene.Config.main.R.Addons.Icons_Info[3].Action.SetBounds(mainScene.Config.main.R.Addons.Icons_Panel[3].Width - 160,
    mainScene.Config.main.R.Addons.Icons_Panel[3].Height - 40, 150, 30);
  mainScene.Config.main.R.Addons.Icons_Info[3].Action.OnClick := ex_main.input.mouse_config.Button.OnMouseClick;
  mainScene.Config.main.R.Addons.Icons_Info[3].Action.Visible := True;

  if user_Active_Local.ADDONS.Soundplayer then
  begin
    mainScene.Config.main.R.Addons.Icons_Info[3].Activeted.Text := 'Active';
    mainScene.Config.main.R.Addons.Icons_Info[3].Activeted.Color := TAlphaColorRec.Lime;
    mainScene.Config.main.R.Addons.Icons_Info[3].Action.Text := 'Deactivate'
  end
  else
  begin
    mainScene.Config.main.R.Addons.Icons_Info[3].Activeted.Text := 'Inactive';
    mainScene.Config.main.R.Addons.Icons_Info[3].Activeted.Color := TAlphaColorRec.Red;
    mainScene.Config.main.R.Addons.Icons_Info[3].Action.Text := 'Activate';
  end;
end;

procedure AzPlay(vIndex: Integer);
begin
  mainScene.Config.main.R.Addons.Icons_Info[4].Header := TLabel.Create(mainScene.Config.main.R.Addons.Icons_Panel[4]);
  mainScene.Config.main.R.Addons.Icons_Info[4].Header.Name := 'Main_Config_Addons_Addon_Playr_Header';
  mainScene.Config.main.R.Addons.Icons_Info[4].Header.Parent := mainScene.Config.main.R.Addons.Icons_Panel[4];
  mainScene.Config.main.R.Addons.Icons_Info[4].Header.SetBounds(10, 20, 300, 28);
  mainScene.Config.main.R.Addons.Icons_Info[4].Header.Text := 'This addon is : ';
  mainScene.Config.main.R.Addons.Icons_Info[4].Header.Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[4].Activeted := TText.Create(mainScene.Config.main.R.Addons.Icons_Panel[4]);
  mainScene.Config.main.R.Addons.Icons_Info[4].Activeted.Name := 'Main_Config_Addons_Addon_Play_Active';
  mainScene.Config.main.R.Addons.Icons_Info[4].Activeted.Parent := mainScene.Config.main.R.Addons.Icons_Panel[4];
  mainScene.Config.main.R.Addons.Icons_Info[4].Activeted.SetBounds(90, 20, 200, 28);
  mainScene.Config.main.R.Addons.Icons_Info[4].Activeted.TextSettings.HorzAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[4].Activeted.Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[4].TextBox := TVertScrollBox.Create(mainScene.Config.main.R.Addons.Icons_Panel[4]);
  mainScene.Config.main.R.Addons.Icons_Info[4].TextBox.Name := 'Main_Config_Addons_Addon_Play_TextBox';
  mainScene.Config.main.R.Addons.Icons_Info[4].TextBox.Parent := mainScene.Config.main.R.Addons.Icons_Panel[4];
  mainScene.Config.main.R.Addons.Icons_Info[4].TextBox.SetBounds(10, 50, mainScene.Config.main.R.Addons.Icons_Panel[4].Width - 20,
    mainScene.Config.main.R.Addons.Icons_Panel[4].Height - 100);
  mainScene.Config.main.R.Addons.Icons_Info[4].TextBox.Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[0] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[4].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[0].Name := 'Main_Config_Addons_Play_Paragraph_' + IntToStr(0);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[0].Parent := mainScene.Config.main.R.Addons.Icons_Info[4].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[0].SetBounds(10, 10, mainScene.Config.main.R.Addons.Icons_Info[4].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[0].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[0].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[0].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[0].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[0].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[0].Text := ' This addon provide some small but addictive games.';
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[0].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[1] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[4].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[1].Name := 'Main_Config_Addons_Play_Paragraph_' + IntToStr(1);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[1].Parent := mainScene.Config.main.R.Addons.Icons_Info[4].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[1].SetBounds(10, 30, mainScene.Config.main.R.Addons.Icons_Info[4].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[1].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[1].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[1].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[1].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[1].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[1].Text := ' All games for now is under contruction. <b>WIP</b>';
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[1].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[2] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[4].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[2].Name := 'Main_Config_Addons_Play_Paragraph_' + IntToStr(2);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[2].Parent := mainScene.Config.main.R.Addons.Icons_Info[4].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[2].SetBounds(10, 50, mainScene.Config.main.R.Addons.Icons_Info[4].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[2].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[2].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[2].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[2].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[2].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[2].Text := ' The addon games are :';
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[2].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[3] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[4].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[3].Name := 'Main_Config_Addons_Play_Paragraph_' + IntToStr(3);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[3].Parent := mainScene.Config.main.R.Addons.Icons_Info[4].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[3].SetBounds(10, 70, mainScene.Config.main.R.Addons.Icons_Info[4].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[3].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[3].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[3].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[3].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[3].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[3].Text := ' <font color="#fff21212">*</font> AzHung : A hangman style game. <b>WIP</b>';
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[3].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[4] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[4].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[4].Name := 'Main_Config_Addons_Play_Paragraph_' + IntToStr(4);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[4].Parent := mainScene.Config.main.R.Addons.Icons_Info[4].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[4].SetBounds(10, 90, mainScene.Config.main.R.Addons.Icons_Info[4].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[4].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[4].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[4].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[4].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[4].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[4].Text := ' <font color="#fff21212">*</font> AzMatch : A matching tile style game. <b>WIP</b>';
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[4].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[5] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[4].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[5].Name := 'Main_Config_Addons_Play_Paragraph_' + IntToStr(5);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[5].Parent := mainScene.Config.main.R.Addons.Icons_Info[4].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[5].SetBounds(10, 110, mainScene.Config.main.R.Addons.Icons_Info[4].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[5].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[5].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[5].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[5].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[5].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[5].Text := ' <font color="#fff21212">*</font> AzOng : A pong style game. <b>WIP</b>';
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[5].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[6] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[4].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[6].Name := 'Main_Config_Addons_Play_Paragraph_' + IntToStr(6);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[6].Parent := mainScene.Config.main.R.Addons.Icons_Info[4].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[6].SetBounds(10, 130, mainScene.Config.main.R.Addons.Icons_Info[4].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[6].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[6].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[6].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[6].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[6].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[6].Text := ' <font color="#fff21212">*</font> AzSuko : A sudoku style game. <b>WIP</b>';
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[6].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[7] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[4].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[7].Name := 'Main_Config_Addons_Play_Paragraph_' + IntToStr(7);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[7].Parent := mainScene.Config.main.R.Addons.Icons_Info[4].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[7].SetBounds(10, 150, mainScene.Config.main.R.Addons.Icons_Info[4].TextBox.Width - 40, 30);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[7].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[7].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[7].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[7].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[7].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[7].Text := ' <font color="#fff21212">*</font> AzType : A typing style game. <b>WIP</b>';
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[7].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[8] := TALText.Create(mainScene.Config.main.R.Addons.Icons_Info[4].TextBox);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[8].Name := 'Main_Config_Addons_Play_Paragraph_' + IntToStr(8);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[8].Parent := mainScene.Config.main.R.Addons.Icons_Info[4].TextBox;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[8].SetBounds(10, 180, mainScene.Config.main.R.Addons.Icons_Info[4].TextBox.Width - 40, 60);
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[8].WordWrap := True;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[8].TextIsHtml := True;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[8].TextSettings.FontColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[8].TextSettings.Font.Size := 14;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[8].TextSettings.VertAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[8].Text :=
    ' <font color="#fff21212">Note : </font>For global scoring and some features must have an active internet connection.';
  mainScene.Config.main.R.Addons.Icons_Info[4].Paragraphs[8].Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[4].Athour := TLabel.Create(mainScene.Config.main.R.Addons.Icons_Panel[4]);
  mainScene.Config.main.R.Addons.Icons_Info[4].Athour.Name := 'Main_Config_Addons_Addon_Play_Author';
  mainScene.Config.main.R.Addons.Icons_Info[4].Athour.Parent := mainScene.Config.main.R.Addons.Icons_Panel[4];
  mainScene.Config.main.R.Addons.Icons_Info[4].Athour.SetBounds(10, mainScene.Config.main.R.Addons.Icons_Panel[4].Height - 40, 300, 28);
  mainScene.Config.main.R.Addons.Icons_Info[4].Athour.Text := 'Creator: Nikos Kordas';
  mainScene.Config.main.R.Addons.Icons_Info[4].Athour.Visible := True;

  mainScene.Config.main.R.Addons.Icons_Info[4].Action := TButton.Create(mainScene.Config.main.R.Addons.Icons_Panel[4]);
  mainScene.Config.main.R.Addons.Icons_Info[4].Action.Name := 'Main_Config_Addons_Addon_Play_Action';
  mainScene.Config.main.R.Addons.Icons_Info[4].Action.Parent := mainScene.Config.main.R.Addons.Icons_Panel[4];
  mainScene.Config.main.R.Addons.Icons_Info[4].Action.SetBounds(mainScene.Config.main.R.Addons.Icons_Panel[4].Width - 160,
    mainScene.Config.main.R.Addons.Icons_Panel[4].Height - 40, 150, 30);
  mainScene.Config.main.R.Addons.Icons_Info[4].Action.OnClick := ex_main.input.mouse_config.Button.OnMouseClick;
  mainScene.Config.main.R.Addons.Icons_Info[4].Action.Visible := True;

  if user_Active_Local.ADDONS.Azplay then
  begin
    mainScene.Config.main.R.Addons.Icons_Info[4].Activeted.Text := 'Active';
    mainScene.Config.main.R.Addons.Icons_Info[4].Activeted.Color := TAlphaColorRec.Lime;
    mainScene.Config.main.R.Addons.Icons_Info[4].Action.Text := 'Deactivate'
  end
  else
  begin
    mainScene.Config.main.R.Addons.Icons_Info[4].Activeted.Text := 'Inactive';
    mainScene.Config.main.R.Addons.Icons_Info[4].Activeted.Color := TAlphaColorRec.Red;
    mainScene.Config.main.R.Addons.Icons_Info[4].Action.Text := 'Activate';
  end;
end;

end.
