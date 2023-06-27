unit UClass.Client.Google;

interface
       //https://maps.googleapis.com/maps/api/geocode/json?address=PR,Mandaguari,Vila+Nova,Rua+Vereador+Tertuliano+Guimar%C3%A3es+Jr,48&key=AIzaSyCnHkp9twap7R3b52mO15tIBRYjcPrssts
uses System.SysUtils,
     System.JSON,
     System.Classes,
     System.Net.HttpClient,
     System.Net.HttpClientComponent,

     UClass.Client.Base,
     UClass.Model.Endereco,
     UClass.Model.Google.Geocode,
     UClass.Controller.Config;

type
  IClientGoogle = interface
  ['{F9863E61-5A2B-465E-A54C-C3B0361051FD}']
     function Geocode(aEndereco : TEndereco) : TGeocode;
  end;

  TClientGoogle = class(TClientBase, IClientGoogle)
  private class var FInstance : IClientGoogle;
  private
     constructor CreatePrivate;
  public
     class function GetInstance : IClientGoogle;
     function Geocode(aEndereco : TEndereco) : TGeocode;
  end;

implementation

{ TClientUsuario }

constructor TClientGoogle.CreatePrivate;
begin

end;

function TClientGoogle.Geocode(aEndereco: TEndereco): TGeocode;
const URL = 'https://maps.googleapis.com/maps/api/geocode/json?address=%S&key=%S';
var LHTTP: TNetHTTPClient;
    LResp : IHTTPResponse;
    LJSON : TJSONObject;
    LAddress : TStringList;
begin
   Result := nil;
   LJSON := nil;
   LAddress := TStringList.Create;
   LHTTP := TNetHTTPClient.Create(nil);
   try
      LAddress.Add(aEndereco.Estado.Trim);
      LAddress.Add(aEndereco.Cidade.Trim.Replace(' ','+'));
      LAddress.Add(aEndereco.Bairro.Trim.Replace(' ','+'));
      LAddress.Add(aEndereco.Endereco.Trim.Replace(' ','+'));
      LAddress.Add(aEndereco.Numero.Trim.Replace(' ','+'));
      LAddress.Text := LAddress.Text.Replace('&','').Replace('/','');

      LHTTP.ConnectionTimeout := 15000;
      LHTTP.ContentType := 'application/json';
      LHTTP.AcceptEncoding := 'UTF-8';
      LResp := LHTTP.Get(Format(URL,[LAddress.CommaText,TConfiguration.GetInstance.GoogleAPIKey]));

      LJSON := TJSONObject(TJSONObject.ParseJSONValue(LResp.ContentAsString));

      Result := TGeocode.Create;
      Result.JSONToObject(LJSON);
   finally
      FreeAndNil(LHTTP);
      FreeAndNil(LAddress);

      if Assigned(LJSON) then
         FreeAndNil(LJSON);
   end;
end;

class function TClientGoogle.GetInstance: IClientGoogle;
begin
   if not Assigned(FInstance) then
      FInstance := TClientGoogle.CreatePrivate;

   Result := FInstance;
end;

end.
