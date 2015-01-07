/*  $Id: tpy_xbs.ch,v 1.13 2014/01/27 18:36 riztan Exp $ */
/*
	Copyright © 2008  Riztan Gutierrez <riztang@gmail.org>

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

//#include "gclass.ch"
//#include "proandsys.ch"
#include "tepuy.ch"
//#include "xhb.ch"
//#include "tpy_netio.ch"
//#include "pc-soft.ch"


#xtranslate ::<exp> => oForm:<exp>

#xtranslate tracelog( <uValue> )  => tpyLog( <uValue>, ProcName() )


//eof
