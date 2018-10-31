// Sintaxis y Semantica del Lenguaje
//
// Implementacion de un reconocedor de expresiones aritmeticas
//
// Alumno : Esmoris Leonardo
// Legajo : 111794-4
//

#include <stdio.h>
#include <string.h>
#include <conio.h>

//------------------------------------------------Estructuras-----------------------------------------------//

struct _TipoExp {
  struct _TipoLisExp  *LisExp;   // Punteros para la lista de la expresion gral
  struct _TipoPilaExp *PilaExp;  // Puntero para la pila
  struct _TipoLisVar  *LisVar;   // Lista de valores de las variables de la expresion
  char Expresion[ 255 ];
  int Nivel;
} TipoExp;

// Estructuras Dinamicas

// Estructura TipoLisExp
//
// Descripcion : Guarda cada nodo de la expresion que luego seran parte del arbol
//
// Nivel    : Indica el nivel de "profundidad"
// Caracter : Indica el caracter. Puede ser una variable ( a,b,c,... ) o un operador ( *,+,-,/ )
// SubLis   : Puntero a otra LisExp con nivel Nivel+1;
// Izq      : Uso posterior en la construccion del arbol;
// Der      : Uso inicial, es Sgte. Despues, Der para la construccion del arbol;
struct _TipoLisExp {
  int Nivel;
  char Caracter;
  float Valor;
  struct _TipoLisExp *SubLis,*Izq,*Der;
} TipoLisExp;

// Estructura TipoPilaExp
struct _TipoPilaExp {
  struct _TipoLisExp *PtrLisExp;
  struct _TipoPilaExp *Sgte;
} TipoPilaExp;

// Estructura TipoLisVar
struct _TipoLisVar {
  char Caracter;
  float Valor;
  struct _TipoLisVar *Sgte;
} TipoLisVar;

typedef struct _TipoExp tExp;
typedef struct _TipoLisExp  *TLisExp;
typedef struct _TipoPilaExp *TPilaExp;
typedef struct _TipoLisVar  *TLisVar;

//-----------------------------------------Prototipos De Funciones------------------------------------------//

// Funcion principal
float CalcularExpresion ( char exp[ ] );

// Funciones de control y armado de la expresion
void CreaExpresion ( tExp *Exp );

// Funciones de resolucion de la expresion
float ResolverExpresion ( tExp Exp );
void  ObtenerValores ( tExp Exp );
float CalcularParentesis ( tExp Exp, int *Div0 );
float Valor ( TLisVar LisVar, char Caracter );
float Operar ( float op1, float op2, char op, int *Div0 );

// Funciones de manejo de estructuras dinamicas
void Meter ( TPilaExp *PilaExp, TLisExp NodoExp );
void Sacar ( TPilaExp *PilaExp, TLisExp *PtrExp );
void InsertaNodoVar ( TLisVar *LisVar, char p );

//--------------------------------------------------------------------------//
float CalcularExpresion ( char exp[ ] ) {
  // Variables
  tExp Exp;        // Contiene toda la info acerca de la expresion analizada
  int Estado = 0;  // Estado en el que termino el constructor de expresiones

  // Comienzo
  strcat ( exp,")" );            // Agrega un parentesis al comienzo y al
  strcpy ( Exp.Expresion,"(" );  // final para un mejor manejo interno
  strcat ( Exp.Expresion,exp );
  puts ( Exp.Expresion );
  CreaExpresion ( &Exp );
  ObtenerValores ( Exp );
  return ResolverExpresion ( Exp );
}

void CreaExpresion ( tExp *Exp ) {
  // Variables Dinamicas
  TLisExp PtrExp  = NULL,   // Puntero para el manejo de la expresion general
          NodoExp = NULL;

  // Variables Estaticas
  char *p;
  int ExisteNodo = 0;

  // Comienzo
  (*Exp).Nivel = 1;
  (*Exp).LisExp = NULL;
  (*Exp).PilaExp = NULL;
  (*Exp).LisVar = NULL;
  p = (*Exp).Expresion;

  for ( ; *p ; p++ )
  {
    if ( *p == '(' )
    {
      if ( ExisteNodo == 0 )
        NodoExp = ( TLisExp ) malloc ( sizeof ( TipoLisExp ) );
      NodoExp->Caracter = *p;
      NodoExp->Valor = 0.0;
      NodoExp->Nivel = (*Exp).Nivel;
      NodoExp->SubLis = NodoExp->Izq = NodoExp->Der = NULL;
      if ( PtrExp != NULL )
      {
        PtrExp->Der = NodoExp;
        NodoExp->Izq = PtrExp;
      }
      PtrExp = NodoExp;
      PtrExp->Der = NULL;
      if ( (*Exp).LisExp == NULL )
        (*Exp).LisExp = NodoExp;
      Meter ( &(*Exp).PilaExp,NodoExp );
      NodoExp = ( TLisExp ) malloc ( sizeof ( TipoLisExp ) );
      PtrExp->SubLis = NodoExp;
      PtrExp = NodoExp;
      (*Exp).Nivel++;
      ExisteNodo = 1;
    }

    else if ( *p == ')' )
    {
      Sacar ( &(*Exp).PilaExp,&PtrExp );
      (*Exp).Nivel--;
    }

    else if ( ( *p >= 'a' && *p <= 'z' ) ||
              ( *p == '*' || *p == '+' || *p == '-' || *p == '/' ) )
    {
      if ( *p >= 'a' && *p <= 'z' )
        InsertaNodoVar ( &(*Exp).LisVar,*p );
      if ( ExisteNodo == 0 )
        NodoExp = ( TLisExp ) malloc ( sizeof ( TipoLisExp ) );
      NodoExp->Caracter = *p;
      NodoExp->Nivel = (*Exp).Nivel;
      NodoExp->SubLis = NodoExp->Izq = NodoExp->Der = NULL;
      if ( ExisteNodo == 0 )
      {
        if ( PtrExp != NULL )
        {
          PtrExp->Der = NodoExp;
          NodoExp->Izq = PtrExp;
        }
        PtrExp = NodoExp;
      }
      else
        ExisteNodo = 0;
      if ( (*Exp).LisExp == NULL )
        (*Exp).LisExp = NodoExp;
    }
  }
}

float ResolverExpresion ( tExp Exp )
{
  // Variables
  TPilaExp PilaExp = NULL;
  TLisExp LisExpAux,PtrAux;
  int i,Div0 = 0;
  float res,op[2];
  char operacion;

  // Comienzo
  LisExpAux = Exp.LisExp;
  while ( Exp.LisExp != NULL )
  {
    if ( Exp.LisExp->SubLis )
    {
      Meter ( &PilaExp,Exp.LisExp );
      Exp.LisExp = Exp.LisExp->SubLis;
    }
    else if ( Exp.LisExp->Der != NULL )
      Exp.LisExp = Exp.LisExp->Der;
    else {
      while ( !Exp.LisExp->Der && Exp.LisExp->Nivel > 1 )
      {
        Sacar ( &PilaExp,&Exp.LisExp );
        Exp.LisExp->Valor = CalcularParentesis ( Exp,&Div0 );
      }
      Exp.LisExp = Exp.LisExp->Der;
    }
  }
  return LisExpAux->Valor;
}

//--------------------------------------------------------------------------//
void ObtenerValores ( tExp Exp )
{
  while ( Exp.LisVar )
  {
    printf ( "Ingrese el valor de la variable %c: ",Exp.LisVar->Caracter );
    scanf ( "%f",&Exp.LisVar->Valor );
    Exp.LisVar = Exp.LisVar->Sgte;
  }
}

float CalcularParentesis ( tExp Exp, int *Div0 )
{
  TLisExp PtrAux;
  int i;
  float res,op[2];
  char operacion;

  if ( Exp.LisExp->SubLis->Der != NULL )
  {
     for ( i = 0 ; i <= 2 ; i++ )
     {
        if ( i % 2 == 0 ) {
           if ( Exp.LisExp->SubLis->Caracter == '(' )
              op[ i ] = Exp.LisExp->SubLis->Valor;
           else
              op[ i ] = Valor ( Exp.LisVar,Exp.LisExp->SubLis->Caracter );
        }
        else
        {
           operacion = Exp.LisExp->SubLis->Caracter;
           PtrAux = Exp.LisExp->SubLis;
        }
        PtrAux = Exp.LisExp->SubLis;
        Exp.LisExp->SubLis = Exp.LisExp->SubLis->Der;
        free ( PtrAux );
     }
     res = Operar ( op[0],op[2],operacion,Div0 );
     return res;
  }
  else
  {
     if ( Exp.LisExp->SubLis->Caracter == '(' )
       Exp.LisExp->Valor = Exp.LisExp->SubLis->Valor;
     else
       Exp.LisExp->Valor = Valor ( Exp.LisVar,Exp.LisExp->SubLis->Caracter );
     free ( Exp.LisExp->SubLis );
     return Exp.LisExp->Valor;
  }
}

float Valor ( TLisVar LisVar, char Caracter )
{
  while ( Caracter != LisVar->Caracter )
    LisVar = LisVar->Sgte;
  return LisVar->Valor;
}

float Operar ( float op1, float op2, char op, int *Div0 )
{
  int i;
  float res;

  switch ( op ) {
    case '+' : return op1+op2;
    case '-' : return op1-op2;
    case '*' : return op1*op2;
    case '^' : { res = op1;
                 for ( i = 1 ; i < op2 ; i++ )
                   res = res * op1;
                 return res;
               }
    case '/' : if ( op2 != 0 )
                 return op1/op2;
               else
                 *Div0 = 1;
  }
}

//--------------------------------------------------------------------------//
void Meter ( TPilaExp *PilaExp, TLisExp PtrExp )
{
  // Variables
  TPilaExp NodoPilaExp;

  // Comienzo
  NodoPilaExp = ( TPilaExp ) malloc ( sizeof ( struct _TipoPilaExp ) );
  NodoPilaExp->PtrLisExp = PtrExp;
  NodoPilaExp->Sgte = *PilaExp;
  *PilaExp = NodoPilaExp;
}

void Sacar ( TPilaExp *PilaExp, TLisExp *PtrExp )
{
  // Variables
  TPilaExp NodoPilaExp;

  // Comienzo
  NodoPilaExp = *PilaExp;
  *PilaExp = (*PilaExp)->Sgte;
  *PtrExp = NodoPilaExp->PtrLisExp;
  free ( NodoPilaExp );
}

void InsertaNodoVar ( TLisVar *LisVar, char p )
{
  // Variables
  TLisVar NodoLisVar,PtrAux;

  // Comienzo
  NodoLisVar = ( TLisVar ) malloc ( sizeof ( TipoLisVar ) );
  NodoLisVar->Caracter = p;
  NodoLisVar->Valor = 0.0;
  NodoLisVar->Sgte = NULL;
  if ( *LisVar == NULL || NodoLisVar->Caracter < (*LisVar)->Caracter )
  {
    NodoLisVar->Sgte = *LisVar;
    *LisVar = NodoLisVar;
  }
  else
  {
    PtrAux = *LisVar;
    while ( PtrAux->Sgte && PtrAux->Sgte->Caracter <= NodoLisVar->Caracter )
      PtrAux = PtrAux->Sgte;
    if ( PtrAux->Caracter != NodoLisVar->Caracter )
    {
      NodoLisVar->Sgte = PtrAux->Sgte;
      PtrAux->Sgte = NodoLisVar;
    }
  }
}
