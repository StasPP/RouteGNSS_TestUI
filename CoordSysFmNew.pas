unit CoordSysFmNew;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, GeoFunctions, GeoFiles, GeoString, GeoClasses,
  UGNSSProject;
  //MapperFm, LangLoader;

type
  TCSFormNew = class(TForm)
    ComboBox2: TComboBox;
    ListBox4: TListBox;
    Button1: TButton;
    Bevel1: TBevel;
    procedure ComboBox2Change(Sender: TObject);
    procedure ListBox4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBox4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ListBox4DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FullRefresh;  
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CSFormNew: TCSFormNew;
  FLang : String = 'Russian';
  oldidx : longInt = -1;
  HintX, HintY:Integer;

implementation

uses UProjCsys;

{$R *.dfm}

procedure FindCat(Cat: String; ListBox: TListBox);
var i: integer;
begin
 ListBox.Items.Clear;
 for i := 0 to Length( CoordinateSystemList)-1 do
  if CoordinateSystemList[i].Category = Cat then
    ListBox.Items.Add(CoordinateSystemList[i].Caption);
end;

procedure TCSFormNew.Button1Click(Sender: TObject);
var I, SC:Integer;
begin
  if ListBox4.ItemIndex <> -1 then
  begin
     SC := FindCoordinateSystemByCaption(ListBox4.Items[ListBox4.ItemIndex]);
     for I := 0 to Length(PrjCS) - 1 do
        if PrjCS[I] = SC  then
          exit;

     SetLength(PrjCSNames, Length(PrjCSNames)+1);
     SetLength(PrjCS, Length(PrjCS)+1);
     PrjCS[Length(PrjCS)-1] := SC;
     PrjCSNames[Length(PrjCSNames)-1] := CoordinateSystemList[SC].Name;
  end;
  close;
end;

procedure TCSFormNew.ComboBox2Change(Sender: TObject);
begin
 if ComboBox2.ItemIndex<>-1 then
    findCat(ComboBox2.Items[ComboBox2.ItemIndex],ListBox4);

  ListBox4.ItemIndex :=0;
  //ListBox4.OnClick(nil);
end;

procedure TCSFormNew.FormActivate(Sender: TObject);
begin
 WGS := FindDatum('WGS84');
 if  ComboBox2.Items.Count = 0 then
   FullRefresh;
end;

procedure TCSFormNew.FormShow(Sender: TObject);
begin
 {
 if Lang <> FLang then
 Begin
   ComboBox2.Items.Clear;
   OnActivate(nil);
   FLang := Lang;
 End; }

 OnActivate(nil);
end;

procedure TCSFormNew.FullRefresh;
var i:integer;
begin
   ComboBox2.Clear;
   for i := 0 to Length(CoorinateSystemCategories)-1 do
     ComboBox2.Items.Add(CoorinateSystemCategories[i]);

   Combobox2.Sorted := true;
   ComboBox2.ItemIndex := 0;
   ComboBox2.OnChange(nil);
end;

procedure TCSFormNew.ListBox4Click(Sender: TObject);
begin
 if ListBox4.ItemIndex <= -1 then
    exit;
  if CSFormNew.Visible then
    Button1.Click();
   // MapFm.CoordSysN := FindCoordinateSystemByCaption(ListBox4.Items[ListBox4.ItemIndex]);
end;

procedure TCSFormNew.ListBox4DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var I, CS:integer;
begin
 with (Control as TListBox).Canvas do
  begin

    try
      CS := FindCoordinateSystemByCaption(ListBox4.Items[Index]);
      I := CoordinateSystemList[CS].ProjectionType;
      case I of
        0: I := 110;
        1: I := 111;
        2..5: I := 112
      end;
    except
        I := 110;
    end;

    UProjCSys.ImgList.Draw((Control as TListBox).Canvas, Rect.Left, Rect.Top-1, I);

    TextOut(Rect.Left + 20, Rect.Top, (Control as TListBox).Items[Index]);

    if odFocused In State then begin
      Brush.Color := (Control as TListBox).Color;
      DrawFocusRect(Rect);
    end;

  end;
end;

procedure TCSFormNew.ListBox4MouseMove(Sender: TObject; Shift: TShiftState; X,
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
//  if  ListBox4.ItemAtPos(Point(x,y),True) > 0 then
  //  ListBox4.Hint := ListBox4.Items[ ListBox4.ItemAtPos(Point(x,y),True) ];
end;

end.
