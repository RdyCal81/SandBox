
	; Power on Reset / WatchDog Timer and MCLR Reset....
Boot.Asm:	clrf	STATUS		; Do initialization (Bank 0)
		clrf	INTCON		; Disable Interrupts..
		clrf	PIE1            ; Disable all peripheral interrupts
		
		; Now clear out all of the Bank 0 RAM...


		movlw	0x20		; Start of Usable Ram
		movwf	FSR
RamClr:		clrf	INDF		; Clear out the Ram, Indirectly
		incf	FSR, F		; F = Keep Result in File..
		btfss	FSR, 7
		jmp	RamClr
		
		
		call	InitPorts
		call	InitTimer

		bsf	INTCON, GIE     ; Enable all Interrupts
		Bank_0
		call	InitLCD
		call	ExtIntInit
		call	BeepInit
