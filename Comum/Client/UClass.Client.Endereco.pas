unit UClass.Client.Endereco;

interface

uses System.SysUtils,
     System.JSON,
     System.Classes,
     System.Net.HttpClient,
     System.Net.HttpClientComponent,
     System.Generics.Collections,

     UClass.Client.Base.APP,
     UClass.Model.Response,
     UClass.Model.Endereco,
     UClass.Model.SolicitacaoColeta, UClass.Utils.Crypt;

type
  IClientEndereco = interface
  ['{147F3196-281F-40A6-A25A-44ABF0880069}']
     function DeletarEndereco(aCodigo : Integer) : TResponse<TEndereco>;
     function InserirEndereco(aEndereco : TEndereco) : TResponse<TEndereco>;
     function AtualizarEndereco(aEndereco : TEndereco) : TResponse<TEndereco>;
     function EnderecosDoUsuario(aCodUsuario : Integer) : TObjectList<TEndereco>;
     function ColetasDoUsuario(aCodUsuario : Integer) : TObjectList<TEndereco>;
     function SolicitarColeta(aEndereco : Integer) : TResponse<TSolicitacaoColeta>;
     function CancelarColeta(aEndereco : Integer) : TResponse<TSolicitacaoColeta>;
     function AvaliarColeta(aCodColeta : Integer; aAvalicao : Integer; aComentario : String) : TResponse<TSolicitacaoColeta>;
     function ConcluirColeta(aCodColeta, aCodColetor : Integer) : TResponse<TSolicitacaoColeta>;
     function HistoricoUsuario(aCodigo : Integer) : TObjectList<TSolicitacaoColeta>;
     function HistoricoColetor(aCodigo : Integer): TObjectList<TSolicitacaoColeta>;
  end;

  TClientEndereco = class(TClientBaseAPP, IClientEndereco)
  private class var FInstance : IClientEndereco;
  private
     constructor CreatePrivate;
  public
     class function GetInstance : IClientEndereco;

     function DeletarEndereco(aCodigo : Integer) : TResponse<TEndereco>;
     function InserirEndereco(aEndereco : TEndereco) : TResponse<TEndereco>;
     function AtualizarEndereco(aEndereco : TEndereco) : TResponse<TEndereco>;
     function EnderecosDoUsuario(aCodUsuario : Integer) : TObjectList<TEndereco>;
     function ColetasDoUsuario(aCodUsuario : Integer) : TObjectList<TEndereco>;
     function SolicitarColeta(aEndereco : Integer) : TResponse<TSolicitacaoColeta>;
     function CancelarColeta(aEndereco : Integer) : TResponse<TSolicitacaoColeta>;
     function AvaliarColeta(aCodColeta : Integer; aAvalicao : Integer; aComentario : String) : TResponse<TSolicitacaoColeta>;
     function ConcluirColeta(aCodColeta, aCodColetor : Integer) : TResponse<TSolicitacaoColeta>;
     function HistoricoUsuario(aCodigo : Integer) : TObjectList<TSolicitacaoColeta>;
     function HistoricoColetor(aCodigo : Integer): TObjectList<TSolicitacaoColeta>;
  end;

implementation

{ TClientEndereco }

function TClientEndereco.AtualizarEndereco(
  aEndereco: TEndereco): TResponse<TEndereco>;
var LHTTP: TNetHTTPClient;
    LResp : IHTTPResponse;
    LJSON : TJSONObject;
    LParam : TStringStream;
begin
   LJSON := nil;
   LParam := TStringStream.Create(aEndereco.ObjectToJSON.ToString,TEncoding.UTF8);
   LHTTP := TNetHTTPClient.Create(nil);
   try
      LHTTP.ConnectionTimeout := 15000;
      LHTTP.ContentType := 'application/json';
      LHTTP.AcceptEncoding := 'UTF-8';
      LResp := LHTTP.Put(GetURL('/AtualizarEndereco'),LParam);
      TratarExecption(LResp);

      LJSON := TJSONObject(TJSONObject.ParseJSONValue(LResp.ContentAsString));

      Result := TResponse<TEndereco>.Create;
      Result.JSONToObject(LJSON);
   finally
      FreeAndNil(LHTTP);

      if Assigned(LJSON) then
         FreeAndNil(LJSON);
   end;
end;

function TClientEndereco.AvaliarColeta(aCodColeta, aAvalicao: Integer;
  aComentario: String): TResponse<TSolicitacaoColeta>;
var LHTTP: TNetHTTPClient;
    LResp : IHTTPResponse;
    LJSON : TJSONObject;
begin
   LJSON := nil;
   LHTTP := TNetHTTPClient.Create(nil);
   try
      LHTTP.ConnectionTimeout := 15000;
      LHTTP.ContentType := 'application/json';
      LHTTP.AcceptEncoding := 'UTF-8';
      LResp := LHTTP.Get(GetURL(Format('/AvaliarSolicitarColeta/%d/%d/%s',[aCodColeta,aAvalicao,TCrypt.GetInstance.Crypt(aComentario)])));
      TratarExecption(LResp);

      LJSON := TJSONObject(TJSONObject.ParseJSONValue(LResp.ContentAsString));

      Result := TResponse<TSolicitacaoColeta>.Create;
      Result.JSONToObject(LJSON);
   finally
      FreeAndNil(LHTTP);

      if Assigned(LJSON) then
         FreeAndNil(LJSON);
   end;
end;

function TClientEndereco.CancelarColeta(
  aEndereco: Integer): TResponse<TSolicitacaoColeta>;
var LHTTP: TNetHTTPClient;
    LResp : IHTTPResponse;
    LJSON : TJSONObject;
begin
   LJSON := nil;
   LHTTP := TNetHTTPClient.Create(nil);
   try
      LHTTP.ConnectionTimeout := 15000;
      LHTTP.ContentType := 'application/json';
      LHTTP.AcceptEncoding := 'UTF-8';
      LResp := LHTTP.Delete(GetURL(Format('/CancelarColeta/%d',[aEndereco])));
      TratarExecption(LResp);

      LJSON := TJSONObject(TJSONObject.ParseJSONValue(LResp.ContentAsString));

      Result := TResponse<TSolicitacaoColeta>.Create;
      Result.JSONToObject(LJSON);
   finally
      FreeAndNil(LHTTP);

      if Assigned(LJSON) then
         FreeAndNil(LJSON);
   end;
end;

function TClientEndereco.ColetasDoUsuario(
  aCodUsuario: Integer): TObjectList<TEndereco>;
var LHTTP: TNetHTTPClient;
    LResp : IHTTPResponse;
    LJSON : TJSONObject;
begin
   Result := nil;
   LJSON := nil;
   LHTTP := TNetHTTPClient.Create(nil);
   try
      LHTTP.ConnectionTimeout := 15000;
      LHTTP.ContentType := 'application/json';
      LHTTP.AcceptEncoding := 'UTF-8';
      LResp := LHTTP.Get(GetURL(Format('/ColetasDoUsuario/%d',[aCodUsuario])));
      TratarExecption(LResp);

      LJSON := TJSONObject(TJSONObject.ParseJSONValue(LResp.ContentAsString));

      Result := TEndereco.JSONToList<TEndereco>(TJSONArray(LJSON));
   finally
      FreeAndNil(LHTTP);

      if Assigned(LJSON) then
         FreeAndNil(LJSON);
   end;
end;

function TClientEndereco.ConcluirColeta(aCodColeta,
  aCodColetor: Integer): TResponse<TSolicitacaoColeta>;
var LHTTP: TNetHTTPClient;
    LResp : IHTTPResponse;
    LJSON : TJSONObject;
begin
   LJSON := nil;
   LHTTP := TNetHTTPClient.Create(nil);
   try
      LHTTP.ConnectionTimeout := 15000;
      LHTTP.ContentType := 'application/json';
      LHTTP.AcceptEncoding := 'UTF-8';
      LResp := LHTTP.Get(GetURL(Format('/ConcluirColeta/%d/%d',[aCodColeta,aCodColetor])));
      TratarExecption(LResp);

      LJSON := TJSONObject(TJSONObject.ParseJSONValue(LResp.ContentAsString));

      Result := TResponse<TSolicitacaoColeta>.Create;
      Result.JSONToObject(LJSON);
   finally
      FreeAndNil(LHTTP);

      if Assigned(LJSON) then
         FreeAndNil(LJSON);
   end;
end;

constructor TClientEndereco.CreatePrivate;
begin

end;

function TClientEndereco.DeletarEndereco(aCodigo: Integer): TResponse<TEndereco>;
var LHTTP: TNetHTTPClient;
    LResp : IHTTPResponse;
    LJSON : TJSONObject;
begin
   LJSON := nil;
   LHTTP := TNetHTTPClient.Create(nil);
   try
      LHTTP.ConnectionTimeout := 15000;
      LHTTP.ContentType := 'application/json';
      LHTTP.AcceptEncoding := 'UTF-8';
      LResp := LHTTP.Delete(GetURL(Format('/DeletarEndereco/%d',[aCodigo])));
      TratarExecption(LResp);

      LJSON := TJSONObject(TJSONObject.ParseJSONValue(LResp.ContentAsString));

      Result := TResponse<TEndereco>.Create;
      Result.JSONToObject(LJSON);
   finally
      FreeAndNil(LHTTP);

      if Assigned(LJSON) then
         FreeAndNil(LJSON);
   end;
end;

function TClientEndereco.EnderecosDoUsuario(
  aCodUsuario: Integer): TObjectList<TEndereco>;
var LHTTP: TNetHTTPClient;
    LResp : IHTTPResponse;
    LJSON : TJSONObject;
begin
   Result := nil;
   LJSON := nil;
   LHTTP := TNetHTTPClient.Create(nil);
   try
      LHTTP.ConnectionTimeout := 15000;
      LHTTP.ContentType := 'application/json';
      LHTTP.AcceptEncoding := 'UTF-8';
      LResp := LHTTP.Get(GetURL(Format('/EnderecosDoUsuario/%d',[aCodUsuario])));
      TratarExecption(LResp);

      LJSON := TJSONObject(TJSONObject.ParseJSONValue(LResp.ContentAsString));

      Result := TEndereco.JSONToList<TEndereco>(TJSONArray(LJSON));
   finally
      FreeAndNil(LHTTP);

      if Assigned(LJSON) then
         FreeAndNil(LJSON);
   end;
end;

class function TClientEndereco.GetInstance: IClientEndereco;
begin
   if not Assigned(FInstance) then
      FInstance := TClientEndereco.CreatePrivate;

   Result := FInstance;
end;

function TClientEndereco.HistoricoColetor(
  aCodigo: Integer): TObjectList<TSolicitacaoColeta>;
var LHTTP: TNetHTTPClient;
    LResp : IHTTPResponse;
    LJSON : TJSONObject;
begin
   Result := nil;
   LJSON := nil;
   LHTTP := TNetHTTPClient.Create(nil);
   try
      LHTTP.ConnectionTimeout := 15000;
      LHTTP.ContentType := 'application/json';
      LHTTP.AcceptEncoding := 'UTF-8';
      LResp := LHTTP.Get(GetURL(Format('/HistoricoColetor/%d',[aCodigo])));
      TratarExecption(LResp);

      LJSON := TJSONObject(TJSONObject.ParseJSONValue(LResp.ContentAsString));

      Result := TSolicitacaoColeta.JSONToList<TSolicitacaoColeta>(TJSONArray(LJSON));
   finally
      FreeAndNil(LHTTP);

      if Assigned(LJSON) then
         FreeAndNil(LJSON);
   end;
end;

function TClientEndereco.HistoricoUsuario(
  aCodigo: Integer): TObjectList<TSolicitacaoColeta>;
var LHTTP: TNetHTTPClient;
    LResp : IHTTPResponse;
    LJSON : TJSONObject;
begin
   Result := nil;
   LJSON := nil;
   LHTTP := TNetHTTPClient.Create(nil);
   try
      LHTTP.ConnectionTimeout := 15000;
      LHTTP.ContentType := 'application/json';
      LHTTP.AcceptEncoding := 'UTF-8';
      LResp := LHTTP.Get(GetURL(Format('/HistoricoUsuario/%d',[aCodigo])));
      TratarExecption(LResp);

      LJSON := TJSONObject(TJSONObject.ParseJSONValue(LResp.ContentAsString));

      Result := TSolicitacaoColeta.JSONToList<TSolicitacaoColeta>(TJSONArray(LJSON));
   finally
      FreeAndNil(LHTTP);

      if Assigned(LJSON) then
         FreeAndNil(LJSON);
   end;
end;

function TClientEndereco.InserirEndereco(
  aEndereco: TEndereco): TResponse<TEndereco>;
var LHTTP: TNetHTTPClient;
    LResp : IHTTPResponse;
    LJSON : TJSONObject;
    LParam : TStringStream;
begin
   LJSON := nil;
   LParam := TStringStream.Create(aEndereco.ObjectToJSON.ToString,TEncoding.UTF8);
   LHTTP := TNetHTTPClient.Create(nil);
   try
      LHTTP.ConnectionTimeout := 15000;
      LHTTP.ContentType := 'application/json';
      LHTTP.AcceptEncoding := 'UTF-8';
      LResp := LHTTP.Post(GetURL('/InserirEndereco'),LParam);
      TratarExecption(LResp);

      LJSON := TJSONObject(TJSONObject.ParseJSONValue(LResp.ContentAsString));

      Result := TResponse<TEndereco>.Create;
      Result.JSONToObject(LJSON);
   finally
      FreeAndNil(LHTTP);

      if Assigned(LJSON) then
         FreeAndNil(LJSON);
   end;
end;


function TClientEndereco.SolicitarColeta(
  aEndereco: Integer): TResponse<TSolicitacaoColeta>;
var LHTTP: TNetHTTPClient;
    LResp : IHTTPResponse;
    LJSON : TJSONObject;
begin
   LJSON := nil;
   LHTTP := TNetHTTPClient.Create(nil);
   try
      LHTTP.ConnectionTimeout := 15000;
      LHTTP.ContentType := 'application/json';
      LHTTP.AcceptEncoding := 'UTF-8';
      LResp := LHTTP.Get(GetURL(Format('/SolicitarColeta/%d',[aEndereco])));
      TratarExecption(LResp);

      LJSON := TJSONObject(TJSONObject.ParseJSONValue(LResp.ContentAsString));

      Result := TResponse<TSolicitacaoColeta>.Create;
      Result.JSONToObject(LJSON);
   finally
      FreeAndNil(LHTTP);

      if Assigned(LJSON) then
         FreeAndNil(LJSON);
   end;
end;

end.
