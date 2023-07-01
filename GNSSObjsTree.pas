unit GNSSObjsTree;

interface

uses CommCtrl, ComCtrls, GNSSObjects;

procedure OutputGNSSObjTree(TW :TTreeView; StatN :Integer);
procedure OutputGNSSVectTree(TW :TTreeView);

var
   RNode, FNode : TTreeNode;
type
   TVectGroup = record
     Name  : String;
     Vects : array of Integer;
   end;
var
   VectGroups: Array of TVectGroup;

implementation

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

procedure OutputGNSSObjTree(TW :TTreeView; StatN :Integer);
var I, j, k, imgN, SolI, SessI :integer;
    Str : string;
    Node1, Node2, Node3 : TTreeNode;
begin
  // TreeInd := TW.ItemIndex
  TW.Items.Clear;
  RNode := nil;
  FNode := nil;
  for I := Length(GNSSPoints) -1 downto 0 do
  begin
    if (StatN >= 0) and (I <> StatN) then
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
         with Node3 do
         begin
           ImageIndex := ImgN +30;
           SelectedIndex := ImgN + 30;
         end;
      end;
    end;


    if (GNSSPoints[I].CoordSource <> 0) and (GNSSPoints[I].CoordSource <> 3) then
    begin
      ImgN := 70;
      case GNSSPoints[I].CoordSource of
          1: begin
             Str  := '[Adjusted Single/PPP Solutions]';     /// ToDo: Translate
             if GNSSPoints[I].Status = 9  then
               ImgN := 76
             else
             if GNSSPoints[I].Status = 12  then
               ImgN := 75;
          end;
          2: begin
             Str  := '[Adjusted Baseline Solutions]';       /// ToDo: Translate
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
      with Node2 do
      begin
         ImageIndex := ImgN;
         SelectedIndex := ImgN;
      end;
    end;

  end;

  
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

procedure OutputGNSSVectTree(TW :TTreeView);
var I, j, N, ImgN :Integer;
    s : string;
    Node1, Node2: TTreeNode;
begin

   GroupVectors;
   TW.Items.Clear;
   RNode := nil;
   FNode := nil;

   for I := Length(VectGroups) -1 downto 0 do
   begin
    Node1 := TW.Items.AddFirst(nil, VectGroups[I].Name);
    RNode := Node1;

    try
        ImgN := GetGNSSVectorGroupStatus(VectGroups[I].Vects);
        case ImgN of
           -1..2 : ImgN := 15 + ImgN;
           8     : ImgN := 19;
           110   : ImgN := 101;
           112   : ImgN := 102;
           113, 114 : ImgN := 103;
           120      : ImgN := 104;
           123, 124 : ImgN := 105;
           130, 140 : ImgN := 106;
           // ToDo ADJUSTED: ok I := 20, poor I := 21
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

        case ImgN of
           -1..2 : ImgN := 15 + ImgN;
           8     : ImgN := 19;
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

      Node2 := TW.Items.AddChild(Node1, s);
      with Node2 do
      begin
         ImageIndex := ImgN;
         SelectedIndex := ImgN;
      end;
      
    end;

  end;

  for I := 0 to TW.Items.count - 1 do
  begin
    TW.Items[I].Expand(true);
  end;

end;


end.
