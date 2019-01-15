unit uDatabase;

interface

uses
  System.Classes,
  ZAbstractRODataset,
  ZAbstractDataset,
  ZDataset,
  ZAbstractConnection,
  ZConnection;

procedure uDatabase_Create;
function uDatabase_Connect: Boolean;
function uDatabase_Disconnect: Boolean;

var
  ExtraFE_DB: TZConnection;
  ExtraFE_Query: TZQuery;

implementation

uses
  uLoad_AllTypes,
  main;

procedure uDatabase_Create;
begin
  ExtraFE_DB := TZConnection.Create(Main_Form);
  ExtraFE_DB.Name := 'ExtraFE_Database';
  ExtraFE_DB.Protocol:= 'mysql';
  ExtraFE_DB.LibraryLocation:= extrafe.prog.Paths.Lib+ 'libmysql.dll';
  ExtraFE_DB.HostName := '192.168.2.4'; // http://az-creations.ddns.net/
  ExtraFE_DB.Port := 3306;
  ExtraFE_DB.User := 'Nikos_Azrael11';
  ExtraFE_DB.Password := '11azrael!';
  ExtraFE_DB.Database := 'extrafe_db_main';

  ExtraFE_Query:= TZQuery.Create(Main_Form);
  ExtraFE_Query.Name:= 'ExtraFE_Database_Query';
  ExtraFE_Query.Connection:= ExtraFE_DB;
end;

function uDatabase_Connect: Boolean;
begin
  ExtraFE_DB.Connect;
  Result := ExtraFE_DB.Connected;
end;

function uDatabase_Disconnect: Boolean;
begin
  ExtraFE_DB.Disconnect;
  Result := ExtraFE_DB.Connected;
end;

///////////////////


end.
