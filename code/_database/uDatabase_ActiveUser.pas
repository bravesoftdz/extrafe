unit uDatabase_ActiveUser;

interface
uses
  System.Classes,
  System.SysUtils;

  procedure uDatabase_Active_User_Collect_Info_From_Database;

implementation
uses
  loading,
  uLoad,
  uLoad_UserAccount,
  uDatabase_SQLCommands;

procedure uDatabase_Active_User_Collect_Info_From_Database;
begin
  user.data.Name:= uDatabase_SQLCommands_Get_RealName(user.data.Database_Num);
  user.data.Surname:= uDatabase_SQLCommands_Get_SurName(user.data.Database_Num);
  user.data.Email:= uDatabase_SQLCommands_Get_Email(user.data.Database_Num);
  user.data.Last_Date_Visit:= uDatabase_SQLCommands_Get_LastDateVisit(user.data.Database_Num);
  user.data.Last_Time_Visit:= uDatabase_SQLCommands_Get_LastTimeVisit(user.data.Database_Num);
  user.data.Country:= uDatabase_SQLCommands_Get_Country(user.data.Database_Num);
  user.data.Country_Code:= uDatabase_SQLCommands_Get_Country_Code(user.data.Database_Num);
  user.data.Genre:= uDatabase_SQLCommands_Get_Genre(user.data.Database_Num);
  user.data.Last_Game_Play:= uDatabase_SQLCommands_Get_LastGame(user.data.Database_Num);
  user.data.Last_Emulator:= uDatabase_SQLCommands_Get_LastEmulator(user.data.Database_Num);
  user.data.Total_Time_Play:= uDatabase_SQLCommands_Get_TimePlay(user.data.Database_Num);
end;

end.
