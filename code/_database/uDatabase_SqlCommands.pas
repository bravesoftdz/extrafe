unit uDatabase_SqlCommands;

interface

uses
  System.Classes,
  System.SysUtils;

function uDatabase_SQLCommands_Count_Records: Integer;
function uDatabase_SQLCommands_Get_UserName(vRecNum: Integer): String;
function uDatabase_SQLCommands_Get_Password(vRecNum: Integer): String;
function uDatabase_SQLCommands_Get_Avatar(vRecNum: Integer): String;
function uDatabase_SQLCommands_Get_RealName(vRecNum: Integer): String;
function uDatabase_SQLCommands_Get_SurName(vRecNum: Integer): String;
function uDatabase_SQLCommands_Get_Email(vRecNum: Integer): String;
function uDatabase_SQLCommands_Get_LastDateVisit(vRecNum: Integer): String;
function uDatabase_SQLCommands_Get_LastTimeVisit(vRecNum: Integer): String;
function uDatabase_SQLCommands_Get_Country(vRecNum: Integer): String;
function uDatabase_SQLCommands_Get_Country_Code(vRecNum: Integer): String;
function uDatabase_SQLCommands_Get_Genre(vRecNum: Integer): String;
function uDatabase_SQLCommands_Get_LastGame(vRecNum: Integer): String;
function uDatabase_SQLCommands_Get_LastEmulator(vRecNum: Integer): String;
function uDatabase_SQLCommands_Get_TimePlay(vRecNum: Integer): String;

function uDatabase_Is_User_Exists(vUser: string): Boolean;
function uDatabase_Is_Password_Correct_For_User(vUser, vPassword: string): Boolean;
procedure uDatabase_Change_Avatar(mNum: Integer);
procedure uDatabase_Change_Password(vPassword: WideString);

implementation

uses
  loading,
  uload,
  uLoad_AllTypes,
  main,
  uLoad_UserAccount,
  uDatabase;

function uDatabase_Is_User_Exists(vUser: string): Boolean;
var
  vRows: Integer;
  vCUser: String;
  vCUser_Avatar: String;
  vi: Integer;
begin
  Result := False;
  vRows := -1;
  vRows := uDatabase_SQLCommands_Count_Records;
  if vRows <> -1 then
    for vi := 0 to vRows - 1 do
    begin
      vCUser := uDatabase_SQLCommands_Get_UserName(vi);
      if vUser = vCUser then
      begin
        Result := True;
        user.data.Database_Num := vi;
        user.data.Username := vCUser;
        vCUser_Avatar := uDatabase_SQLCommands_Get_Avatar(vi);
        user.data.Avatar := vCUser_Avatar;
        ex_load.Login.Avatar.Bitmap.LoadFromFile(ex_main.Paths.Avatar_Images + vCUser_Avatar + '.png');
        Break
      end;
    end;
end;

function uDatabase_Is_Password_Correct_For_User(vUser, vPassword: string): Boolean;
var
  vCPassword: String;
begin
  Result := False;
  vCPassword := uDatabase_SQLCommands_Get_Password(user.data.Database_Num);
  if vCPassword = vPassword then
  begin
    user.data.Password := vCPassword;
    Result := True;
  end
end;

procedure uDatabase_Change_Avatar(mNum: Integer);
begin
  ExtraFE_Query.Close;
  ExtraFE_Query.SQL.Clear;
  ExtraFE_Query.SQL.Add('UPDATE USER SET AVATAR=' + IntToStr(mNum) + ' WHERE ''A/A''=' +
    IntToStr(user.data.Database_Num));
  ExtraFE_Query.ExecSQL;
  user.data.Avatar := IntToStr(mNum);
end;

procedure uDatabase_Change_Password(vPassword: WideString);
begin
  ExtraFE_Query.Close;
  ExtraFE_Query.SQL.Clear;
  ExtraFE_Query.SQL.Add('UPDATE USER SET PASSWORD=''' + vPassword + ''' WHERE ''A/A''=' +
    IntToStr(user.data.Database_Num));
  ExtraFE_Query.ExecSQL;
  user.data.Password := vPassword;
end;

function uDatabase_SQLCommands_Count_Records: Integer;
begin
  ExtraFE_Query.Close;
  ExtraFE_Query.SQL.Clear;
  ExtraFE_Query.SQL.Add('SELECT COUNT(*) as totalrecs FROM USER');
  ExtraFE_Query.Open;
  ExtraFE_Query.First;
  Result := ExtraFE_Query.FieldByName('totalrecs').AsInteger;
  ExtraFE_Query.Close;
end;

function uDatabase_SQLCommands_Get_UserName(vRecNum: Integer): String;
begin
  ExtraFE_Query.Close;
  ExtraFE_Query.SQL.Clear;
  ExtraFE_Query.SQL.Add('SELECT NICKNAME as username FROM USER WHERE ''A/A''=' + vRecNum.ToString);
  ExtraFE_Query.Open;
  ExtraFE_Query.First;
  Result := ExtraFE_Query.FieldByName('username').AsString;
  ExtraFE_Query.Close;
end;

function uDatabase_SQLCommands_Get_Password(vRecNum: Integer): String;
begin
  ExtraFE_Query.Close;
  ExtraFE_Query.SQL.Clear;
  ExtraFE_Query.SQL.Add('SELECT PASSWORD as password FROM USER WHERE ''A/A''=' + vRecNum.ToString);
  ExtraFE_Query.Open;
  ExtraFE_Query.First;
  Result := ExtraFE_Query.FieldByName('password').AsString;
  ExtraFE_Query.Close;
end;

function uDatabase_SQLCommands_Get_Avatar(vRecNum: Integer): String;
begin
  ExtraFE_Query.Close;
  ExtraFE_Query.SQL.Clear;
  ExtraFE_Query.SQL.Add('SELECT AVATAR as avatar FROM USER WHERE ''A/A''=' + vRecNum.ToString);
  ExtraFE_Query.Open;
  ExtraFE_Query.First;
  Result := ExtraFE_Query.FieldByName('avatar').AsString;
  ExtraFE_Query.Close;
end;

function uDatabase_SQLCommands_Get_RealName(vRecNum: Integer): String;
begin
  ExtraFE_Query.Close;
  ExtraFE_Query.SQL.Clear;
  ExtraFE_Query.SQL.Add('SELECT NAME as realname FROM USER WHERE ''A/A''=' + vRecNum.ToString);
  ExtraFE_Query.Open;
  ExtraFE_Query.First;
  Result := ExtraFE_Query.FieldByName('realname').AsString;
  ExtraFE_Query.Close;
end;

function uDatabase_SQLCommands_Get_SurName(vRecNum: Integer): String;
begin
  ExtraFE_Query.Close;
  ExtraFE_Query.SQL.Clear;
  ExtraFE_Query.SQL.Add('SELECT SURNAME as surname FROM USER WHERE ''A/A''=' + vRecNum.ToString);
  ExtraFE_Query.Open;
  ExtraFE_Query.First;
  Result := ExtraFE_Query.FieldByName('surname').AsString;
  ExtraFE_Query.Close;
end;

function uDatabase_SQLCommands_Get_Email(vRecNum: Integer): String;
begin
  ExtraFE_Query.Close;
  ExtraFE_Query.SQL.Clear;
  ExtraFE_Query.SQL.Add('SELECT EMAIL as email FROM USER WHERE ''A/A''=' + vRecNum.ToString);
  ExtraFE_Query.Open;
  ExtraFE_Query.First;
  Result := ExtraFE_Query.FieldByName('email').AsString;
  ExtraFE_Query.Close;
end;

function uDatabase_SQLCommands_Get_LastDateVisit(vRecNum: Integer): String;
begin
  ExtraFE_Query.Close;
  ExtraFE_Query.SQL.Clear;
  ExtraFE_Query.SQL.Add('SELECT LAST_DATE_VISIT as datevisit FROM USER WHERE ''A/A''=' + vRecNum.ToString);
  ExtraFE_Query.Open;
  ExtraFE_Query.First;
  Result := ExtraFE_Query.FieldByName('datevisit').AsString;
  ExtraFE_Query.Close;
end;

function uDatabase_SQLCommands_Get_LastTimeVisit(vRecNum: Integer): String;
begin
  ExtraFE_Query.Close;
  ExtraFE_Query.SQL.Clear;
  ExtraFE_Query.SQL.Add('SELECT LAST_TIME_VISIT as timevisit FROM USER WHERE ''A/A''=' + vRecNum.ToString);
  ExtraFE_Query.Open;
  ExtraFE_Query.First;
  Result := ExtraFE_Query.FieldByName('timevisit').AsString;
  ExtraFE_Query.Close;
end;

function uDatabase_SQLCommands_Get_Country(vRecNum: Integer): String;
begin
  ExtraFE_Query.Close;
  ExtraFE_Query.SQL.Clear;
  ExtraFE_Query.SQL.Add('SELECT COUNTRY as country FROM USER WHERE ''A/A''=' + vRecNum.ToString);
  ExtraFE_Query.Open;
  ExtraFE_Query.First;
  Result := ExtraFE_Query.FieldByName('country').AsString;
  ExtraFE_Query.Close;
end;

function uDatabase_SQLCommands_Get_Country_Code(vRecNum: Integer): String;
begin
  ExtraFE_Query.Close;
  ExtraFE_Query.SQL.Clear;
  ExtraFE_Query.SQL.Add('SELECT COUNTRY_CODE as code FROM USER WHERE ''A/A''=' + vRecNum.ToString);
  ExtraFE_Query.Open;
  ExtraFE_Query.First;
  Result := ExtraFE_Query.FieldByName('code').AsString;
  ExtraFE_Query.Close;
end;

function uDatabase_SQLCommands_Get_Genre(vRecNum: Integer): String;
begin
  ExtraFE_Query.Close;
  ExtraFE_Query.SQL.Clear;
  ExtraFE_Query.SQL.Add('SELECT GENRE as genre FROM USER WHERE ''A/A''=' + vRecNum.ToString);
  ExtraFE_Query.Open;
  ExtraFE_Query.First;
  Result := ExtraFE_Query.FieldByName('genre').AsString;
  ExtraFE_Query.Close;
end;

function uDatabase_SQLCommands_Get_LastGame(vRecNum: Integer): String;
begin
  ExtraFE_Query.Close;
  ExtraFE_Query.SQL.Clear;
  ExtraFE_Query.SQL.Add('SELECT LAST_GAME_PLAY as lastgame FROM USER WHERE ''A/A''=' + vRecNum.ToString);
  ExtraFE_Query.Open;
  ExtraFE_Query.First;
  Result := ExtraFE_Query.FieldByName('lastgame').AsString;
  ExtraFE_Query.Close;
end;

function uDatabase_SQLCommands_Get_LastEmulator(vRecNum: Integer): String;
begin
  ExtraFE_Query.Close;
  ExtraFE_Query.SQL.Clear;
  ExtraFE_Query.SQL.Add('SELECT LAST_EMULATOR as lastemulator FROM USER WHERE ''A/A''=' + vRecNum.ToString);
  ExtraFE_Query.Open;
  ExtraFE_Query.First;
  Result := ExtraFE_Query.FieldByName('lastemulator').AsString;
  ExtraFE_Query.Close;
end;

function uDatabase_SQLCommands_Get_TimePlay(vRecNum: Integer): String;
begin
  ExtraFE_Query.Close;
  ExtraFE_Query.SQL.Clear;
  ExtraFE_Query.SQL.Add('SELECT TOTAL_PLAY_TIME as totalplay FROM USER WHERE ''A/A''=' + vRecNum.ToString);
  ExtraFE_Query.Open;
  ExtraFE_Query.First;
  Result := ExtraFE_Query.FieldByName('totalplay').AsString;
  ExtraFE_Query.Close;
end;

end.
