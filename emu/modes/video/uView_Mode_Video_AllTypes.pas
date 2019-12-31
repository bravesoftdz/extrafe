unit uView_Mode_Video_AllTypes;

interface

uses
  System.Classes,
  FMX.Objects,
  FMX.Ani,
  FMX.Effects,
  FMX.Layouts,
  FMX.TabControl,
  FMX.Filter.Effects,
  FMX.Edit,
  FMX.StdCtrls,
  FMX.Listbox,
  FMX.Types,
  Radiant.Shapes,
  FmxPasLibVlcPlayerUnit,
  ALFMXLayouts;

{ Game list objects }
type
  TEMU_VIEW_MODE_VIDEO_GAMELIST_SEARCH = record
    Back: TImage;
    Search: TImage;
    Glow: TGlowEffect;
    Edit: TEdit;
    Edit_Ani: TFloatAnimation;
  end;

type
  TEMU_VIEW_MODE_VIDEO_GAMELIST_FILTERS_WINDOW_PANELS = record
    Panel: TPanel;
    Filter_Name: TText;
    Choose: TComboBox;
    Sec_Choose: TComboBox;
    Result: TText;
    Result_Num: TText;
    Result_Games: TText;
    Remove: TText;
    Remove_Glow: TGlowEffect;
  end;

type
  TEMU_VIEW_MODE_VIDEO_GAMELIST_FILTERS_WINDOW = record
    Panel: TPanel;
    Shadow: TShadowEffect;
    Clear: TText;
    Clear_Glow: TGlowEffect;
    Add: TText;
    Add_Glow: TGlowEffect;
    Info: TText;
    Games_Num: TText;
    Filter_Panels: array of TEMU_VIEW_MODE_VIDEO_GAMELIST_FILTERS_WINDOW_PANELS;
    OK: TButton;
    Cancel: TButton;
  end;

type
  TEMU_VIEW_MODE_VIDEO_GAMELIST_FILTERS = record
    Back: TImage;
    Filter: TText;
    Filter_Glow: TGlowEffect;
    Filter_Text: TText;
    Window: TEMU_VIEW_MODE_VIDEO_GAMELIST_FILTERS_WINDOW;
  end;

type
  TEMU_VIEW_MODE_VIDEO_GAMELIST_LISTS_LIST = record
    Image: TImage;
    OutLine: TRadiantRectangle;
    OutLine_Glow: TGlowEffect;
    Text: TText;
  end;

type
  TEMU_VIEW_MODE_VIDEO_GAMELIST_LISTS_WINDOW= record
    Panel: TLayout;
    Back: TImage;
    Add_Panel: TImage;
    Add: TText;
    Add_Glow: TGlowEffect;
    List_Control: TTabControl;
    List_Control_Item: array of TTabItem;
    List: array of TEMU_VIEW_MODE_VIDEO_GAMELIST_LISTS_LIST;
  end;

type
  TEMU_VIEW_MODE_VIDEO_GAMELIST_LISTS = record
    Back: TImage;
    Lists: TText;
    Lists_Glow: TGlowEffect;
    Lists_Text: TText;
    Window: TEMU_VIEW_MODE_VIDEO_GAMELIST_LISTS_WINDOW;
  end;

type
  TEMU_VIEW_MODE_VIDEO_GAMELIST_GAMES_LINE = record
    Back: TImage;
    Icon: TImage;
    Text: TText;
  end;

type
  TEMU_VIEW_MODE_VIDEO_GAMELIST_GAMES = record
    List: TImage;
    List_Blur: TBlurEffect;
    Listbox: TVertScrollBox;
    Line: array [0 .. 20] of TEMU_VIEW_MODE_VIDEO_GAMELIST_GAMES_LINE;
    Selection: TGlowEffect;
  end;

type
  TEMU_VIEW_MODE_VIDEO_GAMELIST_INFO = record
    Back: TImage;
    Games_Count: TText;
    Version: TText;
  end;

type
  TEMU_VIEW_MODE_VIDEO_GAMELIST = record
    Info: TEMU_VIEW_MODE_VIDEO_GAMELIST_INFO;
    Games: TEMU_VIEW_MODE_VIDEO_GAMELIST_GAMES;
    Lists: TEMU_VIEW_MODE_VIDEO_GAMELIST_LISTS;
    Filters: TEMU_VIEW_MODE_VIDEO_GAMELIST_FILTERS;
    Search: TEMU_VIEW_MODE_VIDEO_GAMELIST_SEARCH;
    Gamelist: TEMU_VIEW_MODE_VIDEO_GAMELIST_INFO;
  end;
  { End of Game list objects }

  { Media objects }
type
  TEMU_VIEW_MODE_VIDEO_MEDIA_ACTION_GAMEINFO = record
    Layout: TLayout;
    Players: TText;
    Players_Value: TText;
    Favorite: TText;
  end;

type
  TEMU_VIEW_MODE_VIDEO_MEDIA_BAR = record
    Back: TImage;
    Favorites: TText;
    Favorites_Glow: TGlowEffect;
  end;

type
  TEMU_VIEW_MODE_VIDEO_MEDIA_VIDEO = record
    Back: TImage;
    Game_Info: TEMU_VIEW_MODE_VIDEO_MEDIA_ACTION_GAMEINFO;
    Video: TFmxPasLibVlcPlayer;
    Video_Timer_Cont: TTimer;
  end;

type
  TEMU_VIEW_MODE_VIDEO_MEDIA = record
    Bar: TEMU_VIEW_MODE_VIDEO_MEDIA_BAR;
    Video: TEMU_VIEW_MODE_VIDEO_MEDIA_VIDEO;
  end;

  { End Of Media Objects }

  { Game menu Objects }
type
  TEMU_VIEW_MODE_GAMEMENU_INFO = record
    Layout: TLayout;
    Headline: TText;
    Line: TRadiantLine;
    Box: TALVertScrollBox;
    Text_Caption: array [0 .. 18] of TText;
    Text: array [0 .. 18] of TText;
  end;

type
  TEMU_VIEW_MODE_GAMEMENU_POPUP = record
    Back: TImage;
    Line1: TText;
    Line2: TText;
    Snap: TImage;
    Line3_Text: TText;
    Line3_Value: TText;
  end;

type
  TEMU_VIEW_MODE_GAMEMENU = record
    Stamp: TImage;
    Info: TEMU_VIEW_MODE_GAMEMENU_INFO;
    PopUp: TEMU_VIEW_MODE_GAMEMENU_POPUP;
  end;

  { End of Game menu Objects }

  { Configuration objects }

type
  TEMU_VIEW_MODE_VIDEO_CONFIGURATION = record
    Main: TPanel;
    Blur: TGaussianBlurEffect;
    Shadow: TShadowEffect;
  end;
  { End of Configuration objects }

type
  TEMU_VIEW_MODE_VIDEO = record
    Blur: TGaussianBlurEffect;
    Left: TImage;
    Left_Ani: TFloatAnimation;
    Left_Blur: TBlurEffect;
    Right: TImage;
    Right_Ani: TFloatAnimation;
    Right_Blur: TBlurEffect;
    Config: TEMU_VIEW_MODE_VIDEO_CONFIGURATION;
    Gamelist: TEMU_VIEW_MODE_VIDEO_GAMELIST;
    Media: TEMU_VIEW_MODE_VIDEO_MEDIA;
    GameMenu: TEMU_VIEW_MODE_GAMEMENU;
    Settings: TText;
    Settings_Ani: TFloatAnimation;
    Settings_Glow: TGlowEffect;
    Exit: TText;
    Exit_Glow: TGlowEffect;
  end;

var
  Emu_VM_Video: TEMU_VIEW_MODE_VIDEO;

implementation

end.
