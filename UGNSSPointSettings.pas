unit UGNSSPointSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, GNSSObjects, ComCtrls, GeoString, ImgList;

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
    procedure SessBoxChange(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure SolSrcBoxChange(Sender: TObject);
    procedure isBSClick(Sender: TObject);
    procedure isAcClick(Sender: TObject);
    procedure SolBoxChange(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ShowStationOrTrack(StatN:Integer; Img:TImageList);
    { Public declarations }
  end;

var
  FGNSSPointSettings: TFGNSSPointSettings;
  StationN, SessionN:Integer;
  IsInit  :Boolean;
  ImgList :TImagelist;
  TreeInd :integer = -1;

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
var
   RNode, FNode : TTreeNode;
implementation

{$R *.dfm}

procedure OutputGNSSObjTree(TW :TTreeView; StatN :Integer);
var I, j, k, imgN, SolI, SessI :integer;
    Str : string;
    Node1, Node2, Node3, Node4, Node5 : TTreeNode;
begin
  // TreeInd := TW.ItemIndex
  TW.Items.Clear;                               StatN := -1; //DEL!
  RNode := nil;
  FNode := nil;
  for I := Length(GNSSPoints) -1 downto 0 do
  begin
    if (StatN > 0) and (I <> StatN) then
      continue;

    Node1 := TW.Items.AddFirst(nil, GNSSPoints[I].PointName);
    RNode := Node1;

    try
        ImgN := GNSSPoints[I].Status;
        if GNSSPoints[I].Active = false then
          ImgN := 7;
    except
        ImgN := 8;
    end;

    with Node1 do
    begin
       ImageIndex := ImgN;
       SelectedIndex := ImgN;
    end;

    for j := 0 to Length(GNSSPoints[I].Sessions) - 1 do
    begin
      Str := '[Error]';
      imgN := 0;
      Try
        SessI := GetGNSSSessionNumber(GNSSPoints[I].Sessions[j]);
        if SessI <> -1 then
        begin
          Str   := GNSSSessions[SessI].MaskName;
          ImgN  := GNSSSessions[SessI].StatusQ;
        end
      Except
        Str := '[Error]';
        SessI := -1;
        imgN := 0;
      End;

      Node2 := TW.Items.AddChild(Node1, Str);
      with Node2 do
      begin
         ImageIndex := ImgN +22;
         SelectedIndex := ImgN +22;
      end;


      for k := 1 to Length(GNSSSessions[SessI].Solutions)-1 do
      with GNSSSessions[SessI].Solutions[k] do
      begin
         SolI := GetSolutionSubStatus(SessI, k);
         try
           ImgN := SolI*7 + SolutionQ
         except
           ImgN := 0;
         end;

         if SolI > 0 then
         with Node2 do
         if ImageIndex < 60 then
         begin
            ImageIndex := ImgN +30;
            SelectedIndex := ImageIndex;
         end;

         case SolutionKind of
            1: Str := 'Single Code Solution';  //// ToDo: Translate
            2:  try
               Str := GNSSSessions[GetGNSSSessionNumber(BaseID)].MaskName
                    + ' -> ' +  GNSSSessions[SessI].MaskName
             except
               Str := '[Error]'
             end;
            3: Str := 'PPP Solution';
         end;

         Node3 := TW.Items.AddChild(Node2, Str);
         with Node3 do
         begin
           ImageIndex := ImgN +30;
           SelectedIndex := ImgN + 30;
         end;
      end;

    end;
  end;


end;

{

  if RouteCount > 0 then
  Begin
    Node1 := TreeView1.Items.AddFirst(nil, Inf[24]);
    RNode := Node1;
    
    for I := 0 to RouteCount - 1 do
    Begin
      Node2 := TreeView1.Items.AddChild(Node1,Route[I].Name);
      with Node2 do
      begin
         ImageIndex := 3;
         SelectedIndex := 8;
      end;
      for J := 0 to Length(Route[I].WPT)-1 do
      begin
         Node3 := TreeView1.Items.AddChild(Node2,Inf[25]+IntToStr(J+1));
         with Node3 do
         begin
           ImageIndex := 4;
           SelectedIndex := 9;
         end;
      end;
    End;
  End;

  if Frame then
  Begin
    Node5 := TreeView1.Items.AddFirst(nil, Inf[23]);
    FNode := Node5;
    with Node5 do
    begin
       ImageIndex := 0;
       SelectedIndex := 5;
    end;

    for I := 0 to FrameCount - 2 do
    Begin
      Node4 := TreeView1.Items.AddChild(Node5,Inf[25]+IntToStr(i+1));
      with Node4 do
      begin
         ImageIndex := 1;
         SelectedIndex := 6;
      end;
    End;
  End;

   
  case ClickMode of
    21,22,25,27: if FNode <> nil then
    begin


      if FNode.Count > 0 then
         FNode.Expand(true);

      FNode.Selected := true;

      if ClickMode<>25 then
        for I := 0 to FNode.Count - 1 do
        try
           Node4 := FNode[I];
           if SelectedFramePoints[I] then
             TreeView1.Select(Node4, [ssCtrl]);

        except
        end;
    end;

    23,24,26,28: if RNode <> nil then
    if RNode.Count > 0 then
    begin

       RNode.Expand(false);
       RNode.Selected := true;

       if ClickMode=26 then
       begin
         if  RNode[ RNode.Count - 1 ].Count > 0 then
             RNode[ RNode.Count - 1 ].Expand(true)
       end
       else
       for I := 0 to RNode.Count - 1 do
         if RNode.Count > 0 then
           for J := 0 to RNode[I].Count - 1 do
           try
              Node4 := RNode[I][J];

              if (I = MapFm.RouteBox.ItemIndex-1) or
                 (ClickMode = 28)and ( PointToAddRouteNum = I) then
                if  RNode[I].Expanded = false then
                    RNode[I].Expand(true);

              if SelectedRoutePoints[I][J] then
              Begin
                if  RNode[I].Expanded = false then
                    RNode[I].Expand(true);

                   TreeView1.Select(Node4, [ssCtrl]);
              End;

           except
           end;

    end;
  end;
}

procedure RefreshPointSettings;
var I, j:integer;
begin

 with FGNSSPointSettings do
 Begin
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
      ImgList.Draw(StatImg.Canvas, 0, 0, I);
    end;

    OutputGNSSObjTree(TreeView, StationN);
 End;

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

procedure TFGNSSPointSettings.isAcClick(Sender: TObject);
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
  begin
    isInit := true;
    isAc.Checked := not isAc.Checked;
    isInit := false;
    exit;
  end;

  GNSSPoints[StationN].Active := isAC.Checked;
  if GNSSPoints[StationN].Active then
    DebugMSG('Setting Station: '+ GNSSPoints[StationN].PointName +'turned ON')
  else
    DebugMSG('Setting Station: '+ GNSSPoints[StationN].PointName +'turned OFF');
    
  for I := 0 to Length(GNSSPoints[StationN].Sessions)- 1 do
  begin
    if GNSSPoints[StationN].Active then
      AddGNSSVectorsForSession(GNSSPoints[StationN].Sessions[I])
    else
      DelGNSSVectorsForSession(GNSSPoints[StationN].Sessions[I]);
  end;
  
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

end.
