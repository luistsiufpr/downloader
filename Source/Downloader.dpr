program Downloader;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {Main},
  uDownloader in 'uDownloader.pas',
  uDownloaderInterfaces in 'uDownloaderInterfaces.pas',
  uFactory in 'uFactory.pas',
  uModelObserver in 'uModelObserver.pas',
  uObservable in 'uObservable.pas',
  uObserverInterfaces in 'uObserverInterfaces.pas',
  uOrchestrator in 'uOrchestrator.pas',
  uOrchestratorInterfaces in 'uOrchestratorInterfaces.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
