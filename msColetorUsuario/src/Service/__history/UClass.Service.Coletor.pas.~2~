unit UClass.Service.Coletor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs;

type
  TColetor = class(TService)
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  Coletor: TColetor;

implementation

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  Coletor.Controller(CtrlCode);
end;

function TColetor.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

end.
