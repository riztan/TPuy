/*
 *  TPublic().
 *  Clase para el reemplazo de Variables Publicas
 *  Esta basada en la clase original TPublic de
 *  Daniel Andrade Version 2.1
 *
 *  Rosario - Santa Fe - Argentina
 *  andrade_2knews@hotmail.com
 *  http://www.dbwide.com.ar
 *
 *  con Aportes de:
 *     [ER] Eduardo Rizzolo
 *     [WA] Wilson Alves - wolverine@sercomtel.com.br	18/05/2002
 *     [RG] Riztan Gutierrez - riztan@gmail.com 28/10/2008
 *
 *  Sustituido uso de Arreglos por Hashes  [RG]
 *
 *  DATAS
 *	hVars		   - Hash de variables
 *	cName		   - Nombre ultima variable accedida
 *	nPos		   - Valor ultimo variable accedida
 *	lAutomatic	- Asignación automatica, por defecto TRUE	[WA]
 * lSensitive  - Sensibilidad a Mayusculas, por defecto FALSE [RG]
 *
 *  METODOS
 *	New()		- Contructor
 *	Add()		- Agrega/define nueva variable
 *	Del()		- Borra variable
 *	Get()		- Accede a una veriable directamente
 *	Set()		- Define nuevo valor directamente
 *	GetPos()	- Obtener la posición en el Hash
 *	Release()	- Inicializa el Hash
 *	IsDef()		- Chequea si una variable fue definida
 *	Clone()		- Clona el Hash
 *	nCount()	- Devuelve cantidad de variables definidas
 *
 *  NOTA
 *	Para acceder al valor de una variable, se puede hacer de 2 formas,
 *	una directa usando oPub:Get("Codigo") o por Prueba/Error oPub:Codigo,
 *	este último es mas simple de usar pero más lento.
 *
 *	Para definir un nuevo valor a una variable tambien puede ser por 2 formas,
 *	directamente por oPub:Set("Codigo", "ABC" ), o por Prueba/Error
 *	oPub:Codigo := "ABC".
 *
 *	Las variables definidas NO son case sensitive.
 *
 *  ULTIMAS
 *	Se guarda el Nombre y Posición de la última variable accedida para incrementar
 *	la velocidad. (Implementado por Eduardo Rizzolo)
 *
 *  EJEMPLO
 *	FUNCTION Test()
 *	local oP := TPublic():New(), aSave, nPos
 *
 *	oP:Add("Codigo")     // Defino variable sin valor inicial
 *	oP:Add("Precio", 1.15)     // Defino variable con valor inicial
 *	oP:Add("Cantidad", 10 )
 *	oP:Add("TOTAL" )
 *
 *	// Acceso a variables por prueba/error
 *	oP:Total := oP:Precio * oP:Cantidad
 *
 *	// Definicion y Acceso a variables directamente
 *	oP:Set("Total", oP:Get("precio") * oP:Get("CANTIDAD") )
 *
 *	oP:Del("Total")         // Borro una variable
 *	? oP:IsDef("TOTAL")     // Verifico si existe una variable
 *
 *	nPos := oP:GetPos("Total") // Obtengo la posición en el array
 *
 *	oP:Release()         // Borro TODAS las variables
 *
 *	oP:End()       // Termino
 *
 *	RETURN NIL
 *
 *  EXEMPLO (Asignación Automática)
 *
 *	FUNCTION MAIN()
 *	LOCAL oP:=TPublic():New(.T.)
 *
 *	op:nome		:= "Wilson Alves"
 *	op:Endereco	:= "Rua dos Cravos,75"
 *	op:Cidade	:= "Londrina-PR"
 *	op:Celular	:= "9112-5495"
 *	op:Empresa	:= "WCW Software"
 *
 *	? op:Nome,op:Endereco,op:Cidade,op:celular,op:empresa
 *
 *	op:End()
 *	RETURN NIL
 *
 */

#include "gclass.ch"
#include "hbclass.ch"
#include "proandsys.ch"

// GLOBAL EXTERNAL oTpuy
memvar oTpuy

/*
 * TPublic()
 */
/**\file tpublic.prg
 * \class TPublic. Clase TPublic
 *
 *  Clase para el reemplazo de Variables Publicas
 *  Esta basada en la clase original TPublic de
 *  Daniel Andrade Version 2.1
 *  
 *  \see Add().
 */
CLASS TPublic

#xtranslate HGetAutoAdd( <hash> )  =>  ( hb_HAutoAdd(<hash>) == 2 )
//#xtranslate HHasKey( <hash>, <cVar> )  =>  ( hb_HHasKey(<hash>,<cVar>) )

   VISIBLE:

   DATA  lAutoAdd    AS LOGICAL	 INIT .T.		
   DATA  lSensitive  AS LOGICAL	 INIT .F.		
   DATA  lOrder      AS LOGICAL	 INIT .T.

   DATA  hVars

   DATA  nPos        AS NUMERIC    INIT 0   // READONLY // [ER]
   DATA  cName       AS CHARACTER  INIT ""  // READONLY // [ER]

   METHOD New( lAutoAdd, lSensitive, lOrder )          /**New(). */
   METHOD End()   

   METHOD Add( cName, xValue )                 /**Add(). */
   METHOD Del( cName )             
   METHOD Get( cName ) 
   METHOD Set( cName, xValue )

   METHOD GetPos( cName )
   METHOD GetVar( nPos )

   METHOD IsDef( cName )   INLINE HHasKey( ::hVars, cName )

   METHOD Clone()          INLINE HClone( ::hVars )
   METHOD nCount()         INLINE Len( ::hVars )

   METHOD GetArray()           

   METHOD Release()        INLINE ::hVars := Hash()


   ERROR HANDLER OnError( uValue )

ENDCLASS


METHOD END()
   Local uValue
   FOR EACH uValue IN ::hVars
      If IsMethod( uValue, "END" )
         uValue:End()
      EndIf
      uValue := NIL
   NEXT 
   ::Release()
RETURN 


STATIC FUNCTION ISMETHOD(oObject,cMethod)
   local lResp := .f.
   if !hb_IsObject( oObject ) ; return lResp ; endif
   if ASCAN( __objGetMethodList( oObject ),{|x| x==cMethod } ) <> 0
      lResp := .t.
   endif
RETURN lResp

/*
 *  TPublic:New()
 */
/** Metodo Constructor.
 *  Permite generar la instancia de un objeto TPublic,
 *  Se puede inicializar con los parametros lAutomatic y lSensitive, 
 *  para definir si permite la creacion de variables y si admite 
 *  sensibilidad a las mayusculas respectivamente.
*/
METHOD New( lAutoAdd, lSensitive, lOrder ) CLASS TPublic

   ::hVars := Hash()

   DEFAULT lAutoAdd:=.T., lSensitive:=.F., lOrder := .T.

   HSetAutoAdd( ::hVars, lAutoAdd )

   HSetCaseMatch( ::hVars, lSensitive )

   hb_HKeepOrder( ::hVars, !lOrder )

   ::cName:=""
   ::lAutoAdd  :=lAutoAdd
   ::lSensitive:=lSensitive
   ::lOrder    :=lOrder

RETURN Self

/** 
 *  TPublic:Add()
 */
/** Metodo Add.
 *  Permite adicionar una variable al objeto TPublic,
 *  \param cName.
 *  \param xValue.
 *  \return Self.
*/
METHOD Add( cName, xValue ) CLASS TPublic

   If ::lAutoAdd .AND. !::IsDef( cName )
      HSet( ::hVars, cName, xValue )
   EndIf

RETURN Self

/**
 *  TPublic:Del()
 */
METHOD Del( cName ) CLASS TPublic

   If ::IsDef( cName )
      HDel( ::hVars , cName )
   EndIf

RETURN Self

/**
 *  TPublic:Get()
 */
METHOD Get( cName ) CLASS TPublic

   Local xRet:=NIL

   If ::IsDef( cName )
      xRet := HGet( ::hVars , cName )
   Endif

RETURN xRet

/**
 *  TPublic:Set()
 */
METHOD Set( cName, xValue ) CLASS TPublic

   If ::IsDef( cName )
      HSet( ::hVars , cName , xValue )
   Else
      ::Add( cName, xValue )
   Endif

RETURN Self

/**
 *  TPublic:GetPos() 
 */
METHOD GetPos( cName ) CLASS TPublic
   Local nRet:=0

   If ::IsDef( ::hVars )
      nRet := HGetPos( ::hVars, cName )
   Endif

RETURN nRet


/**
 *  TPublic:GetVar()                         
 */
METHOD GetVar( nPos ) CLASS TPublic

   Local nRet:=0

   If !( nPos > Len(::hVars) )
      nRet := HGetValueAt( ::hVars, nPos )
   Endif
   
RETURN nRet


/**
 *  TPublic:GetArray()
 */
METHOD GetArray() CLASS TPublic

   Local nCont:= 1, nHash:= Len(::hVars)
   Local aRet:=ARRAY( nHash , 2 )
   Local aKeys, aValues

   aKeys  := HGetKeys( ::hVars )
   aValues:= HGetValues( ::hVars )

   While nCont <= nHash

      aRet[ nCont , 1 ]:= aKeys[ nCont ]
      aRet[ nCont , 2 ]:= aValues[ nCont ]
      nCont++

   EndDo

RETURN aRet


/**
 *  OnError()
 */
METHOD OnError( uValue ) CLASS TPublic

  Local cMsg   := UPPE(ALLTRIM(__GetMessage()))
  Local cMsg2  := Subs(cMsg,2)

  If SubStr( cMsg, 1, 1 ) == "_" // Asignar Valor
     If !::IsDef( cMsg2 )
        ::Add( cMsg2 , uValue )
     Else
        ::Set(cMsg2, uValue )
     EndIf
  Else
     If ::IsDef( cMsg )
        Return ::Get( cMsg ) 
     EndIf
  EndIf


RETURN uValue





//EOF


