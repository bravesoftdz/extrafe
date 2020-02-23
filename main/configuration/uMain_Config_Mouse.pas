unit uMain_Config_Mouse;

interface

uses
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  System.UiTypes,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Edit,
  FMX.TABControl,
  BASS;

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
  TMAIN_CONFIG_SPEEDBUTTON = class(TObject)
    procedure OnMouseClick(Sender: TObject);
  end;

type
  TMAIN_CONFIG_CHECKBOX = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TMAIN_CONFIG_TABITEM = class(TObject)
    procedure OnMouseClick(Sender: TObject);
  end;

type
  TMAIN_MOUSE_CONFIG_ACTIONS = record
    Image: TMAIN_CONFIG_IMAGE;
    Text: TMAIN_CONFIG_TEXT;
    Edit: TMAIN_CONFIG_EDIT;
    Button: TMAIN_CONFIG_BUTTON;
    Radio: TMAIN_CONFIG_RADIOBUTTON;
    Speedbutton: TMAIN_CONFIG_SPEEDBUTTON;
    Checkbox: TMAIN_CONFIG_CHECKBOX;
    TabItem: TMAIN_CONFIG_TABITEM;
  end;

implementation

uses
  uLoad_AllTypes,
  uSnippet_Text,
  uSnippets,
  uMain_SetAll,
  uMain_AllTypes,
  uMain_Config,
  uMain_Config_Profile,
  uMain_Config_Emulators,
  uMain_Config_Addons,
  uMain_Config_Addons_Actions,
  uMain_Config_Themes,
  uMain_Config_Info,
  uMain_Config_General,
  uMain_Config_General_Visual,
  uMain_Config_General_Keyboard,
  uMain_Config_Info_Extrafe,
  uMain_Config_Info_Credits,
  uMain_Config_Profile_User;

{ TMAIN_CONFIG_IMAGE }

procedure TMAIN_CONFIG_IMAGE.OnMouseClick(Sender: TObject);
begin
  if extrafe.prog.State = 'main_config_profile_avatar' then
  begin
    if TImage(Sender).Name = 'Main_Config_Profile_Avatar_Image_' + TImage(Sender).Tag.ToString then
      uMain_Config_Profile_User.Avatar_Select(TImage(Sender).Tag);
  end
  else if extrafe.prog.State = 'main_config_profile_user' then
  begin
    if TImage(Sender).Name = 'Main_Config_Profile_Main_Avatar' then
      uMain_Config_Profile_User.Avatar;
  end
  else if extrafe.prog.State = 'main_config_emulators' then
  begin
    if TImage(Sender).Name = 'Main_Config_Emulators_Image_' + IntToStr(TImage(Sender).Tag) then
      uMain_Config_Emulators.ShowCategory(TImage(Sender).Tag);
    BASS_ChannelPlay(sound.str_fx.general[0], False);
  end
  else if extrafe.prog.State = 'main_config_info' then
  begin
    if TImage(Sender).Name = 'Main_Config_Info_ExtraFE_Stable_Left' then
      uMain_Config_Info_Extrafe.Previous_Stable
    else if TImage(Sender).Name = 'Main_Config_Info_ExtraFE_Stable_Right' then
      uMain_Config_Info_Extrafe.Next_Stable
    else if TImage(Sender).Name = 'Main_Config_Info_ExtraFE_LastBuild_Left' then
      uMain_Config_Info_Extrafe.Previous_Build
    else if TImage(Sender).Name = 'Main_Config_Info_ExtraFE_LastBuild_Right' then
      uMain_Config_Info_Extrafe.Next_Build
    else if ContainsText(TImage(Sender).Name, 'Main_Config_Info_Credits_Image_') then
    begin
      if (ex_main.Config.Info_Credits_Tab_Selected <> vTab_Selected) or (ex_main.Config.Info_Credits_Selected <> TImage(Sender).Tag) then
        uMain_Config_Info_Credits.Brand_Show((TImage(Sender).TagString).ToInteger, TImage(Sender).Tag);
    end;
  end;
end;

procedure TMAIN_CONFIG_IMAGE.OnMouseEnter(Sender: TObject);
begin
  if extrafe.prog.State = 'main_config_profile_avatar' then
  begin
    if TImage(Sender).Name = 'Main_Config_Profile_Avatar_Image_' + TImage(Sender).Tag.ToString then
    begin
      TImage(Sender).Cursor := crHandPoint;
      if mainScene.Config.Main.R.Profile.User.Avatar.Main.AVatar_Glow[TImage(Sender).Tag].GlowColor <> TAlphaColorRec.White then
        mainScene.Config.Main.R.Profile.User.Avatar.Main.AVatar_Glow[TImage(Sender).Tag].Enabled := True;
    end;
  end
  else if extrafe.prog.State = 'main_config_profile_user' then
  begin
    if TImage(Sender).Name = 'Main_Config_Profile_Main_Avatar' then
    begin
      TImage(Sender).Cursor := crHandPoint;
      uMain_Config_Profile_User.AVatar_Glow(mainScene.Config.Main.R.Profile.User.Avatar_Change);
    end;
  end
  else if extrafe.prog.State = 'main_config_emulators' then
  begin
    if TImage(Sender).Name = 'Main_Config_Emulators_Image_' + IntToStr(TImage(Sender).Tag) then
    begin
      mainScene.Config.Main.R.Emulators.Images_Glow[TImage(Sender).Tag].Enabled := True;
      TImage(Sender).Cursor := crHandPoint;
    end
    else if (TImage(Sender).Name = 'Main_Config_Emulators_Arcade_MAME_Logo') or (TImage(Sender).Name = 'Main_Config_Emulators_Arcade_MAME_Logo_Check') then
    begin
      if mainScene.Config.Main.R.Emulators.Arcade[0].Logo_Gray.Enabled = False then
      begin
        mainScene.Config.Main.R.Emulators.Arcade[0].Logo_Glow.Enabled := True;
        TImage(Sender).Cursor := crHandPoint;
      end;
    end
  end
  else if extrafe.prog.State = 'main_config_info' then
  begin
    if ContainsText(TImage(Sender).Name, 'Main_Config_Info_Credits_Image_') then
    begin
      if (ex_main.Config.Info_Credits_Tab_Selected <> vTab_Selected) or (ex_main.Config.Info_Credits_Selected <> TImage(Sender).Tag) then
        mainScene.Config.Main.R.Info.Credits.Brand_Glow[(TImage(Sender).TagString).ToInteger, TImage(Sender).Tag].Enabled := True;
    end;
  end;
end;

procedure TMAIN_CONFIG_IMAGE.OnMouseLeave(Sender: TObject);
begin
  if extrafe.prog.State = 'main_config_profile_avatar' then
  begin
    if TImage(Sender).Name = 'Main_Config_Profile_Avatar_Image_' + IntToStr(TImage(Sender).Tag) then
    begin
      if mainScene.Config.Main.R.Profile.User.Avatar.Main.AVatar_Glow[TImage(Sender).Tag].GlowColor <> TAlphaColorRec.White then
        mainScene.Config.Main.R.Profile.User.Avatar.Main.AVatar_Glow[TImage(Sender).Tag].Enabled := False;
    end;
  end
  else if extrafe.prog.State = 'main_config_profile_user' then
  begin
    if TImage(Sender).Name = 'Main_Config_Profile_Main_Avatar' then
    begin
      TImage(Sender).Cursor := crHandPoint;
      uMain_Config_Profile_User.Avatar_Glow_Free(mainScene.Config.Main.R.Profile.User.Avatar_Change);
    end;
  end
  else if extrafe.prog.State = 'main_config_emulators' then
  begin
    if TImage(Sender).Name = 'Main_Config_Emulators_Image_' + IntToStr(TImage(Sender).Tag) then
      mainScene.Config.Main.R.Emulators.Images_Glow[TImage(Sender).Tag].Enabled := False
    else if (TImage(Sender).Name = 'Main_Config_Emulators_Arcade_MAME_Logo') or (TImage(Sender).Name = 'Main_Config_Emulators_Arcade_MAME_Logo_Check') then
    begin
      if mainScene.Config.Main.R.Emulators.Arcade[0].Logo_Gray.Enabled = False then
        mainScene.Config.Main.R.Emulators.Arcade[0].Logo_Glow.Enabled := False
    end
  end
  else if extrafe.prog.State = 'main_config_info' then
  begin
    if ContainsText(TImage(Sender).Name, 'Main_Config_Info_Credits_Image_') then
    begin
      if (ex_main.Config.Info_Credits_Tab_Selected <> vTab_Selected) or (ex_main.Config.Info_Credits_Selected <> TImage(Sender).Tag) then
        mainScene.Config.Main.R.Info.Credits.Brand_Glow[(TImage(Sender).TagString).ToInteger, TImage(Sender).Tag].Enabled := False;
    end;
  end
end;

{ TMAIN_CONFIG_TEXT }

procedure TMAIN_CONFIG_TEXT.OnMouseClick(Sender: TObject);
begin
  if extrafe.prog.State = 'main_config_profile_avatar' then
  begin
    if TText(Sender).Name = 'Main_Config_Profile_Avatar_Left' then
    begin
      if vAvatar.Page > 0 then
      begin
        mainScene.Config.Main.R.Profile.User.Avatar.Main.Control.SetActiveTabWithTransition
          (mainScene.Config.Main.R.Profile.User.Avatar.Main.Tabs[vAvatar.Page - 1], TTabTransition.Slide, TTabTransitionDirection.Reversed);
        uMain_Config_Profile_User.Avatar_Page(vAvatar.Page - 1);
      end;
    end
    else if TText(Sender).Name = 'Main_Config_Profile_Avatar_Right' then
    begin
      if vAvatar.Page < vAvatar.Pages then
      begin
        mainScene.Config.Main.R.Profile.User.Avatar.Main.Control.SetActiveTabWithTransition
          (mainScene.Config.Main.R.Profile.User.Avatar.Main.Tabs[vAvatar.Page + 1], TTabTransition.Slide);
        uMain_Config_Profile_User.Avatar_Page(vAvatar.Page + 1);
      end;
    end;
  end
  else if extrafe.prog.State = 'main_config_profile_user' then
  begin
    if TText(Sender).Name = 'Main_Config_Profile_Main_Avatar_Change' then
      uMain_Config_Profile_User.Avatar
    else if TText(Sender).Name = 'Main_Config_Profile_Main_Password_Change' then
      uMain_Config_Profile_User.Password
    else if TImage(Sender).Name = 'Main_Config_Profile_Main_Gender_Male' then
      uMain_Config_Profile_User.Genre('1')
    else if TImage(Sender).Name = 'Main_Config_Profile_Main_Gender_Female' then
      uMain_Config_Profile_User.Genre('0');
  end
  else if extrafe.prog.State = 'main_config_info' then
  begin
    if TText(Sender).Name = 'Main_Config_Info_ExtraFE_Homepage_V' then
      uSnippets.Open_Link_To_Browser(TText(Sender).Text)
    else if TText(Sender).Name = 'Main_Config_Info_ExtraFE_Documentation_V' then
      uSnippets.Open_Link_To_Browser(TText(Sender).Text)
    else if TText(Sender).Name = 'Main_Config_Info_ExtraFE_Forum_V' then
      uSnippets.Open_Link_To_Browser(TText(Sender).Text);
  end
  else if extrafe.prog.State = 'main_config_addons' then
  begin
    if TText(Sender).TextSettings.FontColor <> TAlphaColorRec.Grey then
    begin
      if TText(Sender).Name = 'Main_Config_Addons_Arrow_Left' then
        uMain_Config_Addons_Actions.LeftArrow
      else if TText(Sender).Name = 'Main_Config_Addons_Arrow_Right' then
        uMain_Config_Addons_Actions.RightArrow
      else if TText(Sender).Name = 'Main_Config_Addons_Groupbox_0_Image_' + IntToStr(TImage(Sender).Tag) then
        uMain_Config_Addons.ShowInfo(TImage(Sender).Tag);
    end;
  end
  else if extrafe.prog.State = 'main_config_general' then
  begin
    if vKey_Waiting = False then
    begin
      if (TText(Sender).Name = 'Main_Config_General_Keyboard_General_Panel_Text_' + TText(Sender).Tag.ToString) or
        (TText(Sender).Name = 'Main_Config_General_Keyboard_Emu_Panel_Text_' + TText(Sender).Tag.ToString) then
      begin
        vSelected_Tab := mainScene.Config.Main.R.General.Keyboard.TabControl.TabIndex;
        vSelected_Label := TText(Sender).Tag;
        uMain_Config_General_Keyboard.Click_To_Accept_Key;
      end;
    end;
  end;
  BASS_ChannelPlay(sound.str_fx.general[0], False);
end;

procedure TMAIN_CONFIG_TEXT.OnMouseEnter(Sender: TObject);
begin
  if extrafe.prog.State = 'main_config_profile_avatar' then
  begin
    TText(Sender).Cursor := crHandPoint;
    if TText(Sender).Name = 'Main_Config_Profile_Avatar_Left' then
      mainScene.Config.Main.R.Profile.User.Avatar.Main.Arrow_Left_Glow.Enabled := True
    else if TText(Sender).Name = 'Main_Config_Profile_Avatar_Right' then
      mainScene.Config.Main.R.Profile.User.Avatar.Main.Arrow_Right_Glow.Enabled := True
  end
  else if extrafe.prog.State = 'main_config_profile_user' then
  begin
    if TText(Sender).Name = 'Main_Config_Profile_Main_Avatar_Change' then
      uMain_Config_Profile_User.AVatar_Glow(TText(Sender))
    else if TText(Sender).Name = 'Main_Config_Profile_Main_Password_Change' then
      uSnippets.HyperLink_OnMouseOver(TText(Sender))
    else if TImage(Sender).Name = 'Main_Config_Profile_Main_Gender_Male' then
    begin
      TText(Sender).Cursor := crHandPoint;
      mainScene.Config.Main.R.Profile.User.Gender_Male_Glow.Enabled := True;
    end
    else if TImage(Sender).Name = 'Main_Config_Profile_Main_Gender_Female' then
    begin
      TText(Sender).Cursor := crHandPoint;
      mainScene.Config.Main.R.Profile.User.Gender_Female_Glow.Enabled := True;
    end;
  end
  else if extrafe.prog.State = 'main_config_info' then
  begin
    if TText(Sender).Name = 'Main_Config_Info_ExtraFE_Homepage_V' then
      uSnippets.HyperLink_OnMouseOver(TText(Sender))
    else if TText(Sender).Name = 'Main_Config_Info_ExtraFE_Documentation_V' then
      uSnippets.HyperLink_OnMouseOver(TText(Sender))
    else if TText(Sender).Name = 'Main_Config_Info_ExtraFE_Forum_V' then
      uSnippets.HyperLink_OnMouseOver(TText(Sender));
  end
  else if extrafe.prog.State = 'main_config_addons' then
  begin
    if TText(Sender).Name = 'Main_Config_Addons_Arrow_Left' then
      mainScene.Config.Main.R.Addons.Arrow_Left_Glow.Enabled := True
    else if TText(Sender).Name = 'Main_Config_Addons_Arrow_Right' then
      mainScene.Config.Main.R.Addons.Arrow_Right_Glow.Enabled := True
    else if TText(Sender).Name = 'Main_Config_Addons_Groupbox_0_Image_' + IntToStr(TImage(Sender).Tag) then
      mainScene.Config.Main.R.Addons.Icons_Glow[TImage(Sender).Tag].Enabled := True;
  end
  else if extrafe.prog.State = 'main_config_general' then
  begin
    if vKey_Waiting = False then
    begin
      if (TText(Sender).Name = 'Main_Config_General_Keyboard_General_Panel_Text_' + TText(Sender).Tag.ToString) or
        (TText(Sender).Name = 'Main_Config_General_Keyboard_Emu_Panel_Text_' + TText(Sender).Tag.ToString) then
      begin
        TText(Sender).Text := 'Click to Change';
        TText(Sender).TextSettings.FontColor := TAlphaColorRec.Black;
      end;
    end;
  end;
  TText(Sender).Cursor := crHandPoint;
end;

procedure TMAIN_CONFIG_TEXT.OnMouseLeave(Sender: TObject);
begin
  if extrafe.prog.State = 'main_config_profile_avatar' then
  begin
    if TText(Sender).Name = 'Main_Config_Profile_Avatar_Left' then
      mainScene.Config.Main.R.Profile.User.Avatar.Main.Arrow_Left_Glow.Enabled := False
    else if TText(Sender).Name = 'Main_Config_Profile_Avatar_Right' then
      mainScene.Config.Main.R.Profile.User.Avatar.Main.Arrow_Right_Glow.Enabled := False
  end
  else if extrafe.prog.State = 'main_config_profile_user' then
  begin
    if TText(Sender).Name = 'Main_Config_Profile_Main_Avatar_Change' then
      uMain_Config_Profile_User.Avatar_Glow_Free(TText(Sender))
    else if TText(Sender).Name = 'Main_Config_Profile_Main_Password_Change' then
      uSnippets.HyperLink_OnMouseLeave(TImage(Sender), TAlphaColorRec.White)
    else if TImage(Sender).Name = 'Main_Config_Profile_Main_Gender_Male' then
    begin
      if vTemp_Personal.Genre <> 1 then
        mainScene.Config.Main.R.Profile.User.Gender_Male_Glow.Enabled := False
    end
    else if TImage(Sender).Name = 'Main_Config_Profile_Main_Gender_Female' then
    begin
      if vTemp_Personal.Genre <> 0 then
        mainScene.Config.Main.R.Profile.User.Gender_Female_Glow.Enabled := False
    end
  end
  else if extrafe.prog.State = 'main_config_info' then
  begin
    if TText(Sender).Name = 'Main_Config_Info_ExtraFE_Homepage_V' then
      uSnippets.HyperLink_OnMouseLeave(TText(Sender), TAlphaColorRec.White)
    else if TText(Sender).Name = 'Main_Config_Info_ExtraFE_Documentation_V' then
      uSnippets.HyperLink_OnMouseLeave(TText(Sender), TAlphaColorRec.White)
    else if TText(Sender).Name = 'Main_Config_Info_ExtraFE_Forum_V' then
      uSnippets.HyperLink_OnMouseLeave(TText(Sender), TAlphaColorRec.White);
  end
  else if extrafe.prog.State = 'main_config_addons' then
  begin
    if TText(Sender).Name = 'Main_Config_Addons_Arrow_Left' then
      mainScene.Config.Main.R.Addons.Arrow_Left_Glow.Enabled := False
    else if TText(Sender).Name = 'Main_Config_Addons_Arrow_Right' then
      mainScene.Config.Main.R.Addons.Arrow_Right_Glow.Enabled := False
    else if TImage(Sender).Name = 'Main_Config_Addons_Groupbox_0_Image_' + IntToStr(TImage(Sender).Tag) then
      mainScene.Config.Main.R.Addons.Icons_Glow[TImage(Sender).Tag].Enabled := False;
  end
  else if extrafe.prog.State = 'main_config_general' then
  begin
    if vKey_Waiting = False then
    begin
      if (TText(Sender).Name = 'Main_Config_General_Keyboard_General_Panel_Text_' + TText(Sender).Tag.ToString) or
        (TText(Sender).Name = 'Main_Config_General_Keyboard_Emu_Panel_Text_' + TText(Sender).Tag.ToString) then
      begin
        TText(Sender).Text := 'Press any Key';
        TText(Sender).TextSettings.FontColor := TAlphaColorRec.White;
      end;
    end;
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
  if extrafe.prog.State = 'main_config_profile_user' then
  begin
    if TEdit(Sender).Name = 'Main_Config_Profile_Main_Name_Edit' then
      uMain_Config_Profile_User.Name(TEdit(Sender).Text)
    else if TEdit(Sender).Name = 'Main_Config_Profile_Main_Surname_Edit' then
      uMain_Config_Profile_User.Surname(TEdit(Sender).Text);
  end
  else if extrafe.prog.State = 'main_config_profile_password' then
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
  if ContainsText(extrafe.prog.State, 'main_config') then
  begin
    if TButton(Sender).Name = 'Main_Config_Button_' + IntToStr(TButton(Sender).Tag) then
      uMain_Config.ShowPanel(TButton(Sender).Tag)
    else if extrafe.prog.State = 'main_config_emulators' then
    begin
      if TButton(Sender).TagFloat = 1000 then
        uMain_Config_Emulators.Start_Emu_Wizard(TButton(Sender))
    end
    else if extrafe.prog.State = 'main_config_addons' then
    begin
      if TButton(Sender).Name = 'Main_Config_Addons_Addon_Weather_Action' then
        uMain_Config_Addons_Actions.Activation(2)
      else if TButton(Sender).Name = 'Main_Config_Addons_Addon_Soundplayer_Action' then
        uMain_Config_Addons_Actions.Activation(3)
      else if TButton(Sender).Name = 'Main_Config_Addons_Addon_Play_Action' then
        uMain_Config_Addons_Actions.Activation(4);
    end
    else if extrafe.prog.State = 'main_config_profile_user' then
    begin
      if TButton(Sender).Name = 'Main_Config_Profile_Main_Apply_Changes' then
        uMain_Config_Profile_User.Apply_Changes
    end
    else if extrafe.prog.State = 'main_config_profile_avatar' then
    begin
      if TButton(Sender).Name = 'Main_Config_Profile_Avatar_Main_Cancel' then
        uMain_Config_Profile_User.Return
      else if TButton(Sender).Name = 'Main_Config_Profile_Avatar_Main_Change' then
        uMain_Config_Profile_User.Avatar_Change
    end
    else if extrafe.prog.State = 'main_config_profile_password' then
    begin
      if TButton(Sender).Name = 'Main_Config_Profile_Password_Main_Cancel' then
        uMain_Config_Profile_User.Return
      else if TButton(Sender).Name = 'Main_Config_Profile_Password_Main_Change' then
        uMain_Config_Profile_User.Password_Change
    end
    else if extrafe.prog.State = 'main_config_addons_actions' then
    begin
      if TButton(Sender).Name = 'Main_Config_Addons_Weather_Deactivate_Msg_Main_OK' then
        uMain_Config_Addons_Actions.Weather_Deactivate_Action
      else if TButton(Sender).Name = 'Main_Config_Addons_Weather_Deactivate_Msg_Main_Cancel' then
        uMain_Config_Addons_Actions.Weather_Free
      else if TButton(Sender).Name = 'Main_Config_Addons_Weather_Activate_Msg_Main_OK' then
        uMain_Config_Addons_Actions.Weather_Activate_Action
      else if TButton(Sender).Name = 'Main_Config_Addons_Weather_Activate_Msg_Main_Cancel' then
        uMain_Config_Addons_Actions.Weather_Activate_FreeMessage
      else if TButton(Sender).Name = 'Main_Config_Addons_Soundplayer_Deactivate_Msg_Main_OK' then
        uMain_Config_Addons_Actions.Soundplayer_Deactivate_Action
      else if TButton(Sender).Name = 'Main_Config_Addons_Soundplayer_Deactivate_Msg_Main_Cancel' then
        uMain_Config_Addons_Actions.Soundplayer_Free
      else if TButton(Sender).Name = 'Main_Config_Addons_Soundplayer_Activate_Msg_Main_OK' then
        uMain_Config_Addons_Actions.Soundplayer_Activate_Action
      else if TButton(Sender).Name = 'Main_Config_Addons_Soundplayer_Activate_Msg_Main_Cancel' then
        uMain_Config_Addons_Actions.Soundplayer_Activate_FreeMessage
    end;
  end;
  BASS_ChannelPlay(sound.str_fx.general[0], False);
end;

procedure TMAIN_CONFIG_BUTTON.OnMouseEnter(Sender: TObject);
begin
  TButton(Sender).Cursor := crHandPoint;
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

{ TMAIN_CONFIG_SPEEDBUTTON }

procedure TMAIN_CONFIG_SPEEDBUTTON.OnMouseClick(Sender: TObject);
begin
  if extrafe.prog.State = 'main_config_info' then
  begin
    if TSpeedButton(Sender).Name = 'Main_Config_Info_ExtraFE_Stable_Left' then
      uMain_Config_Info_Extrafe.Previous_Stable
    else if TSpeedButton(Sender).Name = 'Main_Config_Info_ExtraFE_Stable_Right' then
      uMain_Config_Info_Extrafe.Next_Stable
    else if TSpeedButton(Sender).Name = 'Main_Config_Info_ExtraFE_LastBuild_Left' then
      uMain_Config_Info_Extrafe.Previous_Build
    else if TSpeedButton(Sender).Name = 'Main_Config_Info_ExtraFE_LastBuild_Right' then
      uMain_Config_Info_Extrafe.Next_Build;
  end;
end;

{ TMAIN_CONFIG_CHECKBOX }

procedure TMAIN_CONFIG_CHECKBOX.OnMouseClick(Sender: TObject);
begin
  if TCheckBox(Sender).Name = 'Main_Config_General_Visual_VirtualKeyboard' then
    uMain_Config_General_Visual.Update_Virtual_Keyboard(not TCheckBox(Sender).IsChecked);
end;

procedure TMAIN_CONFIG_CHECKBOX.OnMouseEnter(Sender: TObject);
begin

end;

procedure TMAIN_CONFIG_CHECKBOX.OnMouseLeave(Sender: TObject);
begin

end;

{ TMAIN_CONFIG_TABITEM }

procedure TMAIN_CONFIG_TABITEM.OnMouseClick(Sender: TObject);
begin
  if TTabItem(Sender).Name = 'Main_Config_Info_Credits_TabItem_0' then
    vTab_Selected := 0
  else if TTabItem(Sender).Name = 'Main_Config_Info_Credits_TabItem_1' then
    vTab_Selected := 1;
end;

initialization

ex_main.Input.mouse_config.Image := TMAIN_CONFIG_IMAGE.Create;
ex_main.Input.mouse_config.Text := TMAIN_CONFIG_TEXT.Create;
ex_main.Input.mouse_config.Edit := TMAIN_CONFIG_EDIT.Create;
ex_main.Input.mouse_config.Button := TMAIN_CONFIG_BUTTON.Create;
ex_main.Input.mouse_config.Radio := TMAIN_CONFIG_RADIOBUTTON.Create;
ex_main.Input.mouse_config.Speedbutton := TMAIN_CONFIG_SPEEDBUTTON.Create;
ex_main.Input.mouse_config.Checkbox := TMAIN_CONFIG_CHECKBOX.Create;
ex_main.Input.mouse_config.TabItem := TMAIN_CONFIG_TABITEM.Create;

finalization

ex_main.Input.mouse_config.Image.Free;
ex_main.Input.mouse_config.Text.Free;
ex_main.Input.mouse_config.Edit.Free;
ex_main.Input.mouse_config.Button.Free;
ex_main.Input.mouse_config.Radio.Free;
ex_main.Input.mouse_config.Speedbutton.Free;
ex_main.Input.mouse_config.Checkbox.Free;
ex_main.Input.mouse_config.TabItem.Free;

end.
