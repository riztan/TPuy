# Make para ejecutar segun el sistema
# -mwindows al enlazar no sale ventana consola.
# pero para depurar, va de muerte que salgan mensajes en la consola

ifeq ($(HOME),)
  ROOT = /t-gtk/
else
  ROOT = $(HOME)/t-gtk/
endif
  $(info $(ROOT))

include $(ROOT)config/global.mk

include ./src/genresource.mk

RESOURCE_FILE =./src/resource.rc

export HPDF=yes

TARGET = ./bin/tpuy

SRCPATH = ./src/
SOURCES  = $(SRCPATH)main.prg          \
           $(SRCPATH)menu.prg          \
           $(SRCPATH)tpublic.prg       \
           $(SRCPATH)tobject.prg       \
           $(SRCPATH)tscript.prg       \
           $(SRCPATH)hbrun.prg         \
           $(SRCPATH)connto.prg        \
           $(SRCPATH)connsave.prg      \
	   $(SRCPATH)hbpdf_tools.prg   \
           $(SRCPATH)tools01.prg       \
           $(SRCPATH)testqry1.prg      \
           $(SRCPATH)tpostgres.prg     \
           $(SRCPATH)datamodel.prg     \
           $(SRCPATH)listbox.prg       \
           $(SRCPATH)dbcolumn.prg      \
           $(SRCPATH)dbmodel.prg       \
           $(SRCPATH)tpy_selector.prg  \
           $(SRCPATH)pcget.prg         \
           $(SRCPATH)gpctoolbutton.prg \
           $(SRCPATH)utf.prg           \
           $(SRCPATH)xml.prg           \
           $(SRCPATH)mxml.prg          \
           $(SRCPATH)filechooser.prg   \
           $(SRCPATH)about.prg         \
           $(SRCPATH)pctapiz.prg       \
           $(SRCPATH)tpywin.prg        \
           $(SRCPATH)tpywindow.prg     \
           $(SRCPATH)glade.prg         \
           $(SRCPATH)tpy_image.prg     \
           $(SRCPATH)model_abm.prg     \
           $(SRCPATH)tpyentry.prg      \
           $(SRCPATH)tdocument.prg     \
           $(SRCPATH)tcursor.prg       \
           $(SRCPATH)gmail.prg        #\
#           $(SRCPATH)dbfs.prg          \
#           $(SRCPATH)dbf_indexar.prg     

LIBS =-L$(LIBDIR_TGTK) -ltdolphin -lhbct -lhbpg -lhbzebra -lhbxlsxwriter

ifeq ($(HB_MAKE_PLAT),win)
   LIBS  +=-lhbcplr -lhbpp -lhbcommon -lhbnetio -lhbrtl -lhbtip \
	   -lhbmxml -lmxml -lhbtfhka -lhbtpathy -lhbct -lhbcurl -lhbwin \
	   -lrddsql -lsddodbc -lodbc32 -lz #-lxlsxwriter
else
   # temporalmente se suspende el uso de libhbtfhka por un problema de incompatibilidad
   LIBS +=-lmysqlclient -lpq #-lhbtfhka -lhbtpathy -lhbct -lhbmxml -lmxml
endif

LIBS +=-lhbct -lhbmxml -lmxml 
LIBS += -lxlsxwriter -lz 


ifeq ($(XBASE_COMPILER),HARBOUR)
  ifeq ($(HB_MAKE_PLAT),win)
     LIBS += -lharbour-$(HB_VERSION)
  endif
endif

PRGFLAGS=-I./include 
PRGFLAGS+=-I/harbour-project/contrib/xhb
PRGFLAGS+=-I/harbour-project/contrib/hbtip
PRGFLAGS+=-I$(HB_INC_3RD_PATH)/hbmxml

include $(ROOT)Rules.make

