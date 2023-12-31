unit UClass.Client.Usuario;

interface

uses System.SysUtils,
     System.JSON,
     System.Classes,
     System.Net.HttpClient,
     System.Net.HttpClientComponent,

     UClass.Client.Base.APP,
     UClass.Model.Response,
     UClass.Model.Usuario;

type
  IClientUsuario = interface
  ['{134002BE-709B-4BA3-8315-C561E9405399}']
     function NovoUsuario(aUsuario : TUsuario) : TResponse<TUsuario>;
     function AutenticarUsuario(aLogin, aSenha : String) : TResponse<TUsuario>;
  end;

  TClientUsuario = class(TClientBaseAPP, IClientUsuario)
  private class var FInstance : IClientUsuario;
  private
     constructor CreatePrivate;
  public
     class function GetInstance : IClientUsuario;

     function NovoUsuario(aUsuario : TUsuario) : TResponse<TUsuario>;
     function AutenticarUsuario(aLogin, aSenha : String) : TResponse<TUsuario>;
  end;

implementation

{ TClientUsuario }

uses UClass.Utils.Format, UClass.Utils.Crypt;

function TClientUsuario.AutenticarUsuario(aLogin, aSenha: String): TResponse<TUsuario>;
var LHTTP: TNetHTTPClient;
    LResp : IHTTPResponse;
    LJSON : TJSONObject;
begin
   aLogin := AnsiLowerCase(aLogin);
   if not aLogin.Contains('@') then
      aLogin := SomenteNumero(aLogin);

   if aLogin.IsEmpty then
      raise Exception.Create('Revise o Login informado. O mesmo n�o � um E-mail ou CPF v�lido!');

   aLogin := TCrypt.GetInstance.Crypt(aLogin);
   aSenha := TCrypt.GetInstance.Crypt(aSenha);

   LJSON := nil;
   LHTTP := TNetHTTPClient.Create(nil);
   try
      LHTTP.ConnectionTimeout := 15000;
      LHTTP.ContentType := 'application/json';
      LHTTP.AcceptEncoding := 'UTF-8';
      LResp := LHTTP.Get(GetURL(Format('/AutenticarUsuario/%s/%s',[aLogin,aSenha])));
      TratarExecption(LResp);

      LJSON := TJSONObject(TJSONObject.ParseJSONValue(LResp.ContentAsString));

      Result := TResponse<TUsuario>.Create;
      Result.JSONToObject(LJSON);
   finally
      FreeAndNil(LHTTP);

      if Assigned(LJSON) then
         FreeAndNil(LJSON);
   end;
end;

constructor TClientUsuario.CreatePrivate;
begin

end;

class function TClientUsuario.GetInstance: IClientUsuario;
begin
   if not Assigned(FInstance) then
      FInstance := TClientUsuario.CreatePrivate;

   Result := FInstance;
end;

function TClientUsuario.NovoUsuario(aUsuario : TUsuario): TResponse<TUsuario>;
var LHTTP: TNetHTTPClient;
    LResp : IHTTPResponse;
    LJSON : TJSONObject;
    LParam : TStringStream;
begin
   LJSON := nil;
   LParam := TStringStream.Create(aUsuario.ObjectToJSON.ToString,TEncoding.UTF8);
   LHTTP := TNetHTTPClient.Create(nil);
   try
      LHTTP.ConnectionTimeout := 15000;
      LHTTP.ContentType := 'application/json';
      LHTTP.AcceptEncoding := 'UTF-8';
      LResp := LHTTP.Post(GetURL('/NovoUsuario'),LParam);
      TratarExecption(LResp);

      LJSON := TJSONObject(TJSONObject.ParseJSONValue(LResp.ContentAsString));

      Result := TResponse<TUsuario>.Create;
      Result.JSONToObject(LJSON);
   finally
      FreeAndNil(LHTTP);

      if Assigned(LJSON) then
         FreeAndNil(LJSON);
   end;
end;

end.
