Unit Capsules;
Interface
Uses
  Xlib2,
  Xbm2;
Const
  MaxCapsules = 4;
  Capsule_Status : Boolean = False; {Indica si hay una capsula en pantalla}

{$IFDEF AltCaps}
  {$I Include\Capsules.INC}
{$ELSE}
  {$I Include\Caps.INC}
{$ENDIF}

Type
  XCapsule = Record
              Alto,
              Largo,
              Visible,
              CurFrame,                {El frame actual}
              LastFrame : Byte;        {El ultimo frame disponible}
              {$IFDEF AltCaps}
              Sprite : Array [1..14] of Array [1..250] of Byte;  {Contiene las frames del sprite}
              {$ELSE}
              Sprite : Array [1..10] of Array [1..250] of Byte;  {Contiene las frames del sprite}
              {$ENDIF}
            end;
  Capsule_Pos = record
                 x,y : integer;
                end;
Var
  Capsule  : Array [1..MaxCapsules] of XCapsule;
  Cap_Pos  : Capsule_Pos;
  Cap_Seen : Array [1..2] of Capsule_Pos;

Procedure XInitCapsule (Var Sprite : XCapsule);
Procedure XDrawCapsule (X,Y : Integer; Var Sprite : XCapsule);
Procedure XUndrawCapsule (X,Y : Word; Visible : Byte);
Procedure XNextCapsule (Var Sprite : XCapsule);

Implementation
{--------------------------------1§ Capsula----------------------------------}
Procedure XInitCapsule;
Begin
  With Sprite do begin
    Visible := 1;
    CurFrame := 1;
    LastFrame := 1;
  end;
End;

Procedure XDrawCapsule;
Begin
  With Sprite do
    If Visible = 1 then
    XPutCBitmap (X,Y,0,Sprite[CurFrame]);
End;

Procedure XUndrawCapsule (X,Y : Word; Visible : Byte);
Begin
  If Visible = 1 then
   XCpVidRect (X,Y,X+12,Y+6, X,Y, Page1Offs,0, 360,360);
End;

Procedure XNextCapsule;
Begin
  Inc (Sprite.CurFrame);
  If Sprite.CurFrame > Sprite.LastFrame then Sprite.CurFrame := 1;
End;


End.