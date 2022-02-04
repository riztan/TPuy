;NSIS Modern User Interface
;Welcome/Finish Page Example Script
;Written by Joost Verburg

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"
  !include "WordFunc.nsh"
  !include "EnvVarUpdate.nsh"

;--------------------------------
;Include Macros

;  !insertmacro StrFilter

;--------------------------------
;General

  !define NOMBRE "TPuy"
  !define TPUY_EXE "tpuy_win_x86_hb32.exe"
  !define VERSION "0.6.2"
  !define FOLDER "TPuy"

  !define DRIVE  "C:"
  !define ROOT   ".\misc"
  !define SOURCE "${ROOT}"


  ;Name and file
  Name "${NOMBRE}-${VERSION}" 
  Icon "${SOURCE}\images\installer.ico"
  OutFile "${NOMBRE}_${VERSION}_setup.exe"

  !insertmacro MUI_DEFAULT MUI_ICON   "${SOURCE}\images\installer.ico"
  !insertmacro MUI_DEFAULT MUI_UNICON "${SOURCE}\images\installer.ico"

  XPStyle on

  ;Default installation folder
  InstallDir "$PROGRAMFILES\${FOLDER}"
  ;InstallDir "${DRIVE}\${FOLDER}"

  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\Orseit\${NOMBRE}" ""

  SetCompressor /SOLID lzma

  Var INI
;  Var HWND
;  Var THEME

;--------------------------------
;Funciones
Function .onInit

;        StrCpy $THEME "MS-Windows"

        StrCpy $1 "Enero 2022"

        # the plugins dir is automatically deleted when the installer exits
        InitPluginsDir
	GetTempFileName $INI $PLUGINSDIR
	;File /oname=$INI "WordFunc.ini"

        File /oname=$PLUGINSDIR\splash.bmp "${SOURCE}\images\tpuy-logo-splash.bmp"
;        File /oname=$PLUGINSDIR\splash.bmp "${NSISDIR}\Contrib\Graphics\Wizard\llama.bmp"

        #optional
;        File /oname=$PLUGINSDIR\splash.wav "${ROOT}\images\tpuy.wav"

;        File /oname=$PLUGINSDIR\splash.bmp "${SOURCE}\install\tepuyes.bmp"
        advsplash::show 3500 2000 900 0xFDA1FA $PLUGINSDIR\splash
        Pop $0 
  
        MessageBox MB_YESNO "Se Instalará $(^NameDA) (Revisión de $1). Continuar?" IDYES NoAbort
           Abort ; Pa fuera!.
        NoAbort:

        Delete $PLUGINSDIR\tepuyes.bmp
;        Delete $PLUGINSDIR\tpuy.wav
FunctionEnd

;--------------------------------
;Interface Configuration

  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "${SOURCE}\images\tpy_head.bmp" ; optional
  !define MUI_ABORTWARNING
  ;Definiendo Imagenes de Bienvenida y Finalizacion
  !define MUI_WELCOMEFINISHPAGE_BITMAP "${SOURCE}\images\tpy_bar.bmp"



;--------------------------------
;Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "${SOURCE}\license.txt"
  !insertmacro MUI_PAGE_COMPONENTS
;  Page Custom ShowCustom LeaveCustom
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH


;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "Spanish"


;--------------------------------
;Funciones de Pagina Custom
;Function ShowCustom
;	InstallOptions::initDialog /NOUNLOAD "$INI"
;	Pop $hwnd
;	InstallOptions::show
;	Pop $0
;FunctionEnd

;--------------------------------
;Installer Sections

Section "Base Tpuy " SecDummy 

  SetOutPath "$INSTDIR"

;  File ${SOURCE}\install\TPuy.lnk
  File ${SOURCE}\*

  ;Delete "C:\tpuy\*.*"
  ;ADD YOUR OWN FILES HERE...
  ;File /nonfatal /r /x CVS

  SetOverwrite on

  SetOutPath $INSTDIR\bin
  File /r ${SOURCE}\bin\*

  SetOutPath $INSTDIR\etc
  File /r ${SOURCE}\etc\*
  FileOpen   $0 $INSTDIR\etc\gtk-2.0\gtkrc w
  FileWrite  $0 'gtk-theme-name = "MS-Windows"$\r$\n'
  FileWrite  $0 'gtk-fallback-icon-theme = "Tango"$\r$\n'
  FileClose  $0


  SetOutPath $INSTDIR\images
  File /r ${SOURCE}\images\*

  SetOutPath $INSTDIR\include
  File /r ${SOURCE}\include\*

  SetOutPath $INSTDIR\lib
  File /r ${SOURCE}\lib\*

  SetOutPath $INSTDIR\menu
  File /r ${SOURCE}\menu\*

  SetOutPath $INSTDIR\resources
  File /r ${SOURCE}\resources\*

  SetOutPath $INSTDIR\share
  File /r ${SOURCE}\share\*

  SetOutPath $INSTDIR\xbscripts
  File /r ${SOURCE}\xbscripts\*

;SetOutPath $QUICKLAUNCH
;Delete Tpuy.lnk
;File ${SOURCE}\install\Tpuy.lnk
;SetOutPath $DESKTOP
;Delete TPuy.lnk
;File ${SOURCE}\install\Tpuy.lnk

  ;Crear acceso directo
  SetOutPath $INSTDIR
  CreateShortCut "$DESKTOP\${NOMBRE}.lnk" "$INSTDIR\bin\${TPUY_EXE}"
  CreateShortCut "$INSTDIR\${NOMBRE}.lnk" "$INSTDIR\bin\${TPUY_EXE}"

  ;Escribir en el registro del sistema
  WriteRegStr HKCR ".xbs" "" "xbsfile"
  WriteRegStr HKCR "xbsfile" "" "${NOMBRE} Script File"
;  WriteRegStr HKCR "xbsfile\DefaultIcon" "" "Shell32.dll,72"
  WriteRegStr HKCR "xbsfile\DefaultIcon" "" "$INSTDIR\${NOMBRE}.ico"
  WriteRegStr HKCR "xbsfileshell" "" "Abrir"
  WriteRegStr HKCR "xbsfileshellAbrircommand" "" '"$INSTDIR\${NOMBRE}.Lnk" "%1"'


  ;Crear acceso directos
  CreateDirectory "$SMPROGRAMS\${NOMBRE}"
  CreateShortCut  "$SMPROGRAMS\${NOMBRE}\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
  Sleep 500
  CreateShortCut  "$SMPROGRAMS\${NOMBRE}\${NOMBRE} (Command line).lnk" "cmd.exe" "/k cd $INSTDIR" "cmd.exe" 0
  CreateShortCut  "$SMPROGRAMS\${NOMBRE}\${NOMBRE}.lnk" "$INSTDIR\bin\${TPUY_EXE}"
  CreateDirectory "$SMPROGRAMS\${NOMBRE}\Internet"
  WriteINIStr     "$SMPROGRAMS\${NOMBRE}\Internet\TPuy en gTxBase.url"  "InternetShortcut" "URL" "http://www.gtxbase.org/"
  WriteINIStr     "$SMPROGRAMS\${NOMBRE}\Internet\Foro.url"             "InternetShortcut" "URL" "http://www.gtxbase.org/forums"

  ;Crea .bat con nombre corto
  FileOpen   $0 $INSTDIR\bin\${NOMBRE}.bat w
  FileWrite  $0 '@echo off$\r$\n'
  FileWrite  $0 '"$INSTDIR\bin\${TPUY_EXE}" %1 %2 %3 %4 %5 %6 %7 %8 %9 $\r$\n'
  FileClose  $0


  ;Store installation folder
  WriteRegStr HKCU "Software\Orseit\${NOMBRE}" "" $INSTDIR

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  
  ;Eliminando Archivos
  ;Delete "$INSTDIR\*"

  ${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$INSTDIR\bin;$INSTDIR\include" ; Append 


SectionEnd

;--------------------------------
;Themes
Section /o "Tema para Windows 8" SecII

;   StrCpy $THEME "Win8"

  SetOutPath $INSTDIR\share\themes\Win8\gtk-2.0
  File /r ${SOURCE}\themes\Win8\gtk-2.0\*
;  SetOutPath $INSTDIR\share\themes\Win8\gtk-3.0
;  File /r ${SOURCE}\themes\Win8\gtk-3.0\*
  SetOutPath $INSTDIR\share\etc\gtk-2.0
;   File /r ${SOURCE}\themes\Win8\gtkrc

  FileOpen   $0 $INSTDIR\etc\gtk-2.0\gtkrc w
  FileWrite  $0 'gtk-theme-name = "Win8"$\r$\n'
  FileWrite  $0 'gtk-fallback-icon-theme = "Tango"$\r$\n'
  FileClose  $0

SectionEnd



;--------------------------------
;Examples
Section /o "Ejemplos, Turoriales, etc." SecIII

  SetOutPath $INSTDIR
  File /r ${SOURCE}\samples\*

  ;SetOutPath $INSTDIR\images
  ;File /r ${SOURCE}\samples\images\*

  ;SetOutPath $INSTDIR\xbscripts
  ;File /r ${SOURCE}\samples\xbscripts\*

SectionEnd

;--------------------------------
;Descriptions

  ;Language strings
  LangString DESC_SecDummy ${LANG_SPANISH} "Base principal TPuy."
  LangString DESC_SecII    ${LANG_SPANISH} "Instala el tema para Windows 8 y lo asigna como predeterminado"
  LangString DESC_SecIII   ${LANG_SPANISH} "Tutoriales, Ejemplos, etc."

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy} $(DESC_SecDummy)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecII} $(DESC_SecII)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecIII} $(DESC_SecIII)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section "Uninstall"

  ;ADD YOUR OWN FILES HERE...

  Delete "$INSTDIR\Uninstall.exe"
  Delete "$INSTDIR\bin\*"
  RMDir "$INSTDIR\bin"
  Delete "$INSTDIR\include\*"
  RMDir "$INSTDIR\include"
  Delete "$INSTDIR\images\*"
  RMDir "$INSTDIR\images"
  Delete "$INSTDIR\etc\*"
  RMDir "$INSTDIR\etc"
  Delete "$INSTDIR\share\themes"
  RMDir "$INSTDIR\share\themes"
  Delete "$INSTDIR\share\*"
  RMDir "$INSTDIR\share"
  Delete "$INSTDIR\lib\*"
  RMDir "$INSTDIR\lib"
  Delete "$INSTDIR\*"


  SetOutPath $QUICKLAUNCH
  Delete ${NOMBRE}.lnk
  SetOutPath $DESKTOP
  Delete ${NOMBRE}.lnk

  Delete "$SMPROGRAMS\${NOMBRE}\Internet\*" 
  RMDir  "$SMPROGRAMS\${NOMBRE}\Internet"
  Delete "$SMPROGRAMS\${NOMBRE}\Uninstall.lnk" 
  Delete "$SMPROGRAMS\${NOMBRE}\${NOMBRE}.lnk" 
  Delete "$SMPROGRAMS\${NOMBRE}\*" 
  RMDir  "$SMPROGRAMS\${NOMBRE}"


  DeleteRegKey /ifempty HKCU "Software\Orseit\${NOMBRE}"

  DeleteRegKey HKCR ".xbs" 
  DeleteRegKey HKCR "xbsfile" 
  DeleteRegKey HKCR "xbsfileDefaultIcon" 
  DeleteRegKey HKCR "xbsfileshell" 
  DeleteRegKey HKCR "xbsfileshellAbrircommand" 

  ${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR\bin" 
  ${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR\include" 


SectionEnd

;eof
