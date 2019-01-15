unit uMain_Config_Profile;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UITypes,
  FMX.Objects,
  FMX.Types,
  FMX.Edit,
  FMX.StdCtrls,
  FMX.TabControl,
  FMX.Filter.Effects,
  FMX.Effects;

type
  TPROFILE_AVATAR_VARIABLES = record
    Page: Integer;
    Checked: Integer;
  end;

procedure uMain_Config_Profile_Create;

procedure uMain_Config_Profile_ReturnToProfile;

procedure uMain_Config_Profile_ShowAvatar;
procedure uMain_Config_Profile_Avatar_ShowPage(vPage: Byte);
procedure uMain_Config_Profile_Avatar_Select(vNum: Integer);
procedure uMain_Config_Profile_Avatar_Change;

procedure uMain_Config_Profile_ShowPassword;
function uMain_Config_Profile_Password_Check: Boolean;
procedure uMain_Config_Profile_Password_Change;

var
  vAvatar: TPROFILE_AVATAR_VARIABLES;

implementation

uses
  main,
  uWindows,
  uLoad,
  uLoad_AllTypes,
  uMain_SetAll,
  uMain_AllTypes,
  uMain_Mouse,
  uLoad_UserAccount,
  uDatabase_SqlCommands;

procedure uMain_Config_Profile_Create;
const
  cTab_Names: array [0 .. 2] of string = ('User', 'Statistics', 'Machine');
var
  vi, li, ki: Integer;
begin
  mainScene.Config.main.R.Profile.Panel := TPanel.Create(mainScene.Config.main.R.Panel[0]);
  mainScene.Config.main.R.Profile.Panel.Name := 'Main_Config_Profile_Main_Panel';
  mainScene.Config.main.R.Profile.Panel.Parent := mainScene.Config.main.R.Panel[0];
  mainScene.Config.main.R.Profile.Panel.Align := TAlignLayout.Client;
  mainScene.Config.main.R.Profile.Panel.Visible := True;

  mainScene.Config.main.R.Profile.Blur :=
    TGaussianBlurEffect.Create(mainScene.Config.main.R.Profile.Panel);
  mainScene.Config.main.R.Profile.Blur.Name := 'Main_Config_Profile_Main_Blur';
  mainScene.Config.main.R.Profile.Blur.Parent := mainScene.Config.main.R.Profile.Panel;
  mainScene.Config.main.R.Profile.Blur.BlurAmount := 0.5;
  mainScene.Config.main.R.Profile.Blur.Enabled := False;

  mainScene.Config.main.R.Profile.TabControl :=
    TTabControl.Create(mainScene.Config.main.R.Profile.Panel);
  mainScene.Config.main.R.Profile.TabControl.Name := 'Main_Config_Profile_Main_TabContol';
  mainScene.Config.main.R.Profile.TabControl.Parent := mainScene.Config.main.R.Profile.Panel;
  mainScene.Config.main.R.Profile.TabControl.Align := TAlignLayout.Client;
  mainScene.Config.main.R.Profile.TabControl.Visible := True;

  for vi := 0 to 2 do
  begin
    mainScene.Config.main.R.Profile.TabItem[vi] :=
      TTabItem.Create(mainScene.Config.main.R.Profile.TabControl);
    mainScene.Config.main.R.Profile.TabItem[vi].Name := 'Main_Config_Profile_Main_TabItem_' + IntToStr(vi);
    mainScene.Config.main.R.Profile.TabItem[vi].Parent := mainScene.Config.main.R.Profile.TabControl;
    mainScene.Config.main.R.Profile.TabItem[vi].Text := cTab_Names[vi];
    mainScene.Config.main.R.Profile.TabItem[vi].Width := mainScene.Config.main.R.Profile.TabControl.Width;
    mainScene.Config.main.R.Profile.TabItem[vi].Height := mainScene.Config.main.R.Profile.TabControl.Height;
    mainScene.Config.main.R.Profile.TabItem[vi].Visible := True;
  end;

  // User
  mainScene.Config.main.R.Profile.User.Avatar_Show :=
    TImage.Create(mainScene.Config.main.R.Profile.TabItem[0]);
  mainScene.Config.main.R.Profile.User.Avatar_Show.Name := 'Main_Config_Profile_Main_Avatar';
  mainScene.Config.main.R.Profile.User.Avatar_Show.Parent := mainScene.Config.main.R.Profile.TabItem[0];
  mainScene.Config.main.R.Profile.User.Avatar_Show.Width := 150;
  mainScene.Config.main.R.Profile.User.Avatar_Show.Height := 150;
  mainScene.Config.main.R.Profile.User.Avatar_Show.Position.X := 10;
  mainScene.Config.main.R.Profile.User.Avatar_Show.Position.Y := 10;
  mainScene.Config.main.R.Profile.User.Avatar_Show.Bitmap.LoadFromFile(ex_main.Paths.Avatar_Images +
    User.data.Avatar + '.png');
  mainScene.Config.main.R.Profile.User.Avatar_Show.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.main.R.Profile.User.Avatar_Show.Visible := True;

  mainScene.Config.main.R.Profile.User.Avatar_Change :=
    TText.Create(mainScene.Config.main.R.Profile.TabItem[0]);
  mainScene.Config.main.R.Profile.User.Avatar_Change.Name := 'Main_Config_Profile_Main_Avatar_Change';
  mainScene.Config.main.R.Profile.User.Avatar_Change.Parent := mainScene.Config.main.R.Profile.TabItem[0];
  mainScene.Config.main.R.Profile.User.Avatar_Change.Width := 200;
  mainScene.Config.main.R.Profile.User.Avatar_Change.Height := 24;
  mainScene.Config.main.R.Profile.User.Avatar_Change.Position.X := 10;
  mainScene.Config.main.R.Profile.User.Avatar_Change.Position.Y := 170;
  mainScene.Config.main.R.Profile.User.Avatar_Change.Text := 'Change Avatar';
  mainScene.Config.main.R.Profile.User.Avatar_Change.HorzTextAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Profile.User.Avatar_Change.OnClick := ex_main.input.mouse_config.Text.OnMouseClick;
  mainScene.Config.main.R.Profile.User.Avatar_Change.OnMouseEnter :=
    ex_main.input.mouse_config.Text.OnMouseEnter;
  mainScene.Config.main.R.Profile.User.Avatar_Change.OnMouseLeave :=
    ex_main.input.mouse_config.Text.OnMouseLeave;
  mainScene.Config.main.R.Profile.User.Avatar_Change.Visible := True;

  mainScene.Config.main.R.Profile.User.Username := TLabel.Create(mainScene.Config.main.R.Profile.TabItem[0]);
  mainScene.Config.main.R.Profile.User.Username.Name := 'Main_Config_Profile_Main_Username_Label';
  mainScene.Config.main.R.Profile.User.Username.Parent := mainScene.Config.main.R.Profile.TabItem[0];
  mainScene.Config.main.R.Profile.User.Username.Width := 300;
  mainScene.Config.main.R.Profile.User.Username.Height := 24;
  mainScene.Config.main.R.Profile.User.Username.Position.X := 220;
  mainScene.Config.main.R.Profile.User.Username.Position.Y := 30;
  mainScene.Config.main.R.Profile.User.Username.Text := 'Username : ';
  mainScene.Config.main.R.Profile.User.Username.Visible := True;

  mainScene.Config.main.R.Profile.User.Username_V := TEdit.Create(mainScene.Config.main.R.Profile.TabItem[0]);
  mainScene.Config.main.R.Profile.User.Username_V.Name := 'Main_Config_Profile_Main_Username_Edit';
  mainScene.Config.main.R.Profile.User.Username_V.Parent := mainScene.Config.main.R.Profile.TabItem[0];
  mainScene.Config.main.R.Profile.User.Username_V.Width := 370;
  mainScene.Config.main.R.Profile.User.Username_V.Height := 24;
  mainScene.Config.main.R.Profile.User.Username_V.Position.X := 220;
  mainScene.Config.main.R.Profile.User.Username_V.Position.Y := 60;
  mainScene.Config.main.R.Profile.User.Username_V.Text := User.data.Username;
  mainScene.Config.main.R.Profile.User.Username_V.ReadOnly := True;
  mainScene.Config.main.R.Profile.User.Username_V.TextSettings.HorzAlign := TTextAlign.Center;
  mainScene.Config.main.R.Profile.User.Username_V.Visible := True;

  mainScene.Config.main.R.Profile.User.Password := TLabel.Create(mainScene.Config.main.R.Profile.TabItem[0]);
  mainScene.Config.main.R.Profile.User.Password.Name := 'Main_Config_Profile_Main_Password_Label';
  mainScene.Config.main.R.Profile.User.Password.Parent := mainScene.Config.main.R.Profile.TabItem[0];
  mainScene.Config.main.R.Profile.User.Password.Width := 300;
  mainScene.Config.main.R.Profile.User.Password.Height := 24;
  mainScene.Config.main.R.Profile.User.Password.Position.X := 220;
  mainScene.Config.main.R.Profile.User.Password.Position.Y := 100;
  mainScene.Config.main.R.Profile.User.Password.Text := 'Password : ';
  mainScene.Config.main.R.Profile.User.Password.Visible := True;

  mainScene.Config.main.R.Profile.User.Password_V := TEdit.Create(mainScene.Config.main.R.Profile.TabItem[0]);
  mainScene.Config.main.R.Profile.User.Password_V.Name := 'Main_Config_Profile_Main_Password_Edit';
  mainScene.Config.main.R.Profile.User.Password_V.Parent := mainScene.Config.main.R.Profile.TabItem[0];
  mainScene.Config.main.R.Profile.User.Password_V.Width := 370;
  mainScene.Config.main.R.Profile.User.Password_V.Height := 24;
  mainScene.Config.main.R.Profile.User.Password_V.Position.X := 220;
  mainScene.Config.main.R.Profile.User.Password_V.Position.Y := 130;
  mainScene.Config.main.R.Profile.User.Password_V.Text := User.data.Password;
  mainScene.Config.main.R.Profile.User.Password_V.ReadOnly := True;
  mainScene.Config.main.R.Profile.User.Password_V.TextSettings.HorzAlign := TTextAlign.Center;
  mainScene.Config.main.R.Profile.User.Password_V.Password := True;
  mainScene.Config.main.R.Profile.User.Password_V.Visible := True;

  mainScene.Config.main.R.Profile.User.Password_Change :=
    TText.Create(mainScene.Config.main.R.Profile.TabItem[0]);
  mainScene.Config.main.R.Profile.User.Password_Change.Name := 'Main_Config_Profile_Main_Password_Change';
  mainScene.Config.main.R.Profile.User.Password_Change.Parent := mainScene.Config.main.R.Profile.TabItem[0];
  mainScene.Config.main.R.Profile.User.Password_Change.Width := 200;
  mainScene.Config.main.R.Profile.User.Password_Change.Height := 24;
  mainScene.Config.main.R.Profile.User.Password_Change.Position.X := 390;
  mainScene.Config.main.R.Profile.User.Password_Change.Position.Y := 170;
  mainScene.Config.main.R.Profile.User.Password_Change.Text := 'Change Password';
  mainScene.Config.main.R.Profile.User.Password_Change.HorzTextAlign := TTextAlign.Trailing;
  mainScene.Config.main.R.Profile.User.Password_Change.OnClick :=
    ex_main.input.mouse_config.Text.OnMouseClick;
  mainScene.Config.main.R.Profile.User.Password_Change.OnMouseEnter :=
    ex_main.input.mouse_config.Text.OnMouseEnter;
  mainScene.Config.main.R.Profile.User.Password_Change.OnMouseLeave :=
    ex_main.input.mouse_config.Text.OnMouseLeave;
  mainScene.Config.main.R.Profile.User.Password_Change.Visible := True;

  mainScene.Config.main.R.Profile.User.Name := TLabel.Create(mainScene.Config.main.R.Profile.TabItem[0]);
  mainScene.Config.main.R.Profile.User.Name.Name := 'Main_Config_Profile_Main_Name_Label';
  mainScene.Config.main.R.Profile.User.Name.Parent := mainScene.Config.main.R.Profile.TabItem[0];
  mainScene.Config.main.R.Profile.User.Name.Width := 300;
  mainScene.Config.main.R.Profile.User.Name.Height := 24;
  mainScene.Config.main.R.Profile.User.Name.Position.X := 10;
  mainScene.Config.main.R.Profile.User.Name.Position.Y := 210;
  mainScene.Config.main.R.Profile.User.Name.Text := 'Name : ';
  mainScene.Config.main.R.Profile.User.Name.Visible := True;

  mainScene.Config.main.R.Profile.User.Name_V := TEdit.Create(mainScene.Config.main.R.Profile.TabItem[0]);
  mainScene.Config.main.R.Profile.User.Name_V.Name := 'Main_Config_Profile_Main_Name_Edit';
  mainScene.Config.main.R.Profile.User.Name_V.Parent := mainScene.Config.main.R.Profile.TabItem[0];
  mainScene.Config.main.R.Profile.User.Name_V.Width := 370;
  mainScene.Config.main.R.Profile.User.Name_V.Height := 24;
  mainScene.Config.main.R.Profile.User.Name_V.Position.X := 10;
  mainScene.Config.main.R.Profile.User.Name_V.Position.Y := 240;
  mainScene.Config.main.R.Profile.User.Name_V.Text := User.data.Name;
  mainScene.Config.main.R.Profile.User.Name_V.ReadOnly := True;
  mainScene.Config.main.R.Profile.User.Name_V.TextSettings.HorzAlign := TTextAlign.Center;
  mainScene.Config.main.R.Profile.User.Name_V.Visible := True;

  mainScene.Config.main.R.Profile.User.Gender := TImage.Create(mainScene.Config.main.R.Profile.TabItem[0]);
  mainScene.Config.main.R.Profile.User.Gender.Name := 'Main_Config_Profile_Main_Gender';
  mainScene.Config.main.R.Profile.User.Gender.Parent := mainScene.Config.main.R.Profile.TabItem[0];
  mainScene.Config.main.R.Profile.User.Gender.Width := 32;
  mainScene.Config.main.R.Profile.User.Gender.Height := 32;
  mainScene.Config.main.R.Profile.User.Gender.Position.X := 348;
  mainScene.Config.main.R.Profile.User.Gender.Position.Y := 272;
  if StrToBool(User.data.Genre) then
    mainScene.Config.main.R.Profile.User.Gender.Bitmap.LoadFromFile(ex_main.Paths.Config_Images +
      'config_male.png')
  else
    mainScene.Config.main.R.Profile.User.Gender.Bitmap.LoadFromFile(ex_main.Paths.Config_Images +
      'config_female.png');
  mainScene.Config.main.R.Profile.User.Gender.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.main.R.Profile.User.Gender.Visible := True;

  mainScene.Config.main.R.Profile.User.Surname := TLabel.Create(mainScene.Config.main.R.Profile.TabItem[0]);
  mainScene.Config.main.R.Profile.User.Surname.Name := 'Main_Config_Profile_Main_Surname_Label';
  mainScene.Config.main.R.Profile.User.Surname.Parent := mainScene.Config.main.R.Profile.TabItem[0];
  mainScene.Config.main.R.Profile.User.Surname.Width := 300;
  mainScene.Config.main.R.Profile.User.Surname.Height := 24;
  mainScene.Config.main.R.Profile.User.Surname.Position.X := 10;
  mainScene.Config.main.R.Profile.User.Surname.Position.Y := 280;
  mainScene.Config.main.R.Profile.User.Surname.Text := 'Surname : ';
  mainScene.Config.main.R.Profile.User.Surname.Visible := True;

  mainScene.Config.main.R.Profile.User.Surname_V := TEdit.Create(mainScene.Config.main.R.Profile.TabItem[0]);
  mainScene.Config.main.R.Profile.User.Surname_V.Name := 'Main_Config_Profile_Main_Surname_Edit';
  mainScene.Config.main.R.Profile.User.Surname_V.Parent := mainScene.Config.main.R.Profile.TabItem[0];
  mainScene.Config.main.R.Profile.User.Surname_V.Width := 370;
  mainScene.Config.main.R.Profile.User.Surname_V.Height := 24;
  mainScene.Config.main.R.Profile.User.Surname_V.Position.X := 10;
  mainScene.Config.main.R.Profile.User.Surname_V.Position.Y := 310;
  mainScene.Config.main.R.Profile.User.Surname_V.Text := User.data.Surname;
  mainScene.Config.main.R.Profile.User.Surname_V.ReadOnly := True;
  mainScene.Config.main.R.Profile.User.Surname_V.TextSettings.HorzAlign := TTextAlign.Center;
  mainScene.Config.main.R.Profile.User.Surname_V.Visible := True;

  mainScene.Config.main.R.Profile.User.Country := TImage.Create(mainScene.Config.main.R.Profile.TabItem[0]);
  mainScene.Config.main.R.Profile.User.Country.Name := 'Main_Config_Profile_Main_Country';
  mainScene.Config.main.R.Profile.User.Country.Parent := mainScene.Config.main.R.Profile.TabItem[0];
  mainScene.Config.main.R.Profile.User.Country.Width := 150;
  mainScene.Config.main.R.Profile.User.Country.Height := 120;
  mainScene.Config.main.R.Profile.User.Country.Position.X := 410;
  mainScene.Config.main.R.Profile.User.Country.Position.Y := 224;
  mainScene.Config.main.R.Profile.User.Country.Bitmap.LoadFromFile(ex_main.Paths.Flags_Images +
    User.data.Country_Code + '.png');
  mainScene.Config.main.R.Profile.User.Country.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.main.R.Profile.User.Country.Visible := True;

  mainScene.Config.main.R.Profile.User.Email := TImage.Create(mainScene.Config.main.R.Profile.TabItem[0]);
  mainScene.Config.main.R.Profile.User.Email.Name := 'Main_Config_Profile_Main_EMail';
  mainScene.Config.main.R.Profile.User.Email.Parent := mainScene.Config.main.R.Profile.TabItem[0];
  mainScene.Config.main.R.Profile.User.Email.Width := 32;
  mainScene.Config.main.R.Profile.User.Email.Height := 32;
  mainScene.Config.main.R.Profile.User.Email.Position.X := 10;
  mainScene.Config.main.R.Profile.User.Email.Position.Y := 360;
  mainScene.Config.main.R.Profile.User.Email.Bitmap.LoadFromFile(ex_main.Paths.Config_Images +
    'config_email.png');
  mainScene.Config.main.R.Profile.User.Email.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.main.R.Profile.User.Email.Visible := True;

  mainScene.Config.main.R.Profile.User.Email_Dir := TText.Create(mainScene.Config.main.R.Profile.TabItem[0]);
  mainScene.Config.main.R.Profile.User.Email_Dir.Name := 'Main_Config_Profile_Main_EMail_Dir';
  mainScene.Config.main.R.Profile.User.Email_Dir.Parent := mainScene.Config.main.R.Profile.TabItem[0];
  mainScene.Config.main.R.Profile.User.Email_Dir.Width := 400;
  mainScene.Config.main.R.Profile.User.Email_Dir.Height := 24;
  mainScene.Config.main.R.Profile.User.Email_Dir.Position.X := 56;
  mainScene.Config.main.R.Profile.User.Email_Dir.Position.Y := 366;
  mainScene.Config.main.R.Profile.User.Email_Dir.Text := User.data.Email;
  mainScene.Config.main.R.Profile.User.Email_Dir.HorzTextAlign := TTextAlign.Leading;
  mainScene.Config.main.R.Profile.User.Email_Dir.Visible := True;

  // Statistics

  // Machine
  mainScene.Config.main.R.Profile.Machine.Computer :=
    TGroupBox.Create(mainScene.Config.main.R.Profile.TabItem[2]);
  mainScene.Config.main.R.Profile.Machine.Computer.Name := 'Main_Config_Profile_Machine_Computer';
  mainScene.Config.main.R.Profile.Machine.Computer.Parent := mainScene.Config.main.R.Profile.TabItem[2];
  mainScene.Config.main.R.Profile.Machine.Computer.Width := 580;
  mainScene.Config.main.R.Profile.Machine.Computer.Height := 210;
  mainScene.Config.main.R.Profile.Machine.Computer.Position.X := 10;
  mainScene.Config.main.R.Profile.Machine.Computer.Position.Y := 10;
  mainScene.Config.main.R.Profile.Machine.Computer.Text := 'Computer : ';
  mainScene.Config.main.R.Profile.Machine.Computer.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Computer_Info :=
    TLabel.Create(mainScene.Config.main.R.Profile.Machine.Computer);
  mainScene.Config.main.R.Profile.Machine.Computer_Info.Name :=
    'Main_Config_Profile_Machine_Computer_Info_Label';
  mainScene.Config.main.R.Profile.Machine.Computer_Info.Parent :=
    mainScene.Config.main.R.Profile.Machine.Computer;
  mainScene.Config.main.R.Profile.Machine.Computer_Info.Width := 140;
  mainScene.Config.main.R.Profile.Machine.Computer_Info.Height := 24;
  mainScene.Config.main.R.Profile.Machine.Computer_Info.Position.X := 10;
  mainScene.Config.main.R.Profile.Machine.Computer_Info.Position.Y := 20;
  mainScene.Config.main.R.Profile.Machine.Computer_Info.Text := 'Information : ';
  mainScene.Config.main.R.Profile.Machine.Computer_Info.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Computer_Info_V :=
    TLabel.Create(mainScene.Config.main.R.Profile.Machine.Computer);
  mainScene.Config.main.R.Profile.Machine.Computer_Info_V.Name :=
    'Main_Config_Profile_Machine_Computer_Info_V_Label';
  mainScene.Config.main.R.Profile.Machine.Computer_Info_V.Parent :=
    mainScene.Config.main.R.Profile.Machine.Computer;
  mainScene.Config.main.R.Profile.Machine.Computer_Info_V.Width := 440;
  mainScene.Config.main.R.Profile.Machine.Computer_Info_V.Height := 24;
  mainScene.Config.main.R.Profile.Machine.Computer_Info_V.Position.X := 140;
  mainScene.Config.main.R.Profile.Machine.Computer_Info_V.Position.Y := 20;
  mainScene.Config.main.R.Profile.Machine.Computer_Info_V.Text := TOSVersion.ToString;
  mainScene.Config.main.R.Profile.Machine.Computer_Info_V.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Computer_Architecture :=
    TLabel.Create(mainScene.Config.main.R.Profile.Machine.Computer);
  mainScene.Config.main.R.Profile.Machine.Computer_Architecture.Name :=
    'Main_Config_Profile_Machine_Computer_Architecture_Label';
  mainScene.Config.main.R.Profile.Machine.Computer_Architecture.Parent :=
    mainScene.Config.main.R.Profile.Machine.Computer;
  mainScene.Config.main.R.Profile.Machine.Computer_Architecture.Width := 140;
  mainScene.Config.main.R.Profile.Machine.Computer_Architecture.Height := 24;
  mainScene.Config.main.R.Profile.Machine.Computer_Architecture.Position.X := 10;
  mainScene.Config.main.R.Profile.Machine.Computer_Architecture.Position.Y := 60;
  mainScene.Config.main.R.Profile.Machine.Computer_Architecture.Text := 'Architecture : ';
  mainScene.Config.main.R.Profile.Machine.Computer_Architecture.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Computer_Architecture_V :=
    TLabel.Create(mainScene.Config.main.R.Profile.Machine.Computer);
  mainScene.Config.main.R.Profile.Machine.Computer_Architecture_V.Name :=
    'Main_Config_Profile_Machine_Computer_Architecture_V_Label';
  mainScene.Config.main.R.Profile.Machine.Computer_Architecture_V.Parent :=
    mainScene.Config.main.R.Profile.Machine.Computer;
  mainScene.Config.main.R.Profile.Machine.Computer_Architecture_V.Width := 140;
  mainScene.Config.main.R.Profile.Machine.Computer_Architecture_V.Height := 24;
  mainScene.Config.main.R.Profile.Machine.Computer_Architecture_V.Position.X := 140;
  mainScene.Config.main.R.Profile.Machine.Computer_Architecture_V.Position.Y := 60;
  mainScene.Config.main.R.Profile.Machine.Computer_Architecture_V.Text :=
    uWindows_OsArchitectureToStr(TOSVersion.Architecture);;
  mainScene.Config.main.R.Profile.Machine.Computer_Architecture_V.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Computer_Platform :=
    TLabel.Create(mainScene.Config.main.R.Profile.Machine.Computer);
  mainScene.Config.main.R.Profile.Machine.Computer_Platform.Name :=
    'Main_Config_Profile_Machine_Computer_Platform_Label';
  mainScene.Config.main.R.Profile.Machine.Computer_Platform.Parent :=
    mainScene.Config.main.R.Profile.Machine.Computer;
  mainScene.Config.main.R.Profile.Machine.Computer_Platform.Width := 140;
  mainScene.Config.main.R.Profile.Machine.Computer_Platform.Height := 24;
  mainScene.Config.main.R.Profile.Machine.Computer_Platform.Position.X := 10;
  mainScene.Config.main.R.Profile.Machine.Computer_Platform.Position.Y := 84;
  mainScene.Config.main.R.Profile.Machine.Computer_Platform.Text := 'Platform : ';
  mainScene.Config.main.R.Profile.Machine.Computer_Platform.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Computer_Platform_V :=
    TLabel.Create(mainScene.Config.main.R.Profile.Machine.Computer);
  mainScene.Config.main.R.Profile.Machine.Computer_Platform_V.Name :=
    'Main_Config_Profile_Machine_Computer_Platform_V_Label';
  mainScene.Config.main.R.Profile.Machine.Computer_Platform_V.Parent :=
    mainScene.Config.main.R.Profile.Machine.Computer;
  mainScene.Config.main.R.Profile.Machine.Computer_Platform_V.Width := 140;
  mainScene.Config.main.R.Profile.Machine.Computer_Platform_V.Height := 24;
  mainScene.Config.main.R.Profile.Machine.Computer_Platform_V.Position.X := 140;
  mainScene.Config.main.R.Profile.Machine.Computer_Platform_V.Position.Y := 84;
  mainScene.Config.main.R.Profile.Machine.Computer_Platform_V.Text :=
    uWindows_OsPlatformToStr(TOSVersion.Platform) + ' ' + IntToStr(uWindoes_OsPlatformPointerToInt) + ' bit';
  mainScene.Config.main.R.Profile.Machine.Computer_Platform_V.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Computer_Operating_System :=
    TLabel.Create(mainScene.Config.main.R.Profile.Machine.Computer);
  mainScene.Config.main.R.Profile.Machine.Computer_Operating_System.Name :=
    'Main_Config_Profile_Machine_Computer_OperatingSystem_Label';
  mainScene.Config.main.R.Profile.Machine.Computer_Operating_System.Parent :=
    mainScene.Config.main.R.Profile.Machine.Computer;
  mainScene.Config.main.R.Profile.Machine.Computer_Operating_System.Width := 140;
  mainScene.Config.main.R.Profile.Machine.Computer_Operating_System.Height := 24;
  mainScene.Config.main.R.Profile.Machine.Computer_Operating_System.Position.X := 10;
  mainScene.Config.main.R.Profile.Machine.Computer_Operating_System.Position.Y := 108;
  mainScene.Config.main.R.Profile.Machine.Computer_Operating_System.Text := 'Operating System : ';
  mainScene.Config.main.R.Profile.Machine.Computer_Operating_System.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Computer_Operating_System_V :=
    TLabel.Create(mainScene.Config.main.R.Profile.Machine.Computer);
  mainScene.Config.main.R.Profile.Machine.Computer_Operating_System_V.Name :=
    'Main_Config_Profile_Machine_Computer_OperatingSystem_V_Label';
  mainScene.Config.main.R.Profile.Machine.Computer_Operating_System_V.Parent :=
    mainScene.Config.main.R.Profile.Machine.Computer;
  mainScene.Config.main.R.Profile.Machine.Computer_Operating_System_V.Width := 140;
  mainScene.Config.main.R.Profile.Machine.Computer_Operating_System_V.Height := 24;
  mainScene.Config.main.R.Profile.Machine.Computer_Operating_System_V.Position.X := 140;
  mainScene.Config.main.R.Profile.Machine.Computer_Operating_System_V.Position.Y := 108;
  mainScene.Config.main.R.Profile.Machine.Computer_Operating_System_V.Text := TOSVersion.Name;
  mainScene.Config.main.R.Profile.Machine.Computer_Operating_System_V.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Computer_Major :=
    TLabel.Create(mainScene.Config.main.R.Profile.Machine.Computer);
  mainScene.Config.main.R.Profile.Machine.Computer_Major.Name :=
    'Main_Config_Profile_Machine_Computer_Major_Label';
  mainScene.Config.main.R.Profile.Machine.Computer_Major.Parent :=
    mainScene.Config.main.R.Profile.Machine.Computer;
  mainScene.Config.main.R.Profile.Machine.Computer_Major.Width := 140;
  mainScene.Config.main.R.Profile.Machine.Computer_Major.Height := 24;
  mainScene.Config.main.R.Profile.Machine.Computer_Major.Position.X := 10;
  mainScene.Config.main.R.Profile.Machine.Computer_Major.Position.Y := 132;
  mainScene.Config.main.R.Profile.Machine.Computer_Major.Text := 'Major : ';
  mainScene.Config.main.R.Profile.Machine.Computer_Major.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Computer_Major_V :=
    TLabel.Create(mainScene.Config.main.R.Profile.Machine.Computer);
  mainScene.Config.main.R.Profile.Machine.Computer_Major_V.Name :=
    'Main_Config_Profile_Machine_Computer_Major_V_Label';
  mainScene.Config.main.R.Profile.Machine.Computer_Major_V.Parent :=
    mainScene.Config.main.R.Profile.Machine.Computer;
  mainScene.Config.main.R.Profile.Machine.Computer_Major_V.Width := 140;
  mainScene.Config.main.R.Profile.Machine.Computer_Major_V.Height := 24;
  mainScene.Config.main.R.Profile.Machine.Computer_Major_V.Position.X := 140;
  mainScene.Config.main.R.Profile.Machine.Computer_Major_V.Position.Y := 132;
  mainScene.Config.main.R.Profile.Machine.Computer_Major_V.Text := IntToStr(TOSVersion.Major);
  mainScene.Config.main.R.Profile.Machine.Computer_Major_V.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Computer_Minor :=
    TLabel.Create(mainScene.Config.main.R.Profile.Machine.Computer);
  mainScene.Config.main.R.Profile.Machine.Computer_Minor.Name :=
    'Main_Config_Profile_Machine_Computer_Minor_Label';
  mainScene.Config.main.R.Profile.Machine.Computer_Minor.Parent :=
    mainScene.Config.main.R.Profile.Machine.Computer;
  mainScene.Config.main.R.Profile.Machine.Computer_Minor.Width := 140;
  mainScene.Config.main.R.Profile.Machine.Computer_Minor.Height := 24;
  mainScene.Config.main.R.Profile.Machine.Computer_Minor.Position.X := 10;
  mainScene.Config.main.R.Profile.Machine.Computer_Minor.Position.Y := 156;
  mainScene.Config.main.R.Profile.Machine.Computer_Minor.Text := 'Minor : ';
  mainScene.Config.main.R.Profile.Machine.Computer_Minor.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Computer_Minor_V :=
    TLabel.Create(mainScene.Config.main.R.Profile.Machine.Computer);
  mainScene.Config.main.R.Profile.Machine.Computer_Minor_V.Name :=
    'Main_Config_Profile_Machine_Computer_Minor_V_Label';
  mainScene.Config.main.R.Profile.Machine.Computer_Minor_V.Parent :=
    mainScene.Config.main.R.Profile.Machine.Computer;
  mainScene.Config.main.R.Profile.Machine.Computer_Minor_V.Width := 140;
  mainScene.Config.main.R.Profile.Machine.Computer_Minor_V.Height := 24;
  mainScene.Config.main.R.Profile.Machine.Computer_Minor_V.Position.X := 140;
  mainScene.Config.main.R.Profile.Machine.Computer_Minor_V.Position.Y := 156;
  mainScene.Config.main.R.Profile.Machine.Computer_Minor_V.Text := IntToStr(TOSVersion.Minor);
  mainScene.Config.main.R.Profile.Machine.Computer_Minor_V.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Computer_Build :=
    TLabel.Create(mainScene.Config.main.R.Profile.Machine.Computer);
  mainScene.Config.main.R.Profile.Machine.Computer_Build.Name :=
    'Main_Config_Profile_Machine_Computer_Build_Label';
  mainScene.Config.main.R.Profile.Machine.Computer_Build.Parent :=
    mainScene.Config.main.R.Profile.Machine.Computer;
  mainScene.Config.main.R.Profile.Machine.Computer_Build.Width := 140;
  mainScene.Config.main.R.Profile.Machine.Computer_Build.Height := 24;
  mainScene.Config.main.R.Profile.Machine.Computer_Build.Position.X := 10;
  mainScene.Config.main.R.Profile.Machine.Computer_Build.Position.Y := 180;
  mainScene.Config.main.R.Profile.Machine.Computer_Build.Text := 'Build : ';
  mainScene.Config.main.R.Profile.Machine.Computer_Build.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Computer_Build_V :=
    TLabel.Create(mainScene.Config.main.R.Profile.Machine.Computer);
  mainScene.Config.main.R.Profile.Machine.Computer_Build_V.Name :=
    'Main_Config_Profile_Machine_Computer_Build_V_Label';
  mainScene.Config.main.R.Profile.Machine.Computer_Build_V.Parent :=
    mainScene.Config.main.R.Profile.Machine.Computer;
  mainScene.Config.main.R.Profile.Machine.Computer_Build_V.Width := 140;
  mainScene.Config.main.R.Profile.Machine.Computer_Build_V.Height := 24;
  mainScene.Config.main.R.Profile.Machine.Computer_Build_V.Position.X := 140;
  mainScene.Config.main.R.Profile.Machine.Computer_Build_V.Position.Y := 180;
  mainScene.Config.main.R.Profile.Machine.Computer_Build_V.Text := IntToStr(TOSVersion.Build);
  mainScene.Config.main.R.Profile.Machine.Computer_Build_V.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Interner :=
    TGroupBox.Create(mainScene.Config.main.R.Profile.TabItem[2]);
  mainScene.Config.main.R.Profile.Machine.Interner.Name := 'Main_Config_Profile_Machine_Internet';
  mainScene.Config.main.R.Profile.Machine.Interner.Parent := mainScene.Config.main.R.Profile.TabItem[2];
  mainScene.Config.main.R.Profile.Machine.Interner.Width := 580;
  mainScene.Config.main.R.Profile.Machine.Interner.Height := 150;
  mainScene.Config.main.R.Profile.Machine.Interner.Position.X := 10;
  mainScene.Config.main.R.Profile.Machine.Interner.Position.Y := 230;
  mainScene.Config.main.R.Profile.Machine.Interner.Text := 'Internet : ';
  mainScene.Config.main.R.Profile.Machine.Interner.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Interner_Internet :=
    TLabel.Create(mainScene.Config.main.R.Profile.Machine.Interner);
  mainScene.Config.main.R.Profile.Machine.Interner_Internet.Name :=
    'Main_Config_Profile_Machine_Internet_Internet_Label';
  mainScene.Config.main.R.Profile.Machine.Interner_Internet.Parent :=
    mainScene.Config.main.R.Profile.Machine.Interner;
  mainScene.Config.main.R.Profile.Machine.Interner_Internet.Width := 140;
  mainScene.Config.main.R.Profile.Machine.Interner_Internet.Height := 24;
  mainScene.Config.main.R.Profile.Machine.Interner_Internet.Position.X := 10;
  mainScene.Config.main.R.Profile.Machine.Interner_Internet.Position.Y := 20;
  mainScene.Config.main.R.Profile.Machine.Interner_Internet.Text := 'Internet : ';
  mainScene.Config.main.R.Profile.Machine.Interner_Internet.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Interner_Internet_V :=
    TLabel.Create(mainScene.Config.main.R.Profile.Machine.Interner);
  mainScene.Config.main.R.Profile.Machine.Interner_Internet_V.Name :=
    'Main_Config_Profile_Machine_Info_V_Label';
  mainScene.Config.main.R.Profile.Machine.Interner_Internet_V.Parent :=
    mainScene.Config.main.R.Profile.Machine.Interner;
  mainScene.Config.main.R.Profile.Machine.Interner_Internet_V.Width := 440;
  mainScene.Config.main.R.Profile.Machine.Interner_Internet_V.Height := 24;
  mainScene.Config.main.R.Profile.Machine.Interner_Internet_V.Position.X := 140;
  mainScene.Config.main.R.Profile.Machine.Interner_Internet_V.Position.Y := 20;
  if uWindows_IsConected_ToInternet then
    mainScene.Config.main.R.Profile.Machine.Interner_Internet_V.Text := 'Connected'
  else
    mainScene.Config.main.R.Profile.Machine.Interner_Internet_V.Text := 'Disconnected';
  mainScene.Config.main.R.Profile.Machine.Interner_Internet_V.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Interner_IPAddress :=
    TLabel.Create(mainScene.Config.main.R.Profile.Machine.Interner);
  mainScene.Config.main.R.Profile.Machine.Interner_IPAddress.Name :=
    'Main_Config_Profile_Machine_Internet_IPAddress_Label';
  mainScene.Config.main.R.Profile.Machine.Interner_IPAddress.Parent :=
    mainScene.Config.main.R.Profile.Machine.Interner;
  mainScene.Config.main.R.Profile.Machine.Interner_IPAddress.Width := 140;
  mainScene.Config.main.R.Profile.Machine.Interner_IPAddress.Height := 24;
  mainScene.Config.main.R.Profile.Machine.Interner_IPAddress.Position.X := 10;
  mainScene.Config.main.R.Profile.Machine.Interner_IPAddress.Position.Y := 44;
  mainScene.Config.main.R.Profile.Machine.Interner_IPAddress.Text := 'IP Address : ';
  mainScene.Config.main.R.Profile.Machine.Interner_IPAddress.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Interner_IPAddress_V :=
    TLabel.Create(mainScene.Config.main.R.Profile.Machine.Interner);
  mainScene.Config.main.R.Profile.Machine.Interner_IPAddress_V.Name :=
    'Main_Config_Profile_Machine_Internet_IPAddress_V_Label';
  mainScene.Config.main.R.Profile.Machine.Interner_IPAddress_V.Parent :=
    mainScene.Config.main.R.Profile.Machine.Interner;
  mainScene.Config.main.R.Profile.Machine.Interner_IPAddress_V.Width := 140;
  mainScene.Config.main.R.Profile.Machine.Interner_IPAddress_V.Height := 24;
  mainScene.Config.main.R.Profile.Machine.Interner_IPAddress_V.Position.X := 140;
  mainScene.Config.main.R.Profile.Machine.Interner_IPAddress_V.Position.Y := 44;
  mainScene.Config.main.R.Profile.Machine.Interner_IPAddress_V.Text := uWindows_GetIPAddress;
  mainScene.Config.main.R.Profile.Machine.Interner_IPAddress_V.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Interner_DNSServers :=
    TLabel.Create(mainScene.Config.main.R.Profile.Machine.Interner);
  mainScene.Config.main.R.Profile.Machine.Interner_DNSServers.Name :=
    'Main_Config_Profile_Machine_Internet_DNSServer_Label';
  mainScene.Config.main.R.Profile.Machine.Interner_DNSServers.Parent :=
    mainScene.Config.main.R.Profile.Machine.Interner;
  mainScene.Config.main.R.Profile.Machine.Interner_DNSServers.Width := 140;
  mainScene.Config.main.R.Profile.Machine.Interner_DNSServers.Height := 24;
  mainScene.Config.main.R.Profile.Machine.Interner_DNSServers.Position.X := 10;
  mainScene.Config.main.R.Profile.Machine.Interner_DNSServers.Position.Y := 68;
  mainScene.Config.main.R.Profile.Machine.Interner_DNSServers.Text := 'DNS Server : ';
  mainScene.Config.main.R.Profile.Machine.Interner_DNSServers.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Interner_DNSServers_V :=
    TLabel.Create(mainScene.Config.main.R.Profile.Machine.Interner);
  mainScene.Config.main.R.Profile.Machine.Interner_DNSServers_V.Name :=
    'Main_Config_Profile_Machine_Internet_DNSServer_V_Label';
  mainScene.Config.main.R.Profile.Machine.Interner_DNSServers_V.Parent :=
    mainScene.Config.main.R.Profile.Machine.Interner;
  mainScene.Config.main.R.Profile.Machine.Interner_DNSServers_V.Width := 140;
  mainScene.Config.main.R.Profile.Machine.Interner_DNSServers_V.Height := 24;
  mainScene.Config.main.R.Profile.Machine.Interner_DNSServers_V.Position.X := 140;
  mainScene.Config.main.R.Profile.Machine.Interner_DNSServers_V.Position.Y := 68;
  mainScene.Config.main.R.Profile.Machine.Interner_DNSServers_V.Text := '';
  mainScene.Config.main.R.Profile.Machine.Interner_DNSServers_V.Visible := True;

  if (extrafe.style.Name = 'Amakrits') or (extrafe.style.Name = 'Dark') or (extrafe.style.Name = 'Air') then
  begin
    mainScene.Config.main.R.Profile.User.Avatar_Change.TextSettings.FontColor := TAlphaColorRec.White;
    mainScene.Config.main.R.Profile.User.Password_Change.TextSettings.FontColor := TAlphaColorRec.White;
    mainScene.Config.main.R.Profile.User.Email_Dir.TextSettings.FontColor := TAlphaColorRec.White;
  end
  else
  begin
    mainScene.Config.main.R.Profile.User.Avatar_Change.TextSettings.FontColor := TAlphaColorRec.Black;
    mainScene.Config.main.R.Profile.User.Password_Change.TextSettings.FontColor := TAlphaColorRec.Black;
    mainScene.Config.main.R.Profile.User.Email_Dir.TextSettings.FontColor := TAlphaColorRec.Black;
  end;
end;

procedure uMain_Config_Profile_ReturnToProfile;
begin
  extrafe.prog.State := 'main_config';
  mainScene.Config.main.R.Profile.Blur.Enabled := False;
  mainScene.Config.Main.Left_Blur.Enabled:= False;
  FreeAndNil(mainScene.Config.main.R.Profile.User.Avatar.Panel);
  FreeAndNil(mainScene.Config.main.R.Profile.User.Pass.Panel);
end;

procedure uMain_Config_Profile_ShowAvatar;
var
  vi, li, ki: Integer;
begin

  extrafe.prog.State := 'main_config_profile_avatar';
  mainScene.Config.Main.Left_Blur.Enabled := True;
  mainScene.Config.main.R.Profile.Blur.Enabled := True;

  // Avatar panel
  mainScene.Config.main.R.Profile.User.Avatar.Panel := TPanel.Create(mainScene.Config.main.R.Panel[0]);
  mainScene.Config.main.R.Profile.User.Avatar.Panel.Name := 'Main_Config_Profile_Avatar_Panel';
  mainScene.Config.main.R.Profile.User.Avatar.Panel.Parent := mainScene.Config.main.R.Panel[0];
  mainScene.Config.main.R.Profile.User.Avatar.Panel.Width := 560;
  mainScene.Config.main.R.Profile.User.Avatar.Panel.Height := 560;
  mainScene.Config.main.R.Profile.User.Avatar.Panel.Position.X :=
    (mainScene.Config.main.R.Panel[0].Width / 2) - 280;
  mainScene.Config.main.R.Profile.User.Avatar.Panel.Position.Y :=
    (mainScene.Config.main.R.Panel[0].Height / 2) - 280;
  mainScene.Config.main.R.Profile.User.Avatar.Panel.Visible := False;

  mainScene.Config.main.R.Profile.User.Avatar.Header.Panel :=
    TPanel.Create(mainScene.Config.main.R.Profile.User.Avatar.Panel);
  mainScene.Config.main.R.Profile.User.Avatar.Header.Panel.Name := 'Main_Config_Profile_Avatar_Header_Panel';
  mainScene.Config.main.R.Profile.User.Avatar.Header.Panel.Parent :=
    mainScene.Config.main.R.Profile.User.Avatar.Panel;
  mainScene.Config.main.R.Profile.User.Avatar.Header.Panel.Width :=
    mainScene.Config.main.R.Profile.User.Avatar.Panel.Width;
  mainScene.Config.main.R.Profile.User.Avatar.Header.Panel.Height := 30;
  mainScene.Config.main.R.Profile.User.Avatar.Header.Panel.Position.X := 0;
  mainScene.Config.main.R.Profile.User.Avatar.Header.Panel.Position.Y := 0;
  mainScene.Config.main.R.Profile.User.Avatar.Header.Panel.Visible := True;

  mainScene.Config.main.R.Profile.User.Avatar.Header.Icon :=
    TImage.Create(mainScene.Config.main.R.Profile.User.Avatar.Header.Panel);
  mainScene.Config.main.R.Profile.User.Avatar.Header.Icon.Name := 'Main_Config_Profile_Avatar_Header_Icon';
  mainScene.Config.main.R.Profile.User.Avatar.Header.Icon.Parent :=
    mainScene.Config.main.R.Profile.User.Avatar.Header.Panel;
  mainScene.Config.main.R.Profile.User.Avatar.Header.Icon.Width := 24;
  mainScene.Config.main.R.Profile.User.Avatar.Header.Icon.Height := 24;
  mainScene.Config.main.R.Profile.User.Avatar.Header.Icon.Position.X := 6;
  mainScene.Config.main.R.Profile.User.Avatar.Header.Icon.Position.Y := 3;
  mainScene.Config.main.R.Profile.User.Avatar.Header.Icon.Bitmap.LoadFromFile
    (ex_main.Paths.Avatar_Images + '0.png');
  mainScene.Config.main.R.Profile.User.Avatar.Header.Icon.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.main.R.Profile.User.Avatar.Header.Icon.Visible := True;

  mainScene.Config.main.R.Profile.User.Avatar.Header.Text :=
    TLabel.Create(mainScene.Config.main.R.Profile.User.Avatar.Header.Panel);
  mainScene.Config.main.R.Profile.User.Avatar.Header.Text.Name := 'Main_Config_Profile_Avatar_Header_Label';
  mainScene.Config.main.R.Profile.User.Avatar.Header.Text.Parent :=
    mainScene.Config.main.R.Profile.User.Avatar.Header.Panel;
  mainScene.Config.main.R.Profile.User.Avatar.Header.Text.Width := 300;
  mainScene.Config.main.R.Profile.User.Avatar.Header.Text.Height := 24;
  mainScene.Config.main.R.Profile.User.Avatar.Header.Text.Position.X := 36;
  mainScene.Config.main.R.Profile.User.Avatar.Header.Text.Position.Y := 3;
  mainScene.Config.main.R.Profile.User.Avatar.Header.Text.Text := 'Change the avatar';
  mainScene.Config.main.R.Profile.User.Avatar.Header.Text.Visible := True;

  mainScene.Config.main.R.Profile.User.Avatar.main.Panel :=
    TPanel.Create(mainScene.Config.main.R.Profile.User.Avatar.Panel);
  mainScene.Config.main.R.Profile.User.Avatar.main.Panel.Name := 'Main_Config_Profile_Avatar_Main_Panel';
  mainScene.Config.main.R.Profile.User.Avatar.main.Panel.Parent :=
    mainScene.Config.main.R.Profile.User.Avatar.Panel;
  mainScene.Config.main.R.Profile.User.Avatar.main.Panel.Width :=
    mainScene.Config.main.R.Profile.User.Avatar.Panel.Width;
  mainScene.Config.main.R.Profile.User.Avatar.main.Panel.Height :=
    mainScene.Config.main.R.Profile.User.Avatar.Panel.Height - 30;
  mainScene.Config.main.R.Profile.User.Avatar.main.Panel.Position.X := 0;
  mainScene.Config.main.R.Profile.User.Avatar.main.Panel.Position.Y := 30;
  mainScene.Config.main.R.Profile.User.Avatar.main.Panel.Visible := True;

  li := 0;
  ki := 0;

  for vi := 0 to 19 do
  begin
    if (vi = 5) or (vi = 10) or (vi = 15) then
      Inc(ki, 1);
    if li > 4 then
      li := 0;

    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar[vi] :=
      TImage.Create(mainScene.Config.main.R.Profile.User.Avatar.main.Panel);
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar[vi].Name := 'Main_Config_Profile_Avatar_Image_' +
      IntToStr(vi);
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar[vi].Parent :=
      mainScene.Config.main.R.Profile.User.Avatar.main.Panel;
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar[vi].Width := 100;
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar[vi].Height := 100;
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar[vi].Position.X := 10 + (li * 110);
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar[vi].Position.Y := 10 + (ki * 110);
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar[vi].Bitmap.LoadFromFile
      (ex_main.Paths.Avatar_Images + '0.png');
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar[vi].WrapMode := TImageWrapMode.Fit;
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar[vi].Tag := vi;
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar[vi].OnClick :=
      ex_main.input.mouse_config.Image.OnMouseClick;
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar[vi].OnMouseEnter :=
      ex_main.input.mouse_config.Image.OnMouseEnter;
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar[vi].OnMouseLeave :=
      ex_main.input.mouse_config.Image.OnMouseLeave;
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar[vi].Visible := True;

    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar_Check[vi] :=
      TImage.Create(mainScene.Config.main.R.Profile.User.Avatar.main.Avatar[vi]);
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar_Check[vi].Name :=
      'Main_Config_Profile_Avatar_Image_' + IntToStr(vi);
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar_Check[vi].Parent :=
      mainScene.Config.main.R.Profile.User.Avatar.main.Avatar[vi];
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar_Check[vi].Width := 24;
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar_Check[vi].Height := 24;
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar_Check[vi].Position.X := 0;
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar_Check[vi].Position.Y := 76;
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar_Check[vi].Bitmap.LoadFromFile
      (ex_main.Paths.Config_Images + 'config_check.png');
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar_Check[vi].WrapMode := TImageWrapMode.Fit;
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar_Check[vi].Visible := False;

    mainScene.Config.main.R.Profile.User.Avatar.main.AVatar_Glow[vi] :=
      TGlowEffect.Create(mainScene.Config.main.R.Profile.User.Avatar.main.Avatar[vi]);
    mainScene.Config.main.R.Profile.User.Avatar.main.AVatar_Glow[vi].Name :=
      'Main_Config_Profile_Avatar_Image_Glow_' + IntToStr(vi);
    mainScene.Config.main.R.Profile.User.Avatar.main.AVatar_Glow[vi].Parent :=
      mainScene.Config.main.R.Profile.User.Avatar.main.Avatar[vi];
    mainScene.Config.main.R.Profile.User.Avatar.main.AVatar_Glow[vi].GlowColor := TAlphaColorRec.Deepskyblue;
    mainScene.Config.main.R.Profile.User.Avatar.main.AVatar_Glow[vi].Softness := 0.5;
    mainScene.Config.main.R.Profile.User.Avatar.main.AVatar_Glow[vi].Opacity := 0.9;
    mainScene.Config.main.R.Profile.User.Avatar.main.AVatar_Glow[vi].Enabled := False;

    Inc(li, 1);
  end;

  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left :=
    TImage.Create(mainScene.Config.main.R.Profile.User.Avatar.main.Panel);
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left.Name := 'Main_Config_Profile_Avatar_Left';
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left.Parent :=
    mainScene.Config.main.R.Profile.User.Avatar.main.Panel;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left.Width := 24;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left.Height := 24;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left.Position.X :=
    (mainScene.Config.main.R.Profile.User.Avatar.main.Panel.Width / 2) - 40;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left.Position.Y := 460;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left.Bitmap.LoadFromFile
    (ex_main.Paths.Config_Images + 'config_previous.png');
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left.OnClick :=
    ex_main.input.mouse_config.Image.OnMouseClick;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left.OnMouseEnter :=
    ex_main.input.mouse_config.Image.OnMouseEnter;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left.OnMouseLeave :=
    ex_main.input.mouse_config.Image.OnMouseLeave;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left.Visible := True;

  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left_Glow :=
    TGlowEffect.Create(mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left);
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left_Glow.Name :=
    'Main_Config_Profile_Avatar_Left_Glow';
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left_Glow.Parent :=
    mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left_Glow.Softness := 0.5;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left_Glow.Opacity := 0.9;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Left_Glow.Enabled := False;

  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right :=
    TImage.Create(mainScene.Config.main.R.Profile.User.Avatar.main.Panel);
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right.Name := 'Main_Config_Profile_Avatar_Right';
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right.Parent :=
    mainScene.Config.main.R.Profile.User.Avatar.main.Panel;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right.Width := 24;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right.Height := 24;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right.Position.X :=
    (mainScene.Config.main.R.Profile.User.Avatar.main.Panel.Width / 2) + 20;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right.Position.Y := 460;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right.Bitmap.LoadFromFile
    (ex_main.Paths.Config_Images + 'config_next.png');
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right.OnClick :=
    ex_main.input.mouse_config.Image.OnMouseClick;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right.OnMouseEnter :=
    ex_main.input.mouse_config.Image.OnMouseEnter;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right.OnMouseLeave :=
    ex_main.input.mouse_config.Image.OnMouseLeave;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right.Visible := True;

  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right_Glow :=
    TGlowEffect.Create(mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right);
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right_Glow.Name :=
    'Main_Config_Profile_Avatar_Right_Glow';
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right_Glow.Parent :=
    mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right_Glow.Softness := 0.5;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right_Glow.Opacity := 0.9;
  mainScene.Config.main.R.Profile.User.Avatar.main.Arrow_Right_Glow.Enabled := False;

  mainScene.Config.main.R.Profile.User.Avatar.main.Page_Info :=
    TLabel.Create(mainScene.Config.main.R.Profile.User.Avatar.main.Panel);
  mainScene.Config.main.R.Profile.User.Avatar.main.Page_Info.Name := 'Main_Config_Profile_Avatar_Page_Info';
  mainScene.Config.main.R.Profile.User.Avatar.main.Page_Info.Parent :=
    mainScene.Config.main.R.Profile.User.Avatar.main.Panel;
  mainScene.Config.main.R.Profile.User.Avatar.main.Page_Info.Width := 300;
  mainScene.Config.main.R.Profile.User.Avatar.main.Page_Info.Height := 24;
  mainScene.Config.main.R.Profile.User.Avatar.main.Page_Info.Position.X := 10;
  mainScene.Config.main.R.Profile.User.Avatar.main.Page_Info.Position.Y := 460;
  mainScene.Config.main.R.Profile.User.Avatar.main.Page_Info.Text := 'Page 1 from 26 pages';
  mainScene.Config.main.R.Profile.User.Avatar.main.Page_Info.Visible := True;

  mainScene.Config.main.R.Profile.User.Avatar.main.Change :=
    TButton.Create(mainScene.Config.main.R.Profile.User.Avatar.main.Panel);
  mainScene.Config.main.R.Profile.User.Avatar.main.Change.Name := 'Main_Config_Profile_Avatar_Main_Change';
  mainScene.Config.main.R.Profile.User.Avatar.main.Change.Parent :=
    mainScene.Config.main.R.Profile.User.Avatar.main.Panel;
  mainScene.Config.main.R.Profile.User.Avatar.main.Change.Width := 100;
  mainScene.Config.main.R.Profile.User.Avatar.main.Change.Height := 30;
  mainScene.Config.main.R.Profile.User.Avatar.main.Change.Position.X := 50;
  mainScene.Config.main.R.Profile.User.Avatar.main.Change.Position.Y :=
    mainScene.Config.main.R.Profile.User.Avatar.main.Panel.Height - 40;
  mainScene.Config.main.R.Profile.User.Avatar.main.Change.Text := 'Change';
  mainScene.Config.main.R.Profile.User.Avatar.main.Change.OnClick :=
    ex_main.input.mouse_config.Button.OnMouseClick;
  mainScene.Config.main.R.Profile.User.Avatar.main.Change.Visible := True;

  mainScene.Config.main.R.Profile.User.Avatar.main.Cancel :=
    TButton.Create(mainScene.Config.main.R.Profile.User.Avatar.main.Panel);
  mainScene.Config.main.R.Profile.User.Avatar.main.Cancel.Name := 'Main_Config_Profile_Avatar_Main_Cancel';
  mainScene.Config.main.R.Profile.User.Avatar.main.Cancel.Parent :=
    mainScene.Config.main.R.Profile.User.Avatar.main.Panel;
  mainScene.Config.main.R.Profile.User.Avatar.main.Cancel.Width := 100;
  mainScene.Config.main.R.Profile.User.Avatar.main.Cancel.Height := 30;
  mainScene.Config.main.R.Profile.User.Avatar.main.Cancel.Position.X :=
    mainScene.Config.main.R.Profile.User.Avatar.main.Panel.Width - 150;
  mainScene.Config.main.R.Profile.User.Avatar.main.Cancel.Position.Y :=
    mainScene.Config.main.R.Profile.User.Avatar.main.Panel.Height - 40;
  mainScene.Config.main.R.Profile.User.Avatar.main.Cancel.Text := 'Cancel';
  mainScene.Config.main.R.Profile.User.Avatar.main.Cancel.OnClick :=
    ex_main.input.mouse_config.Button.OnMouseClick;
  mainScene.Config.main.R.Profile.User.Avatar.main.Cancel.Visible := True;

  uMain_Config_Profile_Avatar_ShowPage(1);
  mainScene.Config.main.R.Profile.User.Avatar.Panel.Visible := True;
end;
/// /////////////////////////////////////////////////////////////////////////////

procedure uMain_Config_Profile_ShowPassword;
begin

  extrafe.prog.State := 'main_config_profile_password';
  mainScene.Config.Main.Left_Blur.Enabled := True;
  mainScene.Config.main.R.Profile.Blur.Enabled := True;

  // Change Password panel
  mainScene.Config.main.R.Profile.User.Pass.Panel := TPanel.Create(mainScene.Config.main.R.Panel[0]);
  mainScene.Config.main.R.Profile.User.Pass.Panel.Name := 'Main_Config_Profile_Password_Panel';
  mainScene.Config.main.R.Profile.User.Pass.Panel.Parent := mainScene.Config.main.R.Panel[0];
  mainScene.Config.main.R.Profile.User.Pass.Panel.Width := 430;
  mainScene.Config.main.R.Profile.User.Pass.Panel.Height := 260;
  mainScene.Config.main.R.Profile.User.Pass.Panel.Position.X :=
    (mainScene.Config.main.R.Panel[0].Width / 2) - 215;
  mainScene.Config.main.R.Profile.User.Pass.Panel.Position.Y :=
    (mainScene.Config.main.R.Panel[0].Height / 2) - 130;
  mainScene.Config.main.R.Profile.User.Pass.Panel.Visible := False;

  mainScene.Config.main.R.Profile.User.Pass.Header.Panel :=
    TPanel.Create(mainScene.Config.main.R.Profile.User.Pass.Panel);
  mainScene.Config.main.R.Profile.User.Pass.Header.Panel.Name := 'Main_Config_Profile_Password_Header_Panel';
  mainScene.Config.main.R.Profile.User.Pass.Header.Panel.Parent :=
    mainScene.Config.main.R.Profile.User.Pass.Panel;
  mainScene.Config.main.R.Profile.User.Pass.Header.Panel.Width :=
    mainScene.Config.main.R.Profile.User.Pass.Panel.Width;
  mainScene.Config.main.R.Profile.User.Pass.Header.Panel.Height := 30;
  mainScene.Config.main.R.Profile.User.Pass.Header.Panel.Position.X := 0;
  mainScene.Config.main.R.Profile.User.Pass.Header.Panel.Position.Y := 0;
  mainScene.Config.main.R.Profile.User.Pass.Header.Panel.Visible := True;

  mainScene.Config.main.R.Profile.User.Pass.Header.Icon :=
    TImage.Create(mainScene.Config.main.R.Profile.User.Pass.Header.Panel);
  mainScene.Config.main.R.Profile.User.Pass.Header.Icon.Name := 'Main_Config_Profile_Password_Header_Icon';
  mainScene.Config.main.R.Profile.User.Pass.Header.Icon.Parent :=
    mainScene.Config.main.R.Profile.User.Pass.Header.Panel;
  mainScene.Config.main.R.Profile.User.Pass.Header.Icon.Width := 24;
  mainScene.Config.main.R.Profile.User.Pass.Header.Icon.Height := 24;
  mainScene.Config.main.R.Profile.User.Pass.Header.Icon.Position.X := 6;
  mainScene.Config.main.R.Profile.User.Pass.Header.Icon.Position.Y := 3;
  mainScene.Config.main.R.Profile.User.Pass.Header.Icon.Bitmap.LoadFromFile
    (ex_main.Paths.Config_Images + 'config_pass.png');
  mainScene.Config.main.R.Profile.User.Pass.Header.Icon.WrapMode := TImageWrapMode.Fit;
  mainScene.Config.main.R.Profile.User.Pass.Header.Icon.Visible := True;

  mainScene.Config.main.R.Profile.User.Pass.Header.Text :=
    TLabel.Create(mainScene.Config.main.R.Profile.User.Pass.Header.Panel);
  mainScene.Config.main.R.Profile.User.Pass.Header.Text.Name := 'Main_Config_Profile_Password_Header_Label';
  mainScene.Config.main.R.Profile.User.Pass.Header.Text.Parent :=
    mainScene.Config.main.R.Profile.User.Pass.Header.Panel;
  mainScene.Config.main.R.Profile.User.Pass.Header.Text.Width := 430;
  mainScene.Config.main.R.Profile.User.Pass.Header.Text.Height := 24;
  mainScene.Config.main.R.Profile.User.Pass.Header.Text.Position.X := 36;
  mainScene.Config.main.R.Profile.User.Pass.Header.Text.Position.Y := 3;
  mainScene.Config.main.R.Profile.User.Pass.Header.Text.Text := 'Change the password';
  mainScene.Config.main.R.Profile.User.Pass.Header.Text.Visible := True;

  mainScene.Config.main.R.Profile.User.Pass.main.Panel :=
    TPanel.Create(mainScene.Config.main.R.Profile.User.Pass.Panel);
  mainScene.Config.main.R.Profile.User.Pass.main.Panel.Name := 'Main_Config_Profile_Password_Main_Panel';
  mainScene.Config.main.R.Profile.User.Pass.main.Panel.Parent :=
    mainScene.Config.main.R.Profile.User.Pass.Panel;
  mainScene.Config.main.R.Profile.User.Pass.main.Panel.Width :=
    mainScene.Config.main.R.Profile.User.Pass.Panel.Width;
  mainScene.Config.main.R.Profile.User.Pass.main.Panel.Height :=
    mainScene.Config.main.R.Profile.User.Pass.Panel.Height - 30;
  mainScene.Config.main.R.Profile.User.Pass.main.Panel.Position.X := 0;
  mainScene.Config.main.R.Profile.User.Pass.main.Panel.Position.Y := 30;
  mainScene.Config.main.R.Profile.User.Pass.main.Panel.Visible := True;

  mainScene.Config.main.R.Profile.User.Pass.main.Current :=
    TLabel.Create(mainScene.Config.main.R.Profile.User.Pass.main.Panel);
  mainScene.Config.main.R.Profile.User.Pass.main.Current.Name :=
    'Main_Config_Profile_Password_Main_Current_Label';
  mainScene.Config.main.R.Profile.User.Pass.main.Current.Parent :=
    mainScene.Config.main.R.Profile.User.Pass.main.Panel;
  mainScene.Config.main.R.Profile.User.Pass.main.Current.Width := 430;
  mainScene.Config.main.R.Profile.User.Pass.main.Current.Height := 24;
  mainScene.Config.main.R.Profile.User.Pass.main.Current.Position.X := 10;
  mainScene.Config.main.R.Profile.User.Pass.main.Current.Position.Y := 10;
  mainScene.Config.main.R.Profile.User.Pass.main.Current.Text := 'Current password';
  mainScene.Config.main.R.Profile.User.Pass.main.Current.Visible := True;

  mainScene.Config.main.R.Profile.User.Pass.main.Current_V :=
    TEdit.Create(mainScene.Config.main.R.Profile.User.Pass.main.Panel);
  mainScene.Config.main.R.Profile.User.Pass.main.Current_V.Name :=
    'Main_Config_Profile_Password_Main_Current_V_Label';
  mainScene.Config.main.R.Profile.User.Pass.main.Current_V.Parent :=
    mainScene.Config.main.R.Profile.User.Pass.main.Panel;
  mainScene.Config.main.R.Profile.User.Pass.main.Current_V.Width := 410;
  mainScene.Config.main.R.Profile.User.Pass.main.Current_V.Height := 24;
  mainScene.Config.main.R.Profile.User.Pass.main.Current_V.Position.X := 10;
  mainScene.Config.main.R.Profile.User.Pass.main.Current_V.Position.Y := 34;
  mainScene.Config.main.R.Profile.User.Pass.main.Current_V.Text := '';
  mainScene.Config.main.R.Profile.User.Pass.main.Current_V.OnTyping :=
    ex_main.input.mouse_config.Edit.OnTyping;
  mainScene.Config.main.R.Profile.User.Pass.main.Current_V.Visible := True;

  mainScene.Config.main.R.Profile.User.Pass.main.New :=
    TLabel.Create(mainScene.Config.main.R.Profile.User.Pass.main.Panel);
  mainScene.Config.main.R.Profile.User.Pass.main.New.Name := 'Main_Config_Profile_Password_Main_New_Label';
  mainScene.Config.main.R.Profile.User.Pass.main.New.Parent :=
    mainScene.Config.main.R.Profile.User.Pass.main.Panel;
  mainScene.Config.main.R.Profile.User.Pass.main.New.Width := 430;
  mainScene.Config.main.R.Profile.User.Pass.main.New.Height := 24;
  mainScene.Config.main.R.Profile.User.Pass.main.New.Position.X := 10;
  mainScene.Config.main.R.Profile.User.Pass.main.New.Position.Y := 64;
  mainScene.Config.main.R.Profile.User.Pass.main.New.Text := 'New password';
  mainScene.Config.main.R.Profile.User.Pass.main.New.Visible := True;

  mainScene.Config.main.R.Profile.User.Pass.main.New_V :=
    TEdit.Create(mainScene.Config.main.R.Profile.User.Pass.main.Panel);
  mainScene.Config.main.R.Profile.User.Pass.main.New_V.Name :=
    'Main_Config_Profile_Password_Main_New_V_Label';
  mainScene.Config.main.R.Profile.User.Pass.main.New_V.Parent :=
    mainScene.Config.main.R.Profile.User.Pass.main.Panel;
  mainScene.Config.main.R.Profile.User.Pass.main.New_V.Width := 410;
  mainScene.Config.main.R.Profile.User.Pass.main.New_V.Height := 24;
  mainScene.Config.main.R.Profile.User.Pass.main.New_V.Position.X := 10;
  mainScene.Config.main.R.Profile.User.Pass.main.New_V.Position.Y := 88;
  mainScene.Config.main.R.Profile.User.Pass.main.New_V.Text := '';
  mainScene.Config.main.R.Profile.User.Pass.main.New_V.OnTyping := ex_main.input.mouse_config.Edit.OnTyping;
  mainScene.Config.main.R.Profile.User.Pass.main.New_V.Visible := True;

  mainScene.Config.main.R.Profile.User.Pass.main.New_Rewrite :=
    TLabel.Create(mainScene.Config.main.R.Profile.User.Pass.main.Panel);
  mainScene.Config.main.R.Profile.User.Pass.main.New_Rewrite.Name :=
    'Main_Config_Profile_Password_Main_NewRewrite_Label';
  mainScene.Config.main.R.Profile.User.Pass.main.New_Rewrite.Parent :=
    mainScene.Config.main.R.Profile.User.Pass.main.Panel;
  mainScene.Config.main.R.Profile.User.Pass.main.New_Rewrite.Width := 430;
  mainScene.Config.main.R.Profile.User.Pass.main.New_Rewrite.Height := 24;
  mainScene.Config.main.R.Profile.User.Pass.main.New_Rewrite.Position.X := 10;
  mainScene.Config.main.R.Profile.User.Pass.main.New_Rewrite.Position.Y := 118;
  mainScene.Config.main.R.Profile.User.Pass.main.New_Rewrite.Text := 'Rewrite new password';
  mainScene.Config.main.R.Profile.User.Pass.main.New_Rewrite.Visible := True;

  mainScene.Config.main.R.Profile.User.Pass.main.New_Rewrite_V :=
    TEdit.Create(mainScene.Config.main.R.Profile.User.Pass.main.Panel);
  mainScene.Config.main.R.Profile.User.Pass.main.New_Rewrite_V.Name :=
    'Main_Config_Profile_Password_Main_NewRewrite_V_Label';
  mainScene.Config.main.R.Profile.User.Pass.main.New_Rewrite_V.Parent :=
    mainScene.Config.main.R.Profile.User.Pass.main.Panel;
  mainScene.Config.main.R.Profile.User.Pass.main.New_Rewrite_V.Width := 410;
  mainScene.Config.main.R.Profile.User.Pass.main.New_Rewrite_V.Height := 24;
  mainScene.Config.main.R.Profile.User.Pass.main.New_Rewrite_V.Position.X := 10;
  mainScene.Config.main.R.Profile.User.Pass.main.New_Rewrite_V.Position.Y := 142;
  mainScene.Config.main.R.Profile.User.Pass.main.New_Rewrite_V.Text := '';
  mainScene.Config.main.R.Profile.User.Pass.main.New_Rewrite_V.OnTyping :=
    ex_main.input.mouse_config.Edit.OnTyping;
  mainScene.Config.main.R.Profile.User.Pass.main.New_Rewrite_V.Visible := True;

  mainScene.Config.main.R.Profile.User.Pass.main.Warning :=
    TLabel.Create(mainScene.Config.main.R.Profile.User.Pass.main.Panel);
  mainScene.Config.main.R.Profile.User.Pass.main.Warning.Name :=
    'Main_Config_Profile_Password_Main_Current_Warning';
  mainScene.Config.main.R.Profile.User.Pass.main.Warning.Parent :=
    mainScene.Config.main.R.Profile.User.Pass.main.Panel;
  mainScene.Config.main.R.Profile.User.Pass.main.Warning.Width :=
    mainScene.Config.main.R.Profile.User.Pass.main.Panel.Width - 20;
  mainScene.Config.main.R.Profile.User.Pass.main.Warning.Height := 24;
  mainScene.Config.main.R.Profile.User.Pass.main.Warning.Position.X := 10;
  mainScene.Config.main.R.Profile.User.Pass.main.Warning.Position.Y := 164;
  mainScene.Config.main.R.Profile.User.Pass.main.Warning.Text := '';
  mainScene.Config.main.R.Profile.User.Pass.main.Warning.TextSettings.FontColor := TAlphaColorRec.Red;
  mainScene.Config.main.R.Profile.User.Pass.main.Warning.TextSettings.HorzAlign := TTextAlign.Center;
  mainScene.Config.main.R.Profile.User.Pass.main.Warning.Visible := False;

  mainScene.Config.main.R.Profile.User.Pass.main.Change :=
    TButton.Create(mainScene.Config.main.R.Profile.User.Pass.main.Panel);
  mainScene.Config.main.R.Profile.User.Pass.main.Change.Name := 'Main_Config_Profile_Password_Main_Change';
  mainScene.Config.main.R.Profile.User.Pass.main.Change.Parent :=
    mainScene.Config.main.R.Profile.User.Pass.main.Panel;
  mainScene.Config.main.R.Profile.User.Pass.main.Change.Width := 100;
  mainScene.Config.main.R.Profile.User.Pass.main.Change.Height := 30;
  mainScene.Config.main.R.Profile.User.Pass.main.Change.Position.X := 50;
  mainScene.Config.main.R.Profile.User.Pass.main.Change.Position.Y :=
    mainScene.Config.main.R.Profile.User.Pass.main.Panel.Height - 40;
  mainScene.Config.main.R.Profile.User.Pass.main.Change.Text := 'Change';
  mainScene.Config.main.R.Profile.User.Pass.main.Change.OnClick :=
    ex_main.input.mouse_config.Button.OnMouseClick;
  mainScene.Config.main.R.Profile.User.Pass.main.Change.Visible := True;

  mainScene.Config.main.R.Profile.User.Pass.main.Cancel :=
    TButton.Create(mainScene.Config.main.R.Profile.User.Pass.main.Panel);
  mainScene.Config.main.R.Profile.User.Pass.main.Cancel.Name := 'Main_Config_Profile_Password_Main_Cancel';
  mainScene.Config.main.R.Profile.User.Pass.main.Cancel.Parent :=
    mainScene.Config.main.R.Profile.User.Pass.main.Panel;
  mainScene.Config.main.R.Profile.User.Pass.main.Cancel.Width := 100;
  mainScene.Config.main.R.Profile.User.Pass.main.Cancel.Height := 30;
  mainScene.Config.main.R.Profile.User.Pass.main.Cancel.Position.X :=
    mainScene.Config.main.R.Profile.User.Pass.main.Panel.Width - 150;
  mainScene.Config.main.R.Profile.User.Pass.main.Cancel.Position.Y :=
    mainScene.Config.main.R.Profile.User.Pass.main.Panel.Height - 40;
  mainScene.Config.main.R.Profile.User.Pass.main.Cancel.OnClick :=
    ex_main.input.mouse_config.Button.OnMouseClick;
  mainScene.Config.main.R.Profile.User.Pass.main.Cancel.Text := 'Cancel';
  mainScene.Config.main.R.Profile.User.Pass.main.Cancel.Visible := True;

  mainScene.Config.main.R.Profile.User.Pass.Panel.Visible := True;
end;

/// /////////////////////////////////////////////////////////////////////////////
/// Change Password
function uMain_Config_Profile_Password_Check: Boolean;
begin
  Result := False;
  if mainScene.Config.main.R.Profile.User.Pass.main.Current_V.Text = User.data.Password then
  begin
    if mainScene.Config.main.R.Profile.User.Pass.main.New_V.Text = mainScene.Config.main.R.Profile.User.Pass.
      main.New_Rewrite_V.Text then
    begin
      Result := True;
    end
    else
    begin
      mainScene.Config.main.R.Profile.User.Pass.main.Warning.Text :=
        'New passwords do not match please check them up.';
      mainScene.Config.main.R.Profile.User.Pass.main.Warning.Visible := True;
    end;
  end
  else
  begin
    mainScene.Config.main.R.Profile.User.Pass.main.Warning.Text :=
      'This is not your current password please type the right one.';
    mainScene.Config.main.R.Profile.User.Pass.main.Warning.Visible := True;
  end;
end;

procedure uMain_Config_Profile_Password_Change;
begin
  if uMain_Config_Profile_Password_Check then
  begin
    uDatabase_Change_Password(mainScene.Config.main.R.Profile.User.Pass.main.New_V.Text);
    mainScene.Config.main.R.Profile.User.Password_V.Text :=
      mainScene.Config.main.R.Profile.User.Pass.main.New_V.Text;
    uMain_Config_Profile_ReturnToProfile;
  end;
end;
/// /////////////////////////////////////////////////////////////////////////////

procedure uMain_Config_Profile_Avatar_ShowPage(vPage: Byte);
var
  vi: Integer;
  vAvatarPage_Num: Integer;
begin
  if (vPage >= 1) and (vPage <= 26) then
  begin
    vAvatar.Page := vPage;
    vAvatar.Checked := StrToInt(User.data.Avatar);
    vAvatarPage_Num := (StrToInt(User.data.Avatar) div 20) + 1;
    for vi := 0 to 19 do
    begin
      mainScene.Config.main.R.Profile.User.Avatar.main.Avatar[vi].Bitmap.LoadFromFile
        (ex_main.Paths.Avatar_Images + IntToStr((20 * (vPage - 1)) + vi) + '.png');
      mainScene.Config.main.R.Profile.User.Avatar.main.AVatar_Glow[vi].Enabled := False;
      mainScene.Config.main.R.Profile.User.Avatar.main.Avatar_Check[vi].Visible := False;
      if (vAvatar.Page = vAvatarPage_Num) and ((vAvatar.Checked mod 20) = vi) then
      begin
        mainScene.Config.main.R.Profile.User.Avatar.main.AVatar_Glow[vi].GlowColor := TAlphaColorRec.White;
        mainScene.Config.main.R.Profile.User.Avatar.main.AVatar_Glow[vi].Enabled := True;
        mainScene.Config.main.R.Profile.User.Avatar.main.Avatar_Check[vi].Visible := True;
      end
    end;
    mainScene.Config.main.R.Profile.User.Avatar.main.Page_Info.Text := 'Page ' + IntToStr(vPage) +
      ' of 26 pages';
  end;
end;

procedure uMain_Config_Profile_Avatar_Select(vNum: Integer);
var
  vi: Integer;
begin
  vAvatar.Checked := (20 * (vAvatar.Page - 1)) + vNum;
  for vi := 0 to 19 do
  begin
    mainScene.Config.main.R.Profile.User.Avatar.main.AVatar_Glow[vi].Enabled := False;
    mainScene.Config.main.R.Profile.User.Avatar.main.AVatar_Glow[vi].GlowColor := TAlphaColorRec.Deepskyblue;
    mainScene.Config.main.R.Profile.User.Avatar.main.Avatar_Check[vi].Visible := False;
  end;
  mainScene.Config.main.R.Profile.User.Avatar.main.AVatar_Glow[vNum].Enabled := True;
  mainScene.Config.main.R.Profile.User.Avatar.main.AVatar_Glow[vNum].GlowColor := TAlphaColorRec.White;
  mainScene.Config.main.R.Profile.User.Avatar.main.Avatar_Check[vNum].Visible := True;
end;

procedure uMain_Config_Profile_Avatar_Change;
begin
  uDatabase_Change_Avatar(vAvatar.Checked);
  mainScene.Header.Avatar.Bitmap.LoadFromFile(ex_main.Paths.Avatar_Images + IntToStr(vAvatar.Checked)
    + '.png');
  mainScene.Config.main.R.Profile.User.Avatar_Show.Bitmap.LoadFromFile(ex_main.Paths.Avatar_Images +
    IntToStr(vAvatar.Checked) + '.png');
  uMain_Config_Profile_ReturnToProfile;
end;

end.
