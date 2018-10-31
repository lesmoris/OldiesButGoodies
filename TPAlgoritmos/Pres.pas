PROCEDURE AcercaDe;
        BEGIN

          {Pantalla de presentaci¢n}

          CLRSCR;
          TEXTCOLOR(1);
          GOTOXY(10,4); WRITELN('²±°²±°²±°²±°²±°²±°²±°²±°²±°²±°²±°²±°²±°²±°²±°²±°²±°²±°±²°±²');TEXTCOLOR(10);
          GOTOXY(10,5); WRITELN('°               Trabajo Pr ctico N£mero 2                 °');
          GOTOXY(10,6); WRITELN('±                                                         ±');
          GOTOXY(10,7); WRITELN('²            Algoritmos y Estructuras de datos            ²');
          GOTOXY(10,8); WRITELN('°                                                         °');
          GOTOXY(10,9); WRITELN('±                        Grupo N§5                        ±');
          GOTOXY(10,10);WRITELN('²                                                         ²');
          GOTOXY(10,11);WRITELN('°                    Juan Pedro Pereyra                   °');
          GOTOXY(10,12);WRITELN('±                    Facundo Merighi                      ±');
          GOTOXY(10,13);WRITELN('²                    Leonardo Esmoris                     ²');
          GOTOXY(10,14);WRITELN('°                    Mariana Gun                          °');
          GOTOXY(10,15);WRITELN('²                                                         ²');
          GOTOXY(10,16);WRITELN('°                     Curso K-1001                        °');TEXTCOLOR(12);
          GOTOXY(10,17);WRITELN('²±°²±°²±°²±°²±°²±°²±°²±°²±°²±°²±°²±°²±°²±°²±°²±°²±°²±°±²°±²');
          TEXTCOLOR(13); GOTOXY(22,22);
          WRITELN('Presione una tecla para continuar...');
          TEXTCOLOR(7);
          READKEY;
        END;
