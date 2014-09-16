" Vim syntax file:
" Language:	TPuy 1.0.0
" Maintainer:	Riztan Gutierrez <riztan@gmail.com>
" Some things based on clipper.vim by C R Zamana
" Last Change:	Tusday Sep 16 2014

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Exceptions for my "Very Own" (TM) user variables naming style.
" If you don't like this, comment it
syn match  tpuyUserVariable	"\<[a,b,c,d,l,n,o,u,x][A-Z][A-Za-z0-9_]*\>"
syn match  tpuyUserVariable	"\<[a-z]\>"

" TPuy is case insensitive ( see "exception" above )
syn case ignore

" TPuy keywords ( in no particular order )
syn keyword tpuyStatement	ACCEPT APPEND BLANK FROM AVERAGE CALL CANCEL
syn keyword tpuyStatement	CLEAR ALL GETS MEMORY TYPEAHEAD CLOSE
syn keyword tpuyStatement	COMMIT CONTINUE SHARED NEW PICT
syn keyword tpuyStatement	COPY FILE STRUCTURE STRU EXTE TO COUNT
syn keyword tpuyStatement	CREATE FROM NIL
syn keyword tpuyStatement	DELETE FILE DIR DISPLAY EJECT ERASE FIND GO
syn keyword tpuyStatement	INDEX INPUT VALID WHEN
syn keyword tpuyStatement	JOIN KEYBOARD LABEL FORM LIST LOCATE MENU TO
syn keyword tpuyStatement	NOTE PACK QUIT READ
syn keyword tpuyStatement	RECALL REINDEX RELEASE RENAME REPLACE REPORT
syn keyword tpuyStatement	RETURN FORM RESTORE
syn keyword tpuyStatement	RUN SAVE SEEK SELECT
syn keyword tpuyStatement	SKIP SORT STORE SUM TEXT TOTAL TYPE UNLOCK
syn keyword tpuyStatement	UPDATE USE WAIT ZAP
syn keyword tpuyStatement	BEGIN SEQUENCE
syn keyword tpuyStatement	SET ALTERNATE BELL CENTURY COLOR CONFIRM CONSOLE
syn keyword tpuyStatement	CURSOR DATE DECIMALS DEFAULT DELETED DELIMITERS
syn keyword tpuyStatement	DEVICE EPOCH ESCAPE EXACT EXCLUSIVE FILTER FIXED
syn keyword tpuyStatement	FORMAT FUNCTION INTENSITY KEY MARGIN MESSAGE
syn keyword tpuyStatement	ORDER PATH PRINTER PROCEDURE RELATION SCOREBOARD
syn keyword tpuyStatement	SOFTSEEK TYPEAHEAD UNIQUE WRAP
syn keyword tpuyStatement	BOX CLEAR GET PROMPT SAY ? ??
syn keyword tpuyStatement	DELETE TAG GO RTLINKCMD TMP DBLOCKINFO
syn keyword tpuyStatement	DBEVALINFO DBFIELDINFO DBFILTERINFO DBFUNCTABLE
syn keyword tpuyStatement	DBOPENINFO DBORDERCONDINFO DBORDERCREATEINF
syn keyword tpuyStatement	DBORDERINFO DBRELINFO DBSCOPEINFO DBSORTINFO
syn keyword tpuyStatement	DBSORTITEM DBTRANSINFO DBTRANSITEM WORKAREA

" Conditionals
syn keyword tpuyConditional	CASE OTHERWISE ENDCASE
syn keyword tpuyConditional	IF ELSE ENDIF IIF IFDEF IFNDEF

" Loops
syn keyword tpuyRepeat	DO WHILE ENDDO
syn keyword tpuyRepeat	FOR TO NEXT STEP

" Visibility
syn keyword tpuyStorageClass	ANNOUNCE STATIC
syn keyword tpuyStorageClass DECLARE EXTERNAL LOCAL MEMVAR PARAMETERS
syn keyword tpuyStorageClass PRIVATE PROCEDURE PUBLIC REQUEST STATIC
syn keyword tpuyStorageClass FIELD FUNCTION
syn keyword tpuyStorageClass EXIT PROCEDURE INIT PROCEDURE

" Operators
syn match   tpuyOperator	"$\|%\|&\|+\|-\|->\|!"
syn match   tpuyOperator	"\.AND\.\|\.NOT\.\|\.OR\."
syn match   tpuyOperator	":=\|<\|<=\|<>\|!=\|#\|=\|==\|>\|>=\|@"
syn match   tpuyOperator     "*"

" Numbers
syn match   tpuyNumber	"\<\d\+\(u\=l\=\|lu\|f\)\>"

" Includes
syn region tpuyIncluded	contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match  tpuyIncluded	contained "<[^>]*>"
syn match  tpuyInclude	"^\s*#\s*include\>\s*["<]" contains=tpuyIncluded

" String and Character constants
syn region tpuyString	start=+"+ end=+"+
syn region tpuyString	start=+'+ end=+'+

" Delimiters
syn match  TPuyDelimiters	"[()]\|[\[\]]\|[{}]\|[||]"

" Special
syn match tpuyLineContinuation	";"

" This is from Bram Moolenaar:
if exists("c_comment_strings")
  " A comment can contain cString, cCharacter and cNumber.
  " But a "*/" inside a cString in a tpuyComment DOES end the comment!
  " So we need to use a special type of cString: tpuyCommentString, which
  " also ends on "*/", and sees a "*" at the start of the line as comment
  " again. Unfortunately this doesn't very well work for // type of comments :-(
  syntax match tpuyCommentSkip	contained "^\s*\*\($\|\s\+\)"
  syntax region tpuyCommentString	contained start=+"+ skip=+\\\\\|\\"+ end=+"+ end=+\*/+me=s-1 contains=tpuyCommentSkip
  syntax region tpuyComment2String	contained start=+"+ skip=+\\\\\|\\"+ end=+"+ end="$"
  syntax region tpuyComment		start="/\*" end="\*/" contains=tpuyCommentString,tpuyCharacter,tpuyNumber,tpuyString
  syntax match  tpuyComment		"//.*" contains=tpuyComment2String,tpuyCharacter,tpuyNumber
else
  syn region tpuyComment		start="/\*" end="\*/"
  syn match tpuyComment		"//.*"
endif
syntax match tpuyCommentError	"\*/"

" Lines beggining with an "*" are comments too
syntax match tpuyComment		"^\*.*"


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_tpuy_syntax_inits")
  if version < 508
    let did_tpuy_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink tpuyConditional		Conditional
  HiLink tpuyRepeat			Repeat
  HiLink tpuyNumber			Number
  HiLink tpuyInclude		Include
  HiLink tpuyComment		Comment
  HiLink tpuyOperator		Operator
  HiLink tpuyStorageClass		StorageClass
  HiLink tpuyStatement		Statement
  HiLink tpuyString			String
  HiLink tpuyFunction		Function
  HiLink tpuyLineContinuation	Special
  HiLink tpuyDelimiters		Delimiter
  HiLink tpuyUserVariable		Identifier

  delcommand HiLink
endif

let b:current_syntax = "tpuy"

" vim: ts=4
