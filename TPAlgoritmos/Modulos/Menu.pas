Unit Menu;
Interface
Type
  aChoiceArray = Array [ 1..11 ] of String; {Menucito para usar el teclado hecho por mi!}

Function aChoice ( VAR aNames : aChoiceArray; iMax : Integer; X,Y : Byte ) : Integer;

Implementation
Uses Crt;
{FUNCION aCHoice

Crea un menu en pantalla con los datos de un array con las opciones
y devuelve la opcion elegida.

PARAMETROS = aNames : El menu con las opciones a imprimir
             Tipo   : aChoiceArray
             Uso    : E/S

             iMax   : Cantidad de opciones que tiene el menu
             Tipo   : Entero
             Uso    : E

             X,Y    : Posicion en pantalla a imprimirse el menu
             Tipo   : Byte
             Uso    : E

DEVUELVE = Entero. Es la opcion elegida por el usuario
}
Function aChoice ( VAR aNames : aChoiceArray; iMax : Integer; X,Y : Byte ) : Integer;
Var
  I      : Integer;   { Indice para uso interno del procedimiento }
  cTecla : Char;      { Variable que almacena la ultima tecla pulsada }
  bFlag  : Boolean;   { Indica si ya se ha elegido una opcion o debe seguir }
Begin
  GotoXY ( X,Y );
  WriteLn ('Seleccione:');
  For I := 1 to iMax do              { Se imprime el menu en pantalla }
    WriteLn (I,'.- ', + aNames[i]);
  I := 1;
  bFlag := False;
  Repeat
    { En esta parte se resalta la opcion actual }
    GotoXY ( X,Y + I );
    TextBackGround ( 1 );
    TextColor ( 15 );
    Write ( I,'.- ', + aNames[ I ] );
    { Aca se espera que el usuario pulse una tecla }
    cTecla := UpCase ( Readkey );
    { Se saca el resaltado antes de procesar la tecla }
    GotoXY ( X,Y+I );
    TextBackGround (0);
    TextColor ( 7 );
    Write ( I,'.- ', + aNames[ I ] );
    { Se procesa la tecla }
    Case cTecla of
      #72 : Dec ( I );         { Tecla FLECHA ARRIBA }
      #80 : Inc ( I );         { Tecla FLECHA ABAJO  }
      #13 : bFlag := True;     { Tecla ENTER  }
      #27 : bFlag := True;     { Tecla ESCAPE }
    end;
    If I > iMax
      Then  { Verifica que no se salga del limite superior del menu }
        I := iMax
      Else
        If I < 1
          Then { Verifica que no se salga del limite inferior del menu }
            I := 1;
  Until bFlag = True; { Hasta que se pulse ENTER o ESCAPE }
  ClrScr;
  If cTecla = #27
    Then { Si se pulsa ESCAPE entonces, sin importar la opcion actual, se supone
           que el usuario quiere salir y por eso se asigna como valor de
           retorno la ultima opcion del menu (SALIR) }
      aChoice := iMax
    Else
      aChoice := I; { Si no, se devuelve la opcion elegida }
  GotoXY ( X,Y ); { Se pone el cursor donde estaba al principio }
End; { aChoice }

End.