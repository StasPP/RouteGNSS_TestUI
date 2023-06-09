unit UGNSSMainTree;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, ComCtrls, GNSSObjsTree, GNSSObjects,
  Menus;

type
  TFMainTree = class(TForm)
    DataCat: TComboBox;
    BtnPan: TPanel;
    ImprortRIN: TSpeedButton;
    MainPan: TPanel;
    TreeView: TTreeView;
    OpenDialog: TOpenDialog;
    VectorPopup: TPopupMenu;
    Settings1: TMenuItem;
    Invert1: TMenuItem;
    Delete1: TMenuItem;
    Enable1: TMenuItem;
    Process1: TMenuItem;
    PointPopup: TPopupMenu;
    SessionPopup: TPopupMenu;
    SolPopup: TPopupMenu;
    ConfigurePoint1: TMenuItem;
    Sessionsof1: TMenuItem;
    Configure1: TMenuItem;
    DeleteSession1: TMenuItem;
    View1: TMenuItem;
    SetasResult1: TMenuItem;
    DeleteSolution1: TMenuItem;
    ProcessingReport1: TMenuItem;
    Processagain1: TMenuItem;
    AdjPopup: TPopupMenu;
    Adjustmentsettings1: TMenuItem;
    DeletePoint1: TMenuItem;
    AllSessions1: TMenuItem;
    Report1: TMenuItem;
    urnOff1: TMenuItem;
    urnON1: TMenuItem;
    procedure ImprortRINClick(Sender: TObject);
    procedure DataCatDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TreeViewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TreeViewContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure DataCatChange(Sender: TObject);
    procedure ConfigurePoint1Click(Sender: TObject);
    procedure Sessionsof1Click(Sender: TObject);
    procedure TreeViewDblClick(Sender: TObject);
    procedure Configure1Click(Sender: TObject);
    procedure TreeViewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure View1Click(Sender: TObject);
    procedure DeletePoint1Click(Sender: TObject);
    procedure DeleteSession1Click(Sender: TObject);
    procedure DeleteSolution1Click(Sender: TObject);
    procedure Processagain1Click(Sender: TObject);
    procedure SetasResult1Click(Sender: TObject);
    procedure TreeViewCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure Settings1Click(Sender: TObject);
    procedure Process1Click(Sender: TObject);
    procedure Invert1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Enable1Click(Sender: TObject);
    procedure urnOff1Click(Sender: TObject);
    procedure urnON1Click(Sender: TObject);
  private
    { Private declarations }
  public
    ImgList :TImageList;
    { Public declarations }
  end;

var
  FMainTree: TFMainTree;
  ChosenPoint, ChosenSession, ChosenSol, ChosenVect, ChosenVG :integer;
implementation

uses FLoader, Unit1, UGNSSSessionOptions, UGNSSPointSettings, UStartProcessing,
  UVectSettings;

{$R *.dfm}

procedure ExpandEdited;
var I, j : integer;
    ParentNode : TTreeNode;
begin
    if (ChosenPoint >= Length(GNSSPoints)) or (ChosenPoint < 0) or
       (ChosenSession >= Length(GNSSSessions)) or (ChosenSession < 0) then
      exit;

    if FMainTree.DataCat.ItemIndex = 0 then
    if ChosenSol > -1 then
    for I := 0 to FMainTree.TreeView.Items.count - 1 do
    begin
      if (FMainTree.TreeView.Items[I].Level = 1) then
      begin
        ParentNode := FMainTree.TreeView.Items[I].Parent;
        if (FMainTree.TreeView.Items[I].Text =
            GNSSSessions[ChosenSession].MaskName) and
           (ParentNode.Text = GNSSSessions[ChosenSession].Station)
        then
          FMainTree.TreeView.Items[I].Expand(false);
      end;
    end;
    

end;

procedure MainTreeDraw;
begin
  case FMainTree.DataCat.ItemIndex of
    0: OutputGNSSObjTree(FMainTree.TreeView, -1);
    1: OutputGNSSVectTree(FMainTree.TreeView)
  end;
  Form1.ShowDebugLog;
  ExpandEdited;
end;

procedure TFMainTree.Configure1Click(Sender: TObject);
begin
  if ChosenSession > -1 then
    FGNSSSessionOptions.ShowGNSSSessionInfo(ChosenSession, Form1.IcoList);
  MainTreeDraw;
end;

procedure TFMainTree.ConfigurePoint1Click(Sender: TObject);
begin
  if ChosenPoint > -1 then
  begin
    FGNSSPointSettings.ShowStationOrTrack(ChosenPoint, Form1.IcoList);
    MainTreeDraw;
  end;
end;

procedure TFMainTree.DataCatChange(Sender: TObject);
begin
   MainTreeDraw;
end;

procedure TFMainTree.DataCatDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  ComboBox: TComboBox;
  bitmap: TBitmap;
  I: Integer;
begin
  ComboBox := (Control as TComboBox);
  Bitmap := TBitmap.Create;
  try
    case Index of
       0: I := 78;
       1: I := 16;
    end;
    TreeView.Images.GetBitmap(I, Bitmap);
    with ComboBox.Canvas do
    begin

      if Bitmap.Handle <> 0 then
      begin
        Bitmap.Transparent := true;
        Draw(Rect.Left, Rect.Top, Bitmap);
        Rect := Bounds(Rect.Left + Bitmap.Width, Rect.Top,
                     Rect.Right - Rect.Left -Bitmap.Width, Rect.Bottom - Rect.Top);
      end;
      FillRect(Rect);


      DrawText(handle, PChar(ComboBox.Items[Index]), length(ComboBox.Items[index]), Rect, DT_VCENTER+DT_SINGLELINE);
    end;
  finally
    Bitmap.Free;
  end;
end;

procedure TFMainTree.Delete1Click(Sender: TObject);
begin
  DisableGNSSVector(ChosenVect);
  MainTreeDraw;
end;

procedure TFMainTree.DeletePoint1Click(Sender: TObject);
var I:Integer;
begin
  if ChosenPoint > -1 then
    for I := Length(GNSSPoints[ChosenPoint].Sessions)-1 Downto 0 do
      DelGNSSSession(GNSSPoints[ChosenPoint].Sessions[I]);
  MainTreeDraw;
end;

procedure TFMainTree.DeleteSession1Click(Sender: TObject);
begin
  if ChosenSession > -1 then
    DelGNSSSession(ChosenSession);
  MainTreeDraw;
end;

procedure TFMainTree.DeleteSolution1Click(Sender: TObject);
begin
  DeleteGNSSSolution(ChosenSession, ChosenSol);
  MainTreeDraw;
end;

procedure TFMainTree.Enable1Click(Sender: TObject);
begin
  EnableGNSSVector(ChosenVect);
  MainTreeDraw;
end;

procedure TFMainTree.FormActivate(Sender: TObject);
begin
  Form1.ShowDebugLog;
end;

procedure TFMainTree.FormShow(Sender: TObject);
begin
  Form1.ShowDebugLog;
  PointPopup.Images := Treeview.Images;
  SessionPopup.Images := Treeview.Images;
  SolPopup.Images := Treeview.Images;
  VectorPopup.Images := Treeview.Images;
end;

procedure ShowNewSessions(FromI:Integer);
  Var A:Array of Integer; I:integer;
begin
  I := Length(GNSSSessions);
  if I <= FromI then
    exit;

  SetLength(A, I-FromI);

  For I := FromI To Length(GNSSSessions)-1 Do
  begin
     A[I-FromI] := I;
  end;

  if Length(A) = 1 then
    FGNSSSessionOptions.ShowGNSSSessionInfo(A[0], Form1.IcoList)
  else
    FGNSSSessionOptions.ShowGNSSSessionInfo(A, Form1.IcoList);

  MainTreeDraw;
end;

procedure TFMainTree.ImprortRINClick(Sender: TObject);
var I, j :Integer;
begin
  OpenDialog.Filter := 'Rinex Observations Files *.**o|*.??o';
  if OpenDialog.Execute() then
  begin
    FLoadGPS.Show;
    FLoadGps.Label3.Caption := 'Loading Obs File';   FLoadGps.Label3.Visible := true;
    FLoadGps.LCount.Caption := '';                   FLoadGps.LCount.Visible := true;

    j := Length(GNSSSessions);

    for I := 0 to OpenDialog.Files.Count-1 do
     OpenRinex(OpenDialog.Files[I], FLoadGPS.ProgressBar1);

    FLoadGPS.close;
    MainTreeDraw;
    ShowNewSessions(j);
  end;

  MainTreeDraw;
end;

procedure TFMainTree.Invert1Click(Sender: TObject);
begin
  InvertGNSSVector(ChosenVect);
  MainTreeDraw;
end;

procedure TFMainTree.Process1Click(Sender: TObject);
var I, j:Integer; A :Array of byte; B, C :Array of Integer;
begin
  SetLength(A, 0);  SetLength(B, 0);  SetLength(C, 0);

  if ChosenVG = -1 then
  begin
     FStartProcessing.ShowProcOptions(2,
          GetGNSSSessionNumber(GNSSVectors[ChosenVect].RoverID),
          GetGNSSSessionNumber(GNSSVectors[ChosenVect].BaseID));
     MainTreeDraw;     
     exit;
  end
  else
  For I := 0 To Length(VectGroups[ChosenVG].Vects) -1 Do
  begin
    if GNSSVectors[VectGroups[ChosenVG].Vects[I]].StatusQ < 0 then
      continue;  // disabled vector

    j := Length(A);
    SetLength(A, j+1); SetLength(B, j+1);   SetLength(C, j+1);
    A[j] := 2;
    B[j] := GetGNSSSessionNumber(GNSSVectors[VectGroups[ChosenVG].Vects[I]].RoverId);
    C[j] := GetGNSSSessionNumber(GNSSVectors[VectGroups[ChosenVG].Vects[I]].BaseId);
  end;

  if Length(A) = 0 then
    exit
  else FStartProcessing.ShowMultiProcOptions(A,B,C);

  MainTreeDraw;
end;

procedure TFMainTree.Processagain1Click(Sender: TObject);
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
     MainTreeDraw;
end;

procedure TFMainTree.Sessionsof1Click(Sender: TObject);
var I :Integer;
    A :Array of Integer;
begin
  if ChosenPoint < 0 then
    exit;

  SetLength(A, Length(GNSSPoints[ChosenPoint].Sessions));
  for I := 0 to Length(GNSSPoints[ChosenPoint].Sessions)-1 do
     A[I] := GetGNSSSessionNumber(GNSSPoints[ChosenPoint].Sessions[I]);

  if Length(A) = 0 then
    exit;

  if Length(A) = 1 then
    FGNSSSessionOptions.ShowGNSSSessionInfo(A[0], Form1.IcoList)
  else
    FGNSSSessionOptions.ShowGNSSSessionInfo(A, Form1.IcoList);

  MainTreeDraw;
end;

procedure TFMainTree.SetasResult1Click(Sender: TObject);
var WarnMe : boolean; I,j :Integer;
begin

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
    exit;

  GNSSPoints[ChosenPoint].CoordSource := 3;
  GNSSPoints[ChosenPoint].SolutionId.SessionId := GNSSSessions[ChosenSession].SessionID;
  GNSSPoints[ChosenPoint].SolutionId.SolutionN := ChosenSol;
  SetGNSSPointSource(StationN, 3, ChosenSession, ChosenSol);
  MainTreeDraw;
end;

procedure TFMainTree.Settings1Click(Sender: TObject);
begin
  FVectSettings.ShowVectorProp(ChosenVect, Form1.IcoList);
  MainTreeDraw;
end;

procedure TFMainTree.TreeViewContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var  TreeNode : TTreeNode;
begin
  TreeNode := TreeView.GetNodeAt(MousePos.X, MousePos.Y);
  if Assigned(TreeNode) then
    TreeNode.Selected := True;
end;

procedure TFMainTree.TreeViewCustomDrawItem(Sender: TCustomTreeView;
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

procedure TFMainTree.TreeViewDblClick(Sender: TObject);
begin
   case DataCat.ItemIndex of
      0:  if ChosenSol > -1 then
   begin
     View1Click(nil);
   end
   else if ChosenSession > -1 then
   begin
     Configure1Click(nil);
   end
   else if ChosenPoint > -1 then
     ConfigurePoint1Click(nil);

      1:  Settings1Click(nil)
   end;
  
end;

procedure TFMainTree.TreeViewMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var  TreeNode: TTreeNode;
begin
  {if TreeView.Focused then
  begin
    TreeNode := TreeView.GetNodeAt(X, Y);
    if Assigned(TreeNode) then
    begin
      TreeNode.Selected := True;
      TreeView.Cursor := crHandPoint;
    end else
    TreeView.Cursor := crDefault;
  end
  else
    TreeView.Cursor := crDefault; }
end;

procedure TFMainTree.TreeViewMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
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
  ChosenVect    := -1;
  ChosenVG      := -1;

  if DataCat.ItemIndex = 0 then
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

  End ELSE
  if DataCat.ItemIndex = 1 then
  Case TreeNode.Level of
    0: begin
      ChosenVG := TreeNode.Index;
      try
        ChosenVect := VectGroups[ChosenVG].Vects[0];
      except
        ChosenVect := -1;
      end;
    end;
    1:
    begin
      try
        ParentNode  := TreeNode.Parent;
        ChosenVect := VectGroups[ParentNode.Index].Vects[TreeNode.Index];
      except
        ChosenVect := -1;
      end;
    end;
  End;

  if Button = mbRight then
  case DataCat.ItemIndex of
    0: /// Points/Tracks
    begin
      if TreeNode.Level = 0 then
      begin
        PointPopup.Items[0].Caption := Copy(PointPopup.Items[0].Caption, 1,
                     Pos(' ', PointPopup.Items[0].Caption) ) + TreeNode.Text;
        PointPopup.Items[0].ImageIndex := TreeNode.ImageIndex;
        PointPopup.Items[1].Visible := Length(GNSSPoints[ChosenPoint].Sessions) > 1;
        PointPopup.Items[2].Visible := GNSSPoints[ChosenPoint].Active;
        PointPopup.Items[3].Visible := not GNSSPoints[ChosenPoint].Active;
        PointPopup.Popup(P.x, P.y);
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

    1: /// Vectors
    begin
      if (TreeNode.Level = 0) or (TreeNode.Level = 1) then
      begin
        VectorPopup.Items[0].Caption := Copy(PointPopup.Items[0].Caption, 1,
                     Pos(' ', PointPopup.Items[0].Caption) ) + TreeNode.Text;
        VectorPopup.Items[0].ImageIndex := TreeNode.ImageIndex;

        VectorPopup.Items[4].Visible := (ChosenVG = -1) and
              (GNSSVectors[ChosenVect].StatusQ >= 0);
        VectorPopup.Items[5].Visible := (ChosenVG = -1) and
              (GNSSVectors[ChosenVect].StatusQ < 0);
        
        if (ChosenVG > -1) and (VectGroups[ChosenVG].StatQ > 0)
          or (ChosenVG = -1) and (GNSSVectors[ChosenVect].StatusQ > 0) then
          VectorPopup.Items[1].ImageIndex := 92
        else
          VectorPopup.Items[1].ImageIndex := 93;

        if (ChosenVG > -1) and (VectGroups[ChosenVG].StatQ < 0)
          or (ChosenVG = -1) and (GNSSVectors[ChosenVect].StatusQ < 0) then
          VectorPopup.Items[1].Visible := false
        else
          VectorPopup.Items[1].Visible := true;

        VectorPopup.Popup(P.x, P.y);
      end;
    end;
  end;


end;

procedure TFMainTree.urnOff1Click(Sender: TObject);
begin
  if ChosenPoint > -1 then
    FGNSSPointSettings.TurnOnOffStation(ChosenPoint, false);
  MainTreeDraw;
end;

procedure TFMainTree.urnON1Click(Sender: TObject);
begin
  if ChosenPoint > -1 then
    FGNSSPointSettings.TurnOnOffStation(ChosenPoint, true);
  MainTreeDraw;
end;

procedure TFMainTree.View1Click(Sender: TObject);
begin
  if ChosenSession > -1 then
    FGNSSSessionOptions.ShowGNSSSessionInfo(ChosenSession, Form1.IcoList, ChosenSol);
  MainTreeDraw;
end;

end.
