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
    (c)2009 Riztan Gutierrez  <riztan@gmail.com>
*/


#include "proandsys.ch"
#include "gclass.ch"
#include "tgtkext.ch"
#include "tepuy.ch"

memvar oTpuy

/** \brief Invocacion del dialogo Acerca_de
 */
Function AppAbout()
   
//   Local oAbout

//   MsgInfo( CStr(oTpuy:cResource) )

//   SET RESOURCES oTpuy:cResource FROM FILE oTpuy:cRsrcMain 
//   DEFINE ABOUT oAbout ID "acercade" RESOURCE oTpuy:cResource

Return NIL

/*  por los momentos dejo la funcion con el nombre para evitar algun problema */
Function Acerca_de()   
Return TpuyAbout()


Function TpuyAbout()
   Local oWnd, oBoxH, oBoxV, oBox2, oBook //,oImage
   Local cText, cText2 //, oFont
   Local oScroll, oTextView, oTextViewA, oTextView2, oTitu
   Local oImageAR, oImageVE
   Local aStart := Array( 14 )

   //DEFINE FONT oFont NAME "Arial italic 9"
   DEFINE IMAGE oImageAR FILE oTpuy:cImages+"ar.gif" LOAD
   DEFINE IMAGE oImageVE FILE oTpuy:cImages+"ve.gif" LOAD

   cText := ""

   DEFINE WINDOW oWnd TITLE "Acerca de " + TPUY_NAME  SIZE 600,300 ;
          ICON_FILE oTpuy:cIconMain

//   -----  Con respecto al ICON, por ahi vi en la documentacion de GTK
//   -----  que se puede definir el icono por defecto... 
//   gtk_window_set_icon(oWnd:pWidget, ::oIcon)
   oWnd:SetBorder( 5 )

     DEFINE BOX oBoxH OF oWnd EXPAND FILL
//       DEFINE IMAGE oImage FILE "pixmaps/logo.gif" OF oBoxH

      DEFINE BOX oBox2 VERTICAL OF oBoxH EXPAND FILL
      DEFINE NOTEBOOK oBook OF oBox2 EXPAND FILL
      DEFINE BOX oBoxV VERTICAL EXPAND FILL
      DEFINE LABEL oTitu PROMPT "Autor"
      oBook:Append( oBoxV, oTitu )
//      oBook:ShowBorder( .f. )
        DEFINE SCROLLEDWINDOW oScroll OF oBoxV CONTAINER
          oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )
          DEFINE TEXTVIEW oTextView2 VAR cText2 READONLY OF oScroll CONTAINER

   oTextView2:oBuffer:GetIterAtOffSet( aStart, -1 )
   oTextView2:CreateTag( "text" , { "style", PANGO_STYLE_ITALIC, ;
                                    "justification", GTK_JUSTIFY_CENTER } )
   oTextView2:CreateTag( "title", { "weight", 700,;
                                    "size", 10*PANGO_SCALE,;
                                    "justification", GTK_JUSTIFY_CENTER } )
   oTextView2:CreateTag( "link" , { "foreground", "blue", ;
                                    "style", PANGO_STYLE_ITALIC } )

   
   cText := "Versión " + TPUY_VERSION + CRLF + CRLF + ;
            "(c) 2008 - 2019 tpuy.org  "+ CRLF + ;
            "Desarrolladores: " 

   oTextView2:Insert_Tag( TPUY_NAME+CRLF, "title"   , aStart )

   oTextView2:Insert_Tag( cText, "text", aStart )
   oTextView2:Insert_Tag( TPUY_TEAM+CRLF, "link", aStart )

   oTextView2:Insert_Tag( "e-mail: ", "text", aStart )
   oTextView2:Insert_Tag( TPUY_MAIL+CRLF+CRLF, "link", aStart )

   oTextView2:Insert_Tag( "contacto: "+CRLF, "title", aStart )

   oTextView2:Insert_Tag( " ", "text" , aStart )
   oTextView2:Insert_Pixbuf( aStart, oImageAR )
   oTextView2:Insert_Tag( " Deán Funes - Córdoba. Argentina"+CRLF, "text" , aStart )
   oTextView2:Insert_Tag( "Teléfono: +54 ( 03521 ) - 421325  /   " + CRLF, "text" , aStart )
   oTextView2:Insert_Tag( "           +54 9 ( 03521 ) 15 - 440693" + CRLF+CRLF, "text" , aStart )

   oTextView2:Insert_Tag( " ", "text" , aStart )
   oTextView2:Insert_Pixbuf( aStart, oImageVE )
   oTextView2:Insert_Tag( "   Caracas. Venezuela"+CRLF, "text" , aStart )
   oTextView2:Insert_Tag( "      Teléfono: +58 (412) 756.30.82 " + CRLF, "text" , aStart )
   oTextView2:Insert_Tag( "      twitter: @tpuy_project @riztanivan " + CRLF, "text" , aStart )

      DEFINE BOX oBoxV VERTICAL EXPAND FILL
      DEFINE LABEL oTitu PROMPT "Licencia Traducida"
      oBook:Append( oBoxV, oTitu )

        DEFINE SCROLLEDWINDOW oScroll OF oBoxV CONTAINER
          oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )
          DEFINE TEXTVIEW oTextView VAR cText READONLY OF oScroll CONTAINER

   oTextView:Insert( "     "+ CRLF )
   oTextView:Insert( "     "+ CRLF )
   oTextView:Insert( "      Copyright (C) 2019"+ CRLF )
   oTextView:Insert( "     "+ CRLF )
   oTextView:Insert( "      Licencia LGPL."+ CRLF )
   oTextView:Insert( "     "+ CRLF )
   oTextView:Insert( "     Este programa está distribuido bajo los términos de GPL v2." )
   oTextView:Insert( "     "+ CRLF )
   oTextView:Insert( "      Este programa es Software Libre; usted puede redistribuirlo"+ CRLF )
   oTextView:Insert( "      y/o modificarlo bajo los términos de la GNU General Public "+ CRLF )
   oTextView:Insert( "      License, como lo publica la Free Software Foundation en "+ CRLF )
   oTextView:Insert( "      su versión 2 de la Licencia "+ CRLF) 
   oTextView:Insert( "     "+ CRLF )
   oTextView:Insert( "     Este programa es distribuido con la esperanza de que le será"+ CRLF )
   oTextView:Insert( "     útil, pero SIN NINGUNA GARANTIA; incluso sin la garantía"+ CRLF )
   oTextView:Insert( "     implícita por el MERCADEO o EJERCICIO DE ALGUN PROPOSITO en"+ CRLF )
   oTextView:Insert( "     particular. Vea la GNU General Public License para más"+ CRLF )
   oTextView:Insert( "      detalles."+ CRLF )
   oTextView:Insert( "     "+ CRLF )
   oTextView:Insert( "      Usted debe haber recibido una copia de la GNU General Public"+ CRLF )
   oTextView:Insert( "      License junto con este programa, si no, escriba a la "+ CRLF )
   oTextView:Insert( "      Free Software Foundation, Inc., 59 Temple Place - Suite 330,"+ CRLF )
   oTextView:Insert( "      Boston, MA  02111-1307, USA."+ CRLF )
   oTextView:Insert( "      (o visite el sitio web http://www.gnu.org/)."+ CRLF )
   oTextView:Insert( "     "+ CRLF )
   oTextView:Insert( "     "+ CRLF )


      cText := " "

      DEFINE BOX oBoxV VERTICAL EXPAND FILL
      DEFINE LABEL oTitu PROMPT "Licencia"
      oBook:Append( oBoxV, oTitu )

        DEFINE SCROLLEDWINDOW oScroll OF oBoxV CONTAINER
          oScroll:SetPolicy( GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC )
          DEFINE TEXTVIEW oTextViewA VAR cText READONLY OF oScroll CONTAINER


   oTextViewA:Insert( "     "+ CRLF )
   oTextViewA:Insert( "     "+ CRLF )
   oTextViewA:Insert( "      Copyright (C) 2019"+ CRLF )
   oTextViewA:Insert( "     "+ CRLF )
   oTextViewA:Insert( "      LGPL Licence."+ CRLF )
   oTextViewA:Insert( "     "+ CRLF )
   oTextViewA:Insert( "      This program is free software; you can redistribute it and/or modify"+ CRLF )
   oTextViewA:Insert( "      it under the terms of the GNU General Public License as published by"+ CRLF )
   oTextViewA:Insert( "      the Free Software Foundation; either version 2 of the License, or"+ CRLF )
   oTextViewA:Insert( "      (at your option) any later version."+ CRLF )
   oTextViewA:Insert( "     "+ CRLF )
   oTextViewA:Insert( "      This program is distributed in the hope that it will be useful,"+ CRLF )
   oTextViewA:Insert( "      but WITHOUT ANY WARRANTY; without even the implied warranty of"+ CRLF )
   oTextViewA:Insert( "      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the"+ CRLF )
   oTextViewA:Insert( "      GNU General Public License for more details."+ CRLF )
   oTextViewA:Insert( "     "+ CRLF )
   oTextViewA:Insert( "      You should have received a copy of the GNU General Public License"+ CRLF )
   oTextViewA:Insert( "      along with this software; see the file COPYING.  If not, write to"+ CRLF )
   oTextViewA:Insert( "      the Free Software Foundation, Inc., 59 Temple Place, Suite 330,"+ CRLF )
   oTextViewA:Insert( "      Boston, MA 02111-1307 USA"+ CRLF )
   oTextViewA:Insert( "      (or visit the web site http://www.gnu.org/)."+ CRLF )
   oTextViewA:Insert( "     "+ CRLF)
   oTextViewA:Insert( "     "+ CRLF )

   oWnd:SetResizable( .f. )

   ACTIVATE WINDOW oWnd CENTER


Return NIL


//EOF
