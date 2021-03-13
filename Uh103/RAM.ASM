


RAM_STRT	equ	0x20

TEMP1          equ	RAM_STRT + 0x00
Motor_Extra    	equ	RAM_STRT + 0x01
SAVE_W		equ	RAM_STRT + 0x02
SAVE_S		equ	RAM_STRT + 0x03
INT_WL		equ	RAM_STRT + 0x04
INT_WH		equ	RAM_STRT + 0x05
KeyDebounce     equ     RAM_STRT + 0x06
FLAGS		equ	RAM_STRT + 0x07
MSD		equ	RAM_STRT + 0x08
LSD		equ	RAM_STRT + 0x09
LCD_VAL		equ	RAM_STRT + 0x0A
L_PORTD		equ	RAM_STRT + 0x0B
LCD_LOOP	equ	RAM_STRT + 0x0C
LCD_ADD         equ	RAM_STRT + 0x0D
TEMP		equ     RAM_STRT + 0x0E


ANS_H		equ	RAM_STRT + 0x0F
ANS_L		equ	RAM_STRT + 0x10
QUO_H		equ	RAM_STRT + 0x11
QUO_L		equ	RAM_STRT + 0x12
DIV_H		equ	RAM_STRT + 0x13
DIV_L		equ	RAM_STRT + 0x14
TMP_H		equ	RAM_STRT + 0x15
TMP_L		equ	RAM_STRT + 0x16

TableCnt	equ	RAM_STRT + 0x17
;TableCnt + 1	equ	RAM_STRT + 0x18



PrevKeyRead	equ	RAM_STRT + 0x19
MotorSpeed	equ	RAM_STRT + 0x1A

T_1MS		equ	RAM_STRT + 0x1B

        if ( NEW_TIME_DISPLAY )
T_MIN_MIN	equ	RAM_STRT + 0x1C
T_MIN_SEC	equ     RAM_STRT + 0x1D
T_MIN_TENTH     equ     RAM_STRT + 0x1E
T_2MIN_CMP	equ	RAM_STRT + 0x1F

        else
T_2MIN_L	equ	RAM_STRT + 0x1C
;T_2SEC_M	equ     RAM_STRT + 0x1D
;T_2SEC_H       equ     RAM_STRT + 0x1E
T_2MIN_CMP	equ	RAM_STRT + 0x1F
        endif



AppKeyVal      	equ	RAM_STRT + 0x20

MotorSpeedIdx  	equ	RAM_STRT + 0x21
StartDebounce	equ	RAM_STRT + 0x22


STATUS_1	equ	RAM_STRT + 0x23
STATUS_2       	equ	RAM_STRT + 0x24

Debounce	equ	RAM_STRT + 0x25
;Debounce+1                        0x26


TIME_FLAGS      equ	RAM_STRT + 0x27

Speed_Idx       equ     RAM_STRT + 0x28


TempTest        equ     RAM_STRT + 0x29

RESET_VAL       equ     RAM_STRT + 0x2A

LCD_Idx         equ     RAM_STRT + 0x2B


        if ( NEW_TIME_DISPLAY )
T_MIN_MS	equ	RAM_STRT + 0x2C
        endif

SafeSpeedVal	equ	RAM_STRT + 0x2D




;Speed_Val       equ     RAM_STRT + 0x28
;               equ     RAM_STRT + 0x29 + 1
;               equ     RAM_STRT + 0x2A + 2
;               equ     RAM_STRT + 0x2B + 3
;               equ     RAM_STRT + 0x2C + 4
;               equ     RAM_STRT + 0x2D + 5
;               equ     RAM_STRT + 0x2E + 6
;               equ     RAM_STRT + 0x2F + 7
;               equ     RAM_STRT + 0x30 + 8
;               equ     RAM_STRT + 0x31 + 9



;Speed_Time      equ     RAM_STRT + 0x32
;               equ     RAM_STRT + 0x33 + 1
;               equ     RAM_STRT + 0x34 + 2
;               equ     RAM_STRT + 0x35 + 3
;               equ     RAM_STRT + 0x36 + 4
;               equ     RAM_STRT + 0x37 + 5
;               equ     RAM_STRT + 0x38 + 6
;               equ     RAM_STRT + 0x39 + 7
;               equ     RAM_STRT + 0x3A + 8
;               equ     RAM_STRT + 0x3B + 9
