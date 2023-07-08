unit UGNSSPointSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, GNSSObjects, ComCtrls, GeoString, ImgList,
  GNSSObjsTree, Menus;

type
  TFGNSSPointSettings = class(TForm)
    Image1: TImage;
    SessionLabel: TLabel;
    StatusLabel: TLabel;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    SolSrcBox: TComboBox;
    TreeView: TTreeView;
    isAc: TCheckBox;
    OKButton: TButton;
    CoordPan: TPanel;
    XLabel: TLabel;
    XEd: TEdit;
    YEd: TEdit;
    YLabel: TLabel;
    ZLabel: TLabel;
    ZEd: TEdit;
    isBS: TCheckBox;
    SolPC: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    SolPan: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    SessBox: TComboBox;
    SolBox: TComboBox;
    StatImg: TImage;
    SolPopup: TPopupMenu;
    View1: TMenuItem;
    SetasResult1: TMenuItem;
    Processagain1: TMenuItem;
    ProcessingReport1: TMenuItem;
    DeleteSolution1: TMenuItem;
    SessionPopup: TPopupMenu;
    Configure1: TMenuItem;
    AllSessions1: TMenuItem;
    DeleteSession1: TMenuItem;
    PointPopup: TPopupMenu;
    Sessionsof1: TMenuItem;
    procedure SessBoxChange(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure SolSrcBoxChange(Sender: TObject);
    procedure isBSClick(Sender: TObject);
    procedure isAcClick(Sender: TObject);
    procedure SolBoxChange(Sender: TObject);
    procedure TreeViewCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TreeViewDblClick(Sender: TObject);
    procedure TreeViewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Sessionsof1Click(Sender: TObject);
    procedure View1Click(Sender: TObject);
    procedure SetasResult1Click(Sender: TObject);
    procedure Processagain1Click(Sender: TObject);
    procedure DeleteSolution1Click(Sender: TObject);
    procedure Configure1Click(Sender: TObject);
    procedure DeleteSession1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ShowStationOrTrack(StatN:Integer; Img:TImageList);
    procedure TurnOnOffStation(N: Integer; isOn:Boolean);
    procedure RefreshPointSettings;
    { Public declarations }
  end;

var
  FGNSSPointSettings: TFGNSSPointSettings;
  StationN, SessionN:Integer;
  IsInit  :Boolean;
  ImgList :TImagelist;
  TreeInd :integer = -1;

  ChosenPoint, ChosenSession, ChosenSol :integer;
const
  StatList :Array[0..13] of String = ('Not Processed',
                                      'Has Fixed Solution',
                                      'Has Float Solution',
                                      'Has SBAS Solution',
                                      'Has DGPS Solution',
                                      'Has Single Solution',
                                      'Has PPP Solution',
                                      'Turned Off',
                                      'Error!',
                                      'Adjusted Single',
                                      'Adjusted Baselines (ok)',
                                      'Adjusted Baselines (poor)',
                                      'Adjusted PPP',
                                      'User-Defined (Reference)');
//  PointStatusColors: array [0..13] of TColor = (clGray, $0000FF80,
//          $0002EAFD, clFuchsia, clPurple, $006000FF, clTeal,clGray,
//          clRed, clOlive, $000080FF, clOlive, clYellow, clBlue);

implementation

uses UGNSSSessionOptions, Unit1, UStartProcessing;

{$R *.dfm}

procedure TFGNSSPointSettings.RefreshPointSettings;
var I, j:integer;
begin

    IsInit := true;
    SessionLabel.Caption := GNSSPoints[StationN].PointName;

    SessBox.Items.Clear;
    for I := 0 to Length(GNSSPoints[StationN].Sessions) - 1 do
    begin
      j := GetGNSSSessionNumber(GNSSPoints[StationN].Sessions[I]);
      SessionN := j;
      if j > -1 then
      begin
        SessBox.Items.Add(GNSSSessions[j].MaskName);
        if I = 0 then
        begin
          Image1.Visible := not GNSSSessions[j].isKinematic;
          Image3.Visible := (GNSSSessions[j].isKinematic) and not
                         (Length(GNSSSessions[j].Stops) >= 0);
          Image2.Visible := (GNSSSessions[j].isKinematic) and
                         (Length(GNSSSessions[j].Stops) >= 0);
        end;
      end
      else
        SessBox.Items.Add('[ERROR IN ID]: '+GNSSPoints[StationN].Sessions[I]);

    end;
    SessBox.ItemIndex := 0;
    SessBox.OnChange(nil);

    isBS.Checked := GNSSPoints[StationN].IsBase;
    CoordPan.Visible := Image1.Visible;

    SolSrcBox.ItemIndex := GNSSPoints[StationN].CoordSource;
    if GNSSPoints[StationN].CoordSource = 3 then
    begin
      SessBox.ItemIndex := GetGNSSSessionNumber(GNSSPoints[StationN].SolutionId.SessionId);
      SessBoxChange(nil);
      SolBox.ItemIndex  :=  GNSSPoints[StationN].SolutionId.SolutionN-1;
    end;

    if GNSSPoints[StationN].CoordSource = 3 then
      SolPC.ActivePageIndex := 1
    else
      SolPC.ActivePageIndex := 0;

    /// ToDo: Dependency on USER CS
    XEd.Text := FormatFloat('### ### ### ##0.000', GNSSPoints[StationN].Position.X);
    YEd.Text := FormatFloat('### ### ### ##0.000', GNSSPoints[StationN].Position.Y);
    ZEd.Text := FormatFloat('### ### ### ##0.000', GNSSPoints[StationN].Position.Z);

    XEd.ReadOnly := SolSrcBox.ItemIndex <> 4;
    YEd.ReadOnly := SolSrcBox.ItemIndex <> 4;
    ZEd.ReadOnly := SolSrcBox.ItemIndex <> 4;

    isAC.Checked := GNSSPoints[StationN].Active;

    if isAC.Checked = false then
      StatusLabel.Caption := StatList[7]
    else
      StatusLabel.Caption := StatList[GNSSPoints[StationN].Status];

    with StatImg.Canvas do
    begin
      Brush.Color := clBtnFace;
      Fillrect(Rect(0, 0, Width, Height));
      try
        I := GNSSPoints[StationN].Status;
        if GNSSPoints[StationN].Active = false then
          I := 7;
      except
        I := 8;
      end;
      ImgList.Draw(StatImg.Canvas, 0, 0, I+77);
    end;

    OutputGNSSObjTree(TreeView, StationN);

 IsInit := false;
end;


{ TFGNSSPointSettings }

procedure TFGNSSPointSettings.OKButtonClick(Sender: TObject);
var I :Integer;
begin
  /// ToDo: Apply XYZ
  // SolSrcBox.OnChange;

  if (SolSrcBox.ItemIndex = 4)  then
  begin
    SetGNSSPointUserCoords(StationN, StrToFloat2(Xed.Text),
        StrToFloat2(Yed.Text), StrToFloat2(Zed.Text) );
  end;

  if (isBS.Checked) and (SolSrcBox.ItemIndex = 4)  then
    for I := 0 to Length(GNSSPoints[StationN].Sessions)- 1 do
      CheckGNSSVectorsForSession(GNSSPoints[StationN].Sessions[I]);

  close;
end;

procedure TFGNSSPointSettings.Processagain1Click(Sender: TObject);
var N:Integer;
begin

     with GNSSSessions[ChosenSession] do
     case Solutions[ChosenSol].SolutionKind of
       1: FStartProcessing.ShowProcOptions(1, ChosenSession, -1);
       3: FStartProcessing.ShowProcOptions(3, ChosenSession, -1);
       2: begin
         N := GetGNSSSessionNumber(Solutions[ChosenSol].BaseID);
         if N<> -1 then
            FStartProcessing.ShowProcOptions(2, ChosenSession, N);
       end;
     end;
    RefreshPointSettings; 
end;

procedure TFGNSSPointSettings.Button1Click(Sender: TObject);
var F1 : TFGNSSSessionOptions;
begin
 F1 := TFGNSSSessionOptions.Create(nil);
 F1.ShowModal;
 F1.Release;
end;

procedure TFGNSSPointSettings.Configure1Click(Sender: TObject);
var F : TFGNSSSessionOptions;
begin
  if ChosenSession > -1 then
  begin
     F := TFGNSSSessionOptions.Create(nil);
     F.ShowGNSSSessionInfo(ChosenSession, Form1.IcoList);
     F.Release;
  end;
  RefreshPointSettings;
end;

procedure TFGNSSPointSettings.DeleteSession1Click(Sender: TObject);
var I:Integer;
    finalSession:Boolean;
begin

  finalSession := Length(GNSSPoints[StationN].Sessions) <= 1;

  if ChosenSession > -1 then
    DelGNSSSession(ChosenSession);

  for I := 0 to Application.ComponentCount - 1  do
  Begin
    if Pos(Application.Components[I].Name, 'FGNSSSessionOptions') > 0 then
      with Application.Components[I] as TForm Do
        close;
  End;

  if not finalSession then
    RefreshPointSettings
  else
    close;
end;

procedure TFGNSSPointSettings.DeleteSolution1Click(Sender: TObject);
begin
  DeleteGNSSSolution(ChosenSession, ChosenSol);
  RefreshPointSettings;
end;

procedure TFGNSSPointSettings.FormShow(Sender: TObject);
begin
  RefreshPointSettings;
  PointPopup.Images := Treeview.Images;
  SessionPopup.Images := Treeview.Images;
  SolPopup.Images := Treeview.Images;
end;

procedure TFGNSSPointSettings.isAcClick(Sender: TObject);
var I, j, N :Integer; WarnMe:boolean;
begin
 if isInit then
    exit;
 TurnOnOffStation(StationN, isAc.Checked);
//  WarnMe := false;
//
//  for I := 0 to Length(GNSSPoints[StationN].Sessions)- 1 do
//  begin
//      for j := 0 to Length(GNSSVectors) - 1 do
//         if ((GNSSVectors[j].RoverID = GNSSPoints[StationN].Sessions[I]) or
//             (GNSSVectors[j].BaseID = GNSSPoints[StationN].Sessions[I]))
//            and (GNSSVectors[j].StatusQ <> 0) then
//            begin
//              WarnMe := true;
//              break
//            end;
//      if WarnMe then
//        break;
//  end;
//
//
//  if WarnMe then
//  if messagedlg('This may change the other stations. Proceed?',    // Todo : TRANSLATE
//        mtConfirmation, [mbYes, mbNo], 0)<> 6 then
//  begin
//    isInit := true;
//    isAc.Checked := not isAc.Checked;
//    isInit := false;
//    exit;
//  end;
//
//  GNSSPoints[StationN].Active := isAC.Checked;
//  if GNSSPoints[StationN].Active then
//    DebugMSG('Setting Station: '+ GNSSPoints[StationN].PointName +' turned ON')
//  else
//    DebugMSG('Setting Station: '+ GNSSPoints[StationN].PointName +' turned OFF');
//
//  for I := 0 to Length(GNSSPoints[StationN].Sessions)- 1 do
//  begin
//    if GNSSPoints[StationN].Active then
//      AddGNSSVectorsForSession(GNSSPoints[StationN].Sessions[I])
//    else
//      DelGNSSVectorsForSession(GNSSPoints[StationN].Sessions[I]);
//  end;

  RefreshPointSettings;
end;

procedure TFGNSSPointSettings.isBSClick(Sender: TObject);
var I, j, N :Integer; WarnMe:boolean;
begin
 if isInit then
    exit;

  WarnMe := false;

  for I := 0 to Length(GNSSPoints[StationN].Sessions)- 1 do
  begin
      for j := 0 to Length(GNSSVectors) - 1 do
         if ((GNSSVectors[j].RoverID = GNSSPoints[StationN].Sessions[I]) or
            (GNSSVectors[j].BaseID = GNSSPoints[StationN].Sessions[I]))
            and (GNSSVectors[j].StatusQ > 0) then
            begin
              WarnMe := true;
              break
            end;
      if WarnMe then
        break;
  end;


  if WarnMe then
  if messagedlg('This may change the other stations. Proceed?',    // Todo : TRANSLATE
        mtConfirmation, [mbYes, mbNo], 0)<> 6 then
  begin
    isInit := true;
    isBS.Checked := not isBS.Checked;
    isInit := false;
    exit;
  end;

  GNSSPoints[StationN].IsBase := isBS.Checked;

  if GNSSPoints[StationN].IsBase then
    DebugMSG('Setting AS BASE Station: '+ GNSSPoints[StationN].PointName)
  else
    DebugMSG('Setting as regular Station: '+ GNSSPoints[StationN].PointName);

  for I := 0 to Length(GNSSPoints[StationN].Sessions)- 1 do
    CheckGNSSVectorsForSession(GNSSPoints[StationN].Sessions[I]);


  if (isBS.Checked) and (GNSSPoints[StationN].CoordSource <> 4) then
     if messagedlg('Set the station coordinates as reference?',    // Todo : TRANSLATE
        mtConfirmation, [mbYes, mbNo], 0)= 6 then
     begin
       SolSrcBox.ItemIndex := 4;
       SolSrcBoxChange(nil)
     end;


  RefreshPointSettings;
end;

procedure TFGNSSPointSettings.SessBoxChange(Sender: TObject);
var I, j:Integer; s:string;
begin
   SolBox.Items.Clear;

   if SessBox.ItemIndex < 0 then
     exit;

   j := GetGNSSSessionNumber(GNSSPoints[StationN].Sessions[SessBox.ItemIndex]);
   if j > -1 then
     for I := 1 to length(GNSSSessions[j].Solutions) - 1 do
     begin
       case GNSSSessions[j].Solutions[I].SolutionKind of           // Todo : TRANSLATE
          0: s := 'RINEX Approx position';
          1: s := 'Single solution';
          2: s := GNSSSessions[GetGNSSSessionNumber(
                     GNSSSessions[j].Solutions[I].BaseID)].MaskName
                     + ' -> ' + GNSSSessions[j].MaskName;
          3: s := 'PPP solution';
        end;
        SolBox.Items.Add(s);
     end;
  //SolBox.ItemIndex := 0;
end;

procedure TFGNSSPointSettings.Sessionsof1Click(Sender: TObject);
var A:Array of Integer;
    F : TFGNSSSessionOptions;
    I : Integer;
begin
  ChosenPoint := StationN;
  if ChosenPoint < 0 then
    exit;

  SetLength(A, Length(GNSSPoints[ChosenPoint].Sessions));
  for I := 0 to Length(GNSSPoints[ChosenPoint].Sessions)-1 do
     A[I] := GetGNSSSessionNumber(GNSSPoints[ChosenPoint].Sessions[I]);

  if Length(A) = 0 then
    exit;

  if Length(A) > 0 then
  begin
    F := TFGNSSSessionOptions.Create(nil);
    F.ShowGNSSSessionInfo(A, Form1.IcoList);
    F.Release;
  end;

  RefreshPointSettings;
end;

procedure TFGNSSPointSettings.SetasResult1Click(Sender: TObject);
begin
  ChosenPoint := StationN;
  GNSSPoints[ChosenPoint].CoordSource := 3;
  GNSSPoints[ChosenPoint].SolutionId.SessionId := GNSSSessions[ChosenSession].SessionID;
  GNSSPoints[ChosenPoint].SolutionId.SolutionN := ChosenSol;
  RefreshPointSettings;
end;

procedure TFGNSSPointSettings.ShowStationOrTrack(StatN: Integer; Img:TImageList);
var I, j :Integer;
begin
 StationN := StatN;
 ImgList := Img;
 TreeView.Images := Img;
 RefreshPointSettings;
 ShowModal;
end;

procedure TFGNSSPointSettings.SolBoxChange(Sender: TObject);
begin
  if isInit then
    exit;

end;

procedure TFGNSSPointSettings.SolSrcBoxChange(Sender: TObject);
var I, j, N :Integer; WarnMe:boolean;
    MySolId: TSolutionId;  SessN:integer;
begin
  if isInit then
    exit;

  if (SolSrcBox.ItemIndex = GNSSPoints[StationN].CoordSource) and
     (SolSrcBox.ItemIndex <> 3) then
    exit;

  WarnMe := false;

  for I := 0 to Length(GNSSPoints[StationN].Sessions)- 1 do
  begin
      for j := 0 to Length(GNSSVectors) - 1 do
         if (GNSSVectors[j].BaseID = GNSSPoints[StationN].Sessions[I])
            and (GNSSVectors[j].StatusQ > 0) then
            begin
              WarnMe := true;
              break
            end;
      if WarnMe then
        break;
  end;

  if WarnMe then
  if messagedlg('This may change the other stations. Proceed?',    // Todo : TRANSLATE
        mtConfirmation, [mbYes, mbNo], 0)<> 6 then
  begin
    isInit := true;
    SolSrcBox.ItemIndex := GNSSPoints[StationN].CoordSource;
    if GNSSPoints[StationN].CoordSource = 3 then
    begin
        SessBox.ItemIndex := GetGNSSSessionNumber(GNSSPoints[StationN].SolutionId.SessionId);
        SolBox.ItemIndex  :=  GNSSPoints[StationN].SolutionId.SolutionN-1;
    end;
    isInit := false;

    if GNSSPoints[StationN].CoordSource = 3 then
      SolPC.ActivePageIndex := 1
    else
      SolPC.ActivePageIndex := 0;
      
    exit;
  end;

  if SolSrcBox.ItemIndex <> 3 then
  begin
    MySolId.SessionId := '';
    MySolId.SolutionN := 0;
    SessN := -1;
  end
  else
  begin
    SessN :=-1;
    if SessBox.ItemIndex = -1 then MySolId.SessionId := ''
      else begin
        MySolId.SessionId := GNSSPoints[StationN].Sessions[SessBox.ItemIndex];
        MySolId.SolutionN := SolBox.ItemIndex + 1;
        SessN := GetGNSSSessionNumber(MySolId.SessionId)
      end;
  end;

  if (SolSrcBox.ItemIndex = 3) and  (SessN = -1) then
    exit;

  if (GNSSPoints[StationN].CoordSource <> SolSrcBox.ItemIndex) or
     (GNSSPoints[StationN].CoordSource = 3) and (SolSrcBox.ItemIndex = 3) and
     ( (GNSSPoints[StationN].SolutionId.SessionId <> MySolId.SessionId) or
       (GNSSPoints[StationN].SolutionId.SolutionN <> MySolId.SolutionN) ) then
    SetGNSSPointSource(StationN, SolSrcBox.ItemIndex, SessN, MySolId.SolutionN);

  if GNSSPoints[StationN].CoordSource = 3 then
      SolPC.ActivePageIndex := 1
    else
      SolPC.ActivePageIndex := 0;
  XEd.ReadOnly := SolSrcBox.ItemIndex <> 4;
  YEd.ReadOnly := SolSrcBox.ItemIndex <> 4;
  ZEd.ReadOnly := SolSrcBox.ItemIndex <> 4;

  if GNSSPoints[StationN].CoordSource = 4 then
  begin
    GNSSPoints[StationN].Status := 13;
    if not isBS.Checked then
    If messagedlg('Use the Point as a Base Station?',    // Todo : TRANSLATE
        mtConfirmation, [mbYes, mbNo], 0) = 6 then
          isBS.Checked := true;
  end;

  RefreshPointSettings;
end;

procedure TFGNSSPointSettings.TreeViewCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  case Node.ImageIndex  of
    0, 14, 17, 36, 37, 44, 71, 84, 22..35: Sender.Canvas.Font.Color := clGray;
    8, 19, 70, 85 : Sender.Canvas.Font.Color := clMaroon;
    90, 72 : Sender.Canvas.Font.Color := clNavy;
  end;
  case Node.ImageIndex  of
    38..43, 70..76 : if not (fsUnderLine in Sender.Canvas.Font.Style) then
      Sender.Canvas.Font.Style := Sender.Canvas.Font.Style + [fsUnderline];
  end;
  if Node.Level = 0 then if not (fsBold in Sender.Canvas.Font.Style) then
     Sender.Canvas.Font.Style := Sender.Canvas.Font.Style + [fsBold];

end;

procedure TFGNSSPointSettings.TreeViewDblClick(Sender: TObject);
begin
   if ChosenSol > -1 then
   begin
     View1Click(nil);
   end
   else if ChosenSession > -1 then
   begin
     Configure1Click(nil);
   end
end;

procedure TFGNSSPointSettings.TreeViewMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var  TreeNode, ParentNode, ParentNode2 : TTreeNode;
     P : TPoint;
begin
  TreeNode := TreeView.GetNodeAt(X, Y);
  if Assigned(TreeNode) then
    TreeNode.Selected := True;
  if not Assigned(TreeNode) then
    exit;

  P := Mouse.CursorPos;

  ChosenPoint   := -1;
  ChosenSession := -1;
  ChosenSol     := -1;

  Case TreeNode.Level of
    0: ChosenPoint := GetGNSSPointNumber(TreeNode.Text);

    1:
    begin
      ParentNode  := TreeNode.Parent;
      ChosenPoint := GetGNSSPointNumber(ParentNode.Text);
      if TreeNode.Index < length(GNSSPoints[ChosenPoint].Sessions)  then
        ChosenSession := GetGNSSSessionNumber(GNSSPoints[ChosenPoint].
                   Sessions[TreeNode.Index]);
    end;

    2:
    begin
      ChosenSol   := TreeNode.Index + 1;
      ParentNode  := TreeNode.Parent;
      ParentNode2 := ParentNode.Parent;
      ChosenPoint := GetGNSSPointNumber(ParentNode2.Text);

      if ParentNode.Index < length(GNSSPoints[ChosenPoint].Sessions)  then
        ChosenSession := GetGNSSSessionNumber(GNSSPoints[ChosenPoint].
                   Sessions[ParentNode.Index]);
    end;

  End;

  if Button = mbRight then
  begin
      if TreeNode.Level = 0 then
      begin
        PointPopup.Items[0].Visible := Length(GNSSPoints[ChosenPoint].Sessions) > 1;
      end;

      if TreeNode.Level = 1 then
      begin
        if TreeNode.Index < length(GNSSPoints[ChosenPoint].Sessions)  then
        begin
          SessionPopup.Items[0].Caption := Copy(PointPopup.Items[0].Caption, 1,
                     Pos(' ', PointPopup.Items[0].Caption) ) + TreeNode.Text;
          SessionPopup.Items[0].ImageIndex := TreeNode.ImageIndex;
          SessionPopup.Items[1].Visible := Length(GNSSPoints[ChosenPoint].Sessions) > 1;
          SessionPopup.Popup(P.x, P.y);
        end
        else
        begin
          PointPopup.Items[0].Caption := Copy(PointPopup.Items[0].Caption, 1,
                     Pos(' ', PointPopup.Items[0].Caption) ) + ParentNode.Text;
          PointPopup.Items[0].ImageIndex := ParentNode.ImageIndex;
          PointPopup.Popup(P.x, P.y);
        end;

      end;

      if TreeNode.Level = 2 then
      begin
        SolPopup.Items[0].ImageIndex := TreeNode.ImageIndex;
        SolPopup.Popup(P.x, P.y);
      end;

    end;




//  ChosenPoint := PointN;

end;

procedure TFGNSSPointSettings.TurnOnOffStation(N: Integer; isOn:Boolean);
var I, j :Integer; WarnMe:boolean;
begin
 if isInit then
    exit;

  WarnMe := false;

  for I := 0 to Length(GNSSPoints[N].Sessions)- 1 do
  begin
      for j := 0 to Length(GNSSVectors) - 1 do
         if ((GNSSVectors[j].RoverID = GNSSPoints[N].Sessions[I]) or
             (GNSSVectors[j].BaseID = GNSSPoints[N].Sessions[I]))
            and (GNSSVectors[j].StatusQ <> 0) then
            begin
              WarnMe := true;
              break
            end;
      if WarnMe then
        break;
  end;


  if WarnMe then
  if messagedlg('This may change the other stations. Proceed?',    // Todo : TRANSLATE
        mtConfirmation, [mbYes, mbNo], 0)<> 6 then
    exit;

  GNSSPoints[N].Active := isON;
  if GNSSPoints[N].Active then
    DebugMSG('Setting Station: '+ GNSSPoints[N].PointName +' turned ON')
  else
    DebugMSG('Setting Station: '+ GNSSPoints[N].PointName +' turned OFF');

  for I := 0 to Length(GNSSPoints[N].Sessions)- 1 do
  begin
    if GNSSPoints[N].Active then
      AddGNSSVectorsForSession(GNSSPoints[N].Sessions[I])
    else
      DelGNSSVectorsForSession(GNSSPoints[N].Sessions[I]);
  end;
end;

procedure TFGNSSPointSettings.View1Click(Sender: TObject);
var F : TFGNSSSessionOptions;
begin
  F := TFGNSSSessionOptions.Create(nil);
  if ChosenSession > -1 then
    F.ShowGNSSSessionInfo(ChosenSession, Form1.IcoList, ChosenSol);
  F.Release;
  RefreshPointSettings;
end;

end.
