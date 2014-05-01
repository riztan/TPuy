/*
 *
 * Copyright 2010 Daniel Garcia-Gil<danielgarciagil@gmail.com>
 * www - http://tdolphin.blogspot.com/
 *
 * tgtk-dolphin - Ejemplo de conexion con T-Gtk y MySql usando TDolphin
 * este ejemplo muestra como obtener informacion de un query 
 * ---
 * This sample show ho get query datas
 */

#include "proandsys.ch"
#include "tdolphin.ch"
#include "gclass.ch"

memvar oTpuy

//#command MSGBOX(<val1>[,<val2>])  => MessageBox([<val2>],<val1>)

PROCEDURE dolphin()

   LOCAL oServer,aRow, uItem
   LOCAL cQuery, oQry, oErr
   LOCAL aTables, aColumns, cWhere, cOrder, cLimit

   Local oWnd,oBox,oScroll,oTreeView,oModel,oCol,oLbx


   oServer := oTpuy:oConn

   //Activated Case sensitive
   D_SetCaseSensitive( .T. )
   IF ( oServer ) == NIL
      ? "pa fuera!"

      RETURN
   ENDIF
? "fino"
return
   /*
   cQuery  = "select student.name, grade_event.date, score.score, grade_event.category"
   cQuery += "from grade_event, score, student where grade_event.date = " + ClipValue2SQL( CToD( '09-23-2008' ) ) + " and "
   cQuery += "grade_event.event_id = score.event_id and score.student_id = student.student_id"
   */
   
   // define query tables
   aTables  = { "dpprogra" }
   
   //define query columns (from)
   aColumns = { "*"}
   
   //define where
   //cWhere   = "grade_event.date = " + ClipValue2SQL( CToD( '09-23-2008' ) ) + " and "
   //cWhere  += "grade_event.event_id = score.event_id and score.student_id = student.student_id"

   //cLimit := "1"   

   //let Dolphin build query by us, remmenber can build the query your self
   cQuery = BuildQuery( aColumns, aTables, cWhere, ,,,cLimit )
//cQuery := "select * from dpprogra"
//?? cQuery   
   //build query object
   oQry = TDolphinQry():New( cQuery, oServer )
/*
   ? "NAME      TABLE     DEFAULT   TYPE      LENGTH    MAXLENGTH FLAGS     DECIMAL CLIP TYPE"
   ? "======================================================================================="
   ?
   FOR EACH aRow IN oQry:aStructure
     FOR EACH uItem IN aRow
        ?? If( ValType( uItem ) == "N", PadR( AllTrim( Str( uItem ) ), 10 ), PadR( uItem, 11 ) )
     NEXT 
     ? 
   NEXT  
   ? "======================================================================================="

   ?

   //Retrieve cWhere
   ? "WHERE" 
   ? oQry:cWhere 
   
   //Retrieve Info, we can use fieldget( cnField )
   ? 
   ? oQry:prg_tipo, oQry:prg_codigo, oQry:prg_fecha, oQry:prg_aplica, oQry:prg_fchact
   ? oQry:FieldGet( 1 ), oQry:FieldGet( 2 ), oQry:FieldGet( "prg_fecha" ), oQry:FieldGet( 4 ), oQry:FieldGet( "prg_texto" )

//msgInfo( UTF_8(oQry:FieldGet("prg_texto") ))
   ?
   // moving recond pointer
   ? oQry:Goto( 5 ), "GoTo 5"
   ? oQry:GoTop(), "GoTop()"
   ? oQry:GoBottom(), "GoBottom()"
   ? oQry:Skip( - 3 ), "Skip -3"
   ? 
*/   
   //browsing
/* Esto es lo que sustituimos on t-gtk del codigo original. */
/*
   oQry:GoTop()
   ? "student_id  name        date    score    category"
   ? "==================================================="
   do while !oQry:Eof()
      ? oQry:student_id, oQry:name, oQry:date, oQry:score, oQry:category
      oQry:Skip()
   end
   ? "==================================================="
   ?
*/
      
   DEFINE LIST_STORE oLbx TYPES G_TYPE_STRING,G_TYPE_STRING,G_TYPE_BOOLEAN, ;
                          G_TYPE_STRING
   
   oQry:GoTop()
   do while !oQry:Eof()
      APPEND LIST_STORE oLbx VALUES oQry:prg_codigo, DTOC(oQry:prg_fecha), oQry:prg_alter,;
                                    UTF_8(oQry:prg_descri)
      oQry:skip()
   enddo

   
   //Ahora vamos mostrar esos datos que hemos introducido.
   DEFINE WINDOW oWnd TITLE "MySql with TDolphin from T-Gtk...." ;
          SIZE 340,280
  
     DEFINE BOX oBox SPACING 8 OF oWnd
   
     // Llenamos el modelo de datos, a traves de los datos de MySql
     oModel := oLbx
     
     // Scroll Bar
     DEFINE SCROLLEDWINDOW oScroll OF oBox EXPAND FILL // CONTAINER

     // Creamos la vista
     DEFINE TREEVIEW oTreeView MODEL oModel OF oScroll CONTAINER
       
       // Y ahora vamos a definir como vamos a mostrar esos datos.
       DEFINE TREEVIEWCOLUMN oCol COLUMN 1 TITLE UTF_8("Código") TYPE "text"   OF oTreeView
         oCol:SetResizable( .t. )

       // Ademas , a esta columna vamos a permitir cosas...
       DEFINE TREEVIEWCOLUMN oCol COLUMN 2 TITLE "Fecha" TYPE "text" SORT OF oTreeView
         oCol:SetResizable( .T. )            // Permitimos que sea redimensionable
         oCol:oRenderer:SetEditable( .T. )   // Vamos a hacer que sea Editable
         oCol:oRenderer:Connect( "edited" )  // Conectamos signal, y asignamos el codeblock a evaluarse.
         oCol:oRenderer:bEdited := {|o,path,cNewText| Edita_Celda( oTreeView, oModel, oServer, path, cNewText ) }


       // Ademas , a esta columna vamos a permitir cosas...
       DEFINE TREEVIEWCOLUMN oCol COLUMN 3 TITLE "Alterado" TYPE "text" SORT OF oTreeView
         oCol:SetResizable( .T. )            // Permitimos que sea redimensionable
//         oCol:oRenderer:SetEditable( .T. )   // Vamos a hacer que sea Editable
//         oCol:oRenderer:Connect( "edited" )  // Conectamos signal, y asignamos el codeblock a evaluarse.
//         oCol:oRenderer:bEdited := {|o,path,cNewText| Edita_Celda( oTreeView, oModel, oServer, path, cNewText ) }



       // Ademas , a esta columna vamos a permitir cosas...
       DEFINE TREEVIEWCOLUMN oCol COLUMN 4 TITLE UTF_8("Descripción") TYPE "text" SORT OF oTreeView
         oCol:SetResizable( .T. )            // Permitimos que sea redimensionable
//         oCol:oRenderer:SetEditable( .T. )   // Vamos a hacer que sea Editable
//         oCol:oRenderer:Connect( "edited" )  // Conectamos signal, y asignamos el codeblock a evaluarse.
//         oCol:oRenderer:bEdited := {|o,path,cNewText| Edita_Celda( oTreeView, oModel, oServer, path, cNewText ) }

   ACTIVATE WINDOW oWnd CENTER

   oServer:End()   

RETURN   	           

 

// Vamos a editar la celda, y guardar el valor en la tabla y en el modelo de datos.
FUNCTION Edita_Celda(oTreeView,oLbx,oServer,cPath,cNewText)

  Local path
  Local aIter := Array( 4 )
  Local nId, oQuery

  path := gtk_tree_path_new_from_string( cPath )
  
  // Obtenemos el valor de la columna en la vista
  nId := oTreeView:GetValue( 1, "Int", Path, @aIter ) 

  oQuery := oServer:Query("SELECT * from dpprogra where prg_codigo=" + alltrim( str( nId ) )+;
                          " LIMIT 1", .f. )

  oQuery:prg_fecha  := cNewText
//  oQuery:Save()

//  if !oQuery:Save() 
//     Msginfo( oQuery:Error() )
//  endif
  
  /* set new value, en el modelo de datos*/
  oLbx:Set( aIter, 2, cNewText )
  
  /* clean up */
  gtk_tree_path_free( path )

RETURN NIL

 	
  
