unit UVectSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, GNSSObjects, ComCtrls;

type
  TFVectSettings = class(TForm)
    Image3: TImage;
    StatImg: TImage;
    VectLabel: TLabel;
    StatusLabel: TLabel;
    VPC: TPageControl;
    TabSheet1: TTabSheet;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    isAc: TCheckBox;
    BEdit: TEdit;
    REdit: TEdit;
    Memo1: TMemo;
    TabSheet2: TTabSheet;
    BaselinesBox: TListBox;
    Label3: TLabel;
    Button3: TButton;
    Button2: TButton;
    Button1: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    SpeedButton2: TSpeedButton;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Label4: TLabel;
    isItmAc: TCheckBox;
    Memo2: TMemo;
    Button7: TButton;
    SpeedButton3: TSpeedButton;
    procedure Button6Click(Sender: TObject);
    procedure isAcClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure BaselinesBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure BaselinesBoxClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure isItmAcClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    
  private
    { Private declarations }
  public
    procedure ShowVectorProp(VectN:integer; Img:TImageList);
    { Public declarations }
  end;

var
  FVectSettings: TFVectSettings;
  VectorN: integer;
  VectorsN: Array of integer;
  BaseId, RoverId: string;
  ImgList :TImageList;
  isInit : boolean;
const
  StatList :Array[-1..13] of String = ('Turned off',
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
                                      ' ');
                                      /// ToDo : Translate
implementation

uses UStartProcessing;

{$R *.dfm}

{ TFVectSettings }

procedure RefreshVectorSettings;
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

  with FVectSettings do
  Begin 
    N := BaseLinesBox.ItemIndex;
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
      end;

      BaseLinesBox.ItemIndex := N;
      StatI := 0;
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

    VectLabel.Caption := BaseId + ' -> ' + RoverId;
    StatusLabel.Caption := StatList[StatI];

    with StatImg.Canvas do
    begin
      Brush.Color := clBtnFace;
      Fillrect(Rect(0, 0, Width, Height));
      I := 15;
      case StatI of
         -1..2 : I := 15 + StatI;
         8 : I := 19;
         // ToDo ADJUSTED: ok I := 20, poor I := 21
      end;
      ImgList.Draw(StatImg.Canvas, 0, 0, I);
    end;

  End;
  isInit := false;

end;

procedure TFVectSettings.BaselinesBoxClick(Sender: TObject);
var I, StatI, j :integer;
begin
  if BaselinesBox.ItemIndex = -1 then
    exit;

  isInit := true;
  I := BaselinesBox.ItemIndex;
  StatI := GNSSVectors[VectorsN[I]].StatusQ;
  if StatI < 0 then
    StatI := -1;
  
  isItmAc.Checked := GNSSVectors[VectorsN[I]].StatusQ >= 0;
  
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
    Memo1.Lines.Add('No processing info yet');

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
  I := BaselinesBox.ItemIndex;
  if I = -1 then
    exit;
    
  if isInit then
   exit;
   
  case isItmAc.Checked of
    true:  EnableGNSSVector(VectorsN[I]);
    false:
    begin
       if GNSSVectors[VectorsN[I]].StatusQ > 0 then
         if MessageDlg('The action can change the other data. Proceed?',
            mtConfirmation, [mbYes, mbNo], 0) <> 6 then 
            begin
              isItmAc.Checked := true;
              exit;
            end;

       DisableGNSSVector(VectorsN[I]);
    end;
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
    BaseId  := GetGNSSVectorPoint(VectN, true);
    RoverId := GetGNSSVectorPoint(VectN, false);
    ImgList := Img;

    RefreshVectorSettings;
    if VPC.ActivePageIndex = 1 then
      BaseLinesBox.ItemIndex := 0;
    
  finally
    Showmodal;
  end;
 

end;

procedure TFVectSettings.SpeedButton1Click(Sender: TObject);
begin
  if GNSSVectors[VectorN].StatusQ > 0 then
  if MessageDlg('The action can change the other data. Proceed?',
            mtConfirmation, [mbYes, mbNo], 0) <> 6 then  exit;
  InvertGNSSVector(VectorN);
  RefreshVectorSettings;
end;

procedure TFVectSettings.SpeedButton2Click(Sender: TObject);
var I:Integer;
    needAsk: boolean;
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
  RefreshVectorSettings;

end;

procedure TFVectSettings.SpeedButton3Click(Sender: TObject);
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
