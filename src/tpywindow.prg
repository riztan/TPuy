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

   DATA cWndId
   DATA bValid

   METHOD NEW( Wnd, cTitle, nType, nWidth, nHeight, ;
               cId, uGlade, nTypeHint, cIconName, cIconFile, oParent )

   METHOD SetParent( oParent )    INLINE gtk_window_set_transient_for( ::pWidget, oParent:pWidget  )
   
   METHOD Activate()

ENDCLASS



METHOD NEW( cWndId, cTitle, nType, nWidth, nHeight, cId, uGlade, nTypeHint, cIconName, cIconFile, oParent )  CLASS TpyWindow

  local cIconDefault := oTpuy:cImages+oTpuy:cIconMain

  default cIconFile to cIconDefault

  if !oTPuy:IsDef( "oWndGestor" )
     oTPuy:Add( "oWndGestor", TPublic():New() )
  endif

  if oTPuy:owndGestor:IsDef( cWndId )
     oTPuy:oWndGestor:Get(cWndId):SetFocus()
     RETURN oTPuy:oWndGestor:Get( cWndId )
  endif

  if !File( cIconFile ) ; cIconFile := cIconDefault ; endif

  if File( cIconFile )
     ::Super:New( cTitle, nType, nWidth, nHeight, cId, uGlade, nTypeHint, , cIconFile, oParent )
  else
     ::Super:New( cTitle, nType, nWidth, nHeight, cId, uGlade, nTypeHint, cIconName, , oParent )
  endif

  oTPuy:oWndGestor:Add( cWndId, self )
  ::cWndId := cWndId

RETURN self




METHOD Activate( bValid, lCenter, lMaximize, lModal, lInitiate ) CLASS TpyWindow

   local bEnd

   if !hb_IsBlock( bValid )
      bEnd := {|| oTPuy:oWndGestor:Del(::cWndId), ;
                  .t. }
   else
      ::bValid := bValid
      bEnd := {|| oTPuy:oWndGestor:Del(::cWndId), ;
                  EVAL( ::bValid ) }
   endif

   ::Super:Activate( bEnd, lCenter, lMaximize, lModal, lInitiate )

RETURN


//eof
