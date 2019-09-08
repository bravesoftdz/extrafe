unit uMain_Config_Profile_Machine;

interface

uses
  System.Classes,
  System.SysUtils,
  FMX.StdCtrls,
  IdStack;

procedure Load;
procedure Free;

implementation

uses
  uLoad_AllTypes,
  uMain_AllTypes,
  uDatabase_ActiveUser,
  uWindows;

procedure Load;
var
  vStack: TIdStack;
  vList: TIdStackLocalAddressList;
begin
  // vStack:= TIdStack.Create;
  // vList:= TIdStackLocalAddressList.Create;
  // vStack.GetLocalAddressList(vList);
  mainScene.Config.main.R.Profile.Machine.Panel := TPanel.Create(mainScene.Config.main.R.Profile.TabItem[2]);
  mainScene.Config.main.R.Profile.Machine.Panel.Name := 'Main_Config_Profile_Machine';
  mainScene.Config.main.R.Profile.Machine.Panel.Parent := mainScene.Config.main.R.Profile.TabItem[2];
  mainScene.Config.main.R.Profile.Machine.Panel.SetBounds(0, 0, mainScene.Config.main.R.Profile.TabControl.Width,
    mainScene.Config.main.R.Profile.TabControl.Height);
  mainScene.Config.main.R.Profile.Machine.Panel.Visible := True;

  mainScene.Config.main.R.Profile.Machine.OS.Box := TGroupBox.Create(mainScene.Config.main.R.Profile.Machine.Panel);
  mainScene.Config.main.R.Profile.Machine.OS.Box.Name := 'Main_Config_Profile_Machine_OS_Box';
  mainScene.Config.main.R.Profile.Machine.OS.Box.Parent := mainScene.Config.main.R.Profile.Machine.Panel;
  mainScene.Config.main.R.Profile.Machine.OS.Box.SetBounds(10, 10, 580, 210);
  mainScene.Config.main.R.Profile.Machine.OS.Box.Text := 'Operating System : ';
  mainScene.Config.main.R.Profile.Machine.OS.Box.Visible := True;

  mainScene.Config.main.R.Profile.Machine.OS.Info := TLabel.Create(mainScene.Config.main.R.Profile.Machine.OS.Box);
  mainScene.Config.main.R.Profile.Machine.OS.Info.Name := 'Main_Config_Profile_Machine_OS_Info';
  mainScene.Config.main.R.Profile.Machine.OS.Info.Parent := mainScene.Config.main.R.Profile.Machine.OS.Box;
  mainScene.Config.main.R.Profile.Machine.OS.Info.SetBounds(10, 20, 140, 24);
  mainScene.Config.main.R.Profile.Machine.OS.Info.Text := 'Information : ';
  mainScene.Config.main.R.Profile.Machine.OS.Info.Visible := True;

  mainScene.Config.main.R.Profile.Machine.OS.Info_V := TLabel.Create(mainScene.Config.main.R.Profile.Machine.OS.Box);
  mainScene.Config.main.R.Profile.Machine.OS.Info_V.Name := 'Main_Config_Profile_Machine_OS_Info_V';
  mainScene.Config.main.R.Profile.Machine.OS.Info_V.Parent := mainScene.Config.main.R.Profile.Machine.OS.Box;
  mainScene.Config.main.R.Profile.Machine.OS.Info_V.SetBounds(140, 20, 440, 24);
  mainScene.Config.main.R.Profile.Machine.OS.Info_V.Text := TOSVersion.ToString;
  mainScene.Config.main.R.Profile.Machine.OS.Info_V.Visible := True;

  mainScene.Config.main.R.Profile.Machine.OS.Architecture := TLabel.Create(mainScene.Config.main.R.Profile.Machine.OS.Box);
  mainScene.Config.main.R.Profile.Machine.OS.Architecture.Name := 'Main_Config_Profile_Machine_OS_Architecture';
  mainScene.Config.main.R.Profile.Machine.OS.Architecture.Parent := mainScene.Config.main.R.Profile.Machine.OS.Box;
  mainScene.Config.main.R.Profile.Machine.OS.Architecture.SetBounds(10, 60, 140, 24);
  mainScene.Config.main.R.Profile.Machine.OS.Architecture.Text := 'Architecture : ';
  mainScene.Config.main.R.Profile.Machine.OS.Architecture.Visible := True;

  mainScene.Config.main.R.Profile.Machine.OS.Architecture_V := TLabel.Create(mainScene.Config.main.R.Profile.Machine.OS.Box);
  mainScene.Config.main.R.Profile.Machine.OS.Architecture_V.Name := 'Main_Config_Profile_Machine_OS_Architecture_V';
  mainScene.Config.main.R.Profile.Machine.OS.Architecture_V.Parent := mainScene.Config.main.R.Profile.Machine.OS.Box;
  mainScene.Config.main.R.Profile.Machine.OS.Architecture_V.SetBounds(140, 60, 140, 24);
  mainScene.Config.main.R.Profile.Machine.OS.Architecture_V.Text := uWindows_OsArchitectureToStr(TOSVersion.Architecture);
  mainScene.Config.main.R.Profile.Machine.OS.Architecture_V.Visible := True;

  mainScene.Config.main.R.Profile.Machine.OS.VPlatform := TLabel.Create(mainScene.Config.main.R.Profile.Machine.OS.Box);
  mainScene.Config.main.R.Profile.Machine.OS.VPlatform.Name := 'Main_Config_Profile_Machine_OS_VPlatform';
  mainScene.Config.main.R.Profile.Machine.OS.VPlatform.Parent := mainScene.Config.main.R.Profile.Machine.OS.Box;
  mainScene.Config.main.R.Profile.Machine.OS.VPlatform.SetBounds(10, 84, 140, 24);
  mainScene.Config.main.R.Profile.Machine.OS.VPlatform.Text := 'Platform : ';
  mainScene.Config.main.R.Profile.Machine.OS.VPlatform.Visible := True;

  mainScene.Config.main.R.Profile.Machine.OS.VPlatform_V := TLabel.Create(mainScene.Config.main.R.Profile.Machine.OS.Box);
  mainScene.Config.main.R.Profile.Machine.OS.VPlatform_V.Name := 'Main_Config_Profile_Machine_OS_VPlatform_V';
  mainScene.Config.main.R.Profile.Machine.OS.VPlatform_V.Parent := mainScene.Config.main.R.Profile.Machine.OS.Box;
  mainScene.Config.main.R.Profile.Machine.OS.VPlatform_V.SetBounds(140, 84, 140, 24);
  mainScene.Config.main.R.Profile.Machine.OS.VPlatform_V.Text := uWindows_OsPlatformToStr(TOSVersion.Platform) + ' ' +
    IntToStr(uWindoes_OsPlatformPointerToInt) + ' bit';
  mainScene.Config.main.R.Profile.Machine.OS.VPlatform_V.Visible := True;

  mainScene.Config.main.R.Profile.Machine.OS.Operating_System := TLabel.Create(mainScene.Config.main.R.Profile.Machine.OS.Box);
  mainScene.Config.main.R.Profile.Machine.OS.Operating_System.Name := 'Main_Config_Profile_Machine_OS_Operating_System';
  mainScene.Config.main.R.Profile.Machine.OS.Operating_System.Parent := mainScene.Config.main.R.Profile.Machine.OS.Box;
  mainScene.Config.main.R.Profile.Machine.OS.Operating_System.SetBounds(10, 108, 140, 24);
  mainScene.Config.main.R.Profile.Machine.OS.Operating_System.Text := 'Operating System : ';
  mainScene.Config.main.R.Profile.Machine.OS.Operating_System.Visible := True;

  mainScene.Config.main.R.Profile.Machine.OS.Operating_System_V := TLabel.Create(mainScene.Config.main.R.Profile.Machine.OS.Box);
  mainScene.Config.main.R.Profile.Machine.OS.Operating_System_V.Name := 'Main_Config_Profile_Machine_OS_Operating_System_V';
  mainScene.Config.main.R.Profile.Machine.OS.Operating_System_V.Parent := mainScene.Config.main.R.Profile.Machine.OS.Box;
  mainScene.Config.main.R.Profile.Machine.OS.Operating_System_V.SetBounds(140, 108, 140, 24);
  mainScene.Config.main.R.Profile.Machine.OS.Operating_System_V.Text := TOSVersion.Name;
  mainScene.Config.main.R.Profile.Machine.OS.Operating_System_V.Visible := True;

  mainScene.Config.main.R.Profile.Machine.OS.Major := TLabel.Create(mainScene.Config.main.R.Profile.Machine.OS.Box);
  mainScene.Config.main.R.Profile.Machine.OS.Major.Name := 'Main_Config_Profile_Machine_OS_Major';
  mainScene.Config.main.R.Profile.Machine.OS.Major.Parent := mainScene.Config.main.R.Profile.Machine.OS.Box;
  mainScene.Config.main.R.Profile.Machine.OS.Major.SetBounds(10, 132, 140, 24);
  mainScene.Config.main.R.Profile.Machine.OS.Major.Text := 'Major : ';
  mainScene.Config.main.R.Profile.Machine.OS.Major.Visible := True;

  mainScene.Config.main.R.Profile.Machine.OS.Major_V := TLabel.Create(mainScene.Config.main.R.Profile.Machine.OS.Box);
  mainScene.Config.main.R.Profile.Machine.OS.Major_V.Name := 'Main_Config_Profile_Machine_OS_Major_V';
  mainScene.Config.main.R.Profile.Machine.OS.Major_V.Parent := mainScene.Config.main.R.Profile.Machine.OS.Box;
  mainScene.Config.main.R.Profile.Machine.OS.Major_V.SetBounds(140, 132, 140, 24);
  mainScene.Config.main.R.Profile.Machine.OS.Major_V.Text := IntToStr(TOSVersion.Major);
  mainScene.Config.main.R.Profile.Machine.OS.Major_V.Visible := True;

  mainScene.Config.main.R.Profile.Machine.OS.Minor := TLabel.Create(mainScene.Config.main.R.Profile.Machine.OS.Box);
  mainScene.Config.main.R.Profile.Machine.OS.Minor.Name := 'Main_Config_Profile_Machine_OS_Minor';
  mainScene.Config.main.R.Profile.Machine.OS.Minor.Parent := mainScene.Config.main.R.Profile.Machine.OS.Box;
  mainScene.Config.main.R.Profile.Machine.OS.Minor.SetBounds(10, 156, 140, 24);
  mainScene.Config.main.R.Profile.Machine.OS.Minor.Text := 'Minor : ';
  mainScene.Config.main.R.Profile.Machine.OS.Minor.Visible := True;

  mainScene.Config.main.R.Profile.Machine.OS.Minor_V := TLabel.Create(mainScene.Config.main.R.Profile.Machine.OS.Box);
  mainScene.Config.main.R.Profile.Machine.OS.Minor_V.Name := 'Main_Config_Profile_Machine_OS_Minor_V';
  mainScene.Config.main.R.Profile.Machine.OS.Minor_V.Parent := mainScene.Config.main.R.Profile.Machine.OS.Box;
  mainScene.Config.main.R.Profile.Machine.OS.Minor_V.SetBounds(140, 156, 140, 24);
  mainScene.Config.main.R.Profile.Machine.OS.Minor_V.Text := IntToStr(TOSVersion.Minor);
  mainScene.Config.main.R.Profile.Machine.OS.Minor_V.Visible := True;

  mainScene.Config.main.R.Profile.Machine.OS.Build := TLabel.Create(mainScene.Config.main.R.Profile.Machine.OS.Box);
  mainScene.Config.main.R.Profile.Machine.OS.Build.Name := 'Main_Config_Profile_Machine_OS_Build';
  mainScene.Config.main.R.Profile.Machine.OS.Build.Parent := mainScene.Config.main.R.Profile.Machine.OS.Box;
  mainScene.Config.main.R.Profile.Machine.OS.Build.SetBounds(10, 180, 140, 24);
  mainScene.Config.main.R.Profile.Machine.OS.Build.Text := 'Build : ';
  mainScene.Config.main.R.Profile.Machine.OS.Build.Visible := True;

  mainScene.Config.main.R.Profile.Machine.OS.Build_V := TLabel.Create(mainScene.Config.main.R.Profile.Machine.OS.Box);
  mainScene.Config.main.R.Profile.Machine.OS.Build_V.Name := 'Main_Config_Profile_Machine_OS_Build_V';
  mainScene.Config.main.R.Profile.Machine.OS.Build_V.Parent := mainScene.Config.main.R.Profile.Machine.OS.Box;
  mainScene.Config.main.R.Profile.Machine.OS.Build_V.SetBounds(140, 180, 140, 24);
  mainScene.Config.main.R.Profile.Machine.OS.Build_V.Text := IntToStr(TOSVersion.Build);
  mainScene.Config.main.R.Profile.Machine.OS.Build_V.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Net.Box := TGroupBox.Create(mainScene.Config.main.R.Profile.Machine.Panel);
  mainScene.Config.main.R.Profile.Machine.Net.Box.Name := 'Main_Config_Profile_Machine_Net_Box';
  mainScene.Config.main.R.Profile.Machine.Net.Box.Parent := mainScene.Config.main.R.Profile.Machine.Panel;
  mainScene.Config.main.R.Profile.Machine.Net.Box.SetBounds(10, 230, 580, 150);
  mainScene.Config.main.R.Profile.Machine.Net.Box.Text := 'Network : ';
  mainScene.Config.main.R.Profile.Machine.Net.Box.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Net.Internet := TLabel.Create(mainScene.Config.main.R.Profile.Machine.Net.Box);
  mainScene.Config.main.R.Profile.Machine.Net.Internet.Name := 'Main_Config_Profile_Machine_Net_Internet';
  mainScene.Config.main.R.Profile.Machine.Net.Internet.Parent := mainScene.Config.main.R.Profile.Machine.Net.Box;
  mainScene.Config.main.R.Profile.Machine.Net.Internet.SetBounds(10, 20, 140, 24);
  mainScene.Config.main.R.Profile.Machine.Net.Internet.Text := 'Internet : ';
  mainScene.Config.main.R.Profile.Machine.Net.Internet.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Net.Internet_V := TLabel.Create(mainScene.Config.main.R.Profile.Machine.Net.Box);
  mainScene.Config.main.R.Profile.Machine.Net.Internet_V.Name := 'Main_Config_Profile_Machine_Net_Internet_V';
  mainScene.Config.main.R.Profile.Machine.Net.Internet_V.Parent := mainScene.Config.main.R.Profile.Machine.Net.Box;
  mainScene.Config.main.R.Profile.Machine.Net.Internet_V.SetBounds(140, 20, 440, 24);
  if uWindows_IsConected_ToInternet then
    mainScene.Config.main.R.Profile.Machine.Net.Internet_V.Text := 'Connected'
  else
    mainScene.Config.main.R.Profile.Machine.Net.Internet_V.Text := 'Disconnected';
  mainScene.Config.main.R.Profile.Machine.Net.Internet_V.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Net.Local_IP := TLabel.Create(mainScene.Config.main.R.Profile.Machine.Net.Box);
  mainScene.Config.main.R.Profile.Machine.Net.Local_IP.Name := 'Main_Config_Profile_Machine_Net_Local_IP';
  mainScene.Config.main.R.Profile.Machine.Net.Local_IP.Parent := mainScene.Config.main.R.Profile.Machine.Net.Box;
  mainScene.Config.main.R.Profile.Machine.Net.Local_IP.SetBounds(10, 44, 140, 24);
  mainScene.Config.main.R.Profile.Machine.Net.Local_IP.Text := 'Local IP : ';
  mainScene.Config.main.R.Profile.Machine.Net.Local_IP.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Net.Local_IP_V := TLabel.Create(mainScene.Config.main.R.Profile.Machine.Net.Box);
  mainScene.Config.main.R.Profile.Machine.Net.Local_IP_V.Name := 'Main_Config_Profile_Machine_Net_Local_IP_V';
  mainScene.Config.main.R.Profile.Machine.Net.Local_IP_V.Parent := mainScene.Config.main.R.Profile.Machine.Net.Box;
  mainScene.Config.main.R.Profile.Machine.Net.Local_IP_V.SetBounds(140, 44, 140, 24);
  mainScene.Config.main.R.Profile.Machine.Net.Local_IP_V.Text := uWindows.GetIPAddress;
  mainScene.Config.main.R.Profile.Machine.Net.Local_IP_V.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Net.Public_IP := TLabel.Create(mainScene.Config.main.R.Profile.Machine.Net.Box);
  mainScene.Config.main.R.Profile.Machine.Net.Public_IP.Name := 'Main_Config_Profile_Machine_Net_Public_IP';
  mainScene.Config.main.R.Profile.Machine.Net.Public_IP.Parent := mainScene.Config.main.R.Profile.Machine.Net.Box;
  mainScene.Config.main.R.Profile.Machine.Net.Public_IP.SetBounds(10, 68, 140, 24);
  mainScene.Config.main.R.Profile.Machine.Net.Public_IP.Text := 'Public IP : ';
  mainScene.Config.main.R.Profile.Machine.Net.Public_IP.Visible := True;

  mainScene.Config.main.R.Profile.Machine.Net.Public_IP_V := TLabel.Create(mainScene.Config.main.R.Profile.Machine.Net.Box);
  mainScene.Config.main.R.Profile.Machine.Net.Public_IP_V.Name := 'Main_Config_Profile_Machine_Net_Public_IP_V';
  mainScene.Config.main.R.Profile.Machine.Net.Public_IP_V.Parent := mainScene.Config.main.R.Profile.Machine.Net.Box;
  mainScene.Config.main.R.Profile.Machine.Net.Public_IP_V.SetBounds(140, 68, 140, 24);
  mainScene.Config.main.R.Profile.Machine.Net.Public_IP_V.Text := user_Active_Online.IP;
  mainScene.Config.main.R.Profile.Machine.Net.Public_IP_V.Visible := True;
end;

procedure Free;
begin
  FreeAndNil(mainScene.Config.main.R.Profile.Machine.Panel);
end;

end.
