unit UClass.View.Frame.Menu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UClass.Utils.Frame, Skia, FMX.Objects, FMX.Controls.Presentation, Skia.FMX,
  FMX.Layouts, UClass.Model.Usuario;

type
  TfrmMenu = class(TFrameUtil)
    lyLogo: TLayout;
    SkAnimatedImage1: TSkAnimatedImage;
    Label3: TLabel;
    lyUsuReciclador: TLayout;
    rcUsuarioRec: TRectangle;
    Label1: TLabel;
    lyUsuColetor: TLayout;
    Rectangle1: TRectangle;
    Label2: TLabel;
    rcFundoMain: TRectangle;
    lyHost: TLayout;
    imgBack: TImage;
    procedure lyUsuRecicladorClick(Sender: TObject);
    procedure lyUsuColetorClick(Sender: TObject);
    procedure imgBackClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMenu: TfrmMenu;

implementation

{$R *.fmx}

uses UClass.Utils.MainScreen, UClass.View.Frame.Login,
  UClass.View.Frame.ConfigAdmin;

procedure TfrmMenu.imgBackClick(Sender: TObject);
begin
   inherited;
   TMainScreen.GetInstance.Show<TfrmConfigAdm>(nil);
end;

procedure TfrmMenu.lyUsuRecicladorClick(Sender: TObject);
var LfrmLogin : TfrmLogin;
begin
   inherited;
   LfrmLogin := TfrmLogin.Create(nil);
   LfrmLogin.TipoUsu := ttuReciclador;
   TMainScreen.GetInstance.Show<TfrmLogin>(LfrmLogin);
end;

procedure TfrmMenu.lyUsuColetorClick(Sender: TObject);
var LfrmLogin : TfrmLogin;
begin
   inherited;
   LfrmLogin := TfrmLogin.Create(nil);
   LfrmLogin.TipoUsu := ttuColetor;
   TMainScreen.GetInstance.Show<TfrmLogin>(LfrmLogin);
end;

end.
