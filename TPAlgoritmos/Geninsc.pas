PROCEDURE GeneraInscripciones (VAR lista:tPuntero);
TYPE
  tRegIns = RECORD
             leg:   LONGINT;
             dig:   BYTE;
             curso: WORD;
            END;
  tArchIns = FILE OF tRegIns;
VAR
  ptr:       tPuntero;
  i:         BYTE;
  rIns:      tRegIns;
  aIns:      tArchIns;
BEGIN
  ASSIGN(aIns,'DAT\Inscrip.dat');
  REWRITE(aIns);
  WHILE lista <> NIL DO
    BEGIN
     ptr := lista;
     lista := lista^.sgte;
     i := 1;
     WHILE (ptr^.vCurso[i] > 0) AND (i < 6) DO
       BEGIN
        rIns.leg := ptr^.leg DIV 10;
        rIns.dig := ptr^.leg MOD 10;
        rIns.curso := ptr^.vCurso[i];
        WRITE(aIns,rIns);
        INC(i)
       END;
     DISPOSE(ptr)
    END;
  Close ( aIns );
  ClrScr;
  WriteLn ('Archivo Inscrip.Dat Creado');
  ReadKey;
END;
