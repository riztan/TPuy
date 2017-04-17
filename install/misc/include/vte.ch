
#xcommand DEFINE TERMINAL [ <oTerm> ]  ;
                 [ FONT <oFont> ];
                 [ COMMAND <cCommand> ];
                 [ <lExpand: EXPAND> ] ;
                 [ <lFill: FILL> ] ;
                 [ PADDING <nPadding> ];
                 [ <lContainer: CONTAINER> ] ;
                 [ OF <oParent> ] ;
                 [ POS <x>,<y>  ];
                 [ LABELNOTEBOOK <uLabelBook> ];
                 [ <lEnd: INSERT_END> ] ;
                 [ <lSecond: SECOND_PANED > ] ;
                 [ <lResize: RESIZE > ] ;
                 [ <lShrink: SHRINK > ] ;
                 [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
      => ;
    [ <oTerm> := ] GTerminal():New( <cCommand>, <oFont>,;
                                    <oParent>, <.lExpand.>, <.lFill.>, <nPadding> ,;
                                    <.lContainer.>, <x>, <y>, <uLabelBook>,<.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                                    <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta> )
