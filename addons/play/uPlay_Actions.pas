unit uPlay_Actions;

interface

uses
  System.Classes,
  System.SysUtils;

procedure uPlay_Actions_ReturnToMain(vIconsNum: Integer);
procedure uPlay_Actions_Free;

procedure uPlay_Actions_LoadGame(vGame: String);

implementation

uses
  uLoad_AllTypes,
  uMain_AllTypes,
  uMain_Actions,
  uPlay_AllTypes,
  uPlay_SetAll;

procedure uPlay_Actions_ReturnToMain(vIconsNum: Integer);
begin
  emulation.Selection_Ani.StartValue := extrafe.res.Height;
  emulation.Selection_Ani.StopValue := ex_main.Settings.MainSelection_Pos.Y - 130;
  mainScene.Footer.Back_Ani.StartValue := extrafe.res.Height;
  mainScene.Footer.Back_Ani.StopValue := ex_main.Settings.Footer_Pos.Y;
  emulation.Selection_Ani.Enabled := True;
  vPlay.Main_Ani.Start;
  mainScene.Footer.Back_Ani.Start;
  uMain_Actions_All_Icons_Active(vIconsNum);
  extrafe.prog.State := 'main';
end;

procedure uPlay_Actions_Free;
begin
  if Assigned(vPlay.Info) then
    FreeAndNil(vPlay.Info);
  FreeAndNil(vPlay.Main);
end;

procedure uPlay_Actions_LoadGame(vGame: String);
begin
  vPlay.Img_Box_Ani.StartValue := vPlay.Img_Box.Position.X;
  vPlay.Img_Box_Ani.StopValue := -(vPlay.Img_Box.Width + 10);
  vPlay.Info_Ani.StartValue:= vPlay.Info.Position.X;
  vPlay.Info_Ani.StopValue:= extrafe.res.Width+ 10;
  vPlay.Img_Box_Ani.Start;
  vPlay.Info_Ani.Start;
  addons.play.Actions.Game:= vGame;
end;

end.
