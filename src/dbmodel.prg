/*
 * $Id: dbserver.prg 2012-09-17 14:53 riztan $
 */

#include "hbclass.ch"
#include "common.ch"
//#include "dbstruct.ch"
#include "xhb.ch"
#include "tpy_netio.ch"
//#include "tdolphin.ch"
#include "gclass.ch"

#include "base_columns.ch"

#xtranslate _QUERY_:<!msg!>[<params,...>] =>  IIF( ::lRemote, FromRemote( "__object",::oQuery,#<msg>[,<params>] ), ::cQry )

memvar oTpuy

CLASS MODELQUERY FROM TPUBLIC

//   PROTECTED:
   DATA cColFilter   INIT ""
   DATA uValFilter
   DATA lEqual       INIT .t.
 
//   EXPORTED:
   DATA oGtkModel
   DATA oTreeView
   DATA oQuery
   DATA oDBQuery
   DATA aIter
   DATA aStruct
   DATA aTpyStruct
   DATA aTypes
   DATA aData
   DATA nTime
   DATA cQuery
   DATA lQuery       INIT .T.
   DATA nRecNo
   DATA nFields
   DATA lCursorTop

   DATA lRemote
   DATA lMute

   DATA pPath

   DATA aTables

//   METHOD New( oConn, cQry )
   METHOD NewFromRemote( cSchema, uQry, lRemote, lMute  )
//   METHOD New( rQry, lRemote )
//   METHOD Serialize( cMsg )   
//   METHOD HColumn( cCol )  INLINE  {"En desarrollo..."}
   METHOD Listore( oBox, oListBox )
   METHOD Append( oParent )  INLINE Tpy_ABM2():New( oParent, self )
/*
METHOD New( oParent, oModel, cTitle, oIcon, nRow, nWidth, nHeight,;
            cId, uGlade, cBox )  CLASS TPY_ABM2  
*/

   METHOD Clasf2Array(  cClassifier, cSchema, oConn )
   METHOD Refresh( lAppend )
   METHOD QryRefresh( )
   METHOD Set( hNewValues, hOldValues)
   METHOD Insert( hNewValues )
   METHOD Delete( hOldValues, lForce )
   METHOD Update( cColName, uNewValue )
   METHOD GoTop()  INLINE  gtk_tree_model_get_iter_first( ::oGtkModel:pWidget, @::aIter )  //gtk_tree_path_up( ::pPath )
   METHOD Next() INLINE gtk_tree_model_iter_next( ::oGtkModel:pWidget, @::aIter )
   METHOD GetPath()  INLINE ::pPath := gtk_tree_model_get_path( ::oGtkModel:pWidget, @::aIter )
   METHOD FreePath() INLINE gtk_tree_path_free( ::pPath )
//   METHOD GetIter()
   METHOD GetValue( uColumn, aIter )  /* puede recibir posicion o nombre de la columna */
   METHOD Value( uColumn, aIter ) INLINE ::GetValue( uColumn, aIter )
   METHOD GetColPos( cColName ) 
   METHOD GetPosCol( cColName )   INLINE ::GetColPos( cColName ) 
   METHOD Eval( bBlock )

   METHOD SetFilter(cColName, uValue, lEqual)  

   METHOD ObjFree()
   METHOD Destroy() INLINE ::ObjFree()

//   ERROR HANDLER OnError( cMsg, nError )

ENDCLASS

METHOD SETFILTER( cColName, uValue, lEqual )  CLASS MODELQUERY
   ::cColFilter := cColName
   ::uValFilter := uValue
   ::lEqual     := lEqual

   ::oGtkModel:Clear()
   ::Refresh(.t.)
RETURN


METHOD OBJFREE() CLASS MODELQUERY
   local oQry := ::oQuery
   if ::lRemote
      ~oServer:ObjFree( oQry )
   else
      oQry:=NIL
   endif
   ::Release()
   self := nil
RETURN NIL


METHOD UPDATE( cColName, uNewValue )
   local lRes, aColumn, oColumn,cTemp
   local hNewValues := Hash() , hOldValues := Hash()
   
   hNewValues[ cColName ] := uNewValue

   FOR EACH aColumn IN ::aTpyStruct
      
      if ::IsDef( aColumn[COL_NAME] )
         oColumn := ::Get(aColumn[COL_NAME])
         
         if ::oTreeView != NIL
            cTemp := AllTrim( CStr( ::oTreeView:GetAutoValue( aColumn:__EnumIndex() ) ) )
         else
            cTemp := ::GetValue( aColumn[COL_NAME] )
         endif
         hOldValues[ oColumn:Name ] := cTemp

      endif
   NEXT
   lRes := ::Set( hNewValues, hOldValues )

RETURN lRes


METHOD EVAL( bBlock ) CLASS ModelQuery

   if !hb_IsBlock( bBlock ) ; return .f. ; endif

   ::GoTop()
   While .t.
      Eval( bBlock, self )
      if !::Next() ; exit ; endif
   EndDo
RETURN .t.

/**
 *  OnError()
 */
/*
METHOD OnError( uValue ) CLASS ModelQuery

  Local cMsg   := UPPE(ALLTRIM(__GetMessage()))
  Local cMsg2  := Subs(cMsg,2)

  uValue := ::GetValue( cMsg ) 

RETURN uValue
*/

METHOD GetColPos( cColName )
   local nColPos
   nColPos := ASCAN( ::aStruct, {| col |  col[ 1 ] = cColName  } )
   if nColPos = 0 .AND. ::oTreeView != NIL
      nColPos := ::oTreeView:GetPosCol( cColName )
   endif
RETURN (nColPos)


METHOD GetValue( uColumn, aIter ) CLASS ModelQuery
   Local model
   Local uValue, nType, nColumn, lIter := .f.
   
   DEFAULT uColumn := 1

   nColumn := uColumn

   if ValType( uColumn )="C" ; nColumn := ::GetColPos( uColumn ) ; endif
   
   model := ::oGtkModel:pWidget

   if hb_IsNIL( aIter ) .AND. hb_IsObject( ::oTreeView )
      aIter := ARRAY(4)
      if !::oTreeView:IsGetSelected( aIter ) ; return NIL ; endif
      lIter := .t.
   endif
   
   if !lIter
      //if Empty( ::aIter ) ; ::GoTop() ; endif
      ::GetPath()
      lIter := gtk_tree_model_get_iter( model, ::aIter, ::pPath )
      if !lIter 
         ::FreePath()
         return NIL 
      endif
      aIter := ::aIter
   endif
   
   nType := gtk_tree_model_get_column_type( model, nColumn - COL_INIT )

//   IF( gtk_tree_model_get_iter( model, ::aIter, ::pPath ) )
   if lIter

      DO CASE
         CASE ( nType = G_TYPE_CHAR .OR. nType = G_TYPE_UCHAR .OR. nType = G_TYPE_STRING )
              hb_gtk_tree_model_get_string( model, aIter, nColumn - COL_INIT, @uValue ) 
         CASE ( nType = G_TYPE_INT .OR. nType = G_TYPE_UINT .OR. nType = G_TYPE_INT64 .OR.nType = G_TYPE_UINT64 )
              hb_gtk_tree_model_get_int( model, aIter,  nColumn - COL_INIT, @uValue ) 
         CASE ( nType = G_TYPE_BOOLEAN )
              hb_gtk_tree_model_get_boolean( model, aIter,  nColumn - COL_INIT, @uValue ) 
         CASE ( nType = G_TYPE_LONG .OR. nType = G_TYPE_ULONG )
              hb_gtk_tree_model_get_long( model, aIter, nColumn - COL_INIT, @uValue ) 
         CASE ( nType = G_TYPE_DOUBLE .OR. nType = G_TYPE_FLOAT )
              hb_gtk_tree_model_get_double( model, aIter, nColumn - COL_INIT, @uValue )
         CASE ( nType = G_TYPE_POINTER .OR. nType = GDK_TYPE_PIXBUF )
              hb_gtk_tree_model_get_pointer( model, aIter, nColumn - COL_INIT, @uValue ) 
      END CASE

   endif
   
   ::FreePath()

RETURN uValue


/*
 -- Aun no me convence si colocar este metodo... si se necesita se activa.
METHOD GETITER() CLASS ModelQuery
   local aIter := ARRAY(4)

   if Empty(::aIter) ; ::GoTop()   ; endif
   if ::pPath=NIL    ; ::GetPath() ; endif

   ::gtk_tree_model_get_iter( ::oGtkModel:pWidget, @aIter, ::pPath  )

RETURN NIL
*/

METHOD DELETE( hOldValues, lForce )  CLASS ModelQuery
   local lRes := .f.
   local oQry
   local uResult, cValtype, lTreeView
   Local aColumn, oColumn, cTemp
   Local aIter := ARRAY( 4 )

   Default lForce to .f.

   if hb_IsNil( hOldValues ) 

      if ::oTreeView:ClassName() == "GTREEVIEW"

         lTreeView := .t.

         if !::oTreeView:IsGetSelected(aIter) 
            MsgStop( "Por favor, seleccione un registro.", "No hay datos seleccionados" ) 
            return .f.
         endif

         hOldValues := Hash()

         FOR EACH aColumn IN ::aTpyStruct
      
            if ::IsDef( aColumn[COL_NAME] )
               oColumn := ::Get(aColumn[COL_NAME])
         
               cTemp := AllTrim( CStr( ::oTreeView:GetAutoValue( aColumn:__EnumIndex() ) ) )
               hOldValues[ oColumn:Name ] := cTemp

            endif
         NEXT
         
      endif
      
   endif

   //MsgInfo("Metodo Delete en ModelQuery", "dbmodel.prg")

   if !lForce .and. !Empty( hOldValues )
//? LEN(hOldValues), hb_valtoexp( hOldValues )
      
      if !MsgNoYes( "¿Realmente desea eliminar el registro seleccionado?",;
                    "Por favor Confirme." )
         return .f.
      endif
   endif

   if ::lRemote
      //MsgInfo("El Objeto Query es Remoto...  vamos a refrescar como llamar a un metodo del objeto..")
      oQry := ::oQuery
      uResult :=  ~~oQry:Delete( hOldValues )
oTpuy:tLastNetIO := hb_DateTime()
      cValtype := ValType( uResult )
      if cValType = "C"
         MsgAlert( uResult , "Comunicado" )
         return .f.
      elseif cValType = "L" 
         if uResult .and. lTreeView .and. ::oTreeView:IsGetSelected( aIter )
            ::oGtkModel:Remove( aIter )         
            ::oTreeView:SetFocus()
            //::oTreeView:GoTop()
         endif
         return uResult
      else
         MsgAlert( "No se reconoce la respuesta al intentar insertar los datos", "Comunicado" )
         return .f.   
      endif
      
   else
      MsgInfo("Objeto Query NO Remoto")
   endif

RETURN lRes



METHOD INSERT( hNewValues )  CLASS ModelQuery
   local lRes := .f.
   local oQry
   local uResult, cValtype
   local aIter := ARRAY( 4 ), aValues := ARRAY( Len( ::aTpyStruct ) )
   local aColumn,oColumn

   if hb_IsNil( hNewValues ) 
      return NIL
   endif

//   MsgInfo("Metodo Insert en ModelQuery", "dbmodel.prg")

   if ::lRemote
      //MsgInfo("El Objeto Query es Remoto...  vamos a refrescar como llamar a un metodo del objeto..")
      oQry := ::oQuery
      uResult :=  ~~oQry:Insert( hNewValues )
oTpuy:tLastNetIO := hb_DateTime()
      cValtype := ValType( uResult )
      if cValType = "C"
         MsgAlert( uResult , "Comunicado" )
         return .f.
      elseif cValType = "L" 
         if uResult
            FOR EACH aColumn IN ::aTpyStruct
               oColumn := ::Get( aColumn[COL_NAME] )
               if oColumn:Editable
                  aValues[ aColumn:__EnumIndex() ] := hNewValues[ oColumn:Name ]
               endif
            NEXT
            ::oGtkModel:Append( aValues )
            SET VALUES LIST_STORE ::oGtkModel ITER aIter VALUES aValues
/*
            FOR EACH aColumn IN ::aTpyStruct
               oColumn := ::Get( aColumn[COL_NAME] )
               aValues[ aColumn:__EnumIndex() ] := hNewValues[ oColumn:Name ]
            NEXT
            ::oGtkModel:Append( aValues )
*/
         endif
         return uResult
      else
         MsgAlert( "No se reconoce la respuesta al intentar insertar los datos", "Comunicado" )
         return .f.   
      endif
      
   else
      MsgInfo("Objeto Query NO Remoto")
   endif

RETURN lRes



METHOD SET( hNewValues, hOldValues )  CLASS ModelQuery
   local lRes := .f.
   local oQry
   local uResult, cValtype
   local aIter := ARRAY( 4 ), aColumn, oColumn
   local aValues := ARRAY( Len( ::aTpyStruct ) )

   if hb_IsNil( hNewValues ) .or. hb_IsNil( hOldValues )
      return NIL
   endif

   //MsgInfo("Metodo Set en ModelQuery", "dbmodel.prg")

   if ::lRemote
      //MsgInfo("El Objeto Query es Remoto...  vamos a refrescar como llamar a un metodo del objeto..")
      oQry := ::oQuery
      uResult :=  ~~oQry:Set( hNewValues, hOldValues )
oTpuy:tLastNetIO := hb_DateTime()
      cValtype := ValType( uResult )
      if cValType = "C" .AND. !Empty(uResult)
         MsgAlert( uResult , "Comunicado" )
         return .f.
      elseif cValType = "L"  .AND. uResult
         FOR EACH aColumn IN ::aTpyStruct
            oColumn := ::Get( aColumn[COL_NAME] )
            if oColumn:Editable .AND. HHasKey( hNewValues, oColumn:Name ) 
               aValues[ aColumn:__EnumIndex() ] := hNewValues[ oColumn:Name ]
            else
               aValues[ aColumn:__EnumIndex() ] := hOldValues[ oColumn:Name ]
            endif
         NEXT
         //::oGtkModel:Append( aValues )
         SET VALUES LIST_STORE ::oGtkModel ITER aIter VALUES aValues
         return uResult
      elseif cValType != "C" .AND. cValType != "L"
         MsgAlert( "No se reconoce la respuesta al intentar actualizar los datos", "Comunicado" )
         return .f.   
      endif
      
   else
      MsgInfo("Objeto Query NO Remoto")
   endif

RETURN lRes


/*
METHOD NEW(oConn, cQry, cConn)
   local oQry
   local oLin
   local nPos
   local oColumn

   //if ValType(cQry) ; oQry := ::Query( xQry, cConn ) ; endif
   oQry := oConn:Query( cQry, cConn )
//? "aqui voy"
//? ValType( oQry ), oQry:ClassName()

#define FLD_DESCRIPTION   oQry:aTpyStruct[ nPos, 4 ]

   if !hb_IsObject( oQry ) ; return nil ; endif

   FOR EACH oLin IN oQry:aStruct

      nPos := AScan( oQry:aTpyStruct, {|a| oLin[1]==a[4] } )

      if nPos > 0
         oColumn := DbColumn():New( oQry:aTpyStruct[ nPos ] )
      else
         oColumn := DbColumn():New( oQry:aStruct[ nPos ] )
      endif
      
      ::Add( oLin[1], oColumn )

   NEXT

RETURN self
*/
METHOD NEWFROMREMOTE( cSchema, uQry, lRemote, lMute )  CLASS MODELQUERY
   local oQry
   local aLin
   local nPos
   local oColumn
   local oMsgRun

   Default lRemote to .F.
   Default cSchema to "tpuy"
   Default lMute to .f.

   ::Super:New()


/*
  Debemos evaluar si la variable uQry es una consulta o si ya es un objeto remoto..
  no se puede determinar con valtype() porque ambos son "C"haracter
  Imagino que aplicando un filtro de expresion regular se puede verificar.

  * 2014-11-04 - si no tiene blanco es un identificador remoto.

*/

   ::lRemote := lRemote
   ::lCursorTop := .t.
   ::lMute   := lMute

   ::oQuery   := uQry
   //oQry       := uQry
   if ValType( uQry ) = "C"
      if ::lRemote
         if !::lMute ; oMsgRun := MsgRunStart("Generando Consulta...") ; endif

         if ( " " $ uQry )  //-- Si no hay espacio en blanco no es una consulta, es identificador de obj remoto.
            ::oQuery := ~oServer:ModelQuery( uQry, cSchema )
         else
            //::cQry := ~~uQry:cQuery
            ::cQry := "" // No hay acceso a la cadena del query remoto. 
         endif

/* inicializamos el conteo para verificar conexion netIO */
oTpuy:tLastNetIO := hb_DateTime()

//view({ procname(),": ", ::oQuery:uQry })

         //oQry := ::oQuery
         if !::lMute ; MsgRunStop( oMsgRun ) ; endif
      else
/* 
   instanciar acá el query local. Entonces debemos tener acceso a la conexion...  es decir,
   el equivalente a ~oServer en el caso de netio.. de hecho deberia ser oServer
 */
      endif
   endif

/*
   if !hb_IsObject(::oQuery) 
      MsgStop("No se ha creado el objeto tipo query.")
      return NIL 
   endif
*/
   oQry := ::oQuery

   if ::lRemote
      ::aTpyStruct := ~~oQry:GetTpyStruct()
      ::aStruct    := ~~oQry:GetStruct()
   else
      ::aTpyStruct := ::oQuery:aTpyStruct
      ::aStruct    := ::oQuery:aStruct
   endif

   ::aData    := {}

//View( _QUERY_:aData )


//View( ::aTpyStruct )
//View( ::aStruct )
   IF Empty(::aTpyStruct)
      MsgStop("Arreglo de estructura, vacio. ")
      Return NIL
   ENDIF

   if empty( ::cQuery ) ;  ::cQuery  := uQry ; endif  //-- esto es temporal, porque si uQry es un objeto entonces no es correcto.

   ::aTypes  := ARRAY( LEN( ::aStruct ) )
   
   FOR EACH aLin IN ::aStruct


      nPos := AScan( ::aTpyStruct, {|a| aLin[1] == a[COL_NAME] } )
      if nPos > 0
         oColumn := DbColumn():New( ::aTpyStruct[ nPos ], aLin )
      else
         oColumn := DbColumn():New( aLin )
      endif
      ::Add( aLin[1], oColumn )

      ::aTypes[ aLin:__EnumIndex() ] := oColumn:GtkNType  

   NEXT

   DEFINE LIST_STORE ::oGtkModel TYPES ::aTypes 


   ::Refresh( .t. )
//View( aTypes )

//View( self )
RETURN self



METHOD QRYREFRESH()  CLASS MODELQUERY
   Local oQry
   Local lAppend := .t.

   ::aData := {}

   if ::lRemote
      oQry := ::oQuery
      ~~oQry:Refresh()
   else
      ::oQuery:Refresh( .t. )
   endif

   //View(::oGtkModel)
   if IsObject( ::oTreeView )
      ::oTreeView:ClearModel() //::oGtkModel:Release()
      ::Refresh( lAppend )
   else
      ::oGtkModel:Clear()
View("deberia limbpiar")
   endif
//View( ~~oQry:aData )
RETURN .t.


METHOD REFRESH( lAppend )  CLASS MODELQUERY

   local aRow
   //local oColumn//, cCol, cValue
   local oMsgRun, oQry, nColPos := 0

   DEFAULT lAppend TO .F.

   ::aData := {}

//   ::aData := _QUERY_:aData
   if ::lRemote
      oQry := ::oQuery
//      ~~oQry:Refresh()
      ::aData := ~~oQry:GetData()
//View(::aData)
oTpuy:tLastNetIO := hb_DateTime()
   else
      ::aData := ::oQuery:aData
   endif
   ::nRecNo := Len( ::aData )

   ::aIter := ARRAY( ::nRecNo )

//View(::aData)
//View(::aStruct)
   if !Empty( ::cColFilter )
      nColPos := ASCAN(::aStruct, {|a| a[1]=::cColFilter } ) 
   endif

   if !::lMute ; oMsgRun := MsgRunStart("Actualizando Información...") ; endif
   FOR EACH aRow IN ::aData

      /* aqui, deberiamos ir buscando la informacion correspondiente a campos que son referencia en otra tabla */
      /* mejor..  esto ya nos lo debe proveer nuestro servidor de netio */
      /* 06/10/2012 - Ya lo provee el servidor... proceso en pruebas */
//View( { ::cColFilter, ::uValFilter, nColPos} ) 
      if nColPos != 0

//View( { ::cColfilter, ::uValFilter, ::lEqual, aRow[nColPos], (::uValFilter = aRow[nColPos] ), ;
//        (::uValFilter = aRow[nColPos]) = ::lEqual } ) 

         if ( ::uValFilter = aRow[nColPos] ) = ::lEqual
            
            __Registra( lAppend, ::oGtkModel, ::aIter, aRow )

         endif

      else

         __Registra( lAppend, ::oGtkModel, ::aIter, aRow )
         
      endif

   NEXT
   if !::lMute ; MsgRunStop( oMsgRun ) ; endif

RETURN .t.


STATIC PROCEDURE __REGISTRA( lAppend, oGtkModel, aIter, aRow )
   if lAppend 
      APPEND LIST_STORE oGtkModel ITER aIter
   endif

   SET VALUES LIST_STORE oGtkModel ITER aIter ;
       VALUES aRow
RETURN

/*
METHOD SERIALIZE(cMsg)
Return hb_valtoexp( ::Get( cMsg ) )
*/

METHOD LISTORE( oBox, oListBox ) CLASS MODELQUERY

   Local oScroll, oGtkCol, oCol, aCol

   if hb_IsNIL( oBox ) ; return NIL ; endif

   DEFINE SCROLLEDWINDOW oScroll OF oBox EXPAND FILL ;
          SHADOW GTK_SHADOW_ETCHED_IN
   
   oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )

   DEFINE TREEVIEW ::oTreeView MODEL ::oGtkModel OF oScroll CONTAINER
   ::oTreeView:SetRules( .t. )

   FOR EACH aCol IN ::aStruct

      oCol := ::Get( aCol[1] )
      //oCol := ::oQuery:( aCol[1] )
//View( aCol )

      DEFINE TREEVIEWCOLUMN oGtkCol                ;
             COLUMN aCol:__EnumIndex()             ;
             TITLE  oCol:description               ;
             TYPE   oCol:gtkType  SORT             ;
             OF ::oTreeView

       oGtkCol:SetResizable( .t. )

       if !hb_IsNIL( oListBox )
          ::oTreeView:bRow_Activated := oListBox:bEdit
       endif

//? oCol:ClassName(), oCol:Name, "  ",oCol:Navigable
       oGtkCol:SetVisible( oCol:Navigable )
       oGtkCol:Connect( "clicked" )
       oGtkCol:bAction := {|o| ::oTreeView:SetSearchColumn( o:GetSort() ) }

//       oCol:oGtkColumn := oGtkCol
//-- Registramos la columna como un data del objeto.
       __objAddData( self, oCol:Name )
#ifndef __XHARBOUR__
       __objSendMsg( self, "_"+oCol:Name, oGtkCol )
#else
       hb_execFromArray( @self, oCol:Name, {oGtkCol} )
#endif

   NEXT

   ::oTreeView:SetAutoSize()
   if ::lCursorTop
      ::oTreeView:SetFocus()
      ::oTreeView:GoTop()
   endif
   
RETURN NIL


/** Funcion que retorna arreglo correspondiente
 *  a valores del clasificador dado.
 */
METHOD Clasf2Array( cClassifier, cSchema, oConn )  CLASS MODELQUERY
   Local oQuery, cQuery
   Local aData
   
//   Default oConn   := TPY_CONN
   Default cSchema := "tpuy"  //oConn:Schema

/* TODO. Crear el metodo en la clase de conexion a la base de datos para no generar la consulta desde aca. RIGC*/

   cQuery := " SELECT base_classifier_data.clsdata_value, "
   cQuery += "base_classifier_data.clsdata_description, "
   cQuery += "base_classifier_data.clsdata_value_type "
   cQuery += " FROM "+cSchema+".base_classifier "
   cQuery += " JOIN "+cSchema+".base_classifier_data ON "
   cQuery += "base_classifier.class_id = base_classifier_data.clsdata_class_id "
   cQuery += " WHERE base_classifier.class_name='"+cClassifier+"' "

   
   if ::lRemote
      oQuery := ~oServer:Query( cQuery, cSchema )
      aData := ~~oQuery:aData

   else
      oQuery := oConn:Query( cQuery, cSchema )
      aData := oQuery:aData

   endif
   
   oQuery := NIL
   
RETURN aData



//eof
