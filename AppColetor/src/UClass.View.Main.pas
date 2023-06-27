unit UClass.View.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, Skia,
  Skia.FMX, FMX.Edit, UClass.View.Frame.Login, FMX.ListBox,
  UClass.Utils.MainScreen, UClass.View.Frame.Menu, UClass.Consts.Login;

type
  TfrmMain = class(TForm)
    StyleBook1: TStyleBook;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

procedure TfrmMain.FormShow(Sender: TObject);
var LUsuario, LSenha : String;
    LfrmLogin : TfrmLogin;
begin
   TMainScreen.GetInstance.MainForm := Self;

   if not LoadLogin(LUsuario, LSenha) then
      TMainScreen.GetInstance.Show<TfrmMenu>(nil)
   else
   begin
      LfrmLogin         := TfrmLogin.Create(nil);
      LfrmLogin.Usuario := LUsuario;
      LfrmLogin.Senha   := LSenha;
      TMainScreen.GetInstance.Show<TfrmLogin>(LfrmLogin);
      LfrmLogin.Acessar;
   end;
end;

end.
