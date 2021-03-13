	;��������������������������������������������������������������Ŀ
	;� Func : BeepInit						�
	;��������������������������������������������������������������Ĵ
	;� In   : 							�
	;� Out  :							�
	;� Dest :							�
	;� Comm :							�
	;� Hist : 03/12/97 Initial Cut				Randy	�
	;����������������������������������������������������������������
BeepInit:	movlw	PWM_PERIOD
		bcf	INTCON, GIE     ; Disable all Interrupts
		Bank_1
		movwf	PR2
		Bank_0
		bsf	INTCON, GIE     ; Enable all Interrupts


		movlw	PWM_PERIOD >> 1
		movwf	CCPR1L

		clrw
		movwf	CCP1CON

		movlw	B'00000111'
		movwf	T2CON
		return

	;��������������������������������������������������������������Ŀ
	;� Func : BeepOn						�
	;��������������������������������������������������������������Ĵ
	;� In   : 							�
	;� Out  :							�
	;� Dest :							�
	;� Comm :							�
	;� Hist : 03/12/97 Initial Cut				Randy	�
	;����������������������������������������������������������������
BeepOn:		movlw	((( PWM_PERIOD << 4 ) & ( 0x30 )) | 0x0C )
		movwf	CCP1CON
		return

	;��������������������������������������������������������������Ŀ
	;� Func : BeepOff						�
	;��������������������������������������������������������������Ĵ
	;� In   : 							�
	;� Out  :							�
	;� Dest :							�
	;� Comm :							�
	;� Hist : 03/12/97 Initial Cut				Randy	�
	;����������������������������������������������������������������
BeepOff:	clrw
		movwf	CCP1CON
		return

