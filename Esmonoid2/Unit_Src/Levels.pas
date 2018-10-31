Unit Levels;
Interface
Const
  MaxLad = 10;
  Last_Level = 10;
Type
  Nivel_Type = Array [1..Last_Level,1..MaxLad,1..15] of String[5];
Var
  Nivel : Nivel_Type;
  BrickCounter : Integer;

Procedure Initial_Count (Level : byte);
Procedure Load_levels;

Implementation

Procedure Initial_Count;
Var
  I,J : Integer;
Begin
  BrickCounter := 0;
  For I := 1 to MaxLad do
    For J := 1 to 15 do
      If (Nivel[Level,I,J] [1] = '1') and (Nivel[Level,I,J] [3] <> '3') then
        Inc(BrickCounter);
 {   BrickCounter := 1;}
end;

Procedure Load_Levels;
var
  F : file of integer;
  A,K,C : Integer;
  Alto,Largo : Byte;
begin
  Assign (F,'DATA\Levels.dat');
  Reset (F);
  Alto  := 1;
  Largo := 1;
  For K := 1 to Last_Level do
   For Alto := 1 to 10 do
    For Largo := 1 to 15 do begin
      Read (F,A);
      Str (A,Nivel[K,Alto,Largo]);
    end;
end;

End.