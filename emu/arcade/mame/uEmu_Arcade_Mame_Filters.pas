unit uEmu_Arcade_Mame_Filters;

interface

uses
  System.Classes,
  System.UiTypes,
  System.SysUtils,
  System.Inifiles,
  System.StrUtils,
  FMX.Objects,
  FMX.Listbox,
  FMX.StdCtrls,
  FMX.Effects,
  FMX.Types;

procedure Load;
procedure Free;

procedure Add;
procedure Remove(vPanel_Num: Integer);
procedure Sort_Filter_Panels;

procedure Second_Choose(vName: String; vPanel: Integer);
procedure Combo_Create_Filter(vFilter: String; vPanel: Integer);

procedure Filter_Result(vFilter, vResponse: String; vPanel: Integer);

procedure List_Result;

procedure Return;

implementation

uses
  uDatabase_ActiveUser,
  uDatabase_SQLCommands,
  uLoad_AllTypes,
  emu,
  uWindows,
  uEmu_Arcade_Mame,
  uEmu_Arcade_Mame_SetAll,
  uEmu_Arcade_Mame_Gamelist,
  uEmu_Arcade_Mame_AllTypes,
  uEmu_Arcade_Mame_Ini;

procedure Load;
begin
  if vMame.Scene.Media.Video.IsPlay then
    vMame.Scene.Media.Video.Pause;
  extrafe.Prog.State := 'mame_filters';
  vMame.Scene.Left_Blur.Enabled := True;
  vMame.Scene.Right_Blur.Enabled := True;

  mame.Filters.Filter_Done := False;

  mame.Filters.Added := 0;
  mame.Filters.List_Added := TStringList.Create;
  mame.Filters.List_Added.NameValueSeparator := '=';
  mame.Filters.List := TStringList.Create;
  mame.Filters.List.Add('Year');
  mame.Filters.List.Add('Manufacturer');
  mame.Filters.List.Add('Genre');
  mame.Filters.List.Add('Adult');
  mame.Filters.List.Add('Original');
  mame.Filters.List.Add('Mechanical');
  mame.Filters.List.Add('Working');
  mame.Filters.List.Add('Monochrome');
  mame.Filters.List.Add('Screenless');
  mame.Filters.List.Add('Languages');

  mame.Filters.Temp_ListRoms_Final := TStringList.Create;
  mame.Filters.Temp_ListGames_Final := TStringList.Create;
  mame.Filters.Temp_ListRoms := TStringList.Create;
  mame.Filters.Temp_ListGames := TStringList.Create;

  vMame.Scene.Settings_Ani.Enabled := False;

  vMame.Scene.Gamelist.Filters.Window.Panel := TPanel.Create(vMame.Scene.Main);
  vMame.Scene.Gamelist.Filters.Window.Panel.Name := 'Mame_Window_Filters';
  vMame.Scene.Gamelist.Filters.Window.Panel.Parent := vMame.Scene.Main;
  vMame.Scene.Gamelist.Filters.Window.Panel.SetBounds(vMame.Scene.Left.Width - 275, 250, 550, 300);
  vMame.Scene.Gamelist.Filters.Window.Panel.Visible := True;

  vMame.Scene.Gamelist.Filters.Window.Shadow := TShadowEffect.Create(vMame.Scene.Gamelist.Filters.Window.Panel);
  vMame.Scene.Gamelist.Filters.Window.Shadow.Name := 'Main_Window_Filters_Shadow';
  vMame.Scene.Gamelist.Filters.Window.Shadow.Parent := vMame.Scene.Gamelist.Filters.Window.Panel;
  vMame.Scene.Gamelist.Filters.Window.Shadow.Enabled := True;

  CreateHeader(vMame.Scene.Gamelist.Filters.Window.Panel, 'IcoMoon-Free', #$ea5b, 'Select desire filters to narrow the list', False, nil);

  vMame.Scene.Gamelist.Filters.Window.Info := TText.Create(vMame.Scene.Gamelist.Filters.Window.Panel);
  vMame.Scene.Gamelist.Filters.Window.Info.Name := 'Main_Window_Filters_Info';
  vMame.Scene.Gamelist.Filters.Window.Info.Parent := vMame.Scene.Gamelist.Filters.Window.Panel;
  vMame.Scene.Gamelist.Filters.Window.Info.SetBounds(10, 35, 400, 30);
  vMame.Scene.Gamelist.Filters.Window.Info.Font.Size := 14;
  vMame.Scene.Gamelist.Filters.Window.Info.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vMame.Scene.Gamelist.Filters.Window.Info.HorzTextAlign := TTextAlign.Leading;
  vMame.Scene.Gamelist.Filters.Window.Info.Text := 'Filtering list games : ';
  vMame.Scene.Gamelist.Filters.Window.Info.Visible := True;

  vMame.Scene.Gamelist.Filters.Window.Games_Num := TText.Create(vMame.Scene.Gamelist.Filters.Window.Panel);
  vMame.Scene.Gamelist.Filters.Window.Games_Num.Name := 'Main_Window_Filters_Games_Num';
  vMame.Scene.Gamelist.Filters.Window.Games_Num.Parent := vMame.Scene.Gamelist.Filters.Window.Panel;
  vMame.Scene.Gamelist.Filters.Window.Games_Num.SetBounds(136, 35, 400, 30);
  vMame.Scene.Gamelist.Filters.Window.Games_Num.Font.Size := 14;
  vMame.Scene.Gamelist.Filters.Window.Games_Num.TextSettings.FontColor := TAlphaColorRec.Limegreen;
  vMame.Scene.Gamelist.Filters.Window.Games_Num.HorzTextAlign := TTextAlign.Leading;
  vMame.Scene.Gamelist.Filters.Window.Games_Num.Text := '';
  vMame.Scene.Gamelist.Filters.Window.Games_Num.Visible := True;

  vMame.Scene.Gamelist.Filters.Window.Add := TButton.Create(vMame.Scene.Gamelist.Filters.Window.Panel);
  vMame.Scene.Gamelist.Filters.Window.Add.Name := 'Mame_Window_Filters_Add';
  vMame.Scene.Gamelist.Filters.Window.Add.Parent := vMame.Scene.Gamelist.Filters.Window.Panel;
  vMame.Scene.Gamelist.Filters.Window.Add.SetBounds(vMame.Scene.Gamelist.Filters.Window.Panel.Width - 34, 38, 30, 30);
  vMame.Scene.Gamelist.Filters.Window.Add.StyleLookup := 'addtoolbutton';
  vMame.Scene.Gamelist.Filters.Window.Add.Anchors := [TAnchorKind.akRight, TAnchorKind.akTop];
  vMame.Scene.Gamelist.Filters.Window.Add.OnClick := mame.Input.Mouse.Button.OnMouseClick;
  vMame.Scene.Gamelist.Filters.Window.Add.Visible := True;

  vMame.Scene.Gamelist.Filters.Window.OK := TButton.Create(vMame.Scene.Gamelist.Filters.Window.Panel);
  vMame.Scene.Gamelist.Filters.Window.OK.Name := 'Mame_Window_Filters_OK';
  vMame.Scene.Gamelist.Filters.Window.OK.Parent := vMame.Scene.Gamelist.Filters.Window.Panel;
  vMame.Scene.Gamelist.Filters.Window.OK.SetBounds(50, vMame.Scene.Gamelist.Filters.Window.Panel.Height - 40, 100, 30);
  vMame.Scene.Gamelist.Filters.Window.OK.Text := 'OK';
  vMame.Scene.Gamelist.Filters.Window.OK.Anchors := [TAnchorKind.akBottom, TAnchorKind.akLeft];
  vMame.Scene.Gamelist.Filters.Window.OK.OnClick := mame.Input.Mouse.Button.OnMouseClick;
  vMame.Scene.Gamelist.Filters.Window.OK.Visible := True;

  vMame.Scene.Gamelist.Filters.Window.Cancel := TButton.Create(vMame.Scene.Gamelist.Filters.Window.Panel);
  vMame.Scene.Gamelist.Filters.Window.Cancel.Name := 'Mame_Window_Filters_Cancel';
  vMame.Scene.Gamelist.Filters.Window.Cancel.Parent := vMame.Scene.Gamelist.Filters.Window.Panel;
  vMame.Scene.Gamelist.Filters.Window.Cancel.SetBounds(412, vMame.Scene.Gamelist.Filters.Window.Panel.Height - 40, 100, 30);
  vMame.Scene.Gamelist.Filters.Window.Cancel.Text := 'Cancel';
  vMame.Scene.Gamelist.Filters.Window.Cancel.Anchors := [TAnchorKind.akBottom, TAnchorKind.akRight];
  vMame.Scene.Gamelist.Filters.Window.Cancel.OnClick := mame.Input.Mouse.Button.OnMouseClick;
  vMame.Scene.Gamelist.Filters.Window.Cancel.Visible := True;
end;

procedure Free;
begin
  extrafe.Prog.State := 'mame';
  FreeAndNil(vMame.Scene.Gamelist.Filters.Window.Panel);
  vMame.Scene.Left_Blur.Enabled := False;
  vMame.Scene.Right_Blur.Enabled := False;
  vMame.Scene.Settings_Ani.Enabled := True;
  if vMame.Scene.Media.Video.IsPause then
    vMame.Scene.Media.Video.Resume;
end;

procedure Add;
var
  vi: Integer;
  vPanel_Height: Integer;
begin
  if (mame.Filters.Filter_Done) or (mame.Filters.Added = 0) then
  begin
    vPanel_Height := 0;
    inc(mame.Filters.Added, 1);
    SetLength(vMame.Scene.Gamelist.Filters.Window.Filter_Panels, mame.Filters.Added);

    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Panel := TPanel.Create(vMame.Scene.Gamelist.Filters.Window.Panel);
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Panel.Name := 'Mame_Window_Filters_Filter_Panel_' +
      (mame.Filters.Added - 1).ToString;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Panel.Parent := vMame.Scene.Gamelist.Filters.Window.Panel;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Panel.SetBounds(10, 70 + ((mame.Filters.Added - 1) * 70),
      vMame.Scene.Gamelist.Filters.Window.Panel.Width - 20, 60);
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Panel.Visible := True;

    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Remove :=
      TButton.Create(vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Panel);
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Remove.Name := 'Mame_Window_Filters_Filter_Remove_' +
      (mame.Filters.Added - 1).ToString;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Remove.Parent := vMame.Scene.Gamelist.Filters.Window.Filter_Panels
      [mame.Filters.Added - 1].Panel;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Remove.SetBounds
      (vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Panel.Width - 36, 15, 30, 30);
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Remove.StyleLookup := 'trashtoolbutton';
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Remove.OnClick := mame.Input.Mouse.Button.OnMouseClick;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Remove.Tag := mame.Filters.Added - 1;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Remove.Visible := True;

    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Filter_Name :=
      TText.Create(vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Panel);
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Filter_Name.Name := 'Mame_Window_Filters_Filter_Name_' +
      (mame.Filters.Added - 1).ToString;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Filter_Name.Parent := vMame.Scene.Gamelist.Filters.Window.Filter_Panels
      [mame.Filters.Added - 1].Panel;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Filter_Name.SetBounds(10, 2, 300, 20);
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Filter_Name.Text := 'Filter : ';
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Filter_Name.Font.Size := 14;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Filter_Name.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Filter_Name.HorzTextAlign := TTextAlign.Leading;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Filter_Name.Visible := True;

    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Choose :=
      TComboBox.Create(vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Panel);
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Choose.Name := 'Mame_Window_Filters_Filter_Combo_' +
      (mame.Filters.Added - 1).ToString;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Choose.Parent := vMame.Scene.Gamelist.Filters.Window.Filter_Panels
      [mame.Filters.Added - 1].Panel;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Choose.SetBounds(10, 25, 150, 28);
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Choose.Tag := mame.Filters.Added - 1;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Choose.OnChange := mame.Input.Mouse.ComboBox.OnChange;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Choose.Visible := True;

    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result :=
      TText.Create(vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Panel);
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result.Name := 'Mame_Window_Filters_Filter_Result_' +
      (mame.Filters.Added - 1).ToString;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result.Parent := vMame.Scene.Gamelist.Filters.Window.Filter_Panels
      [mame.Filters.Added - 1].Panel;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result.SetBounds(340, 2, 150, 20);
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result.Text := 'Result';
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result.Font.Size := 14;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result.HorzTextAlign := TTextAlign.Center;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result.Visible := False;

    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result_Num :=
      TText.Create(vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Panel);
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result_Num.Name := 'Mame_Window_Filters_Filter_Result_Num_' +
      (mame.Filters.Added - 1).ToString;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result_Num.Parent := vMame.Scene.Gamelist.Filters.Window.Filter_Panels
      [mame.Filters.Added - 1].Panel;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result_Num.SetBounds(340, 20, 150, 20);
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result_Num.Text := '';
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result_Num.Font.Size := 14;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result_Num.TextSettings.FontColor := TAlphaColorRec.Limegreen;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result_Num.HorzTextAlign := TTextAlign.Center;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result_Num.Visible := False;

    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result_Games :=
      TText.Create(vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Panel);
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result_Games.Name := 'Mame_Window_Filters_Filter_Result_Games_' +
      (mame.Filters.Added - 1).ToString;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result_Games.Parent := vMame.Scene.Gamelist.Filters.Window.Filter_Panels
      [mame.Filters.Added - 1].Panel;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result_Games.SetBounds(340, 40, 150, 20);
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result_Games.Text := 'Games';
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result_Games.Font.Size := 14;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result_Games.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result_Games.HorzTextAlign := TTextAlign.Center;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Result_Games.Visible := False;

    for vi := 0 to mame.Filters.List.Count do
    begin
      if vi = 0 then
        vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Choose.Items.Add('Choose...')
      else
        vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Choose.Items.Add(mame.Filters.List.Strings[vi - 1]);
    end;

    mame.Filters.Compo_Done := True;
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Choose.ItemIndex := 0;
    mame.Filters.Compo_Done := False;
    mame.Filters.Filter_Done := False;

    Sort_Filter_Panels;
  end;
end;

procedure Remove(vPanel_Num: Integer);
var
  vi: Integer;
  vPanel_Height: Integer;
begin
  Dec(mame.Filters.Added, 1);
  mame.Filters.List_Added.Delete(vPanel_Num + 1);
  SetLength(vMame.Scene.Gamelist.Filters.Window.Filter_Panels, mame.Filters.Added);

  Sort_Filter_Panels;
end;

procedure Sort_Filter_Panels;
var
  vi: Integer;
  vSum_Height: Single;
begin
  vSum_Height := 0;
  for vi := 0 to mame.Filters.Added - 1 do
  begin
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vi].Panel.Position.Y := 70 + (vi * 70);
    vSum_Height := vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vi].Panel.Position.Y;
  end;

  if vSum_Height + 130 < 300 then
    vMame.Scene.Gamelist.Filters.Window.Panel.Height := 300
  else
    vMame.Scene.Gamelist.Filters.Window.Panel.Height := vSum_Height + 130;
end;

procedure Combo_Create_Filter(vFilter: String; vPanel: Integer);
var
  vList_Filters, vBool_Filters: String;
  vi: Integer;
  vTemp_List: TStringList;
begin
  vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Filter_Name.Text := 'Filter : ' + vFilter;

  vList_Filters := 'Year Manufacturer Genre Monochrome Languages';
  vBool_Filters := 'Adult Original Mechanical Working Screenless';
  vTemp_List := TStringList.Create;

  vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Sec_Choose := TComboBox.Create(vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Panel);
  vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Sec_Choose.Name := 'Mame_Window_Filters_Filter_Combo_' + vFilter;
  vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Sec_Choose.Parent := vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Panel;
  vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Sec_Choose.SetBounds(180, 25, 150, 28);
  vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Sec_Choose.OnChange := mame.Input.Mouse.ComboBox.OnChange;
  vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Sec_Choose.TagString := vFilter;
  vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Sec_Choose.Tag := vPanel;
  vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Sec_Choose.Visible := True;

  if AnsiContainsStr(vList_Filters, vFilter) then
  begin
    if vFilter = 'Year' then
      vTemp_List := mame.Gamelist.ListYear
    else if vFilter = 'Manufacturer' then
      vTemp_List := mame.Gamelist.ListManufaturer
    else if vFilter = 'Genre' then
      vTemp_List := mame.Gamelist.ListGenre
    else if vFilter = 'Monochrome' then
      vTemp_List := mame.Gamelist.ListMonochrome
    else if vFilter = 'Languages' then
      vTemp_List := mame.Gamelist.ListLanguages;

    for vi := 0 to vTemp_List.Count do
    begin
      if vi = 0 then
        vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Sec_Choose.Items.Add('Choose...')
      else
      begin
        if vTemp_List.Strings[vi - 1] <> '' then
          vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Sec_Choose.Items.Add(vTemp_List.Strings[vi - 1]);
      end;
    end;
  end
  else if AnsiContainsStr(vBool_Filters, vFilter) then
  begin
    vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Sec_Choose.Items.Add('Choose...');
    if vFilter = 'Adult' then
    begin
      vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Sec_Choose.Items.Add('All');
      vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Sec_Choose.Items.Add('Adult');
    end
    else if vFilter = 'Original' then
    begin
      vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Sec_Choose.Items.Add('Authentic');
      vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Sec_Choose.Items.Add('Clone');
    end
    else
    begin
      vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Sec_Choose.Items.Add('Yes');
      vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Sec_Choose.Items.Add('No');
    end;
  end;

  mame.Filters.Compo_Done := True;
  vMame.Scene.Gamelist.Filters.Window.Filter_Panels[mame.Filters.Added - 1].Sec_Choose.ItemIndex := 0;
  mame.Filters.Compo_Done := False;

  vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Result.Visible := False;
  vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Result_Num.Visible := False;
  vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Result_Games.Visible := False;
end;

procedure Second_Choose(vName: String; vPanel: Integer);
begin
  if Assigned(vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Sec_Choose) then
    FreeAndNil(vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Sec_Choose);
  case IndexStr(vName, ['Year', 'Manufacturer', 'Genre', 'Adult', 'Original', 'Mechanical', 'Working', 'Monochrome', 'Screenless', 'Languages']) of
    0:
      Combo_Create_Filter('Year', vPanel);
    1:
      Combo_Create_Filter('Manufacturer', vPanel);
    2:
      Combo_Create_Filter('Genre', vPanel);
    3:
      Combo_Create_Filter('Adult', vPanel);
    4:
      Combo_Create_Filter('Original', vPanel);
    5:
      Combo_Create_Filter('Mechanical', vPanel);
    6:
      Combo_Create_Filter('Working', vPanel);
    7:
      Combo_Create_Filter('Monochrome', vPanel);
    8:
      Combo_Create_Filter('Screenless', vPanel);
    9:
      Combo_Create_Filter('Languages', vPanel);
  end;
end;

procedure Filter_Result(vFilter, vResponse: String; vPanel: Integer);
var
  vQuery: String;
  vTitle, vValue: String;
  vFilter_Index: Integer;
begin

  mame.Filters.Temp_ListRoms.Clear;
  mame.Filters.Temp_ListGames.Clear;

  if (vFilter = 'Genre') or (vFilter = 'Manufacturer') or (vFilter = 'Year') then
    vValue := vResponse
  else
    vValue := LowerCase(vResponse);

  if vFilter = 'Adult' then
    vTitle := 'mature'
  else
    vTitle := LowerCase(vFilter);

  vQuery := 'SELECT romname, gamename FROM games WHERE ' + vTitle + '="' + vValue + '" ORDER BY romname ASC';
  vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Filter_Name.Text := 'Filter : ' + vFilter + ' (' + vResponse + ')';

  uEmu_Arcade_Mame_SetAll.vMame_Query.Close;
  uEmu_Arcade_Mame_SetAll.vMame_Query.SQL.Clear;
  uEmu_Arcade_Mame_SetAll.vMame_Query.SQL.Text := vQuery;
  uEmu_Arcade_Mame_SetAll.vMame_Query.DisableControls;
  uEmu_Arcade_Mame_SetAll.vMame_Query.Open;

  try
    uEmu_Arcade_Mame_SetAll.vMame_Query.First;
    while not uEmu_Arcade_Mame_SetAll.vMame_Query.Eof do
    begin
      mame.Filters.Temp_ListRoms.Add(uEmu_Arcade_Mame_SetAll.vMame_Query.FieldByName('romname').AsString);
      mame.Filters.Temp_ListGames.Add(uEmu_Arcade_Mame_SetAll.vMame_Query.FieldByName('gamename').AsString);
      uEmu_Arcade_Mame_SetAll.vMame_Query.Next;
    end;
  finally
    uEmu_Arcade_Mame_SetAll.vMame_Query.EnableControls;
  end;

  vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Result.Visible := True;
  vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Result_Num.Text := mame.Filters.Temp_ListRoms.Count.ToString;
  vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Result_Num.Visible := True;
  vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vPanel].Result_Games.Visible := True;

  if mame.Filters.List.IndexOf(vFilter) <> -1 then
  begin
    mame.Filters.List_Added.Add(vFilter +'='+ vResponse);
    mame.Filters.List.Delete(mame.Filters.List.IndexOf(vFilter));
    mame.Filters.Filter_Done := True;
  end;

  List_Result;
end;

procedure List_Result;
var
  vQuery: String;
  vConditions: String;
  vFilter: String;
  vFilter_Value: String;
  vi: Integer;
begin
  mame.Filters.Temp_ListRoms_Final.Clear;
  mame.Filters.Temp_ListGames_Final.Clear;
  vConditions := '';
  for vi := 0 to mame.Filters.List_Added.Count - 1 do
  begin
    vFilter := mame.Filters.List_Added.Strings[vi];
    if (vFilter = 'Year') or (vFilter = 'Genre') or (vFilter = 'Manufacturer') then
      vFilter_Value := vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vi].Sec_Choose.Selected.Text
    else
      vFilter_Value := LowerCase(vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vi].Sec_Choose.Selected.Text);
    if vFilter = 'Adult' then
      vFilter := 'Mature';
    if vi = 0 then
      vConditions := ' ' + vFilter + '="' + vFilter_Value + '" '
    else
      vConditions := vConditions + ' AND ' + vFilter + '="' + vFilter_Value + '" ';
  end;
  vQuery := 'SELECT romname, gamename FROM games  WHERE ' + vConditions;

  uEmu_Arcade_Mame_SetAll.vMame_Query.Close;
  uEmu_Arcade_Mame_SetAll.vMame_Query.SQL.Clear;
  uEmu_Arcade_Mame_SetAll.vMame_Query.SQL.Text := vQuery;
  uEmu_Arcade_Mame_SetAll.vMame_Query.DisableControls;
  uEmu_Arcade_Mame_SetAll.vMame_Query.Open;

  try
    uEmu_Arcade_Mame_SetAll.vMame_Query.First;
    while not uEmu_Arcade_Mame_SetAll.vMame_Query.Eof do
    begin
      mame.Filters.Temp_ListRoms_Final.Add(uEmu_Arcade_Mame_SetAll.vMame_Query.FieldByName('romname').AsString);
      mame.Filters.Temp_ListGames_Final.Add(uEmu_Arcade_Mame_SetAll.vMame_Query.FieldByName('gamename').AsString);
      uEmu_Arcade_Mame_SetAll.vMame_Query.Next;
    end;
  finally
    uEmu_Arcade_Mame_SetAll.vMame_Query.EnableControls;
  end;

  if mame.Filters.Temp_ListRoms_Final.Count < 0 then
    vMame.Scene.Gamelist.Filters.Window.OK.Enabled := False
  else
    vMame.Scene.Gamelist.Filters.Window.OK.Enabled := True;
  vMame.Scene.Gamelist.Filters.Window.Games_Num.Text := mame.Filters.Temp_ListRoms_Final.Count.ToString;
end;

procedure Return;
var
  vi: Integer;
  vFilter_Name: String;
begin
  mame.Gamelist.ListRoms := mame.Filters.Temp_ListRoms_Final;
  mame.Gamelist.ListGames := mame.Filters.Temp_ListGames_Final;
  mame.Gamelist.Games_Count := mame.Gamelist.ListRoms.Count;
  uEmu_Arcade_Mame.Main;
  for vi := 0 to mame.Filters.Added - 1 do
  begin
    vFilter_Name := vMame.Scene.Gamelist.Filters.Window.Filter_Panels[vi].Filter_Name.Text;
    Delete(vFilter_Name, 1, 9);
    if vi = 0 then
      vMame.Scene.Gamelist.Filters.Text.Text := vFilter_Name
    else
      vMame.Scene.Gamelist.Filters.Text.Text := vMame.Scene.Gamelist.Filters.Text.Text + ', ' + vFilter_Name;
  end;
  Free;
end;

end.
