;**************************  PIC16C64 Header    *************************
;Bank 0 - set RP0 = 0

INDF    equ     00h     ;Indirect Address
TMR0    equ     01h
PCL     equ     02h
STATUS  equ     03h    
FSR     equ     04h
PORTA   equ     05h     ; I/O Port Assignments 
PORTB   equ     06h
PORTC   equ     07h
PORTD   equ     08h
PORTE   equ     09h
PCLATH  equ     0Ah
INTCON  equ     0Bh
PIR1    equ     0Ch
TMR1L   equ     0Eh
TMR1H   equ     0Fh
T1CON   equ     10h
TMR2    equ     11h
T2CON   equ     12h
SSPBUF  equ     13h
SSPCON  equ     14h
CCPR1L  equ     15h
CCPR1H  equ     16h
CCP1CON equ     17h

;BANK 1 - set RP0 = 1
OPTION_REG  equ     01h
RBPU			EQU		7
INTEDG			EQU		6




TRISA   equ     05h
TRISB   equ     06h
TRISC   equ     07h
TRISD   equ     08h
TRISE   equ     09h
PIE1    equ     0Ch
PCON    equ     0Eh
PR2     equ     12h
SSPADD  equ     13h
SSPSTAT equ     14h
;
;*************************************************************************
;
C       equ     0               ;STATUS
DC      equ     1               ;STATUS
Z       equ     2               ;STATUS
PD      equ     3               ;STATUS
TO      equ     4               ;STATUS
RP0     equ     5               ;STATUS
RP1     equ     6               ;STATUS
IRP     equ     7               ;STATUS

RBIF    equ     0               ;INTCON
INTF    equ     1               ;INTCON
RTIF    equ     2               ;INTCON
RBIE    equ     3               ;INTCON
INTE    equ     4               ;INTCON
RTIE    equ     5               ;INTCON
PEIE    equ     6               ;INTCON
GIE     equ     7               ;INTCON

TMR1IF  equ     0               ;PIR1
TMR2IF  equ     1               ;PIR1
CCP1IF  equ     2               ;PIR1
SSPIF   equ     3               ;PIR1
PSPIF   equ     7               ;PIR1

TMR1ON   equ    0               ;T1CON
TMR1CS   equ    1               ;T1CON
T1INSYNC equ    2               ;T1CON
T1OSCEN  equ    3               ;T1CON
T1CKPS0  equ    4               ;T1CON
T1CKPS1  equ    5               ;T1CON

T2CKPS0  equ    0               ;T2CON
T2CKPS1  equ    1               ;T2CON
TMR2ON   equ    2               ;T2CON
TOUTPS0  equ    3               ;T2CON
TOUTPS1  equ    4               ;T2CON
TOUTPS2  equ    5               ;T2CON
TOUTPS3  equ    6               ;T2CON

SSPM0   equ     0               ;SSPCON
SSPM1   equ     1               ;SSPCON
SSPM2   equ     2               ;SSPCON
SSPM3   equ     3               ;SSPCON
CKP     equ     4               ;SSPCON
SSPEN   equ     5               ;SSPCON
SSPOV   equ     6               ;SSPCON
WCOL    equ     7               ;SSPCON

CCP1M0  equ     0               ;CCP1CON
CCP1M1  equ     1               ;CCP1CON
CCP1M2  equ     2               ;CCP1CON
CCP1M3  equ     3               ;CCP1CON
CCP1Y   equ     4               ;CCP1CON
CCP1X   equ     5               ;CCP1CON

TRISE0  equ     0               ;TRISE
TRISE1  equ     1               ;TRISE
TRISE2  equ     2               ;TRISE
PSPMODE equ     4               ;TRISE
IBOV    equ     5               ;TRISE
OBF     equ     6               ;TRISE
IBF     equ     7               ;TRISE

TMR1IE  equ     0               ;PIE1
TMR2IE  equ     1               ;PIE1
CCP1IE  equ     2               ;PIE1
SSPIE   equ     3               ;PIE1
PSPIE   equ     7               ;PIE1

POR     equ     1               ;PCON

Same    equ     1
W       equ     0
 
LSB     equ     0
MSB     equ     7

TRUE    equ     1
YES     equ     1
FALSE   equ     0
NO      equ     0
;
;*************************************************************************





