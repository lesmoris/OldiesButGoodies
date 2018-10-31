Procedure ListarArch ( VAR fArchivo : fCorre;
                       VAR rReg     : rRegistroCorrela );
Var
  I       : Longint;
  sTmpCod : String [ 11 ];
  cKy     : Char;
Begin
  ClrScr;
  Seek ( fArchivo,0 );
  WriteLn ( 'Cantidad de Registros: ',FileSize ( fArchivo ) );
  I := 1;
  While Not Eof ( fArchivo ) AND ( cKy <> #27 ) Do
    Begin
      Read ( fArchivo,rReg );
      WriteLn ('Registro N§ : ',I );
      WriteLn ('Codigo : ',rReg.CodMat );
      WriteLn ('Codigo1 : ',rReg.CodMat1 );
      WriteLn ('Tipo : ',rReg.Tipo );
{      sTmpCod := Cadena ( rReg.CodMat ) + Cadena ( rReg.CodMat1 );
      WriteLn ('Codigo de Ordenamiento : ',sTmpCod ); }
      WriteLn;
      cKy := ReadKey;
      Inc ( I );
    End; { While }
  If FileSize ( fArchivo ) = 0
    Then
      ReadKey;
End;

Procedure ListarVect ( VAR aVector : aArrayCorrela;
                       VAR bVecTop : Byte );
Var
  I : Byte;
Begin
  ClrScr;
  WriteLn ( 'Cantidad de elementos: ',bVecCorrTop );
  WriteLn;
  For I := 1 to bVecTop Do
    Begin
      ImprimirDatos ( aCorrela[ I ] );
      ReadKey;
    End;
  If bVecCorrTop = 0 Then ReadKey;
End;

Procedure GuardarCambios ( VAR fArchivo : fCorre;
                           VAR aVec     : aArrayCorrela;
                           VAR rReg     : rRegistroCorrela;
                           VAR bNOp,
                               bVecTop  : Byte );
Begin
  ApareoABM ( fArchivo,'DAT\Correla.DAT',rReg,aVec,bVecTop );
  bNOp := 0;
  bVecCorrTop := 0;
  Reset ( fCorrela );
End;

Procedure Reiniciar ( VAR fArchivo : fCorre;
                      VAR bNOp,
                          bVecTop  : Byte );
Begin
  bNOp := 0;
  bVecCorrTop := 0;
  Reset ( fCorrela );
End;