unit UClass.View.Frame.ItemHistorico;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UClass.Utils.Frame, FMX.Objects, FMX.Controls.Presentation, UClass.Model.SolicitacaoColeta,
  UClass.Utils.Notificacao;

type
  TfrmItemHistorico = class(TFrameUtil)
    lnLine: TLine;
    lbDescData: TLabel;
    lbData: TLabel;
    lbDescStatus: TLabel;
    lbStatus: TLabel;
    lbEndereco: TLabel;
    lbBairro: TLabel;
    Image1: TImage;
    lbEstrelas: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lbVerMais: TLabel;
    lbComentario: TLabel;
    procedure lbVerMaisClick(Sender: TObject);
  private
    FSolictacaoColeta: TSolicitacaoColeta;
    procedure SetSolictacaoColeta(const Value: TSolicitacaoColeta);
    { Private declarations }
  public
    { Public declarations }
    property SolictacaoColeta : TSolicitacaoColeta read FSolictacaoColeta write SetSolictacaoColeta;
  end;

var
  frmItemHistorico: TfrmItemHistorico;

implementation

{$R *.fmx}

{ TfrmItemHistorico }

procedure TfrmItemHistorico.lbVerMaisClick(Sender: TObject);
begin
   inherited;
   TDialoger.GetInstance.ShowMessage(FSolictacaoColeta.Comentario,mtInformation);
end;

procedure TfrmItemHistorico.SetSolictacaoColeta(
  const Value: TSolicitacaoColeta);
begin
   FSolictacaoColeta := Value;

   if not Assigned(FSolictacaoColeta) then
      Exit;

   lbData.Text := FormatDateTime('DD/MM/YYYY HH:NN',FSolictacaoColeta.DHCadastro);
   lbEndereco.Text := FSolictacaoColeta.LogEndereco;
   lbBairro.Text := FSolictacaoColeta.LogBairro;
   lbComentario.Text := FSolictacaoColeta.Comentario;

   lbVerMais.Visible := not FSolictacaoColeta.Comentario.IsEmpty;

   if FSolictacaoColeta.Avalicao = 0 then
      lbEstrelas.Text := '-'
   else
      lbEstrelas.Text := FSolictacaoColeta.Avalicao.ToString;

   if FSolictacaoColeta.Status = sscConcluido then
   begin
      lbStatus.Text := 'Concluído';
      lbStatus.TextSettings.FontColor := TAlphaColorRec.Green;
   end
   else
   begin
      lbStatus.Text := 'Cancelado';
      lbStatus.TextSettings.FontColor := TAlphaColorRec.Red;
   end;
end;

end.
