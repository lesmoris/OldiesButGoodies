/*
  NIVEL.H
  Contiene funciones para el manejo de la matriz principal

  15/6/03
  Esmoris Leonardo
*/

#include <stdio.h>
#include <conio.h>

/* [------------------------------CONSTANTES-----------------------------] */

#define ALTO  24  /* Alto real  : 22 */
#define ANCHO 29  /* Ancho real : 27 */

#define LIBRE  0
#define PARED  1

#define CAMINO 3
#define PASO   4

/* [------------------------------PROTOTIPOS-----------------------------] */

void MuestraNivel ( int mat[ALTO][ANCHO] );
int CargaNivel ( char *NomArch, int mat[ALTO][ANCHO] );

/* [-------------------------------FUNCIONES-----------------------------] */

void MuestraNivel ( int mat[ALTO][ANCHO] ) {
  /* Variables */
  int i,j;

  /* Comienzo */
  gotoxy ( 1,1 );
  for ( i = 0 ; i < ALTO ; i++ ) {
    for ( j = 0 ; j < ANCHO ; j++ ) {
      switch ( mat[i][j] ) {
        case LIBRE  : printf ( " ",mat[i][j] ); break;
        case CAMINO : printf ( "*",mat[i][j] ); break;
        case PASO   : printf ( ".",mat[i][j] ); break;
        case PARED  : printf ( "|",mat[i][j] ); break;
      }
    }
    puts ( "" );
  }

}

int CargaNivel ( char *NomArch, int mat[ALTO][ANCHO] ) {
   /* Variables */
   FILE *fnivel;
   int ch;
   int fil,col;

   /* Comienzo  */
   /* Apertura del archivo */
   if ( ( fnivel = fopen ( NomArch,"r" ) ) == NULL )
      return -1;
   /* Lectura del nivel */
   fil = 0;
   col = 0;
   ch = getc ( fnivel );
   while ( ch != EOF ) {
      switch ( ch ) {
         case '0': mat[fil][col] = LIBRE; col++; break;
         case '1': mat[fil][col] = PARED; col++; break;
         case '2': mat[fil][col] = LIBRE; col++; break;
         case '3': mat[fil][col] = LIBRE; col++; break;
         case '6': mat[fil][col] = LIBRE; col++; break;
         case 10 : fil++; col = 0; break;
      }
      ch = getc ( fnivel );
   }
   /* Cerrado del archivo */
   if ( fclose ( fnivel ) != 0 )
      return -2;
   return 0;
}

