
Mul_10:		movlw	D'10'
		movwf	DIV_L
		clrw
		movwf	DIV_H


Multiply:
;	ANS = QUO * DIV			; The Multiply...
	
;	ANS = 0				; Zero out the answer,
	
		movlw	D'16'
		movwf	MSD		; Loop Counter....
		clrw
		movwf	ANS_H
		movwf	ANS_L		; Answer = Zero,

;	Start:				;  The Main loop Start...

mul_start:
	
;	DIV >> 1			; Shift DIV to the Right by 1
					;  with LSB going into Carry.
		bcf	STATUS, C
		rrf	DIV_H, F
		rrf	DIV_L, F

;	if (CARRY)			;  If the carry flag is set
;	 { ANS += QUO;			;  Add the Tempory Value to the
;	 				;   Answer.
;	 }
		btfss	STATUS, C
		jmp	NotMulCarry
		movf	QUO_L, W
		addwf	ANS_L, F
		btfsc	STATUS, C
		incf	ANS_H, F
		movf	QUO_H, W
		addwf	ANS_H, F
NotMulCarry:	


;	CARRY = 0	
		bcf	STATUS, C


;	QUO << 1			; Shift QUO to the left by 1,
;					;  we don't care about the carry.
		rlf	QUO_L, F
		rlf	QUO_H, F

;	loop Start			; Stay in the loop for the number
					; bits that are being Multiplied..
		decfsz	MSD, F
		jmp	mul_start
	
;	ANS now has the Answer......
		return
;



Devide_100:	movlw	D'100'
		jmp	Div0

Devide_10:	movlw	D'10'
Div0:		movwf	DIV_L
		clrw
		movwf	DIV_H
Devide:
		movlw	D'16'		; 16 Bit devide.....
		movwf	MSD		; Loop Counter....

;	ANS = QUO / DIV			; The Devide...
	
;	ANS = 0				; Zero out the answer,
;	TMP = 0				;  and a tempory Value...
		clrw
		movwf	ANS_H
		movwf	ANS_L		; Answer = Zero,
		movwf	TMP_H
		movwf	TMP_L		; Temp = Zero,
	
;	Start:				;  The Main loop Start...
div_start:	

;	CARRY = 0	
		bcf	STATUS, C

;	QUO << 1			; Shift QUO to the Left by 1
					;  with MSB going into Carry.
		rlf	QUO_L, F
		rlf	QUO_H, F
;	TMP << 1			; Shift TMP to the Left by 1,
					;  with MSB of QUO going into LSB
					;  of TMP, with MSB going into Carry.
		rlf	TMP_L, F
		rlf	TMP_H, F

;	CARRY = 0	
		bcf	STATUS, C

;	ANS << 1			; Shift ANS to the Left by 1,
		rlf	ANS_L, F
		rlf	ANS_H, F

;	if (TMP >= DIV)			;  If TMP is greater or equal to DIV
;	 { TMP -= DIV;			;  Subtract DIV from TMP,
;	   ANS |= 1;			;   and Set LSB of the Answer.
;	 }

		movf	TMP_H, W
		subwf	DIV_H, W	; DIV_H - TMP_H(w)
					; if TMP_H <= DIV_H C=1
					;    DIV_H >= TMP_H C=1
					;    DIV_H <  TMP_H C=0
		btfss	STATUS, C	;    TMP_H >  DIV_H C=0
		jmp	Tmp_gt_Div	; C=0

		btfss	STATUS, Z
		jmp	Tmp_lt_Div	; Z=0
		movf	TMP_L, W
		subwf	DIV_L, W	; if TMP_L <= DIV_L C=1
					;    DIV_L >= TMP_L C=1
					;    DIV_L <  TMP_L C=0
		btfss	STATUS, C	;    TMP_L >  DIV_L C=0
		jmp	Tmp_gt_Div	; C=0
		btfss	STATUS, Z	;
		jmp	Tmp_lt_Div	; Z=0
Tmp_equ_Div:
Tmp_gt_Div:
		movf	DIV_L, W
		subwf	TMP_L, F
		btfss	STATUS, C
		decf	TMP_H, F
		movf	DIV_H, W
		subwf	TMP_H, F

		bsf	ANS_L, 0
Tmp_lt_Div:
	
;	loop Start			; Stay in the loop for the number
					; bits that are being Multiplied..
		decfsz	MSD, F
		jmp	div_start
;	ANS now has the Answer......
;	TMP now has the Remainder...
		return
;