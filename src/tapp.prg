/*
 *  TApp().
 *
 *  Proyecto TPuy
 */


#include "gclass.ch"
#include "hbclass.ch"
#include "proandsys_lang_es_ve.ch"
#include "tepuy.ch"

memvar oTPuy

/* Se debe construir clase para edicion de scripts, ya que de otra forma es 
 * complicado manejar cosas como por ejemplo... el nuevo nombre del archivo
 * al hacer un guardar como.
 */

CLASS TApp FROM TObject

/*
   DATA cAutor 
   DATA cMail
   DATA cSistema
   DATA cBuild
   DATA cVer
*/
   DATA lNetIO  INIT .f.

   DATA cAppName      
   DATA cSystem_Name 
   DATA cIconMain   

   METHOD SetAppName(cName)
   METHOD About()
   METHOD RunXBS( cFile, ... )
   METHOD RRunXBS( cScript, ... )
   METHOD RunText( cText, ... )  
   METHOD OpenXBS( cFile, p1,p2,p3,p4,p5,p6,p7,p8,p9,p10 )  
   METHOD SaveScript( cFile )  
   METHOD SaveScriptAs( cFile )  
   METHOD Exit( lForce )

ENDCLASS


METHOD SetAppName(cNewName,cLargeName) CLASS TApp
  local lResp := .f.
  local cIcoName
 
  default cNewName := TPUY_NAME
  default cLargeName := ::cSystem_Name

  ::cAppName     := cNewName 
  ::cSystem_Name := cLargeName
  ::cIconMain    := ""

  cNewName := ALLTRIM(cNewName)

#ifdef HB_OS_LINUX
   cIcoName := lower( ::cImages+cNewName ) + "-icon"
   ::cOS          := "LINUX"
   if File( cIcoName+".png") 
      ::cIconMain  += lower(cNewName)+"-icon.png"
   endif
#else
   ::cOS          := "WINDOWS"
   if File( ::cImages+cNewName+".ico")
      ::cIconMain  += cNewName+".ico"
   endif
#endif

RETURN lResp



/** About()   
 *  
 */
METHOD About() CLASS TApp
   Local oAbout

   SET RESOURCES ::cResource FROM FILE ::cRsrcMain 
   DEFINE ABOUT oAbout ID "acercade" RESOURCE ::cResource

RETURN NIL



/** RRunXBS() (Remote RunXBS)
 *
 */
#include "tpy_netio.ch"
METHOD RRunXBS( cScript,lMute,cSchema, ... ) CLASS TApp
   local uResult 
   local cQry, rQry
   local cValcode, cScriptFile, lRun := .f.
   local oMsgRun

   DEFAULT lMute := .f., cSchema := "tpuy"

   if !oTpuy:RunXBS("netio_check") ; return .f.; endif

   if empty(oTpuy:oUser) ; return .f. ; endif
   
   cQry := "select xbs_name,xbs_md5 from " + cSchema + ".base_scripts where "
   cQry += "xbs_name=" + DataToSql(cScript)

   rQry := ~oServer:Query(cQry,cSchema)
   cValcode := ~~rQry:xbs_md5()
   cScriptFile := ::cXBScript + cScript + ".xbs"

   if !FILE( cScriptFile ) .or. ( hb_md5file( cScriptFile ) != cValCode )
      if !lMute ; oMsgRun := MsgRunStart( "Actualizando Script ["+cScript+"]."  ) ; endif
      cQry := "select xbs_source from "+cSchema+".base_scripts where "
      cQry += "xbs_name=" + DataToSql( cScript )
      rQry := ~oServer:Query( cQry, cSchema )
      lRun := hb_MemoWrit( cScriptFile, ~~rQry:xbs_source() ) 
      if !lMute ; MsgRunStop( oMsgRun ) ; endif
   else
      lRun := .t.
   endif

   if lRun
      uResult := ::RunXBS(cScript)      
   endif

Return uResult



/** RunXBS()
 *
 */
METHOD RunXBS( cFile, ... ) CLASS TApp
   Local result, oError
   Local oInterpreter, oFile, cScript := cFile
   Local cFilePPO, cFileXBS
   Local cSchema, lCONN := .F.
   Local oScript, cScriptFile, oMsgRun
   Local aPath,cPath,nPath, cAux
/*
   IF !Empty(oTpuy:aConnection)   
      IF HB_ISOBJECT(TPY_CONN)
         lCONN := .T.
         cSchema := TPY_CONN:Schema
      ENDIF
   ENDIF
*/
   DEFAULT cFile := 'test'

   cPath := ::Get("cXBScripts")

   if ( "/" $ cFile )
      aPath := hb_aTokens( cFile, "/" )
      nPath := LEN(aPath)
      cFile := aPath[nPath]
      FOR EACH cAux IN aPath
         if cAux:__EnumIndex() < nPath
            cPath += cAux+"/"
         endif
      NEXT
   endif

   cScriptFile := cPath+cFile

   IF !(".xbs" $ cScriptFile)
      //cScriptFile := STRTRAN( cScriptFile, ".xbs", "" )
      cScriptFile := ALLTRIM( cScriptFile ) + ".xbs"
   ELSE
      MsgStop( "Archivo No Válido" )
      Return .F.
   ENDIF

   if !File( cScriptFile )
      oMsgRun := MsgRunStart( "Actualizando Script ["+cFile+"]."  )
         if File( cScriptFile )
            Result := oTpuy:RunXBS("xbs_update", cScriptFile )
         endif
      MsgRunStop( oMsgRun )
      if !FILE( cScriptFile ) 
         MsgAlert("No ha sido posible localizar el script '<b>"+cFile+"</b>'.","Atención" MARKUP )
      endif
      return Result 
   endif

#ifdef __HARBOUR__
   if !::oScript:Isdef(cScriptFile)
      oScript := TScript():New( cScriptFile,,cPath,,,.f., ... ) 
   else
//? "retomando ",cFile
      oScript := ::oScript:Get(cScriptFile)
// -- Esto debe ser temporal (RIGC) debe verificar que la modificación está autorizada.
      if hb_md5(memoread(cScriptFile))!=(oScript:cMd5)
         MsgAlert( "El Script [<b>"+cFile+"</b>]. Ha cambiado... debe actualizar" MARKUP )
      endif
   endif
/*
   oScript:cDirective := "#xtranslate ::<!func!>([<params,...>])  => ; "
   oScript:cDirective += "   eval( hb_hrbGetFunSym( oTpuy:oScript:_SCRIPTNAME_:HRBHANDLE, #<func>[,<params>] ) ) "

   oScript:cDirective := StrTran( oScript:cDirective, "_SCRIPTNAME_", cFile )
*/
   if oScript:Refresh()
      if !::oScript:IsDef(cScriptFile)
         ::oScript:Add(cScriptFile,oScript)
      endif
//      TRY
         ::oScript:uResult := oScript:Run(cFile,...)
//      CATCH oError
//Eval( ErrorBlock(), oError )
//         If !MsgNoYes("Se ha presentado un problema al intentar ejecutar cFile, ¿Desea continuar? ","Atención")
//            oTpuy:Exit(.f.)
//         EndIf
//         Return NIL
//      END
      if oScript:lError 
         MsgStop( oScript:cError, "Funcion no encontrada" ) 
         return nil
      endif
      
   else
      if file("comp.log")
         MsgStop( "No se puede ejecutar el script <b>"+cFile+"</b>"+;
                  CRLF+MemoRead("comp.log"),;
                  'Script "'+cFile+'"')
         Salida(.t.) 
      endif
   endif

   result := ::oScript:uResult
   
#endif
/*
   If lCONN .AND. cSchema!=TPY_CONN:Schema
      TPY_CONN:SetSchema(cSchema)
   EndIf
*/
Return result


/** OpenXBS()
 *
 */
METHOD OpenXBS( cFile, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10 ) CLASS TApp

   Local oWnd, oBox, oScroll, oSourceView, cText:=""
   Local cResource
   Local oBtn_Ejecutar, oBtn_Guardar, oBtn_Guardar_Como, oBtn_Prefe, oBtn_Salir

   cText := MemoRead(cFile)
// MsgInfo( cText)

   If File( cFile ) .AND. !Empty( cText )
      SET RESOURCES cResource FROM FILE oTpuy:cResources+"xbscript.glade"

      DEFINE WINDOW oWnd TITLE cFile+" - "+oTpuy:cSystem_Name ;
             ID "window1" RESOURCE cResource  SIZE 800,500
          
             DEFINE BUTTON oBtn_Ejecutar ID "toolbutton_ejecutar" RESOURCE cResource;
                    ACTION ::RunText( oSourceView:GetText() )
          
             DEFINE BUTTON oBtn_Ejecutar ID "toolbutton_guardar" RESOURCE cResource; 
                    ACTION ::SaveScript( cFile, oSourceView:GetText() )
          
             DEFINE BUTTON oBtn_Ejecutar ID "toolbutton_guardar_como" RESOURCE cResource; 
                    ACTION (::SaveScriptAs( oSourceView:GetText() , oWnd) , View(oWnd))
//                    ACTION MsgInfo( "En desarrollo..." )
          
             DEFINE BUTTON oBtn_Ejecutar ID "toolbutton_preferencias" RESOURCE cResource; 
                    ACTION MsgInfo( "En desarollo...", oTpuy:cSystem_Name )
          
             DEFINE BUTTON oBtn_Ejecutar ID "toolbutton_salir" RESOURCE cResource; 
                    ACTION oWnd:End() 
          
             DEFINE BOX oBox OF oWnd VERTICAL
          
             DEFINE SCROLLEDWINDOW oScroll OF oBox CONTAINER ;
                    ID "scrolledwindow1" RESOURCE cResource
          
             DEFINE SOURCEVIEW oSourceView VAR cText OF oScroll CONTAINER;
                    MIME "text/x-prg"
          
      ACTIVATE WINDOW oWnd CENTER ;
         VALID MsgNoYes(MSG_EXIT_WANT, MSG_TITLE_PLEASE_CONFIRM ) 

   EndIf

Return NIL


/** RunText()
 *
 */
METHOD RunText( cText, ... ) CLASS TApp

   Local result:=''
   Local oInterpreter, cScript := "TEMP"

   DEFAULT cText := ''

#ifdef __HARBOUR__
//   MsgRun( MESSAGE_PROCESSING , {|| result := RunXBS( cText, ... ) } )
   result := RunXBS( cText, ... )
#else
   oInterpreter := TInterpreter():New(cScript)
   
   MsgRun( MESSAGE_PROCESSING , {||oInterpreter:SetScript( cText, 1 , cScript )} )
  
   oInterpreter:Run()
#endif

Return result


/** SaveScript()
 *
 *
 */
METHOD SaveScript( cFile, cText, lRefresh , oWnd ) CLASS TApp

   Local oInterpreter, cFilePPO
   Local oFile
   
   Default cText := '' , lRefresh := .F., oWnd := NIL
  
//   --- Posibilidad de incluir la extension de forma automática.. en revision.
//   IIF( !( "." $ cFile ) , cFile := Alltrim(cFile)+".xbs" , NIL )

   If File(cFile)
      If !( MsgNoYes( cFile , MSG_QT_REWRITE_FILE ) )
         Return .F.
      EndIf
   EndIf
   
   If RIGHT( lower(cFile) , 4 ) = '.xbs'

#ifdef __HARBOUR__
      
      oFile := gTextFile():New( cFile, "W" )
      
      oFile:WriteLn( cText )

      oFile:Close()

#else 
      cFilePPO := Left( cFile , LEN(cFile) - 4 ) + ".ppo"
   
      If File( cFilePPO )
      
         If FErase( cFilePPO ) <> 0
            MsgStop( MSG_FILE_NO_DELETE , MSG_TITLE_ERROR )
            Return .F.
         EndIf

      EndIf
      
      oInterpreter := TInterpreter():New(cFile)

      MsgRun( MESSAGE_PROCESSING , {||oInterpreter:SetScript( cText, 1 , cFile )} )

      oInterpreter:lExec:=.F.
      oInterpreter:Run()
      
      oFile := gTextFile():New( cFile, "W" )
      
      oFile:WriteLn( cText )

      oFile:Close()
      
      cText := ''
      
      AEVAL( oInterpreter:acPPed , {|a|                                  ;
                                     IIf( a <> NIL .AND. Left(a,1)<>"#", ;
                                         cText += a + CRLF , NIL )       ;
                                   } )
                                   
      //Escribiendo el pre-procesado
      
      oFile := gTextFile():New( cFilePPO, "W" )
      
      oFile:WriteLn( cText )
      
      oFile:Close()
      
#endif     
      If lRefresh
         //MsgInfo("Refrescando Información.")
         If HB_IsObject( oWnd ) 
            oWnd:SetTitle( cFile+" - "+oTpuy:cSystem_Name )
         EndIf
//         View(oWnd)
      EndIf
   Else
    
      MsgStop( MSG_FILE_NO_ADEQUATE , MSG_FILE_NO_SAVE)

   EndIf

Return cFile


/** SaveScriptAs()
 *
 *
 */
METHOD SaveScriptAs( cText , oWnd )  CLASS TApp

//    FileChooser(GTK_FILE_CHOOSER_ACTION_SAVE)
   Local oFileChooser, cFile, cDialog
   
//   Default nMode := GTK_FILE_CHOOSER_ACTION_OPEN

   SET RESOURCES oTpuy:cResource FROM FILE oTpuy:cRsrcMain 

//   MsgInfo( CStr(OSDRIVE() + "/" +CurDir()+"/xbscripts/") )

//   If nMode = GTK_FILE_CHOOSER_ACTION_OPEN
//      cDialog := "filechooserdialog0"
//   Else
      cDialog := "filechooserdialog1"
//   EndIf
      DEFINE FILECHOOSERBUTTON oFileChooser ID cDialog ;
          RESOURCE oTpuy:cResource;
          PATH_INIT OSDRIVE() + "/" +CurDir()+"/xbscripts/*.xbs"
          
//          oFileChooser:SetIconName("gtk_preferences")

          DEFINE BUTTON ID "button_guardar" RESOURCE oTpuy:cResource  ;
                   ACTION ( cFile := ( oFileChooser:GetFileName() ) ,  ;
                            oFileChooser:End() ,                       ;
                            ::SaveScript(cFile, cText , .T. , oWnd ) )

          DEFINE BUTTON ID "button_cancelar1" RESOURCE oTpuy:cResource;
                 ACTION oFileChooser:End()

    SysRefresh()
   
RETURN NIL


METHOD Exit( lForce ) CLASS TApp

   Default lForce := .F.

   if !hb_IsObject(oTpuy) ; return .t. ; endif
   
   if !lForce
      If !MsgNoYes("Realmente desea Salir de <b>"+;
                   oTpuy:cSystem_Name+"</b>",oTpuy:cSystem_Name)
         return .F.
      endif
   endif

   if ::lNetio
      TRY
         //PQClose(oTpuy:conn)
         /* Acá debe liberar del servidor todos los objetos del usuario...
            igualmente al iniciar (netio_check) debe inicializar todo lo 
            que posiblemente ha dejado abierto.. 
          */
         //~oServer:ObjFree( "oServer" ) --> no permitir matar el objeto oServer.
         ~oServer:Logout()
         NETIO_DISCONNECT( NETSERVER, NETPORT )
      CATCH
         MsgStop("Problema al intentar salir...")
      END
   end

//?? oTpuy:ClassName()
   if oTpuy:IsDef( "oUser" )
      oTpuy:oUser:End()
   endif
   oTpuy := NIL
   gtk_main_quit()
   Quit
   Return .F.

Return .T.


//eof
