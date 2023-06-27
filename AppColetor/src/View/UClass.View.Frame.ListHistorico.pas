unit UClass.View.Frame.ListHistorico;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UClass.Utils.Frame, Skia, FMX.Controls.Presentation, Skia.FMX, FMX.Layouts,
  UClass.Model.SolicitacaoColeta, UClass.Model.Usuario, UClass.Client.Endereco,
  UClass.Utils.Cache, System.Generics.Collections, FMX.Objects;

type
  TfrmListHistorico = class(TFrameUtil)
    sbFundo: TScrollBox;
    lyNotFound: TLayout;
    skNotFound: TSkAnimatedImage;
    Label3: TLabel;
    Label1: TLabel;
    lyClean: TLayout;
    imgClean: TSkAnimatedImage;
    lyMenu: TLayout;
    imgBack: TImage;
    rcFundo: TRectangle;
    procedure imgBackClick(Sender: TObject);
  private
    { Private declarations }
    FListSolic : TObjectList<TSolicitacaoColeta>;
    FUsuario : TUsuario;
    procedure AddSolicitacao(aSolic : TSolicitacaoColeta);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
     destructor Destroy; override;
  end;

var
  frmListHistorico: TfrmListHistorico;

implementation

{$R *.fmx}

uses UClass.View.Frame.ItemHistorico, UClass.View.Frame.PesqColeta,
  UClass.View.Frame.PesqEndereco, UClass.Utils.MainScreen;

{ TFrameUtil1 }

procedure TfrmListHistorico.AddSolicitacao(aSolic: TSolicitacaoColeta);
var LItemHist : TfrmItemHistorico;
begin
   lyNotFound.Visible := False;

   LItemHist := TfrmItemHistorico.Create(Self);
   LItemHist.SolictacaoColeta := aSolic;
   LItemHist.Align := TAlignLayout.Top;
   LItemHist.Parent := sbFundo;
   LItemHist.Name := 'TfrmItemHistorico' + sbFundo.Content.ControlsCount.ToString;

   lyClean.Parent := sbFundo;
   lyClean.Align := TAlignLayout.Top;
   lyClean.Position.Y := sbFundo.Height + 1;
end;

constructor TfrmListHistorico.Create(AOwner: TComponent);
var LSolic : TSolicitacaoColeta;
begin
   inherited;
   FUsuario := TUsuario(TCache.GetInstance.Get(chUsuario));

   if not Assigned(FUsuario) then
     raise Exception.Create('N�o foi localizado os dados do usu�rio para buscar os endere�os!');

   if FUsuario.Tipo = ttuColetor then
      FListSolic := TClientEndereco.GetInstance.HistoricoColetor(FUsuario.Codigo)
   else
      FListSolic := TClientEndereco.GetInstance.HistoricoUsuario(FUsuario.Codigo);

   for LSolic in FListSolic do
      AddSolicitacao(LSolic);
end;

destructor TfrmListHistorico.Destroy;
begin
   if Assigned(FListSolic) then
      FreeAndNil(FListSolic);
   inherited;
end;

procedure TfrmListHistorico.imgBackClick(Sender: TObject);
begin
   inherited;
   if FUsuario.Tipo = ttuColetor then
      TMainScreen.GetInstance.Show<TfrmPesqColeta>(nil)
   else
      TMainScreen.GetInstance.Show<TfrmPesqEndereco>(nil);
end;

end.
