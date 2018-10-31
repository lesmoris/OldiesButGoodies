/*
   FANT.H
   Maneja el movimiento y la IA de los fantasmas en el juego

   12/06/03
   Esmoris Leonardo
*/

#include <stdio.h>
#include "camino.hpp"

/*[--------------------Constantes y Tipos---------------------] */
#define CANTFANT 1
#define MAXSPEED 6
#define MAXCAMINO 10

typedef struct _TipFant {
   int fantx,       /* Define la posicion X del fantasma en el nivel */
       fanty;       /* Define la posicion Y del fantasma en el nivel */
   int speed,
       maxspeed;
   int PtoAnt;
   tCamino Camino;  /* Guarda por donde debe ir el fantasma          */
   tPunto Aux;      /* Guarda el ultimo punto del Fantasma           */
   int nPasos;      /* Cantidad de pasos realizados                  */
} tFant;

/*[-------------------------Prototipos------------------------] */
void CreaFantasmas ( tFant fant[CANTFANT], tNivel * );
void MoverFantasmas ( tFant fant[CANTFANT], tPac , tNivel * );
void RemapearCamino ( int mat[ALTO][ANCHO], tFant *fant, tPac pac );

/*[-------------------------Funciones-------------------------] */
void CreaFantasmas ( tFant fant[CANTFANT], tNivel *nivel ) {
   /* Variables */
   int nfant;

   /* Comienzo */
   for ( nfant = 0 ; nfant < CANTFANT ; nfant++ ) {
      fant[ nfant ].fantx  = 14;
      fant[ nfant ].fanty  = 12;
      fant[ nfant ].speed  = 0;
      fant[ nfant ].maxspeed = MAXSPEED + rand ( ) % 4;
      fant[ nfant ].nPasos = MAXCAMINO + rand ( ) % 10;
      fant[ nfant ].Camino = NULL;
      fant[ nfant ].PtoAnt = (*nivel).mat [ fant[ nfant ].fanty ] [ fant[ nfant ].fantx ];
      (*nivel).mat [ fant[ nfant ].fanty ] [ fant[ nfant ].fantx ] = FANTASMA;
   }
}

void MoverFantasmas ( tFant fant[CANTFANT], tPac pac, tNivel *nivel ) {
  /* Variables */
  int nfant;
  tPunto PtoFant;

  /* Comienzo */
  for ( nfant = 0 ; nfant < CANTFANT ; nfant++ ) {

    if ( fant[ nfant ].nPasos == MAXCAMINO ) {
      RemapearCamino ( (*nivel).mat,fant,pac );
      fant[ nfant ].nPasos = 0;
    }
    else {
      (*nivel).mat [ fant[ nfant ].fanty ] [ fant[ nfant ].fantx ] = LIBRE;
      if ( ++fant[ nfant ].speed == fant[ nfant ].maxspeed ) {
        (*nivel).mat [ fant[ nfant ].fanty ] [ fant[ nfant ].fantx ] = fant[ nfant ].PtoAnt;
        Sacar ( &fant[ nfant ].Camino,&PtoFant );
        fant[ nfant ].PtoAnt = (*nivel).mat [ PtoFant.y ] [ PtoFant.x ];
        fant[ nfant ].fantx = PtoFant.x;
        fant[ nfant ].fanty = PtoFant.y;
        fant[ nfant ].nPasos++;
        fant[ nfant ].speed = 0;
      }
      (*nivel).mat [ fant[ nfant ].fanty ] [ fant[ nfant ].fantx ] = FANTASMA;
    }
  }
}

void RemapearCamino ( int mat[ALTO][ANCHO], tFant *fant, tPac pac ) {
  /* Variables */
  tPunto PtoFant,PtoPac,PtoAux;

  /* Comienzo */
  CrearPunto ( &PtoFant, (*fant).fantx, (*fant).fanty );
  CrearPunto ( &PtoPac, pac.pacx, pac.pacy );
  EncontrarCamino ( mat, PtoFant, PtoPac, &(*fant).Camino, MAXCAMINO );
  VoltearCamino ( &(*fant).Camino );
}
