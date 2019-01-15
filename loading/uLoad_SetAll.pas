unit uLoad_SetAll;

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
  FMX.Memo;

procedure uLoad_SetAll_Load;
procedure uLoad_SetAll_Login;
procedure uLoad_SetAll_Forget_Password;
procedure uLoad_SetAll_Register;
procedure uLoad_SetAll_Terms;

implementation

uses
  loading,
  uLoad_AllTypes;

procedure uLoad_SetAll_Load;
begin
  // Back
  ex_load.Scene.Back := TImage.Create(Loading_Form);
  ex_load.Scene.Back.Name := 'Loading_Back';
  ex_load.Scene.Back.Parent := Loading_Form;
  ex_load.Scene.Back.SetBounds(0, 0, extrafe.res.Width, extrafe.res.Height);
  ex_load.Scene.Back.Bitmap.LoadFromFile(extrafe.loading.Images_Path + 'load.png');
  ex_load.Scene.Back.WrapMode := TImageWrapMode.Fit;
  ex_load.Scene.Back.Visible := True;

  ex_load.Scene.Back_Fade := TFloatAnimation.Create(ex_load.Scene.Back);
  ex_load.Scene.Back_Fade.Name := 'Loading_FadeOut';
  ex_load.Scene.Back_Fade.Parent := ex_load.Scene.Back;
  ex_load.Scene.Back_Fade.PropertyName := 'Opacity';
  ex_load.Scene.Back_Fade.StartValue := 1;
  ex_load.Scene.Back_Fade.StopValue := 0.3;
  ex_load.Scene.Back_Fade.Duration := 2;
  ex_load.Scene.Back_Fade.OnFinish := ex_load.Scene.Back_Fade_Float.OnFinish;
  ex_load.Scene.Back_Fade.Enabled := False;

  ex_load.Scene.Logo := TImage.Create(ex_load.Scene.Back);
  ex_load.Scene.Logo.Name := 'Loading_Logo';
  ex_load.Scene.Logo.Parent := ex_load.Scene.Back;
  ex_load.Scene.Logo.SetBounds(0, 0, 530, 340);
  ex_load.Scene.Logo.Bitmap.LoadFromFile(extrafe.loading.Images_Path + 'logo.png');
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
  ex_load.Scene.Progress.Visible := True;

  ex_load.Scene.Progress_Text := TLabel.Create(ex_load.Scene.Back);
  ex_load.Scene.Progress_Text.Name := 'Loading_Progress_Text';
  ex_load.Scene.Progress_Text.Parent := ex_load.Scene.Back;
  ex_load.Scene.Progress_Text.SetBounds(20, ex_load.Scene.Back.Height - 70, 300, 17);
  ex_load.Scene.Progress_Text.Text := 'Loading...';
  ex_load.Scene.Progress_Text.Visible := True;

  ex_load.Scene.Code_Name := TText.Create(ex_load.Scene.Back);
  ex_load.Scene.Code_Name.Name := 'Loading_Code_Name';
  ex_load.Scene.Code_Name.Parent := ex_load.Scene.Back;
  ex_load.Scene.Code_Name.SetBounds(extrafe.res.Width - 240, 90, 161, 26);
  ex_load.Scene.Code_Name.TextSettings.FontColor := TAlphaColorRec.White;
  ex_load.Scene.Code_Name.Text := extrafe.prog.Desc;
  ex_load.Scene.Code_Name.TextSettings.Font.Style := ex_load.Scene.Code_Name.TextSettings.Font.Style +
    [TFontstyle.fsBold];
  ex_load.Scene.Code_Name.RotationAngle := 38;
  ex_load.Scene.Code_Name.TextSettings.Font.Size := 16;
  ex_load.Scene.Code_Name.Visible := True;

  ex_load.Scene.Ver := TText.Create(ex_load.Scene.Back);
  ex_load.Scene.Ver.Name := 'Loading_Version';
  ex_load.Scene.Ver.Parent := ex_load.Scene.Back;
  ex_load.Scene.Ver.SetBounds(extrafe.res.Width - 350, 160, 260, 26);
  ex_load.Scene.Ver.TextSettings.FontColor := TAlphaColorRec.White;
  ex_load.Scene.Ver.Text := 'Version: ' + extrafe.prog.Version.Major + '.' + extrafe.prog.Version.Minor + '.'
    + extrafe.prog.Version.Realeash + ' build ' + extrafe.prog.Version.Build;
  ex_load.Scene.Ver.TextSettings.Font.Style := ex_load.Scene.Code_Name.TextSettings.Font.Style +
    [TFontstyle.fsBold];
  ex_load.Scene.Ver.RotationAngle := 38;
  ex_load.Scene.Ver.TextSettings.Font.Size := 16;
  ex_load.Scene.Ver.Visible := True;

  ex_load.Scene.Timer := TTimer.Create(Loading_Form);
  ex_load.Scene.Timer.Name := 'Loading_Timer';
  ex_load.Scene.Timer.Parent := Loading_Form;
  ex_load.Scene.Timer.Interval := 1000;
  ex_load.Scene.Timer.Enabled := False;

  uLoad_SetAll_Login;
end;

procedure uLoad_SetAll_Login;
var
  vkState: TKeyboardState;
begin
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

  ex_load.Login.Avatar := TImage.Create(ex_load.Login.Panel);
  ex_load.Login.Avatar.Name := 'Loading_Login_Avatar';
  ex_load.Login.Avatar.Parent := ex_load.Login.Panel;
  ex_load.Login.Avatar.SetBounds(16, 24, 100, 100);
  ex_load.Login.Avatar.Bitmap.LoadFromFile(ex_main.Paths.Avatar_Images + '0.png');
  ex_load.Login.Avatar.WrapMode := TImageWrapMode.Fit;
  ex_load.Login.Avatar.Visible := True;

  ex_load.Login.CapsLock := TText.Create(ex_load.Login.Panel);
  ex_load.Login.CapsLock.Name := 'Loading_Login_CapsLock';
  ex_load.Login.CapsLock.Parent := ex_load.Login.Panel;
  ex_load.Login.CapsLock.SetBounds(328, 90, 150, 17);
  ex_load.Login.CapsLock.Text := 'Caps Lock is on';
  ex_load.Login.CapsLock.TextSettings.FontColor := TAlphaColorRec.Deepskyblue;
  ex_load.Login.CapsLock.TextSettings.HorzAlign := TTextAlign.Trailing;
  ex_load.Login.CapsLock.Visible := False;

  ex_load.Login.User := TLabel.Create(ex_load.Login.Panel);
  ex_load.Login.User.Name := 'Loading_Login_User';
  ex_load.Login.User.Parent := ex_load.Login.Panel;
  ex_load.Login.User.SetBounds(152, 24, 200, 17);
  ex_load.Login.User.Text := 'Username :';
  ex_load.Login.User.Visible := True;

  ex_load.Login.User_V := TEdit.Create(ex_load.Login.Panel);
  ex_load.Login.User_V.Name := 'Loading_Login_User_V';
  ex_load.Login.User_V.Parent := ex_load.Login.Panel;
  ex_load.Login.User_V.SetBounds(152, 40, 329, 36);
  ex_load.Login.User_V.HitTest := True;
  ex_load.Login.User_V.TextSettings.FontColor := TAlphaColorRec.White;
  ex_load.Login.User_V.TextSettings.Font.Size := 18;
  ex_load.Login.User_V.TextSettings.HorzAlign := TTextAlign.Leading;
  ex_load.Login.User_V.TextSettings.VertAlign := TTextAlign.Center;
  ex_load.Login.User_V.Text := 'azrael11';
  ex_load.Login.User_V.StyledSettings := ex_load.Login.User_V.StyledSettings -
    [TStyledSetting.ssSize, TStyledSetting.FontColor, TStyledSetting.Other];
  ex_load.Login.User_V.OnTyping := ex_load.Input.mouse.Edit.OnTyping;
  ex_load.Login.User_V.Visible := True;

  ex_load.Login.Pass := TLabel.Create(ex_load.Login.Panel);
  ex_load.Login.Pass.Name := 'Loading_Login_Pass';
  ex_load.Login.Pass.Parent := ex_load.Login.Panel;
  ex_load.Login.Pass.SetBounds(152, 96, 200, 17);
  ex_load.Login.Pass.Text := 'Password :';
  ex_load.Login.Pass.Visible := True;

  ex_load.Login.Pass_V := TEdit.Create(ex_load.Login.Panel);
  ex_load.Login.Pass_V.Name := 'Loading_Login_Pass_V';
  ex_load.Login.Pass_V.Parent := ex_load.Login.Panel;
  ex_load.Login.Pass_V.SetBounds(152, 112, 329, 36);
  ex_load.Login.Pass_V.HitTest := True;
  ex_load.Login.Pass_V.TextSettings.FontColor := TAlphaColorRec.White;
  ex_load.Login.Pass_V.TextSettings.Font.Size := 18;
  ex_load.Login.Pass_V.TextSettings.HorzAlign := TTextAlign.Leading;
  ex_load.Login.Pass_V.TextSettings.VertAlign := TTextAlign.Center;
  ex_load.Login.Pass_V.Password := True;
  ex_load.Login.Pass_V.Text := '11azrael';
  ex_load.Login.Pass_V.StyledSettings := ex_load.Login.Pass_V.StyledSettings -
    [TStyledSetting.ssSize, TStyledSetting.FontColor, TStyledSetting.Other];
  ex_load.Login.Pass_V.OnTyping := ex_load.Input.mouse.Edit.OnTyping;
  ex_load.Login.Pass_V.Visible := True;

  ex_load.Login.Login := TButton.Create(ex_load.Login.Panel);
  ex_load.Login.Login.Name := 'Loading_Login_Login';
  ex_load.Login.Login.Parent := ex_load.Login.Panel;
  ex_load.Login.Login.SetBounds(400, 184, 80, 22);
  ex_load.Login.Login.Text := 'Login';
  ex_load.Login.Login.OnClick := ex_load.Input.mouse.Button.OnMouseClick;
  ex_load.Login.Login.Visible := True;

  ex_load.Login.Exit_ExtraFE := TButton.Create(ex_load.Login.Panel);
  ex_load.Login.Exit_ExtraFE.Name := 'Loading_Login_Exit';
  ex_load.Login.Exit_ExtraFE.Parent := ex_load.Login.Panel;
  ex_load.Login.Exit_ExtraFE.SetBounds(400, 216, 80, 22);
  ex_load.Login.Exit_ExtraFE.Text := 'Exit';
  ex_load.Login.Exit_ExtraFE.OnClick := ex_load.Input.mouse.Button.OnMouseClick;
  ex_load.Login.Exit_ExtraFE.Visible := True;

  ex_load.Login.Int_Icon := TImage.Create(ex_load.Login.Panel);
  ex_load.Login.Int_Icon.Name := 'Loading_Login_Internet_Icon';
  ex_load.Login.Int_Icon.Parent := ex_load.Login.Panel;
  ex_load.Login.Int_Icon.SetBounds(16, 248, 25, 25);
  ex_load.Login.Int_Icon.Bitmap.LoadFromFile(extrafe.loading.Images_Path + 'internet_active.png');
  ex_load.Login.Int_Icon.WrapMode := TImageWrapMode.Fit;
  ex_load.Login.Int_Icon.Visible := True;

  ex_load.Login.Internet := TLabel.Create(ex_load.Login.Panel);
  ex_load.Login.Internet.Name := 'Loading_Login_Internet';
  ex_load.Login.Internet.Parent := ex_load.Login.Panel;
  ex_load.Login.Internet.SetBounds(48, 256, 200, 17);
  ex_load.Login.Internet.Text := 'Not Connected';
  ex_load.Login.Internet.Visible := True;

  ex_load.Login.Data_Icon := TImage.Create(ex_load.Login.Panel);
  ex_load.Login.Data_Icon.Name := 'Loading_Login_Database_Icon';
  ex_load.Login.Data_Icon.Parent := ex_load.Login.Panel;
  ex_load.Login.Data_Icon.SetBounds(16, 280, 25, 25);
  ex_load.Login.Data_Icon.Bitmap.LoadFromFile(extrafe.loading.Images_Path + 'server_active.png');
  ex_load.Login.Data_Icon.WrapMode := TImageWrapMode.Fit;
  ex_load.Login.Data_Icon.Visible := True;

  ex_load.Login.Database := TLabel.Create(ex_load.Login.Panel);
  ex_load.Login.Database.Name := 'Loading_Login_Database';
  ex_load.Login.Database.Parent := ex_load.Login.Panel;
  ex_load.Login.Database.SetBounds(48, 288, 200, 17);
  ex_load.Login.Database.Text := 'Not Connected';
  ex_load.Login.Database.Visible := True;

  ex_load.Login.NotRegister := TText.Create(ex_load.Login.Panel);
  ex_load.Login.NotRegister.Name := 'Loading_Login_Register';
  ex_load.Login.NotRegister.Parent := ex_load.Login.Panel;
  ex_load.Login.NotRegister.SetBounds(288, 288, 193, 17);
  ex_load.Login.NotRegister.TextSettings.HorzAlign := TTextAlign.Trailing;
  ex_load.Login.NotRegister.Text := 'Not registered yet? Click here';
  ex_load.Login.NotRegister.TextSettings.FontColor := TAlphaColorRec.White;
  ex_load.Login.NotRegister.OnClick := ex_load.Input.mouse.Text.OnMouseClick;
  ex_load.Login.NotRegister.OnMouseEnter := ex_load.Input.mouse.Text.OnMouseEnter;
  ex_load.Login.NotRegister.OnMouseLeave := ex_load.Input.mouse.Text.OnMouseLeave;
  ex_load.Login.NotRegister.Visible := True;

  ex_load.Login.Forget_Pass := TText.Create(ex_load.Login.Panel);
  ex_load.Login.Forget_Pass.Name := 'Loading_Login_Forget_Pass';
  ex_load.Login.Forget_Pass.Parent := ex_load.Login.Panel;
  ex_load.Login.Forget_Pass.SetBounds(136, 154, 193, 17);
  ex_load.Login.Forget_Pass.TextSettings.HorzAlign := TTextAlign.Trailing;
  ex_load.Login.Forget_Pass.Text := 'Forgot your password? Click here';
  ex_load.Login.Forget_Pass.TextSettings.FontColor := TAlphaColorRec.White;
  ex_load.Login.Forget_Pass.OnClick := ex_load.Input.mouse.Text.OnMouseClick;
  ex_load.Login.Forget_Pass.OnMouseEnter := ex_load.Input.mouse.Text.OnMouseEnter;
  ex_load.Login.Forget_Pass.OnMouseLeave := ex_load.Input.mouse.Text.OnMouseLeave;
  ex_load.Login.Forget_Pass.Visible := False;

  ex_load.Login.Warning := TLabel.Create(ex_load.Login.Panel);
  ex_load.Login.Warning.Name := 'Loading_Login_Warning';
  ex_load.Login.Warning.Parent := ex_load.Login.Panel;
  ex_load.Login.Warning.SetBounds(138, 8, 373, 22);
  ex_load.Login.Warning.TextSettings.FontColor := TAlphaColorRec.Red;
  ex_load.Login.Warning.Text := 'OK ola kala';
  ex_load.Login.Warning.TextAlign := TTextAlign.Trailing;
  ex_load.Login.Warning.StyledSettings := ex_load.Login.Warning.StyledSettings -
    [TStyledSetting.FontColor, TStyledSetting.Size];
  ex_load.Login.Warning.Visible := False;

  ex_load.Scene.Logo.Position.X := ex_load.Login.Panel.Position.X;
  ex_load.Scene.Logo.Position.Y := ex_load.Login.Panel.Position.Y - 340;

  GetKeyboardState(vkState);
  if (vkState[VK_CAPITAL] = 0) then
    ex_load.Login.CapsLock.Visible := False
  else
    ex_load.Login.CapsLock.Visible := True;
end;

procedure uLoad_SetAll_Forget_Password;
begin
  ex_load.F_Pass.Panel := TPanel.Create(ex_load.Scene.Back);
  ex_load.F_Pass.Panel.Name := 'Loading_FPass';
  ex_load.F_Pass.Panel.Parent := ex_load.Scene.Back;
  ex_load.F_Pass.Panel.SetBounds(extrafe.res.Half_Width - 250, extrafe.res.Half_Height - 130, 500, 260);
  ex_load.F_Pass.Panel.Opacity := 0.8;
  ex_load.F_Pass.Panel.Visible := True;

  uLoad_SetAll_CreateHeader(ex_load.F_Pass.Panel, 'Loading_FPass', extrafe.loading.Images_Path + 'pass.png',
    'Forget my password');

  ex_load.F_Pass.Main.Panel := TPanel.Create(ex_load.F_Pass.Panel);
  ex_load.F_Pass.Main.Panel.Name := 'Loading_FPass_Main';
  ex_load.F_Pass.Main.Panel.Parent := ex_load.F_Pass.Panel;
  ex_load.F_Pass.Main.Panel.SetBounds(0, 30, ex_load.F_Pass.Panel.Width, ex_load.F_Pass.Panel.Height - 30);
  ex_load.F_Pass.Main.Panel.Visible := True;

  ex_load.F_Pass.Main.Avatar := TImage.Create(ex_load.F_Pass.Main.Panel);
  ex_load.F_Pass.Main.Avatar.Name := 'Loading_FPass_Avatar';
  ex_load.F_Pass.Main.Avatar.Parent := ex_load.F_Pass.Main.Panel;
  ex_load.F_Pass.Main.Avatar.SetBounds(((ex_load.F_Pass.Main.Panel.Width / 2) - 50), 5, 100, 100);
  ex_load.F_Pass.Main.Avatar.Bitmap := ex_load.Login.Avatar.Bitmap;
  ex_load.F_Pass.Main.Avatar.WrapMode := TImageWrapMode.Fit;
  ex_load.F_Pass.Main.Avatar.Visible := True;

  ex_load.F_Pass.Main.Email := TLabel.Create(ex_load.F_Pass.Main.Panel);
  ex_load.F_Pass.Main.Email.Name := 'Loading_FPass_Email';
  ex_load.F_Pass.Main.Email.Parent := ex_load.F_Pass.Main.Panel;
  ex_load.F_Pass.Main.Email.SetBounds(10, 110, 200, 20);
  ex_load.F_Pass.Main.Email.Text := 'Write your email';
  ex_load.F_Pass.Main.Email.Visible := True;

  ex_load.F_Pass.Main.Email_V := TEdit.Create(ex_load.F_Pass.Main.Panel);
  ex_load.F_Pass.Main.Email_V.Name := 'Loading_FPass_Email_V';
  ex_load.F_Pass.Main.Email_V.Parent := ex_load.F_Pass.Main.Panel;
  ex_load.F_Pass.Main.Email_V.SetBounds(10, 130, ex_load.F_Pass.Main.Panel.Width - 20, 20);
  ex_load.F_Pass.Main.Email_V.Text := '';
  ex_load.F_Pass.Main.Email_V.Visible := True;

  ex_load.F_Pass.Main.Send := TButton.Create(ex_load.F_Pass.Main.Panel);
  ex_load.F_Pass.Main.Send.Name := 'Loading_FPass_Send';
  ex_load.F_Pass.Main.Send.Parent := ex_load.F_Pass.Main.Panel;
  ex_load.F_Pass.Main.Send.SetBounds(50, ex_load.F_Pass.Main.Panel.Height - 40, 100, 30);
  ex_load.F_Pass.Main.Send.Text := 'Send';
  ex_load.F_Pass.Main.Send.OnClick := ex_load.Input.mouse.Button.OnMouseClick;
  ex_load.F_Pass.Main.Send.Visible := True;

  ex_load.F_Pass.Main.Cancel := TButton.Create(ex_load.F_Pass.Main.Panel);
  ex_load.F_Pass.Main.Cancel.Name := 'Loading_FPass_Cancel';
  ex_load.F_Pass.Main.Cancel.Parent := ex_load.F_Pass.Main.Panel;
  ex_load.F_Pass.Main.Cancel.SetBounds(ex_load.F_Pass.Main.Panel.Width - 150, ex_load.F_Pass.Main.Panel.Height
    - 40, 100, 30);
  ex_load.F_Pass.Main.Cancel.Text := 'Cancel';
  ex_load.F_Pass.Main.Cancel.OnClick := ex_load.Input.mouse.Button.OnMouseClick;
  ex_load.F_Pass.Main.Cancel.Visible := True;

  ex_load.F_Pass.Main.Warning := TLabel.Create(ex_load.F_Pass.Panel);
  ex_load.F_Pass.Main.Warning.Name := 'Loading_FPass_Warning';
  ex_load.F_Pass.Main.Warning.Parent := ex_load.F_Pass.Panel;
  ex_load.F_Pass.Main.Warning.SetBounds(118, 34, 373, 22);
  ex_load.F_Pass.Main.Warning.TextSettings.FontColor := TAlphaColorRec.Red;
  ex_load.F_Pass.Main.Warning.Text := 'Wrong Email';
  ex_load.F_Pass.Main.Warning.TextAlign := TTextAlign.Trailing;
  ex_load.F_Pass.Main.Warning.StyledSettings := ex_load.F_Pass.Main.Warning.StyledSettings -
    [TStyledSetting.FontColor, TStyledSetting.Size];
  ex_load.F_Pass.Main.Warning.Visible := False;

  FreeAndNil(ex_load.Login.Panel);
end;

procedure uLoad_SetAll_Register;
begin

  ex_load.Reg.Panel := TPanel.Create(ex_load.Scene.Back);
  ex_load.Reg.Panel.Name := 'Loading_Register';
  ex_load.Reg.Panel.Parent := ex_load.Scene.Back;
  ex_load.Reg.Panel.SetBounds(extrafe.res.Half_Width - 250, extrafe.res.Half_Height - 260, 500, 520);
  ex_load.Reg.Panel.Opacity := 0.8;
  ex_load.Reg.Panel.Visible := True;

  uLoad_SetAll_CreateHeader(ex_load.Reg.Panel, 'Loading_Register', extrafe.loading.Images_Path +
    'register.png', 'Register');

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

  ex_load.Reg.Main.User_V := TEdit.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.User_V.Name := 'Loading_Register_User_V';
  ex_load.Reg.Main.User_V.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.User_V.SetBounds(20, 30, ex_load.Reg.Main.Panel.Width - 40, 20);
  ex_load.Reg.Main.User_V.Text := '';
  ex_load.Reg.Main.User_V.Visible := True;

  ex_load.Reg.Main.Pass := TLabel.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Pass.Name := 'Loading_Register_Pass';
  ex_load.Reg.Main.Pass.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Pass.SetBounds(20, 55, 200, 20);
  ex_load.Reg.Main.Pass.Text := 'Password :';
  ex_load.Reg.Main.Pass.Visible := True;

  ex_load.Reg.Main.Pass_V := TEdit.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Pass_V.Name := 'Loading_Register_Pass_V';
  ex_load.Reg.Main.Pass_V.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Pass_V.SetBounds(20, 75, ex_load.Reg.Main.Panel.Width - 40, 20);
  ex_load.Reg.Main.Pass_V.Text := '';
  ex_load.Reg.Main.Pass_V.Visible := True;

  ex_load.Reg.Main.RePass := TLabel.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.RePass.Name := 'Loading_Register_RePass';
  ex_load.Reg.Main.RePass.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.RePass.SetBounds(20, 100, 200, 20);
  ex_load.Reg.Main.RePass.Text := 'Retype password :';
  ex_load.Reg.Main.RePass.Visible := True;

  ex_load.Reg.Main.RePass_V := TEdit.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.RePass_V.Name := 'Loading_Register_RePass_V';
  ex_load.Reg.Main.RePass_V.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.RePass_V.SetBounds(20, 120, ex_load.Reg.Main.Panel.Width - 40, 20);
  ex_load.Reg.Main.RePass_V.Text := '';
  ex_load.Reg.Main.RePass_V.Visible := True;

  ex_load.Reg.Main.Email := TLabel.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Email.Name := 'Loading_Register_Email';
  ex_load.Reg.Main.Email.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Email.SetBounds(20, 145, 200, 20);
  ex_load.Reg.Main.Email.Text := 'Email :';
  ex_load.Reg.Main.Email.Visible := True;

  ex_load.Reg.Main.Email_V := TEdit.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Email_V.Name := 'Loading_Register_Email_V';
  ex_load.Reg.Main.Email_V.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Email_V.SetBounds(20, 165, ex_load.Reg.Main.Panel.Width - 40, 20);
  ex_load.Reg.Main.Email_V.Text := '';
  ex_load.Reg.Main.Email_V.Visible := True;

  ex_load.Reg.Main.ReEmail := TLabel.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.ReEmail.Name := 'Loading_Register_ReEmail';
  ex_load.Reg.Main.ReEmail.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.ReEmail.SetBounds(20, 190, 200, 20);
  ex_load.Reg.Main.ReEmail.Text := 'Retype Email :';
  ex_load.Reg.Main.ReEmail.Visible := True;

  ex_load.Reg.Main.ReEmail_V := TEdit.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.ReEmail_V.Name := 'Loading_Register_ReEmail_V';
  ex_load.Reg.Main.ReEmail_V.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.ReEmail_V.SetBounds(20, 210, ex_load.Reg.Main.Panel.Width - 40, 20);
  ex_load.Reg.Main.ReEmail_V.Text := '';
  ex_load.Reg.Main.ReEmail_V.Visible := True;

  ex_load.Reg.Main.Capt_Img := TImage.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Capt_Img.Name := 'Loading_Register_Capt_Img';
  ex_load.Reg.Main.Capt_Img.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Capt_Img.SetBounds(20, 240, 240, 150);
  ex_load.Reg.Main.Capt_Img.Bitmap.LoadFromFile(extrafe.loading.Images_Path + 'load.png');
  ex_load.Reg.Main.Capt_Img.WrapMode := TImageWrapMode.Fit;
  ex_load.Reg.Main.Capt_Img.Visible := True;

  ex_load.Reg.Main.Capt := TLabel.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Capt.Name := 'Loading_Register_Capt';
  ex_load.Reg.Main.Capt.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Capt.SetBounds(20, 380, 200, 20);
  ex_load.Reg.Main.Capt.Text := 'Type captcha letters :';
  ex_load.Reg.Main.Capt.Visible := True;

  ex_load.Reg.Main.Capt_V := TEdit.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Capt_V.Name := 'Loading_Register_Capt_V';
  ex_load.Reg.Main.Capt_V.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Capt_V.SetBounds(20, 400, 240, 20);
  ex_load.Reg.Main.Capt_V.Text := '';
  ex_load.Reg.Main.Capt_V.Visible := True;

  ex_load.Reg.Main.Terms := TText.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Terms.Name := 'Loading_Register_Terms';
  ex_load.Reg.Main.Terms.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Terms.SetBounds(270, 290, 200, 20);
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
  ex_load.Reg.Main.Terms_Check.SetBounds(310, 320, 200, 17);
  ex_load.Reg.Main.Terms_Check.Text := 'I accept the terms';
  ex_load.Reg.Main.Terms_Check.Enabled := False;
  ex_load.Reg.Main.Terms_Check.Visible := True;

  ex_load.Reg.Main.Reg := TButton.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Reg.Name := 'Loading_Reg_Register';
  ex_load.Reg.Main.Reg.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Reg.SetBounds(50, ex_load.Reg.Main.Panel.Height - 40, 100, 30);
  ex_load.Reg.Main.Reg.Text := 'Register';
  ex_load.Reg.Main.Reg.OnClick := ex_load.Input.mouse.Button.OnMouseClick;
  ex_load.Reg.Main.Reg.Visible := True;

  ex_load.Reg.Main.Cancel := TButton.Create(ex_load.Reg.Main.Panel);
  ex_load.Reg.Main.Cancel.Name := 'Loading_Reg_Cancel';
  ex_load.Reg.Main.Cancel.Parent := ex_load.Reg.Main.Panel;
  ex_load.Reg.Main.Cancel.SetBounds(ex_load.Reg.Main.Panel.Width - 150, ex_load.Reg.Main.Panel.Height -
    40, 100, 30);
  ex_load.Reg.Main.Cancel.Text := 'Cancel';
  ex_load.Reg.Main.Cancel.OnClick := ex_load.Input.mouse.Button.OnMouseClick;
  ex_load.Reg.Main.Cancel.Visible := True;

  FreeAndNil(ex_load.Login.Panel);
end;

procedure uLoad_SetAll_Terms;
begin
  ex_load.Terms.Panel := TPanel.Create(ex_load.Scene.Back);
  ex_load.Terms.Panel.Name := 'Loading_Terms';
  ex_load.Terms.Panel.Parent := ex_load.Scene.Back;
  ex_load.Terms.Panel.SetBounds(extrafe.res.Half_Width - 250, extrafe.res.Half_Height - 260, 500, 520);
  ex_load.Terms.Panel.Visible := True;

  uLoad_SetAll_CreateHeader(ex_load.Terms.Panel, 'Loading_Terms', extrafe.loading.Images_Path + 'terms.png',
    'Read the terms of ExtraFE.');

  ex_load.Terms.Main.Panel := TPanel.Create(ex_load.Terms.Panel);
  ex_load.Terms.Main.Panel.Name := 'Loading_Terms_Main';
  ex_load.Terms.Main.Panel.Parent := ex_load.Terms.Panel;
  ex_load.Terms.Main.Panel.SetBounds(0, 30, ex_load.Terms.Panel.Width, ex_load.Terms.Panel.Height - 30);
  ex_load.Terms.Main.Panel.Visible := True;

  ex_load.Terms.Main.Memo := TMemo.Create(ex_load.Terms.Main.Panel);
  ex_load.Terms.Main.Memo.Name := 'Loading_Terms_Terms';
  ex_load.Terms.Main.Memo.Parent := ex_load.Terms.Main.Panel;
  ex_load.Terms.Main.Memo.SetBounds(10, 10, ex_load.Terms.Main.Panel.Width - 20,
    ex_load.Terms.Main.Panel.Height - 60);
  ex_load.Terms.Main.Memo.Lines.LoadFromFile(extrafe.loading.Images_Path+ 'lin.txt');
  ex_load.Terms.Main.Memo.WordWrap:= True;
  ex_load.Terms.Main.Memo.TextSettings.Font.Size:= 14;
  ex_load.Terms.Main.Memo.StyledSettings:= ex_load.Terms.Main.Memo.StyledSettings- [TStyledSetting.Size];
  ex_load.Terms.Main.Memo.Visible := True;

  ex_load.Terms.Main.Close := TButton.Create(ex_load.Terms.Main.Panel);
  ex_load.Terms.Main.Close.Name := 'Loading_Terms_Close';
  ex_load.Terms.Main.Close.Parent := ex_load.Terms.Main.Panel;
  ex_load.Terms.Main.Close.SetBounds((ex_load.Terms.Main.Panel.Width / 2) - 50,
    ex_load.Terms.Main.Panel.Height - 40, 100, 30);
  ex_load.Terms.Main.Close.Text := 'Close';
  ex_load.Terms.Main.Close.OnClick := ex_load.Input.mouse.Button.OnMouseClick;
  ex_load.Terms.Main.Close.Visible := True;
end;

end.
