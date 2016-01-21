/* $Id: listbox.prg,v 1.0 2014/01/23 23:25 riztan Exp $ */

/*
﻿  Copyright © 2009  Rafa Carmona
﻿  Copyright © 2009  Riztan Gutierrez

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


//#include "tepuy.ch"
#include "proandsys.ch"
#include "xhb.ch"
//#include "common.ch"
#include "gclass.ch"
#include "hbclass.ch"
//#include "pc-soft.ch"
#include "include/pc-soft.ch"


//#define GTK_STOCK_EDIT      "gtk-edit"

memvar oTpuy

/*
 *  Clase para Manejo de Lista de Datos
 */

CLASS TPY_LISTBOX // FROM TPUBLIC // FROM TPY_DATA_MODEL

   DATA oParent
   DATA lParent
   DATA lInBox
   DATA oWnd
   DATA oBox
   DATA oModel
   DATA oBarButton
   DATA oBtn
   DATA oBtns
   DATA lFix
   DATA lBar
   DATA lBotons

   DATA nRows

   DATA cId
   DATA uGlade
   DATA cGlade

   DATA bAction
   DATA bInit

   DATA bNew
   DATA bEdit
   DATA bDel
   DATA bPrint
   DATA bQuit

   METHOD New(oParent, oModel, cTitle, oIcon, nWidth, nHeight, cId, uGlade)
   METHOD Active( bAction, bInit )

   METHOD SetParent( oParent )    INLINE gtk_window_set_transient_for( ::oWnd:pWidget, oParent:pWidget )

   METHOD GetValue( xCol, aIter )

   METHOD RecCount() INLINE  ::oModel:nRows
   METHOD NRows()    INLINE  ::oModel:nRows

   METHOD GoNext()   INLINE  ::oModel:oTreeView:GoNext()
   METHOD GoPrev()   INLINE  ::oModel:oTreeView:GoPrev()

   METHOD Set(...)   INLINE  ::oModel:Set(...)

   METHOD ForEach( bCode )  INLINE ::oModel:oTreeView:ForEach( bCode )

   METHOD Release()  INLINE  IF(  !IsNIL( ::oWnd ), ::oWnd:End(), NIL )
   METHOD End()      INLINE  ::Release() //::oWnd:End()

ENDCLASS


METHOD New( oParent, oModel, cTitle, oIcon, nWidth, nHeight, cId, uGlade ) CLASS TPY_LISTBOX

   //Local cGlade
   Local lParent := .f.

   ::oParent := oParent
   ::oModel  := oModel
   ::oBtns   := TObject():New()
   ::cId     := cId
   ::uGlade  := uGlade
   ::lFix    := .t.
   ::lBotons := .t.
   ::lBar    := .t.
   ::lInBox  := .f.
   ::bNew    := {|| MsgInfo("Accion del Boton 'Nuevo'" ) }  //{|| .T. }
   ::bEdit   := {|| MsgInfo("Accion del Boton 'Edit'"  ) }  //{|| .T. }
   ::bDel    := {|| MsgInfo("Accion del Boton 'Delete'") }  //{|| .T. }
   ::bPrint  := {|| MsgInfo("Accion del Boton 'Print'" ) }  //{|| .T. }
   ::bQuit   := {|| ::oModel:Destroy(),::Release(), .t.  }  //{|| .T. }

   DEFAULT  nWidth := 0 , nHeight := 0

   If !IsNIL(::uGlade)
      If ValType( ::uGlade ) = "C"
         SET RESOURCES ::cGlade FROM FILE oTpuy:cResources+Alltrim(::uGlade)
         //::cGlade := cGlade
      Else
         ::cGlade := ::uGlade
      EndIf

   EndIf

   // Buscamos asignar un padre a la posible nueva ventana.
   if oParent = NIL
      DEFINE WINDOW ::oWnd SIZE nWidth,nHeight TITLE cTitle
             DEFINE BOX ::oParent VERTICAL OF ::oWnd
      ::lParent := .f.
   else
      Do Case
      Case oParent:IsDerivedFrom("GWINDOW")
           ::oParent := oParent
           ::lParent := .t.
      Case oParent:IsDerivedFrom("TPY_LISTBOX")
           ::oParent := oParent:oWnd
           ::lParent := .t.
      Case oParent:ClassName() = "GBOX" .OR.;
           ::oParent:ClassName() = "GBOXVH"
           ::oParent := oParent
           ::lParent := .F.
           ::lInBox  := .T.
      Other
           If oTpuy:oWnd:IsDerivedFrom("GWINDOW")
              ::oParent := oTpuy:oWnd
              ::lParent := .t.
           EndIf
      EndCase
   EndIf

   //if hb_IsNil( oParent )
   if ::lParent
      if nWidth == 0 .OR. nHeight == 0
         DEFINE WINDOW ::oWnd TITLE cTitle ;
                ID ::cId RESOURCE ::cGlade
         ::lFix := .t.
      else
         DEFINE WINDOW ::oWnd SIZE nWidth, nHeight TITLE cTitle ;
                ID ::cId RESOURCE ::cGlade
         ::lFix := .f.
      end
      ::oWnd:SetSkipTaskBar( .t. )

      If ::lParent
         gtk_window_set_transient_for( ::oWnd:pWidget, ::oParent:pWidget )
      EndIf



      If !IsNIL(::uGlade)
         DEFINE BOX ::oBox ID "data" RESOURCE ::cGlade
      Else
         DEFINE BOX ::oBox VERTICAL OF ::oWnd SPACING 8
      EndIF
   else
     ::oBox := ::oParent
   end

   If ISNIL( oIcon ) .and. FILE( oTpuy:cImages+"tpuy-icon-16.png" )
      ::oWnd:SetIconFile( oTpuy:cImages+"tpuy-icon-16.png" )
   Else
      If hb_IsObject(oIcon)
         ::oWnd:SetIconName( oIcon )
      EndIf
   EndIf

   IF ::lBar

      If !IsNIL(::cGlade)
         DEFINE TOOLBAR ::oBarButton OF ::oBox  ;
                     ID "barbutton" RESOURCE ::cGlade
      Else
         DEFINE TOOLBAR ::oBarButton OF ::oBox STYLE GTK_TOOLBAR_BOTH
      Endif

      If ::lBotons //.AND. !Empty(::oBtns:hVars)

         //HSet( ::oBtns:hVars, "oTBtnNew"  , NIL )
         //HSet( ::oBtns:hVars, "oTBtnEdit" , NIL )
         //HSet( ::oBtns:hVars, "oTBtnDel"  , NIL )
         //HSet( ::oBtns:hVars, "oTBtnPrint", NIL )
         //HSet( ::oBtns:hVars, "oTBtnQuit" , NIL )

         ::oBtns:oTBtnNew   := NIL 
         ::oBtns:oTBtnEdit  := NIL 
         ::oBtns:oTBtnDel   := NIL 
         ::oBtns:oTBtnPrint := NIL 
         ::oBtns:oTBtnQuit  := NIL 

         IF IsNIL(::uGlade)

            /* Boton NEW */
            DEFINE PCTOOLBUTTON ::oBtns:oTBtnNew   ;
                TEXT "Nuevo"              ;
                STOCK_ID GTK_STOCK_ADD    ;
                ACTION EVAL( ::bNew )     ;
                TOOLTIP "Añadir nuevo elemento en la lista...";
                OF ::oBarButton

            /* Boton EDIT */
            DEFINE PCTOOLBUTTON ::oBtns:oTBtnEdit      ;
                TEXT "Editar"              ;
                STOCK_ID GTK_STOCK_EDIT    ;    // "gtk-edit" No entiendo por que no acepta
                ACTION EVAL( ::bEdit )     ;
                TOOLTIP "Editar elemento en la lista...";
                OF ::oBarButton

            /* Boton DELETE */
            DEFINE PCTOOLBUTTON ::oBtns:oTBtnDel      ;
                TEXT "Borrar"              ;
                STOCK_ID GTK_STOCK_DELETE  ;
                ACTION EVAL( ::bDel )      ;
                TOOLTIP "Elimina el elemento Seleccionado en la lista...";
                OF ::oBarButton

            /* Boton PRINT */
            DEFINE PCTOOLBUTTON ::oBtns:oTBtnPrint      ;
                TEXT "Imprimir"              ;
                STOCK_ID GTK_STOCK_PRINT  ;
                ACTION EVAL( ::bPrint )      ;
                TOOLTIP "Imprimir...";
                OF ::oBarButton

         ELSE
            /* Boton NEW */
            DEFINE PCTOOLBUTTON ::oBtns:oTBtnNew      ;
                ACTION EVAL(  ::bNew )    ;
                ID "tbnew" RESOURCE ::cGlade

            /* Boton EDIT */
            DEFINE PCTOOLBUTTON ::oBtns:oTBtnEdit      ;
                ACTION EVAL(  ::bEdit )    ;
                ID "tbedit" RESOURCE ::cGlade

            /* Boton DELETE */
            DEFINE PCTOOLBUTTON ::oBtns:oTBtnDel      ;
                ACTION EVAL(  ::bDel )    ;
                ID "tbdel" RESOURCE ::cGlade

            /* Boton PRINT */
            DEFINE PCTOOLBUTTON ::oBtns:oTBtnPrint      ;
                ACTION EVAL(  ::bPrint )    ;
                ID "tbprint" RESOURCE ::cGlade

         ENDIF


      ENDIF

   EndIf


RETURN Self



METHOD GetValue(xCol, aIter ) CLASS TPY_LISTBOX
   Local xResult
   Local cValType, nColumn := 1

   If aIter = NIL
      aIter := ARRAY(4)
      ::oModel:oTreeView:IsGetSelected( aIter )
   EndIf

   cValType := VALTYPE(xCol)
   If cValType = "C"
      if ::oModel:IsDef(xCol)
         //nColumn := ::oModel:Get(xCol):oGtkColumn:nColumn + 1
         nColumn := ::oModel:GetPosCol(xCol)
      else
         nColumn := ::oModel:GetPosCol(xCol) //:oGtkColumn:nColumn + 1
         if !::oModel:lQuery
            return ::oModel:oTreeView:GetAutoValue( nColumn, aIter )
         endif
         /* Es posible que se esté solicitando el valor utilizando la etiqueta de la columna */
         if VALTYPE(nColumn)="N" .AND. !(nColumn < 0 )
            return ::oModel:GetValue( nColumn )
         endif
         MsgStop("Valor [" + xCol + "]. No Reconocido. ")
         return nil
      endif
   ElseIf cValType = "N"
      nColumn := xCol
   EndIf
   xResult := ::oModel:oTreeView:GetAutoValue( nColumn, aIter )
RETURN xResult



// --------------------------------------------------------------------------------------- //

METHOD Active( bAction, bInit ) CLASS TPY_LISTBOX

   //Local x, i, oBox, cGlade

   ::bAction := bAction
   ::bInit   := bInit

   ::oModel:Listore( ::oBox, Self )
   //::oModel:Listore( ::oBox )

   IF ::lBar

      If ::lBotons

         IF IsNIL(::uGlade)

            /* Separador */
            DEFINE TOOL SEPARATOR ::oBtns:oSeparator1  ;
                   OF ::oBarButton  

            /* Boton QUIT */
            DEFINE PCTOOLBUTTON ::oBtns:oTBtnQuit      ;
                TEXT "Salir"              ;
                STOCK_ID GTK_STOCK_QUIT   ;
                ACTION EVAL( ::bQuit )    ;
                TOOLTIP "Salir...";
                OF Self

         ELSE

            /* Boton QUIT */
            DEFINE PCTOOLBUTTON ::oBtns:oTBtnQuit      ;
                ACTION EVAL( ::bQuit )    ;
                ID "tbquit" RESOURCE ::cGlade
         ENDIF

      EndIf

   Else
      ::oBarButton:Hide()
   EndIf

   If IsNIL( ::oWnd )
      if !::lParent .and. !::lInBox
         MsgAlert("No hay Ventana Definida... [revisar] ","Error")
      endif
   Else
      IF IsNIL(::uGlade)
         ACTIVATE WINDOW ::oWnd
      ENDIF

   EndIf



RETURN Self


//EOF
