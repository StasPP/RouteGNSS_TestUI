unit UOutRep;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList, RTKLibExecutor, TabFunctions,
  GeoString, GeoClasses, UGNSSProject, Geoid, GNSSObjects, ShellAPI,
  GeoFunctions;

type

  TRepSettings = record
    ID, Img  :Integer;
    Name, Description :String;
    Formats   :array[1..6] of Boolean;
    Settings  :array[1..7] of String;
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
    MDig2: TComboBox;
    CheckBox9: TCheckBox;
    ComboBox2: TComboBox;
    DegDig: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    RB1: TRadioButton;
    RB2: TRadioButton;
    CheckBox8: TCheckBox;
    SaveDialog1: TSaveDialog;
    Label8: TLabel;
    SepBox: TComboBox;
    SepLabel: TLabel;
    MDig: TComboBox;
    Label9: TLabel;
    procedure Button1Click(Sender: TObject);

    procedure OpenRepWindow(RepKind:Integer; RepObj, RepObj2: Integer; P:TBitMap);
    function getSep:char;


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
    procedure FboxChange(Sender: TObject);
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

function Ed(s:string):string;
  var I: integer;
begin
   result := '';
   for I := 1 to length(s)  do
   case s[I] of
     '/', '\', ':', '*', '?', '"', '<', '>', '|', ' ', #$D, #$A, #9: continue;
     else result := result + s[i];
   end;
end;

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
var S, F: TStringList;
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

  if ObjLabel.Caption<>'' then
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
  F := TStringList.Create;
  FmtStrings(Reports[RepList.ItemIndex].ID, S);
  if fmt = 2 then
  begin
     // ToDo: XLS save
  end
  else
    begin
      if (CheckBox7.Checked) and (OCS.Pages[2].TabVisible) then
        // ToDo: MultiSave
      else
      begin
        S.SaveToFile(FName);
        F.Add(FName);
      end;
    end;

  // ToDo: Translate
  If MessageDlg('Open the saved file?', mtConfirmation, [mbYes, mbNo], 0) = 6 Then
   For I := 0 to F.Count-1 do
     ShellExecute(Handle, 'open', PChar(F[I]),nil,nil,SW_SHOWNORMAL) ;

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

procedure TOutRep.FboxChange(Sender: TObject);
begin
  SepBox.Visible    := (Reports[RepList.ItemIndex].Settings[7] <> '0')
                      and ( FormatSt[1] = FBox.Items[FBox.ItemIndex] );
  SepLabel.Visible  := (Reports[RepList.ItemIndex].Settings[7] <> '0')
                      and ( FormatSt[1] = FBox.Items[FBox.ItemIndex] );
end;

procedure TOutRep.FmtStrings(FID: byte; var S:TStringList);
var S2 :TStringList;
    I, j, BN, RN :integer;
    Sol :TSolutionId;
    Sep :char;

    TOrg: TTopoOrigin;  El:TEllipsoid;  /// ENU -> XYZ for Diff Mode
    newXYZ: TCoord3D;
    CS: TCoordinateSystem;
    OutPt: Boolean;
begin
  Sep := getSep; 

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

         S.Add('-- ' + GNSSSolutionName(Sol.SessionN, Sol.SolutionN));

         for j := 0 to S2.Count - 1 do
            S.Add(S2[j]);
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
    7: begin
      // SHALOMITSKY!!!!!!!!!
       if Length(GNSSVectors) = 0 then
       begin
         S.Add('NO VECTOR DATA HERE');
       end;  

       Sep := ';';//#9
       S.Add('--COORDINATE SYSTEM');
       j := FindCoordinateSystem('WGS84_ECEF');
       El := EllipsoidList[FindEllipsoid('WGS84')];  /// CoordinateSystemList[j].Ellipsoid
       S.Add('WGS84' + Sep +  // CoordinateSystemList[j].Name
             El.Name + Sep +
             FloatToStr(El.a) + Sep +
             FloatToStr(El.alpha) + Sep +
             '0' + Sep +    /// IntToStr(CoordinateSystemList[j].ProjectionType)
             '0' + Sep +  '0' + Sep +  '0' + Sep +

             '0' + Sep +  '0' + Sep +  '0' + Sep +
             '0' + Sep +  '0' + Sep +  '0' + Sep +
             '0' + Sep +  '0' + Sep +  '0' );

       S.Add('--POINT COORDINATES');
       
       for I := 0 to Length(GNSSPoints)-1 do
       begin
         OutPt := false; // TEST IF I NEED TO OUTPUT THIS POINT (ONLY OF IT HAS VECTOR!)
         for j := 0 to Length(GNSSVectors) - 1 do
         if (GNSSVectors[j].StatusQ > 0) and (GNSSVectors[j].StatusQ <> 8) then
         begin
           BN := GetGNSSSessionNumber(GNSSVectors[j].BaseID);
           RN := GetGNSSSessionNumber(GNSSVectors[j].RoverID);

           if (BN<>-1) and (GNSSSessions[BN].Station = GNSSPoints[I].PointName) then
           begin
             OutPt := true;
             break;
           end
           else
           if (RN<>-1) and (GNSSSessions[RN].Station = GNSSPoints[I].PointName) then
           begin
             OutPt := true;
             break;
           end
         end;
         if OutPt then
         S.Add(GNSSPoints[I].PointName + Sep +
              FormatFloat('0.0000', GNSSPoints[I].Position.X)  + Sep +
              FormatFloat('0.0000', GNSSPoints[I].Position.Y)  + Sep +
              FormatFloat('0.0000', GNSSPoints[I].Position.Z)  + Sep +
              FormatFloat('0.0000', GNSSPoints[I].Quality[1])  + Sep +
              FormatFloat('0.0000', GNSSPoints[I].Quality[2])  + Sep +
              FormatFloat('0.0000', GNSSPoints[I].Quality[3])
         );
       end;

       S.Add('--VECTORS');


       for I := 0 to Length(GNSSVectors) - 1 do
          if (GNSSVectors[I].StatusQ > 0) and (GNSSVectors[I].StatusQ <> 8) then
          begin
//            Sol := GetGNSSSolutionForVector(GNSSVectors[I]);

            try
              BN := GetGNSSSessionNumber(GNSSVectors[I].BaseID);
              RN := GetGNSSSessionNumber(GNSSVectors[I].RoverID);

              if (BN = -1) or (RN = -1) then
                continue;

              // ToDO: if Necessary - To XYZ
              
              if DiffENU then
              begin
                El := EllipsoidList[FindEllipsoid('WGS84')];
                j  := GetGNSSSessionNumber(GNSSVectors[I].BaseId);
                TOrg := GetTopoOriginFromXYZ(Coord3D(GNSSSessions[j].AppliedPos),
                   false, El);
                newXYZ := NEHToXYZ(Coord3D(GNSSVectors[I].StDevs[2],
                                           GNSSVectors[I].StDevs[1],
                                           GNSSVectors[I].StDevs[3]), El, TOrg);
              end
              else
                newXYZ := Coord3D(GNSSVectors[I].StDevs[1],
                                  GNSSVectors[I].StDevs[2],
                                  GNSSVectors[I].StDevs[3]);
              S.Add(
              GNSSSessions[BN].Station  + Sep +
              GNSSSessions[RN].Station  + Sep +
         //     FormatFloat('0.000', GNSSSessions[BN].AntHgt.Hant)  + Sep +
         //     FormatFloat('0.000', GNSSSessions[RN].AntHgt.Hant)  + Sep +

              FormatFloat('0.0000', GNSSVectors[I].dX)  + Sep +
              FormatFloat('0.0000', GNSSVectors[I].dY)  + Sep +
              FormatFloat('0.0000', GNSSVectors[I].dZ)  + Sep +

              FormatFloat('0.0000', newXYZ[1])  + Sep +
              FormatFloat('0.0000', newXYZ[2])  + Sep +
              FormatFloat('0.0000', newXYZ[3])  + Sep {+

              FormatFloat('0.0000', GNSSVectors[I].StDevs[1])  + Sep +
              FormatFloat('0.0000', GNSSVectors[I].StDevs[4])  + Sep +
              FormatFloat('0.0000', GNSSVectors[I].StDevs[6])  + Sep +
              FormatFloat('0.0000', GNSSVectors[I].StDevs[4])  + Sep +
              FormatFloat('0.0000', GNSSVectors[I].StDevs[2])  + Sep +
              FormatFloat('0.0000', GNSSVectors[I].StDevs[5])  + Sep +
              FormatFloat('0.0000', GNSSVectors[I].StDevs[6])  + Sep +
              FormatFloat('0.0000', GNSSVectors[I].StDevs[5])  + Sep +
              FormatFloat('0.0000', GNSSVectors[I].StDevs[3])    }
              )
            except
            end;
          end;

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
  RepList.OnClick(nil);
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

function TOutRep.getSep: char;
begin
  case SepBox.ItemIndex of
    0: result := ' ';
    1: result := #9;
    else
     try
       result := SepBox.Text[1];
     except
       result := ' ';
     end;
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

    for k := 1 to 7 do
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
      ObjLabel.Caption := GNSSSolutionName(RPar1, RPar2);
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
      OCS.Pages[2].TabVisible := ((SplitAllowed) or (Settings[6] <> '0'));

      if RKind = 2 then
        OCS.Pages[2].TabVisible :=  (OCS.Pages[2].TabVisible) and (length(Vectors)>1);

      Repaint;

      CheckBox1.Visible := true;  CheckBox4.Visible := true;
      CheckBox2.Visible := true;  CheckBox5.Visible := true;
      CheckBox3.Visible := true;  CheckBox6.Visible := true;
      SepBox.Visible := true;     SepLabel.Visible := true;


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

      SepBox.Visible    := (Settings[7] <> '0') and ( FormatSt[1] = FBox.Items[FBox.ItemIndex] );
      SepLabel.Visible  := (Settings[7] <> '0') and ( FormatSt[1] = FBox.Items[FBox.ItemIndex] );

      FBox.Items.Clear;
      for I := 1 to 6 do     /// ToDo: Translate!
         if Formats[I] then FBox.Items.Add(FormatSt[I]);

      FBox.ItemIndex := 0;
   end;
      OCS.ActivePageIndex := 0;

   Repaint;
end;

end.
