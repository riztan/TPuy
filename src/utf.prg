/*
    LGPL Licence.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this software; see the file COPYING.  If not, write to
    the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
    Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).

    LGPL Licence.
    (c)2007 Federico de Maussion <fj_demaussion@yahoo.com.ar>
*/

#include "hbclass.ch"
#include "common.ch"



FUNCTION iso( xCad )
   Local x

   if Valtype(xCad) == "A"
     for x = 1 to Len( xCad )
       if Valtype(xCad[x]) $ "CM"
         if !Is_Iso( xCad[x] )
           xCad[x] := _Utf_8( xCad[x] )
         end
       end
     next
   elseif Valtype(xCad) $ "CM"
     if !Is_Iso( xCad )
       xCad := _Utf_8( xCad )
     end
   end

Return xCad


//-------------------------------------------------------------------
FUNCTION Utf( xCad )
   Local x

   if Valtype(xCad) == "A"
     for x = 1 to Len( xCad )
       if Valtype(xCad[x]) $ "CM"
         if !Is_Utf_8( xCad[x] )
           xCad[x] := Utf_8( xCad[x] )
         end
       elseif Valtype(xCad[x]) $ "A"
         xCad[x] := Utf( xCad[x] )
       end
     next
   elseif Valtype(xCad) $ "CM"
     if !Is_Utf_8( xCad )
       xCad := Utf_8( xCad )
     end
   end

Return xCad


//-------------------------------------------------

FUNCTION Is_Utf_8( cChar )
   Local x
   Local aIso := {"á","é","í","ó","ú","à","è","ì","ò","ù","ü","ñ",;
                  "Á","É","Í","Ó","Ú","À","È","Ì","Ò","Ù","Ü","Ñ","º","ª"}

/*   Local aIso := {"á","é","í","ó","ú","à","è","ì","ò","ù","ä","ë","ï",;
                  "ö","ü","â","ê","î","ô","û","ã","õ","ñ","ç","Á","É",;
                  "Í","Ó","Ú","À","È","Ì","Ò","Ù","Ä","Ë","Ï","Ö","Ü",;
                  "Â","Ê","Î","Ô","Û","Ã","Õ","Ñ","Ç"}
*/
   for x = 1 to Len( aIso )
      if aIso[x] $ cChar
        Return .f.
      endif
   next

Return .t.


//-------------------------------------------------
FUNCTION Is_Iso( cChar )
   Local x
   Local aIso := {"á","é","í","ó","ú","à","è","ì","ò","ù","ü","ñ",;
                  "Á","É","Í","Ó","Ú","À","È","Ì","Ò","Ù","Ü","Ñ","º","ª"}

/*   Local aIso := {"á","é","í","ó","ú","à","è","ì","ò","ù","ä","ë","ï",;
                  "ö","ü","â","ê","î","ô","û","ã","õ","ñ","ç","Á","É",;
                  "Í","Ó","Ú","À","È","Ì","Ò","Ù","Ä","Ë","Ï","Ö","Ü",;
                  "Â","Ê","Î","Ô","Û","Ã","Õ","Ñ","Ç"}
*/

   for x = 1 to Len( aIso )
      aIso[x] := UTF_8(aIso[x])
   next

   for x = 1 to Len( aIso )
      if aIso[x] $ cChar
        Return .f.
      endif
   next

Return .t.


//-------------------------------------------------

function UTF_Len( cText )
   g_utf8_strlen( cText )
return cText

Function UTF_LOWER( cText )
Return g_utf8_strdown( cText )

Function UTF_UPPER( cText )
Return g_utf8_strup( cText )

//-------------------------------------------------

function UTF_Left( cText, nCant )

return UTF_SubStr( cText, 1, nCant )

//-------------------------------------------------

function UTF_Right( cText, nCant )
local x := UTF_Len(cText)
local nDes := x-nCant
if nDes < 1
  nDes := 1
end
return UTF_SubStr( cText, nDes, nCant )

//-------------------------------------------------

function UTF_SubStr( cText, nDes, nHast )
Local cDev

DEFAULT nDes TO 1,;
        nHast TO UTF_Len( cText )

cDev := g_utf8_strncpy( g_utf8_offset_to_pointer( cText, nDes - 1 ), nHast )

return cDev

//----------------------------------------------------------------------------//
#pragma BEGINDUMP

#include "hbapi.h"
#include <glib.h>

HB_FUNC( G_UTF8_VALIDATE )
{
  gssize max_len = ISNIL( 2 ) ? (gssize) -1 :  (gssize) hb_parni( 2 );

  hb_retl(g_utf8_validate(hb_parc(1), max_len, NULL));
}

HB_FUNC( G_UTF8_STRLEN )
{
  hb_retnl(g_utf8_strlen(hb_parc(1), -1));
}

HB_FUNC( G_UTF8_STRUP )             // Uppert de UTF _8
{
  gchar *szText = g_utf8_strup(hb_parcx(1), -1);
  hb_retc( (gchar *) szText );
  g_free( szText );
}

HB_FUNC( G_UTF8_STRDOWN )             // Lower de UTF _8
{
  gchar *szText = g_utf8_strdown(hb_parcx(1), -1);
  hb_retc( (gchar *) szText );
  g_free( szText );
}

HB_FUNC( G_UTF8_OFFSET_TO_POINTER )
{
  hb_retc( (gchar *) g_utf8_offset_to_pointer(hb_parcx(1), hb_parnl(2)) );
}

HB_FUNC( G_UTF8_STRNCPY )
{
  gchar *dest;
  dest = (gchar *) hb_xgrab( sizeof(gchar *) * hb_parni(2) * 6 );
  g_utf8_strncpy(dest, hb_parcx(1), hb_parni(2));
  hb_retc(dest);
  hb_xfree(dest);
}

#pragma ENDDUMP
//----------------------------------------------------------------------------//
