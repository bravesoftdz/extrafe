unit uEmu_Arcade_Mame_Keyboard;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UiTypes;

procedure uEmu_Arcade_Mame_Keyboard_SetKey(vKey: string);

procedure uEmu_Arcade_Mame_Keyboard_VirtualKeyboard_SetKey(vKey: string);

implementation

uses
  uLoad_AllTypes,
  uVirtual_Keyboard,
  uEmu_Arcade_Mame_Gamelist,
  uEmu_Arcade_Mame_AllTypes,
  uEmu_Arcade_Mame_Actions,
  uEmu_Arcade_Mame_Game_Actions;

procedure uEmu_Arcade_Mame_Keyboard_SetKey(vKey: string);
begin
  if UpperCase(vKey) = 'ESC' then
    uEmu_Arcade_Mame_Actions_Escape
  else
  begin
    if extrafe.prog.State = 'mame_filters' then
    begin

    end
    else if extrafe.prog.State = 'mame' then
    begin
      if UpperCase(vKey) = 'ENTER' then
      begin
        if vMame.Scene.Gamelist.List_Line[10].Text.Color <> TAlphaColorRec.Red then
          uEmu_Arcade_Mame_Actions_Enter
      end
      else if UpperCase(vKey) = 'DOWN' then
        uEmu_Arcade_Mame_Gamelist_PushDown
      else if UpperCase(vKey) = 'UP' then
        uEmu_Arcade_Mame_Gamelist_PushUp
      else if UpperCase(vKey) = 'LEFT' then
        uEmu_Arcade_Mame_Gamelist_PushLeft
      else if UpperCase(vKey) = 'RIGHT' then
        uEmu_Arcade_Mame_Gamelist_PushRight
      else if UpperCase(vKey) = 'S' then
        uEmu_Arcade_Mame_Actions_OpenSearch
      else if UpperCase(vKey) = 'Q' then
        uEmu_Arcade_Mame_Actions_OpenGlobalConfiguration
      else if UpperCase(vKey) = 'F' then
        uEmu_Arcade_Mame_Actions_OpenFilters
      else if UpperCase(vKey) = 'M' then
        uEmu_Arcade_Mame_Actions_ChangeSnapMode
      else if UpperCase(vKey) = 'K' then
        uEmu_Arcade_Mame_Actions_ChangeCategeroy('left')
      else if UpperCase(vKey) = 'L' then
        uEmu_Arcade_Mame_Actions_ChangeCategeroy('right');
    end
    else if extrafe.prog.State = 'mame_game' then
    begin
      if UpperCase(vKey) = 'ENTER' then
        uEmu_Arcade_Mame_Game_Actions_Enter
      else if UpperCase(vKey) = 'UP' then
        uEmu_Arcade_Mame_Game_Actions_ArrowUp
      else if UpperCase(vKey) = 'DOWN' then
        uEmu_Arcade_Mame_Game_Actions_ArrowDown;
    end;
  end;
end;

procedure uEmu_Arcade_Mame_Keyboard_VirtualKeyboard_SetKey(vKey: string);
var
  vStringResult: String;
  vIntegerResult: Integer;
  vGameName: String;
  vi, ri: Integer;
  vFoundResult: Boolean;
  vFoundDrop: Boolean;
begin
  if vVirtual_Keyboard_Type = 'Search' then
    if (UpperCase(vKey) <> 'ENTER') and (UpperCase(vKey) <> 'ESC') and (UpperCase(vKey) <> 'UP') and (UpperCase(vKey) <> 'DOWN')
    then
    begin
      vFoundResult := False;
      vFoundDrop := False;
      vStringResult := VK_Edit.Text;
      if vStringResult = '' then
      begin
        mame.Gamelist.Selected := vMame_Search_Current_Selected;
        uEmu_Arcade_Mame_Gamelist_Refresh;
        uEmu_Arcade_Mame_Actions_ShowData;
        VK_Drop_Num := -1;
        VK_Drop_Num_Current := -1;
        for ri := 20 downto 0 do
          if Assigned(VK_Drop_Line_Back[ri]) then
            FreeAndNil(VK_Drop_Line_Back[ri]);
        VK_Drop_Background.Height := 0;
        VK_Title.Text := 'Search for a game';
      end
      else
      begin
        vIntegerResult := length(vStringResult);
        for vi := 0 to mame.Gamelist.Games_Count do
        begin
          vGameName := Copy(mame.Gamelist.List[0, vi, 1], 0, vIntegerResult);
          if UpperCase(vStringResult) = UpperCase(vGameName) then
          begin
            vFoundResult := True;
            Break
          end;
        end;

        if vFoundResult then
        begin
          mame.Gamelist.Selected := vi;
          VK_Title.Text := 'Found "' + mame.Gamelist.List[0, vi, 1] + '"';
          inc(vi, 1);
          uEmu_Arcade_Mame_Gamelist_Refresh;
          uEmu_Arcade_Mame_Actions_ShowData;
          VK_Drop_Num := -1;
          VK_Drop_Num_Current := -1;
          for ri := 20 downto 0 do
            if Assigned(VK_Drop_Line_Back[ri]) then
              FreeAndNil(VK_Drop_Line_Back[ri]);
          VK_Drop_Background.Height := 0;
          for ri := 0 to 20 do
          begin
            vGameName := Copy(mame.Gamelist.List[0, vi + ri, 1], 0, vIntegerResult);
            if UpperCase(vStringResult) = UpperCase(vGameName) then
            begin
              if ri = 20 then
                uVirtual_Keyboard_Add_DropLine(ri, '...', '')
              else
                uVirtual_Keyboard_Add_DropLine(ri, mame.Gamelist.List[0, vi + ri, 1],
                  mame.prog.Images + 'emu_mame.png');
            end
          end;
        end
        else
        begin
          vStringResult := VK_Edit.Text;
          Delete(vStringResult, length(vStringResult), 1);
          VK_Edit.Text := vStringResult;
          VK_Edit.SelStart := length(VK_Edit.Text);
          // Put code what to do if result not found like (warning, sound etc)
        end;

      end;
    end
    else
    begin
      if vKey = 'ESC' then
      begin
        mame.Gamelist.Selected := vMame_Search_Current_Selected;
        uEmu_Arcade_Mame_Gamelist_Refresh;
        uEmu_Arcade_Mame_Actions_ShowData;
        uVirtual_Keyboard_Free;
      end
      else if vKey = 'ENTER' then
      begin
        vFoundDrop := False;
        for vi := 0 to 19 do
          if Assigned(VK_Drop_Line_Back[vi]) then
            if VK_Drop_Line_Back[vi].Fill.Color = TAlphaColorRec.Deepskyblue then
            begin
              vFoundDrop := True;
              Break
            end;
        if vFoundDrop then
        begin
          VK_Edit.Text := VK_Drop_Text[vi].Text;
          VK_Edit.SelStart := length(VK_Edit.Text);
          uVirtual_Keyboard_DoAction('Drop');
        end
        else
          uVirtual_Keyboard_Free
      end;
    end;
end;

end.
