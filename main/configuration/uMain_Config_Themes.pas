unit uMain_Config_Themes;

interface
uses
  System.Classes,
  System.SysUtils,
  FMX.Types,
  FMX.StdCtrls,
  FMX.Listbox;


  procedure uMain_Config_Themes_Create;

  procedure uMain_Config_Themes_LoadThemes_Names;
  procedure uMain_Config_Themes_ApplyTheme(mThemeName: string);

// DONE 1 -oNikos Kordas -cConfig_Themes: Change text colors to white depends of theme that used

implementation
uses
  main,
//  emu,
  uLoad,
  uLoad_AllTypes,
  uMain_SetAll,
  uMain_AllTypes,
  uMain_Mouse;

procedure uMain_Config_Themes_Create;
begin
  mainScene.Config.Main.R.Themes.Panel:= TPanel.Create(mainScene.Config.Main.R.Panel[5]);
  mainScene.Config.Main.R.Themes.Panel.Name:= 'Main_Config_Themes_Main_Panel';
  mainScene.Config.Main.R.Themes.Panel.Parent:= mainScene.Config.Main.R.Panel[5];
  mainScene.Config.Main.R.Themes.Panel.Align:= TAlignLayout.Client;
  mainScene.Config.Main.R.Themes.Panel.Visible:= True;

  mainScene.Config.Main.R.Themes.Info:= TLabel.Create(mainScene.Config.Main.R.Themes.Panel);
  mainScene.Config.Main.R.Themes.Info.Name:= 'Main_Config_Themes_Info_Label';
  mainScene.Config.Main.R.Themes.Info.Parent:=  mainScene.Config.Main.R.Themes.Panel;
  mainScene.Config.Main.R.Themes.Info.Width:= 300;
  mainScene.Config.Main.R.Themes.Info.Height:= 24;
  mainScene.Config.Main.R.Themes.Info.Position.X:= 10;
  mainScene.Config.Main.R.Themes.Info.Position.Y:= 10;
  mainScene.Config.Main.R.Themes.Info.Text:= 'Active theme: '+ extrafe.style.Name;
  mainScene.Config.Main.R.Themes.Info.Visible:= True;

  mainScene.Config.Main.R.Themes.Box_Header:= TLabel.Create(mainScene.Config.Main.R.Themes.Panel);
  mainScene.Config.Main.R.Themes.Box_Header.Name:= 'Main_Config_Themes_BoxHeader_Label';
  mainScene.Config.Main.R.Themes.Box_Header.Parent:=  mainScene.Config.Main.R.Themes.Panel;
  mainScene.Config.Main.R.Themes.Box_Header.Width:= 300;
  mainScene.Config.Main.R.Themes.Box_Header.Height:= 24;
  mainScene.Config.Main.R.Themes.Box_Header.Position.X:= 10;
  mainScene.Config.Main.R.Themes.Box_Header.Position.Y:= 200;
  mainScene.Config.Main.R.Themes.Box_Header.Text:= 'Choose theme';
  mainScene.Config.Main.R.Themes.Box_Header.Visible:= True;

  uMain_Config_Themes_LoadThemes_Names;

  mainScene.Config.Main.R.Themes.Box:= TComboBox.Create(mainScene.Config.Main.R.Themes.Panel);
  mainScene.Config.Main.R.Themes.Box.Name:= 'Main_Config_Themes_Combobox';
  mainScene.Config.Main.R.Themes.Box.Parent:= mainScene.Config.Main.R.Themes.Panel;
  mainScene.Config.Main.R.Themes.Box.Width:= mainScene.Config.Main.R.Themes.Panel.Width- 20;;
  mainScene.Config.Main.R.Themes.Box.Height:= 24;
  mainScene.Config.Main.R.Themes.Box.Position.X:= 10;
  mainScene.Config.Main.R.Themes.Box.Position.Y:= 224;
  mainScene.Config.Main.R.Themes.Box.Items:= extrafe.style.Names;
  mainScene.Config.Main.R.Themes.Box.Items.Insert(0, 'Default');
  mainScene.Config.Main.R.Themes.Box.ItemIndex:= 0;
  mainScene.Config.Main.R.Themes.Box.Visible:= True;

  mainScene.Config.Main.R.Themes.Apply:= TButton.Create(mainScene.Config.Main.R.Themes.Panel);
  mainScene.Config.Main.R.Themes.Apply.Name:= 'Main_Config_Themes_Apply';
  mainScene.Config.Main.R.Themes.Apply.Parent:= mainScene.Config.Main.R.Themes.Panel;
  mainScene.Config.Main.R.Themes.Apply.Width:= 100;
  mainScene.Config.Main.R.Themes.Apply.Height:= 30;
  mainScene.Config.Main.R.Themes.Apply.Position.X:= (mainScene.Config.Main.R.Themes.Panel.Width/ 2)- 50;
  mainScene.Config.Main.R.Themes.Apply.Position.Y:= mainScene.Config.Main.R.Themes.Panel.Height- 40;
  mainScene.Config.Main.R.Themes.Apply.Text:= 'Apply';
  mainScene.Config.Main.R.Themes.Apply.OnClick:= ex_main.input.mouse_config.Button.OnMouseClick;
  mainScene.Config.Main.R.Themes.Apply.Visible:= True;



//  Main_Form.Themes_Change_Theme.ItemIndex:= extrafe.style.Names.IndexOf(extrafe.style.Name)+ 1;
//  mainScene.Config.Main.R.Themes.Info.Text:= 'Active Theme : '+ extrafe.style.Name;
end;
////////////////////////////////////////////////////////////////////////////////
procedure uMain_Config_Themes_LoadThemes_Names;
var
  vRec: TSearchRec;
  vName: string;
begin
  extrafe.style.Names:= TStringList.Create;
  if FindFirst(extrafe.style.Path+ '*.style', faDirectory- faAnyFile, vRec)= 0 then
    try
      repeat
        vName:= vRec.Name;
        Delete(vName, Length(vName)- 5, 6);
        extrafe.style.Names.Add(vName);
      until FindNext(vRec)<> 0;
    finally
      system.SysUtils.FindClose(vRec);
    end;
end;

procedure uMain_Config_Themes_ApplyTheme(mThemeName: string);
begin
  if mThemeName= 'Air' then
    begin
      mainScene.Main.Style.LoadFromFile(extrafe.style.Path+ 'Air.Style');
      extrafe.ini.Ini.WriteString('Themes', 'Name', 'Air');
      extrafe.style.Name:= 'Air';
    end
  else if mThemeName= 'Amakrits' then
    begin
      mainScene.Main.Style.LoadFromFile(extrafe.style.Path+ 'Amakrits.Style');
      extrafe.ini.Ini.WriteString('Themes', 'Name', 'Amakrits');
      extrafe.style.Name:= 'Amakrits';
    end
  else if mThemeName= 'Dark' then
    begin
      mainScene.Main.Style.LoadFromFile(extrafe.style.Path+ 'Dark.Style');
      extrafe.ini.Ini.WriteString('Themes', 'Name', 'Dark');
      extrafe.style.Name:= 'Dark';
    end
  else if mThemeName= 'Light' then
    begin
      mainScene.Main.Style.LoadFromFile(extrafe.style.Path+ 'Light.Style');
      extrafe.ini.Ini.WriteString('Themes', 'Name', 'Light');
      extrafe.style.Name:= 'Light';
    end
  else
    begin
      mainScene.Main.Style:= nil;
      extrafe.ini.Ini.WriteString('Themes', 'Name', '');
      extrafe.style.Name:= '';
    end;
//  Main_Form.StyleName:= extrafe.style.Name;
end;



end.
