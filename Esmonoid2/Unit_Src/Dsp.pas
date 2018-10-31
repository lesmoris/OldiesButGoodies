Unit DSP;

Interface
Type
  VOCSound   = record
                Sonido : Pointer;
                S    : word;
                Freq : word;
                D    : record
                          Id   : byte;
                          Len  : array [1..3] of byte;
                          Sr   : byte;
                          Pack : byte;
                        end;
               end;
Const
  Main_Sound : boolean = True;

function ResetDSP(base : word) : boolean;
function ReadDAC : byte;
function SpeakerOn: byte;
function SpeakerOff: byte;
Procedure LoadVOC (Archivo : String; Inicio,Tamano:Word; VAR Sound : VOCSound);
Procedure UnLoadVOC (VAR Sound : VOCSound);
procedure WriteDAC(level : byte);
procedure DMAStop;
procedure DMAContinue;
Procedure Playback (Tipo : VocSound);
Procedure Play_and_UnloadVOC (Archivo:String; Inicio,Tamano:Word);

Implementation
Uses Crt;
var
  DSP_RESET,
  DSP_READ_DATA,
  DSP_WRITE_DATA,
  DSP_WRITE_STATUS,
  DSP_DATA_AVAIL : word;

function ResetDSP(base : word) : boolean;
begin
  base := base * $10;
  { Calculate the port addresses }
  DSP_RESET        := base + $206;
  DSP_READ_DATA    := base + $20A;
  DSP_WRITE_DATA   := base + $20C;
  DSP_WRITE_STATUS := base + $20C;
  DSP_DATA_AVAIL   := base + $20E;
  { Reset the DSP, and give some nice long delays just to be safe }
  Port[DSP_RESET] := 1;
  Delay(10);
  Port[DSP_RESET] := 0;
  Delay(10);
  if (Port[DSP_DATA_AVAIL] And $80 = $80) And (Port[DSP_READ_DATA] = $AA) then
    begin
    ResetDSP := true;
    SpeakerOn;
    end
  else
    ResetDSP := false;
end;

procedure WriteDSP(value : byte);
begin
  while Port[DSP_WRITE_STATUS] And $80 <> 0 do;
  Port[DSP_WRITE_DATA] := value;
end;

function ReadDSP : byte;
begin
  while Port[DSP_DATA_AVAIL] and $80 = 0 do;
  ReadDSP := Port[DSP_READ_DATA];
end;

procedure WriteDAC(level : byte);
begin
  WriteDSP($10);
  WriteDSP(level);
end;

function ReadDAC : byte;
begin
  WriteDSP($20);
  ReadDAC := ReadDSP;
end;

function SpeakerOn: byte;
begin
  WriteDSP($D1);
end;

function SpeakerOff: byte;
begin
  WriteDSP($D3);
end;

procedure DMAContinue;
begin
  WriteDSP($D4);
end;

procedure DMAStop;
begin
  WriteDSP($D0);
end;

procedure Playback (Tipo : VOCSound);
var time_constant : word;
     page, offset : word;
begin
  If Main_Sound = true then
  with tipo do begin
  s := s - 1;
  { Set up the DMA chip }
  offset := Seg (sonido^) Shl 4 + Ofs(sonido^);
  page := (Seg(sonido^) + Ofs(sonido^) shr 4) shr 12;
  Port[$0A] := 5;
  Port[$0C] := 0;
  Port[$0B] := $49;
  Port[$02] := Lo(offset);
  Port[$02] := Hi(offset);
  Port[$83] := page;
  Port[$03] := Lo(s);
  Port[$03] := Hi(s);
  Port[$0A] := 1;
  { Set the playback frequency }
  time_constant := 256 - 1000000 div freq;
  WriteDSP($40);
  WriteDSP(time_constant);
  { Set the playback type (8-bit) }
  WriteDSP($14);
  WriteDSP(Lo(s));
  WriteDSP(Hi(s));
  end;
end;

Procedure LoadVOC;
Var
  F    : file;
begin
  with sound do begin
    {$I-}
    assign (f,Archivo);
    reset (f,1);
    {$I+}
    If IOResult <> 0 then begin
      TextMode (LastMode);
      Writeln ('Hubo error al intentar acceder al archivo ',Archivo);
      Halt;
      end;
    Freq := 10989;
    S := Tamano;
    If S = 0 then begin
      seek (f,Inicio);
      blockread (f,D,6);
      S := ord(D.len[3]) + ord(D.len[2]) * 256 + ord(D.len[1]) * 256 * 256;
      end;
    seek (f,Inicio+7);
    getmem (Sonido,S);
    blockread (F,Sonido^,S);
    close (f);
  end;
end;

Procedure UnloadVOC (VAR Sound : VOCSound);
Begin
  with sound do begin
    Freq := 0;
    FreeMem (Sonido,S);
    S    := 0;
    With D do begin
      Id   := 0;
      Len[1] := 0;
      Len[2] := 0;
      Len[3] := 0;
      Sr   := 0;
      Pack := 0;
    end;
  end;
End;

Procedure Play_and_UnloadVOC (Archivo:String; Inicio,Tamano:Word);
Var
  Sonido : VocSound;
Begin
  If Main_Sound = true then begin
    LoadVOC (Archivo,Inicio,Tamano,Sonido);
    PlayBack (Sonido);
    UnloadVOC (Sonido);
  end;
End;

end.