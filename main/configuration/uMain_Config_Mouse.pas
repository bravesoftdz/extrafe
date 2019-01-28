unit uMain_Config_Mouse;

interface

uses
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  System.UiTypes,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Edit;

type
  TMAIN_CONFIG_IMAGE = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TMAIN_CONFIG_TEXT = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TMAIN_CONFIG_EDIT = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
    procedure OnTyping(Sender: TObject);
  end;

type
  TMAIN_CONFIG_BUTTON = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TMAIN_CONFIG_RADIOBUTTON = class(TObject)
    procedure OnMouseClick(Sender: TObject);
  end;

type
  TMAIN_MOUSE_CONFIG_ACTIONS = record
    Image: TMAIN_CONFIG_IMAGE;
    Text: TMAIN_CONFIG_TEXT;
    Edit: TMAIN_CONFIG_EDIT;
    Button: TMAIN_CONFIG_BUTTON;
    Radio: TMAIN_CONFIG_RADIOBUTTON;
  end;

implementation

uses
  uLoad_AllTypes,
  uSnippet_Text,
  uMain_SetAll,
  uMain_AllTypes,
  uMain_Config,
  uMain_Config_Profile,
  uMain_Config_Emulators,
  uMain_Config_Addons,
  uMain_Config_Addons_Actions,
  uMain_Config_Themes,
  uMain_Config_Info,
  uMain_Config_Info_Actions,
  uMain_Config_Info_Credits;

{ TMAIN_CONFIG_IMAGE }

procedure TMAIN_CONFIG_IMAGE.OnMouseClick(Sender: TObject);
begin
  if extrafe.prog.State = 'main_config' then
  begin
    if TImage(Sender).Name = 'Main_Config_Emulators_Image_' + IntToStr(TImage(Sender).Tag) then
      uMain_Config_Emulators_ShowCategory(TImage(Sender).Tag)
    else if TImage(Sender).Name = 'Main_Config_Addons_Groupbox_0_Image_' + IntToStr(TImage(Sender).Tag) then
      uMain_Config_Addons_ShowInfo(TImage(Sender).Tag)
    else if TImage(Sender).Name = 'Main_Config_Addons_Arrow_Left' then
      uMain_Config_Addons_Actions_LeftArrow
    else if TImage(Sender).Name = 'Main_Config_Addons_Arrow_Right' then
      uMain_Config_Addons_Actions_RightArrow
    else if TImage(Sender).Name = 'Main_Config_Info_ExtraFE_Stable_Left' then
      Config_Info_Previous_Stable
    else if TImage(Sender).Name = 'Main_Config_Info_ExtraFE_Stable_Right' then
      Config_Info_Next_Stable
    else if TImage(Sender).Name = 'Main_Config_Info_ExtraFE_LastBuild_Left' then
      Config_Info_Previous_Build
    else if TImage(Sender).Name = 'Main_Config_Info_ExtraFE_LastBuild_Right' then
      Config_Info_Next_Build
    else if ContainsText(TImage(Sender).Name, 'Main_Config_Info_Credits_Image_') then
    begin
      if ex_main.Config.Info_Credits_Selected <> TImage(Sender).Tag then
        uMain_Config_Info_Credits_ShowBrand(TImage(Sender).Tag);
    end;
  end
  else if extrafe.prog.State = 'main_config_profile_avatar' then
  begin
    if TImage(Sender).Name = 'Main_Config_Profile_Avatar_Left' then
      uMain_Config_Profile_Avatar_ShowPage(vAvatar.Page - 1)
    else if TImage(Sender).Name = 'Main_Config_Profile_Avatar_Right' then
      uMain_Config_Profile_Avatar_ShowPage(vAvatar.Page + 1)
    else if TImage(Sender).Name = 'Main_Config_Profile_Avatar_Image_' + IntToStr(TImage(Sender).Tag) then
      uMain_Config_Profile_Avatar_Select(TImage(Sender).Tag);
  end;
end;

procedure TMAIN_CONFIG_IMAGE.OnMouseEnter(Sender: TObject);
begin
  if extrafe.prog.State = 'main_config' then
  begin
    if TImage(Sender).Name = 'Main_Config_Emulators_Image_' + IntToStr(TImage(Sender).Tag) then
      mainScene.Config.Main.R.Emulators.Images_Glow[TImage(Sender).Tag].Enabled := True
    else if (TImage(Sender).Name = 'Main_Config_Emulators_Arcade_MAME_Logo') or
      (TImage(Sender).Name = 'Main_Config_Emulators_Arcade_MAME_Logo_Check') then
    begin
      if mainScene.Config.Main.R.Emulators.Arcade[0].Logo_Gray.Enabled = False then
        mainScene.Config.Main.R.Emulators.Arcade[0].Logo_Glow.Enabled := True
    end
    else if TImage(Sender).Name = 'Main_Config_Addons_Groupbox_0_Image_' + IntToStr(TImage(Sender).Tag) then
      mainScene.Config.Main.R.Addons.Icons_Glow[TImage(Sender).Tag].Enabled := True
    else if TImage(Sender).Name = 'Main_Config_Addons_Arrow_Left' then
    begin
      if mainScene.Config.Main.R.Addons.Arrow_Left_Gray.Enabled = False then
        mainScene.Config.Main.R.Addons.Arrow_Left_Glow.Enabled := True;
    end
    else if TImage(Sender).Name = 'Main_Config_Addons_Arrow_Right' then
    begin
      if mainScene.Config.Main.R.Addons.Arrow_Right_Gray.Enabled = False then
        mainScene.Config.Main.R.Addons.Arrow_Right_Glow.Enabled := True;
    end
    else if TImage(Sender).Name = 'Main_Config_Info_ExtraFE_Stable_Left' then
      mainScene.Config.Main.R.Info.extrafe.Stable_Left_Glow.Enabled := True
    else if TImage(Sender).Name = 'Main_Config_Info_ExtraFE_Stable_Right' then
      mainScene.Config.Main.R.Info.extrafe.Stable_Right_Glow.Enabled := True
    else if TImage(Sender).Name = 'Main_Config_Info_ExtraFE_LastBuild_Left' then
      mainScene.Config.Main.R.Info.extrafe.Build_Left_Glow.Enabled := True
    else if TImage(Sender).Name = 'Main_Config_Info_ExtraFE_LastBuild_Right' then
      mainScene.Config.Main.R.Info.extrafe.Build_Right_Glow.Enabled := True
    else if ContainsText(TImage(Sender).Name, 'Main_Config_Info_Credits_Image_') then
    begin
      if ex_main.Config.Info_Credits_Selected <> TImage(Sender).Tag then
        mainScene.Config.Main.R.Info.Credits.Comps_Image_Glow[TImage(Sender).Tag].Enabled := True;
    end;
  end
  else if extrafe.prog.State = 'main_config_profile_avatar' then
  begin
    if TImage(Sender).Name = 'Main_Config_Profile_Avatar_Left' then
      mainScene.Config.Main.R.Profile.User.Avatar.Main.Arrow_Left_Glow.Enabled := True
    else if TImage(Sender).Name = 'Main_Config_Profile_Avatar_Right' then
      mainScene.Config.Main.R.Profile.User.Avatar.Main.Arrow_Right_Glow.Enabled := True
    else if TImage(Sender).Name = 'Main_Config_Profile_Avatar_Image_' + IntToStr(TImage(Sender).Tag) then
    begin
      if mainScene.Config.Main.R.Profile.User.Avatar.Main.AVatar_Glow[TImage(Sender).Tag].GlowColor <>
        TAlphaColorRec.White then
        mainScene.Config.Main.R.Profile.User.Avatar.Main.AVatar_Glow[TImage(Sender).Tag].Enabled := True;
    end;
  end;
end;

procedure TMAIN_CONFIG_IMAGE.OnMouseLeave(Sender: TObject);
begin
  if extrafe.prog.State = 'main_config' then
  begin
    if TImage(Sender).Name = 'Main_Config_Emulators_Image_' + IntToStr(TImage(Sender).Tag) then
      mainScene.Config.Main.R.Emulators.Images_Glow[TImage(Sender).Tag].Enabled := False
    else if (TImage(Sender).Name = 'Main_Config_Emulators_Arcade_MAME_Logo') or
      (TImage(Sender).Name = 'Main_Config_Emulators_Arcade_MAME_Logo_Check') then
    begin
      if mainScene.Config.Main.R.Emulators.Arcade[0].Logo_Gray.Enabled = False then
        mainScene.Config.Main.R.Emulators.Arcade[0].Logo_Glow.Enabled := False
    end
    else if TImage(Sender).Name = 'Main_Config_Addons_Groupbox_0_Image_' + IntToStr(TImage(Sender).Tag) then
      mainScene.Config.Main.R.Addons.Icons_Glow[TImage(Sender).Tag].Enabled := False
    else if TImage(Sender).Name = 'Main_Config_Addons_Arrow_Left' then
    begin
      if mainScene.Config.Main.R.Addons.Arrow_Left_Gray.Enabled = False then
        mainScene.Config.Main.R.Addons.Arrow_Left_Glow.Enabled := False;
    end
    else if TImage(Sender).Name = 'Main_Config_Addons_Arrow_Right' then
    begin
      if mainScene.Config.Main.R.Addons.Arrow_Right_Gray.Enabled = False then
        mainScene.Config.Main.R.Addons.Arrow_Right_Glow.Enabled := False;
    end
    else if TImage(Sender).Name = 'Main_Config_Info_ExtraFE_Stable_Left' then
      mainScene.Config.Main.R.Info.extrafe.Stable_Left_Glow.Enabled := False
    else if TImage(Sender).Name = 'Main_Config_Info_ExtraFE_Stable_Right' then
      mainScene.Config.Main.R.Info.extrafe.Stable_Right_Glow.Enabled := False
    else if TImage(Sender).Name = 'Main_Config_Info_ExtraFE_LastBuild_Left' then
      mainScene.Config.Main.R.Info.extrafe.Build_Left_Glow.Enabled := False
    else if TImage(Sender).Name = 'Main_Config_Info_ExtraFE_LastBuild_Right' then
      mainScene.Config.Main.R.Info.extrafe.Build_Right_Glow.Enabled := False
    else if ContainsText(TImage(Sender).Name, 'Main_Config_Info_Credits_Image_') then
    begin
      if ex_main.Config.Info_Credits_Selected <> TImage(Sender).Tag then
        mainScene.Config.Main.R.Info.Credits.Comps_Image_Glow[TImage(Sender).Tag].Enabled := False;
    end;
  end
  else if extrafe.prog.State = 'main_config_profile_avatar' then
  begin
    if TImage(Sender).Name = 'Main_Config_Profile_Avatar_Left' then
      mainScene.Config.Main.R.Profile.User.Avatar.Main.Arrow_Left_Glow.Enabled := False
    else if TImage(Sender).Name = 'Main_Config_Profile_Avatar_Right' then
      mainScene.Config.Main.R.Profile.User.Avatar.Main.Arrow_Right_Glow.Enabled := False
    else if TImage(Sender).Name = 'Main_Config_Profile_Avatar_Image_' + IntToStr(TImage(Sender).Tag) then
    begin
      if mainScene.Config.Main.R.Profile.User.Avatar.Main.AVatar_Glow[TImage(Sender).Tag].GlowColor <>
        TAlphaColorRec.White then
        mainScene.Config.Main.R.Profile.User.Avatar.Main.AVatar_Glow[TImage(Sender).Tag].Enabled := False;
    end;
  end;
end;

{ TMAIN_CONFIG_TEXT }

procedure TMAIN_CONFIG_TEXT.OnMouseClick(Sender: TObject);
begin
  if extrafe.prog.State = 'main_config' then
  begin
    if TText(Sender).Name = 'Main_Config_Profile_Main_Avatar_Change' then
      uMain_Config_Profile_ShowAvatar
    else if TText(Sender).Name = 'Main_Config_Profile_Main_Password_Change' then
      uMain_Config_Profile_ShowPassword
  end
end;

procedure TMAIN_CONFIG_TEXT.OnMouseEnter(Sender: TObject);
begin
  if extrafe.prog.State = 'main_config' then
  begin
    if TText(Sender).Name = 'Main_Config_Profile_Main_Avatar_Change' then
      uSnippet_Text_HyperLink_OnMouseEnter(TImage(Sender))
    else if TText(Sender).Name = 'Main_Config_Profile_Main_Password_Change' then
      uSnippet_Text_HyperLink_OnMouseEnter(TImage(Sender))
  end;
end;

procedure TMAIN_CONFIG_TEXT.OnMouseLeave(Sender: TObject);
begin
  if extrafe.prog.State = 'main_config' then
  begin
    if TText(Sender).Name = 'Main_Config_Profile_Main_Avatar_Change' then
      uSnippet_Text_HyperLink_OnMouseLeave(TImage(Sender))
    else if TText(Sender).Name = 'Main_Config_Profile_Main_Password_Change' then
      uSnippet_Text_HyperLink_OnMouseLeave(TImage(Sender))
  end;
end;

{ TMAIN_CONFIG_EDIT }

procedure TMAIN_CONFIG_EDIT.OnMouseClick(Sender: TObject);
begin

end;

procedure TMAIN_CONFIG_EDIT.OnMouseEnter(Sender: TObject);
begin

end;

procedure TMAIN_CONFIG_EDIT.OnMouseLeave(Sender: TObject);
begin

end;

procedure TMAIN_CONFIG_EDIT.OnTyping(Sender: TObject);
begin
  if extrafe.prog.State = 'main_config_profile_password' then
  begin
    if TEdit(Sender).Name = 'Main_Config_Profile_Password_Main_Current_V_Label' then
      mainScene.Config.Main.R.Profile.User.Pass.Main.Warning.Visible := False
    else if TEdit(Sender).Name = 'Main_Config_Profile_Password_Main_New_V_Label' then
      mainScene.Config.Main.R.Profile.User.Pass.Main.Warning.Visible := False
    else if TEdit(Sender).Name = 'Main_Config_Profile_Password_Main_NewRewrite_V_Label' then
      mainScene.Config.Main.R.Profile.User.Pass.Main.Warning.Visible := False
  end;
end;

{ TMAIN_CONFIG_BUTTON }

procedure TMAIN_CONFIG_BUTTON.OnMouseClick(Sender: TObject);
begin
  if extrafe.prog.State = 'main_config' then
  begin
    if TButton(Sender).TagFloat = 1000 then
      uMain_Config_Emulators_Start_Emu_Wizard(TButton(Sender))
    else if TButton(Sender).Name = 'Main_Config_Button_' + IntToStr(TButton(Sender).Tag) then
      uMain_Config_ShowPanel(TButton(Sender).Tag)
//    else if TButton(Sender).Name = 'Main_Config_Themes_Apply' then
//      uMain_Config_Themes_ApplyTheme(mainScene.Config.Main.R.Themes.Box.Items.Strings
//        [mainScene.Config.Main.R.Themes.Box.ItemIndex])
    else if TButton(Sender).Name = 'Main_Config_Addons_Addon_Weather_Action' then
      uMain_Config_Addons_Actions_AddonActivation(2)
    else if TButton(Sender).Name = 'Main_Config_Addons_Addon_Soundplayer_Action' then
      uMain_Config_Addons_Actions_AddonActivation(3)
    else if TButton(Sender).Name = 'Main_Config_Addons_Addon_Play_Action' then
      uMain_Config_Addons_Actions_AddonActivation(4);
  end
  else if extrafe.prog.State = 'main_config_profile_avatar' then
  begin
    if TButton(Sender).Name = 'Main_Config_Profile_Avatar_Main_Cancel' then
      uMain_Config_Profile_ReturnToProfile
    else if TButton(Sender).Name = 'Main_Config_Profile_Avatar_Main_Change' then
      uMain_Config_Profile_Avatar_Change
  end
  else if extrafe.prog.State = 'main_config_profile_password' then
  begin
    if TButton(Sender).Name = 'Main_Config_Profile_Password_Main_Cancel' then
      uMain_Config_Profile_ReturnToProfile
    else if TButton(Sender).Name = 'Main_Config_Profile_Password_Main_Change' then
      uMain_Config_Profile_Password_Change
  end
  else if extrafe.prog.State = 'main_config_addons_actions' then
  begin
    if TButton(Sender).Name = 'Main_Config_Addons_Weather_Deactivate_Msg_Main_OK' then
      uMain_Config_Addons_Actions_Deactivate_Weather_Action
    else if TButton(Sender).Name = 'Main_Config_Addons_Weather_Deactivate_Msg_Main_Cancel' then
      uMain_Config_Addons_Actions_Deactivate_Weather_FreeMessage
    else if TButton(Sender).Name = 'Main_Config_Addons_Weather_Activate_Msg_Main_OK' then
      uMain_Config_Addons_Actions_Activate_Weather_Action
    else if TButton(Sender).Name = 'Main_Config_Addons_Weather_Activate_Msg_Main_Cancel' then
      uMain_Config_Addons_Actions_Activate_Weather_FreeMessage
    else if TButton(Sender).Name = 'Main_Config_Addons_Soundplayer_Deactivate_Msg_Main_OK' then
      uMain_Config_Addons_Actions_Deactivate_Soundplayer_Action
    else if TButton(Sender).Name = 'Main_Config_Addons_Soundplayer_Deactivate_Msg_Main_Cancel' then
      uMain_Config_Addons_Actions_Deactivate_Soundplayer_FreeMessage
    else if TButton(Sender).Name = 'Main_Config_Addons_Soundplayer_Activate_Msg_Main_OK' then
      uMain_Config_Addons_Actions_Activate_Soundplayer_Action
    else if TButton(Sender).Name = 'Main_Config_Addons_Soundplayer_Activate_Msg_Main_Cancel' then
      uMain_Config_Addons_Actions_Activate_Soundplayer_FreeMessage
  end;
end;

procedure TMAIN_CONFIG_BUTTON.OnMouseEnter(Sender: TObject);
begin

end;

procedure TMAIN_CONFIG_BUTTON.OnMouseLeave(Sender: TObject);
begin

end;

{ TMAIN_CONFIG_RADIOBUTTON }

procedure TMAIN_CONFIG_RADIOBUTTON.OnMouseClick(Sender: TObject);
begin
  if extrafe.prog.State = 'main_config_addons_actions' then
  begin
    if (TRadioButton(Sender).Name = 'Main_Config_Addons_Weather_Deactivate_Msg_Main_Radio_1') or
      (TRadioButton(Sender).Name = 'Main_Config_Addons_Weather_Deactivate_Msg_Main_Radio_2') then
      mainScene.Config.Main.R.Addons.Weather.Msg_Deactv.Main.OK.Enabled := True
    else if (TRadioButton(Sender).Name = 'Main_Config_Addons_Weather_Activate_Msg_Main_Radio_1') or
      (TRadioButton(Sender).Name = 'Main_Config_Addons_Weather_Activate_Msg_Main_Radio_2') then
      mainScene.Config.Main.R.Addons.Weather.Msg_Actv.Main.OK.Enabled := True
    else if (TRadioButton(Sender).Name = 'Main_Config_Addons_Soundplayer_Deactivate_Msg_Main_Radio_1') or
      (TRadioButton(Sender).Name = 'Main_Config_Addons_Soundplayer_Deactivate_Msg_Main_Radio_2') then
      mainScene.Config.Main.R.Addons.Soundplayer.Msg_Deactv.Main.OK.Enabled := True
    else if (TRadioButton(Sender).Name = 'Main_Config_Addons_Soundplayer_Activate_Msg_Main_Radio_1') or
      (TRadioButton(Sender).Name = 'Main_Config_Addons_Soundplayer_Activate_Msg_Main_Radio_2') then
      mainScene.Config.Main.R.Addons.Soundplayer.Msg_Actv.Main.OK.Enabled := True;
  end;
end;

initialization

ex_main.Input.mouse_config.Image := TMAIN_CONFIG_IMAGE.Create;
ex_main.Input.mouse_config.Text := TMAIN_CONFIG_TEXT.Create;
ex_main.Input.mouse_config.Edit := TMAIN_CONFIG_EDIT.Create;
ex_main.Input.mouse_config.Button := TMAIN_CONFIG_BUTTON.Create;
ex_main.Input.mouse_config.Radio := TMAIN_CONFIG_RADIOBUTTON.Create;

finalization

ex_main.Input.mouse_config.Image.Free;
ex_main.Input.mouse_config.Text.Free;
ex_main.Input.mouse_config.Edit.Free;
ex_main.Input.mouse_config.Button.Free;
ex_main.Input.mouse_config.Radio.Free;

end.
