unit uWeather_MenuActions;

interface

uses
  System.Classes,
  System.SysUtils,
  FMX.Controls;

type
  TWEATHER_ANIMATION = class(TObject)
    procedure onANIStop(Sender: TObject);
  end;

procedure uWeather_MenuActions_SlideRight;
procedure uWeather_MenuActions_SlideLeft;

var
  vWeather_Animation: TWEATHER_ANIMATION;
  vWeather_Ani_Stop: Boolean = True;

implementation

uses
  main,
  uLoad_AllTypes,
  uWeather_Actions,
  uWeather_AllTypes,
  uWeather_Convert,
  uWeather_SetAll,
  uWeather_Sounds;

procedure uWeather_MenuActions_SlideRight;
begin
  if vWeather_Ani_Stop then
  begin
    if vWeather.Scene.Control.TabIndex <> vWeather.Scene.Control.TabCount - 1 then
    begin
      vWeather_Ani_Stop := False;
      uWeather_Sounds_PlayEffect('','', False);
      uWeather_Sounds_PlayMouse('Slide');
      if vWeather.Scene.Control.TabIndex = vWeather.Scene.Control.TabCount - 2 then
        vWeather.Scene.Arrow_Right.Visible := False
      else
        vWeather.Scene.Arrow_Right.Visible := True;
      vWeather.Scene.Arrow_Left.Visible := True;
      vWeather.Scene.Arrow_Right_Glow.Enabled := True;
      vWeather.Scene.Control.Next;
    end;
  end;
end;

procedure uWeather_MenuActions_SlideLeft;
begin
  if vWeather_Ani_Stop then
  begin
    if vWeather.Scene.Control.TabIndex <> 0 then
    begin
      vWeather_Ani_Stop := False;
      uWeather_Sounds_PlayEffect('','', False);
      uWeather_Sounds_PlayMouse('Slide');
      if vWeather.Scene.Control.TabIndex = 1 then
        vWeather.Scene.Arrow_Left.Visible := False
      else
        vWeather.Scene.Arrow_Left.Visible := True;
      vWeather.Scene.Arrow_Right.Visible := True;
      vWeather.Scene.Arrow_Left_Glow.Enabled := True;
      vWeather.Scene.Control.Previous;
    end;
  end;
end;

{ TWEATHER_ANIMATION }

procedure TWEATHER_ANIMATION.onANIStop(Sender: TObject);
begin
  if TPathAnimation(Sender).Name = 'A_W_Weather_Astronomy_Spot_Animation' then
  begin
    vWeather.Scene.Tab[vWeather.Scene.Control.TabIndex].Astronomy.Spot_Text.Text := TimeToStr(Now);
    vWeather.Scene.Tab[vWeather.Scene.Control.TabIndex].Astronomy.Spot_Text.Visible := True;
  end
  else
  begin
    vWeather_Ani_Stop := True;
    vWeather.Scene.Arrow_Left_Glow.Enabled := False;
    vWeather.Scene.Arrow_Right_Glow.Enabled := False;
    uWeather_Sounds_PlayEffect(addons.weather.Action.Choosen[vWeather.Scene.Control.TabIndex].Code,
    addons.weather.Action.Choosen[vWeather.Scene.Control.TabIndex].Wind.Speed, True);
    uWeather_Actions_Show_AstronomyAnimation;
  end;
end;

initialization

vWeather_Animation := TWEATHER_ANIMATION.Create;

finalization

vWeather_Animation.Free;

end.
