/*
 * $Id: client.prg 2011-12-28 17:26 riztan $
 */

/*
 *
 * Copyright 2010 Przemyslaw Czerpak <druzus / at / priv.onet.pl>
 * www - http://harbour-project.org
 *
 */
/*
 * Modificaciones por Riztan Gutierrez. <riztan / at / gmail.com>
 */

//#include "netio.ch"
 
#define CRLF   hb_eol()

#define NETSERVER  "69.55.54.230" //"localhost"
#define NETPORT    2941
#define NETPASSWD  "topsecret"

#xtranslate net:<!func!>([<params,...>]) => ;
            netio_funcexec( #<func> [,<params>] )
#xtranslate net:[<server>]:<!func!>([<params,...>]) => ;
            netio_funcexec( [ #<server> + ] ":" + #<func> [,<params>] )
#xtranslate net:[<server>]:<port>:<!func!>([<params,...>]) => ;
            netio_funcexec( [ #<server> + ] ":" + #<port> + ":" + #<func> ;
                            [,<params>] )


#xtranslate net:exists:<!func!> => ;
            netio_procexists( #<func> )
#xtranslate net:exists:[<server>]:<!func!> => ;
            netio_procexists( [ #<server> + ] ":" + #<func> )
#xtranslate net:exists:[<server>]:<port>:<!func!> => ;
            netio_procexists( [ #<server> + ] ":" + #<port> + ":" + #<func> )


/*
#xtranslate ~Server:<!msg!>[(<params,...>)] => ;
            FromRemote( "__object", oTpuy:oUser:cHandle, #<msg>[, <params>] )

#xtranslate ~Server:<!method!>([<params,...>]) => ;
            FromRemote( "__objmethod", oTpuy:oUser:cHandle, #<method>[, <params>] )
*/

#xtranslate ~<!msg!>[(<params,...>)] => ;
            FromRemote( "__object", "oApp", #<msg>[, <params>] )

#xtranslate ~<!method!>([<params,...>]) => ;
            FromRemote( "__objmethod", "oApp", #<method>[, <params>] )


#xtranslate ~<!object!>:<!msg!>[(<params,...>)] => ;
            FromRemote( "__object", #<object>, #<msg>[, <params>] )

#xtranslate ~<!object!>:<!method!>([<params,...>]) => ;
            FromRemote( "__objmethod", #<object>, #<method>[, <params>] )



#xtranslate r:<object>:<!msg!> => ;
            FromRemote( "__object", <object>, #<msg> )

#xtranslate r:<object>:<!method!>([<params,...>]) => ;
            FromRemote( "__objmethod", <object>, #<method>[, <params>] )

#xtranslate ~~<object>:<!msg!>[(<params,...>)] => ;
            FromRemote( "__object", <object>, #<msg>[, <params>] )

#xtranslate ~~<object>:<!method!>([<params,...>]) => ;
            FromRemote( "__objmethod", <object>, #<method>[, <params>] )

#xtranslate GET <uValue> FROM QUERY <object> => FromRemote( "__objmethod",<object>,#<uValue> )

#xtranslate ~get(<object>:<uValue>) => FromRemote( "__objmethod",<object>,#<uValue> )

#xtranslate rDbServer:New(<!object!>) => ;
            netio_funcexec( "db_connect", #<object> )


/* TPuy */

#xtranslate ~HGet(<!func!>([<params,...>])) => ;
            hb_deserialize(netio_funcexec( #<func> [,<params>] ))
             

#xtranslate ~~RunXBS(<cScript>[,<params,...>] [<lMute: MUTE>] ;
                    [SCHEMA <cSchema>] ) => ;
              oTpuy:rRunXBS( <cScript>,[<.lMute.>],[<cSchema>][,<params>] )


//eof

