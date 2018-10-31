PROCEDURE ProcesaSolins(VAR lista:tPuntero);
                         {Este procedimiento procesa el archivo solins.dat
                          creando una lista con los datos de las inscripciones
                          listas para ser impresas y guardadas en inscrip.dat}
{--- INICIO DEL TYPE GENERAL ---}
TYPE
  {-- INICIO TIPOS DEL MODULO 3 DEL GRUPO 7 (K-1032) --}
      regveccor= record
                  codmat: longint;
                  tipo: char;
                 END;
      tipveccor= array [1..9] of regveccor;
      tiprcurso=record
            curso:word;
            codigomateria:longint;
            profesor:word;
            turno:char;
            dia1:byte;
            dia2:byte;
            aula:word;
            anexo:string[10];
           end;
      tipacurso=file of tiprcurso;
      tipvecalt=ARRAY[1..3] OF BOOLEAN;
      tiprsolins=record
             legajo:longint;
             digito:byte;
             alt:tipvecalt;
            end;
      tipasolins=file of tiprsolins;
      tvecresul=array[1..3] of boolean;
      tmatcur=array[1..5,1..3] of word;
      tregcur=record{estructura de los registros del archivo curso.dat}
            curso:word;
            codmat:longint;
            prof:word;
            turno:char;
            dia1:byte;
            dia2:byte;
            aula:word;
            anexo:string[10]
        end;
      tarchcur=file of tregcur;{archivo de registros del tipo tregcur}

  {-- FIN TIPOS DEL MÓDULO 3 DEL G
  RUPO 7 (K-1032) --}
  
{--- FIN DEL TYPE GENERAL ---}
{-----------------------------------------------------------------------}
{---------------- INICIO DE FUNCIONES Y PROCEDIMIENTOS -----------------}
{-----------------------------------------------------------------------}


{-------------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!-------------------}
{-------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!-------------}
{------------------ INICIO FUNCIONES Y PROCEDIMIENTOS ------------------}
{--------------- DEL MODULO 3 DESARROLLADO POR EL GRUPO ----------------}
{----------------------- Nº 7 DEL CURSO K-1032 -------------------------}

procedure Buscentorno ( pos: integer; var vec: tipveccor; step:shortint);
         type regcor =  record
                             codmat: longint;
                             codmat1:longint;
                             tipo:char
                       end;
               archcor= file of regcor;
         var cont: byte;
             rentor:regcor;
             correla:archcor;
             Salir:boolean;
             posi:longint;
             codma:longint;
         begin
              assign(correla,'DAT\correla.dat');
              reset (correla);
              seek (correla, pos-1);
              read (correla,rentor);
              codma:=rentor.codmat;
              {hago una restricci¢n para no leer posiciones inexistentes}
              if (pos-1+step >=0) and (pos-1+step< filesize(correla)) then
                 begin
                      seek (correla,pos-1+step);
                      read(correla,rentor);
                      {pongo salir en fales para que entre al ciclo}
                      salir:=false;
                      seek (correla,pos+step);
                 end
                 else
                     {pongo salir en true para que NO entre al ciclo}
                     salir:=true;


              {ciclo para buscar todas las mat con igual
              c¢digo que el que me pasaron en codma}
              cont:=0;
              while (rentor.codmat = codma) and not salir do
                    begin
                         {ojo}
                         {writeln (rentor.codmat:10, codma:10, salir);}

                         inc (cont);
                         {como la primer componente la voy a usar
                         para especificar la cant de componentes
                         v lidas del vector, pongo cont+1 }
                         vec[cont+1].codmat:=rentor.codmat1;
                         vec [cont+1].tipo:=rentor.tipo;
                         {por comodidad y claridad}
                         posi:=filepos(correla)-1+step;
                         {controlo para no buscar en posiciones
                         inexistentes}

                         if (posi>= 0) and (posi<filesize(correla)) then
                            begin
                                 seek (correla, posi);
                                 read(correla,rentor)
                            end
                         else
                             salir:=true;
                      end;
                     close (correla);
                     {asigno a la primera componente la cantidad de
                     componentes v lidas que tiene el vector}
                     vec[1].codmat:=cont
         end;

{termina buscentorno, ahora hago busccor que utilizando la b£squeda
binaria busca la materia dada y una de sus posiciones en el arhivo
despu‚s, valiendose del vector que va a dar buscentorno va a generar
un vector con todas las correlativas de una mater¡a y sus
respectivos tipos}

procedure Busccor (codmat: longint; var veccor:tipveccor);
          type regco =  record
                             codmat: longint;
                             codmat1:longint;
                             tipo:char
                       end;
               archcor= file of regco;

            var veccoraux:tipveccor;
                li, ls, pos, pm:integer;
                correla: archcor;
                regcor: regco;

                i,j:byte;
            begin
              assign (correla, 'DAT\correla.dat');
              reset (correla);

              {busqueda binaria para encontrar alg£n registro con
              el campo codmat = al valor dado en codmat}

              li:=1;
              ls:=filesize(correla);
              pos:=0;
              while (li<=ls) and (pos=0) do
                    begin
                         pm:= (li+ls)div 2;
                         seek (correla, pm-1);
                         read (correla, regcor);
                         if regcor.codmat= codmat then
                            pos:= pm
                         else
                              if codmat> regcor.codmat then
                                li:= pm+1
                             else
                                 ls:=pm-1;;
                    end;
                CLose ( correla );
                {me fijo que halla encontraddo algo sino, pongo
                en la primera componente (que uso para indicar
                la cantidad de componentes v lidas del vector)
                un 0 y me voy}
                if pos=0 then
                   veccor[1].codmat:=0
                else
                    begin
                         {uso la funci¢n buscentorno para buscar
                         los registros anteriores en el archivo
                         de la misma materia}
                         buscentorno (pos, veccoraux,  -1 );
                         {por una anomal¡a observada en orto programa}
                         i:=1;
                         {armo la primera parte del vector con los
                         registros que estaban antes de la posici¢n
                         que encontr‚}

                         for i:=2 to veccoraux[1].codmat+1 do
                             begin
                                  veccor[i].codmat:=veccoraux[i].codmat;
                                  veccor[i].tipo:=veccoraux[i].tipo
                             end;
                          {pongo el registro que encontr‚}
                          veccor[i+1].codmat:=regcor.codmat1;
                          veccor[i+1].tipo:=regcor.tipo;

                          {ahora pongo los registros de despu‚s del
                          que encontr‚}
                          buscentorno (pos, veccoraux, 1);
                          j:=i+1;
                          for j:=i+2 to veccoraux[1].codmat+i+1 do
                              begin
                                   veccor[j].codmat:=veccoraux[j-i].codmat;
                                   veccor[j].tipo:=veccoraux[j-i].tipo
                              end;
                          veccor[1].codmat:=j-1
                    end;
            end;
{termina busccor}
{comienza compmat, le pasan un c¢digo de materia,
un legajo y el tipo de correlatividad y la funci¢n
devuelve true solo si el alumno del legajo tiene la
materia firmada o con tp seg£n corresponda

esta funci¢n supone que los registros de tp.dat y final.dat est n
ordenados por c¢digo de materia y luego por legajo}

function compmat (codm:longint; tipo:char; leg:longint; digi:byte):boolean;

         type
             regtpfin =record
                             codmat:longint;
                             leg:longint;
                             dig:byte;
                             fech:longint
                             end;
             archi = file of regtpfin;
             var li,pm, ls: longint;
                 comp1, comp2: comp;
                 arch:archi;
                 rarch:regtpfin;
                 encontro:boolean;
             begin
                 {asigno el archivo seg£n el tipo}
                 if (tipo= 'F')  or (tipo='f') then
                    assign (arch, 'DAT\final.dat')
                 else
                     assign (arch, 'DAT\tp.dat');
                 reset (arch);

                 {utilizando la busqueda binaria me fijo si existe
                 un registro que tenga igual legajo y codigo
                 de materia que el que me piden}
                 li:=1;
                 ls:=filesize(arch);
                 encontro:=false;
                 while (li<=ls) and not encontro  do
                       begin
                            pm:=(li+ls)div 2;
                            seek(arch,pm-1);
                            read(arch,rarch);
                            comp1:=0;
                            comp2:=0;
                            comp1:=comp1+(comp1+1)*rarch.leg*1000000+rarch.dig*100000+rarch.codmat;
                            comp2:=comp2+(comp2+1)*leg*1000000+digi*100000+codm;

                            if comp1=comp2 then
                               encontro:=true
                            else
                                if comp1 < comp2 then
                                   li:=pm+1
                                else
                                   ls:=pm-1;;
                       end;
                 compmat:=encontro;
                 CLOSE(arch);
             end;
             {termina compmat ahora hago compcor que lo que va
             a hacer va a ser con el vector de las
             correlatividades de una materia determinada y usando
             compmat, comprobar que determinado alumno (leg)
             tenga todas las materias necesarias aprobadas o firmadas}

function compcor (leg: longint; dig:byte; var corr:tipveccor): boolean;
         var cont:byte;
             resul: boolean;
         begin
              cont:=1;
              resul:=true;
              while (cont <= corr[1].codmat) and resul do
                    begin
                         resul:=compmat(corr[cont+1].codmat,corr[cont+1].tipo,leg,dig);
                         inc(cont)
                    end;
              {en el caso de no halla ninguna correlativa a la materia,
              corr[1].codmat=0 por lo que no entra al ciclo, de
              este modo result sigue valiendo TRUE}
              compcor:=resul
         end;
              {ahora s¡! la funci¢n principal}
function correlativas (leg: longint; dig: byte; codmat: longint): boolean;
         var veccor: tipveccor;
         begin
              {genero el vector de correlativas y tipos}
              busccor(codmat,veccor);
              {me fijo si el tipo tiene todas las necesarias}
              correlativas:=compcor(leg,dig,veccor)
         end;
{terminan las funciones y proc del modulo de correlativas}


{-------------------- FIN FUNCIONES Y PROCEDIMIENTOS -------------------}
{--------------- DEL MODULO 3 DESARROLLADO POR EL GRUPO ----------------}
{----------------------- Nº 7 DEL CURSO K-1032 -------------------------}
{-----------------------------------------------------------------------} 

{-------------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!-------------------}
{-------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!-------------}
{------------------ INICIO FUNCIONES Y PROCEDIMIENTOS ------------------}
{--------------- DEL MODULO 3 DESARROLLADO POR EL GRUPO ----------------}
{----------------------- Nº 8 DEL CURSO K-1001 -------------------------}


function buscur(var arch:tarchcur;curso:longint):word;
var{esta funcion busca un codigo de curso en un archivo de estructura del tipo tarchcur}
pi,pf,pm,pos:longint;
regcur:tregcur;
begin
  pi:=1;
  pf:=filesize(arch);
  pos:=0;
  while (pos=0) and (pi<=pf) do{busqueda binaria}
   begin
      pm:=(pi+pf)div 2;
      seek(arch,pm);
      read(arch,regcur);
      if curso=regcur.curso then pos:=filepos(arch)
      else if curso<regcur.curso then pf:=pm-1
           else pi:=pm+1
   end;{como no puede haber 2 registros con el mismo Nø de curso no me preocupo de estar en el 1ø registro con ese Nø de curso}
  buscur:=pos{devuelve la posicion del registro con ese codigo de materia, sino devuelve 0}
end;

procedure suphor(var matriz:tmatcur;var cantmat:byte;var resul:tvecresul);
var{este procedimiento verifica si hay o no superposicion horaria entre los cursos que se especifican en matriz}
f,c:byte;
pos:word;
curs:tarchcur;
control:boolean;
mathor:array[1..5,1..3] of tregcur;{matriz que guardara los registros correspondientes a cada uno de los cursos}
x:byte;
begin
    assign(curs,'DAT\curso.dat');
    reset(curs);
    for c:=1 to 3 do{con estos 2 ciclos relleno la matriz mathor con los datos de cada uno de los cursos}
      begin
         for f:= 1 to cantmat do
           begin
              pos:= buscur(curs,matriz[f,c]);{busca en el archivo de cursos el registro que contiene los datos del curso cuyo}
              seek(curs,pos);                {codigo esta en matriz[f,c], y posiciona al archivo}
              read(curs,mathor[f,c])         {por ultimo lo guarda en la matriz mathor en su respectivo lugar}
           end
      end;
    for c:=1 to 3 do{este ciclo dara una vuelta por cada alternativa}
      begin
         x:=1;
         control:=true;
         while (control) and (x<cantmat) do{este ciclo segira hasta que encuentre alguna superposicion horaria o cuando se}
           begin                           {hayan teminado los cursos por comparar}
              for f:=x+1 to cantmat do{compara cada curso con los }
              begin
                if(mathor[f,c].turno=mathor[x,c].turno)and
                ((mathor[f,c].dia1=mathor[x,c].dia1)or(mathor[f,c].dia1=mathor[x,c].dia2)or((mathor[f,c].dia2=mathor[x,c].dia2)
                and(mathor[x,c].dia2<>0))or(mathor[f,c].dia2=mathor[x,c].dia1))
                 then  control:=false
              end;
                if not(control) then resul[c]:=false{si encontro alguna superposicion le asigna falso a la alternativa c}
                else
                 begin
                     resul[c]:=true;{si no encontro superposicion sige comparando incrementando x y asignandole temporalmente}
                     inc(x)         {true al resultado de la alternativa c}
                 end
           end{fin del while}
      end;{fin del for}
      close(curs)
end;


{-------------------- FIN FUNCIONES Y PROCEDIMIENTOS -------------------}
{--------------- DEL MODULO 3 DESARROLLADO POR EL GRUPO ----------------}
{----------------------- Nº 8 DEL CURSO K-1001 -------------------------}
{-----------------------------------------------------------------------}


{--------------------------------------------------------------------------------}
{-- INICIO Función BuscaAno: Devuelve el año al cual pertenece una materia     --}
{--                          determinada, mediante búsqueda binaria.           --}
FUNCTION BuscaAno(materia: LONGINT): BYTE;
VAR
  aMat: tArchMat;
  rMat: tRegMat;
  PI,PF,PM: LONGINT;
  POS:      BOOLEAN;
BEGIN
  ASSIGN(aMat,'DAT\materia.dat');
  RESET(aMat);
  POS := TRUE;
  PI := 0;
  PF := FILESIZE(aMat)-1;
  WHILE POS DO
    BEGIN
     PM := (PI+PF) DIV 2;
     SEEK(aMat,PM);
     READ(aMat,rMat);
     IF materia = rMat.CodigoMateria
        THEN
          POS := FALSE
        ELSE
          IF materia < rMat.CodigoMateria
             THEN
               PF := PM-1
             ELSE
               PI := PM+1
    END;
  BuscaAno := rMat.anio;
  CLOSE(aMat);
END;
{-- FIN Función BuscaAno --}
{--------------------------}

{--------------------------------------------------------------------------------}
{-- INICIO Función BuscaTurno: Devuelve el el turno correspondiente a un curso --}
{--                            mediante búsqueda binaria.                      --}
FUNCTION BuscaTurno(curso: WORD): CHAR;
VAR
  aCurso:   tArchCurso;
  rCurso:   tRegCurso;
  PI,PF,PM: LONGINT;
  POS:      BOOLEAN;
BEGIN
  ASSIGN(aCurso,'DAT\curso.dat');
  RESET(aCurso);
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
  BuscaTurno := rCurso.turno;
  Close ( aCurso );
END;
{-- FIN Función BuscaTurno --}
{----------------------------}

{--------------------------------------------------------------------------------}
{-- INICIO Función Prioridad: Devuelve un número especial que le asigna la     --}
{--                           prioridad al alumno: 123                         --}
{--                           1: (1..5) Representa el mayor año al que         --} 
{--                                     el alumno desea inscribirse.           --}
{--                           2: (0..1) Representa si el alumno desea cursar   --}
{--                                     todas materias de un mismo año.        --}
{--                           3: (0..1) Representa si el alumno desea cursar   --}
{--                                     todas materias en un mismo turno.      --}

FUNCTION Prioridad(vCurso: tVecCurso;maxcurso: BYTE): WORD;
VAR
  aCurso:      tArchCurso;
  rCurso:      tRegCurso;
  aMat:        tArchMat;
  rMat:        tRegMat;
  MatAnoIgual,TurnoIgual: BOOLEAN;
  matant:      LONGINT;
  turant:      CHAR;
  mayorano,i:  BYTE;
  numero:      WORD;
BEGIN
  ASSIGN(aCurso,'DAT\curso.dat');
  ASSIGN(aMat,'DAT\materia.dat');
  RESET(aCurso);
  RESET(aMat);
  MatAnoIgual := TRUE;
  TurnoIgual := TRUE;
  matant := BuscaMateria(vCurso[1]);
  turant := Buscaturno(vCurso[1]);
  mayorano := 0;
  FOR i := 1 TO maxcurso DO
    BEGIN
     IF mayorano < BuscaAno(BuscaMateria(vCurso[i]))
        THEN
          mayorano := BuscaAno(BuscaMateria(vCurso[i]));
     IF (BuscaMateria(vCurso[i]) <> matant) AND MatAnoIgual
        THEN
          MatAnoIgual := FALSE;
     IF (BuscaTurno(vCurso[i]) <> turant) AND TurnoIgual
        THEN
          TurnoIgual := FALSE;
    END;
  IF TurnoIgual THEN numero := 1;
  IF MatAnoIgual THEN numero := numero + 10;
  numero := numero + mayorano * 100;
  Prioridad := numero;
  CLOSE(aCurso);
  CLOSE(aMat)
END;
{-- FIN Función Prioridad --}
{---------------------------}

{-----------------------------------------------------------------------------}
{-- INICIO Procedimiento InsertaNodo: Inserta el nodo dado en la lista dada --}
PROCEDURE InsertaNodo(VAR ptr,lista: tPuntero);
VAR
  ptraux: tPuntero;
BEGIN
  IF (lista = nil) OR (ptr^.codpos > lista^.codpos)
     THEN
       BEGIN
        ptr^.sgte := lista;
        lista := ptr
       END
     ELSE
       BEGIN
        ptraux := lista;
        WHILE (ptraux^.sgte <> nil) AND (ptraux^.sgte^.codpos > ptr^.codpos) DO
          ptraux := ptraux^.sgte;
        ptr^.sgte := ptraux^.sgte;
        ptraux^.sgte := ptr
       END
END;
{-- FIN Procedimiento InsertaNodo --}
{-----------------------------------}   

{--- INICIO VAR GENERAL ---}
VAR
  aErrCor:       tArchError;
  aErrSup:       tArchError;
  aSol:          tArchSol;
  rSol:          tRegSol;
  legant:        LONGINT;
  matalu:        tmatcur;
  error,leido:   BOOLEAN;
  rErr:          tRegError;
  vBooleans:     tvecresul;
  ptr:           tPuntero;
  maxcurso:      BYTE;
  i:             BYTE;
{--- FIN VAR GENERAL ---}

{------------------------------------}
{--- INICIO PROCEDIMIENTO GENERAL ---}
{------------------------------------}
BEGIN
  ASSIGN(aSol,'DAT\Solins.dat');
  ASSIGN(aErrCor,'DAT\ErrorCor.dat');
  ASSIGN(aErrSup,'DAT\ErrorSup.dat');
  RESET(aSol);
  REWRITE(aErrCor);
  REWRITE(aErrSup);
  lista := NIL;
  ptr := NIL;
  leido := TRUE;
  READ(aSol,rSol);
  WHILE NOT EOF(aSOl) DO
    BEGIN
     legant := rSol.leg*10+rSol.dig;
     maxcurso := 0;
     Error := FALSE;
     WHILE leido AND (legant = rSol.leg*10+rSol.dig) DO
       BEGIN
        IF correlativas(rSol.leg,rSol.dig,BuscaMateria(rSol.vAlt[0]))
           THEN
             BEGIN
              INC(maxcurso);
              matalu[maxcurso,1] := rSol.vAlt[0];
              matalu[maxcurso,2] := rSol.vAlt[1];
              matalu[maxcurso,3] := rSol.vAlt[2]
             END
           ELSE
             error := TRUE;
        rErr.leg := rSol.leg;
        rErr.dig := rSol.dig;
        IF NOT EOF(aSol)
           THEN
             READ(aSol,rSol)
           ELSE
             leido := FALSE;
       END;
     IF NOT error
        THEN
          BEGIN
           suphor(matalu,maxcurso,vBooleans);
           IF vBooleans[1]
              THEN
                BEGIN
                 NEW(ptr);
                 FOR i := 1 TO maxcurso DO ptr^.vCurso[i] := matalu[i,1];
                 FOR i := maxcurso+1 TO 5 DO ptr^.vCurso[i] := 0
                END
              ELSE
                IF vBooleans[2]
                   THEN
                     BEGIN
                      NEW(ptr);
                      FOR i := 1 TO maxcurso DO ptr^.vCurso[i] := matalu[i,2];
                      FOR i := maxcurso+1 TO 5 DO ptr^.vCurso[i] := 0
                     END
                   ELSE
                     IF vBooleans[3]
                        THEN
                          BEGIN
                           NEW(ptr);
                           FOR i := 1 TO maxcurso DO ptr^.vCurso[i] := matalu[i,3];
                           FOR i := maxcurso+1 TO 5 DO ptr^.vCurso[i] := 0
                          END
                        ELSE
                          BEGIN
                           error := TRUE;
                           WRITE(aErrSup,rErr)
                          END
          END
        ELSE
          WRITE(aErrCor,rErr);
     IF NOT error
        THEN
          BEGIN
           ptr^.codpos := Prioridad(ptr^.vCurso,maxcurso);
           ptr^.leg := legant;
           InsertaNodo(ptr,lista)
          END
    END;
  CLOSE(aErrSup);
  CLOSE(aErrCor);
  CLOSE(aSol);
END;
{-----------------------------------}
{---- FIN PROCEDIMIENTO GENERAL ----}
{-----------------------------------}
