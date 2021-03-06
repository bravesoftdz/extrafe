unit uPlay_Mouse;

interface

uses
  System.Classes,
  System.UiTypes,
  System.SysUtils,
  FMX.Objects,
  FMX.StdCtrls;

type
  TADDON_PLAY_INPUT_BUTTON = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TADDON_PLAY_INPUT_IMAGE = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TADDON_PLAY_INPUT_MAIN = record
    Button: TADDON_PLAY_INPUT_BUTTON;
    Image: TADDON_PLAY_INPUT_IMAGE;
  end;

type
  TADDON_PLAY_INPUT = record
    mouse: TADDON_PLAY_INPUT_MAIN;
  end;

implementation

uses
  uLoad_AllTypes,
  uPlay_AllTypes,
  uPlay_SetAll,
  uPlay_Actions;

{ TADDON_PLAY_INPUT_IMAGE }

procedure TADDON_PLAY_INPUT_IMAGE.OnMouseClick(Sender: TObject);
begin
  if TImage(Sender).Name = 'A_P_Icon_' + (TImage(Sender).Tag).ToString then
  begin
    if vPlay.Main_Blur.Enabled = False then
      uPlay_SetAll_CreateGameScene(TImage(Sender).Tag)
  end
  else if TImage(Sender).Name = 'A_P_Info_Img_' + (TImage(Sender).Tag).ToString then
  begin
    if vPlay.Info_Blur.Enabled = False then
      uPlay_Actions_Image_Full(TImage(Sender))
  end
  else if TImage(Sender).Name = 'AzPlay_Full_Preview_Exit' then
    uPlay_Actions_Image_Full_Close;
end;

procedure TADDON_PLAY_INPUT_IMAGE.OnMouseEnter(Sender: TObject);
begin
  if TImage(Sender).Name = 'A_P_Icon_' + (TImage(Sender).Tag).ToString then
  begin
    if vPlay.Main_Blur.Enabled = False then
      MouseOver_GameIcon(TImage(Sender).Tag);
  end
  else if TImage(Sender).Name = 'A_P_Info_Img_' + (TImage(Sender).Tag).ToString then
  begin
    if vPlay.Info_Blur.Enabled = False then
      uPlay_Actions_OnMouseOver_Image(TImage(Sender));
  end
  else if TImage(Sender).Name = 'AzPlay_Full_Preview_Exit' then
    vPlay.Full.Close_Glow.Enabled := True;
  TImage(Sender).Cursor := crHandPoint;
end;

procedure TADDON_PLAY_INPUT_IMAGE.OnMouseLeave(Sender: TObject);
begin
  if TImage(Sender).Name = 'A_P_Icon_' + (TImage(Sender).Tag).ToString then
  begin
    if vPlay.Main_Blur.Enabled = False then
      vPlay.Img_Img_Glow[TImage(Sender).Tag].Enabled := False;
  end
  else if TImage(Sender).Name = 'A_P_Info_Img_' + (TImage(Sender).Tag).ToString then
  begin
    if vPlay.Info_Blur.Enabled = False then
      uPlay_Actions_OnMouseLeave_Image(TImage(Sender))
  end
  else if TImage(Sender).Name = 'AzPlay_Full_Preview_Exit' then
    vPlay.Full.Close_Glow.Enabled := False;
end;

{ TADDON_PLAY_INPUT_BUTTON }

procedure TADDON_PLAY_INPUT_BUTTON.OnMouseClick(Sender: TObject);
begin
  if TButton(Sender).Name = 'AzHung' then
    uPlay_Actions_LoadGame('AzHung');
end;

procedure TADDON_PLAY_INPUT_BUTTON.OnMouseEnter(Sender: TObject);
begin

end;

procedure TADDON_PLAY_INPUT_BUTTON.OnMouseLeave(Sender: TObject);
begin

end;

initialization

addons.play.Input.mouse.Button := TADDON_PLAY_INPUT_BUTTON.Create;
addons.play.Input.mouse.Image := TADDON_PLAY_INPUT_IMAGE.Create;

finalization

addons.play.Input.mouse.Button.Free;
addons.play.Input.mouse.Image.Free;

end.
