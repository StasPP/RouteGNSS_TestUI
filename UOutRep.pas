unit UOutRep;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList, RTKLibExecutor, TabFunctions,
  GeoString, GeoClasses, UGNSSProject, Geoid, GNSSObjects;

type

  TRepSettings = record
    ID, Img  :Integer;
    Name, Description :String;
    Formats   :array[1..6] of Boolean;
    Settings  :array[1..6] of String;
    CSAllowed     :boolean;
    SplitAllowed  :boolean;
  end;

  TOutRep = class(TForm)
    Panel3: TPanel;
    Panel4: TPanel;
    Button6: TButton;
    Button1: TButton;
    Panel1: TPanel;
    RepList: TListBox;
    ImageList1: TImageList;
    OCS: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Fbox: TComboBox;
    Label1: TLabel;
    CSBox: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    GeoidBox: TComboBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Image3: TImage;
    SessionLabel: TLabel;
    StatusLabel: TLabel;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox6: TCheckBox;
    TabSheet4: TTabSheet;
    Label7: TLabel;
    StatImg: TImage;
    ObjLabel: TLabel;
    FC: TPageControl;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    ComboBox1: TComboBox;
    CheckBox9: TCheckBox;
    ComboBox2: TComboBox;
    ComboBox7: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    RB1: TRadioButton;
    RB2: TRadioButton;
    CheckBox8: TCheckBox;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);

    procedure OpenRepWindow(RepKind:Integer; RepObj, RepObj2: Integer; P:TBitMap);

    procedure RepListClick(Sender: TObject);
    procedure CSBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure FormShow(Sender: TObject);
    procedure GeoidBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure CSBoxChange(Sender: TObject);
    procedure Button6Click(Sender: TObject);

    procedure AddLine(var S:TStringList; str: string; fmt: byte);
    procedure FmtStrings(FID: byte; var S:TStringList);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OutRep: TOutRep;
  Reports: Array of TRepSettings;
  RepCount: Integer;
  RKind, RPar1, RPar2: Integer;

  Vectors: array of Integer;

  FormatSt: Array [1..6] of String = ('Text file ANSI *.txt',
        'HTML Web-page *.html', 'Excel Table *.xls',
        'RTKLib position file *.pos', '', '');

  FormatExt: Array [1..6] of String = ('.txt',
        '.html', '.xls','.pos', '', '');

  KindStr: Array[0..5] of String = ('Project Common Report',
        'Solution Report', 'Vector Report',
        'Point Report', '', '');

implementation

uses Unit1;

{$R *.dfm}

procedure TOutRep.AddLine(var S: TStringList; str: string; fmt: byte);
var I, j:Integer;
begin
  case fmt of
    0: begin

    end;
    1: begin

    end;
  end;
end;

procedure TOutRep.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TOutRep.Button6Click(Sender: TObject);
var S: TStringList;
    I, j, fmt :Integer;
    FName:String;
begin
  if RepList.ItemIndex < 0 then
    exit;

  fmt := 0;
  if FBox.ItemIndex >= 0 then
  for I := 1 to Length(FormatSt) do
    if FormatSt[I] = FBox.Items[FBox.ItemIndex] then
      fmt := I;

  SaveDialog1.Filter := FormatSt[fmt] +'|*'+ FormatExt[fmt];

  SaveDialog1.FileName := Ed(ObjLabel.Caption)+ FormatExt[fmt];

  if not SaveDialog1.Execute() then
    exit;

  FName := SaveDialog1.FileName;
  if AnsiLowerCase(Copy(FName, Length(FName)-3,4)) <> FormatExt[fmt] then
    FName := FName + FormatExt[fmt];
  if fileexists(FName) then
    if MessageDLG({inf[22]}'Rewrite file?' +#13 + FName, MtConfirmation, mbYesNo, 0) <> 6 then
      exit;

  S := TStringList.Create;
  FmtStrings(RKind, S);
  if fmt = 2 then
  begin
     // ToDo: XLS save
  end
  else
    S.SaveToFile(FName);
  S.Free;
//
end;

procedure TOutRep.CSBoxChange(Sender: TObject);
begin

 if CSBox.ItemIndex >= 0 then
 begin

    GeoidBox.Enabled := CoordinateSystemList[PrjCS[CSBox.ItemIndex]].ProjectionType <> 1;

    if CoordinateSystemList[PrjCS[CSBox.ItemIndex]].ProjectionType > 0 then
      FC.ActivePageIndex := 0
    else
      FC.ActivePageIndex := 1;
 end;
 Label3.Enabled := GeoidBox.Enabled;


 
end;

procedure TOutRep.CSBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  ComboBox: TComboBox;
  bitmap: TBitmap;
  I: Integer;
begin
  ComboBox := (Control as TComboBox);
  Bitmap := TBitmap.Create;
  try
    I := CoordinateSystemList[PrjCS[Index]].ProjectionType;
    case I of
       0: I := 110;
       1: I := 111;
       2..5: I := 112
    end;
    Form1.IcoList.GetBitmap(I, Bitmap);
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
      Rect := Bounds(Rect.Left + 2, Rect.Top,
                     Rect.Right -2, Rect.Bottom - Rect.Top);

      DrawText(handle, PChar(ComboBox.Items[Index]), length(ComboBox.Items[index]), Rect, DT_VCENTER+DT_SINGLELINE);
    end;
  finally
    Bitmap.Free;
  end;

end;

procedure TOutRep.FmtStrings(FID: byte; var S:TStringList);
var S2 :TStringList;
    I, j :integer;
    Sol :TSolutionId;
begin
  case FID of
    0: begin
      // Common Report
    end;
    1: begin
     // GNSS Processor Report SOL
      S2 := TStringList.Create;
      S2.LoadFromFile(GNSSSessions[RPar1].Solutions[RPar2].SolFileName);
      S.Assign(S2);
      S2.Free;
    end;
    2: begin
     // GNSS Processor Report Vect

       for I := 0 to Length(Vectors) - 1 do
       Begin
         Sol := GetGNSSSolutionForVector(Vectors[I]);
         S2 := TStringList.Create;
         S2.LoadFromFile(GNSSSessions[Sol.SessionN].Solutions[Sol.SolutionN].SolFileName);
         S.Assign(S2);
         S2.Free;
       End;

    end;
    3: begin
     // Vector Short Report


    end;
    4: begin
     // Vector List Short Report
    end;
    5: begin
     // Point Short Report
    end;
    6: begin
     // Point List
    end;
  end;

end;

procedure TOutRep.FormShow(Sender: TObject);
var I, j:Integer;
begin
  // COORDINATE SYSTEMS -----------------

  j := CSbox.ItemIndex;

  CSBox.Items.Clear;
  for I := 0 to Length(PrjCS) - 1 do
    CSBox.Items.Add(CoordinateSystemList[PrjCS[I]].Caption);

  if j = -1 then
    j := CSbox.Items.Count-1;
  CSbox.ItemIndex := j;
//  CSBox.OnChange(nil);

// GEOIDS!!!
  j := GeoidBox.ItemIndex;

  GeoidBox.Items.Clear;
  GeoidBox.Items.Add('Off'); // ToDo: Translate
  for I := 0 to Length(GeoidList) - 1 do
    GeoidBox.Items.Add(GeoidList[I].Caption);

  if j = -1 then
    j := Geoidbox.Items.Count-1;
  GeoidBox.ItemIndex := j;
//  GeoidBox.OnChange(nil);

end;

procedure TOutRep.GeoidBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  ComboBox: TComboBox;
  bitmap: TBitmap;
  I: Integer;
begin

  ComboBox := (Control as TComboBox);
  if ComboBox.Enabled = false then
    exit;
  Bitmap := TBitmap.Create;
  try
    if Index > 0 then
      Form1.IcoList.GetBitmap(113, Bitmap);
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

      Rect := Bounds(Rect.Left + 2, Rect.Top,
                     Rect.Right -2, Rect.Bottom - Rect.Top);

      DrawText(handle, PChar(ComboBox.Items[Index]), length(ComboBox.Items[index]),
              Rect, DT_VCENTER+DT_SINGLELINE);
    end;
  finally
    Bitmap.Free;
  end;

end;

procedure TOutRep.OpenRepWindow(RepKind:Integer; RepObj, RepObj2: Integer;
    P:TBitmap);
var S: TStringList;
    lang, st, BS, RS :String;
    I, j, k: Integer;
begin
  ///
  RepList.Clear;
  StatImg.Picture.Assign(P);

  SetLength(Reports, 0);
  /// ToDo: OTHER Languages
  lang := 'English';
  S := TStringList.Create;
  S.LoadFromFile(RTKWorkDir +'Data\Reports\'+lang+'.loc');
  for I := 1 to S.Count - 1 do
  if StrToFloat2(GetCols(S[I], 1, 1, 1, False)) = RepKind  then
  begin
    j := Length(Reports);
    SetLength(Reports, j+1);
    Reports[j].ID   := Trunc(StrToFloat2(GetCols(S[I], 0, 1, 1, False)));
    Reports[j].Name := GetCols(S[I], 2, 1, 1, False);
    Reports[j].Description := GetCols(S[I], 3, 1, 1, False);
    Reports[j].Img  := Trunc(StrToFloat2(GetCols(S[I], 4, 1, 1, False)));
    for k := 1 to 6 do
       Reports[j].Formats[k] := (Trunc(StrToFloat2(GetCols(S[I], 4+k, 1, 1, False))) = 1);

    Reports[j].CSAllowed := Trunc(StrToFloat2(GetCols(S[I], 11, 1, 1, False))) = 1;
    Reports[j].SplitAllowed := Trunc(StrToFloat2(GetCols(S[I], 12, 1, 1, False))) = 1;

    for k := 1 to 6 do
       Reports[j].Settings[k]  := GetCols(S[I], 12+k, 1, 1, False);

  end;

  for I := 0 to Length(Reports) - 1 do
    RepList.Items.Add(Reports[I].Name);

  RepCount := 1;

  StatusLabel.Caption := KindStr[RepKind];
  if RepKind > 0 then StatusLabel.Caption := StatusLabel.Caption +': ';
  ObjLabel.Left := StatusLabel.Left+StatusLabel.Width;
  ObjLabel.Caption := '';

  RKind := RepKind;
  RPar1 := RepObj;
  RPar2 := RepObj2;

  try
  case RepKind of
    1:
    begin
      st := '';
      case GNSSSessions[RPar1].Solutions[RPar2].SolutionKind of
          0: st := 'RINEX Approx position';                                     ////// ToDo:Translate
          1: st := 'Single solution';
          2: st := '('+GNSSSessions[GetGNSSSessionNumber(
                    GNSSSessions[RPar1].Solutions[RPar2].BaseID) ].MaskName
                    + ' -> ' + GNSSSessions[RPar1].MaskName +')';
          3: st := 'PPP solution';
      end;
      ObjLabel.Caption := GNSSSessions[RPar1].MaskName + ' - ' + st;
    end;
    2:
    begin
      if Rpar1 = -1 then
      begin
        ObjLabel.Caption :=
          GNSSSessions[GetGNSSSessionNumber(GNSSVectors[RPar2].BaseID)].MaskName
          + ' -> ' +
          GNSSSessions[GetGNSSSessionNumber(GNSSVectors[RPar2].RoverID)].MaskName;

        SetLength(Vectors, 1);
        Vectors[0] := RPar2;
      end
      else
      begin
        ObjLabel.Caption :=  GNSSPoints[RPar1].PointName + ' -> ' +
              GNSSPoints[RPar2].PointName;

        SetLength(Vectors, 0);

        for I := 0 to Length(GNSSVectors) - 1 do
        Begin
          BS :=  GetGNSSVectorPoint(I, true);
          RS :=  GetGNSSVectorPoint(I, false);

          if (RS = GNSSPoints[RPar2].PointName) and
             (BS = GNSSPoints[RPar1].PointName) then

          begin
            SetLength(Vectors, Length(Vectors)+1);
            Vectors[Length(Vectors) - 1] := I;
          end;
        End;


      end;
    end;
    3: ObjLabel.Caption := GNSSPoints[RPar1].PointName;
  end;
  except
  end;

  RepList.ItemIndex := 0;
  RepList.OnClick(nil);

  S.Free;
  Showmodal;
end;

procedure TOutRep.RepListClick(Sender: TObject);
var I:Integer;
begin
   if RepList.ItemIndex = -1 then
   begin
     OCS.Pages[0].TabVisible := false;
     OCS.Pages[1].TabVisible := false;
     OCS.Pages[2].TabVisible := false;
     OCS.ActivePageIndex := 3;
     exit;
   end;

   with Reports[RepList.ItemIndex] do
   begin
      OCS.Pages[0].TabVisible := true;
      OCS.Pages[1].TabVisible := CSAllowed;
      OCS.Pages[2].TabVisible := (SplitAllowed) or (Settings[6] <> '0');

      CheckBox1.Caption := Settings[1];
      CheckBox1.Visible := Settings[1] <> '0';
      CheckBox2.Caption := Settings[2];
      CheckBox2.Visible := Settings[2] <> '0';
      CheckBox3.Caption := Settings[3];
      CheckBox3.Visible := Settings[3] <> '0';
      CheckBox4.Caption := Settings[4];
      CheckBox4.Visible := Settings[4] <> '0';
      CheckBox5.Caption := Settings[5];
      CheckBox5.Visible := Settings[5] <> '0';
      CheckBox6.Caption := Settings[6];
      CheckBox6.Visible := Settings[6] <> '0';

      FBox.Items.Clear;
      for I := 1 to 6 do     /// ToDo: Translate!
         if Formats[I] then FBox.Items.Add(FormatSt[I]);

      FBox.ItemIndex := 0;
   end;
      OCS.ActivePageIndex := 0;
end;

end.