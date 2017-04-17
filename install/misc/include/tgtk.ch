/*  $Id: tgtk.ch,v 1.3 2010-12-28 18:52:20 dgarciagil Exp $ */

/*
 * Definicion de comandos para T-Gtk.
 * (c)2008 Riztan Gutierrez
 */

#define COL_INIT      1

#xtranslate MsgAlert( <cMessage> [, <cTitle> ] [ <lMarkup: MARKUP> ] );
            =>;
            Msg_Alert( <cMessage>,[ <cTitle> ],[ <.lMarkup.> ] )


#xtranslate MsgInfo( <cMessage> [, <cTitle> ] [ <lMarkup: NO_MARKUP> ] [ ICON <cIconFile> ] );
            =>;
            Msg_Info( <cMessage>,[ <cTitle> ],[ <.lMarkup.> ],[ <cIconFile> ] )


#xtranslate MsgStop( <cMessage> [, <cTitle> ] [ <lMarkup: NO_MARKUP> ] [ ICON <cIconFile> ] );
            =>;
            Msg_Stop( <cMessage>,[ <cTitle> ],[ <.lMarkup.> ],[ <cIconFile> ] )


#xtranslate MsgNoYes( <cMessage> [, <cTitle> ] [ <lMarkup: NO_MARKUP> ] [ ICON <cIconFile> ] );
            =>;
            Msg_NoYes( <cMessage>,[ <cTitle> ], .F. ,[ <.lMarkup.> ] , [ <cIconFile> ] )


#xtranslate MsgYesNo( <cMessage> [, <cTitle> ] [ <lMarkup: NO_MARKUP> ] [ ICON <cIconFile> ] );
            =>;
            Msg_NoYes( <cMessage>,[ <cTitle> ],.T.,[ <.lMarkup.> ] , [ <cIconFile> ] )


#xtranslate MsgOkCancel( <cMessage> [, <cTitle> ] [ <lMarkup: NO_MARKUP> ] [ ICON <cIconFile> ] );
            =>;
            Msg_OkCancel( <cMessage>,[ <cTitle> ],.T.,[ <.lMarkup.> ],[ <cIconFile> ] )

#xtranslate MsgCancelOk( <cMessage> [, <cTitle> ] [ <lMarkup: NO_MARKUP> ] [ ICON <cIconFile> ] );
            =>;
            Msg_OkCancel( <cMessage>,[ <cTitle> ],.F.,[ <.lMarkup.> ],[ <cIconFile> ] )

#command ? [ <list,...> ] => WQout( [ \{ <list> \} ] )

#command ?. [ <list,...> ] => gQout( [ \{ <list> \} ] )


/* Se define WVT por defecto en Windows para Evitar que aparezca la consola */
#ifdef __PLATFORM__WINDOWS
   REQUEST HB_GT_WVT_DEFAULT
#endif

