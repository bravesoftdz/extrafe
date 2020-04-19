unit uView_Mode_Default;

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
  FMX.Edit,
  FMX.Graphics,
  FmxPasLibVlcPlayerUnit,
  PasLibVlcUnit,
  Xml.xmldom,
  Xml.XMLIntf,
  Xml.adomxmldom,
  Xml.XMLDoc,
  Xml.omnixmldom,
  FireDAC.Comp.Client;

{ Creation }

function get_view_name: String;

{ Create Scene }
procedure Create_Scene(vUser_Num: Integer; vQuery: TFDQuery; vMain: TImage; vPath, vImages, vSounds: String);

{ Create the configuration standard part }
procedure Create_Configuration(vMain: TImage);
procedure Free_Configuarion;
procedure Set_Panels_Configurtaion(vMain, vLeft, vRight: TPanel);

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

{ Load extra files }
procedure Load_Files;

{Start Default ViewMode}
procedure Start_View_Mode(vSelected, vGames_Count: Integer; vList_Games, vList_Roms, vList_Path: TStringlist);

var
  vXML: IXMLDocument;
  vRoot, vNode: IXMLNode;
  vMain_Upper: TBitmap;

implementation

uses
  uLoad_AllTypes,
  uDB,
  uDB_AUser,
  uView_Mode_Default_Actions,
  uView_Mode_Default_Game,
  uView_Mode_Default_Sounds,
  uView_Mode_Default_AllTypes,
  uView_Mode_Default_Mouse;

function get_view_name: String;
begin
  if extrafe.prog.State = 'emu_mame' then
    Result := uDB_AUser.Local.EMULATORS.Arcade_D.Mame_D.View_Mode + '\';
end;

procedure Load_XML_Variables(vPath: String);
var
  vi, vk: Integer;
  vNode_Temp: IXMLNode;

begin
  vXML := TXMLDocument.Create('');
  vXML.LoadFromFile(vPath + 'default.xml');
  if vXML.IsEmptyDoc = False then
  begin
    vRoot := vXML.DocumentElement;
    if vRoot.HasAttribute('name') then
      Emu_XML.emu.name := vRoot.Attributes['name'];
    if vRoot.HasAttribute('type') then
      Emu_XML.emu.vtype := vRoot.Attributes['type'];
    if vRoot.HasAttribute('exe') then
      Emu_XML.emu.exe := vRoot.Attributes['exe'];
    if vRoot.HasAttribute('path') then
      Emu_XML.emu.path := vRoot.Attributes['path'];

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
      end
      else if vNode.NodeName = 'lists' then
      begin
        { lists path, num }
        Emu_XML.lists.path := vNode.Attributes['path'];
        Emu_XML.lists.num := vNode.Attributes['num'];

        for vk := 0 to Emu_XML.lists.num.ToInteger do
        begin
          Emu_XML.lists.list[vk].name := vNode.ChildNodes[vk].Attributes['name'];
          Emu_XML.lists.list[vk].path := vNode.ChildNodes[vk].Attributes['path'];

          Emu_XML.lists.list[vk].logo := vNode.ChildNodes[vk].ChildNodes[0].Text;
          Emu_XML.lists.list[vk].pcb := vNode.ChildNodes[vk].ChildNodes[1].Text;
        end;
      end
      else if vNode.NodeName = 'game' then
      begin
        { Game variables }
        Emu_XML.game.games := vNode.ChildNodes['games'].Text;
        Emu_XML.game.play_count_refresh_status := vNode.ChildNodes['refresh_play_count'].Text;
        Emu_XML.game.favorites := vNode.ChildNodes['favorites'].Text;
        { Game Menu Icons Variables }
        vNode_Temp := vNode.ChildNodes[3];
        if vNode_Temp.NodeName = 'icons' then
        begin
          for vk := 0 to vNode_Temp.ChildNodes.Count - 1 do
          begin
            if vNode_Temp.ChildNodes[vk].NodeName = 'icon' then
            begin
              if vNode_Temp.ChildNodes[vk].Attributes['name'] = 'play' then
              begin
                Emu_XML.game.menu.play.image := vNode_Temp.ChildNodes[vk].Text;
                Emu_XML.game.menu.play.width := vNode_Temp.ChildNodes[vk].Attributes['width'];
                Emu_XML.game.menu.play.height := vNode_Temp.ChildNodes[vk].Attributes['height'];
              end
              else if vNode_Temp.ChildNodes[vk].Attributes['name'] = 'open_folder' then
              begin
                Emu_XML.game.menu.open_folder.image := vNode_Temp.ChildNodes[vk].Text;
                Emu_XML.game.menu.open_folder.width := vNode_Temp.ChildNodes[vk].Attributes['width'];
                Emu_XML.game.menu.open_folder.height := vNode_Temp.ChildNodes[vk].Attributes['height'];
              end
              else if vNode_Temp.ChildNodes[vk].Attributes['name'] = 'fullscreen' then
              begin
                Emu_XML.game.menu.fullscreen.image := vNode_Temp.ChildNodes[vk].Text;
                Emu_XML.game.menu.fullscreen.width := vNode_Temp.ChildNodes[vk].Attributes['width'];
                Emu_XML.game.menu.fullscreen.height := vNode_Temp.ChildNodes[vk].Attributes['height'];
              end
              else if vNode_Temp.ChildNodes[vk].Attributes['name'] = 'favorite' then
              begin
                Emu_XML.game.menu.favorite.image := vNode_Temp.ChildNodes[vk].Text;
                Emu_XML.game.menu.favorite.width := vNode_Temp.ChildNodes[vk].Attributes['width'];
                Emu_XML.game.menu.favorite.height := vNode_Temp.ChildNodes[vk].Attributes['height'];
              end
              else if vNode_Temp.ChildNodes[vk].Attributes['name'] = 'list' then
              begin
                Emu_XML.game.menu.list.image := vNode_Temp.ChildNodes[vk].Text;
                Emu_XML.game.menu.list.width := vNode_Temp.ChildNodes[vk].Attributes['width'];
                Emu_XML.game.menu.list.height := vNode_Temp.ChildNodes[vk].Attributes['height'];
              end
            end;
          end;
        end;
      end;
    end;

  end;
end;

procedure Create_Configuration(vMain: TImage);
begin
  Emu_VM_Default.config.main := TPanel.Create(vMain);
  Emu_VM_Default.config.main.name := 'Emu_Config';
  Emu_VM_Default.config.main.Parent := vMain;
  Emu_VM_Default.config.main.SetBounds(((vMain.width / 2) - 350), ((vMain.height / 2) - 300), 700, 630);
  Emu_VM_Default.config.main.Visible := True;

  Emu_VM_Default.config.Blur := TGaussianBlurEffect.Create(Emu_VM_Default.config.main);
  Emu_VM_Default.config.Blur.name := 'Emu_Config_Blur';
  Emu_VM_Default.config.Blur.Parent := Emu_VM_Default.config.main;
  Emu_VM_Default.config.Blur.BlurAmount := 0.6;
  Emu_VM_Default.config.Blur.Enabled := False;

  Emu_VM_Default.config.Shadow := TShadowEffect.Create(Emu_VM_Default.config.main);
  Emu_VM_Default.config.Shadow.name := 'Emu_Config_Shadow';
  Emu_VM_Default.config.Shadow.Parent := Emu_VM_Default.config.main;
  Emu_VM_Default.config.Shadow.Direction := 90;
  Emu_VM_Default.config.Shadow.Distance := 5;
  Emu_VM_Default.config.Shadow.Opacity := 0.8;
  Emu_VM_Default.config.Shadow.ShadowColor := TAlphaColorRec.Darkslategray;
  Emu_VM_Default.config.Shadow.Softness := 0.5;
  Emu_VM_Default.config.Shadow.Enabled := True;

  Emu_VM_Default.config.left := TPanel.Create(Emu_VM_Default.config.main);
  Emu_VM_Default.config.left.name := 'Emu_Config_Left';
  Emu_VM_Default.config.left.Parent := Emu_VM_Default.config.main;
  Emu_VM_Default.config.left.SetBounds(0, 30, 150, 600);
  Emu_VM_Default.config.left.Visible := True;

  Emu_VM_Default.config.right := TPanel.Create(Emu_VM_Default.config.main);
  Emu_VM_Default.config.right.name := 'Emu_Config_Right';
  Emu_VM_Default.config.right.Parent := Emu_VM_Default.config.main;
  Emu_VM_Default.config.right.SetBounds(150, 30, 550, 600);
  Emu_VM_Default.config.right.Visible := True;

end;

procedure Free_Configuarion;
begin
  FreeAndNil(Emu_VM_Default.config.right);
  FreeAndNil(Emu_VM_Default.config.left);
  FreeAndNil(Emu_VM_Default.config.main);
end;

procedure Set_Panels_Configurtaion(vMain, vLeft, vRight: TPanel);
begin
  vMain := Emu_VM_Default.config.main;
  vLeft := Emu_VM_Default.config.left;
  vRight := Emu_VM_Default.config.right;
end;

procedure Create_Scene(vUser_Num: Integer; vQuery: TFDQuery; vMain: TImage; vPath, vImages, vSounds: String);
begin
  Emu_VM_Default.main := vMain;

  Load_XML_Variables(vPath);
  Emu_XML.Images_Path := vImages + get_view_name;
  Emu_XML.Sounds_Path := vSounds + get_view_name;

  { Load all view mode (video) sounds }
  uView_Mode_Default_Sounds.Load;

  { Set up the start variables }
  Emu_VM_Default_Var.Query := vQuery;
  Emu_VM_Default_Var.User_Num := vUser_Num;
  Emu_VM_Default_Var.Config_Open := False;
  Emu_VM_Default_Var.Filters_Open := False;
  Emu_VM_Default_Var.Lists_Open := False;
  Emu_VM_Default_Var.lists.Selected := 'None';
  Emu_VM_Default_Var.Game_Mode := False;
  Emu_VM_Default_Var.Gamelist.Loaded := False;
  Emu_VM_Default_Var.Favorites_Open := False;
  Emu_VM_Default_Var.Search_Open := False;
  Emu_VM_Default_Var.Video.Old_Width := 0;
  Emu_VM_Default_Var.Video.Times := 0;
  Emu_VM_Default_Var.favorites.Count := uDB.Query_Count(Emu_VM_Default_Var.Query, Emu_XML.game.favorites,
    'fav_id_' + Emu_VM_Default_Var.User_Num.ToString, '1');
  if Emu_VM_Default_Var.Favorites_Open then
    Emu_VM_Default_Var.favorites.game_is := True;

  { Gamelist refresh timer }
  Emu_VM_Default.Gamelist.Gamelist.Timer := TTimer.Create(Emu_VM_Default.main);
  Emu_VM_Default.Gamelist.Gamelist.Timer.name := 'Emu_Gamelist_Timer';
  Emu_VM_Default.Gamelist.Gamelist.Timer.Interval := 500;
  Emu_VM_Default.Gamelist.Gamelist.Timer.OnTimer := Emu_VM_Default_Var.Timer.Gamelist.OnTimer;
  Emu_VM_Default.Gamelist.Gamelist.Timer.Enabled := False;

  { Video refresh timers }
  Emu_VM_Default.Media.Video.Video_Timer_Cont := TTimer.Create(Emu_VM_Default.main);
  Emu_VM_Default.Media.Video.Video_Timer_Cont.name := 'Emu_Video_Timer_Continue';
  Emu_VM_Default.Media.Video.Video_Timer_Cont.Interval := 100;
  Emu_VM_Default.Media.Video.Video_Timer_Cont.OnTimer := Emu_VM_Default_Var.Timer.Video.OnTimer;
  Emu_VM_Default.Media.Video.Video_Timer_Cont.Enabled := True;

  Emu_VM_Default.Blur := TGaussianBlurEffect.Create(Emu_VM_Default.main);
  Emu_VM_Default.Blur.name := 'Main_Blur';
  Emu_VM_Default.Blur.Parent := Emu_VM_Default.main;
  Emu_VM_Default.Blur.BlurAmount := 0;
  Emu_VM_Default.Blur.Enabled := False;

  Emu_VM_Default.main.Bitmap.LoadFromFile(Emu_XML.Images_Path + Emu_XML.main.Background.image);
  vMain_Upper := Emu_VM_Default.main.Bitmap;

  Emu_VM_Default.main_upper := TImage.Create(Emu_VM_Default.main);
  Emu_VM_Default.main_upper.name := 'Emu_Main_Upper';
  Emu_VM_Default.main_upper.Parent := Emu_VM_Default.main;
  Emu_VM_Default.main_upper.Align := TAlignLayout.Client;
  Emu_VM_Default.main_upper.WrapMode := TImageWrapMode.Center;
  Emu_VM_Default.main_upper.Visible := True;

  Emu_VM_Default.main_upper_ani := TFloatAnimation.Create(Emu_VM_Default.main_upper);
  Emu_VM_Default.main_upper_ani.name := 'Emu_Main_Upper_Animation';
  Emu_VM_Default.main_upper_ani.Parent := Emu_VM_Default.main_upper;
  Emu_VM_Default.main_upper_ani.PropertyName := 'Opacity';
  Emu_VM_Default.main_upper_ani.OnFinish := uView_Mode_Default_AllTypes.vAll_ANI.OnFinish;
  Emu_VM_Default.main_upper_ani.Enabled := False;

  Emu_VM_Default.right_layout := TLayout.Create(Emu_VM_Default.main);
  Emu_VM_Default.right_layout.name := 'Emu_Right_Layout';
  Emu_VM_Default.right_layout.Parent := Emu_VM_Default.main;
  Emu_VM_Default.right_layout.SetBounds((Emu_VM_Default.main.width / 2), 0, (Emu_VM_Default.main.width / 2), (Emu_VM_Default.main.height));
  Emu_VM_Default.right_layout.Visible := True;

  Emu_VM_Default.right := TImage.Create(Emu_VM_Default.right_layout);
  Emu_VM_Default.right.name := 'Main_Right';
  Emu_VM_Default.right.Parent := Emu_VM_Default.right_layout;
  Emu_VM_Default.right.Align := TAlignLayout.Client;
  Emu_VM_Default.right.WrapMode := TImageWrapMode.Original;
  Emu_VM_Default.right.BitmapMargins.left := -(Emu_VM_Default.main.width / 2);
  Emu_VM_Default.right.Visible := True;

  Emu_VM_Default.Right_Ani := TFloatAnimation.Create(Emu_VM_Default.right_layout);
  Emu_VM_Default.Right_Ani.name := 'Main_Right_Animation';
  Emu_VM_Default.Right_Ani.Parent := Emu_VM_Default.right_layout;
  Emu_VM_Default.Right_Ani.Duration := Emu_XML.config.Right_Duration.ToSingle;;
  Emu_VM_Default.Right_Ani.Interpolation := TInterpolationType.Cubic;
  Emu_VM_Default.Right_Ani.PropertyName := 'Position.X';
  Emu_VM_Default.Right_Ani.OnFinish := Emu_VM_Default_Var.Ani.config.OnFinish;
  Emu_VM_Default.Right_Ani.Enabled := False;

  Emu_VM_Default.Right_Ani_Opacity := TFloatAnimation.Create(Emu_VM_Default.right);
  Emu_VM_Default.Right_Ani_Opacity.name := 'Main_Right_Animation_Opacity';
  Emu_VM_Default.Right_Ani_Opacity.Parent := Emu_VM_Default.right;
  Emu_VM_Default.Right_Ani_Opacity.Duration := 1;
  Emu_VM_Default.Right_Ani_Opacity.Interpolation := TInterpolationType.Cubic;
  Emu_VM_Default.Right_Ani_Opacity.PropertyName := 'Opacity';
  Emu_VM_Default.Right_Ani_Opacity.StartValue := 0;
  Emu_VM_Default.Right_Ani_Opacity.StopValue := 1;
  Emu_VM_Default.Right_Ani_Opacity.Enabled := False;

  Emu_VM_Default.Right_Blur := TBlurEffect.Create(Emu_VM_Default.right);
  Emu_VM_Default.Right_Blur.name := 'Main_Blur_Right';
  Emu_VM_Default.Right_Blur.Parent := Emu_VM_Default.right;
  Emu_VM_Default.Right_Blur.Enabled := False;

  Emu_VM_Default.left_layout := TLayout.Create(Emu_VM_Default.main);
  Emu_VM_Default.left_layout.name := 'Emu_Left_Layout';
  Emu_VM_Default.left_layout.Parent := Emu_VM_Default.main;
  Emu_VM_Default.left_layout.SetBounds(0, 0, (Emu_VM_Default.main.width / 2), (Emu_VM_Default.main.height));
  Emu_VM_Default.left_layout.Visible := True;

  Emu_VM_Default.left := TImage.Create(Emu_VM_Default.left_layout);
  Emu_VM_Default.left.name := 'Main_Left';
  Emu_VM_Default.left.Parent := Emu_VM_Default.left_layout;
  Emu_VM_Default.left.Align := TAlignLayout.Client;
  Emu_VM_Default.left.WrapMode := TImageWrapMode.Original;
  Emu_VM_Default.left.Visible := True;

  Emu_VM_Default.Left_Ani := TFloatAnimation.Create(Emu_VM_Default.left_layout);
  Emu_VM_Default.Left_Ani.name := 'Main_Left_Animation';
  Emu_VM_Default.Left_Ani.Parent := Emu_VM_Default.left_layout;
  Emu_VM_Default.Left_Ani.Duration := Emu_XML.config.Left_Duration.ToSingle;;
  Emu_VM_Default.Left_Ani.Interpolation := TInterpolationType.Cubic;
  Emu_VM_Default.Left_Ani.PropertyName := 'Position.X';
  Emu_VM_Default.Left_Ani.OnFinish := Emu_VM_Default_Var.Ani.config.OnFinish;
  Emu_VM_Default.Left_Ani.Enabled := False;

  Emu_VM_Default.Left_Ani_Opacity := TFloatAnimation.Create(Emu_VM_Default.left);
  Emu_VM_Default.Left_Ani_Opacity.name := 'Main_Left_Animation_Opacity';
  Emu_VM_Default.Left_Ani_Opacity.Parent := Emu_VM_Default.left;
  Emu_VM_Default.Left_Ani_Opacity.Duration := 1;
  Emu_VM_Default.Left_Ani_Opacity.Interpolation := TInterpolationType.Cubic;
  Emu_VM_Default.Left_Ani_Opacity.PropertyName := 'Opacity';
  Emu_VM_Default.Left_Ani_Opacity.StartValue := 0;
  Emu_VM_Default.Left_Ani_Opacity.StopValue := 1;
  Emu_VM_Default.Left_Ani_Opacity.Enabled := False;

  Emu_VM_Default.Left_Blur := TBlurEffect.Create(Emu_VM_Default.left);
  Emu_VM_Default.Left_Blur.name := 'Main_Blur_Left';
  Emu_VM_Default.Left_Blur.Parent := Emu_VM_Default.left;
  Emu_VM_Default.Left_Blur.Enabled := False;

  Emu_VM_Default.Exit := TText.Create(Emu_VM_Default.right);
  Emu_VM_Default.Exit.name := 'Emu_Exit';
  Emu_VM_Default.Exit.Parent := Emu_VM_Default.right;
  Emu_VM_Default.Exit.SetBounds((Emu_VM_Default.right.width - 29), 5, 24, 24);
  Emu_VM_Default.Exit.Font.Family := 'IcoMoon-Free';
  Emu_VM_Default.Exit.Font.Size := 18;
  Emu_VM_Default.Exit.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Default.Exit.Text := #$ea0f;
  Emu_VM_Default.Exit.OnClick := Emu_VM_Default_Mouse.Text.OnMouseClick;
  Emu_VM_Default.Exit.OnMouseEnter := Emu_VM_Default_Mouse.Text.OnMouseEnter;
  Emu_VM_Default.Exit.OnMouseLeave := Emu_VM_Default_Mouse.Text.OnMouseLeave;
  Emu_VM_Default.Exit.Visible := True;

  Emu_VM_Default.Exit_Glow := TGlowEffect.Create(Emu_VM_Default.Exit);
  Emu_VM_Default.Exit_Glow.name := 'Emu_Exit_Glow';
  Emu_VM_Default.Exit_Glow.Parent := Emu_VM_Default.Exit;
  Emu_VM_Default.Exit_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Default.Exit_Glow.Opacity := 0.9;
  Emu_VM_Default.Exit_Glow.Softness := 0.4;
  Emu_VM_Default.Exit_Glow.Enabled := False;

  Emu_VM_Default.Settings := TText.Create(Emu_VM_Default.main);
  Emu_VM_Default.Settings.name := 'Emu_Settings';
  Emu_VM_Default.Settings.Parent := Emu_VM_Default.main;
  Emu_VM_Default.Settings.SetBounds(((Emu_VM_Default.main.width / 2) - 25), (Emu_VM_Default.main.height - 60), 48, 48);
  Emu_VM_Default.Settings.Font.Family := 'IcoMoon-Free';
  Emu_VM_Default.Settings.Font.Size := 48;
  Emu_VM_Default.Settings.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Default.Settings.Text := #$e994;
  Emu_VM_Default.Settings.OnClick := Emu_VM_Default_Mouse.Text.OnMouseClick;
  Emu_VM_Default.Settings.OnMouseEnter := Emu_VM_Default_Mouse.Text.OnMouseEnter;
  Emu_VM_Default.Settings.OnMouseLeave := Emu_VM_Default_Mouse.Text.OnMouseLeave;
  Emu_VM_Default.Settings.Tag := 1;
  Emu_VM_Default.Settings.Visible := True;

  Emu_VM_Default.Settings_Ani := TFloatAnimation.Create(Emu_VM_Default.Settings);
  Emu_VM_Default.Settings_Ani.name := 'Emu_Settings_Ani';
  Emu_VM_Default.Settings_Ani.Parent := Emu_VM_Default.Settings;
  Emu_VM_Default.Settings_Ani.Duration := 4;
  Emu_VM_Default.Settings_Ani.Loop := True;
  Emu_VM_Default.Settings_Ani.PropertyName := 'RotationAngle';
  Emu_VM_Default.Settings_Ani.StartValue := 0;
  Emu_VM_Default.Settings_Ani.StopValue := 360;
  Emu_VM_Default.Settings_Ani.Enabled := True;

  Emu_VM_Default.Settings_Glow := TGlowEffect.Create(Emu_VM_Default.Settings);
  Emu_VM_Default.Settings_Glow.name := 'Emu_Settings_Glow';
  Emu_VM_Default.Settings_Glow.Parent := Emu_VM_Default.Settings;
  Emu_VM_Default.Settings_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Default.Settings_Glow.Opacity := 0.9;
  Emu_VM_Default.Settings_Glow.Softness := 0.4;
  Emu_VM_Default.Settings_Glow.Enabled := False;

  Create_Gamelist;
  Create_Media;
  Favorite_Box;

  Load_Files;
end;

{ Creation of the gamelist part }

procedure Create_Gamelist_Info;
begin
  Emu_VM_Default.Gamelist.Info.Back := TImage.Create(Emu_VM_Default.left);
  Emu_VM_Default.Gamelist.Info.Back.name := 'Emu_Gamelist_Info';
  Emu_VM_Default.Gamelist.Info.Back.Parent := Emu_VM_Default.left;
  Emu_VM_Default.Gamelist.Info.Back.SetBounds(50, 18, 750, 26);
  Emu_VM_Default.Gamelist.Info.Back.WrapMode := TImageWrapMode.Tile;
  Emu_VM_Default.Gamelist.Info.Back.Bitmap.LoadFromFile(Emu_XML.Images_Path + Emu_XML.main.Black_Opacity.image);
  Emu_VM_Default.Gamelist.Info.Back.Visible := True;

  Emu_VM_Default.Gamelist.Info.Games_Count := TText.Create(Emu_VM_Default.Gamelist.Info.Back);
  Emu_VM_Default.Gamelist.Info.Games_Count.name := 'Emu_Gamelist_Info_GamesCount';
  Emu_VM_Default.Gamelist.Info.Games_Count.Parent := Emu_VM_Default.Gamelist.Info.Back;
  Emu_VM_Default.Gamelist.Info.Games_Count.SetBounds(0, 1, 750, 22);
  Emu_VM_Default.Gamelist.Info.Games_Count.Text := '';
  Emu_VM_Default.Gamelist.Info.Games_Count.Color := TAlphaColorRec.White;
  Emu_VM_Default.Gamelist.Info.Games_Count.Font.Family := 'Tahoma';
  Emu_VM_Default.Gamelist.Info.Games_Count.Font.Style := Emu_VM_Default.Gamelist.Info.Games_Count.Font.Style + [TFontStyle.fsBold];
  Emu_VM_Default.Gamelist.Info.Games_Count.Font.Size := 20;
  Emu_VM_Default.Gamelist.Info.Games_Count.TextSettings.HorzAlign := TTextAlign.Trailing;
  Emu_VM_Default.Gamelist.Info.Games_Count.Visible := True;

  Emu_VM_Default.Gamelist.Info.Version := TText.Create(Emu_VM_Default.Gamelist.Info.Back);
  Emu_VM_Default.Gamelist.Info.Version.name := 'Emu_Gamelist_Info_Version';
  Emu_VM_Default.Gamelist.Info.Version.Parent := Emu_VM_Default.Gamelist.Info.Back;
  Emu_VM_Default.Gamelist.Info.Version.SetBounds(0, 1, 750, 22);
  Emu_VM_Default.Gamelist.Info.Version.Color := TAlphaColorRec.White;
  Emu_VM_Default.Gamelist.Info.Version.Text := '';
  Emu_VM_Default.Gamelist.Info.Version.Font.Family := 'Tahoma';
  Emu_VM_Default.Gamelist.Info.Version.Font.Style := Emu_VM_Default.Gamelist.Info.Version.Font.Style + [TFontStyle.fsBold];
  Emu_VM_Default.Gamelist.Info.Version.Font.Size := 20;
  Emu_VM_Default.Gamelist.Info.Version.TextSettings.HorzAlign := TTextAlign.Leading;
  Emu_VM_Default.Gamelist.Info.Version.Visible := True;
end;

procedure Create_Gamelist_Games;
var
  vi: Integer;
  viPos: Integer;
begin
  Emu_VM_Default.Gamelist.games.list := TImage.Create(Emu_VM_Default.left);
  Emu_VM_Default.Gamelist.games.list.name := 'Emu_Gamelist_Games';
  Emu_VM_Default.Gamelist.games.list.Parent := Emu_VM_Default.left;
  Emu_VM_Default.Gamelist.games.list.SetBounds(50, 50, 750, (Emu_VM_Default.left.height - 180));
  Emu_VM_Default.Gamelist.games.list.WrapMode := TImageWrapMode.Tile;
  Emu_VM_Default.Gamelist.games.list.Bitmap.LoadFromFile(Emu_XML.Images_Path + Emu_XML.main.Black_Opacity.image);
  Emu_VM_Default.Gamelist.games.list.Visible := True;

  Emu_VM_Default.Gamelist.games.Listbox := TVertScrollBox.Create(Emu_VM_Default.Gamelist.games.list);
  Emu_VM_Default.Gamelist.games.Listbox.name := 'Emu_Gamelist_Games_Box';
  Emu_VM_Default.Gamelist.games.Listbox.Parent := Emu_VM_Default.Gamelist.games.list;
  Emu_VM_Default.Gamelist.games.Listbox.Align := TAlignLayout.Client;
  Emu_VM_Default.Gamelist.games.Listbox.ShowScrollBars := False;
  Emu_VM_Default.Gamelist.games.Listbox.Visible := True;

  for vi := 0 to 20 do
  begin
    Emu_VM_Default.Gamelist.games.Line[vi].Back := TImage.Create(Emu_VM_Default.Gamelist.games.Listbox);
    Emu_VM_Default.Gamelist.games.Line[vi].Back.name := 'Emu_Gamelist_Games_Line_' + vi.ToString;
    Emu_VM_Default.Gamelist.games.Line[vi].Back.Parent := Emu_VM_Default.Gamelist.games.Listbox;
    Emu_VM_Default.Gamelist.games.Line[vi].Back.SetBounds(0, ((vi * 40) + (vi + 10)), (Emu_VM_Default.Gamelist.games.Listbox.width - 10), 40);
    Emu_VM_Default.Gamelist.games.Line[vi].Back.Tag := vi;
    Emu_VM_Default.Gamelist.games.Line[vi].Back.Visible := True;

    Emu_VM_Default.Gamelist.games.Line[vi].Icon := TImage.Create(Emu_VM_Default.Gamelist.games.Line[vi].Back);
    Emu_VM_Default.Gamelist.games.Line[vi].Icon.name := 'Emu_Gamelist_Games_Icon_' + vi.ToString;
    Emu_VM_Default.Gamelist.games.Line[vi].Icon.Parent := Emu_VM_Default.Gamelist.games.Line[vi].Back;
    Emu_VM_Default.Gamelist.games.Line[vi].Icon.SetBounds(4, 2, 38, 38);
    Emu_VM_Default.Gamelist.games.Line[vi].Icon.Tag := vi;
    Emu_VM_Default.Gamelist.games.Line[vi].Icon.Visible := True;

    Emu_VM_Default.Gamelist.games.Line[vi].Text := TText.Create(Emu_VM_Default.Gamelist.games.Line[vi].Back);
    Emu_VM_Default.Gamelist.games.Line[vi].Text.name := 'Emu_Gamelist_Games_Game_' + vi.ToString;
    Emu_VM_Default.Gamelist.games.Line[vi].Text.Parent := Emu_VM_Default.Gamelist.games.Line[vi].Back;
    Emu_VM_Default.Gamelist.games.Line[vi].Text.SetBounds(48, 3, 654, 34);
    Emu_VM_Default.Gamelist.games.Line[vi].Text.Text := IntToStr(vi);
    Emu_VM_Default.Gamelist.games.Line[vi].Text.Font.Family := 'Tahoma';
    Emu_VM_Default.Gamelist.games.Line[vi].Text.Color := TAlphaColorRec.White;
    Emu_VM_Default.Gamelist.games.Line[vi].Text.Font.Style := Emu_VM_Default.Gamelist.games.Line[vi].Text.Font.Style + [TFontStyle.fsBold];
    if vi = 10 then
      Emu_VM_Default.Gamelist.games.Line[vi].Text.Font.Size := 24
    else
      Emu_VM_Default.Gamelist.games.Line[vi].Text.Font.Size := 18;
    Emu_VM_Default.Gamelist.games.Line[vi].Text.HorzTextAlign := TTextAlign.Leading;
    Emu_VM_Default.Gamelist.games.Line[vi].Text.Tag := vi;
    Emu_VM_Default.Gamelist.games.Line[vi].Text.Visible := True;
  end;

  Emu_VM_Default.Gamelist.games.Selection := TGlowEffect.Create(Emu_VM_Default.Gamelist.games.Line[10].Text);
  Emu_VM_Default.Gamelist.games.Selection.name := 'Emu_Gamelist_Game_Selection';
  Emu_VM_Default.Gamelist.games.Selection.Parent := Emu_VM_Default.Gamelist.games.Line[10].Text;
  Emu_VM_Default.Gamelist.games.Selection.GlowColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Default.Gamelist.games.Selection.Opacity := 0.9;
  Emu_VM_Default.Gamelist.games.Selection.Softness := 0.4;
  Emu_VM_Default.Gamelist.games.Selection.Enabled := True;

  Emu_VM_Default.Gamelist.games.Line[10].Back.Bitmap.LoadFromFile(Emu_XML.Images_Path + Emu_XML.main.Selection.image);

  Emu_VM_Default.Gamelist.games.List_Blur := TBlurEffect.Create(Emu_VM_Default.Gamelist.games.Listbox);
  Emu_VM_Default.Gamelist.games.List_Blur.name := 'Emu_Gamelist_Games_List_Blur';
  Emu_VM_Default.Gamelist.games.List_Blur.Parent := Emu_VM_Default.Gamelist.games.Listbox;
  Emu_VM_Default.Gamelist.games.List_Blur.Softness := 0.9;
  Emu_VM_Default.Gamelist.games.List_Blur.Enabled := False;
end;

procedure Create_Gamelist_Lists;
begin
  Emu_VM_Default.Gamelist.lists.Back := TImage.Create(Emu_VM_Default.left);
  Emu_VM_Default.Gamelist.lists.Back.name := 'Emu_Gamelist_Lists';
  Emu_VM_Default.Gamelist.lists.Back.Parent := Emu_VM_Default.left;
  Emu_VM_Default.Gamelist.lists.Back.SetBounds(50, 958, 750, 26);
  Emu_VM_Default.Gamelist.lists.Back.WrapMode := TImageWrapMode.Tile;
  Emu_VM_Default.Gamelist.lists.Back.Bitmap.LoadFromFile(Emu_XML.Images_Path + Emu_XML.main.Black_Opacity.image);
  Emu_VM_Default.Gamelist.lists.Back.Visible := True;

  Emu_VM_Default.Gamelist.lists.lists := TText.Create(Emu_VM_Default.Gamelist.lists.Back);
  Emu_VM_Default.Gamelist.lists.lists.name := 'Emu_Gamelist_Lists_Icon';
  Emu_VM_Default.Gamelist.lists.lists.Parent := Emu_VM_Default.Gamelist.lists.Back;
  Emu_VM_Default.Gamelist.lists.lists.SetBounds(2, 1, 24, 24);
  Emu_VM_Default.Gamelist.lists.lists.Font.Family := 'IcoMoon-Free';
  Emu_VM_Default.Gamelist.lists.lists.Font.Size := 22;
  Emu_VM_Default.Gamelist.lists.lists.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Default.Gamelist.lists.lists.Text := #$e904;
  Emu_VM_Default.Gamelist.lists.lists.OnClick := Emu_VM_Default_Mouse.Text.OnMouseClick;
  Emu_VM_Default.Gamelist.lists.lists.OnMouseEnter := Emu_VM_Default_Mouse.Text.OnMouseEnter;
  Emu_VM_Default.Gamelist.lists.lists.OnMouseLeave := Emu_VM_Default_Mouse.Text.OnMouseLeave;
  Emu_VM_Default.Gamelist.lists.lists.Visible := True;

  Emu_VM_Default.Gamelist.lists.Lists_Glow := TGlowEffect.Create(Emu_VM_Default.Gamelist.lists.lists);
  Emu_VM_Default.Gamelist.lists.Lists_Glow.name := 'Emu_Gamelist_Lists_Icon_Glow';
  Emu_VM_Default.Gamelist.lists.Lists_Glow.Parent := Emu_VM_Default.Gamelist.lists.lists;
  Emu_VM_Default.Gamelist.lists.Lists_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Default.Gamelist.lists.Lists_Glow.Softness := 0.9;
  Emu_VM_Default.Gamelist.lists.Lists_Glow.Enabled := False;

  Emu_VM_Default.Gamelist.lists.Lists_Text := TText.Create(Emu_VM_Default.Gamelist.lists.Back);
  Emu_VM_Default.Gamelist.lists.Lists_Text.name := 'Mame_Gamelist_Lists_Text';
  Emu_VM_Default.Gamelist.lists.Lists_Text.Parent := Emu_VM_Default.Gamelist.lists.Back;
  Emu_VM_Default.Gamelist.lists.Lists_Text.SetBounds(40, 1, 710, 22);
  Emu_VM_Default.Gamelist.lists.Lists_Text.Color := TAlphaColorRec.White;
  Emu_VM_Default.Gamelist.lists.Lists_Text.Font.Family := 'Tahoma';
  Emu_VM_Default.Gamelist.lists.Lists_Text.Font.Size := 20;
  Emu_VM_Default.Gamelist.lists.Lists_Text.TextSettings.HorzAlign := TTextAlign.Leading;
  Emu_VM_Default.Gamelist.lists.Lists_Text.Text := Emu_VM_Default_Var.lists.Selected;
  Emu_VM_Default.Gamelist.lists.Lists_Text.Visible := True;
end;

procedure Create_Gamelist_Filters;
begin
  Emu_VM_Default.Gamelist.filters.Back := TImage.Create(Emu_VM_Default.left);
  Emu_VM_Default.Gamelist.filters.Back.name := 'Emu_Gamelist_Filters';
  Emu_VM_Default.Gamelist.filters.Back.Parent := Emu_VM_Default.left;
  Emu_VM_Default.Gamelist.filters.Back.SetBounds(50, 992, 750, 26);
  Emu_VM_Default.Gamelist.filters.Back.WrapMode := TImageWrapMode.Tile;
  Emu_VM_Default.Gamelist.filters.Back.Bitmap.LoadFromFile(Emu_XML.Images_Path + Emu_XML.main.Black_Opacity.image);
  Emu_VM_Default.Gamelist.filters.Back.Visible := True;

  Emu_VM_Default.Gamelist.filters.Filter := TText.Create(Emu_VM_Default.Gamelist.filters.Back);
  Emu_VM_Default.Gamelist.filters.Filter.name := 'Emu_Gamelist_Filters_Icon';
  Emu_VM_Default.Gamelist.filters.Filter.Parent := Emu_VM_Default.Gamelist.filters.Back;
  Emu_VM_Default.Gamelist.filters.Filter.SetBounds(2, 1, 24, 24);
  Emu_VM_Default.Gamelist.filters.Filter.Font.Family := 'IcoMoon-Free';
  Emu_VM_Default.Gamelist.filters.Filter.Font.Size := 22;
  Emu_VM_Default.Gamelist.filters.Filter.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Default.Gamelist.filters.Filter.Text := #$ea5b;
  Emu_VM_Default.Gamelist.filters.Filter.OnClick := Emu_VM_Default_Mouse.Text.OnMouseClick;
  Emu_VM_Default.Gamelist.filters.Filter.OnMouseEnter := Emu_VM_Default_Mouse.Text.OnMouseEnter;
  Emu_VM_Default.Gamelist.filters.Filter.OnMouseLeave := Emu_VM_Default_Mouse.Text.OnMouseLeave;
  Emu_VM_Default.Gamelist.filters.Filter.Visible := True;

  Emu_VM_Default.Gamelist.filters.Filter_Glow := TGlowEffect.Create(Emu_VM_Default.Gamelist.filters.Filter);
  Emu_VM_Default.Gamelist.filters.Filter_Glow.name := 'Mame_Gamelist_Filters_Icon_Glow';
  Emu_VM_Default.Gamelist.filters.Filter_Glow.Parent := Emu_VM_Default.Gamelist.filters.Filter;
  Emu_VM_Default.Gamelist.filters.Filter_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Default.Gamelist.filters.Filter_Glow.Softness := 0.9;
  Emu_VM_Default.Gamelist.filters.Filter_Glow.Enabled := False;

  Emu_VM_Default.Gamelist.filters.Filter_Text := TText.Create(Emu_VM_Default.Gamelist.filters.Back);
  Emu_VM_Default.Gamelist.filters.Filter_Text.name := 'Mame_Gamelist_Filters_Text';
  Emu_VM_Default.Gamelist.filters.Filter_Text.Parent := Emu_VM_Default.Gamelist.filters.Back;
  Emu_VM_Default.Gamelist.filters.Filter_Text.SetBounds(40, 1, 710, 22);
  Emu_VM_Default.Gamelist.filters.Filter_Text.Color := TAlphaColorRec.White;
  Emu_VM_Default.Gamelist.filters.Filter_Text.Font.Size := 20;
  Emu_VM_Default.Gamelist.filters.Filter_Text.Text := 'All';
  Emu_VM_Default.Gamelist.filters.Filter_Text.TextSettings.HorzAlign := TTextAlign.Leading;
  Emu_VM_Default.Gamelist.filters.Filter_Text.Visible := True;
end;

procedure Create_Gamelist_Search;
begin
  Emu_VM_Default.Gamelist.Search.Back := TImage.Create(Emu_VM_Default.left);
  Emu_VM_Default.Gamelist.Search.Back.name := 'Emu_Gamelist_Search';
  Emu_VM_Default.Gamelist.Search.Back.Parent := Emu_VM_Default.left;
  Emu_VM_Default.Gamelist.Search.Back.SetBounds(50, 1026, 750, 26);
  Emu_VM_Default.Gamelist.Search.Back.WrapMode := TImageWrapMode.Tile;
  Emu_VM_Default.Gamelist.Search.Back.Bitmap.LoadFromFile(Emu_XML.Images_Path + Emu_XML.main.Black_Opacity.image);
  Emu_VM_Default.Gamelist.Search.Back.Visible := True;

  Emu_VM_Default.Gamelist.Search.Search := TText.Create(Emu_VM_Default.Gamelist.Search.Back);
  Emu_VM_Default.Gamelist.Search.Search.name := 'Emu_Gamelist_Search_Icon';
  Emu_VM_Default.Gamelist.Search.Search.Parent := Emu_VM_Default.Gamelist.Search.Back;
  Emu_VM_Default.Gamelist.Search.Search.SetBounds(2, 1, 24, 24);
  Emu_VM_Default.Gamelist.Search.Search.Font.Family := 'IcoMoon-Free';
  Emu_VM_Default.Gamelist.Search.Search.Font.Size := 22;
  Emu_VM_Default.Gamelist.Search.Search.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Default.Gamelist.Search.Search.Text := #$e986;
  Emu_VM_Default.Gamelist.Search.Search.OnClick := Emu_VM_Default_Mouse.Text.OnMouseClick;
  Emu_VM_Default.Gamelist.Search.Search.OnMouseEnter := Emu_VM_Default_Mouse.Text.OnMouseEnter;
  Emu_VM_Default.Gamelist.Search.Search.OnMouseLeave := Emu_VM_Default_Mouse.Text.OnMouseLeave;
  Emu_VM_Default.Gamelist.Search.Search.Visible := True;

  Emu_VM_Default.Gamelist.Search.Glow := TGlowEffect.Create(Emu_VM_Default.Gamelist.Search.Search);
  Emu_VM_Default.Gamelist.Search.Glow.name := 'Emu_Gamelist_Search_Icon_Glow';
  Emu_VM_Default.Gamelist.Search.Glow.Parent := Emu_VM_Default.Gamelist.Search.Search;
  Emu_VM_Default.Gamelist.Search.Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Default.Gamelist.Search.Glow.Softness := 0.9;
  Emu_VM_Default.Gamelist.Search.Glow.Enabled := False;

  Emu_VM_Default.Gamelist.Search.Edit := TEdit.Create(Emu_VM_Default.Gamelist.Search.Back);
  Emu_VM_Default.Gamelist.Search.Edit.name := 'Emu_Gamelist_Search_Edit';
  Emu_VM_Default.Gamelist.Search.Edit.Parent := Emu_VM_Default.Gamelist.Search.Back;
  Emu_VM_Default.Gamelist.Search.Edit.SetBounds(34, 1, 0, 24);
  Emu_VM_Default.Gamelist.Search.Edit.StyledSettings := Emu_VM_Default.Gamelist.Search.Edit.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
  Emu_VM_Default.Gamelist.Search.Edit.Text := '';
  Emu_VM_Default.Gamelist.Search.Edit.TextSettings.FontColor := TAlphaColorRec.White;
  Emu_VM_Default.Gamelist.Search.Edit.TextSettings.Font.Size := 16;
  Emu_VM_Default.Gamelist.Search.Edit.OnTyping := Emu_VM_Default_Mouse.Edit.OnTyping;
  Emu_VM_Default.Gamelist.Search.Edit.Visible := True;

  Emu_VM_Default.Gamelist.Search.Edit_Ani := TFloatAnimation.Create(Emu_VM_Default.Gamelist.Search.Edit);
  Emu_VM_Default.Gamelist.Search.Edit_Ani.name := 'Emu_Gamelist_Search_Edit_Animation';
  Emu_VM_Default.Gamelist.Search.Edit_Ani.Parent := Emu_VM_Default.Gamelist.Search.Edit;
  Emu_VM_Default.Gamelist.Search.Edit_Ani.PropertyName := 'Width';
  Emu_VM_Default.Gamelist.Search.Edit_Ani.Duration := 0.2;
  Emu_VM_Default.Gamelist.Search.Edit_Ani.StartValue := 0;
  Emu_VM_Default.Gamelist.Search.Edit_Ani.StopValue := 716;
  Emu_VM_Default.Gamelist.Search.Edit_Ani.Enabled := False;
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
  Emu_VM_Default.Media.Bar.Back := TImage.Create(Emu_VM_Default.right);
  Emu_VM_Default.Media.Bar.Back.name := 'Emu_Media_Bar';
  Emu_VM_Default.Media.Bar.Back.Parent := Emu_VM_Default.right;
  Emu_VM_Default.Media.Bar.Back.SetBounds(50, 18, 750, 26);
  Emu_VM_Default.Media.Bar.Back.WrapMode := TImageWrapMode.Tile;
  Emu_VM_Default.Media.Bar.Back.Bitmap.LoadFromFile(Emu_XML.Images_Path + Emu_XML.main.Black_Opacity.image);
  Emu_VM_Default.Media.Bar.Back.Visible := True;

  Emu_VM_Default.Media.Bar.favorites := TText.Create(Emu_VM_Default.Media.Bar.Back);
  Emu_VM_Default.Media.Bar.favorites.name := 'Emu_Media_Bar_Favorites';
  Emu_VM_Default.Media.Bar.favorites.Parent := Emu_VM_Default.Media.Bar.Back;
  Emu_VM_Default.Media.Bar.favorites.SetBounds(2, 1, 24, 24);
  Emu_VM_Default.Media.Bar.favorites.Font.Family := 'IcoMoon-Free';
  Emu_VM_Default.Media.Bar.favorites.Font.Size := 22;
  Emu_VM_Default.Media.Bar.favorites.TextSettings.FontColor := TAlphaColorRec.Grey;
  Emu_VM_Default.Media.Bar.favorites.Text := #$e9da;
  Emu_VM_Default.Media.Bar.favorites.OnClick := Emu_VM_Default_Mouse.Text.OnMouseClick;
  Emu_VM_Default.Media.Bar.favorites.OnMouseEnter := Emu_VM_Default_Mouse.Text.OnMouseEnter;
  Emu_VM_Default.Media.Bar.favorites.OnMouseLeave := Emu_VM_Default_Mouse.Text.OnMouseLeave;
  Emu_VM_Default.Media.Bar.favorites.Visible := True;

  Emu_VM_Default.Media.Bar.Favorites_Glow := TGlowEffect.Create(Emu_VM_Default.Media.Bar.favorites);
  Emu_VM_Default.Media.Bar.Favorites_Glow.name := 'Emu_Media_Bar_Favorites_Glow';
  Emu_VM_Default.Media.Bar.Favorites_Glow.Parent := Emu_VM_Default.Media.Bar.favorites;
  Emu_VM_Default.Media.Bar.Favorites_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Default.Media.Bar.Favorites_Glow.Softness := 0.9;
  Emu_VM_Default.Media.Bar.Favorites_Glow.Enabled := False;
end;

procedure Create_Media_Video;
begin
  Emu_VM_Default.Media.Video.Back := TImage.Create(Emu_VM_Default.right);
  Emu_VM_Default.Media.Video.Back.name := 'Emu_Media_Video';
  Emu_VM_Default.Media.Video.Back.Parent := Emu_VM_Default.right;
  Emu_VM_Default.Media.Video.Back.SetBounds(50, 50, 750, (Emu_VM_Default.right.height - 180));
  Emu_VM_Default.Media.Video.Back.Bitmap.LoadFromFile(Emu_XML.Images_Path + Emu_XML.main.Black_Opacity.image);
  Emu_VM_Default.Media.Video.Back.WrapMode := TImageWrapMode.Tile;
  Emu_VM_Default.Media.Video.Back.Visible := True;

  Emu_VM_Default.Media.Video.Marquee := TImage.Create(Emu_VM_Default.Media.Video.Back);
  Emu_VM_Default.Media.Video.Marquee.name := 'Emu_Media_Video_Marquee';
  Emu_VM_Default.Media.Video.Marquee.Parent := Emu_VM_Default.Media.Video.Back;
  Emu_VM_Default.Media.Video.Marquee.SetBounds(150, 4, 450, 88);
  Emu_VM_Default.Media.Video.Marquee.WrapMode := TImageWrapMode.Fit;
  Emu_VM_Default.Media.Video.Marquee.Visible := True;

  Emu_VM_Default.Media.Video.Video_Back := TImage.Create(Emu_VM_Default.Media.Video.Back);
  Emu_VM_Default.Media.Video.Video_Back.name := 'Emu_Media_Video_Back';
  Emu_VM_Default.Media.Video.Video_Back.Parent := Emu_VM_Default.Media.Video.Back;
  Emu_VM_Default.Media.Video.Video_Back.SetBounds(50, 100, 650, 600);
  Emu_VM_Default.Media.Video.Video_Back.Bitmap.LoadFromFile(Emu_XML.Images_Path + Emu_XML.main.Black.image);
  Emu_VM_Default.Media.Video.Video_Back.Visible := True;

  Emu_VM_Default.Media.Video.Video := TFmxPasLibVlcPlayer.Create(Emu_VM_Default.Media.Video.Video_Back);
  Emu_VM_Default.Media.Video.Video.name := 'Emu_Media_Video_Video';
  Emu_VM_Default.Media.Video.Video.Parent := Emu_VM_Default.Media.Video.Video_Back;
  Emu_VM_Default.Media.Video.Video.Align := TAlignLayout.Client;
  Emu_VM_Default.Media.Video.Video.SetVideoAspectRatio('4:3');
  Emu_VM_Default.Media.Video.Video.WrapMode := TImageWrapMode.Stretch;
  Emu_VM_Default.Media.Video.Video.Visible := True;

  Emu_VM_Default.Media.Video.Video_Timer_Cont := TTimer.Create(Emu_VM_Default.Media.Video.Video_Back);
  Emu_VM_Default.Media.Video.Video_Timer_Cont.Interval := 100;
  Emu_VM_Default.Media.Video.Video_Timer_Cont.OnTimer := Emu_VM_Default_Var.Timer.Video.OnTimer;
  Emu_VM_Default.Media.Video.Video_Timer_Cont.Enabled := False;

  Emu_VM_Default.Media.Video.Video_Logo_Fullscreen := TImage.Create(Emu_VM_Default.Media.Video.Video);
  Emu_VM_Default.Media.Video.Video_Logo_Fullscreen.name := 'Emu_Media_Video_Video_Logo';
  Emu_VM_Default.Media.Video.Video_Logo_Fullscreen.Parent := Emu_VM_Default.Media.Video.Video;
  Emu_VM_Default.Media.Video.Video_Logo_Fullscreen.SetBounds(10, 10, 200, 120);
  Emu_VM_Default.Media.Video.Video_Logo_Fullscreen.WrapMode := TImageWrapMode.Fit;
  Emu_VM_Default.Media.Video.Video_Logo_Fullscreen.Visible := False;

  Emu_VM_Default.Media.Video.Video_Text_Fullscreen := TText.Create(Emu_VM_Default.Media.Video.Video);
  Emu_VM_Default.Media.Video.Video_Text_Fullscreen.name := 'Emu_Media_Video_Video_Text';
  Emu_VM_Default.Media.Video.Video_Text_Fullscreen.Parent := Emu_VM_Default.Media.Video.Video;
  Emu_VM_Default.Media.Video.Video_Text_Fullscreen.SetBounds(0, 0, 0, 0);
  Emu_VM_Default.Media.Video.Video_Text_Fullscreen.Font.Size := 48;
  Emu_VM_Default.Media.Video.Video_Text_Fullscreen.Canvas.BeginScene;
  Emu_VM_Default.Media.Video.Video_Text_Fullscreen.Canvas.Stroke.Thickness := 5;
  Emu_VM_Default.Media.Video.Video_Text_Fullscreen.Canvas.Stroke.Color := TAlphaColorRec.White;
  Emu_VM_Default.Media.Video.Video_Text_Fullscreen.Canvas.EndScene;
  Emu_VM_Default.Media.Video.Video_Text_Fullscreen.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Default.Media.Video.Video_Text_Fullscreen.Visible := False;

  Emu_VM_Default.Media.Video.Game_Info.Layout := TLayout.Create(Emu_VM_Default.Media.Video.Video_Back);
  Emu_VM_Default.Media.Video.Game_Info.Layout.name := 'Mame_Media_Players';
  Emu_VM_Default.Media.Video.Game_Info.Layout.Parent := Emu_VM_Default.Media.Video.Video_Back;
  Emu_VM_Default.Media.Video.Game_Info.Layout.SetBounds(0, -50, Emu_VM_Default.Media.Video.Video_Back.width, 50);
  Emu_VM_Default.Media.Video.Game_Info.Layout.Visible := True;

  Emu_VM_Default.Media.Video.Game_Info.Players := TText.Create(Emu_VM_Default.Media.Video.Game_Info.Layout);
  Emu_VM_Default.Media.Video.Game_Info.Players.name := 'Mame_Media_Players';
  Emu_VM_Default.Media.Video.Game_Info.Players.Parent := Emu_VM_Default.Media.Video.Game_Info.Layout;
  Emu_VM_Default.Media.Video.Game_Info.Players.SetBounds(2, 5, 40, 50);
  Emu_VM_Default.Media.Video.Game_Info.Players.Font.Family := 'IcoMoon-Free';
  Emu_VM_Default.Media.Video.Game_Info.Players.Font.Size := 24;
  Emu_VM_Default.Media.Video.Game_Info.Players.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  Emu_VM_Default.Media.Video.Game_Info.Players.Text := #$e972;
  Emu_VM_Default.Media.Video.Game_Info.Players.Visible := True;

  Emu_VM_Default.Media.Video.Game_Info.Players_Value := TText.Create(Emu_VM_Default.Media.Video.Game_Info.Layout);
  Emu_VM_Default.Media.Video.Game_Info.Players_Value.name := 'Mame_Media_Players_Value';
  Emu_VM_Default.Media.Video.Game_Info.Players_Value.Parent := Emu_VM_Default.Media.Video.Game_Info.Layout;
  Emu_VM_Default.Media.Video.Game_Info.Players_Value.SetBounds(42, 5, 500, 50);
  Emu_VM_Default.Media.Video.Game_Info.Players_Value.Font.Family := 'Tahome';
  Emu_VM_Default.Media.Video.Game_Info.Players_Value.Font.Size := 18;
  Emu_VM_Default.Media.Video.Game_Info.Players_Value.TextSettings.FontColor := TAlphaColorRec.White;
  Emu_VM_Default.Media.Video.Game_Info.Players_Value.HorzTextAlign := TTextAlign.Leading;
  Emu_VM_Default.Media.Video.Game_Info.Players_Value.Text := '';
  Emu_VM_Default.Media.Video.Game_Info.Players_Value.Visible := True;

  Emu_VM_Default.Media.Video.Game_Info.favorite := TText.Create(Emu_VM_Default.Media.Video.Game_Info.Layout);
  Emu_VM_Default.Media.Video.Game_Info.favorite.name := 'Mame_Media_Favorite';
  Emu_VM_Default.Media.Video.Game_Info.favorite.Parent := Emu_VM_Default.Media.Video.Game_Info.Layout;
  Emu_VM_Default.Media.Video.Game_Info.favorite.SetBounds(Emu_VM_Default.Media.Video.Game_Info.Layout.width - 60, 5, 60, 50);
  Emu_VM_Default.Media.Video.Game_Info.favorite.Font.Family := 'IcoMoon-Free';
  Emu_VM_Default.Media.Video.Game_Info.favorite.Font.Size := 24;
  Emu_VM_Default.Media.Video.Game_Info.favorite.TextSettings.FontColor := TAlphaColorRec.Red;
  Emu_VM_Default.Media.Video.Game_Info.favorite.Text := #$e9da;
  Emu_VM_Default.Media.Video.Game_Info.favorite.Visible := False;
end;

procedure Create_Media;
begin
  Create_Media_Bar;
  Create_Media_Video;
end;

procedure Load_Files;
begin

end;

procedure Start_View_Mode(vSelected, vGames_Count: Integer; vList_Games, vList_Roms, vList_Path: TStringlist);
begin
  Emu_VM_Default_Var.Gamelist.Games := TStringlist.Create;
  Emu_VM_Default_Var.Gamelist.Roms := TStringlist.Create;
  Emu_VM_Default_Var.Gamelist.Paths := TStringlist.Create;

  Emu_VM_Default_Var.Gamelist.Selected := vSelected;
  Emu_VM_Default_Var.Gamelist.Total_Games := vGames_Count;
  Emu_VM_Default_Var.Gamelist.Roms := vList_Roms;
  Emu_VM_Default_Var.Gamelist.Games := vList_Games;
  Emu_VM_Default_Var.Gamelist.Paths := vList_Path;

  uView_Mode_Default_Actions.Refresh;

end;


end.
