


#define	NO		0
#define	YES		1

#define	MOTDIR_2FRONT 	0
#define	MOTDIR_2BACK 	1

extern	bit 		SN_TEMP_HI, SN_TABLE_HOME;
extern	bit 		MOT_DIR, MOT_ENA, MOTOR_ERROR, TIME0_MOD;


extern	unsigned char	Motor_Extra;
extern	unsigned int	TableCnt;

#label	_B_a



void	SetMotor	( void )
{
     Motor_Extra = 6;
     MOT_ENA = YES;
     TIME0_MOD = NO;
	#asm
     Timer0On
     	#endasm
}



void	StartMotorFw ( void )
{
   MOT_DIR = MOTDIR_2FRONT;
   InitTableCnt ();
   SetMotor ();
}


void	CalibrationMotorFw ( void )
{
   MOT_DIR = MOTDIR_2FRONT;
 /*InitTableCnt ();*/
   SetMotor ();
}




void	StartMotorBk ( void )
{
   MOT_DIR = MOTDIR_2BACK;
   TableCnt = 0;
   SetMotor ();
}



void	FwMotion ( void )
{
  TestHiTemp ();  
  if ( !MOT_ENA)
  {
    #asm
      Timer0Off
    #endasm
  }
}


	#asm
		if ( CAN_RUN )
MotorMovement:	call	TestHiTemp
		call	Accelerate
		movf	Debounce, W
		iorwf	Debounce + 1, W
		btfss	STATUS, Z
		return
		jmp	LCD_Error_MotorTimeOut

		endif
	#endasm




void	BkMotion ( void )
{
  TestHiTemp ();  
  if ( !MOT_ENA)
  {
    #asm
      Timer0Off
    #endasm
  }
}



void	StopTableMotor ( void )
{
    
    if ( !Motor_Extra )
    {
      MOT_ENA = NO;
      #asm
         Timer0Off
      #endasm
    }

}



