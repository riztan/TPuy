/*
 */
#include "hbclass.ch"
#include "common.ch"
#include "gclass.ch"

memvar oTpuy

STATIC s_aIncDir := {}

CLASS TScript 

   DATA hrbCode
   DATA hrbHandle
   DATA cPrgCode
   DATA cMD5
   DATA cDirective
   DATA cName
   DATA cPath
   DATA lError
   DATA cError

   DATA lFile
   DATA cFile
   DATA lBuffer

   DATA uResult

   METHOD New( cFile, cBuffer, cPath, cFunc, lRun, ... )
   METHOD SetBuffer( cBuffer )
   METHOD Refresh()
   METHOD Run( cFunc, ... )
   METHOD End()  INLINE ( hb_hrbUnLoad( ::hrbHandle ), self := NIL )
   

ENDCLASS


METHOD New( cFile, cBuffer, cPath, cFunc, lRun, ... )  CLASS TScript
   Local uRes
   Local cExt
   Local FuncHandle
   Local cVarPATH := GetEnv("PATH")
   Local aVarPath, cValue

   ::lError  := .f.
   ::cError  := ""

   DEFAULT cFunc TO "XBSMAIN"
   DEFAULT lRun  TO .f.

   if Empty(cFile) .and. Empty(cBuffer) 
      ::lError := .t.
      ::cError := "No se ha definido fichero y/o cuerpo del script."
      Return self
   endif

   if !Empty(cFile)

      if !File( cFile )
         ::cName := cFile
         cFile := cPath + AllTrim(cFile) + ".xbs"
      endif

      if !File(cFile) 
         ::lError := .t.
         ::cError := "Fichero no encontrado."
         Return self
      else
         ::cFile    := cFile
         ::cPath    := cPath
         ::cPrgCode := "" //MemoRead( ::cFile )
         ::lFile    := .t.
         ::lBuffer  := .f.
      endif

   endif

   if !Empty( cBuffer )
      ::lFile    := .f.
      ::lBuffer := ::SetBuffer( cBuffer )
   endif

/*
   ::cDirective := "#xtranslate ::<!func!>([<params,...>])  => ; "
   ::cDirective += "   eval( hb_hrbGetFunSym( oTpuy:oScript:_SCRIPTNAME_:HRBHANDLE, #<func>[,<params>] ) ) "

   ::cDirective := StrTran( ::cDirective, "_SCRIPTNAME_", ::cName )

QOUT( ::cDirective )
*/

   if Empty( s_aIncDir )
 
      AADD( s_aIncDir, "-I./include"  )

      cPath := getenv( "HB_INSTALL_INC" )
      IF !EMPTY( cPath )
         AADD( s_aIncDir, "-I" + cPath )
      ENDIF

      cPath := getenv( "TGTK_INC" )
      IF !EMPTY( cPath )
         AADD( s_aIncDir, "-I" + cPath )
      ENDIF

/*
      AEVAL( HB_aTokens( GetEnv("PATH"), hb_osPathListSeparator() ), ;
             {|a| IIF( "inc"$a, AADD( s_aIncDir, "-I" + a ),) } )
*/
      aVarPath := hb_aTokens( cVarPATH, hb_osPathListSeparator() )
      FOR EACH cValue IN aVarPath
         if !( cValue $ s_aIncDir )
            AADD( s_aIncDir, "-I" + cValue )
         endif
      NEXT

#ifdef __PLATFORM__UNIX
      AADD( s_aIncDir, "-I/usr/include/harbour" )
      AADD( s_aIncDir, "-I/usr/local/include/harbour" )
      AADD( s_aIncDir, "-I/usr/local/include/tgtk" )
      AADD( s_aIncDir, "-I"+GetEnv("HOME")+"/t-gtk/include" )
      AADD( s_aIncDir, "-I/usr/local/share/harbour/contrib/xhb" )
#endif
#ifdef __PLATFORM__WINDOWS
      if !("t-gtk" $ cVarPATH)
         if FILE( "/t-gtk/include/gclass.ch" )
            AADD( s_aIncDir, "-I/t-gtk/include" )
         endif
      endif
      if !("harbour/contrib" $ cVarPATH)
         AADD( s_aIncDir, "-I/harbour/contrib/xhb" )
         AADD( s_aIncDir, "-I/harbour/contrib/hbtip" )
         AADD( s_aIncDir, "-I/harbour-project/contrib/xhb" )
         AADD( s_aIncDir, "-I/harbour-project/contrib/hbtip" )
      endif
#endif

   endif


   if lRun
      if ::Refresh()
         ::uResult := ::Run( ::cName, ... )
      endif
   endif

Return Self



METHOD SetBuffer( cBuffer )
   Local lRes := .f.
   If !Empty( cBuffer )
      ::cPrgCode := cBuffer
      lRes := .t.
   EndIf
Return lRes



METHOD Refresh( cPrgCode ) CLASS TScript
   
   Local oErr
   Local lCompile := .t., cMd5,cSource

   DEFAULT cPrgCode := ::cFile

   ::lError := .f.

   if !Empty(::hrbCODE) ; hb_hrbUnLoad( ::hrbHANDLE ) ; endif

   ::uResult := NIL

   if ::lFile 
      if !FILE( ::cFile )
         MsgStop( "No es posible localizar el Script "+::cFile+". " )
         Return .f.
      endif
      cSource := MemoRead( ::cFile )
      cMd5 := hb_MD5( cSource )
      if ISNIL(::cPrgCode) .or. Empty(::cPrgCode) .or.;
         ( ::cMD5 != cMd5 )
         ::cPrgCode := cSource
         ::cMd5 := cMd5
//      else
//? "no actualizamos el fuente de "+::cFile
      else
         lCompile := .f.
      endif
   endif
   
   if !Empty(::cDirective)
      ::cPrgCode := ::cDirective + hb_eol() + ::cPrgCode
   endif

/*
   BEGIN SEQUENCE WITH {|oErr| hbrun_Err( oErr, cPrgCode ) }

      if ISNIL(::hrbCODE) .or. Empty( ::hrbCODE ) .or. lCompile
            ::hrbCODE := NIL
            ::hrbCODE := hb_CompileFromBuf( ::cPrgCode, "harbour", "-n2", "-w0", "-es2", "-q0", ;
                                      s_aIncDir, "-I" + FNameDirGet( ::cFile ) )
//else
// ? "no compilamos "+::cFile+"."
      endif
      IF ::hrbCODE == NIL
         EVAL( ErrorBlock(), oErr ) //"Syntax error." )
      ELSE
         ::hrbHANDLE := hb_hrbLoad( ::hrbCODE )
         IF ::hrbHANDLE = NIL
            ::lError := .t.
            ::cError := "Posible error de Sintaxis"
         ENDIF
      ENDIF

   ENDSEQUENCE
*/

   ::hrbCODE := NIL
   ::hrbCODE := hb_CompileFromBuf( ::cPrgCode, "harbour", "-n2", "-w0", "-es2", "-q0", ;
                                   s_aIncDir, "-I" + FNameDirGet( ::cFile ) )
   if !hb_ISNIL( ::hrbCODE )
      ::hrbHANDLE := hb_hrbLoad( ::hrbCODE )
   else
      ::lError := .t.
      ::cError := "Posible error de Sintaxis"
   endif

RETURN !::lError



METHOD Run( cFunc, ... ) CLASS TScript
   Local FuncHandle

   DEFAULT cFunc TO ::cName

if !hb_IsNIL( ::hrbHANDLE )
   FuncHandle := hb_hrbGetFunSym( ::hrbHANDLE, cFunc )
endif
   If !hb_ISNIL( FuncHandle )
      ::uResult := EVAL( FuncHandle, ... )
   Else
      FuncHandle := hb_hrbGetFunSym( ::hrbHANDLE, "xbsmain" )
      if hb_IsNIL( FuncHandle )
         ::lError := .t.
         ::cError := "No es posible encontrar ["+::cName+" o xbsMain] en el Script "
         return nil
      endif
      ::uResult := EVAL( FuncHandle, ... )
   EndIf
Return ::uResult







STATIC FUNCTION FNameDirGet( cFileName )
   LOCAL cDir

   hb_FNameSplit( cFileName, @cDir )

   RETURN cDir



STATIC FUNCTION hbrun_FindInPath( cFileName )
   LOCAL cDir
   LOCAL cName
   LOCAL cExt

   LOCAL cDirPATH

   hb_FNameSplit( cFileName, @cDir, @cName, @cExt )

   FOR EACH cExt IN iif( Empty( cExt ), { ".hbs", ".hrb" }, { cExt } )

      /* Check original filename (in supplied path or current dir) */
      IF hb_FileExists( cFileName := hb_FNameMerge( cDir, cName, cExt ) )
         RETURN cFileName
      ENDIF

      IF Empty( cDir )

         /* Check in the dir of this executable. */
         IF ! Empty( hb_DirBase() )
            IF hb_FileExists( cFileName := hb_FNameMerge( hb_DirBase(), cName, cExt ) )
               RETURN cFileName
            ENDIF
         ENDIF

         /* Check in the PATH. */
         #if defined( __PLATFORM__WINDOWS ) .OR. ;
             defined( __PLATFORM__DOS ) .OR. ;
             defined( __PLATFORM__OS2 )
         FOR EACH cDirPATH IN hb_ATokens( GetEnv( "PATH" ), hb_osPathListSeparator(), .T., .T. )
         #else
         FOR EACH cDirPATH IN hb_ATokens( GetEnv( "PATH" ), hb_osPathListSeparator() )
         #endif
            IF ! Empty( cDirPATH )
               IF hb_FileExists( cFileName := hb_FNameMerge( hbrun_DirAddPathSep( hbrun_StrStripQuote( cDirPATH ) ), cName, cExt ) )
                  RETURN cFileName
               ENDIF
            ENDIF
         NEXT
      ENDIF
   NEXT

   RETURN NIL


STATIC FUNCTION hbrun_DirAddPathSep( cDir )

   IF ! Empty( cDir ) .AND. !( Right( cDir, 1 ) == hb_ps() )
      cDir += hb_ps()
   ENDIF

   RETURN cDir

STATIC FUNCTION hbrun_StrStripQuote( cString )
   RETURN iif( Left( cString, 1 ) == '"' .AND. Right( cString, 1 ) == '"',;
               SubStr( cString, 2, Len( cString ) - 2 ),;
               cString )


STATIC PROCEDURE hbrun_Err( oErr, cCommand )

   LOCAL xArg, cMessage

   cMessage := "Sorry, could not execute:;;" + cCommand + ";;"
   IF oErr:ClassName == "ERROR"
      cMessage += oErr:Description
      IF ISARRAY( oErr:Args ) .AND. Len( oErr:Args ) > 0
         cMessage += ";Arguments:"
         FOR EACH xArg IN oErr:Args
            cMessage += ";" + HB_CStr( xArg )
         NEXT
      ENDIF
   ELSEIF ISCHARACTER( oErr )
      cMessage += oErr
   ENDIF
   cMessage += ";;" + ProcName( 2 ) + "(" + hb_NToS( ProcLine( 2 ) ) + ")"

   Alert( cMessage )

   BREAK( oErr )

//EOF
