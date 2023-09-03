unit UGNSSProject;

interface

uses GeoClasses, Geoid;

procedure PrepareNewGNSSProject;
procedure RefreshGNSSProjectCSs;
procedure SaveGNSSProject;


var ProjectName :String;
    ProjectFile :String;

    PrjCSNames: array of String;
    PrjCS: array of Integer;

    PrjGeoidName :string;
    PrjGeoid :Integer;
implementation

procedure PrepareNewGNSSProject;
var I:Integer;
begin
  ProjectName := 'New';
  ProjectFile := '';

  SetLength(PrjCSNames, 2);
  PrjCSNames[0] := 'WGS84_ECEF';
  PrjCSNames[1] := 'WGS84_LatLon';
  PrjGeoidName := 'EGM2008';

  RefreshGNSSProjectCSs;
end;

procedure RefreshGNSSProjectCSs;
var I, j :Integer;
begin
  SetLength(PrjCS, Length(PrjCSNames));
  for I := 0 to Length(PrjCSNames) - 1 do
    PrjCS[I] := FindCoordinateSystem(PrjCSNames[I]);

  /// Delete errornous ones
  for I := Length(PrjCS) - 1 downto 0 do
    if PrjCS[I] = -1 then
    begin
      for j := I to Length(PrjCS) - 2 do
        PrjCS[j] := PrjCS[j+1];
      SetLength(PrjCS, Length(PrjCS) - 1);
    end;

 // Geoid
 if Length(GeoidList)< 1 then
 begin
   SetLength(GeoidList, 1);
   ReloadGeoidByID(PrjGeoidName, 0);
 end;
 
end;

procedure SaveGNSSProject;
begin
  if ProjectFile = '' then
    exit;
end;

end.
