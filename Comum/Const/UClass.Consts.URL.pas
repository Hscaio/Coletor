unit UClass.Consts.URL;

interface

uses
  System.Classes,
  System.SysUtils,
  System.IOUtils;

var
   URL_MSCOLETOR : String;
   CONST_DIR_URL : String;

procedure SaveURL_MSCOLETOR(aURL : String);
procedure LoadURL_MSCOLETOR;

implementation

procedure SaveURL_MSCOLETOR(aURL : String);
var LStrList : TStringList;
begin
   URL_MSCOLETOR := aURL.Trim;

   LStrList := TStringList.Create;
   try
      LStrList.Text := URL_MSCOLETOR;
      LStrList.SaveToFile(CONST_DIR_URL);
   finally
      FreeAndNil(LStrList);
   end;
end;

procedure LoadURL_MSCOLETOR;
var LStrList : TStringList;
begin
   URL_MSCOLETOR := 'http://192.168.2.56:8080';

   LStrList := TStringList.Create;
   try
      if not FileExists(CONST_DIR_URL) then
         Exit;

      LStrList.LoadFromFile(CONST_DIR_URL);

      if not LStrList.Text.Trim.IsEmpty then
         URL_MSCOLETOR := LStrList.Text.Trim;
   finally
      FreeAndNil(LStrList);
   end;
end;


initialization
   CONST_DIR_URL := TPath.GetCachePath + '\Coletor';
   if not DirectoryExists(CONST_DIR_URL) then
       ForceDirectories(CONST_DIR_URL);

   CONST_DIR_URL := CONST_DIR_URL + '\URL_MSCOLETOR.txt';

   LoadURL_MSCOLETOR;

end.
