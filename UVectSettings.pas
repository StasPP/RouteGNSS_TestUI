unit UVectSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, GNSSObjects;

type
  TFVectSettings = class(TForm)
    Image3: TImage;
    StatImg: TImage;
    VectLabel: TLabel;
    isAc: TCheckBox;
    StatusLabel: TLabel;
    Button1: TButton;
    Button2: TButton;
    BEdit: TEdit;
    REdit: TEdit;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    Button3: TButton;
    Memo1: TMemo;
    Label2: TLabel;
    procedure ShowVectorProp(VectN:integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FVectSettings: TFVectSettings;

implementation

{$R *.dfm}

{ TFVectSettings }

procedure TFVectSettings.ShowVectorProp(VectN: integer);
begin
///
  ShowModal;
end;

end.
