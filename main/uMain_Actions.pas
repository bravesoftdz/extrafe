unit uMain_Actions;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UITypes,
  System.UIConsts,
  Winapi.Windows,
  Winapi.Messages,
  FMX.Forms,
  FMX.Graphics,
  FMX.Objects,
  FMX.Effects,
  FMX.Types,
  ALFmxStdCtrls,
  ALFmxObjects,
  ALFmxLayouts,
  ALFmxTabControl,
  FMX.Filter.Effects,
  BASS;

type
  TMAIN_TIMER = class(TObject)
    procedure OnTimer(Sender: TObject);
  end;

procedure uMain_Actions_ShowAvatar;

procedure uMain_Actions_ShowHide_Addon(vNum: Integer; mShow: String; mAddonName: string);
procedure uMain_Actions_SetCurrent_Icon_Active(vNum: Integer);
procedure uMain_Actions_All_Icons_Active(vNum: Integer);
procedure uMain_Actions_ShowHide_Addons(vAddon_Num: Integer);

procedure uMain_Actions_Update_All;
procedure uMain_Actions_Update_Footer_Timer;

var
  vMain_Timer: TMAIN_TIMER;

  // Emulator number
  // 0 MAME

implementation

uses
  uLoad,
  uLoad_AllTypes,
  main,
  emu,
  uWindows,
  uMain,
  uEmu_Actions,
  uMain_Emulation,
  uMain_SetAll,
  uMain_AllTypes,
  uMain_Config,
  // Addons
  uTime_SetAll,
  uTime_AllTypes,
  uWeather_AllTypes,
  uWeather_SetAll,
  uWeather_Actions,
  uSoundplayer_SetAll,
  uSoundplayer_AllTypes,
  uSoundplayer_Player,
  uPlay_Actions;

procedure uMain_Actions_ShowAvatar;
begin
  mainScene.Header.Avatar_Glow.Enabled := False;
  uMain_Config_ShowHide('main');
  uMain_Config_ShowPanel(0);
  ex_main.Config.Active_Panel := 0;
end;

procedure uMain_Actions_ShowHide_Addon(vNum: Integer; mShow: string; mAddonName: string);
begin
  if emulation.Selection_Ani.Enabled = False then
    if mShow = 'main' then
    begin
      emulation.Selection_Ani.StartValue := ex_main.Settings.MainSelection_Pos.Y;
      emulation.Selection_Ani.StopValue := extrafe.res.Height;
      mainScene.Footer.Back_Ani.StartValue := ex_main.Settings.Footer_Pos.Y;
      mainScene.Footer.Back_Ani.StopValue := extrafe.res.Height;
      emulation.Selection_Ani.Enabled := True;
      mainScene.Footer.Back_Ani.Enabled := True;
      uMain_Actions_SetCurrent_Icon_Active(vNum);
      extrafe.prog.State := 'addon_' + mAddonName;
      BASS_ChannelPlay(ex_main.Sounds.effects[0], False);
    end
    else
    begin
      if mAddonName = 'weather' then
        uWeather_Actions_ReturnToMain(vNum)
      else if mAddonName = 'play' then
        uPlay_Actions_ReturnToMain(vNum)
      else
      begin
        emulation.Selection_Ani.StartValue := extrafe.res.Height;
        emulation.Selection_Ani.StopValue := ex_main.Settings.MainSelection_Pos.Y - 130;
        mainScene.Footer.Back_Ani.StartValue := extrafe.res.Height;
        mainScene.Footer.Back_Ani.StopValue := ex_main.Settings.Footer_Pos.Y;
        emulation.Selection_Ani.Enabled := True;
        if mShow = 'addon_time' then
          vTime.Time_Ani.Enabled := True
        else if mShow = 'addon_calendar' then
          // vCalendar.Calendar_Ani.Enabled:= True
        else if mShow = 'addon_weather' then
          vWeather.Scene.Weather_Ani.Enabled := True
        else if mShow = 'addon_soundplayer' then
          vSoundplayer.Scene.Soundplayer_Ani.Enabled := True;
        mainScene.Footer.Back_Ani.Enabled := True;
        uMain_Actions_All_Icons_Active(vNum);
        extrafe.prog.State := 'main';
      end;
      BASS_ChannelPlay(ex_main.Sounds.effects[1], False);
    end;
end;

procedure uMain_Actions_SetCurrent_Icon_Active(vNum: Integer);
var
  vi: Integer;
begin
  for vi := 0 to addons.Total_Num do
  begin
    mainScene.Header.Addon_Icons[vi].Scale.X := 0.9;
    mainScene.Header.Addon_Icons[vi].Scale.Y := 0.9;
    mainScene.Header.Addon_Icons_GaussianBlur[vi].Enabled := True;
  end;

  mainScene.Header.Addon_Icons[vNum].Scale.X := 1.1;
  mainScene.Header.Addon_Icons[vNum].Scale.Y := 1.1;
  mainScene.Header.Addon_Icons[vNum].Position.X := mainScene.Header.Addon_Icons[vNum].Position.X - 6;
  mainScene.Header.Addon_Icons_GaussianBlur[vNum].Enabled := False;
  addons.Active_Now_Num := vNum;
end;

procedure uMain_Actions_All_Icons_Active(vNum: Integer);
var
  vi: Integer;
begin
  for vi := 0 to addons.Total_Num do
  begin
    mainScene.Header.Addon_Icons[vi].Scale.X := 1;
    mainScene.Header.Addon_Icons[vi].Scale.Y := 1;
    mainScene.Header.Addon_Icons_GaussianBlur[vi].Enabled := False;
  end;

  mainScene.Header.Addon_Icons[vNum].Position.X := mainScene.Header.Addon_Icons[vNum].Position.X + 6;
  addons.Active_Now_Num := -1;
end;

procedure uMain_Actions_ShowHide_Addons(vAddon_Num: Integer);
begin
  if mainScene.Header.Back_Blur.Enabled = False then
    if addons.Active_PosNames[vAddon_Num] <> '' then
      uMain_Actions_ShowHide_Addon(vAddon_Num, extrafe.prog.State, addons.Active_PosNames[vAddon_Num]);
end;

/// /////////////////////////////////////////////////////////////////////////////
procedure uMain_Actions_Update_Footer_Timer;
var
  vDate: TDateTime;
begin
  vDate := Now;
  mainScene.Footer.Addon_Calendar.Text.Text := formatdatetime('dd/mm/yyyy', vDate);
  mainScene.Footer.Addon_Time.Text.Text := TimeToStr(Now);
end;

procedure uMain_Actions_Update_All;
begin
  if extrafe.prog.State <> 'addon_soundplayer' then
    if addons.soundplayer.Player.Play then
      uSoundplayer_Player.Refresh;
end;
{ TMAIN_TIMER }

procedure TMAIN_TIMER.OnTimer(Sender: TObject);
begin
  if TTimer(Sender).Name = 'Main_All_Timer' then
    uMain_Actions_Update_All
  else if TTimer(Sender).Name = 'Main_Footer_Timer' then
    uMain_Actions_Update_Footer_Timer
end;

initialization

vMain_Timer := TMAIN_TIMER.Create;

finalization

vMain_Timer.Free;

end.
