/*  $Id: gdkevent.ch,v 1.1 2006-09-08 10:16:34 xthefull Exp $ */
/*
 * GdkEvent.ch Codigos de evento para T-Gtk -------------------------------------
 * Las definiciones pertenecen a GDK gdkkeysyms.h 
 * Porting Harbour to GTK+ power !
 * (C) 2005. Rafa Carmona -TheFull-
 * (C) 2005. Joaquim Ferrer
 */

#define   GDK_NOTHING	         -1
#define   GDK_DELETE		  0
#define   GDK_DESTROY		  1
#define   GDK_EXPOSE		  2
#define   GDK_MOTION_NOTIFY       3
#define   GDK_BUTTON_PRESS        4
#define   GDK_2BUTTON_PRESS	  5  
#define   GDK_3BUTTON_PRESS	  6  
#define   GDK_BUTTON_RELEASE	  7  
#define   GDK_KEY_PRESS		  8  
#define   GDK_KEY_RELEASE	  9  
#define   GDK_ENTER_NOTIFY	  10  
#define   GDK_LEAVE_NOTIFY	  11  
#define   GDK_FOCUS_CHANGE	  12  
#define   GDK_CONFIGURE		  13  
#define   GDK_MAP		  14  
#define   GDK_UNMAP		  15  
#define   GDK_PROPERTY_NOTIFY	  16  
#define   GDK_SELECTION_CLEAR	  17  
#define   GDK_SELECTION_REQUEST   18  
#define   GDK_SELECTION_NOTIFY	  19  
#define   GDK_PROXIMITY_IN	  20  
#define   GDK_PROXIMITY_OUT	  21  
#define   GDK_DRAG_LEAVE          23  
#define   GDK_DRAG_MOTION         24  
#define   GDK_DRAG_STATUS         25  
#define   GDK_DROP_START          26  
#define   GDK_DROP_FINISHED       27  
#define   GDK_CLIENT_EVENT	  28  
#define   GDK_VISIBILITY_NOTIFY   29  
#define   GDK_NO_EXPOSE		  30  
#define   GDK_SCROLL              31  
#define   GDK_WINDOW_STATE        32  
#define   GDK_SETTING             33

/*
 * Enum GdkEventMask -------------------------------------------
 */
#define GDK_EXPOSURE_MASK            DESPLAZA_LEFT( 1 , 1  )
#define GDK_POINTER_MOTION_MASK      DESPLAZA_LEFT( 1 , 2  )
#define GDK_POINTER_MOTION_HINT_MASK DESPLAZA_LEFT( 1 , 3  )
#define GDK_BUTTON_MOTION_MASK       DESPLAZA_LEFT( 1 , 4  )
#define GDK_BUTTON1_MOTION_MASK      DESPLAZA_LEFT( 1 , 5  )
#define GDK_BUTTON2_MOTION_MASK      DESPLAZA_LEFT( 1 , 6  )
#define GDK_BUTTON3_MOTION_MASK      DESPLAZA_LEFT( 1 , 7  )
#define GDK_BUTTON_PRESS_MASK        DESPLAZA_LEFT( 1 , 8  )
#define GDK_BUTTON_RELEASE_MASK      DESPLAZA_LEFT( 1 , 9  )
#define GDK_KEY_PRESS_MASK           DESPLAZA_LEFT( 1 , 10 )
#define GDK_KEY_RELEASE_MASK         DESPLAZA_LEFT( 1 , 11 )
#define GDK_ENTER_NOTIFY_MASK        DESPLAZA_LEFT( 1 , 12 )
#define GDK_LEAVE_NOTIFY_MASK        DESPLAZA_LEFT( 1 , 13 )
#define GDK_FOCUS_CHANGE_MASK        DESPLAZA_LEFT( 1 , 14 )
#define GDK_STRUCTURE_MASK           DESPLAZA_LEFT( 1 , 15 )
#define GDK_PROPERTY_CHANGE_MASK     DESPLAZA_LEFT( 1 , 16 )
#define GDK_VISIBILITY_NOTIFY_MASK   DESPLAZA_LEFT( 1 , 17 )
#define GDK_PROXIMITY_IN_MASK        DESPLAZA_LEFT( 1 , 18 )
#define GDK_PROXIMITY_OUT_MASK       DESPLAZA_LEFT( 1 , 19 )
#define GDK_SUBSTRUCTURE_MASK        DESPLAZA_LEFT( 1 , 20 )
#define GDK_SCROLL_MASK              DESPLAZA_LEFT( 1 , 21 )
#define GDK_ALL_EVENTS_MASK          0x3FFFFE

/*
 * Enum GdkModifierType -------------------------------------------
 */
#define GDK_SHIFT_MASK    DESPLAZA_LEFT( 1 , 0 ) 
#define GDK_LOCK_MASK	  DESPLAZA_LEFT( 1 , 1 )
#define GDK_CONTROL_MASK  DESPLAZA_LEFT( 1 , 2 )
#define GDK_MOD1_MASK	  DESPLAZA_LEFT( 1 , 3 )
#define GDK_MOD2_MASK	  DESPLAZA_LEFT( 1 , 4 )
#define GDK_MOD3_MASK	  DESPLAZA_LEFT( 1 , 5 )
#define GDK_MOD4_MASK	  DESPLAZA_LEFT( 1 , 6 )
#define GDK_MOD5_MASK	  DESPLAZA_LEFT( 1 , 7 )
#define GDK_BUTTON1_MASK  DESPLAZA_LEFT( 1 , 8 )
#define GDK_BUTTON2_MASK  DESPLAZA_LEFT( 1 , 9 )
#define GDK_BUTTON3_MASK  DESPLAZA_LEFT( 1 , 10 )
#define GDK_BUTTON4_MASK  DESPLAZA_LEFT( 1 , 11 )
#define GDK_BUTTON5_MASK  DESPLAZA_LEFT( 1 , 12 )
 /* The next few modifiers are used by XKB, so we skip to the end.
  * Bits 16 - 28 are currently unused, but will eventually
  * be used for "virtual modifiers". Bit 29 is used internally.
  */
#define GDK_RELEASE_MASK  DESPLAZA_LEFT( 1 , 30 )
#define GDK_MODIFIER_MASK nOr( GDK_RELEASE_MASK , 0x1fff )

/*
 * Enum GtkAccelFlags; -------------------------------------------
 */
#define GTK_ACCEL_VISIBLE DESPLAZA_LEFT( 1 , 0 ) 
#define GTK_ACCEL_LOCKED  DESPLAZA_LEFT( 1 , 1 ) 
#define GTK_ACCEL_MASK    0x07


