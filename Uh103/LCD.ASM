
	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ LCD Addresses. ³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LCD_DATAP	EQU     PORTD           ; The LCD data is on the lower 4-bits


	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ LCD Equates. ³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FUNC		EQU	B'00101000'
ENTRMOD		EQU	B'00000110'
DISPOFF		EQU	B'00001000'
CURSOFF		EQU	B'00001100'
CURSON		EQU	B'00001110'
CLRLCD		EQU	B'00000001'
;;CURSLFT		EQU	010
;;CURSRGT		EQU	014
;;MARKADD		EQU	0C7
LCD1LINE	equ	H'80'
LCD2LINE	equ	H'C0'
LCDCG_RAM	equ	H'40'


	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Function : LCD_Init						³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ Input    : 							³
	;³ Output   :							³
	;³ Destroys : Alot						³
	;³ History  :							³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
InitLCD:	clr	LCD_E           	; LCD Not enabled.
		clr	LCD_RS          	; Select Command, !Data.

		movlw	B'00110000'		; Function Set, Data len = 8.
		movwf	LCD_VAL			;   8 bits just for now...
		movlw	D'20'			; Wait 20ms.
		call	Wait_LCD_1

		movlw	B'00110000'		; Function Set, Data len = 8.
		movwf	LCD_VAL			;   8 bits just for now...
		movlw	D'6'			; Wait 6 more ms.
		call	Wait_LCD_1

		movlw	B'00110000'		; Function Set, Data len = 8.
		movwf	LCD_VAL			;   8 bits just for now...
		movlw	D'2'			; And 2ms more.
		call	Wait_LCD_1

		movlw	B'00100000'		; Function Set, Data len = 4.
		movwf	LCD_VAL			;  From now on 4 bit data.
		movlw	D'2'			;
		call	Wait_LCD_1

	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ From now on all Data is 4 bits and must be written ³
	;³ High nybble first, the low nybble.		      ³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		clrw				; Start at Zero..
		movwf	LCD_LOOP

LCD_LOOP_CMD:	movlw	D'2'			;
		movwf	MSD	                ; Use MSD and LSD Registers to Initilize LCD
		clr	LCD_E	                ; LCD Not enabled.
		clr	LCD_RS	                ; Select Command, !Data.
WaitLcLoop:	jnb     LCD_TIME_FLAG, WaitLcLoop
		clr     LCD_TIME_FLAG
		decfsz	MSD, F
		jmp	WaitLcLoop
		
	        call    LCD_iTable		; Get the Indexed command..
	
		iorlw	NULL
	        btfsc	STATUS, Z
		jmp     NowCG_RAM               ; Jump out if end of CommandTable
		call	LCD_Command
		incf	LCD_LOOP, F
		jmp	LCD_LOOP_CMD
NowCG_RAM:
        if ( NO_GRAPH )
	        return
        else
		clrw				; Start at Zero..
		movwf	LCD_LOOP

CGLoop:         call    CG_iTable		; Get the Indexed command..
		call	LCD_Data
		incf	LCD_LOOP, F
		movf	LCD_LOOP, W
		xorlw	D'40'
	        btfsc	STATUS, Z
                return
		jmp	CGLoop
	endif








	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : ClearLCD						³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/07/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ClearLCD:
;       	movwf	LCD_LOOP
;		clrw
;		movwf	LCD_ADD
		movlw	CLRLCD
		call	LCD_Command
		movlw	d'3'		        ; Wait for 3 additional ms for
					        ; a CLRLCD Command..
		jmp	Wait


LCD_ln1:	movlw	LCD1LINE
                jmp     LCD_Cmd

LCD_ln2:	movlw	LCD2LINE
LCD_Cmd:
		call	LCD_Command
		jmp	LDelay			; N_0006, N_0012

LCD_Digit:      addlw   '0'

LCD_Data:	setb	LCD_RS                  ; Select Data, !Command.
		jmp	LCD_write

LCD_Command:	clr	LCD_RS          	; Select Command, !Data.

LCD_write:	clr     LCD_E	                ; LCD Not enabled.

		movwf	TEMP
		movf	L_PORTD, W
		andlw	B'00001111'
		movwf	L_PORTD
		movf	TEMP, W
		andlw	B'11110000'
		iorwf	L_PORTD, W
		movwf	LCD_DATAP
		setb    LCD_E
		nop			; N_0006
		nop			; N_0006
		nop			; N_0006
		nop			; N_0006
		nop
		nop
		nop			; N_0002
		nop			; was only 2 nop's, was intermittant
		nop
		nop
		clr     LCD_E

		nop
		nop

		swapf	TEMP, W
		andlw	B'11110000'
		iorwf	L_PORTD, W
		movwf	LCD_DATAP

BobbleEnable:	setb    LCD_E
		nop			; N_0006
		nop			; N_0006
		nop			; N_0006
		nop			; N_0006
		nop
		nop			; N_0002
		nop			; was only 2 nop's, was intermittant
		nop
		nop
		clr     LCD_E

LDelay:		movlw	LCD_DELAY	; Wait for 'x' uS before returning.
		movwf	MSD		; N_0002
BobbleDelay:	decfsz	MSD, F
		jmp	BobbleDelay
		return


        if      YES == NULL
DisplayKey:
                movwf   TEMP1
		xorlw   D'10'
		jnz     DT_01
		return
DT_01:
		movlw	LCD1LINE + 2
		call	LCD_Command
		movlw   NULL
		movwf	QUO_H
		movf	TEMP1, W
		jmp     DT_02
        endif		
;StayHere:		
;		jmp     StayHere

DisplayAbsKey:
		movlw	LCD1LINE + 5
		call	LCD_Command
		movlw   NULL
		movwf	QUO_H
		movf	PrevKeyRead, W
		call    DT_02
	                
		movlw   ' '
		call	LCD_Data

		movlw   NULL
		movwf	QUO_H
		movf	AppKeyVal, W
		jmp     DT_02

        if      ( NO_TEXT )
DisplayA_Num:	
		movf	LCD_LOOP, W		; Get the Index into the string..
		movwf	QUO_L
		clrw    
		movwf	QUO_H
        endif	
Display3DigitNumber:
		call	Devide_100
		movf	ANS_L, W
		call    DontShowZero

		movf	TMP_H, W
		movwf	QUO_H
		movf	TMP_L, W
		movwf	QUO_L
		call	Devide_10
		movf	ANS_L, W
		call    DontShowZero

		movf	TMP_L, W
		jmp     LCD_Digit

DisplayTime:
		movlw	LCD2LINE + 2
		call	LCD_Command

        if ( NEW_TIME_DISPLAY )
	else
		movf	T_2MIN_L + 2, W
		movwf	QUO_H
		movf	T_2MIN_L + 1, W
		movwf	QUO_L
		call    Display3DigitNumber
	
        if ( 0 )
		movlw   ' '
		call    LCD_Data


		movlw   NULL
		movwf	QUO_H
		movf	T_1MS, W
		movwf	QUO_L
		call	Devide_100
		movf	ANS_L, W
		call    LCD_Digit

		movf	TMP_H, W
		movwf	QUO_H
		movf	TMP_L, W
		movwf	QUO_L
		call	Devide_10
		movf	ANS_L, W
		call    LCD_Digit

		movf	TMP_L, W
		call    LCD_Digit

        endif		
		movlw   ' '
		call    LCD_Data


		movlw   NULL
		movwf	QUO_H
		movf	TableCnt + 1, W
	endif
DT_02:
		movwf	QUO_L
		call	Devide_100
		movf	ANS_L, W
		call    LCD_Digit

		movf	TMP_H, W
		movwf	QUO_H
		movf	TMP_L, W
		movwf	QUO_L
		call	Devide_10
		movf	ANS_L, W
		call    LCD_Digit

		movf	TMP_L, W
		jmp     LCD_Digit











	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : String functions that use Table 1			³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/07/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
StrTbl1Ln1:	movwf	LCD_LOOP
                call	LCD_ln1
                jmp     SendTbl1String


StrTbl1Ln2:	movwf	LCD_LOOP
                call    LCD_ln2


SendTbl1String:
        if      ( NO_TEXT )
                jmp     DisplayA_Num
        else
                clrw
	        movwf	LCD_ADD

SSu1:		call	String1Table		; Get the Indexed Data.
		iorlw	NULL
		btfsc	STATUS, Z
		jmp     EndStr
		call	LCD_Data
		incf	LCD_ADD, F
		incf	LCD_LOOP, F
		jmp	SSu1

        ; This is common to all string functions.   It clears out the rest of the line..
EndStr:
		movf    LCD_ADD, W
		andlw   0xF0
		btfss   STATUS, Z
	        return
		incf	LCD_ADD, F
		movlw   ' '
		call	LCD_Data
                jmp     EndStr
        endif

	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : String functions that use Table 1			³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/07/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
StrTbl2Ln1:	movwf	LCD_LOOP
                call	LCD_ln1
                jmp     SendTbl2String


StrTbl2Ln2:	movwf	LCD_LOOP
                call    LCD_ln2


SendTbl2String:
        if      ( NO_TEXT )
                jmp     DisplayA_Num
        else
                clrw
	        movwf	LCD_ADD

SSu2:		call	String2Table		; Get the Indexed Data.
		iorlw	NULL
		btfsc	STATUS, Z
		jmp     EndStr
		call	LCD_Data
		incf	LCD_ADD, F
		incf	LCD_LOOP, F
		jmp	SSu2
        endif







