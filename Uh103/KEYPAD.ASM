

ReadKeyPad:
        	retnb	KEY_TIME_FLAG           ; return not bit


		clr	KEY_TIME_FLAG


		movf	PORTA, W
		andlw	B'00011111'
		xorlw	B'00011111'
		movwf	TEMP
		jz	NoKeyAtThisTime		; found all ones..
		xorwf	PrevKeyRead, W
		jnz	keyIsNotTheSame
		movf	KeyDebounce, W
		xorlw	0xFF
		jnz	KeepDebouncing
		retb	KEY_IS_HIT              ; return not bit
		setb	KEY_IS_HIT
		setb    APP_KEY_HIT

		movf	PrevKeyRead, W
		movwf	TEMP
		movlw	4
		movwf	ANS_L

key_start:
		rrf	TEMP, F
		jc	GoodKeyRead	
		decfsz	ANS_L, F
		jmp	key_start
GoodKeyRead:
		movf	ANS_L, W
		btfsc	PORTE, 0	; KEY_ROW1
		addlw	5
		movwf   AppKeyVal
		return			


KeepDebouncing:
		decf	KeyDebounce, F
		return

NoKeyAtThisTime:
		jb	KEY_ROW1, TestRow2
		setb	KEY_ROW1
		clr	KEY_ROW2
		jmp	keyIsNotTheSame
TestRow2:
		jb	KEY_ROW2, SetUpRows
		setb	KEY_ROW1
		setb	KEY_ROW2
		jmp	keyIsNotTheSame
SetUpRows:	
		clr	KEY_ROW1
	       ;setb	KEY_ROW2



keyIsNotTheSame:
		movf	TEMP, W
		movwf	PrevKeyRead
		movlw	D'10'			; 10ms debounce time...
		movwf	KeyDebounce
		clr	KEY_IS_HIT
                return

StartSwitch:
                retnb   START_SW_FLAG
		clr     START_SW_FLAG
                jb      SW_START, NoStartSw
        	decfsz	StartDebounce, F
		return
        if ( CAN_RUN )
		jmp     StartRunning
	endif
NoStartSw:
                movlw   D'10'
		movwf   StartDebounce
                return



