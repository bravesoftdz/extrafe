unit uEmu_Arcade_Mame_Mouse;

interface
uses
  System.Classes,
  FMX.StdCtrls,
  FMX.Ani,
  FMX.Objects;

  type TEMU_ARCADE_MAME_ANIMATION= class(TObject)
    procedure OnFinish(Sender: TObject);
  end;

  type TEMU_ARCADE_MAME_IMAGE= class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

  type TEMU_ARCADE_MAME_BUTTON= class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

  type TEMU_ARCADE_MAME_MOUSE= record
    Animation: TEMU_ARCADE_MAME_ANIMATION;
    Image: TEMU_ARCADE_MAME_IMAGE;
    Button: TEMU_ARCADE_MAME_BUTTON;
  end;

implementation
uses
  uEmu_Arcade_Mame,
  uEmu_Arcade_Mame_Actions,
  uEmu_Arcade_Mame_AllTypes,
  uEmu_Arcade_Mame_Config;


{ TEMU_ARCADE_MAME_IMAGE }

procedure TEMU_ARCADE_MAME_IMAGE.OnMouseClick(Sender: TObject);
begin
  if TImage(Sender).Name= 'Mame_Gamelist_Search_Image' then
    uEmu_Arcade_Mame_Actions_OpenSearch
  else if TImage(Sender).Name= 'Mame_Gamelist_Filters_Image' then
    uEmu_Arcade_Mame_Actions_OpenFilters
  else if TImage(Sender).Name= 'Mame_Settings' then
    uEmu_Arcade_Mame_Actions_OpenGlobalConfiguration
  else if TImage(Sender).Name= 'Mame_Exit' then
    uEmu_Arcade_Mame_Exit;
end;

procedure TEMU_ARCADE_MAME_IMAGE.OnMouseEnter(Sender: TObject);
begin
  if TImage(Sender).Name= 'Mame_Gamelist_Search_Image' then
    vMame.Scene.Gamelist.Search_Glow.Enabled:= True
  else if TImage(Sender).Name= 'Mame_Gamelist_Filters_Image' then
    vMame.Scene.Gamelist.Filters_Glow.Enabled:= True
  else if TImage(Sender).Name= 'Mame_Settings' then
    vMame.Scene.Settings_Glow.Enabled:= True
  else if TImage(Sender).Name= 'Mame_Exit' then
    vMame.Scene.Exit_Mame_Glow.Enabled:= True;
end;

procedure TEMU_ARCADE_MAME_IMAGE.OnMouseLeave(Sender: TObject);
begin
  if TImage(Sender).Name= 'Mame_Gamelist_Search_Image' then
    vMame.Scene.Gamelist.Search_Glow.Enabled:= False
  else if TImage(Sender).Name= 'Mame_Gamelist_Filters_Image' then
    vMame.Scene.Gamelist.Filters_Glow.Enabled:= False
  else if TImage(Sender).Name= 'Mame_Settings' then
    vMame.Scene.Settings_Glow.Enabled:= False
  else if TImage(Sender).Name= 'Mame_Exit' then
    vMame.Scene.Exit_Mame_Glow.Enabled:= False;
end;

{ TEMU_ARCADE_MAME_ANIMATION }

procedure TEMU_ARCADE_MAME_ANIMATION.OnFinish(Sender: TObject);
begin
  TFloatAnimation(Sender).Enabled:= False;
end;

{ TEMU_ARCADE_MAME_BUTTON }

procedure TEMU_ARCADE_MAME_BUTTON.OnMouseClick(Sender: TObject);
begin
  if TButton(Sender).Name= 'Mame_Config_Button_0' then
    uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
  else if TButton(Sender).Name= 'Mame_Config_Button_1' then
    uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
  else if TButton(Sender).Name= 'Mame_Config_Button_2' then
    uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
  else if TButton(Sender).Name= 'Mame_Config_Button_3' then
    uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
  else if TButton(Sender).Name= 'Mame_Config_Button_4' then
    uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
  else if TButton(Sender).Name= 'Mame_Config_Button_5' then
    uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
  else if TButton(Sender).Name= 'Mame_Config_Button_6' then
    uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
  else if TButton(Sender).Name= 'Mame_Config_Button_7' then
    uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
  else if TButton(Sender).Name= 'Mame_Config_Button_8' then
    uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
  else if TButton(Sender).Name= 'Mame_Config_Button_9' then
    uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
  else if TButton(Sender).Name= 'Mame_Config_Button_10' then
    uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
  else if TButton(Sender).Name= 'Mame_Config_Button_11' then
    uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
  else if TButton(Sender).Name= 'Mame_Config_Button_12' then
    uEmu_Arcade_Mame_Config_ShowActivePanel(TButton(Sender).Tag)
end;

procedure TEMU_ARCADE_MAME_BUTTON.OnMouseEnter(Sender: TObject);
begin

end;

procedure TEMU_ARCADE_MAME_BUTTON.OnMouseLeave(Sender: TObject);
begin

end;

end.
