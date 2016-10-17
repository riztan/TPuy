/* $Id: main.prg,v 1.0 2008/10/23 14:44:02 riztan Exp $*/
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

/** \file main.prg.
 *  \brief Programa Inicial  
 *  \author Riztan Gutierrez. riztan@gmail.com
 *  \date 2008
 *  \remark Donde comienza la historia...
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

#include "hbmxml.ch"

EXTERNAL MXMLLOADSTRING
EXTERNAL MXMLDELETE

FUNCTION XMLtoHash( pRoot, cElement )
   Local pNode, hNext
   Local Map := {=>}

   if empty( cElement )
      pNode := pRoot
   else  
      pNode := mxmlFindElement( pRoot, pRoot, cElement, NIL, NIL, MXML_DESCEND )
   endif
     
   IF Empty( pNode )
      RETURN Map
   ENDIF

   hNext := mxmlWalkNext( pNode, pNode, MXML_DESCEND )
   Map :=  NodeToHash( hNext )

  return Map



FUNCTION NodeToHash( node  )
   Local hNext
   Local hHashChild := {=>}
   Local hHash := {=>}
   Local node2

   WHILE node != NIL
         
         IF mxmlGetType( node ) == MXML_ELEMENT
            if HB_HHASKEY( hHash, mxmlGetElement( node ) )
               if valtype( hHash[ mxmlGetElement( node ) ] ) <> "A"
                  hHash[ mxmlGetElement( node ) ] := mxmlGetOpaque( node )
               else
                 // Es un array, por lo tanto, no lo tocamos
               endif  
            else                  
               hHash[ mxmlGetElement( node ) ] :=  mxmlGetOpaque( node )
            endif  

            if empty( mxmlGetOpaque( node ) ) // Miramos dentro
               hNext := mxmlWalkNext( node, node, MXML_DESCEND )  
               if hNext != NIL
                  hHashChild :=  NodeToHash( hNext  )
                  // Correcion de Posible bug. Un elemento con espacios en blanco, deja descender un nivel!, cuando no debería!
                  // example  <element> </element>
                  if hHashChild != NIL .and. !empty( hHashChild )
                     if empty( hHash[ mxmlGetElement( node ) ] )
                        hHash[ mxmlGetElement( node ) ] := {}
                     endif  

                     if HB_MXMLGETATTRSCOUNT( node ) > 0
                        hHashChild[ mxmlGetElement( node ) + "@attr"] := HB_MXMLGETATTRS( node )
                      endif  
                      AADD( hHash[ mxmlGetElement( node ) ], hHashChild )
                  endif
                else
                   if HB_MXMLGETATTRSCOUNT( node ) > 0
                     if empty( hHash[ mxmlGetElement( node ) ] )
                        hHash[ mxmlGetElement( node ) ] := {}
                     endif  
                 AADD( hHash[ mxmlGetElement( node ) ], HB_MXMLGETATTRS( node ) )
                   endif
                endif
            else  
               if HB_MXMLGETATTRSCOUNT( node ) > 0
                  hHash[ mxmlGetElement( node ) + "@attr"] := HB_MXMLGETATTRS( node )
               endif  
            endif
         ENDIF   

         node := mxmlGetNextSibling( node )
                    
   END WHILE

return hHash


/*
 * 'type_cb()' - XML data type callback for mxmlLoadFile()...
 */

/* O - Data type */
/* I - Element node */

FUNCTION type_cb( hNode )

   LOCAL cType                            /* Type string */

   /*
    * You can lookup attributes and/or use the element name, hierarchy, etc...
    */

   IF Empty( cType := mxmlElementGetAttr( hNode, "type" ) )
      cType := mxmlGetElement( hNode )
   ENDIF

   SWITCH Lower( cType )
   CASE "integer" ;  RETURN MXML_INTEGER
   CASE "opaque"  ;  RETURN MXML_OPAQUE
   CASE "real"    ;  RETURN MXML_REAL
   ENDSWITCH

   RETURN MXML_TEXT


//EOF

