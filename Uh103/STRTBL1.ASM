        ;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : String1Table						³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/04/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
String1Table:
                MOVLW   HIGH (String1Table)  ; Ensure that the PCLATH high has the 
                MOVWF   PCLATH              ;   correct value

		movf	LCD_LOOP, W		; Get the Index into the string..
        	addwf	PCL, F		; Determine Offset into table
TableStart:
;                       "0123456789abcdef"

        if      ( SHORT_TEXT )

;                       "0123456789abcdef"
Str1:		DT	"WU", NULL
Str2:		DT	"R", NULL
Str4:		DT	"CS", NULL
Str5:		DT	"HT", NULL
Str6:		DT	"HO", NULL
Str7:		DT	"LT", NULL
Str8:		DT	"SNC", NULL
Str9:		DT	"V", NULL 
Str10:          DT      "E", NULL
Str11:		DT	"DO", NULL
        if ( YES == NO )
Str12:		DT	"R1", NULL
Str13:          DT      "Ok", NULL
        endif

Str18:          DT      "SNO", NULL
Str19:          DT      "SNC", NULL
Str20:          DT      "MTO", NULL
;Str21:          DT      "BE", NULL
Str22:          DT      "C", NULL
                if ( !NO_START_TIMER )
            include <UH103.VER>
                endif
        else

;                       "0123456789abcdef"
Str1:		DT	"   WARMING UP", NULL
Str2:		DT	"     READY", NULL
Str4:		DT	"Curing Speed", NULL
Str5:		DT	"    OVER TEMP", NULL
Str6:		DT	"   HATCH OPEN", NULL
Str7:		DT	"Temp Limit Exced", NULL
Str8:		DT	"  Calibration", NULL
Str9:		DT	"   UH103 Ver.", NULL 
Str10:          DT      "     ERROR!", NULL
Str11:		DT	"Door not CLosed!", NULL  
;                       "0123456789abcdef"


;                       "0123456789abcdef"
Str18:          DT      "Shut Not Open", NULL
Str19:          DT      "Shut Not Closed", NULL
Str20:          DT      "Motor TimeOut", NULL
;Str21:          DT      " Table At Back", NULL
Str22:          DT      "     Curing", NULL
                if ( !NO_START_TIMER )
                    include <UH103.VER>
                endif
        endif

WU_STR		equ	Str1   - TableStart
RDY_STR		equ	Str2   - TableStart
CS_STR		equ	Str4   - TableStart
HIT_STR		equ	Str5   - TableStart
HOP_STR		equ	Str6   - TableStart
LOT_STR		equ	Str7   - TableStart
CAL_STR         equ     Str8   - TableStart
SJM_STR		equ	Str19  - TableStart
UH1_STR		equ	Str9   - TableStart
ERR_STR		equ	Str10  - TableStart
DNC_STR		equ	Str11  - TableStart
        if ( !NO_START_TIMER )
VER_STR         equ     (StrVer - TableStart) + 4
        endif

        if ( YES == NO )
RC1_STR         equ     Str12  - TableStart
OK_STR          equ     Str13  - TableStart
        endif
	

SNO_STR         equ     Str18  - TableStart 
SNC_STR	        equ     Str19  - TableStart 
MTO_STR         equ     Str20  - TableStart 
;TAB_STR         equ     Str21  - TableStart 
CUR_STR         equ     Str22  - TableStart 









        if      ( SHORT_TEXT )
;                       "0123456789abcdef"
Str23:          DT      "TB", NULL
        else
;                       "0123456789abcdef"
Str23:          DT      "Table Back Sens", NULL
        endif
TBS_STR         equ     Str23  - TableStart 






	

String1TableEnd:
    if (( String1Table & 0xFF00 ) != ( String1TableEnd & 0xFF00 ))
       MESSG   "RWarning: String1Table Boundry."
    endif

