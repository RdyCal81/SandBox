	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : CloseShutter						³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/11/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if ( GOT_SHUTTER )
OpenShutter:	bsf	SH_MOTOR_ADD, SH_MOTOR_BIT	; Turn On the motor.
		btfss	SH_OUT_ADD, SH_OUT_BIT		; Drawer In?
		jmp	MotorsOff

		bcf	FLAGS, 0
		call	StartMotorTimer

		bsf	SH_DIR_ADD, SH_DIR_BIT		; 1 = Open....
		bsf	SH_MOTOR_ADD, SH_MOTOR_BIT	; Turn On the motor.

OpShLoop:	btfss	SH_OUT_ADD, SH_OUT_BIT		; Drawer Out?
		jmp	MotorsOff
		call	TestMotorError
		jmp	OpShLoop
	endif

	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : OpenShutter						³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/11/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if ( GOT_SHUTTER )
CloseShutter:	bcf	SH_MOTOR_ADD, SH_MOTOR_BIT	; Turn On the motor.
		btfss	SH_IN_ADD, SH_IN_BIT		; Drawer In?
		jmp	MotorsOff

		bcf	FLAGS, 0
		call	StartMotorTimer

		bcf	SH_DIR_ADD, SH_DIR_BIT		; 0 = Close....
		bcf	SH_MOTOR_ADD, SH_MOTOR_BIT	; Turn On the motor.

ClsShLoop:	btfss	SH_IN_ADD, SH_IN_BIT		; Drawer In?
		jmp	MotorsOff
		call	TestMotorError
		jmp	ClsShLoop

	endif
	; Make sure that this function does not modify 'W'..
MotorsOff:
	;102	bcf	SH_MOTOR_ADD, SH_MOTOR_BIT
	;102	bcf	DR_MOTOR_ADD, DR_MOTOR_BIT
	;102	bcf	SH_DIR_ADD, SH_DIR_BIT
	;102	bcf	DR_DIR_ADD, DR_DIR_BIT
		return

	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : Motor Errors.						³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/11/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TestMotorError:	btfsc	TIME_FLAGS, 1			; TimeOut?
		jmp	MotorTimeOut
		btfsc	FLAGS, 0			; OverLoad?
		jmp	MotorOverLoad
		return

MotorTimeOut:	movlw	SJM_STR
	;102	btfss	SH_MOTOR_ADD, SH_MOTOR_BIT	; Is this Motor On?
	;102	movlw	DJM_STR
		call	MotorsOff
		call	SendString
		jmp	Wait4StartSwitch

MotorOverLoad:	call	MotorsOff
		movlw	MOV_STR
		call	SendString
		jmp	Wait4StartSwitch

Wait4StartSwitch:
		SET_TIMER	START_SW_TIME

W4swLoop:	call	UVoff				; N_0008
		call	N2off				; N_0008
		btfsc	SW_START_ADD, SW_START_BIT
		jmp	Wait4StartSwitch
		btfss	TIME_FLAGS, 1			; Done Waiting?
		jmp	W4swLoop			; NO
		jmp	Main				; YES

