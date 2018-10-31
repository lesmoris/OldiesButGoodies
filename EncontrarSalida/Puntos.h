/*
  PUNTOS.H
  Tipos y Funciones para el manejo de puntos.

  15/06/03
  Esmoris Leonardo
*/
 
#include <stdio.h>

/* [----------------------------TIPOS DE DATOS---------------------------] */

struct _TipoPunto {
  int x,y;
} TipoPunto;

typedef struct _TipoPunto tPunto;

/* [------------------------------PROTOTIPOS-----------------------------] */

void CrearPunto ( tPunto *, int, int );
void MuestraPunto ( tPunto , char PtoNom[] );

/* [-------------------------------FUNCIONES-----------------------------] */

void CrearPunto ( tPunto *punto, int x, int y ) {
  (*punto).x = x;
  (*punto).y = y;
}

void MuestraPunto ( tPunto punto, char PtoNom[] ) {
  printf ( "Punto %s : %3d %3d\n",PtoNom,punto.x,punto.y );
}
