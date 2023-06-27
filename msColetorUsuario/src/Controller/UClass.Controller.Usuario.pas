unit UClass.Controller.Usuario;

interface

uses System.SysUtils,
     System.Math,
     UClass.Model.Usuario,
     UClass.DAO.Usuario;

type
   IControllerUsuario = interface
   ['{32A3B114-5645-49F5-A08C-0992E48115B6}']
      procedure ValidarDadosUsuario(aUsuario : TUsuario);
      procedure NovoUsuario(aUsuario : TUsuario);
      procedure AlterarSenha(aLogin, aNovaSenha : String);
       function AutenticarUsuario(aLogin, aSenha : String) : TUsuario;
   end;

   TControllerUsuario = class(TInterfacedObject, IControllerUsuario)
   private
      function CPFValido(aCPF : String) : Boolean;
      function EmailValido(aEmail : String) : Boolean;
      function UsuarioCadastrado(aLogin : String) : Boolean;

   public
      procedure ValidarDadosUsuario(aUsuario : TUsuario);
      procedure NovoUsuario(aUsuario : TUsuario);
      procedure AlterarSenha(aLogin, aNovaSenha : String);
       function AutenticarUsuario(aLogin, aSenha : String) : TUsuario;

   end;

implementation

{ TControllerUsuario }

procedure TControllerUsuario.AlterarSenha(aLogin, aNovaSenha: String);
begin

end;

function TControllerUsuario.AutenticarUsuario(aLogin, aSenha: String): TUsuario;
var LUsuario : TUsuario;
    LDAO : TDAOUsuario;
begin
   Result := nil;

   if aSenha.IsEmpty then
      Exit;

   LDAO := TDAOUsuario.Create;
   try
      LUsuario := LDAO.Usuario(AnsiLowerCase(aLogin), aSenha);
      Result   := LUsuario;
   finally
      FreeAndNil(LDAO);
   end;
end;

function TControllerUsuario.CPFValido(aCPF: String): Boolean;
var
  LDigitoVerificador1 : Word;
  LDigitoVerificador2 : Word;
  LIntCPF: array [0 .. 10] of Integer;
  I: Integer;
begin
   Result := False;

   aCPF := aCPF.Replace('.','').Replace('-','').Trim;

   if Length(aCPF) <> 11 then
     Exit;

   for I := 0 to 9 do
      if aCPF = StringOfChar(I.ToString[1], 11) then
        Exit;

   try
      for I := 1 to 11 do
         LIntCPF[I - 1] := StrToInt(aCPF[I]);

      LDigitoVerificador1 := 10 * LIntCPF[0] + 9 * LIntCPF[1] + 8 * LIntCPF[2];
      LDigitoVerificador1 := LDigitoVerificador1 + 7 * LIntCPF[3] + 6 * LIntCPF[4] + 5 * LIntCPF[5];
      LDigitoVerificador1 := LDigitoVerificador1 + 4 * LIntCPF[6] + 3 * LIntCPF[7] + 2 * LIntCPF[8];
      LDigitoVerificador1 := 11 - LDigitoVerificador1 mod 11;
      LDigitoVerificador1 := IfThen(LDigitoVerificador1 >= 10, 0, LDigitoVerificador1);

      LDigitoVerificador2 := 11 * LIntCPF[0] + 10 * LIntCPF[1] + 9 * LIntCPF[2];
      LDigitoVerificador2 := LDigitoVerificador2 + 8 * LIntCPF[3] + 7 * LIntCPF[4] + 6 * LIntCPF[5];
      LDigitoVerificador2 := LDigitoVerificador2 + 5 * LIntCPF[6] + 4 * LIntCPF[7] + 3 * LIntCPF[8];
      LDigitoVerificador2 := LDigitoVerificador2 + 2 * LIntCPF[9];
      LDigitoVerificador2 := 11 - LDigitoVerificador2 mod 11;
      LDigitoVerificador2 := IfThen(LDigitoVerificador2 >= 10, 0, LDigitoVerificador2);

     Result := ((LDigitoVerificador1 = LIntCPF[9]) and (LDigitoVerificador2 = LIntCPF[10]));
   except on E: Exception do
       Result := False;
   end;
end;

function TControllerUsuario.EmailValido(aEmail: String): Boolean;
var LIndex : Integer;
    LPossuiArroba : Boolean;
begin
   Result        := False;
   LPossuiArroba := False;

   for LIndex := 1 to Length(aEmail) do
   begin
      if aEmail[LIndex] = '@' then
      begin
         if LPossuiArroba then
            Exit;
         LPossuiArroba := True;
      end
      else
      if aEmail[LIndex] = '.' then
      begin
         if LPossuiArroba then
            Exit(True);
      end;
   end;
end;

procedure TControllerUsuario.NovoUsuario(aUsuario: TUsuario);
var LDAO : TDAOUsuario;
begin
   LDAO := TDAOUsuario.Create;
   try
      ValidarDadosUsuario(aUsuario);
      LDAO.Insert(aUsuario);
   finally
      FreeAndNil(LDAO);
   end;
end;

function TControllerUsuario.UsuarioCadastrado(aLogin: String): Boolean;
var LUsuario : TUsuario;
    LDAO : TDAOUsuario;
begin
   LDAO := TDAOUsuario.Create;
   try
      LUsuario := LDAO.Usuario(aLogin);
      Result := Assigned(LUsuario);
   finally
      FreeAndNil(LDAO);

      if Assigned(LUsuario) then
         FreeAndNil(LUsuario);
   end;
end;

procedure TControllerUsuario.ValidarDadosUsuario(aUsuario: TUsuario);
begin
   if aUsuario.Senha.IsEmpty then
      raise Exception.Create('Senha não foi informada');

   if not EmailValido(aUsuario.Email) then
      raise Exception.Create('E-mail Inválido');

   if not CPFValido(aUsuario.CPF) then
      raise Exception.Create('CPF Inválido');

   if UsuarioCadastrado(aUsuario.CPF) then
      raise Exception.Create('Já existe um usuário com CPF informado');

   if UsuarioCadastrado(aUsuario.Email) then
      raise Exception.Create('Já existe um usuário com E-mail informado');
end;

end.
