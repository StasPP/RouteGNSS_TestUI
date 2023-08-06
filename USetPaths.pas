unit USetPaths;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, RTKLibExecutor;

type
  TFProcSet = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    OpenDialog1: TOpenDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FProcSet: TFProcSet;

implementation

{$R *.dfm}

procedure TFProcSet.Button1Click(Sender: TObject);
begin
  RTKLibDest     := Edit1.Text;
  RTKLibDestPPP  := Edit2.Text;
  close;
end;

procedure TFProcSet.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TFProcSet.FormShow(Sender: TObject);
begin
  Edit1.Text := RTKLibDest;
  Edit2.Text := RTKLibDestPPP;
end;

procedure TFProcSet.SpeedButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Edit1.Text := OpenDialog1.FileName;
end;

procedure TFProcSet.SpeedButton2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Edit2.Text := OpenDialog1.FileName;
end;

end.
