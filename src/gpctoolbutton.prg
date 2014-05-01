/* $Id: gtoolbutton.prg,v 1.1 2006/09/07 17:02:46 xthefull Exp $*/
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
    (c)2003 Rafael Carmona <thefull@wanadoo.es>
*/

memvar oTepuy

#include "gtkapi.ch"
#include "hbclass.ch"


CLASS GPCTOOLBUTTON FROM GTOOLBUTTON

  DATA  oTooTips

  METHOD New( cText, bAction, cStock, lMnemonic, cFromStock, oParent, lExpand, xImage, cTooTips, cId, uGlade  )
  METHOD SetTip( cTooTips )

ENDCLASS



METHOD New( cText, bAction, cStock, lMnemonic, cFromStock, oParent, lExpand, xImage, cTooTips,;
            cId, uGlade ) CLASS GPCTOOLBUTTON

   LOCAL oImage, lImage:=.T.
   LOCAL oBarButton

//View({"ClassName",oParent:ClassName})
   If oParent:ClassName == "TPY_LISTBOX"
      oBarButton := oParent:oBarButton
   Else
      oBarButton := oParent
   EndIf

       DEFAULT lExpand   := .F.,;
               lMnemonic := .F.

       Super:New( cText, bAction, cStock, lMnemonic, cFromStock, oBarButton, lExpand,;
            cId, uGlade )
       IF cId == NIL
             if xImage != NIL
               if Valtype( xImage ) == "C"
                  If !File( xImage ) 
                     If !File( oTepuy:cImages+xImage )
                        If !File( oTepuy:cResources+xImage )
                           lImage := .F.
                        Else
                           xImage := oTepuy:cResources+xImage
                        EndIf
                     Else
                        xImage := oTepuy:cImages+xImage
                     EndIf
                  EndIf
                  oImage := GImage():New( xImage,,.F.,.F.,,.F.,,,,,,,,.F.,.F.,.F.,.F.,,,,,,,,,,,.F. )
               else
                 oImage := xImage
               end
               If lImage
                  gtk_tool_button_set_icon_widget( ::pWidget, oImage:pWidget )
               EndIf
             endif
        ENDIF

       IF cTooTips != NIL
         ::oTooTips :=  Gtk_ToolTips_New()
         gtk_tool_item_set_tooltip ( ::pWidget, ::oTooTips, cTooTips )
       ENDIF

RETURN Self

METHOD SetTip( cTooTips ) CLASS GPCTOOLBUTTON

  IF ::oTooTips = NIL
    ::oTooTips :=  Gtk_ToolTips_New()
    gtk_tool_item_set_tooltip ( ::pWidget, ::oTooTips, cTooTips )
  ENDIF
  Gtk_tooltips_set_tip( ::oTooTips, ::pWidget, cTooTips )

RETURN Nil


