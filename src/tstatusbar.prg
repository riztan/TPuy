/** Proyecto TPuy 
 *  TStausBar.xbs  Clase para gestionar la información a mostrar en una barra de estado. 
 *
 */

#include "common.ch"
#include "hbclass.ch"

CLASS TStatusBar FROM GSTATUSBAR
 
   DATA oStatusBar
   DATA hPila
   DATA lMessage
   DATA hMessage 

   METHOD New( oStatusBar )
  
   METHOD Add( cKey, uValue )
   
   METHOD Message( cMessage, nDuration )
   METHOD EndMessage()   INLINE ( ::lMessage := .f., ::Refresh() )
   METHOD MessageEnd()   INLINE ( ::lMessage := .f., ::Refresh() )

   METHOD Refresh()

   METHOD End()          INLINE (::oStatusBar:End(), ::Release())

ENDCLASS



METHOD New( oStatusBar )   CLASS TSTATUSBAR

   if hb_IsObject( oStatusBar )
      ::oStatusBar := oStatusBar
   else
      return NIL
   endif

   ::hPila := hb_Hash()
   
   ::lMessage := .f.

RETURN Self



METHOD Add( cKey, uValue )  CLASS TSTATUSBAR
   local cType
   cType := VALTYPE( uValue )

   if !( (cType $ "CB") .and. !Empty(uValue) )
      return .f.
   endif

   hb_hSet( ::hPila, cKey, uValue )

RETURN .t.



METHOD Refresh()   CLASS TSTATUSBAR
   local cValue := "", uItem
   loca cType, cKey

   if ::lMessage
      // Evaluamos si ya se cumplió el tiempo de mostrar el mensaje
      if hb_DateTime() - ::hMessage["finish"] >= 0 
        ::lMessage := .f.
      endif
      return .t.
   endif
   

   FOR EACH uItem IN ::hPila
      cKey := hb_hKeyAt(::hPila, uItem:__EnumIndex() )
      cType := VALTYPE( uItem )
      if cType = "B"
         cValue += EVAL( uItem )
      endif
      if cType = "C"
         cValue += uItem
      endif
      iif(!Empty( cValue ), cValue += " ", nil )
   NEXT

   if VALTYPE( cValue ) = "C"
      ::oStatusBar:SetText( cValue )
   endif
RETURN .t.



METHOD Message( cMessage, nDuration )
   default nDuration to .7

   if nDuration < 0 .or. nDuration > 3 ; nDuration := 3 ; endif
   nDuration := nDuration / 100000

   ::lMessage := .t.
   ::oStatusBar:SetText( cMessage )
   ::hMessage := {;
                  "finish"   => hb_DateTime()+nDuration ;
                 }
   SysRefresh(.t.)


//eof
