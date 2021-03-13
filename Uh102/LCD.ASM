
	;здддддддддддддддд©
	;Ё LCD Addresses. Ё
	;юдддддддддддддддды
LCD_DATAP	EQU     PORTD           ; The LCD data is on the lower 4-bits
;;LCD_DATA_TRIS	EQU	TRISD           ; The TRIS register for the LCD data
LCD_CNTL        EQU     PORTC           ; Three control lines

LCD_ENA		equ	7
LCD_RS		equ	6

	;здддддддддддддд©
	;Ё LCD Equates. Ё
	;юдддддддддддддды
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


	;здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	;Ё Function : LCD_Init						Ё
	;цдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
	;Ё Input    : 							Ё
	;Ё Output   :							Ё
	;Ё Destroys : Alot						Ё
	;Ё History  :							Ё
	;юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
InitLCD:	bcf	LCD_CNTL, LCD_ENA	; LCD Not enabled.
		bcf	LCD_CNTL, LCD_RS	; Select Command, !Data.

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

	;здддддддддддддддддддддддддддддддддддддддддддддддддддд©
	;Ё From now on all Data is 4 bits and must be written Ё
	;Ё High nybble first, the low nybble.		      Ё
	;юдддддддддддддддддддддддддддддддддддддддддддддддддддды

		clrw				; Start at Zero..
		movwf	LCD_LOOP

LCD_LOOP_CMD:	movlw	D'2'			;
		movwf	MSD	; Use MSD and LSD Registers to Initilize LCD
		bcf	LCD_CNTL, LCD_ENA	; LCD Not enabled.
		bcf	LCD_CNTL, LCD_RS	; Select Command, !Data.
WaitLcLoop:	btfss	TIME_FLAGS, 0
		jmp	WaitLcLoop
		bcf	TIME_FLAGS, 0
		decfsz	MSD, F
		jmp	WaitLcLoop
		
		movf	LCD_LOOP, W		; Get the Index..
		call	LCD_iTable		; Get the Indexed command..
		iorlw	NULL
		btfsc	STATUS, Z
		return				; Return if end of table..
		call	LCD_Command
		incf	LCD_LOOP, F
		jmp	LCD_LOOP_CMD



	;здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	;Ё Func : ClearLCD						Ё
	;цдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
	;Ё In   : 							Ё
	;Ё Out  :							Ё
	;Ё Dest :							Ё
	;Ё Comm :							Ё
	;Ё Hist : 03/07/97 Initial Cut				Randy	Ё
	;юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
ClearLCD:	movwf	LCD_LOOP
		clrw
		movwf	LCD_ADD
		movlw	CLRLCD
		call	LCD_Command
		movlw	d'3'		; Wait for 3 additional ms for
					; a CLRLCD Command..
		jmp	Wait


LCD_ln2:	movlw	LCD2LINE
		call	LCD_Command
		jmp	LDelay			; N_0006, N_0012

LCD_Data:	bsf	LCD_CNTL, LCD_RS	; Select Data, !Command.
		jmp	LCD_write

LCD_Command:	bcf	LCD_CNTL, LCD_RS	; Select Command, !Data.

LCD_write:	bcf	LCD_CNTL, LCD_ENA	; LCD Not enabled.

		movwf	TEMP
		movf	L_PORTD, W
		andlw	B'00001111'
		movwf	L_PORTD
		movf	TEMP, W
		andlw	B'11110000'
		iorwf	L_PORTD, W
		movwf	LCD_DATAP
		bsf	LCD_CNTL, LCD_ENA
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
		bcf	LCD_CNTL, LCD_ENA

		nop
		nop

		swapf	TEMP, W
		andlw	B'11110000'
		iorwf	L_PORTD, W
		movwf	LCD_DATAP

BobbleEnable:	bsf	LCD_CNTL, LCD_ENA
		nop			; N_0006
		nop			; N_0006
		nop			; N_0006
		nop			; N_0006
		nop
		nop			; N_0002
		nop			; was only 2 nop's, was intermittant
		nop
		nop
		bcf	LCD_CNTL, LCD_ENA

LDelay:		movlw	LCD_DELAY	; Wait for 'x' uS before returning.
		movwf	MSD		; N_0002
BobbleDelay:	decfsz	MSD, F
		jmp	BobbleDelay
		return



DisplayTime:	movlw	~4
		andwf	TIME_FLAGS, F
		movlw	LCD2LINE + 5
		call	LCD_Command

		movf	TIME_H, W
		movwf	QUO_H
		movf	TIME_L, W
		movwf	QUO_L
		call	Devide_100
		movf	ANS_L, W
		call	AsciiTable
		call	LCD_Data

		movf	TMP_H, W
		movwf	QUO_H
		movf	TMP_L, W
		movwf	QUO_L
		call	Devide_10
		movf	ANS_L, W
		call	AsciiTable
		call	LCD_Data

		movf	TMP_L, W
		call	AsciiTable
		call	LCD_Data
		return





	if ( Clock )
		nop
		movlw	0x80
		movwf	LCD_DATAP
		nop
		bsf	LCD_CNTL, LCD_ENA
		nop
		nop
		bcf	LCD_CNTL, LCD_ENA








		movlw	0x30
		movwf	LCD_DATAP
		nop
		bsf	LCD_CNTL, LCD_ENA
		nop
		nop
		bcf	LCD_CNTL, LCD_ENA

		movlw	D'20'
		call	Wait_LCD_1
		movlw	0x30
		movwf	LCD_DATAP
		nop
		bsf	LCD_CNTL, LCD_ENA
		nop
		nop
		bcf	LCD_CNTL, LCD_ENA

		movlw	D'4'
		call	Wait_LCD_1
		movlw	0x30
		movwf	LCD_DATAP
		nop
		bsf	LCD_CNTL, LCD_ENA
		nop
		nop
		bcf	LCD_CNTL, LCD_ENA


		movlw	D'4'
		call	Wait_LCD_1
		movlw	0x20
		movwf	LCD_DATAP
		nop
		bsf	LCD_CNTL, LCD_ENA
		nop
		nop
		bcf	LCD_CNTL, LCD_ENA

		movlw	D'4'
		call	Wait_LCD_1
		movlw	0x20
		movwf	LCD_DATAP
		nop
		bsf	LCD_CNTL, LCD_ENA
		nop
		nop
		bcf	LCD_CNTL, LCD_ENA
		nop
		movlw	0x80
		movwf	LCD_DATAP
		nop
		bsf	LCD_CNTL, LCD_ENA
		nop
		nop
		bcf	LCD_CNTL, LCD_ENA



		movlw	D'4'
		call	Wait_LCD_1
		movlw	0x00
		movwf	LCD_DATAP
		nop
		bsf	LCD_CNTL, LCD_ENA
		nop
		nop
		bcf	LCD_CNTL, LCD_ENA
		nop
		movlw	0xC0
		movwf	LCD_DATAP
		nop
		bsf	LCD_CNTL, LCD_ENA
		nop
		nop
		bcf	LCD_CNTL, LCD_ENA


		movlw	D'4'
		call	Wait_LCD_1
		movlw	0x00
		movwf	LCD_DATAP
		nop
		bsf	LCD_CNTL, LCD_ENA
		nop
		nop
		bcf	LCD_CNTL, LCD_ENA
		nop
		movlw	0x10
		movwf	LCD_DATAP
		nop
		bsf	LCD_CNTL, LCD_ENA
		nop
		nop
		bcf	LCD_CNTL, LCD_ENA

		movlw	D'4'
		call	Wait_LCD_1
		movlw	0x00
		movwf	LCD_DATAP
		nop
		bsf	LCD_CNTL, LCD_ENA
		nop
		nop
		bcf	LCD_CNTL, LCD_ENA
		nop
		movlw	0x60
		movwf	LCD_DATAP
		nop
		bsf	LCD_CNTL, LCD_ENA
		nop
		nop
		bcf	LCD_CNTL, LCD_ENA

		bcf	LCD_CNTL, LCD_ENA
		bsf	LCD_CNTL, LCD_RS

		movlw	D'4'
		call	Wait_LCD_1
		movlw	'R'
		movwf	LCD_DATAP
		nop
		bsf	LCD_CNTL, LCD_ENA
		nop
		nop
		bcf	LCD_CNTL, LCD_ENA
		nop
		movlw	('R' << 4) & 0xF0
		movwf	LCD_DATAP
		nop
		bsf	LCD_CNTL, LCD_ENA
		nop
		nop
		bcf	LCD_CNTL, LCD_ENA
		return










		movlw	0xC0
		movf	LCD_DATAP, W
		nop
		bsf	LCD_CNTL, LCD_ENA
		nop
		nop
		bcf	LCD_CNTL, LCD_ENA

	endif		



;		bcf	L_PORTB, LCD_ENA
;		movf	L_PORTB, W
;		movwf	PORTB
;		call	Wait60ms
;		call	Wait20ms


	if ( Clock )
		mov	r7, #0
LCLILoop:	mov	dptr, #InitLCDTable
		mov	a, r7
		inc	r7
		movc	a, @a + dptr
		jz	EndLCDInit
		acall	LcdCmnd
		acall	Wait10ms
		sjmp	LCLILoop
EndLCDInit:
		mov	dptr, #InitLCDTable
		mov	a, r7
		inc	r7
		cjne	a, #ILen, gomore
		sjmp	EndLCDData
gomore:		movc	a, @a + dptr
		acall	LcdData
		acall	Wait10ms
		sjmp	EndLCDInit
EndLCDData:

		mov	a, #0
		acall	GotoRow1
		mov	dptr, #RACUTILS
		acall	LCD_Str
		mov	a, #0
		acall	GotoRow2
		mov	dptr, #BATT
		acall	LCD_Str
	
		mov	r7, #200		; Wait for 12 Seconds....
Lcdwt:		acall	Wait60ms
		djnz	r7, Lcdwt
		mov	a, #CLRLCD
		acall	LcdCmnd
		acall	Wait10ms
		ret


DispBHex:	mov	dptr, #BHEX
		mov	a, DSPHEX
		anl	a, #00Fh
		movc	a, @a + dptr
		acall	LcdData
		ret

		
DispUpHex:	mov	dptr, #HEX2ASC
		mov	a, DSPHEX
		swap	a
		anl	a, #00Fh
		movc	a, @a + dptr
		acall	LcdData			; Display Upper Byte of
		ret

DispLowHex:	mov	dptr, #HEX2ASC
		mov	a, DSPHEX
		anl	a, #00Fh
		movc	a, @a + dptr
		acall	LcdData			; Display Upper Byte of
		ret


DispHex:	mov	dptr, #HEX2ASC
		mov	a, DSPHEX
		swap	a
		anl	a, #00Fh
		movc	a, @a + dptr
		acall	LcdData			; Display Upper Byte of
						;	Battery Voltage.
						;  On Column #6.
		mov	a, DSPHEX
		anl	a, #00Fh
		movc	a, @a + dptr
		acall	LcdData			; Display Lower Byte of
						;   Battery Voltage.
						;  On Column #7.
		ret



GotoRow1:	anl	a, #01Fh
		orl	a, #LCD1LINE
		sjmp	LcdCmnd

GotoRow2:	anl	a, #01Fh
		orl	a, #LCD2LINE
		sjmp	LcdCmnd

	;здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	;Ё Function : LcdCmnd						Ё
	;цдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
	;Ё Input    : Command in ACC					Ё
	;Ё Output   :							Ё
	;Ё Destroys : Alot						Ё
	;Ё History  :							Ё
	;юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
LcdCmnd:	clr	LCD_RS
	        sjmp    Lcdq

	;здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	;Ё Function : LcdData						Ё
	;цдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
	;Ё Input    : Data Byte in ACC					Ё
	;Ё Output   :							Ё
	;Ё Destroys : Alot						Ё
	;Ё History  :							Ё
	;юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
LcdData:	setb	LCD_RS
Lcdq:		mov	LCD_D, a
		nop
		nop
		nop
		nop
		nop
		nop
		setb	LCD_EN
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		clr	LCD_EN
		mov	A2D_ACC, #68
ddls:		djnz	A2D_ACC, ddls
		mov	LCD_D, #0FFh
	        ret


	;зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	;Ё Fun:LCD_Str, Write a String on the LCD.                       Ё
	;Ё His: 10/22/93 Initial Cut.                    	RAC    	 Ё
	;юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
LCD_Str:	clr	a
		movc	a, @a + dptr
		jz	Lcd_ret
		acall	LcdData
		inc	dptr
		sjmp	LCD_Str
Lcd_ret:	ret

	endif
