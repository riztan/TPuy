/*
LGPL Licence.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this software; see the file COPYING. If not, write to
the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).

LGPL Licence.
(c)2007 Federico de Maussion <fj_demaussion@yahoo.com.ar>
*/

#include "hbclass.ch"
#include "gclass.ch"
#include "common.ch"

//#define nAcentoAgudo 65105
//#define nAcentoGrave 65104
//#define nDieresis 65111
//#define nTilde 126
//#define nCircunflejo 65106

// Shift Ctrl Alt
// Shift Izquierdo 65505
// Shift Derecho 65506
// Ctrl Izquierdo 65507
// Ctrl Derecho 65508
// Alt Izquierdo 65513
// Alt Derecho 65027

memvar oTepuy

Static oGetAct


CLASS PC_Get FROM GWIDGET

DATA Block
DATA xBuffer
DATA Original
DATA Justify INIT GTK_JUSTIFY_LEFT
DATA Name
DATA FocusInBlock
DATA FocusOutBlock
DATA oFont


DATA Type
DATA hasfocus
DATA BadDate
DATA nMaxLen
DATA DecPos
DATA nMaxLen
DATA DecPos INIT 0
DATA Minus
DATA lEdit
DATA nDispLen
DATA nDispPos
DATA lMinus INIT .F.
DATA lDispLen INIT .F.

DATA cPicFunc
DATA cPicMask
DATA cPicture INIT ''
DATA Mascara INIT ''

DATA lCompletion INIT .F.

DATA lPassWord INIT .F.

DATA pWidget
/*
DATA Font
DATA Enabled INIT .T.
DATA color INIT Nil
DATA backcolor INIT Nil
DATA Width INIT 20
DATA Height INIT 13
DATA ToolTip INIT ''
*/


DATA lSal INIT .F.

DATA nInsertId
DATA nDeleteId

METHOD New(bSetGet, cPicture, bWhen, bValid, aCompletion, font, oParent, lExpand,;
lFill, nPadding , lContainer, x, y, cId, uGlade, uLabelTab, lPassWord,;
lEnd , lSecond, lResize, lShrink, left_ta,right_ta,top_ta,bottom_ta,;
xOptions_ta, yOptions_ta )
/*
METHOD hide( ) INLINE gtk_widget_hide(::pWidget)
METHOD show( ) INLINE gtk_widget_show(::pWidget)
METHOD Enable( ) INLINE ::enabled := .t., gtk_widget_set_sensitive(::pWidget, TRUE)
METHOD Disable( ) INLINE ::enabled := .f., gtk_widget_set_sensitive(::pWidget, FALSE)
*/
METHOD SetVisible( lVisible ) INLINE gtk_entry_set_visibility( ::pWidget, lVisible )
METHOD SetText( cText ) INLINE gtk_entry_set_text( ::pWidget, cText )
METHOD GetText( ) INLINE gtk_entry_get_text( ::pWidget )
METHOD Justify( nType ) INLINE gtk_entry_set_alignment( ::pWidget, nType )
METHOD GetJustify( ) INLINE ::justify

METHOD SetPos( nPos ) INLINE gtk_editable_set_position( ::pWidget, nPos )
METHOD GetPos() INLINE gtk_editable_get_position( ::pWidget )

METHOD SetLen( nLen ) INLINE (::nMaxLen:=nLen, gtk_entry_set_max_length( ::pWidget, nLen ))
METHOD SetLenChar( nLen ) INLINE gtk_entry_set_width_chars( ::pWidget, nLen )
METHOD SetValue( uValue ) INLINE ::SetText( uValue )
METHOD GetValue( ) INLINE ::GetText()
METHOD UpdateBuffer( ) INLINE ::UpdateBlock()
// METHOD Create_Completion( aCompletion )

// METHOD SetTooltip( ctooltip )
METHOD Refresh(OnFocus)
METHOD UpdateBlock()
METHOD SetcPicture( cPicture )

METHOD OnInsert_Text()
METHOD OnDelete_Text()
METHOD OnFocus_out_event( oSender )
METHOD OnFocus_in_event( oSender )
METHOD OnKeyPressevent( oSender, pGdkEventKey )

ENDCLASS


METHOD New( bSetGet, uValue, cPicture, bWhen, bValid, aCompletion, font, oParent, lExpand,;
lFill, nPadding , lContainer, x, y, cId, uGlade, uLabelTab, lPassWord,;
lEnd , lSecond, lResize, lShrink, left_ta,right_ta,top_ta,bottom_ta,;
xOptions_ta, yOptions_ta ) CLASS PC_Get

::Block := bSetGet
::xBuffer := Eval( ::Block )
::Original := ::xBuffer
::Type := ValType( ::xBuffer )
::FocusInBlock := bWhen
::FocusOutBlock := bValid
::lPassWord := IIF( ISNIL(lPassWord), .F., lPassWord )
::ofont := IIF( ISNIL(font), ::ofont, font )

//Por Implememtar
/*
::justify := IIF( ISNIL(justify), GTK_JUSTIFY_LEFT, justify)
::width := IIF( ISNIL(Width), ::Width, Width )
::Height := IIF( ISNIL(Height), ::Height, Height )
::tooltip := IIF( ISNIL(tooltip), ::tooltip, tooltip )

gtk_widget_set_color(GtkWidget* widget,
GtkPaletteType pal, // fg, bg, light, base
GtkStateType state,
GdkColor* color); // allocated color
::color := IIF( ISNIL(color), ::color, color )

gtk_widget_set_background(GtkWidget* widget,
GdkColor* color); // allocated color
::backcolor := IIF( ISNIL(backcolor), ::backcolor, backcolor )
*/

::pWidget := gtk_entry_new()

::AddChild( oParent, lExpand, lFill, nPadding, lContainer, x, y, uLabelTab,;
lEnd, lSecond, lResize, lShrink, left_ta,right_ta,top_ta,bottom_ta,;
xOptions_ta, yOptions_ta )

::Connect( "key-press-event" )
::Connect( "focus-out-event" )
::Connect( "focus-in-event" )
// ::Connect( "insert-text" )
// ::Connect( "delete-text" )
::nInsertId := gtk_signal_connect(::pWidget, "insert-text", {|w, arg1, arg2, arg3| ::OnInsert_Text(w, arg1, arg2, arg3) } )
::nDeleteId := gtk_signal_connect(::pWidget, "delete-text", {|w, arg1, arg2, arg3| ::OnDelete_Text(w, arg1, arg2, arg3) } )

if !ISNIL(::ofont)
::SetFont( ::ofont )
endif

::SetcPicture( cPicture )
::Refresh( )

if !ISNIL(::justify) .and. ::justify != GTK_JUSTIFY_LEFT
gtk_entry_set_alignment(::pWidget, ::justify)
endif

::SetLen( ::nMaxLen )
::SetLenChar( ::nMaxLen )

If !ISNIL( uValue ) .AND. !Empty( uValue )
::SetText(uValue)
EndIf

::Show()

oGetAct := Self

RETURN self

METHOD OnKeyPressEvent( oSender, pGdkEventKey ) CLASS PC_Get

local nKey, nType

nKey := HB_GET_GDKEVENTKEY_KEYVAL( pGdkEventKey )// aGdkEventKey[ 6 ]
nType:= HB_GET_GDKEVENTKEY_TYPE( pGdkEventKey ) // aGdkEventKey[ 1 ]

do case
// Sift Tab = 65056
case nKey == 65056 .or. nKey = K_UP

if !oSender:lCompletion
oSender:UpdateBlock()
if ISBLOCK(oSender:FocusOutBlock)
if !Eval(oSender:FocusOutBlock)
Return .t.
end
endif

gtk_widget_child_focus( gtk_widget_get_toplevel( oSender:pWidget ) ,GTK_DIR_TAB_BACKWARD )
oSender:lSal := .t.
return .T.
endif

case nKey == GDK_Tab .or. nKey == K_TAB .Or. nKey == GDK_Return .or. nKey == K_ENTER .or. ;
nKey == 13 .or. nKey == 65421 .or. nKey == K_DOWN// VK_RETURN

if !oSender:lCompletion
oSender:UpdateBlock()
if ISBLOCK(oSender:FocusOutBlock)
if !Eval(oSender:FocusOutBlock)
Return .t.
end
endif

gtk_widget_child_focus( gtk_widget_get_toplevel( oSender:pWidget ) ,GTK_DIR_TAB_FORWARD )
oSender:lSal := .t.
return .T.
endif

case nKey == GDK_INSERT
Set( _SET_INSERT, ! Set( _SET_INSERT ) )
return .T.

case nKey == GDK_Escape .Or. nKey == K_ESC
//::SetText( cValToChar( ::Original ) )
eval( oSender:Block, oSender:Original )
oSender:Refresh()

return .t.

endcase

Return .F.


METHOD SetcPicture( cPicture ) CLASS PC_Get
Local i, nPos, nAt
Local xStr
Local xVal
Local xPic
Local Buffer

::cPicFunc := ""
::cPicture := IIF( ISNIL(cPicture), ::cPicture, Upper( cPicture ) )

nPos := AT("@", ::cPicture )
if nPos > 0

if nPos > 1
::cPicture := SubStr( ::cPicture, nPos )
endif

nAt := At( " ", ::cPicture )

if nAt == 0
::cPicFunc := ::cPicture
::cPicMask := ""
else
::cPicFunc := SubStr( ::cPicture, 1, nAt - 1 )
::cPicMask := SubStr( ::cPicture, nAt + 1 )
endif
else
::cPicFunc := ""
::cPicMask := ::cPicture
endif

if ISNIL(::xBuffer)
xStr := Repl(' ',20)
::Type := "C"
::xBuffer := Space(20)
::Mascara := Space(20)
::cPicMask := Repl('X',20)
::cPicture := ::cPicMask
else
If ::Type == 'D' .or. "D" $ ::cPicFunc
xStr := DtoC(::xBuffer)
::Mascara := DtoC(CtoD(''))
::cPicFunc := ""
::cPicMask := StrTran( ::Mascara, " ", "9" )
::cPicture := ::cPicMask
elseIf ::Type == 'C'
if empty(::cPicture) .OR. '@X' == ::cPicture
::cPicMask := replicate('X', g_utf8_strlen(::xBuffer))
::cPicture := ::cPicMask
elseif '@!' == ::cPicture
::cPicMask := replicate( '!', g_utf8_strlen(::xBuffer))
::cPicture := ::cPicMask
elseif '@9' == ::cPicture
::cPicMask := replicate( '9', g_utf8_strlen(::xBuffer))
::cPicture := ::cPicMask
endif

xStr := transform(repl(" ", Len(::cPicture)), ::cPicture)
::Mascara := xStr
elseIf ::Type == 'N'
// Create a cPicture
if empty(::cPicture)
::cPicture := str(::xBuffer)
for i := 1 to len(::cPicture)
if substr(::cPicture, i, 1) $ ' 0123456789'
::cPicture := stuff(::cPicture, i, 1, '9')
endif
next
::cPicMask := ::cPicture
endif

xStr := " "+transform( ::xBuffer, ::cPicture)

::DecPos := at( iif( '@E' $ ::cPicture, ',', '.' ), xStr )
::Mascara := " " + ::cPicMask

if '@E' $ ::cPicture
::Mascara := strtran(::Mascara, '9', ' ')
::Mascara := strtran(::Mascara, '.', '9')
::Mascara := strtran(::Mascara, ',', '.')
::Mascara := strtran(::Mascara, '9', ',')
else
::Mascara := strtran(::Mascara, '9', ' ')
endif

endif
endif

::nMaxLen :=len(xStr)

RETURN nil


METHOD Refresh(OnFocus) CLASS PC_Get
Local i := 0
Local xStr
Local xVal
Local xPic
Local Buffer

DEFAULT OnFocus := .F.

g_signal_handler_block( ::pWidget, ::nDeleteId)
g_signal_handler_block( ::pWidget, ::nInsertId)


::xBuffer := Eval( ::Block )
//View( { ValType(::xBuffer),::xBuffer } )

gtk_editable_delete_text(::pWidget, 0, ::nMaxLen )

if ::Type == "N"
if ::xBuffer < 0
::lMinus := .t.
::xBuffer *= -1
else
::lMinus := .f.
endif
gtk_editable_insert_text(::pWidget, if(::lMinus,"-"," "), 1, 0)
i++
endif

If( ValType(::xBuffer)="C" )
xStr := transform(::xBuffer, ::cPicture)
EndIf

gtk_editable_insert_text(::pWidget, xStr, g_utf8_strlen(xStr), i)

g_signal_handler_unblock( ::pWidget, ::nDeleteId)
g_signal_handler_unblock( ::pWidget, ::nInsertId)

if OnFocus
gtk_editable_select_region(::pWidget, 0, ::nMaxLen)
endif
//View({::xBuffer,xStr})

RETURN nil


METHOD OnDelete_Text( oSender, arg1, arg2 ) CLASS PC_Get
Local xStart := arg1
Local xEnd := arg2
Local xPics := 0
Local xChar
Local xPic
Local i

//Movement( "delete_text", ::pWidget, arg1, arg2, arg3 )

g_signal_handler_block( ::pWidget, ::nInsertId)
g_signal_handler_block( ::pWidget, ::nDeleteId)

// complete deletion of widget
if xEnd - xStart == ::nMaxLen
gtk_editable_delete_text(::pWidget, 0, ::nMaxLen )
::lMinus := .f.

if ::Type == 'D' .or. ::Type == 'C' .or. (::Type == 'N' .and. ::justify != GTK_JUSTIFY_RIGHT)
gtk_editable_insert_text(::pWidget, ::Mascara, ::nMaxLen, 0)
else
if '@Z' $ ::cPicture
if at('@', ::cPicture) == 1
xPic := strtran(::cPicture, '@Z ', '')
else
xPic := strtran(::cPicture, '@Z', '')
endif
else
xPic := ::cPicture
endif

gtk_editable_insert_text(::pWidget, transform(0, xPic), ::nMaxLen, 0)

if ::DecPos != 0
gtk_entry_set_position(::pWidget, ::DecPos - 1)
else
gtk_entry_set_position(::pWidget, ::nMaxLen)
endif
endif

// Partial deletion
elseif ::Type == 'D' .or. ;
::Type == 'C' .or. ;
(::Type == 'N' .and. ::justify == GTK_JUSTIFY_RIGHT .and. ::DecPos > 0 .and. xStart + 1 > ::DecPos) .or. ;
(::Type == 'N' .and. ::justify != GTK_JUSTIFY_RIGHT)

// Delete all cPicture chars from End until Start
for i := ::nMaxLen to xEnd Step -1
if ! Empty(substr(::Mascara, i, 1))
gtk_editable_delete_text(::pWidget, i - 1, i )
endif
next

// Count how many cPicture chars will be deleted
for i := xStart + 1 to xEnd
if ! Empty(substr(::Mascara, i, 1))
xPics++
endif
next

if ! Empty(xEnd - xStart - xPics)
// Delete selected range
gtk_editable_delete_text(::pWidget, xStart, xEnd )

// Add spaces at the end
gtk_editable_insert_text(::pWidget, space(xEnd - xStart - xPics), len(space(xEnd - xStart - xPics)), ::nMaxLen)
endif

// Add cPictures from Start to End
for i := xStart + 1 to ::nMaxLen
if ! Empty(substr(::Mascara, i, 1))
gtk_editable_insert_text(::pWidget, substr(::Mascara, i, 1), 1, i - 1)
endif
next

// Partial deletion for Right Numeric
elseif ::Type == 'N' .and. ::justify == GTK_JUSTIFY_RIGHT
if ::DecPos == gtk_editable_get_position(::pWidget) .and. ! Empty(::DecPos)
// Correct the cursor position when the backspace was pressed behind a DecPos separator
gtk_entry_set_position(::pWidget, ::DecPos - 1)

else
if gtk_editable_get_position(::pWidget) != xEnd
// Del key. Prevent this against backspace Key

if xEnd - xStart == 1
xStart--
xEnd--
elseif xStart == xEnd .and. Empty(::DecPos)
xStart--
endif
endif

// Delete all cPicture chars from the beginning until to Start
for i := 1 to xStart
if ! Empty(substr(::Mascara, i, 1))
gtk_editable_delete_text(::pWidget, i - 1, i )
gtk_editable_insert_text(::pWidget, ' ', 1, 0)
endif
next

// Count how many cPicture chars will be deleted
for i := xStart + 1 to xEnd
if ! Empty(substr(::Mascara, i, 1))
xPics++
endif
next

if ! Empty(xEnd - xStart - xPics)
// Delete selected range
gtk_editable_delete_text(::pWidget, xStart, xEnd )

// Add spaces at the end
gtk_editable_insert_text(::pWidget, space(xEnd - xStart - xPics), len(space(xEnd - xStart - xPics)), 0)
endif

// Add cPictures from start to beginning
for i := xStart to 1 step - 1
if ! Empty(substr(::Mascara, i, 1))
xChar := gtk_editable_get_chars(::pWidget, i - 1, i)
gtk_editable_delete_text(::pWidget, 0, 1 )

if empty(xChar)
gtk_editable_insert_text(::pWidget, ' ', 1, i - 1)
else
gtk_editable_insert_text(::pWidget, substr(::Mascara, i, 1), 1, i - 1)
endif
endif
next
endif
endif

g_signal_handler_unblock(::pWidget, ::nInsertId)
g_signal_handler_unblock(::pWidget, ::nDeleteId)
g_signal_stop_emission_by_name(::pWidget, "delete_text")

return nil


METHOD OnInsert_Text( oSender, arg1, arg2, arg3 ) CLASS PC_Get
Local xPos := arg3
Local nPos := arg3
Local iPos := 0
Local cPic
Local xChr
Local xDel := 0
Local xStr := ''
Local xArg
Local xPic := 0
Local i, x

cPic := strtran(::cPicture, '@Z', '')
if at('@', cPic) <> 0
cPic := substr( cPic, at(' ', cPic) + 1 )
else
cPic := cPic
endif

g_signal_handler_block( ::pWidget, ::nDeleteId)
g_signal_handler_block( ::pWidget, ::nInsertId)

// MyInfo(" OnInsert_Text( oSender, "+arg1+","+Str(Arg2)+","+Str(Arg3)+") " ,"Alerta")

// set the right cursor position
if at('@', ::cPicture) <> 0
cPic := substr( ::cPicture, at(' ', ::cPicture) + 1 )
else
cPic := ::cPicture
endif

// set the right cursor position
while xPos + 1 <= len(::Mascara) .and. ! empty(substr(::Mascara, xPos + 1, 1)) .and. ;
::Type == 'N' .and. xPos + 1 != ::DecPos
xPos++
nPos++
enddo

if xPos == ::nMaxLen .and. ::justify == GTK_JUSTIFY_RIGHT .and. empty(::DecPos)
// Allow insert when right numeric and no DecPos separator
iPos := xPos
xPos--
endif

if xPos + 1 <= ::nMaxLen
for i := 1 to g_utf8_strlen(arg1)
nPos := xPos
xDel := 0
xChr := ''
xPic := 0

if ! (::Type == 'N' .and. ::justify == GTK_JUSTIFY_RIGHT)
for x := ::nMaxLen to nPos + 1 step -1
// Remove all cPicture chars
if ! Empty(substr(::Mascara, x, 1))
gtk_editable_delete_text(::pWidget, x - 1, x )
xDel++
endif
next
endif

xArg := g_utf8_strncpy(g_utf8_offset_to_pointer(arg1, i - 1), 1)

// Insert chars
if ::Type == 'D' .and. xArg $ '0123456789'
xChr := substr(arg1, i, 1)

elseif ::Type == 'C'
// Handle char only
x := substr(cPic, xPos + 1, 1)
if x == 'X'
xChr := xArg
elseif x == '9'
if xArg $ '+-0123456789'
xChr := xArg
endif
elseif x == 'N'
if xArg $ '0123456789'
xChr := xArg
endif
elseif x == 'A'
if ! (xArg $ '0123456789')
xChr := xArg
endif
elseif x == '!'
xChr := g_utf8_strup(xArg)
end

elseif ::Type == 'N' .and. xArg $ '0123456789'
// Handle numeric chars
xChr := xArg

elseif ::Type == 'N' .and. xArg $ '.,' .and. ::DecPos > 0 .and. xPos + 1 <= ::DecPos
// Only when DecPos separator is pressed
xChr := '.'

elseif ::Type == 'N' .and. xArg $ '-' // .and. ::DecPos > 0 .and. xPos + 1 <= ::DecPos
// Validate '-' that was pressed
xChr := '-'

endif

if ::Type == 'N' .and. xPos == 0
xPos++
endif

if ::Type == 'N' .and. xChr $ '-'
::lMinus := !::lMinus
gtk_editable_delete_text(::pWidget, 0, 1 )
if ::lMinus
gtk_editable_insert_text(::pWidget, "-", 1, 0)
else
gtk_editable_insert_text(::pWidget, " ", 1, 0)
endif

elseif ::Type == 'N' .and. xChr $ '.'
// untransform all chars in pos until the beginning
xStr := ''
for x := 2 to xPos
if Empty(substr(::Mascara, x, 1))
xStr += gtk_editable_get_chars(::pWidget, x - 1, x)
endif
next

if '@Z' $ ::cPicture
if at('@', ::cPicture) == 1
cPic := strtran(::cPicture, '@Z ', '')
else
cPic := strtran(::cPicture, '@Z', '')
endif
else
cPic := ::cPicture
endif

//xStr := if( ::lMinus, val( xStr ) * -1, val( xStr ) )
xStr := transform( val( xStr ), cPic )

// delete all
gtk_editable_delete_text(::pWidget, 1, ::nMaxLen-1 )

// set new pos
if ::DecPos != 0
xPos := ::DecPos
else
xPos := ::nMaxLen
endif

// Fill the transformed data
gtk_editable_insert_text(::pWidget, xStr, ::nMaxLen-1, 1)

elseif ! Empty(xChr) .and. ::Type == 'N' .and. ::justify == GTK_JUSTIFY_RIGHT .and. ;
(Empty(::DecPos) .or. xPos < ::DecPos)

// Delete all cPicture chars from the beginning until the position
for x := 1 to xPos
if ! Empty(substr(::Mascara, x, 1))
gtk_editable_delete_text(::pWidget, x - 1, x )
gtk_editable_insert_text(::pWidget, ' ', 1, 0)
xPic++
endif
next

if gtk_editable_get_chars(::pWidget, xPos - 1, xPos) == '0' .and. ;
gtk_editable_get_chars(::pWidget, xPos - 2, xPos - 1) == ' '
// delete the "0" when numeric is empty
gtk_editable_delete_text(::pWidget, xPos - 1, xPos )
gtk_editable_insert_text(::pWidget, ' ', 1, 0)
endif

if ::lMinus
gtk_editable_delete_text(::pWidget, 0, 1 )
gtk_editable_insert_text(::pWidget, "-", 1, 0)
else
gtk_editable_delete_text(::pWidget, 0, 1 )
gtk_editable_insert_text(::pWidget, " ", 1, 0)
endif
// Delete the First char
gtk_editable_delete_text(::pWidget, xPic, xPic + 1 )

// Insert char at cursor position
gtk_editable_insert_text(::pWidget, xChr, len(xChr), xPos - 1)

// Add cPictures from start to beginning
for x := xPos to 1 step - 1
if ! Empty(substr(::Mascara, x, 1))
xChr := gtk_editable_get_chars(::pWidget, x - 1, x)
gtk_editable_delete_text(::pWidget, 0, 1 )

if empty(xChr)
gtk_editable_insert_text(::pWidget, ' ', 1, x - 1)
else
gtk_editable_insert_text(::pWidget, substr(::Mascara, x, 1), 1, x - 1)
endif
endif
next

elseif ! ISNIL(xChr) .and. (::Type == 'D' .or. ::Type == 'C' .or. ::Type == 'N' )
if Set( _SET_INSERT )
// delete current cursor char
gtk_editable_delete_text(::pWidget, xPos, xPos + 1 )
else
// delete the last char
gtk_editable_delete_text(::pWidget, ::nMaxLen - xDel - 1, ::nMaxLen - xDel )
endif

if ::Type == 'N'
if ::lMinus
gtk_editable_delete_text(::pWidget, 0, 1 )
gtk_editable_insert_text(::pWidget, "-", 1, 0)
else
gtk_editable_delete_text(::pWidget, 0, 1 )
gtk_editable_insert_text(::pWidget, " ", 1, 0)
endif
endif
gtk_editable_insert_text(::pWidget, xChr, len(xChr), xPos)
xPos++

// set the right cursor position
while xPos + 1 <= len(::Mascara) .and. ! empty(substr(::Mascara, xPos + 1, 1))
xPos++
enddo
endif

if Empty(xStr) .and. ! (::Type == 'N' .and. ::justify == GTK_JUSTIFY_RIGHT)
for x := nPos + 1 to ::nMaxLen
if ! Empty(substr(::Mascara, x, 1))
gtk_editable_insert_text(::pWidget, substr(::Mascara, x, 1), 1, x - 1)
endif
next
endif
next
endif

if ! Empty(iPos)
xPos := iPos
endif

g_signal_handler_unblock( ::pWidget, ::nDeleteId )
g_signal_handler_unblock( ::pWidget, ::nInsertId )
g_signal_stop_emission_by_name( ::pWidget, "insert_text" )

return xPos


METHOD OnFocus_In_Event(oSender) CLASS PC_Get

if !( oGetAct == oSender )
oGetAct:UpdateBlock()

if ISBLOCK( oSender:FocusInBlock )
if !Eval( oSender:FocusInBlock )
Return Nil
endif
endif
oGetAct = oSender
oSender:Original := Eval( oSender:Block )

//--- este refresh, hace que se repita el valor al pasar a otro get. (Riztan)
// oSender:Refresh(.T.)

oSender:lSal := .F.
endif
RETURN nil


METHOD OnFocus_Out_Event(oSender) CLASS PC_Get
// if oSender:lSal
oSender:UpdateBlock()
// endif
RETURN nil


METHOD UpdateBlock() CLASS PC_Get
Local xValue, cletra
Local cValue
Local i := 0
Local xStr := ''

if ISBLOCK(::Block)
g_signal_handler_block( ::pWidget, ::nDeleteId)
g_signal_handler_block( ::pWidget, ::nInsertId)

cValue := gtk_editable_get_chars(::pWidget, 0, ::nMaxLen)
gtk_editable_delete_text(::pWidget, 0, ::nMaxLen )

if ::Type == 'D'
xValue := CtoD( cValue )
elseif ::Type == 'N' .or. ( ::Type == 'C' .and. '@R' $ ::cPicture )
for i := 1 to len(cValue)
cLetra := substr(cValue, i, 1)
if cLetra == iif( '@E' $ ::cPicture, ',', '.' ) .and. ::Type == 'N'
xStr += '.'
elseif Empty(substr(::Mascara, i, 1))
if !Empty(cLetra)
xStr += cLetra
endif
endif
next

if ::Type == 'N'
xValue := val(xStr)
elseif ::Type == 'C' .and. '@R' $ ::cPicture
xValue := xStr
endif

elseif ::Type == 'C'
xValue := cValue
endif


eval( ::Block, xValue )
::Refresh()

g_signal_handler_unblock( ::pWidget, ::nDeleteId)
g_signal_handler_unblock( ::pWidget, ::nInsertId)
endif
RETURN nil



//----------------------------------------------------------------------------//
#pragma BEGINDUMP

#include "hbapi.h"
#include <glib.h>
#include <gtk/gtk.h>
#include <gtk/gtkversion.h>
#include <gdk/gdkkeysyms.h>


HB_FUNC( GTK_ENTRY_SET_POSITION ) //ADD by Sandro
{
GtkWidget * Entry = GTK_WIDGET( hb_parptr( 1 ) );
gtk_entry_set_position( GTK_ENTRY( Entry ), hb_parni(2) );
}


HB_FUNC( GTK_EDITABLE_INSERT_TEXT )
{
GtkWidget * editable = GTK_WIDGET( hb_parptr( 1 ) );
gint tmp_pos = hb_parni(4);
gtk_editable_insert_text( GTK_EDITABLE(editable), (const gchar *) hb_parc(2), hb_parni(3), &tmp_pos );
hb_storni( tmp_pos, 4 );
}

/*
HB_FUNC( GTK_EDITABLE_DELETE_TEXT )
{
GtkWidget * editable = GTK_WIDGET( hb_parnl( 1 ) );
gtk_editable_delete_text( GTK_EDITABLE(editable), hb_parni(2), hb_parni(3) );
}
*/

HB_FUNC( GTK_EDITABLE_GET_CHARS )
{
GtkWidget * editable = GTK_WIDGET( hb_parptr( 1 ) );
hb_retc((gchar *) gtk_editable_get_chars( GTK_EDITABLE(editable), hb_parni(2), hb_parni(3) ) );
}
/*
HB_FUNC( GTK_EDITABLE_SELECT_REGION )
{
GtkWidget * editable = GTK_WIDGET( hb_parnl( 1 ) );
gtk_editable_select_region( GTK_EDITABLE(editable), hb_parni(2), hb_parni(3) );
}
*/
HB_FUNC( G_SIGNAL_HANDLER_BLOCK )
{
GtkWidget * editable = GTK_WIDGET( hb_parptr( 1 ) );
g_signal_handler_block(G_OBJECT( editable ), hb_parnl(2) );
}

HB_FUNC( G_SIGNAL_HANDLER_UNBLOCK )
{
GtkWidget * editable = GTK_WIDGET( hb_parptr( 1 ) );
g_signal_handler_unblock(G_OBJECT( editable ), hb_parnl(2) );
}

#pragma ENDDUMP
//----------------------------------------------------------------------------//


