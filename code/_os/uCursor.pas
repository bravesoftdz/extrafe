unit uCursor;

interface
uses
  FMX.Platform,FMX.Types,System.UITypes;

type
  ImCursor= interface
    ['{A4BAC63E-FF7C-4298-8229-C3C170BF274E}']
  end;

  TmCursor= class(TInterfacedObject, ImCursor)
    private
      cs: IFMXCursorService;
      mCursor: TCursor;
      mCursorDefault: Boolean;
    protected
      constructor Create;
      destructor Destroy; override;
    public
      class function setCursor: ImCursor;

      property CursorDefault: Boolean read mCursorDefault write mCursorDefault;

  end;

  procedure uMultiFMX_ChangeMyCursorTo(mCursor: SmallInt);

implementation

constructor TmCursor.Create;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXCursorService) then
    cs:= TPlatformServices.Current.GetPlatformService(IFMXCursorService) as IFMXCursorService;
  if Assigned(cs) then
    begin
      mCursor:= cs.GetCursor;
      cs.SetCursor(crHandPoint);
      mCursorDefault:= False;
    end;
end;

destructor TmCursor.Destroy;
begin
  if mCursorDefault= True then
    begin
      cs.SetCursor(mCursor);
    end;
  inherited;
end;

class function TmCursor.setCursor: ImCursor;
begin
  Result:= TmCursor.Create;
end;

procedure uMultiFMX_ChangeMyCursorTo(mCursor: SmallInt);
var
  cs: IFMXCursorService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXCursorService) then
    cs:= TPlatformServices.Current.GetPlatformService(IFMXCursorService) as IFMXCursorService;
  if Assigned(cs) then
    cs.SetCursor(mCursor);
end;

end.
