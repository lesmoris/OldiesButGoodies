/*
   TECLAS.H
   Manejo del teclado en el juego

   12/06/03
   Esmoris Leonardo
*/

#include <conio.h>
#include <ctype.h>

/*[---------------------Constantes y Tipos--------------------] */

#define IZQUIERDA 'Z'
#define DERECHA   'C'
#define ARRIBA    'S'
#define ABAJO     'X'

/*[-------------------------Prototipos------------------------] */

/* Funcion LeerTecla */
/* Si se presiono una tecla, la lee, cambia la direccion del */
/* pacman (si es necesario), y devuelve la tecla para su procesado */
int LeerTecla ( tPac *,tNivel );

/*[--------------------------Funciones------------------------] */

int LeerTecla ( tPac *pac,tNivel nivel ) {
   /* Variables */
   int ky;

   /* Comienzo */
   if ( kbhit ( ) ) {
      ky = toupper ( getch ( ) );
      switch ( ky ) {
         case IZQUIERDA : if ( nivel.mat [ (*pac).pacy ] [ (*pac).pacx - 1 ] != PARED ) {
                            (*pac).dirx = -1;
                            (*pac).diry = 0;
                          }
                          break;
         case DERECHA   : if ( nivel.mat [ (*pac).pacy ] [ (*pac).pacx + 1 ] != PARED ) {
                             (*pac).dirx =  1;
                             (*pac).diry = 0;
                          }
                          break;
         case ARRIBA    : if ( nivel.mat [ (*pac).pacy - 1 ] [ (*pac).pacx ] != PARED ) {
                             (*pac).diry = -1;
                             (*pac).dirx = 0;
                          }
                          break;
         case ABAJO     : if ( nivel.mat [ (*pac).pacy + 1 ] [ (*pac).pacx ] != PARED ) {
                             (*pac).diry =  1;
                             (*pac).dirx = 0;
                          }
                          break;
      }
   }
   return ky;
}

