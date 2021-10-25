/* $Id: tools01.prg,v 1.0 2008/10/23 14:44:02 riztan Exp $*/
/*
	Copyright © 2008  Riztan Gutierrez <riztang@gmail.com>

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

/** \file tools01.prg.
 *  \brief Detalle del contenido de \c "tools01.prg" 
 *  \author Riztan Gutierrez. riztan@gmail.com
 *  \date 2008
 *  \remark Comentarios sobre "tools01.prg"
*/

/**
 \details
  Ejemplo de Uso de MsgRun()
 \code
   oRun:=MsgRunStart(MESSAGE_CONNECTING)

         MsgInfo("Alo?")

         oMsgRun_oLabel:SetMarkup(Space(5)+"<b>sii</b>iiiiiiii")
         oMsgRun_oImage:SetFile("../../images/flacoygordo.gif")

         MsgYesNO("fino?")

   MsgRunStop(oRun)
  \endcode
*/

#include "gclass.ch"
#include "proandsys.ch"

// GLOBAL EXTERNAL oTpuy /** \var GLOBAL oTpuy. Objeto Principal oTpuy. */
memvar oTpuy

memvar oMsgRun_oLabel /** \var oMsgRun_oLabel */
memvar oMsgRun_oImage /** \var oMsgRun_oImage */


/** \brief Presenta Mensaje mientras se ejecuta el bloque de codigo.
 *  \par cMensaje, variable tipo caracter.
 *  \par bAction, variable tipo Bloque de Codigo.
 *  \par cImagen,   Imagen a Mostrar.
 *  \par nWidth,    Ancho en pixel del dialogo.
 *  \par nHeight,   Altura en pixel del dialogo.
 *  \par MSGRUN_TYPE, tipo de MSGRUN_TYPE (mensaje a desplegar).
 *  \pre previos...
 *  \ret Verdadero
 */
FUNCTION MsgRun(cMensaje,bAction)

   Local oRun 

   oRun := MsgRunStart(cMensaje,bAction)
   oRun:End()   

Return .T.


/** 
 *  \brief Presenta Mensaje mientras se ejecuta el bloque de codigo.
 *  \par cMensaje, variable tipo caracter.
 *  \par bAction, variable tipo Bloque de Codigo.
 *  \par cImagen
 *  \par nWidth
 *  \par nHeight
 *  \par MSGRUN_TYPE
 */
Function MsgRunStart(cMensaje,bAction,cImagen,nWidth,nHeight/*,MSGRUN_TYPE*/)

   Local oMsgRun, pixbuf, oDraw, oErr, cRes, lRes := .f.

   Public oMsgRun_oLabel, oMsgRun_oImage

   Default cMensaje:="", bAction:={|| .T. }, nWidth:=300, nHeight:=100

   Default cImagen:=oTpuy:cImages+"loading_16.gif"
   
   IIF(ValType(cMensaje)!="C", cMensaje:=hb_ValToExp(cMensaje), NIL)

   IF ValType(bAction)!="B"
      MsgAlert("La Acción no es un bloque de código","MsgRun")
   ENDIF
   
   pixbuf := gdk_pixbuf_new_from_file( oTpuy:cImages+"tepuyes.png" )

   if !FILE( oTpuy:cResources+"msgrun.ui" )
      //oMsgRun := GDialog():New(,nWidth,nHeight,,,,, )
      DEFINE DIALOG oMsgRun SIZE nWidth, nHeight 
   else
      lRes := .t.
      SET RESOURCES cRes FROM FILE oTpuy:cResources+"msgrun.ui"
      DEFINE DIALOG oMsgRun SIZE nWidth, nHeight ID "msgrun" RESOURCE cRes
   endif
//   oBox    := GBoxVH():New( .F.,, .F., oMsgRun, .F., .F.,, .T.,,,, .F., .F., .F.,,,,,,,, )

   if lRes
      DEFINE IMAGE oMsgRun_oImage ;
             FILE oTpuy:cImages+"tepuyes.png" ;
             ID "image1" RESOURCE cRes
      DEFINE LABEL oMsgRun_oLabel ;
             TEXT cMensaje ;
             ID "label1" RESOURCE cRes
//   else
//
//      DEFINE DRAWINGAREA oDraw ;
//             EXPOSE EVENT  MsgRunDraw( oSender, pixbuf, cMensaje );
//             OF oMsgRun CONTAINER

   endif
/*
   oMsgRun_oImage :=GImage():New(cImagen,oBox,.F.,.F.,,.F.;
                 ,,,,,,,, .F., .F., .F., .F.,,,,,,,,,,, .F. )

   oMsgRun_oLabel :=GLabel():New(Space(5)+cMensaje,;
                         .T.,oBox,,.F.,.F.,,.F.,,,,,,.F.,.F.,.F.,.F.,,,,,,,,, 0 )
*/
   oMsgRun:SetSkipTaskBar( .T. )
   oMsgRun:SetDecorated(.F.)
//   oMsgRun:Separator(.F.)

   if lRes 
      ACTIVATE DIALOG oMsgRun CENTER RUN
   else
      oMsgRun:Activate(,,,,,, ,, .T., .F. , .F., .F., .F. )
   endif

//   oMsgRun:Refresh()
//   SecondsSleep(.2)
   SysRefresh()

   TRY
      Eval(bAction)
   CATCH oErr
      MsgAlert("Se presentó un problema al realizar la acción.")
      return oMsgRun
   END

Return oMsgRun




/** 
 *  \brief Muestra Imagen y Mensaje en Ventana MsgRun.
 *  \par oSender
 *  \par pixbuf
 *  \par cMsg
 */
STATIC FUNCTION MsgRunDraw( oSender, pixbuf, cMsg )
  LOCAL gc
  LOCAL pango
  //LOCAL color := { 0, 0XF, 25500, 34534 }
  LOCAL widget

  widget := oSender:pWidget

  gc = gdk_gc_new( widget  )   // cambio propiedades del contexto gráfico gc

  gdk_draw_pixbuf( widget, gc, pixbuf, 0, 0, 0, 0 )

  If !Empty( cMsg )
  
     cMsg := '<span  size="11000"><b><i>'+cMsg
     cMsg += '</i></b> </span>'
     
     pango :=  gtk_widget_create_pango_layout( widget )
     pango_layout_set_markup( pango, cMsg )
     gdk_draw_layout( widget, gc, 10, 15, pango )
     
  EndIf
  
  g_object_unref( gc )


Return .T.




/*
  Para Detener MsgRun
*/
/** \brief Detiene el "msgrun".
 *  \par oMsgRun.  Indica el objeto msgrun que será destruido.
 */
Function MsgRunStop(oMsgRun)
Return IIF( oMsgRun!=NIL , oMsgRun:End(), NIL)




/*
  Grabar archivo .ini
*/
/** \brief Lectura de Archivo .ini
 */
Function LoadIni(cFileIni)

   Local hFile 

   Default cFileIni := oTpuy:cMainIni

   If !File( cFileIni )
      MsgAlert("No es posible localizar el archivo [<b>"+cFileIni+"</b>]" MARKUP )
      Return nil
   EndIf

   hFile:= HB_ReadIni( cFileIni )

Return hFile


/*
  Cargar archivo .ini
*/
/** \brief Almacenar archivo .ini
 *  \par hIni.  Hash con la iformación a almacenar.
 *  \par cFileIni. Nombre del archivo donde se almacenaran los datos.
 *  \par cHead. Comentario para el encabezado. Debe contener ";" o "#" al inicio.
 *  \par cFoot. Comentario al pie del fichero ini. Debe contener ";" o "#" al inicio.
 */
Function SaveIni( hIni,cFileIni,cHead,cFoot )
   local hInitemp,hItem

   DEFAULT cFileIni := "temp.ini"

   hInitemp := hb_IniRead( "" )

   FOR EACH hItem IN hIni
      HSet( hInitemp, hItem:__EnumKey(), hItem )
   NEXT

   if !hb_IniWrite( cFileIni, hInitemp, cHead, cFoot )
      MsgAlert("No se generó el archivo")
      RETURN .F.
   endif

Return .T.



/** \brief Verifica
 */
FUNCTION Connect()

   MsgInfo("Funcion Connect()")

RETURN .F.


/** \brief Visualiza el contenido de un tipo de dato.
 *   Detecta el tipo de dato del parámetro y determina la forma 
 *   de desplegar el contenido del mismo.
 *  \par uValue Tipo de Dato a Examinar.
 */
Function View( uValue  )

   Local oWnd,oBox
   Local nCols,nLins,i,j,lConvertir
   Local aData,cCadena //,aConverted
   Local oScroll,oLbx,oTreeView, aIter
   
   IF !oTpuy:lDebug
      Return NIL
   EndIf

   DEFAULT uValue := ""

   If ValType( uValue )="A" 

      If Empty(uValue)
         MsgStop( hb_ValToExp(uValue), "Arreglo Vacio."  )
         Return NIL
      EndIf

      //aConverted := uValue

      lConvertir := IIF( ValType(uValue[1])!="A", .T. , .F. )

      nLins := Len( uValue )

      IF lConvertir
         nCols := 2
      ELSE
         nCols := LEN(uValue[1])+1
      ENDIF
      
      aData := ARRAY( nLins, nCols )
      //aIter := ARRAY(nCols)

      For i = 1 to nLins
         aData[i,1]   := Alltrim(STRZERO(i,2))
         If lConvertir
            aData[i,2] := iif( ValType( uValue[i] ) == "A", ;
                              CStr( uValue[i] ), ;
                              hb_ValToExp( uValue[i] ) )
         Else
            For j = 1 to nCols-1
               aData[i,j+1] := uValue[i,j] 
            Next j 
         EndIf
      Next i

      DEFINE WINDOW oWnd TITLE "xView( "+CStr(uValue)+" )" SIZE 500,300

         DEFINE BOX oBox SPACING 2 OF oWnd

         /* Scroll bar */
         DEFINE SCROLLEDWINDOW oScroll OF oBox EXPAND FILL // CONTAINER

         /* Modelo de datos */
         DEFINE LIST_STORE oLbx AUTO aData
            
            For i := 1 To Len( aData )
               APPEND LIST_STORE oLbx ITER aIter
               for j := 1 to Len( aData[ i ] )
                  SET LIST_STORE oLbx ITER aIter POS j VALUE aData[i,j]
               next
            Next
            
         /* Browse/Tree */
         DEFINE TREEVIEW oTreeView MODEL oLbx OF oScroll CONTAINER
         oTreeView:SetRules( .T. )            


         For i=0 to nCols-1
            /* Columna simple de texto creada con gtk_tree_view_column_new_with_attributes  */
            cCadena := IIF( i=0, "Lin\Col", STRZERO(i,2) )
            DEFINE TREEVIEWCOLUMN COLUMN i+1 TITLE cCadena TYPE "text" ;
                   WIDTH 70 OF oTreeView
   
         Next i

      ACTIVATE WINDOW oWnd

   ElseIf ValType( uValue )="O" 
   
      aData   := uValue:ClassSel()
     
      /*
      AEVAL(  aData , { | a, n| IIF( Left( a,1)="_" ,  ;
              AADD(aConverted, {a , hb_ValToExp( uValue:a )  } ) , ;
              NIL  )  } )
      */
      
      View( uValue:ClassSel() )

   Else
      // Se debe desarrollar una accion por tipo de dato pasado. Riztan
      MsgInfo( hb_ValToExp( uValue ) )
   EndIf

Return NIL

/** \brief Equivalente a DefError de T-Gtk para Tepuy.
 *  \par oError
 *  \par cCommand  Nombre de la instruccion en ejecucion
 *  \par lEVal     Indica si el error proviene de un bloque de codigo.
 */

#include "common.ch"
#include "error.ch"

FUNCTION TPDefError( oError, cCommand, lEVal )
   LOCAL cIconFile :=  oTpuy:cImages+"tpuy-icon-16.png"//oTpuy:cIconMain
   LOCAL cMessage
   LOCAL cDOSError

   LOCAL aOptions
   LOCAL nChoice

   LOCAL n
   LOCAL nArea
   Local lReturn := .F.

   Local cText  := "", oWnd, oScrool,hView, hBuffer, oBox, oBtn, oBoxH, expand, oFont, oExpand, oMemo
   Local cRText := ""
   Local cTextExpand := '<span foreground="orange" background="black" size="large"><b>'+MESSAGE_PULSE+' <span foreground="red"'+;
                        ' size="large" ><i>'+MESSAGE_DETAILS+'</i></span></b>!</span>'
   Local aStyle := { { "red" ,    BGCOLOR , STATE_NORMAL },;
                     { "yellow" , BGCOLOR , STATE_PRELIGHT },; 
                     { "white"  , FGCOLOR , STATE_NORMAL } }
   Local aStyleChild := { { "white", FGCOLOR , STATE_NORMAL },;
                          { "red",   FGCOLOR , STATE_PRELIGHT }}

   Default lEval to .F.

   // By default, division by zero results in zero
   IF oError:genCode == EG_ZERODIV
      RETURN 0
   ENDIF

   // Set NetErr() of there was a database open error
   IF oError:genCode == EG_OPEN .AND. ;
      oError:osCode == 32 .AND. ;
      oError:canDefault
      NetErr( .T. )
      RETURN .F.
   ENDIF


   // Set NetErr() if there was a lock error on dbAppend()
   IF oError:genCode == EG_APPENDLOCK .AND. ;
      oError:canDefault
      NetErr( .T. )
      RETURN .F.
   ENDIF

   cMessage := ErrorMessage( oError )

   IF ! Empty( oError:osCode )
      cDOSError := "(DOS Error " + LTrim( Str( oError:osCode ) ) + ")"
   ENDIF

   IF ! Empty( oError:osCode )
      cMessage += " " + cDOSError
   ENDIF

   IF ! Empty( oError:subsystem )
      cMessage += " " + oError:subsystem + "/" + Ltrim(Str(oError:subCode)) 
   END

   IF ! Empty(oError:description)
      cMessage += "  " + oError:description
   END

   IF ! Empty(oError:operation)
      cMessage += ": " + oError:operation
   END

   IF ! Empty(oError:filename)
      cMessage += ": " + oError:filename
   END

*   MsgStop( cMessage, "Error" )

   cText  += MSG_APPLICATION + CRLF
   cRText += "<b>"+MSG_APPLICATION+"</b>" + CRLF
   cText  += Replicate("=", Len(MSG_APPLICATION) ) + CRLF
   cRText += Replicate("=", Len(MSG_APPLICATION) ) + CRLF 
   cText  += "   "+MSG_PATH_NAME+" (script): " + HB_ArgV( 0 ) + HB_OsNewLine()
   cRText += "   "+MSG_PATH_NAME+" (script): <b>" + HB_ArgV( 0 ) + "</b>" + HB_OsNewLine()


   cText += "   "+MSG_ERROR_AT+": " 
   cText += DToC( Date() ) + ", " + Time() + CRLF + CRLF
   cRText += "   "+MSG_ERROR_AT+": " 
   cRText += "<b>" + DToC( Date() ) + ", " + Time() + "</b>" + CRLF + CRLF

   // Error object analysis
   cMessage   = ErrorMessage( oError ) + CRLF
   cText  += MSG_ERROR_DESCRIPTION + CRLF
   cText  += Replicate("=", Len(MSG_ERROR_DESCRIPTION) ) + CRLF 
   cText  += "   " + cMessage
   cRText += "<b>" + MSG_ERROR_DESCRIPTION + "</b>" + CRLF
   cRText += Replicate("=", Len(MSG_ERROR_DESCRIPTION) ) + CRLF 
   cRText += "<b>" + cMessage + "</b>"

   if ValType( oError:Args ) == "A"
      cText  += "   "+MSG_ARGS+": " + CRLF
      cRText += "   "+MSG_ARGS+": " + CRLF
      for n = 1 to Len( oError:Args )
         cText  += "     [" + Str( n, 4 ) + "] = " + ;
	                 ValType( oError:Args[ n ] ) + "   " + ;
	                 cValToChar( oError:Args[ n ] ) + CRLF
         cRText += "     [" + Str( n, 4 ) + "] = " + ;
	                 ValType( oError:Args[ n ] ) + "   " + ;
	                 cValToChar( oError:Args[ n ] ) + CRLF
      next
   endif

   cText += CRLF + MSG_STACK_CALLS + CRLF
   cText += Replicate( "=", Len( MSG_STACK_CALLS ) ) + CRLF

   cRText += CRLF + "<b>" + MSG_STACK_CALLS + "</b>" + CRLF
   cRText += Replicate( "=", Len( MSG_STACK_CALLS ) ) + CRLF

   n := 2

   g_print( CRLF + cText + CRLF )
   WHILE ! Empty( ProcName( n ) )
			cText  += MSG_CALLED_FROM + ProcFile( n ) + "->" + ProcName(n) + "(" + AllTrim( Str( ProcLine( n ) ) ) + ")" + CRLF
			cRText += MSG_CALLED_FROM + ProcFile( n ) + "->" +;
                                  iif(n=3,"<b>","") + ProcName(n) + "(" + AllTrim( Str( ProcLine( n ) ) ) + ")" + iif(n=3,"</b>","") + CRLF
			g_print( MSG_CALLED_FROM + ProcFile( n ) + "->" + ProcName(n) + "(" + AllTrim( Str( ProcLine( n ) ) ) + ")" + CRLF )
      n++
   ENDDO
   g_print( CRLF )

if lEval
      MsgStop( cRText, "SCRIPT ERROR " + "[" + HB_ArgV( 0 ) + "]" )
else

    DEFINE WINDOW oWnd TITLE "Errorsys Tepuy/T-Gtk MultiSystem"
           oWnd:lInitiate := .T. //Fuerzo a entrar en otro bucles de procesos.

           if FILE( cIconFile ) ; oWnd:SetIconFile( cIconFile ) ; endif

           DEFINE BOX oBox VERTICAL OF oWnd CONTAINER
                      cMessage := '<span foreground="blue"><i>'+;
                                  MSG_ERROR_DESCRIPTION + ":"+"</i>"+CRLF+;
                                  '<span foreground="black"><b>'+cMessage +'</b></span></span>'

                      DEFINE LABEL TEXT cMessage MARKUP OF oBox

                      DEFINE EXPANDER oExpand OPEN ;
                                      TEXT cTextExpand MARKUP ;
                                      EXPAND FILL OF oBox ;
                                      ACTION oWnd:Center( GTK_WIN_POS_CENTER_ALWAYS )

                      DEFINE SCROLLEDWINDOW oScrool ;
                             SIZE 400,400 OF oExpand CONTAINER

                      DEFINE MEMO oMemo VAR cText OF oScrool CONTAINER
                          oMemo:SetLeft( 10 ) 
                          oMemo:SetRight( 20 )
               
               DEFINE BOX oBoxH  OF oBox

               DEFINE BUTTON oBtn TEXT "_QUIT" MNEMONIC OF oBoxH EXPAND FILL ;
                            ACTION __Salir( oWnd ) 


               if oError:canRetry
                  DEFINE BUTTON oBtn TEXT "_Entry" MNEMONIC OF oBoxH EXPAND FILL;
                         ACTION ( lReturn := .T.,oWnd:End() )
               endif

               if oError:CanDefault
                  DEFINE BUTTON oBtn TEXT "_Default" MNEMONIC OF oBoxH EXPAND FILL ;
                         ACTION ( lReturn := .F., oWnd:End() )
               endif

               DEFINE FONT oFont NAME "Sans italic bold 13" 
               
               DEFINE BUTTON oBtn TEXT "_Save error.log" MNEMONIC;
                                 ACTION Memowrit( "error.log", cText ) ;
                                 FONT oFont ;
                                 STYLE aStyle ;
                                 STYLE_CHILD aStyleChild ;
                                 OF oBoxH

    ACTIVATE WINDOW oWnd CENTER MODAL
endif
//BREAK(oError)

RETURN lReturn

// SALIR DEL PROGRAMA Eliminando todo residuo memorial ;-)
// Salimos 'limpiamente' de la memoria del ordenador
/** \brief Realiza la Salida desde el programa de control de errores TPDefError()
 *
 */ 
Static Function __Salir( oWnd )
       Local nLen := Len( oWnd:aWindows ) - 1
       Local X

       if nLen > 0
          FOR X := nLen To 1
             oWnd:aWindows[x]:bEnd := NIL
             oWnd:aWindows[x]:End()
          NEXT
       endif
       oWnd:End()
       gtk_main_quit()
       QUIT

Return .F.



/** \brief Lee archivo tipo CSV y crea arreglo con los datos.
 *  \par cFile Ruta y Nombre del Archivo
 *  \par cDelimiter  Cadena con el delimitador
 *  \par lRemcomillar  Valor logico que indica si debe remover las comillas
 *  \ret Arreglo con el contenido del CSV.
 */ 
FUNCTION CSV2Array(cFile,cDelimiter,lRemComillas)
   Local aItems 
   Local aLines, cLine  
   Local cText, nItems
   Local myDelimiter := "|"

   Default cFile := ""
   Default cDelimiter := ","
   Default lRemComillas   := .T.

   IF Empty(cFile) .OR. !File(cFile)
      Return {}   
   ENDIF

   cText := MEMOREAD(cFile)

   cText := STRTRAN( cText, cDelimiter,myDelimiter )   //--  Coloco mi delimitador "|"

   IF lRemComillas
      cText := STRTRAN( cText,'"',"" )   // ---  Eliminamos las comillas
   ENDIF

   aLines := HB_aTokens( cText,CRLF )

   IF Empty(aLines)
      Return {}
   ENDIF

   nItems := NumToken( aLines[1], myDelimiter )
   
   aItems := {} 
   FOR EACH cLine IN aLines
      if !Empty( cLine )
         AADD( aItems, hb_aTokens( cLine, myDelimiter ) )
      endif
   NEXT

Return aItems



/** \brief Valida la cadena de un Correo Electronico (Sintaxis).
 *  \par cMail  cadena de texto (mail). 
 *              La variable es modificada internamente  por lo que si se pasa
 *              el puntero, se obtiene su modificación.
 *  \ret Valor logico si la sintaxis evaluada es correcta
 *
 */ 
Function ValidMail( cMail )

   Local cRes
   Local cIni
   Local cFin
   Local cTest
   Local lTest := .F.
   Local cToken :="@"
   Local nTokens
   
   cRes := LOWER(cMail)
   cRes := ALLTRIM(cRes)
   
   //---- Lo Primero.. caracteres aceptables
   IF LEN(cRes) != LEN( ANSITOHTML(cRes) )
       RETURN .F.
   ENDIF

   //---- Verificamos que exista solo un "@"
   IF NumToken(cRes,cToken) !=2
       RETURN .F.
   ENDIF

   //---  dividir en antes y despues de "@"
   cIni := Token( cRes, cToken, 1 )
   cFin := Token( cRes, cToken, 2 )

   //---  Estudiamos el primer token...
   IF LEN(cIni)<3
      Return .F.
   ENDIF


   //---  Estudiamos el segundo token...

   /* 
      Debe contener al menos un punto. Por lo que nuevamente contamos 
      los tokens  
    */
   cToken  := "."
   nTokens := NumToken(cFin,cToken)
   
   IF nTokens<2 .OR. nTokens>3
      Return .F.
   ENDIF

   //--- si tenemos 3 tokens, el ultimo debe tener longitud 2
   IF nTokens=3 .AND. Len(Token(cFin,cToken,3))>2
      Return .F.
   ENDIF

   //--- si tenemos 3 tokens, verificamos el contenido 2do
   IF nTokens=3 
      cTest := Token(cFin,cToken,2)
      IF Len(cTest)<=4 
         IF "com"$cTest ; lTest:=.T. ; ENDIF
         IF "net"$cTest ; lTest:=.T. ; ENDIF
         IF "edu"$cTest ; lTest:=.T. ; ENDIF
         IF "org"$cTest ; lTest:=.T. ; ENDIF
         IF "gov"$cTest ; lTest:=.T. ; ENDIF
         IF "gob"$cTest ; lTest:=.T. ; ENDIF
         IF "mil"$cTest ; lTest:=.T. ; ENDIF
         IF "info"$cTest ; lTest:=.T. ; ENDIF
         IF !lTest 
            Return .F.
         ENDIF
      ENDIF
   ENDIF
   
   cMail := cRes

Return .T.
      

/** \brief Convierte un valor de texto al tipo especificado.
 *  \par cVal     Cadena de texto a convertir. 
 *  \par cValTYpe Caracter que indica el tipo de dato a devolver.
 *  \ret El valor convertido a lo solicitado.
 *                
 */
Function Str2Val(cVal, cValType )

   Local xRes
   
   IF HB_ISNIL(cVal)
      cVal := 'NIL'
   ENDIF

   IF Empty(cValType)
      Return cVal
   ENDIF
   
   cValType := AllTrim(cValType)
   
   
   DO CASE
      CASE cValType="N"
         xRes := Val( cVal )
      CASE cValType="L"
         cVal := hb_ValToExp(cVal)
         xRes := IIF( ("T" IN upper(cVal)) .OR. ("TRUE" IN upper(cVal)), .T.,.F.)
      OTHER
         xRes = cVal
   ENDCASE

Return xRes


/** \brief Obtiene el menu a mostrar. 
 * En caso de existir una conexión NetIO, obtiene el menu desde el servidor. 
 * Si no hay conexión remota, lo obtiene de archivos .ini en la carpeta <i>menu</i>.
 * \return Hash de elementos para el menu.
 */
Function GetMenu(cMenuName)
   Local hMenu, cExt := ".ini"

   if Right( cMenuName, 4 ) != cExt 
      cMenuName += cExt
   endif

   if !oTpuy:lNetIO
      hMenu := hb_IniRead( oTpuy:cMenuDir + cMenuName )
   else
      hMenu := ~HGet( LoadMenu( cMenuName ) )
   endif
Return hMenu




/** \brief Funcion para extraer el nombre de un archivo cuando la 
 *  cadena contiene toda la ruta
 */
FUNCTION ExtName( cFileName )
   local nPos, cSep := "/"

   if oTpuy:cOS="WINDOWS" ; cSep := "\" ; endif

   nPos := RAT( cSep, cFileName )

   if nPos > 0
      cFileName := RIGHT( cFileName, LEN( cFileName ) - nPos )
   endif

RETURN cFileName


FUNCTION Check_Version( cRuta )
   local cHash
   local cOS := lower( OS() )
   local aFiles, cPath := GetEnv("TMP")
   //local cBat,cBatFile:="tl.bat"
   local uTpyVersion, cFilePath, aPath, cBinName, cDirSep

   if oTPuy:lNetIO 
#ifdef __PLATFORM__WINDOWS
      if "windows" $ cOS
         cOS := "windows"
         cDirSep := "\"
         default cRuta to CurDrive()+":"+cDirSep+CurDir()+cDirSep+"bin"

         //cBat := '@start /B tasklist | find "tpuy" > %TMP%\tl.log'
         //hb_MemoWrit( cPath+"\"+cBatFile, cBat ) 
         //wapi_shellexecute(,"open", cPath+"\"+cBatFile,,,0 )
         //cFile := MemoRead( cPath + "/" + "tl.log" )
         //cFile := LEFT( cFile, AT( " ", cFile )-1 )
         //cFilePath := cRuta + "/" +cFile
        
         cFilePath := hb_ProgName()
         aPath := hb_aTokens( cFilePath, cDirSep )
         cBinName := aPath[ len(aPath) ] 
#else
      if "linux" $ cOS
         cDirSep := "/"
         cOS := "ubuntu"  // ya se cambiara cuando se trabaje otra distribucion.
         default cRuta to cDirSep+CurDir()+cDirSep+"bin"

         //cFile := "tpuy_Ubuntu_16041_x86_64_hb32"
         //cFilePath := cRuta + "/" + cFile
         cFilePath := hb_ProgName()
         aPath := hb_aTokens( cFilePath, cDirSep )
         cBinName := aPath[ len(aPath) ] + "_bin" 
#endif

         if FILE( cFilePath )
            cHash := hb_MD5File( cFilePath )
            if !( cHash == net:tpycli_version( cOS ) )

               if MsgYesNo("¿Desea continuar con el proceso de actualización?",;
                           "Detectada diferencia en el binario TPuy")

                  MsgInfo("Iniciar Descarga. (puede tardar algunos minutos) ",;
                          "Actualización del componente binario.")
                  inkey(.2)
                  uTpyVersion :=  net:tpycli_get_version( cOS ) 

                  if !empty( uTpyVersion )

                     MsgInfo("Finalizado el proceso de descarga!" + hb_eol() + ;
                             "Se intentará sustituir el archivo ejecutable correspondiente.",;
                             "Descarga Completada")

                     if FILE( cFilePath+"__before" ) ; FERASE( cFilePath+"__before" ) ; endif
#ifdef __PLATFORM__WINDOWS
                     FRENAME( cFilePath, STRTRAN(cFilePath,".exe","") + "__before.exe" ) 
//                     hb_MemoWrit( STRTRAN( cFilePath,".exe","") + "__before.exe", MemoRead( cFilePath ) ) 
                     
#else
                     hb_Run( "mv "+cFilePath+" "+cFilePath+"__before" )
#endif

                     if hb_MemoWrit( cFilePath, uTpyVersion  )
//                     if hb_MemoWrit( (cFilePath + "__before"), MemoRead(cFilePath) )
//                     if FRENAME( cRuta + "/" + cFile, (cRuta + "/" + cFile + "__before") )
#ifdef __PLATFORM__LINUX
                        hb_Run( "chmod 755 "+cFilePath )
#endif
                        MsgAlert("Se cerrará el sistema...","Atención")
//                        Salida(.t.)
                        oTPuy:End()
                        gtk_main_quit()
                        QUIT
                     else
                        MsgAlert("No fue posible reescribir el binario." + hb_eol() +;
                                 "Posiblemente no hay permisos para realizar este tipo de ajuste.",;
                                 "Atención")
                        //return "revisar"

                        if hb_MemoWrit( cBinName, uTpyVersion )
                           MsgInfo( "Se ha guardado una copia del binario en: " + CurDir() +;
                                     cDirSep + cBinName )
                        endif
                     endif
                  elseif hb_IsNIL( uTpyVersion )
                     MsgAlert( "No se logró obtener la información de actualización."+hb_eol()+;
                               "Posiblemente deba comunicarse con su administrador del sistema. " )
                  endif
               else
                  MsgAlert("Posiblemente esté ejecutando una versión desactualizada. "+;
                           "Se recomienda actualizar lo antes posible.", "Atención")
                  return .f.
               endif
               return cHash

            endif
         else
MsgAlert( "No localiza el archivo " + cFilePath + " para verificar version." )
         endif
      endif
      
   endif
return nil


/** \brief Convierte un texto numerico formateado tipo 999.999,99 a
 *         numerico
 */
FUNCTION ToNum( cValue, nDec )
   local cPatron, cDec

   default nDec := oTPuy:nDecimals

   if cValue == NIL .or. empty(cValue) .or. ValType(cValue)!="C"
      return 0
   endif

   cDec := ALLTRIM(STR(nDec))

   if ( "," $ cValue ) .and. !( "." $ cValue ) 
      // esto hace que si tenemos mas decimales, 
      // sean tomados en cuenta.
      if oTPuy:cSepDec==","
         cValue := STRTRAN( cValue, ",", "." )
      endif
   endif

//   if ( "." $ cValue ) .and. !( "," $ cValue ) 
      // '.' como separador
      cPatron := "^-?[\,0-9]{1,9}(\.[0-9]{0,"+cDec+"})?$"
      if hb_RegExMatch( cPatron, cValue )
         return VAL( STRTRAN( cValue, ",", "" ) )
      endif
//   endif

   // Patron de coma decimal
//   cPatron := "^[\,0-9]{1,9}(\,[0-9]{0,"+cDec+"})?$"
   cPatron := "^-?(\d{1}\.)?(\d+\.?)+(,\d{0,"+cDec+"})?$"
   if hb_RegExMatch( cPatron, cValue )
      if oTpuy:cSepDec==","
         return VAL( STRTRAN( STRTRAN( cValue, ".", "" ), ",", "." ) )
      endif
   else
      if ( ( "," $ cValue ) .and. ( "." $ cValue ) ) .and. oTpuy:cSepDec==","
         cValue := STRTRAN(cValue, ".", "")
         cValue := STRTRAN(cValue, ",", ".")
      endif
   endif

RETURN VAL( cValue )


/** \brief Convierte un valor numerico a texto formateado 
 *         y sin espacios.
 */
FUNCTION ToStrF( nValue, cMask )
   default cMask := P_92
   if nValue = NIL .or. nValue=0 .or. VALTYPE(nValue)!="N"
      return ""
   endif
RETURN ALLTRIM( TRANSFORM( nValue, cMask ) )



/** \brief Convierte un valor dado en su equivalente de cadena tipo SQL segun el motor
 *         de base de datos indicado. Por defecto devuelve cadena compatible con MySql
 * 
 */
FUNCTION ToSql( uValue, nDbType )

   Local cResult := 'NULL'
   Local xValue 
   Local cType

   default nDBType to 0
   
   if nDBType < 0  .or.  nDBType > 1 
      nDBType := 0
   endif

   cType := VALTYPE( uValue )

   if cType = "C"

      if !Empty(uValue)
         if nDbType = 0 // MySql
            cResult := uValue
            if AT( "'", cResult ) > 0
               cResult := StrTran(uValue, "'", "\'")
            endif
            if AT( '"', cResult ) > 0
               cResult := StrTran(uValue, '"', '\"')
            endif
            if AT( "#", cResult ) > 0
               cResult := StrTran(uValue, '#', '\#')
            endif
            cResult := "'"+ cResult + "'"
         else
            // aun por revisar como escapar caracteres especiales en pgsql
            cResult := "'"+ StrTran(uValue, "'", ' ') + "'"
         endif
      endif
           
   elseif cType = "D" .and. ! Empty(uValue)
      if nDbType = 1 //Postgresql
         cResult := "'" + StrZero( MONTH( uValue ), 2 ) + '/'
         cResult +=       StrZero(   DAY( uValue ), 2 ) + '/'
         cResult +=       StrZero(  YEAR( uValue ), 4 ) + "'"
      else  // MySQL
         cResult := "'" + StrZero(  YEAR( uValue ), 4 ) + '-'
         cResult +=       StrZero( MONTH( uValue ), 2 ) + '-'
         cResult +=       StrZero(   DAY( uValue ), 2 ) + "'"
      endif

   elseif cType ="N"
      cResult := "'"+ALLTRIM(STR( uValue ))+"'"

   elseif cType == "L"
      if nDbType = 1 //Postgresql
         cResult := iif( uValue, "'t'", "'f'" )
      else
         cResult := iif( uValue, "1", "0" )
      endif

   elseif cType ="O" .and. uValue:ClassName()="TPYENTRY"
      cResult := ToSql( uValue:Get() )
   endif
        
return cResult   


/** \brief Recibe un arreglo con datos u objetos tpyentry y
 *         retorna una cadena compatible con SQL con el motor de base de datos indicado.
 *         Por defecto devuelve cadena compatible con MySql
 */
FUNCTION AToSql( aDatos, nDbType )
   local xValue, cSql := ""

   FOR EACH xValue IN aDatos
      if Empty( cSql )
         cSql += ToSql( xValue, nDbType )
      else
         cSql += ", " + ToSql( xValue, nDbType )
      endif
   NEXT
RETURN cSql



/** \brief Función para validar una entrada que será utilizada luego en
 *                la construcción de una consulta SQL. 
 *                El objetivo es evitar la inyección sql.
 *  cString = Cadena de texto a evaluar.
 *
 * \return .t. / .f.  Si la cadena es válida o no según sea el caso.
 */
FUNCTION sql_Sanitize( cString )

   LOCAL cRegex1 := "(;|\s)" 
   LOCAL cRegex2 := "(exec|execute|select|insert|update|delete|create|alter|drop|rename|truncate|backup|restore)\s"

   hb_DefaultValue( cString, "")

   if hb_RegExHas( cRegEx1, cString ) .or. ( hb_RegExHas( cRegex1, cString ) .and. ;
                                             hb_RegExHas( cRegex2, cString ) )
      return .f.
   else
      if hb_RegExHas( cRegex2, cString )
         return .f.
      endif
   endif

   return .t.



/** \brief Apertura un archivo tipo PDF
 *         
 *
FUNCTION tpy_PDFOpen( cFilePDF )
  local uRes
  if empty( cFilePDF ) .or. !FILE( cFilePDF )
     MsgAlert("Archivo PDF No localizado.", "Atención")
     return nil 
  endif
#ifdef __PLATFORM__WINDOWS
      uRes := wapi_ShellExecute(0, 'open', cFilePDF, , 0, 0 )
#else
      uRes := winexec( "evince " + " " + cFilePDF )
#endif  
RETURN uRes
*/


/** Descarga archivo desde url en la ubicación dada.
 */
#include "hbcurl.ch"
FUNCTION tpy_download( cUrl, cTo, cError )
   local nRes, pCurl
  
   pCurl = curl_easy_init()    // Initialize a CURL session.
   curl_easy_setopt(pCurl, HB_CURLOPT_DOWNLOAD )
   curl_easy_setopt(pCurl, HB_CURLOPT_URL, cURL)  // Pass URL as parameter.
   curl_easy_setopt(pCurl, HB_CURLOPT_DL_FILE_SETUP, cTo )

   nRes := curl_easy_perform( pCurl )
   If nRes != HB_CURLE_OK
      //MsgStop( curl_easy_strerror(nRes) )
      cError := curl_easy_strerror(nRes)
      curl_easy_cleanup( pCurl )
      RETURN nRes
   EndIf
  
   curl_easy_cleanup( pCurl )

RETURN nRes

//EOF
