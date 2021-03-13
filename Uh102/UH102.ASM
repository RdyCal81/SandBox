
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
            INCLUDE <UH102.inc>
            INCLUDE <CONSTANT.ASM>
            include <SWITCHES.ASM>
            include <MACROS.ASM>
            include <RAM.ASM>
            include <VECTORS.ASM>
            include <TABLES.ASM>
            include <BOOT.ASM>

;
;
Main:		call	TestDoorLatch	; Stays here until Door is closed
	if ( GOT_SHUTTER )
		bsf	DOOR_L_ADD, DOOR_L_BIT	; Set the Door Latch
		call	CloseShutter
	endif
		call	UVon
		call	N2on
		movlw	UH1_STR
		call	SendString
	;102	call	Wait500ms
	;102	call	CloseDrawer
	if ( WARM_UP )
		call	WarmUp
	endif	; ( WARM_UP )
;;;;;;;		call	N2off
	;102	call	OpenDrawer
		call	LED_On


	; -------------	The door is closed, UV is on N2 is off
	;		We're ready now

Main1:		movlw	RDY_STR		; Display Ready
		call	SendString
		call	N2off


		; Put 120 seconds into the two minute counter.
		;   two minutes = 120 seconds.
		movlw	D'120'
		movwf	TWO_MINUTE_CNTR

		movlw	D'3'
		movwf	STANDBY_CNT
		jmp	MainLoop_x
DisplayNotReady:
		movlw	NOT_RDY
		call	SendString
MainLoop_x:
		bcf	FLAGSPLUS, 3

MainLoop:	; Turn Off motors again and again here...
	if ( GOT_SHUTTER )
		call	CloseShutter
		call	UVon
	else
		call	UVoff
	endif
		call	N2off
	if ( GOT_SHUTTER )
		bcf	DOOR_L_ADD, DOOR_L_BIT	; Clear the Door Latch
	endif
		btfsc	DOOR_IN_ADD, DOOR_IN_BIT	; Don't turn off if 
		call	LED_On				; door not open

		btfsc	FLAGSPLUS, 3
		jmp	DisplayNotReady

		call	ReadTimeSw
		btfsc	STATUS, C	; C=0 means "TIME" not pushed.
		jmp	MainTime	; C=1 means Go do time..

		call	ReadStartSw
		btfsc	STATUS, C	; C=0 means "START" not pushed.
		jmp	DoStart		; C=1 means Go do Start..

	;	call	ReadAbortSw
	;	btfsc	STATUS, C	; C=0 means "ABORT" not pushed
	;	call	DoAbort		; C=1 means Go do Abort

		call	ReadStandBySw
		
		call	UpdateLED

		jmp	MainLoop


ReMain:
	if ( GOT_SHUTTER )
		call	CloseShutter
	endif
		call	UVon
	;102	call	Wait500ms
	;102	call	OpenDrawer
		call	N2off
		call	LED_Blink
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

DoStart:	call	TestDoorLatch
		btfsc	DOOR_IN_ADD, DOOR_IN_BIT
		jmp	Main1

	if ( GOT_SHUTTER )
		bsf	DOOR_L_ADD, DOOR_L_BIT	; Set the Door Latch
	endif
		call	LED_Off

		movf	R_TIME_L, W
		iorwf	R_TIME_H, W
		btfsc	STATUS, Z			; N_0001
		jmp	DoStartTime

; Say "PREEXPOSE PURGE" while Chamber is filling up with Nitrogen 01.08.98 (dt)
	if ( GOT_SHUTTER )
		movlw	PRE_EXP
	else
		movlw	WU_STR
	endif
		call	SendString
		call	N2on

	if ( GOT_SHUTTER == FALSE )
		setb	UV_LAMP
	endif

	;102	call	CloseDrawer


;	; ------------- Now Wait for xSeconds until the chamber fills up
;	; ------------- with Nitrogen
;; Added Delay between N2on() and OpenShutter() 01.05.98 (dt)
		SET_TIMER	WAIT_BTWN_N2_AND_SHUT
W4n2ToFill:	btfsc	DOOR_IN_ADD, DOOR_IN_BIT
		jmp	DoAbort			; Door is Opened

		movlw	SW_DEBOUNCE		; Prepare Working Register.
		btfsc	SW_ABORT_ADD, SW_ABORT_BIT
		movwf	R_y1MS			; R_y1MS = 'w' if not pushed
		btfsc	TIME_FLAGS, 5		; Bit 5 is timer R_y1MS
		jmp	DoAbort			; Abort Button Pushed

		btfss	TIME_FLAGS, 1			; Done Waiting?
		jmp	W4n2ToFill			; NO
							; YES
	; ------------- The Chamber is now filled with Nitrogen

; Say "EXPOSURE TIME" after "PREEXPOSE PURGE"  01.08.98 (dt)
		movlw	EXP_STR
		call	SendString

	if ( GOT_SHUTTER )
		call	OpenShutter
	endif
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
		
S_001:		call	LED_Off
	if ( GOT_SHUTTER )
		btfsc	DOOR_IN_ADD, DOOR_IN_BIT
		jmp	ReMain
	else
		DOOR_CHECK
	endif


		movlw	SW_DEBOUNCE		; Prepare Working Register.

; N_0007	btfsc	SW_START_ADD, SW_START_BIT
; N_0007	movwf	R_x1MS
; N_0007	btfsc	TIME_FLAGS, 4		; Bit 4 is 1ms, Rx_1ms
; N_0007	jmp	ReMain			; Start Switch Pushed.

	; N_0004
		btfsc	SW_ABORT_ADD, SW_ABORT_BIT
		movwf	R_y1MS			; R_y1MS = 'w' if not pushed
		btfsc	TIME_FLAGS, 5		; Bit 5 is timer R_y1MS
		jmp	DoAbort			; Start InOut Pushed.

		btfss	TIME_FLAGS, 2		; Bit 2 is 1 Second...
		jmp	S_001
		
		movf	TIME_L, W
		iorlw	NULL
		btfss	STATUS, Z
		jmp	NotSZero
		movf	TIME_H, W
		iorlw	NULL
		btfsc	STATUS, Z
		jmp	ReMain		; Return if Timer is Zero..
		decf	TIME_H, F
NotSZero:	decf	TIME_L, F
		jmp	StartLoop



DoAbort:
	if ( GOT_SHUTTER )
		call	CloseShutter
	endif
		call	LED_Blink
		jmp	ReMain


	;102	btfsc	DR_OUT_ADD, DR_OUT_BIT		; Drawer In?
	;102	jmp	SendOut
	;102	call	N2on
	;102	call	CloseDrawer
	;102	call	Wait500ms
	;102	call	OpenShutter

	;102	movlw	IN_OUT_MAXIMUM
	;102	call	StartTimer
		bsf	FLAGSPLUS, 0		; Set LED flag to Blinking
		bcf	FLAGSPLUS, 2
		jmp	Main




;102InOutNoKey:	movlw	SW_DEBOUNCE
;102		movwf	MSD
;102
;102InOutLoop:	btfss	TIME_FLAGS, 0	; Test for 1ms.
;102		jmp	InOutLoop
;102		bcf	TIME_FLAGS, 0	; Reset the ms Flag.
;102		
;102		btfsc	TIME_FLAGS, 1			; TimeOut?
;102		jmp	ReMain
;102
;102		btfsc	SW_INOUT_ADD, SW_INOUT_BIT
;102		jmp	InOutNoKey
;102
;102		decfsz	MSD, F
;102		jmp	InOutLoop
;102		jmp	ReMain
;102
;102
;102
;102SendOut:	jmp	ReMain

;;		jmp	ReMain










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
	if ( WARM_UP )
WarmUp:		movlw	WU_STR
		call	SendString
		call	StartWarmUpTimer
WarmUpLoop:	call	DisplayTime
if ( GOT_SHUTTER == FALSE )

endif	; ( GOT_SHUTTER == FALSE )
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
	endif	; ( WARM_UP )

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


TestDoorLatch:	btfss	DOOR_IN_ADD, DOOR_IN_BIT
		return
		movlw	DOR_STR
		call	SendString
TDL0a:		btfsc	DOOR_IN_ADD, DOOR_IN_BIT
		jmp	TDL0a
	if ( GOT_SHUTTER )
		bsf	DOOR_L_ADD, DOOR_L_BIT	; Set the Door Latch
	endif
		return



	    include <LED.ASM>
            include <PORTS.ASM>
            include <TIME.ASM>
            include <LCD.ASM>
            include <MATH_LIB.ASM>
            include <MOTORS.ASM>
            include <BEEP.ASM>
            include <EXT_INT.ASM>
    end

