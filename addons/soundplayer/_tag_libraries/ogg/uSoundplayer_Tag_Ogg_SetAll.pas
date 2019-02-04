unit uSoundplayer_Tag_Ogg_SetAll;

interface

uses
  System.Classes,
  System.SysUtils,
  System.UiTypes,
  FMX.StdCtrls,
  FMX.Filter.Effects,
  FMX.Objects,
  FMX.Graphics,
  FMX.Edit,
  FMX.ComboEdit,
  FMX.Effects;

procedure uSoundplayer_TagSet_Opus;
procedure uSoundplayer_TagSet_Opus_Free;

implementation

uses
  uLoad_AllTypes,
  uSoundplayer_AllTypes,
  uSoundplayer_Player,
  uSoundplayer;

procedure uSoundplayer_TagSet_Opus;
begin
  extrafe.prog.State := 'addon_soundplayer_tag_opus';

  uSoundplayer.Hide_Animations;

  vSoundplayer.tag.opus.Back := TPanel.Create(vSoundplayer.scene.Soundplayer);
  vSoundplayer.tag.opus.Back.Name := 'A_SP_Tag_Opus';
  vSoundplayer.tag.opus.Back.Parent := vSoundplayer.scene.Soundplayer;
  vSoundplayer.tag.opus.Back.Width := 1000;
  vSoundplayer.tag.opus.Back.Height := 500;
  vSoundplayer.tag.opus.Back.Position.X := (vSoundplayer.scene.Back.Width / 2) - 500;
  vSoundplayer.tag.opus.Back.Position.Y := (vSoundplayer.scene.Back.Height / 2) - 250;
  vSoundplayer.tag.opus.Back.Visible := True;

  vSoundplayer.tag.opus.Back_Blur := TGaussianBlurEffect.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Back_Blur.Name := 'A_SP_Tag_Opus_Blur';
  vSoundplayer.tag.opus.Back_Blur.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Back_Blur.BlurAmount := 0.5;
  vSoundplayer.tag.opus.Back_Blur.Enabled := False;

  uLoad_SetAll_CreateHeader(vSoundplayer.tag.opus.Back, 'A_SP_Tag_Opus', addons.Soundplayer.Path.Images +
    'sp_tag_opus.png', 'Tag ogg,opus');

  // Prepei na balo ola se tab prota to opus/ogg meta to info

  vSoundplayer.tag.opus.Main := TPanel.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Main.Name := 'A_SP_Opus_Main';
  vSoundplayer.tag.opus.Main.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Main.SetBounds(0, 30, vSoundplayer.tag.opus.Back.Width,
    vSoundplayer.tag.opus.Back.Height - 30);
  vSoundplayer.tag.opus.Main.Visible := True;

  vSoundplayer.tag.opus.Logo := TImage.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Logo.Name := 'A_SP_Tag_Opus_Logo';
  vSoundplayer.tag.opus.Logo.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Logo.Width := 50;
  vSoundplayer.tag.opus.Logo.Height := 50;
  vSoundplayer.tag.opus.Logo.Position.X := vSoundplayer.tag.opus.Back.Width - 60;
  vSoundplayer.tag.opus.Logo.Position.Y := 10;
  vSoundplayer.tag.opus.Logo.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images + 'sp_tag_opus.png');
  vSoundplayer.tag.opus.Logo.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.opus.Logo.Visible := True;

  vSoundplayer.tag.opus.Title := TLabel.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Title.Name := 'A_SP_Tag_Opus_Title';
  vSoundplayer.tag.opus.Title.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Title.Width := 100;
  vSoundplayer.tag.opus.Title.Height := 24;
  vSoundplayer.tag.opus.Title.Position.X := 40;
  vSoundplayer.tag.opus.Title.Position.Y := 90;
  vSoundplayer.tag.opus.Title.Text := 'Song Name : ';
  vSoundplayer.tag.opus.Title.Font.Style := vSoundplayer.tag.opus.Title.Font.Style + [TFontStyle.fsBold];
  vSoundplayer.tag.opus.Title.Visible := True;

  vSoundplayer.tag.opus.Title_V := TEdit.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Title_V.Name := 'A_SP_Tag_Opus_Title_V';
  vSoundplayer.tag.opus.Title_V.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Title_V.Width := 320;
  vSoundplayer.tag.opus.Title_V.Height := 24;
  vSoundplayer.tag.opus.Title_V.Position.X := 140;
  vSoundplayer.tag.opus.Title_V.Position.Y := 90;
  vSoundplayer.tag.opus.Title_V.Text := '';
  vSoundplayer.tag.opus.Title_V.Visible := True;

  vSoundplayer.tag.opus.Artist := TLabel.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Artist.Name := 'A_SP_Tag_Opus_Artist';
  vSoundplayer.tag.opus.Artist.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Artist.Width := 100;
  vSoundplayer.tag.opus.Artist.Height := 24;
  vSoundplayer.tag.opus.Artist.Position.X := 40;
  vSoundplayer.tag.opus.Artist.Position.Y := 120;
  vSoundplayer.tag.opus.Artist.Text := 'Artist Name : ';
  vSoundplayer.tag.opus.Artist.Font.Style := vSoundplayer.tag.opus.Artist.Font.Style + [TFontStyle.fsBold];
  vSoundplayer.tag.opus.Artist.Visible := True;

  vSoundplayer.tag.opus.Artist_V := TEdit.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Artist_V.Name := 'A_SP_Tag_Opus_Artist_V';
  vSoundplayer.tag.opus.Artist_V.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Artist_V.Width := 320;
  vSoundplayer.tag.opus.Artist_V.Height := 24;
  vSoundplayer.tag.opus.Artist_V.Position.X := 140;
  vSoundplayer.tag.opus.Artist_V.Position.Y := 120;
  vSoundplayer.tag.opus.Artist_V.Text := '';
  vSoundplayer.tag.opus.Artist_V.Visible := True;

  vSoundplayer.tag.opus.Album := TLabel.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Album.Name := 'A_SP_Tag_Opus_Album';
  vSoundplayer.tag.opus.Album.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Album.Width := 100;
  vSoundplayer.tag.opus.Album.Height := 24;
  vSoundplayer.tag.opus.Album.Position.X := 40;
  vSoundplayer.tag.opus.Album.Position.Y := 150;
  vSoundplayer.tag.opus.Album.Text := 'Album Name : ';
  vSoundplayer.tag.opus.Album.Font.Style := vSoundplayer.tag.opus.Album.Font.Style + [TFontStyle.fsBold];
  vSoundplayer.tag.opus.Album.Visible := True;

  vSoundplayer.tag.opus.Album_V := TEdit.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Album_V.Name := 'A_SP_Tag_Opus_Album_V';
  vSoundplayer.tag.opus.Album_V.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Album_V.Width := 320;
  vSoundplayer.tag.opus.Album_V.Height := 24;
  vSoundplayer.tag.opus.Album_V.Position.X := 140;
  vSoundplayer.tag.opus.Album_V.Position.Y := 150;
  vSoundplayer.tag.opus.Album_V.Text := '';
  vSoundplayer.tag.opus.Album_V.Visible := True;

  vSoundplayer.tag.opus.Genre := TLabel.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Genre.Name := 'A_SP_Tag_Opus_Genre';
  vSoundplayer.tag.opus.Genre.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Genre.Width := 100;
  vSoundplayer.tag.opus.Genre.Height := 24;
  vSoundplayer.tag.opus.Genre.Position.X := 40;
  vSoundplayer.tag.opus.Genre.Position.Y := 180;
  vSoundplayer.tag.opus.Genre.Text := 'Genre Type : ';
  vSoundplayer.tag.opus.Genre.Font.Style := vSoundplayer.tag.opus.Genre.Font.Style + [TFontStyle.fsBold];
  vSoundplayer.tag.opus.Genre.Visible := True;

  vSoundplayer.tag.opus.Genre_V := TComboEdit.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Genre_V.Name := 'A_SP_Tag_Opus_Genre_V';
  vSoundplayer.tag.opus.Genre_V.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Genre_V.Width := 320;
  vSoundplayer.tag.opus.Genre_V.Height := 24;
  vSoundplayer.tag.opus.Genre_V.Position.X := 140;
  vSoundplayer.tag.opus.Genre_V.Position.Y := 180;
  vSoundplayer.tag.opus.Genre_V.Items.LoadFromFile(addons.Soundplayer.Path.Files + 'sp_genre_tags.txt');
  vSoundplayer.tag.opus.Genre_V.Text := '';
  vSoundplayer.tag.opus.Genre_V.Visible := True;

  vSoundplayer.tag.opus.Date := TLabel.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Date.Name := 'A_SP_Tag_Opus_Date';
  vSoundplayer.tag.opus.Date.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Date.Width := 100;
  vSoundplayer.tag.opus.Date.Height := 24;
  vSoundplayer.tag.opus.Date.Position.X := 40;
  vSoundplayer.tag.opus.Date.Position.Y := 210;
  vSoundplayer.tag.opus.Date.Text := 'Date Releash : ';
  vSoundplayer.tag.opus.Date.Font.Style := vSoundplayer.tag.opus.Date.Font.Style + [TFontStyle.fsBold];
  vSoundplayer.tag.opus.Date.Visible := True;

  vSoundplayer.tag.opus.Date_V := TEdit.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Date_V.Name := 'A_SP_Tag_Opus_Date_V';
  vSoundplayer.tag.opus.Date_V.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Date_V.Width := 320;
  vSoundplayer.tag.opus.Date_V.Height := 24;
  vSoundplayer.tag.opus.Date_V.Position.X := 140;
  vSoundplayer.tag.opus.Date_V.Position.Y := 210;
  vSoundplayer.tag.opus.Date_V.Text := '';
  vSoundplayer.tag.opus.Date_V.Visible := True;

  vSoundplayer.tag.opus.Track := TLabel.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Track.Name := 'A_SP_Tag_Opus_Track';
  vSoundplayer.tag.opus.Track.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Track.Width := 100;
  vSoundplayer.tag.opus.Track.Height := 24;
  vSoundplayer.tag.opus.Track.Position.X := 40;
  vSoundplayer.tag.opus.Track.Position.Y := 240;
  vSoundplayer.tag.opus.Track.Text := 'Track Number : ';
  vSoundplayer.tag.opus.Track.Font.Style := vSoundplayer.tag.opus.Track.Font.Style + [TFontStyle.fsBold];
  vSoundplayer.tag.opus.Track.Visible := True;

  vSoundplayer.tag.opus.Track_V := TEdit.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Track_V.Name := 'A_SP_Tag_Opus_Track_V';
  vSoundplayer.tag.opus.Track_V.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Track_V.Width := 320;
  vSoundplayer.tag.opus.Track_V.Height := 24;
  vSoundplayer.tag.opus.Track_V.Position.X := 140;
  vSoundplayer.tag.opus.Track_V.Position.Y := 240;
  vSoundplayer.tag.opus.Track_V.Text := '';
  vSoundplayer.tag.opus.Track_V.Visible := True;

  vSoundplayer.tag.opus.Disk := TLabel.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Disk.Name := 'A_SP_Tag_Opus_Disk';
  vSoundplayer.tag.opus.Disk.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Disk.Width := 100;
  vSoundplayer.tag.opus.Disk.Height := 24;
  vSoundplayer.tag.opus.Disk.Position.X := 40;
  vSoundplayer.tag.opus.Disk.Position.Y := 270;
  vSoundplayer.tag.opus.Disk.Text := 'Disc Name : ';
  vSoundplayer.tag.opus.Disk.Font.Style := vSoundplayer.tag.opus.Disk.Font.Style + [TFontStyle.fsBold];
  vSoundplayer.tag.opus.Disk.Visible := True;

  vSoundplayer.tag.opus.Disk_V := TEdit.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Disk_V.Name := 'A_SP_Tag_Opus_Disk_V';
  vSoundplayer.tag.opus.Disk_V.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Disk_V.Width := 320;
  vSoundplayer.tag.opus.Disk_V.Height := 24;
  vSoundplayer.tag.opus.Disk_V.Position.X := 140;
  vSoundplayer.tag.opus.Disk_V.Position.Y := 270;
  vSoundplayer.tag.opus.Disk_V.Text := '';
  vSoundplayer.tag.opus.Disk_V.Visible := True;

  vSoundplayer.tag.opus.Comment := TLabel.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Comment.Name := 'A_SP_Tag_Opus_Comment';
  vSoundplayer.tag.opus.Comment.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Comment.Width := 100;
  vSoundplayer.tag.opus.Comment.Height := 24;
  vSoundplayer.tag.opus.Comment.Position.X := 40;
  vSoundplayer.tag.opus.Comment.Position.Y := 300;
  vSoundplayer.tag.opus.Comment.Text := 'Comments : ';
  vSoundplayer.tag.opus.Comment.Font.Style := vSoundplayer.tag.opus.Comment.Font.Style + [TFontStyle.fsBold];
  vSoundplayer.tag.opus.Comment.Visible := True;

  vSoundplayer.tag.opus.Comment_V := TEdit.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Comment_V.Name := 'A_SP_Tag_Opus_Comment_V';
  vSoundplayer.tag.opus.Comment_V.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Comment_V.Width := 320;
  vSoundplayer.tag.opus.Comment_V.Height := 24;
  vSoundplayer.tag.opus.Comment_V.Position.X := 140;
  vSoundplayer.tag.opus.Comment_V.Position.Y := 300;
  vSoundplayer.tag.opus.Comment_V.Text := '';
  vSoundplayer.tag.opus.Comment_V.Visible := True;

  vSoundplayer.tag.opus.CoverBox := TGroupBox.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.CoverBox.Name := 'A_SP_Tag_Opus_Cover_Groupbox';
  vSoundplayer.tag.opus.CoverBox.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.CoverBox.Width := 280;
  vSoundplayer.tag.opus.CoverBox.Height := 360;
  vSoundplayer.tag.opus.CoverBox.Position.X := 480;
  vSoundplayer.tag.opus.CoverBox.Position.Y := 80;
  vSoundplayer.tag.opus.CoverBox.Text := 'Covers';
  vSoundplayer.tag.opus.CoverBox.Visible := True;

  vSoundplayer.tag.opus.Cover := TImage.Create(vSoundplayer.tag.opus.CoverBox);
  vSoundplayer.tag.opus.Cover.Name := 'A_SP_Tag_Opus_Cover';
  vSoundplayer.tag.opus.Cover.Parent := vSoundplayer.tag.opus.CoverBox;
  vSoundplayer.tag.opus.Cover.Width := 260;
  vSoundplayer.tag.opus.Cover.Height := 200;
  vSoundplayer.tag.opus.Cover.Position.X := 10;
  vSoundplayer.tag.opus.Cover.Position.Y := 30;
  vSoundplayer.tag.opus.Cover.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images + 'sp_nocover.png');
  vSoundplayer.tag.opus.Cover.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.opus.Cover.Visible := True;

  { vSoundplayer.tag.mp3.ID3v2_Cover_Label := TLabel.Create(vSoundplayer.tag.mp3.ID3v2_Covers);
    vSoundplayer.tag.mp3.ID3v2_Cover_Label.Name := 'A_SP_Tag_Mp3_ID3v2_Cover_Label';
    vSoundplayer.tag.mp3.ID3v2_Cover_Label.Parent := vSoundplayer.tag.mp3.ID3v2_Covers;
    vSoundplayer.tag.mp3.ID3v2_Cover_Label.Width := 280;
    vSoundplayer.tag.mp3.ID3v2_Cover_Label.Height := 24;
    vSoundplayer.tag.mp3.ID3v2_Cover_Label.Position.X := 0;
    vSoundplayer.tag.mp3.ID3v2_Cover_Label.Position.Y := 260;
    vSoundplayer.tag.mp3.ID3v2_Cover_Label.Text := '';
    vSoundplayer.tag.mp3.ID3v2_Cover_Label.Font.Style := vSoundplayer.tag.mp3.ID3v1_Title.Font.Style +
    [TFontStyle.fsBold];
    vSoundplayer.tag.mp3.ID3v2_Cover_Label.TextAlign := TTextAlign.Center;
    vSoundplayer.tag.mp3.ID3v2_Cover_Label.Visible := True; }

  vSoundplayer.tag.opus.Cover_LoadFromComputer := TImage.Create(vSoundplayer.tag.opus.CoverBox);
  vSoundplayer.tag.opus.Cover_LoadFromComputer.Name := 'A_SP_Tag_Opus_Cover_AddComputer';
  vSoundplayer.tag.opus.Cover_LoadFromComputer.Parent := vSoundplayer.tag.opus.CoverBox;
  vSoundplayer.tag.opus.Cover_LoadFromComputer.Width := 28;
  vSoundplayer.tag.opus.Cover_LoadFromComputer.Height := 28;
  vSoundplayer.tag.opus.Cover_LoadFromComputer.Position.X := 10;
  vSoundplayer.tag.opus.Cover_LoadFromComputer.Position.Y := vSoundplayer.tag.opus.CoverBox.Height - 42;
  vSoundplayer.tag.opus.Cover_LoadFromComputer.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_computer.png');
  vSoundplayer.tag.opus.Cover_LoadFromComputer.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.opus.Cover_LoadFromComputer.OnClick :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseClick;
  vSoundplayer.tag.opus.Cover_LoadFromComputer.OnMouseEnter :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseEnter;
  vSoundplayer.tag.opus.Cover_LoadFromComputer.OnMouseLeave :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseLeave;
  vSoundplayer.tag.opus.Cover_LoadFromComputer.Visible := True;

  vSoundplayer.tag.opus.Cover_LoadFromComputer_Glow :=
    TGlowEffect.Create(vSoundplayer.tag.opus.Cover_LoadFromComputer);
  vSoundplayer.tag.opus.Cover_LoadFromComputer_Glow.Name := 'A_SP_Tag_Opus_Covers_AddComputer_Glow';
  vSoundplayer.tag.opus.Cover_LoadFromComputer_Glow.Parent := vSoundplayer.tag.opus.Cover_LoadFromComputer;
  vSoundplayer.tag.opus.Cover_LoadFromComputer_Glow.Softness := 0.4;
  vSoundplayer.tag.opus.Cover_LoadFromComputer_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vSoundplayer.tag.opus.Cover_LoadFromComputer_Glow.Opacity := 0.9;
  vSoundplayer.tag.opus.Cover_LoadFromComputer_Glow.Enabled := False;

  vSoundplayer.tag.opus.Cover_LoadFromInterent := TImage.Create(vSoundplayer.tag.opus.CoverBox);
  vSoundplayer.tag.opus.Cover_LoadFromInterent.Name := 'A_SP_Tag_Opus_Cover_AddInternet';
  vSoundplayer.tag.opus.Cover_LoadFromInterent.Parent := vSoundplayer.tag.opus.CoverBox;
  vSoundplayer.tag.opus.Cover_LoadFromInterent.Width := 28;
  vSoundplayer.tag.opus.Cover_LoadFromInterent.Height := 28;
  vSoundplayer.tag.opus.Cover_LoadFromInterent.Position.X := 60;
  vSoundplayer.tag.opus.Cover_LoadFromInterent.Position.Y := vSoundplayer.tag.opus.CoverBox.Height - 42;
  vSoundplayer.tag.opus.Cover_LoadFromInterent.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images +
    'sp_internet.png');
  vSoundplayer.tag.opus.Cover_LoadFromInterent.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.opus.Cover_LoadFromInterent.OnClick :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseClick;
  vSoundplayer.tag.opus.Cover_LoadFromInterent.OnMouseEnter :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseEnter;
  vSoundplayer.tag.opus.Cover_LoadFromInterent.OnMouseLeave :=
    addons.Soundplayer.Input.mouse_tag.Image.OnMouseLeave;
  vSoundplayer.tag.opus.Cover_LoadFromInterent.Visible := True;

  vSoundplayer.tag.opus.Cover_LoadFromInterent_Glow :=
    TGlowEffect.Create(vSoundplayer.tag.opus.Cover_LoadFromInterent);
  vSoundplayer.tag.opus.Cover_LoadFromInterent_Glow.Name := 'A_SP_Tag_Opus_Covers_AddInternet_Glow';
  vSoundplayer.tag.opus.Cover_LoadFromInterent_Glow.Parent := vSoundplayer.tag.opus.Cover_LoadFromInterent;
  vSoundplayer.tag.opus.Cover_LoadFromInterent_Glow.Softness := 0.4;
  vSoundplayer.tag.opus.Cover_LoadFromInterent_Glow.GlowColor := TAlphaColorRec.Deepskyblue;
  vSoundplayer.tag.opus.Cover_LoadFromInterent_Glow.Opacity := 0.9;
  vSoundplayer.tag.opus.Cover_LoadFromInterent_Glow.Enabled := False;

  vSoundplayer.tag.opus.Cover_Delete := TImage.Create(vSoundplayer.tag.opus.CoverBox);
  vSoundplayer.tag.opus.Cover_Delete.Name := 'A_SP_Tag_Opus_Covers_Remove';
  vSoundplayer.tag.opus.Cover_Delete.Parent := vSoundplayer.tag.opus.CoverBox;
  vSoundplayer.tag.opus.Cover_Delete.Width := 28;
  vSoundplayer.tag.opus.Cover_Delete.Height := 28;
  vSoundplayer.tag.opus.Cover_Delete.Position.X := vSoundplayer.tag.opus.CoverBox.Width - 42;
  vSoundplayer.tag.opus.Cover_Delete.Position.Y := vSoundplayer.tag.opus.CoverBox.Height - 42;
  vSoundplayer.tag.opus.Cover_Delete.Bitmap.LoadFromFile(addons.Soundplayer.Path.Images + 'sp_delete.png');
  vSoundplayer.tag.opus.Cover_Delete.WrapMode := TImageWrapMode.Fit;
  vSoundplayer.tag.opus.Cover_Delete.OnClick := addons.Soundplayer.Input.mouse_tag.Image.OnMouseClick;
  vSoundplayer.tag.opus.Cover_Delete.OnMouseEnter := addons.Soundplayer.Input.mouse_tag.Image.OnMouseEnter;
  vSoundplayer.tag.opus.Cover_Delete.OnMouseLeave := addons.Soundplayer.Input.mouse_tag.Image.OnMouseLeave;
  vSoundplayer.tag.opus.Cover_Delete.Visible := True;

  vSoundplayer.tag.opus.Cover_Delete_Glow := TGlowEffect.Create(vSoundplayer.tag.opus.Cover_Delete);
  vSoundplayer.tag.opus.Cover_Delete_Glow.Name := 'A_SP_Tag_Opus_Covers_Delete_Glow';
  vSoundplayer.tag.opus.Cover_Delete_Glow.Parent := vSoundplayer.tag.opus.Cover_Delete;
  vSoundplayer.tag.opus.Cover_Delete_Glow.Softness := 0.4;
  vSoundplayer.tag.opus.Cover_Delete_Glow.GlowColor := TAlphaColorRec.Red;
  vSoundplayer.tag.opus.Cover_Delete_Glow.Opacity := 0.9;
  vSoundplayer.tag.opus.Cover_Delete_Glow.Enabled := False;

  vSoundplayer.tag.opus.Cover_Delete_Grey := TMonochromeEffect.Create(vSoundplayer.tag.opus.Cover_Delete);
  vSoundplayer.tag.opus.Cover_Delete_Grey.Name := 'A_SP_Tag_Opus_Covers_Delete_Grey';
  vSoundplayer.tag.opus.Cover_Delete_Grey.Parent := vSoundplayer.tag.opus.Cover_Delete;
  vSoundplayer.tag.opus.Cover_Delete_Grey.Enabled := False;

  vSoundplayer.tag.opus.Button_Save := TButton.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Button_Save.Name := 'A_SP_Tag_Opus_Save';
  vSoundplayer.tag.opus.Button_Save.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Button_Save.Width := 100;
  vSoundplayer.tag.opus.Button_Save.Height := 24;
  vSoundplayer.tag.opus.Button_Save.Position.X := 100;
  vSoundplayer.tag.opus.Button_Save.Position.Y := vSoundplayer.tag.opus.Back.Height - 34;
  vSoundplayer.tag.opus.Button_Save.Text := 'Save changes';
  vSoundplayer.tag.opus.Button_Save.OnClick := addons.Soundplayer.Input.mouse_tag.Button.OnMouseClick;
  vSoundplayer.tag.opus.Button_Save.Visible := True;

  vSoundplayer.tag.opus.Button_Cancel := TButton.Create(vSoundplayer.tag.opus.Back);
  vSoundplayer.tag.opus.Button_Cancel.Name := 'A_SP_Tag_Opus_Cancel';
  vSoundplayer.tag.opus.Button_Cancel.Parent := vSoundplayer.tag.opus.Back;
  vSoundplayer.tag.opus.Button_Cancel.Width := 100;
  vSoundplayer.tag.opus.Button_Cancel.Height := 24;
  vSoundplayer.tag.opus.Button_Cancel.Position.X := vSoundplayer.tag.opus.Back.Width - 200;
  vSoundplayer.tag.opus.Button_Cancel.Position.Y := vSoundplayer.tag.opus.Back.Height - 34;
  vSoundplayer.tag.opus.Button_Cancel.Text := 'Cancel';
  vSoundplayer.tag.opus.Button_Cancel.OnClick := addons.Soundplayer.Input.mouse_tag.Button.OnMouseClick;
  vSoundplayer.tag.opus.Button_Cancel.Visible := True;
end;

procedure uSoundplayer_TagSet_Opus_Free;
begin
  extrafe.prog.State := 'addon_soundplayer';
  vSoundplayer.scene.Back_Blur.Enabled := False;
  FreeAndNil(vSoundplayer.tag.opus.Back);
  uSoundplayer_Player.OnLeave(vSoundplayer.player.Song_Tag, vSoundplayer.player.Song_Tag_Glow);
end;

end.
