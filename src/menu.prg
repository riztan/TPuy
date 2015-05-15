/* $Id: menu.prg,v 1.0 2014/07/19 20:48 riztan Exp $*/
/*
	Copyright © 2008-2014  Riztan Gutierrez <riztang@gmail.com>

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
 *  \brief Creacion de Menu  
 *  \author Riztan Gutierrez. riztan@gmail.com
 *  \date 2009
 *  \remark 2014
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
#include "hbclass.ch"


// GLOBAL oTpuy  /** \var GLOBAL oTpuy. Objeto Principal oTpuy. */

memvar oTpuy

/** Clase que instancia items para el menu en tpuy.
 *
 */
CLASS MNUITEM FROM TPUBLIC

   DATA lRoot     INIT .f.
   DATA nImgSize  INIT 24
   DATA oParent
   DATA oGtkItem  INIT NIL
   DATA oMenuBar
   DATA oImage

   METHOD New()
   METHOD FromHash() VIRTUAL

   METHOD AddItem( oItem )   INLINE  ::oSubItem:Add( oItem:cId, oItem ) 

   METHOD Activate()

   METHOD RefreshAll()

   METHOD End()       INLINE  ::oGtkItem:End()

   METHOD Enable()    INLINE  ::oGtkItem:Enable()
   METHOD Disable()   INLINE  ::oGtkItem:Disable()

ENDCLASS




METHOD New( lRoot, cId, cTitle, cAction, cImage, cValid, oParentItem )  CLASS MNUITEM

   Default lRoot to .f.

   ::Super:New(.t.,.f.,.f.)

   //hb_HKeepOrder( ::hVars, .T. )

   ::Add( "cId"     , cId     )
   ::Add( "cTitle"  , cTitle  )
   ::Add( "cAction" , cAction )
   ::Add( "cImage"  , cImage  )
   ::Add( "cValid"  , cValid  )
   ::Add( "oSubItem", TPublic():New(.t.,.f.,.f.) )

   //hb_HKeepOrder( ::oSubItem:hVars, .T. )

   ::lRoot := lRoot

   ::oParent := oParentItem

   if ::lRoot 
      ::nImgSize := ::nImgSize*2 
      ::Set("cAction","")
   endif


   /* Si este objecto es SubItem de otro */
   if hb_IsObject( oParentItem ) .and. oParentItem:ClassName() == "MNUITEM"  
      if !oParentItem:oSubItem:IsDef(::cId)
         oParentItem:oSubItem:Add( ::cId, self )
      endif

   endif

   ::lAutoAdd := .f.

RETURN Self



METHOD ACTIVATE( oParentMenu )

   local cAction := ::cAction
   local cValid  
   local hSubMenu, oSubMenu
   local oMenu, oParent, hSubItems, oItem
   local lSub := .f.

   if hb_IsObject(::oGtkItem) ; ::oGtkItem:End() ; endif

   if ::lRoot
      MENUBAR oMenu OF ::oParent
   else
      if hb_IsObject( oParentMenu )
         oMenu := oParentMenu
         if !Empty(::oSubItem:hVars)
            /* Evitamos accion en opcion con submenu */
            ::cAction := ""
         endif
      else
         oMenu := ::oParent
      endif
   endif

   cValid := ::cValid
   
   IF !Empty(::cImage) .and. !FILE( ::cImage )
      if FILE( oTpuy:cImages+::cImage ) 
         ::cImage := oTpuy:cImages+::cImage
      else
         if oTPuy:lNetIO .and. !Empty(oTPuy:rApp)
            GetImage( ::cImage )
            if FILE( oTpuy:cImages + ::cImage ) 
               ::cImage := oTpuy:cImages + ::cImage
            endif
         else
            ::cImage := oTpuy:cImages+"tpuy-logo.png"
         endif
      endif
   ENDIF


   IF !Empty(::cImage)

      DEFINE IMAGE ::oImage FILE ::cImage
      ::oImage:Adjust(::nImgSize)

      IF Empty(::cAction)
         if ::lRoot
            MENUITEM IMAGE ::oGtkItem ROOT TITLE ::cTitle ;
                     IMAGE ::oImage ;
                     MNEMONIC OF oMenu
         else
            MENUITEM IMAGE ::oGtkItem TITLE ::cTitle ;
                     IMAGE ::oImage ;
                     MNEMONIC OF oMenu
         endif
      ELSE

         if ::lRoot
            MENUITEM IMAGE ::oGtkItem ROOT TITLE ::cTitle ;
                     IMAGE ::oImage ;
                     ACTION &cAction ;
                     MNEMONIC OF oMenu
         else
            MENUITEM IMAGE ::oGtkItem TITLE ::cTitle ;
                     IMAGE ::oImage ;
                     ACTION &cAction ;
                     MNEMONIC OF oMenu
         endif

      ENDIF

   ELSE

      IF !Empty(::cAction)
         if ::lRoot
            MENUITEM IMAGE ::oGtkItem ROOT TITLE ::cTitle ;
                 ACTION &cAction MNEMONIC OF oMenu
         else
            MENUITEM IMAGE ::oGtkItem TITLE ::cTitle ;
                 ACTION &cAction MNEMONIC OF oMenu
         endif

      ELSE
         if ::lRoot
            MENUITEM IMAGE ::oGtkItem ROOT TITLE ::cTitle MNEMONIC OF oMenu
         else
            MENUITEM IMAGE ::oGtkItem TITLE ::cTitle MNEMONIC OF oMenu
         endif
      ENDIF

   ENDIF

   if empty(cValid) .or. (hb_IsNIL(cValid))
      ::oGtkItem:Enable()
   else
      if !&cValid
         ::oGtkItem:Disable()
      endif
   endif

   if hb_IsObject(::oSubItem) .and. ::oSubItem:ClassName()="TPUBLIC"
      hSubItems := ::oSubItem:hVars

      lSub := .f.

      FOR EACH oItem IN hSubItems

         if !::lRoot 
            if hb_IsObject( oItem )
//View("submenu! "+::oSubItem:ClassName() )
               if !lSub
                  SUBMENU oSubMenu OF ::oGtkItem
                  lSub := .t.
               endif
               oItem:Activate( oSubMenu )
            else
//View("no submenu! " + ::oSubItem:cId )
               oItem:Activate()
            endif
         else
            oItem:Activate( oMenu )
         endif

      NEXT
   endif

   if ::lRoot
      ACTIVATE MENUBAR oMenu
   endif

RETURN .t.



METHOD REFRESHALL()  CLASS MNUITEM
   local oItem
   ::Activate()

   FOR EACH oItem IN ::oSubItem:hVars
      oItem:Active( )
   NEXT
   
RETURN .t.


//EOF
