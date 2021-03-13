
	; Power on Reset / WatchDog Timer and MCLR Reset....
Boot.Asm:
	; -----------------------------------------------------	Start (dt.1)
		Bank_1
		movlw	B'00000000'
		movwf	TRISD           ; . Input: 0,1,2,3,4,5,6,7 Outputs
		movwf	TRISE           ; . Input: 0,1,2 Outputs
		Bank_0
		
		movlw	0xFF
		movwf	PORTE
		clrf	STATUS_1
	       ;call	UpdateOutPuts
	; -----------------------------------------------------	End (dt.1)

		clrf	STATUS		; Do initialization (Bank 0)
		clrf	INTCON		; Disable Interrupts..
		clrf	PIE1            ; Disable all peripheral interrupts
		
		InitPorts
		; Now clear out all of the Bank 0 RAM...

        if      ( ABORT_ACTIVE )
                movf    RESET_VAL, W
		xorlw   0x5A
		jz      AbortKey1
	endif
		


		movlw	0x20		; Start of Usable Ram
		movwf	FSR
RamClr:	
   clrf		INDF		; Clear out the Ram, Indirectly
   incf		FSR, F		; F = Keep Result in File..
   btfss	FSR, 7
   jmp      RamClr
		
		
		movlw   7
		movwf   MotorSpeedIdx
		movwf   SafeSpeedVal

		call    SpeedTable
		movwf   MotorSpeed
;		clr     MAX_SPEED_FLAG
AbortKey1:
		InitTimer
		InitTimer0

		bsf	INTCON, GIE     ; Enable all Interrupts
		Bank_0
		
		call    ClearCOOL_FAN
		call	InitLCD



        if      ( ABORT_ACTIVE )
                movf    RESET_VAL, W
		xorlw   0x5A
		jz      Abort.Asm
		movlw   0x5A
		movwf   RESET_VAL
	endif


	if      ( ABORT_ACTIVE )
	;	btfss	PCON, POR	; Power-up reset?
	;	jmp	Abort.Asm
	endif
			
