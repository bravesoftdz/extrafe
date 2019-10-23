unit uEmu_Arcade_Mame_Game_SetAll;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UITypes,
  FMX.Objects,
  FMX.Types,
  ALFmxLayouts;

procedure uEmu_Arcade_Mame_Game_Exit;

procedure uEmu_Arcade_Mame_Game_SetAll_Set;

// Data from mame
procedure uEmu_Arcade_Mame_Game_GetDataFromMame;

implementation

uses
  uDatabase,
  uDatabase_ActiveUser,
  uDatabase_SQLCommands,
  uLoad_AllTypes,
  uSnippet_Search,
  uEmu_Arcade_Mame,
  uEmu_Arcade_Mame_SetAll,
  uEmu_Arcade_Mame_Actions,
  uEmu_Arcade_Mame_Gamelist,
  uEmu_Arcade_Mame_AllTypes,
  uEmu_Arcade_Mame_Support_Files,
  uEmu_Arcade_Mame_Game_Actions;

procedure uEmu_Arcade_Mame_Game_SetAll_Set;
var
  vi: Integer;
begin
  for vi := 0 to 20 do
    vMame.Scene.Gamelist.List_Line[vi].text.text := '';

  for vi := 10 to 20 do
  begin
    vMame.Scene.Gamelist.List_Line[vi].text.text := cShowGamePanelMenu[vi - 10];
    if vi = 11 then
    begin
      if not FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Manuals + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.pdf') then
        vMame.Scene.Gamelist.List_Line[vi].text.Color := TAlphaColorRec.Red;
    end;
    if vi = 14 then
    begin
      if not FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Soundtracks + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.zip') then
        vMame.Scene.Gamelist.List_Line[14].text.Color := TAlphaColorRec.Red;
    end;
  end;
  vMame.Scene.Settings.TextSettings.FontColor := TAlphaColorRec.Lime;
  if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Fanart + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
  begin
    vMame.Scene.Left.Bitmap.LoadFromFile(user_Active_Local.EMULATORS.Arcade_D.Media.Fanart + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png');
    vMame.Scene.Right.Bitmap.LoadFromFile(user_Active_Local.EMULATORS.Arcade_D.Media.Fanart + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png');
    vMame.Scene.Right.BitmapMargins.Left := -960;
  end;

  if FileExists(user_Active_Local.EMULATORS.Arcade_D.Media.Stamps + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
  begin
    vMame.Scene.GameMenu.Stamp := TImage.Create(vMame.Scene.Media.Back);
    vMame.Scene.GameMenu.Stamp.Name := 'Mame_Game_Info_Stamp';
    vMame.Scene.GameMenu.Stamp.Parent := vMame.Scene.Media.Back;
    vMame.Scene.GameMenu.Stamp.SetBounds((vMame.Scene.Media.Back.Width / 2) - (400 / 2), 30, 400, 150);
    vMame.Scene.GameMenu.Stamp.Bitmap.LoadFromFile(user_Active_Local.EMULATORS.Arcade_D.Media.Stamps + mame.gamelist.ListGames[mame.Gamelist.Selected]
      + '.png');
    vMame.Scene.GameMenu.Stamp.WrapMode := TImageWrapMode.Fit;
    vMame.Scene.GameMenu.Stamp.Visible := True;
  end;

  vMame.Scene.GameMenu.Headline := TText.Create(vMame.Scene.Media.Back);
  vMame.Scene.GameMenu.Headline.Name := 'Mame_Game_Info_Headline';
  vMame.Scene.GameMenu.Headline.Parent := vMame.Scene.Media.Back;
  vMame.Scene.GameMenu.Headline.SetBounds((vMame.Scene.Media.Back.Width / 2) - (400 / 2), 190, 400, 22);
  vMame.Scene.GameMenu.Headline.text := 'General Info';
  vMame.Scene.GameMenu.Headline.Font.Family := 'Tahoma';
  vMame.Scene.GameMenu.Headline.Font.Size := 20;
  vMame.Scene.GameMenu.Headline.TextSettings.HorzAlign := TTextAlign.Center;
  vMame.Scene.GameMenu.Headline.Color := TAlphaColorRec.White;
  vMame.Scene.GameMenu.Headline.Font.Style := vMame.Scene.GameMenu.Headline.Font.Style + [TFontStyle.fsBold];
  vMame.Scene.GameMenu.Headline.Visible := True;

  vMame.Scene.GameMenu.Box := TALVertScrollBox.Create(vMame.Scene.Media.Back);
  vMame.Scene.GameMenu.Box.Name := 'Mame_Game_Info_VerticalScrollBox';
  vMame.Scene.GameMenu.Box.Parent := vMame.Scene.Media.Back;
  vMame.Scene.GameMenu.Box.SetBounds(10, 20, 730, 680);
  vMame.Scene.GameMenu.Box.ShowScrollBars := False;
  vMame.Scene.GameMenu.Box.Visible := True;

  mame.Game.Menu_Selected := 0;
  // vMame.Scene.Media.Type_Arcade.Visible := False;
  // vMame.Scene.Media.Black_Image.Visible := False;
  // vMame.Scene.Media.Video.Visible := False;
  // vMame.Scene.Media.Image.Visible := False;
  uSnippet_Search.vSearch.Scene.Back.Visible := False;
  vMame.Scene.Gamelist.Filters.Back.Visible := False;
  vMame.Scene.Gamelist.Up_Back_Image.Visible := False;
  vMame.Scene.Gamelist.Down_Back_Image.Visible := False;

  // Get data from mame for general info

  uEmu_Arcade_Mame_Game_GetDataFromMame;

end;

procedure uEmu_Arcade_Mame_Game_GetDataFromMame;
const
  cGameLabels: array [0 .. 10] of string = ('Game Name', 'Year', 'Manufacturer', 'Game Type', 'Refresh Rate', 'Width', 'Height', 'Sound Channels', 'Savestate',
    'Emulation', 'Overall Status');
var
  vi: Integer;
begin
  uDatabase_SQLCommands.vQuery := 'SELECT * FROM GAMES WHERE ROMNAME="' + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '"';
  vMame_Query.Close;
  vMame_Query.SQL.Clear;
  vMame_Query.SQL.Add(uDatabase_SQLCommands.vQuery);
  vMame_Query.Open;
  vMame_Query.First;

  for vi := 0 to 10 do
  begin
    vMame.Scene.GameMenu.Text_Caption[vi] := TText.Create(vMame.Scene.GameMenu.Box);
    vMame.Scene.GameMenu.Text_Caption[vi].Name := 'Mame_Game_Info_Text_Caption_' + vi.ToString;
    vMame.Scene.GameMenu.Text_Caption[vi].Parent := vMame.Scene.GameMenu.Box;
    vMame.Scene.GameMenu.Text_Caption[vi].SetBounds(10, 260 + (40 * vi), 300, 24);
    vMame.Scene.GameMenu.Text_Caption[vi].Font.Size := 20;
    vMame.Scene.GameMenu.Text_Caption[vi].Color := TAlphaColorRec.Deepskyblue;
    vMame.Scene.GameMenu.Text_Caption[vi].Font.Style := vMame.Scene.GameMenu.Text_Caption[vi].Font.Style + [TFontStyle.fsBold];
    vMame.Scene.GameMenu.Text_Caption[vi].Font.Family := 'Tahoma';
    vMame.Scene.GameMenu.Text_Caption[vi].TextSettings.HorzAlign := TTextAlign.Leading;
    vMame.Scene.GameMenu.Text_Caption[vi].WordWrap := True;
    vMame.Scene.GameMenu.Text_Caption[vi].text := cGameLabels[vi] + ' : ';
    vMame.Scene.GameMenu.Text_Caption[vi].Visible := True;

    vMame.Scene.GameMenu.text[vi] := TText.Create(vMame.Scene.GameMenu.Box);
    vMame.Scene.GameMenu.text[vi].Name := 'Mame_Game_Info_Text_' + vi.ToString;
    vMame.Scene.GameMenu.text[vi].Parent := vMame.Scene.GameMenu.Box;
    vMame.Scene.GameMenu.text[vi].SetBounds(320, 260 + (40 * vi), vMame.Scene.GameMenu.Box.Width - 330, 24);
    vMame.Scene.GameMenu.text[vi].Font.Size := 20;
    vMame.Scene.GameMenu.text[vi].Color := TAlphaColorRec.White;
    vMame.Scene.GameMenu.text[vi].Font.Style := vMame.Scene.GameMenu.Text_Caption[vi].Font.Style + [TFontStyle.fsBold];
    vMame.Scene.GameMenu.text[vi].Font.Family := 'Tahoma';
    vMame.Scene.GameMenu.text[vi].TextSettings.HorzAlign := TTextAlign.Leading;
    vMame.Scene.GameMenu.text[vi].WordWrap := True;
    case vi of
      0 :
         vMame.Scene.GameMenu.text[vi].text := vMame_Query.FieldByName('gamename').AsString;
      1 :
         vMame.Scene.GameMenu.text[vi].text := vMame_Query.FieldByName('year').AsString;
      2 :
         vMame.Scene.GameMenu.text[vi].text := vMame_Query.FieldByName('manufacturer').AsString;
      3 :
         vMame.Scene.GameMenu.text[vi].text := vMame_Query.FieldByName('displaytype').AsString;
      4 :
         vMame.Scene.GameMenu.text[vi].text := vMame_Query.FieldByName('refreshrate').AsString;
      5 :
         vMame.Scene.GameMenu.text[vi].text := vMame_Query.FieldByName('width').AsString;
      6 :
         vMame.Scene.GameMenu.text[vi].text := vMame_Query.FieldByName('height').AsString;
      7 :
         vMame.Scene.GameMenu.text[vi].text := vMame_Query.FieldByName('channels').AsString;
      8 :
         vMame.Scene.GameMenu.text[vi].text := vMame_Query.FieldByName('savestate').AsString;
      9 :
         vMame.Scene.GameMenu.text[vi].text := vMame_Query.FieldByName('emulation').AsString;
      10 :
         vMame.Scene.GameMenu.text[vi].text := vMame_Query.FieldByName('status').AsString;
    end;
    vMame.Scene.GameMenu.text[vi].Visible := True;
  end;
end;

procedure uEmu_Arcade_Mame_Game_Exit;
begin
  if FileExists(user_Active_Local.EMULATORS.Arcade_D.Mame_D.p_Database + 'game.xml') then
    System.SysUtils.DeleteFile(user_Active_Local.EMULATORS.Arcade_D.Mame_D.p_Database + 'game.xml');

  FreeAndNil(vMame.Scene.GameMenu.Stamp);
  FreeAndNil(vMame.Scene.GameMenu.Headline);
  FreeAndNil(vMame.Scene.GameMenu.Box);

  extrafe.Prog.State := 'mame';
  vMame.Scene.Settings.Tag := 1;

  uEmu_Arcade_Mame_SetAll.Create_Image_Scene;
  uSnippet_Search.vSearch.Scene.Back.Visible := True;
  vMame.Scene.Gamelist.Filters.Back.Visible := True;
  vMame.Scene.Gamelist.Up_Back_Image.Visible := True;
  vMame.Scene.Gamelist.Down_Back_Image.Visible := True;

  uEmu_Arcade_Mame_Gamelist_Refresh;
  vMame.Scene.Left.Bitmap.LoadFromFile(user_Active_Local.EMULATORS.Arcade_D.Mame_D.p_Images + 'background.png');
  vMame.Scene.Right.Bitmap.LoadFromFile(user_Active_Local.EMULATORS.Arcade_D.Mame_D.p_Images + 'background.png');
  vMame.Scene.Right.BitmapMargins.Left := -960;
  vMame.Scene.Settings.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;

  uEmu_Arcade_Mame_Actions.Show_Media;
end;

end.
