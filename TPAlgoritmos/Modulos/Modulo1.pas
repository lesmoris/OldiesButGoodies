Unit Modulo1;
Interface

Procedure ABMAlumnos;
Procedure ABMProfesores;

Implementation
Uses Crt,Menu;

Procedure ABMAlumnos;
Const
  iOp = 5;
  aMenuAlumnos : aChoiceArray = ('Altas         ',
  {Opciones del menu}            'Bajas         ',
                                 'Modificaciones',
                                 'Listado       ',
                                 'Salir         ','','','','','','');
Type
  tcadena10=string[10];
  tcadena20=string[20];
  tcadena35=string[35];
  tr_alumno=record
    legajo:longint;
    digito:byte;
    nom_ap:tcadena20;
    anio_ing:word;
    tel:longint;
    mail:tcadena20;
  end;
  ta_alumno=file of tr_alumno;
  tv_alumno=array[1..20] of tr_alumno;

  tr_legajo=record
    legajo:longint;
    digito:byte;
  end;


procedure listado_alumnos(var a_alumno18:ta_alumno);
var
  r_alumno:tr_alumno;
begin
  reset(a_alumno18);
  clrscr;
  while not eof (a_alumno18) do
  begin
    read(a_alumno18,r_alumno);
    writeln(r_alumno.legajo:5,'  ',r_alumno.digito:1,'  ',r_alumno.nom_ap:20,'  ',r_alumno.anio_ing:4,'  ',
    r_alumno.tel:8,'  ',r_alumno.mail);
    readkey;
  end;
end;

procedure busqueda_binaria_alumnos(var a_alumno1:ta_alumno;r_legajo1:tr_legajo;var esta1:boolean;var pos1:word);
var
  min,med,max:longint;
  r_alumno:tr_alumno;
begin
 min:=0;
 max:=(filesize(a_alumno1)) - 1;
 med:=(min + max) div 2;
 seek(a_alumno1,med);
 read(a_alumno1,r_alumno);
 while (min <= max) and ((r_alumno.legajo <> r_legajo1.legajo) or ((r_alumno.legajo = r_legajo1.legajo)
 and (r_alumno.digito <> r_legajo1.digito))) do
 begin
   if ((r_alumno.legajo < r_legajo1.legajo) or ((r_alumno.legajo = r_legajo1.legajo)
    and (r_alumno.digito < r_legajo1.digito)))
   then
     min:=med + 1
   else
     max:=med - 1;
   med:=(min + max) div 2;
   seek(a_alumno1,med);
   read(a_alumno1,r_alumno);
 end;
 if min > max
 then
   esta1:=false
 else
 begin
   esta1:=true;
   pos1:=med;
 end;
end;

procedure termino_alumnos(var contalum3:byte;var alumnos3:boolean);
begin
 if contalum3 = 20
 then
   alumnos3:=false
 else
   alumnos3:=true;
end;

procedure busqueda_vector_alumnos(Var v_alumno15:tv_alumno;topealum15:byte;
Var encontrado15:boolean;Var posic15:byte;r_legajo:tr_legajo);
var
  I:byte;
begin
  I:=0;
  encontrado15:=false;
  while (I <= topealum15) and (not encontrado15) do
  begin
    inc(I);
      if ((v_alumno15[I].legajo = r_legajo.legajo) and (v_alumno15[I].digito = r_legajo.digito))
      then
      begin
        posic15:=I;
        encontrado15:=true;
      end
      else
        encontrado15:=false
  end;
end;

procedure altas_alumnos(var a_alumno5:ta_alumno;var v_alumno5:tv_alumno;
var alumnos5:boolean;var contalum5:byte;var topealum5:byte);
var
  fin:boolean;
  opcion4:char;
  r_legajo:tr_legajo;
  encontrado,esta:boolean;
  pos:word;
  posic:byte;
begin
  fin:=false;
  repeat
      clrscr;
      write('Ingrese el n£mero de legajo: ');
      readln(r_legajo.legajo);
      write('Ingrese el digito: ');
      readln(r_legajo.digito);
      busqueda_binaria_alumnos(a_alumno5,r_legajo,esta,pos);
      if esta
      then
        writeln('El legajo ya existe: ')
      else
      begin
        busqueda_vector_alumnos(v_alumno5,topealum5,encontrado,posic,r_legajo);
        if encontrado
        then
           writeln('El legajo ya existe: ')
        else
        begin
          inc(topealum5);
          v_alumno5[topealum5].legajo:=r_legajo.legajo;
          v_alumno5[topealum5].digito:=r_legajo.digito;
          write('Ingrese el Nombre y Apellido: ');
          readln(v_alumno5[topealum5].nom_ap);
          write('Ingrese el a¤o ingreso: ');
          readln(v_alumno5[topealum5].anio_ing);
          write('Ingrese el tel‚fono: ');
          readln(v_alumno5[topealum5].tel);
          write('Ingrese el e_mail: ');
          readln(v_alumno5[topealum5].mail);
          inc(contalum5);
        end;
      end;
      write('¨Desea realizar otra alta?: S/N');
      repeat
        opcion4:=upcase(readkey);
      until ((opcion4 = 'S') or (opcion4 = 'N'));
      if opcion4 = 'S'
      then
        fin:=false
      else
        fin:=true;
      termino_alumnos(contalum5,alumnos5);
  until ((opcion4='N') or (not alumnos5));
end;

procedure bajas_alumnos(var a_alumno7:ta_alumno;
var v_alumno7:tv_alumno;var alumnos7:boolean;var contalum7:byte;topealum7:byte);
var
  fin:boolean;
  r_legajo:tr_legajo;
  opcion4:char;
  encontrado,esta:boolean;
  pos:word;
  posic:byte;
  r_alumno:tr_alumno;

begin
  repeat
      clrscr;
      write('Ingrese el n£mero de legajo: ');
      readln(r_legajo.legajo);
      write('Ingrese el d¡gito: ');
      readln(r_legajo.digito);
      busqueda_binaria_alumnos(a_alumno7,r_legajo,esta,pos);
      if esta
      then
      begin
        seek(a_alumno7,pos);
        read(a_alumno7,r_alumno);
        r_alumno.legajo:=0;
        r_alumno.digito:=0;
        seek(a_alumno7,pos);
        write(a_alumno7,r_alumno);
        inc(contalum7);
      end
      else
      begin
        busqueda_vector_alumnos(v_alumno7,topealum7,encontrado,posic,r_legajo);
        if encontrado
          then
          begin
            v_alumno7[posic].legajo:=0;
            v_alumno7[posic].digito:=0;
            inc(contalum7);
          end
          else
            writeln('No se encontr¢ el legajo');
      end;
    write('¨Desea realizar otra baja?: S/N');
    repeat
      opcion4:=upcase(readkey);
    until ((opcion4='S') or (opcion4='N'));
    if opcion4 = 'S'
    then
      fin:=false
    else
      fin:=true;
      termino_alumnos(contalum7,alumnos7);
  until ((opcion4='N') or (not alumnos7));
end;

procedure modificaciones_alumnos(var a_alumno9:ta_alumno;var v_alumno9:tv_alumno;
var alumnos9:boolean;var contalum9:byte;var topealum9:byte);
var
  r_legajo:tr_legajo;
  opcion4,opcion5:char;
  fin:boolean;
  encontrado,esta:boolean;
  pos:word;
  posic:byte;
  r_alumno:tr_alumno;
begin
  repeat
      clrscr;
      write('Ingrese el n£mero de legajo: ');
      readln(r_legajo.legajo);
      write('Ingrese el d¡gito: ');
      readln(r_legajo.digito);
      busqueda_binaria_alumnos(a_alumno9,r_legajo,esta,pos);
      if esta
      then
      begin
        inc(topealum9);
        seek(a_alumno9,pos);
        read(a_alumno9,r_alumno);
        v_alumno9[topealum9].legajo:=r_alumno.legajo;
        v_alumno9[topealum9].digito:=r_alumno.digito;
        v_alumno9[topealum9].nom_ap:=r_alumno.nom_ap;
        v_alumno9[topealum9].anio_ing:=r_alumno.anio_ing;
        v_alumno9[topealum9].tel:=r_alumno.tel;
        v_alumno9[topealum9].mail:=r_alumno.mail;
        seek(a_alumno9,pos);
        read(a_alumno9,r_alumno);
        r_alumno.legajo:=0;
        r_alumno.digito:=0;
        seek(a_alumno9,pos);
        write(a_alumno9,r_alumno);
        repeat
          clrscr;
          writeln('1_ Legajo');
          writeln('2_ D¡gito');
          writeln('3_ Nombre y Apellido');
          writeln('4_ A¤o de Ingreso');
          writeln('5_ Tel‚fono');
          writeln('6_ E_Mail');
          writeln('7_ Salir');
          writeln('Ingrese la opci¢n que desea modificar: ');
          repeat
            opcion5:=upcase(readkey);
          until opcion5 in ['1'..'7'];
          clrscr;
          case opcion5 of
            '1':
            begin
              write('Ingrese el n£mero de legajo: ');
              readln(v_alumno9[topealum9].legajo);
            end;
            '2':
            begin
              write('Ingrese el d¡gito: ');
              readln(v_alumno9[topealum9].digito);
            end;
            '3':
            begin
              write('Ingrese el Nombre y Apellido: ');
              readln(v_alumno9[topealum9].nom_ap);
            end;
            '4':
            begin
              write('Ingrese el a¤o de ingreso: ');
              readln(v_alumno9[topealum9].anio_ing);
            end;
            '5':
            begin
             write('Ingrese el tel‚fono: ');
             readln(v_alumno9[topealum9].tel);
            end;
            '6':
            begin
              write('Ingrese el E_mail: ');
              readln(v_alumno9[topealum9].mail);
            end;
          end;
        until opcion5='7';
        inc(contalum9);
      end
      else
      begin
        busqueda_vector_alumnos(v_alumno9,topealum9,encontrado,posic,r_legajo);
        if encontrado
        then
        begin
          repeat
            clrscr;
            writeln('1_ Legajo');
            writeln('2_ D¡gito');
            writeln('3_ Nombre y Apellido');
            writeln('4_ A¤o de Ingreso');
            writeln('5_ Tel‚fono');
            writeln('6_ E_Mail');
            writeln('7_ Salir');
            writeln('Ingrese la opci¢n que desea modificar: ');
            repeat
              opcion5:=upcase(readkey);
            until opcion5 in ['1'..'7'];
            clrscr;
            case opcion5 of
              '1':
              begin
                write('Ingrese el n£mero de legajo: ');
                readln(v_alumno9[posic].legajo);
              end;
              '2':
              begin
                write('Ingrese el d¡gito: ');
                readln(v_alumno9[posic].digito);
              end;
              '3':
              begin
                write('Ingrese el Nombre y Apellido: ');
                readln(v_alumno9[posic].nom_ap);
              end;
              '4':
              begin
                write('Ingrese el a¤o de ingreso: ');
                readln(v_alumno9[posic].anio_ing);
              end;
              '5':
              begin
               write('Ingrese el tel‚fono: ');
               readln(v_alumno9[posic].tel);
              end;
              '6':
              begin
                write('Ingrese el E_mail: ');
                readln(v_alumno9[posic].mail);
              end;
            end;
          until opcion5='7';
          inc(contalum9);
        end
      else
        writeln('No se encontr¢ el legajo');
  end;
    write('¨Desea realizar otra modificaci¢n?: S/N');
    repeat
      opcion4:=upcase(readkey);
    until ((opcion4='S') or (opcion4='N'));
    if opcion4 = 'S'
    then
      fin:=false
    else
      fin:=true;
    termino_alumnos(contalum9,alumnos9);
  until ((opcion4='N') or (not alumnos9));
end;

procedure ordena_alumnos(var v_alumno11:tv_alumno;topealum11:byte);
var
  I,fin:byte;
  r_auxalum:tr_alumno;
begin
  while (topealum11 > 1) do
  begin
    fin:=(topealum11 - 1);
    topealum11:=0;
    for I:=1 to fin do
      if (v_alumno11[I].legajo > v_alumno11[I+1].legajo) or ((v_alumno11[I].legajo = v_alumno11[I+1].legajo)
      and (v_alumno11[I].digito > v_alumno11[I+1].digito))
      then
      begin
        r_auxalum:=v_alumno11[I];
        v_alumno11[I]:=v_alumno11[I+1];
        v_alumno11[I+1]:=r_auxalum;
        topealum11:=I;
      end;
  end;
end;

procedure Aparea_alumnos(var a_alumno13:ta_alumno;v_alumno13:tv_alumno;
topealum13:byte;var a_auxalum13:ta_alumno);

procedure leerarch(var arch:ta_alumno;var reg:tr_alumno;var fin:boolean);
begin
     if not eof(arch) then
        begin
        read(arch,reg);
        fin:=false;
        end
     else
         fin:=true;
end;

var
  I:byte;
  fin:boolean;
  r_alumno,r_auxalum:tr_alumno;
begin
  I:=1;
  reset(a_alumno13);
  leerarch(a_alumno13,r_alumno,fin);
  while (not fin) or (I <= topealum13) do
  begin
    if (not fin) and ((I > topealum13) or ((r_alumno.legajo < v_alumno13[topealum13].legajo)
    or ((r_alumno.legajo = v_alumno13[topealum13].legajo) and (r_alumno.digito < v_alumno13[topealum13].digito))))
      then
        if ((r_alumno.legajo <> 0) or (r_alumno.digito <> 0))
        then
        begin
          r_auxalum:=r_alumno;
          write(a_auxalum13,r_auxalum);
          leerarch(a_alumno13,r_alumno,fin);
        end
        else
            leerarch(a_alumno13,r_alumno,fin)

      else
        if ((v_alumno13[I].legajo <> 0) or (v_alumno13[I].digito <> 0))
        then
        begin
          r_auxalum:=v_alumno13[I];
          write(a_auxalum13,r_auxalum);
          inc(I);
        end
        else
        inc(I);
  end;
      close(a_alumno13);
      close(a_auxalum13);
      erase(a_alumno13);
      rename(a_auxalum13,'DAT\alumnos.dat');

end;
Var
  opcion2:char;
  r_alumno:tr_alumno;
  r_auxalum:tr_alumno;
  a_alumno:ta_alumno;
  a_auxalum:ta_alumno;
  v_alumno:tv_alumno;
  op,topealum,contalum:byte;
  alumnos:boolean;
Begin
  assign(a_alumno,'Dat\Alumnos.dat');
  assign(a_auxalum,'Dat\Auxalum.dat');
  reset(a_alumno);
  rewrite(a_auxalum);
  contalum:=0;
  topealum:=0;
        repeat
          clrscr;
          GotoXY ( 1,25 ); { Impresion de titulos en pantalla}
          Write ( 'Cantidad de operaciones realizadas hasta el momento : ',contAlum,'/20' );
          GotoXY ( 1,1 );
          WriteLn ( 'ABM Alumnos' );
          op := aChoice ( aMenuAlumnos,iOp,1,3 );
          Case op of
            1 : opcion2 := 'A';
            2 : opcion2 := 'B';
            3 : opcion2 := 'M';
            4 : opcion2 := 'L';
            5 : opcion2 := 'S';
          End;
          clrscr;
          case opcion2 of
            'A':
            begin
              writeln('Altas');
              altas_alumnos(a_alumno,v_alumno,alumnos,contalum,topealum);
            end;
            'B':
            begin
              writeln('Bajas');
              bajas_alumnos(a_alumno,v_alumno,alumnos,contalum,topealum);
            end;
            'M':
            begin
              writeln('Modificaciones');
              modificaciones_alumnos(a_alumno,v_alumno,alumnos,contalum,topealum);
            end;
            'L':
            begin
              writeln('Listado de Alumnos');
              listado_alumnos(a_alumno);
            end;
          end;
        until ((opcion2='S') or (not alumnos));
  if (topealum > 0)
  then
    begin
      ordena_alumnos(v_alumno,topealum);
      aparea_alumnos(a_alumno,v_alumno,topealum,a_auxalum);
    end
  else
    begin
      erase ( a_auxalum );
    end;
End;

Procedure ABMProfesores;
Const
  iOp = 5;
  aMenuProfesores : aChoiceArray = ('Altas         ',
  {Opciones del menu}               'Bajas         ',
                                    'Modificaciones',
                                    'Listado       ',
                                    'Salir         ','','','','','','');
Type
  tcadena10=string[10];
  tcadena20=string[20];
  tcadena35=string[35];
  tr_profesor=record
    legajo:word;
    nombre:tcadena20;
    calle:tcadena10;
    numero:word;
    tel:longint;
    mail:tcadena35;
  end;
  ta_profesor=file of tr_profesor;
  tv_profesor=array[1..30] of tr_profesor;

procedure listado_profesores(var a_profesor17:ta_profesor);
var
  r_profesor:tr_profesor;
begin
  reset(a_profesor17);
  clrscr;
  while not eof (a_profesor17) do
  begin
    read(a_profesor17,r_profesor);
    writeln(r_profesor.legajo:4,'  ',r_profesor.nombre:30,'  ',r_profesor.calle:15,'  ',r_profesor.numero:10,'  ',
    r_profesor.tel);
   readkey;
  end;
end;

procedure busqueda_binaria_profesores(var a_profesor2:ta_profesor;legajo2:word;var esta2:boolean;var pos2:word);
var
  min,med,max:longint;
  r_profesor:tr_profesor;
begin
 min:=0;
 max:=(filesize(a_profesor2)) - 1;
 med:=(min + max) div 2;
 while (min <= max) and (r_profesor.legajo <> legajo2) do
 begin
   seek(a_profesor2,med);
   read(a_profesor2,r_profesor);
   if r_profesor.legajo < legajo2
   then
     min:=med + 1
   else
     max:=med - 1;
   med:=(min + max) div 2;
 end;
 if min > max
 then
   esta2:=false
 else
 begin
   esta2:=true;
   pos2:=med;
 end;
end;

procedure termino_profesores(var contprof4:byte;var profesores4:boolean);
begin
  if contprof4 = 30
  then
    profesores4:=false
  else
    profesores4:=true;
end;

procedure busqueda_vector_profesores(Var v_profesor16:tv_profesor;Var topeprof16:byte;
Var encontrado16:boolean;Var posic16:byte;legajo:word);
var
  I:byte;
begin
  I:=0;
  encontrado16:=false;
  while (I <= topeprof16) and (not encontrado16) do
  begin
   inc(I);
   if v_profesor16[I].legajo = legajo
    then
    begin
      posic16:=I;
      encontrado16:=true;
    end
    else
      encontrado16:=false;
  end;
end;

procedure altas_profesores(var a_profesor6:ta_profesor;var v_profesor6:tv_profesor;
var contprof6:byte;var profesores6:boolean;var topeprof6:byte);
var
  fin:boolean;
  opcion4:char;
  legajo:word;
  encontrado,esta:boolean;
  pos:word;
  posic:byte;
begin
  repeat
     clrscr;
     write('Ingrese el n£mero de legajo: ');
     readln(legajo);
     busqueda_binaria_profesores(a_profesor6,legajo,esta,pos);
     if esta
     then
       writeln('El legajo ya existe: ')
     else
     begin
       busqueda_vector_profesores(v_profesor6,topeprof6,encontrado,posic,legajo);
       if encontrado
       then
         writeln('El legajo ya fue agregado: ')
       else
       begin
         inc(topeprof6);
         v_profesor6[topeprof6].legajo:=legajo;
         write('Ingrese el Nombre: ');
         readln(v_profesor6[topeprof6].nombre);
         write('Ingrese la calle: ');
         readln(v_profesor6[topeprof6].calle);
         write('Ingrese el n£mero: ');
         readln(v_profesor6[topeprof6].numero);
         write('Ingrese el tel‚fono: ');
         readln(v_profesor6[topeprof6].tel);
         write('Ingrese el e_mail: ');
         readln(v_profesor6[topeprof6].mail);
         inc(contprof6);
       end;
     end;
     write('¨Desea realizar otra alta?: S/N');
     repeat
       opcion4:=upcase(readkey);
     until ((opcion4='S') or (opcion4='N'));
     if opcion4 = 'S'
     then
       fin:=false
     else
       fin:=true;
     termino_profesores(contprof6,profesores6);
  until ((opcion4='N') or (not profesores6));
end;

procedure bajas_profesores(var a_profesor8:ta_profesor;var v_profesor8:tv_profesor;
var contprof8:byte;var profesores8:boolean;topeprof8:byte);
var
  fin:boolean;
  legajo:word;
  opcion4:char;
  encontrado,esta:boolean;
  pos:word;
  posic:byte;
  r_profesor:tr_profesor;
begin
  repeat
      clrscr;
      write('Ingrese el n£mero de legajo: ');
      readln(legajo);
      busqueda_binaria_profesores(a_profesor8,legajo,esta,pos);
      if esta
      then
      begin
        seek(a_profesor8,pos);
        r_profesor.legajo:=0;
        write(a_profesor8,r_profesor);
        inc(contprof8);
      end
      else
      begin
        busqueda_vector_profesores(v_profesor8,topeprof8,encontrado,posic,legajo);
        if encontrado
        then
        begin
          v_profesor8[posic].legajo:=0;
          inc(contprof8);
        end
        else
          writeln('No se encontr¢ el legajo');
      end;
      writeln('¨Desea realizar otra baja?: S/N');
      repeat
        opcion4:=upcase(readkey);
      until ((opcion4='S') or (opcion4='N'));
      if opcion4 = 'S'
      then
        fin:=false
      else
        fin:=true;
      termino_profesores(contprof8,profesores8);
  until ((opcion4='N') or (not profesores8));
end;

procedure modificaciones_profesores(var a_profesor10:ta_profesor;var v_profesor10:tv_profesor;
var contprof10:byte;var profesores10:boolean;var topeprof10:byte);
var
  legajo:word;
  opcion4,opcion5:char;
  fin:boolean;
  encontrado,esta:boolean;
  pos:word;
  posic:byte;
  r_profesor:tr_profesor;

begin
  repeat
      clrscr;
      write('Ingrese el n£mero de legajo: ');
      readln(legajo);
      busqueda_binaria_profesores(a_profesor10,legajo,esta,pos);
      if esta
      then
      begin
        inc(topeprof10);
        seek(a_profesor10,pos);
        read(a_profesor10,r_profesor);
        v_profesor10[topeprof10].legajo:=r_profesor.legajo;
        v_profesor10[topeprof10].nombre:=r_profesor.nombre;
        v_profesor10[topeprof10].calle:=r_profesor.calle;
        v_profesor10[topeprof10].numero:=r_profesor.numero;
        v_profesor10[topeprof10].tel:=r_profesor.tel;
        v_profesor10[topeprof10].mail:=r_profesor.mail;
        seek(a_profesor10,pos);
        r_profesor.legajo:=0;
        write(a_profesor10,r_profesor);
        Repeat
          clrscr;
          writeln('1_ Legajo');
          writeln('2_ Nombre');
          writeln('3_ Calle');
          writeln('4_ N£mero');
          writeln('5_ Tel‚fono');
          writeln('6_ E_Mail');
          writeln('7_ Salir');
          write('Ingrese la opci¢n que desea modificar: ');
          repeat
            opcion5:=upcase(readkey);
          until opcion5 in ['1'..'7'];
          clrscr;
          case opcion5 of
           '1':
            begin
              write('Ingrese el n£mero de legajo: ');
              readln(v_profesor10[topeprof10].legajo);
            end;
           '2':
            begin
              write('Ingrese el nombre: ');
              readln(v_profesor10[topeprof10].nombre);
            end;
            '3':
            begin
              write('Ingrese la calle: ');
              readln(v_profesor10[topeprof10].calle);
            end;
            '4':
            begin
              write('Ingrese el n£mero: ');
              readln(v_profesor10[topeprof10].numero);
            end;
            '5':
            begin
              write('Ingrese el tel‚fono: ');
              readln(v_profesor10[topeprof10].tel);
            end;
            '6':
            begin
              write('Ingrese el E_mail: ');
              readln(v_profesor10[topeprof10].mail);
            end;
          end;
        until opcion5='7';
        inc(contprof10);
      end
      else
      begin
        Busqueda_vector_profesores(v_profesor10,topeprof10,encontrado,posic,legajo);
        if encontrado
        then
        begin
          repeat
            clrscr;
            writeln('1_ Legajo');
            writeln('2_ Nombre');
            writeln('3_ Calle');
            writeln('4_ N£mero');
            writeln('5_ Tel‚fono');
            writeln('6_ E_Mail');
            writeln('7_ Salir');
            writeln('Ingrese la opci¢n que desea modificar: ');
            repeat
              opcion5:=upcase(readkey);
            until opcion5 in ['1'..'7'];
            case opcion5 of
                '1':
                begin
                  write('Ingrese el n£mero de legajo: ');
                  readln(v_profesor10[posic].legajo);
                end;
                '2':
                begin
                  write('Ingrese el nombre: ');
                  readln(v_profesor10[posic].nombre);
                end;
                '3':
                begin
                  write('Ingrese la calle: ');
                  readln(v_profesor10[posic].calle);
                end;
                '4':
                begin
                  write('Ingrese el n£mero: ');
                  readln(v_profesor10[posic].numero);
                end;
                '5':
                begin
                  write('Ingrese el tel‚fono: ');
                  readln(v_profesor10[posic].tel);
                end;
                '6':
                begin
                  write('Ingrese el E_mail: ');
                  readln(v_profesor10[posic].mail);
                end;
            end;
          until opcion5='7';
          inc(contprof10);
        end
        else
          writeln('No se encontr¢ el legajo');
      end;
      write('¨Desea realizar otra modificaci¢n?: S/N');
      repeat
        opcion4:=upcase(readkey);
      until ((opcion4='S') or (opcion4='N'));
      if opcion4 = 'S'
      then
        fin:=false
      else
        fin:=true;
      termino_profesores(contprof10,profesores10);
  until ((opcion4='N') or (not profesores10));
end;


procedure ordena_profesores(var v_profesor12:tv_profesor;topeprof12:byte);
var
  I,fin:byte;
  r_aux:tr_profesor;
begin
  while topeprof12>1 do
     begin
          fin:=topeprof12-1;
          topeprof12:=0;
          for I:=1 to fin do
              if v_profesor12[I].legajo > v_profesor12[I+1].legajo
              then
              begin
                   r_aux:=v_profesor12[I];
                   v_profesor12[I]:=v_profesor12[I+1];
                   v_profesor12[I+1]:=r_aux;
                   topeprof12:=I;
              end;
    end;
end;

procedure Aparea_profesores(var a_profesor14:ta_profesor;v_profesor14:tv_profesor;topeprof14:byte;
var a_auxprof14:ta_profesor);

var
  I:byte;
  fin:boolean;
  r_profesor,r_auxprof:tr_profesor;
begin
  I:=1;
  reset(a_profesor14);
  if eof (a_profesor14)
  then
    fin:=true
  else
  begin
    fin:=false;
    read(a_profesor14,r_profesor);
  end;
  while (not fin) or (I <= topeprof14) do
  begin
    if (not fin) and ((I > topeprof14) or (r_profesor.legajo < v_profesor14[I].legajo))
      then
        if r_profesor.legajo <> 0
        then
        begin
          r_auxprof:=r_profesor;
          write(a_auxprof14,r_auxprof);
          if eof (a_profesor14)
          then
            fin:=true
          else
          begin
            fin:=false;
            read(a_profesor14,r_profesor);
          end;
        end
        else
        begin
          if eof (a_profesor14)
            then
              fin:=true
            else
            begin
              fin:=false;
              read(a_profesor14,r_profesor);
             end;
        end
      else
        if v_profesor14[I].legajo <> 0
        then
        begin
          r_auxprof:=v_profesor14[I];
          write(a_auxprof14,r_auxprof);
          inc(I);
        end
        else
        inc(I);
  end;
  close(a_profesor14);
  close(a_auxprof14);
  erase(a_profesor14);
  rename(a_auxprof14,'DAT\profesor.dat');
end;
Var
  opcion3:char;
  r_profesor:tr_profesor;
  r_auxprof:tr_profesor;
  a_profesor:ta_profesor;
  a_auxprof:ta_profesor;
  v_profesor:tv_profesor;
  op,topeprof,contprof:byte;
  profesores:boolean;
Begin
  assign(a_profesor,'DAT\Profesor.dat');
  assign(a_auxprof,'DAT\Auxprof.dat');
  reset(a_profesor);
  rewrite(a_auxprof);
  contprof:=0;
  topeprof:=0;
        repeat
          clrscr;
          WriteLn ( 'ABM Profesores' );
          GotoXY ( 1,25 ); { Impresion de titulos en pantalla}
          Write ( 'Cantidad de operaciones realizadas hasta el momento : ',contprof,'/30' );
          GotoXY ( 1,1 );
          op := aChoice ( aMenuProfesores,iOp,1,3 );
          Case op of
            1 : opcion3 := 'A';
            2 : opcion3 := 'B';
            3 : opcion3 := 'M';
            4 : opcion3 := 'L';
            5 : opcion3 := 'S';
          End;
          clrscr;
          case opcion3 of
            'A':
            begin
              writeln('Altas');
              altas_profesores(a_profesor,v_profesor,contprof,profesores,topeprof);
            end;
            'B':
            begin
             writeln('Bajas');
             bajas_profesores(a_profesor,v_profesor,contprof,profesores,topeprof);
            end;
            'M':
            begin
              writeln('Modificaciones');
              modificaciones_profesores(a_profesor,v_profesor,contprof,profesores,topeprof);
            end;
            'L':
            begin
              writeln('Listado de Profesores');
              listado_profesores(a_profesor);
            end;
          end;
        until ((opcion3='S') or (not profesores));
  if (topeprof > 0)
  then
  begin
    ordena_profesores(v_profesor,topeprof);
    aparea_profesores(a_profesor,v_profesor,topeprof,a_auxprof);
  end
  else
    begin
      erase ( a_auxprof );
    end;
End;

End.