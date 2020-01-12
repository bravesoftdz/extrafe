unit uEmu_Arcade_Mame;

interface

uses
  System.Classes,
  System.SysUtils,
  FMX.Types;

procedure Load;
procedure Start_View_Mode;
procedure Main;

procedure Exit;

implementation

uses
  uDB,
  uDB_AUser,
  uLoad_AllTypes,
  uEmu_Actions,
  uEmu_Arcade_Mame_SetAll,
  uEmu_Arcade_Mame_AllTypes,
  uEmu_Arcade_Mame_Gamelist,
  uEmu_Arcade_Mame_Actions,
  uEmu_Arcade_Mame_Sounds,
  {View Modes}
  uView_Mode_Video_Actions;

procedure Load;
var
  vi: integer;
begin
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'emulators', 'ACTIVE_UNIQUE', uDB_AUser.Local.EMULATORS.Arcade_D.Mame_D.Unique.ToString, 'USER_ID',
    uDB_AUser.Local.Num.ToString);
  extrafe.prog.State := 'emu_mame';

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

  uEmu_Arcade_Mame_SetAll.Load;
  Start_View_Mode;
//  Main;

//  Sounds
   uEmu_Arcade_Mame_Sounds.Load;
end;

procedure Start_View_Mode;
begin
  if uDB_AUser.Local.EMULATORS.Arcade_D.Mame_D.View_Mode = 'video' then
    uView_Mode_Video_Actions.Start_View_Mode(0, mame.Gamelist.Games_Count, mame.Gamelist.ListGames, mame.Gamelist.ListRoms, mame.Emu.Ini.CORE_SEARCH_rompath);
end;

procedure Main;
var
  vi, ti, ri: integer;
  iPos: integer;
  vName: string;
  romName: String;
  vGamesInfoCount: String;
begin
  mame.Gamelist.Selected := 0;
  uEmu_Arcade_Mame_Gamelist.Refresh;
  vGamesInfoCount := IntToStr(mame.Gamelist.Selected + 1) + '/' + IntToStr(mame.Gamelist.Games_Count);
  vMame.Scene.Gamelist.T_Games_Count_Info.Text := vGamesInfoCount;
  mame.Main.SnapMode := 'arcade';
  mame.Main.SnapCategory_Num := 0;
  uEmu_Arcade_Mame_Actions.Show_Media;
end;

Procedure Exit;
begin
  FreeAndNil(vMame.Scene.Left);
  { Right }
  { Media }
  FreeAndNil(vMame.Scene.Media.T_Image.Image);
  FreeAndNil(vMame.Scene.Media.Back);
  FreeAndNil(vMame.Scene.Right);
  FreeAndNil(vMame.Scene.Main);
  uEmu_Arcade_Mame_Sounds.Free;
  mame.Support.ClearSupport;
  extrafe.prog.State := 'main';
  uEmu_Actions_Exit;
end;

end.
