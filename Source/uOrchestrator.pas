unit uOrchestrator;

interface

uses
  uObserverInterfaces, Vcl.ComCtrls, System.SysUtils, Vcl.StdCtrls, Vcl.Dialogs, uOrchestratorInterfaces, uDownloaderInterfaces, uDownloader,
  uObservable, uModelObserver;

type
  TOrchestrator = class(TModelObserver, IOrchestrator)
  strict private
    oEditUrl: TEdit;
    oSaveDialog: TSaveDialog;
    oDownloader: IDownloader;
    oProgressBar: TProgressBar;
    oButtonIniciar, oButtonCancelar: TButton;
  private

  public
    constructor Create(poDownloader: IDownloader; poEditUrl: TEdit; poSaveDialog: TSaveDialog; poProgressBar: TProgressBar;
      poButtonIniciar, poButtonCancelar: TButton);
    procedure UpdateUI(Subject: TObservable);
    procedure Start;
    function CanCloseApp: Boolean;
    procedure CancelDownload(const pbForceClose: Boolean);
  end;


implementation

uses
  System.UITypes, Vcl.Forms;

procedure TOrchestrator.CancelDownload(const pbForceClose: Boolean);
begin
  oDownloader.CancelDownload(pbForceClose);
end;

function TOrchestrator.CanCloseApp: Boolean;
begin
  if Assigned(oDownloader) and (oDownloader.Status = TDownloaderStatus.dsRunning) then
  begin
    Result := False;
    if MessageDlg('Download em andamento. Deseja cancelar o download e fechar?', TMsgDlgType.mtWarning, [mbYes, mbNo], 0) = mrYes then
      oDownloader.CancelDownload(True);
  end
  else
    Result := True;
end;

constructor TOrchestrator.Create(poDownloader: IDownloader; poEditUrl: TEdit; poSaveDialog: TSaveDialog; poProgressBar: TProgressBar;
  poButtonIniciar, poButtonCancelar: TButton);
begin
  inherited Create(UpdateUI);

  oSaveDialog := poSaveDialog;
  oEditUrl := poEditUrl;
  oDownloader := poDownloader;
  oProgressBar := poProgressBar;
  oButtonIniciar := poButtonIniciar;
  oButtonCancelar := poButtonCancelar;

  (oDownloader as ISubject).Attach(Self);
end;

procedure TOrchestrator.Start;
  function ExtractUrlFileName(const AUrl: string): string;
  var
    i: Integer;
  begin
    i := LastDelimiter('/', AUrl);
    Result := Copy(AUrl, i + 1, Length(AUrl) - (i));
  end;
begin
  oSaveDialog.Filter := 'Files' + ExtractFileExt(oEditUrl.Text) + '|*' + ExtractFileExt(oEditUrl.Text);
  oSaveDialog.FileName := ExtractUrlFileName(oEditUrl.Text);
  if oSaveDialog.Execute then
  begin
    oDownloader.StartDownload(oEditUrl.Text, oSaveDialog.FileName);
  end;
end;

procedure TOrchestrator.UpdateUI(Subject: TObservable);
begin
  if (TInterfacedObject(Subject) as IDownloader).Status = TDownloaderStatus.dsForceStopToClose then
    Application.MainForm.Close
  else if (TInterfacedObject(Subject) as IDownloader).Status = TDownloaderStatus.dsFinishedSuccessfully then
  begin
    Application.ProcessMessages;
    ShowMessage('Download finalizado com sucesso!');
  end
  else
  begin
    if oProgressBar.Max <> (TInterfacedObject(Subject) as IDownloader).FileTotalSize then
      oProgressBar.Max := (TInterfacedObject(Subject) as IDownloader).FileTotalSize;
    oProgressBar.Position := (TInterfacedObject(Subject) as IDownloader).FileCurrentAmountDownloaded;
    Application.ProcessMessages;
  end;
  oButtonIniciar.Enabled := ((TInterfacedObject(Subject) as IDownloader).Status <> TDownloaderStatus.dsRunning);
  oButtonCancelar.Enabled := (TInterfacedObject(Subject) as IDownloader).Status = TDownloaderStatus. dsRunning;
end;

end.
