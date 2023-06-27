unit UClass.Model.Google.Geocode;

interface

uses System.SysUtils,
     System.JSON,
     UClass.Model.Base,
     UClass.Utils.Format;

type
   TGeocode = class(TModelBase)
   private
      FStatus : String;
      FAddress : String;
      FLng : Double;
      FLat: Double;
   public
      constructor Create;

      property Status : String read FStatus write FStatus;
      property Lat : Double read FLat write FLat;
      property Lng : Double read FLng write FLng;
      property Address : String read FAddress write FAddress;

      procedure JSONToObject(aJSON : TJSONObject); override;
   end;


implementation

{ TGeocode }

constructor TGeocode.Create;
begin
   FStatus  := '';
   FAddress := '';
   FLng     := 0;
   FLat     := 0 ;
end;

procedure TGeocode.JSONToObject(aJSON: TJSONObject);
var LJSONArr : TJSONArray;
    LJSONGeometry : TJSONObject;
    LJSONLocation : TJSONObject;
begin
   inherited;
   FStatus := aJSON.GetValue('status').Value;
   LJSONArr := aJSON.GetValue('results') as TJSONArray;

   if LJSONArr.Count < 1 then
      Exit;

   FAddress := TJSONObject(LJSONArr.Items[0]).GetValue('formatted_address').Value;

   LJSONGeometry := TJSONObject(LJSONArr.Items[0]).GetValue('geometry') as TJSONObject;
   LJSONLocation := LJSONGeometry.GetValue('location') as TJSONObject;
   FLat          := StrToFloatDef(LJSONLocation.GetValue('lat').Value.Replace('.',','),0);
   FLng          := StrToFloatDef(LJSONLocation.GetValue('lng').Value.Replace('.',','),0);
end;

end.
