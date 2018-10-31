{
Alg£n d¡a de alg£n mes del a¤o de 1998

Ultima Actualizacion 12/01/2001 (Paso mucho tiempo, no?)

Este es mi primer proyecto groso. El proximo va a ser un Tetris pero
en Clipper. Espero que este te guste!
La mayoria de las unidades la hice yo exeptuando:

XLIB 2.0  Tristan Tarrant - tristant@cogs.susx.ac.uk  (Ojala las hubiese
XBM 2.0   Tristan Tarrant - tristant@cogs.susx.ac.uk        hecho yo!!!)
UMB_Heap  No se quien la hizo, pero gracias!!!

La informacion para hacer la unidad DSP.PAS y PALETTE.PAS
la saque de un CD de una revista que no me acuerdo cual era. Cuando
lo sepa lo voy a poner ac .

Por favor, si vas a usar algo de este juego para hacer uno tuyo, aunque sea
nombrame y haceme sentir importante, como hice yo con los que crearon las
3 librerias antes nombradas.
Otra cosa, si vas a modificarlo hacelo ORDENADAMENTE y pone comentarios A TODO.
Pensa que despues de 2 a¤os de no haberlo tocado, hasta a mi me resulto
dificil entender algunas cosas (otras ni las entiendo (la mayoria) ;-) )

Si te preguntas porque este es el EsmoNOID 2 y no el 1 (que nunca aparecio)
es que el 1 era muy precario, estaba hecho con el modo grafico basico de
Pascal y era muy lento. La unica vez que lo vieron fue cuando lo lleve el a¤o
pasado al colegio (el ilustre "E.T. 37 Hogar Naval Stella Maris") pero la
profesora de laboratorio (Perra!!) me lo hizo sacar porque no queria juegos
en su hora.

Ojala que te diviertas jugando tanto como yo al hacerlo.

Aguanten los Redondos y Boca.
(Actualizacion) y tambien AC/DC!!!

Agradecimientos:

A Adrian por hacer la presentacion, que aunque la haya cambiado para
hacerla andar en esta nueva version, el espritu es el de la misma.
(Que presentacion te mandaste, pap !)

A Charly por ayudarme un poco cuando hice el EsmoNOID 1 (en realidad no
hiciste casi nada, boton)

Si entendes algo del programa, por favor ponele comentarios!!!!!!!!
NOTA : La presentacion esta desactivada por defecto porque es un poco larga
y puede resultar molesta despues de un rato. Activala si queres verla
poneindo en el menu OPTION / COMPILER / CONDTIONAL DEFINES la palabra PRES.
Si en ese mismo lugar tambien pones ALTCAPS vas a ver una diferencia en la
capsula de puntos normal del juego.

Quedar¡a:

PRES;ALTCAPS

Acordate de separarlos entre punto y coma. Acordate despues de re-compilar
el programa porque si no no te va a andar la presentacion.
}

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
  Xlib2,    {Contiene todas las rutinas graficas usadas en el Esmo2}
  Xbm2;     {Contiene todas las rutinas de creacion de bitmaps del juego}


{---------------------------Declaracion de CONSTANTES------------------------}
Const
  {
  Esto indica los valores a tener en cuenta para utilizar cada sonido
  ubicado en E2_Snds.Dat :

  Sonido 1_Comienzo = 00003; Sonido 1_Tama¤o   = 16000;
  Sonido 2_Comienzo = 18000; Sonido 2_Tama¤o   = 22000;
  Sonido 3_Comienzo = 41000; Sonido 3_Tama¤o   = 10000;
  Sonido 4_Comienzo = 53000; Sonido 4_Tama¤o   = 14500;
  Sonido 5_Comienzo = 00003; Sonido 5_Tama¤o   = 14500;
  Sonido 6_Comienzo = 15000; Sonido 6_Tama¤o   = 2000;

  Ten‚ en cuenta que si les cambias la frecuencia al utilizarlos van a sonar
  diferente, dando la impresion de ser varios sonidos distintos.
  Mas info en DSP.PAS (DSP = Digital Signal Procesing)

  }
  Level    : Word = 1;  {Indica el nivel inicial del Esmo2 (del 1 al 10}
  BaseAddr = 2;         {Indica la direccion base de la SB}
  Right    = 241;       {Estos son los limites impuestos a la pelota}
  Left     = 1;
  Up       = 1;
  Down     = 200;
  MaxRebCount = 30;     {Es la cant de veces que puede rebotar la pelota antes de aumentar de velocidad}

{---------------------------Declaracion de VARIABLES-------------------------}
Var
  Sound         : Array [1..6] of VOCSound;  {Contiene los sonidos que deben pemanecer cargados si o si en memoria}
  Level_Completed,    {Indica si se ha terminado el nivel o no}
  Main_Exit,          {Indica la salida por preder una vida,pasar de nivel o presionar ESC}
  Capsule_Speed,      {Indica la velocidad de la capsula}
  FlagX,              {Indican la direccion de la pelota}
  FlagY         : Boolean;
  Terminator,
  RebCounter,         {Indica la cantidad de veces que la pelotita rebota contra la pared}
  MovBall,
  Speed,              {Indica la velocidad por defecto}
  Lives,              {Indica las vidas actuales}
  NoBall,
  NoCapsule,                 {Indica el frame de la capsula actual}
  ArX,                       {Indica la posicion del arkanoid}
  X,Y           : Integer;   {Indica la posicion de la pelota}
  Score         : Word;      {Indica los puntos actuales}
  FileMissing   : String;    {Indica el archivo faltante necesario para jugar al Esmo2}
  Font_1,Font_2 : Pointer;   {Contienen la letras contenidas en el archivo E2_Font.Dat}


{------------------------Seccion de procedimientos VARIOS--------------------}

Procedure ExitGame (ExitCode : Byte);  {termina el juego dando el mensaje indicado por ExitCode}
Var
  I : Byte;
Begin
  If InGraphics = 1 then begin  {Detecta si esta en modo grafico}
    Fade_Out (10);
    ClearDevice;
    Fade_In (0);
  end;
  If Main_Sound then begin      {Descarga los sonidos de la memoria}
    For I := 1 to 6 do
     If Sound[I].S <> 0 then Begin
      UnloadVOC (Sound[I]);
{      SpeakerOff;                 {Apaga la SB}
      end;
    end;
  XTextMode;                    {Pone el modo texto}
  Case ExitCode of
    0 : Writeln ('Gracias por jugar al Esmonoid 2 !!!!!!!');
    1 : Writeln ('Necesit s una tarjeta VGA para jugar.');
    2 : Writeln ('Necesit s un mouse para jugar.');
    3 : Writeln ('Falta el archivo ',FileMissing);
  end;
  While Keypressed do Readkey;
  Hs_Done;                      {Salva los high scores}
  Halt;
End;

Procedure PlaySound(No:byte; Frecuencia:Word);  {Ejecuta el sonido indicado por No con la frequencia Frecuencia}
begin
  If Main_Sound=True then begin
    If Frecuencia > 0 then
      Sound[No].Freq := Frecuencia
    else
      Sound[No].Freq := 10989;     {Frecuencia por defecto}
    Playback (Sound[No]);
    end;
end;

Procedure Show_Lives; {Muestra la cant vidas actuales en este momento}
Var
  X : Integer;
  S : String;
Begin
  Str (Lives,S);
  X := 238 + ((80 - XTextWidth(S,4)) div 2);
  XCpVidRect (X,59,X+XTextWidth(S,4)+7,67, X,59, Page1Offs,0, 360,360);
  XPrintF (X+1,59,0,118,S);
  XPrintF (X,60,0,127,S);
End;

Procedure Increase_Score (Cant : byte);  {Incrementa los puntos en la cant establecida por cant}
Var
  X : Integer;
  S : String;
Begin
  Inc (Score,Cant);
  Str (Score,S);
  X := 238 + ((80 - XTextWidth(S,4)) div 2);
  XCpVidRect (X,29,X+XTextWidth(S,4)+7,37, X,29, Page1Offs,0, 360,360);
  XPrintF (X+1,29,0,118,S);
  XPrintF (X,30,0,127,S);
  If (Score mod 10000 = 0) and (Score<>0) then begin  {Especifica si se ha alcanzado el puntaje para una vida}
    Inc (lives);
    Show_Lives;
  end;
End;

Procedure Input_Name;  {Permite el ingreso del nombre si este alcanzo un lugar en los high scores}
var  Nombre : string;
begin
  If Hs_CheckScore (score) then begin
    Up_Button (3,100,238,130,'');
    Down_Button (6,113,235,127,'');
    XPrintf (60,102,0,223,'Capo!!! Pone tu nombre:');
    XHideMouse;
    Input (8,117,Nombre,25);
    If Nombre = '                         ' then
      Nombre := 'Salame';
    Hs_NewScore (Nombre,Score);
  end;
end;

{------------Seccion de Procedimientos concernientes a la pelota-------------}

Procedure BrickExist;  {Verifica si por donde pasa la pelota existe un ladrillo}
Var
  Izquierdo,
  Derecho   : Boolean;
  Un_X,Un_Y,
  I,J,
  DirY,DirX : Integer;
  aux : string;
Procedure Activate_Capsule (X,Y : Integer);  {Activa la capsula indicando su inicio en X,Y}
Var
  K  : 1..10;
  L  : Integer;
Begin
  If Capsule_Status = True then Exit;  {Si ya hay una capsula entonces sale, no dibuja 2 al mismo tiempo}
  Capsule_Status := True;
  Val (Nivel[Level,I,J] [5],K,L);    {Detecta el tipo de capsula a mostrar}
  NoCapsule := K;
  Cap_Pos.X := Un_X+2;               {Especifica los puntos de inicio de la capsula}
  Cap_Pos.Y := Un_Y;
End;
Function Y_Entre (Y1,Y2 : Integer) : Boolean;  {Detecta si Y esta entre [Y1,Y2]}
Begin
  If (Y+DirY >= Y1) and (Y+DirY <= Y2) then Y_Entre := True
  else Y_Entre := False;
End;
Function X_Entre (X1,X2 : Integer) : Boolean;  {Detecta si X esta entre [X1,X2]}
Begin
  If (X+DirX >= X1) and (X+DirX <= X2) then X_Entre := True
  else X_Entre := False;
End;
Begin
  If FlagX then DirX := 4
  else DirX := -1;
  If FlagY then DirY := 4
  else DirY := -1;
  If Y_Entre (13,52) then
    repeat
      If Y_Entre (13,20) then begin Un_Y := 13; I := 1;  Break; end;
      If Y_Entre (21,28) then begin Un_Y := 21; I := 2;  Break; end;
      If Y_Entre (29,36) then begin Un_Y := 29; I := 3;  Break; end;
      If Y_Entre (37,44) then begin Un_Y := 37; I := 4;  Break; end;
      If Y_Entre (45,52) then begin Un_Y := 45; I := 5;  Break; end
      else exit;
    until 1=0
  else
    repeat
      If Y_Entre (53,60) then begin Un_Y := 53; I := 6;  Break; end;
      If Y_Entre (61,68) then begin Un_Y := 61; I := 7;  Break; end;
      If Y_Entre (69,76) then begin Un_Y := 69; I := 8;  Break; end;
      If Y_Entre (77,84) then begin Un_Y := 77; I := 9;  Break; end;
      If Y_Entre (85,92) then begin Un_Y := 85; I := 10; Break; end
      else exit;
    until 1=0;
  If X_Entre (1,112) then
    repeat
      If X_Entre (1,16)    then begin Un_X := 1;   J := 1;  Break; end;
      If X_Entre (17,32)   then begin Un_X := 17;  J := 2;  Break; end;
      If X_Entre (33,48)   then begin Un_X := 33;  J := 3;  Break; end;
      If X_Entre (49,64)   then begin Un_X := 49;  J := 4;  Break; end;
      If X_Entre (65,80)   then begin Un_X := 65;  J := 5;  Break; end;
      If X_Entre (81,96)   then begin Un_X := 81;  J := 6;  Break; end;
      If X_Entre (97,112)  then begin Un_X := 97;  J := 7;  Break; end
      else exit;
    until 1=0
  else
    repeat
      If X_Entre (113,128) then begin Un_X := 113; J := 8;  Break; end;
      If X_Entre (129,144) then begin Un_X := 129; J := 9;  Break; end;
      If X_Entre (145,160) then begin Un_X := 145; J := 10; Break; end;
      If X_Entre (161,176) then begin Un_X := 161; J := 11; Break; end;
      If X_Entre (177,192) then begin Un_X := 177; J := 12; Break; end;
      If X_Entre (193,208) then begin Un_X := 193; J := 13; Break; end;
      If X_Entre (209,224) then begin Un_X := 209; J := 14; Break; end;
      If X_Entre (225,240) then begin Un_X := 225; J := 15; Break; end
      else exit;
    until 1=0;
  If Nivel[Level,I,J][1] = '1' then begin    {Detecta si el ladrillo es rompible}
    If Nivel[Level,I,J][3] = '1' then begin  {Detecta cuantas veces le falta pegarle para que desaparezca}
      If Nivel[Level,I,J][2] = '1' then Activate_Capsule(I,J); {detecta si el ladrillo posee alguna capsula}
      XCpVidRect (Un_X,Un_Y,Un_X+16,Un_Y+8, Un_X,Un_Y, NonVisualOffs,0, 360,360);
      XCpVidRect (Un_X,Un_Y,Un_X+16,Un_Y+8, Un_X,Un_Y, NonVisualOffs,Page1Offs, 360,360);
      Increase_Score (100);
{      PlaySound(1,15873);}
      PlaySound(1,22222);
      Nivel[level,I,J][1] := '0';
      Dec (BrickCounter);
{      str (brickCounter,aux);
      XBgCentre (250,100,0,1,223,aux);}
      end
    else
      If Nivel[Level,I,J][3] = '2' then begin  {El ladrillo debe tocarse 2 veces}
        Nivel[Level,I,J][3] := '1';            {se disminuye la cant de veces a 1}
        PlaySound(1,22222);
        end
      Else begin     {Si no, el ladrillo es irrompible}
         Case Random(3)+1 of
          1 : PlaySound (4,22222);
          2 : PlaySound (4,20000);
          3 : PlaySound (4,24000);
         end;
       end;
    If BrickCounter = 0 then begin  {detecta si se han terminado todos los ladrillos en el nivel}
      Play_and_UnloadVOC ('DATA\E2_SNDS.SND',3004,10752);
      Main_Exit := True;
      Inc(Level);
      Level_Completed := true;
      Exit;
      end;
    {Detecta si se ha pegado del lado izquierdo o derecho del ladrillo}
  If Terminator = 0 then Begin
    Izquierdo := (X+DirX = Un_X)    and ((Y+DirY >= Un_Y) and (Y+DirY <= Un_Y+8));
    Derecho   := (X+DirX = Un_X+15) and ((Y+DirY >= Un_Y) and (Y+DirY <= Un_Y+8));
    If FlagY = true then begin
      Inc (RebCounter);
      If FlagX and (Izquierdo) then
        FlagX := Not FlagX
      else
      If (FlagX=False) and (Derecho) then
        FlagX := Not FlagX
      else
        FlagY := False;
      exit;
      end
    else
    If FlagY = False then begin
      Inc (RebCounter);
      If FlagX and (Izquierdo) then
        FlagX := Not FlagX
      else
      If (FlagX=False) and (Derecho) then
        FlagX := Not FlagX
      else
        FlagY := True;
      exit;
      end;
    end;
  End;
  If RebCounter = MaxRebCount then begin
    If Speed > 3 then
      Dec (Speed);
    RebCounter := 1;
    end;

End;

Procedure NewXY (VAR x,y : Integer);  {Da un nuevo valor a X,Y de la pelota}
Begin
  If (X+2 >= ArX-4) and (X+2 <= ArX+32) and (Y+2 = 185) then begin {Detecta si la pelota cae dentro del arkanoid}
    MovBall := 1;
    If (X+2 >= ArX-2)  and (X+2 <= ArX+7)  then begin
      FlagX := False;
      MovBall := 2;
      end;
    If (X+2 >= ArX+21) and (X+2 <= ArX+30) then begin
      FlagX := True;
      MovBall := 2;
      end;

    FlagY := False;
    PlaySound(5,22222);
    end;

  If FlagX = True Then
    If X+4 < Right Then Inc(x,MovBall)
    Else begin
      FlagX := FALSE;
{      PlaySound(1,22222);}
      end
  else
    If X+0 > Left Then Dec(x,MovBall)
    Else begin
      FlagX := TRUE;
{      PlaySound(1,22222);}
      end;

  If FlagY = True Then begin
    Inc(y);
   	If Y = Down Then begin
      PlaySound (2,22222);
      Dec (Lives); Main_Exit := True;
      Exit; end;
    end
	Else
   	If Y+0 > Up Then
      Dec(y)
    Else begin
      FlagY := TRUE;
      PlaySound(1,65535);
      end;

End;

{------------------------------Seccion GAME INIT-----------------------------}

Procedure GameInit;   {Inicia el juego en su totalidad}
Procedure Initial_Checking;  {Checkea la existencia de los archivos y requerimientos necesarios del sistema}
Begin
{  Extend_Heap; }
  If Not XModeSupport ($13) then ExitGame (1);
  If Not XMouseExists then ExitGame (2);
  If Not XExists ('DATA\E2_FONT.DAT',FileMissing) then ExitGame (3);
  If Not XExists ('DATA\LEVELS.DAT',FileMissing) then ExitGame (3);
  If Not XExists ('DATA\E2_SNDS.SND',FileMissing) then ExitGame (3);
  If Not XExists ('DATA\E2_SNDS2.SND',FileMissing) then ExitGame (3);
  If Not XExists ('DATA\E2_SNDS3.SND',FileMissing) then ExitGame (3);
  IF (ParamStr(1) = '-NOSOUND') or Not (ResetDSP (BaseAddr)) then;
    Main_Sound := False;
  Hs_Init (10,'DATA\E2_High.Scr',0);
{  Hs_Clear; }  {Esto es para vaciar el Highscore}
End;
Procedure SoundInit;  {Inicia los sonidos si existe una SB y si esta bien puesta la Direccion Base en la var BassAddr}
Begin
  If Main_Sound = True then begin
    LoadVOC ('DATA\E2_SNDS2.SND',00003,16000,Sound[1]);
    LoadVOC ('DATA\E2_SNDS2.SND',18000,22000,Sound[2]);
    LoadVOC ('DATA\E2_SNDS2.SND',41000,10000,Sound[3]);
    LoadVOC ('DATA\E2_SNDS2.SND',53000,14500,Sound[4]);
    LoadVOC ('DATA\E2_SNDS3.SND',00003,14500,Sound[5]);
    LoadVOC ('DATA\E2_SNDS.SND ',15000,02000,Sound[6]);
  end;
End;
Procedure TextInit;  {Lee las letras e inicia el texto}
Begin
  InstallFont ('DATA\E2_Font.Dat',20,988,Font_1);
  InstallFont ('DATA\E2_Font.Dat',988,1247,Font_2);
  XTextInit;
End;
Procedure MouseInit;  {inicia del mouse,velocidad,tipo,rango}
Const
  E2_Mouse  : array [0..13] of byte =
      (3,1,0,119,017,115,065,119,000,117,087,085,085,117);
Begin
  XMouseInit;
  XDefineSpeed (20,100);
  XMouseWindow (2,2,310,180);
  XDefineMouseCursor (E2_Mouse,223);
End;
Begin
  Initial_Checking;
  SoundInit;
  XSetMode (0,360);
  PaletteInit;
  Initcol;
{  ShowPalette;
  Readkey;}
  Presentacion;
  TextInit;
  MouseInit;
End;

{---------------------------------Seccion MENU-------------------------------}

Procedure Menu;  {Inicia el menu inicial del juego}
Procedure Game_Menu;  {Incia los botones y los mustra en pantalla}
Const
  E2_Mouse  : array [1..2] of Array [0..13] of byte = (
      (3,1,0,119,017,115,065,119,000,117,087,085,085,117),
      (3,1,0,117,087,087,085,117,000,050,082,082,082,050) );
  {pensa esto en binario, no en decimal}
Var
  Buttons : Arr_Buttons;
  CursorType,
  MouseCounter : Word;
  Ant_Opcion,
  Opcion  : Byte;
Begin
  MouseFrozen := 0;
  Fade_Out (0);
  Bg_Draw (0);
  XRegisterUserFont (Font_2^);
  XSetFont (2);
  XCentre (160,1,0,223,'EsmoNOID 2');
  XRegisterUserFont (Font_1^);
  XSetFont (2);
  Opcion := 0;
  MouseColor := 223;
  Init_Buttons (130,50,190,61,'Jugar',1,Buttons);
  Init_Buttons (130,63,190,74,'Opciones',2,Buttons);
  Init_Buttons (130,76,190,87,'PassWord',3,Buttons);
  Init_Buttons (130,89,190,100,'Hi Scores',4,Buttons);
  Init_Buttons (130,102,190,113,'Salir',5,Buttons);
  Show_Buttons (Buttons);
  Fade_in (10);
  CursorType := 1;
  repeat
    repeat
      If MouseCounter = 65535 then
        If CursorType = 1 then
          CursorType := 2
        else
          CursorType := 1;
      Inc (MouseCounter);
      XDefineMouseCursor (E2_Mouse[CursorType],223);
      Check_Buttons (Buttons,Opcion);
    until (opcion > 0);
{    PlaySound (3,11050);}
    Case Opcion of
      1 : begin XHideMouse; MouseFrozen := 1; Fade_out (10); ClearPage(0); Exit; end;
      2 : Change_Options (Lives);
      3 : Read_Password (Level);
      4 : Show_Scores;
      5 : ExitGame (0);
    end;
    Ant_Opcion := Opcion;
      Opcion := 0;
  until opcion > 0;
End;
Procedure GlobalVarsInit;  {Inicia las variables globales al inicio del juego}
Begin
  Level_Completed := True;
  Lives := 3;
  Speed := 6;
  Score := 0;
  Terminator := 0;
  noBall := 1;
End;
begin
  XPositionMouse (160,70);
  Game_Menu;
  XSetDoubleBuffer (200);
  Fade_Out (0);
  GameSpritesInit;
  GlobalVarsInit;
  Load_Levels;
end;

{---------------------------------Seccion MAIN-------------------------------}

Procedure Main;  {Comienza el juego en si}
Procedure LevelInit;  {Inicia c/nivel}
Var
  T1,T2,
  I,J,
  X,Y : Integer;
  Aux : String[4];
Begin
  Draw_BackGround;
  Y := 13; I := 1;
  Repeat
    X := 1; J := 1;
    Repeat
      Aux := Nivel[Level,I,J];
      If Aux[1] = '1' then begin
        Val (Aux[4],T1,T2);
        If Aux[3] <> '1' then
          If Aux[3] = '3' then XPutCBitmap (X,Y,0,Ladrillo[ { Random(2) + 8 } 8 ])
          else begin If Aux[3] = '2' then XPutCBitmap (X,Y,0,Ladrillo[ { Random(2) + 8 } 9 ]) end
        else XPutCBitmap (X,Y,0,Ladrillo[T1])
        end;
      Inc (X,16); Inc (J);
    Until J = 16;
    Inc (Y,8); Inc (I);
  Until I > 10;
  Fade_in (5);
  Initial_Count (Level);
End;
Procedure InitLevelVars;  {Incia las variables que tendran lugar en c/nivel}
Begin
  Main_Exit := False;
  Capsule_Status := False;
  FlagX := True;
  FlagY := False;
  XCpVidRect (0,0,242,100, 0,0, 0,Page1Offs, 360,360);
  Show_Lives;
  Increase_Score (0);
  Arx := MouseX;
  X := ArX+12;
  Y := 184;
  XPositionMouse (110,187);
  Speed := 8;
  Terminator := 0;
  noBall := 1;
  RebCounter := 1;
  MovBall := 1;
End;
Procedure DrawInicialSprites;  {Muestra los sprites inciales del juego}
Begin
  XDrawSprite (X,Y,Ball[noBall]);
  XDrawSprite (110,187,Arkanoid);
End;
Procedure Begining;    {Permite el movimiento y previa indicacion de hacia donde se dirigira la pelota}
Begin
  XMouseWindow (1,1,Right-Ark_Width,185);
  Repeat
    If Keypressed then readkey;
    If MouseButtonStatus = RightPressed then begin
      FlagX := Not FlagX;
      MouseButtonStatus := 0;
      PlaySound(1,22222);
      end;
    If ArX <> MouseX then Begin
      XUnDrawArk (ArX,187);
      XUnDrawBall (ArX+12,183,Ball[noBall].Visible);
      ArX := MouseX;
      XDrawSprite (ArX,187,Arkanoid);
      XDrawSprite (ArX+12,184,Ball[noBall]);
      X := ArX+12;
      end;
    Until MouseButtonStatus = LeftPressed;
end;
Procedure Draw_Capsules (Var X,Y : Integer);  {Dibuja la capsula activa en ese momento}
Procedure Deactivate_Capsule (X,Y : Integer); {desactiva la capsula cuando es agarrado o llega al limite de la pantalla}
Begin
  Capsule_Status := false;
  XUnDrawCapsule (X,Y,1);
  NoCapsule := 1;
End;
Begin
  If ((X in [ArX..ArX+Ark_Width+1]) or
     (X+12 in [ArX..ArX+Ark_Width-1]))
     and (Y = 182) then begin
{       PlaySound (6,11500);
       {Estos son los efectos de agarrar una capsula}
       Case NoCapsule of
         1 : Increase_Score (100);                   {Capsula P (roja) }
         2 : Begin Inc(Lives); Show_Lives; End;      {Capsula L (azul) }
         3 : Inc(Speed,2);                           {Capsula O (verde)}
         4 : Begin Terminator := 1; noBall := 2 End; {Capsula T (negra)}
       end;
       Deactivate_Capsule (X,182);
     end;
  If Y < 194 then begin
    If Capsule_Speed = true then begin
      XUnDrawCapsule (X,Y,1);
      Inc (Y);
      XDrawCapsule (X,Y,Capsule[NoCapsule]);
      If Y mod 7 = 0 then
        XNextCapsule (Capsule[NoCapsule]);
    end;
    Capsule_Speed := Not Capsule_Speed;
  end
  else
    Deactivate_Capsule (X,Y);
End;
Procedure KeyRead;   {Identifica las teclas con funciones especiales en el juego}
Begin
  If (MouseButtonStatus = RightPressed) Then
    FlagX := Not FlagX
  Else begin
    Case Upcase(Readkey) of
      #27 : begin Main_Exit := True; Lives := -1; end;
      'P' : repeat until Upcase(Readkey) = 'P';
      'S' : If ParamStr (1) <> '-NOSOUND' then Main_Sound := NOT Main_Sound;
      #32 : FlagX := Not FlagX;
    end;
  end;
End;

{Borra los sprites que quedaron en pantalla despues de terminar el nivel,perder todas las vidas o salir del juego}
Procedure UnDrawSprites;
Begin
  XUnDrawArk (ArX,187);
  XUnDrawBall (X,Y,Ball[noBall].Visible);
  If Capsule_Status then
    XUnDrawCapsule (Cap_Pos.X,Cap_Pos.Y,1);
End;
Begin
  If Level_Completed then LevelInit;
  InitLevelVars;
  DrawInicialSprites;
  Level_Completed := False;
  Begining;
  Repeat
    XUnDrawBall (X,Y,Ball[noBall].Visible);
    If Capsule_Status then Draw_Capsules (Cap_Pos.X,Cap_Pos.Y);
    If Y in [5..95] then BrickExist;
    NewXY (X,Y);
    XDrawSprite (X,Y,Ball[noBall]);
    Delay (Speed);
    If (Keypressed) or (MouseButtonStatus = RightPressed) then KeyRead;
    If ArX <> MouseX then Begin
      XUnDrawArk (ArX,187);
      ArX := MouseX;
      XDrawSprite (ArX,187,Arkanoid);
      end;
  Until Main_Exit;
  UndrawSprites;
End;

{--------------------------Seccion Programa Principal------------------------}

Begin
  GameInit;
  Repeat
    Menu;
    Repeat
      Main;
      If Lives = -1 then break;
      If (Main_Exit) then
        If (Level_Completed) and (Level <= Last_Level) then Fade_Out (10);
    Until (Lives < 0) or (Level > Last_Level);
    Level := 1;
    Input_Name;
    Fade_out (10);
    ClearPage (VisiblePageOffs); ClearPage (NonVisualOffs); ClearPage (Page1Offs);
  until 1=0;
End.