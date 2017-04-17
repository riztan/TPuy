/*  $Id: gclass_extra.ch,v 1.0 2012-12-24 17:11:21 riztan Exp $ */
/*
 * Definicion de clases para GtkExtra , filosofia GTK.
 * (c)2012 Rafa Carmona
 * (c)2012 Riztan Gutierrez
 */

// SHEET
#xcommand DEFINE SHEET [ <oSheet> ]  ;
                 [ TITLE <cTitle> ];
                 [ <lExpand: EXPAND> ] ;
                 [ <lBrowser: BROWSER> ] ;
                 [ <lFill: FILL> ] ;
                 [ PADDING <nPadding> ];
                 [ <lContainer: CONTAINER> ] ;
                 [ OF <oParent> ] ;
                 [ POS <x>,<y>  ];
                 [ ID <cId> ;
                 [ RESOURCE <uGlade> ] ];
                 [ LABELNOTEBOOK <uLabelBook> ];
                 [ SIZE <nLines>, <nColumns> ] ;
                 [ <lEnd: INSERT_END> ] ;
                 [ <lSecond: SECOND_PANED > ] ;
                 [ <lResize: RESIZE > ] ;
                 [ <lShrink: SHRINK > ] ;
                 [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
                 [ ON ROW ACTIVATED <uRowActivated> ];
                 [ ON MOVE <uCursorMove> ];
                 [ ON CHANGE <uOnChange> ];
      => ;
    [ <oSheet> := ] gSheet():New( <cTitle>, <oParent>, <.lExpand.>, <.lBrowser.>,<.lFill.>, <nPadding> ,;
                         <.lContainer.>, <x>, <y>, <cId>, <uGlade>, , <uLabelBook>, <nLines>, <nColumns>, , ,;
                         <.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                         <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta>,;
                         [ \{|  Path, TreeViewColumn | <uRowActivated> \} ], [ \{| nStep, nCount| <uCursorMove> \} ], ;
                         [ \{| aIter, Path | <uOnChange> \} ], 2 )


