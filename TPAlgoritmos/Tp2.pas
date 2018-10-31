Program TP2;
Uses
  Crt,
  Printer,
  Dos,
  Menu,
  Modulo1,
  Modulo2,
  Modulo4;

{$I Pres.Pas}
{$I Procesa.Pas}

Procedure Borrar ( NomArch : String );
Type
  tRegError  = Record
                 Leg : Longint;
                 Dig : Byte;
               End;

  tArchError = File Of tRegError;
Var
 Arch    : tArchError;
 RegArch : tRegError;
Begin
  Assign ( Arch,NomArch );
  Reset ( Arch );
  WriteLn ( ' Legajos con error del archivo ',NomArch );
  WriteLn;
  While Not Eof ( Arch ) do
    Begin
      Read ( Arch,RegArch );
      Writeln ( RegArch.Leg,'-',RegArch.Dig );
    End;
  ReadKey;
  Rewrite ( Arch );
  Close ( Arch );
end;

Const
  iOp = 11;
  aMenu        : aChoiceArray = ('ABM Alumnos           ',
  {Opciones del menu}            'ABM Profesores        ',
                                 'ABM Materias          ',
                                 'ABM Cursos            ',
                                 'ABM Inscripciones     ',
                                 'ABM Correlativas      ',
                                 'Procesar Inscripciones',
                                 'Vaciar ErrCor.DAT     ',
                                 'Vaciar ErrSup.DAT     ',
                                 'Acerca De...          ',
                                 'Salir                 ');
Var
  Op : Byte;

Begin
  Repeat
    Clrscr;
    WriteLn ( 'AyE / Trabajo Practico n§2' );
    WriteLn ( 'K - 1001 / Grupo 5' );
    op := aChoice ( aMenu,iOp,1,4 );
    {OP := 7;}
    Case Op of
      1 : ABMAlumnos;
      2 : ABMProfesores;
      3 : ABMMaterias;
      4 : ABMCursos;
      5 : ABMSolins;
      6 : ABMCorrela;
      7 : ProcesarInscripciones;
      8 : Borrar ( 'DAT\ErrorCor.DAT' );
      9 : Borrar ( 'DAT\ErrorSup.DAT' );
     10 : AcercaDe;
    End { Case }
  Until Op = 11;
End.
