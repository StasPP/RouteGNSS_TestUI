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
    OCS: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    CSbox: TComboBox;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    ComboBox2: TComboBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Image3: TImage;
    SessionLabel: TLabel;
    StatusLabel: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure OpenRepWindow(RepKind:Integer; RepObj, RepObj2: Integer);
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

procedure TOutRep.OpenRepWindow(RepKind:Integer; RepObj, RepObj2: Integer);
begin
  ///
  ///
  Showmodal;
end;

end.
