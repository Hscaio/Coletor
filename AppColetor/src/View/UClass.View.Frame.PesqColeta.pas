unit UClass.View.Frame.PesqColeta;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UClass.Utils.Frame, Skia, FMX.Objects, FMX.Ani, FMX.Controls.Presentation,
  Skia.FMX, FMX.Layouts, UClass.View.Frame.ListColeta, UClass.Utils.Cache,
  UClass.Utils.MainScreen, UClass.Consts.Login, UClass.View.Frame.Menu;

type
  TfrmPesqColeta = class(TFrameUtil)
    lyMenu: TLayout;
    recFundoMenu: TRectangle;
    lyBotMenu: TLayout;
    SkAnimatedImage1: TSkAnimatedImage;
    imgConfig: TImage;
    Label3: TLabel;
    imgUp: TImage;
    FloatAnimationMenu: TFloatAnimation;
    lyClientMenu: TLayout;
    Layout1: TLayout;
    lbCriarConta: TLabel;
    Line1: TLine;
    Layout2: TLayout;
    Label1: TLabel;
    Line2: TLine;
    lyHistorico: TLayout;
    lbHistorico: TLabel;
    lnHistorico: TLine;
    lySair: TLayout;
    lbSair: TLabel;
    lnSair: TLine;
    frmListColeta: TfrmListColeta;
    rcFundo: TRectangle;
    procedure lyBotMenuClick(Sender: TObject);
    procedure lySairClick(Sender: TObject);
    procedure lyHistoricoClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateImgMenu;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmPesqColeta: TfrmPesqColeta;

implementation

{$R *.fmx}

uses UClass.Utils.Notificacao, UClass.View.Frame.ListHistorico;

{ TfrmPesqColeta }

constructor TfrmPesqColeta.Create(AOwner: TComponent);
begin
  inherited;
   FloatAnimationMenu.StartValue := 0;
   FloatAnimationMenu.StopValue  := (lyMenu.Height - lyBotMenu.Height) * -1;

   lyMenu.Position.Y := FloatAnimationMenu.StopValue;
   UpdateImgMenu;
end;

procedure TfrmPesqColeta.lyHistoricoClick(Sender: TObject);
begin
   inherited;
   TMainScreen.GetInstance.Show<TfrmListHistorico>(nil);
end;

procedure TfrmPesqColeta.lyBotMenuClick(Sender: TObject);
begin
  inherited;
   FloatAnimationMenu.Inverse := not FloatAnimationMenu.Inverse;
   FloatAnimationMenu.Start;
   UpdateImgMenu;
end;

procedure TfrmPesqColeta.lySairClick(Sender: TObject);
begin
   inherited;
   TDialoger.
      GetInstance.
         ShowMessage('Deseja realmente sair da conta?',TMessageType.mtConfirmation,
                     procedure(aResponse : TMessageResponse)
                     begin
                        if aResponse <> mrYes then
                           Exit;

                        DeleteLogin;
                        TCache.GetInstance.Clear;
                        TMainScreen.GetInstance.Show<TfrmMenu>(nil);
                     end);
end;

procedure TfrmPesqColeta.UpdateImgMenu;
begin
   imgConfig.Visible := not FloatAnimationMenu.Inverse;
   imgUp.Visible     := FloatAnimationMenu.Inverse;
end;

end.
