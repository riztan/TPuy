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



/* Clase de Columna */
CLASS DBCOLUMN FROM TPUBLIC

//   DATA Type
   DATA lPassword   INIT .f.
//   DATA Len
//   DATA DbType
   DATA GtkType
   DATA GtkNType
   DATA oGtkColumn
   DATA oWidGet
   DATA oEventBox

/*
   DATA Id
   DATA Schema
   DATA Table
   DATA Name
   DATA Description
   DATA Editable  
   DATA Reference 
   DATA Ref_ScriptName 
   DATA Ref_Table 
   DATA Ref_Link
   DATA Ref_Descriptor
   DATA Picture 
   DATA Viewable 
   DATA Navigable 
   DATA Default 
   DATA Order 
   DATA Container
   DATA Valid
*/   
   METHOD NEW( aValues, aStruct )
/*
   METHOD SET( cName, xValue )
   METHOD ISDEF( cName )  INLINE __objHasData( self, cName )
   METHOD SENDMSG()

   ERROR HANDLER OnError( cMsg, nError )
*/
ENDCLASS


METHOD NEW( aValues, aStruct ) CLASS DBCOLUMN

   local cDbType

   ::Super:New()

   Default aValues To {}

   if Len( aStruct ) < 5
      Do Case
      Case aStruct[2]="C"
         cDbType := "VARCHAR("+STR(aStruct[3])+")"
      Case aStruct[2]="D"
         cDbType := "DATE"
      Case aStruct[2]="L"
         cDbType := "BOOLEAN"
      Case aStruct[2]="N" .and. aStruct[4]=0
         cDbType := "INTEGER("+STR(aStruct[4])+")"
      Case aStruct[2]="N" .and. aStruct[4]>0
         cDbType := "DECIMAL("+STR(aStruct[4])+")"
      EndCase
   else
      cDbType := aStruct[7]
   endif

   If Len(aValues)>10

      //::Type                 := aStruct[2]
      ::Add("type", aStruct[2])
      //::Len                  := aStruct[3]
      ::Add("len", aStruct[3])
      //::DbType               := aStruct[7]
      ::Add("dbtype", cDbType)
      //::Schema               := aValues[COL_SCHEMA        ]
      ::Add("schema", aValues[COL_SCHEMA])
      //::Table                := aValues[COL_TABLE         ]
      ::Add("table", aValues[COL_TABLE])
      //::Id                   := aValues[COL_ID            ]
      ::Add("id", aValues[COL_ID])
      //::Name                 := aValues[COL_NAME          ]
      ::Add("name", aValues[COL_NAME])
      //::Description          := aValues[COL_DESCRIPTION   ]
      ::Add("description", aValues[COL_DESCRIPTION])
      //::Editable             := aValues[COL_EDITABLE      ]
      ::Add("editable", aValues[COL_EDITABLE])
      //::Reference            := aValues[COL_REFERENCE     ]
      ::Add("reference", aValues[COL_REFERENCE])
      //::Ref_ScriptName       := aValues[COL_REF_SCRIPTNAME]
      ::Add("ref_scriptname", aValues[COL_REF_SCRIPTNAME])
      //::Ref_Table            := aValues[COL_REF_TABLE     ]
      ::Add("ref_table", aValues[COL_REF_TABLE])
      //::Ref_Link             := aValues[COL_REF_LINK      ]
      ::Add("ref_link", aValues[COL_REF_LINK])
      //::Ref_Descriptor       := aValues[COL_REF_DESCRIPTOR]
      ::Add("ref_descriptor", aValues[COL_REF_DESCRIPTOR])
      //::Picture              := aValues[COL_PICTURE       ]
      ::Add("picture", aValues[COL_PICTURE])
      //::Viewable             := aValues[COL_VIEWABLE      ]
      ::Add("viewable", aValues[COL_VIEWABLE])
      //::Navigable            := aValues[COL_NAVIGABLE     ]
      ::Add("navigable", aValues[COL_NAVIGABLE])
      //::Default              := aValues[COL_DEFAULT       ]
      ::Add("default", aValues[COL_DEFAULT])
      //::Order                := aValues[COL_ORDER         ] 
      ::Add("order", aValues[COL_ORDER])
      //::Container            := iif( hb_IsNIL( aValues[COL_CONTAINER] ), "", aValues[COL_CONTAINER] )
      ::Add("container", iif( hb_IsNIL( aValues[COL_CONTAINER] ), "", aValues[COL_CONTAINER]) )
      //::Valid                := aValues[COL_VALID] //iif( hb_IsNIL( aValues[COL_VALID] ), .t., aValues[COL_CONAINER] ) 
      ::Add("valid", aValues[COL_VALID])

   Else

      //::Type                 := aStruct[2]
      ::Add("type", aStruct[2])
      //::Len                  := aStruct[3]
      ::Add("len", aStruct[3])
      //::DbType               := aStruct[7]
      ::Add("dbtype", cDbType)
      //::GtkType              := IIF( ::Type == "L", "active", "text" )
      ::Add("gtktype", iif( ::hVars[ "type" ] == "L", "active", "text" ))
      //::Schema               := ""
      ::Add("schema", "")
      //::Table                := ""
      ::Add("table", "")
      //::Name                 := aValues[COL_NAME]
      ::Add("name", aValues[COL_NAME])
      //::Description          := AllTrim( aValues[1] ) + "*"
      ::Add("description", AllTrim( aValues[1] ) + "*" )
      //::Editable             := .t.
      ::Add("editable" , .t.)
      //::Reference            := .f.
      ::Add("reference", .f.)
      //::Ref_ScriptName      := ""
      ::Add("ref_scriptname", "")
      //::Ref_Table           := ""
      ::Add("ref_table", "")
      //::Ref_Field_Link       := ""
      ::Add("field_link", "")
      //::Ref_Field_Descriptor := ""
      ::Add("ref_descriptor", "")
      //::Picture              := ""
      ::Add("picture", "")
      //::Viewable             := .t.
      ::Add("viewable", .t.)
      //::Navigable            := .t.
      ::Add("navigable", .t.)
      //::Default              := ""
      ::Add("default", "")
      //::Order                := 0
      ::Add("order", 0)
      //::Container            := ""
      ::Add("container", "")

   EndIf

   ::lPassword            := .f.
   ::GtkType     := IIF( ::Type == "L", "active", "text" )
   ::oGtkColumn  := NIL

   /* definimos la columna en el modelo de Gtk+ */
   if (::hVars["Type"] == "L")
      ::GtkNType := G_TYPE_BOOLEAN  
/*
   elseif ( _QUERY:("type") = "N" ) .and. ( _QUERY_:("dbtype") = "integer" )
      ::GtkNType := G_TYPE_UINT 
   elseif ( _QUERY_:("type") = "N" ) .and. !( _QUERY_:("dbtype") = "integer" )
      ::GtkNType := G_TYPE_DOUBLE 
*/
   else 
      ::GtkNType := G_TYPE_STRING 
   endif

Return self




/*

METHOD Set( cName, xValue ) CLASS DBCOLUMN
   local uRet
   
   if __objHasData( Self, cName)

      if xValue == nil
         uRet = __ObjSendMsg( Self, cName )
      else
         __objSendMsg( Self, "___"+cName, __objSendMsg(Self,cName) )
         uRet = __ObjSendMsg( Self, "_"+cName, xValue )
      endif

   endif
return nil


METHOD SendMsg( cMsg, ...  ) CLASS DBCOLUMN
   if "(" $ cMsg
      cMsg = StrTran( cMsg, "()", "" )
   endif
return __ObjSendMsg( Self, cMsg, ... )

METHOD ONERROR( uParam1 ) CLASS DBCOLUMN
   local cCol    := __GetMessage()

   if Left( cCol, 1 ) == "_"
      cCol = Right( cCol, Len( cCol ) - 1 )
   endif
   
   if !::IsDef(cCol)
      ::Add( cCol )
   endif
   
RETURN ::Set(cCol,uParam1)

*/


//eof
