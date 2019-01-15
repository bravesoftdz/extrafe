unit uMain_Emulation;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UITypes,
  System.UIConsts,
  FMX.Objects,
  FMX.Graphics,
  FMX.Effects,
  FMX.Ani,
  FMX.Types,
  FMX.Filter.Effects,
  ALFmxStdCtrls,
  ALFmxObjects,
  ALFmxLayouts,
  ALFmxTabControl;

type
  TEMULATOR_IMAGE = class(TObject)

    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
    procedure OnMouseClick(Sender: TObject);
  end;

procedure uMain_Emulation_Clear_Selection_Control;

procedure uMain_Emulation_Create_Selection_Control;
procedure uMain_Emulation_Create_Selection_Tab(vTab, vLevel: Integer; isActive: Boolean);
function uMain_Emulation_GetBitmap(vNum, vLevel: Integer): TBitmap;

procedure uMain_Emulation_TriggerEmulator;

procedure uMain_Emulation_Arcade_Category;
procedure uMain_Emulation_SubHeader_Level(vCategory: Integer);

procedure uMain_Emulation_Trigger_Click(vTriggerImage: Integer; vBack: Boolean);

procedure uMain_Emulation_Category(vMenuIndex: Integer);

procedure uMain_Emulation_Slide_Right;
procedure uMain_Emulation_Slide_Left;

var
  vEmulator_Image: TEMULATOR_IMAGE;

implementation

uses
  main,
  emu,
  uLoad,
  uLoad_AllTypes,
  uMain_AllTypes,
  uMain_SetAll,
  uMain_Mouse,
  uEmu_Actions;

procedure uMain_Emulation_Clear_Selection_Control;
begin
  FreeAndNil(emulation.Selection);
end;

function uMain_Emulation_GetBitmap(vNum, vLevel: Integer): TBitmap;
begin
  Result := TBitmap.Create;
  if vLevel = 0 then
  begin
    case vNum of
      0:
        Result.LoadFromFile(emulation.Category[0].Menu_Image_Path + emulation.Category[0].Menu_Image);
      1:
        Result.LoadFromFile(emulation.Category[1].Menu_Image_Path + emulation.Category[1].Menu_Image);
      2:
        Result.LoadFromFile(emulation.Category[2].Menu_Image_Path + emulation.Category[2].Menu_Image);
      3:
        Result.LoadFromFile(emulation.Category[3].Menu_Image_Path + emulation.Category[3].Menu_Image);
      4:
        Result.LoadFromFile(emulation.Category[4].Menu_Image_Path + emulation.Category[4].Menu_Image);
    end;
  end
  else if vLevel = 1 then
  begin
    Case vNum of
      0:
        Result.LoadFromFile(emulation.Arcade[0].Menu_Image_Path + emulation.Arcade[0].Menu_Image);
    end;
  end;
end;

procedure uMain_Emulation_Create_Selection_Control;
var
  vi: Integer;
begin
  emulation.Selection := TALTabControl.Create(mainScene.Selection.Back);
  emulation.Selection.Name := 'MainMenu_Selection_Control';
  emulation.Selection.Parent := mainScene.Selection.Back;
  emulation.Selection.Width := mainScene.Selection.Back.Width;
  emulation.Selection.Height := mainScene.Selection.Back.Height;
  emulation.Selection.Visible := True;

  emulation.Selection_Ani := TFloatAnimation.Create(emulation.Selection);
  emulation.Selection_Ani.Name := 'MainMenu_Selection_Ani';
  emulation.Selection_Ani.Parent := emulation.Selection;
  emulation.Selection_Ani.Duration := 0.4;
  emulation.Selection_Ani.Interpolation := TInterpolationType.Quadratic;
  emulation.Selection_Ani.PropertyName := 'Position.Y';
  emulation.Selection_Ani.Loop := False;
  emulation.Selection_Ani.OnFinish := ex_main.input.mouse.Animation.OnFinish;
  emulation.Selection_Ani.Enabled := False;
end;

procedure uMain_Emulation_Create_Selection_Tab(vTab, vLevel: Integer; isActive: Boolean);
begin
  emulation.Selection_Tab[vTab].Tab := TALTabItem.Create(emulation.Selection);
  emulation.Selection_Tab[vTab].Tab.Name := 'Emulator_' + IntToStr(vTab);
  emulation.Selection_Tab[vTab].Tab.Parent := emulation.Selection;
  emulation.Selection_Tab[vTab].Tab.Visible := True;

  emulation.Selection_Tab[vTab].Logo := TImage.Create(emulation.Selection_Tab[vTab].Tab);
  emulation.Selection_Tab[vTab].Logo.Name := 'Emulator_Logo_' + IntToStr(vTab);
  emulation.Selection_Tab[vTab].Logo.Parent := emulation.Selection_Tab[vTab].Tab;
  emulation.Selection_Tab[vTab].Logo.Width := 600;
  emulation.Selection_Tab[vTab].Logo.Height := 186;
  emulation.Selection_Tab[vTab].Logo.Position.X := (emulation.Selection.Width / 2) - 300;
  emulation.Selection_Tab[vTab].Logo.Position.Y := (emulation.Selection.Height / 2) - 93;
  emulation.Selection_Tab[vTab].Logo.Bitmap := uMain_Emulation_GetBitmap(vTab, vLevel);
  emulation.Selection_Tab[vTab].Logo.OnMouseEnter := vEmulator_Image.OnMouseEnter;
  emulation.Selection_Tab[vTab].Logo.OnMouseLeave := vEmulator_Image.OnMouseLeave;
  emulation.Selection_Tab[vTab].Logo.OnClick := vEmulator_Image.OnMouseClick;
  emulation.Selection_Tab[vTab].Logo.Tag := vTab;
  emulation.Selection_Tab[vTab].Logo.Visible := True;

  emulation.Selection_Tab[vTab].Logo_Gray := TMonochromeEffect.Create(emulation.Selection_Tab[vTab].Logo);
  emulation.Selection_Tab[vTab].Logo_Gray.Name := 'Emulator_Logo_Gray_' + IntToStr(vTab);
  emulation.Selection_Tab[vTab].Logo_Gray.Parent := emulation.Selection_Tab[vTab].Logo;
  emulation.Selection_Tab[vTab].Logo_Gray.Enabled := not isActive;

  emulation.Selection_Tab[vTab].Logo_Glow := TGlowEffect.Create(emulation.Selection_Tab[vTab].Logo);
  emulation.Selection_Tab[vTab].Logo_Glow.Name := 'Emulator_Logo_Glow_' + IntToStr(vTab);
  emulation.Selection_Tab[vTab].Logo_Glow.Parent := emulation.Selection_Tab[vTab].Logo;
  emulation.Selection_Tab[vTab].Logo_Glow.Opacity := 0.9;
  emulation.Selection_Tab[vTab].Logo_Glow.Softness := 0.4;
  emulation.Selection_Tab[vTab].Logo_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  emulation.Selection_Tab[vTab].Logo_Glow.Tag := vTab;
  emulation.Selection_Tab[vTab].Logo_Glow.Enabled := False;

  emulation.Selection_Tab[vTab].Story := TText.Create(emulation.Selection_Tab[vTab].Tab);
  emulation.Selection_Tab[vTab].Story.Name := 'Emulator_Story_' + IntToStr(vTab);
  emulation.Selection_Tab[vTab].Story.Parent := emulation.Selection_Tab[vTab].Tab;
  emulation.Selection_Tab[vTab].Story.Position.X := extrafe.res.Width - 200;
  emulation.Selection_Tab[vTab].Story.Position.Y := 100;
  emulation.Selection_Tab[vTab].Story.TextSettings.FontColor := claWhite;
  emulation.Selection_Tab[vTab].Story.Text := 'gaksfgsakd';
  emulation.Selection_Tab[vTab].Story.Visible := True;
end;

procedure uMain_Emulation_TriggerEmulator;
begin
  Main_Form.Visible := False;
  uEmu_LoadEmulator(emulation.Number);
  Emu_Form.Show;
end;

procedure uMain_Emulation_Arcade_Category;
begin
  emulation.Level := 1;
  emulation.Category_Num := 0;
  uMain_Emulation_Clear_Selection_Control;
  uMain_Emulation_Create_Selection_Control;
  uMain_Emulation_Create_Selection_Tab(0, emulation.Level, emulation.Arcade[0].Active);
  emulation.Selection.TabIndex := 0;
end;

procedure uMain_Emulation_SubHeader_Level(vCategory: Integer);
begin
  case vCategory of
    0:
      uMain_Emulation_Arcade_Category;
    1:
      ;
    2:
      ;
    3:
      ;
    4:
      ;
  end;
end;

procedure uMain_Emulation_Trigger_Click(vTriggerImage: Integer; vBack: Boolean);
begin
  if vBack then
  begin
    if emulation.Level = 1 then
    begin
      uMain_Emulation_Clear_Selection_Control;
      uMain_Emulation_Category(emulation.Category_Num);
    end;
  end
  else
  begin
    if emulation.Level = 0 then
    begin
      uMain_Emulation_SubHeader_Level(vTriggerImage);
    end
    else
    begin
      emulation.Number := vTriggerImage;
      uMain_Emulation_TriggerEmulator;
    end;
  end;
end;

procedure uMain_Emulation_Category(vMenuIndex: Integer);
var
  vi, ki: Integer;
  vActive: Boolean;
  vEmu_Num: Integer;
begin
  emulation.Level := 0;
  for vi := 0 to 4 do
  begin
    case vi of
      0:
        vEmu_Num := 8;
      1:
        vEmu_Num := 30;
      2:
        vEmu_Num := 40;
      3:
        vEmu_Num := 10;
      4:
        vEmu_Num := 1;
    end;
    vActive:= False;
    for ki := 0 to vEmu_Num do
    begin
      if emulation.emu[vi, ki] <> 'nil' then
        begin
          vActive := True;
          Break;
        end;
    end;
    uMain_Emulation_Create_Selection_Tab(vi, emulation.Level, vActive);
  end;
  emulation.Selection.TabIndex := vMenuIndex;
  emulation.Category_Num := -1;
end;

/// /////////////////////////////////////////////////////////////////////////////
procedure uMain_Emulation_Slide_Right;
begin
  if extrafe.prog.State = 'main' then
    if emulation.Selection.TabCount - 1 <> emulation.Selection.TabIndex then
      emulation.Selection.Next();
end;

procedure uMain_Emulation_Slide_Left;
begin
  if extrafe.prog.State = 'main' then
    if emulation.Selection.TabIndex <> 0 then
      emulation.Selection.Previous();
end;

{ TEMULATOR_IMAGE }

procedure TEMULATOR_IMAGE.OnMouseClick(Sender: TObject);
begin
  if extrafe.prog.State = 'main' then
    if emulation.Selection_Tab[TImage(Sender).Tag].Logo_Gray.Enabled = False then
    begin
      uMain_Emulation_Trigger_Click(TImage(Sender).Tag, False);
    end;
end;

procedure TEMULATOR_IMAGE.OnMouseEnter(Sender: TObject);
begin
  if extrafe.prog.State = 'main' then
  begin
    emulation.Selection_Tab[TImage(Sender).Tag].Logo_Glow.Enabled := True;
  end;
end;

procedure TEMULATOR_IMAGE.OnMouseLeave(Sender: TObject);
begin
  if extrafe.prog.State = 'main' then
  begin
    emulation.Selection_Tab[TImage(Sender).Tag].Logo_Glow.Enabled := False;
  end;
end;

initialization

vEmulator_Image := TEMULATOR_IMAGE.Create;

finalization

vEmulator_Image.Free;

end.
