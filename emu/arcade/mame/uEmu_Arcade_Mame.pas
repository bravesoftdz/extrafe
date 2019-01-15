unit uEmu_Arcade_Mame;

interface

uses
  System.Classes,
  System.SysUtils,
  FMX.Forms,
  FMX.Types,
  OXmlPDOM;

procedure uEmu_Arcade_Mame_Load;
procedure uEmu_Arcade_Mame_Loading;
procedure uEmu_Arcade_Mame_Display_Main;

Procedure uEmu_Arcade_Mame_Exit;

implementation

uses
  uLoad_AllTypes,
  uEmu_Actions,
  uEmu_Arcade_Mame_SetAll,
  uEmu_Arcade_Mame_AllTypes,
  uEmu_Arcade_Mame_Game_SetAll,
  uEmu_Arcade_Mame_Support_Files,
  uEmu_Arcade_Mame_Ini,
  uEmu_Arcade_Mame_Gamelist,
  uEmu_Arcade_Mame_Actions,
  uEmu_Arcade_Mame_Filters,
  uEmu_Arcade_Mame_Config;

procedure uEmu_Arcade_Mame_Loading;
begin
  Application.ProcessMessages;
  uEmu_Arcade_Mame_Ini_Load;
  uEmu_Arcade_Mame_Ini_GetMediaPaths;
  // mame.Gamelist.Games:= CreateXMLDoc;
  // mame.Gamelist.Games.LoadFromFile(mame.Prog.Data_Path+ mame.Prog.Games_XML);
end;

procedure uEmu_Arcade_Mame_Load;
var
  vi: integer;
begin
  extrafe.prog.State := 'mame';
  emulation.Active_Num := 0;

  // Timers
  mame.Timers.Gamelist := TEMU_GAMELISTS_TIMER.Create(vMame.Scene.Main);
  mame.Timers.Video := TEMU_VIDEO_TIMER.Create(vMame.Scene.Main);

  // Animations
  mame.Ani.Gamelist := TEMU_GAMELISTS_ANIMATION.Create;

  // Gamelist
  mame.Gamelist.Timer := TTimer.Create(vMame.Scene.Main);
  mame.Gamelist.Timer.Interval := 500;
  mame.Gamelist.Timer.Enabled := False;
  mame.Gamelist.Timer.OnTimer := mame.Timers.Gamelist.OnTimer;

  // Create Main Scene
  uEmu_Arcade_Mame_Filters_Ini;
  uEmu_Arcade_Mame_Filters_Load_Filter(mame.Prog.Filter);

  uEmu_Arcade_Mame_Support_Load;

  uEmu_Arcade_Mame_SetAll_Set;
  uEmu_Arcade_Mame_Display_Main;
end;

procedure uEmu_Arcade_Mame_Display_Main;
var
  vi, ti, ri: integer;
  iPos: integer;
  vName: string;
  romName: String;
  vGamesInfoCount: String;
begin
  mame.Gamelist.Selected := 0;
  uEmu_Arcade_Mame_Gamelist_Refresh;
  vGamesInfoCount := IntToStr(mame.Gamelist.Selected + 1) + '/' + IntToStr(mame.Gamelist.Games_Count);
  vMame.Scene.Gamelist.T_Games_Count_Info.Text := vGamesInfoCount;
  mame.Main.SnapCategory := 'Video Snaps';
  mame.Main.SnapMode := 'arcade';
  mame.Main.SnapCategory_Num := 0;
  uEmu_Arcade_Mame_Actions_ShowData;
end;

Procedure uEmu_Arcade_Mame_Exit;
begin
  FreeAndNil(vMame.Scene.Main);
  mame.Support.ClearSupport;
  extrafe.prog.State := 'main';
  uEmu_Actions_Exit;
end;

end.
