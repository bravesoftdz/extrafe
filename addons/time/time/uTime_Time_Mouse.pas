unit uTime_Time_Mouse;

interface

uses
  System.Classes,
  System.SysUtils,
  FMX.TabControl,
  FMX.Controls,
  FMX.Listbox,
  FMX.StdCtrls,
  FMX.Colors,
  FMX.Objects;

type
  TTIME_ADDON_TIME_IMAGE = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TTIME_ADDON_TIME_TABITEM = class(TObject)
    procedure OnMouseClick(Sender: TObject);
  end;

type
  TTIME_ADDON_TIME_COMBOBOX = class(TObject)
    procedure OnChange(Sender: TObject);
  end;

type
  TTIME_ADDON_TIME_CHECKBOX = class(TObject)
    procedure OnMouseClick(Sender: TObject);
  end;

type
  TTIME_ADDON_TIME_COLORCOMBOBOX = class(TObject)
    procedure OnChange(Sender: TObject);
  end;

type
  TTIME_TIME_MOUSE_ACTIONS = record
    Image: TTIME_ADDON_TIME_IMAGE;
    TabItem: TTIME_ADDON_TIME_TABITEM;
    Combobox: TTIME_ADDON_TIME_COMBOBOX;
    Checkbox: TTIME_ADDON_TIME_CHECKBOX;
    ColorCombobox: TTIME_ADDON_TIME_COLORCOMBOBOX end;

implementation

uses
  uLoad_AllTypes,
  uTime_AllTypes,
  uTime_Time_SetAll,
  uTime_Time_Actions;

{ TTIME_ADDON_TIME_IMAGE }

procedure TTIME_ADDON_TIME_IMAGE.OnMouseClick(Sender: TObject);
begin
  if TImage(Sender).Name = 'A_T_P_Time_Settings' then
  begin
    if not Assigned(vTime.P_Time.Config.Panel) then
    begin
      uTime_Time_SetAll_Set_Config;
      uTime_Time_SetAll_Set_General;
    end
    else
      uTime_Time_SetAll_Config_Free;
  end;
end;

procedure TTIME_ADDON_TIME_IMAGE.OnMouseEnter(Sender: TObject);
begin

end;

procedure TTIME_ADDON_TIME_IMAGE.OnMouseLeave(Sender: TObject);
begin

end;

{ TTIME_ADDON_TIME_TABITEM }

procedure TTIME_ADDON_TIME_TABITEM.OnMouseClick(Sender: TObject);
begin
  if TTabItem(Sender).Name = 'A_T_P_Time_TabItem_0' then
  begin
    if not Assigned(vTime.P_Time.Config.General.Panel) then
    begin
      if Assigned(vTime.P_Time.Config.Analog.Panel) then
        FreeAndNil(vTime.P_Time.Config.Analog.Panel)
      else if Assigned(vTime.P_Time.Config.Digital.Panel) then
        FreeAndNil(vTime.P_Time.Config.Digital.Panel);
      uTime_Time_SetAll_Set_General;
    end;
  end
  else if TTabItem(Sender).Name = 'A_T_P_Time_TabItem_1' then
  begin
    if not Assigned(vTime.P_Time.Config.Analog.Panel) then
    begin
      if Assigned(vTime.P_Time.Config.General.Panel) then
        FreeAndNil(vTime.P_Time.Config.General.Panel)
      else if Assigned(vTime.P_Time.Config.Digital.Panel) then
        FreeAndNil(vTime.P_Time.Config.Digital.Panel);
      uTime_Time_SetAll_Set_Analog;
    end;
  end
  else if TTabItem(Sender).Name = 'A_T_P_Time_TabItem_2' then
  begin
    if not Assigned(vTime.P_Time.Config.Digital.Panel) then
    begin
      if Assigned(vTime.P_Time.Config.General.Panel) then
        FreeAndNil(vTime.P_Time.Config.General.Panel)
      else if Assigned(vTime.P_Time.Config.Analog.Panel) then
        FreeAndNil(vTime.P_Time.Config.Analog.Panel);
      uTime_Time_SetAll_Set_Digital;
    end;
  end

end;

{ TTIME_ADDON_TIME_COMBOBOX }

procedure TTIME_ADDON_TIME_COMBOBOX.OnChange(Sender: TObject);
begin
  if TComboBox(Sender).Name = 'A_T_P_Time_General_Type' then
    uTime_Time_Actions_ShowType(TComboBox(Sender).Items.Strings[TComboBox(Sender).ItemIndex])
  else if TComboBox(Sender).Name = 'A_T_P_Time_General_Both_Type' then
    uTime_Time_Actions_ShowBothType(TComboBox(Sender).Items.Strings[TComboBox(Sender).ItemIndex])
  else if TComboListBox(Sender).Name = 'A_T_P_Time_Digital_Font' then
    uTime_Time_Actions_Digital_SetFont(TComboBox(Sender).Items.Strings[TComboBox(Sender).ItemIndex]);
end;

{ TTIME_ADDON_TIME_CHECKBOX }

procedure TTIME_ADDON_TIME_CHECKBOX.OnMouseClick(Sender: TObject);
begin
  if TCheckBox(Sender).Name = 'A_T_P_Time_Analog_Option_ShowSecondsIndicator' then
    uTime_Time_Actions_Analog_ShowSecondsIndicator
  else if TCheckBox(Sender).Name = 'A_T_P_Time_Analog_Option_ShowQuarters' then
    uTIme_Time_Actions_Analog_ShowQuarters
  else if TCheckBox(Sender).Name = 'A_T_P_Time_Analog_Option_ShowHours' then
    uTime_Time_Actions_Analog_ShowHours;
end;

{ TTIME_ADDON_TIME_COLORCOMBOBOX }

procedure TTIME_ADDON_TIME_COLORCOMBOBOX.OnChange(Sender: TObject);
begin
  if TColorComboBox(Sender).Name = 'A_T_P_Time_Digital_Color' then
    uTime_Time_Actions_Digital_SetFontColor(TColorComboBox(Sender).Color)
  else if TColorComboBox(Sender).Name = 'A_T_P_Time_Digital_Color_Back' then
    uTime_Time_Actions_Digital_SetBackColor(TColorComboBox(Sender).Color)
  else if TColorComboBox(Sender).Name = 'A_T_P_Time_Digital_Color_Stroke_Back' then
    uTime_Time_Actions_Digital_SetBackStrokeColor(TColorComboBox(Sender).Color)
end;

initialization

addons.time.Input.mouse_time.Image := TTIME_ADDON_TIME_IMAGE.Create;
addons.time.Input.mouse_time.TabItem := TTIME_ADDON_TIME_TABITEM.Create;
addons.time.Input.mouse_time.Combobox := TTIME_ADDON_TIME_COMBOBOX.Create;
addons.time.Input.mouse_time.Checkbox := TTIME_ADDON_TIME_CHECKBOX.Create;
addons.time.Input.mouse_time.ColorCombobox := TTIME_ADDON_TIME_COLORCOMBOBOX.Create;

finalization

addons.time.Input.mouse_time.Image.Free;
addons.time.Input.mouse_time.TabItem.Free;
addons.time.Input.mouse_time.Combobox.Free;
addons.time.Input.mouse_time.Checkbox.Free;
addons.time.Input.mouse_time.ColorCombobox.Free;

end.
