unit UClass.View.Frame.PesqEndereco;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UClass.Utils.Frame, FMX.Layouts, FMX.Objects, Skia, FMX.Controls.Presentation,
  Skia.FMX, UClass.View.Frame.ListEndereco, FMX.Ani, UClass.Consts.Login,
  UClass.View.Frame.Menu, UClass.Utils.MainScreen, UClass.Utils.Cache;

type
  TfrmPesqEndereco = class(TFrameUtil)
    lyMenu: TLayout;
    recFundoMenu: TRectangle;
    rcFundo: TRectangle;
    SkAnimatedImage1: TSkAnimatedImage;
    Label3: TLabel;
    imgConfig: TImage;
    frmListEndereco: TfrmListEndereco;
    lyBotMenu: TLayout;
    FloatAnimationMenu: TFloatAnimation;
    lyClientMenu: TLayout;
    Layout1: TLayout;
    lbCriarConta: TLabel;
    Line1: TLine;
    Layout2: TLayout;
    Label1: TLabel;
    Line2: TLine;
    lyHistorico: TLayout;
    lnHistorico: TLine;
    lySair: TLayout;
    lbSair: TLabel;
    lnSair: TLine;
    imgUp: TImage;
    lbHistorico: TLabel;
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
  frmPesqEndereco: TfrmPesqEndereco;

implementation

{$R *.fmx}

uses UClass.Utils.Notificacao, UClass.View.Frame.ListHistorico;

constructor TfrmPesqEndereco.Create(AOwner: TComponent);
begin
   inherited;
   FloatAnimationMenu.StartValue := 0;
   FloatAnimationMenu.StopValue  := (lyMenu.Height - lyBotMenu.Height) * -1;

   lyMenu.Position.Y := FloatAnimationMenu.StopValue;
   UpdateImgMenu;
end;

procedure TfrmPesqEndereco.lyBotMenuClick(Sender: TObject);
begin
   inherited;
   FloatAnimationMenu.Inverse := not FloatAnimationMenu.Inverse;
   FloatAnimationMenu.Start;
   UpdateImgMenu;
end;

procedure TfrmPesqEndereco.lyHistoricoClick(Sender: TObject);
begin
   inherited;
   TMainScreen.GetInstance.Show<TfrmListHistorico>(nil)
end;

procedure TfrmPesqEndereco.lySairClick(Sender: TObject);
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

procedure TfrmPesqEndereco.UpdateImgMenu;
begin
   imgConfig.Visible := not FloatAnimationMenu.Inverse;
   imgUp.Visible     := FloatAnimationMenu.Inverse;
end;

end.
