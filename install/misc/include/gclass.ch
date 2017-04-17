/*  $Id: gclass.ch,v 1.17 2010-12-24 14:35:37 dgarciagil Exp $ */
/*
 * Definicion de clases , filosofia GTK.
 * (c)2004 Rafa Carmona
 */

#include "gtkapi.ch"

#ifdef HB_OS_LINUX
  #include "gnomeprint.ch"
#endif

#define CRLF HB_OSNEWLINE()


// Support relations of Windows-------------------------------------------------
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
      <oWnd> := GWindow():New( <cTitle>, <nType>, <nWidth>, <nHeight>, [<cId>],;
                              [<uGlade>],[<nType_Hint>],[<cIconName>],[<cIconFile>],[<oParent>] )

#xcommand ACTIVATE WINDOW <oWnd>;
         [ VALID <uEnd> ] ;
         [ <lCenter: CENTER> ] ;
         [ <lMaximize: MAXIMIZED> ] ;
         [ <lModal: MODAL> ] ;
         [ <lInitiate: INITIATE> ] ;
          => ;
          <oWnd>:Activate( [ \{|o| <uEnd> \} ], <.lCenter.>, <.lMaximize.>, <.lModal.>,<.lInitiate.> )

#xcommand DEFINE DIALOG <oDlg> [ TITLE <cTitle> ] ;
                               [ TYPE_HINT <nType_Hint> ];
                               [ SIZE <nWidth>, <nHeight> ] ;
                               [ OF <oParent> ];
                               [ ID <cId> ;
                               [ RESOURCE <uGlade> ] ];
                               [ ICON_NAME <cIconName> ];
                               [ ICON_FILE <cIconFile> ];
  	      => ;
	      <oDlg> := GDialog():New( <cTitle>, <nWidth>, <nHeight>, [<cId>],[<uGlade>],[<nType_Hint>],;
                                 [<cIconName>],[<cIconFile>],[<oParent>] )

#xcommand ADD DIALOG <oDlg>;
              BUTTON <cText> ;
	      ACTION <uAction>;
          => ;
          <oDlg>:AddButton( <cText>, [ \{|o| <uAction> \} ] )

#xcommand ACTIVATE DIALOG <oDlg>;
         [ VALID <uEnd> ] ;
         [ <lNoSeparator: NOSEPARATOR> ] ;
         [ <lRun: RUN> ] ;
         [ <lCenter: CENTER> ] ;
         [ <lNoModal: NOMODAL> ] ;
         [ <lResizable: RESIZABLE> ] ;
         [ <lInitiate: INITIATE> ] ;
         [ <lys: ON_YES,    ON YES> <uYes> ] ;
         [ <lno: ON_NO,     ON NO > <uNo> ] ;
         [ <lOk: ON_OK,     ON OK> <uOk> ] ;
         [ <lCa: ON_CANCEL, ON CANCEL> <uCancel> ] ;
         [ <lCl: ON_CLOSE,  ON CLOSE> <uClose> ] ;
         [ <lAp: ON_APPLY,  ON APPLY> <uApply> ] ;
         [ <lHp: ON_HELP,   ON HELP> <uHelp> ] ;
          => ;
          <oDlg>:Activate( [ \{|o| <uYes> \} ],[ \{|o| <uNo> \} ],[ \{|o| <uOk> \} ],;
                           [ \{|o| <uCancel> \} ], [ \{|o| <uClose> \} ], [ \{|o| <uApply> \} ],;
                           [ \{|o| <uHelp> \} ] , [ \{|o| <uEnd> \} ], <.lCenter.>,;
                           <.lResizable.> , <.lNoModal.>, <.lNoSeparator.>, <.lRun.>, <.lInitiate.>  )


#xcommand DEFINE FILECHOOSERWIDGET <oBox>  ;
               [ MODE <nMode> ];
               [ <lHomogeneous: HOMOGENEOUS, HOMO> ] ;
               [ SPACING <nSpacing> ];
               [ BORDER <nBorder> ]  ;
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
       <oBox> := GFileChooserWidget():New( <nMode>, <.lHomogeneous.>, <nSpacing>, <oParent>, <.lExpand.>,;
                  <.lFill.>, <nPadding>, <.lContainer.>, <x>, <y>, <uLabelBook>,;
                  <.lSecond.>, <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
                  <xOptions_ta>, <yOptions_ta>, <cId>, <uGlade>, <nBorder> )




/* Support Timers */
#xcommand DEFINE TIMER <oTimer>;
              [ INTERVAL <nInterval> ];
   	        [ ACTION <uAction> ];
          => ;
          <oTimer> := gTimer():New( <nInterval>, [ \{|o| <uAction> \} ] )

#xcommand ACTIVATE TIMER <oTimer>;
	  =>;
	  <oTimer>:Activate()

// Support relations of Menus-------------------------------------------------
// Creation bar container of menus
#xcommand DEFINE BARMENU <oBarMenu> ;
          [ OF <oParent> ] ;
  	      => ;
	      <oBarMenu> := GMenuBar():New( [ <oParent> ] )

#xcommand MENUBAR <oMenu> OF  <oBarMenu>  ;
               [ ID <cId> [ RESOURCE <uGlade> ] ];
       	      => ;
	      <oMenu> := GMenu():New( <oBarMenu>, NIL ,[<cId>], [<uGlade>] )

#xcommand SUBMENU <oSubMenu> OF  <oMenuItem>  ;
  	      => ;
	      <oSubMenu> := GMenu():New( , <oMenuItem> )

#xcommand ACTIVATE MENUBAR <oBarMenu>   ;
  	      => ;
	      <oBarMenu>:Activate()

#xcommand MENU SEPARATOR [<oMenuSep>] OF  <oMenu>  ;
  	      => ;
	     [ <oMenuSep> := ] GMenuSeparator():New( <oMenu> )

#xcommand MENU TEAROFF [<oMenuTear>] OF  <oMenu>  ;
  	      => ;
	     [ <oMenuTear> := ] GMenuTearOff():New( <oMenu> )

#xcommand DEFINE MENU <oMenu> ;
               [ ID <cId> [ RESOURCE <uGlade> ] ];
       	      => ;
	      <oMenu> := GMenu():New( ,  ,[<cId>], [<uGlade>] )

#xcommand MENUITEM [<oMenuItem>] ;
 	           [ <lRoot: ROOT> ] ;
                   TITLE <cTitle> ;
	           [ ACTION <bAction> ];
                   [ <lMnemonic: MNEMONIC> ];
	           OF  <oMenu> ;
  	      => ;
	       [<oMenuItem> :=] GMenuItem():New( <cTitle>, <oMenu>, [ \{|o| <bAction> \} ], <.lRoot.>, <.lMnemonic.> )


#xcommand MENUITEM CHECK [ <oMenuItem> ] ;
			 [ <lRoot: ROOT> ] ;
                         TITLE <cTitle> ;
			 [ ACTION <bAction> ];
			 [ <lRadio: ASRADIO>];
			 [ <lActive: ACTIVE> ];
	                 [ <lMnemonic: MNEMONIC> ];
			 OF  <oMenu> ;
  	      => ;
	     [ <oMenuItem> := ] GMenuItemCheck():New( <cTitle>, <oMenu>,;
		                     [ \{|o| <bAction> \} ], <.lRoot.>, <.lRadio.>, <.lActive.>, <.lMnemonic.> )

#xcommand MENUITEM IMAGE [ <oMenuItem> ] ;
                         [ <lRoot: ROOT> ] ;
                         [ TITLE <cTitle> ];
                         [ ACTION <bAction> ];
                         [ FROM STOCK <cFromStock> ];
                         [ IMAGE <oImage> ];
                         [ <lMnemonic: MNEMONIC> ];
                         OF  <oMenu> ;
      => ;
    [ <oMenuItem> := ] GMenuItemImage():New( <cTitle>, <oMenu>,;
                   [ \{|o| <bAction> \} ], <.lRoot.>, <.lMnemonic.>, <oImage>, <cFromStock> )

// MenuItems para controlar desde glade
#xcommand DEFINE MENUITEM [<oMenuItem>] ;
          ACTION <bAction> ;
          ID <cId> ;
          RESOURCE <uGlade> ;
          => ;
         [<oMenuItem> :=] GMenuItem():New(,,[ \{|o| <bAction> \} ],,, <cId>, <uGlade> )

#xcommand DEFINE MENUITEM CHECK [ <oMenuItem> ] ;
          [ ACTION <bAction> ];
          [ <lRadio: ASRADIO>];
          [ <lActive: ACTIVE> ];
          ID <cId> ;
          RESOURCE <uGlade> ;
          => ;
       [ <oMenuItem> := ] GMenuItemCheck():New( ,,;
                         [ \{|o| <bAction> \} ], , <.lRadio.>, <.lActive.>, , <cId>, <uGlade> )

#xcommand DEFINE MENUITEM IMAGE [ <oMenuItem> ] ;
                          ACTION <bAction> ;
                          ID <cId> ;
                          RESOURCE <uGlade> ;
          => ;
       [ <oMenuItem> := ] GMenuItemImage():New( , ,;
                         [ \{|o| <bAction> \} ], , , , , <cId>, <uGlade>  )


// Images-------
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
 [ <oImage> := ] GImage():New( [<cFileImage>] , <oParent>, <.lExpand.>, <.lFill.>, <nPadding> , <.lContainer.>,;
                                <x>, <y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>,;
                                <.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                                <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta>, <nHor>, <nVer>,;
                                <cFromStock>, <nIcon_Size>, <.lLoad.>  )


// Box Verticals and Horizontal
#xcommand DEFINE BOX <oBox>  ;
               [ <lHomogeneous: HOMOGENEOUS, HOMO> ] ;
               [ SPACING <nSpacing> ];
               [ BORDER <nBorder> ]  ;
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
       <oBox> := GBoxVH():New( <.lHomogeneous.>, <nSpacing>, <.lMode.>, <oParent>, <.lExpand.>,;
                  <.lFill.>, <nPadding>, <.lContainer.>, <x>, <y>, <uLabelBook>,;
                  <.lSecond.>, <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
                  <xOptions_ta>, <yOptions_ta>, <cId>, <uGlade>, <nBorder> )

// Label
#xcommand DEFINE LABEL [<oLabel>]  ;
                 [ <label: TEXT,LABEL,PROMPT> <cText> ];
                 [ <lMarkup: MARKUP> ] ;
                 [ <lExpand: EXPAND> ] ;
                 [ <lMnemonic: MNEMONIC> ];
                 [ FONT <oFont> ];
                 [ <lFill: FILL> ] ;
                 [ PADDING <nPadding> ];
                 [ <lContainer: CONTAINER> ] ;
                 [ OF <oParent> ] ;
                 [ POS <x>,<y>  ];
                 [ ID <cId> [ RESOURCE <uGlade> ] ];
                 [ LABELNOTEBOOK <uLabelBook> ];
                 [ <lEnd: INSERT_END> ] ;
                 [ <lSecond: SECOND_PANED > ] ;
                 [ <lResize: RESIZE > ] ;
                 [ <lShrink: SHRINK > ] ;
                 [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ];
                 [ HALIGN <nHor> ];
                 [ VALIGN <nVer> ];
                 [ JUSTIFY <nJustify> ];
      => ;
 [ <oLabel> := ]GLabel():New( <cText>, <.lMarkup.>, <oParent>, <oFont>, <.lExpand.>,;
                <.lFill.>, <nPadding>, <.lContainer.>, <x>, <y>,;
                <cId>, <uGlade>, <uLabelBook>,<.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>,<yOptions_ta>,;
                <nHor>, <nVer>, <nJustify>, <.lMnemonic.> )

// Expander
#xcommand DEFINE EXPANDER [<oExpander>]  ;
                 [ <label: TEXT,LABEL,PROMPT> <cText> ];
                 [ ACTION <bAction> ];
                 [ <lOpen: OPEN> ];
                 [ <lMnemonic: MNEMONIC> ];
                 [ <lMarkup: MARKUP> ] ;
                 [ <lExpand: EXPAND> ] ;
                 [ <lFill: FILL> ] ;
                 [ PADDING <nPadding> ];
                 [ <lContainer: CONTAINER> ] ;
                 [ OF <oParent> ] ;
                 [ POS <x>,<y>  ];
                 [ ID <cId> ;
                 [ RESOURCE <uGlade> ] ];
                 [ LABELNOTEBOOK <uLabelBook> ];
                 [ SIZE <nWidth>, <nHeight> ] ;
                 [ <lEnd: INSERT_END> ] ;
                 [ <lSecond: SECOND_PANED > ] ;
                 [ <lResize: RESIZE > ] ;
                 [ <lShrink: SHRINK > ] ;
                 [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ];
      => ;
 [ <oExpander> := ]GExpander():New( <cText>, [ \{|o| <bAction> \} ], <.lOpen.>, <.lMarkup.>, <.lMnemonic.>,;
                      <oParent>, <.lExpand.>, <.lFill.>, <nPadding> ,;
                      <.lContainer.>, <x>, <y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>,<.lEnd.>,;
                      <.lSecond.>, <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
                      <xOptions_ta>, <yOptions_ta> )

// Buttons
#xcommand DEFINE BUTTON [ <oBtn> ]  ;
                 [ <label: TEXT,LABEL,PROMPT> <cText> ];
                 [ ACTION <bAction> ];
                 [ VALID <bValid> ];
                 [ FONT <oFont> ];
                 [ FROM STOCK <cFromStock> ];
                 [ <lMnemonic: MNEMONIC> ];
                 [ <lExpand: EXPAND> ] ;
                 [ <lFill: FILL> ] ;
                 [ PADDING <nPadding> ];
                 [ <lContainer: CONTAINER> ] ;
                 [ OF <oParent> ] ;
                 [ POS <x>,<y>  ];
                 [ ID <cId> ;
                 [ RESOURCE <uGlade> ] ];
                 [ CURSOR <nCursor> ];
                 [ LABELNOTEBOOK <uLabelBook> ];
                 [ SIZE <nWidth>, <nHeight> ] ;
                 [ BAR <oBar> [ MSG <cMsgBar>] ] ;
                 [ <lEnd: INSERT_END> ] ;
                 [ <lSecond: SECOND_PANED > ] ;
                 [ <lResize: RESIZE > ] ;
                 [ <lShrink: SHRINK > ] ;
                 [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
                 [ STYLE <aStyles> ];
                 [ STYLE_CHILD <aStylesChild> ];
                 [ IMAGE <cImage> ];
                 [ TOOLTIP <cToolTip> ];
      => ;
    [ <oBtn> := ] GButton():New( <cText>,[ \{|o| <bAction> \} ] , [ \{|o| <bValid> \} ], <oFont>,;
       <.lMnemonic.>, <cFromStock>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding> ,;
      <.lContainer.>, <x>, <y>, <cId>, <uGlade>, <nCursor>, <uLabelBook>, <nWidth>, <nHeight>,;
      <oBar>,<cMsgBar>,<.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
      <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta>, <aStyles> , <aStylesChild>, <cImage>, <cToolTip> )

// Toggle
#xcommand DEFINE TOGGLE [ <oBtn> ]  ;
                 [ <label: TEXT,LABEL,PROMPT> <cText> ];
                 [ ACTION <bAction> ];
                 [ VALID <bValid> ];
                 [ FONT <oFont> ];
                 [ <lMnemonic: MNEMONIC> ];
                 [ <lExpand: EXPAND> ] ;
                 [ <lFill: FILL> ] ;
                 [ PADDING <nPadding> ];
                 [ <lContainer: CONTAINER> ] ;
                 [ OF <oParent> ] ;
                 [ POS <x>,<y>  ];
                 [ ID <cId> ;
                 [ RESOURCE <uGlade> ] ];
                 [ CURSOR <nCursor> ];
                 [ LABELNOTEBOOK <uLabelBook> ];
                 [ SIZE <nWidth>, <nHeight> ] ;
                 [ BAR <oBar> [ MSG <cMsgBar>] ] ;
                 [ <lEnd: INSERT_END> ] ;
                 [ <lSecond: SECOND_PANED > ] ;
                 [ <lResize: RESIZE > ] ;
                 [ <lShrink: SHRINK > ] ;
                 [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
      => ;
[ <oBtn> := ] GToggleButton():New( <cText>,[ \{|o| <bAction> \} ] , [ \{|o| <bValid> \} ],;
               <oFont>,<.lMnemonic.>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding>,;
               <.lContainer.>, <x>, <y>, <cId>, <uGlade>, <nCursor>, <uLabelBook>,;
               <nWidth>, <nHeight>, <oBar>,<cMsgBar>,<.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
               <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta> )

// Toggle
#xcommand DEFINE RADIO [ <oBtn> ]  ;
                 [ <label: TEXT,LABEL,PROMPT> <cText> ];
                 [ GROUP <oRadio> ];
                 [ <lActived: ACTIVED> ];
                 [ ACTION <uAction> ];
                 [ FONT <oFont> ];
                 [ <lMnemonic: MNEMONIC> ];
                 [ <lExpand: EXPAND> ] ;
                 [ <lFill: FILL> ] ;
                 [ PADDING <nPadding> ];
                 [ <lContainer: CONTAINER> ] ;
                 [ OF <oParent> ] ;
                 [ POS <x>,<y>  ];
                 [ ID <cId> ;
                 [ RESOURCE <uGlade> ] ];
                 [ CURSOR <nCursor> ];
                 [ LABELNOTEBOOK <uLabelBook> ];
                 [ SIZE <nWidth>, <nHeight> ] ;
                 [ BAR <oBar> [ MSG <cMsgBar>] ] ;
                 [ <lEnd: INSERT_END> ] ;
                 [ <lSecond: SECOND_PANED > ] ;
                 [ <lResize: RESIZE > ] ;
                 [ <lShrink: SHRINK > ] ;
                 [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
     => ;
  [ <oBtn> := ] GRadioButton():New( <cText>, <.lActived.>,<oRadio>, [ \{|o| <uAction> \} ],;
                 <oFont>,<.lMnemonic.>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding>,;
                 <.lContainer.>, <x>, <y>, <cId>, <uGlade>, <nCursor>, <uLabelBook>,;
                 <nWidth>, <nHeight>, <oBar>,<cMsgBar>,<.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                 <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta>)

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
  [ <oBtn> := ] GEntry():New( bSetGet( <uVar> ), <cPicture>, [ \{|o| <bValid> \} ],;
                   <aCompletion>, <oFont>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding>,<.lContainer.>,;
                   <x>,<y>, <cId>, <uGlade>, <uLabelBook>,<.lPassword.>,;
                   <.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                   <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta>,;
                   [ \{| this,nPos | <bAction> \} ], <ulButton>, <urButton> )

// Combobox
#xcommand DEFINE COMBOBOX [ <oCombo> ]  ;
                 [ VAR <uVar> ];
                 [ ITEMS <aItems> ];
                 [ ON CHANGE <bChange> ];
                 [ MODEL <oModel> ];
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
                 [ SIZE <nWidth>, <nHeight> ] ;
                 [ <lEnd: INSERT_END> ] ;
                 [ <lSecond: SECOND_PANED > ] ;
                 [ <lResize: RESIZE > ] ;
                 [ <lShrink: SHRINK > ] ;
                 [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
          => ;
 [ <oCombo> := ] GComboBox():New( bSetGet( <uVar> ), <aItems>, [ \{|o| <bChange> \} ],<oModel>,;
              <oFont>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding>,<.lContainer.>,;
              <x>,<y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>, <.lEnd.>,;
              <.lSecond.>, <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
              <xOptions_ta>, <yOptions_ta>)

// Combobox Compatible Clipper
#xcommand DEFINE COMBOBOX CLIPPER [ <oCombo> ]  ;
                 [ VAR <uVar> ];
                 [ ITEMS <aItems> ];
                 [ ON CHANGE <bChange> ];
                 [ MODEL <oModel> ];
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
                 [ SIZE <nWidth>, <nHeight> ] ;
                 [ <lEnd: INSERT_END> ] ;
                 [ <lSecond: SECOND_PANED > ] ;
                 [ <lResize: RESIZE > ] ;
                 [ <lShrink: SHRINK > ] ;
                 [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
          => ;
 [ <oCombo> := ] GComboBox_Clip():New( bSetGet( <uVar> ), <aItems>, [ \{|o| <bChange> \} ],<oModel>,;
              <oFont>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding>,<.lContainer.>,;
              <x>,<y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>, <.lEnd.>,;
              <.lSecond.>, <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
              <xOptions_ta>, <yOptions_ta>)


// CheckBox
#xcommand DEFINE CHECKBOX [ <oBtn> ]  ;
                 [ <label: TEXT,LABEL,PROMPT> <cText> ];
                 [ VAR <uVar> ];
                 [ VALID <bValid> ];
                 [ ON CLICK <bClicked> ];
                 [ FONT <oFont> ];
                 [ <lMnemonic: MNEMONIC> ];
                 [ <lExpand: EXPAND> ] ;
                 [ <lFill: FILL> ] ;
                 [ PADDING <nPadding> ];
                 [ <lContainer: CONTAINER> ] ;
                 [ OF <oParent> ] ;
                 [ ID <cId> ;
                 [ RESOURCE <uGlade> ] ];
                 [ CURSOR <nCursor> ];
                 [ POS <x>,<y>  ];
                 [ LABELNOTEBOOK <uLabelBook> ];
                 [ <lEnd: INSERT_END> ] ;
                 [ <lSecond: SECOND_PANED > ] ;
                 [ <lResize: RESIZE > ] ;
                 [ <lShrink: SHRINK > ] ;
                 [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
      => ;
   [ <oBtn> := ] GCheckBox():New( <cText>, bSetGet( <uVar> ) , [ \{|o| <bValid> \} ],;
                     <oFont>,<.lMnemonic.>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding>,;
                     <.lContainer.>, <x>, <y>, <cId>, <uGlade>, <nCursor>, <uLabelBook>,;
                     <.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                     <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta>, [ \{|o| <bClicked> \} ] )

#xcommand SET RESOURCES <uGlade> FROM FILE <cFile> [ ROOT <root> ];
  	      => ;
	      <uGlade> := glade_xml_new( <cFile>, <root> )

#xcommand SET RESOURCES <uGlade> FROM BUFFER <cBuffer> [ ROOT <root> ];
  	      => ;
	      <uGlade> := glade_xml_new_from_buffer( <cBuffer>, <root> )


// ToolBar
#xcommand DEFINE TOOLBAR [<oToolBar>]  ;
                 [ <lVertical: VERTICAL> ] ;
                 [ <lExpand: EXPAND> ] ;
                 [ <lShowArrow: SHOW ARROW> ] ;
                 [ <lFill: FILL> ] ;
                 [ PADDING <nPadding> ];
                 [ <lContainer: CONTAINER> ] ;
                 [ OF <oParent> ] ;
                 [ STYLE <nStyle> ];
                 [ ID <cId> ;
                 [ RESOURCE <uGlade> ] ];
                 [ POS <x>,<y>  ];
                 [ LABELNOTEBOOK <uLabelBook> ];
                 [ <lEnd: INSERT_END> ] ;
                 [ <lSecond: SECOND_PANED > ] ;
                 [ <lResize: RESIZE > ] ;
                 [ <lShrink: SHRINK > ] ;
                 [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
      => ;
[ <oToolBar> := ] GToolBar():New( <nStyle>, <.lShowArrow.>, <.lVertical.>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding> , <.lContainer.>,;
                  <x>, <y>, <cId>, <uGlade>,<uLabelBook>, <.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                  <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta>)

// ToolButton
#xcommand DEFINE TOOLBUTTON [ <oBtn> ];
                 [ <label: TEXT,LABEL,PROMPT> <cText> ];
                 [ STOCK_ID <cStock> ];
                 [ FROM STOCK <cFromStock> ];
                 [ ACTION <bAction> ];
                 [ <lMnemonic: MNEMONIC> ];
                 [ <lExpand: EXPAND> ] ;
                 [ OF <oParent> ];
                 [ ID <cId> ;
                 [ RESOURCE <uGlade> ] ];
                  => ;
  [ <oBtn> := ] GToolButton():New( <cText>, [ \{|o| <bAction> \} ] , <cStock>,;
                  <.lMnemonic.>,<cFromStock>, <oParent>, <.lExpand.>, <cId>, <uGlade> )

// ToolToggle
#xcommand DEFINE TOOLTOGGLE [ <oBtn> ];
                 [ <label: TEXT,LABEL,PROMPT> <cText> ];
                 [ <lActive: ACTIVED> ];
                 [ STOCK_ID <cStock> ];
                 [ FROM STOCK <cFromStock> ];
                 [ ACTION <bAction> ];
                 [ <lMnemonic: MNEMONIC> ];
                 [ <lExpand: EXPAND> ] ;
                 [ OF <oParent> ] ;
                 [ ID <cId> ;
                 [ RESOURCE <uGlade> ] ];
      => ;
  [ <oBtn> := ] GToolToggle():New( <cText>, [ \{|o| <bAction> \} ] , <.lActive.>, <cStock>,;
                  <.lMnemonic.>,<cFromStock>, <oParent>, <.lExpand.>, <cId>, <uGlade> )

// ToolRadio
#xcommand DEFINE TOOLRADIO [ <oBtn> ];
                 [ <label: TEXT,LABEL,PROMPT> <cText> ];
                 [ <lActive: ACTIVED> ];
                 [ GROUP <oGroup>  ];
                 [ STOCK_ID <cStock> ];
                 [ FROM STOCK <cFromStock> ];
                 [ ACTION <bAction> ];
                 [ <lMnemonic: MNEMONIC> ];
                 [ <lExpand: EXPAND> ] ;
                 [ OF <oParent> ] ;
                 [ ID <cId> ;
                 [ RESOURCE <uGlade> ] ];
      => ;
  [ <oBtn> := ] GToolRadio():New( <cText>, [ \{|o| <bAction> \} ] , <.lActive.>, <cStock>,;
                  <.lMnemonic.>,<cFromStock>, <oParent>, <.lExpand.>, <oGroup>, <cId>, <uGlade> )

// ToolSeparator
#xcommand DEFINE TOOL SEPARATOR [ <oBtn> ]  ;
                 [ <lExpand: EXPAND> ] ;
                 [ <lNoDraw: NODRAW> ] ;
                 [ OF <oParent> ] ;
                 [ ID <cId> ;
                 [ RESOURCE <uGlade> ] ];
      => ;
  [ <oBtn> := ] GToolSeparator():New( <.lExpand.>, <.lNoDraw.>, <oParent>, <cId>, <uGlade> )

// ToolMenu
#xcommand DEFINE TOOLMENU [ <oBtn> ];
                 [ <label: TEXT,LABEL,PROMPT> <cText> ];
                 [ FROM STOCK <cFromStock> ];
                 [ IMAGE <oImage> ];
                 [ MENU <oMenu> ];
                 [ ACTION <bAction> ];
                 [ <lExpand: EXPAND> ] ;
                 [ OF <oParent> ];
                 [ ID <cId> ;
                 [ RESOURCE <uGlade> ] ];
                  => ;
  [ <oBtn> := ] GToolMenu():New( <cText>, <oImage>, <oMenu>, [ \{|o| <bAction> \} ] ,;
                                  <cFromStock>, <oParent>, <.lExpand.>, <cId>, <uGlade> )

//Fixed
#xcommand DEFINE FIXED [ <oFixed> ] [ OF <oParent> ] ;
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ SIZE <nWidth>, <nHeight> ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
      => ;
  [ <oFixed> := ] gfixed():New( <oParent>, <cId>, <uGlade>, <.lSecond.>, <.lResize.>,;
             <.lShrink.>, <nWidth>, <nHeight>, <left_ta>, <right_ta>, <top_ta>, <bottom_ta>,;
             <xOptions_ta>, <yOptions_ta> )

//Table
#xcommand DEFINE TABLE [ <oTable> ] ;
               [ ROWS <nRows> COLS <nColumns> ];
               [ <lHomogeneous: HOMOGENEOUS, HOMO> ] ;
               [ OF <oParent> ] ;
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
      => ;
 [  <oTable> :=] gTable():New( <nRows>, <nColumns>, <.lHomogeneous.>,;
                    <oParent>, <cId>, <uGlade>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                    <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta> )


//Frame
#xcommand DEFINE FRAME [ <oFrame> ] [ OF <oParent> ] ;
               [ <label: TEXT,LABEL,PROMPT> <cText> ];
               [ SHADOW <nShadow> ];
               [ ALIGN <nHor>, <nVer> ];
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ LABELNOTEBOOK <uLabelBook> ];
               [ SIZE <nWidth>, <nHeight> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
       => ;
 [ <oFrame> := ]gFrame():New( <cText>, <nShadow>, <nHor>, <nVer>, <oParent>, <.lExpand.>, <.lFill.>,;
                <nPadding>, <.lContainer.>, <x>, <y>, <cId>, <uGlade>,;
                <uLabelBook>, <nWidth>, <nHeight>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta> )

//Calendar
#xcommand DEFINE CALENDAR [ <oCalendar> ] [ OF <oParent> ] ;
               [ DATE <dDate> ];
               [ STYLE <nStyle> ];
               [ <lMark: MARKDAY> ] ;
               [ ON_SELECTED <uDaySelected> ] ;
               [ ON_DELETE <uDelete> ] ;
               [ ON_MARKDAY <bOnMarkDay> ] ;
               [ ON_UNMARKDAY <bOnUnMarkDay> ] ;
               [ ON_DCLICK <uDayDClick> ] ;
               [ ON_PREV_MONTH <uPrevMonth> ] ;
               [ ON_NEXT_MONTH <uNextMonth> ] ;
               [ ON_MONTH_CHANGED <uMonthChanged> ] ;
               [ ON_PREV_YEAR <uPrevYear> ] ;
               [ ON_NEXT_YEAR <uNextYear> ] ;
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ LABELNOTEBOOK <uLabelBook> ];
               [ SIZE <nWidth>, <nHeight> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
       => ;
[ <oCalendar> := ] gCalendar():New( <dDate>, <nStyle>, <.lMark.>,;
                    [ \{|o| <uDaySelected> \} ],[ \{|o| <uDayDClick> \} ],;
                    [ \{|o| <uPrevMonth> \} ],[ \{|o| <uNextMonth> \} ],[ \{|o| <uMonthChanged> \} ],;
                    [ \{|o| <uPrevYear> \} ],[ \{|o| <uNextYear> \} ],;
                     <oParent>, <.lExpand.>, <.lFill.>, <nPadding>, <.lContainer.>,;
                     <x>, <y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>, <.lSecond.>,;
                     <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
                     <xOptions_ta>, <yOptions_ta>,[ \{|o| <bOnMarkDay> \} ],[ \{|o| <bOnUnMarkDay> \} ],;
		    [ \{|o| <uDelete> \} ] )


//Arrow
#xcommand DEFINE ARROW [ <oArrow> ] [ OF <oParent> ] ;
               [ ORIENTATION <nOrientation> ];
               [ SHADOW <nShadow> ];
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ SIZE <nWidth>, <nHeight> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
               [ HALIGN <nHor> ];
               [ VALIGN <nVer> ];
              => ;
[ <oArrow> := ] gArrow():New( <nOrientation>, <nShadow>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding>, <.lContainer.>,;
                  <x>, <y>, <cId>, <uGlade>, <nWidth>, <nHeight>, <.lSecond.>,;
                  <.lResize.>, <.lShrink.>, <left_ta>, <right_ta>, <top_ta>, <bottom_ta>,;
                  <xOptions_ta>, <yOptions_ta>, <nHor> ,<nVer> )

//Notebook
#xcommand DEFINE NOTEBOOK [ <oBook> ] [ OF <oParent> ] ;
               [ POSITION <nPosition> ];
               [ ON CHANGE <bChange> ];
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ <lEnd: INSERT_END> ] ;
               [ SIZE <nWidth>, <nHeight> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
       => ;
[ <oBook> := ] gNoteBook():New( <nPosition>, [ \{|o| <bChange> \} ], <oParent>, <.lExpand.>, <.lFill.>, <nPadding>,;
                           <.lContainer.>,<x>, <y>, <cId>, <uGlade>, <nWidth>, <nHeight> ,;
                           <.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                           <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta> )

//Progressbar
#xcommand DEFINE PROGRESSBAR [ <oMeter> ] [ OF <oParent> ];
               [ VAR  <nVar> ];
               [ <label: TEXT,LABEL,PROMPT> <cText> ];
               [ ORIENTATION <nOrientation> ] ;
               [ TOTAL <nTotal> ] ;
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ SIZE <nWidth>, <nHeight> ] ;
               [ <lEnd: INSERT_END> ] ;
               [ SIZE <nWidth>, <nHeight> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
=> ;
    [ <oMeter> := ]  gProgressBar():New( <cText>, bSetGet( <nVar> ), <nTotal>,<nOrientation>,;
                   <oParent>, <.lExpand.>, <.lFill.>, <nPadding>, <.lContainer.>,;
                   <x>, <y>, <cId>, <uGlade>, <nWidth>, <nHeight>, <.lEnd.>, <.lSecond.>,;
                  <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,<xOptions_ta>, <yOptions_ta> )

// SpinButton
#xcommand DEFINE SPIN [ <oSpin> ] [ OF <oParent> ];
               [ VAR  <nVar> ];
               [ MIN  <nMin> ];
               [ MAX  <nMax> ];
               [ DECIMALS <nDecimals> ];
               [ STEP <nStep> ];
               [ ADJUST <oAdjust> ];
               [ VALID <bValid> ];
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ SIZE <nWidth>, <nHeight> ] ;
               [ LABELNOTEBOOK <uLabelBook> ];
               [ <lEnd: INSERT_END> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
=> ;
[ <oSpin> := ] gSpinButton():New( bSetGet( <nVar> ), <nMin>, <nMax>, <nDecimals>, <nStep>, <oAdjust>, [ \{|o| <bValid> \} ] ,;
               <oParent>, <.lExpand.>, <.lFill.>, <nPadding>, <.lContainer.>,;
               <x>, <y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>, <.lEnd.>,;
               <.lSecond.>, <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
               <xOptions_ta>, <yOptions_ta>  )

// Scale Vertical & Horizontal
#xcommand DEFINE SCALE [ <oScale> ] [ OF <oParent> ];
               [ VAR  <nVar> ];
               [ <lVertical: VERTICAL> ] ;
               [ MIN  <nMin> ];
               [ MAX  <nMax> ];
               [ DECIMALS <nDecimals> ];
               [ STEP <nStep> ];
               [ ADJUST <oAdjust> ];
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ SIZE <nWidth>, <nHeight> ] ;
               [ LABELNOTEBOOK <uLabelBook> ];
               [ <lEnd: INSERT_END> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
=> ;
  [ <oScale> := ]  gScaleVH():New( bSetGet( <nVar> ), <.lVertical.>, <nMin>, <nMax>, <nDecimals>, <nStep>, <oAdjust> ,;
               <oParent>, <.lExpand.>, <.lFill.>, <nPadding>, <.lContainer.>,;
               <x>, <y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>, <.lEnd.>,;
               <.lSecond.>, <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
               <xOptions_ta>, <yOptions_ta> )

//Scroll Window GSCROLLEDWINDOW
#xcommand DEFINE SCROLLEDWINDOW [ <oScrool> ] [ OF <oParent> ] ;
               [ HORIZONTAL <oAdjH> ];
               [ VERTICAL   <oAdjV> ];
               [ SHADOW <nShadow> ];
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ SIZE <nWidth>, <nHeight> ] ;
               [ LABELNOTEBOOK <uLabelBook> ];
               [ <lEnd: INSERT_END> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
       => ;
[  <oScrool> ] := gScrolledWindow():New( <oAdjH>, <oAdjV>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding>,;
               <.lContainer.>,<x>, <y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>,;
               <.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
               <xOptions_ta>, <yOptions_ta>, <nShadow>  )

//Viewport GVIEWPORT
#xcommand DEFINE VIEWPORT [ <oView> ] [ OF <oParent> ] ;
               [ HORIZONTAL <oAdjH> ];
               [ VERTICAL   <oAdjV> ];
               [ SHADOW <nShadow> ];
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ SIZE <nWidth>, <nHeight> ] ;
               [ LABELNOTEBOOK <uLabelBook> ];
               [ <lEnd: INSERT_END> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
       => ;
[  <oView> ] := gViewPort():New( <oAdjH>, <oAdjV>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding>,;
               <.lContainer.>,<x>, <y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>,;
               <.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
               <xOptions_ta>, <yOptions_ta>, <nShadow> )

//Adjusment
#xcommand DEFINE ADJUSTMENT <oAdj>  ;
               [ MIN <nMin> ];
               [ MAX <nMax>];
               [ VALUE <nValue>];
               [ STEP <nStep> ];
               [ PAGE_INC <nPage_Inc> ];
               [ PAGE_SIZE <nPage_Size> ];
       => ;
    <oAdj> := gAdjustment(): New( <nMin>, <nMax>, <nValue>, <nStep>, <nPage_Inc>, <nPage_Size> )

//Status Bar
#xcommand DEFINE STATUSBAR [ <oBar> ] [ OF <oParent> ] ;
               [ <label: TEXT,LABEL,PROMPT> <cText> ];
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ SIZE <nWidth>, <nHeight> ] ;
               [ LABELNOTEBOOK <uLabelBook> ];
               [ <lEnd: INSERT_END> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
       => ;
 [ <oBar> := ] gStatusBar():New( <cText>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding>,;
               <.lContainer.>,<x>, <y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>,<.lEnd.>,;
               <.lSecond.>, <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
               <xOptions_ta>, <yOptions_ta> )

//PANED
#xcommand DEFINE PANED [ <oPaned> ] [ OF <oParent> ] ;
               [ <lVertical: VERTICAL> ] ;
               [ <lEnd: INSERT_END> ] ;
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ CUTTERPOS <nPos> ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ SIZE <nWidth>, <nHeight> ] ;
               [ LABELNOTEBOOK <uLabelBook> ];
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
       => ;
 [ <oPaned> := ] gPaned():New( <.lVertical.>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding>,;
               <.lContainer.>,<x>, <y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>, <.lEnd.>,;
               <.lSecond.>, <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
               <xOptions_ta>, <yOptions_ta>, <nPos> )

// LIST
#xcommand DEFINE LIST [ <oList> ]  ;
                 [ VAR <uVar> ];
                 [ ITEMS <aItems> ];
                 [ ON CHANGE <bChange> ];
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
                 [ SIZE <nWidth>, <nHeight> ] ;
                 [ <lEnd: INSERT_END> ] ;
                 [ <lSecond: SECOND_PANED > ] ;
                 [ <lResize: RESIZE > ] ;
                 [ <lShrink: SHRINK > ] ;
                 [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
          => ;
 [ <oList> := ] GList():New( bSetGet( <uVar> ), <aItems>,[ \{|o| <bChange> \} ],;
              <oFont>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding>,<.lContainer.>,;
              <x>,<y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>, <.lEnd.>,;
              <.lSecond.>, <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
              <xOptions_ta>, <yOptions_ta> )

// Fonts
#xcommand DEFINE FONT <oFont> NAME <cName> ;
  	      => ;
              <oFont> := gFont():New( <cName> )

// ToolTips
#xcommand DEFINE TOOLTIP [<oToolTip>] ;
                 [ WIDGET <oWidget> ] ;
                 [ TEXT <cText> ] ;
  	      => ;
              [<oToolTip> := ] gToolTip():New( <cText>, <oWidget> )

// Buttons
#xcommand DEFINE FILECHOOSERBUTTON [ <oBtn> ]  ;
                 [ <label: TEXT,LABEL,PROMPT> <cText> ];
                 [ PATH_INIT <cPath_Init> ];
                 [ MODE <nMode> ];
                 [ <lExpand: EXPAND> ] ;
                 [ <lFill: FILL> ] ;
                 [ PADDING <nPadding> ];
                 [ <lContainer: CONTAINER> ] ;
                 [ OF <oParent> ] ;
                 [ POS <x>,<y>  ];
                 [ ID <cId> ;
                 [ RESOURCE <uGlade> ] ];
                 [ CURSOR <nCursor> ];
                 [ LABELNOTEBOOK <uLabelBook> ];
                 [ SIZE <nWidth>, <nHeight> ] ;
                 [ BAR <oBar> [ MSG <cMsgBar>] ] ;
                 [ <lEnd: INSERT_END> ] ;
                 [ <lSecond: SECOND_PANED > ] ;
                 [ <lResize: RESIZE > ] ;
                 [ <lShrink: SHRINK > ] ;
                 [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta> [,<xOptions_ta>, <yOptions_ta> ] ] ;
                 [ <fil: FILTER, FILTERS> <cFilter> ];
                 [ <onsel: ON_SELECT, ON SELECT><uSelect> ];
      => ;
    [ <oBtn> := ] GFileChooserButton():New( <cText>, <nMode>, <cPath_Init>,;
                  <oParent>, <.lExpand.>, <.lFill.>, <nPadding> ,;
                  <.lContainer.>, <x>, <y>, <cId>, <uGlade>, <nCursor>, <uLabelBook>, <nWidth>, <nHeight>,;
                 <oBar>,<cMsgBar>,<.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                 <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta>,[<cFilter>], [ \{|cFileName| <uSelect> \} ] )


// MEMO / TEXTVIEW
#xcommand DEFINE MEMO [ <oMemo> ];
               [ <lReadOnly: READONLY> ] ;
               [ OF <oParent> ] ;
               [ VAR <uVar> ];
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ SIZE <nWidth>, <nHeight> ] ;
               [ LABELNOTEBOOK <uLabelBook> ];
               [ <lEnd: INSERT_END> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
       => ;
 [ <oMemo> := ] gTextView():New( bSetGet( <uVar> ), <.lReadOnly.>, [<oParent>], <.lExpand.>, <.lFill.>, <nPadding>,;
                <.lContainer.>,<x>, <y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>,<.lEnd.>,;
                <.lSecond.>, <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
                <xOptions_ta>, <yOptions_ta> )

#xcommand DEFINE TEXTVIEW [ <oMemo> ];
               [ <lReadOnly: READONLY> ] ;
               [ OF <oParent> ] ;
               [ VAR <uVar> ];
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ SIZE <nWidth>, <nHeight> ] ;
               [ LABELNOTEBOOK <uLabelBook> ];
               [ <lEnd: INSERT_END> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
       => ;
 [ <oMemo> := ] gTextView():New( bSetGet( <uVar> ), <.lReadOnly.>, [<oParent>], <.lExpand.>, <.lFill.>, <nPadding>,;
                <.lContainer.>,<x>, <y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>,<.lEnd.>,;
                <.lSecond.>, <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
                <xOptions_ta>, <yOptions_ta> )

#xcommand DEFINE SOURCEVIEW [ <oMemo> ];
               [ MIME <cMime> ] ;
               [ <lNoShowLines: NOSHOWLINES> ] ;
               [ <lReadOnly: READONLY> ] ;
               [ OF <oParent> ] ;
               [ VAR <uVar> ];
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ SIZE <nWidth>, <nHeight> ] ;
               [ LABELNOTEBOOK <uLabelBook> ];
               [ <lEnd: INSERT_END> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
       => ;
 [ <oMemo> := ] gSourceView():New( <cMime>, <.lNoShowLines.> , bSetGet( <uVar> ), <.lReadOnly.>, [<oParent>],;
                <.lExpand.>, <.lFill.>, <nPadding>,;
                <.lContainer.>,<x>, <y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>,<.lEnd.>,;
                <.lSecond.>, <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
                <xOptions_ta>, <yOptions_ta> )

//EVENTBOX
#xcommand DEFINE EVENTBOX [ <oEventBox> ] [ OF <oParent> ] ;
               [ <lEnd: INSERT_END> ] ;
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ SIZE <nWidth>, <nHeight> ] ;
               [ LABELNOTEBOOK <uLabelBook> ];
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
       => ;
 [ <oEventBox> := ] gEventBox():New( <oParent>, <.lExpand.>, <.lFill.>, <nPadding>,;
               <.lContainer.>,<x>, <y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>, <.lEnd.>,;
               <.lSecond.>, <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
               <xOptions_ta>, <yOptions_ta> )

//Separator
#xcommand DEFINE SEPARATOR [ <oSeparator> ] [ OF <oParent> ] ;
               [ <lMode: VERTICAL> ] ;
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ LABELNOTEBOOK <uLabelBook> ];
               [ SIZE <nWidth>, <nHeight> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
       => ;
 [ <oSeparator> := ] gSeparator():New( <.lMode.>, <oParent>, <.lExpand.>, <.lFill.>,;
                <nPadding>, <.lContainer.>, <x>, <y>, <cId>, <uGlade>,;
                <uLabelBook>, <nWidth>, <nHeight>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta> )

// Alignment
#xcommand DEFINE ALIGNMENT [<oAlign>]  ;
                 [ ALIGN <xalign>, <yalign> ];
                 [ SCALE <xscale>, <yscale> ];
                 [ <lExpand: EXPAND> ] ;
                 [ <lFill: FILL> ] ;
                 [ PADDING <nPadding> ];
                 [ <lContainer: CONTAINER> ] ;
                 [ OF <oParent> ] ;
                 [ POS <x>,<y>  ];
                 [ SIZE <nWidth>, <nHeight> ] ;
                 [ ID <cId> ;
                 [ RESOURCE <uGlade> ] ];
                 [ LABELNOTEBOOK <uLabelBook> ];
                 [ <lEnd: INSERT_END> ] ;
                 [ <lSecond: SECOND_PANED > ] ;
                 [ <lResize: RESIZE > ] ;
                 [ <lShrink: SHRINK > ] ;
                 [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ];
      => ;
 [ <oAlign> := ]gALignment():New( <xalign>, <yalign>, <xscale>, <yscale>, <oParent>, <.lExpand.>,;
                 <.lFill.>, <nPadding>, <.lContainer.>, <x>, <y>,;
                 <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>, <.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                 <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>,<yOptions_ta> )

/* Soporte para Modelo de Datos LISTSTORE */
#xcommand DEFINE LIST_STORE <oLbx>  ;
                 TYPES <aTypes,...> ;
       =>;
         <oLbx> :=  gListStore():New( \{<aTypes>\} )

#xcommand DEFINE LIST_STORE <oLbx>  ;
                 AUTO <aItems> ;
       =>;
         <oLbx> :=  gListStore():NewAuto( <aItems> )

#xcommand DEFINE LIST_STORE <oLbx>  ;
                 MODEL <cModel> ;
                 RESOURCE <pGlade> ;
       =>;
         <oLbx> :=  gListStore():Create( <cModel>,<pGlade> )

#xcommand APPEND LIST_STORE <oLbx> ;
                 [ ITER <aIter> ];
                 [ VALUES <aValues,...> ];
       =>;
        [ <aIter> := ] <oLbx>:Append( [\{<aValues>\}] )

#xcommand INSERT LIST_STORE <oLbx> ROW <nRow> ;
                 [ ITER <aIter> ];
                 [ VALUES <aValues,...> ];
       =>;
        [ <aIter> := ] <oLbx>:Insert( <nRow>,[\{<aValues>\}] )

#xcommand SET LIST_STORE <oLbx> ;
              ITER <aIter> ;
              POS <n>;
              VALUE <uValue>;
       =>;
        <oLbx>:Set( <aIter>, <n>, <uValue> )

#xcommand SET VALUES LIST_STORE <oLbx> ;
              ITER <aIter> ;
              VALUES <aValues,...>;
       =>;
        <oLbx>:SetValues( <aIter>, \{<aValues>\} )


// TREEVIEW
#xcommand DEFINE TREEVIEW [ <oTreeView> ]  ;
                 [ MODEL <oModel> ];
                 [ <lExpand: EXPAND> ] ;
                 [ <lFill: FILL> ] ;
                 [ PADDING <nPadding> ];
                 [ <lContainer: CONTAINER> ] ;
                 [ OF <oParent> ] ;
                 [ POS <x>,<y>  ];
                 [ ID <cId> ;
                 [ RESOURCE <uGlade> ] ];
                 [ LABELNOTEBOOK <uLabelBook> ];
                 [ SIZE <nWidth>, <nHeight> ] ;
                 [ <lEnd: INSERT_END> ] ;
                 [ <lSecond: SECOND_PANED > ] ;
                 [ <lResize: RESIZE > ] ;
                 [ <lShrink: SHRINK > ] ;
                 [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
                 [ ON ROW ACTIVATED <uRowActivated> ];
                 [ ON MOVE <uCursorMove> ];
                 [ ON CHANGE <uOnChange> ];
      => ;
    [ <oTreeView> := ] gTreeView():New( <oModel>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding> ,;
                         <.lContainer.>, <x>, <y>, <cId>, <uGlade>, , <uLabelBook>, <nWidth>, <nHeight>, , ,;
                         <.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                         <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta>,;
                         [ \{|  Path, TreeViewColumn | <uRowActivated> \} ], [ \{| nStep, nCount| <uCursorMove> \} ], ;
                         [ \{| aIter, Path | <uOnChange> \} ], 2 )

// TreeViewColumn
#xcommand DEFINE TREEVIEWCOLUMN [ <oCol> ] ;
              [ TITLE <cTitle> ];
              [ <pos: COLUMN,POS> <nPos> ];
              [ TYPE <cType> ];
              [ MODEL <oModelCombo> [ TEXT <nColumn> ] ];
              [ <lExpand: EXPAND> ] ;
              [ <lSort:   SORT> ] ;
              [ WIDTH <nWidth> ];
              [ OF <oTreeView> ] ;
              [ <oper: EDITABLE, TOOGLE> <uAction> ];
              [ ID <cId> ;
              [ RESOURCE <uGlade> ] ];
              [ RENDERER ID <cId_Renderer> ];
       =>;
      [ <oCol> := ] gTreeViewColumn():New( <cTitle>, <cType>, <nPos>, <.lExpand.>,;
                           <oTreeView>, <nWidth>, <.lSort.>, [ \{| oSender, path, uVal, aIter | <uAction> \} ],;
                    <cId>, <uGlade>, <cId_Renderer>, <oModelCombo>, <nColumn> )

// Comando para poner un MENUPOPUP a un treeview
#xcommand DEFINE MENU <aMenus,...> OF TREEVIEW <oTreeView>  ;
       	      => ;
	      <oTreeView>:SetMenuPopup( \{<aMenus>\})


/* Soporte para Modelo de Datos TREESTORE */
#xcommand DEFINE TREE_STORE <oLbx>  ;
                 TYPES <aTypes,...> ;
       =>;
         <oLbx> :=  gTreeStore():New( \{<aTypes>\} )

#xcommand DEFINE TREE_STORE <oLbx>  ;
                 ARRAY <aTypes,...> ;
       =>;
         <oLbx> :=  gTreeStore():New( <aTypes> )

#xcommand DEFINE TREE_STORE <oLbx>  ;
                 AUTO <aItems> ;
       =>;
         <oLbx> :=  gTreeStore():NewAuto( <aItems> )

#xcommand APPEND TREE_STORE <oLbx> ;
                 [ ITER <aIter> ];
                 [ VALUES <aValues,...> ];
       =>;
        [ <aIter> := ] <oLbx>:Append( [\{<aValues>\}] )

#xcommand APPEND TREE_STORE <oLbx> ;
                 PARENT <aParent> ;
                 [ ITER <aIter> ];
                 [ VALUES <aValues,...> ];
       =>;
        [ <aIter> := ] <oLbx>:AppendChild( [\{<aValues>\}], <aParent> )

#xcommand SET TREE_STORE <oLbx> ;
              ITER <aIter> ;
              POS <n>;
              VALUE <uValue>;
       =>;
        <oLbx>:Set( <aIter>, <n>, <uValue> )

#xcommand INSERT TREE_STORE <oLbx> ROW <nRow> ;
                 [ PARENT <aParent> ];
                 [ ITER <aIter> ];
                 [ VALUES <aValues,...> ];
       =>;
        [ <aIter> := ] <oLbx>:Insert( <nRow>,[\{<aValues>\}], [<aParent>] )


/**
 * Commandos para la clase nativa de Browses de T-Gtk.
 * (c)2005 Rafa Carmona
 * (c)2005 Joaquim Ferrer
 * Notas by Quim:
 * El preprocesado de \{ [\{|o|<Expr1>\} [,\{|o|<ExprN>\}] \}
 * fuerzo para que sea un array vacio si FIELDS no es invocado
 * de esta manera se puede ignorar en DEFINE BROWSE sin error.
 **/

#define SCROLL_VERTICAL  1

#define COL_TYPE_TEXT    0
#define COL_TYPE_CHECK   1
#define COL_TYPE_SHADOW  2
#define COL_TYPE_BOX     3
#define COL_TYPE_RADIO   4
#define COL_TYPE_BITMAP  5

//------------------------------------------------------------------------//

#xcommand DEFINE BROWSE [ <oBrw> ] ;
               [ FIELDS <Expr1> [,<ExprN>] ] ;
               [ <dsrc: ALIAS, DATASOURCE, ARRAY, OBJECT, RECORDSET> <uData> ] ;
               [ <sizes:FIELDSIZES, SIZES, COLSIZES> <aColSizes,...> ] ;
               [ <head:HEAD,HEADER,HEADERS> <aHeaders,...> ] ;
               [ SIZE <nWidth>, <nHeigth> ] ;
               [ POSITION <nRow>, <nCol> ] ;
               [ <dlg:OF,DIALOG> <oWnd> ] ;
               [ <change: ON CHANGE, ON CLICK> <uChange> ] ;
               [ FONT <cFont> ] ;
               [ <color: COLOR, COLORS> <uClrFore> [,<uClrBack>] ] ;
               [ POS <x>,<y>  ];
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ LABELNOTEBOOK <uLabelBook> ];
               [ <lEnd: INSERT_END> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ <lAutoCol: AUTOCOL> ];
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ];
      => ;
         [ <oBrw> := ] gDbfGrid():New( [<oWnd>], <nRow>, <nCol>, ;
                           [\{<aHeaders>\}], [\{<aColSizes>\}], ;
                           \{ [\{|o|<Expr1>\}] [,\{|o|<ExprN>\}] \},;
                           <uData>, <nWidth>, <nHeigth>,;
                           [<{uChange}>], <cFont>, <uClrFore>, <uClrBack>,;
                           <.lExpand.>, <.lFill.>, <nPadding> ,<.lContainer.>,;
                            <x>,<y>,<uLabelBook>,<.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                           <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>,<yOptions_ta>, <.lAutoCol.> )

// general data columns
#command ADD [ COLUMN TO ] BROWSE  <oBrw> ;
            [ <dat: DATA> <uData> ] ;
            [ <tit: TITLE, HEADER> <cHead> ];
            [ HEADER_PICTURE <cBmpFile> ];
            [ <clr: COLOR, COLORS, COLOURS> <uClrFore> [,<uClrBack>] ] ;
            [ <wid: WIDTH, SIZE> <nWidth> ] ;
            [ <type: TYPE, COLTYPE> <nType> ] ;
            => ;
    <oBrw>:AddColumn( DbfGridColumn():New(  ;
             <cHead>,;
            [ If( ValType(<uData>)== "B", <uData>, <{uData}> ) ],;
             <nWidth>, <uClrFore>, <uClrBack> ,;
             <nType>, <cBmpFile> ) )


/* Soporte para AccelGroup */
#xcommand DEFINE ACCEL_GROUP <oGroup>  ;
                 [ OF <oWnd> ] ;
       =>;
         <oGroup> :=  gAccelGroup():New( <oWnd> )

#xcommand ADD ACCELGROUP <oGroup>  ;
              OF <oWidget>  ;
              SIGNAL <cSignal>  ;
	      KEY <cKey>;
              [ MODE <nMode> ] ;
              [ FLAGS <nFlags> ] ;
       =>;
         <oGroup>:Add( <oWidget>, <cSignal> , <cKey>, <nMode>, <nFlags> )

// Combobox Entry
#xcommand DEFINE COMBOBOX ENTRY [ <oCombo> ]  ;
                 [ VAR <uVar> ];
                 [ ITEMS <aItems> ];
                 [ ON CHANGE <bChange> ];
                 [ MODEL <oModel> ];
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
                 [ SIZE <nWidth>, <nHeight> ] ;
                 [ <lEnd: INSERT_END> ] ;
                 [ <lSecond: SECOND_PANED > ] ;
                 [ <lResize: RESIZE > ] ;
                 [ <lShrink: SHRINK > ] ;
                 [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
          => ;
 [ <oCombo> := ] GComboBoxEntry():New( bSetGet( <uVar> ), <aItems>, [ \{|o| <bChange> \} ],<oModel>,;
              <oFont>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding>,<.lContainer.>,;
              <x>,<y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>, <.lEnd.>,;
              <.lSecond.>, <.lResize.>, <.lShrink.>, <left_ta>,<right_ta>,<top_ta>,<bottom_ta>,;
              <xOptions_ta>, <yOptions_ta>)

// ICONVIEW
#xcommand DEFINE ICONVIEW [ <oIconView> ]  ;
                 [ MODEL <oModel> ];
                 [ <lExpand: EXPAND> ] ;
                 [ <lFill: FILL> ] ;
                 [ PADDING <nPadding> ];
                 [ <lContainer: CONTAINER> ] ;
                 [ OF <oParent> ] ;
                 [ POS <x>,<y>  ];
                 [ ID <cId> ;
                 [ RESOURCE <uGlade> ] ];
                 [ LABELNOTEBOOK <uLabelBook> ];
                 [ SIZE <nWidth>, <nHeight> ] ;
                 [ <lEnd: INSERT_END> ] ;
                 [ <lSecond: SECOND_PANED > ] ;
                 [ <lResize: RESIZE > ] ;
                 [ <lShrink: SHRINK > ] ;
                 [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
      => ;
    [ <oIconView> := ] gIconView():New( <oModel>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding> ,;
                         <.lContainer.>, <x>, <y>, <cId>, <uGlade>, <uLabelBook>, <nWidth>, <nHeight>,;
                         <.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                         <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta> )

// Message Status Bar
#xcommand DEFINE MESSAGE <cText> BAR <oBar> OF <oWidget> ;
  	      => ;
              <oWidget>:SetMsg( <cText>, <oBar> )

//DrawingArea
#xcommand DEFINE DRAWINGAREA [ <oDraw> ] [ OF <oParent> ] ;
               [ EXPOSE EVENT <bExpose> ];
               [ CONFIGURE EVENT <bConfigure> ];
               [ REALIZE <bRealize> ];
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ <lEnd: INSERT_END> ] ;
               [ SIZE <nWidth>, <nHeight> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
       => ;
[ <oDraw> := ] gDrawingArea():New( [ \{|oSender,pEvent| <bExpose> \} ], [ \{|oSender,pEvent| <bConfigure> \} ],;
                           [ \{|oSender,p| <bRealize> \} ],;
                           <oParent>, <.lExpand.>, <.lFill.>, <nPadding>,;
                           <.lContainer.>,<x>, <y>, <cId>, <uGlade>, <nWidth>, <nHeight> ,;
                           <.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                           <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta> )

/* AboutDialog */
#xcommand DEFINE ABOUT [ <oAbout> ] ;
                 [ NAME <cName> ] ;
                 [ VERSION <cVersion> ] ;
                 [ AUTHORS <aAuthors> ];
                 [ ARTISTS <aArtists> ];
                 [ DOCUMENTERS <aDocumenters> ];
                 [ <img: LOGO, LOGO IMAGE> <oLogo> ] ;
                 [ <lCenter: CENTER> ] ;
                 [ ID <cId> ;
                 [ RESOURCE <uGlade> ] ];
       =>;
[ <oAbout> := ] gAboutDialog():New( <cName>, <cVersion>, <aAuthors>,;
                                    <aArtists>, <aDocumenters>, <oLogo>, <.lCenter.>, <cId>, <uGlade> )

/* Assistan */
#xcommand DEFINE ASSISTANT <oWnd> ;
               [ <lCa: ON_CANCEL,   ON CANCEL>  <uCancel>  ] ;
               [ <lCl: ON_CLOSE,    ON CLOSE>   <uClose>   ] ;
               [ <lPr: ON_PREPARE,  ON PREPARE> <uPrepare> ] ;
               [ <lAp: ON_APPLY,    ON APPLY>   <uApply>   ] ;
               [ SIZE <nWidth>, <nHeight> ] ;
	       [ ID <cId> ;
	       [ RESOURCE <uGlade> ] ];
      => ;
      <oWnd> := gAssistant():New( [ \{|o| <uCancel> \} ] ,;
				  [ \{|o| <uClose> \} ] ,;
				  [ \{|o,pPage| <uPrepare> \} ] ,;
				  [ \{|o| <uApply> \} ] ,;
                                   <nWidth>, <nHeight>, [<cId>],[<uGlade>] )

#xcommand APPEND ASSISTANT <oWnd> ;
                 WIDGET <oWidget> ;
                 [ <lComplete: COMPLETE> ] ;
                 [ TYPE   <nType> ] ;
                 [ TITLE  <cTitle> ];
                 [ <li:IMAGE_HEADER, IMAGE HEADER> <uImage> ];
                 [ <ls:IMAGE_SIDE, IMAGE SIDE> <uImage_Side> ];
       =>;
         <oWnd>:Append( <oWidget>, <nType>, <cTitle>, <uImage>, <uImage_Side>,<.lComplete.> )


#xcommand ACTIVATE ASSISTANT <oWnd>;
         [ VALID <uEnd> ] ;
         [ <lCenter: CENTER> ] ;
         [ <lMaximize: MAXIMIZED> ] ;
         [ <lModal: MODAL> ] ;
         [ <lInitiate: INITIATE> ] ;
          => ;
          <oWnd>:Activate( [ \{|o| <uEnd> \} ], <.lCenter.>, <.lMaximize.>, <.lModal.>,<.lInitiate.> )

// Entry/Get
#xcommand DEFINE GET [ <oBtn> ]  ;
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
      => ;
  [ <oBtn> := ] gGet():New( bSetGet( <uVar> ), <cPicture>, [ \{|o| <bValid> \} ],;
                   <aCompletion>, <oFont>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding>,<.lContainer.>,;
                   <x>,<y>, <cId>, <uGlade>, <uLabelBook>,<.lPassword.>,;
                   <.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                   <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta> )

// Spinner
#xcommand DEFINE SPINNER [ <oDraw> ] [ OF <oParent> ] ;
               [ <lStart: START> ] ;
               [ <lExpand: EXPAND> ] ;
               [ <lFill: FILL> ] ;
               [ PADDING <nPadding> ];
               [ <lContainer: CONTAINER> ] ;
               [ POS <x>,<y>  ];
               [ ID <cId> ;
               [ RESOURCE <uGlade> ] ];
               [ <lEnd: INSERT_END> ] ;
               [ SIZE <nWidth>, <nHeight> ] ;
               [ <lSecond: SECOND_PANED > ] ;
               [ <lResize: RESIZE > ] ;
               [ <lShrink: SHRINK > ] ;
               [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
       => ;
[ <oDraw> := ] gSpinner():New( <.lStart.>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding>,;
                           <.lContainer.>,<x>, <y>, <cId>, <uGlade>, <nWidth>, <nHeight> ,;
                           <.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                           <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta> )

#xcommand SET GTKBUILDER  ON;
           =>;
           SetGtkBuilder( .T. )

#xcommand SET GTKBUILDER  OFF;
           =>;
           SetGtkBuilder( .F. )

#xcommand DEFINE TABORDER [ <oTab> ];
                 WIDGETS <aWidgets,...> ;
                 OF <oParent> ;
       =>;
        [ <oTab> := ] gTabOrder():Create( \{<aWidgets>\}, <oParent> )


#xcommand DEFINE [PC] KEY [ <oKey> ]  ;
                 [ FONT <oFont> ];
                 [ OF <oParent> [, <oParentN>]] ;
      => ;
  [ <oKey > := ] gKey():New( \{ <oParent> [, <oParentN>]\}, <oFont> )

#xcommand [PC_Set] KEY  <nKey>[, <nKey1> ]  ;
                 [ ACTION <bAction> ];
                 [ OF <oKey> ] ;
      => ;
  <oKey>:SetKey( \{ <nKey>[, <nKey1> ] \}, [ \{|o| <bAction> \} ] )

#xcommand [PC_]DISPLAY KEY  <oKey>  ;
                 [ F1 <cf1> ];
                 [ F2 <cf2> ];
                 [ F3 <cf3> ];
                 [ F4 <cf4> ];
                 [ F5 <cf5> ];
                 [ F6 <cf6> ];
                 [ F7 <cf7> ];
                 [ F8 <cf8> ];
                 [ F9 <cf9> ];
                 [ F10 <cf10> ];
                 [ F11 <cf11> ];
                 [ F12 <cf12> ];
                 [ <lDobleLine: DOBLELINE> ];
                 OF <oBox> ;
      => ;
  <oKey>:Display( <oBox>, [ <cf1> ], [ <cf2> ], [ <cf3> ], [ <cf4> ], [ <cf5> ], [ <cf6> ], [ <cf7> ],;
          [ <cf8> ], [ <cf9> ], [ <cf10> ], [ <cf11> ], [ <cf12> ], [ <.lDobleLine.> ] )


 extern errorsys

