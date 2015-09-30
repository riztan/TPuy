/* $Id: main.prg,v 1.0 2008/10/23 14:44:02 riztan Exp $*/
/*
   Copyright © 2008-2014  Riztan Gutierrez <riztang@gmail.com>

   Este programa es software libre: usted puede redistribuirlo y/o modificarlo 
   conforme a los términos de la Licencia Pública General de GNU publicada por
   la Fundación para el Software Libre, ya sea la versión 3 de esta Licencia o 
   (a su elección) cualquier versión posterior.

   Este programa se distribuye con el deseo de que le resulte útil, pero 
   SIN GARANTÍAS DE NINGÚN TIPO; ni siquiera con las garantías implícitas de
   COMERCIABILIDAD o APTITUD PARA UN PROPÓSITO DETERMINADO. Para más información, 
   consulte la Licencia Pública General de GNU.

   http://www.gnu.org/licenses/
*/

/** \file main.prg.
 *  \brief Programa Inicial  
 *  \author Riztan Gutierrez. riztan@gmail.com
 *  \date 2008
 *  \remark Donde comienza la historia...
*/

/** \mainpage Archivo Principal (index.html)
 *
 * \section intro_sec Introduccion
 *
 * Esta es la introducción.
 *
 * \section install_sec Instalacion
 *
 * \subsection step1 Paso 1: Inicializando Variables
 *
 * etc...
 */

//#include "proandsys.ch"
//#include "gclass.ch"
#include "tepuy.ch"
#include "tgtkext.ch"
#include "tgtkext2.ch"
#include "tpy_extern.ch"
//#include "libgdaext.ch"
#include "tip.ch"
#include "tpy_init.ch"

// #include "hbstruct.ch"
// #include "hblang.ch"

EXTERNAL HB_LANGSELECT


// GLOBAL oTpuy  /** \var GLOBAL oTpuy. Objeto Principal oTpuy. */

memvar oTpuy

// memvar oMsgRun_oLabel, oMsgRun_oImage

/** \brief Inicio. Donde comienza todo.
 */
Function Main( ... )
//Function Main(  )

   Local oError, uReturn
   Local cVersion:="0.1 (Alfa)"
   Local cSystem_Name:=TPUY_NAME+" v"+cVersion

   Local tValor := hb_DateTime() //ROUND(SECONDS()+50,0)

//   Default uPar1 := "", uPar2 := "", uPar3 := "", uPar4 := ""

   SetGtkBuilder( .t. )
//   pGt := hb_gtCreate("WVT")
//? VALTYPE(pGt)
//   hb_gtSelect(pGt)

   // Public oMsgRun_oLabel, oMsgRun_oImage
   Public oApp,oTpuy

   CLOS ALL
   SET DELE ON
   SET WRAP ON
   SET SCOR OFF
   SET BELL OFF
   SET SOFT ON
   SET EXCL OFF
//   SET DECI TO 2
   SET DATE FORMAT TO TPY_DATEFORMAT
   SET CENTURY ON
   SET EPOCH TO ( YEAR( DATE() ) - 50 )
   SET Delete On

#ifdef __HARBOUR__
   SET( _SET_HBOUTLOG, "error_.log" ) 
#endif

   HB_LANGSELECT("ES")

//   SET CENTURY ON
//   SET DATE ITALIAN
//   SET EXACT ON   // No se porque... pero esto falla con los script.
//   SET DECIMALS TO 2
   SET CONFIRM ON

   oTpuy := Tapp():New()

   DEFINE PUBLIC oTpuy:oScript 

   oTpuy:cVersion     :=cVersion
   oTpuy:cSystem_Name :=cSystem_Name
   oTpuy:lSalir       := .F.
   oTpuy:cTime := Left( cStr( Time() ), 5 )
   oTpuy:lSBarUpdate  := .T.
   oTPuy:aStBarItem   := Array(10)
//   oTpuy:l_gnome_db_init := .F.

   /*
     Definicion de Timer General
     Desconozco por los momentos el porque si activo una ventana antes que el
     timer... Este luego no funciona.
   */
   DEFINE TIMER oTpuy:oTimer;
          INTERVAL 10000;  /* 1000 = 1seg */
   	  ACTION tValor := TestTimer(tValor);

   ACTIVATE TIMER oTpuy:oTimer

/*
 * Lo primero es intentar conectar a la base de datos para tomar 
 * las configuraciones iniciales 
 * 
*/

//   oTpuy:aTabs_Main := { TP_TABLE_MAIN, TP_TABLE_ENTITY }
   oTpuy:cMainSchema:= Alltrim(TPUY_SCHEMA)+"."
   oTpuy:cImages    := "./images/"
   oTpuy:cResources := "./resources/"
   oTpuy:cTablas    := "./tables/"
   oTpuy:cIncludes  := "./include/"
   oTpuy:cXBScripts := "./xbscripts/"
   oTpuy:cSQLScr    := "./sql/"
   oTpuy:cDocs      := "./doc/"
   oTpuy:cHomePath  := HOMEPATH
   oTpuy:cTempDir   := oTpuy:cHomePath+"/.tpuy_tmp/"

   oTpuy:cTemps     := oTpuy:cTempDir

   oTpuy:cResource  := ""
   oTpuy:cRsrcMain  := oTpuy:cResources+"proandsys.glade"

   oTpuy:cOS        := ""
   oTpuy:cIconMain  := ""
   oTpuy:cAppName   := ""

   oTpuy:cPassword  := "Sarisariñama"
   
   oTPuy:lNetIO     := .F.  // Conexion con servicio de TPuy
   //-- Modo Debug
   oTpuy:lDebug     := .T.  // Activa o Desactiva en View()

   oTpuy:lMainRun   := .f.

   oTpuy:nDecimals  := 2

   TRY
     RUNXBS( "init.conf" )
   CATCH
     MsgStop("Hay problemas para leer el archivo <b>'init.conf'</b>","Finalizado.") 
     RETURN NIL
   END

   SET DECIMALS TO oTpuy:nDecimals

   // Debemos resetear nombre de la aplicacion luego de ejecutar el init.conf 
   oTpuy:SetAppName( TPUY_NAME )

   If !File(oTpuy:cTempDir)
      DirMake(oTpuy:cTempDir)
   Endif

//netio_main()
//return

   IF !Empty( hb_pValue(1) )

/*
      IF ("SAVE" IN UPPER( uPar2 ) )
         SaveScript(uPar1, MEMOREAD(uPar1) ,;
                           IIF( UPPER(uPar2)="SAVEEXEC",.T.,.F. ) )
         oTpuy:Release()
         CLEAR SCREEN
         Quit
      ENDIF
*/
      If File(oTpuy:cXBScripts + hb_pValue(1) + ".xbs")
         oTpuy:RunXBS( ... )
      Else
         MsgStop("No puede localizar ["+hb_pValue(1)+".xbs]")
      EndIf
      oTpuy:Release()
      Quit

   ENDIF
   
   oTpuy:aConnection:= {}
   DEFINE PUBLIC oTpuy:oConnections

   // No se porque, pero si se define el recurso antes de 
   // activar el timer, el timer no funciona
   // SET RESOURCES oTpuy:cResource FROM FILE oTpuy:cRsrcMain 

//   MemoToXML() // Guardamos los valores de conexion.

   TRY
     uReturn := oTpuy:RunXBS('begin')
     Salir( .f., uReturn )
   CATCH oError
     MsgStop("Se ha presentado un problema durante la ejecución del script '<b>begin</b>'",;
             "Fin de Ejecución.")
     Eval( ErrorBlock(), oError ) 
     RETURN NIL
   END
Return uReturn



/** \brief Realiza la Salida del Sistema
 */
Function Salida( lForce )

   DEFAULT lForce := .T.

   oTpuy:Exit( lForce )
   
Return .F.



/** \brief Realiza la Salida del Sistema
 */
Function Salir( lForce, uReturn )

   Default lForce := .F.
   
   If Salida( lForce )

//      TRY
//         PQClose(oTpuy:conn)
//      CATCH
//      END

      IF oTpuy:oWnd != NIL
         oTpuy:oWnd:End()
      ENDIF
      oTpuy:End()
      gtk_main_quit()
      //Quit
      Return uReturn

   EndIf

Return uReturn



/** \brief Test para Timer. (Funcion Provisional)
 */
Function TestTimer(tValor)

   local cItem, nItems := 0
   local rApp

   DEFAULT tValor := hb_DateTime()

   If HB_ISNIL(oTpuy:oWnd)
      Return hb_DateTime()
   EndIf

   if !oTpuy:IsDef("cStBarTxt")  ; oTpuy:Add("cStBarTxt","")  ; endif
/*
   if !oTpuy:IsDef("aStBarItem") 
      oTpuy:Add("aStBarItem",Array(10))
      oTpuy:aStBarItem[1] := ""
      oTpuy:aStBarItem[2] := ""
      oTpuy:aStBarItem[3] := ""
   endif
*/
   If tValor <= hb_DateTime() .AND. !Empty( oTpuy:oStatusBar )

      oTpuy:cTime := Left( cStr( Time() ), 5 )
      oTpuy:aStBarItem[1] := oTpuy:cSystem_Name
      oTpuy:aStBarItem[2] := "Hora: " + oTpuy:cTime

      if oTpuy:IsDef("oUser") .and. oTpuy:oUser:IsDef("cUserName")
         rApp := oTpuy:rApp
         //if Empty( oTpuy:aStBarItem[3] )
            oTpuy:aStBarItem[3] := oTpuy:oUser:cUserName
            if !Empty(rApp) .and. ~~rApp:DevelMode()
               oTpuy:aStBarItem[3] += " [Devel] "
            endif
         //endif
      endif
if oTpuy:lSBarUpdate
      oTpuy:cStBarTxt := ""
      nItems := Len(oTpuy:aStBarItem)
      FOR EACH cItem IN oTpuy:aStBarItem
         if ValType( cItem ) = "C"
            if cItem:__EnumIndex() = 1
               oTpuy:cStBarTxt += cItem
            else
               oTpuy:cStBarTxt += " | "
               oTpuy:cStBarTxt += cItem
            endif
         endif
      NEXT
      oTpuy:oStatusBar:SetText( oTpuy:cStBarTxt )
endif
 
      tValor := hb_DateTime() //+0.001 

   Endif

Return tValor


Function SaveScript( cFile, cText, lExec, p1,p2,p3,p4,p5,p6,p7,p8,p9,p10 )

   Local lRet
#ifndef __HARBOUR__
   Local oInterpreter, cFilePPO
   Local oFile, oRun, lRet

   Default cText := '' , lExec := .F.

   If RIGHT( lower(cFile) , 4 ) = '.xbs'

      cFilePPO := Left( cFile , LEN(cFile) - 4 ) + ".ppo"

      If File( cFilePPO  )

         If FErase( cFilePPO ) <> 0
            MsgStop( MSG_FILE_NO_DELETE , MSG_TITLE_ERROR )
            Return .F.
         EndIf

      EndIf

      oInterpreter := TInterpreter():New(cFile)

      oInterpreter:SetScript( cText, 1 , cFile )
      If !lExec
         oInterpreter:lExec:=.F.
      EndIf
      lRet := oInterpreter:Run( { p1,p2,p3,p4,p5,p6,p7,p8,p9,p10 } )

      cText := ''

      AEVAL( oInterpreter:acPPed , {|a|                                  ;
                                     IIf( a <> NIL .AND. Left(a,1)<>"#", ;
                                         cText += a + CRLF , NIL )       ;
                                   } )

      //Escribiendo el pre-procesado
      
      oFile := gTextFile():New( cFilePPO, "W" )

      oFile:WriteLn( cText )

      oFile:Close()

      MsgInfo( "Generado "+ALLTRIM( cFilePPO ) ) 
   Else

      MsgStop( MSG_FILE_NO_ADEQUATE , MSG_FILE_NO_SAVE)

   EndIf
#endif
Return lRet



function FromRemote( cFuncName, cObj, ... )
   local uValue, cValtype, uReturn
   local cHandle

   if hb_pValue(1) = nil ; return nil ; endif
   if oTpuy:IsDef("oUser")

      cHandle := oTpuy:oUser:cHandle
      default cHandle to ""

      if UPPER(cObj) == "OSERVER" ; cObj := cHandle ; endif

//tracelog( "solicitando "+cFuncName+" ,"+cHandle+", ..." )
      uReturn := hb_deserialize( netio_funcexec( cFuncName, cHandle, cObj, ...  ) )
   else
//tracelog( "solicitando "+cFuncName+" , , ..." )
      uReturn := hb_deserialize( netio_funcexec( cFuncName, "", cObj, ...  ) )
   endif
return uReturn //hb_deserialize( netio_funcexec( ... ) )


/** TraceLog()
 *  Registra mensaje en el Objeto oTpuy:oLog
 */
PROCEDURE TPYLOG(uMensaje,cFuncName)
   DEFAULT uMensaje := ""
   DEFAULT cFuncName := ""
   if !Empty(uMensaje)
      if ValType( uMensaje ) != "C" ; uMensaje := hb_ValToExp(uMensaje) ; endif
      if !Empty( cFuncName ); uMensaje := cFuncName + ": " + uMensaje ; endif
      oTpuy:oLog:Insert( uMensaje + CRLF )
   endif
RETURN



//EOF
