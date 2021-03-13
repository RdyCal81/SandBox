
	; Power on Reset / WatchDog Timer and MCLR Reset....
        if      ( ABORT_ACTIVE )

Abort.Asm:
	; -----------------------------------------------------
                movlw   ABORT_STR
		call    StrTbl2Ln1

                movlw   PAK_STR
		call    StrTbl2Ln2


AbortLoop:
		clr     APP_KEY_HIT
                call    ReadKeyPad
                jnb     APP_KEY_HIT, AbortLoop
;        	movf    AppKeyVal, W
;		xorlw	NULL
;		jnz	AbortLoop
                jmp     WarmUp


	endif





