unit uEmu_Arcade_Mame_Config;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UiTypes,
  FMX.Objects,
  FMX.StdCtrls;

const
  cMame_Config_Buttons_Names: array [0 .. 12] of WideString = ('Directories', 'Display', 'Advance', 'Screen',
    'OpenGL/BGFX', 'OpenGL Shaders', 'Vector', 'Sound', 'Controllers', 'Controller Mapping', 'Miscellaneous',
    'Miscellaneous II', 'Snap/Movie/Playback');
  cMame_Config_Media_dirs: array [0 .. 25] of WideString = ('Artworks', 'Cabinets', 'Control Panels',
    'Covers', 'Flyers', 'Fanart', 'Icons', 'Manuals', 'Marquees', 'Pcbs', 'Snapshots', 'Titles',
    'Artwork Preview', 'Bosses', 'Ends', 'How To', 'Logos', 'Scores', 'Selects', 'Versus', 'Game Over',
    'Warnings', 'Stamps', 'Soundtracks', 'Support Files', 'Videos');

procedure uEmu_Arcade_Mame_Config_Load;
procedure uEmu_Arcade_Mame_Config_Free;

procedure uEmu_Arcade_Mame_Config_FreePreviewsPanel(vFreePanel_Num: Integer);
procedure uEmu_Arcade_Mame_Config_ShowActivePanel(vShow: Integer);

var
  mame_config_menu_panel: Integer;

implementation

uses
  uLoad_AllTypes,
  uEmu_Arcade_Mame_AllTypes,
  uEmu_Arcade_Mame_Mouse,
  uEmu_Arcade_Mame_Config_Directories,
  uEmu_Arcade_Mame_Config_Display,
  uEmu_Arcade_Mame_Config_Advanced,
  uEmu_Arcade_Mame_Config_Screen,
  uEmu_Arcade_Mame_Config_OpenGL_BGFX,
  uEmu_Arcade_Mame_Config_OpenGLShaders,
  uEmu_Arcade_Mame_Config_Vector,
  uEmu_Arcade_Mame_Config_Sound,
  uEmu_Arcade_Mame_Config_Controllers,
  uEmu_Arcade_Mame_Config_Controller_Mapping,
  uEmu_Arcade_Mame_Config_Miscellaneous,
  uEmu_Arcade_Mame_Config_MiscellaneousII,
  uEmu_Arcade_Mame_Config_Snap_Movie_Playback;

procedure uEmu_Arcade_Mame_Config_Load;
var
  vi: Integer;
begin
  vMame.Config.Scene.Header_Icon := TImage.Create(vMame.Config.Scene.Header);
  vMame.Config.Scene.Header_Icon.Name := 'Mame_Config_Header_Icon';
  vMame.Config.Scene.Header_Icon.Parent := vMame.Config.Scene.Header;
  vMame.Config.Scene.Header_Icon.Width := 24;
  vMame.Config.Scene.Header_Icon.Height := 24;
  vMame.Config.Scene.Header_Icon.Position.X := 6;
  vMame.Config.Scene.Header_Icon.Position.Y := 3;
  vMame.Config.Scene.Header_Icon.Visible := True;

  vMame.Config.Scene.Header_Label := TLabel.Create(vMame.Config.Scene.Header);
  vMame.Config.Scene.Header_Label.Name := 'Mame_Config_Header_Label';
  vMame.Config.Scene.Header_Label.Parent := vMame.Config.Scene.Header;
  vMame.Config.Scene.Header_Label.Width := vMame.Config.Scene.Header.Width - 36;
  vMame.Config.Scene.Header_Label.Height := 28;
  vMame.Config.Scene.Header_Label.Position.X := 36;
  vMame.Config.Scene.Header_Label.Position.Y := 1;
  vMame.Config.Scene.Header_Label.Font.Family := 'Tahoma';
  vMame.Config.Scene.Header_Label.Font.Style := vMame.Config.Scene.Header_Label.Font.Style +
    [TFontStyle.fsBold];
  vMame.Config.Scene.Header_Label.Visible := True;

  for vi := 0 to 12 do
  begin
    vMame.Config.Scene.Left_Buttons[vi] := TButton.Create(vMame.Config.Scene.Left);
    vMame.Config.Scene.Left_Buttons[vi].Name := 'Mame_Config_Button_' + IntToStr(vi);
    vMame.Config.Scene.Left_Buttons[vi].Parent := vMame.Config.Scene.Left;
    vMame.Config.Scene.Left_Buttons[vi].Width := 130;
    vMame.Config.Scene.Left_Buttons[vi].Height := 22;
    vMame.Config.Scene.Left_Buttons[vi].Position.X := 10;
    vMame.Config.Scene.Left_Buttons[vi].Position.Y := 20 + ((vi * 22) + (vi * 10));
    vMame.Config.Scene.Left_Buttons[vi].OnClick := mame.Input.Mouse.Button.OnMouseClick;
    vMame.Config.Scene.Left_Buttons[vi].Text := cMame_Config_Buttons_Names[vi];
    vMame.Config.Scene.Left_Buttons[vi].Tag := vi;
    vMame.Config.Scene.Left_Buttons[vi].Visible := True;
  end;

  for vi := 0 to 12 do
  begin
    vMame.Config.Scene.Right_Panels[vi] := TPanel.Create(vMame.Config.Scene.Right);
    vMame.Config.Scene.Right_Panels[vi].Name := 'Mame_Config_A_Panel_' + IntToStr(vi);
    vMame.Config.Scene.Right_Panels[vi].Parent := vMame.Config.Scene.Right;
    vMame.Config.Scene.Right_Panels[vi].Width := vMame.Config.Scene.Right.Width;
    vMame.Config.Scene.Right_Panels[vi].Height := vMame.Config.Scene.Right.Height;
    vMame.Config.Scene.Right_Panels[vi].Position.X := 0;
    vMame.Config.Scene.Right_Panels[vi].Position.Y := 0;
    vMame.Config.Scene.Right_Panels[vi].Tag := vi;
    vMame.Config.Scene.Right_Panels[vi].Visible := False;
  end;

  mame_config_menu_panel := -1;
end;

procedure uEmu_Arcade_Mame_Config_Free;
var
  vi: Integer;
begin
  FreeAndNil(vMame.Config.Scene.Header_Icon);
  FreeAndNil(vMame.Config.Scene.Header_Label);
  for vi := 0 to 12 do
  begin
    FreeAndNil(vMame.Config.Scene.Left_Buttons[vi]);
    FreeAndNil(vMame.Config.Scene.Right_Panels[vi]);
  end;
end;

/// /////////////////////////////////////////////////////////////////////////////

procedure uEmu_Arcade_Mame_Config_FreePreviewsPanel(vFreePanel_Num: Integer);
var
  vi: Integer;
begin
  if vFreePanel_Num <> -1 then
  begin
    for vi := 0 to 12 do
      FreeAndNil(vMame.Config.Scene.Right_Panels[vi]);
    for vi := 0 to 12 do
    begin
      vMame.Config.Scene.Right_Panels[vi] := TPanel.Create(vMame.Config.Scene.Right);
      vMame.Config.Scene.Right_Panels[vi].Name := 'Mame_Config_A_Panel_' + IntToStr(vi);
      vMame.Config.Scene.Right_Panels[vi].Parent := vMame.Config.Scene.Right;
      vMame.Config.Scene.Right_Panels[vi].Width := vMame.Config.Scene.Right.Width;
      vMame.Config.Scene.Right_Panels[vi].Height := vMame.Config.Scene.Right.Height;
      vMame.Config.Scene.Right_Panels[vi].Position.X := 0;
      vMame.Config.Scene.Right_Panels[vi].Position.Y := 0;
      vMame.Config.Scene.Right_Panels[vi].Tag := vi;
      vMame.Config.Scene.Right_Panels[vi].Visible := False;
    end;
  end;
end;

procedure uEmu_Arcade_Mame_Config_ShowActivePanel(vShow: Integer);
begin
  uEmu_Arcade_Mame_Config_FreePreviewsPanel(mame_config_menu_panel);
  case vShow of
    0:
      begin
        uEmu_Arcade_Mame_Config_Create_Directories_Panel;
        vMame.Config.Scene.Right_Panels[0].Visible := True;
        extrafe.prog.State := 'mame_config_dirs';
        vMame.Config.Panel.Dirs.TabControl.TabIndex := 0;
        mame_config_menu_panel := 0;
      end;
    1:
      begin
        uEmu_Arcade_Mame_Config_Display.Load;
        vMame.Config.Scene.Right_Panels[1].Visible := True;
        extrafe.prog.State := 'mame_config_display';
        mame_config_menu_panel := 1;
      end;
    2:
      begin
        uEmu_Arcade_Mame_Config_Create_Advanced_Panel;
        vMame.Config.Scene.Right_Panels[2].Visible := True;
        extrafe.prog.State := 'mame_config_advanced';
        mame_config_menu_panel := 2;
      end;
    3:
      begin
        uEmu_Arcade_Mame_Config_Create_Screen_Panel;
        vMame.Config.Scene.Right_Panels[3].Visible := True;
        extrafe.prog.State := 'mame_config_screen';
        mame_config_menu_panel := 3;
      end;
    4:
      begin
        uEmu_Arcade_Mame_Config_Create_OpenGL_BGFX_Panel;
        vMame.Config.Scene.Right_Panels[4].Visible := True;
        extrafe.prog.State := 'mame_config_ogl_bgfx';
        mame_config_menu_panel := 4;
      end;
    5:
      begin
        uEmu_Arcade_Mame_Config_Create_OpenGL_Shaders_Panel;
        vMame.Config.Scene.Right_Panels[5].Visible := True;
        extrafe.prog.State := 'mame_config_ogl_shaders';
        mame_config_menu_panel := 5;
      end;
    6:
      begin
        uEmu_Arcade_Mame_Config_Create_Vector_Panel;
        vMame.Config.Scene.Right_Panels[6].Visible := True;
        extrafe.prog.State := 'mame_config_vector';
        mame_config_menu_panel := 6;
      end;
    7:
      begin
        uEmu_Arcade_Mame_Config_Create_Sound_Panel;
        vMame.Config.Scene.Right_Panels[7].Visible := True;
        extrafe.prog.State := 'mame_config_sound';
        mame_config_menu_panel := 7;
      end;
    8:
      begin
        uEmu_Arcade_Mame_Config_Create_Controllers_Panel;
        vMame.Config.Scene.Right_Panels[8].Visible := True;
        extrafe.prog.State := 'mame_config_controls';
        mame_config_menu_panel := 8;
      end;
    9:
      begin
        uEmu_Arcade_Mame_Config_Create_ControllerMapping_Panel;
        vMame.Config.Scene.Right_Panels[9].Visible := True;
        extrafe.prog.State := 'mame_config_controlmapping';
        mame_config_menu_panel := 9;
      end;
    10:
      begin
        uEmu_Arcade_Mame_Config_Create_Miscellaneous_Panel;
        vMame.Config.Scene.Right_Panels[10].Visible := True;
        extrafe.prog.State := 'mame_config_misc';
        mame_config_menu_panel := 10;
      end;
    11:
      begin
        uEmu_Arcade_Mame_Config_Create_MiscellaneousII_Panel;
        vMame.Config.Scene.Right_Panels[11].Visible := True;
        extrafe.prog.State := 'mame_config_miscII';
        mame_config_menu_panel := 11;
      end;
    12:
      begin
        uEmu_Arcade_Mame_Config_Create_Snap_Movie_Playback_Panel;
        vMame.Config.Scene.Right_Panels[12].Visible := True;
        extrafe.prog.State := 'mame_config_smp';
        mame_config_menu_panel := 12;
      end;
  end;
end;

end.
