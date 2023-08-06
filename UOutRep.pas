unit UOutRep;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList;

type
  TOutRep = class(TForm)
    Panel3: TPanel;
    Panel4: TPanel;
    Button6: TButton;
    Button1: TButton;
    Panel1: TPanel;
    ListBox1: TListBox;
    ImageList1: TImageList;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OutRep: TOutRep;

implementation

{$R *.dfm}

procedure TOutRep.Button1Click(Sender: TObject);
begin
  close;
end;

end.
