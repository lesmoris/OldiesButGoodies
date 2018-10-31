// Archivo AFD.C
//
// Esmoris Leonardo                            leonardo_esmoris@yahoo.com.ar
//
// Descripcion : Es el "corazon" del programa. Aca se lee el archivo .AFD,
//               y con la informacion sacada del mismo se crea una
//               estructura en memoria dinamica que simula el
//               comportamiento de un automata. Luego de usarse, el automata
//               en memoria se elimina de la misma.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//[-Constantes -----------------------------------------------]
//[-Estados Posibles -----------------------------------------]
#define INICIAL   0         // Estado Inicial
#define TRANS     1         // Estado de Transicion
#define FINAL     2         // Estado Final
#define INIC_FIN  3         // Estado Incial/Final
#define ERROR     4         // Para uso interno

//[-Funcion de Transicion Nula y Nodo Error ------------------]
#define NODO_ERR -1         // Nodo Error
#define FNULA    -2         // Funcion Nula

//[-Posibles salidas -----------------------------------------]
#define CON_ECO   1         // Con salida en pantalla
#define SIN_ECO   0         // Sin salida en pantalla

//[-Estados en la creacion y ejecucion del AFD ---------------]
#define NORMAL         0    // Sin errores
#define ERR_ARCHIVO   -1    // Error al abrir archivo .AFD
#define ERR_FUNC_NODO  5    // Error en la funcion OperarNodo

//[------------------------------Estructuras-------------------------------]//

// Estructura TipoAFD
//
// Descripcion : En esta estructura se guardan todos los datos del automata.
//               El uso de la misma facilita muchisimo el uso del programa.
struct _TipoAFD {
  struct _TipoAutFDet *AFD;   // Puntero al Automata en memoria
  int nCantEst;               // Cantidad de estados totales. (0..nCantEst-1)
  char *Alfabeto;             // Guarda los caracteres todos juntos
  char *NomArch;              // Guarda el nombre del archivo .AFD
} TipoAFD;

// Estructura TipoPtrTrans
//
// Descripcion : Guarda los caracteres que tienen alguna transicion en ese
//               estado y sus respectivas funciones en memoria dinamica
struct _TipoPtrTrans {
  char cCarTrans;             // Caracter de transicion
  short int nEstado;          // Numero de estado a ir por cCarTrans
  struct _TipoPtrTrans *Sgte;
} TipoPtrTrans;

// Estructura TipoAutFDef
//
// Descripcion : Guarda los estados, el tipo de los mismos, caracteres y
//               sus transiciones en memoria dinamica
//
// nEstado : Numero de estado
// TipEst  : Tipo de Estado = 0 - Inicial
//                            1 - De Transicion
//                            2 - Final
//                            3 - Incial / Final
//                            4 - De Error ( Reservado para uso interno )
// *LisTrans : Sublista con los caracteres y sus transiciones
struct _TipoAutFDet {
  short int nEstado;
  short int TipEst;
  struct _TipoPtrTrans *LisTrans;
  struct _TipoAutFDet *Sgte;
} TipoAutFDet;

// Definicion de Tipos
typedef struct _TipoAFD tAFD;
typedef struct _TipoPtrTrans *tPtrTrans;
typedef struct _TipoAutFDet  *tAutFDet;

//[--------------------------Prototipos de Funciones-----------------------]//

// Procedimiento de control del automata
int Automata ( char NomArch[ ],
               char Palabra[ ],
               int (*)( char Palabra[ ],
                        int nEstado,
                        int TipEst,
                        char p ),
               int Eco );

// Procedimientos de Creacion de Estructuras del AFD
int ConstruirAFD ( tAFD *AFD );
void AgregarNodoError ( tAFD AFD );
void BorrarAFD ( tAFD *AFD );

// Funciones de Manejo del AFD
tAutFDet TransicionSgte ( int nEstado , tAutFDet AFD );
int VerificaPalabra ( tAFD AFD,
                      char Palabra[ ],
                      int (*)( char Palabra[ ],
                               int nEstado,
                               int TipEst,
                               char p ),
                      int Eco );

// Procedimiento de Visualizacion de Estructuras del AFD
void TablaDeTrans ( tAFD AFD );

//[-------------------------------Funciones--------------------------------]//

// Procedimiento Automata
//
// Descripcion : Crea, verifica la palabra y destruye el AFD.
//               Devuelve el estado en el que termino el automata.
int Automata ( char NomArch[ ],
               char Palabra[ ],
               int (*FuncionNodo)( char Palabra[ ],
                                   int nEstado,
                                   int TipEst,
                                   char p ),
               int Eco )
{
  // Variables
  tAFD AFD;            // Registro donde se guardan todos los datos del AFD.
  int EstadoAFD;       // Estado del AFD.

  // Comienzo
  strcpy ( AFD.NomArch,NomArch );
  if ( ( EstadoAFD = ConstruirAFD ( &AFD ) ) == NORMAL ) {
    // Si no hubo errores al crear el AFD, se procede a verificar la palabra
    EstadoAFD = VerificaPalabra ( AFD,Palabra,FuncionNodo,Eco );
    BorrarAFD ( &AFD );
  }
  return EstadoAFD;
}

// Funcion ConstruirAFD
//
// Descripcion : Construye el AFD a partir de los datos leidos del
//               archivo .AFD. Devuelve 0 si salio todo bien. Si no,
//               devuelve un numero especificado en las constantes
//               de error definifas en la cabecera de este archivo.
int ConstruirAFD ( tAFD *AFD )
{
  // Archivos
  FILE *fAfd;            // Puntero al archivo .AFD

  // Variables Dinamicas
  tAutFDet NodoAFD,      // Puntero para los estados principales
           AFD_Fin;      // Puntero para el armado del AFD - Tipo Cola
  tPtrTrans NodoTrans;   // Puntero para las transiciones
  char *p;               // Puntero para recorrer AFD.Alfabeto

  // Variables Estaticas
  int nFuncTrans,        // Funcion de transicion para el caracter en curso
      nCantCar,          // Cantidad de caracteres del alfabeto
      Caracter;          // Caracter leido del archivo .AFD
  int i;                 // Variable para manejo de ciclos

  // Comienzo
  (*AFD).AFD = NULL;  // Inicializa las estructuras

  // Abre el archivo .AFD y lee los datos del AFD desde el mismo
  fAfd = fopen ( (*AFD).NomArch,"r+" );
  if ( fAfd == NULL )
    return ERR_ARCHIVO; // Hubo un problema abriendo el archivo
  else {
    // El archivo fue abierto con exito
    // Lee la cantidad de estados
    fread ( &(*AFD).nCantEst,sizeof ( int ),1,fAfd );
    // Lee la cantidad de caracteres
    fread ( &nCantCar,sizeof ( int ),1,fAfd );
    // Lee los caracteres
    p = (*AFD).Alfabeto;
    for ( i = 0 ; i < nCantCar ; ++i ) {
      fread ( &Caracter,sizeof ( int ),1,fAfd );
      *p = Caracter;
      p++;
    }
    *p = '\0'; // Cierra la cadena
  }

  // Armado del AFD
  for ( i = 0 ; i <= (*AFD).nCantEst - 1 ; ++i ) {
    NodoAFD = ( tAutFDet ) malloc ( sizeof ( struct _TipoAutFDet ) );
    NodoAFD->nEstado = i;
    fread ( &NodoAFD->TipEst,sizeof ( int ),1,fAfd );
    NodoAFD->LisTrans = NULL;
    NodoAFD->Sgte = NULL;

    p = (*AFD).Alfabeto;  // recorre todos los caracteres del alfabeto
    for ( ; *p ; ++p ) {
      fread ( &nFuncTrans,sizeof ( int ),1,fAfd );
      if ( nFuncTrans != FNULA ) { // La funcion leida no es la nula ( -2 )
        NodoTrans = ( tPtrTrans ) malloc ( sizeof ( struct _TipoPtrTrans ) );
        NodoTrans->cCarTrans = *p;
        NodoTrans->nEstado = nFuncTrans;
        // Inserta tipo pila
        NodoTrans->Sgte = NodoAFD->LisTrans;
        NodoAFD->LisTrans = NodoTrans;
        }
    }
    // Trata al AFD como pila para un manejo mas facil y rapido
    if ( (*AFD).AFD == NULL )
      (*AFD).AFD = NodoAFD;
    else
      AFD_Fin->Sgte = NodoAFD;
    AFD_Fin = NodoAFD;
  }
  // El nodo error es adonde va el AFD cuando entra un caracter invalido
  AgregarNodoError ( *AFD );
  fclose ( fAfd );
  return NORMAL;  // Salida normal. Sin errores.
}

// Procedimiento ConstruirNodoError
//
// Descripcion : Construye y coloca al final de AFD el NodoError, que es
//               adende va el AFD cuando entra un caracter invalido
void AgregarNodoError ( tAFD AFD )
{
  // Variables Dinamicas
  tAutFDet  PtrError;  // Puntero para la creacion del Nodo Error
  tPtrTrans PtrTrans;  // Transiciones del nodo error
  char *p;             // Puntero para recorrer AFD.Alfabeto

  // Comienzo
  PtrError = ( tAutFDet ) malloc ( sizeof ( struct _TipoAutFDet ) );
  PtrError->nEstado = NODO_ERR;
  PtrError->TipEst = ERROR;
  PtrError->LisTrans = NULL;
  PtrError->Sgte = NULL;
  p = AFD.Alfabeto;
  // Se indica a los caracteres que ciclen dentro del nodo error
  for ( ; *p ; p++  ) {
    PtrTrans = ( tPtrTrans ) malloc ( sizeof ( struct _TipoPtrTrans ) );
    PtrTrans->cCarTrans = *p;
    PtrTrans->nEstado = NODO_ERR;
    PtrTrans->Sgte = NULL;
    // Se engancha con el anterior tipo pila
    PtrTrans->Sgte = PtrError->LisTrans;
    PtrError->LisTrans = PtrTrans;
  };
  // Se coloca el Nodo Error al final del automata.
  while ( AFD.AFD->Sgte != NULL )
    AFD.AFD = AFD.AFD->Sgte;
  AFD.AFD->Sgte = PtrError;
}

// Funcion TransicionSgte
//
// Descripcion : Busca en AFD el estado nEstado y devuelve un puntero a el.
tAutFDet TransicionSgte ( int nEstado , tAutFDet AFD )
{
  // Comienzo
  while ( nEstado != AFD->nEstado )
    AFD = AFD->Sgte;
  return AFD;
}

// Procedimiento BorrarAutomata
//
// Descripcion : Recorre el automata nodo por nodo y libera la memoria
//               utilizada por los mismos
void BorrarAFD ( tAFD *AFD )
{
  // Variables Dinamicas
  tAutFDet  PtrAFDAux;
  tPtrTrans PtrTransAux;

  // Comienzo
  while ( (*AFD).AFD != NULL ) {
    while ( (*AFD).AFD->LisTrans != NULL ) {
      PtrTransAux = (*AFD).AFD->LisTrans;
      (*AFD).AFD->LisTrans = (*AFD).AFD->LisTrans->Sgte;
      free ( PtrTransAux );
    }
    PtrAFDAux = (*AFD).AFD;
    (*AFD).AFD = (*AFD).AFD->Sgte;
    free ( PtrAFDAux );
  }
}

// Funcion VerfifcaPalabra
//
// Descripcion : Verifica si una palabra ingresada dentro del proc es valida
//               en el AFD. Devuelve el estado final del automata.
int VerificaPalabra ( tAFD AFD,
                      char Palabra[ ],
                      int (*FuncionDeNodo)( char Alfabeto[],
                                            int nEstado,
                                            int TipEst,
                                            char p ),
                      int Eco )
{
  // Variables Dinamicas
  tAutFDet  PtrAFD;    // Puntero para recorrer el automata
  tPtrTrans PtrTrans;  // Puntero para recorrer la sublista
  char *p;             // Puntero para recorrer Palabra[ ]

  // Variables Estaticas
  int Estado = 0;      // Estado de la funcion FuncionDeEstado

  // Comienzo
  if ( Eco ) {  // Con salida en pantalla
    TablaDeTrans ( AFD );
    printf ( "Palabra a verificar : %s\n\n",Palabra );
  }
  // Estado actual
  PtrAFD = AFD.AFD;
  // Recorrido caracter por caracter
  p = Palabra;
  for ( ; *p ; ++p ) {
    // Ejecuta la FuncionDeNodo
    if ( *FuncionDeNodo )
      (*FuncionDeNodo)( Palabra,PtrAFD->nEstado,PtrAFD->TipEst,*p );
    // Busca el caracter *p en ese estado actual
    // ( dentro de la sublista del nodo actual PtrAFD )
    PtrTrans = PtrAFD->LisTrans;
    while ( ( PtrTrans != NULL ) && ( PtrTrans->cCarTrans != *p ) )
      PtrTrans = PtrTrans->Sgte;
    if ( PtrTrans != NULL )
      // Si encontro el caracter, que siga al siguiente estado
      PtrAFD = TransicionSgte ( PtrTrans->nEstado,AFD.AFD );
    else
      // Si no encontro el caracter => hay error, ir al estado error ( -1 )
      PtrAFD = TransicionSgte ( NODO_ERR,AFD.AFD );
  }
  // Procesa el ultimo nodo. Envia la se¤al de termino de la palabra '\0'
  if ( *FuncionDeNodo )
    Estado = (*FuncionDeNodo)( Palabra,PtrAFD->nEstado,PtrAFD->TipEst,'\0' );
  if ( Eco ) {
    printf ( "\nEl nodo final fue : %d\n",PtrAFD->nEstado );
    printf ( "El tipo de estado en el que termino la palabra es :\n" );
    switch ( PtrAFD->TipEst ) {
      case INICIAL  : printf ( "( Inicial ) => No Pertenece al Lenguaje"    ); break;
      case TRANS    : printf ( "( Transici¢n ) => No Pertenece al Lenguaje" ); break;
      case FINAL    : printf ( "( Final ) => Pertenece al Lenguaje"         ); break;
      case INIC_FIN : printf ( "( Inicial/Final ) => Pertenece al Lenguaje" ); break;
      case ERROR    : printf ( "( Error ) => No Pertenece al Lenguaje"      ); break;
    }
    printf ( "\n\n" );
  }
  // Devuelve un posible error en FuncionDeNodo
  if ( Estado )
    return Estado;
  else
    return PtrAFD->TipEst;
}

// Procedimiento TablaDeTrans
//
// Descripcion : Imprime en pantalla la tabla de transiciones del automata
void TablaDeTrans ( tAFD AFD )
{
  // Variables Dinamicas
  tPtrTrans PtrTrans;    // Puntero para recorrer las transiciones
  char *p;               // Puntero para recorrer AFD.Alfabeto

  // Variables Estaticas
  int i;

  // Comienzo
  puts ( "Tabla de Transiciones\n" );
  // Imprime los caracteres
  printf ( "   " );
  p = AFD.Alfabeto;
  for ( ; *p ; ++p ) {
    printf ( "%c ",*p );
  }
  // imprime los estados y las funciones de c/caracter
  for ( i = 0 ; i <= AFD.nCantEst - 1 ; ++i ) {
    printf ( "\n%d",AFD.AFD->nEstado );
    switch ( AFD.AFD->TipEst ) {
      case INICIAL  : printf ( "- " ); break;
      case TRANS    : printf ( "  " ); break;
      case FINAL    : printf ( "+ " ); break;
      case INIC_FIN : printf ( "= " ); break;
    }
    p = AFD.Alfabeto;
    for ( ; *p ; ++p ) {
      PtrTrans = AFD.AFD->LisTrans;
      // Busca para verificar si el caracter p tiene funcion
      while ( ( PtrTrans != NULL ) && ( PtrTrans->cCarTrans != *p ) )
        PtrTrans = PtrTrans->Sgte;
      if ( PtrTrans == NULL )
        printf ( "- " ); // No tiene
      else
        printf ( "%d ",PtrTrans->nEstado ); // Tiene
    }
    AFD.AFD = AFD.AFD->Sgte;
  }
  printf ( "\n\n" );
}
