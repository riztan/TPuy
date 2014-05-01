/* $Id: tpyselector.prg,v 1.0 2009/03/18 10:21:00 tyler Exp $*/
/*
   Copyright © 2009  Miguel Suarez <tyler.ve at gmail.com>

   Este programa es software libre: usted puede redistribuirlo y/o modificarlo
   conforme a los términos de la Licencia Pública General de GNU publicada por
   la Fundación para el Software Libre, ya sea la versión 3 de esta Licencia o
   (a su elección) cualquier versión posterior.

   Este programa se distribuye con el deseo de que le resulte útil, pero
   SIN GARANTÍAS DE NINGÚN TIPO; ni siquiera con las garantías implícitas de
   COMERCIABILIDAD o APTITUD PARA UN PROPÓSITO DETERMINADO. Para más información,
   consulte la Licencia Pública General de GNU.

   http://www.gnu.org/licenses/

    (c)2008 Rafael Carmona <rafa.tgtk at gmail.com>
    (c)2009 Riztan Gutierrez <riztan at gmail.com>
    (c)2009 Miguel Suarez <tyler.ve at gmail.com>
*/

#include "hbclass.ch"
#include "gclass.ch"

memvar oTpuy

CLASS TPYSELECTOR FROM GFRAME
      
      DATA oAlign    // Objeto de Alineacion
      DATA oHBox     // Objeto que sera etiqueta del frame
      DATA oButton   // Manejador de la los botones
      DATA oImg      // Imagen
      DATA oName     // Valor de la etiqueta Selector
      DATA oValue    // Valor de la la Seleccion
      DATA oTextView // Descripción
      
      METHOD New( cText, nShadow, nHor, nVer, oParent, lExpand, lFill, nPadding, lContainer, x, y, cId,;
                  uGlade, uLabelTab, nWidth, nHeight, lSecond, lResize, lShrink, left_ta, top_ta, bottom_ta,;
                  xOptions_ta, yOptions_ta, cFromstock, nSize, bAction, cFileImg, cName, cValue )
      METHOD SetName( cName ) INLINE  gtk_label_set_markup ( ::oName:pWidget, cName )
      METHOD SetValue( cValue ) INLINE gtk_label_set_markup ( ::oValue:pWidget, cValue )
      METHOD GetName( ) INLINE ::oName:GetText()
      METHOD GetValue( ) INLINE ::oValue:GetText()

ENDCLASS

METHOD New( cText, nShadow, nHor, nVer, oParent, lExpand, lFill, nPadding, lContainer, x, y,;
            cId, uGlade, uLabelTab, nWidth, nHeight, lSecond, lResize, lShrink,;
            left_ta,right_ta,top_ta,bottom_ta, xOptions_ta, yOptions_ta,;
            cFromstock, nSize, bAction, cFileImg,;
            cName, cValue   ) CLASS TPYSELECTOR

    DEFAULT cText := "", nShadow := 4, nSize := 20

    IF cId == NIL
       if Valtype( cText ) = "C" // Si es un texto
          ::pWidget = gtk_frame_new( cText )
       elseif Valtype( cText ) = "O" /* Es un objeto label */
          ::pWidget = gtk_frame_new()
          ::SetLabel( cText )
       endif
    ELSE
       ::pWidget := glade_xml_get_widget( uGlade, cId )
       ::CheckGlade( cId )
   ENDIF

   ::Register()

   ::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y,;
               uLabelTab, , lSecond, lResize, lShrink, left_ta,right_ta,top_ta,bottom_ta,;
               xOptions_ta, yOptions_ta  )

   if nShadow != 0
      ::SetShadow( nShadow )
   endif

   if nWidth != NIL
      ::Size( nWidth, nHeight )
   endif

   IF nHor != NIL /* Definimos alinacion del texto.*/
      ::SetLabelAlign( nHor, nVer )
   ENDIF


   /* ALINEACION */
   ::oAlign := gALignment():New( 0.5, 0.5, 1, 1,;
                                 Self, .F., .F., , .T., , , , , , .5,;
                                .5, .F., .F., .F., .F., ,,,, , )


   /* HBOX LABEL */
   ::oHBox:= GBoxVH():New( .F., 3, .F., , .T., .T., , .F., , , , ;
                          .F., .F., .F., ,,,, , , ,  )


   /* BOTON */
   ::oButton :=  GButton():New( ,  , , , .T., ,::oHBox, .F., .F.,,   ;
                               .F., , , , , , , , , ,,.F., .F., .F., ;
                               .F., ,,,, , ,  ,  )

   IF bAction != NIL // Si hay una accion , conectamos seal
      ::oButton:bAction := bAction
      ::oButton:Connect( "clicked" )
   ENDIF


   ::oTextView :=  gTextView():New( {|u| If( PCount() == 0, cText, cText := u ) },;
                                    .T., ::oAlign, .F., .F., , ;
                                    .T.,, , , , , , ,.F.,      ;
                                    .F., .F., .F., ,,,, ,  )

   /* TIPO IMAGEN */
   if cFromstock != NIL
          
      ::oImg := GImage():New(  , ::oButton, .F., .F.,  ,            ;
                             .T., , , , , , , , .F., .F., .F., .F., ;
                             ,,,, , , , , cFromstock, nSize, .F.  )
   else   
      ::oImg :=  GImage():New( cFileImg , ::oButton, .F.,           ;
                              .F.,  , .T., , , , , , , , .F.,      ;
                              .F., .F., .F., ,,,, , , , , , , .F.  )
   endif
    

   /* NOMBRE */
   ::oName := GLabel():New( "<i>"+cName+"</i>" , .T., ::oHBox, , .F., .F., , ;
                            .F., , , , , ,.F., .F., .F., .F., ,,,, ,, , ,  )

   /* VALOR */
   ::oValue := GLabel():New( "<b>"+cValue+"</b>", .T., ::oHBox, , .F., .F., , ;
                             .F., , , , , ,.F., .F., .F., .F., ,,,, ,, , ,  )

   ::SetLabel(::oHBox)

   ::Show()

RETURN Self




/*
 * Otro Selector a ver que tal.
 */
CLASS TPYDMSELECTOR FROM TPYSELECTOR

      DATA oModel
      DATA oConn
      DATA aField
      DATA aReg
      DATA nRow
      
      DATA bExec
      
      METHOD FromModel( oConn, oModel, oParent, aField, aReg, nRow )
      METHOD SetValue(cValue)

ENDCLASS


METHOD FromModel( oConn, oModel, oParent, aField, aReg, nRow ) CLASS TPYDMSELECTOR
    Local cTemp,other

    ::oConn := oConn
    ::oModel:= oModel
    ::aField:= aField
    ::aReg  := aReg
    ::nRow  := nRow
    
    cTemp := '{|| '+::aField[12]+'}'
//    cTemp := '{|Self| ::SetValue(::aField[12]),view(::aReg[3])}'
    ::bExec := &cTemp

    other := DescriFromRef(::oConn,::aField[9],;
                         ::aField[11],::aField[10],;
                         ::aReg[3],::nRow)

   ::New( other;
           , , , ,;
           oParent, .F., .F., , .F., , , , , , , , .F., .F., .F.,,,,;
           ,,, "gtk-index", 20,  {|o| ::SetValue(eval(::bExec)) } ,,;
           "", "<b>"+::aReg[3]+"</b>",1 )     

RETURN Self



METHOD SetValue( cValue ) CLASS TPYDMSELECTOR
   Local cResult
   cResult := DescriFromRef( ::oConn, ::aField[9],::aField[11],::aField[10],cValue,1 )
   
   IF !Empty(cResult)
      ::aReg[3]:=cValue
      cValue := "<b>"+cValue+"</b>"
      gtk_label_set_markup ( ::oValue:pWidget, cValue )
      ::oTextView:SetText( cResult )
      RETURN cValue
   ENDIF

Return ""



/**
 *  Funcion que retorna el valor correspondiente a una referencia
 */
STATIC FUNCTION DescriFromRef( oConn, cTable,cRef,cWhere,cValue,nLin )
   Local cRes:=" "
   Local cQuery, oQuery
   
   If nlin > 0 .AND. !Empty(cValue)
      cQuery := "select "+cRef+" from "+cTable+" "
      cQuery += "where "+cWhere+"="+DataToSQL(cValue)

      oQuery := oConn:Query( cQuery )

      If !Empty(oQuery:aData)
         cRes := oQuery:aData[1,1]
      EndIf
   EndIf
  
RETURN cRes




/*
 * Otro Selector a ver que tal.
 */
CLASS TPYSELECTORDATE FROM TPYSELECTOR

   DATA oWndFecha

      METHOD SelectDate( oParent, cDate )
      METHOD SetFecha(dFecha)
      METHOD SetAction(oWnd)

ENDCLASS


//Crea y despliega la ventana para la seleccion de una fecha
//tambien llama a la funcion que actualiza la fecha y cierra esta misma
METHOD SelectDate( oParent, cDate ) CLASS TPYSELECTORDATE
//Function SelectFecha(oParent, oLabel)

  local oCalendar
  local oBox, dDate //:= date()
  local oBtn
  local bSel

   If cDate != NIL
      dDate := CTOD( cDate )
   EndIf
   
   bSel := {|| ::SetFecha( oCalendar:GetDate() ), ::oWndFecha:End() }

   DEFINE WINDOW ::oWndFecha OF oParent
    
//      ::oWndFecha:SetDecorated(.f.)

      gtk_window_set_destroy_with_parent( oTpuy:oWnd, .t. )
      gtk_window_set_modal( ::oWndFecha, .t. )
      ::oWndFecha:SetSkipTaskBar( .t. )
      
      DEFINE BOX oBox VERTICAL OF ::oWndFecha
      
      DEFINE CALENDAR oCalendar;
             DATE dDate ;
             ON_DCLICK Eval(bSel);
             MARKDAY;
           OF oBox

      DEFINE BUTTON oBtn FROM STOCK GTK_STOCK_OK ;
             ACTION Eval(bSel);
             OF oBox
             
             // -- Por hacer -- RIGC
             //--  Debemos buscar valores en
             //--  Tabla de Calendarios y marcar los dias correspondientes
             //--  al mes
             //oCalendar:MarkDay(5)
  
   ACTIVATE WINDOW ::oWndFecha CENTER

Return Self



//funcion que actualiza la fecha y cierra la ventana que la llama

METHOD SetFecha( dFecha ) CLASS TPYSELECTORDATE

  Local cFecha
  
  //traduccion a una etiqueta de marcado
  cFecha := "<b>" + DTOC(dFecha) + "</b>"
  //cambio en la etiqueta principal que contiene la fecha
  ::oValue:SetMarkup(cFecha)

Return Self


METHOD SetAction(oWnd) CLASS TPYSELECTORDATE

      ::oButton:bAction := {|| ::SelectDate(oWnd) }
      ::oButton:Connect( "clicked" )

Return Self

