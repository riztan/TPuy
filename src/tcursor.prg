/*
 *  Proyecto Tpuy.
 *
 *  tcursor.xbs Clase para facilitar manipulacion de datos de un 
 *              arreglo de datos dada la estructura o 
 *              una consulta de dolphin.
 *  
 */

#include "hbclass.ch"
#include "tepuy.ch"


/*
 * Se invoca entegando un arreglo bidimensional con los datos y otro unidimensional con los nombres de las
 * columnas.
 *
 * Igualmente puede invocarse entregando un query de libdolphin.
 *
 * Ejemplo:  TCursor():New({{1,"agua"},{2,"tierra"}}, {"id","elemento"})
 *
 *           ó  TCursor():New( oDolphinQuery )
 *
 * Esto permite iterar con el cursor de datos sin tener acceso a los elementos internos del query ó
 * sin tener que estar trabajando con numeros para referirse a un dato del arreglo, evitando la aparición
 * de errores a futuro cuando algo cambia en la estructura de los datos a usar.
 *
 * Asi, luego se pude acceder (segun el ejemplo) como:
 *
 *  ? oCursor:elemento  ó  oCursor:Get("elemento")  evitando:  aData[1,2]
 *  si, la columna "elemento" cambia de posición... tendríamos un error porque se busca la columna 2.
 *
 */
CLASS TCURSOR

   METHOD New( uData, aNames )
   METHOD Columns()               INLINE  HGetKeys( ::hHeaders )
   METHOD GetData()               INLINE  ::aData
   METHOD Get( cColumn )
   METHOD GetRec( nPos )
   METHOD ForEach( bCode, ... )

   METHOD GoTop()                 INLINE ::nPos := 1
   METHOD GoBottom()              INLINE ::nPos := ::nLen

   METHOD RecCount()              INLINE ::nLen
   METHOD RecNo()                 INLINE ::nPos
   METHOD Skip( nSkip )      
   METHOD GoTo( nPos ) 
   METHOD Bof()                   INLINE ::lBof
   METHOD Eof()                   INLINE ::lEof

protected:

   DATA nLen
   DATA lBof
   DATA lEof

   DATA lQry  INIT  .f.
   DATA oQry
   DATA nPos

   DATA aData
   DATA hHeaders INIT Hash()

   ERROR HANDLER OnError( uValue )

ENDCLASS




METHOD New( uData, aNames )

   HSetCaseMatch( ::hHeaders, .f. )

   if hb_IsArray( uData )
      if Empty( aNames ) ; return uData ; endif

      ::nLen := LEN(uData)
      ::aData := uData
      ::nLen  := LEN(uData)
      AEVAL( aNames, {|a,n| hb_HSet( ::hHeaders, ALLTRIM(a), n ) } )

   elseif hb_IsObject(uData) .and. uData:IsDerivedFrom("TDOLPHINQRY")
      
      ::lQry := .t.
      ::oQry := uData
      ::oQry:GoTop()
      ::nLen := ::oQry:RecCount() 

      ::aData := ::oQry:FillArray()
      AEVAL( ::oQry:aColumns, {|a,n| hb_HSet( ::hHeaders,          ;
                                              ::oQry:FieldName(n), ; 
                                              n ) } )

   else
      return nil
   endif

   ::nPos := 1
   ::lBof := .t.
   ::lEof := iif( ::nPos=::nLen .or. ::nLen=0, .t., .f. ) 

RETURN Self





/** Retorna el valor de la columna solicitada en la posicion ::nPos.
 *
 */
METHOD Get( cColumn )
   local uValue
   default cColumn to ""

   if Empty( cColumn ) ; return ::GetRec() ; endif

   if !HHasKey( ::hHeaders, cColumn ) ; return nil ; endif

   uValue := ::aData[ ::nPos, ::hHeaders[cColumn] ]

   if ValType(uValue)="C" ; uValue := ALLTRIM(uValue); endif

Return uValue




/** Retorna Hash con el contenido del cursor en la posicion
 *  ::nPos o la posición solicitada.
 */
METHOD GetRec( nPos )
   local aNames := HGetKeys( ::hHeaders )
   local hResult := Hash()
   local uValue
   default nPos to ::nPos

   if nPos > ::nLen ; return nil ; endif

   AEVAL( aNames, {|a,n| uValue := ::aData[nPos,n],  ;  
                         hb_HSet( hResult,           ;
                                  a,                 ;
                                  iif(ValType(uValue)="C",ALLTRIM(uValue),uValue) ) } )
RETURN hResult



/** Ejecuta Bloque de Codigo mientras recorre 
 *  los datos del cursor.
 */
METHOD ForEach( bCode, ... )
   local aItem, hData
   local uValue
   FOR EACH aItem IN ::aData
      hData  := Hash()
      AEVAL( ::Columns(), {|a,n| uValue := iif( VALTYPE(aItem[n])="C", ;
                                                ALLTRIM(aItem[n]),     ;
                                                aItem[n] ),;
                                 hb_HSet( hData, a, uValue )  } )
      EVAL( bCode, hData,              ;
                   aItem:__EnumIndex(),;
                   ... )
   NEXT
RETURN



/** Cambia el valor de la posición del cursor
 * 
 */
METHOD Skip(nSkip)
   default nSkip to 1

   if VALTYPE( nSkip ) != "N" ; return .f. ; endif

   if ::nPos+nSkip > ::nLen
      ::nPos := ::nLen 
      ::lEof := .t.
      return .t.
   elseif ::nPos+nSkip <= 1
      ::nPos := 1
      ::lBof := .t.
      return .t.
   else
      ::nPos += nSkip
   endif

RETURN .t.



/**
 *
 */
METHOD GoTo( nPos )
   default nPos to 0

   if VALTYPE( nPos ) != "N" ; return .f. ; endif

   if nPos > ::nLen
      ::nPos := ::nLen 
      ::lEof := .t.
      return .t.
   elseif nPos <= 1
      ::nPos := 1
      ::lBof := .t.
      return .t.
   else
      ::nPos += nPos
   endif

RETURN .T.



/** Atrapamos el error y lo redirigimos al metodo get.
 *  De esta forma, se puede solicitar una columna como 
 *  si de un DATA se tratara.
 *
 */
METHOD OnError( uValue ) 

  Local cMsg   := __GetMessage() //UPPE(ALLTRIM(__GetMessage()))

  If !SubStr( cMsg, 1, 1 ) == "_" // Asignar Valor
     Return ::Get( cMsg ) 
  EndIf

RETURN uValue

//eof
