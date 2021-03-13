

jmp		MACRO	GotoAddress
		goto	GotoAddress
		ENDM

Bank_0		MACRO
		bcf	STATUS, RP0     ; Bank 0
		ENDM

Bank_1		MACRO
		bsf	STATUS, RP0     ; Bank 1
		ENDM

TIME		MACRO	Tval
		movlw	HIGH Tval
		movwf	TIME_H
		movlw	LOW Tval
		movwf	TIME_L
		ENDM


QUO		MACRO	Qval
		movlw	HIGH Qval
		movwf	QUO_H
		movlw	LOW Qval
		movwf	QUO_L
		ENDM

clr             MACRO   Value
                bcf	Value / 8, Value & 7
                ENDM

setb            MACRO   Value
                bsf	Value / 8, Value & 7
                ENDM

jb              MACRO   BitVal, Address
                btfsc	BitVal / 8, BitVal & 7
		goto	Address
                ENDM


retb            MACRO   BitVal
                btfsc	BitVal / 8, BitVal & 7
		return
                ENDM

retnb           MACRO   BitVal
                btfss	BitVal / 8, BitVal & 7
		return
                ENDM






jnb             MACRO   BitVal, Address
                btfss	BitVal / 8, BitVal & 7
		goto	Address
                ENDM


jz              MACRO   Address
                btfsc	ZERO / 8, ZERO & 7
		goto	Address
                ENDM

jnz             MACRO   Address
                btfss	ZERO / 8, ZERO & 7
		goto	Address
                ENDM

jc              MACRO   Address
                btfsc	CARRY / 8, CARRY & 7
		goto	Address
                ENDM

jnc             MACRO   Address
                btfss	CARRY / 8, CARRY & 7
		goto	Address
                ENDM






	if ( NO )

SET_TIMER	MACRO	THE_TIME
		incf	T_1MS, F	; Just make sure it doesn't roll over
		incf	T_1MS, F	; while we are setting it...
		movlw	( THE_TIME / D'1000' ) + 1
		movwf	T_SEC
		movlw	(( THE_TIME % D'1000' ) / D'100' ) + 1
		movwf	T_100MS
		movlw	( THE_TIME % D'100' ) + 1
		movwf	T_1MS
		clrw
		movwf	TIME_FLAGS	; Clear all of the bits...
		ENDM
        endif

	
