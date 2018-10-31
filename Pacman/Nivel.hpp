/*
   NIVEL.H
   Archivo con tipos y funciones para el manejo de los niveles

   11/06/03
   Esmoris Leonardo
*/

#include <stdio.h>
#include <conio.h>


/*[--------------------Constantes y Tipos---------------------]*/

/* Alto y ancho del nivel*/
#define ALTO      24
#define ANCHO     29

/* Elementos del nivel */
#define LIBRE      0
#define PARED      1
#define PILL       2
#define SUPERPILL  3

/* Personajes */
#define PACMAN     6
#define FANTASMA   7

/* Estructura del Nivel */
class tNivel {
  public :
    tNivel ( );
    int Carga ( char * );
    void Dibujar ( );

    int mat[ ALTO ][ ANCHO ];  /* Matriz con el nivel */
    int pills;                 /* Cantidad de pildoras totales */
  private :
    void DibujarCaracter ( int car );
};

tNivel :: tNivel ( ) {
}

int tNivel :: Carga ( char *NomArch ) {
   /* Variables */
   FILE *fnivel;
   int ch;
   int fil,col;

   /* Comienzo  */
   /* Apertura del archivo */
   if ( ( fnivel = fopen ( NomArch,"r" ) ) == NULL )
      return -1;
   /* Lectura del nivel */
   pills = 0;
   fil = 0;
   col = 0;
   ch = getc ( fnivel );
   while ( ch != EOF ) {
      switch ( ch ) {
         case '0': mat[fil][col] = LIBRE; col++; break;
         case '1': mat[fil][col] = PARED; col++; break;
         case '2': mat[fil][col] = PILL; col++; pills++; break;
         case '3': mat[fil][col] = SUPERPILL; col++; pills++; break;
         case 10 : fil++; col = 0; break;
      }
      ch = getc ( fnivel );
   }
   /* Cerrado del archivo */
   if ( fclose ( fnivel ) != 0 )
      return -2;
   return 0;
}

void tNivel :: Dibujar ( ) {
   /* Variables */
   int fil,col;
   int ky;

   /* Comienzo */
   gotoxy ( 1,1 );
   for ( fil = 0 ; fil < ALTO ; fil++ ) {
      for ( col = 0 ; col < ANCHO ; col++ )
         DibujarCaracter ( mat [ fil ][ col ] );
      printf ( "\n" );
   }
}

void tNivel :: DibujarCaracter ( int car ) {
   /* Comienzo */
   switch ( car ) {
      case LIBRE     : printf ( " " ); break;
      case PARED     : printf ( "|" ); break;
      case PILL      : printf ( "." ); break;
      case SUPERPILL : printf ( "*" ); break;
      case PACMAN    : printf ( "O" ); break;
      case FANTASMA  : printf ( "A" ); break;
   }
}
