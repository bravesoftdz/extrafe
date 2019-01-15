unit uWeather_Config_Towns_Add;

interface

uses
  System.Classes,
  System.UiTypes,
  System.SysUtils,
  FMX.Types,
  FMX.Objects,
  FMX.Edit,
  FMX.Grid,
  FMX.Effects,
  FMX.StdCtrls,
  FMX.Dialogs,
  FMX.ImgList,
  FMX.Ani,
  OXmlPDOM;

type
  TWEATHER_CONFIG_TOWNS_ADD_FLOATANIMATION = Class(TObject)
    procedure OnFinish(Sender: TObject);
  End;

type
  TWEATHER_CONFIG_TOWNS_ADD_SEARCHTOWN_RESULTS = record
    woeid: string;
    name: string;
    state_1: string;
    country: string;
    country_code: string;
  end;

procedure uWeather_Config_Towns_Add_Load;
procedure uWeather_Config_Towns_Add_Free;

procedure uWeather_Config_Towns_Add_FindTown(mTown: string);
procedure uWeather_Config_Towns_Add_AddTown(vStay: Boolean);
procedure uWeather_Config_Towns_Add_AddSelectedTown(vNum: Integer; mWoeid, country_code: string);

var
  vAni: TWEATHER_CONFIG_TOWNS_ADD_FLOATANIMATION;
  vAni_End: Boolean;
  vStayToADD: Boolean;

implementation

uses
  uLoad_AllTypes,
  main,
  uWindows,
  uWeather_AllTypes,
  uWeather_SetAll,
  uWeather_Actions,
  uWeather_Convert,
  uWeather_Config_Towns,
  uWeather_Forcast,
  uSnippet_Image,
  uSnippet_StringGrid;

var
  vCTTempResults: array [0 .. 100] of TWEATHER_CONFIG_TOWNS_ADD_SEARCHTOWN_RESULTS;
  vCodes: TStringList;
  vTown_HasData: Boolean;

procedure uWeather_Config_Towns_Add_Load;
var
  vi: Integer;
  vImage: Timage;
begin
  if addons.weather.Action.Provider <> '' then
  begin
    extrafe.prog.State := 'addon_weather_config_towns_add';
    vWeather.Config.Panel_Blur.Enabled := True;

    vAni_End := False;

    vWeather.Config.main.Right.Towns.Add.Panel := TPanel.Create(vWeather.Scene.weather);
    vWeather.Config.main.Right.Towns.Add.Panel.name := 'A_W_Config_Towns_Add';
    vWeather.Config.main.Right.Towns.Add.Panel.Parent := vWeather.Scene.weather;
    vWeather.Config.main.Right.Towns.Add.Panel.Width := 600;
    vWeather.Config.main.Right.Towns.Add.Panel.Height := 450;
    vWeather.Config.main.Right.Towns.Add.Panel.Position.X := extrafe.res.Half_Width - 300;
    vWeather.Config.main.Right.Towns.Add.Panel.Position.Y := extrafe.res.Half_Height - 400;
    vWeather.Config.main.Right.Towns.Add.Panel.Visible := True;

    uLoad_SetAll_CreateHeader(vWeather.Config.main.Right.Towns.Add.Panel, 'A_W_Config_Towns_Add',
      addons.weather.Path.Images + 'w_add.png', 'Search and add new towns.');

    vWeather.Config.main.Right.Towns.Add.main.Panel :=
      TPanel.Create(vWeather.Config.main.Right.Towns.Add.Panel);
    vWeather.Config.main.Right.Towns.Add.main.Panel.name := 'A_W_Config_Towns_Add_Main';
    vWeather.Config.main.Right.Towns.Add.main.Panel.Parent := vWeather.Config.main.Right.Towns.Add.Panel;
    vWeather.Config.main.Right.Towns.Add.main.Panel.Width := vWeather.Config.main.Right.Towns.Add.Panel.Width;
    vWeather.Config.main.Right.Towns.Add.main.Panel.Height :=
      vWeather.Config.main.Right.Towns.Add.Panel.Height - 30;
    vWeather.Config.main.Right.Towns.Add.main.Panel.Position.X := 0;
    vWeather.Config.main.Right.Towns.Add.main.Panel.Position.Y := 30;
    vWeather.Config.main.Right.Towns.Add.main.Panel.Visible := True;

    vWeather.Config.main.Right.Towns.Add.main.FindTown :=
      TLabel.Create(vWeather.Config.main.Right.Towns.Add.main.Panel);
    vWeather.Config.main.Right.Towns.Add.main.FindTown.name := 'A_W_Config_AddTown_Label';
    vWeather.Config.main.Right.Towns.Add.main.FindTown.Parent :=
      vWeather.Config.main.Right.Towns.Add.main.Panel;
    vWeather.Config.main.Right.Towns.Add.main.FindTown.Width := 300;
    vWeather.Config.main.Right.Towns.Add.main.FindTown.Position.X :=
      vWeather.Config.main.Right.Towns.Add.main.Panel.Width - 350;
    vWeather.Config.main.Right.Towns.Add.main.FindTown.Position.Y := 10;
    vWeather.Config.main.Right.Towns.Add.main.FindTown.Text := 'Find a "Town" for weather forcast.';
    vWeather.Config.main.Right.Towns.Add.main.FindTown.Font.Style :=
      vWeather.Config.main.Right.Towns.Add.main.FindTown.Font.Style + [TFontStyle.fsBold];
    vWeather.Config.main.Right.Towns.Add.main.FindTown.TextSettings.HorzAlign := TTextAlign.Trailing;
    vWeather.Config.main.Right.Towns.Add.main.FindTown.Visible := True;

    vWeather.Config.main.Right.Towns.Add.main.FindTown_V :=
      TEdit.Create(vWeather.Config.main.Right.Towns.Add.main.Panel);
    vWeather.Config.main.Right.Towns.Add.main.FindTown_V.name := 'A_W_Config_AddTown_Edit';
    vWeather.Config.main.Right.Towns.Add.main.FindTown_V.Parent :=
      vWeather.Config.main.Right.Towns.Add.main.Panel;
    vWeather.Config.main.Right.Towns.Add.main.FindTown_V.Width :=
      vWeather.Config.main.Right.Towns.Add.main.Panel.Width - 60;
    vWeather.Config.main.Right.Towns.Add.main.FindTown_V.Height := 30;
    vWeather.Config.main.Right.Towns.Add.main.FindTown_V.Position.X := 10;
    vWeather.Config.main.Right.Towns.Add.main.FindTown_V.Position.Y := 38;
    vWeather.Config.main.Right.Towns.Add.main.FindTown_V.Text := '';
    vWeather.Config.main.Right.Towns.Add.main.FindTown_V.Caret.Color := TAlphaColorRec.Deepskyblue;
    vWeather.Config.main.Right.Towns.Add.main.FindTown_V.TextSettings.HorzAlign := TTextAlign.Center;
    vWeather.Config.main.Right.Towns.Add.main.FindTown_V.TextSettings.Font.Size := 16;
    vWeather.Config.main.Right.Towns.Add.main.FindTown_V.Visible := True;

    vWeather.Config.main.Right.Towns.Add.main.Search :=
      Timage.Create(vWeather.Config.main.Right.Towns.Add.main.Panel);
    vWeather.Config.main.Right.Towns.Add.main.Search.name := 'A_W_Config_Towns_Add_Search';
    vWeather.Config.main.Right.Towns.Add.main.Search.Parent :=
      vWeather.Config.main.Right.Towns.Add.main.Panel;
    vWeather.Config.main.Right.Towns.Add.main.Search.Width := 34;
    vWeather.Config.main.Right.Towns.Add.main.Search.Height := 34;
    vWeather.Config.main.Right.Towns.Add.main.Search.Position.X :=
      vWeather.Config.main.Right.Towns.Add.main.Panel.Width - 43;
    vWeather.Config.main.Right.Towns.Add.main.Search.Position.Y := 34;
    vWeather.Config.main.Right.Towns.Add.main.Search.Bitmap.LoadFromFile
      (addons.weather.Path.Images + 'w_search.png');
    vWeather.Config.main.Right.Towns.Add.main.Search.WrapMode := TImageWrapMode.Fit;
    vWeather.Config.main.Right.Towns.Add.main.Search.OnClick := addons.weather.Input.mouse.Image.OnMouseClick;
    vWeather.Config.main.Right.Towns.Add.main.Search.OnMouseEnter :=
      addons.weather.Input.mouse.Image.OnMouseEnter;
    vWeather.Config.main.Right.Towns.Add.main.Search.OnMouseLeave :=
      addons.weather.Input.mouse.Image.OnMouseLeave;
    vWeather.Config.main.Right.Towns.Add.main.Search.Visible := True;

    vWeather.Config.main.Right.Towns.Add.main.Search_Glow :=
      TGlowEffect.Create(vWeather.Config.main.Right.Towns.Add.main.Search);
    vWeather.Config.main.Right.Towns.Add.main.Search_Glow.name := 'A_W_Config_Towns_Add_Search_Glow';
    vWeather.Config.main.Right.Towns.Add.main.Search_Glow.Parent :=
      vWeather.Config.main.Right.Towns.Add.main.Search;
    vWeather.Config.main.Right.Towns.Add.main.Search_Glow.Softness := 0.4;
    vWeather.Config.main.Right.Towns.Add.main.Search_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
    vWeather.Config.main.Right.Towns.Add.main.Search_Glow.Opacity := 0.9;
    vWeather.Config.main.Right.Towns.Add.main.Search_Glow.Enabled := False;

    vWeather.Config.main.Right.Towns.Add.main.Grid :=
      TStringGrid.Create(vWeather.Config.main.Right.Towns.Add.main.Panel);
    vWeather.Config.main.Right.Towns.Add.main.Grid.name := 'A_W_Config_Towns_Add_StringGrid';
    vWeather.Config.main.Right.Towns.Add.main.Grid.Parent := vWeather.Config.main.Right.Towns.Add.main.Panel;
    vWeather.Config.main.Right.Towns.Add.main.Grid.Width :=
      vWeather.Config.main.Right.Towns.Add.Panel.Width - 20;
    vWeather.Config.main.Right.Towns.Add.main.Grid.Height :=
      vWeather.Config.main.Right.Towns.Add.Panel.Height - 160;
    vWeather.Config.main.Right.Towns.Add.main.Grid.Position.X := 10;
    vWeather.Config.main.Right.Towns.Add.main.Grid.Position.Y := 80;
    vWeather.Config.main.Right.Towns.Add.main.Grid.Options :=
      vWeather.Config.main.Right.Towns.Add.main.Grid.Options + [TGridOption.AlternatingRowBackground] -
      [TGridOption.Editing] - [TGridOption.AlwaysShowEditor] - [TGridOption.ColumnResize] -
      [TGridOption.ColumnMove] + [TGridOption.ColLines] + [TGridOption.RowLines] + [TGridOption.RowSelect] -
      [TGridOption.AlwaysShowSelection] + [TGridOption.Tabs] + [TGridOption.Header] +
      [TGridOption.HeaderClick] - [TGridOption.CancelEditingByDefault] - [TGridOption.AutoDisplacement];
    vWeather.Config.main.Right.Towns.Add.main.Grid.RowHeight := 24;
    vWeather.Config.main.Right.Towns.Add.main.Grid.OnClick :=
      addons.weather.Input.mouse.Stringgrid.OnMouseClick;
    vWeather.Config.main.Right.Towns.Add.main.Grid.OnMouseEnter :=
      addons.weather.Input.mouse.Stringgrid.OnMouseEnter;
    vWeather.Config.main.Right.Towns.Add.main.Grid.OnMouseLeave :=
      addons.weather.Input.mouse.Stringgrid.OnMouseLeave;
    vWeather.Config.main.Right.Towns.Add.main.Grid.Visible := True;

    for vi := 0 to 4 do
    begin
      if vi <> 1 then
        vWeather.Config.main.Right.Towns.Add.main.Grid.AddObject
          (TStringColumn.Create(vWeather.Config.main.Right.Towns.Add.main.Grid))
      else
        vWeather.Config.main.Right.Towns.Add.main.Grid.AddObject
          (TGlyphColumn.Create(vWeather.Config.main.Right.Towns.Add.main.Grid));
    end;

    vWeather.Config.main.Right.Towns.Add.main.Grid.Columns[0].Header := 'Num';
    vWeather.Config.main.Right.Towns.Add.main.Grid.Columns[0].Width := 36;
    vWeather.Config.main.Right.Towns.Add.main.Grid.Columns[1].Header := 'Flag';
    vWeather.Config.main.Right.Towns.Add.main.Grid.Columns[1].Width := 36;
    vWeather.Config.main.Right.Towns.Add.main.Grid.Columns[2].Header := 'Town';
    vWeather.Config.main.Right.Towns.Add.main.Grid.Columns[2].Width := 100;
    vWeather.Config.main.Right.Towns.Add.main.Grid.Columns[3].Header := 'Region';
    vWeather.Config.main.Right.Towns.Add.main.Grid.Columns[3].Width := 238;
    vWeather.Config.main.Right.Towns.Add.main.Grid.Columns[4].Header := 'County';
    vWeather.Config.main.Right.Towns.Add.main.Grid.Columns[4].Width := 144;

    vWeather.Config.main.Right.Towns.Add.main.Add :=
      TButton.Create(vWeather.Config.main.Right.Towns.Add.main.Panel);
    vWeather.Config.main.Right.Towns.Add.main.Add.name := 'A_W_Config_Towns_Add_Add';
    vWeather.Config.main.Right.Towns.Add.main.Add.Parent := vWeather.Config.main.Right.Towns.Add.main.Panel;
    vWeather.Config.main.Right.Towns.Add.main.Add.Width := 80;
    vWeather.Config.main.Right.Towns.Add.main.Add.Height := 24;
    vWeather.Config.main.Right.Towns.Add.main.Add.Position.X := 100;
    vWeather.Config.main.Right.Towns.Add.main.Add.Position.Y :=
      vWeather.Config.main.Right.Towns.Add.main.Panel.Height - 36;
    vWeather.Config.main.Right.Towns.Add.main.Add.Text := 'Add town';
    vWeather.Config.main.Right.Towns.Add.main.Add.OnClick := addons.weather.Input.mouse.Button.OnMouseClick;
    vWeather.Config.main.Right.Towns.Add.main.Add.OnMouseEnter :=
      addons.weather.Input.mouse.Button.OnMouseEnter;
    vWeather.Config.main.Right.Towns.Add.main.Add.OnMouseLeave :=
      addons.weather.Input.mouse.Button.OnMouseLeave;
    vWeather.Config.main.Right.Towns.Add.main.Add.Visible := True;

    vWeather.Config.main.Right.Towns.Add.main.Add_Stay :=
      TButton.Create(vWeather.Config.main.Right.Towns.Add.main.Panel);
    vWeather.Config.main.Right.Towns.Add.main.Add_Stay.name := 'A_W_Config_Towns_Add_AddStay';
    vWeather.Config.main.Right.Towns.Add.main.Add_Stay.Parent :=
      vWeather.Config.main.Right.Towns.Add.main.Panel;
    vWeather.Config.main.Right.Towns.Add.main.Add_Stay.Width := 100;
    vWeather.Config.main.Right.Towns.Add.main.Add_Stay.Height := 24;
    vWeather.Config.main.Right.Towns.Add.main.Add_Stay.Position.X :=
      (vWeather.Config.main.Right.Towns.Add.main.Panel.Width / 2) - 50;
    vWeather.Config.main.Right.Towns.Add.main.Add_Stay.Position.Y :=
      vWeather.Config.main.Right.Towns.Add.main.Panel.Height - 36;
    vWeather.Config.main.Right.Towns.Add.main.Add_Stay.Text := 'Add and Stay';
    vWeather.Config.main.Right.Towns.Add.main.Add_Stay.OnClick :=
      addons.weather.Input.mouse.Button.OnMouseClick;
    vWeather.Config.main.Right.Towns.Add.main.Add_Stay.OnMouseEnter :=
      addons.weather.Input.mouse.Button.OnMouseEnter;
    vWeather.Config.main.Right.Towns.Add.main.Add_Stay.OnMouseLeave :=
      addons.weather.Input.mouse.Button.OnMouseLeave;
    vWeather.Config.main.Right.Towns.Add.main.Add_Stay.Visible := True;

    vWeather.Config.main.Right.Towns.Add.main.Cancel :=
      TButton.Create(vWeather.Config.main.Right.Towns.Add.Panel);
    vWeather.Config.main.Right.Towns.Add.main.Cancel.name := 'A_W_Config_Towns_Add_Cancel';
    vWeather.Config.main.Right.Towns.Add.main.Cancel.Parent :=
      vWeather.Config.main.Right.Towns.Add.main.Panel;
    vWeather.Config.main.Right.Towns.Add.main.Cancel.Width := 80;
    vWeather.Config.main.Right.Towns.Add.main.Cancel.Height := 24;
    vWeather.Config.main.Right.Towns.Add.main.Cancel.Position.X :=
      vWeather.Config.main.Right.Towns.Add.main.Panel.Width - 180;
    vWeather.Config.main.Right.Towns.Add.main.Cancel.Position.Y :=
      vWeather.Config.main.Right.Towns.Add.main.Panel.Height - 36;
    vWeather.Config.main.Right.Towns.Add.main.Cancel.Text := 'Cancel';
    vWeather.Config.main.Right.Towns.Add.main.Cancel.OnClick :=
      addons.weather.Input.mouse.Button.OnMouseClick;
    vWeather.Config.main.Right.Towns.Add.main.Cancel.OnMouseEnter :=
      addons.weather.Input.mouse.Button.OnMouseEnter;
    vWeather.Config.main.Right.Towns.Add.main.Cancel.OnMouseLeave :=
      addons.weather.Input.mouse.Button.OnMouseLeave;
    vWeather.Config.main.Right.Towns.Add.main.Cancel.Visible := True;

    vWeather.Config.main.Right.Towns.Add.main.Add.Enabled := False;
    vWeather.Config.main.Right.Towns.Add.main.Add_Stay.Enabled := False;

    vWeather.Config.main.Right.Towns.Add.main.ImageList :=
      TImageList.Create(vWeather.Config.main.Right.Towns.Add.Panel);
    vWeather.Config.main.Right.Towns.Add.main.ImageList.name := 'A_W_Config_Towns_Add_ImageList';

    vCodes := uWindows_GetFileNames(ex_main.Paths.Flags_Images);

    for vi := 0 to vCodes.Count - 1 do
    begin
      vImage := Timage.Create(Main_Form);
      vImage.Width := 24;
      vImage.Height := 24;
      vImage.Bitmap.LoadFromFile(ex_main.Paths.Flags_Images + vCodes[vi]);
      vImage.WrapMode := TImageWrapMode.Fit;
      vWeather.Config.main.Right.Towns.Add.main.ImageList.Add(vImage.Bitmap);
      FreeAndNil(vImage);
    end;

    vWeather.Config.main.Right.Towns.Add.main.Grid.Images :=
      vWeather.Config.main.Right.Towns.Add.main.ImageList;

    vWeather.Config.main.Right.Towns.Add.main.Ani_Panel :=
      TPanel.Create(vWeather.Config.main.Right.Towns.Add.Panel);
    vWeather.Config.main.Right.Towns.Add.main.Ani_Panel.name := 'A_W_Config_Towns_Add_AniPanel';
    vWeather.Config.main.Right.Towns.Add.main.Ani_Panel.Parent := vWeather.Config.main.Right.Towns.Add.Panel;
    vWeather.Config.main.Right.Towns.Add.main.Ani_Panel.Width := 400;
    vWeather.Config.main.Right.Towns.Add.main.Ani_Panel.Height := 100;
    vWeather.Config.main.Right.Towns.Add.main.Ani_Panel.Position.X :=
      (vWeather.Config.main.Right.Towns.Add.Panel.Width / 2) - 200;
    vWeather.Config.main.Right.Towns.Add.main.Ani_Panel.Position.Y :=
      (vWeather.Config.main.Right.Towns.Add.Panel.Height / 2) - 50;
    vWeather.Config.main.Right.Towns.Add.main.Ani_Panel.Visible := False;

    vWeather.Config.main.Right.Towns.Add.main.Ani :=
      TFloatAnimation.Create(vWeather.Config.main.Right.Towns.Add.main.Ani_Panel);
    vWeather.Config.main.Right.Towns.Add.main.Ani.name := 'A_W_Config_Towns_Add_Ani';
    vWeather.Config.main.Right.Towns.Add.main.Ani.Parent :=
      vWeather.Config.main.Right.Towns.Add.main.Ani_Panel;
    vWeather.Config.main.Right.Towns.Add.main.Ani.PropertyName := 'Opacity';
    vWeather.Config.main.Right.Towns.Add.main.Ani.Duration := 2.5;
    vWeather.Config.main.Right.Towns.Add.main.Ani.StartValue := 1;
    vWeather.Config.main.Right.Towns.Add.main.Ani.StopValue := 0.1;
    vWeather.Config.main.Right.Towns.Add.main.Ani.OnFinish := vAni.OnFinish;
    vWeather.Config.main.Right.Towns.Add.main.Ani.Enabled := False;

    vWeather.Config.main.Right.Towns.Add.main.Ani_Text :=
      TLabel.Create(vWeather.Config.main.Right.Towns.Add.main.Ani_Panel);
    vWeather.Config.main.Right.Towns.Add.main.Ani_Text.name := 'A_W_Config_Towns_Add_AniText';
    vWeather.Config.main.Right.Towns.Add.main.Ani_Text.Parent :=
      vWeather.Config.main.Right.Towns.Add.main.Ani_Panel;
    vWeather.Config.main.Right.Towns.Add.main.Ani_Text.Width := 380;
    vWeather.Config.main.Right.Towns.Add.main.Ani_Text.Height := 24;
    vWeather.Config.main.Right.Towns.Add.main.Ani_Text.Position.X := 10;
    vWeather.Config.main.Right.Towns.Add.main.Ani_Text.Position.Y := 40;
    vWeather.Config.main.Right.Towns.Add.main.Ani_Text.Text := '';
    vWeather.Config.main.Right.Towns.Add.main.Ani_Text.Visible := True;
  end
  else
    ShowMessage('You must add a provider first' + #13#10 + 'Click to provider button and select one');
end;

procedure uWeather_Config_Towns_Add_Free;
begin
  extrafe.prog.State := 'addon_weather_config';
  vWeather.Config.Panel_Blur.Enabled := False;
  vWeather.Config.main.Right.Towns.Add_Town_Glow.Enabled := False;

  FreeAndNil(vCodes);
  FreeAndNil(vWeather.Config.main.Right.Towns.Add.Panel);
end;
///

procedure uWeather_Config_Towns_Add_FindTown(mTown: string);
var
  vTownAnwsers: TStringList;
  vCorrectedTown: string;
  vCodeFlag: Integer;
  vi: Integer;
  vi_1: Integer;

  function vvv_Weather_Correct_Town(mTown: string): string;
  var
    viPos: Integer;
    vText: string;
    vText1, vText2: string;
  begin
    vText := mTown;
    repeat
      viPos := Pos(' ', vText);
      if viPos <> 0 then
      begin
        vText1 := Trim(Copy(vText, 0, viPos));
        vText2 := Trim(Copy(vText2, viPos, length(vText) - viPos));
        vText := vText1 + '%20' + vText2;
      end;
    until viPos = 0;
    Result := vText;
  end;

begin
  vWeather.Config.main.Right.Towns.Add.main.Add.Enabled := False;
  vWeather.Config.main.Right.Towns.Add.main.Add_Stay.Enabled := False;
  if mTown <> '' then
  begin
    for vi := 0 to 100 do
    begin
      vCTTempResults[vi].woeid := '';
      vCTTempResults[vi].name := '';
      vCTTempResults[vi].state_1 := '';
      vCTTempResults[vi].country := '';
    end;
    vCorrectedTown := vvv_Weather_Correct_Town(mTown);
    vTownAnwsers := TStringList.Create;
    vTownAnwsers.Add(Main_Form.Main_IdHttp.Get
      ('http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20geo.places%20where%20text%3D%22' +
      vCorrectedTown + '%22&diagnostics=true'));
    vTownAnwsers.SaveToFile(extrafe.prog.Path + cTemp_Towns);

    vNTXML := CreateXMLDoc;
    vNTXML.LoadFromFile(extrafe.prog.Path + cTemp_Towns);
    vNTRoot := vNTXML.DocumentElement;

    vi := -1;
    while vNTRoot.GetNextChild(vNTNode) do
      while vNTNode.GetNextChild(vNTNode_1) do
        if vNTNode_1.NodeName = 'place' then
        begin
          inc(vi, 1);
          while vNTNode_1.GetNextChild(vNTNode_2) do
          begin
            vNTAttribute := nil;
            if vNTNode_2.NodeName = 'woeid' then
              vCTTempResults[vi].woeid := vNTNode_2.Text;
            if vNTNode_2.NodeName = 'name' then
              vCTTempResults[vi].name := vNTNode_2.Text;
            if vNTNode_2.NodeName = 'admin1' then
              vCTTempResults[vi].state_1 := vNTNode_2.Text;
            if vNTNode_2.NodeName = 'country' then
            begin
              vCTTempResults[vi].country := vNTNode_2.Text;
              vNTNode_2.FindAttribute('code', vNTAttribute);
              vCTTempResults[vi].country_code := vNTAttribute.NodeValue;
            end;
          end;
        end;
    vWeather.Config.main.Right.Towns.Add.main.Grid.RowCount := vi + 1;

    for vi_1 := 0 to vi do
    begin
      vWeather.Config.main.Right.Towns.Add.main.Grid.Cells[0, vi_1] := IntToStr(vi_1 + 1);
      vCodeFlag := vCodes.IndexOf(vCTTempResults[vi_1].country_code + '.png');
      vWeather.Config.main.Right.Towns.Add.main.Grid.Cells[1, vi_1] := vCodeFlag.ToString;
      vWeather.Config.main.Right.Towns.Add.main.Grid.Cells[2, vi_1] := vCTTempResults[vi_1].name;
      vWeather.Config.main.Right.Towns.Add.main.Grid.Cells[3, vi_1] := vCTTempResults[vi_1].state_1;
      vWeather.Config.main.Right.Towns.Add.main.Grid.Cells[4, vi_1] := vCTTempResults[vi_1].country;
    end;
    vWeather.Config.main.Right.Towns.Add.main.Grid.Selected := 0;
    DeleteFile(extrafe.prog.Path + cTemp_Towns);
    vWeather.Config.main.Right.Towns.Add.main.Add.Enabled := True;
    vWeather.Config.main.Right.Towns.Add.main.Add_Stay.Enabled := True;
  end
  else
    ShowMessage('Please write a town fist');
end;

procedure uWeather_Config_Towns_Add_AddSelectedTown(vNum: Integer; mWoeid, country_code: string);
begin
  if uWeather_Forcast_Get(vNum, mWoeid, country_code).City <> '' then
  begin
    // Add founded forcast to list
    addons.weather.Action.Choosen[vNum] := uWeather_Forcast_Get(vNum, mWoeid, country_code);
    // Add values to ini
    addons.weather.Action.Active_Total := vNum;
    addons.weather.Ini.Ini.WriteInteger('Active', 'Active_Total', addons.weather.Action.Active_Total);
    addons.weather.Ini.Ini.WriteString(addons.weather.Action.Provider,
      addons.weather.Action.Active_Total.ToString + '_WoeID', addons.weather.Action.Choosen[vNum].woeid + '{'
      + addons.weather.Action.Choosen[vNum].Country_FlagCode + '}');
    // Create new town panel in config towns
    uWeather_Config_Towns_CreateTown_Panel(vNum, addons.weather.Action.Choosen[vNum]);
    // Create new town in main selection
    uWeather_SetAll_CreateWeather_Tab(addons.weather.Action.Choosen[vNum], vNum);
    vWeather.Scene.Control.TabIndex := 0;
    vTown_HasData := True;
  end
  else
    vTown_HasData := False;
end;

procedure uWeather_Config_Towns_Add_AddTown(vStay: Boolean);
var
  vi: Integer;
begin
  // Set the new town if data is not nil
  uWeather_Config_Towns_Add_AddSelectedTown(addons.weather.Action.Active_Total + 1,
    vCTTempResults[vWeather.Config.main.Right.Towns.Add.main.Grid.Selected].woeid,
    vCTTempResults[vWeather.Config.main.Right.Towns.Add.main.Grid.Selected].country_code);
  // Set and start the ani panel
  vWeather.Config.main.Right.Towns.Add.main.Ani_Panel.Visible := True;
  vStayToADD := vStay;
  vWeather.Config.main.Right.Towns.Add.main.Ani.Start;
  if vTown_HasData then
  begin
    vWeather.Config.main.Right.Towns.Add.main.Ani_Text.Text :=
      '" ' + vWeather.Config.main.Right.Towns.Add.main.Grid.Cells
      [2, vWeather.Config.main.Right.Towns.Add.main.Grid.Selected] + ' "  from " ' +
      vWeather.Config.main.Right.Towns.Add.main.Grid.Cells
      [4, vWeather.Config.main.Right.Towns.Add.main.Grid.Selected] + ' " added successfully.';
    for vi := 0 to vWeather.Config.main.Right.Towns.Add.main.Grid.RowCount - 1 do
      TStringGrid(vWeather.Config.main.Right.Towns.Add.main.Grid).myDeleteRow(vi);
    vWeather.Config.main.Right.Towns.Add.main.FindTown_V.Text := '';
  end
  else
    vWeather.Config.main.Right.Towns.Add.main.Ani_Text.Text := 'Can''t get forcast data for " ' +
      vWeather.Config.main.Right.Towns.Add.main.Grid.Cells
      [2, vWeather.Config.main.Right.Towns.Add.main.Grid.Selected] + ' "  from " ' +
      vWeather.Config.main.Right.Towns.Add.main.Grid.Cells
      [4, vWeather.Config.main.Right.Towns.Add.main.Grid.Selected] + ' "';
end;

{ TWEATHER_CONFIG_TOWNS_DELETE_FLOATANIMATION }

procedure TWEATHER_CONFIG_TOWNS_ADD_FLOATANIMATION.OnFinish(Sender: TObject);
begin
  vWeather.Config.main.Right.Towns.Add.main.Ani_Panel.Visible := False;
  if vTown_HasData then
    if vStayToADD = False then
      uWeather_Config_Towns_Add_Free;
end;

initialization

vAni := TWEATHER_CONFIG_TOWNS_ADD_FLOATANIMATION.Create;

finalization

vAni.Free;

end.
