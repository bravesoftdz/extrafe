unit uSoundplayer_Tag_Mouse;

interface

uses
  System.Classes,
  System.UiTypes,
  System.StrUtils,
  System.SysUtils,
  FMX.Objects,
  FMX.StdCtrls;

type
  TSOUNDPLAYER_TAG_IMAGE = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
  end;

type
  TSOUNDPLAYER_TAG_BUTTON = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
  end;

type
  TSOUNDPLAYER_TAG_TEXT = class(TObject)
    procedure OnMouseClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);
    procedure OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
  end;

type
  TSOUNDPLAYER_TAG_RADIOBUTTON = class(TObject)
    procedure OnMouseClick(Sender: TObject);
  end;

type
  TSOUNDPLAYER_MOUSE_TAG_ACTIONS = record
    Image: TSOUNDPLAYER_TAG_IMAGE;
    Button: TSOUNDPLAYER_TAG_BUTTON;
    Text: TSOUNDPLAYER_TAG_TEXT;
    Radio: TSOUNDPLAYER_TAG_RADIOBUTTON;
  end;

implementation

uses
  uLoad_AllTypes,
  uSoundplayer_AllTypes,
  uSoundplayer_Scrapers_AZLyrics,
  uSoundplayer_Tag_MP3_SetAll,
  uSoundplayer_Tag_MP3,
  uSoundplayer_Tag_OGG_SetAll,
  uSoundplayer_Tag_OGG,
  uSnippets;

{ TSOUNDPLAYER_TAG_IMAGE }

procedure TSOUNDPLAYER_TAG_IMAGE.OnMouseClick(Sender: TObject);
var
  viPos_mp3: Integer;
  viPos_ogg: Integer;
begin
  viPos_mp3 := Pos('addon_soundplayer_tag_mp3', extrafe.prog.State);
  viPos_ogg := Pos('addon_soundplayer_tag_opus', extrafe.prog.State);
  if viPos_mp3 <> 0 then
  begin
    if TImage(Sender).Name = 'A_SP_Tag_Mp3_Lyrics_Get_Provider_0' then
      vSoundplayer.Tag.mp3.Lyrics_Int.Lyrics_Box.Lines := uSoundplayer_Scrapers_AZLyrics.Lyrics(vSoundplayer.Tag.mp3.ID3v2.Title_V.Text,
        vSoundplayer.Tag.mp3.ID3v2.Artist_V.Text);
  end
  else if viPos_ogg <> 0 then
  begin
    if TImage(Sender).Name = 'A_SP_Tag_Opus_Cover_AddComputer' then
    begin
      vSoundplayer.scene.OpenDialog.Name := 'A_SP_OpenDialog_Ogg_Cover_AddComputer';
      vSoundplayer.scene.OpenDialog.Execute;
    end
    else if TImage(Sender).Name = 'A_SP_Tag_Opus_Covers_Remove' then
      uSoundplayer_Tag_Ogg_Cover_Delete
  end;
end;

procedure TSOUNDPLAYER_TAG_IMAGE.OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  viPos_mp3: Integer;
  viPos_ogg: Integer;
begin
  viPos_mp3 := Pos('addon_soundplayer_tag_mp3', extrafe.prog.State);
  viPos_ogg := Pos('addon_soundplayer_tag_opus', extrafe.prog.State);
  if viPos_mp3 <> 0 then
  begin
    if TImage(Sender).Name = 'A_SP_Tag_Mp3_Lyrics_Get_Provider_0' then

  end
  else if viPos_ogg <> 0 then
  begin

  end;
end;

procedure TSOUNDPLAYER_TAG_IMAGE.OnMouseEnter(Sender: TObject);
var
  viPos_mp3: Integer;
  viPos_ogg: Integer;
begin
  viPos_mp3 := Pos('addon_soundplayer_tag_mp3', extrafe.prog.State);
  viPos_ogg := Pos('addon_soundplayer_tag_opus', extrafe.prog.State);
  if viPos_mp3 <> 0 then
  begin
    if TImage(Sender).Name = 'A_SP_Tag_Mp3_Lyrics_Get_Provider_0' then
      vSoundplayer.Tag.mp3.Lyrics_Int.Providers_Glow[0].Enabled := True
  end
  else if viPos_ogg <> 0 then
  begin
    if TImage(Sender).Name = 'A_SP_Tag_Opus_Cover_AddComputer' then
      vSoundplayer.Tag.Opus.Cover_LoadFromComputer_Glow.Enabled := True
    else if TImage(Sender).Name = 'A_SP_Tag_Opus_Cover_AddInternet' then
      vSoundplayer.Tag.Opus.Cover_LoadFromInterent_Glow.Enabled := True
    else if TImage(Sender).Name = 'A_SP_Tag_Opus_Covers_Remove' then
    begin
      if vSoundplayer.Tag.Opus.Cover_Delete_Grey.Enabled = False then
        vSoundplayer.Tag.Opus.Cover_Delete_Glow.Enabled := True;
    end;
  end;
  TImage(Sender).Cursor := crHandPoint;
end;

procedure TSOUNDPLAYER_TAG_IMAGE.OnMouseLeave(Sender: TObject);
var
  viPos_mp3: Integer;
  viPos_ogg: Integer;
begin
  viPos_mp3 := Pos('addon_soundplayer_tag_mp3', extrafe.prog.State);
  viPos_ogg := Pos('addon_soundplayer_tag_opus', extrafe.prog.State);
  if viPos_mp3 <> 0 then
  begin
    if TImage(Sender).Name = 'A_SP_Tag_Mp3_Lyrics_Get_Provider_0' then
      vSoundplayer.Tag.mp3.Lyrics_Int.Providers_Glow[0].Enabled := False
  end
  else if viPos_ogg <> 0 then
  begin
    if TImage(Sender).Name = 'A_SP_Tag_Opus_Cover_AddComputer' then
      vSoundplayer.Tag.Opus.Cover_LoadFromComputer_Glow.Enabled := False
    else if TImage(Sender).Name = 'A_SP_Tag_Opus_Cover_AddInternet' then
      vSoundplayer.Tag.Opus.Cover_LoadFromInterent_Glow.Enabled := False
    else if TImage(Sender).Name = 'A_SP_Tag_Opus_Covers_Remove' then
    begin
      if vSoundplayer.Tag.Opus.Cover_Delete_Grey.Enabled = False then
        vSoundplayer.Tag.Opus.Cover_Delete_Glow.Enabled := False;
    end;
  end;
end;

{ TSOUNDPLAYER_TAG_BUTTON }

procedure TSOUNDPLAYER_TAG_BUTTON.OnMouseClick(Sender: TObject);
var
  viPos_mp3: Integer;
  viPos_ogg: Integer;
begin
  viPos_mp3 := Pos('addon_soundplayer_tag_mp3', extrafe.prog.State);
  viPos_ogg := Pos('addon_soundplayer_tag_opus', extrafe.prog.State);
  if viPos_mp3 <> 0 then
  begin
    if TButton(Sender).Name = 'A_SP_Tag_Mp3_Save' then
      uSoundplayer_Tag_MP3.Save
    else if TButton(Sender).Name = 'A_SP_Tag_Mp3_Cancel' then
      uSoundplayer_Tag_MP3_SetAll.Free
    else if TButton(Sender).Name = 'A_SP_Tag_Mp3_CoverSelet_Main_Load' then
      uSoundplayer_Tag_MP3.Cover_SetFromComputer(vSoundplayer.Tag.mp3.Cover_Select.List.ItemIndex)
    else if TButton(Sender).Name = 'A_SP_Tag_Mp3_CoverSelet_Main_Cancel' then
      uSoundplayer_Tag_MP3.Cover_Select_Cancel
    else if TButton(Sender).Name = 'A_SP_Tag_Mp3_LyricsAdd_Main_Add' then
      uSoundplayer_Tag_MP3.Lyrics_Load
    else if TButton(Sender).Name = 'A_SP_Tag_Mp3_LyricsAdd_Main_Cancel' then
      uSoundplayer_Tag_MP3.Lyrics_Add_Cancel
    else if TButton(Sender).Name = 'A_SP_Tag_Mp3_Lyrics_Get_Add' then
      uSoundplayer_Tag_MP3.Lyrics_Get_Add
    else if TButton(Sender).Name = 'A_SP_Tag_Mp3_Lyrics_Get_Cancel' then
      uSoundplayer_Tag_MP3.Lyrics_Get_Cancel
  end
  else if viPos_ogg <> 0 then
  begin
    if TButton(Sender).Name = 'A_SP_Tag_Opus_Save' then
      uSoundplayer_Tag_Ogg_Save
    else if TButton(Sender).Name = 'A_SP_Tag_Opus_Cancel' then
      uSoundplayer_Tag_Ogg_Cancel
  end
end;

procedure TSOUNDPLAYER_TAG_BUTTON.OnMouseEnter(Sender: TObject);
begin
  TImage(Sender).Cursor := crHandPoint;
end;

procedure TSOUNDPLAYER_TAG_BUTTON.OnMouseLeave(Sender: TObject);
begin

end;

{ TSOUNDPLAYER_TAG_TEXT }

procedure TSOUNDPLAYER_TAG_TEXT.OnMouseClick(Sender: TObject);
var
  viPos_mp3: Integer;
  viPos_ogg: Integer;
begin
  viPos_mp3 := Pos('addon_soundplayer_tag_mp3', extrafe.prog.State);
  viPos_ogg := Pos('addon_soundplayer_tag_opus', extrafe.prog.State);
  if viPos_mp3 <> 0 then
  begin
    if TText(Sender).Name = ('A_SP_Tag_Mp3_ID3v2_Rate_' + TImage(Sender).TagString) then
      uSoundplayer_Tag_MP3.Rating_Select_Stars(TText(Sender).TagString.ToInteger)
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v1_Transfer' then
      uSoundplayer_Tag_MP3.Transfer('to_2')
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Transfer' then
      uSoundplayer_Tag_MP3.Transfer('to_1')
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Covers_Cover_ArrowLeft' then
    begin
      if vSoundplayer.Tag.mp3.ID3v2.Cover_ArrowLeft.TextSettings.FontColor <> TAlphaColorRec.Grey then
        uSoundplayer_Tag_MP3.Cover_Previous;
    end
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Covers_Cover_ArrowRight' then
    begin
      if vSoundplayer.Tag.mp3.ID3v2.Cover_ArrowRight.TextSettings.FontColor <> TAlphaColorRec.Grey then
        uSoundplayer_Tag_MP3.Cover_Next;
    end
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Covers_AddComputer' then
    begin
      // vSoundplayer.scene.OpenDialog.Name := 'A_SP_OpenDialog_Mp3_Cover_AddComputer';
      // vSoundplayer.scene.OpenDialog.Execute;
      uSoundplayer_Tag_MP3_SetAll.SelectCover;
    end
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Covers_Remove' then
    begin
      if vSoundplayer.Tag.mp3.ID3v2.Cover_Remove.TextSettings.FontColor <> TAlphaColorRec.Grey then
        uSoundplayer_Tag_MP3.Cover_Remove
    end
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Lyrics_AddComputer' then
    begin
      vSoundplayer.scene.OpenDialog.Name := 'A_SP_OpenDialog_Mp3_Lyrics_AddComputer';
      vSoundplayer.scene.OpenDialog.Execute;
    end
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Lyrics_AddInternet' then
      uSoundplayer_Tag_MP3_SetAll.Lyrics_Get
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Lyrics_Remove' then
    begin
      if vSoundplayer.Tag.mp3.ID3v2.Lyrics_Remove.TextSettings.FontColor <> TAlphaColorRec.Grey then
        uSoundplayer_Tag_MP3.Lyrics_Delete;
    end;
  end
  else if viPos_ogg <> 0 then
  begin

  end;
end;

procedure TSOUNDPLAYER_TAG_TEXT.OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  viPos_mp3: Integer;
  viPos_ogg: Integer;
begin
  viPos_mp3 := Pos('addon_soundplayer_tag_mp3', extrafe.prog.State);
  viPos_ogg := Pos('addon_soundplayer_tag_opus', extrafe.prog.State);
  if viPos_mp3 <> 0 then
  begin
    if TText(Sender).Name = ('A_SP_Tag_Mp3_ID3v2_Rate_' + TImage(Sender).TagString) then
    begin
      if Button = TMouseButton.mbRight then
        uSoundplayer_Tag_MP3.Rating_RemoveAll_Stars;
    end;
  end
  else if viPos_ogg <> 0 then
  begin

  end;
end;

procedure TSOUNDPLAYER_TAG_TEXT.OnMouseEnter(Sender: TObject);
var
  viPos_mp3: Integer;
  viPos_ogg: Integer;
begin
  viPos_mp3 := Pos('addon_soundplayer_tag_mp3', extrafe.prog.State);
  viPos_ogg := Pos('addon_soundplayer_tag_opus', extrafe.prog.State);
  if viPos_mp3 <> 0 then
  begin
    if (TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Rate_' + TText(Sender).TagString) or
      (TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Rate_Dot_' + TText(Sender).TagString) then
      uSoundplayer_Tag_MP3.Rating_Stars(TText(Sender).TagString.ToInteger, False)
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v1_Transfer' then
      uSnippets.HyperLink_OnMouseOver(Sender)
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Transfer' then
      uSnippets.HyperLink_OnMouseOver(Sender)
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Covers_Cover_ArrowLeft' then
    begin
      if vSoundplayer.Tag.mp3.ID3v2.Cover_ArrowLeft.TextSettings.FontColor <> TAlphaColorRec.Grey then
        vSoundplayer.Tag.mp3.ID3v2.Cover_ArrowLeft_Glow.Enabled := True;
    end
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Covers_Cover_ArrowRight' then
    begin
      if vSoundplayer.Tag.mp3.ID3v2.Cover_ArrowRight.TextSettings.FontColor <> TAlphaColorRec.Grey then
        vSoundplayer.Tag.mp3.ID3v2.Cover_ArrowRight_Glow.Enabled := True;
    end
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Covers_AddComputer' then
      vSoundplayer.Tag.mp3.ID3v2.Cover_Add_Computer_Glow.Enabled := True
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Covers_AddInternet' then
      vSoundplayer.Tag.mp3.ID3v2.Cover_Add_Internet_Glow.Enabled := True
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Covers_Remove' then
    begin
      if vSoundplayer.Tag.mp3.ID3v2.Cover_Remove.TextSettings.FontColor <> TAlphaColorRec.Grey then
        vSoundplayer.Tag.mp3.ID3v2.Cover_Remove_Glow.Enabled := True
    end
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Lyrics_AddComputer' then
      vSoundplayer.Tag.mp3.ID3v2.Lyrics_Add_Computer_Glow.Enabled := True
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Lyrics_AddInternet' then
      vSoundplayer.Tag.mp3.ID3v2.Lyrics_Add_Internet_Glow.Enabled := True
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Lyrics_Remove' then
    begin
      if vSoundplayer.Tag.mp3.ID3v2.Lyrics_Remove.TextSettings.FontColor <> TAlphaColorRec.Grey then
        vSoundplayer.Tag.mp3.ID3v2.Lyrics_Remove_Glow.Enabled := True;
    end;
  end
  else if viPos_ogg <> 0 then
  begin

  end;
end;

procedure TSOUNDPLAYER_TAG_TEXT.OnMouseLeave(Sender: TObject);
var
  viPos_mp3: Integer;
  viPos_ogg: Integer;
begin
  viPos_mp3 := Pos('addon_soundplayer_tag_mp3', extrafe.prog.State);
  viPos_ogg := Pos('addon_soundplayer_tag_opus', extrafe.prog.State);
  if viPos_mp3 <> 0 then
  begin
    if (TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Rate_' + TText(Sender).TagString) or
      (TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Rate_Dot_' + TText(Sender).TagString) then
      uSoundplayer_Tag_MP3.Rating_Stars(soundplayer.player_actions.Tag.mp3.Rating, True)
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v1_Transfer' then
      uSnippets.HyperLink_OnMouseLeave(TText(Sender), TAlphaColorRec.White)
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Transfer' then
      uSnippets.HyperLink_OnMouseLeave(TText(Sender), TAlphaColorRec.White)
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Covers_Cover_ArrowLeft' then
    begin
      if vSoundplayer.Tag.mp3.ID3v2.Cover_ArrowLeft.TextSettings.FontColor <> TAlphaColorRec.Grey then
        vSoundplayer.Tag.mp3.ID3v2.Cover_ArrowLeft_Glow.Enabled := False;
    end
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Covers_Cover_ArrowRight' then
    begin
      if vSoundplayer.Tag.mp3.ID3v2.Cover_ArrowRight.TextSettings.FontColor <> TAlphaColorRec.Grey then
        vSoundplayer.Tag.mp3.ID3v2.Cover_ArrowRight_Glow.Enabled := False;
    end
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Covers_AddComputer' then
      vSoundplayer.Tag.mp3.ID3v2.Cover_Add_Computer_Glow.Enabled := False
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Covers_AddInternet' then
      vSoundplayer.Tag.mp3.ID3v2.Cover_Add_Internet_Glow.Enabled := False
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Covers_Remove' then
    begin
      if vSoundplayer.Tag.mp3.ID3v2.Cover_Remove.TextSettings.FontColor <> TAlphaColorRec.Grey then
        vSoundplayer.Tag.mp3.ID3v2.Cover_Remove_Glow.Enabled := False
    end
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Lyrics_AddComputer' then
      vSoundplayer.Tag.mp3.ID3v2.Lyrics_Add_Computer_Glow.Enabled := False
    else if TText(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Lyrics_AddInternet' then
      vSoundplayer.Tag.mp3.ID3v2.Lyrics_Add_Internet_Glow.Enabled := False
    else if TImage(Sender).Name = 'A_SP_Tag_Mp3_ID3v2_Lyrics_Remove' then
    begin
      if vSoundplayer.Tag.mp3.ID3v2.Lyrics_Remove.TextSettings.FontColor <> TAlphaColorRec.Grey then
        vSoundplayer.Tag.mp3.ID3v2.Lyrics_Remove_Glow.Enabled := False;
    end;
  end
  else if viPos_ogg <> 0 then
  begin

  end;
end;

{ TSOUNDPLAYER_TAG_RADIOBUTTON }

procedure TSOUNDPLAYER_TAG_RADIOBUTTON.OnMouseClick(Sender: TObject);
var
  viPos_mp3: Integer;
  viPos_ogg: Integer;
begin
  viPos_mp3 := Pos('addon_soundplayer_tag_mp3', extrafe.prog.State);
  viPos_ogg := Pos('addon_soundplayer_tag_opus', extrafe.prog.State);
  if viPos_mp3 <> 0 then
  begin
    if TRadioButton(Sender).Name = 'A_SP_Tag_Mp3_LyricsAdd_Main_Radio_Above' then
      vSoundplayer.Tag.mp3.Lyrics_Add.Add.Enabled := True
    else if TRadioButton(Sender).Name = 'A_SP_Tag_Mp3_LyricsAdd_Main_Radio_Clear' then
      vSoundplayer.Tag.mp3.Lyrics_Add.Add.Enabled := True;
  end
  else if viPos_ogg <> 0 then
  begin

  end;
end;

initialization

addons.soundplayer.Input.mouse_tag.Image := TSOUNDPLAYER_TAG_IMAGE.Create;
addons.soundplayer.Input.mouse_tag.Button := TSOUNDPLAYER_TAG_BUTTON.Create;
addons.soundplayer.Input.mouse_tag.Text := TSOUNDPLAYER_TAG_TEXT.Create;
addons.soundplayer.Input.mouse_tag.Radio := TSOUNDPLAYER_TAG_RADIOBUTTON.Create;

finalization

addons.soundplayer.Input.mouse_tag.Image.Free;
addons.soundplayer.Input.mouse_tag.Button.Free;
addons.soundplayer.Input.mouse_tag.Text.Free;
addons.soundplayer.Input.mouse_tag.Radio.Free;

end.
