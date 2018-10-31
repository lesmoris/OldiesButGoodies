Unit E2_Menu;
Interface

Procedure Input (X,Y : Word;VAR Name : String; Cant : Byte);
Procedure Change_Options (Var Lives : Integer);
Procedure Read_Password (Var nivel : Word);
Procedure Show_Scores;

Implementation
uses
  crt,
  button,
  fade,
  highscr,
  xlib2;

Procedure WaitforPress;
Begin
  if keypressed then readkey;
  repeat
  until keypressed or (MouseButtonStatus = LeftPressed);
  if keypressed then readkey;
End;

Procedure Change_Options (Var Lives : Integer);
begin
  MouseFrozen := 1;
  XCpVIdRect (50,130,276,146, 50,130, 0,NonVisualOffs, 360,360);
  Up_Button (50,130,275,145,'');
  XPrintf (60,134,0,223,'Opciones en construccion');
  MouseFrozen := 0;
  WaitforPress;
  MouseFrozen := 1;
  XHideMouse;
  XCpVIdRect (50,130,276,146, 50,130, NonVisualOffs,0, 360,360);
  XShowMouse;
  MouseFrozen := 0;
end;

Procedure Input (X,Y : Word;VAR Name : String; Cant : Byte);
var
  ky    : char;
  aux,
  cont  : word;
begin
  aux  := x;
  cont := 0;
  name := '                         ';
  while keypressed do readkey;
  repeat
    If (MouseButtonStatus = Leftpressed) then ky := #13;
    if keypressed then begin
      Ky := Upcase(readkey);
      case ky of
        #8  : If X > aux then begin
                dec (x,9); XRectFill (X,Y,X+8,Y+8,0,215);
                name[cont] := ' ';
                dec (Cont);
              end;
        #13 :
      else
        If (cont < cant) and ((Ky in ['A'..'Z']) or (Ky in ['0'..'9']) or (Ky = #32)) then begin
          Inc (Cont);
          name[cont] := Ky;
          Xprintf (x,y,0,223,ky);
          Inc (X,9);
          end;
      end;
    end;
  until (ky = #13) or (MouseButtonStatus = Leftpressed);
end;

Function Password ( Clave : String ) : Integer;
Begin
  Password := 0;
  If Clave = '00001' Then
    Password := 1;
  If Clave = '00002' Then
    Password := 2;
  If Clave = '00003' Then
    Password := 3;
  If Clave = '00004' Then
    Password := 4;
  If Clave = '00005' Then
    Password := 5;
  If Clave = '00006' Then
    Password := 6;
  If Clave = '00007' Then
    Password := 7;
  If Clave = '00008' Then
    Password := 8;
  If Clave = '00009' Then
    Password := 9;
  If Clave = '00010' Then
    Password := 10;
End;

Procedure Read_Password (var nivel : Word);
var
  clave : string;
  pass,k  : Integer;
begin
  MouseFrozen := 1;
  XCpVIdRect (50,130,276,146, 50,130, 0,NonVisualOffs, 360,360);
  Up_Button (50,130,275,145,'');
  XPrintf (60,134,0,223,'Introduce el pasword:');
  Down_Button (173,132,272,143,'');
  MouseFrozen := 0;
  Input (175,134,Clave,5);
{  XPrintf (1,1,0,223,Clave); }
  Clave := Concat(Clave[1],Clave[2],Clave[3],Clave[4],Clave[5]);
  Nivel := Password ( Clave );
  If Nivel = 0 then begin
    Up_Button (50,130,275,145,'');
    XPrintf (60,134,0,223,'El password no sirve, mamerto!!!');
    Nivel := 1;
    end
  Else Begin
    Up_Button (50,130,275,145,'');
    Str( nivel,clave );
    XPrintf (60,134,0,223,'Bien!!! La clave es del nivel '+clave);
    End;
  ReadKey;
  MouseFrozen := 1;
  XHideMouse;
  XCpVIdRect (50,130,276,146, 50,130, NonVisualOffs,0, 360,360);
  XShowMouse;
  MouseFrozen := 0;
end;

Procedure Show_Scores;
var
  aux : string;
  x,y,
  I : byte;
begin
  MouseFrozen := 1;
  Fade_Out (10);
  XHideMouse;
  XCpVIdRect (0,0,320,200, 0,0, 0,NonVisualOffs, 360,360);
  Up_Button (0,0,319,20,'');
  Up_Button (0,21,319,199,'');
  Up_Button (230,21,319,199,'');
  Up_Button (0,21,229,199,'');
  XHideMouse;

  XCentre (160,3,0,223,'Los 10 Mejores de todos los tiempos');
  y := 35;
  For I := 1 to 10 do begin
    Str(I,Aux);
    XPrintf (5,y,0,223,aux);
    XPrintf (15,y,0,223,' .- '+Hs_name(I));
    Str(Hs_score(I),Aux);
    XCentre (300,y,0,223,aux);
    inc (y,16);
  end;

  Fade_In (10);
  WaitforPress;
  Fade_Out(10);
  XCpVIdRect (0,0,320,200, 0,0, NonVisualOffs,0, 360,360);
  Fade_In(10);
  XShowMouse;
  MouseFrozen := 0;
end;

End.