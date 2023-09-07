unit UStartProcessing;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls, Buttons, ComCtrls, GNSSObjects,
  RTKLibExecutor;

type
  TFStartProcessing = class(TForm)
    Gb_GNSSSystems: TGroupBox;
    GN1: TCheckBox;
    GN3: TCheckBox;
    GN4: TCheckBox;
    GN6: TCheckBox;
    GN5: TCheckBox;
    GN7: TCheckBox;
    GN2: TCheckBox;
    Cb_GNSSSystems: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    CB_Freq: TComboBox;
    SE_ElevMask: TSpinEdit;
    Label9: TLabel;
    Label10: TLabel;
    SetPC: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    isFixedMode: TCheckBox;
    TabSheet3: TTabSheet;
    SessionLabel: TLabel;
    Image3: TImage;
    Image1: TImage;
    Image2: TImage;
    LProcKind: TLabel;
    CancelButton: TButton;
    Image4: TImage;
    Label1: TLabel;
    Label2: TLabel;
    isDGNSS: TCheckBox;
    ProcButton: TSpeedButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    procedure Cb_GNSSSystemsChange(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure ProcButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure isFixedModeClick(Sender: TObject);
    procedure isDGNSSClick(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
  private
    { Private declarations }
  public
     procedure ShowProcOptions(Method: Byte; // 1 - Single, 2 - BaseLine, 3 - PPP
        Rover, Base :Integer);

     procedure ShowMultiProcOptions(Method: Array of Byte; // 1 - Single, 2 - BaseLine, 3 - PPP
        Rover, Base :Array of Integer);
    { Public declarations }
  end;

var
  FStartProcessing: TFStartProcessing;
  ProcMethod: Byte;  ProcMethods: Array of Byte;
  pRover, pBase :Integer;
  mRover, mBase :Array of Integer;

implementation

uses FProcGNSS;

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
    Cb := FStartProcessing.FindComponent('GN'+IntToStr(i+1)) as TCheckBox;
    A[I] := Cb.Checked;
  end;
  SetRTKSetings(FStartProcessing.SE_ElevMask.Value, A,
      FStartProcessing.CB_Freq.ItemIndex, ES);
end;

procedure TFStartProcessing.ShowProcOptions(Method: Byte;
                  Rover, Base:Integer);
begin

  ProcMethod := Method;
  SetPC.ActivePageIndex := Method - 1;
  pRover := Rover;
  pBase := Base;
  with FStartProcessing do
  case Method of
     1:
     begin
       SessionLabel.Caption := GNSSSessions[Rover].MaskName;
       LProcKind.Caption := 'Single processing'; /// ToDo: Translate
     end;

     2:
     begin
       SessionLabel.Caption := GNSSSessions[Base].MaskName +'-'+GNSSSessions[Rover].MaskName;
       LProcKind.Caption := 'Baseline processing'; /// ToDo: Translate
       TabSheet2Show(nil);
     end;

     3: begin
       SessionLabel.Caption := GNSSSessions[Rover].MaskName;
       LProcKind.Caption := 'Precise Point Positioning';
     end;
  end;

  Image1.Visible := ProcMethod = 1;
  Image2.Visible := ProcMethod = 2;
  Image3.Visible := ProcMethod = 3;
  Image4.Visible := False;
  ShowModal;
end;

procedure TFStartProcessing.TabSheet2Show(Sender: TObject);
var I :Integer; HasKinematicOnly:Boolean;
begin
  HasKinematicOnly := true;

  if ProcMethod = 2 then
    HasKinematicOnly := GNSSSessions[pRover].isKinematic
  else
  if ProcMethod = 10 then
    for I := 0 to length(mRover) - 1 do
    begin
       if not GNSSSessions[mRover[I]].isKinematic then
       begin
          HasKinematicOnly := false;
          break;
       end;
    end;

  isFixedMode.Enabled := not HasKinematicOnly;
  if not isFixedMode.Enabled then
     isFixedMode.Checked := false;

  isDGNSS.Enabled := not isFixedMode.Checked;
end;

procedure TFStartProcessing.ShowMultiProcOptions(Method: Array of Byte;
        Rover, Base :Array of Integer);
var I:Integer;
    commonM:byte;
begin
  ProcMethod := 10; /// MULTI
  commonM := 0;

  SetLength(ProcMethods, Length(Method));
  for I := 0 to Length(Method)-1 do
    ProcMethods[I] := Method[I];

  CommonM := Method[0];
  for I := 0 to Length(Method)-1 do
    if CommonM <> ProcMethods[I] then
    begin
       CommonM := 0;
       break;
    end;


  SetLength(mBase, Length(Base));
  for I := 0 to Length(mBase)-1 do
    mBase[I] := Base[I];

  SetLength(mRover, Length(Rover));
  for I := 0 to Length(mRover)-1 do
    mRover[I] := Rover[I];

 
  with FStartProcessing do
  case CommonM of
     1:
     begin
       SessionLabel.Caption := GNSSSessions[mRover[0]].MaskName;

       if Length(mRover) >= 2 then
          SessionLabel.Caption := SessionLabel.Caption+', '+
                        GNSSSessions[mRover[1]].MaskName;

       LProcKind.Caption := 'Single processing'; /// ToDo: Translate
     end;

     2:
     begin
       SessionLabel.Caption := GNSSSessions[mBase[0]].MaskName + '-' +
                                GNSSSessions[mRover[0]].MaskName;
       if Length(mRover) >= 2 then
          SessionLabel.Caption := SessionLabel.Caption + ', ' +
                GNSSSessions[mBase[1]].MaskName + '-' +
                GNSSSessions[mRover[1]].MaskName;

       LProcKind.Caption := 'Baseline processing'; /// ToDo: Translate
       TabSheet2Show(nil);
     end;

     3: begin
       SessionLabel.Caption := GNSSSessions[mRover[0]].MaskName;

       if Length(mRover) >= 2 then
          SessionLabel.Caption := SessionLabel.Caption+', '+
             GNSSSessions[mRover[1]].MaskName;

       LProcKind.Caption := 'Precise Point Positioning';
     end;

     0: begin
       SessionLabel.Caption := '(Multiplied selection)' ;    /// ToDo: Translate

       if Length(mRover) = 2 then
          SessionLabel.Caption := SessionLabel.Caption+', '+
                      GNSSSessions[mRover[1]].MaskName;

       LProcKind.Caption := '(Different methods)';  /// ToDo: Translate

     end;
  end;

  if (Length(mRover) > 2 ) and (CommonM <> 0) then
     SessionLabel.Caption := SessionLabel.Caption+', ...';

  Image1.Visible := commonM = 1;
  Image2.Visible := commonM = 2;
  Image3.Visible := commonM = 3;
  Image4.Visible := commonM = 0;

  SetPC.Visible := true;
  if CommonM = 0 then
    SetPC.ActivePageIndex := 1
  else
    SetPC.ActivePageIndex := commonM - 1;

  FStartProcessing.ShowModal;
end;

procedure TFStartProcessing.ProcButtonClick(Sender: TObject);
var I:Integer;
begin
    PrepareProc;

    case ProcMethod of
      1:  if SingleRTKProcess(GNSSSessions[pRover], ProcGNSS.Progress, ProcGNSS.Memo)
       then  ProcGNSS.ShowModal2(GNSSSessions[pRover].MaskName, 0);
      2:  if BaseLineRTKProcess(GNSSSessions[pRover], GNSSSessions[pBase],
            ProcGNSS.Progress, ProcGNSS.Memo,
            isFixedMode.Checked, isDGNSS.Checked)
       then ProcGNSS.ShowModal2(GNSSSessions[pRover].MaskName + '-' +
            GNSSSessions[pBase].MaskName, 0);
      3:  if PPPRTKProcess(GNSSSessions[pRover], ProcGNSS.Progress, ProcGNSS.Memo)
       then  ProcGNSS.ShowModal2(GNSSSessions[pRover].MaskName, 0);

      10:
      begin

         for I := 0 to Length(ProcMethods) - 1 do
         begin
           case ProcMethods[I] of
             1:  if SingleRTKProcess(GNSSSessions[mRover[I]],
                      ProcGNSS.Progress, ProcGNSS.Memo)
               then  ProcGNSS.ShowModal2(GNSSSessions[mRover[I]].MaskName,
                      Length(ProcMethods)-1 - I);
             2:  if BaseLineRTKProcess(GNSSSessions[mRover[I]],
                      GNSSSessions[mBase[I]], ProcGNSS.Progress, ProcGNSS.Memo,
                      isFixedMode.Checked, isDGNSS.Checked)
               then ProcGNSS.ShowModal2(GNSSSessions[mRover[I]].MaskName+'-'+
                      GNSSSessions[mBase[I]].MaskName,
                      Length(ProcMethods)-1 - I);
             3:  if PPPRTKProcess(GNSSSessions[mRover[I]],
                      ProcGNSS.Progress, ProcGNSS.Memo)
               then  ProcGNSS.ShowModal2(GNSSSessions[mRover[I]].MaskName,
                      Length(ProcMethods)-1 - I);
           end;

           if ProcGNSS.Cancelled then break;
         end;

      end;
    end;
    close;
end;

procedure TFStartProcessing.CancelButtonClick(Sender: TObject);
begin
  close;
end;

procedure TFStartProcessing.Cb_GNSSSystemsChange(Sender: TObject);
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
    Gb_GNSSSystems.Enabled := Cb_GNSSSystems.ItemIndex = 3;
end;

procedure TFStartProcessing.CheckBox3Click(Sender: TObject);
begin
  DiffENU := CheckBox3.Checked;
end;

procedure TFStartProcessing.FormShow(Sender: TObject);
begin
//  Cb_GNSSSystems.OnClick(nil);
end;

procedure TFStartProcessing.isDGNSSClick(Sender: TObject);
begin
  isFixedMode.Enabled := not isDGNSS.Checked;
  if not isFixedMode.Enabled then
     isFixedMode.Checked := false;
end;

procedure TFStartProcessing.isFixedModeClick(Sender: TObject);
begin
  isDGNSS.Enabled := not isFixedMode.Checked;
  if not isDGNSS.Enabled then
     isDGNSS.Checked := false;
end;

end.
