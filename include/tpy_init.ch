/* $Id: tpy_init.ch,v 1.0 2014/05/17 17:52 riztan Exp $*/
/*
   Copyright © 2008-2014  Riztan Gutierrez <riztang@gmail.com>

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

/** \file tpy_init.ch.
 *  \brief Cabecera inicial  
 *  \author Riztan Gutierrez. riztan@gmail.com
 *  \date 2014
 *  \remark ... 
*/


REQUEST HB_LANG_ES
//REQUEST FIS_StrXOR
//REQUEST FIS_ErrStr
//REQUEST FIS_SendCmd
//REQUEST HexToStr
//REQUEST StrToHex
//REQUEST StruToGType
//REQUEST Run2Me
//REQUEST CSV2Array
//REQUEST ValidMail
//REQUEST TPYENTRY

REQUEST DISPBOX
REQUEST __BOX
REQUEST __BOXD
REQUEST __BOXS
REQUEST DEVOUTPICT

REQUEST hb_MD5

REQUEST TDolphinSrv
REQUEST hb_Crypt
REQUEST hb_DeCrypt

REQUEST hb_DATETIME
REQUEST hb_HOUR
REQUEST hb_MINUTE
REQUEST hb_TTON
REQUEST hb_NTOT
REQUEST hb_TTOS
REQUEST hb_STOT
REQUEST hb_TTOC
REQUEST hb_CTOT
REQUEST hb_TSTOSTR
REQUEST hb_STRTOTS
REQUEST hb_RUN
REQUEST __RUN

REQUEST hb_serialize
REQUEST hb_deserialize
REQUEST netio_connect
REQUEST netio_funcexec
REQUEST netio_procexists

REQUEST hb_RegExMatch

//REQUEST FILE_OPEN
//REQUEST FILE_CLOSE
REQUEST CURL_GLOBAL_INIT
REQUEST CURL_GLOBAL_CLEANUP
REQUEST CURL_EASY_INIT
REQUEST CURL_EASY_CLEANUP
REQUEST CURL_EASY_SETOPT
REQUEST CURL_EASY_STRERROR
REQUEST CURL_EASY_PERFORM
REQUEST CURL_EASY_DL_BUFF_GET
REQUEST CURL_EASY_RESET
REQUEST CURL_VERSION


REQUEST GTREESTORE
REQUEST GFIXED

REQUEST Directory

#ifdef __PLATFORM__WINDOWS
   REQUEST HB_GT_WVT_DEFAULT

   REQUEST WIN_OLECREATEOBJECT
   REQUEST WIN_OLEERRORTEXT
   REQUEST SHELLEXECUTE
   REQUEST WAPI_SHELLEXECUTE
   REQUEST WIN_REGGET
   REQUEST WIN_REGSET
   REQUEST WIN_REGREAD
   REQUEST WIN_REGWRITE

   #define THREAD_GT "WVT"

   #define HOMEPATH  GetEnv("HOMEPATH")

#else
   REQUEST HB_GT_STD_DEFAULT
   #define THREAD_GT "XWC"
   
   #define HOMEPATH  GetEnv("HOME")

#endif

//REQUEST DBFCDX
//REQUEST DBUSEAREA

//NETIO
REQUEST NETIO_CONNECT
REQUEST NETIO_FUNCEXEC
REQUEST NETIO_PROCEXISTS
REQUEST NETIO_DISCONNECT
REQUEST NETIO_GETCONNECTION


