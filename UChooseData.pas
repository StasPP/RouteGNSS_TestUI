unit UChooseData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons, Menus, GNSSObjects;

type
  TFChooseData = class(TForm)
    TreeView: TTreeView;
    ProcBox: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    SpeedButton1: TSpeedButton;
    ProcBtn: TSpeedButton;
    SpeedButton3: TSpeedButton;
    AddCur: TSpeedButton;
    AddAll: TSpeedButton;
    DelAll: TSpeedButton;
    DelCur: TSpeedButton;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    Addtoprocessing1: TMenuItem;
    AddAll1: TMenuItem;
    RemovefromProcessing1: TMenuItem;
    ClearProcessingList1: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormResize(Sender: TObject);
    procedure ChooseProcData(CPMode: byte; NewOnly:boolean; IList:TImageList);
    procedure DrawList;
    procedure ProcBtnClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure DelAllClick(Sender: TObject);
    procedure ProcBoxClick(Sender: TObject);
    procedure TreeViewClick(Sender: TObject);
    procedure AddAllClick(Sender: TObject);
    procedure ProcBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure DelCurClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AddCurClick(Sender: TObject);
    procedure TreeViewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public

    { Public declarations }
  end;

var
  FChooseData: TFChooseData;
  ChooseProcMode: byte = 1; /// 1 -Single, 2 - Baselines, 3 - PPP
  ImgList :TImageList;

  ProcList: Array of Integer;
implementation

uses Unit1, UStartProcessing, GNSSObjsTree, UGNSSMainTree;

{$R *.dfm}

procedure TFChooseData.AddAllClick(Sender: TObject);
var I: Integer;
begin
 case ChooseProcMode of
   1,3 :
   begin
     SetLength(ProcList, Length(GNSSSessions));
     for I := 0 to Length(GNSSSessions) - 1 do
        ProcList[I] := I;
   end;

   2 :
   begin
      SetLength(ProcList, Length(GNSSVectors));
      for I := 0 to Length(GNSSVectors) - 1 do
         ProcList[I] := I;
   end;
 end;

  AddAll.Enabled := False;
  AddCur.Enabled := False;
  DrawList;
end;

procedure TFChooseData.AddCurClick(Sender: TObject);
var I, j, PointN, SessN, VectN, VGN: Integer;
  SkipIt: Boolean;
begin
  if TreeView.Selected.Index < 0 then
    exit;

  case ChooseProcMode of
   1,3 :
   BEGIN
     case TreeView.Items[TreeView.Selected.AbsoluteIndex].Level of
        0: try
          PointN :=  TreeNumbersList[TreeView.Selected.AbsoluteIndex];
          for I := 0 to Length(GNSSPoints[PointN].Sessions) - 1 do
          begin
            SkipIt := false;
            SessN := GetGNSSSessionNumber(GNSSPoints[PointN].Sessions[I]);
            for j := 0 to Length(ProcList)-1 do
               if ProcList[j] = SessN then
                  SkipIt := true;

            if (SkipIt) or (SessN < 0) then
              continue;

            j := Length(ProcList);
            SetLength(ProcList, j+1);
            ProcList[j] := SessN;
          end;
        except
        end;
        1: try
           SessN := TreeNumbersList[TreeView.Selected.AbsoluteIndex];

           I := Length(ProcList);
           SetLength(ProcList, I+1);
           ProcList[I] := SessN;
        except
        end;

     end;
   END;


   2: BEGIN
     case TreeView.Items[TreeView.Selected.AbsoluteIndex].Level of
        0: try
          VGN :=  TreeNumbersList[TreeView.Selected.AbsoluteIndex];
          for I := 0 to Length(VectGroups[VGN].Vects) - 1 do
          begin
            SkipIt := false;
            for j := 0 to Length(ProcList)-1 do
               if ProcList[j] = VectGroups[VGN].Vects[I]  then
                  SkipIt := true;

            if SkipIt then
              continue;

            j := Length(ProcList);
            SetLength(ProcList, j+1);
            ProcList[j] := VectGroups[VGN].Vects[I];
          end;
        except
        end;
        1: try
           VectN := TreeNumbersList[TreeView.Selected.AbsoluteIndex];

           I := Length(ProcList);
           SetLength(ProcList, I+1);
           ProcList[I] := VectN;

        except
        end;

     end;
   END;


  end;


  DrawList;




end;

procedure TFChooseData.ChooseProcData(CPMode: byte; NewOnly: boolean; IList:TImageList);
var I, j :Integer;
   ToAdd:Boolean;
begin
 ///
 ChooseProcMode := CPMode;
 ImgList := IList;
 TreeView.Images := IList;
 SetLength(ProcList, 0);


 case CPMode of
   1,3 : begin
     case NewOnly of
        true: begin
          for I := 0 to Length(GNSSSessions) - 1 do
          begin
            ToAdd := true;
            for j := 0 to Length(GNSSSessions[I].Solutions) - 1 do
              if GNSSSessions[I].Solutions[j].SolutionKind = CPMode then
                ToAdd := false;

            if not ToAdd  then
              continue;

            j := Length(ProcList);
            SetLength(ProcList, j+1);
            ProcList[j] := I;
          end;
        end;

        false: begin
          SetLength(ProcList, Length(GNSSSessions));
          for I := 0 to Length(GNSSSessions) - 1 do
             ProcList[I] := I;
        end;
     end;
   end;

   2 : begin
     case NewOnly of
        true: begin
          for I := 0 to Length(GNSSVectors) - 1 do
             if (GNSSVectors[I].StatusQ = 0) then
             begin
                j := Length(ProcList);
                SetLength(ProcList, j+1);
                ProcList[j] := I;
             end;
        end;

        false: begin
          SetLength(ProcList, Length(GNSSVectors));
          for I := 0 to Length(GNSSVectors) - 1 do
             ProcList[I] := I;
        end;
     end;

   end;
 end;

 DrawList;
 Showmodal;
end;

procedure TFChooseData.DelAllClick(Sender: TObject);
begin
  SetLength(ProcList, 0);
  DelAll.Enabled := False;
  DelCur.Enabled := False;

  DrawList;
  TreeView.OnClick(nil);
end;

procedure TFChooseData.DelCurClick(Sender: TObject);
var I, j:Integer;
begin
  if ProcBox.ItemIndex < 0 then
    exit;

  j := Length(ProcList);
  for I := ProcBox.ItemIndex to j-2 do
     ProcList[I] := ProcList[I+1];

  SetLength(ProcList, j-1);

  if ProcBox.ItemIndex > 0 then
    ProcBox.ItemIndex := ProcBox.ItemIndex -1;

  DrawList;
end;

procedure TFChooseData.DrawList;
var I, j:Integer;
    s, ID: string;
begin
  case ChooseProcMode of
    1, 3 : OutputGNSSObjTree(TreeView, -2, ProcList, Length(ProcList));
    2    : OutputGNSSVectTree(TreeView, ProcList, Length(ProcList))
  end;
  TreeView.OnClick(nil);

  j := ProcBox.ItemIndex;
  ProcBox.Clear;
  for I := 0 to Length(ProcList) - 1 do
    case ChooseProcMode of
      1, 3 : ProcBox.Items.Add(GNSSSessions[ProcList[I]].MaskName);
      2    : try
         ID := GNSSVectors[ProcList[I]].BaseID;
         s := GNSSSessions[GetGNSSSessionNumber(ID)].MaskName;
         ID := GNSSVectors[ProcList[I]].RoverID;
         s := s + ' -> ' +GNSSSessions[GetGNSSSessionNumber(ID)].MaskName;
         ProcBox.Items.Add(s);
      except
         ProcBox.Items.Add('Errornous Vector');
      end;
    end;
    ProcBox.ItemIndex := j;
    ProcBox.OnClick(nil);
    ProcBox.Repaint;
end;

procedure TFChooseData.FormResize(Sender: TObject);
begin
  Panel1.Width := ClientWidth div 2 -20;
  Panel3.Width := ClientWidth div 2 -20;
end;

procedure TFChooseData.FormShow(Sender: TObject);
begin
  ProcBox.OnClick(nil);
  TreeView.OnClick(nil);
end;

procedure TFChooseData.ProcBoxClick(Sender: TObject);
begin
  DelCur.Enabled := ProcBox.ItemIndex >= 0;
  DelAll.Enabled := ProcBox.Count > 0;

  ProcBtn.Enabled := Length(ProcList) > 0;
end;

procedure TFChooseData.ProcBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
 var IcoN :integer;
begin

  case ChooseProcMode of
    1, 3 :
    BEGIN
       IcoN := 0;
       if Index < Length(ProcList) then
       try
         IcoN := GNSSSessions[ProcList[Index]].StatusQ;
       except
         IcoN := 0;
       end;
       IcoN := IcoN +22
    END;


    2:
    BEGIN
      IcoN := 0;
      if Index < Length(ProcList) then
        try
          IcoN := GNSSVectors[ProcList[Index]].StatusQ;
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
      IcoN := IcoN +15;
    END;
  end;


  with (Control as TListBox).Canvas do
  begin
    ImgList.Draw((Control as TListBox).Canvas, Rect.Left, Rect.Top-1, IcoN);

  //  Brush.Color := (Control as TListBox).Color;
    TextOut(Rect.Left + 20, Rect.Top, (Control as TListBox).Items[Index]);
    
  if odFocused In State then begin
      Brush.Color := (Control as TListBox).Color;
      DrawFocusRect(Rect);
  end;
  end;



end;


procedure TFChooseData.SpeedButton1Click(Sender: TObject);
begin
  close;
end;

procedure TFChooseData.ProcBtnClick(Sender: TObject);
var I, j, k:Integer; A :Array of byte; B, C :Array of Integer;
begin
  SetLength(A, 0); SetLength(B, 0); SetLength(C, 0);
  j := 0;
  SetLength(A, length(ProcList));
  SetLength(B, length(ProcList));
  SetLength(C, length(ProcList));

  for I := 0 to length(ProcList) - 1 do
  begin
    A[I] := ChooseProcMode;

    case ChooseProcMode of
      1,3 : begin
        B[I] := ProcList[I];
        C[I] := ProcList[I];
      end;

      2: begin
         B[I] := GetGNSSSessionNumber(GNSSVectors[ProcList[I]].RoverID);
         C[I] := GetGNSSSessionNumber(GNSSVectors[ProcList[I]].BaseID);
      end;
    end;
  end;

  if length(A) > 0 then
    FStartProcessing.ShowMultiProcOptions(A,B,C);

  Form1.ShowDebugLog;
  FMainTree.OnShow(nil);
  close;
end;

procedure TFChooseData.TreeViewClick(Sender: TObject);
begin
  AddCur.Enabled := TreeView.Selected.Index >= 0;
  AddAll.Enabled := TreeView.Items.Count > 0;
end;

procedure TFChooseData.TreeViewMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var TreeNode: TTreeNode;
begin
    TreeNode := TreeView.GetNodeAt(X, Y);
  if Assigned(TreeNode) then
    TreeNode.Selected := True;
end;

end.
