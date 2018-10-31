/*
  MAIN.C
  Programa que testea el modulo CAMINO.H

  15/06/03
  Esmoris Leonardo
*/

#include "nivel.h"
#include "camino.h"

int main ( ) {
  /* Variables */
  int mat [ALTO][ANCHO];
  tPunto A,B,I;
  tCamino camino;
  int i,ky,sw;

  /* Comienzo */
  CargaNivel ( "nivel3.txt",mat );
  A.x =  1;
  A.y =  1;
  B.x =  20;
  B.y =  10;

  srand ( time ( NULL ) );
  camino = CreaCamino ( );
  EncontrarCamino ( mat,A,B,&camino,10 );
  for ( i = 0 ; i < 4 ; i++ ) {
    MuestraNivel ( mat );
    sw = 1;
    while ( Sacar ( &camino,&A ) != -1 ) {
      if ( sw == 1 ) {
        I = A;
        sw = 0;
      }
      gotoxy ( A.x+1,A.y+1 );
      printf ( "*" );
    }
    getch ( );
    A   = I;
    B.x = rand ( ) % 20 + 1;
    B.y = rand ( ) % 20 + 1;
    EncontrarCamino ( mat,A,B,&camino,10 );
  }
  return 0;
}
