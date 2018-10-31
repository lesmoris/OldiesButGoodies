#Include "DbEdit.ch"       
#Include "Inkey.ch"
#Include "Box.ch"
#Include "AChoice.ch"

*Estas son las variables del array EmusCFG
Static  TitEmu := 1,;   
        Dir1   := 2,;   
        Dir2   := 3,;   
        Dir3   := 4,;
        EmuCom := 5,;
        EmuDir := 6,;
        EmuTipo:= 8,;   
        _Emu1  := 9,;   
        _Emu2  := 10,;  
        _Emu3  := 11,;  
        _Emu4  := 12,;  
        _Emu5  := 13,;
        ComEmu1 := 14,;  
        ComEmu2 := 15,;  
        ComEmu3 := 16,;  
        ComEmu4 := 17,;  
        ComEmu5 := 18,;  
        Emu1Pla := 19,;  
        Emu2Pla := 20,;  
        Emu3Pla := 21,;  
        Emu4Pla := 22,;  
        Emu5Pla := 23,;  
        _EmuAct := 24,;  
        ComEmuAct := 25,;
        EmuActPla := 26,;
        EmuDet := 27,;
        EmuDBF := 28

Static Verbose := "OFF",;
       IpsStat := "ON "

Static Gba    := 2,; 
       NGPock := 6

Static EmusCFG,;
       EmuPla,;
       I := 0,;
       CantEmus := 0,;
       Handler,;
       Op := 0,;
       GetList := {},;
       Sw := 0,;
       SwTot := 1,;
       Recno := -1000,;
       Totemu,;
       Tot,;
       EmuAct,;
       Accion,;
       Act,;
       Fil := 0,;
       _verCFG,;
       Separador1 := "------------------------------------------------",;
       Separador2 := "----------------------",;
       scrDOS,;
       scrTMP,;
       Nul

Static IpsMenu,;
		   IpsDir,;
       IpsCantOp,;
		   IpsOp,;
       IpsSw,;
       Source,;
       Ips


Function Main( Op1,Op2,Op3,Op4,Op5 )

  If File("Play.BAT")
    Erase Play.BAT
  endif
  LeerConfig()
  Do While SW = 0
    If SwTot = 1 .AND. Op = 0
      Total()
      SwTot := 0
    EndIf
    If Op = 0
      Fil := 1
      Recno := -1000
      ShowMenu( EmusCFG )
    Endif  
    Cls
    If (Op <> CantEmus) .and. (Op <> 0)
      InitEmu ( Op )
      If File("Play.bat")
        GrabarConfig()
        quit
      endif
      Op := 0
      GrabarConfig("0 ","0   ")
    else
      sw := 1
    endif
  Enddo
  GrabarConfig("0 ","0   ")
  Cls
Return NIL

Function LeerConfig()
Static c
  handler := FOpen( "Menu.CFG" )    
  FSeek ( Handler,154,1 )
  CantEmus := VAL( FReadSTR( handler,4 ))
  Op := VAL( FReadSTR( handler,4 ))
  Recno := VAL( FReadSTR( handler,6 ))
  EmuAct := FReadSTR( handler,8 ) ; FSeek (handler,2,1)
  Tot := FReadSTR( handler,4 ) ; FSeek (handler,2,1)
  EmusCFG := Array( CantEmus,EmuDBF )
  Fil := Val( FReadSTR( handler,2 )) ; FSeek (handler,2,1)
  For I := 1 to CantEmus
    c := FReadSTR (handler,19) ; FSeek (handler,2,1); EmusCFG[I,TitEmu ] := c 
    c := FReadSTR (handler,39) ; FSeek (handler,2,1); EmusCFG[I,Dir1   ] := c 
    c := FReadSTR (handler,39) ; FSeek (handler,2,1); EmusCFG[I,Dir2   ] := c 
    c := FReadSTR (handler,39) ; FSeek (handler,2,1); EmusCFG[I,Dir3   ] := c 
    c := FReadSTR (handler,44) ; FSeek (handler,2,1); EmusCFG[I,EmuCom ] := c 
    c := FReadSTR (handler,44) ; FSeek (handler,2,1); EmusCFG[I,EmuDir ] := c 
    c := FReadSTR (handler,1)  ; FSeek (handler,2,1); EmusCFG[I,EmuTipo] := c 
    c := FReadSTR (handler,8)  ; FSeek (handler,2,1); EmusCFG[I,EmuDBF ] := c 
    c := FReadSTR (handler,8)  ; FSeek (handler,1,1); EmusCFG[I,_Emu1  ] := c
    c := FReadSTR (handler,19) ; FSeek (handler,1,1); EmusCFG[I,ComEmu1] := c
    c := FReadSTR (handler,3)  ; FSeek (handler,2,1); EmusCFG[I,Emu1Pla] := c
    c := FReadSTR (handler,8)  ; FSeek (handler,1,1); EmusCFG[I,_Emu2  ] := c 
    c := FReadSTR (handler,19) ; FSeek (handler,1,1); EmusCFG[I,ComEmu2] := c
    c := FReadSTR (handler,3)  ; FSeek (handler,2,1); EmusCFG[I,Emu2Pla] := c
    c := FReadSTR (handler,8)  ; FSeek (handler,1,1); EmusCFG[I,_Emu3  ] := c 
    c := FReadSTR (handler,19) ; FSeek (handler,1,1); EmusCFG[I,ComEmu3] := c
    c := FReadSTR (handler,3)  ; FSeek (handler,2,1); EmusCFG[I,Emu3Pla] := c
    c := FReadSTR (handler,8)  ; FSeek (handler,1,1); EmusCFG[I,_Emu4  ] := c 
    c := FReadSTR (handler,19) ; FSeek (handler,1,1); EmusCFG[I,ComEmu4] := c
    c := FReadSTR (handler,3)  ; FSeek (handler,2,1); EmusCFG[I,Emu4Pla] := c
    c := FReadSTR (handler,8)  ; FSeek (handler,1,1); EmusCFG[I,_Emu5  ] := c 
    c := FReadSTR (handler,19) ; FSeek (handler,1,1); EmusCFG[I,ComEmu5] := c
    c := FReadSTR (handler,3)  ; FSeek (handler,2,1); EmusCFG[I,Emu5Pla] := c
    IF Op != I
      EmusCFG[I,_EmuAct] := EmusCFG[I,_Emu1]
      EmusCFG[I,ComEmuAct] := EmusCFG[I,ComEmu1]
      EmusCFG[I,EmuActPla] := EmusCFG[I,Emu1Pla]
    ELSE 
      EmusCFG[I,_EmuAct] := EmuAct
      Do Case
        Case EmuAct = EmusCFG[I,_Emu1]
          EmusCFG[I,ComEmuAct] := EmusCFG[I,ComEmu1]
          EmusCFG[I,EmuActPla] := EmusCFG[I,Emu1Pla]
        Case EmuAct = EmusCFG[I,_Emu2]
          EmusCFG[I,ComEmuAct] := EmusCFG[I,ComEmu2]
          EmusCFG[I,EmuActPla] := EmusCFG[I,Emu2Pla]
        Case EmuAct = EmusCFG[I,_Emu3]
          EmusCFG[I,ComEmuAct] := EmusCFG[I,ComEmu3]
          EmusCFG[I,EmuActPla] := EmusCFG[I,Emu3Pla]
        Case EmuAct = EmusCFG[I,_Emu4]
          EmusCFG[I,ComEmuAct] := EmusCFG[I,ComEmu4]
          EmusCFG[I,EmuActPla] := EmusCFG[I,Emu4Pla]
        Case EmuAct = EmusCFG[I,_Emu5]
          EmusCFG[I,ComEmuAct] := EmusCFG[I,ComEmu5]
          EmusCFG[I,EmuActPla] := EmusCFG[I,Emu5Pla]
      EndCase
    ENDIF
    If Op != 0
      SwTot := 0
    Endif
  Next I
  FClose (handler)
  Cls
  For I := 1 to CantEmus
*    EmusCFG[I,TitEmu] := Left ( EmusCFG[ I,TitEmu ] , Len( EmusCFG[I,TitEmu] ) - 1 )
    EmusCFG[I,TitEmu] := Right( EmusCFG[ I,TitEmu ] , Len( EmusCFG[I,TitEmu] ) - 1 )
  Next I
  If _verCFG = "-E"
    For Op := 1 to CantEmus 
      If Op = CantEmus
        Op := CantEmus - 1
      Endif
      EditItem()
      Cls
      Do Case
    	  Case LastKey() = K_ESC
  	      Quit
    	  Case LastKey() = K_PGUP
  	      Op := Op - 2
  	      If Op < 0 
  	        Op := 0
  	      Endif
      End Case
    Next op
    Quit
  EndIf
Return NIL
  
Function GrabarConfig(OpcionMenu,NRegistro)
  Handler := FOpen( "Menu.CFG",2 )    
  FSeek (Handler,158,0)
  If OpcionMenu = NIL
    EmuAct := EmusCFG[ Op,_EmuAct ]
    Op := Alltrim( Str( Op ) )
    Op := Op + Space( 2 - Len(Op) )
    Recno := Alltrim( Str(Recno) )
    Recno := Recno + Space( 4 - Len(Recno) )
    FWrite (Handler,Op + Chr(13) + Chr(10) )
    FWrite (Handler,Recno + Chr(13) + Chr(10) )
    FWrite (Handler,EmuAct + Chr(13) + Chr(10) )
  Else
    FWrite (Handler,OpcionMenu + Chr(13) + Chr(10) )
    FWrite (Handler,NRegistro  + Chr(13) + Chr(10) )
    FWrite (Handler,"        " + Chr(13) + Chr(10) )
  Endif
  Tot := Alltrim( Tot )
  Tot := Tot + Space( 4 - Len(Tot))
  FWrite (Handler,Tot + Chr(13) + Chr(10))
  Fil := Alltrim( Str( Fil ))
  Fil := Fil + Space( 2 - Len( Fil ))
  FWrite (Handler,Fil + Chr(13) + Chr(10))
  FClose (Handler)
Return Nil

Function ShowMenu( Menu )
Local aElemMenu,aElemDisp

  SetColor ("R+/N")
  @1,1 Say "Elija su Opcion:"
  @24,0 Say "Total de Juegos en el men£: "+Alltrim(Tot)
  SetColor ("W/N")
  If !File("E:\ARCADES2\ARJ.EXE")
    SetColor ("R+/N")
    @1,40 Say "No esta puesto el CD de los emuladores"
    SetColor ("W/N")
  EndIf
  aElemMenu := Array( CantEmus )
  aElemDisp := Array( CantEmus )
  For I := 1 to CantEmus
    aElemMenu[ I ] := Menu [ I,1 ]
    aElemDisp[ I ] := .T.
  Next I
  SetColor ("W/N,BG+/B,,,W/N")
*  ConsDet( 1 )
  Op := AChoice (3,1,3+CantEmus,20,aElemMenu,aElemDisp,"OtraTecla" )
  I := 0
Return NIL

INIT Procedure Begin( Op1,Op2,Op3,Op4,Op5 )
  Save Screen to scrDOS
  Cls

  LineaDeComandos( Op1 )
  LineaDeComandos( Op2 )
  LineaDeComandos( Op3 )
  LineaDeComandos( Op4 )
  LineaDeComandos( Op5 )

*  MouseInit( 2 )
*  MouseOn()
  SET MESSAGE TO 23
  SET SOFTSEEK ON
Return

Exit Procedure Salir()
  IF FILE( "MENU.NTX" )
    Erase MENU.NTX
  ENDIF  
Return

Function EditItem()
  @3,0  Say "Nombre:    "  Get EmusCFG[Op,TitEmu ]
  @4,0  Say "Emulador1: "  Get EmusCFG[Op,_Emu1  ]
  @4,25 Say "Descripcion:" Get EmusCFG[Op,ComEmu1]
*  @4,60 Say "Plataforma :" Get EmusCFG[Op,Emu1Pla]
  @5,0  Say "Emulador2: "  Get EmusCFG[Op,_Emu2  ]
  @5,25 Say "Descripcion:" Get EmusCFG[Op,ComEmu2]
*  @5,60 Say "Plataforma :" Get EmusCFG[Op,Emu2Pla]
  @6,0  Say "Emulador3: "  Get EmusCFG[Op,_Emu3  ]
  @6,25 Say "Descripcion:" Get EmusCFG[Op,ComEmu3]
*  @6,60 Say "Plataforma :" Get EmusCFG[Op,Emu3Pla]
  @7,0  Say "Emulador4: "  Get EmusCFG[Op,_Emu4  ]
  @7,25 Say "Descripcion:" Get EmusCFG[Op,ComEmu4]
*  @7,60 Say "Plataforma :" Get EmusCFG[Op,Emu4Pla]
  @8,0  Say "Emulador5: "  Get EmusCFG[Op,_Emu5  ]
  @8,25 Say "Descripcion:" Get EmusCFG[Op,ComEmu5]
*  @8,60 Say "Plataforma :" Get EmusCFG[Op,Emu5Pla]
  @9,0  Say "Ubicaci¢n: "  Get EmusCFG[Op,EmuDir ]
  @10,0  Say "Dir1:      "  Get EmusCFG[Op,Dir1   ]
  @11,0 Say "Dir2:      "  Get EmusCFG[Op,Dir2   ]
  @12,0 Say "Dir3:      "  Get EmusCFG[Op,Dir3   ]
  @13,0 Say "Comentario:"  Get EmusCFG[Op,EmuCom ]
  @14,0 Say "Tipo:      "  Get EmusCFG[Op,EmuTipo]
*  @14,0 Say "Detalles de la Consola:" Get EmusCFG[Op,EmuDet]
  @15,0 Say "DBF:" Get EmusCFG[Op,EmuDBF]
*  @15,0 Say "Comentario:"  Get EmusCFG[Op,ComEmuAct]
*  @16,0 Say "Plataforma:"  Get EmusCFG[Op,EmuActPla]
  Read
Return Nil

Procedure InitEmu( Op )
Static Dbf,Tit,xx
  Cls
  Dbf := Alltrim(EmusCFG[OP,EmuDir])+"\"+Alltrim(EmusCFG[OP,EmuDbf])
  Use &Dbf
  Index on NOMBRE to &DBF
  If !File("E:\ARCADES2\ARJ.EXE")
    Set Filter To Directorio = "ROMS" .or. Directorio = "roms"
  EndIf
  Fil := Filtros( Fil )
  If Recno = -1000
    Go Top
  Else
    Go Recno
  Endif
  Info()
  SetColor ("W+/G")
  @0,0 Clear To 0,79
  Tit := "Menu de Juegos para el " + Alltrim( EmusCFG[ Op,TitEmu ] ) 
  xx := ( 79 - Len( Tit )) / 2 
  @0,xx Say Tit
  SetColor ("W+/B,N/W,,,W/B")
*  If Op = 8
*    DBEdit (1,0,23,79,{"Nombre","Archivo"},"DB")
*  Else
    DBEdit (1,0,23,79,{"Nombre","Tipo","Aprobado"},"DB")
*  EndIf
  CLOSE DATA
  DBF := DBF + ".NTX"
  ERASE &DBF
  SetColor ("W/N")
  Cls
Return

Function DB ( nModo, nCol )
  Local nTecla := LastKey()
  Local nValRet := DE_CONT
  Local Sc,S
  Do Case
    Case nModo == DE_IDLE
      Return DE_CONT
    Case nModo == DE_HITTOP
      Return DE_CONT
    Case nModo == DE_HITBOTTOM
      Return DE_CONT
    Case nModo == DE_EMPTY
      SetColor ("W/R+")
      @5,20 Clear TO 10,60
      @5,20,10,60 Box B_SINGLE
      @6,25 Say "No hay juegos para esta consola"
      @7,25 Say " o para el filtro seleccionado "
      @8,25 Say "    Quer‚s poner uno nuevo?    "
*      I := AChoice ( 9,32,9,35, {" NO "," SI "},,"OtraTecla" )
      @9,32 Prompt " NO "
      @9,45 Prompt " SI "
      Menu to I 
      Do Case
        Case I = 2
          SetColor ("W+/B")
          Browse(0,0,24,79)
      End case 
      SetColor ("W/N")
      Return 0
    Case nModo == DE_EXCEPT
      Do Case
        Case nTecla == K_F1
          s := MenuCont()
          Return s
        Case nTecla == K_F2
          CambiarEmulador()
        Case nTecla == K_F3
          Editar()
          Info()
        Case nTecla == K_F4
          Configuracion()
          Return 2
        Case nTecla == K_F5
          OrdNombre()
          Return 2
        Case nTecla == K_F6
          OrdTipo()
          Return 2
*        Case nTecla == K_F7
*          Ordubic()    
*          Return 2
        Case nTecla == K_F8
          BuscarJuego()
        Case nTecla == K_F9
          Fil := Filtros(0)
          Return 2
        Case nTecla == K_F10
          Save Screen to scrTMP
          Restore Screen from scrDOS
          Inkey(0)
          Restore Screen from scrTMP
          Return 2
        Case nTecla == K_F12
          PACK
          Info()
          SwTot := 1
          Return 1
        Case nTecla == K_ESC 
          Recno := Recno()
          Return 0
        Case nTecla == K_ENTER
          Save Screen
          Accion := Ejecutar()
          Restore Screen      
          Return Accion
        Case nTecla == K_INS
          InsertarCampo()
        Case ((nTecla >= 97) .and. (nTecla <= 122)) .or. ((nTecla >= 48) .and. (nTecla <= 57))
          nTecla := CHR(nTecla)
          nTecla := Upper(nTecla)
          DBSeek (nTecla)
          Return (1)
        End Case
  End Case
Return NIL

Function Crear_BAT()
Static handler,Game,Opcion,Path,Dir,Ext,Emu
  IF VERBOSE = "OFF" 
    NUL := ">NUL"
  ELSE
    NUL := ""
  ENDIF
  handler = FCREATE("Play.BAT",0)
  FWRITE (handler,"@ECHO OFF" + CHR(13) + CHR(10))
  FWRITE (handler,"CD "+EmusCfg[Op,EmuDir]+CHR(13) + CHR(10))
  Do Case
    Case EmusCFG[Op,EmuTipo] = "1"
//  Quiere decir que es un emulador de consolas

       Emu := SelectEMU( Emu )
       If Emu = Space(8) 
         FClose (handler)
         Erase Play.Bat
         Return 1
       Endif

       IpsDir := Alltrim( ARCHIVO )
       ElegirIPS( EmusCfg[ Op,EmuDir ] )
       If Ips = "Back"
         FClose ( Handler )
         Erase Play.Bat
         Return 1
       Endif

       IF ARJ = SPACE(8) 
         Game := Alltrim(ARCHIVO)
       ELSE
         Game := Alltrim(ARJ)
       ENDIF   

       IF DIRECTORIO = Space(Len(DIRECTORIO))
         Dir := Alltrim(ARCHIVO)
       ELSE
         Dir := Alltrim(DIRECTORIO)
       ENDIF

       If File( Alltrim(EmusCFG[ Op,Dir1 ])+DIR+"\"+Game+".*" )
         Path := Alltrim(EmusCFG[ OP,Dir1 ])
       ElseIf File( Alltrim(EmusCFG[ Op,Dir2 ])+DIR+"\"+Game+".*" )
         Path := Alltrim(EmusCFG[ Op,Dir2 ])
       Else
         Path := Alltrim(EmusCFG[ Op,Dir3 ])
       Endif

       Ext := "."+EXTENSION
       Dir := Dir+"\"

       FWRITE (handler,"MD "+Game +CHR(13) + CHR(10))
       If COMPTIPO = "Z" 
         FWRITE (handler,"PKUNZIP "+Path + Dir + Game +" "+Game+" -O "+ NUL + CHR(13) + CHR(10))
       ElseIf COMPTIPO = "W" 
         FWRITE (handler,"WZUNZIP "+Path + Dir + Game +" "+Game+" -O "+ NUL + CHR(13) + CHR(10))
       ELSEIF COMPTIPO = "C" 
         FWRITE (handler,"ACE E "+Path + Dir + Game +" "+Game+"\"+ NUL + CHR(13) + CHR(10))
       ELSEIF COMPTIPO = "A" 
         FWRITE (handler,"ARJ E "+Path + Dir + Game +" "+Game+" -U -Y "+ NUL + CHR(13) + CHR(10))
       ELSE
         FWRITE (handler,"PKUNZIP "+Path + Dir + Game +" "+Game+" -O "+ NUL + CHR(13) + CHR(10))
       ENDIF
       If Ips != "Ninguno" .AND. Ips != NIL
         FWRITE (handler,"IF EXIST IPS\" +IPSDir+ "\" +Alltrim( ARCHIVO )+ ".ZIP " + "GOTO IPS_1" + CHR(13) + CHR(10))
         FWRITE (handler,"GOTO IPS_2" + CHR(13) + CHR(10))
         FWRITE (handler,":IPS_1" + CHR(13) + CHR(10))
         FWRITE (handler,"PKUNZIP IPS\"+IPSDir+"\"+Alltrim( ARCHIVO )+".ZIP "+IPS+" "+ nul + CHR(13) + CHR(10))
         FWRITE (handler,"MOVE "+IPS+" "+GAME +" "+ nul + CHR(13) + CHR(10))
         FWRITE (handler,"IPS "+GAME+"\"+Alltrim(ARCHIVO)+EXT+" "+GAME+"\"+IPS+ CHR(13) + CHR(10))
         FWRITE (handler,":IPS_2" + CHR(13) + CHR(10))
       Endif
       IF VERBOSE = "ON "
         FWRITE (handler,"PAUSE >NUL" + CHR(13) + CHR(10))
       ENDIF
       IF EmusCFG[Op,EmuActPla] = "WIN"
         FWRITE (handler,"START /W "+Alltrim( Emu )+" "+Game+"\"+ Alltrim(Archivo) + Ext +" "+Alltrim(Opciones)+ chr(13) + chr(10))     
       ELSE
         FWRITE (handler,"CALL "+Alltrim( Emu )+" "+Alltrim(Opciones)+" "+Game+"\"+ Alltrim(Archivo) + Ext +" "+Alltrim(Opciones)+ chr(13) + chr(10))
       ENDIF
       FWRITE (handler,"DELTREE /Y "+Game+" "+ NUL + CHR(13) + CHR(10))

    Case EmusCFG[Op,EmuTipo] = "2"
//  Quiere decir que es un emulador que soporta lor roms en ZIP's comprimidos*/

       Emu := SelectEMU(Emu)
       If Emu = Space(8) 
         FCLOSE (handler)
         Erase Play.Bat
         Return 1
       Endif
       IF EmusCFG[Op,EmuActPla] = "WIN"
         FWRITE (handler,"START /W "+ Emu + " " +Alltrim(Archivo) +" "+Alltrim(Opciones)+ chr(13) + chr(10))     
       ELSE
         FWRITE (handler,"Call "+Emu+" "+ Alltrim(Archivo) + " "+ Alltrim(Opciones) + chr(13) + chr(10))
       ENDIF

    Case EmusCFG[Op,EmuTipo] = "3"
//  Quiere decir que es un emulador que necesita comandos especiales
      Do Case  

        Case Op = NGPOCK
          Emu := SelectEmu(Emu)
          IPS := Alltrim(ARCHIVO)
          If Emu = Space(8) 
            FCLOSE (handler)
            Erase Play.Bat
            Return 1
          ElseIF Emu = "NGPOCKET" .OR. Emu ="NEOPOCOT"
            FWrite (handler,"PKUNZIP ROMS.NGP\"+Alltrim(ARJ) +" ROMS.NGP\ -d -o "+ NUL +CHR(13)+CHR(10))  
            FWrite (handler,"REN ROMS.NGP\*.NPC *.NGP" +CHR(13)+CHR(10))                  
      
            FWrite (handler,"IF EXIST IPS\"+IPS+"\"+IPS+".IPS GOTO IPS_1" + CHR(13) + CHR(10))
			      FWRITE (handler,"GOTO IPS_2" + CHR(13) + CHR(10))
            FWRITE (handler,":IPS_1" + CHR(13) + CHR(10))
            FWRITE (handler,"IPS ROMS.NGP\"+Alltrim(ARCHIVO)+".NGP IPS\"+Alltrim(ARCHIVO)+"\"+IPS+".IPS"+ CHR(13) + CHR(10))
            FWRITE (handler,":IPS_2" + CHR(13) + CHR(10))
            
            FWrite (handler,"START /W "+ Emu +".EXE ROMS.NGP\"+Alltrim(ARCHIVO)+".NGP"+CHR(13)+CHR(10))
          Else
            FWrite (handler,"PKUNZIP ROMS.NGP\"+Alltrim(ARJ) +" -d -o "+ NUL +CHR(13)+CHR(10))  

            FWrite (handler,"IF EXIST IPS\"+IPS+"\"+IPS+".IPS GOTO IPS_1" + CHR(13) + CHR(10))
			      FWRITE (handler,"GOTO IPS_2" + CHR(13) + CHR(10))
            FWRITE (handler,":IPS_1" + CHR(13) + CHR(10))
            FWRITE (handler,"IPS "+Alltrim(ARCHIVO)+".NPC IPS\"+Alltrim(ARCHIVO)+"\"+IPS+".IPS"+ CHR(13) + CHR(10))
            FWRITE (handler,":IPS_2" + CHR(13) + CHR(10))

            FWrite (handler,"START /W "+ Emu +".EXE"+CHR(13)+CHR(10))
          endif 
          FWrite (handler,"DEL *.ngp "+NUL +CHR(13)+CHR(10))
          FWrite (handler,"DEL *.npc "+NUL +CHR(13)+CHR(10))
          FWrite (handler,"DEL *.ips "+NUL +CHR(13)+CHR(10))
          FWrite (handler,"DEL ROMS.NGP\*.ngp "+NUL +CHR(13)+CHR(10))
          FWrite (handler,"DEL ROMS.NGP\*.npc "+NUL +CHR(13)+CHR(10))
          FWrite (handler,"DEL ROMS.NGP\*.ips "+NUL +CHR(13)+CHR(10))

    End case
  End Case
  FWRITE (handler,"CD.."+ CHR(13) + CHR(10))
  FWRITE (handler,"DEL PLAY.BAT >NUL")
  FCLOSE (handler)
Return 0

Function MenuCont()
Local aElemMenu := {"Jugar a este juego                       - ENTER",;
                    "Cambiar emulador actual                     - F2",;
                    "Editar la base de datos                     - F3",;
                    "Opciones de Configuracion                   - F4",;
                     Separador1,;
                    "Ordenar por Nombre                          - F5",;
                    "Ordenar por Tipo                            - F6",;
                    "Ordenar por Ubicacion                       - F7",;
                    "Buscar juego                                - F8",;
                    "Filtros                                     - F9",;
                    "Ver pantalla de DOS                        - F10",;
                     Separador1,;
                    "Cancelar                                   - ESC"}
Local aElemDisp := {.T. , .T. , .T. , .T. , .F. , .T. , .T. , .T. , .T. , .T. , .T. , .F. , .T.}
Local X1 := 17,;
      X2 := 64,;
      Y1 := 8,;
      Y2 := 20
Local I

  Save Screen
  SetColor ("N/W")
*  I := 1
*Do While (I != 14) .AND. (I != 0)
  @Y1-2 , X1 Say Nombre
  SetColor ("W/R+ , N/W , , , N/R")
  @Y1-1 , X1 Say Separador1
  @Y1-3 , X1-1 , Y2+1 , X2+1 Box B_SINGLE
  I := AChoice (Y1,X1,Y2,X2,aElemMenu,aElemDisp,"OtraTecla")
  Do Case
    Case I = 0
      Restore Screen
    Case I = 1
      Restore Screen
      Save Screen
      Accion := Ejecutar()
      Restore Screen      
      Return Accion
    Case I = 2
      Restore Screen
      CambiarEmulador()
    Case I = 3
      Restore Screen
      Editar()
    Case I = 4
      Restore Screen
      Configuracion()
    Case I = 6
      OrdNombre()
      Restore Screen
    Case I = 7
      OrdTipo()
      Restore Screen
    Case I = 8
*      OrdUbic()
      Restore Screen
    Case I = 9
      Restore Screen
      BuscarJuego()
    Case I = 10
      Restore Screen
      Fil := Filtros(0)
      Return 1
    Case I = 11
      Restore Screen
      Save Screen to scrTMP
      Restore Screen from scrDOS
      Inkey(0)
      Restore Screen from scrTMP
    Case I = 13
      Restore Screen
  End
*Enddo
  SetColor ("W/R+ , N/W , , , W/N")
Return 1

Function Ejecutar()
  Recno := Recno()
  Act := Crear_BAT()
Return Act

Function CambiarEmulador()
  Save Screen
*  SetColor ("W+/N,BG+/B,,,W/N")
  SetColor ("W+/R+,N/W,,,W/R")
  I := 0
  @5,23 Clear TO 12,47
  @5,23,13,48 Box B_SINGLE
  @6,25 Say "Eleg¡ el emulador:"
  @7,25 Say Separador2
  I := AChoice (8,25,12,46, { EmusCFG[Op,ComEmu1],EmusCFG[Op,ComEmu2],EmusCFG[Op,ComEmu3],EmusCFG[Op,ComEmu4],EmusCFG[Op,ComEmu5] },;
                            { .T.,EmusCFG[Op,_Emu2] != Space(8),EmusCFG[Op,_Emu3] != Space(8),EmusCFG[Op,_Emu4] != Space(8),EmusCFG[Op,_Emu5] != Space(8)} , "OtraTecla")
  IF I != 0
    EmusCFG[Op,_EmuAct]   := EmusCFG[Op,8+I]  
    EmusCFG[Op,ComEmuAct] := EmusCFG[Op,13+I]  
    EmusCFG[Op,EmuActPla] := EmusCFG[Op,18+I]
  ENDIF
  Restore Screen
  SetColor ("W+/N,N/W,,,W/N")
  Info()
Return NIL

Function Editar()
  Save Screen
  Cls
  SetColor ("W+/B")
  Browse(0,0,24,79)
  Restore Screen
  If totEmu != Alltrim( STR( RECCOUNT() ))
    totEmu := Alltrim( STR( RECCOUNT() ))
    SwTot := 1
  Endif
Return NIL

Function OrdNombre()
  Index on Nombre to Menu
Return NIL

Function OrdTipo()
  Index on Tipo + Nombre to Menu
Return NIL

Function OrdUbic()
  Index on Directorio + Nombre to Menu
Return NIL

Function BuscarJuego()
Local JAB := Space (30)
  Save Screen
  SetColor ("W/R+")
  @5,23 Clear TO 7,55
  @5,23,8,56 Box B_SINGLE
  @6,25 Say "Escrib¡ el juego a buscar:"
  @7,25 Get JAB
  Read
  If JAB != Space(30)
    JAB := Upper( Left( JAB,1 )) + Lower( Right( JAB, Len(JAB)-1 ))
    Seek JAB
  Endif
  Restore Screen    
  Info()
Return NIL

Procedure Info()
  SetColor ("W+/R")
  @24,0 Clear To 24,79
  @24,0 Say "Emulador: "+EmusCFG[Op,ComEmuAct]
  @24,40 Say "³"
  totEmu := Alltrim( STR( RECCOUNT() ))
  @24,42 Say "Total de Juegos: " + totEmu
  @24,63 Say "³"
  @24,65 Say "F1 mas opciones"
Return

Function Total()
Static Dbf,_tot
  _tot := 0
  For I := 1 to CantEmus-1
    Dbf := Alltrim(EmusCFG[I,EmuDir])+"\"+Alltrim(EmusCFG[I,EmuDbf])
    Use &Dbf
    _Tot := _Tot + RECCOUNT()
    Close Data
  Next I
  Tot := Alltrim(Str(_Tot))
Return Tot

Function SelectEmu(Emu)
Local I
  IF EMULADOR != SPACE(8) 
    IF Alltrim(Emulador) = "?"
      SetColor ("W+/R+,N/W,,,W/R")
      I := 0
      @5,23 Clear TO 10,45
      @5,23,11,45 Box B_SINGLE
      @6,25 Say "Eleg¡ el emulador:"
      I := AChoice (7,25,10,43, { EmusCFG[Op,ComEmu1],EmusCFG[Op,ComEmu2],EmusCFG[Op,ComEmu3],EmusCFG[Op,ComEmu4] },;
                                { .T.,EmusCFG[Op,_Emu2] != Space(8),EmusCFG[Op,_Emu3] != Space(8),EmusCFG[Op,_Emu4] != Space(8)} , "OtraTecla")
      If I = 0
        Emu := Space(8)
        Return Emu
      Else
        Emu := EmusCFG[Op,8+I]
      Endif
      SetColor ("W/N")
    ELSE 
       Emu := Alltrim(EMULADOR)
    ENDIF
  ELSE
    Emu := EmusCFG[Op,_EmuAct]
  ENDIF
  Emu := Alltrim(Emu)
Return Emu

Function Filtros( Fil )
Local aElemMenu := {"Ninguno","Pelea","Ingenio","Aventuras","Plataformas","Accion","Deportes","RPG","Carreras","Naves"}
Local X1 := 20,;
      X2 := 49,;
      Y1 := 9,;
      Y2 := 18
  If Fil = 0 
    Save Screen
    SetColor ("N/W")
    @Y1-2 , X1 Say "Filtrar Por:                   "
    SetColor ("W/R+ , N/W , , , N/R")
    @Y1-1 , X1 Say Left( Separador1,31 )
    @Y1-3 , X1-1 , Y2+1 , X2+1 Box B_SINGLE
    Fil := AChoice (Y1,X1,Y2,X2,aElemMenu)
    Restore Screen
  Endif
  Do Case
    Case Fil = 0
      Fil := 1
      Return Fil
    Case Fil = 1
      If !File("E:\ARCADES2\ARJ.EXE")
        Set Filter To Upper( Directorio ) = "ROMS" 
      Else
        Set Filter To
      EndIf
    Case Fil = 2
      If !File("E:\ARCADES2\ARJ.EXE")
        Set Filter To UPPER( Tipo ) = "PELEA" .and. Upper( Directorio ) = "ROMS"    
      Else
        Set Filter To UPPER( Tipo ) = "PELEA"
      EndIf
    Case Fil = 3
      If !File("E:\ARCADES2\ARJ.EXE")
        Set Filter To UPPER( Tipo ) = "INGENIO" .and. Upper( Directorio ) = "ROMS" 
      Else
        Set Filter To UPPER( Tipo ) = "INGENIO"
      EndIf
    Case Fil = 4
      If !File("E:\ARCADES2\ARJ.EXE")
        Set Filter To UPPER( Tipo ) = "AVENTURAS" .and. Upper( Directorio ) = "ROMS" 
      Else
        Set Filter To UPPER( Tipo ) = "AVENTURAS"
      EndIf
    Case Fil = 5
      If !File("E:\ARCADES2\ARJ.EXE")
        Set Filter To UPPER( Tipo ) = "PLATAFORMAS" .and. Upper( Directorio ) = "ROMS" 
      Else
        Set Filter To UPPER( Tipo ) = "PLATAFORMAS"
      EndIf
    Case Fil = 6
      If !File("E:\ARCADES2\ARJ.EXE")
        Set Filter To UPPER( Tipo ) = "ACCION" .and. Upper( Directorio ) = "ROMS" 
      Else
        Set Filter To UPPER( Tipo ) = "ACCION"
      EndIf
    Case Fil = 7
      If !File("E:\ARCADES2\ARJ.EXE")
        Set Filter To UPPER( Tipo ) = "DEPORTES" .and. Upper( Directorio ) = "ROMS" 
      Else
        Set Filter To UPPER( Tipo ) = "DEPORTES"
      EndIf
    Case Fil = 8
      If !File("E:\ARCADES2\ARJ.EXE")
        Set Filter To UPPER( Tipo )= "RPG" .and. Upper( Directorio ) = "ROMS" 
      Else
        Set Filter To UPPER( Tipo ) = "RPG"
      EndIf
    Case Fil = 9
      If !File("E:\ARCADES2\ARJ.EXE")
        Set Filter To UPPER( Tipo )= "CARRERAS" .and. Upper( Directorio ) = "ROMS" 
      Else
        Set Filter To UPPER( Tipo ) = "CARRERAS"
      EndIf
    Case Fil = 10
      If !File("E:\ARCADES2\ARJ.EXE")
        Set Filter To UPPER( Tipo )= "NAVES" .and. Upper( Directorio ) = "ROMS" 
      Else
        Set Filter To UPPER( Tipo ) = "NAVES"
      EndIf
  End Case
  Go Top
  SetColor ("W/R+ , N/W , , , W/N")
Return Fil


Function Ayuda()
  ?"Front End para Emuladores hecho por Leo"
  ?"Comandos:"
  ?"           -h  Esta pantalla"
  ?"           -e  Editar datos del menu.cfg"
  ?"           -v  Verbose mode.Permite ver todos los comandos del BAT sin el '>NUL' "
  Erase "Play.Bat" 
  quit
Return Nil


Function InsertarCampo()
Local _Tipo := Space(15),;
      _Jug := " ",;
      _Aprobado := Space(10),;
      _Arj := Space(8),;
      _Archivo := Space(8),;
      _Extension := "   ",;
      _Nombre := Space(30),;
      _CompTipo := "Z" ,;
      _Directorio := "ROMS"
       
Local X1 := 20,;
      X2 := 49,;
      Y1 := 10,;
      Y2 := 19

  DBAppend()
  Replace NOMBRE with _Nombre
  Replace TIPO with _Tipo
  Replace JUG with _Jug
  Replace APROBADO with _Aprobado
*  Replace TRUCOS with _Trucos
  Replace ARJ with _Arj     
  Replace ARCHIVO with _Archivo 
  If EmusCFG[Op,EmuTipo] != "2"
    Replace EXTENSION with _Extension
    Replace COMPTIPO with _CompTipo
  Endif
  If Op = NGPOCK
    Replace DIRECTORIO with "ROMS.NGP"
  ElseIf Op = GBA
    Replace DIRECTORIO with "ROMS"
  else    
    Replace DIRECTORIO with _Directorio
  Endif
*  SetColor ("W+/B,N/W,,,W/B")
  SetColor ("W+/B")
  Browse()
Return NIL

Function ElegirIPS( EmuDir )
  If IpsStat = "ON"
	  LeeIpsConfig( EmuDir )
  	If IpsSw != NIL 
    	Ips := NIL
	    Return NIL
  	Endif
	  If IpsCantOp > 2
  	  ShowipsMenu( IpsOP )
    	If IpsOp != 0
  	  	If IpsMenu[IpsOp] != NIL
    	  	Ips := Alltrim( IpsMenu[IpsOp] )
		    Endif
  		Else
    		Ips := "Back"
		  EndIf
  	Else
    	Ips := Alltrim( IpsMenu[ 1 ] )
	  Endif
  EndIf
Return NIL

Function LeeIpsConfig( EmuDir )
Local i,h,c
  If !File( Alltrim(EmuDir)+"\IPS\"+IpsDir+"\Ips.cfg" )
    IpsSw := 1
    Return Nil
  Endif
  h := FOpen( Alltrim(EmuDir)+"\IPS\"+IpsDir+"\Ips.cfg" )
  IpsCantOp := Val( FReadSTR(h,3) ) + 1
  IpsMenu := Array( IpsCantOp ) ; FSeek ( h,1,1 )
  IpsMenu[ IpsCantOp ] := "Ninguno                      "
  For I := 1 to IpsCantOp - 1
    c := FReadSTR( h,12 ); FSeek ( h,2,1 )
    IpsMenu[ I ] := c + Space( ( 29 - Len( c ) ) )
  Next I
  FClose(h)
Return Nil


Function ShowIpsMenu()
Static I
  SetColor ("W/R+")
  I := 0
  @05,23 Clear TO 8 + IpsCantOp , 54
  @05,23,8 + IpsCantOp,55 Box B_SINGLE
  @06,25 Say "Elija el parche a utilizar:"
  IpsOp := AChoice (8,25,8+IpsCantOp,35, IpsMenu ,,"OtraTecla" )
  If IpsOp = 0
    Return Nil
  Endif
  Cls
Return Nil

Function LineaDeComandos( Opcion )
*      _VerCFG := "-E"
  If Opcion = NIL
    Opcion := Space(1)
  Endif
  Opcion := Upper( Alltrim( Opcion ))
  Do Case
    Case Opcion = "-H"
	    Ayuda()
    Case Opcion = "-V"
      Verbose := "ON "
    Case Opcion = "-E"
      _VerCFG := "-E"
  EndCase
Return NIL

Function Configuracion()
Static scr,I,I_Ant
Local aElemMenu := {Separador2,"Verbose Mode","Activar IPS's","Salir       ", AC_CONT}
Local aElemDisp := { .F. , .T. , .T. , .T. }
Local X1 := 20,;
      X2 := 39,;
      Y1 := 10,;
      Y2 := 14

  Save Screen to scr
  I := 1
  SetColor ("W/R+ , N/W , , , W+/R")
  @Y1,X1 Clear TO Y2,X2+5
  @Y1-1,X1-1,Y2+1,X2+5 Box B_SINGLE
	@Y1,X1 Say "Opciones"
	Do While (I != 4) .AND. (I != 0)
  	@Y1+2,X1+21 Say Verbose
  	@Y1+3,X1+21 Say IpsStat
	  I := AChoice (Y1+1,X1,Y2,X2,aElemMenu,aElemDisp,"OtraTecla",I_Ant)
  	Do Case
	    Case I = 2
    	  If Verbose = "ON "
  	      Verbose := "OFF"
	      Else
      	  Verbose := "ON "
    	  Endif
	    Case I = 3
    	  If IpsStat = "ON "
  	      IpsStat := "OFF"
	      Else
      	  IpsStat := "ON "
    	  Endif
  	EndCase
  	I_Ant := I
  End Do
  Restore Screen from Scr
Return NIL

Function OtraTecla( nModo,nElemAct,nRosFila )
Local nValDev := AC_CONT 
Local nTecla := LastKey()
	Do Case
    CASE nModo = AC_EXCEPT
	    DO CASE
		  CASE nTecla = K_RETURN
    	  nValDev := AC_SELECT
	    CASE nTecla = K_ESC
  	    nValDev := AC_ABORT
*      CASE nTecla = K_F1
*        SetColor ("W+/B , N/W , , , W+/R")
*        @5,50 Say "                        "
*        DO CASE
*          Case nElemAct = 1
*            @5,50 Say "Super Nintendo"
*          Case nElemAct = 2
*            @5,50 Say "Nintendo"
*          Case nElemAct = 3
*            @5,50 Say "Gameboy"
*          Case nElemAct = 4
*            @5,50 Say "Sega Genesis"
*          Case nElemAct = 5
*            @5,50 Say "PC Engine"
*          Case nElemAct = 6
*            @5,50 Say "NeoGeo Pocket"
*          Case nElemAct = 7
*            @5,50 Say "Callus"
*          Case nElemAct = 8
*            @5,50 Say "MAME"
*          Case nElemAct = 9
*            @5,50 Say "MAME Old Ver"
*          Case nElemAct = 10
*            @5,50 Say "System 16"
*          Case nElemAct = 11
*            @5,50 Say "Raine"
*          Case nElemAct = 12
*            @5,50 Say "Salir"
*        END CASE
*        SetColor ("W/N,BG+/B,,,W/N")
	  	OTHERWISE
      	nValDev := AC_GOTO
	    ENDCASE
	ENDCASE
Return nValDev

Function ConsDet( numCons )
Local X1 := 30,;
      X2 := 70,;
      Y1 := 4,;
      Y2 := 10

  SetColor ("W+/B , N/W , , , W+/R")
  @Y1,X1 Clear TO Y2,X2+5
  @Y1-1,X1-1,Y2+1,X2+5 Box B_SINGLE
	@Y1,X1 Say "Detalles de la consola:"
  SetColor ("W/N,BG+/B,,,W/N")
Return NIL
