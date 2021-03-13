

#define	NO		0
#define	YES		1




	/* (dt.5) */

#define	SOL_ACTIVE	YES
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


	/* --- :InPuts: --- */
	/* Sensors */

	/* Switches */
extern	bit		SW_STOP, SW_START;
extern	bit		LED_LED;
extern	bit		LCD_RS, LCD_E;
extern	bit		LCD_D4, LCD_D5, LCD_D6, LCD_D7;
extern	bit		SN_SH_OPEN, SN_TEMP_LO, SN_HATCH_CLOSE;
extern	bit		SOL_UV_ON, SOL_COOL_FAN, SOL_SHUTTER_OPEN;
extern	bit		MIN2_FLAG, SN_TABLE_HOME;

extern	bit		START_IND, STOP_IND;
extern	bit		TMP_FLAG_1, APP_KEY_HIT;

extern	bit		SN_DOOR_CLOSE, SPEED_IS_SET, SOL_DOOR_LOCK;
extern	bit		ACC_NOT_COMPLETE, START_RUN;
extern	bit 		MOT_DIR, MOT_ENA, MOTOR_ERROR, MOT_STEP;
extern	bit		SN_SH_CLOSE, SUB_MAX_PULSES;
extern	bit		SOL_N2_ON, SN_TABLE_BACK;
/*
extern	bit		MAX_SPEED_FLAG; */

	/* --- :Flags: --- */


extern	unsigned int	Debounce;
extern	unsigned int	TableCnt;

extern	unsigned char	PORTE, PORTD, Motor_Extra;



void	main	( void )
{

  LED_LED = NO;
  /*
  MAX_SPEED_FLAG = NO; */
  DisplayVer();

JumpAfterError:

  SOL_SHUTTER_OPEN = 1;
  StartVerTimer ();
  while ( !MIN2_FLAG )
  {
     Update2SecTImer ();
     TestHiTemp ();  
  }

WarmUp:

  LED_LED = NO;
  ClearLCD();

  
 /* Power up Sequence */
  TestHiTemp ();  

  if (  SN_SH_CLOSE ) 	 LCD_Error_PUSh (); 
  if (  SN_TEMP_LO ) 	 LCD_Error_PUTempLo (); 
  if (  SN_HATCH_CLOSE ) LCD_Error_PUHatchNotClosed ();


  /* You may assume that all outputs are currently at level 0, low */
  StrWarmUp ();
  StartMotorFw ();
  Start2SecTimer ();

  ClearCOOL_FAN ();


  while ( 1 )
  {
    SOL_UV_ON = YES;
    Update2SecTImer ();
    DisplayTime ();
    FwMotion ();

    if ( MIN2_FLAG )
      SetCOOL_FAN ();

    if ( !SN_TABLE_HOME )
    {
      if ( !Motor_Extra )
         StopTableMotor();
      if ( MIN2_FLAG ) goto ( MainLoop );
    }
  }



MainLoop:
  ClearLCD();
  StrReady ();

  LED_LED = NO;

  while ( 1 )
  {
    SetCOOL_FAN ();
    TestHiTemp ();
    StartSwitch ();  
    ReadKeyPad();
    if ( APP_KEY_HIT )
    {
      START_RUN = NO;
      APP_KEY_HIT = NO;
      MainKeyHit ();
    }
    
/*
    if ( !Debounce )
    {
      Debounce = 100;
	#asm
		jb	LED_LED, MainLED_Off
		setb	LED_LED
		jmp	MainLED_End
MainLED_Off:
		clr	LED_LED
MainLED_End:
	#endasm
    } */
  
  }
}








	#asm
		if ( CAN_RUN )
	#endasm



void	StartRunning	( void )
{

  SetDOOR_LOCK ();
  Wait500ms ();
  if ( SN_DOOR_CLOSE )	LCD_Error_DoorNotClosed (); 
  if ( SN_HATCH_CLOSE ) LCD_Error_HatchNotClosed ();
  if ( SN_TABLE_HOME )  LCD_Error_RunHome ();
  /*MAX_SPEED_FLAG = NO;*/

  START_RUN = YES;
        #asm
		if ( SPEED_CONFIG )
	#endasm
  if ( !SPEED_IS_SET ) 	SpeedConfig();
SpeedConfigReturn:
	#asm
		endif
	#endasm

  SetRunSpeed ();


  LCD_Curing ();
  LED_LED = YES;
  
  SetDOOR_LOCK ();
  Wait500ms ();
  if ( SN_DOOR_CLOSE )	LCD_Error_DoorNotClosed ();
   
  SOL_N2_ON = YES;

  SOL_SHUTTER_OPEN = 0;
  for ( Debounce = 3000; Debounce; )
  {
     if ( !SN_SH_OPEN )  goto ( ForExit01 );
     TestHiTemp ();  
  }
  LCD_Error_ShutterNotOpen ();
ForExit01:


  /*
  RAC_Test_01 (); */
	
  MOTOR_ERROR =  NO;
  Debounce = 10000;
  SUB_MAX_PULSES = NO;
  StartMotorBk ();
  ACC_NOT_COMPLETE = YES;

  
  #asm
Mmm_01:   
		call	MotorMovement
		jnb     SN_TABLE_BACK, EndRun2Back
		btfsc	ACC_NOT_COMPLETE / 8, ACC_NOT_COMPLETE & 7
		jmp	Mmm_01
  #endasm

  /*
  RAC_Test_02 (); */
  
  SUB_MAX_PULSES = YES;
  #asm
Mmm_02:   
		call	MotorMovement
		jnb     SN_TABLE_BACK, EndRun2Back
		btfss	ACC_NOT_COMPLETE / 8, ACC_NOT_COMPLETE & 7
		jmp	Mmm_02
  #endasm
  
  /*
  RAC_Test_03 ();*/

  while ( MOT_ENA )
  {
     MotorMovement ();
     if ( !SN_TABLE_BACK ) goto ( EndRun2Back );
  }
  MOTOR_ERROR =  YES;



EndRun2Back:
  ACC_NOT_COMPLETE = YES;
  MOT_ENA = NO;
  MOT_STEP = NO;
  #asm
      Timer0Off
  #endasm


  SOL_SHUTTER_OPEN = 1;
  for ( Debounce = 3000; Debounce; )
  {
     if ( !SN_SH_CLOSE )  goto ( ForExit02 );
  }
  LCD_Error_ShutterNotClose ();
ForExit02:


  if ( MOTOR_ERROR )
    LCD_Error_Motor2Back ();  



  /* Do something here????? */
  /* Go back to the front at the maximum speed... */
  Wait250ms ();

  StartMotorFw ();
  /*MAX_SPEED_FLAG = YES;*/
  SetMaxSpeed ();
  Debounce = 10000;

  #asm
Mmm_03:   
		btfss	MOT_ENA / 8, MOT_ENA & 7
		jmp	AtHomePos
		call	MotorMovement
		btfsc	ACC_NOT_COMPLETE / 8, ACC_NOT_COMPLETE & 7
		jmp	Mmm_03
  #endasm

  SUB_MAX_PULSES = NO;
  #asm
Mmm_04:   
		btfss	MOT_ENA / 8, MOT_ENA & 7
		jmp	AtHomePos
		call	MotorMovement
		btfss	ACC_NOT_COMPLETE / 8, ACC_NOT_COMPLETE & 7
		jmp	Mmm_04
  #endasm


  while ( MOT_ENA )
  {
     MotorMovement ();
  }

AtHomePos:
  if ( SN_TABLE_HOME ) LCD_Error_RunHome ();
  MOT_STEP = NO;

MainEndLoop: 
  ClearDOOR_LOCK ();
  SOL_N2_ON = NO;
  
  Debounce = 0;

  ClearLCD();
  StrReady ();

  while ( 1 )
  {
    TestHiTemp ();
    StartSwitch ();

    if ( SN_DOOR_CLOSE )  MainLoop ();
   
    ReadKeyPad();
    if ( APP_KEY_HIT )
    {
      START_RUN = NO;
      APP_KEY_HIT = NO;
      MainKeyHit ();
    }


    if ( !Debounce )
    {
      Debounce = 250;
	#asm
		jb	LED_LED, MainqLED_Off
		setb	LED_LED
		jmp	MainqLED_End
MainqLED_Off:
		clr	LED_LED
MainqLED_End:
	#endasm
    }
  }
}


































void	RunCalibration	( void )
{

  SetDOOR_LOCK ();
  Wait500ms ();
  if ( SN_DOOR_CLOSE )	LCD_Error_DoorNotClosed (); 
  if ( SN_HATCH_CLOSE ) LCD_Error_HatchNotClosed ();
  if ( SN_TABLE_HOME )  LCD_Error_RunHome ();
  /*MAX_SPEED_FLAG = NO;*/

  SetMinSpeed ();
  LCD_Calibration ();

  LED_LED = YES;
  
  SetDOOR_LOCK ();
  Wait500ms ();
  if ( SN_DOOR_CLOSE )	LCD_Error_DoorNotClosed ();
   
  SOL_N2_ON = YES;

  /*  Not for Calibration
    SOL_SHUTTER_OPEN = 0;
    for ( Debounce = 3000; Debounce; )
    {
       if ( !SN_SH_OPEN )  goto ( ForExit01 );
       TestHiTemp ();  
    }
    LCD_Error_ShutterNotOpen ();
ForExit01:  */

  /*
  RAC_Test_01 (); */
	
  MOTOR_ERROR =  NO;
  Debounce = 10000;
  SUB_MAX_PULSES = NO;
  StartMotorBk ();
  
  #asm
CalMmm_01:   
		call	TestForCalibrationLimit
		jnb     SN_TABLE_BACK, CalEndRun2Back
		jnb	MOT_ENA, CalEndRun2Back
		jmp	CalMmm_01
  #endasm


CalEndRun2Back:
  ACC_NOT_COMPLETE = YES;
  MOT_ENA = NO;
  MOT_STEP = NO;
  #asm
      Timer0Off
  #endasm


  SOL_SHUTTER_OPEN = 0;
  for ( Debounce = 3000; Debounce; )
  {
     if ( !SN_SH_OPEN )  goto ( CaliExit01 );
     TestHiTemp ();  
  }
  LCD_Error_ShutterNotOpen ();
CaliExit01:


  for ( Debounce = 2000; Debounce; )
  {
     TestHiTemp ();  
  }


  SOL_SHUTTER_OPEN = 1;
  for ( Debounce = 3000; Debounce; )
  {
     if ( !SN_SH_CLOSE )  goto ( CalForExit02 );
  }
  LCD_Error_ShutterNotClose ();
CalForExit02:


  /* Do something here????? */
  /* Go back to the front at the maximum speed... */
  Wait250ms ();
  SetMinSpeed ();
  CalibrationMotorFw ();
  Debounce = 10000;

  #asm
CalMmm_03:   
		call	CalibMotorMovement
		btfss	MOT_ENA / 8, MOT_ENA & 7
		jmp	CalAtHomePos
		jmp	CalMmm_03
  #endasm


CalAtHomePos:
  if ( SN_TABLE_HOME ) LCD_Error_RunHome ();
  MOT_STEP = NO;
  MainEndLoop ();
}


	#asm
		endif
	#endasm
