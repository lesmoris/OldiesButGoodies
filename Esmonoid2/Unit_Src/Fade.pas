UNIT Fade;

INTERFACE
Const
  MaxInten = 63;

Procedure InitCol;
Procedure SetBrightness (Brightness :Byte);
Procedure Fade_Out (Duration:Byte);
Procedure Fade_In  (Duration:Byte);

IMPLEMENTATION

USES
  crt;

CONST     PelIdxR  = $3c7; {Port to read}
          PelIdxW  = $3c8; {Port to write}
          PelData  = $3c9; {Dataport}
          Maxreg   = 255;  {Set to 63 for textmode}

VAR col : ARRAY [0..MaxReg] of RECORD
                                r, g, b : Byte
                              END;
    i : Byte;

PROCEDURE GetCol(ColNr :Byte; var r, g, b :Byte);
BEGIN
  Port[PelIdxR] := ColNr;
  r := Port[PelData];
  g := Port[PelData];
  b := Port[PelData];;
END;

PROCEDURE SetCol(ColNr, r, g, b :Byte); assembler;
asm
	mov  al,ColNr
	mov  dx,PelIdxW
	out  dx,al
	mov  dx,PelData
	mov  al,R
	out  dx,al
	mov  al,G
	out  dx,al
	mov  al,B
	out  dx,al
End;

Procedure InitCol;
Var
 i : byte;
Begin
  FOR i := 0 to MaxReg DO
    GetCol(i,col[i].r,col[i].g,col[i].b);
End;

PROCEDURE SetBrightness(Brightness :Byte);
VAR
  i,fr,fg,fb :Byte;
BEGIN
  FOR i := 0 to MaxReg DO
  BEGIN
    fr := col[i].r * Brightness DIV MaxInten;
    fg := col[i].g * Brightness DIV MaxInten;
    fb := col[i].b * Brightness DIV MaxInten;
    SetCol(i,fr,fg,fb);
  END;
END;

PROCEDURE Fade_OUT(Duration :Byte);
VAR
  i :Byte;
BEGIN
  If Duration = 0 then SetBrightness (0);
  FOR i := MaxInten downto 0 DO
  BEGIN
    SetBrightness(i);
    Delay(Duration);
  END;
END;

PROCEDURE Fade_IN(Duration :Byte);
VAR
  i :Byte;
BEGIN
  If Duration = 0 then SetBrightness (63);
  FOR i := 0 to MaxInten DO
  BEGIN
    SetBrightness(i);
    Delay(Duration);
  END;
END;

End.