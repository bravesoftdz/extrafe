unit uEmu_Arcade_Mame;

interface

uses
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  FMX.Types;

procedure Load;
procedure Exit;

procedure Open_Global_Configuration;

implementation

uses
  uDB,
  uDB_AUser,
  uLoad_AllTypes,
  uEmu_Actions,
  uEmu_Arcade_Mame_SetAll,
  uEmu_Arcade_Mame_AllTypes,
  uEmu_Arcade_Mame_Config,
  uView_Mode;

{ Start Mame }
procedure Load;
begin
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'emulators', 'ACTIVE_UNIQUE', uDB_AUser.Local.EMULATORS.Arcade_D.Mame_D.Unique.ToString, 'USER_ID',
    uDB_AUser.Local.USER.Num.ToString);
  extrafe.prog.State := 'emu_mame';

  uEmu_Arcade_Mame_SetAll.Load;

  uView_Mode.Start(uDB_AUser.Local.EMULATORS.Arcade_D.Mame_D.View_Mode, 0, mame.Gamelist.Games_Count, mame.Gamelist.ListGames, mame.Gamelist.ListRoms, mame.Emu.Ini.CORE_SEARCH_rompath);
end;

{ Exit Mame }
Procedure Exit;
begin
  FreeAndNil(vMame.Scene.Main);
  extrafe.prog.State := 'main';
  uEmu_Actions_Exit;
end;

{ Open Close Configurtaion }
procedure Open_Global_Configuration;
var
  vi: Integer;
begin
  if not ContainsText(extrafe.prog.State, 'mame_config') then
  begin
    uEmu_Arcade_Mame_Config.Load;
    extrafe.prog.State := 'emu_mame_config';
  end
  else
    extrafe.prog.State := 'emu_mame';
end;

end.
