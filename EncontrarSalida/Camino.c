#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "puntos.h"
#include "pila.h"
#include "nivel.h"

int EncontrarCamino ( int mat[ALTO][ANCHO], tPunto , tPunto , tPila * );
void DireccionInicial ( int vPri[4], tPunto A, tPunto B);
int AdondeMover (  int mat[ALTO][ANCHO], int, tPunto );
int Moverse ( int mat[ALTO][ANCHO],int ,tPunto * ,tPila * );

/* [--------------------------PROGRAMA PRINCIPAL-------------------------] */

int main ( ) {
  /* Variables */
  int mat [ALTO][ANCHO] = { { 2,2,2,2,2,2,2,2,2,2,2,2 },
                            { 2,0,0,0,2,0,0,0,0,0,0,2 },
                            { 2,0,0,0,2,0,2,2,2,2,0,2 },
                            { 2,0,0,0,2,0,0,0,0,2,0,2 },
                            { 2,0,2,2,2,0,2,2,0,2,0,2 },
                            { 2,0,2,0,0,0,0,2,0,2,0,2 },
                            { 2,0,2,0,0,2,0,2,0,2,0,2 },
                            { 2,0,0,0,0,2,0,0,0,2,0,2 },
                            { 2,0,2,2,0,2,0,0,0,2,0,2 },
                            { 2,0,2,2,0,2,2,2,0,2,0,2 },
                            { 2,0,0,0,0,0,0,0,0,2,0,2 },
                            { 2,2,2,2,2,2,2,2,2,2,2,2 } };

  tPunto A,B;
  tPila pila;

  /* Comienzo */
  clrscr ( );
  A.x =  1;
  A.y = 10;
  B.x = 10;
  B.y = 10;
  pila = CreaPila ( );
  MuestraPunto ( A,"A" );
  MuestraPunto ( B,"B" );
  if ( EncontrarCamino ( mat,A,B,&pila ) == 1 )
    puts ( "Existe un camino de A a B" );
  else
    puts ( "No existe un camino de A a B" );
  MuestraNivel ( mat );
  getch ( );
  return 0;
}

int EncontrarCamino ( int mat[ALTO][ANCHO], tPunto A , tPunto B , tPila *pila ) {
  /* Variables */
  int vPri[ 4 ];     /* En este vector esta para donde conviene moverse */

  int j,i;           /* Variables de manejo de ciclos                   */

  int nomueve = 0,   /* Determina si ya no hay posibilidades de moverse */
      llego   = 0,   /* Determina se se llego al punto de destino       */
      semovio;       /* Determina se se movio                           */

  /* Comienzo */
  while ( !nomueve && !llego ) {
    /* Establece las prioridades de movimiento segun el punto destino */
    DireccionInicial ( vPri,A,B );
    semovio = 0;
    for ( j = 0 ; j < 4 && !semovio ; j++ )
      /* Ubica la direccion a moverse y trata de moverse en esa direccion */
      semovio = Moverse ( mat,vPri[j],&A,pila );

    /* Si no se pudo mover, se fija si puede volver atras */
    if ( !semovio ) {
      mat [ A.y ][ A.x ] = PASO;
      if ( Sacar ( pila,&A ) != 0 )
        nomueve = 1;
    }

    /* Si llego, sale del ciclo */
    if ( A.x == B.x && A.y == B.y ) {
      Meter ( pila,A );
      mat [ A.y ][ A.x ] = CAMINO;
      llego = 1;
    }

  } /* end while */
  if ( llego )
    return 1; /* Devuelve que pudo encontrar un camino */
  else
    return 0; /* Devuelve que no pudo encontrar un camino */
}

void DireccionInicial ( int vPri[4], tPunto A, tPunto B ) {
  /* Comienzo */
  if ( B.x - A.x == 0 ) {
    vPri[ 1 ] =  1;
    vPri[ 3 ] = -1;
    if ( B.y - A.y >= 0 ) {
      vPri[ 0 ] =  10;
      vPri[ 2 ] = -10;
    }
    else {
      vPri[ 0 ] = -10;
      vPri[ 2 ] =  10;
    }
  }
  else {
    if ( B.x - A.x > 0 ) {
      vPri[ 0 ] =  1;
      vPri[ 2 ] = -1;
    }
    else {
      vPri[ 0 ] = -1;
      vPri[ 2 ] =  1;
    }

    if ( B.y - A.y >= 0 ) {
      vPri[ 1 ] =  10;
      vPri[ 3 ] = -10;
    }
    else {
      vPri[ 1 ] = -10;
      vPri[ 3 ] =  10;
    }
  }

}

int AdondeMover ( int mat[ALTO][ANCHO], int dir, tPunto A ) {
  /* Comienzo */
  /* Calcula la direccion en la que se va a tratar de mover */
  switch ( dir ) {
    case   1 : return mat [ A.y ][ A.x + 1 ]; /* Derecha   */
    case  -1 : return mat [ A.y ][ A.x - 1 ]; /* Izquierda */
    case  10 : return mat [ A.y + 1 ][ A.x ]; /* Abajo     */
    case -10 : return mat [ A.y - 1 ][ A.x ]; /* Arriba    */
  } /* switch */
  return -1;
}

int Moverse ( int mat[][ANCHO],int dir,tPunto *A,tPila *pila ) {
  /* Variables */
  int lugar;           /* Determina hacia donde hay que moverse */

  /* Comienzo */
  /* Se fija para donde moverse */
  lugar = AdondeMover ( mat,dir,*A );
  /* Se mueve en esa direccion */
  if ( lugar != CAMINO && lugar != PASO && lugar != PARED ) {
    Meter ( pila,*A );
    mat [ (*A).y ][ (*A).x ] = CAMINO;
    switch ( dir ) {
      case   1 : (*A).x++; break;
      case  -1 : (*A).x--; break;
      case  10 : (*A).y++; break;
      case -10 : (*A).y--; break;
    } /* end switch */
    return 1;
  } /* end if */
  return 0;
}