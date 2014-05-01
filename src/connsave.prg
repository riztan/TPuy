/* $Id: connsave.prg,v 1.0 2011/10/22 23:03:21 riztan Exp $*/
/*
        Copyright © 2011  Riztan Gutierrez <riztang@gmail.com>

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


#include "gclass.ch"
#include "proandsys.ch"

memvar oTpuy

FUNCTION ConnSave( cFileIni )
   LOCAL cHead,cFoot,lRes

   DEFAULT cFileIni := "connect_test.ini"

   if Empty(oTpuy:hConnections)
      MsgAlert("No hay conexión Disponible")
      Return .F.
   endif

   cHead := ";"+CRLF
   cHead += "; Fichero autogenerado"+CRLF
   cHead += "; Parametros de Conexion"+CRLF
   cHead += ";"

   cFoot := CRLF+"; eof "+CRLF

   lRes := SaveIni( oTpuy:hConnections, cFileIni, cHead, cFoot )

   if lRes
      MsgInfo("Parametros de conexión guardados en "+CRLF+;
              "[<b>"+cFileIni+"</b>]",MESSAGE_INFO) 
   endif

RETURN lRes



//eof
