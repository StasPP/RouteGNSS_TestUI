unit GNSSObjsTree;

interface

uses CommCtrl, ComCtrls, StdCtrls, GNSSObjects, GeoFunctions, GeoClasses, Geoid,
   ExtCtrls, GeoString, Classes, SysUtils, MATRIX;

procedure OutputGNSSObjTree(TW :TTreeView; StatN :Integer); overload;
procedure OutputGNSSObjTree(TW :TTreeView; StatN :Integer; HideArr:Array of Integer;
            HideArrLength :integer); overload;
procedure OutputGNSSVectTree(TW :TTreeView);  overload;
procedure OutputGNSSVectTree(TW :TTreeView; HideArr:Array of Integer;
            HideArrLength :integer);  overload;
procedure OutputCoords(X, Y, Z : Double; CS1, CS2, WGSCS:Integer;
                XEd, YEd, ZEd: TEdit; XLabel, YLabel, ZLabel: TLabel;
                GeoidP:TPanel; GeoidIdx: integer);
function ConvCoords(X, Y, Z : Double; CS1, CS2, WGSCS, GeoidIdx:Integer): TXYZ;

function ConvStDevsNEHToXYZ(StN, StE, StU : Double; B, L : Double):TCoord3D;

var
   RNode, FNode : TTreeNode;

const
     TmpInf :Array[0..8] of String = ('X, m:', 'Y, m:', 'Z, m:',
                                  'Latitude, deg:', 'Longtitude, deg:',
                                  'Ellipsoidal Height, m:',
                                  'Northing, m:', 'Easting, m:',
                                  'Orthometric Height, m:');
type
   TVectGroup = record
     Name  : String;
     Vects : array of Integer;
     StatQ : integer;
   end;
var
   VectGroups      : Array of TVectGroup;
   TreeNumbersList : Array of Integer;
implementation

procedure AddNum(I, Idx:Integer);
var j, n : integer;
begin
  j := Length(TreeNumbersList);
  SetLength(TreeNumbersList, j+1);
  for n := j Downto Idx do
    TreeNumbersList[n] := TreeNumbersList[n-1];

  TreeNumbersList[Idx] := I;
end;

procedure DelNum(I:Integer);
var j:integer;
begin
  for j := I to Length(TreeNumbersList)-2 do
    TreeNumbersList[j] := TreeNumbersList[j+1];

  SetLength(TreeNumbersList, Length(TreeNumbersList)-1);
end;

function ConvCoords(X, Y, Z : Double; CS1, CS2, WGSCS, GeoidIdx:Integer): TXYZ;
var nX, nY, nZ, B, L, H, dH, Bwgs, Lwgs, Hwgs, dEll : Double;
begin
  nX := 0;
  nY := 0;
  nZ := 0;

  try
  //  CSToCS(X, Y, Z, CS1, CS2, nX, nY, nZ);
  //  if CoordinateSystemList[CS2].ProjectionType <> 1 then

      if GeoidIdx > -1 then
      begin
        CoordinateSystemToDatum(CS1, X, Y, Z, B, L, H);
        CSToCS(X, Y, Z, CS1, WGSCS, Bwgs, Lwgs, Hwgs);
        dH   := GetGeoidH(GeoidIdx, Bwgs, Lwgs);

        if CoordinateSystemList[CS1].ProjectionType <> 1 then
        begin
          dEll := H - Hwgs;
          H    := H + dEll + dH;  // extrude Geoid from input;
          DatumToCoordinateSystem(CS1, B, L, H, X, Y, Z);
        end;

        CSToCS(X, Y, Z, CS1, CS2, nX, nY, nZ);

        if CoordinateSystemList[CS2].ProjectionType <> 1 then
        begin
          CoordinateSystemToDatum(CS2, nX, nY, nZ, B, L, H);
          dEll := H - Hwgs;
          H    := H - dEll - dH; /// Add Geoid to New
          DatumToCoordinateSystem(CS2, B, L, H, nX, nY, nZ);
        end;

      end
       else
         CSToCS(X, Y, Z, CS1, CS2, nX, nY, nZ);
  finally
    result.X := nX; result.Y := nY; result.Z := nZ;
  end;

end;

procedure OutputCoords(X, Y, Z : Double; CS1, CS2, WGSCS:Integer;
    XEd, YEd, ZEd: TEdit; XLabel, YLabel, ZLabel: TLabel; GeoidP:TPanel;
                GeoidIdx: integer);
  var nXYZ : TXYZ;
begin
    XEd.Text := '';  YEd.Text := '';  ZEd.Text := '';

    if GeoidIdx > Length(GeoidList)-1 then
      GeoidIdx := Length(GeoidList)-1;

    if (CS2 = -1) or (CS1 = -1) then
      exit;

    nXYZ :=  ConvCoords(X, Y, Z, CS1, CS2, WGSCS, GeoidIdx);

    GeoidP.Visible := true;  GeoidP.Enabled := true;

    case CoordinateSystemList[CS2].ProjectionType of
      0: begin
        XEd.Text := DegToDMS(nXYZ.X, true,  5, true);
        YEd.Text := DegToDMS(nXYZ.Y, false, 5, true);
        ZEd.Text := FormatFloat('0.000', nXYZ.Z);

        XLabel.Caption := TmpInf[3];    /// ToDo: replace with common inf
        YLabel.Caption := TmpInf[4];
        if GeoidIdx = -1 then
          ZLabel.Caption := TmpInf[5]
        else
          ZLabel.Caption := TmpInf[8]
      end;

      1: begin
        XEd.Text := FormatFloat('### ### ### ##0.000', nXYZ.X);
        YEd.Text := FormatFloat('### ### ### ##0.000', nXYZ.Y);
        ZEd.Text := FormatFloat('### ### ### ##0.000', nXYZ.Z);

        XLabel.Caption := TmpInf[0];
        YLabel.Caption := TmpInf[1];
        ZLabel.Caption := TmpInf[2];
        GeoidP.Enabled := false;  GeoidP.Visible := false;
      end;

      2..5: begin
        XEd.Text := FormatFloat('### ### ### ##0.000', nXYZ.X);
        YEd.Text := FormatFloat('### ### ### ##0.000', nXYZ.Y);
        ZEd.Text := FormatFloat('0.000', nXYZ.Z);

        XLabel.Caption := TmpInf[6];
        YLabel.Caption := TmpInf[7];
        if GeoidIdx = -1 then
          ZLabel.Caption := TmpInf[5]
        else
          ZLabel.Caption := TmpInf[8]
      end;

    end;

end;

procedure SetNodeBoldState(Node: TTreeNode; Value: Boolean);
var
  TVItem: TTVItem;
begin
  if not Assigned(Node) then Exit;
  with TVItem do
  begin
    mask := TVIF_STATE or TVIF_HANDLE;
    hItem := Node.ItemId;
    stateMask := TVIS_BOLD;
    if Value then state := TVIS_BOLD
    else 
      state := 0;
    TreeView_SetItem(Node.Handle, TVItem);
  end;
end;

procedure ClearEmptyNodes(var TW :TTreeView);
var I, j: Integer;
begin
  for I := TW.Items.Count-1 Downto 0 do
  begin
    if TW.Items[I].Level = 0 then
     if TW.Items[I].GetLastChild = nil then
     begin
       TW.Items[I].Delete;
       DelNum(I);
     end;
  end;
end;

procedure OutputGNSSObjTree(TW :TTreeView; StatN :Integer); overload;
var A : array of integer;
begin
   SetLength(A, 0);
   OutputGNSSObjTree(TW, StatN, A, 0);
end;

procedure OutputGNSSObjTree(TW :TTreeView; StatN :Integer; HideArr:Array of Integer;
            HideArrLength :integer); overload;
var I, j, k, imgN, SolI, SessI :integer;
    Str : string;
    Node1, Node2, Node3 : TTreeNode;
    isHidden: Boolean;
begin
  SetLength(TreeNumbersList, 0);
  // TreeInd := TW.ItemIndex
  TW.Items.Clear;
  RNode := nil;
  FNode := nil;
  for I := Length(GNSSPoints) -1 downto 0 do
  begin
    if (StatN >= 0) and (I <> StatN) then
      continue;

    Node1 := TW.Items.AddFirst(nil, GNSSPoints[I].PointName);
    AddNum(I, Node1.AbsoluteIndex);

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
       ImageIndex := ImgN +77;
       SelectedIndex := ImgN +77;
    end;

    SetNodeBoldState(Node1, True);

    for j := 0 to Length(GNSSPoints[I].Sessions)-1 do
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

      if GNSSPoints[I].Active = false then   ImgN := 0;

      isHidden := false;
      if (StatN = -2) then ////  Choose Data Mode!
        for k := 0 to HideArrLength - 1 do
          if SessI = HideArr[k] then
          begin
            isHidden := true;
            break;
          end;

      if isHidden then
        continue;

      Node2 := TW.Items.AddChild(Node1, Str);
      AddNum(SessI, Node2.AbsoluteIndex);
      with Node2 do
      begin
         ImageIndex := ImgN +22;
         SelectedIndex := ImgN +22;
      end;

      if (StatN = -2) then  /// Don't output solutions!
        continue;

      for k := 1 to Length(GNSSSessions[SessI].Solutions)-1 do
      with GNSSSessions[SessI].Solutions[k] do
      begin
         SolI := GetSolutionSubStatus(SessI, k);
         try
           ImgN := SolI*7 + SolutionQ
         except

         end;

         if GNSSPoints[I].Active = false then  ImgN := 0;

         if SolI > 0 then
         with Node2 do
         if ImageIndex < 60 then
         begin
            ImageIndex := ImageIndex +40;
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
         AddNum(k, Node3.AbsoluteIndex);
         with Node3 do
         begin
           ImageIndex := ImgN +30;
           SelectedIndex := ImgN + 30;
         end;
      end;
    end;


    if (GNSSPoints[I].CoordSource <> 0) and (GNSSPoints[I].CoordSource <> 3)
      and (StatN <> -2) then
    begin
      ImgN := 70;
      case GNSSPoints[I].CoordSource of
          1: begin

             case GNSSPoints[I].AdjMethod of
               0: Str  := '[Chosen the best Single/PPP Solution]';     /// ToDo: Translate
               1: Str  := '[Average Single/PPP Solutions]';     /// ToDo: Translate
               2: Str  := '[Weighted Avg. Single/PPP Solutions]';     /// ToDo: Translate
             end;

             if GNSSPoints[I].Status = 9  then
               ImgN := 76
             else
             if GNSSPoints[I].Status = 12  then
               ImgN := 75;
          end;
          2: begin

             case GNSSPoints[I].AdjMethod of
               0: Str  := '[Chosen the best Baseline Solution]';     /// ToDo: Translate
               1: Str  := '[Average Baseline Solutions]';     /// ToDo: Translate
               2: Str  := '[Weighted Avg. Baseline Solutions]';     /// ToDo: Translate
               ///
               4: Str  := '[Adjusted Baseline Solutions]'; 
             end;

             if GNSSPoints[I].Status = 10  then
               ImgN := 73
             else
             if GNSSPoints[I].Status = 11  then
               ImgN := 74;
          end;
          4: begin
             Str  := '[User Defined Coordinates]';          /// ToDo: Translate
             ImgN := 72;
          end;
      end;

      if (GNSSPoints[I].Status = 8) then
        ImgN := 70;

      if (GNSSPoints[I].Status = 7) or (GNSSPoints[I].Active = false) then
        ImgN := 71;

      Node2 := TW.Items.AddChild(Node1, Str);
      AddNum(-I, Node2.AbsoluteIndex);
      with Node2 do
      begin
         ImageIndex := ImgN;
         SelectedIndex := ImgN;
      end;
    end;

  end;


  if HideArrLength > 0 then
    ClearEmptyNodes(TW);
  
  for I := 0 to TW.Items.count - 1 do
  begin
    if (StatN = -1) and (TW.Items[I].Level > 0) then
      TW.Items[I].Collapse(true)
    else
      TW.Items[I].Expand(false);
  end;

end;

procedure GroupVectors;
var I, j, k :Integer;
    s : string;
    NeedNew: boolean;
begin
   SetLength(VectGroups, 0);
   for I := 0 to Length(GNSSVectors) - 1 do
   begin
     s := GetGNSSVectorPoint(I, true) + '-'+ GetGNSSVectorPoint(I, false);

     NeedNew := True;
     for j := 0 to Length(VectGroups) - 1 do
       if VectGroups[j].Name = s then
       begin
         NeedNew := false;
         break;
       end;

     if NeedNew then
     begin
       j := Length(VectGroups);
       SetLength(VectGroups, j+1);
       VectGroups[j].Name := s;
     end;

     k := Length(VectGroups[j].Vects);
     SetLength(VectGroups[j].Vects, k+1);

     VectGroups[j].Vects[k] := I;
   end;
end;

procedure OutputGNSSVectTree(TW :TTreeView);   overload;
var A : array of integer;
begin
   SetLength(A, 0);
   OutputGNSSVectTree(TW, A, 0);
end;

procedure OutputGNSSVectTree(TW :TTreeView;  HideArr:Array of Integer;
            HideArrLength :integer); overload;
var I, j, k, N, ImgN :Integer;
    s : string;
    Node1, Node2: TTreeNode;

    isHidden : Boolean;
begin
   SetLength(TreeNumbersList, 0);
   GroupVectors;
   TW.Items.Clear;
   RNode := nil;
   FNode := nil;

   for I := Length(VectGroups) -1 downto 0 do
   begin
    Node1 := TW.Items.AddFirst(nil, VectGroups[I].Name);
    AddNum(I, Node1.AbsoluteIndex);
    RNode := Node1;
    VectGroups[I].StatQ := GetGNSSVectorGroupStatus(VectGroups[I].Vects);

    try
        ImgN := VectGroups[I].StatQ;
        if ImgN < 0 then ImgN := -1;
        case ImgN of
           -1..2 : ImgN := 15 + ImgN;

           3..7  : ImgN := 18;
           8     : ImgN := 19;
           11..12: ImgN := ImgN - 6;

           110   : ImgN := 101;
           112   : ImgN := 102;
           113, 114 : ImgN := 103;
           120      : ImgN := 104;
           123, 124 : ImgN := 105;
           130, 140 : ImgN := 106;
           else ImgN := 15;
         end;
    except
        ImgN := 15;
    end;

    with Node1 do
    begin
       ImageIndex := ImgN;
       SelectedIndex := ImgN;
    end;
    SetNodeBoldState(Node1, True);

    for j := 0 to Length(VectGroups[I].Vects) - 1 do
    begin
      try
        ImgN := GNSSVectors[VectGroups[I].Vects[j]].StatusQ;
        if ImgN < 0 then ImgN := -1;
        case ImgN of
           -1..2 : ImgN := 15 + ImgN;
           3..7  : ImgN := 18;
           8     : ImgN := 19;
           11..12: ImgN := ImgN - 6;
           // ToDo ADJUSTED: ok I := 20, poor I := 21
           else ImgN := 15;
        end;

        N := GetGNSSSessionNumber(GNSSVectors[VectGroups[I].Vects[j]].BaseID);
        if N = -1 then
          continue;
        s:= GNSSSessions[N].MaskName;

        N := GetGNSSSessionNumber(GNSSVectors[VectGroups[I].Vects[j]].RoverID);
        if N = -1 then
          continue;
        s:= s + ' -> '+GNSSSessions[N].MaskName;
      except
        continue;
      end;
      
      isHidden := false;
      if (HideArrLength > 0) then ////  Choose Data Mode!
        for k := 0 to HideArrLength - 1 do
          if VectGroups[I].Vects[j] = HideArr[k] then
          begin
            isHidden := true;
            break;
          end;

      if isHidden then
        continue;

      Node2 := TW.Items.AddChild(Node1, s);
      AddNum(VectGroups[I].Vects[j], Node2.AbsoluteIndex);
      with Node2 do
      begin
         ImageIndex := ImgN;
         SelectedIndex := ImgN;
      end;
      
    end;

  end;

  if HideArrLength > 0 then
    ClearEmptyNodes(TW);

  for I := 0 to TW.Items.count - 1 do
  begin
    TW.Items[I].Expand(true);
  end;

end;


function ConvStDevsNEHToXYZ(StN, StE, StU : Double; B, L : Double):TCoord3D;
var RBase, RBaseTr :array[0..8] of Double;
    StDevs :array[0..8] of Double;
    ResMatrix :array[0..8] of Double;
begin
  StDevs[0] := StE;      StDevs[1] :=  0;             StDevs[2] :=  0;
  StDevs[3] :=  0;       StDevs[4] := StN;            StDevs[5] :=  0;
  StDevs[6] :=  0;       StDevs[7] :=  0;             StDevs[8] := StU;

  RBase[0] := -sin(L);   RBase[1] := -cos(L)*sin(B);  RBase[2] := cos(L)*cos(B);
  RBase[3] :=  cos(L);   RBase[4] := -sin(L)*sin(B);  RBase[5] := sin(L)*cos(B);
  RBase[6] :=    0;      RBase[7] :=     cos(B);      RBase[8] :=    sin(B);

  TRANSP(3, 3, RBase, RBaseTr);

  MUL(3, RBase, StDevs, ResMatrix);
  MUL(3, ResMatrix, RBaseTr, ResMatrix);

  result[1] := ResMatrix[0];
  result[2] := ResMatrix[4];
  result[3] := ResMatrix[8];
end;

end.
