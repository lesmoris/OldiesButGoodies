Procedure ListarMaterias ( Var Lista    : TPuntero;
                               aVecDias : tVecDias );

Function BuscaLeg ( Var Legajo : Longint ) : Longint;
Var
  Enc      : Boolean;
  Regalu   : tRegAlu;
  Alu      : tArchAlu;
  Pm,Pi,Pf : Longint;

Begin
  Assign( alu,'DAT\Alumnos.dat' );
  Reset ( alu );
  Pi := 1;
  Pf := FileSize ( alu ) - 1;
  Enc:=false;
  While not(enc) do
    Begin
      Pm := (pi+pf) div 2;
      Seek (alu,pm);
      Read (alu,regalu);
      If legajo=regalu.leg*10+regalu.dig
        Then
          enc:=true
        else
          begin
            if legajo < regalu.leg*10+regalu.dig
              then
                pf:=pm-1
              else
                pi:=pm+1
          end; {Else}
    End; {While}
  BuscaLeg := Pm;
  Close ( alu );
End;

Function BuscaPosMat ( Var vMat     : TVecMat;
                           lTopVMat : Longint;
                           Materia  : LongInt ) : Byte;
Var
  PosMat,Pm,Pi,Pf : Longint;
Begin
  Pi := 1;
  Pf := lTopVMat;
  PosMat := 0;
  While PosMat = 0 Do
    Begin
      Pm := ( Pi + Pf ) Div 2;
      If vMat [ Pm ].CodMat = Materia
        Then
          PosMat := Pm
        Else
          If vMat [ Pm ].CodMat > Materia
            Then
              Pf := Pm - 1
            Else
              Pi := PM + 1
    End; { While }
  BuscaPosMat := PosMat;
End;

Procedure InsertaNodo ( Var aMat       : tVecMat;
                            Legajo,
                            Curso,
                            Materia,
                            PosMateria : Longint );
Var
  PtrCurso,
  PtrCursoAux : TPunteroCurso;

  PtrAux,
  PtrLeg,
  PtrLegAux   : TPunteroLeg;

  rCurso : tRegCurso;
Begin
  If ( aMat [ PosMateria ].PtrCurso = Nil ) Or ( Curso < aMat [ PosMateria ].PtrCurso^.Curso )
    Then
      Begin
        New ( PtrCurso );
        PtrCurso^.Curso := Curso;
        PtrCurso^.Pos := BuscaPosCurso ( Curso,rCurso );
        PtrCurso^.PtrLeg := Nil;
        PtrCurso^.Sgte := aMat [ PosMateria ].PtrCurso;
        aMat [ PosMateria ].PtrCurso := PtrCurso;
      End
    Else
      Begin
        PtrCursoAux := aMat [ PosMateria ].PtrCurso;
        While ( PtrCursoAux^.Sgte <> Nil ) AND ( PtrCursoAux^.Sgte^.Curso < Curso ) Do
          PtrCursoAux := PtrCursoAux^.Sgte;
        If PtrCursoAux^.Curso = Curso
          Then
            PtrCurso := PtrCursoAux
          Else
            Begin
              New ( PtrCurso );
              PtrCurso^.Curso := Curso;
              PtrCurso^.Pos := BuscaPosCurso ( Curso,rCurso );
              PtrCurso^.PtrLeg := Nil;
              PtrCurso^.Sgte := PtrCursoAux^.Sgte;
              PtrCursoAux^.Sgte := PtrCurso;
            End;
      End;

  If ( PtrCurso^.PtrLeg = Nil ) OR ( Legajo < PtrCurso^.PtrLeg^.Leg )
    Then
      Begin
        New ( PtrLeg );
        PtrLeg^.Leg := Legajo;
        PtrLeg^.Pos := BuscaLeg ( Legajo );
        PtrLeg^.Sgte := PtrCurso^.PtrLeg;
        PtrCurso^.PtrLeg := PtrLeg;
      End
    Else
      Begin
        PtrLegAux := PtrCurso^.PtrLeg;
        While ( PtrAux^.Sgte <> Nil ) AND ( PtrAux^.Sgte^.Leg > Legajo ) Do
          PtrLegAux := PtrLegAux^.Sgte;
        New ( PtrLeg );
        PtrLeg^.Leg := Legajo;
        PtrLeg^.Pos := BuscaLeg ( Legajo );
        PtrLeg^.Sgte := PtrLegAux^.Sgte;
        PtrLegAux^.Sgte := PtrLeg;
      End;

End; { Procedimiento InsertaNodo }

Procedure ImprimirMaterias ( Var aMat : tVecMat; lTopVecMat : Byte );
Var
  fMat : tArchMat;
  rMat : tRegMat;

  fCurso : tArchCurso;
  rCurso : tRegCurso;

  fAlum  : tArchAlu;
  rAlum  : tRegAlu;

  fProfe : tArchProfe;
  rProfe : tRegProfe;

  i : Byte;

  PtrCursoAux : TPunteroCurso;

  PtrLegAux   : TPunteroLeg;

Begin
 Assign ( fMat,'DAT\Materia.Dat' );
 Assign ( fCurso,'DAT\Curso.Dat' );
 Assign ( fProfe,'DAT\Profesor.Dat' );
 Assign ( fAlum,'DAT\Alumnos.Dat' );
 Reset ( fMat );
 Reset ( fCurso );
 Reset ( fProfe );
 Reset ( fAlum );

 For I := 1 to lTopVecMat Do
  Begin
    While aMat [ I ].PtrCurso <> NIL Do
      Begin
        ClrScr;
        WriteLn ( '      Codigo Materia          Nombre Materia          Curso' );
        WriteLn ( aMat [ I ].CodMat:15,' ',BuscaNombreMat ( aMat [ I ].CodMat ):30,aMat [ I ].PtrCurso^.Curso:13 );
        Seek ( fCurso,aMat [ I ].PtrCurso^.Pos );
        Read ( fCurso,rCurso );
        WriteLn;
        WriteLn ( '        Anexo             Dia1       Dia2          Profesor' );
        WriteLn ( rCurso.Anexo:14,aVecDias [ rCurso.Dia1 ]:17,aVecDias [ rCurso.Dia2 ]:11,rCurso.Profesor:18 );
        WriteLn;
        WriteLn ( '    Legajo                      Nombre                    Mail' );
        While aMat [ I ].PtrCurso^.PtrLeg <> NIL Do
          Begin
            Seek ( fAlum,aMat [ I ].PtrCurso^.PtrLeg^.Pos );
            Read ( fAlum,rAlum );
            WriteLn ( aMat [ I ].PtrCurso^.PtrLeg^.Leg:10,rAlum.NyA:30,rAlum.eMail:30 );
            PtrLegAux := aMat [ I ].PtrCurso^.PtrLeg;
            aMat [ I ].PtrCurso^.PtrLeg := aMat [ I ].PtrCurso^.PtrLeg^.Sgte;
            Dispose ( PtrLegAux );
          End;
        WriteLn;
        PtrCursoAux := aMat [ I ].PtrCurso;
        aMat [ I ].PtrCurso := aMat [ I ].PtrCurso^.Sgte;
        Dispose ( PtrCursoAux );
        ReadKey;
      End;
    CLrScr;
  End;
 Close ( fMat );
 Close ( fCurso );
 Close ( fProfe );
 Close ( fAlum );
End;

Var
  fMat : tArchMat;
  aMat : tVecMat;
  rMat : tRegMat;

  i : Byte;

  PtrListaAux : TPuntero;

  Legajo,
  lTopVecMat  : Longint;
  Materia     : Longint;
  Curso       : Word;
  PosMateria  : Byte;
Begin
  { Carga el contenido del archivo Materia.Dat en el vector aVecMat }
  Assign ( fMat,'DAT\Materia.Dat' );
  Reset ( fMat );
  lTopVecMat := FileSize ( fMat );
  For I := 1 to lTopVecMat Do
    Begin
      Read ( fMat,rMat );
      aMat [ I ].CodMat := rMat.CodigoMateria;
      aMat [ I ].PtrCurso := Nil;
    End;
{  For I := lTopVecMat+1 To 40 Do
    Begin
      aMat [ I ].CodMat := 0;
      aMat [ I ].PtrCurso := Nil;
    End; }
  Close ( fMat );

  PtrListaAux := Lista;
  While PtrListaAux <> Nil Do
    Begin
      Legajo := PtrListaAux^.Leg;
      I := 0;
      While ( i < 5 ) AND ( PtrListaAux^.vCurso [ i+1 ] <> 0 ) Do
        Begin
          Inc ( I );
          Curso := PtrListaAux^.vCurso [ i ];
          Materia := BuscaMateria ( Curso );
          PosMateria := BuscaPosMat ( aMat,lTopVecMat,Materia );
          InsertaNodo ( aMat,Legajo,Curso,Materia,PosMateria );
        End;
      PtrListaAux := PtrListaAux^.Sgte;
    End;

  ImprimirMaterias ( aMat,lTopVecMat );
End;
