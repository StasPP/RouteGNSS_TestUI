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
    Label2: TLabel;
    isAc: TCheckBox;
    BEdit: TEdit;
    REdit: TEdit;
    Memo1: TMemo;
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

uses UStartProcessing, UGNSSSessionOptions, Unit1;

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

      Memo1.Clear;
      if (StatI > 0) and (StatI <> 8) then
      with GNSSVectors[VectorN] do
      begin
        Memo1.Lines.Add('Vector length: '+FormatFloat('### ### ##0.000',
                        SQRT(sqr(dX) + sqr(dY) + sqr(dZ)) ) + ' m;');

        Memo1.Lines.Add('dX: '+ FormatFloat('### ### ##0.000', dX)  + ' m;  ' +
                        'dY: '+ FormatFloat('### ### ##0.000', dY)  + ' m;  ' +
                        'dZ: '+ FormatFloat('### ### ##0.000', dZ)  + ' m.');
        Memo1.Lines.Add('StDevs / Covariation matrix elements:');
        Memo1.Lines.Add('mX: '+ FormatFloat('0.0000', StDevs[1])  + ' m;  ' +
                        'mY: '+ FormatFloat('0.0000', StDevs[2])  + ' m;  ' +
                        'mZ: '+ FormatFloat('0.0000', StDevs[3])  + ' m;');
        Memo1.Lines.Add('mXY: '+ FormatFloat('0.0000', StDevs[4]) + ' m;  ' +
                        'mYZ: '+ FormatFloat('0.0000', StDevs[5]) + ' m;  ' +
                        'mZX: '+ FormatFloat('0.0000', StDevs[6]) + ' m.');
      end
      else
        Memo1.Lines.Add('No processing info yet');
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

procedure TFVectSettings.BaselinesBoxClick(Sender: TObject);
var I, StatI, j :integer;
  Sol:TSolutionId;
begin
  if BaselinesBox.ItemIndex = -1 then
    exit;

  I := BaselinesBox.ItemIndex;
  if I < 0 then
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

  Memo2.Clear;
  Memo2.Lines.Add(BaselinesBox.Items[I]);
  Memo2.Lines.Add(StatList[StatI]);
  if (StatI > 0) and (StatI <> 8) then
  with GNSSVectors[VectorsN[I]] do
  begin
    Memo2.Lines.Add('Vector length: '+FormatFloat('### ### ##0.000',
                        SQRT(sqr(dX) + sqr(dY) + sqr(dZ)) ) + ' m;');

    Memo2.Lines.Add('dX: '+ FormatFloat('### ### ##0.000', dX)  + ' m;');
    Memo2.Lines.Add('dY: '+ FormatFloat('### ### ##0.000', dY)  + ' m;');
    Memo2.Lines.Add('dZ: '+ FormatFloat('### ### ##0.000', dZ)  + ' m.');

    Memo2.Lines.Add('StDevs / Covariation matrix elements:');
    Memo2.Lines.Add('mX: '+ FormatFloat('0.0000', StDevs[1])  + ' m; ' +
                    'mY: '+ FormatFloat('0.0000', StDevs[2])  + ' m; ' + 
                    'mZ: '+ FormatFloat('0.0000', StDevs[3])  + ' m;');
    Memo2.Lines.Add('mXY: '+ FormatFloat('0.0000', StDevs[4]) + ' m; ' +
                    'mYZ: '+ FormatFloat('0.0000', StDevs[5]) + ' m; ' + 
                    'mZX: '+ FormatFloat('0.0000', StDevs[6]) + ' m.');
  end
  else
    Memo2.Lines.Add('No processing info yet');

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
