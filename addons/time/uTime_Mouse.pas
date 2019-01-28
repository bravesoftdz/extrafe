unit uTime_Mouse;

interface

uses
  System.Classes,
  System.SysUtils,
  FMX.Objects,
  FMX.Listbox,
  FMX.Types,
  FMX.StdCtrls,
  FMX.Colors,
  FMX.Effects;

type
  TTIME_ADDON_TIMER = class(TObject)
    procedure onTimer(Sender: TObject);
  end;

type
  TTIME_ADDON_IMAGE = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TTIME_ADDON_TEXT = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TTIME_ADDON_COMBOBOX = class(TObject)
    procedure OnChange(Sender: TObject);
  end;

type
  TTIME_ADDON_COLORCOMBOBOX = class(TObject)
    procedure OnChange(Sender: TObject);
  end;

type
  TTIME_ADDON_CHECKBOX = class(TObject)
    procedure OnMouseClick(Sender: TObject);
  end;

type
  TTIME_MOUSE_ACTIONS = record
    Timer: TTIME_ADDON_TIMER;
    Image: TTIME_ADDON_IMAGE;
    Text: TTIME_ADDON_TEXT;
    Combobox: TTIME_ADDON_COMBOBOX;
    ColorCombobox: TTIME_ADDON_COLORCOMBOBOX;
    Checkbox: TTIME_ADDON_CHECKBOX;
  end;

implementation

uses
  uLoad_AllTypes,
  uMain_SetAll,
  uTime_SetAll,
  uTime_AllTypes,
  uTime_Actions,
  uTime_Time_Actions,
  uTime_Time_SetAll;

{ TTIME_ADDON_IMAGE }

procedure TTIME_ADDON_IMAGE.OnMouseClick(Sender: TObject);
begin
  if vTime.Tab_Selected <> TImage(Sender).Tag then
  begin
    if TImage(Sender).Name = 'A_T_Tab_' + IntToStr(TImage(Sender).Tag) then
      uTime_Actions_ShowTab(TImage(Sender).Tag)
    else if TImage(Sender).Name = 'A_T_Tab_Icon_' + IntToStr(TImage(Sender).Tag) then
      uTime_Actions_ShowTab(TImage(Sender).Tag);
  end;
end;

procedure TTIME_ADDON_IMAGE.OnMouseEnter(Sender: TObject);
var
  vComp: TComponent;
begin
  if vTime.Tab_Selected <> TImage(Sender).Tag then
  begin
    if TImage(Sender).Name = 'A_T_Tab_' + IntToStr(TImage(Sender).Tag) then
      vTime.Tab[TImage(Sender).Tag].Back_Glow.Enabled := True
    else if TImage(Sender).Name = 'A_T_Tab_Icon_' + IntToStr(TImage(Sender).Tag) then
      vTime.Tab[TImage(Sender).Tag].Back_Glow.Enabled := True;
  end;
end;

procedure TTIME_ADDON_IMAGE.OnMouseLeave(Sender: TObject);
begin
  if vTime.Tab_Selected <> TImage(Sender).Tag then
  begin
    if TImage(Sender).Name = 'A_T_Tab_' + IntToStr(TImage(Sender).Tag) then
      vTime.Tab[TImage(Sender).Tag].Back_Glow.Enabled := False
    else if TImage(Sender).Name = 'A_T_Tab_Icon_' + IntToStr(TImage(Sender).Tag) then
      vTime.Tab[TImage(Sender).Tag].Back_Glow.Enabled := False;
  end;
end;

{ TTIME_ADDON_TEXT }

procedure TTIME_ADDON_TEXT.OnMouseClick(Sender: TObject);
begin
  if vTime.Tab_Selected <> TText(Sender).Tag then
  begin
    if TText(Sender).Name = 'A_T_Tab_Label_' + IntToStr(TText(Sender).Tag) then
      uTime_Actions_ShowTab(TImage(Sender).Tag);
  end;
end;

procedure TTIME_ADDON_TEXT.OnMouseEnter(Sender: TObject);
begin
  if vTime.Tab_Selected <> TText(Sender).Tag then
  begin
    if TText(Sender).Name = 'A_T_Tab_Label_' + IntToStr(TText(Sender).Tag) then
      vTime.Tab[TImage(Sender).Tag].Back_Glow.Enabled := True;
  end;
end;

procedure TTIME_ADDON_TEXT.OnMouseLeave(Sender: TObject);
begin
  if vTime.Tab_Selected <> TText(Sender).Tag then
  begin
    if TText(Sender).Name = 'A_T_Tab_Label_' + IntToStr(TText(Sender).Tag) then
      vTime.Tab[TImage(Sender).Tag].Back_Glow.Enabled := False;
  end;
end;

{ TTIME_ADDON_TIMER }

procedure TTIME_ADDON_TIMER.onTimer(Sender: TObject);
begin
  if TTimer(Sender).Name = 'A_T_P_Time_Timer' then
  begin
    if vTime.P_Time.Timer.Enabled then
    begin
      if addons.time.P_Time.Clock_Type = 'Analog' then
        uTime_Time_Actions_Update_Analog
      else if addons.time.P_Time.Clock_Type = 'Digital' then
        uTime_Time_Actions_Update_Digital
      else if addons.time.P_Time.Clock_Type = 'Both' then
      begin
        uTime_Time_Actions_Update_Analog;
        uTime_Time_Actions_Update_Digital;
      end;
    end;
  end;
end;

{ TTIME_ADDON_COMBOBOX }
procedure TTIME_ADDON_COMBOBOX.OnChange(Sender: TObject);
begin

end;

{ TTIME_ADDON_CHECKBOX }
procedure TTIME_ADDON_CHECKBOX.OnMouseClick(Sender: TObject);
begin

end;

{ TTIME_ADDON_COLORCOMBOBOX }
procedure TTIME_ADDON_COLORCOMBOBOX.OnChange(Sender: TObject);
begin

end;

initialization

addons.time.Input.mouse.Timer := TTIME_ADDON_TIMER.Create;
addons.time.Input.mouse.Image := TTIME_ADDON_IMAGE.Create;
addons.time.Input.mouse.Text := TTIME_ADDON_TEXT.Create;
addons.time.Input.mouse.Combobox := TTIME_ADDON_COMBOBOX.Create;
addons.time.Input.mouse.ColorCombobox := TTIME_ADDON_COLORCOMBOBOX.Create;
addons.time.Input.mouse.Checkbox := TTIME_ADDON_CHECKBOX.Create;

finalization

addons.time.Input.mouse.Timer.Free;
addons.time.Input.mouse.Image.Free;
addons.time.Input.mouse.Text.Free;
addons.time.Input.mouse.Combobox.Free;
addons.time.Input.mouse.ColorCombobox.Free;
addons.time.Input.mouse.Checkbox.Free;

end.
