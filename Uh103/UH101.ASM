
	LIST	P = 16C65A
	LIST	F = INHX8M
	__CONFIG	0x1FF2		; 0x1FF2
	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : DebugPntf						³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³      :							³
	;³ Hist : 03/05/97 Began				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            INCLUDE <PIC16C64.h>
            INCLUDE <Uh101.inc>
            INCLUDE <CONSTANT.ASM>
            include <SWITCHES.ASM>
            include <MACROS.ASM>
            include <RAM.ASM>
            include <VECTORS.ASM>
            include <TABLES.ASM>
            include <BOOT.ASM>

;
;

Main:		call	UVon
		call	N2on
		movlw	UH1_STR
		call	SendString
		call	CloseShutter
		call	Wait500ms
		call	CloseDrawer
		call	WarmUp
;;;;;;;		call	N2off
		call	OpenDrawer
		call	N2off
Main1:		movlw	RDY_STR
		call	SendString


MainLoop:	; Turn Off motors again and again here...
		call	ReadTimeSw
		btfsc	STATUS, C	; C=0 means "TIME" not pushed.
		jmp	MainTime	; C=1 means Go do time..

		call	ReadStartSw
		btfsc	STATUS, C	; C=0 means "START" not pushed.
		call	DoStart		; C=1 means Go do Start..

		call	ReadInOutSw
		btfsc	STATUS, C	; C=0 means "INOUT" not pushed.
		call	DoInOut		; C=1 means Go do InOut..

		call	ReadStandBySw

		jmp	MainLoop


CureComplete:
		bsf	FxLAGS, 1	; Indicate Cure Complete

ReMain:		call	UVon
		call	CloseShutter
		call	Wait500ms
		call	OpenDrawer
		call	N2off
		jmp	Main1


	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : Input the Times.					³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/04/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MainTime:	movlw	EXP_STR
		call	DoTime
		jmp	Main1

DoTime:		call	SendString
		movf	R_TIME_L, W
		movwf	TIME_L
		movf	R_TIME_H, W
		movwf	TIME_H
TimTime:	call	DisplayTime
		call	TimeGoAway
DtLoop:		call	ReadTimeSw
		btfsc	STATUS, C	; C=0 means "TIME" not pushed.
		jmp	TimeGoAwaywClr	; Jump if pushed.
		call	ReadSwitches
		btfss	STATUS, C	; C=0 means "SWITCHES" not pushed.
		jmp	DtLoop
		movwf	TEMP		; Keep The key pressed.

		movf	TIME_L, W	; Multiply the old Time by 10.
		movwf	QUO_L
		movf	TIME_H, W
		movwf	QUO_H
		call	Mul_10
		
		movf	TEMP, W		; Now add in the Key Pressed.
		addwf	ANS_L, F
		btfsc	STATUS, C
		incf	ANS_H, F

					; Now test for greater than the
					; maximum alowable time.........
		movlw	HIGH MAXIMUM_TIME
		subwf	ANS_H, W	; if MAXIMUM_TIME <= ANS_H C=1
					;    ANS_H >= MAXIMUM_TIME C=1
					;    ANS_H <  MAXIMUM_TIME C=0
		btfss	STATUS, C	;    MAXIMUM_TIME >  ANS_H C=0
		jmp	IsOk
		btfss	STATUS, Z	;    ANS_H == MAXIMUM_TIME C=1
		jmp	TooBig

		movlw	LOW MAXIMUM_TIME
		subwf	ANS_L, W	; if MAXIMUM_TIME <= ANS_L C=1
					;    ANS_L >= MAXIMUM_TIME C=1
					;    ANS_L <  MAXIMUM_TIME C=0
		btfss	STATUS, C	;    MAXIMUM_TIME >  ANS_L C=0
		jmp	IsOk
		btfsc	STATUS, Z	;    ANS_L == MAXIMUM_TIME C=1
		jmp	IsOk
TooBig:		clrw
		movwf	TEMP
		movwf	ANS_H
		movwf	ANS_L
IsOk:		movf	ANS_L, W
		movwf	TIME_L
		movf	ANS_H, W
		movwf	TIME_H

		call	DisplayTime
		call	SwitchGoAway
		jmp	DtLoop

TimeGoAwaywClr:	;;call	ClearLCD		; N_0001
TimeGoAway:	movlw	SW_DEBOUNCE
		movwf	T_1MS
		bcf	TIME_FLAGS, 3
TimeAwayOk:	btfss	SW_TIME_ADD, SW_TIME_BIT
		jmp	TimeGoAway	; Wait to let go of the switch.
		btfss	TIME_FLAGS, 3
		jmp	TimeAwayOk

		movf	TIME_L, W	; Keep the value...
		movwf	R_TIME_L
		movf	TIME_H, W
		movwf	R_TIME_H
		return
		


DoStartTime:	movlw	SET_STR
		call	DoTime
		jmp	Main1				; N_0005


DoStart:	movf	R_TIME_L, W
		iorwf	R_TIME_H, W
		btfsc	STATUS, Z			; N_0001
		jmp	DoStartTime
		bcf	FxLAGS, 1	; Indicate NotCured Yet

		movlw	EXP_STR
		call	SendString
		call	N2on
		call	CloseDrawer
		call	OpenShutter

		movf	R_TIME_L, W
		movwf	TIME_L
		movf	R_TIME_H, W
		movwf	TIME_H
		call	StartTimer
		
		movlw	SW_DEBOUNCE
		movwf	R_x1MS
		movwf	R_y1MS
		bcf	TIME_FLAGS, 4
StartLoop:	call	DisplayTime
		
S_001:		movlw	SW_DEBOUNCE		; Prepare Working Register.

; N_0007	btfsc	SW_START_ADD, SW_START_BIT
; N_0007	movwf	R_x1MS
; N_0007	btfsc	TIME_FLAGS, 4		; Bit 4 is 1ms, Rx_1ms
; N_0007	jmp	ReMain			; Start Switch Pushed.

	; N_0004
		btfsc	SW_INOUT_ADD, SW_INOUT_BIT
		movwf	R_y1MS
		btfsc	TIME_FLAGS, 5		; Bit 5 is 1ms, Ry_1ms
		jmp	ReMain			; Start InOut Pushed.

		btfss	TIME_FLAGS, 2		; Bit 2 is 1 Second...
		jmp	S_001
		
		movf	TIME_L, W
		iorlw	NULL
		btfss	STATUS, Z
		jmp	NotSZero
		movf	TIME_H, W
		iorlw	NULL
		btfsc	STATUS, Z
		jmp	CureComplete		; Return if Timer is Zero..
		decf	TIME_H, F
NotSZero:	decf	TIME_L, F
		jmp	StartLoop





DoInOut:	btfsc	DR_OUT_ADD, DR_OUT_BIT		; Drawer In?
		jmp	SendOut
		call	N2on
		call	CloseDrawer
		call	Wait500ms
		call	OpenShutter

		movlw	IN_OUT_MAXIMUM
		call	StartTimer

InOutNoKey:	movlw	SW_DEBOUNCE
		movwf	MSD

InOutLoop:	btfss	TIME_FLAGS, 0	; Test for 1ms.
		jmp	InOutLoop
		bcf	TIME_FLAGS, 0	; Reset the ms Flag.
		
		btfsc	TIME_FLAGS, 1			; TimeOut?
		jmp	ReMain

		btfsc	SW_INOUT_ADD, SW_INOUT_BIT
		jmp	InOutNoKey

		decfsz	MSD, F
		jmp	InOutLoop
		jmp	ReMain



SendOut:	jmp	ReMain



		jmp	ReMain










DoSwitches:	movlw	SET_STR
		call	SendString
		return


	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : WarmUp						³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm : Display "WARMING UP xxx", xxx being the time..	³
	;³ Hist : 03/07/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WarmUp:		movlw	WU_STR
		call	SendString
		call	StartWarmUpTimer
WarmUpLoop:	call	DisplayTime
		
WU_001:		btfss	TIME_FLAGS, 2	; Bit 2 is a 4...
		jmp	WU_001
		
		movf	TIME_L, W
		iorlw	NULL
		btfss	STATUS, Z
		jmp	NotWUZero
		movf	TIME_H, W
		iorlw	NULL
		btfsc	STATUS, Z
		return			; Return if Timer is Zero..
		decf	TIME_H, F
NotWUZero:	decf	TIME_L, F
		jmp	WarmUpLoop


SendString:	call	ClearLCD
SSu:		movf	LCD_ADD, W
		xorlw	8
		btfsc	STATUS, Z
		call	LCD_ln2
		incf	LCD_ADD, F
		movf	LCD_LOOP, W		; Get the Index..
		call	StringTable		; Get the Indexed Data.
		iorlw	NULL
		btfsc	STATUS, Z
		return
		call	LCD_Data
		incf	LCD_LOOP, F
		jmp	SSu

            include <PORTS.ASM>
            include <TIME.ASM>
            include <LCD.ASM>
            include <MATH_LIB.ASM>
            include <MOTORS.ASM>
            include <BEEP.ASM>
            include <EXT_INT.ASM>
    end

