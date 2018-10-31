{
12/1/2001

Estructura del Ladrillo en Levels.dat

(EJEMPLO)--|
           |
  |--------|
  
-[ 11371 ]-

1§Digito : Especifica si el ladrillo esta 'vivo' o si ya lo han destruido
           Este valor solo cambia durante el desarrollo del juego y
           siempre debe valer uno al comienzo del mismo (si queres que este,
           obvio), si no el ladrillo no se dibujar .
           0 = Desactivado
           1 = Activado

2§Digito : Especifica si el ladrillo soltara una capsula al destruirse
           0 = Con capsula
           1 = Sin capsula

3§Digito : Especifica cuantas veces debera tocarse el ladrillo para
           romperse. Va desde 1 a 3. Si es 3, el ladrillo es
           indestructible.
           1 = Se rompe de una
           2 = Hay que pegarle 2 veces
           3 = Indestructible

4§Digito : Especifica el sprite a utilizar. En total va dese 1 al 8.
           Sin embargo el 8 esta reservado para el ladrillo indestructible.
           En el editor no se puede poner este ladrillo si es uno comun
           (rompible).
           Mas informacion sobre los tipos de ladrillosen la unidad
                                        ' PICS.PAS '
                                                |----------|
                                             |---|          |
           (Hac‚ CTRL+ENTER arriba del nombre para abrirla)-|
5§Digito : Es el tipo de capsula que contiene el ladrillo. Son 4.
           1 = Puntos
           2 = Da 1 Vida
           3 = Reduce la velocidad de la pelotita
           4 = Convierte la pelotita en TERMINATOR (probala)

Esta informacion no esta comprobada. Por favor comprobar. Aunque me parece
que esta bien.
(A pesar de que yo mismo dise¤‚ la estructura, ya no me la acuerdo!!!!!!)
(Que loco, no?)

13/1/2001

Este es el dia de gloria! Este programa lo empeze ayer y hoy ya lo termin‚!.
Fue facil pensando que la mayor parte del trabajo ya estaba hecha en el juego
mismo, y poseia nociones del editor anterior que habia hecho pero que no se
por que se me perdio. Lo que falta es mejorar el aspecto visual (muchisimo)
asi como tambien el aspecto de los comentarios en el codigo fuente.

Diviertanse modificando tanto este programa (haganlo mas lindo) asi como
tambien los 5 ultimos niveles faltantes del EsmoNOID 2 (terminenlos por favor.
Mi imaginacion ya se acab¢ cuando hice los primeros 5 niveles, aunque por lo
visto se acabo antes de empezar a hacerlos)

Agradecimientos : A mis viejos que se fueron de vacaciones y me dejaron solo
en la casa y asi me dieron tiempo de terminar esto sin tener que preocuparme
por tener que hacer esto o aquello.

Que lo disfruten. :-P
Enjoy :-)

}

Program LevelsEditor;
Uses
  Crt,
  Palette,
  Pics,
  Xlib2,
  XBm2;
Const
  Niv : Byte = 1;
  MaxLad = 10;
  Last_Level = 10;
  Txt : Byte = 0;
Type
  Nivel_Type = Array [1..Last_Level,1..MaxLad,1..15] of String[5];
Var
  Nivel         : Nivel_Type;
  strBrick      : String;
  BrickCounter  : Integer;
  Font_1,Font_2 : Pointer;   {Contienen la letras contenidas en el archivo E2_Font.Dat}
  strX,strY,tmp : String;
  X,Y,I,J       : Integer;
  Res,dummyKey  : Char;
  Sw            : Integer; {Indica si el nivel ha sido modificado }
  FileMissing   : String;

Procedure ExitGame (ExitCode : Byte);  {termina el juego dando el mensaje indicado por ExitCode}
Var
  I : Byte;
Begin
  If InGraphics = 1 then begin  {Detecta si esta en modo grafico}
    XTextMode;                    {Pone el modo texto}
  end;
  Case ExitCode of
    0 : Begin
        Writeln ('Gracias por jugar al Esmonoid 2 !!!!!!!');
        Writeln ('  ');
    {    ReadLn;}
        End;
    3 : Writeln ('Falta el archivo ',FileMissing);
  end;
  While Keypressed do Readkey;
  Halt;
End;

Procedure Initial_Count (Level : byte);
Var
  I,J : Integer;
Begin
  BrickCounter := 0;
  For I := 1 to MaxLad do
    For J := 1 to 15 do
      If (Nivel[Level,I,J] [1] = '1') then
        Inc(BrickCounter);
end;

Procedure Load_Levels; {Carga los niveles del disco rigido}
var
  F : file of integer;
  A,K,C : Integer;
  Alto,Largo : Byte;
begin
  Assign (F,'DATA\Levels.dat');

  Reset (F);
  Alto  := 1;
  Largo := 1;
  For K := 1 to 10 do
   For Alto := 1 to 10 do
    For Largo := 1 to 15 do begin
      Read (F,A);
      If A <> 0 Then
        Str (A,Nivel[K,Alto,Largo])
      Else
        Nivel[K,Alto,Largo] := '01111';
    end;
  Close (F);
end;

Procedure Save_Levels; {Guarda los niveles en el disco rigido}
var
  F : file of integer;
  A,K,C : Integer;
  Alto,Largo : Byte;
begin
  Assign (F,'DATA\Levels.dat');
  Rewrite (F);
  Alto  := 1;
  Largo := 1;
  For K := 1 to 10 do
   For Alto := 1 to 10 do
    For Largo := 1 to 15 do begin
      If Nivel[K,Alto,Largo][1] <> '0' then begin
        Val (Nivel[K,Alto,Largo],A,C);
        Write (F,A);
        end
      Else Begin
        A := 0;
        Write (F,A);
        end;
    end;
  Close (F);
end;

Procedure DrawLevelGfx (niv : Integer);  {Inicia c/nivel}
Var
  T1,T2,
  I,J,
  X,Y : Integer;
  Aux : String[4];
Begin
  Y := 13; I := 1;
  Repeat
    X := 1; J := 1;
    Repeat
      Aux := Nivel[niv,I,J];
      If Aux[1] = '1' then begin
        Val (Aux[4],T1,T2);
        If Aux[3] <> '1' then
          If Aux[3] = '3' then XPutCBitmap (X,Y,0,Ladrillo[ { Random(2) + 8 } 8 ])
          else begin If Aux[3] = '2' then XPutCBitmap (X,Y,0,Ladrillo[ { Random(2) + 8 } 9 ]) end
        else XPutCBitmap (X,Y,0,Ladrillo[T1])
        end;
      Inc (X,16); Inc (J);
    Until J = 16;
    Inc (Y,8); Inc (I);
  Until I > 10;
End;

Procedure TextInit;  {Lee las letras e inicia el texto}
Begin
  InstallFont ('DATA\E2_Font.Dat',20,988,Font_1);
  InstallFont ('DATA\E2_Font.Dat',988,1247,Font_2);
  XTextInit;
End;

Procedure EditorInitialSetup;
Begin
  If Not XExists ('DATA\E2_FONT.DAT',FileMissing) then ExitGame (3);
  If Not XExists ('DATA\LEVELS.DAT',FileMissing)  then ExitGame (3);
  XSetMode (0,360);
  PaletteInit;
  TextInit;
  GameSpritesInit;
End;

Procedure EditorExit;
Begin
  If InGraphics = 1 then begin  {Detecta si esta en modo grafico}
    ClearDevice;
    XTextMode;                  {Pone el modo texto}
  end;
End;

Procedure RefreshLevel (nivel : Integer);
Begin
  XRectFill (1,1,250,100,0,0);
  DrawLevelGfx (nivel)
End;

Procedure EraseAllBricks;
Var
  I,J : Byte;
Begin
  For I := 1 to MaxLad do
    For J := 1 to 15 do
       Nivel[Niv,I,J][1] := '0';
  Sw := 1;
  RefreshLevel (niv);
End;

Procedure InvertBricks;
Var
  I,J : Byte;
Begin
  For I := 1 to MaxLad do Begin
    For J := 1 to 15 do Begin
      If Nivel[Niv,I,J][1] = '1' then
        Nivel[Niv,I,J][1] := '0'
      else
        Nivel[Niv,I,J][1] := '1';
    end;
  end;
  Sw := 1;
  RefreshLevel (niv);
End;

Procedure EditBrick (noBrick,limite : Integer);
Var
  Aux,A : Integer;
  B     : String;
Begin
  Aux := 0;
  Val (Nivel[Niv,I,J][noBrick],Aux,A);
  Inc (Aux);
  If Aux > Limite then Begin
    If Limite = 1
       Then Aux := 0
       Else Aux := 1;
    End;
{  If noBrick = 3 then
    Nivel[Niv,I,J][4] := '1'; }
  Str (Aux,B);
  Nivel[Niv,I,J][noBrick] := B[1];
  Sw := 1;
  RefreshLevel (niv);
End;

Begin
Randomize;
Repeat
  Repeat
    ClrScr;
    Write ('Introduc¡ el nivel que quer‚s editar (1-10):');
    ReadLN (Niv);
  Until Niv in [1..10];
{  niv := 1;}
  EditorInitialSetup;
  Load_Levels;
  DrawLevelGfx (Niv);
  XRegisterUserFont (Font_1^);
  XSetFont (2);
  Sw := 0;
  I := 1;
  J := 1;
  X := 1;
  Y := 13;
  XRectangle (X-1,Y-1,X+15,Y+7,223,0);
  Str (I,strX);
  Str (J,strY);
  Str (15*(I-1)+J,tmp);
  XPrintF (10,100,0,223,'Posicion en la matriz: '+strY+' '+strX);
  XPrintF (10,110,0,223,'Numero de ladrillo:    '+tmp);
  XPrintF (10,120,0,223,'Opciones del ladrillo: '+Nivel[Niv,I,J]);
  XPrintF (10,140,0,223,'1 - (0)Desactiva/(1)Activa');
  XPrintF (10,150,0,223,'2 - (0)Sin/(1)Con Capsula');
  XPrintF (10,160,0,223,'3 - Ladrillo (1)Simple/(2)Doble/(3)Indest');
  XPrintF (10,170,0,223,'4 - Color (1 - 8)');
  XPrintF (10,180,0,223,'5  - Tipo de Capsula (si 2 esta activado)');
  XPrintF (10,190,0,223,'(*)Invierte los ladrillos / (E)Borra todos los ladrillos');
  Repeat
    dummyKey := Upcase( ReadKey );
    XRectangle (X-1,Y-1,X+15,Y+7,0,0); {borra el anterior rectangulo blanco}
    XRectFill (120,99,190,140,0,0);   {borra la informacion en pantalla del ladrillo}
    Case DummyKey of
      #75 {Flecha Izquierda} : begin X := X - 16; J := J - 1 end;
      #77 {Flecha Derecha}   : begin X := X + 16; J := J + 1 end;
      #72 {Flecha Arriba}    : begin Y := Y - 8; I := I - 1 end;
      #80 {Flecha Abajo}     : begin Y := Y + 8; I := I + 1 end;
      #49 {1}                : EditBrick (1,1);
      #50 {2}                : EditBrick (2,1);
      #51 {3}                : EditBrick (3,3);
      #52 {4}                : EditBrick (4,7);
      #53 {5}                : EditBrick (5,4);
      #32 {Espacio}          : RefreshLevel(niv);
      #42 {Asterisco}        : InvertBricks;
      #69 {Letra E}          : EraseAllBricks;
    end;
    If X < 1   then begin X := 1;   J := 1  end;
    If X > 225 then begin X := 225; J := 15 end;
    If Y < 13  then begin Y := 13;  I := 1  end;
    If Y > 85  then begin Y := 85;  I := 10 end;
    Str (I,strX);
    Str (J,strY);
    Str (15*(I-1)+J,tmp);
    XPrintF (122,100,0,223,strY+' '+strX);
    XPrintF (120,110,0,223,tmp);
    If Nivel[Niv,I,J][1] <> '0' then
      XPrintF (120,120,0,223,Nivel[Niv,I,J])
    Else
      XPrintF (120,120,0,223,'Desactivado');
    XRectangle (X-1,Y-1,X+15,Y+7,223,0);
  Until dummyKey = #27;
  If Sw = 1 then begin
    XRectFill (0,139,320,200,0,0);   {borra la informacion en pantalla del ladrillo}
    XPrintF (10,160,0,223,'Desea salvar este nivel? (S/N)');
    Repeat
      dummyKey := ReadKey;
      dummyKey := UpCase(dummyKey);
    until (dummyKey = 'S') or (dummyKey = 'N');
    If dummyKey = 'S'then begin
      Save_Levels;
      XPrintF (10,170,0,223,'Nivel Salvado');
      Readkey;
      end;
    End;
  EditorExit;
  Repeat
    ClrScr;
    Write ('Quer‚s editar otro nivel? (S/N):');
    ReadLN (Res);
    Res := UpCase (Res);
  Until (Res = 'S') or (Res = 'N')
{  Res := 'N' }
Until Res = 'N'
End.
