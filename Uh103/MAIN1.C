

#define	NO		0
#define	YES		1

#label	__Aa

#define	NULL		0

#define	DEBOUCETIME	 30
#define	RELEASETIME	 50

	/* (dt.5) */
#define	JOGTIME		100
#define	MOTORDLY	100

#define	SOL_ACTIVE	1
#define	SOL_NOT_ACTIVE	0

#define	RAM_ACTIVE	1
#define	RAM_NOT_ACTIVE	0



	/* --- :OutPuts: --- */
	/* Solinoids, Ram things */

#define	MOTOR_OFF	0
#define	MOTOR_ON	1
#define	MOTOR_UP	1
#define	MOTOR_DOWN	0

	/* Indicators, Lights */
extern	bit		STOP_IND, START_IND;


	/* --- :InPuts: --- */
	/* Sensors */
extern	bit		SN_HOME;

	/* Switches */
extern	bit		SW_STOP, SW_START;


	/* --- :Flags: --- */


extern	unsigned int	Debounce;
extern	unsigned char	PORTE, PORTD;
