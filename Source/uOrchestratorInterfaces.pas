unit uOrchestratorInterfaces;

interface

uses
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Dialogs, uDownloaderInterfaces;

type
  IOrchestrator = interface ['{9FD702E9-D412-4338-B497-C372E3316624}']
    procedure Start;
    function CanCloseApp: Boolean;
    procedure CancelDownload(const pbForceClose: Boolean);
  end;


implementation


end.
