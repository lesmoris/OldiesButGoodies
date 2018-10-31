// itos.h
//
// Convierte un entero largo en un string. La funcion no testea que el entero ingresado este
// dentro del rango de los enteros.

void itos ( long int i , char s[] );
int hmdig ( long int i );

void itos ( long int i , char s[] ) {
  char *p;
  int m;

  p = &s[ hmdig ( i ) ];   // Obtiene y se posiciona en la ultima posicion de la cadena
  *p = '\0';               // Cierra la cadena
  if ( i == 0 ) {
    p--;
    *p = 48;
  }
  else
  while ( i > 0 ) {        // Mientras el entero tengo digitos
    --p;                   // Retrocede un caracter en la cadena
    m = i % 10;            // Obtiene el ultimo digito del entero
    *p = 48+m;             // Lo convierta a char y lo graba en la posicion actual de la cadena
    i = i / 10;            // Borra el ultimo digito
  }
//  p = NULL;                // Inutiliza el puntero que rrecorrio la cadena para evitar errores
}

int hmdig ( long int i ) {
  int c = 0;

  if ( i == 0 )
    c++;
  else
    while ( i > 0 ) {        // Mientras el entero tenga digitos
      i = i / 10;            // Borra el ultimo digito
      c++;                   // Cuenta el ultimo digito borrado
    }
  return c;                // Devuelve la cantidad de digitos
}

