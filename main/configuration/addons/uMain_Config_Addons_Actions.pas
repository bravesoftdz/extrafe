unit uMain_Config_Addons_Actions;

interface

uses
  System.Classes,
  System.UITypes,
  System.SysUtils,
  FMX.Objects,
  FMX.StdCtrls,
  BASS;

procedure uMain_Config_Addons_Actions_AddonActivation(vAddonNum: integer);

procedure LeftArrow;
procedure RightArrow;

// Addons activations deactivations
// Weather
procedure Activate_Weather;
procedure Activate_Weather_FreshStart(vFresh: Boolean);
procedure Activate_Weather_Action;
procedure Activate_Weather_ShowMessage;
procedure Activate_Weather_FreeMessage;
procedure uMain_Config_Addons_Actions_Deactivate_Weather;
procedure uMain_Config_Addons_Actions_Deactivate_Weather_Action;
procedure uMain_Config_Addons_Actions_Deactivate_Weather_ShowMessage;
procedure uMain_Config_Addons_Actions_Deactivate_Weather_FreeMessage;
// Soundplayer
procedure uMain_Config_Addons_Actions_Activate_Soundplayer;
procedure uMain_Config_Addons_Actions_Activate_Soundplayer_FreshStart(vFresh: Boolean);
procedure uMain_Config_Addons_Actions_Activate_Soundplayer_Action;
procedure uMain_Config_Addons_Actions_Activate_Soundplayer_ShowMessage;
procedure uMain_Config_Addons_Actions_Activate_Soundplayer_FreeMessage;
procedure uMain_Config_Addons_Actions_Deactivate_Soundplayer;
procedure uMain_Config_Addons_Actions_Deactivate_Soundplayer_Action;
procedure uMain_Config_Addons_Actions_Deactivate_Soundplayer_ShowMessage;
procedure uMain_Config_Addons_Actions_Deactivate_Soundplayer_FreeMessage;
// Play
procedure uMain_Config_Addons_Actions_Activate_Play;
procedure uMain_Config_Addons_Actions_Activate_Play_FreshStart(vFresh: Boolean);
procedure uMain_Config_Addons_Actions_Activate_Play_FreeMessage;
procedure uMain_Config_Addons_Actions_Deactivate_Play;

procedure uMain_Config_Addons_Actions_SetIconsToRightPosition(vDeletedIcon: integer);

implementation

uses
  uLoad_AllTypes,
  main,
  uDatabase,
  uDatabase_ActiveUser,
  uDatabase_SQLCommands,
  uWindows,
  uMain_SetAll,
  uMain_AllTypes,
  uMain_Config_Addons;

procedure uMain_Config_Addons_Actions_SetIconsToRightPosition(vDeletedIcon: integer);
  procedure uMain_Config_Addons_Actions_SetIconsToRightPosition_addonPos(vAddon_Name: string; vMenu_Position: integer);
  begin
    if vAddon_Name = 'weather' then
      addons.weather.Main_Menu_Position := vMenu_Position
    else if vAddon_Name = 'soundplayer' then
      addons.soundplayer.Main_Menu_Position := vMenu_Position
    else if vAddon_Name = 'play' then
      addons.play.Main_Menu_Position := vMenu_Position;
  end;

var
  vi: integer;
begin
  for vi := 2 to user_Active_Local.addons.Active do
    if vDeletedIcon <= vi then
      if vDeletedIcon = vi then
      begin
        // mainScene.Header.Addon_Icons[vi].Bitmap := nil;
        addons.Active_PosNames[vi] := '';
      end
      else
      begin
        // mainScene.Header.Addon_Icons[(vDeletedIcon + vi) - 3].Bitmap := mainScene.Header.Addon_Icons[vi].Bitmap;
        // mainScene.Header.Addon_Icons[vi].Bitmap := nil;
        addons.Active_PosNames[(vDeletedIcon + vi) - 3] := addons.Active_PosNames[vi];
        uMain_Config_Addons_Actions_SetIconsToRightPosition_addonPos(addons.Active_PosNames[vi], ((vDeletedIcon + vi) - 3));
        addons.Active_PosNames[vi] := '';
      end;
end;

/// ///////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure LeftArrow;
begin
  if mainScene.Config.main.R.addons.Arrow_Left_Gray.Enabled = False then
  begin
    Dec(ex_main.Config.Addons_Tab_First);
    Dec(ex_main.Config.Addons_Tab_Last);
    if ex_main.Config.Addons_Tab_First = 0 then
    begin
      mainScene.Config.main.R.addons.Left_Num.Visible := False;
      mainScene.Config.main.R.addons.Arrow_Left_Gray.Enabled := True;
    end;
    if ex_main.Config.Addons_Tab_Last <> user_Active_Local.addons.Active then
    begin
      mainScene.Config.main.R.addons.Arrow_Right_Gray.Enabled := False;
      mainScene.Config.main.R.addons.Right_Num.Visible := True;
      mainScene.Config.main.R.addons.Right_Num.Text := (ex_main.Config.Addons_Tab_Last - 2).ToString;
    end;
    mainScene.Config.main.R.addons.Left_Num.Text := ex_main.Config.Addons_Tab_First.ToString;
    uMain_Config_Addons.Icons_Free;
    uMain_Config_Addons.Icons(ex_main.Config.Addons_Tab_First);
    if ex_main.Config.Addons_Active_Tab <> -1 then
    begin
      if ex_main.Config.Addons_Active_Tab = user_Active_Local.addons.Active then
        FreeAndNil(mainScene.Config.main.R.addons.Icons_Panel[user_Active_Local.addons.Active])
      else
        uMain_Config_Addons.ShowInfo(ex_main.Config.Addons_Active_Tab);
    end;
  end;
end;

procedure RightArrow;
begin
  if mainScene.Config.main.R.addons.Arrow_Right_Gray.Enabled = False then
  begin
    Inc(ex_main.Config.Addons_Tab_First);
    Inc(ex_main.Config.Addons_Tab_Last);
    if ex_main.Config.Addons_Tab_First > 0 then
    begin
      mainScene.Config.main.R.addons.Left_Num.Visible := True;
      mainScene.Config.main.R.addons.Left_Num.Text := ex_main.Config.Addons_Tab_First.ToString;
      mainScene.Config.main.R.addons.Arrow_Left_Gray.Enabled := False;
    end;
    if ex_main.Config.Addons_Tab_Last = user_Active_Local.addons.Active then
    begin
      mainScene.Config.main.R.addons.Arrow_Right_Gray.Enabled := True;
      mainScene.Config.main.R.addons.Right_Num.Visible := False;
      mainScene.Config.main.R.addons.Right_Num.Text := '0';
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
end;

/// ///////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure uMain_Config_Addons_Actions_Activate_Soundplayer_FreshStart(vFresh: Boolean);
begin
  Inc(addons.Active_Num, 1);
  addons.soundplayer.Active := True;
  addons.soundplayer.Main_Menu_Position := addons.Active_Num;
  extrafe.ini.ini.WriteInteger('Addons', 'Active_Num', addons.Active_Num);
  addons.soundplayer.ini.ini.WriteString('SOUNDPLAYER', 'Addon_Name', 'soundplayer');
  addons.soundplayer.ini.ini.WriteBool('SOUNDPLAYER', 'Active', True);
  addons.soundplayer.ini.ini.WriteInteger('SOUNDPLAYER', 'Menu_Position', addons.soundplayer.Main_Menu_Position);
  addons.Active_PosNames[addons.soundplayer.Main_Menu_Position] := 'soundplayer';
  mainScene.Config.main.R.addons.Icons_Info[3].Activeted.Text := 'Active';
  mainScene.Config.main.R.addons.Icons_Info[3].Activeted.Color := TAlphaColorRec.Lime;
  mainScene.Config.main.R.addons.Icons_Info[3].Action.Text := 'Deactivate';
  addons.Active_PosNames[addons.soundplayer.Main_Menu_Position] := 'soundplayer';
  // mainScene.Header.Addon_Icons[addons.soundplayer.Main_Menu_Position].Bitmap.LoadFromFile(addons.soundplayer.Path.Icon + 'addons_soundplayer_icon.png');
  if vFresh then
  begin
    addons.soundplayer.ini.ini.WriteBool('General', 'First', False);
    addons.soundplayer.ini.ini.WriteInteger('Playlists', 'TotalPlaylists', -1);
    addons.soundplayer.ini.ini.WriteInteger('Playlists', 'ActivePlaylist', -1);
    addons.soundplayer.ini.ini.WriteString('Playlists', 'ActivePlaylistName', '');
    addons.soundplayer.ini.ini.WriteInteger('Song', 'LastPlayed', -1);
    addons.soundplayer.ini.ini.WriteString('Volume', 'State', 'Master');
    addons.soundplayer.ini.ini.WriteInteger('Volume', 'Master', 1);
    addons.soundplayer.ini.ini.WriteInteger('Volume', 'Left', 1);
    addons.soundplayer.ini.ini.WriteInteger('Volume', 'Right', 1);
  end;

  addons.soundplayer.Name := addons.soundplayer.ini.ini.ReadString('SOUNDPLAYER', 'Addon_Name', addons.soundplayer.Name);
  addons.soundplayer.Active := addons.soundplayer.ini.ini.ReadBool('SOUNDPLAYER', 'Active', addons.soundplayer.Active);
  addons.soundplayer.Main_Menu_Position := addons.soundplayer.ini.ini.ReadInteger('SOUNDPLAYER', 'Menu_Position', addons.soundplayer.Main_Menu_Position);
  addons.soundplayer.Path.Icon := addons.soundplayer.ini.Path + 'icon\';
  addons.soundplayer.Path.Images := addons.soundplayer.ini.Path + 'images\';
  addons.soundplayer.Path.Files := addons.soundplayer.ini.Path + 'files\';
  addons.soundplayer.Path.Playlists := addons.soundplayer.ini.Path + 'playlists\';

  addons.soundplayer.Actions.First := addons.soundplayer.ini.ini.ReadBool('General', 'First', addons.soundplayer.Actions.First);

  addons.soundplayer.Playlist.Total := addons.soundplayer.ini.ini.ReadInteger('Playlists', 'TotalPlaylists', addons.soundplayer.Playlist.Total);
  addons.soundplayer.Playlist.Active := addons.soundplayer.ini.ini.ReadInteger('Playlists', 'ActivePlaylist', addons.soundplayer.Playlist.Active);
  addons.soundplayer.Playlist.List.Name := addons.soundplayer.ini.ini.ReadString('Playlists', 'ActivePlaylistName', addons.soundplayer.Playlist.List.Name);
  addons.soundplayer.Player.LastPlayed := addons.soundplayer.ini.ini.ReadInteger('Song', 'LastPlayed', addons.soundplayer.Player.LastPlayed);
  addons.soundplayer.Volume.State := addons.soundplayer.ini.ini.ReadString('Volume', 'State', addons.soundplayer.Volume.State);
  addons.soundplayer.Volume.Master := addons.soundplayer.ini.ini.ReadFloat('Volume', 'Master', addons.soundplayer.Volume.Master);
  addons.soundplayer.Volume.Left := addons.soundplayer.ini.ini.ReadFloat('Volume', 'Left', addons.soundplayer.Volume.Left);
  addons.soundplayer.Volume.Right := addons.soundplayer.ini.ini.ReadFloat('Volume', 'Right', addons.soundplayer.Volume.Right);
end;

procedure uMain_Config_Addons_Actions_Activate_Soundplayer_Action;
begin
  if mainScene.Config.main.R.addons.soundplayer.Msg_Actv.main.Radio_2.IsChecked then
  begin
    uWindows_DeleteDirectory(addons.soundplayer.Path.Playlists, '*.*', False);
    uMain_Config_Addons_Actions_Activate_Soundplayer_FreshStart(True)
  end
  else
    uMain_Config_Addons_Actions_Activate_Soundplayer_FreshStart(False);
  uMain_Config_Addons_Actions_Activate_Soundplayer_FreeMessage;
end;

procedure uMain_Config_Addons_Actions_Activate_Soundplayer_ShowMessage;
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

procedure uMain_Config_Addons_Actions_Activate_Soundplayer_FreeMessage;
begin
  extrafe.prog.State := 'main_config';
  mainScene.Config.main.Left_Blur.Enabled := False;
  mainScene.Config.main.R.addons.Panel_Blur.Enabled := False;
  FreeAndNil(mainScene.Config.main.R.addons.soundplayer.Msg_Actv.Panel);
end;

procedure uMain_Config_Addons_Actions_Activate_Soundplayer;
begin
  if FileExists(addons.soundplayer.ini.Path + addons.soundplayer.ini.Name) then
    uMain_Config_Addons_Actions_Activate_Soundplayer_ShowMessage
  else
    uMain_Config_Addons_Actions_Activate_Soundplayer_FreshStart(True);
end;

procedure uMain_Config_Addons_Actions_Deactivate_Soundplayer;
begin
  if FileExists(addons.soundplayer.ini.Path + addons.soundplayer.ini.Name) then
    uMain_Config_Addons_Actions_Deactivate_Soundplayer_ShowMessage
end;

procedure uMain_Config_Addons_Actions_Deactivate_Soundplayer_Action;
begin
  if addons.Active_Num = addons.soundplayer.Main_Menu_Position then
  begin
    // mainScene.Header.Addon_Icons[addons.Active_Num].Bitmap := nil;
    addons.Active_PosNames[addons.soundplayer.Main_Menu_Position] := '';
  end
  else
    uMain_Config_Addons_Actions_SetIconsToRightPosition(addons.soundplayer.Main_Menu_Position);
  Dec(addons.Active_Num, 1);
  addons.soundplayer.Active := False;
  addons.soundplayer.Main_Menu_Position := -1;
  extrafe.ini.ini.WriteInteger('Addons', 'Active_Num', addons.Active_Num);
  addons.soundplayer.ini.ini.WriteBool('SOUNDPLAYER', 'Active', addons.weather.Active);
  addons.soundplayer.ini.ini.WriteInteger('SOUNDPLAYER', 'Menu_Position', addons.weather.Main_Menu_Position);
  mainScene.Config.main.R.addons.Icons_Info[3].Activeted.Text := 'Inactive';
  mainScene.Config.main.R.addons.Icons_Info[3].Activeted.Color := TAlphaColorRec.Red;
  mainScene.Config.main.R.addons.Icons_Info[3].Action.Text := 'Activate';
  if mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.main.Radio_2.IsChecked then
  begin
    DeleteFile(addons.soundplayer.ini.Path + addons.soundplayer.ini.Name);
    uWindows_DeleteDirectory(addons.soundplayer.Path.Playlists, '*.*', False);
  end;
  if addons.soundplayer.Player.play then
  begin
    BASS_ChannelStop(sound.str_music[1]);
    BASS_StreamFree(sound.str_music[1]);
  end;
  uMain_Config_Addons_Actions_Deactivate_Soundplayer_FreeMessage;
end;

procedure uMain_Config_Addons_Actions_Deactivate_Soundplayer_ShowMessage;
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

procedure uMain_Config_Addons_Actions_Deactivate_Soundplayer_FreeMessage;
begin
  extrafe.prog.State := 'main_config';
  mainScene.Config.main.Left_Blur.Enabled := False;
  mainScene.Config.main.R.addons.Panel_Blur.Enabled := False;
  FreeAndNil(mainScene.Config.main.R.addons.soundplayer.Msg_Deactv.Panel);
end;

/// /////////////////////////////////////////////////////////////////////////////
procedure Activate_Weather_ShowMessage;
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

procedure Activate_Weather_FreeMessage;
begin
  extrafe.prog.State := 'main_config';
  mainScene.Config.main.Left_Blur.Enabled := False;
  mainScene.Config.main.R.addons.Panel_Blur.Enabled := False;
  FreeAndNil(mainScene.Config.main.R.addons.weather.Msg_Actv.Panel)
end;

procedure Activate_Weather_FreshStart(vFresh: Boolean);
var
  vQuery: String;
  vUser_Exists: Boolean;
begin
  Inc(user_Active_Local.addons.Active, 1);
  user_Active_Local.addons.weather := True;
  user_Active_Local.addons.Weather_D.Menu_Position := user_Active_Local.addons.Active;
  user_Active_Local.addons.Weather_D.First_Pop := True;
  if vFresh then
    user_Active_Local.addons.Weather_D.Old_Backup := True;
  user_Active_Local.addons.Weather_D.Provider_Count := 1;
  user_Active_Local.addons.Weather_D.Yahoo.Iconset_Count := 3;
  user_Active_Local.addons.Weather_D.Yahoo.Iconset := 'default';
  user_Active_Local.addons.Weather_D.Yahoo.Towns_Count := -1;
  user_Active_Local.addons.Weather_D.Yahoo.System := 'imperial';
  user_Active_Local.addons.Weather_D.Yahoo.Degree := 'celcius';
  user_Active_Local.addons.Weather_D.OpenWeatherMap.Iconset_Count := 1;
  user_Active_Local.addons.Weather_D.OpenWeatherMap.Iconset := 'default';
  user_Active_Local.addons.Weather_D.OpenWeatherMap.Towns_Count := -1;
  user_Active_Local.addons.Weather_D.OpenWeatherMap.System := 'imperial';
  user_Active_Local.addons.Weather_D.OpenWeatherMap.Degree := 'celcius';
  user_Active_Local.addons.Weather_D.OpenWeatherMap.API := '';
  user_Active_Local.addons.Weather_D.OpenWeatherMap.Language := 'english';

  uDatabase_SQLCommands.Update_Local_Query('ADDONS', 'ACTIVE', user_Active_Local.addons.Active.ToString, user_Active_Local.Num.ToString);
  uDatabase_SQLCommands.Update_Local_Query('ADDONS', 'WEATHER', '1', user_Active_Local.Num.ToString);
  uDatabase_SQLCommands.Update_Local_Query('ADDON_WEATHER', 'MENU_POSITION', user_Active_Local.addons.Weather_D.Menu_Position.ToString,
    user_Active_Local.Num.ToString);
  uDatabase_SQLCommands.Update_Local_Query('ADDON_WEATHER', 'FIRST_POP', user_Active_Local.addons.Weather_D.First_Pop.ToInteger.ToString,
    user_Active_Local.Num.ToString);
  uDatabase_SQLCommands.Update_Local_Query('ADDON_WEATHER', 'OLD_BACKUP', user_Active_Local.addons.Weather_D.Old_Backup.ToInteger.ToString,
    user_Active_Local.Num.ToString);
  uDatabase_SQLCommands.Update_Local_Query('ADDON_WEATHER', 'PROVIDER_COUNT', user_Active_Local.addons.Weather_D.Provider_Count.ToString,
    user_Active_Local.Num.ToString);
  uDatabase_SQLCommands.Update_Local_Query('ADDON_WEATHER', 'PROVIDER', user_Active_Local.addons.Weather_D.Provider, user_Active_Local.Num.ToString);
  uDatabase_SQLCommands.Update_Local_Query('ADDON_WEATHER', 'YAHOO_ICONSET_COUNT', user_Active_Local.addons.Weather_D.Yahoo.Iconset_Count.ToString,
    user_Active_Local.Num.ToString);
  uDatabase_SQLCommands.Update_Local_Query('ADDON_WEATHER', 'YAHOO_ICONSET', user_Active_Local.addons.Weather_D.Yahoo.Iconset, user_Active_Local.Num.ToString);
  uDatabase_SQLCommands.Update_Local_Query('ADDON_WEATHER', 'YAHOO_TOWNS', user_Active_Local.addons.Weather_D.Yahoo.Towns_Count.ToString,
    user_Active_Local.Num.ToString);
  uDatabase_SQLCommands.Update_Local_Query('ADDON_WEATHER', 'YAHOO_SYSTEM', user_Active_Local.addons.Weather_D.Yahoo.System, user_Active_Local.Num.ToString);
  uDatabase_SQLCommands.Update_Local_Query('ADDON_WEATHER', 'YAHOO_DEGREE_TYPE', user_Active_Local.addons.Weather_D.Yahoo.Degree,
    user_Active_Local.Num.ToString);
  uDatabase_SQLCommands.Update_Local_Query('ADDON_WEATHER', 'OWM_ICONSET_COUNT', user_Active_Local.addons.Weather_D.OpenWeatherMap.Iconset_Count.ToString,
    user_Active_Local.Num.ToString);
  uDatabase_SQLCommands.Update_Local_Query('ADDON_WEATHER', 'OWM_ICONSET', user_Active_Local.addons.Weather_D.OpenWeatherMap.Iconset,
    user_Active_Local.Num.ToString);
  uDatabase_SQLCommands.Update_Local_Query('ADDON_WEATHER', 'OWM_TOWNS', user_Active_Local.addons.Weather_D.OpenWeatherMap.Towns_Count.ToString,
    user_Active_Local.Num.ToString);
  uDatabase_SQLCommands.Update_Local_Query('ADDON_WEATHER', 'OWM_SYSTEM', user_Active_Local.addons.Weather_D.OpenWeatherMap.System,
    user_Active_Local.Num.ToString);
  uDatabase_SQLCommands.Update_Local_Query('ADDON_WEATHER', 'OWM_DEGREE_TYPE', user_Active_Local.addons.Weather_D.OpenWeatherMap.Degree,
    user_Active_Local.Num.ToString);
  uDatabase_SQLCommands.Update_Local_Query('ADDON_WEATHER', 'OWM_APIKEY', user_Active_Local.addons.Weather_D.OpenWeatherMap.API,
    user_Active_Local.Num.ToString);
  uDatabase_SQLCommands.Update_Local_Query('ADDON_WEATHER', 'OWM_LANGUAGE', user_Active_Local.addons.Weather_D.OpenWeatherMap.Language,
    user_Active_Local.Num.ToString);


  mainScene.Config.main.R.addons.Icons_Info[2].Activeted.Text := 'Active';
  mainScene.Config.main.R.addons.Icons_Info[2].Activeted.Color := TAlphaColorRec.Lime;
  mainScene.Config.main.R.addons.Icons_Info[2].Action.Text := 'Deactivate';
end;

procedure Activate_Weather_Action;
begin
  if mainScene.Config.main.R.addons.weather.Msg_Actv.main.Radio_2.IsChecked then
    Activate_Weather_FreshStart(True)
  else
    Activate_Weather_FreshStart(False);
  Activate_Weather_FreeMessage;
end;

procedure Activate_Weather;
begin
  if user_Active_Local.addons.Weather_D.Old_Backup then
    Activate_Weather_ShowMessage
  else
    Activate_Weather_FreshStart(True);
end;

procedure uMain_Config_Addons_Actions_Deactivate_Weather_ShowMessage;
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

procedure uMain_Config_Addons_Actions_Deactivate_Weather_Action;
begin
  if addons.Active_Num = addons.weather.Main_Menu_Position then
  begin
    // mainScene.Header.Addon_Icons[addons.Active_Num].Bitmap := nil;
    addons.Active_PosNames[addons.weather.Main_Menu_Position] := '';
  end
  else
    uMain_Config_Addons_Actions_SetIconsToRightPosition(addons.weather.Main_Menu_Position);

  Dec(addons.Active_Num, 1);
  addons.weather.Active := False;
  addons.weather.Main_Menu_Position := -1;
  extrafe.ini.ini.WriteInteger('Addons', 'Active_Num', addons.Active_Num);
  addons.weather.ini.ini.WriteBool('WEATHER', 'Active', addons.weather.Active);
  addons.weather.ini.ini.WriteInteger('WEATHER', 'Menu_Position', addons.weather.Main_Menu_Position);
  mainScene.Config.main.R.addons.Icons_Info[2].Activeted.Text := 'Inactive';
  mainScene.Config.main.R.addons.Icons_Info[2].Activeted.Color := TAlphaColorRec.Red;
  mainScene.Config.main.R.addons.Icons_Info[2].Action.Text := 'Activate';

  if mainScene.Config.main.R.addons.weather.Msg_Deactv.main.Radio_2.IsChecked then
  begin
    DeleteFile(addons.weather.ini.Path + addons.weather.ini.Name);
  end;
  uMain_Config_Addons_Actions_Deactivate_Weather_FreeMessage;
end;

procedure uMain_Config_Addons_Actions_Deactivate_Weather;
begin
  if FileExists(addons.weather.ini.Path + addons.weather.ini.Name) then
    uMain_Config_Addons_Actions_Deactivate_Weather_ShowMessage;
end;

procedure uMain_Config_Addons_Actions_Deactivate_Weather_FreeMessage;
begin
  extrafe.prog.State := 'main_config';
  mainScene.Config.main.Left_Blur.Enabled := False;
  mainScene.Config.main.R.addons.Panel_Blur.Enabled := False;
  FreeAndNil(mainScene.Config.main.R.addons.weather.Msg_Deactv.Panel);
end;

///
procedure uMain_Config_Addons_Actions_Activate_Play_FreshStart(vFresh: Boolean);
begin
  Inc(addons.Active_Num, 1);
  addons.play.Active := True;
  addons.play.Main_Menu_Position := addons.Active_Num;
  extrafe.ini.ini.WriteInteger('Addons', 'Active_Num', addons.Active_Num);
  addons.play.ini.ini.WriteString('PLAY', 'Addon_Name', 'play');
  addons.play.ini.ini.WriteBool('PLAY', 'Active', True);
  addons.play.ini.ini.WriteInteger('PLAY', 'Menu_Position', addons.play.Main_Menu_Position);

  mainScene.Config.main.R.addons.Icons_Info[4].Activeted.Text := 'Active';
  mainScene.Config.main.R.addons.Icons_Info[4].Activeted.Color := TAlphaColorRec.Lime;
  mainScene.Config.main.R.addons.Icons_Info[4].Action.Text := 'Deactivate';
  addons.Active_PosNames[addons.play.Main_Menu_Position] := 'play';
  // mainScene.Header.Addon_Icons[addons.play.Main_Menu_Position].Bitmap.LoadFromFile(addons.play.Path.Icon + 'addons_play_icon.png');
  if vFresh then
  begin
    { addons.weather.ini.ini.WriteBool('General', 'First', False);
      addons.weather.ini.ini.WriteInteger('Active', 'Active_Woeid', -1);
      addons.weather.ini.ini.WriteInteger('Active', 'Active_Total', -1);
      addons.weather.ini.ini.WriteString('Options', 'Degree', 'Celcius');
      addons.weather.ini.ini.WriteInteger('Options', 'Refresh', 0);
      addons.weather.ini.ini.WriteInteger('Iconset', 'Count', 2);
      addons.weather.ini.ini.WriteString('Iconset', 'Name', 'pengui');
      addons.weather.ini.ini.WriteString('Provider', 'Name', '');

      addons.weather.Action.First := False;
      addons.weather.Action.Active_WEOID := -1;
      addons.weather.Action.Active_Total := -1;
      addons.weather.Action.Degree := 'Celcius';
      addons.weather.Config.Refresh_Once := False;
      addons.weather.Config.Iconset.Name := 'pengui';
      addons.weather.Action.Provider := ''; }
  end
  else
  begin
    { addons.weather.Action.First := addons.weather.ini.ini.ReadBool('General', 'First',
      addons.weather.Action.First);
      addons.weather.Action.Provider := addons.weather.ini.ini.ReadString('Provider', 'Name',
      addons.weather.Action.Provider);
      addons.weather.Action.Active_WEOID := addons.weather.ini.ini.ReadInteger('Provider', 'Active_Woeid',
      addons.weather.Action.Active_WEOID);
      addons.weather.Action.Active_Total := addons.weather.ini.ini.ReadInteger('Active', 'Active_Total',
      addons.weather.Action.Active_Total);
      addons.weather.Action.Degree := addons.weather.ini.ini.ReadString('Options', 'Degree',
      addons.weather.Action.Degree);
      addons.weather.Config.Refresh_Once := addons.weather.ini.ini.ReadBool('Options', 'Refresh',
      addons.weather.Config.Refresh_Once);
      addons.weather.Config.Iconset.Name := addons.weather.ini.ini.ReadString('Iconset', 'Name',
      addons.weather.Config.Iconset.Name); }
  end;
end;

procedure uMain_Config_Addons_Actions_Activate_Play_FreeMessage;
begin
  extrafe.prog.State := 'main_config';
  mainScene.Config.main.Left_Blur.Enabled := False;
  mainScene.Config.main.R.addons.Panel_Blur.Enabled := False;
end;

procedure uMain_Config_Addons_Actions_Activate_Play;
begin
  { extrafe.prog.State := 'main_config_addons_actions';
    mainScene.Config.main.Left_Blur.Enabled := True;
    mainScene.Config.main.R.addons.Panel_Blur.Enabled := True; }

  uMain_Config_Addons_Actions_Activate_Play_FreshStart(True);
end;

procedure uMain_Config_Addons_Actions_Deactivate_Play;
begin

end;

/// /////////////////////////////////////////////////////////////////////////////

procedure uMain_Config_Addons_Actions_AddonActivation(vAddonNum: integer);
begin
  if vAddonNum = 2 then
  begin
    case addons.weather.Active of
      True:
        uMain_Config_Addons_Actions_Deactivate_Weather;
      False:
        Activate_Weather;
    end;
  end
  else if vAddonNum = 3 then
  begin
    case addons.soundplayer.Active of
      True:
        uMain_Config_Addons_Actions_Deactivate_Soundplayer;
      False:
        uMain_Config_Addons_Actions_Activate_Soundplayer;
    end;
  end
  else if vAddonNum = 4 then
  begin
    case addons.play.Active of
      True:
        uMain_Config_Addons_Actions_Deactivate_Play;
      False:
        uMain_Config_Addons_Actions_Activate_Play;
    end;
  end;
end;

end.