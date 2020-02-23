unit uView_Mode_Default_Key;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UITypes,
  System.StrUtils,
  BASS;

procedure Key(vKey: String);

procedure VK_Key(vKey: String);

procedure Search_Key(vString: String);

implementation

uses
  uDB_AUser,
  uVirtual_Keyboard,
  uView_Mode_Default_AllTypes,
  uView_Mode_Default_Actions,
  uView_Mode_Default_Game;

procedure Key(vKey: String);
begin

  if (uDB_AUser.Local.OPTIONS.Visual.Virtual_Keyboard) and (Emu_VM_Video_Var.Search_Open) then
    VK_Key(vKey)
  else
  begin
    if Emu_VM_Video_Var.Game_Loading = False then
    begin
      if Emu_VM_Video_Var.Search_Open = False then
      begin
        if UpperCase(vKey) = 'ESC' then
          uView_Mode_Default_Actions.Exit_Action
        else if UpperCase(vKey) = 'ENTER' then
          if uVirtual_Keyboard.vKey.Enter_Pressed then
            uVirtual_Keyboard.vKey.Enter_Pressed := False
          else
            uView_Mode_Default_Actions.Enter;
      end;
      if Emu_VM_Video_Var.Search_Open then
      begin
        if UpperCase(vKey) = 'ESC' then
        begin
          uView_Mode_Default_Actions.Search_Open;
          Emu_VM_Video_Var.gamelist.Selected := Emu_VM_Video_Var.search.Selected;
          uView_Mode_Default_Actions.Refresh;
        end
        else if UpperCase(vKey) = 'ENTER' then
          uView_Mode_Default_Actions.Search_Open
        else if UpperCase(vKey) = 'BACKSPACE' then
          uView_Mode_Default_Actions.Search_Backspace
        else if UpperCase(vKey) = 'SPACE' then
          Emu_VM_Video_Var.search.vString := Emu_VM_Video_Var.search.vString + ' '
        else
        begin
          if AnsiContainsText('A B C D E F G H I G K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9 0 '' ( ) @ ! $ % ^ & * : < > ?', vKey) then
          begin
            if Emu_VM_Video_Var.search.vString = 'First' then
              Emu_VM_Video_Var.search.vString := '';
            Emu_VM_Video_Var.search.vString := Emu_VM_Video_Var.search.vString + vKey;
            Emu_VM_Video_Var.search.vKey := vKey;
          end;
        end;
      end
      else if Emu_VM_Video_Var.Game_Mode then
      begin
        if UpperCase(vKey) = 'DOWN' then
          uView_Mode_Default_Game.Menu_Down
        else if UpperCase(vKey) = 'UP' then
          uView_Mode_Default_Game.Menu_Up;
      end
      else
      begin
        if UpperCase(vKey) = 'DOWN' then
          uView_Mode_Default_Actions.Move_Gamelist('DOWN')
        else if UpperCase(vKey) = 'UP' then
          uView_Mode_Default_Actions.Move_Gamelist('UP')
        else if UpperCase(vKey) = 'PAGE UP' then
          uView_Mode_Default_Actions.Move_Gamelist('PAGE UP')
        else if UpperCase(vKey) = 'PAGE DOWN' then
          uView_Mode_Default_Actions.Move_Gamelist('PAGE DOWN')
        else if UpperCase(vKey) = 'HOME' then
          uView_Mode_Default_Actions.Move_Gamelist('HOME')
        else if UpperCase(vKey) = 'END' then
          uView_Mode_Default_Actions.Move_Gamelist('END')
        else if UpperCase(vKey) = 'R' then
          uView_Mode_Default_Actions.Favorites_Open
        else if UpperCase(vKey) = 'T' then
          uView_Mode_Default_Actions.Favorites_Add
        else if UpperCase(vKey) = 'S' then
        begin
          Emu_VM_Video_Var.search.vString := 'First';
          uView_Mode_Default_Actions.Search_Open;
        end;
      end;
    end;
  end;
end;

procedure VK_Key(vKey: String);
var
  vStringResult: String;
  vIntegerResult: Integer;
  vGameName: String;
  vi, ri: Integer;
  vFoundResult: Boolean;
  vFoundDrop: Boolean;
begin
  if uVirtual_Keyboard.vKey.OPTIONS.vType = 'Search' then
  begin
    if (UpperCase(vKey) <> 'ENTER') and (UpperCase(vKey) <> 'ESC') and (UpperCase(vKey) <> 'UP') and (UpperCase(vKey) <> 'DOWN') and (UpperCase(vKey) <> 'LEFT')
      and (UpperCase(vKey) <> 'RIGHT') then
    begin
      vFoundResult := False;
      vFoundDrop := False;
      vStringResult := uVirtual_Keyboard.vKey.Construct.Edit.Edit.Text;
      if vStringResult = '' then
      begin
        Emu_VM_Video_Var.gamelist.Selected := Emu_VM_Video_Var.search.Selected;
        uView_Mode_Default_Actions.Refresh;
        uVirtual_Keyboard.Clear_Drop;
        uVirtual_Keyboard.vKey.Construct.Title.Text.Text := 'Search for a game';
      end
      else
      begin
        vIntegerResult := Length(vStringResult);
        for vi := 0 to Emu_VM_Video_Var.gamelist.Total_Games - 1 do
        begin
          if Emu_VM_Video_Var.Favorites_Open then
            vGameName := Copy(Emu_VM_Video_Var.favorites.games[vi], 0, vIntegerResult)
          else
            vGameName := Copy(Emu_VM_Video_Var.gamelist.games[vi], 0, vIntegerResult);
          if UpperCase(vStringResult) = UpperCase(vGameName) then
          begin
            vFoundResult := True;
            Break
          end;
        end;

        if vFoundResult then
        begin
          Emu_VM_Video_Var.gamelist.Selected := vi;
          if Emu_VM_Video_Var.Favorites_Open then
            uVirtual_Keyboard.vKey.Construct.Title.Text.Text := 'Found "' + Emu_VM_Video_Var.favorites.games[vi] + '"'
          else
            uVirtual_Keyboard.vKey.Construct.Title.Text.Text := 'Found "' + Emu_VM_Video_Var.gamelist.games[vi] + '"';
          inc(vi, 1);
          uView_Mode_Default_Actions.Refresh;
          uVirtual_Keyboard.Clear_Drop;
          for ri := 0 to 20 do
          begin
            vGameName := Copy(Emu_VM_Video_Var.gamelist.games[vi + ri], 0, vIntegerResult);
            if UpperCase(vStringResult) = UpperCase(vGameName) then
            begin
              if ri = 20 then
                uVirtual_Keyboard.Drop(ri, '...', '')
              else
              begin
                if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Icons + Emu_VM_Video_Var.gamelist.Roms[vi + ri] + '.ico') then
                  uVirtual_Keyboard.Drop(ri, Emu_VM_Video_Var.gamelist.games[vi + ri], uDB_AUser.Local.EMULATORS.Arcade_D.Media.Icons +
                    Emu_VM_Video_Var.gamelist.Roms[vi + ri] + '.ico')
                else
                  uVirtual_Keyboard.Drop(ri, Emu_VM_Video_Var.gamelist.games[vi + ri], Emu_XML.Images_Path + 'emu_mame.png');
              end;
            end
          end;
        end
        else
        begin
          vStringResult := uVirtual_Keyboard.vKey.Construct.Edit.Edit.Text;
          Delete(vStringResult, Length(vStringResult), 1);
          uVirtual_Keyboard.vKey.Construct.Edit.Edit.Text := vStringResult;
          uVirtual_Keyboard.vKey.Construct.Edit.Edit.SelStart := Length(uVirtual_Keyboard.vKey.Construct.Edit.Edit.Text);
          BASS_ChannelPlay(Emu_VM_Video_Var.sounds.VK_Click, False);
        end;

      end;
    end
    else
    begin
      if UpperCase(vKey) = 'ESC' then
      begin
        if not uVirtual_Keyboard.vKey.Enter_Pressed then
        begin
          Emu_VM_Video_Var.gamelist.Selected := Emu_VM_Video_Var.search.Selected;
          uView_Mode_Default_Actions.Refresh;
          uVirtual_Keyboard.Animation(False);
          Emu_VM_Video_Var.Search_Open := False;
        end;
      end
      else if UpperCase(vKey) = 'ENTER' then
      begin
        if not uVirtual_Keyboard.vKey.Enter_Pressed then
        begin
          vFoundDrop := False;
          for vi := 0 to 19 do
            if Assigned(uVirtual_Keyboard.vKey.Construct.Drop.Line_Back[vi]) then
              if uVirtual_Keyboard.vKey.Construct.Drop.Line_Back[vi].Fill.Color = TAlphaColorRec.Deepskyblue then
              begin
                vFoundDrop := True;
                Break
              end;
          if vFoundDrop then
          begin
            uVirtual_Keyboard.vKey.Construct.Edit.Edit.Text := uVirtual_Keyboard.vKey.Construct.Drop.Text[vi].Text;
            uVirtual_Keyboard.vKey.Construct.Edit.Edit.SelStart := Length(uVirtual_Keyboard.vKey.Construct.Edit.Edit.Text);
            uVirtual_Keyboard.Press('Drop');
          end
          else
          begin
            uVirtual_Keyboard.Animation(False);
            Emu_VM_Video_Var.Search_Open := False;
          end
        end
      end;
    end;
  end;
end;

procedure Search_Key(vString: String);
var
  vGameName: String;
  vi: Integer;
begin
  if vString = '' then
  begin
    Emu_VM_Video_Var.gamelist.Selected := Emu_VM_Video_Var.search.Selected;
    uView_Mode_Default_Actions.Refresh;
  end
  else
  begin
    for vi := 0 to Emu_VM_Video_Var.gamelist.Total_Games - 1 do
    begin
      vGameName := Copy(Emu_VM_Video_Var.gamelist.games[vi], 0, Length(vString));
      if UpperCase(vString) = UpperCase(vGameName) then
      begin
        Emu_VM_Video_Var.gamelist.Selected := vi;
        uView_Mode_Default_Actions.Refresh;
        Break
      end;
    end;
    if UpperCase(vString) <> UpperCase(vGameName) then
    begin
      // Delete(vSearch.Actions.Search_Str, length(uSnippet_Search.vSearch.Actions.Search_Str), 1);
      // uSnippet_Search.vSearch.Scene.Edit.Text := uSnippet_Search.vSearch.Actions.Search_Str_Clear;
      // BASS_ChannelPlay(mame.Sound.Effects[0], False);
      // uSnippet_Search.vSearch.Actions.Str_Error := True;
    end;
  end;
end;

end.
