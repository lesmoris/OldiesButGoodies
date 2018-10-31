Unit Button;
Interface
Uses
  crt,
  palette,
  xlib2;
Const
  MaxButtons = 10;
Type
  Reg_Button = record
             X1,Y1,X2,Y2 : Word;
             Text : String;
           end;
  Arr_Buttons = Array [1..MaxButtons] of Reg_Button;
Var
  ActButtons : Byte;

Procedure Init_Buttons (X1,Y1,X2,Y2 : Word; Text : String; Number : Byte; VAR Buttons : Arr_Buttons);
Procedure Show_Buttons (Buttons : Arr_Buttons);
Procedure Check_Buttons (Buttons : Arr_Buttons;Var Opcion : Byte);
Procedure Up_Button (X1,Y1,X2,Y2 : Word; Text : String);
Procedure Down_Button (X1,Y1,X2,Y2 : Word; Text : String);

Implementation
Var
  I : Word;

Procedure Up_Button (X1,Y1,X2,Y2 : Word; Text : String);
begin
  XHideMouse;
  XRectFill (x1,y1,x2,y2,0,215);
  XLine (x1,y1,x1,y2,223,0);
  XLine (x1,y1,x2,y1,223,0);
  XLine (x2,y1+1,x2,y2,201,0);
  XLine (x1+1,y2,x2-1,y2,201,0);
  XCentre (160,y1+2,0,223,Text);
  XShowMouse;
End;

Procedure Down_Button (X1,Y1,X2,Y2 : Word; Text : String);
begin
  XHideMouse;
  XRectFill (x1,y1,x2,y2,0,215);
  XLine (x1,y1,x1,y2,201,0);
  XLine (x1,y1,x2,y1,201,0);
  XLine (x2,y1+1,x2,y2,223,0);
  XLine (x1+1,y2,x2-1,y2,223,0);
  XCentre (160,y1+2,0,223,Text);
  XShowMouse;
End;

Procedure ButtonPressed (X1,Y1,X2,Y2 : Word; Text : String);
Begin
  Down_Button (X1,Y1,X2,Y2,Text);
  repeat
  until MouseButtonStatus = 0;
  Delay (50);
  Up_Button (X1,Y1,X2,Y2,Text);
end;

Procedure Init_Buttons;
begin
  Buttons[Number].X1 := X1;
  Buttons[Number].Y1 := Y1;
  Buttons[Number].X2 := X2;
  Buttons[Number].Y2 := Y2;
  Buttons[Number].Text := Text;
  If Number > ActButtons then ActButtons := Number;
end;

Procedure Show_Buttons (Buttons : Arr_Buttons);
begin
  For I := 1 to ActButtons do
    Up_Button (Buttons[I].X1, Buttons[I].Y1, Buttons[I].X2, Buttons[I].Y2, Buttons[I].Text);
end;

Procedure Check_Buttons (Buttons : Arr_Buttons;Var Opcion : Byte);
begin
  Opcion := 0;
  For I := 1 to MaxButtons do
   If XMouseIn (Buttons[I].X1, Buttons[I].Y1, Buttons[I].X2, Buttons[I].Y2) and (MouseButtonStatus = LeftPressed) then begin
     ButtonPressed (Buttons[I].X1, Buttons[I].Y1, Buttons[I].X2, Buttons[I].Y2, Buttons[I].Text);
     Opcion := I;
     Exit;
     end;
end;

end.