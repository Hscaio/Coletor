unit UClass.Horse.Bussines;

interface

uses Horse,
     UClass.Horse.Usuario,
     UClass.Horse.Endereco;

type
   IBussinessHorse = interface
   ['{1425F1CA-0D27-42A6-B85E-ED222835AEFC}']
      function GetPort: Integer;
      procedure SetPort(const Value: Integer);

      procedure Registering;
      procedure Start;
      procedure Stop;

      property Port : Integer read GetPort write SetPort;
   end;

   TBussinessHorse = class(TInterfacedObject, IBussinessHorse)
   strict private class var
      FInstance : IBussinessHorse;
   private
      FPort : Integer;
      function GetPort: Integer;
      procedure SetPort(const Value: Integer);
   public
      class function GetInstance : IBussinessHorse;

      procedure Registering;
      procedure Start;
      procedure Stop;

      property Port : Integer read GetPort write SetPort default 8080;
   end;

implementation

{ TBussinesHorse }

class function TBussinessHorse.GetInstance: IBussinessHorse;
begin
   if not Assigned(FInstance) then
      FInstance := TBussinessHorse.Create;

   Result := FInstance;
end;

function TBussinessHorse.GetPort: Integer;
begin
   Result := FPort;
end;

procedure TBussinessHorse.Registering;
begin
  THorseUsuario.Registering;
  THorseEndereco.Registering;
end;

procedure TBussinessHorse.SetPort(const Value: Integer);
begin
   FPort := Value;
end;

procedure TBussinessHorse.Start;
begin
   THorse.Listen(FPort);
end;

procedure TBussinessHorse.Stop;
begin
   THorse.StopListen;
end;

end.
