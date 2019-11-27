unit uEmu_Arcade_Mame_Gamelist;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UITypes,
  FMX.StdCtrls;

procedure Clear;
procedure Glow_Selected;
procedure Refresh;

procedure Down;
procedure Up;
procedure Left;
procedure Right;

implementation

uses
  uLoad_AllTypes,
  uSnippet_Text,
  uSnippet_Search,
  uEmu_Arcade_Mame_AllTypes;

procedure Clear;
var
  vi: Integer;
begin
  for vi := 0 to 20 do
  begin
    vMame.Scene.Gamelist.List_Line[vi].Text.Text := '';
    vMame.Scene.Gamelist.List_Line[vi].Text.Color := TAlphaColorRec.White;
  end;
  if extrafe.prog.State = 'mame' then
  begin
    vMame.Scene.Media.T_Players.Players_Value.Text := '';
    vMame.Scene.Media.T_Players.Favorite.Visible := False;
    vMame.Scene.Media.T_Image.Image_X_Ani.Enabled := False;
    vMame.Scene.Media.T_Image.Image_Y_Ani.Enabled := False;
    vMame.Scene.Media.T_Image.Image_Width_Ani.Enabled := False;
    vMame.Scene.Media.T_Image.Image_Height_Ani.Enabled := False;
  end;
end;

procedure Glow_Selected;
begin
  vMame.Scene.Gamelist.List_Selection_Glow.Enabled := False;
  vMame.Scene.Gamelist.List_Selection_Glow.Enabled := True;
end;

procedure Refresh;
var
  vi, ri, ki: Integer;
begin
  mame.Gamelist.Loading_Done := False;
  Clear;
  ri := mame.Gamelist.Selected - 10;
  for vi := 0 to 20 do
  begin
    if ((mame.Gamelist.Selected + 10) + vi < 20) or (mame.Gamelist.Selected + vi >= mame.Gamelist.Games_Count + 10) then
    begin
      vMame.Scene.Gamelist.List_Line[vi].Text.Text := '';
      ri := -1;
    end
    else
    begin
      vMame.Scene.Gamelist.List_Line[vi].Text.Text := mame.Gamelist.ListGames.Strings[ri];
      if uSnippet_Text_ToPixels(vMame.Scene.Gamelist.List_Line[vi].Text) > 640 then
        vMame.Scene.Gamelist.List_Line[vi].Text.Text := uSnippet_Text_SetInGivenPixels(640, vMame.Scene.Gamelist.List_Line[vi].Text);
      for ki := 0 to mame.Emu.Ini.CORE_SEARCH_rompath.Count - 1 do
      begin
        if FileExists(mame.Emu.Ini.CORE_SEARCH_rompath.Strings[ki] + '\' + mame.Gamelist.ListRoms[ri] + '.zip') then
          vMame.Scene.Gamelist.List_Line[vi].Text.Color := TAlphaColorRec.White
        else
          vMame.Scene.Gamelist.List_Line[vi].Text.Color := TAlphaColorRec.Red;
      end;
    end;
    inc(ri, 1);
  end;
  Glow_Selected;
  mame.Gamelist.Loading_Done := True;
  vMame.Scene.Gamelist.T_Games_Count_Info.Text := IntToStr(mame.Gamelist.Selected + 1) + '/' + IntToStr(mame.Gamelist.Games_Count);
end;

procedure Down;
var
  vi, ri: Integer;
begin
  if mame.Gamelist.Selected < mame.Gamelist.Games_Count - 1 then
  begin
    if extrafe.prog.Virtual_Keyboard = False then
      if uSnippet_Search.vSearch.Actions.Active then
        uSnippet_Search.Clear;
    inc(mame.Gamelist.Selected, 1);
    Refresh;
    mame.Gamelist.Timer.Enabled := False;
    mame.Gamelist.Timer.Enabled := True;
  end;
end;

procedure Up;
begin
  if mame.Gamelist.Selected <> 0 then
  begin
    dec(mame.Gamelist.Selected, 1);
    Refresh;
    mame.Gamelist.Timer.Enabled := False;
    mame.Gamelist.Timer.Enabled := True;
  end;
end;

procedure Left;
begin
  if mame.Gamelist.Loading_Done then
    if mame.Gamelist.Selected > 20 then
    begin
      dec(mame.Gamelist.Selected, 20);
      Refresh;
      mame.Gamelist.Timer.Enabled := False;
      mame.Gamelist.Timer.Enabled := True;
    end;
end;

procedure Right;
begin
  if mame.Gamelist.Loading_Done then
    if mame.Gamelist.Selected < mame.Gamelist.Games_Count - 20 then
    begin
      inc(mame.Gamelist.Selected, 20);
      Refresh;
      mame.Gamelist.Timer.Enabled := False;
      mame.Gamelist.Timer.Enabled := True;
    end;
end;

end.
