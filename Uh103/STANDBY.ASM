



























        if ( STAND_BY )
StandBy:	
                movlw   SBCON_STR
                call    StrTbl2Ln1
                movlw   ENTER_STR
                call    StrTbl2Ln2


		movlw	D'8'
		movwf	MSD

sbtim:		movlw	D'250'
		movwf	LSD
		clr     LCD_TIME_FLAG
		

Jxloop:		call	TestHiTemp

		jnb     LCD_TIME_FLAG, Jx1Lop
		clr     LCD_TIME_FLAG
		decfsz	LSD, F
		jmp	Jx1Lop
		decfsz	MSD, F
		jmp	sbtim
		jmp	MainLoop
Jx1Lop:
		clr     APP_KEY_HIT
                call    ReadKeyPad
                jnb     APP_KEY_HIT, Jxloop
        	movf    AppKeyVal, W
		xorlw	NULL
		jnz	Jxloop   ; Stay here if wrong key

                clr     LED_LED
                movlw   STD_STR
		call    StrTbl2Ln1


StdByAgain:

                jnb     SN_TEMP_LO, ShowTempLow
; Temp is not that low...
                call    SetCOOL_FAN
                movlw   BON_STR	
		jmp     ShowTempStat


ShowTempLow:
                call    ClearCOOL_FAN
                movlw   BOF_STR	


ShowTempStat:
		call    StrTbl2Ln2





StandByLoop:
                clr     SOL_UV_ON

                jnb     SN_TEMP_LO, Show1TempLow
                jb      SOL_COOL_FAN, StdByAgain
		jmp     Show1TempStat

Show1TempLow:
                jnb     SOL_COOL_FAN, StdByAgain
Show1TempStat:



		clr     APP_KEY_HIT
                call    ReadKeyPad
                jnb     APP_KEY_HIT, StandByLoop
        	movf    AppKeyVal, W
		xorlw	NULL
		jnz	StandByLoop
                jmp     WarmUp

	endif