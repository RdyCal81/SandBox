
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








DOOR_CHECK	MACRO
	if ( GOT_SHUTTER == FALSE )
		call	StayIfDoorOpen
	endif
		ENDM		




; *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
; *-*-*-*-*-  8051 style programming macros.   -*-*-*-*-*-*-*-*-*-*-*-*-*-*-
; *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
setb		MACRO	BitVal
		bsf	BitVal / 8, BitVal & 7
		ENDM

clr		MACRO	BitVal
		bcf	BitVal / 8, BitVal & 7
		ENDM



jb		MACRO	BitVal, Add
		btfsc	BitVal / 8, BitVal & 7
		jmp		Add				
		ENDM

jnb		MACRO	BitVal, Add
		btfss	BitVal / 8, BitVal & 7
		jmp		Add				
		ENDM
