unit UClass.Horse.Base;

interface

uses System.SysUtils,
     System.JSON,
     Horse,
     Horse.Jhonson,
     UClass.Model.Base,
     UClass.Model.StatusResponse,
     UClass.Model.Response;

type
   THorseBase = class
   protected
      class function CreateStatusResponse(aCode : Integer; aMessage : String) : TJSONObject; overload;
      class function CreateStatusResponse<T : constructor, TModelBase>(aCode : Integer; aMessage : String; aData : T) : TJSONObject; overload;
   public
      class procedure Registering; virtual; abstract;
   end;

implementation

{ THorseBase }

class function THorseBase.CreateStatusResponse(aCode: Integer;
  aMessage: String): TJSONObject;
begin
   Result := CreateStatusResponse<TModelBase>(aCode,aMessage,nil);
end;

class function THorseBase.CreateStatusResponse<T>(aCode: Integer;
  aMessage: String; aData: T): TJSONObject;
var LResponse : TResponse<T>;
begin
   LResponse := TResponse<T>.Create;
   try
      LResponse.Data := aData;
      LResponse.Status.Code := aCode;
      LResponse.Status.Message := aMessage;
      Result := LResponse.ObjectToJSON;
   finally
      FreeAndNil(LResponse);
   end;
end;

initialization
   THorse.Use(Jhonson());

end.
