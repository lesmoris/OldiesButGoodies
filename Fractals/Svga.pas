Unit SVGA;
Interface

Procedure InitVGA;
Procedure InitSVGA;

Implementation

Uses Graph,Dos;
Const
  res = 3;
Var
  gd,gm : integer;

Procedure InitVGA;
Begin
  InitGraph (gd,gm,'c:\util\tp\bgi');
End;

Procedure InitSVGA;
Var
  autodetect : Pointer;

{$F+}
Function DetectVGA : Integer;
Begin
  DetectVGA := res;
End;
{$F-}

Begin
  Gd := InstallUserDriver('SVGA256',AutoDetect);
  AutoDetect := @DetectVGA;
  Gd := InstallUserDriver('SVGA256',AutoDetect);
  Gd := Detect;
  InitGraph(Gd,Gm,'');
End;

End.