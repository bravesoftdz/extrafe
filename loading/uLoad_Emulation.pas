unit uLoad_Emulation;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Inifiles,
  FMX.Forms;

type TLOAD_EMU_TAB_DATA= record
  Prog_Path: String;
  Emu_Path: String;
  Emu_Name: String;
  Emu_Name_Exe: String;
  Active: Boolean;
  Categorie: Integer;
  Place_Num: Integer;
  Unique_Num: Integer;
  Installed: Boolean;
  Images_Path: String;
  Tab_Images_Path: String;
end;

procedure uLoad_Emulation_FirstTime;
procedure uLoad_Emulation_Load;

procedure uLoad_Emulation_LoadDefaults;
procedure uLoad_Emulation_SetTabs;

procedure uLoad_Emulation_CollectEmuData;
procedure uLoad_Emulation_Collect_Arcade_Mame;

implementation

uses
  loading,
  uLoad,
  uLoad_AllTypes,
  uEmu_Arcade_Mame;

procedure uLoad_Emulation_FirstTime;
begin
  CreateDir(extrafe.prog.Path + 'emu');
  // Arcade
  CreateDir(extrafe.prog.Path + 'emu\arcade');
  CreateDir(extrafe.prog.Path + 'emu\arcade\mame');
  CreateDir(extrafe.prog.Path + 'emu\arcade\mame\config');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Artworks');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Cabinets');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Control Panels');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Covers');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Flyers');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Fanart');
  CreateDir(extrafe.prog.Path + 'emu\arcade\medis\Game Over');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Icons');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Manuals');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Marquees');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Pcbs');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Snapshots');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Titles');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Artwork Preview');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Bosses');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Ends');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\How To');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Logos');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Scores');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Selects');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Stamps');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Versus');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Warnings');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Soundtracks');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Support Files');
  CreateDir(extrafe.prog.Path + 'emu\arcade\media\Videos');
  // Computers
  CreateDir(extrafe.prog.Path + 'emu\computers');
  // Consoles
  CreateDir(extrafe.prog.Path + 'emu\consoles');
  // Handhelds
  CreateDir(extrafe.prog.Path + 'emu\handhelds');
  // Pinball
  CreateDir(extrafe.prog.Path + 'emu\pinball');

  extrafe.ini.ini.WriteBool('Emulation', 'Active', true);
  emulation.Active := true;
  extrafe.ini.ini.WriteInteger('Emulation', 'Active_Num', -1);
  emulation.Active_Num := -1;
  extrafe.ini.ini.WriteInteger('Emulation', 'Unique_Num', -1);
  emulation.Unique_Num := -1;
  extrafe.ini.ini.WriteBool('Emulation', 'ShowCat', true);
  emulation.ShowCat := true;
end;

procedure uLoad_Emulation_Load;
begin
  emulation.Active := extrafe.ini.ini.ReadBool('Emulation', 'Active', emulation.Active);
  emulation.Active_Num := extrafe.ini.ini.ReadInteger('Emulation', 'Active_Num', emulation.Active_Num);
  emulation.Unique_Num := extrafe.ini.ini.ReadInteger('Emulation', 'Unique_Num', emulation.Unique_Num);
  emulation.ShowCat := extrafe.ini.ini.ReadBool('Emulation', 'ShowCat', emulation.ShowCat);
  emulation.Path := extrafe.prog.Path + 'emu\';

  // Create the emulators string multi array
  SetLength(emulation.Emu, 5);

  SetLength(emulation.Emu[0], 255);
  SetLength(emulation.Emu[1], 255);
  SetLength(emulation.Emu[2], 255);
  SetLength(emulation.Emu[3], 255);
  SetLength(emulation.Emu[4], 255);

  //

  emulation.Category[0].Active := true;
  emulation.Category[0].Active_Place := 0;
  emulation.Category[0].Name := 'Arcade';
  emulation.Category[0].Menu_Image_Path := emulation.Path + 'arcade\';
  emulation.Category[0].Menu_Image := 'arcade.png';
  emulation.Category[0].Second_Level := -1;
  emulation.Category[0].Installed := False;
  emulation.Category[0].Unique_Num := -1;

  emulation.Category[1].Active := true;
  emulation.Category[1].Active_Place := 1;
  emulation.Category[1].Name := 'Computers';
  emulation.Category[1].Menu_Image_Path := emulation.Path + 'computers\';
  emulation.Category[1].Menu_Image := 'computers.png';
  emulation.Category[1].Second_Level := -1;
  emulation.Category[1].Installed := False;
  emulation.Category[1].Unique_Num := -1;

  emulation.Category[2].Active := true;
  emulation.Category[2].Active_Place := 2;
  emulation.Category[2].Name := 'Consoles';
  emulation.Category[2].Menu_Image_Path := emulation.Path + 'consoles\';
  emulation.Category[2].Menu_Image := 'consoles.png';
  emulation.Category[2].Second_Level := -1;
  emulation.Category[2].Installed := False;
  emulation.Category[2].Unique_Num := -1;

  emulation.Category[3].Active := true;
  emulation.Category[3].Active_Place := 3;
  emulation.Category[3].Name := 'Handhelds';
  emulation.Category[3].Menu_Image_Path := emulation.Path + 'handhelds\';
  emulation.Category[3].Menu_Image := 'handhelds.png';
  emulation.Category[3].Second_Level := -1;
  emulation.Category[3].Installed := False;
  emulation.Category[3].Unique_Num := -1;

  emulation.Category[4].Active := true;
  emulation.Category[4].Active_Place := 4;
  emulation.Category[4].Name := 'Pinball';
  emulation.Category[4].Menu_Image_Path := emulation.Path + 'pinball\';
  emulation.Category[4].Menu_Image := 'pinballs.png';
  emulation.Category[4].Second_Level := -1;
  emulation.Category[4].Installed := False;
  emulation.Category[4].Unique_Num := -1;

  uLoad_Emulation_SetTabs;

  ex_load.Scene.Progress.Value:= 60;
end;

procedure uLoad_Emulation_SetTabs;
var
  vi, vk: integer;
begin
  for vi := 0 to 4 do
    for vk := 0 to 254 do
      emulation.Emu[vi, vk] := 'nil';

  if emulation.Active_Num = -1 then
  begin
    emulation.Arcade[0].Active := False;
  end
  else
  begin
    uLoad_Emulation_CollectEmuData;
    for vi := 0 to 4 do
      for vk := 0 to 254 do
        if emulation.Emu[vi, vk] <> 'nil' then
        begin
          inc(emulation.Category[vi].Second_Level, 1);
        end;
  end;
end;

procedure uLoad_Emulation_CollectEmuData;
begin
  uLoad_Emulation_Collect_Arcade_Mame;
end;

procedure uLoad_Emulation_LoadDefaults;
begin
  emulation.Active := extrafe.ini.ini.ReadBool('Emulators', 'Active', emulation.Active);
  emulation.Active_Num := extrafe.ini.ini.ReadInteger('Emulators', 'Active_Num', emulation.Active_Num);
  emulation.Unique_Num := extrafe.ini.ini.ReadInteger('Emulators', 'Unique_Num', emulation.Unique_Num);
  emulation.ShowCat := extrafe.ini.ini.ReadBool('Emulators', 'ShowCat', emulation.ShowCat);
end;

//Arcade Emulators Collection
procedure uLoad_Emulation_Collect_Arcade_Mame;
var
  vtempIni: TInifile;
  isActive: Boolean;
  vMenu_Image: String;
  vEmu: TLOAD_EMU_TAB_DATA;

begin
  if FileExists(extrafe.prog.Path + 'emu\arcade\mame\config\prog_mame.ini') then
  begin
    vtempIni := TInifile.Create(extrafe.prog.Path + 'emu\arcade\mame\config\prog_mame.ini');
    isActive := vtempIni.ReadBool('Emulation', 'Active', isActive);
    if isActive then
    begin
      vEmu.Emu_Name_Exe:= vtempIni.ReadString('Mame', 'mame_name', vEmu.Emu_Name_Exe);
      vEmu.Emu_Path := vtempIni.ReadString('Mame', 'mame_path', vEmu.Emu_Path);
      vEmu.Emu_Name := vtempIni.ReadString('Emulation', 'Emu_Name', vEmu.Emu_Name);
      vEmu.Place_Num := vtempIni.ReadInteger('Emulation', 'Place_Num', vEmu.Place_Num);
      vEmu.Images_Path:= vtempIni.ReadString('Emulation', 'TabPath', vEmu.Images_Path);
      vEmu.Tab_Images_Path:= vtempIni.ReadString('Emulation', 'TabPath', vEmu.Tab_Images_Path);
      vMenu_Image := vtempIni.ReadString('Emulation', 'Images', vMenu_Image);
      vEmu.Unique_Num := vtempIni.ReadInteger('Emulation', 'Unique_Num', vEmu.Unique_Num);
      vEmu.Installed := vtempIni.ReadBool('Emulation', 'Installed', vEmu.Installed);
      vEmu.Prog_Path := vtempIni.ReadString('PROG', 'Path', vEmu.Prog_Path);

      emulation.Emu[0, 0] := vEmu.Emu_Name;
      emulation.Arcade[0].Prog_Path := vEmu.Prog_Path;
      emulation.Arcade[0].Emu_Path := vEmu.Emu_Path;
      emulation.Arcade[0].Active := isActive;
      emulation.Arcade[0].Active_Place := vEmu.Place_Num;
      emulation.Arcade[0].Name := vEmu.Emu_Name;
      emulation.Arcade[0].Name_Exe:= vEmu.Emu_Name_Exe;
      emulation.Arcade[0].Menu_Image := vMenu_Image;
      emulation.Arcade[0].Menu_Image_Path := vEmu.Tab_Images_Path;
      emulation.Arcade[0].Second_Level := -1;
      emulation.Arcade[0].Unique_Num := vEmu.Unique_Num;
      emulation.Arcade[0].Installed := vEmu.Installed;

      uEmu_Arcade_Mame_Loading;
    end;
    FreeAndNil(vtempIni);
  end;
end;

end.
