unit uVirtual_Keyboard;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UiTypes,
  System.UiConsts,
  FMX.Forms,
  FMX.Objects,
  FMX.Effects,
  FMX.Types,
  FMX.Edit,
  FMX.StdCtrls,
  FMX.Layouts;

type
  TVIRTUAL_KEYBOARD_IMAGE = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TVIRTUAL_KEYBOARD_TEXT = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TVIRTUAL_KEYBOARD_RECTANGLE = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TVIRTUAL_KEYBOARD = class(TLayout)
  private
    FCapsLock: Boolean;

    procedure uVK_Create(vType, vTitle: String);

  var
    vLayout: TLayout;
    vBackground: TImage;

    procedure uVirtual_Keyboard_Create(Sender: TObject; vType, vTitle: String);

  public
    Constructor Create(AOwner: TComponent); Override;

    procedure SetCapsLock(const value: Boolean);
    property CapsLock: Boolean read FCapsLock write SetCapsLock;

    Destructor Destroy; Override;
  end;

const
  cVirtual_Keyboard_Keys: array [0 .. 50] of string = ('English', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    '0', 'Back', 'Caps Lock', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', 'Enter', 'Shift', 'a', 's',
    'd', 'f', 'g', 'h', 'j', 'k', 'l', ':', '', 'Symbols', 'z', 'x', 'c', 'v', 'b', 'n', 'm', '.', '/', '@',
    'Space', '<', '>', 'Exit');
  cVirtual_Keyboard_Keys_Capital: array [0 .. 50] of string = ('', '', '', '', '', '', '', '', '', '', '', '',
    '', 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '', '', 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L',
    '', '', '', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '', '', '', '', '', '', '');
  cVirtual_Keyboard_Keys_Symbols: array [0 .. 50] of string = ('', '', '!', '@', '#', '$', '%', '^', '&', '`',
    '', '', '', '', '(', ')', '[', ']', '{', '}', '<', '>', '', '', '', '', '*', '/', '+', '-', '_', '+', '\',
    '?', '', '', '', '', '''', '"', ',', '.', '|', '~', ';', ':', '', '', '', '', '');
  cVirtual_Keyboard_Keys_Shift: array [0 .. 50] of string = ('', '!', '@', '#', '$', '%', '^', '&', '*', '(',
    ')', '', '', 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '', '', 'A', 'S', 'D', 'F', 'G', 'H', 'J',
    'K', 'L', '', '', '', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '', '', '', '', '', '', '');

procedure uVirtual_Keyboard_Create_Alt(Sender: TObject; vType, vTitle: String);

var
  // vVK_Back: TImage;
  vVK_Back: TLayout;

  VK_Symbols: Boolean;
  VK_Capitals: Boolean;
  VK_Shifts: Boolean;

  VK_Drop_Num: Integer;
  VK_Drop_Num_Current: Integer;

  vVirtual_Keyboard_Active: Boolean;
  vVirtual_Keyboard_Type: String;
  // The background
  VK_Background: TRectangle;
  // The Title
  VK_Title_Background: TRectangle;
  VK_Title_Icon: TImage;
  VK_Title: TText;
  // The edit action type
  VK_Edit_Background: TRectangle;
  VK_Edit: TEdit;
  // The Drop down menu
  VK_Drop_Background: TRectangle;
  VK_Drop_Box: TVertScrollBox;
  VK_Drop_Line_Back: array [0 .. 21] of TRectangle;
  VK_Drop_Icon: array [0 .. 21] of TImage;
  VK_Drop_Text: array [0 .. 21] of TText;
  // Keys
  VK_Key: array [0 .. 60] of TRectangle;
  VK_Key_Symbol: array [0 .. 60] of TText;

  vVK_Image: TVIRTUAL_KEYBOARD_IMAGE;
  vVK_Text: TVIRTUAL_KEYBOARD_TEXT;
  vVK_Rectangle: TVIRTUAL_KEYBOARD_RECTANGLE;

procedure uVirtual_Keyboard_Free;

procedure uVirtual_Keyboard_Capital(vActive: Boolean);
procedure uVirtual_Keyboard_Symbols(vActive: Boolean);
procedure uVirtual_Keyboard_Shift(vActive: Boolean);

procedure uVirtual_Keyboard_Add_DropLine(vLine: Integer; vString: String; vImagePath: String);

procedure uVirtual_Keyboard_SetKey(vKey: String);

procedure uVirtual_Keyboard_DoAction(vKey: String);

implementation

uses
  emu,
  uLoad,
  uLoad_AllTypes,
  uEmu_Actions;

procedure uVirtual_Keyboard_Create_Alt(Sender: TObject; vType, vTitle: String);
var
  vi, vfi: Integer;
begin
  vVK_Back := TLayout(Sender);

  vVK_Back.Align := TAlignLayout.Client;

  VK_Background := TRectangle.Create(vVK_Back);
  VK_Background.Name := 'Virtual_Keyboard';
  VK_Background.Parent := vVK_Back;
  VK_Background.Width := 800;
  VK_Background.Height := 500;
  VK_Background.Position.X := extrafe.res.Half_Width - 400;
  VK_Background.Position.Y := extrafe.res.Half_Height - 250;
  VK_Background.XRadius := 8;
  VK_Background.YRadius := 8;
  VK_Background.Stroke.Thickness := 8;
  VK_Background.Stroke.Color := TAlphaColorRec.Deepskyblue;
  VK_Background.Fill.Color := StringToAlphaColor('#FF01182E');
  VK_Background.Visible := True;

  VK_Title_Background := TRectangle.Create(VK_Background);
  VK_Title_Background.Name := 'Virtual_Keyboard_BackTitle';
  VK_Title_Background.Parent := VK_Background;
  VK_Title_Background.Width := VK_Background.Width - 16;
  VK_Title_Background.Height := 30;
  VK_Title_Background.Position.X := 8;
  VK_Title_Background.Position.Y := 8;
  VK_Title_Background.XRadius := 4;
  VK_Title_Background.YRadius := 4;
  VK_Title_Background.Stroke.Thickness := 4;
  VK_Title_Background.Stroke.Color := TAlphaColorRec.Black;
  VK_Title_Background.Fill.Color := StringToAlphaColor('#FF010709');
  VK_Title_Background.Corners := VK_Title_Background.Corners - [TCorner.BottomLeft, TCorner.BottomRight];
  VK_Title_Background.Visible := True;

  VK_Title_Icon := TImage.Create(VK_Title_Background);
  VK_Title_Icon.Name := 'Virtual_Keyboard_IconTitle';
  VK_Title_Icon.Parent := VK_Title_Background;
  VK_Title_Icon.Width := 28;
  VK_Title_Icon.Height := 28;
  VK_Title_Icon.Position.X := 1;
  VK_Title_Icon.Position.Y := 1;
  VK_Title_Icon.WrapMode := TImageWrapMode.Fit;
  vVirtual_Keyboard_Type := vType;
  if vVirtual_Keyboard_Type = 'Search' then
    VK_Title_Icon.Bitmap.LoadFromFile(ex_main.Paths.Images + 'vk_search.png')
  else if vVirtual_Keyboard_Type = 'Type' then
    VK_Title_Icon.Bitmap.LoadFromFile(ex_main.Paths.Images + 'vk_type.png');
  VK_Title_Icon.Visible := True;

  VK_Title := TText.Create(VK_Title_Background);
  VK_Title.Name := 'Virtual_Keyboard_Title';
  VK_Title.Parent := VK_Title_Background;
  VK_Title.Color := TAlphaColorRec.White;
  VK_Title.Font.Family := 'Tahoma';
  VK_Title.Font.Size := 16;
  VK_Title.Width := VK_Title_Background.Width - 30;
  VK_Title.Height := 28;
  VK_Title.Position.X := 34;
  VK_Title.Position.Y := 1;
  VK_Title.Font.Style := VK_Title.Font.Style + [TFontStyle.fsBold];
  VK_Title.Text := vTitle;
  VK_Title.HorzTextAlign := TTextAlign.Leading;
  VK_Title.VertTextAlign := TTextAlign.Center;
  VK_Title.Visible := True;

  VK_Edit_Background := TRectangle.Create(VK_Background);
  VK_Edit_Background.Name := 'Virtual_Keyboard_BackEdit';
  VK_Edit_Background.Parent := VK_Background;
  VK_Edit_Background.Width := VK_Background.Width - 16;
  VK_Edit_Background.Height := 30;
  VK_Edit_Background.Position.X := 8;
  VK_Edit_Background.Position.Y := 58;
  VK_Edit_Background.XRadius := 4;
  VK_Edit_Background.YRadius := 4;
  VK_Edit_Background.Stroke.Thickness := 4;
  VK_Edit_Background.Stroke.Color := TAlphaColorRec.Black;
  VK_Edit_Background.Fill.Color := StringToAlphaColor('#FF010709');
  VK_Edit_Background.Corners := VK_Edit_Background.Corners - [TCorner.BottomLeft, TCorner.BottomRight];
  VK_Edit_Background.Visible := True;

  VK_Edit := TEdit.Create(VK_Edit_Background);
  VK_Edit.Name := 'Virtual_Keyboard_Edit';
  VK_Edit.Parent := VK_Edit_Background;
  VK_Edit.Width := VK_Edit_Background.Width - 20;
  VK_Edit.Height := 22;
  VK_Edit.Position.X := 10;
  VK_Edit.Position.Y := 4;
  VK_Edit.Text := '';
  VK_Edit.ReadOnly := True;
  VK_Edit.Caret.Color := TAlphaColorRec.Deepskyblue;
  VK_Edit.TextSettings.HorzAlign := TTextAlign.Center;
  VK_Edit.Visible := True;

  VK_Drop_Background := TRectangle.Create(VK_Background);
  VK_Drop_Background.Name := 'Virtual_Keyboard_Drop_Background';
  VK_Drop_Background.Parent := VK_Background;
  VK_Drop_Background.Width := VK_Background.Width - 16;
  VK_Drop_Background.Height := 0;
  VK_Drop_Background.Position.X := 8;
  VK_Drop_Background.Position.Y := 88;
  VK_Drop_Background.XRadius := 4;
  VK_Drop_Background.YRadius := 4;
  VK_Drop_Background.Stroke.Thickness := 4;
  VK_Drop_Background.Stroke.Color := TAlphaColorRec.Black;
  VK_Drop_Background.Fill.Color := StringToAlphaColor('#FF010709');
  VK_Drop_Background.Corners := VK_Drop_Background.Corners - [TCorner.TopLeft, TCorner.TopRight];
  VK_Drop_Background.Visible := True;

  VK_Drop_Box := TVertScrollBox.Create(VK_Drop_Background);
  VK_Drop_Box.Name := 'Virtual_Keyboard_Drop_Box';
  VK_Drop_Box.Parent := VK_Drop_Background;
  VK_Drop_Box.Align := TAlignLayout.Client;
  VK_Drop_Box.Visible := True;

  vfi := 0;
  for vi := 0 to 50 do
  begin
    VK_Key[vi] := TRectangle.Create(VK_Background);
    VK_Key[vi].Name := 'Virtual_Keyboard_Key_' + IntToStr(vi);
    VK_Key[vi].Parent := VK_Background;
    if vi = 11 then
    begin
      VK_Key[vi].Width := 80;
      VK_Key[vi].Height := 50;
      VK_Key[vi].Position.X := (50 * 10) + 170;
      VK_Key[vi].Position.Y := 220;
    end
    else if vi = 23 then
    begin
      VK_Key[vi].Width := 80;
      VK_Key[vi].Height := 100;
      VK_Key[vi].Position.X := (50 * 10) + 170;
      VK_Key[vi].Position.Y := 270;
    end
    else if vi = 47 then
    begin
      VK_Key[vi].Width := 300;
      VK_Key[vi].Height := 50;
      VK_Key[vi].Position.X := (50 * 1) + 170;
      VK_Key[vi].Position.Y := 420;
    end
    else if vi in [48, 49, 50] then
    begin
      VK_Key[vi].Width := 50;
      VK_Key[vi].Height := 50;
      if vi = 48 then
        VK_Key[vi].Position.X := (50 * 8) + 170
      else if vi = 49 then
        VK_Key[vi].Position.X := (50 * 9) + 170
      else
        VK_Key[vi].Position.X := (50 * 11) + 150;
      VK_Key[vi].Position.Y := 420;
    end
    else if vi in [0, 12, 24, 36] then
    begin
      VK_Key[vi].Width := 120;
      VK_Key[vi].Height := 50;
      VK_Key[vi].Position.X := 50;
      if vi > 28 then
        VK_Key[vi].Position.Y := 370
      else if vi > 18 then
        VK_Key[vi].Position.Y := 320
      else if vi > 10 then
        VK_Key[vi].Position.Y := 270
      else
        VK_Key[vi].Position.Y := 220;
    end
    else
    begin
      VK_Key[vi].Width := 50;
      VK_Key[vi].Height := 50;
      if (vi = 13) or (vi = 25) or (vi = 37) then
        vfi := 0;
      VK_Key[vi].Position.X := (50 * vfi) + 170;
      if vi > 36 then
        VK_Key[vi].Position.Y := 370
      else if vi > 23 then
        VK_Key[vi].Position.Y := 320
      else if vi > 11 then
        VK_Key[vi].Position.Y := 270
      else
        VK_Key[vi].Position.Y := 220;
      inc(vfi, 1);
    end;
    VK_Key[vi].Stroke.Thickness := 4;
    VK_Key[vi].Stroke.Color := TAlphaColorRec.Black;
    VK_Key[vi].Fill.Color := StringToAlphaColor('#FF010709');
    VK_Key[vi].OnClick := vVK_Image.OnMouseClick;
    VK_Key[vi].OnMouseEnter := vVK_Image.OnMouseEnter;
    VK_Key[vi].OnMouseLeave := vVK_Image.OnMouseLeave;
    VK_Key[vi].Tag := vi;
    if vi <> 35 then
      VK_Key[vi].Visible := True
    else
      VK_Key[vi].Visible := False;

    VK_Key_Symbol[vi] := TText.Create(VK_Key[vi]);
    VK_Key_Symbol[vi].Name := 'Virtual_Keyboard_Key_Name_' + IntToStr(vi);
    VK_Key_Symbol[vi].Parent := VK_Key[vi];
    VK_Key_Symbol[vi].Align := TAlignLayout.Client;
    VK_Key_Symbol[vi].Color := TAlphaColorRec.White;
    VK_Key_Symbol[vi].Font.Family := 'Tahoma';
    VK_Key_Symbol[vi].Font.Size := 20;
    VK_Key_Symbol[vi].Font.Style := VK_Key_Symbol[vi].Font.Style + [TFontStyle.fsBold];
    VK_Key_Symbol[vi].Text := cVirtual_Keyboard_Keys[vi];
    VK_Key_Symbol[vi].HorzTextAlign := TTextAlign.Center;
    VK_Key_Symbol[vi].VertTextAlign := TTextAlign.Center;
    VK_Key_Symbol[vi].OnClick := vVK_Text.OnMouseClick;
    VK_Key_Symbol[vi].OnMouseEnter := vVK_Text.OnMouseEnter;
    VK_Key_Symbol[vi].OnMouseLeave := vVK_Text.OnMouseLeave;
    VK_Key_Symbol[vi].Tag := vi;
    VK_Key_Symbol[vi].Visible := True;
  end;

  vVirtual_Keyboard_Active := True;
  VK_Symbols := False;
  VK_Capitals := False;
  VK_Shifts := False;

  VK_Drop_Num := -1;
  VK_Drop_Num_Current := -1;

  VK_Edit.SetFocus;
end;

procedure uVirtual_Keyboard_Free;
var
  vi: Integer;
begin
  vVirtual_Keyboard_Active := False;
  VK_Drop_Num := -1;
  for vi := 20 downto 0 do
    if Assigned(VK_Drop_Line_Back[vi]) then
      FreeAndNil(VK_Drop_Line_Back[vi]);
  FreeAndNil(VK_Background);
  FreeAndNil(vVK_Back);
end;

procedure uVirtual_Keyboard_Capital(vActive: Boolean);
var
  vi: Integer;
begin
  if vActive then
  begin
    for vi := 0 to 50 do
    begin
      if vi in [0 .. 12, 23, 24, 34, 35, 36, 44 .. 50] then
      else
        VK_Key_Symbol[vi].Text := cVirtual_Keyboard_Keys_Capital[vi];
      VK_Key_Symbol[12].TextSettings.FontColor := TAlphaColorRec.Red;
    end;
  end
  else
  begin
    for vi := 0 to 50 do
      VK_Key_Symbol[vi].Text := cVirtual_Keyboard_Keys[vi];
    VK_Key_Symbol[12].TextSettings.FontColor := TAlphaColorRec.White;
  end;
end;

procedure uVirtual_Keyboard_Symbols(vActive: Boolean);
var
  vi: Integer;
begin
  if vActive then
  begin
    for vi := 0 to 50 do
      if vi in [0, 11, 12, 23, 24, 35, 36, 47 .. 50] then
      else
        VK_Key_Symbol[vi].Text := cVirtual_Keyboard_Keys_Symbols[vi];
    VK_Key_Symbol[36].TextSettings.FontColor := TAlphaColorRec.Red;
    VK_Key_Symbol[12].TextSettings.FontColor := TAlphaColorRec.Gray;
    VK_Key_Symbol[24].TextSettings.FontColor := TAlphaColorRec.Gray;
  end
  else
  begin
    if VK_Capitals then
    begin
      for vi := 0 to 50 do
        VK_Key_Symbol[vi].Text := cVirtual_Keyboard_Keys[vi];
      uVirtual_Keyboard_Capital(VK_Capitals);
      VK_Key_Symbol[24].TextSettings.FontColor := TAlphaColorRec.White;
      VK_Key_Symbol[36].TextSettings.FontColor := TAlphaColorRec.White;
    end
    else
    begin
      for vi := 0 to 50 do
        VK_Key_Symbol[vi].Text := cVirtual_Keyboard_Keys[vi];
      VK_Key_Symbol[12].TextSettings.FontColor := TAlphaColorRec.White;
      VK_Key_Symbol[24].TextSettings.FontColor := TAlphaColorRec.White;
      VK_Key_Symbol[36].TextSettings.FontColor := TAlphaColorRec.White;
    end;
  end;
end;

procedure uVirtual_Keyboard_Shift(vActive: Boolean);
var
  vi: Integer;
begin
  if vActive then
  begin
    for vi := 0 to 50 do
      if vi in [0, 11, 12, 23, 24, 34, 35, 36, 44 .. 50] then
      else
        VK_Key_Symbol[vi].Text := cVirtual_Keyboard_Keys_Shift[vi];
    VK_Key_Symbol[12].TextSettings.FontColor := TAlphaColorRec.Gray;
    VK_Key_Symbol[24].TextSettings.FontColor := TAlphaColorRec.Red;
    VK_Key_Symbol[36].TextSettings.FontColor := TAlphaColorRec.Gray;
  end
  else
  begin
    for vi := 0 to 50 do
      VK_Key_Symbol[vi].Text := cVirtual_Keyboard_Keys[vi];
    VK_Key_Symbol[12].TextSettings.FontColor := TAlphaColorRec.White;
    VK_Key_Symbol[24].TextSettings.FontColor := TAlphaColorRec.White;
    VK_Key_Symbol[36].TextSettings.FontColor := TAlphaColorRec.White;
  end;
end;

procedure uVirtual_Keyboard_Add_DropLine(vLine: Integer; vString: String; vImagePath: String);
begin
  VK_Drop_Line_Back[vLine] := TRectangle.Create(VK_Drop_Box);
  VK_Drop_Line_Back[vLine].Name := 'Virual_Keyboard_Drop_Line_' + vLine.ToString;
  VK_Drop_Line_Back[vLine].Parent := VK_Drop_Box;
  VK_Drop_Line_Back[vLine].Width := VK_Drop_Box.Width - 8;
  VK_Drop_Line_Back[vLine].Height := 20;
  VK_Drop_Line_Back[vLine].Position.X := 4;
  VK_Drop_Line_Back[vLine].Position.Y := (vLine * 20) + 4;
  VK_Drop_Line_Back[vLine].Fill.Color := TAlphaColorRec.Black;
  VK_Drop_Line_Back[vLine].OnClick := vVK_Rectangle.OnMouseClick;
  VK_Drop_Line_Back[vLine].OnMouseEnter := vVK_Rectangle.OnMouseEnter;
  VK_Drop_Line_Back[vLine].OnMouseLeave := vVK_Rectangle.OnMouseLeave;
  VK_Drop_Line_Back[vLine].Tag := vLine;
  VK_Drop_Line_Back[vLine].Visible := True;

  VK_Drop_Icon[vLine] := TImage.Create(VK_Drop_Line_Back[vLine]);
  VK_Drop_Icon[vLine].Name := 'Virtual_Keyboard_Drop_Icon_' + vLine.ToString;
  VK_Drop_Icon[vLine].Parent := VK_Drop_Line_Back[vLine];
  VK_Drop_Icon[vLine].Width := 18;
  VK_Drop_Icon[vLine].Height := 18;
  VK_Drop_Icon[vLine].Position.X := 2;
  VK_Drop_Icon[vLine].Position.Y := 1;
  if vImagePath <> '' then
    VK_Drop_Icon[vLine].Bitmap.LoadFromFile(vImagePath);
  VK_Drop_Icon[vLine].OnClick := vVK_Image.OnMouseClick;
  VK_Drop_Icon[vLine].OnMouseEnter := vVK_Image.OnMouseEnter;
  VK_Drop_Icon[vLine].OnMouseLeave := vVK_Image.OnMouseLeave;
  VK_Drop_Icon[vLine].Tag := vLine;
  VK_Drop_Icon[vLine].Visible := True;

  VK_Drop_Text[vLine] := TText.Create(VK_Drop_Line_Back[vLine]);
  VK_Drop_Text[vLine].Name := 'Virtual_Keyboard_Drop_Text_' + vLine.ToString;
  VK_Drop_Text[vLine].Parent := VK_Drop_Line_Back[vLine];
  VK_Drop_Text[vLine].Width := VK_Drop_Line_Back[vLine].Width - 22;
  VK_Drop_Text[vLine].Height := 18;
  VK_Drop_Text[vLine].Font.Size := 16;
  VK_Drop_Text[vLine].Position.X := 22;
  VK_Drop_Text[vLine].Color := TAlphaColorRec.White;
  VK_Drop_Text[vLine].TextSettings.HorzAlign := TTextAlign.Leading;
  VK_Drop_Text[vLine].Text := vString;
  VK_Drop_Text[vLine].Tag := vLine;
  VK_Drop_Text[vLine].OnClick := vVK_Text.OnMouseClick;
  VK_Drop_Text[vLine].OnMouseEnter := vVK_Text.OnMouseEnter;
  VK_Drop_Text[vLine].OnMouseLeave := vVK_Text.OnMouseLeave;
  VK_Drop_Text[vLine].Visible := True;

  if vLine > 5 then
    VK_Drop_Background.Height := 130
  else
    VK_Drop_Background.Height := (vLine + 1) * 21.66;
  VK_Drop_Num := vLine;
end;

/// /////////////////////////////////////////////////////////////////////////////
procedure uVirtual_Keyboard_SetKey(vKey: String);
var
  vi: Integer;
  vEditString: String;
  vScrollByNum: Single;
  vFoundDrop: Boolean;

  function uVirtual_Keyboard_KeyToNum(vKey_Num: String): Integer;
  begin
    if vKey_Num = '' then
      Result := 0
    else if vKey_Num = '1' then
      Result := 1
    else if vKey_Num = '2' then
      Result := 2
    else if vKey_Num = '3' then
      Result := 3
    else if vKey_Num = '4' then
      Result := 4
    else if vKey_Num = '5' then
      Result := 5
    else if vKey_Num = '6' then
      Result := 6
    else if vKey_Num = '7' then
      Result := 7
    else if vKey_Num = '8' then
      Result := 8
    else if vKey_Num = '9' then
      Result := 9
    else if vKey_Num = '0' then
      Result := 10
    else if vKey_Num = 'BACKSPACE' then
      Result := 11
    else if vKey_Num = 'CAPS LOCK' then
      Result := 12
    else if vKey_Num = 'Q' then
      Result := 13
    else if vKey_Num = 'W' then
      Result := 14
    else if vKey_Num = 'E' then
      Result := 15
    else if vKey_Num = 'R' then
      Result := 16
    else if vKey_Num = 'T' then
      Result := 17
    else if vKey_Num = 'Y' then
      Result := 18
    else if vKey_Num = 'U' then
      Result := 19
    else if vKey_Num = 'I' then
      Result := 20
    else if vKey_Num = 'O' then
      Result := 21
    else if vKey_Num = 'P' then
      Result := 22
    else if vKey_Num = 'ENTER' then
      Result := 23
    else if vKey_Num = 'SHIFT' then
      Result := 24
    else if vKey_Num = 'A' then
      Result := 25
    else if vKey_Num = 'S' then
      Result := 26
    else if vKey_Num = 'D' then
      Result := 27
    else if vKey_Num = 'F' then
      Result := 28
    else if vKey_Num = 'G' then
      Result := 29
    else if vKey_Num = 'H' then
      Result := 30
    else if vKey_Num = 'J' then
      Result := 31
    else if vKey_Num = 'K' then
      Result := 32
    else if vKey_Num = 'L' then
      Result := 33
    else if vKey_Num = ';' then
      Result := 34
    else if vKey_Num = '' then
      Result := 35
    else if vKey_Num = 'CTRL' then
      Result := 36
    else if vKey_Num = 'Z' then
      Result := 37
    else if vKey_Num = 'X' then
      Result := 38
    else if vKey_Num = 'C' then
      Result := 39
    else if vKey_Num = 'V' then
      Result := 40
    else if vKey_Num = 'B' then
      Result := 41
    else if vKey_Num = 'N' then
      Result := 42
    else if vKey_Num = 'M' then
      Result := 43
    else if vKey_Num = '.' then
      Result := 44
    else if vKey_Num = '/' then
      Result := 45
    else if vKey_Num = 'NUM2' then
      Result := 46
    else if vKey_Num = 'SPACE' then
      Result := 47
    else if vKey_Num = 'LEFT' then
      Result := 48
    else if vKey_Num = 'RIGHT' then
      Result := 49
    else if vKey_Num = 'ESC' then
      Result := 50
    else if vKey_Num = 'UP' then
      Result := 51
    else if vKey_Num = 'DOWN' then
      Result := 52
    else
      Result := -1;
  end;

begin
  if (UpperCase(vKey) <> 'UP') and (UpperCase(vKey) <> 'DOWN') then
  begin
    for vi := 0 to 50 do
      VK_Key[vi].Fill.Color := TAlphaColorRec.Black;
    VK_Key[uVirtual_Keyboard_KeyToNum(UpperCase(vKey))].Fill.Color := TAlphaColorRec.Deepskyblue;
  end;

  if UpperCase(vKey) = 'BACKSPACE' then
  begin
    if VK_Edit.Text <> '' then
    begin
      vEditString := VK_Edit.Text;
      Delete(vEditString, Length(vEditString), 1);
      VK_Edit.Text := vEditString;
      VK_Edit.SelStart := Length(VK_Edit.Text);
    end
  end
  else if UpperCase(vKey) = 'ENTER' then
  begin
    uVirtual_Keyboard_DoAction('ENTER');
  end
  else if UpperCase(vKey) = 'CAPS LOCK' then
  begin
    if VK_Key_Symbol[uVirtual_Keyboard_KeyToNum(UpperCase(vKey))].Color <> TAlphaColorRec.Grey then
    begin
      VK_Capitals := not VK_Capitals;
      uVirtual_Keyboard_Capital(VK_Capitals);
    end;
  end
  else if UpperCase(vKey) = 'SHIFT' then
  begin
    if (VK_Symbols = False) and (VK_Capitals = False) then
    begin
      VK_Shifts := not VK_Shifts;
      uVirtual_Keyboard_Shift(VK_Shifts);
    end;
  end
  else if UpperCase(vKey) = 'CTRL' then
  begin
    if VK_Key_Symbol[uVirtual_Keyboard_KeyToNum(UpperCase(vKey))].Color <> TAlphaColorRec.Gray then
    begin
      VK_Symbols := not VK_Symbols;
      uVirtual_Keyboard_Symbols(VK_Symbols);
    end;
  end
  else if UpperCase(vKey) = 'SPACE' then
  begin
    VK_Edit.Text := VK_Edit.Text + ' ';
    VK_Edit.SelStart := Length(VK_Edit.Text);
  end
  else if UpperCase(vKey) = 'UP' then
  begin
    if VK_Drop_Num_Current > -1 then
    begin
      if VK_Drop_Num > 5 then
        vScrollByNum := ((VK_Drop_Num * 21.66) - 130) / VK_Drop_Num + 1;
      for vi := 0 to 50 do
        VK_Key[vi].Fill.Color := TAlphaColorRec.Black;
      VK_Drop_Line_Back[VK_Drop_Num_Current].Fill.Color := TAlphaColorRec.Black;
      dec(VK_Drop_Num_Current, 1);
      if VK_Drop_Num_Current <> -1 then
        VK_Drop_Line_Back[VK_Drop_Num_Current].Fill.Color := TAlphaColorRec.Deepskyblue;
      if VK_Drop_Num_Current < VK_Drop_Num + 1 then
        if VK_Drop_Num_Current = 0 then
          VK_Drop_Box.ScrollBy(0, 1000)
        else
          VK_Drop_Box.ScrollBy(0, vScrollByNum);
    end;
  end
  else if UpperCase(vKey) = 'DOWN' then
  begin
    if VK_Drop_Num_Current < 20 then
    begin
      for vi := 0 to 50 do
        VK_Key[vi].Fill.Color := TAlphaColorRec.Black;
      if VK_Drop_Num_Current < VK_Drop_Num then
      begin
        if VK_Drop_Num > 5 then
          vScrollByNum := ((VK_Drop_Num * 21.66) - 130) / VK_Drop_Num + 1;
        if VK_Drop_Num_Current <> -1 then
          VK_Drop_Line_Back[VK_Drop_Num_Current].Fill.Color := TAlphaColorRec.Black;
        inc(VK_Drop_Num_Current, 1);
        if VK_Drop_Num_Current > 20 then
          VK_Drop_Num_Current := 20;
        VK_Drop_Line_Back[VK_Drop_Num_Current].Fill.Color := TAlphaColorRec.Deepskyblue;
        if VK_Drop_Num_Current > 1 then
          if VK_Drop_Num = VK_Drop_Num_Current then
            VK_Drop_Box.ScrollBy(0, -1000)
          else
            VK_Drop_Box.ScrollBy(0, -vScrollByNum);
      end;
    end;
  end
  else
  begin
    VK_Edit.Text := VK_Edit.Text + VK_Key_Symbol[uVirtual_Keyboard_KeyToNum(vKey)].Text;
    VK_Edit.SelStart := Length(VK_Edit.Text);
  end;
  if (UpperCase(vKey) <> 'UP') and (UpperCase(vKey) <> 'DOWN') then
    uVirtual_Keyboard_DoAction(UpperCase(vKey));
end;

procedure uVirtual_Keyboard_DoAction(vKey: String);
begin
  if extrafe.prog.State = 'Loading' then
  begin

  end
  else if extrafe.prog.State = 'mainmenu' then
  begin

  end
  else if extrafe.prog.State = 'mame' then
  begin
    uEmu_Actions_VirtualKeyboard_SetKey(vKey);
  end;
end;

{ TVIRTUAL_KEYBOARD_IMAGE }

procedure TVIRTUAL_KEYBOARD_IMAGE.OnMouseClick(Sender: TObject);
begin

end;

procedure TVIRTUAL_KEYBOARD_IMAGE.OnMouseEnter(Sender: TObject);
begin
  if TImage(Sender).Name = 'Virtual_Keyboard_Drop_Icon_' + TImage(Sender).Tag.ToString then
    VK_Drop_Line_Back[TImage(Sender).Tag].Fill.Color := TAlphaColorRec.Deepskyblue;
end;

procedure TVIRTUAL_KEYBOARD_IMAGE.OnMouseLeave(Sender: TObject);
begin
  if TImage(Sender).Name = 'Virtual_Keyboard_Drop_Icon_' + TImage(Sender).Tag.ToString then
    VK_Drop_Line_Back[TImage(Sender).Tag].Fill.Color := TAlphaColorRec.Black;
end;

{ TVIRTUAL_KEYBOARD_TEXT }

procedure TVIRTUAL_KEYBOARD_TEXT.OnMouseClick(Sender: TObject);
var
  vString: String;
begin
  if TText(Sender).Name = 'Virtual_Keyboard_Drop_Text_' + TText(Sender).Tag.ToString then
  begin
    if TText(Sender).Text <> '...' then
    begin
      VK_Edit.Text := TText(Sender).Text;
      VK_Edit.SelStart := Length(VK_Edit.Text);
      uVirtual_Keyboard_DoAction('Drop');
    end;
  end
  else
  begin
    if TText(Sender).Text = 'Caps Lock' then
    begin
      if TText(Sender).Color <> TAlphaColorRec.Grey then
      begin
        VK_Capitals := not VK_Capitals;
        uVirtual_Keyboard_Capital(VK_Capitals)
      end;
    end
    else if TText(Sender).Text = 'Shift' then
    begin
      if (VK_Symbols = False) and (VK_Capitals = False) then
      begin
        VK_Shifts := not VK_Shifts;
        uVirtual_Keyboard_Shift(VK_Shifts);
      end;
    end
    else if TText(Sender).Text = 'Symbols' then
    begin
      if TText(Sender).Color <> TAlphaColorRec.Gray then
      begin
        VK_Symbols := not VK_Symbols;
        uVirtual_Keyboard_Symbols(VK_Symbols);
      end;
    end
    else if TText(Sender).Text = 'Back' then
    begin
      if VK_Edit.Text <> '' then
      begin
        vString := VK_Edit.Text;
        Delete(vString, Length(vString), 1);
        VK_Edit.Text := vString;
        VK_Edit.SelStart := Length(VK_Edit.Text);
        uVirtual_Keyboard_DoAction('Back');
      end;
    end
    else if TText(Sender).Text = 'Space' then
    begin
      VK_Edit.Text := VK_Edit.Text + ' ';
      uVirtual_Keyboard_DoAction('Space');
    end
    else if TText(Sender).Text = 'Exit' then
      uVirtual_Keyboard_DoAction('Key_Esc')
    else if TText(Sender).Text = 'Enter' then
      uVirtual_Keyboard_DoAction('Key_Enter')
    else
    begin
      VK_Edit.Text := VK_Edit.Text + VK_Key_Symbol[TImage(Sender).Tag].Text;
      uVirtual_Keyboard_DoAction(TText(Sender).Text);
      if VK_Shifts then
      begin
        VK_Shifts := not VK_Shifts;
        uVirtual_Keyboard_Shift(VK_Shifts);
      end;
    end;
    VK_Edit.SelStart := Length(VK_Edit.Text);
  end;
end;

procedure TVIRTUAL_KEYBOARD_TEXT.OnMouseEnter(Sender: TObject);
var
  vi: Integer;
begin
  if TText(Sender).Name = 'Virtual_Keyboard_Drop_Text_' + TText(Sender).Tag.ToString then
  begin
    if VK_Drop_Num_Current <> TText(Sender).Tag then
    begin
      for vi := 0 to 20 do
        if Assigned(VK_Drop_Line_Back[vi]) then
          VK_Drop_Line_Back[vi].Fill.Color := TAlphaColorRec.Black;
    end;
    VK_Drop_Line_Back[TText(Sender).Tag].Fill.Color := TAlphaColorRec.Deepskyblue;
    VK_Drop_Num_Current := TText(Sender).Tag;
  end
  else
    VK_Key[TText(Sender).Tag].Fill.Color := TAlphaColorRec.Deepskyblue;
end;

procedure TVIRTUAL_KEYBOARD_TEXT.OnMouseLeave(Sender: TObject);
begin
  if TText(Sender).Name = 'Virtual_Keyboard_Drop_Text_' + TText(Sender).Tag.ToString then
  begin
    VK_Drop_Line_Back[TText(Sender).Tag].Fill.Color := TAlphaColorRec.Black;
    VK_Drop_Num_Current := -1;
  end
  else
    VK_Key[TText(Sender).Tag].Fill.Color := StringToAlphaColor('#FF010709');
end;

{ TVIRTUAL_KEYBOARD }

constructor TVIRTUAL_KEYBOARD.Create(AOwner: TComponent);
begin
  inherited;
  uVirtual_Keyboard_Create(nil, '', '');
end;

destructor TVIRTUAL_KEYBOARD.Destroy;
begin

  inherited;
end;

procedure TVIRTUAL_KEYBOARD.SetCapsLock(const value: Boolean);
begin

end;

procedure TVIRTUAL_KEYBOARD.uVirtual_Keyboard_Create(Sender: TObject; vType, vTitle: String);
var
  vi, vfi: Integer;
begin
  // vVK_Back:= TImage(Sender);
  // vVK_Back:= TLayout(sender);

  // vVK_Back.Align:= TAlignLayout.Client;
  // vVK_Back.Width:= 400;
  // vVK_Back.Height:= 350;
  // vVK_Back.Position.X:= (Emu_Form.Width/ 2)- (vVK_Back.Width / 2);
  // vVK_Back.Position.Y:= 250;
  self.Align := TAlignLayout.Client;
  // VK_Background:= TRectangle.Create(vVK_Back);
  VK_Background := TRectangle.Create(self);
  VK_Background.Name := 'Virtual_Keyboard';
  VK_Background.Parent := self;
  VK_Background.Width := 800;
  VK_Background.Height := 500;
  VK_Background.Position.X := extrafe.res.Half_Width - 400;
  VK_Background.Position.Y := extrafe.res.Half_Height + 250;
  VK_Background.XRadius := 8;
  VK_Background.YRadius := 8;
  VK_Background.Stroke.Thickness := 8;
  VK_Background.Stroke.Color := TAlphaColorRec.Deepskyblue;
  VK_Background.Fill.Color := StringToAlphaColor('#FF01182E');
  VK_Background.Visible := True;

  VK_Title_Background := TRectangle.Create(VK_Background);
  VK_Title_Background.Name := 'Virtual_Keyboard_BackTitle';
  VK_Title_Background.Parent := VK_Background;
  VK_Title_Background.Width := VK_Background.Width - 16;
  VK_Title_Background.Height := 30;
  VK_Title_Background.Position.X := 8;
  VK_Title_Background.Position.Y := 8;
  VK_Title_Background.XRadius := 4;
  VK_Title_Background.YRadius := 4;
  VK_Title_Background.Stroke.Thickness := 4;
  VK_Title_Background.Stroke.Color := TAlphaColorRec.Black;
  VK_Title_Background.Fill.Color := StringToAlphaColor('#FF010709');
  VK_Title_Background.Corners := VK_Title_Background.Corners - [TCorner.BottomLeft, TCorner.BottomRight];
  VK_Title_Background.Visible := True;

  VK_Title_Icon := TImage.Create(VK_Title_Background);
  VK_Title_Icon.Name := 'Virtual_Keyboard_IconTitle';
  VK_Title_Icon.Parent := VK_Title_Background;
  VK_Title_Icon.Width := 28;
  VK_Title_Icon.Height := 28;
  VK_Title_Icon.Position.X := 1;
  VK_Title_Icon.Position.Y := 1;
  VK_Title_Icon.WrapMode := TImageWrapMode.Fit;
  vVirtual_Keyboard_Type := vType;
  if vVirtual_Keyboard_Type = 'Search' then
    VK_Title_Icon.Bitmap.LoadFromFile(ex_main.Paths.Images + 'vk_search.png')
  else if vVirtual_Keyboard_Type = 'Type' then
    VK_Title_Icon.Bitmap.LoadFromFile(ex_main.Paths.Images + 'vk_type.png');
  VK_Title_Icon.Visible := True;

  VK_Title := TText.Create(VK_Title_Background);
  VK_Title.Name := 'Virtual_Keyboard_Title';
  VK_Title.Parent := VK_Title_Background;
  VK_Title.Color := TAlphaColorRec.White;
  VK_Title.Font.Family := 'Tahoma';
  VK_Title.Font.Size := 16;
  VK_Title.Width := VK_Title_Background.Width - 30;
  VK_Title.Height := 28;
  VK_Title.Position.X := 34;
  VK_Title.Position.Y := 1;
  VK_Title.Font.Style := VK_Title.Font.Style + [TFontStyle.fsBold];
  VK_Title.Text := vTitle;
  VK_Title.HorzTextAlign := TTextAlign.Leading;
  VK_Title.VertTextAlign := TTextAlign.Center;
  VK_Title.Visible := True;

  VK_Edit_Background := TRectangle.Create(VK_Background);
  VK_Edit_Background.Name := 'Virtual_Keyboard_BackEdit';
  VK_Edit_Background.Parent := VK_Background;
  VK_Edit_Background.Width := VK_Background.Width - 16;
  VK_Edit_Background.Height := 30;
  VK_Edit_Background.Position.X := 8;
  VK_Edit_Background.Position.Y := 58;
  VK_Edit_Background.XRadius := 4;
  VK_Edit_Background.YRadius := 4;
  VK_Edit_Background.Stroke.Thickness := 4;
  VK_Edit_Background.Stroke.Color := TAlphaColorRec.Black;
  VK_Edit_Background.Fill.Color := StringToAlphaColor('#FF010709');
  VK_Edit_Background.Corners := VK_Edit_Background.Corners - [TCorner.BottomLeft, TCorner.BottomRight];
  VK_Edit_Background.Visible := True;

  VK_Edit := TEdit.Create(VK_Edit_Background);
  VK_Edit.Name := 'Virtual_Keyboard_Edit';
  VK_Edit.Parent := VK_Edit_Background;
  VK_Edit.Width := VK_Edit_Background.Width - 20;
  VK_Edit.Height := 22;
  VK_Edit.Position.X := 10;
  VK_Edit.Position.Y := 4;
  VK_Edit.Text := '';
  VK_Edit.ReadOnly := True;
  VK_Edit.Caret.Color := TAlphaColorRec.Deepskyblue;
  VK_Edit.TextSettings.HorzAlign := TTextAlign.Center;
  VK_Edit.Visible := True;

  VK_Drop_Background := TRectangle.Create(VK_Background);
  VK_Drop_Background.Name := 'Virtual_Keyboard_Drop_Background';
  VK_Drop_Background.Parent := VK_Background;
  VK_Drop_Background.Width := VK_Background.Width - 16;
  VK_Drop_Background.Height := 130;
  VK_Drop_Background.Position.X := 8;
  VK_Drop_Background.Position.Y := 88;
  VK_Drop_Background.XRadius := 4;
  VK_Drop_Background.YRadius := 4;
  VK_Drop_Background.Stroke.Thickness := 4;
  VK_Drop_Background.Stroke.Color := TAlphaColorRec.Black;
  VK_Drop_Background.Fill.Color := StringToAlphaColor('#FF010709');
  VK_Drop_Background.Corners := VK_Drop_Background.Corners - [TCorner.TopLeft, TCorner.TopRight];
  VK_Drop_Background.Visible := True;

  VK_Drop_Box := TVertScrollBox.Create(VK_Drop_Background);
  VK_Drop_Box.Name := 'Virtual_Keyboard_Drop_Box';
  VK_Drop_Box.Parent := VK_Drop_Background;
  VK_Drop_Box.Align := TAlignLayout.Client;
  VK_Drop_Box.Visible := True;

  for vi := 0 to 20 do
  begin
    VK_Drop_Line_Back[vi] := TRectangle.Create(VK_Drop_Box);
    VK_Drop_Line_Back[vi].Name := 'Virual_Keyboard_Drop_Line_' + vi.ToString;
    VK_Drop_Line_Back[vi].Parent := VK_Drop_Box;
    VK_Drop_Line_Back[vi].Width := VK_Drop_Box.Width - 28;
    VK_Drop_Line_Back[vi].Height := 20;
    VK_Drop_Line_Back[vi].Position.X := 4;
    VK_Drop_Line_Back[vi].Position.Y := (vi * 20) + 4;
    VK_Drop_Line_Back[vi].Fill.Color := TAlphaColorRec.Black;
    VK_Drop_Line_Back[vi].Visible := True;

    VK_Drop_Icon[vi] := TImage.Create(VK_Drop_Line_Back[vi]);
    VK_Drop_Icon[vi].Name := 'Virtual_Keyboard_Drop_Icon_' + vi.ToString;
    VK_Drop_Icon[vi].Parent := VK_Drop_Line_Back[vi];
    VK_Drop_Icon[vi].Width := 18;
    VK_Drop_Icon[vi].Height := 18;
    VK_Drop_Icon[vi].Position.X := 2;
    VK_Drop_Icon[vi].Position.Y := 1;
    VK_Drop_Icon[vi].Bitmap.LoadFromFile(ex_main.Paths.Images + 'line.png');
    VK_Drop_Icon[vi].Visible := True;

    VK_Drop_Text[vi] := TText.Create(VK_Drop_Line_Back[vi]);
    VK_Drop_Text[vi].Name := 'Virtual_Keyboard_Drop_Text_' + vi.ToString;
    VK_Drop_Text[vi].Parent := VK_Drop_Line_Back[vi];
    VK_Drop_Text[vi].Width := 300;
    VK_Drop_Text[vi].Height := 18;
    VK_Drop_Text[vi].Font.Size := 16;
    VK_Drop_Text[vi].Color := TAlphaColorRec.White;
    if vi = 20 then
      VK_Drop_Text[vi].Text := '...'
    else
      VK_Drop_Text[vi].Text := 'Here is a result that counts';
    VK_Drop_Text[vi].Visible := True;
  end;

  vfi := 0;
  for vi := 0 to 50 do
  begin
    VK_Key[vi] := TRectangle.Create(VK_Background);
    VK_Key[vi].Name := 'Virtual_Keyboard_Key_' + IntToStr(vi);
    VK_Key[vi].Parent := VK_Background;
    if vi = 11 then
    begin
      VK_Key[vi].Width := 80;
      VK_Key[vi].Height := 50;
      VK_Key[vi].Position.X := (50 * 10) + 170;
      VK_Key[vi].Position.Y := 220;
    end
    else if vi = 23 then
    begin
      VK_Key[vi].Width := 80;
      VK_Key[vi].Height := 100;
      VK_Key[vi].Position.X := (50 * 10) + 170;
      VK_Key[vi].Position.Y := 270;
    end
    else if vi = 47 then
    begin
      VK_Key[vi].Width := 300;
      VK_Key[vi].Height := 50;
      VK_Key[vi].Position.X := (50 * 1) + 170;
      VK_Key[vi].Position.Y := 420;
    end
    else if vi in [48, 49, 50] then
    begin
      VK_Key[vi].Width := 50;
      VK_Key[vi].Height := 50;
      if vi = 48 then
        VK_Key[vi].Position.X := (50 * 8) + 170
      else if vi = 49 then
        VK_Key[vi].Position.X := (50 * 9) + 170
      else
        VK_Key[vi].Position.X := (50 * 11) + 150;
      VK_Key[vi].Position.Y := 420;
    end
    else if vi in [0, 12, 24, 36] then
    begin
      VK_Key[vi].Width := 120;
      VK_Key[vi].Height := 50;
      VK_Key[vi].Position.X := 50;
      if vi > 28 then
        VK_Key[vi].Position.Y := 370
      else if vi > 18 then
        VK_Key[vi].Position.Y := 320
      else if vi > 10 then
        VK_Key[vi].Position.Y := 270
      else
        VK_Key[vi].Position.Y := 220;
    end
    else
    begin
      VK_Key[vi].Width := 50;
      VK_Key[vi].Height := 50;
      if (vi = 13) or (vi = 25) or (vi = 37) then
        vfi := 0;
      VK_Key[vi].Position.X := (50 * vfi) + 170;
      if vi > 36 then
        VK_Key[vi].Position.Y := 370
      else if vi > 23 then
        VK_Key[vi].Position.Y := 320
      else if vi > 11 then
        VK_Key[vi].Position.Y := 270
      else
        VK_Key[vi].Position.Y := 220;
      inc(vfi, 1);
    end;
    VK_Key[vi].Stroke.Thickness := 4;
    VK_Key[vi].Stroke.Color := TAlphaColorRec.Black;
    VK_Key[vi].Fill.Color := StringToAlphaColor('#FF010709');
    VK_Key[vi].OnClick := vVK_Image.OnMouseClick;
    VK_Key[vi].OnMouseEnter := vVK_Image.OnMouseEnter;
    VK_Key[vi].OnMouseLeave := vVK_Image.OnMouseLeave;
    VK_Key[vi].Tag := vi;
    if vi <> 35 then
      VK_Key[vi].Visible := True
    else
      VK_Key[vi].Visible := False;

    VK_Key_Symbol[vi] := TText.Create(VK_Key[vi]);
    VK_Key_Symbol[vi].Name := 'Virtual_Keyboard_Key_Name_' + IntToStr(vi);
    VK_Key_Symbol[vi].Parent := VK_Key[vi];
    VK_Key_Symbol[vi].Align := TAlignLayout.Client;
    VK_Key_Symbol[vi].Color := TAlphaColorRec.White;
    VK_Key_Symbol[vi].Font.Family := 'Tahoma';
    VK_Key_Symbol[vi].Font.Size := 20;
    VK_Key_Symbol[vi].Font.Style := VK_Key_Symbol[vi].Font.Style + [TFontStyle.fsBold];
    VK_Key_Symbol[vi].Text := cVirtual_Keyboard_Keys[vi];
    VK_Key_Symbol[vi].HorzTextAlign := TTextAlign.Center;
    VK_Key_Symbol[vi].VertTextAlign := TTextAlign.Center;
    VK_Key_Symbol[vi].OnClick := vVK_Text.OnMouseClick;
    VK_Key_Symbol[vi].OnMouseEnter := vVK_Text.OnMouseEnter;
    VK_Key_Symbol[vi].OnMouseLeave := vVK_Text.OnMouseLeave;
    VK_Key_Symbol[vi].Tag := vi;
    VK_Key_Symbol[vi].Visible := True;
  end;

  vVirtual_Keyboard_Active := True;
  VK_Symbols := False;
  VK_Capitals := False;
  VK_Shifts := False;
end;

procedure TVIRTUAL_KEYBOARD.uVK_Create(vType, vTitle: String);
begin

end;

{ TVIRTUAL_KEYBOARD_RECTANGLE }

procedure TVIRTUAL_KEYBOARD_RECTANGLE.OnMouseClick(Sender: TObject);
begin

end;

procedure TVIRTUAL_KEYBOARD_RECTANGLE.OnMouseEnter(Sender: TObject);
begin
  if TRectangle(Sender).Name = 'Virual_Keyboard_Drop_Line_' + TRectangle(Sender).Tag.ToString then
    TRectangle(Sender).Fill.Color := TAlphaColorRec.Deepskyblue;
end;

procedure TVIRTUAL_KEYBOARD_RECTANGLE.OnMouseLeave(Sender: TObject);
begin
  if TRectangle(Sender).Name = 'Virual_Keyboard_Drop_Line_' + TRectangle(Sender).Tag.ToString then
    TRectangle(Sender).Fill.Color := TAlphaColorRec.Black;
end;

initialization

vVK_Image := TVIRTUAL_KEYBOARD_IMAGE.Create;
vVK_Text := TVIRTUAL_KEYBOARD_TEXT.Create;
vVK_Rectangle := TVIRTUAL_KEYBOARD_RECTANGLE.Create;

finalization

vVK_Image.Free;
vVK_Text.Free;
vVK_Rectangle.Free;

end.
