unit LoadData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ValEdit, ComCtrls, Spin, BasicMapObjects,
  LangLoader, TabFunctions, Buttons, GeoString, UGetMapPos;

type
  TLoadRData = class(TForm)
    RSpacer: TRadioGroup;
    Button1: TButton;
    Button2: TButton;
    Spacer: TEdit;
    ValueList: TValueListEditor;
    StringGrid1: TStringGrid;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ComboBox1: TComboBox;
    RadioGroup2: TRadioGroup;
    ComboBox2: TComboBox;
    ListBox4: TListBox;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    PC2: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    RoutesBE: TRadioGroup;
    ValueList2: TValueListEditor;
    HgtTab: TSpinEdit;
    HgtTabIs: TRadioGroup;
    Panel1: TPanel;
    OpTmp: TComboBox;
    OTSave: TSpeedButton;
    OTDel: TSpeedButton;
    Panel2: TPanel;
    CheckGlobe: TSpeedButton;
    procedure Button2Click(Sender: TObject);
    procedure RefreshRes;
    procedure RSpacerClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ValueListKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBox4Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure RenameTabs(StringGrid:TStringGrid; TabNameStyle:byte);
    procedure ListBox4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure RoutesBEClick(Sender: TObject);
    procedure InitOT;
    procedure LoadOTList(FN:String);
    procedure FindWGS;
    procedure HgtTabIsClick(Sender: TObject);
    procedure OpTmpChange(Sender: TObject);
    procedure OTSaveClick(Sender: TObject);
    procedure OTDelClick(Sender: TObject);
    procedure SpacerChange(Sender: TObject);
    procedure ValueListClick(Sender: TObject);
    procedure ValueList2Click(Sender: TObject);
    procedure CheckGlobeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure OpenFile(FileName:String);
    var
    LatS, LonS, XS, YS, ZS, NordS, SouthS, NSS, EWS, WestS, EastS, NameS, FName, HS : String;
    OpenKind : Byte;
  end;

var
  LoadRData: TLoadRData;
  Flang: string = 'Russian';
  var S, OTList: TStringList;
{    oldidx : Longint = -1;
     idx: Longint;
    HintX, HintY:Integer;
 }
implementation

uses GeoClasses, GeoFunctions, MapperFm;
{$R *.dfm}

procedure FindCat(Cat: String; ListBox: TListBox);
var i: integer;
begin
 ListBox.Items.Clear;
 for i := 0 to Length( CoordinateSystemList)-1 do
  if CoordinateSystemList[i].Category = Cat then
    ListBox.Items.Add(CoordinateSystemList[i].Caption);
end;

procedure ClearGrid(StringGrid: TStringGrid);
var i, j: Integer;
begin
  with StringGrid do
  begin
    for i:=1 to RowCount-1 do
    for j:=0 to ColCount-1 do
      Cells[j, i]:='';
    StringGrid.RowCount := 2;
  end;
end;


function GetCols(str, sep: string; ColN, ColCount:integer): string;
  var j,stl,b :integer;
  begin

    Result:='';
    stl:=0;
    b:=1;

    for j:=1 to length(Str)+1 do
    Begin

      if ((copy(Str,j,1)=sep)or(j=length(Str)+1))and(copy(Str,j-1,1)<>sep) then
      begin

       if (stl>=ColN) and (Stl<ColN+ColCount) then
       Begin
        if result='' then
          Result:=(Copy(Str,b,j-b))
            else
              Result:=Result+' '+(Copy(Str,b,j-b));
       End;

       inc(stl);
       b:=j+1;

       if stl>ColN+ColCount then
          break;
      end;

    End;

    if result <> '' then
      for j:= 1 to length(Result)+1 do
        if ((Result[j] = '.') or (Result[j] = ','))and(Result[j]<>sep) then
           Result[j] := DecimalSeparator;
end;


procedure TLoadRData.Button2Click(Sender: TObject);
begin
 close;
end;

procedure TLoadRData.RSpacerClick(Sender: TObject);
begin
  Spacer.Enabled := RSpacer.ItemIndex = 2;
  Optmp.ItemIndex := 0;
  OTDel.Visible := false;  
  RefreshRes;
end;

procedure TLoadRData.SpacerChange(Sender: TObject);
begin
  Optmp.ItemIndex := 0;
  OTDel.Visible := false;  
end;

procedure TLoadRData.Button1Click(Sender: TObject);
begin
// Form1.CanLoad := true;

 isRoutesDatum := PageControl1.ActivePageIndex = 0;

 RoutesBEKind := RoutesBE.ItemIndex;

 Case LoadRData.RSpacer.itemIndex of
     0: RoutesRSpacer := ' ';
     1: RoutesRSpacer := #$9;
     2: RoutesRSpacer := LoadRData.Spacer.Text[1];
     3: RoutesRSpacer := ';';
     4: RoutesRSpacer := ',';
 end;

 if isRoutesDatum then
 begin
   RoutesDatum := FindDatumByCaption(ComboBox1.Items[ComboBox1.ItemIndex]);
   RoutesCS := RadioGroup2.ItemIndex;
 end
  else
  begin
    RoutesCS := FindCoordinateSystemByCaption(ListBox4.Items[ListBox4.ItemIndex]);
    RoutesDatum :=  -1; //CoordinateSystemList[MainForm.RoutesCS].DatumN;
  end;

  RoutesXTab :=  StrToInt(ValueList.Cells[1,2])-1;
  RoutesYTab :=  StrToInt(ValueList.Cells[1,3])-1;
  if ValueList.RowCount = 5 then
    RoutesZTab :=  StrToInt(ValueList.Cells[1,4])-1
      else
       RoutesZTab := -1;
  RoutesH := 0;
  if OpenKind  = 2 then
    if (HgtTabIs.Enabled) and (HgtTabIs.ItemIndex > 0) then
    begin
       RoutesZTab := HgtTab.Value-1;
       RoutesH := HgtTabIs.ItemIndex;
    end;

  RoutesNameTab := StrToInt(ValueList.Cells[1,1])-1;

  RoutesX2Tab :=  StrToInt(ValueList2.Cells[1,1])-1;
  RoutesY2Tab :=  StrToInt(ValueList2.Cells[1,2])-1;
  if ValueList2.RowCount = 4 then
   RoutesZ2Tab :=  StrToInt(ValueList2.Cells[1,3])-1
    else
       RoutesZ2Tab := -1;


  RoutesTabStart := SpinEdit1.Value;
  case OpenKind of
     0: LoadRoutes(FName, AddRoutes, inf[102]);
     1: LoadFrame(FName);
     2: LoadMarkersEx(FName);
  end;

      
  close;
end;

procedure TLoadRData.CheckGlobeClick(Sender: TObject);

  procedure GetBL(x, y, z: Double; var B, L, H : Double);
  begin
       WGS := FindDatum('WGS84') ;

       if isRoutesDatum = false then
       begin
            /// RouteCS - CК

            if  CoordinateSystemList[RoutesCS].ProjectionType <=1 then
                CoordinateSystemToDatum(RoutesCS, x, y, z, B, L, H)
                else
                   CoordinateSystemToDatum(RoutesCS, y, x, z, B, L, H);

           if CoordinateSystemList[RoutesCS].DatumN <> WGS then
              Geo1ForceToGeo2(B, L, H,  CoordinateSystemList[RoutesCS].DatumN,
                              WGS, B, L, H);
       end
          else
            begin
              /// RouteCS - тип проекции
              case RoutesCS of
                 0: begin
                   B := x;
                   L := y;

                   if RoutesDatum <> WGS then
                     Geo1ForceToGeo2( x, y, z, RoutesDatum, WGS, B, L, H);
                 end;

                 1:   begin
                   // XYZ
                   ECEFToGeo(RoutesDatum, x, y, z, B, L, H);

                   if RoutesDatum <> WGS then
                     Geo1ForceToGeo2( B, L, z, RoutesDatum, WGS, B, L, H);

                 end;
                 2:  begin
                   // GK
                   GaussKrugerToGeo(RoutesDatum, y, x, B, L);

                  if RoutesDatum <> WGS then
                       Geo1ForceToGeo2( B, L, z, RoutesDatum, WGS, B, L, H);

                 end;
                 3,4:  begin
                   // UTM
                   UTMToGeo(RoutesDatum, y, x, RoutesCS = 4, B, L);

                   if RoutesDatum <> WGS then
                       Geo1ForceToGeo2( B, L, z, RoutesDatum, WGS, B, L, H);

                   End;

                 end;
              end;

  end;

var X, Y, Z, B, L, H :Double;
begin
 isRoutesDatum := PageControl1.ActivePageIndex = 0;

 if isRoutesDatum then
 begin
   RoutesDatum := FindDatumByCaption(ComboBox1.Items[ComboBox1.ItemIndex]);
   RoutesCS := RadioGroup2.ItemIndex;
 end
  else
  begin
    RoutesCS := FindCoordinateSystemByCaption(ListBox4.Items[ListBox4.ItemIndex]);
    RoutesDatum :=  -1; //CoordinateSystemList[MainForm.RoutesCS].DatumN;
  end;

  
  if (isRoutesDatum) and (RoutesCS = 0) or
     (not isRoutesDatum) and (CoordinateSystemList[RoutesCS].ProjectionType = 0) then
  begin
      X := StrToLatLon(StringGrid1.Cells[1,1],true);
      Y := StrToLatLon(StringGrid1.Cells[2,1],false);
  end
   else
   begin
      X := StrToFloat2(StringGrid1.Cells[1,1]);
      Y := StrToFloat2(StringGrid1.Cells[2,1]);
   end;


  if (isRoutesDatum) and (RoutesCS = 2) or
     (not isRoutesDatum) and (CoordinateSystemList[RoutesCS].ProjectionType = 2) then
     Z := StrToFloat2(StringGrid1.Cells[3,1])
  else Z := 0;
  GetBL(X, Y, Z, B, L, H);

  GetMapPos.GMMode := false;
  GetMapPos.PointB := B;
  GetMapPos.PointL := L;
  GetMapPos.ShowModal;
end;

procedure TLoadRData.ComboBox1Change(Sender: TObject);
var i, j : integer;
begin
  if ComboBox1.ItemIndex>=0 then
  Begin
     // Memo1.clear;
    //ListBox1.Clear;

    i:= FindDatumByCaption(ComboBox1.Items[ComboBox1.ItemIndex]);

    RadioGroup2.ItemIndex := 0;
    RadioGroup2.Buttons[2].Enabled := false;
    RadioGroup2.Buttons[3].Enabled := false;
    RadioGroup2.Buttons[4].Enabled := false;
    for j:=0 to length(DatumList[i].Projections)-1 Do
    begin
      if DatumList[i].Projections[j]='Gauss' then
         RadioGroup2.Buttons[2].Enabled := true;
      if DatumList[i].Projections[j]='UTM' then
      begin
         RadioGroup2.Buttons[3].Enabled := true;
         RadioGroup2.Buttons[4].Enabled := true;
      end;
    end;

  End;
  Optmp.ItemIndex := 0;
  OTDel.Visible := false;
end;

procedure TLoadRData.RadioGroup2Click(Sender: TObject);
begin

  case RadioGroup2.ItemIndex of
    3,4: begin
      ValueList.Keys[1] := NameS;
      ValueList.Keys[2] := EWS;
      ValueList.Keys[3] := NSS;

      if ValueList.RowCount=5 then
         ValueList.DeleteRow(4);

      ValueList2.Keys[1] := EWS;
      ValueList2.Keys[2] := NSS;

      if ValueList2.RowCount=4 then
         ValueList2.DeleteRow(3);
    end;

    2: begin
      ValueList.Keys[1] := NameS;
      ValueList.Keys[2] := EWS;
      ValueList.Keys[3] := NSS;

      if ValueList.RowCount=5 then
         ValueList.DeleteRow(4);

      ValueList2.Keys[1] := EWS;
      ValueList2.Keys[2] := NSS;

      if ValueList2.RowCount=4 then
         ValueList2.DeleteRow(3);

    end;

    1: begin
      ValueList.Keys[1] := NameS;
      ValueList.Keys[2] := XS;
      ValueList.Keys[3] := YS;

      if ValueList.RowCount<5 then
        ValueList.InsertRow(ZS, '4', true);

      ValueList2.Keys[1] := XS;
      ValueList2.Keys[2] := YS;

      if ValueList2.RowCount<4 then
         ValueList2.InsertRow(ZS, '7', true);
    end;

    0: begin
      ValueList.Keys[1] := NameS;
      ValueList.Keys[2] := LatS+#176;
      ValueList.Keys[3] := LonS+#176;

      if ValueList.RowCount = 5 then
         ValueList.DeleteRow(4);

      ValueList2.Keys[1] :=  LatS +#176;
      ValueList2.Keys[2] :=  LonS +#176;

      if ValueList2.RowCount = 4 then
         ValueList2.DeleteRow(3);
    end;
  end;
  RenameTabs(StringGrid1,RadioGroup2.ItemIndex);
  RefreshRes;
  Optmp.ItemIndex := 0;
  OTDel.Visible := false;  
end;

procedure TLoadRData.FindWGS;
var I, j:Integer;
const CN = 'WGS84_LatLon';
begin
//
 j := -1;

 for I := 0 to Length(CoordinateSystemList)-1 do
   if CoordinateSystemList[I].Name = CN then
   begin
     j := I;
     break;
   end;

 if j = -1 then
   exit;

 for I := 0 to ComboBox2.Items.Count - 1 do
   if CoordinateSystemList[j].Category = ComboBox2.Items[I] then
   begin
     ComboBox2.ItemIndex := I;
     break;
   end;

 FindCat(CoordinateSystemList[j].Category, ListBox4);
 for I := 0 to ListBox4.Items.Count - 1 do
   if ListBox4.Items[I] = CoordinateSystemList[j].Caption then
   begin
     ListBox4.ItemIndex := I;
     break;
   end;

end;

procedure TLoadRData.FormActivate(Sender: TObject);
var I : Integer;
begin
 if Lang <> FLang then
 Begin
   ComboBox2.Items.Clear;
   ComboBox1.Items.Clear;
   FLang := Lang;
   findWgs;
 End;

 if  ComboBox1.Items.Count = 0 then
 begin

   ComboBox2.Clear;
   for i := 0 to Length(CoorinateSystemCategories)-1 do
     ComboBox2.Items.Add(CoorinateSystemCategories[i]);

   Combobox2.Sorted := true;
   ComboBox2.ItemIndex :=0;
   ComboBox2.OnChange(nil);

   for I := 0 to Length(DatumList)-1 do
    if not  DatumList[i].Hidden then
     ComboBox1.Items.Add(DatumList[i].Caption);
   ComboBox1.ItemIndex := 0;
   ComboBox1.OnChange(nil);

   findwgs;
 end;

 {
 if MainForm.isRoutesDatum then
 begin
  for i := 0 to ComboBox1.Items.Count - 1 do
    if DatumList[MainForm.RoutesDatum].Caption = ComboBox1.Items[I] then
      ComboBox1.ItemIndex := i;
 end 
   else
     begin
       for i := 0 to ComboBox2.Items.Count - 1 do
         if CoordinateSystemList[MainForm.RoutesCS].Category = ComboBox2.Items[I] then
            ComboBox2.ItemIndex := i;
       ComboBox2.OnChange(nil);     
       for i := 0 to ListBox4.Items.Count - 1 do
         if CoordinateSystemList[MainForm.RoutesCS].Caption = ListBox4.Items[I] then
            ListBox4.ItemIndex := i;
     end;   

 SpinEdit1.Value := MainForm.RoutesTabStart;
 
 ValueList.Cells[1,1] := IntToStr(MainForm.RoutesNameTab+1);
 ValueList.Cells[1,2] := IntToStr(MainForm.RoutesXTab+1);
 ValueList.Cells[1,3] := IntToStr(MainForm.RoutesYTab+1);
 if ValueList.RowCount>4 then 
   ValueList.Cells[1,4] := IntToStr(MainForm.RoutesZTab+1);

 ValueList2.Cells[1,1] := IntToStr(MainForm.RoutesX2Tab+1);
 ValueList2.Cells[1,2] := IntToStr(MainForm.RoutesY2Tab+1);
 if ValueList2.RowCount>3 then
    ValueList2.Cells[1,3] := IntToStr(MainForm.RoutesZ2Tab+1);

 if MainForm.isRoutesDatum then
 begin
   PageControl1.ActivePageIndex:= 0;
   Combobox1.OnChange(nil);
   RadioGroup2.OnClick(nil);
 end  
    else
      begin
       PageControl1.ActivePageIndex := 1;
       ListBox4.OnClick(nil);
      end;
              }
 if PageControl1.ActivePageIndex = 1 then
    ListBox4.OnClick(nil);
    
 RefreshRes;
end;

procedure TLoadRData.FormCreate(Sender: TObject);
begin
    S :=TStringList.Create;
    OTList :=TStringList.Create;
    
    oldidx := -1;

    LatS := 'Широта B, ';
    LonS := 'Долгота L, ';
    XS := 'X, м'; YS := 'Y, м'; ZS := 'Z, м';
    NordS := 'Север, м';
    SouthS:= 'Юг, м';
    NSS := 'Север/Юг, м';
    EWS := 'Запад/Восток, м';
    WestS := 'Запад, м';
    EastS := 'Восток, м';
    HS := 'Высота, м';
    NameS := 'Имя'
end;

procedure TLoadRData.FormDestroy(Sender: TObject);
begin
  S.Destroy;
  OTList.Destroy;
end;

procedure TLoadRData.FormShow(Sender: TObject);
begin
  OnActivate(Sender);
  RadioGroup2.OnClick(nil);
  RefreshRes;


  LatS := inf[0];
  LonS := inf[1];
  XS := inf[2]; YS := inf[3]; ZS := inf[4];
  NordS := inf[5];
  SouthS:= inf[6];
  NSS := inf[7];
  EWS := inf[8];
  WestS := inf[9];
  EastS := inf[10];
  NameS := inf[11];
  HS := inf[201];

  ValueList.TitleCaptions[0]:= inf[12];
  ValueList.TitleCaptions[1]:= inf[13];

  ValueList2.TitleCaptions[0]:= inf[12];
  ValueList2.TitleCaptions[1]:= inf[13];

  InitOT;
end;

procedure TLoadRData.HgtTabIsClick(Sender: TObject);
begin
  HgtTab.Visible := HgtTabIs.ItemIndex > 0;
  case PageControl1.ActivePageIndex of
      0:  RadioGroup2.OnClick(nil);
      1:  ListBox4.OnClick(nil);
  end;
  Optmp.ItemIndex := 0;
  OTDel.Visible := false;  
  RefreshRes;
end;

procedure TLoadRData.InitOT;
var FN:string;
begin
  SetCurrentDir(MyDir);

  case PC2.ActivePageIndex of
    0: FN := 'Data\import_routes.txt';
    1: FN := 'Data\import_markers.txt';
  end;

  if fileexists(FN) = false then
  begin
    OpTmp.Items.Clear;
    OpTmp.Items.SaveToFile(FN);
  end;

  LoadOTList(FN);

end;

procedure TLoadRData.RefreshRes;
var i : integer;
    Sep : String;
begin
   ClearGrid(StringGrid1);

  { if TabSheet1.PageIndex = 0 then
     RenameTabs(StringGrid1,RadioGroup2.ItemIndex)
       else
         ListBox4.OnClick;   }
    
   try

   for i:= SpinEdit1.Value-1 to S.count-1 do
   Begin
     if i<0 then
       continue;
       
     if i > 3 + (SpinEdit1.Value-1) then exit;

     with StringGrid1 do
      // if i >= 4 - (SpinEdit1.Value-1) + RowCount-2 then
         RowCount := 5; //i + 2 - (SpinEdit1.Value-1);

     if StringGrid1.RowCount > 1 then
       StringGrid1.FixedRows := 1;

     case RSpacer.ItemIndex of
        0: sep:=' ';
        1: sep:=#$9;
        2: if Spacer.Text<> '' then sep := Spacer.Text[1];
        3: sep:=';';
        4: sep:=',';
     end;

     StringGrid1.Cells[0,i+1-(SpinEdit1.Value-1)] := GetCols(s[i],sep, StrToInt(ValueList.Cells[1,1])-1,1);
     StringGrid1.Cells[1,i+1-(SpinEdit1.Value-1)] := GetCols(s[i],sep, StrToInt(ValueList.Cells[1,2])-1,1);
     StringGrid1.Cells[2,i+1-(SpinEdit1.Value-1)] := GetCols(s[i],sep, StrToInt(ValueList.Cells[1,3])-1,1);
     
     if ValueList.RowCount>4 then
       StringGrid1.Cells[3,i+1-(SpinEdit1.Value-1)] := GetCols(s[i],sep, StrToInt(ValueList.Cells[1,4])-1,1);

     if PC2.ActivePageIndex = 1 then
     if HgtTabIs.ItemIndex > 0 then
     if HgtTabIs.Enabled then
     begin
        StringGrid1.Cells[3,i+1-(SpinEdit1.Value-1)] := GetCols(s[i], sep, HgtTab.Value-1,1);
     end;

     

     if RoutesBE.ItemIndex = 0 then
     begin
        if ValueList.RowCount>4 then
        begin
          StringGrid1.Cells[0,i+1-(SpinEdit1.Value-1)] := GetCols(s[i],sep, StrToInt(ValueList.Cells[1,1])-1,1);

          StringGrid1.Cells[1,i+1-(SpinEdit1.Value-1)] := GetCols(s[i],sep, StrToInt(ValueList.Cells[1,2])-1,1);
          StringGrid1.Cells[2,i+1-(SpinEdit1.Value-1)] := GetCols(s[i],sep, StrToInt(ValueList.Cells[1,3])-1,1);
          StringGrid1.Cells[3,i+1-(SpinEdit1.Value-1)] := GetCols(s[i],sep, StrToInt(ValueList.Cells[1,4])-1,1);

          StringGrid1.Cells[4,i+1-(SpinEdit1.Value-1)] := GetCols(s[i],sep, StrToInt(ValueList2.Cells[1,1])-1,1);
          StringGrid1.Cells[5,i+1-(SpinEdit1.Value-1)] := GetCols(s[i],sep, StrToInt(ValueList2.Cells[1,2])-1,1);
          StringGrid1.Cells[6,i+1-(SpinEdit1.Value-1)] := GetCols(s[i],sep, StrToInt(ValueList2.Cells[1,3])-1,1);
        end
         else
         begin
            StringGrid1.Cells[0,i+1-(SpinEdit1.Value-1)] := GetCols(s[i],sep, StrToInt(ValueList.Cells[1,1])-1,1);

            StringGrid1.Cells[1,i+1-(SpinEdit1.Value-1)] := GetCols(s[i],sep, StrToInt(ValueList.Cells[1,2])-1,1);
            StringGrid1.Cells[2,i+1-(SpinEdit1.Value-1)] := GetCols(s[i],sep, StrToInt(ValueList.Cells[1,3])-1,1);

            StringGrid1.Cells[3,i+1-(SpinEdit1.Value-1)] := GetCols(s[i],sep, StrToInt(ValueList2.Cells[1,1])-1,1);
            StringGrid1.Cells[4,i+1-(SpinEdit1.Value-1)] := GetCols(s[i],sep, StrToInt(ValueList2.Cells[1,2])-1,1);
         end;

     end;
   end;

   except
   end;

  
end;

procedure TLoadRData.RenameTabs(StringGrid: TStringGrid; TabNameStyle: byte);
var i: integer;
begin
 
  case TabNameStyle of
    4: begin
      StringGrid.Cells[0,0] := NameS;
      StringGrid.Cells[2,0] := SouthS;
      StringGrid.Cells[1,0] := WestS;

      if RoutesBE.ItemIndex = 0 then
        StringGrid.ColCount := 5
        else
          StringGrid.ColCount := 3;
      
      if StringGrid.ColCount>4 then
      begin
        StringGrid.Cells[3,0] := WestS;
        StringGrid.Cells[4,0] := SouthS;
      end;
      
     // StringGrid.Cells[3,0] := 'Высота над эл., м';
    end;

    3: begin
      StringGrid.Cells[0,0] := NameS;
      StringGrid.Cells[1,0] := EastS;
      StringGrid.Cells[2,0] := NordS;

      if RoutesBE.ItemIndex = 0 then
        StringGrid.ColCount := 5
        else
          StringGrid.ColCount := 3;

      if StringGrid.ColCount>4 then
      begin
        StringGrid.Cells[3,0] := EastS;
        StringGrid.Cells[4,0] := NordS;
      end;
    end;

    2: begin
      StringGrid.Cells[0,0] := NameS;
      StringGrid.Cells[1,0] := EastS;
      StringGrid.Cells[2,0] := NordS;

      if RoutesBE.ItemIndex = 0 then
        StringGrid.ColCount := 5
        else
          StringGrid.ColCount := 3;
          
      if StringGrid.ColCount>4 then
      begin
        StringGrid.Cells[3,0] := EastS;
        StringGrid.Cells[4,0] := NordS;
      end;
    end;

    1: begin
      StringGrid.Cells[0,0] := NameS;
      StringGrid.Cells[1,0] := XS;
      StringGrid.Cells[2,0] := YS;
      StringGrid.Cells[3,0] := ZS;

      if RoutesBE.ItemIndex = 0 then
        StringGrid.ColCount := 7
        else
          StringGrid.ColCount := 4;

      if StringGrid.ColCount>4 then
      begin
        StringGrid.Cells[4,0] := XS;
        StringGrid.Cells[5,0] := YS;
        StringGrid.Cells[6,0] := ZS;
      end;
    end;

    0: begin
      StringGrid.Cells[0,0] := NameS;
      StringGrid.Cells[1,0] := LatS+#176;
      StringGrid.Cells[2,0] := LonS+#176;

      if RoutesBE.ItemIndex = 0 then
        StringGrid.ColCount := 5
        else
          StringGrid.ColCount := 3;

      if StringGrid.ColCount>=4 then
      begin
         StringGrid.Cells[3,0] := LatS+#176;
         StringGrid.Cells[4,0] := LonS+#176;
      end;
    end;
  end;

  if PC2.ActivePageIndex = 1 then
  if HgtTabIs.ItemIndex > 0 then
     if TabNameStyle = 1 then
       HgtTabIs.Enabled := false
     else
     begin
       HgtTabIs.Enabled := true;
       StringGrid.ColCount :=  StringGrid.ColCount +1;
       StringGrid.Cells[StringGrid.ColCount-1,0] := HS;
     end;


  for i:= 0 to StringGrid1.ColCount-1 do
    StringGrid1.ColWidths[i] := (StringGrid1.Width - 10) div StringGrid1.ColCount;
end;

procedure TLoadRData.RoutesBEClick(Sender: TObject);
begin
  ValueList2.Visible := RoutesBE.ItemIndex = 0;
  if TabSheet1.PageIndex = 0 then
    RadioGroup2.OnClick(nil)
     else
      ListBox4.OnClick(nil);

   Optmp.ItemIndex := 0;
   OTDel.Visible := false;
end;

procedure TLoadRData.ValueList2Click(Sender: TObject);
begin
  Optmp.ItemIndex := 0;
  OTDel.Visible := false;
end;

procedure TLoadRData.ValueListClick(Sender: TObject);
begin
  Optmp.ItemIndex := 0;
  OTDel.Visible := false;
end;

procedure TLoadRData.ValueListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  RefreshRes;
end;

procedure TLoadRData.ListBox4Click(Sender: TObject);
var i, CoordType : integer;
begin
   if ListBox4.ItemIndex <= -1 then
    exit;
    
   i := FindCoordinateSystemByCaption(ListBox4.Items[ListBox4.ItemIndex]);
   CoordType := CoordinateSystemList[i].ProjectionType;
                
   case CoordType of
    3,4: begin
      ValueList.Keys[1] := NameS;
      ValueList.Keys[2] := EWS;
      ValueList.Keys[3] := NSS;

      if ValueList.RowCount=5 then
         ValueList.DeleteRow(4);

      ValueList2.Keys[1] := EWS;
      ValueList2.Keys[2] := NSS;

      if ValueList2.RowCount=4 then
         ValueList2.DeleteRow(3);
    end;

    2: begin
      ValueList.Keys[1] := NameS;
      ValueList.Keys[2] := EWS;
      ValueList.Keys[3] := NSS;

      if ValueList.RowCount=5 then
         ValueList.DeleteRow(4);

      ValueList2.Keys[1] := EWS;
      ValueList2.Keys[2] := NSS;

      if ValueList2.RowCount=4 then
         ValueList2.DeleteRow(3);

    end;

    1: begin
      ValueList.Keys[1] := NameS;
      ValueList.Keys[2] := XS;
      ValueList.Keys[3] := YS;

      if ValueList.RowCount<5 then
        ValueList.InsertRow(ZS, '4', true);

      ValueList2.Keys[1] := XS;
      ValueList2.Keys[2] := YS;

      if ValueList2.RowCount<4 then
         ValueList2.InsertRow(ZS, '7', true);
    end;

    0: begin
      ValueList.Keys[1] := NameS;
      ValueList.Keys[2] := LatS+#176;
      ValueList.Keys[3] := LonS+#176;

      if ValueList.RowCount = 5 then
         ValueList.DeleteRow(4);

      ValueList2.Keys[1] :=  LatS +#176;
      ValueList2.Keys[2] :=  LonS +#176;

      if ValueList2.RowCount = 4 then
         ValueList2.DeleteRow(3);
    end;
    

  end;
  RenameTabs(StringGrid1,CoordType);
  Optmp.ItemIndex := 0;
  OTDel.Visible := false;
end;

procedure TLoadRData.ComboBox2Change(Sender: TObject);
begin
  if ComboBox2.ItemIndex<>-1 then
    findCat(ComboBox2.Items[ComboBox2.ItemIndex], ListBox4);
  //Form2.ListBox4.Sorted :=true;
  ListBox4.ItemIndex :=0;
  ListBox4.OnClick(nil);
  
  Optmp.ItemIndex := 0;
  OTDel.Visible := false;
end;

procedure TLoadRData.PageControl1Change(Sender: TObject);
begin
  case PageControl1.ActivePageIndex of
    0: begin
         ComboBox1.OnChange(nil);
         RadioGroup2.OnClick(nil);
       end;
    1: begin
        ComboBox2.OnChange(nil);
        ListBox4.OnClick(nil);
      end;
  end;   
end;

procedure TLoadRData.ListBox4MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  idx : Longint;
begin
  with Sender as TListBox do begin
    idx := ItemAtPos(Point(x,y),True);
    if (idx < 0) or (idx = oldidx) then
      Exit;

    Application.ProcessMessages;
    Application.CancelHint;

    oldidx := idx;

    HintX := TListBox(Sender).itemRect(idx).Left;
    HintY := TListBox(Sender).itemRect(idx).Top;

    Hint := '';
    if Canvas.TextWidth(Items[idx]) > Width - 24 then
      Hint:=Items[idx];

  end;
end;

procedure TLoadRData.LoadOTList(FN:String);
var I:Integer;
begin
  OTList.LoadFromFile(FN);
  OpTmp.Items.Clear;
  OpTmp.Items.Add('');
  for I := 0 to OTList.Count - 1 do
    OpTmp.Items.Add(GetCols(OTList[I],#$9,0,1));

end;

procedure TLoadRData.OpenFile(FileName: String);
begin
  if (AnsiLowerCase(Copy(FileName, Length(FileName)-3,4))='.xls')or
        (AnsiLowerCase(Copy(FileName, Length(FileName)-4,5))='.xlsx')  then
     begin
        ExcelToStringList(FileName, S);
        RSpacer.ItemIndex := 1;
     end
     else
  S.LoadFromFile(FileName);
  FName := FileName;
end;

procedure TLoadRData.OpTmpChange(Sender: TObject);
var I, N, j : Integer;
begin
  OTDel.Visible := OpTmp.ItemIndex > 0;
  N :=  OpTmp.ItemIndex - 1;
  if OpTmp.ItemIndex > 0 then
  begin
    PageControl1.ActivePageIndex := StrToInt(GetCols(OTList[N],#$9,1,1));

    case PageControl1.ActivePageIndex of
      0: begin
           for I := 0 to Length(DatumList) - 1 do
             if DatumList[I].Name = GetCols(OTList[N],#$9,2,1) then
             begin
               for j := 0 to Combobox1.Items.Count - 1 do
                 if  DatumList[I].Caption = Combobox1.Items[j] then
                 begin
                   Combobox1.ItemIndex := j;
                   break;
                 end;
               break;
             end;
           Radiogroup2.ItemIndex := StrToInt(GetCols(OTList[N],#$9,3,1));
           Radiogroup2.OnClick(nil);
      end;
      1: begin
           for I := 0 to Length(CoordinateSystemList) - 1 do
             if CoordinateSystemList[I].Name = GetCols(OTList[N],#$9,2,1) then
             begin
               for j := 0 to ComboBox2.Items.Count - 1 do
                 if CoordinateSystemList[I].Category = ComboBox2.Items[j] then
                 begin
                   ComboBox2.ItemIndex := j;
                   ComboBox2.OnChange(nil);
                   break;
                 end;

                 for j := 0 to ListBox4.Items.Count - 1 do
                 if ListBox4.Items[j] = CoordinateSystemList[I].Caption then
                 begin
                   ListBox4.ItemIndex := j;
                   ListBox4.OnClick(nil);
                   break;
                 end;
               
               break;
             end;
      end;
    end;

    RSpacer.ItemIndex := StrToInt(GetCols(OTList[N],#$9,4,1));
    Spacer.Text := GetCols(OTList[N],#$9,5,1);
    SpinEdit1.Value := StrToInt(GetCols(OTList[N],#$9,6,1));

    ValueList.Cells[1,1] := GetCols(OTList[N],#$9,7,1);
    ValueList.Cells[1,2] := GetCols(OTList[N],#$9,8,1);
    ValueList.Cells[1,3] := GetCols(OTList[N],#$9,9,1);
    ValueList2.Cells[1,1] := GetCols(OTList[N],#$9,10,1);
    ValueList2.Cells[1,2] := GetCols(OTList[N],#$9,11,1);

    case PC2.ActivePageIndex of
      0: RoutesBE.ItemIndex := StrToInt(GetCols(OTList[N],#$9,12,1));
      1: HgtTabIs.ItemIndex := StrToInt(GetCols(OTList[N],#$9,12,1));
    end;

    I := 13;
    if ValueList.RowCount = 5 then
    begin
       ValueList.Cells[1,4] :=  GetCols(OTList[N],#$9,I,1);
       inc(I);
    end;

    if ValueList2.RowCount = 4 then
       ValueList2.Cells[1,3] := GetCols(OTList[N],#$9,I,1);

    OpTmp.ItemIndex :=  N + 1;
    
  end;
    OTDel.Visible := OpTmp.ItemIndex > 0;
end;

procedure TLoadRData.OTDelClick(Sender: TObject);
var FN:string;
begin
  if OPTmp.ItemIndex = 0 then
    exit;

  SetCurrentDir(MyDir);

  case PC2.ActivePageIndex of
    0: FN := 'Data\import_routes.txt';
    1: FN := 'Data\import_markers.txt';
  end;

  if messageDlg(inf[224], mtConfirmation, mbYesNo, 0) = 6 then
  begin
    OTList.Delete(OPTmp.ItemIndex-1);
    OPTmp.Items.Delete(OPTmp.ItemIndex);
    OTList.SaveToFile(FN);
  end;

  OPTmp.ItemIndex := 0;
  OTDel.Visible := false;
end;

procedure TLoadRData.OTSaveClick(Sender: TObject);
var FN, NewName, NewStr:string; I : Integer;
begin
  SetCurrentDir(MyDir);

  case PC2.ActivePageIndex of
    0: FN := 'Data\import_routes.txt';
    1: FN := 'Data\import_markers.txt';
  end;

  if InputQuery(inf[223], inf[223], NewName) then
  begin
    if NewName = '' then
      NewName := '*';

    NewStr := Newname + #$9 + IntToStr(PageControl1.ActivePageIndex);
    case PageControl1.ActivePageIndex of
      0: NewStr := NewStr  + #$9 +
         DatumList[FindDatumByCaption(ComboBox1.Items[ComboBox1.ItemIndex])].Name
         + #$9 +  IntToStr(RadioGroup2.ItemIndex);
      1: NewStr := NewStr  + #$9 +
         CoordinateSystemList[FindCoordinateSystemByCaption
                                  (ListBox4.Items[ListBox4.ItemIndex])].Name + #$9 + '0';
    end;

    if Spacer.Text ='' then
       Spacer.Text :=' ';

    NewStr := NewStr + #$9 + IntToStr(RSpacer.ItemIndex) + #$9 + Spacer.Text;
    NewStr := NewStr + #$9 + IntToStr(SpinEdit1.Value);

    NewStr := NewStr + #$9 + ValueList.Cells[1,1];
    NewStr := NewStr + #$9 + ValueList.Cells[1,2];
    NewStr := NewStr + #$9 + ValueList.Cells[1,3];

    NewStr := NewStr + #$9 + ValueList2.Cells[1,1];
    NewStr := NewStr + #$9 + ValueList2.Cells[1,2];

    case PC2.ActivePageIndex of
      0: NewStr := NewStr + #$9 + IntToStr(RoutesBE.ItemIndex);
      1: NewStr := NewStr + #$9 + IntToStr(HgtTabIs.ItemIndex);
    end;

    if ValueList.RowCount = 5 then
       NewStr := NewStr + #$9 + ValueList.Cells[1,4];

    if ValueList2.RowCount = 4 then
       NewStr := NewStr + #$9 + ValueList2.Cells[1,3];

    OTList.Add(NewStr);
    OTList.SaveToFile(FN);

    OPTmp.Items.Add(NewName);
    OPTmp.ItemIndex := OPTmp.Items.Count-1;
  end;

end;

end.
