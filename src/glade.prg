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


//#include "hbclass.ch"
//#include "common.ch"

memvar  oTpuy


FUNCTION tpy_glade( cResFile, ... )

   Local uResm, rApp

   default cResFile to ""

   if !FILE( cResFile )

      if oTPuy:lNetIO

         // Intentamos obtener el fichero desde el servidor TPuy.
         rApp := oTPuy:rApp

         ~~rApp:GetResource( /*Obtener Nombre del fichero de Resurso*/ )

      else

         MsgStop( "No es posible localizar el fichero de recursos. " + cResFile )
      
      endif

   else

      if oTpuy:lNetIO
         /* Verificar si el recurso existe en el servidor, para registrar o actualizar */
         if ~IsDeveloper()
            if !~~rApp:ResourceExist( /* Obtener Nombre del archivo de recurso */ )
               /* debe preguntar al programador */
               if MsgNOYES( "¿Desea actualizar " )
                  /* Actualizar el recurso en el servidor */
               endif
            else
               /* Verificar si el fichero de recurso tiene diferencia con el del servidor*/
               if .f. // Si hay diferencia, preguntar si actualiza
                  if MsgNOYES( "¿Desea actualizar " )
                     /* Actualizar el recurso en el servidor */
                  endif
               endif
            endif
         endif
      endif

      uRes := glade_xml_new( cResFile, ... )

   endif
   

RETURN uRes

//eof
