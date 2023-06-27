unit UClass.Client.Base;

interface

uses System.SysUtils,
     System.JSON,
     System.Net.HttpClient,
     System.Net.HttpClientComponent;

type
  IClientBase = interface
  ['{4794AE80-CE54-48B4-A343-ECD3A9E1A58F}']
     function GetInstance : IClientBase;
  end;

  TClientBase = class(TInterfacedObject, IClientBase)
  strict private var FInstance : IClientBase;
  private
     constructor CreatePrivate; virtual; abstract;
  public
     function GetInstance : IClientBase; virtual; abstract;
  end;

implementation

{ TClientBase }

end.
