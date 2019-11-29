unit uKeyboard;

interface

uses
  System.Classes,
  System.StrUtils,
  System.SysUtils,
  Winapi.Windows,
  FMX.Dialogs,
  FMX.Forms,
  Winapi.Hooks;

procedure uKeyboard_HookKeyboard;
procedure MapKeyboard(vKey: String);

var
  FHook: THook;

implementation

uses
  load,
  main,
  uload,
  uLoad_Keyboard,
  uLoad_AllTypes,
  uEmu_Actions,
  uEmu_Arcade_Mame_Keyboard,
  uMain_Keyboard,
  uWeather_Keyboard,
  uSoundplayer_Keyboard,
  uVirtual_Keyboard,
  uSnippet_Search;

procedure uKeyboard_HookKeyboard;
begin
  FHook := THookInstance<TLowLevelKeyboardHook>.CreateHook(Main_Form);
  FHook.OnPreExecute := procedure(Hook: THook; var HookMsg: THookMessage)
    var
      LLKeyBoardHook: TLowLevelKeyboardHook;
      ScanCode: integer;
    begin
      LLKeyBoardHook := TLowLevelKeyboardHook(Hook);

      if LLKeyBoardHook.LowLevelKeyStates.KeyState <> ksKeyDown then
        exit;

      ScanCode := LLKeyBoardHook.KeyName.ScanCode;

      // if not(ScanCode in [VK_NUMPAD0 .. VK_NUMPAD9, VK_0 .. VK_9]) then
      if not(ScanCode in [VK_NUMPAD0 .. VK_NUMPAD9]) then
      begin
        MapKeyboard(LLKeyBoardHook.KeyName.KeyExtName);
        HookMsg.Result := 0; // 0 For Free ; 1 For blocked
      end;
    end;
end;

procedure MapKeyboard(vKey: String);
begin
  if uSnippet_Search.vSearch.Actions.Active then
    if uSnippet_Search.vSearch.Actions.CanIType then
      uSnippet_Search.Key(vKey);
  if extrafe.prog.State = 'virtual_keyboard' then
    uVirtual_Keyboard.Key(vKey)
  else if ContainsText(extrafe.prog.State, 'load') then
    uLoad_Keyboard.SetKey(vKey)
  else if ContainsText(extrafe.prog.State, 'main') then
    uMain_Keyboard.SetKey(vKey)
  else if ContainsText(extrafe.prog.State, 'mame') then
    uEmu_Arcade_Mame_Keyboard_SetKey(vKey)
  else if ContainsText(extrafe.prog.State, 'addon_weather') then
    uWeather_Keyboard_SetKey(vKey)
  else if ContainsText(extrafe.prog.State, 'addon_soundplayer') then
    uSoundplayer_Keyboard_SetKey(vKey);
end;

end.
