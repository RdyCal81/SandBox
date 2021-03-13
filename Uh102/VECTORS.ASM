
	org	0x0000			; RESET vector location
Reset:		Bank_1
		btfsc	PCON, POR	; Power-up reset?
		jmp	Boot.Asm	; YES
		jmp	Boot.Asm	; NO, a WDT or MCLR reset

	org	0x0004			; Interrupt vector location
		Bank_0
		btfsc	PIR1, TMR1IF	; Timer 1 overflowed?
		jmp	T1_Interrupt	; YES, Service the Timer1 Overflow Interrupt
		btfsc	INTCON, INTF	; External Interrupt?
		jmp	Ext_Interrupt	; YES, External Int.
		jmp	ExRROR1		; NO, Exrror Condition - Unknown Interrupt
