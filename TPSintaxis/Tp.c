/* TP1.C

   "Reconoce la sentencia FOR del lenguaje C"
   
   04/06/2003
   Esmoris Leonardo
   Leg n 111794-4
*/

#include <stdio.h>
#include <conio.h>
#include <string.h>
#include <process.h>

#define ESTADOS 31
#define EST_ERR ESTADOS
#define EST_FIN 30
#define CARACTERES 256

//[-----------------------------Prototipos-----------------------------------]

char *BorraEspacios ( char Cad1[] );
int Reconoce ( int mat[][CARACTERES],char *Palabra );
void CargaMatriz ( int mat[][CARACTERES] );
void InicializaMatriz ( int mat[][CARACTERES] );
void LlenaLet ( int mat[][CARACTERES],int Nodo,int NodoSgte );
void LlenaNum ( int mat[][CARACTERES],int Nodo,int NodoSgte );
void ComVar ( int mat[][CARACTERES],int Nodo,int NodoSgte );
void CueVar ( int mat[][CARACTERES],int Nodo,int NodoSgte );
void LlenaAscii ( int mat[][CARACTERES],int Nodo,int NodoSgte );

//[-------------------------Programa Principal-------------------------------]
void main ( int argc, char *argv[] ) {
  // Variables
  FILE *h;
  int mat [ESTADOS+1][CARACTERES];
  char *Palabra;

  // Comienzo
  clrscr ( );
  if ( argc < 3 ) {
  	puts ( "Error en la linea de comandos." );
  	puts ( "Uso : Verifica <sentencia a verficar> <archivo.txt> ");
    getch ( );
	  exit ( 0 );
  }
	    
  strcpy ( Palabra,argv[1] );
  Palabra = BorraEspacios ( Palabra );

  CargaMatriz ( mat );
  if ( ( h = fopen ( argv[2],"ab" ) ) == NULL ) {
    printf ( "Error al abrir el archivo %s\n",argv[2] );
    getch ( );
    exit ( 0 );
  }

  if ( Reconoce ( mat,Palabra ) == 1 ) {
	  puts ( "La palabra pertenece al lenguaje" );
	  fputs ( "La palabra pertenece al lenguaje\n",h );
  }
  else {
	  puts ( "La palabra no pertenece al lenguaje" );
	  fputs ( "La palabra no pertenece al lenguaje\n",h );
  }
  fclose ( h );
  getch ( );
}

//[------------------------------Funciones-----------------------------------]

void CargaMatriz ( int mat[][CARACTERES] ) {
  // Comienzo
  InicializaMatriz ( mat ); 
  mat[0]['f'] = 1;
  mat[1]['o'] = 2;
  mat[2]['r'] = 3;
  mat[3]['('] = 4;
  
  ComVar ( mat,4,5 );

  CueVar ( mat,5,5 );
  mat[5]['='] = 6;
  
  mat[6]['\''] = 7;
  LlenaNum ( mat,6,11 );

  LlenaAscii ( mat,7,9 );
  mat[7]['\\'] = 8;

  mat[8]['\\'] = 9;
  mat[8]['\?'] = 9;
  mat[8]['\"'] = 9;
  mat[8]['\''] = 9;

  mat[9]['\''] = 10;
  
  mat[10][';'] = 12;
  mat[10][','] = 4;

  LlenaNum ( mat,11,11 );
  mat[11][';'] = 12;
  mat[11][','] = 4;

  ComVar ( mat,12,13 );
  
  CueVar ( mat,13,13 );
  mat[13]['<'] = 14;
  mat[13]['>'] = 14;  
  mat[13]['='] = 16;
  mat[13]['!'] = 16;  

  mat[14]['='] = 15;
  mat[14]['\''] = 17;
  ComVar ( mat,14,20 );
  LlenaNum ( mat,14,21 );

  mat[15]['\''] = 17;
  ComVar ( mat,15,20 );
  LlenaNum ( mat,15,21 );

  mat[16]['='] = 15;

  LlenaAscii ( mat,17,19 );  
  mat[17]['\\'] = 18;

  mat[18]['\\'] = 19;
  mat[18]['\?'] = 19;
  mat[18]['\"'] = 19;
  mat[18]['\''] = 19;

  mat[19]['\''] = 22;
  
  CueVar ( mat,20,20 );
  mat[20]['&'] = 23;
  mat[20]['|'] = 24;
  mat[20][';'] = 25;
  
  LlenaNum ( mat,21,21 );
  mat[21]['&'] = 23;
  mat[21]['|'] = 24;
  mat[21][';'] = 25;

  mat[22]['&'] = 23;
  mat[22]['|'] = 24;
  mat[22][';'] = 25;

  mat[23]['&'] = 12; 

  mat[24]['|'] = 12;

  ComVar ( mat,25,26 );
  
  CueVar ( mat,26,26 );
  mat[26]['+'] = 27;
  mat[26]['-'] = 28;

  mat[27]['+'] = 29;
  mat[28]['-'] = 29;

  mat[29][','] = 25;
  mat[29][')'] = 30;

}

char *BorraEspacios ( char Cad1[] ) {
  // Variables
  char *p,*s;
  
  // Comienzo
  p = Cad1;
  s = Cad1;
  for ( ; *p ; p++ )
    if ( *p != 32 ) {
      *s = *p;
      s++;
    }
  *s = '\0';

  return Cad1;
}

int Reconoce ( int mat[][CARACTERES],char Palabra[] ) {
  // Variables
  int Nodo = 0;
  char *p;

  // Comienzo
  p = Palabra;
  for ( ; *p ; p++ ) {
    Nodo = mat[Nodo][*p];
  }

  if ( Nodo == EST_FIN )
    return 1;
  else
    return 0;
}

void InicializaMatriz ( int mat[][CARACTERES] ) {
  // Variables
  int i,j;

  // Comienzo
  for ( i = 0 ; i < ESTADOS+1 ; i++ )
    for ( j = 0 ; j < CARACTERES ; j++ )
      mat[i][j] = EST_ERR;
}

void CueVar ( int mat[][CARACTERES],int Nodo,int NodoSgte ) {
  // Comienzo
  LlenaLet ( mat,Nodo,NodoSgte );
  LlenaNum ( mat,Nodo,NodoSgte );
  mat[Nodo]['_'] = NodoSgte;
}

void ComVar ( int mat[][CARACTERES],int Nodo,int NodoSgte ) {
  // Comienzo
  LlenaLet ( mat,Nodo,NodoSgte );
  mat[Nodo]['_'] = NodoSgte;
}

void LlenaLet ( int mat[][CARACTERES],int Nodo,int NodoSgte ) {
  // Variables
  char i;

  // Comienzo
  for ( i = 'a' ; i <= 'z' ; i++ ) {
    mat[Nodo][i] = NodoSgte;
    mat[Nodo][i+('A'-'a')] = NodoSgte;
  }
}

void LlenaNum ( int mat[][CARACTERES],int Nodo,int NodoSgte ) {
  // Variables
  char i;
  
  // Comienzo
  for ( i = '0' ; i <= '9' ; i++ )
    mat[Nodo][i] = NodoSgte;
}

void LlenaAscii ( int mat[][CARACTERES],int Nodo,int NodoSgte ) {
  // Variables
  int i;
  
  // Comienzo
  for ( i = 0 ; i < 256 ; i++ )
    mat[Nodo][i] = NodoSgte;
}
