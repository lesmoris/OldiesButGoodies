Unit Dune2Voc;

Interface

Procedure Play_Dune2_Sounds ( D2F : String; I : Integer; Freq : Word );
Procedure Read_Dune2_Sounds (D2F : String; Var I : Integer);
Procedure Show_Voc_Info (I : Integer);
Procedure Vaciar_VOCArray;

Implementation
Uses
  Crt,Dsp,Dos,Misc;
Type
  D2_Voc_Info = Record
                  Nombre : String;
                  Inicio,Size : LongInt;
                end;
  Voc_Arr = Array [1..70] of D2_Voc_Info;

Var
  VOC_Array   : VOC_Arr;
  Sound       : VocSound;
  B,Voice     : String;
  F           : File;
  Size,A,C    : LongInt;

Procedure Show_Voc_Info;
Begin
  WriteLn ('Nombre: ',Voc_Array[I].Nombre:8,'  ');
  WriteLn ('Inicio: ',Voc_Array[I].Inicio:8,'  ');
  If Voc_Array[I].Size > 0 then
    WriteLn ('Tama¤o: ',Voc_Array[I].Size:8,'             ')
  else
    WriteLn ('Tama¤o: Error en archivo');
End;

Procedure Vaciar_VOCArray;
Var
  I : Integer;
Begin
  For I := 1 to 70 do begin
    With Voc_Array[I] do begin
        Nombre := '';
        Inicio := 0;
        Size   := 0;
      End;
  End;
End;

Procedure Play_Dune2_Sounds;
Begin
  If Voc_Array[I].Size > 0 then
    Play_And_UnLoadVoc (D2F, Voc_Array[I].Inicio , Voc_Array[I].Size,Freq);
End;

Procedure Read_Dune2_Sounds;
Begin
  A := 0;
  C := 0;
  B[1] := ' ';
  Voice := '';
  Assign (F,D2F);
  Reset (F,1);
  BlockRead (F,A,4);
  I := 1;
  Voc_Array[I].Inicio := A+705;
  Repeat
    Seek ( F,FilePos( F ) - 1 );
    While (B[ 1 ] <> '.') do begin
      BlockRead ( F,B,2 );
      Voice := Voice + B[ 1 ];
      Seek ( F,FilePos( F ) - 1 );
      end;
    Voice := Copy( Voice,1,Length(Voice)-1 );
    Voc_Array[I].Nombre := Voice;
    BlockRead ( F,C,5 );
    BlockRead ( F,C,4 );
    If C = 0 Then
      Size := FileSize( F ) - ( A + 800 )
    Else
      Size := C - ( A + 800 );
    Voc_Array[I].Size := Size;
    If (C = 0) Then Begin
        Close (F);
        Exit;
      End;
    A := C;
    C := 0;
    B[1] := ' ';
    Voice := '';
    Inc ( I );
    Voc_Array[I].Inicio := A+705;
  Until 1 = 0;
End;

End.