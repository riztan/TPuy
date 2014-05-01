/* $Id: menu.prg,v 1.0 2009/11/17 13:39:41 riztan Exp $*/
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

/** \file menu.prg.
 *  \brief Programa Inicial  
 *  \author Riztan Gutierrez. riztan@gmail.com
 *  \date 2009
 *  \remark ...
*/

/** \mainpage Archivo Principal (index.html)
 *
 * \section intro_sec Introduccion
 *
 * Esta es la introducción.
 *
 * \section install_sec Instalacion
 *
 * \subsection step1 Paso 1: Inicializando Variables
 *
 * etc...
 */

#include "proandsys.ch"
#include "gclass.ch"


// GLOBAL oTpuy  /** \var GLOBAL oTpuy. Objeto Principal oTpuy. */

memvar oTpuy

/** Creación del Menu a Partir de la Base de Datos.
 *
 */
FUNCTION Create_Menus( oBoxMenu )
    Local oMenuBar, oMenu, Tearoff
    Local oImage, oFont, oMi, oMiMenu
    Local oImgMain, oImgScript, oImgScrExec, oImgScrEdit
    Local oImg1
    Local oConn := oTpuy:aConnection[1], oQuery
    Local cTable := oTpuy:cMainSchema+"base_modules"
    Local aModules, aImages, i
    Local oMenuItem, oMenuItem2, oMenuItem3
    Local oSubMenu, oSubMenu2
    Local cQuery


    IF !HB_ISOBJECT(oConn) 
       RETURN NIL
    ENDIF

/*
    If oConn:ViewExists("v_base_modules")
       cTable := "v_base_modules"

    Else
       If oConn:TableExists("base_modules")
          MsgAlert("No Existe la Vista v_base_modules, sin embargo "+;
                   "la tabla base_modules si existe. Deberia intentar "+;
                   "crear la vista integrada de modulos. ", "Atención")
       EndIf
    EndIf
*/    
    cTable := 'tepuy.modules()'
    cQuery := "select mod_id, mod_description, mod_image_name "+;
                           "from "+cTable+" order by mod_order"
    oQuery := oConn:Query( cQuery )

//                           DataToSQL(oConn:Schema)+" or lower(mod_schema)='all' ) order by mod_order" )
    aModules := oQuery:aData


    If Empty( aModules )
       MsgAlert("No hay información de modulos","Error al generar Menu.")
       Return NIL
    EndIf

    aImages := ARRAY( LEN(oQuery:aData) )

    // Ya tenemos conexion e Información, procedemos a generar el menu.

    DEFINE FONT oFont NAME "Verdana 12" 

    DEFINE IMAGE oImage FILE "../../images/gnome-logo.png"
    DEFINE IMAGE oImgScript FILE oTpuy:cImages+"scripts-04-48x48.png"
    DEFINE IMAGE oImg1 FILE oTpuy:cImages+"main_32x32.png"
    DEFINE IMAGE oImgMain FROM STOCK GTK_STOCK_PREFERENCES 

    DEFINE BARMENU oMenuBar OF oBoxMenu
       MENUBAR oMenu OF oMenuBar
       
/*       
               MENUITEM IMAGE ROOT oMenuItem ;
                              TITLE "_Principal" ;
                              IMAGE oImg1 ;
                              MNEMONIC OF oMenu

              // oMenuItem:SetFont( oFont )
              // Tearoff
              // MENU TEAROFF OF oMenu

               MENUITEM IMAGE TITLE "Scripts" oMenuItem2 ;
                              IMAGE oImgScript OF oMenu
//               oMenuItem2:SetFont( oFont )

               SUBMENU oSubMenu OF oMenuItem2
                  MENUITEM IMAGE FROM STOCK GTK_STOCK_EXECUTE TITLE "Ejecutar" ;
                                 ACTION ChooserExec() OF oSubMenu
                  MENUITEM IMAGE FROM STOCK "gtk-edit" TITLE "Editar" ;
                                 ACTION FileChooser() OF oSubMenu
//                  MENU SEPARATOR OF oSubMenu // = gtk_separator_menu_item_new()


               MENUITEM IMAGE TITLE "Configuración" oMenuItem3 ;
                              OF oMenu
                  SUBMENU oSubMenu2 OF oMenuItem3
                     MENUITEM ; //IMAGE FROM STOCK GTK_STOCK_PREFERENCES;
                                    TITLE "Personalizar Columnas" ;
                                    ACTION oTpuy:RunXBS('base_fields') ;
                                    OF oSubMenu2


               MENU SEPARATOR OF oMenu // = gtk_separator_menu_item_new()


               MENUITEM TITLE "Modulos"   OF oMenu
    ACTIVATE MENUBAR oMenu
*/

    oQuery:GoTop()
    DO While !oQuery:Eof() 

       MenuAddRoot( oMenuBar, oMenu, oQuery:Field("mod_id"), ;
                                     oQuery:Field("mod_description"), ;
                                     oQuery:Field("mod_image_name") )

       oQuery:Skip()
    EndDo

/*
    MENUITEM IMAGE ROOT oMenuItem ;
                   TITLE "_Salida" ;
                   FROM STOCK "gtk-quit" ;
                   ACTION oTpuy:Exit();
                   MNEMONIC OF oMenu

              // oMenuItem:SetFont( oFont )
              // Tearoff
              // MENU TEAROFF OF oMenu

    ACTIVATE MENUBAR oMenu
*/

Return NIL



/** Funcion para crear un Menu en la Barra a partir de los Modulos en
 *  en la base de datos.
 *
 */
Function MenuAddRoot( oMnuParent, oMenu, cId, cDescri, cImage, lSub )

   Local oImage

   Default lSub := .T.

   cImage := oTpuy:cImages+Alltrim(cImage)
   cDescri := Alltrim(cDescri)

   IF !Empty(cDescri)

      MENUBAR oMenu OF oMnuParent

      IF !Empty(cImage)

         DEFINE IMAGE oImage FILE cImage

         MENUITEM IMAGE ROOT TITLE cDescri ;
                        IMAGE oImage ;
                        MNEMONIC OF oMenu

      ELSE

         MENUITEM IMAGE ROOT TITLE cDescri MNEMONIC OF oMenu

      ENDIF


      If lSub
         MenuAddItem( oMenu, cId, "mnu_level = '1'", 1 )
      EndIf

      ACTIVATE MENUBAR oMenu

   ENDIF

Return NIL



/** Funcion para crear un Item en un Menú. Si el item indica que tiene
 *  hijos (mnu_child_tf), crea el submenu y se llama a si mismo.
 *
 */
Function MenuAddItem( oMnuParent, cId, cCondition, nLevel )

   Local oImage, oSubMenu, oItem, cQuery, cTable
   Local oConn := oTpuy:aConnection[1], oQuery, aItem
   Local cDescri:="", cImage:="", cSubMnu:=""
   Local cGroup:="", cMnuId:="", cValid, lSubMnu := .F.
   Local cAction, cFileAction, lStock := .F.

   Default cCondition := ""

   cTable := oTpuy:cMainSchema+"v_mainmenu "

   If oConn:ViewExists("v_mainmenu")
      cTable := "v_mainmenu"
   EndIf
   
   cQuery := "select * from "+cTable+" where "
   cQuery += "mod_id = "+DataToSql( Alltrim(cId) )
   If nLevel > 1
      cQuery += " and mnu_level = "+DataToSQL(Alltrim(CStr(nLevel)))
   EndIf

//   cQuery += "(mnu_schema="+DataToSQL(oConn:Schema)+" or lower(mnu_schema)='all' ) and "

   If !Empty(cCondition)
      cQuery += " and "+cCondition
   EndIf

   oQuery := oConn:Query( cQuery )

//View(cQuery)
//View(oQuery:aData)

   oQuery:GoTop()
   DO While !oQuery:Eof() 
   
      cImage := oQuery:Field("mnu_image_name")

      IF !Empty( cImage ) .AND. ;
         !( cImage == "NIL" )
         
         IF LEFT( cImage, 4 )="gtk-"
            lStock := .t.
         ELSE
            cImage := oTpuy:cImages + Alltrim( oQuery:Field("mnu_image_name") )
         ENDIF         
         
      ELSE
         cImage := ""
      ENDIF
      
//      View(cImage)
//      IF oQuery:Field("mnu_image_name") = NIL ; cImage := "" ; ENDIF
//      IF Empty(oQuery:Field("mnu_image_name")) ; cImage := "" ; ENDIF

      cDescri := IIF( !Empty(oQuery:Field("mnu_description")) , ; 
                     Alltrim( oQuery:Field("mnu_description") ), "" )

      lSubMnu := oQuery:Field("mnu_child_tf")

      cAction := IIF( !Empty(oQuery:Field("mnu_action")), ;
                     oQuery:Field("mnu_action"), "" )
      cFileAction := oTpuy:cXBScripts+Alltrim(cAction)

      IF !Empty( cDescri )

            IF !Empty(cImage)

               IF lStock
                  oImage := NIL
               ELSE
                  DEFINE IMAGE oImage FILE cImage
                  cImage := NIL
               ENDIF

                IF lSubMnu
                   MENUITEM IMAGE TITLE cDescri oItem ;
                                  IMAGE oImage  ;
                                  FROM STOCK cImage ;
                                  MNEMONIC OF oMnuParent
                ELSE
                   IF !FILE( cFileAction+".ppo" )
                      MENUITEM IMAGE TITLE cDescri oItem ;
                                     IMAGE oImage  ;
                                     FROM STOCK cImage;
                                     ACTION &cAction;
                                     MNEMONIC OF oMnuParent                    
                   ELSE
                      MENUITEM IMAGE TITLE cDescri oItem ;
                                     IMAGE oImage  ;
                                     FROM STOCK cImage ;
                                     ACTION oTpuy:RunXBS( cAction );
                                     MNEMONIC OF oMnuParent                                                         
                   ENDIF                                  
                ENDIF           

            ELSE

/*
                MENUITEM oItem TITLE cDescri ;
                         ACTION cAction ;
                         OF oMnuParent
*/                         
 
                IF !FILE( cFileAction+".ppo" )
                   MENUITEM oItem TITLE cDescri ;
                                  ACTION &cAction;
                                  MNEMONIC OF oMnuParent                    

                ELSE
                   MENUITEM oItem TITLE cDescri ;
                                  ACTION oTpuy:RunXBS( cAction );
                                  MNEMONIC OF oMnuParent  

                ENDIF                                  
            ENDIF
         
         IF lSubMnu

            cMnuId := Alltrim(oQuery:Field("mnu_id"))
            cGroup := Alltrim(oQuery:Field("mnu_group"))

            SUBMENU oSubMenu OF oItem

            MenuAddItem( oSubMenu, cId, "mnu_group = "+DataToSql(cGroup)+;
                                       " and mnu_id != "+DataToSql(cMnuId), nLevel+1 )

         ENDIF
         

      ENDIF

      oQuery:Skip()
   EndDo

RETURN NIL

//EOF

