unit uEmu_Arcade_Mame_Mouse;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UiTypes,
  FMX.StdCtrls,
  FMX.Ani,
  FMX.Objects,
  FMX.ListBox,
  BASS;

type
  TEMU_ARCADE_MAME_ANIMATION = class(TObject)
    procedure OnFinish(Sender: TObject);
  end;

type
  TEMU_ARCADE_MAME_IMAGE = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TEMU_ARCADE_MAME_TEXT = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TEMU_ARCADE_MAME_BUTTON = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TEMU_ARCADE_MAME_COMBOBOX = class(TObject)
    procedure OnChange(Sender: TObject);
  end;

type
  TEMU_ARCADE_MAME_MOUSE = record
    Animation: TEMU_ARCADE_MAME_ANIMATION;
    Image: TEMU_ARCADE_MAME_IMAGE;
    Text: TEMU_ARCADE_MAME_TEXT;
    Button: TEMU_ARCADE_MAME_BUTTON;
    ComboBox: TEMU_ARCADE_MAME_COMBOBOX;
  end;

implementation

uses
  uLoad_AllTypes,
  uEmu_Arcade_Mame,
  uEmu_Arcade_Mame_Actions,
  uEmu_Arcade_Mame_AllTypes,
  uEmu_Arcade_Mame_Config,
  uEmu_Arcade_Mame_Filters;

{ TEMU_ARCADE_MAME_IMAGE }

procedure TEMU_ARCADE_MAME_IMAGE.OnMouseClick(Sender: TObject);
begin
  if TImage(Sender).Name = 'Mame_Gamelist_Search_Image' then
    uEmu_Arcade_Mame_Actions.Open_Search
  else if TImage(Sender).Name = 'Mame_Exit' then
    uEmu_Arcade_Mame.Exit;
end;

procedure TEMU_ARCADE_MAME_IMAGE.OnMouseEnter(Sender: TObject);
begin
  if TImage(Sender).Name = 'Mame_Gamelist_Search_Image' then
    vMame.Scene.Gamelist.Search_Glow.Enabled := True
  else if TImage(Sender).Name = 'Mame_Exit' then
    vMame.Scene.Exit_Mame_Glow.Enabled := True;
end;

procedure TEMU_ARCADE_MAME_IMAGE.OnMouseLeave(Sender: TObject);
begin
  if TImage(Sender).Name = 'Mame_Gamelist_Search_Image' then
    vMame.Scene.Gamelist.Search_Glow.Enabled := False
  else if TImage(Sender).Name = 'Mame_Exit' then
    vMame.Scene.Exit_Mame_Glow.Enabled := False;
end;

{ TEMU_ARCADE_MAME_ANIMATION }

procedure TEMU_ARCADE_MAME_ANIMATION.OnFinish(Sender: TObject);
begin
  TFloatAnimation(Sender).Enabled := False;
end;

{ TEMU_ARCADE_MAME_BUTTON }

procedure TEMU_ARCADE_MAME_BUTTON.OnMouseClick(Sender: TObject);
begin
  if extrafe.prog.State = 'mame_filters' then
  begin
    if TButton(Sender).Name = 'Mame_Window_Filters_Cancel' then
      uEmu_Arcade_Mame_Filters.Free
    else if TButton(Sender).Name = 'Mame_Window_Filters_OK' then
      uEmu_Arcade_Mame_Filters.Return
    else if TButton(Sender).Name = 'Mame_Window_Filters_Add' then
      uEmu_Arcade_Mame_Filters.Add
    else if TButton(Sender).Name = 'Mame_Window_Filters_Filter_Remove_' + TButton(Sender).Tag.ToString then
      uEmu_Arcade_Mame_Filters.Remove(TButton(Sender).Tag);

  end
  else
  begin
    if TButton(Sender).Name = 'Mame_Config_Button_0' then
      uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
    else if TButton(Sender).Name = 'Mame_Config_Button_1' then
      uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
    else if TButton(Sender).Name = 'Mame_Config_Button_2' then
      uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
    else if TButton(Sender).Name = 'Mame_Config_Button_3' then
      uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
    else if TButton(Sender).Name = 'Mame_Config_Button_4' then
      uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
    else if TButton(Sender).Name = 'Mame_Config_Button_5' then
      uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
    else if TButton(Sender).Name = 'Mame_Config_Button_6' then
      uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
    else if TButton(Sender).Name = 'Mame_Config_Button_7' then
      uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
    else if TButton(Sender).Name = 'Mame_Config_Button_8' then
      uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
    else if TButton(Sender).Name = 'Mame_Config_Button_9' then
      uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
    else if TButton(Sender).Name = 'Mame_Config_Button_10' then
      uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
    else if TButton(Sender).Name = 'Mame_Config_Button_11' then
      uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
    else if TButton(Sender).Name = 'Mame_Config_Button_12' then
      uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
  end;
end;

procedure TEMU_ARCADE_MAME_BUTTON.OnMouseEnter(Sender: TObject);
begin

end;

procedure TEMU_ARCADE_MAME_BUTTON.OnMouseLeave(Sender: TObject);
begin

end;

{ TEMU_ARCADE_MAME_TEXT }

procedure TEMU_ARCADE_MAME_TEXT.OnMouseClick(Sender: TObject);
begin
  if TText(Sender).Name = 'Mame_Settings' then
    uEmu_Arcade_Mame_Actions_OpenGlobalConfiguration
  else if TImage(Sender).Name = 'Mame_Gamelist_Filters_Image' then
    uEmu_Arcade_Mame_Actions.Open_Filters;
  BASS_ChannelPlay(sound.str_fx.general[0], False);
end;

procedure TEMU_ARCADE_MAME_TEXT.OnMouseEnter(Sender: TObject);
begin
  TText(Sender).Cursor := crHandPoint;
  if TText(Sender).Name = 'Mame_Settings' then
    vMame.Scene.Settings_Glow.Enabled := True
  else if TImage(Sender).Name = 'Mame_Gamelist_Filters_Image' then
    vMame.Scene.Gamelist.Filters.Icon_Glow.Enabled := True;
end;

procedure TEMU_ARCADE_MAME_TEXT.OnMouseLeave(Sender: TObject);
begin
  if TText(Sender).Name = 'Mame_Settings' then
    vMame.Scene.Settings_Glow.Enabled := False
  else if TImage(Sender).Name = 'Mame_Gamelist_Filters_Image' then
    vMame.Scene.Gamelist.Filters.Icon_Glow.Enabled := False;
end;

{ TEMU_ARCADE_MAME_COMBOBOX }

procedure TEMU_ARCADE_MAME_COMBOBOX.OnChange(Sender: TObject);
begin
  if extrafe.prog.State = 'mame_filters' then
  begin
    if mame.Filters.Compo_Done = False then
    begin
      if TComboBox(Sender).Name = 'Mame_Window_Filters_Filter_Combo_' + TComboBox(Sender).Tag.ToString then
        uEmu_Arcade_Mame_Filters.Second_Choose(TComboBox(Sender).Items.Strings[TComboBox(Sender).ItemIndex], TComboBox(Sender).Tag)
      else if TComboBox(Sender).Name = 'Mame_Window_Filters_Filter_Combo_' + TComboBox(Sender).TagString then
        uEmu_Arcade_Mame_Filters.Filter_Result(TComboBox(Sender).TagString, TComboBox(Sender).Items.Strings[TComboBox(Sender).ItemIndex],
          TComboBox(Sender).Tag);
    end;
  end;
end;

initialization

mame.Input.Mouse.Animation := TEMU_ARCADE_MAME_ANIMATION.Create;
mame.Input.Mouse.Image := TEMU_ARCADE_MAME_IMAGE.Create;
mame.Input.Mouse.Text := TEMU_ARCADE_MAME_TEXT.Create;
mame.Input.Mouse.Button := TEMU_ARCADE_MAME_BUTTON.Create;
mame.Input.Mouse.ComboBox := TEMU_ARCADE_MAME_COMBOBOX.Create;

finalization

mame.Input.Mouse.Animation.Free;
mame.Input.Mouse.Image.Free;
mame.Input.Mouse.Text.Free;
mame.Input.Mouse.Button.Free;
mame.Input.Mouse.ComboBox.Free;

end.
