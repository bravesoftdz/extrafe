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

{ TWEATHER_ANIMATION }

procedure TWEATHER_ANIMATION.onANIStop(Sender: TObject);
begin
//  if TPathAnimation(Sender).Name = 'A_W_Weather_Astronomy_Spot_Animation' then
//  begin
//    vWeather.Scene.Tab[vWeather.Scene.Control.TabIndex].Astronomy.Spot_Text.Text := TimeToStr(Now);
//    vWeather.Scene.Tab[vWeather.Scene.Control.TabIndex].Astronomy.Spot_Text.Visible := True;
//  end
//  else
//  begin
    vWeather_Ani_Stop := True;
    vWeather.Scene.Arrow_Left_Glow.Enabled := False;
    vWeather.Scene.Arrow_Right_Glow.Enabled := False;
    FreeAndNil(vWeather.Scene.weather);
//    addons.weather.Action.Choosen[vWeather.Scene.Control.TabIndex].Wind.Speed, True);
//    uWeather_Actions_Show_AstronomyAnimation;
//  end;
end;

initialization

vWeather_Animation := TWEATHER_ANIMATION.Create;

finalization

vWeather_Animation.Free;

end.
