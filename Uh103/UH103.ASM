
	LIST	P = 16C65A
	LIST	F = INHX8M
	__CONFIG	0x1FF2		; 0x1FF2
	;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	;� Func : DebugPntf						�
	;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑
	;� In   : 							�
	;� Out  :							�
	;� Dest :							�
	;� Comm :							�
	;�      :							�
	;� Hist : 03/05/97 Began				Randy	�
	;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
            INCLUDE <PIC16C64.h>
            include <RAM.ASM>
            INCLUDE <UH103.inc>
            INCLUDE <CONSTANT.ASM>
            include <SWITCHES.ASM>
            include <MACROS.ASM>
            include <VECTORS.ASM>
            include <StrTbl1.ASM>
            include <StrTbl2.ASM>
            include <TABLES.ASM>
            include <PORTS.ASM>
            include <TIME.ASM>
            include <BOOT.ASM>

;
;
	    include <MAIN.PIC>
;	    include <MAIN1.PIC>
	    include <MOTOR.PIC>
	    include <Speed.PIC>
	    include <KeyPad.ASM>

            include <LCD.ASM>
            include <LCDErs.ASM>
            include <SpeedAsm.ASM>
            include <StandBy.ASM>
            include <MATH_LIB.ASM>
            include <Abort.ASM>
            include <FinalObj.ASM>

    end

