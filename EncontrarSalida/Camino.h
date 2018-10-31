/*
  CAMINO.C
  Funciones que permiten encontrar caminos dentro de una matriz

  15/06/03
  Esmoris Leonardo
*/

#include <stdio.h>
#include <stdlib.h>
#include <conio.h>

/* [------------------------------PROTOTIPOS-----------------------------] */

#define MOVIDO     0
#define SINMOV     1
#define INAMOVIBLE 2
#define LLEGO      3

/* [--------------------------DEFINICION DE TIPOS------------------------] */

struct _TipoPunto {
  int x,y;
} TipoPunto;

struct _TipoCamino {
  int x,y;
  struct _TipoCamino *sgte;
} TipoCamino;

typedef struct _TipoPunto tPunto;
typedef struct _TipoCamino *tCamino;

/* [------------------------------PROTOTIPOS-----------------------------] */

/*
  Funcion EncontrarCamino
  Dada una matriz, un punto inicial "A" y un punto final "B", devuelve un
  estructura en memoria dinamica que contiene todos las celdas de la
  matriz por las que hay que pasa para llegar desde el punto A hasta B.
*/
int EncontrarCamino ( int mat[ALTO][ANCHO], tPunto , tPunto , tCamino *, int );

/*
  Funcion DireccionInicial
  Establece hacia donde conviene empezar moverse segun las coordenadas
  del punto inicial y final
*/
void DireccionInicial ( int vPri[4], tPunto A, tPunto B);

/*
  Funcion Moverse
  Trata de moverse segun la direccion establecida por las anteriores
  funciones
*/
int Moverse ( int mat[ALTO][ANCHO],int ,tPunto * ,tCamino * );

/*
  Funcion AdondeMover
  Se fija para que lugar de la matriz se va a mover
*/
int AdondeMover (  int mat[ALTO][ANCHO], int, tPunto );

int VuelveAtras ( int mat[ALTO][ANCHO], tPunto *, tCamino * );

void VoltearCamino ( tCamino *Camino );

tCamino CreaCamino ( void );
int Meter ( tCamino * , tPunto );
int Sacar ( tCamino * , tPunto * );

void CrearPunto ( tPunto *, int, int );
void MuestraPunto ( tPunto , char PtoNom[] );

/* [-------------------------------FUNCIONES-----------------------------] */

int EncontrarCamino ( int aux[ALTO][ANCHO], tPunto A , tPunto B , tCamino *camino, int cantmax ) {
  /* Variables */
  int mat[ALTO][ANCHO];
  int vPri[ 4 ];        /* En este vector esta para donde conviene moverse */
  int estado = SINMOV;  /* Determina el estado del movimiento              */
  int mov;              /* Variables de manejo de ciclos                   */

  /* Comienzo */
  memcpy ( mat,aux,ALTO*ANCHO*2 );
  while ( cantmax-- > 0 ) {
    /* Establece las prioridades de movimiento segun el punto destino */
    DireccionInicial ( vPri,A,B );
    estado = SINMOV;
    for ( mov = 0 ; mov < 4 && estado != MOVIDO ; mov++ )
      /* Ubica la direccion a moverse y trata de moverse en esa direccion */
      estado = Moverse ( mat,vPri[mov],&A,camino );
  } /* end while */
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

int Moverse ( int mat[ALTO][ANCHO], int dir, tPunto *A, tCamino *camino ) {
  /* Variables */
  int lugar;           /* Determina hacia donde hay que moverse */

  /* Comienzo */
  /* Se fija para donde moverse */
  lugar = AdondeMover ( mat,dir,*A );
  /* Se mueve en esa direccion */
  if ( lugar != CAMINO && lugar != PASO && lugar != PARED ) {
    Meter ( camino,*A );
    mat [ (*A).y ][ (*A).x ] = CAMINO;
    switch ( dir ) {
      case   1 : (*A).x++; break;  /* Derecha   */
      case  -1 : (*A).x--; break;  /* Izquierda */
      case  10 : (*A).y++; break;  /* Abajo     */
      case -10 : (*A).y--; break;  /* Arriba    */
    } /* end switch */
    return MOVIDO;
  } /* end if */
  return SINMOV;
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

int VuelveAtras ( int mat[ALTO][ANCHO], tPunto *A, tCamino *camino ) {
  mat [ (*A).y ][ (*A).x ] = PASO;
  if ( Sacar ( camino,A ) != 0 )
    return INAMOVIBLE;
  return SINMOV;
}

tCamino CreaCamino ( ) {
  return NULL;
}

int Meter ( tCamino *camino , tPunto punto ) {
  /* Variables */
  tCamino nodo;

  /* Comienzo */
  if ( ( nodo = ( tCamino ) malloc ( sizeof ( TipoCamino ) ) ) != NULL ) {
    nodo->x = punto.x;
    nodo->y = punto.y;
    nodo->sgte = *camino;
    *camino = nodo;
    return 0;
  }
  else
    return -1;
}

int Sacar ( tCamino *camino , tPunto *punto ) {
  /* Variables */
  tCamino nodo;

  /* Comienzo */
  if ( *camino != NULL ) {
    nodo = *camino;
    *camino = (*camino)->sgte;
    (*punto).x = nodo->x;
    (*punto).y = nodo->y;
    free ( nodo );
    return 0;
  }
  else
    return -1;
}

void VoltearCamino ( tCamino *Camino ) {
  /* Variables */
  tCamino CaminoAux;
  tPunto PtoAux;

  /* Comienzo */
  CaminoAux = CreaCamino ( );
  while ( Sacar ( Camino,&PtoAux ) != -1 )
    Meter ( &CaminoAux,PtoAux );
  *Camino = CaminoAux;
}

void CrearPunto ( tPunto *punto, int x, int y ) {
  (*punto).x = x;
  (*punto).y = y;
}

void MuestraPunto ( tPunto punto, char PtoNom[] ) {
  printf ( "Punto %s : %3d %3d\n",PtoNom,punto.x,punto.y );
}
