

#define	NO		0
#define	YES		1


#define	NULL		0


#label	_C_a



extern	bit		APP_KEY_HIT, SPEED_IS_SET, LED_LED;
extern	unsigned int	TableCnt;

	#asm
		if ( SPEED_CONFIG )
	#endasm
void	SpeedConfig	( void )
{

  LED_LED = NO;

  SetRunSpeed ();
  StrCurSpeed ();
  ShowGraph ();

  /*
  StartMotorFw (); */

  SPEED_IS_SET = YES;
  while ( 1 )
  {
    /* 
    InitTableCnt (); */
    TestHiTemp ();  
    ReadKeyPad();
    if ( APP_KEY_HIT )
    {
      APP_KEY_HIT = NO;
      SpeedKeyHit ();
    }
  }
}
	#asm
		endif
	#endasm


