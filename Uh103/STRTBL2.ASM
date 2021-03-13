	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : Tables        					³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ After many hours of testing and failing I have come to the   ³
	;³ conclusing that all tables need to be on either page 0 or 1  ³
	;³ The Program counter becomes very messed up on page 2.  This  ³
	;³ does not sound correct, but if you have any problems with    ³
	;³ tables, put them on page 0 or 1.                             ³
	;³ The problem is with the instruction "DDWF PCL, F" -- The     ³
	;³ program counter gets some random number.                     ³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ Hist : 03/31/04 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

        if ( ORG_1 )
        org     0x100
	endif

	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : String1Table						³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/04/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
String2Table:
                MOVLW   HIGH (String2Table)  ; Ensure that the PCLATH high has the 
                MOVWF   PCLATH              ;   correct value

		movf	LCD_LOOP, W		; Get the Index into the string..
        	addwf	PCL, F		; Determine Offset into table
Table2Start:
;                       "0123456789abcdef"

           if ( SHORT_TEXT )
Str2_6:          DT      "H", NULL
           else
;                        "0123456789abcdef"
Str2_6:          DT      "  Finding Home!", NULL
	   endif

FH_STR       equ     Str2_6  - Table2Start


;  /---------------------------------------\
;  |            ABORT_ACTIVE               |
;  \---------------------------------------/
;                       "0123456789abcdef"
        if      ( ABORT_ACTIVE )
           if ( SHORT_TEXT )
Str2_1:          DT      "A", NULL
Str2_2:          DT      "PK", NULL
           else
;                        "0123456789abcdef"
Str2_1:          DT      "     Abort!", NULL
Str2_2:          DT      " Press Any Key.", NULL
	   endif

ABORT_STR       equ     Str2_1  - Table2Start
PAK_STR         equ     Str2_2  - Table2Start
        endif	



;  /---------------------------------------\
;  |              STAND_BY                 |
;  \---------------------------------------/
;                       "0123456789abcdef"
        if ( STAND_BY )
           if ( SHORT_TEXT )
Str2_3:		DT	"SB", NULL
Str2_4:         DT      "BN", NULL   
Str2_5:         DT      "BF", NULL   

Str2_7:         DT      "a1", NULL
Str2_8:         DT      "a2", NULL
Str2_9:         DT      "a3", NULL
Str2_10:        DT      "a4", NULL
Str2_11:         DT      "C", NULL


           else
;                       "0123456789abcdef"
Str2_3:		DT	"     STANDBY", NULL
Str2_4:         DT      " Cooling Fan ON", NULL   
Str2_5:         DT      " Cooling Fan OFF", NULL

Str2_7:         DT      "   Temperature", NULL
Str2_8:         DT      "       OK", NULL
Str2_9:         DT      "  Press Any Key", NULL
Str2_10:        DT      "    to Restart", NULL
Str2_11:         DT      "     Cooling", NULL
    
	   endif

Str2_25:          DT      "Standby Confirm?", NULL
Str2_26:          DT      "  Press Enter", NULL

SBCON_STR       equ     Str2_25  - Table2Start
ENTER_STR       equ     Str2_26  - Table2Start

STD_STR		equ	Str2_3  - Table2Start
BON_STR		equ	Str2_4  - Table2Start
BOF_STR		equ	Str2_5  - Table2Start
COOL_STR	equ	Str2_11 - Table2Start



TEMPER_STR      equ     Str2_7  - Table2Start
OK_STR          equ     Str2_8  - Table2Start

PRESS_STR       equ     Str2_9  - Table2Start
TORES_STR       equ     Str2_10 - Table2Start

        endif

String2TableEnd:
    if (( String2Table & 0xFF00 ) != ( String2TableEnd & 0xFF00 ))
       MESSG   "RWarning: String2Table Boundry."
    endif





        if ( SPEED_CONFIG )
SpeedKeyHit:
                MOVLW   HIGH (SpeedKeyHit)  ; Ensure that the PCLATH high has the 
                MOVWF   PCLATH              ;   correct value

        	movf    AppKeyVal, W
	        addwf	PCL, F		; Determine Offset into table

                jmp     JumpOutOfSpeedConfig    ;Key_0: Enter
                return                          ;Key_1: N/A
                return                          ;Key_2: Speed config
                return                          ;Key_3: N/A 
                return                          ;Key_4: Calibration 
                jmp     SpeedFaster             ;Key_5: Fast  
                return                          ;Key_6: N/A 
                return                          ;Key_7: Stand By 
                return                          ;Key_8: N/A 
                jmp     SpeedSlower             ;Key_9: Slow 
SpeedKeyHitEnd:
    if (( SpeedKeyHit & 0xFF00 ) != ( SpeedKeyHitEnd & 0xFF00 ))
       MESSG   "RWarning: SpeedKeyHit Boundry."
    endif
        endif

