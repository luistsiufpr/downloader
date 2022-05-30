unit uModelObserver;

interface

uses
  uObservable, uObserverInterfaces, System.SysUtils;

type
  TModelObserver = class(TInterfacedObject, uObserverInterfaces.IObserver)
  strict private
    oNotifier: TProc<TObservable>;
  public
    constructor Create(ppNotifier: TProc<TObservable>);
    procedure Update(Subject: TObject);
  end;

implementation

{ TModelObserver }

constructor TModelObserver.Create(ppNotifier: TProc<TObservable>);
begin
  inherited Create;
  oNotifier := ppNotifier;
end;

procedure TModelObserver.Update(Subject: TObject);
begin
  oNotifier(Subject as TObservable);
end;

end.
