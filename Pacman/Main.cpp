/* Archivos cabecera con los modulos del juego */
#include "nivel.hpp"
#include "jugador.hpp"
#include "pacman.hpp"
#include "fant.hpp"
#include "teclas.hpp"

void InicializarPantalla ( void );

int main ( )  {
   /* Variables */
   tNivel Nivel;           /* Datos del nivel  */
   tPac Pac;               /* Datos del pacman */
   tFant fant[CANTFANT];   /* Datos de los fantasmas */
   tJugador Jug;           /* Datos del que esta jugando */

   int EstPac;             /* Estado del pacman */

   /* Comienzo */
   InicializarPantalla ( );
   Nivel.Carga ( "niveles/nivel.txt" );
   CreaPac ( &Pac,&Nivel );
   CreaFantasmas ( fant,&Nivel );
   do {
      EstPac = MoverPac ( &Pac,&Nivel,&Jug );
      MoverFantasmas ( fant,Pac,&Nivel );
      Nivel.Dibujar ( );
      Jug.MostrarScore ( );
   } while ( LeerTecla ( &Pac,Nivel ) != 27 &&
             Nivel.pills > 0 &&
             EstPac != FANTASMA );

   return 0;
}

void InicializarPantalla ( void ) {
   /* Comienzo */
   clrscr ( );
   textmode ( C4350 );
}
