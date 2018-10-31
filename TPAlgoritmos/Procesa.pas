PROCEDURE ProcesarInscripciones;
TYPE
  tRegError    =   RECORD
                    leg: LONGINT;
                    dig: BYTE
                   END;
  tArchError   =   FILE OF tRegError;

  tVecAlt      =   ARRAY[0..2] OF WORD;

  tRegSol      =   RECORD
                    leg: LONGINT;
                    dig: BYTE;
                    vAlt: tVecAlt;
                   END;
  tArchSol     =   FILE OF tRegSol;

  { Tipo de puntero de la lista a usar }
  tVecCurso    =   ARRAY [1..5] OF WORD;
  tPuntero     =   ^tNodo;
  tNodo        =   RECORD
                    leg    : LONGINT;
                    codpos : WORD;
                    vCurso : tVecCurso;
                    sgte   : tPuntero
                   END;
  {------------------------------------}

  tRegProfe    =   RECORD
                     Legajo : Word;
                     Nombre : String [ 20 ];
                     Calle  : String [ 10 ];
                     Numero : Word;
                     Tel    : Longint;
                     eMail  : String [ 35 ];
                    END;
  tArchprofe   =   FILE OF tRegProfe;

  tRegCurso    =   RECORD
                    curso:         WORD;
                    codigomateria: LONGINT;
                    profesor:      WORD;
                    turno:         CHAR;
                    dia1:          BYTE;
                    dia2:          BYTE;
                    aula:          WORD;
                    anexo:         STRING[10]
                   END;
  tArchCurso   =   FILE OF tRegCurso;

  tRegMat      =   RECORD
                    CodigoMateria: LONGINT;
                    NombreMateria: STRING[20];
                    anio:          BYTE;
                    regimen:       CHAR;
                   END;
  tArchMat     =   FILE OF tRegMat;

  tMatAlu      =   ARRAY [1..6,1..3] OF WORD;
  tRegAlu      =   RECORD
                    leg:         LONGINT;
                    dig:         BYTE;
                    NyA:         STRING[20];
                    AnioIngreso: WORD;
                    tel:         LONGINT;
                    email:       STRING[20];
                   END;
  tArchAlu     =   FILE OF tRegAlu;

  Str20        =   STRING[20];

  tPunteroLeg   = ^tNodoLeg;
  tNodoLeg      = RECORD
                   leg:  LONGINT;
                   pos:  LONGINT;
                   sgte: tPunteroLeg;
                  END;

  tPunteroCurso = ^TNodoCurso;
  tNodoCurso    = RECORD
                   curso  : WORD;
                   POS    : LONGINT;
                   ptrleg : tPunteroLeg;
                   sgte   : tPunteroCurso;
                  END;

  tVecMat      =   array[1..40] of RECORD
                                    codmat: LONGINT;
                                    ptrCurso:    tPunteroCurso;
                                   END;

  tVecDias     = array [ 0..6 ] of String;

{--------------------------------------------------------------------------------}
{-- INICIO Función BuscaMateria: Devuelve el número de materia correspondiente --}
{--                              a un curso, mediante búsqueda binaria.        --}
Function BuscaMateria ( Curso : Word ) : Longint;
Var
  aCurso   : TArchCurso;
  rCurso   : tRegCurso;
  PI,PF,PM : LONGINT;
  POS      : BOOLEAN;
BEGIN
  Assign (aCurso,'DAT\Curso.DAT');
  Reset (aCurso);
  PI := 0;
  PF := FILESIZE(aCurso)-1;
  POS := TRUE;
  WHILE POS DO
    BEGIN
     PM := (PI+PF) DIV 2;
     SEEK(aCurso,PM);
     READ(aCurso,rCurso);
     IF curso = rCurso.curso
        THEN
          POS := FALSE
        ELSE
          IF curso > rCurso.curso
             THEN
               PI := PM+1
             ELSE
               PF := PM-1;
    END;
  BuscaMateria := rCurso.codigomateria;
  Close ( aCurso );
END;

Function BuscaPosCurso (     Curso    : Word;
                         Var RegCurso : TRegCurso ) : Longint;
Var
  pm,
  pi,
  pf     : Longint;
  enc    : Boolean;
  aCurso : TArchCurso;

Begin
  Assign ( aCurso,'DAT\Curso.Dat' );
  Reset ( aCurso );
  pi := 0;
  pf := Filesize ( aCurso ) - 1;
  enc := False;
  While not ( enc ) do
    begin
      Pm := ( pi + pf ) div 2;
      Seek ( aCurso,Pm );
      Read ( aCurso,RegCurso );
      If Curso = RegCurso.Curso
        Then
          Enc := True
        Else
          Begin
            If curso < regcurso.curso
              Then
                Pf := Pm - 1
              Else
                Pi := Pm + 1
          End; { Else }
    End; { While }
  BuscaPosCurso := Pm;
  Close ( aCurso );
end;

Function BuscaNombreAlu ( VAR Legajo : Longint  ) : Str20;
Var
  Pm,Pi,Pf : Longint;
  Enc      : Boolean;
  RegAlu   : tRegAlu;
  aAlu     : tArchAlu;

Begin
  Assign ( aAlu,'DAT\Alumnos.Dat' );
  Reset ( aAlu );
  Pi := 0;
  Pf := FileSize ( aAlu ) - 1;
  Enc := False;
  While Not ( Enc ) do
    Begin
      Pm := ( pi+pf )div 2;
      Seek ( aAlu,pm );
      Read ( aAlu,RegAlu );
      If Legajo = RegAlu.Leg * 10 + RegAlu.Dig
        Then
          Enc := True
        Else
          Begin
            If Legajo < RegAlu.Leg * 10 + RegAlu.Dig
              Then
                Pf := Pm - 1
              Else
                Pi := Pm + 1
          End; { Else }
    End; { While }
  BuscaNombreAlu := RegAlu.NyA;
  Close ( aAlu );
End; { BuscaNombreAlu }

Function BuscaNombreMat ( Var CodMat : Longint ) : Str20;
Var
  Pm,Pi,Pf : Longint;
  Enc      : Boolean;
  RegMat   : tRegMat;
  aMat     : tArchMat;
Begin
  Assign ( aMat,'DAT\Materia.Dat' );
  Reset ( aMat );
  Pi := 0;
  Pf := Filesize ( aMat ) - 1;
  Enc := False;
  While Not Enc do
    Begin
      Pm := (Pi+Pf) div 2;
      Seek ( aMat,Pm );
      Read ( aMat,RegMat );
      If CodMat = RegMat.CodigoMateria
        Then
          Enc := True
        Else
          Begin
            If CodMat < RegMat.CodigoMateria
              Then
                Pf := Pm - 1
              Else
                Pi := Pm + 1
          End; { Else }
    End; { While }
  BuscaNombreMat := RegMat.NombreMateria;
  Close ( aMat );
End; { BuscaNombreMat }

Procedure CreaVecDias ( VAR aVec : tVecDias );
Begin
  aVec [ 0 ] := '------';
  aVec [ 1 ] := 'Lunes';
  aVec [ 2 ] := 'Martes';
  aVec [ 3 ] := 'Miercoles';
  aVec [ 4 ] := 'Jueves';
  aVec [ 5 ] := 'Viernes';
  aVec [ 6 ] := 'Sabado';
End;

{$I ProcSol.pas}
{$I OblInsc.pas}
{$I ListMat.pas}
{$I GenInsc.pas}

Const
  iOp = 4;
  aMenuProc    : aChoiceArray = ('Generar obleas de inscripcion',
                                 'Generar listado de materias  ',
                                 'Inscribir                    ',
                                 'Salir                        ','','','','','','','');
Var
   op    : byte;
   lista : tPuntero;
   vMat  : tVecMat;
   ptr   : tPuntero;
   aVecDias : tVecDias;
BEGIN
   Lista := NIL;
   CreaVecDias ( aVecDias );
   ProcesaSolins ( Lista );
   ObleaInscripcion ( Lista,aVecDias );
   ListarMaterias ( Lista,aVecDias );
   GeneraInscripciones ( Lista );
   WHILE lista <> NIL DO
     BEGIN
      ptr := lista;
      lista := lista^.sgte;
      DISPOSE(ptr)
     END
END;
