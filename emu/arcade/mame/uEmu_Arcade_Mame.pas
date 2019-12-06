unit uEmu_Arcade_Mame;

interface

uses
  System.Classes,
  System.SysUtils,
  FMX.Types;

procedure Load;
procedure Main;

procedure Exit;

implementation

uses
  uLoad_AllTypes,
  uEmu_Actions,
  uEmu_Arcade_Mame_SetAll,
  uEmu_Arcade_Mame_AllTypes,
  uEmu_Arcade_Mame_Gamelist,
  uEmu_Arcade_Mame_Actions,
  uEmu_Arcade_Mame_Sounds;


procedure Load;
var
  vi: integer;
begin
  extrafe.prog.State := 'mame';

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
  Main;

  //Sounds
  uEmu_Arcade_Mame_Sounds.Load;
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
  mame.Main.SnapCategory := 'Snapshots';
  mame.Main.SnapMode := 'arcade';
  mame.Main.SnapCategory_Num := 0;
  uEmu_Arcade_Mame_Actions.Show_Media;
end;

Procedure Exit;
begin
  FreeAndNil(vMame.Scene.Left);
  {Right}
  {Media}
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
