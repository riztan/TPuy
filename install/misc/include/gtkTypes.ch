/* $Id: gtkTypes.ch,v 1.2 2006-10-05 15:17:03 rosenwla Exp $*/

/*
 * GtkApi.ch Fichero de definiciones de T-Gtk -------------------------------------
 * Porting Harbour to GTK+ power !
 * (C) 2004. Rafa Carmona -TheFull-
 * (C) 2004. Joaquim Ferrer
 */

#define gboolean		3 //CTYPE_INT <=> gint
#define gpointer		7 //CTYPE_VOID_PTR
#define gconstpointer	0 //const void
#define gchar			1 //CTYPE_CHAR
#define guchar		   -1 //CTYPE_UNSIGNED_CHAR

#define gint			3 //CTYPE_INT
#define guint		   -3 //CTYPE_UNSIGNED_INT
#define gshort			2 //CTYPE_SHORT
#define gushort		   -2 //CTYPE_UNSIGNED_SHORT
#define glong			4 //CTYPE_LONG
#define gulong		   -4 //CTYPE_UNSIGNED_LONG

#define gint8			1 //CTYPE_CHAR
#define guint8		   -1 //CTYPE_UNSIGNED_CHAR 
#define gint16			2 //CTYPE_SHORT
#define guint16		   -2 //CTYPE_UNSIGNED_SHORT
#define gint32			3 //CTYPE_INT
#define guint32		   -3 //CTYPE_UNSIGNED_INT

//#define     G_HAVE_GINT64
//#define gint64
//#define guint64
//#define     G_GINT64_CONSTANT               (val)
//#define     G_GUINT64_CONSTANT              (val)

#define gfloat			5 //CTYPE_FLOAT
#define gdouble			6 //CTYPE_DOUBLE

#define gsize		   -3 //CTYPE_UNSIGNED_INT
#define gssize3 		3 //CTYPE_INT

#define gcharptr		10 //CTYPE_CHAR_PTR
#define gucharptr	   -10 //CTYPE_UNSIGNED_CHAR_PTR
