unit UClass.Model.Usuario;

interface

uses System.SysUtils,
     System.JSON,
     UClass.Model.Base,
     UClass.Utils.Format;

type
   TTipoUsuario = (ttuReciclador, ttuColetor);

   TUsuario = class(TModelBase)
   private
      FCodigo : Integer;
      FEmail : String;
      FCPF : String;
      FSenha : String;
      FTipo : TTipoUsuario;

      procedure SetCPF(aValue : String);
      procedure SetEmail(aValue : String);
   public
      constructor Create;

      property Codigo : Integer read FCodigo write FCodigo;
      property Email : String read FEmail write SetEmail;
      property CPF : String read FCPF write SetCPF;
      property Senha : String read FSenha write FSenha;
      property Tipo : TTipoUsuario read FTipo write FTipo;

      function ObjectToJSON : TJSONObject; override;
      procedure JSONToObject(aJSON : TJSONObject); override;
   end;

const ConstTipoUsuario : array[TTipoUsuario] of String = ('R','C');

function StrToTipoUsuario(aValue : String) : TTipoUsuario;

implementation

function StrToTipoUsuario(aValue : String) : TTipoUsuario;
begin
   case aValue[1] of
      'R' : Result := TTipoUsuario.ttuReciclador;
      'C' : Result := TTipoUsuario.ttuColetor;
      else raise Exception.Create('StrToTipoUsuario: Tipo n�o localizado ' + aValue);
   end;
end;

{ TUsuario }

constructor TUsuario.Create;
begin
   FCodigo := 0;
   FEmail  := EmptyStr;
   FCPF    := EmptyStr;
   FSenha  := EmptyStr;
   FTipo   := ttuReciclador;
end;

procedure TUsuario.JSONToObject(aJSON: TJSONObject);
begin
   inherited;
   FCodigo := StrToIntDef(aJSON.GetValue('Codigo').Value,0);
   FEmail  := aJSON.GetValue('Email').Value;
   FCPF    := aJSON.GetValue('CPF').Value;
   FSenha  := aJSON.GetValue('Senha').Value;
   FTipo   := StrToTipoUsuario(aJSON.GetValue('Tipo').Value);
end;

function TUsuario.ObjectToJSON: TJSONObject;
begin
   Result := TJSONObject.Create;

   Result.AddPair('Codigo', FCodigo.ToString);
   Result.AddPair('Email', FEmail);
   Result.AddPair('CPF', FCPF);
   Result.AddPair('Senha', FSenha);
   Result.AddPair('Tipo', ConstTipoUsuario[FTipo]);
end;

procedure TUsuario.SetCPF(aValue: String);
begin
   FCPF := SomenteNumero(aValue);
end;

procedure TUsuario.SetEmail(aValue: String);
begin
   FEmail := AnsiLowerCase(aValue);
end;

end.
