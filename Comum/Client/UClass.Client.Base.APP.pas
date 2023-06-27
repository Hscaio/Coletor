unit UClass.Client.Base.APP;

interface

uses System.SysUtils,
     System.JSON,
     System.Net.HttpClient,
     System.Net.HttpClientComponent,

     UClass.Client.Base,
     UClass.Consts.URL;

type
  IClientBaseAPP = interface(IClientBase)
  ['{12267797-0231-48EC-976C-19F556834C5C}']
  end;

  TClientBaseAPP = class(TInterfacedObject, IClientBaseAPP)
  strict private var FInstance : IClientBaseAPP;
  protected
      function GetURL(aResorce : String = '') : String;
     procedure TratarExecption(aResponse : IHTTPResponse);

  private
     constructor CreatePrivate;
  public
     function GetInstance : IClientBase;
  end;

implementation

{ TClientBaseAPP }

constructor TClientBaseAPP.CreatePrivate;
begin

end;

function TClientBaseAPP.GetURL(aResorce: String): String;
begin
   Result := URL_MSCOLETOR + aResorce;
end;

procedure TClientBaseAPP.TratarExecption(aResponse: IHTTPResponse);
var LJSON, LJSONMessage : TJSONValue;
begin
   if aResponse.StatusCode = 200 then
      Exit;

   LJSON := TJSONObject.ParseJSONValue(aResponse.ContentAsString);
   try
      if not Assigned(LJSON) then
         raise Exception.Create(aResponse.StatusCode.ToString + ': ' + aResponse.ContentAsString);

      if LJSON.TryGetValue<TJSONValue>('Message',LJSONMessage) then
         raise Exception.Create(LJSONMessage.ToString);
   finally
      if Assigned(LJSON) then
         FreeAndNil(LJSON);
   end;
end;

function TClientBaseAPP.GetInstance: IClientBase;
begin
   if not Assigned(FInstance) then
      FInstance := TClientBaseAPP.CreatePrivate;

   Result := FInstance;
end;

end.
