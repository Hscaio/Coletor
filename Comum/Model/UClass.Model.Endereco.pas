unit UClass.Model.Endereco;

interface

uses System.SysUtils,
     System.JSON,
     UClass.Model.Base,
     UClass.Model.SolicitacaoColeta,
     UClass.Utils.Format;

type
   TEndereco = class(TModelBase)
   private
      FCodigo: Integer;
      FNumero: String;
      FComplemento: String;
      FUsuario: Integer;
      FCidade: String;
      FEstado: String;
      FBairro: String;
      FEndereco: String;
      FLat: Double;
      FLong: Double;
      FAtivo : Boolean;
      FSolicitacaoColeta : TSolicitacaoColeta;
   public
      constructor Create;
      destructor Destroy; override;

      property Codigo : Integer read FCodigo write FCodigo;
      property Usuario : Integer read FUsuario write FUsuario;
      property Cidade : String read FCidade write FCidade;
      property Estado : String read FEstado write FEstado;
      property Bairro : String read FBairro write FBairro;
      property Numero : String read FNumero write FNumero;
      property Endereco : String read FEndereco write FEndereco;
      property Complemento : String read FComplemento write FComplemento;
      property Lat : Double read FLat write FLat;
      property Long : Double read FLong write FLong;
      property Ativo : Boolean read FAtivo write FAtivo;

      property SolicitacaoColeta : TSolicitacaoColeta read FSolicitacaoColeta write FSolicitacaoColeta;

      function ObjectToJSON : TJSONObject; override;
      procedure JSONToObject(aJSON : TJSONObject); override;
   end;

implementation

{ TEndereco }

constructor TEndereco.Create;
begin
   FCodigo := 0;
   FNumero := EmptyStr;
   FBairro := EmptyStr;
   FComplemento := EmptyStr;
   FUsuario := 0;
   FCidade := EmptyStr;
   FEstado := EmptyStr;
   FLat := 0;
   FLong := 0;
   FAtivo := True;
   FSolicitacaoColeta := nil;
end;

destructor TEndereco.Destroy;
begin
   if Assigned(FSolicitacaoColeta) then
      FreeAndNil(FSolicitacaoColeta);

   inherited;
end;

procedure TEndereco.JSONToObject(aJSON: TJSONObject);
begin
   inherited;
   FCodigo := StrToIntDef(aJSON.GetValue('Codigo').Value,0);
   FLong := StrToFloatDef(aJSON.GetValue('Long').Value,0);
   FLat := StrToFloatDef(aJSON.GetValue('Lat').Value,0);
   FNumero := aJSON.GetValue('Numero').Value;
   FBairro := aJSON.GetValue('Bairro').Value;
   FEndereco := aJSON.GetValue('Endereco').Value;
   FComplemento := aJSON.GetValue('Complemento').Value;
   FUsuario := StrToIntDef(aJSON.GetValue('Usuario').Value,0);
   FCidade := aJSON.GetValue('Cidade').Value;
   FEstado := aJSON.GetValue('Estado').Value;

   if Assigned(aJSON.GetValue('SolicitacaoColeta')) then
   begin
      FSolicitacaoColeta := TSolicitacaoColeta.Create;
      FSolicitacaoColeta.JSONToObject(TJSONObject(aJSON.GetValue('SolicitacaoColeta')))
   end;

end;

function TEndereco.ObjectToJSON: TJSONObject;
begin
   Result := TJSONObject.Create;

   Result.AddPair('Codigo', FCodigo.ToString);
   Result.AddPair('Usuario', FUsuario.ToString);
   Result.AddPair('Cidade', FCidade);
   Result.AddPair('Estado', FEstado);
   Result.AddPair('Numero', FNumero);
   Result.AddPair('Bairro', FBairro);
   Result.AddPair('Endereco', FEndereco);
   Result.AddPair('Complemento', FComplemento);
   Result.AddPair('Lat', FLat.ToString);
   Result.AddPair('Long', FLong.ToString);

   if Assigned(FSolicitacaoColeta) then
      Result.AddPair('SolicitacaoColeta', FSolicitacaoColeta.ObjectToJSON);
end;

end.
