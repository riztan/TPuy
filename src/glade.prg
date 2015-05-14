/*
 * $Id: 2015/05/08 11:35:43 glade.prg riztan $
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

/** \file glade.prg.
 *  \brief Sustituto para instruccion que hace lectura de fichero de recursos de glade.
 *  \author Riztan Gutierrez. riztan@gmail.com
 *  \date 2015
 *  \remark  
*/


#include "tepuy.ch"

memvar  oTpuy


FUNCTION tpy_glade( cResFile, ... )

   Local uRes, rApp
   Local cResName, cRes, cSep := "/"

   default cResFile to ""

   cResName := ExtName( cResFile )
   if oTPuy:lNetIO ;  rApp := oTPuy:rApp ; endif

   if !FILE( cResFile )

      if oTPuy:lNetIO

         if GetResource( cResName )
            return glade_xml_new( cResFile, ... )
         endif

      else

         MsgStop( "No es posible localizar el fichero de recursos. " + cResFile )
      
      endif

   else

      /* si existe conexion con el servidor y el usuario está identificado */
      if oTpuy:lNetIO .and. oTpuy:IsDef( "oUser" )
         /* Verificar si el recurso existe en el servidor, para registrar o actualizar */
         if ~oServer:IsDeveloper()
            if !( ~~rApp:ResourceExist( cResName ) )
               /* debe preguntar al programador */
               if MsgNOYES( "¿Desea actualizar el servidor? " )
                  /* Actualizar el recurso en el servidor */
                  ~~rApp:SetResource( cResName, MemoRead( cResFile ) )
               endif
            else
               /* Verificar si el fichero de recurso tiene diferencia con el del servidor*/
               if !(~~rApp:ResourceHash(cResName) == hb_MD5File( cResFile ) ) 
                  if MsgNOYES( "¿Desea actualizar el servidor?" )
                     /* Actualizar el recurso en el servidor */
                     ~~rApp:SetResource( cResName, MemoRead( cResFile ) )

                  elseif MsgNOYES( "¿Actualizar la copia local?" )
                     if GetResource( cResName )
                        return glade_xml_new( cResFile, ... )
                     endif
                  endif
               endif
            endif
         else
            if GetResource( cResName )
               return glade_xml_new( cResFile, ... )
            endif

         endif

      endif

      uRes := glade_xml_new( cResFile, ... )

   endif
   

RETURN uRes




/** Obtener archivo de recursos.
 */
Function GetResource( cResName )
   local lRes := .f.
   local rApp, cRes

   if oTpuy:lNetIO .and. !Empty(oTPuy:rApp)
      rApp := oTPuy:rApp
      if ~~rApp:ResourceExist( cResName )
         cRes := ~~rApp:GetResource( cResName )
         if !FILE( oTPuy:cResources + cResName )
            return hb_MemoWrit( oTPuy:cResources + cResName, cRes )
         else
            if !( cRes == MemoRead( oTpuy:cResources + cResName ) )
               return hb_MemoWrit( oTPuy:cResources + cResName, cRes )
            endif
         endif
      endif
   endif
Return lRes



//eof
