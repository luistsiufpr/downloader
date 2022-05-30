unit uDownloaderInterfaces;

interface

type
  TDownloaderStatus = (dsStopped, dsRunning, dsFinishedSuccessfully, dsForceStopToClose, dsCancel, dsError);

  IDownloader = interface ['{763AD53A-D2D7-42FE-A8DA-6DD95CA9FB7A}']

    function GetErrorMessage: String;
    function GetFileTotalSize: Int64;
    function GetFileCurrentAmountDownloaded: Int64;
    function GetStatus: TDownloaderStatus;

    procedure StartDownload(const psUrl, psDestinationFileName: String);
    procedure CancelDownload(const pbForceClose: Boolean);

    property Status: TDownloaderStatus read GetStatus;
    property FileTotalSize: Int64 read GetFileTotalSize;
    property FileCurrentAmountDownloaded: Int64 read GetFileCurrentAmountDownloaded;
    property ErrorMessage: String read GetErrorMessage;
  end;


implementation


end.
