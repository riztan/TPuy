/*
 * $Id: 2015/09/29 21:41:32 tpyentry.prg riztan $
 */
/*
   Copyright © 2008-2015  Riztan Gutierrez <riztang@gmail.com>

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

/** \file tpyentry.prg.
 *  \brief Clase pare entry desde tpuy (complemento de gentry)
 *  \author Riztan Gutierrez. riztan@gmail.com
 *  \date 2015
 *  \remark  
*/


#include "hbclass.ch"
#include "common.ch"
#include "tpyentry.ch"

memvar  oTpuy

/*
#define TPYENTRY_DOCUMENT   0
#define TPYENTRY_PORCENT    1
#define TPYENTRY_INTEGER    2
#define TPYENTRY_DECIMAL    3
#define TPYENTRY_MONEY      4
#define TPYENTRY_EMAIL      5
#define TPYENTRY_DATETIME   6
#define TPYENTRY_DATE       7
#define TPYENTRY_TIME       8
#define TPYENTRY_IP         9
#define TPYENTRY_OTHER      10

// evaluar incorporar los siguientes:
#define TPYENTRY_FILE       11
#define TPYENTRY_FILEPATH   12
#define TPYENTRY_NAME       13
*/

CLASS TpyEntry FROM GEntry

   DATA nType        INIT 10     // TPYENTRY_TYPE
   DATA cDataType                // Tipo de Dato: "N"umeric  "C"haracter  
                                 //               "D"ate  
   DATA cPicture     INIT ""     // Mascara para evaluar y transformar datos.
   DATA cRegExFilter INIT ""     // Filtro de expresion regular
   DATA oMsgWidget               // Contenedor para mostrar mensajes
   DATA cMessage     INIT "El dato es inválido."
   DATA bError       INIT {|| .t. }

   DATA bPosValid    INIT {|| .t. } 

   DATA nDecimals    INIT  oTPuy:nDecimals   // decimales en caso de ser 
                                             // tipo numerico
   DATA lRound       INIT .T.                
   DATA nLen         INIT 15                 // Cantidad Maxima de Caracteres
   DATA lZero        INIT .F.                // Rellenar con ceros?
   DATA lYearsLimit  INIT 20                 // Limite en filtro de Años 
                                             // (Entry tipo fecha)

   DATA cDbVarName   INIT  ""    // Nombre de variable en base de datos.
   DATA cTitle       INIT  ""    // Titulo o Nombre que visualmente 
                                 // representaria este objeto.
   

   METHOD New( bSetGet, cPicture, bValid, aCompletion, oFont, oParent, lExpand,;
               lFill, nPadding , lContainer, x, y, cId, uGlade, uLabelTab, lPassWord,;
               lEnd , lSecond, lResize, lShrink, left_ta,right_ta,top_ta,bottom_ta,;
               xOptions_ta, yOptions_ta, bAction, ulButton, urButton )
      
   METHOD GetText()           INLINE  ALLTRIM( ::Super:GetText() )  
   METHOD GetValue()          INLINE  ALLTRIM( ::Super:GetText() )  

   METHOD Get()               // Obtener el valor del entry segun el tipo de dato.

   METHOD ToSql( nDBType )    INLINE ToSql( ::Get(), nDbType ) // 0=MySql 
                                                               // 1=PostgreSQL

   METHOD SetText( cText )    INLINE  ::Super:SetText( ALLTRIM(cText), .F. )
   METHOD SetValue( cText )   INLINE  ::SetText( cText )
   METHOD Set( cText )        

   METHOD SetDecimals( nDecimals )  

   METHOD Empty()             INLINE  Empty( ::GetText() )

//   METHOD SetCondition        VIRTUAL // Luego de validar, si no se 
                                        // cumple la condicion el entry
                                        // debe ser no editable
   

ENDCLASS



METHOD New( nType, bSet, cRegExFilter, oMsgWidget, cPicture, bValid,;
            nLen, lZero, ... ) CLASS TPYENTRY

   default nType        to TPYENTRY_OTHER
   default cPicture     to ""
   default cRegExFilter to ""
   default nLen         to 0
   default lZero        to .f.

   ::Super:New( bSet, cPicture, bValid, ... )

   ::nType := nType
   ::nLen  := nLen
   ::lZero := lZero

   ::SetMaxLength( ::nLen )

   if ::nType = TPYENTRY_DOCUMENT .or. ;
      ::nType = TPYENTRY_EMAIL    .or. ;
      ::nType = TPYENTRY_DATETIME .or. ;
      ::nType = TPYENTRY_TIME     .or. ;
      ::nType = TPYENTRY_IP       .or. ;
      ::nType = TPYENTRY_OTHER

      ::cDataType := "C"

   elseif ::nType = TPYENTRY_DATE

      ::cDataType := "D"

   elseif ::nType = TPYENTRY_DECIMAL .or. ;
          ::nType = TPYENTRY_PORCENT .or. ;
          ::nType = TPYENTRY_MONEY   .or. ;
          ::nType = TPYENTRY_INTEGER

      ::cDataType := "N"

   endif

   if ::cDataType = "N" .and. Empty( cPicture )
      ::cPicture := oTpuy:cDefDecMask
   else
      ::cPicture := cPicture
   endif

   ::cRegExFilter := cRegExFilter

   if hb_IsObject( oMsgWidget )
      // verificar que tenga el metodo SetText()
      ::oMsgWidget := oMsgWidget
   endif

   if hb_IsBlock( bValid )
      ::bPosValid := bValid
   endif

//   if hb_IsNil( bValid )
      Do Case 
      Case ::nType = TPYENTRY_DOCUMENT
         ::nDecimals := 0
         if Empty( ::cRegExFilter ) 
            ::cRegExFilter := "^[0-9A-Z]{0,1}"  +;  // Primer caracter solo numero o letra
                              "+[0-9A-Z-]{0,}"  +;  // Cuerpo: numero, letras o guiones. 
                              "([0-9A-Z])$"    // último caracter solo numero o letra
         endif
         ::bValid    := { | this | __VALDOCUMENT( this ) }

      Case ::nType = TPYENTRY_DATE
         ::nDecimals := 0
         ::bValid    := { | this | __VALDATE( this )     }

      Case ::cDataType = "N"
//::nType = TPYENTRY_DECIMAL
         ::bValid    := { | this | __VALNUMERIC( this )  }

      Other      
         if hb_IsBlock( bValid )
            ::bPosValid := bValid
         endif
         ::bValid    := {| this | __VALOTHER( this )     }
      EndCase
//   endif

RETURN Self




METHOD Set( xValue )  CLASS TPYENTRY
   local cValue := ""
   local cType
   local cMask

   cType := ValType( xValue )

   if ::cDataType = "C"
      if cType = "C"
         ::SetText( xValue )
         return .T.
/*
      elseif cType = "D"
         if xValue == "."
            ::SetText( DTOC(oTpuy:dFecha) )
            return .T.
         endif
*/
      endif
   endif

   if ::cDataType = "N"
      if cType = "C" 
         ::SetText( TRANSFORM( ToNum( xValue ), ::cPicture ) )
         return .T.
      endif
      if cType = "N"
         ::SetText( TRANSFORM( xValue, ::cPicture )  )
         return .T.
      endif
   endif

   if ::cDataType = "D"
      if cType = "D" 
         ::SetText( DTOC( xValue ) )
         return .T.
      elseif cType = "C"
         ::SetText( DTOC( CTOD( xValue ) ) )
         return .T.
      endif
   endif

return .F.



/**
 * Obtiene el valor del contenido del get transformado al tipo de dato.
 */
METHOD Get()  CLASS TPYENTRY
   local xValue

   if ::cDataType = "C"

      xValue := ::GetValue()
           
   elseif ::cDataType = "D"// .and. ! Empty(cValue)
      xValue := CTOD( ::GetValue() )

   elseif ::cDataType ="N"
      xValue := ToNum( ::GetValue() )

   endif

RETURN xValue


/** \brief Reasigna la mascara del formato numerico de acuerdo al nro de decimales indicado
 */
METHOD SetDecimals( nDecimals )  CLASS TPYENTRY

   default nDecimals to oTpuy:nDecimals

   ::cPicture := iif( oTpuy:cSepDec == ",", "@E ", "@R " )

   if nDecimals == ::nDecimals; return .t. ; endif

   ::nDecimals := nDecimals
   if nDecimals = 0
      ::cPicture += "999,999,999"
   else 
      ::cPicture += "999,999,999."+REPLICATE( '9', ::nDecimals )
   endif
Return .t.



/**
 *  FUNCIONES PARA VALIDACION
 */



/** \brief Validacion predeterminada para entry tipo documento.
 */
STATIC FUNCTION __VALDOCUMENT( oEntry )
   local nVal
   if !oEntry:Empty() //!Empty( oEntry:cRegExFilter ) .and. !oEntry:Empty()

      if !Empty( oENtry:cRegExFilter )
         if !hb_RegExMatch( oEntry:cRegExFilter, oEntry:GetText() )
            if hb_IsObject( oEntry:oMsgWidget )
               oEntry:oMsgWidget:SetText( oEntry:cMessage )
            endif
            if hb_IsBlock( oEntry:bError )
               EVAL( oEntry:bError, oEntry )
            else
//               oEntry:SetText('')
               if !EVAL( oEntry:bPosValid, oEntry )
                  if hb_IsBlock( oEntry:bActionBtn )
                     oEntry:SetFocus()
                     EVAL( oEntry:bActionBtn, oEntry )
                  endif
               endif
            endif
            return .F.
         endif
      endif

      if oEntry:nLen>0 .and. oEntry:lZero
         nVal := ABS( VAL(oEntry:GetText()) )  // Evitamos un monto negativo.
         if nVal != 0
            oEntry:Set( STRZERO( nVal, oEntry:nLen ) )
         endif
      endif
      if !EVAL( oEntry:bPosValid, oEntry ) 
         oEntry:SetFocus()
         return .F.
      endif

      if hb_IsObject( oEntry:oMsgWidGet() )
         oEntry:oMsgWidget:SetText('')
      endif

   else
      if hb_IsBlock(oEntry:bPosValid)
         return EVAL( oEntry:bPosValid, oEntry )
      endif
   endif
RETURN .T.



/** \brief Validacion predeterminada para entry tipo Fecha.
 */
STATIC FUNCTION __VALDATE( oEntry )
   local lResult
   local cValue, dValue

   if !oEntry:Empty()

      cValue := oEntry:GetText()

      if hb_IsObject( oEntry:oMsgWidGet() )
         oEntry:oMsgWidget:SetText('')
      endif


      if cValue == "."
         oEntry:Set( oTPuy:dFecha )
         if hb_IsBlock(oEntry:bPosValid)
            return EVAL( oEntry:bPosValid, oEntry )
         endif
         return .t.
      endif


      if cValue == ".." .and. hb_IsBlock( oEntry:bActionBtn )
         oEntry:SetText('')
         EVAL( oEntry:bActionBtn, oEntry )
         oEntry:SetFocus()
         if hb_IsBlock(oEntry:bPosValid)
            return EVAL( oEntry:bPosValid, oEntry )
         endif
         return .t.
      endif


      dValue := CTOD( cValue )

      if Empty( dValue )

         oEntry:SetText('')
         if hb_IsBlock( oEntry:bActionBtn )
            EVAL( oEntry:bActionBtn, oEntry )
         else

            if hb_IsObject( oEntry:oMsgWidget )
               oEntry:oMsgWidget:SetText( oEntry:cMessage )
            endif
            if hb_IsBlock( oEntry:bError )
               EVAL( oEntry:bError, oEntry )
            endif
            return .F.

         endif

      else

         if ABS( YEAR( oTPuy:dFecha ) - YEAR( dValue ) ) > oEntry:lYearsLimit
            oEntry:SetText('')
            if hb_IsObject( oEntry:oMsgWidget )
               oEntry:oMsgWidget:SetText( oEntry:cMessage )
            endif
            if hb_IsBlock( oEntry:bError )
               EVAL( oEntry:bError, oEntry )
            endif
            return .F.
         else
            oEntry:Set( dValue )
         endif

      endif


      if hb_IsObject( oEntry:oMsgWidGet() )
         oEntry:oMsgWidget:SetText('')
      endif

   endif
   if hb_IsBlock(oEntry:bPosValid)
      return EVAL( oEntry:bPosValid, oEntry )
   endif

RETURN .T.


STATIC FUNCTION __VALNUMERIC( oEntry )

   local cValue, cRegExp, nValue, cDec

   if oEntry:Empty() ; return .t. ; endif

   cValue := oEntry:GetText()
   cDec := ALLTRIM(STR( oEntry:nDecimals ))

   cRegExp := "^-?[\"+oTpuy:cSepMiles+"0-9]{1,9}(\"
   cRegExp += oTpuy:cSepDec+"[0-9]{0,"+cDec+"})?$"
   if oEntry:nType = TPYENTRY_MONEY
      cRegExp := "^[\"+oTpuy:cSepMiles+"0-9]{1,9}(\"
      cRegExp += oTpuy:cSepDec+"[0-9]{0,"+cDec+"})?$"
   endif

   nValue := ToNum( cValue )
   if hb_RegExMatch( cRegExp, cValue )
      oEntry:SetText( iif(left(cValue,1)=="+","+","") + ToStrF( nValue, oEntry:cPicture ) )
   else
      if LEN( cValue ) > 0 .and. VAL( cValue ) != 0
         oEntry:SetText( iif(left(cValue,1)=="+","+","") + ToStrF( nValue, oEntry:cPicture ) )
      endif
      if hb_IsObject( oEntry:oMsgWidget )
         oEntry:oMsgWidget:SetText( oEntry:cMessage )
      endif
      return EVAL( oEntry:bPosValid, oEntry )
   endif
   if !EVAL( oEntry:bPosValid, oEntry )
      if hb_IsObject( oEntry:oMsgWidget )
         oEntry:oMsgWidget:SetText( oEntry:cMessage )
      endif
      return .F.
   endif
   if hb_IsObject( oEntry:oMsgWidget )
      oEntry:oMsgWidget:SetText( '' )
   endif

RETURN .t.


/** \brief Validacion predeterminada para entry no definido.
 *         El objetivo en este caso es tratar de evitar una inyeccion sql.
 */
STATIC FUNCTION __VALOTHER( oEntry )

   local cValue, dValue

   if oEntry:Empty() ; return .t. ; endif
      
   cValue := oEntry:GetText()

   if AT("'", cValue)>0 
      cValue := STRTRAN( cValue, "'", "\'" )
   endif

   if AT("\", cValue)>0 
      cValue := STRTRAN( cValue, "\", "\\" )
   endif

   if AT('"', cValue)>0 
      cValue := STRTRAN( cValue, '"', '\"' )
   endif

   cValue := oEntry:SetText( cValue )

   if hb_IsBlock(oEntry:bPosValid)
      return EVAL( oEntry:bPosValid, oEntry )
   endif

return .t.

//eof
