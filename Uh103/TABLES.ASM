
;           1
; "1234567890123456"
;  --1   100%   8++
; 
	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : AsciiTable						³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/08/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
;AsciiTable:
;                addlw   '0'
;		return
;		andlw	0x0F
;		addwf	PCL, F		; Determine Offset into table
;		DT	"0123456789xxxxxx"


;TablesEnd:

;    if ( (( TablesStart & 0xFF00 ) | ( TablesEnd & 0xFF00 )) != NULL )
;       MESSG   "RWarning: Tables Boundry."
;    endif


        if ( !NO_GRAPH )
CG_iTable:	
                MOVLW   HIGH (CG_iTable)  ; Ensure that the PCLATH high has the 
                MOVWF   PCLATH              ;   correct value


		movf	LCD_LOOP, W		; Get the Index..
		addwf	PCL, F		; Determine Offset into table

                ; Char 0
                RETLW   b'00001'
                RETLW   b'00001'
                RETLW   b'00001'
                RETLW   b'00001'
                RETLW   b'00001'
                RETLW   b'00001'
                RETLW   b'00001'
                RETLW   b'00001'

                ; Char 1
                RETLW   b'10000'
                RETLW   b'10000'
                RETLW   b'10000'
                RETLW   b'10000'
                RETLW   b'10000'
                RETLW   b'10000'
                RETLW   b'10000'
                RETLW   b'10000'

                ; Char 2
                RETLW   b'11111111'
                RETLW   b'00000'
                RETLW   b'00000'
                RETLW   b'00000'
                RETLW   b'00000'
                RETLW   b'00000'
                RETLW   b'00000'
                RETLW   b'11111111'

                ; Char 3
                RETLW   b'11111111'
                RETLW   b'00000'
                RETLW   b'11111111'
                RETLW   b'11111111'
                RETLW   b'11111111'
                RETLW   b'11111111'
                RETLW   b'00000'
                RETLW   b'11111111'

                ; Char 4
                RETLW   b'11111111'
                RETLW   b'00000'
                RETLW   b'11100'
                RETLW   b'11100'
                RETLW   b'11100'
                RETLW   b'11100'
                RETLW   b'00000'
                RETLW   b'11111111'
CG_iTableEnd:
    if (( CG_iTable & 0xFF00 ) != ( CG_iTableEnd & 0xFF00 )) 
       MESSG   "RWarning: LCD Table Boundry."
    endif
        endif



StrWarmUp:	movlw	WU_STR
		jmp	StrTbl1Ln1


DisplayVer:
        if ( !NO_START_TIMER )
        	movlw	UH1_STR
		call	StrTbl1Ln1
	        movlw	VER_STR
		jmp     StrTbl1Ln2
	else
                return
	endif
		


StrReady:       call    ClearLCD
	        movlw	RDY_STR
		jmp	StrTbl1Ln1



	;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	;³ Func : LCD_iTable						³
	;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
	;³ In   : 							³
	;³ Out  :							³
	;³ Dest :							³
	;³ Comm :							³
	;³ Hist : 03/04/97 Initial Cut				Randy	³
	;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LCD_iTable:	
                MOVLW   HIGH (LCD_iTable)  ; Ensure that the PCLATH high has the 
                MOVWF   PCLATH              ;   correct value

		movf	LCD_LOOP, W		; Get the Index..
                addwf   PCL, F              ; Determine Offset into table
		DT	FUNC, FUNC, FUNC, DISPOFF, CLRLCD
		DT	ENTRMOD, CURSOFF, LCD1LINE, H'40'
		DT	NULL
LCD_iTableEnd:
    if (( LCD_iTable & 0xFF00 ) != ( LCD_iTableEnd & 0xFF00 ))
       MESSG   "RWarning: LCD_iTable Boundry."
    endif


MainKeyHit:
                MOVLW   HIGH (MainKeyHit)   ; Ensure that the PCLATH high has the 
                MOVWF   PCLATH              ;   correct value

        	movf    AppKeyVal, W
	        addwf	PCL, F		; Determine Offset into table

                return                  ;Key_0: Enter
                return                  ;Key_1: N/A
	if ( SPEED_CONFIG )
                jmp     SpeedConfig     ;Key_2: Speed config
        else
	        return
	endif
                return                  ;Key_3: N/A 
                jmp     RunCalibration  ;Key_4: Calibration 
                return                  ;Key_5: Fast  
                return                  ;Key_6: N/A 
        if ( STAND_BY )
                jmp     StandBy         ;Key_7: Stand By 
	else
	        return
	endif
                return                  ;Key_8: N/A 
                return                  ;Key_9: Slow 
MainKeyHitEnd:
    if (( MainKeyHit & 0xFF00 ) != ( MainKeyHitEnd & 0xFF00 ))
       MESSG   "RWarning: MainKeyHit Boundry."
    endif
 
 
 
 


StrCurSpeed:    
                call    ClearLCD
                movlw   CS_STR
		jmp     StrTbl1Ln1




SpeedTable:
                MOVLW   HIGH (SpeedTable)  ; Ensure that the PCLATH high has the 
                MOVWF   PCLATH              ;   correct value

                movf    MotorSpeedIdx, W
		addwf	PCL, F		; Determine Offset into table
                RETLW   MIN_TABLE_SPEED
                RETLW   TABLE_SPEED_05
                RETLW   TABLE_SPEED_10
                RETLW   TABLE_SPEED_15
                RETLW   TABLE_SPEED_20
                RETLW   TABLE_SPEED_25
                RETLW   TABLE_SPEED_30
                RETLW   TABLE_SPEED_35
                RETLW   TABLE_SPEED_40
                RETLW   TABLE_SPEED_45
                RETLW   TABLE_SPEED_50
                RETLW   TABLE_SPEED_55
                RETLW   TABLE_SPEED_60
                RETLW   TABLE_SPEED_65
                RETLW   TABLE_SPEED_70
                RETLW   TABLE_SPEED_73
                RETLW   TABLE_SPEED_82
                RETLW   TABLE_SPEED_85
                RETLW   TABLE_SPEED_90
                RETLW   TABLE_SPEED_95
                RETLW   MAX_TABLE_SPEED
SpeedTableEnd:
    if (( SpeedTable & 0xFF00 ) != ( SpeedTableEnd & 0xFF00 ))
       MESSG   "RWarning: SpeedTable Boundry."
    endif







