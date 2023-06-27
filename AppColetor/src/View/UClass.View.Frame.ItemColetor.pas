unit UClass.View.Frame.ItemColetor;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UClass.Utils.Frame, FMX.Objects, FMX.Controls.Presentation, FMX.Layouts,
  UClass.View.Frame.ListColeta, UClass.Model.Endereco;

type
  TfrmItemColeta = class(TFrameUtil)
    lyFundo: TLayout;
    lbEndereco: TLabel;
    imgColeta: TImage;
    lbBairro: TLabel;
    lbFixo: TLabel;
    lnLine: TLine;
    lbComplemento: TLabel;
    procedure lyFundoClick(Sender: TObject);
  private
    { Private declarations }
     FOwnerList : TfrmListColeta;
     FEndereco: TEndereco;
     procedure SetEndereco(const Value: TEndereco);
  public
    { Public declarations }
     property OwnerList : TfrmListColeta read FOwnerList write FOwnerList;
     property Endereco : TEndereco read FEndereco write SetEndereco;
  end;

var
  frmItemColeta: TfrmItemColeta;

implementation

{$R *.fmx}

{ TfrmItemColeta }

procedure TfrmItemColeta.lyFundoClick(Sender: TObject);
begin
   inherited;
   FOwnerList.SelectEndereco(FEndereco,Self);
end;

procedure TfrmItemColeta.SetEndereco(const Value: TEndereco);
begin
   FEndereco := Value;

   if not Assigned(FEndereco) then
      Exit;

   lbEndereco.Text    := FEndereco.Endereco + ', ' + FEndereco.Numero;
   lbBairro.Text      := FEndereco.Bairro + ' - ' + FEndereco.Cidade + '/' + FEndereco.Estado;
   lbComplemento.Text := FEndereco.Complemento;
   lbComplemento.Visible := not FEndereco.Complemento.Trim.IsEmpty;

   if not lbComplemento.Visible then
      Self.Height := Self.Height - lbComplemento.Height;
end;

end.
