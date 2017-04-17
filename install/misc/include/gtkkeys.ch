/*  $Id: gtkkeys.ch,v 1.3 2007-08-12 13:55:20 clneumann Exp $ */
/*
 * GtkApi.ch Códigos de teclas para T-Gtk -------------------------------------
 * Porting Harbour to GTK+ power !
 * Las definiciones pertenecen a GDK gdkkeysyms.h 
 * (C) 2005. Rafa Carmona -TheFull-
 * (C) 2005. Joaquim Ferrer
 */

#define GDK_HOME             0xFF50
#define GDK_LEFT             0xFF51
#define GDK_UP               0xFF52
#define GDK_RIGHT            0xFF53
#define GDK_DOWN             0xFF54
#define GDK_PRIOR            0xFF55
#define GDK_Page_Up          0xFF55
#define GDK_NEXT             0xFF56
#define GDK_Page_Down        0xFF56
#define GDK_END              0xFF57
#define GDK_Begin            0xFF58
#define GDK_SELECT           0xFF60
#define GDK_PRINT            0xFF61
#define GDK_EXECUTE          0xFF62
#define GDK_INSERT           0xFF63
#define GDK_Return           0xFF0D
#define GDK_Delete           0xFFFF

#define GDK_KP_Space         0xFF80
#define GDK_KP_Tab           0xFF89
#define GDK_KP_Enter         0xFF8D
#define GDK_Escape           0xFF1B
#define GDK_BackSpace        0xFF08
#define GDK_Tab              0xFF09
#define GDK_Shift_L          0xFFE1
#define GDK_Shift_R          0xFFE2
#define GDK_Control_L        0xFFE3
#define GDK_Control_R        0xFFE4
#define GDK_space 			 0x020
#define GDK_exclam 			 0x021
#define GDK_quotedbl 		 0x022
#define GDK_numbersign 		 0x023
#define GDK_dollar 			 0x024
#define GDK_percent 		 0x025
#define GDK_ampersand 		 0x026
#define GDK_apostrophe 		 0x027
#define GDK_quoteright 		 0x027
#define GDK_parenleft 		 0x028
#define GDK_parenright 		 0x029
#define GDK_asterisk 		 0x02A
#define GDK_plus 			 0x02B
#define GDK_comma 			 0x02C
#define GDK_minus 			 0x02D
#define GDK_period 			 0x02E
#define GDK_slash 			 0x02F

#define GDK_VoidSymbol       0xFFFFFF

// Puesto por Manuel Calomarde 29-03-2006
#define GDK_F1  0xFFBE
#define GDK_F2  0xFFBF
#define GDK_F3  0xFFC0
#define GDK_F4  0xFFC1
#define GDK_F5  0xFFC2
#define GDK_F6  0xFFC3
#define GDK_F7  0xFFC4
#define GDK_F8  0xFFC5
#define GDK_F9  0xFFC6
#define GDK_F10 0xFFC7
#define GDK_F11 0xFFC8
#define GDK_L1  0xFFC8
#define GDK_F12 0xFFC9

/*
  -- estas teclas chocan con hbrun de harbour --
  
  
#define K_ESC       65307
#define K_HOME      65360
#define K_END       65367
#define K_PAGEUP    65365
#define K_PAGEDOWN  65366
#define K_UP        65362
#define K_DOWN      65364
#define K_TAB       65289
#define K_LEFT      65361
#define K_RIGHT     65363
#define K_DEL       65535
#define K_BS        65288
#define K_SHIFT     65505
#define K_CTRL      65507
#define K_UPPER     65509
#define K_ENTER     65293
*/
#define GTK_KEY_ESC       65307
#define GTK_KEY_HOME      65360
#define GTK_KEY_END       65367
#define GTK_KEY_PAGEUP    65365
#define GTK_KEY_PAGEDOWN  65366
#define GTK_KEY_UP        65362
#define GTK_KEY_DOWN      65364
#define GTK_KEY_TAB       65289
#define GTK_KEY_LEFT      65361
#define GTK_KEY_RIGHT     65363
#define GTK_KEY_DEL       65535
#define GTK_KEY_BS        65288
#define GTK_KEY_SHIFT     65505
#define GTK_KEY_CTRL      65507
#define GTK_KEY_UPPER     65509
#define GTK_KEY_ENTER     65293


/* Por definir

#define VK_LBUTTON          1         //  0x01
#define VK_RBUTTON          2         //  0x02
#define VK_CANCEL           3         //  0x03
#define VK_MBUTTON          4         //  0x04
#define VK_BACK             8         //  0x08
#define VK_TAB              9         //  0x09
#define VK_CLEAR            12        //  0x0C
#define VK_RETURN           13        //  0x0D
#define VK_SHIFT            16        //  0x10
#define VK_CONTROL          17        //  0x11
#define VK_MENU             18        //  0x12
#define VK_PAUSE            19        //  0x13
#define VK_CAPITAL          20        //  0x14
#define VK_ESCAPE           27        //  0x1B
#define VK_SPACE            32        //  0x20
#define VK_SNAPSHOT         44        //  0x2C
#define VK_DELETE           46        //  0x2E
#define VK_HELP             47        //  0x2F
#define VK_NUMPAD0          96        //  0x60
#define VK_NUMPAD1          97        //  0x61
#define VK_NUMPAD2          98        //  0x62
#define VK_NUMPAD3          99        //  0x63
#define VK_NUMPAD4         100        //  0x64
#define VK_NUMPAD5         101        //  0x65
#define VK_NUMPAD6         102        //  0x66
#define VK_NUMPAD7         103        //  0x67
#define VK_NUMPAD8         104        //  0x68
#define VK_NUMPAD9         105        //  0x69
#define VK_MULTIPLY        106        //  0x6A
#define VK_ADD             107        //  0x6B
#define VK_SEPARATOR       108        //  0x6C
#define VK_SUBTRACT        109        //  0x6D
#define VK_DECIMAL         110        //  0x6E
#define VK_DIVIDE          111        //  0x6F
#define VK_F1              112        //  0x70
#define VK_F2              113        //  0x71
#define VK_F3              114        //  0x72
#define VK_F4              115        //  0x73
#define VK_F5              116        //  0x74
#define VK_F6              117        //  0x75
#define VK_F7              118        //  0x76
#define VK_F8              119        //  0x77
#define VK_F9              120        //  0x78
#define VK_F10             121        //  0x79
#define VK_F11             122        //  0x7A
#define VK_F12             123        //  0x7B
#define VK_F13             124        //  0x7C
#define VK_F14             125        //  0x7D
#define VK_F15             126        //  0x7E
#define VK_F16             127        //  0x7F
#define VK_F17             128        //  0x80
#define VK_F18             129        //  0x81
#define VK_F19             130        //  0x82
#define VK_F20             131        //  0x83
#define VK_F21             132        //  0x84
#define VK_F22             133        //  0x85
#define VK_F23             134        //  0x86
#define VK_F24             135        //  0x87
#define VK_NUMLOCK         144        //  0x90
#define VK_SCROLL          145        //  0x91
*/

#define GDK_a 0x061
#define GDK_b 0x062
#define GDK_c 0x063
#define GDK_d 0x064
#define GDK_e 0x065
#define GDK_f 0x066
#define GDK_g 0x067
#define GDK_h 0x068
#define GDK_i 0x069
#define GDK_j 0x06a
#define GDK_k 0x06b
#define GDK_l 0x06c
#define GDK_m 0x06d
#define GDK_n 0x06e
#define GDK_o 0x06f
#define GDK_p 0x070
#define GDK_q 0x071
#define GDK_r 0x072
#define GDK_s 0x073
#define GDK_t 0x074
#define GDK_u 0x075
#define GDK_v 0x076
#define GDK_w 0x077
#define GDK_x 0x078
#define GDK_y 0x079
#define GDK_z 0x07a
