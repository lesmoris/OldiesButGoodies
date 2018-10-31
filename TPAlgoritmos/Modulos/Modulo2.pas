Unit Modulo2;
Interface

Procedure ABMMaterias;
Procedure ABMCursos;

Implementation
Uses
  Menu,
  Printer,
  Crt;

{**************************************************************************}
{***************** M O D U L O  D E  M A T E R I A S **********************}
{**************************************************************************}

PROCEDURE ABMMaterias;
Const
  iOp = 4;
  aMenuMaterias : aChoiceArray = ('Altas         ',
  {Opciones del menu}             'Bajas         ',
                                  'Modificaciones',
                                  'Salir         ','','','','','','','');
CONST
Ejecuciones=10;
CantMaxMaterias=40;
MarcadeBaja = 0;
NoEncontrado=-1;

TYPE
    String20=STRING [20];
    TRegMaterias=RECORD
                   CodigoMateria:LONGINT;
                   NombreMateria:String20;
                   Anio:BYTE;
                   Regimen:CHAR
    END;

    TArchMaterias=FILE OF TRegMaterias;

    TVectorMaterias=ARRAY[1..(Ejecuciones+CantMAxMaterias)] OF TRegMaterias;

{**************************************************************************}

FUNCTION BusBinariaVecMat (VAR Vec: TVectorMaterias; PContVector: byte; dato:LONGINT):longint;
{Realiza la busqueda binaria en el vector}
Var
   LimInf,LimSup,PuntoMedio:LONGINT;
   Encontrado:boolean;
Begin
     LimInf:=1;
     LimSup:=PContVector;
     Encontrado:=false;
     WHILE (Not Encontrado) AND (LimInf<=LimSup) DO
     BEGIN
          PuntoMedio:=(LimInf+LimSup) div 2;
          IF Vec[PuntoMedio].CodigoMateria=dato THEN
          Encontrado:=True
          Else
              If Vec[PuntoMedio].CodigoMateria>dato THEN
              LimSup:=PuntoMedio-1
              Else
                  LimInf:=PuntoMedio+1;
     end;
     IF Encontrado THEN
     BusBinariaVecMat:=PuntoMedio
     else
     BusBinariaVecMat:=NoEncontrado;

end;

{**************************************************************************}
PROCEDURE Inicializar_Vector(VAR PVectorMaterias:TVectorMaterias);
{Inicializa el vector con ceros porque no sabemos si va a estar completo}
VAR
I:BYTE;
BEGIN
FOR I:=1 TO (Ejecuciones+CantMAxMaterias) DO
PVectorMaterias[I].CodigoMateria:=0;
END;

{**************************************************************************}

PROCEDURE Cargar_VectorMaterias (VAR PVectorMaterias:TVectorMaterias;
VAR PMaterias:TArchMaterias; VAR PContVector:BYTE);
{Cargamos el vector con el contenido del archivo de Materias}
BEGIN
RESET(PMaterias);
PContVector:=1;
WHILE NOT EOF(PMaterias) DO
   BEGIN
   READ(PMaterias,PVectorMaterias[PContVector]);
   INC(PContVector)
   END;
CLOSE(PMaterias);
END;


{**************************************************************************}

PROCEDURE OrdenarVector (VAR PVectorMaterias: TVectorMaterias; Ult: BYTE);
VAR
   Aux: TRegMaterias;
   I,Fin:BYTE;
BEGIN
     WHILE Ult>1 DO
     BEGIN
          Fin:=Ult-1;
          Ult:=0;
          FOR I:=1 TO Fin DO
          BEGIN
               IF PVectorMaterias[I].CodigoMateria>PVectorMaterias[I+1].CodigoMateria
               THEN
               BEGIN
                    Aux:=PVectorMaterias[I];
                    PVectorMaterias[I]:=PVectorMaterias[I+1];
                    PVectorMaterias[I+1]:=Aux;
                    Ult:=I
               END
          END;
     END;
END;

{**************************************************************************}

PROCEDURE Cargar_Alta (VAR PVectorMaterias:TVectorMaterias; VAR PContVector: BYTE);
{Carga las altes ingresadas por el usuario en el vactor donde habia guardado
el contenido del archivo Materias y lo ordeno para poder tene realizar busqueda
binaria en este}
VAR
 codigo:longint;
 encontrado:boolean;
BEGIN
     CLRSCR;
     WRITELN ('PANTALLA DE ALTAS');
     WRITELN ('-----------------');
     WRITELN;
     WRITE ('Ingrese el Codigo de Materia: ');
     READLN (codigo);

     {Reviso que el c¢digo a ser dado de alta no exista}

     IF BusBinariaVecMat(PVectorMaterias,PContVector,codigo)= NoEncontrado
     THEN encontrado:=false
     ELSE encontrado:=true;

     IF NOT encontrado THEN
     BEGIN
          PVectorMaterias[PContVector].CodigoMateria:=codigo;
          WRITE ('Ingrese el nombre de la Materia: ');
          READLN (PVectorMaterias[PContVector].NombreMateria);
          WRITE ('Ingrese el a¤o: ');
          READLN (PVectorMaterias[PContVector].Anio);
          WRITE ('Ingrese el Regimen de Cursada (C:Cuatrimestral, A:Anual): ');
          READLN (PVectorMaterias[PContVector].Regimen);
          OrdenarVector (PVectorMaterias, PContVector);
          INC(PContVector)

      END
      ELSE
          BEGIN
               WRITELN;
               WRITELN ('El codigo de materia que desea ingresar ya existe');
               WRITELN;
               WRITELN ('    Presione cualquier tecla para continuar');
               READKEY;
          END;
END;

{**************************************************************************}

PROCEDURE Cargar_Baja(VAR PVectorMaterias:TVectorMaterias; PContVector:BYTE);
{Una vez realizado el control de no querer dar de baja una Materia que no existe,
el registro a dar de baja se le ingresa una marca de baja. Lo ordeno para poder
realizar busqueda binaria}

VAR
   Baja:longint;
   Posi:longint;
BEGIN

     CLRSCR;
     WRITELN ('PANTALLA DE BAJAS');
     WRITELN ('-----------------');
     WRITELN;
     WRITE ('Ingrese el Codigo de la Materia que desea dar de baja: ');
     READLN (Baja);
     Posi:=BusBinariaVecMat(PVectorMaterias,PContVector,Baja);
              IF Posi <>NoEncontrado THEN
              BEGIN
              PVectorMaterias[Posi].CodigoMateria:= MarcadeBaja;
              OrdenarVector (PVectorMaterias, PContVector);

              WRITELN;
              WRITELN ('La Materia con Codigo: ',Baja, ' fue dada de BAJA');
              WRITELN;
              WRITELN ('   Presione cualquier tecla para continuar');
              READKEY;
              END
              ELSE
              BEGIN
                   CLRSCR;
                   WRITELN;
                   WRITELN ('    No existe el Codigo de Materia que pidio dar de baja');
                   WRITELN;
                   WRITELN ('         Presione cualquier tecla para continuar');
                   READKEY;
              END;

END;

{**************************************************************************}

PROCEDURE Cargar_Modificacion (VAR PVectorMaterias:TVectorMaterias; PContVector: BYTE);
{Para realizaar un modificacion se busca el registro y se ingresa sobre el
varctor los datos modificados}
VAR
   Modificacion:longint;
   Posi:longint;
BEGIN
     CLRSCR;
     WRITELN ('PANTALLA DE MODIFICACIONES');
     WRITELN ('--------------------------');
     WRITELN;
     WRITELN('Ingrese el Codigo de la Materia que desea Modificar');
     READLN(Modificacion);
     Posi:=BusBinariaVecMat (PVectorMaterias,PContVector,Modificacion);
              IF Posi <> NoEncontrado THEN
              BEGIN
                   clrscr;
                   WRITELN ('PANTALLA DE MODIFICACION');
                   WRITELN ('------------------------');
                   WRITELN;
                   WRITELN ('Los datos actuales del registro son los siguientes:');
                   WRITELN ('Nombre de la Materia: ',PVectorMaterias[posi].NombreMateria);
                   WRITELN ('A¤o en que se cursa: ',PVectorMaterias[posi].Anio);
                   WRITELN ('Regimen de Cursada (C:Cuatrimestral, A:Anual): ',PVectorMaterias[posi].Regimen);
                   WRITELN;
                   WRITELN ('INGRESE LOS DATOS A MODIFICAR:');
                   WRITELN;
                   WRITE ('Ingrese el Nombre de la Materia: ');
                   READLN (PVectorMaterias[posi].NombreMateria);
                   WRITE ('Ingrese el a¤o en que se cursa: ');
                   READLN (PVectorMaterias[posi].Anio);
                   WRITE ('Ingrese el Regimen de Cursada (C:Cuatrimestral, A:Anual): ');
                   READLN (PVectorMaterias[posi].Regimen);
              END
              ELSE
              BEGIN
                    WRITELN;
                    WRITELN ('    No existe el Codigo de Materia que pidio modificar');
                    WRITELN;
                    WRITELN ('        Presione cualquier tecla para continuar');
                    READLN;
              END;

END;

{**************************************************************************}

PROCEDURE Guardar_Vector_en_Archivo(VAR PVectorMaterias:TVectorMaterias;
VAR PContVector:BYTE;VAR PMaterias:TArchMaterias);
{Se crea un archivo auxiliar donde se carga el vector con las Altas, Bajas
y Modificaciones. Luego se borra el archivo Materias obviando los registros
con la marca de baja. Se renombra el archivo Auxiliar con el nombre Materias}
VAR
I:BYTE;
AuxMaterias:TArchMaterias;
BEGIN
ASSIGN(AuxMaterias,'DAT\AUXMAT.DAT');
REWRITE(AuxMaterias);
FOR I:=1 TO PContVector DO
BEGIN
IF PVectorMaterias[I].CodigoMateria<>MarcadeBaja
   THEN
   WRITE(AuxMaterias,  PVectorMaterias[I]);
END;
CLOSE (AuxMaterias);
ERASE (PMaterias);
RENAME (AuxMaterias,'DAT\MATERIA.DAT')
END;

{**************************************************************************}

PROCEDURE Control_a_fin (VAR PFin: BOOLEAN; VAR PMaterias: TArchMaterias;
VAR PRegMaterias: TRegMaterias);
{Controla que no sea el fin del archivo, pudiendo realizar la lectura del
ultimo registro sin problemas}

BEGIN

     IF EOF (PMaterias) THEN
     PFin := TRUE
     ELSE
         READ (PMaterias, PRegMaterias)

END;

{**************************************************************************}

PROCEDURE Carteles;
BEGIN
CLRSCR;
          WRITELN ('                    *****************************');
          WRITELN ('                    *  MODULO DE ABM MATERIAS   *');
          WRITELN ('                    *****************************');
          WRITELN;
          WRITELN ('Ingrese:');
          WRITELN ('--------');
          WRITELN;
          WRITELN ('"A" si desea dar de ALTA una Materias');
          WRITELN ('"B" si desea dar de BAJA una Materias');
          WRITELN ('"M" si desea MODIFICAR una Materias');
          WRITELN;
          WRITELN ('Para dejar de realizar operaciones escriba "F"');
          WRITELN;
          WRITE ('Opcion: ');

END;

{**************************************************************************}

PROCEDURE IngresoABM (VAR PABM : CHAR);
{La variable ABM contiene la opcion ingresa por el usuario, controlando
que solo se ingrese las opciones deseadas}
BEGIN
          Carteles;
          PABM:= (ReadKey);
          WHILE (PABM <> 'A') AND (PABM <> 'B') AND (PABM <> 'M')
          AND (PABM <> 'F') DO
          BEGIN
          Carteles;
          PABM:= (ReadKey)
          END;

END;

{**************************************************************************}

PROCEDURE CartelesImpresion;
Begin
CLRSCR;
          WRITELN ('                        ***************');
          WRITELN ('                        *  IMPRESION  *');
          WRITELN ('                        ***************');
          WRITELN;
          WRITELN ('Ingrese:');
          WRITELN ('--------');
          WRITELN;
          WRITELN ('"P" si desea ver pon pantalla el contenido del Archivo MATERIA');
          WRITELN ('"I" si desea imprimir el contenido del Archivo MATERIA');
          WRITELN;
          WRITELN ('Para volver al menu principal "F"');
          WRITELN;
          WRITE ('Opcion: ');
END;

{**************************************************************************}

PROCEDURE Listado_de_Impresion (VAR PMaterias:TArchMaterias;VAR PRegMaterias:TRegMaterias);
{Permite ver el archivo Materias por pantalla o imprimirlo}
VAR
Impresion: CHAR;
Fin:BOOLEAN;
Cont: BYTE;

BEGIN
     CartelesImpresion;
     Impresion:= (ReadKey);
     WHILE (Impresion <> 'P') AND (Impresion <> 'I') AND (Impresion <> 'F') DO
          BEGIN
          CartelesImpresion;
          Impresion:= (ReadKey)
          ENd;

     IF Impresion = 'P' THEN
          BEGIN
          RESET (PMaterias);
          Fin:=False;
          CLRSCR;
          Control_a_fin(Fin,PMaterias,PRegMaterias);
          WHILE NOT Fin DO
          BEGIN
              CONT:=1;
              WRITELN ('Listado del archivo MATERIAS');
              WRITELN ('----------------------------');
              WRITELN ( '__________________________________________________');
              WRITELN ( '| Cod.Materia |   Nombre de Materia  | A¤o | Reg |');
              WRITELN ( '--------------------------------------------------');
          WHILE NOT Fin AND (Cont<17) DO
               BEGIN
               WRITELN ('|',PRegMaterias.CodigoMateria:9,'    | ',
               PRegMaterias.NombreMateria:20,' |',PRegMaterias.Anio:3,'  |',
               PRegMaterias.Regimen:3, '  |');
               INC (Cont);
               Control_a_fin(Fin,PMaterias,PRegMaterias);
               END;
              WRITELN ( '--------------------------------------------------');
              WRITELN ('     Presione cualquier tecla para continuar');
              READKEY;
              CLRSCR;

              END
         END
     ELSE
     IF (Impresion = 'I') THEN
     BEGIN

          RESET (PMaterias);
          CLRSCR;
          WRITELN (LST,'Listado del archivo MATERIAS');
          WRITELN (LST,'----------------------------');
          WRITELN (LST, '__________________________________________________');
          WRITELN (LST, '| Cod.Materia |   Nombre de Materia  | A¤o | Reg |');
          WRITELN (LST, '--------------------------------------------------');
          WHILE NOT (EOF(PMaterias)) do
              BEGIN
              read (PMaterias, PRegMaterias);
              WRITELN (LST, '|',PRegMaterias.CodigoMateria:9,'    | ',
              PRegMaterias.NombreMateria:20,' |',PRegMaterias.Anio:3,'  |',
              PRegMaterias.Regimen:3, '  |');
              END;
              WRITELN (LST, '--------------------------------------------------');

     END
END;

{**************************************************************************}

VAR
VectorMaterias: TVectorMaterias;
ABM: CHAR;
op,ContVector: BYTE;
Materias: TArchMaterias;
RegMaterias: TRegMaterias;

BEGIN  {****PRINCIPAL MATERIAS*****}
     clrscr;
     ASSIGN (Materias,'DAT\MATERIA.DAT');
     Inicializar_Vector(VectorMaterias);
     Cargar_VectorMaterias (VectorMaterias, Materias,ContVector);

    Repeat
      ClrScr;
      GotoXY ( 1,25 ); { Impresion de titulos en pantalla}
      Write ( 'Cantidad de operaciones realizadas hasta el momento : ',ContVector,'/',CantMaxMaterias );
      GotoXY ( 1,1 );
      WriteLN ('ABM Materias');
      op := aChoice ( aMenuMaterias,iOp,1,3 );
      Case Op of
        1 : abm := 'A';
        2 : abm := 'B';
        3 : abm := 'M';
        4 : abm := 'F';
      End; { Case }
      CASE ABM OF
               'A': Cargar_Alta(VectorMaterias, ContVector);
               'B': Cargar_Baja(VectorMaterias, ContVector);
               'M': Cargar_Modificacion(VectorMaterias, ContVector);
      END;
   Until ABM = 'F';

   Guardar_Vector_en_Archivo(VectorMaterias,ContVector,Materias);
{     Listado_de_Impresion (Materias, RegMaterias) }
END;

{**************************************************************************}
{********************* M O D U L O  D E  C U R S O S **********************}
{**************************************************************************}

PROCEDURE ABMCursos;

CONST
  iOp = 4;
  aMenuCursos  : aChoiceArray = ('Altas         ',
  {Opciones del menu}            'Bajas         ',
                                 'Modificaciones',
                                 'Salir         ','','','','','','','');
Ejecuciones=80;
MarcadeBaja=0;
NoEncontrado=-1;

TYPE
    String10 = STRING [10];

    TRegCurso = RECORD
                      Curso: WORD;
                      Materia: LONGINT;
                      Profesor: WORD;
                      Turno: CHAR;
                      Dia1: BYTE;
                      Dia2: BYTE;
                      Aula: WORD;
                      Anexo: String10;
                      END;

    TAltasCursos = ARRAY [1 .. Ejecuciones] OF TRegCurso;

    TArchCurso = FILE OF TRegCurso;

{**************************************************************************}

FUNCTION BusBinaria (VAR PCurso:TArchCurso;PRegCurso:TRegCurso;Dato:word):longint;

Var
   LimInf,LimSup,PuntoMedio:longint;
   Encontrado:boolean;

Begin
     RESET (Pcurso);
     LimInf:=1;
     LimSup:=filesize (PCurso);
     Encontrado:=false;
     WHILE (Not Encontrado) AND (LimInf<=LimSup) do
     BEGIN
          PuntoMedio:=(LimInf+LimSup) div 2;
          Seek (PCurso,PuntoMedio-1);
          read (PCurso,PRegCurso);
          IF PRegCurso.curso=Dato
          THEN
          Encontrado:=True
          Else
              If PRegCurso.curso>dato THEN
              LimSup:=PuntoMedio-1
              Else
                  LimInf:=PuntoMedio+1;
     end;
     IF Encontrado THEN
     BusBinaria:=PuntoMedio
     else
     BusBinaria:=NoEncontrado;
     close (PCurso);
end;

{**************************************************************************}

FUNCTION BusBinariaVec (VAR Vec: TAltasCursos; ContAltas: BYTE; dato:WORD):LONGINT;
Var
   LimInf,LimSup,PuntoMedio:longint;
   Encontrado:boolean;
Begin
     LimInf:=1;
     LimSup:=ContAltas;
     Encontrado:=false;
     WHILE (Not Encontrado) AND (LimInf<=LimSup) DO
     BEGIN
          PuntoMedio:=(LimInf+LimSup) div 2;
          IF Vec[PuntoMedio].Curso=dato THEN
          Encontrado:=True
          Else
              If Vec[PuntoMedio].Curso>dato THEN
              LimSup:=PuntoMedio-1
              Else
                  LimInf:=PuntoMedio+1;
     end;
     IF Encontrado THEN
     BusBinariaVec:=PuntoMedio
     else
     BusBinariaVec:=NoEncontrado;

end;

{**************************************************************************}

PROCEDURE OrdenarVector (VAR Vec: TAltasCursos; Ult: BYTE);

VAR
   Aux: TRegCurso;
   I,Fin:BYTE;
BEGIN
     WHILE Ult>1 DO
     BEGIN
          Fin:=Ult-1;
          Ult:=0;
          FOR I:=1 TO Fin DO
          BEGIN
               IF Vec[I].Curso>Vec[I+1].Curso
               THEN
               BEGIN
                    Aux:=Vec[I];
                    Vec[I]:=Vec[I+1];
                    Vec[I+1]:=Aux;
                    Ult:=I
               END
          END;
     END;
END;

{**************************************************************************}

PROCEDURE Cargar_Alta (VAR PCurso:TArchCurso;VAR PRegCurso:TRegCurso;
VAR PVecAltas:TAltasCursos;VAR PContAltas: BYTE);
{En el Vector se cargan las Altas realizadas por el usuario, previamente se
controla que el Curso que se quiere dar de alta no exista}
VAR
 codigo:WORD;
 encontrado:BOOLEAN;

BEGIN
     CLRSCR;
     WRITELN ('PANTALLA DE ALTAS');
     WRITELN ('-----------------');
     WRITELN;
     WRITE('Ingrese el Curso: ');
     READLN (codigo);

     {Reviso que el c¢digo a ser dado de alta no exista}

     IF BusBinaria (PCurso,PRegCurso,codigo)= NoEncontrado
     THEN
         BEGIN
              IF BusBinariaVec(PVecAltas,PContAltas,codigo)= NoEncontrado THEN
              BEGIN
              encontrado:=false;
              INC(PContAltas)
              END
              ELSE
              encontrado:=true;
          END
     ELSE
         encontrado:=true;

     IF NOT encontrado THEN
     BEGIN
          PVecAltas[PContAltas].Curso:=codigo;
          WRITE('Ingrese el Codigo de la Materia: ');
          READLN(PVecAltas[PContAltas].Materia);
          WRITE('Ingrese el codigo del Profesor a cargo: ');
          READLN(PVecAltas[PContAltas].Profesor);
          WRITE('Ingrese el Turno (M:Ma¤ana, T:Tarde o N:Noche): ');
          READLN(PVecAltas[PContAltas].Turno);
          WRITELN('Ingrese el Primer dia de cursada');
          WRITE('(Lunes:1,Martes:2,Miercoles:3,Jueves:4,Viernes:5,Sabado:6): ');
          READLN(PVecAltas[PContAltas].Dia1);
          WRITELN('Ingrese el Segundo dia de cursada');
          WRITELN('(Lunes:1,Martes:2,Miercoles:3,Jueves:4,Viernes:5,Sabado:6): ');
          WRITE('(Si solo se cursa un dia ingresar "0"): ');
          READLN(PVecAltas[PContAltas].Dia2);
          WRITE('Ingrese el Aula: ');
          READLN(PVecAltas[PContAltas].Aula);
          WRITE('Ingrese el Anexo en donde sera cursada: ');
          READLN(PVecAltas[PContAltas].Anexo);
          OrdenarVector (PVecAltas,PContAltas)
     END
     ELSE
          BEGIN
               WRITELN;
               WRITELN ('El Curso que desea ingresar ya existe');
               WRITELN;
               WRITELN ('Presione cualquier tecla para continuar');
               READKEY;
          END;

END;

{**************************************************************************}

PROCEDURE Cargar_Baja(VAR PCurso:TArchCurso;VAR PRegCurso:TRegCurso;
VAR Vec:TAltasCursos;ContAltas:byte);
{Busca en el Vector de Altas y en el archivo el curso que se desea dar de baja
y cuando lo encuentra, le ingresa una marca de baja}
VAR
   Baja:word;
   Posi:longint;
BEGIN

     CLRSCR;
     WRITELN ('PANTALLA DE BAJAS');
     WRITELN ('-----------------');
     WRITELN;
     WRITE ('Ingrese el Codigo del Curso que desea dar de baja: ');
     READLN (Baja);
     Posi:=BusBinaria (PCurso,PRegCurso,Baja);
     IF Posi <>NoEncontrado THEN
     BEGIN
          RESET (PCurso);
          PRegCurso.curso:=MarcadeBaja;
          SEEK (PCurso,(Posi)-1);
          WRITE (PCurso,PRegCurso);
          WRITELN;
          WRITELN(' El Curso Nø ',Baja,' fue dado de BAJA');
          WRITELN;
          WRITELN('Presione cualquier tecla para continuar');
          READKEY;
          CLOSE (PCurso);
     END
     ELSE
         BEGIN
              Posi:=BusBinariaVec (vec,ContAltas,Baja);
              IF Posi <> NoEncontrado THEN
              BEGIN
              vec[Posi].curso:=MarcadeBaja;
              OrdenarVector (vec,ContAltas);
              WRITELN;
              WRITELN(' El Curso Nø ',Baja,' fue dado de BAJA');
              WRITELN;
              WRITELN('Presione cualquier tecla para continuar');
              READKEY
              END
              ELSE
              BEGIN
              WRITELN;
              WRITELN ('    No existe el curso que pidio dar de baja');
              WRITELN;
              WRITELN ('    Presione cualquier tecla para continuar');
              readkey;
              END;
         END;

END;


{**************************************************************************}

PROCEDURE Cargar_Modificacion (VAR PCurso:TArchCurso;VAR PRegCurso:TRegCurso;
Var Vec:TAltasCursos;ContAltas:byte);
{Busca en el Vector de Altas y en el archivo el curso que se desea modificar
y cuando lo encuentra, le ingresa una marca de baja}
VAR
   Modificaciones:word;
   Posi:longint;
BEGIN
     CLRSCR;
     WRITELN ('PANTALLA DE MODIFICACIONES');
     WRITELN ('--------------------------');
     WRITELN;
     WRITELN('Ingrese el Curso que desea Modificar');
     READLN(Modificaciones);
     Posi:=BusBinaria (PCurso,PRegCurso,Modificaciones);
     IF Posi<>NoEncontrado THEN
     BEGIN
          clrscr;
          RESET (PCurso);
          SEEK (PCurso,(Posi-1));
          READ (PCurso,PRegCurso);
          WRITELN ('PANTALLA DE MODIFICACIONES');
          WRITELN ('--------------------------');
          WRITELN;
          WRITELN ('Los datos actuales del registro son los siguientes:');
          WRITELN ('Curso: ',PRegCurso.Curso);
          WRITELN ('Materia: ',PRegCurso.Materia);
          WRITELN ('Profesor: ',PRegCurso.Profesor);
          WRITELN ('Turno: ',PRegCurso.Turno);
          WRITELN ('Dia 1: ',PRegCurso.Dia1);
          WRITELN ('Dia 2: ',PRegCurso.Dia2);
          WRITELN ('Aula: ',PRegCurso.Aula);
          WRITELN ('Anexo: ',PRegCurso.Anexo);
          WRITELN;
          WRITELN ('INGRESE LOS DATOS A MODIFICAR:');
          WRITELN;
          WRITE('Ingrese el codigo de Materia: ');
          READLN(PRegCurso.materia);
          WRITE('Ingrese el codigo del Profesor a cargo: ');
          READLN(PRegCurso.profesor);
          WRITE('Ingrese el Turno (M:Ma¤ana, T:Tarde o N:Noche:): ');
          READLN(PRegCurso.Turno);
          WRITE('Ingrese el Primer dia de cursada: ');
          READLN(PRegCurso.Dia1);
          WRITE('Ingrese el Segundo dia de cursada: ');
          READLN(PRegCurso.Dia2);
          WRITE('Ingrese el Aula: ');
          READLN(PRegCurso.Aula);
          WRITE('Ingrese el Anexo en donde sera cursada: ');
          READLN(PRegCurso.Anexo);
          SEEK (PCurso,(Posi-1));
          WRITE (PCurso,PRegCurso);
          CLOSE (PCurso);
     END
     ELSE
         BEGIN
              Posi:=BusBinariaVec (Vec, ContAltas, Modificaciones);
              IF Posi<>NoEncontrado THEN
              BEGIN
                   clrscr;
                   WRITELN ('PANTALLA DE MODIFICACIONES');
                   WRITELN ('--------------------------');
                   WRITELN;
                   WRITELN ('Los datos actuales del registro son los siguientes:');
                   WRITELN ('Curso: ',Vec[Posi].Curso);
                   WRITELN ('Materia: ',Vec[Posi].Materia);
                   WRITELN ('Profesor: ',Vec[Posi].Profesor);
                   WRITELN ('Turno: ',Vec[Posi].Turno);
                   WRITELN ('Dia1: ',Vec[Posi].Dia1);
                   WRITELN ('Dia2: ',Vec[Posi].Dia2);
                   WRITELN ('Aula: ',Vec[Posi].Aula);
                   WRITELN ('Anexo: ',Vec[Posi].Anexo);
                   WRITELN;
                   WRITELN ('INGRESE LOS DATOS A MODIFICAR:');
                   WRITELN;
                   WRITE('Ingrse el codigo de Materia:');
                   READLN(Vec[Posi].Materia);
                   WRITE('Ingrese el codigo del Profesor a cargo:');
                   READLN(Vec[Posi].Profesor);
                   WRITE('Ingrese el Turno (M:Ma¤ana, T:Tarde o N:Noche:)');
                   READLN(Vec[Posi].Turno);
                   WRITE('Ingrese el Primer dia de cursada:');
                   READLN(Vec[Posi].Dia1);
                   WRITE('Ingrese el Segundo dia de cursada:');
                   READLN(Vec[Posi].Dia2);
                   WRITE('Ingrese el Aula:');
                   READLN(Vec[Posi].Aula);
                   WRITE('Ingrese el Anexo en donde sera cursada:');
                   READLN(Vec[Posi].Anexo);
              END
              ELSE
                   BEGIN
                        WRITELN ('No existe el curso que desea modificar');
                        WRITELN;
                        WRITELN ('Presione cualquier tecla para continuar');
                        readkey;
                   END;
         END;
END;

{**************************************************************************}

PROCEDURE Control_a_fin (VAR PFin: BOOLEAN; VAR PCurso: TArchCurso;
VAR PRegCurso: TRegCurso);
{Controla que no sea el fin de archivo, garantizando que el ultnimo registro
se leera sin problemas}
BEGIN

     IF EOF (PCurso) THEN
     PFin := TRUE
     ELSE
         READ (PCurso, PRegCurso)

END;

{**************************************************************************}

PROCEDURE Procesar_Apareo (VAR PCurso: TArchCurso;
PContAltas: BYTE; VAR PAltasCursos: TAltasCursos; VAR PRegCurso: TRegCurso);
{Una vez de haber cargado la Altas, Bajas y Modificaciones, realiza el apareo
entre el archivo Cursos y el Vector que contenia las altas en un archivo auxiliar.
Cuando encuentra una marca de baja, no copia el registro en el archivo Auxiliar.
Una vez terminado el apareo, borra el archivo Cursos y renombra el Erchivo Auxiliar
con el nombre Cursos}
VAR
   Fin:boolean;
   i:byte;
   AuxCurso:TArchCurso;
BEGIN
     RESET (Pcurso);
     ASSIGN (AuxCurso,'DAT\auxiliar.dat');
     REWRITE (AuxCurso);
     fin:=false;
     Control_a_fin(Fin,PCurso,PRegCurso);
     i:=1;
     WHILE (NOT Fin) OR (i <= PContAltas) DO
     BEGIN
          IF (i > PContAltas) OR ((NOT Fin) AND
          (PRegCurso.Curso<=PAltasCursos[i].Curso)) THEN
             IF PRegCurso.Curso <> MarcadeBaja THEN
             BEGIN
                  WRITE (AuxCurso, PRegCurso);
                  Control_a_fin(Fin,PCurso,PRegCurso)
             END
             ELSE Control_a_fin(Fin,PCurso,PRegCurso)
          ELSE
             IF PAltasCursos [i].Curso <> MarcadeBaja THEN
             BEGIN
                  WRITE (AuxCurso,PAltasCursos[i]);
                  INC (i)
             END
             ELSE INC (i)
     END;

CLOSE (AuxCurso);
CLOSE (PCurso);
ERASE (PCurso);
RENAME (AuxCurso,'DAT\CURSO.DAT');
END;

{**************************************************************************}

PROCEDURE Carteles;
BEGIN
CLRSCR;
          WRITELN ('                     ***************************');
          WRITELN ('                     *  MODULO DE ABM CURSOS   *');
          WRITELN ('                     ***************************');
          WRITELN;
          WRITELN ('Ingrese:');
          WRITELN ('--------');
          WRITELN;
          WRITELN ('"A" si desea dar de ALTA un Curso');
          WRITELN ('"B" si desea dar de BAJA un Curso');
          WRITELN ('"M" si desea MODIFICAR un Curso');
          WRITELN;
          WRITELN ('Para dejar de ingresar datos escriba "F"');
          WRITELN;
          WRITE ('Opcion: ');

END;

{**************************************************************************}

PROCEDURE IngresoABM (VAR PABM : CHAR);
{En ABM el usuario ingresa si desea trabajar con Altas, Bajas o Modificaciones,
y se controla que solo se ingrese esas opciones}
BEGIN
          Carteles;
          PABM:= (ReadKey);
          WHILE (PABM <> 'A') AND (PABM <> 'B') AND (PABM <> 'M')
          AND (PABM <> 'F')  DO
          BEGIN
          Carteles;
          PABM:= (ReadKey)
          ENd;
END;

{**************************************************************************}

PROCEDURE CartelesImpresion;
Begin
CLRSCR;
          WRITELN ('                        ***************');
          WRITELN ('                        *  IMPRESION  *');
          WRITELN ('                        ***************');
          WRITELN;
          WRITELN ('Ingrese:');
          WRITELN ('--------');
          WRITELN;
          WRITELN ('"P" si desea ver pon pantalla el contenido del Archivo CURSO');
          WRITELN ('"I" si desea imprimir el contenido del Archivo CURSOS');
          WRITELN;
          WRITELN ('Para volver al menu principal "F"');
          WRITELN;
          WRITE ('Opcion: ');
END;

{**************************************************************************}

PROCEDURE Listado_de_Impresion (PRegCurso:TRegCurso; VAR PCurso:TArchCurso);
{Da la posibilidad de ver el contenido del Archivo por pantalla o imprimirlo}

VAR
Impresion: CHAR;
Fin:BOOLEAN;
Cont : BYTE;

BEGIN
     CartelesImpresion;
     Impresion:= (ReadKey);
     WHILE (Impresion <> 'P') AND (Impresion <> 'I') AND (Impresion <> 'F') DO
          BEGIN
          CartelesImpresion;
          Impresion:= (ReadKey)
          ENd;

     IF Impresion = 'P' THEN
       BEGIN
          RESET (PCurso);
          CLRSCR;
          Fin:=False;
          Control_a_fin(Fin,PCurso,PRegCurso);
          WHILE NOT Fin DO
          BEGIN
          Cont:=1;
          WRITELN ('Listado del archivo CURSOS');
          WRITELN ('--------------------------');
          WRITELN('_______________________________________________________________________');
          WRITELN('| Curso | Materia | Profesor | Turno | Dia1 | Dia2 | Aula |   Anexo   |');
          WRITELN('-----------------------------------------------------------------------');
              WHILE  (NOT Fin) AND (Cont<18)   DO
              BEGIN

                   WRITELN ('|',PRegCurso.Curso:5,'  |',PRegCurso.Materia:7,
                   '  |',PRegCurso.Profesor:7,'   |',PRegCurso.Turno:4,'   |',
                   PRegCurso.Dia1:4,'  |',PRegCurso.Dia2:4,'  |',PRegCurso.Aula:4,
                   '  |',PRegCurso.Anexo:10,' |');
                   INC (Cont);
                   Control_a_fin(Fin,PCurso,PRegCurso)
              END;

              WRITELN('-----------------------------------------------------------------------');
              WRITELN ('          Presione cualquier tecla para continuar');
              READKEY;
              CLRSCR;
          END

       END

     ELSE
     IF (Impresion = 'I') THEN
     BEGIN
      RESET (PCurso);
          CLRSCR;
          WRITELN (LST, 'Listado del archivo CURSOS');
          WRITELN (LST, '--------------------------');
          WRITELN(LST,'_______________________________________________________________________');
          WRITELN(LST,'| Curso | Materia | Profesor | Turno | Dia1 | Dia2 | Aula |   Anexo   |');
          WRITELN(LST,'-----------------------------------------------------------------------');
          WHILE NOT (EOF(PCurso)) do
              BEGIN
              READ (PCurso, PRegCurso);
              WRITELN (LST,'|',PRegCurso.Curso:5,'  |',PRegCurso.Materia:7,
              '  |',PRegCurso.Profesor:7,'   |',PRegCurso.Turno:4,'   |',
              PRegCurso.Dia1:4,'  |',PRegCurso.Dia2:4,'  |',PRegCurso.Aula:4,
              '  |',PRegCurso.Anexo:10,' |');
              END;
           WRITELN(LST,'-----------------------------------------------------------------------');
     END
END;


{**************************************************************************}
VAR

   AltasCursos: TAltasCursos;
   ABM: CHAR;
   op,ContAltas: BYTE;
   Curso: TArchCurso;
   RegCurso: TRegCurso;

BEGIN  {****PRINCIPAL CURSOS*****}
    ASSIGN (Curso,'DAT\curso.dat');
    ContAltas:=0;
    Repeat
      ClrScr;
      GotoXY ( 1,25 ); { Impresion de titulos en pantalla}
      Write ( 'Cantidad de operaciones realizadas hasta el momento : ',ContAltas,'/',Ejecuciones );
      GotoXY ( 1,1 );
      WriteLN ('ABM Cursos');
      op := aChoice ( aMenuCursos,iOp,1,3 );
      Case Op of
        1 : abm := 'A';
        2 : abm := 'B';
        3 : abm := 'M';
        4 : abm := 'F';
      End; { Case }
      CASE ABM OF
        'A': Cargar_Alta(Curso,RegCurso,AltasCursos,ContAltas);
        'B': Cargar_Baja(Curso,RegCurso,AltasCursos,ContAltas);
        'M': Cargar_Modificacion(Curso,RegCurso,AltasCursos,ContAltas);
      END;
   Until ABM = 'F';
   Procesar_Apareo (Curso,ContAltas,AltasCursos,RegCurso);;
{     Listado_de_Impresion (RegCurso, Curso); }
END;

End.