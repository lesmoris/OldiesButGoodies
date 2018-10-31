Program Dune2RIP;
Uses
  Crt,Dsp,Dune2Voc,Dune2Ini,Dos,Misc;
Var
  D2F,FileMiss : String;
  MaxSounds,I  : Integer;
  Freq         : Word;
  Ky           : Char;
  Sw           : Boolean;
  Opcion       : Integer;
Const
  Opciones : aChoiceArray = ('Ripear VOC','Ripear INI','Salir        ','','','','','','','','','','','','','','','','','');

  {ESTOS}
  VocFiles : aChoiceArray = ('Atre.PAK','Ordos.PAK','Hark.PAK','Merc.PAK','Voc.PAK','Introvoc.PAK','Salir'
                             ,'','','','','','','','','','','','','');
  VocNames : aChoiceArray = ('Atreides PAK','Ordos PAK','Harkonnen PAK','Mercenaries PAK','Misc Voc PAK','Introduction PAK'
                             ,'Salir','','','','','','','','','','','','','');

Procedure D2Sonidos;
Const
  X : Integer = 8;
Begin
  D2F := 'Voc\' + VocFiles[aChoice (VocNames,7)];
  If Sw = true then
     Exit;
  If FExists (D2F,FileMiss) = False Then begin
    WriteLn ('El archivo ',D2F,' no existe');
    WriteLn;
    Fanfarria;
    Halt;
    End;
  ResetDsp (2);
  Read_Dune2_Sounds (D2F,I);
  MaxSounds := I;
  I := 1;
  Freq := 11000;
  TextBackground (1);
  TextColor (15);
  WriteLn ('Seleccione el numero de sonido a reproducir con las flechas del cursor:');
  TextColor (7);
  TextBackground (0);
  WriteLn ('FLECHA ARRIBA    / ABAJO   : Baja/Sube una posicion');
  WriteLn ('FLECHA IZQUIERDA / DERECHA : Baja/Sube 5 posiciones');
  WriteLn ('TECLA Z-X / TECLA A-S      : Baja/Sube frecuencia 100/1000 unidades');
  WriteLn ('TECLA D / TECLA C          : Frecuencia M xima-M¡nima');
  WriteLn ('Barra Espaciadora          : Frecuencia Normal');
  WriteLn;
  TextBackground (1);
  TextColor (15);
  GotoXY (1,X);
  WriteLn ('Escuchando Archivo : ',D2F);
  Repeat
    GotoXY (1,X+1);
    TextBackground (2);
    TextColor (15);
    Write ('Posicion :',I:3);
    TextBackground (3);
    TextColor (15);
    GotoXY (50,X);
    Write ('Frecuencia:',Freq:5);
    TextBackground (0);
    TextColor (7);
    GotoXY (1,X+2);
    Show_Voc_Info (I);
    Ky := Readkey;
    Case UpCase(Ky) of
      #72 : Dec (I);
      #80 : Inc (I);
      #75 : Dec (I,5);
      #77 : Inc (I,5);
      'A' : Inc (Freq,100);
      'Z' : Dec (Freq,100);
      'S' : Inc (Freq,1000);
      'X' : Dec (Freq,1000);
      'C' : Freq := 4000;
      'D' : Freq := 44100;
      #32 : Freq := 11000;
      #13 : Play_Dune2_Sounds (D2F,I,Freq);
    End;
    If I > MaxSounds then I := MaxSounds
    Else If I < 1 then I := 1;
    If Freq > 44100 then Freq := 44100
    Else If Freq < 4000 then Freq := 4000;
  Until (Ky = #27);
  Vaciar_VOCArray;
  ClrScr;
End;

Procedure D2Inis;
Begin
  D2F := 'INI\SCENARIO.PAK';
  Rip_Dune2_Ini (D2F);
  Sw := False;
End;

Begin
  Repeat
  TextBackGround (0);
  TextColor (7);
  ClrScr;
  Opcion := aChoice (Opciones,3);
    If Opcion = 1 then
      D2Sonidos
    Else
      If Opcion = 2 then
        D2Inis
      Else Begin
             WriteLn ('Tenes que poner alguna opcion, querido');
             WriteLn ('Pone -v para escuchar los archivos VOC');
             WriteLn ('o pone -i para ver los INI');
             WriteLn;
             sw := true;
           End;
  Until Sw = True;
  Fanfarria;
End.