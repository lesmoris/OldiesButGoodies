// Archivo MENUS.C
//
// Esmoris Leonardo                            leonardo_esmoris@yahoo.com.ar
//
// Descripcion : Crea un menu en pantalla con las opciones recividas desde
//               un vector aOpcion. El vector hab perimte habilitar opciones
//               para personalizar las opciones posibles. Este modulo es
//               mi version para C de la funcion aChoice de Clipper
#include <stdio.h>
#include <conio.h>

//[------------------------------Constantes--------------------------------]//
#define SEPARADOR "---------------------"

//[------------------------Prototipos de Funciones-------------------------]//
int Menu ( char *aOpcion[ ], int hab[ ], int CantOp, int x, int y );

//[-------------------------------Funciones--------------------------------]//
int Menu ( char *aOpcion[ ], int hab[ ], int CantOp, int x, int y ) {
  int i,sw = 0;
  char ky;

  gotoxy ( x,y );
  puts ( "Seleccione : " );
  y += 2;
  for ( i = 0 ; i < CantOp ; i++ ) {
    gotoxy ( x,y + i );
    printf ( "%s\n",aOpcion[ i ] );
  }
  i = 0;
  while ( sw == 0 ) {
    gotoxy ( x,y + i );
    if ( hab[ i ] == 0 ) textcolor ( DARKGRAY );
    else textcolor ( WHITE );
    textbackground ( BLUE );
    cprintf ( "%s",aOpcion [ i ] );

    ky = getche ( );

    gotoxy ( x,y + i );
    textcolor ( LIGHTGRAY );
    textbackground ( BLACK );
    cprintf ( "%s ",aOpcion [ i ] );

    switch ( ky ) {
      case 72 : if ( i > 0 ) i--; break;
      case 80 : if ( i < CantOp - 1 ) i++; break;
      case 27 : sw = 1; break;
      case 13 : if ( hab[ i ] == 1 ) sw = 1; break;
    }
  }
  if ( ky == 27 )
    return CantOp-1;
  return i;
}