


ExtIntInit:	bcf	INTCON, GIE     ; Disable all Interrupts
		Bank_1
		bsf	TRISB, 0	; RB0 is an input...
		bcf	OPTION_REG, INTEDG ; Ext Int on Falling Edg..
		Bank_0
		bsf	INTCON, GIE     ; Enable all Interrupts

		bcf	INTCON, INTF	; Clear External Interrupt flag.
		bsf	INTCON, INTE	; Enable External Interrupt.
		return


Ext_Interrupt:	bcf	INTCON, INTF	; Clear External Interrupt flag.
		movwf	SAVE_W
		swapf	STATUS, W
		movwf	SAVE_S
		
; N_0003	call	BeepOn
		bsf	FLAGS, 0
		bcf	SH_MOTOR_ADD, SH_MOTOR_BIT	; Turn On the motor,
		bcf	DR_MOTOR_ADD, DR_MOTOR_BIT	; this motor also.

		swapf	SAVE_S, W
		movwf	STATUS
		swapf	SAVE_W, F
		swapf	SAVE_W, W

		retfie











                                                                         