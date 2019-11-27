unit uDB_AUser;

interface

uses
  System.Classes,
  System.SysUtils,
  System.DateUtils,
  System.JSON,
  Rest.Types;

type
  TDATABASE_ACTIVE_USER_ONLINE = record
    Num: Integer;
    User_ID: String;
    Username: String;
    Password: String;
    Email: String;
    IP: String;
    Country: String;
    Name: String;
    Surname: String;
    Avatar: Integer;
    Registered: String;
    Last_Visit: String;
    Genre: Integer;
    Active: Integer;
  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_ADDONS_TIME_TIME = record
    vType: String;
    Both_Analog_Width: Integer;
    Both_Analog_Height: Integer;
    Both_Analog_X: Integer;
    Both_Analog_Y: Integer;
    Both_Digital_Width: Integer;
    Both_Digital_Height: Integer;
    Both_Digital_X: Integer;
    Both_Digital_Y: Integer;
    Both_Selection: String;
    Analog_Width: Integer;
    Analog_Height: Integer;
    Analog_X: Integer;
    Analog_Y: Integer;
    Analog_Theme: String;
    Analog_Color: String;
    Analog_Font: String;
    Analog_Show_Ind: Boolean;
    Analog_Show_Nums: Boolean;
    Analog_Tick: Boolean;
    Digital_Width: Integer;
    Digital_Height: Integer;
    Digital_X: Integer;
    Digital_Y: Integer;
    Digital_Color: String;
    Digital_Font: String;
    Digital_Font_Color: String;
    Digital_Sep: String;
    Digital_Sep_Color: String;

  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_ADDONS_TIME_PATHS = record
    Images: String;
    Sounds: String;
    Clocks: String;
  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_ADDONS_TIME = record
    Menu_Position: Integer;
    First_Pop: Boolean;
    Path: TDATABASE_ACTIVE_USER_LOCAL_ADDONS_TIME_PATHS;
    Time: TDATABASE_ACTIVE_USER_LOCAL_ADDONS_TIME_TIME;

  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_ADDONS_CALENDAR = record
    Menu_Position: Integer;
  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_ADDONS_WEATHER_TOWNS_DATA = record
    Name: String;
    Num: Integer;
    Woeid: Integer;
  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_ADDONS_WEATHER_YAHOO = record
    Iconset_Count: Integer;
    Iconset: String;
    Iconsets: TStringList;
    Towns_Count: Integer;
    System: String;
    Degree: String;
    Towns: array of TDATABASE_ACTIVE_USER_LOCAL_ADDONS_WEATHER_TOWNS_DATA;
  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_ADDONS_WEATHER_OPENWEATHERMAP = record
    Iconset_Count: Integer;
    Iconset: String;
    Towns_Count: Integer;
    System: String;
    Degree: String;
    API: String;
    Language: String;
    Towns: array of TDATABASE_ACTIVE_USER_LOCAL_ADDONS_WEATHER_TOWNS_DATA;
  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_ADDONS_WEATHER = record
    Menu_Position: Integer;
    First_Pop: Boolean;
    Old_Backup: Boolean;
    Provider_Count: Integer;
    Provider: String;
    p_Icons: String;
    p_Images: String;
    p_Sounds: String;
    p_Temp: String;
    Yahoo: TDATABASE_ACTIVE_USER_LOCAL_ADDONS_WEATHER_YAHOO;
    OpenWeatherMap: TDATABASE_ACTIVE_USER_LOCAL_ADDONS_WEATHER_OPENWEATHERMAP;
  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_ADDONS_SOUNDPLAYER = record
    Menu_Position: Integer;
    First_Pop: Boolean;
    Volume: Integer;
    Last_Visit: String;
    Last_Play_Song_Num: Integer;
    Last_Playlist_Num: Integer;
    Playlist_Count: Integer;
    Total_Play_Click: Integer;
    Total_Play_Time: String;
    p_Images: String;
    p_Playlists: String;
    p_Sounds: String;
  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_ADDONS_AZPLAY = record
    Menu_Position: Integer;
    First_Pop: Boolean;
    Count: Integer;
    Active: Integer;
    AzHung: Boolean;
    AzMatch: Boolean;
    AzOng: Boolean;
    AzSuko: Boolean;
    AzType: Boolean;
  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_ADDONS = record
    Count: Integer;
    Active: Integer;
    Names: TStringlist;
    Time: Boolean;
    Time_D: TDATABASE_ACTIVE_USER_LOCAL_ADDONS_TIME;
    Calendar: Boolean;
    Calendar_D: TDATABASE_ACTIVE_USER_LOCAL_ADDONS_CALENDAR;
    Weather: Boolean;
    Weather_D: TDATABASE_ACTIVE_USER_LOCAL_ADDONS_WEATHER;
    Soundplayer: Boolean;
    Soundplayer_D: TDATABASE_ACTIVE_USER_LOCAL_ADDONS_SOUNDPLAYER;
    Azplay: Boolean;
    Azplay_D: TDATABASE_ACTIVE_USER_LOCAL_ADDONS_AZPLAY;
  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE_MEDIA = record
    Artworks: String;
    Cabinets: String;
    Control_Panels: String;
    Covers: String;
    Flyers: String;
    Fanart: String;
    Game_Over: String;
    Icons: String;
    Manuals: String;
    Marquees: String;
    Pcbs: String;
    Snapshots: String;
    Titles: String;
    Artwork_Preview: String;
    Bosses: String;
    Ends: String;
    How_To: String;
    Logos: String;
    Scores: String;
    Selects: String;
    Stamps: String;
    Versus: String;
    Warnings: String;
    Soundtracks: String;
    Support_Files: String;
    Videos: String;
  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE_MAME = record
    Installed: Boolean;
    Active: Boolean;
    Position: Integer;
    Unique: Integer;
    Path: String;
    Name: String;
    Version: String;
    Ini: String;
    p_Path: String;
    p_Database: String;
    p_Images: String;
    p_Sounds: String;
  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE_FBA = record

  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE_ZINC = record

  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE_DAPHNE = record

  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE_KRONOS = record

  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE_RAINE = record

  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE_MODEL2 = record

  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE_SUPERMODEL = record

  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE_DEMUL = record

  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE = record
    Media: TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE_MEDIA;
    Mame: Boolean;
    Mame_D: TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE_MAME;
    FBA: Boolean;
    FBA_D: TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE_FBA;
    Zinc: Boolean;
    Zinc_D: TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE_ZINC;
    Daphne: Boolean;
    Daphne_D: TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE_DAPHNE;
    Kronos: Boolean;
    Kronos_D: TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE_KRONOS;
    Raine: Boolean;
    Raine_D: TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE_RAINE;
    Model2: Boolean;
    Model2_D: TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE_MODEL2;
    SuperModel: Boolean;
    SuperModel_D: TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE_SUPERMODEL;
    Demul: Boolean;
    Demul_D: TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE_DEMUL;
  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_COMPUTERS = record
    Acorn_Archimedes: Boolean;
    Amiga: Boolean;
    Amstrad: Boolean;
    Atari_800XL: Boolean;
    Atart_ST: Boolean;
    Commodore_64: Boolean;
    MsDos: Boolean;
    PCWindows: Boolean;
    Scummvm: Boolean;
    Spectrum: Boolean;
    X68000: Boolean;
  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_CONSOLES = record
    Panasonic_3DO: Boolean;
    Amiga_CD32: Boolean;
    Atari_2600: Boolean;
    Atari_5200: Boolean;
    Atari_7800: Boolean;
    Atari_Jaguar: Boolean;
    Neo_Geo: Boolean;
    Neo_Geo_CD: Boolean;
    NES: Boolean;
    SNES: Boolean;
    Nintendo_64: Boolean;
    Gamecube: Boolean;
    Wii: Boolean;
    Wii_U: Boolean;
    Nintendo_Switch: Boolean;
    PC_Engine: Boolean;
    PC_Engine_CD: Boolean;
    PX_FX: Boolean;
    Playstation: Boolean;
    Playstation_2: Boolean;
    Playstation_3: Boolean;
    SG_1000: Boolean;
    Master_System: Boolean;
    Mega_Drive: Boolean;
    Mega_Drive_32X: Boolean;
    Mega_Drive_CD: Boolean;
    Saturn: Boolean;
    Dreamcast: Boolean;
    XBOX: Boolean;
    XBOX_ONE: Boolean;
  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_HANDHELDS = record
    Atari_Lynx: Boolean;
    Neo_Geo_Pocket: Boolean;
    GameGear: Boolean;
    Game_And_Watch: Boolean;
    Gameboy: Boolean;
    Gameboy_Color: Boolean;
    Gameboy_VirtualBoy: Boolean;
    Gameboy_Advance: Boolean;
    Nintendo_DS: Boolean;
    Nintendo_3DS: Boolean;
    PSP: Boolean;
    PSP_Vita: Boolean;
    Wonderswan: Boolean;
  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_PINBALLS = record
    Visual_Pinball: Boolean;
    Future_Pinball: Boolean;
  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_EMULATORS = record
    Count: Integer;
    Arcade: Boolean;
    Arcade_D: TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_ARCADE;
    Computers: Boolean;
    Computers_D: TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_COMPUTERS;
    Consoles: Boolean;
    Consoles_D: TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_CONSOLES;
    Handhelds: Boolean;
    Handhelds_D: TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_HANDHELDS;
    Pinballs: Boolean;
    Pinballs_D: TDATABASE_ACTIVE_USER_LOCAL_EMULATORS_PINBALLS;
  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_OPTIONS_VISUAL = record
    Virtual_Keyboard: Boolean;
  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_OPTIONS_GRAPHICS = record

  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_OPTIONS_SOUND = record

  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_OPTIONS_INPUT = record

  end;

type
  TDATABASE_ACTIVE_USER_LOCAL_OPTIONS = record
    Visual: TDATABASE_ACTIVE_USER_LOCAL_OPTIONS_VISUAL;
    Graphics: TDATABASE_ACTIVE_USER_LOCAL_OPTIONS_GRAPHICS;
    Sound: TDATABASE_ACTIVE_USER_LOCAL_OPTIONS_SOUND;
    Input: TDATABASE_ACTIVE_USER_LOCAL_OPTIONS_INPUT;
  end;

type
  TDATABASE_ACTIVE_USER_LOCAL = record
    Num: Integer;
    ID: Integer;
    Username: String;
    Password: String;
    Email: String;
    IP: String;
    Country: String;
    Name: String;
    Surname: String;
    Avatar: String;
    Registered: String;
    Last_Visit: String;
    Last_Visit_Online: String;
    Genre: Boolean;
    Active: Boolean;
    OPTIONS: TDATABASE_ACTIVE_USER_LOCAL_OPTIONS;
    ADDONS: TDATABASE_ACTIVE_USER_LOCAL_ADDONS;
    EMULATORS: TDATABASE_ACTIVE_USER_LOCAL_EMULATORS;
  end;

procedure Get_Online_Data(vUser_Num: String);
procedure Get_Local_Data(vUser_Num: String);

function Find_User_Online_Num(vUser_ID: String): Integer;

procedure update_time;

procedure Temp_User;

var
  Local: TDATABASE_ACTIVE_USER_LOCAL;
  Online: TDATABASE_ACTIVE_USER_ONLINE;

implementation

uses
  load,
  uLoad,
  uDB,
  uInternet_files;

procedure Get_Online_Data(vUser_Num: String);
var
  vQuery: String;
begin
  vQuery := 'SELECT * FROM USERS WHERE NUM=' + vUser_Num;
  ExtraFE_Query.Close;
  ExtraFE_Query.SQL.Clear;
  ExtraFE_Query.SQL.Add(vQuery);
  ExtraFE_Query.ExecSQL;
  ExtraFE_Query.Open;
  ExtraFE_Query.First;
  Online.Num := ExtraFE_Query.FieldByName('NUM').AsInteger;
  Online.User_ID := ExtraFE_Query.FieldByName('USER_ID').AsString;
  Online.Username := ExtraFE_Query.FieldByName('USERNAME').AsString;
  Online.Password := ExtraFE_Query.FieldByName('PASSWORD').AsString;
  Online.Email := ExtraFE_Query.FieldByName('EMAIL').AsString;
  Online.IP := ExtraFE_Query.FieldByName('IP').AsString;
  Online.Avatar := ExtraFE_Query.FieldByName('AVATAR').AsInteger;
  Online.Country := ExtraFE_Query.FieldByName('COUNTRY').AsString;
  Online.Name := ExtraFE_Query.FieldByName('NAME').AsString;
  Online.Surname := ExtraFE_Query.FieldByName('SURNAME').AsString;
  Online.Registered := ExtraFE_Query.FieldByName('REGISTERED').AsString;
  Online.Last_Visit := ExtraFE_Query.FieldByName('LAST_VISIT').AsString;
  Online.Genre := ExtraFE_Query.FieldByName('GENDER').AsInteger;
  Online.Active := ExtraFE_Query.FieldByName('ACTIVE').AsInteger;
end;

procedure Get_Local_Data(vUser_Num: String);
var
  vQuery: String;
begin
  vQuery := 'SELECT * FROM USERS WHERE USER_ID=' + vUser_Num;
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Add(vQuery);
  ExtraFE_Query_Local.Open;
  ExtraFE_Query_Local.First;
  Local.Num := ExtraFE_Query_Local.FieldByName('USER_ID').AsInteger;
  Local.ID := ExtraFE_Query_Local.FieldByName('UNIQUE_ID').AsInteger;
  Local.Username := ExtraFE_Query_Local.FieldByName('USERNAME').AsString;
  Local.Password := ExtraFE_Query_Local.FieldByName('PASSWORD').AsString;
  Local.Email := ExtraFE_Query_Local.FieldByName('EMAIL').AsString;
  Local.IP := ExtraFE_Query_Local.FieldByName('IP').AsString;
  Local.Country := ExtraFE_Query_Local.FieldByName('COUNTRY').AsString;
  Local.Name := ExtraFE_Query_Local.FieldByName('NAME').AsString;
  Local.Surname := ExtraFE_Query_Local.FieldByName('SURNAME').AsString;
  Local.Avatar := ExtraFE_Query_Local.FieldByName('AVATAR').AsString;
  Local.Registered := ExtraFE_Query_Local.FieldByName('REGISTERED').AsString;
  Local.Last_Visit := ExtraFE_Query_Local.FieldByName('LAST_VISIT').AsString;
  Local.Last_Visit_Online := ExtraFE_Query_Local.FieldByName('LAST_VISIT_ONLINE').AsString;
  Local.Genre := ExtraFE_Query_Local.FieldByName('GENDER').AsBoolean;
  Local.Active := ExtraFE_Query_Local.FieldByName('ACTIVE_ONLINE').AsBoolean;

  vQuery := 'SELECT * FROM OPTIONS WHERE USER_ID=' + vUser_Num;
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Add(vQuery);
  ExtraFE_Query_Local.Open;
  ExtraFE_Query_Local.First;
  Local.OPTIONS.Visual.Virtual_Keyboard := ExtraFE_Query_Local.FieldByName('VIRTUAL_KEYBOARD').AsBoolean;

  vQuery := 'SELECT * FROM EMULATORS WHERE USER_ID=' + vUser_Num;
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Add(vQuery);
  ExtraFE_Query_Local.Open;
  ExtraFE_Query_Local.First;
  Local.EMULATORS.Count := ExtraFE_Query_Local.FieldByName('COUNT').AsInteger;
  Local.EMULATORS.Arcade := ExtraFE_Query_Local.FieldByName('ARCADE').AsBoolean;
  Local.EMULATORS.Computers := ExtraFE_Query_Local.FieldByName('COMPUTERS').AsBoolean;
  Local.EMULATORS.Consoles := ExtraFE_Query_Local.FieldByName('CONSOLES').AsBoolean;
  Local.EMULATORS.Handhelds := ExtraFE_Query_Local.FieldByName('HANDHELDS').AsBoolean;
  Local.EMULATORS.Pinballs := ExtraFE_Query_Local.FieldByName('PINBALLS').AsBoolean;

  vQuery := 'SELECT * FROM ARCADE WHERE USER_ID=' + vUser_Num;
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Add(vQuery);
  ExtraFE_Query_Local.Open;
  ExtraFE_Query_Local.First;
  Local.EMULATORS.Arcade_D.Mame := ExtraFE_Query_Local.FieldByName('MAME').AsBoolean;
  Local.EMULATORS.Arcade_D.FBA := ExtraFE_Query_Local.FieldByName('FBA').AsBoolean;
  Local.EMULATORS.Arcade_D.Zinc := ExtraFE_Query_Local.FieldByName('ZINC').AsBoolean;
  Local.EMULATORS.Arcade_D.Daphne := ExtraFE_Query_Local.FieldByName('DAPHNE').AsBoolean;
  Local.EMULATORS.Arcade_D.Kronos := ExtraFE_Query_Local.FieldByName('KRONOS').AsBoolean;
  Local.EMULATORS.Arcade_D.Raine := ExtraFE_Query_Local.FieldByName('RAINE').AsBoolean;
  Local.EMULATORS.Arcade_D.Model2 := ExtraFE_Query_Local.FieldByName('MODEL2').AsBoolean;
  Local.EMULATORS.Arcade_D.SuperModel := ExtraFE_Query_Local.FieldByName('SUPERMODEL').AsBoolean;
  Local.EMULATORS.Arcade_D.Demul := ExtraFE_Query_Local.FieldByName('DEMUL').AsBoolean;

  vQuery := 'SELECT * FROM COMPUTERS WHERE USER_ID=' + vUser_Num;
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Add(vQuery);
  ExtraFE_Query_Local.Open;
  ExtraFE_Query_Local.First;
  Local.EMULATORS.Computers_D.Acorn_Archimedes := ExtraFE_Query_Local.FieldByName('ACORN_ARCHIMEDES').AsBoolean;
  Local.EMULATORS.Computers_D.Amiga := ExtraFE_Query_Local.FieldByName('AMIGA').AsBoolean;
  Local.EMULATORS.Computers_D.Amstrad := ExtraFE_Query_Local.FieldByName('AMSTRAD').AsBoolean;
  Local.EMULATORS.Computers_D.Atari_800XL := ExtraFE_Query_Local.FieldByName('ATARI_800XL').AsBoolean;
  Local.EMULATORS.Computers_D.Atart_ST := ExtraFE_Query_Local.FieldByName('ATARI_ST').AsBoolean;
  Local.EMULATORS.Computers_D.Commodore_64 := ExtraFE_Query_Local.FieldByName('COMMODORE_64').AsBoolean;
  Local.EMULATORS.Computers_D.MsDos := ExtraFE_Query_Local.FieldByName('MSDOS').AsBoolean;
  Local.EMULATORS.Computers_D.PCWindows := ExtraFE_Query_Local.FieldByName('OLD_PC_WINDOWS').AsBoolean;
  Local.EMULATORS.Computers_D.Scummvm := ExtraFE_Query_Local.FieldByName('SCUMMVM').AsBoolean;
  Local.EMULATORS.Computers_D.Spectrum := ExtraFE_Query_Local.FieldByName('SPECTRUM').AsBoolean;
  Local.EMULATORS.Computers_D.X68000 := ExtraFE_Query_Local.FieldByName('X68000').AsBoolean;

  vQuery := 'SELECT * FROM CONSOLES WHERE USER_ID=' + vUser_Num;
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Add(vQuery);
  ExtraFE_Query_Local.Open;
  ExtraFE_Query_Local.First;
  Local.EMULATORS.Consoles_D.Panasonic_3DO := ExtraFE_Query_Local.FieldByName('3DO').AsBoolean;
  Local.EMULATORS.Consoles_D.Amiga_CD32 := ExtraFE_Query_Local.FieldByName('AMIGA_CD32').AsBoolean;
  Local.EMULATORS.Consoles_D.Atari_2600 := ExtraFE_Query_Local.FieldByName('ATARI_2600').AsBoolean;
  Local.EMULATORS.Consoles_D.Atari_5200 := ExtraFE_Query_Local.FieldByName('ATARI_5200').AsBoolean;
  Local.EMULATORS.Consoles_D.Atari_7800 := ExtraFE_Query_Local.FieldByName('ATARI_7800').AsBoolean;
  Local.EMULATORS.Consoles_D.Atari_Jaguar := ExtraFE_Query_Local.FieldByName('ATARI_JAGUAR').AsBoolean;
  Local.EMULATORS.Consoles_D.Neo_Geo := ExtraFE_Query_Local.FieldByName('NEO_GEO').AsBoolean;
  Local.EMULATORS.Consoles_D.Neo_Geo_CD := ExtraFE_Query_Local.FieldByName('NEO_GEO_CD').AsBoolean;
  Local.EMULATORS.Consoles_D.NES := ExtraFE_Query_Local.FieldByName('NES').AsBoolean;
  Local.EMULATORS.Consoles_D.SNES := ExtraFE_Query_Local.FieldByName('SNES').AsBoolean;
  Local.EMULATORS.Consoles_D.Nintendo_64 := ExtraFE_Query_Local.FieldByName('NINTENDO_64').AsBoolean;
  Local.EMULATORS.Consoles_D.Gamecube := ExtraFE_Query_Local.FieldByName('GAMECUBE').AsBoolean;
  Local.EMULATORS.Consoles_D.Wii := ExtraFE_Query_Local.FieldByName('WII').AsBoolean;
  Local.EMULATORS.Consoles_D.Wii_U := ExtraFE_Query_Local.FieldByName('WII_U').AsBoolean;
  Local.EMULATORS.Consoles_D.Nintendo_Switch := ExtraFE_Query_Local.FieldByName('NINTENDO SWITCH').AsBoolean;
  Local.EMULATORS.Consoles_D.PC_Engine := ExtraFE_Query_Local.FieldByName('PC_ENGINE').AsBoolean;
  Local.EMULATORS.Consoles_D.PC_Engine_CD := ExtraFE_Query_Local.FieldByName('PC_ENGINE_CD').AsBoolean;
  Local.EMULATORS.Consoles_D.PX_FX := ExtraFE_Query_Local.FieldByName('PC_FX').AsBoolean;
  Local.EMULATORS.Consoles_D.Playstation := ExtraFE_Query_Local.FieldByName('PLAYSTATION').AsBoolean;
  Local.EMULATORS.Consoles_D.Playstation_2 := ExtraFE_Query_Local.FieldByName('PLAYSTATION_2').AsBoolean;
  Local.EMULATORS.Consoles_D.Playstation_3 := ExtraFE_Query_Local.FieldByName('PLAYSTATION_3').AsBoolean;
  Local.EMULATORS.Consoles_D.SG_1000 := ExtraFE_Query_Local.FieldByName('SG_1000').AsBoolean;
  Local.EMULATORS.Consoles_D.Master_System := ExtraFE_Query_Local.FieldByName('MASTER_SYSTEM').AsBoolean;
  Local.EMULATORS.Consoles_D.Mega_Drive := ExtraFE_Query_Local.FieldByName('MEGA_DRIVE').AsBoolean;
  Local.EMULATORS.Consoles_D.Mega_Drive_32X := ExtraFE_Query_Local.FieldByName('MEGA_DRIVE_32X').AsBoolean;
  Local.EMULATORS.Consoles_D.Mega_Drive_CD := ExtraFE_Query_Local.FieldByName('MEGA_DRIVE_CD').AsBoolean;
  Local.EMULATORS.Consoles_D.Saturn := ExtraFE_Query_Local.FieldByName('SATURN').AsBoolean;
  Local.EMULATORS.Consoles_D.Dreamcast := ExtraFE_Query_Local.FieldByName('DREAMCAST').AsBoolean;
  Local.EMULATORS.Consoles_D.XBOX := ExtraFE_Query_Local.FieldByName('XBOX').AsBoolean;
  Local.EMULATORS.Consoles_D.XBOX_ONE := ExtraFE_Query_Local.FieldByName('XBOX_ONE').AsBoolean;

  vQuery := 'SELECT * FROM HANDHELDS WHERE USER_ID=' + vUser_Num;
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Add(vQuery);
  ExtraFE_Query_Local.Open;
  ExtraFE_Query_Local.First;
  Local.EMULATORS.Handhelds_D.Atari_Lynx := ExtraFE_Query_Local.FieldByName('ATARI_LYNX').AsBoolean;
  Local.EMULATORS.Handhelds_D.Neo_Geo_Pocket := ExtraFE_Query_Local.FieldByName('NEO_GEO_POCKET').AsBoolean;
  Local.EMULATORS.Handhelds_D.GameGear := ExtraFE_Query_Local.FieldByName('GAMEGEAR').AsBoolean;
  Local.EMULATORS.Handhelds_D.Game_And_Watch := ExtraFE_Query_Local.FieldByName('GAME_AND_WATCH').AsBoolean;
  Local.EMULATORS.Handhelds_D.Gameboy := ExtraFE_Query_Local.FieldByName('GAMEBOY').AsBoolean;
  Local.EMULATORS.Handhelds_D.Gameboy_Color := ExtraFE_Query_Local.FieldByName('GAMEBOY_COLOR').AsBoolean;
  Local.EMULATORS.Handhelds_D.Gameboy_VirtualBoy := ExtraFE_Query_Local.FieldByName('GAMEBOY_VIRTUALBOY').AsBoolean;
  Local.EMULATORS.Handhelds_D.Gameboy_Advance := ExtraFE_Query_Local.FieldByName('GAMEBOY_ADVANCE').AsBoolean;
  Local.EMULATORS.Handhelds_D.Nintendo_DS := ExtraFE_Query_Local.FieldByName('NINTENDO_DS').AsBoolean;
  Local.EMULATORS.Handhelds_D.Nintendo_3DS := ExtraFE_Query_Local.FieldByName('NINTENDO_3DS').AsBoolean;
  Local.EMULATORS.Handhelds_D.PSP := ExtraFE_Query_Local.FieldByName('PSP').AsBoolean;
  Local.EMULATORS.Handhelds_D.PSP_Vita := ExtraFE_Query_Local.FieldByName('PSP_VITA').AsBoolean;
  Local.EMULATORS.Handhelds_D.Wonderswan := ExtraFE_Query_Local.FieldByName('WONDERSWAN').AsBoolean;

  vQuery := 'SELECT * FROM PINBALLS WHERE USER_ID=' + vUser_Num;
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Add(vQuery);
  ExtraFE_Query_Local.Open;
  ExtraFE_Query_Local.First;
  Local.EMULATORS.Pinballs_D.Visual_Pinball := ExtraFE_Query_Local.FieldByName('VISUAL_PINBALL').AsBoolean;
  Local.EMULATORS.Pinballs_D.Future_Pinball := ExtraFE_Query_Local.FieldByName('FUTURE_PINBALL').AsBoolean;

  vQuery := 'SELECT * FROM ADDONS WHERE USER_ID=' + vUser_Num;
  ExtraFE_Query_Local.Close;
  ExtraFE_Query_Local.SQL.Clear;
  ExtraFE_Query_Local.SQL.Add(vQuery);
  ExtraFE_Query_Local.Open;
  ExtraFE_Query_Local.First;
  Local.ADDONS.Active := ExtraFE_Query_Local.FieldByName('ACTIVE').AsInteger;
  Local.ADDONS.Count := ExtraFE_Query_Local.FieldByName('COUNT').AsInteger;
  Local.ADDONS.Time := ExtraFE_Query_Local.FieldByName('TIME').AsBoolean;
  Local.ADDONS.Calendar := ExtraFE_Query_Local.FieldByName('CALENDAR').AsBoolean;
  Local.ADDONS.Weather := ExtraFE_Query_Local.FieldByName('WEATHER').AsBoolean;
  Local.ADDONS.Soundplayer := ExtraFE_Query_Local.FieldByName('SOUNDPLAYER').AsBoolean;
  Local.ADDONS.Azplay := ExtraFE_Query_Local.FieldByName('AZPLAY').AsBoolean;
end;

function Find_User_Online_Num(vUser_ID: String): Integer;
begin
  ExtraFE_Query.Close;
  ExtraFE_Query.SQL.Clear;
  ExtraFE_Query.SQL.Add('SELECT * FROM USERS WHERE USER_ID=' + vUser_ID);
  ExtraFE_Query.ExecSQL;
  ExtraFE_Query.Open;
  ExtraFE_Query.First;
  Result := ExtraFE_Query.FieldByName('NUM').AsInteger;
end;

procedure update_time;
var
  vCurFinal: String;
  vIP: TJsonValue;
  vIP_Value: String;
begin
  vCurFinal := FormatDateTime('dd/mm/yyyy  hh:mm:ss ampm', now);
  if uDB_AUser.Online.Active = 1 then
  begin
    vIP := uInternet_files.JSONValue('Register_IP_', 'http://ipinfo.io/json', TRESTRequestMethod.rmGET);
    vIP_Value := vIP.GetValue<String>('ip');
    uDB.Query_Update_Online('USERS', 'IP', vIP_Value, Online.Num.ToString);
    uDB.Query_Update(uDB.ExtraFE_Query_Local, 'users', 'IP', vIP_Value, 'USER_ID', Local.Num.ToString);
    uDB_AUser.Local.IP := vIP_Value;
    uDB.Query_Update_Online('USERS', 'LAST_VISIT', vCurFinal, Online.Num.ToString);
    uDB.Query_Update(uDB.ExtraFE_Query_Local, 'users', 'LAST_VISIT_ONLINE', vCurFinal, 'USER_ID', Local.Num.ToString);
  end;

  uDB.Query_Update(uDB.ExtraFE_Query_Local, 'users', 'LAST_VISIT', 'USER_ID',  vCurFinal, Local.Num.ToString);
end;

procedure Temp_User;
begin
  { uDB_AUser.Online.Num := 0;
    uDB_AUser.Online.Username := 'JohnDoe';
    uDB_AUser.Online.Password := '123456';
    uDB_AUser.Online.Email := 'JohnDoe@temp.com';
    uDB_AUser.Online.IP := '100.100.100.100';
    uDB_AUser.Online.Name := 'Jonh';
    uDB_AUser.Online.Surname := 'Doe';
    uDB_AUser.Online.Avatar := '0';
    uDB_AUser.Online.Registered := '00:00:00:00';
    uDB_AUser.Online.Last_Visit := '00:00:00:00'; }
end;

end.
