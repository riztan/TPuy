/*
 * $Id: 2015/05/08 11:35:43 tpy_image.prg riztan $
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

/** \file tpy_image.prg.
 *  \brief clase tpy_image de t-gtk con modificaciones para TPuy.
 *  \author Riztan Gutierrez. riztan@gmail.com
 *  \date 2015
 *  \remark  
*/


#include "tepuy.ch"
#include "hbclass.ch"

memvar  oTpuy


CLASS TPY_IMAGE FROM GIMAGE

   METHOD NEW( cImage , oParent, lExpand, lFill, nPadding , lContainer, x, y, cId, uGlade ,;
            uLabelTab, nWidth, nHeight, lEnd, lSecond, lResize, lShrink,;
            left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta, nHor, nVer,;
            cFromStock, nIcon_Size, lLoad, lBuffer  )

   METHOD SetFile( cImage )

ENDCLASS


METHOD NEW( cImage , oParent, lExpand, lFill, nPadding , lContainer, x, y, cId, uGlade ,;
            uLabelTab, nWidth, nHeight, lEnd, lSecond, lResize, lShrink,;
            left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta, nHor, nVer,;
            cFromStock, nIcon_Size, lLoad, lBuffer ) CLASS TPY_IMAGE

   ::Super:New( cImage , oParent, lExpand, lFill, nPadding , lContainer, x, y, cId, uGlade ,;
            uLabelTab, nWidth, nHeight, lEnd, lSecond, lResize, lShrink,;
            left_ta, right_ta, top_ta, bottom_ta, xOptions_ta, yOptions_ta, nHor, nVer,;
            cFromStock, nIcon_Size, lLoad, lBuffer )

RETURN Self



METHOD SetFile( cImage ) CLASS TPY_IMAGE

   local rApp := oTPuy:rApp
   local cImgName

   default cImage := ""

   if !Empty(cImage)

      if !FILE( cImage ) 

         if !( "/" $ cImage ) ; cImage := oTPuy:cImages + cImage ; endif

      endif

      cImgName := ExtName( cImage )

      if !FILE( cImage )

         if oTPuy:lNetIO .and. !Empty(rApp)
            if !GetImage( cImgName )
               MsgStop( 'No es posible obtener la imagen "'+ cImgName +'" desde el servidor.', ~~rApp:cAppName )
               return nil
            endif
 
         else

//            MsgStop( "No es posible localizar el archivo " + cImgName )
            return nil
      
         endif

      else
      
         if oTPuy:lNetIO .and. !Empty(rApp)

            if ~oServer:IsDeveloper()
               if !( ~~rApp:ImageExist( cImgName ) )
                  /* debe preguntar al programador */
                  if MsgNOYES( "¿Desea actualizar el servidor con la imagen "+cImgName+"? " )
                     /* Actualizar la imagen en el servidor */
                     ~~rApp:SetImage( cImgName, MemoRead( cImage ) )
                  endif
               else
                  /* Verificar si la imagen tiene diferencia con la del servidor*/
                  if !(~~rApp:ImageHash(cImgName) == hb_MD5File( cImage ) ) 
                     if MsgNOYES( "¿Desea actualizar la imagen "+cImgName+" en el servidor?" )
                        /* Actualizar la imagen en el servidor */
                        ~~rApp:SetImage( cImgName, MemoRead( cImage ) )

                     elseif MsgNOYES( "¿Actualizar la copia local de la imagen "+cImgName+"?" )
                        if !GetImage( cImgName )
                           MsgStop( "No ha sido posible obtener la imagen desde el servidor.", ~~rApp:cAppName )
                           return nil
                        endif
                     endif
                  endif
               endif
            else
               if !GetImage( cImgName )
                  MsgStop('No es posible obtener la imagen "'+ cImgName +'" desde el servidor.', ~~rApp:cAppName )
                  return nil
               endif

            endif

         endif

      endif
   
      ::Super:SetFile( cImage )
   
   endif

Return nil




/** Funcion para obtener una imagen desde un servidor TPuy.
 *  cImgName:  Nombre de la imagen a solicitar. 
 *             Se debe incluir la extensión. (sin ruta).
 */
Function GetImage( cImgName )
   local lRes := .f.
   local rApp, cImg

   if oTpuy:lNetIO .and. !Empty(oTPuy:rApp)
      rApp := oTPuy:rApp
      if ~~rApp:ImageExist( cImgName )
         cImg := ~~rApp:GetImage( cImgName )
         if !FILE( oTPuy:cImages + cImgName )
            return hb_MemoWrit( oTPuy:cImages + cImgName, cImg )
         else
            if !( cImg == MemoRead( oTpuy:cImages + cImgName ) )
               return hb_MemoWrit( oTPuy:cImages + cImgName, cImg )
            else
               // imagenes identicas
               return .t.
            endif
         endif
      else
         // Si la imagen existe localmente, la usamos...
         if FILE( oTPuy:cImages+cImgName )
            return .t.
         endif
      endif
   endif
Return lRes


//eof
