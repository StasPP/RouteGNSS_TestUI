unit GeoMath;

//// ������ �. 2016    + ������� ���������

interface
  function Sign(x :double):Integer;       ///  ����
  function Pow(x, n :double):Double ;     ///  x^y

  function Vincenty(Lat1, Lon1, Lat2, Lon2: Double): Double;

  const Pi = 3.14159265358979;               ///  ����� ��
  const ro = 206264.8062471;                 ///  ����� ������� ������ � �������

implementation

uses Math;

function Vincenty(Lat1, Lon1, Lat2, Lon2: Double): Double;
{var sigma: double;
begin
  sigma := arccos( sin(lat1*pi/180)*sin(lat2*pi/180) +
                   cos(lat1*pi/180)*cos(lat2*pi/180)*cos((lon2-lon1)*pi/180));
  result := 6356830.0 *sigma;
end;}


//   �����: ��������
//   Copyright: ����������� � Survey Review �175 �� ������ 1976�.
//   http://delphisite.ru/faq/raschet-rasstoyaniya-mezhdu-2mya-tochkami-na-zemnoi-poverkhnosti-metodom-vinsenti

const // ��������� ����������:
 a = 6378137.0;                //6378245.0;
 f = 1/298.257223563;         //1 / 298.3;
 b = (1 - f) * a;
 EPS = 0.5E-30;

var
 APARAM, BPARAM, CPARAM, OMEGA, TanU1, TanU2,
 Lambda, LambdaPrev, SinL, CosL, USQR, U1, U2,
 SinU1, CosU1, SinU2, CosU2, SinSQSigma, CosSigma,
 TanSigma, Sigma, SinAlpha, Cos2SigmaM, DSigma : Extended;
begin
 lon1 := lon1 * (PI / 180);
 lat1 := lat1 * (PI / 180);
 lon2 := lon2 * (PI / 180);
 lat2 := lat2 * (PI / 180); // �������� �������� ��������� � �������
 TanU1 := (1 - f) * Tan(lat1);
 TanU2 := (1 - f) * Tan(lat2);
 U1 := ArcTan(TanU1);
 U2 := ArcTan(TanU2);
 SinCos(U1, SinU1, CosU1);
 SinCos(U2, SinU2, CosU2);
 OMEGA := lon2 - lon1;
 lambda := OMEGA;
 repeat //������ ����� ��������
   LambdaPrev:= lambda;
   SinCos(lambda, SinL, CosL);
   SinSQSigma := (CosU2 * SinL * CosU2 * SinL) +
     (CosU1 * SinU2 - SinU1 * CosU2 * CosL) *
     (CosU1 * SinU2 - SinU1 * CosU2 * CosL);
   CosSigma := SinU1 * SinU2 + CosU1 * CosU2 * CosL;
   TanSigma:= Sqrt(SinSQSigma) / CosSigma;
   if TanSigma > 0
     then Sigma := ArcTan(TanSigma)
        else Sigma := ArcTan(TanSigma) + Pi;
   if SinSQSigma = 0
     then SinAlpha := 0
        else SinAlpha := CosU1 * CosU2 * SinL / Sqrt(SinSQSigma);
   if (Cos(ArcSin(SinAlpha)) * Cos(ArcSin(SinAlpha))) = 0
      then Cos2SigmaM := 0
       else Cos2SigmaM:= CosSigma -
           (2 * SinU1 * SinU2 / (Cos(ArcSin(SinAlpha)) * Cos(ArcSin(SinAlpha))));
    CPARAM:= (f / 16) * Cos(ArcSin(SinAlpha)) * Cos(ArcSin(SinAlpha)) *
          (4 + f * (4 - 3 * Cos(ArcSin(SinAlpha)) * Cos(ArcSin(SinAlpha))));
    lambda := OMEGA + (1 - CPARAM) * f * SinAlpha * (ArcCos(CosSigma) +
          CPARAM * Sin(ArcCos(CosSigma)) * (Cos2SigmaM + CPARAM * CosSigma *
          (-1 + 2 * Cos2SigmaM * Cos2SigmaM)));
 until Abs(lambda - LambdaPrev) < EPS; // ����� ����� ��������

 USQR:= Cos(ArcSin(SinAlpha)) * Cos(ArcSin(SinAlpha)) *
                      (a * a - b * b) / (b * b);
 APARAM := 1 + (USQR / 16384) *
                  (4096 + USQR * (-768 + USQR * (320 - 175 * USQR)));
 BPARAM := (USQR / 1024) * (256 + USQR * (-128 + USQR * (74 - 47 * USQR)));
 DSigma := BPARAM * SQRT(SinSQSigma) * (Cos2SigmaM + BPARAM / 4 *
            (CosSigma * (-1 + 2 * Cos2SigmaM * Cos2SigmaM) - BPARAM / 6 * Cos2SigmaM *
            (-3 + 4 * SinSQSigma) * (-3 + 4 * Cos2SigmaM * Cos2SigmaM)));
 Result := b * APARAM * (Sigma - DSigma);
end;

function Sign (x : double):Integer;
begin
    if ( x >= 0 ) then Sign := 1 else Sign := -1;
end;

function Pow(x, n:double):Double ;
begin
  Pow := Power(x,n);//exp(n*ln(x));
end;


end.
