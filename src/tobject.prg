/** TObject
 *
*/
/**\file tobject.prg
 * \class TObject. Clase TObject
 *
 *  Clase para manipulación de datos al estilo de TPublic.
 *  
 */

#include "gclass.ch"
#include "hbclass.ch"
#include "proandsys.ch"

// GLOBAL EXTERNAL oTpuy
memvar oTpuy


CLASS TObject

   VISIBLE:

   DATA  lAutoAdd    AS LOGICAL	 INIT .T.		
   DATA  lSensitive  AS LOGICAL	 INIT .F.		

   METHOD New( lAutoAdd, lSensitive )          /**New(). */
   METHOD End()            INLINE ::Release()  /**End(). */ 

   METHOD Add( cName, xValue )                 /**Add(). */
   METHOD Del( cName )             
   METHOD Get( cName ) 
   METHOD Set( cName, xValue )

   METHOD AddMethod( cMethod )
   METHOD DelMethod( cMethod )

   METHOD IsDef( cName )   INLINE __objHasData( Self, cName )

   METHOD SendMsg()

   METHOD GetArray()       INLINE __objGetValueList( self ) 

   METHOD Release()        INLINE Self := NIL

   ERROR HANDLER OnError( cMsg, nError )

ENDCLASS


//------------------------------------------------//
METHOD New( lAutomatic ) CLASS TObject
   DEFAULT lAutomatic:=.T.

   ::lAutoAdd  :=lAutomatic
RETURN Self


//------------------------------------------------//
METHOD Add( cName, xValue ) CLASS TObject

   if !::lAutoAdd ; return .f. ; endif

   if !::IsDef(cName)
      __objAddData( Self, cName )

      if !HB_ISNIL(xValue)
          return ::Set(cName, xValue)
      endif 

   endif

RETURN .F.


//------------------------------------------------//
METHOD Del( cName ) CLASS TObject
   if !::IsDef(cName)
      __objDelMethod( Self, cName )
      return .t.
   endif
Return .f.


//------------------------------------------------//
METHOD Get( cName ) CLASS TObject
   //local aData, nPos
   if ::IsDef(cName)
      return ::SendMsg( cName )
   endif
/*
   if __objHasData( Self, cName )
      aData := __objGetValueList(Self)
      nPos  := ASCAN(aData,{|a| a[HB_OO_DATA_SYMBOL]=UPPER(cName) }) 
      return aData[nPos,HB_OO_DATA_VALUE]
   endif
*/
Return nil


//------------------------------------------------//
METHOD Set( cName, xValue ) CLASS TObject
   local uRet
   
   if __objHasData( Self, cName)

   #ifndef __XHARBOUR__
      if xValue == nil
         uRet = __ObjSendMsg( Self, cName )
      else
         uRet = __ObjSendMsg( Self, "_"+cName, xValue )
      endif
   #else   
      if xValue == nil
         uRet = hb_execFromArray( @Self, cName )
      else
         uRet = hb_execFromArray( @Self, cName, { xValue } )
      endif
   #endif    

   endif

return nil


//------------------------------------------------//
METHOD AddMethod( cMethod, pFunc ) CLASS TObject
 
   if ! __objHasMethod( Self, cMethod )  
      __objAddMethod( Self, cMethod, pFunc )    
   endif

return nil


//------------------------------------------------//
METHOD DelMethod( cMethod ) CLASS TObject
 
   if ! __objHasMethod( Self, cMethod )  
      __objDelMethod( Self, cMethod )    
   endif

return nil


//------------------------------------------------//

#ifndef __XHARBOUR__
METHOD SendMsg( cMsg, ...  ) CLASS TObject
   if "(" $ cMsg
      cMsg = StrTran( cMsg, "()", "" )
   endif
return __ObjSendMsg( Self, cMsg, ... )
#else   
METHOD SendMsg( ... ) CLASS TObject
   local aParams := hb_aParams()
      
   if "(" $ aParams[ 1 ]
      aParams[ 1 ] = StrTran( aParams[ 1 ], "()", "" )
   endif
 
   ASize( aParams, Len( aParams ) + 1 )
   AIns( aParams, 1 )
   aParams[ 1 ] = Self
   
   return hb_execFromArray( aParams )   
#endif 


//------------------------------------------------//
METHOD ONERROR( uParam1 ) CLASS TObject
   local cCol    := __GetMessage()

   if Left( cCol, 1 ) == "_"
      cCol = Right( cCol, Len( cCol ) - 1 )
   endif
   
   if !::IsDef(cCol)
      ::Add( cCol )
   endif
   
RETURN ::Set(cCol,uParam1)

//EOF
