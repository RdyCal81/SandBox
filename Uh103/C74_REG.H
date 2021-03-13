    NOLIST
;
;   File =   C64_reg.h
;   Rev. History:     08-04-93 by MP
;                     10-18-93 by MP to make Page ok
;                     11-15-93 by MP to have correct pages for SFR
;
; EQUates for Special Function Registers
;
;
INDF            EQU     00
RTCC            EQU     01
OPTION_R        EQU     81
PCL             EQU     02
STATUS          EQU     03
FSR             EQU     04
PORTA           EQU     05
TRISA           EQU     85
PORTB           EQU     06
TRISB           EQU     86
PORTC           EQU     07
TRISC           EQU     87
PORTD           EQU     08
TRISD           EQU     88
PORTE           EQU     09
TRISE           EQU     89
PCLATH          EQU     0A
INTCON          EQU     0B
PIR1            EQU     0C
PIE1            EQU     8C
TMR1L           EQU     0E
PCON            EQU     8E
TMR1H           EQU     0F
T1CON           EQU     10
TMR2            EQU     11
T2CON           EQU     12
PR2             EQU     92
SSPBUF          EQU     13
SSPADD          EQU     93
SSPCON          EQU     14
SSPSTAT         EQU     94
CCPR1L          EQU     15
CCPR1H          EQU     16
CCP1CON         EQU     17
RCSTA			EQU		18
TXSTA			EQU		98
TXREG			EQU		19
SPBRG			EQU		99
RCREG			EQU		1A
CCPR2L          EQU     1B
CCPR2H          EQU     1C
CCP2CON         EQU     1D
ADRES			EQU		1E
ADCON0			EQU		1F
ADCON1			EQU		9F
;
;**********************************************
;************   Bit Deffinitions   ************
;**********************************************
;
; STATUS register (Address 03/83)
;
IRP				EQU		7
RP1				EQU		6
RP0				EQU		5
TO				EQU		4
PD				EQU		3
Z				EQU		2
DC				EQU		1
C				EQU		0
;
; INTCON register (Address 0B/8B)
;
GIE				EQU		7
PEIE			EQU		6
RTIE			EQU		5
INTE			EQU		4
RBIE			EQU		3
RTIF			EQU		2
INTF			EQU		1
RBIF			EQU		0
;
; PIR1 register (Address 0C)
;
PSPIF			EQU		7
SSPIF			EQU		3
CCP1IF			EQU		2
TMR2IF			EQU		1
TMR1IF			EQU		0
;
; PIE1 register (Address 8C)
;
PSPIE			EQU		7
SSPIE			EQU		3
CCP1IE			EQU		2
TMR2IE			EQU		1
TMR1IE			EQU		0
;
; OPTION register (Address 81)
;
RBPU			EQU		7
INTEDG			EQU		6
RTS				EQU		5
RTE				EQU		4
PSA				EQU		3
PS2				EQU		2
PS1				EQU		1
PS0				EQU		0
;
; PCON register (Address 8E)
;
POR				EQU		1
;
; TRISE register (Address 89)
;
IBF				EQU		7
OBF				EQU		6
IBOV			EQU		5
PSPMODE			EQU		4
TRISE2			EQU		2
TRISE1			EQU		1
TRISE0			EQU		0
;
; T1CON register (Address 10)
;
T1CKPS1			EQU		5
T1CKPS0			EQU		4
T1OSCEN			EQU		3
T1INSYNC		EQU		2
TMR1CS			EQU		1
TMR1ON			EQU		0
;
; T2CON register (Address 12)
;
TOUTPS3			EQU		6
TOUTPS2			EQU		5
TOUTPS1			EQU		4
TOUTPS0			EQU		3
TMR2ON			EQU		2
T2CKPS1			EQU		1
T2CKPS0			EQU		0
;
; SSPCON register (Address 14)
;
WCOL			EQU		7
SSPOV			EQU		6
SSPEN			EQU		5
CKP				EQU		4
SSPM3			EQU		3
SSPM2			EQU		2
SSPM1			EQU		1
SSPM0			EQU		0
;
; SSPSTAT register (Address 94)
;
DA				EQU		5
P				EQU		4
S				EQU		3
RW				EQU		2
UA				EQU		1
BF				EQU		0
;
; CCP1CON register (Address 17)
;
CCP1X			EQU		5
CCP1Y			EQU		4
CCP1M3			EQU		3
CCP1M2			EQU		2
CCP1M1			EQU		1
CCP1M0			EQU		0
;
; RCSTA register (Address 18)
;
SPEN			EQU		7
RC89			EQU		6
SREN			EQU		5
CREN			EQU		4
FERR			EQU		2
OERR			EQU		1
RCD8			EQU		0
;
; TXSTA register (Address 98)
;
CSRC			EQU		7
TX89			EQU		6
TXEN			EQU		5
SYNC			EQU		4
BRGH			EQU		2
TRMT			EQU		1
TXD8			EQU		0

;
; CCP2CON register (Address 1D)
;
CCP2X			EQU		5
CCP2Y			EQU		4
CCP2M3			EQU		3
CCP2M2			EQU		2
CCP2M1			EQU		1
CCP2M0			EQU		0
;
; ADCON0 register (Address 1F)
;
ADCS1			EQU		7
ADCS0			EQU		6
CHS2			EQU		5
CHS1			EQU		4
CHS0			EQU		3
GO				EQU		2
DONE			EQU		2
ADON			EQU		0
;
; ADCON1 register (Address 9F)
;
PCFG2			EQU		2
PCFG1			EQU		1
PCFG0			EQU		0
;
;***********************************************
;**** Bits for destination control
;****    W = W register is destination
;****    F = File register is destination
;***********************************************
;
W				EQU		0
F				EQU		1
;
FALSE			EQU		0
TRUE			EQU		1


    LIST

