#include <stdio.h>
#include "inc\afd.c"
#include "inc\exp.c"

void main ( int argc, char *argv[ ] )
{
  // Variables
  float res;

  // Comienzo
  clrscr ( );
  textmode ( C80 );

  if ( argc > 1 ) {
    if ( Automata ( "exp.afd",argv[ 1 ],NULL,SIN_ECO ) == FINAL ) {
      res = CalcularExpresion ( argv [ 1 ] );
      printf ( "\nEl resultado es : %f\n\n",res );
    }
    else
      puts ( "Error en la expresion" );
  }
  else {
    puts ( "Tenes que poner la expresion a analizar\n" );
    puts ( "Ejemplo : " );
    puts ( "exp \"((a+b)*c)/d\"\n " );
  }
  getche ( );
}
