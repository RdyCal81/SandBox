


; 200 PPR, Pulses Per Revolution
; 1.5 RPI, Revolution per Inch.

; Max 19.5"
; Slow at 17"
; Max Pulses = 19.5 * ( 200 / 1.5 ) = 26000
; Slow Pulses = 2.5 * ( 200 / 1.5 ) = 334 (333.33333)
; 340 = 2.55"
; 348 = 2.61"


MAX_TABLE_MOVE          equ     D'2600'
SLOW_PULSES             equ     D'348'                    ; Must a power of ten number

BK_SLOW_SPOT            equ     MAX_TABLE_MOVE - SLOW_PULSES


Dev_Freq		EQU		D'12000000'
					; N_0009

MOTOR_TIME_OUT		equ	D'6'	; Motor timeout in Seconds.
WARM_UP_TIME		equ	D'15'	; Warm up time in seconds, 3 digits
					; only please......
					; N_0009

				; (dt.1)
MAXIMUM_TIME		equ	D'999'	; The Maximum time that can be entered.

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







; 14 is slow speed;
; 3 is fast... speed



MAX_TABLE_SPEED         equ     D'256' - D'47'
MIN_TABLE_SPEED         equ     D'256' - D'221'

TEST1                   equ     ((MAX_TABLE_SPEED - MIN_TABLE_SPEED) / D'20')
TEST2                   equ     (7 * ((MAX_TABLE_SPEED - MIN_TABLE_SPEED) / D'20'))

TABLE_SPEED_05          equ     MIN_TABLE_SPEED + ((D'1' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'20')    
TABLE_SPEED_10          equ     MIN_TABLE_SPEED + ((D'2' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'20')    
TABLE_SPEED_15          equ     MIN_TABLE_SPEED + ((D'3' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'20')    
TABLE_SPEED_20          equ     MIN_TABLE_SPEED + ((D'4' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'20')    
TABLE_SPEED_25          equ     MIN_TABLE_SPEED + ((D'5' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'20')    
TABLE_SPEED_30          equ     MIN_TABLE_SPEED + ((D'6' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'20')    
TABLE_SPEED_35          equ     MIN_TABLE_SPEED + ((D'7' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'20')    
TABLE_SPEED_40          equ     MIN_TABLE_SPEED + ((D'8' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'20')    
TABLE_SPEED_45          equ     MIN_TABLE_SPEED + ((D'9' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'20')    
TABLE_SPEED_50          equ     MIN_TABLE_SPEED + ((D'10' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'20')   
TABLE_SPEED_55          equ     MIN_TABLE_SPEED + ((D'11' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'20')   
TABLE_SPEED_60          equ     MIN_TABLE_SPEED + ((D'12' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'20')   
TABLE_SPEED_65          equ     MIN_TABLE_SPEED + ((D'13' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'20')   
TABLE_SPEED_70          equ     MIN_TABLE_SPEED + ((D'14' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'20')   
TABLE_SPEED_75          equ     MIN_TABLE_SPEED + ((D'15' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'20')   
TABLE_SPEED_80          equ     MIN_TABLE_SPEED + ((D'16' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'20')   
TABLE_SPEED_85          equ     MIN_TABLE_SPEED + ((D'17' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'20')   
TABLE_SPEED_90          equ     MIN_TABLE_SPEED + ((D'18' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'20')   
TABLE_SPEED_95          equ     MIN_TABLE_SPEED + ((D'19' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'20')   
                                                                                                            
                                                                                                            
TEST_01                 equ     ( SLOW_PULSES * D'1' ) / D'10'
TEST_02                 equ     ( SLOW_PULSES * D'2' ) / D'10'
TEST_03                 equ     ( SLOW_PULSES * D'3' ) / D'10'
TEST_04                 equ     ( SLOW_PULSES * D'4' ) / D'10'
TEST_05                 equ     ( SLOW_PULSES * D'5' ) / D'10'
TEST_06                 equ     ( SLOW_PULSES * D'6' ) / D'10'
TEST_07                 equ     ( SLOW_PULSES * D'7' ) / D'10'
TEST_08                 equ     ( SLOW_PULSES * D'8' ) / D'10'
TEST_09                 equ     ( SLOW_PULSES * D'9' ) / D'10'


MOVE_2_HOME_SPEED       equ     TABLE_SPEED_20






TABLE_SPEED_73          equ     MIN_TABLE_SPEED + ((D'73' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'100')
TABLE_SPEED_75a         equ     MIN_TABLE_SPEED + ((D'75' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'100')
    if ( TABLE_SPEED_75 != TABLE_SPEED_75a )
       MESSG   "RWarning: TABLE_SPEED_75 != TABLE_SPEED_75a"
    endif


TABLE_SPEED_82          equ     MIN_TABLE_SPEED + ((D'82' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'100')
TABLE_SPEED_80a          equ     MIN_TABLE_SPEED + ((D'80' * (MAX_TABLE_SPEED - MIN_TABLE_SPEED)) / D'100')
    if ( TABLE_SPEED_80 != TABLE_SPEED_80a )
       MESSG   "RWarning: TABLE_SPEED_80 != TABLE_SPEED_80a"
    endif



;                             Values are in your time, not my (*2) time...  The real period..
;         slowest

;23     0%  ( 1 / ( 187,500 / (256 -  35) ) / 2 ) =  2.347ms 
;2B     5%  ( 1 / ( 187,500 / (256 -  43) ) / 2 ) =
;34    10%  ( 1 / ( 187,500 / (256 -  52) ) / 2 ) =
;3D    15%  ( 1 / ( 187,500 / (256 -  61) ) / 2 ) =
;45    20%  ( 1 / ( 187,500 / (256 -  69) ) / 2 ) =
;4E    25%  ( 1 / ( 187,500 / (256 -  78) ) / 2 ) =
;57    30%  ( 1 / ( 187,500 / (256 -  87) ) / 2 ) =
;5F    35%  ( 1 / ( 187,500 / (256 -  95) ) / 2 ) =
;68    40%  ( 1 / ( 187,500 / (256 - 104) ) / 2 ) =
;71    45%  ( 1 / ( 187,500 / (256 - 113) ) / 2 ) =
;7A    50%  ( 1 / ( 187,500 / (256 - 122) ) / 2 ) =
;82    55%  ( 1 / ( 187,500 / (256 - 130) ) / 2 ) =
;8B    60%  ( 1 / ( 187,500 / (256 - 139) ) / 2 ) =
;94    65%  ( 1 / ( 187,500 / (256 - 148) ) / 2 ) =
;9C    70%  ( 1 / ( 187,500 / (256 - 156) ) / 2 ) =
;A2    75%  ( 1 / ( 187,500 / (256 - 162) ) / 2 ) =
;B1    80%  ( 1 / ( 187,500 / (256 - 177) ) / 2 ) =
;B6    85%  ( 1 / ( 187,500 / (256 - 182) ) / 2 ) =
;BF    90%  ( 1 / ( 187,500 / (256 - 191) ) / 2 ) =
;C8    95%  ( 1 / ( 187,500 / (256 - 200) ) / 2 ) =
;D1   100%  ( 1 / ( 187,500 / (256 - 209) ) / 2 ) =  0.501333ms

;          fastest

