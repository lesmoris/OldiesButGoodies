Unit Mouse;
Interface
Uses
  Crt;

Procedure ActivateMouse;
Procedure DeActivateMouse;
Procedure ShowMouse;
Procedure HideMouse;
Procedure GetMouseStatus ( Var b,mX,mY : Integer );
Procedure SetMousePosition ( Xpos,Ypos : integer );

Implementation
{ mouse pointer }
Const seta : array[0..15,0..7] of word =
 (
 (015,015,015,015,015,015,999,999),
 (015,015,015,015,015,999,999,999),
 (015,015,015,015,999,999,999,999),
 (015,015,015,999,999,999,999,999),
 (015,015,999,999,999,999,999,999),
 (015,999,999,999,999,999,999,999),
 (999,999,999,999,999,999,999,999),
 (999,999,999,999,999,999,999,999),
 (999,999,999,999,999,999,999,999),
 (999,999,999,999,999,999,999,999),
 (999,999,999,999,999,999,999,999),
 (999,999,999,999,999,999,999,999),
 (999,999,999,999,999,999,999,999),
 (999,999,999,999,999,999,999,999),
 (999,999,999,999,999,999,999,999),
 (999,999,999,999,999,999,999,999)
 );


var mode,co,n,
    m,xmax,
    ymax,mxmax : word;

    ky,c       : char;

    buf        : array [0..255] of byte;

    sos,ooo    : word;

    bank       : byte;

    mask       : array [0..15,0..7] of byte;  { mask of mouse pointer }

    mx,my,mb,

    oldseg,
    oldofs,
    oldmask,

    newseg,
    newofs,
    newmask,

    oldbank  : word;

    visible  : boolean;

{$F+}
procedure SetPixel(X, Y : Word; C : word);  { VESA putpixel }
var b,z1,z2,z3,q,w:longint;
    bnk:word;
begin
 if c <= 255 then
 begin       { if color <256 change, else dont put the pixel }
   z1 := y;
   z2 := xmax;            { swaping x,y to longint vars }
   q  := z1 * z2 + x;                { calculating offset }
   z3 := memw[ sos:ooo+6 ];
   z3 := z3 * 1024;
   if z3 = 0 then
     z3 := 1;
   b := q div z3;
   bnk := b * bank;                 { calculating effective Bank # }
   if oldbank <> b then
    begin
     asm
      mov ax,$4f05
      mov bx,0
      mov dx,bnk
      int $10
     end;   { Change to Bank # }
     oldbank:=b;
    end;
   if ((x<xmax) and (y<ymax)) then mem[$a000:q]:=c; {screen dimmensions}
 end;
end;

Function GetPixel(X, Y : Word):byte;
Var
  z1,z2,q,w:longint;
  b:word;
Begin
  z1 :=y;
  z2 :=xmax;
  q := z1 * z2 + x;
  b := q div 65536;
  b := b * bank;
  if oldbank<>b then begin
    asm mov ax,$4f05
        mov bx,0
        mov dx,b
        int $10
    end;
    oldbank := b;
  end;
  getpixel:=mem[$a000:q];
End;

Procedure newmouse ( Flags,CS,IP,AX,BX,CX,DX,SI,DI,DS,ES,BP : word);interrupt;
Var hx,hy,hb,ev:word;
    hn,hm:integer;
Begin
 ev:=ax;
 hx:=cx div 4;
 hy:=dx;
 hb:=bx;
 if ( (hx<>mx) or (hy<>my)) and (Visible) then begin
   for hn:=0 to 15 do
    for hm:=0 to 7 do
     setpixel(mx+hm,my+hn,mask[hn,hm]);
   for hn:=0 to 15 do
    for hm:=0 to 7 do
     mask[hn,hm]:=getpixel(hx+hm,hy+hn);
   for hn:=0 to 15 do
    for hm:=0 to 7 do
     setpixel(hx+hm,hy+hn,seta[hn,hm]);
   mx:=hx;
   my:=hy;
  end;
 inline ($8B/ $E5/ $5D/ $07/ $1F/ $5F/ $5E/ $5A/ $59/$5B/ $58/ $CB);
end;

Procedure ShowMouse;
Begin
 { pick up (0,0) mask }
 for n := 1 to 16 do
  for m := 1 to 8 do
   mask[n,m] := getpixel( m,n );
asm
  mov ax,1
  int $33    { Show Mouse }
end;
Visible := True;
End;

Procedure HideMouse;
Begin
asm
  mov ax,2
  int $33    { Show Mouse }
end;
Visible := false;
End;

Procedure GetVesaInfo;
Begin
 sos := seg (buf);
 ooo := ofs (buf[0]); { pointing VESA information Buffer }
 mode := $103; { Vesa mode }
 asm
  mov ax,$4f01
  mov cx,mode
  mov es,sos
  mov di,ooo
  int $10
 end; { Get VESA info }
End;

Procedure ActivateMouse;
Begin
  GetVesaInfo;
  SetMousePosition (1,1);
  visible := false;
  mx:=0;
  my:=0;
  oldbank:=0;

  if memw[ sos:ooo+4 ] = 0 then memw[sos:ooo+4] := 1;
  bank := memw[ sos:ooo+6 ] div memw[ sos:ooo+4 ];
  { Granularity }

  xmax := memw[ sos:ooo+$12 ];
  ymax := memw[ sos:ooo+$14 ];
 { Get Screen Size }

 newseg := seg( newmouse );
 newofs := ofs( newmouse ); { pointing to new mouse routine }
 newmask := 1;

 mxmax := xmax * 4;
 asm
  mov ax,0
  int $33    { mouse ? }
  mov ax,1
  int $33    { Show Mouse }
  mov ax,2
  int $33    { Hide Mouse }
  mov ax,7
  mov cx,0
  mov dx,mxmax
  int $33
  mov ax,8
  mov cx,0
  mov dx,ymax  { Set YMAX for mouse windows }
  int $33
  mov ax,20
  mov cx,newmask
  mov es,newseg
  mov dx,newofs
  int $33      { Active USER Mouse Routine }
  mov ax,$000f
  mov cx,4
  mov dx,4
  int $33
 end;
End;

Procedure GetMouseStatus ( Var b,mX,mY : Integer );
Var
  boton,xpos,ypos : word;
Begin
asm
  mov ax,3
  int $33
  mov boton,bx
  mov xpos,cx
  mov ypos,dx
end;
  b  := boton;
  mx := xpos;
  my := ypos;
End;

Procedure SetMousePosition(Xpos,Ypos : integer);
Begin
asm
  mov ax,04;
  mov cx,Xpos;
  mov dx,Ypos;
  int $33
end;
End;

Procedure DeActivateMouse;
Begin
 asm
  mov ax,20
  mov cx,oldmask
  mov es,oldseg
  mov dx,oldofs
  int $33   { Restore old Mouse Routine }
 end;
 asm
  mov ax,3
  int $10
 end;
end;

begin
end.
