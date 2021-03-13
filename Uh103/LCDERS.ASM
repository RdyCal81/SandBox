



LCD_ERR_2End:
                call    StrTbl2Ln2
                jmp     AllEndError

LCD_ERR_End:
                call    StrTbl1Ln2
AllEndError:
                call    ClearDOOR_LOCK
                clr     SOL_N2_ON
		

        if      ( NO_START_TIMER )
NoErrorYet:
                jb      SW_START, NoErrorYet
		jb      SN_TABLE_HOME, NoErrorYet
        endif

;;              call    ClearDOOR_LOCK
;;		clr     SOL_N2_ON


                movlw   MOVE_2_HOME_SPEED
		movwf   MotorSpeed


                jnb     SN_TABLE_HOME, EndOfError
		call    StartMotorFw

StayInErrorLoop:
                call    FwMotion
		jnb     MOT_ENA, EndOfError 
                jnb     SN_TABLE_HOME, EndOfError
                jmp     StayInErrorLoop


EndOfError:
                clr     MOT_ENA
                Timer0Off
                jmp     AbortLoop







LCD_ErrInit:
                movlw   ERR_STR
		jmp     StrTbl1Ln1







; The following errors have the same method of clearing...
;
;         ClearDOOR_LOCK
; clr     SOL_N2_ON
;   slowly move table home, if not alread there.
; wait for any key - while testing for Hi Temp
; jump to WarmUp


;Err- Power Up -> Shutter Not closed
; Display - "     ERROR!     "
;           "Shut Not Closed "
LCD_Error_PUSh:
		call    LCD_ErrInit
                movlw   SJM_STR
		jmp     LCD_ERR_End



; Power Up Temperture is too low.
LCD_Error_PUTempLo:
                call    SetCOOL_FAN

                movlw   LOT_STR
                call    StrTbl1Ln1
                movlw   COOL_STR
                call    StrTbl2Ln2
 
No1ErrorYet:

                jb      SN_TEMP_LO, No1ErrorYet
		call    StrReady
		call    ClearCOOL_FAN
Jloop:

		clr     APP_KEY_HIT
                call    ReadKeyPad
                jnb     APP_KEY_HIT, Jloop
        	movf    AppKeyVal, W
		xorlw	NULL
		jnz	Jloop
                jmp     WarmUp




; Power Up Hatch is not closed.
LCD_Error_PUHatchNotClosed:
		call    LCD_ErrInit
                movlw   HOP_STR
		jmp     LCD_ERR_End


LCD_Error_MotorTimeOut:
		call    LCD_ErrInit
                movlw   MTO_STR
		jmp     LCD_ERR_End


        ; The rest use table 2 for strings....


;Err- Start - Table not home.
;Err- Running - moving table back to home. 
; Display - "     ERROR!     "
;           "  Finding Home! "
LCD_Error_RunHome:
		call    LCD_ErrInit
                movlw   FH_STR
                call    StrTbl2Ln2
		jmp     M2B_01



;;;		jmp     LCD_ERR_2End

; --------------------------------------------------------------
; --------------------------------------------------------------
; --------------------------------------------------------------
; --------------------------------------------------------------
; --------------------------------------------------------------
; --------------------------------------------------------------
; --------------------------------------------------------------
; --------------------------------------------------------------
; --------------------------------------------------------------
; --------------------------------------------------------------






; Start -> Door not Closed.
LCD_Error_DoorNotClosed:
		call    LCD_ErrInit
                movlw   DNC_STR
                call    StrTbl1Ln2
		call    ClearDOOR_LOCK

DNC_Loop:	call    TestHiTemp
		clr     APP_KEY_HIT
                call    ReadKeyPad
                jnb     APP_KEY_HIT, DNC_Loop
		jmp     MainLoop
		


LCD_Error_HatchNotClosed:
		call    LCD_ErrInit
                movlw   HOP_STR
                call    StrTbl1Ln2

HNC_Loop:
		call    TestHiTemp
		jb      SN_HATCH_CLOSE, HNC_Loop    
		jmp     MainLoop
		





LCD_Error_ShutterNotOpen:
		call    LCD_ErrInit
                movlw   SNO_STR
                call    StrTbl1Ln2

                setb    SOL_SHUTTER_OPEN        ; Release Shutter Open SOL, it's active low...

LEr_SNO_Loop:
		call    TestHiTemp
		call    StartSwitch
		clr     APP_KEY_HIT
                call    ReadKeyPad
                jnb     APP_KEY_HIT, LEr_SNO_Loop
		clr     APP_KEY_HIT


                call    ClearDOOR_LOCK
		clr     SOL_N2_ON
		
                call    MainKeyHit
		jmp     MainLoop




LCD_Error_ShutterNotClose:
                movlw   SNC_STR
                call    StrTbl1Ln1
		jmp     ShutterNotClosedJumpSpot



TestDoorClosedAndHiTemp:

; Any old Temperature is too high...
TestHiTemp:
                btfsc   SN_TEMP_HI / 8, SN_TEMP_HI & 7
		return
;LCD_ERROR_TempHi:
                movlw   HIT_STR
                call    StrTbl1Ln1

        if ( STAND_BY )
                movlw   BON_STR	
		call    StrTbl2Ln2
        endif           


ShutterNotClosedJumpSpot:
		
                movlw   MOVE_2_HOME_SPEED
		movwf   MotorSpeed
		call    ClearDOOR_LOCK
		
        if ( STAND_BY )
                movlw   COOL_STR
                call    StrTbl2Ln2
        endif

HiTemp_00:		
                
                clr     SOL_UV_ON
                call    SetCOOL_FAN
		clr     SOL_N2_ON

                jnb     SN_TEMP_LO, HiTemp_01

                jmp     HiTemp_00
HiTemp_01:


Err01_loop:
                setb    TIME_TOGGLE_FLAG
		setb    MIN2_FLAG


                
Err01_loop01:
		jnb     MIN2_FLAG, Err01_NoStr 
                call    StartLCDStrTimer
		jnb     TIME_TOGGLE_FLAG, Err01_PAKey
                clr     TIME_TOGGLE_FLAG

        if ( STAND_BY )
                movlw   TEMPER_STR
                call    StrTbl2Ln1

                movlw   OK_STR
                call    StrTbl2Ln2
        endif

                jmp     Err01_EndStr
Err01_PAKey:
		setb    MIN2_FLAG

        if ( STAND_BY )
                movlw   PRESS_STR
                call    StrTbl2Ln1

                movlw   TORES_STR
                call    StrTbl2Ln2
        endif

               ;jmp     Err01_EndStr            ;Just fall through

Err01_EndStr:

Err01_NoStr:
		call    Update2SecTImer

		clr     APP_KEY_HIT
                call    ReadKeyPad
                jnb     APP_KEY_HIT, Err01_loop01
                jmp     WarmUp







; -----------------------------------------------------------------------
; -----------------------------------------------------------------------
; ------------------ Start LCD_Error_Motor2Back ------------------------- 
; -----------------------------------------------------------------------
; -----------------------------------------------------------------------
;
;
;Err- Running - Table did not reach Back Sensor.
; Close Shutter
; Display - "     ERROR!     "
;           "Table Back Sens "
; Wait for a key - testing for hi temp
; Display - "                "
;           "  Finding Home! "
; At slow speed move table to home.
; Jump to MainLoop

LCD_Error_RunMotor2Home:
		call    LCD_ErrInit
                movlw   FH_STR
                call    StrTbl2Ln2
		jmp     M2B_01


LCD_Error_Motor2Back:
		call    LCD_ErrInit
                movlw   TBS_STR
                call    StrTbl1Ln2



M2B_01:		call    ClearDOOR_LOCK
                clr     SOL_N2_ON



M2B_02:	       	call    TestHiTemp
		clr     APP_KEY_HIT
                call    ReadKeyPad
                jnb     APP_KEY_HIT, M2B_02


                movlw   MOVE_2_HOME_SPEED
		movwf   MotorSpeed
		
		call    ClearLCD
                movlw   FH_STR
                call    StrTbl2Ln2

                jnb     SN_TABLE_HOME, M2B_Exit
		call    StartMotorFw

M2B_Loop:
                call    FwMotion
		jnb     MOT_ENA, M2B_Exit 
                jb      SN_TABLE_HOME, M2B_Loop


M2B_Exit:
                clr     MOT_ENA
                Timer0Off
                jmp     MainLoop
; -----------------------------------------------------------------------
; -----------------------------------------------------------------------
; ------------------ End LCD_Error_Motor2Back ---------------------------
; -----------------------------------------------------------------------
; -----------------------------------------------------------------------























        if ( YES == NO )
RAC_Test_01:    movlw   0
                movwf   TempTest
                movlw	LCD1LINE + 2
		call	LCD_Command
		movlw  	1
		call    LCD_Digit

                movlw	LCD2LINE + 2
		call	LCD_Command
		movf	TableCnt, W
		jmp     DT_02
         endif


	                

        if ( YES == NO )
RAC_Test_02:    movlw	LCD1LINE + 3
		call	LCD_Command
		movlw  	2
		call    LCD_Digit

                movlw	LCD2LINE + 5
		call	LCD_Command
		movf	TableCnt, W
		jmp     DT_02
        endif
		
RAC_T_Exit:
                movlw   8
		movwf   TempTest

RAC_T_Loex:
		call    Wait500ms
                decfsz  TempTest, F
		jmp     RAC_T_Loex
		jmp     JumpAfterError





        if ( YES == NO )
RAC_Test_03:    movlw	LCD1LINE + 4
		call	LCD_Command
		movlw  	3
		jmp     LCD_Digit
        endif	


        

        if ( YES == NO )
RAC_ErrStr_1:
		call    LCD_ErrInit
                movlw   RC1_STR
		call    StrTbl1Ln2
       		jmp     RAC_T_Exit
        endif
	

        if ( 0 )
RAC_Test_Err_01:
		jb      MOT_ENA, RAC_T_MotorsOff
		movf    TempTest, W
		xorlw   0xFF
		btfss   STATUS, Z
                incf    TempTest, F
                return                

RAC_T_MotorsOff:
                movlw	LCD2LINE + 5
		call	LCD_Command
		movf	TempTest, W
		call    DT_02
        endif
	






; Motor went to back Error
;LCD_Error_TableAtBack:
;		call    LCD_ErrInit
;               movlw   TAB_STR
;		jmp     LCD_ERR_End


LCD_Curing:
                call    ClearLCD
	        movlw	CUR_STR
		jmp	StrTbl1Ln1

LCD_Calibration:
                call    ClearLCD
	        movlw	CAL_STR
		jmp	StrTbl1Ln1


