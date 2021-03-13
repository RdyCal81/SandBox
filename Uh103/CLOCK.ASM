
	if ( Clock )

;
;
; Reset address. Determine type of RESET
;
        org     RESET_V                 ; RESET vector location
RESET       BSF     STATUS, RP0         ; Bank 1
            BTFSC   PCON, POR           ; Power-up reset?
            GOTO    START               ; YES
            GOTO    OTHER_RESET         ; NO, a WDT or MCLR reset
;
; This is the Periperal Interrupt routine. Need to determine the type
; of interrupt that occurred. The following interrupts are enabled:
;   1.  PORTB Change (RBIF)
;   2.  TMR1 Overflow Interrupt (T1IF)
;
    page
        org     ISR_V              ; Interrupt vector location
PER_INT_V	
        if ( Debug )
            bsf     PORTD, 0            ; Set high, use to measure total
        endif                           ;     time in Int Service Routine
;
            BCF         STATUS, RP0	; Bank 0
            BTFSC	PIR1, TMR1IF	; Timer 1 overflowed?
            GOTO	T1_OVRFL	; YES, Service the Timer1 Overflow Interrupt
            BTFSS	INTCON, RBIF	; NO, Did PORTB change?
            GOTO	ExRROR1		; NO, Exrror Condition - Unknown Interrupt
;
PORTB_FLAG				; Are any of PORTB's inputs active?
            MOVF	PORTB, W	;
            ANDLW	0xE0		; Keep only the 3 switch values
DEBOUNCE    MOVWF	TEMP		;
            MOVLW	DB_HI_BYTE	; This is the debounce delay 
            MOVF	MSD, F		;
            CLRF	LSD		;
KB_D_LP1    DECFSZ	LSD, F		;
            GOTO	KB_D_LP1	;
            DECFSZ	MSD, F		;
            GOTO	KB_D_LP1	;
END_DELAY   MOVF	PORTB, W	;
            ANDLW	0xE0		; Keep only the 3 switch values
            SUBWF	TEMP, F		;
            BTFSS	STATUS, Z	; Is the Zero bit set?
                                        ;    (switches were the same on 2 reads)
            GOTO	DEBOUNCE	; NO, Try another read
KEY_MATCH   MOVWF	TEMP		; YES, need to see which is depressed.
;
            MOVLW	0x80		; Since doing key inputs, clear TMR1
            MOVWF	TMR1H		;   for 1 sec overflow.
            CLRF	TMR1L		;
            BCF		PIR1, TMR1IF	; Clear Timer 1 Interrupt Flag

            BTFSS	TEMP, HR_MIN_SW		; Is the hour-min-off switch depressed?
            GOTO	SELECT_UNITS		; YES, specify the units selected
            BTFSS	TEMP, INC_SW		; Is the inc switch depressed?
            GOTO	INC_UNIT		; YES, Increment the selected Units
            BTFSS	TEMP, CLR_MIN_SW	; Is the clear minute switch depressed?
            GOTO	CLR_MIN			; YES, clear the minutes.
;
; No key match occured, or finished with PortB interrupt and need to clear interrupt condition.
;
CLR_RB					; No RB<7:5> keys are depressed (rising edge Int.)
            MOVF	PORTB, F	; Clear the PORTB mismatch condition
            BCF		INTCON, RBIF	; Clear the PORTB Int Flag
        if ( Debug )
            bcf		PORTD, 0	; Set low, use to measure total
                                        ;     time in Int Service Routine
        endif
            RETFIE			; Return / Enable Global Interrupts
;
    page
SELECT_UNITS
            MOVLW	0xFF		;
            MOVWF	WAIT_CNTR	; WAIT_CNTR has LSb set after each SELECT UNIT key press.
            INCF	FLAG_REG, F		; Increment the pointer to the MIN_UNIT:HR_UNIT
            BSF		FLAG_REG, KEY_INPUT	;
            GOTO	DISPLAY			; Flash the Display of the selected unit
;
INC_UNIT
            CLRF	WAIT_CNTR		; WAIT_CNTR is cleared to zero after each key press.
            BTFSC	FLAG_REG, HR_UNIT	; Are the hour units selected?
            GOTO	INC_HRS			; YES, Increment the hour units
            BTFSS	FLAG_REG, MIN_UNIT	; Are the minute units selected?
            GOTO	CLR_RB			; NO, Not a valid key. Clear flags
;
            INCF	MIN, F			; YES, Increment the minute units
            MOVLW	0x3C			; This is Decimal 60
            SUBWF	MIN, W			; MIN - 60 = ?
            BTFSS	STATUS, Z		; MIN = 60?
            GOTO	DISPLAY			; NO, display time
                                            	; YES, MIN = 0 (use code from CLR_MIN)
CLR_MIN     CLRF	MIN			; MIN = 0
            MOVLW	0x04			; Clear the seconds 
            MOVWF	SECS			; Initial Second count = 4
            MOVLW	0x80			; Clear Timer 1, for 1 sec overflow
            MOVWF	TMR1H			;
            CLRF	TMR1L			;
            BCF		PIR1, TMR1IF		; Clear the TMR1 overflow interrupt.
            CLRF	WAIT_CNTR		; WAIT_CNTR is cleared to zero after each key press.
            BTFSC	TEMP, CLR_MIN_SW	; Is the clear minute switch depressed?
            GOTO	DISPLAY			; NO. Rollover from increment key
            BCF		FLAG_REG, MIN_UNIT	; YES, Clear ALL relevant flags
            BCF		FLAG_REG, HR_UNIT	;
            BCF		FLAG_REG, KEY_INPUT	;
            GOTO	DISPLAY			;
;
    page
;
T1_OVRFL
            BCF		PIR1, TMR1IF		; Clear Timer 1 Interrupt Flag
            BTFSS	FLAG_REG, KEY_INPUT	; Are we using the key inputs?
            GOTO	INC_TIME		; NO, Need to Increment the time
            INCF	WAIT_CNTR, F		; YES, 
            MOVLW	0x0A			; 10 counts x 1 seconds
            SUBWF	WAIT_CNTR, W		; Has the 10 Sec wait for key expired?
            BTFSS	STATUS, Z		; Is the result 0?
            GOTO	DISPLAY			; NO, Display value
            CLRF	WAIT_CNTR		; YES, Clear WAIT_CNTR
            BCF		FLAG_REG, KEY_INPUT	;
            BCF		FLAG_REG, HR_UNIT	;
            BCF		FLAG_REG, MIN_UNIT	;
;
;
INC_TIME	MOVLW	0x80			;
		MOVWF	TMR1H		; 1 Second Overflow
		INCF	SECS, F		;
		BTFSS	SECS, 6		; 
		GOTO	DISPLAY		;
		MOVLW	0x04		;
		MOVWF	SECS		;
		INCF	MIN, F		;
		MOVLW	0x3C		; W = 60d
		SUBWF	MIN, W		;
		BTFSS	STATUS, Z	;
		GOTO	DISPLAY		;
		CLRF	MIN		;
INC_HRS		INCF	HRS, F		;

		MOVLW	0x0C		; It is now 12:00, Toggle AM / PM
		SUBWF	HRS, W		;
		BTFSS	STATUS, Z	;
		GOTO	CK_13		; Need to check if HRS = 13
		BTFSS	FLAG_REG, AM	; Was it AM or PM
		GOTO	SET_AM		; Was PM, Needs to be AM
		BCF	FLAG_REG, AM	; It is PM
		GOTO	DISPLAY		;
SET_AM		BSF	FLAG_REG, AM	; It is AM
		GOTO	DISPLAY		;

CK_13		MOVLW	0x0D			; Check if HRS = 13
		SUBWF	HRS, W			;
		BTFSS	STATUS, Z		;
		GOTO	DISPLAY			;
		CLRF	HRS			;
		INCF	HRS, F			;
		GOTO	DISPLAY			;
;
	page
INIT_DISPLAY
		MOVLW	DISP_ON			; Display On, Cursor On
		CALL	SEND_CMD		; Send This command to the Display Module
		MOVLW	CLR_DISP		; Clear the Display
		CALL	SEND_CMD		; Send This command to the Display Module
		MOVLW	ENTRY_INC		; Set Entry Mode Inc., No shift
		CALL	SEND_CMD		; Send This command to the Display Module
		RETURN
;
DISPLAY
		MOVLW	DD_RAM_ADDR		;
		CALL	SEND_CMD		;
;
		BTFSC	FLAG_REG, KEY_INPUT	; Do we need to flash the selectected units?
		GOTO	FLASH_UNITS		; YES, we need to flash selected units
		CALL	LOAD_HRS		; NO, do a normal display
		CALL	LOAD_COLON		;
		CALL	LOAD_MIN		;
		GOTO	LOAD_AM			;
;
FLASH_UNITS
		CLRF	PCLATH			; This clears PCLATH, This table in 1st
		MOVF	FLAG_REG, W		;    256 bytes of program memory
		ANDLW	0x03			; only HR_UNIT and MIN_UNIT bit can be non-zero
UNIT_TBL
		ADDWF	PCL, F			; HR_UNIT:MIN_UNIT
		GOTO	NO_UNITS		;       0 0        - Display everything.
		GOTO	HR_UNITS		;       0 1        - Flash the hour units
		GOTO	MIN_UNITS		;       1 0        - Flash the minute units
UNIT_TBL_END
		MOVLW	0xFC			;       1 1        - Need to clear FLAG_REG<HR_UNIT:MIN_UNIT>
		ANDWF	FLAG_REG, F		;
		GOTO	NO_UNITS		;       0 0        - Display everything.
;
	if ( (UNIT_TBL & 0x0FF) >= (UNIT_TBL_END & 0x0FF) )
       MESSG   "Warning: Table UNIT_TBL crosses page boundry in computed jump"
    endif
;
;
HR_UNITS
		BTFSS	WAIT_CNTR, 0		; If WAIT_CNTR is odd,
                                        	;    hour digits are displayed as blank
		GOTO	SKIP_BLK_HRS		;
		MOVLW	' '			;
		CALL	SEND_CHAR		;
		MOVLW	' '			;
		CALL	SEND_CHAR		;
SKIP_BLK_HRS
		BTFSS	WAIT_CNTR, 0		; WAIT_CNTR was even, display hour digits
		CALL	LOAD_HRS		;
;
		MOVLW	':'			; : always on, display all other character
		CALL	SEND_CHAR		;
		CALL	LOAD_MIN		;
		GOTO	LOAD_AM			;
;
	page
MIN_UNITS
		CALL	LOAD_HRS		; Display hours
		MOVLW	':'			; : always on
		CALL	SEND_CHAR		;
		BTFSS	WAIT_CNTR, 0		; If WAIT_CNTR is odd,
                                        	;    minute digits are displayed as blank
		GOTO	SKIP_BLK_MIN		;
		MOVLW	' '			;
		CALL	SEND_CHAR		;
		MOVLW	' '			;
		CALL	SEND_CHAR		;
SKIP_BLK_MIN
		BTFSS	WAIT_CNTR, 0		; WAIT_CNTR was even, display minute digits
		CALL	LOAD_MIN		;
		GOTO	LOAD_AM			;
;			
NO_UNITS
		CALL	LOAD_HRS		; Display all character
		MOVLW	':'			;
		CALL	SEND_CHAR		;
		CALL	LOAD_MIN		;
		GOTO	LOAD_AM			;
;
LOAD_HRS
		MOVF	HRS, W			; Load the Wreg with the value 
		CALL	BIN_2_BCD		;   to convert to BCD
		MOVF	MSD, W			; Load the MSD value into the Wreg
		CALL	NUM_TABLE		; Get the ASCII code
		CALL	SEND_CHAR		; Send this Character to the Display
;
		MOVF	LSD, W			; Load the LSD value into the Wreg
		CALL	NUM_TABLE		; Get the ASCII code
		CALL	SEND_CHAR		; Send this Character to the Display
		RETURN
;
LOAD_COLON	MOVLW	' '			; ASCII value for a Blank space
		BTFSC	SECS, 0			; Is it an EVEN or ODD second
		ADDLW	':' - ' '		; Is ODD, Second colon is ON.
						;   Add delta offset of ASCII Characters
		CALL	SEND_CHAR		; Send this Character to the Display
		RETURN
;
LOAD_MIN
		MOVF	MIN, W			; Load the Wreg with the value 
		CALL	BIN_2_BCD		;   to convert to BCD
		MOVF	MSD, W			; Load the MSD value into the Wreg
		CALL	NUM_TABLE		; Get the ASCII code
		CALL	SEND_CHAR		; Send this Character to the Display
;
		MOVF	LSD, W			; Load the LSD value into the Wreg
		CALL	NUM_TABLE		; Get the ASCII code
		CALL	SEND_CHAR		; Send this Character to the Display
		RETURN
;
	page
LOAD_AM		MOVLW	' '			; ASCII value for a Blank space
		CALL	SEND_CHAR		; Send this Character to the Display
		MOVLW	'A'			; ASCII value for a Blank space
		BTFSS	FLAG_REG, AM		; Is it AM or PM
		ADDLW	'P' - 'A'		; Is PM, Add delta offset of ASCII Characters
		CALL	SEND_CHAR		; Send this Character to the Display
		MOVLW	'M'
		CALL	SEND_CHAR		; Send this Character to the Display
;
		BSF     STATUS, RP0		; Bank 1
		BCF	OPTION_R, RBPU		; Turn on PORTB Pull-up
		BCF     STATUS, RP0		; Bank 0
		GOTO	CLR_RB			; You've displayed the time, Clear RBIF 
;
;
;******************************************************************************
; The BIN_2_BCD routine converts the binary number, in the W register, to a 
; binary coded decimal (BCD) munber. This BCD number is stored MSD:LSD. This
; routine is used by the DISPLAY subroutine, to convert the time values.
;******************************************************************************
;
BIN_2_BCD   CLRF    MSD                 ; This value contain the 10's digit value
            MOVWF   LSD                 ; This value contain the 1's digit value
TENS_SUB    MOVLW   .10                 ; A decimal 10
            SUBWF   LSD, W              ;
            BTFSS   STATUS, C           ; Did this subtract cause a Negative Result?
            RETLW   0                   ; YES, Return from this Routine
            MOVWF   LSD                 ; No, move the result into LSD
            INCF    MSD, F              ; Increment the most significat digit
            GOTO    TENS_SUB            ;
;			
;
; Should NEVER get here
;
ExRROR1      BCF     STATUS, RP0         ; Bank 0
;
        if ( Debug )
            BSF     PORTD, 1
            BCF     PORTD, 1
        else
            BSF     PORTC, 0
            BCF     PORTC, 0
        endif
            GOTO    ExRROR1
;
	page
;
;*******************************************************************
;* SendChar - Sends character to LCD                               *
;* This routine splits the character into the upper and lower      * 
;* nibbles and sends them to the LCD, upper nibble first.          *
;* The data is transmitted on the PORT<3:0> pins                   *
;*******************************************************************

SEND_CHAR
            MOVWF   CHAR                ; Character to be sent is in W
            CALL    BUSY_CHECK          ; Wait for LCD to be ready
            SWAPF   CHAR, W
            ANDLW   0x0F                ; Get upper nibble
            MOVWF   LCD_DATA            ; Send data to LCD
            BCF     LCD_CNTL, R_W       ; Set LCD to read
            BSF     LCD_CNTL, RS        ; Set LCD to data mode
            BSF     LCD_CNTL, E         ; toggle E for LCD
            BCF     LCD_CNTL, E
            MOVF    CHAR, W
            ANDLW   0x0F                ; Get lower nibble
            MOVWF   LCD_DATA            ; Send data to LCD
            BSF     LCD_CNTL, E         ; toggle E for LCD
            BCF     LCD_CNTL, E
            RETURN

;*******************************************************************
;* SendCmd - Sends command to LCD                                  *
;* This routine splits the command into the upper and lower        * 
;* nibbles and sends them to the LCD, upper nibble first.          *
;* The data is transmitted on the PORT<3:0> pins                   *
;*******************************************************************

SEND_CMD
            MOVWF   CHAR                ; Character to be sent is in W
            CALL    BUSY_CHECK          ; Wait for LCD to be ready
            SWAPF   CHAR, W
            ANDLW   0x0F                ; Get upper nibble
            MOVWF   LCD_DATA            ; Send data to LCD
            BCF     LCD_CNTL, R_W       ; Set LCD to read
            BCF     LCD_CNTL, RS        ; Set LCD to command mode
            BSF     LCD_CNTL, E         ; toggle E for LCD
            BCF     LCD_CNTL, E
            MOVF    CHAR, W
            ANDLW   0x0F                ; Get lower nibble
            MOVWF   LCD_DATA            ; Send data to LCD
            BSF     LCD_CNTL, E         ; toggle E for LCD
            BCF     LCD_CNTL, E
            RETURN
    page
;*******************************************************************
;* This routine checks the busy flag, returns when not busy        *
;*  Affects:                                                       *
;*      TEMP - Returned with busy/address                          *
;*******************************************************************

BUSY_CHECK
;
        if ( Debug )
            BSF     PORTD, 3
            BCF     PORTD, 3
        endif
            CLRF    LCD_DATA            ;** Have PORTB<3:0> output low
            BSF     STATUS, RP0         ; Bank 1
            BSF     OPTION_R, RBPU      ; Turn off PORTB Pull-up 
            MOVLW   0xFF                ; Set PortB for input
            MOVWF   LCD_DATA_TRIS
            BCF     STATUS, RP0         ; Bank 0
            BCF     LCD_CNTL, RS        ; Set LCD for Command mode
            BSF     LCD_CNTL, R_W       ; Setup to read busy flag
            BSF     LCD_CNTL, E         ; Set E high
            BCF     LCD_CNTL, E         ; Set E low
            SWAPF   LCD_DATA, W         ; Read upper nibble busy flag, DDRam address
            ANDLW   0xF0                ; Mask out lower nibble
            MOVWF   TEMP                ;
            BSF     LCD_CNTL, E         ; Toggle E to get lower nibble
            BCF     LCD_CNTL, E
            MOVF    LCD_DATA, W         ; Read lower nibble busy flag, DDRam address
            ANDLW   0x0F                ; Mask out upper nibble
            IORWF   TEMP, F             ; Combine nibbles
            BTFSC   TEMP, 7             ; Check busy flag, high = busy
            GOTO    BUSY_CHECK          ; If busy, check again
            BCF     LCD_CNTL, R_W
            BSF     STATUS, RP0         ; Bank 1
            MOVLW   0xF0                ;
            MOVWF   LCD_DATA_TRIS       ; RB7 - 4 = inputs, RB3 - 0 = output
            BCF     STATUS, RP0         ; Bank 0
            RETURN
;
    page
;
;******************************************************************************
;*****      Start program here, Power-On Reset occurred.
;******************************************************************************
;
START                               ; POWER_ON Reset (Beginning of program)
            BCF     STATUS, RP0     ; Bank 0
            MOVLW   0x0C            ; Decimal 12
            MOVWF   HRS             ; HOURS = 12
            CLRF    MIN             ; MIN   = 00
            MOVLW   0x00            ;
            MOVWF   FLAG_REG        ; PM light is on
            MOVLW   0x04            ; Initial value of seconds (64d - 60d)
            MOVWF   SECS            ; This allows a simple bit test to see if 60
                                    ;   secs has elapsed.
            MOVLW   0x80            ; TIM1H:TMR1L = 0x8000 gives 1 second
            MOVWF   TMR1H           ;   overflow, at 32 KHz.
            CLRF    TMR1L           ;
;
MCLR_RESET                          ; A Master Clear Reset
            CLRF    STATUS          ; Do initialization (Bank 0)
            CLRF    INTCON
            CLRF    PIR1
            BSF     STATUS, RP0     ; Bank 1
            MOVLW   0x00            ; The LCD module does not like to work w/ weak pull-ups
            MOVWF   OPTION_R        ;
            CLRF    PIE1            ; Disable all peripheral interrupts
            MOVLW   0xFF            ;
            MOVWF   ADCON1          ; Port A is Digital (for 16C7x devices).
;
;
            BCF     STATUS, RP0     ; Bank 0
            CLRF    PORTA           ; ALL PORT output should output Low.
            CLRF    PORTB
            CLRF    PORTC
            CLRF    PORTD
            CLRF    PORTE
            BCF     T1CON, TMR1ON   ; Timer 1 is NOT incrementing
;
            BSF     STATUS, RP0     ; Select Bank 1
            CLRF    TRISA           ; RA5 -  0 outputs
            MOVLW   0xF0            ;
            MOVWF   TRISB           ; RB7 - 4 inputs, RB3 - 0 outputs 
            CLRF    TRISC           ; RC Port are outputs
            BSF     TRISC, T1OSO    ; RC0 needs to be input for the oscillator to function
            CLRF    TRISD           ; RD Port are outputs
            CLRF    TRISE           ; RE Port are outputs
            BSF     PIE1, TMR1IE    ; Enable TMR1 Interrupt
            BCF     OPTION_R, RBPU  ; Enable PORTB pull-ups
            BCF     STATUS, RP0     ; Select Bank 0
            MOVF    PORTB, F        ; Need to clear 1st RBIF, due to
            BCF     INTCON, RBIF    ;    set up of PORTB
;
    page
;
; Initilize the LCD Display Module
;
            CLRF    LCD_CNTL        ; ALL PORT output should output Low.

DISPLAY_INIT
            MOVLW   0x02            ; Command for 4-bit interface
            MOVWF   LCD_DATA        ;
            BSF     LCD_CNTL, E     ; 
            BCF     LCD_CNTL, E     ;
;
; This routine takes the calculated times that the delay loop needs to
; be executed, based on the LCD_INIT_DELAY EQUate that includes the
; frequency of operation. These uses registers before they are needed to 
; store the time.
;
LCD_DELAY   MOVLW   LCD_INIT_DELAY  ;
            MOVWF   MSD             ; Use MSD and LSD Registers to Initilize LCD
            CLRF    LSD             ;
LOOP2       DECFSZ  LSD, F          ; Delay time = MSD * ((3 * 256) + 3) * Tcy
            GOTO    LOOP2           ;
            DECFSZ  MSD, F          ;
END_LCD_DELAY
            GOTO    LOOP2           ;
;
; Command sequence for 2 lines of 5x7 characters
;
CMD_SEQ     MOVLW   0X02
            MOVWF   LCD_DATA
            BSF     LCD_CNTL, E     ; 
            BCF     LCD_CNTL, E     ;
            MOVLW   0x08            ; 
            MOVWF   LCD_DATA        ;
            BSF     LCD_CNTL, E     ; 
            BCF     LCD_CNTL, E     ;
;
; Busy Flag should be valid after this point
;
            MOVLW   DISP_ON         ;
            CALL    SEND_CMD        ;
            MOVLW   CLR_DISP        ;
            CALL    SEND_CMD        ;
            MOVLW   ENTRY_INC       ;
            CALL    SEND_CMD        ;
            MOVLW   DD_RAM_ADDR     ;
            CALL    SEND_CMD        ;
;
    page
;
; Initialize the Special Function Registers (SFR) interrupts
;
            CLRF    PIR1            ;
            MOVLW   0x0E
            MOVWF   T1CON           ; RC1 is overridden by TCKO
            BSF     INTCON, PEIE    ; Enable Peripheral Interrupts
            BSF     INTCON, RBIE    ; Disable PORTB<7:4> Change Interrupts
            BSF     INTCON, GIE     ; Enable all Interrupts
;
            CALL    INIT_DISPLAY    ;
            CALL    DISPLAY         ;
;
            MOVLW   0x0E
            MOVWF   T1CON           ; Enable T1 Oscillator, Ext Clock, Async, prescaler = 1
            BSF     T1CON, TMR1ON   ; Turn Timer 1 ON
;
        if ( PICMaster )
lzz         goto    lzz             ; Loop waiting for interrupts (for use with PICMASTER)
        else
;
SLEEP_LP    SLEEP                   ; Wait for Change on PORTB interrupt. or TMR1 timeout
            NOP                     ;
            GOTO    SLEEP_LP        ; 
;
        endif
;
; Here is where you do things depending on the type of RESET (Not a Power-On Reset).
;
OTHER_RESET   BTFSS  STATUS, TO     ; WDT Time-out?
WDT_TIMEOUT   GOTO   ExRROR1         ; YES, This is exrror condition
        if ( Debug_PU )
            goto   START            ; MCLR reset, Goto START
        else
            GOTO   MCLR_RESET       ; MCLR reset, Goto MCLR_RESET
        endif
;
        if (Debug )
END_START     NOP                   ; END lable for debug
        endif
;
    page
;
    org     TABLE_ADDR
;
NUM_TABLE       MOVWF   TEMP                ; Store value to TEMP register
                MOVLW   HIGH (TABLE_ADDR)   ; Ensure that the PCLATH high has the 
                MOVWF   PCLATH              ;   correct value
                MOVF    TEMP, W             ; Value into table
                ANDLW   0x0F                ; Mask to 4-bits (00 - 0Fh) 
NUM_TBL         ADDWF   PCL, F              ; Determine Offset into table
                RETLW   '0'                 ; ASCII value of "0" in W register
                RETLW   '1'                 ; ASCII value of "1" in W register
                RETLW   '2'                 ; ASCII value of "2" in W register
                RETLW   '3'                 ; ASCII value of "3" in W register
                RETLW   '4'                 ; ASCII value of "4" in W register
                RETLW   '5'                 ; ASCII value of "5" in W register
                RETLW   '6'                 ; ASCII value of "6" in W register
                RETLW   '7'                 ; ASCII value of "7" in W register
                RETLW   '8'                 ; ASCII value of "8" in W register
                RETLW   '9'                 ; ASCII value of "9" in W register
                                            ; Any enter after is in exrror (Display an E)
                RETLW   'E'                 ; ASCII value of "E" in W register
                RETLW   'E'                 ; ASCII value of "E" in W register
                RETLW   'E'                 ; ASCII value of "E" in W register
                RETLW   'E'                 ; ASCII value of "E" in W register
                RETLW   'E'                 ; ASCII value of "E" in W register
NUM_TBL_END     RETLW   'E'                 ; ASCII value of "E" in W register
;
    if ( (NUM_TBL & 0xFF00) != (NUM_TBL_END & 0xFF00) )
       MESSG   "Warning: Table NUM_TBL crosses page boundry in computed jump"
    endif
;
;
    org     PMEM_END            ; End of Program Memory
            GOTO    ExRROR1          ; If you get here your program was lost

	endif

	DT	"Just a Test.", 0
	retlw	'3'

            INCLUDE <LCD.ASM>
            INCLUDE <TIME.ASM>
;	org	0x2007
	;db	000
