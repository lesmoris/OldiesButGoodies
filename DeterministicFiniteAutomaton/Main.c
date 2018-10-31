//[----------------------------PROJECTO AUTOMATA---------------------------]//
//
// Implementacion de un automata finito deterministico (AFD) a traves de su
// tabla de transiciones por medio de archivos .AFD
//
// Alumno : Esmoris, Leonardo Gabriel
// Legajo : 111794-4
//
// Historia : El programa lo cree inicialmente en Linux. Llevaba, tambien,
//            paralelamente una version en DOS bajo el Borland C Builder 5.5.
//            Pero como el programa requeria demasiados cambios para andar
//            en DOS y por problemas ( que no pude resolver, nunca entendi
//            el porque del error... ) de compatibilidad de los archivos .AFD
//            ( mas info ver el archivo WAFD.C ) me decidi pasarlo
//            definitivamente a DOS bajo el Borland C++ 3.1. Tambien es
//            compatible con el Turbo C 3.0.
//
#include "inc\menus.c"   // Modulo de manejo de men£s
#include "inc\afd.c"     // Modulo de manejo del AFD
#include "inc\rafd.c"    // Modulo de lectura de archivos .AFD
#include "inc\wafd.c"    // Modulo de creaci¢n de archivos .AFD

//[------------------------Prototipos de Funciones-------------------------]//

int  SeleccionarArchivoAFD ( char NomArch [ ] );
void VerificarPalabraEnAFD ( char NomArch [ ] );
int  FuncionNodo ( char Palabra[ ], int nEstado, int TipEst,char p );

//[--------------------------Programa Principal----------------------------]//
void main ( ) {
  // Variables Estaticas
  char *vec[] = { "Tabla de Transiciones",  // Elementos del menu
                  "Verificar Palabra    ",
                  SEPARADOR,
                  "Seleccionar .AFD     ",
                  "Crear Nuevo .AFD     ",
                  SEPARADOR,
                  "Salir                " };
  int hab[] = { 0,0,0,1,1,0,1 };    // Elementos habilitados del vector vec
  int op = 0;                       // Toma el valor de retorno del menu
  char NomArch[ 21 ];               // Nombre del archivo .AFD

  // Comienzo
  textmode ( C80 );
  while ( op != sizeof ( vec )/2 - 1 ) {
    clrscr ( );
    op = Menu ( vec,hab,sizeof ( vec )/2,1,1 );
    clrscr ( );
    switch ( op ) {
      case 0 : LeerArchivoAFD ( NomArch ); break;
      case 1 : VerificarPalabraEnAFD ( NomArch ); break;
      case 3 : if ( SeleccionarArchivoAFD ( NomArch ) == 1 ) {
                 // Habilita las opciones del menu
                 hab [0] = 1; hab [1] = 1;
               }
               else {
                 // Deshabilita las opciones del menu
                 hab [0] = 0; hab [1] = 0;
               }
               break;
      case 4 : CrearArchivoAFD ( );
      case 6 : puts ( "Programa de manejo de Automatas Finitos Deterministicos\n" );
               puts ( "Por Leonardo Esmoris\nleonardo_esmoris@yahoo.com.ar" );
    }
    getche ( );
  }
}

//[-------------------------------Funciones--------------------------------]//

// Funcion SeleccionarArchivoAFD
//
// Descripcion : Pregunta al usuario por el archivo .AFD a procesar por el
//               programa. Devuelve -1 su hubo error.
int SeleccionarArchivoAFD ( char NomArch [ ] ) {
  // Archivo
  FILE *fAFD;

  // Comienzo
  printf ( "Ingrese el nombre del archivo .AFD : " );
  scanf ( "%s",NomArch );
  if ( ( fAFD = fopen ( NomArch,"r" ) ) == NULL ) {
    puts ( "El archivo no existe" );
    fclose ( fAFD );
    return 0;
  }
  else {
    puts ( "El archivo fue abierto con exito" );
    fclose ( fAFD );
    return 1;
  }
}

// Procedimiento VerificarPalabraEnAFD
//
// Descripcion : Pregunta al usuario por la palabra a verificar en el
//               automata actual y la verifica. Devuelve el nombre del .AFD
void VerificarPalabraEnAFD ( char NomArch [ ] ) {
  // Variables
  char *Palabra;

  // Comienzo
  printf ( "Ingrese la palabra a verificar : " );
  scanf ( "%s",Palabra );
  switch ( Automata ( NomArch,Palabra,FuncionNodo,CON_ECO ) ) {
    case ERR_ARCHIVO   : printf ( "Error al abrir el archivo %s\n",NomArch );
    case ERR_FUNC_NODO : puts ( "Hubo un error en el proceso" ); break;
  }
}

// Funcion FuncionNodo
//
// Descripcion : Esta funcion se ejecuta cada vez que se pasa a un nuevo
//               nodo. Util para hacer cosas dentro de la verificacion de la
//               palabra. Devuelve un valor que puede servir para indicarle
//               cosas ( x ej : errores ) al programa principal.
int FuncionNodo ( char Palabra[ ], int nEstado, int TipEst,char p ) {
  // Variables
  static parent = 0;

  // Comienzo de la seccion de comportamiento del AFD
  return 0;

}

