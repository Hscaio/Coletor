unit UClass.Controller.SolicitacaoColeta;

interface

uses System.SysUtils,
     System.Math,
     System.Generics.Collections,
     UClass.Model.SolicitacaoColeta,
     UClass.Model.Endereco,
     UClass.Model.Usuario,
     UClass.DAO.Endereco,
     UClass.DAO.SolicitacaoColeta,
     UClass.DAO.Usuario;

type
   IControllerSolicitacaoColeta = interface
   ['{DCA1B1C0-97CF-446A-8953-2FCC180C2308}']
       function SolicitarColeta(aCodEndereco : Integer) : TSolicitacaoColeta;
      procedure CancelarColeta(aCodColeta : Integer);
       function AvaliarColeta(aCodColeta : Integer; aAvalicao : Integer; aComentario : String) : TSolicitacaoColeta;
       function ConcluirColeta(aCodColeta : Integer; aCodColetor : Integer) : TSolicitacaoColeta;
       function HistoricoUsuario(aCodUsurio : Integer): TObjectList<TSolicitacaoColeta>;
       function HistoricoColetor(aCodColetor : Integer): TObjectList<TSolicitacaoColeta>;
   end;

   TControllerSolicitacaoColeta = class(TInterfacedObject, IControllerSolicitacaoColeta)
   public
       function SolicitarColeta(aCodEndereco : Integer) : TSolicitacaoColeta;
      procedure CancelarColeta(aCodColeta : Integer);
       function AvaliarColeta(aCodColeta : Integer; aAvalicao : Integer; aComentario : String) : TSolicitacaoColeta;
       function ConcluirColeta(aCodColeta : Integer; aCodColetor : Integer) : TSolicitacaoColeta;
       function HistoricoUsuario(aCodUsurio : Integer): TObjectList<TSolicitacaoColeta>;
       function HistoricoColetor(aCodColetor : Integer): TObjectList<TSolicitacaoColeta>;
   end;

implementation

{ TControllerSolicitacaoColeta }

function TControllerSolicitacaoColeta.AvaliarColeta(aCodColeta,
  aAvalicao: Integer; aComentario: String) : TSolicitacaoColeta;
var LDAO : TDAOSolicitacaoColeta;
begin
   Result := nil;
   LDAO := TDAOSolicitacaoColeta.Create;
   try
      Result := LDAO.Get(aCodColeta);

      if not Assigned(Result) then
         raise Exception.Create('Não foi localizado a solicitação de coleta informada');

      if Result.Avalicao > 0 then
         raise Exception.Create('A coleta já foi avaliada');

      if (aAvalicao < 1) and (aAvalicao > 5) then
         raise Exception.Create('A avaliação deve ser entre 1 e 5');

      Result.Avalicao   := aAvalicao;
      Result.Comentario := aComentario;
      LDAO.Update(Result);
   finally
      FreeAndNil(LDAO);
   end;
end;

procedure TControllerSolicitacaoColeta.CancelarColeta(aCodColeta: Integer);
var LDAO : TDAOSolicitacaoColeta;
    LColeta : TSolicitacaoColeta;
begin
   LColeta := nil;
   LDAO := TDAOSolicitacaoColeta.Create;
   try
      LColeta := LDAO.Get(aCodColeta);

      if not Assigned(LColeta) then
         raise Exception.Create('Não foi localizado a solicitação de coleta informada');

      if LColeta.Status = TStatusSolicitacaoColeta.sscConcluido then
         raise Exception.Create('Não é possível cancelar uma solicitação de coleta no status Concluído');

      LColeta.Status := TStatusSolicitacaoColeta.sscCancelado;
      LDAO.Update(LColeta);
   finally
      FreeAndNil(LDAO);

      if Assigned(LColeta) then
         FreeAndNil(LColeta);
   end;
end;

function TControllerSolicitacaoColeta.ConcluirColeta(
  aCodColeta: Integer; aCodColetor : Integer): TSolicitacaoColeta;
var LDAOSol : TDAOSolicitacaoColeta;
    LDAOUsu : TDAOUsuario;
    LDAOEnd : TDAOEndereco;
    LUsuario : TUsuario;
    LEndereco : TEndereco;
begin
   Result := nil;
   LDAOSol := TDAOSolicitacaoColeta.Create;
   LDAOUsu := TDAOUsuario.Create;
   LDAOEnd := TDAOEndereco.Create;
   try
      LUsuario := LDAOUsu.Usuario(aCodColetor);

      if not Assigned(LUsuario) then
         raise Exception.Create('Coletor informado não foi localizado');

      if LUsuario.Tipo <> TTipoUsuario.ttuColetor then
         raise Exception.Create('Usuário informado para concluir a coleta não é um coletor');

      Result := LDAOSol.Get(aCodColeta);

      if not Assigned(Result) then
         raise Exception.Create('Não foi localizado a solicitação de coleta informada');

      if Result.Status <> TStatusSolicitacaoColeta.sscPendende then
         raise Exception.Create('Solicitação de coleta deve estar como Pendente para Concluir a coleta');

      LEndereco := LDAOEnd.Get(Result.Endereco);

      if not Assigned(LEndereco) then
         raise Exception.Create('Não foi localizado o endereço da coleta');

      Result.Status      := TStatusSolicitacaoColeta.sscConcluido;
      Result.Coletor     := LUsuario.Codigo;
      Result.LogEndereco := LEndereco.Endereco + ', ' + LEndereco.Numero;
      Result.LogBairro   := LEndereco.Bairro + ' - ' + LEndereco.Cidade + '/' + LEndereco.Estado;
      LDAOSol.Update(Result);
   finally
      FreeAndNil(LDAOSol);
      FreeAndNil(LDAOUsu);
      FreeAndNil(LDAOEnd);
   end;
end;
function TControllerSolicitacaoColeta.HistoricoColetor(
  aCodColetor: Integer): TObjectList<TSolicitacaoColeta>;
var LDAOSolic : TDAOSolicitacaoColeta;
begin
   LDAOSolic := TDAOSolicitacaoColeta.Create;
   try
      Result := LDAOSolic.HistoricoColetor(aCodColetor);
   finally
      FreeAndNil(LDAOSolic);
   end;
end;

function TControllerSolicitacaoColeta.HistoricoUsuario(
  aCodUsurio: Integer): TObjectList<TSolicitacaoColeta>;
var LDAOSolic : TDAOSolicitacaoColeta;
begin
   LDAOSolic := TDAOSolicitacaoColeta.Create;
   try
      Result := LDAOSolic.HistoricoUsuario(aCodUsurio);
   finally
      FreeAndNil(LDAOSolic);
   end;
end;

function TControllerSolicitacaoColeta.SolicitarColeta(aCodEndereco: Integer) : TSolicitacaoColeta;
var LDAOSolic : TDAOSolicitacaoColeta;
    LDAOEnd : TDAOEndereco;
    LEndereco : TEndereco;
begin
   LDAOSolic := TDAOSolicitacaoColeta.Create;
   LDAOEnd := TDAOEndereco.Create;
   try
      LEndereco := LDAOEnd.Get(aCodEndereco);
      if not Assigned(LEndereco) then
         raise Exception.Create('Não foi localizado o endereço informado');

      Result := TSolicitacaoColeta.Create;
      Result.Endereco := aCodEndereco;
      Result.Status   := TStatusSolicitacaoColeta.sscPendende;
      LDAOSolic.Insert(Result);

      LEndereco.SolicitacaoColeta := Result;
      LDAOEnd.Update(LEndereco);
   finally
      FreeAndNil(LDAOSolic);
      FreeAndNil(LDAOEnd);
   end;
end;

end.
