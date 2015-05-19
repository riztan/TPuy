#
# Rutina para generar fichero de recursor resource.rc
#

ifeq ($(HB_MAKE_PLAT),win)

RESDIR:=src
RESFILE:=resource.rc
RESDATE :=$(shell cmd /C date /T)

$(info )
$(info Ejecutando genresource.mk )


$(info * Generando $(RESFILE) )

SPACE =echo.
ECHO:=echo
N:=\#
INI:=> $(RESDIR)\$(RESFILE) 
ADD:=>> $(RESDIR)\$(RESFILE)


$(shell $(strip $(ECHO) App ICON "images/tpuy.ico" $(INI)))
$(shell $(strip $(ECHO) 1 VERSIONINFO $(ADD)))
$(shell $(strip $(ECHO) PRODUCTVERSION 0, 1, 0, 0 $(ADD)))
$(shell $(strip $(ECHO) FILEFLAGSMASK 0 $(ADD)))
$(shell $(strip $(ECHO) FILEOS 0x40000 $(ADD)))
$(shell $(strip $(ECHO) FILETYPE 1 $(ADD)))
$(shell $(strip $(ECHO) { $(ADD)))
$(shell $(strip $(ECHO) BLOCK "StringFileInfo" $(ADD)))
$(shell $(strip $(ECHO) { $(ADD)))
$(shell $(strip $(ECHO)  BLOCK "040904E4" $(ADD)))
$(shell $(strip $(ECHO)  { $(ADD)))
$(shell $(strip $(ECHO)   VALUE "CompanyName", "www.gtxbase.org" $(ADD)))
$(shell $(strip $(ECHO)   VALUE "FileDescription", "Tepuy. Base para Sistemas de Gestión" $(ADD)))
$(shell $(strip $(ECHO)   VALUE "FileVersion", "$(RESDATE)" $(ADD)))
$(shell $(strip $(ECHO)   VALUE "InternalName", "tpuy" $(ADD)))
$(shell $(strip $(ECHO)   VALUE "LegalCopyright", "GNU Public License" $(ADD)))
$(shell $(strip $(ECHO)   VALUE "OriginalFilename", "tpuy_win_x86_hb32.exe" $(ADD)))
$(shell $(strip $(ECHO)   VALUE "ProductName", "TPuy" $(ADD)))
$(shell $(strip $(ECHO)   VALUE "ProductVersion", "0.2 (Alpha)" $(ADD)))
$(shell $(strip $(ECHO)   VALUE "Comments", "Compilado por Orseit,c.a. " $(ADD)))
$(shell $(strip $(ECHO)  } $(ADD)))
$(shell $(strip $(ECHO) } $(ADD)))
$(shell $(strip $(ECHO) } $(ADD)))

endif
#/eof
