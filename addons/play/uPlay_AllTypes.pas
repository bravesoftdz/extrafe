unit uPlay_AllTypes;

interface

uses
  System.Classes,
  System.IniFiles,
  FMX.Layouts,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Effects,
  FMX.Ani,
  FMX.Filter.Effects,
  ALFMXObjects,
  FmxPasLibVlcPlayerUnit,
  Radiant.Shapes,
  uPlay_Mouse,
  Bass;

type
  TADDON_PLAY_ANIMATION = class(TObject)
    procedure OnFinish(Sender: TObject);
  end;

  /// /////////////////////////

type
  TADDON_PLAY_CONFIG = record
    Ini: TIniFile;
    Name: string;
    Path: string;
  end;

type
  TADDON_PLAY_PATHS = record
    Icon: String;
    Images: String;
    Sounds: String;
  end;

type
  TADDON_PLAY_ACTIONS = record
    Game: String;
  end;

type
  TADDON_PLAY_SOUNDS = record
    Voices: array [0 .. 4] of HSAMPLE;
    Mouse : array [0 .. 0] of HSAMPLE;
  end;

type
  TADDON_PLAY = record
    Name: String;
    Active: Boolean;
    Main_Menu_Position: Integer;
    Actions: TADDON_PLAY_ACTIONS;
    Ini: TADDON_PLAY_CONFIG;
    Path: TADDON_PLAY_PATHS;
    Input: TADDON_PLAY_INPUT;
    Sounds: TADDON_PLAY_SOUNDS;
  end;

  ///
  /// Constraction
  ///

type
  TPLAY_SCOREBOARD = record
    Panel: TRectangle;
    Names: array [0 .. 9] of TText;
  end;

type
  TPLAY_FULL_PREVIEW = record
    Frame: TRadiantFrame;
    Close: TImage;
    Close_Glow: TGlowEffect;
    Back: TImage;
    Image: TImage;
  end;

type
  TPLAY = record
    Main: Tlayout;
    Main_Ani: TFloatAnimation;
    Img_Box: TVertScrollBox;
    Img_Box_Ani: TFloatAnimation;
    Img_Img: array [0 .. 10] of TImage;
    Img_Img_Glow: array [0 .. 10] of TGlowEffect;
    Info: TVertScrollBox;
    Info_Blur: TGaussianBlurEffect;
    Info_Ani: TFloatAnimation;
    Info_Text: array [0 .. 20] of TALText;
    Info_Img: array [0 .. 7] of TImage;
    Info_Grey: array [0 .. 7] of TMonochromeEffect;
    Info_Img_Glow: array [0 .. 7] of TGlowEffect;
    Full: TPLAY_FULL_PREVIEW;
    Info_Video: TFmxPasLibVlcPlayer;
    Info_Start: TButton;
    Score: TPLAY_SCOREBOARD;
    Play_Ani: TADDON_PLAY_ANIMATION;
  end;

var
  vPlay: TPLAY;

implementation

uses
  uLoad_AllTypes,
  uAzHung_Actions;

{ TADDON_PLAY_ANIMATION }

procedure TADDON_PLAY_ANIMATION.OnFinish(Sender: TObject);
begin
  if TFloatAnimation(Sender).Name = 'A_P_Icons_Animation' then
  begin
    if addons.play.Actions.Game = 'AzHung' then
      uAzHung_Actions_Load;
  end;
end;

initialization

vPlay.Play_Ani := TADDON_PLAY_ANIMATION.Create;

finalization

vPlay.Play_Ani.Free;

end.
