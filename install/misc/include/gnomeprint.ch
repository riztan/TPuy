/*  $Id: gnomeprint.ch,v 1.1 2006-09-08 10:16:34 xthefull Exp $ */
/*
 * Gnomeprint.ch
 * Fichero de definiciones para impresion
 * Porting Harbour to Gnomeprint power !
 * (C) 2004. Rafa Carmona
 */

#define GNOME_PRINT_KEY_PAPER_SIZE               "Settings.Output.Media.PhysicalSize" /* Paper name, such as A4 or Letter */
#define GNOME_PRINT_KEY_PAPER_WIDTH              "Settings.Output.Media.PhysicalSize.Width" /* Arbitrary units - use conversion */
#define GNOME_PRINT_KEY_PAPER_HEIGHT             "Settings.Output.Media.PhysicalSize.Height" /* Arbitrary units - use conversion */
#define GNOME_PRINT_KEY_PAPER_ORIENTATION        "Settings.Output.Media.PhysicalOrientation" /* R0, R90, R180, R270 */
#define GNOME_PRINT_KEY_PAPER_ORIENTATION_MATRIX "Settings.Output.Media.PhysicalOrientation.Paper2PrinterTransform" /* 3x2 abstract matrix */

#define GNOME_PRINT_KEY_PAGE_ORIENTATION         "Settings.Document.Page.LogicalOrientation" /* R0, R90, R180, R270 */
#define GNOME_PRINT_KEY_PAGE_ORIENTATION_MATRIX  "Settings.Document.Page.LogicalOrientation.Page2LayoutTransform" /* 3x2 abstract matrix */

/* Just a reminder - application is only interested in logical orientation */
#define GNOME_PRINT_KEY_ORIENTATION GNOME_PRINT_KEY_PAGE_ORIENTATION

#define GNOME_PRINT_KEY_LAYOUT        "Settings.Document.Page.Layout"        /* Id of layout ('Plain' is always no-special-layout) */
#define GNOME_PRINT_KEY_LAYOUT_WIDTH  "Settings.Document.Page.Layout.Width"  /* Double value */
#define GNOME_PRINT_KEY_LAYOUT_HEIGHT "Settings.Document.Page.Layout.Height" /* Double value */

#define GNOME_PRINT_KEY_PAPER_SOURCE  "Settings.Output.PaperSource"          /* String value, like "Tray 1" */

/* Master resolution, i.e. ink dots for color printer RGB resolution is usually smaller */
#define GNOME_PRINT_KEY_RESOLUTION       "Settings.Output.Resolution"       /* String value, like 300x300 or 300dpi */
#define GNOME_PRINT_KEY_RESOLUTION_DPI   "Settings.Output.Resolution.DPI"   /* Numeric value, like 300, if meaningful */
#define GNOME_PRINT_KEY_RESOLUTION_DPI_X "Settings.Output.Resolution.DPI.X" /* Numeric value */
#define GNOME_PRINT_KEY_RESOLUTION_DPI_Y "Settings.Output.Resolution.DPI.Y" /* Numeric value */

/* These belong to 'Output' because PGL may implement multiple copies itself */
#define GNOME_PRINT_KEY_NUM_COPIES               "Settings.Output.Job.NumCopies" /* Number of copies */
#define GNOME_PRINT_KEY_NONCOLLATED_COPIES_IN_HW "Settings.Output.Job.NonCollatedCopiesHW"
#define GNOME_PRINT_KEY_COLLATED_COPIES_IN_HW    "Settings.Output.Job.CollatedCopiesHW"

#define GNOME_PRINT_KEY_COLLATE   "Settings.Output.Job.Collate"   /* Boolean (true|yes|1 false|no|0) */
#define GNOME_PRINT_KEY_DUPLEX    "Settings.Output.Job.Duplex"   /* Boolean (true|yes|1 false|no|0) */
#define GNOME_PRINT_KEY_TUMBLE    "Settings.Output.Job.Tumble"   /* Boolean (true|yes|1 false|no|0) */
#define GNOME_PRINT_KEY_HOLD      "Settings.Output.Job.Hold"   /* String value, like no-hold|indefinite|day-time|evening|night|weekend|second-shift|third-shift*/

/* These are ignored by libgnomeprint, but you may want to get/set/inspect these */
/* Libgnomeprintui uses these for displaying margin symbols */
#define GNOME_PRINT_KEY_PAGE_MARGIN_LEFT   "Settings.Document.Page.Margins.Left"   /* Length, i.e. use conversion */
#define GNOME_PRINT_KEY_PAGE_MARGIN_RIGHT  "Settings.Document.Page.Margins.Right"  /* Length, i.e. use conversion */
#define GNOME_PRINT_KEY_PAGE_MARGIN_TOP    "Settings.Document.Page.Margins.Top"    /* Length, i.e. use conversion */
#define GNOME_PRINT_KEY_PAGE_MARGIN_BOTTOM "Settings.Document.Page.Margins.Bottom" /* Length, i.e. use conversion */

/* These are ignored by libgnomeprint, and you most probably cannot change these too */
/* Also - these are relative to ACTUAL PAGE IN PRINTER - not physicalpage */
/* Libgnomeprintui uses these for displaying margin symbols */
#define GNOME_PRINT_KEY_PAPER_MARGIN_LEFT   "Settings.Output.Media.Margins.Left"   /* Length, i.e. use conversion */
#define GNOME_PRINT_KEY_PAPER_MARGIN_RIGHT  "Settings.Output.Media.Margins.Right"  /* Length, i.e. use conversion */
#define GNOME_PRINT_KEY_PAPER_MARGIN_TOP    "Settings.Output.Media.Margins.Top"    /* Length, i.e. use conversion */
#define GNOME_PRINT_KEY_PAPER_MARGIN_BOTTOM "Settings.Output.Media.Margins.Bottom" /* Length, i.e. use conversion */

/* More handy keys */
#define GNOME_PRINT_KEY_OUTPUT_FILENAME "Settings.Output.Job.FileName"          /* Filename used when printing to file. */
#define GNOME_PRINT_KEY_DOCUMENT_NAME   "Settings.Document.Name"                /* The name of the document 'Cash flow 2002', `Grandma cookie recipies' */
#define GNOME_PRINT_KEY_PREFERED_UNIT   "Settings.Document.PreferedUnit"        /* Abbreviation for the preferred unit cm, in,... */


// GnomePrintReturnCode
#define GNOME_PRINT_OK                    0
#define GNOME_PRINT_ERROR_UNKNOWN        -1
#define GNOME_PRINT_ERROR_BADVALUE       -2
#define GNOME_PRINT_ERROR_NOCURRENTPOINT -3
#define GNOME_PRINT_ERROR_NOCURRENTPATH  -4
#define GNOME_PRINT_ERROR_TEXTCORRUPT    -5
#define GNOME_PRINT_ERROR_BADCONTEXT     -6
#define GNOME_PRINT_ERROR_NOPAGE         -7
#define GNOME_PRINT_ERROR_NOMATCH        -8

/*
 * Used to track what type of range selection has been setup
 * GnomePrintRangeType
 */
#DEFINE GNOME_PRINT_RANGETYPE_NONE   0
#DEFINE GNOME_PRINT_RANGETYPE_CUSTOM 1
#DEFINE GNOME_PRINT_RANGETYPE_PAGES  2

/*
 * Flags for creation of range widget
 * GnomePrintDialogRangeFlags
 */
#DEFINE GNOME_PRINT_RANGE_CURRENT               1  // 1 << 0
#DEFINE GNOME_PRINT_RANGE_ALL                   2  // 1 << 1
#DEFINE GNOME_PRINT_RANGE_RANGE                 4  // 1 << 2
#DEFINE GNOME_PRINT_RANGE_SELECTION             8  // 1 << 3
#DEFINE GNOME_PRINT_RANGE_SELECTION_UNSENSITIVE 16 // 1 << 4

/*
 * Flags to specify, whether we want range and copies widgets
 * GnomePrintDialogFlags
 */
#DEFINE GNOME_PRINT_DIALOG_RANGE   1 // 1 << 0
#DEFINE GNOME_PRINT_DIALOG_COPIES  2 // 1 << 1

/*
 * The button numbers corresponding to the standard buttons
 * Used with the GnomeDialog "clicked" signal.
 * GnomePrintButtons
 */
#DEFINE GNOME_PRINT_DIALOG_RESPONSE_PRINT    1
#DEFINE GNOME_PRINT_DIALOG_RESPONSE_PREVIEW  2
#DEFINE GNOME_PRINT_DIALOG_RESPONSE_CANCEL  -6
