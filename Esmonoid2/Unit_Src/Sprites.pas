Unit Sprites;
Interface
Uses
  Xlib2,
  Xbm2;
Const
  MaxFrame = 3;           {La cantidad actual maxima de Frames de un sprite.
                           Se puede cambiar teniendo en cuenta que a mas frames,
                           menos memoria pero mas resolucion.}
  Ark_Width : Integer = 28; {Es el largo inicial en pixels del arkanoid}

Type
  XSprite = Record
              Alto,
              Largo,
              Visible,
              CurFrame,                {El frame actual}
              LastFrame : Byte;        {El ultimo frame disponible}
              Sprite : Array [1..MaxFrame] of Array [1..2000] of Byte;  {Contiene las frames del sprite}
            end;

Procedure XInitSprite (Var Sprite : XSprite);
Procedure XDrawSprite (X,Y : Integer; Var Sprite : XSprite);
Procedure XUndrawArk (X,Y : Word);
Procedure XUndrawBall (X,Y : Word; Visible : Byte);
Procedure XNextFrame (Var Sprite : XSprite);

Implementation

Procedure XInitSprite;
Begin
  With Sprite do begin
    Visible := 1;
    CurFrame := 1;
    LastFrame := 1;
  end;
End;

Procedure XDrawSprite;
Begin
  With Sprite do
    If Visible = 1 then
    XPutCBitmap (X,Y,0,Sprite[CurFrame]);
End;

Procedure XUndrawBall (X,Y : Word; Visible : Byte);
Begin
  If Visible = 1 then
   XCpVidRect (X,Y,X+4,Y+4, X,Y, Page1Offs,0, 360,360);
End;

Procedure XUndrawArk (X,Y : Word);
Begin
  XCpVidRect (X,Y,X+28,Y+10, X,Y, NonVisualOffs,0, 360,360);
End;

Procedure XNextFrame;
Begin
  Inc (Sprite.CurFrame);
  If Sprite.CurFrame > Sprite.LastFrame then Sprite.CurFrame := 1;
End;

end.
