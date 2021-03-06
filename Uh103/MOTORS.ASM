	;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	;� Func : CloseShutter						�
	;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑
	;� In   : 							�
	;� Out  :							�
	;� Dest :							�
	;� Comm :							�
	;� Hist : 03/11/97 Initial Cut				Randy	�
	;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
OpenShutter:	btfss	SH_OUT_ADD, SH_OUT_BIT		; Drawer In?
		jmp	MotorsOff

		bcf	FLAGS, 0
		call	StartMotorTimer

		bsf	SH_DIR_ADD, SH_DIR_BIT		; 1 = Open....
		bsf	SH_MOTOR_ADD, SH_MOTOR_BIT	; Turn On the motor.

OpShLoop:	btfss	SH_OUT_ADD, SH_OUT_BIT		; Drawer Out?
		jmp	MotorsOff
		call	TestMotorError
		jmp	OpShLoop

	;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	;� Func : OpenShutter						�
	;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑
	;� In   : 							�
	;� Out  :							�
	;� Dest :							�
	;� Comm :							�
	;� Hist : 03/11/97 Initial Cut				Randy	�
	;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
CloseShutter:	btfss	SH_IN_ADD, SH_IN_BIT		; Drawer In?
		jmp	MotorsOff

		bcf	FLAGS, 0
		call	StartMotorTimer

		bcf	SH_DIR_ADD, SH_DIR_BIT		; 0 = Close....
		bsf	SH_MOTOR_ADD, SH_MOTOR_BIT	; Turn On the motor.

ClsShLoop:	btfss	SH_IN_ADD, SH_IN_BIT		; Drawer In?
		jmp	MotorsOff
		call	TestMotorError
		jmp	ClsShLoop


	; Make sure that this function does not modify 'W'..
MotorsOff:	bcf	SH_MOTOR_ADD, SH_MOTOR_BIT
		bcf	DR_MOTOR_ADD, DR_MOTOR_BIT
		bcf	SH_DIR_ADD, SH_DIR_BIT
		bcf	DR_DIR_ADD, DR_DIR_BIT
		return

	;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	;� Func : OpenDrawer						�
	;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑
	;� In   : 							�
	;� Out  :							�
	;� Dest :							�
	;� Comm :							�
	;� Hist : 03/11/97 Initial Cut				Randy	�
	;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
OpenDrawer:	;;;call	ClearLCD		; N_0001
		movlw	3
		movwf	LSD
OpDr:		call	BeepOn
		movlw	BEEP_ON_TIME		; N_0003
		call	Wait100
		call	BeepOff
		movlw	BEEP_OFF_TIME		; N_0003
		call	Wait100
		decfsz	LSD, F
		jmp	OpDr

		btfss	DR_OUT_ADD, DR_OUT_BIT		; Drawer In?
		jmp	MotorsOff

		bcf	FLAGS, 0
		call	StartMotorTimer

		bsf	DR_DIR_ADD, DR_DIR_BIT		; 1 = Open....
		bsf	DR_MOTOR_ADD, DR_MOTOR_BIT	; Turn On the motor.

OpDrLoop:	btfss	DR_OUT_ADD, DR_OUT_BIT		; Drawer Out?
		jmp	MotorsOff
		call	TestMotorError
		jmp	OpDrLoop

	;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	;� Func : CloseDrawer						�
	;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑
	;� In   : 							�
	;� Out  :							�
	;� Dest :							�
	;� Comm :							�
	;� Hist : 03/11/97 Initial Cut				Randy	�
	;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
CloseDrawer:
		btfss	DR_IN_ADD, DR_IN_BIT		; Drawer In?
		jmp	MotorsOff

		bcf	FLAGS, 0
		call	StartMotorTimer

		bcf	DR_DIR_ADD, DR_DIR_BIT		; 0 = Close....
		bsf	DR_MOTOR_ADD, DR_MOTOR_BIT	; Turn On the motor.

ClDrLoop:	btfss	DR_IN_ADD, DR_IN_BIT		; Drawer Out?
		jmp	MotorsOff
		call	TestMotorError
		jmp	ClDrLoop

	;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	;� Func : Motor Errors.						�
	;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑
	;� In   : 							�
	;� Out  :							�
	;� Dest :							�
	;� Comm :							�
	;� Hist : 03/11/97 Initial Cut				Randy	�
	;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
TestMotorError:	btfsc	TIME_FLAGS, 1			; TimeOut?
		jmp	MotorTimeOut
		btfsc	FLAGS, 0			; OverLoad?
		jmp	MotorOverLoad
		return

MotorTimeOut:	movlw	SJM_STR
		btfss	SH_MOTOR_ADD, SH_MOTOR_BIT	; Is this Motor On?
		movlw	DJM_STR
		call	MotorsOff
		call	SendString
		jmp	Wait4StartSwitch

MotorOverLoad:	call	MotorsOff
		movlw	MOV_STR
		call	SendString
		jmp	Wait4StartSwitch

Wait4StartSwitch:
		SET_TIMER	START_SW_TIME

W4swLoop:	btfsc	SW_START_ADD, SW_START_BIT
		jmp	Wait4StartSwitch
		btfss	TIME_FLAGS, 1			; Done Waiting?
		jmp	W4swLoop			; NO
		jmp	Main				; YES

