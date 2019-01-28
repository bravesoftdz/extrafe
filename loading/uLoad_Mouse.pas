unit uLoad_Mouse;

interface

uses
  System.Classes,
  System.SysUtils,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Forms,
  FMX.Edit;

type
  TLOADING_BUTTON = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TLOADING_IMAGE = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TLOADING_EDIT = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
    procedure OnTyping(Sender: TObject);
  end;

type
  TLOADING_TEXT = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TLOADING_INPUT_MOUSE = record
    Image: TLOADING_IMAGE;
    Button: TLOADING_BUTTON;
    Edit: TLOADING_EDIT;
    Text: TLOADING_TEXT;
  end;

implementation

uses
  uSnippet_Text,
  uKeyboard,
  uLoad_AllTypes,
  uLoad_SetAll,
  uLoad_Actions;

{ TLOADING_BUTTON }

procedure TLOADING_BUTTON.OnMouseClick(Sender: TObject);
begin
  if TButton(Sender).Name = 'Loading_Login_Login' then
    uLoad_Actions_Login
  else if TButton(Sender).Name = 'Loading_Login_Exit' then
    Application.Terminate
  else if TButton(Sender).Name= 'Loading_Reg_Cancel' then
    uLoad_Actions_Return_Login('Register')
  else if TButton(Sender).Name = 'Loading_FPass_Send' then
    uLoad_Actions_SendEmail
  else if TButton(Sender).Name = 'Loading_FPass_Cancel' then
    uLoad_Actions_Return_Login('FPass')
  else if TButton(Sender).Name = 'Loading_Terms_Close' then
    begin
      FreeAndNil(ex_load.Terms.Panel);
      ex_load.Reg.Main.Terms_Check.Enabled:= True;
    end;
end;

procedure TLOADING_BUTTON.OnMouseEnter(Sender: TObject);
begin

end;

procedure TLOADING_BUTTON.OnMouseLeave(Sender: TObject);
begin

end;

{ TLOADING_IMAGE }

procedure TLOADING_IMAGE.OnMouseClick(Sender: TObject);
begin

end;

procedure TLOADING_IMAGE.OnMouseEnter(Sender: TObject);
begin

end;

procedure TLOADING_IMAGE.OnMouseLeave(Sender: TObject);
begin

end;

{ TLOADING_EDIT }

procedure TLOADING_EDIT.OnMouseClick(Sender: TObject);
begin

end;

procedure TLOADING_EDIT.OnMouseEnter(Sender: TObject);
begin

end;

procedure TLOADING_EDIT.OnMouseLeave(Sender: TObject);
begin

end;

procedure TLOADING_EDIT.OnTyping(Sender: TObject);
begin
  if TEdit(Sender).Name = 'Loading_Login_User_V' then
  begin
    if ex_load.Login.Warning.Visible then
      ex_load.Login.Warning.Visible := False;
  end
  else if TEdit(Sender).Name = 'Loading_Login_Pass_V' then
  begin
    if ex_load.Login.Warning.Visible then
    begin
      ex_load.Login.Warning.Visible := False;
      ex_load.Login.Forget_Pass.Visible := False;
    end;
  end;
end;

{ TLOADING_TEXT }

procedure TLOADING_TEXT.OnMouseClick(Sender: TObject);
begin
  if TText(Sender).Name = 'Loading_Login_Register' then
    uLoad_SetAll_Register
  else if TText(Sender).Name = 'Loading_Login_Forget_Pass' then
    uLoad_SetAll_Forget_Password
  else if TText(Sender).Name = 'Loading_Register_Terms' then
    uLoad_SetAll_Terms;
end;

procedure TLOADING_TEXT.OnMouseEnter(Sender: TObject);
begin
  if TText(Sender).Name = 'Loading_Login_Register' then
    uSnippet_Text_HyperLink_OnMouseEnter(TText(Sender))
  else if TText(Sender).Name = 'Loading_Login_Forget_Pass' then
    uSnippet_Text_HyperLink_OnMouseEnter(TText(Sender))
  else if TText(Sender).Name = 'Loading_Register_Terms' then
    uSnippet_Text_HyperLink_OnMouseEnter(TText(Sender))
end;

procedure TLOADING_TEXT.OnMouseLeave(Sender: TObject);
begin
  if TText(Sender).Name = 'Loading_Login_Register' then
    uSnippet_Text_HyperLink_OnMouseLeave(TText(Sender))
  else if TText(Sender).Name = 'Loading_Login_Forget_Pass' then
    uSnippet_Text_HyperLink_OnMouseLeave(TText(Sender))
  else if TText(Sender).Name = 'Loading_Register_Terms' then
    uSnippet_Text_HyperLink_OnMouseLeave(TText(Sender))
end;

initialization

ex_load.Input.mouse.Button := TLOADING_BUTTON.Create;
ex_load.Input.mouse.Image := TLOADING_IMAGE.Create;
ex_load.Input.mouse.Edit := TLOADING_EDIT.Create;
ex_load.Input.mouse.Text := TLOADING_TEXT.Create;

finalization

ex_load.Input.mouse.Button.Free;
ex_load.Input.mouse.Image.Free;
ex_load.Input.mouse.Edit.Free;
ex_load.Input.mouse.Text.Free;

end.
