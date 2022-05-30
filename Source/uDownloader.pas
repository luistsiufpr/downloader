unit uDownloader;

interface

uses
  System.Threading, System.Net.HttpClientComponent, System.Net.HttpClient, System.Classes,
  uObserverInterfaces, uObservable, System.SysUtils, uDownloaderInterfaces;

type
  TDownloader = class(TObservable, ISubject, IDownloader)

  strict private
    oHTTPRequest: TNetHTTPRequest;
    oHTTPClient: TNetHTTPClient;
    sUrl, sDestinationFileName, sErrorMessage: String;
    iFileTotalSize, iFileCurrentAmountDownloaded: Int64;
    eDownloaderStatus: TDownloaderStatus;

    procedure DownloadFile;
    procedure NetHTTPRequestRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
    procedure NetHTTPRequestReceiveData(const Sender: TObject; AContentLength, AReadCount: Int64; var AAbort: Boolean);
    procedure NetHTTPRequestRequestException(const Sender: TObject; const AError: Exception);
    procedure NetHTTPRequestRequestError(const Sender: TObject; const AError: string);
  private
    function GetStatus: TDownloaderStatus;

  public
    aTask: array[0..0] of ITask;
    constructor Create(AOwner: TComponent);

    procedure StartDownload(const psUrl, psDestinationFileName: String);
    procedure CancelDownload(const pbForceClose: Boolean);
    function GetErrorMessage: String;
    function GetFileTotalSize: Int64;
    function GetFileCurrentAmountDownloaded: Int64;

    property FileTotalSize: Int64 read GetFileTotalSize;
    property FileCurrentAmountDownloaded: Int64 read GetFileCurrentAmountDownloaded;
    property ErrorMessage: String read GetErrorMessage;
    property Status: TDownloaderStatus read GetStatus;
  end;

implementation


{ TDownloader }

procedure TDownloader.CancelDownload(const pbForceClose: Boolean);
begin
  if pbForceClose then
    eDownloaderStatus := TDownloaderStatus.dsForceStopToClose
  else
    eDownloaderStatus := TDownloaderStatus.dsCancel
end;

constructor TDownloader.Create(AOwner: TComponent);
begin
  inherited Create;

  eDownloaderStatus := TDownloaderStatus.dsStopped;
  oHTTPRequest := TNetHTTPRequest.Create(AOwner);
  oHTTPClient := TNetHTTPClient.Create(AOwner);

  oHTTPRequest.Client := oHTTPClient;
  oHTTPRequest.OnRequestCompleted := NetHTTPRequestRequestCompleted;
  oHTTPRequest.OnReceiveData := NetHTTPRequestReceiveData;
  oHTTPRequest.OnRequestException := NetHTTPRequestRequestException;
  oHTTPRequest.OnRequestError := NetHTTPRequestRequestError;
end;

procedure TDownloader.DownloadFile;
begin
  oHTTPRequest.Get(sUrl);
end;

function TDownloader.GetErrorMessage: String;
begin
  Result := sErrorMessage;
end;

function TDownloader.GetFileCurrentAmountDownloaded: Int64;
begin
  Result := iFileCurrentAmountDownloaded;
end;

function TDownloader.GetFileTotalSize: Int64;
begin
  Result := iFileTotalSize;
end;

function TDownloader.GetStatus: TDownloaderStatus;
begin
  Result := eDownloaderStatus;
end;

procedure TDownloader.NetHTTPRequestReceiveData(const Sender: TObject; AContentLength, AReadCount: Int64; var AAbort: Boolean);
begin
  if eDownloaderStatus = TDownloaderStatus.dsRunning then
  begin
    if iFileTotalSize <> AContentLength then
      iFileTotalSize := AContentLength;
    iFileCurrentAmountDownloaded := AReadCount;

    TThread.Queue(TThread.CurrentThread, Notify);
  end
  else
    AAbort:= True;
end;

procedure TDownloader.NetHTTPRequestRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
var
  oMemoryStream: TMemoryStream;
begin
  oMemoryStream := TMemoryStream.Create;
  oMemoryStream.LoadFromStream(AResponse.ContentStream);
  oMemoryStream.SaveToFile(sDestinationFileName);
  FreeAndNil(oMemoryStream);

  if eDownloaderStatus <> TDownloaderStatus.dsForceStopToClose then
    if iFileTotalSize = iFileCurrentAmountDownloaded then
      eDownloaderStatus := TDownloaderStatus.dsFinishedSuccessfully
    else
      eDownloaderStatus := TDownloaderStatus.dsStopped;

  TThread.Queue(TThread.CurrentThread, Notify);
end;

procedure TDownloader.NetHTTPRequestRequestError(const Sender: TObject; const AError: string);
begin
  eDownloaderStatus := TDownloaderStatus.dsError;
  sErrorMessage := AError;

  TThread.Queue(TThread.CurrentThread, Notify);
end;

procedure TDownloader.NetHTTPRequestRequestException(const Sender: TObject; const AError: Exception);
begin
  eDownloaderStatus := TDownloaderStatus.dsError;
  sErrorMessage := AError.Message;

  TThread.Queue(TThread.CurrentThread, Notify);
end;

procedure TDownloader.StartDownload(const psUrl, psDestinationFileName: String);
begin
  eDownloaderStatus := TDownloaderStatus.dsRunning;
  sErrorMessage := EmptyStr;

  sUrl := psUrl;
  sDestinationFileName := psDestinationFileName;

  aTask[0] := TTask.Create(DownloadFile);
  aTask[0].Start;
end;


end.
