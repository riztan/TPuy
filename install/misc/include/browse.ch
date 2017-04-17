/*  $Id: browse.ch,v 1.1 2006-09-08 10:16:34 xthefull Exp $ */
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
               [ ALIAS <cAlias> ] ;
               [ <sizes:FIELDSIZES, SIZES, COLSIZES> <aColSizes,...> ] ;
               [ <head:HEAD,HEADER,HEADERS> <aHeaders,...> ] ;
               [ SIZE <nWidth>, <nHeigth> ] ;
               [ POSITION <nRow>, <nCol> ] ;
               [ <dlg:OF,DIALOG> <oWnd> ] ;
               [ <change: ON CHANGE, ON CLICK> <uChange> ] ;
               [ FONT <cFont> ] ;
               [ <color: COLOR, COLORS> <uClrFore> [,<uClrBack>] ] ;
      => ;
         [ <oBrw> := ] DbfGrid():New( [<oWnd>], <nRow>, <nCol>, ;
                           [\{<aHeaders>\}], [\{<aColSizes>\}], ;
                           \{ [\{|o|<Expr1>\}] [,\{|o|<ExprN>\}] \},;
                           <cAlias>, <nWidth>, <nHeigth>,;
                           [<{uChange}>], <cFont>, <uClrFore>, <uClrBack> )

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
