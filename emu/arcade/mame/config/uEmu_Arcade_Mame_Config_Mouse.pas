unit uEmu_Arcade_Mame_Config_Mouse;

interface

uses
  System.Classes,
  System.StrUtils,
  System.UITypes,
  System.UIConsts,
  FMX.StdCtrls,
  FMX.Listbox,
  FMX.TabControl,
  FMX.Objects,
  FMX.Graphics;

type
  TEMU_ARCADE_MAME_CONFIG_SPEEDBUTTON = class(TObject)
    procedure onMouseClick(Sender: TObject);
    procedure onMouseEnter(Sender: TObject);
    procedure onMouseLeave(Sender: TObject);
  end;

type
  TEMU_ARCADE_MAME_CONFIG_TEXT = class(TObject)
    procedure onMouseClick(Sender: TObject);
    procedure onMouseEnter(Sender: TObject);
    procedure onMouseLeave(Sender: TObject);
  end;

type
  TEMU_ARCADE_MAME_CONFIG_TRACKBAR = class(TObject)
    procedure OnChange(Sender: TObject);
    procedure onMouseEnter(Sender: TObject);
    procedure onMouseLeave(Sender: TObject);
  end;

type
  TEMU_ARCADE_MAME_CONFIG_CHECKBOX = class(TObject)
    procedure onMouseClick(Sender: TObject);
    procedure onMouseEnter(Sender: TObject);
    procedure onMouseLeave(Sender: TObject);
  end;

type
  TEMU_ARCADE_MAME_CONFIG_COMBOBOX = class(TObject)
    procedure OnChange(Sender: TObject);
    procedure onMouseEnter(Sender: TObject);
    procedure onMouseLeave(Sender: TObject);
  end;

type
  TEMU_ARCADE_MAME_CONFIG_BUTTON = class(TObject)
    procedure onMouseClick(Sender: TObject);
    procedure onMouseEnter(Sender: TObject);
    procedure onMouseLeave(Sender: TObject);
  end;

type
  TEMU_ARCADE_MAME_CONFIG_OPENDIALOG = class(TObject)
    procedure OnClose(Sender: TObject);
    procedure onMouseEnter(Sender: TObject);
    procedure onMouseLeave(Sender: TObject);
  end;

type
  TEMU_ARCADE_MAME_CONFIG_TABITEM = class(TObject)
    procedure onMouseClick(Sender: TObject);
    procedure onMouseEnter(Sender: TObject);
    procedure onMouseLeave(Sender: TObject);
  end;

type
  TEMU_ARCADE_MAME_CONFIG_MOUSE = record
    SpeedButton: TEMU_ARCADE_MAME_CONFIG_SPEEDBUTTON;
    Text: TEMU_ARCADE_MAME_CONFIG_TEXT;
    Trackbar: TEMU_ARCADE_MAME_CONFIG_TRACKBAR;
    Checkbox: TEMU_ARCADE_MAME_CONFIG_CHECKBOX;
    Combobox: TEMU_ARCADE_MAME_CONFIG_COMBOBOX;
    Button: TEMU_ARCADE_MAME_CONFIG_BUTTON;
    OpenDialog: TEMU_ARCADE_MAME_CONFIG_OPENDIALOG;
    TabItem: TEMU_ARCADE_MAME_CONFIG_TABITEM;
  end;

implementation

uses
  uLoad_AllTypes,
  uEmu_Arcade_Mame_AllTypes,
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

{ TEMU_ARCADE_MAME_CONFIG_BUTTON }
procedure TEMU_ARCADE_MAME_CONFIG_SPEEDBUTTON.onMouseClick(Sender: TObject);
begin
  if extrafe.prog.State = 'mame_config_media' then
  begin
    if ContainsText(TSpeedButton(Sender).Name, 'Mame_Dir_Media_Change_') then
      uEmu_Arcade_Mame_Config_Media_Find(TSpeedButton(Sender).Tag)
  end
  else if extrafe.prog.State = 'mame_config_dirs' then
  begin
    if TSpeedButton(Sender).Name = 'Mame_Dir_Roms_Add_Button' then
      uEmu_Arcade_Mame_Config_Roms_Find
    else if TSpeedButton(Sender).TagFloat= 10 then
      uEmu_Arcade_Mame_Config_RomPath_Delete(TSpeedButton(Sender).Tag);
  end;
end;

procedure TEMU_ARCADE_MAME_CONFIG_SPEEDBUTTON.onMouseEnter(Sender: TObject);
begin

end;

procedure TEMU_ARCADE_MAME_CONFIG_SPEEDBUTTON.onMouseLeave(Sender: TObject);
begin

end;

{ TEMU_ARCADE_MAME_CONFIG_BUTTON }
procedure TEMU_ARCADE_MAME_CONFIG_BUTTON.onMouseClick(Sender: TObject);
begin
  if extrafe.prog.State = 'mame_config_advanced' then
    uEmu_Arcade_Mame_Config_Advanced_ButtonClick(TButton(Sender).Name)
  else if extrafe.prog.State = 'mame_config_ogl_bgfx' then
    uEmu_Arcade_Mame_Config_OpenGL_BGFX_ButtonClick(TButton(Sender).Name)
  else if extrafe.prog.State = 'mame_config_ogl_shaders' then
    uEmu_Arcade_Mame_Config_OpenGL_Shaders_ButtonClick(TButton(Sender).Name)
  else if extrafe.prog.State = 'mame_config_controls' then
    uEmu_Arcade_Mame_Config_Controllers_ButtonClick(TButton(Sender).Name)
  else if extrafe.prog.State = 'mame_config_misc' then
    uEmu_Arcade_Mame_Config_Misc_ButtonClick(TButton(Sender).Name)
  else if extrafe.prog.State = 'mame_config_miscII' then
    uEmu_Arcade_Mame_Config_MiscII_ButtonClick(TButton(Sender).Name);
end;

procedure TEMU_ARCADE_MAME_CONFIG_BUTTON.onMouseEnter(Sender: TObject);
begin

end;

procedure TEMU_ARCADE_MAME_CONFIG_BUTTON.onMouseLeave(Sender: TObject);
begin

end;

{ TEMU_ARCADE_MAME_CONFIG_TEXT }
procedure TEMU_ARCADE_MAME_CONFIG_TEXT.onMouseClick(Sender: TObject);
begin
  if extrafe.prog.State = 'mame_config_media' then
    uEmu_Arcade_Mame_Config_CheckAndDowload(TText(Sender).Tag);
end;

procedure TEMU_ARCADE_MAME_CONFIG_TEXT.onMouseEnter(Sender: TObject);
begin
  TText(Sender).TextSettings.Font.Style := TText(Sender).TextSettings.Font.Style + [TFontStyle.fsUnderline];
  TText(Sender).TextSettings.FontColor := claDeepskyblue;
  TText(Sender).Cursor := crHandPoint;
end;

procedure TEMU_ARCADE_MAME_CONFIG_TEXT.onMouseLeave(Sender: TObject);
begin
  TText(Sender).TextSettings.Font.Style := TText(Sender).TextSettings.Font.Style - [TFontStyle.fsUnderline];
  if (extrafe.Style.Name = 'Amakrits') or (extrafe.Style.Name = 'Dark') or (extrafe.Style.Name = 'Air') then
    TText(Sender).TextSettings.FontColor := claWhite
  else
    TText(Sender).TextSettings.FontColor := claBlack;
  TText(Sender).Cursor := crDefault;
end;

{ TEMU_ARCADE_MAME_CONFIG_TRACKBAR }
procedure TEMU_ARCADE_MAME_CONFIG_TRACKBAR.OnChange(Sender: TObject);
begin
  if extrafe.prog.State = 'mame_config_display' then
    uEmu_Arcade_Mame_Config_Display_TrackbarChange(TTrackBar(Sender).Name)
  else if extrafe.prog.State = 'mame_config_advanced' then
    uEmu_Arcade_Mame_Config_Advanced_TrackbarChange(TTrackBar(Sender).Name)
  else if extrafe.prog.State = 'mame_config_screen' then
    uEmu_Arcade_Mame_Config_Screen_TrackbarOnChange(TTrackBar(Sender).Name)
  else if extrafe.prog.State = 'mame_config_vector' then
    uEmu_Arcade_Mame_Config_Vector_TrackbarChange(TTrackBar(Sender).Name)
  else if extrafe.prog.State = 'mame_config_sound' then
    uEmu_Arcade_Mame_Config_Sound_TrackbarOnChange(TTrackBar(Sender).Name)
  else if extrafe.prog.State = 'mame_config_controls' then
    uEmu_Arcade_Mame_Config_Controllers_TrackbarOnChange(TTrackBar(Sender).Name)
  else if extrafe.prog.State = 'mame_config_misc' then
    uEmu_Arcade_Mame_Config_Misc_TrackbarOnChange(TTrackBar(Sender).Name)
  else if extrafe.prog.State = 'mame_config_miscII' then
    uEmu_Arcade_Mame_Config_MiscII_TrackbarOnChange(TTrackBar(Sender).Name);

end;

procedure TEMU_ARCADE_MAME_CONFIG_TRACKBAR.onMouseEnter(Sender: TObject);
begin

end;

procedure TEMU_ARCADE_MAME_CONFIG_TRACKBAR.onMouseLeave(Sender: TObject);
begin

end;

{ TEMU_ARCADE_MAME_CONFIG_CHECKBOX }
procedure TEMU_ARCADE_MAME_CONFIG_CHECKBOX.onMouseClick(Sender: TObject);
begin
  if extrafe.prog.State = 'mame_config_display' then
    uEmu_Arcade_Mame_Config_Display_CheckboxClick(TCheckBox(Sender).Name)
  else if extrafe.prog.State = 'mame_config_advanced' then
    uEmu_Arcade_Mame_Config_Advanced_CheckboxClick(TCheckBox(Sender).Name)
  else if extrafe.prog.State = 'mame_config_screen' then
    uEmu_Arcade_Mame_Config_Screen_CheckboxClick(TCheckBox(Sender).Name)
  else if extrafe.prog.State = 'mame_config_ogl_bgfx' then
    uEmu_Arcade_Mame_Config_OpenGL_BGFX_CheckboxClick(TCheckBox(Sender).Name)
  else if extrafe.prog.State = 'mame_config_sound' then
    uEmu_Arcade_Mame_Config_Sound_CheckboxClick(TCheckBox(Sender).Name)
  else if extrafe.prog.State = 'mame_config_controls' then
    uEmu_Arcade_Mame_Config_Controllers_CheckboxClick(TCheckBox(Sender).Name)
  else if extrafe.prog.State = 'mame_config_misc' then
    uEmu_Arcade_Mame_Config_Misc_CheckboxClick(TCheckBox(Sender).Name)
  else if extrafe.prog.State = 'mame_config_miscII' then
    uEmu_Arcade_Mame_Config_MiscII_CheckboxClick(TCheckBox(Sender).Name)
  else if extrafe.prog.State = 'mame_config_smp' then
    uEmu_Arcade_Mame_Config_SMP_CheckboxClick(TCheckBox(Sender).Name);
end;

procedure TEMU_ARCADE_MAME_CONFIG_CHECKBOX.onMouseEnter(Sender: TObject);
begin

end;

procedure TEMU_ARCADE_MAME_CONFIG_CHECKBOX.onMouseLeave(Sender: TObject);
begin

end;

{ TEMU_ARCADE_MAME_CONFIG_COMBOBOX }
procedure TEMU_ARCADE_MAME_CONFIG_COMBOBOX.OnChange(Sender: TObject);
begin
  if extrafe.prog.State = 'mame_config_display' then
    uEmu_Arcade_Mame_Config_Display_ComboboxChange(TComboBox(Sender).Name)
  else if extrafe.prog.State = 'mame_config_screen' then
    uEmu_Arcade_Mame_Config_Screen_ComboboxOnChange(TComboBox(Sender).Name)
  else if extrafe.prog.State = 'mame_config_ogl_bgfx' then
    uEmu_Arcade_Mame_Config_OpenGL_BGFX_ComboboxOnChange(TComboBox(Sender).Name)
  else if extrafe.prog.State = 'mame_config_sound' then
    uEmu_Arcade_Mame_Config_Sound_ComboboxOnChange(TComboBox(Sender).Name)
  else if extrafe.prog.State = 'mame_config_controls' then
    uEmu_Arcade_Mame_Config_Controllers_ComboboxOnChange(TComboBox(Sender).Name)
  else if extrafe.prog.State = 'mame_config_controlmapping' then
    uEmu_Arcade_Mame_Config_ControllerMapping_SetContMapping(TComboBox(Sender).ItemIndex,
      TComboBox(Sender).Tag)
  else if extrafe.prog.State = 'mame_config_misc' then
    uEmu_Arcade_Mame_Config_Misc_ComboboxOnChange(TComboBox(Sender).Name)
  else if extrafe.prog.State = 'mame_config_miscII' then
    uEmu_Arcade_Mame_Config_MiscII_ComboboxOnChange(TComboBox(Sender).Name)
  else if extrafe.prog.State = 'mame_config_smp' then
    uEmu_Arcade_Mame_Config_SMP_ComboboxOnChange(TComboBox(Sender).Name);
end;

procedure TEMU_ARCADE_MAME_CONFIG_COMBOBOX.onMouseEnter(Sender: TObject);
begin

end;

procedure TEMU_ARCADE_MAME_CONFIG_COMBOBOX.onMouseLeave(Sender: TObject);
begin

end;

{ TEMU_ARCADE_MAME_CONFIG_OPENDIALOG }
procedure TEMU_ARCADE_MAME_CONFIG_OPENDIALOG.OnClose(Sender: TObject);
begin
  if extrafe.prog.State = 'mame_config_advanced' then
    uEmu_Arcade_Mame_Config_Advanced_OpenDialogOnClose
  else if extrafe.prog.State = 'mame_config_ogl_bgfx' then
    uEmu_Arcade_Mame_Config_OpenGL_BGFX_OpenDialogOnClose
  else if extrafe.prog.State = 'mame_config_ogl_shaders' then
    uEmu_Arcade_Mame_Config_OpenGL_Shaders_OpenDialog
  else if extrafe.prog.State = 'mame_config_misc' then
    uEmu_Arcade_Mame_Config_Misc_OpenDialog
  else if extrafe.prog.State = 'mame_config_miscII' then
    uEmu_Arcade_Mame_Config_MiscII_Opendialog;
end;

procedure TEMU_ARCADE_MAME_CONFIG_OPENDIALOG.onMouseEnter(Sender: TObject);
begin

end;

procedure TEMU_ARCADE_MAME_CONFIG_OPENDIALOG.onMouseLeave(Sender: TObject);
begin

end;

{ TEMU_ARCADE_MAME_CONFIG_TABITEM }

procedure TEMU_ARCADE_MAME_CONFIG_TABITEM.onMouseClick(Sender: TObject);
begin
  if (extrafe.prog.State = 'mame_config_dirs') or (extrafe.prog.State = 'mame_config_media') then
    uEmu_Arcade_Mame_Config_Directories_TabItemClick(TTabItem(Sender).Name);
end;

procedure TEMU_ARCADE_MAME_CONFIG_TABITEM.onMouseEnter(Sender: TObject);
begin

end;

procedure TEMU_ARCADE_MAME_CONFIG_TABITEM.onMouseLeave(Sender: TObject);
begin

end;

end.
