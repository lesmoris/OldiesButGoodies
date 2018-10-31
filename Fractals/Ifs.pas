{$N+}
Program IFS_FernFractal;
Uses
  Crt,SVGA,Graph;
Const
  Zoom = 50;
  iter = 150000;
Var
  a,b,c,
  d,e,f : Array [ 0..3 ] of Real;
  i,k : LongInt;
  x,y,xlast,ylast : Real;

begin
  InitSVGA;
  Randomize;

{Fern}
  a[0]:=0;
  a[1]:=0.2;
  a[2]:=-0.15;
  a[3]:=0.75;

  b[0]:=0;
  b[1]:=-0.26;
  b[2]:=0.28;
  b[3]:=0.04;

  c[0]:=0;
  c[1]:=0.23;
  c[2]:=0.26;
  c[3]:=-0.04;

  d[0]:=0.16;
  d[1]:=0.22;
  d[2]:=0.24;
  d[3]:=0.85;

  e[0]:=0;
  e[1]:=0;
  e[2]:=0;
  e[3]:=0;

  f[0]:=0;
  f[1]:=1.6;
  f[2]:=0.44;
  f[3]:=1.6;

  for i := 0 to iter do begin
    case random ( 100 ) of
       0..9  : k := 0;
      10..17 : k := 1;
      18..25 : k := 2;
    else
      k := 3;
    end;

    x := a[k] * xlast + b[k] * ylast + e[k];
    y := c[k] * xlast + d[k] * ylast + f[k];
    xlast := x;
    ylast := y;
    PutPixel ( 370 + Round ( x * Zoom ) , 550 - Round ( y * Zoom ), 50);

  end;
  SetColor (15);
  Rectangle (0,0,GetMaxX,GetMaxY);
  ReadKey;
  CloseGraph;
  WriteLn ('Programa de Fractales                               Leonardo Esmoris');
  WriteLn ('UTN F.R.B.A. Leg n§ 111794-4                    lesmoris@hotmail.com');

end.

