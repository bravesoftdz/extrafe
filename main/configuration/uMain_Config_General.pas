unit uMain_Config_General;

interface

uses
  System.Classes,
  System.SysUtils,
  FMX.TabControl,
  FMX.Filter.Effects,
  FMX.Types,
  FMX.StdCtrls;

procedure Create;

implementation

uses
  uLoad_AllTypes,
  uMain_AllTypes,
  uMain_Config_General_Visual;

procedure Create;
const
  cItem_Names: array [0 .. 2] of string = ('Visual', 'Graphics', 'Sound');
var
  vi: Integer;
begin
  mainScene.Config.Main.R.General.Panel := TPanel.Create(mainScene.Config.Main.R.Panel[1]);
  mainScene.Config.Main.R.General.Panel.Name := 'Main_Config_General';
  mainScene.Config.Main.R.General.Panel.Parent := mainScene.Config.Main.R.Panel[1];
  mainScene.Config.Main.R.General.Panel.Align := TAlignLayout.Client;
  mainScene.Config.Main.R.General.Panel.Visible := True;

  mainScene.Config.Main.R.General.Blur := TGaussianBlurEffect.Create(mainScene.Config.Main.R.General.Panel);
  mainScene.Config.Main.R.General.Blur.Name := 'Main_Config_General_Blur';
  mainScene.Config.Main.R.General.Blur.Parent := mainScene.Config.Main.R.General.Panel;
  mainScene.Config.Main.R.General.Blur.BlurAmount := 0.5;
  mainScene.Config.Main.R.General.Blur.Enabled := False;

  mainScene.Config.Main.R.General.Contol := TTabControl.Create(mainScene.Config.Main.R.General.Panel);
  mainScene.Config.Main.R.General.Contol.Name := 'Main_Config_General_TabControl';
  mainScene.Config.Main.R.General.Contol.Parent := mainScene.Config.Main.R.General.Panel;
  mainScene.Config.Main.R.General.Contol.Align := TAlignLayout.Client;
  mainScene.Config.Main.R.General.Contol.Visible := True;

  for vi := 0 to 2 do
  begin
    mainScene.Config.Main.R.General.Tab_Item[vi] := TTabItem.Create(mainScene.Config.Main.R.General.Contol);
    mainScene.Config.Main.R.General.Tab_Item[vi].Name := 'Main_Config_General_Tab_Item_' + vi.ToString;
    mainScene.Config.Main.R.General.Tab_Item[vi].Parent := mainScene.Config.Main.R.General.Contol;
    mainScene.Config.Main.R.General.Tab_Item[vi].SetBounds(0, 0, mainScene.Config.Main.R.General.Contol.Width,
      mainScene.Config.Main.R.General.Contol.Height);
    mainScene.Config.Main.R.General.Tab_Item[vi].Text:= cItem_Names[vi];
      mainScene.Config.Main.R.General.Tab_Item[vi].Visible := True;
  end;

  uMain_Config_General_Visual.Create;
end;

end.