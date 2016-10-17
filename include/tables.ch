/*
 *  Proyecto Tpuy.
 *
 *  tables.ch   Cabecera de manipulacion de informacion de tablas de datos.
 *

	Copyright © 2008-2016  Riztan Gutierrez <riztang@gmail.org>

   Este programa es software libre: usted puede redistribuirlo y/o modificarlo 
   conforme a los términos de la Licencia Pública General de GNU publicada por
   la Fundación para el Software Libre, ya sea la versión 3 de esta Licencia o 
   (a su elección) cualquier versión posterior.

   Este programa se distribuye con el deseo de que le resulte útil, pero 
   SIN GARANTÍAS DE NINGÚN TIPO; ni siquiera con las garantías implícitas de
   COMERCIABILIDAD o APTITUD PARA UN PROPÓSITO DETERMINADO. Para más información, 
   consulte la Licencia Pública General de GNU.

   http://www.gnu.org/licenses/

 */

/* NOTA: Las Tablas deben ser Hash y las columnas 
 *       un Hash dentro del Hash de la tabla
 *  
 *   Ejemplo:   tabla := Hash()
 *              tabla["ID"] := Hash()
 *              tabla["ID"]["NAME" ] := "ID"
 *              tabla["ID"]["LABEL"] := "Identificación"
 *
 *   Ejemplo de Uso:
 *              "select "+TB:ID  ó   "select "+__:ID
 */

//#include "tpy_xbs.ch"

#xtranslate TB:<field>  => ;
            __TNAME__+"." + ;
            hb_HGet( hb_HGet( _TABLE_ ,<"field">), "NAME" )

#xtranslate __:<field>  => ;
            hb_HGet( hb_HGet( _TABLE_ ,<"field">), "NAME" )

#xtranslate __:<field>:<property>  => ;
            hb_HGet( hb_HGet( _TABLE_ ,<"field">), <"property"> )

//eof
