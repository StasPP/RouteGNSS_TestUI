unit FProcGNSS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RTKLibExecutor, StdCtrls, Buttons, ExtCtrls, ComCtrls, shellApi;

type
  TProcGNSS = class(TForm)
    Progress: TProgressBar;
    MainPan: TPanel;
    MemoPan: TPanel;
    Memo: TMemo;
    ButtonsPan: TPanel;
    StopBtn: TSpeedButton;
    ShowMemo: TSpeedButton;
    StatusLabel: TLabel;
    MemoSubPan1: TPanel;
    MemoSubPan2: TPanel;
    MessagesLabel: TLabel;
    procedure MemoChange(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ShowMemoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowModal2(S:String; Count:integer);
    var Cancelled :Boolean;
  end;

var
  ProcGNSS  :TProcGNSS;
  ProcCount :Integer;
implementation

{$R *.dfm}

procedure TProcGNSS.FormShow(Sender: TObject);
begin
    Progress.Position := 0;
    StatusLabel.Caption := '';
    Memo.Lines.Clear;
    Cancelled := false;

    if MemoPan.Visible then
    begin
      MemoPan.Visible := false;
      if Height > MemoPan.Height then
         Height := Height - MemoPan.Height
    end;   

end;

procedure TProcGNSS.MemoChange(Sender: TObject);
begin
  if Memo.Lines.Count = 0 then
    exit;
  if Memo.Lines[Memo.Lines.Count-1] = RTKLogStart then
    StatusLabel.Caption := 'Loading data...'       /// ToDo: Translate
  else
  if Memo.Lines[Memo.Lines.Count-1] = RTKLogEnd then
  begin
    StatusLabel.Caption := 'Done!';                /// ToDo: Translate
    Progress.Position := 100;
    Progress.Repaint;
    repaint;
    if (ProcCount = 0) then
      sleep(500);
    close;
  end
  else
  if Memo.Lines[Memo.Lines.Count-1] <> '' then
    StatusLabel.Caption := 'Processing...';        /// ToDo: Translate

end;

procedure TProcGNSS.StopBtnClick(Sender: TObject);
begin

  if MessageDlg('Stop the processing?', mtConfirmation, [mbYes, mbNo], 0) <> 6   /// ToDo: Translate
    then exit;

  StopRTKLib;
  StatusLabel.Caption := 'Canceled.';   /// ToDo: Translate
  repaint;

  if ProcCount >= 1 then
     if MessageDlg('Stop all the other '+ IntToStr(ProcCount) +' processings?'      /// ToDo: Translate
       ,mtConfirmation, [mbYes, mbNo], 0) = 6 then Cancelled := true;
  
  if (Cancelled) or (ProcCount = 0) then
    sleep(500);
  close;
end;

procedure TProcGNSS.ShowMemoClick(Sender: TObject);
begin
    if MemoPan.Visible then
    begin
      MemoPan.Visible := false;
      if Height > MemoPan.Height then
         Height := Height - MemoPan.Height
    end
    else
    begin
       MemoPan.Visible := true;
       Height := Height + MemoPan.Height;
    end;
end;

procedure TProcGNSS.ShowModal2(S: String; Count: integer);
begin
  Cancelled := false;
  Caption := 'GNSSProcessor: '+ S;
  ProcCount := Count;
  if Count >= 1 then
    Caption := Caption + ' (+'+inttoStr(Count) +' more left)';    /// ToDo: Translate
  if not Showing then
    ShowModal;
end;

end.
