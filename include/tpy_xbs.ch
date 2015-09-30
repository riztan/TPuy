/*  $Id: tpy_xbs.ch,v 1.13 2014/01/27 18:36 riztan Exp $ */
/*
	Copyright © 2008  Riztan Gutierrez <riztang@gmail.org>

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
#include "proandsys.ch"
//#include "pc-soft.ch"

#xuncommand SET RESOURCES <uGlade> FROM FILE <cFile> [ ROOT <root> ];
              => ;
              <uGlade> := glade_xml_new( <cFile>, <root> )

#xcommand SET RESOURCES <uGlade> FROM FILE <cFile> [ ROOT <root> ];
              => ;
              <uGlade> := tpy_glade( <cFile>, <root> )


#xuncommand DEFINE WINDOW <oWnd> [ TITLE <cTitle> ] ;
                               [ ICON_NAME <cIconName>];
                               [ ICON_FILE <cIconFile>];
                               [ TYPE <nType> ];
                               [ TYPE_HINT <nType_Hint> ];
                               [ SIZE <nWidth>, <nHeight> ] ;
                               [ OF <oParent> ];
                               [ ID <cId> ;
                               [ RESOURCE <uGlade> ] ];
      => ;
      <oWnd> := GWindow():New( <cTitle>, <nType>, <nWidth>, <nHeight>, [<cId>],;
                              [<uGlade>],[<nType_Hint>],[<cIconName>],[<cIconFile>],[<oParent>] )


#xcommand DEFINE WINDOW <oWnd> [ TITLE <cTitle> ] ;
                               [ ICON_NAME <cIconName>];
                               [ ICON_FILE <cIconFile>];
                               [ TYPE <nType> ];
                               [ TYPE_HINT <nType_Hint> ];
                               [ SIZE <nWidth>, <nHeight> ] ;
                               [ OF <oParent> ];
                               [ ID <cId> ;
                               [ RESOURCE <uGlade> ] ];
      => ;
      <oWnd> := TpyWindow():New( <cTitle>, <nType>, <nWidth>, <nHeight>, [<cId>],;
                              [<uGlade>],[<nType_Hint>],[<cIconName>],[<cIconFile>],[<oParent>] )


#xuncommand DEFINE IMAGE [ <oImage> ] ;
               [ FILE <cFileImage> ] ;
               [ FROM STOCK <cFromStock> [ SIZE_ICON <nIcon_Size> ] ];
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ OF <oParent> ] ;
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ POS <x>,<y>  ];
               [ LABELNOTEBOOK <uLabelBook> ];
               [ SIZE <nWidth>, <nHeight> ] ;
               [ <lEnd: INSERT_END> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ];
               [ HALIGN <nHor> ];
               [ VALIGN <nVer> ];
               [ <lLoad: LOAD> ] ;
      => ;
 [ <oImage> := ] GImage():New( [<cFileImage>] , <oParent>, <.lExpand.>, <.lFill.>, <nPadding> , <.lContainer.>,;
                                <x>, <y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>,;
                                <.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                                <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta>, <nHor>, <nVer>,;
                                <cFromStock>, <nIcon_Size>, <.lLoad.>  )



#xcommand DEFINE IMAGE [ <oImage> ] ;
               [ FILE <cFileImage> ] ;
               [ FROM STOCK <cFromStock> [ SIZE_ICON <nIcon_Size> ] ];
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ OF <oParent> ] ;
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ POS <x>,<y>  ];
               [ LABELNOTEBOOK <uLabelBook> ];
               [ SIZE <nWidth>, <nHeight> ] ;
               [ <lEnd: INSERT_END> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ];
               [ HALIGN <nHor> ];
               [ VALIGN <nVer> ];
               [ <lLoad: LOAD> ] ;
      => ;
 [ <oImage> := ] tpy_Image():New( [<cFileImage>] , <oParent>, <.lExpand.>, <.lFill.>, <nPadding> , <.lContainer.>,;
                                <x>, <y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>,;
                                <.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                                <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta>, <nHor>, <nVer>,;
                                <cFromStock>, <nIcon_Size>, <.lLoad.>  )



#xtranslate ::<exp> => oForm:<exp>

#xtranslate tracelog( <uValue> )  => tpyLog( <uValue>, ProcName() )




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


// Entry/Get
#xcommand DEFINE ENTRY [ <oBtn> ]  ;
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
  [ <oBtn> := ] tpy_Entry():New( bSetGet( <uVar> ), <cPicture>, [ \{|o| <bValid> \} ],;
                   <aCompletion>, <oFont>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding>,<.lContainer.>,;
                   <x>,<y>, <cId>, <uGlade>, <uLabelBook>,<.lPassword.>,;
                   <.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                   <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta>,;
                   [ \{| this,nPos | <bAction> \} ], <ulButton>, <urButton> )


//eof
