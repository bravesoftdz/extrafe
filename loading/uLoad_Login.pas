unit uLoad_Login;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UiTypes,
  System.DateUtils,
  System.JSON,
  FMX.Listbox,
  FMX.Forms,
  FMX.Types,
  IdExplicitTLSClientServerBase,
  IdSMTP,
  IdSSLOpenSSL,
  IdMessage,
  IdGlobal,
  Rest.Types,
  BASS;

procedure Login;
procedure Exit_Program;

procedure Change_User(vUser_Num: Integer);

procedure Update_Password(vValue: String);

procedure Show_Password;
procedure CapsLock(vActive: Boolean);

implementation

uses
  load,
  uWindows,
  uLoad,
  uLoad_AllTypes,
  uLoad_SetAll,
  uDB,
  uDB_AUser,
  uInternet_Files;

var
  vPassword_Count: Integer;

procedure Login;
begin
  ex_load.Scene.Progress.Visible := True;
  ex_load.Scene.Progress_Text.Visible := True;
  if (ex_load.Login.User_V.Items.Strings[ex_load.Login.User_V.ItemIndex] = uDB_AUser.Local.USER.Username) and (ex_load.Login.Pass_V.Text = uDB_AUser.Local.USER.Password) then
    uLoad.Start_ExtraFE
  else
  begin
    if (ex_load.Login.User_V.Items.Strings[ex_load.Login.User_V.ItemIndex] = uDB_AUser.Local.USER.Username) then
      ex_load.Login.Warning.Text := 'Password is incorrect';
    ex_load.Login.Warning.Visible := True;
    ex_load.Login.Forget_Pass.Visible := True;
    ex_load.Login.Panel_Login_Error.Start;
    BASS_ChannelStop(sound.str_fx.general[0]);
    BASS_ChannelSetPosition(sound.str_fx.general[0], 0, 0);
    BASS_ChannelPlay(sound.str_fx.general[1], false);
  end;
end;

procedure Exit_Program;
begin
  if extrafe.databases.online_connected then
  begin
    uDB.ExtraFE_DB.Disconnect;
    FreeAndNil(uDB.ExtraFE_DB);
  end;
  uDB.ExtraFE_DB_Local.Connected := false;
  FreeAndNil(uDB.ExtraFE_DB_Local);
  Application.Terminate;
end;

procedure Show_Password;
begin
  if ex_load.Login.Pass_V.Password then
  begin
    ex_load.Login.Pass_Show.Text := #$e9ce;
    ex_load.Login.Pass_Show.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    BASS_ChannelStop(sound.str_fx.general[5]);
    BASS_ChannelSetPosition(sound.str_fx.general[5], 0, 0);
    BASS_ChannelPlay(sound.str_fx.general[4], false);
  end
  else
  begin
    ex_load.Login.Pass_Show.Text := #$e9d1;
    ex_load.Login.Pass_Show.TextSettings.FontColor := TAlphaColorRec.Blueviolet;
    BASS_ChannelStop(sound.str_fx.general[4]);
    BASS_ChannelSetPosition(sound.str_fx.general[4], 0, 0);
    BASS_ChannelPlay(sound.str_fx.general[5], false);
  end;
  ex_load.Login.Pass_V.Password := not ex_load.Login.Pass_V.Password;
end;

procedure CapsLock(vActive: Boolean);
begin
  vActive := not vActive;
  if vActive then
  begin
    ex_load.Login.CapsLock_Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    ex_load.Login.CapsLock_Icon.Font.Size := 36;
    ex_load.Login.CapsLock.Text := 'Caps lock is Active';
  end
  else
  begin
    ex_load.Login.CapsLock_Icon.TextSettings.FontColor := TAlphaColorRec.Grey;
    ex_load.Login.CapsLock_Icon.Font.Size := 24;
    ex_load.Login.CapsLock.Text := 'Caps lock is Inactive';
  end;
  ex_load.Login.CapsLock_Icon.Locked := vActive;
end;

procedure Update_Password(vValue: String);
begin
  vPassword_Count := Length(vValue);

  if ex_load.Login.Warning.Visible then
  begin
    ex_load.Login.Warning.Visible := false;
    ex_load.Login.Forget_Pass.Visible := false;
  end;

  if vPassword_Count > 0 then
  begin
    if ex_load.Login.Pass_V.Password then
      ex_load.Login.Pass_Show.TextSettings.FontColor := TAlphaColorRec.Blueviolet
    else
      ex_load.Login.Pass_Show.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  end
  else
    ex_load.Login.Pass_Show.TextSettings.FontColor := TAlphaColorRec.Grey;

end;

procedure Change_User(vUser_Num: Integer);
begin
  if extrafe.databases.online_connected then
  begin
    if vUser_Num <> 0 then
    begin
      uDB_AUser.Get_Local_Data((vUser_Num).ToString);
      ex_load.Login.Avatar.Bitmap.LoadFromFile(ex_main.Paths.Avatar_Images + uDB_AUser.Local.USER.Avatar + '.png');
      ex_load.Login.Last_Visit.Text := 'Last Visit : ' + uDB_AUser.Local.USER.Last_Visit;
      uDB_AUser.Get_Online_Data(uDB_AUser.Local.USER.Unique_ID);
    end
    else
    begin
      ex_load.Login.Avatar.Bitmap.LoadFromFile(ex_main.Paths.Avatar_Images + '0.png');
      ex_load.Login.Last_Visit.Text := 'Last Visit : --/--/--';
    end
  end
  else
  begin
    // Exception (if not connectet to internet or online database)
  end;
end;

end.
