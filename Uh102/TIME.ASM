
InitTimer:	Bank_0
		movlw	HIGH TIME_VAL	;
		movwf	TMR1H		;
		movlw	LOW TIME_VAL	;
		movwf	TMR1L		;

		clrf	PIR1		; Clear Interrupt Flags...
		
		Bank_1
		bsf	INTCON, PEIE    ; Enable Perifial interrupts.
		bsf	PIE1, TMR1IE	; Enable Timer1 Interrupt.

		Bank_0
		clrf	T1CON           ; Enable Nothing.
		bsf	T1CON, TMR1ON   ; Turn Timer 1 ON

		return

T1_Interrupt:	bcf	PIR1, TMR1IF	; Clear Timer 1 Interrupt Flag
Push:		movwf	SAVE_W
		swapf	STATUS, W
		movwf	SAVE_S
		
TryAgain:	movf	TMR1H, W
		movwf	INT_WH		; Save for later compare..
		movf	TMR1L, W
		movwf	INT_WL

		movf	TMR1H, W
		subwf	INT_WH, W
		btfss	STATUS, Z
		jmp	TryAgain
		
		movf	INT_WL, W
		bcf	STATUS, C
		addlw	LOW ( TIME_VAL + 4 )
		movwf	TMR1L		;
		btfsc	STATUS, C
		incf	INT_WH, F
		movf	INT_WH, W
		addlw	HIGH ( TIME_VAL + 4 )
		movwf	TMR1H

		bsf	TIME_FLAGS, 0		; Set every 1ms.

	if ( GOT_SHUTTER == FALSE )
		jb	IGNORE_TIMER, DoneSec
	endif

	; Mis 1ms flags....
		decfsz	R_w1MS, F
		jmp	w1Flag
		bsf	FLAGSPLUS, 1
w1Flag:
		decfsz	R_x1MS, F
		jmp	x1Flag
		bsf	TIME_FLAGS, 4
x1Flag:
		decfsz	R_y1MS, F
		jmp	y1Flag
		bsf	TIME_FLAGS, 5
y1Flag:		
		decfsz	R_z1MS, F
		jmp	z1Flag
		bsf	TIME_FLAGS, 6
z1Flag:
	; 1ms flags...


		decfsz	T_1MS, F
		jmp	DoneSec
		movlw	D'100'
		movwf	T_1MS
		bsf	TIME_FLAGS, 3		; Set every 100ms


	; Mis 100ms flags....
		decfsz	R_x100MS, F
		jmp	xFlag
		bsf	TIME_FLAGS, 7
xFlag:		
	; 100ms flags...

		decfsz	T_100MS, F
		jmp	DoneSec
		movlw	D'10'
		movwf	T_100MS
		bsf	TIME_FLAGS, 2		; Set every Second.

		decfsz	TWO_MINUTE_CNTR, F
		jmp	NoTwoMinuteTimeUp
		bsf	FLAGSPLUS, 3
NoTwoMinuteTimeUp:

		decfsz	T_SEC, F
		jmp	DoneSec
		bsf	TIME_FLAGS, 1		; Set when Seconds expire.
DoneSec:

		incf	LOC_PORTB, F
		movf	LOC_PORTB, W
		movwf	PORTB

Pop:		swapf	SAVE_S, W
		movwf	STATUS
		swapf	SAVE_W, F
		swapf	SAVE_W, W

ExRROR1:	retfie

;
;


Wait_LCD_1:	movwf	MSD	; Use MSD and LSD Registers to Initilize LCD
WaitLoop:	btfss	TIME_FLAGS, 0
		jmp	WaitLoop
		bcf	TIME_FLAGS, 0
		decfsz	MSD, F
		jmp	WaitLoop
		
		movf	LCD_VAL, F
		movwf	LCD_DATAP
		jmp	BobbleEnable



Wait500ms:	movlw	D'250'
		call	Wait
		movlw	D'250'


Wait:		movwf	MSD	; Use MSD and LSD Registers to Initilize LCD
		bcf	TIME_FLAGS, 0		; N_0011
WaitL:		btfss	TIME_FLAGS, 0
		jmp	WaitL
		bcf	TIME_FLAGS, 0
		decfsz	MSD, F
		jmp	WaitL
		return


	if ( WARM_UP )
StartWarmUpTimer:
		movlw	HIGH WARM_UP_TIME
		movwf	TIME_H
		movlw	LOW WARM_UP_TIME
		movwf	TIME_L
	endif	; ( WARM_UP )
	if ( GOT_SHUTTER )
StartMotorTimer:
		movlw	MOTOR_TIME_OUT
	endif	; ( GOT_SHUTTER )

StartTimer:	incf	T_1MS, F	; Just make sure it doesn't roll over
		incf	T_1MS, F	; while we are setting it...
		movwf	T_SEC
		movlw	D'100'
		movwf	T_1MS
		movlw	D'10'
		movwf	T_100MS
		clrw
		movwf	TIME_FLAGS	; Clear all of the bits...
		return
	
Wait100:	movwf	MSD	; Use MSD and LSD Registers to Initilize LCD
		movlw	D'100'
		movwf	T_1MS
		bcf	TIME_FLAGS, 3
Wait100L:	btfss	TIME_FLAGS, 3
		jmp	Wait100L
		bcf	TIME_FLAGS, 3
		decfsz	MSD, F
		jmp	Wait100L
		return




	if ( GOT_SHUTTER == FALSE )
StayIfDoorOpen:
		jb	DOOR_IN, DoorIsOpen
		return


DoorIsOpen:	setb	IGNORE_TIMER
		clr	UV_LAMP
		movlw	D'100'			; 100ms the door must be closed
		movwf	DOOR_DBNC
		

dio_loop:	jnb	MS1_TICK, dio_loop
		jb	DOOR_IN, DoorIsOpen	; Start over if the door is still open.

		decfsz	DOOR_DBNC, F
		jmp	dio_loop

		setb	UV_LAMP
		clr	IGNORE_TIMER
		return
	endif
		
