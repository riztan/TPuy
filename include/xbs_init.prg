/* Proyecto TPuy.
 * Lineas de codigo iniciales para scripts en tpuy. 
 */

  oForm := TPublic():New()

  if !oTpuy:RunXBS("netio_check") ; return .f. ; endif

