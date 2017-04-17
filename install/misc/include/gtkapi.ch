/* $Id: gtkapi.ch,v 1.11 2009-12-11 21:13:40 riztan Exp $*/

/*
 * GtkApi.ch Fichero de definiciones de T-Gtk -------------------------------------
 * Porting Harbour to GTK+ power !
 * (C) 2004. Rafa Carmona -TheFull-
 * (C) 2004. Joaquim Ferrer
 */

/* Definiciones de commandos para T-Gtk */
#include "tgtk.ch"

/* Version que queremos que soporte de T-Gtk de GTK+ */
#define T_GTK_VERSION  2.10  // Deprecated, look file include "gtkversion.ch"

/* Codigos de teclado */
#include "gtkkeys.ch"

/* Codigos de evento */
#include "gdkevent.ch"

/* Support Print */
#include "gtkprint.ch"

/* Support Pango */
#include "pango.ch"

/* Support for version GTK*/
#include "gtkversion.ch"

/* Compatibilidad con C */
#ifndef TRUE
#define TRUE   1
#endif
#ifndef FALSE
#define FALSE  0
#endif

/* Define In Gentry two definition to work with caption or without */
#define HB_GET			0
#define HB_GET_CAPTION	1

#DEFINE GTK_TOP      0.0
#DEFINE GTK_BOTTOM   1.0

#DEFINE GTK_LEFT     0.0
#DEFINE GTK_CENTERED 0.5
#DEFINE GTK_RIGHT    1.0

#define GTK_WIN_POS_NONE                0
#define GTK_WIN_POS_CENTER              1
#define GTK_WIN_POS_MOUSE               2
#define GTK_WIN_POS_CENTER_ALWAYS       3
#define GTK_WIN_POS_CENTER_ON_PARENT    4

#DEFINE GTK_WINDOW_TOPLEVEL 0

#define GTK_DIALOG_MODAL                0
#define GTK_DIALOG_DESTROY_WITH_PARENT  1
#define GTK_DIALOG_NO_SEPARATOR         2

#define GTK_POLICY_ALWAYS      0
#define GTK_POLICY_AUTOMATIC   1
#define GTK_POLICY_NEVER       2

/*
 * Enum  GtkResponseType -------------------------------------------
 */
#define GTK_RESPONSE_NONE          -1
#define GTK_RESPONSE_REJECT        -2
#define GTK_RESPONSE_ACCEPT        -3
#define GTK_RESPONSE_DELETE_EVENT  -4
#define GTK_RESPONSE_OK            -5
#define GTK_RESPONSE_CANCEL        -6
#define GTK_RESPONSE_CLOSE         -7
#define GTK_RESPONSE_YES           -8
#define GTK_RESPONSE_NO            -9
#define GTK_RESPONSE_APPLY        -10
#define GTK_RESPONSE_HELP         -11


#define GTK_MSGBOX_INFO     1
#define GTK_MSGBOX_QUESTION 2
#define GTK_MSGBOX_ERROR    3
#define GTK_MSGBOX_WARNING  4

#define GTK_MSGBOX_OK       1
#define GTK_MSGBOX_CANCEL   2
#define GTK_MSGBOX_CLOSE    4
#define GTK_MSGBOX_ABORT    8
#define GTK_MSGBOX_RETRY    16
#define GTK_MSGBOX_YES      32
#define GTK_MSGBOX_NO       64

/* Emun GtkPositionType -------------------------------------
 * the tabs of a GtkNotebook, the handle of a GtkHandleBox
 * or the label of a GtkScale.
 */
#define GTK_POS_LEFT        0
#define GTK_POS_RIGHT       1
#define GTK_POS_TOP         2
#define GTK_POS_BOTTOM      3

#define GTK_SHADOW_NONE       0
#define GTK_SHADOW_IN         1
#define GTK_SHADOW_OUT        2
#define GTK_SHADOW_ETCHED_IN  3
#define GTK_SHADOW_ETCHED_OUT 4

#define GTK_PROGRESS_LEFT_TO_RIGHT  0
#define GTK_PROGRESS_RIGHT_TO_LEFT  1
#define GTK_PROGRESS_BOTTOM_TO_TOP  2
#define GTK_PROGRESS_TOP_TO_BOTTOM  3

/*
 * Enum GtkStateType -------------------------------------------
 */
#define GTK_STATE_NORMAL        0
#define GTK_STATE_ACTIVE        1
#define GTK_STATE_PRELIGHT      2
#define GTK_STATE_SELECTED      3
#define GTK_STATE_INSENSITIVE   4

/*
 * Miembros de la estructura GtkWidgetFlags de C----------------
 */
#define GTK_TOPLEVEL         DESPLAZA_LEFT( 1,4 )
#define GTK_NO_WINDOW        DESPLAZA_LEFT( 1,5 )
#define GTK_REALIZED         DESPLAZA_LEFT( 1,6 )
#define GTK_MAPPED           DESPLAZA_LEFT( 1,7 )
#define GTK_VISIBLE          DESPLAZA_LEFT( 1,8 )
#define GTK_SENSITIVE        DESPLAZA_LEFT( 1,9 )
#define GTK_PARENT_SENSITIVE DESPLAZA_LEFT( 1,10 )
#define GTK_CAN_FOCUS        DESPLAZA_LEFT( 1,11 )
#define GTK_HAS_FOCUS        DESPLAZA_LEFT( 1,12 )
#define GTK_CAN_DEFAULT      DESPLAZA_LEFT( 1,13 )
#define GTK_HAS_DEFAULT      DESPLAZA_LEFT( 1,14 )
#define GTK_HAS_GRAB	     DESPLAZA_LEFT( 1,15 )
#define GTK_RC_STYLE	     DESPLAZA_LEFT( 1,16 )
#define GTK_COMPOSITE_CHILD  DESPLAZA_LEFT( 1,17 )
#define GTK_NO_REPARENT      DESPLAZA_LEFT( 1,18 )
#define GTK_APP_PAINTABLE    DESPLAZA_LEFT( 1,19 )
#define GTK_RECEIVES_DEFAULT DESPLAZA_LEFT( 1,20 )
#define GTK_DOUBLE_BUFFERED  DESPLAZA_LEFT( 1,21 )
#define GTK_NO_SHOW_ALL      DESPLAZA_LEFT( 1,22 )

/*
 * Enum GConnectFlags
 *
 */
#define G_CONNECT_AFTER	   DESPLAZA_LEFT( 1,0 )
#define G_CONNECT_SWAPPED  DESPLAZA_LEFT( 1,1 )

/*
 * Control de Styles y Colores--------------------------------------------
 */
#define STATE_NORMAL      0 // # El estado durante la operacin normal
#define STATE_ACTIVE      1 // # El control est�activado, como cuando se pulsa un botn
#define STATE_PRELIGHT    2 // # El puntero del ratn est�sobre el control
#define STATE_SELECTED    3 // # El control est�seleccionado
#define STATE_INSENSITIVE 4 // # El control est�desactivado
#define FGCOLOR           1   // # Color de frente
#define BGCOLOR           2   // # Color de Fondo
#define BASECOLOR         3   // # Color
#define TEXTCOLOR         4   // # Color

/*
 * Definicion de Stocks-----------------------------------------------------
 */
#define GTK_STOCK_DIALOG_AUTHENTICATION "gtk-dialog-authentication"
#define GTK_STOCK_DIALOG_INFO      "gtk-dialog-info"
#define GTK_STOCK_DIALOG_WARNING   "gtk-dialog-warning"
#define GTK_STOCK_DIALOG_ERROR     "gtk-dialog-error"
#define GTK_STOCK_DIALOG_QUESTION  "gtk-dialog-question"

#define GTK_STOCK_DND              "gtk-dnd"
#define GTK_STOCK_DND_MULTIPLE     "gtk-dnd-multiple"

#define GTK_STOCK_ADD              "gtk-add"
#define GTK_STOCK_APPLY            "gtk-apply"
#define GTK_STOCK_BOLD             "gtk-bold"
#define GTK_STOCK_CANCEL           "gtk-cancel"
#define GTK_STOCK_CDROM            "gtk-cdrom"
#define GTK_STOCK_CLEAR            "gtk-clear"
#define GTK_STOCK_CLOSE            "gtk-close"
#define GTK_STOCK_COLOR_PICKER     "gtk-color-picker"
#define GTK_STOCK_CONNECT          "gtk-connect"
#define GTK_STOCK_CONVERT          "gtk-convert"
#define GTK_STOCK_COPY             "gtk-copy"
#define GTK_STOCK_CUT              "gtk-cut"
#define GTK_STOCK_DELETE           "gtk-delete"
#define GTK_STOCK_EDIT             "gtk-edit"
#define GTK_STOCK_EXECUTE          "gtk-execute"
#define GTK_STOCK_FIND             "gtk-find"
#define GTK_STOCK_FIND_AND_REPLACE "gtk-find-and-replace"
#define GTK_STOCK_FLOPPY           "gtk-floppy"
#define GTK_STOCK_GOTO_BOTTOM      "gtk-goto-bottom"
#define GTK_STOCK_GOTO_FIRST       "gtk-goto-first"
#define GTK_STOCK_GOTO_LAST        "gtk-goto-last"
#define GTK_STOCK_GOTO_TOP         "gtk-goto-top"
#define GTK_STOCK_GO_BACK          "gtk-go-back"
#define GTK_STOCK_GO_DOWN          "gtk-go-down"
#define GTK_STOCK_GO_FORWARD       "gtk-go-forward"
#define GTK_STOCK_GO_UP            "gtk-go-up"
#define GTK_STOCK_HARDDISK         "gtk-harddisk"
#define GTK_STOCK_HELP             "gtk-help"
#define GTK_STOCK_HOME             "gtk-home"
#define GTK_STOCK_INDEX            "gtk-index"
#define GTK_STOCK_INDENT           "gtk-indent"		/* since gtk-2.4 */
#define GTK_STOCK_UNINDENT         "gtk-unindent"	/* since gtk-2.4 */
#define GTK_STOCK_ITALIC           "gtk-italic"
#define GTK_STOCK_JUMP_TO          "gtk-jump-to"
#define GTK_STOCK_JUSTIFY_CENTER   "gtk-justify-center"
#define GTK_STOCK_JUSTIFY_FILL     "gtk-justify-fill"
#define GTK_STOCK_JUSTIFY_LEFT     "gtk-justify-left"
#define GTK_STOCK_JUSTIFY_RIGHT    "gtk-justify-right"
#define GTK_STOCK_MISSING_IMAGE    "gtk-missing-image"
#define GTK_STOCK_NETWORK          "gtk-network"
#define GTK_STOCK_NEW              "gtk-new"
#define GTK_STOCK_NO               "gtk-no"
#define GTK_STOCK_OK               "gtk-ok"
#define GTK_STOCK_OPEN             "gtk-open"
#define GTK_STOCK_PASTE            "gtk-paste"
#define GTK_STOCK_PREFERENCES      "gtk-preferences"
#define GTK_STOCK_PRINT            "gtk-print"
#define GTK_STOCK_PRINT_PREVIEW    "gtk-print-preview"
#define GTK_STOCK_PROPERTIES       "gtk-properties"
#define GTK_STOCK_QUIT             "gtk-quit"
#define GTK_STOCK_REDO             "gtk-redo"
#define GTK_STOCK_REFRESH          "gtk-refresh"
#define GTK_STOCK_REMOVE           "gtk-remove"
#define GTK_STOCK_REVERT_TO_SAVED  "gtk-revert-to-saved"
#define GTK_STOCK_SAVE             "gtk-save"
#define GTK_STOCK_SAVE_AS          "gtk-save-as"
#define GTK_STOCK_SELECT_COLOR     "gtk-select-color"
#define GTK_STOCK_SELECT_FONT      "gtk-select-font"
#define GTK_STOCK_SORT_ASCENDING   "gtk-sort-ascending"
#define GTK_STOCK_SORT_DESCENDING  "gtk-sort-descending"
#define GTK_STOCK_SPELL_CHECK      "gtk-spell-check"
#define GTK_STOCK_STOP             "gtk-stop"
#define GTK_STOCK_STRIKETHROUGH    "gtk-strikethrough"
#define GTK_STOCK_UNDELETE         "gtk-undelete"
#define GTK_STOCK_UNDERLINE        "gtk-underline"
#define GTK_STOCK_UNDO             "gtk-undo"
#define GTK_STOCK_YES              "gtk-yes"
#define GTK_STOCK_ZOOM_100         "gtk-zoom-100"
#define GTK_STOCK_ZOOM_FIT         "gtk-zoom-fit"
#define GTK_STOCK_ZOOM_IN          "gtk-zoom-in"
#define GTK_STOCK_ZOOM_OUT         "gtk-zoom-out"

/*
 * Cursors Cursores GDK-----------------------------------------------------
 */
#define  GDK_X_CURSOR             0
#define  GDK_ARROW                2
#define  GDK_BASED_ARROW_DOWN     4
#define  GDK_BASED_ARROW_UP       6
#define  GDK_BOAT                 8
#define  GDK_BOGOSITY             10
#define  GDK_BOTTOM_LEFT_CORNER   12
#define  GDK_BOTTOM_RIGHT_CORNER  14
#define  GDK_BOTTOM_SIDE          16
#define  GDK_BOTTOM_TEE           18
#define  GDK_BOX_SPIRAL           20
#define  GDK_CENTER_PTR           22
#define  GDK_CIRCLE               24
#define  GDK_CLOCK                26
#define  GDK_COFFEE_MUG           28
#define  GDK_CROSS                30
#define  GDK_CROSS_REVERSE        32
#define  GDK_CROSSHAIR            34
#define  GDK_DIAMOND_CROSS        36
#define  GDK_DOT                  38
#define  GDK_DOTBOX               40
#define  GDK_DOUBLE_ARROW         42
#define  GDK_DRAFT_LARGE          44
#define  GDK_DRAFT_SMALL          46
#define  GDK_DRAPED_BOX           48
#define  GDK_EXCHANGE             50
#define  GDK_FLEUR                52
#define  GDK_GOBBLER              54
#define  GDK_GUMBY                56
#define  GDK_HAND1                58
#define  GDK_HAND2                60
#define  GDK_HEART                62
#define  GDK_ICON                 64
#define  GDK_IRON_CROSS           66
#define  GDK_LEFT_PTR             68
#define  GDK_LEFT_SIDE            70
#define  GDK_LEFT_TEE             72
#define  GDK_LEFTBUTTON           74
#define  GDK_LL_ANGLE             76
#define  GDK_LR_ANGLE             78
#define  GDK_MAN                  80
#define  GDK_MIDDLEBUTTON         82
#define  GDK_MOUSE                84
#define  GDK_PENCIL               86
#define  GDK_PIRATE               88
#define  GDK_PLUS                 90
#define  GDK_QUESTION_ARROW       92
#define  GDK_RIGHT_PTR            94
#define  GDK_RIGHT_SIDE           96
#define  GDK_RIGHT_TEE            98
#define  GDK_RIGHTBUTTON          100
#define  GDK_RTL_LOGO             102
#define  GDK_SAILBOAT             104
#define  GDK_SB_DOWN_ARROW        106
#define  GDK_SB_H_DOUBLE_ARROW    108
#define  GDK_SB_LEFT_ARROW        110
#define  GDK_SB_RIGHT_ARROW       112
#define  GDK_SB_UP_ARROW          114
#define  GDK_SB_V_DOUBLE_ARROW    116
#define  GDK_SHUTTLE              118
#define  GDK_SIZING               120
#define  GDK_SPIDER               122
#define  GDK_SPRAYCAN             124
#define  GDK_STAR                 126
#define  GDK_TARGET               128
#define  GDK_TCROSS               130
#define  GDK_TOP_LEFT_ARROW       132
#define  GDK_TOP_LEFT_CORNER      134
#define  GDK_TOP_RIGHT_CORNER     136
#define  GDK_TOP_SIDE             138
#define  GDK_TOP_TEE              140
#define  GDK_TREK                 142
#define  GDK_UL_ANGLE             144
#define  GDK_UMBRELLA             146
#define  GDK_UR_ANGLE             148
#define  GDK_WATCH                150
#define  GDK_XTERM                152
#define  GDK_STANDARD_CURSOR      999 // Non standard of GTK, used by t-gtk for used standar pointer mouse

/**
 * enum GtkButtonBoxStyle ----------------------------------------------------
 **/
#define GTK_BUTTONBOX_DEFAULT_STYLE   0
#define GTK_BUTTONBOX_SPREAD          1
#define GTK_BUTTONBOX_EDGE	      2
#define GTK_BUTTONBOX_START           3
#define GTK_BUTTONBOX_END             4

/*
 * Icons -------------------------------------------------------------------
 */
#define  GTK_ICON_SIZE_INVALID          0
#define  GTK_ICON_SIZE_MENU             1
#define  GTK_ICON_SIZE_SMALL_TOOLBAR    2
#define  GTK_ICON_SIZE_LARGE_TOOLBAR    3
#define  GTK_ICON_SIZE_BUTTON           4
#define  GTK_ICON_SIZE_DND              5
#define  GTK_ICON_SIZE_DIALOG           6

/*
 * Styles ToolBar ----------------------------------------------------------
 */
#define  GTK_TOOLBAR_ICONS         0
#define  GTK_TOOLBAR_TEXT          1
#define  GTK_TOOLBAR_BOTH          2
#define  GTK_TOOLBAR_BOTH_HORIZ    3

/*
 * Styles Calendar ----------------------------------------------------------
 */
#define GTK_CALENDAR_SHOW_HEADING      DESPLAZA_LEFT( 1, 0 )
#define GTK_CALENDAR_SHOW_DAY_NAMES    DESPLAZA_LEFT( 1, 1 )
#define GTK_CALENDAR_NO_MONTH_CHANGE   DESPLAZA_LEFT( 1, 2 )
#define GTK_CALENDAR_SHOW_WEEK_NUMBERS DESPLAZA_LEFT( 1, 3 )
#define GTK_CALENDAR_WEEK_START_MONDAY DESPLAZA_LEFT( 1, 4 )

/*
 * Used for justifying the text inside a GtkLabel widget. -------------------
 */
#define GTK_JUSTIFY_LEFT                0
#define GTK_JUSTIFY_RIGHT               1
#define GTK_JUSTIFY_CENTER              2
#define GTK_JUSTIFY_FILL                3

/*
 *  Used to indicate the direction in which a GtkArrow should point.--------
 */
#define GTK_ARROW_UP    0
#define GTK_ARROW_DOWN  1
#define GTK_ARROW_LEFT  2
#define GTK_ARROW_RIGHT 3

/*
 *  GtkDirectionType. Used to indicate the direction focus
 */
#define GTK_DIR_TAB_FORWARD  0
#define GTK_DIR_TAB_BACKWARD 1
#define GTK_DIR_UP           2
#define GTK_DIR_DOWN         3
#define GTK_DIR_LEFT         4
#define GTK_DIR_RIGHT        5

/*
 *  GtkUpdateType. Used en Range
 */
#define GTK_UPDATE_CONTINUOUS    0
#define GTK_UPDATE_DISCONTINUOUS 1
#define GTK_UPDATE_DELAYED       2

/*
 *  GtkScrollType Used in ScaleVH
 */
#define GTK_SCROLL_NONE          0
#define GTK_SCROLL_JUMP          1
#define GTK_SCROLL_STEP_BACKWARD 2
#define GTK_SCROLL_STEP_FORWARD  3
#define GTK_SCROLL_PAGE_BACKWARD 4
#define GTK_SCROLL_PAGE_FORWARD  5
#define GTK_SCROLL_STEP_UP       6
#define GTK_SCROLL_STEP_DOWN     7
#define GTK_SCROLL_PAGE_UP       8
#define GTK_SCROLL_PAGE_DOWN     9
#define GTK_SCROLL_STEP_LEFT    10
#define GTK_SCROLL_STEP_RIGHT   11
#define GTK_SCROLL_PAGE_LEFT    12
#define GTK_SCROLL_PAGE_RIGHT   13
#define GTK_SCROLL_START        14
#define GTK_SCROLL_END          15

/*
 * GtkSelectionMode. Used in GList
 */
#define GTK_SELECTION_NONE     0 /* Nothing can be selected */
#define GTK_SELECTION_SINGLE   1
#define GTK_SELECTION_BROWSE   2
#define GTK_SELECTION_MULTIPLE 3
#define GTK_SELECTION_EXTENDER 3 /* Deprecated */



#define GTK_TREE_VIEW_COLUMN_GROW_ONLY   0
#define GTK_TREE_VIEW_COLUMN_AUTOSIZE    1
#define GTK_TREE_VIEW_COLUMN_FIXED       2

/*
 * Constant fundamental types,
 */
#define G_TYPE_INVALID    G_TYPE_MAKE_FUNDAMENTAL(0)
#define G_TYPE_NONE       G_TYPE_MAKE_FUNDAMENTAL(1)
#define G_TYPE_INTERFACE  G_TYPE_MAKE_FUNDAMENTAL(2)
#define G_TYPE_CHAR       G_TYPE_MAKE_FUNDAMENTAL(3)
#define G_TYPE_UCHAR      G_TYPE_MAKE_FUNDAMENTAL(4)
#define G_TYPE_BOOLEAN    G_TYPE_MAKE_FUNDAMENTAL(5)
#define G_TYPE_INT        G_TYPE_MAKE_FUNDAMENTAL(6)
#define G_TYPE_UINT       G_TYPE_MAKE_FUNDAMENTAL(7)
#define G_TYPE_LONG       G_TYPE_MAKE_FUNDAMENTAL(8)
#define G_TYPE_ULONG      G_TYPE_MAKE_FUNDAMENTAL(9)
#define G_TYPE_INT64      G_TYPE_MAKE_FUNDAMENTAL(10)
#define G_TYPE_UINT64     G_TYPE_MAKE_FUNDAMENTAL(11)
#define G_TYPE_ENUM       G_TYPE_MAKE_FUNDAMENTAL(12)
#define G_TYPE_FLAGS      G_TYPE_MAKE_FUNDAMENTAL(13)
#define G_TYPE_FLOAT      G_TYPE_MAKE_FUNDAMENTAL(14)
#define G_TYPE_DOUBLE     G_TYPE_MAKE_FUNDAMENTAL(15)
#define G_TYPE_STRING     G_TYPE_MAKE_FUNDAMENTAL(16)
#define G_TYPE_POINTER    G_TYPE_MAKE_FUNDAMENTAL(17)
#define G_TYPE_BOXED      G_TYPE_MAKE_FUNDAMENTAL(18)
#define G_TYPE_PARAM      G_TYPE_MAKE_FUNDAMENTAL(19)
#define G_TYPE_OBJECT     G_TYPE_MAKE_FUNDAMENTAL(20)
#define GDK_TYPE_PIXBUF   gdk_pixbuf_get_type()

/*
 * GdkRgbDither
 */
#define GDK_RGB_DITHER_NONE   0
#define GDK_RGB_DITHER_NORMAL 1
#define GDK_RGB_DITHER_MAX    2


#define GDK_LINE_SOLID        0
#define GDK_LINE_ON_OFF_DASH  1
#define GDK_LINE_DOUBLE_DASH  2

#define GDK_CAP_NOT_LAST      0
#define GDK_CAP_BUTT          1
#define GDK_CAP_ROUND         2
#define GDK_CAP_PROJECTING    3

#define GDK_JOIN_MITER 0
#define GDK_JOIN_ROUND 1
#define GDK_JOIN_BEVEL 2


/*
 * enum GtkFileChooserAction ( GTK 2.6 )
 */
#define GTK_FILE_CHOOSER_ACTION_OPEN          0
#define GTK_FILE_CHOOSER_ACTION_SAVE          1
#define GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER 2
#define GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER 3

/*
 * enum GtkAttachOptions
 */
#define GTK_EXPAND  DESPLAZA_LEFT( 1, 0 )
#define GTK_SHRINK  DESPLAZA_LEFT( 1, 1 )
#define GTK_FILL    DESPLAZA_LEFT( 1, 2 )

/*
 * enum GtkMetricType
 */
#define GTK_PIXELS        0
#define GTK_INCHES        1
#define GTK_CENTIMETERS   2

/*
 * enum GtkOrientation
 */
#define GTK_ORIENTATION_HORIZONTAL 0
#define GTK_ORIENTATION_VERTICAL   1

/*
 * enum GdkWindowTypeHint
 */
#define GDK_WINDOW_TYPE_HINT_NORMAL 	   0 //Normal toplevel window.
#define GDK_WINDOW_TYPE_HINT_DIALOG 	   1 //Dialog window.
#define GDK_WINDOW_TYPE_HINT_MENU 	   2 //Window used to implement a menu.
#define GDK_WINDOW_TYPE_HINT_TOOLBAR 	   3 //Window used to implement toolbars.
#define GDK_WINDOW_TYPE_HINT_SPLASHSCREEN  4 //Window used to display a splash screen during application startup.
#define GDK_WINDOW_TYPE_HINT_UTILITY 	   5 //Utility windows which are not detached toolbars or dialogs.
#define GDK_WINDOW_TYPE_HINT_DOCK 	   6 //Used for creating dock or panel windows.
#define GDK_WINDOW_TYPE_HINT_DESKTOP 	   7 //Used for creating the desktop background window.

// Prepo Commands
#xcommand DEFAULT <uVar1> := <uVal1> ;
               [, <uVarN> := <uValN> ] => ;
                  <uVar1> := If( <uVar1> == nil, <uVal1>, <uVar1> ) ;;
                [ <uVarN> := If( <uVarN> == nil, <uValN>, <uVarN> ); ]

// SetGet Standard
#define bSetGet(x)   {|u| If( PCount() == 0, x, x := u ) }
// Define Enum GtkDeleteType 
#define GTK_DELETE_CHARS				0
#define GTK_DELETE_WORD_ENDS			1 /* delete only the portion of the word to the * left/right of cursor if we're in the middle * of a word */
#define GTK_DELETE_WORDS				2
#define GTK_DELETE_DISPLAY_LINES		3
#define GTK_DELETE_DISPLAY_LINE_ENDS	4
#define GTK_DELETE_PARAGRAPH_ENDS		5 /* like C-k in Emacs (or its reverse) */
#define GTK_DELETE_PARAGRAPHS			6 /* C-k in pico, kill whole line */
#define GTK_DELETE_WHITESPACE			7

/* 
 * enum GtkAssistantPageType 
 */
#define GTK_ASSISTANT_PAGE_CONTENT  0
#define GTK_ASSISTANT_PAGE_INTRO    1
#define GTK_ASSISTANT_PAGE_CONFIRM  2
#define GTK_ASSISTANT_PAGE_SUMMARY  3
#define GTK_ASSISTANT_PAGE_PROGRESS 4

/* 
 * enum GtkEntryIconPosition
 */
#define GTK_ENTRY_ICON_PRIMARY      0
#define GTK_ENTRY_ICON_SECONDARY    1

/*
 *enum GtkTreeViewGridLines
*/
#define GTK_TREE_VIEW_GRID_LINES_NONE        0
#define GTK_TREE_VIEW_GRID_LINES_HORIZONTAL  1
#define GTK_TREE_VIEW_GRID_LINES_VERTICAL    2
#define GTK_TREE_VIEW_GRID_LINES_BOTH        3 


/*
 *enum GtkCellRendererMode
 */
#define GTK_CELL_RENDERER_MODE_INERT          0
#define GTK_CELL_RENDERER_MODE_ACTIVATABLE    1
#define GTK_CELL_RENDERER_MODE_EDITABLE       2 
