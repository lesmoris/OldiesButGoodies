/*
   PACMAN.H
   Archivo con tipos y funciones para el manejo del pacman

   11/06/03
   Esmoris Leonardo
*/

#include <stdio.h>

/*[--------------------Constantes y Tipos---------------------]*/

#define PACSPEED 6

typedef struct _TipoPac {
   int pacx,      /* Define la posicion X del pacman en el nivel */
       pacy;      /* Define la posicion Y del pacman en el nivel */
   int dirx,      /* Define la direccion X del pacman            */
                  /*   1 : Avance a la derecha                   */
                  /*   0 : Sin avance                            */
                  /*  -1 : Avance a la izquierda                 */
       diry;      /* Idem dirx, pero para Y                      */
   int vidas;     /* Cantidad de vidas iniciales del pacman      */
   int speedX,
       speedY;
} tPac;

/*[-------------------------Prototipos------------------------] */

/* Funcion CreaPac */
/* Establece los valores iniciales del pacman y lo posiciona */
/* dentro del nivel */
void CreaPac ( tPac *, tNivel * );

/* Funcion Mover */
/* Mueve el pacman segun la dirx y la diry */
int MoverPac ( tPac *, tNivel *, tJugador * );

/* Funcion
/*[--------------------------Funciones------------------------] */

void CreaPac ( tPac *pac, tNivel *nivel ) {
   /* Valores iniciales del pacman */
   (*pac).pacx   = 14;
   (*pac).pacy   = 19;
   (*pac).dirx   = 0;
   (*pac).diry   = 0;
   (*pac).vidas  = 2;
   (*pac).speedX = 0;
   (*pac).speedY = 0;
   /* Posiciona el pacman en el nivel */
   (*nivel).mat[ (*pac).pacy ][ (*pac).pacx ] = 5;
}

int MoverPac ( tPac *pac, tNivel *nivel, tJugador *Jug ) {
   /* Comienzo */

   /* Movimiento Izquierda - Derecha */
   if ( (*nivel).mat [ (*pac).pacy ] [ (*pac).pacx + (*pac).dirx ] != PARED ) {
      switch ( (*nivel).mat [ (*pac).pacy ] [ (*pac).pacx + (*pac).dirx ] ) {
         case FANTASMA  : return FANTASMA;
      }
      (*nivel).mat [ (*pac).pacy ] [ (*pac).pacx ] = LIBRE;
      if ( ++(*pac).speedX == PACSPEED ) {
        (*pac).pacx += (*pac).dirx;
        switch ( (*nivel).mat [ (*pac).pacy ] [ (*pac).pacx ] ) {
          case PILL      : (*nivel).pills--; (*Jug).IncPuntaje ( ptosPILL ); break;
          case SUPERPILL : (*nivel).pills--; (*Jug).IncPuntaje ( ptosSUPERPILL ); break;
        }
        (*pac).speedX = 0;
      }
      (*nivel).mat [ (*pac).pacy ] [ (*pac).pacx ] = PACMAN;
   }

   /* Movimiento Arriba - Abajo */
   if ( (*nivel).mat [ (*pac).pacy + (*pac).diry ] [ (*pac).pacx ] != PARED ) {
      switch ( (*nivel).mat [ (*pac).pacy + (*pac).diry ] [ (*pac).pacx ] ) {
         case FANTASMA  : return FANTASMA;
      }
      (*nivel).mat [ (*pac).pacy ] [ (*pac).pacx ] = LIBRE;
      if ( ++(*pac).speedY == PACSPEED ) {
        (*pac).pacy += (*pac).diry;
        switch ( (*nivel).mat [ (*pac).pacy ] [ (*pac).pacx ] ) {
          case PILL      : (*nivel).pills--; (*Jug).IncPuntaje ( ptosPILL ); break;
          case SUPERPILL : (*nivel).pills--; (*Jug).IncPuntaje ( ptosSUPERPILL ); break;
        }
        (*pac).speedY = 0;
      }
      (*nivel).mat [ (*pac).pacy ] [ (*pac).pacx ] = PACMAN;
   }

   return LIBRE;
}