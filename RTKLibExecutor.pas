unit RTKLibExecutor;

interface

uses
  SysUtils, Windows, Variants, Classes, Dialogs, ShellApi, ComCtrls, StdCtrls,
  Messages, Forms, TabFunctions, DateUtils, GNSSObjects, GeoString, GeoTime;

type

  TRTKLibThread = class(TThread)
      CommandLine     :string;
      Progressbar     :TProgressBar;
      Memo            :TMemo;
      UpdStr          :string;
      RoverID, BaseID :string;
      ResultFile      :string;
      Success         :boolean;
    private
      procedure GUIUpdate();
      procedure ApplyResult();
    protected
    public
      constructor Create(Const ACommandLine: string;
          AProgressbar: TProgressBar; AMemo: TMemo;
          ARoverID, ABaseID, AResultFile: string);
      destructor Destroy; override;
      procedure Execute(); override;
    published
  end;

  TRTKProcSettings = record
    ElevAngle: integer;
    AvailableGNSS: Array [0..6] of Boolean;
    Frequencies:integer;
    ExcludedSats:string;
  end;

  TRTKLibSolutionLine = record
    T : TDateTime;
    X, Y, Z :Double;
    Q : Byte;
    sdX, sdY, sdZ, sdXY, sdYZ, sdZX : double;
  end;
  //// -------------------------------------------------------------------------

  function LaunchRTKLib(Const CommandLine : string;
          Progressbar: TProgressBar; Memo: TMemo;
          RoverID, BaseID, ResultFile: string):boolean;
  function GetTimeFromRTKLIB(s:string):TDateTime;
  function GetTimeForRTKLIB(DT:TDateTime):string;
  function StopRTKLib :boolean;

  //// -------------------------------------------------------------------------
  procedure SetRTKSetings(ElevAngle: integer; AvGNSS:Array of Boolean;
        Frequencies:integer; ExcludedSats:string);

  function SingleRTKProcess(Rover:TGNSSSession; ProgressBar:TProgressBar;
    Memo:TMemo):boolean;

  function BaseLineRTKProcess(Rover, Base :TGNSSSession; ProgressBar:TProgressBar;
    Memo:TMemo; isFix, isDGNSS:boolean):boolean; overload;

  function PPPRTKProcess(Rover:TGNSSSession; ProgressBar:TProgressBar;
    Memo:TMemo):boolean;

  procedure InitRTKLIBPaths(FileName:string);

var
  RTKLibThread     :TRTKLibThread = nil;
  isMainProcessOn  :boolean = false;
  MainProcessInfo  :TProcessInformation;
  RTKLibLog        :TStringList;

  RTKStartTime     :TDateTime;
  RTKEndTime       :TDateTime;
  RTKLibMethod     :byte = 0; // 1 - Single, 2 - Baseline, 3 - PPP

  RTKLibDest       :string = 'RTKLIB\bin\rnx2rtkp.exe';
  RTKLibDestPPP    :string = 'RTKLIB\bin_242\rnx2rtkp.exe';
  RTKWorkDir       :string = '';

  RTKSettingsInited:boolean = false;
  RTKSettings      :TRTKProcSettings;

  RTKCancelled     :Boolean = false;
const
  RTKLogStart = 'Starting the process...';
  RTKLogEnd   = 'Done!';

implementation

procedure CheckDirs;
  procedure CorrectDir(var s:string);
  begin
     if s[Length(s)] <> '\' then  s := s + '\';
  end;
begin
   //CorrectDir(RTKLibDest);
   CorrectDir(RTKWorkDir);
end;

function TerminateProcessByID(ProcessID: Cardinal): Boolean;
var
  hProcess : THandle;
begin
  Result := False;
  hProcess := OpenProcess(PROCESS_TERMINATE,False,ProcessID);
  if hProcess > 0 then
  try
    Result := Win32Check(Windows.TerminateProcess(hProcess,0));
  finally
    CloseHandle(hProcess);
    RTKCancelled := true;
  end;
end;

function StopRTKLib :boolean;
begin
    result := TerminateProcessByID(MainProcessInfo.dwProcessId);
    DebugMSG('Aborted by user!')
end;

function GetTimeForRTKLIB(DT:TDateTime):String;
var
  fs: TFormatSettings;
begin
  fs.DateSeparator   := '/';
  fs.ShortDateFormat := 'yyyy/MM/dd';
  fs.TimeSeparator   := ':';
  fs.ShortTimeFormat := 'hh:mm:ss';
  fs.LongTimeFormat  := 'hh:mm:ss';

  result := DateToStr(DT, fs) + ' '+ TimeToStr(DT, fs);
end;

function GetTimeFromRTKLIB(s:string):TDateTime;
var
  fs: TFormatSettings;
begin
  //fs := TFormatSettings.Create;
  fs.DateSeparator := '/';
  fs.ShortDateFormat := 'yyyy/MM/dd';
  fs.TimeSeparator := ':';
  fs.ShortTimeFormat := 'hh:mm:ss';
  fs.LongTimeFormat := 'hh:mm:ss';

  result := StrToDateTime(s, fs);
end;

constructor TRTKLibThread.Create(Const ACommandLine: string;
    AProgressbar :TProgressBar; AMemo: TMemo;
    ARoverID, ABaseID, AResultFile: string);
begin
  inherited Create(false);
  CommandLine := ACommandLine;
  Progressbar := AProgressbar;
  Memo        := AMemo;
  RoverID     := ARoverID;
  BaseID      := ABaseID;
  ResultFile  := AResultFile;
  Self.FreeOnTerminate := True;
  Success     := False;
  RTKCancelled:= False;
end;

destructor TRTKLibThread.Destroy;
begin
  inherited;
  RTKLibThread := nil;

  UpdStr := UpdStr + #13+ RTKLogEnd;
  if directoryexists('Logs\') then
    RTKLibLog.SaveToFile('Logs\Recent.txt');
  TThread.Synchronize(nil, GUIUpdate);
  ProgressBar.Position := 0;
end;

procedure TRTKLibThread.ApplyResult();
var S   :TStringList;
    I, j, N:Integer;
    A:Array of TRTKLibSolutionLine;

    WaitForStart: Boolean;
begin
  if RTKLibMethod = 0 then
    exit;

  S := TStringList.Create;
  S.LoadFromFile(ResultFile);

  WaitForStart := true;
  j := 0;
  for I := 0 to S.Count - 1 do
  begin

    if WaitForStart then
    begin
     // showmessage(S[I][1]);
      if (s[I][1] <> '%') and (s[I][1] <> ' ') then
      begin
         WaitForStart := false;
         SetLength(A, S.Count - I)
      end else
      continue;
    end;

    if S[I]='' then
    begin
      SetLength(A, Length(A)-1);
    end;

    A[j].T := GetTimeFromRTKLIB(GetCols(S[I], 0, 1, ' ', false) + ' '
                + GetCols(S[I], 1, 1, ' ', false));
    A[j].X := StrToFloat2(GetCols(S[I], 2, 1, ' ', false));
    A[j].Y := StrToFloat2(GetCols(S[I], 3, 1, ' ', false));
    A[j].Z := StrToFloat2(GetCols(S[I], 4, 1, ' ', false));

    A[j].Q := Trunc(StrToFloat2(GetCols(S[I], 5, 1, ' ', false)));

    A[j].sdX  := StrToFloat2(GetCols(S[I], 7, 1, ' ', false));
    A[j].sdY  := StrToFloat2(GetCols(S[I], 8, 1, ' ', false));
    A[j].sdZ  := StrToFloat2(GetCols(S[I], 9, 1, ' ', false));
    A[j].sdXY := StrToFloat2(GetCols(S[I], 10,1, ' ', false));
    A[j].sdYZ := StrToFloat2(GetCols(S[I], 11,1, ' ', false));
    A[j].sdZX := StrToFloat2(GetCols(S[I], 12,1, ' ', false));

    inc(j);
  end;

  // Find: I = SessionN, N = SolutionN

  I := GetGNSSSessionNumber(RoverId);
  if (I = -1) then
  begin
    messageDlg('Object not found: '+RoverID, mtError, [mbOk], 0);
    S.Free;
    exit
  end;

  if (Length(A) = 0) then
  begin
     if (not RTKCancelled) then
     begin
       messageDlg('The solution is empty!', mtError, [mbOk], 0);
       DebugMSG('ERROR! No solution is gotten');
       /// Vector has an Error!
       if RTKLibMethod = 2 then
       for j := 0 to Length(GNSSVectors) - 1 do
       if (GNSSVectors[j].BaseID = BaseID) and
          (GNSSVectors[j].RoverID = GNSSSessions[I].SessionID)
       then
       begin
          DeleteGNSSSolution(I,
             GetGNSSSolutionForVector(I, GNSSVectors[j].BaseID));
          GNSSVectors[j].StatusQ := 8;   /// ERROR!
       end;
     end;
     S.Free;
     exit
  end;
  

  N := -1;
  for j := 0 to Length(GNSSSessions[I].Solutions) - 1 do
  begin
     if GNSSSessions[I].Solutions[j].SolutionKind = RTKLibMethod then
     begin
        if RTKLibMethod = 2 then
           if GNSSSessions[I].Solutions[j].BaseID <> BaseID then
             continue;

        N := j;
     end;
  end;
  if N = -1 then
  begin
    N := Length(GNSSSessions[I].Solutions);
    SetLength(GNSSSessions[I].Solutions, N+1);
    GNSSSessions[I].Solutions[N].SolutionKind := RTKLibMethod;
    GNSSSessions[I].Solutions[N].BaseID := BaseID;
  end;

  /// Temporary. ToDo: Better
  with GNSSSessions[I].Solutions[N] do
  Begin
     PointPos.X := A[0].X;
     PointPos.Y := A[0].Y;
     PointPos.Z := A[0].Z;
     SolutionQ := A[0].Q;
     StDevs[1] :=  A[0].sdX;   StDevs[2] :=  A[0].sdY;   StDevs[3] :=  A[0].sdZ;
     StDevs[4] :=  A[0].sdXY;  StDevs[5] :=  A[0].sdYZ;  StDevs[6] :=  A[0].sdZX;
  End;

  if GNSSSessions[I].isKinematic then
  begin


     // ToDo: Convert Array A into a Track; Assign the track to the Rover
  end
  else
  begin
     

     // ToDo: FindAVG
  end; 

  RefreshGNSSSolution(I, N, True);

  S.Free;
end;

procedure TRTKLibThread.GUIUpdate();
var I   :Integer;
    s   :string;
    DT  :TDateTime;
begin
   if RTKLibLog = nil then
      RTKLibLog := TStringList.Create;
   RTKLibLog.Text := RTKLibLog.Text + Updstr;

   if Memo <> nil then
   begin
      Application.ProcessMessages;

      Memo.Lines.BeginUpdate;
      if Memo.Lines.Count > 20 then
         Memo.Lines.Clear;

      Memo.Lines.Text := Memo.Lines.Text + Updstr;
      UpdStr := '';
      SendMessage(Memo.Handle, EM_LINESCROLL, 0, Memo.Lines.Count);
      Memo.Lines.EndUpdate;
   end;


   for I := RTKLibLog.Count-1  DownTo RTKLibLog.Count-10 do
   try
     if I < 0 then
       break;

     if GetColCount(RTKLibLog[I], ' ') >= 4 then
     begin

       s := GetCols(RTKLibLog[I], 4, 1, ' ', false);
       if length(s)<3 then
         continue;

       s :=  GetCols(RTKLibLog[I], 2, 1, ' ', false)+' '+
            GetCols(RTKLibLog[I], 3, 1, ' ', false);

       DT := GetTimeFromRTKLIB(s);

       ProgressBar.Position := Round( 100*(DT - RTKStartTime) /
                                    (RTKEndTime - RTKStartTime) );

       break;
     end;
   except
   end;
end;

procedure TRTKLibThread.Execute;

  function ExecAndCapture(const ACmdLine: string): Boolean;
  const
    cBufferSize = 2048;
  var
    SA: TSecurityAttributes;
    SI: TStartupInfo;
    PI: TProcessInformation;
    StdOutPipeRead, StdOutPipeWrite: THandle;
    WasOK: Boolean;
    Buffer: array[0..255] of AnsiChar;
    BytesRead: Cardinal;
    WorkDir: string;
    Handle: Boolean;

    AOutput: string;
  begin
    Result := False;
    AOutput := '';

    UpdStr := UpdStr + #13+ RTKLogStart;
    TThread.Synchronize(nil, GUIUpdate);
    with SA do begin
      nLength := SizeOf(SA);
      bInheritHandle := True;
      lpSecurityDescriptor := nil;
    end;
    CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SA, 0);
    try
      with SI do
      begin
        FillChar(SI, SizeOf(SI), 0);
        cb := SizeOf(SI);
        dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
        wShowWindow := SW_HIDE;
        hStdInput := GetStdHandle(STD_INPUT_HANDLE);
        hStdOutput := StdOutPipeWrite;
        hStdError := StdOutPipeWrite;
      end;

      WorkDir := GetCurrentDir;
      Handle := CreateProcess(nil, PChar(ACmdLine),
                            nil, nil, True, 0, nil,
                            PChar(WorkDir), SI, PI);

      MainProcessInfo := PI;

      CloseHandle(StdOutPipeWrite);
      if Handle then
        try
          repeat
            WasOK := ReadFile(StdOutPipeRead, Buffer[0], 255, BytesRead, nil);
            if BytesRead > 0 then
            begin
              Buffer[BytesRead] := #0;
              AOutput := AOutput + string(Buffer);
            end;

            UpdStr := UpdStr + AOutput; AOutput:='';
            TThread.Synchronize(nil, GUIUpdate);

          until not WasOK or (BytesRead = 0);
          WaitForSingleObject(PI.hProcess, INFINITE);
          Application.ProcessMessages;
        finally
          CloseHandle(PI.hThread);
          CloseHandle(PI.hProcess);

          UpdStr := UpdStr + Aoutput; AOutput := '';
          TThread.Synchronize(nil, GUIUpdate);
        end;

      Result := True;
    finally
      CloseHandle(StdOutPipeRead);
      Success := true;
      TThread.Synchronize(nil, ApplyResult);
      {UpdStr := UpdStr + #13+ RTKLogEnd;
      RTKLibLog.SaveToFile('Logs\Recent.txt');
      TThread.Synchronize(nil, GUIUpdate);
      ProgressBar.Position := 0;             }
    end;
  end;

begin
  try
    if not ExecAndCapture(CommandLine) then
      MessageDlg('Error! Cannot launch the GNSS Processor', mtError, [mbOk], 0)
  except
    MessageDlg('Error! GNSS Processor Failure', mtError, [mbOk], 0)
  end;
end;

function LaunchRTKLib(Const CommandLine: string;
          Progressbar: TProgressBar; Memo: TMemo;
          RoverID, BaseID, ResultFile: string):boolean;
begin
  if RTKLibThread = nil then
  begin
    if RTKLibLog = nil then
      RTKLibLog := TStringList.Create();
    RTKLibLog.clear;

    RTKLibLog.SaveToFile(ResultFile); // clerar the result file

    RTKLibThread := TRTKLibThread.Create(CommandLine, Progressbar, Memo,
        RoverID, BaseID, ResultFile);
    result := true
  end
  else
  begin
    MessageDlg('Error! GNSS Processor is already ran', mtError, [mbOk], 0);
    result := false;
  end;
end;


procedure PrepareSettings(FileName: String; Mode: byte; ElevAngle: integer;
        AvGNSS:array of boolean; Frequencies:integer; ExcludedSats:string;
        X, Y, Z, Xr, Yr, Zr :double; Ant1, Ant2: string;
        A1N, A1E, A1H, A2N, A2E, A2H: double); overload;
var S :TStringList;
    I, j, AvailableGNSS :Integer;
const
    Frq :Array [0..3] of String = ('l1+2+3+4+5','l1','l1+2','l1+2+3');
    Modes :Array [0..8] of String = ('single', 'dgps', 'kinematic', 'static',
                'movingbase','fixed','ppp-kine','ppp-static','ppp-fixed');
begin
   S := TStringList.Create;
   case Mode of
      0   : S.LoadFromFile('Data\GNSS\Single.conf');
      1..5: S.LoadFromFile('Data\GNSS\Static.conf');
      6..8:  S.LoadFromFile('Data\GNSS\PPP.conf');
   end;

   j := 1; AvailableGNSS := 0;
   for I := 0 to 6 do
    if I < Length(AvGNSS) then
    begin
      if AvGNSS[I] then
         AvailableGNSS := AvailableGNSS + j;
      RTKSettings.AvailableGNSS[I] := AvGNSS[I];
      j := j*2;
    end else
      RTKSettings.AvailableGNSS[I] := true;

   for I := 0 to S.Count - 1 do
   begin
     if Pos('pos1-posmode', S[I]) =1 then
       S[I] := 'pos1-posmode       =' +  Modes[Mode];

     if Pos('pos1-navsys', S[I]) =1 then
       S[I] := 'pos1-navsys        =' +  IntToStr(AvailableGNSS);

     if Pos('pos1-elmask', S[I]) =1 then
       S[I] := 'pos1-elmask        =' +  IntToStr(ElevAngle);

     if Pos('pos1-frequency', S[I]) =1 then
       if mode < 6  then
         S[I] := 'pos1-frequency     =' +  Frq[Frequencies]
       else S[I] := 'pos1-frequency     =l1+l2';

     if Pos('pos1-exclsats', S[I]) =1 then
       S[I] := 'pos1-exclsats      =' +  ExcludedSats;

     if Pos('ant2-postype', S[I]) =1 then
       S[I] := 'ant2-postype       =' +  'xyz';

     if Pos('ant2-pos1', S[I]) =1 then
       S[I] := 'ant2-pos1          =' +  FormatFloat('#.###', X);

     if Pos('ant2-pos2', S[I]) =1 then
       S[I] := 'ant2-pos2          =' +  FormatFloat('#.###', Y);

     if Pos('ant2-pos3', S[I]) =1 then
       S[I] := 'ant2-pos3          =' +  FormatFloat('#.###', Z);

     if Pos('ant1-postype', S[I]) =1 then
       S[I] := 'ant1-postype       =' +  'xyz';

     if Pos('ant1-pos1', S[I]) =1 then
       S[I] := 'ant2-pos1          =' +  FormatFloat('0.000', Xr);

     if Pos('ant1-pos2', S[I]) =1 then
       S[I] := 'ant1-pos2          =' +  FormatFloat('0.000', Yr);

     if Pos('ant1-pos3', S[I]) =1 then
       S[I] := 'ant1-pos3          =' +  FormatFloat('0.000', Zr);

     if Pos('ant2-anttype', S[I]) =1 then
       S[I] := 'ant2-anttype       =' +  Ant2;

     if Pos('ant1-anttype', S[I]) =1 then
       S[I] := 'ant1-anttype       =' +  Ant1;

     if Pos('ant1-antdele', S[I]) =1 then
       S[I] := 'ant1-antdele       =' +  FormatFloat('0.000', A1N);
     if Pos('ant1-antdeln', S[I]) =1 then
       S[I] := 'ant1-antdeln       =' +  FormatFloat('0.000', A1E);
     if Pos('ant1-antdelu', S[I]) =1 then
       S[I] := 'ant1-antdelu       =' +  FormatFloat('0.000', A1H);

     if Pos('ant2-antdele', S[I]) =1 then
       S[I] := 'ant2-antdele       =' +  FormatFloat('0.000', A2N);
     if Pos('ant2-antdeln', S[I]) =1 then
       S[I] := 'ant2-antdeln       =' +  FormatFloat('0.000', A2E);
     if Pos('ant2-antdelu', S[I]) =1 then
       S[I] := 'ant2-antdelu       =' +  FormatFloat('0.000', A2H);

     if Pos('out-solstatic', S[I]) =1 then
     case Mode of
        3,4,7,8: S[I] := 'out-solstatic      =' +  'single'
     else
        S[I] := 'out-solstatic      =' +  'all';
     end;

     if Pos('out-solformat', S[I]) =1 then
       S[I] := 'out-solformat      =xyz';

     if Pos('file-rcvantfile', S[I]) =1 then
       S[I] := 'file-rcvantfile    =' + PCVFilePath;

   end;

   RTKSettings.ElevAngle    := ElevAngle;
   RTKSettings.Frequencies := Frequencies;
   RTKSettings.ExcludedSats := ExcludedSats;
   if not RTKSettingsInited then RTKSettingsInited := true;

   S.SaveToFile(FileName);
   S.Free;
end;

procedure PrepareSettings(FileName: String; Mode: byte; X, Y, Z,
        Xr, Yr, Zr :double; Ant1, Ant2: string;
        A1N, A1E, A1H, A2N, A2E, A2H: double); overload;
var I:Integer;
const
   A: Array [0..6] of Boolean = (true, true, true, true, true, true, true);
begin
   if not RTKSettingsInited then
   begin
     for I := 0 to 6 do
       RTKSettings.AvailableGNSS[I] := A[I];

     RTKSettings.Frequencies  := 0;
     RTKSettings.ExcludedSats := '';
     RTKSettings.ElevAngle    := 15;

     RTKSettingsInited := true;
   end;

   PrepareSettings(FileName, Mode, RTKSettings.ElevAngle,
       RTKSettings.AvailableGNSS, RTKSettings.Frequencies,
       RTKSettings.ExcludedSats, X, Y, Z, Xr, Yr, Zr, Ant1, Ant2,
       A1N, A1E, A1H, A2N, A2E, A2H);
end;

procedure SetRTKSetings(ElevAngle: integer; AvGNSS:Array of Boolean;
        Frequencies:integer; ExcludedSats:string);
var I:Integer;
begin

   for I := 0 to 6 do
      if I < Length(AvGNSS) then
        RTKSettings.AvailableGNSS[I] := AvGNSS[I]
      else
        RTKSettings.AvailableGNSS[I] := true;

   RTKSettings.ElevAngle    := ElevAngle;
   RTKSettings.Frequencies := Frequencies;
   RTKSettings.ExcludedSats := ExcludedSats;
   RTKSettingsInited := true;
end;

function SingleRTKProcess(Rover:TGNSSSession; ProgressBar:TProgressBar;
    Memo:TMemo):boolean;
var CMDString:string;
    ResultFile:string;
    I:Integer;
begin
  CheckDirs;

  RTKLibMethod := 1;

  RTKStartTime := UTCToGPS(Rover.StartTime);
  RTKEndTime   := UTCToGPS(Rover.EndTime);

  PrepareSettings(RTKWorkDir +'Tmp\Config.conf', 0,
     Rover.AppliedPos.X, Rover.AppliedPos.Y, Rover.AppliedPos.Z,
     Rover.AppliedPos.X, Rover.AppliedPos.Y, Rover.AppliedPos.Z,
     Rover.Antenna.AntName, Rover.Antenna.AntName,
     Rover.Antenna.dE, Rover.Antenna.dN, Rover.AntHgt.Hant,
     Rover.Antenna.dE, Rover.Antenna.dN, Rover.AntHgt.Hant);

  if Length(Rover.AdditionalFiles) = 0 then
  begin
    MessageDlg('No navigation data found for ' + Rover.MaskName,
        mtError, [mbOk], 0);  /// ToDo: Translate!!!
    result := false;
    exit;
  end;

  CMDString := RTKLibDest + ' "' + Rover.FileName + '"';

  for I := 0 To Length(Rover.AdditionalFiles)-1 Do
     CMDString := CMDString + ' "'  + Rover.AdditionalFiles[i] +'"';

  

  CMDString := CMDString + ' -k "' + RTKWorkDir +'Tmp\Config.conf' +'"';

  ResultFile:= RTKWorkDir +'Tmp\' + Rover.SessionID + '.txt';
  CMDString := CMDString + ' -o "' + ResultFile + '"';

  DebugMSG('Started single processing: ' + Rover.MaskName);

  result := LaunchRTKLib(Cmdstring, ProgressBar, Memo, Rover.SessionID, '',
     ResultFile);
end;

function BaseLineRTKProcess(Rover, Base :TGNSSSession; ProgressBar:TProgressBar;
    Memo:TMemo; isFix, isDGNSS:boolean):boolean; overload;
var CMDString:string;
    ResultFile:string;
    I:Integer;
begin
  CheckDirs;

  RTKLibMethod := 2;

  /// ???? ����������  �������� �����??? ToDO
  RTKStartTime := UTCToGPS(Rover.StartTime);
  RTKEndTime   := UTCToGPS(Rover.EndTime);

  if Rover.isKinematic then
     I := 2
  else
     I := 3;

  if I = 3 then
    if IsFix then
      I := 5;

  if I <> 5 then
    if isDGNSS then
      I := 1;

  PrepareSettings(RTKWorkDir +'\Tmp\Config.conf', I,
     Base.AppliedPos.X, Base.AppliedPos.Y, Base.AppliedPos.Z,
     Rover.AppliedPos.X, Rover.AppliedPos.Y, Rover.AppliedPos.Z,
     Base.Antenna.AntName, Rover.Antenna.AntName,
     Rover.Antenna.dE, Rover.Antenna.dN, Rover.AntHgt.Hant,
     Base.Antenna.dE,  Base.Antenna.dN,  Base.AntHgt.Hant);  /// &&&&!!!!

  CMDString := RTKLibDest + ' "' + Rover.FileName + '"';
  CMDString := CMDString  + ' "' + Base.FileName + '"';

  if Length(Rover.AdditionalFiles) > 0 then
  begin
    for I := 0 To Length(Rover.AdditionalFiles)-1 Do
     CMDString := CMDString + ' "'  + Rover.AdditionalFiles[i] +'"';
  end
  else
  if Length(Base.AdditionalFiles) > 0 then
  begin
    for I := 0 To Length(Base.AdditionalFiles)-1 Do
     CMDString := CMDString + ' "'  + Base.AdditionalFiles[i] +'"';
  end
  else
  begin
     MessageDlg('No navigation data found for '+ Base.MaskName +'/'+Rover.MaskName,
        mtError, [mbOk], 0);  /// ToDo: Translate!!!
     result := false;
     exit;
  end;

  CMDString := CMDString + ' -k "' + RTKWorkDir +'Tmp\Config.conf' +'"';

  ResultFile := RTKWorkDir +'Tmp\' + Base.SessionID
     + '_' + Rover.SessionID + '.txt';
  CMDString := CMDString + ' -o "' + ResultFile + '"';

  DebugMSG('Started baseline processing: ' + Base.MaskName + ' -> ' + Rover.MaskName);

  result := LaunchRTKLib(Cmdstring, ProgressBar, Memo,
            Rover.SessionID, Base.SessionID, ResultFile);
end;

function PPPRTKProcess(Rover:TGNSSSession; ProgressBar:TProgressBar;
    Memo:TMemo):boolean;

  function isNumber(s:char):boolean;
  begin
     case s of
       '0'..'9', '_' : result := true;
       else result := false;
     end;
  end;

  function HasFilesPPP:boolean;
  var I:Integer;  s:string;
      hasSP3, hasCLK, hasN :boolean;
  begin
    result := false;
    hasSP3 := false;
    hasCLK := false;
    hasN   := false;
    with Rover do
    begin

       for I := 0 to length(AdditionalFiles) - 1 do
       begin
         s := AnsiLowerCase(ExtractFileExt(AdditionalFiles[i]));
         if s = '.sp3' then
            hasSP3 := true;
         if s = '.clk' then
            hasCLK := true;
         if (s[length(s)] = 'n') and (isNumber(s[length(s)-1])) then
            hasN := true;
       end;

       result := hasSP3 and hasCLK and hasN;
    end;
  end;

  function GetFileForPPP(kind:byte):string;
   var I:Integer;  s:string;
  begin
    result := '';
    with Rover do
       for I := 0 to length(AdditionalFiles) - 1 do
       begin
         s := AnsiLowerCase(ExtractFileExt(AdditionalFiles[i]));

         if (kind = 0) and (s[length(s)] = 'n') and
            (isNumber(s[length(s)-1])) then
            result := AdditionalFiles[i];
         if (kind = 1) and (s = '.sp3') then
            result := AdditionalFiles[i];
         if (kind = 2) and (s = '.clk') then
            result := AdditionalFiles[i];

         if result<>'' then
           exit;
       end;
  end;

var CMDString:string;
    ResultFile:string;
    I:Integer;
begin
  CheckDirs;

  RTKStartTime := UTCToGPS(Rover.StartTime);
  RTKEndTime   := UTCToGPS(Rover.EndTime);

  RTKLibMethod := 3;

  if Rover.isKinematic then
     I := 6
  else
     I := 7;

  PrepareSettings(RTKWorkDir +'\Tmp\Config.conf', I,
     Rover.AppliedPos.X, Rover.AppliedPos.Y, Rover.AppliedPos.Z,
     Rover.AppliedPos.X, Rover.AppliedPos.Y, Rover.AppliedPos.Z,
     Rover.Antenna.AntName, Rover.Antenna.AntName,
     Rover.Antenna.dE, Rover.Antenna.dN, Rover.AntHgt.Hant,
     Rover.Antenna.dE, Rover.Antenna.dN, Rover.AntHgt.Hant);

  if not HasFilesPPP then
  begin
    MessageDlg('No Satellite clocks and Orbits data found for ' + Rover.MaskName,
        mtError, [mbOk], 0);       /// ToDo: Translate!!!
    result := false;
    exit;
  end;

  CMDString := RTKLibDestPPP + ' "' + Rover.FileName + '"';

  CMDString := CMDString + ' "'  + GetFileForPPP(0) +'"';
  CMDString := CMDString + ' "'  + GetFileForPPP(1) +'"';
  CMDString := CMDString + ' "'  + GetFileForPPP(2) +'"';

  CMDString := CMDString + ' -k "' + RTKWorkDir +'Tmp\Config.conf' +'"';

  ResultFile:= RTKWorkDir +'Tmp\ppp_' + Rover.SessionID + '.txt';
  CMDString := CMDString + ' -o "' + ResultFile + '"';

  DebugMSG('Started PPP processing: ' + Rover.MaskName);

  result := LaunchRTKLib(Cmdstring, ProgressBar, Memo, Rover.SessionID, '',
     ResultFile);
end;

procedure InitRTKLIBPaths(FileName:string);
var S :TStringlist;
begin
  if not fileexists(FileName) then
    exit;
  S := TStringlist.Create;
  S.LoadFromFile(FileName);
  if S.Count >1 then
  begin
    RTKLibDest    := S[0];
    RTKLibDestPPP := S[1];
  end;

  if S.Count >2 then
    LoadAntennasPCV(S[2]);
  S.Free;
end;

end.
