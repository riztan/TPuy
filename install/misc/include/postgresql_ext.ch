/* $Id: postgresql_ext.ch,v 1.0 2017/04/28 21:58:22 riztan Exp $*/
/*
	Copyright © 2017  Riztan Gutierrez <riztang@gmail.com>

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


 EXTERNAL PQCONNECT
 EXTERNAL PQCONNECTDB //connectdb             
// EXTERNAL PQCONNDEFAULTS          
 EXTERNAL PQFINISH                
 EXTERNAL PQRESET                 
 EXTERNAL PQrequestCancel         
 EXTERNAL PQdb                    
 EXTERNAL PQuser                  
 EXTERNAL PQpass                  
 EXTERNAL PQhost                   
 EXTERNAL PQport                   
 EXTERNAL PQtty                    
 EXTERNAL PQoptions                
 EXTERNAL PQstatus                 
 EXTERNAL PQerrorMessage           
// EXTERNAL PQsocket                 
// EXTERNAL PQbackendPID             
 EXTERNAL PQtrace                  
 EXTERNAL PQuntrace                
// EXTERNAL PQsetNoticeProcessor     
 EXTERNAL PQexec                   
// EXTERNAL PQnotifies               
 EXTERNAL PQsendQuery              
 EXTERNAL PQgetResult              
 EXTERNAL PQisBusy                 
 EXTERNAL PQconsumeInput           
// EXTERNAL PQgetline                
// EXTERNAL PQputline                
// EXTERNAL PQgetlineAsync           
// EXTERNAL PQputnbytes              
// EXTERNAL PQendcopy                
// EXTERNAL PQfn                     
 EXTERNAL PQresultStatus           
 EXTERNAL PQntuples                
 EXTERNAL PQnfields                
 EXTERNAL PQbinaryTuples           
 EXTERNAL PQfname                  
 EXTERNAL PQfnumber                
 EXTERNAL PQftype                  
 EXTERNAL PQfsize                  
 EXTERNAL PQfmod                   
 EXTERNAL PQcmdStatus              
 EXTERNAL PQoidStatus              
 EXTERNAL PQcmdTuples              
 EXTERNAL PQgetvalue               
 EXTERNAL PQgetlength              
 EXTERNAL PQgetisnull              
// EXTERNAL PQclear                  
// EXTERNAL PQmakeEmptyPGresult      
// EXTERNAL PQprint                  
// EXTERNAL PQdisplayTuples          
// EXTERNAL PQprintTuples            
/*
 EXTERNAL lo_open                  
 EXTERNAL lo_close                 
 EXTERNAL lo_read                  
 EXTERNAL lo_write                 
 EXTERNAL lo_lseek                 
 EXTERNAL lo_creat                 
 EXTERNAL lo_tell                  
 EXTERNAL lo_unlink                
 EXTERNAL lo_import                
 EXTERNAL lo_export                
*/
// EXTERNAL pgresStatus              
// EXTERNAL PQmblen                  
 EXTERNAL PQresultErrorMessage     
 EXTERNAL PQresStatus              
// EXTERNAL termPQExpBuffer          
// EXTERNAL appendPQExpBufferChar    
// EXTERNAL initPQExpBuffer          
// EXTERNAL resetPQExpBuffer         
 EXTERNAL PQoidValue               
 EXTERNAL PQclientEncoding         
// EXTERNAL PQenv2encoding           
// EXTERNAL appendBinaryPQExpBuffer  
// EXTERNAL appendPQExpBufferStr     
// EXTERNAL destroyPQExpBuffer       
// EXTERNAL createPQExpBuffer        
// EXTERNAL PQconninfoFree           
// EXTERNAL PQconnectPoll            
// EXTERNAL PQconnectStart           
 EXTERNAL PQflush                  
 EXTERNAL PQisnonblocking          
// EXTERNAL PQresetPoll              
// EXTERNAL PQresetStart             
 EXTERNAL PQsetClientEncoding      
 EXTERNAL PQsetnonblocking         
// EXTERNAL PQfreeNotify             
 EXTERNAL PQescapeString           
 EXTERNAL PQescapeBytea            
// EXTERNAL printfPQExpBuffer        
// EXTERNAL appendPQExpBuffer        
 EXTERNAL pg_encoding_to_char      
// EXTERNAL pg_utf_mblen             
 EXTERNAL PQunescapeBytea          
// EXTERNAL PQfreemem                
 EXTERNAL PQtransactionStatus      
// EXTERNAL PQparameterStatus        
 EXTERNAL PQprotocolVersion        
 EXTERNAL PQsetErrorVerbosity      
// EXTERNAL PQsetNoticeReceiver       
 EXTERNAL PQexecParams              
// EXTERNAL PQsendQueryParams         
 EXTERNAL PQputCopyData             
 EXTERNAL PQputCopyEnd              
// EXTERNAL PQgetCopyData             
// EXTERNAL PQresultErrorField        
 EXTERNAL PQftable                  
// EXTERNAL PQftablecol               
// EXTERNAL PQfformat                 
 EXTERNAL PQexecPrepared            
// EXTERNAL PQsendQueryPrepared       
// EXTERNAL PQdsplen                  
 EXTERNAL PQserverVersion           
// EXTERNAL PQgetssl                  
// EXTERNAL pg_char_to_encoding       
// EXTERNAL pg_valid_server_encoding  
// EXTERNAL pqsignal                  
 EXTERNAL PQprepare                 
// EXTERNAL PQsendPrepare             
 EXTERNAL PQgetCancel               
// EXTERNAL PQfreeCancel              
 EXTERNAL PQcancel                  
// EXTERNAL lo_create                 
// EXTERNAL PQinitSSL                 
// EXTERNAL PQregisterThreadLock      
// EXTERNAL PQescapeStringConn        
 EXTERNAL PQescapeByteaConn         
// EXTERNAL PQencryptPassword         
// EXTERNAL PQisthreadsafe            
// EXTERNAL enlargePQExpBuffer        
// EXTERNAL PQnparams                 
// EXTERNAL PQparamtype               
// EXTERNAL PQdescribePrepared        
// EXTERNAL PQdescribePortal          
// EXTERNAL PQsendDescribePrepared    
// EXTERNAL PQsendDescribePortal      
// EXTERNAL lo_truncate               
// EXTERNAL PQconnectionUsedPassword  
// EXTERNAL pg_valid_server_encoding_id 
// EXTERNAL PQconnectionNeedsPassword 
// EXTERNAL lo_import_with_oid        
// EXTERNAL PQcopyResult              
// EXTERNAL PQsetResultAttrs          
// EXTERNAL PQsetvalue                
// EXTERNAL PQresultAlloc             
// EXTERNAL PQregisterEventProc       
// EXTERNAL PQinstanceData            
// EXTERNAL PQsetInstanceData         
// EXTERNAL PQresultInstanceData      
// EXTERNAL PQresultSetInstanceData   
// EXTERNAL PQfireResultCreateEvents  
// EXTERNAL PQconninfoParse           
// EXTERNAL PQinitOpenSSL             
// EXTERNAL PQescapeLiteral           
// EXTERNAL PQescapeIdentifier        
// EXTERNAL PQconnectdbParams         
// EXTERNAL PQconnectStartParams      

