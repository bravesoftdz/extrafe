﻿unit uDB_Check;

interface

uses
  System.Classes,
  CodeSiteLogging;

{ Check if Tables exists and create the missing one }
procedure Local_tables;

{ Check if Columns exits or have someone to delete }
procedure Local_Columns;
procedure Users;
procedure Users_Statistics;
procedure Settings;
procedure Options;
procedure Addons;
procedure Addon_Time;
procedure Addon_Time_Time;
procedure Addon_Calendar;
procedure Addon_Weather;
procedure Addon_Weather_OWM;
procedure Addon_Weather_Yahoo;
procedure Addon_Soundplayer;
procedure Addon_Soundplayer_Playlists;
procedure Addon_AzPlay;
procedure Emulators;
procedure Arcade;
procedure Arcade_Mame;
procedure Arcade_Media;
procedure Computers;
procedure Consoles;
procedure Handhelds;
procedure Pinballs;

implementation

uses
  uDB;

{ Check if Tables exists and create the missing one }
procedure Local_tables;
begin
  CodeSite.EnterMethod('Check Tables of Extrafe local database (SQLLite)');
  { 22 Tables }
  // Users ->
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS users ("USER_ID" Integer NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT, "USERNAME" Text,	"PASSWORD" Text,	"NAME" Text, "SURNAME" Text, "IP" Text, "UNIQUE_ID" Integer, '
    + '"REGISTERED" Text, "GENDER" Boolean, "AVATAR" Text, "LAST_VISIT" Text, "LAST_VISIT_ONLINE" Text, "EMAIL" Text, "COUNTRY" Text, "ACTIVE_ONLINE" Boolean);';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "users" is checked and corrected');

  // Users_Statistics ->
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'CREATE TABLE IF NOT EXISTS users_statistics ("USER_ID" Integer);';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "users_statistics" is checked and corrected');

  // Settings ->
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS settings ("USER_ID" Integer NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT, "THEME_PATH" Text,	"THEME_NUM" Integer,	"THEME_NAME" Text, "RESOLUTION_WIDTH" Integer, '
    + '"RESOLUTION_HEIGHT" Integer, "NAME" Text, "PATH_LIB" Text, "PATH_HISTORY" Text, "PATH_FONTS" Text, "PATH" Text, "LOCAL_DATA" Boolean, "FOULSCREEN" Boolean, "DATABASE_PATH" Text );';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "settings" is checked and corrected');

  // Options ->
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS options ("USER_ID" Integer NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT, "VIRTUAL_KEYBOARD" Boolean);';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "options" is checked and corrected');

  // Addons ->
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS addons ("USER_ID" Integer NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT, "ACTIVE" BOOLENAN DEFAULT True,	"COUNT" Integer DEFAULT 4,	"TIME" Boolean DEFAULT True, '
    + '"CALENDAR" Boolean DEFAULT True, "WEATHER" Boolean DEFAULT False, "SOUNDPLAYER" Boolean DEFAULT False, "AZPLAY" Boolean DEFAULT False);';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "addons" is checked and corrected');

  // Addon_Time ->
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS addon_time ("USER_ID" Integer NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT, "FIRST_POP" Boolean DEFAULT True,	"MENU_POSITION" Integer DEFAULT 0,	"PATH_CLOCKS" Text, '
    + ' "PATH_IMAGES" Text, "PATH_SOUNDS" Text);';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "addon_time" is checked and corrected');

  // Addon_Time_Time ->
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS addon_time_time ("USER_ID" Integer NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT, "CLOCK_TYPE" Text DEFAULT "digital", "ANALOG_WIDTH" Integer DEFAULT 400,'
    + ' "ANALOG_HEIGHT" Integer DEFAULT 400, "ANALOG_X" Integer DEFAULT 400, "ANALOG_Y" Integer DEFAULT 50, "ANALOG_THEME" Text DEFAULT "default", "ANALOG_COLOR" Text DEFAULT "$FFFF1493", '
    + ' "ANALOG_FONT" Text DEFAULT Arial, "ANALOG_INDICATORS" Boolean DEFAULT True, "ANALOG_NUMS" Boolean DEFAULT True, "ANALOG_TICK" Boolean DEFAULT False, "DIGITAL_WIDTH" Integer DEFAULT 400, '
    + ' "DIGITAL_HEIGHT" Integer DEFAULT 200, "DIGITAL_X" Integer DEFAULT 400, "DIGITAL_Y" Integer DEFAULT 100, "DIGITAL_COLOR" Text DEFAULT "$FF483D8B", "DIGITAL_FONT" Text DEFAULT Arial, '
    + ' "DIGITAL_FONT_COLOR" Text DEFAULT "$FFFF1493", "DIGITAL_SEPARATOR" Text DEFAULT ":", "DIGITAL_SEPARATOR_COLOR" Text DEFAULT "$FFFF1493");';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "addon_time_time" is checked and corrected');

  // Addon_Calendar ->
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS addon_calendar ("USER_ID" Integer NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT, "FIRST_POP" Boolean DEFAULT True, "MENU_POSITION" Integer DEFAULT 1);';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "addon_calendar" is checked and corrected');

  // Addon_Weather ->
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS addon_weather ("USER_ID" Integer NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT, "FIRST_POP" Boolean DEFAULT True, "MENU_POSITION" Integer, '
    + ' "OLD_BACKUP" Boolean DEFAULT False, "PROVIDER_COUNT" Integer DEFAULT 1, "PROVIDER" Text, "PATH_ICONS" Text, "PATH_IMAGES" Text, "PATH_SOUNDS" Text, "PATH_TEMP" Text, '
    + ' "YAHOO_ICONSET_COUNT" Integer DEFAULT 3, "YAHOO_ICONSET" Text DEFAULT "default", "YAHOO_ICONSET_SELECTED" Integer DEFAULT "0", "YAHOO_METRIC" Text DEFAULT "imperial", "YAHOO_DEGREE" Text DEFAULT "celcius", "OWM_ICONSET_COUNT" Integer DEFAULT 1, '
    + ' "OWM_ICONSET" Text DEFAULT "default", "OWM_ICONSET_SELECTED" Integer DEFAULT "0", "OWM_METRIC" Text DEFAULT "imperial", "OWM_DEGREE" Text DEFAULT "celcius", "OWM_API" Text, "OWM_LANG" Text DEFAULT "english");';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "addon_weather" is checked and corrected');

  // Addon_Weather_OWM  ->
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS addon_weather_owm ("USER_ID" Integer , "TOWN_NUM" Integer, "TOWN_WOEID" Text,	"TOWN_NAME" Text );';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "addon_weather_owm" is checked and corrected');

  // Addon_Weather_Yahoo ->
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS addon_weather_yahoo ("USER_ID" Integer , "TOWN_NUM" Integer, "TOWN_WOEID" Text,	"TOWN_NAME" Text );';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "addon_weather_yahoo" is checked and corrected');

  // Addon_Soundplayer ->
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS addon_soundplayer ("USER_ID" Integer NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT, "FIRST_POP" Boolean DEFAULT True, ' +
    ' "MENU_POSITION" Integer, "PATH_IMAGES" Text, "PATH_SOUNDS" Text, "PATH_PLAYLISTS" Text, "VOLUME" Integer DEFAULT 80, "LAST_PLAYING_SONG_NUM" Integer DEFAULT "-1", '
    + ' "PLAYLIST_COUNT" Integer DEFAULT "-1", "LAST_PLAYLIST" Integer DEFAULT "-1", "TOTAL_PLAY" Integer DEFAULT "-1", "TOTAL_TIME" Text DEFAULT "00:00:00");';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "addon_soundplayer" is checked and corrected');

  { That i'll check it if has benefits from that

    Addon_Soundplayer_Playlists
    ExtraFE_Query_Local.Close;
    ExtraFE_Query_Local.SQL.Clear;
    ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS addon_soundplayer_playlists ("game_num" Integer NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT, "sourcefile" Text,	"savestate" Boolean,	"width" Integer );';
    ExtraFE_Query_Local.ExecSQL;
    CodeSite.Send('Table "addon_soundplayer_playlists" is checked and corrected'); }

  // Addon_AzPlay ->
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS addon_azplay ("USER_ID" Integer NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT, "FIRST_POP" Boolean DEFAULT True, "MENU_POSITION" Integer, "COUNT" Integer DEFAULT 0, '
    + ' "Active" Integer DEFAULT 0, "AZHUNG" Boolean DEFAULT True);';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "addon_azplay" is checked and corrected');

  // Emulators  ->
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS emulators ("USER_ID" Integer NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT, "COUNT" Integer DEFAULT "-1", "ACTIVE_UNIQUE" Integer DEFAULT "-1", '
    + ' "ACTIVE_UNIQUE_MULTI" Integer DEFAULT "-1", "PATH" Text,	"ARCADE" Boolean DEFAULT False, "COMPUTERS" Boolean DEFAULT False, "CONSOLES" Boolean DEFAULT False, "HANDHELDS" Boolean DEFAULT False,'
    + ' "PINBALLS" Boolean DEFAULT False );';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "emulators" is checked and corrected');

  // Arcade ->
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS arcade ("USER_ID" Integer NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT, "ACTIVE" Boolean DEFAULT "True","COUNT" Integer DEFAULT "-1", "POSITION" Integer DEFAULT "0", "NAME" Text DEFAULT "arcade", '
    + ' "PATH_IMAGES" Text,	"MAME" Boolean DEFAULT False,	"FBA" Boolean DEFAULT False, "ZINC" Boolean DEFAULT False, "DAPHNE" Boolean DEFAULT False, "RAINE" Boolean DEFAULT False, '
    + ' "SUPERMODEL" Boolean DEFAULT False, "DEMUL" Boolean DEFAULT False, "WINKAWAKS" Boolean DEFAULT False, "MODEL2" Boolean DEFAULT False );';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "arcade" is checked and corrected');

  // Arcade_Mame ->
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS arcade_mame ("USER_ID" Integer NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT, "INSTALLED" Boolean DEFAULT False,	"EMU_POSITION" Integer DEFAULT "-1", '
    + ' "EMU_ACTIVE" Boolean DEFAULT False, "EMU_UNIQUE" Integer DEFAULT "0","EMU_UNIQUE_MULTI" Integer DEFAULT "0", "VIEW_MODE" Text DEFAULT "video", "EXTRAFE_MAME_PATH" Text, '
    + ' "EXTRAFE_MAME_IMAGES" Text, "EXTRAFE_MAME_SOUNDS" Text, "MAME_NAME" Text, "MAME_PATH" Text, "MAME_INI" Text, "MAME_VERSION" Text);';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "arcade_mame" is checked and corrected');

  // Arcade_Media ->
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS arcade_media ("USER_ID" Integer NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT, "ARTWORKS" Text, "CABINETS" Text,	"CONTROL_PANELS" Text, "COVERS" Text, "FLYERS" Text, '
    + ' "FANART" Text, "GAME_OVER" Text, "ICONS" Text, "MANUALS" Text, "MARQUEESS" Text, "PCBS" Text, "SNAPSHOTS" Text, "TITLES" Text, "ARTWORK_PREVIEW" Text, "BOSSES" Text, "ENDS" Text, "HOW_TO" Text, '
    + ' "LOGOS" Text, "SCORES" Text, "SELECTS" Text, "STAMPS" Text, "VERSUS" Text, "WARNINGS" Text, "SOUNDTRACKS" Text, "SUPPORT_FILES" Text, "VIDEOS" Text);';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "arcade_media" is checked and corrected');

  // Computers
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS computers ("USER_ID" Integer NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT,"ACTIVE" Boolean DEFAULT "True", "COUNT" Integer DEFAULT "-1", "POSITION" Integer DEFAULT "1", "NAME" Text DEFAULT "computers", '
    + ' "PATH_IMAGES" Text,	"ACORN_ARCHIMEDES" Boolean DEFAULT False,	"AMIGA" Boolean DEFAULT False, "AMSTRAD" Boolean DEFAULT False, "ATARI_8BIT" Boolean DEFAULT False, "ATARI_ST" Boolean DEFAULT False, '
    + ' "COMMODORE_64" Boolean DEFAULT False, "MSDOS" Boolean DEFAULT False, "OLD_PC_WINDOWS" Boolean DEFAULT False, "SCUMMVM" Boolean DEFAULT False, "SPECTRUM" Boolean DEFAULT False, "X68000" Boolean DEFAULT False );';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "computers" is checked and corrected');

  // Consoles
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS consoles ("USER_ID" Integer NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT,"ACTIVE" Boolean DEFAULT "True", "COUNT" Integer DEFAULT "-1", "POSITION" Integer DEFAULT "2", "NAME" Text DEFAULT "consoles", '
    + ' "PATH_IMAGES" Text,	"3DO" Boolean DEFAULT False,	"AMIGA_CD32" Boolean DEFAULT False, "ATARI_2600" Boolean DEFAULT False, "ATARI_5200" Boolean DEFAULT False, "ATARI_7800" Boolean DEFAULT False, '
    + ' "ATARI_JAGUAR" Boolean DEFAULT False, "NEO_GEO" Boolean DEFAULT False, "NEO_GEO_CD" Boolean DEFAULT False, "NES" Boolean DEFAULT False, "SNES" Boolean DEFAULT False, "NINTENDO_64" Boolean DEFAULT False, '
    + ' "GAMECUBE" Boolean DEFAULT False, "WII" Boolean DEFAULT False, "WII_U" Boolean DEFAULT False, "NINTENDO_SWITCH" Boolean DEFAULT False, "PC_ENGINE" Boolean DEFAULT False, "PC_ENGINE_CD" Boolean DEFAULT False, '
    + ' "PC_FX" Boolean DEFAULT False, "PLAYSTATION" Boolean DEFAULT False, "PLAYSTATION_2" Boolean DEFAULT False, "PLAYSTATION_3" Boolean DEFAULT False, "SG_1000" Boolean DEFAULT False, '
    + ' "MASTER_SYSTEM" Boolean DEFAULT False, "MEGA_DRIVE" Boolean DEFAULT False, "MEGA_DRIVE_32X" Boolean DEFAULT False, "MEGA_DRIVE_CD" Boolean DEFAULT False, "SATURN" Boolean DEFAULT False, '
    + ' "DREAMCAST" Boolean DEFAULT False, "XBOX" Boolean DEFAULT False, "XBOX_ONE" Boolean DEFAULT False );';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "consoles" is checked and corrected');

  // Handhelds
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS handhelds ("USER_ID" Integer NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT,"ACTIVE" Boolean DEFAULT "True", "COUNT" Integer DEFAULT "-1", "POSITION" Integer DEFAULT "3", "NAME" Text DEFAULT "handhelds", '
    + ' "PATH_IMAGES" Text, "ATARI_LYNX" Boolean DEFAULT False, "NEO_GEO_POCKET" Boolean DEFAULT False, "GAMEGEAR" Boolean DEFAULT False, "GAME_AND_WATCH" Boolean DEFAULT False, "GAMEBOY" Boolean DEFAULT False, '
    + ' "GAMEBOY_COLOR" Boolean DEFAULT False, "GAMEBOY_VIRTUALBOY" Boolean DEFAULT False, "GAMEBOY_ADVANCE" Boolean DEFAULT False, "NINTENDO_DS" Boolean DEFAULT False, "NINTENDO_3DS" Boolean DEFAULT False, '
    + ' "PSP" Boolean DEFAULT False, "PSP_VITA" Boolean DEFAULT False, "WONDERSWAN" Boolean DEFAULT False);';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "handhelds" is checked and corrected');

  // Pinballs
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS pinballs ("USER_ID" Integer NOT NULL DEFAULT 0 PRIMARY KEY AUTOINCREMENT, "ACTIVE" Boolean DEFAULT "True", "COUNT" Integer DEFAULT "-1", "POSITION" Integer DEFAULT "4", "NAME" Text DEFAULT "pinballs", '
    + ' "PATH_IMAGES" Text, "VISUAL_PINBALL" Boolean DEFAULT False, "FUTURE_PINBALL" Boolean DEFAULT False);';
  ExtraFE_Query_Local.ExecSQL;
  CodeSite.Send('Table "pinballs" is checked and corrected');

  CodeSite.ExitMethod('All the tables of the database is checked and corrected');
end;

{ Check if Columns exits or have someone to delete }
procedure Users;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("users");';
  ExtraFE_Query_Local.Open;
  ExtraFE_Query_Local.First;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Users_Statistics;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("users_statistcs");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Settings;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("settings");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Options;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("options");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Addons;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("addons");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Addon_Time;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("addon_time");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Addon_Time_Time;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("addon_time_time");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Addon_Calendar;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("addon_calendar");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Addon_Weather;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("addon_weather");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Addon_Weather_OWM;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("addon_weather_owm");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Addon_Weather_Yahoo;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("addon_weather_yahoo");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Addon_Soundplayer;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("addon_soundplayer");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Addon_Soundplayer_Playlists;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("addon_soundplayer_playlists");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Addon_AzPlay;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("addon_azplay");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Emulators;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("emulators");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Arcade;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("arcade");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Arcade_Mame;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("arcade_mame");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Arcade_Media;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("arcade_media");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Computers;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("computers");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Consoles;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("consoles");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Handhelds;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("handhelds");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Pinballs;
const
  cColumns_Names: array [0 .. 10] of string = ('', '', '', '', '', '', '', '', '', '', '');
var
  vi: Integer;
  vList: TStringlist;
begin
  vList := TStringlist.Create;

  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Text := 'PRAGMA table_info("pinballs");';
  ExtraFE_Query_Local.Open;

  for vi := 0 to ExtraFE_Query_Local.FieldList.Count - 1 do
  begin

  end;
end;

procedure Local_Columns;
begin
  Users;
  Users_Statistics;
  Settings;
  Options;
  Addons;
  Addon_Time;
  Addon_Time_Time;
  Addon_Calendar;
  Addon_Weather;
  Addon_Weather_OWM;
  Addon_Weather_Yahoo;
  Addon_Soundplayer;
  Addon_Soundplayer_Playlists;
  Addon_AzPlay;
  Emulators;
  Arcade;
  Arcade_Mame;
  Arcade_Media;
  Computers;
  Consoles;
  Handhelds;
  Pinballs;
end;

end.
