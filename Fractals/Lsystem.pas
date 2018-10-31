Program LSystem;
Uses Crt,Graph,SVGA;
Const
  res = 0;
Type
  punto = record
            x,y : Integer;
          end;
  setPuntos = array [1..5] of punto;
Var
  h : punto;
  Puntos : setPuntos;
  I : Integer;

Procedure PutPix ( VAR pto : punto; color : Byte );
Begin
  PutPixel ( pto.x , pto.y , color );
End;

Procedure CalcularPuntos ( VAR pto : setPuntos );
Begin
  pto[2].x := pto[1].x + ( pto[5].x - pto[1].x ) div 3;
  pto[2].y := pto[1].y + ( pto[5].y - pto[1].y ) div 3;

  pto[4].x := pto[1].x + (( pto[5].x - pto[1].x ) div 3 ) * 2;
  pto[4].y := pto[1].y + (( pto[5].y - pto[1].y ) div 3 ) * 2;

  pto[3].x := pto[1].x + ( pto[5].x - pto[1].x ) div 2;
  pto[3].y := pto[1].y + ( pto[5].y - pto[1].y ) div 2;
  h.x := pto[4].x - pto[3].x;
  h.y := pto[4].y - pto[3].y;
  pto[3].x := ( pto[3].x + h.y * 13 div 7);
  pto[3].y := ( pto[3].y - h.x * 13 div 7);
End;

Begin
  InitVGA;
  SetColor (15);

  Puntos[1].x := 200;
  Puntos[1].y := 150;
  Puntos[5].x := 400;
  Puntos[5].y := 150;

  PutPix ( Puntos[1],15 ); PutPix ( Puntos[5],15 );

  CalcularPuntos ( Puntos );

  Line ( Puntos[1].x,Puntos[1].y,Puntos[2].x,Puntos[2].y );
  Line ( Puntos[4].x,Puntos[4].y,Puntos[5].x,Puntos[5].y );
  PutPix ( Puntos[3],3 );
  SetColor (15);
  Line ( Puntos[2].x,Puntos[2].y,Puntos[3].x,Puntos[3].y );
  Line ( Puntos[3].x,Puntos[3].y,Puntos[4].x,Puntos[4].y );

  ReadKey;
End.