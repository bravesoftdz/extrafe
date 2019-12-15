﻿unit uLoad_SetAll;

interface

uses
  System.Classes,
  System.UiTypes,
  System.SysUtils,
  Winapi.Windows,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Effects,
  FMX.Ani,
  FMX.Types,
  FMX.Edit,
  FMX.Memo,
  FMX.Filter.Effects,
  FMX.ListBox,
  FMX.Layouts,
  CodeSiteLogging;

type
  TLOGIN_USER = record
    Username: String;
    Password: String;
    Avatar: String;
    Last_Visit: String;
  end;

procedure Load;
procedure Login;
procedure Login_Forget_Password;
procedure Register_Form;
procedure Register_Terms;
procedure Register_Error;
procedure Register_Success;

var
  vLogin_User: array of TLOGIN_USER;
  vListBox_Item: array of TListBoxItem;

implementation

uses
  Load,
  uDB,
  uDB_AUser,
  uWindows,
  uLoad_Login,
  uLoad_AllTypes,
  uLoad_Register;

procedure Load;
begin
  // Back
  ex_load.Scene.Back_Back := TImage.Create(Load.Loading);
  ex_load.Scene.Back_Back.Name := 'Loading_Back_Back';
  ex_load.Scene.Back_Back.Parent := Load.Loading;
  ex_load.Scene.Back_Back.SetBounds(0, 0, extrafe.res.Width, extrafe.res.Height);
  ex_load.Scene.Back_Back.Bitmap.LoadFromFile(ex_load.Path.Images + 'load.png');
  ex_load.Scene.Back_Back.WrapMode := TImageWrapMode.Fit;
  ex_load.Scene.Back_Back.Visible := True;

  ex_load.Scene.Back := TImage.Create(Load.Loading);
  ex_load.Scene.Back.Name := 'Loading_Back';
  ex_load.Scene.Back.Parent := Load.Loading;
  ex_load.Scene.Back.SetBounds(0, 0, extrafe.res.Width, extrafe.res.Height);
  ex_load.Scene.Back.Bitmap.LoadFromFile(ex_load.Path.Images + 'load.png');
  ex_load.Scene.Back.WrapMode := TImageWrapMode.Fit;
  ex_load.Scene.Back.Visible := True;

  ex_load.Scene.Back_Fade := TFloatAnimation.Create(ex_load.Scene.Back);
  ex_load.Scene.Back_Fade.Name := 'Loading_FadeOut';
  ex_load.Scene.Back_Fade.Parent := ex_load.Scene.Back;
  ex_load.Scene.Back_Fade.PropertyName := 'Opacity';
  ex_load.Scene.Back_Fade.StartValue := 1;
  ex_load.Scene.Back_Fade.StopValue := 0.1;
  ex_load.Scene.Back_Fade.Duration := 1.8;
  ex_load.Scene.Back_Fade.OnFinish := ex_load.Scene.Back_Fade_Float.OnFinish;
  ex_load.Scene.Back_Fade.Enabled := False;

  ex_load.Scene.Logo := TImage.Create(ex_load.Scene.Back);
  ex_load.Scene.Logo.Name := 'Loading_Logo';
  ex_load.Scene.Logo.Parent := ex_load.Scene.Back;
  ex_load.Scene.Logo.SetBounds(0, 0, 530, 340);
  ex_load.Scene.Logo.Bitmap.LoadFromFile(ex_load.Path.Images + 'logo.png');
  ex_load.Scene.Logo.WrapMode := TImageWrapMode.Fit;
  ex_load.Scene.Logo.Visible := True;

  ex_load.Scene.Logo_Shadow := TShadowEffect.Create(ex_load.Scene.Logo);
  ex_load.Scene.Logo_Shadow.Name := 'Loading_Logo_Shadow';
  ex_load.Scene.Logo_Shadow.Parent := ex_load.Scene.Logo;
  ex_load.Scene.Logo_Shadow.ShadowColor := TAlphaColorRec.Deepskyblue;
  ex_load.Scene.Logo_Shadow.Direction := 90;
  ex_load.Scene.Logo_Shadow.Opacity := 0.7;
  ex_load.Scene.Logo_Shadow.Enabled := True;

  ex_load.Scene.Progress := TProgressBar.Create(ex_load.Scene.Back);
  ex_load.Scene.Progress.Name := 'Loading_Progress_Bar';
  ex_load.Scene.Progress.Parent := ex_load.Scene.Back;
  ex_load.Scene.Progress.SetBounds(20, ex_load.Scene.Back.Height - 50, ex_load.Scene.Back.Width - 40, 30);
  ex_load.Scene.Progress.Width := ex_load.Scene.Back.Width - 40;
  ex_load.Scene.Progress.Min := 0;
  ex_load.Scene.Progress.Max := 100;
  ex_load.Scene.Progress.Value := 0;
  ex_load.Scene.Progress.Visible := False;

  ex_load.Scene.Progress_Text := TLabel.Create(ex_load.Scene.Back);
  ex_load.Scene.Progress_Text.Name := 'Loading_Progress_Text';
  ex_load.Scene.Progress_Text.Parent := ex_load.Scene.Back;
  ex_load.Scene.Progress_Text.SetBounds(20, ex_load.Scene.Back.Height - 74, 1000, 22);
  ex_load.Scene.Progress_Text.StyledSettings := ex_load.Scene.Progress_Text.StyledSettings - [TStyledSetting.Size];
  ex_load.Scene.Progress_Text.Font.Size := 18;
  ex_load.Scene.Progress_Text.Text := 'Waiting for Login.';
  ex_load.Scene.Progress_Text.Visible := False;

  ex_load.Scene.Code_Name := TText.Create(ex_load.Scene.Back);
  ex_load.Scene.Code_Name.Name := 'Loading_Code_Name';
  ex_load.Scene.Code_Name.Parent := ex_load.Scene.Back;
  ex_load.Scene.Code_Name.SetBounds(extrafe.res.Width - 240, 90, 161, 26);
  ex_load.Scene.Code_Name.TextSettings.FontColor := TAlphaColorRec.White;
  ex_load.Scene.Code_Name.Text := extrafe.prog.Desc;
  ex_load.Scene.Code_Name.TextSettings.Font.Style := ex_load.Scene.Code_Name.TextSettings.Font.Style + [TFontstyle.fsBold];
  ex_load.Scene.Code_Name.RotationAngle := 38;
  ex_load.Scene.Code_Name.TextSettings.Font.Size := 16;
  ex_load.Scene.Code_Name.Visible := True;

  ex_load.Scene.Ver := TText.Create(ex_load.Scene.Back);
  ex_load.Scene.Ver.Name := 'Loading_Version';
  ex_load.Scene.Ver.Parent := ex_load.Scene.Back;
  ex_load.Scene.Ver.SetBounds(extrafe.res.Width - 350, 160, 260, 26);
  ex_load.Scene.Ver.TextSettings.FontColor := TAlphaColorRec.White;
  ex_load.Scene.Ver.Text := 'Version: ' + extrafe.prog.Version.Major + '.' + extrafe.prog.Version.Minor + '.' + extrafe.prog.Version.Realeash + ' build ' + extrafe.prog.Version.Build;
  ex_load.Scene.Ver.TextSettings.Font.Style := ex_load.Scene.Code_Name.TextSettings.Font.Style + [TFontstyle.fsBold];
  ex_load.Scene.Ver.RotationAngle := 38;
  ex_load.Scene.Ver.TextSettings.Font.Size := 16;
  ex_load.Scene.Ver.Visible := True;

  ex_load.Scene.Timer := TTimer.Create(Load.Loading);
  ex_load.Scene.Timer.Name := 'Loading_Timer';
  ex_load.Scene.Timer.Parent := Load.Loading;
  ex_load.Scene.Timer.Interval := 1000;
  ex_load.Scene.Timer.Enabled := False;

  Login;
end;

procedure Login;
var
  vkState: TKeyboardState;
  vi: Integer;
begin
  extrafe.prog.State := 'load_login';

  ex_load.Login.Panel := TPanel.Create(ex_load.Scene.Back);
  ex_load.Login.Panel.Name := 'Loading_Login';
  ex_load.Login.Panel.Parent := ex_load.Scene.Back;
  ex_load.Login.Panel.SetBounds(extrafe.res.Half_Width - 265, extrafe.res.Half_Height - 173, 530, 346);
  ex_load.Login.Panel.Opacity := 0.8;
  ex_load.Login.Panel.Visible := True;

  ex_load.Login.Panel_Login_Error := TFloatAnimation.Create(ex_load.Login.Panel);
  ex_load.Login.Panel_Login_Error.Name := 'Loading_Login_Ani_Error';
  ex_load.Login.Panel_Login_Error.Parent := ex_load.Login.Panel;
  ex_load.Login.Panel_Login_Error.PropertyName := 'Position.X';
  ex_load.Login.Panel_Login_Error.Duration := 0.3;
  ex_load.Login.Panel_Login_Error.Interpolation := TInterpolationType.Bounce;
  ex_load.Login.Panel_Login_Error.AnimationType := TAnimationType.&In;
  ex_load.Login.Panel_Login_Error.StartValue := ex_load.Login.Panel.Position.X - 40;
  ex_load.Login.Panel_Login_Error.StopValue := ex_load.Login.Panel.Position.X;
  ex_load.Login.Panel_Login_Error.Enabled := False;

  ex_load.Login.Panel_Login_Correct := TFloatAnimation.Create(ex_load.Login.Panel);
  ex_load.Login.Panel_Login_Correct.Name := 'Loading_Login_Ani_Correct';
  ex_load.Login.Panel_Login_Correct.Parent := ex_load.Login.Panel;
  ex_load.Login.Panel_Login_Correct.PropertyName := 'Opacity';
  ex_load.Login.Panel_Login_Correct.Duration := 0.2;
  ex_load.Login.Panel_Login_Correct.Interpolation := TInterpolationType.Linear;
  ex_load.Login.Panel_Login_Correct.AnimationType := TAnimationType.&In;
  ex_load.Login.Panel_Login_Correct.StartValue := 0.2;
  ex_load.Login.Panel_Login_Correct.Enabled := False;

  CreateHeader(ex_load.Login.Panel, 'IcoMoon-Free', #$e971, 'Login', False, nil);

  ex_load.Login.Main := TPanel.Create(ex_load.Login.Panel);
  ex_load.Login.Main.Name := 'Loading_Main';
  ex_load.Login.Main.Parent := ex_load.Login.Panel;
  ex_load.Login.Main.SetBounds(0, 30, ex_load.Login.Panel.Width, ex_load.Login.Panel.Height - 30);
  ex_load.Login.Main.Visible := True;

  ex_load.Login.Last_Visit := TLabel.Create(ex_load.Login.Main);
  ex_load.Login.Last_Visit.Name := 'Loading_Login_Last_Visit';
  ex_load.Login.Last_Visit.Parent := ex_load.Login.Main;
  ex_load.Login.Last_Visit.SetBounds(ex_load.Login.Main.Width - 210, -22, 200, 17);
  ex_load.Login.Last_Visit.TextSettings.HorzAlign := TTextAlign.Trailing;
  ex_load.Login.Last_Visit.Text := 'Last visit : ';
  ex_load.Login.Last_Visit.Visible := True;

  ex_load.Login.Avatar := TImage.Create(ex_load.Login.Main);
  ex_load.Login.Avatar.Name := 'Loading_Login_Avatar';
  ex_load.Login.Avatar.Parent := ex_load.Login.Main;
  ex_load.Login.Avatar.SetBounds(24, 28, 120, 120);
  ex_load.Login.Avatar.Bitmap.LoadFromFile(ex_main.Paths.Avatar_Images + '0.png');
  ex_load.Login.Avatar.WrapMode := TImageWrapMode.Fit;
  ex_load.Login.Avatar.Visible := True;

  ex_load.Login.Warning := TLabel.Create(ex_load.Login.Main);
  ex_load.Login.Warning.Name := 'Loading_Login_Warning';
  ex_load.Login.Warning.Parent := ex_load.Login.Main;
  ex_load.Login.Warning.SetBounds(ex_load.Login.Main.Width - 519, 8, 500, 22);
  ex_load.Login.Warning.TextSettings.FontColor := TAlphaColorRec.Red;
  ex_load.Login.Warning.Font.Size := 18;
  ex_load.Login.Warning.Text := 'OK ola kala';
  ex_load.Login.Warning.TextAlign := TTextAlign.Trailing;
  ex_load.Login.Warning.StyledSettings := ex_load.Login.Warning.StyledSettings - [TStyledSetting.FontColor, TStyledSetting.Size];
  ex_load.Login.Warning.Visible := False;

  ex_load.Login.User := TLabel.Create(ex_load.Login.Main);
  ex_load.Login.User.Name := 'Loading_Login_User';
  ex_load.Login.User.Parent := ex_load.Login.Main;
  ex_load.Login.User.SetBounds(182, 22, 200, 17);
  ex_load.Login.User.Text := 'Username :';
  ex_load.Login.User.Visible := True;

  ex_load.Login.User_V := TComboBox.Create(ex_load.Login.Main);
  ex_load.Login.User_V.Name := 'Loading_Login_User_V';
  ex_load.Login.User_V.Parent := ex_load.Login.Main;
  ex_load.Login.User_V.SetBounds(182, 40, 329, 36);
  ex_load.Login.User_V.OnChange := ex_load.Input.mouse.Combobox.OnChange;
  ex_load.Login.User_V.Visible := True;

  ex_load.Login.Pass := TLabel.Create(ex_load.Login.Main);
  ex_load.Login.Pass.Name := 'Loading_Login_Pass';
  ex_load.Login.Pass.Parent := ex_load.Login.Main;
  ex_load.Login.Pass.SetBounds(182, 94, 200, 17);
  ex_load.Login.Pass.Text := 'Password :';
  ex_load.Login.Pass.Visible := True;

  ex_load.Login.Forget_Pass := TText.Create(ex_load.Login.Main);
  ex_load.Login.Forget_Pass.Name := 'Loading_Login_Forget_Pass';
  ex_load.Login.Forget_Pass.Parent := ex_load.Login.Main;
  ex_load.Login.Forget_Pass.SetBounds(331, 94, 180, 17);
  ex_load.Login.Forget_Pass.Text := 'Forgot your password? Click here';
  ex_load.Login.Forget_Pass.TextSettings.FontColor := TAlphaColorRec.Red;
  ex_load.Login.Forget_Pass.TextSettings.HorzAlign := TTextAlign.Trailing;
  ex_load.Login.Forget_Pass.OnClick := ex_load.Input.mouse.Text.OnMouseClick;
  ex_load.Login.Forget_Pass.OnMouseEnter := ex_load.Input.mouse.Text.OnMouseEnter;
  ex_load.Login.Forget_Pass.OnMouseLeave := ex_load.Input.mouse.Text.OnMouseLeave;
  ex_load.Login.Forget_Pass.Visible := False;

  ex_load.Login.Pass_V := TEdit.Create(ex_load.Login.Main);
  ex_load.Login.Pass_V.Name := 'Loading_Login_Pass_V';
  ex_load.Login.Pass_V.Parent := ex_load.Login.Main;
  ex_load.Login.Pass_V.SetBounds(182, 112, 329, 36);
  ex_load.Login.Pass_V.HitTest := True;
  ex_load.Login.Pass_V.TextSettings.FontColor := TAlphaColorRec.White;
  ex_load.Login.Pass_V.TextSettings.Font.Size := 18;
  ex_load.Login.Pass_V.TextSettings.HorzAlign := TTextAlign.Leading;
  ex_load.Login.Pass_V.TextSettings.VertAlign := TTextAlign.Center;
  ex_load.Login.Pass_V.Password := True;
  ex_load.Login.Pass_V.Text := '';
  ex_load.Login.Pass_V.StyledSettings := ex_load.Login.Pass_V.StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Other];
  ex_load.Login.Pass_V.OnTyping := ex_load.Input.mouse.Edit.OnTyping;
  ex_load.Login.Pass_V.Visible := True;

  ex_load.Login.Pass_Show := TText.Create(ex_load.Login.Main);
  ex_load.Login.Pass_Show.Name := 'Loading_Login_Pass_Show';
  ex_load.Login.Pass_Show.Parent := ex_load.Login.Main;
  ex_load.Login.Pass_Show.SetBounds(473, 112, 36, 36);
  ex_load.Login.Pass_Show.Font.Family := 'IcoMoon-Free';
  ex_load.Login.Pass_Show.Font.Size := 24;
  ex_load.Login.Pass_Show.Text := #$e9d1;
  ex_load.Login.Pass_Show.TextSettings.FontColor := TAlphaColorRec.Grey;
  ex_load.Login.Pass_Show.TextSettings.HorzAlign := TTextAlign.Center;
  ex_load.Login.Pass_Show.OnClick := ex_load.Input.mouse.Text.OnMouseClick;
  ex_load.Login.Pass_Show.OnMouseEnter := ex_load.Input.mouse.Text.OnMouseEnter;
  ex_load.Login.Pass_Show.OnMouseLeave := ex_load.Input.mouse.Text.OnMouseLeave;
  ex_load.Login.Pass_Show.Visible := True;

  ex_load.Login.Pass_Show_Glow := TGlowEffect.Create(ex_load.Login.Pass_Show);
  ex_load.Login.Pass_Show_Glow.Name := 'Loading_Login_Pass_Show_Glow';
  ex_load.Login.Pass_Show_Glow.Parent := ex_load.Login.Pass_Show;
  ex_load.Login.Pass_Show_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  ex_load.Login.Pass_Show_Glow.Opacity := 0.9;
  ex_load.Login.Pass_Show_Glow.Enabled := False;

  ex_load.Login.Login := TButton.Create(ex_load.Login.Main);
  ex_load.Login.Login.Name := 'Loading_Login_Login';
  ex_load.Login.Login.Parent := ex_load.Login.Main;
  ex_load.Login.Login.SetBounds(330, 174, 180, 40);
  ex_load.Login.Login.Text := 'Login';
  ex_load.Login.Login.OnClick := ex_load.Input.mouse.Button.OnMouseClick;
  ex_load.Login.Login.OnMouseEnter := ex_load.Input.mouse.Button.OnMouseEnter;
  ex_load.Login.Login.Visible := True;

  ex_load.Login.Login_Indicator := TAniIndicator.Create(ex_load.Login.Login);
  ex_load.Login.Login_Indicator.Name := 'Loading_Login_Indicator';
  ex_load.Login.Login_Indicator.Parent := ex_load.Login.Login;
  ex_load.Login.Login_Indicator.SetBounds(75, 5, 30, 30);
  ex_load.Login.Login_Indicator.Enabled := False;
  ex_load.Login.Login_Indicator.Visible := False;

  ex_load.Login.Exit_ExtraFE := TButton.Create(ex_load.Login.Main);
  ex_load.Login.Exit_ExtraFE.Name := 'Loading_Login_Exit';
  ex_load.Login.Exit_ExtraFE.Parent := ex_load.Login.Main;
  ex_load.Login.Exit_ExtraFE.SetBounds(330, 228, 180, 40);
  ex_load.Login.Exit_ExtraFE.Text := 'Exit';
  ex_load.Login.Exit_ExtraFE.OnClick := ex_load.Input.mouse.Button.OnMouseClick;
  ex_load.Login.Exit_ExtraFE.OnMouseEnter := ex_load.Input.mouse.Button.OnMouseEnter;
  ex_load.Login.Exit_ExtraFE.Visible := True;

  ex_load.Login.CapsLock_Icon := TText.Create(ex_load.Login.Main);
  ex_load.Login.CapsLock_Icon.Name := 'Loading_Login_CapsLock_Icon';
  ex_load.Login.CapsLock_Icon.Parent := ex_load.Login.Main;
  ex_load.Login.CapsLock_Icon.SetBounds(12, 166, 32, 32);
  ex_load.Login.CapsLock_Icon.Font.Family := 'IcoMoon-Free';
  ex_load.Login.CapsLock_Icon.Text := #$ea6d;
  ex_load.Login.CapsLock_Icon.TextSettings.Font.Size := 36;
  ex_load.Login.CapsLock_Icon.Visible := True;

  ex_load.Login.CapsLock := TLabel.Create(ex_load.Login.Main);
  ex_load.Login.CapsLock.Name := 'Loading_Login_Capslock';
  ex_load.Login.CapsLock.Parent := ex_load.Login.Main;
  ex_load.Login.CapsLock.SetBounds(48, 174, 200, 17);
  ex_load.Login.CapsLock.Text := 'CapsLock';
  ex_load.Login.CapsLock.Visible := True;

  ex_load.Login.Int_Icon := TText.Create(ex_load.Login.Main);
  ex_load.Login.Int_Icon.Name := 'Loading_Login_Internet_Icon';
  ex_load.Login.Int_Icon.Parent := ex_load.Login.Main;
  ex_load.Login.Int_Icon.SetBounds(16, 200, 24, 24);
  ex_load.Login.Int_Icon.Font.Family := 'IcoMoon-Free';
  ex_load.Login.Int_Icon.Font.Size := 24;
  ex_load.Login.Int_Icon.Text := #$e9c9;
  ex_load.Login.Int_Icon.TextSettings.FontColor := TAlphaColorRec.Grey;
  ex_load.Login.Int_Icon.Visible := True;

  ex_load.Login.Internet := TLabel.Create(ex_load.Login.Main);
  ex_load.Login.Internet.Name := 'Loading_Login_Internet';
  ex_load.Login.Internet.Parent := ex_load.Login.Main;
  ex_load.Login.Internet.SetBounds(48, 208, 200, 17);
  ex_load.Login.Internet.Text := 'Internet not Connected';
  ex_load.Login.Internet.Visible := True;

  ex_load.Login.Online_Data_Icon := TText.Create(ex_load.Login.Main);
  ex_load.Login.Online_Data_Icon.Name := 'Loading_Login_Online_Database_Icon';
  ex_load.Login.Online_Data_Icon.Parent := ex_load.Login.Main;
  ex_load.Login.Online_Data_Icon.SetBounds(16, 234, 24, 24);
  ex_load.Login.Online_Data_Icon.Font.Family := 'IcoMoon-Free';
  ex_load.Login.Online_Data_Icon.Font.Size := 24;
  ex_load.Login.Online_Data_Icon.Text := #$e964;
  ex_load.Login.Online_Data_Icon.TextSettings.FontColor := TAlphaColorRec.Grey;
  ex_load.Login.Online_Data_Icon.Visible := True;

  ex_load.Login.Online_Database := TLabel.Create(ex_load.Login.Main);
  ex_load.Login.Online_Database.Name := 'Loading_Login_Online_Database';
  ex_load.Login.Online_Database.Parent := ex_load.Login.Main;
  ex_load.Login.Online_Database.SetBounds(48, 242, 200, 17);
  ex_load.Login.Online_Database.Text := 'Online database not connected';
  ex_load.Login.Online_Database.Visible := True;

  ex_load.Login.Local_Data_Icon := TText.Create(ex_load.Login.Main);
  ex_load.Login.Local_Data_Icon.Name := 'Loading_Login_Local_Database_Icon';
  ex_load.Login.Local_Data_Icon.Parent := ex_load.Login.Main;
  ex_load.Login.Local_Data_Icon.SetBounds(16, 268, 24, 24);
  ex_load.Login.Local_Data_Icon.Font.Family := 'IcoMoon-Free';
  ex_load.Login.Local_Data_Icon.Font.Size := 24;
  ex_load.Login.Local_Data_Icon.Text := #$e963;
  ex_load.Login.Local_Data_Icon.TextSettings.FontColor := TAlphaColorRec.Grey;
  ex_load.Login.Local_Data_Icon.Visible := True;

  ex_load.Login.Local_Database := TLabel.Create(ex_load.Login.Main);
  ex_load.Login.Local_Database.Name := 'Loading_Login_Local_Database';
  ex_load.Login.Local_Database.Parent := ex_load.Login.Main;
  ex_load.Login.Local_Database.SetBounds(48, 276, 200, 17);
  ex_load.Login.Local_Database.Text := 'Local database not connected';
  ex_load.Login.Local_Database.Visible := True;

  ex_load.Login.NotRegister := TText.Create(ex_load.Login.Main);
  ex_load.Login.NotRegister.Name := 'Loading_Login_Register';
  ex_load.Login.NotRegister.Parent := ex_load.Login.Main;
  ex_load.Login.NotRegister.SetBounds(230, 276, 278, 17);
  ex_load.Login.NotRegister.TextSettings.HorzAlign := TTextAlign.Trailing;
  ex_load.Login.NotRegister.Text := 'Not registered yet? Click here';
  ex_load.Login.NotRegister.TextSettings.FontColor := TAlphaColorRec.White;
  ex_load.Login.NotRegister.OnClick := ex_load.Input.mouse.Text.OnMouseClick;
  ex_load.Login.NotRegister.OnMouseEnter := ex_load.Input.mouse.Text.OnMouseEnter;
  ex_load.Login.NotRegister.OnMouseLeave := ex_load.Input.mouse.Text.OnMouseLeave;
  ex_load.Login.NotRegister.Visible := True;

  ex_load.Scene.Logo.Position.X := ex_load.Login.Panel.Position.X;
  ex_load.Scene.Logo.Position.Y := ex_load.Login.Panel.Position.Y - 340;

  SetLength(vLogin_User, extrafe.users_total + 1);
  SetLength(vListBox_Item, extrafe.users_total + 1);

  vListBox_Item[0] := TListBoxItem.Create(ex_load.Login.User_V);
  vListBox_Item[0].Name := 'Load_ListItem_0';
  vListBox_Item[0].Parent := ex_load.Login.User_V;
  vListBox_Item[0].StyledSettings := vListBox_Item[0].StyledSettings - [TStyledSetting.FontColor, TStyledSetting.Size];
  vListBox_Item[0].TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  vListBox_Item[0].Font.Size := 18;
  vListBox_Item[0].Text := 'Choose...';
  vListBox_Item[0].Visible := True;
  ex_load.Login.User_V.AddObject(vListBox_Item[0]);

  if extrafe.users_total > 0 then
  begin
    for vi := 1 to extrafe.users_total do
    begin
      vLogin_User[vi].Username := uDB.Query_Select(uDB.ExtraFE_Query_Local, 'USERNAME', 'USERS', 'USER_ID', vi.ToString);
      vLogin_User[vi].Password := uDB.Query_Select(uDB.ExtraFE_Query_Local, 'PASSWORD', 'USERS', 'USER_ID', vi.ToString);
      vLogin_User[vi].Avatar := uDB.Query_Select(uDB.ExtraFE_Query_Local, 'AVATAR', 'USERS', 'USER_ID', vi.ToString);
      vLogin_User[vi].Last_Visit := uDB.Query_Select(uDB.ExtraFE_Query_Local, 'LAST_VISIT', 'USERS', 'USER_ID', vi.ToString);

      vListBox_Item[vi] := TListBoxItem.Create(ex_load.Login.User_V);
      vListBox_Item[vi].Name := 'Load_ListItem_' + vi.ToString;
      vListBox_Item[vi].Parent := ex_load.Login.User_V;
      vListBox_Item[vi].StyledSettings := vListBox_Item[vi].StyledSettings - [TStyledSetting.FontColor, TStyledSetting.Size];
      vListBox_Item[vi].TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
      vListBox_Item[vi].Font.Size := 18;
      vListBox_Item[vi].Text := vLogin_User[vi].Username;
      vListBox_Item[vi].Visible := True;
      ex_load.Login.User_V.AddObject(vListBox_Item[vi]);
    end;
  end;

  if extrafe.users_total > 0 then
  begin
    ex_load.Login.Avatar.Bitmap.LoadFromFile(ex_main.Paths.Avatar_Images + vLogin_User[1].Avatar + '.png');
    ex_load.Login.Last_Visit.Text := 'Last Visit : ' + vLogin_User[1].Last_Visit;
  end
  else
  begin
    ex_load.Login.Avatar.Bitmap.LoadFromFile(ex_main.Paths.Avatar_Images + '0.png');
    ex_load.Login.Last_Visit.Text := 'Last Visti :  Not Yet';
  end;

  GetKeyboardState(vkState);
  if (vkState[VK_CAPITAL] = 0) then
    ex_load.Login.CapsLock_Icon.Locked := False
  else
    ex_load.Login.CapsLock_Icon.Locked := True;

  uLoad_Login.CapsLock(not ex_load.Login.CapsLock_Icon.Locked);

  if extrafe.databases.local_connected then
  begin
    ex_load.Login.Local_Database.Text := 'Local database is connected';
    ex_load.Login.Local_Data_Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  end;

  if extrafe.Internet_Active then
  begin
    ex_load.Login.Int_Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    ex_load.Login.Internet.Text := 'Internet is connected';
    if extrafe.databases.online_connected then
    begin
      ex_load.Login.Online_Database.Text := 'Online database is connected';
      ex_load.Login.Online_Data_Icon.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
    end
    else
    begin
      ex_load.Login.NotRegister.Text := 'Something wrong and you can''t register';
      ex_load.Login.NotRegister.TextSettings.FontColor := TAlphaColorRec.Red;
    end;
  end;

    ex_load.Login.User_V.ItemIndex := 0;
end;

procedure Login_Forget_Password;
begin
  extrafe.prog.State := 'load_forgat';

  ex_load.F_Pass.Panel := TPanel.Create(ex_load.Scene.Back);
  ex_load.F_Pass.Panel.Name := 'Loading_FPass';
  ex_load.F_Pass.Panel.Parent := ex_load.Scene.Back;
  ex_load.F_Pass.Panel.SetBounds(extrafe.res.Half_Width - 250, extrafe.res.Half_Height - 100, 500, 200);
  ex_load.F_Pass.Panel.Opacity := 0.8;
  ex_load.F_Pass.Panel.Visible := True;

  CreateHeader(ex_load.F_Pass.Panel, 'IcoMoon-Free', #$e98d, 'Forget my password', False, nil);

  ex_load.F_Pass.Main.Panel := TPanel.Create(ex_load.F_Pass.Panel);
  ex_load.F_Pass.Main.Panel.Name := 'Loading_FPass_Main';
  ex_load.F_Pass.Main.Panel.Parent := ex_load.F_Pass.Panel;
  ex_load.F_Pass.Main.Panel.SetBounds(0, 30, ex_load.F_Pass.Panel.Width, ex_load.F_Pass.Panel.Height - 30);
  ex_load.F_Pass.Main.Panel.Visible := True;

  ex_load.F_Pass.Main.User := TText.Create(ex_load.F_Pass.Panel);
  ex_load.F_Pass.Main.User.Name := 'Loading_FPass_User';
  ex_load.F_Pass.Main.User.Parent := ex_load.F_Pass.Panel;
  ex_load.F_Pass.Main.User.SetBounds(10, 60, ex_load.F_Pass.Main.Panel.Width - 110, 26);
  ex_load.F_Pass.Main.User.TextSettings.FontColor := TAlphaColorRec.White;
  ex_load.F_Pass.Main.User.TextSettings.HorzAlign := TTextAlign.Center;
  ex_load.F_Pass.Main.User.Font.Size := 18;
  ex_load.F_Pass.Main.User.Text := 'User " ' + ex_load.Login.User_V.Items.Strings[ex_load.Login.User_V.ItemIndex] + ' "';
  ex_load.F_Pass.Main.User.Visible := True;

  ex_load.F_Pass.Main.Avatar := TImage.Create(ex_load.F_Pass.Main.Panel);
  ex_load.F_Pass.Main.Avatar.Name := 'Loading_FPass_Avatar';
  ex_load.F_Pass.Main.Avatar.Parent := ex_load.F_Pass.Main.Panel;
  ex_load.F_Pass.Main.Avatar.SetBounds(((ex_load.F_Pass.Main.Panel.Width) - 90), 5, 70, 70);
  ex_load.F_Pass.Main.Avatar.Bitmap := ex_load.Login.Avatar.Bitmap;
  ex_load.F_Pass.Main.Avatar.WrapMode := TImageWrapMode.Fit;
  ex_load.F_Pass.Main.Avatar.Visible := True;

  ex_load.F_Pass.Main.Email := TLabel.Create(ex_load.F_Pass.Main.Panel);
  ex_load.F_Pass.Main.Email.Name := 'Loading_FPass_Email';
  ex_load.F_Pass.Main.Email.Parent := ex_load.F_Pass.Main.Panel;
  ex_load.F_Pass.Main.Email.SetBounds(10, 70, 200, 20);
  ex_load.F_Pass.Main.Email.Text := 'Write your email';
  ex_load.F_Pass.Main.Email.Visible := True;

  ex_load.F_Pass.Main.Email_V := TEdit.Create(ex_load.F_Pass.Main.Panel);
  ex_load.F_Pass.Main.Email_V.Name := 'Loading_FPass_Email_V';
  ex_load.F_Pass.Main.Email_V.Parent := ex_load.F_Pass.Main.Panel;
  ex_load.F_Pass.Main.Email_V.SetBounds(10, 90, ex_load.F_Pass.Main.Panel.Width - 20, 36);
  ex_load.F_Pass.Main.Email_V.Text := '';
  ex_load.F_Pass.Main.Email_V.Font.Size := 18;
  ex_load.F_Pass.Main.Email_V.TextSettings.FontColor := TAlphaColorRec.White;
  ex_load.F_Pass.Main.Email_V.StyledSettings := ex_load.F_Pass.Main.Email_V.StyledSettings - [TStyledSetting.FontColor, TStyledSetting.Size];
  ex_load.F_Pass.Main.Email_V.OnTyping := ex_load.Input.mouse.Edit.OnTyping;
  ex_load.F_Pass.Main.Email_V.Visible := True;

  ex_load.F_Pass.Main.Send := TButton.Create(ex_load.F_Pass.Main.Panel);
  ex_load.F_Pass.Main.Send.Name := 'Loading_FPass_Send';
  ex_load.F_Pass.Main.Send.Parent := ex_load.F_Pass.Main.Panel;
  ex_load.F_Pass.Main.Send.SetBounds(50, ex_load.F_Pass.Main.Panel.Height - 40, 100, 30);
  ex_load.F_Pass.Main.Send.Text := 'Send';
  ex_load.F_Pass.Main.Send.OnClick := ex_load.Input.mouse.Button.OnMouseClick;
  ex_load.F_Pass.Main.Send.OnMouseEnter := ex_load.Input.mouse.Button.OnMouseEnter;
  ex_load.F_Pass.Main.Send.Visible := True;

  ex_load.F_Pass.Main.Cancel := TButton.Create(ex_load.F_Pass.Main.Panel);
  ex_load.F_Pass.Main.Cancel.Name := 'Loading_FPass_Cancel';
  ex_load.F_Pass.Main.Cancel.Parent := ex_load.F_Pass.Main.Panel;
  ex_load.F_Pass.Main.Cancel.SetBounds(ex_load.F_Pass.Main.Panel.Width - 150, ex_load.F_Pass.Main.Panel.Height - 40, 100, 30);
  ex_load.F_Pass.Main.Cancel.Text := 'Cancel';
  ex_load.F_Pass.Main.Cancel.OnClick := ex_load.Input.mouse.Button.OnMouseClick;
  ex_load.F_Pass.Main.Cancel.OnMouseEnter := ex_load.Input.mouse.Button.OnMouseEnter;
  ex_load.F_Pass.Main.Cancel.Visible := True;

  ex_load.F_Pass.Main.Warning := TLabel.Create(ex_load.F_Pass.Panel);
  ex_load.F_Pass.Main.Warning.Name := 'Loading_FPass_Warning';
  ex_load.F_Pass.Main.Warning.Parent := ex_load.F_Pass.Panel;
  ex_load.F_Pass.Main.Warning.SetBounds(118, 34, 373, 22);
  ex_load.F_Pass.Main.Warning.TextSettings.FontColor := TAlphaColorRec.Red;
  ex_load.F_Pass.Main.Warning.Text := 'Wrong Email';
  ex_load.F_Pass.Main.Warning.TextAlign := TTextAlign.Trailing;
  ex_load.F_Pass.Main.Warning.StyledSettings := ex_load.F_Pass.Main.Warning.StyledSettings - [TStyledSetting.FontColor, TStyledSetting.Size];
  ex_load.F_Pass.Main.Warning.Visible := False;

  FreeAndNil(ex_load.Login.Panel);
end;

procedure Register_Form;
begin

  extrafe.prog.State := 'load_register';
  ex_load.Reg.Edit_Select := 'noone';

  ex_load.Reg.Panel := TPanel.Create(ex_load.Scene.Back);
  ex_load.Reg.Panel.Name := 'Loading_Register';
  ex_load.Reg.Panel.Parent := ex_load.Scene.Back;
  ex_load.Reg.Panel.SetBounds(extrafe.res.Half_Width - 250, extrafe.res.Half_Height - 260, 500, 600);
  ex_load.Reg.Panel.Opacity := 0.8;
  ex_load.Reg.Panel.Visible := True;

  ex_load.Reg.Panel_Error := TFloatAnimation.Create(ex_load.Reg.Panel);
  ex_load.Reg.Panel_Error.Name := 'Loading_Register_Ani_Error';
  ex_load.Reg.Panel_Error.Parent := ex_load.Reg.Panel;
  ex_load.Reg.Panel_Error.PropertyName := 'Position.X';
  ex_load.Reg.Panel_Error.Duration := 0.3;
  ex_load.Reg.Panel_Error.Interpolation := TInterpolationType.Bounce;
  ex_load.Reg.Panel_Error.AnimationType := TAnimationType.&In;
  ex_load.Reg.Panel_Error.Enabled := False;

  uLoad_Register.Create_Help;

  CreateHeader(ex_load.Reg.Panel, 'IcoMoon-Free', #$e907, 'Register', False, nil);

  ex_load.Reg.Main.Panel := TPanel.Create(ex_load.Reg.Panel);
  ex_load.Reg.Main.Panel.Name := 'Loading_Register_Main';
  ex_load.Reg.Main.Panel.Parent := ex_load.Reg.Panel;
  ex_load.Reg.Main.Panel.SetBounds(0, 30, ex_load.Reg.Panel.Width, ex_load.Reg.Panel.Height - 30);
  ex_load.Reg.Main.Panel.Visible := True;

  ex_load.Reg.Main.User := TLabel.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.User.Name := 'Loading_Register_User';
  ex_load.Reg.Main.User.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.User.SetBounds(20, 10, 200, 20);
  ex_load.Reg.Main.User.Text := 'Username :';
  ex_load.Reg.Main.User.Visible := True;

  ex_load.Reg.Main.User_Max := TLabel.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.User_Max.Name := 'Loading_Register_User_Max';
  ex_load.Reg.Main.User_Max.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.User_Max.SetBounds(80, 10, 300, 20);
  ex_load.Reg.Main.User_Max.Text := 'Max characters (20)';
  ex_load.Reg.Main.User_Max.StyledSettings := ex_load.Reg.Main.User_Max.StyledSettings - [TStyledSetting.Style, TStyledSetting.FontColor];
  ex_load.Reg.Main.User_Max.TextSettings.Font.Style := ex_load.Reg.Main.User_Max.TextSettings.Font.Style + [TFontstyle.fsItalic];
  ex_load.Reg.Main.User_Max.Visible := True;

  ex_load.Reg.Main.User_Online := TLabel.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.User_Online.Name := 'Loading_Register_User_Online';
  ex_load.Reg.Main.User_Online.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.User_Online.SetBounds(ex_load.Reg.Main.Panel.Width - 220, 10, 200, 20);
  ex_load.Reg.Main.User_Online.Text := '';
  ex_load.Reg.Main.User_Online.StyledSettings := ex_load.Reg.Main.User_Online.StyledSettings - [TStyledSetting.Style, TStyledSetting.FontColor];
  ex_load.Reg.Main.User_Online.TextSettings.Font.Style := ex_load.Reg.Main.User_Online.TextSettings.Font.Style + [TFontstyle.fsItalic];
  ex_load.Reg.Main.User_Online.TextSettings.HorzAlign := TTextAlign.Trailing;
  ex_load.Reg.Main.User_Online.Visible := True;

  ex_load.Reg.Main.User_V := TEdit.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.User_V.Name := 'Loading_Register_User_V';
  ex_load.Reg.Main.User_V.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.User_V.SetBounds(20, 30, ex_load.Reg.Main.Panel.Width - 40, 30);
  ex_load.Reg.Main.User_V.Text := '';
  ex_load.Reg.Main.User_V.Font.Size := 18;
  ex_load.Reg.Main.User_V.StyledSettings := ex_load.Reg.Main.User_V.StyledSettings - [TStyledSetting.Size];
  ex_load.Reg.Main.User_V.OnMouseEnter := ex_load.Input.mouse.Edit.OnMouseEnter;
  ex_load.Reg.Main.User_V.OnTyping := ex_load.Input.mouse.Edit.OnTyping;
  ex_load.Reg.Main.User_V.Visible := True;

  ex_load.Reg.Main.Pass := TLabel.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Pass.Name := 'Loading_Register_Pass';
  ex_load.Reg.Main.Pass.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Pass.SetBounds(20, 65, 200, 20);
  ex_load.Reg.Main.Pass.Text := 'Password :';
  ex_load.Reg.Main.Pass.Visible := True;

  ex_load.Reg.Main.Pass_Max := TLabel.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Pass_Max.Name := 'Loading_Register_Pass_Max';
  ex_load.Reg.Main.Pass_Max.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Pass_Max.SetBounds(80, 65, 300, 20);
  ex_load.Reg.Main.Pass_Max.Text := 'Max characters (20) ';
  ex_load.Reg.Main.Pass_Max.StyledSettings := ex_load.Reg.Main.Pass_Max.StyledSettings - [TStyledSetting.Style, TStyledSetting.FontColor];
  ex_load.Reg.Main.Pass_Max.TextSettings.Font.Style := ex_load.Reg.Main.Pass_Max.TextSettings.Font.Style + [TFontstyle.fsItalic];
  ex_load.Reg.Main.Pass_Max.Visible := True;

  ex_load.Reg.Main.Pass_V := TEdit.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Pass_V.Name := 'Loading_Register_Pass_V';
  ex_load.Reg.Main.Pass_V.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Pass_V.SetBounds(20, 85, ex_load.Reg.Main.Panel.Width - 40, 30);
  ex_load.Reg.Main.Pass_V.Text := '';
  ex_load.Reg.Main.Pass_V.Font.Size := 18;
  ex_load.Reg.Main.Pass_V.StyledSettings := ex_load.Reg.Main.Pass_V.StyledSettings - [TStyledSetting.Size];
  ex_load.Reg.Main.Pass_V.OnMouseEnter := ex_load.Input.mouse.Edit.OnMouseEnter;
  ex_load.Reg.Main.Pass_V.OnTyping := ex_load.Input.mouse.Edit.OnTyping;
  ex_load.Reg.Main.Pass_V.Password := True;
  ex_load.Reg.Main.Pass_V.Visible := True;

  ex_load.Reg.Main.Pass_Show := TText.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Pass_Show.Name := 'Loading_Register_Pass_Show';
  ex_load.Reg.Main.Pass_Show.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Pass_Show.SetBounds(ex_load.Reg.Main.Pass_V.Width - 2, 90, 20, 20);
  ex_load.Reg.Main.Pass_Show.Font.Family := 'IcoMoon-Free';
  ex_load.Reg.Main.Pass_Show.Font.Size := 18;
  ex_load.Reg.Main.Pass_Show.TextSettings.FontColor := TAlphaColorRec.Grey;
  ex_load.Reg.Main.Pass_Show.Text := #$e9d1;
  ex_load.Reg.Main.Pass_Show.OnClick := ex_load.Input.mouse.Text.OnMouseClick;
  ex_load.Reg.Main.Pass_Show.OnMouseEnter := ex_load.Input.mouse.Text.OnMouseEnter;
  ex_load.Reg.Main.Pass_Show.OnMouseLeave := ex_load.Input.mouse.Text.OnMouseLeave;
  ex_load.Reg.Main.Pass_Show.Visible := True;

  ex_load.Reg.Main.Pass_Show_Glow := TGlowEffect.Create(ex_load.Reg.Main.Pass_Show);
  ex_load.Reg.Main.Pass_Show_Glow.Name := 'Loading_Register_Pass_Show_Glow';
  ex_load.Reg.Main.Pass_Show_Glow.Parent := ex_load.Reg.Main.Pass_Show;
  ex_load.Reg.Main.Pass_Show_Glow.GlowColor := TAlphaColorRec.Lime;
  ex_load.Reg.Main.Pass_Show_Glow.Opacity := 0.9;
  ex_load.Reg.Main.Pass_Show_Glow.Enabled := False;

  ex_load.Reg.Main.RePass := TLabel.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.RePass.Name := 'Loading_Register_RePass';
  ex_load.Reg.Main.RePass.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.RePass.SetBounds(20, 120, 200, 20);
  ex_load.Reg.Main.RePass.Text := 'Retype password :';
  ex_load.Reg.Main.RePass.Visible := True;

  ex_load.Reg.Main.RePass_V := TEdit.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.RePass_V.Name := 'Loading_Register_RePass_V';
  ex_load.Reg.Main.RePass_V.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.RePass_V.SetBounds(20, 140, ex_load.Reg.Main.Panel.Width - 40, 30);
  ex_load.Reg.Main.RePass_V.Text := '';
  ex_load.Reg.Main.RePass_V.Font.Size := 18;
  ex_load.Reg.Main.RePass_V.StyledSettings := ex_load.Reg.Main.RePass_V.StyledSettings - [TStyledSetting.Size];
  ex_load.Reg.Main.RePass_V.OnMouseEnter := ex_load.Input.mouse.Edit.OnMouseEnter;
  ex_load.Reg.Main.RePass_V.OnTyping := ex_load.Input.mouse.Edit.OnTyping;
  ex_load.Reg.Main.RePass_V.Password := True;
  ex_load.Reg.Main.RePass_V.Visible := True;

  ex_load.Reg.Main.RePass_Show := TText.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.RePass_Show.Name := 'Loading_Register_RePass_Show';
  ex_load.Reg.Main.RePass_Show.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.RePass_Show.SetBounds(ex_load.Reg.Main.RePass_V.Width - 2, 145, 20, 20);
  ex_load.Reg.Main.RePass_Show.Font.Family := 'IcoMoon-Free';
  ex_load.Reg.Main.RePass_Show.Font.Size := 18;
  ex_load.Reg.Main.RePass_Show.TextSettings.FontColor := TAlphaColorRec.Grey;
  ex_load.Reg.Main.RePass_Show.Text := #$e9d1;
  ex_load.Reg.Main.RePass_Show.OnClick := ex_load.Input.mouse.Text.OnMouseClick;
  ex_load.Reg.Main.RePass_Show.OnMouseEnter := ex_load.Input.mouse.Text.OnMouseEnter;
  ex_load.Reg.Main.RePass_Show.OnMouseLeave := ex_load.Input.mouse.Text.OnMouseLeave;
  ex_load.Reg.Main.RePass_Show.Visible := True;

  ex_load.Reg.Main.RePass_Show_Glow := TGlowEffect.Create(ex_load.Reg.Main.RePass_Show);
  ex_load.Reg.Main.RePass_Show_Glow.Name := 'Loading_Register_RePass_Show_Glow';
  ex_load.Reg.Main.RePass_Show_Glow.Parent := ex_load.Reg.Main.RePass_Show;
  ex_load.Reg.Main.RePass_Show_Glow.GlowColor := TAlphaColorRec.Lime;
  ex_load.Reg.Main.RePass_Show_Glow.Opacity := 0.9;
  ex_load.Reg.Main.RePass_Show_Glow.Enabled := False;

  ex_load.Reg.Main.Email := TLabel.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Email.Name := 'Loading_Register_Email';
  ex_load.Reg.Main.Email.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Email.SetBounds(20, 175, 200, 20);
  ex_load.Reg.Main.Email.Text := 'Email :';
  ex_load.Reg.Main.Email.Visible := True;

  ex_load.Reg.Main.Email_Online := TLabel.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Email_Online.Name := 'Loading_Register_Email_Online';
  ex_load.Reg.Main.Email_Online.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Email_Online.SetBounds(ex_load.Reg.Main.Panel.Width - 220, 175, 200, 20);
  ex_load.Reg.Main.Email_Online.Text := '';
  ex_load.Reg.Main.Email_Online.StyledSettings := ex_load.Reg.Main.Email_Online.StyledSettings - [TStyledSetting.Style, TStyledSetting.FontColor];
  ex_load.Reg.Main.Email_Online.TextSettings.Font.Style := ex_load.Reg.Main.Email_Online.TextSettings.Font.Style + [TFontstyle.fsItalic];
  ex_load.Reg.Main.Email_Online.TextSettings.HorzAlign := TTextAlign.Trailing;
  ex_load.Reg.Main.Email_Online.Visible := True;

  ex_load.Reg.Main.Email_V := TEdit.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Email_V.Name := 'Loading_Register_Email_V';
  ex_load.Reg.Main.Email_V.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Email_V.SetBounds(20, 195, ex_load.Reg.Main.Panel.Width - 40, 30);
  ex_load.Reg.Main.Email_V.Text := '';
  ex_load.Reg.Main.Email_V.Font.Size := 18;
  ex_load.Reg.Main.Email_V.StyledSettings := ex_load.Reg.Main.Email_V.StyledSettings - [TStyledSetting.Size];
  ex_load.Reg.Main.Email_V.OnMouseEnter := ex_load.Input.mouse.Edit.OnMouseEnter;
  ex_load.Reg.Main.Email_V.OnTyping := ex_load.Input.mouse.Edit.OnTyping;
  ex_load.Reg.Main.Email_V.Visible := True;

  ex_load.Reg.Main.ReEmail := TLabel.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.ReEmail.Name := 'Loading_Register_ReEmail';
  ex_load.Reg.Main.ReEmail.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.ReEmail.SetBounds(20, 230, 200, 20);
  ex_load.Reg.Main.ReEmail.Text := 'Retype Email :';
  ex_load.Reg.Main.ReEmail.Visible := True;

  ex_load.Reg.Main.ReEmail_V := TEdit.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.ReEmail_V.Name := 'Loading_Register_ReEmail_V';
  ex_load.Reg.Main.ReEmail_V.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.ReEmail_V.SetBounds(20, 250, ex_load.Reg.Main.Panel.Width - 40, 30);
  ex_load.Reg.Main.ReEmail_V.Text := '';
  ex_load.Reg.Main.ReEmail_V.Font.Size := 18;
  ex_load.Reg.Main.ReEmail_V.StyledSettings := ex_load.Reg.Main.ReEmail_V.StyledSettings - [TStyledSetting.Size];
  ex_load.Reg.Main.ReEmail_V.OnMouseEnter := ex_load.Input.mouse.Edit.OnMouseEnter;
  ex_load.Reg.Main.ReEmail_V.OnTyping := ex_load.Input.mouse.Edit.OnTyping;
  ex_load.Reg.Main.ReEmail_V.Visible := True;

  ex_load.Reg.Main.Capt_Img := TImage.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Capt_Img.Name := 'Loading_Register_Capt_Img';
  ex_load.Reg.Main.Capt_Img.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Capt_Img.SetBounds(20, 300, 240, 150);
  ex_load.Reg.Main.Capt_Img.Bitmap.LoadFromFile(ex_load.Path.Images + 'captcha.png');
  ex_load.Reg.Main.Capt_Img.WrapMode := TImageWrapMode.Fit;
  ex_load.Reg.Main.Capt_Img.Visible := True;

  uLoad_Register.Create_Captcha;

  ex_load.Reg.Main.Capt_Refresh := TText.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Capt_Refresh.Name := 'Loading_Register_Capt_Refresh';
  ex_load.Reg.Main.Capt_Refresh.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Capt_Refresh.SetBounds(266, 300, 24, 24);
  ex_load.Reg.Main.Capt_Refresh.Font.Family := 'IcoMoon-Free';
  ex_load.Reg.Main.Capt_Refresh.Font.Size := 24;
  ex_load.Reg.Main.Capt_Refresh.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  ex_load.Reg.Main.Capt_Refresh.Text := #$e982;
  ex_load.Reg.Main.Capt_Refresh.OnClick := ex_load.Input.mouse.Text.OnMouseClick;
  ex_load.Reg.Main.Capt_Refresh.OnMouseEnter := ex_load.Input.mouse.Text.OnMouseEnter;
  ex_load.Reg.Main.Capt_Refresh.OnMouseLeave := ex_load.Input.mouse.Text.OnMouseLeave;
  ex_load.Reg.Main.Capt_Refresh.Visible := True;

  ex_load.Reg.Main.Capt_Refresh_Glow := TGlowEffect.Create(ex_load.Reg.Main.Capt_Refresh);
  ex_load.Reg.Main.Capt_Refresh_Glow.Name := 'Loading_Register_Capt_Refresh_Glow';
  ex_load.Reg.Main.Capt_Refresh_Glow.Parent := ex_load.Reg.Main.Capt_Refresh;
  ex_load.Reg.Main.Capt_Refresh_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  ex_load.Reg.Main.Capt_Refresh_Glow.Opacity := 0.9;
  ex_load.Reg.Main.Capt_Refresh_Glow.Enabled := False;

  ex_load.Reg.Main.Capt := TLabel.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Capt.Name := 'Loading_Register_Capt';
  ex_load.Reg.Main.Capt.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Capt.SetBounds(20, 450, 200, 20);
  ex_load.Reg.Main.Capt.Text := 'Type captcha letters :';
  ex_load.Reg.Main.Capt.Visible := True;

  ex_load.Reg.Main.Capt_V := TEdit.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Capt_V.Name := 'Loading_Register_Capt_V';
  ex_load.Reg.Main.Capt_V.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Capt_V.SetBounds(20, 470, 240, 30);
  ex_load.Reg.Main.Capt_V.Text := '';
  ex_load.Reg.Main.Capt_V.Font.Size := 18;
  ex_load.Reg.Main.Capt_V.StyledSettings := ex_load.Reg.Main.Capt_V.StyledSettings - [TStyledSetting.Size];
  ex_load.Reg.Main.Capt_V.OnMouseEnter := ex_load.Input.mouse.Edit.OnMouseEnter;
  ex_load.Reg.Main.Capt_V.OnTyping := ex_load.Input.mouse.Edit.OnTyping;
  ex_load.Reg.Main.Capt_V.Visible := True;

  ex_load.Reg.Main.Terms := TText.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Terms.Name := 'Loading_Register_Terms';
  ex_load.Reg.Main.Terms.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Terms.SetBounds(270, 375, 200, 20);
  ex_load.Reg.Main.Terms.Text := '<< Read the Terms >>';
  ex_load.Reg.Main.Terms.TextSettings.FontColor := TAlphaColorRec.White;
  ex_load.Reg.Main.Terms.TextSettings.Font.Size := 16;
  ex_load.Reg.Main.Terms.OnClick := ex_load.Input.mouse.Text.OnMouseClick;
  ex_load.Reg.Main.Terms.OnMouseEnter := ex_load.Input.mouse.Text.OnMouseEnter;
  ex_load.Reg.Main.Terms.OnMouseLeave := ex_load.Input.mouse.Text.OnMouseLeave;
  ex_load.Reg.Main.Terms.Visible := True;

  ex_load.Reg.Main.Terms_Check := TCheckBox.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Terms_Check.Name := 'Loading_Register_Terms_Check';
  ex_load.Reg.Main.Terms_Check.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Terms_Check.SetBounds(310, 400, 200, 17);
  ex_load.Reg.Main.Terms_Check.Text := 'I accept the terms';
  ex_load.Reg.Main.Terms_Check.Enabled := False;
  ex_load.Reg.Main.Terms_Check.OnClick := ex_load.Input.mouse.Checkbox.OnMouseClick;
  ex_load.Reg.Main.Terms_Check.OnMouseEnter := ex_load.Input.mouse.Checkbox.OnMouseEnter;
  ex_load.Reg.Main.Terms_Check.OnMouseLeave := ex_load.Input.mouse.Checkbox.OnMouseLeave;
  ex_load.Reg.Main.Terms_Check.Visible := True;

  ex_load.Reg.Main.Reg := TButton.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Reg.Name := 'Loading_Reg_Register';
  ex_load.Reg.Main.Reg.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Reg.SetBounds(50, ex_load.Reg.Main.Panel.Height - 40, 100, 30);
  ex_load.Reg.Main.Reg.Text := 'Register';
  ex_load.Reg.Main.Reg.OnClick := ex_load.Input.mouse.Button.OnMouseClick;
  ex_load.Reg.Main.Reg.OnMouseEnter := ex_load.Input.mouse.Button.OnMouseEnter;
  ex_load.Reg.Main.Reg.Visible := True;

  ex_load.Reg.Main.Cancel := TButton.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Cancel.Name := 'Loading_Reg_Cancel';
  ex_load.Reg.Main.Cancel.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Cancel.SetBounds(ex_load.Reg.Main.Panel.Width - 150, ex_load.Reg.Main.Panel.Height - 40, 100, 30);
  ex_load.Reg.Main.Cancel.Text := 'Cancel';
  ex_load.Reg.Main.Cancel.OnClick := ex_load.Input.mouse.Button.OnMouseClick;
  ex_load.Reg.Main.Cancel.OnMouseEnter := ex_load.Input.mouse.Button.OnMouseEnter;
  ex_load.Reg.Main.Cancel.Visible := True;

  FreeAndNil(ex_load.Login.Panel);

  CodeSite.Send(csmLevel5, 'User is in Registration mode');
end;

procedure Register_Terms;
begin
  ex_load.Terms.Panel := TPanel.Create(ex_load.Scene.Back);
  ex_load.Terms.Panel.Name := 'Loading_Terms';
  ex_load.Terms.Panel.Parent := ex_load.Scene.Back;
  ex_load.Terms.Panel.SetBounds(extrafe.res.Half_Width - 250, extrafe.res.Half_Height - 260, 500, 600);
  ex_load.Terms.Panel.Visible := True;

  CreateHeader(ex_load.Terms.Panel, 'IcoMoon-Free', #$e922, 'Read the terms of ExtraFE.', False, nil);

  ex_load.Terms.Main.Panel := TPanel.Create(ex_load.Terms.Panel);
  ex_load.Terms.Main.Panel.Name := 'Loading_Terms_Main';
  ex_load.Terms.Main.Panel.Parent := ex_load.Terms.Panel;
  ex_load.Terms.Main.Panel.SetBounds(0, 30, ex_load.Terms.Panel.Width, ex_load.Terms.Panel.Height - 30);
  ex_load.Terms.Main.Panel.Visible := True;

  ex_load.Terms.Main.Memo := TMemo.Create(ex_load.Terms.Main.Panel);
  ex_load.Terms.Main.Memo.Name := 'Loading_Terms_Terms';
  ex_load.Terms.Main.Memo.Parent := ex_load.Terms.Main.Panel;
  ex_load.Terms.Main.Memo.SetBounds(10, 10, ex_load.Terms.Main.Panel.Width - 20, ex_load.Terms.Main.Panel.Height - 60);
  ex_load.Terms.Main.Memo.Lines.LoadFromFile(ex_load.Path.Images + 'lin.txt');
  ex_load.Terms.Main.Memo.WordWrap := True;
  ex_load.Terms.Main.Memo.TextSettings.Font.Size := 14;
  ex_load.Terms.Main.Memo.StyledSettings := ex_load.Terms.Main.Memo.StyledSettings - [TStyledSetting.Size];
  ex_load.Terms.Main.Memo.Visible := True;

  ex_load.Terms.Main.Close := TButton.Create(ex_load.Terms.Main.Panel);
  ex_load.Terms.Main.Close.Name := 'Loading_Terms_Close';
  ex_load.Terms.Main.Close.Parent := ex_load.Terms.Main.Panel;
  ex_load.Terms.Main.Close.SetBounds((ex_load.Terms.Main.Panel.Width / 2) - 50, ex_load.Terms.Main.Panel.Height - 40, 100, 30);
  ex_load.Terms.Main.Close.Text := 'Close';
  ex_load.Terms.Main.Close.OnClick := ex_load.Input.mouse.Button.OnMouseClick;
  ex_load.Terms.Main.Close.Visible := True;
end;

procedure Register_Error;
begin
  ex_load.Login.Panel.Visible := False;

  ex_load.Reg_Error.Panel := TPanel.Create(ex_load.Scene.Back);
  ex_load.Reg_Error.Panel.Name := 'Loading_Register_Error';
  ex_load.Reg_Error.Panel.Parent := ex_load.Scene.Back;
  ex_load.Reg_Error.Panel.SetBounds(extrafe.res.Half_Width - 265, extrafe.res.Half_Height - 173, 530, 346);
  ex_load.Reg_Error.Panel.Visible := True;

  CreateHeader(ex_load.Reg_Error.Panel, 'IcoMoon-Free', #$e909, 'Something wrong with register', False, nil);

  ex_load.Reg_Error.Memo := TMemo.Create(ex_load.Reg_Error.Panel);
  ex_load.Reg_Error.Memo.Name := 'Loading_Register_Error_Main';
  ex_load.Reg_Error.Memo.Parent := ex_load.Reg_Error.Panel;
  ex_load.Reg_Error.Memo.SetBounds(10, 40, ex_load.Reg_Error.Panel.Width - 20, ex_load.Reg_Error.Panel.Height - 90);
  ex_load.Reg_Error.Memo.Lines.Add(' Warning !!!');
  ex_load.Reg_Error.Memo.Lines.Add(' Or internet is down or for some reason you can''t connect to server database.');
  ex_load.Reg_Error.Memo.Lines.Add(' ');
  ex_load.Reg_Error.Memo.Lines.Add(' In this case you can''t register a new user.');
  ex_load.Reg_Error.Memo.Lines.Add(' If your machine is not connect to internet try to connect and restart the ExtraFE');
  ex_load.Reg_Error.Memo.Lines.Add(' If ExtraFE can''t connect to server database please close and wait for a couple minutes and try again');
  ex_load.Reg_Error.Memo.Lines.Add('  ');
  ex_load.Reg_Error.Memo.Lines.Add(' If the next start of ExtraFE the icon of Online database turns Blue then you can register a new user');
  ex_load.Reg_Error.Memo.WordWrap := True;
  ex_load.Reg_Error.Memo.Visible := True;

  ex_load.Reg_Error.OK := TButton.Create(ex_load.Reg_Error.Panel);
  ex_load.Reg_Error.OK.Name := 'Loading_Register_Error_Ok';
  ex_load.Reg_Error.OK.Parent := ex_load.Reg_Error.Panel;
  ex_load.Reg_Error.OK.SetBounds(10, ex_load.Reg_Error.Panel.Height - 50, ex_load.Reg_Error.Panel.Width - 20, 40);
  ex_load.Reg_Error.OK.Text := 'Close';
  ex_load.Reg_Error.OK.OnClick := ex_load.Input.mouse.Button.OnMouseClick;
  ex_load.Reg_Error.OK.OnMouseEnter := ex_load.Input.mouse.Button.OnMouseEnter;
  ex_load.Reg_Error.OK.Visible := True;
end;

procedure Register_Success;
begin
  ex_load.Reg_Success.Panel := TLayout.Create(ex_load.Scene.Back);
  ex_load.Reg_Success.Panel.Name := 'Loading_Register_Success';
  ex_load.Reg_Success.Panel.Parent := ex_load.Scene.Back;
  ex_load.Reg_Success.Panel.SetBounds(extrafe.res.Half_Width - 265, extrafe.res.Half_Height - 173, 530, 346);
  ex_load.Reg_Success.Panel.Visible := True;

  ex_load.Reg_Success.Text := TText.Create(ex_load.Reg_Success.Panel);
  ex_load.Reg_Success.Text.Name := 'Loading_Register_Success_Text';
  ex_load.Reg_Success.Text.Parent := ex_load.Reg_Success.Panel;
  ex_load.Reg_Success.Text.SetBounds(10, 10, ex_load.Reg_Success.Panel.Width - 20, 30);
  ex_load.Reg_Success.Text.Font.Size := 18;
  ex_load.Reg_Success.Text.Text := 'Please wait to complete the registeration...';
  ex_load.Reg_Success.Text.TextSettings.FontColor := TAlphaColorRec.White;
  ex_load.Reg_Success.Text.Visible := True;

  ex_load.Reg_Success.Indicator := TAniIndicator.Create(ex_load.Reg_Success.Panel);
  ex_load.Reg_Success.Indicator.Name := 'Loading_Register_Success_AniIndicator';
  ex_load.Reg_Success.Indicator.Parent := ex_load.Reg_Success.Panel;
  ex_load.Reg_Success.Indicator.SetBounds((ex_load.Reg_Success.Panel.Width / 2) - 40, 70, 80, 80);
  ex_load.Reg_Success.Indicator.Enabled := True;

  ex_load.Reg_Success.Timer := TTimer.Create(ex_load.Reg_Success.Panel);
  ex_load.Reg_Success.Timer.Name := 'Loading_Register_Success_Timer';
  ex_load.Reg_Success.Timer.Parent := ex_load.Reg_Success.Panel;
  ex_load.Reg_Success.Timer.Interval := 100;
  ex_load.Reg_Success.Timer.OnTimer := ex_load.Reg_Success.Success_Timer.OnTimer;
  ex_load.Reg_Success.Timer.Enabled := True;
end;

end.
