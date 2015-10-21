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

TARGET = ./bin/tpuy-dp

SRCPATH = ./src/
SOURCES  = $(SRCPATH)main.prg          \
           $(SRCPATH)menu.prg          \
           $(SRCPATH)tpublic.prg       \
           $(SRCPATH)tobject.prg       \
           $(SRCPATH)tscript.prg       \
           $(SRCPATH)hbrun.prg         \
	   $(SRCPATH)connto.prg        \
	   $(SRCPATH)connsave.prg      \
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
	   $(SRCPATH)filechooser.prg   \
           $(SRCPATH)about.prg         \
           $(SRCPATH)pctapiz.prg       \
           $(SRCPATH)tpywin.prg        \
           $(SRCPATH)tpywindow.prg     \
           $(SRCPATH)glade.prg         \
           $(SRCPATH)tpy_image.prg     \
           $(SRCPATH)model_abm.prg     \
           $(SRCPATH)tpy_dp.prg        \
	   $(SRCPATH)tpyentry.prg

LIBS =-L$(LIBDIR_TGTK) -ltdolphin -lhbct -lhbpg -lpq

ifeq ($(HB_MAKE_PLAT),win)
   LIBS  +=-lhbcplr -lhbpp -lhbcommon -lhbnetio -lhbrtl -lhbtip
else
   LIBS +=-lmysqlclient -lpq
endif


ifeq ($(XBASE_COMPILER),HARBOUR)
  ifeq ($(HB_MAKE_PLAT),win)
     LIBS += -lharbour-$(HB_VERSION)
  endif
endif

PRGFLAGS=-I./include 
PRGFLAGS+=-I/harbour-project/contrib/xhb
PRGFLAGS+=-I/harbour-project/contrib/hbtip

include $(ROOT)Rules.make

