unit FLoader;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, LangLoader;

type
   TFLoadGPS = class(TForm)
    ProgressBar1: TProgressBar;
    Panel1: TPanel;
    MapLoad: TLabel;
    LCount: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormHide(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FLoadGPS: TFLoadGPS;

implementation

{$R *.dfm}

procedure TFLoadGPS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Label3.Visible := false;
end;

procedure TFLoadGPS.FormHide(Sender: TObject);
begin
  Label3.Visible := false;
end;

end.
