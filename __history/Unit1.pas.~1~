unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, shellApi, ComCtrls, Buttons, RTKLibExecutor, ExtCtrls,
  TabFunctions, Spin, GNSSObjects, GeoString, ImgList, Menus, GeoFiles, Geoid;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Button3: TButton;
    Button4: TButton;
    Label5: TLabel;
    Label6: TLabel;
    OpenDialog: TOpenDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label7: TLabel;
    Cb_GNSSSystems: TComboBox;
    Gb_GNSSSystems: TGroupBox;
    GN1: TCheckBox;
    GN3: TCheckBox;
    GN4: TCheckBox;
    GN6: TCheckBox;
    GN5: TCheckBox;
    Label8: TLabel;
    CB_Freq: TComboBox;
    SE_ElevMask: TSpinEdit;
    Label9: TLabel;
    Label10: TLabel;
    bX: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    bY: TEdit;
    bZ: TEdit;
    Label14: TLabel;
    RadioButton1: TRadioButton;
    RadioButton3: TRadioButton;
    CheckBox6: TCheckBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Button5: TButton;
    t1: TEdit;
    t2: TEdit;
    GN7: TCheckBox;
    GN2: TCheckBox;
    SessionBox: TListBox;
    SpeedButton1: TSpeedButton;
    SPropButton: TSpeedButton;
    AllSessions: TSpeedButton;
    PointBox: TListBox;
    Label15: TLabel;
    Label16: TLabel;
    DelSBtn: TSpeedButton;
    Label17: TLabel;
    BaselinesBox: TListBox;
    StationProp: TSpeedButton;
    VectorProc: TSpeedButton;
    RTKLibPathEd: TEdit;
    Label18: TLabel;
    IcoList: TImageList;
    VectorPopup: TPopupMenu;
    Invert1: TMenuItem;
    Delete1: TMenuItem;
    Enable1: TMenuItem;
    Process1: TMenuItem;
    VectorProp: TSpeedButton;
    Settings1: TMenuItem;
    SelectAll1: TMenuItem;
    Label19: TLabel;
    Panel2: TPanel;
    Memo1: TListBox;
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Cb_GNSSSystemsChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure RTKLibPathEdChange(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure SessionBoxDblClick(Sender: TObject);
    procedure SessionBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AllSessionsClick(Sender: TObject);
    procedure SessionBoxClick(Sender: TObject);
    procedure BaselinesBoxClick(Sender: TObject);
    procedure VectorProcClick(Sender: TObject);
    procedure BaselinesBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DelSBtnClick(Sender: TObject);
    procedure PointBoxClick(Sender: TObject);
    procedure StationPropClick(Sender: TObject);
    procedure VectorPopupPopup(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure VectorPropClick(Sender: TObject);
    procedure Invert1Click(Sender: TObject);
    procedure Enable1Click(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Memo1DrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure PointBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure BaselinesBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure SessionBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure BaselinesBoxDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  isProc: boolean;
  ProcInfo :TProcessInformation;
  ProcTxt  :THandle;

  Base : integer = -1;
  Rover: integer = -1;

  MyDir, ResFile :string;
implementation

uses FProcGNSS, UGNSSSessionOptions, FLoader, UStartProcessing,
  UGNSSPointSettings, UVectSettings;

{$R *.dfm}

procedure PrepareProc;
var I  :integer;
    Cb :TCheckBox;
    ES :String;
    A  :Array [0..6] of Boolean;
begin
  ES := '';
  for i := 0 to 6 do
  begin
    Cb := Form1.FindComponent('GN'+IntToStr(i+1)) as TCheckBox;
    A[I] := Cb.Checked;
  end;
  SetRTKSetings(Form1.SE_ElevMask.Value, A, Form1.CB_Freq.ItemIndex, ES);
end;

procedure WaitStatus(isWaiting :Boolean);
begin
  isProc := isWaiting;

//  with Form1 do
//  begin
//    BitBtn1.Enabled := not isProc;
//    BitBtn2.Enabled := isProc;
//
//    t1.Enabled := not isProc;
//    t2.Enabled := not isProc;
//    d1.Enabled := not isProc;
//    d2.Enabled := not isProc;
//
//    case isWaiting of
//      true:   Caption := 'RUNNING';
//      false:  Caption := '';
//    end;
//
//    pb.Position := 0;
//    StatusLabel.Caption := '';
//
//    Repaint;
//  end;

end;


procedure ExecuteWaitAndGetInfo(const ACommand, AParameters: String; AMemo: TMemo);

const
   CReadBuffer = 2400;
var
   saSecurity: TSecurityAttributes;
   hRead: THandle;
   hWrite: THandle;

   suiStartup: TStartupInfo;
   piProcess: TProcessInformation;

   pBuffer: array[0..CReadBuffer] of Char;
   dRead: DWord;
   dRunning: DWord;

   tmpProgram: String;
begin

  // PREPARING TO CAPTURE IN/OUT
  saSecurity.nLength := SizeOf(TSecurityAttributes);
  saSecurity.bInheritHandle := True;
  saSecurity.lpSecurityDescriptor := nil;

  if CreatePipe(hRead, hWrite, @saSecurity, 0) then
  begin
     SetHandleInformation(hRead, HANDLE_FLAG_INHERIT, 0);

     ProcTxt := hRead;

     /// SET STARTUP INFO
     FillChar(suiStartup, SizeOf(TStartupInfo), #0);
     with suiStartup do
     begin
        cb := SizeOf(TStartupInfo);
        hStdOutput := hWrite;
        hStdError := hWrite;
       // dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
       // wShowWindow := SW_HIDE;
     end;

     /// EXECUTE!
     if CreateProcess(nil, PChar(trim(ACommand) + ' ' + AParameters), @saSecurity,
       @saSecurity, True, NORMAL_PRIORITY_CLASS, nil, nil, suiStartup, piProcess)
       then
     begin

       WaitStatus(true);
       ProcInfo := piProcess;

       // loop every 10 ms
       while WaitForSingleObject(piProcess.hProcess, 10) > 0 do
       begin
          Application.ProcessMessages();

          {dRead := 0;
          ReadFile(hRead, pBuffer[0], CReadBuffer, dRead, nil);
          pBuffer[dRead] := #0;

          OemToAnsi(pBuffer, pBuffer);
          AMemo.Lines.Add(String(pBuffer));
//         until (dRead < CReadBuffer);
           }

       end;

       {dRunning  := WaitForSingleObject(piProcess.hProcess, 10);
       repeat
          Application.ProcessMessages();
         repeat
           Application.ProcessMessages();
           dRead := 0;
//           ReadFile(hRead, pBuffer[0], CReadBuffer, dRead, nil);
//           pBuffer[dRead] := #0;
//
//           OemToAnsi(pBuffer, pBuffer);
//           AMemo.Lines.Add(String(pBuffer));
         until (dRead < CReadBuffer);
       until (dRunning > WAIT_TIMEOUT);    }

//       repeat
//         dRunning  := WaitForSingleObject(piProcess.hProcess, 10);
//         Application.ProcessMessages();
//
//         repeat
//           Application.ProcessMessages();
//           dRead := 0;
//           ReadFile(hRead, pBuffer[0], CReadBuffer, dRead, nil);
//           pBuffer[dRead] := #0;
//
//           OemToAnsi(pBuffer, pBuffer);
//           AMemo.Lines.Add(String(pBuffer));
//         until (dRead < CReadBuffer);
//
//       until (dRunning < WAIT_TIMEOUT);

       CloseHandle(piProcess.hProcess);
       CloseHandle(piProcess.hThread);
     end  /// process
     else
     begin
        RaiseLastOSError;
     end;  // process

     CloseHandle(hRead);
     CloseHandle(hWrite);
     WaitStatus(false);
   end;   // pipe


    {if CreateProcess(nil, pchar(tmpProgram), nil, nil, true, CREATE_NO_WINDOW,
      nil, nil, suiStartup, piProcess) then}

end;

procedure ExecuteAndWait(const aCommando: string);
var
  tmpStartupInfo: TStartupInfo;
  tmpProcessInformation: TProcessInformation;
  tmpProgram: String;
begin

  tmpProgram := trim(aCommando);
  FillChar(tmpStartupInfo, SizeOf(tmpStartupInfo), 0);
  with tmpStartupInfo do
  begin
    cb := SizeOf(TStartupInfo);
    wShowWindow := SW_HIDE;
    dwFlags := STARTF_USESHOWWINDOW
  end;

  if CreateProcess(nil, pchar(tmpProgram), nil, nil, true, CREATE_NO_WINDOW,
    nil, nil, tmpStartupInfo, tmpProcessInformation) then
  begin
    WaitStatus(true);
    ProcInfo := tmpProcessInformation;
    // loop every 10 ms
    while WaitForSingleObject(tmpProcessInformation.hProcess, 10) > 0 do
    begin
      Application.ProcessMessages;
    end;
    CloseHandle(tmpProcessInformation.hProcess);
    CloseHandle(tmpProcessInformation.hThread);
    WaitStatus(false);
  end
  else
  begin
    RaiseLastOSError;
  end;
end;




procedure TForm1.BitBtn1Click(Sender: TObject);
{var CMDString, ExclSatStr :string;
    i :Integer;
    AvailableGNSS : Array[0..7] of Boolean;
    Cb:TCheckBox;}
begin
 { RTKStartTime := GetTimeFromRTKLIB(t1.Text);
  RTKEndTime   := GetTimeFromRTKLIB(t2.Text);

  SetCurrentDir(MyDir);
  ExclSatStr := '';
  for i := 0 to 6 do
  begin
    Cb := FindComponent('GN'+IntToStr(i+1)) as TCheckBox;
    AvailableGNSS[I] := Cb.Checked;
  end;


  SetRTKSetings(SpinEdit1.Value, AvailableGNSS, ComboBox3.ItemIndex, ExclSatStr);


  CMDString := MyDir + Edit4.Text + ' "' +GNSSSessions[Rover].FileName +'"';
  CMDString := CMDString + ' "' +GNSSSessions[Base].FileName +'"';

  for I := 0 To Length(GNSSSessions[Rover].AdditionalFiles)-1 Do
     CMDString := CMDString + ' "'  + GNSSSessions[Rover].AdditionalFiles[i] +'"';

  CMDString := CMDString + ' -k "' + MyDir +'\Tmp\Config.conf' +'"';
  CMDString := CMDString + ' -o "' + MyDir +'\Tmp\output.txt' +'"';

  if (LaunchRTKLib(Cmdstring,ProcGNSS.Progress, ProcGNSS.Memo)) then
  begin
    ProcGNSS.ShowModal;
    Button5.Enabled := true;
  end;  }
                                           
//  PrepareProc;
//  if BaseLineRTKProcess(GNSSSessions[Rover], GNSSSessions[Base],
//        ProcGNSS.Progress, ProcGNSS.Memo)
//    then
//  begin
//    ProcGNSS.ShowModal;
//    Button5.Enabled := true;
//    ResFile := GNSSSessions[Rover].SessionID +'_'+GNSSSessions[Base].SessionID;
//  end;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
//  RTKStartTime := GetTimeFromRTKLIB(t1.Text);
//  RTKEndTime   := GetTimeFromRTKLIB(t2.Text);

//  SetCurrentDir(MyDir);

//  PrepareSettings( MyDir +'\Tmp\Config.conf', 0, SpinEdit1.Value,
//     AvailableGNSS, ComboBox3.ItemIndex, ExclSatStr, 0,0,0);


{  CMDString := MyDir + Edit4.Text + ' "' +GNSSSessions[Rover].FileName +'"';

  for I := 0 To Length(GNSSSessions[Rover].AdditionalFiles)-1 Do
     CMDString := CMDString + ' "'  + GNSSSessions[Rover].AdditionalFiles[i] +'"';

  CMDString := CMDString + ' -k "' + MyDir +'\Tmp\Config.conf' +'"';
  CMDString := CMDString + ' -o "' + MyDir +'\Tmp\output.txt' +'"';
 }


  PrepareProc;
  //if (LaunchRTKLib(Cmdstring,ProcGNSS.Progress, ProcGNSS.Memo)) then
  if SingleRTKProcess(GNSSSessions[Rover], ProcGNSS.Progress, ProcGNSS.Memo) then
  begin
    ProcGNSS.ShowModal;
    Button5.Enabled := true;
    ResFile := GNSSSessions[Rover].SessionID;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  OpenDialog.Filter := 'Rinex Observations Files *.**o|*.??o';
  if OpenDialog.Execute() then
  begin
    FLoadGPS.Show;
    FLoadGps.Label3.Caption := 'Loading Obs File'; FLoadGps.Label3.Visible := true;
    FLoadGps.LCount.Caption := '';                 FLoadGps.LCount.Visible := true;
    
    if OpenRinex(OpenDialog.FileName, FLoadGPS.ProgressBar1) then
    begin
      SetCurrentDir(MyDir);
      Base := Length(GNSSSessions)-1;
      label4.Caption := '';

      BitBtn1.Enabled := false;
      PageControl1.ActivePageIndex := 0;
      
     { if (GNSSSessions[Rover].StartTime < GNSSSessions[Base].EndTime)
         or (GNSSSessions[Base].StartTime < GNSSSessions[Rover].EndTime)  then
        exit;
      }

      label4.Caption := GNSSSessions[Base].FileName;

      bX.Text := FloatToStr(GNSSSessions[Base].AppliedPos.X);
      bY.Text := FloatToStr(GNSSSessions[Base].AppliedPos.Y);
      bZ.Text := FloatToStr(GNSSSessions[Base].AppliedPos.Z);
      //T1.Text := GetTimeForRTKLib(GNSSSessions[Rover].StartTime);
      //T2.Text := GetTimeForRTKLib(GNSSSessions[Rover].EndTime);

      if Length(GNSSSessions[Rover].AdditionalFiles) > 0 then
      begin
        BitBtn1.Enabled := true;
        PageControl1.ActivePageIndex := 1;
      end;

      if Length(GNSSSessions[Base].AdditionalFiles) > 0 then
      begin
        BitBtn1.Enabled := true;
        if Label5.Caption = '' then
          Label5.Caption := GNSSSessions[Base].AdditionalFiles[0];

        if Label6.Caption = '' then
        if Length(GNSSSessions[Base].AdditionalFiles) > 1 then
          Label6.Caption := GNSSSessions[Base].AdditionalFiles[1];

        PageControl1.ActivePageIndex := 1;
      end;
    end;
    FLoadGPS.Close;
  end;

end;

procedure RefreshSessionList;
var I, N: Integer; s:string;
begin
  With Form1 Do
  Begin
    // SESSIONS
    SessionBox.Clear;
    for I := 0 to Length(GNSSSessions) - 1 do
      SessionBox.Items.Add(GNSSSessions[I].MaskName);

    SPropButton.Enabled := false;
    AllSessions.Enabled := SessionBox.Items.Count > 0;


    /// BASELINES
    BaseLinesBox.Items.Clear;
    for I := 0 to Length(GNSSVectors) - 1 do
    begin
      N := GetGNSSSessionNumber(GNSSVectors[I].BaseID);
      if N = -1 then
        continue;
      s:= GNSSSessions[N].MaskName;

      N := GetGNSSSessionNumber(GNSSVectors[I].RoverID);
      if N = -1 then
        continue;
       s:= s + ' -> '+GNSSSessions[N].MaskName;
       BaseLinesBox.Items.Add(s);
    end;
    VectorProp.Enabled := false;
    VectorProc.Enabled := false;

    /// POINTS
    PointBox.Clear;
    for I := 0 to Length(GNSSPoints) - 1 do
      PointBox.Items.Add(GNSSPoints[I].PointName);

    if GNSSDebug <> nil then
      if Memo1.Items.Count < GNSSDebug.Count then
         for I := Memo1.Items.Count to GNSSDebug.Count - 1 do
            Memo1.Items.Add(GNSSDebug[I]);

    Memo1.perform( WM_VSCROLL, SB_BOTTOM, 0 );
    Memo1.perform( WM_VSCROLL, SB_ENDSCROLL, 0 );
  End;

  
end;


procedure TForm1.Button2Click(Sender: TObject);
var I, j :Integer;
begin
  OpenDialog.Filter := 'Rinex Observations Files *.**o|*.??o';
  if OpenDialog.Execute() then
  begin
    FLoadGPS.Show;
    FLoadGps.Label3.Caption := 'Loading Obs File';   FLoadGps.Label3.Visible := true;
    FLoadGps.LCount.Caption := '';                   FLoadGps.LCount.Visible := true;
    j := SessionBox.Items.Count;

    for I := 0 to OpenDialog.Files.Count-1 do
     OpenRinex(OpenDialog.Files[I], FLoadGPS.ProgressBar1);

    FLoadGPS.close;
  end;

  RefreshSessionList;
  for I := 0 to SessionBox.Items.Count - 1 do
     SessionBox.Selected[I] := I >= j;
  SessionBoxDblClick(nil);
end;

procedure TForm1.Button3Click(Sender: TObject);
var I: Integer;
begin
  OpenDialog.Filter := 'Rinex Nav Files *.**g|*.??g';
  if OpenDialog.Execute() then
  begin
    I := Length(GNSSSessions[Rover].AdditionalFiles);
    SetLength(GNSSSessions[Rover].AdditionalFiles, I+1);
    GNSSSessions[Rover].AdditionalFiles[I] := OpenDialog.FileName;
    Label6.Caption := OpenDialog.FileName;
    BitBtn2.Enabled := true;
  end;

//  ExecuteWaitAndGetInfo('C:\Users\Satellite\Desktop\Разработки\Soft\RouteGNSS\RTKLIB\bin\rnx2rtkp.exe',' -?',Memo1);
end;

procedure TForm1.Button4Click(Sender: TObject);
var I:Integer;
begin
 // TerminateProcessByID(ProcInfo.dwProcessId);
//  StopRTKLib;
//  WaitStatus(false);
  OpenDialog.Filter := 'Rinex Nav Files *.**n|*.??n';
  if OpenDialog.Execute() then
  begin
    I := Length(GNSSSessions[Rover].AdditionalFiles);
    SetLength(GNSSSessions[Rover].AdditionalFiles, I+1);
    GNSSSessions[Rover].AdditionalFiles[I] := OpenDialog.FileName;
    Label5.Caption := OpenDialog.FileName;
    BitBtn2.Enabled := true;
  end;


end;

function ExecuteFile(const FileName, Params, DefaultDir: string; ShowCmd: Integer): THandle;
begin
  if fileexists(FileName) then
    Result := ShellExecute(Application.MainForm.Handle, nil, PChar(FileName), PChar(Params),
      PChar(DefaultDir), ShowCmd);
end;

procedure TForm1.Button5Click(Sender: TObject);
//const
//   CReadBuffer = 2400;
//var
//    pBuffer: array[0..CReadBuffer] of Char;
//    dRead: DWord;
begin
//    ReadFile(procTxt, pBuffer[0], CReadBuffer, dRead, nil);
//    pBuffer[dRead] := #0;
//
//    OemToAnsi(pBuffer, pBuffer);
//    Memo1.Lines.Add(String(pBuffer));
      Executefile(MyDir +'\Tmp\'+ResFile+'.txt','','',sw_show);

end;


function GetDosOutput(CommandLine: string; Work: string = ''): string;
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
begin
  Result := '';
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
      //dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
     // wShowWindow := SW_HIDE;
      hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect stdin
      hStdOutput := StdOutPipeWrite;
      hStdError := StdOutPipeWrite;
    end;
    WorkDir := Work;
    Handle := CreateProcess(nil, PChar('cmd.exe /C ' + CommandLine),
                            nil, nil, True, 0, nil,
                            PChar(WorkDir), SI, PI);

    CloseHandle(StdOutPipeWrite);
   // SendMessage(Form1.Memo1.Handle, EM_LINESCROLL, 0, Form1.Memo1.Lines.Count);
    if Handle then
      try
        repeat
          WasOK := ReadFile(StdOutPipeRead, Buffer, 255, BytesRead, nil);
          if BytesRead > 0 then
          begin
            Buffer[BytesRead] := #0;
            Result := Result + Buffer;
//            form1.Memo1.lines.Add(result);
          end;
//          form1.Memo1.lines.Add(result);
        until not WasOK or (BytesRead = 0);
        WaitForSingleObject(PI.hProcess, INFINITE);
//        form1.Memo1.lines.Add(result);
      finally
        CloseHandle(PI.hThread);
        CloseHandle(PI.hProcess);
//        form1.Memo1.lines.Add(result);
      end;
  finally
    CloseHandle(StdOutPipeRead);
  end;
end;


function ExecAndCapture(const ACmdLine ,s: string ): Boolean;
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

    WaitStatus(true);

    WorkDir := GetCurrentDir;
    Handle := CreateProcess(nil, PChar(ACmdLine),
                            nil, nil, True, 0, nil,
                            PChar(WorkDir), SI, PI);

    Application.ProcessMessages;
    ProcInfo := PI;

    CloseHandle(StdOutPipeWrite);
    if Handle then
      try
        repeat
          Application.ProcessMessages;
          WasOK := ReadFile(StdOutPipeRead, Buffer[0], 255, BytesRead, nil);
          if BytesRead > 0 then
          begin
            Buffer[BytesRead] := #0;
            AOutput := AOutput + string(Buffer);
          end;
//          form1.Memo1.lines.Add(Aoutput);
          Application.ProcessMessages;
          AOutput:= '';
        until not WasOK or (BytesRead = 0) ;
        WaitForSingleObject(PI.hProcess, INFINITE);
        Application.ProcessMessages;
      finally
        CloseHandle(PI.hThread);
        CloseHandle(PI.hProcess);
//        form1.Memo1.lines.Add(Aoutput);
      end;

    WaitStatus(false);
    Result := True;
  finally
    CloseHandle(StdOutPipeRead);
    WaitStatus(false);
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
var s:string;
begin
   //  GetDosOutput('C:\Users\Satellite\Desktop\Разработки\Soft\RouteGNSS\RTKLIB\bin\rnx2rtkp.exe -?', 'c:\');
   //  GetDosOutput('C:\Users\Satellite\Desktop\Разработки\Soft\RouteGNSS\Test_Utils\Test0\TestApp\test.exe', 'c:\') ;
    ExecAndCapture('C:\Users\Satellite\Desktop\Разработки\Soft\RouteGNSS\RTKLIB\bin\rnx2rtkp.exe -?', s);
end;

procedure TForm1.Button7Click(Sender: TObject);
var s:string;
begin
   ExecAndCapture('C:\Users\Satellite\Desktop\Разработки\Soft\RouteGNSS\Test_Utils\Test0\TestApp\test.exe', s);
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var S: TstringList;
begin
 // if ComboBox1.ItemIndex = -1 then
  //   exit;

 { S := TStringList.Create;
  S.LoadFromFile('times.txt');

  d1.Text :=  GetCols(S[ComboBox1.ItemIndex], 0, 1, ' ', false);
  t1.Text :=  GetCols(S[ComboBox1.ItemIndex], 1, 1, ' ', false);
  d2.Text :=  GetCols(S[ComboBox1.ItemIndex], 2, 1, ' ', false);
  t2.Text :=  GetCols(S[ComboBox1.ItemIndex], 3, 1, ' ', false);

  S.Free;   }
end;

procedure TForm1.Delete1Click(Sender: TObject);
var I :Integer;
begin
  For I := 0 To BaseLinesBox.Items.Count-1 Do
     if BaseLinesBox.Selected[I] then
       DisableGNSSVector(I);
       
  RefreshSessionList;

end;

procedure TForm1.DelSBtnClick(Sender: TObject);
var I:Integer;
begin
  For I := SessionBox.Items.Count-1 DownTo 0 Do
     if SessionBox.Selected[I] then
          DelGNSSSession(I);

  RefreshSessionList;
end;

procedure TForm1.Enable1Click(Sender: TObject);
var I :Integer;
begin
  For I := 0 To BaseLinesBox.Items.Count-1 Do
     if BaseLinesBox.Selected[I] then
       EnableGNSSVector(I);
       
  RefreshSessionList;
end;

procedure TForm1.Cb_GNSSSystemsChange(Sender: TObject);
begin
  case Cb_GNSSSystems.ItemIndex of
     0: begin
       gn1.Checked := true;    gn2.Checked := true;  gn3.Checked := true;
       gn4.Checked := true;    gn5.Checked := true;  gn6.Checked := true;
       gn7.Checked := true;
     end;
     1:  begin
       gn1.Checked := true;     gn2.Checked := false;  gn3.Checked := false;
       gn4.Checked := false;    gn5.Checked := false;  gn6.Checked := false;
       gn7.Checked := false;
     end;
     2:  begin
       gn1.Checked := true;     gn3.Checked := true;   gn2.Checked := false;
       gn4.Checked := false;    gn5.Checked := false;  gn6.Checked := false;
       gn7.Checked := false;
     end;
  end;
    Gb_GNSSSystems.Visible := Cb_GNSSSystems.ItemIndex = 3;
end;

procedure TForm1.RTKLibPathEdChange(Sender: TObject);
begin
  RTKLibDest := MyDir + RTKLibPathEd.Text;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    if GNSSDebug <> nil then
      if directoryexists(MyDir+'Logs\') then
        GNSSDebug.SaveToFile(MyDir+'Logs\GNSSLog.txt');
  except
  end;
  DestroyGNSSObjs;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 // ComboBox1.Items.LoadFromFile('paths.txt');
 // ComboBox1.ItemIndex := 0;
 MyDir := GetCurrentDir;

 if MyDir[Length(MyDir)-1] <> '\' then
     MyDir := MyDir + '\';

 RTKWorkDir := MyDir;

 InitRTKLIBPaths('Data\GNSS\Paths.loc');

 GeoInit('Data\Sources.loc', '', '');

 /// EGM08
 if Length(GeoidList)< 1 then
 begin
   SetLength(GeoidList, 1);
   ReloadGeoidByID('EGM2008', 0);
 end;


 if Fileexists(RTKLibDest )= false then
   RTKLibPathEd.OnChange(nil)
 else
   RTKLibPathEd.Text := RTKLibDest;

end;

procedure TForm1.Invert1Click(Sender: TObject);
var I :Integer;
begin
  For I := 0 To BaseLinesBox.Items.Count-1 Do
     if BaseLinesBox.Selected[I] then
       InvertGNSSVector(I);
       
  RefreshSessionList;
end;

procedure TForm1.Label3Click(Sender: TObject);
begin
  if Rover<> -1  then
     FGNSSSessionOptions.ShowGNSSSessionInfo(Rover, IcoList);

end;

procedure TForm1.Label4Click(Sender: TObject);
begin
  if Base<> -1  then
     FGNSSSessionOptions.ShowGNSSSessionInfo(Base, IcoList);
end;

procedure TForm1.SelectAll1Click(Sender: TObject);
begin
  BaselinesBox.SelectAll;
end;

procedure TForm1.SessionBoxClick(Sender: TObject);
var I:Integer;
begin
  SPropButton.Enabled := false;
  DelSBtn.Enabled := false;
  
  For I := 0 To SessionBox.Items.Count-1 Do
     if SessionBox.Selected[I] then
     begin
       SPropButton.Enabled := true;
       DelSBtn.Enabled := true;
       break;
     end;
end;

procedure TForm1.SessionBoxDblClick(Sender: TObject);
Var A:Array of Integer; Count, I:integer;
begin
  SetLength(A, 0);
  Count := 0;
  For I := 0 To SessionBox.Items.Count-1 Do
  begin
     if SessionBox.Selected[I] then
     begin
        SetLength(A, Count+1);
        A[Count] := I;
        Inc(Count);
     end;
  end;

  if Count = 0 then
    exit
  else if Count = 1 then
    FGNSSSessionOptions.ShowGNSSSessionInfo(A[0], IcoList)
  else
    FGNSSSessionOptions.ShowGNSSSessionInfo(A, IcoList);

  RefreshSessionList;
end;

procedure TForm1.SessionBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var IcoN:integer;
begin
 with (Control as TListBox).Canvas do
  begin

    try
        IcoN := GNSSSessions[Index].StatusQ;
    except
        IcoN := 0;
    end;

    IcoList.Draw((Control as TListBox).Canvas, Rect.Left, Rect.Top-1, IcoN+22);

    TextOut(Rect.Left + 20, Rect.Top, (Control as TListBox).Items[Index]);

    if odFocused In State then begin
      Brush.Color := (Control as TListBox).Color;
      DrawFocusRect(Rect);
    end;

  end;
end;

procedure TForm1.SessionBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_return then
     SessionBox.OnDblClick(nil);
end;

procedure TForm1.BaselinesBoxClick(Sender: TObject);
var I, Count, EnCount:Integer;
begin
  Count := 0;
  VectorProc.Enabled := false;
  For I := 0 To BaseLinesBox.Items.Count-1 Do
     if BaseLinesBox.Selected[I] then
     begin
       if GNSSVectors[I].StatusQ >= 0 then
         inc(EnCount);
       inc(Count);
     end;
  VectorProp.Enabled := Count = 1;
  VectorProc.Enabled := EnCount >= 1;
end;

procedure TForm1.BaselinesBoxDblClick(Sender: TObject);
var I, j:Integer;
    isNotProcessed: boolean;
begin

  j := 0;
  For I := 0 To BaseLinesBox.Items.Count-1 Do
  begin
     if BaseLinesBox.Selected[I] then
     begin
        inc(j);
        if j = 1 then
          isNotProcessed := GNSSVectors[I].StatusQ = 0;
     end;
  end;

  if (j = 1) and (not isNotProcessed) then
    VectorProp.Click
  else
    VectorProc.Click;
end;

procedure TForm1.BaselinesBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var IcoN:integer;
begin
inherited;
  with (Control as TListBox).Canvas do
  begin

    try
        IcoN := GNSSVectors[Index].StatusQ;
    except
        IcoN := 8;
    end;

    if IcoN < 0 then
       IcoN := -1
    else
    case icoN of
       0..2  : IcoN := IcoN;
       3..7  : IcoN := 3;
       8     : IcoN := 4;
       11..12: IcoN := IcoN - 6;
    end;


    IcoList.Draw((Control as TListBox).Canvas, Rect.Left, Rect.Top-1, IcoN+15);

    TextOut(Rect.Left + 20, Rect.Top, (Control as TListBox).Items[Index]);

    if odFocused In State then begin
      Brush.Color := (Control as TListBox).Color;
      DrawFocusRect(Rect);
    end;

  end;
end;

procedure TForm1.BaselinesBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_return then
     VectorProc.Click;
end;

procedure TForm1.Memo1Change(Sender: TObject);
//var I:Integer;
//    s:string;
//    DT: TDateTime;
begin
//  if Memo1.Lines.Count = 0 then
//    exit;
//  if Memo1.Lines[Memo1.Lines.Count-1] = RTKLogStart then
//    StatusLabel.Caption := 'Loading data...'
//  else
//  if Memo1.Lines[Memo1.Lines.Count-1] = RTKLogEnd then
//  begin
//    WaitStatus(false);
//    StatusLabel.Caption := 'Done!'
//  end
//  else
//  if Memo1.Lines[Memo1.Lines.Count-1] <> '' then
//    StatusLabel.Caption := 'Processing...'

end;

procedure TForm1.Memo1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  inherited;
  with (Control as TListBox).Canvas do
  begin
    if Index mod 2 = 0 then
      Brush.Color := clWhite
    else
      Brush.Color := $00F5F4F1;

    Font.Color := clBlack;

    if Pos('assigned', AnsiLowerCase((Control as TListBox).Items[Index])) > 0 then
       Font.Color  := clNavy;
    if Pos('refresh', AnsiLowerCase((Control as TListBox).Items[Index])) > 0 then
       Font.Color  := clNavy;
    if Pos('setting', AnsiLowerCase((Control as TListBox).Items[Index])) > 0 then
       Font.Color  := clNavy;

    if Pos('error', AnsiLowerCase((Control as TListBox).Items[Index])) > 0 then
       Font.Color  := clRed;

    if Pos('added', AnsiLowerCase((Control as TListBox).Items[Index])) > 0 then
       Font.Color  := clGreen;

    if Pos('delet', AnsiLowerCase((Control as TListBox).Items[Index])) > 0 then
       Font.Color  := clMaroon;

    if (Font.Color = clRed) or (Font.Color = clGreen) or
       (Pos('applying', AnsiLowerCase((Control as TListBox).Items[Index])) > 0) or
       (Pos('assign', AnsiLowerCase((Control as TListBox).Items[Index])) > 0)
    then
       Font.Style := Font.Style + [fsBold];

    if Pos('aborted', AnsiLowerCase((Control as TListBox).Items[Index])) > 0 then
       Font.Color  := clRed;
    if Pos('started', AnsiLowerCase((Control as TListBox).Items[Index])) > 0 then
       Font.Color  := clGreen;

    if odSelected in State then
    begin
      Brush.Color := clBlue;//$00FFD2A6;
      Font.Color  := clwhite;
    end;


    FillRect(Rect);

    TextOut(Rect.Left, Rect.Top, (Control as TListBox).Items[Index]);
    if odFocused In State then begin
      Brush.Color := Memo1.Color;
      DrawFocusRect(Rect);
    end;
  end;

end;

procedure TForm1.PointBoxClick(Sender: TObject);
begin
  StationProp.Enabled := PointBox.ItemIndex > -1;
end;

procedure TForm1.PointBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var IcoN:integer;
begin
inherited;
  with (Control as TListBox).Canvas do
  begin

    try
        IcoN := GNSSPoints[Index].Status;
        if not GNSSPoints[Index].Active then
          IcoN := 7;
    except
        IcoN := 8;
    end;

    //FillRect(Rect);
    IcoList.Draw((Control as TListBox).Canvas, Rect.Left, Rect.Top-2, IcoN+77);
    TextOut(Rect.Left + 20, Rect.Top, (Control as TListBox).Items[Index]);
    if odFocused In State then begin
      Brush.Color := (Control as TListBox).Color;
      DrawFocusRect(Rect);
    end;
  end;
end;

procedure TForm1.VectorPopupPopup(Sender: TObject);
var I:Integer;
    HasSelection, isEnabled, HideAll: Boolean;
begin
  HasSelection := false;
  HideAll := false;

  For I := 0 To BaseLinesBox.Items.Count-1 Do
     if BaseLinesBox.Selected[I] then
     begin
       if not HasSelection then
       begin
         isEnabled := GNSSVectors[I].StatusQ >= 0;
         HasSelection := true;
       end
       else
         if isEnabled <> (GNSSVectors[I].StatusQ >= 0) then
           HideAll := true;
     end;

  Enable1.Visible  := not HideAll and not isEnabled;
  Delete1.Visible := not HideAll and isEnabled;

  for I := 0 to VectorPopup.Items.Count - 1 do
      VectorPopup.Items[I].Visible := HasSelection;

  Enable1.Visible  := HasSelection and not HideAll and not isEnabled;
  Delete1.Visible :=  HasSelection and not HideAll and isEnabled;

  SelectAll1.Visible := not HasSelection;

 if BaselinesBox.Items.Count = 0 then
   SelectAll1.Visible := false;
end;

procedure TForm1.AllSessionsClick(Sender: TObject);
var I:Integer;
begin
 For I := 0 To SessionBox.Items.Count-1 Do
   SessionBox.Selected[I] := true;

 SessionBox.OnClick(nil);
end;

procedure TForm1.VectorPropClick(Sender: TObject);
var I :Integer;
begin
   For I := 0 To BaseLinesBox.Items.Count-1 Do
     if BaseLinesBox.Selected[I] then
     begin
       /// ToDo: Window of Vector's settings
       FVectSettings.ShowVectorProp(I, IcoList);
       RefreshSessionList;
       break;
     end;
end;

procedure TForm1.StationPropClick(Sender: TObject);
begin
  if PointBox.ItemIndex > -1 then
  begin
    FGNSSPointSettings.ShowStationOrTrack(PointBox.ItemIndex, IcoList);
    RefreshSessionList;
  end;
end;

procedure TForm1.VectorProcClick(Sender: TObject);
var I, j:Integer; A :Array of byte; B, C :Array of Integer;
begin
  SetLength(A, 0);  SetLength(B, 0);  SetLength(C, 0);
  For I := 0 To BaseLinesBox.Items.Count-1 Do
  begin
     if BaseLinesBox.Selected[I] then
     begin
        if GNSSVectors[I].StatusQ < 0 then
          continue;  // disabled vector

        j := Length(A);
        SetLength(A, j+1); SetLength(B, j+1);   SetLength(C, j+1);
        A[j] := 2;
        B[j] := GetGNSSSessionNumber(GNSSVectors[I].RoverId);
        C[j] := GetGNSSSessionNumber(GNSSVectors[I].BaseId);
     end;
  end;

  if Length(A) = 0 then
    exit
  else FStartProcessing.ShowMultiProcOptions(A,B,C);


  RefreshSessionList;
end;

end.
