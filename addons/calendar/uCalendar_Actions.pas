unit uCalendar_Actions;

interface
uses
  System.Classes;

procedure Get_Data;

implementation
uses
  uDB,
  uDB_AUser;

procedure Get_Data;
var
  vQuery: String;
begin
  vQuery := 'SELECT * FROM ADDON_CALENDAR';
  uDB.ExtraFE_Query_Local.Close;
  uDB.ExtraFE_Query_Local.SQL.Clear;
  uDB.ExtraFE_Query_Local.SQL.Add(vQuery);
  uDB.ExtraFE_Query_Local.Open;
  uDB.ExtraFE_Query_Local.First;

  uDB_AUser.Local.ADDONS.Calendar_D.Menu_Position:= uDB.ExtraFE_Query_Local.FieldByName('MENU_POSITION').AsInteger;

  uDB_AUser.Local.ADDONS.Names.Insert(uDB_AUser.Local.ADDONS.Calendar_D.Menu_Position, 'calendar');
end;

end.
