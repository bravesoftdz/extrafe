library keyC;


uses
  SimpleShareMem,
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  FMX.Dialogs;

{$R *.res}


var
  Hook: HHOOK;
  hookedKey: WideString;
// variable to store hook handle to be used to unhook later
// routine that handles the keyboard events (when the hook is installed)

function HookKeyIs(vParam: Word): String;
begin
  case vParam of
    8 : Result:= 'Key_Backspace';
    9 : Result:= 'Key_Tab';
    13 : Result:= 'Key_Enter';
    16 : Result:= 'Key_Shift';
    17 : Result:= 'Key_Ctrl';
    18 : Result:= 'Key_Alt';
    19 : Result:= 'Key_Pause';
    20 : Result:= 'Key_Capital';
    27 : Result:= 'Key_Esc';
    32 : Result:= 'Key_Space';
    33 : Result:= 'Key_PageUp';
    34 : Result:= 'Key_PageDown';
    35 : Result:= 'Key_End';
    36 : Result:= 'Key_Home';
    37 : Result:= 'Key_ArrowLeft';
    38 : Result:= 'Key_ArrowUp';
    39 : Result:= 'Key_ArrowRight';
    40 : Result:= 'Key_ArrowDown';
    45 : Result:= 'Key_Insert';
    46 : Result:= 'Key_Delete';
    48 : Result:= 'Key_0';
    49 : Result:= 'Key_1';
    50 : Result:= 'Key_2';
    51 : Result:= 'Key_3';
    52 : Result:= 'Key_4';
    53 : Result:= 'Key_5';
    54 : Result:= 'Key_6';
    55 : Result:= 'Key_7';
    56 : Result:= 'Key_8';
    57 : Result:= 'Key_9';
    65 : Result:= 'Key_A';
    66 : Result:= 'Key_B';
    67 : Result:= 'Key_C';
    68 : Result:= 'Key_D';
    69 : Result:= 'Key_E';
    70 : Result:= 'Key_F';
    71 : Result:= 'Key_G';
    72 : Result:= 'Key_H';
    73 : Result:= 'Key_I';
    74 : Result:= 'Key_J';
    75 : Result:= 'Key_K';
    76 : Result:= 'Key_L';
    77 : Result:= 'Key_M';
    78 : Result:= 'Key_N';
    79 : Result:= 'Key_O';
    80 : Result:= 'Key_P';
    81 : Result:= 'Key_Q';
    82 : Result:= 'Key_R';
    83 : Result:= 'Key_S';
    84 : Result:= 'Key_T';
    85 : Result:= 'Key_U';
    86 : Result:= 'Key_V';
    87 : Result:= 'Key_W';
    88 : Result:= 'Key_X';
    89 : Result:= 'Key_Y';
    90 : Result:= 'Key_Z';
    91 : Result:= 'Key_LeftWin';
    92 : Result:= 'Key_RightWin';
    93 : Result:= 'Key_Special';
    96 : Result:= 'Key_Num0';
    97 : Result:= 'Key_Num1';
    98 : Result:= 'Key_Num2';
    99 : Result:= 'Key_Num3';
    100 : Result:= 'Key_Num4';
    101 : Result:= 'Key_Num5';
    102 : Result:= 'Key_Num6';
    103 : Result:= 'Key_Num7';
    104 : Result:= 'Key_Num8';
    105 : Result:= 'Key_Num9';
    106 : Result:= 'Key_Num*';
    107 : Result:= 'Key_Num+';
    109 : Result:= 'Key_Num-';
    110 : Result:= 'Key_Num.';
    111 : Result:= 'Key_Num/';
    112 : Result:= 'Key_F1';
    113 : Result:= 'Key_F2';
    114 : Result:= 'Key_F3';
    115 : Result:= 'Key_F4';
    116 : Result:= 'Key_F5';
    117 : Result:= 'Key_F6';
    118 : Result:= 'Key_F7';
    119 : Result:= 'Key_F8';
    120 : Result:= 'Key_F9';
    121 : Result:= 'Key_F10';
    122 : Result:= 'Key_F11';
    123 : Result:= 'Key_F12';
    144 : Result:= 'Key_NumLock';
    145 : Result:= 'Key_ScrollLock';
    186 : Result:= 'Key_;';
    187 : Result:= 'Key_+';
    188 : Result:= 'Key_,';
    189 : Result:= 'Key_-';
    190 : Result:= 'Key_.';
    191 : Result:= 'Key_/';
    219 : Result:= 'Key_[';
    220 : Result:= 'Key_\';
    221 : Result:= 'Key_]';
    222 : Result:= 'Key_''';
  end;
end;

function KBHookHandler(ACode: Integer; WParam: WParam; LParam: LParam): LResult; stdcall;
begin
  if ACode < 0 then
    begin
    // Immediately pass the event to next hook
      Result := CallNextHookEx(Hook, ACode, WParam, LParam);
      hookedKey := HookKeyIs(WParam);
      ShowMessage('Hooked key is : '+ hookedKey);
    end
  else
    // by setting Result to values other than 0 means we drop/erase the event
    Result := 1;
end;

// This exported routine is the one to call to disable the keyboard.
// It actually installs keyboard hook which handler drops any keyboard event
// it receives
function HookKeyboard: Boolean; stdcall;
begin
  if Hook = 0 then
    // install the hook
    Hook:= SetWindowsHookEx(WH_KEYBOARD, KBHookHandler, HINSTANCE, 0);
  Result := Hook <> 0;
end;


// This exported routine is the one to call to enable keyboard input.
// It actually just uninstall our keyboard hook, which mean now keyboard
// events will reach their intended destination (unless there is another
// similar kind of hook installed with another application).
procedure UnHookKeyboard;
begin
  if Hook <> 0 then
    UnhookWindowsHookEx(Hook);
  Hook := 0;
end;
exports
  HookKeyboard,
  UnHookKeyboard,
  hookedKey;

begin
  Hook := 0;
end.
