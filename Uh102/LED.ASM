


	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : ClearLED							³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/11/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LED_Off:	bcf	FLAGSPLUS, 0		; Set LED flag to OFF
		bcf	FLAGSPLUS, 2

ClearLED:	bsf	LED_ADD, LED_BIT
		movlw	D'255'
		movwf	R_w1MS
		return

LED_On:		bsf	FLAGSPLUS, 0		; Set LED flag to OFF
		bsf	FLAGSPLUS, 2

SetLED:		bcf	LED_ADD, LED_BIT
		movlw	D'255'
		movwf	R_w1MS
		return

LED_Blink:	bsf	FLAGSPLUS, 0
		bcf	FLAGSPLUS, 2


UpdateLED:	btfss	FLAGSPLUS, 0
		jmp	ClearLED
		btfsc	FLAGSPLUS, 2
		jmp	SetLED
		btfss	FLAGSPLUS, 1		; Timer tick
		return
		movlw	D'150'
		movwf	R_w1MS
		bcf	FLAGSPLUS, 1		; Clear timer tick

		btfss	LED_ADD, LED_BIT
		jmp	Set_LED
ClLED:		bcf	LED_ADD, LED_BIT
		return
Set_LED:	bsf	LED_ADD, LED_BIT
		return


