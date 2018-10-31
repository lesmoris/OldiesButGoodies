{$N+}
Program OrbitFractal;
Uses Crt,Graph,SVGA;
Const
  opciones = 6;
  res = 3;
Type
  aChoiceArray = Array [1..10] of String;
Const
  aMenu   : aChoiceArray = ('GingerBread Man','Hop Along','PopCorn','Quadrup Two','ThreePly','Salir','','','','');
Var
  iter,i  : Longint;
  zoom    : Single;
  aux,x,y : real;
  tipofractal : Byte;

Function aChoice ( VAR aNames : aChoiceArray; max : Integer ) : Integer;
Var
  I,Code : Integer;
  Ky : Char;
  sw : Boolean;
Begin
  WriteLn ('Seleccione:');
  For i := 1 to Max do
    WriteLn (I,'.- ', + aNames[i]);
  i := 1;
  Sw := False;
  Repeat
    GotoXY (1,1+i);
    TextBackGround (1);
    TextColor (15);
    Write ( i,'.- ', + aNames[ i ] );
    Ky := UpCase( Readkey );
    GotoXY (1,1+i);
    TextBackGround (0);
    TextColor (7);
    Write (i,'.- ', + aNames[i]);
    Case Ky of
      #72 : Dec ( i );
      #80 : Inc ( i );
      #13 : Sw := True;
      #27 : Sw := True;
    end;
    If i > Max then i := Max
    Else If i < 1 then i := 1;
  Until Sw = True;
  If ( Ky = #27 ) or ( i = Max ) then
    begin
      ClrScr;
      aChoice := max;
      Exit;
    end;
  aChoice := i;
  ClrScr;
  GotoXY (1,1);
End;

Function Sgn ( r : single ) : integer;
Begin
  if r < 0 then
    sgn := -1
  else
    sgn := 1;
End;

Procedure GingerBreadMan;
Begin
  iter := 500000;
  zoom := 50;
  x := -0.1000;
  y := 0.0000;
  For i := 1 to iter do begin
    aux := x;
    x := 1 - y + abs ( x );
    y := aux;
    PutPixel ( 300 + Round ( ( x * zoom ) ),180 + Round ( ( y * zoom ) ),15 );
  end;
End;

Procedure HopAlong;
Begin
  iter := 32000;
  zoom := 10;
  x := -2.625;
  y := 1.625;
  For i := 1 to iter do begin
    aux := x;
    x := y - sgn ( x ) * Abs ( 0.566 * x - 4.6 );
    y := 1.666 - aux;
    PutPixel ( 320 + Round ( ( x * zoom ) ),240 + Round ( ( y * zoom ) ),15 );
  end;
End;

Procedure PopCorn;
Begin
  iter := 150000;
  zoom := 50;
  x := -2.0000;
  y := -1.0000;
  For i := 1 to iter do begin
    aux := x;
    x := x - 0.05 * sin (   y + sin ( 3 * y )   / cos ( 3 * y )   );
    y := y - 0.05 * sin ( aux + sin ( 3 * aux ) / cos ( 3 * aux ) );
    PutPixel ( Round ( abs ( x * zoom ) ),Round ( ( y * zoom ) ),15 );
  end;
End;

Procedure QuadrupTwo;
Begin
  iter := 300000;
  zoom := 5;
  x := -0.1000;
  y := 0.0000;
  For i := 1 to iter do begin
    aux := x;
    x := y - sgn ( x ) * sin ( ln ( abs ( 1 * x - 5 ) )) * arctan ( sqr ( abs ( 5 * x - 1 ) ) );
    y := 34 - aux;
    PutPixel ( 300 + Round ( ( x * zoom ) ),200 + Round ( ( y * zoom ) ),15 );
  end;
End;

Procedure ThreePly;
Begin
  iter := 50000;
  zoom := 0.5;
  x := -0.1000;
  y := 0.0000;
  For i := 1 to iter do begin
    aux := x;
    x := y - sgn ( x ) * abs ( sin ( x ) * cos ( - 1 ) - 42 - x * sin ( - 68 ));
    y := - 55 - aux;
    PutPixel ( 300 + Round ( ( x * zoom ) ),150 + Round ( ( y * zoom ) ),15 );
  end;
End;

Procedure Kamtorus;
Var
  a : real;
Begin
  iter := 100000;
  zoom := 5;
  x := 0;
  y := 0;
  a := 0.1;
  For i := 1 to iter do begin
    aux := x;
    x :=   x * cos ( a ) + ( sqr ( x )   - y ) * sin ( a );
    y := aux * sin ( a ) - ( sqr ( aux ) - y ) * cos ( a );
    PutPixel ( 300 + Round ( ( x * zoom ) ),150 + Round ( ( y * zoom ) ),15 );
  end;
End;

Begin
  Repeat
    Clrscr;
    tipoFractal := aChoice ( aMenu , opciones );
    if tipoFractal in [ 1..Opciones - 1 ] then begin
      InitSVGA;
      SetColor ( 15 );
      Case tipoFractal of
        1 : GingerBreadMan;
        2 : HopAlong;
        3 : PopCorn;
        4 : QuadrupTwo;
        5 : ThreePly;
        6 : Kamtorus;
      end;
      Rectangle (0,0,GetMaxX,GetMaxY);
      Readkey;
      CloseGraph;
    end;
  Until tipoFractal = Opciones;
  WriteLn ('Programa de Fractales Mandelbrot y Julia creado por Leonardo Esmoris');
  WriteLn ('UTN F.R.B.A. Leg n§ 111794-4                    lesmoris@hotmail.com');
End.