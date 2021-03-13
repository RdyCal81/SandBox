
;;;	nolist

NULL		equ	0



; Port AAAAA	---------------------------------------------------------------
; 0 1 2 3 4	Columns

SW_STANDBY_ADD	equ	PORTA
SW_STANDBY_BIT	equ	5


; Port BBBBB	---------------------------------------------------------------
; 0 N/A

SW_TIME_ADD	equ	PORTB
SW_TIME_BIT	equ	1

SH_OUT_ADD	equ	PORTB
SH_OUT_BIT	equ	2

SW_START_ADD	equ	PORTB
SW_START_BIT	equ	3

; 4 5 6 7	N/A

; Port CCCCC	---------------------------------------------------------------
N2_ADD		equ	PORTC
N2_BIT		equ	0

UV_LAMP     equ (PORTC * 8) + 2


    if ( GOT_SHUTTER )
DOOR_L_ADD	equ	PORTC
DOOR_L_BIT	equ	2
DOOR_SW		equ	(PORTC * 8) + 2
    endif


SH_DIR_ADD	equ	PORTC
SH_DIR_BIT	equ	3

DOOR_IN_ADD	equ	PORTC		;102 DR_IN_ADD
DOOR_IN_BIT	equ	4		;102 DR_IN_BIT
DOOR_IN     equ (PORTC * 8) + 4

;DR_OUT_ADD	equ	PORTC
;DR_OUT_BIT	equ	5

; 6 = LCD RS
; 7 = LCD E
; Port DDDDD	---------------------------------------------------------------
    if ( GOT_SHUTTER )
SH_MOTOR_ADD	equ	PORTD
SH_MOTOR_BIT	equ	0
    endif


SW_ABORT_ADD	equ	PORTD		; Was SW_INOUT_ADD
SW_ABORT_BIT	equ	1		; Was SW_INOUT_BIT

;DR_MOTOR_ADD	equ	PORTD
;DR_MOTOR_BIT	equ	2

LED_ADD		equ	PORTD
LED_BIT		equ	3


; Port EEEEE	---------------------------------------------------------------
; 0 1	Rows
SH_IN_ADD	equ	PORTE
SH_IN_BIT	equ	2



