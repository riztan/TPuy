/* 
 * Proyecto TPuy
 * TDocument: Clase Formulario de Edición de Documentos
 *
 */

#include "tpy_class.ch"

//#define  ORSEIT_ICON  oTPuy:cImages+"orseit.ico"

CLASS TDOCUMENT FROM TPUBLIC

   DATA lDebug      INIT .F.
   DATA lTheme      INIT .F.
   DATA oLogBox     INIT NIL     // Contenedor para depositar registros del sistema
   DATA oLog        INIT NIL     // Registro de eventos (para debug)
   DATA lDatos      INIT .F.     // Indicador para saber si hay datos en el grid.

   DATA nLimit      INIT 10
   DATA cColumns    INIT "inv_codigo, inv_descri"
   DATA cCondition  INIT ""
   DATA cOrder      INIT ""
   DATA lAscendente INIT .F.

   DATA cResFile    INIT nil     //oTpuy:cResources+"plantilla_cargas_view.ui"
   DATA cIconFile   INIT oTpuy:cImages+"orseit.ico"
   DATA cTitle      INIT "Edición"

   DATA nHigh       INIT 600    // Altura de la ventana
   DATA nWide       INIT 1000   // Ancho de la ventana

   DATA aStruct                 // Estructura para el modelo de datos
   DATA aData                   // Datos (items) para el modelo de datos.

   DATA oModel                  // Modelo de datos del formulario
   DATA oListBox                // ListBox del Modelo de datos.

   DATA oParent                 // Widget o Control padre de este formulario.
   DATA oWnd                    // Ventana del formulario
   DATA oImgBanner              // Imagen tipo Banner en la ventana
   DATA oLabBanner              // Etiqueta en el Banner.

   DATA nOption     INIT 0      // Opcion tipo datapro 1=incluir, 3=modificar

   DATA nStatus     INIT 0      // Modo del documento
                                // 0 = Lectura
                                // 1 = Escritura

   DATA oFecha
   DATA oEntFecha

   DATA oRes         INIT  NIL  // Objeto de Recursos

   DATA bPreRefresh  INIT  {|| .t. }   // Codebloc a ejecutar antes de refrescar 
                                       // valores en modelo de datos

   DATA bRefresh     INIT  {|| .t. }   // Codebloc que se ejecuta cuando se solicita
                                       // Actualizar el modelo de datos.

   DATA bPosRefresh  INIT  {|| .t. }   // Codebloc a ejecutar luego de actualizar
                                       // el modelo de datos.

   DATA bPreUpdate   INIT  {|| .t. }   // Codebloc a ejecutar antes de guardar datos
                                       // del formulario.

   DATA bFecha       INIT  {|| .t. }   // Codebloc a ejecutar para validar un campo fecha (revisar)

   DATA lEstado      INIT .F.          // Indica si el widget oEstado está presente.

   DATA bEdit        INIT  {|| .t. }

   DATA bExit        INIT  {|| .t. }
   DATA lFSalir      INIT .F.
   DATA lQuit        INIT .T.          // Indica si debe ejecutar QUIT (en algunos windows de no hacerlo da problema)

   Method New( oParent ) 
   Method SetLimit( nLimit )          INLINE  ::nLimit     := nLimit
   Method SetColumns( cColumns )      INLINE  ::cColumns   := cColumns
   Method SetCondition( cCondition )  INLINE  ::cCondition := cCondition
   Method SetTitle( cTitle )          INLINE  ::cTitle     := cTitle

   Method CreaVentana()
//   Method SetEntry( cTipo, cNombre  )
/*   Method SetEntry( cVar, bValid, bAction, ;
                    cId, uGlade )
*/
   Method Exit()
   Method Quit()                      INLINE  ::Exit()
   Method End()                       INLINE  ::Exit()
   Method Close()                     INLINE  ::Exit()

   Method Show()
   Method Activate()                  INLINE  ::Show()

   //Method Configure() // Crea Ventana de Configuración.
   Method Refresh()

   Method SetResFile( cResFile )    

   Method Traza( cText ) 
   Method SetTheme( cTema )

   /*Metodos para evaluar expresiones regulares...
     Esto debe pasar a clases hijas de gentry que deben hacerse
     */
   Method ValExpNumDoc( uValue )              //Entrada tipo documento
   Method ValExpPorcen( uValue, oEntRefer )   //Entrada tipo Monto de Porcentaje
                                              //        (Dcto, Iva, Comision, etc)

   Method ValExpMonto( uValue, cMask )        // Entrada tipo Monto


ENDCLASS

/*
METHOD SetEntry( cVar, bValid, bAction, cId, uGlade ) CLASS TDocument
   local oEntry

   default bAction := {|| .t. }

   DEFINE ENTRY oEntry VAR cVar ;
          ACTION bAction        ;
          ID cId RESOURCE uGlade

   if hb_IsBlock( bValid )
      Gtk_Signal_Connect( oEntry:pWidget, ;
                          "focus-out-event", ;
                          bValid )
   endif
   
RETURN oEntry
*/

METHOD New( oParent ) CLASS TDocument

   ::Super:New()
   ::oParent := oParent

   ::lDatos := .F.

/*
gtk-color-scheme	= "base_color:#fefefe\nfg_color:#000000\ntooltip_fg_color:#000000\nselected_bg_color:#3399ff\nselected_fg_color:#FFFFFF\ntext_color:#313739\nbg_color:#F0F0F0\ninsensitive_bg_color:#F4F4F2\ntooltip_bg_color:#FFFFE1"
*/
   /*Efecto pijama*/

   gtk_rc_parse_string( 'gtk-font-name= "Tahoma 7" ' + CRLF +;
                        'style "bicolor"{' + CRLF + ;
                        ' GtkTreeView::even-row-color = "#E3E3FC"' + CRLF +;
                        ' GtkTreeView::odd-row-color = "#FDFDFD"' + CRLF +;
                        ' GtkTreeView::allow-rules = 1 ' + CRLF +;
                        '}'                           + CRLF + ;
                        'class "GtkTreeView" style "bicolor"' )

//   gtk_rc_parse_string( 'gtk-font-name= "Tahoma 8" ' )

RETURN self



METHOD CreaVentana() CLASS TDocument
   local oFBanner, oFFrame

   if !FILE(::cResFile)
      MsgStop("No es posible localizar el archivo de recursos", "Atención")
      return nil
   endif

   SET RESOURCES ::oRes FROM FILE ::cResFile

   DEFINE FONT oFBanner NAME "Arial Black"
   DEFINE FONT oFFrame  NAME "Timen New Roman 10 "//"TW Cent MT"
   
   DEFINE WINDOW ::oWnd TITLE ::cTitle ;
          SIZE ::nWide,::nHigh         ;
          ICON_FILE ::cIconFile        ;
          ID "window1" RESOURCE ::oRes

   DEFINE BOX ::oTheme_Bot ID "theme_bot" RESOURCE ::oRes 
   DEFINE BOX ::oLogBox OF ::oTheme_Bot EXPAND FILL //ID "box_debug" RESOURCE ::oRes

   DEFINE BUTTON ::oBtnSalir   ;
      ACTION ::oWnd:End()      ;
      ID "btn_salir" RESOURCE ::oRes


   //::oWnd:bEnd := {| ... | ::Exit( ... ) }

RETURN 

/*
METHOD Exit( lWnd )  CLass TDocument

   default lWnd := .f.

   if lWnd
      ::oWnd:End()
      if !::lFSalir 
         if !MsgNoYes("¿Realmente desea Salir?","Confirme por favor.")
            return .f.
         endif
         ::lFSalir := .t.
         return .t.
      endif
   endif

   if !EVAL( ::bExit )
      return .f.
   endif

   //::Release()
   if ::lQuit
      QUIT
   endif
RETURN .t.
*/


METHOD Show()  Class TDocument

   if ::oWnd:ClassName() ="GWINDOW"  ; return nil ; endif

   if ::lDebug 
      if hb_IsObject( ::oLogBox )
         ::oLog := TREGLOG():New( ::oTheme_Bot )//::oLogBox )
      else
         MsgAlert("No existe el contenedor para resgitros 'oLogBox'.")
         ::lDebug := .f.
      endif
   endif

   ACTIVATE WINDOW ::oWnd CENTER VALID ::Exit( .t. )

Return 



METHOD Refresh( )  Class TDocument
   if hb_IsBlock( ::bPreRefresh ) ; EVAL( ::bPreRefresh, self ) ; endif
   if hb_IsBlock( ::bRefresh    ) ; EVAL( ::bRefresh   , self ) ; endif
   if hb_IsBlock( ::bPosRefresh ) ; EVAL( ::bPosRefresh, self ) ; endif
RETURN 



METHOD TRAZA( cCadena )  CLASS TDocument
  if ::lDebug .and. hb_IsObject( ::oLog )
     ::oLog:Set( cCadena )
  endif
Return


// Verificar que el contenido sea compatible para un numero de documento.
// solo numeros, letras y guion
METHOD ValExpNumDoc( uValue )  Class TDocument 
   local cRegExp, cValue

   cRegExp := "^[0-9A-Z]{0,1}"  +;  // Primer caracter solo numero o letra
              "+[0-9A-Z-]{0,}"  +;  // Cuerpo: numero, letras o guiones. 
              "([0-9A-Z])$"    // Último caracter solo numero o letra

   if uValue == NIL .or. Empty(uValue) ; return .f. ; endif

   if hb_IsObject( uValue )
      cValue := uValue:GetText()
   elseif ValType(uValue)="C" 
      cValue := uValue
   else
      return .f.
   endif

return hb_RegExMatch( cRegExp, cValue )


// oEntRefer es el Entry de referencia para posible cálculo.
// lCalc, indica si debe calcular valor.
Method ValExpPorcen( uValue, oEntRefer, lCalc, cMask, nDecimal )  
   local cRegExp, cValue, nRefer, nMonto, cDec
   local lEntry := .f., nPorcen, nPorDiff, cSigno

   default cMask := oTpuy:cDefDecMask //P_62
   default nDecimal := oTPuy:nDecimals
   
   if uValue == NIL .or. Empty(uValue) ; return .f. ; endif

   cDec := ALLTRIM(STR(nDecimal))

   if hb_IsObject( uValue )
      cValue := ALLTRIM(uValue:GetText())
      lEntry := .t.
   elseif ValType(uValue)="C" 
      cValue := ALLTRIM(uValue)
   else
      return .f.
   endif

/* evaluamos si se pide calcular porcentaje. */
   cRegExp := "^([+-]{1,1})"  +;                   //Primer caracter puede ser '+' o '-' 
              "+[0-9]{1,9}(\"+oTpuy:cSepDec+"[0-9]{0,"+cDec+"})?$"  // El resto debe ser numerico
      
   if hb_RegExMatch( cRegExp, cValue )
      if hb_IsObject( oEntRefer ) 
         nRefer := ToNum( oEntRefer:GetText() )
//::oEstado:SetText( STR(nRefer) )
         if !Empty( nRefer )
            cSigno := LEFT( cValue, 1 ) // si es '+' calculamos el monto de dcto sobre la base dada. 
                                        // si es '-' entonces el monto del dcto esta ya en la base dada y lo extraemos
                                        // ejemplo:  Base=100  y %=10.  '+' = 10  y  '-' = 9,09 
                                        //           '+' => 10 es el 10% de 100
                                        //           '-' => 9,09 es el 10% de 90,91 es decir, un monto X + 9,09 = 100 
            cValue  := RIGHT( cValue, LEN(cValue) - 1 ) 
            nPorcen := ToNum( cValue, nDecimal ) / 100
/*
            if oTpuy:cSepDec==","
               nPorcen := ( VAL( cValue, ",", "." ) ) / 100 ) 
            else
               nPorcen := ( VAL( cValue, ",", "." ) ) / 100 ) 
            endif
*/

            if cSigno = '-'
               nMonto := ROUND( nRefer / ( nPorcen + 1 ), nDecimal)
               nMonto := ROUND( ( nRefer - nMonto ), nDecimal )
               if lEntry ; uValue:SetText( ALLTRIM(TRANSFORM( nMonto, cMask ) )) ; endif
               return .t.
            endif

            nMonto := nRefer * nPorcen
            if lEntry ; uValue:SetText( ALLTRIM(TRANSFORM( nMonto, cMask ) )) ; endif
            return .t.
         else
            if ::lEstado
               ::oEstado:SetText( "No se puede calcular el porcentaje. Monto cero" )
            endif
            return .t.
         endif
      else
         if ::lEstado
            ::oEstado:SetText("No se puede calcular el porcentaje")
         endif
         return .t.
      endif
   else
//View("no cumple el filtro  !"+cValue+"!")
      // si no se solicita calcular, entonces se debe validar el monto.
      if lEntry
         return ::ValExpMonto( uValue, cMask )
      endif
   endif

return .f.



Method ValExpMonto( uValue, cMask, nDec )
//    ::oEntNumDoc:SetText( TRANSFORM( ::oEntNumDoc:GetText(), P_92 ) )
   local cRegExp, cValue, cDec
   local nMonto, lEntry := .f.

return .t.
   default cMask := oTpuy:cDefDecMask //P_92
   default nDec  := oTpuy:nDecimals+1

   cDec := ALLTRIM(STR(nDec))

   cRegExp := "^[\"+oTPuy:cSepMiles+"0-9]{1,9}(\"
   cRegExp += oTpuy:cSepDec+"[0-9]{0,"+cDec+"})?$"

   if uValue == NIL .or. Empty(uValue) ; return .f. ; endif

   if hb_IsObject( uValue )
      cValue := uValue:GetText()
      lEntry := .t.
   elseif ValType(uValue)="C" 
      cValue := uValue
   else
      return .f.
   endif

  if hb_RegExMatch( cRegExp, cValue )
      nMonto := ToNum( cValue )
      if lEntry
//View( nMonto )
         uValue:SetText( ToStrF( nMonto, cMask ), .f. )
      endif
   else
      if ::lEstado; ::oEstado:SetText( "El valor indicado no es válido." ) ; endif
      return .f.
   endif

return .t.



Method SetTheme( cTema )  Class TDocument

   local cFile
   local setting

   default cTema := ""
   cFile := "./themes/" + cTema  + "/gtk-2.0/gtkrc"

   if !File( cFile ) 
      ::Traza( procname() + ": " + "El tema de interfaz " + cTema + "no existe. " ) 
      return
   endif

   gtk_rc_parse( cFile )
   setting := gtk_settings_get_default()
   gtk_rc_reset_styles( setting )

   ::lTheme := .T.

return nil


/*  
 *  Asigna nombre del fichero de recursos (glade)
 */
Method SetResFile( cResFile )
   if File( cResfile )
      ::cResFile := cResFile
      return .t.
   else
      if File( oTpuy:cResources+cResFile )
         ::cResFile := oTpuy:cResources+cResFile
         return .t.
      endif
   endif
return .f.


/** Cerrar la ventana y salir
 */

Method Exit( )  CLASS TDocument
   If hb_IsBlock( ::bSalir )
      If !Eval( ::bSalir )
         ::lFSalir := .t.
         return .f.
      EndIf
   Else
      if ::lFSalir 
         ::lFSalir := .f. // Parche. Esto porque cuando se le dice no, vuelve a entrar al metodo..
         return .f. 
      endif
      If MsgNoYes( "Realmente desea Salir", "Por favor, confirme." )
         return .t.
      Else
         ::lFSalir := .t.
         return .f.
      EndIf
   EndIf
return .t.



//FIN CLASE

static procedure Calendario( oForm, oEntry, cEntry )
   local oWnd, oCalendar, cRes
   SET RESOURCES cRes FROM FILE oForm:cResFile

   DEFINE WINDOW oWnd TITLE "Fecha";
          ID "window2" RESOURCE cRes OF oForm:oWnd

     DEFINE CALENDAR oCalendar ID "calendar1" RESOURCE cRes ;
            DATE date() ;
            MARKDAY ;
            ON_DCLICK (__ChgFecha( oForm, o, oEntry, cEntry ),;
                       oWnd:End(), oWnd:=NIL)
//            ON_DCLICK (::oEntFecha:SetText( DTOC(o:GetDate()) ), ;
//                       oWnd:End(), oWnd:=NIL, ::Refresh()  )


   ACTIVATE WINDOW oWnd 

return



static procedure __ChgFecha( oForm, oCalendar, oEntry, cEntry )
  local cValue

  cValue := DTOC( oCalendar:GetDate() )
  oEntry:SetText( cValue )
  /* Ejecutar bloque de codigo pos_edit del entry */
return



/* Prueba, creando objeto para registros de log.. */

CLASS TREGLOG //FROM TPUBLIC
   DATA oRegistro
   DATA oContainer
   DATA oExpander
   DATA oBtn
   DATA cLog  INIT ""
   METHOD New( oParent )
   METHOD SetText( cText )   INLINE ::cLog += cText + CRLF, ::oRegistro:SetText( ::cLog )
   METHOD Set( cText )       INLINE ::SetText( cText )
ENDCLASS


Method NEW( oParent ) Class TRegLog

    local oScroll, cLog

    if !hb_IsObject( oParent )
       return nil
    endif

    DEFINE EXPANDER ::oExpander  PROMPT "Estado" MARKUP OF oParent

           DEFINE TOOLTIP WIDGET ::oExpander ;
                  TEXT "Pulse para desplegar detalles del Estado del Sistema" 

    DEFINE BOX ::oContainer OF ::oExpander VERTICAL CONTAINER

    DEFINE BUTTON TEXT "Limpiar Registro";
           ACTION ( ::cLog:="", ::Set( ::cLog ) ) ;
           OF ::oContainer

    DEFINE SCROLLEDWINDOW oScroll OF ::oContainer EXPAND FILL CONTAINER
           oScroll:SetPolicy( GTK_POLICY_AUTOMATIC,;
                              GTK_POLICY_AUTOMATIC)

    oTpuy:cLog := ""

    DEFINE TEXTVIEW ::oRegistro VAR cLog OF oScroll CONTAINER

        ::oRegistro:SetEditable(.f.)

Return Self


//eof
