

InitPorts       MACRO

	       	clrf	PORTA           ; ALL PORT output should output Low.
		                        ; Except the 2 active low output specified below...

        	clrf	PORTB

                movlw   B'00001000'
        	movwf   PORTC


               ;movlw   B'00001000'
        	movwf	PORTD


		clrf	PORTE



		Bank_1
		movlw	0xFF
		movwf	TRISA           ; 0,1,2,3,4,5 Inputs:  Outputs

		movlw	0x1F
		movwf	TRISB		; 0,1,2,3,4 Input: 5,6,7 Outputs

		movlw	0x30
		movwf	TRISC           ; 0,1,4,5 Input: 0,1,2,3,6,7 Outputs

		movlw	B'00000010'
		movwf	TRISD           ; . Input: 0,1,2,3,4,5,6,7 Outputs

		movlw	B'00000100'
		movwf	TRISE           ; 2. Input: 0,1 Outputs
	
	
	
;		bcf	T1CON, TMR1ON	; Timer 1 is NOT incrementing
;
	
;;;		bsf	PIE1, TMR1IE    ; Enable TMR1 Interrupt
;		bcf	OPTION_REG, RBPU; Enable PORTB pull-ups
		Bank_0
		movf	PORTB, F        ; Need to clear 1st RBIF, due to
		bcf	INTCON, RBIF    ;    set up of PORTB

     ;		bsf	PORTE, 0
     ;		bsf	PORTE, 1

		ENDM








SetDOOR_LOCK:
        bsf     PORTD, 0
	bsf     L_PORTD, 0
	return

ClearDOOR_LOCK:
        bcf     PORTD, 0
	bcf     L_PORTD, 0
	return


SetCOOL_FAN:
        bcf     PORTD, 3
	bcf     L_PORTD, 3
	return

ClearCOOL_FAN:
        bsf     PORTD, 3
	bsf     L_PORTD, 3
	return


