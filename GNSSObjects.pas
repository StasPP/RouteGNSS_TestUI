unit GNSSObjects;

interface

uses GeoString, GeoTime, Classes, SysUtils, TabFunctions, DateUtils, Dialogs,
    ComCtrls, Math, GeoClasses;

type
  TGNSSSatSystems = record
    isGPS, isGLO, isBDS, isGAL,
    isSBAS, isQZSS, isNAVIC :boolean;
  end;

  TGNSSAntHgt = record
    Hant  :Double;
    Hant_u:Double;
    Hkind :Byte; // 0- to phase center, 1- to the bottom, 2- slant
  end;

  TGNSSAntenna = record
    AntName  :string;
    dN, dE   :double;
  end;

  TGNSSAntennaPCV = record
    AntName       :string;
    AntDescripton :string;
    isNew         :boolean;
    LineN         :integer;

    Radius        :Double;
    GroundPlaneH  :Double;

    L1E, L1N, L1H :Double;
    L2E, L2N, L2H :Double;

    L1Corr, L2Corr:Array[0..20] of Double;
  end;

  //// -------------------------------------------------------------------------

  TGNSSStopPoint = record
     SessionID    :String;  /// ID of the Session in which the point is
     Pos          :TXYZ;
     Name         :string;
     MaskName     :string;
     AntHgt       :TGNSSAntHgt;
     dN, dE       :Double;
     StartT, EndT :TDateTime;
     Status       :byte;
  end;

  TStDevs = array[1..6] of Double;

  TGNSSSolution = record
    SolutionQ    :Byte; // 0 - Error,   1 - Fixed, 2 - Float, 3 -SBAS, 4-DGNSS, 5-Single, 6-PPP (RTKLib)
    SolutionKind :Byte; // 0 - ApproxRIN, 1- Single, 2 - Baseline, 3 - PPP
    BaseID       :string;  // if Baseline

    // Static / StartPoint
    PointPos     :TXYZ;
    //StDevs       :array[1..6] of Double;
    StDevs       :TStDevs;

    // Kinematic
    //Track        :TTrack;
  end;

  //// -------------------------------------------------------------------------

  TGNSSSession = record
    RinVersion      :real;
    Comment         :string;
    isVisible       :boolean;
    GNSSMeasurements:array of string;

    FileName        :string;
    MaskName        :string;
    Station         :string;
    AdditionalFiles :array of string;
    SessionID       :string;

    isKinematic     :boolean;

    SatSystems      :TGNSSSatSystems;
    StartTime       :TDateTime;
    EndTime         :TDateTime;

    Antenna         :TGNSSAntenna;
    AntHgt          :TGNSSAntHgt;

    AppliedPos      :TXYZ;
    GNSSPointName   :string;
    PositionID      :byte;  // -1 - User defined, else: from Positions Array

    // Solutions
    Solutions       :Array of TGNSSSolution;
    StatusQ         :Byte; // Best solution status

    // Kinematic
    Stops           :Array of TGNSSStopPoint;
  end;

  TGNSSVector = record
     StatusQ  :integer; // 0-not done, 1 - Fixed, 2 - Float, ... (RTKLib)

     BaseID   :string; // SessionID
     RoverID  :string; // SessionID

     dX, dY, dZ :Double;
     StDevs     :TStDevs;
  end;

  TSolutionId = record
      SessionId :String;
      SolutionN :integer;
  end;

  TGNSSPoint = record
     PointName   :string;
     HasErrors   :array[0..5] of Boolean; // 1 - Bad sessions, 2 - ...
     Active      :boolean;
     IsBase      :boolean;
     Sessions    :array of string; // SessionIDs

     CoordSource :byte; // 0 - Average from RINEX Headers
                        // 1 - Single/PPP Average
                        // 2 - BaseLines Adjustment
                        // 3 - Choosed Solution (from one of the sessions)
                        // 4 - Definded by User

     Status      :byte; // as for Session + 8 Error, 9 - Adjustment: OK, 10 -Adjustment:Bad

     SolutionId :TSolutionId; // if Source = 2
     Position   :TXYZ;        // Accepted Coordinates
     Quality    :TStDevs;     // StDevs
  end;

  function OpenRINEX (FileName:string; ProgressBar: TProgressBar):Boolean;
     overload;
  function OpenRINEX (FileName:string):Boolean;   overload;

  procedure AnalyseSessionRINEX(var Session:TGNSSSession;
    ProgressBar: TProgressBar);

  procedure GNSSSessionAddAdditionalFile(var Session:TGNSSSession;
      AddFileName:string);
  procedure GNSSSessionDelAdditionalFile(var Session:TGNSSSession;
      DelFileName:string);

  procedure DelGNSSSession(SessionId:string);  overload  // Delete all connected data (solutions, vectors) + Change/hide Points
  procedure DelGNSSSession(SessionN:integer);  overload

  function GetGNSSSessionNumber(SessionId:String):integer;
  procedure GNSSSessionApplyCoordinates(SessionN:integer; Coords:TXYZ;
        UpdN:integer = 0);

  procedure AddOrUpdateGNSSStation(SessionN:integer; isNew:boolean); overload
  procedure AddOrUpdateGNSSStation(SessionId:string; isNew:boolean); overload

  procedure CheckGNSSPoints;
  function GetGNSSPointNumber(PointName: string):integer;
  procedure RefreshGNSSPoint(PointN: integer; UpdN:integer = 0);
  procedure DeleteSessionFromPoint(PointN :integer; SessionId:string);

  procedure SetGNSSPointUserCoords(PointN: integer; X, Y, Z :Double);
  procedure SetGNSSPointSource(PointN, SolSource, SessionNumber,
        SolutionNumber:integer; UpdN:integer = 0);

  function GetSolutionSubStatus(SessionN, SolutionN:integer):byte;
  function GetGNSSSolutionForVector(VectorN:integer):TSolutionId; overload;
  function GetGNSSSolutionForVector(SessionN:integer; BaseId:string):integer;
    overload;
  procedure RefreshGNSSSolution(SessionN, SolutionN:integer;
    ChangeVectors:Boolean);  // Change all connected data (sessions, Vector status, points)
  procedure DeleteGNSSSolution(SessionN, SolutionN:integer);   // Change all connected data (sessions, Vector status, points)

  procedure AddGNSSVectorsForSession(SessionId:string);  overload
  procedure AddGNSSVectorsForSession(SessionN:integer);  overload

  procedure DelGNSSVectorsForSession(SessionId:string);  overload
  procedure DelGNSSVectorsForSession(SessionN:integer);  overload

  procedure CheckGNSSVectorsForSession(SessionId:string);  overload
  procedure CheckGNSSVectorsForSession(SessionN:integer);  overload

  function GetGNSSVector(RoverId, BaseId:String):integer;
  function GetGNSSVectorPoint(VectN: Integer; isBase: boolean):String;
  function GetGNSSVectorGroupStatus(VectN: Array of Integer):integer;
  procedure EnableGNSSVector(VectorN:integer);
  procedure DisableGNSSVector(VectorN:integer);
  procedure InvertGNSSVector(VectorN:integer; GroupInv:Boolean = true);

  //procedure LoadMessagesFromFile;

  function GetAntParams(AntName:string):TGNSSAntennaPCV;
  function GetAntH(rawH:Double; AntName:string; Method: byte): Double;

  procedure AddAntennaToPCV(NewAnt:TGNSSAntennaPCV);
  procedure LoadAntennasPCV(FileName:String; Filename2:String = '');
  /// ToDo procedure UpdateAntennasPCV(FileName:String);

  procedure DebugMSG(s:string);

  procedure DestroyGNSSObjs;
var
  GNSSSessions  :array of TGNSSSession;
  GNSSVectors   :array of TGNSSVector;
  GNSSPoints    :array of TGNSSPoint;

  PCVFile, ARFile :TStringList;
  PCVFilePath     :string = 'Data\GNSS\ngs_abs.pcv';
  ARFilePath      :string = 'Data\GNSS\AntRad.txt';
  GNSSAntNames    :array of string;

  GNSSMessages  :array [0..5] of String = ('File is Already opened',
                                           'Error reading Obs file',
                                           'ERROR: Station/Sessions updating stack overflow!',
                                           'Infinity loop detected! Disabling the vector: ',
                                           'Reserved',
                                           'Reserved');
  GNSSDebug     :TStringList;
  GNSSDebuging  :boolean = True;          /// ToDO: False!

/// Anti-loop cratch!
const
  GNSSMaxUpdateStack = 10000;

/// Disable Kinematic and Stop-and-Go
const
  isStaticOnly = true;
var
  GNSSPointsUpdateStack: array [0..GNSSMaxUpdateStack] of integer;

const StatusNames: array [0..10] of String = ('[Not processed]',
          '[Fixed]', '[Float]', '[SBAS]', '[DGPS]', '[Single]', '[PPP]',
          '', '[Error!!!]', '[Adjusted: OK]', '[Adjusted: Poor Solutions]');
const SolSourcesNames: array [0..4] of String = (' from RINEX headers',
    ' from Single/PPP solutions', ' from Baselines Adjustment',
    ' from Solution', ' User defined');
implementation

/////////////// AUXIMILAR STUFF ------------------------------------------------

function BareId(s:string):string;
var I: Integer;
begin
  result := s;
  for I := Length(s) - 1 downto 0 do
    if s[I] = '_' then
    begin
      result := copy(s, 1, I - 1);
      break;
    end;
end;

procedure DebugMSG(s:string);
begin
  if not GNSSDebuging then
    exit;

  if GNSSDebug = nil then
    GNSSDebug := TStringList.Create;

  GNSSDebug.Add(TimeToStr(Now)+' '+s);
end;


function GetDateTime(Str:String; Method: byte):TDateTime;   {�������� ���� � ����� �� ������}
var
   DTI     :Array [0..6] of Integer;  /// Variable for DateTime Decoding
   D       :Double;                   /// Seconds.milliseconds
   K       :Integer;
   SubStr  :String;
begin

  D := 0;

  // DTI:
  // 0 - Year, 1 - Month, 2 - Day, 3 - Hour, 4 - Min., 5 - Sec., 6 - mSec.
  case Method of
    0:   {YYYY MM DD  - Date only}
    begin
       for K := 0 to 2 do
         DTI[K] := StrToInt(GetCols(str, K, 1, ' ', false));

       for K := 3 to 6 do
         DTI[K] := 0;
    end;
    1:   {YYYY MM DD hh mm ss.zzz}
    begin
      for K := 0 to 4 do
         DTI[K] := StrToInt(GetCols(str, K, 1, ' ', false));

      D := StrToFloat(GetCols(str, 5, 1, ' ', true));
    end;
    2:  {DDMMYY hhmmss.zzzzzzz}
    begin
       substr := GetCols(Str, 0, 1, ' ', false);

       DTI[2] := StrToInt(Copy(SubStr, length(Substr)-1, 2));
       DTI[1] := StrToInt(Copy(SubStr, length(Substr)-3, 2));
       DTI[0] := StrToInt(Copy(SubStr, 1, length(Substr)-4));

       substr := GetCols(Str, 1, 1, ' ', false);

       DTI[3] := StrToInt(Copy(SubStr, 1, 2));
       DTI[4] := StrToInt(Copy(SubStr, 3, 2));
       D := StrToFloat2(Copy(SubStr, 5, length(SubStr)-4));
    end;
  end;
  DTI[5] := Trunc(D);
  DTI[6] := Trunc((D-DTI[5])*1000);
  if DTI[0] < 1900 then
  Begin
     if DTI[0] < 80 then
       DTI[0] := 2000 + DTI[0]
       else
         DTI[0] := 1900 + DTI[0];
  End;
  Result := EncodeDateTime(DTI[0], DTI[1], DTI[2], DTI[3], DTI[4], DTI[5], DTI[6]);
end;


procedure RinexTimeToUTC(var DT:TDateTime; TS :string; LS :double);
begin
  If TS = '' then exit;

  if TS = 'GPS' then
  begin
    if LS = 0 then
       GPSToUTC(DT)
    else
       DT := DT - LS/86400;
  end;

  if TS = 'GLO' then
  begin
      DT := DT - 3/24;
  end;

end;

Function GetfilesizeEx( const filename: String ): int64;
Var
   SRec: TSearchrec;
   converter: packed record
     case Boolean of
       false: ( n: int64 );
       true : ( low, high: LongWORD );
     end;  
Begin
 Try
    If FindFirst( filename, faAnyfile, SRec ) = 0 Then Begin
      converter.low := SRec.FindData.nFileSizeLow;
      converter.high:= SRec.FindData.nFileSizeHigh;
      Result:= converter.n;
      FindClose( SRec );
    End
    Else
      Result := -1;
 Except
   Result := -1;
 End;
End;

///////////// SESSIONS ---------------------------------------------------------

procedure DelGNSSSession(SessionN:integer);  overload
var I:Integer;
begin
  // 1. Delete All related Solutions
  for I := Length(GNSSSessions[SessionN].Solutions)-1 downto 0 do
    DeleteGNSSSolution(SessionN, I);

  // 2. Delete All related Vectors
  DelGNSSVectorsForSession(SessionN);

  // 3 Delete Session from Point
  I := GetGNSSPointNumber(GNSSSessions[SessionN].Station);
  if I > -1 then
    DeleteSessionFromPoint(I, GNSSSessions[SessionN].SessionID);

  // 4. Delete Session itself
  for I := SessionN to Length(GNSSSessions) - 2 do
    GNSSSessions[I] := GNSSSessions[I+1];

  I := Length(GNSSSessions);
  SetLength(GNSSSessions, I-1);

  // 5. Check Stations
  CheckGNSSPoints;
end;

procedure DelGNSSSession(SessionId:string);  overload  // Delete all connected data (solutions, vectors) + Change/hide Points
var I:Integer;
begin
  I := GetGNSSSessionNumber(SessionId);
  if I > -1 then
      DelGNSSSession(I);
end;

procedure GNSSSessionAddAdditionalFile(var Session:TGNSSSession;
    AddFileName:string);
var j :Integer;
    alreadyAdded :boolean;
begin
  alreadyAdded := false;
  with Session do
  begin
      for j := 0 to Length(AdditionalFiles)  - 1 do
        if AdditionalFiles[j] = AddFileName then
           alreadyAdded := true;

       if not alreadyAdded then
       begin
          j := Length(AdditionalFiles);
          SetLength(AdditionalFiles, j+1);
          AdditionalFiles[j] := AddFileName;
       end;
  end;
end;

procedure GNSSSessionDelAdditionalFile(var Session:TGNSSSession;
      DelFileName:string);
var
   I, j : integer;
begin
   with Session do
   begin
     j := -1;
     for I := 0 to Length(AdditionalFiles) - 1 do
       if DelFileName = AdditionalFiles[I] then
        j := I;

     if j < 0 then
       exit;

     for I := j to Length(AdditionalFiles) - 2 do
       AdditionalFiles[i] := AdditionalFiles[i+1];
     SetLength(AdditionalFiles, Length(AdditionalFiles) - 1);
   end;
end;

procedure AnalyseSessionRINEX(var Session:TGNSSSession;
    ProgressBar: TProgressBar);
var Prg, oPrg   :Integer;
    Fsize, cSize:Int64;
    myFile      :TextFile;
    myText, str, str2 :string;
    isHeader: boolean;

    s, LastS :string;
    isStop  :boolean;
    NewStop :TGNSSStopPoint;
    StartTimeSys :string;
    LeapSeconds  :real;

  procedure AddStopPoint;
  var I:Integer;
  begin
     I := Length(Session.Stops);
     SetLength(Session.Stops, I+1);
     Session.Stops[I].SessionID := Session.SessionID;
     Session.Stops[I].Name      := NewStop.Name;
     Session.Stops[I].MaskName  := NewStop.Name;
     Session.Stops[I].AntHgt    := NewStop.AntHgt;
     RinexTimeToUTC(NewStop.StartT, StartTimeSys, LeapSeconds);
     RinexTimeToUTC(NewStop.EndT,   StartTimeSys, LeapSeconds);
     Session.Stops[I].StartT    := NewStop.StartT;
     Session.Stops[I].EndT      := NewStop.EndT;
     Session.StatusQ            := 0;
  end;

begin
   /// Find Stop And Go, Refresh the Last Time, Clarify SatSystems

  try
    AssignFile(myFile, Session.FileName);
    Reset(myFile);

    cSize := 0;
    oPrg := 0;
    Fsize := GetfilesizeEx(Session.FileName);

    if ProgressBar <> nil then
      ProgressBar.Position := 0;

    isHeader := true;
    isStop   := false;
    SetLength(Session.Stops, 0); 
    LastS := '';    StartTimeSys :='';  LeapSeconds :=0;
    while not Eof(myFile) do
    begin
      ReadLn(myFile, myText);

      if ProgressBar <> nil then
      begin
        cSize := cSize + Length(MyText)+2;
        Prg := round(100*cSize/Fsize);
        if (Prg = 100) or (Prg-5 > oPrg) then
        begin
          oPrg := Prg;
          ProgressBar.Position := Prg;
        end;
      end;

      if IsHeader then
      Begin
        if Length(myText) < 61 then
          continue;
        str := Trim(AnsiUpperCase( copy(myText, 61, Length(myText)-60) ));

        if str = 'LEAP SECONDS' then
        begin
          str2 := Trim(copy(myText, 1, 14));
          LeapSeconds := StrToFloat2(str2);
        end else

        if str = 'TIME OF FIRST OBS' then
        begin
          //str2 := Trim(copy(myText, 1, 48));
          //NewSession.StartTime := GetDateTime(Str2, 1);
          str2 := Trim(copy(myText, 49, 10));
          StartTimeSys := str2;
        end else

        if str = 'END OF HEADER' then
        begin
          isHeader := False;
        end;

      End Else
      Begin
        /// ToDo: Analyse Body!!!!!

        if Length(MyText) < 10 then
          continue;

        if ((Session.RinVersion <  3) and (MyText[2] <> ' ') and (MyText[4] = ' ') ) or
           ((Session.RinVersion >= 3) and (MyText[1] =  '>')) then
        //// it's an EPOCH STRING
        begin
             if Session.RinVersion >= 3  then
                s :=copy(MyText, 2, length(MyText)-1)
             else
                s := MyText;
             if s[3] <> ' ' then
                LastS := s;

             /// check if it is new occupation
             s := trim(copy(MyText, 30, 3));

             if s = '2' then
               Session.isKinematic := true;
               
             if s = '3' then
             begin
                isStop := true;
                newStop.Name      := '*';
                newStop.StartT    := GetDateTime(LastS,1);
                NewStop.AntHgt    := Session.AntHgt;
                NewStop.dN        := 0;
                NewStop.dE        := 0;
             end;

             if (isStop) and (s = '2') then
             begin
                isStop := false;
                newStop.EndT := GetDateTime(LastS, 1);
                AddStopPoint;
             end;
        end
        else  //// not an EPOCH STRING
        begin
           if not isStop then
             begin
                continue
             end
             else
             begin
               //// ��� ��� �������
               if POS('MARKER NAME', MyText) > 0 then
                 newStop.Name := trim(copy(MyText, 1, 59))
               else
               if POS('ANTENNA: DELTA H/E/N', MyText) > 0 then
               begin
                  NewStop.AntHgt.Hkind := 1;
                  NewStop.AntHgt.Hant  := StrToFloat2(copy(MyText,1,14));
                  NewStop.AntHgt.Hant_u:=  NewStop.AntHgt.Hant;
                  NewStop.dE := StrToFloat2(copy(MyText,16,14));
                  NewStop.dN := StrToFloat2(copy(MyText,31,14));
               end;
             end;
        end;
      End;

    end;
                            

    Session.EndTime :=  GetDateTime(LastS,1);
    RinexTimeToUTC(Session.EndTime, StartTimeSys, LeapSeconds);
    if isStop then
    begin
      newStop.EndT := Session.EndTime;
      AddStopPoint;
    end;


  except
     MessageDlg(GNSSMessages[1], mtError, [mbOk], 0);
  end;

  if isStaticOnly then
    Session.isKinematic := False;
end;

function CheckAntName(s:string):string;
var I:Integer;
    AN1, AN2, I_AN1, I_AN2 :String;
begin
  result := s;

  AN1 := AnsiLowerCase(getCols(s, 0, 1, ' ', false));
  AN2 := AnsiLowerCase(getCols(s, 1, 1, ' ', false));

  for I := 0 to Length(GNSSAntNames) - 1 do
  begin
    I_AN1 := AnsiLowerCase(getCols(GNSSAntNames[I], 0, 1, ' ', false));
    I_AN2 := AnsiLowerCase(getCols(GNSSAntNames[I], 1, 1, ' ', false));

    if GNSSAntNames[I] = s then
      break;

    if ((AN2 = I_AN2) and (AN1 = I_AN1)) or
       ((AN2 = '') and (Trim(I_AN2) = 'none') and (AN1 = I_AN1)) then
    begin
      result := GNSSAntNames[I];
      break;
    end;

  end;

end;

function OpenRINEX (FileName:string; ProgressBar: TProgressBar
     ):Boolean;  overload;
var
  myFile : TextFile;
  myText, str, str2 : string;

  isHeader :boolean;

  NewSession :TGNSSSession;

  StartTimeSys, EndTimeSys :string;
  LeapSeconds :double;
  I, j :Integer;

const
  AddExt :array[0..5] of char = ('n','g','c','l','j','i');
begin
  Result := false;

  for I := 0 to Length(GNSSSessions) - 1 do
     if GNSSSessions[i].FileName = FileName then
     begin
        MessageDlg(GNSSMessages[0], mtError, [mbOk], 0);
        exit;
     end;

  try
    AssignFile(myFile, FileName);
    Reset(myFile);

    if ProgressBar <> nil then
    begin
        ProgressBar.Position := 0;
    end;

    isHeader := true;
    LeapSeconds := 0;
    StartTimeSys := '';
    EndTimeSys := '';

    NewSession.isVisible  := true;
    NewSession.Comment  := '';
    NewSession.FileName := FileName;
    NewSession.isKinematic := false;  // Todo: Delete and write the check!

    while not Eof(myFile) do
    begin
      ReadLn(myFile, myText);

      if isHeader then
      begin
        if Length(myText) < 61 then
          continue;

        str := Trim(AnsiUpperCase( copy(myText, 61, Length(myText)-60) ));

        if str = 'RINEX VERSION / TYPE' then
        begin
          str2 := Trim(copy(myText, 1, 20));
          NewSession.RinVersion := StrToFloat2(str2);
        end else

        if str = 'MARKER NAME' then
        begin
          str2 := Trim(copy(myText, 1, 60));
          NewSession.Station := str2;
        end else

        if str = 'COMMENT' then
        begin
          str2 := Trim(copy(myText, 1, 60));
          if NewSession.Comment <> '' then
             NewSession.Comment := NewSession.Comment + ' ';
          NewSession.Comment := NewSession.Comment + str2;
        end else

        if str = 'TIME OF FIRST OBS' then
        begin
          str2 := Trim(copy(myText, 1, 48));
          NewSession.StartTime := GetDateTime(Str2, 1);
          str2 := Trim(copy(myText, 49, 10));
          StartTimeSys := str2;
        end else

        if str = 'TIME OF LAST OBS' then
        begin
          str2 := Trim(copy(myText, 1, 48));
          NewSession.EndTime := GetDateTime(Str2, 1);
          str2 := Trim(copy(myText, 49, 10));
          EndTimeSys := str2;
        end else

      // ToDo Systems Definition!
      { if (NewSession.RinVersion < 3) and (str = '# / TYPES OF OBSERV') then
       begin
         str2 := Trim(copy(myText, 8, 52));

       end else

       if (NewSession.RinVersion < 4) and (str = 'SYS / # / OBS TYPES') then
       begin
         str2 := Trim(copy(myText, 1, 14));
         LeapSeconds := StrToFloat2(str2);
       end else  }

        if str = 'LEAP SECONDS' then
        begin
          str2 := Trim(copy(myText, 1, 14));
          LeapSeconds := StrToFloat2(str2);
        end else

        if str = 'ANT # / TYPE' then
        begin
          str2 := Trim(copy(myText, 21, 40));
          NewSession.Antenna.AntName := CheckAntName(str2);
        end else

        if str = 'ANTENNA: DELTA H/E/N' then
        begin
          str2 := Trim(copy(myText, 1, 14));
          NewSession.AntHgt.Hant  := StrToFloat2(str2);
          NewSession.AntHgt.Hant_u:= StrToFloat2(str2);
          NewSession.AntHgt.Hkind := 1;
          str2 := Trim(copy(myText, 16, 14));
          NewSession.Antenna.dN   := StrToFloat2(str2);
          str2 := Trim(copy(myText, 31, 14));
          NewSession.Antenna.dE   := StrToFloat2(str2);
        end else

        if str = 'APPROX POSITION XYZ' then
        begin
          str2 := Trim(copy(myText, 1, 14));
          NewSession.AppliedPos.X := StrToFloat2(str2);
          str2 := Trim(copy(myText, 16, 14));
          NewSession.AppliedPos.Y := StrToFloat2(str2);
          str2 := Trim(copy(myText, 31, 14));
          NewSession.AppliedPos.Z := StrToFloat2(str2);

          NewSession.PositionID := 0;
          SetLength(NewSession.Solutions, 1);
          with NewSession.Solutions[0] do
          begin
             SolutionKind := 0;
             BaseID       := '';
             PointPos     := NewSession.AppliedPos;
          end;

        end else

        if str = 'END OF HEADER' then
        begin
          isHeader := False;
        end;

     end; /// Header


     /// We are reading only the header here!
     if not isHeader then
        break;

   end;

   // CONVERT TIME TO UTC!
   RinexTimeToUTC(NewSession.StartTime, StartTimeSys, LeapSeconds);
   if NewSession.EndTime <> 0 then
     RinexTimeToUTC(NewSession.EndTime, EndTimeSys,   LeapSeconds)
   else
     AnalyseSessionRINEX(NewSession, ProgressBar);

   /// Checking NAV files
   str2 := copy(Filename, 1, Length(FileName)-1);
   for j := 0 to length(AddExt) - 1 do
     if Fileexists(str2 + AddExt[j]) then
       GNSSSessionAddAdditionalFile(NewSession, str2 + AddExt[j]);

   str2 := copy(Filename, 1, Length(FileName)-3) +'nav';
   if Fileexists(str2) then
      GNSSSessionAddAdditionalFile(NewSession, str2);

  // ID
   NewSession.MaskName  :=  ExtractFileName(NewSession.FileName);
   for I := Length(NewSession.MaskName)-1 DownTo 0 do
    if NewSession.MaskName[I] = '.'  then
    begin
      NewSession.MaskName  := Copy(NewSession.MaskName, 1, I-1);
      break;
    end;

   NewSession.SessionID   := NewSession.MaskName + '_'
                            + IntToStr( Trunc(NewSession.StartTime*100) );

   if NewSession.Station = '' then
     NewSession.Station := NewSession.MaskName;

   // Close the file for the last time
   CloseFile(myFile);

   SetLength(GNSSSessions, Length(GNSSSessions)+1);
   GNSSSessions[Length(GNSSSessions)-1] := NewSession;
   DebugMSG('Loaded session: '+ NewSession.MaskName);

   AddOrUpdateGNSSStation(NewSession.SessionID, true);
   AddGNSSVectorsForSession(NewSession.SessionID);

   Result := true;
  except
     MessageDlg(GNSSMessages[1], mtError, [mbOk], 0);
     Result := false;
  end;
end;

function OpenRINEX(FileName:string):Boolean;   overload;
begin
    result := OpenRINEX(FileName, nil);
end;

function GetGNSSSessionNumber(SessionId:String):integer;
var I:Integer;
begin
  result := -1;
  for I := 0 to Length(GNSSSessions) - 1 do
    if GNSSSessions[I].SessionID = SessionID then
    begin
      result := I;
      break;
    end;

  if result = -1 then
     DebugMSG('ERROR! Session not found: '+ BareId(SessionId));
end;

procedure GNSSSessionApplyCoordinates(SessionN:integer; Coords:TXYZ;
    UpdN:integer = 0);

   function IsRepeatedStation(SN:string):boolean;
   var I, j:integer;
   begin
      result := false;
      j := GetGNSSPointNumber(SN);
      if j = -1 then
        DebugMSG('ERROR! Point not found: '+ SN)
      else
      for I := 0 to UpdN - 1 do
        if j = GNSSPointsUpdateStack[I] then
        begin
          DebugMSG('ERROR! Infinity cycle detected with '+ SN);
          result := true;
          break;
        end;

   end;

var I, j, N :Integer;
begin
  // ToDo 1) apply, 2) Change Rovers
  if (abs(GNSSSessions[SessionN].AppliedPos.X - Coords.X) < 0.001) and
     (abs(GNSSSessions[SessionN].AppliedPos.Y - Coords.Y) < 0.001) and
     (abs(GNSSSessions[SessionN].AppliedPos.Z - Coords.Z) < 0.001)
  then
    exit;

  if UpdN >= GNSSMaxUpdateStack-1 then
  begin
     DebugMSG('ERROR: Station/Sessions updating stack overflow!');
     MessageDLG(GNSSMessages[2], mtError, [mbOk], 0);
     exit;
  end;
  DebugMSG('Applying new coordinates for Session: ' +
           GNSSSessions[SessionN].MaskName+' - Stack level: '+IntToStr(UpdN));

  // Apply to the Session
  GNSSSessions[SessionN].AppliedPos.X := Coords.X;
  GNSSSessions[SessionN].AppliedPos.Y := Coords.Y;
  GNSSSessions[SessionN].AppliedPos.Z := Coords.Z;

  // Apply to the rovers of the session
  for I := 0 to Length(GNSSVectors) - 1 do
   if (GNSSVectors[I].BaseID = GNSSSessions[SessionN].SessionID) and
      // the Vector's Base is the changed sessionn
      (GNSSVectors[I].StatusQ > 0) and (GNSSVectors[I].StatusQ <> 8) then
      // the Vector is not Disabled, not Errornous
   begin
     /// find solution by vector, shift it
     N := GetGNSSSessionNumber(GNSSVectors[I].RoverID);


     if N <> -1 then
     begin

       // Test if I modified this station before within the current cycle
       if IsRepeatedStation(GNSSSessions[N].Station) then
       begin
         MessageDLG(GNSSMessages[3] + BareId(GNSSVectors[I].BaseID) +
            ' -> ' + BareId(GNSSVectors[I].RoverID),
            mtError, [mbOk], 0);
         DisableGNSSVector(I);
         continue;
       end;

       // Modyfy the connected solutions
       j := GetGNSSSolutionForVector(N, GNSSSessions[SessionN].SessionID);
       if j > -1 then
       begin
            DebugMSG('!!! Correcting coordinates for Session: ' +
               GNSSSessions[N].MaskName + ' using Vector from' +
               GNSSSessions[SessionN].MaskName);

            GNSSSessions[N].Solutions[j].PointPos.X := Coords.X +
                                                       GNSSVectors[I].dX;
            GNSSSessions[N].Solutions[j].PointPos.Y := Coords.Y +
                                                       GNSSVectors[I].dY;
            GNSSSessions[N].Solutions[j].PointPos.Z := Coords.Z +
                                                       GNSSVectors[I].dZ;
         end;

       /// Refresh the Point connected to the solution
       j := GetGNSSPointNumber(GNSSSessions[N].Station);
       if j > -1 then
         RefreshGNSSPoint(j, UpdN)
       else DebugMSG('Point not found: '+ GNSSSessions[N].Station);
     end;
   end;

end;


procedure CheckGNSSSessionStatus(SessionN:integer);
var I, St, OldSt:Integer;
begin
  St := 0;
  OldSt := GNSSSessions[SessionN].StatusQ;

  for I := 0 to Length(GNSSSessions[SessionN].Solutions) - 1 do
  with GNSSSessions[SessionN].Solutions[I] do
  begin
    if (St = 0) and (SolutionQ > 0) then
      St := SolutionQ
    else
    if (St > 2) and (SolutionQ = 6) then
      St := SolutionQ
    else
    if (St < 5) and (SolutionQ < St) then
      St := SolutionQ
    else
    if (St = 6) and (SolutionQ > 0) and (SolutionQ < 3) then
      St := SolutionQ
    else
    if (St = 5) and (SolutionQ <> 5) and (SolutionQ > 0) then
      St := SolutionQ
  end;

  GNSSSessions[SessionN].StatusQ := St;
  if OldSt <> St then
  begin
   DebugMSG('Assigning status for Session : ' +
           GNSSSessions[SessionN].MaskName +' to '+StatusNames[St]);

   St := GetGNSSPointNumber(GNSSSessions[SessionN].Station);
   if St > -1 then
     RefreshGNSSPoint(St)
   else DebugMSG('Point not found: '+ GNSSSessions[SessionN].Station);
  end;
end;

//////////// SOLUTIONS ---------------------------------------------------------

function GetSolutionSubStatus(SessionN, SolutionN:integer):byte;
var I, PointN :Integer;
begin
  result := 0;
  PointN := GetGNSSPointNumber(GNSSSessions[SessionN].Station);
  if PointN = -1 then
  begin
    DebugMSG('Point not found: '+ GNSSSessions[SessionN].Station);
    exit;
  end;

  if GNSSPoints[PointN].CoordSource = 3 then
  begin
     if (GNSSPoints[PointN].SolutionId.SessionId =
         GNSSSessions[SessionN].SessionID) and
        (GNSSPoints[PointN].SolutionId.SolutionN = SolutionN)
       then
         result := 1;
  end
  else
  if ( (GNSSPoints[PointN].CoordSource = 2) and
       (GNSSSessions[SessionN].Solutions[SolutionN].SolutionKind = 2) )
     or
     ( (GNSSPoints[PointN].CoordSource = 1) and
       ((GNSSSessions[SessionN].Solutions[SolutionN].SolutionKind = 1)
       or (GNSSSessions[SessionN].Solutions[SolutionN].SolutionKind = 3)) )
  then
    result := 2;

end;


function GetGNSSSolutionForVector(VectorN:integer):TSolutionId;   overload;
var j, SessionN:Integer;
begin
 result.SessionId := '';
 result.SolutionN := -1;

 SessionN := GetGNSSSessionNumber(GNSSVectors[VectorN].RoverID);
 if SessionN > -1 then
   for j := 0 to Length(GNSSSessions[SessionN].Solutions) - 1 do
      if GNSSSessions[SessionN].Solutions[j].SolutionKind = 2 then
      if GNSSSessions[SessionN].Solutions[j].BaseID =
            GNSSVectors[VectorN].BaseID then
      begin
        result.SessionId := GNSSSessions[SessionN].SessionID;
        result.SolutionN := j;
        Break;
      end;

end;

function GetGNSSSolutionForVector(SessionN:integer; BaseId:string):integer;
  overload;
var j:Integer;
begin
 result := -1;
 if SessionN = -1 then
 begin
   DebugMSG('Error! No station for searching a Solution!');
   exit;
 end;

 for j := 0 to Length(GNSSSessions[SessionN].Solutions) - 1 do
   if GNSSSessions[SessionN].Solutions[j].SolutionKind = 2 then
     if GNSSSessions[SessionN].Solutions[j].BaseID = BaseId then
     begin
       result := j;
       break;
     end;

end;

procedure RefreshGNSSSolution(SessionN, SolutionN:integer; ChangeVectors:Boolean);
var I, j :Integer;
begin
  With GNSSSessions[SessionN].Solutions[SolutionN] Do
  Begin

    // 1) Check Vectors - > Change status
    if (SolutionKind = 2) and (ChangeVectors) then
    for I := 0 to Length(GNSSVectors) - 1 do
      if (GNSSVectors[I].BaseID = BaseID) and
         (GNSSVectors[I].RoverID = GNSSSessions[SessionN].SessionID)
      then
      begin
        GNSSVectors[I].StatusQ := SolutionQ;
        j := GetGNSSSessionNumber(BaseId);
        if j = -1 then
          continue;
        // ToDo - devide processed values and adjusted ones
        // not assign if it is not the processing result!!!
        GNSSVectors[I].dX := PointPos.X - GNSSSessions[j].AppliedPos.X;
        GNSSVectors[I].dY := PointPos.Y - GNSSSessions[j].AppliedPos.Y;
        GNSSVectors[I].dZ := PointPos.Z - GNSSSessions[j].AppliedPos.Z;
        GNSSVectors[I].StDevs := StDevs;

        DebugMSG('Applying Solution to the Vector: ' + BareId(GNSSVectors[I].BaseID) +
            ' -> ' + BareId(GNSSVectors[I].RoverID));
      end;

    // 2) Check Rover Status
      CheckGNSSSessionStatus(SessionN);

    // 3) Check Points - > Adjustment or Accept the best solution  
    j := GetGNSSPointNumber(GNSSSessions[SessionN].Station);
    if j > -1 then
      RefreshGNSSPoint(j)
    else
      DebugMSG('Point not found: '+ GNSSSessions[SessionN].Station);
  End;
end;

procedure DeleteGNSSSolution(SessionN, SolutionN:integer);
var I, j, SolKind :integer;
begin
  if (SessionN = -1) or (SolutionN = -1) then
    exit;

  if SolutionN >= Length(GNSSSessions[SessionN].Solutions)  then
    exit;

  SolKind := GNSSSessions[SessionN].Solutions[SolutionN].SolutionKind;
  if SolKind = 0 then
    exit;

  DebugMSG('Deleting Solution #' + IntToStr(SolutionN) +
           ' of Session: ' + GNSSSessions[SessionN].MaskName);

  ///  1 Deactivate Vector!
  I := GetGNSSVector(GNSSSessions[SessionN].SessionID,
       GNSSSessions[SessionN].Solutions[SolutionN].BaseID);

  if I <> -1 then
    if GNSSVectors[I].StatusQ > 0 then
     GNSSVectors[I].StatusQ := 0;

  /// 2. Delete Solution
  for I := SolutionN to Length(GNSSSessions[SessionN].Solutions) - 2 do
    GNSSSessions[SessionN].Solutions[I] := GNSSSessions[SessionN].Solutions[I+1];

  I := Length(GNSSSessions[SessionN].Solutions);
  SetLength(GNSSSessions[SessionN].Solutions, I-1);

  /// 3. SessionStatus
  CheckGNSSSessionStatus(SessionN);


  /// 4. GNSS Point Status
  j := GetGNSSPointNumber(GNSSSessions[SessionN].Station);
  if j > -1 then
  begin
    if ( (GNSSPoints[j].CoordSource = 3) and
         (GNSSPoints[j].SolutionId.SessionId = GNSSSessions[SessionN].SessionID) and
         (GNSSPoints[j].SolutionId.SolutionN = SolutionN) ) or
       ( (SolKind = 1) and
         (GNSSPoints[j].CoordSource = 1) ) or
       ( (SolKind = 2) and
         (GNSSPoints[j].CoordSource = 2) )
    then
      RefreshGNSSPoint(j);
  end
  else DebugMSG('Point not found: '+ GNSSSessions[SessionN].Station); 
end;

////////////////// ADJUSTMENT --------------------------------------------------




///////////////// POINTS -------------------------------------------------------

procedure DeleteGNSSPoint(N:Integer);
var I:Integer;
begin
  DebugMSG('Deleting Point: '+ GNSSPoints[N].PointName);

  for I := N to Length(GNSSPoints)-2 do
     GNSSPoints[I] := GNSSPoints[I+1];

  I := Length(GNSSPoints);
  SetLength(GNSSPoints, I-1);
end;

procedure ClearEmptyGNSSPoints;
var I:Integer;
begin
  for I := Length(GNSSPoints) - 1 downto 0 do
    if Length(GNSSPoints[I].Sessions) = 0 then
       DeleteGNSSPoint(I);
end;

function GetGNSSPointNumber(PointName: string):integer;
var I:Integer;
begin
  result := -1;
  if PointName = '' then
    exit;
  for I := 0 to Length(GNSSPoints) - 1 do
    if GNSSPoints[I].PointName = PointName then
    begin
      result := I;
      break;
    end;
end;

procedure DeleteSessionFromPoint(PointN :integer; SessionId:string);
var I, N :Integer;
begin
   N := -1;
   for I := 0 to Length(GNSSPoints[PointN].Sessions) - 1 do
     if GNSSPoints[PointN].Sessions[I] = SessionId then
     begin
       N := I;
     end;

   if N = -1 then
     exit;

   DebugMSG('Deleting Session: '+ SessionId +
            ' from Point: '+ GNSSPoints[PointN].PointName);

   for I := N to Length(GNSSPoints[PointN].Sessions) - 2 do
      GNSSPoints[PointN].Sessions[I] := GNSSPoints[PointN].Sessions[I+1];

   SetLength(GNSSPoints[PointN].Sessions,Length(GNSSPoints[PointN].Sessions)-1);

end;

procedure AddSessionToPoint(PointN :integer; SessionId :string);
var I, SessionN, N :Integer;
    T, newT :TDateTime;
begin

   //// Find Pos in array by StartTime
   I := GetGNSSSessionNumber(SessionId);
   if I = -1 then
     exit;
   newT := GNSSSessions[I].StartTime;

   SessionN:= I;

   N := 0;
   for I := 0 to Length(GNSSPoints[PointN].Sessions) - 1 do
   begin
     T := GNSSSessions[I].StartTime;
     if newT > T  then
       N := I+1;
   end;

   I := Length(GNSSPoints[PointN].Sessions);
   SetLength(GNSSPoints[PointN].Sessions, I + 1);

   for I := Length(GNSSPoints[PointN].Sessions) - 1 downto  N+1 do
      GNSSPoints[PointN].Sessions[I] := GNSSPoints[PointN].Sessions[I-1];

   GNSSPoints[PointN].Sessions[N] := SessionId;

   DebugMSG('Adding Session: '+ SessionId +
            ' to Point: '+ GNSSPoints[PointN].PointName);

   if GNSSPoints[PointN].CoordSource = 4 then
   begin
     GNSSSessions[SessionN].AppliedPos.X := GNSSPoints[PointN].Position.X;
     GNSSSessions[SessionN].AppliedPos.Y := GNSSPoints[PointN].Position.Y;
     GNSSSessions[SessionN].AppliedPos.Z := GNSSPoints[PointN].Position.Z;
   end;

   RefreshGNSSPoint(PointN);
end;

procedure AddGNSSStationOnly(SessionN:integer); overload
var I, j :Integer;
begin
    DebugMSG('Added new Point: ' +  GNSSSessions[SessionN].Station +
             ' for Session: ' + GNSSSessions[SessionN].MaskName);

    I := Length(GNSSPoints);
    SetLength(GNSSPoints, I + 1);
    GNSSPoints[I].PointName :=  GNSSSessions[SessionN].Station;
    GNSSPoints[I].Active := true;

    GNSSPoints[I].isBase := false;
    GNSSPoints[I].CoordSource := 0;
    GNSSPoints[I].Status := 0;
    GNSSPoints[I].Position := GNSSSessions[SessionN].AppliedPos;
    GNSSPoints[I].SolutionId.SessionId := '';
    GNSSPoints[I].SolutionId.SolutionN := -1;

    for j := 0 to length(GNSSPoints[I].HasErrors) - 1 do
      GNSSPoints[I].HasErrors[j] := false;
    for j := 0 to length(GNSSPoints[I].Quality) - 1 do
      GNSSPoints[I].Quality[j] := 0;

    AddSessionToPoint(I, GNSSSessions[SessionN].SessionID);
end;

procedure CheckGNSSPoints;

  procedure AddKinematicbyMaskName(PointN, PointSessionN, SessionN:Integer);
  var I:Integer; s:string;
  begin
    if GetGNSSPointNumber(GNSSSessions[SessionN].MaskName) > -1 then
    begin
       I := 1;

       repeat
         inc(I);
         s := GNSSSessions[SessionN].MaskName + '(' + IntToStr(I) + ')'
       until GetGNSSPointNumber(s) = -1;
            
       GNSSSessions[SessionN].Station := s;
    end
    else
       GNSSSessions[SessionN].Station := GNSSSessions[SessionN].MaskName;
               
    AddGNSSStationOnly(SessionN);
    DeleteSessionFromPoint(PointN, GNSSPoints[PointN].Sessions[PointSessionN]);
  end;

var I, j, N :Integer;
begin
  ClearEmptyGNSSPoints;

  DebugMSG('Checking Points... ');

  for I := 0 to Length(GNSSPoints) - 1 do
  begin

    /// 1) delete errornous sessions
    For j := Length(GNSSPoints[I].Sessions) - 1 DownTo 0 Do
       if GetGNSSSessionNumber(GNSSPoints[I].Sessions[j]) = -1 then
         DeleteSessionFromPoint(I, GNSSPoints[I].Sessions[j]);

    /// 2) Check if Kinematic sessions need to be splitted
    if Length(GNSSPoints[I].Sessions) > 1 then
    begin
      j := 1;
      repeat
        N := GetGNSSSessionNumber(GNSSPoints[I].Sessions[j]);
        if GNSSSessions[N].isKinematic then
           AddKinematicbyMaskName(I, j, N)
        else inc(j);

      until j > Length(GNSSPoints[I].Sessions)-1;

    end;

    /// Check if the 1s is kinematic and the others are staic (EDGE CASE)
    if Length(GNSSPoints[I].Sessions) > 1 then
    begin
      N := GetGNSSSessionNumber(GNSSPoints[I].Sessions[0]);
      if GNSSSessions[N].isKinematic then
         AddKinematicbyMaskName(I, 0, N);
    end;

  end;

  ClearEmptyGNSSPoints;
  DebugMSG('Checking Points is DONE! ');
end;

procedure AddOrUpdateGNSSStation(SessionN:integer; isNew:boolean); overload
var I, j, N :Integer;
    NeedNew: Boolean;
begin
  // Test if not already Ok
  N := GetGNSSPointNumber(GNSSSessions[SessionN].Station);
  if N <> -1 then
  for I := 0 to Length(GNSSPoints[N].Sessions) - 1 do
    if GNSSPoints[N].Sessions[I] = GNSSSessions[SessionN].SessionID then
      exit;  /// Already ok!

  NeedNew := true;
  // If not isNew - delete the Session from the other Station.
  //       OR JUST RENAME THE STATION (IF THE POINT HAD THIS SESSION ONLY)
  for I := 0 to Length(GNSSPoints) - 1 do
    for j := 0 to Length(GNSSPoints[I].Sessions) - 1 do
      if GNSSPoints[I].Sessions[j] = GNSSSessions[SessionN].SessionID then
        if (Length(GNSSPoints[I].Sessions) = 1) and (N = -1) then
        /// If it is the only session and the station with new name doesn't already exist
        begin
          NeedNew := false;
          DebugMSG('Renaming the Point: '+GNSSPoints[I].PointName+
                   ' to: ' + GNSSSessions[SessionN].Station);
          GNSSPoints[I].PointName := GNSSSessions[SessionN].Station;
          break;
        end
        else
        begin
          NeedNew := true;
          DeleteSessionFromPoint(I, GNSSSessions[SessionN].SessionID);
          break;
        end;

  // If found the point - update (if the point hasn't the session - add it!)
  if NeedNew then
  for I := 0 to Length(GNSSPoints) - 1 do
    if GNSSPoints[I].PointName = GNSSSessions[SessionN].Station then
    begin
       NeedNew := false;
       AddSessionToPoint(I, GNSSSessions[SessionN].SessionID);
    end;

  // if there is no point with the name - create a new one
  if NeedNew then
  begin
    AddGNSSStationOnly(SessionN);
  End;

  CheckGNSSPoints;
end;

procedure AddOrUpdateGNSSStation(SessionId:string; isNew:boolean); overload
begin
  AddOrUpdateGNSSStation(GetGNSSSessionNumber(SessionId), isNew);
end;

function GetAvgPos(Sol :Array of TGNSSSolution; SolSource:integer;
    FilterSigma, Weighted:Boolean; var Q:TStDevs; var StatQ:integer;
    HasPPP:Boolean): TXYZ;
var I, j, Num :Integer;
    P :Array of Double;
    NewSol  :Array of TGNSSSolution;
begin

  Num := 0; StatQ := 0;
  result.X := 0;
  result.Y := 0;
  result.Z := 0;
  for j := 1 to 6 do Q[j] := 0;

  /// Simple Average
  if not Weighted then
  Begin
    for I := 0 to Length(Sol) - 1 do
    begin
      if (SolSource = 1) and (HasPPP) then          /// PPP better than Single
        if Sol[I].SolutionQ <> 6 then continue;

      inc(Num);
      result.X := result.X + Sol[I].PointPos.X;
      result.Y := result.Y + Sol[I].PointPos.Y;
      result.Z := result.Z + Sol[I].PointPos.Z;
      for j := 1 to 6 do
        Q[j] := Q[j] + Sol[I].StDevs[j];
      StatQ := StatQ + Sol[I].SolutionQ;
    end;

    if Num = 0 then
    begin
      DebugMSG('ERROR! No data for average solution!');
      exit;
    end;

    result.X := result.X / Num;
    result.Y := result.Y / Num;
    result.Z := result.Z / Num;
    StatQ := round(StatQ / Num);
    for j := 1 to 6 do
      Q[j] := Q[j] / Num;
  End;

end;


procedure SetGNSSPointUserCoords(PointN: integer; X, Y, Z :Double);
var I, N :Integer; OldXYZ:TXYZ;
begin
  OldXYZ.X := GNSSPoints[PointN].Position.X;
  OldXYZ.Y := GNSSPoints[PointN].Position.Y;
  OldXYZ.Z := GNSSPoints[PointN].Position.Z;

  GNSSPoints[PointN].CoordSource := 4;
  GNSSPoints[PointN].Position.X := X;
  GNSSPoints[PointN].Position.Y := Y;
  GNSSPoints[PointN].Position.Z := Z;
  GNSSPoints[PointN].Status := 13;

  if  (OldXYZ.X <> GNSSPoints[PointN].Position.X) or
      (OldXYZ.Y <> GNSSPoints[PointN].Position.Y) or
      (OldXYZ.Z <> GNSSPoints[PointN].Position.Z) then
  for I := 0 to Length(GNSSPoints[PointN].Sessions) - 1 do
  begin
     N := GetGNSSSessionNumber(GNSSPoints[PointN].Sessions[I]);
     if N > -1 then
       GNSSSessionApplyCoordinates(N, GNSSPoints[PointN].Position)
     else
       DebugMSG('ERROR! Session not found: '+ BareId(GNSSPoints[PointN].Sessions[I]));
  end;
end;

procedure SetGNSSPointSource(PointN, SolSource, SessionNumber,
        SolutionNumber:integer; UpdN:integer = 0);

var I, j, N: Integer;
    Sol :Array of TGNSSSolution;
    PPPCount :integer;
    OldXYZ :TXYZ;
    lastN, lastj, Stat :integer;
begin
  DebugMSG('Setting Coordinates for Point: '+ GNSSPoints[PointN].PointName +
           ' ' +SolSourcesNames[SolSource]);

  PPPCount := 0;
  Stat := 0;
  if SolSource = 4 then
    Stat := 13;

  OldXYZ.X := GNSSPoints[PointN].Position.X;
  OldXYZ.Y := GNSSPoints[PointN].Position.Y;
  OldXYZ.Z := GNSSPoints[PointN].Position.Z;

  /// Collect the solutions
  if SolSource < 3 then
  for I := 0 to Length(GNSSPoints[PointN].Sessions) - 1 do
  begin
    N := GetGNSSSessionNumber(GNSSPoints[PointN].Sessions[I]);
    if N > -1 then
    with GNSSSessions[N] do
    for j := 0 to Length(Solutions) - 1 do
    begin

       if ( (SolSource = 0) and (Solutions[j].SolutionKind = 0) ) or
          ( (SolSource = 1) and ( (Solutions[j].SolutionKind = 1)
            or (Solutions[j].SolutionKind = 3) ) )                  or
          ( (SolSource = 2) and (Solutions[j].SolutionKind = 2) )
       then
       begin
         SetLength(Sol, Length(Sol)+1);
         Sol[Length(Sol)-1] := Solutions[j];

         LastN := N;
         Lastj := j;

         //////////////////// ------------------- PPP
         if Solutions[j].SolutionKind = 3 then
         begin
           inc(PPPCount);
           if PPPCount = 1 then
           begin
              SessionNumber  := LastN;
              SolutionNumber := Lastj;
           end;
         end;
         //////////////////// --------------------
       end;

    end;
  end;

  if (SolSource = 1) and (PPPCount = 1) then
  begin
     LastN := SessionNumber;
     Lastj := SolutionNumber;
     SolSource := 3;
  end;

  /// Check the Solutions count        // <> 4
  if (Length(Sol) = 0) and (SolSource < 3) then
  begin                /// Nothing
    GNSSPoints[PointN].Position.X := 0;
    GNSSPoints[PointN].Position.Y := 0;
    GNSSPoints[PointN].Position.Z := 0;
    GNSSPoints[PointN].Status := 8;
    Stat := 8;
  end
  else                 /// Single Solution
  if (Length(Sol) = 1) and (Sol[0].SolutionKind > 0) then
  begin
     SolSource := 3;
     SessionNumber  := LastN;
     SolutionNumber := Lastj;
  end
  else
  case SolSource of    /// Average
    0: GNSSPoints[PointN].Position := GetAvgPos(Sol, SolSource, false,
        false, GNSSPoints[PointN].Quality, Stat, PPPCount > 0);
    1: GNSSPoints[PointN].Position := GetAvgPos(Sol, SolSource, false,
        false, GNSSPoints[PointN].Quality, Stat, PPPCount > 0);
    2: GNSSPoints[PointN].Position := GetAvgPos(Sol, SolSource, false,
        false, GNSSPoints[PointN].Quality, Stat, PPPCount > 0);
  end;
  GNSSPoints[PointN].Status := Stat;

  /// Single Solution
  GNSSPoints[PointN].CoordSource := SolSource;
  if SolSource = 3 then
  with GNSSPoints[PointN].SolutionId do
  begin
    SessionId := GNSSSessions[SessionNumber].SessionID;
    SolutionN := SolutionNumber;

    GNSSPoints[PointN].Position :=
      GNSSSessions[SessionNumber].Solutions[SolutionN].PointPos;
    GNSSPoints[PointN].Status :=
      GNSSSessions[SessionNumber].Solutions[SolutionN].SolutionQ;
  end;

  if (SolSource <> 3) then
    DebugMSG('Assigned: ' + SolSourcesNames[SolSource])
  else
    DebugMSG('Assigned: ' + SolSourcesNames[SolSource]+' #' +
             IntToStr(SolutionNumber)+
             ' of Session: ' + BareId(GNSSSessions[SessionNumber].SessionID) );

  //// Apply the coordinates to children Sessions

  GNSSPointsUpdateStack[UpdN] := PointN;
  inc(UpdN);

  if ( abs(OldXYZ.X - GNSSPoints[PointN].Position.X) > 0.001) or
     ( abs(OldXYZ.Y - GNSSPoints[PointN].Position.Y) > 0.001) or
     ( abs(OldXYZ.Z - GNSSPoints[PointN].Position.Z) > 0.001) then
  for I := 0 to Length(GNSSPoints[PointN].Sessions) - 1 do
  begin
     N := GetGNSSSessionNumber(GNSSPoints[PointN].Sessions[I]);
     if N > -1 then
       GNSSSessionApplyCoordinates(N, GNSSPoints[PointN].Position, UpdN)
     else
       DebugMSG('ERROR! Session not found: '+
          BareId(GNSSPoints[PointN].Sessions[I]));
  end;

  if (SolSource <> 3) and (Length(Sol) <> 0) then
    case SolSource of
       0: GNSSPoints[PointN].Status := 0;
       1: if PPPCount > 0 then
            GNSSPoints[PointN].Status := 12
          else GNSSPoints[PointN].Status := 9;
       2: GNSSPoints[PointN].Status := 10; /// ToDo: if Big Error: 11!!!!
       4: GNSSPoints[PointN].Status := 13;
    end;
                       
  /// ToDo: Compare with solutions. Find Big errors!
  GNSSPoints[PointN].HasErrors[0] := false;
end;

procedure RefreshGNSSPoint(PointN: integer; UpdN:integer = 0);
var I, j, N :integer;
    Stat    :integer;
begin
  if GNSSPoints[PointN].CoordSource = 4 then
    exit;

  DebugMSG('Refreshing Point: ' + GNSSPoints[PointN].PointName);
  
  Stat := 0;
  for I := 0 to Length(GNSSPoints[PointN].Sessions) - 1 do
  begin
    N := GetGNSSSessionNumber(GNSSPoints[PointN].Sessions[I]);
    if N > -1 then
    with GNSSSessions[N] do
    if StatusQ > 0 then
    begin
      if Stat = 0 then
        Stat := StatusQ
      else
      if ((Stat = 5) and (StatusQ <> 5)) or (StatusQ < Stat) then
        Stat := StatusQ
    end;
  end;

  case Stat of
     0       :Stat := 0;  /// Avg from RINEX
     1, 2, 4 :Stat := 2;  /// One or AVG from Vectors
     6, 5    :Stat := 1;  /// One or Avg from Single/PPP
  end;

  SetGNSSPointSource(PointN, Stat, -1, -1, UpdN);

  /// ToDo: Refresh Vectors if Point is Base
end;

///////////////// VECTORS ------------------------------------------------------
function NeedRewerse(BaseN, RoverN:integer):boolean;
var N1, N2 :integer;
begin
  result := false;

  N2 := GetGNSSPointNumber(GNSSSessions[RoverN].Station);
  N1 := GetGNSSPointNumber(GNSSSessions[BaseN].Station);
  if (N1 > - 1) and (N2 > -1) then
  begin
    result :=  ( (GNSSPoints[N2].IsBase) and not (GNSSPoints[N1].IsBase) ) or
               ( (GNSSPoints[N2].IsBase) and (GNSSPoints[N1].IsBase) and
                 (GNSSPoints[N2].CoordSource =  4) and
                 (GNSSPoints[N1].CoordSource <> 4) );

//    if not result then
//      result := (GNSSPoints[N1].Status = 0) or (GNSSPoints[N1].Status = 8) and  // Base has no solution
//                (GNSSPoints[N2].Status > 0) and (GNSSPoints[N2].Status < 5); // Rover already Has solution
  end
   else
       begin
         if N1 = -1 then DebugMSG('ERROR! Point not found: '+ GNSSSessions[RoverN].Station);
         if N2 = -1 then DebugMSG('ERROR! Point not found: '+ GNSSSessions[BaseN].Station);
       end;
end;

procedure AddGNSSVectorsForSession(SessionN:integer);  overload
Var I, j, N1, N2 :Integer;
    Emin, Smax   :TDateTime;
begin

  for I := 0 to Length(GNSSSessions) - 1 do
  begin
     if I = SessionN then
       continue;

     if GNSSSessions[I].isKinematic then
       continue;

     if GetGNSSVector(GNSSSessions[I].SessionID,
                GNSSSessions[SessionN].SessionID) > -1 then
       continue;

     if GetGNSSVector(GNSSSessions[SessionN].SessionID,
                      GNSSSessions[I].SessionID) > -1 then
       continue;

     Emin := GNSSSessions[SessionN].EndTime;
     Smax := GNSSSessions[SessionN].StartTime;
     if GNSSSessions[I].StartTime > Smax then
       Smax := GNSSSessions[I].StartTime;
     if GNSSSessions[I].EndTime < Emin then
       Emin := GNSSSessions[I].EndTime;

     if Smax < Emin then
     begin
       for j := 0 to length(GNSSVectors) - 1 do
       if ( (GNSSSessions[SessionN].SessionID = GNSSVectors[j].BaseID) and
            (GNSSSessions[I].SessionID = GNSSVectors[j].RoverID) ) or
          ( (GNSSSessions[SessionN].SessionID = GNSSVectors[j].RoverID) and
            (GNSSSessions[I].SessionID = GNSSVectors[j].BaseID) )
        then
          continue;

       j := length(GNSSVectors);
       SetLength(GNSSVectors, j +1);
       GNSSVectors[j].StatusQ := 0;
       GNSSVectors[j].RoverID := GNSSSessions[SessionN].SessionID;
       GNSSVectors[j].BaseID := GNSSSessions[I].SessionID;

       GNSSVectors[j].dX := 0;
       GNSSVectors[j].dY := 0;
       GNSSVectors[j].dZ := 0;

       GNSSVectors[j].StDevs[1] := 0;     GNSSVectors[j].StDevs[4] := 0;
       GNSSVectors[j].StDevs[2] := 0;     GNSSVectors[j].StDevs[5] := 0;
       GNSSVectors[j].StDevs[3] := 0;     GNSSVectors[j].StDevs[6] := 0;

       if NeedRewerse(I, SessionN) then
       Begin
         GNSSVectors[j].RoverID := GNSSSessions[I].SessionID;
         GNSSVectors[j].BaseID  := GNSSSessions[SessionN].SessionID;
         DebugMSG('Rewersing...');
       End;

       DebugMSG('Added Vector: '+ BareId(GNSSVectors[j].BaseID) +' -> '+
            BareId(GNSSVectors[j].RoverID))

     end;

  end;
end;

procedure AddGNSSVectorsForSession(SessionId:string);  overload
Var I:Integer;
begin
   I := GetGNSSSessionNumber(SessionId);
   if I <> -1 then
      AddGNSSVectorsForSession(I);
end;

procedure DelGNSSVector(VectorN:Integer);  overload
var I, SessionN :Integer;
begin

  /// 1. Delete Solution for the Rover of the Vector
  SessionN := GetGNSSSessionNumber(GNSSVectors[VectorN].RoverID);
  if SessionN > -1 then
  for I := 0 to Length(GNSSSessions[SessionN].Solutions) - 1 do
  begin
     if GNSSSessions[SessionN].Solutions[I].BaseID =
        GNSSVectors[VectorN].BaseID then
     DeleteGNSSSolution(SessionN, I);
  end;

  DebugMSG('Deleting Vector: '+ BareId(GNSSVectors[VectorN].BaseID) +' -> '+
            BareId(GNSSVectors[VectorN].RoverID));

  /// 2. Delete Vector
  for I := VectorN to Length(GNSSVectors) - 2 do
    GNSSVectors[I] := GNSSVectors[I+1];

  I := Length(GNSSVectors);
  SetLength(GNSSVectors, I-1);
end;

procedure DelGNSSVectorsForSession(SessionId:string);  overload
var I: Integer;
begin
  for I := Length(GNSSVectors) - 1 downto 0 do
     if (GNSSVectors[I].BaseID  = SessionId) or
        (GNSSVectors[I].RoverID = SessionId) then
      DelGNSSVector(I);
end;

procedure DelGNSSVectorsForSession(SessionN:integer);  overload
var
    SessionId :string;
begin
   SessionId := GNSSSessions[SessionN].SessionID;
   DelGNSSVectorsForSession(SessionId);
end;

function GetGNSSVector(RoverId, BaseId:String):integer;
Var I:Integer;
begin
   result := -1;
   for I := 0 to Length(GNSSVectors) -1 do
     if GNSSVectors[I].RoverID = RoverId then
     if GNSSVectors[I].BaseID  = BaseId  then
     begin
       result := I;
       break;
     end;
end;

function GetGNSSVectorPoint(VectN: Integer; isBase: boolean):String;
var j :Integer;
begin
  result := '';
  case isBase of
     true:  j := GetGNSSSessionNumber(GNSSVectors[VectN].BaseID);
     false: j := GetGNSSSessionNumber(GNSSVectors[VectN].RoverID);
  end;

  if j >= 0 then
  result := GNSSSessions[j].Station;
end;

procedure AddSolutionFromVector(VectorN:integer);
var I, j, SessN, SessBaseN :Integer;
begin
   if GNSSVectors[VectorN].StatusQ <= 0 then
     exit;

   if GetGNSSSolutionForVector(VectorN).SolutionN > -1 then
     exit;
     
   SessN := GetGNSSSessionNumber(GNSSVectors[VectorN].RoverID);
   SessBaseN  := GetGNSSSessionNumber(GNSSVectors[VectorN].BaseID);
   if (SessN <> -1) and (SessBaseN <> -1) then
   begin
     I := Length(GNSSSessions[SessN].Solutions);
     SetLength(GNSSSessions[SessN].Solutions, I+1);
     with GNSSSessions[SessN].Solutions[I] do
     begin
       SolutionKind := 2;
       BaseID := GNSSSessions[SessBaseN].SessionID;
       PointPos.X := GNSSSessions[SessBaseN].AppliedPos.X + GNSSVectors[VectorN].dX;
       PointPos.Y := GNSSSessions[SessBaseN].AppliedPos.Y + GNSSVectors[VectorN].dY;
       PointPos.Z := GNSSSessions[SessBaseN].AppliedPos.Z + GNSSVectors[VectorN].dZ;
       SolutionQ  := GNSSVectors[VectorN].StatusQ;

       for j := 1 to 6 do
         StDevs[j] :=  GNSSVectors[VectorN].StDevs[j];

       DebugMSG('Accepting Solution #'+IntToStr(I)+' of Session : ' +
                GNSSSessions[SessN].MaskName + ' by Vector: '+
                BareId(GNSSVectors[VectorN].RoverID) +' -> '+
                BareId(GNSSVectors[VectorN].BaseID));
     end;
   end;

   RefreshGNSSSolution(SessN, I, false);

end;

procedure DelSolutionFromVector(VectorN:integer; Inverted:boolean);
var  I, SessN : integer;
     Id :string;
begin

   case Inverted of
      false:
      begin
        SessN := GetGNSSSessionNumber(GNSSVectors[VectorN].RoverID);
        Id := GNSSVectors[VectorN].BaseID;
      end;
      true: begin
        SessN := GetGNSSSessionNumber(GNSSVectors[VectorN].BaseID);
        Id := GNSSVectors[VectorN].RoverID;
      end;
   end;

   if SessN <> -1 then
     for I := Length(GNSSSessions[SessN].Solutions) - 1 downto 0 do
       if (GNSSSessions[SessN].Solutions[I].SolutionKind = 2)
          and (GNSSSessions[SessN].Solutions[I].BaseID = Id) then
         DeleteGNSSSolution(SessN, I);
end;

function GetGNSSVectorGroupStatus(VectN: Array of Integer):integer;
var i, j, bestQ, worstQ:integer;
    isHomo :boolean;
begin
  result := -1;

  if Length(VectN) < 1 then
    exit;

  // Test if the group is Homogenious by Q
  bestQ := GNSSVectors[VectN[0]].StatusQ ;
  isHomo := true;
  for I := 1 to Length(VectN) - 1 do
  begin
    if GNSSVectors[VectN[I]].StatusQ < 0 then
      continue;
    if (GNSSVectors[VectN[I]].StatusQ <> bestQ) then
    begin
      isHomo := false;
    end;
  end;

  if isHomo then
  begin
    result := bestQ;
    exit;
  end;

  // 2 Got the Best Q
  bestQ := 0;
  for I := 0 to Length(VectN) - 1 do
  begin
    if GNSSVectors[VectN[I]].StatusQ < 0 then
      continue;
    if (bestQ = 0) or (GNSSVectors[VectN[I]].StatusQ < bestQ)and(GNSSVectors[VectN[I]].StatusQ > 0) then
      bestQ := GNSSVectors[VectN[I]].StatusQ;
  end;

  // 3 Got the Worst Q
  worstQ := -1;
  for I := 0 to Length(VectN) - 1 do
  begin
    if GNSSVectors[VectN[I]].StatusQ < 0 then
      continue;
    if (worstQ = -1) or (GNSSVectors[VectN[I]].StatusQ > worstQ)
      or (GNSSVectors[VectN[I]].StatusQ = 0) then
      worstQ := GNSSVectors[VectN[I]].StatusQ;
  end;

  if (worstQ = bestQ) or (worstQ = -1) then
  begin
    result := bestQ;
    exit;
  end else
  begin
    if worstQ > 6 then
      worstQ := 0;

    result := 100 + bestQ*10 + worstQ;
  end;

end;


procedure EnableGNSSVector(VectorN:integer);
//var SessN:Integer;
begin
  if GNSSVectors[VectorN].StatusQ < 0 then
  begin
     GNSSVectors[VectorN].StatusQ := -GNSSVectors[VectorN].StatusQ;

     if GNSSVectors[VectorN].StatusQ = 100 then
        GNSSVectors[VectorN].StatusQ := 0;

     //SessN := GetGNSSSessionNumber(GNSSVectors[VectorN].RoverID);

     if (GNSSVectors[VectorN].StatusQ > 0) and
        (GNSSVectors[VectorN].StatusQ <> 8) then
       AddSolutionFromVector(VectorN);

    if GNSSVectors[VectorN].StatusQ >= 0 then
       DebugMSG('ENABLING Vector: '+
                BareId(GNSSVectors[VectorN].RoverID) +' -> '+
                BareId(GNSSVectors[VectorN].BaseID))
    else
       DebugMSG('DISABLING Vector: '+
                BareId(GNSSVectors[VectorN].RoverID) +' -> '+
                BareId(GNSSVectors[VectorN].BaseID));
  end;

end;

procedure DisableGNSSVector(VectorN:integer);
begin
  if GNSSVectors[VectorN].StatusQ >= 0 then
  begin
     GNSSVectors[VectorN].StatusQ := -GNSSVectors[VectorN].StatusQ;

     if GNSSVectors[VectorN].StatusQ < 0 then
       DelSolutionFromVector(VectorN, false);

    if GNSSVectors[VectorN].StatusQ = 0 then
      GNSSVectors[VectorN].StatusQ := -100;

    if GNSSVectors[VectorN].StatusQ >= 0 then
       DebugMSG('ENABLING Vector: '+
                BareId(GNSSVectors[VectorN].RoverID) +' -> '+
                BareId(GNSSVectors[VectorN].BaseID))
    else
       DebugMSG('DISABLING Vector: '+
                BareId(GNSSVectors[VectorN].RoverID) +' -> '+
                BareId(GNSSVectors[VectorN].BaseID));
  end;

end;

procedure InvertGNSSVector(VectorN:integer; GroupInv:Boolean = true);

  procedure InvertOneVector(N:integer);
  var s:string;
  begin
    DebugMSG('Inverting Vector: '+
                BareId(GNSSVectors[N].RoverID) +' -> '+
                BareId(GNSSVectors[N].BaseID));

    // 1. Delete Solution for ex-Rover
    // Replaced

    // 2. Invert Vector
    s := GNSSVectors[N].BaseID;
    GNSSVectors[N].BaseID  := GNSSVectors[N].RoverID;
    GNSSVectors[N].RoverID := s;
    GNSSVectors[N].dX := -GNSSVectors[N].dX;
    GNSSVectors[N].dY := -GNSSVectors[N].dY;
    GNSSVectors[N].dZ := -GNSSVectors[N].dZ;

    /// ToDo: Invert Matrix with errs

    DebugMSG('Vector Inverted: '+
                BareId(GNSSVectors[N].RoverID) +' -> '+
                BareId(GNSSVectors[N].BaseID));

    // 3. Make a new Solution
    // REPLACED!
  end;

  function GetStation(ID:string):string;
  var j:integer;
  begin
    result := '';
    j   := GetGNSSSessionNumber(ID);
    if j > -1 then
      result := GNSSSessions[j].Station;
  end;
var
    I, j : integer;
    BID, RID, iBID, iRID :string;
    Ar: Array [0..GNSSMaxUpdateStack] of Integer;
begin

   if GroupInv = false then
   begin
     InvertOneVector(VectorN);
     DelSolutionFromVector(VectorN, true);
     AddSolutionFromVector(VectorN);
   end
   else
   begin
     BID := GetStation(GNSSVectors[VectorN].BaseID);
     RID := GetStation(GNSSVectors[VectorN].RoverID);
     if (RID = '') or (BID = '') then
       exit;
     j := -1;
     for I := 0 to Length(GNSSVectors) - 1 do
     begin
        iBID := GetStation(GNSSVectors[I].BaseID);
        iRID := GetStation(GNSSVectors[I].RoverID);
        if (iRID = '') or (iBID = '') then
          continue;
        if (iBID = BID) and (iRID = RID) then
        begin
           InvertOneVector(I);
           if j < GNSSMaxUpdateStack then
             inc(j)
           else
           begin
             DebugMSG('ERROR! Vectors amount overflow');
             break;
           end;

           Ar[j] := I;
        end;
      end;
      for I := 0 to j  do
      begin
        DelSolutionFromVector(Ar[I], true);
        AddSolutionFromVector(Ar[I]);
      end;
   end;

end;

procedure CheckGNSSVectorsForSession(SessionId:string);  overload
var I, N1, N2, SessionN :Integer;
begin
   DebugMSG('Checking directions of Vectors for: '+BareId(SessionId));

   for I := 0 to Length(GNSSVectors) - 1 do
   begin
     if (GNSSVectors[I].BaseID = SessionId) or
        (GNSSVectors[I].RoverID = SessionId) then

     N2 := GetGNSSSessionNumber(GNSSVectors[I].RoverID);
     N1 := GetGNSSSessionNumber(GNSSVectors[I].BaseID);

     if (N1 = -1) or (N2 = -1) then
        continue;

     if NeedRewerse(N1, N2) then
        InvertGNSSVector(I);
   end;
     
end;

procedure CheckGNSSVectorsForSession(SessionN:integer);  overload
begin
  try
    CheckGNSSVectorsForSession(GNSSSessions[SessionN].SessionID);
  except
  end;
end;

function GetAntParams(AntName:string):TGNSSAntennaPCV;

  function isTheSame(name1, name2: string): boolean;
  var s11, s12, s21, s22:string;
  begin
    s11 := trim(GetCols(name1,0,1,' ',false));
    s12 := trim(GetCols(name1,1,1,' ',false));
    s21 := trim(GetCols(name2,0,1,' ',false));
    s22 := trim(GetCols(name2,1,1,' ',false));

    result := s11 = s21;

    if result then
      result := (s22 = s12) or
                ((s22 = '') and (LowerCase(s12) ='none')) or
                ((s12 = '') and (LowerCase(s22) ='none'));
  end;

  var I, j :Integer;
      IAntName: string;
  const StartN = 11;
begin
  AntName := trim(AntName);

  result.AntName := AntName;
  result.LineN   := -1;

  result.L1E := 0;    result.L1N := 0;    result.L1H := 0;
  result.L2E := 0;    result.L2N := 0;    result.L2H := 0;

  result.Radius := 0;

  for I := 0 to 20 do
  begin
    result.L1Corr[I] := 0;
    result.L2Corr[I] := 0;
  end;

  I := StartN;
  repeat
     IAntName := Trim(copy(PCVFile[I],1,21));

     if AnsiLowerCase(IAntName) = AnsiLowerCase(AntName) then
     begin
        result.LineN   := I;

        result.AntDescripton := Trim(copy(PCVFile[I],22, 40));

        result.GroundPlaneH := 0;
        result.Radius       := 0;

        result.L1E := StrToFloat2(copy(PCVFile[I+1],  1, 10));
        result.L1N := StrToFloat2(copy(PCVFile[I+1], 11, 10));
        result.L1H := StrToFloat2(copy(PCVFile[I+1], 21, 10));

        result.L2E := StrToFloat2(copy(PCVFile[I+4],  1, 10));
        result.L2N := StrToFloat2(copy(PCVFile[I+4], 11, 10));
        result.L2H := StrToFloat2(copy(PCVFile[I+4], 21, 10));

        for j := 0 to 9 do
        begin
          result.L1Corr[j]     := StrToFloat2(copy(PCVFile[I+2], 1 + j*6, 6));
          result.L1Corr[10+j]  := StrToFloat2(copy(PCVFile[I+3], 1 + j*6, 6));
          result.L2Corr[j]     := StrToFloat2(copy(PCVFile[I+5], 1 + j*6, 6));
          result.L2Corr[10+j]  := StrToFloat2(copy(PCVFile[I+6], 1 + j*6, 6));
        end;


     end;

     I := I+7;
  until I >= PCVFile.Count-1;

  /// ToDo: ANTPCV.GroundPlaneH, Radius

  for I := 0 to ARFile.Count - 1 do
  begin
    IAntName := GetCols(ARFile[I],0,1,#$9,false);
    if isTheSame(IAntName, AntName) then
    begin
      result.Radius       :=  StrToFloat2(GetCols(ARFile[I], 1, 1, #$9, false));
      result.GroundPlaneH :=  StrToFloat2(GetCols(ARFile[I], 2, 1, #$9, false));
      break;
    end
    else
      if IAntName > AntName then
        break;
  end;

end;

function GetAntH(rawH:Double; AntName:string; Method: byte): Double;
var a: double;
    MyAnt :TGNSSAntennaPCV;
begin
  result := rawH;
  MyAnt :=  GetAntParams(AntName);

  case Method of
     0: // From BGP (subtract the difference BGP-ARP)
     begin
       result := rawH - MyAnt.GroundPlaneH;
     end;

     1: // From ARP (do nothing)
     begin
       result := rawH;
     end;

     2: // Slant (needs Radius!!!!)
     try
       result := Sqrt(sqr(rawH) - sqr(MyAnt.Radius)) - MyAnt.GroundPlaneH;
     except
       result := rawH;
     end;

     3: result := rawH - MyAnt.L1H;
     4: result := rawH - MyAnt.L2H;
  end;

end;


function LeftFormatted(D:Double; aCount :integer):string;
var I:Integer;
    s:string;
begin
   result := '';
   s:= FormatFloat('0.0', D);
   for I := length(s) to aCount-1 do
     s := ' ' + s;
   result := s;
end;

procedure AddAntennaToPCV(NewAnt:TGNSSAntennaPCV);
  function isTheSame(name1, name2: string): boolean;
    var s11, s12, s21, s22:string;
  begin
    s11 := trim(GetCols(name1, 0, 1, ' ', false));
    s12 := trim(GetCols(name1, 1, 1, ' ', false));
    s21 := trim(GetCols(name2, 0, 1, ' ', false));
    s22 := trim(GetCols(name2, 1, 1, ' ', false));

    result := s11 = s21;

    if result then
      result := (s22 = s12) or
                ((s22 = '') and (LowerCase(s12) ='none')) or
                ((s12 = '') and (LowerCase(s22) ='none'));
  end;

  var I, j, LineN:Integer;
      OldAnt:TGNSSAntennaPCV;
      isAdd :boolean;
begin
   OldAnt := GetAntParams(NewAnt.AntName);
   LineN := OldAnt.LineN;
   isAdd := LineN = -1;

   NewAnt.AntName :=  AnsiUpperCase(NewAnt.AntName);

   if isAdd then
   begin
     // 1) Find Alphabetical
     j := 0;
     for I := 1 to Length(GNSSAntNames) - 1 do
       if AnsiUpperCase(GNSSAntNames[I]) > AnsiUpperCase(NewAnt.AntName)  then
       begin
         j := I;
         break;
       end;

     if (j = 0) and (AnsiUpperCase(GNSSAntNames[Length(GNSSAntNames) - 1])
           < AnsiUpperCase(NewAnt.AntName) ) then
     begin
       LineN := PCVFile.Count;
       for I := 0 to 6 do
         PCVFile.Add('');
     end
     else
     begin
       OldAnt := GetAntParams(GNSSAntNames[j]);
       LineN := OldAnt.LineN;
       for I := 0 to 6 do
         PCVFile.Insert(LineN,'');
     end;
  end;

  for I := 1 to 6 do
    PCVFile[LineN+I]   := '';

  PCVFile[LineN]   := NewAnt.AntName;

  for I := length(PCVFile[LineN]) to 20 do
    PCVFile[LineN]   := PCVFile[LineN] + ' ';
  PCVFile[LineN]   := PCVFile[LineN] + NewAnt.AntDescripton;



  PCVFile[LineN+1] := LeftFormatted(NewAnt.L1E, 10) +
                      LeftFormatted(NewAnt.L1N, 10) +
                      LeftFormatted(NewAnt.L1H, 10);

  PCVFile[LineN+4] := LeftFormatted(NewAnt.L2E, 10) +
                      LeftFormatted(NewAnt.L2N, 10) +
                      LeftFormatted(NewAnt.L2H, 10);

  for I := 0 to 9 do
  begin
    PCVFile[LineN+2] := PCVFile[LineN+2] +
                        LeftFormatted(NewAnt.L1Corr[I], 6);
    if I <= 8 then
      PCVFile[LineN+3] := PCVFile[LineN+3] +
                          LeftFormatted(NewAnt.L1Corr[I + 10], 6);

    PCVFile[LineN+5] := PCVFile[LineN+5] +
                        LeftFormatted(NewAnt.L2Corr[I], 6);
    if I <= 8 then
      PCVFile[LineN+6] := PCVFile[LineN+6] +
                          LeftFormatted(NewAnt.L2Corr[I + 10], 6);
  end;

  PCVFile.SaveToFile(PCVFilePath);

  isAdd:= false;
  LineN := 0;
  for I := 0 to ARFile.Count - 1 do
  begin
    if isTheSame(GetCols(ARFile[I], 0, 1, #$9, false), NewAnt.AntName) then
    begin
      ARFile[I] := NewAnt.AntName + #$9 + FloatToStr(NewAnt.Radius)
          + #$9 + FloatToStr(NewAnt.GroundPlaneH);
      break;
    end
    else
      if GetCols(ARFile[I], 0, 1, #$9, false) > NewAnt.AntName then
      begin
        isAdd := true;
        LineN := I;
        break;
      end;
  end;

  if (isAdd) then
    ARFile.Insert(LineN, NewAnt.AntName + #$9 + FloatToStr(NewAnt.Radius)
          + #$9 + FloatToStr(NewAnt.GroundPlaneH));

  ARFile.SaveToFile(ARFilePath);

  LoadAntennasPCV(PCVFilePath, ARFilePath);
end;

procedure GetAntList;
var I, N:Integer;
const StartN = 11;
begin
  I := StartN;

  N:= Trunc( (PCVFile.Count - StartN)/ 7 );

  SetLength(GNSSAntNames, N);

  for I := 0 to N - 1 do
    GNSSAntNames[I] :=  Trim(copy(PCVFile[StartN + I*7], 1, 21));
end;

procedure LoadAntennasPCV(FileName:String; Filename2:String = '');
begin
  if PCVFile = nil then
    PCVFile := TStringList.Create;

  if ARFile = nil then
    ARFile := TStringList.Create;

  PCVFile.LoadFromFile(FileName);
  if Pos(':',FileName) = 0 then
    PCVFilePath := GetCurrentDir+'\'+FileName
  else
    PCVFilePath := FileName;
  GetAntList;

  if FileName2 <> '' then
  begin
    if Pos(':', FileName2) = 0 then
      ARFilePath := GetCurrentDir+'\'+FileName2
    else
      ARFilePath := FileName2;
  end;

  ARFile.LoadFromFile(ARFilePath);
end;

procedure DestroyGNSSObjs;
begin
  try
    if PCVFile <> nil then
      PCVFile.Destroy;
    if ARFile <> nil then
      ARFile.Destroy;
    if GNSSDebug <> nil then
      GNSSDebug.Destroy
  except
  end;
end;


end.
