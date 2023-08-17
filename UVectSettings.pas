unit UVectSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, GNSSObjects, ComCtrls,
  UGNSSPointSettings;

type
  TFVectSettings = class(TForm)
    Image3: TImage;
    StatImg: TImage;
    VectLabel: TLabel;
    StatusLabel: TLabel;
    VPC: TPageControl;
    TabSheet1: TTabSheet;
    RevVect: TSpeedButton;
    Label1: TLabel;
    isAc: TCheckBox;
    BEdit: TEdit;
    REdit: TEdit;
    TabSheet2: TTabSheet;
    BaselinesBox: TListBox;
    Label3: TLabel;
    Button1: TButton;
    Button6: TButton;
    SpeedButton2: TSpeedButton;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Label4: TLabel;
    isItmAc: TCheckBox;
    Memo2: TMemo;
    ProcVectI: TSpeedButton;
    ProcVect: TSpeedButton;
    VectRep: TSpeedButton;
    VectRepI: TSpeedButton;
    RepAll: TSpeedButton;
    ProcAll: TSpeedButton;
    VectLabel3: TLabel;
    VectLabel2: TLabel;
    SolTypeI: TLabel;
    SolBtnI: TSpeedButton;
    Label5: TLabel;
    BEditI: TEdit;
    Label6: TLabel;
    REditI: TEdit;
    VLPC: TPageControl;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    Label7: TLabel;
    aLength: TEdit;
    XLabel: TLabel;
    AdN: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    adU: TEdit;
    Label8: TLabel;
    A3D: TEdit;
    Label11: TLabel;
    adE: TEdit;
    TabSheet8: TTabSheet;
    Label12: TLabel;
    AmN: TEdit;
    Label13: TLabel;
    AmE: TEdit;
    Label14: TLabel;
    AmU: TEdit;
    A11: TEdit;
    A21: TEdit;
    A31: TEdit;
    A32: TEdit;
    A22: TEdit;
    A12: TEdit;
    A33: TEdit;
    A23: TEdit;
    A13: TEdit;
    VLPC0: TPageControl;
    TabSheet9: TTabSheet;
    Label2: TLabel;
    TabSheet10: TTabSheet;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    BLength: TEdit;
    BdN: TEdit;
    BdU: TEdit;
    BdE: TEdit;
    Label20: TLabel;
    BmN: TEdit;
    Label21: TLabel;
    BmE: TEdit;
    Label22: TLabel;
    BmU: TEdit;
    Label19: TLabel;
    B3D: TEdit;
    GroupBox1: TGroupBox;
    B11: TEdit;
    B12: TEdit;
    B13: TEdit;
    B23: TEdit;
    B22: TEdit;
    B21: TEdit;
    B31: TEdit;
    B32: TEdit;
    B33: TEdit;
    procedure Button6Click(Sender: TObject);
    procedure isAcClick(Sender: TObject);
    procedure RevVectClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure BaselinesBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure BaselinesBoxClick(Sender: TObject);
    procedure ProcVectIClick(Sender: TObject);
    procedure isItmAcClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure VectLabelMouseLeave(Sender: TObject);
    procedure VectLabelMouseEnter(Sender: TObject);
    procedure VectLabelClick(Sender: TObject);
    procedure VectLabel3MouseLeave(Sender: TObject);
    procedure VectLabel3MouseEnter(Sender: TObject);
    procedure VectLabel3Click(Sender: TObject);

    procedure RefreshVectorSettings;
    procedure SolTypeIMouseEnter(Sender: TObject);
    procedure SolTypeIMouseLeave(Sender: TObject);
    procedure SolBtnIClick(Sender: TObject);
    procedure SolTypeIClick(Sender: TObject);
    procedure BEditDblClick(Sender: TObject);
    procedure REditChange(Sender: TObject);
    procedure VectRepClick(Sender: TObject);
    procedure RepAllClick(Sender: TObject);
    procedure VectRepIClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ShowVectorProp(VectN:integer; Img:TImageList);
    { Public declarations }
  end;

var
  FVectSettings: TFVectSettings;
  VectorN  :integer;
  ChoosedN :integer;
  VectorsN :Array of integer;
  BaseId, RoverId: string;
  ImgList :TImageList;
  isInit : boolean;
const
  StatList :Array[-1..14] of String = ('Turned off',
                                      'Not Processed',
                                      'Fixed Solution',
                                      'Float Solution',
                                      'SBAS Solution',
                                      'DGPS Solution',
                                      ' ',
                                      ' ',
                                      ' ',
                                      'Error!',
                                      ' ',
                                      'Adjusted Baselines (ok)',
                                      'Adjusted Baselines (poor)',
                                      ' ',
                                      ' ',
                                      'Mixed');
                                      /// ToDo : Translate
implementation

uses UStartProcessing, UGNSSSessionOptions, Unit1, UOutRep;

{$R *.dfm}

{ TFVectSettings }

procedure TFVectSettings.REditChange(Sender: TObject);
var I:Integer;
    F2  :TFGNSSSessionOptions;
begin

  I := GetGNSSSessionNumber(REdit.Text);

  F2 := TFGNSSSessionOptions.Create(nil);
  F2.ShowGNSSSessionInfo(I, Form1.IcoList);
  F2.Release;
  RefreshVectorSettings;
end;

procedure TFVectSettings.RefreshVectorSettings;
var I, j, N:integer;
   BS, RS :string;
   StatI :integer;
begin
    SetLength(VectorsN, 0);
    isInit := true;
    for I := 0 to Length(GNSSVectors) - 1 do
    Begin
     BS :=  GetGNSSVectorPoint(I, true);
     RS :=  GetGNSSVectorPoint(I, false);

     if (RS = RoverId) and (BS = BaseId) then
     begin
       SetLength(VectorsN, Length(VectorsN)+1);
       VectorsN[Length(VectorsN) - 1] := I;
     end;

    End;
    N := BaseLinesBox.ItemIndex;

    if Length(VectorsN)= 0 then
    begin
      close;
      exit;
    end
    else

    if Length(VectorsN) > 1 then
    begin
      VPC.ActivePageIndex := 1;
      BaseLinesBox.Clear;
      for I := 0 to Length(VectorsN) - 1 do
      begin
        j := GetGNSSSessionNumber(GNSSVectors[VectorsN[I]].BaseID);
        if j = -1 then
          continue;
        BS := GNSSSessions[j].MaskName;
        j := GetGNSSSessionNumber(GNSSVectors[VectorsN[I]].RoverID);
        if j = -1 then
          continue;
        RS := GNSSSessions[j].MaskName;

        BaseLinesBox.Items.Add( BS + ' -> ' + RS );
        if ChoosedN <> -1 then
          if I = ChoosedN then
            N := I
      end;

      BaseLinesBox.ItemIndex := N;

      StatI := GetGNSSVectorGroupStatus(VectorsN);
    end
    else
    begin
      VPC.ActivePageIndex := 0;
      j := GetGNSSSessionNumber(GNSSVectors[VectorN].BaseID);
      if j >= 0 then
        BEdit.Text := GNSSSessions[j].MaskName;
      j := GetGNSSSessionNumber(GNSSVectors[VectorN].RoverID);
      if j >= 0 then
        REdit.Text := GNSSSessions[j].MaskName;

      ProcVect.Glyph.Assign(nil);
      if GNSSVectors[VectorN].StatusQ > 0 then
         ImgList.GetBitmap(92,ProcVect.Glyph)
      else
         ImgList.GetBitmap(93,ProcVect.Glyph);

      VectRep.Enabled := GNSSVectors[VectorN].StatusQ > 0;
      ProcVect.Enabled := GNSSVectors[VectorN].StatusQ >= 0;
      
      isAC.Checked := GNSSVectors[VectorN].StatusQ >= 0;
      StatI := GNSSVectors[VectorN].StatusQ;

      if StatI < 0 then
        StatI := -1;

//      Memo1.Clear;
//      if (StatI > 0) and (StatI <> 8) then
//      with GNSSVectors[VectorN] do
//      begin
//        Memo1.Lines.Add('Vector length: '+FormatFloat('### ### ##0.000',
//                        SQRT(sqr(dX) + sqr(dY) + sqr(dZ)) ) + ' m;');
//
//        Memo1.Lines.Add('dX: '+ FormatFloat('### ### ##0.000', dX)  + ' m;  ' +
//                        'dY: '+ FormatFloat('### ### ##0.000', dY)  + ' m;  ' +
//                        'dZ: '+ FormatFloat('### ### ##0.000', dZ)  + ' m.');
//        Memo1.Lines.Add('StDevs / Covariation matrix elements:');
//        Memo1.Lines.Add('mX: '+ FormatFloat('0.0000', StDevs[1])  + ' m;  ' +
//                        'mY: '+ FormatFloat('0.0000', StDevs[2])  + ' m;  ' +
//                        'mZ: '+ FormatFloat('0.0000', StDevs[3])  + ' m;');
//        Memo1.Lines.Add('mXY: '+ FormatFloat('0.0000', StDevs[4]) + ' m;  ' +
//                        'mYZ: '+ FormatFloat('0.0000', StDevs[5]) + ' m;  ' +
//                        'mZX: '+ FormatFloat('0.0000', StDevs[6]) + ' m.');
//      end
//      else
//        Memo1.Lines.Add('No processing info yet');

    if (StatI > 0) and (StatI <> 8) then
    begin
      VLPC0.ActivePageIndex := 1;
      with GNSSVectors[VectorN] do
      begin
        BLength.Text :=  FormatFloat('### ### ##0.000',
                     SQRT(sqr(dX) + sqr(dY) + sqr(dZ)) );

        BdN.Text :=  FormatFloat('### ### ##0.000', dX);  // ToDo!!!  XYZ => NEU
        BdE.Text :=  FormatFloat('### ### ##0.000', dY);
        BdU.Text :=  FormatFloat('### ### ##0.000', dZ);

        B3D.Text :=  FormatFloat('0.0000',
                     SQRT(sqr(StDevs[1]) + sqr(StDevs[2]) + sqr(StDevs[3])) );

        BmN.Text :=  FormatFloat('0.0000', StDevs[1]);  // ToDo!!! XYZ => NEU
        BmE.Text :=  FormatFloat('0.0000', StDevs[2]);
        BmU.Text :=  FormatFloat('0.0000', StDevs[3]);

        B11.Text :=  FormatFloat('0.0000', StDevs[1]);
        B12.Text :=  FormatFloat('0.0000', StDevs[4]);
        B13.Text :=  FormatFloat('0.0000', StDevs[6]);

        B21.Text :=  FormatFloat('0.0000', StDevs[4]);
        B22.Text :=  FormatFloat('0.0000', StDevs[2]);
        B23.Text :=  FormatFloat('0.0000', StDevs[5]);

        B31.Text :=  FormatFloat('0.0000', StDevs[5]);
        B32.Text :=  FormatFloat('0.0000', StDevs[6]);
        B33.Text :=  FormatFloat('0.0000', StDevs[3]);
      end;
    end
    else
      VLPC0.ActivePageIndex := 0;

    end;

    VectLabel.Caption  := BaseId;
    VectLabel3.Caption := RoverId;

    VectLabel2.Left    := VectLabel.Left  + VectLabel.Width;
    VectLabel3.Left    := VectLabel2.Left + VectLabel2.Width;

    if (StatI >= -1) and (StatI < 100) then
      StatusLabel.Caption := StatList[StatI]
    else
      StatusLabel.Caption := StatList[14];

    with StatImg.Canvas do
    begin
      Brush.Color := clBtnFace;
      Fillrect(Rect(0, 0, Width, Height));
      I := 15;
      case StatI of
         -1..2 : I := 15 + StatI;
         3..7: I := 18;
         8 : I := 19;
         110 : I := 101;
         112 : I := 102;
         113, 114 : I := 103;
         120 : I := 104;
         123, 124 : I := 105;
         130, 140 : I := 106;
         // ToDo ADJUSTED: ok I := 20, poor I := 21
      end;
      ImgList.Draw(StatImg.Canvas, 0, 0, I);
    end;
    BaseLinesBox.OnClick(nil);

    ProcAll.Glyph.Assign(nil);
    case StatI of
       0, 8, 110, 120, 130, 140: ImgList.GetBitmap(114,ProcAll.Glyph);
       else ImgList.GetBitmap(92,ProcAll.Glyph);
    end;
        

    isInit := false;

end;

procedure TFVectSettings.RepAllClick(Sender: TObject);
begin
  OutRep.OpenRepWindow(2, GetGNSSPointNumber(BaseId), GetGNSSPointNumber(RoverId), StatImg.Picture.Bitmap);
end;

procedure TFVectSettings.BaselinesBoxClick(Sender: TObject);
var I, StatI, j :integer;
  Sol:TSolutionId;
begin
  if BaselinesBox.ItemIndex = -1 then
    exit;

  I := BaselinesBox.ItemIndex;
  if I < 0 then
    exit;

  if length(VectorsN) < 2 then
    exit;
    
  isInit := true;
  StatI := GNSSVectors[VectorsN[I]].StatusQ;
  if StatI < 0 then
    StatI := -1;

  isItmAc.Checked := GNSSVectors[VectorsN[I]].StatusQ >= 0;

  VectRepI.Enabled := (GNSSVectors[VectorsN[I]].StatusQ > 0) and
    (GNSSVectors[VectorsN[I]].StatusQ <> 8);

  SolTypeI.Caption := StatList[StatI];

  SolBtnI.Glyph.Assign(nil);
  j := 30;
  if (StatI > 0) and (StatI < 6) then
  begin
    SolTypeI.Cursor := crHandPoint;
    Sol := GetGNSSSolutionForVector(VectorsN[I]);
    if (Sol.SessionId <> '') and (Sol.SolutionN <> -1) then
    begin
      j := GNSSSessions[GetGNSSSessionNumber(Sol.SessionId)].
        Solutions[Sol.SolutionN].SolutionQ
        + 7*GetSolutionSubStatus(GetGNSSSessionNumber(Sol.SessionId),
            Sol.SolutionN) + 30;
    end;

  end
  else
    SolTypeI.Cursor := crDefault;

  ImgList.GetBitmap(j, SolBtnI.Glyph);

  j := GetGNSSSessionNumber(GNSSVectors[VectorsN[I]].BaseID);
  if j >= 0 then
    BEditI.Text := GNSSSessions[j].MaskName;
  j := GetGNSSSessionNumber(GNSSVectors[VectorsN[I]].RoverID);
  if j >= 0 then
    REditI.Text := GNSSSessions[j].MaskName;


  if (StatI > 0) and (StatI <> 8) then
  begin
    VLPC.Pages[1].TabVisible := true;
    VLPC.Pages[2].TabVisible := true;
    VLPC.Pages[3].TabVisible := true;
    VLPC.ActivePageIndex := 1;
    with GNSSVectors[VectorsN[I]] do
    begin
      aLength.Text :=  FormatFloat('### ### ##0.000',
                     SQRT(sqr(dX) + sqr(dY) + sqr(dZ)) );

      adN.Text :=  FormatFloat('### ### ##0.000', dX);  // ToDo!!!  XYZ => NEU
      adE.Text :=  FormatFloat('### ### ##0.000', dY);
      adU.Text :=  FormatFloat('### ### ##0.000', dZ);

      a3D.Text :=  FormatFloat('0.0000',
                     SQRT(sqr(StDevs[1]) + sqr(StDevs[2]) + sqr(StDevs[3])) );

      amN.Text :=  FormatFloat('0.0000', StDevs[1]);  // ToDo!!! XYZ => NEU
      amE.Text :=  FormatFloat('0.0000', StDevs[2]);
      amU.Text :=  FormatFloat('0.0000', StDevs[3]);

      a11.Text :=  FormatFloat('0.0000', StDevs[1]);
      a12.Text :=  FormatFloat('0.0000', StDevs[4]);
      a13.Text :=  FormatFloat('0.0000', StDevs[6]);

      a21.Text :=  FormatFloat('0.0000', StDevs[4]);
      a22.Text :=  FormatFloat('0.0000', StDevs[2]);
      a23.Text :=  FormatFloat('0.0000', StDevs[5]);

      a31.Text :=  FormatFloat('0.0000', StDevs[5]);
      a32.Text :=  FormatFloat('0.0000', StDevs[6]);
      a33.Text :=  FormatFloat('0.0000', StDevs[3]);
    end;
  end
  else
  begin
    VLPC.Pages[1].TabVisible := false;
    VLPC.Pages[2].TabVisible := false;
    VLPC.Pages[3].TabVisible := false;
    VLPC.ActivePageIndex := 0;
  end;




  ProcVectI.Glyph.Assign(nil);
  ProcVectI.Enabled := GNSSVectors[VectorsN[I]].StatusQ >= 0;
  if GNSSVectors[VectorsN[I]].StatusQ > 0 then
      ImgList.GetBitmap(92,ProcVectI.Glyph)
  else
      ImgList.GetBitmap(93,ProcVectI.Glyph);


  isInit := false;
end;

procedure TFVectSettings.BaselinesBoxDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var IcoN:integer;
begin
inherited;
  with (Control as TListBox).Canvas do
  begin

    try
        IcoN := GNSSVectors[VectorsN[Index]].StatusQ;
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


    ImgList.Draw((Control as TListBox).Canvas, Rect.Left, Rect.Top-1, IcoN+15);

    TextOut(Rect.Left + 20, Rect.Top, (Control as TListBox).Items[Index]);

    if odFocused In State then begin
      Brush.Color := (Control as TListBox).Color;
      DrawFocusRect(Rect);
    end;

  end;
end;

procedure TFVectSettings.BEditDblClick(Sender: TObject);
var I:Integer;
    F2  :TFGNSSSessionOptions;
begin

  I := GetGNSSSessionNumber(BEdit.Text);

  F2 := TFGNSSSessionOptions.Create(nil);
  F2.ShowGNSSSessionInfo(I, Form1.IcoList);
  F2.Release;
  RefreshVectorSettings;

end;

procedure TFVectSettings.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TFVectSettings.Button3Click(Sender: TObject);
var I, j:Integer; A :Array of byte; B, C :Array of Integer;
begin
  SetLength(A, 0);  SetLength(B, 0);  SetLength(C, 0);
  For I := 0 To BaseLinesBox.Items.Count-1 Do
  begin
    if GNSSVectors[VectorsN[I]].StatusQ < 0 then
      continue; 
      
    j := Length(A);
    SetLength(A, j+1); SetLength(B, j+1);   SetLength(C, j+1);
    A[j] := 2;
    B[j] := GetGNSSSessionNumber(GNSSVectors[VectorsN[I]].RoverId);
    C[j] := GetGNSSSessionNumber(GNSSVectors[VectorsN[I]].BaseId);
  end;

  if Length(A) = 0 then
    exit
  else
    FStartProcessing.ShowMultiProcOptions(A, B, C); 
  RefreshVectorSettings;
end;

procedure TFVectSettings.Button4Click(Sender: TObject);
begin
  FStartProcessing.ShowProcOptions(2,      
     GetGNSSSessionNumber(GNSSVectors[VectorN].RoverId),
     GetGNSSSessionNumber(GNSSVectors[VectorN].BaseId));
  RefreshVectorSettings;   
end;

procedure TFVectSettings.Button6Click(Sender: TObject);
begin
  close;
end;

procedure TFVectSettings.isItmAcClick(Sender: TObject);
var I:Integer;
begin
  if isInit then
   exit;

  I := BaselinesBox.ItemIndex;
  if I = -1 then
    exit;

  if (GNSSVectors[VectorsN[I]].StatusQ <> 0) and
     (GNSSVectors[VectorsN[I]].StatusQ <> -100) then
     if MessageDlg('The action can change the other data. Proceed?',
        mtConfirmation, [mbYes, mbNo], 0) <> 6 then
     begin
        isInit := true;
        isItmAc.Checked := not (isItmAc.Checked);
        isInit := false;
        exit;
     end;

  case isItmAc.Checked of
    true:  EnableGNSSVector(VectorsN[I]);
    false: DisableGNSSVector(VectorsN[I]);
  end;
  
  RefreshVectorSettings;  
end;

procedure TFVectSettings.isAcClick(Sender: TObject);
begin

  if isInit then
   exit;
   
  case isAc.Checked of
    true:  EnableGNSSVector(VectorN);
    false:
    begin
       if GNSSVectors[VectorN].StatusQ > 0 then
         if MessageDlg('The action can change the other data. Proceed?',
            mtConfirmation, [mbYes, mbNo], 0) <> 6 then 
            begin
              isAc.Checked := true;
              exit;
            end;

       DisableGNSSVector(VectorN);
    end;
  end;    
  
  RefreshVectorSettings;  
end;

procedure TFVectSettings.ShowVectorProp(VectN: integer; Img:TImageList);
begin
  if VectN < 0 then
      exit;

  try
    VectorN := VectN;
    ChoosedN:= VectN;
    BaseId  := GetGNSSVectorPoint(VectN, true);
    RoverId := GetGNSSVectorPoint(VectN, false);
    ImgList := Img;

    RefreshVectorSettings;
    if VPC.ActivePageIndex = 1 then
    begin
      //BaseLinesBox.ItemIndex := 0;
    end;
    
  finally
    ChoosedN := -1;
    Showmodal;
  end;

end;

procedure TFVectSettings.SolBtnIClick(Sender: TObject);
var Sol :TSolutionId; I:Integer;
    F2  :TFGNSSSessionOptions;
begin
  if BaselinesBox.ItemIndex = -1 then
    exit;
  I := BaselinesBox.ItemIndex;

  Sol := GetGNSSSolutionForVector(VectorsN[I]);
  if (Sol.SessionId <> '') and (Sol.SolutionN <> -1) then
  begin
     F2 := TFGNSSSessionOptions.Create(nil);
     F2.ShowGNSSSessionInfo(GetGNSSSessionNumber(Sol.SessionId), Form1.IcoList, Sol.SolutionN);
     F2.Release;
     RefreshVectorSettings;
  end;
end;

procedure TFVectSettings.SolTypeIClick(Sender: TObject);
begin
  if VectRepI.Enabled then
    SolBtnI.Click;
end;

procedure TFVectSettings.SolTypeIMouseEnter(Sender: TObject);
begin
  if VectRepI.Enabled then
  begin
    if not (fsUnderline in SoltypeI.Font.Style) then
      SoltypeI.Font.Style := SoltypeI.Font.Style + [fsUnderline];
  end
  else
    if fsUnderline in SoltypeI.Font.Style then
      SoltypeI.Font.Style := SoltypeI.Font.Style - [fsUnderline];
end;

procedure TFVectSettings.SolTypeIMouseLeave(Sender: TObject);
begin
    if fsUnderline in SoltypeI.Font.Style then
      SoltypeI.Font.Style := SoltypeI.Font.Style - [fsUnderline];
end;

procedure TFVectSettings.RevVectClick(Sender: TObject);
var s:string;
begin
  if GNSSVectors[VectorN].StatusQ > 0 then
  if MessageDlg('The action can change the other data. Proceed?',
            mtConfirmation, [mbYes, mbNo], 0) <> 6 then  exit;
  InvertGNSSVector(VectorN);

  s := RoverId;
  RoverId := BaseId;
  BaseId := s;

  RefreshVectorSettings;
end;

procedure TFVectSettings.SpeedButton2Click(Sender: TObject);
var I:Integer;
    needAsk: boolean;
    s: string;
begin
  needAsk := false;
  for I := 0 to Length(VectorsN) - 1 do
    if GNSSVectors[VectorN].StatusQ > 0 then
    begin
      needAsk := true; 
      break;
    end;

  if needAsk then
    if MessageDlg('The action can change the other data. Proceed?',
            mtConfirmation, [mbYes, mbNo], 0) <> 6 then  exit;
            
  InvertGNSSVector(VectorN, true);

  s := RoverId;
  RoverId := BaseId;
  BaseId := s;

  RefreshVectorSettings;

end;

procedure TFVectSettings.VectLabel3Click(Sender: TObject);
var I:Integer;
    F2: TFGNSSPointSettings;
begin

  I := GetGNSSPointNumber(RoverID);
  if I > -1 then
  begin
    F2 := TFGNSSPointSettings.Create(nil);
    F2.ShowStationOrTrack( I, ImgList);
    F2.Release;
    RefreshVectorSettings;
  end;
end;

procedure TFVectSettings.VectLabel3MouseEnter(Sender: TObject);
begin
  if not (fsUnderline in VectLabel3.Font.Style) then
    VectLabel3.Font.Style := VectLabel3.Font.Style + [fsUnderline];
end;

procedure TFVectSettings.VectLabel3MouseLeave(Sender: TObject);
begin
  if fsUnderline in VectLabel3.Font.Style then
    VectLabel3.Font.Style := VectLabel3.Font.Style - [fsUnderline];
end;

procedure TFVectSettings.VectLabelClick(Sender: TObject);
var I:Integer;
    F2: TFGNSSPointSettings;
begin

  I := GetGNSSPointNumber(BaseID);
  if I > -1 then
  begin
    F2 := TFGNSSPointSettings.Create(nil);
    F2.ShowStationOrTrack( I, ImgList);
    F2.Release;
    RefreshVectorSettings;
  end;
end;

procedure TFVectSettings.VectLabelMouseEnter(Sender: TObject);
begin
  if not (fsUnderline in VectLabel.Font.Style) then
    VectLabel.Font.Style := VectLabel.Font.Style + [fsUnderline];
end;

procedure TFVectSettings.VectLabelMouseLeave(Sender: TObject);
begin
  if fsUnderline in VectLabel.Font.Style then
    VectLabel.Font.Style := VectLabel.Font.Style - [fsUnderline];
end;

procedure TFVectSettings.VectRepClick(Sender: TObject);
begin
   OutRep.OpenRepWindow(2, -1, VectorN, StatImg.Picture.Bitmap);
end;

procedure TFVectSettings.VectRepIClick(Sender: TObject);
//var I, BaseI, RoverI : Integer;
var I, Im:Integer; B:TBitMap;
begin
  I := BaseLinesBox.ItemIndex;
//  BaseI  := GetGNSSSessionNumber(GNSSVectors[VectorsN[I]].BaseID);
//  RoverI := GetGNSSSessionNumber(GNSSVectors[VectorsN[I]].RoverID);
//  OutRep.OpenRepWindow(2, BaseI, RoverI, StatImg.Picture.Bitmap);

  try
    Im := GNSSVectors[VectorsN[I]].StatusQ
  except
    Im := 8;
  end;

    if Im < 0 then
       Im := -1
    else
    case I of
       0..2  : Im := Im;
       3..7  : Im := 3;
       8     : Im := 4;
       11..12: Im := Im - 6;
    end;

  B:= TBitMap.Create;
  ImgList.GetBitmap(Im+15, B);
  OutRep.OpenRepWindow(2, -1, VectorsN[I], StatImg.Picture.Bitmap);
  B.Free;
end;

procedure TFVectSettings.ProcVectIClick(Sender: TObject);
var I:Integer;
begin
  I := BaselinesBox.ItemIndex;
  if I = -1 then
    exit;
  FStartProcessing.ShowProcOptions(2,
     GetGNSSSessionNumber(GNSSVectors[VectorsN[I]].RoverId),
     GetGNSSSessionNumber(GNSSVectors[VectorsN[I]].BaseId));
  RefreshVectorSettings;
end;

end.
