
Dev_Freq		EQU		D'12000000'
					; N_0009

WAIT_BTWN_N2_AND_SHUT	equ	D'7000'; N2 for xSeconds befor Opening shutter


MOTOR_TIME_OUT		equ	D'6'	; Motor timeout in Seconds.
WARM_UP_TIME		equ	D'15'	; Warm up time in seconds, 3 digits
					; only please......
					; N_0009
MAXIMUM_TIME		equ	D'999'	; The Maximum time that can be entered.
                                ; Changed to 999 from 128, Ver. 0.252 02/24/02 ', NULL
IN_OUT_MAXIMUM		equ	D'128'	; The Maximum time that can be entered.
START_SW_TIME		equ	D'2000'	; MilliSeconds after Motor Error.


SW_DEBOUNCE		equ	D'40'	; Switch debounce time in 1ms..
STAND_BY_SW_TIME	equ	D'2000'	; Stand By Switch in ms.....




LCD_DELAY		equ	d'160'	; Loop counter after an LCD instruction
					; was 40, but had intermittant errors.
					; N_0006 = 160

BEEP_OFF_TIME		equ	2	; N_0003
BEEP_ON_TIME		equ	2	; N_0003


; 4 * 1000: the 1000 is 1/1000 or a 1ms timer interrupt...
;	  : the    4 is the clock / 4, a PIC thing...
TIME_VAL	equ	( (Dev_Freq / ( D'4' * D'1000' )) ^ 0xFFFF )
PWM_PERIOD	equ	(  Dev_Freq / ( D'4' * D'1000' * D'16' )   )


    if ( PWM_PERIOD & 0xFF00 )
       MESSG   "RWarning: PWM PR2 value is out of range."
    endif

