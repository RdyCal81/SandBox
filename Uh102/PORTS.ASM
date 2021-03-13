

InitPorts:	clrf	PORTA           ; ALL PORT output should output Low.
		clrf	PORTB
		clrf	PORTC
		clrf	PORTD
		clrf	PORTE
;		bcf	T1CON, TMR1ON	; Timer 1 is NOT incrementing
;
		Bank_1
		movlw	0xFF
		movwf	TRISA           ; 0,1,2,3,4,5 Inputs:  Outputs

		movlw	0x0F
		movwf	TRISB		; 0,1,2,3 Input: 4,5,6,7 Outputs

		movlw	0x30
		movwf	TRISC           ; 4,5 Input: 0,1,2,3,6,7 Outputs

		movlw	B'00000010'
		movwf	TRISD           ; 1 Input: 0,2,3,4,5,6,7 Outputs

		movlw	B'00000100'
		movwf	TRISE           ; 2 Input: 0,1 Outputs
		
;;;		bsf	PIE1, TMR1IE    ; Enable TMR1 Interrupt
		bsf	OPTION_REG, RBPU; Disable PORTB pull-ups
		Bank_0
;;		movf	PORTB, F        ; Need to clear 1st RBIF, due to
;;		bcf	INTCON, RBIF    ;    set up of PORTB

		bsf	PORTE, 0
		bsf	PORTE, 1
		return



	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : UVon							³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/11/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
UVon:		setb	UV_LAMP
		return

	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : UVoff							³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/11/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
UVoff:		clr	UV_LAMP
		return

	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : N2on							³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/11/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
N2on:		bsf	N2_ADD, N2_BIT
		return

	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : N2off							³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/11/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
N2off:		bcf	N2_ADD, N2_BIT
		return


	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : ReadTimeSw						³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/13/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ReadTimeSw:	movlw	SW_DEBOUNCE
		movwf	MSD

SwTioL:		bcf	TIME_FLAGS, 0	; Clear the 1ms flag...
SwTiiL:		bcf	STATUS, C	; Clear the carry flag...
		btfsc	SW_TIME_ADD, SW_TIME_BIT
		return
		btfss	TIME_FLAGS, 0
		jmp	SwTiiL

		decfsz	MSD, F
		jmp	SwTioL
		bsf	STATUS, C	; Set the carry flag...
		return




	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : ReadStartSw						³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/13/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ReadStartSw:	movlw	SW_DEBOUNCE
		movwf	MSD

SwSroL:		bcf	TIME_FLAGS, 0	; Clear the 1ms flag...
SwSriL:		bcf	STATUS, C	; Clear the carry flag...
		btfsc	SW_START_ADD, SW_START_BIT
		return
		btfss	TIME_FLAGS, 0
		jmp	SwSriL

		decfsz	MSD, F
		jmp	SwSroL
		bsf	STATUS, C	; Set the carry flag...
		return


	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : ReadInOutSw						³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/13/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ReadAbortSw:	movlw	SW_DEBOUNCE
		movwf	MSD

SwIooL:		bcf	TIME_FLAGS, 0	; Clear the 1ms flag...
SwIoiL:		bcf	STATUS, C	; Clear the carry flag...
		btfsc	SW_ABORT_ADD, SW_ABORT_BIT
		return
		btfss	TIME_FLAGS, 0
		jmp	SwIoiL

		decfsz	MSD, F
		jmp	SwIooL
		bsf	STATUS, C	; Set the carry flag...
		return


	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : ReadStandBySw						³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/13/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ReadStandBySw:	SET_TIMER	SW_DEBOUNCE		; ; N_0001
SwSbiL:		btfsc	SW_STANDBY_ADD, SW_STANDBY_BIT
		return
		btfss	TIME_FLAGS, 1		; Done Waiting?
		jmp	SwSbiL			; NO
						; YES
	if ( GOT_SHUTTER )
		call	UVoff
	else
		; The stand by button has been pushe,
		;  turn on the lamp if count is not zero...
		decfsz	STANDBY_CNT, F
		jmp	Sw1x1
		incf	STANDBY_CNT, F
		call	UVoff
		jmp	Sw1x2
Sw1x1:
		call	UVon
Sw1x2:
		movlw	D'2'
		call	StartTimer
GetSw1Dbnc:
		btfsc	TIME_FLAGS, 1		; Bit 4 is 1ms, Rx_1ms
		jmp	TimeUpSw1
		btfss	SW_STANDBY_ADD, SW_STANDBY_BIT
		jmp	GetSw1Dbnc
		call	UVoff
		jmp	ReadStandBySw
TimeUpSw1:
		call	UVoff

		movlw	D'3'
		call	StartTimer
GetSw2Dbnc:
		btfsc	TIME_FLAGS, 1		; Bit 4 is 1ms, Rx_1ms
		jmp	TimeUpSw2
		btfss	SW_STANDBY_ADD, SW_STANDBY_BIT
		jmp	GetSw2Dbnc
		jmp	ReadStandBySw
TimeUpSw2:

	endif	
	

		call	N2off
		;;;call	ClearLCD		; N_0001
	if ( GOT_SHUTTER )
		call	CloseShutter
	endif
	;102	call	Wait500ms
	;102	call	CloseDrawer
		movlw	STD_STR
		call	SendString

StandByStart:	SET_TIMER	SW_DEBOUNCE
StandByLoop:	btfss	SW_STANDBY_ADD, SW_STANDBY_BIT
		jmp	StandByStart
		btfss	TIME_FLAGS, 1		; Done Waiting?
		jmp	StandByLoop		; NO

StandByEnd:	call	ReadTimeSw
		btfsc	STATUS, C	; C=0 means "START" not pushed.
		jmp	Main		; C=1 means Go do Start..

		call	ReadStartSw
		btfsc	STATUS, C	; C=0 means "START" not pushed.
		call	Main		; C=1 means Go do Start..

	;102	call	ReadInOutSw
	;102	btfsc	STATUS, C	; C=0 means "INOUT" not pushed.
	;102	call	Main		; C=1 means Go do Start..

		SET_TIMER	SW_DEBOUNCE
SSEnd:		btfsc	SW_STANDBY_ADD, SW_STANDBY_BIT
		jmp	StandByEnd
		btfss	TIME_FLAGS, 1		; Done Waiting?
		jmp	SSEnd			; NO
		jmp	Main			; YES



SwitchGoAway:	movlw	SW_DEBOUNCE
		movwf	MSD
SgaoL:		bcf	TIME_FLAGS, 0	; Clear the 1ms flag...
SgaiL:		bcf	PORTE, 0
		nop
		nop
		nop
		nop
		nop		; N_0010
		nop		; N_0010
		nop		; N_0010
		nop		; N_0010
		movf	PORTA, W
		andlw	0x1F
		xorlw	0x1F
		movwf	TEMP

		bsf	PORTE, 0
		bcf	PORTE, 1
		nop
		nop
		nop
		nop
		nop		; N_0010
		nop		; N_0010
		nop		; N_0010
		nop		; N_0010
		movf	PORTA, W
		andlw	0x1F
		xorlw	0x1F
		bsf	PORTE, 1	; N_0010, I need to set this bit...
		iorwf	TEMP, W
		btfss	STATUS, Z
		jmp	SwitchGoAway
		btfss	TIME_FLAGS, 0
		jmp	SgaiL
		decfsz	MSD, F
		jmp	SgaoL
		return


ReadSwitches:	bcf	PORTE, 0
		nop
		nop
		nop
		nop
		movf	PORTA, W
		andlw	0x1F
		xorlw	0x1F
		btfss	STATUS, Z
		jmp	KeepSw

		bsf	PORTE, 0
		bcf	PORTE, 1
		nop
		nop
		nop
		nop
		movf	PORTA, W
		andlw	0x1F
		xorlw	0x1F
		btfss	STATUS, Z
		jmp	KeepSw

NoKeyHit:	bcf	STATUS, C	; C=0 means "SWITCHES" not pushed.
RsExit:		bsf	PORTE, 0
		bsf	PORTE, 1
		return


KeepSw:		movwf	TEMP 
		movlw	SW_DEBOUNCE
		movwf	MSD
KsoL:		bcf	TIME_FLAGS, 0	; Clear the 1ms flag...
		
KsiL:		movf	PORTA, W
		andlw	0x1F
		xorlw	0x1F
		xorwf	TEMP, W
		btfss	STATUS, Z
		jmp	NoKeyHit
		btfss	TIME_FLAGS, 0
		jmp	KsiL
		decfsz	MSD, F
		jmp	KsoL

;	Test here for which switch is pressed.
		movlw	4
		movwf	MSD
		rlf	TEMP, F
		rlf	TEMP, F
		rlf	TEMP, F
DoKeyAgain:	rlf	TEMP, F
		btfsc	STATUS, C
		jmp	GotTheKey
		decfsz	MSD, F
		jmp	DoKeyAgain
GotTheKey:	clrw
		btfss	PORTE, 1
		movlw	5
		addwf	MSD, F
		incf	MSD, F
		movlw	D'10'
		subwf	MSD, W		; (w) - 10 will Clear the Carry.
		btfsc	STATUS, C	; Skip if carry is not cleared.
		movlw	D'6'		; Pick a number to make W = 0x10;
		addlw	D'10'		;   when 9 is added to it.
		andlw	0x0F
		bsf	STATUS, C	; C=1 means a "SWITCH" pushed.
		jmp	RsExit

