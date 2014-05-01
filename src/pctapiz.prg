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
#include "gclass.ch"
#include "dbstruct.ch"
#include "pc-soft.ch"


#define GTK_WRAP_WORD       2
#define GTK_TEXT_DIR_RTL    2

#define PANGO_STYLE_ITALIC  2
//#define PANGO_SCALE         1024

// --------------------------------------------------------------------------------------- //

CLASS PCTapiz
   DATA oBox
   DATA aDraw
   DATA aoImage     INIT  {}
   DATA oDraw
   DATA nPos        INIT  0

   METHOD New() CONSTRUCTOR
   METHOD Active()
   METHOD Imagen()

   METHOD Configure_event()
   METHOD Dibuja()
   METHOD Linea()
   METHOD Say()
   METHOD SetText( cMsg )
   
   METHOD Version()  INLINE  "0.1.2"
END CLASS

// ------------------------------------------------------------------------ //

METHOD New( oBox ) CLASS PCTapiz

  ::oBox    := oBox
  ::aoImage := {}
  ::nPos    := 0

RETURN Self

// ------------------------------------------------------------------------ //

METHOD Active( cText ) CLASS PCTapiz

   Default cText:=""

   DEFINE DRAWINGAREA ::oDraw ;
          EXPOSE EVENT    ::Dibuja( oSender,pEvent, Self, cText );
          CONFIGURE EVENT ::Configure_event( oSender,pEvent, Self );
          OF ::oBox EXPAND FILL //CONTAINER

RETURN Nil


// ------------------------------------------------------------------------ //

METHOD Imagen( xImagen, nOp1, nOp2 ) CLASS PCTapiz
   Local x
   Local nPos
   
   if ValType(xImagen) == "C"
     aadd( ::aoImage, { gdk_pixbuf_new_from_file( xImagen ), , nOp1, nOp2 } )
   elseif ValType(xImagen) == "O"
     aadd( ::aoImage, { xImagen:pWidget, , nOp1, nOp2 } )
   elseif ValType(xImagen) == "N"
     aadd( ::aoImage, { xImagen, , nOp1, nOp2 } )
   end
   
   ::nPos++
   
   ::aoImage[ ::nPos, 2 ] := Prop_Img( ::aoImage[ ::nPos, 1 ] )

RETURN Nil

// ------------------------------------------------------------------------ //

METHOD  Configure_event( oSender, pEvent, oSelf ) CLASS PCTapiz
 Local widget

  widget := oSender:pWidget

  ::aDraw := aDraw( pEvent )
//   TraceLog( "::aDraw", ::aDraw[1], ::aDraw[2], ::aDraw[3], ::aDraw[4])

RETURN .T.

// ------------------------------------------------------------------------ //
/*
Abajo      1
izquierda  1
Centrado   2
Arriba     4
derecha    4
Estirado   8
*/
METHOD Dibuja(  oSender, pEvent, oSelf, cText ) CLASS PCTapiz
 Local widget := oSender:pWidget
 Local gc := gdk_gc_new( widget  )   // cambio propiedades del contexto gráfico gc
 Local alto, ancho, x, Pix,pango
// Local color, pango, y

 for x=1 to ::nPos
   if ::aoImage[x,3] # nil
     // Estirado y Estirado
     if ::aoImage[x,3] == 8 .and. ::aoImage[x,4] == 8
       Pix := gdk_pixbuf_scale_simple( ::aoImage[x,1], ::aDraw[3], ::aDraw[4] )
       gdk_draw_pixbuf( widget, gc, Pix, 0, 0, 0, 0, ::aDraw[3], ::aDraw[4] )
       gdk_pixbuf_unref( Pix )
     
     else 
   
       // Abajo
       if ::aoImage[x,3] == 1
         alto  := ::aDraw[4] - ( ::aoImage[x,2,1] + 5 )
       
       // Centrado
       elseif ::aoImage[x,3] == 2
         alto  := ( ::aDraw[4] / 2 ) - ( ::aoImage[x,2,1] / 2 )
       
       // Arriba
       elseif ::aoImage[x,3] == 4
         alto  := 5 //( ::aDraw[4] / 2 ) - ( ::aoImage[x,2,1] / 2 )
       end
     
       // Izquierda
       if ::aoImage[x,4] == 1
         ancho := 5 //::aDraw[3] - ( ::aoImage[x,2,2] + 5 )
       // Centrado
       elseif ::aoImage[x,4] == 2
         ancho := ( ::aDraw[3] / 2 ) - ( ::aoImage[x,2,2] / 2 )
       // Derecha
       elseif ::aoImage[x,4] == 4
         ancho := ::aDraw[3] - ( ::aoImage[x,2,2] + 5 )
       end

       gdk_draw_pixbuf( widget, gc, ::aoImage[x,1], 0, 0, ancho, alto )
     end
   else
   // Para posicion Fija
   end
 next

/*
 
   color := { 0XFFFF, 0XFFFF, 0XFFFF, 0XFFFF }
   gdk_gc_set_foreground( gc, color )

   y = 80
   gdk_draw_line( widget,; // area en donde dibujar
                  gc,; // contexto grafico a utilizar 
                  10, y,; // (x, y) inicial
                  ::aDraw[3]-10, y) // (x, y) final

   gdk_gc_set_line_attributes(gc,;
                             3,; // grosor
                             GDK_LINE_DOUBLE_DASH,; // tipo de linea (salida en este caso) 
                             GDK_CAP_ROUND,; // terminación (redondeada en este caso)
                             GDK_JOIN_BEVEL) // unión de trazos (redondeado en este caso)

  pango :=  gtk_widget_create_pango_layout( widget )
  pango_layout_set_markup( pango, '<span size="large"><b>'+;
                                  Str(::aReport[1],8)+" Socios"+HB_OSNEWLINE()+;
                                  Str(::aReport[2],8)+" Peliculas"+HB_OSNEWLINE()+;
                                  Str(::aReport[3],8)+" Alquiladas"+HB_OSNEWLINE()+;
                                  Str(::aReport[4],8)+" Atrasadas </b></span>" )

  gdk_draw_layout( widget, gc, 10, 5, pango )
*/
  If !Empty(cText)
  
    pango :=  gtk_widget_create_pango_layout( widget )
    pango_layout_set_markup( pango, cText )

    gdk_draw_layout( widget, gc, 10, 5, pango )

  EndIf
  
  g_object_unref( gc )  

Return .T.

// ------------------------------------------------------------------------ //

METHOD Linea(  oSender, pEvent, oSelf ) CLASS PCTapiz
 Local widget := oSender:pWidget
 Local gc := gdk_gc_new( widget  )   // cambio propiedades del contexto gráfico gc
 Local Pix := gdk_pixbuf_scale_simple( ::oImage[1], ::aDraw[3], ::aDraw[4] )
 Local color, pango, y

  gdk_draw_pixbuf( widget, gc, Pix, 0, 0, 0, 0, ::aDraw[3], ::aDraw[4] )

  gdk_draw_pixbuf( widget, gc, ::oImage[2], 0, 0, ::aDraw[3]/2-80, ::aDraw[4]-55 )

/*
   color := { 0XFFFF, 0XFFFF, 0XFFFF, 0XFFFF }
   gdk_gc_set_foreground( gc, color )

   y = 80
   gdk_draw_line( widget,; // area en donde dibujar
                  gc,; // contexto grafico a utilizar 
                  10, y,; // (x, y) inicial
                  ::aDraw[3]-10, y) // (x, y) final

   gdk_gc_set_line_attributes(gc,;
                             3,; // grosor
                             GDK_LINE_DOUBLE_DASH,; // tipo de linea (salida en este caso) 
                             GDK_CAP_ROUND,; // terminación (redondeada en este caso)
                             GDK_JOIN_BEVEL) // unión de trazos (redondeado en este caso)

  pango :=  gtk_widget_create_pango_layout( widget )
  pango_layout_set_markup( pango, '<span size="large"><b>'+;
                                  Str(::aReport[1],8)+" Socios"+HB_OSNEWLINE()+;
                                  Str(::aReport[2],8)+" Peliculas"+HB_OSNEWLINE()+;
                                  Str(::aReport[3],8)+" Alquiladas"+HB_OSNEWLINE()+;
                                  Str(::aReport[4],8)+" Atrasadas </b></span>" )

  gdk_draw_layout( widget, gc, 10, 5, pango )
*/
  g_object_unref( gc )  
  gdk_pixbuf_unref( Pix )

Return .T.

// ------------------------------------------------------------------------ //
METHOD SetText(  oSender, cText ) CLASS PCTapiz
 Local widget := oSender:pWidget
 Local gc := gdk_gc_new( widget  )   // cambio propiedades del contexto gráfico gc
 Local Pix := gdk_pixbuf_scale_simple( ::oImage[1], ::aDraw[3], ::aDraw[4] )
 Local color, pango, y

  gdk_draw_pixbuf( widget, gc, Pix, 0, 0, 0, 0, ::aDraw[3], ::aDraw[4] )

  gdk_draw_pixbuf( widget, gc, ::oImage[2], 0, 0, ::aDraw[3]/2-80, ::aDraw[4]-55 )

  If !Empty( cText )
  
     cText := '<span  size="11000"><b><i>'+cText
     cText += '</i></b> </span>'
     
     pango :=  gtk_widget_create_pango_layout( widget )
     pango_layout_set_markup( pango, cText )
     gdk_draw_layout( widget, gc, 10, 15, pango )
     
  EndIf

  g_object_unref( gc )  
  gdk_pixbuf_unref( Pix )

Return .T.


METHOD Say(  oSender, pEvent, oSelf ) CLASS PCTapiz
 Local widget := oSender:pWidget
 Local gc := gdk_gc_new( widget  )   // cambio propiedades del contexto gráfico gc
 Local Pix := gdk_pixbuf_scale_simple( ::oImage[1], ::aDraw[3], ::aDraw[4] )
 Local color, pango, y

  gdk_draw_pixbuf( widget, gc, Pix, 0, 0, 0, 0, ::aDraw[3], ::aDraw[4] )

  gdk_draw_pixbuf( widget, gc, ::oImage[2], 0, 0, ::aDraw[3]/2-80, ::aDraw[4]-55 )

/*
   color := { 0XFFFF, 0XFFFF, 0XFFFF, 0XFFFF }
   gdk_gc_set_foreground( gc, color )

   y = 80
   gdk_draw_line( widget,; // area en donde dibujar
                  gc,; // contexto grafico a utilizar 
                  10, y,; // (x, y) inicial
                  ::aDraw[3]-10, y) // (x, y) final

   gdk_gc_set_line_attributes(gc,;
                             3,; // grosor
                             GDK_LINE_DOUBLE_DASH,; // tipo de linea (salida en este caso) 
                             GDK_CAP_ROUND,; // terminación (redondeada en este caso)
                             GDK_JOIN_BEVEL) // unión de trazos (redondeado en este caso)
*/
  pango :=  gtk_widget_create_pango_layout( widget )
  pango_layout_set_markup( pango, '<span size="large"><b>'+;
                                  Str(1)+" Socios"+HB_OSNEWLINE()+;
                                  Str(2)+" Peliculas"+HB_OSNEWLINE()+;
                                  Str(3)+" Alquiladas"+HB_OSNEWLINE()+;
                                  Str(4)+" Atrasadas </b></span>" )

  gdk_draw_layout( widget, gc, 10, 5, pango )


  g_object_unref( gc )  
  gdk_pixbuf_unref( Pix )

Return .T.


// ------------------------------------------------------------------------ //

#pragma BEGINDUMP

#include <gtk/gtk.h>
#include "hbapi.h"
#include <t-gtk.h>

HB_FUNC( ADRAW )
{
 GdkEventExpose * event = ( GdkEventExpose * ) hb_parptr( 1 );

  hb_reta( 4 );
  hb_stornl( (glong) event->area.x, -1, 1 );
  hb_stornl( (glong) event->area.y, -1, 2 );
  hb_stornl( (glong) event->area.width, -1, 3 );
  hb_stornl( (glong) event->area.height, -1, 4 );

}

HB_FUNC( PROP_IMG )
{
 GdkPixbuf * pixbuf = GDK_PIXBUF( hb_parptr( 1 ) );
 gint hei, wid;

 hei = gdk_pixbuf_get_height(pixbuf);
 wid = gdk_pixbuf_get_width(pixbuf);

 hb_reta( 2 );
 hb_storni( (gint) hei, -1, 1 );
 hb_storni( (gint) wid, -1, 2 );

}

#pragma ENDDUMP
