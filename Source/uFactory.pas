unit uFactory;

interface

uses
  uOrchestratorInterfaces, uDownloaderInterfaces, uObserverInterfaces, System.Classes, System.SysUtils, uDownloader, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls;

type
  TFactory = class
  public
    class function CreateOrchestrator(poDownloader: IDownloader; poEditUrl: TEdit; poSaveDialog: TSaveDialog;
      poProgressBar: TProgressbar; poButtonIniciar, poButtonCancelar: TButton): IOrchestrator;
    class function CreateDownloader(AOwner: TComponent): IDownloader;
  end;

implementation

{ TFactory }

uses
  uOrchestrator;

class function TFactory.CreateDownloader(AOwner: TComponent): IDownloader;
begin
  Result := TDownloader.Create(AOwner);
end;

class function TFactory.CreateOrchestrator(poDownloader: IDownloader; poEditUrl: TEdit; poSaveDialog: TSaveDialog;
  poProgressBar: TProgressbar; poButtonIniciar, poButtonCancelar: TButton): IOrchestrator;
begin
  Result := TOrchestrator.Create(poDownloader, poEditUrl, poSaveDialog, poProgressBar, poButtonIniciar, poButtonCancelar) as IOrchestrator;
end;

end.
