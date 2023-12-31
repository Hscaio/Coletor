unit UClass.View.Frame.Endereco;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UClass.Utils.Frame, FMX.Objects, FMX.ListBox, FMX.Edit,
  FMX.Controls.Presentation, FMX.Layouts, UClass.Model.Endereco;

type
  TfrmEndereco = class(TFrameUtil)
    recFundoLogin: TRectangle;
    lyBot: TLayout;
    lyFinalizar: TLayout;
    rcFinalizar: TRectangle;
    lbFinalizar: TLabel;
    lyCancelar: TLayout;
    rcCancelar: TRectangle;
    lbCancelar: TLabel;
    lyMenu: TLayout;
    lyTop: TLayout;
    lyLogo: TLayout;
    lbEndereco: TLabel;
    lyCidadeEstado: TLayout;
    lyCidade: TLayout;
    rcCidade: TRectangle;
    edCidade: TEdit;
    lyEstado: TLayout;
    rcEstado: TRectangle;
    cbEstado: TComboBox;
    lbiAC: TListBoxItem;
    lbiAL: TListBoxItem;
    lbiAM: TListBoxItem;
    lbiAP: TListBoxItem;
    lbiBA: TListBoxItem;
    lbiCE: TListBoxItem;
    lbiDF: TListBoxItem;
    lbiES: TListBoxItem;
    lbiGO: TListBoxItem;
    lbiMA: TListBoxItem;
    lbiMG: TListBoxItem;
    lbiMS: TListBoxItem;
    lbiMT: TListBoxItem;
    lbiPA: TListBoxItem;
    lbiPB: TListBoxItem;
    lbiPE: TListBoxItem;
    lbiPI: TListBoxItem;
    lbiPR: TListBoxItem;
    lbiRJ: TListBoxItem;
    lbiRN: TListBoxItem;
    lbiRO: TListBoxItem;
    lbiRR: TListBoxItem;
    lbiRS: TListBoxItem;
    lbiSC: TListBoxItem;
    lbiSE: TListBoxItem;
    lbiSP: TListBoxItem;
    lbiTO: TListBoxItem;
    lyBairro: TLayout;
    rcBairro: TRectangle;
    edBairro: TEdit;
    lyEndereco: TLayout;
    rcEndereco: TRectangle;
    edEndereco: TEdit;
    lyComplementoNumero: TLayout;
    lyNumero: TLayout;
    rcNumero: TRectangle;
    edNumero: TEdit;
    lyComplemento: TLayout;
    rcComplemento: TRectangle;
    edComplemento: TEdit;
    procedure lyFinalizarClick(Sender: TObject);
    procedure lyCancelarClick(Sender: TObject);
  private
    { Private declarations }
    FEndereco : TEndereco;
    function ValidarDados : Boolean;
    function CadastrarEndereco : Boolean;
    procedure SetEndereco(const Value: TEndereco);
    procedure VoltarTela;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;

    property Endereco : TEndereco read FEndereco write SetEndereco;
  end;

implementation

{$R *.fmx}

uses UClass.Utils.Notificacao, UClass.Model.Usuario, UClass.Model.Response,
  System.Generics.Collections, UClass.Utils.Cache, UClass.Client.Endereco,
  UClass.View.Frame.PesqEndereco, UClass.Utils.MainScreen, System.Threading,
  UClass.View.Frame.PesqColeta;

function TfrmEndereco.CadastrarEndereco: Boolean;
var LResponse : TResponse<TEndereco>;
    LEndereco : TEndereco;
    LUsuario : TUsuario;
    LListEnd : TObjectList<TEndereco>;
begin
   Result := False;

   try
      LResponse := nil;
      LEndereco := nil;
      try
         LUsuario := TUsuario(TCache.GetInstance.Get(chUsuario));

         if not Assigned(LUsuario) then
            raise Exception.Create('N�o foi localizado os dados do Usu�rio para cadastra o Endere�o');

         if Assigned(FEndereco) then
         begin
            FEndereco.Cidade      := edCidade.Text;
            FEndereco.Bairro      := edBairro.Text;
            FEndereco.Endereco    := edEndereco.Text;
            FEndereco.Numero      := edNumero.Text;
            FEndereco.Complemento := edComplemento.Text;
            FEndereco.Estado      := cbEstado.Items[cbEstado.ItemIndex];
            LResponse := TClientEndereco.GetInstance.AtualizarEndereco(FEndereco)
         end
         else
         begin
            LEndereco := TEndereco.Create;
            LEndereco.Usuario     := LUsuario.Codigo;
            LEndereco.Cidade      := edCidade.Text;
            LEndereco.Bairro      := edBairro.Text;
            LEndereco.Endereco    := edEndereco.Text;
            LEndereco.Numero      := edNumero.Text;
            LEndereco.Complemento := edComplemento.Text;
            LEndereco.Estado      := cbEstado.Items[cbEstado.ItemIndex];

            LResponse := TClientEndereco.GetInstance.InserirEndereco(LEndereco);
         end;

         if LResponse.Status.Code <> 200 then
            raise Exception.Create(LResponse.Status.Message);

         if not Assigned(FEndereco) then
         begin
            LListEnd := TObjectList<TEndereco>(TCache.GetInstance.Get(chListaEndereco));

            if Assigned(LListEnd) then
               LListEnd.Add(LResponse.Data);
         end;

         Result := True;
      finally
         if Assigned(LEndereco) then
            FreeAndNil(LEndereco);

         if Assigned(LResponse) then
         begin
            if Assigned(FEndereco) and Assigned(LResponse.Data) then
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

constructor TfrmEndereco.Create(AOwner: TComponent);
begin
   inherited;
   FEndereco := nil;
end;

procedure TfrmEndereco.lyCancelarClick(Sender: TObject);
begin
   inherited;
   VoltarTela;
end;

procedure TfrmEndereco.lyFinalizarClick(Sender: TObject);
var LTask : ITask;
begin
   TDialoger.GetInstance.ShowLoad;
   LTask := TTask.Run(
      procedure
      var LfrmEndereco : TfrmEndereco;
      begin
         try
            if not ValidarDados then
               Exit;

            if not CadastrarEndereco then
               Exit;

            TThread.Synchronize(TThread.CurrentThread,
               procedure
               begin
                  VoltarTela;
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

procedure TfrmEndereco.SetEndereco(const Value: TEndereco);
begin
   FEndereco := Value;

   if not Assigned(FEndereco) then
      Exit;

   edCidade.Text      := FEndereco.Cidade;
   edBairro.Text      := FEndereco.Bairro;
   edEndereco.Text    := FEndereco.Endereco;
   edNumero.Text      := FEndereco.Numero;
   edComplemento.Text := FEndereco.Complemento;
   cbEstado.ItemIndex := cbEstado.Items.IndexOf(FEndereco.Estado);
end;

function TfrmEndereco.ValidarDados: Boolean;
begin
   Result := True;

   if CampoIsEmpty(edCidade, rcCidade) then
      Result := False;

   if CampoIsEmpty(edBairro, rcBairro) then
      Result := False;

   if CampoIsEmpty(edEndereco, rcEndereco) then
      Result := False;

   if CampoIsEmpty(edNumero, rcNumero) then
      Result := False;

   if not Result then
      TDialoger.GetInstance.ShowMessage('H� dados obrigat�rios n�o informados',mtError);
end;

procedure TfrmEndereco.VoltarTela;
var LUsuario : TUsuario;
begin
   LUsuario := TUsuario(TCache.GetInstance.Get(chUsuario));

   if LUsuario.Tipo = ttuReciclador then
      TMainScreen.GetInstance.Show<TfrmPesqEndereco>(nil)
   else
      TMainScreen.GetInstance.Show<TfrmPesqColeta>(nil);
end;

end.
