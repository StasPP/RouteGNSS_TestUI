unit UWinManager;

interface

 uses SysUtils, Forms, Classes, StdCtrls, ExtCtrls, Buttons, Menus, ComCtrls,
      Dialogs;

type TAppWind = record
   WindName  :string;
   WindParam :integer;
   WParamArr :array of Integer;
end;

const WMax :integer = 128;

var WinList  :Array [0..128] of TAppWind;
    WinIndex :integer;

procedure OpenRecentWin;
procedure CloseWin(WinName:string);
//procedure NewWin(CurrentWinName, NewWinName:string);


implementation

procedure OpenRecentWin;
var I:Integer;
begin
//  I := Length(WinList)-1;
//  for I := 0 to Application.ComponentCount - 1  do
//  Begin
//    if Application.Components[I].Name = WinList[WinIndex].WindName then
//      with Application.Components[I] as TForm Do
//      begin
//         if WinIndex 
//         Showmodal;
//         break;
//      end;
//  End;
end;

procedure CloseWin(WinName:string);
var I:integer;
begin
//  I := Length(WinList);
//  SetLength(WinList, I+1);
//  WinList[I] := WinName;
end;


end.
