unit UClass.View.Frame.AvaliarColeta;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UClass.Utils.Frame, FMX.Layouts, FMX.Objects, FMX.Edit,
  FMX.Controls.Presentation, UClass.Utils.MainScreen,
  UClass.View.Frame.PesqEndereco, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  UClass.Utils.Notificacao, System.Threading, UClass.Model.Endereco, UClass.Model.SolicitacaoColeta,
  UClass.Client.Endereco, UClass.Model.Response;

type
  TfrmAvaliar = class(TFrameUtil)
    Layout1: TLayout;
    recFundo: TRectangle;
    lyMenu: TLayout;
    imgBack: TImage;
    lyTop: TLayout;
    lyAvaliar: TLayout;
    lbAvaliar: TLabel;
    lyStar: TLayout;
    rcStar: TRectangle;
    lyStarCenter: TLayout;
    imgStar1: TImage;
    imgStar5: TImage;
    imgStar4: TImage;
    imgStar3: TImage;
    imgStar2: TImage;
    imgSelect: TImage;
    imgUnSelect: TImage;
    lyBot: TLayout;
    lyFinalizar: TLayout;
    rcFinalizar: TRectangle;
    lbFinalizar: TLabel;
    lyCancelar: TLayout;
    rcCancelar: TRectangle;
    lbCancelar: TLabel;
    Layout2: TLayout;
    Rectangle1: TRectangle;
    Label1: TLabel;
    mmObs: TMemo;
    procedure imgBackClick(Sender: TObject);
    procedure imgStar1Click(Sender: TObject);
    procedure lyFinalizarClick(Sender: TObject);
  private
    { Private declarations }
    FEndereco : TEndereco;
    FCountStars : Integer;

    procedure SetStar(aCount : Integer);
    function AvaliarColeta : Boolean;
  public
    { Public declarations }
    property Endereco : TEndereco read FEndereco write FEndereco;

    constructor Create(AOwner: TComponent); override;
  end;

var
  frmAvaliar: TfrmAvaliar;

implementation

{$R *.fmx}

{ TfrmAvaliar }

function TfrmAvaliar.AvaliarColeta: Boolean;
var LResponse : TResponse<TSolicitacaoColeta>;
begin
   Result := False;

   try
      LResponse := nil;
      try
         LResponse := TClientEndereco.GetInstance.AvaliarColeta(FEndereco.SolicitacaoColeta.Codigo, FCountStars, mmObs.Text);

         if LResponse.Status.Code <> 200 then
            raise Exception.Create(LResponse.Status.Message);

         FEndereco.SolicitacaoColeta.Avalicao   := LResponse.Data.Avalicao;
         FEndereco.SolicitacaoColeta.Comentario := LResponse.Data.Comentario;

         Result := True;
      finally
         if Assigned(LResponse) then
         begin
            FreeAndNil(LResponse.Data);
            FreeAndNil(LResponse);
         end;
      end;
   except on E: Exception do
      begin
         TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
               TDialoger.GetInstance.ShowMessage(E.Message,mtError);
            end
         );
      end;
   end;
end;

constructor TfrmAvaliar.Create(AOwner: TComponent);
begin
   inherited;
   FCountStars := 1;
end;

procedure TfrmAvaliar.imgBackClick(Sender: TObject);
begin
   inherited;
   TMainScreen.GetInstance.Show<TfrmPesqEndereco>(nil);
end;

procedure TfrmAvaliar.imgStar1Click(Sender: TObject);
begin
   inherited;
   SetStar(TImage(Sender).Tag);
end;

procedure TfrmAvaliar.lyFinalizarClick(Sender: TObject);
var LTask : ITask;
begin
   inherited;
   TDialoger.GetInstance.ShowLoad;
   LTask := TTask.Run(
      procedure
      begin
         try
            if not AvaliarColeta then
               Exit;

            TThread.Synchronize(TThread.CurrentThread,
               procedure
               begin
                  TDialoger.GetInstance.ToastMessage('Avalia��o realizada com Sucesso!');
                  imgBackClick(imgBack);
               end
            );
         finally
            TThread.Synchronize(TThread.CurrentThread,
               procedure
               begin
                  TDialoger.GetInstance.HideLoad;
               end
            );
         end;
      end
   );
end;

procedure TfrmAvaliar.SetStar(aCount: Integer);

   procedure SetImg(aImg : TImage; aSelect : Boolean);
   begin
      if aSelect then
         aImg.Bitmap := imgSelect.Bitmap
      else
         aImg.Bitmap := imgUnSelect.Bitmap;
   end;

begin
   SetImg(imgStar1, aCount >= 1);
   SetImg(imgStar2, aCount >= 2);
   SetImg(imgStar3, aCount >= 3);
   SetImg(imgStar4, aCount >= 4);
   SetImg(imgStar5, aCount >= 5);

   FCountStars := aCount;

   if FCountStars < 1 then
      FCountStars := 1;

   if FCountStars > 5 then
      FCountStars := 5;
end;

end.
