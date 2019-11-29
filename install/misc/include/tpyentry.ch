/*  $Id: tpyentry.ch,v 0.01 2015/10/02 22:38 riztan Exp $ */
/*
	Copyright © 2015  Riztan Gutierrez <riztang@gmail.org>

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


#define TPYENTRY_DOCUMENT   0
#define TPYENTRY_PORCENT    1
#define TPYENTRY_INTEGER    2
#define TPYENTRY_DECIMAL    3
#define TPYENTRY_MONEY      4
#define TPYENTRY_EMAIL      5
#define TPYENTRY_DATETIME   6
#define TPYENTRY_DATE       7
#define TPYENTRY_TIME       8
#define TPYENTRY_IP         9
#define TPYENTRY_OTHER      10




// Entry/Get
#xuncommand DEFINE ENTRY [ <oBtn> ]  ;
                 [ VAR <uVar> ];
                 [ <lPassword: PASSWORD> ] ;
                 [ PICTURE <cPicture> ];
                 [ VALID <bValid> ];
                 [ COMPLETION <aCompletion> ];
                 [ FONT <oFont> ];
                 [ <lExpand: EXPAND> ] ;
                 [ <lFill: FILL> ] ;
                 [ PADDING <nPadding> ];
                 [ <lContainer: CONTAINER> ] ;
                 [ OF <oParent> ] ;
                 [ ID <cId> ;
                 [ RESOURCE <uGlade> ] ];
                 [ POS <x>,<y>  ];
                 [ LABELNOTEBOOK <uLabelBook> ];
                 [ <lEnd: INSERT_END> ] ;
                 [ <lSecond: SECOND_PANED > ] ;
                 [ <lResize: RESIZE > ] ;
                 [ <lShrink: SHRINK > ] ;
                 [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
                 [ ACTION <bAction> ];
                 [ LEFT BUTTON <ulButton> ];
                 [ RIGHT BUTTON <urButton> ];
      => ;
  [ <oBtn> := ] GEntry():New( bSetGet( <uVar> ), <cPicture>, [ \{|o| <bValid> \} ],;
                   <aCompletion>, <oFont>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding>,<.lContainer.>,;
                   <x>,<y>, <cId>, <uGlade>, <uLabelBook>,<.lPassword.>,;
                   <.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                   <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta>,;
                   [ \{| this,nPos | <bAction> \} ], <ulButton>, <urButton> )


// Modificacion para evitar conflicto con la definicion de comboboxentry
// y mantener compatibilidad con los tipos de entry elaborados en tpuy.
// RIGC - 2015-12-13
#xtranslate DEFINE DOCUMENT ENTRY  => DEFINE ENTRY TYPE DOCUMENT
#xtranslate DEFINE PORCENT ENTRY   => DEFINE ENTRY TYPE PORCENT
#xtranslate DEFINE INTEGER ENTRY   => DEFINE ENTRY TYPE INTEGER
#xtranslate DEFINE DECIMAL ENTRY   => DEFINE ENTRY TYPE DECIMAL
#xtranslate DEFINE MONEY ENTRY     => DEFINE ENTRY TYPE MONEY
#xtranslate DEFINE EMAIL ENTRY     => DEFINE ENTRY TYPE EMAIL
#xtranslate DEFINE DATETIME ENTRY  => DEFINE ENTRY TYPE DATETIME
#xtranslate DEFINE DATE ENTRY      => DEFINE ENTRY TYPE DATE
#xtranslate DEFINE TIME ENTRY      => DEFINE ENTRY TYPE TIME
#xtranslate DEFINE IP ENTRY        => DEFINE ENTRY TYPE IP
#xtranslate DEFINE OTHER ENTRY     => DEFINE ENTRY TYPE OTHER

// Entry/Get
#xcommand DEFINE ENTRY [TYPE <cType>] [ <oBtn> ]  ;
                 [ VAR <uVar> ];
                 [ <lCalendar: CALENDAR> [FORM <oForm> ] ];
                 [ <lPassword: PASSWORD> ] ;
                 [ FILTER <cRegExFilter> ] ;
                 [ MSGWIDGET <oMsgWidget> ];
                 [ PICTURE <cPicture> ];
                 [ VALID <bValid> ];
                 [ LENGTH <nLen> [ <lZero: ZERO> ] ];
                 [ COMPLETION <aCompletion> ];
                 [ FONT <oFont> ];
                 [ <lExpand: EXPAND> ] ;
                 [ <lFill: FILL> ] ;
                 [ PADDING <nPadding> ];
                 [ <lContainer: CONTAINER> ] ;
                 [ OF <oParent> ] ;
                 [ ID <cId> ;
                 [ RESOURCE <uGlade> ] ];
                 [ POS <x>,<y>  ];
                 [ LABELNOTEBOOK <uLabelBook> ];
                 [ <lEnd: INSERT_END> ] ;
                 [ <lSecond: SECOND_PANED > ] ;
                 [ <lResize: RESIZE > ] ;
                 [ <lShrink: SHRINK > ] ;
                 [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
                 [ ACTION <bAction> ];
                 [ LEFT BUTTON <ulButton> ];
                 [ RIGHT BUTTON <urButton> ];
      => ;
  [ <oBtn> := ] tpyEntry():New( [TPYENTRY_<cType>], ;
                   bSetGet( <uVar> ), <cRegExFilter>, <oMsgWidget>, <cPicture>,;
                   [ \{|o| <bValid> \} ],<.lCalendar.>,<oForm>,;
                   <nLen>,<.lZero.>,;
                   <aCompletion>, <oFont>, <oParent>, <.lExpand.>, <.lFill.>, ;
                   <nPadding>,<.lContainer.>,;
                   <x>,<y>, <cId>, <uGlade>, <uLabelBook>,<.lPassword.>,;
                   <.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                   <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, ;
                   <yOptions_ta>,;
                   [ \{| this,nPos | <bAction> \} ], <ulButton>, <urButton> )



