;NSIS Modern User Interface
;Welcome/Finish Page Example Script
;Written by Joost Verburg

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"
  !include "WordFunc.nsh"
  !include "EnvVarUpdate.nsh"

  !insertmacro MUI_DEFAULT MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
  !insertmacro MUI_DEFAULT MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"

;--------------------------------
;Include Macros

;  !insertmacro StrFilter

;--------------------------------
;General

  !define NOMBRE "TPuy"
  !define VERSION "0.1(a)"
  !define FOLDER "TPuy"

  !define DRIVE  "C:"
  !define ROOT   "z:\utilitis\GIT"
  !define SOURCE "${ROOT}\tpuy-win"


  ;Name and file
  Name "${NOMBRE}-${VERSION}" 
  OutFile "${NOMBRE}_${VERSION}_setup.exe"

  XPStyle on

  ;Default installation folder
  InstallDir "${DRIVE}\${FOLDER}"

  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\Orseit\${NOMBRE}" ""

  SetCompressor /SOLID lzma

  Var INI
  Var HWND
  Var STATE

;--------------------------------
;Funciones
Function .onInit

        StrCpy $1 "Mayo 2014"

        # the plugins dir is automatically deleted when the installer exits
        InitPluginsDir
	GetTempFileName $INI $PLUGINSDIR
	;File /oname=$INI "WordFunc.ini"

        File /oname=$PLUGINSDIR\splash.bmp "${SOURCE}\install\tpuy-logo.bmp"
        #optional
;        File /oname=$PLUGINSDIR\splash.wav "${ROOT}\images\adaptapro.wav"

;        File /oname=$PLUGINSDIR\splash.bmp "${SOURCE}\install\tepuyes.bmp"
        advsplash::show 3500 2000 900 0xFDA1FA $PLUGINSDIR\splash
        Pop $0 
  
        MessageBox MB_YESNO "Se Instalará $(^NameDA) (Revisión de $1). Continuar?" IDYES NoAbort
           Abort ; Pa fuera!.
        NoAbort:

        Delete $PLUGINSDIR\tepuyes.bmp
;        Delete $PLUGINSDIR\adaptapro.wav
FunctionEnd

;--------------------------------
;Interface Configuration

  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "${SOURCE}\install\tpy_head.bmp" ; optional
  !define MUI_ABORTWARNING
  ;Definiendo Imagenes de Bienvenida y Finalizacion
  !define MUI_WELCOMEFINISHPAGE_BITMAP "${SOURCE}\install\tpy_bar.bmp"



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
Function ShowCustom
	InstallOptions::initDialog /NOUNLOAD "$INI"
	Pop $hwnd
	InstallOptions::show
	Pop $0
FunctionEnd

;--------------------------------
;Installer Sections

Section "Base Tpuy " SecDummy 

  SetOutPath "$INSTDIR"

  File ${SOURCE}\install\TPuy.lnk
  File ${SOURCE}\*

  ;Delete "C:\tpuy\*.*"
  ;ADD YOUR OWN FILES HERE...
  ;File /nonfatal /r /x CVS

SetOverwrite on

SetOutPath $INSTDIR\bin
File /r ${SOURCE}\bin\*

SetOutPath $INSTDIR\etc
File /r ${SOURCE}\etc\*

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

SetOutPath $QUICKLAUNCH
Delete Tpuy.lnk
File ${SOURCE}\install\Tpuy.lnk
SetOutPath $DESKTOP
Delete TPuy.lnk
File ${SOURCE}\install\Tpuy.lnk


  ;Store installation folder
  WriteRegStr HKCU "Software\Orseit\${NOMBRE}" "" $INSTDIR

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall2.exe"
  
  ;Eliminando Archivos
  ;Delete "$INSTDIR\*"

${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$INSTDIR\bin;$INSTDIR\include" ; Append 

SectionEnd

;--------------------------------
;Examples
Section /o "Ejemplos, Turoriales, etc." SecII

SectionEnd

;--------------------------------
;Descriptions

  ;Language strings
  LangString DESC_SecDummy ${LANG_SPANISH} "Base principal TPuy."
  LangString DESC_SecII    ${LANG_SPANISH} "Tutoriales, Ejemplos, etc."

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy} $(DESC_SecDummy)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecII} $(DESC_SecII)
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
  Delete "$INSTDIR\share\*"
  RMDir "$INSTDIR\share"
  Delete "$INSTDIR\lib\*"
  RMDir "$INSTDIR\lib"
  Delete "$INSTDIR\*"


  SetOutPath $QUICKLAUNCH
  Delete Tpuy.lnk
  SetOutPath $DESKTOP
  Delete TPuy.lnk

  DeleteRegKey /ifempty HKCU "Software\Orseit\${NOMBRE}"

  ${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR\bin;$INSTDIR\include" 

SectionEnd

;eof
