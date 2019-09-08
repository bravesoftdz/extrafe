unit uMain_Config_Emulation_Arcade_Scripts_Mouse;

interface

uses
  System.Classes,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.TabControl;

type
  TMAIN_MOUSE_CONFIG_EMULATION_ARCADE_BUTTON = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TMAIN_MOUSE_CONFIG_EMULATION_ARCADE_RADIO = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TMAIN_MOUSE_CONFIG_EMULATION_ARCADE_ACTIONS = record
    Button: TMAIN_MOUSE_CONFIG_EMULATION_ARCADE_BUTTON;
    Radio: TMAIN_MOUSE_CONFIG_EMULATION_ARCADE_RADIO;
  end;

implementation

uses
  uLoad_AllTypes,
  uMain_AllTypes,
  uMain_Config_Emulation_Arcade_Scripts_Mame_Install,
  uMain_Config_Emulation_Arcade_Scripts_Mame_Uninstall;

{ TMAIN_MOUSE_CONFIG_EMULATION_ARCADE_BUTTON }

procedure TMAIN_MOUSE_CONFIG_EMULATION_ARCADE_BUTTON.OnMouseClick(Sender: TObject);
begin
  if (TButton(Sender).Name = 'Script_Mame_Install_Main_Tab1_Cancel') or (TButton(Sender).Name = 'Script_Mame_Install_Main_Tab2_Cancel') or
    (TButton(Sender).Name = 'Script_Mame_Install_Main_Tab3_Cancel') or (TButton(Sender).Name = 'Script_Mame_Install_Main_Tab4_Close') then
    uEmulation_Arcade_Mame_Install_Free
  else if TButton(Sender).Name = 'Script_Mame_Install_Main_Tab1_Next' then
    Script_Mame_Install.Main.Control.SetActiveTabWithTransition(Script_Mame_Install.Main.Tabs[1], TTabTransition.Slide)
  else if TButton(Sender).Name = 'Script_Mame_Install_Main_Tab2_Back' then
    Script_Mame_Install.Main.Control.SetActiveTabWithTransition(Script_Mame_Install.Main.Tabs[0], TTabTransition.Slide, TTabTransitionDirection.Reversed)
  else if TButton(Sender).Name = 'Script_Mame_Install_Main_Tab2_Next' then
    uEmulation_Arcade_Mame_Install_ChooseInstallationType_ShowTab3
  else if TButton(Sender).Name = 'Script_Mame_Install_Main_Tab3_Find' then
    Script_Mame_Install.Main.Tab3.Open_Dialog.Execute
  else if TButton(Sender).Name = 'Script_Mame_Install_Main_Tab3_Start' then
    uEmulation_Arcade_Mame_Install_Start_FromComputer
  else if TButton(Sender).Name = 'Script_Mame_Install_Main_Tab3_Next' then
    Script_Mame_Install.Main.Control.SetActiveTabWithTransition(Script_Mame_Install.Main.Tabs[3], TTabTransition.Slide)
  else if TButton(Sender).Name = 'Script_Mame_Install_Main_Tab3_Back' then
    Script_Mame_Install.Main.Control.SetActiveTabWithTransition(Script_Mame_Install.Main.Tabs[1], TTabTransition.Slide, TTabTransitionDirection.Reversed)
  else if (TButton(Sender).Name = 'Script_Mame_Uninstall_Main_Tab1_Cancel') or (TButton(Sender).Name = 'Script_Mame_Uninstall_Main_Tab2_Cancel') then
    uEmulation_Arcade_Mame_Uninstall_Free
  else if TButton(Sender).Name = 'Script_Mame_Uninstall_Main_Tab1_Next' then
    Script_Mame_Uninstall.Main.Control.SetActiveTabWithTransition(Script_Mame_Uninstall.Main.Tabs[1], TTabTransition.Slide)
  else if TButton(Sender).Name = 'Script_Mame_Uninstall_Main_Tab2_Back' then
    Script_Mame_Uninstall.Main.Control.SetActiveTabWithTransition(Script_Mame_Uninstall.Main.Tabs[0], TTabTransition.Slide, TTabTransitionDirection.Reversed)
  else if TButton(Sender).Name = 'Script_Mame_Uninstall_Main_Tab2_Next' then
    uEmulation_Arcade_Mame_Uninstall_Remove;
end;

procedure TMAIN_MOUSE_CONFIG_EMULATION_ARCADE_BUTTON.OnMouseEnter(Sender: TObject);
begin

end;

procedure TMAIN_MOUSE_CONFIG_EMULATION_ARCADE_BUTTON.OnMouseLeave(Sender: TObject);
begin

end;

{ TMAIN_MOUSE_CONFIG_EMULATION_ARCADE_RADIO }

procedure TMAIN_MOUSE_CONFIG_EMULATION_ARCADE_RADIO.OnMouseClick(Sender: TObject);
begin
  if (TRadioButton(Sender).Name = 'Script_Mame_Install_Main_Tab2_Radio_1') or (TRadioButton(Sender).Name = 'Script_Mame_Install_Main_Tab2_Radio_2') then
    Script_Mame_Install.Main.Tab2.Next.Visible := True;
end;

procedure TMAIN_MOUSE_CONFIG_EMULATION_ARCADE_RADIO.OnMouseEnter(Sender: TObject);
begin

end;

procedure TMAIN_MOUSE_CONFIG_EMULATION_ARCADE_RADIO.OnMouseLeave(Sender: TObject);
begin

end;

initialization

ex_main.Input.mouse_script_arcade.Button := TMAIN_MOUSE_CONFIG_EMULATION_ARCADE_BUTTON.Create;
ex_main.Input.mouse_script_arcade.Radio := TMAIN_MOUSE_CONFIG_EMULATION_ARCADE_RADIO.Create;

finalization

ex_main.Input.mouse_script_arcade.Button.Free;
ex_main.Input.mouse_script_arcade.Radio.Free;

end.
