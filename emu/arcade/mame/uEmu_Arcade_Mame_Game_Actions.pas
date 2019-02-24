unit uEmu_Arcade_Mame_Game_Actions;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UiTypes;

const
  cShowGamePanelMenu: array [0 .. 10] of string = ('Play game', 'Read manual', 'Open media folder',
    'View images in fullscreen', 'Sound Tracks', 'Add to favorites', 'Add to playlist', '', '', '', '');

procedure uEmu_Arcade_Mame_Game_Actions_Refresh;

procedure uEmu_Arcade_Mame_Game_Actions_Enter;
procedure uEmu_Arcade_Mame_Game_Actions_ArrowUp;
procedure uEmu_Arcade_Mame_Game_Actions_ArrowDown;

implementation

uses
  emu,
  uLoad_AllTypes,
  uEmu_Commands,
  uEmu_Arcade_Mame_AllTypes,
  uEmu_Arcade_Mame_Gamelist,
  uEmu_Arcade_Mame_Game_SetAll;

procedure uEmu_Arcade_Mame_Game_Actions_Refresh;
var
  vi, ri: Integer;
begin
  uEmu_Arcade_Mame_Gamelist_Clear;
  ri := 0;
  for vi := 10 - (mame.Game.Menu_Selected) to 20 - (mame.Game.Menu_Selected) do
  begin
    vMame.Scene.Gamelist.List_Line[vi].Text.Text := cShowGamePanelMenu[ri];
    inc(ri, 1);
  end;
  if not FileExists(mame.Emu.Media.Manuals + mame.Gamelist.List[0, mame.Gamelist.Selected, 0] + '.pdf') then
    vMame.Scene.Gamelist.List_Line[11 - (mame.Game.Menu_Selected)].Text.Color := TAlphaColorRec.Red;
  if not FileExists(mame.Emu.Media.Soundtracks + mame.Gamelist.List[0, mame.Gamelist.Selected, 0] + '.zip')
  then
    vMame.Scene.Gamelist.List_Line[14 - (mame.Game.Menu_Selected)].Text.Color := TAlphaColorRec.Red;

  uEmu_Arcade_Mame_Gamelist_GlowSelected
end;

procedure uEmu_Arcade_Mame_Game_Actions_Enter;
var
  romName: WideString;
begin

  romName := mame.Gamelist.List[0, mame.Gamelist.Selected, 0];
  vMame.Scene.Load_Game.Visible := True;
  vMame.Scene.Load_Game_Line2.Text := mame.Gamelist.List[0, mame.Gamelist.Selected, 0];
  vMame_Game_Info_Back.Visible := False;
  vMame.Scene.Left_Blur.Enabled := True;
  vMame.Scene.Right_Blur.Enabled := True;
  vMame.Scene.Gamelist.List.Visible := False;
  case mame.Game.Menu_Selected of
    0:
      fEmu_Commands_RunGame(emulation.Arcade[0].Name_Exe, romName, emulation.Arcade[0].Emu_Path, 0);
    1:
      ;
    2:
      ;
    3:
      ;
    4:
      ;
    5:
      ;
    6:
      ;
  end;
  vMame.Scene.Load_Game.Visible := False;
  vMame_Game_Info_Back.Visible := True;
  vMame.Scene.Left_Blur.Enabled := False;
  vMame.Scene.Right_Blur.Enabled := False;
  vMame.Scene.Gamelist.List.Visible := True;
end;

procedure uEmu_Arcade_Mame_Game_Actions_ArrowUp;
begin
  if mame.Game.Menu_Selected > 0 then
  begin
    dec(mame.Game.Menu_Selected, 1);
    uEmu_Arcade_Mame_Game_Actions_Refresh;
  end;
end;

procedure uEmu_Arcade_Mame_Game_Actions_ArrowDown;
begin
  if mame.Game.Menu_Selected < 6 then
  begin
    inc(mame.Game.Menu_Selected, 1);
    uEmu_Arcade_Mame_Game_Actions_Refresh;
  end
end;

end.
