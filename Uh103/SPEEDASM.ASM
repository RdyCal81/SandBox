


        if ( NO_GRAPH )
GRAPH_CH_0              equ     '<'
GRAPH_CH_1              equ     '>'
GRAPH_CH_2              equ     '.'
GRAPH_CH_3              equ     '*'
GRAPH_CH_4              equ     '|'
	else
GRAPH_CH_0              equ     0
GRAPH_CH_1              equ     1
GRAPH_CH_2              equ     2
GRAPH_CH_3              equ     3
GRAPH_CH_4              equ     4
        endif

Spaces2:        movlw   ' '
		call    LCD_Data
                movlw   ' '
		jmp	LCD_Data

DontShowZero:   jnb     LEADING_ZERO_FLAG, ShowVal
                andlw   0xFF
		jnz     ShowVal
                movlw   ' '
                jmp     LCD_Data

ShowVal:	clr     LEADING_ZERO_FLAG 
		jmp     LCD_Digit




ShowSpeedPercent:
		movlw	LCD1LINE + D'13'
		call	LCD_Command

                movf    MotorSpeedIdx, W
		clr     CARRY
		movwf   TEMP
		rlf     TEMP, F
		rlf     TEMP, F
                addwf   TEMP, W

		movwf	QUO_L

		clrw
		movwf	QUO_H
	
	        setb    LEADING_ZERO_FLAG
		jmp     Display3DigitNumber


DispTheGraphChar:
                movf    LCD_Idx, W
		andlw   0xFF
		btfsc   ZERO / 8, ZERO & 7
		return   

		movwf   TMP_L
		sublw   D'20'
		btfss   CARRY / 8, CARRY & 7
                return

                movf    MotorSpeedIdx, W
		movwf   TMP_H


		subwf   TMP_L, W
		jz      LCDIdx_EQ_MotorSpIdx
                
                decf    TMP_L, F
		clr     CARRY
		rrf     TMP_L, F
		
                movf    TMP_H, W
		andlw   0xFF
		jz      LCDIdx_GT_MotorSpIdx
		
		
                decf    TMP_H, F
		clr     CARRY
		rrf     TMP_H, F

                movf    TMP_H, W		
       		subwf   TMP_L, W
                btfsc   ZERO / 8, ZERO & 7
		return
		jc	LCDIdx_GT_MotorSpIdx
LCDIdx_LT_MotorSpIdx:		
                movf    TMP_L, W
		addlw   LCD2LINE + 3
		call	LCD_Command
		jmp     FullChar

LCDIdx_GT_MotorSpIdx:
                movf    TMP_L, W
ShowChar_2:
		addlw   LCD2LINE + 3
		call	LCD_Command
                movlw   GRAPH_CH_2
                jmp     LCD_Data




LCDIdx_EQ_MotorSpIdx:
                decf    TMP_L, F
		clr     CARRY
		rrf     TMP_L, W  
                addlw   LCD2LINE + 3
		call	LCD_Command
                btfss   MotorSpeedIdx, 0
		jmp     FullChar

HalfChar:       movlw   GRAPH_CH_4
                jmp     LCD_Data

FullChar:       movlw   GRAPH_CH_3
                jmp     LCD_Data






ShowGraph:
                call    LCD_ln2
		call    Spaces2
                movlw   GRAPH_CH_0
		call    LCD_Data


                clrw
		movwf   LCD_Idx

GrphLoop:
                movf    LCD_Idx, W
		sublw   D'20'
		jnc     GrphExit
		call    DispTheGraphChar
		incf    LCD_Idx, F
		jmp     GrphLoop
GrphExit:
                movlw   GRAPH_CH_1
		call    LCD_Data
		jmp     ShowSpeedPercent




                


	

                


;        k - (W) >> (W)
;                        SUBWF 0x02    LCD_Idx = 0x02
;        Example 1:      SUBWF 0x02
;                        Before Instruction
;        W = 1 MotorSpeedIdx
;        C = ?
;        Z = ?
;                        After Instruction
;        W = 1
;        C = 1           ; result is positive, LCD_Idx > MotorSpeedIdx
;        Z = 0
;
;        Example 2:      Before Instruction
;        W = 2
;        C = ?
;        Z = ?
;                        After Instruction
;        W = 0
;        C = 1           ; result is zero
;        Z = 1
;
;        Example 3:      Before Instruction
;        W = 3
;        C = ?
;        Z = ?
;                        After Instruction
;        W = 0xFF
;        C = 0           ; result is negative
;        Z = 0
;
;
		
		
                







SpeedFaster:
                movf    MotorSpeedIdx, W
		sublw   D'19'
                btfss	CARRY / 8, CARRY & 7
		return                          ; The speed is too fast...
                incf    MotorSpeedIdx, F
                jmp     Spd_01
     
SpeedSlower:
                movf    MotorSpeedIdx, W
		sublw   D'3'+D'1'
                btfsc	CARRY / 8, CARRY & 7
		return                          ; The speed is too slow...
 

                decf    MotorSpeedIdx, F
		btfss   MotorSpeedIdx, 0
		jmp     DisplayBlank
Spd_01:		
		movf    MotorSpeedIdx, W
		movwf   LCD_Idx
		call    DispTheGraphChar     
		jmp     ShowSpeedPercent


DisplayBlank:
                clr     CARRY
                rrf     MotorSpeedIdx, W
		call    ShowChar_2
		jmp     ShowSpeedPercent


;		movlw	LCD1LINE + 3
;		call	LCD_Command
;		movlw   NULL
;		movwf	QUO_H

;                movf    MotorSpeedIdx, W
;		call    SpeedTable
;		movwf   MotorSpeed

;                jmp     DT_02
	

       if ( 0 )
                sublw   ConstX
		
		        W = ConstX - W       

                if W == ConstX
                  Z = 1 ;True
		  C = 1 ;True
		endif

                if W  > ConstX
                  Z = 0 ;False
		  C = 0 ;False
		endif

                if W  < ConstX
                  Z = 0 ;False
		  C = 1 ;True
		endif





;        k - (W) >> (W)
;                        SUBLW 0x02
;        Example 1:      SUBLW 0x02
;                        Before Instruction
;        W = 1
;        C = ?
;        Z = ?
;                        After Instruction
;        W = 1
;        C = 1           ; result is positive
;        Z = 0
;
;        Example 2:      Before Instruction
;        W = 2
;        C = ?
;        Z = ?
;                        After Instruction
;        W = 0
;        C = 1           ; result is zero
;        Z = 1
;
;        Example 3:      Before Instruction
;        W = 3
;        C = ?
;        Z = ?
;                        After Instruction
;        W = 0xFF
;        C = 0           ; result is negative
;        Z = 0
;
;
       endif




Accelerate:     btfss   TIME0_MOD / 8,  TIME0_MOD & 7
                return
		clr     TIME0_MOD

RepeatAccTest:  movf	TableCnt + 1, W
		movwf	ANS_H

                movf	TableCnt, W
                movwf	ANS_L

		movf	TableCnt + 1, W
		subwf	ANS_H, W
		btfss	STATUS, Z
		goto	RepeatAccTest
		
		jnb     SUB_MAX_PULSES, DontSubMaxPulses

                movf    ANS_L, W
		sublw   LOW MAX_TABLE_MOVE
                movwf   ANS_L
		btfss   STATUS, C
		incf    ANS_H, F

                movf    ANS_H, W
		sublw   HIGH MAX_TABLE_MOVE
                movwf   ANS_H
DontSubMaxPulses:


                clr     CARRY
                rrf     ANS_H, W
		rrf     ANS_L, F
		btfsc   STATUS, C
                return                  ; Return if it's an odd pulse... i.e. bit 0 is set.
        
                ; W still has ANS_H from the prior shift's
		andlw   0xFF
		btfss   STATUS, Z
		jmp     SetMaximum      ; If W, (or ANS_H) has anything but Zero, it's too big.
		


                movf    ANS_L, W
		addlw   MIN_TABLE_SPEED
		btfsc   STATUS, C
		jmp     SetMaximum
		movwf   ANS_L

		call    SpeedTable
		
;		jnb     MAX_SPEED_FLAG, NoMaxSpeed 
;		movlw   MAX_TABLE_SPEED
;NoMaxSpeed:		

		subwf   ANS_L, W                ; W = ANS_L - W
                btfsc   STATUS, C
		jmp     SetMaximum


                movf    ANS_L, W
		movwf   MotorSpeed
                setb    ACC_NOT_COMPLETE
                return
		

SetMaximum:
                call    SpeedTable

;		jnb     MAX_SPEED_FLAG, No1MaxSpeed 
;		movlw   MAX_TABLE_SPEED
;No1MaxSpeed:		

		movwf   MotorSpeed
                clr     ACC_NOT_COMPLETE
		return
	
;SpeedMin:       clrw
;		call    SpeedTable
;		movwf   MotorSpeed
;                clr     ACC_NOT_COMPLETE
;		return





TestForCalibrationLimit:

RepAccTest_01:  movf	TableCnt + 1, W
		movwf	ANS_H

                movf	TableCnt, W
                movwf	ANS_L

		movf	TableCnt + 1, W
		subwf	ANS_H, W
		btfss	STATUS, Z
		goto	RepAccTest_01


		movf	ANS_H, W
                sublw   HIGH D'1277'
		jb      ZERO, AccCalib_01
                jb      CARRY, AccCalib_02
                jmp     AccCalib_MotorOff
AccCalib_01:
		movf	ANS_L, W
                sublw   LOW D'1277'
		jb      ZERO, AccCalib_MotorOff
                jb      CARRY, AccCalib_02
                jmp     AccCalib_MotorOff

	
AccCalib_MotorOff:
                clr     MOT_ENA
                clr     MOT_STEP
AccCalib_02:

CalibMotorMovement:

        	call	TestHiTemp
		movf	Debounce, W
		iorwf	Debounce + 1, W
		btfss	STATUS, Z
		return
		jmp	LCD_Error_MotorTimeOut

		return



        if ( SPEED_CONFIG )
JumpOutOfSpeedConfig:
		movf    MotorSpeedIdx, W
		movwf   SafeSpeedVal

                btfss   START_RUN / 8, START_RUN & 7 
		jmp     MainLoop
           if ( CAN_RUN )
                jmp     SpeedConfigReturn
	   else
		jmp     MainLoop
	   endif
        endif






SetRunSpeed:    movf    SafeSpeedVal, W
                movwf   MotorSpeedIdx
		return


SetMaxSpeed:    movlw   D'20'
		movwf   MotorSpeedIdx
		return


SetMinSpeed:    movlw   D'3'
		movwf   MotorSpeedIdx
		return



InitTableCnt:
                movlw   LOW MAX_TABLE_MOVE
		movwf   TableCnt

                movlw   HIGH MAX_TABLE_MOVE
		movwf   TableCnt + 1
		return

