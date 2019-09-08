unit uTime_Actions;

interface

uses
  System.Classes,
  System.SysUtils;

procedure Load;
procedure Free;

procedure ShowTab(vTab: Integer);

implementation

uses
  uLoad_AllTypes,
  uTime_Time_Actions,
  uTime_AllTypes,
  uTime_SetAll,
  uTime_Time_SetAll,
  uTime_Sounds;

procedure Load;
begin
  uTime_Sounds_Load;
  uTime_SetAll_Set;
end;

procedure ShowTab(vTab: Integer);
var
  vi: Integer;
begin
  for vi := 0 to 4 do
  begin
    vTime.Tab[vi].Back_Glow.Enabled := False;
    if Assigned(vTime.P_Time.Back) then
      uTime_Time_SetAll_Free;
  end;

  case vTab of
    0:
      uTime_Time_SetAll_Set;
  end;
  vTime.Tab[vTab].Back_Glow.Enabled := True;
  vTime.Tab_Selected := vTab;
end;

procedure Free;
var
  vi: Integer;
begin
  for vi := 0 to 4 do
    FreeAndNil(vTime.Tab[vi]);
  uTime_Time_SetAll_Free;
  FreeAndNil(vTime.Time);
end;

/// /////////////////////////////////////////////////////////////////////////////

end.
