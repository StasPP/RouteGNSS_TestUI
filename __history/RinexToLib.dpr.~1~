program RinexToLib;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  RTKLibExecutor in 'RTKLibExecutor.pas',
  FProcGNSS in 'FProcGNSS.pas' {ProcGNSS},
  GNSSObjects in 'GNSSObjects.pas',
  UGNSSSessionOptions in 'UGNSSSessionOptions.pas' {FGNSSSessionOptions},
  FLoader in 'FLoader.pas' {FLoadGPS},
  UStartProcessing in 'UStartProcessing.pas' {FStartProcessing},
  UGNSSPointSettings in 'UGNSSPointSettings.pas' {FGNSSPointSettings},
  UVectSettings in 'UVectSettings.pas' {FVectSettings},
  UAntProp in 'UAntProp.pas' {FAntProp};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TProcGNSS, ProcGNSS);
  Application.CreateForm(TFGNSSSessionOptions, FGNSSSessionOptions);
  Application.CreateForm(TFLoadGPS, FLoadGPS);
  Application.CreateForm(TFStartProcessing, FStartProcessing);
  Application.CreateForm(TFGNSSPointSettings, FGNSSPointSettings);
  Application.CreateForm(TFVectSettings, FVectSettings);
  Application.CreateForm(TFAntProp, FAntProp);
  Application.Run;
end.
