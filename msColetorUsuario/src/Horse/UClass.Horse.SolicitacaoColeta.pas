unit UClass.Horse.SolicitacaoColeta;

interface

uses System.SysUtils,
     System.JSON,

     UClass.Utils.Crypt,

     Horse,
     Horse.Jhonson,

     UClass.Horse.Base,
     UClass.Model.SolicitacaoColeta,
     UClass.Controller.SolicitacaoColeta;

type

   THorseSolicitacaoColeta = class(THorseBase)
   public
      class procedure Registering; override;
   end;

implementation

{ THorseSolicitacaoColeta }

class procedure THorseSolicitacaoColeta.Registering;
begin
  inherited;

end;

end.
