#define GTK_MAJOR_VERSION				(2)
#define GTK_MINOR_VERSION				(12)
#define GTK_MICRO_VERSION				(0)
#define GTK_BINARY_AGE					(1006)
#define GTK_INTERFACE_AGE				(7)

/* check whether a Gtk+ version equal to or greater than
 * major.minor.micro is present.
 */
#define GTK_CHECK_VERSION( major,minor,micro ) ( GTK_MAJOR_VERSION > (major) .or. (GTK_MAJOR_VERSION == (major) .and. GTK_MINOR_VERSION > (minor)) .or. (GTK_MAJOR_VERSION == (major) .and. GTK_MINOR_VERSION == (minor) .and.  GTK_MICRO_VERSION >= (micro)))
