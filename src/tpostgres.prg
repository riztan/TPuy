/*
 * $Id: TPostgres.prg,v 1.1 2006/09/15 00:30:00 riztan Exp $
 *
 * xHarbour Project source code:
 * PostgreSQL RDBMS low level (client api) interface code.
 *
 * Copyright 2003 Rodrigo Moreno rodrigo_moreno@yahoo.com
 * www - http://www.xharbour.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 * See doc/license.txt for licensing terms.
 *
 */

/*  Noviembre 2008. Riztan Gutierrez  riztan(at)gmail.com
 *
 *  Clase TPQQuery
 *  + var nRows para indicar nro de lineas
 *  de un query (nRows).
 *
 *  + array aData con el contenido devuelto por
 *  el query.
 *
 *  + Hash hData para Iteraccion con la linea actual.
 *
 *
 *  Clase TPQserver.
 *  * Metodo Struct().
 *    + parametro cTypeStruct, para definir el tipo de estructura a presentar.
 *      por defecto sera tipo "DBF" de lo contrario... "postgresql"
 *  + Metodo List_OIDs( cTable )  
 *    Lista los OID de las relaciones existentes
 *    ( oid, relname, relnamespace, relkind )
 *  + Metodo GetTable_OID( cTable )
 *    Para Obtener el oid de una tabla especifica.
 *  + Metodo pg_get_serial_sequence( cTabla, cCampo )
 *    Para obtener arreglo con la(s) secuencia(s) relacionadas a un campo de
 *    una tabla especifica.
 *  + Metodo pg_get_viewdef( cViewName )
 *    Para obtener contenido que define una Vista.
 *  + Metodo get_index_of_table( cTabla )
 *    Retorna el(los) indice(s) perteneciente(s) a la tabla cTabla. No forma parte de postgresql.
 *  + Metodo pg_get_indexdef( uIndex )
 *    Retorna la definicion del indice pasado. El parametro puede ser el OID del indice
 *    o el nombre del indice.
 *  + Metodo SchemaOID( cSchema )
 *    Retorna el numero OID del esquema pasado como parámetro. Si no se especifica,
 *    devolverá OID del esquema actual.
 *  + Metodo ListFunctions( [ "*" | cSchema_name |  ])
 *    Retorna arreglo con funciones del esquema pasado como parametro o esquema por
 *    defecto.  Si se envia como parámetro "*" retorna todas las funciones encontradas.
 *
 *  + Metodo GetField(cField), para obtener el valor del campo cField en la linea actual.
 *  + Metodo ViewExists(cViewName), para conocer la existencia de una vista.
 *
 */

#include "common.ch"
#include "hbclass.ch"
#include "postgres.ch"


CLASS TPQServer
    DATA     pDb
    DATA     cDatabase
    DATA     lTrans
    DATA     lallCols     INIT .T.
    DATA     Schema       INIT 'public'
    DATA     nPort        INIT 5432
    DATA     OID          INIT 0
    DATA     lError       INIT .F.
    DATA     cError       INIT ''
    DATA     lTrace       INIT .F.
    DATA     pTrace   

    DATA cHost
    DATA cUser
    DATA aQueries
   
    METHOD   New( cHost, cDatabase, cUser, cPass, nPort, Schema )
    METHOD   Destroy()            
    METHOD   Close()                 INLINE ::Destroy()
    METHOD   End()                   INLINE ::Destroy()

    METHOD   AddQuery( aQuery )      INLINE AADD( ::aQueries, aQuery )

    METHOD   StartTransaction()
    METHOD   TransactionStatus()     INLINE PQtransactionstatus(::pDb)
    METHOD   Commit()
    METHOD   Rollback()

    METHOD   Query( cQuery, lExtend, lRecurr, cShema )
    METHOD   TpyQuery( cQuery, lRecurr, cSchema )  INLINE  ::Query( cQuery, .t., lRecurr, cSchema )
    METHOD   Execute( cQuery )       INLINE ::Query(cQuery)
    METHOD   SetSchema( cSchema )
    METHOD   SchemaOID( cSchema )

    METHOD   NetErr()                INLINE ::lError
    METHOD   Error()                 INLINE ::cError
    
    METHOD   TableExists( cTable )
    METHOD   ViewExists( cViewName, cSchema )
    METHOD   GetTable_OID( cTable )  INLINE IIF(Empty(cTable),0,::List_OIDs( cTable )[1,1])
    METHOD   GetTablePath( cColumn, nTableOID )  
    METHOD   ListTables()
    METHOD   ListFunctions(cSchema)
    METHOD   List_OIDs( cTable )
    METHOD   GetTable_Comment( cTable, nCol )  
    METHOD   TableStruct( cTable, cTypeStruct )   // cTypeStruct por defecto es 'DBF'
    METHOD   FieldLen( cField, cTable, cSchema )
    METHOD   CreateTable( cTable, aStruct )
    METHOD   DeleteTable( cTable  )
    METHOD   TraceOn(cFile)
    METHOD   TraceOff()
    METHOD   SetVerbosity(num)    INLINE PQsetErrorVerbosity( ::pDb, iif( num >= 0 .and. num <= 2, num, 1 )  )

    METHOD   get_index_of_table( cTabla )    // No pertenece al grupo de funciones de postgresql

    METHOD   pg_get_indexdef( uIndex )                // Definicion compatible con postgresql
    METHOD   pg_get_serial_sequence( cTabla, cCampo ) // Definicion compatible con postgresql
    METHOD   pg_get_viewdef( cViewName )                  // Definicion compatible con postgresql
    //DESTRUCTOR Destroy
ENDCLASS


METHOD New( cHost, cDatabase, cUser, cPass, nPort, Schema ) CLASS TPQserver
    Local res
    //DEFAULT nPort TO 5432
    
    ::pDB := PQconnect(cDatabase, cHost, cUser, cPass, nPort)
    
    if PQstatus(::pDb) != CONNECTION_OK
        ::lError := .T.
        ::cError := PQerrormessage(::pDb) 
        
    else                
        if ! Empty(Schema)
            ::SetSchema(Schema)
        else        
            res := PQexec( ::pDB, 'SELECT current_schema()' )        
            if PQresultStatus(res) == PGRES_TUPLES_OK
                ::Schema := PQgetvalue( res, 1, 1 )
            endif
            PQclear(res)
            res := PQexec(::pDB,"select oid from pg_namespace where nspname = "+;
                                DataToSql(::Schema) )
            if PQresultStatus(res) == PGRES_TUPLES_OK
                ::OID := PQgetvalue( res, 1, 1 )
            endif
        endif                
        ::cHost     := cHost
        ::cUser     := cUser
        ::cDatabase := cDatabase
        ::aQueries  := {}
        ::aSQueries := {}
    endif

RETURN self


METHOD Destroy() CLASS TPQserver
    ::TraceOff()
    PQFinish(::pDb)    
RETURN nil


METHOD SetSchema( cSchema ) CLASS TPQserver
    Local res
    Local result := .F.
    
    if PQstatus(::pDb) == CONNECTION_OK

        res := PQexec( ::pDB, "SET search_path TO " + DataToSql(cSchema) )        
        result := (PQresultStatus(res) == PGRES_COMMAND_OK)
        
        If !result
           Return result
        EndIf

        PQclear(res)
        res := PQexec(::pDB,"SELECT oid FROM pg_namespace WHERE nspname = "+;
                            DataToSql(cSchema) )
        result := (PQresultStatus(res) == PGRES_TUPLES_OK)
        
        If !result
           Return result
        EndIf

        ::Schema := cSchema
        ::OID    := AllTrim(CStr(PQgetvalue( res, 1, 1 )))
        PQclear(res)
        
    endif        
RETURN result


METHOD StartTransaction() CLASS TPQserver
    Local res, lError
    
    res    := PQexec( ::pDB, 'BEGIN' )        
    lError := PQresultstatus(res) != PGRES_COMMAND_OK

    if lError
        ::lError := .T.
        ::cError := PQresultErrormessage(res)       
    else
        ::lError := .F.
        ::cError := ''    
    endif
    PQclear(res)    
RETURN lError


METHOD Commit() CLASS TPQserver
    Local res, lError
    
    res    := PQexec( ::pDB, 'COMMIT' )    
    lError := PQresultstatus(res) != PGRES_COMMAND_OK
    
    if lError
        ::lError := .T.
        ::cError := PQresultErrormessage(res)       
    else
        ::lError := .F.
        ::cError := ''    
    endif
    //PQclear(res)
RETURN lError

    
METHOD Rollback() CLASS TPQserver
    Local res, lError
    
    res    := PQexec( ::pDB, 'ROLLBACK' )    
    lError := PQresultstatus(res) != PGRES_COMMAND_OK

    if lError
        ::lError := .T.
        ::cError := PQresultErrormessage(res)       
    else
        ::lError := .F.
        ::cError := ''    
    endif
    //PQclear(res)
RETURN lError


METHOD Query( cQuery, lExtend, lRecurr, cSchema ) CLASS TPQserver

    Local oQuery

    Default lExtend to .f.
    Default lRecurr to .f.
    Default cSchema to ::Schema

//    ?
//    ? "TPOSTGRES:QUERY()"
//    ? cSchema

    oQuery := TPQquery():New( self, ::pDB, cQuery, ::lallCols, cSchema, , lExtend, lRecurr )

RETURN oQuery

    
METHOD TableExists( cTable, cSchema ) CLASS TPQserver
    Local result := .F.
    Local cQuery
    Local res

    Default cSchema To ::Schema

    cQuery := "select table_name "
    cQuery += "from information_schema.tables "
    cQuery += "where table_type = 'BASE TABLE' and table_schema = "
    cQuery += DataToSql(cSchema) + " and table_name = " + DataToSql(lower(cTable))

    res := PQexec( ::pDB, cQuery )
    
    if PQresultstatus(res) == PGRES_TUPLES_OK
        result := (PQlastrec(res) != 0)
        ::lError := .F.
        ::cError := ''    
    else
        ::lError := .T.
        ::cError := PQresultErrormessage(res)       
    endif
    
    //PQclear(res)
RETURN result    


METHOD ViewExists( cViewName, cSchema ) CLASS TPQserver
    Local result := .F.
    Local cQuery
    Local res

    Default cSchema To ::Schema

? procname()
? cViewName
    cQuery := "select table_name "
    cQuery += "from information_schema.tables "
    cQuery += "where table_type = 'VIEW' and table_schema = "
    cQuery += DataToSql(cSchema) + " and table_name = " + DataToSql(lower(cViewName))

    res := PQexec( ::pDB, cQuery )
    
? cQuery
? PQlastrec(res)
? "fin."
    if PQresultstatus(res) == PGRES_TUPLES_OK
        result := (PQlastrec(res) != 0)
        ::lError := .F.
        ::cError := ''    
    else
        ::lError := .T.
        ::cError := PQresultErrormessage(res)       
    endif
    
    //PQclear(res)
RETURN result    


METHOD GetTable_Comment( cTable, nCol )  CLASS TPQserver

   Local nOID, res, result:=''

   IF cTable==NIL
      Return ''
   ENDIF

   IF nCol== NIL
      nCol := 0
   ENDIF
   
   nOID := ::GetTable_OID(cTable)

   res := PQexec( ::pDB, "select col_description("+DataToSql(nOID)+","+;
                         DataToSql(nCol)+")" )

   if PQresultstatus(res) == PGRES_TUPLES_OK
       result := (PQgetvalue( res, 1, 1 ))
       ::lError := .F.
       ::cError := ''    
   else
       ::lError := .T.
       ::cError := PQresultErrormessage(res)       
   endif

RETURN result


METHOD ListTables() CLASS TPQserver
    Local result := {}
    Local cQuery
    Local res
    Local i
    
    cQuery := "select table_name "
    cQuery += "  from information_schema.tables "
    cQuery += "  where table_schema = " + DataToSql(::Schema)
    cQuery += " and table_type = 'BASE TABLE' "
    
    res := PQexec( ::pDB, cQuery )
    
    if PQresultstatus(res) == PGRES_TUPLES_OK
        For i := 1 to PQlastrec(res)
            aadd( result, PQgetvalue( res, i, 1 ) )
        Next                    
        ::lError := .F.
        ::cError := ''            
    else
        ::lError := .T.
        ::cError := PQresultErrormessage(res)
    endif
    
    //PQclear(res)
RETURN result  



METHOD List_OIDs(cTable) CLASS TPQserver
    Local result := {}
    Local cQuery
    Local res
    Local i

    cQuery := " select oid, relname, relnamespace, relkind "
    cQuery += " from pg_class "

    If cTable != NIL
       cQuery += " where relname =" + DataToSql(cTable)
    EndIf
    
    res := PQexec( ::pDB, cQuery )
    
    if PQresultstatus(res) == PGRES_TUPLES_OK
        For i := 1 to PQlastrec(res)
            aadd( result, { PQgetvalue( res, i, 1 ),;
                            PQgetvalue( res, i, 2 ),;
                            PQgetvalue( res, i, 3 ),;
                            PQgetvalue( res, i, 4 ) ;
                            })
        Next                    
        ::lError := .F.
        ::cError := ''            
    else
        ::lError := .T.
        ::cError := PQresultErrormessage(res)
    endif
    
    PQclear(res)
RETURN result  



METHOD GetTablePath( cColumn, nTableOID ) CLASS TPQServer
   local result := {}
   local cQuery
   local res
   local cString
   
   cQuery := "select relname, relnamespace, nspname, relkind "
   cQuery += " from pg_class "
   cQuery += " join pg_namespace on  relnamespace = pg_namespace.oid "
   cQuery += " where pg_class.oid = "+DataToSql(nTableOID)
/*
  select relname,relnamespace, relkind from pg_class
  relkind i = indice
          r = rules (tabla)
          v = vista
          S = secuencia
*/

   res := PQExec( ::pDB, cQuery )

   if PQresultstatus(res) == PGRES_TUPLES_OK

      /* Si es una vista tenemos que buscar los datos de las tablas involucradas */
      if pqGetValue( res, 1, 3 ) == "v"

//? "/////////////////////////////////////////////////////////////////////////"
//? cColumn," --- ",cQuery
//? "/////////////////////////////////////////////////////////////////////////"
         cString := "view_schema = " + DataToSQL( pqGetValue( res, 1, 2) ) 
         cString += " and view_name = " + DataToSQL( pqGetValue( res, 1, 1 ) )
         
//? " AAAAAAANNNNNNNNNNTTTTTTTTEEEEEESSSSSS"
         pqClear( res ) 
//? " DDDDDEEEEESSSSPPPPPUUUUUEEEEESSS"

         cQuery := " select table_schema, table_name, column_name from "
         cQuery += " information_schema.view_column_usage "  
         cQuery += " where " + cString
         cQuery += " and column_name = " + DataToSQL( cColumn )
//? "&&&&&&&&&"
//? cQuery
//? "&&&&&&&&&"
         res := pqExec( ::pDB, cQuery )
         if PQresultstatus(res) == PGRES_TUPLES_OK
            result := { pqGetValue( res, 1, 1 ), ;
                        pqGetValue( res, 1, 2 ), ;
                        pqGetValue( res, 1, 3 ), ;
                        pqGetValue( res, 1, 1 ) + "." + pqGetValue( res, 1, 3 ) }
//? "%%%%%%%%%%%%%"
//? hb_valtoexp( result )
//? "%%%%%%%%%%%%%"
         else
            ::lError := .t.
            ::cError := pqResultErrorMessage(res)
         endif
         pqClear( res )
         return result
      endif

//? valtype( PQgetvalue(res,1,1) )
//? ( PQgetvalue(res,1,1) )
//? valtype( PQgetvalue(res,1,2) )
//? ( PQgetvalue(res,1,2) )
//?
      result := { PQgetvalue( res, 1, 1 ), Val( PQgetValue(res, 1, 2) ), NIL, NIL }
      PQClear(res)

      cQuery := "select nspname from pg_namespace where "
      cQuery += "oid = " + DataToSql( result[2] )
      res := PQExec( ::pDB, cQuery )
      if PQResultStatus(res) == PGRES_TUPLES_OK
         result[3] := PQGetValue( res, 1, 1 )
         result[4] := result[3] + "." + result[1]
      else
         ::lError := .T.
         ::cError := PQResultErrorMessage(res)
      endif
   else
      ::lError := .T.
      ::cError := PQresultErrormessage(res)
   endif

   PQClear(res)

RETURN result




/** \brief Obtener el OID del esquema por defecto o el esquema pasado
 *  como parametro. Retorna valor del OID del esquema.
 *  sintaxis:  oConn:SchemaOID( ['cSchema_name'] )
 *  \par string cSchema_name
 */
METHOD SchemaOID(cSchema) CLASS TPQserver
    Local result
    Local cQuery
    Local res
    
    Default cSchema to ::Schema

    cQuery := " select oid from pg_namespace "
    cQuery += " where nspname = '"+cSchema+"'"
    
    res := PQexec( ::pDB, cQuery )

    if PQresultstatus(res) == PGRES_TUPLES_OK
       result := Val( PQgetvalue( res, 1, 1 ) )
    else
        ::lError := .T.
        ::cError := PQresultErrormessage(res)
    endif
        
    PQclear(res)
RETURN result  


/** \brief retorna arreglo con la identificacion de la(s) funcion(es) relacionada(s)
 *  con el esquema.
 *  sintaxis:  oConn:ListFunctions( '[cSchema_name | * ]' )
 *  \par string cSchema_name ó '*' para retornar todas las funciones.
 */
METHOD ListFunctions( cSchema ) CLASS TPQserver
    Local result := {}
    Local cQuery
    Local res, nOIDSchema
    Local i

    Default cSchema to ::Schema
    
    If cSchema != "*"
       nOIDSchema := ::SchemaOID( cSchema )
    EndIf
    
    cQuery := " select proname, pronamespace, proowner, prolang, prosrc "
    cQuery += " from pg_proc "
    If cSchema != "*"
       cQuery += " where pronamespace = "+CStr(nOIDSchema)
    EndIf

    
    res := PQexec( ::pDB, cQuery )
    
    if PQresultstatus(res) == PGRES_TUPLES_OK
        For i := 1 to PQlastrec(res)
            aadd( result, { PQgetvalue( res, i, 1 ),;
                            PQgetvalue( res, i, 2 ),;
                            PQgetvalue( res, i, 3 ),;
                            PQgetvalue( res, i, 4 ),;
                            PQgetvalue( res, i, 5 ) ;
                            })
                            
        Next                    
        ::lError := .F.
        ::cError := ''            
    else
        ::lError := .T.
        ::cError := PQresultErrormessage(res)
    endif
    
    //PQclear(res)
RETURN result  



/** \brief retorna arreglo con la identificacion de la(s) secuencia(s) relacionada(s)
 *  con la columna y tabla especificada en los parametros.
 *  sintaxis:  oConn:pg_get_serial_sequence( '[schema_name.]table_name','column_name' )
 *  \par string cTabla
 *  \par string cCampo
 */
METHOD pg_get_serial_sequence(cTabla, cCampo) CLASS TPQserver
    Local result := {}
    Local cQuery
    Local res
    Local i

    IF cTabla == NIL .OR. cCampo==NIL
       Return ''
    ENDIF

    IF AT('.',cTabla)==0
       cTabla := Alltrim(::Schema)+"."+Alltrim(cTabla)
    ENDIF

    cQuery := " select pg_get_serial_sequence("
    cQuery += DataToSql(cTabla)+","+DataToSql(cCampo)+")"

    res := PQexec( ::pDB, cQuery )

    if PQresultstatus(res) == PGRES_TUPLES_OK
        For i := 1 to PQlastrec(res)
            aadd( result, { PQgetvalue( res, i, 1 ) })
        Next                    
        ::lError := .F.
        ::cError := ''            
    else
        ::lError := .T.
        ::cError := PQresultErrormessage(res)
    endif
    
    //PQclear(res)
RETURN result  


/** \brief retorna el contenido que define una vista.
 *  sintaxis:  oConn:pg_get_viewdef( '[schema_name.]view_name' )
 *  \par string cViewName (Nombre de la vista)
 */
METHOD pg_get_viewdef( cViewName ) CLASS TPQserver
    Local result := {}
    Local cQuery
    Local res
    Local i

    IF cViewName == NIL
       Return ''
    ENDIF

    IF AT('.',cViewName)==0
       cViewName := Alltrim(::Schema)+"."+Alltrim(cViewName)
    ENDIF

    cQuery := " select pg_get_viewdef("
    cQuery += DataToSql(cViewName)+")"

    res := PQexec( ::pDB, cQuery )

    if PQresultstatus(res) == PGRES_TUPLES_OK
        For i := 1 to PQlastrec(res)
            aadd( result, { PQgetvalue( res, i, 1 ) })
        Next                    
        ::lError := .F.
        ::cError := ''            
    else
        ::lError := .T.
        ::cError := PQresultErrormessage(res)
    endif
    
    //PQclear(res)
RETURN result  


/** \brief retorna los indices relacionados con una tabla.
 *  sintaxis:  oConn:get_index_of_table( '[schema_name.]table_name' )
 *  \par string cTabla (Nombre de la tabla)
 */
METHOD get_index_of_table( cTabla )
    Local result := {}
    Local cQuery
    Local res
    Local i

    IF cTabla == NIL
       Return ''
    ENDIF

//    IF AT('.',cTabla)==0
//       cTabla := Alltrim(::Schema)+"."+Alltrim(cTabla)
//    ENDIF

    cQuery := " select constraint_name, constraint_type from"
    cQuery += " information_schema.table_constraints where"
    cQuery += " table_name="+DataToSql(cTabla)+" and"
    cQuery += " constraint_schema="+DataToSql(::Schema)+" and"
    cQuery += " constraint_type='PRIMARY KEY'"

// Msg_Info( cQuery )

    res := PQexec( ::pDB, cQuery )

    if PQresultstatus(res) == PGRES_TUPLES_OK
        For i := 1 to PQlastrec(res)
            aadd( result, PQgetvalue( res, i, 1 ) )
        Next                    
        ::lError := .F.
        ::cError := ''            
    else
        ::lError := .T.
        ::cError := PQresultErrormessage(res)
    endif
    
    //PQclear(res)
RETURN result  


/** \brief retorna la definicion de un indice especifico.
 *  si el parametro es numerico, lo asume como el oid del indice.
 *  de lo contrario asume el nombre de la tabla y si no especifica
 *  el esquema, utiliza el de la conexión.
 *  sintaxis:  oConn:pg_get_indexdef(index_oid or table_name)
 *  \par string or integer uTabla (OID del indice o Nombre del indice)
 */
METHOD pg_get_indexdef( uIndex ) CLASS TPQserver
    Local result := {}
    Local cQuery
    Local res
    Local i

    IF uIndex == NIL
       Return ''
    ENDIF

    cQuery := " select pg_get_indexdef("

    IF ValType(uIndex)='N'
       cQuery += uIndex
    ELSE
       IF AT('.',uIndex)==0
          uIndex := Alltrim(::Schema)+"."+Alltrim(uIndex)
       ENDIF
       cQuery += DataToSql(uIndex)+"::regclass"
    ENDIF

    cQuery += ")"

    res := PQexec( ::pDB, cQuery )

    if PQresultstatus(res) == PGRES_TUPLES_OK
        For i := 1 to PQlastrec(res)
            result := PQgetvalue( res, i, 1 )
        Next                    
        ::lError := .F.
        ::cError := ''            
    else
        ::lError := .T.
        ::cError := PQresultErrormessage(res)
    endif
    
    //PQclear(res)
RETURN result  



METHOD TableStruct( cTable, cTypeStruct ) CLASS TPQserver
    Local result := {}
    Local cQuery
    Local res
    Local i
    Local cField
    Local cType, cPgType
    Local nSize
    Local nDec
    Local cNullable

    IF cTypeStruct == NIL
       cTypeStruct := "DBF"
    ENDIF
    
    cQuery := "SELECT column_name, data_type, character_maximum_length, "
    cQuery +=        "numeric_precision, numeric_scale, is_nullable "
    cQuery += " FROM information_schema.columns "
    cQuery += " WHERE table_schema = " + DataToSql(::Schema)
    cQuery +=       " and table_name = " + DataToSql(lower(cTable))
    cQuery += " ORDER BY ordinal_position "                                                             

    res := PQexec( ::pDB, cQuery )

    if PQresultstatus(res) == PGRES_TUPLES_OK
        For i := 1 to PQlastrec(res)
            cField    := PQgetvalue(res, i, 1)
            cType     := PQgetvalue(res, i, 2)
            cPgType   := PQgetvalue(res, i, 3)
            nSize     := PQgetvalue(res, i, 4)
            nDec      := PQgetvalue(res, i, 5)
            cNullable := PQgetvalue(res, i, 6)

            if 'char' $ cType
                cType := 'C'
                nSize := Val(PQgetvalue(res, i, 3))
                nDec  := 0

            elseif 'text' $ cType                 
                cType := 'M'
                nSize := 10
                nDec := 0

            elseif 'boolean' $ cType
                cType := 'L'
                nSize := 1
                nDec  := 0

            elseif 'smallint' $ cType
                cType := 'N'
                nSize := 5
                nDec  := 0
                
            elseif 'integer' $ cType .or. 'serial' $ cType
                cType := 'N'
                nSize := 9
                nDec  := 0
                
            elseif 'bigint' $ cType .or. 'bigserial' $ cType
                cType := 'N'
                nSize := 19
                nDec  := 0
                
            elseif 'decimal' $ cType .or. 'numeric' $ cType
                cType := 'N'
                nDec  := val(nDec)
                // Postgres don't store ".", but .dbf does, it can cause data width problem
                nSize := val(nSize) + iif( ! Empty(nDec), 1, 0 )

                // Numeric/Decimal without scale/precision can genarete big values, so, i limit this to 10,5
                
                if nDec > 100
                    nDec := 5
                endif
                
                if nSize > 100
                    nSize := 15
                endif

            elseif 'real' $ cType .or. 'float4' $ cType
                cType := 'N'
                nSize := 15
                nDec  :=  4
                
            elseif 'double precision' $ cType .or. 'float8' $ cType
                cType := 'N'
                nSize := 19
                nDec  := 9
                
            elseif 'money' $ cType               
                cType := 'N'
                nSize := 9
                nDec  := 2
                
            elseif 'timestamp' $ cType               
                cType := 'C'
                nSize := 20
                nDec  := 0

            elseif 'date' $ cType               
                cType := 'D'
                nSize := 8
                nDec  := 0

            elseif 'time' $ cType               
                cType := 'C'
                nSize := 10
                nDec  := 0

            else
                // Unsuported
                cType := 'U'
                nSize := 0
                nDec  := -1

            end               

            if cType <> 'U'
                IF cTypeStruct = "DBF"
                   aadd( result, { cField, cType, nSize, nDec } )
                ELSE
                   aadd( result, { cField, cPgType, nSize, nDec, ;
                                   IIF( 'NO' $ cNullable , 'NOT NULL' , '' ) } )
                ENDIF
            end                

        Next
        ::lError := .F.
        ::cError := ''    
    else
        ::lError := .T.
        ::cError := PQresultErrormessage(res)               
    endif
    
    //PQclear(res)
RETURN result  


METHOD FieldLen( cField, cTable, cSchema ) CLASS TPQserver
   Local cQuery
   Local nSize := 0
   Local res

   Default cTable  TO ""
   Default cSchema TO ::Schema
    
   cQuery := "SELECT character_maximum_length "
   cQuery += "FROM information_schema.columns "
   cQuery += "WHERE table_schema = " + DataToSql(cSchema) + " and "
   cQuery +=       "column_name = "+DataToSql(AllTrim(cField))+" "
   cQuery += IIF(!Empty(cTable), "and table_name = " + DataToSql(lower(cTable))+" ","")
   cQuery += "ORDER BY ordinal_position limit 1"

   res := PQexec( ::pDB, cQuery )
    
   If PQresultstatus(res) == PGRES_TUPLES_OK
      nSize     := Val(PQgetvalue(res, 1, 1))

      ::lError := .F.
      ::cError := ''    
   Else
      ::lError := .T.
      ::cError := PQresultErrormessage(res)               
   EndIf
    
   //PQclear(res)

RETURN nSize



METHOD CreateTable( cTable, aStruct ) CLASS TPQserver
    Local result := .T.
    Local cQuery
    Local res
    Local i
    
    cQuery := 'CREATE TABLE ' + ::Schema + '.' + cTable + '( '
    
    For i := 1 to Len(aStruct)
    
        cQuery += aStruct[i, 1]
        
        if aStruct[ i, 2 ]     == "C"
            cQuery += ' Char(' + ltrim(str(aStruct[i, 3])) + ')'
                
        elseif aStruct[ i, 2 ] == "D"
            cQuery += ' Date '                                                        
            
        elseif aStruct[ i, 2 ] == "N"
            cQuery += ' Numeric(' + ltrim(str(aStruct[i, 3])) + ',' + ;
                                    ltrim(str(aStruct[i, 4])) + ')'

        elseif aStruct[ i, 2 ] == "L"
            cQuery += ' boolean '
            
        elseif aStruct[ i, 2 ] == "M"
            cQuery += ' text '
        end
        
        if i == Len(aStruct)
            cQuery += ')'
        else
            cQuery += ','
        end    
    Next
    
    res := PQexec( ::pDB, cQuery )
        
    if PQresultstatus(res) != PGRES_COMMAND_OK
        result := .F.
        ::lError := .T.
        ::cError := PQresultErrormessage(res)       
    else
        ::lError := .F.
        ::cError := ''    
    end
    
    //PQclear(res)
RETURN result


METHOD DeleteTable( cTable ) CLASS TPQserver
    Local result := .T.
    Local res

    res := PQexec( ::pDB, 'DROP TABLE ' + ::Schema + '.' + cTable  )
    
    if PQresultstatus(res) != PGRES_COMMAND_OK
        result := .F.
        ::lError := .T.
        ::cError := PQresultErrormessage(res)       
    else
        ::lError := .F.
        ::cError := ''            
    end
    
    //PQclear(res)
RETURN result


METHOD TraceOn( cFile ) CLASS TPQserver
    ::pTrace := PQtracecreate( cFile )
    
    if ::pTrace != NIL
        PQtrace( ::pDb, ::pTrace )
        ::lTrace := .t.
    endif                
RETURN nil


METHOD TraceOff() CLASS TPQserver
    if ::pTrace != NIL
        PQuntrace( ::pDb )
        //PQclosetrace( ::pTrace )    
    endif
    
    ::lTrace := .f.                
RETURN nil



CLASS TPQQuery FROM TPUBLIC
    DATA     pQuery
    DATA     pDB

    DATA     oConn

    DATA     lBof
    DATA     lEof
    DATA     lClosed
    DATA     lallCols INIT .T.

    DATA     lError   INIT .F.
    DATA     cError   INIT ''

    DATA     cQuery
    DATA     nRecno
    DATA     nFields
    DATA     nLastrec
    DATA     nRows
    DATA     nTime

    DATA     aData
    DATA     aSData
    DATA     hData
    DATA     aStruct
    DATA     bValue
#ifdef __TPUY__
    DATA     aTpyStruct
#endif
    DATA     aKeys
    DATA     TableName
    DATA     Schema
    DATA     rows     INIT 0

    METHOD   New( oConn, pDB, cQuery, lallCols, cSchema, res )
    METHOD   Destroy()          
    METHOD   Close()            INLINE ::Destroy()
    METHOD   End()              INLINE ::Destroy()

    METHOD   Refresh(lQuery)  
    METHOD   Fetch()            INLINE ::Skip()
    METHOD   Skip( nRecno )             

    METHOD   Bof()              INLINE ::lBof
    METHOD   Eof()              INLINE ::lEof
    METHOD   RecNo()            INLINE ::nRecno
    METHOD   RecCount()         INLINE ::nRows
    METHOD   Lastrec()          INLINE ::nLastrec
    METHOD   GoTo(nRecno)       
    METHOD   GoTop(nRecno)      INLINE ::GoTo(IIF(Empty(nRecno),1,nRecno))
    METHOD   GoBottom(nRecno)   INLINE ::GoTo(IIF(Empty(nRecno),::nRows,nRecno))

    METHOD   NetErr()           INLINE ::lError
    METHOD   Error()            INLINE ::cError    

    METHOD   FCount()           INLINE ::nFields
    METHOD   FieldName( nField )
    METHOD   FieldPos( cField )
    METHOD   FieldLen( nField )
    METHOD   FieldDec( nField )
    METHOD   FieldType( nField )
    METHOD   Update( oRow )
    METHOD   Delete( oRow )
    METHOD   Append( oRow )
    METHOD   SetKey()

    METHOD   Changed(nField)    INLINE ::aRow[nField] != ::aOld[nField]
    METHOD   Blank()            INLINE ::GetBlankRow()

    METHOD   Struct()
    
    METHOD   FillArray()        INLINE ::aData
    METHOD   RefreshIter()
    METHOD   FieldGet( nField, nRow )
    METHOD   GetRow( nRow )   
    METHOD   GetBlankRow()  
    METHOD   Field(cField)      INLINE ::GetField(cField)
    METHOD   GetField( cField )
    METHOD   FieldProperty( cField, cProperty )
    METHOD   GetTables( aItems )

    ERROR HANDLER OnError( uValue )
    
    //DESTRUCTOR Destroy
ENDCLASS


METHOD New( oConn, pDB, cQuery, lallCols, cSchema, res, lExtend, lRecurr ) CLASS TPQquery
    ::pDB      := pDB
    ::oConn    := oConn
    ::lClosed  := .T.    
    ::cQuery   := cQuery
    ::lallCols := lallCols
    ::Schema   := cSchema
    ::aData    := {}
    ::aSData    := {}
    ::hData    := Hash()
    ::hVars    := Hash()

    ::lAutoAdd := .t.
    
    if ! ISNIL(res)
        ::pQuery := res
    endif

//?
//? "TPQQUERY:NEW()"
//? cSchema
            
    ::Refresh(ISNIL(res), lExtend, lRecurr, cSchema)

//? oConn:ClassName()
    oConn:AddQuery( { "pg", hb_DateTime(), cSchema, ::cQuery, ::aStruct, ::aData, hb_MD5(::cQuery) } )
    ::lAutoAdd := .f.

RETURN self


METHOD Destroy() CLASS TPQquery
    if ! ::lClosed
        PQclear( ::pQuery )    
        ::lClosed := .T.
    endif        
RETURN .T.


METHOD Refresh(lQuery, lExtend, lRecurr, cSchema) CLASS TPQquery
    Local res
    Local aStruct := {}
    Local aTemp  
    //Local aRow  
    //Local aOld 
    Local i
    Local cFName, cType, cPgType, nDec, nSize, nTable, nPosition, aPath
    Local nCol, nTime, nLenArray
    Local xTemp
#ifdef __TPUY__
    Local aSchemas := {}, cSch
    Local cFldWhere := ""
    Local cWhere, cTpyQuery
    Local cBaseColumns := "base_columns"
    Local aLine, nLenStruct,aTpyStruct
#endif


    Default lQuery  To .T.
    Default lRecurr To .t.
    Default lExtend To .f.
    Default cSchema To ::oConn:Schema

#ifdef __TPUY__
    AADD( aSchemas, cSchema )
#endif

    ::Destroy()

    ::lBof     := .F.
    ::lEof     := .F.
    ::lClosed  := .F.    
    ::nRecno   := 0
    ::nFields  := 0
    ::nLastrec := 0    
    ::nRows    := 0
    ::aStruct  := {}
    ::aData    := {}
    ::aSData   := {}
    ::hData    := Hash()
    ::Rows     := 0
    ::nTime    := 0
    ::bValue   := {|cField| ::hData[cField] }
#ifdef __TPUY__
    AADD( aSchemas, "tpuy" )
#endif

    if lQuery
        nTime := Seconds()
        res := PQexec( ::pDB, ::cQuery )
        nTime := Seconds() - nTime
//? "====="
//? "====="
//? procname()
//? "Ejecutando nuevamente el query "
//? ::cQuery
//? "====="
//? "====="
    else
        res := ::pQuery
    endif

    if PQresultstatus(res) == PGRES_TUPLES_OK     
        // Get some information about metadata
        aTemp := PQmetadata(res)
//? "&&&&&&&&& &&&&&&&& &&&&&&&& &&&&&&& &&&&&&&&"
//? hb_valtoexp( aTemp )
//? "&&&&&&&&& &&&&&&&& &&&&&&&& &&&&&&& &&&&&&&&"
        ::nTime  := nTime
#ifdef __TPUY__
        if lExtend 
           ::aTpyStruct := {}

           if ::oConn:ViewExists( "v_"+cBaseColumns, cSchema )
              cBaseColumns := cSchema + ".v_"+cBaseColumns
           else
              cBaseColumns := cSchema + "." + cBaseColumns
           endif
//? "__________________________________"
//? " TPOSTGRES. REFRESH() BASECOLUMNS"
//? "__________________________________"
//? cBaseColumns
        endif
#endif
        
        if ISARRAY(aTemp)                        
            cFName := ""
            nLenArray := Len(aTemp)
            For i := 1 to nLenArray
                cType    := aTemp[ i, 2 ]
                cPgType  := aTemp[ i, 2 ]
                nSize    := aTemp[ i, 3 ]
                nDec     := aTemp[ i, 4 ]
                nTable   := aTemp[ i, 5 ]
                nPosition:= aTemp[ i, 6 ]
                if nTable != 0
                   aPath :=  ::oConn:GetTablePath( aTemp[i,1], nTable )
                else
                   aPath := Array(4)
                endif

#ifdef __TPUY__
                cFName   += iif( i = 1, "( col_name =", " or col_name = " ) + DataToSQL( aTemp[ i, 1 ] )

                AADD( aSchemas, aPath[3] )
                cFldWhere += iif( i = 1, "( col_name =", " or ( col_name = " ) + DataToSQL( aTemp[ i, 1 ] )
                cFldWhere += " and information_schema.tables.table_schema = " + DataToSQL( aPath[3] )
                cFldWhere += " and information_schema.tables.table_name = " + DataToSQL( aPath[1] ) + " ) "
#endif

                if nSize == 0 .and. PQlastrec(res) >= 1
                    //nSize := PQgetLength(res, 1, i)
                    nSize := PQfmod( res, i )
                endif                    
                
                if 'char' $ cType
                    cType := 'C'
                    nSize := nSize - VARHDRSZ
        
                elseif 'text' $ cType                 
                    cType := 'M'
        
                elseif 'boolean' $ cType
                    cType := 'L'
                    nSize := 1
        
                elseif 'smallint' $ cType
                    cType := 'N'
                    nSize := 5
                
                elseif 'integer' $ cType .or. 'serial' $ cType
                    cType := 'N'
                    nSize := 9
                
                elseif 'bigint' $ cType .or. 'bigserial' $ cType
                    cType := 'N'
                    nSize := 19
                
                elseif 'decimal' $ cType .or. 'numeric' $ cType
                    cType := 'N'
                    
                    // Postgres don't store ".", but .dbf does, it can cause data width problem
                    if ! Empty(nDec)
                        nSize++
                    endif                        

                    // Numeric/Decimal without scale/precision can genarete big values, so, i limit this to 10,5
                    if nDec > 100
                        nDec := 5
                    endif

                    nSize := nSize - VARHDRSZ
                
                    if nSize > 100
                        nSize := 15
                    endif        
        
                elseif 'real' $ cType .or. 'float4' $ cType
                    cType := 'N'
                    nSize := 15
                    nDec  :=  4
                
                elseif 'double precision' $ cType .or. 'float8' $ cType
                    cType := 'N'
                    nSize := 19
                    nDec  := 9
                
                elseif 'money' $ cType               
                    cType := 'N'
                    nSize := 10
                    nDec  := 2
                
                elseif 'timestamp' $ cType               
                    cType := 'C'
                    nSize := 20
        
                elseif 'date' $ cType               
                    cType := 'D'
                    nSize := 8
        
                elseif 'time' $ cType               
                    cType := 'C'
                    nSize := 10
        
                else
                    // Unsuported
                    cType := 'K'
                endif               
                
                aadd( aStruct, {aTemp[ i, 1 ], ;
                                cType,         ;
                                nSize,         ;
                                nDec,          ;
                                nTable,        ;
                                nPosition,     ;
                                cPgType,       ;
                                aPath[4],      ;
                                hb_valtoexp(aPath)  } )
                //HSet( ::hData , aTemp[i,1], NIL )
//                __objAddInline( self, aTemp[i,1], {|| ::Get(aTemp[i,1]):Value } )

                
                xTemp := Hash()
                //::Add( aTemp[i,1], Hash() )
                //xTemp := ::Get( aTemp[i,1] )
                xTemp:Value     := ""
                xTemp:OldValue  := ""
                xTemp:Type      := cType
                xTemp:Size      := nSize
                xTemp:Dec       := nDec
                xTemp:PgType    := cPgType
                xTemp:ColPos    := i
                xTemp:OidTable  := nTable
#ifdef __TPUY__
                xTemp:GtkType:= IIF( cType == "L" , "active" , "text" )
                xTemp:id                   := ""
                xTemp:schema               := ""
                xTemp:table                := ""
                xTemp:name                 := aTemp[i,1]
                xTemp:description          := ""
                xTemp:editable             := .t.
                xTemp:reference            := .f.
                xTemp:ref_scriptname       := ""
                xTemp:ref_table            := ""
                xTemp:ref_link             := ""
                xTemp:ref_descriptor       := ""
                xTemp:ref_picture          := ""
                xTemp:ref_viewable         := .f.
                xTemp:ref_navigable        := .f.
                xTemp:ref_default          := ""
                xTemp:ref_order            := ""
                xTemp:widget               := ""
#endif
                ::Add( aTemp[i,1], xTemp )
//                __objAddData( self, aTemp[i,1], xTemp:Value )
//                ? __objSendMsg( ::aTemp[i,1], xTemp:Value )

//? "test ",aTemp[i,1]
//__objAddData( self, "minombre", {=>} )

            Next    
//? "test 2"
//::hVars:minombre := "riztan" 
/*
? "test 3"
? hb_valtoexp( __objGetMsgList( self ) )
__objSendMsg( ::minombre, "gutierrez" )
? Valtype( ::minombre )
::minombre:description := "riztan" 
*/
#ifdef __TPUY__
            if lExtend
               cFName +=" ) "
//? cFName
               if lRecurr
/*
                  cWhere    := "where " + cFName + ;
                               " and (information_schema.tables.table_schema = " + ;
                               DataToSQL(cSchema) + " or " + ;
                               " information_schema.tables.table_schema = 'tpuy') and " + ;
                               cBaseColumns + ".col_table_name=information_schema.tables.table_name " 
*/
                  cTpyQuery := "select "
                  cTpyQuery += "col_id, "
                  cTpyQuery += "col_schema, "
                  cTpyQuery += "col_table, "
                  cTpyQuery += "col_name, "
                  cTpyQuery += "col_description, "
                  cTpyQuery += "col_editable, "
                  cTpyQuery += "col_reference, "
                  cTpyQuery += "col_ref_scriptname, "
                  cTpyQuery += "col_ref_table, "
                  cTpyQuery += "col_ref_link, "
                  cTpyQuery += "col_ref_descriptor, "
                  cTpyQuery += "col_picture, "
                  cTpyQuery += "col_viewable, "
                  cTpyQuery += "col_navigable, "
                  cTpyQuery += "col_default, "
                  cTpyQuery += "col_order, "
                  cTpyQuery += "col_container, "
                  cTpyQuery += "col_valid "
                  cTpyQuery += " from " + cBaseColumns + ", " + ;
                               "information_schema.tables " + " where " + cFldWhere //cWhere 
                  cTpyQuery += " order by col_order "
/*
? "Esquema ", cSchema
? hb_valtoexp( aSchemas )
? cFldWhere
?
? cTpyQuery
*/

                  ::aTpyStruct := ::oConn:Query( cTpyQuery, .f., , cSchema ):aData
/*
? hb_valtoexp( ::aTpyStruct )
? "logitud de aTpyStruct ", LEN(::aTpyStruct)
? hb_valtoexp(::aTpyStruct)
*/
                  if Empty( ::aTpyStruct )
   
                     cTpyQuery := "select 0 as col_id, table_schema as col_schema, table_name as col_table,"
                     cTpyQuery += "column_name as col_name, column_name as col_description, "
                     cTpyQuery += "false as col_editable, false as col_reference, '' as col_ref_scriptname, "
                     cTpyQuery += "'' as col_ref_table, '' as col_ref_link, '' as col_ref_descriptor, "
                     cTpyQuery += "'X' as col_picture, true as col_viewable, true as col_navigable, "
                     cTpyQuery += "'' as col_default, '' as col_order, '' as col_container, '' as col_valid "
                     cTpyQuery += "from information_schema.columns "
                     cTpyQuery += "where "
                     cTpyQuery += STRTRAN(cFldWhere,"information_schema.tables.table_schema",;
                                                    "information_schema.columns.table_schema")
                     cTpyQuery := STRTRAN(cTpyQuery,"information_schema.tables.table_name",;
                                                    "information_schema.columns.table_name")
                     cTpyQuery := STRTRAN(cTpyQuery," col_name ="," information_schema.columns.column_name =")


                     ::aTpyStruct := ::oConn:Query( cTpyQuery, .f., , cSchema ):aData
                  endif
#include "base_columns.ch"
                  FOR EACH aLine IN ::aTpyStruct
                     if ::IsDef( aLine[COL_NAME] )
                        xTemp := ::Get( aLine[COL_NAME] )
                        xTemp:id                := aLine[COL_ID]
                        xTemp:schema            := aLine[COL_SCHEMA]
                        xTemp:table             := aLine[COL_TABLE]
                        xTemp:name              := aLine[COL_NAME]
                        xTemp:description       := aLine[COL_DESCRIPTION]
                        xTemp:editable          := aLine[COL_EDITABLE]
                        xTemp:reference         := aLine[COL_REFERENCE]
                        xTemp:ref_scriptname    := aLine[COL_REF_SCRIPTNAME]
                        xTemp:ref_table         := aLine[COL_REF_TABLE]
                        xTemp:ref_link          := aLine[COL_REF_LINK]
                        xTemp:ref_descriptor    := aLine[COL_REF_DESCRIPTOR]
                        xTemp:picture           := aLine[COL_PICTURE]
                        xTemp:viewable          := aLine[COL_VIEWABLE]
                        xTemp:navigable         := aLine[COL_NAVIGABLE]
                        xTemp:default           := aLine[COL_DEFAULT]
                        xTemp:order             := aLine[COL_ORDER]
                        xTemp:container         := aLine[COL_CONTAINER]
                        xTemp:valid             := aLine[COL_VALID]
                     endif
            //? "[["+aLine[3]+"]] ",hb_valtoexp( xtemp ) + hb_eol()
                  NEXT
               endif
            endif
            //xTemp := NIL
#endif

            
            ::nFields  := PQfcount(res)
            ::nLastrec := PQlastrec(res)
            ::nRows    := PQnTuples(res)

            ::aData    := ARRAY(::nRows,::nFields)
            ::aSData    := ARRAY(::nRows,::nFields)

            for i := 1 to ::nRows
               //aRow := ARRAY( ::nFields )
               //aOld := ARRAY( ::nFields )
               For nCol := 1 to ::nFields               
                   //::aData[ i, nCol ]  := CStr(PQGetValue(res, i, nCol))
                   if PQGetValue( res, i, nCol ) = NIL
                      ::aData[ i, nCol ]  := ""
                   else
                      ::aData[ i, nCol ]  := CStr(PQGetValue(res, i, nCol))
                   endif
                   ::aSData[ i, nCol ] := ::aData[i,nCol] 
                   If aStruct[nCol,2]=="L"
                      If ::aData[i,nCol]=="t"
                         ::aData[i,nCol]:=.t.
                      Else
                         ::aData[i,nCol]:=.f.
                      EndIf
                   EndIf                   
               Next
            next i
//? procname()
//? hb_valtoexp( ::aData )
            if ::nLastrec <> 0
                ::nRecno := 1
            endif                
                
            ::aStruct := aStruct        
        endif
    
        ::lError := .F.
        ::cError := ''    
        If !Empty(::aData)
           For i := 1 to ::nFields
              HSet( ::hData, ::aStruct[i,1], ::aData[::nRecno,i] )
           Next
        EndIf
    
    elseif PQresultstatus(res) == PGRES_COMMAND_OK
        ::lError := .F.
        ::cError := ''    
        ::rows   := val(PQcmdTuples(res))
        ::nRows  := PQnTuples(res)
        ::nTime  := nTime
        
    else
        ::lError := .T.
        ::cError := PQresultErrormessage(res)               
        return .f.
    endif            
    
    ::pQuery := res

RETURN ! ::lError
    
    
METHOD Struct() CLASS TPQquery
    Local aResult 
    Local i, nLen

    nLen := Len( ::aStruct ) 
#ifdef __TPUY__
    aResult := ARRAY( 2 )
    aResult[2] := ARRAY( nLen )

    FOR EACH i IN ::aStruct
       
       if ::IsDef( i[1] )
          aResult[1] := ::Get( i[1] )
          aResult[ 2, i:__EnumIndex() ] := {     ;
          aResult[1]:id                   ,;
          aResult[1]:name                 ,;
          aResult[1]:Type                 ,;
          aResult[1]:Size                 ,;
          aResult[1]:Dec                  ,;
          aResult[1]:PgType               ,;
          aResult[1]:ColPos               ,;
          aResult[1]:GtkType              ,;
          aResult[1]:schema               ,;
          aResult[1]:table                ,;
          aResult[1]:description          ,;
          aResult[1]:editable             ,;
          aResult[1]:reference            ,;
          aResult[1]:ref_scriptname       ,;
          aResult[1]:ref_table            ,;
          aResult[1]:ref_link             ,;
          aResult[1]:ref_descriptor       ,;
          aResult[1]:ref_picture          ,;
          aResult[1]:ref_viewable         ,;
          aResult[1]:ref_navigable        ,;
          aResult[1]:ref_default          ,;
          aResult[1]:ref_order            ,; 
          aResult[1]:container            ,; 
          aResult[1]:valid               }  
       else
          aResult[2, i:__EnumIndex()] := ARRAY( 21 ) 
       endif
    NEXT
    aResult := aResult[2]
#else
    aResult := ARRAY( nLen )
    For i := 1 to nLen
        aResult[i] := { ::aStruct[i, 1], ::aStruct[i, 2], ::aStruct[i, 3], ::aStruct[i, 4] }
    Next    

#endif
RETURN aResult


METHOD Skip( nrecno ) CLASS TPQquery
    Local i
    DEFAULT nRecno TO 1

    if ::nRecNo >= ::nRows 
       ::lEof := .T.
    endif
    
    if ::nRecno + nRecno > 0 .and. ::nRecno + nRecno <= ::nLastrec
        ::nRecno := ::nRecno + nRecno
        ::lEof := .F.
        ::lBof := .F.
    
    else            
        if ::nRecno + nRecno > ::nLastRec
            ::nRecno := ::nLastRec + 1
            ::lEof := .T.        
        end
    
        if ::nRecno + nRecno < 0
            ::nRecno := 1
            ::lBof := .T.
        end
    end        

    If !::lEof
       ::RefreshIter()
/*
       For i := 1 to ::nFields
          HSet( ::hData, ::aStruct[i,1], ::aData[::nRecno,i] )
       Next
*/
    EndIf

RETURN .T.


METHOD RefreshIter() CLASS TPQQuery
   Local hData := Hash(), hCol
   Local xData
   FOR EACH hCol IN ::aStruct
      xData := ::aData[ ::nRecno, hCol:__EnumIndex() ]  
      HSet( hData, hCol[1], xData )
      ::Get( hCol[1] )["value"] := xData
   NEXT
   ::hData := hData
RETURN .t.


METHOD Goto( nRecno ) CLASS TPQquery    
   Local i
    if nRecno > 0 .and. nRecno <= ::nLastrec
        ::nRecno := nRecno
        ::RefreshIter()
/*
        For i := 1 to ::nFields
           HSet( ::hData, ::aStruct[i,1], ::aData[::nRecno,i] )
        Next
*/
        ::lEof := .F.
    end
RETURN .T.    
    
    
METHOD FieldPos( cField ) CLASS TPQquery
    if PQresultstatus(::pQuery) == PGRES_TUPLES_OK     
       If ::IsDef( cField ) 
           return ::cField["colpos"]
       EndIf
    end        
RETURN 0
    

METHOD FieldName( nField ) CLASS TPQquery
    Local result

    if ISCHARACTER(nField)
        nField := ::Fieldpos(nField)
    endif
        
    if PQresultstatus(::pQuery) == PGRES_TUPLES_OK .and. nField >= 1 .and. nField <= len(::aStruct)
        result := ::aStruct[nField, 1]    
    endif    
RETURN result


METHOD FieldType( nField ) CLASS TPQquery
    Local result
    
    if ISCHARACTER(nField)
        nField := ::Fieldpos(nField)
    endif

    if PQresultstatus(::pQuery) == PGRES_TUPLES_OK .and. nField >= 1 .and. nField <= len(::aStruct)
        result := ::aStruct[nField, 2]    
    end    
RETURN result


METHOD FieldLen( nField ) CLASS TPQquery
    Local result
    
    if ISCHARACTER(nField)
        nField := ::Fieldpos(nField)
    endif

    if PQresultstatus(::pQuery) == PGRES_TUPLES_OK .and. nField >= 1 .and. nField <= len(::aStruct)
        result := ::aStruct[nField, 3]    
    end
RETURN result


METHOD FieldDec( nField ) CLASS TPQquery
    Local result

    if ISCHARACTER(nField)
        nField := ::Fieldpos(nField)
    endif
    
    if PQresultstatus(::pQuery) == PGRES_TUPLES_OK .and. nField >= 1 .and. nField <= len(::aStruct)
        result := ::aStruct[nField, 4]    
    end
RETURN result


METHOD Delete(oRow) CLASS TPQquery
    Local res
    Local i
    Local nField
    Local xField
    Local cWhere := ''
    Local aParams := {}
    
    ::SetKey()
    
    if ! Empty(::Tablename) .and. ! Empty(::aKeys)
        For i := 1 to len(::aKeys)
            nField := oRow:Fieldpos(::aKeys[i])
            xField := oRow:FieldGetOld(nField)

            cWhere += ::aKeys[i] + ' = $' + ltrim(str(i))
            
            AADD( aParams, ValueToString(xField) )

            if i <> len(::aKeys)
                cWhere += ' and '
            endif
        Next                        

        if ! (cWhere == '')
            res := PQexecParams( ::pDB, 'DELETE FROM ' + ::Schema + '.' + ;
                                 ::Tablename + ' WHERE ' + cWhere, aParams)    

            if PQresultstatus(res) != PGRES_COMMAND_OK            
                ::lError := .T.
                ::cError := PQresultErrormessage(res)       
                ::rows   := 0
            else             
                ::lError := .F.
                ::cError := ''
                ::rows   := val(PQcmdTuples(res))
            endif                
            PQclear(res)
        end            
    else
        ::lError := .T.
        ::cError := 'There is no primary keys or query is a joined table'        
    endif
RETURN ! ::lError


METHOD Append( oRow ) CLASS TPQquery
    Local cQuery
    Local i
    Local res
    Local lChanged := .f.
    Local aParams := {}
    Local nParams := 0

    ::SetKey()
    
    if ! Empty(::Tablename)
        cQuery := 'INSERT INTO ' + ::Schema + '.' + ::Tablename + '('
        For i := 1 to oRow:FCount()
            if ::lallCols .or. oRow:changed(i)
                lChanged := .t.
                cQuery += oRow:Fieldname(i) + ','
            endif                
        Next

        cQuery := Left( cQuery, len(cQuery) - 1 ) +  ') VALUES ('

        For i := 1 to oRow:FCount()
            if ::lallCols .or. oRow:Changed(i)
                nParams++
                cQuery += '$' + ltrim(str(nParams)) + ','
                aadd( aParams, ValueToString(oRow:FieldGet(i)) )
            endif                
        Next
        
        cQuery := Left( cQuery, len(cQuery) - 1  ) + ')'
    
        if lChanged
            res := PQexecParams( ::pDB, cQuery, aParams)    

            if PQresultstatus(res) != PGRES_COMMAND_OK            
                ::lError := .T.
                ::cError := PQresultErrormessage(res)       
                ::rows   := 0
            else             
                ::lError := .F.
                ::cError := ''
                ::rows   := val(PQcmdTuples(res))
            endif                

            PQclear(res)
        endif            
    else
        ::lError := .T.
        ::cError := 'Cannot insert in a joined table, or unknown error'                
    endif
RETURN ! ::lError


METHOD Update(oRow) CLASS TPQquery
    //Local result := .F.
    Local cQuery
    Local i
    Local nField
    Local xField
    Local cWhere
    Local res
    Local lChanged := .f.
    Local aParams := {}
    Local nParams := 0

    ::SetKey()

    if ! Empty(::Tablename) .and. ! Empty(::aKeys)
        cWhere := ''
        For i := 1 to len(::aKeys)
    
            nField := oRow:Fieldpos(::aKeys[i])            
            xField := oRow:FieldGetOld(nField)
            
            cWhere += ::aKeys[i] + '=' + DataToSql(xField)
                
            if i <> len(::aKeys)
                cWhere += ' and '
            end
        Next                        
                
        cQuery := 'UPDATE ' + ::Schema + '.' + ::Tablename + ' SET '
        For i := 1 to oRow:FCount()
            if ::lallcols .or. oRow:Changed(i)
                lChanged := .t.
                nParams++
                cQuery += oRow:Fieldname(i) + ' = $' + ltrim(str(nParams)) + ','
                aadd( aParams, ValueToString(oRow:FieldGet(i)) )
            end                
        Next
        
        if ! (cWhere == '') .and. lChanged

            cQuery := Left( cQuery, len(cQuery) - 1 ) + ' WHERE ' + cWhere                        
            
            res := PQexecParams( ::pDB, cQuery, aParams)    

            if PQresultstatus(res) != PGRES_COMMAND_OK            
                ::lError := .T.
                ::cError := PQresultErrormessage(res)       
                ::rows   := 0
            else             
                ::lError := .F.
                ::cError := ''
                ::rows   := val(PQcmdTuples(res))
            endif                

            PQclear(res)
        end            
    else        
        ::lError := .T.
        ::cError := 'Cannot insert in a joined table, or unknown error'                
    endif
RETURN ! ::lError


METHOD FieldGet( nField, nRow ) CLASS TPQquery
    Local result
    Local cType
    Local nSize
    Local tmp
    Local cDateFmt

    if ISCHARACTER(nField)
        nField := ::Fieldpos(nField)
    endif
                    
    if nField >= 1 .and. nField <= ::nFields .and. ! ::lclosed ;
                   .and. PQresultstatus(::pQuery) == PGRES_TUPLES_OK
        
        if ISNIL(nRow)
            nRow := ::nRecno
        endif
                    
        result := PQgetvalue( ::pQuery, nRow, nField)
        cType := ::aStruct[ nField, 2 ]
        nSize := ::aStruct[ nField, 3 ]
                                    
        if cType == "N"
            if ! ISNIL(result)
                result := val(result)
            else
                result := 0
            end
        
        elseif cType == "D"
            if ! ISNIL(result)
                tmp := 'yyyy-mm-dd'   
                tmp := strtran( tmp, 'dd', substr(result, 9, 2) )
                tmp := strtran( tmp, 'mm', substr(result, 6, 2) )
                tmp := strtran( tmp, 'yyyy', left(result, 4) )

                cDateFmt := Set(_SET_DATEFORMAT, 'yyyy-mm-dd')
                result := CtoD(tmp)
                Set(_SET_DATEFORMAT, cDateFmt)
            else
                result := CtoD('')
            end
            
        elseif cType == "L"
            if ! ISNIL(result)
                result := (result == 't')
            else
                result := .F.
            end
            
        elseif cType == "C"
            if Empty(nSize)
                nSize := PQgetLength(::pQuery, nRow, nField)
            endif
                            
            if ISNIL(result)
                result := Space(nSize)
            else
                result := PadR(result, nSize)                
            end
                        
        elseif cType == "M"
            if ISNIL(result)
                result := ""
            else
                result := result
            end
                        
        end
    end                    
RETURN result


METHOD GetRow( nRow ) CLASS TPQquery
    Local result, aRow := {}, aOld := {}, nCol
    
    DEFAULT nRow TO ::nRecno

    if ! ::lclosed .and. PQresultstatus(::pQuery) == PGRES_TUPLES_OK
        
        if nRow > 0 .and. nRow <= ::nLastRec

            ASize(aRow, ::nFields)
            ASize(aOld, ::nFields)

            For nCol := 1 to ::nFields
                aRow[nCol] := ::Fieldget(nCol, nRow)    
                aOld[nCol] := ::Fieldget(nCol, nRow)                    
            Next

            result := TPQRow():New( aRow, aOld, ::aStruct )
            
        elseif nRow > ::nLastrec        
            result := ::GetBlankRow()
        end        
    end            
RETURN result


METHOD GetBlankRow() CLASS TPQquery
    Local result, aRow := {}, aOld := {}, i
    
    ASize(aRow, ::nFields)
    ASize(aOld, ::nFields)
    
    For i := 1 to ::nFields
        if ::aStruct[i, 2] == 'C'
            aRow[i] := ''
            aOld[i] := ''
        elseif ::aStruct[i, 2] == 'N'
            aRow[i] := 0
            aOld[i] := 0
        elseif ::aStruct[i, 2] == 'L'
            aRow[i] := .F.
            aOld[i] := .F.
        elseif ::aStruct[i, 2] == 'D'
            aRow[i] := CtoD('')

        elseif ::aStruct[i, 2] == 'M'
            aRow[i] := ''
            aOld[i] := ''
        end                                
    Next
    
    result := TPQRow():New( aRow, aOld, ::aStruct )
RETURN result

/*
METHOD GetHField() CLASS TPQQUERY
   local result := Hash()
   local aData
   local oCol
   FOR EACH aData IN ::aTpyStruct
      oCol := ::Get(aData[3])
      HSet( result, aData[3], {  ;
                              } )
   NEXT
   
RETURN result
*/
METHOD GetField( cField ) CLASS TPQquery
   Local result
   result := Eval( ::bValue, cField )
/*
   IF HHAsKey( ::hData, cField )
      result := HGet( ::hData, cField )    
   ENDIF
*/
RETURN result

METHOD FieldProperty(cField, cProperty)
   local result 
   local Field

   cProperty := Upper(cProperty)
//? "buscando ", cField, ". Propiedad ",cProperty
//? "existe el campo? ", ::IsDef(cField)

   if ::IsDef(cField)
      Field := ::Get(cField)
      if hb_HHasKey(Field, cProperty)
//? ValType(Field)
//? hb_valtoexp(Field)
         result := Field[Upper(cProperty)]
      endif
   endif
RETURN result


/*
 * -- Este metodo no funciona... lo dejo por si realmente lo necesito. RIGC
 */
METHOD GetTables( aItems ) CLASS TPQquery

   Local n
   Local cQuery
   Local oQuery
   
//   Local res,aData,nFields,nLastrec,nRows,nCol,lError,cError
  
      cQuery := "SELECT table_name "
      cQuery += " FROM information_schema.columns "
      cQuery += " WHERE table_schema = " + DataToSql(::oConn:Schema)

      For n=1 to Len( aItems )

         If n=1 ; cQuery += " and "  ; Else ; cQuery += " or "; EndIf
         cQuery +=       " column_name = " + DataToSql(lower(aItems[n]))
      
      Next n
      
      cQuery += " and is_updatable = 'YES' "
      cQuery += " GROUP BY table_name "

      //View(cQuery)
      
      oQuery := ::Query( cQuery )
      
      /*
            res := PQexecParams( ::pDB, cQuery, aParams)    

            nFields  := PQfcount(res)
            nLastrec := PQlastrec(res)
            nRows    := PQnTuples(res)

            aData    := ARRAY(nRows,nFields)

            for n := 1 to nRows
//               aRow := ARRAY( nFields )
//               aOld := ARRAY( nFields )
               For nCol := 1 to nFields
                   aData[ n, nCol ] := CStr(PQGetValue(res, n, nCol))
               Next
            next n

        endif
    
        lError := .F.
        cError := ''    
    
        if PQresultstatus(res) != PGRES_COMMAND_OK            
            lError := .T.
            cError := PQresultErrormessage(res)       
        endif                

        PQclear(res)  

       */   
       
RETURN oQuery



METHOD SetKey() CLASS TPQquery
    Local cQuery
    Local i, x
    Local nTableId, xTableId := -1
    Local nCount := 0
    Local res
    Local nPos

    if PQresultstatus(::pQuery) == PGRES_TUPLES_OK         
        if ISNIL(::Tablename)
            /* set the table name looking for table oid */
            for i := 1 to len(::aStruct)
                /* Store table codes oid */
                nTableId := ::aStruct[i, 5]
                
                if nTableId != xTableId
                    xTableId := nTableId
                    nCount++
                endif                
            next
            
            if nCount == 1            
                /* first, try get the table name from select, else get from pg_catalog */
                if (npos := at('FROM ', Upper(::cQuery))) != 0
                    cQuery := lower(ltrim(substr( ::cQuery, nPos + 5 )))
                    
                    if (npos := at('.', cQuery)) != 0
                        ::Schema := alltrim(left(cQuery,npos-1))
                        cQuery := substr(cQuery, nPos + 1)
                    endif
                                            
                    if (npos := at(' ', cQuery)) != 0
                        ::Tablename := trim(Left(cQuery, npos))
                    else
                        ::Tablename := cQuery                                            
                    endif                
                endif
                
                if empty(::Tablename)
                    cQuery := 'select relname from pg_class where oid = ' + str(xTableId)

                    res := PQexec(::pDB, cQuery)
            
                    if PQresultstatus(res) == PGRES_TUPLES_OK .and. PQlastrec(res) != 0
                        ::Tablename := trim(PQgetvalue(res, 1, 1))
                    endif        
                
                    PQclear(res)
                endif                    
            endif            
        endif
        
        if ISNIL(::aKeys) .and. ! empty(::Tablename)
            /* Set the table primary keys */        
            cQuery := "SELECT c.attname "
            cQuery += "  FROM pg_class a, pg_class b, pg_attribute c, pg_index d, pg_namespace e "
            cQuery += " WHERE a.oid = d.indrelid "
            cQuery += "   AND a.relname = '" + ::Tablename + "'"
            cQuery += "   AND b.oid = d.indexrelid "
            cQuery += "   AND c.attrelid = b.oid "
            cQuery += "   AND d.indisprimary "
            cQuery += "   AND e.oid = a.relnamespace "
            cQuery += "   AND e.nspname = " + DataToSql(::Schema)
        
            res := PQexec(::pDB, cQuery)

            if PQresultstatus(res) == PGRES_TUPLES_OK .and. PQlastrec(res) != 0
                ::aKeys := {}
                
                For x := 1 To PQlastrec(res)
                    aadd( ::aKeys, PQgetvalue( res, x, 1 ) )
                Next                          
            endif   
                        
            PQclear(res)
        endif
    endif    
    
RETURN nil


/**
 *  OnError()
 */
METHOD OnError( uValue ) CLASS TPQQuery

  Local cMsg   := lower(ALLTRIM(__GetMessage()))
  Local cMsg2  := Subs(cMsg,2)

  If ::IsDef( cMsg )
     If PCount() = 1 
        Return ::FieldGet( cMsg )[ UPPER(hb_PValue(1)) ]
     EndIf
     Return  Eval( ::bValue, cMsg )  //::Get( cMsg ):Value
  EndIf

RETURN uValue





/**
 *  Clase TPQRow
 *
 */

CLASS TPQRow
   DATA     aRow
   DATA     aOld
   DATA     aStruct
   
   METHOD   New( row, old, struct )

   METHOD   FCount()           INLINE Len(::aRow)
   METHOD   FieldGet( nField )
   METHOD   FieldPut( nField, Value )  
   METHOD   FieldName( nField )
   METHOD   FieldPos( cFieldName )
   METHOD   FieldLen( nField )             
   METHOD   FieldDec( nField )             
   METHOD   FieldType( nField )
   METHOD   Changed( nField )     INLINE ! (::aRow[nField] == ::aOld[nField])              
   METHOD   FieldGetOld( nField ) INLINE ::aOld[nField]
ENDCLASS


METHOD new( row, old, struct) CLASS TPQrow
    ::aRow := row
    ::aOld := old
    ::aStruct := struct            
RETURN self


METHOD FieldGet( nField ) CLASS TPQrow
    Local result

    if ISCHARACTER(nField)
        nField := ::Fieldpos(nField)
    endif
    
    if nField >= 1 .and. nField <= len(::aRow)
        result := ::aRow[nField]    
    end
    
RETURN result


METHOD FieldPut( nField, Value ) CLASS TPQrow
    Local result
    
    if ISCHARACTER(nField)
        nField := ::Fieldpos(nField)
    endif

    if nField >= 1 .and. nField <= len(::aRow)
        result := ::aRow[nField] := Value
    end
RETURN result


METHOD FieldName( nField ) CLASS TPQrow
    Local result

    if ISCHARACTER(nField)
        nField := ::Fieldpos(nField)
    endif
    
    if nField >= 1 .and. nField <= len(::aStruct)
        result := ::aStruct[nField, 1]    
    end
    
RETURN result


METHOD FieldPos( cFieldName ) CLASS TPQrow
    Local result 
    
    result := AScan( ::aStruct, {|x| x[1] == trim(lower(cFieldName)) })

RETURN result
    

METHOD FieldType( nField ) CLASS TPQrow
    Local result

    if ISCHARACTER(nField)
        nField := ::Fieldpos(nField)
    endif
    
    if nField >= 1 .and. nField <= len(::aStruct)
        result := ::aStruct[nField, 2]    
    end
    
RETURN result


METHOD FieldLen( nField ) CLASS TPQrow
    Local result

    if ISCHARACTER(nField)
        nField := ::Fieldpos(nField)
    endif
    
    if nField >= 1 .and. nField <= len(::aStruct)
        result := ::aStruct[nField, 3]    
    end
RETURN result


METHOD FieldDec( nField ) CLASS TPQrow
    Local result

    if ISCHARACTER(nField)
        nField := ::Fieldpos(nField)
    endif
    
    if nField >= 1 .and. nField <= len(::aStruct)
        result := ::aStruct[nField, 4]    
    end
RETURN result


Function DataToSql(xField)
        Local cType, result := 'NULL'

        cType := ValType(xField)
        
        if cType == "C" .or. cType == "M"
                if !Empty(xField)
                   //result := "'"+ strtran(xField, "'", "''") + "'"
                   result := "$$"+ xField + "$$"
                end
           If xField == 'NIL'
              result := 'NULL'
           EndIf
           
        elseif cType == "D" .and. ! Empty(xField)
                result := "'" + StrZero(month(xField),2) + '/'
                result +=       StrZero( day(xField),2 ) + '/'
                result +=       StrZero( Year(xField),4) + "'"
        elseif cType == "N"
                result := str(xField)
        elseif cType == "L"
                result := iif( xField, "'t'", "'f'" )
        end      
        
//        if cType == "C" .and. xField = 'NIL'
//           result := 'NULL'
//        endif
return result           


Static Function ValueToString(xField)
        Local cType, result := nil

        cType := ValType(xField)
        
        if cType == "D" .and. ! Empty(xField)
                result := StrZero(month(xField),2) + '/'
                result += StrZero( day(xField),2 ) + '/'
                result += StrZero( Year(xField),4)
        elseif cType == "N"
                result := str(xField)
        elseif cType == "L"
                result := iif( xField, "t", "f" )
        elseif cType == "C" .or. cType == "M"
                result := xField                                
        end        
return result           

//eof
