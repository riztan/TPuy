/*
	Copyright © 2012  Riztan Gutierrez <riztang@gmail.com>

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


#ifdef __PLATFORM__WINDOWS


FUNCTION WAITRUN( cRun )
   local hIn, hOut, nRet, hProc
   // "Launching process", cProc
   hProc := HB_OpenProcess( cRun , @hIn, @hOut, @hOut )

   // "Reading output"

   // "Waiting for process termination"
   nRet := HB_ProcessValue( hProc )

   FClose( hProc )
   FClose( hIn )
   FClose( hOut )

   Return nRet


#pragma BEGINDUMP

#include <windows.h>
#include "hbapi.h"
#include "hbapiitm.h"
#include <shellapi.h>
#include <string.h>

HB_FUNC( SHELLEXECUTE )
{
 hb_retni(( int )
 ShellExecute( 0 , 0 , (LPCTSTR)hb_parc(1),
                       (LPCTSTR)hb_parc(2),
                       NULL,
                       hb_parni(3)));
}

#pragma ENDDUMP
#endif

//EOF
