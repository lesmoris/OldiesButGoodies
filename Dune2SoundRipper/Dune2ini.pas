Unit Dune2Ini;
Interface

Procedure Rip_Dune2_Ini (D2File : String);

Implementation
Uses
  Crt,Dsp,Dos,Misc;
Type
  Pak_Dune2 = File;
Var
  FileMiss,D2f : String;
  Size,A,C : LongInt;
  B : String;
  Voice : String;
  F,RipF : Pak_Dune2;
  I : Integer;
  Ky : Char;

Procedure Rip_Dune2_Ini (D2File : String);
Begin
  ClrScr;
  D2F := D2File;
  If FExists (D2F,FileMiss) = False Then begin
    WriteLn ('El archivo ',D2F,' no existe');
    WriteLn;
    Halt;
    End;
  Assign (F,D2F);
  Reset (F,1);
  BlockRead (F,A,4);
  Write ('Inicio: ',A+705,'   ');
  Repeat

    Seek (F,FilePos(F)-1);
    While (B[1] <> '.') do begin
      BlockRead (F,B,2);
      Voice := Voice + B[1];
      Seek (F,FilePos(F)-1);
      end;
    Voice := Voice + 'INI';
    Write ('Nombre del INI: ',Voice,'  ');

    BlockRead (F,C,5);

    BlockRead (F,C,4);
    If C = 0 Then
      Size := FileSize(F)-(A+800)
    Else
      Size := C-(A+800);
    WriteLn ('Tama¤o: ',Size);
    Ky := Readkey;
    If C = 0 Then Begin
        Close (F);
        ClrScr;
        Exit;
      End;
    Write ('Inicio: ',C,'   ');
    A := C;
    C := 0;
    B[1] := ' ';
    Voice := '';
  Until Ky = #27;
  Close (F);
  ClrScr;
End;

End.