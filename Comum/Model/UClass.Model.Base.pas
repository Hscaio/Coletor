unit UClass.Model.Base;

interface

uses System.JSON,
     System.Generics.Collections;

type
   TModelBase = class
   public
      function ObjectToJSON : TJSONObject; virtual; abstract;
      procedure JSONToObject(aJSON : TJSONObject); virtual; abstract;

      class function ListToJSON<T : constructor, TModelBase>(aList : TObjectList<T>) : TJSONArray;
      class function JSONToList<T : constructor, TModelBase>(aJSON : TJSONArray) : TObjectList<T>;
   end;

implementation

{ TModelBase }

class function TModelBase.JSONToList<T>(aJSON: TJSONArray): TObjectList<T>;
var LItemJSON : TJSONValue;
    LItemObj : T;
begin
   Result := TObjectList<T>.Create;

   for LItemJSON in aJSON do
   begin
      LItemObj := T.Create;
      TModelBase(LItemObj).JSONToObject(TJSONObject(LItemJSON));
      Result.Add(LItemObj);
   end;
end;

class function TModelBase.ListToJSON<T>(aList: TObjectList<T>): TJSONArray;
var LItem : T;
begin
   Result := TJSONArray.Create;

   for LItem in aList do
      Result.Add(LItem.ObjectToJSON);
end;

end.
