/* $Id: model_abm.prg,v 1.0 2008/10/23 14:44:02 riztan Exp $ */

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

/** \file model_abm.prg.
 *  \brief Programa de funciones para tpuy (derivado de listore en t-gtk)  
 *  \author Riztan Gutierrez. riztan (at) gmail (dot) com
 *  \date 2009
 *  \remark ...
*/

//#include "tepuy.ch"
#include "proandsys.ch"
#include "xhb.ch"
//#include "common.ch"
#include "gclass.ch"
#include "hbclass.ch"
//#include "pc-soft.ch"
#include "include/pc-soft.ch"
#include "include/base_columns.ch"

//#define GTK_STOCK_EDIT      "gtk-edit"

memvar oTpuy

#define GtkTreeIter  Array( 4 )



CLASS TPY_ABM2 //FROM TPUBLIC

   DATA oForm
   DATA oBoxes
   DATA oWnd
   DATA oModel
   DATA oListBox
   DATA aIter 
   DATA oGet
   DATA oBox, oBox1, oBox2, oBox3, oBox4
   DATA oTable, oScroll
   DATA oBtn
   DATA hButtons
   DATA oImage
   DATA oFont

   DATA cColorLabel

/* Probando */
   DATA hWidGet
   DATA hVars
   DATA oVar   
   DATA oField
//

   DATA cId
   DATA uGlade
   DATA cGlade

   DATA hOldValues 
   DATA hPreValues
   DATA hNewValues
   DATA aFields
//   DATA aVars
   DATA aReg
   DATA aGet
   DATA nLenGet
   DATA nAlto
   DATA nAncho
   DATA lFromListBox
   DATA lNew
   DATA lImage
   DATA oSeparator
   DATA lFix
   DATA lAcepta
   DATA lEnable
   DATA lButton
   DATA lBarBtn
   DATA lWnd
   DATA lModal
   DATA lEndSilence
   DATA nRow
   DATA nRows
   DATA nInterline   INIT 6

   DATA bAction
   DATA bInit
   DATA bEnd

   DATA bSave
   DATA bPosSave     INIT {|| .t. }

   DATA cImage

   METHOD New( oParent, oModel, cTitle, oIcon, nRow, nWidth, nHeight, cId, uGlade, cBox, lNew, lRemote )
   METHOD End( lForce )
   METHOD Active( bAction, bInit )
   METHOD ACantGet()
   METHOD UpdateBuffer()
   METHOD Enable()  INLINE (aEval( ::aGet, { |o| o:Enable()  } ),;
                            aEval( ::oBtn, { |o| o:Enable()  } ), ::lEnable := .t.)
   METHOD Disable() INLINE (aEval( ::aGet, { |o| o:Disable() } ),;
                            aEval( ::oBtn, { |o| o:Disable() } ) , ::lEnable := .f.)
   METHOD Refresh() INLINE  aEval( ::aGet, { |o| o:Refresh() } )
   METHOD nLen(n)   INLINE ::nLenGet := n

   METHOD GenOldValues()

   METHOD Save()
   METHOD Get(cField)  
   METHOD GetValue(cField)  
   METHOD GetTitle(cField)
   METHOD PosField(cField)
   METHOD Set(nColumn,uField,cValue)
   METHOD SetAction(uField,cAction)    INLINE  ::Set(12,uField,cAction)
   METHOD SetRefTable(uField,cTable)   INLINE  ::Set( 9,uField,cTable)
   METHOD SetRefDescri(uField,cField)  INLINE  ::Set(11,uField,cField)
   METHOD SetRefField(uField,cField)   INLINE  ::Set(10,uField,cField)
   METHOD SetEditable(uField,lVal)     //INLINE  ::Set( 3,uField,lVal)
   METHOD SetViewable(uField,lVal)     INLINE  ::Set( 4,uField,lVal)
   METHOD SetNavigable(uField,lVal)    INLINE  ::Set( 5,uField,lVal)

   METHOD SetValue( cField, uValue )   //INLINE  ::hNewValues[ cField ] := uValue

   METHOD SetImage( cImgName )

   METHOD IsDef( cField )              INLINE  HHasKey( ::hWidGet, cField )

   ERROR HANDLER OnError( uValue )

ENDCLASS


/** SetImage( cImgName ) Asigna una imagen al formulario. 
 *  Si la imagen no existe localmente, la solicita al servidor. En caso 
 *  de existir la imagen, la envia al servidor para ser guardada.
 *
 *  cImgName: Nombre del archivo contenedor de la imagen.
 */
METHOD SETIMAGE( cImgName )  CLASS TPY_ABM2
   local rApp
   If !File( oTPuy:cImages + cImgname )
      GetImage( cImgName )
      if File( oTpuy:cImages + cImgName )
         ::oImage:SetFile( oTPuy:cImages + cImgName )
         Return .t.
      endif
   else
      if oTpuy:lNetIO .and. !Empty(oTpuy:rApp)
         rApp := oTPuy:rApp
         ~~rApp:SetImage( cImgName, MemoRead( oTPuy:cImages + cImgName ) )
      endif
      ::oImage:SetFile( oTPuy:cImages + cImgName )
   EndIf
RETURN .f.


METHOD SETEDITABLE( cField, lValue )
   default cField to ""

   if ValType(lValue) != "L" ; return nil ; endif
   if empty(cField) ; return nil ; endif

   ::oBoxes:hVars[cField]:Show()
   ::hWidget[cField+"_label"]:Show()
   ::hWidget[cField]:Show()
   if lValue
      ::hWidget[cField]:Enable()
      ::hWidget[cField]:Enable()
   else
      ::hWidget[cField]:Disable()
      ::hWidget[cField]:Disable()
   endif
RETURN nil


/**
*/
METHOD SETVALUE( cField, uValue )
   local cClassName
if !( hb_HHasKey( ::hWidget, cField ) )
   View( HGetKeys(::hWidget) )
endif
   if hb_HHasKey( ::hWidget, cField )
      cClassName := ::hWidget[cField]:ClassName()
      if cClassName="GENTRY" .or. cClassName="GGET"
         ::hWidget[cField]:SetText( uValue )
      elseif cClassName="GCHECKBOX"
         ::hWidget[cField]:SetValue(uValue) 
      else
MsgAlert(cClassName, procname() )
         ::hNewValues[ cField ] := uValue
      endif
   else
MsgAlert(cClassName, procname() )
      ::hNewValues[ cField ] := uValue
   endif
Return nil


METHOD NEW( oParent, oModel, cTitle, oIcon, nRow, nWidth, nHeight,;
            cId, uGlade, cBox, lNew, lRemote )  CLASS TPY_ABM2  

   Local aColumn, oColumn//, xDefault
   Local cTemp
   Local aCombo := {}
   Local cIdGlade
   Local aComboValues
   Local oBoxTmp, oWidgetTmp
   Local oEventBox
   Local oWndParent, cScript
   Local lIni := .T.
   Local rApp

   
   ::lFromListBox := .f.

   DEFAULT  nWidth := 0 , nHeight := 0
   DEFAULT  cBox := "vbox2"
   DEFAULT  nRow := 0
   DEFAULT  lNew := .f.

   if oModel:ClassName()="TPY_LISTBOX" 
      ::lFromListBox := .t.
      ::oListBox := oModel
      ::oModel := oModel:oModel 
   else
      ::oModel := oModel 
   endif

   if !lNew .and. ::lFromListBox .and. ;
      !::oModel:oTreeView:IsGetSelected(ARRAY(4))

      MsgStop( "Seleccione un Registro", "No se puede editar" )
      return .f.
   endif

   ::aIter   := GtkTreeIter
   ::oGet    := TPublic():New()
   ::oVar    := TPublic():New()
   ::hVars   := Hash()
   ::hWidGet := Hash()
   ::oField  := TPublic():New()
   ::oBoxes  := TPublic():New()

   ::cId     := cId
   ::uGlade  := uGlade

   ::cColorLabel := "DarkGray"

   ::oBtn    := {,}
   ::aFields := {}
   ::aReg    := {}
   ::nAlto   := 0
   ::nAncho  := 0
   ::lFix    := .t.
   ::lAcepta := .f.
   ::lEnable := .t.
   ::lImage  := .t.
   ::lButton := .t.
   ::lBarBtn := .t.
   ::hButtons:= Hash()
   ::lNew    := lNew
   ::lWnd    := .t.
   ::lModal  := .t.
   ::nRow    := nRow
   ::nRows   := 0

   ::lEndSilence := .f.

   ::hOldValues := Hash()
   ::hPreValues := Hash()
   ::hNewValues := Hash()

   ::cImage  := "logo_gnome_64x64.png"
   ::bSave   := {|| .T. }

   ::bEnd    := {|| .T. }
   
   DEFINE FONT ::oFont NAME "Tahoma 9"

//   cRow     := ALLTRIM( CSTR(::oModel:GetPosRow()-1) )

   //pPath := gtk_tree_path_new_from_string( cRow )
   //pPath := gtk_tree_model_get_path( ::oModel:oGtkModel, @aIter )

   If !IsNIL(::uGlade)
      IF ValType( ::uGlade )="C"
         SET RESOURCES ::cGlade FROM FILE oTpuy:cResources+Alltrim(::uGlade)
         //::cGlade := cGlade
      ELSE
         ::cGlade := ::uGlade
      ENDIF
   EndIf


   if hb_IsObject(oParent) //.AND. oParent:ClassName()=="GWINDOW"
      if oParent:IsDerivedFrom("TPY_LISTBOX")
         oParent := oParent:oWnd
         oWndParent := oParent
      endif
      if oParent:IsDerivedFrom("GWINDOW")
         oWndParent := oParent
      endif
   else
      oWndParent := oTpuy:oWnd
   endif

   if oParent == NIL .or. oParent:IsDerivedFrom("GWINDOW")
      if nWidth == 0 .or. nHeight == 0
         DEFINE WINDOW ::oWnd TITLE cTitle OF oWndParent;
                       ID ::cId RESOURCE ::cGlade
         ::lFix := .t.
      else
         DEFINE WINDOW ::oWnd  TITLE cTitle ;
                       SIZE nWidth, nHeight ;
                       OF oWndParent        ;
                       ID ::cId RESOURCE ::cGlade
/*
                       view("bien")
                       ACTIVATE WINDOW ::oWnd
                       return self
                       */
         ::lFix := .f.
      end

      ::oWnd:SetSkipTaskBar( .t. )

      If ISNIL( oIcon ) .and. FILE( oTpuy:cImages+"tpuy-icon-16.png" )
         ::oWnd:SetIconFile( oTpuy:cImages+"tpuy-icon-16.png" )
      Else
         If hb_IsObject(oIcon)
            ::oWnd:SetIconName( oIcon )
         EndIf
      EndIf
      
      If !IsNIL(::uGlade)
         DEFINE BOX ::oBox ID cBox RESOURCE ::cGlade
      Else
         DEFINE BOX ::oBox VERTICAL OF ::oWnd SPACING 8
      EndIF

///      DEFINE BOX ::oBox OF ::oWnd SPACING 8
   else
     ::oBox := oParent
     ::lWnd := .f.
   end



//   ::oGet := ::oEdit:oGet

//   If !IsNIL(oParent)
      //::lButton:=.F.
//   EndIf

   // Creamos barra de botones si es necesario.
   If ::lBarBtn
      DEFINE TOOLBAR ::oBoxes:oBoxBtns OF ::oBox //SHOW ARROW
   EndIf      

   /* Caja Principal */
   DEFINE BOX ::oBoxes:oBoxMain OF ::oBox EXPAND FILL ; //HOMOGENEOUS
          SPACING 5

   If ::lImage
      //if ::oWnd == Nil
      //  DEFINE SEPARATOR OF ::oBox VERTICAL PADDING 15 //EXPAND FILL
      //end
      ::oBoxes:oBoxMain:SetBorder( 8 )
      if !FILE( oTPuy:cImages+::cImage )
         if oTPuy:lNetIO .and. !Empty( oTPuy:rApp )
            rApp := oTPuy:rApp
            GetImage( ::cImage )
            DEFINE IMAGE ::oImage FILE oTpuy:cImages+::cImage ;
                   OF ::oBoxes:oBoxMain
            
         endif
      else
         DEFINE IMAGE ::oImage FILE oTpuy:cImages+::cImage ;
                OF ::oBoxes:oBoxMain
      endif
      DEFINE SEPARATOR ::oSeparator OF ::oBoxes:oBoxMain ;
             VERTICAL PADDING 15 //EXPAND FILL
   EndIf

   DEFINE BOX ::oBoxes:oBoxTable VERTICAL OF ::oBoxes:oBoxMain ;
          EXPAND FILL HOMOGENEOUS SPACING ::nInterline


//View( ::oModel:aTpyStruct )

   FOR EACH aColumn IN ::oModel:aTpyStruct
      
      if ::oModel:IsDef( aColumn[COL_NAME] )
         oColumn := ::oModel:Get(aColumn[COL_NAME])
         
         ::nRows++


         /* definimos el contenedor secundario donde se despliegan los controles... */
//         if ::nRows > 2  
         if !hb_IsNIL( ::cGlade )
            cIdGlade := oColumn:Container
            if Empty( cIdGlade ) .or. hb_IsNIL( cIdGlade ) .or. cIdGlade="NIL" 
               DEFINE BOX oBoxTmp OF ::oBoxes:oBoxTable EXPAND FILL CONTAINER //HOMOGENEOUS
            else
               DEFINE BOX oBoxTmp ID cIdGlade RESOURCE ::cGlade EXPAND FILL CONTAINER
            Endif
         else
            DEFINE BOX oBoxTmp OF ::oBoxes:oBoxTable EXPAND FILL CONTAINER //HOMOGENEOUS
         endif 
//         ::nRows := 1
//         endif


/*
         if oColumn:Type == "C" .and. FEmpty( AllTrim( oColumn:Default ) )
            xDefault := Space( oColumn:Len ) 

         elseif oColumn:Type == "N" .and. FEmpty( AllTrim( oColumn:Default ) )
            if ( "." IN oColumn:Picture )
               xDefault := 0  
            else
               xDefault := Space( oColumn:Len )
            endif

         elseif oColumn:Type == "N" .and. !FEmpty( AllTrim( oColumn:Default ) )
            xDefault := oColumn:Default

         else
            xDefault := " "
         endif
*/
//            HSet( ::hVars, oColumn:Name, xDefault )


         //-- Repetimos el PICTURE si se especifica un solo valor.
         if oColumn:Type == "C" .and. LEN( Alltrim( oColumn:Picture ) ) = 1
            oColumn:Picture := Repli( AllTrim( oColumn:Picture ), oColumn:Len )
         endif

         //-- Seteamos el valor maximo para el ancho. Valor para calculo de tamaño de la ventana.
         if oColumn:Len > ::nAncho
            ::nAncho := oColumn:Len
         endif

         //-- Si estamos editando, colocamos el valor desde el modelo...
         If !lNew .and. ( ::nRow > 0 .or. ::lFromListBox )
            //cTemp := AllTrim( CStr( ::oModel:oGtkModel:oTreeView:GetValue( aColumn:__EnumIndex(), "", pPath, @aIter ) ) )
//View("deberia...")
            if ::lFromListBox
//View("2")
               cTemp := ::oListBox:GetValue( oColumn:Name )
//View( ::oListBox:GetValue("Nombre") )
               if Empty(cTemp)
                  cTemp := ::oListBox:oModel:oTreeView:GetAutoValue( aColumn:__EnumIndex() )
               endif
               if ValType(cTemp)="C"
                  cTemp := ALLTRIM( cTemp )
               endif
            else
View( "aqui...  revisar. (model_abm.prg)" )
               cTemp := CStr( ::oModel:oGtkModel:oTreeView:GetAutoValue( aColumn:__EnumIndex() ) )
            endif
//View( iif( !Empty(cTemp), ALLTRIM( cTemp ), cTemp ) )

            ::hOldValues[ oColumn:Name ] := cTemp //iif( !Empty(cTemp), cTemp, cTemp )
         Else
            //? "no hay fila seleccionada"
            //if ::oModel:oTreeView:IsGetSelected()
            //  ? ::oModel:oTreeView:ClassName()," buscando columna ", aColumn:__EnumIndex()
            cTemp := "" //AllTrim( CStr( ::oModel:oTreeView:GetAutoValue( aColumn:__EnumIndex() ) ) )
            
            //endif
            ::hPreValues[ oColumn:Name ] := cTemp
         EndIf

       
         /* Preparando Elementos Visuales */
         DEFINE BOX ::oBoxes:tmp OF oBoxTmp VERTICAL EXPAND FILL SPACING 1 CONTAINER

         DEFINE EVENTBOX oEventBox OF ::oBoxes:tmp EXPAND FILL
                //EXPAND FILL
                oEventBox:Style( ::cColorLabel, BGCOLOR, STATE_NORMAL )
                
         DEFINE LABEL oWidGetTmp TEXT oColumn:description + ": " MARKUP ; 
                FONT ::oFont ;
                OF  oEventBox CONTAINER ; //::oBoxes:tmp ; //oBoxTmp ;
                HALIGN .01 //JUSTIFY GTK_JUSTIFY_RIGHT

                HSet( ::hWidGet, oColumn:Name+"_label", oWidGetTmp )
                
                if !oColumn:Viewable ; oWidGetTmp:Hide() ; endif
                //oWidGetTmp:Style( "white", FGCOLOR, STATE_NORMAL )

                //oWidGetTmp:SetJustify( GTK_JUSTIFY_LEFT )
                //oWidGets:Add( "label_" + oColumn:Name , oWidGetTmp )

         //oWidGetTmp := ::Add( oColumn:name, nil )
         Do Case
            Case oColumn:reference .and. ALLTRIM( UPPER( oColumn:ref_descriptor ) ) = "COMBOBOX"
               // -- traemos los valores para el combo
               aCombo := {}
               aComboValues := oModel:Clasf2Array( oColumn:Ref_Link, oColumn:Ref_Table )
               AEVAL( aComboValues, {|lin| AADD(aCombo, lin[2]) } )
              
               DEFINE COMBOBOX oWidGetTmp VAR cTemp ;
                      ITEMS aCombo ;
                      OF ::oBoxes:tmp EXPAND FILL


            Case oColumn:reference .and. ALLTRIM( UPPER( oColumn:ref_descriptor ) ) != "COMBOBOX"
               cScript := "oTpuy:RunXBS('"+oColumn:ref_scriptname+"')"
               //cScript := {| cCadena | cTmp := "oTpuy:RunXBS("+cCadena+")", &cTmp }
               // No funciona enviando el nombre del script como parametro.. llega NIL al metodo RUN. (RIGC)
               if oColumn:picture != NIL
                  //DEFINE GET oWidGetTmp VAR cTemp 
                  DEFINE ENTRY oWidGetTmp VAR cTemp ;
                      ACTION &cScript ;
                      PICTURE oColumn:Picture ;
                      RIGHT BUTTON  GTK_STOCK_FIND ;
                      OF ::oBoxes:tmp EXPAND FILL 

               else
                  DEFINE ENTRY oWidGetTmp VAR cTemp ;
                      ACTION &cScript ;
                      RIGHT BUTTON  GTK_STOCK_FIND ;
                      OF ::oBoxes:tmp EXPAND FILL 
               endif
               //g_object_set_property( oWidGetTmp:pwidget, "overwrite-mode", .T. )
               //oWidgetTmp:Connect("activate",, {||msginfo("activado")} )
               //oWidGetTmp:OnKeyPressEvent( {||msginfo("prueba"),.t.} )
               //oWidGetTmp:Connect( "key-press-event", {||msginfo("prueba")} )
               //gtk_widget_grab_focus( oWidgetTmp:pWidget )
               //gtk_editable_select_region( oWidgetTmp:pWidget, 0, 0 )
               //gtk_signal_connect( oWidgetTmp:pWidget, "", {||msginfo("probando")} )

               /*para que se active el action del get al presionar enter*/
               //oWidGetTmp:Set_Property( "seconday_icon_sensitive", .t. )
               //oWidGetTmp:Set_Property( "secondary_icon_activatable", .t. )
               oWidGetTmp:Set_Property( "activates_default", .t. )
               oWidGetTmp:Set_Property( "secondary-icon-tooltip-text", "Buscar..." )
               oWidGetTmp:SetMaxLength( oColumn:Len )
              

                      //ACTION (cScript :="oTPuy:RunXBS('"+oColumn:ref_scriptname+"')", &cScript ) ;

            Case oColumn:reference .and. !hb_IsNIL( oColumn:picture ) ;
                .and. !oColumn:Reference
                 //DEFINE GET oWidGetTmp VAR cTemp PICTURE oColumn:Picture OF oBoxTmp
                 DEFINE GET oWidGetTmp VAR cTemp PICTURE oColumn:Picture OF ::oBoxes:tmp EXPAND FILL

                 if oColumn:Type = "N"
                    oWidGetTmp:Justify(GTK_JUSTIFY_RIGHT)
                    oWidGetTmp:SetMaxLength(15)
                 endif
            


            Case ALLTRIM( UPPER( oColumn:picture ) ) = "BOOLEAN"  .or. ; 
                 oColumn:DbType = "boolean"
          
                 DEFINE CHECKBOX oWidGetTmp VAR cTemp;
                        OF ::oBoxes:tmp 

                    

            OTHER
                 DEFINE ENTRY oWidGetTmp VAR cTemp OF ::oBoxes:tmp EXPAND FILL
         ENDCASE

         if oColumn:lPassword .and. oWidGetTmp:ClassName()="GENTRY"
            oWidGetTmp:SetVisible(.f.)
         endif
         if lIni 
            oWidGetTmp:SetFocus()
            gtk_editable_select_region( oWidgetTmp:pWidget, -1, -1 )
            lIni := .f.
         endif


         /*Desactivamos la autoseleccion del contenido de los get 
           y posicionamos el cursor al final */
         if oWidGetTmp:ClassName="GENTRY"
               oWidgetTmp:SelectOnFocus( .f. )
               oWidGetTmp:OnFocus( {|o| gtk_editable_select_region( o:pWidget,-1,-1 ) } )
         endif

         /* Ocultamos o Desactivamos... */

         if !oColumn:Viewable 
            oBoxTmp:Hide()
            oWidGetTmp:Hide()
         endif
         if !oColumn:Editable 
            oBoxTmp:Show()
            oWidGetTmp:Show()
//            if hb_HHasKey( ::hWidget[ oColumn:Name + "_label" ] )
               ::hWidget[oColumn:Name+"_label"]:Show()
//            endif
            oWidGetTmp:Disable()
         endif

         HSet( ::hWidGet, oColumn:Name, oWidGetTmp )
         if !::oBoxes:IsDef( oColumn:Name )
            ::oBoxes:Add( oColumn:Name, oBoxTmp )
         endif

         oColumn:oBox := oBoxTmp
         oColumn:oEventBox := oEventBox


         cTemp := ""

else
MsgInfo( aColumn[COL_NAME] )
View( ::oModel:IsDef( aColumn[COL_NAME] ) )
      endif
   NEXT

   if !Empty( ::hOldValues )
      ::hPreValues := ::hOldValues
   endif

   ::nAncho := ::nAncho * 16  // Aproximado necesario para mostrar bien el ancho pantalla
   If ::nAncho > 600
      ::nAncho := 600
   EndIf

return Self



METHOD GET(cField) CLASS TPY_ABM2
   Local uRes
   
   IF ::oGet:IsDef( cField )
      uRes := ::oGet:Get(cField)
   ENDIF

Return uRes



METHOD GETVALUE(cField) CLASS TPY_ABM2

   Local cValue, nPosCol
   Local cClassName 

   if hb_HHasKey( ::hWidget, cField )

      cClassName := ::hWidget[cField]:ClassName()

      Do Case
      Case cClassName = "GENTRY" .or. cClassName = "GGET"
         cValue :=  ALLTRIM( ::hWidget[ cField ]:GetText() )
      Case cClassName = "GCHECKBOX"
         cValue :=  ::hWidget[ cField ]:GetValue() 
      EndCase

   endif
/*
   IF ::oGet:IsDef(cField)
   
      cValue := ::oGet:Get(cField):GetValue()

   ELSEIF ::oVar:IsDef(cField)
   
      cValue := ::oVar:Get(cField)

   ELSE
   
      nPosCol := ASCAN( ::oModel:aStruct, {|a| a[1]=cField } )
   
      If nPosCol>0
         cValue := ::oModel:aItems[::nRow,nPosCol]

      Else
//         View("No está")
      EndIf
      
   ENDIF
   
//   View(ValType(cValue) )
*/
Return cValue



METHOD GETTITLE(cField) CLASS TPY_ABM2

   Local nPosFld
   
   nPosFld := ::PosField(cField)
   
   IF !hb_IsNIL(nPosFld)
      Return ::aFields[nPosFld,1]
   ENDIF
   
Return NIL



METHOD SET(nColumn,uField, cValue) CLASS TPY_ABM2
   
   Local nPos
   
   IF ValType(uField)="N"
      nPos := uField
      IF uField > 0
         ::oForm:aFields[nPos,nColumn] := cValue
         Return .T.
      ENDIF

   ELSEIF ValType(uField)="C"
   
      Return ::oModel:ColSet( uField, nColumn, cValue )
   
   ENDIF

Return .F.



METHOD END( lForce ) CLASS TPY_ABM2

   DEFAULT lForce To .t.

   If !::lEndSilence
      If !MsgNoYes( "¿Realmente Desea Cerrar el Formulario?","Por favor confirme." )
         Return .f.
      Else
         ::lEndSilence := .t.
      EndIf
   EndIf

   If hb_IsBlock( ::bEnd ) .and. !Eval(::bEnd)
      Return .f.
   Endif

   ::oWnd:Modal(.f.)
   If lForce
      If hb_IsObject( ::oWnd )
         ::oWnd:End()
      Endif
   EndIf

   ::Release()
RETURN .t.






#define  ABM_WIDGET            ::aGet[x2]

#define  ABM_WGTYPE            ::aReg[x,1]
#define  ABM_WG_LABEL          ::aReg[x,2,1]
#define  ABM_WG_BCODE          ::aReg[x,2,2]
#define  ABM_WG_LEN            ::aReg[x,2,3]
#define  ABM_WG_PICT           ::aReg[x,2,4]
#define  ABM_WG_VALID          ::aReg[x,2,5]
#define  ABM_WG_FIELDNAME      ::aReg[x,2,6]

METHOD ACTIVE( bAction, bInit ) CLASS TPY_ABM2

   ::aGet := Array(::aCantGet())
   ::bAction := bAction
   ::bInit   := bInit
   
   /* Caja Principal */
   //DEFINE BOX ::oBoxes:oBoxMain OF ::oBox EXPAND FILL //HOMOGENEOUS

   If !::lImage
      If hb_IsObject( ::oImage )
         ::oImage:End()
         ::oSeparator:End()
      EndIf
   EndIf

   If !::lButton .and. hb_IsOBject( ::oBoxes:oBoxBtns ) ; ::oBoxes:oBoxBtns:Hide() ; EndIf

//   DEFINE BOX ::oBoxes:oBoxTable VERTICAL OF ::oBoxes:oBoxMain EXPAND FILL HOMOGENEOUS

/*
   if ::lFix .and. ::nRows > 0
      DEFINE TABLE ::oBoxes:oTable ROWS ::nRows COLS 2 OF ::oBoxes:oBoxTable
   endif
*/

/* Esto debo revisarlo con calma... y definir si realmente va aqui o dejarlo al crear el abm. */
/*
   FOR EACH aColumn IN ::oModel:aTpyStruct
      
      if ::oModel:IsDef( aColumn[COL_NAME] )
         oColumn := ::oModel:Get(aColumn[COL_NAME])

         if !hb_IsNIL( ::cGlade )
            cIdGlade := oColumn:Container
            if Empty( cIdGlade ) .or. hb_IsNIL( cIdGlade ) .or. cIdGlade="NIL" 
                 
               DEFINE BOX oBoxTmp OF ::oBoxes:oBoxTable EXPAND FILL HOMOGENEOUS

            else

               DEFINE BOX oBoxTmp OF ::oBoxes:oBoxTable ;
                      ID cIdGlade RESOURCE ::cGlade

            Endif
         else
            DEFINE BOX oBoxTmp OF ::oBoxes:oBoxTable VERTICAL EXPAND FILL
         endif 
         
         oBoxTmp:SetBorder( 5 )
 

         if oColumn:Viewable .or. oColumn:Editable

            DEFINE LABEL oWidGetTmp TEXT oColumn:Description + ": " ;
                   OF oBoxTmp 

                   oWidGets:Add( "label_" + oColumn:Name , oWidGetTmp )

            Do Case
               Case !Empty( oColumn:Picture ) .OR. !hb_IsNil( oColumn:Picture )
                    //DEFINE GET oWidGetTmp VAR cTemp PICTURE oColumn:Picture OF oBoxTmp
                    DEFINE ENTRY oWidGetTmp VAR cTemp PICTURE oColumn:Picture ;
                           OF oBoxTmp EXPAND FILL

                    if oColumn:Type = "N"
                       oWidGetTmp:Justify(GTK_JUSTIFY_RIGHT)
                       oWidGetTmp:SetMaxLength(15)
                    endif

                    if oColumn:lPassword ; oWidGetTmp:SetVisible(.f.) ; endif
               

               Case Empty( oColumn:Picture ) .OR. hb_IsNil( oColumn:Picture )


               Case Alltrim(Upper( oColumn:Picture ))="BOOLEAN" .OR. ;
                    oColumn:DbType = "boolean"
             
                    DEFINE CHECKBOX oWidGetTmp VAR cTemp;
                           OF oBoxTmp 

               Other
                    DEFINE ENTRY oWidGetTmp VAR cTemp OF oBoxTmp EXPAND FILL
                    if oColumn:lPassword ; oWidGetTmp:SetVisible(.f.) ; endif
            EndCase

            ::oBoxes:Add( oColumn:Name, oBoxTmp )

         endif

      endif

   NEXT
*/



   If ::lButton

      If !::lBarBtn

         ::oBoxes:oBoxBtns:End() 

         DEFINE BOX ::oBoxes:oBoxBtns OF ::oBox ;
                /*EXPAND FILL*/ HOMOGENEOUS;
                SPACING 5

         DEFINE BUTTON ::hButtons["oSave"] TEXT "Guardar" ;
                FROM STOCK GTK_STOCK_SAVE ;
                ACTION ::Save() ;
                OF ::oBoxes:oBoxBtns  

         DEFINE BUTTON ::hBUttons["oCancel"] TEXT "Cancelar" ;
                FROM STOCK GTK_STOCK_CANCEL ;
                ACTION (::lEndSilece:=.t., ::End()) ;
                OF ::oBoxes:oBoxBtns


      Else

         DEFINE TOOLBUTTON ::hButtons["oSave"] TEXT "Guardar" ;
                FROM STOCK GTK_STOCK_SAVE ;
                ACTION ::Save() ;
                OF ::oBoxes:oBoxBtns  
/*
      DEFINE BOX ::hButtons["otro"] OF ::hButtons["oSave"]

      DEFINE LABEL ::hButtons["prueba"] TEXT "prueba" ;
             OF ::hButtons["otro"]

//      DEFINE IMAGE ::hButtons["iSave"] FILE oTpuy:cImages+"save_red.png" OF ::hButtons["oSave"]
*/
         DEFINE TOOLBUTTON ::hBUttons["oCancel"] TEXT "Cancelar" ;
                FROM STOCK GTK_STOCK_CANCEL ;
                ACTION (::lEndSilece:=.t., ::End()) ;
                OF ::oBoxes:oBoxBtns

      EndIf
         DEFINE TOOLTIP WIDGET ::hButtons["oSave"  ] TEXT "Guarda los Valores en Base de Datos."
         DEFINE TOOLTIP WIDGET ::hButtons["oCancel"] TEXT "Cancela cualquier acción y cierra el formulario."
   EndIf   



   If ::lWnd
//      If IsNIL(::uGlade)
         ::oWnd:Modal( ::lModal )
         ACTIVATE WINDOW ::oWnd CENTER ;
                  VALID ( ::End( .f. ) )

//      EndIf
   EndIf

return Self


/*
 *  Metodo SAVE()  
 */
METHOD SAVE() CLASS TPY_ABM2
   Local lRet
   Local aColumn, oColumn
   Local cClassName, cValue, uValue
//   Local hNewValues := Hash()
   Local aIter := ARRAY( 4 )
   Local pPath
   Local aUpdate := {}

   lRet := Eval( ::bSave,Self )

   If !hb_ISLogical( lRet )
      MsgAlert( MSG_RETURN_NO_LOGIC, MSG_ALERTA )
      lRet := .F.
   Else
   
      If !lRet
         Return lRet
      EndIf

//? ::oModel:cQuery
//View( ::oModel:aStruct )
//View( ::oModel:aData )
      /* Creamos Hash con Valores Nuevos para generar Query de Actualización */
      FOR EACH aColumn IN ::oModel:aTpyStruct
          oColumn := ::oModel:Get( aColumn[COL_NAME] )

          cValue := ""
          if hb_HHasKey( ::hWidget, oColumn:Name ) 
             cClassName := ::hWidget[oColumn:Name]:ClassName() 
          else
             cClassName := ""
             if !::lNew
                cValue := ::oListBox:GetValue( oColumn:Name )
             endif
          endif


          /* Alta/Adicion */
          if Empty( ::hOldValues )  
             Do Case
             Case cClassName = "GENTRY" .or. cClassName = "GGET"
                cValue :=  ALLTRIM( ::hWidget[oColumn:Name]:GetText() )
             Case cClassName = "GCHECKBOX"
                cValue :=  ::hWidget[oColumn:Name]:GetValue() 
             EndCase

             hb_HSet( ::hNewValues, oColumn:Name, cValue )
/*
if ValType(cValue) = "C"
  MsgInfo("Valor nuevo...  " + oColumn:Name + " = " + cValue)
else
  MsgInfo("Valor nuevo...  " + oColumn:Name + " = " + CStr(cValue))
endif
*/             
          /* Modificar */
          else  

             if oColumn:Editable

                Do Case
                Case cClassName = "GENTRY" .or. cClassName = "GGET" 
                   
                   cValue := ALLTRIM( ::hWidget[oColumn:Name]:GetText() )
//View( cValue )
                   hb_HSet( ::hNewValues, oColumn:Name, cValue )
//? hb_valtoexp( ::hOldValues )
//? ValType( ::oModel:oTreeView )
//                   if !Empty( ::hOldValues )
Do Case
   Case oColumn:Type ="L"
      uValue := IIF( cValue = "S" .or. cValue = "T", .t., .f. )
   Case oColumn:Type ="D"
      uValue := DTOC(CTOD( cValue ))
   Other
      uValue := cValue
EndCase
                   if !(::hOldValues[ oColumn:Name ] == uValue )
                      AADD( aUpdate, { aColumn:__EnumIndex, uValue } )
                   endif
//                   else
//? "Insertar valores..."
//                   endif          
                Case cClassName = "GCHECKBOX"
                   uValue := ::hWidget[oColumn:Name]:GetValue()
                   hb_HSet( ::hNewValues, oColumn:Name, uValue )
                   if !(::hOldValues[ oColumn:Name ] == uValue )
                      AADD( aUpdate, { aColumn:__EnumIndex, uValue } )
                   endif
                Other
? ::hWidget[oColumn:Name]:ClassName()  
                EndCase

             else
                //-- puede ser no editable pero es posible que se asignara 
                //   un valor desde el script de trabajo.

//MsgInfo( ::oModel:GetValue( oColumn:Name ), oColumn:Name )
                uValue := ::oModel:GetValue( oColumn:Name )
//View( ::hNewValues )
                hb_HSet( ::hNewValues[ oColumn:Name ], uValue )
             endif

          endif

      NEXT

//View( aUpdate )
      if ::lNew 
//View( ::hNewValues )
         if !::oModel:Insert(::hNewValues) 
            return .f. 
         endif

      else
View("aqui")
View( ::hNewValues )
         //-- Mandamos a Actualizar el Modelo
         if ::oModel:Set( ::hNewValues, ::hOldValues ) .and. ;
            ::oModel:oTreeView:IsGetSelected(aIter)
   
            pPath := ::oModel:oTreeView:GetPath( aIter )
            FOR EACH aColumn IN aUpdate
               ::oModel:oTreeView:SetValue( aColumn[1], aColumn[2], pPath, ::oModel:oGtkModel )
            NEXT
            gtk_tree_path_free( pPath )

            ::GenOldValues()

            //::oModel:QryRefresh()
            //::oModel:Refresh()
         endif
      endif
      
      if hb_IsBlock( ::bPosSave )
         return EVAL( ::bPosSave, self )
      endif

   EndIf

Return lRet


METHOD GENOLDVALUES()  CLASS TPY_ABM2
   Local aColumn, oColumn, cTemp

   FOR EACH aColumn IN ::oModel:aTpyStruct
      
      if ::oModel:IsDef( aColumn[COL_NAME] )
         oColumn := ::oModel:Get(aColumn[COL_NAME])
         
//         if oColumn:Viewable .and. oColumn:Editable

            if ::nRow > 0 .or. ::lFromListBox
               //cTemp := AllTrim( CStr( ::oModel:oGtkModel:oTreeView:GetValue( aColumn:__EnumIndex(), "", pPath, @aIter ) ) )
               if ::lFromListBox
                  cTemp := ::oListBox:GetValue( oColumn:Name )
               else
                  cTemp := CStr( ::oModel:oGtkModel:oTreeView:GetAutoValue( aColumn:__EnumIndex() ) ) 
               endif
               ::hOldValues[ oColumn:Name ] := iif( ValType(cTemp)="C", ALLTRIM( cTemp ), cTemp )
            endif

//         endif
      endif
   NEXT
RETURN .t.


METHOD ACANTGET(  ) CLASS TPY_ABM2
   Local x, i
   Local x2 := 0

     // Vamos a usar una tabla ;-)
     for x=1 to Len(::aReg)

      if ::aReg[x,1] == "Get"
      elseif ::aReg[x,1] == "Combo"
      elseif ::aReg[x,1] == "Button"
      elseif ::aReg[x,1] == "ContainerGet"
//View(::aReg[x,2])
        for i=1 to Len(::aReg[x,2])
//        view(::aReg[x,2,])
          if ::aReg[x,2,i,1] == "Get"
          elseif ::aReg[x,2,i,1] == "Combo"
          elseif ::aReg[x,2,i,1] == "Button"
          endif
            x2++
        next
        x2--
      end
      x2++
     next

RETURN x2



METHOD UPDATEBUFFER( ) CLASS TPY_ABM2
   Local x, ctext

   for x=1 to Len(::aGet)
     if ::aGet[x]:Classname() == "GGET"
       ::aGet[x]:Refresh( )
     elseif ::aGet[x]:Classname() == "PC_GET"
       ::aGet[x]:Refresh( )
     elseif ::aGet[x]:Classname() == "GCOMBOBOX"
       ctext := eval(::aGet[x]:bSetGet)
       if !Empty(ctext)
         ::aGet[x]:SelectItem( ctext )
       else
         ::aGet[x]:SetActive( 1 )
       end
     else
       //::aGet[x]:SelectItem( eval(::aGet[x]:bSetGet) )
     end
   next

RETURN nil



METHOD POSFIELD( cField ) CLASS TPY_ABM2

   Local n:=0
   Local aReg:={}

   FOR EACH aReg IN ::aReg

      n++

      If UPPER( aReg[1] ) = "COMBO" .OR. ;
         UPPER( aReg[1] ) = "GET"

         If aReg[2,6] = cField   

           Return n
      
         EndIf
      EndIf
   
   NEXT

Return NIL



METHOD ONERROR( uValue ) CLASS TPY_ABM2
  Local cMsg   := Lower( ALLTRIM(__GetMessage()) )

  If ::IsDef( cMsg )
     Return HGet( ::hWidget, cMsg )
  EndIf

RETURN uValue



//EOF

