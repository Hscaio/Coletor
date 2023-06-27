unit UClass.View.Frame.ConfigAdmin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UClass.Utils.Frame, FMX.Objects, FMX.Layouts, FMX.Edit,
  FMX.Controls.Presentation;

type
  TfrmConfigAdm = class(TFrameUtil)
    recFundo: TRectangle;
    lyMenu: TLayout;
    imgBack: TImage;
    lyTop: TLayout;
    lyHost: TLayout;
    lbHost: TLabel;
    lyIP: TLayout;
    rcIP: TRectangle;
    edIP: TEdit;
    lyBot: TLayout;
    lySalvar: TLayout;
    rcSalvar: TRectangle;
    lbSalvar: TLabel;
    procedure lySalvarClick(Sender: TObject);
    procedure imgBackClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmConfigAdm: TfrmConfigAdm;

implementation

{$R *.fmx}

uses UClass.Consts.URL, UClass.Utils.MainScreen, UClass.View.Frame.Menu;

{ TFrameUtil1 }

constructor TfrmConfigAdm.Create(AOwner: TComponent);
begin
   inherited;
   edIP.Text := URL_MSCOLETOR;
end;

procedure TfrmConfigAdm.imgBackClick(Sender: TObject);
begin
   inherited;
   TMainScreen.GetInstance.Show<TfrmMenu>(nil);
end;

procedure TfrmConfigAdm.lySalvarClick(Sender: TObject);
begin
   inherited;
   if edIP.Text.Trim.IsEmpty then
      Exit;

   SaveURL_MSCOLETOR(edIP.Text);
   TMainScreen.GetInstance.Show<TfrmMenu>(nil);
end;

end.
