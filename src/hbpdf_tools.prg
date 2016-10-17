/* $Id: hbpdf_tools.prg,v 1.0 2016/10/17 16:24:02 riztan Exp $*/
/*
	Copyright © 2008  Riztan Gutierrez <riztang@gmail.com>

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

/** \file hbpdf_tools.prg.
 *  \brief Detalle del contenido de \c "hbpdf_tools.prg" 
 *  \author Riztan Gutierrez. riztan@gmail.com
 *  \date 2016
 *  \remark Comentarios sobre "hbpdf_tools.prg"
*/

#include "gclass.ch"
#include "proandsys.ch"

// GLOBAL EXTERNAL oTpuy /** \var GLOBAL oTpuy. Objeto Principal oTpuy. */
memvar oTpuy


/** \brief Presenta Mensaje mientras se ejecuta el bloque de codigo.
 *  \par cMensaje, variable tipo caracter.
 *  \par bAction, variable tipo Bloque de Codigo.
 *  \par cImagen,   Imagen a Mostrar.
 *  \par nWidth,    Ancho en pixel del dialogo.
 *  \par nHeight,   Altura en pixel del dialogo.
 *  \par MSGRUN_TYPE, tipo de MSGRUN_TYPE (mensaje a desplegar).
 *  \pre previos...
 *  \ret Verdadero
 */

      
/** \brief Apertura un archivo tipo PDF
 *         
 */
FUNCTION tpy_PDFOpen( cFilePDF )
  local uRes
  if empty( cFilePDF ) .or. !FILE( cFilePDF )
     MsgAlert("Archivo PDF No localizado.", "Atención")
     return nil 
  endif
#ifdef __PLATFORM__WINDOWS
      uRes := wapi_ShellExecute(0, 'open', cFilePDF, , 0, 0 )
#else
      uRes := winexec( "evince " + " " + cFilePDF )
#endif  
RETURN uRes



PROCEDURE DrawBarcode( page, nY, nLineWidth, cType, cCode, nFlags )

   LOCAL hZebra, nLineHeight, cTxt

   nY := HPDF_Page_GetHeight( page ) - nY

   SWITCH cType
   CASE "EAN13"      ; hZebra := hb_zebra_create_ean13( cCode, nFlags )   ; EXIT
   CASE "EAN8"       ; hZebra := hb_zebra_create_ean8( cCode, nFlags )    ; EXIT
   CASE "UPCA"       ; hZebra := hb_zebra_create_upca( cCode, nFlags )    ; EXIT
   CASE "UPCE"       ; hZebra := hb_zebra_create_upce( cCode, nFlags )    ; EXIT
   CASE "CODE39"     ; hZebra := hb_zebra_create_code39( cCode, nFlags )  ; EXIT
   CASE "ITF"        ; hZebra := hb_zebra_create_itf( cCode, nFlags )     ; EXIT
   CASE "MSI"        ; hZebra := hb_zebra_create_msi( cCode, nFlags )     ; EXIT
   CASE "CODABAR"    ; hZebra := hb_zebra_create_codabar( cCode, nFlags ) ; EXIT
   CASE "CODE93"     ; hZebra := hb_zebra_create_code93( cCode, nFlags )  ; EXIT
   CASE "CODE11"     ; hZebra := hb_zebra_create_code11( cCode, nFlags )  ; EXIT
   CASE "CODE128"    ; hZebra := hb_zebra_create_code128( cCode, nFlags ) ; EXIT
   CASE "PDF417"     ; hZebra := hb_zebra_create_pdf417( cCode, nFlags ); nLineHeight := nLineWidth * 3 ; EXIT
   CASE "DATAMATRIX" ; hZebra := hb_zebra_create_datamatrix( cCode, nFlags ); nLineHeight := nLineWidth ; EXIT
   CASE "QRCODE"     ; hZebra := hb_zebra_create_qrcode( cCode, nFlags ); nLineHeight := nLineWidth ; EXIT
   ENDSWITCH

   IF hZebra != NIL
      IF hb_zebra_geterror( hZebra ) == 0
         IF Empty( nLineHeight )
            nLineHeight := 16
         ENDIF
         HPDF_Page_BeginText( page )
         HPDF_Page_TextOut( page,  40, nY - 13, cType )
         cTxt := hb_zebra_getcode( hZebra )
         IF Len( cTxt ) < 20
            HPDF_Page_TextOut( page, 150, nY - 13, cTxt )
         ENDIF
         HPDF_Page_EndText( page )
         hb_zebra_draw_hpdf( hZebra, page, 300, nY, nLineWidth, -nLineHeight )
      ELSE
         ? "Type", cType, "Code", cCode, "Error", hb_zebra_geterror( hZebra )
      ENDIF
      hb_zebra_destroy( hZebra )
   ELSE
      ? "Invalid barcode type", cType
   ENDIF

   RETURN

STATIC FUNCTION hb_zebra_draw_hpdf( hZebra, page, ... )

   IF hb_zebra_geterror( hZebra ) != 0
      RETURN HB_ZEBRA_ERROR_INVALIDZEBRA
   ENDIF

   hb_zebra_draw( hZebra, {| x, y, w, h | HPDF_Page_Rectangle( page, x, y, w, h ) }, ... )

   HPDF_Page_Fill( page )

   RETURN 0

//EOF
