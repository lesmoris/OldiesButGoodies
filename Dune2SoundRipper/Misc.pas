Unit Misc;
Interface
Uses
  Crt;
Type
  aChoiceArray = Array [1..20] of String;
Var
  Sw : Boolean;

Procedure Fanfarria; {- / -}
Function FExists (Filename : string; VAR FileMissing : String) : boolean;
Function aChoice ( VAR aNames : aChoiceArray; max : Integer ) : Integer;

Implementation

Function aChoice ( VAR aNames : aChoiceArray; max : Integer ) : Integer;
Var
  I,Code : Integer;
  Ky : Char;
Begin
  WriteLn ('Seleccione:');
  For I := 1 to Max do
    WriteLn (I,'.- ', + aNames[I]);
  I := 1;
  Repeat
    GotoXY (1,1+I);
    TextBackGround (1);
    TextColor (15);
    Write (I,'.- ', + aNames[I]);
    Ky := UpCase( Readkey );
    GotoXY (1,1+I);
    TextBackGround (0);
    TextColor (7);
    Write (I,'.- ', + aNames[I]);
    Case Ky of
      #72 : Dec (I);
      #80 : Inc (I);
      #13 : Sw := True;
      #27 : Sw := True;
    end;
    If I > Max then I := Max
    Else If I < 1 then I := 1;
  Until Sw = True;
  Sw := False;
  If ( Ky = #27 ) or ( I = Max ) then
    begin
      ClrScr;
      Sw := True;
      Exit;
    end;
  aChoice := I;
  ClrScr;
  GotoXY (1,1);
End;

Procedure Fanfarria; {- / -}
Begin
  WriteLn ('Este programa fue hecho por Leonardo Esmoris (YO!)');
  WriteLn ('Usalo como quieras pero no seas boton y dame creditos');
  WriteLn ('(alabanzas) si queres darselo a otros ;-) ');
  WriteLn;
  WriteLn ('(He, He. Y despues me dicen que vivo tirandome abajo)');
End;

Function FExists (Filename : string; VAR FileMissing : String) : boolean;
Var
  F : file;
  Tmp : boolean;
Begin
  {$I-}
  Assign (f,filename);
  Reset (f);
  {$I+}
  Tmp := IOresult=0;
  If Tmp then Close(F);
  FExists := tmp;
  If Tmp = False then
  FileMissing := FileName;
End;

End.