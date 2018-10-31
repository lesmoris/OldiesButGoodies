{$N+}
Program Arbol;
Uses Crt,Graph,SVGA,DOS;
Const
  n   : Integer = 1;
  xx  : Integer = 0;
  yy  : Integer = 0;

  res = 3;

  color  : Byte = 35;  {Es obvio para que sirve esto...}

  speed  : Word = 1;  {La velocidad de dibujado del arbol}
  potmax : Byte = 12; {Maximo 12 o se va de rango (tengo que implementar memoria dinamica!) }
  ancho  : Byte = 10; {Es el ancho de cada "rama" }

  incang  : single = pi / 8; {Jug  con este valor para darle una forma diferente al arbol}
  anginit : single = { - 3 * } pi / { - } 2; {Dejalo en (pi / 2) para que el arbol empiese derechito para arriba}
  h       : single = 5;      {El tama¤o inicial de la hipotenusa del angulo}

  {El valor tiene que estar entre [0..1].Valores mas grandes andan
  pero pueden colgar el programa y no dejan ver el arbol ;-) }
  var_h  : single = 9/10;
Type
  ptos = Array [1..2] of Array [ 1..4095 ] of Record
                              x,y : word;
                              ang : single;
                            end;

Var
  Aux     : single;
  Puntos  : ^ptos;

  crec,
  ptr,
  ctr,
  vec,
  max,
  i,j : Integer;

Function Sqr_de_2 ( Pot : Integer ) : Longint;
Var
  Res : Longint;
  I : Word;
Begin
  Res := 2;
  For I := 1 to (Pot - 1) do begin
    Res := Res * 2;
    end;
  Sqr_de_2 := Res;
End;

Function IntToStr( I : Longint ): String;
Var
  S : string [ 5 ];
Begin
  Str(I, S);
  IntToStr := S;
End;

Begin
  InitSVGA;
  New ( Puntos );
  Vec := 1;
  Ctr := 2;
  SetColor ( Color );
  Puntos^[1][1].x   := 400;
  Puntos^[1][1].y   := 430;
  Puntos^[1][1].ang := { Round ( Anginit ); }  Anginit;
  xx := ( Round ( ( cos(Puntos^[1][1].ang) * ancho ) * h));
  yy := ( Round ( ( sin(Puntos^[1][1].ang) * ancho ) * h));
  Line  ( Puntos^[1][1].x , Puntos^[1][1].y , Puntos^[1][1].x+xx , Puntos^[1][1].y+yy );

  { En este for se indica la potencia maxima de 2 a la que se quiere llegar}
  Max := 1;
  For J := 0 to PotMax do begin
    If J <> 0 then
      Max := Sqr_de_2 (J);
    Ptr := 1;
    SetColor ( Color );
    Color := Color + 1;
    OutTextXY (1,J*10, IntToStr( Max ) );
    For I := 1 to Max do begin

      Aux := Puntos^[vec][I].ang;

      Puntos^[vec][I].ang   := Puntos^[vec][I].ang - incang; { Round ( incang ); }
      xx := ( Round ( ( cos(Puntos^[vec][I].ang) * ancho ) * h));
      yy := ( Round ( ( sin(Puntos^[vec][I].ang) * ancho ) * h));
      Puntos^[ctr][ptr].x   := Puntos^[vec][I].x - xx;
      Puntos^[ctr][ptr].y   := Puntos^[vec][I].y - yy;
      Puntos^[ctr][ptr].ang := Puntos^[vec][I].ang;
      Inc (ptr);
      Line  ( Puntos^[vec][I].x , Puntos^[vec][I].y , Puntos^[vec][I].x-xx , Puntos^[vec][I].y-yy );

      Puntos^[vec][I].ang :=  Aux { Round ( Aux )} ;

      Puntos^[vec][I].ang   := Puntos^[vec][I].ang + incang; { Round ( incang );}
      xx := ( Round ( ( cos(Puntos^[vec][I].ang) * ( - ancho ) ) * h) );
      yy := ( Round ( ( sin(Puntos^[vec][I].ang) * ancho ) * h) );
      Puntos^[ctr][ptr].x   := Puntos^[vec][I].x + xx;
      Puntos^[ctr][ptr].y   := Puntos^[vec][I].y - yy;
      Puntos^[ctr][ptr].ang := Puntos^[vec][I].ang;
      Inc (ptr);
      Line  ( Puntos^[vec][I].x , Puntos^[vec][I].y , Puntos^[vec][I].x+xx , Puntos^[vec][I].y-yy );

      end;
    writeln ( i );

    If speed = 0
      then Readkey
      else Delay ( Speed );
    h := h * var_h;

    If vec = 1
      then begin
        ctr := 1; vec := 2;
        end
      else begin
        ctr := 2; vec := 1;
        end;

  end;
  If speed <> 0 then
    ReadKey;

  CloseGraph;
  TextMode (CO80);
  WriteLn ('Programa de Fractales                               Leonardo Esmoris');
  WriteLn ('UTN F.R.B.A. Leg n§ 111794-4                    lesmoris@hotmail.com');
End.