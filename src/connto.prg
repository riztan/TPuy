/*
 *
 * Copyright 2010 Daniel Garcia-Gil<danielgarciagil@gmail.com>
 * www - http://tdolphin.blogspot.com/
 *
 */

/* Modificaciones por Riztan Gutierrez - riztan (at) gmail (dot) com */

#include "gclass.ch"
#include "proandsys.ch"


FUNCTION ConnectTo( cNameConn, hIni )
   LOCAL hConn, pConn, cPQStatus
   LOCAL oServer   
   LOCAL cDBType,cServer, cUser, cPassword, nPort, cDBName,nFlags    
   LOCAL oErr

   DEFAULT cNameConn := "", hIni := HB_ReadIni( "connect.ini" )

   If HHasKey( hIni, cNameConn )
      hConn     := hIni[cNameConn]
   Else
      MsgStop( "Conexion "+cNameConn+". No existe " )
      Return NIL
   Endif

   oServer   := NIL
   cDBType   := hConn["dbtype"]
   cServer   := hConn["host"]
   cUser     := hConn["user"]
   cPassword := hConn["psw"]
   nPort     := val(hConn["port"])
   cDBName   := hConn["dbname"]
   nFlags    := val(hConn["flags"])

   If Upper(cDBType)=="MYSQL"
      TRY
      
         oServer := TDolphinSrv():New( cServer,   ;
                                       cUser,     ;
                                       cPassword, ;
                                       nPort,     ;
                                       nFlags,    ;
                                       cDBName )
                                
      CATCH oErr 
        RETURN NIL
      END

   ElseIf Left(Upper(cDBType),7)=="POSTGRE" 

      //pConn := PQsetdbLogin( cServer, nPort, NIL, NIL, cDBName, cUser, cPassword)
      //pConn := PQConnect(cDBName, cServer, cUser, cPassword, nPort )

      oServer := TPQserver():New( cServer, cDBName, cUser, cPassword, nPort )

      pConn := oServer:pDB

      If PQStatus(pConn) != CONNECTION_OK

         cPQStatus := Alltrim( STR( PQStatus(pConn) ) )

         MsgStop( "<b>"+MSG_STATUS_CONNECTION+":</b> "+cPQStatus+CRLF+;
                  "<b>Error:</b> "+( PQErrorMessage(pConn) ),;
                  MSG_ERROR_CONNECTION )

         Return NIL

/*
      Else
         MsgAlert( MSG_CONNECTED+"!" )
*/
      EndIf

   EndIf
   
RETURN oServer


//eof
