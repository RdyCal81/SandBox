
#define	NO		0
#define	YES		1


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
extern	bit		SOL_CUT, SOL_CLAMP;

	#asm		if ( MOTOR )	#endasm
extern	bit		SN_STR_UP;
extern	bit		MOT_RAM_DIR, MOT_RAM_ENA;
#define	MOTOR_OFF	0
#define	MOTOR_ON	1
#define	MOTOR_UP	1
#define	MOTOR_DOWN	0
	#asm		else	#endasm
extern	bit		SOL_RAM_DOWN, SOL_RAM_UP;

	#asm		endif	#endasm


	/* Indicators, Lights */
extern	bit		STOP_IND, DOWN_IND, START_IND;
extern	bit		JOG_IND, CUT_IND;


	/* --- :InPuts: --- */
	/* Sensors */
extern	bit		SN_HOME, SN_RAM_UP;

	/* Switches */
extern	bit		SW_STOP, SW_START, SW_JOG, SW_CLAMP, SW_DOWN;
extern	bit		SW_CIR_CUT;


	/* --- :Flags: --- */


extern	unsigned int	Debounce;
extern	unsigned char	SOLINOID_WR, LIGHT_WR;
extern	unsigned char	PORTE, PORTD;
extern	unsigned char	StopBounce;


void	main	( void )
{
  /* You may assume that all outputs are currently at level 0, low */
 UpdateOutPuts ();

 while ( 1 )
 {
	#asm
	if ( MOTOR )
	#endasm
   if ( !SN_STR_UP )	goto ( Sramup );
	#asm
	endif
	#endasm
 
   if ( !SN_RAM_UP )
   {
Sramup:
     if ( START_IND )
     { START_IND = NO;

#asm		if ( MOTOR )	#endasm
	
       MOT_RAM_ENA = MOTOR_OFF;

#asm		else		#endasm

       SOL_RAM_UP = RAM_NOT_ACTIVE;
#asm		endif		#endasm

       UpdateOutPuts ();
     }
   }

 	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ---------------   DOWN Switch   --------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
   if ( !SW_DOWN )		/* Is Down Switch Pushed?	1st */
   { if ( START_IND  ) goto ( NoDownSwitch );

#asm		if ( MOTOR )	#endasm
     if ( !SN_HOME ) goto ( NoDownSwitch );
#asm		endif		#endasm

	#asm
	if ( !MOTOR )
	#endasm
     if ( SOL_RAM_UP ) goto ( NoDownSwitch );
	#asm
	else
	#endasm
     if ( MOT_RAM_ENA ) goto ( NoDownSwitch );
	#asm
	endif
	#endasm


     for ( Debounce = DEBOUCETIME; Debounce; )
     { if ( SW_DOWN )
		goto ( NoDownSwitch );
       CheckStop ();
     }

     DOWN_IND = YES;
     STOP_IND = NO;
#asm		if ( MOTOR )	#endasm
     MOT_RAM_DIR = MOTOR_DOWN;
     UpdateOutPuts ();
     for ( Debounce = MOTORDLY; Debounce; )	CheckStop ();
     MOT_RAM_ENA = MOTOR_ON;
     UpdateOutPuts ();
#asm		else		#endasm
     SOL_RAM_DOWN = RAM_ACTIVE;
     UpdateOutPuts ();
#asm		endif		#endasm

     if ( SN_HOME )
     { while ( 1 ) 
       { if (      SW_DOWN ) goto ( NoDownSwitch );
         CheckStop ();
         if ( !SN_HOME )
         {
#asm		if ( MOTOR )	#endasm
           MOT_RAM_ENA = MOTOR_OFF;
#asm		else		#endasm
           SOL_RAM_DOWN = RAM_NOT_ACTIVE;
#asm		endif		#endasm

	   UpdateOutPuts ();
         }
       }
     }

     for ( Debounce = RELEASETIME; Debounce; )
     { if ( !SW_DOWN ) Debounce = RELEASETIME;
       CheckStop ();
     }

NoDownSwitch:
#asm		if ( MOTOR )	#endasm
     MOT_RAM_ENA = MOTOR_OFF;
#asm		else		#endasm
     SOL_RAM_DOWN = RAM_NOT_ACTIVE;
#asm		endif	#endasm

     DOWN_IND = NO;
     UpdateOutPuts ();
   }

	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/


	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ---------------  START Switch   --------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
   if ( !SW_START )		/* Is Start Switch Pushed?	2nd */
   {

     for ( Debounce = DEBOUCETIME; Debounce; )
     { if ( SW_START )
		goto ( NoStartSwitch );
       CheckStop ();
     }

     START_IND = YES;
     STOP_IND = NO;

     if ( SOL_CLAMP )		/* Only activte if Clamped	*/
     {
#asm		if ( MOTOR )	#endasm
       if ( SN_RAM_UP )
       { MOT_RAM_DIR = MOTOR_UP;
         UpdateOutPuts ();
         for ( Debounce = MOTORDLY; Debounce; )	CheckStop ();
         MOT_RAM_ENA = MOTOR_ON;
         UpdateOutPuts ();
       }
#asm		else	#endasm
       if ( SN_RAM_UP )
	SOL_RAM_UP = RAM_ACTIVE;
#asm		endif		#endasm
     }
     UpdateOutPuts ();
NoStartSwitch:
   }

   if ( SW_START )		/* If Start Switch is Not Pushed? */
   { if ( !SOL_CLAMP )		/* Only test if not Clamped	*/
     { if ( START_IND )
       { START_IND = NO;
         UpdateOutPuts ();
       }
     }
   }

	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/


	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ---------------   STOP Switch   --------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
   if ( !SW_STOP )		/* Is Stop Switch Pushed?	3rd */
   { for ( Debounce = DEBOUCETIME; Debounce; )
     { if ( SW_STOP )
		goto ( NoStopSwitch );
     }

AbsStop:
	/* -------------------------------- Start (dt.2) ------------------- */
#asm		if ( MOTOR )	#endasm
     MOT_RAM_ENA = MOTOR_OFF;
#asm		else		#endasm
     SOL_RAM_DOWN = SOL_RAM_UP = NO;
#asm		endif		#endasm
     SOL_CUT = NO;

     DOWN_IND = START_IND = NO;
     JOG_IND = CUT_IND = NO;
	/* -------------------------------- End (dt.2) --------------------- */

     STOP_IND = YES;
     UpdateOutPuts ();
     for ( Debounce = RELEASETIME; Debounce; )
     { if ( !SW_STOP ) Debounce = RELEASETIME;
     }


	/* -------------------------------- Start (dt.3) ------------------- */
     for ( Debounce = RELEASETIME; Debounce; )
     { if ( SW_STOP ) Debounce = RELEASETIME;
     }

     STOP_IND = NO;
     UpdateOutPuts ();


     for ( Debounce = RELEASETIME; Debounce; )
     { if ( !SW_STOP ) Debounce = RELEASETIME;
     }
	/* -------------------------------- End (dt.3) --------------------- */

NoStopSwitch:
   }
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/


	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ---------------  CLAMP Switch   --------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
   if ( !SW_CLAMP )		/* Is Clamp Switch Pushed?	4th */
   { for ( Debounce = DEBOUCETIME; Debounce; )
     { if ( SW_CLAMP )
		goto ( NoClampSwitch );
       CheckStop ();
     }

     STOP_IND = NO;
     
     if ( !SN_HOME )		/* (dt.4) */
     { if ( SOL_CLAMP )
       { SOL_CLAMP = NO;
         goto ( ClampDone );
       }
       SOL_CLAMP = YES;
ClampDone:
     }


     UpdateOutPuts ();

     for ( Debounce = RELEASETIME; Debounce; )
     { if ( !SW_CLAMP ) Debounce = RELEASETIME;
       CheckStop ();
     }
NoClampSwitch:
   }
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/




	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ---------------    CUT Switch   --------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
   if ( !SW_CIR_CUT )		/* Is Cut Switch Pushed?	5th */
   { for ( Debounce = DEBOUCETIME; Debounce; )
     { if ( SW_CIR_CUT )
		goto ( NoCutSwitch );
       CheckStop ();
     }

     STOP_IND = NO;
     CUT_IND = YES;
     UpdateOutPuts ();

#asm		if ( MOTOR )	#endasm
/*   if ( !SN_STR_UP )	goto ( SCut );*/
#asm		endif		#endasm

     if ( !SN_RAM_UP )		/* Only activte if Up		*/
     {
/*SCut:*/
       if ( SOL_CLAMP )
       { SOL_CUT = YES;
         UpdateOutPuts ();
       }
     }



     for ( Debounce = RELEASETIME; Debounce; )
     { if ( !SW_CIR_CUT ) Debounce = RELEASETIME;
       CheckStop ();
     }

NoCutSwitch:
     SOL_CUT = CUT_IND = NO;
     UpdateOutPuts ();
   }
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/





	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ---------------    JOG Switch   --------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
   if ( !SW_JOG )		/* Is Jog Switch Pushed?	6th */
   { if ( START_IND  ) goto ( NoJogSwitch );

#asm		if ( MOTOR )	#endasm
     if ( MOT_RAM_ENA )	goto ( NoJogSwitch );
     if ( !SN_HOME )	goto ( NoJogSwitch );
#asm		else		#endasm
     if ( SOL_RAM_UP ) goto ( NoJogSwitch );
#asm		endif		#endasm

     for ( Debounce = DEBOUCETIME; Debounce; )
     { if ( SW_JOG )
		goto ( NoJogSwitch );
       CheckStop ();
     }
     

#asm		if ( MOTOR )		#endasm
     MOT_RAM_DIR = MOTOR_DOWN;
     UpdateOutPuts ();
     for ( Debounce = MOTORDLY; Debounce; )	CheckStop ();
     MOT_RAM_ENA = MOTOR_ON;
     UpdateOutPuts ();
#asm		else		#endasm
     SOL_RAM_DOWN = RAM_ACTIVE;
#asm		endif		#endasm


     STOP_IND = NO;
     JOG_IND = YES;
     UpdateOutPuts ();
     if ( SN_HOME )
     { for ( Debounce = JOGTIME; Debounce; )
       { if ( !SN_HOME )
         { goto ( JogDone );
	 }
	 CheckStop ();
       }
       goto ( JogDone );
     }
     for ( Debounce = JOGTIME; Debounce; )
     { CheckStop (); 
     }

JogDone:
#asm		if ( MOTOR )		#endasm
     MOT_RAM_ENA = MOTOR_OFF;
#asm		else			#endasm
     SOL_RAM_DOWN = RAM_NOT_ACTIVE;
#asm		endif			#endasm
     UpdateOutPuts ();

     for ( Debounce = RELEASETIME; Debounce; )
     { if ( !SW_JOG ) Debounce = RELEASETIME;
       CheckStop ();
     }

NoJogSwitch:
     JOG_IND = NO;
     UpdateOutPuts ();
   }
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
	/* ----------------------------------------------------	*/
  }
}


void	UpdateOutPuts ( void )
{ PORTD = SOLINOID_WR;
  PORTE = 1;
  PORTE = 7;

  PORTD = LIGHT_WR;
  PORTE = NULL;
  PORTE = 7;
}


void	CheckStop	( void )
{ if ( !SW_STOP )
  { if ( !StopBounce )	goto ( AbsStop );
    goto ( EndStopCheck );
  }
  
  StopBounce =  DEBOUCETIME;

EndStopCheck:

}



