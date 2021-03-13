
TablesStart:

	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : LCD_iTable						³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/04/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LCD_iTable:	addwf	PCL, F              ; Determine Offset into table
		DT	FUNC, FUNC, FUNC, DISPOFF, CLRLCD
		DT	ENTRMOD, CURSOFF, LCD1LINE, H'40'
		DT	NULL

	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : StringTable						³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/04/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
StringTable:	addwf	PCL, F		; Determine Offset into table
TableStart:
Str1:		DT	"WARMING UP", NULL
Str2:		DT	"READY", NULL
Str3:		DT	"    STANDBY", NULL		; N_0001
Str4:		DT	"EXPOSURE TIME", NULL
Str5:		DT	"SET TIME", NULL
Str6:		DT	"MOTOR OVERLOAD", NULL
Str8:		DT	"SHUTTER JAMMED", NULL
Str9:		DT	"     UH102", NULL		; N_0001
Str10:		DT	"  DOOR OPEN!", NULL
Str11:		DT	"PREEXPOSE PURGE", NULL
Str12:		DT	"NOT READY", NULL

WU_STR		equ	Str1 - TableStart
RDY_STR		equ	Str2 - TableStart
STD_STR		equ	Str3 - TableStart
EXP_STR		equ	Str4 - TableStart
SET_STR		equ	Str5 - TableStart
MOV_STR		equ	Str6 - TableStart
SJM_STR		equ	Str8 - TableStart
UH1_STR		equ	Str9 - TableStart

DOR_STR		equ	Str10 - TableStart
PRE_EXP		equ	Str11 - TableStart
NOT_RDY		equ	Str12 - TableStart


	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : AsciiTable						³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/08/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AsciiTable:	andlw	0x3F
		addwf	PCL, F		; Determine Offset into table
		DT	"0123456789abcdef"
		DT	"ghijklmnopqrstuv"
		DT	"wxyzABCDEFGHIJKL"
		DT	"MNOPQRSTUVWXYZ&*"

TablesEnd:

    if ( ( TablesStart & 0xFF00 ) != ( TablesEnd & 0xFF00 ) )
       MESSG   "RWarning: Tables Boundry."
    endif

