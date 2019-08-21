unit uWeather_Actions;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UiTypes,
  System.Threading,
  System.Types,
  FMX.Forms,
  FMX.Objects,
  FMX.Types,
  FMX.Layouts,
  FMX.StdCtrls,
  FMX.Ani,
  FMX.Controls,
  FMX.Graphics,
  FMX.Effects,
  FMX.WebBrowser,
  ALFmxTabControl,
  ALFmxObjects,
  uWeather_AllTypes,
  uWeather_Config_Towns,
  Radiant.Shapes;

procedure Load;
procedure ReturnToMain(vIconsNum: Integer);
procedure Free;

procedure ShowFirstTimeScene(vFirst: Boolean);
procedure CheckFirst(vCheched: Boolean);

procedure ShowTheForcast;

procedure Show_AstronomyAnimation;

procedure Control_Slide_Right;
procedure Control_Slide_Left;

procedure Show_Map(vProvider, vLat, vLon: String);
procedure Close_Map;

var
  vTaskTimer: TTimer;

implementation

uses
  main,
  uload,
  uLoad_AllTypes,
  uSnippet_Text,
  uMain_AllTypes,
  uMain_SetAll,
  uMain_Actions,
  uWindows,
  uWeather_SetAll,
  uWeather_Convert,
  uWeather_MenuActions,
  uWeather_Sounds,
  uWeather_Providers_Yahoo,
  uWeather_Providers_OpenWeatherMap;

procedure Load;
var
  ki: Integer;
begin
  // Create the effect timer
  vWeather.Scene.Effect_Timer := TTimer.Create(vWeather.Scene.weather);
  vWeather.Scene.Effect_Timer.Name := 'A_W_Effect_Timer';
  vWeather.Scene.Effect_Timer.Parent := vWeather.Scene.weather;
  vWeather.Scene.Effect_Timer.Interval := 1;
  vWeather.Scene.Effect_Timer.OnTimer := vWeather.Scene.Timer.OnTimer;
  vWeather.Scene.Effect_Timer.Enabled := False;

  uWeather_Sounds_Load;

  // What

  if (addons.weather.Action.Provider <> '') and (addons.weather.Action.Active_WOEID <> -1) then
  begin

    if uWindows_IsConected_ToInternet then
    begin
      vTaskTimer := TTimer.Create(Main_Form);
      vTaskTimer.Enabled := False;
      vTaskTimer.Interval := 300;
      vTaskTimer.OnTimer := addons.weather.Input.mouse.Timer.OnTimer;

      vWeather.Config.Panel.Visible := False;
      vLoading_Integer := -1;

      if addons.weather.Action.Provider = 'yahoo' then
        uWeather_Providers_Yahoo.Main_Create_Towns
      else if addons.weather.Action.Provider = 'openweathermap' then
        uWeather_Providers_OpenWeatherMap.Main_Create_Towns;
      ShowTheForcast;
    end
  end
  else
    uWeather_Actions.ShowFirstTimeScene(addons.weather.Action.First);
end;

procedure ShowTheForcast;
var
  ki: Integer;
begin
  FreeAndNil(vTaskTimer);

  vWeather.Scene.Control.TabIndex := 0;
  vWeather.Scene.Control.AnimationEnabled := False;
  vWeather.Scene.Settings.Visible := True;
  vWeather.Scene.Settings_Ani.Enabled := True;

  addons.weather.Config.Edit_Lock := False;

  addons.weather.Loaded := True;

  vWeather.Scene.Control_Ani.Start;
  // uWeather_Actions_Show_AstronomyAnimation;
end;

procedure ReturnToMain(vIconsNum: Integer);
begin
  if addons.weather.Loaded then
  begin
    Close_Map;
    emulation.Selection_Ani.StartValue := extrafe.res.Height;
    emulation.Selection_Ani.StopValue := ex_main.Settings.MainSelection_Pos.Y - 130;
    mainScene.Footer.Back_Ani.StartValue := extrafe.res.Height;
    mainScene.Footer.Back_Ani.StopValue := ex_main.Settings.Footer_Pos.Y;
    emulation.Selection_Ani.Enabled := True;
    vWeather.Scene.Weather_Ani.Start;
    mainScene.Footer.Back_Ani.Start;
    uMain_Actions_All_Icons_Active(vIconsNum);
    extrafe.prog.State := 'main';
  end;
end;

procedure Free;
var
  vi: Integer;
begin
  if Assigned(vWeather.Scene.weather) then
    FreeAndNil(vWeather.Scene.weather);
  uWeather_Sounds_Free;
  addons.weather.Loaded := False;
end;

procedure Show_AstronomyAnimation;
begin
  // vWeather.Scene.Tab[vWeather.Scene.Control.TabIndex].Astronomy.Spot.Visible := False;
  // vWeather.Scene.Tab[vWeather.Scene.Control.TabIndex].Astronomy.Spot.Position.X := vWeather.Scene.Tab[vWeather.Scene.Control.TabIndex]
  // .Astronomy.Sunrise.Width + 120;
  // vWeather.Scene.Tab[vWeather.Scene.Control.TabIndex].Astronomy.Spot.Position.Y := 670;
  // vWeather.Scene.Tab[vWeather.Scene.Control.TabIndex].Astronomy.Spot_Ani.Path :=
  // uWeather_Convert_SunSpot(addons.weather.Action.Choosen[vWeather.Scene.Control.TabIndex].Astronomy.Sunrise,
  // addons.weather.Action.Choosen[vWeather.Scene.Control.TabIndex].Astronomy.Sunset);
  // vWeather.Scene.Tab[vWeather.Scene.Control.TabIndex].Astronomy.Spot_Text.Visible := False;
  // if addons.weather.Action.PathAni_Show then
  // begin
  // vWeather.Scene.Tab[vWeather.Scene.Control.TabIndex].Astronomy.Spot.Visible := True;
  // vWeather.Scene.Tab[vWeather.Scene.Control.TabIndex].Astronomy.Spot_Ani.Start;
  // end;
end;

procedure ShowFirstTimeScene(vFirst: Boolean);
begin
  vWeather.Scene.Settings.Visible := True;
  vWeather.Scene.Settings_Ani.Enabled := True;
  if vFirst = False then
  begin
    vWeather.Scene.First.Panel := TPanel.Create(vWeather.Scene.weather);
    vWeather.Scene.First.Panel.Name := 'A_W_Fisrt';
    vWeather.Scene.First.Panel.Parent := vWeather.Scene.weather;
    vWeather.Scene.First.Panel.SetBounds(extrafe.res.Half_Width - 400, extrafe.res.Half_Height - 500, 800, 600);
    vWeather.Scene.First.Panel.Visible := True;

    vWeather.Scene.First.Panel_Shadow := TShadowEffect.Create(vWeather.Scene.First.Panel);
    vWeather.Scene.First.Panel_Shadow.Name := 'A_W_First_Shadow';
    vWeather.Scene.First.Panel_Shadow.Parent := vWeather.Scene.First.Panel;
    vWeather.Scene.First.Panel_Shadow.ShadowColor := TAlphaColorRec.Black;
    vWeather.Scene.First.Panel_Shadow.Opacity := 0.9;
    vWeather.Scene.First.Panel_Shadow.Distance := 2;
    vWeather.Scene.First.Panel_Shadow.Direction := 90;
    vWeather.Scene.First.Panel_Shadow.Enabled := True;

    CreateHeader(vWeather.Scene.First.Panel, 'Weather Icons', #$f002, 'Welcome to "Weather" Addon.', False, nil);

    vWeather.Scene.First.main.Panel := TPanel.Create(vWeather.Scene.First.Panel);
    vWeather.Scene.First.main.Panel.Name := 'A_W_First_Main';
    vWeather.Scene.First.main.Panel.Parent := vWeather.Scene.First.Panel;
    vWeather.Scene.First.main.Panel.Width := vWeather.Scene.First.Panel.Width;
    vWeather.Scene.First.main.Panel.Height := vWeather.Scene.First.Panel.Height - 30;
    vWeather.Scene.First.main.Panel.Position.X := 0;
    vWeather.Scene.First.main.Panel.Position.Y := 30;
    vWeather.Scene.First.main.Panel.Visible := True;

    vWeather.Scene.First.main.Line_1 := TALText.Create(vWeather.Scene.First.main.Panel);
    vWeather.Scene.First.main.Line_1.Name := 'A_W_First_Main_Line_1';
    vWeather.Scene.First.main.Line_1.Parent := vWeather.Scene.First.main.Panel;
    vWeather.Scene.First.main.Line_1.Width := 700;
    vWeather.Scene.First.main.Line_1.Height := 150;
    vWeather.Scene.First.main.Line_1.Position.X := 50;
    vWeather.Scene.First.main.Line_1.Position.Y := 30;
    vWeather.Scene.First.main.Line_1.TextIsHtml := True;
    vWeather.Scene.First.main.Line_1.TextSettings.Font.Size := 14;
    vWeather.Scene.First.main.Line_1.TextSettings.VertAlign := TTextAlign.Leading;
    vWeather.Scene.First.main.Line_1.WordWrap := True;
    vWeather.Scene.First.main.Line_1.Text := 'I assume this is your first time that open "<font color="#ff63cbfc">Weather</font>" addon.';
    vWeather.Scene.First.main.Line_1.Color := TAlphaColorRec.White;
    vWeather.Scene.First.main.Line_1.Visible := True;

    vWeather.Scene.First.main.Line_2 := TALText.Create(vWeather.Scene.First.main.Panel);
    vWeather.Scene.First.main.Line_2.Name := 'A_W_First_Main_Line_2';
    vWeather.Scene.First.main.Line_2.Parent := vWeather.Scene.First.main.Panel;
    vWeather.Scene.First.main.Line_2.Width := 700;
    vWeather.Scene.First.main.Line_2.Height := 150;
    vWeather.Scene.First.main.Line_2.Position.X := 50;
    vWeather.Scene.First.main.Line_2.Position.Y := 60;
    vWeather.Scene.First.main.Line_2.TextIsHtml := True;
    vWeather.Scene.First.main.Line_2.TextSettings.Font.Size := 14;
    vWeather.Scene.First.main.Line_2.TextSettings.VertAlign := TTextAlign.Leading;
    vWeather.Scene.First.main.Line_2.WordWrap := True;
    vWeather.Scene.First.main.Line_2.Text :=
      'To start see forcast results go to the <font color="#ff63cbfc">spinning gear</font> to the left, after you close this message.' + #13#10 +
      'Go to <font color="#ff63cbfc">provider panel</font> and choose one. Then go to towns press the <font color="#ff63cbfc">+</font> button and find your town and <font color="#ff63cbfc">add</font> it.';
    vWeather.Scene.First.main.Line_2.Color := TAlphaColorRec.White;
    vWeather.Scene.First.main.Line_2.Visible := True;

    vWeather.Scene.First.main.Line_3 := TALText.Create(vWeather.Scene.First.main.Panel);
    vWeather.Scene.First.main.Line_3.Name := 'A_W_First_Main_Line_3';
    vWeather.Scene.First.main.Line_3.Parent := vWeather.Scene.First.main.Panel;
    vWeather.Scene.First.main.Line_3.Width := 700;
    vWeather.Scene.First.main.Line_3.Height := 150;
    vWeather.Scene.First.main.Line_3.Position.X := 50;
    vWeather.Scene.First.main.Line_3.Position.Y := 120;
    vWeather.Scene.First.main.Line_3.TextIsHtml := True;
    vWeather.Scene.First.main.Line_3.TextSettings.Font.Size := 14;
    vWeather.Scene.First.main.Line_3.TextSettings.VertAlign := TTextAlign.Leading;
    vWeather.Scene.First.main.Line_3.WordWrap := True;
    vWeather.Scene.First.main.Line_3.Text :=
      'This message also appears when you delete all the towns for forcast and the addon is <font color="#ff03fb09">active</font>.';
    vWeather.Scene.First.main.Line_3.Color := TAlphaColorRec.White;
    vWeather.Scene.First.main.Line_3.Visible := True;

    vWeather.Scene.First.main.Line_4 := TALText.Create(vWeather.Scene.First.main.Panel);
    vWeather.Scene.First.main.Line_4.Name := 'A_W_First_Main_Line_4';
    vWeather.Scene.First.main.Line_4.Parent := vWeather.Scene.First.main.Panel;
    vWeather.Scene.First.main.Line_4.Width := 700;
    vWeather.Scene.First.main.Line_4.Height := 150;
    vWeather.Scene.First.main.Line_4.Position.X := 50;
    vWeather.Scene.First.main.Line_4.Position.Y := 160;
    vWeather.Scene.First.main.Line_4.TextIsHtml := True;
    vWeather.Scene.First.main.Line_4.TextSettings.Font.Size := 14;
    vWeather.Scene.First.main.Line_4.TextSettings.VertAlign := TTextAlign.Leading;
    vWeather.Scene.First.main.Line_4.WordWrap := True;
    vWeather.Scene.First.main.Line_4.Text := '" <font color="#ffff0000">Have Fun </font>" ';
    vWeather.Scene.First.main.Line_4.Color := TAlphaColorRec.White;
    vWeather.Scene.First.main.Line_4.Visible := True;

    vWeather.Scene.First.main.Check := TCheckBox.Create(vWeather.Scene.First.main.Panel);
    vWeather.Scene.First.main.Check.Name := 'A_W_First_Main_Check';
    vWeather.Scene.First.main.Check.Parent := vWeather.Scene.First.main.Panel;
    vWeather.Scene.First.main.Check.Width := 400;
    vWeather.Scene.First.main.Check.Height := 24;
    vWeather.Scene.First.main.Check.Position.X := 20;
    vWeather.Scene.First.main.Check.Position.Y := vWeather.Scene.First.main.Panel.Height - 70;
    vWeather.Scene.First.main.Check.Text := 'Check to never see this message again.';
    vWeather.Scene.First.main.Check.FontColor := TAlphaColorRec.White;
    vWeather.Scene.First.main.Check.OnClick := addons.weather.Input.mouse.Checkbox.OnMouseClick;
    vWeather.Scene.First.main.Check.Visible := True;

    vWeather.Scene.First.main.Done := TButton.Create(vWeather.Scene.First.main.Panel);
    vWeather.Scene.First.main.Done.Name := 'A_W_First_Main_Done';
    vWeather.Scene.First.main.Done.Parent := vWeather.Scene.First.main.Panel;
    vWeather.Scene.First.main.Done.Width := 120;
    vWeather.Scene.First.main.Done.Height := 30;
    vWeather.Scene.First.main.Done.Position.X := (vWeather.Scene.First.main.Panel.Width / 2) - 60;
    vWeather.Scene.First.main.Done.Position.Y := vWeather.Scene.First.main.Panel.Height - 40;
    vWeather.Scene.First.main.Done.Text := 'Done';
    vWeather.Scene.First.main.Done.OnClick := addons.weather.Input.mouse.Button.OnMouseClick;
    vWeather.Scene.First.main.Done.Visible := True;
  end;
  addons.weather.Loaded := True;
end;

procedure CheckFirst(vCheched: Boolean);
begin
  addons.weather.Ini.Ini.WriteBool('General', 'First', vCheched);
  addons.weather.Action.First := vCheched;
end;

procedure Control_Slide_Right;
begin
  if vWeather_Ani_Stop then
  begin
    if vWeather.Scene.Control.TabIndex <> vWeather.Scene.Control.TabCount - 1 then
    begin
      vWeather_Ani_Stop := False;
      uWeather_Sounds_PlayEffect('', '', False);
      uWeather_Sounds_PlayMouse('Slide');
      if vWeather.Scene.Control.TabIndex = vWeather.Scene.Control.TabCount - 2 then
        vWeather.Scene.Arrow_Right.Visible := False
      else
        vWeather.Scene.Arrow_Right.Visible := True;
      vWeather.Scene.Arrow_Left.Visible := True;
      vWeather.Scene.Arrow_Right_Glow.Enabled := True;
      vWeather.Scene.Control.Next;
      Close_Map;
    end;
  end;
end;

procedure Control_Slide_Left;
begin
  if vWeather_Ani_Stop then
  begin
    if vWeather.Scene.Control.TabIndex <> 0 then
    begin
      vWeather_Ani_Stop := False;
      uWeather_Sounds_PlayEffect('', '', False);
      uWeather_Sounds_PlayMouse('Slide');
      if vWeather.Scene.Control.TabIndex = 1 then
        vWeather.Scene.Arrow_Left.Visible := False
      else
        vWeather.Scene.Arrow_Left.Visible := True;
      vWeather.Scene.Arrow_Right.Visible := True;
      vWeather.Scene.Arrow_Left_Glow.Enabled := True;
      vWeather.Scene.Control.Previous;
      Close_Map;
    end;
  end;
end;

procedure Show_Map(vProvider, vLat, vLon: String);
begin
  vWeather.Scene.Map.Rect := TRadiantRectangle.Create(vWeather.Scene.weather);
  vWeather.Scene.Map.Rect.Name := 'A_W_Map';
  vWeather.Scene.Map.Rect.Parent := vWeather.Scene.weather;
  vWeather.Scene.Map.Rect.SetBounds(extrafe.res.Width + 10, 10, extrafe.res.Width - 500, 778);
  vWeather.Scene.Map.Rect.Fill.Kind := TBrushKind.Solid;
  vWeather.Scene.Map.Rect.Fill.Color := TAlphaColorRec.Deepskyblue;
  vWeather.Scene.Map.Rect.Visible := True;

  vWeather.Scene.Map.Close := TText.Create(vWeather.Scene.Map.Rect);
  vWeather.Scene.Map.Close.Name := 'A_W_Map_Close';
  vWeather.Scene.Map.Close.Parent := vWeather.Scene.Map.Rect;
  vWeather.Scene.Map.Close.SetBounds(vWeather.Scene.Map.Rect.Width - 40, 6, 28, 28);
  vWeather.Scene.Map.Close.Font.Family := 'IcoMoon-Free';
  vWeather.Scene.Map.Close.Font.Size := 24;
  vWeather.Scene.Map.Close.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Scene.Map.Close.Text := #$ea0f;
  vWeather.Scene.Map.Close.OnClick := addons.weather.Input.mouse.Text.OnMouseClick;
  vWeather.Scene.Map.Close.OnMouseEnter := addons.weather.Input.mouse.Text.OnMouseEnter;
  vWeather.Scene.Map.Close.OnMouseLeave := addons.weather.Input.mouse.Text.OnMouseLeave;
  vWeather.Scene.Map.Close.Visible := True;

  vWeather.Scene.Map.Close_Glow := TGlowEffect.Create(vWeather.Scene.Map.Close);
  vWeather.Scene.Map.Close_Glow.Name := 'A_W_Map_Close_Glow';
  vWeather.Scene.Map.Close_Glow.Parent := vWeather.Scene.Map.Close;
  vWeather.Scene.Map.Close_Glow.Softness := 0.9;
  vWeather.Scene.Map.Close_Glow.GlowColor := TAlphaColorRec.White;
  vWeather.Scene.Map.Close_Glow.Enabled := False;

  vWeather.Scene.Map.Info_Line := TText.Create(vWeather.Scene.Map.Rect);
  vWeather.Scene.Map.Info_Line.Name := 'A_W_Map_Info_Line';
  vWeather.Scene.Map.Info_Line.Parent := vWeather.Scene.Map.Rect;
  vWeather.Scene.Map.Info_Line.SetBounds(15, 6, vWeather.Scene.Map.Rect.Width - 55, 28);
  vWeather.Scene.Map.Info_Line.Font.Size := 24;
  vWeather.Scene.Map.Info_Line.TextSettings.FontColor := TAlphaColorRec.White;
  vWeather.Scene.Map.Info_Line.Text := 'Provider : ' + vProvider + ' , Coordinates = Lat : ' + vLat + ' Lon : ' + vLon;
  vWeather.Scene.Map.Info_Line.Visible := True;

  //������ �� ������ ��� config ����� ������� ������ ��� ������� ������� ������ ��� �� ���� ��� ��� settings addons ��� user

  vWeather.Scene.Map.Map_Url := 'https://bing.com/maps/default.aspx?cp=' + vLat + '~' + vLon + '&lvl=12&style=r&setlang=el';

  vWeather.Scene.Map.Ani := TFloatAnimation.Create(vWeather.Scene.Map.Rect);
  vWeather.Scene.Map.Ani.Name := 'A_W_Map_Animation';
  vWeather.Scene.Map.Ani.Parent := vWeather.Scene.Map.Rect;
  vWeather.Scene.Map.Ani.PropertyName := 'Position.X';
  vWeather.Scene.Map.Ani.Duration := 0.6;
  vWeather.Scene.Map.Ani.StartValue := vWeather.Scene.Map.Rect.Position.X;
  vWeather.Scene.Map.Ani.StopValue := 500;
  vWeather.Scene.Map.Ani.Enabled := True;
  vWeather.Scene.Map.Ani.OnFinish := vWeather.Scene.Map.Ani_On_Finish;
end;

procedure Close_Map;
begin
  if Assigned(vWeather.Scene.Map.Rect) then
    FreeAndNil(vWeather.Scene.Map.Rect);
end;

end.
