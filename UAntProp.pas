unit UAntProp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GNSSObjects, Grids, ValEdit, GeoString;

type
  TFAntProp = class(TForm)
    NameEd: TEdit;
    Label1: TLabel;
    Button1: TButton;
    GroupBox1: TGroupBox;
    EAntU: TEdit;
    Label18: TLabel;
    Label17: TLabel;
    EAntE: TEdit;
    EAntN: TEdit;
    Label16: TLabel;
    VBL1: TValueListEditor;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EAntU2: TEdit;
    EAntE2: TEdit;
    EAntN2: TEdit;
    Button2: TButton;
    Label5: TLabel;
    Label6: TLabel;
    VBL2: TValueListEditor;
    Label8: TLabel;
    EDiscr: TEdit;
    GroupBox3: TGroupBox;
    Label7: TLabel;
    EdRad: TEdit;
    Label9: TLabel;
    EGrPl: TEdit;
    Label10: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ShowAntProp(AntName:string);
  private
    { Private declarations }
  public
    { Public declarations }
    AntAccepted: boolean;
    AntPCV  :TGNSSAntennaPCV;

  end;

var
  FAntProp: TFAntProp;
  
implementation

{$R *.dfm}

procedure AcceptAnt;
var I:Integer;
begin
  with FAntProp do
  begin
    AntPCV.AntName := NameEd.Text;
    ANTPCV.AntDescripton := EDiscr.Text;
    

    AntPCV.L1N := StrToFloat2(EAntN.Text);
    AntPCV.L1E := StrToFloat2(EAntE.Text);
    AntPCV.L1H := StrToFloat2(EAntU.Text);

    AntPCV.L2N := StrToFloat2(EAntN2.Text);
    AntPCV.L2E := StrToFloat2(EAntE2.Text);
    AntPCV.L2H := StrToFloat2(EAntU2.Text);

    AntPCV.Radius := StrToFloat2(EdRad.Text);
    ANTPCV.GroundPlaneH := StrToFloat2(EGrPl.Text);

    for I := 0 to 18 do
      if StrToFloat2(VBL1.Cells[1, I+1]) <> AntPCV.L1Corr[I] then
        AntPCV.L1Corr[I] := StrToFloat2(VBL1.Cells[1, I+1]);

    for I := 0 to 18 do
      if StrToFloat2(VBL2.Cells[1, I+1]) <> AntPCV.L2Corr[I] then
        AntPCV.L2Corr[I] := StrToFloat2(VBL2.Cells[1, I+1]);
  end;

end;

function isHasChanges:boolean;
var I:Integer;
begin
  result := false;

  with FAntProp do
  begin
    result := NameEd.Text <> AntPCV.AntName;

    if not result then result := StrToFloat2(EAntN.Text)  <> AntPCV.L1N;
    if not result then result := StrToFloat2(EAntE.Text)  <> AntPCV.L1E;
    if not result then result := StrToFloat2(EAntU.Text)  <> AntPCV.L1H;

    if not result then result := StrToFloat2(EAntN2.Text) <> AntPCV.L2N;
    if not result then result := StrToFloat2(EAntE2.Text) <> AntPCV.L2E;
    if not result then result := StrToFloat2(EAntU2.Text) <> AntPCV.L2H;

    if not result then result :=  StrToFloat2(EdRad.Text) <> AntPCV.Radius;

    if not result then
      for I := 0 to 18 do
        if StrToFloat2(VBL1.Cells[1, I+1]) <> AntPCV.L1Corr[I] then
        begin
          result := true;
          break;
        end;

     if not result then
      for I := 0 to 18 do
        if StrToFloat2(VBL2.Cells[1, I+1]) <> AntPCV.L2Corr[I] then
        begin
          result := true;
          break;
        end;
  end;

end;

procedure TFAntProp.Button1Click(Sender: TObject);
var I:Integer;
begin
  if ANTPCV.LineN > -1 then
    if isHasChanges then
    begin
      if MessageDlg('Change the existing Antenna "'+ANTPCV.AntName+'" ?',    /// ToDo: Translate!
          mtConfirmation, [mbYes, mbNo], 0) <> 6 then
        exit
      else
        if ANTPCV.AntName = PCVFile[ANTPCV.LineN] then
          MessageDlg(ANTPCV.AntName+' is Already exists.'+#13+
              'Type the new unique name for the Antenna to save it.',   /// ToDo: Translate!
              mtError, [mbOK], 0)
        else
          ANTPCV.LineN := -1;

    end;
      

  if (isHasChanges) or (ANTPCV.LineN = -1) then
    AcceptAnt;

  AntAccepted := true;

  close;
end;

procedure TFAntProp.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TFAntProp.ShowAntProp(AntName: string);
var I: Integer;
begin
  AntName := AnsiUpperCase(AntName);
  ANTPCV := GetAntParams(AntName);
  AntAccepted := false;
  NameEd.Text := ANTPCV.AntName;
  EDiscr.Text := ANTPCV.AntDescripton;
  

  EAntN.Text  := FormatFloat('0.0', ANTPCV.L1N);
  EAntE.Text  := FormatFloat('0.0', ANTPCV.L1E);
  EAntU.Text  := FormatFloat('0.0', ANTPCV.L1H);

  EAntN2.Text := FormatFloat('0.0', ANTPCV.L2N);
  EAntE2.Text := FormatFloat('0.0', ANTPCV.L2E);
  EAntU2.Text := FormatFloat('0.0', ANTPCV.L2H);

  EdRad.Text  := FormatFloat('0', AntPCV.Radius);
  EGrPl.Text  := FormatFloat('0', ANTPCV.GroundPlaneH);
  
  for I := 0 to 18 do
    VBL1.Cells[1, I + 1] := FormatFloat('0.0', ANTPCV.L1Corr[I]);
  for I := 0 to 18 do
    VBL2.Cells[1, I + 1] := FormatFloat('0.0', ANTPCV.L2Corr[I]);

  ShowModal;
end;

end.
