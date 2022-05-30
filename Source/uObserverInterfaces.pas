unit uObserverInterfaces;

interface


type
  IObserver = interface ['{ADA3CFC6-064C-4806-8B9C-B7A7399BA39C}']
    procedure Update(Subject: TObject);
  end;

  

  ISubject = interface ['{FF6047EE-288B-4220-BDAB-E72187CE2E2F}']
    procedure Attach(Observer: IObserver);
    procedure Detach(Observer: IObserver);
  end;


implementation


end.
