/*
  PILA.H
  Funciones de manejo de pilas dinamicas

  15/06/03
  Esmoris Leonardo
*/

#include <stdio.h>
#include <stdlib.h>

/* [----------------------------TIPOS DE DATOS---------------------------] */

struct _TipoPila {
  int x,y;
  struct _TipoPila *sgte;
} TipoPila;

typedef struct _TipoPila *tPila;

/* [------------------------------PROTOTIPOS-----------------------------] */

tPila CreaPila ( void );
int Meter ( tPila * , tPunto );
int Sacar ( tPila * , tPunto * );

/* [-------------------------------FUNCIONES-----------------------------] */

tPila CreaPila ( ) {
  return NULL;
}

int Meter ( tPila *pila , tPunto punto ) {
  /* Variables */
  tPila nodo;

  /* Comienzo */
  if ( ( nodo = ( tPila ) malloc ( sizeof ( TipoPila ) ) ) != NULL ) {
    nodo->x = punto.x;
    nodo->y = punto.y;
    nodo->sgte = *pila;
    *pila = nodo;
    return 0;
  }
  else
    return -1;
}

int Sacar ( tPila *pila , tPunto *punto ) {
  /* Variables */
  tPila nodo;

  /* Comienzo */
  if ( *pila != NULL ) {
    nodo = *pila;
    *pila = (*pila)->sgte;
    (*punto).x = nodo->x;
    (*punto).y = nodo->y;
    free ( nodo );
    return 0;
  }
  else
    return -1;
}
