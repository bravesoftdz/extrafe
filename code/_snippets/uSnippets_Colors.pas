unit uSnippets_Colors;

interface
uses
  System.Classes,
  System.UiTypes,
  System.SysUtils;

  function uSnippets_Colors_Convert_ColorToHex(vColor: TAlphaColorRec): String;
  function uSnippets_Colors_Convert_HexToColor(vHexColor: String): TAlphaColorRec;

implementation

function uSnippets_Colors_Convert_ColorToHex(vColor: TAlphaColorRec): String;
begin
  Result:='$'+ IntToHex(vColor.A)+ IntToHex(vColor.R)+ IntToHex(vColor.G)+ IntToHex(vColor.B);
end;

function uSnippets_Colors_Convert_HexToColor(vHexColor: String): TAlphaColorRec;
begin
//complete the function
//  Result.A:=
end;

end.
