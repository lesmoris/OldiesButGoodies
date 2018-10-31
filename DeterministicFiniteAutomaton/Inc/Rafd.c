// Archivo RAFD.C
//
// Esmoris Leonardo                            leonardo_esmoris@yahoo.com.ar
//
// Descripcion : Este modulo permite leer archivos .AFD y visualizar la
//               tabla de transiciones del automata.
#include <stdio.h>
#include <conio.h>

//[-----------------------Prototipos de Funciones--------------------------]//
int LeerArchivoAFD ( char NomArch[ ] );

//[-------------------------------Funciones-------------------------------]]//
int LeerArchivoAFD ( char NomArch[ ] ) {
  // Variables
  FILE *fAfd;
  int nCantEst = 0,
      nCantCar = 0,
      Caracter = 0,
      TipEst   = 0,
      Funcion  = 0;
  int i;
  int j;
  char s [ 255 ];
  char *p;

  // Comienzo
  if ( ( fAfd = fopen ( NomArch,"r+" ) ) == NULL ) {
    printf ( "Error al abrir el archivo %s",NomArch );
    return -1;
  }

  // Lee la cantidad de estados
  fread ( &nCantEst,sizeof ( nCantEst ),1,fAfd );

  // Lee la cantidad de caracteres
  fread ( &nCantCar,sizeof ( nCantCar ),1,fAfd );

  // Lee los caracteres
  for ( i = 0 ; i < nCantCar ; ++i ) {
    fread ( &Caracter,sizeof ( Caracter ),1,fAfd );
    s[i] = Caracter;
  }
  s[i] = '\0';
  printf ( "Tabla de Transiciones del automata del archivo %s:\n\n     ",NomArch );

  // Lee el tipo de los estados y sus funciones de transicion
  p = s;
  for ( ; *p ; p++ ) {
    printf ( "%c ",*p );
  }
  for ( i = 0 , j = 0; i < nCantEst*nCantCar ; i = i + nCantCar , j++ ) {
    fread ( &TipEst ,sizeof ( TipEst ),1,fAfd );
    printf ( "\n%2d",j );
    switch ( TipEst ) {
      case 0 : { printf ( "-  " ); break; }
      case 1 : { printf ( "   " ); break; }
      case 2 : { printf ( "+  " ); break; }
      case 3 : { printf ( "=  " ); break; }
    }
    p = s;
    for ( ; *p ; ++p ) {
      fread ( &Funcion ,sizeof ( Funcion ),1,fAfd );
      if ( Funcion == -2 )
        printf ( "- " );
      else
        printf ( "%d ",Funcion );
    }
  }
  puts ( "\n" );
  fclose ( fAfd );
  return 0;
}
