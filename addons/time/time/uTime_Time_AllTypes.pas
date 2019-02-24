unit uTime_Time_AllTypes;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UiTypes,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Effects,
  FMX.Ani,
  FMX.Types,
  FMX.Edit,
  FMX.TabControl,
  FMX.Listbox,
  FMX.Colors,
  Radiant.Shapes;

type
  TTIME_PANEL_TIME_CONFIG_TAB_1 = record
    Panel: Tpanel;
    ShowType_L: Tlabel;
    ShowType: TComboBox;
    ShowBothType_L: TLabel;
    ShowBothType: TComboBox;
  end;

type
  TTIME_PANEL_TIME_CONFIG_TAB_2 = record
    Panel: TPanel;
    Options: TGroupBox;
    Options_ShowQuarters: TCheckBox;
    Options_ShowHours: TCheckBox;
    Options_ShowMinutes: TCheckBox;
    Options_ShowSecondsIndicator: TCheckBox;
    Analog: TGroupBox;
    Circle_Label: TLabel;
    Circle: TEdit;
    Circle_Search: TButton;
    Hour_Label: TLabel;
    Hour: TEdit;
    Hour_Search: TButton;
    Minutes_Label: TLabel;
    Minutes: TEdit;
    Minutes_Search: TButton;
    Seconds_Label: TLabel;
    Seconds: TEdit;
    Seconds_Search: TButton;
    Hour_Image_Label: TLabel;
    Hour_Image: TEdit;
    Hour_Image_Search: TButton;
    Minutes_Image_Label: TLabel;
    Minutes_Image: TEdit;
    Minutes_Image_Search: TButton;
  end;

type
  TTIME_PANEL_TIME_CONFIG_TAB_3 = record
    Panel: TPanel;
    Font_Label: TLabel;
    Font_Combo: TComboBox;
    Color_Label: TLabel;
    Color_Combo: TColorComboBox;
    Sep_Label: TLabel;
    Sep_Combo: TComboBox;
    Color_Back_Label: TLabel;
    Color_Back_Combo: TColorComboBox;
    Color_Back_Stroke_Label: TLabel;
    Color_Back_Stroke_Combo: TColorComboBox;
    Image_Label: TLabel;
    Image: TEdit;
    Image_Search: TButton;
    Matrix_Label: TLabel;
    Matrix: TEdit;
    Matrix_Search: TButton;
  end;

type
  TTIME_PANEL_TIME_CONFIG_MAIN= record
    Panel: TPanel;
    Control: TTabControl;
    Tab: array [0 .. 2] of TTabItem;
    General: TTIME_PANEL_TIME_CONFIG_TAB_1;
    Analog: TTIME_PANEL_TIME_CONFIG_TAB_2;
    Digital: TTIME_PANEL_TIME_CONFIG_TAB_3;
  end;
type
  TTIME_PANEL_TIME_CONFIG = record
    Panel: TPanel;
    Panel_Ani: TFloatAnimation;
    Main: TTIME_PANEL_TIME_CONFIG_MAIN;
    Control: TTabControl;
    Tab: array [0 .. 2] of TTabItem;
    General: TTIME_PANEL_TIME_CONFIG_TAB_1;
    Analog: TTIME_PANEL_TIME_CONFIG_TAB_2;
    Digital: TTIME_PANEL_TIME_CONFIG_TAB_3;
  end;

type
  TTIME_PANEL_TIME_ANALOG = record
    Back: Timage;
    Circle: TRadiantRing;
    Hour: TRadiantRectangle;
    Minutes: TRadiantRectangle;
    Seconds: TRadiantRectangle;
    Quarters: array [0 .. 3] of TRadiantRectangle;
    Hours: array [0 .. 7] of TRadiantRectangle;
  end;

type
  TTIME_PANEL_TIME_DIGITAL = record
    Back: Timage;
    Rect: TRadiantRectangle;
    Hour: TText;
    Sep_1: TText;
    Sep_1_Ani: TFloatAnimation;
    Seconds: TText;
    Sep_2: TText;
    Sep_2_Ani: TFloatAnimation;
    Minutes: TText;
  end;

type
  TTIME_PANEL_TIME = record
    Back: Timage;
    Settings: Timage;
    Settings_Glow: TGlowEffect;
    Settings_Ani: TFloatAnimation;
    Timer: TTimer;
    Analog: TTIME_PANEL_TIME_ANALOG;
    Digital: TTIME_PANEL_TIME_DIGITAL;
    Config: TTIME_PANEL_TIME_CONFIG;
  end;

implementation

end.
