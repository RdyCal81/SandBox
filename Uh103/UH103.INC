
;;;	nolist

NULL		equ	0

MOTOR		equ	1
DOWNCONST   equ 0



SW_COL1             equ (PORTA * 8) + 0
SW_COL2             equ (PORTA * 8) + 1
SW_COL3             equ (PORTA * 8) + 2
SW_COL4             equ (PORTA * 8) + 3
SW_COL5             equ (PORTA * 8) + 4
SN_TABLE_BACK       equ (PORTA * 8) + 5


NA_NA1              equ (PORTB * 8) + 0
SN_TEMP_LO          equ (PORTB * 8) + 1
SN_SH_OPEN          equ (PORTB * 8) + 2
SW_START            equ (PORTB * 8) + 3
SN_TEMP_HI          equ (PORTB * 8) + 4
MOT_DIR             equ (PORTB * 8) + 5
MOT_ENA             equ (PORTB * 8) + 6
MOT_STEP            equ (PORTB * 8) + 7

SOL_N2_ON           equ (PORTC * 8) + 0
SOL_UV_ON           equ (PORTC * 8) + 1
LED_LED             equ (PORTC * 8) + 2
SOL_SHUTTER_OPEN    equ (PORTC * 8) + 3
SN_HATCH_CLOSE      equ (PORTC * 8) + 4
SN_DOOR_CLOSE       equ (PORTC * 8) + 5
LCD_RS              equ (PORTC * 8) + 6
LCD_E               equ (PORTC * 8) + 7

SOL_DOOR_LOCK       equ (PORTD * 8) + 0
SN_TABLE_HOME       equ (PORTD * 8) + 1
NA_NAD2             equ (PORTD * 8) + 2
SOL_COOL_FAN        equ (PORTD * 8) + 3
LCD_D4              equ (PORTD * 8) + 4
LCD_D5              equ (PORTD * 8) + 5
LCD_D6              equ (PORTD * 8) + 6
LCD_D7              equ (PORTD * 8) + 7


KEY_ROW1            equ (PORTE * 8) + 0
KEY_ROW2            equ (PORTE * 8) + 1
SN_SH_CLOSE         equ (PORTE * 8) + 2









; STATUS_1 is RAM, used for status....
; SW_STOP needs to look like the abort switch

APP_KEY_HIT equ (STATUS_1 * 8) + 0
KEY_IS_HIT  equ (STATUS_1 * 8) + 1
TMP_FLAG_1  equ (STATUS_1 * 8) + 2
MOTOR_ERROR equ (STATUS_1 * 8) + 3
          if ( NEW_TIME_DISPLAY )
          else
MIN2_FLAG   equ (STATUS_1 * 8) + 4
          endif
SW_STOP     equ (STATUS_1 * 8) + 5
STOP_IND    equ (STATUS_1 * 8) + 6
START_IND   equ (STATUS_1 * 8) + 7



SPEED_IS_SET        equ (STATUS_2 * 8) + 0

ACC_NOT_COMPLETE    equ (STATUS_2 * 8) + 1
TIME_TOGGLE_FLAG    equ (STATUS_2 * 8) + 1


START_RUN           equ (STATUS_2 * 8) + 2
TIME0_MOD           equ (STATUS_2 * 8) + 3
SUB_MAX_PULSES      equ (STATUS_2 * 8) + 4
LEADING_ZERO_FLAG   equ (STATUS_2 * 8) + 5
;MAX_SPEED_FLAG      equ (STATUS_2 * 8) + 6





LCD_TIME_FLAG       equ (TIME_FLAGS * 8) + 0
KEY_TIME_FLAG       equ (TIME_FLAGS * 8) + 1
START_SW_FLAG       equ (TIME_FLAGS * 8) + 2



ZERO                equ (STATUS * 8) + Z
CARRY               equ (STATUS * 8) + C