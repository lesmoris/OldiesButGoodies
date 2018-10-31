Program Stars;
Uses
  Crt,Xlib2,Palette;
Type
  Star = Record
           X,Y,Plano,Color : Integer;
         End;
Const
  Colores       : Array [1..5] of Byte = (32,63,95,127,145);
  cantPlanos    : Byte = 4;
  cantEstrellas = 50;
  StarsSpeedX   : Integer = 1;
  StarsSpeedY   : Integer = 1;
  TmpSiz        : Integer = 1;
  maxSpeedPos   : Integer = 5;
  maxSpeedNeg   : Integer = -10;
Var
  arrStar : Array [1..cantEstrellas] of Star;
  C,I,J : Integer;
  ky : char;

Procedure PutPix (X,Y,Size,Color : Integer);
Begin
  Case Size of
    1 : XPutPix (X,Y,0,Color);
    2..3 : begin
          XPutPix (X  ,Y  ,0,Color);
          XPutPix (X  ,Y+1,0,Color);
          XPutPix (X+1,Y  ,0,Color);
          XPutPix (X+1,Y+1,0,Color);
        end;
    4..5 : begin
          XPutPix (X  ,Y+1,0,Color);
          XPutPix (X+1,Y  ,0,Color);
          XPutPix (X+1,Y+1,0,Color);
          XPutPix (X+1,Y+2,0,Color);
          XPutPix (X+2,Y+1,0,Color);
        end;
  End;
End;

Begin
  XSetMode (0,360);
  PaletteInit;
  Randomize;
  For I := 1 to cantEstrellas do begin
     C := 223;
{    C := Colores[ Random( 5 ) + 1 ]; }
    With arrStar[I] do begin
      X := Random( 318 )+1;;
      Y := Random( 198 )+1;
      Plano := Random( cantPlanos )+1;
      Color := C;
      end;
    end;
  Repeat
    For J := 1 to cantEstrellas do Begin
      With arrStar[J] do begin
{        tmpsiz := Plano;}
        PutPix (X,Y,tmpsiz,0);
        If StarsSpeedX <> 0 then
          Inc (X,Plano + StarsSpeedX );
        If StarsSpeedY <> 0 then
          Inc (Y,Plano + StarsSpeedY );
        Delay (1);
        PutPix (X,Y,tmpsiz,color);
      end;
    End;
    For I := 1 to 99 do
      With arrStar[I] do begin
        If X > 319 then X := 0;
        If X < -20 then X := 319;
        If Y > 199 then Y := 0;
        If Y < -20 then Y := 199;
      end;
    If Keypressed then begin
      ky := Readkey;
      ky := UpCase (Ky);
      Case Ky of
        #83 : Dec (StarsSpeedY,1); {(Flecha Arriba)}
        #90 : Dec (StarsSpeedX,1); {(Flecha Izquierda)}
        #88 : Inc (StarsSpeedY,1); {(Flecha Abajo) }
        #67 : Inc (StarsSpeedX,1); {(Flecha Derecha)}
        '1' : StarsSpeedY := 0;
        '2' : StarsSpeedX := 0;

      End;

      If StarsSpeedX > maxSpeedPos+1 then
        StarsSpeedX := maxSpeedPos
      Else If StarsSpeedX < maxSpeedNeg then
        StarsSpeedX := maxSpeedNeg;

      If StarsSpeedY > maxSpeedPos+1 then
        StarsSpeedY := maxSpeedPos
      Else If StarsSpeedY < maxSpeedNeg then
        StarsSpeedY := maxSpeedNeg;

      While KeyPressed do
        Readkey;
    End;

  Until Ky = #27;
  XTextMode;
End.