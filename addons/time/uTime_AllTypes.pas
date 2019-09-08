unit uTime_AllTypes;

interface

uses
  System.Classes,
  System.IniFiles,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Effects,
  FMX.Ani,
  uTime_Mouse,
  uTime_Time_AllTypes,
  uTime_Time_Mouse,
  BASS;

type
  TADDON_TIME_TIME = record
    Clock_Type: String;
    Analog_Circle_Path: String;
    Analog_Hour_Path: String;
    Analog_Minutes_Path: String;
    Analog_Hour_Indicator_Path: String;
    Analog_Minutes_Indicator_Path: String;
    Analog_Seconds_Indicator_Path: String;
    Analog_Img_Quarters_Path: String;
    Analog_Img_Quarters_Show: Boolean;
    Analog_Img_Hours_Show: Boolean;
    Analog_Img_Minutes_Path: String;
    Analog_Img_Minutes_Show: Boolean;
    Analog_Seconds_Indicator: Boolean;
    Digital_Type: String;
    Digital_Font: String;
    Digital_Color: String;
    Digital_Sep: String;
    Digital_Color_Back: String;
    Digital_Color_Back_Stroke: String;
    Digital_Img_Folder: String;
    Digital_Matrix: String;
    Sound_Tick: Boolean;
  end;

type
  TADDON_TIME_PATHS = record
    Icon: String;
    Images: string;
    Clock: String;
    Sounds: String;
  end;

type
  TADDON_TIME_CONFIG = record
    Ini: TIniFile;
    Name: String;
    Path: String;
  end;

type
  TADDON_TIME_INPUT = record
    mouse: TTIME_MOUSE_ACTIONS;
    mouse_time: TTIME_TIME_MOUSE_ACTIONS;
  end;

type
  TTIME_SOUNDS = record
    Clock: array [0 .. 1] of HSAMPLE;
  end;

type
  TADDON_TIME = record
    Name: String;
    Active: Boolean;
    Main_Menu_Position: Integer;
    Ini: TADDON_TIME_CONFIG;
    Path: TADDON_TIME_PATHS;
    Input: TADDON_TIME_INPUT;
    Sound: TTIME_SOUNDS;
    // widget: TADDON_WIDGET;
    P_Time: TADDON_TIME_TIME;
  end;

  /// /Construction

type
  TTIME_PANEL_ALARM = record

  end;

type
  TTIME_PANEL_TIMER = record

  end;

type
  TTIME_PANEL_STOPWATCH = record

  end;

type
  TTIME_PANEL_WORLDCLOCK = record

  end;

type
  TTIME_TAB = record
    Back: Timage;
    Back_Glow: TInnerGlowEffect;
    Icon: TText;
    Text: TText;
    UpPanel: TPanel;
  end;

type
  TTIME_ADDON = record
    Time: Timage;
    Time_Ani: TFloatAnimation;
    Back: Timage;
    UpLine: Timage;
    MiddleLine: Timage;
    DownLine: Timage;
    Tab_Selected: Integer;
    Tab: array [0 .. 4] of TTIME_TAB;
    P_Time: TTIME_PANEL_TIME;
    P_Alarm: TTIME_PANEL_ALARM;
    P_Timer: TTIME_PANEL_TIMER;
    P_StopWatch: TTIME_PANEL_STOPWATCH;
    P_WorldClock: TTIME_PANEL_WORLDCLOCK;
  end;

var
  vTime: TTIME_ADDON;

implementation

end.
