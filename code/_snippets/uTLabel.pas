unit uTLabel;

interface
uses
  System.Classes,
  System.UiTypes,
  System.UiConsts,
  FMX.StdCtrls;


  //HyperLink Mouse events
  procedure uTLabel_HyperLink_OnMouseEnter(Sender: TObject);
  procedure uTLabel_HyperLink_OnMouseLeave(Sender: TObject);

implementation

procedure uTLabel_HyperLink_OnMouseEnter(Sender: TObject);
begin
  TLabel(Sender).TextSettings.Font.Style:= TLabel(Sender).TextSettings.Font.Style+ [TFontStyle.fsUnderline];
  TLabel(Sender).TextSettings.FontColor:= claDeepskyblue;
  TLabel(Sender).Cursor:= crHandPoint;
end;

procedure uTLabel_HyperLink_OnMouseLeave(Sender: TObject);
begin
  TLabel(Sender).TextSettings.Font.Style:= TLabel(Sender).TextSettings.Font.Style- [TFontStyle.fsUnderline];
  TLabel(Sender).TextSettings.FontColor:= claBlack;
  TLabel(Sender).Cursor:= crDefault;
end;

end.
