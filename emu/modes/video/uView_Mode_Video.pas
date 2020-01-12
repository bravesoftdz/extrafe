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
  PasLibVlcUnit,
  Xml.xmldom,
  Xml.XMLIntf,
  Xml.adomxmldom,
  Xml.XMLDoc,
  Xml.omnixmldom;

{ Creation }

{ Create Scene }
procedure Create_Scene(vMain: TImage; vPath, vImages: String);

{ Create the configuration standard part }
procedure Create_Configuration(vMain: TImage);
procedure Free_Configuarion;

{ Create the Gamelist part }
procedure Create_Gamelist;
procedure Create_Gamelist_Info;
procedure Create_Gamelist_Games;
procedure Create_Gamelist_Lists;
procedure Create_Gamelist_Filters;
procedure Create_Gamelist_Search;

{ Create the media part }
procedure Create_Media;
procedure Create_Media_Bar;
procedure Create_Media_Video;

{ XML Part of view mode }
procedure Load_XML_Variables(vPath: String);

var
  vXML: IXMLDocument;
  vRoot, vNode: IXMLNode;

implementation

uses
  uLoad_AllTypes,
  uDB_AUser,
  uView_Mode_Video_AllTypes,
  uView_Mode_Video_Mouse;

procedure Load_XML_Variables(vPath: String);
var
  vi, vk: Integer;
  vNode_Temp: IXMLNode;

begin
  vXML := TXMLDocument.Create('');
  vXML.LoadFromFile(vPath + 'video.xml');
  if vXML.IsEmptyDoc = False then
  begin
    vRoot := vXML.DocumentElement;
    if vRoot.HasAttribute('name') then
      Emu_XML.emu.name := vRoot.Attributes['name'];
    if vRoot.HasAttribute('type') then
      Emu_XML.emu.vtype := vRoot.Attributes['type'];
    if vRoot.HasAttribute('exe') then
      Emu_XML.emu.exe := vRoot.Attributes['exe'];

    for vi := 0 to vRoot.ChildNodes.Count - 1 do
    begin
      vNode := vRoot.ChildNodes[vi];
      if vNode.NodeName = 'main' then
      begin
        { Background }
        Emu_XML.main.Background.image := vNode.ChildNodes['background'].Text;
        Emu_XML.main.Background.width := vNode.ChildNodes['background'].Attributes['width'];
        Emu_XML.main.Background.height := vNode.ChildNodes['background'].Attributes['height'];
        Emu_XML.main.Background.vtype := vNode.ChildNodes['background'].Attributes['type'];
        { Black }
        Emu_XML.main.Black.image := vNode.ChildNodes['black'].Text;
        Emu_XML.main.Black.width := vNode.ChildNodes['black'].Attributes['width'];
        Emu_XML.main.Black.height := vNode.ChildNodes['black'].Attributes['height'];
        { Black Opacity }
        Emu_XML.main.Black_Opacity.image := vNode.ChildNodes['black_opacity'].Text;
        Emu_XML.main.Black_Opacity.width := vNode.ChildNodes['black_opacity'].Attributes['width'];
        Emu_XML.main.Black_Opacity.height := vNode.ChildNodes['black_opacity'].Attributes['height'];
        { Selection }
        Emu_XML.main.Selection.image := vNode.ChildNodes['selection'].Text;
        Emu_XML.main.Selection.width := vNode.ChildNodes['selection'].Attributes['width'];
        Emu_XML.main.Selection.height := vNode.ChildNodes['selection'].Attributes['height'];
      end
      else if vNode.NodeName = 'config' then
      begin
        { Left Panel animations }
        Emu_XML.config.Left_Duration := vNode.ChildNodes['left_ani'].Attributes['duration'];
        Emu_XML.config.Left_Limit := vNode.ChildNodes['left_ani'].Text;
        { Right Panel animations }
        Emu_XML.config.Right_Duration := vNode.ChildNodes['right_ani'].Attributes['duration'];
        Emu_XML.config.Right_Limit := vNode.ChildNodes['right_ani'].Text;
      end
      else if vNode.NodeName = 'filters' then
      begin
        { List of filters }
        Emu_XML.filters.main := TStringList.Create;
        Emu_XML.filters.main_num := vNode.ChildNodes['list'].Attributes['num'];

        for vk := 0 to Emu_XML.filters.main_num.ToInteger do
          Emu_XML.filters.main.Add(vNode.ChildNodes['list'].ChildNodes[vk].Text);
      end;
    end;

  end;
end;

procedure Create_Configuration(vMain: TImage);
begin
  Emu_VM_Video.config.main := TPanel.Create(vMain);
  Emu_VM_Video.config.main.name := 'Emu_Config';
  Emu_VM_Video.config.main.Parent := vMain;
  Emu_VM_Video.config.main.SetBounds(((vMain.width / 2) - 350), ((vMain.height / 2) - 300), 700, 630);
  Emu_VM_Video.config.main.Visible := True;

  Emu_VM_Video.config.Blur := TGaussianBlurEffect.Create(Emu_VM_Video.config.main);
  Emu_VM_Video.config.Blur.name := 'Emu_Config_Blur';
  Emu_VM_Video.config.Blur.Parent := Emu_VM_Video.config.main;
  Emu_VM_Video.config.Blur.BlurAmount := 0.6;
  Emu_VM_Video.config.Blur.Enabled := False;

  Emu_VM_Video.config.Shadow := TShadowEffect.Create(Emu_VM_Video.config.main);
  Emu_VM_Video.config.Shadow.name := 'Emu_Config_Shadow';
  Emu_VM_Video.config.Shadow.Parent := Emu_VM_Video.config.main;
  Emu_VM_Video.config.Shadow.Direction := 90;
  Emu_VM_Video.config.Shadow.Distance := 5;
  Emu_VM_Video.config.Shadow.Opacity := 0.8;
  Emu_VM_Video.config.Shadow.ShadowColor := TAlphaColorRec.Darkslategray;
  Emu_VM_Video.config.Shadow.Softness := 0.5;
  Emu_VM_Video.config.Shadow.Enabled := True;

  Emu_VM_Video.config.left := TPanel.Create(Emu_VM_Video.config.main);
  Emu_VM_Video.config.left.name := 'Emu_Config_Left';
  Emu_VM_Video.config.left.Parent := Emu_VM_Video.config.main;
  Emu_VM_Video.config.left.SetBounds(0, 30, 150, 600);
  Emu_VM_Video.config.left.Visible := True;

  Emu_VM_Video.config.right := TPanel.Create(Emu_VM_Video.config.main);
  Emu_VM_Video.config.right.name := 'Emu_Config_Right';
  Emu_VM_Video.config.right.Parent := Emu_VM_Video.config.main;
  Emu_VM_Video.config.right.SetBounds(150, 30, 550, 600);
  Emu_VM_Video.config.right.Visible := True;
end;

procedure Free_Configuarion;
begin
  FreeAndNil(Emu_VM_Video.config.right);
  FreeAndNil(Emu_VM_Video.config.left);
  FreeAndNil(Emu_VM_Video.config.main);
end;

procedure Create_Scene(vMain: TImage; vPath, vImages: String);
begin
  Emu_VM_Video.main := vMain;

  Emu_XML.Images_Path := vImages + 'video\';
  Load_XML_Variables(vPath);

  Emu_VM_Video_Var.Config_Open := False;
  Emu_VM_Video_Var.Filters_Open := False;
  Emu_VM_Video_Var.Game_Mode := False;
  Emu_VM_Video_Var.Gamelist.Loaded := False;
  Emu_VM_Video_Var.Video.Old_Width := 0;

  { Gamelist refresh timer }
  Emu_VM_Video.Gamelist.Gamelist.Timer := TTimer.Create(Emu_VM_Video.main);
  Emu_VM_Video.Gamelist.Gamelist.Timer.name := 'Emu_Gamelist_Timer';
  Emu_VM_Video.Gamelist.Gamelist.Timer.Interval := 500;
  Emu_VM_Video.Gamelist.Gamelist.Timer.OnTimer := Emu_VM_Video_Var.Timer.Gamelist.OnTimer;
  Emu_VM_Video.Gamelist.Gamelist.Timer.Enabled := False;

  { Video refresh timers }
  Emu_VM_Video.Media.Video.Video_Timer_Cont := TTimer.Create(Emu_VM_Video.main);
  Emu_VM_Video.Media.Video.Video_Timer_Cont.name := 'Emu_Video_Timer_Continue';
  Emu_VM_Video.Media.Video.Video_Timer_Cont.Interval := 100;
  Emu_VM_Video.Media.Video.Video_Timer_Cont.OnTimer := Emu_VM_Video_Var.Timer.Video.OnTimer;
  Emu_VM_Video.Media.Video.Video_Timer_Cont.Enabled := True;

  Emu_VM_Video.Blur := TGaussianBlurEffect.Create(Emu_VM_Video.main);
  Emu_VM_Video.Blur.name := 'Main_Blur';
  Emu_VM_Video.Blur.Parent := Emu_VM_Video.main;
  Emu_VM_Video.Blur.BlurAmount := 0;
  Emu_VM_Video.Blur.Enabled := False;

  // Create_Configuration(Emu_VM_Video.Main);

  Emu_VM_Video.right := TImage.Create(Emu_VM_Video.main);
  Emu_VM_Video.right.name := 'Main_Right';
  Emu_VM_Video.right.Parent := Emu_VM_Video.main;
  Emu_VM_Video.right.SetBounds((Emu_VM_Video.main.width / 2), 0, (Emu_VM_Video.main.width / 2), (Emu_VM_Video.main.height));
  Emu_VM_Video.right.Bitmap.LoadFromFile(Emu_XML.Images_Path + Emu_XML.main.Background.image);
  Emu_VM_Video.right.WrapMode := TImageWrapMode.Original;
  Emu_VM_Video.right.BitmapMargins.left := -(Emu_VM_Video.main.width / 2);
  Emu_VM_Video.right.Visible := True;

  Emu_VM_Video.Right_Ani := TFloatAnimation.Create(Emu_VM_Video.right);
  Emu_VM_Video.Right_Ani.name := 'Main_Right_Animation';
  Emu_VM_Video.Right_Ani.Parent := Emu_VM_Video.right;
  Emu_VM_Video.Right_Ani.Duration := Emu_XML.config.Right_Duration.ToSingle;;
  Emu_VM_Video.Right_Ani.Interpolation := TInterpolationType.Cubic;
  Emu_VM_Video.Right_Ani.PropertyName := 'Position.X';
  Emu_VM_Video.Right_Ani.OnFinish := Emu_VM_Video_Var.Ani.config.OnFinish;
  Emu_VM_Video.Right_Ani.Enabled := False;

  Emu_VM_Video.Right_Blur := TBlurEffect.Create(Emu_VM_Video.right);
  Emu_VM_Video.Right_Blur.name := 'Main_Blur_Right';
  Emu_VM_Video.Right_Blur.Parent := Emu_VM_Video.right;
  Emu_VM_Video.Right_Blur.Enabled := False;

  Emu_VM_Video.left := TImage.Create(Emu_VM_Video.main);
  Emu_VM_Video.left.name := 'Main_Left';
  Emu_VM_Video.left.Parent := Emu_VM_Video.main;
  Emu_VM_Video.left.SetBounds(0, 0, (Emu_VM_Video.main.width / 2), (Emu_VM_Video.main.height));
  Emu_VM_Video.left.Bitmap.LoadFromFile(Emu_XML.Images_Path + Emu_XML.main.Background.image);
  Emu_VM_Video.left.WrapMode := TImageWrapMode.Original;
  Emu_VM_Video.left.Visible := True;

  Emu_VM_Video.Left_Ani := TFloatAnimation.Create(Emu_VM_Video.left);
  Emu_VM_Video.Left_Ani.name := 'Main_Left_Animation';
  Emu_VM_Video.Left_Ani.Parent := Emu_VM_Video.left;
  Emu_VM_Video.Left_Ani.Duration := Emu_XML.config.Left_Duration.ToSingle;;
  Emu_VM_Video.Left_Ani.Interpolation := TInterpolationType.Cubic;
  Emu_VM_Video.Left_Ani.PropertyName := 'Position.X';
  Emu_VM_Video.Left_Ani.OnFinish := Emu_VM_Video_Var.Ani.config.OnFinish;
  Emu_VM_Video.Left_Ani.Enabled := False;

  Emu_VM_Video.Left_Blur := TBlurEffect.Create(Emu_VM_Video.left);
  Emu_VM_Video.Left_Blur.name := 'Main_Blur_Left';
  Emu_VM_Video.Left_Blur.Parent := Emu_VM_Video.left;
  Emu_VM_Video.Left_Blur.Enabled := False;

  Emu_VM_Video.Exit := TText.Create(Emu_VM_Video.right);
  Emu_VM_Video.Exit.name := 'Emu_Exit';
  Emu_VM_Video.Exit.Parent := Emu_VM_Video.right;
  Emu_VM_Video.Exit.SetBounds((Emu_VM_Video.right.width - 29), 5, 24, 24);
  Emu_VM_Video.Exit.Font.Family := 'IcoMoon-Free';
  Emu_VM_Video.Exit.Font.Size := 18;
  Emu_VM_Video.Exit.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Exit.Text := #$ea0f;
  Emu_VM_Video.Exit.OnClick := Emu_VM_Video_Mouse.Text.OnMouseClick;
  Emu_VM_Video.Exit.OnMouseEnter := Emu_VM_Video_Mouse.Text.OnMouseEnter;
  Emu_VM_Video.Exit.OnMouseLeave := Emu_VM_Video_Mouse.Text.OnMouseLeave;
  Emu_VM_Video.Exit.Visible := True;

  Emu_VM_Video.Exit_Glow := TGlowEffect.Create(Emu_VM_Video.Exit);
  Emu_VM_Video.Exit_Glow.name := 'Emu_Exit_Glow';
  Emu_VM_Video.Exit_Glow.Parent := Emu_VM_Video.Exit;
  Emu_VM_Video.Exit_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Exit_Glow.Opacity := 0.9;
  Emu_VM_Video.Exit_Glow.Softness := 0.4;
  Emu_VM_Video.Exit_Glow.Enabled := False;

  Emu_VM_Video.Settings := TText.Create(Emu_VM_Video.main);
  Emu_VM_Video.Settings.name := 'Emu_Settings';
  Emu_VM_Video.Settings.Parent := Emu_VM_Video.main;
  Emu_VM_Video.Settings.SetBounds(((Emu_VM_Video.main.width / 2) - 25), (Emu_VM_Video.main.height - 60), 48, 48);
  Emu_VM_Video.Settings.Font.Family := 'IcoMoon-Free';
  Emu_VM_Video.Settings.Font.Size := 48;
  Emu_VM_Video.Settings.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Settings.Text := #$e994;
  Emu_VM_Video.Settings.OnClick := Emu_VM_Video_Mouse.Text.OnMouseClick;
  Emu_VM_Video.Settings.OnMouseEnter := Emu_VM_Video_Mouse.Text.OnMouseEnter;
  Emu_VM_Video.Settings.OnMouseLeave := Emu_VM_Video_Mouse.Text.OnMouseLeave;
  Emu_VM_Video.Settings.Tag := 1;
  Emu_VM_Video.Settings.Visible := True;

  Emu_VM_Video.Settings_Ani := TFloatAnimation.Create(Emu_VM_Video.Settings);
  Emu_VM_Video.Settings_Ani.name := 'Emu_Settings_Ani';
  Emu_VM_Video.Settings_Ani.Parent := Emu_VM_Video.Settings;
  Emu_VM_Video.Settings_Ani.Duration := 4;
  Emu_VM_Video.Settings_Ani.Loop := True;
  Emu_VM_Video.Settings_Ani.PropertyName := 'RotationAngle';
  Emu_VM_Video.Settings_Ani.StartValue := 0;
  Emu_VM_Video.Settings_Ani.StopValue := 360;
  Emu_VM_Video.Settings_Ani.Enabled := True;

  Emu_VM_Video.Settings_Glow := TGlowEffect.Create(Emu_VM_Video.Settings);
  Emu_VM_Video.Settings_Glow.name := 'Emu_Settings_Glow';
  Emu_VM_Video.Settings_Glow.Parent := Emu_VM_Video.Settings;
  Emu_VM_Video.Settings_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Settings_Glow.Opacity := 0.9;
  Emu_VM_Video.Settings_Glow.Softness := 0.4;
  Emu_VM_Video.Settings_Glow.Enabled := False;

  Create_Gamelist;
  Create_Media;
end;

{ Creation of the gamelist part }

procedure Create_Gamelist_Info;
begin
  Emu_VM_Video.Gamelist.Info.Back := TImage.Create(Emu_VM_Video.left);
  Emu_VM_Video.Gamelist.Info.Back.name := 'Emu_Gamelist_Info';
  Emu_VM_Video.Gamelist.Info.Back.Parent := Emu_VM_Video.left;
  Emu_VM_Video.Gamelist.Info.Back.SetBounds(50, 18, 750, 26);
  Emu_VM_Video.Gamelist.Info.Back.WrapMode := TImageWrapMode.Tile;
  Emu_VM_Video.Gamelist.Info.Back.Bitmap.LoadFromFile(Emu_XML.Images_Path + Emu_XML.main.Black_Opacity.image);
  Emu_VM_Video.Gamelist.Info.Back.Visible := True;

  Emu_VM_Video.Gamelist.Info.Games_Count := TText.Create(Emu_VM_Video.Gamelist.Info.Back);
  Emu_VM_Video.Gamelist.Info.Games_Count.name := 'Emu_Gamelist_Info_GamesCount';
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
  Emu_VM_Video.Gamelist.Info.Version.name := 'Emu_Gamelist_Info_Version';
  Emu_VM_Video.Gamelist.Info.Version.Parent := Emu_VM_Video.Gamelist.Info.Back;
  Emu_VM_Video.Gamelist.Info.Version.SetBounds(0, 1, 750, 22);
  Emu_VM_Video.Gamelist.Info.Version.Color := TAlphaColorRec.White;
  Emu_VM_Video.Gamelist.Info.Version.Text := '';
  Emu_VM_Video.Gamelist.Info.Version.Font.Family := 'Tahoma';
  Emu_VM_Video.Gamelist.Info.Version.Font.Style := Emu_VM_Video.Gamelist.Info.Version.Font.Style + [TFontStyle.fsBold];
  Emu_VM_Video.Gamelist.Info.Version.Font.Size := 20;
  Emu_VM_Video.Gamelist.Info.Version.TextSettings.HorzAlign := TTextAlign.Leading;
  Emu_VM_Video.Gamelist.Info.Version.Visible := True;
end;

procedure Create_Gamelist_Games;
var
  vi: Integer;
  viPos: Integer;
begin
  Emu_VM_Video.Gamelist.Games.List := TImage.Create(Emu_VM_Video.left);
  Emu_VM_Video.Gamelist.Games.List.name := 'Emu_Gamelist_Games';
  Emu_VM_Video.Gamelist.Games.List.Parent := Emu_VM_Video.left;
  Emu_VM_Video.Gamelist.Games.List.SetBounds(50, 50, 750, (Emu_VM_Video.left.height - 180));
  Emu_VM_Video.Gamelist.Games.List.WrapMode := TImageWrapMode.Tile;
  Emu_VM_Video.Gamelist.Games.List.Bitmap.LoadFromFile(Emu_XML.Images_Path + Emu_XML.main.Black_Opacity.image);
  Emu_VM_Video.Gamelist.Games.List.Visible := True;

  Emu_VM_Video.Gamelist.Games.Listbox := TVertScrollBox.Create(Emu_VM_Video.Gamelist.Games.List);
  Emu_VM_Video.Gamelist.Games.Listbox.name := 'Emu_Gamelist_Games_Box';
  Emu_VM_Video.Gamelist.Games.Listbox.Parent := Emu_VM_Video.Gamelist.Games.List;
  Emu_VM_Video.Gamelist.Games.Listbox.Align := TAlignLayout.Client;
  Emu_VM_Video.Gamelist.Games.Listbox.ShowScrollBars := False;
  Emu_VM_Video.Gamelist.Games.Listbox.Visible := True;

  for vi := 0 to 20 do
  begin
    Emu_VM_Video.Gamelist.Games.Line[vi].Back := TImage.Create(Emu_VM_Video.Gamelist.Games.Listbox);
    Emu_VM_Video.Gamelist.Games.Line[vi].Back.name := 'Emu_Gamelist_Games_Line_' + vi.ToString;
    Emu_VM_Video.Gamelist.Games.Line[vi].Back.Parent := Emu_VM_Video.Gamelist.Games.Listbox;
    Emu_VM_Video.Gamelist.Games.Line[vi].Back.SetBounds(0, ((vi * 40) + (vi + 10)), (Emu_VM_Video.Gamelist.Games.Listbox.width - 10), 40);
    Emu_VM_Video.Gamelist.Games.Line[vi].Back.Tag := vi;
    Emu_VM_Video.Gamelist.Games.Line[vi].Back.Visible := True;

    Emu_VM_Video.Gamelist.Games.Line[vi].Icon := TImage.Create(Emu_VM_Video.Gamelist.Games.Line[vi].Back);
    Emu_VM_Video.Gamelist.Games.Line[vi].Icon.name := 'Emu_Gamelist_Games_Icon_' + vi.ToString;
    Emu_VM_Video.Gamelist.Games.Line[vi].Icon.Parent := Emu_VM_Video.Gamelist.Games.Line[vi].Back;
    Emu_VM_Video.Gamelist.Games.Line[vi].Icon.SetBounds(4, 2, 38, 38);
    Emu_VM_Video.Gamelist.Games.Line[vi].Icon.Tag := vi;
    Emu_VM_Video.Gamelist.Games.Line[vi].Icon.Visible := True;

    Emu_VM_Video.Gamelist.Games.Line[vi].Text := TText.Create(Emu_VM_Video.Gamelist.Games.Line[vi].Back);
    Emu_VM_Video.Gamelist.Games.Line[vi].Text.name := 'Emu_Gamelist_Games_Game_' + vi.ToString;
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
  Emu_VM_Video.Gamelist.Games.Selection.name := 'Emu_Gamelist_Game_Selection';
  Emu_VM_Video.Gamelist.Games.Selection.Parent := Emu_VM_Video.Gamelist.Games.Line[10].Text;
  Emu_VM_Video.Gamelist.Games.Selection.GlowColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Gamelist.Games.Selection.Opacity := 0.9;
  Emu_VM_Video.Gamelist.Games.Selection.Softness := 0.4;
  Emu_VM_Video.Gamelist.Games.Selection.Enabled := True;

  Emu_VM_Video.Gamelist.Games.Line[10].Back.Bitmap.LoadFromFile(Emu_XML.Images_Path + Emu_XML.main.Selection.image);

  Emu_VM_Video.Gamelist.Games.List_Blur := TBlurEffect.Create(Emu_VM_Video.Gamelist.Games.Listbox);
  Emu_VM_Video.Gamelist.Games.List_Blur.name := 'Emu_Gamelist_Games_List_Blur';
  Emu_VM_Video.Gamelist.Games.List_Blur.Parent := Emu_VM_Video.Gamelist.Games.Listbox;
  Emu_VM_Video.Gamelist.Games.List_Blur.Softness := 0.9;
  Emu_VM_Video.Gamelist.Games.List_Blur.Enabled := False;
end;

procedure Create_Gamelist_Lists;
begin
  Emu_VM_Video.Gamelist.Lists.Back := TImage.Create(Emu_VM_Video.left);
  Emu_VM_Video.Gamelist.Lists.Back.name := 'Emu_Gamelist_Lists';
  Emu_VM_Video.Gamelist.Lists.Back.Parent := Emu_VM_Video.left;
  Emu_VM_Video.Gamelist.Lists.Back.SetBounds(50, 958, 750, 26);
  Emu_VM_Video.Gamelist.Lists.Back.WrapMode := TImageWrapMode.Tile;
  Emu_VM_Video.Gamelist.Lists.Back.Bitmap.LoadFromFile(Emu_XML.Images_Path + Emu_XML.main.Black_Opacity.image);
  Emu_VM_Video.Gamelist.Lists.Back.Visible := True;

  Emu_VM_Video.Gamelist.Lists.Lists := TText.Create(Emu_VM_Video.Gamelist.Lists.Back);
  Emu_VM_Video.Gamelist.Lists.Lists.name := 'Emu_Gamelist_Lists_Icon';
  Emu_VM_Video.Gamelist.Lists.Lists.Parent := Emu_VM_Video.Gamelist.Lists.Back;
  Emu_VM_Video.Gamelist.Lists.Lists.SetBounds(2, 1, 24, 24);
  Emu_VM_Video.Gamelist.Lists.Lists.Font.Family := 'IcoMoon-Free';
  Emu_VM_Video.Gamelist.Lists.Lists.Font.Size := 22;
  Emu_VM_Video.Gamelist.Lists.Lists.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Gamelist.Lists.Lists.Text := #$e904;
  Emu_VM_Video.Gamelist.Lists.Lists.OnClick := Emu_VM_Video_Mouse.Text.OnMouseClick;
  Emu_VM_Video.Gamelist.Lists.Lists.OnMouseEnter := Emu_VM_Video_Mouse.Text.OnMouseEnter;
  Emu_VM_Video.Gamelist.Lists.Lists.OnMouseLeave := Emu_VM_Video_Mouse.Text.OnMouseLeave;
  Emu_VM_Video.Gamelist.Lists.Lists.Visible := True;

  Emu_VM_Video.Gamelist.Lists.Lists_Glow := TGlowEffect.Create(Emu_VM_Video.Gamelist.Lists.Lists);
  Emu_VM_Video.Gamelist.Lists.Lists_Glow.name := 'Emu_Gamelist_Lists_Icon_Glow';
  Emu_VM_Video.Gamelist.Lists.Lists_Glow.Parent := Emu_VM_Video.Gamelist.Lists.Lists;
  Emu_VM_Video.Gamelist.Lists.Lists_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Gamelist.Lists.Lists_Glow.Softness := 0.9;
  Emu_VM_Video.Gamelist.Lists.Lists_Glow.Enabled := False;

  Emu_VM_Video.Gamelist.Lists.Lists_Text := TText.Create(Emu_VM_Video.Gamelist.Lists.Back);
  Emu_VM_Video.Gamelist.Lists.Lists_Text.name := 'Mame_Gamelist_Lists_Text';
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
  Emu_VM_Video.Gamelist.filters.Back := TImage.Create(Emu_VM_Video.left);
  Emu_VM_Video.Gamelist.filters.Back.name := 'Emu_Gamelist_Filters';
  Emu_VM_Video.Gamelist.filters.Back.Parent := Emu_VM_Video.left;
  Emu_VM_Video.Gamelist.filters.Back.SetBounds(50, 992, 750, 26);
  Emu_VM_Video.Gamelist.filters.Back.WrapMode := TImageWrapMode.Tile;
  Emu_VM_Video.Gamelist.filters.Back.Bitmap.LoadFromFile(Emu_XML.Images_Path + Emu_XML.main.Black_Opacity.image);
  Emu_VM_Video.Gamelist.filters.Back.Visible := True;

  Emu_VM_Video.Gamelist.filters.Filter := TText.Create(Emu_VM_Video.Gamelist.filters.Back);
  Emu_VM_Video.Gamelist.filters.Filter.name := 'Emu_Gamelist_Filters_Icon';
  Emu_VM_Video.Gamelist.filters.Filter.Parent := Emu_VM_Video.Gamelist.filters.Back;
  Emu_VM_Video.Gamelist.filters.Filter.SetBounds(2, 1, 24, 24);
  Emu_VM_Video.Gamelist.filters.Filter.Font.Family := 'IcoMoon-Free';
  Emu_VM_Video.Gamelist.filters.Filter.Font.Size := 22;
  Emu_VM_Video.Gamelist.filters.Filter.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Gamelist.filters.Filter.Text := #$ea5b;
  Emu_VM_Video.Gamelist.filters.Filter.OnClick := Emu_VM_Video_Mouse.Text.OnMouseClick;
  Emu_VM_Video.Gamelist.filters.Filter.OnMouseEnter := Emu_VM_Video_Mouse.Text.OnMouseEnter;
  Emu_VM_Video.Gamelist.filters.Filter.OnMouseLeave := Emu_VM_Video_Mouse.Text.OnMouseLeave;
  Emu_VM_Video.Gamelist.filters.Filter.Visible := True;

  Emu_VM_Video.Gamelist.filters.Filter_Glow := TGlowEffect.Create(Emu_VM_Video.Gamelist.filters.Filter);
  Emu_VM_Video.Gamelist.filters.Filter_Glow.name := 'Mame_Gamelist_Filters_Icon_Glow';
  Emu_VM_Video.Gamelist.filters.Filter_Glow.Parent := Emu_VM_Video.Gamelist.filters.Filter;
  Emu_VM_Video.Gamelist.filters.Filter_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Gamelist.filters.Filter_Glow.Softness := 0.9;
  Emu_VM_Video.Gamelist.filters.Filter_Glow.Enabled := False;

  Emu_VM_Video.Gamelist.filters.Filter_Text := TText.Create(Emu_VM_Video.Gamelist.filters.Back);
  Emu_VM_Video.Gamelist.filters.Filter_Text.name := 'Mame_Gamelist_Filters_Text';
  Emu_VM_Video.Gamelist.filters.Filter_Text.Parent := Emu_VM_Video.Gamelist.filters.Back;
  Emu_VM_Video.Gamelist.filters.Filter_Text.SetBounds(40, 1, 710, 22);
  Emu_VM_Video.Gamelist.filters.Filter_Text.Color := TAlphaColorRec.White;
  Emu_VM_Video.Gamelist.filters.Filter_Text.Font.Size := 20;
  Emu_VM_Video.Gamelist.filters.Filter_Text.Text := 'All';
  Emu_VM_Video.Gamelist.filters.Filter_Text.TextSettings.HorzAlign := TTextAlign.Leading;
  Emu_VM_Video.Gamelist.filters.Filter_Text.Visible := True;
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

{ Creation of the media part }

procedure Create_Media_Bar;
begin
  Emu_VM_Video.Media.Bar.Back := TImage.Create(Emu_VM_Video.right);
  Emu_VM_Video.Media.Bar.Back.name := 'Emu_Media_Bar';
  Emu_VM_Video.Media.Bar.Back.Parent := Emu_VM_Video.right;
  Emu_VM_Video.Media.Bar.Back.SetBounds(50, 50, 750, (Emu_VM_Video.right.height - 180));
  Emu_VM_Video.Media.Bar.Back.WrapMode := TImageWrapMode.Tile;
  Emu_VM_Video.Media.Bar.Back.Bitmap.LoadFromFile(Emu_XML.Images_Path + Emu_XML.main.Black_Opacity.image);
  Emu_VM_Video.Media.Bar.Back.Visible := True;

  Emu_VM_Video.Media.Bar.Favorites := TText.Create(Emu_VM_Video.Media.Bar.Back);
  Emu_VM_Video.Media.Bar.Favorites.name := 'Emu_Media_Bar_Favorites';
  Emu_VM_Video.Media.Bar.Favorites.Parent := Emu_VM_Video.Media.Bar.Back;
  Emu_VM_Video.Media.Bar.Favorites.SetBounds(2, 1, 24, 24);
  Emu_VM_Video.Media.Bar.Favorites.Font.Family := 'IcoMoon-Free';
  Emu_VM_Video.Media.Bar.Favorites.Font.Size := 22;
  Emu_VM_Video.Media.Bar.Favorites.TextSettings.FontColor := TAlphaColorRec.Grey;
  Emu_VM_Video.Media.Bar.Favorites.Text := #$e9d9;
  Emu_VM_Video.Media.Bar.Favorites.OnClick := Emu_VM_Video_Mouse.Text.OnMouseClick;
  Emu_VM_Video.Media.Bar.Favorites.OnMouseEnter := Emu_VM_Video_Mouse.Text.OnMouseEnter;
  Emu_VM_Video.Media.Bar.Favorites.OnMouseLeave := Emu_VM_Video_Mouse.Text.OnMouseLeave;
  Emu_VM_Video.Media.Bar.Favorites.Visible := True;

  Emu_VM_Video.Media.Bar.Favorites_Glow := TGlowEffect.Create(Emu_VM_Video.Media.Bar.Favorites);
  Emu_VM_Video.Media.Bar.Favorites_Glow.name := 'Emu_Media_Bar_Favorites_Glow';
  Emu_VM_Video.Media.Bar.Favorites_Glow.Parent := Emu_VM_Video.Media.Bar.Favorites;
  Emu_VM_Video.Media.Bar.Favorites_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Media.Bar.Favorites_Glow.Softness := 0.9;
  Emu_VM_Video.Media.Bar.Favorites_Glow.Enabled := False;
end;

procedure Create_Media_Video;
begin
  Emu_VM_Video.Media.Video.Back := TImage.Create(Emu_VM_Video.right);
  Emu_VM_Video.Media.Video.Back.name := 'Emu_Media_Video';
  Emu_VM_Video.Media.Video.Back.Parent := Emu_VM_Video.right;
  Emu_VM_Video.Media.Video.Back.SetBounds(100, 150, 650, 600);
  Emu_VM_Video.Media.Video.Back.Bitmap.LoadFromFile(Emu_XML.Images_Path + Emu_XML.main.Black.image);
  Emu_VM_Video.Media.Video.Back.Visible := True;

{$IFDEF WIN32}
  libvlc_dynamic_dll_init_with_path('C:\Program Files (x86)\VideoLAN\VLC');
{$ENDIF}
  if (libvlc_dynamic_dll_error <> '') then
  begin
    ShowMessage(libvlc_dynamic_dll_error);
    Exit;
  end;

  Emu_VM_Video.Media.Video.Video := TFmxPasLibVlcPlayer.Create(Emu_VM_Video.Media.Video.Back);
  Emu_VM_Video.Media.Video.Video.name := 'Mame_Snap_Video';
  Emu_VM_Video.Media.Video.Video.Parent := Emu_VM_Video.Media.Video.Back;
  Emu_VM_Video.Media.Video.Video.Align := TAlignLayout.Client;
  Emu_VM_Video.Media.Video.Video.SetVideoAspectRatio('4:3');
  Emu_VM_Video.Media.Video.Video.WrapMode := TImageWrapMode.Stretch;
  Emu_VM_Video.Media.Video.Video.Visible := True;

  Emu_VM_Video.Media.Video.Video_Timer_Cont := TTimer.Create(Emu_VM_Video.Media.Video.Back);
  Emu_VM_Video.Media.Video.Video_Timer_Cont.Interval := 100;
  Emu_VM_Video.Media.Video.Video_Timer_Cont.OnTimer := Emu_VM_Video_Var.Timer.Video.OnTimer;
  Emu_VM_Video.Media.Video.Video_Timer_Cont.Enabled := False;

  Emu_VM_Video.Media.Video.Game_Info.Layout := TLayout.Create(Emu_VM_Video.Media.Video.Back);
  Emu_VM_Video.Media.Video.Game_Info.Layout.name := 'Mame_Media_Players';
  Emu_VM_Video.Media.Video.Game_Info.Layout.Parent := Emu_VM_Video.Media.Video.Back;
  Emu_VM_Video.Media.Video.Game_Info.Layout.SetBounds(0, -50, Emu_VM_Video.Media.Video.Back.width, 50);
  Emu_VM_Video.Media.Video.Game_Info.Layout.Visible := True;

  Emu_VM_Video.Media.Video.Game_Info.Players := TText.Create(Emu_VM_Video.Media.Video.Game_Info.Layout);
  Emu_VM_Video.Media.Video.Game_Info.Players.name := 'Mame_Media_Players';
  Emu_VM_Video.Media.Video.Game_Info.Players.Parent := Emu_VM_Video.Media.Video.Game_Info.Layout;
  Emu_VM_Video.Media.Video.Game_Info.Players.SetBounds(2, 5, 40, 50);
  Emu_VM_Video.Media.Video.Game_Info.Players.Font.Family := 'IcoMoon-Free';
  Emu_VM_Video.Media.Video.Game_Info.Players.Font.Size := 24;
  Emu_VM_Video.Media.Video.Game_Info.Players.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Video.Media.Video.Game_Info.Players.Text := #$e972;
  Emu_VM_Video.Media.Video.Game_Info.Players.Visible := True;

  Emu_VM_Video.Media.Video.Game_Info.Players_Value := TText.Create(Emu_VM_Video.Media.Video.Game_Info.Layout);
  Emu_VM_Video.Media.Video.Game_Info.Players_Value.name := 'Mame_Media_Players_Value';
  Emu_VM_Video.Media.Video.Game_Info.Players_Value.Parent := Emu_VM_Video.Media.Video.Game_Info.Layout;
  Emu_VM_Video.Media.Video.Game_Info.Players_Value.SetBounds(42, 5, 500, 50);
  Emu_VM_Video.Media.Video.Game_Info.Players_Value.Font.Family := 'Tahome';
  Emu_VM_Video.Media.Video.Game_Info.Players_Value.Font.Size := 18;
  Emu_VM_Video.Media.Video.Game_Info.Players_Value.TextSettings.FontColor := TAlphaColorRec.White;
  Emu_VM_Video.Media.Video.Game_Info.Players_Value.HorzTextAlign := TTextAlign.Leading;
  Emu_VM_Video.Media.Video.Game_Info.Players_Value.Text := '';
  Emu_VM_Video.Media.Video.Game_Info.Players_Value.Visible := True;

  Emu_VM_Video.Media.Video.Game_Info.Favorite := TText.Create(Emu_VM_Video.Media.Video.Game_Info.Layout);
  Emu_VM_Video.Media.Video.Game_Info.Favorite.name := 'Mame_Media_Favorite';
  Emu_VM_Video.Media.Video.Game_Info.Favorite.Parent := Emu_VM_Video.Media.Video.Game_Info.Layout;
  Emu_VM_Video.Media.Video.Game_Info.Favorite.SetBounds(Emu_VM_Video.Media.Video.Game_Info.Layout.width - 60, 5, 60, 50);
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
