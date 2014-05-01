/*  $Id: fiscal.ch,v 1.2 2009/02/10 20:51:00 riztan Exp $ */
/*
 * Constantes para manejo de protocolo fiscal.
 * compatible con:
 * HASAR
 * Samsung Bixolon
 * Aclas
 *
 * (c)2009 Riztan Gutierrez
 */

#define  STR_STX                "02"
#define  STR_ENQ                "05"
#define  STR_ETX                "03"
#define  STR_EOT                "04"
#define  STR_ACK                "06"
#define  STR_NAK                "15"
#define  STR_ETB                "17"
#define  STR_LRC(value)         FIS_StrXOR(value, STR_ETX)

#define  STX                    HexToStr( STR_STX )
#define  ENQ                    HexToStr( STR_ENQ )
#define  ETX                    HexToStr( STR_ETX )
#define  EOT                    HexToStr( STR_EOT )
#define  ACK                    HexToStr( STR_ACK )
#define  NAK                    HexToStr( STR_NAK )
#define  ETB                    HexToStr( STR_ETB )
#define  LRC(value)             HexToStr( STR_LRC( value ) )



