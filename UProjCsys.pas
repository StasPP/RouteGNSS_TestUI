unit UProjCsys;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, UGNSSProject, GeoClasses, GeoFunctions,
  Geoid, RTKLibExecutor, GeoFiles;

type
  TFProjCsys = class(TForm)
    CSBox: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    AddButton: TSpeedButton;
    DelSBtn: TSpeedButton;
    Panel4: TPanel;
    Label1: TLabel;
    Panel5: TPanel;
    Label2: TLabel;
    GeoidBox: TComboBox;
    CfgButton: TSpeedButton;
    AcceptButton: TSpeedButton;
    Panel6: TPanel;
    Panel7: TPanel;
    procedure GeoidBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure CSBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure RefreshBoxes;
    procedure CSBoxClick(Sender: TObject);
    procedure DelSBtnClick(Sender: TObject);
    procedure AcceptButtonClick(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure CfgButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowProjCsys(Img:TImagelist);
  end;

var
  FProjCsys: TFProjCsys;
  ImgList :TImageList;

implementation

uses CoordSysFmNew;

{$R *.dfm}

procedure TFProjCsys.GeoidBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  ComboBox: TComboBox;
  bitmap: TBitmap;
  I: Integer;
begin

  ComboBox := (Control as TComboBox);
  Bitmap := TBitmap.Create;
  try
    if Index > 0 then
      ImgList.GetBitmap(113, Bitmap);
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

procedure TFProjCsys.RefreshBoxes;
var I:Integer;
begin
  CSBox.Clear;
  for I := 0 to Length(PrjCS) - 1 do
     CSBox.Items.Add(CoordinateSystemList[PrjCS[I]].Caption);

  GeoidBox.Clear;
  GeoidBox.Items.Add('(none)');
  for I := 0 to Length(GeoidsMetaData) - 1 do
     GeoidBox.Items.Add(Trim(GeoidsMetaData[I].Caption));

  GeoidBox.ItemIndex := 0;
  if Length(GeoidList) > 0 then
  for I := 0 to GeoidBox.Items.Count - 1 do
  if Trim(GeoidList[0].Caption) = GeoidBox.Items[I]  then
  begin
    GeoidBox.ItemIndex := I;
  end;
end;

procedure TFProjCsys.CSBoxClick(Sender: TObject);
var I:Integer;
begin
  DelSBtn.Enabled := false;

  For I := 0 To CSBox.Items.Count-1 Do
     if CSBox.Selected[I] then
     begin
       DelSBtn.Enabled := true;
       break;
     end;
end;

procedure TFProjCsys.CSBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var I:integer;
begin
 with (Control as TListBox).Canvas do
  begin

    try
      I := CoordinateSystemList[PrjCS[Index]].ProjectionType;
      case I of
        0: I := 110;
        1: I := 111;
        2..5: I := 112
      end;
    except
        I := 110;
    end;

    ImgList.Draw((Control as TListBox).Canvas, Rect.Left, Rect.Top-1, I);

    TextOut(Rect.Left + 20, Rect.Top, (Control as TListBox).Items[Index]);

    if odFocused In State then begin
      Brush.Color := (Control as TListBox).Color;
      DrawFocusRect(Rect);
    end;

  end;
end;

procedure TFProjCsys.DelSBtnClick(Sender: TObject);
var I, j : Integer;
begin
    For I := CSBox.Items.Count-1 downTo 0 Do
    if CSBox.Selected[I] then
    begin

      for j := I to Length(PrjCS) - 2 do
        PrjCS[j] := PrjCS[j+1];

      SetLength(PrjCS,Length(PrjCS)-1);
    end;
    RefreshBoxes;
end;

procedure TFProjCsys.ShowProjCsys(Img: TImagelist);
begin
  ImgList := Img;
  RefreshBoxes;
  showmodal;
end;

procedure TFProjCsys.AddButtonClick(Sender: TObject);
begin
  CSFormNew.ShowModal;
  RefreshBoxes;
end;


function ExecAndWait(const FileName,
                     Params: ShortString;
                     const WinState: Word): boolean; export; 
var 
  StartInfo: TStartupInfo; 
  ProcInfo: TProcessInformation; 
  CmdLine: ShortString;
begin 
  { Помещаем имя файла между кавычками, с соблюдением всех пробелов в именах Win9x } 
  CmdLine := '"' + Filename + '" ' + Params; 
  FillChar(StartInfo, SizeOf(StartInfo), #0); 

  with StartInfo do
  begin 
    cb := SizeOf(StartInfo);
    dwFlags := STARTF_USESHOWWINDOW; 
    wShowWindow := WinState; 
  end; 
  Result := CreateProcess(nil, PChar( String( CmdLine ) ), nil, nil, false, 
                          CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, 
                          PChar(ExtractFilePath(Filename)),StartInfo,ProcInfo); 
  { Ожидаем завершения приложения } 
  if Result then 
  begin 
    WaitForSingleObject(ProcInfo.hProcess, INFINITE); 
    { Free the Handles } 
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end; 
end;


procedure TFProjCsys.CfgButtonClick(Sender: TObject);
begin
  SetCurrentDir(RTKWorkDir);
  ExecAndWait(PChar(RTKWorkDir+'Geo.exe'),'-ed', sw_restore);
  GeoReset;
  GeoInit('Data\Sources.loc', '', '');
  RefreshGNSSProjectCSs;
  CSFormNew.FullRefresh;
  RefreshBoxes;
end;

procedure TFProjCsys.AcceptButtonClick(Sender: TObject);
begin
 if GeoidBox.ItemIndex > 0 then
 begin
   PrjGeoidName := GeoidsMetaData[GeoidBox.ItemIndex -1].NameID;
   ReLoadGeoidbyID(PrjGeoidName, 0);
 end else
 begin
   PrjGeoidName := '';
   SetLength(GeoidList, 0);
 end;
 close;
end;

end.
