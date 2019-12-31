unit uView_Mode_Video;

interface
uses
  System.Classes,
  System.UiTypes,
  System.SysUtils,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Filter.Effects,
  FMX.Types,
  FMX.Ani,
  FMX.Effects,
  FMX.Layouts,
  FMX.Dialogs,
  FmxPasLibVlcPlayerUnit,
  PasLibVlcUnit;

{Creation}

{Create Scene }
procedure Create_Scene(vMain: TImage);

{Create the configuration standard part}
procedure Create_Configuration(vMain: TImage);

{Create the Gamelist part }
procedure Create_Gamelist;
procedure Create_Gamelist_Info;
procedure Create_Gamelist_Games;
procedure Create_Gamelist_Lists;
procedure Create_Gamelist_Filters;
procedure Create_Gamelist_Search;

{Create the media part}
procedure Create_Media;
procedure Create_Media_Bar;
procedure Create_Media_Video;


implementation
uses
  uDB_AUser,
  uView_Mode_Video_AllTypes,
  uView_Mode_Video_Mouse;

procedure Create_Configuration(vMain: TImage);
begin
  Emu_VM_Video.Config.Main := TPanel.Create(vMain);
  Emu_VM_Video.Config.Main.Name := 'Emu_Config';
  Emu_VM_Video.Config.Main.Parent := vMain;
  Emu_VM_Video.Config.Main.SetBounds(((vMain.Width / 2) - 350), ((vMain.Height / 2) - 300), 700, 630);
  Emu_VM_Video.Config.Main.Visible := True;

  Emu_VM_Video.Config.Blur := TGaussianBlurEffect.Create(Emu_VM_Video.Config.Main);
  Emu_VM_Video.Config.Blur.Name := 'Emu_Config_Blur';
  Emu_VM_Video.Config.Blur.Parent := Emu_VM_Video.Config.Main;
  Emu_VM_Video.Config.Blur.BlurAmount := 0.6;
  Emu_VM_Video.Config.Blur.Enabled := False;

  Emu_VM_Video.Config.Shadow := TShadowEffect.Create(Emu_VM_Video.Config.Main);
  Emu_VM_Video.Config.Shadow.Name := 'Mame_Config_Shadow';
  Emu_VM_Video.Config.Shadow.Parent := Emu_VM_Video.Config.Main;
  Emu_VM_Video.Config.Shadow.Direction := 90;
  Emu_VM_Video.Config.Shadow.Distance := 5;
  Emu_VM_Video.Config.Shadow.Opacity := 0.8;
  Emu_VM_Video.Config.Shadow.ShadowColor := TAlphaColorRec.Darkslategray;
  Emu_VM_Video.Config.Shadow.Softness := 0.5;
  Emu_VM_Video.Config.Shadow.Enabled := True;

  { This header part maybe not needed

  vMame.Config.Scene.Header := TPanel.Create(vMame.Config.Scene.Main);
  vMame.Config.Scene.Header.Name := 'Mame_Config_Header';
  vMame.Config.Scene.Header.Parent := vMame.Config.Scene.Main;
  vMame.Config.Scene.Header.SetBounds(0, 0, 700, 30);
  vMame.Config.Scene.Header.Visible := True;
  }

  Emu_VM_Video.Right := TImage.Create(vMain);
  Emu_VM_Video.Right.Name := 'Main_Right';
  Emu_VM_Video.Right.Parent := vMain;
  Emu_VM_Video.Right.SetBounds((vMain.Width / 2), 0, (vMain.Width / 2), (vMain.Height));
  Emu_VM_Video.Right.Bitmap.LoadFromFile(uDB_AUser.Local.EMULATORS.Arcade_D.Mame_D.p_Images + 'background.png');
  Emu_VM_Video.Right.WrapMode := TImageWrapMode.Original;
  Emu_VM_Video.Right.BitmapMargins.Left := -(vMain.Width / 2);
  Emu_VM_Video.Right.Visible := True;

  Emu_VM_Video.Right_Ani := TFloatAnimation.Create(Emu_VM_Video.Right);
  Emu_VM_Video.Right_Ani.Name := 'Main_Right_Animation';
  Emu_VM_Video.Right_Ani.Parent := Emu_VM_Video.Right;
  Emu_VM_Video.Right_Ani.Duration := 0.2;
  Emu_VM_Video.Right_Ani.Interpolation := TInterpolationType.Cubic;
  Emu_VM_Video.Right_Ani.PropertyName := 'Position.X';
//  Emu_VM_Video.Right_Ani.OnFinish := mame.Input.Mouse.Animation.OnFinish;
  Emu_VM_Video.Right_Ani.Enabled := False;

  Emu_VM_Video.Right_Blur := TBlurEffect.Create(Emu_VM_Video.Right);
  Emu_VM_Video.Right_Blur.Name := 'Main_Blur_Right';
  Emu_VM_Video.Right_Blur.Parent := Emu_VM_Video.Right;
  Emu_VM_Video.Right_Blur.Enabled := False;

  Emu_VM_Video.Left := TImage.Create(vMain);
  Emu_VM_Video.Left.Name := 'Main_Left';
  Emu_VM_Video.Left.Parent := vMain;
  Emu_VM_Video.Left.SetBounds(0, 0, (vMain.Width / 2), (vMain.Height));
  Emu_VM_Video.Left.Bitmap.LoadFromFile(uDB_AUser.Local.EMULATORS.Arcade_D.Mame_D.p_Images + 'background.png');
  Emu_VM_Video.Left.WrapMode := TImageWrapMode.Original;
  Emu_VM_Video.Left.Visible := True;

  Emu_VM_Video.Left_Ani := TFloatAnimation.Create(Emu_VM_Video.Left);
  Emu_VM_Video.Left_Ani.Name := 'Main_Left_Animation';
  Emu_VM_Video.Left_Ani.Parent := Emu_VM_Video.Left;
  Emu_VM_Video.Left_Ani.Duration := 0.2;
  Emu_VM_Video.Left_Ani.Interpolation := TInterpolationType.Cubic;
  Emu_VM_Video.Left_Ani.PropertyName := 'Position.X';
//  Emu_VM_Video.Left_Ani.OnFinish := mame.Input.Mouse.Animation.OnFinish;
  Emu_VM_Video.Left_Ani.Enabled := False;

  Emu_VM_Video.Left_Blur := TBlurEffect.Create(Emu_VM_Video.Left);
  Emu_VM_Video.Left_Blur.Name := 'Main_Blur_Left';
  Emu_VM_Video.Left_Blur.Parent := Emu_VM_Video.Left;
  Emu_VM_Video.Left_Blur.Enabled := False;
end;

procedure Create_Scene(vMain: TImage);
begin
  Emu_VM_Video.Blur := TGaussianBlurEffect.Create(vMain);
  Emu_VM_Video.Blur.Name := 'Main_Blur';
  Emu_VM_Video.Blur.Parent := vMain;
  Emu_VM_Video.Blur.BlurAmount := 0;
  Emu_VM_Video.Blur.Enabled := False;

  Create_Configuration(vMain);

  Emu_VM_Video.Exit := TText.Create(Emu_VM_Video.Right);
  Emu_VM_Video.Exit.Name := 'Emu_Exit';
  Emu_VM_Video.Exit.Parent := Emu_VM_Video.Right;
  Emu_VM_Video.Exit.SetBounds((Emu_VM_Video.Right.Width - 29), 5, 24, 24);
  Emu_VM_Video.Exit.Font.Family := 'IcoMoon-Free';
  Emu_VM_Video.Exit.Font.Size := 18;
  Emu_VM_Video.Exit.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Exit.Text := #$ea0f;
  Emu_VM_Video.Exit.OnClick := Emu_VM_Video_Mouse.Text.OnMouseClick;
  Emu_VM_Video.Exit.OnMouseEnter := Emu_VM_Video_Mouse.Text.OnMouseEnter;
  Emu_VM_Video.Exit.OnMouseLeave := Emu_VM_Video_Mouse.Text.OnMouseLeave;
  Emu_VM_Video.Exit.Visible := True;

  Emu_VM_Video.Exit_Glow := TGlowEffect.Create(Emu_VM_Video.Exit);
  Emu_VM_Video.Exit_Glow.Name := 'Emu_Exit_Glow';
  Emu_VM_Video.Exit_Glow.Parent := Emu_VM_Video.Exit;
  Emu_VM_Video.Exit_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Exit_Glow.Opacity := 0.9;
  Emu_VM_Video.Exit_Glow.Softness := 0.4;
  Emu_VM_Video.Exit_Glow.Enabled := False;

  Emu_VM_Video.Settings := TText.Create(vMain);
  Emu_VM_Video.Settings.Name := 'Emu_Settings';
  Emu_VM_Video.Settings.Parent := vMain;
  Emu_VM_Video.Settings.SetBounds(((vMain.Width / 2) - 25), (vMain.Height - 60), 48, 48);
  Emu_VM_Video.Settings.Font.Family := 'IcoMoon-Free';
  Emu_VM_Video.Settings.Font.Size := 48;
  Emu_VM_Video.Settings.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Settings.Text := #$e994;
//  Emu_VM_Video.Settings.OnClick := mame.Input.Mouse.Text.OnMouseClick;
//  Emu_VM_Video.Settings.OnMouseEnter := mame.Input.Mouse.Text.OnMouseEnter;
//  Emu_VM_Video.Settings.OnMouseLeave := mame.Input.Mouse.Text.OnMouseLeave;
  Emu_VM_Video.Settings.Tag := 1;
  Emu_VM_Video.Settings.Visible := True;

  Emu_VM_Video.Settings_Ani := TFloatAnimation.Create(Emu_VM_Video.Settings);
  Emu_VM_Video.Settings_Ani.Name := 'Emu_Settings_Ani';
  Emu_VM_Video.Settings_Ani.Parent := Emu_VM_Video.Settings;
  Emu_VM_Video.Settings_Ani.Duration := 4;
  Emu_VM_Video.Settings_Ani.Loop := True;
  Emu_VM_Video.Settings_Ani.PropertyName := 'RotationAngle';
  Emu_VM_Video.Settings_Ani.StartValue := 0;
  Emu_VM_Video.Settings_Ani.StopValue := 360;
  Emu_VM_Video.Settings_Ani.Enabled := True;

  Emu_VM_Video.Settings_Glow := TGlowEffect.Create(Emu_VM_Video.Settings);
  Emu_VM_Video.Settings_Glow.Name := 'Emu_Settings_Glow';
  Emu_VM_Video.Settings_Glow.Parent := Emu_VM_Video.Settings;
  Emu_VM_Video.Settings_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Settings_Glow.Opacity := 0.9;
  Emu_VM_Video.Settings_Glow.Softness := 0.4;
  Emu_VM_Video.Settings_Glow.Enabled := False;

  Create_Gamelist;
  Create_Media;
end;


{Creation of the gamelist part}

procedure Create_Gamelist_Info;
begin
  Emu_VM_Video.Gamelist.Info.Back := TImage.Create(Emu_VM_Video.Left);
  Emu_VM_Video.Gamelist.Info.Back.Name := 'Emu_Gamelist_Info';
  Emu_VM_Video.Gamelist.Info.Back.Parent := Emu_VM_Video.Left;
  Emu_VM_Video.Gamelist.Info.Back.SetBounds(50, 18, 750, 26);
  Emu_VM_Video.Gamelist.Info.Back.WrapMode := TImageWrapMode.Tile;
  Emu_VM_Video.Gamelist.Info.Back.Bitmap.LoadFromFile(uDB_AUser.Local.EMULATORS.Arcade_D.Mame_D.p_Images + 'black_menu.png');
  Emu_VM_Video.Gamelist.Info.Back.Visible := True;

  Emu_VM_Video.Gamelist.Info.Games_Count := TText.Create(Emu_VM_Video.Gamelist.Info.Back);
  Emu_VM_Video.Gamelist.Info.Games_Count.Name := 'Emu_Gamelist_Info_GamesCount';
  Emu_VM_Video.Gamelist.Info.Games_Count.Parent := Emu_VM_Video.Gamelist.Info.Back;
  Emu_VM_Video.Gamelist.Info.Games_Count.SetBounds(0, 1, 750, 22);
  Emu_VM_Video.Gamelist.Info.Games_Count.Text := '';
  Emu_VM_Video.Gamelist.Info.Games_Count.Color := TAlphaColorRec.White;
  Emu_VM_Video.Gamelist.Info.Games_Count.Font.Family := 'Tahoma';
  Emu_VM_Video.Gamelist.Info.Games_Count.Font.Style := Emu_VM_Video.Gamelist.Info.Games_Count.Font.Style + [TFontStyle.fsBold];
  Emu_VM_Video.Gamelist.Info.Games_Count.Font.Size := 20;
  Emu_VM_Video.Gamelist.Info.Games_Count.TextSettings.HorzAlign := TTextAlign.Trailing;
  Emu_VM_Video.Gamelist.Info.Games_Count.Visible := True;

  Emu_VM_Video.Gamelist.Info.Version := TText.Create(Emu_VM_Video.Gamelist.Info.Back);
  Emu_VM_Video.Gamelist.Info.Version.Name := 'Emu_Gamelist_Info_Version';
  Emu_VM_Video.Gamelist.Info.Version.Parent := Emu_VM_Video.Gamelist.Info.Back;
  Emu_VM_Video.Gamelist.Info.Version.SetBounds(0, 1, 750, 22);
  Emu_VM_Video.Gamelist.Info.Version.Color := TAlphaColorRec.White;
  Emu_VM_Video.Gamelist.Info.Version.Text := uDB_AUser.Local.EMULATORS.Arcade_D.Mame_D.Version;
  Emu_VM_Video.Gamelist.Info.Version.Font.Family := 'Tahoma';
  Emu_VM_Video.Gamelist.Info.Version.Font.Style := Emu_VM_Video.Gamelist.Info.Version.Font.Style + [TFontStyle.fsBold];
  Emu_VM_Video.Gamelist.Info.Version.Font.Size := 20;
  Emu_VM_Video.Gamelist.Info.Version.TextSettings.HorzAlign := TTextAlign.Leading;
  Emu_VM_Video.Gamelist.Info.Version.Visible := True;
end;

procedure Create_Gamelist_Games;
var
  vi: integer;
  viPos: integer;
begin
  Emu_VM_Video.Gamelist.Games.List := TImage.Create(Emu_VM_Video.Left);
  Emu_VM_Video.Gamelist.Games.List.Name := 'Emu_Gamelist_Games';
  Emu_VM_Video.Gamelist.Games.List.Parent := Emu_VM_Video.Left;
  Emu_VM_Video.Gamelist.Games.List.SetBounds(50, 50, 750, (Emu_VM_Video.Left.Height - 180));
  Emu_VM_Video.Gamelist.Games.List.WrapMode := TImageWrapMode.Tile;
  Emu_VM_Video.Gamelist.Games.List.Bitmap.LoadFromFile(uDB_AUser.Local.EMULATORS.Arcade_D.Mame_D.p_Images + 'black_menu.png');
  Emu_VM_Video.Gamelist.Games.List.Visible := True;

  Emu_VM_Video.Gamelist.Games.Listbox := TVertScrollBox.Create(Emu_VM_Video.Gamelist.Games.List);
  Emu_VM_Video.Gamelist.Games.Listbox.Name := 'Emu_Gamelist_Games_Box';
  Emu_VM_Video.Gamelist.Games.Listbox.Parent := Emu_VM_Video.Gamelist.Games.List;
  Emu_VM_Video.Gamelist.Games.Listbox.Align := TAlignLayout.Client;
  Emu_VM_Video.Gamelist.Games.Listbox.ShowScrollBars := False;
  Emu_VM_Video.Gamelist.Games.Listbox.Visible := True;

  for vi := 0 to 20 do
  begin
    Emu_VM_Video.Gamelist.Games.Line[vi].Back := TImage.Create(Emu_VM_Video.Gamelist.Games.Listbox);
    Emu_VM_Video.Gamelist.Games.Line[vi].Back.Name := 'Emu_Gamelist_Games_Line_' + vi.ToString;
    Emu_VM_Video.Gamelist.Games.Line[vi].Back.Parent := Emu_VM_Video.Gamelist.Games.Listbox;
    Emu_VM_Video.Gamelist.Games.Line[vi].Back.SetBounds(0, ((vi * 40) + (vi + 10)), (Emu_VM_Video.Gamelist.Games.Listbox.Width - 10), 40);
    Emu_VM_Video.Gamelist.Games.Line[vi].Back.Tag := vi;
    Emu_VM_Video.Gamelist.Games.Line[vi].Back.Visible := True;

    Emu_VM_Video.Gamelist.Games.Line[vi].Icon := TImage.Create(Emu_VM_Video.Gamelist.Games.Line[vi].Back);
    Emu_VM_Video.Gamelist.Games.Line[vi].Icon.Name := 'Emu_Gamelist_Games_Icon_' + vi.ToString;
    Emu_VM_Video.Gamelist.Games.Line[vi].Icon.Parent := Emu_VM_Video.Gamelist.Games.Line[vi].Back;
    Emu_VM_Video.Gamelist.Games.Line[vi].Icon.SetBounds(4, 2, 38, 38);
    Emu_VM_Video.Gamelist.Games.Line[vi].Icon.Tag := vi;
    Emu_VM_Video.Gamelist.Games.Line[vi].Icon.Visible := True;

    Emu_VM_Video.Gamelist.Games.Line[vi].Text := TText.Create(Emu_VM_Video.Gamelist.Games.Line[vi].Back);
    Emu_VM_Video.Gamelist.Games.Line[vi].Text.Name := 'Emu_Gamelist_Games_Game_' + vi.ToString;
    Emu_VM_Video.Gamelist.Games.Line[vi].Text.Parent := Emu_VM_Video.Gamelist.Games.Line[vi].Back;
    Emu_VM_Video.Gamelist.Games.Line[vi].Text.SetBounds(48, 3, 654, 34);
    Emu_VM_Video.Gamelist.Games.Line[vi].Text.Text := IntToStr(vi);
    Emu_VM_Video.Gamelist.Games.Line[vi].Text.Font.Family := 'Tahoma';
    Emu_VM_Video.Gamelist.Games.Line[vi].Text.Color := TAlphaColorRec.White;
    Emu_VM_Video.Gamelist.Games.Line[vi].Text.Font.Style := Emu_VM_Video.Gamelist.Games.Line[vi].Text.Font.Style + [TFontStyle.fsBold];
    if vi = 10 then
      Emu_VM_Video.Gamelist.Games.Line[vi].Text.Font.Size := 24
    else
      Emu_VM_Video.Gamelist.Games.Line[vi].Text.Font.Size := 18;
    Emu_VM_Video.Gamelist.Games.Line[vi].Text.HorzTextAlign := TTextAlign.Leading;
    Emu_VM_Video.Gamelist.Games.Line[vi].Text.Tag := vi;
    Emu_VM_Video.Gamelist.Games.Line[vi].Text.Visible := True;
  end;

  Emu_VM_Video.Gamelist.Games.Selection := TGlowEffect.Create(Emu_VM_Video.Gamelist.Games.Line[10].Text);
  Emu_VM_Video.Gamelist.Games.Selection.Name := 'Emu_Gamelist_Game_Selection';
  Emu_VM_Video.Gamelist.Games.Selection.Parent := Emu_VM_Video.Gamelist.Games.Line[10].Text;
  Emu_VM_Video.Gamelist.Games.Selection.GlowColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Gamelist.Games.Selection.Opacity := 0.9;
  Emu_VM_Video.Gamelist.Games.Selection.Softness := 0.4;
  Emu_VM_Video.Gamelist.Games.Selection.Enabled := True;

  Emu_VM_Video.Gamelist.Games.Line[10].Back.Bitmap.LoadFromFile(uDB_AUser.Local.EMULATORS.Arcade_D.Mame_D.p_Images + 'selection.png');

  Emu_VM_Video.Gamelist.Games.List_Blur := TBlurEffect.Create(Emu_VM_Video.Gamelist.Games.Listbox);
  Emu_VM_Video.Gamelist.Games.List_Blur.Name := 'Emu_Gamelist_Games_List_Blur';
  Emu_VM_Video.Gamelist.Games.List_Blur.Parent := Emu_VM_Video.Gamelist.Games.Listbox;
  Emu_VM_Video.Gamelist.Games.List_Blur.Softness := 0.9;
  Emu_VM_Video.Gamelist.Games.List_Blur.Enabled := False;
end;

procedure Create_Gamelist_Lists;
begin
  Emu_VM_Video.Gamelist.Lists.Back := TImage.Create(Emu_VM_Video.Left);
  Emu_VM_Video.Gamelist.Lists.Back.Name := 'Emu_Gamelist_Lists';
  Emu_VM_Video.Gamelist.Lists.Back.Parent := Emu_VM_Video.Left;
  Emu_VM_Video.Gamelist.Lists.Back.SetBounds(50, 958, 750, 26);
  Emu_VM_Video.Gamelist.Lists.Back.WrapMode := TImageWrapMode.Tile;
  Emu_VM_Video.Gamelist.Lists.Back.Bitmap.LoadFromFile(uDB_AUser.Local.EMULATORS.Arcade_D.Mame_D.p_Images + 'black_menu.png');
  Emu_VM_Video.Gamelist.Lists.Back.Visible := True;

  Emu_VM_Video.Gamelist.Lists.Lists := TText.Create(Emu_VM_Video.Gamelist.Lists.Back);
  Emu_VM_Video.Gamelist.Lists.Lists.Name := 'Emu_Gamelist_Lists_Icon';
  Emu_VM_Video.Gamelist.Lists.Lists.Parent := Emu_VM_Video.Gamelist.Lists.Back;
  Emu_VM_Video.Gamelist.Lists.Lists.SetBounds(2, 1, 24, 24);
  Emu_VM_Video.Gamelist.Lists.Lists.Font.Family := 'IcoMoon-Free';
  Emu_VM_Video.Gamelist.Lists.Lists.Font.Size := 22;
  Emu_VM_Video.Gamelist.Lists.Lists.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Gamelist.Lists.Lists.Text := #$e904;
//  Emu_VM_Video.Gamelist.Lists.Lists.OnClick := mame.Input.Mouse.Text.OnMouseClick;
//  Emu_VM_Video.Gamelist.Lists.Lists.OnMouseEnter := mame.Input.Mouse.Text.OnMouseEnter;
//  Emu_VM_Video.Gamelist.Lists.Lists.OnMouseLeave := mame.Input.Mouse.Text.OnMouseLeave;
  Emu_VM_Video.Gamelist.Lists.Lists.Visible := True;

  Emu_VM_Video.Gamelist.Lists.Lists_Glow := TGlowEffect.Create(Emu_VM_Video.Gamelist.Lists.Lists);
  Emu_VM_Video.Gamelist.Lists.Lists_Glow.Name := 'Emu_Gamelist_Lists_Icon_Glow';
  Emu_VM_Video.Gamelist.Lists.Lists_Glow.Parent := Emu_VM_Video.Gamelist.Lists.Lists;
  Emu_VM_Video.Gamelist.Lists.Lists_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Gamelist.Lists.Lists_Glow.Softness := 0.9;
  Emu_VM_Video.Gamelist.Lists.Lists_Glow.Enabled := False;

  Emu_VM_Video.Gamelist.Lists.Lists_Text := TText.Create(Emu_VM_Video.Gamelist.Lists.Back);
  Emu_VM_Video.Gamelist.Lists.Lists_Text.Name := 'Mame_Gamelist_Lists_Text';
  Emu_VM_Video.Gamelist.Lists.Lists_Text.Parent := Emu_VM_Video.Gamelist.Lists.Back;
  Emu_VM_Video.Gamelist.Lists.Lists_Text.SetBounds(40, 1, 710, 22);
  Emu_VM_Video.Gamelist.Lists.Lists_Text.Color := TAlphaColorRec.White;
  Emu_VM_Video.Gamelist.Lists.Lists_Text.Font.Family := 'Tahoma';
  Emu_VM_Video.Gamelist.Lists.Lists_Text.Font.Size := 20;
  Emu_VM_Video.Gamelist.Lists.Lists_Text.TextSettings.HorzAlign := TTextAlign.Leading;
  Emu_VM_Video.Gamelist.Lists.Lists_Text.Visible := True;
end;

procedure Create_Gamelist_Filters;
begin
  Emu_VM_Video.Gamelist.Filters.Back := TImage.Create(Emu_VM_Video.Left);
  Emu_VM_Video.Gamelist.Filters.Back.Name := 'Emu_Gamelist_Filters';
  Emu_VM_Video.Gamelist.Filters.Back.Parent := Emu_VM_Video.Left;
  Emu_VM_Video.Gamelist.Filters.Back.SetBounds(50, 992, 750, 26);
  Emu_VM_Video.Gamelist.Filters.Back.WrapMode := TImageWrapMode.Tile;
  Emu_VM_Video.Gamelist.Filters.Back.Bitmap.LoadFromFile(uDB_AUser.Local.EMULATORS.Arcade_D.Mame_D.p_Images + 'black_menu.png');
  Emu_VM_Video.Gamelist.Filters.Back.Visible := True;

  Emu_VM_Video.Gamelist.Filters.Filter := TText.Create(Emu_VM_Video.Gamelist.Filters.Back);
  Emu_VM_Video.Gamelist.Filters.Filter.Name := 'Emu_Gamelist_Filters_Icon';
  Emu_VM_Video.Gamelist.Filters.Filter.Parent := Emu_VM_Video.Gamelist.Filters.Back;
  Emu_VM_Video.Gamelist.Filters.Filter.SetBounds(2, 1, 24, 24);
  Emu_VM_Video.Gamelist.Filters.Filter.Font.Family := 'IcoMoon-Free';
  Emu_VM_Video.Gamelist.Filters.Filter.Font.Size := 22;
  Emu_VM_Video.Gamelist.Filters.Filter.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Gamelist.Filters.Filter.Text := #$ea5b;
//  Emu_VM_Video.Gamelist.Filters.Filter.OnClick := mame.Input.Mouse.Text.OnMouseClick;
//  Emu_VM_Video.Gamelist.Filters.Filter.OnMouseEnter := mame.Input.Mouse.Text.OnMouseEnter;
//  Emu_VM_Video.Gamelist.Filters.Filter.OnMouseLeave := mame.Input.Mouse.Text.OnMouseLeave;
  Emu_VM_Video.Gamelist.Filters.Filter.Visible := True;

  Emu_VM_Video.Gamelist.Filters.Filter_Glow := TGlowEffect.Create(Emu_VM_Video.Gamelist.Filters.Filter);
  Emu_VM_Video.Gamelist.Filters.Filter_Glow.Name := 'Mame_Gamelist_Filters_Icon_Glow';
  Emu_VM_Video.Gamelist.Filters.Filter_Glow.Parent := Emu_VM_Video.Gamelist.Filters.Filter;
  Emu_VM_Video.Gamelist.Filters.Filter_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Gamelist.Filters.Filter_Glow.Softness := 0.9;
  Emu_VM_Video.Gamelist.Filters.Filter_Glow.Enabled := False;

  Emu_VM_Video.Gamelist.Filters.Filter_Text := TText.Create(Emu_VM_Video.Gamelist.Filters.Back);
  Emu_VM_Video.Gamelist.Filters.Filter_Text.Name := 'Mame_Gamelist_Filters_Text';
  Emu_VM_Video.Gamelist.Filters.Filter_Text.Parent := Emu_VM_Video.Gamelist.Filters.Back;
  Emu_VM_Video.Gamelist.Filters.Filter_Text.SetBounds(40, 1, 710, 22);
  Emu_VM_Video.Gamelist.Filters.Filter_Text.Color := TAlphaColorRec.White;
  Emu_VM_Video.Gamelist.Filters.Filter_Text.Font.Size := 20;
  Emu_VM_Video.Gamelist.Filters.Filter_Text.Text := 'All';
  Emu_VM_Video.Gamelist.Filters.Filter_Text.TextSettings.HorzAlign := TTextAlign.Leading;
  Emu_VM_Video.Gamelist.Filters.Filter_Text.Visible := True;
end;

procedure Create_Gamelist_Search;
begin

end;

procedure Create_Gamelist;
begin
  Create_Gamelist_Info;
  Create_Gamelist_Games;
  Create_Gamelist_Lists;
  Create_Gamelist_Filters;
  Create_Gamelist_Search;
end;


{Creation of the media part}

procedure Create_Media_Bar;
begin
  Emu_VM_Video.Media.Bar.Back := TImage.Create(Emu_VM_Video.Right);
  Emu_VM_Video.Media.Bar.Back.Name := 'Emu_Media_Bar';
  Emu_VM_Video.Media.Bar.Back.Parent := Emu_VM_Video.Right;
  Emu_VM_Video.Media.Bar.Back.SetBounds(50, 50, 750, (Emu_VM_Video.Right.Height - 180));
  Emu_VM_Video.Media.Bar.Back.WrapMode := TImageWrapMode.Tile;
  Emu_VM_Video.Media.Bar.Back.Bitmap.LoadFromFile(uDB_AUser.Local.EMULATORS.Arcade_D.Mame_D.p_Images + 'black_menu.png');
  Emu_VM_Video.Media.Bar.Back.Visible := True;

  { I dont understand why i create this see in future
  vMame.Scene.Media.Up_Back_Image := TImage.Create(vMame.Scene.Right);
  vMame.Scene.Media.Up_Back_Image.Name := 'Mame_Media_Up_Back_Image';
  vMame.Scene.Media.Up_Back_Image.Parent := vMame.Scene.Right;
  vMame.Scene.Media.Up_Back_Image.SetBounds(50, 18, 750, 26);
  vMame.Scene.Media.Up_Back_Image.WrapMode := TImageWrapMode.Tile;
  vMame.Scene.Media.Up_Back_Image.Bitmap.LoadFromFile(uDB_AUser.Local.EMULATORS.Arcade_D.Mame_D.p_Images + 'black_menu.png');
  vMame.Scene.Media.Up_Back_Image.Visible := True;
  }

  Emu_VM_Video.Media.Bar.Favorites := TText.Create(Emu_VM_Video.Media.Bar.Back);
  Emu_VM_Video.Media.Bar.Favorites.Name := 'Emu_Media_Bar_Favorites';
  Emu_VM_Video.Media.Bar.Favorites.Parent := Emu_VM_Video.Media.Bar.Back;
  Emu_VM_Video.Media.Bar.Favorites.SetBounds(2, 1, 24, 24);
  Emu_VM_Video.Media.Bar.Favorites.Font.Family := 'IcoMoon-Free';
  Emu_VM_Video.Media.Bar.Favorites.Font.Size := 22;
  Emu_VM_Video.Media.Bar.Favorites.TextSettings.FontColor := TAlphaColorRec.Grey;
  Emu_VM_Video.Media.Bar.Favorites.Text := #$e9d9;
//  Emu_VM_Video.Media.Bar.Favorites.OnClick := mame.Input.Mouse.Text.OnMouseClick;
//  Emu_VM_Video.Media.Bar.Favorites.OnMouseEnter := mame.Input.Mouse.Text.OnMouseEnter;
//  Emu_VM_Video.Media.Bar.Favorites.OnMouseLeave := mame.Input.Mouse.Text.OnMouseLeave;
  Emu_VM_Video.Media.Bar.Favorites.Visible := True;

  Emu_VM_Video.Media.Bar.Favorites_Glow := TGlowEffect.Create(Emu_VM_Video.Media.Bar.Favorites);
  Emu_VM_Video.Media.Bar.Favorites_Glow.Name := 'Emu_Media_Bar_Favorites_Glow';
  Emu_VM_Video.Media.Bar.Favorites_Glow.Parent := Emu_VM_Video.Media.Bar.Favorites;
  Emu_VM_Video.Media.Bar.Favorites_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Media.Bar.Favorites_Glow.Softness := 0.9;
  Emu_VM_Video.Media.Bar.Favorites_Glow.Enabled := False;
end;

procedure Create_Media_Video;
begin
  Emu_VM_Video.Media.Video.Back := TImage.Create(Emu_VM_Video.Right);
  Emu_VM_Video.Media.Video.Back.Name := 'Emu_Media_Video';
  Emu_VM_Video.Media.Video.Back.Parent := Emu_VM_Video.Right;
  Emu_VM_Video.Media.Video.Back.SetBounds(100, 150, 650, 600);
  Emu_VM_Video.Media.Video.Back.Bitmap.LoadFromFile(uDB_AUser.Local.EMULATORS.Arcade_D.Mame_D.p_Images + 'black.png');
  Emu_VM_Video.Media.Video.Back.Visible := True;

{$IFDEF WIN32}
  libvlc_dynamic_dll_init_with_path('C:\Program Files (x86)\VideoLAN\VLC');
{$ENDIF}
  if (libvlc_dynamic_dll_error <> '') then
  begin
    ShowMessage(libvlc_dynamic_dll_error);
    exit;
  end;

  Emu_VM_Video.Media.Video.Video := TFmxPasLibVlcPlayer.Create(Emu_VM_Video.Media.Video.Back);
  Emu_VM_Video.Media.Video.Video.Name := 'Mame_Snap_Video';
  Emu_VM_Video.Media.Video.Video.Parent := Emu_VM_Video.Media.Video.Back;
  Emu_VM_Video.Media.Video.Video.Align := TAlignLayout.Client;
  Emu_VM_Video.Media.Video.Video.SetVideoAspectRatio('4:3');
  Emu_VM_Video.Media.Video.Video.WrapMode := TImageWrapMode.Stretch;
  Emu_VM_Video.Media.Video.Video.Visible := True;

  Emu_VM_Video.Media.Video.Video_Timer_Cont := TTimer.Create(Emu_VM_Video.Media.Video.Back);
  Emu_VM_Video.Media.Video.Video_Timer_Cont.Interval := 100;
//  Emu_VM_Video.Media.Video.Video_Timer_Cont.OnTimer := mame.Timers.Video_Cont.OnTimer;
  Emu_VM_Video.Media.Video.Video_Timer_Cont.Enabled := False;

  Emu_VM_Video.Media.Video.Game_Info.Layout := TLayout.Create(Emu_VM_Video.Media.Video.Back);
  Emu_VM_Video.Media.Video.Game_Info.Layout.Name := 'Mame_Media_Players';
  Emu_VM_Video.Media.Video.Game_Info.Layout.Parent := Emu_VM_Video.Media.Video.Back;
  Emu_VM_Video.Media.Video.Game_Info.Layout.SetBounds(0, 0, Emu_VM_Video.Media.Video.Back.Width, 50);
  Emu_VM_Video.Media.Video.Game_Info.Layout.Visible := True;

  Emu_VM_Video.Media.Video.Game_Info.Players := TText.Create(Emu_VM_Video.Media.Video.Game_Info.Layout);
  Emu_VM_Video.Media.Video.Game_Info.Players.Name := 'Mame_Media_Players';
  Emu_VM_Video.Media.Video.Game_Info.Players.Parent := Emu_VM_Video.Media.Video.Game_Info.Layout;
  Emu_VM_Video.Media.Video.Game_Info.Players.SetBounds(10, 5, 60, 50);
  Emu_VM_Video.Media.Video.Game_Info.Players.Font.Family := 'IcoMoon-Free';
  Emu_VM_Video.Media.Video.Game_Info.Players.Font.Size := 24;
  Emu_VM_Video.Media.Video.Game_Info.Players.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Media.Video.Game_Info.Players.Text := #$e972;
  Emu_VM_Video.Media.Video.Game_Info.Players.Visible := True;

  Emu_VM_Video.Media.Video.Game_Info.Players_Value := TText.Create(Emu_VM_Video.Media.Video.Game_Info.Layout);
  Emu_VM_Video.Media.Video.Game_Info.Players_Value.Name := 'Mame_Media_Players_Value';
  Emu_VM_Video.Media.Video.Game_Info.Players_Value.Parent := Emu_VM_Video.Media.Video.Game_Info.Layout;
  Emu_VM_Video.Media.Video.Game_Info.Players_Value.SetBounds(60, 5, 500, 50);
  Emu_VM_Video.Media.Video.Game_Info.Players_Value.Font.Family := 'Tahome';
  Emu_VM_Video.Media.Video.Game_Info.Players_Value.Font.Size := 18;
  Emu_VM_Video.Media.Video.Game_Info.Players_Value.TextSettings.FontColor := TAlphaColorRec.White;
  Emu_VM_Video.Media.Video.Game_Info.Players_Value.HorzTextAlign := TTextAlign.Leading;
  Emu_VM_Video.Media.Video.Game_Info.Players_Value.Text := '';
  Emu_VM_Video.Media.Video.Game_Info.Players_Value.Visible := True;

  Emu_VM_Video.Media.Video.Game_Info.Favorite := TText.Create(Emu_VM_Video.Media.Video.Game_Info.Layout);
  Emu_VM_Video.Media.Video.Game_Info.Favorite.Name := 'Mame_Media_Favorite';
  Emu_VM_Video.Media.Video.Game_Info.Favorite.Parent := Emu_VM_Video.Media.Video.Game_Info.Layout;
  Emu_VM_Video.Media.Video.Game_Info.Favorite.SetBounds(Emu_VM_Video.Media.Video.Game_Info.Layout.Width - 60, 5, 60, 50);
  Emu_VM_Video.Media.Video.Game_Info.Favorite.Font.Family := 'IcoMoon-Free';
  Emu_VM_Video.Media.Video.Game_Info.Favorite.Font.Size := 24;
  Emu_VM_Video.Media.Video.Game_Info.Favorite.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Media.Video.Game_Info.Favorite.Text := #$e9d9;
  Emu_VM_Video.Media.Video.Game_Info.Favorite.Visible := False;
end;

procedure Create_Media;
begin
  Create_Media_Bar;
  Create_Media_Video;
end;

end.
