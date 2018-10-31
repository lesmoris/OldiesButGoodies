Unit Modulo4;
Interface

Procedure ABMSolins;
Procedure ABMCorrela;

Implementation
Uses
  Menu,Crt;

{////////////////////////////////////////////////////////////////////////////}
{////////////////////// INICIO PROCEDIMIENTO ABMSolins //////////////////////}
{////////////////////////////////////////////////////////////////////////////}
PROCEDURE ABMSolins;
TYPE
    tVecAlt = ARRAY[0..2] OF WORD;
    tRegSol = Record
               leg: LONGINT;
               dig: BYTE;
               vAlt: tVecAlt;
              END;
    tArchSol = File Of tRegSol;
    tVecSol = ARRAY[0..100] OF tRegSol;
Const
  iOp = 4;
  aMenuSolins  : aChoiceArray = ('Altas         ',
  {Opciones del menu}            'Bajas         ',
                                 'Modificaciones',
                                 'Salir         ','','','','','','','');
VAR
   aSol: tArchSol;
   rSol: tRegSol;
   vEntrada: tVecSol;
   max100: BYTE;
   salir,opcionmal: BOOLEAN;
   abm: Integer;

 {//////////////INICIO SUBPROCEDIMIENTOS y FUNCIONES DE ABMSolins/////////////////////}

 {INICIO FUNCION BUSCAREG: Busca un registro en un archivo por una clave que está
 ordenada, en este caso el legajo, y por otra que no lo está, en este caso la primer
 alternativa de curso. Además, certifica que el dígito verificador concuerde con el
 legajo especificado}
 FUNCTION BuscaReg(LYD:longint;CURSO:WORD;VAR arch: tArchSol):LONGINT;
  VAR
     leg,P,F,PM,POS,POS2: LONGINT;
     CambioLeg, ENCONTRE: BOOLEAN;
     rArch: tRegSol;
     dig:BYTE;
  BEGIN
    leg := LYD DIV 10;
    dig := LYD-(leg*10);
    P:=0;
    F:=FILESIZE(arch)-1;
    POS := -1;
    BuscaReg := -1;
    WHILE (POS = -1) AND (P <= F) DO
      BEGIN
       PM := (P+F) DIV 2;
       SEEK(arch,PM);
       READ(arch,rArch);
       IF (leg = rArch.leg) AND (dig = rArch.dig)
         THEN 
          POS:=PM
         ELSE
          IF leg > rArch.leg
            THEN
             P:=PM+1
            ELSE
             F:=PM-1;
      END;
    
    IF POS <> -1
      THEN
       BEGIN
        CambioLeg := FALSE;
        ENCONTRE := FALSE;
        POS2 := POS;
        WHILE NOT CambioLeg AND NOT ENCONTRE AND (POS2>=0) DO
          BEGIN
           SEEK(arch,POS2);
           READ(arch,rArch);
           IF rArch.vAlt[0] = CURSO THEN ENCONTRE := TRUE;
           IF leg <> rArch.leg THEN CambioLeg := TRUE;
           DEC(POS2);
          END;
        IF ENCONTRE 
          THEN
           BuscaReg := POS2+1
          ELSE
           BEGIN
            CambioLeg := FALSE;
            ENCONTRE := FALSE;
            SEEK(aSol,POS);
            WHILE NOT CambioLeg AND NOT ENCONTRE AND NOT EOF(arch) DO
              BEGIN
              SEEK(arch,POS);
              READ(arch,rArch);
              IF rArch.vAlt[0] = CURSO THEN ENCONTRE := TRUE;
              IF leg <> rArch.leg THEN CambioLeg := TRUE; 
              INC(POS);
              END;
            IF ENCONTRE THEN 
            BuscaReg := POS-1
           END
       END
     ELSE
  END;
 {FIN FUNCION BUSCAREG}
 
 {INICIO FUNCION CTRLCURSO: se le pasa un registro y verifica que la materia de los
 tres cursos elegidos se la misma. Primero encuentra mediante búsqueda binaria el 
 primer curso en el archivo de cursos, y almacena la materia a la que corresponde.
 Luego, también mediante búsquedas binarias encuentra los otros dos cursos y compara 
 sus correspondientes materias contra la que había almacenado, en caso de no existir 
 alguno o que no se correspondan las materias de los primeros dos cursos, la segunda
 y tercera búsquedas binarias no se realizan.}
 FUNCTION ctrlcurso(vec: tRegSol):BOOLEAN;
   TYPE
     tRegCurso = RECORD
                   Curso: WORD;
                   CodigoMateria: LONGINT;
                   Profesor: WORD;
                   Turno: CHAR;
                   Dia1,Dia2: BYTE;
                   Aula:WORD;
                   Anexo: String[10];
                  END;
     tArchCurso = FILE OF tRegCurso;
   VAR
     aCurso:tArchCurso;
     rCurso:tRegCurso;
     PM,P,F,POS:LONGINT;
     materia: Longint;
   BEGIN
     ASSIGN(aCurso,'DAT\curso.dat');
     RESET(aCurso);
     P:=0;
     F:=FILESIZE(aCurso)-1;
     POS:=-1;
     WHILE (POS = -1) AND (P <= F) DO
      BEGIN
       PM := (P+F) DIV 2;
       SEEK(aCurso,PM);
       READ(aCurso,rCurso);
       IF (vec.vAlt[0] = rCurso.curso)
         THEN 
          POS:=PM
         ELSE
          IF vec.vAlt[0] > rCurso.curso
            THEN
             P:=PM+1
            ELSE
             F:=PM-1;
      END;
     IF POS <> -1
      THEN
       BEGIN
        SEEK(aCurso,POS);
        READ(aCurso,rCurso);
        materia := rCurso.CodigoMateria;
        P:=0;
        F:=FILESIZE(aCurso)-1;
        POS := -1;
        WHILE (POS = -1) AND (P <= F) DO
         BEGIN
          PM := (P+F) DIV 2;
          SEEK(aCurso,PM);
          READ(aCurso,rCurso);
          IF (vec.vAlt[1] = rCurso.curso) AND (rCurso.CodigoMateria = materia)
            THEN 
             POS:=PM
            ELSE
             IF vec.vAlt[1] > rCurso.curso
               THEN
                P:=PM+1
               ELSE
                F:=PM-1;
          END;  
        IF POS <> -1
         THEN
          BEGIN
           P:=0;
           F:=FILESIZE(aCurso)-1;
           POS := -1;
           WHILE (POS = -1) AND (P <= F) DO
            BEGIN
             PM := (P+F) DIV 2;
             SEEK(aCurso,PM);
             READ(aCurso,rCurso);
             IF (vec.vAlt[2] = rCurso.curso) AND (rCurso.CodigoMateria = materia)
              THEN 
               POS:=PM
              ELSE
               IF vec.vAlt[2] > rCurso.curso
                 THEN
                  P:=PM+1
                 ELSE
                  F:=PM-1
            END;
           IF POS <> -1 
              THEN ctrlcurso := TRUE
              ELSE ctrlcurso := FALSE;
          END
         ELSE
          ctrlcurso := FALSE;
       END 
      ELSE
        ctrlcurso := FALSE;
 END;
 {FIN FUNCION CTRLCURSO}

 {INICIO PROCEDIMIENTO ALTAS: Realiza las altas en el archivo Solins.dat}
 PROCEDURE Altas(VAR max100:BYTE;VAR aSol: tArchSol);
  VAR
    aTemp: tArchSol;
    rTemp: tRegSol;
    i,j: BYTE;
    salir1,salir2: CHAR;
    legajo,legant: Longint;
    rVec:tRegSol;

  {INICIO SUBPROCEDIMIENTOS Y FUNCIONES DE ALTAS}
  {INICIO PROCEDIMIENTO APAREO}
  PROCEDURE Apareo(vec: tVecSol;VAR arch:tArchSol;ultRegVec:BYTE);
   VAR
    finarch: BOOLEAN;
    reg: tRegSol;
    vApareo: tVecSol;
    i,j: BYTE;

    {INICIO SUBPROCEDIMIENTOS DE Apareo}
    PROCEDURE OrdenaVec(VAR vec:tVecSol;ult:BYTE);
     VAR
       FIN,i: BYTE;
       aux: tRegSol;
     BEGIN
      WHILE ult>1 DO
        BEGIN 
         FIN := ult-1;
         ult := 0;
         FOR i:=1 TO FIN DO
           IF vec[i].leg>vec[i+1].leg THEN
             BEGIN
               aux := vec[i];
               vec[i] := vec[i+1];
               vec[i+1] := aux;
               ult := i;
             END
        END;
     END;
    
    PROCEDURE LeerArch(VAR Arch:tArchSol; VAR Reg:tRegSol; VAR FinArch:Boolean);
     BEGIN
        IF NOT EOF(arch)
            THEN
               BEGIN
              READ(arch,reg);
              finArch := FALSE
             END
            ELSE
               finArch := TRUE
     END;

     FUNCTION PuedoLeerVec(VAR i:BYTE;vec: tVecSol):BOOLEAN;
      BEGIN
        IF i<=100
          THEN
            IF vec[i].leg <> -1 
              THEN
               PuedoLeerVec := TRUE
              ELSE
               PuedoLeerVec := FALSE
          ELSE
            PuedoLeerVec := FALSE;
      END;
   {FIN SUBPROCEDIMIENTOS DE Apareo}
   BEGIN
        OrdenaVec(vec,ultRegVec);
      i := 1;
        j := 1;
      LeerArch(arch,reg,finarch);
        WHILE PuedoLeerVec(i,vec) OR (NOT finarch) DO
          BEGIN
              IF finarch  OR ( PuedoLeerVec(i,vec)  AND
              (vec[i].leg <= reg.leg))
               THEN
                   BEGIN
                    vApareo[j] := vec[i];
                    INC(i);
                   END
               ELSE
                   BEGIN
                    vApareo[j] := reg;
                    LeerArch(arch,reg,finarch)
                   END;
              INC(j);     
        END; 
      CLRSCR;
      CLOSE(arch);
      REWRITE(arch);
      FOR i:=1 TO j-1 DO
            BEGIN
             reg := vApareo[i];
             WRITE(arch,reg);
            END;
   END;
   {FIN PROCEDIMIENTO APAREO}
 {FIN SUBPROCEDIMIENTOS Y FUNCIONES DE ALTAS}

 BEGIN
      salir2:='c';
      legant := 0;
      FOR j:=1 TO 100 DO vEntrada[j].leg := -1;
      j := 1;
      REPEAT
            CLRSCR;
            WRITELN('Ingreso de Datos');
            WRITELN;
            WRITE('INGRESE NUMERO DE LEGAJO (Formato: NNNNND): '); READLN(legajo);
            WRITE('Alternativa 1: '); READLN(vEntrada[j].vAlt[0]);
            WRITE('Alternativa 2: '); READLN(vEntrada[j].vAlt[1]);
            WRITE('Alternativa 3: '); READLN(vEntrada[j].vAlt[2]);
            IF legajo=legant
               THEN
                   INC(i)
               ELSE
                   BEGIN
                    legant := legajo;
                    i := 1
                   END;
            rVec := vEntrada[j];
            WHILE (i>5) OR not(ctrlcurso(rVec)) DO
                 BEGIN
                  IF (i>5) AND not(ctrlcurso(rVec))
                     
                     THEN
                      WRITE('ERROR: El mismo alumno no puede inscribirse',
                      ' en m',CHR(160),'s de 5 materias y adem',CHR(160),'s la materia seleccionada',
                      ' para las diferentes alternativas no puede diferir')
                     ELSE
                      IF i>5
                         THEN
                          WRITE('ERROR: El mismo alumno no puede inscribirse',
                          ' en m',CHR(160),'s de 5 materias')
                         ELSE
                          WRITE('ERROR: La materia seleccionada para las',
                          ' diferentes alternativas no puede diferir');
                  WRITELN;
                  GOTOXY(10,22);
                  TEXTCOLOR(143);
                  WRITE('Presione una tecla para intentar otra vez.');
                  NORMVIDEO;
                  READKEY;
                  CLRSCR;
                  WRITELN('Ingreso de Datos');
                  WRITELN;
                  WRITE('INGRESE NUMERO DE LEGAJO (Formato: NNNNND): '); READLN(legajo);
                  WRITE('Alternativa 1: '); READLN(vEntrada[j].vAlt[0]);
                  WRITE('Alternativa 2: '); READLN(vEntrada[j].vAlt[1]);
                  WRITE('Alternativa 3: '); READLN(vEntrada[j].vAlt[2]);
                  IF legajo=legant
                     THEN
                      INC(i)
                     ELSE
                      BEGIN
                       legant := legajo;
                       i := 1
                      END;
                  rVec := vEntrada[j];
                 END;
            vEntrada[j].leg := legajo DIV 10;
            vEntrada[j].dig := legajo-(vEntrada[j].leg*10);
            INC(j);
            INC(max100);
            GOTOXY(10,22);
            TEXTCOLOR(143);
            WRITE('Para SALIR presione "s" o cualquier otra tecla para',
            ' continuar.');
            NORMVIDEO;
            salir1 := READKEY;
            CLRSCR;
            IF salir1='s' THEN
               BEGIN
                WRITE(CHR(168),'Est',CHR(160),' SEGURO que de desea salir',CHR(63),': ');
                salir2 := READKEY;
               END;
            IF max100=100 THEN
               BEGIN
                WRITE('Ud. ya ha realizado las 100 operaciones permitidas.',
                ' Ahora el programa se cerrar',CHR(160),'. Muchas Gracias por usar',
                ' nuestro Soft.');
                salir2:='s'
               END;
      UNTIL salir2='s';
      Apareo(vEntrada,aSol,j-1);
 END;
 {FIN PROCEDIMIENTO ALTAS}



{PROCEDIMIENTO BAJAS}
PROCEDURE Bajas(VAR max100:BYTE;VAR aSol:tArchSol);
 VAR
    Dig: BYTE;
    Leg,LYD,POS: LONGINT;
    CambioLeg, ENCONTRE: BOOLEAN;
    CURSO: WORD;
    salir: CHAR;
    rSol: tRegSol;

 PROCEDURE BorraReg(VAR arch:tArchSol);
  VAR
     aAux: tArchSol;
     rAux,rArch: tRegSol;
  BEGIN
   reset(arch);
   ASSIGN(aAux,'DAT\auxilar.dat');
   REWRITE(aAux);
   WHILE NOT EOF(arch) DO
     BEGIN
      READ(arch,rArch);
      IF rArch.vAlt[2] <> 0 
       THEN
        WRITE(aAux,rArch);
     END;
   CLOSE(arch);
   ERASE(arch);
   reset(aAux);
   RENAME(aAux,'DAT\solins.dat');
   close(aAux);
   ASSIGN(arch,'DAT\solins.dat');
   RESET(arch);
  END;
    
 
 BEGIN
      REPEAT 
        CLRSCR;
        WRITELN('INGRESE NUMERO DE LEGAJO (Formato: NNNNND)');
        READLN(LYD);
        WRITELN('INGRESE EL NUMERO DE CURSO DE LA PRIMER ALTERNATIVA');
        READLN(CURSO);
        leg := LYD DIV 10;
        POS := BuscaReg(LYD,CURSO,aSol);
        IF POS = -1 
          THEN
           BEGIN
            WRITELN('Alguno de los datos que ingres',CHR(162),' no es correcto');
            READKEY
           END
          ELSE
           BEGIN 
            SEEK(aSol,POS);
            rSol.vAlt[0] := CURSO;
            rSol.vAlt[1] := 0;
            rSol.vAlt[2] := 0;
            rSol.leg := leg;
            rSol.dig := dig;
            WRITE(aSOl,rSol);
            INC(max100)
           END;
        GOTOXY(10,22);
        TEXTCOLOR(143);
        WRITE('Para SALIR presione "s" o cualquier otra tecla para continuar.');
        NORMVIDEO;
        salir := upcase(READKEY);
   UNTIL (salir='S') OR (max100 = 100);
   BorraReg(aSol);
         
 END;
 {FIN PROCEDIMIENTO BAJAS}






{PROCEDIMIENTO MODIF}
PROCEDURE Modif(VAR max100:BYTE;VAR aSol:tArchSol);
          VAR
             rSol: tRegSol;
             LYD,P,F,PM,POS,POS2,POSFINAL: LONGINT;
             CambioLeg, ENCONTRE: BOOLEAN;
             CURSO: WORD;
             salir: CHAR;
             
          BEGIN
                REPEAT 
                   CLRSCR;
                  WRITELN('INGRESE NUMERO DE LEGAJO');
                   READLN(LYD);
                   WRITELN('INGRESE EL NUMERO DE CURSO DE LA PRIMER ALTERNATIVA');
                   READLN(CURSO);
                  POS := BuscaReg(LYD,CURSO,aSol);
                  IF POS = -1 
                     THEN
                      BEGIN 
                       WRITELN('HAY UN ERROR EN ALGUNO DE LOS DATOS');
                       READKEY
                      END
                     ELSE
                      BEGIN
                       SEEK(aSol,POS);
                       WRITELN('Ingreso de Datos');
                       WRITELN;
                       WRITE('Alternativa 1: '); READLN(rSol.vAlt[0]);
                       WRITE('Alternativa 2: '); READLN(rSol.vAlt[1]);
                       WRITE('Alternativa 3: '); READLN(rSol.vAlt[2]);
                       WHILE NOT ctrlcurso(rSol) DO
                         BEGIN
                           WRITE('ERROR: La materia seleccionada para las',
                           ' diferentes alternativas no puede diferir');
                           WRITELN;
                           GOTOXY(10,22);
                           TEXTCOLOR(143);
                           WRITE('Presione una tecla para intentar otra vez.');
                           NORMVIDEO;
                           READKEY;
                           CLRSCR;
                           WRITELN('Ingreso de Datos');
                           WRITELN;
                           WRITE('Alternativa 1: '); READLN(rSol.vAlt[0]);
                           WRITE('Alternativa 2: '); READLN(rSol.vAlt[1]);
                           WRITE('Alternativa 3: '); READLN(rSol.vAlt[2]);
                         END; 
                       rSol.leg := LYD DIV 10;
                       rSol.dig := LYD-(rSol.leg*10);
                       WRITE(aSOl,rSol);
                       INC(max100)
                      END;
               GOTOXY(19,22);
               TEXTCOLOR(143);
               WRITE('Para SALIR presione "s" o cualquier otra tecla para continuar.');
               NORMVIDEO;
               salir := upcase(READKEY);
   UNTIL (salir='S') OR (max100 = 100);
 END;
{FIN PROCEDIMIENTO MODIF}

{//////////////FIN SUBPROCEDIMIENTOS DE ABMSolins/////////////////////}
BEGIN
        max100 := 0;    {Asigno 0 al max100, que es el contador encargado
                        de guardar la cantidad de operaciones realizadas.}
        ASSIGN(aSol,'DAT\solins.dat');
      {$I-}    {Desactivo la detección de errores de E/S para que el
                programa no cancele en caso de que no exista el archivo.}
      RESET(aSol);
      {$I+}    {Vuelvo a activar el control.}
      IF IOResult <> 0 THEN REWRITE(aSol); {Si no existe, lo creo.}
      REPEAT
            IF max100=100
               THEN
                   salir:=TRUE
               ELSE
                   REPEAT
                     BEGIN
                      opcionmal:=FALSE;
                      CLRSCR;
                      GotoXY ( 1,25 ); { Impresion de titulos en pantalla}
                      Write ( 'Cantidad de operaciones realizadas hasta el momento : ',max100,'/100' );
                      GotoXY ( 1,1 );
                      WriteLn ( 'ABM Inscripciones' );
                      abm := aChoice ( aMenuSolins,iOp,1,3 );
                      CASE abm OF
                         1 : Altas(max100,aSol);
                         2 : Bajas(max100,aSol);
                         3 : Modif(max100,aSol);
                         4 : salir:=TRUE;
                         ELSE
                             WRITE('Ingrese alguna de las opciones presentadas',
                             '(1,2,3 o 4). Presione cualquier tecla para',
                             ' continuar');
                             READKEY;
                             opcionmal := TRUE
                      END
                     END;
                   UNTIL NOT opcionmal;
      UNTIL salir;
      CLOSE(aSol);
      {Le doy las opciones, controlo que la ingrese bien. Entre las opciones
      que tiene está la de Salir del programa. También controlo que no venga
      de alguno de los procedimientos con la cantidad máxima de operaciones.}
END;

{//////////////////////////////////////////////////////////////////////////////////}
{////////////////////////// FIN PROCEDIMIENTO ABMSolins ///////////////////////////}
{//////////////////////////////////////////////////////////////////////////////////}



{
MODULO 4
ABM Correlativas
Grupo 5
Docente : Broner
Ayudante : Glikman, Ariel
Curso K-1001
Lunes y Miercoles de 8:30 - 12:30

NOTA : Este programa tiene 2 modos de ejecucion. El modo "normal" y el modo
"debug". Para entrar en modo debug, y poder efectuar acciones adicionales
sobre el vector y/o el archivo durante la marcha sin reiniciar, o ver mas
a fondo el funcionamiento interno del prog a medida que se ejecuta, anda al
menu OPTION/COMPILER/Conditional Defines y ahi pone DEBUG. Compila y listo.
Para el modo normal no pongas nada en esa opcion.

}
Procedure ABMCorrela;
Const
  iMaxOp = 20;  {Cantidad de operaciones maximas por ejecucion}
                                {Tambien sirve para indicar el maximo del vector buffer}
{$IFDEF Debug}
  iCantOp = 8;  {Cantidad de opciones que hay en el menu principal}
{$ELSE}         {Cambia segun el modo en el que compilo}
  iCantOp = 4;
{$ENDIF}
Type
  aChoiceArray     = Array [ 1..iCantOp ] of String; {Menucito para usar el teclado hecho por mi!}

  rRegistroCorrela = Record    {Registro con la estructura base del archivo CORRELA.DAT}
                       CodMat,              {5 digitos - 00001/99999}
                       CodMat1 : Longint;   {5 digitos - 00001/99999}
                       Tipo    : Char;      {1 digitos - T/F}
                     End; { rRegistroAluCorrela }

  aArrayCorrela    = Array [ 1..iMaxOp ] of rRegistroCorrela; {Vector Buffer}

  fCorre           = File of rRegistroCorrela; {Manejador del archivo CORRELA.DAT}

  sNombreArchivo   = String [ 11 ]; { Tipo usado en el apareo ABM, para indicar el nombre del archivo en el caso de que difiera
                                      del preasignado, o quiera usarse el modulo para otra cosa}
Const
  aMenu        : aChoiceArray = ('Altas          ',
  {Opciones del menu}            'Bajas          ',
                                 'Modificaciones ',
                                 {$IFDEF Debug}     {Estas 4 opciones aparecen solo si se esta en modo DEBUG}
                                 'Listar Archivo ', {Mas info en el archivo DEBUG.PAS}
                                 'Listar Vector  ',
                                 'Guardar Cambios',
                                 'Reiniciar      ',
                                 {$ENDIF}
                                 'Salir          ');
Var
  fCorrela     : fCorre;           {El archivo}
  aCorrela     : aArrayCorrela;    {El vector buffer}
  rRegCorr     : rRegistroCorrela; {El registro individual para uso en varios proc del programa}
  cOpcion,         {La opcion que devuelve el menu aChoice}
  bVecCorrTop,     {La cantidad de elementos que tiene el vector aCorrela}
  bNOp         : Byte;  {La cantidad actual de operaciones realizadas por el modulo}

{FUNCION aCHoice

Crea un menu en pantalla con los datos de un array con las opciones
y devuelve la opcion elegida.

PARAMETROS = aNames : El menu con las opciones a imprimir
             Tipo   : aChoiceArray
             Uso    : E/S

             iMax   : Cantidad de opciones que tiene el menu
             Tipo   : Entero
             Uso    : E

             X,Y    : Posicion en pantalla a imprimirse el menu
             Tipo   : Byte
             Uso    : E

DEVUELVE = Entero. Es la opcion elegida por el usuario
}
Function aChoice ( VAR aNames : aChoiceArray; iMax : Integer; X,Y : Byte ) : Integer;
Var
  I      : Integer;   { Indice para uso interno del procedimiento }
  cTecla : Char;      { Variable que almacena la ultima tecla pulsada }
  bFlag  : Boolean;   { Indica si ya se ha elegido una opcion o debe seguir }
Begin
  GotoXY ( X,Y );
  WriteLn ('Seleccione:');
  For I := 1 to iMax do              { Se imprime el menu en pantalla }
    WriteLn (I,'.- ', + aNames[i]);
  I := 1;
  bFlag := False;
  Repeat
    { En esta parte se resalta la opcion actual }
    GotoXY ( X,Y + I );
    TextBackGround ( 1 );
    TextColor ( 15 );
    Write ( I,'.- ', + aNames[ I ] );
    { Aca se espera que el usuario pulse una tecla }
    cTecla := UpCase ( Readkey );
    { Se saca el resaltado antes de procesar la tecla }
    GotoXY ( X,Y+I );
    TextBackGround (0);
    TextColor ( 7 );
    Write ( I,'.- ', + aNames[ I ] );
    { Se procesa la tecla }
    Case cTecla of
      #72 : Dec ( I );         { Tecla FLECHA ARRIBA }
      #80 : Inc ( I );         { Tecla FLECHA ABAJO  }
      #13 : bFlag := True;     { Tecla ENTER  }
      #27 : bFlag := True;     { Tecla ESCAPE }
    end;
    If I > iMax
      Then  { Verifica que no se salga del limite superior del menu }
        I := iMax
      Else
        If I < 1
          Then { Verifica que no se salga del limite inferior del menu }
            I := 1;
  Until bFlag = True; { Hasta que se pulse ENTER o ESCAPE }
  ClrScr;
  If cTecla = #27
    Then { Si se pulsa ESCAPE entonces, sin importar la opcion actual, se supone
           que el usuario quiere salir y por eso se asigna como valor de
           retorno la ultima opcion del menu (SALIR) }
      aChoice := iMax
    Else
      aChoice := I; { Si no, se devuelve la opcion elegida }
  GotoXY ( X,Y ); { Se pone el cursor donde estaba al principio }
End; { aChoice }

{
PROCEDIMIENTO IngresarDatos

Permite ingresar datos correspondientes al registro actual. Controla que los
valores sean > a 0 y <= 99999

PARAMETROS = rReg : Registro donde se almacenaran los datos a devolver
             Tipo : rRegistroCorrela
             Uso  : E/S
}
Procedure IngresarDatos ( VAR rReg : rRegistroCorrela );
Begin
  ClrScr;
  Repeat
    Write  ( 'Codigo Materia [0..99999]:' );
    ReadLn ( rReg.CodMat );
  Until ( rReg.CodMat > 0 ) AND ( rReg.CodMat <= 99999 ); {impide que el numero pase del rango de los 5 digitos}
  Repeat
    Write  ( 'Codigo Materia Correlativa [0..99999]:' );
    ReadLn ( rReg.CodMat1 );
  Until ( rReg.CodMat1 > 0 ) AND ( rReg.CodMat <= 99999 );
End; { IngresarDatos }

{
PROCEDIMIENTO ImprimirDatos

Imprime los datos del registro en cuestion. Util debido a la gran cantidad de
impresiones durante el prog.

PARAMETROS = rReg : Registro de donde se sacaran los datos a imprimir
             Tipo : rRegistroCorrela
             Uso  : E

             cCodOP : Codigo de operacion del registro a imprimir. Se usa
                      al hacer el apareoABM del vector con el archivo
             Tipo   : Char
             Uso    : E
}
Procedure ImprimirDatos ( rReg : rRegistroCorrela );
Begin
   WriteLn ( 'Codigo Materia :',rReg.CodMat );
   WriteLn ( 'Codigo Materia Correlativa :',rReg.CodMat1 );
   WriteLn ( 'Tipo :',rReg.Tipo );
End; { ImprimirDatos }

{FUNCION BusBinVec

Efectua una busqueda binaria en el vector.

PARAMETROS = aVec : Vector donde se efectuara la busqueda
             Tipo : aArrayCorrela
             Uso  : E/S

             iLimInf,
             iLimSup : El comienzo y el final desde donde se desea
                       buscar ( respectivamente ).
             Tipo : Entero
             Uso  : E

             lCod : Clave a buscar en el vector.
             Tipo : Entero Largo
             Uso  : E

DEVUELVE = Entero. Si lo encontro devuelve la posicion en el vector donde se
           encuentra el valor buscado. Si no, devuelve 0.
}
Function BusBinVec ( VAR aVec     : aArrayCorrela;
                         iLimInf,
                         iLimSup  : Integer;
                         lCod     : Longint ) : Integer;
Var
  iPuntoMedio,              { Apunta al medio del segmento definifo por iLimInf/iLimSup del vector }
  iPosicion    : Integer;   { Indica la posicion en la que esta el elemento buscado. Si no la encuentra queda como 0
                              y eso devuelve la funcion }
Begin
  iPosicion := iLimInf- 1;
  iPuntoMedio := iLimInf;
  While ( iPosicion <> iPuntoMedio ) AND ( iLimInf <= iLimSup ) do
    Begin
      iPuntoMedio := ( iLimInf + iLimSup ) Div 2;
      If lCod = aVec[ iPuntoMedio ].CodMat
        Then
          iPosicion := iPuntoMedio
        Else
          If lCod > aVec[ iPuntoMedio ].CodMat
            Then
              iLimInf := iPuntoMedio + 1
            Else
              iLimSup := iPuntoMedio - 1
          { End IF }
      { End IF }
    End; { While }
  BusBinVec := iPosicion;
End; { BusBinVec }

Function BusMatVec ( VAR aVec    : aArrayCorrela;
                         bVectop : Byte;
                         lCod    : Longint;
                         lPos    : Longint ) : LongInt;

Procedure Leer ( VAR aVec       : aArrayCorrela;
                     lCod,
                     lTmpCod,
                     lCodMatAct : Longint;
                     lPos       : Byte;
                 VAR bEncontro  : Boolean );
Begin
  lTmpCod := aVec[ lPos ].CodMat;
  If ( aVec[ lPos ].CodMat1 = lCod ) AND ( lCodMatAct = aVec[ lPos ].CodMat )
    Then
      Begin
        BusMatVec := lPos;
        bEncontro := True;
      End;
End;

Var
  bEncontro    : Boolean;
  lPosInicial  : Byte;
  LTmpCod,
  lCodMatAct   : Longint;
Begin
  BusMatVec := 0;
  bEncontro := False;
  lPosInicial := lPos;
  lCodMatAct := aVec[ lPos ].CodMat;
  lTmpCod := aVec[ lPos ].CodMat;
  While NOT bEncontro AND ( lPos >= 1 ) AND ( lCodMatAct = lTmpCod ) Do
    Begin
      Leer ( aVec,lCod,lTmpCod,lCodMatAct,lPos,bEncontro );
      Dec ( lPos );
    End;
  lPos := lPosInicial;
  lCodMatAct := aVec[ lPos ].CodMat;
  lTmpCod := aVec[ lPos ].CodMat;
  While NOT bEncontro AND ( lPos <= bVecTop ) AND ( lCodMatAct = lTmpCod ) Do
    Begin
      Leer ( aVec,lCod,lTmpCod,lCodMatAct,lPos,bEncontro );
      Inc ( lPos );
    End;
End;
{FUNCION BusBinArch

Efectua una busqueda binaria en el archivo.

PARAMETROS = fArchivo : Archivo donde se efectuara la busqueda
             Tipo : fCorre
             Uso  : E/S

             sCod : Clave a buscar en el archivo.
             Tipo : Entero Largo
             Uso  : E

             rReg : Registro con la estructura del archivo
             Tipo : rRegistroCorrela
             Uso  : E

DEVUELVE = Entero largo.Si lo encontro devuelve la posicion en el archivo
           donde se encuentra el valor buscado. Si no, devuelve -1.
}
Function BusBinArch ( VAR fArchivo : fCorre;
                          lCod     : Longint;
                          rReg     : rRegistroCorrela ) : LongInt;
Var
  lPuntoMedio,
  lPosicion,
  lLimInf,
  lLimSup     : Longint;
Begin
  lLimInf := 0;
  lLimSup := FileSize ( fArchivo ) - 1;
  lPosicion := -1;
  While ( lPosicion = -1 ) AND ( lLimInf <= lLimSup ) do
    Begin
    lPuntoMedio := ( lLimInf + lLimSup ) Div 2;
{$IFDEF Debug}
    WriteLn ( 'LimInf: ',lLimInf:2,' PtoMedio: ',lPuntoMedio:2,' LimSup',lLimSup:2 );
{$ENDIF}
    Seek ( fArchivo,lPuntoMedio );
    Read ( fArchivo,rReg );
    If lCod = rReg.CodMat
      Then
        lPosicion := lPuntoMedio
      Else
        If lCod > rReg.CodMat
          Then
            lLimInf := lPuntoMedio + 1
          Else
            lLimSup := lPuntoMedio - 1;
        { End IF }
    { End IF }
  End; { While }
  BusBinArch := lPosicion;
End; { BusBinArch }

Function BusMatArch ( VAR fArchivo : fCorre;
                          lCod     : Longint;
                          rReg     : rRegistroCorrela;
                          lPos     : Longint ) : LongInt;

Procedure Leer ( VAR fArchivo   : fCorre;
                     rReg       : rRegistroCorrela;
                     lCodMatAct : Longint;
                 VAR bEncontro  : Boolean );
Begin
  Seek ( fArchivo,lPos );
  Read ( fArchivo,rReg );
  If ( rReg.CodMat1 = lCod ) AND ( lCodMatAct = rReg.CodMat )
    Then
      Begin
        BusMatArch := lPos;
        bEncontro := True;
      End;
End;

Var
  bEncontro    : Boolean;
  lPosInicial,
  lCodMatAct   : Longint;
Begin
  BusMatArch := -1;
  bEncontro := False;
  lPosInicial := lPos;
  Seek ( fArchivo,lPosInicial );
  Read ( fArchivo,rReg );
  lCodMatAct := rReg.CodMat;
  While NOT bEncontro AND ( lPos >= 0 ) AND ( lCodMatAct = rReg.CodMat ) Do
    Begin
      Leer ( fArchivo,rReg,lCodMatAct,bEncontro );
      Dec ( lPos );
    End;
  lPos := lPosInicial;
  Seek ( fArchivo,lPosInicial );
  Read ( fArchivo,rReg );
  lCodMatAct := rReg.CodMat;
  While NOT bEncontro AND ( lPos < FileSize ( fArchivo ) ) AND ( lCodMatAct = rReg.CodMat ) Do
    Begin
      Leer ( fArchivo,rReg,lCodMatAct,bEncontro );
      Inc ( lPos );
    End;
End;

{PROCEDIMIENTO OrdenarVector

Efectua un ordenamiento en el vector indicado.

PARAMETROS = aVec : Vector donde se efectuara el ordenamiento
             Tipo : aArrayCorrela
             Uso  : E/S

             bFin : Cantidad de elementos del vector. Si se especifica un
                    valor menor, ordena hasta la posicion indicada, dejando
                    sin ordenar los valores superiores a la misma
             Tipo : Byte
             Uso  : E
}
Procedure OrdenarVector ( VAR aVec : aArrayCorrela;
                              bFin : Byte );
Var
  I,
  bUltimo : Byte;
  rAux    : rRegistroCorrela;
Begin
  While bFin > 1 Do
    Begin
      bUltimo := bFin - 1;
      bFin := 0;
      For I := 1 to bUltimo Do
        Begin
          If aVec[ I ].CodMat > aVec[ I + 1 ].CodMat
             Then
               Begin
                 rAux := aVec[ I ];
                 aVec[ I ] := aVec[ I + 1 ];
                 aVec[ I + 1 ] := rAux;
                 bFin := I;
               End; { If }
        End; { For }
    End; { While }
End; { OrdenarVector }

Procedure ApareoABM ( VAR fArchivo  : fCorre;
                          sNomArch  : sNombreArchivo;
                          rReg      : rRegistroCorrela;
                      VAR aVec      : aArrayCorrela;
                      VAR bVecTop   : Byte );
Var
  bLeidoArch : Boolean;
  bVecPos    : Byte;
  fTemporal  : fCorre;
  lAux       : Longint;

Procedure LeerArch ( VAR fArchivo : fCorre;
                     VAR rReg     : rRegistroCorrela;
                     VAR bLeido   : Boolean );
Begin
  If Not Eof ( fArchivo )
    Then
      Begin
        Read ( fArchivo,rReg );
        bLeido := True
      End
    Else
      bLeido := False;
End; { LeerArch }

Begin
  Assign  ( fTemporal,'Temp.Dat' );
  ReWrite ( fTemporal );
  Reset   ( fArchivo );
  LeerArch ( fArchivo,rReg,bLeidoArch );
  bVecPos := 1;
  While bLeidoArch Or ( bVecPos <= bVecTop ) do
    Begin
      If ( bVecPos > bVecTop ) OR
         ( ( bLeidoArch ) AND ( rReg.CodMat <= aVec[ bVecPos ].CodMat ) )
         Then { Es menor el cod del archivo, se graba el arch }
           Begin
             If rReg.CodMat1 <> -1
               Then { No esta dado de baja }
                 Write ( fTemporal,rReg );
             LeerArch ( fArchivo,rReg,bLeidoArch );
           End
         Else
           Begin
             If aVec[ bVecPos ].CodMat1 <> -1
               Then { No esta dado de baja }
                 Write ( fTemporal,aVec[ bVecPos ] );
             Inc ( bVecPos )
           End { Else }
    End; { While }
  Close  ( fArchivo );
  Erase  ( fArchivo );
  Close  ( fTemporal );
  Rename ( fTemporal,sNomArch );
End; { ApareoABM }

Procedure VerificaCorrelativa ( VAR fArchivo        : fCorre;
                                    aVec            : aArrayCorrela;
                                    rReg            : rRegistroCorrela;
                                    bVecTop         : Byte;
                                    lPosInicArch    : Longint;
                                    bPosInicVec     : Byte;
                                VAR bCantCorreTp,
                                    bCantCorreFinal : Byte    );
Var
  lPos,
  lTmpCod,
  lCodMatAct : Longint;
Begin
  bCantCorreTp := 0;
  bCantCorreFinal := 0;
{ Primero cuenta en el archivo la cantidad de correaltivas (tanto de tp como
  de final que tiene la materia indicada }
  If lPosInicArch <> - 1
    Then
      Begin
        lPos := lPosInicArch;
        Seek ( fCorrela,lPos );
        Read ( fCorrela,rReg );
        lCodMatAct := rReg.CodMat;
        While ( lPos >= 0 ) AND ( lCodMatAct = rReg.CodMat ) Do
          Begin
            If rReg.CodMat1 <> -1 Then
              Case rReg.Tipo Of
                'F' : Inc ( bCantCorreFinal );
                'T' : Inc ( bCantCorreTp );
              End; { Case }
            Dec ( lPos );
            If lPos >= 0
              Then
                Begin
                  Seek ( fArchivo,lPos );
                  Read ( fArchivo,rReg );
                End; { Then }
          End; { While }
        lPos := lPosInicArch;
        Seek ( fArchivo,lPos );
        Read ( fArchivo,rReg );
        While ( lPos < FileSize ( fArchivo ) ) AND ( lCodMatAct = rReg.CodMat ) Do
          Begin
            If rReg.CodMat1 <> -1 Then
              Case rReg.Tipo Of
                'F' : Inc ( bCantCorreFinal );
                'T' : Inc ( bCantCorreTp );
              End; { Case }
            Inc ( lPos );
            If lPos < FileSize ( fArchivo )
              Then
                Begin
                  Seek ( fArchivo,lPos );
                  Read ( fArchivo,rReg );
                End; { Then }
          End; { While }
        Seek ( fArchivo,lPosInicArch );
        Read ( fArchivo,rReg );
        If rReg.CodMat1 <> -1
          Then
            If rReg.Tipo = 'F'
              Then
                Dec ( bCantCorreFinal )
              Else
                Dec ( bCantCorreTp );
      End; { Then }

{ Despues cuenta en el vector la cantidad de correaltivas (tanto de tp como
  de final que tiene la materia indicada) y las suma a las anteriores }
  If bPosInicVec <> 0
    Then
      Begin
        lPos := bPosInicVec;
        lCodMatAct := aVec[ lPos ].CodMat;
        lTmpCod := aVec[ lPos ].CodMat;
        While ( lPos >= 1 ) AND ( lCodMatAct = lTmpCod ) Do
          Begin
            If aVec[ lPos ].CodMat1 <> -1 Then
              Case aVec[ lPos ].Tipo Of
                'F' : Inc ( bCantCorreFinal );
                'T' : Inc ( bCantCorreTp );
              End; { Case }
            Dec ( lPos );
            If lPos >= 1
              Then
                lCodMatAct := aVec[ lPos ].CodMat;
          End; { While }
        lPos := bPosInicVec;
        lCodMatAct := aVec[ lPos ].CodMat;
        lTmpCod := aVec[ lPos ].CodMat;
        While ( lPos <= bVecTop ) AND ( lCodMatAct = lTmpCod ) Do
          Begin
            If aVec[ lPos ].CodMat1 <> -1 Then
              Case aVec[ lPos ].Tipo Of
                'F' : Inc ( bCantCorreFinal );
                'T' : Inc ( bCantCorreTp );
              End; { Case }
            Inc ( lPos );
            If lPos <= bVecTop
              Then
                lCodMatAct := aVec[ lPos ].CodMat;
          End; { While }
      If aVec[ bPosInicVec ].CodMat1 <> -1
        Then
          If aVec[ bPosInicVec ].Tipo = 'F'
            Then
              Dec ( bCantCorreFinal )
            Else
              If aVec[ bPosInicVec ].Tipo = 'T'
                Then
                  Dec ( bCantCorreTp );
      End; { Then }
{$IFDEF Debug}
   WriteLn ( 'TP:',bCantCorreTp,' ','Final:',bCantCorreFinal );
   Readkey;
{$ENDIF}
End;

Procedure Altas ( VAR aVec      : aArrayCorrela;
                  VAR fArchivo  : fCorre;
                  VAR rReg      : rRegistroCorrela;
                  VAR bNOp,
                      bVecTop   : Byte );
Var
  bCantCorreTp,
  bCantCorreFinal : Byte;
  bPosInicVec,
  bPosVec         : Byte;
  lPosInicArch,
  lPosArch        : LongInt;
Begin
  IngresarDatos ( rReg );

  bPosInicVec  := BusBinVec  ( aVec,1,bVecTop,rReg.CodMat );
  bPosVec := bPosInicVec;
  If bPosInicVec <> 0 Then
    bPosVec := BusMatVec ( aVec,bVecTop,rReg.CodMat1,bPosInicVec );

  lPosInicArch := BusBinArch ( fArchivo,rReg.CodMat,rReg );
  lPosArch := lPosInicArch;
  If lPosInicArch <> -1 Then
    lPosArch := BusMatArch ( fArchivo,rReg.CodMat1,rReg,lPosInicArch );

  If ( ( bPosVec = 0 ) AND ( lPosArch = -1 ) ) {No lo encontro ni en el vec ni en el arch}
    Then
      Begin
        Repeat
          Write  ( 'Tipo [F/T]:' );
          ReadLn ( rReg.Tipo );
          rReg.Tipo := Upcase ( rReg.Tipo )
        Until rReg.Tipo in ['F','T'];
        VerificaCorrelativa ( fArchivo,aVec,rReg,bVecTop,lPosInicArch,bPosInicVec,bCantCorreTp,bCantCorreFinal );
        If ( ( rReg.Tipo = 'T' ) AND ( bCantCorreTp < 5 ) ) OR
           ( ( rReg.Tipo = 'F' ) AND ( bCantCorreFinal < 3 ) )
          Then
            Begin
              Inc ( bNOp );
              Inc ( bVecTop );
              aVec[ bVecTop ] := rReg;
              OrdenarVector ( aVec,bVecTop );
              WriteLn ( 'El Alta se ha realizado con exito' );
              ReadKey;
            End
          Else
            Begin
              WriteLn ( 'No se puede efectuar la operacion por haber',
                        'sobrepasado la cantidad maxima de correlativas de ese tipo');
              ReadKey;
            End;
      End { Then }
    Else {Lo encontro en algun lado (vec o arch) y no esta como baja}
      Begin
        WriteLn ( 'El registro ya existe' );
        ReadKey
      End; { Else }
End; { Altas }

Procedure Bajas ( VAR aVec      : aArrayCorrela;
                  VAR fArchivo  : fCorre;
                  VAR rReg      : rRegistroCorrela;
                  VAR bNOp,
                      bVecTop   : Byte );

Function Borrar : Char;
Var
  cRes : Char;
Begin
  Repeat
    Write  ( Chr ( 10 ) + 'Desea borrar? (S/N): ');
    ReadLn ( cRes );
    cRes := UpCase ( cRes );
  Until cRes in ['N','S'];
  Borrar := cRes;
End; { Borrar }

Var
  bPosVec  : Byte;
  lTmpCod,
  lPosArch : LongInt;
Begin
  IngresarDatos ( rReg );
  ClrScr;

  bPosVec  := BusBinVec ( aVec,1,bVecTop,rReg.CodMat );
  If bPosVec <> 0 Then
    bPosvec := BusMatVec ( aVec,bVecTop,rReg.CodMat1,bPosVec );

  lPosArch := BusBinArch ( fArchivo,rReg.CodMat,rReg );
  If lPosArch <> -1 Then
    lPosArch := BusMatArch ( fArchivo,rReg.CodMat1,rReg,lPosArch );

  If bPosVec <> 0
    Then
      lTmpCod := aVec[ bPosVec ].CodMat1;
  If ( bPosVec <> 0 ) AND ( lTmpCod <> -1 )
    Then { Esta en el vector como alta }
      Begin
        ImprimirDatos ( aVec[ bPosVec ] );
        If Borrar = 'S'
          Then
            Begin
              Inc ( bNOp );
              aVec[ bPosVec ].CodMat1 := -1;
              OrdenarVector ( aVec,bVecTop );
              WriteLn ( 'La operacion se ha realizado con exito' );
              ReadKey
            End { Then }
      End { Then }
    Else
      If ( lPosArch <> -1 ) AND ( bPosVec = 0 )
        Then { Esta en archivo }
          Begin
            Seek ( fArchivo,lPosArch );
            Read ( fArchivo,rReg );
            ImprimirDatos ( rReg );
            If Borrar = 'S'
              Then
                Begin
                  Inc ( bNOp );
                  Seek ( fArchivo,lPosArch );
                  rReg.CodMat1 := -1;
                  Write ( fArchivo,rReg );
                  WriteLn ( 'La operacion se ha realizado con exito' );
                  ReadKey
                End { Then }
          End { Then }
        Else
          Begin
            WriteLn ( 'El registro no existe');
            ReadKey
          End { Else }
End;

Procedure Modif ( VAR aVec      : aArrayCorrela;
                  VAR fArchivo  : fCorre;
                  VAR rReg      : rRegistroCorrela;
                  VAR bNOp,
                      bVecTop   : Byte );
Var
  bCantCorreTp,
  bCantCorreFinal,
  bTmpPosVec,
  bPosInicVec,
  bPosVec       : Byte;
  lTmpCod,
  lPosInicArch,
  lPosArch      : LongInt;
Begin
  ClrScr;
  IngresarDatos ( rReg );

  bPosVec  := BusBinVec  ( aVec,1,bVecTop,rReg.CodMat );
  If bPosVec <> 0 Then
    bPosvec := BusMatVec ( aVec,bVecTop,rReg.CodMat1,bPosVec );

  lPosArch := BusBinArch ( fArchivo,rReg.CodMat,rReg );
  If lPosArch <> -1 Then
    lPosArch := BusMatArch ( fArchivo,rReg.CodMat1,rReg,lPosArch );

  WriteLn;
  If bPosVec <> 0
    Then
      lTmpCod := aVec[ bPosVec ].CodMat1;
  If ( bPosVec <> 0 ) AND ( lTmpCod <> -1 ) {La encontro en el vec pero no en el arch}
    Then
      Begin
        Inc ( bNOp );
        Repeat
          Write  ( 'Nuevo Codigo Materia Correlativa [0..99999]:' );
          ReadLn ( rReg.CodMat1 );
        Until ( rReg.CodMat1 > 0 ) AND ( rReg.CodMat <= 99999 );

        { Verifica que la nuev modificacion no exista ya como un alta }
        bTmpPosVec  := BusBinVec  ( aVec,1,bVecTop,rReg.CodMat );
        If bTmpPosVec <> 0 Then
          bTmpPosvec := BusMatVec ( aVec,bVecTop,rReg.CodMat1,bTmpPosVec );

        lPosArch := BusBinArch ( fArchivo,rReg.CodMat,rReg );
        If lPosArch <> -1 Then
          lPosArch := BusMatArch ( fArchivo,rReg.CodMat1,rReg,lPosArch );

        { Si esta todo OK recian ahi la graba }
        If ( bTmpPosVec = 0 ) AND ( lPosArch = -1 )
          Then
            Begin
              Repeat
                Write  ( 'Nuevo Tipo [F/T]:' );
                ReadLn ( rReg.Tipo );
                rReg.Tipo := Upcase ( rReg.Tipo );
              Until rReg.Tipo in ['F','T'];
              aVec[ bPosVec ] := rReg;
              WriteLn ( 'La operacion se ha realizado con exito' );
              ReadKey
            End { Then }
          Else
            Begin
              WriteLn ( 'La modificacion que usted desea realizar ya existe' );
              ReadKey
            End
      End { Then }
    Else
      If ( lPosArch <> -1 ) AND ( bPosVec = 0 )
        Then { La encontro en el arch pero no en el vec }
          Begin
            Inc ( bNOp );
            Repeat
              Write  ( 'Nuevo Codigo Materia Correlativa [0..99999]:' );
              ReadLn ( rReg.CodMat1 );
            Until ( rReg.CodMat1 > 0 ) AND ( rReg.CodMat <= 99999 );

            { Verifica que la nuev modificacion no exista ya como un alta }
            bPosVec  := BusBinVec  ( aVec,1,bVecTop,rReg.CodMat );
            If bPosVec <> 0 Then
              bPosvec := BusMatVec ( aVec,bVecTop,rReg.CodMat1,bPosVec );

            lPosArch := BusBinArch ( fArchivo,rReg.CodMat,rReg );
            If lPosArch <> -1 Then
              lPosArch := BusMatArch ( fArchivo,rReg.CodMat1,rReg,lPosArch );

            { Si esta todo OK recian ahi la graba }
            If ( bPosVec = 0 ) AND ( lPosArch = -1 )
              Then
                Begin
                  Repeat
                    Write  ( 'Nuevo Tipo [F/T]:' );
                    ReadLn ( rReg.Tipo );
                    rReg.Tipo := Upcase ( rReg.Tipo );
                  Until rReg.Tipo in ['F','T'];
                  Seek ( fArchivo,lPosArch );
                  Write ( fArchivo,rReg );
                  WriteLn ( 'La operacion se ha realizado con exito' );
                  ReadKey
                End { Then }
              Else
                Begin
                  WriteLn ( 'La modificacion que usted desea realizar ya existe' );
                  ReadKey
                End { Else }

          End { Then }
        Else
          Begin
            WriteLn ('El registro no existe para modificar');
            ReadKey
          End; { Else }
    { End If }
End; { Modif }

{$IFDEF Debug}
{$I Debug.PAS}
{$ENDIF}

Begin { ABMCorrelativas}
  Assign ( fCorrela,'Correla.Dat' );  {Se abre el archivo CORRELA.DAT}
  {$I-}
  Reset  ( fCorrela ); { Se lo abre para lectura/escritura }
  {$I+}
  If IOResult <> 0
    Then
      Rewrite ( fCorrela ); { Si no encuentra el archivo, lo crea }
  bNOp := 0;        { Cuenta la cantidad de opraciones hasta el momento }
  bVecCorrTop := 0; { Se inicializa los operadores del vector }
  Repeat
    ClrScr;
    GotoXY ( 1,25 ); { Impresion de titulos en pantalla}
    Write ( 'Cantidad de operaciones realizadas hasta el momento : ',bNOp,'/',iMaxOp );
    GotoXY ( 1,1 );
    WriteLn ( 'ABM Correlativas' );
    cOpcion := aChoice ( aMenu,iCantOp,1,3 ); { Impresion del menu y retorno de opcion elegida }
    ClrScr;
    If ( bNOp < iMaxOp ) {$IFDEF Debug} OR ( cOpcion in [4..7] ) {$ENDIF}
      Then { Entra si todavia hay operaciones disponibles } { O si estoy en modo DEBUG }
        Case cOpcion Of
          1 : Altas ( aCorrela,fCorrela,rRegCorr,bNOp,bVecCorrTop );
          2 : Bajas ( aCorrela,fCorrela,rRegCorr,bNOp,bVecCorrTop );
          3 : Modif ( aCorrela,fCorrela,rRegCorr,bNOp,bVecCorrTop );
{$IFDEF Debug}
{Esta parte es opcional. Sirve para efectuar operaciones sin tener que
reiniciar el prog. Para mas info ver archivo Debug.PAS }
          4 : ListarArch ( fCorrela,rRegCorr );
          5 : ListarVect ( aCorrela,bVecCorrTop );
          6 : GuardarCambios ( fCorrela,aCorrela,rRegCorr,bNOp,bVecCorrTop );
          7 : Reiniciar ( fCorrela,bNOp,bVecCorrTop );
{$ENDIF}
        End { Case }
      Else
        If cOpcion < iCantOp
          Then { Verifica que se han pasado la maxima cant de operaciones }
            Begin
              WriteLn ( 'Se ha alcanzado el m ximo de operaciones por ejecuci¢n' );
              ReadKey;
            End {Then}
  Until cOpcion = iCantOp; { Sale si se ha puesto la opcion de salir }
  Close ( fCorrela ); { Se cierra el archivo }
{$IFDEF Debug}
  WriteLn ( 'Apareo ABM' );
{$ENDIF}
  ApareoABM ( fCorrela,'Correla.DAT',rRegCorr,aCorrela,bVecCorrTop ); { Se hace el apareo con el vector }
End; { ABMCorrelativas }

End.