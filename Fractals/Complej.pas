{$N+}
Program Fractales_nComplejos;
Uses
  Crt,Graph,Mouse,SVGA;
Const
  res  = 3;
  pot  : Integer = 2;
  iter : Integer = 50;
Type
  ImagType =  record {la mejor forma de representar un n§ complejo a + bi}
                r : single;
                i : single;
              end;

Var
  c          : ImagType; {numeros imaginarios usados en el prog}

  ky         : Char;

  maxspeed,
  speed      : integer;  {velocidad de escape del punto}

  complej,               {complejidad del fractal}
  b,mX,mY    : integer;  {las coordenadas del mouse}

  aux        : single;

Procedure FractalJulia ( var z : imagType; zoom : Word );
Var
  a,b,i,j,l,
  speed : word;
  t,c   : imagType;
Begin
  c.r := -2.0000;
  For a := 1 to GetMaxX do begin
    c.i := -2.0000;
    For b := 1 to GetMaxY do begin
      t.r := c.r; t.i := c.i;
      i := 0;
      repeat
        For l := 1 to pot - 1 do begin
          aux := t.r;
          t.r := sqr ( t.r ) - sqr ( t.i );
          t.i := 2 * aux * t.i;
        end;
        t.r := t.r + z.r;
        t.i := t.i + z.i;
        inc ( i );
      until ( i = 100 ) or ( t.r*t.r + t.i*t.i > 4 );
      PutPixel (a,b,32 + i);
      c.i := c.i + 0.0065;
    end;
    c.r := c.r + 0.0050;
  end;
End;

Procedure FractalMandelbrot ( c : ImagType ; zoom : longint);
Var
  k,i,j,l : word;
  a,b,
  divi,
  zaux,
  incz    : single;
  mult,
  x,y     : longint;
  t       : imagtype;
Begin
  mult :=  100 * zoom;
  incz := 0.01 / zoom;

  zaux  := c.i;
  For i := 1 to GetMaxX do begin
    c.i := zaux;
    For j := 1 to GetMaxY do begin
      t.r := c.r; t.i := c.i;
      k := 0;
      a := t.r; b := t.i;
      repeat
        aux := t.r;
        t.r := Sqr ( t.r ) - Sqr ( t.i ) + c.r;
        t.i := 2 * aux * t.i + c.i;

{
        aux := a;
        divi := 3 * ( ( a*a - 2*a*b + b*b ) + ( 2*a*b ) * ( 2*a*b ));
}
        Inc ( k );
      until ( k >= iter ) or ( (t.r * t.r) + (t.i * t.i) > 4 );
      speed := k;
      { if speed > maxspeed then maxspeed := speed; }
      If k < iter then PutPixel ( i,j,32 + speed);
      c.i := c.i + incz;
    end;
    c.r := c.r + incz
  end;
End;

Procedure GrabarImagen ( z : ImagType ; zoom : integer );
Var
  h   : File of integer;
  aux : integer;
Begin
  Assign ( h,'Image.frt' );
  Rewrite ( h );
  aux := Round ( 100 * zoom * z.r );
  Write ( h,aux );
  aux := Round ( 100 * zoom * z.i );
  Write ( h,aux );
  Write ( h,zoom );
  Close ( h );
  OutTextXY (1,1,'Imagen grabada en archivo Image.FRT');
  Readkey;
End;

Procedure LeerImagen;
Var
  h     : File of Integer;
  z1,z2,
  zoom,
  tipo  : integer;
  c     : imagtype;
Begin
  Assign ( h,'Image.FRT' );
  Reset ( h );
  Read ( h,z1 );
  Read ( h,z2 );
  Read ( h,zoom );
  Read ( h,tipo );
  c.r := z1/(100 * zoom);
  c.i := z2/(100 * zoom);
  If Tipo = 1 then FractalMandelbrot ( c,zoom )
              else FractalJulia ( c,zoom );
  ReadKey;
  CloseGraph;
  Close ( h );
End;

Procedure Wait;
Const
  KeySet = [#27,'S'];
Begin
  ky := #0;
  repeat GetMouseStatus ( b,mX,mY );
         if keypressed then ky := upcase ( readkey );
  until (b in [1..2]) or (ky in KeySet);
End;

Begin
  InitSVGA;
  ActivateMouse;
  c.r := -2.000;
  c.i := -1.500;
  complej := 2;
  maxspeed := 0;

  repeat

    ClearDevice;
    FractalMandelbrot ( c , complej );
    If complej = 2 then begin
      SetMousePosition (1,1);
      ShowMouse;
      Wait;
      SetMousePosition (1,1);
      HideMouse;

      If b = 1 then begin {Mandelbrot Zoom}
          c.r := ( (mX div 4 ) - 400 ) / 200;
          c.i := ( mY - 300 ) / 200;
          complej := 100;
          iter := 150;
        end
      else If b = 2 then begin {Julia}
          c.r := ( (mX div 4 ) - 400 ) / 200;
          c.i := ( mY - 300 ) / 200;
          FractalJulia ( c,complej );
          Wait;
          If ky = 'S' then GrabarImagen ( c,complej );
          c.r := -2.000;
          c.i := -1.500;
        end;

      end
    else
      begin
        Wait;
        If ky = 'S' then GrabarImagen ( c,complej );
        c.r := -2.000;
        c.i := -1.500;
        complej := 2;
        iter := 50;
      end;

  until ky = #27;
  DeactivateMouse;
  CloseGraph;
  WriteLn ('Programa de Fractales Mandelbrot y Julia creado por Leonardo Esmoris');
  WriteLn ('UTN F.R.B.A. Leg n§ 111794-4                    lesmoris@hotmail.com');
End.

{
          aux := t.r;
          t.r := Sqr ( t.r ) - Sqr ( t.i ) + c.r;
          t.i := 2 * aux * t.i + c.i;
}
{
          if t.r >= 0 then begin
            aux := t.r;
            t.r := ( ( t.r - 1 ) * c.r ) - ( t.i * c.i );
            t.i := ( ( aux - 1 ) * c.i ) + ( t.i * c.r );
            end;
          if t.r < 0 then begin
            aux := t.r;
            t.r := ( ( t.r + 1 ) * c.r ) - ( t.i * c.i );
            t.i := ( ( aux + 1 ) * c.i ) + ( t.i * c.r );
            end;
}
{
          aux := t.r;
          For l := 1 to 3 do begin
            t.r := ln ( Abs ( Sqr ( t.r ) - Sqr ( t.i )));
            t.i := ln ( Abs ( 2 * aux * t.i ));
          end;
          t.r := t.r + c.r;
          t.i := t.i + c.i;
}
