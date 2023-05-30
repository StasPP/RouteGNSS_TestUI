program test;

{$APPTYPE CONSOLE}

uses
  SysUtils;
  var I:Integer;
begin
  writeln('!!!');
  for I := 0 to 100 do
  begin
    sleep(100);
    writeln(I)
  end;

end.
