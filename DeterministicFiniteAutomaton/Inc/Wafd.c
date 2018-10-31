// Archivo WAFD.C
//
// Esmoris Leonardo                           leonardo_esmoris@yahoo.com.ar
//
// Descripcion : Programa que crea archivos .AFD
//
// Estructura de un archivo .AFD :
//
// Nombre del Campo          | NombreDeVariable | Cantidad |Tama¤o |Tipo
// --------------------------+------------------+----------+-------+----
// Cantidad de estados       |     nCantEst     |        1 | 2byte | int
// Cantidad de caracteres    |     nCantCar     |        1 | 2byte | int
// Caracter del alfabeto     |     Caracter     |        1 | 2byte | int
// Tipo de estado            |      nTipEst     |        1 | 2byte | int
// Funciones de cada caracter|      Funcion     | nCantEst | 2byte | int
//
// Los dos ultimos campos se repiten para cada estado
//
// NOTA IMPORTANTE : Los tama¤os dependen muchisimo del compilador. Por
//                   ejemplo, este programa compilado dentro de Linux,
//                   da un tama¤o de 4 bytes a los int, y con el
//                   Borland C Builder 5.5 pasa algo similar. O sea, los
//                   archivos creados en Linux NO ANDAN en Dos. CUIDADO!!.
#include <stdio.h>
#include <conio.h>
#include <string.h>
#include <ctype.h>

//[-------------------------Prototipos De Funciones------------------------]//
void CrearArchivoAFD ( void );

//[--------------------------------Funciones-------------------------------]//
void CrearArchivoAFD ( void ) {

  // Archivos
  FILE *fAfd;

  // Variables Estaticas
  int nCantEst,
      nCantCar,
      nTipEst,
      Caracter,
      Funcion,
      i;
  char *p,
       *Alfabeto,
       *NomArch;

  // Comienzo
  printf ( "\nIngrese el nombre del archivo .AFD : " );
  scanf ( "%s",NomArch );

  strcat ( NomArch,".afd" );
  fAfd = fopen ( NomArch,"r" );
  if ( fAfd != NULL ) {
    printf ( "El archivo %s ya existe.\n\n",NomArch );
    printf ( "Desea sobreescribirlo?(S/N): " );
    do {
      Caracter = toupper ( getche () );
    } while ( Caracter != 'S' && Caracter != 'N' );
    if ( Caracter == 'N' )
      return;
  }

  fAfd = fopen ( NomArch,"w+" );
  if ( fAfd == NULL ) {
    printf ( "Hubo un error al intentar crear el archivo %s.\n\n",NomArch );
    return;
  }

  printf ( "\nIngrese la cantidad de estados : " );
  scanf ( "%d",&nCantEst );
  printf ( "\nIngrese los caracteres : " );
  scanf ( "%s",Alfabeto );
  nCantCar = strlen ( Alfabeto );

  // Datos de cantidad de estados y cant de caracteres
  fwrite ( &nCantEst,sizeof ( nCantEst ),1,fAfd );
  fwrite ( &nCantCar,sizeof ( nCantCar ),1,fAfd );

  // Datos de caracteres del lenguaje
  p = Alfabeto;
  for ( ; *p ; p++ ) {
    Caracter = *p;
    fwrite ( &Caracter,sizeof ( Caracter ),1,fAfd );
  }

  // Datos de las funciones de cada caracter
  for ( i = 0 ; i < nCantEst ; i++ ) {
    printf ( "\nEstado Actual : %d",i );
    printf ( "\nTipo de Estado? ( 0-Inicial ; 1-De Transicion ; 2-Final ; 3-Incial/Final ) : " );
    scanf ( "%d",&nTipEst );
    // Graba en el .ADF la informacion de cada estado y su funcion
    fwrite ( &nTipEst ,sizeof ( nTipEst ),1,fAfd );
    p = Alfabeto;
    for ( ; *p ; p++ ) {
      printf ( "Funcion en %c : ",*p );
      scanf ( "%d",&Funcion );
      fwrite ( &Funcion ,sizeof ( Funcion ),1,fAfd );
    }
  }

  fclose ( fAfd );
  printf ( "El archivo %s fue creado con exito!\n",NomArch );
}
