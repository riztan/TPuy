/*
    LGPL Licence.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this software; see the file COPYING.  If not, write to
    the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
    Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).

    LGPL Licence.
    (c)2007 Federico de Maussion <fj_demaussion@yahoo.com.ar>
*/
/*
 *  Noviembre 2009.
 *  Adaptación para Scripts por Riztan Gutierrez.  <riztan@gmail.com>
*/

#include "inkey.ch"
#define pcAbajo      1
#define pcizquierda  1
#define pcCentrado   2
#define pcArriba     4
#define pcderecha    4
#define pcEstirado   8

#xcommand DEFINE EDIT <oEdit> ;
                 [ OF <oParent> ] ;
                 [ SIZE <nWidth>, <nHeight> ] ;
                 [ TITLE <cTitle> ] ;
                 [ ICONO <oIcon> ];
      => ;
      <oEdit>:=gPcEdit():New( <oParent>, <cTitle>, <oIcon>, <nWidth>, <nHeight> )

#xcommand EDIT ADD [ <cLabel> ]  ;
                 [ NAME <cName> ]; 
                 [ GET <uVar>   ];
                 [ PICTURE <cPicture> ];
                 [ VALID <bValid> ];
                 [ OF <oParent> ] ;
      => ;
      Aadd(<oParent>:aReg,\{ "Get",\{ <cLabel>, bSetGet( <uVar> ), <uVar>, <cPicture>, [ \{|o| <bValid> \} ],<cName> \} \})

#xcommand EDIT ADD [ <cLabel> ]  ;
                 [ ENTRY <uVar> ];
                 [ PICTURE <cPicture> ];
                 [ VALID <bValid> ];
                 [ COMPLETION <aCompletion> ];
                 [ OF <oParent> ] ;
      => ;
      Aadd(<oParent>:aReg,\{ "Entry",\{ <cLabel>, bSetGet( <uVar> ), <cPicture>, [ \{|o| <bValid> \} ], <aCompletion> \} \})

#xcommand EDIT ADD [ <cLabel> ]  ;
                 [ COMBOBOX <uVar> ];
                 [ NAME <cName> ];
                 [ ITEMS <aItems> ];
                 [ ON CHANGE <bChange> ];
                 [ OF <oParent> ] ;
      => ;
      Aadd(<oParent>:aReg,\{ "Combo",\{  <cLabel>, bSetGet( <uVar> ), <aItems>, [ \{|o| <bChange> \} ],,<cName> \} \})

#xcommand EDIT ADD [ <cLabel> ]  ;
                 [ TOOGLE <uVar> ];
                 [ ACTION <bAction> ];
                 [ VALID <bValid> ];
                 [ OF <oParent> ] ;
      => ;
      Aadd(<oParent>:aReg,\{ "Toggle",\{ <cLabel>, bSetGet( <uVar> ), [ \{|o| <bAction> \} ], [ \{|o| <bValid> \} ]  \} \})


#xcommand EDIT ADD [ <cLabel> ]  ;
                 [ CHECKBOX <uVar> ];
                 [ NAME <cName> ];
                 [ ACTION <bAction> ];
                 [ VALID <bValid> ];
                 [ OF <oParent> ] ;
      => ;
      Aadd(<oParent>:aReg,\{ "CheckBox",\{ <cLabel>, bSetGet( <uVar> ), [ \{|o| <bAction> \} ], [ \{|o| <bValid> \} ],,<cName>  \} \})
   

#xcommand EDIT ADD CONTAINER <nPos> ;
                 [ BUTTON <cLabel> ];
                 [ ACTION <bAction> ];
                 [ VALID <bValid> ];
                   [ OF <oParent> ] ;
      => ;
      Aadd(<oParent>:aReg,\{ "Button",\{  <cLabel>, [ \{|o| <bAction> \} ],;
      [ \{|o| <bValid> \} ] \} \})

#xcommand EDIT ADD CONTAINER  <nPos>   OF <oParent>  ;
      => ;
      Aadd(<oParent>:aReg,\{ "ContainerGet",\{  \} \});;
      <nPos>:=Len(<oParent>:aReg)

#xcommand EDIT ADD CONTAINER <nPos> ;
                 [ LABEL <cLabel> ]  ;
                 GET <uVar>;
                 [ PICTURE <cPicture> ];
                 [ VALID <bValid> ];
                 [ OF <oParent> ] ;
      => ;
      Aadd(<oParent>:aReg\[<nPos>,2]\,\{ "Get", <cLabel>, bSetGet( <uVar> ), <cPicture>, [ \{|o| <bValid> \} ] \})

#xcommand EDIT ADD CONTAINER <nPos> ;
                 [ LABEL <cLabel> ]  ;
                 ENTRY <uVar>;
                 [ PICTURE <cPicture> ];
                 [ VALID <bValid> ];
                 [ COMPLETION <aCompletion> ];
                 [ OF <oParent> ] ;
      => ;
      Aadd(<oParent>:aReg\[<nPos>,2]\,\{ "Entry", <cLabel>, bSetGet( <uVar> ), <cPicture>, [ \{|o| <bValid> \} ], <aCompletion> \})

#xcommand EDIT ADD CONTAINER <nPos> ;
                 [ LABEL <cLabel> ]  ;
                 COMBOBOX <uVar>;
                 [ NAME <cName> ];
                 [ ITEMS <aItems> ];
                 [ ON CHANGE <bChange> ];
                 [ OF <oParent> ] ;
      => ;
      Aadd(<oParent>:aReg\[<nPos>,2]\, \{ "Combo", <cLabel>, bSetGet( <uVar> ), <aItems>, [ \{|o| <bChange> \} ],<cName> \} )

#xcommand EDIT ADD CONTAINER <nPos> ;
                 BUTTON <cLabel> ;
                 [ ACTION <bAction> ];
                 [ VALID <bValid> ];
                 [ OF <oParent> ] ;
      => ;
      Aadd(<oParent>:aReg\[<nPos>,2]\, \{  "Button",, <cLabel>,  [ \{|o| <bAction> \} ], ;
      [ \{|o| <bValid> \} ] \} )

#xcommand ACTIVATE EDIT <oParent> ;
                 [ ACTION <bAction> ];
                 [ INIT <bInit> ];
      => ;
      <oParent>:Active( [ \{|o| <bAction> \} ], [ \{|o| <bInit> \} ] )


#xcommand DEFINE PCTOOLBUTTON [ <oBtn> ];
                 [ <label: TEXT,LABEL,PROMPT> <cText> ];
                 [ STOCK_ID <cStock> ];
                 [ FROM STOCK <cFromStock> ];
                 [ IMAGE <xImage> ];
                 [ ACTION <bAction> ];
                 [ <lMnemonic: MNEMONIC> ];
                 [ <lExpand: EXPAND> ] ;
                 [ TOOLTIP <cTips> ];
                 [ OF <oParent> ];
                 [ ID <cId> ;
                 [ RESOURCE <uGlade> ] ];
                  => ;
  [ <oBtn> := ] gPcToolButton():New( <cText>, [ \{|o| <bAction> \} ], <cStock>, <.lMnemonic.>,;
                  <cFromStock>, <oParent>, <.lExpand.>, <xImage>, <cTips>, <cId>, <uGlade> )

#xcommand ISO  <xDato>   =>   <xDato> := iso( <xDato> )
#xcommand UTF  <xDato>   =>   <xDato> := utf( <xDato> )

#define BARRADIR              If( "Linux" $ OS(), "/", "\" )

#xcommand DEFINE PCGET [ <oBtn> ]  ;
                 [ VAR <uVar> ];
                 [ <lPassword: PASSWORD> ] ;
                 [ PICTURE <cPicture> ];
                 [ VALID <bValid> ];
                 [ WHEN <bWhen> ];
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
                 [ <lSecond: SECOND_PANED> ] ;
                 [ <lResize: RESIZE> ] ;
                 [ <lShrink: SHRINK> ] ;
                 [ TABLEATTACH <left_ta>,<right_ta>,<top_ta>,<bottom_ta>[,<xOptions_ta>, <yOptions_ta> ] ] ;
      => ;
  [ <oBtn> := ] Pc_Get():New( bSetGet( <uVar> ), <cPicture>, [ \{|o| <bWhen> \} ], [ \{|o| <bValid> \} ],;
                   <aCompletion>, <oFont>, <oParent>, <.lExpand.>, <.lFill.>, <nPadding>,<.lContainer.>,;
                   <x>,<y>, <cId>, <uGlade>, <uLabelBook>,<.lPassword.>,;
                   <.lEnd.>, <.lSecond.>, <.lResize.>, <.lShrink.>,;
                   <left_ta>,<right_ta>,<top_ta>,<bottom_ta>, <xOptions_ta>, <yOptions_ta> )

#xcommand DEFINE PC KEY [ <oKey> ] ;
                 [ FONT <oFont> ];
                 [ OF <oParent> ] ;
      => ;
  [ <oKey> := ] PC_Key():New( <oParent>, <oFont> )

#xcommand PC_Set KEY  <nKey>[, <nKey1> ]  ;
                 [ ACTION <bAction> ];
                 [ OF <oKey> ] ;
      => ;
  <oKey>:SetKey( \{ <nKey>[, <nKey1> ] \}, [ \{|o| <bAction> \} ] )

#xcommand PC_DISPLAY KEY  <oKey>  ;
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
