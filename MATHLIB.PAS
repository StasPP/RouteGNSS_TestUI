
UNIT MATHLIB;

Interface

  FUNCTION TAN(ZN:DOUBLE):DOUBLE;
  FUNCTION ATAN2(X,Y:DOUBLE):DOUBLE;
  FUNCTION ASIN(ZN:DOUBLE):DOUBLE;
  FUNCTION ACOS(ZN:DOUBLE):DOUBLE;
  FUNCTION POW(Base,Power:DOUBLE):DOUBLE;

Implementation

(*-----------------------------------------------------------*)
FUNCTION TAN(ZN:DOUBLE):DOUBLE;
BEGIN
  TAN:=SIN(ZN)/COS(ZN);
END;
(*-----------------------------------------------------------*)
FUNCTION ATan2(X,Y:DOUBLE):DOUBLE;
VAR AT2,dr:DOUBLE;
BEGIN
  if x=0.0 then begin
     dr:=pi/2.0;
     if y<0.0 then dr:=-dr;
     ATan2:=dr;
     end
  else begin
     AT2:=arctan(abs(y/x));
     ATan2:=AT2;
     if (x>=0.0)and (y<0.0)  then ATan2:=-AT2;
     if (x<0.0) and (y<0.0)  then ATan2:=-pi+AT2;
     if (x<0.0) and (y>=0.0) then ATan2:= pi-AT2;
  end;
END;
(*-----------------------------------------------------------*)
FUNCTION ASIN(ZN:DOUBLE):DOUBLE;
BEGIN
  if ABS(zn)<>1 then
    ASIN:=ArcTan(zn/sqrt(1-zn*zn))
  else ASIN:=zn*Pi/2;
END;
(*-----------------------------------------------------------*)
FUNCTION ACOS(ZN:DOUBLE):DOUBLE;
BEGIN
  if zn<>0 then
    ACOS:=ArcTan(sqrt(1-zn*zn)/zn)
  else ACOS:=Pi/2;
END;
(*-----------------------------------------------------------*)
FUNCTION POW(Base,Power:DOUBLE):DOUBLE;
BEGIN
  Result:=1;
  If Power=0 then Exit;
  Result:=0;
  If Base=0 then exit;
  If Base>0 Then
    Result:=exp(Power*Ln(Base))
  else
    if Frac(Power)=0.0 Then begin
      Result:=exp(Power*Ln(-Base));
      if Round(-Power) mod 2=1 then Result:=-Result;
    end;
END;
(*-----------------------------------------------------------*)
END.


