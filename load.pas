unit load;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf, FireDAC.Phys,
  FireDAC.Phys.SQLite;

type
  TLoading = class(TForm)
    SQLite_DriverLink: TFDPhysSQLiteDriverLink;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Loading: TLoading;

implementation

{$R *.fmx}

uses
  uLoad_AllTypes,
  uwindows,
  uLoad_SetAll,
  uLoad;

procedure TLoading.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ReportMemoryLeaksOnShutdown := False;
end;

procedure TLoading.FormCreate(Sender: TObject);
var
  iRetCode: Integer;
begin
  // if CPUID.CpuType <> CPU_TYPE_INTEL then
  // SetEnvironmentVar('KMP_AFFINITY', 'disabled');


  // if kmp then

  // iRetCode = _putenv( "KMP_AFFINITY=disabled" );
  // if( iRetCode == 0 )
  // printf( "KMP_AFFINITY=%sn", getenv( "KMP_AFFINITY" ) )
  // else
  // printf( "Error: Failed to Set Environment Variable KMP_AFFINITYn" );
  Default_Load := False;
  uLoad.Prepare;
end;

end.