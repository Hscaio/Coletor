unit UClass.View.Frame.ListEndereco;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UClass.Utils.Frame, FMX.Layouts, Skia, Skia.FMX, FMX.Controls.Presentation,
  UClass.Model.Endereco, System.Generics.Collections, FMX.Objects;

type
  TfrmListEndereco = class(TFrameUtil)
    sbFundo: TScrollBox;
    skNotFound: TSkAnimatedImage;
    lyNotFound: TLayout;
    Label3: TLabel;
    Label1: TLabel;
    lyClean: TLayout;
    imgClean: TSkAnimatedImage;
    lyAdd: TLayout;
    clAdd: TCircle;
    lbAdd: TLabel;
    procedure clAddClick(Sender: TObject);
  private
    { Private declarations }
    FListEndereco : TObjectList<TEndereco>;
    procedure AddEndereco(aEndereco : TEndereco);
  public
    { Public declarations }
     constructor Create(AOwner: TComponent); override;
     destructor Destroy; override;

     procedure Refresh;
  end;

var
  frmListEndereco: TfrmListEndereco;

implementation

{$R *.fmx}

uses UClass.View.Frame.ItemEndereco, UClass.Utils.MainScreen, UClass.View.Frame.Endereco,
  UClass.Utils.Cache, UClass.Client.Endereco, UClass.Model.Usuario,
  UClass.Utils.Notificacao;

{ TfrmListEndereco }

procedure TfrmListEndereco.AddEndereco(aEndereco: TEndereco);
var LItemEnd : TfrmItemEndereco;
begin
   lyNotFound.Visible := False;

   LItemEnd := TfrmItemEndereco.Create(Self);
   LItemEnd.Endereco := aEndereco;
   LItemEnd.ListEndereco := Self;
   LItemEnd.Align := TAlignLayout.Top;
   LItemEnd.Parent := sbFundo;
   LItemEnd.Name := 'TfrmItemEndereco' + sbFundo.Content.ControlsCount.ToString;

   lyClean.Parent := sbFundo;
   lyClean.Align := TAlignLayout.Top;
   lyClean.Position.Y := sbFundo.Height + 1;
end;

procedure TfrmListEndereco.clAddClick(Sender: TObject);
begin
   inherited;
   TMainScreen.GetInstance.Show<TfrmEndereco>(nil);
end;

constructor TfrmListEndereco.Create(AOwner: TComponent);
var LUsuario : TUsuario;
    LEndereco : TEndereco;
begin
   inherited;

   try
      FListEndereco := TObjectList<TEndereco>(TCache.GetInstance.Get(chListaEndereco));

      if not Assigned(FListEndereco) then
      begin
         LUsuario := TUsuario(TCache.GetInstance.Get(chUsuario));

         if not Assigned(LUsuario) then
            raise Exception.Create('N�o foi localizado os dados do usu�rio para buscar os endere�os!');

         FListEndereco := TClientEndereco.GetInstance.EnderecosDoUsuario(LUsuario.Codigo);
         TCache.GetInstance.Add(chListaEndereco,FListEndereco);
      end;

      for LEndereco in FListEndereco do
          AddEndereco(LEndereco);

      Refresh;
   except on E: Exception do
      begin
         TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
               lyClean.Visible := False;
               lyNotFound.Visible := True;
               TDialoger.GetInstance.ShowMessage(E.Message);
            end
         );
      end;
   end;
end;

destructor TfrmListEndereco.Destroy;
begin
   inherited;
end;

procedure TfrmListEndereco.Refresh;
begin
  lyClean.Visible := FListEndereco.Count > 0;
  lyNotFound.Visible := FListEndereco.Count = 0;
end;

end.
