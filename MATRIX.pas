UNIT Matrix;

INTERFACE

(**************************************************************)
(*                                                            *)
(*             ПРОЦЕДУРЫ ДЛЯ РАБОТЫ С МАТРИЦАМИ               *)
(*                     И МАССИВАМИ                            *)
(*                                                            *)
(**************************************************************)

CONST  DivMinZ = 0.000001;
       DivMinS =  1.E-100;

//type Double = extended;

(*====================================================================*)
{в последующих четырех процедурах для хранения элементов матриц
 используется вся распределенная под них на момент вызова процедуры
 память}
(*--------------------------------------------------------------------*)

  PROCEDURE SUMMA(VAR A,B,C:ARRAY OF DOUBLE);
(*сложение матриц A+B=C*)

  PROCEDURE MUL(k:INTEGER;
                 A:ARRAY OF DOUBLE;
                 B:ARRAY OF DOUBLE;
                VAR C:ARRAY OF DOUBLE);
(*умножаются матрицы A[m.k] и B[k.l];C[m.l]-результат умножения*)

  PROCEDURE NEG(VAR A:ARRAY OF DOUBLE);
(*смена знака матрицы A:=-A*)

  PROCEDURE SCALAR(scl:DOUBLE;VAR A:ARRAY OF DOUBLE);
(*умножение матрицы на скаляр: A:=scl*A:*)


(*====================================================================*)
{в следующих пяти процедурах число элементов матриц принимается в
 соответствии с заданными размерностями независимо от распределенной
 памяти}
(*--------------------------------------------------------------------*)

  PROCEDURE SUMMA_(n:INTEGER;VAR A,B,C:ARRAY OF DOUBLE);

  PROCEDURE MUL_( m,k,n :INTEGER;
                VAR A : ARRAY OF DOUBLE;
                VAR B : ARRAY OF DOUBLE;
                VAR C : ARRAY OF DOUBLE);

  PROCEDURE NEG_(n:INTEGER;VAR A:ARRAY OF DOUBLE);

  PROCEDURE SCALAR_(k:INTEGER;scl:DOUBLE;
                           VAR A:ARRAY OF DOUBLE);

  PROCEDURE TRANSP(n,m:INTEGER;VAR A,B:ARRAY OF DOUBLE );
(*                                 т*)
(*транспонирование: A[n*m],B[m*n]=A *)

(*====================================================================*)

  FUNCTION Det (n:INTEGER; matr:ARRAY OF DOUBLE ):DOUBLE;
(*вычисление определителя кв.матрицы порядка n*)

(*====================================================================*)
(*обращение матрицы без выбора элементов*)

  PROCEDURE INV(n:word;(* порядок матрицы *)
                VAR A,         (* исходная матрица [n*n]  *)
                B:ARRAY OF DOUBLE;(* буфер [2* n *n]*)
                VAR dt:DOUBLE;(* определитель A       *)
                VAR InvA:ARRAY OF DOUBLE;
                (* обратная матрица  [n x n]             *)
                VAR res:BOOLEAN (* результат обращения *));
(*====================================================================*)

  PROCEDURE INVH(n:INTEGER; (* порядок матрицы *)
                VAR InvOld,     (* старая обратная *)
                A,          (* новая прямая    *)
                E,          (* буфер 2 диагональной n*n*)
                Buf:ARRAY OF DOUBLE (* буфер n*n *);
                VAR InvNew:ARRAY OF DOUBLE
                                      (* новая обратная *));
(*уточнение обратной матрицы методом Хотеллинга*)

  /// добавлено: 15-01-2020 Шевчук С. О.
  Function Invert(A: Array of Double;       // Исходная
                  var InvA:Array OF Double  // Результат
                  ):Boolean;                // Успех/отказ

  /// добавлено: 15-01-2020 Шевчук С. О.
  Function InvNew(A: Array of Double; var InvA:Array OF Double):Boolean;

(*====================================================================*)
                              (* псевдообращение матрицы[n*m] *)

  PROCEDURE PINV(n,m:INTEGER  (* размерности исходной матрицы *);
                VAR A,            (* исходная матрица             *)
                AT,           (* буфер транспонирования       *)
                B,            (* буфер     AT*A               *)
                BB,           (* буфер удвоенной     AT*A     *)
                I:ARRAY OF DOUBLE;(* буфер обратной   AT*A    *)
                VAR PInvA:ARRAY OF DOUBLE;
                              (* псевдообратная к A           *)
                VAR res:BOOLEAN(*результат псевдообращения    *));

(*====================================================================*)
{                           t                                          }
{разложение матрицы типа L*L                                           }

 PROCEDURE Low_ ( n:INTEGER ;            (*порядок*)
                 Const A:ARRAY OF DOUBLE;(*Исходная матрица*)
                 Norm:BOOLEAN;
          VAR T: ARRAY OF DOUBLE;        (*нижняя треугольная*)
          VAR res:        BOOLEAN);      (*результат*)

(*====================================================================*)
{                           t                                          }
{разложение матрицы типа H*H                                          }

 PROCEDURE High_ ( n:INTEGER;            (*порядок*)
                   Const A: ARRAY OF  DOUBLE;(*Исходная матрица *)
                Norm:BOOLEAN;
           VAR T: ARRAY OF DOUBLE;       (*Верхняя треугольная*)
           VAR res:        BOOLEAN);     (*результат*)

(*====================================================================*)
{принудительное симметрирование симметричной матрицы для
 повышения устойчивости вычислительного процесса}
PROCEDURE SymMatrix(N:INTEGER ;VAR M:ARRAY OF DOUBLE);
(*симметрирование матрицы*)
(*====================================================================*)

PROCEDURE InvSymMatr ( n:INTEGER ;       (*порядок матрицы*)
         Const A: ARRAY OF DOUBLE;       (*исходная матрица*)
           VAR B: ARRAY OF DOUBLE;       (*обратная матрица*)
           VAR T: ARRAY OF DOUBLE;       (*треугольная матрица*)
         VAR res:        BOOLEAN);       (*признак корректности*)
(* обращение симметричной матрицы n*n *)
(* с использованием разложения на две треугольные матрицы*)

(*====================================================================*)
PROCEDURE INV_(n:INTEGER;  Const A:ARRAY OF  DOUBLE;
                           VAR B,InvA:ARRAY OF DOUBLE);
(* обращение с выбором ведущего элемента для повышения точности
   обращения при возможном наличии малых ведущих элементов  *)
(*====================================================================*)
TYPE MaximLine=ARRAY[0..7999]OF Double;
     LinePtr=^MaximLine;

PROCEDURE InvBigSymMatr ( n:INTEGER;
           Const A: ARRAY OF LinePtr;
             VAR B: ARRAY OF LinePtr;
             VAR T: ARRAY OF LinePtr;
            VAR res:        BOOLEAN);

Function  Regress3(Num:integer;
                   Var M:array of double;
                   Var Cfs:array of double;
                   Var Kp,Kv,Ka,Kj:double;
                   Dia:double):boolean;
Function  Regress2(Num:integer;
                   Var M:array of double;
                   Var Cfs:array of double;
                   Var Kp,Kv,Ka:double;
                   Dia:double):boolean;
Function  Regress1(Num:integer;
                   Var M:array of double;
                   Var Cfs:array of double;
                   Var Kp,Kv:double;
                   Dia:double):boolean;
                   
IMPLEMENTATION
USES MATHLIB;

(*====================================================================*)

  PROCEDURE SUMMA(VAR A,B,C:ARRAY OF DOUBLE);

    VAR i:INTEGER;

    BEGIN
      FOR i:=low(A) TO HIGH(A) DO BEGIN
          C[i]:=A[i]+B[i];
      END;
    END;

(*====================================================================*)

  PROCEDURE   MUL ( k : INTEGER;
                 A : ARRAY OF DOUBLE;
                 B : ARRAY OF DOUBLE;
                VAR C : ARRAY OF DOUBLE);

    VAR
       i,j,l,m,n:INTEGER;

    BEGIN
      m:=(HIGH(A)-LOW(A)+1)DIV k;
      n:=(HIGH(B)-LOW(B)+1)DIV k;
      FOR i:=0 TO m-1 DO BEGIN
        FOR j:=0 TO n-1 DO BEGIN
          C[i*n+j+LOW(C)]:=0.0;
          FOR l:=0 TO k-1 DO BEGIN
            C[i*n+j+LOW(C)]:=C[i*n+j+LOW(C)]+
                             A[i*k+l+LOW(A)]*B[l*n+j+LOW(B)];
          END;
        END;
      END;
    END;

(*====================================================================*)

  PROCEDURE NEG (VAR A:ARRAY OF DOUBLE);

    VAR i:INTEGER;

    BEGIN
      FOR i:=LOW(A) TO HIGH(A) DO BEGIN
        A[i]:=-A[i];
      END;
    END;

(*====================================================================*)

  PROCEDURE SUMMA_(n:INTEGER;VAR A,B,C:ARRAY OF DOUBLE);

    VAR i:INTEGER;

    BEGIN
      FOR i:=LOW(A) TO LOW(A)+n-1 DO BEGIN
          C[i]:=A[i]+B[i];
      END;
    END;

(*====================================================================*)

  PROCEDURE   MUL_( m,k,n : INTEGER;
                VAR A : ARRAY OF DOUBLE;
                VAR B : ARRAY OF DOUBLE;
                VAR C : ARRAY OF DOUBLE);

    VAR
       i,j,l:INTEGER;

    BEGIN
      FOR i:=0 TO m-1 DO  BEGIN
        FOR j:=0 TO n-1 DO BEGIN
          C[i*n+j+LOW(C)]:=0.0;
          FOR l:=0 TO k-1 DO BEGIN
            C[i*n+j+LOW(C)]:=C[i*n+j+LOW(C)]+
                             A[i*k+l+LOW(A)]*B[l*n+j+LOW(B)];
          END;
        END;
      END;
    END;

(*====================================================================*)

  PROCEDURE NEG_(n:INTEGER;VAR A:ARRAY OF DOUBLE);

    VAR i:INTEGER;

    BEGIN
      FOR i:=LOW(A) TO LOW(A)+n-1 DO BEGIN
        A[i]:=-A[i];
      END;
    END;
(*====================================================================*)

  PROCEDURE SCALAR_(k:INTEGER;scl:DOUBLE;VAR A:ARRAY OF DOUBLE);

    VAR i:INTEGER;

    BEGIN
      FOR i:=LOW(A) TO LOW(A)+k-1 DO BEGIN
        A[i]:=scl*A[i];
      END;
    END;

(*====================================================================*)

  PROCEDURE SCALAR(scl:DOUBLE;VAR A:ARRAY OF DOUBLE);

    VAR i:INTEGER;

    BEGIN
      FOR i:=LOW(A) TO HIGH(A) DO BEGIN
        A[i]:=scl*A[i];
      END;
    END;

(*====================================================================*)

  PROCEDURE TRANSP(n,m:INTEGER;VAR A,B:ARRAY OF DOUBLE);
                                (*A-matr.[n*m],B-matr[m*n]*)
    VAR i,j:INTEGER;

    BEGIN
      FOR i:=0 TO m-1 DO
        FOR j:=0 TO n-1 DO BEGIN
          B[i*n+j+LOW(B)]:=A[j*m+i+LOW(A)];
        END;
    END ;

(*====================================================================*)

FUNCTION Det (n:INTEGER; matr:ARRAY OF DOUBLE):DOUBLE;
  LABEL M1;
    VAR i,j,j1,k,l,s,t : INTEGER;
                 determ: DOUBLE;
    BEGIN
      i:=LOW(MATR);
      j:=i;
      determ:=matr[0];
      FOR s:=1 TO n-1 DO BEGIN
        t:=n-s;
        FOR k:=1 TO t DO BEGIN
          j:=j+1;
          IF matr[i]<>0.0 THEN matr[j]:=matr[j]/matr[i]
          ELSE  BEGIN
            determ:=0.0;
            GOTO M1;
          END;
        END;
        j:=i+n;
        FOR l:=1 TO t DO  BEGIN
          j1:=j;
          FOR k:=1 TO t DO  BEGIN
            i:=i+1;
            j:=j+1;
            matr[j]:=matr[j]-matr[i]*matr[j1];
          END;
          i:=i-t;
          j:=j+s;
        END;
        i:=i+n+1;
        j:=i;
        determ:=determ*matr[i];
      END;
      M1:Det:=determ;
    END;

(*====================================================================*)

  PROCEDURE INV(n:word; VAR A,B:ARRAY OF DOUBLE; VAR dt:DOUBLE;
                       VAR InvA:ARRAY OF DOUBLE; VAR res:BOOLEAN);

    LABEL MARK;

    VAR    i1,j1,i,j,k,l,m,s: word;

    BEGIN
      i:=LOW(B);
      j:=LOW(A);
      s:=0;
      res:=TRUE;

      FOR m:=1 TO N DO  begin
        FOR k:=1 TO N DO begin
          B[i]:=A[j];
          B[i+n]:=0.0;
          i:=i+1;
          j:=j+1;
        END;
        B[i+s]:=1.0;
        s:=s+1;
        i:=i+n;
      END;

      i:=LOW(B);
      s:=1;
      dt:=1.0;
      (*прямой ход*)
      FOR l:=1 TO n DO  begin
        IF B[i]=0.0 THEN begin
          res:=FALSE;
          GOTO MARK;
        end
        ELSE begin
          dt:=dt*B[i];
          j:=i;
          FOR k:=1 TO n DO begin
            j:=j+1;
            B[j]:=B[j]/B[i];
          END;
          j:=i+2*n;
          IF n>s THEN  begin
            FOR m:=1 TO n-s DO begin
              j1:=j;
              FOR k:=1 TO n DO begin
                j:=j+1;
                i:=i+1;
                B[j]:=B[j]-B[i]*B[j1];
              END;
              i:=i-n;
              j:=j+n;
            END;
          END;
          s:=s+1;
          i:=i+2*n+1;
        END;
      END;
      (*обратный ход*)
      s:=0;
      j:=LOW(B)+2*N*N-1{HIGH(B)}-n;
      FOR l:=1 TO n-1 DO begin
        i:=j-2*n;
        i1:=i-s;
        FOR m:=1 TO n-s-1 DO begin
          FOR k:=1 TO n DO begin
            i:=i+1;
            j:=j+1;
            B[i]:=B[i]-B[j]*B[i1];
          END;
          j:=j-n;
          IF m<>n-s-1 THEN begin
            i1:=i1-2*n;
            i:=i1+s
          END;
        END;
        j:=j-2*n;
        s:=s+1;
      END;
      i:=LOW(INVA);
      j:=n+LOW(B);
      FOR l:=1 TO n DO begin
        FOR k:=1 TO n DO begin
          InvA[i]:=B[j];
          i:=i+1;
          j:=j+1;
        END;
        j:=j+n;
      END;
      MARK:
    END;

(*====================================================================*)

  PROCEDURE INVH(n:INTEGER;VAR InvOld,A,E,Buf:ARRAY OF DOUBLE;
                 VAR InvNew:ARRAY OF DOUBLE);

    VAR i:INTEGER;

  BEGIN
    FOR i:=LOW(A) TO LOW(A)+(n-1) DO BEGIN
      IF (i-LOW(A)) MOD (n+1)=0 THEN
        E[i]:=2.0
      ELSE BEGIN
        E[i]:=0.0
      END;
    END;
    MUL(n,A,InvOld,Buf);
    NEG(Buf);
    SUMMA(E,Buf,Buf);
    MUL(n,InvOld,Buf,InvNew);
  END;

(*====================================================================*)

 Function Invert(A: Array of Double; var InvA:Array OF Double):Boolean;
 var
    B  :Array of Double;
    dt :Double;
    res:Boolean;
    N  :Word;
    Na :Double;
 begin
    Result := False;
    Na := sqrt(Length(A));       // вычислить порядок матрицы

    If Frac(Na) <> 0 then
      exit
        else
          N := Trunc(Na);

    dt := Det(N, A);              // детерменант

    If dt = 0 then
      exit;

    SetLength(B, Length(A) * 2);  // буфферная матрица для метода Гаусса
//    SetLength(InvA, Length(A));


    INV(N, A,B, dt, InvA, res);
    Result := Res;
 end;

 Function InvNew(A: Array of Double; var InvA:Array OF Double):Boolean;

   procedure GetMinors(N: Word; var M :Array of Double);
   var
      tmp :Array of Double; /// Матрица для поиска миноров
      i, j, k, l, Mi, Mj, Ml : Integer;
   begin
      // Вычисление элементов матрицы миноров

      SetLength(tmp, sqr(N-1));

      k := 0;
      For K := 0 To Length(A)-1 Do
      Begin
        // Строка и столбец текущего минора
        Mi := Trunc(k/N);
        Mj := K - Mi*N;

        Ml :=0;
        /// Заполняю временную матрицу
        For L := 0 To Length(A)-1 Do
        Begin
          I := Trunc(L/N);
          j := L - I*N;
          if (I <> Mi) and (J <> Mj) then
          begin
            tmp[Ml] := A[L];
            Inc(Ml);
          end;
         End;

         M[K] := Det(N - 1, tmp); /// определитель временной матрицы

         if (MI+Mj) mod 2 <> 0 then /// Нужно ли менять знак
            M[K] := -M[K];

      End;
   end;

 var
    M   :Array of Double; /// Матрица миноров
    MT  :Array of Double; /// Матрица алебраических дополнений

    dt  :Double;
    res :Boolean;
    N   :Word;
    Na  :Double;
    I   : Integer;
 begin
    Result := False;

    If Length(InvA) <> Length(A) then
      exit;

    Na := sqrt(Length(A));       // вычислить порядок матрицы
    If Frac(Na) <> 0 then
      exit
        else
          N := Trunc(Na);

    dt := Det(N, A);              // детерменант

    If dt = 0 then
      exit;

    // Вычисление элементов матрицы миноров
    SetLength(M,   Length(A));
    GetMinors(N, M);

    SetLength(MT,   Length(A));
    TRANSP(N, N, M, MT);

    For I := 0 To Length(A)-1 Do
      InvA[I] := MT[I];

    Scalar(1/dt, InvA);

 end;

(*====================================================================*)

  PROCEDURE PINV(n,m:INTEGER;VAR A,AT,B,BB,I:ARRAY OF DOUBLE;
                 VAR PInvA:ARRAY OF DOUBLE;VAR res:BOOLEAN);
  VAR d:DOUBLE;
  BEGIN
    TRANSP(n,m,A,AT);
    MUL(n,AT,A,B);
    INV(m,B,BB,d,I,res);
    IF res THEN MUL(m,I,AT,PInvA);
  END;

(*===============================================================*)

PROCEDURE Low_ ( n:INTEGER;
                Const A: ARRAY OF  DOUBLE;
                Norm:BOOLEAN;
            VAR T: ARRAY OF  DOUBLE;
            VAR res:        BOOLEAN);
LABEL MARK;

VAR
   i,j,k,m,jn : INTEGER;
   S,D        :  DOUBLE;

BEGIN
   res:=TRUE;
  (*определение ненулевых элементов нижней треугольной матрицы*)
  FOR i:=1 TO n DO BEGIN(*цикл по строкам*)
    S:=0.0;
    m:=(i-1)*n;
    FOR k:=1 TO i-1 DO BEGIN
      S:=S+T[m+k-1+LOW(T)]*T[m+k-1+LOW(T)];(*диагональные элементы*)
    END;(* for k *)
    IF A[m+i-1+LOW(A)]>=S THEN
      T[m+i-1+LOW(T)]:=Sqrt(A[m+i-1+LOW(A)]-S)
     ELSE
     BEGIN
      res:=FALSE; GOTO MARK;
     END;
    FOR j:=i+1 TO n DO BEGIN(*цикл по столбцам*)
      S:=0.0;
      jn:=(j-1)*n;
      FOR k:=1 TO i-1 DO BEGIN
        S:=S+T[jn+k-1+LOW(T)]*T[m+k-1+LOW(T)];
      END;(* for k *)
      IF T[m+i-1+LOW(T)]<DivMinS THEN BEGIN
          (*res:=FALSE; GOTO MARK;*)
        T[m+i-1+LOW(T)]:=DivMinS;
        T[jn+i-1+LOW(T)]:=(A[jn+i-1]-S+LOW(A))/T[m+i-1+LOW(T)];
      END
      ELSE
        T[jn+i-1+LOW(T)]:=(A[jn+i-1+LOW(A)]-S)/T[m+i-1+LOW(T)];
    END;(* for j *)
  END;(* for i*)
  FOR i:=1 TO n DO BEGIN
    D:=T[(i-1)*n+(i-1)+LOW(T)];
    FOR j:=1 TO n DO BEGIN
      IF i>j THEN T[(j-1)*n+i-1+LOW(T)]:=0.0
      ELSE BEGIN
        IF D=0 THEN BEGIN
          res:=FALSE;
          GOTO MARK;
        END;
      IF Norm THEN T[(j-1)*n+i-1+LOW(T)]:=T[(j-1)*n+i-1+LOW(T)]/D;
      END;
    END;
  END;
  MARK:
END;

(*===============================================================*)

PROCEDURE High_ ( n:INTEGER;
                Const A: ARRAY OF DOUBLE;
                Norm:BOOLEAN;
            VAR T: ARRAY OF DOUBLE;
            VAR res:        BOOLEAN);

LABEL MARK;

VAR
   i,j,k,m,jn : INTEGER;
  I1,J1,K1    : INTEGER;
   S,D        : DOUBLE;



BEGIN
   res:=TRUE;
  (*определение ненулевых элементов верхней треугольной матрицы *)
  (*FOR i:=n TO 1 BY -1 DO BEGIN  *)
  i:=n;
  FOR I1:=1 TO N DO BEGIN
    S:=0.0;
    m:=(i-1)*n;
    (*FOR k:=n TO i+1 BY -1 DO BEGIN *)
    k:=n;
    FOR K1:=I+1 TO N DO BEGIN
      S:=S+T[m+k-1+Low(T)]*T[m+k-1+Low(T)]; (*диагональные элементы*)
      k:=k-1;
    END;(* for k *)
    IF A[m+i-1+Low(A)]>=S THEN BEGIN
       T[m+i-1+Low(T)]:=Sqrt(A[m+i-1+Low(A)]-S);
    END
    ELSE BEGIN
      res:=FALSE;
      GOTO MARK;
    END;
    (*FOR j:=i-1 TO 1 BY -1 DO BEGIN*)
    j:=i-1;
    FOR J1:=1 TO I-1 DO BEGIN
      S:=0.0;
      jn:=(j-1)*n;
      (*FOR k:=n TO i+1 BY -1 DO BEGIN*)
      k:=n;
      FOR K1:=I+1 TO N DO BEGIN
        S:=S+T[jn+k-1+Low(T)]*T[m+k-1+Low(T)];
      k:=k-1;
      END;(* for k *)
      IF T[m+i-1+Low(T)]<DivMinS THEN BEGIN
        (*res:=FALSE; GOTO MARK;*)
        T[m+i-1+Low(T)]:=DivMinS;
        T[jn+i-1+Low(T)]:=(A[jn+i-1+Low(A)]-S)/T[m+i-1+Low(T)];
      END
      ELSE BEGIN
        T[jn+i-1+Low(T)]:=(A[jn+i-1+Low(A)]-S)/T[m+i-1+Low(T)];
      END;(* if *)
    j:=j-1;
    END;(* for j *)
  i:=i-1;
  END; (* for i*)
  FOR i:=1 TO n DO BEGIN
    D:=T[(i-1)*n+(i-1)+Low(T)];
    FOR j:=1 TO n DO BEGIN
      IF i<j THEN BEGIN
        T[(j-1)*n+i-1+Low(T)]:=0.0;
      END
      ELSE BEGIN
        IF D=0 THEN BEGIN
           res:=FALSE;
           GOTO MARK;
        END;
        IF Norm THEN T[(j-1)*n+i-1+Low(T)]:=T[(j-1)*n+i-1+Low(T)]/D;
      END;
    END;
  END;
  MARK:
END;

(*===============================================================*)
PROCEDURE InvSymMatr ( n:INTEGER;
           Const A: ARRAY OF DOUBLE;
            VAR B: ARRAY OF DOUBLE;
            VAR T: ARRAY OF DOUBLE;
            VAR res:        BOOLEAN);
(*обращение симметричной матрицы n*n *)
(*с использованием разложения на две треугольные матрицы*)

LABEL MARK;

VAR
   i,j,k,m,jn : WORD;
   S          : DOUBLE;
BEGIN
   res:=TRUE;
  (*определение ненулевых элементов нижней треугольной матрицы*)
  FOR i:=1 TO n DO BEGIN
    S:=0.0;
    m:=(i-1)*n;
    FOR k:=1 TO i-1 DO BEGIN
      S:=S+T[m+k-1+LOW(T)]*T[m+k-1+LOW(T)];(*диагональные элементы*)
    END;(* for k *)
    IF A[m+i-1+LOW(A)]>=S THEN BEGIN
      T[m+i-1+LOW(T)]:=Sqrt(A[m+i-1+LOW(A)]-S);
    END
    ELSE BEGIN
      res:=FALSE;
      GOTO MARK;
    END;
    FOR j:=i+1 TO n DO BEGIN
      S:=0.0;
      jn:=(j-1)*n;
      FOR k:=1 TO i-1 DO BEGIN
        S:=S+T[jn+k-1+LOW(T)]*T[m+k-1+LOW(T)];
      END;(* for k *)
      IF T[m+i-1+LOW(T)]=0.0 THEN BEGIN
        res:=FALSE;
        GOTO MARK;
      END
      ELSE BEGIN
        T[jn+i-1+LOW(T)]:=(A[jn+i-1+LOW(A)]-S)/T[m+i-1+LOW(T)];
      END;(* if *)
    END;(* for j *)
  END;(* for i )
  (*определение элементов обратной нижней треугольной матрицы*)
  FOR i:=1 TO n DO BEGIN
    m:=(i-1)*n;
    IF T[m+i-1+LOW(T)]=0.0 THEN BEGIN
      res:=FALSE;
      GOTO MARK;
    END
    ELSE BEGIN
      T[m+i-1+LOW(T)]:=1.0/T[m+i-1+LOW(T)];(*диагональные элементы*)
    END;(*if*)
    FOR j:=i+1 TO n DO BEGIN
      T[m+j-1+LOW(T)]:=0.0;     (*нулевые элементы*)
    END;(* for j *)
    FOR j:=1 TO i-1 DO BEGIN
      S:=0.0;
      FOR k:=j TO i-1 DO BEGIN
        S:=S+T[m+k-1+LOW(T)]*T[(k-1)*n+j-1+LOW(T)];
      END;(* for k *)
      T[m+j-1+LOW(T)]:=-T[m+i-1+LOW(T)]*S;
    END;(* for j *)
  END;(* for i*)
  (*умножение обратной транспонированной треугольной матрицы*)
  FOR i:=1 TO n DO BEGIN(*на обратную нижнюю треугольную матрицу *)
    m:=(i-1)*n;
    FOR j:=i TO n DO BEGIN(*формирование верхней половины матрицы*)
      S:=0.0;
      FOR k:=j TO n DO BEGIN
        jn:=(k-1)*n;
        S:=S+T[jn+i-1+LOW(T)]*T[jn+j-1+LOW(T)];
      END;(* for k *)
      B[m+j-1]:=S;
    END;(* for j *)
  END;(* for i *)
  FOR i:=2 TO n DO BEGIN(*дополнение произведения *)
    m:=(i-1)*n; (*нижней симметричной частью*)
    FOR j:=1 TO (i-1) DO BEGIN
      B[m+j-1+LOW(B)]:=B[(j-1)*n+i-1+LOW(B)];
    END;(* for j *)
  END;(* for i *)
  MARK:
END;
(*===============================================================*)

PROCEDURE InvBigSymMatr ( n:INTEGER;
           Const A: ARRAY OF LinePtr;
             VAR B: ARRAY OF LinePtr;
             VAR T: ARRAY OF LinePtr;
            VAR res:        BOOLEAN);

(*обращение симметричной матрицы n*n *)
(*с использованием разложения на две треугольные матрицы*)

LABEL MARK;

VAR
   i,j,k,m,jn : WORD;
   S          : DOUBLE;
BEGIN
   res:=TRUE;
  (*определение ненулевых элементов нижней треугольной матрицы*)
  FOR i:=1 TO n DO BEGIN
    S:=0.0;
    m:=(i-1);
    FOR k:=1 TO i-1 DO BEGIN
      S:=S+T[m]^[k-1]*T[m]^[k-1];(*диагональные элементы*)
    END;(* for k *)
    IF A[m]^[i-1]>=S THEN BEGIN
      T[m]^[i-1]:=Sqrt(A[m]^[i-1]-S);
    END
    ELSE BEGIN
      res:=FALSE;
      GOTO MARK;
    END;
    FOR j:=i+1 TO n DO BEGIN
      S:=0.0;
      jn:=(j-1);
      FOR k:=1 TO i-1 DO BEGIN
        S:=S+T[jn]^[k-1]*T[m]^[k-1];
      END;(* for k *)
      IF T[m]^[i-1]=0.0 THEN BEGIN
        res:=FALSE;
        GOTO MARK;
      END
      ELSE BEGIN
        T[jn]^[i-1]:=(A[jn]^[i-1]-S)/T[m]^[i-1];
      END;(* if *)
    END;(* for j *)
  END;(* for i )
  (*определение элементов обратной нижней треугольной матрицы*)
  FOR i:=1 TO n DO BEGIN
    m:=(i-1);
    IF T[m]^[i-1]=0.0 THEN BEGIN
      res:=FALSE;
      GOTO MARK;
    END
    ELSE BEGIN
      T[m]^[i-1]:=1.0/T[m]^[i-1];(*диагональные элементы*)
    END;(*if*)
    FOR j:=i+1 TO n DO BEGIN
      T[m]^[j-1]:=0.0;     (*нулевые элементы*)
    END;(* for j *)
    FOR j:=1 TO i-1 DO BEGIN
      S:=0.0;
      FOR k:=j TO i-1 DO BEGIN
        S:=S+T[m]^[k-1]*T[(k-1)]^[j-1];
      END;(* for k *)
      T[m]^[j-1]:=-T[m]^[i-1]*S;
    END;(* for j *)
  END;(* for i*)

  (*умножение обратной транспонированной треугольной матрицы*)
  FOR i:=1 TO n DO BEGIN(*на обратную нижнюю треугольную матрицу *)
    m:=(i-1);
    FOR j:=i TO n DO BEGIN(*формирование верхней половины матрицы*)
      S:=0.0;
      FOR k:=j TO n DO BEGIN
        jn:=(k-1);
        S:=S+T[jn]^[i-1]*T[jn]^[j-1];
      END;(* for k *)
      B[m]^[j-1]:=S;
    END;(* for j *)
  END;(* for i *)
  FOR i:=2 TO n DO BEGIN(*дополнение произведени *)
    m:=(i-1); (*нижней симметричной частью*)
    FOR j:=1 TO (i-1) DO BEGIN
      B[m]^[j-1]:=B[j-1]^[i-1];
    END;(* for j *)
  END;(* for i *)
  MARK:
END;
(*===============================================================*)

PROCEDURE SymMatrix(N:INTEGER; VAR M:ARRAY OF DOUBLE);

VAR i,j:WORD;
      S:DOUBLE;

BEGIN
   FOR i:=0 TO N-1 DO BEGIN
     FOR j:=i TO N-1 DO BEGIN
       S:=(M[i*N+j+LOW(M)]+M[j*N+i+LOW(M)])/2.0;
       M[i*N+j+low(m)]:=S;
       M[j*N+i+low(m)]:=S;
     END;
   END;
END;

(*===============================================================*)

PROCEDURE INV_(n:INTEGER; Const A:ARRAY OF  DOUBLE;
                          VAR B,InvA:ARRAY OF DOUBLE);
LABEL MARK;

VAR i1,j1,i,j,k,l,m,s,ij,imax : INTEGER;
    MAX,R: DOUBLE;

BEGIN
  i:=LOW(B);
  j:=LOW(A);
  s:=0;
  FOR m:=1 TO n DO BEGIN
    FOR k:=1 TO n DO BEGIN
      B[i]:=A[j];
      B[i+n]:=0.0;
      INC(i);
      INC(j);
    END;
    B[i+s]:=1.0;
    INC(s);
    INC(i,n);
  END;

  i:=LOW(B);(*индекс элемента для матрицы А 0..(n-1)n
            для матрицы В 0..(n-1)*n*2*)
  s:=1; (*номер столбца 1..n*)
  (*ij-индекс диагонального элемента первой половины
                                    матрицы B 0..s(n+1)*)
  (*прямой ход*)
  FOR l:=1 TO n DO BEGIN(*цикл по столбцам*)
    IF n>s THEN BEGIN
      MAX:=B[i];
      ij:=i;
      imax:=i;
      FOR k:=s TO n-1 DO BEGIN
        INC(i,2*n);
        R:=B[i];
        IF ABS(R)>ABS(MAX) THEN BEGIN
          MAX:=R;
          imax:=i;
        END;{IF}
      END;{for k}
      IF MAX= 0.0 THEN BEGIN
        B[i]:=DivMinZ;
      END;
      i:=ij;
      IF imax<>ij  THEN BEGIN
        FOR k:=l TO 2*n DO BEGIN
          R:=B[ij];
          B[ij]:=B[imax];
          B[imax]:=R;
          INC(ij);
          INC(imax);
        END;{for k}
      END;{ifimax<>ij}
    END;{if n>s}
    j:=i;
    FOR k:=1 TO 2*n-s DO BEGIN
      INC(j);
      IF B[I]=0 THEN BEGIN
         GOTO MARK;
      END;
      B[j]:=B[j]/B[i];
    END;
    j:=i+2*n;
    IF n>s THEN  BEGIN
      FOR m:=1 TO n-s DO BEGIN
        j1:=j;
        FOR k:=1 TO 2*n-s DO BEGIN
          INC(j);
          INC(i);
          B[j]:=B[j]-B[i]*B[j1];
        END;{for k}
        DEC(i,2*n-s);
        INC(j,s);
      END;{for m}
    END;{ifn>s}
    INC(s);
    INC(i,2*n+1);
  END;{конец цикла по столбцам}
  (*обратный ход*)
  s:=0;
  j:=LOW(B)+2*N*N-1{HIGH(B)}-n;
  FOR l:=1 TO n-1 DO BEGIN
    i:=j-2*n;
    i1:=i-s;
    FOR m:=1 TO n-s-1 DO BEGIN
      FOR k:=1 TO n DO BEGIN
        INC(i);
        INC(j);
        B[i]:=B[i]-B[j]*B[i1];
      END;{for k}
      DEC(j,n);
      IF m<>n-s-1 THEN BEGIN
        i1:=i1-2*n;
        i:=i1+s;
      END;
    END;{for m}
    DEC(j,2*n);
    INC(s);
  END;{for l}
  i:=LOW(INVA);
  j:=n+low(B);
  FOR l:=1 TO n DO BEGIN
    FOR k:=1 TO n DO BEGIN
      InvA[i]:=B[j];
      INC(i);
      INC(j);
    END;
    INC(j,n);
MARK:END;
END;

Function Regress3(Num:integer;
                   Var M:array of double;
                   Var Cfs:array of double;
                   Var Kp,Kv,Ka,Kj:double;
                   Dia:double):boolean;
Type M4x4=Array[0..15]of double;

Var i,i0,J,K:integer;
    Dis,Dt:double;
    D:array[0..3]of double;
    H4,InvH4:M4x4;
    res:boolean;
    B:array[0..31]of double;
begin
  Result:=true;
  Dis:=Dia/(Num-1);
  i0:=Low(M);
  For i:=0 to 3 do D[i]:=0;
  For i:=0 To Num-1 Do begin
    D[0]:=D[0] +                 1*M[i0+i];
    D[1]:=D[1] +             Dis*i*M[i0+i];
    D[2]:=D[2] +       Dis*i*Dis*i*M[i0+i];
    D[3]:=D[3] + Dis*i*Dis*i*Dis*i*M[i0+i];
  end;
  FOR I:=0 TO 3 DO
  FOR J:=0 TO 3 DO BEGIN
    H4[I*4+J]:=0;
    for K:=0 TO NUM-1 do
      H4[I*4+J]:=H4[I*4+J]+POW(DIS*K,I+J)
  end;
  Inv(4,H4,B,dt,InvH4,res);
  If res Then begin
    Kp:=Sqrt(InvH4[0]);
    Kv:=Sqrt(InvH4[5]);
    Ka:=2*Sqrt(InvH4[10]);
    Kj:=6*Sqrt(InvH4[15]);
    Mul(4,InvH4,D,Cfs);
    end
  else Result:=false;
end;

function  Regress2(Num:integer;
                   Var M:array of double;
                   Var Cfs:array of double;
                   Var Kp,Kv,Ka:double;
                   Dia:double):boolean;
Type M3x3=Array[0..8]of double;

Var i,i0,J,K:integer;
    Dis,Dt:double;
    D:array[0..2]of double;
    H3,InvH3:M3x3;
    res:boolean;
    B:array[0..17]of double;
begin
  Result:=true;
  Dis:=Dia/(Num-1);
  i0:=Low(M);
  For i:=0 to 2 do D[i]:=0;
  For i:=0 To Num-1 Do begin
    D[0]:=D[0] +           1*M[i0+i];
    D[1]:=D[1] +       Dis*i*M[i0+i];
    D[2]:=D[2] + Dis*i*Dis*i*M[i0+i];
  end;
  FOR I:=0 TO 2 DO
  FOR J:=0 TO 2 DO BEGIN
    H3[I*3+J]:=0;
    for K:=0 TO NUM-1 do
      H3[I*3+J]:=H3[I*3+J]+POW(DIS*K,I+J)
  end;
  Inv(3,H3,B,dt,InvH3,res);
  if res then begin
    Kp:=Sqrt(InvH3[0]);
    Kv:=Sqrt(InvH3[4]);
    Ka:=2*Sqrt(InvH3[8]);
    Mul(3,InvH3,D,Cfs);
    end
  else Result:=false;
end;


Function  Regress1(Num:integer;
                   Var M:array of double;
                   Var Cfs:array of double;
                   Var Kp,Kv:double;
                   Dia:double):boolean;
Type M2x2=Array[0..3]of double;

Var i,I0,J,K:integer;
    Dis,Dt:double;
    D:array[0..1]of double;
    H2,InvH2:M2x2;
    res:boolean;
    B:array[0..7]of double;
begin
  Result:=true;
  Dis:=Dia/(NUM-1);
  I0:=LOW(M);
  For i:=0 to 1 do D[i]:=0;
  For i:=0 To Num-1 Do begin
    D[0]:=D[0] +           1*M[i0+i];
    D[1]:=D[1] +       Dis*i*M[i0+i];
  end;
  FOR I:=0 TO 1 DO
  FOR J:=0 TO 1 DO BEGIN
    H2[I*2+J]:=0;
    for K:=0 TO NUM-1 do
      H2[I*2+J]:=H2[I*2+J]+POW(DIS*K,I+J)
  end;
  Inv(2,H2,B,dt,InvH2,res);
  If Res then begin
    Kp:=Sqrt(InvH2[0]);
    Kv:=Sqrt(InvH2[3]);
    Mul(2,InvH2,D,Cfs);
    end
  else Result:=false;
end;

(*====================================================================*)

END.

