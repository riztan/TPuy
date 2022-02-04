/*
 * $Id: gmail.prg 2012-12-26 17:26 riztan $
 */

/*
 *
 * Copyright 2011 Riztan Gutierrez <riztan / at / gmail.com>
 *
 */

/*
 */
#include "common.ch"
#include "gmail.ch"

#require "hbssl"
#require "hbtip"

REQUEST __HBEXTERN__HBSSL__

#include "simpleio.ch"

Function tpy_IsMail(cMail)
   Local cRegExp

   cRegExp := "^[_a-z0-9-]+(\.[_a-z0-9-]+)"
   cRegExp += "*@[a-z0-9-]+(\.[a-z0-9-]+)*"
   cRegExp += "(\.[a-z]{2,3})$"

return hb_RegExMatch( cRegExp, ALLTRIM(cMail) )


Function tpy_IsLogin( cLogin )
   Local lResp := .f.
   Local cRegExp

   cRegExp := "^[a-z\_d]{4,15}$"
   lResp := hb_RegExMatch( cRegExp, cLogin )
return lResp


Function tpy_SendMail( cTo, cSubject, cBody, cFrom, cPassword )
   Local lResp := .f.

   IF ! tip_SSL()
      ? "Error: Requires SSL support"
      RETURN lResp
   ENDIF

   hb_default( @cFrom    , G_EMAIL  )
   hb_default( @cPassword, G_PASSWORD  )
   hb_default( @cTo      , G_EMAIL  )
   hb_default( @cSubject , G_SUBJECT )
   hb_default( @cBody    , G_BODY )

   lResp := hb_SendMail( ;
      "smtp.gmail.com", ;
      465, ;
      "Proyecto Tpuy", ;
      cTo, ;
      NIL /* CC */, ;
      {} /* BCC */, ;
      cBody, ;
      cSubject, ;
      NIL /* attachment */, ;
      cFrom, ;
      cPassword, ;
      "", ;
      NIL /* nPriority */, ;
      NIL /* lRead */, ;
      .T. /* lTrace */, ;
      .F., ;
      NIL /* lNoAuth */, ;
      NIL /* nTimeOut */, ;
      NIL /* cReplyTo */, ;
      .T., ;
      NIL, ;
      "utf8" )

   RETURN lResp


//eof
