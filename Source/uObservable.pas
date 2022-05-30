unit uObservable;

interface

uses
  System.Generics.Collections, uObserverInterfaces;

type
  TObservable = class(TInterfacedObject, ISubject)
  strict private
    FObservers: TList<uObserverInterfaces.IObserver>;
  strict protected
    procedure Notify;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Attach(Observer: uObserverInterfaces.IObserver);
    procedure Detach(Observer: uObserverInterfaces.IObserver);
  end;


implementation

uses
  System.SysUtils;

{ TObservable }

constructor TObservable.Create;
begin
  inherited Create;
  FObservers := TList<uObserverInterfaces.IObserver>.Create;
end;

destructor TObservable.Destroy;
begin
  FreeAndNil(FObservers);
  inherited;
end;

procedure TObservable.Attach(Observer: uObserverInterfaces.IObserver);
begin
  FObservers.Add(Observer);
end;

procedure TObservable.Detach(Observer: uObserverInterfaces.IObserver);
begin
  FObservers.Remove(Observer);
end;

procedure TObservable.Notify;
var
  observer: uObserverInterfaces.IObserver;
begin
  for observer in FObservers do
    observer.Update(Self);
end;

end.
