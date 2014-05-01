/* $Id: main.prg,v 1.0 2008/10/23 14:44:02 riztan Exp $*/
/*
	Copyright © 2008  Riztan Gutierrez <riztang@gmail.com>

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

//#include "proandsys.ch"
#include "gclass.ch"
#include "tepuy.ch"

memvar oTpuy

Function FileChooser(nMode, cType )

   Local oFileChooser, cFile, cDialog
   Local cPath//, cAction
   
   Default nMode := GTK_FILE_CHOOSER_ACTION_OPEN
   Default cType := "XBS"

   DO CASE 
      CASE cType = "XBS"
         cPath   := "/xbscripts/*.xbs"
         //cAction := "oTpuy:OpenXBS(cFile)"
      CASE cType = "SQL"
         cPath   := "/sql/*.sql"
         //cAction := "OpenSQL(cFile)"
   ENDCASE
   
   SET RESOURCES oTpuy:cResource FROM FILE oTpuy:cRsrcMain 

//   MsgInfo( CStr(OSDRIVE() + "/" +CurDir()+"/xbscripts/") )

   If nMode = GTK_FILE_CHOOSER_ACTION_OPEN
      cDialog := "filechooserdialog0"
   Else
      cDialog := "filechooserdialog1"
   EndIf
      DEFINE FILECHOOSERBUTTON oFileChooser ID cDialog ;
          RESOURCE oTpuy:cResource;
          PATH_INIT OSDRIVE() + "/" +CurDir()+cPath
          
//          oFileChooser:SetIconName("gtk_preferences")

          DEFINE BUTTON ID "button_abrir" RESOURCE oTpuy:cResource;
                 ACTION (cFile:= oFileChooser:GetFileName(), oFileChooser:End(),;
                         IIF(cType = "XBS", oTpuy:OpenXBS(cFile), NIL ) )

          DEFINE BUTTON ID "button_cancelar" RESOURCE oTpuy:cResource;
                 ACTION oFileChooser:End()

    SysRefresh()

Return .T.


Function ChooserExec(nMode, cType )

   Local oFileChooser, cFile, cDialog
   Local cPath, cAction

   Default nMode := GTK_FILE_CHOOSER_ACTION_OPEN
   Default cType := "PPO"

   cPath   := "/xbscripts/*.ppo"
   //cAction := "oTpuy:RunXBS(cFile)"

   

   SET RESOURCES oTpuy:cResource FROM FILE oTpuy:cRsrcMain 

   If nMode = GTK_FILE_CHOOSER_ACTION_OPEN
      cDialog := "filechooserdialog0"
   Else
      cDialog := "filechooserdialog1"
   EndIf
      DEFINE FILECHOOSERBUTTON oFileChooser ID cDialog ;
          RESOURCE oTpuy:cResource;
          PATH_INIT OSDRIVE() + "/" +CurDir()+cPath

          DEFINE BUTTON ID "button_abrir" RESOURCE oTpuy:cResource;
                 ACTION ( cFile:= Token( Token(oFileChooser:GetFileName(),'/',; 
                          NumToken(oFileChooser:GetFileName(),'/') ) ,'.', 1 ),; 
                          oFileChooser:End(),;
                          MsgInfo(cFile) )

          DEFINE BUTTON ID "button_cancelar" RESOURCE oTpuy:cResource;
                 ACTION oFileChooser:End()

    SysRefresh()

Return .T.

//EOF
