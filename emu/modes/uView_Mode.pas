unit uView_Mode;

interface

uses
  System.Classes,
  FMX.StdCtrls,
  FMX.Objects,
  FireDAC.Comp.Client;

procedure Scene(vViewMode: String; vUser_Num: Integer; vQuery: TFDQuery; vMain: TImage; vPath, vImages, vSounds: String);
procedure Start(vViewMode: String; vSelected, vGames_Count: Integer; vList_Games, vList_Roms, vList_Path: TStringlist);

procedure Set_Config_Panels(vViewMode: String; vMain, vLeft, vRight: TPanel);

implementation

uses
  uView_Mode_Default;

{ Create scene by selected viewmode }
procedure Scene(vViewMode: String; vUser_Num: Integer; vQuery: TFDQuery; vMain: TImage; vPath, vImages, vSounds: String);
begin
  if vViewMode = 'default' then
    uView_Mode_Default.Create_Scene(vUser_Num, vQuery, vMain, vPath, vImages, vSounds);
end;

{ Start selected viewmode }
procedure Start(vViewMode: String; vSelected, vGames_Count: Integer; vList_Games, vList_Roms, vList_Path: TStringlist);
begin
  if vViewMode = 'default' then
    uView_Mode_Default.Start_View_Mode(vSelected, vGames_Count, vList_Games, vList_Roms, vList_Path);
end;

{ Set the panels depends of viewmode }
procedure Set_Config_Panels(vViewMode: String; vMain, vLeft, vRight: TPanel);
begin
  if vViewMode = 'default' then
    uView_Mode_Default.Set_Panels_Configurtaion(vMain, vLeft, vRight);
end;

end.
