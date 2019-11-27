unit uLoad_Addons;

interface

uses
  System.Classes,
  System.SysUtils;

procedure Load;

implementation

uses
  uLoad_AllTypes,
  uDB_AUser,
  uDB,
  uTime_Actions,
  uCalendar_Actions,
  uWeather_Actions,
  uSoundplayer_Actions,
  uPlay_Actions;

procedure Load;
var
  vi: Integer;
begin
  uDB_AUser.Local.ADDONS.Names := TStringList.Create;
  for vi := 0 to uDB_AUser.Local.ADDONS.Count do
    uDB_AUser.Local.ADDONS.Names.Add('');

  ex_load.Scene.Progress_Text.Text := 'Configurate and loading "Addons" ...';

  uTime_Actions.Get_Data;
  uCalendar_Actions.Get_Data;
  uWeather_Actions.Get_Data;
  uSoundplayer_Actions.Get_Data;
  uPlay_Actions.Get_Data;

  ex_load.Scene.Progress.Value := 90;
end;

/// //////////////////////////////////////////////////////////////////////////////////////////////////////////
// Addon Play

procedure uLoad_Addons_Play_FirstTime;
begin
  { CreateDir(extrafe.prog.Path + 'data');
    CreateDir(extrafe.prog.Path + 'data\addons');
    CreateDir(extrafe.prog.Path + 'data\addons\play');
    CreateDir(extrafe.prog.Path + 'data\addons\play\azhung');
    CreateDir(extrafe.prog.Path + 'data\addons\play\azmatch');
    CreateDir(extrafe.prog.Path + 'data\addons\play\azong');
    CreateDir(extrafe.prog.Path + 'data\addons\play\azsuko');
    CreateDir(extrafe.prog.Path + 'data\addons\play\aztype');

    addons.play.ini.Path := extrafe.prog.Path + 'data\addons\play\';
    addons.play.ini.Name := 'play.ini';
    addons.play.ini.ini := TIniFile.Create(addons.play.ini.Path + addons.play.ini.Name);
    addons.play.Path.Icon := addons.soundplayer.ini.Path + 'icon\';
    addons.play.Path.Images := addons.soundplayer.ini.Path + 'images\';
    addons.play.Path.Sounds := addons.soundplayer.ini.Path + 'sounds\';

    addons.play.ini.ini.WriteString('PLAY', 'Addon_Name', 'play');
    addons.play.ini.ini.WriteBool('PLAY', 'Active', False);
    addons.play.ini.ini.WriteInteger('PLAY', 'Menu_Position', -1);

    // Game AzHung
    gAzHung.Path.Game := addons.play.ini.Path + 'azhung\';
    gAzHung.Path.Icon := gAzHung.Path.Game + 'icon\';
    gAzHung.Path.Sounds := gAzHung.Path.Game + 'sounds\';
    gAzHung.Path.Images := gAzHung.Path.Game + 'images\';
    gAzHung.Path.Score := gAzHung.Path.Game + 'score\';
    gAzHung.Path.Words := gAzHung.Path.Game + 'words\';

    gAzHung.ini.Name := 'azhung.ini';
    gAzHung.ini.Path := gAzHung.Path.Game;
    gAzHung.ini.ini := TIniFile.Create(gAzHung.ini.Path + gAzHung.ini.Name);

    gAzHung.ini.ini.WriteBool('AZHUNG', 'Active', False);
    gAzHung.ini.ini.WriteBool('AZHUNG', 'Pause', False);
    gAzHung.ini.ini.WriteString('AZHUNG', 'Words', 'words.ini'); }

end;

procedure uLoad_Addons_Play_Load;
begin
  { addons.play.ini.Path := extrafe.prog.Path + 'data\addons\play\';
    addons.play.ini.Name := 'play.ini';
    addons.play.ini.ini := TIniFile.Create(addons.play.ini.Path + addons.play.ini.Name);

    addons.play.Name := addons.play.ini.ini.ReadString('PLAY', 'Addon_Name', addons.play.Name);
    addons.play.Active := addons.play.ini.ini.ReadBool('PLAY', 'Active', addons.play.Active);
    addons.play.Main_Menu_Position := addons.play.ini.ini.ReadInteger('PLAY', 'Menu_Position', addons.play.Main_Menu_Position);
    addons.play.Path.Icon := addons.play.ini.Path + 'icon\';
    addons.play.Path.Images := addons.play.ini.Path + 'images\';
    addons.play.Path.Sounds := addons.play.ini.Path + 'sounds\';

    // Game AzHung
    gAzHung.Path.Game := addons.play.ini.Path + 'azhung\';
    gAzHung.Path.Icon := gAzHung.Path.Game + 'icon\';
    gAzHung.Path.Sounds := gAzHung.Path.Game + 'sounds\';
    gAzHung.Path.Images := gAzHung.Path.Game + 'images\';
    gAzHung.Path.Score := gAzHung.Path.Game + 'score\';
    gAzHung.Path.Words := gAzHung.Path.Game + 'words\';

    gAzHung.ini.Name := 'azhung.ini';
    gAzHung.ini.Path := gAzHung.Path.Game;
    gAzHung.ini.ini := TIniFile.Create(gAzHung.ini.Path + gAzHung.ini.Name);

    gAzHung.Actions.Active := gAzHung.ini.ini.ReadBool('AZHUNG', 'Active', gAzHung.Actions.Active);
    gAzHung.Actions.Paused := gAzHung.ini.ini.ReadBool('AZHUNG', 'Pause', gAzHung.Actions.Paused);
    gAzHung.Actions.Words := gAzHung.ini.ini.ReadString('AZHUNG', 'Words', gAzHung.Actions.Words); }
end;

end.
