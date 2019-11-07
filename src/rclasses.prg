/**
 *  Clases de gestion de objetos remotos (netIO)
 *
 */

/** rsession.xbs  
 *  Clase para gestionar la session remota y mensajes de TPuy-Server
 *
 */

#include "hbclass.ch"
#include "gclass.ch"


CLASS RSESSION
   DATA cHandle
   DATA oMsgWidget
   DATA lInfo   INIT .f.

   METHOD New( oUser, oMsgWidget )
   METHOD Get( cMessage ) 

   METHOD SetMsgWidget( oMsgWidget )

   ERROR HANDLER OnError( uValue, ... )  //INLINE ::Get( __GetMessage(), ... )

ENDCLASS



/** Crea el objeto local que gestiona una sesion remota de TPuy-Server
 */
METHOD NEW( oUser )  CLASS RSESSION
   local cHandle

   if hb_IsNIL( oUser )
      MsgStop( "No se ha proporcionado el controlador de la sesion." )
      return nil
   endif

   if !( hb_IsObject( oUser ) .and. oUser:IsDef("CHANDLE") )
      MsgStop("El valor proporcionado es incorrecto")
      return nil
   endif

   ::cHandle := oUser:cHandle
   cHandle := ::cHandle

RETURN Self



/** Envía un mensaje al servidor, analiza la respuesta y dependiendo
 *  del tipo de dato puede crear un objeto local para su iteraccion.
 *
 *  Si el mensaje recibido es un Hash tipo "query", genera localmente un 
 *  objeto de la clase TCursor.
 *
 *  Igualmente si el mensaje recibido es el identificador de un objeto
 *  remoto, genera una instancia de la clase RObject
 */
METHOD GET( cMessage, ... )  CLASS RSESSION
   local uResp, cHandle := ::cHandle

   //if lInfo; oTPuy:oStBar:Message("Solicitando información al servidor." ) ; endif
   if ::lInfo
      ::oMsgWidget:Message("Solicitando información..." )
   endif

   uResp := FromRemote( "__objMethod", cHandle, cMessage, ... )

   if hb_IsHash( uResp ) .and. hb_hHasKey( uResp, "ok" )
      Do Case
      Case !uResp["ok"]
         MsgAlert( uResp["message"] )
         uResp := nil

      Case uResp["ok"] .and. uResp["type"] = "boolean"
         uResp := uResp["content"]

      Case uResp["type"] = "query"
         uResp := RCursor():New( uResp ) 

      Case uResp["type"] = "object_id"
         uResp := RObject():New( uResp["content"]["id_token"] )

      Other
         MsgAlert( "Tipo de mensaje por implementar", procname())
      EndCase
   endif

   if ::lInfo ; ::oMsgWidget:EndMessage() ; endif

RETURN uResp



/**  
 */
METHOD SetMsgWidget( oMsgWidget )  CLASS RSESSION

   ::lInfo := .f.

   if !hb_IsObject( oMsgWidget )
      return .f.
   endif

/*
   if ! (oMsgWidget:IsDerivedFrom( "GLABEL" ) .or. ;
         oMsgWidget:IsDerivedFrom( "GENTRY" ) .or. ;
         oMsgWidget:IsDerivedFrom( "GSTATUSBAR" ) )
*/
   if ! oMsgWidget:IsDerivedFrom("TSTATUSBAR")
      return .f.
   endif
      
   ::oMsgWidget := oMsgWidget

   ::lInfo := .t.

RETURN .t.



/** Atrapamos el error y lo redirigimos al metodo get.
 *  De esta forma, se puede solicitar una columna como 
 *  si de un DATA se tratara.
 *
 */
METHOD OnError( ... )   CLASS RSESSION
RETURN ::Get( __GetMessage(), ... ) 




/** Clase para gestionar la manipulación de un objeto remoto.
 */
CLASS RObject FROM RSession
   DATA cHandle
   METHOD New( cRObj )
   METHOD Get( cMessage, ... )
ENDCLASS


METHOD New( cRObj ) CLASS RObject

   if hb_IsNIL( cRObj )
      MsgStop( "No se ha proporcionado identificador del objeto." )
      return nil
   endif

   ::cHandle := cRObj

RETURN Self


METHOD GET( cMessage, ... )  CLASS RObject
   local uResp, cHandle := ::cHandle

   if ::lInfo
      ::oMsgWidget:Message( "Solicitando información..." )
   endif

   uResp := FromRemote( "__objMethod", cHandle, cMessage, ... )

   if ::lInfo ; ::oMsgWidget:EndMessage() ; endif

   if hb_IsHash( uResp ) .and. hb_hHasKey( uResp, "ok" )
      Do Case
      Case !uResp["ok"]
         MsgAlert( uResp["message"] )
         uResp := nil
      
      Case uResp["ok"] .and. uResp["type"]="boolean"
         uResp := uResp["content"]

      Case uResp["type"] = "query"
         uResp := RCursor():New( uResp ) 

      Case uResp["type"] = "object_id"
         uResp := RObject():New( uResp["content"]["id_token"] )

      Other
         MsgAlert( "Tipo de mensaje por implementar", procname())
      EndCase
   endif

RETURN uResp



/** Clase para gestionar una estructura remota tipo "query"
 */
CLASS RCursor FROM TCURSOR
   DATA aStruct
   METHOD New( hMsg )

   METHOD Struct()  INLINE  ::aStruct
   
   ERROR HANDLER OnError( ... )
ENDCLASS


METHOD New( hMsg )  CLASS RCURSOR
   local aData, aColumns, aRow, uValue

   aData := hMsg["content"]["data"]
   FOR EACH aRow IN aData
      FOR EACH uValue IN aRow
         if VALTYPE( uValue ) = "C"
            aData[ aRow:__EnumIndex, uValue:__EnumIndex() ] := ALLTRIM( uValue )
         endif
      NEXT
   NEXT

   ::Super:New( aData, hMsg["content"]["columns"] )
   
   ::aStruct := hMsg["content"]["struct"]

RETURN Self



METHOD OnError( ... )
RETURN ::Get( ALLTRIM(__GetMessage()), ... )

//eof
