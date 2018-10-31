Program Esmonoid_2;
{---------------------------Declaracion de UNIDADES--------------------------}
Uses
  Bg,       {Contiene los fondos de todo el juego}
  Button,   {Contiene rutinas para las opciones con botones}
  Crt,
  Capsules, {Contiene rutinas para el manejo de las capsulas}
  DSP,      {Contiene rutinas para el manejo de la Sound Blaster}
  E2_menu,  {Contiene las opciones del menu inicial}
  E2_Pres,  {Contiene la presentacion del juego}
  Fade,     {Contiene rutinas de apagado y prendido de pantalla}
  Highscr,  {Contiene rutinas para el manejo de los high scores}
  Levels,   {Contiene rutinas para la lectura e inicializacion de los niveles}
  Palette,  {Contiene rutinas de inicializacion de la paleta de colores}
  Pics,     {Contiene los todos los elementos del juego y los inicializa}
  Sprites,  {Contiene rutinas para el manejo de sprites exclusivos del Esmo2}
  UMB_Heap, {Contiene rutinas para la ampliacion del stack usando el HMA}
  Xlib2,    {Contiene todas las rutinas graficas usadas en el Esmo2}
  Xbm2;     {Contiene todas las rutinas de creacion de bitmaps del juego}
Type
  E2_Nivel = Object
         Numero : Word;
         Completo : Boolean;
         Procedure Inicio_del_Nivel;
       end;
Var
  E2 : E2_Nivel;

Procedure E2_Nivel.Inicio_Del_Nivel;
var
  Aux1,Aux2,X,Y,Largo,Alto : Integer;
begin
  Load_Levels;
  Draw_BackGround;
  Y := 13; Alto := 1;
  Repeat
    X := 1; Largo := 1;
    Repeat
      If Nivel[Numero,Alto,Largo][1] = '1' then begin
        Val (Nivel[Numero,Alto,Largo][4],Aux1,Aux2);
        If Nivel[Numero,Alto,Largo][3] = '3' then XPutCBitmap (X,Y,0,Ladrillo[8])
        else XPutCBitmap (X,Y,0,Ladrillo[Aux1])
        end;
      Inc (X,16); Inc (Largo);
    Until Largo = 16;
    Inc (Y,8); Inc (Alto);
  Until Alto > 10;
end;

Begin
  XSetMode (0,360);
  PaletteInit;
  E2.Inicio_del_Nivel;
  readkey;
  XTextMode;
End.