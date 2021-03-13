

;Timer 0 Notes
;  12,000,000            =   OcsFreq
;   3,000,000            =   OcsFreq/4
;     187,500.0          =  (OcsFreq/4)/16
;      93,750.0          =  (OcsFreq/4)/32
;      46,875.0          =  (OcsFreq/4)/64
;      23,437.5          =  (OcsFreq/4)/128
;      11,718.75         =  (OcsFreq/4)/256
;          45.7763671875 = ((OcsFreq/4)/256)/256

; 200 PPR, Pulses Per Revolution
; 2.12 Revolutions per second, at slow speed
; 10.00 Reveloutions per second, at fast speed


; 848  =  424 * 2 = Slow speed = (200 *  2.12 * 2) pulses per second
; 4000 = 2000 * 2 = Fast speed = (200 * 10.00 * 2) pulses per second

; prescaler = 256
; 14 is slow speed;
; 3 is fast... speed


; prescaler = 128
; 27.6 is slow
; 5.8 is fast


; prescaler = 64
; 55.27 is slow
; 11.7 is fast


; prescaler = 32
; 110.5 is slow
; 23.4 is fast

; prescaler = 16
; 221.1 is slow
; 46.8 is fast
;





InitTimer0      MACRO
		Bank_1
                movlw   B'00000011'
		movwf   OPTION_REG      ; 011 is the prescaler 1:16
		                        ; 111 is the prescaler 1:256


        	Bank_0
		movf    MotorSpeed, W
		movwf   TMR0
                ENDM
		
Timer0Off       MACRO
		bcf     INTCON, RTIE	; 
                ENDM

Timer0On        MACRO
		bsf     INTCON, RTIE	; 
                ENDM


T0_Interrupt:	
		movwf	SAVE_W
		swapf	STATUS, W
		movwf	SAVE_S

		movf    MotorSpeed, W
		movwf   TMR0
                setb    TIME0_MOD


		jnb     MOT_ENA, MotorsOff
                jb      MOT_STEP, ClrMotStep
		jnb     MOT_DIR, TestForHome            ; 0 = Motor Direction toward Home
		                                        ; 1 = Motor Direction toward Back
TestForMax:    ;jnb     SN_TABLE_BACK, TurnMotorOff

		movf	TableCnt + 1, W
                sublw   HIGH MAX_TABLE_MOVE
		jb      ZERO, TestLowerTableCntMax
                jb      CARRY, Ok2IncTableCnt
                jmp     TurnMotorOff
TestLowerTableCntMax:
		movf	TableCnt, W
                sublw   LOW MAX_TABLE_MOVE
		jb      ZERO, TurnMotorOff
                jb      CARRY, Ok2IncTableCnt
                jmp     TurnMotorOff

Ok2IncTableCnt:
		incf	TableCnt, F
		movf	TableCnt, W
		andlw	0FFh
		jnb     ZERO, MotorStep
		incf	TableCnt + 1, F
		jmp     MotorStep


TestForHome:
                jnb     SN_TABLE_HOME, Ok2DecMotorExtra 
		movf	TableCnt + 1, W
                iorwf   TableCnt, W
		jb      ZERO, TurnMotorOff
Ok2DecTableCnt:
		decf	TableCnt, F
		movf	TableCnt, W
		xorlw	0FFh
		jnb     ZERO, MotorStep
		decf	TableCnt + 1, F
		jmp     MotorStep

Ok2DecMotorExtra:
		movf	Motor_Extra, W
		andlw	0FFh
		btfsc	STATUS, Z
		jmp     TurnMotorOff
		decf	Motor_Extra, F

		
MotorStep:      setb    MOT_STEP
		jmp     EndMotStep 
ClrMotStep:     clr     MOT_STEP
EndMotStep:




MotorsOff:

            	jmp	TMOxx

TurnMotorOff:   clr     MOT_ENA
                clr     MOT_STEP
TMOxx:

		swapf	SAVE_S, W
		movwf	STATUS
		swapf	SAVE_W, F
		swapf	SAVE_W, W
		bcf     INTCON, RTIF	; Clear Timer 0 Interrupt Flag

        	retfie





InitTimer       MACRO
                Bank_0
		movlw	HIGH TIME_VAL	;
		movwf	TMR1H		;
		movlw	LOW TIME_VAL	;
		movwf	TMR1L		;

		clrf	PIR1		; Clear Interrupt Flags...
		
		Bank_1
		bsf	INTCON, PEIE    ; Enable Perifial interrupts.
		bsf	PIE1, TMR1IE	; Enable Timer1 Interrupt.

		Bank_0
		clrf	T1CON           ; Enable Nothing.
		bsf	T1CON, TMR1ON   ; Turn Timer 1 ON

		ENDM






	; -----------------------------------------------------------------
T1_Interrupt:
Push:		movwf	SAVE_W
		swapf	STATUS, W
		movwf	SAVE_S


		
TryAgain:	movf	TMR1H, W
		movwf	INT_WH		; Save for later compare..
		movf	TMR1L, W
		movwf	INT_WL

		movf	TMR1H, W
		subwf	INT_WH, W
		btfss	STATUS, Z
		goto	TryAgain
		
		movf	INT_WL, W
		bcf	STATUS, C
		addlw	LOW ( TIME_VAL + 4 )
		btfsc	STATUS, C
		incf	INT_WH, F
		movf	INT_WH, W
		addlw	HIGH ( TIME_VAL + 4 )
		movwf	TMR1H

	
		movlw	0xFF
		movwf   TIME_FLAGS

		decf	T_1MS, F
		
	
		movf	Debounce, W
		iorwf	Debounce + 1, W
		btfsc	STATUS, Z
		goto	Pop		; Don't dec if already Zero

		decf	Debounce, F
		movf	Debounce, W
		xorlw	0FFh
		btfsc	STATUS, Z
		decf	Debounce + 1, F	; Dec the upper byte if needed


Pop:		swapf	SAVE_S, W
		movwf	STATUS
		swapf	SAVE_W, F
		swapf	SAVE_W, W

        	bcf	PIR1, TMR1IF	; Clear Timer 1 Interrupt Flag

Ext_Interrupt:
ExRROR1:	retfie


TWO_MINUTES	equ	D'180000' - D'1'
T2_H            equ     (TWO_MINUTES / 0x10000 ) 
T2_M            equ     ((TWO_MINUTES / 0x100 ) & 0xFF )
T2_L            equ     ((TWO_MINUTES )  & 0xFF )

VER_TIME        equ	D'5000' - D'1'
TVerH           equ     (VER_TIME / 0x10000 ) 
TVerM           equ     ((VER_TIME / 0x100 ) & 0xFF )
TVerL           equ     ((VER_TIME )  & 0xFF )

LCD_TIME        equ	D'2000' - D'1'
TLcdH           equ     (LCD_TIME / 0x10000 ) 
TLcdM           equ     ((LCD_TIME / 0x100 ) & 0xFF )
TLcdL           equ     ((LCD_TIME )  & 0xFF )



StartLCDStrTimer:
        if      ( !NO_START_TIMER )
          if ( NEW_TIME_DISPLAY )
	  else
                movlw   TLcdL
		movwf	T_2MIN_L
                movlw   TLcdM
		movwf	T_2MIN_L + 1
                movlw   TLcdH
		movwf	T_2MIN_L + 2
	  endif
		jmp     SecTimer
        endif



StartVerTimer:
        if      ( !NO_START_TIMER )
          if ( NEW_TIME_DISPLAY )
	  else
                movlw   TVerL
		movwf	T_2MIN_L
                movlw   TVerM
		movwf	T_2MIN_L + 1
                movlw   TVerH
		movwf	T_2MIN_L + 2
	  endif
		jmp     SecTimer
        endif

Start2SecTimer:
        if      ( !NO_START_TIMER )
          if ( NEW_TIME_DISPLAY )
SecTimer: 
          else
	        movlw   T2_L
		movwf	T_2MIN_L
                movlw   T2_M
		movwf	T_2MIN_L + 1
                movlw   T2_H
		movwf	T_2MIN_L + 2

SecTimer:       clr     MIN2_FLAG
		movf	T_1MS, W                ; Get current ms counter
		movwf   T_2MIN_CMP              ; Keep for the compare.
	  endif
        endif
	
Update2SecTImer:
        if      ( !NO_START_TIMER )
          if ( NEW_TIME_DISPLAY )
          else
                movf    T_1MS, W
		movwf	TEMP

                ; W and TEMP are equal to T_1MS
		subwf   T_2MIN_CMP, W           ; W = T_2MIN_CMP - T_1MS
		subwf   T_2MIN_L, F             ; Subtract the differnece,
		                                ;  keep in file T_2MIN_L
		btfsc	STATUS, C	        ;
		jmp	End2SecTimUpdate        ;

		setb    TMP_FLAG_1
		decf	T_2MIN_L + 1, F
                movf    T_2MIN_L + 1, W
		xorlw	0xFF
		btfss	STATUS, Z
		jmp	End2SecTimUpdate        ;
		
		decf	T_2MIN_L + 2, F
                movf    T_2MIN_L + 2, W
		xorlw	0xFF
		btfss	STATUS, Z
		jmp	End2SecTimUpdate        ;

                setb    MIN2_FLAG
                clrw	
		movwf	T_2MIN_L
		movwf	T_2MIN_L + 1
		movwf	T_2MIN_L + 2

End2SecTimUpdate:
		movf	TEMP, W                 ; Get current ms counter
		movwf   T_2MIN_CMP              ; Keep for the compare.
		return
          endif
        else
          if ( NEW_TIME_DISPLAY )
          else
                setb    MIN2_FLAG
	  endif
                return
	endif	        







;		movf	TMP_H, W
;		subwf	DIV_H, W	; DIV_H - TMP_H(w)
					; if TMP_H <= DIV_H C=1
					;    DIV_H >= TMP_H C=1
					;    DIV_H <  TMP_H C=0
;		btfss	STATUS, C	;    TMP_H >  DIV_H C=0
;		jmp	Tmp_gt_Div	; C=0











Wait_LCD_1:	movwf	MSD	                ; Use MSD and LSD Registers to Initilize LCD
WaitLoop:	jnb     LCD_TIME_FLAG, WaitLoop
		clr     LCD_TIME_FLAG

		decfsz	MSD, F
		jmp	WaitLoop
		
		movf	LCD_VAL, W
		movwf	LCD_DATAP
		jmp	BobbleEnable



Wait500ms:	movlw	D'250'
		call	Wait
Wait250ms:	movlw	D'250'


Wait:		movwf	MSD	                ; Use MSD and LSD Registers to Initilize LCD
		clr     LCD_TIME_FLAG
WaitL:		jnb     LCD_TIME_FLAG, WaitL
		clr     LCD_TIME_FLAG
		decfsz	MSD, F
		jmp	WaitL
		return


