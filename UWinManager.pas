unit UWinManager;

interface

 uses SysUtils, Forms, Classes, StdCtrls, ExtCtrls, Buttons, Menus, ComCtrls,
      Dialogs;

var WinList:Array of String;

procedure OpenRecentWin;
procedure CloseWin(WinName:string);
//procedure NewWin(CurrentWinName, NewWinName:string);


implementation

procedure OpenRecentWin;
var I:Integer;
begin
  I := Length(WinList)-1;
  for I := 0 to Application.ComponentCount - 1  do
  Begin
    if Application.Components[I].Name = WinList[I] then
      with Application.Components[I] as TForm Do
      begin
         SetLength(WinList, I);
         Showmodal;
         break;
      end;
  End;
end;

procedure CloseWin(WinName:string);
var I:integer;
begin
  I := Length(WinList);
  SetLength(WinList, I+1);
  WinList[I] := WinName;
end;


end.
