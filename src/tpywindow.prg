/*
 * $Id: 2015/01/12 23:51:14 tpywindow.prg riztan $
 */
/*
   Copyright © 2008-2015  Riztan Gutierrez <riztang@gmail.com>

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

/** \file tpywindow.prg.
 *  \brief Clase Pre-generadora de Ventana tipo t-gtk en TPuy
 *  \author Riztan Gutierrez. riztan@gmail.com
 *  \date 2015
 *  \remark  
*/


#include "hbclass.ch"
#include "common.ch"

memvar  oTpuy


CLASS TpyWindow FROM GWindow

   METHOD NEW( cTitle, nType, nWidth, nHeight, ;
               cId, uGlade, nTypeHint, cIconName, cIconFile, oParent )
   
ENDCLASS


METHOD NEW( cTitle, nType, nWidth, nHeight, cId, uGlade, nTypeHint, cIconName, cIconFile, oParent )  CLASS TpyWindow

  local cIconDefault := oTpuy:cImages+oTpuy:cIconMain

  default cIconFile to cIconDefault

  if !File( cIconFile ) ; cIconFile := cIconDefault ; endif

  if File( cIconFile )
     Super:New( cTitle, nType, nWidth, nHeight, cId, uGlade, nTypeHint, , cIconFile, oParent )
  else
     Super:New( cTitle, nType, nWidth, nHeight, cId, uGlade, nTypeHint, cIconName, , oParent )
  endif

RETURN self

//eof
