/*
 Funciones de TPuy en DataPro 
 */

#include "common.ch"
#include "gclass.ch"

memvar oTpuy

#translate ( <exp1> LIKE <exp2> )   => ( hb_regexLike( (<exp2>), (<exp1>) ) )

#xtranslate MensajeErr(<cMsg>,<cTitle>) => MsgStop(<cMsg>,<cTitle>)
#xtranslate WaitRun(<cRun>,<nVal>) => ShellExecute(<cRun>,"",<nVal>)

/*
   Funcion para reconocer si el sistema es
   Administrativo o Nómina
*/
FUNCTION DP_SYS(cPath)
   Local cRes := "ADMCONFIG"
   Default cPath := " "
   IF ( "DPNMWIN" $ UPPER(AllTrim(cPath)) )
      cRes := "NMCONFIG"
   ENDIF
RETURN cRes



//#ifndef __XHARBOUR__
//FUNCTION SENMAIL(...)
//return .t.
//#else
FUNCTION SENDMAIL(cFrom,cTo,cName,cUser,cPass, ;
                 lTTLS,cSMTP,cSubject,cBody,  ;
                 lHtml,nPort,cAttach)
   Local nRes, lBodyFile:=.f.
   Local cTTLS , cCadena, cMime:="text/plain"
   Local cProgram := "bin\ms1.16.exe"
   Local cMyPass, cPort:="25"

   DEFAULT lHtml := .F.

   if nPort=NIL
      if ("gmail"$cSMTP)
         cPort := "587"
      endif
   endif

   if ValType(nPort)="N"
      cPort := VAL(nPort)
   elseif ValType(nPort)="C"
      cPort := nPort
   endif

   if Empty(cFrom) .OR. Empty(cTo) .OR. Empty(cUser) .OR. ;
      Empty(cPass) .OR. Empty(cSMTP) .OR. Empty(cSubject) .OR. ;
      Empty(cBody)
      MensajeErr("Faltan Argumentos.","No se puede enviar correo.")
      Return .F.
   endif

   cMyPass := ENCRIP( cPass, .F., .t. )

   if Empty(cName) ; cName := cTo ; endif

   if File(cBody) 
      //cBody := MEMOREAD(cBody) 
      lBodyFile := .t.
   endif

   if lHtml ; cMime := STRTRAN(cMime,"plain","html") ; endif

   if lTTLS
      cTTLS := " -starttls "
   endif

   cCadena := IIF(lTTLS,cTTLS + " -auth-plain","") +;
              " -user "+lower(cUser)+;
              " -pass "+cMyPass+" -t "+cTo+" "+;
              " -smtp "+lower(cSMTP)+" "+;
              " -port "+cPort+" "+;
              " -from "+cFrom+" "+;
              ' -name "'+AllTrim(cName)+'" '+;
              ' -sub "'+cSubject+'" '+;
              IIF(lBodyFile, ' -attach "'+AllTrim(cBody)+','+cMime+',i"' ,;
                             ' -M "'+cBody+'"')+;
              IIF(!Empty(cAttach)," -attach "+'"'+cAttach+","+hb_SetMimeType( cAttach )+'"',"")
/*
mailsend -to user@gmail.com -from user@gmail.com -starttls -smtp smtp.gmail.com -port 587 -sub test +cc +bc -v -auth-plain -user you -pass secreto
*/

   if file(cProgram)

//MsgInfo(cProgram+" "+cCadena)
//return .t.
#ifdef __PLATFORM__UNIX 
      /* buscar como enviar el correo en sistema tipo unix */
      nRes := 0 //ShellExecute(cProgram,cCadena,0) 
#else
      nRes := ShellExecute(cProgram,cCadena,0) 
#endif

      if nRes < 32
         MensajeErr("ocurrio un problema al intentar enviar el correo","Problema desconocido")
         Return nRes
      endif

   else
      MensajeErr("No se puede enviar el correo.","Problema desconocido")
   endif
//?? nRes
//?? clpcopy(cCadena)

RETURN nRes
//#endif

FUNCTION hb_SetMimeType( cFile )

   cFile := Lower( cFile )

   DO CASE
   CASE ( cFile LIKE ".+\.vbd" ); RETURN "application/activexdocument"
   CASE ( cFile LIKE ".+\.(asn|asz|asd)" ); RETURN "application/astound"
   CASE ( cFile LIKE ".+\.pqi" ); RETURN "application/cprplayer"
   CASE ( cFile LIKE ".+\.tsp" ); RETURN "application/dsptype"
   CASE ( cFile LIKE ".+\.exe" ); RETURN "application/exe"
   CASE ( cFile LIKE ".+\.(sml|ofml)" ); RETURN "application/fml"
   CASE ( cFile LIKE ".+\.pfr" ); RETURN "application/font-tdpfr"
   CASE ( cFile LIKE ".+\.frl" ); RETURN "application/freeloader"
   CASE ( cFile LIKE ".+\.spl" ); RETURN "application/futuresplash"
   CASE ( cFile LIKE ".+\.gz" ); RETURN "application/gzip"
   CASE ( cFile LIKE ".+\.stk" ); RETURN "application/hstu"
   CASE ( cFile LIKE ".+\.ips" ); RETURN "application/ips"
   CASE ( cFile LIKE ".+\.ptlk" ); RETURN "application/listenup"
   CASE ( cFile LIKE ".+\.hqx" ); RETURN "application/mac-binhex40"
   CASE ( cFile LIKE ".+\.mbd" ); RETURN "application/mbedlet"
   CASE ( cFile LIKE ".+\.mfp" ); RETURN "application/mirage"
   CASE ( cFile LIKE ".+\.(pot|pps|ppt|ppz)" ); RETURN "application/mspowerpoint"
   CASE ( cFile LIKE ".+\.doc" ); RETURN "application/msword"
   CASE ( cFile LIKE ".+\.n2p" ); RETURN "application/n2p"
   CASE ( cFile LIKE ".+\.(bin|class|lha|lzh|lzx|dbf)" ); RETURN "application/octet-stream"
   CASE ( cFile LIKE ".+\.oda" ); RETURN "application/oda"
   CASE ( cFile LIKE ".+\.axs" ); RETURN "application/olescript"
   CASE ( cFile LIKE ".+\.zpa" ); RETURN "application/pcphoto"
   CASE ( cFile LIKE ".+\.pdf" ); RETURN "application/pdf"
   CASE ( cFile LIKE ".+\.(ai|eps|ps)" ); RETURN "application/postscript"
   CASE ( cFile LIKE ".+\.shw" ); RETURN "application/presentations"
   CASE ( cFile LIKE ".+\.qrt" ); RETURN "application/quest"
   CASE ( cFile LIKE ".+\.rtc" ); RETURN "application/rtc"
   CASE ( cFile LIKE ".+\.rtf" ); RETURN "application/rtf"
   CASE ( cFile LIKE ".+\.smp" ); RETURN "application/studiom"
   CASE ( cFile LIKE ".+\.dst" ); RETURN "application/tajima"
   CASE ( cFile LIKE ".+\.talk" ); RETURN "application/talker"
   CASE ( cFile LIKE ".+\.tbk" ); RETURN "application/toolbook"
   CASE ( cFile LIKE ".+\.vmd" ); RETURN "application/vocaltec-media-desc"
   CASE ( cFile LIKE ".+\.vmf" ); RETURN "application/vocaltec-media-file"
   CASE ( cFile LIKE ".+\.wri" ); RETURN "application/write"
   CASE ( cFile LIKE ".+\.wid" ); RETURN "application/x-DemoShield"
   CASE ( cFile LIKE ".+\.rrf" ); RETURN "application/x-InstallFromTheWeb"
   CASE ( cFile LIKE ".+\.wis" ); RETURN "application/x-InstallShield"
   CASE ( cFile LIKE ".+\.ins" ); RETURN "application/x-NET-Install"
   CASE ( cFile LIKE ".+\.tmv" ); RETURN "application/x-Parable-Thing"
   CASE ( cFile LIKE ".+\.arj" ); RETURN "application/x-arj"
   CASE ( cFile LIKE ".+\.asp" ); RETURN "application/x-asap"
   CASE ( cFile LIKE ".+\.aab" ); RETURN "application/x-authorware-bin"
   CASE ( cFile LIKE ".+\.(aam|aas)" ); RETURN "application/x-authorware-map"
   CASE ( cFile LIKE ".+\.bcpio" ); RETURN "application/x-bcpio"
   CASE ( cFile LIKE ".+\.vcd" ); RETURN "application/x-cdlink"
   CASE ( cFile LIKE ".+\.chat" ); RETURN "application/x-chat"
   CASE ( cFile LIKE ".+\.cnc" ); RETURN "application/x-cnc"
   CASE ( cFile LIKE ".+\.(coda|page)" ); RETURN "application/x-coda"
   CASE ( cFile LIKE ".+\.z" ); RETURN "application/x-compress"
   CASE ( cFile LIKE ".+\.con" ); RETURN "application/x-connector"
   CASE ( cFile LIKE ".+\.cpio" ); RETURN "application/x-cpio"
   CASE ( cFile LIKE ".+\.pqf" ); RETURN "application/x-cprplayer"
   CASE ( cFile LIKE ".+\.csh" ); RETURN "application/x-csh"
   CASE ( cFile LIKE ".+\.(cu|csm)" ); RETURN "application/x-cu-seeme"
   CASE ( cFile LIKE ".+\.(dcr|dir|dxr|swa)" ); RETURN "application/x-director"
   CASE ( cFile LIKE ".+\.dvi" ); RETURN "application/x-dvi"
   CASE ( cFile LIKE ".+\.evy" ); RETURN "application/x-envoy"
   CASE ( cFile LIKE ".+\.ebk" ); RETURN "application/x-expandedbook"
   CASE ( cFile LIKE ".+\.gtar" ); RETURN "application/x-gtar"
   CASE ( cFile LIKE ".+\.hdf" ); RETURN "application/x-hdf"
   CASE ( cFile LIKE ".+\.map" ); RETURN "application/x-httpd-imap"
   CASE ( cFile LIKE ".+\.phtml" ); RETURN "application/x-httpd-php"
   CASE ( cFile LIKE ".+\.php3" ); RETURN "application/x-httpd-php3"
   CASE ( cFile LIKE ".+\.ica" ); RETURN "application/x-ica"
   CASE ( cFile LIKE ".+\.ipx" ); RETURN "application/x-ipix"
   CASE ( cFile LIKE ".+\.ips" ); RETURN "application/x-ipscript"
   CASE ( cFile LIKE ".+\.js" ); RETURN "application/x-javascript"
   CASE ( cFile LIKE ".+\.latex" ); RETURN "application/x-latex"
   CASE ( cFile LIKE ".+\.bin" ); RETURN "application/x-macbinary"
   CASE ( cFile LIKE ".+\.mif" ); RETURN "application/x-mif"
   CASE ( cFile LIKE ".+\.(mpl|mpire)" ); RETURN "application/x-mpire"
   CASE ( cFile LIKE ".+\.adr" ); RETURN "application/x-msaddr"
   CASE ( cFile LIKE ".+\.wlt" ); RETURN "application/x-mswallet"
   CASE ( cFile LIKE ".+\.(nc|cdf)" ); RETURN "application/x-netcdf"
   CASE ( cFile LIKE ".+\.npx" ); RETURN "application/x-netfpx"
   CASE ( cFile LIKE ".+\.nsc" ); RETURN "application/x-nschat"
   CASE ( cFile LIKE ".+\.pgp" ); RETURN "application/x-pgp-plugin"
   CASE ( cFile LIKE ".+\.css" ); RETURN "application/x-pointplus"
   CASE ( cFile LIKE ".+\.sh" ); RETURN "application/x-sh"
   CASE ( cFile LIKE ".+\.shar" ); RETURN "application/x-shar"
   CASE ( cFile LIKE ".+\.swf" ); RETURN "application/x-shockwave-flash"
   CASE ( cFile LIKE ".+\.spr" ); RETURN "application/x-sprite"
   CASE ( cFile LIKE ".+\.sprite" ); RETURN "application/x-sprite"
   CASE ( cFile LIKE ".+\.sit" ); RETURN "application/x-stuffit"
   CASE ( cFile LIKE ".+\.sca" ); RETURN "application/x-supercard"
   CASE ( cFile LIKE ".+\.sv4cpio" ); RETURN "application/x-sv4cpio"
   CASE ( cFile LIKE ".+\.sv4crc" ); RETURN "application/x-sv4crc"
   CASE ( cFile LIKE ".+\.tar" ); RETURN "application/x-tar"
   CASE ( cFile LIKE ".+\.tcl" ); RETURN "application/x-tcl"
   CASE ( cFile LIKE ".+\.tex" ); RETURN "application/x-tex"
   CASE ( cFile LIKE ".+\.(texinfo|texi)" ); RETURN "application/x-texinfo"
   CASE ( cFile LIKE ".+\.tlk" ); RETURN "application/x-tlk"
   CASE ( cFile LIKE ".+\.(t|tr|roff)" ); RETURN "application/x-troff"
   CASE ( cFile LIKE ".+\.man" ); RETURN "application/x-troff-man"
   CASE ( cFile LIKE ".+\.me" ); RETURN "application/x-troff-me"
   CASE ( cFile LIKE ".+\.ms" ); RETURN "application/x-troff-ms"
   CASE ( cFile LIKE ".+\.alt" ); RETURN "application/x-up-alert"
   CASE ( cFile LIKE ".+\.che" ); RETURN "application/x-up-cacheop"
   CASE ( cFile LIKE ".+\.ustar" ); RETURN "application/x-ustar"
   CASE ( cFile LIKE ".+\.src" ); RETURN "application/x-wais-source"
   CASE ( cFile LIKE ".+\.xls" ); RETURN "application/xls"
   CASE ( cFile LIKE ".+\.xlt" ); RETURN "application/xlt"
   CASE ( cFile LIKE ".+\.zip" ); RETURN "application/zip"
   CASE ( cFile LIKE ".+\.(au|snd)" ); RETURN "audio/basic"
   CASE ( cFile LIKE ".+\.es" ); RETURN "audio/echospeech"
   CASE ( cFile LIKE ".+\.(gsm|gsd)" ); RETURN "audio/gsm"
   CASE ( cFile LIKE ".+\.rmf" ); RETURN "audio/rmf"
   CASE ( cFile LIKE ".+\.tsi" ); RETURN "audio/tsplayer"
   CASE ( cFile LIKE ".+\.vox" ); RETURN "audio/voxware"
   CASE ( cFile LIKE ".+\.wtx" ); RETURN "audio/wtx"
   CASE ( cFile LIKE ".+\.(aif|aiff|aifc)" ); RETURN "audio/x-aiff"
   CASE ( cFile LIKE ".+\.(cht|dus)" ); RETURN "audio/x-dspeech"
   CASE ( cFile LIKE ".+\.(mid|midi)" ); RETURN "audio/x-midi"
   CASE ( cFile LIKE ".+\.mp3" ); RETURN "audio/x-mpeg"
   CASE ( cFile LIKE ".+\.mp2" ); RETURN "audio/x-mpeg"
   CASE ( cFile LIKE ".+\.m3u" ); RETURN "audio/x-mpegurl"
   CASE ( cFile LIKE ".+\.(ram|ra)" ); RETURN "audio/x-pn-realaudio"
   CASE ( cFile LIKE ".+\.rpm" ); RETURN "audio/x-pn-realaudio-plugin"
   CASE ( cFile LIKE ".+\.stream" ); RETURN "audio/x-qt-stream"
   CASE ( cFile LIKE ".+\.rmf" ); RETURN "audio/x-rmf"
   CASE ( cFile LIKE ".+\.(vqf|vql)" ); RETURN "audio/x-twinvq"
   CASE ( cFile LIKE ".+\.vqe" ); RETURN "audio/x-twinvq-plugin"
   CASE ( cFile LIKE ".+\.wav" ); RETURN "audio/x-wav"
   CASE ( cFile LIKE ".+\.wtx" ); RETURN "audio/x-wtx"
   CASE ( cFile LIKE ".+\.mol" ); RETURN "chemical/x-mdl-molfile"
   CASE ( cFile LIKE ".+\.pdb" ); RETURN "chemical/x-pdb"
   CASE ( cFile LIKE ".+\.dwf" ); RETURN "drawing/x-dwf"
   CASE ( cFile LIKE ".+\.ivr" ); RETURN "i-world/i-vrml"
   CASE ( cFile LIKE ".+\.cod" ); RETURN "image/cis-cod"
   CASE ( cFile LIKE ".+\.cpi" ); RETURN "image/cpi"
   CASE ( cFile LIKE ".+\.fif" ); RETURN "image/fif"
   CASE ( cFile LIKE ".+\.gif" ); RETURN "image/gif"
   CASE ( cFile LIKE ".+\.ief" ); RETURN "image/ief"
   CASE ( cFile LIKE ".+\.(jpeg|jpg|jpe)" ); RETURN "image/jpeg"
   CASE ( cFile LIKE ".+\.rip" ); RETURN "image/rip"
   CASE ( cFile LIKE ".+\.svh" ); RETURN "image/svh"
   CASE ( cFile LIKE ".+\.(tiff|tif)" ); RETURN "image/tiff"
   CASE ( cFile LIKE ".+\.mcf" ); RETURN "image/vasa"
   CASE ( cFile LIKE ".+\.(svf|dwg|dxf)" ); RETURN "image/vnd"
   CASE ( cFile LIKE ".+\.wi" ); RETURN "image/wavelet"
   CASE ( cFile LIKE ".+\.ras" ); RETURN "image/x-cmu-raster"
   CASE ( cFile LIKE ".+\.etf" ); RETURN "image/x-etf"
   CASE ( cFile LIKE ".+\.fpx" ); RETURN "image/x-fpx"
   CASE ( cFile LIKE ".+\.(fh5|fh4|fhc)" ); RETURN "image/x-freehand"
   CASE ( cFile LIKE ".+\.dsf" ); RETURN "image/x-mgx-dsf"
   CASE ( cFile LIKE ".+\.pnm" ); RETURN "image/x-portable-anymap"
   CASE ( cFile LIKE ".+\.pbm" ); RETURN "image/x-portable-bitmap"
   CASE ( cFile LIKE ".+\.pgm" ); RETURN "image/x-portable-graymap"
   CASE ( cFile LIKE ".+\.ppm" ); RETURN "image/x-portable-pixmap"
   CASE ( cFile LIKE ".+\.rgb" ); RETURN "image/x-rgb"
   CASE ( cFile LIKE ".+\.xbm" ); RETURN "image/x-xbitmap"
   CASE ( cFile LIKE ".+\.xpm" ); RETURN "image/x-xpixmap"
   CASE ( cFile LIKE ".+\.xwd" ); RETURN "image/x-xwindowdump"
   CASE ( cFile LIKE ".+\.dig" ); RETURN "multipart/mixed"
   CASE ( cFile LIKE ".+\.push" ); RETURN "multipart/x-mixed-replace"
   CASE ( cFile LIKE ".+\.(wan|waf)" ); RETURN "plugin/wanimate"
   CASE ( cFile LIKE ".+\.ccs" ); RETURN "text/ccs"
   CASE ( cFile LIKE ".+\.(htm|html)" ); RETURN "text/html"
   CASE ( cFile LIKE ".+\.pgr" ); RETURN "text/parsnegar-document"
   CASE ( cFile LIKE ".+\.xml" ); RETURN "text/xml"
   CASE ( cFile LIKE ".+\.txt" ); RETURN "text/plain"
   CASE ( cFile LIKE ".+\.rtx" ); RETURN "text/richtext"
   CASE ( cFile LIKE ".+\.tsv" ); RETURN "text/tab-separated-values"
   CASE ( cFile LIKE ".+\.hdml" ); RETURN "text/x-hdml"
   CASE ( cFile LIKE ".+\.etx" ); RETURN "text/x-setext"
   CASE ( cFile LIKE ".+\.(talk|spc)" ); RETURN "text/x-speech"
   CASE ( cFile LIKE ".+\.afl" ); RETURN "video/animaflex"
   CASE ( cFile LIKE ".+\.(mpeg|mpg|mpe)" ); RETURN "video/mpeg"
   CASE ( cFile LIKE ".+\.(qt|mov)" ); RETURN "video/quicktime"
   CASE ( cFile LIKE ".+\.(viv|vivo)" ); RETURN "video/vnd.vivo"
   CASE ( cFile LIKE ".+\.(asf|asx)" ); RETURN "video/x-ms-asf"
   CASE ( cFile LIKE ".+\.avi" ); RETURN "video/x-msvideo"
   CASE ( cFile LIKE ".+\.movie" ); RETURN "video/x-sgi-movie"
   CASE ( cFile LIKE ".+\.(vgm|vgx|xdr)" ); RETURN "video/x-videogram"
   CASE ( cFile LIKE ".+\.vgp" ); RETURN "video/x-videogram-plugin"
   CASE ( cFile LIKE ".+\.vts" ); RETURN "workbook/formulaone"
   CASE ( cFile LIKE ".+\.vtts" ); RETURN "workbook/formulaone"
   CASE ( cFile LIKE ".+\.(3dmf|3dm|qd3d|qd3)" ); RETURN "x-world/x-3dmf"
   CASE ( cFile LIKE ".+\.svr" ); RETURN "x-world/x-svr"
   CASE ( cFile LIKE ".+\.(wrl|wrz)" ); RETURN "x-world/x-vrml"
   CASE ( cFile LIKE ".+\.vrt" ); RETURN "x-world/x-vrt"
   ENDCASE

RETURN "text/plain"




FUNCTION MEncrip(cCadena, lEncripta, lMail)
  LOCAL cResult 

  DEFAULT lEncripta TO .t.
  DEFAULT lMail TO .f.  

  cResult := Encrip(cCadena+"tpuyrigc",lEncripta)

//? RIGHT(cResult,8)
/*
  if !lEncripta
     if RIGHT(cResult,8)="tpuyrigc"
        RETURN LEFT( cResult, LEN(cResult)-8  )
     endif
  endif
*/
RETURN cResult

FUNCTION MENCRIP_CHECK(cCadena)
RETURN Encrip( cCadena, .F., .F., .T. )



FUNCTION Encrip(cCadena, lAccion, lMail, lCheck)
   Local I:=1,cRes:=""
   Local lVerif

   DEFAULT lAccion TO .T.
   DEFAULT lMail TO .f.
   DEFAULT lCheck TO .f.

   IF lAccion
      cCadena:="-"+cCadena+"¡"
   ENDIF

   While I<=LEN(cCadena)

      cRes:=cRes+EncripChar( SUBSTR(cCadena,I,1), LEN(cCadena), I , lAccion )
      I ++
   ENDDO

   IF !lAccion
//      cRes:=(SUBSTR(cRes,1,4),1,LEN(cRes)-8)
      cRes := LEFT ( RIGHT( cRes, LEN(cRes)-1 ), LEN(cRes)-2 )
   ENDIF

   IF !lAccion
     lVerif := RIGHT(cRes,8)="tpuyrigc"
     IF lCheck
        RETURN lVerif
     ENDIF
     IF lVerif
        IF lMail
           RETURN LEFT( cRes, LEN(cRes)-8  )
        ELSE
           RETURN "*" //LEFT( cRes, LEN(cRes)-8  )
        ENDIF
     ENDIF
   ENDIF

RETURN cRes


FUNCTION EncripChar(cChar, nVariable, nInd, lAccion)

   Local nIndice, cResult
   Local tPA1:="nwyñ748tz15",tPA2:="D26GA9ú0J&K}",tPA3:="öH³LCü3EM)B¤I",tPA4:="]-u€v_.ékFó¥l'?¿h("
   Local tPA5:="í¶UçáTVd=iXce",tPA6:="¡!NabRS:Q,;|@fgj#",tPA7:="$%Ñ{Yxopmr[²WOPqZ"
   Local tPB1:="ó%¶AHJBPfgNWTZ",tPB2:="ÑOnQbcdRSej",tPB3:="ñVauvmUoyzhirt",tPB4:="x5kl0'67w?p³éIC"
   Local tPB5:="GXYEFúq8124(",tPB6:="9)-3¿¡_.:!#$,",tPB7:=";|&}]@á{[²¤€MKDL¥=íçöü"
   Local cPatronA:=tPA1+tPA2+tPA3+tPA4+tPA5+tPA6+tPA7
   Local cPatronB:=tPB1+tPB2+tPB3+tPB4+tPB5+tPB6+tPB7
   Local cPatA:=cPatronA, cPatB:=cPatronB

   DEFAULT cChar   TO ""
   DEFAULT nVariable TO 0
   DEFAULT nInd    TO 0
   DEFAULT lAccion TO .T.

   cResult:=cChar

   IF !lAccion
      cPatA:=cPatronB
      cPatB:=cPatronA
   ENDIF

   If AT( cChar, cPatB ) <> 0

      IF lAccion
   
//? AT( cChar, cPatB ) + nVariable + nInd,  Len(cPatB) 
//?  hb_MOD(1,1)

         nIndice:= MOD ( AT( cChar, cPatB ) + nVariable + nInd , Len(cPatB) )

         cResult:= SUBSTR( cPatA, nIndice , 1  )

      ELSE

         IF ( AT( cChar, cPatB ) - nVariable - nInd ) > 0

            nIndice:= MOD ( AT( cChar, cPatB ) - nVariable - nInd , Len(cPatB) )

         ELSE

            nIndice:= MOD ( Len(cPatB) + AT( cChar, cPatB ) - nVariable - nInd , Len(cPatB) )

         ENDIF

         cResult:= SUBSTR( cPatA, nIndice , 1  )

      ENDIF

   EndIf
   

RETURN cResult

