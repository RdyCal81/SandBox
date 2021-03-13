

Clock		EQU	FALSE
PICMaster       EQU     FALSE           ; A Debugging Flag
Debug           EQU     FALSE           ; A Debugging Flag
Debug_PU        EQU     TRUE            ; A Debugging Flag

FULL_BUILD      equ     TRUE



        if ( !FULL_BUILD )
SHORT_TEXT              equ     TRUE
NO_GRAPH                equ     FALSE
NO_START_TIMER          equ     TRUE
STAND_BY                equ     FALSE
ABORT_ACTIVE            equ     FALSE
SPEED_CONFIG            equ     TRUE
CAN_RUN                 equ     FALSE
ORG_1                   equ     FALSE
        else
SHORT_TEXT              equ     FALSE
NO_GRAPH                equ     FALSE
NO_START_TIMER          equ     FALSE
STAND_BY                equ     TRUE
ABORT_ACTIVE            equ     TRUE
SPEED_CONFIG            equ     TRUE
CAN_RUN                 equ     TRUE
ORG_1                   equ     TRUE
	endif




MATH_MUL                equ     FALSE
NEW_TIME_DISPLAY        equ     FALSE
NO_TEXT                 equ     FALSE