unit UGNSSSessionOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GNSSObjects, StdCtrls, ComCtrls, ExtCtrls, Buttons, jpeg,
  RTKLibExecutor, GeoFunctions, GeoString, Geoid, UWinManager, Menus,
  UGNSSProject, GNSSObjsTree, UVectSettings;

type
  TFGNSSSessionOptions = class(TForm)
    Image1: TImage;
    SessionLabel: TLabel;
    StatusLabel: TLabel;
    Image2: TImage;
    Image3: TImage;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    ModeBox: TComboBox;
    Label1: TLabel;
    TabSheet4: TTabSheet;
    Label2: TLabel;
    FNameEdit: TEdit;
    Label3: TLabel;
    t1: TEdit;
    Label4: TLabel;
    t2: TEdit;
    CommentMemo: TMemo;
    Label5: TLabel;
    Label8: TLabel;
    CloseBtn: TButton;
    Label12: TLabel;
    RinV: TEdit;
    TabSheet5: TTabSheet;
    Label13: TLabel;
    NavFiles: TListBox;
    DelNav: TSpeedButton;
    AddNav: TSpeedButton;
    Label14: TLabel;
    PPPFiles: TListBox;
    AddPPP: TSpeedButton;
    DelPPP: TSpeedButton;
    Label15: TLabel;
    AntNameBox: TComboBox;
    EAntdN: TEdit;
    EAntdE: TEdit;
    EAntHgt: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    AntMethodBox: TComboBox;
    Label19: TLabel;
    Image4: TImage;
    OpenDialog: TOpenDialog;
    GetSingle: TSpeedButton;
    GetPPP: TSpeedButton;
    AvSol: TListBox;
    AvProc: TListBox;
    Label7: TLabel;
    RinAnalyse: TSpeedButton;
    TabSheet6: TTabSheet;
    StPan: TPanel;
    StationBox: TComboBox;
    StationLab: TLabel;
    ListBox2: TListBox;
    ProcBL: TSpeedButton;
    SolInfoPan: TPageControl;
    TabSheet7: TTabSheet;
    ChoosedSol: TLabel;
    DelSol: TSpeedButton;
    RecomputeBtn: TSpeedButton;
    TabSheet8: TTabSheet;
    Label6: TLabel;
    TabSheet9: TTabSheet;
    SpeedButton3: TSpeedButton;
    Label24: TLabel;
    Label25: TLabel;
    TrackLab: TLabel;
    StatImg: TImage;
    SolStatImg: TImage;
    ProcAllBL: TSpeedButton;
    CustAnt: TSpeedButton;
    VectRepI: TSpeedButton;
    ZEd: TEdit;
    ZLabel: TLabel;
    YLabel: TLabel;
    YEd: TEdit;
    XEd: TEdit;
    XLabel: TLabel;
    CSbox: TComboBox;
    Label9: TLabel;
    Edit5: TEdit;
    GeoidP: TPanel;
    ChangeGeoid: TSpeedButton;
    GeoidPopup: TPopupMenu;
    VectBtn: TSpeedButton;
    PointPropBtn: TSpeedButton;
    DownloadPPP: TSpeedButton;
    SpeedButton1: TSpeedButton;
    StopResults: TPageControl;
    TabSheet10: TTabSheet;
    TabSheet11: TTabSheet;
    Label10: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    ComboBox1: TComboBox;
    Edit4: TEdit;
    ComboBox2: TComboBox;
    Image5: TImage;
    Label11: TLabel;
    Edit6: TEdit;
    Label26: TLabel;
    Edit7: TEdit;
    Label27: TLabel;
    Edit8: TEdit;
    Label28: TLabel;
    Edit9: TEdit;
    Label29: TLabel;
    SpeedButton2: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure TabSheet5Show(Sender: TObject);
    procedure ModeBoxChange(Sender: TObject);
    procedure RinAnalyseClick(Sender: TObject);
    procedure DelNavClick(Sender: TObject);
    procedure NavFilesClick(Sender: TObject);
    procedure PPPFilesClick(Sender: TObject);
    procedure AddNavClick(Sender: TObject);
    procedure AddPPPClick(Sender: TObject);
    procedure DelPPPClick(Sender: TObject);
    procedure GetSingleClick(Sender: TObject);
    procedure PointPropBtnClick(Sender: TObject);
    procedure CustomAntClick(Sender: TObject);
    procedure AvSolClick(Sender: TObject);
    procedure AvProcClick(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure GetPPPClick(Sender: TObject);
    procedure RecomputeBtnClick(Sender: TObject);
    procedure ProcBLClick(Sender: TObject);
    procedure StationBoxChange(Sender: TObject);
    procedure DelSolClick(Sender: TObject);
    procedure AvSolDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure AvProcDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure AntNameBoxChange(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NavFilesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure PPPFilesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ProcAllBLClick(Sender: TObject);

    procedure CheckAntennaPOSChange;
    procedure CheckAntennaChange;
    procedure ShowStatus(Stat:integer);

    procedure RefreshCSBox;
    procedure GeoidPopupPopup(Sender: TObject);
    procedure GeoidPopupClick(Sender: TObject);
    procedure OutputCoordinates;
    procedure CSboxChange(Sender: TObject);
    procedure ChangeGeoidClick(Sender: TObject);
    procedure VectBtnClick(Sender: TObject);
    procedure ChoosedSolClick(Sender: TObject);
    procedure ChoosedSolMouseEnter(Sender: TObject);
    procedure ChoosedSolMouseLeave(Sender: TObject);
  private
    { Private declarations }

  public
    procedure RefreshSettings;
    procedure ShowGNSSSessionInfo(AGNSSSessions:Array of Integer; Img :TImageList); overload;
    procedure ShowGNSSSessionInfo(AGNSSSession:Integer; Img :TImageList); overload;
    procedure ShowGNSSSessionInfo(AGNSSSession:Integer; Img :TImageList; Sol: integer); overload;
    { Public declarations }
  end;


  type StopPointN = record
    SessionN, StopN :integer;
  end;

  type TProcArr = record
    BaseId, RoverId :string;
    Method :byte;
  end;
var
  FGNSSSessionOptions: TFGNSSSessionOptions;
  ActiveGNSSSessions:Array of Integer;

  Reloaded :Boolean = true;
  EditableStopPoints:array of StopPointN;

  AvProcArr :Array of TProcArr;

  ImgList   :TImageList;
  ShowSol   :Integer = -1;
  GeoidIdx :integer = -1;
implementation

uses FLoader, UStartProcessing, UGNSSPointSettings, UAntProp, GeoClasses;

{$R *.dfm}

procedure TFGNSSSessionOptions.CheckAntennaPOSChange;
var I, j, SolN, SessionN: integer;
    dE, dN, dH, realH: Double;
    newXYZ :TCoord3D;
    TOrg: TTopoOrigin;  El:TEllipsoid;
    WarnMe, isChanged: boolean;
begin
  isChanged := false;

  for I := 0 to Length(ActiveGNSSSessions) - 1 do
  begin
     // 1) Compare dE, dN

     dN := StrToFloat2(EAntdN.Text) -
           GNSSSessions[ActiveGNSSSessions[I]].Antenna.dN;
     dE := StrToFloat2(EAntdE.Text) -
           GNSSSessions[ActiveGNSSSessions[I]].Antenna.dE;

     isChanged := (abs(dN) >= 0.001) or (abs(dE) >= 0.001);
     if isChanged then
       break;

     // 2) Recompute AntH from AntH_u and compare

     realH := StrToFloat2(EAntHgt.Text);
     realH := GetAntH(realH, AntNameBox.Text,
                      AntMethodBox.ItemIndex);
     dH := realH -
           GNSSSessions[ActiveGNSSSessions[I]].AntHgt.Hant;

     isChanged := (abs(dH) >= 0.001);
     if isChanged then
       break
  end;

  // 2.5) Ask user!
  if not isChanged then
    exit
  else
  if Length(GNSSSessions[ActiveGNSSSessions[I]].Solutions) > 1 then
  if MessageDLG('The Antenna position has been changed. Apply?',
        mtConfirmation, [mbYes, mbNo], 0) <> 6 then
    exit;

  // 3) Apply
  for I := 0 to Length(ActiveGNSSSessions) - 1 do
  begin
     // 3.1 Calculate Deltas
     dN := StrToFloat2(EAntdN.Text) -
           GNSSSessions[ActiveGNSSSessions[I]].Antenna.dN;
     dE := StrToFloat2(EAntdE.Text) -
           GNSSSessions[ActiveGNSSSessions[I]].Antenna.dE;
     realH := StrToFloat2(EAntHgt.Text);
     realH := GetAntH(realH, AntNameBox.Text, AntMethodBox.ItemIndex);
     dH := realH -
           GNSSSessions[ActiveGNSSSessions[I]].AntHgt.Hant;

     // 3.2 Assign
     GNSSSessions[ActiveGNSSSessions[I]].Antenna.dN     :=
        StrToFloat2(EAntdN.Text);
     GNSSSessions[ActiveGNSSSessions[I]].Antenna.dE     :=
        StrToFloat2(EAntdE.Text);
     GNSSSessions[ActiveGNSSSessions[I]].AntHgt.Hant    :=
        realH;
     GNSSSessions[ActiveGNSSSessions[I]].AntHgt.Hant_u  :=
        StrToFloat2(EAntHgt.Text);
     GNSSSessions[ActiveGNSSSessions[I]].AntHgt.Hkind   :=
        AntMethodBox.ItemIndex;

     // 3.3 if not the same - go to solutions - recompute XYZ + d(XYZ) by ENU
     if (abs(dN) >= 0.001) or (abs(dE) >= 0.001) or (abs(dH) >= 0.001) then
     begin
        // TODO!
        for j := 1 to Length(GNSSSessions[ActiveGNSSSessions[I]].Solutions) - 1 do
        with GNSSSessions[ActiveGNSSSessions[I]].Solutions[j] do
        if SolutionKind >= 1 then
        begin
          El := EllipsoidList[FindEllipsoid('WGS84')];
          TOrg := GetTopoOriginFromXYZ(Coord3D(PointPos), false, El);
          newXYZ := NEHToXYZ(Coord3D(-dN, -dE, -dH), El, TOrg);

          PointPos.X := newXYZ[1];
          PointPos.Y := newXYZ[2];
          PointPos.Z := newXYZ[3];
        end;
        // 4) refresh station
        j := GetGNSSPointNumber(GNSSSessions[ActiveGNSSSessions[I]].Station);
        if j > -1 then
        begin
          {if GNSSPoints[j].CoordSource = 4 then
          begin
             El     := EllipsoidList[FindEllipsoid('WGS84')];
             TOrg   := GetTopoOriginFromXYZ(Coord3D(GNSSPoints[j].Position),
                 false, El);
             newXYZ := NEHToXYZ(Coord3D(-dN, -dE, -dH), El, TOrg);
             GNSSPoints[j].Position.X :=  newXYZ[1];
             GNSSPoints[j].Position.Y :=  newXYZ[2];
             GNSSPoints[j].Position.Z :=  newXYZ[3];
          end
          else}
          RefreshGNSSPoint(j);
        end;
     end;
  end;

end;

procedure TFGNSSSessionOptions.ChoosedSolClick(Sender: TObject);
begin
  if VectBtn.Visible then
    VectBtn.Click;
end;

procedure TFGNSSSessionOptions.ChoosedSolMouseEnter(Sender: TObject);
begin
  if VectBtn.Visible then
  begin
    if not (fsUnderline in ChoosedSol.Font.Style) then
      ChoosedSol.Font.Style := ChoosedSol.Font.Style + [fsUnderline];
  end
  else
    if fsUnderline in ChoosedSol.Font.Style then
      ChoosedSol.Font.Style := ChoosedSol.Font.Style - [fsUnderline];
end;

procedure TFGNSSSessionOptions.ChoosedSolMouseLeave(Sender: TObject);
begin
   if fsUnderline in ChoosedSol.Font.Style then
      ChoosedSol.Font.Style := ChoosedSol.Font.Style - [fsUnderline];
end;

procedure TFGNSSSessionOptions.ChangeGeoidClick(Sender: TObject);
var P: TPoint;
begin
  P := Mouse.CursorPos;
  GeoidPopup.Popup(P.X, P.Y);
end;

procedure TFGNSSSessionOptions.CheckAntennaChange;
var I, j, SolN, SessionN: integer;
    WarnMe, isChanged: boolean;
begin
    isChanged := false;

    for I := 0 to Length(ActiveGNSSSessions) - 1 do
    if GNSSSessions[ActiveGNSSSessions[I]].Antenna.AntName <>
       AntNameBox.Text  then
      isChanged := true;

    if not isChanged then
      exit;

    WarnMe := false;
    for I := 0 to Length(ActiveGNSSSessions) - 1 do
    begin
      for j := 0 to Length(GNSSVectors) - 1 do
        if ( (GNSSVectors[j].RoverID = GNSSSessions[ActiveGNSSSessions[I]].SessionID) or
             (GNSSVectors[j].BaseID  = GNSSSessions[ActiveGNSSSessions[I]].SessionID) )
          and (GNSSVectors[j].StatusQ > 0) then
          begin
            WarnMe := true;
            break
          end;
      if WarnMe then
        break;
    end;

    if WarnMe then
      if messagedlg('The Antenna Name is changed.'+#13+
         ' This may change the other stations. Proceed?',    // Todo : TRANSLATE
         mtConfirmation, [mbYes, mbNo], 0) <> 6 then
        exit;

    for I := 0 to Length(ActiveGNSSSessions) - 1 do
    begin
        for j := 0 to Length(GNSSVectors) - 1 do
          if ( (GNSSVectors[j].RoverID = GNSSSessions[ActiveGNSSSessions[I]].SessionID) or
           (GNSSVectors[j].BaseID  = GNSSSessions[ActiveGNSSSessions[I]].SessionID) )
            and (GNSSVectors[j].StatusQ > 0) then
          begin
            SessionN := GetGNSSSessionNumber(GNSSVectors[j].RoverID);
            SolN := GetGNSSSolutionForVector(SessionN,GNSSVectors[j].BaseID);
            if (SolN <> -1)and(SessionN <> -1) then
              DeleteGNSSSolution(SessionN, SolN);
            GNSSVectors[j].StatusQ := 0;
          end;

        GNSSSessions[ActiveGNSSSessions[I]].Antenna.AntName :=
           AntNameBox.Text;
    end;

end;


procedure TFGNSSSessionOptions.ShowStatus(Stat:integer);
var I:Integer;
        // ToDo: Translate or replace with Inf[...]
const StatList :Array[0..7] of String = ('Not Processed',
                                         'Has Fixed Solution',
                                         'Has Float Solution',
                                         'Has SBAS Solution',
                                         'Has DGPS Solution',
                                         'Has Single Solution',
                                         'Has PPP Solution',
                                         '(Mixed)'
                                         );
begin

    with StatImg.Canvas do
    begin
      Brush.Color := clBtnFace;
      Fillrect(Rect(0, 0, Width, Height));
      ImgList.Draw(StatImg.Canvas, 0, 0, Stat+22);
    end;
    StatusLabel.Caption := StatList[Stat];

end;

{ TFGNSSSessionOptions }

function PPPAvailable(Session:TGNSSSession):boolean;  overload
var   I, j :Integer;  s:string;
      hasSP3 :boolean;
      hasCLK :boolean;
begin
    result := false;
    with Session do
    begin
       hasSP3 := false;
       hasCLK := false;
       for I := 0 to length(AdditionalFiles) - 1 do
       begin
         s := AnsiLowerCase(ExtractFileExt(AdditionalFiles[i]));
         if s = '.sp3' then
            hasSP3 := true;
         if s = '.clk' then
            hasCLK := true;
       end;

       result := hasSP3 and hasCLK;
    end;
end;

function PPPAvailable(SessionN:Integer):boolean;  overload
var N:Integer;
begin
  result := PPPAvailable(GNSSSessions[SessionN]);
end;

function SingleAvailable(Session:TGNSSSession):boolean; overload
var I :Integer; s:string;
begin
    result := false;
    with Session do
    begin
       for I := 0 to length(AdditionalFiles) - 1 do
       begin
         s := AnsiLowerCase(AdditionalFiles[i][length(AdditionalFiles[i])]);
         if (s = 'g') or (s = 'n') or (s = 'i') or (s = 'j')
                      or (s = 'c') or (s = 'l') then
         begin
           result := true;
           break;
         end;
       end;
    end;
end;

function SingleAvailable(SessionN:Integer):boolean; overload
begin
   result := SingleAvailable(GNSSSessions[SessionN]);
end;


procedure HorScrollBar(ListBox: TListBox; MaxWidth: Integer);
var
  i, w: Integer;
begin
  if ListBox.Items.Count = 0 then
  begin
     SendMessage(ListBox.Handle, LB_SETHORIZONTALEXTENT, 0, 0);
     exit;
  end;


  if MaxWidth = 0 then
    SendMessage(ListBox.Handle, LB_SETHORIZONTALEXTENT, MaxWidth, 0)
  else
  begin
    { get largest item }
    for i := 0 to ListBox.Items.Count - 1 do
      with ListBox do
      begin
        w := Canvas.TextWidth(Items[i]) +20;
        if w > MaxWidth then
          MaxWidth := w;
      end;
    if MaxWidth > ListBox.Width then
        SendMessage(ListBox.Handle, LB_SETHORIZONTALEXTENT,
          MaxWidth + GetSystemMetrics(SM_CXFRAME), 0)
    else
        SendMessage(ListBox.Handle, LB_SETHORIZONTALEXTENT, 0, 0);
  end;
end;

procedure TFGNSSSessionOptions.RecomputeBtnClick(Sender: TObject);
var j, N:Integer;
begin
  j := AvSol.ItemIndex;
  if AvSol.ItemIndex > -1 then
  begin

     with GNSSSessions[ActiveGNSSSessions[0]] do
     case Solutions[AvSol.ItemIndex].SolutionKind of
       1: GetSingle.Click;
       3: GetPPP.Click;
       2: begin
         N := GetGNSSSessionNumber(Solutions[AvSol.ItemIndex].BaseID);
         if N<> -1 then
            FStartProcessing.ShowProcOptions(2,ActiveGNSSSessions[0],
                N);
       end;
     end;
     RefreshSettings;
     AvSol.ItemIndex := j;
     AvSol.OnClick(nil);
     //ShowStatus(GNSSSessions[ActiveGNSSSessions[0]].StatusQ);
  end;

end;

procedure TFGNSSSessionOptions.RefreshCSBox;
var I, j:Integer;
    PopupItm : TMenuItem;
begin
  // COORDINATE SYSTEMS -----------------

  j := CSbox.ItemIndex;

  CSBox.Items.Clear;
  for I := 0 to Length(PrjCS) - 1 do
    CSBox.Items.Add(CoordinateSystemList[PrjCS[I]].Caption);

  if j = -1 then
    j := CSbox.Items.Count-1;
  CSbox.ItemIndex := j;
  CSBox.OnChange(nil);

  // GEOID -------------------------------

  if (GeoidIdx > Length(GeoidList) -1 ) or (GeoidIdx = -1) then
    GeoidIdx  := Length(GeoidList) -1;

  GeoidPopup.Images := ImgList;
  GeoidPopup.Items.Clear;
  PopupItm := TMenuItem.Create(nil);
  PopupItm.Caption := '(off)';  PopupItm.Tag := -1;
  PopupItm.OnClick := GeoidPopupClick;
  PopupItm.ImageIndex := -1;

  GeoidPopup.Items.Add(PopupItm);

  for I := 0 to Length(GeoidList) - 1 do
  begin
    PopupItm := TMenuItem.Create(nil);
    PopupItm.Caption := Trim(GeoidList[I].Caption);
    PopupItm.Tag := I;
    PopupItm.OnClick := GeoidPopupClick;
    GeoidPopup.Items.Add(PopupItm);
  end;

  ECEFWGS := FindCoordinateSystem('WGS84_ECEF');
  WGSCS   := FindCoordinateSystem('WGS84_LatLon');
end;

procedure TFGNSSSessionOptions.RefreshSettings;

  function CheckStops:boolean;
  var j:integer;
  begin
     result := false;
     for j := 0 to Length(ActiveGNSSSessions) - 1 do
       if Length(GNSSSessions[ActiveGNSSSessions[j]].Stops)> 0 then
        begin
          result := true;
          break;
        end;
  end;

  var I, j, Stat:Integer;
      s:string;
      HasSingle, HasPPP: Boolean;

begin
  ModeBox.Font.Color := clWindowText;
  StationBox.Font.Color := clWindowText;
  AntNameBox.Font.Color := clWindowText;
  EAntdN.Font.Color := clWindowText;
  EAntdE.Font.Color := clWindowText;
  EAntHgt.Font.Color := clWindowText;
  AntMethodBox.Font.Color := clWindowText;
  Stat := 7;
  ModeBox.Enabled := not isStaticOnly;

  StationBox.Clear;
  for I := 0 to Length(GNSSPoints) - 1 do
  begin
    // Static Only!!!
    if Length(GNSSPoints[I].Sessions) > 0 then
    begin
      j := GetGNSSSessionNumber(GNSSPoints[I].Sessions[0]);
      if j <> -1 then
         if not GNSSSessions[j].isKinematic then
            StationBox.Items.Add(GNSSPoints[I].PointName);
    end;
  end;

  for I := 0 to Length(ActiveGNSSSessions) - 1 do
  if ActiveGNSSSessions[I] > Length(GNSSSessions)-1 then
  begin
    close;
    exit;
  end;


  if length(ActiveGNSSSessions) = 1 then
  with GNSSSessions[ActiveGNSSSessions[0]] do
  begin
     SessionLabel.Caption := MaskName;
    // notVisible.Checked := not isVisible;
     if GNSSSessions[ActiveGNSSSessions[0]].isKinematic then
     begin
       ModeBox.ItemIndex  := 1;
       if Length(GNSSSessions[ActiveGNSSSessions[0]].Stops) > 1 then
          ModeBox.ItemIndex  := 2;
     end
     else
       ModeBox.ItemIndex  := 0;

     Stat := StatusQ;
     StationBox.Text := Station;

     AntNameBox.Items.Clear;

     for I := 0 to Length(GNSSAntNames) - 1 do
        AntNameBox.Items.Add(GNSSAntNames[I]);

     AntNameBox.Text := Antenna.AntName;
     EAntdN.Text := FloatToStr(Antenna.dN);
     EAntdE.Text := FloatToStr(Antenna.dE);
     EAntHgt.Text := FloatToStr(AntHgt.Hant_u);
     AntMethodBox.ItemIndex := AntHgt.Hkind;

     FNameEdit.Text := FileName;
     T1.Text := GetTimeForRTKLib(StartTime);
     T2.Text := GetTimeForRTKLib(EndTime);
     RinV.Text := FloatToStr(RinVersion);
     CommentMemo.Lines.Clear;
     CommentMemo.Text := Comment;

     NavFiles.Items.Clear;
     PPPFiles.Items.Clear;

     for I := 0 to length(AdditionalFiles) - 1 do
     begin
       s := AnsiLowerCase(copy(AdditionalFiles[i], length(AdditionalFiles[i])-2,3));
       if (s = 'sp3') or (s = 'clk') or (s = 'ion') then
         PPPFiles.Items.Add(AdditionalFiles[i])
       else
         NavFiles.Items.Add(AdditionalFiles[i]);
     end;

     AvSol.Items.Clear;
     HasSingle := false;   HasPPP := false;
     for I := 0 to length(Solutions) - 1 do
     begin
        case Solutions[I].SolutionKind of
          0: s := 'RINEX Approx position';                                     ////// ToDo:Translate
          1: begin s := 'Single solution'; HasSingle := true; end;
          2: begin s := GNSSSessions[GetGNSSSessionNumber(Solutions[I].BaseID)].MaskName
                    + ' -> ' + MaskName
             end;
          3: begin s := 'PPP solution'; HasPPP := true; end;
        end;
        AvSol.Items.Add(s);
     end;

     SetLength(AvProcArr, 0);
     if (not HasSingle) and SingleAvailable(GNSSSessions[ActiveGNSSSessions[0]]) then
     begin
        j := Length(AvProcArr);
        SetLength(AvProcArr, j+1);
        AvProcArr[j].RoverId := SessionID;
        AvProcArr[j].BaseId := '';
        AvProcArr[j].Method := 1;
     end;

     if (not HasPPP) and PPPAvailable(GNSSSessions[ActiveGNSSSessions[0]]) then
     begin
        j := Length(AvProcArr);
        SetLength(AvProcArr, j+1);
        AvProcArr[j].RoverId := SessionID;
        AvProcArr[j].BaseId := '';
        AvProcArr[j].Method := 3;
     end;

     for I := 0 to Length(GNSSVectors) - 1 do
       if (GNSSVectors[I].RoverID = SessionID) and
          (GNSSVectors[I].StatusQ = 0) or (GNSSVectors[I].StatusQ = 8) then
       begin
          j := Length(AvProcArr);
          SetLength(AvProcArr, j+1);
          AvProcArr[j].RoverId := GNSSVectors[I].RoverID;
          AvProcArr[j].BaseId := GNSSVectors[I].BaseID;
          AvProcArr[j].Method := 2;
       end;



     AvProc.Items.Clear;
     for I := 0 to length(AvProcArr) - 1 do
     begin
       case AvProcArr[I].Method of
          1: begin s := 'Single solution'; HasSingle := true; end;
          2: begin s := GNSSSessions[GetGNSSSessionNumber(AvProcArr[I].BaseID)].MaskName
                 + ' -> ' + MaskName
             end;
          3: begin s := 'PPP solution'; HasPPP := true; end;
        end;
        AvProc.Items.Add(s);
     end;

  end
  else
  begin
      SessionLabel.Caption := GNSSSessions[ActiveGNSSSessions[0]].MaskName + ', '
          + GNSSSessions[ActiveGNSSSessions[1]].MaskName;
      if length(ActiveGNSSSessions) > 2 then
      SessionLabel.Caption := SessionLabel.Caption + ', ...';

      SetLength(AvProcArr, 0);
      For I := 0 to length(ActiveGNSSSessions) - 1 do
      begin
        with GNSSSessions[ActiveGNSSSessions[I]] do
        Begin
          if I = 0 then
          begin
             j := 0;
             if isKinematic then
                if Length(Stops) <= 1 then
                   j := 1
                else
                   j := 2;

             Stat := StatusQ;
             ModeBox.ItemIndex := j;
             StationBox.Text := Station;
             AntNameBox.Text := Antenna.AntName;
             EAntdN.Text := FloatToStr(Antenna.dN);
             EAntdE.Text := FloatToStr(Antenna.dE);
             EAntHgt.Text := FloatToStr(AntHgt.Hant_u);
             AntMethodBox.ItemIndex := AntHgt.Hkind;
          end else
          Begin
             j := 0;
             if isKinematic then
                if Length(Stops) = 0 then
                   j := 1
                else
                   j := 2;

             if ModeBox.ItemIndex <> j then
             begin
               ModeBox.Font.Color := clRed;
               ModeBox.Enabled := false;
             end;

             if StationBox.Text <> Station then
             begin
               StationBox.Font.Color := clRed;
               StationBox.Text := '';
             end;
             if AntNameBox.Text <> Antenna.AntName then
               AntNameBox.Font.Color := clRed;
             if EAntdN.Text <> FloatToStr(Antenna.dN) then
               EAntdN.Font.Color := clRed;
             if EAntdE.Text <> FloatToStr(Antenna.dE) then
               EAntdE.Font.Color := clRed;
             if EAntHgt.Text <> FloatToStr(AntHgt.Hant_u) then
               EAntHgt.Font.Color := clRed;
             if AntMethodBox.ItemIndex <> AntHgt.Hkind then
               AntMethodBox.Font.Color := clRed;
             if Stat <> StatusQ then
               Stat := 7;
          End;

          /// Baselines Available
          for j := 0 to Length(GNSSVectors) - 1 do
             if (GNSSVectors[j].RoverID = SessionID) and
                (GNSSVectors[j].StatusQ = 0) or (GNSSVectors[j].StatusQ = 8) then
          begin
            SetLength(AvProcArr, Length(AvProcArr)+1);
            AvProcArr[Length(AvProcArr)-1].RoverId := GNSSVectors[j].RoverID;
            AvProcArr[Length(AvProcArr)-1].BaseId  := GNSSVectors[j].BaseID;
            AvProcArr[Length(AvProcArr)-1].Method  := 2;
          end;
        End;
      end;
  end;

  SetLength(EditableStopPoints, 0);
  if  ModeBox.ItemIndex = 2 then
  for I := 0 to length(ActiveGNSSSessions)- 1 do
  begin
     /// To Do: EditableStopPoints

  end;

 // StatusShape.Brush.Color := SolutionStatusColors[Stat];
  ShowStatus(Stat);

  DelNav.Enabled := NavFiles.ItemIndex >= 0;
  DelPPP.Enabled := PPPFiles.ItemIndex >= 0;

  Image1.Visible := length(ActiveGNSSSessions) = 1;
  Image2.Visible := length(ActiveGNSSSessions) = 2;
  Image3.Visible := length(ActiveGNSSSessions) > 2;

  HorScrollBar(NavFiles, NavFiles.Width);
  HorScrollBar(PPPFiles, PPPFiles.Width);

  StPan.Visible := ModeBox.ItemIndex = 0;
  StationLab.Visible := ModeBox.ItemIndex = 0;
  TrackLab.Visible := not StationLab.Visible;

  TabSheet1.OnShow(nil);
end;

procedure TFGNSSSessionOptions.ShowGNSSSessionInfo(
  AGNSSSessions: array of Integer; Img :TImageList);
var I:Integer;
begin
  ImgList := Img;

  SetLength(ActiveGNSSSessions, Length(AGNSSSessions));
  for I := 0 to length(AGNSSSessions) - 1 do
     ActiveGNSSSessions[I] := AGNSSSessions[I];

  if length(ActiveGNSSSessions) = 0 then
    exit
  else
    RefreshSettings;

  PageControl.ActivePageIndex := 0;
  Tabsheet3.TabVisible := length(ActiveGNSSSessions) = 1;
  Tabsheet4.TabVisible := length(ActiveGNSSSessions) = 1;
  Tabsheet5.TabVisible := length(ActiveGNSSSessions) = 1;
  Tabsheet6.TabVisible := ModeBox.ItemIndex = 2;
  TabSheet1Show(nil);
  Showmodal;
end;

procedure TFGNSSSessionOptions.AddNavClick(Sender: TObject);
var I:Integer;
begin
  OpenDialog.Filter := 'Rinex Nav Files *.**n, *.**l, *.**g, *.**c|*.??n;*.??g;*.**c;*.**l;*.**j;*.**i';
  if OpenDialog.Execute() then
  begin
    for I := 0 to OpenDialog.Files.Count - 1 do
       GNSSSessionAddAdditionalFile(GNSSSessions[ActiveGNSSSessions[0]],
           OpenDialog.Files[I]);
  end;

  RefreshSettings;
end;

procedure TFGNSSSessionOptions.AddPPPClick(Sender: TObject);
var I:Integer;
begin
  OpenDialog.Filter := 'Precise Orbits and Clock   *.clk, *.sp3|*.clk;*.sp3';
  if OpenDialog.Execute() then
    for I := 0 to OpenDialog.Files.Count - 1 do
       GNSSSessionAddAdditionalFile(GNSSSessions[ActiveGNSSSessions[0]],
           OpenDialog.Files[I]);

  RefreshSettings;
end;

procedure TFGNSSSessionOptions.AntNameBoxChange(Sender: TObject);
begin
  if  AntNameBox.Font.Color = clRed then
  begin
    AntNameBox.Font.Color := clWindowText;
    CheckAntennaChange;
  end;

end;

procedure TFGNSSSessionOptions.AvSolClick(Sender: TObject);
var I, Zone, j :integer;
    B, L, H, E, N, dH :Double;
begin
  if AvSol.ItemIndex > -1 then
  begin
     SolInfoPan.ActivePageIndex := 0;
     AvProc.ItemIndex := -1;

     ChoosedSol.Caption := AvSol.Items[AvSol.ItemIndex];

     DelSol.Enabled := true;
     RecomputeBtn.Enabled := true;

     with GNSSSessions[ActiveGNSSSessions[0]] do
     begin
         I := GetSolutionSubStatus(ActiveGNSSSessions[0], AvSol.ItemIndex);

         with SolStatImg.Canvas do
         begin
            Brush.Color := clBtnFace;
            Fillrect(Rect(0, 0, Width, Height));
            ImgList.Draw(SolStatImg.Canvas, 0, 0,
              Solutions[AvSol.ItemIndex].SolutionQ + 30 + I*7);
         end;

        DelSol.Enabled := Solutions[AvSol.ItemIndex].SolutionKind > 0;
        RecomputeBtn.Enabled := Solutions[AvSol.ItemIndex].SolutionKind > 0;
        VectRepI.Enabled := Solutions[AvSol.ItemIndex].SolutionKind > 0;

        // if Static
        OutputCoordinates;
        with Solutions[AvSol.ItemIndex] do
          Edit5.Text := FormatFloat('##0.0000',
            sqrt(sqr(StDevs[1]) + sqr(StDevs[2]) + sqr(StDevs[3])));

        VectBtn.Visible := Solutions[AvSol.ItemIndex].SolutionKind = 2;
        if VectBtn.Visible then
          ChoosedSol.Cursor := crHandPoint
        else
          ChoosedSol.Cursor := crDefault;

        if VectBtn.Visible  then
          ChoosedSol.Left := VectBtn.Left + VectBtn.Width + 2
        else
          ChoosedSol.Left := VectBtn.Left;

        Label9.Enabled := Solutions[AvSol.ItemIndex].SolutionKind <> 0;
        Edit5.Enabled  := Solutions[AvSol.ItemIndex].SolutionKind <> 0;

        if Solutions[AvSol.ItemIndex].SolutionKind = 2 then
        for I := 0 to Length(GNSSVectors) - 1 do
        with GNSSSessions[ActiveGNSSSessions[0]] do
        if (GNSSVectors[I].BaseID = Solutions[AvSol.ItemIndex].BaseID) and
         (GNSSVectors[I].RoverID = SessionID)
        then
        begin
           VectBtn.Glyph.Assign(nil);
           case GNSSVectors[I].StatusQ of
             -1..2 : j := 15 + GNSSVectors[I].StatusQ;
             3..7  : j := 18;
             8     : j := 19;
             11..12: j := GNSSVectors[I].StatusQ - 6;
             // ToDo ADJUSTED: ok I := 20, poor I := 21
             else j := 15;
           end;
           ImgList.GetBitmap(j,VectBtn.Glyph);
        end;

     end;
  end
  else
  begin
     SolInfoPan.ActivePageIndex := 1
  end;
end;

procedure TFGNSSSessionOptions.AvSolDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var I:integer;
begin
inherited;
  with (Control as TListBox).Canvas do
  begin

    I := GetSolutionSubStatus(ActiveGNSSSessions[0], Index);
    try
       I := I*7 + GNSSSessions[ActiveGNSSSessions[0]].Solutions[Index].SolutionQ
    except
       I := 0;
    end;
    //FillRect(Rect);
    ImgList.Draw((Control as TListBox).Canvas, Rect.Left, Rect.Top-2, I + 30);
    TextOut(Rect.Left + 20, Rect.Top, (Control as TListBox).Items[Index]);
    if odFocused In State then begin
      Brush.Color := (Control as TListBox).Color;
      DrawFocusRect(Rect);
    end;
  end;
end;

procedure ApplyGNSSPoint(NewName:string);
var I:Integer;
begin
  if NewName = '' then
    exit;

  for I := 0 to Length(ActiveGNSSSessions) - 1 do
  begin
     GNSSSessions[ActiveGNSSSessions[I]].Station := NewName;
     AddOrUpdateGNSSStation(ActiveGNSSSessions[I], false);
  end;
end;

procedure TFGNSSSessionOptions.PageControlChange(Sender: TObject);
begin
  if not ( (AntNameBox.Font.Color = clRed) or (AntNameBox.Text='') )  then
    CheckAntennaChange;
  ///  ToDo: ApplyAntenna dN dE dH!!!
  CheckAntennaPOSChange;
end;


procedure TFGNSSSessionOptions.PointPropBtnClick(Sender: TObject);
var I:Integer;
    F2: TFGNSSPointSettings;
begin

  if StationBox.Font.Color = clWindowText then
    ApplyGNSSPoint(StationBox.Text);
  RefreshSettings;

  I := GetGNSSPointNumber(StationBox.Text);
  if I > -1 then
  begin
    F2 := TFGNSSPointSettings.Create(nil);
//    FGNSSPointSettings.ShowStationOrTrack( I, ImgList);
    F2.ShowStationOrTrack( I, ImgList);
    F2.Release;
    RefreshSettings;
  end;
end;


procedure TFGNSSSessionOptions.CloseBtnClick(Sender: TObject);
var I:Integer;
   AntChanged :boolean;
   WarnMe: boolean;
begin
  if StationBox.Font.Color = clWindowText then
    ApplyGNSSPoint(StationBox.Text);

  if not ( (AntNameBox.Font.Color = clRed) or (AntNameBox.Text='') )  then
    CheckAntennaChange;

  ///  ToDo: ApplyAntenna dN dE dH!!!
  CheckAntennaPOSChange;

  Close;
end;

procedure TFGNSSSessionOptions.CSboxChange(Sender: TObject);
begin
  OutPutCoordinates;
end;

procedure TFGNSSSessionOptions.CustomAntClick(Sender: TObject);
var I, j, SolN, SessionN :integer;
    WarnMe: boolean;
begin

   FAntProp.ShowAntProp(AntNameBox.Text);

   if FAntProp.AntAccepted then
   begin

      WarnMe := false;
      for I := 0 to Length(ActiveGNSSSessions) - 1 do
      begin
        for j := 0 to Length(GNSSVectors) - 1 do
          if ( (GNSSVectors[j].RoverID = GNSSSessions[ActiveGNSSSessions[I]].SessionID) or
               (GNSSVectors[j].BaseID  = GNSSSessions[ActiveGNSSSessions[I]].SessionID) )
            and (GNSSVectors[j].StatusQ > 0) then
            begin
              WarnMe := true;
              break
            end;
        if WarnMe then
          break;

      end;


      if WarnMe then
      if messagedlg('This may change the other stations. Proceed?',    // Todo : TRANSLATE
         mtConfirmation, [mbYes, mbNo], 0) <> 6 then
      exit;


      for I := 0 to Length(ActiveGNSSSessions) - 1 do
      begin
          for j := 0 to Length(GNSSVectors) - 1 do
            if ((GNSSVectors[j].RoverID = GNSSSessions[ActiveGNSSSessions[I]].SessionID) or
             (GNSSVectors[j].BaseID  = GNSSSessions[ActiveGNSSSessions[I]].SessionID))
              and (GNSSVectors[j].StatusQ > 0) then
            begin
              SessionN := GetGNSSSessionNumber(GNSSVectors[j].RoverID);
              SolN := GetGNSSSolutionForVector(SessionN,GNSSVectors[j].BaseID);
              if (SolN <> -1)and(SessionN <> -1) then
                DeleteGNSSSolution(SessionN, SolN);
              GNSSVectors[j].StatusQ := 0;
            end;

          GNSSSessions[ActiveGNSSSessions[I]].Antenna.AntName := FAntProp.AntPCV.AntName;
      end;

      AddAntennaToPCV(FAntProp.AntPCV);
   end;


   RefreshSettings;

end;

procedure TFGNSSSessionOptions.DelNavClick(Sender: TObject);
begin
   if NavFiles.ItemIndex < 0 then
     exit;

   GNSSSessionDelAdditionalFile(GNSSSessions[ActiveGNSSSessions[0]],
      NavFiles.Items[NavFiles.ItemIndex]);

   RefreshSettings;
end;

procedure TFGNSSSessionOptions.DelPPPClick(Sender: TObject);
begin
   if PPPFiles.ItemIndex < 0 then
     exit;

   GNSSSessionDelAdditionalFile(GNSSSessions[ActiveGNSSSessions[0]],
      PPPFiles.Items[PPPFiles.ItemIndex]);

   RefreshSettings;
end;

procedure TFGNSSSessionOptions.DelSolClick(Sender: TObject);
begin
  DeleteGNSSSolution(ActiveGNSSSessions[0], AvSol.ItemIndex);
  RefreshSettings;
  AvSol.OnClick(nil);
end;

procedure TFGNSSSessionOptions.FormCreate(Sender: TObject);
begin
 ModeBox.Enabled := not isStaticOnly;
end;

procedure TFGNSSSessionOptions.FormShow(Sender: TObject);
begin
  Reloaded := false;
  RefreshSettings;
  if ShowSol >= 0 then
  begin
    PageControl.ActivePageIndex := 2;
    TabSheet3Show(nil);
    AvSol.ItemIndex := ShowSol;
    AvSol.OnClick(nil);
    ShowSol := -1;
  end;
end;

procedure TFGNSSSessionOptions.GeoidPopupClick(Sender: TObject);
begin
  with Sender as TMenuItem do
    GeoidIdx := tag;
  OutputCoordinates;
end;

procedure TFGNSSSessionOptions.GeoidPopupPopup(Sender: TObject);
var I:Integer;
begin
  for I := 0 to GeoidPopup.Items.Count - 1 do
  begin
    GeoidPopup.Items[I].ImageIndex := -1;
    if GeoidPopup.Items[I].Tag = GeoidIdx then
      GeoidPopup.Items[I].ImageIndex := 96;
  end;
end;

procedure TFGNSSSessionOptions.GetPPPClick(Sender: TObject);
var I :Integer;
    A :Array of Byte;
    B :Array of Integer;
begin
   if length(ActiveGNSSSessions)= 1 then
     FStartProcessing.ShowProcOptions(3, ActiveGNSSSessions[0],
                 ActiveGNSSSessions[0])
   else
   begin
      SetLength(A, Length(ActiveGNSSSessions));
      SetLength(B, Length(ActiveGNSSSessions));
      for I := 0 to Length(ActiveGNSSSessions) - 1 do
      begin
         A[I] := 3;
         B[I] := ActiveGNSSSessions[I];
      end;

      FStartProcessing.ShowMultiProcOptions(A,B,B);
   end;
   RefreshSettings;
end;

procedure TFGNSSSessionOptions.GetSingleClick(Sender: TObject);
var I :Integer;
    A :Array of Byte;
    B :Array of Integer;
begin
   if length(ActiveGNSSSessions)= 1 then
     FStartProcessing.ShowProcOptions(1, ActiveGNSSSessions[0],
                  ActiveGNSSSessions[0])
   else
   begin
      SetLength(A, Length(ActiveGNSSSessions));
      SetLength(B, Length(ActiveGNSSSessions));
      for I := 0 to Length(ActiveGNSSSessions) - 1 do
      begin
         A[I] := 1;
         B[I] := ActiveGNSSSessions[I];
      end;

      FStartProcessing.ShowMultiProcOptions(A,B,B);
   end;
   RefreshSettings;
end;

procedure TFGNSSSessionOptions.AvProcClick(Sender: TObject);
begin
  if AvProc.ItemIndex > -1 then
  begin
    AvSol.ItemIndex := -1;
    SolInfoPan.ActivePageIndex := 2;

    Label24.Caption := AvProc.Items[AvProc.ItemIndex];
    case AvProcArr[AvProc.ItemIndex].Method of
      0: Label25.Caption := ''; // ToDo Translate;
      1: Label25.Caption := 'Single solution has the lowest accuracy. ' +
                            'You may use it to have the approximate ' +
                            'station position/track poins.'; // ToDo Translate;
      2: Label25.Caption := 'Relative positioning provides the highest accuracy, ' +
                            'depending on the baseline length and environment. ' +
                            'The method takes to have a base station '+
                            'with well-known coordinates.';// ToDo Translate;
      3: Label25.Caption := 'Precise Point Position provides the accuracy '+
                            '10 cm to 1 m in ITRF coordinates frame. '; // ToDo Translate;
     end;
  end;

end;

procedure TFGNSSSessionOptions.AvProcDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TListBox).Canvas do
  begin
    ImgList.Draw((Control as TListBox).Canvas, Rect.Left, Rect.Top-2, 30);
    TextOut(Rect.Left + 20, Rect.Top, (Control as TListBox).Items[Index]);
    if odFocused In State then begin
      Brush.Color := (Control as TListBox).Color;
      DrawFocusRect(Rect);
    end;
  end;
end;

procedure TFGNSSSessionOptions.ModeBoxChange(Sender: TObject);
  function CheckStops:boolean;
  var j:integer;
  begin
     result := false;
     for j := 0 to Length(ActiveGNSSSessions) - 1 do
       if Length(GNSSSessions[ActiveGNSSSessions[j]].Stops)> 0 then
        begin
          result := true;
          break;
        end;
  end;
  function NeedToCheck:boolean;
  var j:integer;
  begin
     result := false;
     for j := 0 to Length(ActiveGNSSSessions) - 1 do
       if Length(GNSSSessions[ActiveGNSSSessions[j]].Stops) = 0 then
        begin
          result := true;
          break;
        end;
  end;
var I:Integer;
begin
  Tabsheet6.TabVisible := ModeBox.ItemIndex = 2;
  StPan.Visible := true;
  StPan.Visible := ModeBox.Enabled;
  StationLab.Visible := ModeBox.ItemIndex = 0;
  TrackLab.Visible := not StationLab.Visible;

  for I := 0 to Length(ActiveGNSSSessions) - 1 do
    GNSSSessions[ActiveGNSSSessions[I]].isKinematic := ModeBox.ItemIndex > 0;

  if ModeBox.ItemIndex = 2 then
    if NeedToCheck then
      if not Reloaded then
      begin
         RinAnalyse.Click;
         if CheckStops = false then
           MessageDlg('No stop points found', mtInformation, [mbOk], 0)  /// Translate

      end;

  if ModeBox.ItemIndex > 0 then
  begin
    StationBox.Text := '';
    CheckGNSSPoints;
  end
  else
    RefreshSettings;
end;

procedure TFGNSSSessionOptions.NavFilesClick(Sender: TObject);
begin
  DelNav.Enabled := NavFiles.ItemIndex >= 0;
end;

procedure TFGNSSSessionOptions.NavFilesDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var s:string; c:char; I:integer;
begin
  with (Control as TListBox).Canvas do
  begin

    try
        s := AnsiLowerCase(NavFiles.Items[Index]);
        s := s[length(s)];
        c := s[1];
        case c of
           'n' : I := 52;
           'g' : I := 53;
           'l' : I := 54;
           'c' : I := 55;
           'j' : I := 56;
           'i' : I := 57;
           else I:= 51;
        end;
    except
       I:= 51;
    end;

    ImgList.Draw((Control as TListBox).Canvas, Rect.Left, Rect.Top-1, I);

    TextOut(Rect.Left + 20, Rect.Top, (Control as TListBox).Items[Index]);

    if odFocused In State then begin
      Brush.Color := (Control as TListBox).Color;
      DrawFocusRect(Rect);
    end;

  end;
end;

procedure TFGNSSSessionOptions.OutputCoordinates;
begin
    if AvSol.ItemIndex < 0 then
      exit;

    with GNSSSessions[ActiveGNSSSessions[0]].Solutions[AvSol.ItemIndex].PointPos do
        OutputCoords(X, Y, Z,
              ECEFWGS, PrjCS[CSBox.ItemIndex], WGSCS,
              Xed, Yed, Zed, Xlabel, Ylabel, Zlabel, GeoidP,
              GeoidIdx);

    ChangeGeoid.Glyph.Assign(nil);
    if GeoidIdx > -1 then
      ImgList.GetBitmap(113,ChangeGeoid.Glyph)
    else
      ImgList.GetBitmap(115,ChangeGeoid.Glyph);
end;

procedure TFGNSSSessionOptions.PPPFilesClick(Sender: TObject);
begin
  DelPPP.Enabled := PPPFiles.ItemIndex >= 0;
end;

procedure TFGNSSSessionOptions.PPPFilesDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var s:string; I:integer;
begin
  with (Control as TListBox).Canvas do
  begin
    I:= 51;
    try
        s := PPPFiles.Items[Index];
        s := AnsiLowerCase(ExtractFileExt(s));
        if s = '.sp3' then
          I := 58;
        if s = '.clk' then
          I := 59;
        if s = '.ion' then
          I := 60;
    except
       I:= 51;
    end;

    ImgList.Draw((Control as TListBox).Canvas, Rect.Left, Rect.Top-1, I);

    TextOut(Rect.Left + 20, Rect.Top, (Control as TListBox).Items[Index]);

    if odFocused In State then begin
      Brush.Color := (Control as TListBox).Color;
      DrawFocusRect(Rect);
    end;

  end;
end;

procedure TFGNSSSessionOptions.ProcBLClick(Sender: TObject);
var I, j:Integer; A :Array of byte; B, C :Array of Integer;
begin
  SetLength(A, 0); SetLength(B, 0); SetLength(C, 0);
  j := 0;
  for I := 0 to Length(AvProcArr)-1 do
  if AvProcArr[I].Method = 2 then
  begin
      j := Length(A);
      SetLength(A, j+1);
      SetLength(B, j+1);
      SetLength(C, j+1);
      A[j] := 2;
      B[j] := GetGNSSSessionNumber(AvProcArr[I].RoverId);
      C[j] := GetGNSSSessionNumber(AvProcArr[I].BaseId);
  end;
  if length(A) > 0 then
    FStartProcessing.ShowMultiProcOptions(A,B,C);
  RefreshSettings;
  TabSheet1Show(nil)
end;

procedure TFGNSSSessionOptions.RinAnalyseClick(Sender: TObject);
var I:Integer;
begin
    FLoadGPS.Show;
    FLoadGps.Label3.Caption := 'Reloading Obs File';
    FLoadGps.Label3.Visible := true;
    FLoadGps.LCount.Visible := true;
    for I := 0 to Length(ActiveGNSSSessions) - 1 do
    begin
       FLoadGps.LCount.Caption := intToStr(I+1) + ' / ' + intToStr(Length(ActiveGNSSSessions));
       FLoadGPS.Repaint;
       AnalyseSessionRINEX(GNSSSessions[ActiveGNSSSessions[I]], FLoadGPS.ProgressBar1);
    end;
    FLoadGPS.Close;

    Reloaded := true;
    RefreshSettings;
end;

procedure TFGNSSSessionOptions.ShowGNSSSessionInfo(AGNSSSession: Integer; Img :TImageList);
var A:Array[0..0] of Integer;
begin
 A[0] := AGNSSSession;
 ShowGNSSSessionInfo(A, Img);
end;

procedure TFGNSSSessionOptions.ProcAllBLClick(Sender: TObject);
var I, j, k:Integer; A :Array of byte; B, C :Array of Integer;
begin
  SetLength(A, 0); SetLength(B, 0); SetLength(C, 0);
  j := 0;

  for k := 0 to length(ActiveGNSSSessions) - 1 do
  with GNSSSessions[ActiveGNSSSessions[k]] do
    for I := 0 to Length(GNSSVectors) - 1 do
    if (GNSSVectors[I].RoverID = SessionID) then
    begin
      j := Length(A);
      SetLength(A, j+1);
      SetLength(B, j+1);
      SetLength(C, j+1);

      A[j] := 2;
      B[j] := GetGNSSSessionNumber(GNSSVectors[I].RoverID);
      C[j] := GetGNSSSessionNumber(GNSSVectors[I].BaseID);
    end;

  if length(A) > 0 then
    FStartProcessing.ShowMultiProcOptions(A,B,C);
  RefreshSettings;
  TabSheet1Show(nil)
end;

procedure TFGNSSSessionOptions.ShowGNSSSessionInfo(AGNSSSession: Integer;
  Img: TImageList; Sol: integer);
begin
  ShowSol := Sol;
  ShowGNSSSessionInfo(AGNSSSession, Img);
end;

procedure TFGNSSSessionOptions.SpeedButton3Click(Sender: TObject);
var N, j:Integer;
begin

  if AvProc.ItemIndex > -1 then
  begin
    j := AVSol.Items.Count;
    case AvProcArr[AvProc.ItemIndex].Method of
      1:  GetSingle.Click;
      3:  GetPPP.Click;
      2: begin
         N := GetGNSSSessionNumber(AvProcArr[AvProc.ItemIndex].BaseId);
         if N<> -1 then
            FStartProcessing.ShowProcOptions(2, ActiveGNSSSessions[0], N);
      end;
    end;

    RefreshSettings;
    Tabsheet3.OnShow(nil);
    if j < AVSol.Items.Count then AVSol.ItemIndex := j;
    AVSol.OnClick(nil);
    
  end;
 
end;

procedure TFGNSSSessionOptions.StationBoxChange(Sender: TObject);
begin
  StationBox.Font.Color := clWindowText;
end;

procedure TFGNSSSessionOptions.TabSheet1Show(Sender: TObject);
  function isNumber(s:char):boolean;
  begin
     case s of
       '0'..'9', '_' : result := true;
       else result := false;
     end;
  end;

  function HasSol(SKind:Integer): boolean;
  var j, k:Integer;
      b:boolean;
  begin
    result := false;
    b := false;
    for j := 0 to length(ActiveGNSSSessions) - 1 do
    begin
      with GNSSSessions[ActiveGNSSSessions[j]] do
      begin
        if SKind <> 2 then
          b := false;
        for k := 0 to Length(Solutions) - 1 do
        if Solutions[k].SolutionKind = SKind then
          b := true;
      end;

      case SKind of
        1, 3 : if (b = false) then exit;
        2:  if (b = true) then break;
      end;
      
    end;
    if b = true then
      result := true;
  end;

  function HasNav:boolean;
  var I, j :Integer; s:string;
  begin
    result := false;
    //if (length(ActiveGNSSSessions) = 1) then
    for j := 0 to length(ActiveGNSSSessions) - 1 do
    with GNSSSessions[ActiveGNSSSessions[j]] do
    begin

       for I := 0 to length(AdditionalFiles) - 1 do
       begin
         s := AnsiLowerCase(AdditionalFiles[i][length(AdditionalFiles[i])]);
         if (s = 'g') or (s = 'n') or (s = 'i') or (s = 'j')
                      or (s = 'c') or (s = 'l') then
         begin
           if s = 'n' then
             result := isNumber(AdditionalFiles[i][length(AdditionalFiles[i])-1])
           else
             result := true;

           break;
         end;
       end;
    end;
  end;

  function HasFilesPPP:boolean;
  var I, j :Integer;  s:string;
      hasSP3 :boolean;
      hasCLK :boolean;
      hasN   :boolean;
  begin
    result := false;
   // if (length(ActiveGNSSSessions) = 1) then
    for j := 0 to length(ActiveGNSSSessions) - 1 do
    with GNSSSessions[ActiveGNSSSessions[j]] do
    begin
       hasSP3 := false;
       hasCLK := false;
       hasN   := false;
       for I := 0 to length(AdditionalFiles) - 1 do
       begin
         s := AnsiLowerCase(ExtractFileExt(AdditionalFiles[i]));
         if s = '.sp3' then
            hasSP3 := true;
         if s = '.clk' then
            hasCLK := true;
         if (s[length(s)] = 'n') and
            (isNumber(s[length(s)-1])) then
            hasN   := true;

       end;

       result := hasSP3 and hasCLK and hasN;
       if result then
         break;
    end;
  end;

  function HasBaseLines: boolean;
  var I:Integer;
  begin
    result := false;
    for I := 0 to Length(AvProcArr) - 1 do
      if AvProcArr[I].Method = 2 then
      begin
        result := true;
        break;
      end;
  end;

var I, j:Integer;

begin

  GetSingle.Glyph.Assign(nil);
  GetPPP.Glyph.Assign(nil);
  ProcAllBL.Glyph.Assign(nil);
  PointPropBtn.Glyph.Assign(nil);

  GetSingle.Enabled := HasNav;
  if GetSingle.Enabled then
  begin
    if HasSol(1) then
      ImgList.GetBitmap(92,GetSingle.Glyph)
    else
      ImgList.GetBitmap(93,GetSingle.Glyph);
  end;

  GetPPP.Enabled := HasFilesPPP and HasNav;

  if GetPPP.Enabled then
  begin
    if HasSol(3) then
      ImgList.GetBitmap(92,GetPPP.Glyph)
    else
      ImgList.GetBitmap(93,GetPPP.Glyph);
  end;
      

  ProcBL.Enabled := HasBaseLines;
  ProcBL.Visible := HasBaseLines;
  ProcAllBL.Enabled := HasBaseLines or HasSol(2);
  if HasSol(2) then
    ImgList.GetBitmap(92,ProcAllBL.Glyph)
  else
  begin
    if ProcAllBL.Enabled then
      ImgList.GetBitmap(93,ProcAllBL.Glyph);
    ProcBL.Visible := false;
  end;

  I := GetGNSSPointNumber(StationBox.Text);
  j := -1;
  if I > -1 then
  begin
    j := GNSSPoints[I].Status;
    if GNSSPoints[I].Active = false then
      j := 7;
    ImgList.GetBitmap(j+77 ,PointPropBtn.Glyph);
    PointPropBtn.Caption := '';
  end
   else PointPropBtn.Caption := '...';

end;

procedure TFGNSSSessionOptions.TabSheet3Show(Sender: TObject);
begin
  PageControl.OnChange(nil);
  RefreshSettings;
  RefreshCSBox;
  AvSol.OnClick(nil);
end;

procedure TFGNSSSessionOptions.TabSheet5Show(Sender: TObject);
begin
  HorScrollBar(NavFiles, NavFiles.Width);
  HorScrollBar(PPPFiles, PPPFiles.Width);
  DelNav.Enabled := NavFiles.ItemIndex >= 0;
  DelPPP.Enabled := PPPFiles.ItemIndex >= 0;
end;

procedure TFGNSSSessionOptions.VectBtnClick(Sender: TObject);
var    F2: TFVectSettings; I, j, VN:Integer;
begin
   if AvSol.ItemIndex > -1 then
   begin
      VN := -1;
      for I := 0 to Length(GNSSVectors) - 1 do
      with GNSSSessions[ActiveGNSSSessions[0]] do
      if (GNSSVectors[I].BaseID = Solutions[AvSol.ItemIndex].BaseID) and
         (GNSSVectors[I].RoverID = SessionID)
      then
      begin
        VN := I;
        break;
      end;

      if VN > -1 then
      begin
        j := AVSol.ItemIndex;
        F2:= TFVectSettings.Create(nil);
        F2.ShowVectorProp(VN ,ImgList);
        F2.Release;
        RefreshSettings;
        AvSol.ItemIndex := j;
        AVSol.OnClick(nil);
      end;
      
   end;
end;

end.
