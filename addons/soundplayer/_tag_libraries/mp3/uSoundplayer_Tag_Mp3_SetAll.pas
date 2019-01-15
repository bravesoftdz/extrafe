unit uSoundplayer_Tag_Mp3_SetAll;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UITypes,
  FMX.Objects,
  FMX.Dialogs,
  FMX.Grid,
  FMX.Effects,
  FMX.StdCtrls,
  FMX.Types,
  FMX.Ani,
  FMX.Filter.Effects,
  FMX.TabControl,
  FMX.Edit,
  FMX.ComboEdit,
  FMX.Memo,
  FMX.Listbox,
  FMX.Graphics;

procedure uSoundplayer_TagSet_Mp3;
procedure uSoundplayer_TagSet_Mp3_SelectCover;
procedure uSoundplayer_TagSet_Mp3_ShowCoverLabel(vShow: Boolean);
procedure uSoundplayer_TagSet_Mp3_ShowLyrics_AddDialog;
procedure uSoundplayer_TagSet_Mp3_Free;

implementation

uses
  uLoad,
  uSnippet_Text,
  uLoad_AllTypes,
  uMain_SetAll,
  uSoundplayer_SetAll,
  uSoundplayer_AllTypes,
  uSoundplayer_Player_Actions,
  uSoundplayer_Mouse;

procedure uSoundplayer_TagSet_Mp3;
var
  vi: Integer;
begin
  extrafe.prog.State := 'addon_soundplayer_tag_mp3';

  vSoundplayer.tag.mp3.Back := TPanel.Create(vSoundplayer.scene.Soundplayer);
  vSoundplayer.tag.mp3.Back.Name := 'A_SP_Tag_Mp3';
  vSoundplayer.tag.mp3.Back.Parent := vSoundplayer.scene.Soundplayer;
  vSoundplayer.tag.mp3.Back.SetBounds((vSoundplayer.scene.Back.Width / 2) - 500,
    (vSoundplayer.scene.Back.Height / 2) - 250, 1000, 500);
  vSoundplayer.tag.mp3.Back.Visible := True;

  vSoundplayer.tag.mp3.Back_Blur := TGaussianBlurEffect.Create(vSoundplayer.tag.mp3.Back);
  vSoundplayer.tag.mp3.Back_Blur.Name := 'A_SP_Back_Blur';
  vSoundplayer.tag.mp3.Back_Blur.Parent := vSoundplayer.tag.mp3.Back;
  vSoundplayer.tag.mp3.Back_Blur.BlurAmount := 0.5;
  vSoundplayer.tag.mp3.Back_Blur.Enabled := False;

  vSoundplayer.tag.mp3.Logo := TImage.Create(vSoundplayer.tag.mp3.Back);
  vSoundplayer.tag.mp3.Logo.Name := 'A_SP_Tag_Mp3_Logo';
  vSoundplayer.tag.mp3.Logo.Parent := vSoundplayer.tag.mp3.Back;
  vSoundplayer.tag.mp3.Logo.SetBounds(vSoundplayer.tag.mp3.Back.Width - 60, 10, 50, 50);
  vSoundplayer.tag.mp3.Logo.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images + 'sp_tag_mp3.png');
  vSoundplayer.tag.mp3.Logo.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.Logo.Visible := True;

  vSoundplayer.tag.mp3.TabControl := TTabControl.Create(vSoundplayer.tag.mp3.Back);
  vSoundplayer.tag.mp3.TabControl.Name := 'A_SP_Tag_Mp3_TabControl';
  vSoundplayer.tag.mp3.TabControl.Parent := vSoundplayer.tag.mp3.Back;
  vSoundplayer.tag.mp3.TabControl.SetBounds(10, 60, vSoundplayer.tag.mp3.Back.Width - 20,
    vSoundplayer.tag.mp3.Back.Height - 100);
  vSoundplayer.tag.mp3.TabControl.Visible := True;

  for vi := 0 to 1 do
  begin
    vSoundplayer.tag.mp3.TabItem[vi] := TTabItem.Create(vSoundplayer.tag.mp3.TabControl);
    vSoundplayer.tag.mp3.TabItem[vi].Name := 'A_SP_Tag_Mp3_TabItem_' + IntToStr(vi);
    vSoundplayer.tag.mp3.TabItem[vi].Parent := vSoundplayer.tag.mp3.TabControl;
    vSoundplayer.tag.mp3.TabItem[vi].Text := 'ID3v' + IntToStr(vi + 1);
    vSoundplayer.tag.mp3.TabItem[vi].Width := vSoundplayer.tag.mp3.TabControl.Width;
    vSoundplayer.tag.mp3.TabItem[vi].Height := vSoundplayer.tag.mp3.TabControl.Height;
    vSoundplayer.tag.mp3.TabItem[vi].Visible := True;
  end;
  // ID3v1
  vSoundplayer.tag.mp3.ID3v1.Title := TLabel.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Title.Name := 'A_SP_Tag_Mp3_ID3v1_Title';
  vSoundplayer.tag.mp3.ID3v1.Title.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Title.SetBounds(10, 30, 100, 24);
  vSoundplayer.tag.mp3.ID3v1.Title.Text := 'Song Name : ';
  vSoundplayer.tag.mp3.ID3v1.Title.Font.Style := vSoundplayer.tag.mp3.ID3v1.Title.Font.Style +
    [TFontStyle.fsBold];
  vSoundplayer.tag.mp3.ID3v1.Title.Visible := True;

  vSoundplayer.tag.mp3.ID3v1.Title_V := TEdit.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Title_V.Name := 'A_SP_Tag_Mp3_ID3v1_Title_V';
  vSoundplayer.tag.mp3.ID3v1.Title_V.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Title_V.SetBounds(100, 30, 260, 24);
  vSoundplayer.tag.mp3.ID3v1.Title_V.Text := '';
  vSoundplayer.tag.mp3.ID3v1.Title_V.Visible := True;

  vSoundplayer.tag.mp3.ID3v1.Title_Differ := TImage.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Title_Differ.Name := 'A_SP_Tag_Mp3_ID3v1_Title_Differ';
  vSoundplayer.tag.mp3.ID3v1.Title_Differ.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Title_Differ.SetBounds(336, 30, 24, 24);
  vSoundplayer.tag.mp3.ID3v1.Title_Differ.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_different.png');
  vSoundplayer.tag.mp3.ID3v1.Title_Differ.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v1.Title_Differ.Visible := False;

  vSoundplayer.tag.mp3.ID3v1.Artist := TLabel.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Artist.Name := 'A_SP_Tag_Mp3_ID3v1_Artist';
  vSoundplayer.tag.mp3.ID3v1.Artist.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Artist.SetBounds(10, 60, 100, 24);
  vSoundplayer.tag.mp3.ID3v1.Artist.Text := 'Artist Name : ';
  vSoundplayer.tag.mp3.ID3v1.Artist.Font.Style := vSoundplayer.tag.mp3.ID3v1.Artist.Font.Style +
    [TFontStyle.fsBold];
  vSoundplayer.tag.mp3.ID3v1.Artist.Visible := True;

  vSoundplayer.tag.mp3.ID3v1.Artist_V := TEdit.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Artist_V.Name := 'A_SP_Tag_Mp3_ID3v1_Artist_V';
  vSoundplayer.tag.mp3.ID3v1.Artist_V.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Artist_V.SetBounds(100, 60, 260, 24);
  vSoundplayer.tag.mp3.ID3v1.Artist_V.Text := '';
  vSoundplayer.tag.mp3.ID3v1.Artist_V.Visible := True;

  vSoundplayer.tag.mp3.ID3v1.Artist_Differ := TImage.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Artist_Differ.Name := 'A_SP_Tag_Mp3_ID3v1_Artist_Differ';
  vSoundplayer.tag.mp3.ID3v1.Artist_Differ.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Artist_Differ.SetBounds(336, 60, 24, 24);
  vSoundplayer.tag.mp3.ID3v1.Artist_Differ.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_different.png');
  vSoundplayer.tag.mp3.ID3v1.Artist_Differ.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v1.Artist_Differ.Visible := False;

  vSoundplayer.tag.mp3.ID3v1.Album := TLabel.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Album.Name := 'A_SP_Tag_Mp3_ID3v1_Album';
  vSoundplayer.tag.mp3.ID3v1.Album.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Album.SetBounds(10, 90, 100, 24);
  vSoundplayer.tag.mp3.ID3v1.Album.Text := 'Album Title : ';
  vSoundplayer.tag.mp3.ID3v1.Album.Font.Style := vSoundplayer.tag.mp3.ID3v1.Album.Font.Style +
    [TFontStyle.fsBold];
  vSoundplayer.tag.mp3.ID3v1.Album.Visible := True;

  vSoundplayer.tag.mp3.ID3v1.Album_V := TEdit.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Album_V.Name := 'A_SP_Tag_Mp3_ID3v1_Album_V';
  vSoundplayer.tag.mp3.ID3v1.Album_V.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Album_V.SetBounds(100, 90, 260, 24);
  vSoundplayer.tag.mp3.ID3v1.Album_V.Text := '';
  vSoundplayer.tag.mp3.ID3v1.Album_V.Visible := True;

  vSoundplayer.tag.mp3.ID3v1.Album_Differ := TImage.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Album_Differ.Name := 'A_SP_Tag_Mp3_ID3v1_Album_Differ';
  vSoundplayer.tag.mp3.ID3v1.Album_Differ.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Album_Differ.SetBounds(336, 90, 24, 24);
  vSoundplayer.tag.mp3.ID3v1.Album_Differ.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_different.png');
  vSoundplayer.tag.mp3.ID3v1.Album_Differ.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v1.Album_Differ.Visible := False;

  vSoundplayer.tag.mp3.ID3v1.Year := TLabel.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Year.Name := 'A_SP_Tag_Mp3_ID3v1_Year';
  vSoundplayer.tag.mp3.ID3v1.Year.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Year.SetBounds(10, 120, 100, 24);
  vSoundplayer.tag.mp3.ID3v1.Year.Text := 'Year Published : ';
  vSoundplayer.tag.mp3.ID3v1.Year.Font.Style := vSoundplayer.tag.mp3.ID3v1.Year.Font.Style +
    [TFontStyle.fsBold];
  vSoundplayer.tag.mp3.ID3v1.Year.Visible := True;

  vSoundplayer.tag.mp3.ID3v1.Year_V := TEdit.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Year_V.Name := 'A_SP_Tag_Mp3_ID3v1_Year_V';
  vSoundplayer.tag.mp3.ID3v1.Year_V.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Year_V.SetBounds(100, 120, 260, 24);
  vSoundplayer.tag.mp3.ID3v1.Year_V.Text := '';
  vSoundplayer.tag.mp3.ID3v1.Year_V.Visible := True;

  vSoundplayer.tag.mp3.ID3v1.Year_Differ := TImage.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Year_Differ.Name := 'A_SP_Tag_Mp3_ID3v1_Year_Differ';
  vSoundplayer.tag.mp3.ID3v1.Year_Differ.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Year_Differ.SetBounds(336, 120, 24, 24);
  vSoundplayer.tag.mp3.ID3v1.Year_Differ.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_different.png');
  vSoundplayer.tag.mp3.ID3v1.Year_Differ.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v1.Year_Differ.Visible := False;

  vSoundplayer.tag.mp3.ID3v1.Genre := TLabel.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Genre.Name := 'A_SP_Tag_Mp3_ID3v1_Genre';
  vSoundplayer.tag.mp3.ID3v1.Genre.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Genre.SetBounds(10, 150, 100, 24);
  vSoundplayer.tag.mp3.ID3v1.Genre.Text := 'Genre Type : ';
  vSoundplayer.tag.mp3.ID3v1.Genre.Font.Style := vSoundplayer.tag.mp3.ID3v1.Genre.Font.Style +
    [TFontStyle.fsBold];
  vSoundplayer.tag.mp3.ID3v1.Genre.Visible := True;

  vSoundplayer.tag.mp3.ID3v1.Genre_V := TComboEdit.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Genre_V.Name := 'A_SP_Tag_Mp3_ID3v1_Genre_V';
  vSoundplayer.tag.mp3.ID3v1.Genre_V.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Genre_V.SetBounds(100, 150, 260, 24);
  vSoundplayer.tag.mp3.ID3v1.Genre_V.Items.LoadFromFile(addons.Soundplayer.Path.Files + 'sp_genre_tags.txt');
  vSoundplayer.tag.mp3.ID3v1.Genre_V.Text := '';
  vSoundplayer.tag.mp3.ID3v1.Genre_V.Visible := True;

  vSoundplayer.tag.mp3.ID3v1.Genre_Differ := TImage.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Genre_Differ.Name := 'A_SP_Tag_Mp3_ID3v1_Genre_Differ';
  vSoundplayer.tag.mp3.ID3v1.Genre_Differ.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Genre_Differ.SetBounds(318, 150, 24, 24);
  vSoundplayer.tag.mp3.ID3v1.Genre_Differ.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_different.png');
  vSoundplayer.tag.mp3.ID3v1.Genre_Differ.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v1.Genre_Differ.Visible := False;

  vSoundplayer.tag.mp3.ID3v1.Track := TLabel.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Track.Name := 'A_SP_Tag_Mp3_ID3v1_Track';
  vSoundplayer.tag.mp3.ID3v1.Track.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Track.SetBounds(10, 180, 100, 24);
  vSoundplayer.tag.mp3.ID3v1.Track.Text := 'Track Number : ';
  vSoundplayer.tag.mp3.ID3v1.Track.Font.Style := vSoundplayer.tag.mp3.ID3v1.Track.Font.Style +
    [TFontStyle.fsBold];
  vSoundplayer.tag.mp3.ID3v1.Track.Visible := True;

  vSoundplayer.tag.mp3.ID3v1.Track_V := TEdit.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Track_V.Name := 'A_SP_Tag_Mp3_ID3v1_Track_V';
  vSoundplayer.tag.mp3.ID3v1.Track_V.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Track_V.SetBounds(100, 180, 260, 24);
  vSoundplayer.tag.mp3.ID3v1.Track_V.Text := '';
  vSoundplayer.tag.mp3.ID3v1.Track_V.Visible := True;

  vSoundplayer.tag.mp3.ID3v1.Track_Differ := TImage.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Track_Differ.Name := 'A_SP_Tag_Mp3_ID3v1_Track_Differ';
  vSoundplayer.tag.mp3.ID3v1.Track_Differ.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Track_Differ.SetBounds(336, 180, 24, 24);
  vSoundplayer.tag.mp3.ID3v1.Track_Differ.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_different.png');
  vSoundplayer.tag.mp3.ID3v1.Track_Differ.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v1.Track_Differ.Visible := False;

  vSoundplayer.tag.mp3.ID3v1.Comment := TLabel.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Comment.Name := 'A_SP_Tag_Mp3_ID3v1_Comments';
  vSoundplayer.tag.mp3.ID3v1.Comment.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Comment.SetBounds(10, 210, 100, 24);
  vSoundplayer.tag.mp3.ID3v1.Comment.Text := 'Comments : ';
  vSoundplayer.tag.mp3.ID3v1.Comment.Font.Style := vSoundplayer.tag.mp3.ID3v1.Comment.Font.Style +
    [TFontStyle.fsBold];
  vSoundplayer.tag.mp3.ID3v1.Comment.Visible := True;

  vSoundplayer.tag.mp3.ID3v1.Comment_V := TEdit.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Comment_V.Name := 'A_SP_Tag_Mp3_ID3v1_Comments_V';
  vSoundplayer.tag.mp3.ID3v1.Comment_V.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Comment_V.SetBounds(100, 210, 260, 24);
  vSoundplayer.tag.mp3.ID3v1.Comment_V.Text := '';
  vSoundplayer.tag.mp3.ID3v1.Comment_V.Visible := True;

  vSoundplayer.tag.mp3.ID3v1.Comment_Differ := TImage.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Comment_Differ.Name := 'A_SP_Tag_Mp3_ID3v1_Comment_Differ';
  vSoundplayer.tag.mp3.ID3v1.Comment_Differ.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Comment_Differ.SetBounds(336, 210, 24, 24);
  vSoundplayer.tag.mp3.ID3v1.Comment_Differ.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_different.png');
  vSoundplayer.tag.mp3.ID3v1.Comment_Differ.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v1.Comment_Differ.Visible := False;

  vSoundplayer.tag.mp3.ID3v1.Transfer := TText.Create(vSoundplayer.tag.mp3.TabItem[0]);
  vSoundplayer.tag.mp3.ID3v1.Transfer.Name := 'A_SP_Tag_Mp3_ID3v1_Transfer';
  vSoundplayer.tag.mp3.ID3v1.Transfer.Parent := vSoundplayer.tag.mp3.TabItem[0];
  vSoundplayer.tag.mp3.ID3v1.Transfer.SetBounds(200, 240, 160, 24);
  vSoundplayer.tag.mp3.ID3v1.Transfer.Text := 'Tranfer data to ID3v2';
  vSoundplayer.tag.mp3.ID3v1.Transfer.Font.Style := vSoundplayer.tag.mp3.ID3v1.Transfer.Font.Style +
    [TFontStyle.fsBold];
  vSoundplayer.tag.mp3.ID3v1.Transfer.TextSettings.FontColor := TAlphaColorRec.White;
  vSoundplayer.tag.mp3.ID3v1.Transfer.TextSettings.HorzAlign := TTextAlign.Trailing;
  vSoundplayer.tag.mp3.ID3v1.Transfer.OnClick := addons.Soundplayer.Input.mouse.Text.OnMouseClick;
  vSoundplayer.tag.mp3.ID3v1.Transfer.OnMouseEnter := addons.Soundplayer.Input.mouse.Text.OnMouseEnter;
  vSoundplayer.tag.mp3.ID3v1.Transfer.OnMouseLeave := addons.Soundplayer.Input.mouse.Text.OnMouseLeave;
  vSoundplayer.tag.mp3.ID3v1.Transfer.Visible := True;
  // ID3v2
  vSoundplayer.tag.mp3.ID3v2.Title := TLabel.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Title.Name := 'A_SP_Tag_Mp3_ID3v2_Title';
  vSoundplayer.tag.mp3.ID3v2.Title.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Title.SetBounds(10, 30, 100, 24);
  vSoundplayer.tag.mp3.ID3v2.Title.Text := 'Song Name : ';
  vSoundplayer.tag.mp3.ID3v2.Title.Font.Style := vSoundplayer.tag.mp3.ID3v2.Title.Font.Style +
    [TFontStyle.fsBold];
  vSoundplayer.tag.mp3.ID3v2.Title.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Title_V := TEdit.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Title_V.Name := 'A_SP_Tag_Mp3_ID3v2_Title_V';
  vSoundplayer.tag.mp3.ID3v2.Title_V.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Title_V.SetBounds(100, 30, 260, 24);
  vSoundplayer.tag.mp3.ID3v2.Title_V.Text := '';
  vSoundplayer.tag.mp3.ID3v2.Title_V.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Title_Differ := TImage.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Title_Differ.Name := 'A_SP_Tag_Mp3_ID3v2_Title_Differ';
  vSoundplayer.tag.mp3.ID3v2.Title_Differ.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Title_Differ.SetBounds(336, 30, 24, 24);
  vSoundplayer.tag.mp3.ID3v2.Title_Differ.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_different.png');
  vSoundplayer.tag.mp3.ID3v2.Title_Differ.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v2.Title_Differ.Visible := False;

  vSoundplayer.tag.mp3.ID3v2.Artist := TLabel.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Artist.Name := 'A_SP_Tag_Mp3_ID3v2_Artist';
  vSoundplayer.tag.mp3.ID3v2.Artist.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Artist.SetBounds(10, 60, 100, 24);
  vSoundplayer.tag.mp3.ID3v2.Artist.Text := 'Artist Name : ';
  vSoundplayer.tag.mp3.ID3v2.Artist.Font.Style := vSoundplayer.tag.mp3.ID3v2.Artist.Font.Style +
    [TFontStyle.fsBold];
  vSoundplayer.tag.mp3.ID3v2.Artist.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Artist_V := TEdit.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Artist_V.Name := 'A_SP_Tag_Mp3_ID3v2_Artist_V';
  vSoundplayer.tag.mp3.ID3v2.Artist_V.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Artist_V.SetBounds(100, 60, 260, 24);
  vSoundplayer.tag.mp3.ID3v2.Artist_V.Text := '';
  vSoundplayer.tag.mp3.ID3v2.Artist_V.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Artist_Differ := TImage.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Artist_Differ.Name := 'A_SP_Tag_Mp3_ID3v2_Artist_Differ';
  vSoundplayer.tag.mp3.ID3v2.Artist_Differ.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Artist_Differ.SetBounds(336, 60, 24, 24);
  vSoundplayer.tag.mp3.ID3v2.Artist_Differ.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_different.png');
  vSoundplayer.tag.mp3.ID3v2.Artist_Differ.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v2.Artist_Differ.Visible := False;

  vSoundplayer.tag.mp3.ID3v2.Album := TLabel.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Album.Name := 'A_SP_Tag_Mp3_ID3v2_Album';
  vSoundplayer.tag.mp3.ID3v2.Album.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Album.SetBounds(10, 90, 100, 24);
  vSoundplayer.tag.mp3.ID3v2.Album.Text := 'Album Title : ';
  vSoundplayer.tag.mp3.ID3v2.Album.Font.Style := vSoundplayer.tag.mp3.ID3v2.Album.Font.Style +
    [TFontStyle.fsBold];
  vSoundplayer.tag.mp3.ID3v2.Album.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Album_V := TEdit.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Album_V.Name := 'A_SP_Tag_Mp3_ID3v2_Album_V';
  vSoundplayer.tag.mp3.ID3v2.Album_V.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Album_V.SetBounds(100, 90, 260, 24);
  vSoundplayer.tag.mp3.ID3v2.Album_V.Text := '';
  vSoundplayer.tag.mp3.ID3v2.Album_V.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Album_Differ := TImage.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Album_Differ.Name := 'A_SP_Tag_Mp3_ID3v2_Album_Differ';
  vSoundplayer.tag.mp3.ID3v2.Album_Differ.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Album_Differ.SetBounds(336, 90, 24, 24);
  vSoundplayer.tag.mp3.ID3v2.Album_Differ.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_different.png');
  vSoundplayer.tag.mp3.ID3v2.Album_Differ.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v2.Album_Differ.Visible := False;

  vSoundplayer.tag.mp3.ID3v2.Year := TLabel.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Year.Name := 'A_SP_Tag_Mp3_ID3v2_Year';
  vSoundplayer.tag.mp3.ID3v2.Year.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Year.SetBounds(10, 120, 100, 24);
  vSoundplayer.tag.mp3.ID3v2.Year.Text := 'Year Published : ';
  vSoundplayer.tag.mp3.ID3v2.Year.Font.Style := vSoundplayer.tag.mp3.ID3v2.Year.Font.Style +
    [TFontStyle.fsBold];
  vSoundplayer.tag.mp3.ID3v2.Year.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Year_V := TEdit.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Year_V.Name := 'A_SP_Tag_Mp3_ID3v2_Year_V';
  vSoundplayer.tag.mp3.ID3v2.Year_V.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Year_V.SetBounds(100, 120, 260, 24);
  vSoundplayer.tag.mp3.ID3v2.Year_V.Text := '';
  vSoundplayer.tag.mp3.ID3v2.Year_V.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Year_Differ := TImage.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Year_Differ.Name := 'A_SP_Tag_Mp3_ID3v2_Year_Differ';
  vSoundplayer.tag.mp3.ID3v2.Year_Differ.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Year_Differ.SetBounds(336, 120, 24, 24);
  vSoundplayer.tag.mp3.ID3v2.Year_Differ.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_different.png');
  vSoundplayer.tag.mp3.ID3v2.Year_Differ.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v2.Year_Differ.Visible := False;

  vSoundplayer.tag.mp3.ID3v2.Genre := TLabel.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Genre.Name := 'A_SP_Tag_Mp3_ID3v2_Genre';
  vSoundplayer.tag.mp3.ID3v2.Genre.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Genre.SetBounds(10, 150, 100, 24);
  vSoundplayer.tag.mp3.ID3v2.Genre.Text := 'Genre Type : ';
  vSoundplayer.tag.mp3.ID3v2.Genre.Font.Style := vSoundplayer.tag.mp3.ID3v2.Genre.Font.Style +
    [TFontStyle.fsBold];
  vSoundplayer.tag.mp3.ID3v2.Genre.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Genre_V := TComboEdit.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Genre_V.Name := 'A_SP_Tag_Mp3_ID3v2_Genre_V';
  vSoundplayer.tag.mp3.ID3v2.Genre_V.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Genre_V.SetBounds(100, 150, 260, 24);
  vSoundplayer.tag.mp3.ID3v2.Genre_V.Items.LoadFromFile(addons.Soundplayer.Path.Files + 'sp_genre_tags.txt');
  vSoundplayer.tag.mp3.ID3v2.Genre_V.Text := '';
  vSoundplayer.tag.mp3.ID3v2.Genre_V.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Genre_Differ := TImage.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Genre_Differ.Name := 'A_SP_Tag_Mp3_ID3v2_Genre_Differ';
  vSoundplayer.tag.mp3.ID3v2.Genre_Differ.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Genre_Differ.SetBounds(318, 150, 24, 24);
  vSoundplayer.tag.mp3.ID3v2.Genre_Differ.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_different.png');
  vSoundplayer.tag.mp3.ID3v2.Genre_Differ.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v2.Genre_Differ.Visible := False;

  vSoundplayer.tag.mp3.ID3v2.Track := TLabel.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Track.Name := 'A_SP_Tag_Mp3_ID3v2_Track';
  vSoundplayer.tag.mp3.ID3v2.Track.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Track.SetBounds(10, 180, 100, 24);
  vSoundplayer.tag.mp3.ID3v2.Track.Text := 'Track Number : ';
  vSoundplayer.tag.mp3.ID3v2.Track.Font.Style := vSoundplayer.tag.mp3.ID3v2.Track.Font.Style +
    [TFontStyle.fsBold];
  vSoundplayer.tag.mp3.ID3v2.Track.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Track_V := TEdit.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Track_V.Name := 'A_SP_Tag_Mp3_ID3v2_Track_V';
  vSoundplayer.tag.mp3.ID3v2.Track_V.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Track_V.SetBounds(100, 180, 260, 24);
  vSoundplayer.tag.mp3.ID3v2.Track_V.Text := '';
  vSoundplayer.tag.mp3.ID3v2.Track_V.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Track_Differ := TImage.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Track_Differ.Name := 'A_SP_Tag_Mp3_ID3v2_Track_Differ';
  vSoundplayer.tag.mp3.ID3v2.Track_Differ.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Track_Differ.SetBounds(336, 180, 24, 24);
  vSoundplayer.tag.mp3.ID3v2.Track_Differ.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_different.png');
  vSoundplayer.tag.mp3.ID3v2.Track_Differ.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v2.Track_Differ.Visible := False;

  vSoundplayer.tag.mp3.ID3v2.Comment := TLabel.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Comment.Name := 'A_SP_Tag_Mp3_ID3v2_Comments';
  vSoundplayer.tag.mp3.ID3v2.Comment.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Comment.SetBounds(10, 210, 100, 24);
  vSoundplayer.tag.mp3.ID3v2.Comment.Text := 'Comments : ';
  vSoundplayer.tag.mp3.ID3v2.Comment.Font.Style := vSoundplayer.tag.mp3.ID3v2.Comment.Font.Style +
    [TFontStyle.fsBold];
  vSoundplayer.tag.mp3.ID3v2.Comment.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Comment_V := TEdit.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Comment_V.Name := 'A_SP_Tag_Mp3_ID3v2_Comments_V';
  vSoundplayer.tag.mp3.ID3v2.Comment_V.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Comment_V.SetBounds(100, 210, 260, 24);
  vSoundplayer.tag.mp3.ID3v2.Comment_V.Text := '';
  vSoundplayer.tag.mp3.ID3v2.Comment_V.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Comment_Differ := TImage.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Comment_Differ.Name := 'A_SP_Tag_Mp3_ID3v2_Comment_Differ';
  vSoundplayer.tag.mp3.ID3v2.Comment_Differ.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Comment_Differ.SetBounds(336, 210, 24, 24);
  vSoundplayer.tag.mp3.ID3v2.Comment_Differ.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_different.png');
  vSoundplayer.tag.mp3.ID3v2.Comment_Differ.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v2.Comment_Differ.Visible := False;

  vSoundplayer.tag.mp3.ID3v2.Rate_Label := TLabel.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Rate_Label.Name := 'A_SP_Tag_Mp3_ID3v2_Rate_Label';
  vSoundplayer.tag.mp3.ID3v2.Rate_Label.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Rate_Label.SetBounds(10, 240, 100, 24);
  vSoundplayer.tag.mp3.ID3v2.Rate_Label.Text := 'Rating : ';
  vSoundplayer.tag.mp3.ID3v2.Rate_Label.Font.Style := vSoundplayer.tag.mp3.ID3v2.Rate_Label.Font.Style +
    [TFontStyle.fsBold];
  vSoundplayer.tag.mp3.ID3v2.Rate_Label.Visible := True;

  for vi := 0 to 4 do
  begin
    vSoundplayer.tag.mp3.ID3v2.Rate[vi] := TImage.Create(vSoundplayer.tag.mp3.TabItem[1]);
    vSoundplayer.tag.mp3.ID3v2.Rate[vi].Name := 'A_SP_Tag_Mp3_ID3v2_Rate_' + vi.ToString;
    vSoundplayer.tag.mp3.ID3v2.Rate[vi].Parent := vSoundplayer.tag.mp3.TabItem[1];
    vSoundplayer.tag.mp3.ID3v2.Rate[vi].SetBounds(100 + (28 * vi), 240, 24, 24);
    vSoundplayer.tag.mp3.ID3v2.Rate[vi].Bitmap.LoadFromFile(addons.Soundplayer.Path.Images + 'sp_star.png');
    vSoundplayer.tag.mp3.ID3v2.Rate[vi].OnClick := addons.Soundplayer.Input.mouse_tag.Image.OnMouseClick;
    vSoundplayer.tag.mp3.ID3v2.Rate[vi].OnMouseEnter := addons.Soundplayer.Input.mouse_tag.Image.OnMouseEnter;
    vSoundplayer.tag.mp3.ID3v2.Rate[vi].OnMouseLeave := addons.Soundplayer.Input.mouse_tag.Image.OnMouseLeave;
    vSoundplayer.tag.mp3.ID3v2.Rate[vi].OnMouseDown := addons.Soundplayer.Input.mouse_tag.Image.OnMouseDown;
    vSoundplayer.tag.mp3.ID3v2.Rate[vi].Visible := True;

    vSoundplayer.tag.mp3.ID3v2.Rate_Glow[vi] := TGlowEffect.Create(vSoundplayer.tag.mp3.ID3v2.Rate[vi]);
    vSoundplayer.tag.mp3.ID3v2.Rate_Glow[vi].Name := 'A_SP_Tag_Mp3_ID3v2_Rate_Glow_' + vi.ToString;
    vSoundplayer.tag.mp3.ID3v2.Rate_Glow[vi].Parent := vSoundplayer.tag.mp3.ID3v2.Rate[vi];
    vSoundplayer.tag.mp3.ID3v2.Rate_Glow[vi].Softness := 0.4;
    vSoundplayer.tag.mp3.ID3v2.Rate_Glow[vi].GlowColor := TAlphaColorRec.Deepskyblue;
    vSoundplayer.tag.mp3.ID3v2.Rate_Glow[vi].Opacity := 0.9;
    vSoundplayer.tag.mp3.ID3v2.Rate_Glow[vi].Enabled := False;

    vSoundplayer.tag.mp3.ID3v2.Rate_Dot[vi] := TCircle.Create(vSoundplayer.tag.mp3.TabItem[1]);
    vSoundplayer.tag.mp3.ID3v2.Rate_Dot[vi].Name := 'A_SP_Tag_Mp3_ID3v2_Rate_Dot_' + vi.ToString;
    vSoundplayer.tag.mp3.ID3v2.Rate_Dot[vi].Parent := vSoundplayer.tag.mp3.TabItem[1];
    vSoundplayer.tag.mp3.ID3v2.Rate_Dot[vi].SetBounds(109 + (28 * vi), 249, 6, 6);
    vSoundplayer.tag.mp3.ID3v2.Rate_Dot[vi].Fill.Bitmap.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
      'sp_back.png');
    vSoundplayer.tag.mp3.ID3v2.Rate_Dot[vi].Fill.Kind := TBrushKind.Bitmap;
    vSoundplayer.tag.mp3.ID3v2.Rate_Dot[vi].Fill.Bitmap.WrapMode := TWrapMode.Tile;
    vSoundplayer.tag.mp3.ID3v2.Rate_Dot[vi].Stroke.Thickness := 0;
    vSoundplayer.tag.mp3.ID3v2.Rate_Dot[vi].OnClick := addons.Soundplayer.Input.mouse_tag.Circle.OnMouseClick;
    vSoundplayer.tag.mp3.ID3v2.Rate_Dot[vi].OnMouseEnter :=
      addons.Soundplayer.Input.mouse_tag.Circle.OnMouseEnter;
    vSoundplayer.tag.mp3.ID3v2.Rate_Dot[vi].OnMouseLeave :=
      addons.Soundplayer.Input.mouse_tag.Circle.OnMouseLeave;
    vSoundplayer.tag.mp3.ID3v2.Rate_Dot[vi].Visible := True;
  end;

  vSoundplayer.tag.mp3.ID3v2.Transfer := TText.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Transfer.Name := 'A_SP_Tag_Mp3_ID3v2_Transfer';
  vSoundplayer.tag.mp3.ID3v2.Transfer.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Transfer.SetBounds(200, 350, 160, 24);
  vSoundplayer.tag.mp3.ID3v2.Transfer.Text := 'Tranfer data to ID3v1';
  vSoundplayer.tag.mp3.ID3v2.Transfer.Font.Style := vSoundplayer.tag.mp3.ID3v2.Transfer.Font.Style +
    [TFontStyle.fsBold];
  vSoundplayer.tag.mp3.ID3v2.Transfer.TextSettings.FontColor := TAlphaColorRec.White;
  vSoundplayer.tag.mp3.ID3v2.Transfer.TextSettings.HorzAlign := TTextAlign.Trailing;
  vSoundplayer.tag.mp3.ID3v2.Transfer.OnClick := addons.Soundplayer.Input.mouse.Text.OnMouseClick;
  vSoundplayer.tag.mp3.ID3v2.Transfer.OnMouseEnter := addons.Soundplayer.Input.mouse.Text.OnMouseEnter;
  vSoundplayer.tag.mp3.ID3v2.Transfer.OnMouseLeave := addons.Soundplayer.Input.mouse.Text.OnMouseLeave;
  vSoundplayer.tag.mp3.ID3v2.Transfer.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Covers := TGroupBox.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Covers.Name := 'A_SP_Tag_Mp3_ID3v2_Covers_Groupbox';
  vSoundplayer.tag.mp3.ID3v2.Covers.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Covers.SetBounds(380, 20, 280, vSoundplayer.tag.mp3.TabControl.Height - 50);
  vSoundplayer.tag.mp3.ID3v2.Covers.Text := 'Covers';
  vSoundplayer.tag.mp3.ID3v2.Covers.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Cover := TImage.Create(vSoundplayer.tag.mp3.ID3v2.Covers);
  vSoundplayer.tag.mp3.ID3v2.Cover.Name := 'A_SP_Tag_Mp3_ID3v2_Covers_Cover';
  vSoundplayer.tag.mp3.ID3v2.Cover.Parent := vSoundplayer.tag.mp3.ID3v2.Covers;
  vSoundplayer.tag.mp3.ID3v2.Cover.SetBounds(10, 30, 260, 220);
  vSoundplayer.tag.mp3.ID3v2.Cover.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images + 'sp_nocover.png');
  vSoundplayer.tag.mp3.ID3v2.Cover.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v2.Cover.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Cover_Label := TLabel.Create(vSoundplayer.tag.mp3.ID3v2.Covers);
  vSoundplayer.tag.mp3.ID3v2.Cover_Label.Name := 'A_SP_Tag_Mp3_ID3v2_Cover_Label';
  vSoundplayer.tag.mp3.ID3v2.Cover_Label.Parent := vSoundplayer.tag.mp3.ID3v2.Covers;
  vSoundplayer.tag.mp3.ID3v2.Cover_Label.SetBounds(0, 260, 280, 24);
  vSoundplayer.tag.mp3.ID3v2.Cover_Label.Text := '';
  vSoundplayer.tag.mp3.ID3v2.Cover_Label.Font.Style := vSoundplayer.tag.mp3.ID3v1.Title.Font.Style +
    [TFontStyle.fsBold];
  vSoundplayer.tag.mp3.ID3v2.Cover_Label.TextAlign := TTextAlign.Center;
  vSoundplayer.tag.mp3.ID3v2.Cover_Label.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft := TImage.Create(vSoundplayer.tag.mp3.ID3v2.Covers);
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft.Name := 'A_SP_Tag_Mp3_ID3v2_Covers_Cover_ArrowLeft';
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft.Parent := vSoundplayer.tag.mp3.ID3v2.Covers;
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft.SetBounds(10, 260, 24, 24);
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_arrowleft.png');
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft.OnClick := addons.Soundplayer.Input.mouse_tag.Image.OnMouseClick;
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft.OnMouseEnter :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseEnter;
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft.OnMouseLeave :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseLeave;
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft_Glow :=
    TGlowEffect.Create(vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft);
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft_Glow.Name := 'A_SP_Tag_Mp3_ID3v2_Covers_Cover_ArrowLeft_Glow';
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft_Glow.Parent := vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft;
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft_Glow.Softness := 0.4;
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft_Glow.Opacity := 0.9;
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft_Glow.Enabled := False;

  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft_Grey :=
    TMonochromeEffect.Create(vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft);
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft_Grey.Name := 'A_SP_Tag_Mp3_Covers_Cover_ArrowLeft_Grey';
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft_Grey.Parent := vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft;
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowLeft_Grey.Enabled := False;

  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight := TImage.Create(vSoundplayer.tag.mp3.ID3v2.Covers);
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight.Name := 'A_SP_Tag_Mp3_ID3v2_Covers_Cover_ArrowRight';
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight.Parent := vSoundplayer.tag.mp3.ID3v2.Covers;
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight.SetBounds(vSoundplayer.tag.mp3.ID3v2.Covers.Width - 34,
    260, 24, 24);
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_arrowright.png');
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight.OnClick :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseClick;
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight.OnMouseEnter :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseEnter;
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight.OnMouseLeave :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseLeave;
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight_Glow :=
    TGlowEffect.Create(vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight);
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight_Glow.Name := 'A_SP_Tag_Mp3_ID3v2_Covers_Cover_ArrowRight_Glow';
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight_Glow.Parent := vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight;
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight_Glow.Softness := 0.4;
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight_Glow.Opacity := 0.9;
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight_Glow.Enabled := False;

  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight_Grey :=
    TMonochromeEffect.Create(vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight);
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight_Grey.Name := 'A_SP_Tag_Mp3_Covers_Cover_ArrowRight_Grey';
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight_Grey.Parent := vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight;
  vSoundplayer.tag.mp3.ID3v2.Cover_ArrowRight_Grey.Enabled := False;

  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Computer := TImage.Create(vSoundplayer.tag.mp3.ID3v2.Covers);
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Computer.Name := 'A_SP_Tag_Mp3_ID3v2_Covers_AddComputer';
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Computer.Parent := vSoundplayer.tag.mp3.ID3v2.Covers;
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Computer.SetBounds(10, vSoundplayer.tag.mp3.ID3v2.Covers.Height -
    42, 28, 28);
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Computer.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_computer.png');
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Computer.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Computer.OnClick :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseClick;
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Computer.OnMouseEnter :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseEnter;
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Computer.OnMouseLeave :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseLeave;
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Computer.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Computer_Glow :=
    TGlowEffect.Create(vSoundplayer.tag.mp3.ID3v2.Cover_Add_Computer);
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Computer_Glow.Name := 'A_SP_Tag_Mp3_ID3v2_Covers_AddComputer_Glow';
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Computer_Glow.Parent := vSoundplayer.tag.mp3.ID3v2.Cover_Add_Computer;
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Computer_Glow.Softness := 0.4;
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Computer_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Computer_Glow.Opacity := 0.9;
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Computer_Glow.Enabled := False;

  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Internet := TImage.Create(vSoundplayer.tag.mp3.ID3v2.Covers);
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Internet.Name := 'A_SP_Tag_Mp3_ID3v2_Covers_AddInternet';
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Internet.Parent := vSoundplayer.tag.mp3.ID3v2.Covers;
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Internet.SetBounds(60, vSoundplayer.tag.mp3.ID3v2.Covers.Height -
    42, 28, 28);
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Internet.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_internet.png');
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Internet.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Internet.OnClick :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseClick;
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Internet.OnMouseEnter :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseEnter;
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Internet.OnMouseLeave :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseLeave;
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Internet.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Internet_Glow :=
    TGlowEffect.Create(vSoundplayer.tag.mp3.ID3v2.Cover_Add_Internet);
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Internet_Glow.Name := 'A_SP_Tag_Mp3_ID3v2_Covers_AddInternet_Glow';
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Internet_Glow.Parent := vSoundplayer.tag.mp3.ID3v2.Cover_Add_Internet;
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Internet_Glow.Softness := 0.4;
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Internet_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Internet_Glow.Opacity := 0.9;
  vSoundplayer.tag.mp3.ID3v2.Cover_Add_Internet_Glow.Enabled := False;

  vSoundplayer.tag.mp3.ID3v2.Cover_Remove := TImage.Create(vSoundplayer.tag.mp3.ID3v2.Covers);
  vSoundplayer.tag.mp3.ID3v2.Cover_Remove.Name := 'A_SP_Tag_Mp3_ID3v2_Covers_Remove';
  vSoundplayer.tag.mp3.ID3v2.Cover_Remove.Parent := vSoundplayer.tag.mp3.ID3v2.Covers;
  vSoundplayer.tag.mp3.ID3v2.Cover_Remove.SetBounds(vSoundplayer.tag.mp3.ID3v2.Covers.Width - 42,
    vSoundplayer.tag.mp3.ID3v2.Covers.Height - 42, 28, 28);
  vSoundplayer.tag.mp3.ID3v2.Cover_Remove.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_delete.png');
  vSoundplayer.tag.mp3.ID3v2.Cover_Remove.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v2.Cover_Remove.OnClick := addons.Soundplayer.Input.mouse_tag.Image.OnMouseClick;
  vSoundplayer.tag.mp3.ID3v2.Cover_Remove.OnMouseEnter :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseEnter;
  vSoundplayer.tag.mp3.ID3v2.Cover_Remove.OnMouseLeave :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseLeave;
  vSoundplayer.tag.mp3.ID3v2.Cover_Remove.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Cover_Remove_Glow := TGlowEffect.Create(vSoundplayer.tag.mp3.ID3v2.Cover_Remove);
  vSoundplayer.tag.mp3.ID3v2.Cover_Remove_Glow.Name := 'A_SP_Tag_Mp3_ID3v2_Covers_Remove_Glow';
  vSoundplayer.tag.mp3.ID3v2.Cover_Remove_Glow.Parent := vSoundplayer.tag.mp3.ID3v2.Cover_Remove;
  vSoundplayer.tag.mp3.ID3v2.Cover_Remove_Glow.Softness := 0.4;
  vSoundplayer.tag.mp3.ID3v2.Cover_Remove_Glow.GlowColor := TAlphaColorRec.Red;
  vSoundplayer.tag.mp3.ID3v2.Cover_Remove_Glow.Opacity := 0.9;
  vSoundplayer.tag.mp3.ID3v2.Cover_Remove_Glow.Enabled := False;

  vSoundplayer.tag.mp3.ID3v2.Cover_Remove_Grey :=
    TMonochromeEffect.Create(vSoundplayer.tag.mp3.ID3v2.Cover_Remove);
  vSoundplayer.tag.mp3.ID3v2.Cover_Remove_Grey.Name := 'A_SP_Tag_Mp3_Covers_Cover_Remove_Grey';
  vSoundplayer.tag.mp3.ID3v2.Cover_Remove_Grey.Parent := vSoundplayer.tag.mp3.ID3v2.Cover_Remove;
  vSoundplayer.tag.mp3.ID3v2.Cover_Remove_Grey.Enabled := False;

  vSoundplayer.tag.mp3.ID3v2.Lyrics := TGroupBox.Create(vSoundplayer.tag.mp3.TabItem[1]);
  vSoundplayer.tag.mp3.ID3v2.Lyrics.Name := 'A_SP_Tag_Mp3_ID3v2_Lyrics_Groupbox';
  vSoundplayer.tag.mp3.ID3v2.Lyrics.Parent := vSoundplayer.tag.mp3.TabItem[1];
  vSoundplayer.tag.mp3.ID3v2.Lyrics.SetBounds(680, 20, 280, vSoundplayer.tag.mp3.TabControl.Height - 50);
  vSoundplayer.tag.mp3.ID3v2.Lyrics.Text := 'Lyrics';
  vSoundplayer.tag.mp3.ID3v2.Lyrics.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Lyrics_Memo := TMemo.Create(vSoundplayer.tag.mp3.ID3v2.Lyrics);
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Memo.Name := 'A_SP_Tag_Mp3_ID3v2_Lyrics';
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Memo.Parent := vSoundplayer.tag.mp3.ID3v2.Lyrics;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Memo.SetBounds(10, 20, vSoundplayer.tag.mp3.ID3v2.Lyrics.Width - 20,
    vSoundplayer.tag.mp3.ID3v2.Lyrics.Height - 70);
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Memo.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Computer := TImage.Create(vSoundplayer.tag.mp3.ID3v2.Lyrics);
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Computer.Name := 'A_SP_Tag_Mp3_ID3v2_Lyrics_AddComputer';
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Computer.Parent := vSoundplayer.tag.mp3.ID3v2.Lyrics;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Computer.SetBounds(10, vSoundplayer.tag.mp3.ID3v2.Lyrics.Height -
    42, 28, 28);
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Computer.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_computer.png');
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Computer.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Computer.OnClick :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseClick;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Computer.OnMouseEnter :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseEnter;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Computer.OnMouseLeave :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseLeave;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Computer.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Computer_Glow :=
    TGlowEffect.Create(vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Computer);
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Computer_Glow.Name := 'A_SP_Tag_Mp3_ID3v2_Lyrics_AddComputer_Glow';
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Computer_Glow.Parent :=
    vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Computer;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Computer_Glow.Softness := 0.4;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Computer_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Computer_Glow.Opacity := 0.9;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Computer_Glow.Enabled := False;

  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Internet := TImage.Create(vSoundplayer.tag.mp3.ID3v2.Lyrics);
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Internet.Name := 'A_SP_Tag_Mp3_ID3v2_Lyrics_AddInternet';
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Internet.Parent := vSoundplayer.tag.mp3.ID3v2.Lyrics;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Internet.SetBounds(60, vSoundplayer.tag.mp3.ID3v2.Lyrics.Height -
    42, 28, 28);
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Internet.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_internet.png');
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Internet.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Internet.OnClick :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseClick;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Internet.OnMouseEnter :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseEnter;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Internet.OnMouseLeave :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseLeave;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Internet.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Internet_Glow :=
    TGlowEffect.Create(vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Internet);
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Internet_Glow.Name := 'A_SP_Tag_Mp3_ID3v2_Lyrics_AddInternet_Glow';
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Internet_Glow.Parent :=
    vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Internet;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Internet_Glow.Softness := 0.4;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Internet_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Internet_Glow.Opacity := 0.9;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Add_Internet_Glow.Enabled := False;

  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove := TImage.Create(vSoundplayer.tag.mp3.ID3v2.Lyrics);
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove.Name := 'A_SP_Tag_Mp3_ID3v2_Lyrics_Remove';
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove.Parent := vSoundplayer.tag.mp3.ID3v2.Lyrics;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove.SetBounds(vSoundplayer.tag.mp3.ID3v2.Lyrics.Width - 42,
    vSoundplayer.tag.mp3.ID3v2.Lyrics.Height - 42, 28, 28);
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_delete.png');
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove.OnClick := addons.Soundplayer.Input.mouse_tag.Image.OnMouseClick;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove.OnMouseEnter :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseEnter;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove.OnMouseLeave :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseLeave;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove.Visible := True;

  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove_Glow :=
    TGlowEffect.Create(vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove);
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove_Glow.Name := 'A_SP_Tag_Mp3_ID3v2_Lyrics_Remove_Glow';
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove_Glow.Parent := vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove_Glow.Softness := 0.4;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove_Glow.GlowColor := TAlphaColorRec.Red;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove_Glow.Opacity := 0.9;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove_Glow.Enabled := False;

  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove_Grey :=
    TMonochromeEffect.Create(vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove);
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove_Grey.Name := 'A_SP_Tag_Mp3_Covers_Lyrics_Remove_Grey';
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove_Grey.Parent := vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove;
  vSoundplayer.tag.mp3.ID3v2.Lyrics_Remove_Grey.Enabled := False;

  vSoundplayer.tag.mp3.Button_Save := TButton.Create(vSoundplayer.tag.mp3.Back);
  vSoundplayer.tag.mp3.Button_Save.Name := 'A_SP_Tag_Mp3_Save';
  vSoundplayer.tag.mp3.Button_Save.Parent := vSoundplayer.tag.mp3.Back;
  vSoundplayer.tag.mp3.Button_Save.SetBounds(100, vSoundplayer.tag.mp3.Back.Height - 34, 100, 24);
  vSoundplayer.tag.mp3.Button_Save.Text := 'Save changes';
  vSoundplayer.tag.mp3.Button_Save.OnClick := addons.Soundplayer.Input.mouse_tag.Button.OnMouseClick;
  vSoundplayer.tag.mp3.Button_Save.Visible := True;

  vSoundplayer.tag.mp3.Button_Cancel := TButton.Create(vSoundplayer.tag.mp3.Back);
  vSoundplayer.tag.mp3.Button_Cancel.Name := 'A_SP_Tag_Mp3_Cancel';
  vSoundplayer.tag.mp3.Button_Cancel.Parent := vSoundplayer.tag.mp3.Back;
  vSoundplayer.tag.mp3.Button_Cancel.SetBounds(vSoundplayer.tag.mp3.Back.Width - 200,
    vSoundplayer.tag.mp3.Back.Height - 34, 100, 24);
  vSoundplayer.tag.mp3.Button_Cancel.Text := 'Cancel';
  vSoundplayer.tag.mp3.Button_Cancel.OnClick := addons.Soundplayer.Input.mouse_tag.Button.OnMouseClick;
  vSoundplayer.tag.mp3.Button_Cancel.Visible := True;
end;

procedure uSoundplayer_TagSet_Mp3_SelectCover;
begin
  vSoundplayer.tag.mp3.Back_Blur.Enabled := True;
  vSoundplayer.tag.mp3.TabControl.Enabled := False;

  vSoundplayer.tag.mp3.Cover_Select.Panel := TPanel.Create(vSoundplayer.scene.Soundplayer);
  vSoundplayer.tag.mp3.Cover_Select.Panel.Name := 'A_SP_Tag_Mp3_CoverSelet';
  vSoundplayer.tag.mp3.Cover_Select.Panel.Parent := vSoundplayer.scene.Soundplayer;
  vSoundplayer.tag.mp3.Cover_Select.Panel.SetBounds(extrafe.res.Half_Width - 100,
    extrafe.res.Half_Height - 250, 200, 300);
  vSoundplayer.tag.mp3.Cover_Select.Panel.Visible := True;

  uLoad_SetAll_CreateHeader(vSoundplayer.tag.mp3.Cover_Select.Panel, 'A_SP_Tag_Mp3_CoverSelet',
    addons.Soundplayer.Path.Images + 'sp_nocover.png', 'Choose cover type.');

  vSoundplayer.tag.mp3.Cover_Select.Main := TPanel.Create(vSoundplayer.tag.mp3.Cover_Select.Panel);
  vSoundplayer.tag.mp3.Cover_Select.Main.Name := 'A_SP_Tag_Mp3_CoverSelet_Main';
  vSoundplayer.tag.mp3.Cover_Select.Main.Parent := vSoundplayer.tag.mp3.Cover_Select.Panel;
  vSoundplayer.tag.mp3.Cover_Select.Main.SetBounds(0, 30, vSoundplayer.tag.mp3.Cover_Select.Panel.Width,
    vSoundplayer.tag.mp3.Cover_Select.Panel.Height - 30);
  vSoundplayer.tag.mp3.Cover_Select.Main.Visible := True;

  vSoundplayer.tag.mp3.Cover_Select.List :=
    TListBox.Create(vSoundplayer.tag.mp3.Cover_Select.Main);
  vSoundplayer.tag.mp3.Cover_Select.List.Name := 'A_SP_Tag_Mp3_CoverSelet_Main_List';
  vSoundplayer.tag.mp3.Cover_Select.List.Parent := vSoundplayer.tag.mp3.Cover_Select.Main;
  vSoundplayer.tag.mp3.Cover_Select.List.SetBounds(5, 5,
    vSoundplayer.tag.mp3.Cover_Select.Main.Width - 10,
    vSoundplayer.tag.mp3.Cover_Select.Main.Height - 60);
  vSoundplayer.tag.mp3.Cover_Select.List.Items.Add('Front Cover');
  vSoundplayer.tag.mp3.Cover_Select.List.Items.Add('Back Cover');
  vSoundplayer.tag.mp3.Cover_Select.List.Items.Add('CD Cover');
  vSoundplayer.tag.mp3.Cover_Select.List.Items.Add('Company Logo');
  vSoundplayer.tag.mp3.Cover_Select.List.Items.Add('Other');
  vSoundplayer.tag.mp3.Cover_Select.List.ItemIndex := 0;
  vSoundplayer.tag.mp3.Cover_Select.List.ItemHeight := 37;
  vSoundplayer.tag.mp3.Cover_Select.List.Visible := True;

  vSoundplayer.tag.mp3.Cover_Select.Load :=
    TButton.Create(vSoundplayer.tag.mp3.Cover_Select.Main);
  vSoundplayer.tag.mp3.Cover_Select.Load.Name := 'A_SP_Tag_Mp3_CoverSelet_Main_Load';
  vSoundplayer.tag.mp3.Cover_Select.Load.Parent := vSoundplayer.tag.mp3.Cover_Select.Main;
  vSoundplayer.tag.mp3.Cover_Select.Load.SetBounds(20,
    vSoundplayer.tag.mp3.Cover_Select.Main.Height - 40, 50, 30);
  vSoundplayer.tag.mp3.Cover_Select.Load.Text := 'Load';
  vSoundplayer.tag.mp3.Cover_Select.Load.OnClick :=
    addons.Soundplayer.Input.mouse_tag.Button.OnMouseClick;
  vSoundplayer.tag.mp3.Cover_Select.Load.Visible := True;

  vSoundplayer.tag.mp3.Cover_Select.Cancel :=
    TButton.Create(vSoundplayer.tag.mp3.Cover_Select.Main);
  vSoundplayer.tag.mp3.Cover_Select.Cancel.Name := 'A_SP_Tag_Mp3_CoverSelet_Main_Cancel';
  vSoundplayer.tag.mp3.Cover_Select.Cancel.Parent := vSoundplayer.tag.mp3.Cover_Select.Main;
  vSoundplayer.tag.mp3.Cover_Select.Cancel.SetBounds(vSoundplayer.tag.mp3.Cover_Select.Main.Width
    - 70, vSoundplayer.tag.mp3.Cover_Select.Main.Height - 40, 50, 30);
  vSoundplayer.tag.mp3.Cover_Select.Cancel.Text := 'Cancel';
  vSoundplayer.tag.mp3.Cover_Select.Cancel.OnClick :=
    addons.Soundplayer.Input.mouse_tag.Button.OnMouseClick;
  vSoundplayer.tag.mp3.Cover_Select.Cancel.Visible := True;
end;

procedure uSoundplayer_TagSet_Mp3_Free;
begin
  extrafe.prog.State := 'addon_soundplayer';
  vSoundplayer.scene.Back_Blur.Enabled := False;
  FreeAndNil(vSoundplayer.tag.mp3.Back);
  uSoundPlayer_Player_Actions_OnLeave(vSoundplayer.player.Song_Tag, vSoundplayer.player.Song_Tag_Glow);
end;

procedure uSoundplayer_TagSet_Mp3_ShowCoverLabel(vShow: Boolean);
begin

end;

procedure uSoundplayer_TagSet_Mp3_ShowLyrics_AddDialog;
begin
  vSoundplayer.tag.mp3.Back_Blur.Enabled := True;
  vSoundplayer.tag.mp3.TabControl.Enabled := False;

  vSoundplayer.tag.mp3.Lyrics_Add.Panel := TPanel.Create(vSoundplayer.scene.Soundplayer);
  vSoundplayer.tag.mp3.Lyrics_Add.Panel.Name := 'A_SP_Tag_Mp3_LyricsAdd';
  vSoundplayer.tag.mp3.Lyrics_Add.Panel.Parent := vSoundplayer.scene.Soundplayer;
  vSoundplayer.tag.mp3.Lyrics_Add.Panel.SetBounds(extrafe.res.Half_Width - 175, extrafe.res.Half_Height - 100,
    350, 200);
  vSoundplayer.tag.mp3.Lyrics_Add.Panel.Visible := True;

  uLoad_SetAll_CreateHeader(vSoundplayer.tag.mp3.Lyrics_Add.Panel, 'A_SP_Tag_Mp3_LyricsAdd',
    addons.Soundplayer.Path.Images + 'sp_lyrics.png', 'How to add lyrics?');

  vSoundplayer.tag.mp3.Lyrics_Add.Main := TPanel.Create(vSoundplayer.tag.mp3.Lyrics_Add.Panel);
  vSoundplayer.tag.mp3.Lyrics_Add.Main.Name := 'A_SP_Tag_Mp3_LyricsAdd_Main';
  vSoundplayer.tag.mp3.Lyrics_Add.Main.Parent := vSoundplayer.tag.mp3.Lyrics_Add.Panel;
  vSoundplayer.tag.mp3.Lyrics_Add.Main.SetBounds(0, 30, vSoundplayer.tag.mp3.Lyrics_Add.Panel.Width,
    vSoundplayer.tag.mp3.Lyrics_Add.Panel.Height - 30);
  vSoundplayer.tag.mp3.Lyrics_Add.Main.Visible := True;

  vSoundplayer.tag.mp3.Lyrics_Add.Radio_Above :=
    TRadioButton.Create(vSoundplayer.tag.mp3.Lyrics_Add.Main);
  vSoundplayer.tag.mp3.Lyrics_Add.Radio_Above.Name := 'A_SP_Tag_Mp3_LyricsAdd_Main_Radio_Above';
  vSoundplayer.tag.mp3.Lyrics_Add.Radio_Above.Parent := vSoundplayer.tag.mp3.Lyrics_Add.Main;
  vSoundplayer.tag.mp3.Lyrics_Add.Radio_Above.SetBounds(10, 20, 280, 24);
  vSoundplayer.tag.mp3.Lyrics_Add.Radio_Above.Text := 'Add lyrics to the end of the line.';
  vSoundplayer.tag.mp3.Lyrics_Add.Radio_Above.OnClick :=
    addons.Soundplayer.Input.mouse_tag.Radio.OnMouseClick;
  vSoundplayer.tag.mp3.Lyrics_Add.Radio_Above.Visible := True;

  vSoundplayer.tag.mp3.Lyrics_Add.Radio_Clear :=
    TRadioButton.Create(vSoundplayer.tag.mp3.Lyrics_Add.Main);
  vSoundplayer.tag.mp3.Lyrics_Add.Radio_Clear.Name := 'A_SP_Tag_Mp3_LyricsAdd_Main_Radio_Clear';
  vSoundplayer.tag.mp3.Lyrics_Add.Radio_Clear.Parent := vSoundplayer.tag.mp3.Lyrics_Add.Main;
  vSoundplayer.tag.mp3.Lyrics_Add.Radio_Clear.SetBounds(10, 60, 280, 24);
  vSoundplayer.tag.mp3.Lyrics_Add.Radio_Clear.Text :=
    'Clear the current lyrics and add the new ones.';
  vSoundplayer.tag.mp3.Lyrics_Add.Radio_Clear.OnClick :=
    addons.Soundplayer.Input.mouse_tag.Radio.OnMouseClick;
  vSoundplayer.tag.mp3.Lyrics_Add.Radio_Clear.Visible := True;

  vSoundplayer.tag.mp3.Lyrics_Add.Add :=
    TButton.Create(vSoundplayer.tag.mp3.Lyrics_Add.Main);
  vSoundplayer.tag.mp3.Lyrics_Add.Add.Name := 'A_SP_Tag_Mp3_LyricsAdd_Main_Add';
  vSoundplayer.tag.mp3.Lyrics_Add.Add.Parent := vSoundplayer.tag.mp3.Lyrics_Add.Main;
  vSoundplayer.tag.mp3.Lyrics_Add.Add.SetBounds(20,
    vSoundplayer.tag.mp3.Lyrics_Add.Main.Height - 40, 50, 30);
  vSoundplayer.tag.mp3.Lyrics_Add.Add.Text := 'Add';
  vSoundplayer.tag.mp3.Lyrics_Add.Add.Enabled := False;
  vSoundplayer.tag.mp3.Lyrics_Add.Add.OnClick :=
    addons.Soundplayer.Input.mouse_tag.Button.OnMouseClick;
  vSoundplayer.tag.mp3.Lyrics_Add.Add.Visible := True;

  vSoundplayer.tag.mp3.Lyrics_Add.Cancel :=
    TButton.Create(vSoundplayer.tag.mp3.Lyrics_Add.Main);
  vSoundplayer.tag.mp3.Lyrics_Add.Cancel.Name := 'A_SP_Tag_Mp3_LyricsAdd_Main_Cancel';
  vSoundplayer.tag.mp3.Lyrics_Add.Cancel.Parent := vSoundplayer.tag.mp3.Lyrics_Add.Main;
  vSoundplayer.tag.mp3.Lyrics_Add.Cancel.SetBounds
    (vSoundplayer.tag.mp3.Lyrics_Add.Main.Width - 70, vSoundplayer.tag.mp3.Lyrics_Add.Main.Height
    - 40, 50, 30);
  vSoundplayer.tag.mp3.Lyrics_Add.Cancel.Text := 'Cancel';
  vSoundplayer.tag.mp3.Lyrics_Add.Cancel.OnClick :=
    addons.Soundplayer.Input.mouse_tag.Button.OnMouseClick;
  vSoundplayer.tag.mp3.Lyrics_Add.Cancel.Visible := True;
end;

end.
