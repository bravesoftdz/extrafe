unit uMain_Config_General_Mouse;

interface

uses
  System.Classes,
  FMX.Objects,
  FMX.StdCtrls;

procedure Load;

implementation

uses
  uDB_AUser,
  uLoad_AllTypes,
  uMain_AllTypes;

procedure Load;
begin
  mainScene.Config.Main.R.General.Mouse.Image := TImage.Create(mainScene.Config.Main.R.General.Tab_Item[5]);
  mainScene.Config.Main.R.General.Mouse.Image.Name := 'Main_Config_General_Mouse_Image';
  mainScene.Config.Main.R.General.Mouse.Image.Parent := mainScene.Config.Main.R.General.Tab_Item[5];
  mainScene.Config.Main.R.General.Mouse.Image.Bitmap.LoadFromFile(ex_main.Paths.Config_Images + 'general\mouse.png');
  mainScene.Config.Main.R.General.Mouse.Image.SetBounds(mainScene.Config.Main.R.General.Contol.Width - 76, 6, 56, 56);
  mainScene.Config.Main.R.General.Mouse.Image.WrapMode := TImageWrapMode.Stretch;
  mainScene.Config.Main.R.General.Mouse.Image.Visible := True;

  mainScene.Config.Main.R.General.Mouse.Panel := TPanel.Create(mainScene.Config.Main.R.General.Tab_Item[5]);
  mainScene.Config.Main.R.General.Mouse.Panel.Name := 'Main_Config_General_Mouse_Panel';
  mainScene.Config.Main.R.General.Mouse.Panel.Parent := mainScene.Config.Main.R.General.Tab_Item[5];
  mainScene.Config.Main.R.General.Mouse.Panel.SetBounds(10, 66, mainScene.Config.Main.R.General.Contol.Width - 20,
    mainScene.Config.Main.R.General.Contol.Height - 100);
  mainScene.Config.Main.R.General.Mouse.Panel.Visible := True;
end;

end.
