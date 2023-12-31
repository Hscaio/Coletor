unit UClass.Model.StatusResponse;

interface

uses System.SysUtils,
     System.JSON,
     UClass.Model.Base;

type
   TStatusResponse = class(TModelBase)
   private
      FCode : Integer;
      FMessage : String;
   public
      property Code : Integer read FCode write FCode;
      property Message : String read FMessage write FMessage;

      function ObjectToJSON : TJSONObject; override;
      procedure JSONToObject(aJSON : TJSONObject); override;
   end;

implementation

{ TStatusResponse }

procedure TStatusResponse.JSONToObject(aJSON: TJSONObject);
begin
   inherited;
   if not Assigned(aJSON) then
      raise Exception.Create('JSON n�o informado para gera��o do Objeto');

   FCode    := StrToIntDef(aJSON.GetValue('Code').Value,0);
   FMessage := aJSON.GetValue('Message').Value;
end;

function TStatusResponse.ObjectToJSON: TJSONObject;
begin
   Result := TJSONObject.Create;
   Result.AddPair('Code', FCode.ToString);
   Result.AddPair('Message', FMessage);
end;

end.
