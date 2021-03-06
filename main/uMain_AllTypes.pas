unit uMain_AllTypes;

interface

uses
  System.Classes,
  System.SysUtils,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Effects,
  FMX.Ani,
  FMX.Filter.Effects,
  FMX.Edit,
  FMX.Memo,
  FMX.TabControl,
  FMX.Grid,
  FMX.Dialogs,
  FMX.ImgList,
  FMX.Types,
  FMX.Layouts,
  FMX.Controls,
  FMX.Listbox,
  FMX.ViewPort3d,
  FMX.Objects3d,
  FMX.MaterialSources,
  FMX.Controls3d,
  FMX.OBJ.Importer,
  FMX.Types3d,
  FMX.Layers3D,
  ALFMXObjects,
  IdHTTP,
  IdComponent,
  uMain_Mouse,
  BASS;

type
  TMAIN_POSITIONS = Record
    X: Single;
    Y: Single;
  end;

type
  TMAIN_PATHS = record
    Images: String;
    Config_Images: String;
    Avatar_Images: String;
    Flags_Images: String;
    Sounds: String;
  end;

type
  TMAIN_SETTINGS = record
    Header_Pos: TMAIN_POSITIONS;
    MainSelection_Pos: TMAIN_POSITIONS;
    Footer_Pos: TMAIN_POSITIONS;
    Config_Pos: TMAIN_POSITIONS;
  end;

type
  TMAIN_CONFIG = record
    Active_Panel: Integer;
    Emulators_Active_Tab: Integer;
    Addons_Active_Tab: Integer;
    Addons_Tab_First: Integer;
    Addons_Tab_Last: Integer;
    Info_Credits_Tab_Selected: Integer;
    Info_Credits_Selected: Integer;
  end;

type
  TMAIN_SOUNDS = record
    Effects: array [0 .. 100] of HSAMPLE;
    mouse: array [0 .. 100] of HSAMPLE;
  end;

type
  TMAIN = record
    Paths: TMAIN_PATHS;
    Settings: TMAIN_SETTINGS;
    Input: TMAIN_INPUT;
    Config: TMAIN_CONFIG;
  end;

  /// /////////////////////////////////////////////////////////////////////////////
  /// Construction
type
  TMAIN_EXIT_MAIN = record
    Panel: TPanel;
    Logo: TImage;
    Text: TText;
    Yes: TButton;
    No: TButton;
  end;

type
  TMAIN_EXIT_PROGRAM = record
    Panel: TPanel;
    Panel_Shadow: TShadowEffect;
    Main: TMAIN_EXIT_MAIN;
  end;

type
  TMAIN_MAIN = record
    Back: TImage;
    Down_Level: TImage;
    Down_Level_Ani: TFloatAnimation;
    Up_Level: TImage;
    Style: TStyleBook;
    Timer: TTimer;
    Prog_Exit: TMAIN_EXIT_PROGRAM;
  end;

type
  TMAIN_HEADER_ADDON_ICONS = record
    Frame: array [0 .. 9] of TLayout;
    Icons: array [0 .. 9] of TText;
    Glow: array [0 .. 9] of TGlowEffect;
    Blur: array [0 .. 9] of TGaussianBlurEffect;
  end;

type
  TMAIN_HEADER = record
    Back: TImage;
    Back_Blur: TGaussianBlurEffect;
    Exit: TImage;
    Exit_Glow: TGlowEffect;
    Exit_Grey: TMonochromeEffect;
    Minimize: TImage;
    Minimize_Glow: TGlowEffect;
    Minimize_Grey: TMonochromeEffect;
    Avatar: TImage;
    Avatar_Glow: TGlowEffect;
    Addon_Icon: TMAIN_HEADER_ADDON_ICONS;
  end;

type
  TMAIN_WIDGET_CALENDAR = record
    Panel: TLayout;
    Panel_Glow: TInnerGlowEffect;
    Icon: TText;
    Text: TText;
    Above: TPanel;
  end;

type
  TMAIN_WIDGET_TIME = record
    Panel: TLayout;
    Icon: TText;
    Text: TText;
  end;

type
  TMAIN_WIDGETS = record
    Time: TMAIN_WIDGET_TIME;
    Calendar: TMAIN_WIDGET_CALENDAR;
  end;

type
  TMAIN_FOOTER = record
    Back: TImage;
    Back_Ani: TFloatAnimation;
    Back_Blur: TGaussianBlurEffect;
    Back_Line: TImage;
    GridPanel: TGridPanelLayout;
    Settings: TText;
    Settings_Ani: TFloatAnimation;
    Settings_Glow: TGlowEffect;
    Widgets: TMAIN_WIDGETS;
    Timer: TTimer;
  end;

type
  TMAIN_SELECTION = record
    Back: TImage;
    Line: TImage;
    Blur: TGaussianBlurEffect;
  end;

type
  TMAIN_CONFIG_LEFT = record
    Button: array [0 .. 6] of TButton;
  end;

type
  TMAIN_CONFIG_PROFILE_USER_AVATAR_MAIN = record
    Panel: TPanel;
    Control: TTabControl;
    Tabs: array of TTabItem;
    Avatar: array of TImage;
    Avatar_Glow: array of TGlowEffect;
    Avatar_Check: array of TText;
    Arrow_Left: TText;
    Arrow_Left_Glow: TGlowEffect;
    Arrow_Right: TText;
    Arrow_Right_Glow: TGlowEffect;
    Page_Info: TLabel;
    Change: TButton;
    Cancel: TButton;
  end;

type
  TMAIN_CONFIG_PROFILE_USER_AVATAR = record
    Panel: TPanel;
    Main: TMAIN_CONFIG_PROFILE_USER_AVATAR_MAIN;
  end;

type
  TMAIN_CONFIG_PROFILE_USER_PASSWORD_MAIN = record
    Panel: TPanel;
    Current: TLabel;
    Current_V: TEdit;
    New: TLabel;
    New_V: TEdit;
    New_Rewrite: TLabel;
    New_Rewrite_V: TEdit;
    Warning: TLabel;
    Change: TButton;
    Cancel: TButton;
  end;

type
  TMAIN_CONFIG_PROFILE_USER_PASSWORD = record
    Panel: TPanel;
    Main: TMAIN_CONFIG_PROFILE_USER_PASSWORD_MAIN;
  end;

type
  TMAIN_CONFIG_PROFILE_USER = record
    Panel: TPanel;
    Avatar_Show: TImage;
    Avatar_Show_Glow: TGlowEffect;
    Avatar_Change: TText;
    Username: TLabel;
    Username_V: TEdit;
    Password: TLabel;
    Password_V: TEdit;
    Password_Change: TText;
    Personal: TGroupBox;
    Name: TLabel;
    Name_V: TEdit;
    Surname: TLabel;
    Surname_V: TEdit;
    Country: TImage;
    Country_Name: TLabel;
    Email: TText;
    Email_Dir: TText;
    Gender_Male: TText;
    Gender_Male_Glow: TGlowEffect;
    Gender_Female: TText;
    Gender_Female_Glow: TGlowEffect;
    Apply_Changes: TButton;
    Status: TGroupBox;
    Active_Led: TCircle;
    Active_Text: TText;
    Last_Active_Online: TText;
    Created: TText;
    Avatar: TMAIN_CONFIG_PROFILE_USER_AVATAR;
    Pass: TMAIN_CONFIG_PROFILE_USER_PASSWORD;
  end;

type
  TMAIN_CONFIG_PROFILE_STATISTICS = record

  end;

type
  TCONFIG_PROFILE_MACHINE_OS = record
    Box: TGroupBox;
    Info: TLabel;
    Info_V: TLabel;
    Architecture: TLabel;
    Architecture_V: TLabel;
    VPlatform: TLabel;
    VPlatform_V: TLabel;
    Operating_System: TLabel;
    Operating_System_V: TLabel;
    Major: TLabel;
    Major_V: TLabel;
    Minor: TLabel;
    Minor_V: TLabel;
    Build: TLabel;
    Build_V: TLabel;
  end;

type
  TCONFIG_PROFILE_MACHINE_INTERNET = record
    Box: TGroupBox;
    Internet: TLabel;
    Internet_V: TLabel;
    Local_IP: TLabel;
    Local_IP_V: TLabel;
    Public_IP: TLabel;
    Public_IP_V: TLabel;
  end;

type
  TMAIN_CONFIG_PROFILE_MACHINE = record
    Panel: TPanel;
    OS: TCONFIG_PROFILE_MACHINE_OS;
    Net: TCONFIG_PROFILE_MACHINE_INTERNET;
  end;

type
  TMAIN_CONFIG_PROFILE = record
    Panel: TPanel;
    Blur: TGaussianBlurEffect;
    TabControl: TTabControl;
    TabItem: array [0 .. 2] of TTabItem;
    User: TMAIN_CONFIG_PROFILE_USER;
    Statistics: TMAIN_CONFIG_PROFILE_STATISTICS;
    Machine: TMAIN_CONFIG_PROFILE_MACHINE;
  end;

  // Config General

type
  TMAIN_CONFIG_GENERAL_VISOUAL = record
    Keyboard_Group: TGroupBox;
    Virtual_Keyboard: TCheckBox;
  end;

type
  TMAIN_CONFIG_GENERAL_GRAPHICS = record

  end;

type
  TMAIN_CONFIG_GENERAL_SOUND = record

  end;

type
  TMAIN_CONFIG_GENERAL_KEYBOARD = record
    Image: TImage;
    Panel: TPanel;
    TabControl: TTabControl;
    TabItems: array [0 .. 1] of TTabItem;
    Gen_Labels: array [0 .. 6] of TLabel;
    Gen_Panels: array [0 .. 6] of TRectangle;
    Gen_Panels_Text: array [0 .. 6] of TText;
    Emu_Labels: array [0 .. 11] of TLabel;
    Emu_Panels: array [0 .. 11] of TRectangle;
    Emu_Panels_Text: array [0 .. 11] of TText;
  end;

type
  TMAIN_CONFIG_GENERAL_OPTIONS = record
    Panel: TPanel;
    Main: TPanel;
    Info: TText;
    VBox: TVertScrollBox;
    VBox_Items: array [0 .. 31] of TRectangle;
    VBox_Texts: array [0 .. 31] of TText;
    Wait: TText;
  end;

type
  TMAIN_CONFIG_GENERAL_JOYSTICK_MMSYSTEM_STUFF = record
    Layout: TLayout;
    Name: TText;
    Top, Down, Left, Right: TRectangle;
    Top_Name, Down_Name, Left_Name, Right_Name: TText;
    Place: TRectangle;
    Place_Circle: TCircle;
    Place_dot: TCircle;
    Buttons: array [0 .. 15] of TCircle;
    Buttons_Names: array [0 .. 15] of TText;
    Info: TGroupBox;
    Info_Current: TText;
    Info_Standard: TText;
  end;

type
  TMAIN_CONFIG_GENERAL_JOYSTICK_MMSYSTEM = record
    Joy: TComboBox;
    Control: TTabControl;
    Items: array [0 .. 1] of TTabItem;
    General: TMAIN_CONFIG_GENERAL_JOYSTICK_MMSYSTEM_STUFF;
    Emulators: TMAIN_CONFIG_GENERAL_JOYSTICK_MMSYSTEM_STUFF;
  end;

type
  TMAIN_CONFIG_GENERAL_JOYSTICK_DIRECTX = record

  end;

type
  TMAIN_CONFIG_GENERAL_JOYSTICK_XINPUT = record

  end;

type
  TMAIN_CONFIG_GENERAL_JOYSTICK = record
    Image: TImage;
    Panel: TPanel;
    Control: TTabControl;
    Items: array [0 .. 2] of TTabItem;
    Generic: TMAIN_CONFIG_GENERAL_JOYSTICK_MMSYSTEM;
    DirextX: TMAIN_CONFIG_GENERAL_JOYSTICK_DIRECTX;
    XInput: TMAIN_CONFIG_GENERAL_JOYSTICK_XINPUT;
    Options: TMAIN_CONFIG_GENERAL_OPTIONS;
  end;

type
  TMAIN_CONFIG_GENERAL_MOUSE = record
    Image: TImage;
    Panel: TPanel;
  end;

type
  TMAIN_CONFIG_GENERAL = record
    Panel: TPanel;
    Blur: TGaussianBlurEffect;
    Contol: TTabControl;
    Tab_Item: array [0 .. 5] of TTabItem;
    Visual: TMAIN_CONFIG_GENERAL_VISOUAL;
    Graphics: TMAIN_CONFIG_GENERAL_GRAPHICS;
    Sound: TMAIN_CONFIG_GENERAL_SOUND;
    Keyboard: TMAIN_CONFIG_GENERAL_KEYBOARD;
    Joystick: TMAIN_CONFIG_GENERAL_JOYSTICK;
    mouse: TMAIN_CONFIG_GENERAL_MOUSE;
  end;

  // Config Emulators
type
  TMAIN_CONFIG_EMULATORS_TAB = record
    Panel: TPanel;
    Panel_Image: TPanel;
    Logo: TImage;
    Logo_Glow: TGlowEffect;
    Logo_Gray: TMonochromeEffect;
    Logo_Check: TImage;
    Info: TALText;
    Action: TButton;
    Add_New: TButton;
  end;

type
  TMAIN_CONFIG_EMULATORS_OPENDIALOG = class(TObject)
    procedure OnClose(Sender: TObject);
  end;

type
  TMAIN_CONFIG_EMULATORS = record
    Panel: TPanel;
    Panel_Blur: TGaussianBlurEffect;
    Groupbox: TGroupBox;
    Images: array [0 .. 4] of TImage;
    Images_Glow: array [0 .. 4] of TGlowEffect;
    Panels: array [0 .. 4] of TCalloutPanel;
    ScrollBox: array [0 .. 4] of TVertScrollBox;
    Arcade: array [0 .. 6] of TMAIN_CONFIG_EMULATORS_TAB;
    Computers: array [0 .. 10] of TMAIN_CONFIG_EMULATORS_TAB;
    Consoles: array [0 .. 30] of TMAIN_CONFIG_EMULATORS_TAB;
    Handhelds: array [0 .. 11] of TMAIN_CONFIG_EMULATORS_TAB;
    Pinballs: array [0 .. 1] of TMAIN_CONFIG_EMULATORS_TAB;
    Download: TidHTTP;
    Dialog: TOpenDialog;
    Dialog_Object: TMAIN_CONFIG_EMULATORS_OPENDIALOG;
    Installed: String;
    procedure Clear_Config_Emulators_Panel;
  end;

  // Config Games
type
  TMAIN_CONFIG_PCGAMES = record

  end;

  // Config Addons
type
  TMAIN_CONFIG_ADDONS_INFO = record
    Header: TLabel;
    Activeted: TText;
    TextBox: TVertScrollBox;
    Paragraphs: array [0 .. 40] of TALText;
    Athour: TLabel;
    Action: TButton;
  end;

type
  TMAIN_CONFIG_ADDONS_WEATHER_DEACTIVATE_MAIN = record
    Panel: TPanel;
    Text: TLabel;
    Radio_1: TRadioButton;
    Radio_2: TRadioButton;
    OK: TButton;
    Cancel: TButton;
  end;

type
  TMAIN_CONFIG_ADDONS_WEATHER_MESSAGE = record
    Panel: TPanel;
    Main: TMAIN_CONFIG_ADDONS_WEATHER_DEACTIVATE_MAIN;
  end;

type
  TMAIN_CONFIG_ADDONS_MES = record
    Msg_Actv: TMAIN_CONFIG_ADDONS_WEATHER_MESSAGE;
    Msg_Deactv: TMAIN_CONFIG_ADDONS_WEATHER_MESSAGE;
  end;

type
  TMAIN_CONFIG_ADDONS = record
    Panel: TPanel;
    Panel_Blur: TGaussianBlurEffect;
    Groupbox: TGroupBox;
    Arrow_Left: TText;
    Arrow_Left_Glow: TGlowEffect;
    Left_Num: TText;
    Arrow_Right: TText;
    Arrow_Right_Glow: TGlowEffect;
    Right_Num: TText;
    Icons: array [0 .. 100] of TText;
    Icons_Glow: array [0 .. 100] of TGlowEffect;
    Icons_Panel: array [0 .. 100] of TCalloutPanel;
    Icons_Info: array [0 .. 100] of TMAIN_CONFIG_ADDONS_INFO;
    Weather: TMAIN_CONFIG_ADDONS_MES;
    Soundplayer: TMAIN_CONFIG_ADDONS_MES;
  end;

  // Config Themes
type
  TMAIN_CONFIG_THEMES = record
    Panel: TPanel;
    Box: TVertScrollBox;
    Frame: array [0 .. 10] of TPanel;
    Check: array [0 .. 10] of TCheckBox;
    Info: array [0 .. 10] of TLabel;
    Image: array [0 .. 10] of TImage;
    Apply: TButton;
  end;

  // Config Info
type
  TMAIN_CONFIG_INFO_EXTRAFE = record
    Creator: TLabel;
    Creator_V: TLabel;
    Desc: TLabel;
    Desc_V: TLabel;
    Stable: TLabel;
    Stable_V: TLabel;
    Homepage: TLabel;
    Homepage_V: TText;
    Documentation: TLabel;
    Documentation_V: TText;
    Forum: TLabel;
    Forum_V: TText;
    History_Group: TGroupBox;
    Stable_Num: TLabel;
    Build_Num: TLabel;
    Stable_Left: TSpeedButton;
    Stable_Right: TSpeedButton;
    Stable_History_Num: TLabel;
    Build_Left: TSpeedButton;
    Build_Right: TSpeedButton;
    Build_History_Num: TLabel;
    History_Info: TMemo;
  end;

type
  TMAIN_CONFIG_INFO_EMULATORS = record
    Header: TLabel;
    ImageBox: TVertScrollBox;
    Image: array [0 .. 100] of TImage;
    Info: TMemo;
  end;

type
  TMAIN_CONFIG_INFO_CREDITS = record
    Panel: TPanel;
    Groupbox: TGroupBox;
    Text: TALText;
    Groupbox_Other: TGroupBox;
    Control: TTabControl;
    Tab_Item: array [0 .. 1] of TTabItem;
    Left_Box: array [0 .. 1] of TVertScrollBox;
    Brand: array [0 .. 1] of array [0 .. 10] of TImage;
    Brand_Glow: array [0 .. 1] of array [0 .. 10] of TGlowEffect;
    Right_Box: array [0 .. 1] of array [0 .. 10] of TVertScrollBox;
    Paragraphs: array [0 .. 100] of TALText;
  end;

type
  TMAIN_CONFIG_INFO = record
    Panel: TPanel;
    TabControl: TTabControl;
    TabItem: array [0 .. 4] of TTabItem;
    Extrafe: TMAIN_CONFIG_INFO_EXTRAFE;
    Emu: TMAIN_CONFIG_INFO_EMULATORS;
    Credits: TMAIN_CONFIG_INFO_CREDITS;
  end;

type
  TMAIN_CONFIG_RIGHT = record
    Panel: array [0 .. 6] of TPanel;
    Profile: TMAIN_CONFIG_PROFILE;
    General: TMAIN_CONFIG_GENERAL;
    Emulators: TMAIN_CONFIG_EMULATORS;
    PCGames: TMAIN_CONFIG_PCGAMES;
    Addons: TMAIN_CONFIG_ADDONS;
    Themes: TMAIN_CONFIG_THEMES;
    Info: TMAIN_CONFIG_INFO;
  end;

type
  TMAIN_CONFIG_MAIN = record
    Left: TPanel;
    Left_Blur: TBlurEffect;
    Right: TPanel;
    L: TMAIN_CONFIG_LEFT;
    R: TMAIN_CONFIG_RIGHT;
  end;

type
  TMAIN_CONFIGURATION = record
    Panel: TPanel;
    Panel_Ani: TFloatAnimation;
    Panel_Shadow: TShadowEffect;
    Main: TMAIN_CONFIG_MAIN;
  end;

type
  TMAIN_ANIMATION = class(TObject)
    procedure OnFinish(Sender: TObject);
  end;

type
  TMAIN_SCENE = record
    Main: TMAIN_MAIN;
    Header: TMAIN_HEADER;
    Selection: TMAIN_SELECTION;
    Footer: TMAIN_FOOTER;
    Config: TMAIN_CONFIGURATION;
    Animation: TMAIN_ANIMATION;
  end;

var
  mainScene: TMAIN_SCENE;

implementation

uses
  Emu,
  Main,
  uEmu_Actions,
  uLoad_AllTypes;

{ TMAIN_CONFIG_R_EMULATORS_OPENDIALOG }

procedure TMAIN_CONFIG_EMULATORS_OPENDIALOG.OnClose(Sender: TObject);
begin

end;

{ TMAIN_CONFIG_EMULATORS }

procedure TMAIN_CONFIG_EMULATORS.Clear_Config_Emulators_Panel;
begin
  Self := Default (TMAIN_CONFIG_EMULATORS);
  // FreeAndNil(Self.Panel);
end;

{ TMAIN_ANIMATION }

procedure TMAIN_ANIMATION.OnFinish(Sender: TObject);
begin
  if TFloatAnimation(Sender).Name = 'Main_Down_Animation' then
  begin
    Emu_Form.Show;
    Main_Form.Visible := False;
  end;
end;

initialization

mainScene.Config.Main.R.Emulators.Dialog_Object := TMAIN_CONFIG_EMULATORS_OPENDIALOG.Create;

finalization

mainScene.Config.Main.R.Emulators.Dialog_Object.Free;

end.
