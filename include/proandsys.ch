/* $Id: proandsys.ch,v 1.0 2008/10/23 14:44:02 riztan Exp $*/
/*
	Copyright © 2008  Riztan Gutierrez <riztan@gmail.com>

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

#include "tepuy.ch"
#include "proandsys_lang_es_ve.ch"
#include "postgres.ch"

#define MSGRUN_NONE            0
#define MSGRUN_CONNECTING      1
#define MSGRUN_IMPORTDOC       2
#define MSGRUN_EXPORTDOC       3
#define MSGRUN_DELETE          4



/*
  Definiciones varias a fin sutituir comandos nativos de xHarbour para la interfaz
  grafica.  Riztan
*/

// puts y print  para cierta compatibilidad con ruby.

#command ? [ <xlist,...> ] => View( [ \{ <xlist> \} ] )
#command puts  [ <xList,...> ] => [? <xList>  ]
	   
#command print [ <xList,...> ] => [View(\{<xList>\}) ]
#command ??    [ <xList,...> ] => [View(\{<xList>\}) ]


/* Esto debe ir en gclass...  se coloca temporalmente por acá mientras se 
   termina de definir.
 */
#xcommand DEFINE BOXGRID <oBox>  ;
                 MODEL <pDataModel> ;
               [ <lHomogeneous: HOMOGENEOUS, HOMO> ] ;
               [ SPACING <nSpacing> ];
               [ <lMode: VERTICAL> ] ;
               [ OF <oParent> ] ;
               [ LABELNOTEBOOK <uLabelBook> ];
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
      => ;
       <oBox> := GBoxGrid():New( <pDataModel>, <.lHomogeneous.>, <nSpacing>, <.lMode.>, <oParent>, <.lExpand.>,;
                  <.lFill.>, <nPadding>, <.lContainer.>, <x>, <y>, <uLabelBook>,;
                  <.lSecond.>, <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
                  <xOptions_ta>, <yOptions_ta>, <cId>, <uGlade> )

