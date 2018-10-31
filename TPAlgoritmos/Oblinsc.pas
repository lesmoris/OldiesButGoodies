Procedure ObleaInscripcion ( VAR Lista    : TPuntero;
                                 aVecDias : tVecDias );

Procedure ImprimirPorPantalla ( Lista : TPuntero );
Var
  A,M,D,Dow : Word;
  i         : Byte;
  Ptr       : TPuntero;
  rCurso    : TRegCurso;
Begin
  ClrScr;
  Ptr := Lista;
  GetDate ( A,M,D,Dow );
  WHILE ptr^.sgte <> NIL DO
    BEGIN
      TextColor ( 1 );
      WRITELN ('Fecha: ',d,'/',m,'/',a,'  Legajo:  ',ptr^.leg,'  Nombre:  ',BuscaNombreAlu ( ptr^.leg ) );
      i := 1;
      TextColor ( 7 );
      WRITELN ('Codigo':7,'Asignatura':15,'Curso':15,'Anexo':10,'Aula':10,'Dia I':10,'Dia II':10);
      WHILE (i <= 5) AND (ptr^.vCurso[i] <> 0) DO
        BEGIN
          BuscaPosCurso ( ptr^.vCurso[i],rCurso );
          WRITELN( rCurso.codigomateria :6,
                   BuscaNombreMat ( rCurso.codigomateria ):25,
                   ptr^.vCurso[i]:5,
                   rCurso.anexo  :10,
                   rCurso.aula   :10,
                   aVecDias [ rCurso.dia1 ]   :10,
                   aVecDias [ rCurso.dia2 ]   :10);
          INC(i);
        END; { While }
      ptr := ptr^.sgte;
      IF ptr^.sgte <> NIL
        THEN
          BEGIN
            WRITELN ( Chr ( 10 ) + 'Presione cualquier tecla para mostrar la oblea del',
            ' siguiente alumno');
            WRITELN;
          END { Then }
        ELSE
          BEGIN
            WRITELN;
            WRITELN('Presione cualquier tecla para salir');
          END; { Else }
      READKEY;
    END { While }
End;

Procedure ImprimirPorImpresora ( Lista : TPuntero );
Var
  i,j       : Byte;
  Ptr       : TPuntero;
  A,M,D,Dow : Word;
  rCurso    : TRegCurso;
Begin
  J := 0;
  GetDate ( A,M,D,Dow );
  Ptr := Lista;
  WHILE ptr^.sgte <> NIL DO
    BEGIN
      WRITELN ( LST,'Fecha: ',d,'/',m,'/',a,'  Legajo:  ',ptr^.leg,'  Nombre:  ',BuscaNombreAlu (ptr^.leg));
      I := 1;
      WRITELN(LST,'Codigo        ','Asignatura       ','Curso       ','Anexo      ',
      'Aula       ','Dia I        ','Dia II    ');
      INC ( J,4 );
      WHILE (i <= 5 ) AND ( ptr^.vCurso[i] <> 0 ) DO
        BEGIN
          BUscaPosCurso(ptr^.vCurso[i],rCurso);
          WRITELN(rCurso.codigomateria,'    ',BuscaNombreMat(rCurso.codigomateria),
          '    ',ptr^.vCurso[i],'    ',rCurso.anexo,'    ',rCurso.aula,'    ',
          rCurso.dia1,'    ',rCurso.dia2);
          INC(i);
          INC(j)
        END;
      ptr := ptr^.sgte;
      IF ( J > 40 ) OR ( ptr^.sgte = NIL )
        THEN
          Begin
            If J > 40 Then J := 0;
            WRITE ( LST,CHR(12) ) { Salto de pagina }
          End; { Begin }
    END;
End;

Var
  Op        : Char;
  i,j       : Byte;
  RegCurso  : TRegCurso;
Begin
  Repeat
    ClrScr;
    Write ( 'Desea imprimir por pantalla (P) o por impresora (I)?' );
    Op := UpCase ( ReadKey );
    Case Op Of
     'P': ImprimirPorPantalla ( Lista );
     'I': ImprimirPorImpresora ( Lista );
    END; { Case }
  UNTIL Op in ['P','I']
END;
