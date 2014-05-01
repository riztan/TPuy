/*
	Copyright © 2008  Riztan Gutierrez <riztang@proandsys.org>

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

/** \file xml.prg.
 *  \brief Algunas rutinas y funciones utilizadas \c "xml.prg" 
 *  \author Riztan Gutierrez. riztan@gmail.com
 *  \date 2008
 *  \remark El contenido esta relacionado al manejo de archivos .xml y/o .ini "tools02.prg"
*/

#include "gclass.ch"
//#include "proandsys.ch"
#include "hbxml.ch"

// GLOBAL EXTERNAL oTpuy /** \var GLOBAL oTpuy. Objeto Principal oTpuy. */
memvar oTpuy

/** \brief lee un archivo login.xml 
 */
FUNCTION LoadLogin( cFile )

   LOCAL oXmlDoc := TXmlDocument():New()
   LOCAL oXmlNode
   
   If Empty( cFile )
      cFile := oTpuy:cTemps+"login.xml"
   EndIf

   If !File( cFile )
      Return NIL
   EndIf

   oXmlDoc:Read( MemoRead( cFile ) )

   oXmlNode := oXmlDoc:FindFirst("lastlogin")

RETURN oXmlNode


/** \brief guarda datos de login en un archivo login.xml
 */
FUNCTION MemoToXML()

   LOCAL nFileHandle
   LOCAL oXmlDoc, oXmlConnection, oXmlLogin
   LOCAL cPass := oTpuy:cPass
   
   IF oTpuy:cSavePass != "T"
      cPass := ""
   ENDIF

   oXmlDoc := TXmlDocument():new( '<?xml version="1.0"?>' )

   oXmlConnection := TXmlNode():new( , "conexion", { "nombre" => "postgresql" } )

   oXmlDoc:oRoot:AddBelow( oXmlConnection )
   
   oXmlLogin := TXmlNode():new( , "lastlogin", { ;
                                  "nombre"     => oTpuy:cSystem_Name ,;
                                  "host"       => oTpuy:cHost        ,;
                                  "port"       => Alltrim(CStr(oTpuy:nPort)) ,;
                                  "database"   => oTpuy:cDB          ,;
                                  "user"       => oTpuy:cUser        ,;
                                  "password"   => cPass               ,;
                                  "save_pass"  => oTpuy:cSavePass     ;
                                } )

   oXmlConnection:AddBelow( oXmlLogin )

   nFileHandle := FCreate( oTpuy:cTemps+"login.xml" )
   // write the XML tree
   oXmlDoc:write( nFileHandle, HBXML_STYLE_INDENT )
   // close files
   FClose( nFileHandle )

RETURN NIL


/** \brief lee un archivo .xml 
 */
FUNCTION LoadXML( cFile )

   LOCAL oXmlDoc := TXmlDocument():New()
//   LOCAL cFile := oTpuy:cTemps+"login.xml"

   If !File( cFile )
      // MsgStop(MSG_FILE_NO_EXIST+cFile)
      Return NIL
   EndIf

   oXmlDoc:Read( MemoRead( cFile ) )
   
//   oTpuy:oTmpXML := oXmlDoc

//   oXmlNode := oXmlDoc:FindFirst("lastlogin")

RETURN oXmlDoc


//EOF
