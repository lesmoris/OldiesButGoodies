Unit Palette;
Interface
Type
  PalArray = array [0..255,1..3] of byte;
Var
  Pal : PalArray;

Procedure PaletteInit;

Implementation
Uses
  dos;

Procedure PaletteInit;
Procedure SetPalette (VAR Pal : PalArray);
Var
  I,J,K : Integer;
Begin
  for i:=0 to 31 do
    begin
      Pal[i,1] :=0;
      Pal[i,2] :=0;
      Pal[i,3] :=i*2;
    end;
  Pal[1,1] := 0;
  Pal[1,2] := 0;
  Pal[1,3] := 0;
  for i:=32 to 64 do
    begin
      Pal[i,1]:=0;
      Pal[i,2]:=i*2;
      Pal[i,3]:=0;
    end;
  for i:=65 to 97 do
    begin
      Pal[i,1]:=0;
      Pal[i,2]:=i*2;
      Pal[i,3]:=i*2;
    end;
  for i:=98 to 130 do
    begin
      Pal[i,1]:=i*2;
      Pal[i,2]:=0;
      Pal[i,3]:=0;
    end;
  for i:=131 to 163 do
    begin
      Pal[i,1]:=i*2;
      Pal[i,2]:=0;
      Pal[i,3]:=i*2;
    end;
  for i:=164 to 196 do
    begin
      Pal[i,1]:=i*2;
      Pal[i,2]:=i*2;
      Pal[i,3]:=0;
    end;
  for i:=197 to 229 do
    begin
      Pal[i,1]:=i*2;
      Pal[i,2]:=i*2;
      Pal[i,3]:=i*2;
    end;
  i := 224;
  j := 11;
  k := 7;
  Repeat
    Pal[i,1] := j;
    Pal[i,2] := k;
    Pal[i,3] := 0;
    Inc (i);
    Inc (j);
    Inc (k);
  until i=255;
end;

Procedure SetRGBPal (PalBuf : PalArray);
var
  Reg : Registers;
begin
  reg.ax := $1012;
  reg.bx := 0;
  reg.cx := 256;
  reg.es := Seg(PalBuf);
  reg.dx := Ofs(PalBuf);
  intr($10,reg);
end;

Begin
  SetPalette (Pal);
  SetRGBPal (Pal);
End;

End.