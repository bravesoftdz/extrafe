unit uAzHung_SetAll;

interface

uses
  System.Classes,
  System.UiTypes,
  System.SysUtils,
  FMX.Forms,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Types,
  FMX.Effects,
  FMX.Filter.Effects,
  FMX.Layouts,
  FMX.Ani,
  Radiant.Shapes,
  ALFMXObjects;

procedure uAzHung_SetAll_Set;
procedure uAzHung_SetAll_Set_First;

procedure uAzHung_SetAll_Set_Start;
procedure uAzHung_SetAll_Set_Start_Tip(vType: String);
procedure uAzHung_SetAll_Set_Game;
procedure uAzHung_SetAll_Create_Letter_Un(vNum: Integer);
procedure uAzHung_SetAll_Create_Lives(vNum: Integer);
procedure uAzHung_SetAll_Create_WinWord_InList(vNum: Integer);

procedure uAzHung_SetAll_CreateLose(vWord: String);
procedure uAzHung_SetAll_CreateWin(vWord: String);

implementation

uses
  uMain_AllTypes,
  uPlay_AllTypes,
  uAzHung_AllTypes;

procedure uAzHung_SetAll_Set;
begin
  vAzHung.Main := TFrame.Create(vPlay.Main);
  vAzHung.Main.Name := 'AzHung';
  vAzHung.Main.Parent := vPlay.Main;
  vAzHung.Main.SetBounds(0, 0, vPlay.Main.Width, vPlay.Main.Height - 10);
  vAzHung.Main.Visible := True;

  uAzHung_SetAll_Set_First;
end;

procedure uAzHung_SetAll_Set_First;
begin
  vAzHung.Load.Back := TImage.Create(vAzHung.Main);
  vAzHung.Load.Back.Name := 'AzHung_Back';
  vAzHung.Load.Back.Parent := vAzHung.Main;
  vAzHung.Load.Back.SetBounds(0, 10, vAzHung.Main.Width, vAzHung.Main.Height);
  vAzHung.Load.Back.Bitmap.LoadFromFile(gAzHung.Path.Images + 'azhung_start_back.png');
  vAzHung.Load.Back.WrapMode := TImageWrapMode.Stretch;
  vAzHung.Load.Back.Visible := True;

  vAzHung.Load.Logo := TText.Create(vAzHung.Load.Back);
  vAzHung.Load.Logo.Name := 'AzHung_Logo';
  vAzHung.Load.Logo.Parent := vAzHung.Load.Back;
  vAzHung.Load.Logo.SetBounds((vAzHung.Load.Back.Width / 2) - 350, 100, 700, 180);
  vAzHung.Load.Logo.TextSettings.Font.Size := 72;
  vAzHung.Load.Logo.TextSettings.Font.Family := 'Ropest PERSONAL USE ONLY';
  vAzHung.Load.Logo.Text := 'AzHung';
  vAzHung.Load.Logo.TextSettings.FontColor := TAlphaColorRec.White;
  vAzHung.Load.Logo.Visible := True;

  vAzHung.Load.Start.Text := TText.Create(vAzHung.Load.Back);
  vAzHung.Load.Start.Text.Name := 'AzHung_Start';
  vAzHung.Load.Start.Text.Parent := vAzHung.Load.Back;
  vAzHung.Load.Start.Text.SetBounds((vAzHung.Load.Back.Width / 2) - 350, 320, 700, 80);
  vAzHung.Load.Start.Text.TextSettings.Font.Size := 46;
  vAzHung.Load.Start.Text.TextSettings.Font.Family := 'Ropest PERSONAL USE ONLY';
  vAzHung.Load.Start.Text.Text := 'Start';
  vAzHung.Load.Start.Text.TextSettings.FontColor := TAlphaColorRec.White;
  vAzHung.Load.Start.Text.OnClick := gAzHung.Input.mouse.Text.OnMouseClick;
  vAzHung.Load.Start.Text.OnMouseEnter := gAzHung.Input.mouse.Text.OnMouseEnter;
  vAzHung.Load.Start.Text.OnMouseLeave := gAzHung.Input.mouse.Text.OnMouseLeave;
  vAzHung.Load.Start.Text.Visible := True;

  vAzHung.Load.Start.Text_Glow := TGlowEffect.Create(vAzHung.Load.Start.Text);
  vAzHung.Load.Start.Text_Glow.Name := 'AzHung_Start_Glow';
  vAzHung.Load.Start.Text_Glow.Parent := vAzHung.Load.Start.Text;
  vAzHung.Load.Start.Text_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vAzHung.Load.Start.Text_Glow.Opacity := 0.9;
  vAzHung.Load.Start.Text_Glow.Enabled := False;

  vAzHung.Load.Options := TText.Create(vAzHung.Load.Back);
  vAzHung.Load.Options.Name := 'AzHung_Options';
  vAzHung.Load.Options.Parent := vAzHung.Load.Back;
  vAzHung.Load.Options.SetBounds((vAzHung.Load.Back.Width / 2) - 350, 420, 700, 80);
  vAzHung.Load.Options.TextSettings.Font.Size := 46;
  vAzHung.Load.Options.TextSettings.Font.Family := 'Ropest PERSONAL USE ONLY';
  vAzHung.Load.Options.Text := 'Options';
  vAzHung.Load.Options.TextSettings.FontColor := TAlphaColorRec.White;
  vAzHung.Load.Options.OnClick := gAzHung.Input.mouse.Text.OnMouseClick;
  vAzHung.Load.Options.OnMouseEnter := gAzHung.Input.mouse.Text.OnMouseEnter;
  vAzHung.Load.Options.OnMouseLeave := gAzHung.Input.mouse.Text.OnMouseLeave;
  vAzHung.Load.Options.Visible := True;

  vAzHung.Load.Options_Glow := TGlowEffect.Create(vAzHung.Load.Options);
  vAzHung.Load.Options_Glow.Name := 'AzHung_Options_Glow';
  vAzHung.Load.Options_Glow.Parent := vAzHung.Load.Options;
  vAzHung.Load.Options_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vAzHung.Load.Options_Glow.Opacity := 0.9;
  vAzHung.Load.Options_Glow.Enabled := False;

  vAzHung.Load.Score := TText.Create(vAzHung.Load.Back);
  vAzHung.Load.Score.Name := 'AzHung_Score';
  vAzHung.Load.Score.Parent := vAzHung.Load.Back;
  vAzHung.Load.Score.SetBounds((vAzHung.Load.Back.Width / 2) - 350, 520, 700, 80);
  vAzHung.Load.Score.TextSettings.Font.Size := 46;
  vAzHung.Load.Score.TextSettings.Font.Family := 'Ropest PERSONAL USE ONLY';
  vAzHung.Load.Score.Text := 'Score';
  vAzHung.Load.Score.TextSettings.FontColor := TAlphaColorRec.White;
  vAzHung.Load.Score.OnClick := gAzHung.Input.mouse.Text.OnMouseClick;
  vAzHung.Load.Score.OnMouseEnter := gAzHung.Input.mouse.Text.OnMouseEnter;
  vAzHung.Load.Score.OnMouseLeave := gAzHung.Input.mouse.Text.OnMouseLeave;
  vAzHung.Load.Score.Visible := True;

  vAzHung.Load.Score_Glow := TGlowEffect.Create(vAzHung.Load.Score);
  vAzHung.Load.Score_Glow.Name := 'AzHung_Score_Glow';
  vAzHung.Load.Score_Glow.Parent := vAzHung.Load.Score;
  vAzHung.Load.Score_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vAzHung.Load.Score_Glow.Opacity := 0.9;
  vAzHung.Load.Score_Glow.Enabled := False;

  vAzHung.Load.Exit_Game := TText.Create(vAzHung.Load.Back);
  vAzHung.Load.Exit_Game.Name := 'AzHung_Exit';
  vAzHung.Load.Exit_Game.Parent := vAzHung.Load.Back;
  vAzHung.Load.Exit_Game.SetBounds((vAzHung.Load.Back.Width / 2) - 350, 650, 700, 80);
  vAzHung.Load.Exit_Game.TextSettings.Font.Size := 52;
  vAzHung.Load.Exit_Game.TextSettings.Font.Family := 'Ropest PERSONAL USE ONLY';
  vAzHung.Load.Exit_Game.Text := 'Exit';
  vAzHung.Load.Exit_Game.TextSettings.FontColor := TAlphaColorRec.White;
  vAzHung.Load.Exit_Game.OnClick := gAzHung.Input.mouse.Text.OnMouseClick;
  vAzHung.Load.Exit_Game.OnMouseEnter := gAzHung.Input.mouse.Text.OnMouseEnter;
  vAzHung.Load.Exit_Game.OnMouseLeave := gAzHung.Input.mouse.Text.OnMouseLeave;
  vAzHung.Load.Exit_Game.Visible := True;

  vAzHung.Load.Exit_Glow := TGlowEffect.Create(vAzHung.Load.Exit_Game);
  vAzHung.Load.Exit_Glow.Name := 'AzHung_Exit_Glow';
  vAzHung.Load.Exit_Glow.Parent := vAzHung.Load.Exit_Game;
  vAzHung.Load.Exit_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vAzHung.Load.Exit_Glow.Opacity := 0.9;
  vAzHung.Load.Exit_Glow.Enabled := False;
end;

procedure uAzHung_SetAll_Set_Start;
begin
  vAzHung.Load.Start.Select.Back := TImage.Create(vAzHung.Main);
  vAzHung.Load.Start.Select.Back.Name := 'AzHung_Start_Back';
  vAzHung.Load.Start.Select.Back.Parent := vAzHung.Main;
  vAzHung.Load.Start.Select.Back.SetBounds(0, 10, vAzHung.Main.Width, vAzHung.Main.Height);
  vAzHung.Load.Start.Select.Back.Bitmap.LoadFromFile(gAzHung.Path.Images + 'azhung_start_back.png');
  vAzHung.Load.Start.Select.Back.WrapMode := TImageWrapMode.Stretch;
  vAzHung.Load.Start.Select.Back.Visible := True;

  vAzHung.Load.Start.Select.Logo := TText.Create(vAzHung.Load.Start.Select.Back);
  vAzHung.Load.Start.Select.Logo.Name := 'AzHung_Start_Logo';
  vAzHung.Load.Start.Select.Logo.Parent := vAzHung.Load.Start.Select.Back;
  vAzHung.Load.Start.Select.Logo.SetBounds((vAzHung.Load.Start.Select.Back.Width / 2) - 350, 100, 700, 180);
  vAzHung.Load.Start.Select.Logo.TextSettings.Font.Size := 72;
  vAzHung.Load.Start.Select.Logo.TextSettings.Font.Family := 'Ropest PERSONAL USE ONLY';
  vAzHung.Load.Start.Select.Logo.Text := 'AzHung';
  vAzHung.Load.Start.Select.Logo.TextSettings.FontColor := TAlphaColorRec.White;
  vAzHung.Load.Start.Select.Logo.Visible := True;

  vAzHung.Load.Start.Select.Easy := TText.Create(vAzHung.Load.Start.Select.Back);
  vAzHung.Load.Start.Select.Easy.Name := 'AzHung_Start_Easy';
  vAzHung.Load.Start.Select.Easy.Parent := vAzHung.Load.Start.Select.Back;
  vAzHung.Load.Start.Select.Easy.SetBounds((vAzHung.Load.Start.Select.Back.Width / 2) - 300, 300, 200, 80);
  vAzHung.Load.Start.Select.Easy.TextSettings.Font.Size := 48;
  vAzHung.Load.Start.Select.Easy.TextSettings.Font.Family := 'Ropest PERSONAL USE ONLY';
  vAzHung.Load.Start.Select.Easy.Text := 'Easy';
  vAzHung.Load.Start.Select.Easy.TextSettings.FontColor := TAlphaColorRec.White;
  vAzHung.Load.Start.Select.Easy.OnClick := gAzHung.Input.mouse.Text.OnMouseClick;
  vAzHung.Load.Start.Select.Easy.OnMouseEnter := gAzHung.Input.mouse.Text.OnMouseEnter;
  vAzHung.Load.Start.Select.Easy.OnMouseLeave := gAzHung.Input.mouse.Text.OnMouseLeave;
  vAzHung.Load.Start.Select.Easy.Visible := True;

  vAzHung.Load.Start.Select.Easy_Glow := TGlowEffect.Create(vAzHung.Load.Start.Select.Easy);
  vAzHung.Load.Start.Select.Easy_Glow.Name := 'AzHung_Start_Easy_Glow';
  vAzHung.Load.Start.Select.Easy_Glow.Parent := vAzHung.Load.Start.Select.Easy;
  vAzHung.Load.Start.Select.Easy_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vAzHung.Load.Start.Select.Easy_Glow.Opacity := 0.9;
  vAzHung.Load.Start.Select.Easy_Glow.Enabled := False;

  vAzHung.Load.Start.Select.Medium := TText.Create(vAzHung.Load.Start.Select.Back);
  vAzHung.Load.Start.Select.Medium.Name := 'AzHung_Start_Medium';
  vAzHung.Load.Start.Select.Medium.Parent := vAzHung.Load.Start.Select.Back;
  vAzHung.Load.Start.Select.Medium.SetBounds((vAzHung.Load.Start.Select.Back.Width / 2) - 100, 300, 200, 80);
  vAzHung.Load.Start.Select.Medium.TextSettings.Font.Size := 48;
  vAzHung.Load.Start.Select.Medium.TextSettings.Font.Family := 'Ropest PERSONAL USE ONLY';
  vAzHung.Load.Start.Select.Medium.Text := 'Medium';
  vAzHung.Load.Start.Select.Medium.TextSettings.FontColor := TAlphaColorRec.White;
  vAzHung.Load.Start.Select.Medium.OnClick := gAzHung.Input.mouse.Text.OnMouseClick;
  vAzHung.Load.Start.Select.Medium.OnMouseEnter := gAzHung.Input.mouse.Text.OnMouseEnter;
  vAzHung.Load.Start.Select.Medium.OnMouseLeave := gAzHung.Input.mouse.Text.OnMouseLeave;
  vAzHung.Load.Start.Select.Medium.Visible := True;

  vAzHung.Load.Start.Select.Medium_Glow := TGlowEffect.Create(vAzHung.Load.Start.Select.Medium);
  vAzHung.Load.Start.Select.Medium_Glow.Name := 'AzHung_Start_Medium_Glow';
  vAzHung.Load.Start.Select.Medium_Glow.Parent := vAzHung.Load.Start.Select.Medium;
  vAzHung.Load.Start.Select.Medium_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vAzHung.Load.Start.Select.Medium_Glow.Opacity := 0.9;
  vAzHung.Load.Start.Select.Medium_Glow.Enabled := False;

  vAzHung.Load.Start.Select.Hard := TText.Create(vAzHung.Load.Start.Select.Back);
  vAzHung.Load.Start.Select.Hard.Name := 'AzHung_Start_Hard';
  vAzHung.Load.Start.Select.Hard.Parent := vAzHung.Load.Start.Select.Back;
  vAzHung.Load.Start.Select.Hard.SetBounds((vAzHung.Load.Start.Select.Back.Width / 2) + 100, 300, 200, 80);
  vAzHung.Load.Start.Select.Hard.TextSettings.Font.Size := 48;
  vAzHung.Load.Start.Select.Hard.TextSettings.Font.Family := 'Ropest PERSONAL USE ONLY';
  vAzHung.Load.Start.Select.Hard.Text := 'Hard';
  vAzHung.Load.Start.Select.Hard.TextSettings.FontColor := TAlphaColorRec.White;
  vAzHung.Load.Start.Select.Hard.OnClick := gAzHung.Input.mouse.Text.OnMouseClick;
  vAzHung.Load.Start.Select.Hard.OnMouseEnter := gAzHung.Input.mouse.Text.OnMouseEnter;
  vAzHung.Load.Start.Select.Hard.OnMouseLeave := gAzHung.Input.mouse.Text.OnMouseLeave;
  vAzHung.Load.Start.Select.Hard.Visible := True;

  vAzHung.Load.Start.Select.Hard_Glow := TGlowEffect.Create(vAzHung.Load.Start.Select.Hard);
  vAzHung.Load.Start.Select.Hard_Glow.Name := 'AzHung_Start_Hard_Glow';
  vAzHung.Load.Start.Select.Hard_Glow.Parent := vAzHung.Load.Start.Select.Hard;
  vAzHung.Load.Start.Select.Hard_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vAzHung.Load.Start.Select.Hard_Glow.Opacity := 0.9;
  vAzHung.Load.Start.Select.Hard_Glow.Enabled := False;

  vAzHung.Load.Start.Select.Start_Game := TText.Create(vAzHung.Load.Start.Select.Back);
  vAzHung.Load.Start.Select.Start_Game.Name := 'AzHung_Start_StartGame';
  vAzHung.Load.Start.Select.Start_Game.Parent := vAzHung.Load.Start.Select.Back;
  vAzHung.Load.Start.Select.Start_Game.SetBounds((vAzHung.Load.Start.Select.Back.Width / 2) - 350,
    650, 700, 80);
  vAzHung.Load.Start.Select.Start_Game.TextSettings.Font.Size := 48;
  vAzHung.Load.Start.Select.Start_Game.TextSettings.Font.Family := 'Ropest PERSONAL USE ONLY';
  vAzHung.Load.Start.Select.Start_Game.Text := 'Start Game';
  vAzHung.Load.Start.Select.Start_Game.TextSettings.FontColor := TAlphaColorRec.Black;
  vAzHung.Load.Start.Select.Start_Game.OnClick := gAzHung.Input.mouse.Text.OnMouseClick;
  vAzHung.Load.Start.Select.Start_Game.OnMouseEnter := gAzHung.Input.mouse.Text.OnMouseEnter;
  vAzHung.Load.Start.Select.Start_Game.OnMouseLeave := gAzHung.Input.mouse.Text.OnMouseLeave;
  vAzHung.Load.Start.Select.Start_Game.Visible := True;

  vAzHung.Load.Start.Select.Start_Game_Glow := TGlowEffect.Create(vAzHung.Load.Start.Select.Start_Game);
  vAzHung.Load.Start.Select.Start_Game_Glow.Name := 'AzHung_Start_StartGame_Glow';
  vAzHung.Load.Start.Select.Start_Game_Glow.Parent := vAzHung.Load.Start.Select.Start_Game;
  vAzHung.Load.Start.Select.Start_Game_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vAzHung.Load.Start.Select.Start_Game_Glow.Opacity := 0.9;
  vAzHung.Load.Start.Select.Start_Game_Glow.Enabled := False;

  vAzHung.Load.Start.Select.Back_ToStart := TText.Create(vAzHung.Load.Start.Select.Back);
  vAzHung.Load.Start.Select.Back_ToStart.Name := 'AzHung_Start_BackTOStart';
  vAzHung.Load.Start.Select.Back_ToStart.Parent := vAzHung.Load.Start.Select.Back;
  vAzHung.Load.Start.Select.Back_ToStart.SetBounds((vAzHung.Load.Start.Select.Back.Width / 2) - 350,
    730, 700, 80);
  vAzHung.Load.Start.Select.Back_ToStart.TextSettings.Font.Size := 48;
  vAzHung.Load.Start.Select.Back_ToStart.TextSettings.Font.Family := 'Ropest PERSONAL USE ONLY';
  vAzHung.Load.Start.Select.Back_ToStart.Text := 'Back';
  vAzHung.Load.Start.Select.Back_ToStart.TextSettings.FontColor := TAlphaColorRec.White;
  vAzHung.Load.Start.Select.Back_ToStart.OnClick := gAzHung.Input.mouse.Text.OnMouseClick;
  vAzHung.Load.Start.Select.Back_ToStart.OnMouseEnter := gAzHung.Input.mouse.Text.OnMouseEnter;
  vAzHung.Load.Start.Select.Back_ToStart.OnMouseLeave := gAzHung.Input.mouse.Text.OnMouseLeave;
  vAzHung.Load.Start.Select.Back_ToStart.Visible := True;

  vAzHung.Load.Start.Select.Back_ToStart_Glow := TGlowEffect.Create(vAzHung.Load.Start.Select.Back_ToStart);
  vAzHung.Load.Start.Select.Back_ToStart_Glow.Name := 'AzHung_Start_BackTOStrart_Glow';
  vAzHung.Load.Start.Select.Back_ToStart_Glow.Parent := vAzHung.Load.Start.Select.Back_ToStart;
  vAzHung.Load.Start.Select.Back_ToStart_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vAzHung.Load.Start.Select.Back_ToStart_Glow.Opacity := 0.9;
  vAzHung.Load.Start.Select.Back_ToStart_Glow.Enabled := False;
end;

procedure uAzHung_SetAll_Set_Start_Tip(vType: String);
begin
  if Assigned(vAzHung.Load.Start.Select.Frame) then
    FreeAndNil(vAzHung.Load.Start.Select.Frame);

  vAzHung.Load.Start.Select.Frame := TRadiantFrame.Create(vAzHung.Main);
  vAzHung.Load.Start.Select.Frame.Name := 'AzHung_Start_Frame';
  vAzHung.Load.Start.Select.Frame.Parent := vAzHung.Main;
  vAzHung.Load.Start.Select.Frame.SetBounds((vAzHung.Load.Start.Select.Back.Width / 2) - 400, 400, 800, 250);
  vAzHung.Load.Start.Select.Frame.FrameSize.Units := TRadiantDimensionUnits.Pixels;
  vAzHung.Load.Start.Select.Frame.FrameSize.Pixels := 8;
  vAzHung.Load.Start.Select.Frame.Fill.Color := TAlphaColorRec.Wheat;
  vAzHung.Load.Start.Select.Frame.Stroke.Thickness := 2;
  vAzHung.Load.Start.Select.Frame.Stroke.Color := TAlphaColorRec.White;
  vAzHung.Load.Start.Select.Frame.Visible := True;

  vAzHung.Load.Start.Select.Frame_Text := TALText.Create(vAzHung.Load.Start.Select.Frame);
  vAzHung.Load.Start.Select.Frame_Text.Name := 'AzHung_Start_Frame_Text';
  vAzHung.Load.Start.Select.Frame_Text.Parent := vAzHung.Load.Start.Select.Frame;
  vAzHung.Load.Start.Select.Frame_Text.SetBounds(20, 20, 760, 210);
  vAzHung.Load.Start.Select.Frame_Text.TextIsHtml := True;
  vAzHung.Load.Start.Select.Frame_Text.Font.Family := 'Tahoma';
  vAzHung.Load.Start.Select.Frame_Text.Font.Size := 18;
  vAzHung.Load.Start.Select.Frame_Text.Color := TAlphaColorRec.White;
  vAzHung.Load.Start.Select.Frame_Text.WordWrap := True;
  vAzHung.Load.Start.Select.Frame_Text.TextSettings.VertAlign := TTextAlign.Leading;
  if vType = 'easy' then
    vAzHung.Load.Start.Select.Frame_Text.Text := 'In this mode you can find simple and easy words to guess.' +
      #13#10 + 'It is design for ages 6 to 14 but adult may try to.' + #13#10 +
      'You can do 6 error guesses until you lost a live and the correct guesses remove the letter from the letter board.'
  else if vType = 'medium' then
    vAzHung.Load.Start.Select.Frame_Text.Text :=
      'In this mode things are harder with more difficult and complex words to guess.' + #13#10 +
      'It is design for ages 13 to 100+ but also kids that believe is good to that.' + #13#10 +
      'You can do 4 error guesses until you lost a live and the correct guess letter don''t disappear the first time only the second time you select the letter.'
  else if vType = 'hard' then
    vAzHung.Load.Start.Select.Frame_Text.Text :=
      'In this mode things are really hard with even more difficult and complex words to guess.' + #13#10 +
      'It is design for ages 18 to 100+ for people to use an extended vocabulary daily.' + #13#10 +
      'You can do 3 error guesses until you lost a live and the correct guess never disappear for the letter board and has a timer for every guess that get smaller when the words come to realeash itseft.';

  vAzHung.Load.Start.Select.Frame_Text.Visible := True;

  vAzHung.Load.Start.Select.Start_Game.TextSettings.FontColor := TAlphaColorRec.White;
  gAzHung.Actions.GameMode := vType;
end;

procedure uAzHung_SetAll_Set_Game;
const
  cEnglish_Set: array [0 .. 25] of string = ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z');
var
  vi: Integer;
begin
  vAzHung.Game.Back := TImage.Create(vAzHung.Main);
  vAzHung.Game.Back.Name := 'AzHung_Game_Background';
  vAzHung.Game.Back.Parent := vAzHung.Main;
  vAzHung.Game.Back.SetBounds(0, 0, vAzHung.Main.Width, vAzHung.Main.Height);
  vAzHung.Game.Back.Bitmap.Canvas.Fill.Color := TAlphaColorRec.Black;
  vAzHung.Game.Back.Visible := True;

  vAzHung.Game.Back_Blur := TGaussianBlurEffect.Create(vAzHung.Game.Back);
  vAzHung.Game.Back_Blur.Name := 'AzHung_Game_Background_Blur';
  vAzHung.Game.Back_Blur.Parent := vAzHung.Game.Back;
  vAzHung.Game.Back_Blur.BlurAmount := 0.9;
  vAzHung.Game.Back_Blur.Enabled := False;

  vAzHung.Game.Hung := TImage.Create(vAzHung.Game.Back);
  vAzHung.Game.Hung.Name := 'AzHung_Game_Hung';
  vAzHung.Game.Hung.Parent := vAzHung.Game.Back;
  vAzHung.Game.Hung.SetBounds(40, 40, 1000, 600);
  vAzHung.Game.Hung.Bitmap.LoadFromFile(gAzHung.Path.Images + 'azhung_hung_2.png');
  vAzHung.Game.Hung.WrapMode := TImageWrapMode.Fit;
  vAzHung.Game.Hung.Visible := True;

  for vi := 0 to 25 do
  begin
    vAzHung.Game.Letter[vi] := TText.Create(vAzHung.Game.Back);
    vAzHung.Game.Letter[vi].Name := 'AzHung_Game_Letter_' + vi.ToString;
    vAzHung.Game.Letter[vi].Parent := vAzHung.Game.Back;
    if vi < 13 then
      vAzHung.Game.Letter[vi].SetBounds(600 + (vi * 60), vAzHung.Game.Back.Height - 220, 50, 50)
    else
      vAzHung.Game.Letter[vi].SetBounds(600 + ((vi - 13) * 60), vAzHung.Game.Back.Height - 160, 50, 50);
    vAzHung.Game.Letter[vi].TextSettings.Font.Family := 'Mellow DEMO';
    vAzHung.Game.Letter[vi].TextSettings.Font.Size := 36;
    vAzHung.Game.Letter[vi].TextSettings.VertAlign := TTextAlign.Center;
    vAzHung.Game.Letter[vi].TextSettings.HorzAlign := TTextAlign.Center;
    vAzHung.Game.Letter[vi].TextSettings.FontColor := TAlphaColorRec.White;
    vAzHung.Game.Letter[vi].Text := cEnglish_Set[vi];
    vAzHung.Game.Letter[vi].OnClick := gAzHung.Input.mouse.Text.OnMouseClick;
    vAzHung.Game.Letter[vi].OnMouseEnter := gAzHung.Input.mouse.Text.OnMouseEnter;
    vAzHung.Game.Letter[vi].OnMouseLeave := gAzHung.Input.mouse.Text.OnMouseLeave;
    vAzHung.Game.Letter[vi].TagString := vi.ToString;
    vAzHung.Game.Letter[vi].Tag := vi;
    vAzHung.Game.Letter[vi].Visible := True;

    vAzHung.Game.Letter_Glow[vi] := TGlowEffect.Create(vAzHung.Game.Letter[vi]);
    vAzHung.Game.Letter_Glow[vi].Name := 'AzHung_Game_Letter_Glow' + vi.ToString;
    vAzHung.Game.Letter_Glow[vi].Parent := vAzHung.Game.Letter[vi];
    vAzHung.Game.Letter_Glow[vi].GlowColor := TAlphaColorRec.Deepskyblue;
    vAzHung.Game.Letter_Glow[vi].Opacity := 0.9;
    vAzHung.Game.Letter_Glow[vi].Enabled := False;
  end;

  vAzHung.Game.Score := TText.Create(vAzHung.Game.Back);
  vAzHung.Game.Score.Name := 'AzHung_Game_Score';
  vAzHung.Game.Score.Parent := vAzHung.Game.Back;
  vAzHung.Game.Score.SetBounds(vAzHung.Game.Back.Width - 250, 40, 100, 30);
  vAzHung.Game.Score.TextSettings.FontColor := TAlphaColorRec.White;
  vAzHung.Game.Score.TextSettings.Font.Family := 'Mellow DEMO';
  vAzHung.Game.Score.TextSettings.Font.Size := 24;
  vAzHung.Game.Score.Text := 'Score : ';
  vAzHung.Game.Score.Visible := True;

  vAzHung.Game.Score_V := TText.Create(vAzHung.Game.Back);
  vAzHung.Game.Score_V.Name := 'AzHung_Game_Score_V';
  vAzHung.Game.Score_V.Parent := vAzHung.Game.Back;
  vAzHung.Game.Score_V.SetBounds(vAzHung.Game.Back.Width - 240, 40, 200, 30);
  vAzHung.Game.Score_V.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vAzHung.Game.Score_V.TextSettings.Font.Family := 'Mellow DEMO';
  vAzHung.Game.Score_V.TextSettings.Font.Size := 24;
  vAzHung.Game.Score_V.Text := '0';
  vAzHung.Game.Score_V.Visible := True;

  vAzHung.Game.Errors := TText.Create(vAzHung.Game.Back);
  vAzHung.Game.Errors.Name := 'AzHung_Game_Errors';
  vAzHung.Game.Errors.Parent := vAzHung.Game.Back;
  vAzHung.Game.Errors.SetBounds(vAzHung.Game.Back.Width - 250, 80, 100, 30);
  vAzHung.Game.Errors.TextSettings.FontColor := TAlphaColorRec.White;
  vAzHung.Game.Errors.TextSettings.Font.Family := 'Mellow DEMO';
  vAzHung.Game.Errors.TextSettings.Font.Size := 24;
  vAzHung.Game.Errors.Text := 'Errors : ';
  vAzHung.Game.Errors.Visible := True;

  vAzHung.Game.Errors_V := TText.Create(vAzHung.Game.Back);
  vAzHung.Game.Errors_V.Name := 'AzHung_Game_Errors_V';
  vAzHung.Game.Errors_V.Parent := vAzHung.Game.Back;
  vAzHung.Game.Errors_V.SetBounds(vAzHung.Game.Back.Width - 240, 80, 200, 30);
  vAzHung.Game.Errors_V.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vAzHung.Game.Errors_V.TextSettings.Font.Family := 'Mellow DEMO';
  vAzHung.Game.Errors_V.TextSettings.Font.Size := 24;
  vAzHung.Game.Errors_V.Visible := True;

  vAzHung.Game.Correct_Back := TImage.Create(vAzHung.Game.Back);
  vAzHung.Game.Correct_Back.Name := 'AzHung_Correct_Back';
  vAzHung.Game.Correct_Back.Parent := vAzHung.Game.Back;
  vAzHung.Game.Correct_Back.SetBounds(vAzHung.Game.Back.Width, 140, 400, vAzHung.Game.Back.Height - 160);
  vAzHung.Game.Correct_Back.Bitmap.LoadFromFile(gAzHung.Path.Images + 'azhung_back.png');
  vAzHung.Game.Correct_Back.WrapMode := TImageWrapMode.Stretch;
  vAzHung.Game.Correct_Back.Visible := True;

  vAzHung.Game.Correct_Back_Ani := TFloatAnimation.Create(vAzHung.Game.Correct_Back);
  vAzHung.Game.Correct_Back_Ani.Name := 'AzHung_Correct_Back_Ani';
  vAzHung.Game.Correct_Back_Ani.Parent := vAzHung.Game.Correct_Back;
  vAzHung.Game.Correct_Back_Ani.Duration := 0.2;
  vAzHung.Game.Correct_Back_Ani.Loop := False;
  vAzHung.Game.Correct_Back_Ani.PropertyName := 'Position.X';
  vAzHung.Game.Correct_Back_Ani.OnFinish := gAzHung.Actions.Animation.OnFinish;
  vAzHung.Game.Correct_Back_Ani.Enabled := False;

  vAzHung.Game.Correct_Catch := TImage.Create(vAzHung.Game.Correct_Back);
  vAzHung.Game.Correct_Catch.Name := 'AzHung_Correct_Catch';
  vAzHung.Game.Correct_Catch.Parent := vAzHung.Game.Correct_Back;
  vAzHung.Game.Correct_Catch.SetBounds(-50, (vAzHung.Game.Correct_Back.Height / 2) - 20, 50, 40);
  vAzHung.Game.Correct_Catch.Bitmap.LoadFromFile(gAzHung.Path.Images + 'azhung_winlist.png');
  vAzHung.Game.Correct_Catch.WrapMode := TImageWrapMode.Stretch;
  vAzHung.Game.Correct_Catch.OnClick := gAzHung.Input.mouse.Image.OnMouseClick;
  vAzHung.Game.Correct_Catch.OnMouseEnter := gAzHung.Input.mouse.Image.OnMouseEnter;
  vAzHung.Game.Correct_Catch.OnMouseLeave := gAzHung.Input.mouse.Image.OnMouseLeave;
  vAzHung.Game.Correct_Catch.Visible := True;

  vAzHung.Game.Correct_Catch_Num := TText.Create(vAzHung.Game.Correct_Catch);
  vAzHung.Game.Correct_Catch_Num.Name := 'AzHung_Game_Correct_Catch_Num';
  vAzHung.Game.Correct_Catch_Num.Parent := vAzHung.Game.Correct_Catch;
  vAzHung.Game.Correct_Catch_Num.SetBounds((vAzHung.Game.Correct_Catch.Width / 2) - 25, 2, 40, 30);
  vAzHung.Game.Correct_Catch_Num.TextSettings.FontColor := TAlphaColorRec.White;
  vAzHung.Game.Correct_Catch_Num.TextSettings.Font.Family := 'Mellow DEMO';
  vAzHung.Game.Correct_Catch_Num.TextSettings.Font.Size := 14;
  vAzHung.Game.Correct_Catch_Num.Text := '0';
  vAzHung.Game.Correct_Catch_Num.TextSettings.HorzAlign := TTextAlign.Center;
  vAzHung.Game.Correct_Catch_Num.OnClick := gAzHung.Input.mouse.Text.OnMouseClick;
  vAzHung.Game.Correct_Catch_Num.OnMouseEnter := gAzHung.Input.mouse.Text.OnMouseEnter;
  vAzHung.Game.Correct_Catch_Num.OnMouseLeave := gAzHung.Input.mouse.Text.OnMouseLeave;
  vAzHung.Game.Correct_Catch_Num.Visible := True;

  vAzHung.Game.Correct_List := TText.Create(vAzHung.Game.Correct_Back);
  vAzHung.Game.Correct_List.Name := 'AzHung_Game_WinWordsList';
  vAzHung.Game.Correct_List.Parent := vAzHung.Game.Correct_Back;
  vAzHung.Game.Correct_List.SetBounds(10, 4, 200, 30);
  vAzHung.Game.Correct_List.TextSettings.FontColor := TAlphaColorRec.White;
  vAzHung.Game.Correct_List.TextSettings.Font.Family := 'Mellow DEMO';
  vAzHung.Game.Correct_List.TextSettings.Font.Size := 24;
  vAzHung.Game.Correct_List.Text := 'Win Words List';
  vAzHung.Game.Correct_List.Visible := True;

  vAzHung.Game.Correct_Line_Hor := TImage.Create(vAzHung.Game.Correct_Back);
  vAzHung.Game.Correct_Line_Hor.Name := 'AzHung_Correct_Frame_Horizontal';
  vAzHung.Game.Correct_Line_Hor.Parent := vAzHung.Game.Correct_Back;
  vAzHung.Game.Correct_Line_Hor.SetBounds(0, 30, 390, 5);
  vAzHung.Game.Correct_Line_Hor.Bitmap.LoadFromFile(gAzHung.Path.Images + 'azhung_line.png');
  vAzHung.Game.Correct_Line_Hor.WrapMode := TImageWrapMode.Stretch;
  vAzHung.Game.Correct_Line_Hor.Visible := True;

  vAzHung.Game.Correct_Line_Hor_1 := TImage.Create(vAzHung.Game.Correct_Back);
  vAzHung.Game.Correct_Line_Hor_1.Name := 'AzHung_Correct_Frame_Horizontal_1';
  vAzHung.Game.Correct_Line_Hor_1.Parent := vAzHung.Game.Correct_Back;
  vAzHung.Game.Correct_Line_Hor_1.SetBounds(0, vAzHung.Game.Correct_Back.Height - 5, 390, 5);
  vAzHung.Game.Correct_Line_Hor_1.Bitmap.LoadFromFile(gAzHung.Path.Images + 'azhung_line.png');
  vAzHung.Game.Correct_Line_Hor_1.WrapMode := TImageWrapMode.Stretch;
  vAzHung.Game.Correct_Line_Hor_1.Visible := True;

  vAzHung.Game.Correct_Line_Vert := TImage.Create(vAzHung.Game.Correct_Back);
  vAzHung.Game.Correct_Line_Vert.Name := 'AzHung_Correct_Frame_Vertical';
  vAzHung.Game.Correct_Line_Vert.Parent := vAzHung.Game.Correct_Back;
  vAzHung.Game.Correct_Line_Vert.SetBounds(0, 30, 5, vAzHung.Game.Correct_Back.Height - 30);
  vAzHung.Game.Correct_Line_Vert.Bitmap.LoadFromFile(gAzHung.Path.Images + 'azhung_line.png');
  vAzHung.Game.Correct_Line_Vert.WrapMode := TImageWrapMode.Stretch;
  vAzHung.Game.Correct_Line_Vert.Visible := True;

  vAzHung.Game.Correct_Box := TVertScrollBox.Create(vAzHung.Game.Correct_Back);
  vAzHung.Game.Correct_Box.Name := 'AzHung_Game_Correct_Box';
  vAzHung.Game.Correct_Box.Parent := vAzHung.Game.Correct_Back;
  vAzHung.Game.Correct_Box.SetBounds(15, 15, 360, vAzHung.Game.Correct_Back.Height - 170);
  vAzHung.Game.Correct_Box.ShowScrollBars := True;
  vAzHung.Game.Correct_Box.Visible := True;
end;

procedure uAzHung_SetAll_Create_Letter_Un(vNum: Integer);
begin
  vAzHung.Game.Letter_Un[vNum] := TText.Create(vAzHung.Game.Back);
  vAzHung.Game.Letter_Un[vNum].Name := 'AzHung_Game_Letter_Un' + vNum.ToString;
  vAzHung.Game.Letter_Un[vNum].Parent := vAzHung.Game.Back;
  vAzHung.Game.Letter_Un[vNum].SetBounds(1100 + (vNum * 50), 350, 50, 50);
  vAzHung.Game.Letter_Un[vNum].TextSettings.Font.Family := 'Mellow DEMO';
  vAzHung.Game.Letter_Un[vNum].TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vAzHung.Game.Letter_Un[vNum].TextSettings.Font.Size := 36;
  vAzHung.Game.Letter_Un[vNum].Text := '_';
  vAzHung.Game.Letter_Un[vNum].Visible := True;
end;

procedure uAzHung_SetAll_Create_Lives(vNum: Integer);
var
  vi: Integer;
begin
  for vi := 0 to vNum - 1 do
  begin
    vAzHung.Game.Lives[vi] := TImage.Create(vAzHung.Game.Back);
    vAzHung.Game.Lives[vi].Name := 'AzHung_Game_Live_' + vi.ToString;
    vAzHung.Game.Lives[vi].Parent := vAzHung.Game.Back;
    vAzHung.Game.Lives[vi].SetBounds(30 + (vi * 25), 20, 20, 40);
    vAzHung.Game.Lives[vi].Bitmap.LoadFromFile(gAzHung.Path.Images + 'azhung_live.png');
    vAzHung.Game.Lives[vi].WrapMode := TImageWrapMode.Fit;
    vAzHung.Game.Lives[vi].Visible := True;
  end;
end;

procedure uAzHung_SetAll_Create_WinWord_InList(vNum: Integer);
begin
  vAzHung.Game.Correct_ListWord[vNum] := TText.Create(vAzHung.Game.Correct_Box);
  vAzHung.Game.Correct_ListWord[vNum].Name := 'AzHung_Game_List_WinWord_' + vNum.ToString;
  vAzHung.Game.Correct_ListWord[vNum].Parent := vAzHung.Game.Correct_Box;
  vAzHung.Game.Correct_ListWord[vNum].SetBounds(14, 30 + (vNum * 36), 320, 25);
  vAzHung.Game.Correct_ListWord[vNum].TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vAzHung.Game.Correct_ListWord[vNum].TextSettings.Font.Family := 'Mellow DEMO';
  vAzHung.Game.Correct_ListWord[vNum].TextSettings.Font.Size := 20;
  vAzHung.Game.Correct_ListWord[vNum].TextSettings.HorzAlign := TTextAlign.Leading;
  vAzHung.Game.Correct_ListWord[vNum].Text := (vNum + 1).ToString + '.  ' +
    gAzHung.Actions.Correct.List.Strings[vNum];
  vAzHung.Game.Correct_ListWord[vNum].Visible := True;
end;

procedure uAzHung_SetAll_CreateLose(vWord: String);
var
  vi: Integer;
begin
  vAzHung.Game.Lose.Back := TImage.Create(vAzHung.Main);
  vAzHung.Game.Lose.Back.Name := 'AzHung_Game_Lose';
  vAzHung.Game.Lose.Back.Parent := vAzHung.Main;
  vAzHung.Game.Lose.Back.SetBounds((vAzHung.Main.Width / 2) - 400, (vAzHung.Main.Height / 2) - 250, 800, 500);
  vAzHung.Game.Lose.Back.Bitmap.LoadFromFile(gAzHung.Path.Images + 'azhung_back.png');
  vAzHung.Game.Lose.Back.WrapMode := TImageWrapMode.Stretch;
  vAzHung.Game.Lose.Back.Visible := True;

  for vi := 0 to 1 do
  begin
    vAzHung.Game.Lose.Hor[vi] := TImage.Create(vAzHung.Game.Lose.Back);
    vAzHung.Game.Lose.Hor[vi].Name := 'AzHung_Correct_Lose_Hor_' + vi.ToString;
    vAzHung.Game.Lose.Hor[vi].Parent := vAzHung.Game.Lose.Back;
    if vi = 0 then
      vAzHung.Game.Lose.Hor[vi].SetBounds(0, 0, vAzHung.Game.Lose.Back.Width, 5)
    else
      vAzHung.Game.Lose.Hor[vi].SetBounds(0, vAzHung.Game.Lose.Back.Height - 5,
        vAzHung.Game.Lose.Back.Width, 5);
    vAzHung.Game.Lose.Hor[vi].Bitmap.LoadFromFile(gAzHung.Path.Images + 'azhung_line.png');
    vAzHung.Game.Lose.Hor[vi].WrapMode := TImageWrapMode.Stretch;
    vAzHung.Game.Lose.Hor[vi].Visible := True;
  end;

  for vi := 0 to 1 do
  begin
    vAzHung.Game.Lose.Vert[vi] := TImage.Create(vAzHung.Game.Lose.Back);
    vAzHung.Game.Lose.Vert[vi].Name := 'AzHung_Correct_Lose_Vert_' + vi.ToString;
    vAzHung.Game.Lose.Vert[vi].Parent := vAzHung.Game.Lose.Back;
    if vi = 0 then
      vAzHung.Game.Lose.Vert[vi].SetBounds(0, 0, 5, vAzHung.Game.Lose.Back.Height)
    else
      vAzHung.Game.Lose.Vert[vi].SetBounds(vAzHung.Game.Lose.Back.Width - 5, 0,
        5, vAzHung.Game.Lose.Back.Height);
    vAzHung.Game.Lose.Vert[vi].Bitmap.LoadFromFile(gAzHung.Path.Images + 'azhung_line.png');
    vAzHung.Game.Lose.Vert[vi].WrapMode := TImageWrapMode.Stretch;
    vAzHung.Game.Lose.Vert[vi].Visible := True;
  end;

  vAzHung.Game.Lose.Word := TText.Create(vAzHung.Game.Lose.Back);
  vAzHung.Game.Lose.Word.Name := 'AzHung_Game_Lose_Word';
  vAzHung.Game.Lose.Word.Parent := vAzHung.Game.Lose.Back;
  vAzHung.Game.Lose.Word.SetBounds(100, 40, 240, 40);
  vAzHung.Game.Lose.Word.TextSettings.Font.Family := 'Mellow DEMO';
  vAzHung.Game.Lose.Word.TextSettings.FontColor := TAlphaColorRec.White;
  vAzHung.Game.Lose.Word.TextSettings.Font.Size := 36;
  vAzHung.Game.Lose.Word.Text := 'The word was : ';
  vAzHung.Game.Lose.Word.Visible := True;

  vAzHung.Game.Lose.Word_V := TText.Create(vAzHung.Game.Lose.Back);
  vAzHung.Game.Lose.Word_V.Name := 'AzHung_Game_Lose_Word_V';
  vAzHung.Game.Lose.Word_V.Parent := vAzHung.Game.Lose.Back;
  vAzHung.Game.Lose.Word_V.SetBounds(300, 40, 400, 40);
  vAzHung.Game.Lose.Word_V.TextSettings.Font.Family := 'Mellow DEMO';
  vAzHung.Game.Lose.Word_V.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vAzHung.Game.Lose.Word_V.TextSettings.Font.Size := 36;
  vAzHung.Game.Lose.Word_V.Text := vWord;
  vAzHung.Game.Lose.Word_V.Visible := True;

  vAzHung.Game.Lose.Word_Des := TALText.Create(vAzHung.Game.Lose.Back);
  vAzHung.Game.Lose.Word_Des.Name := 'AzHung_Game_Lose_Word_Des';
  vAzHung.Game.Lose.Word_Des.Parent := vAzHung.Game.Lose.Back;
  vAzHung.Game.Lose.Word_Des.SetBounds(50, 100, vAzHung.Game.Lose.Back.Width - 100, 220);
  if gAzHung.Actions.Lives > 1 then
    vAzHung.Game.Lose.Word_Des.Text := 'You lost a live. You must be more carefull next time. ' + #13#10 +
      'Plese make thinking choices.'
  else
    vAzHung.Game.Lose.Word_Des.Text := 'You lost all of your lives. Your score is ''';
  vAzHung.Game.Lose.Word_Des.TextSettings.FontColor := TAlphaColorRec.White;
  vAzHung.Game.Lose.Word_Des.TextSettings.Font.Size := 16;
  vAzHung.Game.Lose.Word_Des.TextIsHtml := True;
  vAzHung.Game.Lose.Word_Des.WordWrap := True;
  vAzHung.Game.Lose.Word_Des.Visible := True;

  vAzHung.Game.Lose.OK := TImage.Create(vAzHung.Game.Lose.Back);
  vAzHung.Game.Lose.OK.Name := 'AzHung_Game_Lose_OK';
  vAzHung.Game.Lose.OK.Parent := vAzHung.Game.Lose.Back;
  vAzHung.Game.Lose.OK.SetBounds((vAzHung.Game.Lose.Back.Width / 2) - 50, vAzHung.Game.Lose.Back.Height -
    50, 100, 50);
  vAzHung.Game.Lose.OK.Bitmap.LoadFromFile(gAzHung.Path.Images + 'azhung_lose_button.png');
  vAzHung.Game.Lose.OK.WrapMode := TImageWrapMode.Fit;
  vAzHung.Game.Lose.OK.OnClick := gAzHung.Input.mouse.Image.OnMouseClick;
  vAzHung.Game.Lose.OK.Visible := True;
end;

procedure uAzHung_SetAll_CreateWin(vWord: String);
var
  vi: Integer;
begin
  vAzHung.Game.Lose.Back := TImage.Create(vAzHung.Main);
  vAzHung.Game.Lose.Back.Name := 'AzHung_Game_Win';
  vAzHung.Game.Lose.Back.Parent := vAzHung.Main;
  vAzHung.Game.Lose.Back.SetBounds((vAzHung.Main.Width / 2) - 400, (vAzHung.Main.Height / 2) - 250, 800, 500);
  vAzHung.Game.Lose.Back.Bitmap.LoadFromFile(gAzHung.Path.Images + 'azhung_back.png');
  vAzHung.Game.Lose.Back.WrapMode := TImageWrapMode.Stretch;
  vAzHung.Game.Lose.Back.Visible := True;

   for vi := 0 to 1 do
  begin
    vAzHung.Game.Lose.Hor[vi] := TImage.Create(vAzHung.Game.Lose.Back);
    vAzHung.Game.Lose.Hor[vi].Name := 'AzHung_Correct_Win_Hor_' + vi.ToString;
    vAzHung.Game.Lose.Hor[vi].Parent := vAzHung.Game.Lose.Back;
    if vi = 0 then
      vAzHung.Game.Lose.Hor[vi].SetBounds(0, 0, vAzHung.Game.Lose.Back.Width, 5)
    else
      vAzHung.Game.Lose.Hor[vi].SetBounds(0, vAzHung.Game.Lose.Back.Height - 5,
        vAzHung.Game.Lose.Back.Width, 5);
    vAzHung.Game.Lose.Hor[vi].Bitmap.LoadFromFile(gAzHung.Path.Images + 'azhung_line.png');
    vAzHung.Game.Lose.Hor[vi].WrapMode := TImageWrapMode.Stretch;
    vAzHung.Game.Lose.Hor[vi].Visible := True;
  end;

  for vi := 0 to 1 do
  begin
    vAzHung.Game.Lose.Vert[vi] := TImage.Create(vAzHung.Game.Lose.Back);
    vAzHung.Game.Lose.Vert[vi].Name := 'AzHung_Correct_Win_Vert_' + vi.ToString;
    vAzHung.Game.Lose.Vert[vi].Parent := vAzHung.Game.Lose.Back;
    if vi = 0 then
      vAzHung.Game.Lose.Vert[vi].SetBounds(0, 0, 5, vAzHung.Game.Lose.Back.Height)
    else
      vAzHung.Game.Lose.Vert[vi].SetBounds(vAzHung.Game.Lose.Back.Width - 5, 0,
        5, vAzHung.Game.Lose.Back.Height);
    vAzHung.Game.Lose.Vert[vi].Bitmap.LoadFromFile(gAzHung.Path.Images + 'azhung_line.png');
    vAzHung.Game.Lose.Vert[vi].WrapMode := TImageWrapMode.Stretch;
    vAzHung.Game.Lose.Vert[vi].Visible := True;
  end;

  vAzHung.Game.Lose.Word := TText.Create(vAzHung.Game.Lose.Back);
  vAzHung.Game.Lose.Word.Name := 'AzHung_Game_Win_Word';
  vAzHung.Game.Lose.Word.Parent := vAzHung.Game.Lose.Back;
  vAzHung.Game.Lose.Word.SetBounds(100, 40, 280, 40);
  vAzHung.Game.Lose.Word.TextSettings.Font.Family := 'Mellow DEMO';
  vAzHung.Game.Lose.Word.TextSettings.FontColor := TAlphaColorRec.White;
  vAzHung.Game.Lose.Word.TextSettings.Font.Size := 36;
  vAzHung.Game.Lose.Word.Text := 'Bravo word was : ';
  vAzHung.Game.Lose.Word.Visible := True;

  vAzHung.Game.Lose.Word_V := TText.Create(vAzHung.Game.Lose.Back);
  vAzHung.Game.Lose.Word_V.Name := 'AzHung_Game_Win_Word_V';
  vAzHung.Game.Lose.Word_V.Parent := vAzHung.Game.Lose.Back;
  vAzHung.Game.Lose.Word_V.SetBounds(320, 40, 400, 40);
  vAzHung.Game.Lose.Word_V.TextSettings.Font.Family := 'Mellow DEMO';
  vAzHung.Game.Lose.Word_V.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vAzHung.Game.Lose.Word_V.TextSettings.Font.Size := 36;
  vAzHung.Game.Lose.Word_V.Text := vWord;
  vAzHung.Game.Lose.Word_V.Visible := True;

  vAzHung.Game.Lose.Word_Des := TALText.Create(vAzHung.Game.Lose.Back);
  vAzHung.Game.Lose.Word_Des.Name := 'AzHung_Game_Win_Word_Des';
  vAzHung.Game.Lose.Word_Des.Parent := vAzHung.Game.Lose.Back;
  vAzHung.Game.Lose.Word_Des.SetBounds(50, 100, vAzHung.Game.Lose.Back.Width - 100, 220);
  vAzHung.Game.Lose.Word_Des.Text := 'You win with score : ' + gAzHung.Actions.Score.ToString + #13#10 +
    'Now go for more and break the record.';
  vAzHung.Game.Lose.Word_Des.TextSettings.FontColor := TAlphaColorRec.White;
  vAzHung.Game.Lose.Word_Des.TextSettings.Font.Size := 16;
  vAzHung.Game.Lose.Word_Des.TextIsHtml := True;
  vAzHung.Game.Lose.Word_Des.WordWrap := True;
  vAzHung.Game.Lose.Word_Des.Visible := True;

  vAzHung.Game.Lose.OK := TImage.Create(vAzHung.Game.Lose.Back);
  vAzHung.Game.Lose.OK.Name := 'AzHung_Game_Win_OK';
  vAzHung.Game.Lose.OK.Parent := vAzHung.Game.Lose.Back;
  vAzHung.Game.Lose.OK.SetBounds((vAzHung.Game.Lose.Back.Width / 2) - 50, vAzHung.Game.Lose.Back.Height -
    50, 100, 50);
  vAzHung.Game.Lose.OK.Bitmap.LoadFromFile(gAzHung.Path.Images + 'azhung_lose_button.png');
  vAzHung.Game.Lose.OK.WrapMode := TImageWrapMode.Fit;
  vAzHung.Game.Lose.OK.OnClick := gAzHung.Input.mouse.Image.OnMouseClick;
  vAzHung.Game.Lose.OK.Visible := True;
end;

end.
