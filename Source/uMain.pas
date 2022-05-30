unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  uDownloaderInterfaces, uOrchestratorInterfaces;

type
  TMain = class(TForm)
    pbDownload: TProgressBar;
    edtUrl: TEdit;
    Image1: TImage;
    Label1: TLabel;
    btnIniciarDownload: TButton;
    btnPararDownload: TButton;
    btnExibirHistorico: TButton;
    Bevel1: TBevel;
    svDialog: TSaveDialog;
    procedure btnIniciarDownloadClick(Sender: TObject);
    procedure btnPararDownloadClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    oDownloader: IDownloader;
    oOrchestrator: IOrchestrator;
  public
    { Public declarations }
  end;

var
  Main: TMain;

implementation

{$R *.dfm}

uses
  uFactory;

procedure TMain.btnIniciarDownloadClick(Sender: TObject);
begin
  oOrchestrator.Start;
end;

procedure TMain.btnPararDownloadClick(Sender: TObject);
begin
  oOrchestrator.CancelDownload(False);
end;

procedure TMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := oOrchestrator.CanCloseApp;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  oDownloader := TFactory.CreateDownloader(Self);
  oOrchestrator := TFactory.CreateOrchestrator(
    oDownloader,
    edtUrl,
    svDialog,
    pbDownload,
    btnIniciarDownload,
    btnPararDownload
  );
end;

end.
