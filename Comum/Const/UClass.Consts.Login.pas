unit UClass.Consts.Login;

interface

uses
  System.Classes,
  System.SysUtils,
  System.IOUtils,
  UClass.Utils.Crypt;

var
   CONST_DIR_LOGIN : String;

procedure SaveLogin(aUsuario : String; aSenha : String);
function LoadLogin(out aUsuario : String; out aSenha : String) : Boolean;
procedure DeleteLogin;

implementation

procedure SaveLogin(aUsuario : String; aSenha : String);
var LStrList : TStringList;
begin
   LStrList := TStringList.Create;
   try
      LStrList.Values['U'] := TCrypt.GetInstance.Crypt(aUsuario,'980E16F2A184');
      LStrList.Values['S'] := TCrypt.GetInstance.Crypt(aSenha,'980E16F2A184');
      LStrList.SaveToFile(CONST_DIR_LOGIN);
   finally
      FreeAndNil(LStrList);
   end;
end;

function LoadLogin(out aUsuario : String; out aSenha : String) : Boolean;
var LStrList : TStringList;
begin
   if not FileExists(CONST_DIR_LOGIN) then
      Exit(False);

   LStrList := TStringList.Create;
   try
      LStrList.LoadFromFile(CONST_DIR_LOGIN);
      aUsuario := TCrypt.GetInstance.Decrypt(LStrList.Values['U'],'980E16F2A184');
      aSenha   := TCrypt.GetInstance.Decrypt(LStrList.Values['S'],'980E16F2A184');

      Result := (not aUsuario.IsEmpty) and (not aSenha.IsEmpty);
   finally
      FreeAndNil(LStrList);
   end;
end;

procedure DeleteLogin;
begin
   if FileExists(CONST_DIR_LOGIN) then
      DeleteFile(CONST_DIR_LOGIN);
end;

initialization
   CONST_DIR_LOGIN := TPath.GetCachePath + '\Coletor';
   if not DirectoryExists(CONST_DIR_LOGIN) then
       ForceDirectories(CONST_DIR_LOGIN);

   CONST_DIR_LOGIN := CONST_DIR_LOGIN + '\CLT-P.txt';

end.
