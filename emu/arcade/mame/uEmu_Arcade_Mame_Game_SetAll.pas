unit uEmu_Arcade_Mame_Game_SetAll;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UITypes,
  FMX.Objects,
  FMX.Types,
  FMX.Graphics,
  FMX.Layouts,
  ALFmxLayouts,
  Radiant.Shapes;



procedure Load;
procedure Free;

procedure Info_Box;

procedure Create_Loading_Game;
procedure Free_Loading_Game;

// Data from mame
procedure uEmu_Arcade_Mame_Game_GetDataFromMame;

implementation

uses
  uDB,
  uDB_AUser,
  uLoad_AllTypes,
  uSnippet_Search,
  uEmu_Arcade_Mame,
  uEmu_Arcade_Mame_SetAll,
  uEmu_Arcade_Mame_Actions,
  uEmu_Arcade_Mame_Gamelist,
  uEmu_Arcade_Mame_AllTypes,
  uEmu_Arcade_Mame_Support_Files,
  uEmu_Arcade_Mame_Game_Actions;

procedure Load;
var
  vi: Integer;
begin
  extrafe.Prog.State := 'mame_game';
  vMame.Scene.Settings.Tag := 2;
  for vi := 0 to 20 do
    vMame.Scene.Gamelist.List_Line[vi].text.text := '';

  for vi := 10 to 20 do
  begin
    vMame.Scene.Gamelist.List_Line[vi].text.text := cShowGamePanelMenu[vi - 10];
    if vi = 11 then
    begin
      if not FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Manuals + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.pdf') then
        vMame.Scene.Gamelist.List_Line[vi].text.Color := TAlphaColorRec.Red;
    end;
    if vi = 14 then
    begin
      if not FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Soundtracks + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.zip') then
        vMame.Scene.Gamelist.List_Line[14].text.Color := TAlphaColorRec.Red;
    end;
  end;
  vMame.Scene.Settings.TextSettings.FontColor := TAlphaColorRec.Lime;
  if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Fanart + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
  begin
    vMame.Scene.Left.Bitmap.LoadFromFile(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Fanart + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png');
    vMame.Scene.Right.Bitmap.LoadFromFile(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Fanart + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png');
    vMame.Scene.Right.BitmapMargins.Left := -960;
  end;

  if FileExists(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Stamps + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png') then
  begin
    vMame.Scene.GameMenu.Stamp := TImage.Create(vMame.Scene.Media.Back);
    vMame.Scene.GameMenu.Stamp.Name := 'Mame_Game_Info_Stamp';
    vMame.Scene.GameMenu.Stamp.Parent := vMame.Scene.Media.Back;
    vMame.Scene.GameMenu.Stamp.SetBounds((vMame.Scene.Media.Back.Width / 2) - (400 / 2), 30, 400, 150);
    vMame.Scene.GameMenu.Stamp.Bitmap.LoadFromFile(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Stamps + mame.Gamelist.ListGames[mame.Gamelist.Selected] + '.png');
    vMame.Scene.GameMenu.Stamp.WrapMode := TImageWrapMode.Fit;
    vMame.Scene.GameMenu.Stamp.Visible := True;
  end;

  Info_Box;

    mame.Game.Menu_Selected := 0;
  // vMame.Scene.Media.Type_Arcade.Visible := False;
  // vMame.Scene.Media.Black_Image.Visible := False;
  // vMame.Scene.Media.Video.Visible := False;
  // vMame.Scene.Media.Image.Visible := False;
  uSnippet_Search.vSearch.Scene.Back.Visible := False;
  vMame.Scene.Gamelist.Filters.Back.Visible := False;
  vMame.Scene.Gamelist.Up_Back_Image.Visible := False;
  vMame.Scene.Gamelist.Down_Back_Image.Visible := False;

  uEmu_Arcade_Mame_Game_Actions.Refresh;

end;

procedure Info_Box;
begin
  vMame.Scene.GameMenu.Info.Layout := TLayout.Create(vMame.Scene.Media.Back);
  vMame.Scene.GameMenu.Info.Layout.Name := 'Mame_Game_Info_Box';
  vMame.Scene.GameMenu.Info.Layout.Parent:=  vMame.Scene.Media.Back;
  vMame.Scene.GameMenu.Info.Layout.Align := TAlignLayout.Client;
  vMame.Scene.GameMenu.Info.Layout.Visible := True;


  vMame.Scene.GameMenu.Info.Headline := TText.Create(vMame.Scene.GameMenu.Info.Layout);
  vMame.Scene.GameMenu.Info.Headline.Name := 'Mame_Game_Info_Headline';
  vMame.Scene.GameMenu.Info.Headline.Parent := vMame.Scene.GameMenu.Info.Layout;
  vMame.Scene.GameMenu.Info.Headline.SetBounds(20, 20, vMame.Scene.Media.Back.Width - 40, 22);
  vMame.Scene.GameMenu.Info.Headline.text := 'General Info';
  vMame.Scene.GameMenu.Info.Headline.Font.Family := 'Tahoma';
  vMame.Scene.GameMenu.Info.Headline.Font.Size := 20;
  vMame.Scene.GameMenu.Info.Headline.TextSettings.HorzAlign := TTextAlign.Center;
  vMame.Scene.GameMenu.Info.Headline.Color := TAlphaColorRec.White;
  vMame.Scene.GameMenu.Info.Headline.Font.Style := vMame.Scene.GameMenu.Info.Headline.Font.Style + [TFontStyle.fsBold];
  vMame.Scene.GameMenu.Info.Headline.Visible := True;

  vMame.Scene.GameMenu.Info.Line := TRadiantLine.Create(vMame.Scene.GameMenu.Info.Layout);
  vMame.Scene.GameMenu.Info.Line.Name := 'Mame_Game_Info_Line';
  vMame.Scene.GameMenu.Info.Line.Parent := vMame.Scene.GameMenu.Info.Layout;
  vMame.Scene.GameMenu.Info.Line.SetBounds(20, 50, vMame.Scene.Media.Back.Width - 40, 4);
  vMame.Scene.GameMenu.Info.Line.LineSlope := TRadiantLineSlope.Horizontal;
  vMame.Scene.GameMenu.Info.Line.Stroke.Thickness := 4;
  vMame.Scene.GameMenu.Info.Line.Stroke.Color := TAlphaColorRec.Deepskyblue;
  vMame.Scene.GameMenu.Info.Line.Stroke.Cap := TStrokeCap.Round;
  vMame.Scene.GameMenu.Info.Line.Fill.Kind := TBrushKind.Solid;
  vMame.Scene.GameMenu.Info.Line.Fill.Color := TAlphaColorRec.Deepskyblue;
  vMame.Scene.GameMenu.Info.Line.Visible := True;

  vMame.Scene.GameMenu.Info.Box := TALVertScrollBox.Create(vMame.Scene.GameMenu.Info.Layout);
  vMame.Scene.GameMenu.Info.Box.Name := 'Mame_Game_Info_VerticalScrollBox';
  vMame.Scene.GameMenu.Info.Box.Parent := vMame.Scene.GameMenu.Info.Layout;
  vMame.Scene.GameMenu.Info.Box.SetBounds(10, 20, 730, 680);
  vMame.Scene.GameMenu.Info.Box.ShowScrollBars := False;
  vMame.Scene.GameMenu.Info.Box.Visible := True;

  uEmu_Arcade_Mame_Game_GetDataFromMame;
end;

procedure uEmu_Arcade_Mame_Game_GetDataFromMame;
const
  cGameLabels: array [0 .. 11] of string = ('Game Name', 'Year', 'Manufacturer', 'Game Type', 'Refresh Rate', 'Width', 'Height', 'Sound Channels', 'Savestate',
    'Emulation', 'Overall Status', 'Support Hiscore');
var
  vi: Integer;
  vQuery: String;
  vStr: String;
begin
  vQuery := 'SELECT * FROM GAMES WHERE ROMNAME="' + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '"';
  uDB.Arcade_Query.Close;
  uDB.Arcade_Query.SQL.Clear;
  uDB.Arcade_Query.SQL.Add(vQuery);
  uDB.Arcade_Query.Open;
  uDB.Arcade_Query.First;

  for vi := 0 to 11 do
  begin
    vMame.Scene.GameMenu.Info.Text_Caption[vi] := TText.Create(vMame.Scene.GameMenu.Info.Box);
    vMame.Scene.GameMenu.Info.Text_Caption[vi].Name := 'Mame_Game_Info_Text_Caption_' + vi.ToString;
    vMame.Scene.GameMenu.Info.Text_Caption[vi].Parent := vMame.Scene.GameMenu.Info.Box;
    if vi = 0 then
    begin
      vMame.Scene.GameMenu.Info.Text_Caption[vi].SetBounds(20, 60 + (40 * vi), 300, 100);
      vMame.Scene.GameMenu.Info.Text_Caption[vi].VertTextAlign := TTextAlign.Center;
    end
    else
      vMame.Scene.GameMenu.Info.Text_Caption[vi].SetBounds(20, 140 + (40 * vi), 300, 24);
    vMame.Scene.GameMenu.Info.Text_Caption[vi].Font.Size := 20;
    vMame.Scene.GameMenu.Info.Text_Caption[vi].Color := TAlphaColorRec.Deepskyblue;
    vMame.Scene.GameMenu.Info.Text_Caption[vi].Font.Style := vMame.Scene.GameMenu.Info.Text_Caption[vi].Font.Style + [TFontStyle.fsBold];
    vMame.Scene.GameMenu.Info.Text_Caption[vi].Font.Family := 'Tahoma';
    vMame.Scene.GameMenu.Info.Text_Caption[vi].TextSettings.HorzAlign := TTextAlign.Leading;
    vMame.Scene.GameMenu.Info.Text_Caption[vi].WordWrap := True;
    vMame.Scene.GameMenu.Info.Text_Caption[vi].text := cGameLabels[vi] + ' : ';
    vMame.Scene.GameMenu.Info.Text_Caption[vi].Visible := True;

    vMame.Scene.GameMenu.Info.text[vi] := TText.Create(vMame.Scene.GameMenu.Info.Box);
    vMame.Scene.GameMenu.Info.text[vi].Name := 'Mame_Game_Info_Text_' + vi.ToString;
    vMame.Scene.GameMenu.Info.text[vi].Parent := vMame.Scene.GameMenu.Info.Box;
    if vi= 0  then
    begin
      vMame.Scene.GameMenu.Info.text[vi].SetBounds(320, 60 + (40 * vi), vMame.Scene.GameMenu.Info.Box.Width - 330, 100);
      vMame.Scene.GameMenu.Info.text[vi].VertTextAlign := TTextAlign.Center;
    end
    else
      vMame.Scene.GameMenu.Info.text[vi].SetBounds(320, 140 + (40 * vi), vMame.Scene.GameMenu.Info.Box.Width - 330, 24);
    vMame.Scene.GameMenu.Info.text[vi].Font.Size := 20;
    vMame.Scene.GameMenu.Info.text[vi].Color := TAlphaColorRec.White;
    vMame.Scene.GameMenu.Info.text[vi].Font.Style := vMame.Scene.GameMenu.Info.Text_Caption[vi].Font.Style + [TFontStyle.fsBold];
    vMame.Scene.GameMenu.Info.text[vi].Font.Family := 'Tahoma';
    vMame.Scene.GameMenu.Info.text[vi].TextSettings.HorzAlign := TTextAlign.Leading;
    vMame.Scene.GameMenu.Info.text[vi].WordWrap := True;
    case vi of
      0:
        vMame.Scene.GameMenu.Info.text[vi].text := uDB.Arcade_Query.FieldByName('gamename').AsString;
      1:
        vMame.Scene.GameMenu.Info.text[vi].text := uDB.Arcade_Query.FieldByName('year').AsString;
      2:
        vMame.Scene.GameMenu.Info.text[vi].text := uDB.Arcade_Query.FieldByName('manufacturer').AsString;
      3:
        vMame.Scene.GameMenu.Info.text[vi].text := uDB.Arcade_Query.FieldByName('displaytype').AsString;
      4:
        vMame.Scene.GameMenu.Info.text[vi].text := uDB.Arcade_Query.FieldByName('refreshrate').AsString;
      5:
        vMame.Scene.GameMenu.Info.text[vi].text := uDB.Arcade_Query.FieldByName('width').AsString;
      6:
        vMame.Scene.GameMenu.Info.text[vi].text := uDB.Arcade_Query.FieldByName('height').AsString;
      7:
        vMame.Scene.GameMenu.Info.text[vi].text := uDB.Arcade_Query.FieldByName('channels').AsString;
      8:
        vMame.Scene.GameMenu.Info.text[vi].text := uDB.Arcade_Query.FieldByName('savestate').AsString;
      9:
        vMame.Scene.GameMenu.Info.text[vi].text := uDB.Arcade_Query.FieldByName('emulation').AsString;
      10:
        vMame.Scene.GameMenu.Info.text[vi].text := uDB.Arcade_Query.FieldByName('status').AsString;
      11:
        begin
          vStr := uDB.Arcade_Query.FieldByName('hiscore').AsString;
          if vStr = '0' then
            vMame.Scene.GameMenu.Info.text[vi].text := 'No'
          else
            vMame.Scene.GameMenu.Info.text[vi].text := 'Yes';
        end;
    end;
    vMame.Scene.GameMenu.Info.text[vi].Visible := True;
  end;
end;

procedure Free;
begin
  if Assigned(vMame.Scene.GameMenu.Info.Layout) then
    FreeAndNil(vMame.Scene.GameMenu.Info.Layout);

  extrafe.Prog.State := 'mame';
  vMame.Scene.Settings.Tag := 1;

  vMame.Scene.Settings.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  uEmu_Arcade_Mame_SetAll.Show_Image_Scene(True);
  uSnippet_Search.vSearch.Scene.Back.Visible := True;
  vMame.Scene.Gamelist.Filters.Back.Visible := True;
  vMame.Scene.Gamelist.Up_Back_Image.Visible := True;
  vMame.Scene.Gamelist.Down_Back_Image.Visible := True;
  vMame.Scene.Media.T_Players.Layout.Visible := True;

  uEmu_Arcade_Mame_Gamelist.Refresh;
  uEmu_Arcade_Mame_Actions.Show_Media;
end;

procedure Create_Loading_Game;
begin
  vMame.Scene.Left_Blur.Enabled := True;
  vMame.Scene.Right_Blur.Enabled := True;
  vMame.Scene.Gamelist.List.Visible := False;
  vMame.Scene.Media.Back.Visible := False;

  vMame.Scene.PopUp.Back := TImage.Create(vMame.Scene.Main);
  vMame.Scene.PopUp.Back.Name := 'Mame_Loading_Game';
  vMame.Scene.PopUp.Back.Parent := vMame.Scene.Main;
  vMame.Scene.PopUp.Back.SetBounds(((vMame.Scene.Main.Width / 2) - 500), ((vMame.Scene.Main.Height / 2 - 200) - 150), 1000, 500);
  vMame.Scene.PopUp.Back.Bitmap.LoadFromFile(uDB_AUser.Local.EMULATORS.Arcade_D.Mame_D.p_Images + 'black_menu.png');
  vMame.Scene.PopUp.Back.WrapMode := TImageWrapMode.Tile;
  vMame.Scene.PopUp.Back.Visible := True;

  vMame.Scene.PopUp.Line1 := TText.Create(vMame.Scene.PopUp.Back);
  vMame.Scene.PopUp.Line1.Name := 'vMame_Loading_Game_Line1';
  vMame.Scene.PopUp.Line1.Parent := vMame.Scene.PopUp.Back;
  vMame.Scene.PopUp.Line1.SetBounds(0, 20, 1000, 50);
  vMame.Scene.PopUp.Line1.Text := 'Loading Game : ';
  vMame.Scene.PopUp.Line1.Font.Family := 'Tahoma';
  vMame.Scene.PopUp.Line1.Font.Size := 36;
  vMame.Scene.PopUp.Line1.TextSettings.HorzAlign := TTextAlign.Center;
  vMame.Scene.PopUp.Line1.Color := TAlphaColorRec.Deepskyblue;
  vMame.Scene.PopUp.Line1.Font.Style := vMame.Scene.PopUp.Line1.Font.Style + [TFontStyle.fsBold];
  vMame.Scene.PopUp.Line1.Visible := True;

  vMame.Scene.PopUp.Line2 := TText.Create(vMame.Scene.PopUp.Back);
  vMame.Scene.PopUp.Line2.Name := 'Mame_Loading_Game_Line2';
  vMame.Scene.PopUp.Line2.Parent := vMame.Scene.PopUp.Back;
  vMame.Scene.PopUp.Line2.SetBounds(0, 90, 1000, 100);
  vMame.Scene.PopUp.Line2.Text := mame.Gamelist.ListGames[mame.Gamelist.Selected];
  vMame.Scene.PopUp.Line2.Font.Family := 'Tahoma';
  vMame.Scene.PopUp.Line2.Font.Size := 36;
  vMame.Scene.PopUp.Line2.TextSettings.HorzAlign := TTextAlign.Center;
  vMame.Scene.PopUp.Line2.Color := TAlphaColorRec.White;
  vMame.Scene.PopUp.Line2.Font.Style := vMame.Scene.PopUp.Line2.Font.Style + [TFontStyle.fsBold];
  vMame.Scene.PopUp.Line2.Visible := True;

  vMame.Scene.PopUp.Snap := TImage.Create(vMame.Scene.PopUp.Back);
  vMame.Scene.PopUp.Snap.Name := 'Mame_Loading_Game_Snap';
  vMame.Scene.PopUp.Snap.Parent:=   vMame.Scene.PopUp.Back;
  vMame.Scene.PopUp.Snap.SetBounds(400, 200, 200, 200);
  vMame.Scene.PopUp.Snap.Bitmap.LoadFromFile(uDB_AUser.Local.EMULATORS.Arcade_D.Media.Snapshots + mame.Gamelist.ListRoms[mame.Gamelist.Selected] + '.png');
  vMame.Scene.PopUp.Snap.WrapMode:= TImageWrapMode.Center;
  vMame.Scene.PopUp.Snap.Visible:= True;


  vMame.Scene.PopUp.Line3_Text := TText.Create(vMame.Scene.PopUp.Back);
  vMame.Scene.PopUp.Line3_Text.Name := 'Mame_Loading_Game_Line3_Text';
  vMame.Scene.PopUp.Line3_Text.Parent := vMame.Scene.PopUp.Back;
  vMame.Scene.PopUp.Line3_Text.SetBounds(20, 440, 200, 50);
  vMame.Scene.PopUp.Line3_Text.Text := 'Was played : ';
  vMame.Scene.PopUp.Line3_Text.Font.Family := 'Tahoma';
  vMame.Scene.PopUp.Line3_Text.Font.Size := 24;
  vMame.Scene.PopUp.Line3_Text.TextSettings.HorzAlign := TTextAlign.Leading;
  vMame.Scene.PopUp.Line3_Text.Color := TAlphaColorRec.White;
  vMame.Scene.PopUp.Line3_Text.Font.Style := vMame.Scene.PopUp.Line2.Font.Style + [TFontStyle.fsBold];
  vMame.Scene.PopUp.Line3_Text.Visible := True;

  vMame.Scene.PopUp.Line3_Value := TText.Create(vMame.Scene.PopUp.Back);
  vMame.Scene.PopUp.Line3_Value.Name := 'Mame_Loading_Game_Line3_Value';
  vMame.Scene.PopUp.Line3_Value.Parent := vMame.Scene.PopUp.Back;
  vMame.Scene.PopUp.Line3_Value.SetBounds(180, 440, 200, 50);
  vMame.Scene.PopUp.Line3_Value.Text := '0';
  vMame.Scene.PopUp.Line3_Value.Font.Family := 'Tahoma';
  vMame.Scene.PopUp.Line3_Value.Font.Size := 24;
  vMame.Scene.PopUp.Line3_Value.TextSettings.HorzAlign := TTextAlign.Leading;
  vMame.Scene.PopUp.Line3_Value.Color := TAlphaColorRec.Deepskyblue;
  vMame.Scene.PopUp.Line3_Value.Font.Style := vMame.Scene.PopUp.Line2.Font.Style + [TFontStyle.fsBold];
  vMame.Scene.PopUp.Line3_Value.Visible := True;

end;

procedure Free_Loading_Game;
begin
  FreeAndNil(vMame.Scene.PopUp.Back);
  vMame.Scene.Left_Blur.Enabled := False;
  vMame.Scene.Right_Blur.Enabled := False;
  vMame.Scene.Gamelist.List.Visible := True;
  vMame.Scene.Media.Back.Visible := True;
end;

end.
