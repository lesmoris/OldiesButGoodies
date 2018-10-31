/*
  JUGADOR.H
  Funciones para el manejo del puntaje del jugador en curso

  16/06/03
  Esmoris Leonardo
*/

#define ptosPILL       10
#define ptosSUPERPILL 100

class tJugador {
  public :
    tJugador ( );
    void IncPuntaje ( int cant );
    void MostrarScore ( );
  private :
    int Puntaje;
};

tJugador :: tJugador ( ) {
  Puntaje = 0;
}

void tJugador :: IncPuntaje ( int cant ) {
  Puntaje += cant;
}

void tJugador :: MostrarScore ( void ) {
  gotoxy ( 35,1 );
  printf ( "Puntos: %d",Puntaje );
}