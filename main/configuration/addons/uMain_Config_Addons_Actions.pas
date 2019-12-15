unit uMain_Config_Addons_Actions;

interface

uses
  System.Classes,
  System.UITypes,
  System.SysUtils,
  FMX.Objects,
  FMX.StdCtrls,
  BASS;

procedure Activation(vAddonNum: integer);

procedure LeftArrow;
procedure RightArrow;

// Addons activations deactivations
// Weather
procedure Weather_Activate;
procedure Weather_Activate_FreshStart(vFresh: Boolean);
procedure Weather_Activate_Action;
procedure Weather_Activate_ShowMessage;
procedure Weather_Activate_FreeMessage;
procedure Weather_Deactivate;
procedure Weather_Deactivate_Action;
procedure Weather_Deactivate_ShowMessage;
procedure Weather_Free;
// Soundplayer
procedure Soundplayer_Activate;
procedure Soundplayer_Activate_FreshStart(vFresh: Boolean);
procedure Soundplayer_Activate_Action;
procedure Soundplayer_Activate_ShowMessage;
procedure Soundplayer_Activate_FreeMessage;
procedure Soundplayer_Deactivate;
procedure Soundplayer_Deactivate_Action;
procedure Soundplayer_Deactivate_ShowMessage;
procedure Soundplayer_Free;
// Play
procedure AzPlay_Activate;
procedure AzPlay_Activate_FreshStart(vFresh: Boolean);
procedure AzPlay_Activate_FreeMessage;
procedure AzPlay_Deactivate;

procedure Set_Icons(vDeletedIcon: integer);

implementation

uses
  uLoad_AllTypes,
  main,
  uDB,
  uDB_AUser,
  uWindows,
  uMain_SetAll,
  uMain_AllTypes,
  uMain_Config_Addons,
  uSoundplayer_AllTypes;

procedure Set_Icons(vDeletedIcon: integer);
var
  vi: integer;
begin
  if vDeletedIcon = uDB_AUser.Local.addons.Active then
  begin
    FreeAndNil(mainScene.Header.Addon_Icon.Frame[vDeletedIcon]);
    uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_' + UpperCase(uDB_AUser.Local.addons.Names[vDeletedIcon]), 'MENU_POSITION', '-1', 'USER_ID',
      uDB_AUser.Local.Num.ToString);
    uDB_AUser.Local.addons.Names[vDeletedIcon] := '';
  end
  else
  begin
    for vi := vDeletedIcon + 1 to uDB_AUser.Local.addons.Active do
    begin
      mainScene.Header.Addon_Icon.Icons[vi - 1] := mainScene.Header.Addon_Icon.Icons[vi];
      uDB_AUser.Local.addons.Names[vi - 1] := uDB_AUser.Local.addons.Names[vi];
      uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_' + UpperCase(uDB_AUser.Local.addons.Names[vi - 1]), 'MENU_POSITION', (vi - 1).ToString, 'USER_ID',
        uDB_AUser.Local.Num.ToString);
      if vi = uDB_AUser.Local.addons.Active then
      begin
        FreeAndNil(mainScene.Header.Addon_Icon.Frame[vi]);
        uDB_AUser.Local.addons.Names[vi] := '';
      end;
    end;
  end;
end;

procedure LeftArrow;
begin
  Dec(ex_main.Config.Addons_Tab_First);
  Dec(ex_main.Config.Addons_Tab_Last);
  if ex_main.Config.Addons_Tab_First = 0 then
  begin
    mainScene.Config.main.R.addons.Left_Num.Visible := False;
    mainScene.Config.main.R.addons.Arrow_Left.TextSettings.FontColor := TAlphaColorRec.Grey;
  end;
  if ex_main.Config.Addons_Tab_Last <> uDB_AUser.Local.addons.Active then
  begin
    mainScene.Config.main.R.addons.Right_Num.Visible := True;
    mainScene.Config.main.R.addons.Right_Num.Text := (ex_main.Config.Addons_Tab_Last - 2).ToString;
    mainScene.Config.main.R.addons.Arrow_Right.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  end;
  mainScene.Config.main.R.addons.Left_Num.Text := ex_main.Config.Addons_Tab_First.ToString;
  uMain_Config_Addons.Icons_Free;
  uMain_Config_Addons.Icons(ex_main.Config.Addons_Tab_First);
  if ex_main.Config.Addons_Active_Tab <> -1 then
  begin
    if ex_main.Config.Addons_Active_Tab = uDB_AUser.Local.addons.Active then
      FreeAndNil(mainScene.Config.main.R.addons.Icons_Panel[uDB_AUser.Local.addons.Active])
    else
      uMain_Config_Addons.ShowInfo(ex_main.Config.Addons_Active_Tab);
  end;
end;

procedure RightArrow;
begin
  Inc(ex_main.Config.Addons_Tab_First);
  Inc(ex_main.Config.Addons_Tab_Last);
  if ex_main.Config.Addons_Tab_First > 0 then
  begin
    mainScene.Config.main.R.addons.Left_Num.Visible := True;
    mainScene.Config.main.R.addons.Left_Num.Text := ex_main.Config.Addons_Tab_First.ToString;
    mainScene.Config.main.R.addons.Arrow_Left.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  end;
  if ex_main.Config.Addons_Tab_Last = uDB_AUser.Local.addons.Active then
  begin
    mainScene.Config.main.R.addons.Right_Num.Visible := False;
    mainScene.Config.main.R.addons.Right_Num.Text := '0';
    mainScene.Config.main.R.addons.Arrow_Right.TextSettings.FontColor := TAlphaColorRec.Grey;
  end;
  mainScene.Config.main.R.addons.Right_Num.Text := (ex_main.Config.Addons_Tab_Last - 4).ToString;
  uMain_Config_Addons.Icons_Free;
  uMain_Config_Addons.Icons(ex_main.Config.Addons_Tab_First);
  if ex_main.Config.Addons_Active_Tab <> -1 then
  begin
    if ex_main.Config.Addons_Active_Tab = 0 then
      FreeAndNil(mainScene.Config.main.R.addons.Icons_Panel[0])
    else
      uMain_Config_Addons.ShowInfo(ex_main.Config.Addons_Active_Tab);
  end;
end;

procedure Soundplayer_Activate_FreshStart(vFresh: Boolean);
begin
  Inc(uDB_AUser.Local.addons.Active, 1);
  uDB_AUser.Local.addons.soundplayer := True;
  uDB_AUser.Local.addons.Soundplayer_D.Menu_Position := uDB_AUser.Local.addons.Active;
  uDB_AUser.Local.addons.Soundplayer_D.First_Pop := True;
  uDB_AUser.Local.addons.Soundplayer_D.Volume := 80;
  uDB_AUser.Local.addons.Soundplayer_D.Last_Visit := DateTimeToStr(now);
  uDB_AUser.Local.addons.Soundplayer_D.Last_Play_Song_Num := -1;
  uDB_AUser.Local.addons.Soundplayer_D.Last_Playlist_Num := -1;
  uDB_AUser.Local.addons.Soundplayer_D.Playlist_Count := -1;
  uDB_AUser.Local.addons.Soundplayer_D.Total_Play_Click := -1;
  uDB_AUser.Local.addons.Soundplayer_D.Total_Play_Time := '00:00:00';

  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDONS', 'ACTIVE', uDB_AUser.Local.addons.Active.ToString, 'USER_ID', uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDONS', 'SOUNDPLAYER', '1', 'USER_ID', uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_SOUNDPLAYER', 'MENU_POSITION', uDB_AUser.Local.addons.Soundplayer_D.Menu_Position.ToString, 'USER_ID',
    uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_SOUNDPLAYER', 'FIRST_POP', '0', 'USER_ID', uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_SOUNDPLAYER', 'VOLUME', uDB_AUser.Local.addons.Soundplayer_D.Volume.ToString, 'USER_ID',
    uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_SOUNDPLAYER', 'LAST_VISIT', uDB_AUser.Local.addons.Soundplayer_D.Last_Visit, 'USER_ID',
    uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_SOUNDPLAYER', 'LAST_PLAY_SONG_NUM', uDB_AUser.Local.addons.Soundplayer_D.Last_Play_Song_Num.ToString,
    'USER_ID', uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_SOUNDPLAYER', 'LAST_PLAYLIST_NUM', uDB_AUser.Local.addons.Soundplayer_D.Last_Playlist_Num.ToString,
    'USER_ID', uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_SOUNDPLAYER', 'PLAYLIST_COUNT', uDB_AUser.Local.addons.Soundplayer_D.Playlist_Count.ToString, 'USER_ID',
    uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_SOUNDPLAYER', 'TOTAL_PLAY_CLICK', uDB_AUser.Local.addons.Soundplayer_D.Total_Play_Click.ToString, 'USER_ID',
    uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_SOUNDPLAYER', 'TOTAL_PLAY_TIME', uDB_AUser.Local.addons.Soundplayer_D.Total_Play_Time, 'USER_ID',
    uDB_AUser.Local.Num.ToString);

  mainScene.Config.main.R.addons.Icons_Info[3].Activeted.Text := 'Active';
  mainScene.Config.main.R.addons.Icons_Info[3].Activeted.Color := TAlphaColorRec.Lime;
  mainScene.Config.main.R.addons.Icons_Info[3].Action.Text := 'Deactivate';

  uMain_SetAll.Addon_Icon(uDB_AUser.Local.addons.Soundplayer_D.Menu_Position);
  uDB_AUser.Local.addons.Names[uDB_AUser.Local.addons.Soundplayer_D.Menu_Position] := 'soundplayer';
  mainScene.Header.Addon_Icon.Icons[uDB_AUser.Local.addons.Soundplayer_D.Menu_Position].Text := #$ea15;
end;

procedure Soundplayer_Activate_Action;
begin

  // if mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_2.IsChecked then
  // begin
  // Soundplayer_Activate_FreshStart(True)
  // end
  // else
  Soundplayer_Activate_FreshStart(True);
  Soundplayer_Activate_FreeMessage;
end;

procedure Soundplayer_Activate_ShowMessage;
begin
  extrafe.prog.State := 'main_config_addons_actions';
  mainScene.Config.main.Left_Blur.Enabled := True;
  mainScene.Config.main.R.addons.Panel_Blur.Enabled := True;

  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.Panel := TPanel.Create(mainScene.Config.Panel);
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.Panel.Name := 'Main_Config_Addons_Soundplayer_Activate_Msg';
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.Panel.Parent := mainScene.Config.Panel;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.Panel.Width := 500;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.Panel.Height := 200;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.Panel.Position.X := (mainScene.Config.Panel.Width / 2) - 150;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.Panel.Position.Y := (mainScene.Config.Panel.Height / 2) - 100;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.Panel.Visible := True;

  CreateHeader(mainScene.Config.main.R.addons.soundplayer.Msg_Actv.Panel, 'IcoMoon-Free', #$e997, 'Activate Soundplayer addon', False, nil);

  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel := TPanel.Create(mainScene.Config.main.R.addons.soundplayer.Msg_Actv.Panel);
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel.Name := 'Main_Config_Addons_Soundplayer_Activate_Msg_Main';
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel.Parent := mainScene.Config.main.R.addons.soundplayer.Msg_Actv.Panel;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel.Width := mainScene.Config.main.R.addons.soundplayer.Msg_Actv.Panel.Width;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel.Height := mainScene.Config.main.R.addons.soundplayer.Msg_Actv.Panel.Height - 30;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel.Position.X := 0;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel.Position.Y := 30;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel.Visible := True;

  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Text := TLabel.Create(mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel);
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Text.Name := 'Main_Config_Addons_Soundplayer_Activate_Msg_Main_Text';
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Text.Parent := mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Text.Width := 400;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Text.Height := 24;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Text.Position.X := 50;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Text.Position.Y := 30;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Text.Text := 'Found old configuration and playlists do you want to use this one?';
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Text.Font.Style := mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Text.Font.Style +
    [TFontStyle.fsBold];
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Text.Visible := True;

  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_1 := TRadioButton.Create(mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel);
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_1.Name := 'Main_Config_Addons_Soundplayer_Activate_Msg_Main_Radio_1';
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_1.Parent := mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_1.Width := 300;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_1.Height := 24;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_1.Position.X := 100;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_1.Position.Y := 60;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_1.Text := 'Yes load my old playlists.';
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_1.OnClick := ex_main.Input.mouse_config.Radio.OnMouseClick;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_1.Visible := True;

  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_2 := TRadioButton.Create(mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel);
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_2.Name := 'Main_Config_Addons_Soundplayer_Activate_Msg_Main_Radio_2';
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_2.Parent := mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_2.Width := 300;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_2.Height := 24;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_2.Position.X := 100;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_2.Position.Y := 90;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_2.Text := 'Lets create a new ones and rock.';
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_2.OnClick := ex_main.Input.mouse_config.Radio.OnMouseClick;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_2.Visible := True;

  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.OK := TButton.Create(mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel);
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.OK.Name := 'Main_Config_Addons_Soundplayer_Activate_Msg_Main_OK';
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.OK.Parent := mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.OK.Width := 100;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.OK.Height := 26;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.OK.Position.X := 50;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.OK.Position.Y := mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel.Height - 36;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.OK.Text := 'Activate';
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.OK.OnClick := ex_main.Input.mouse_config.Button.OnMouseClick;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.OK.Enabled := False;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.OK.Visible := True;

  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Cancel := TButton.Create(mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel);
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Cancel.Name := 'Main_Config_Addons_Soundplayer_Activate_Msg_Main_Cancel';
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Cancel.Parent := mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Cancel.Width := 100;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Cancel.Height := 26;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Cancel.Position.X := mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel.Width - 150;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Cancel.Position.Y := mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Panel.Height - 36;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Cancel.Text := 'Cancel';
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Cancel.OnClick := ex_main.Input.mouse_config.Button.OnMouseClick;
  mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Cancel.Visible := True;
end;

procedure Soundplayer_Activate_FreeMessage;
begin
  extrafe.prog.State := 'main_config';
  mainScene.Config.main.Left_Blur.Enabled := False;
  mainScene.Config.main.R.addons.Panel_Blur.Enabled := False;
  FreeAndNil(mainScene.Config.main.R.addons.soundplayer.Msg_Actv.Panel);
end;

procedure Soundplayer_Activate;
begin
  if uDB_AUser.Local.addons.Soundplayer_D.Playlist_Count <> -1 then
    Soundplayer_Activate_ShowMessage
  else
    Soundplayer_Activate_FreshStart(True);
end;

procedure Soundplayer_Deactivate;
begin
  if uDB_AUser.Local.addons.Soundplayer_D.Playlist_Count <> -1 then
    Soundplayer_Deactivate_ShowMessage
  else
    Soundplayer_Deactivate_Action;
end;

procedure Soundplayer_Deactivate_Action;
begin
  Set_Icons(uDB_AUser.Local.addons.Soundplayer_D.Menu_Position);

  Dec(uDB_AUser.Local.addons.Active, 1);
  uDB_AUser.Local.addons.soundplayer := False;
  uDB_AUser.Local.addons.Soundplayer_D.Menu_Position := -1;

  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDONS', 'ACTIVE', uDB_AUser.Local.addons.Active.ToString, 'USER_ID', uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDONS', 'SOUNDPLAYER', '0', 'USER_ID', uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_SOUNDPLAYER', 'MENU_POSITION', '-1', 'USER_ID', uDB_AUser.Local.Num.ToString);

  mainScene.Config.main.R.addons.Icons_Info[3].Activeted.Text := 'Inactive';
  mainScene.Config.main.R.addons.Icons_Info[3].Activeted.Color := TAlphaColorRec.Red;
  mainScene.Config.main.R.addons.Icons_Info[3].Action.Text := 'Activate';
  if Assigned(mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_2) then
  begin
    if mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_2.IsChecked then
    begin
      // Delete playlist from database and set in addon_soundplayer the Playlist_Count to -1
      // DeleteFile(addons.soundplayer.ini.Path + addons.soundplayer.ini.Name);
      // uWindows_DeleteDirectory(addons.soundplayer.Path.Playlists, '*.*', False);
    end;
  end;
  if soundplayer.player = sPlay then
  begin
    BASS_ChannelStop(sound.str_music[1]);
    BASS_StreamFree(sound.str_music[1]);
  end;
  Soundplayer_Free;
end;

procedure Soundplayer_Deactivate_ShowMessage;
begin
  extrafe.prog.State := 'main_config_addons_actions';
  mainScene.Config.main.Left_Blur.Enabled := True;
  mainScene.Config.main.R.addons.Panel_Blur.Enabled := True;

  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.Panel := TPanel.Create(mainScene.Config.Panel);
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.Panel.Name := 'Main_Config_Addons_Soundplayer_Deactivate_Msg';
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.Panel.Parent := mainScene.Config.Panel;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.Panel.Width := 500;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.Panel.Height := 200;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.Panel.Position.X := (mainScene.Config.Panel.Width / 2) - 150;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.Panel.Position.Y := (mainScene.Config.Panel.Height / 2) - 100;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.Panel.Visible := True;

  CreateHeader(mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.Panel, 'IcoMoon-Free', #$e996, 'Deactivate Soundplayer addon', False, nil);

  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel := TPanel.Create(mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.Panel);
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel.Name := 'Main_Config_Addons_Soundplayer_Deactivate_Msg_Main';
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel.Parent := mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.Panel;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel.Width := mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.Panel.Width;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel.Height := mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.Panel.Height - 30;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel.Position.X := 0;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel.Position.Y := 30;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel.Visible := True;

  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Text := TLabel.Create(mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel);
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Text.Name := 'Main_Config_Addons_Soundplayer_Deactivate_Msg_Main_Text';
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Text.Parent := mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Text.Width := 400;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Text.Height := 24;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Text.Position.X := 50;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Text.Position.Y := 30;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Text.Text := 'Do you want to keep the existance configuration and playlists?';
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Text.Font.Style := mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Text.Font.Style +
    [TFontStyle.fsBold];
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Text.Visible := True;

  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_1 := TRadioButton.Create(mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel);
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_1.Name := 'Main_Config_Addons_Soundplayer_Deactivate_Msg_Main_Radio_1';
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_1.Parent := mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_1.Width := 300;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_1.Height := 24;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_1.Position.X := 100;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_1.Position.Y := 60;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_1.Text := 'Yes keep it all.';
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_1.OnClick := ex_main.Input.mouse_config.Radio.OnMouseClick;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_1.Visible := True;

  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_2 := TRadioButton.Create(mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel);
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_2.Name := 'Main_Config_Addons_Soundplayer_Deactivate_Msg_Main_Radio_2';
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_2.Parent := mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_2.Width := 300;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_2.Height := 24;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_2.Position.X := 100;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_2.Position.Y := 90;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_2.Text := 'I don''t want anything. Delete all.';
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_2.OnClick := ex_main.Input.mouse_config.Radio.OnMouseClick;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_2.Visible := True;

  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.OK := TButton.Create(mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel);
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.OK.Name := 'Main_Config_Addons_Soundplayer_Deactivate_Msg_Main_OK';
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.OK.Parent := mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.OK.Width := 100;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.OK.Height := 26;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.OK.Position.X := 50;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.OK.Position.Y := mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel.Height - 36;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.OK.Text := 'Deactivate';
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.OK.OnClick := ex_main.Input.mouse_config.Button.OnMouseClick;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.OK.Enabled := False;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.OK.Visible := True;

  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Cancel := TButton.Create(mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel);
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Cancel.Name := 'Main_Config_Addons_Soundplayer_Deactivate_Msg_Main_Cancel';
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Cancel.Parent := mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Cancel.Width := 100;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Cancel.Height := 26;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Cancel.Position.X := mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel.Width - 150;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Cancel.Position.Y := mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Panel.Height - 36;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Cancel.Text := 'Cancel';
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Cancel.OnClick := ex_main.Input.mouse_config.Button.OnMouseClick;
  mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Cancel.Visible := True;
end;

procedure Soundplayer_Free;
begin
  extrafe.prog.State := 'main_config';
  mainScene.Config.main.Left_Blur.Enabled := False;
  mainScene.Config.main.R.addons.Panel_Blur.Enabled := False;
  FreeAndNil(mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.Panel);
end;

/// /////////////////////////////////////////////////////////////////////////////
procedure Weather_Activate_ShowMessage;
begin
  extrafe.prog.State := 'main_config_addons_actions';
  mainScene.Config.main.Left_Blur.Enabled := True;
  mainScene.Config.main.R.addons.Panel_Blur.Enabled := True;

  mainScene.Config.main.R.addons.weather.Msg_Actv.Panel := TPanel.Create(mainScene.Config.Panel);
  mainScene.Config.main.R.addons.weather.Msg_Actv.Panel.Name := 'Main_Config_Addons_Weather_Activate_Msg';
  mainScene.Config.main.R.addons.weather.Msg_Actv.Panel.Parent := mainScene.Config.Panel;
  mainScene.Config.main.R.addons.weather.Msg_Actv.Panel.Width := 500;
  mainScene.Config.main.R.addons.weather.Msg_Actv.Panel.Height := 200;
  mainScene.Config.main.R.addons.weather.Msg_Actv.Panel.Position.X := (mainScene.Config.Panel.Width / 2) - 150;
  mainScene.Config.main.R.addons.weather.Msg_Actv.Panel.Position.Y := (mainScene.Config.Panel.Height / 2) - 100;
  mainScene.Config.main.R.addons.weather.Msg_Actv.Panel.Visible := True;

  CreateHeader(mainScene.Config.main.R.addons.weather.Msg_Actv.Panel, 'IcoMoon-Free', #$e997, 'Activate Weather addon', False, nil);

  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel := TPanel.Create(mainScene.Config.main.R.addons.weather.Msg_Actv.Panel);
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel.Name := 'Main_Config_Addons_Weather_Activate_Msg_Main';
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel.Parent := mainScene.Config.main.R.addons.weather.Msg_Actv.Panel;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel.Width := mainScene.Config.main.R.addons.weather.Msg_Actv.Panel.Width;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel.Height := mainScene.Config.main.R.addons.weather.Msg_Actv.Panel.Height - 30;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel.Position.X := 0;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel.Position.Y := 30;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel.Visible := True;

  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Text := TLabel.Create(mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel);
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Text.Name := 'Main_Config_Addons_Weather_Activate_Msg_Main_Text';
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Text.Parent := mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Text.Width := 400;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Text.Height := 24;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Text.Position.X := 50;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Text.Position.Y := 30;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Text.Text := 'Found old configuration do you want to use this one?';
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Text.Font.Style := mainScene.Config.main.R.addons.weather.Msg_Actv.main.Text.Font.Style +
    [TFontStyle.fsBold];
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Text.Visible := True;

  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_1 := TRadioButton.Create(mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel);
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_1.Name := 'Main_Config_Addons_Weather_Activate_Msg_Main_Radio_1';
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_1.Parent := mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_1.Width := 300;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_1.Height := 24;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_1.Position.X := 100;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_1.Position.Y := 60;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_1.Text := 'Yes i have some good places here.';
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_1.OnClick := ex_main.Input.mouse_config.Radio.OnMouseClick;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_1.Visible := True;

  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_2 := TRadioButton.Create(mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel);
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_2.Name := 'Main_Config_Addons_Weather_Activate_Msg_Main_Radio_2';
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_2.Parent := mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_2.Width := 300;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_2.Height := 24;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_2.Position.X := 100;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_2.Position.Y := 90;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_2.Text := 'No let''s make a fresh new start.';
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_2.OnClick := ex_main.Input.mouse_config.Radio.OnMouseClick;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_2.Visible := True;

  mainScene.Config.main.R.addons.weather.Msg_Actv.main.OK := TButton.Create(mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel);
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.OK.Name := 'Main_Config_Addons_Weather_Activate_Msg_Main_OK';
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.OK.Parent := mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.OK.Width := 100;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.OK.Height := 26;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.OK.Position.X := 50;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.OK.Position.Y := mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel.Height - 36;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.OK.Text := 'Activate';
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.OK.OnClick := ex_main.Input.mouse_config.Button.OnMouseClick;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.OK.Enabled := False;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.OK.Visible := True;

  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Cancel := TButton.Create(mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel);
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Cancel.Name := 'Main_Config_Addons_Weather_Activate_Msg_Main_Cancel';
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Cancel.Parent := mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Cancel.Width := 100;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Cancel.Height := 26;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Cancel.Position.X := mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel.Width - 150;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Cancel.Position.Y := mainScene.Config.main.R.addons.weather.Msg_Actv.main.Panel.Height - 36;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Cancel.Text := 'Cancel';
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Cancel.OnClick := ex_main.Input.mouse_config.Button.OnMouseClick;
  mainScene.Config.main.R.addons.weather.Msg_Actv.main.Cancel.Visible := True;
end;

procedure Weather_Activate_FreeMessage;
begin
  extrafe.prog.State := 'main_config';
  mainScene.Config.main.Left_Blur.Enabled := False;
  mainScene.Config.main.R.addons.Panel_Blur.Enabled := False;
  FreeAndNil(mainScene.Config.main.R.addons.weather.Msg_Actv.Panel)
end;

procedure Weather_Activate_FreshStart(vFresh: Boolean);
begin
  Inc(uDB_AUser.Local.addons.Active, 1);
  uDB_AUser.Local.addons.weather := True;
  uDB_AUser.Local.addons.Weather_D.Menu_Position := uDB_AUser.Local.addons.Active;
  uDB_AUser.Local.addons.Weather_D.First_Pop := True;
  if vFresh then
    uDB_AUser.Local.addons.Weather_D.Old_Backup := True;
  uDB_AUser.Local.addons.Weather_D.Provider_Count := 1;
  uDB_AUser.Local.addons.Weather_D.Yahoo.Iconset_Count := 3;
  uDB_AUser.Local.addons.Weather_D.Yahoo.Iconset := 'default';
  uDB_AUser.Local.addons.Weather_D.Yahoo.Towns_Count := -1;
  uDB_AUser.Local.addons.Weather_D.Yahoo.Metric:= 'imperial';
  uDB_AUser.Local.addons.Weather_D.Yahoo.Degree := 'celcius';
  uDB_AUser.Local.addons.Weather_D.OpenWeatherMap.Iconset_Count := 1;
  uDB_AUser.Local.addons.Weather_D.OpenWeatherMap.Iconset := 'default';
  uDB_AUser.Local.addons.Weather_D.OpenWeatherMap.Towns_Count := -1;
  uDB_AUser.Local.addons.Weather_D.OpenWeatherMap.Metric := 'imperial';
  uDB_AUser.Local.addons.Weather_D.OpenWeatherMap.Degree := 'celcius';
  uDB_AUser.Local.addons.Weather_D.OpenWeatherMap.API := '';
  uDB_AUser.Local.addons.Weather_D.OpenWeatherMap.Language := 'english';

  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDONS', 'ACTIVE', uDB_AUser.Local.addons.Active.ToString, 'USER_ID', uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDONS', 'WEATHER', '1', 'USER_ID', uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_WEATHER', 'MENU_POSITION', uDB_AUser.Local.addons.Weather_D.Menu_Position.ToString, 'USER_ID',
    uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_WEATHER', 'FIRST_POP', uDB_AUser.Local.addons.Weather_D.First_Pop.ToInteger.ToString, 'USER_ID',
    uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_WEATHER', 'OLD_BACKUP', uDB_AUser.Local.addons.Weather_D.Old_Backup.ToInteger.ToString, 'USER_ID',
    uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_WEATHER', 'PROVIDER_COUNT', uDB_AUser.Local.addons.Weather_D.Provider_Count.ToString, 'USER_ID',
    uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_WEATHER', 'PROVIDER', uDB_AUser.Local.addons.Weather_D.Provider, 'USER_ID', uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_WEATHER', 'YAHOO_ICONSET_COUNT', uDB_AUser.Local.addons.Weather_D.Yahoo.Iconset_Count.ToString, 'USER_ID',
    uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_WEATHER', 'YAHOO_ICONSET', uDB_AUser.Local.addons.Weather_D.Yahoo.Iconset, 'USER_ID',
    uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_WEATHER', 'YAHOO_METRIC', uDB_AUser.Local.addons.Weather_D.Yahoo.Metric, 'USER_ID',
    uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_WEATHER', 'YAHOO_DEGREE_TYPE', uDB_AUser.Local.addons.Weather_D.Yahoo.Degree, 'USER_ID',
    uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_WEATHER', 'OWM_ICONSET_COUNT', uDB_AUser.Local.addons.Weather_D.OpenWeatherMap.Iconset_Count.ToString,
    'USER_ID', uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_WEATHER', 'OWM_ICONSET', uDB_AUser.Local.addons.Weather_D.OpenWeatherMap.Iconset, 'USER_ID',
    uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_WEATHER', 'OWM_METRIC', uDB_AUser.Local.addons.Weather_D.OpenWeatherMap.Metric, 'USER_ID',
    uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_WEATHER', 'OWM_DEGREE_TYPE', uDB_AUser.Local.addons.Weather_D.OpenWeatherMap.Degree, 'USER_ID',
    uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_WEATHER', 'OWM_APIKEY', uDB_AUser.Local.addons.Weather_D.OpenWeatherMap.API, 'USER_ID',
    uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_WEATHER', 'OWM_LANGUAGE', uDB_AUser.Local.addons.Weather_D.OpenWeatherMap.Language, 'USER_ID',
    uDB_AUser.Local.Num.ToString);

  mainScene.Config.main.R.addons.Icons_Info[2].Activeted.Text := 'Active';
  mainScene.Config.main.R.addons.Icons_Info[2].Activeted.Color := TAlphaColorRec.Lime;
  mainScene.Config.main.R.addons.Icons_Info[2].Action.Text := 'Deactivate';

  uMain_SetAll.Addon_Icon(uDB_AUser.Local.addons.Weather_D.Menu_Position);
  uDB_AUser.Local.addons.Names[uDB_AUser.Local.addons.Weather_D.Menu_Position] := 'weather';
  mainScene.Header.Addon_Icon.Icons[uDB_AUser.Local.addons.Weather_D.Menu_Position].Text := #$e9c1;
end;

procedure Weather_Activate_Action;
begin
  if mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_2.IsChecked then
    Weather_Activate_FreshStart(True)
  else
    Weather_Activate_FreshStart(False);
  Weather_Activate_FreeMessage;
end;

procedure Weather_Activate;
begin
  if uDB_AUser.Local.addons.Weather_D.Old_Backup then
    Weather_Activate_ShowMessage
  else
    Weather_Activate_FreshStart(True);
end;

procedure Weather_Deactivate_ShowMessage;
begin
  extrafe.prog.State := 'main_config_addons_actions';
  mainScene.Config.main.Left_Blur.Enabled := True;
  mainScene.Config.main.R.addons.Panel_Blur.Enabled := True;

  mainScene.Config.main.R.addons.weather.Msg_Deactv.Panel := TPanel.Create(mainScene.Config.Panel);
  mainScene.Config.main.R.addons.weather.Msg_Deactv.Panel.Name := 'Main_Config_Addons_Weather_Deactivate_Msg';
  mainScene.Config.main.R.addons.weather.Msg_Deactv.Panel.Parent := mainScene.Config.Panel;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.Panel.Width := 500;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.Panel.Height := 200;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.Panel.Position.X := (mainScene.Config.Panel.Width / 2) - 150;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.Panel.Position.Y := (mainScene.Config.Panel.Height / 2) - 100;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.Panel.Visible := True;

  CreateHeader(mainScene.Config.main.R.addons.weather.Msg_Deactv.Panel, 'IcoMoon-Free', #$e996, 'Deactivate Weather addon', False, nil);

  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel := TPanel.Create(mainScene.Config.main.R.addons.weather.Msg_Deactv.Panel);
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel.Name := 'Main_Config_Addons_Weather_Deactivate_Msg_Main';
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel.Parent := mainScene.Config.main.R.addons.weather.Msg_Deactv.Panel;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel.Width := mainScene.Config.main.R.addons.weather.Msg_Deactv.Panel.Width;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel.Height := mainScene.Config.main.R.addons.weather.Msg_Deactv.Panel.Height - 30;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel.Position.X := 0;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel.Position.Y := 30;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel.Visible := True;

  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Text := TLabel.Create(mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel);
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Text.Name := 'Main_Config_Addons_Weather_Deactivate_Msg_Main_Text';
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Text.Parent := mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Text.Width := 400;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Text.Height := 24;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Text.Position.X := 50;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Text.Position.Y := 30;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Text.Text := 'Do you want to keep the existance configuration for future proposes?';
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Text.Font.Style := mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Text.Font.Style +
    [TFontStyle.fsBold];
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Text.Visible := True;

  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_1 := TRadioButton.Create(mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel);
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_1.Name := 'Main_Config_Addons_Weather_Deactivate_Msg_Main_Radio_1';
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_1.Parent := mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_1.Width := 300;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_1.Height := 24;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_1.Position.X := 100;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_1.Position.Y := 60;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_1.Text := 'Yes please keep it.';
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_1.OnClick := ex_main.Input.mouse_config.Radio.OnMouseClick;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_1.Visible := True;

  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_2 := TRadioButton.Create(mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel);
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_2.Name := 'Main_Config_Addons_Weather_Deactivate_Msg_Main_Radio_2';
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_2.Parent := mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_2.Width := 300;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_2.Height := 24;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_2.Position.X := 100;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_2.Position.Y := 90;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_2.Text := 'Delete it, i start from the beginning.';
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_2.OnClick := ex_main.Input.mouse_config.Radio.OnMouseClick;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_2.Visible := True;

  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.OK := TButton.Create(mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel);
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.OK.Name := 'Main_Config_Addons_Weather_Deactivate_Msg_Main_OK';
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.OK.Parent := mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.OK.Width := 100;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.OK.Height := 26;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.OK.Position.X := 50;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.OK.Position.Y := mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel.Height - 36;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.OK.Text := 'Deactivate';
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.OK.OnClick := ex_main.Input.mouse_config.Button.OnMouseClick;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.OK.Enabled := False;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.OK.Visible := True;

  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Cancel := TButton.Create(mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel);
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Cancel.Name := 'Main_Config_Addons_Weather_Deactivate_Msg_Main_Cancel';
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Cancel.Parent := mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Cancel.Width := 100;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Cancel.Height := 26;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Cancel.Position.X := mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel.Width - 150;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Cancel.Position.Y := mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Panel.Height - 36;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Cancel.Text := 'Cancel';
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Cancel.OnClick := ex_main.Input.mouse_config.Button.OnMouseClick;
  mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Cancel.Visible := True;
end;

procedure Weather_Deactivate_Action;
begin
  Set_Icons(uDB_AUser.Local.addons.Weather_D.Menu_Position);

  Dec(uDB_AUser.Local.addons.Active, 1);
  uDB_AUser.Local.addons.weather := False;

  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDONS', 'ACTIVE', uDB_AUser.Local.addons.Active.ToString, 'USER_ID', uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDONS', 'WEATHER', 'FALSE', 'USER_ID', uDB_AUser.Local.Num.ToString);

  mainScene.Config.main.R.addons.Icons_Info[2].Activeted.Text := 'Inactive';
  mainScene.Config.main.R.addons.Icons_Info[2].Activeted.Color := TAlphaColorRec.Red;
  mainScene.Config.main.R.addons.Icons_Info[2].Action.Text := 'Activate';

  Weather_Free;
end;

procedure Weather_Deactivate;
begin
  if uDB_AUser.Local.addons.Weather_D.Yahoo.Towns_Count > -1 then
    Weather_Deactivate_ShowMessage
  else
    Weather_Deactivate_Action;
end;

procedure Weather_Free;
begin
  extrafe.prog.State := 'main_config_addons';
  mainScene.Config.main.Left_Blur.Enabled := False;
  mainScene.Config.main.R.addons.Panel_Blur.Enabled := False;
  FreeAndNil(mainScene.Config.main.R.addons.weather.Msg_Deactv.Panel);
end;

///
procedure AzPlay_Activate_FreshStart(vFresh: Boolean);
begin
  Inc(uDB_AUser.Local.addons.Active, 1);
  uDB_AUser.Local.addons.Azplay := True;
  uDB_AUser.Local.addons.Azplay_D.Menu_Position := uDB_AUser.Local.addons.Active;

  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDONS', 'ACTIVE', uDB_AUser.Local.addons.Active.ToString, 'USER_ID', uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDONS', 'AZPLAY', '1', 'USER_ID', uDB_AUser.Local.Num.ToString);
  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'ADDON_AZPLAY', 'MENU_POSITION', uDB_AUser.Local.addons.Azplay_D.Menu_Position.ToString, 'USER_ID',
    uDB_AUser.Local.Num.ToString);

  mainScene.Config.main.R.addons.Icons_Info[4].Activeted.Text := 'Active';
  mainScene.Config.main.R.addons.Icons_Info[4].Activeted.Color := TAlphaColorRec.Lime;
  mainScene.Config.main.R.addons.Icons_Info[4].Action.Text := 'Deactivate';
  addons.Active_PosNames[addons.play.Main_Menu_Position] := 'play';
end;

procedure AzPlay_Activate_FreeMessage;
begin
  extrafe.prog.State := 'main_config';
  mainScene.Config.main.Left_Blur.Enabled := False;
  mainScene.Config.main.R.addons.Panel_Blur.Enabled := False;
end;

procedure AzPlay_Activate;
begin
  { extrafe.prog.State := 'main_config_addons_actions';
    mainScene.Config.main.Left_Blur.Enabled := True;
    mainScene.Config.main.R.addons.Panel_Blur.Enabled := True; }

  AzPlay_Activate_FreshStart(True);
end;

procedure AzPlay_Deactivate;
begin

end;

/// /////////////////////////////////////////////////////////////////////////////

procedure Activation(vAddonNum: integer);
begin
  if vAddonNum = 2 then
  begin
    case uDB_AUser.Local.addons.weather of
      True:
        Weather_Deactivate;
      False:
        Weather_Activate;
    end;
  end
  else if vAddonNum = 3 then
  begin
    case uDB_AUser.Local.addons.soundplayer of
      True:
        Soundplayer_Deactivate;
      False:
        Soundplayer_Activate;
    end;
  end
  else if vAddonNum = 4 then
  begin
    case uDB_AUser.Local.addons.Azplay of
      True:
        AzPlay_Deactivate;
      False:
        AzPlay_Activate;
    end;
  end;
end;

end.
