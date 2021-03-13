


#define	NO		0
#define	YES		1



extern	bit		KEY_ROW1, KEY_ROW2;
extern	bit		KEY_TIME_FLAG, KEY_IS_HIT;
extern	unsigned byte	PORTA, KeyDebounce, PrevKeyRead, TEMP, ANS_L;

#label	_C_a

void	SetTheKey	( void )
{
	#asm
		movf	PrevKeyRead, W
		movwf	TEMP
		movlw	5
		movwf	ANS_L

key_start:
		rrf	TEMP, F
		jc	GoodKeyRead	
		decfsz	ANS_L, F
		jmp	key_start

GoodKeyRead:
		movf	ANS_L, W			
	#endasm
}

void ReadKeyPad ( void )
{
	#asm
		jnb	KEY_TIME_FLAG, NoKeyTick
		clr	KEY_TIME_FLAG


		movf	PORTA, W
		andlw	B'00011111'
		xorlw	B'00011111'
		movwf	TEMP
		xorlw	0x1F
		jz	NoKeyAtThisTime		; found all ones..
		xorlw	0x1F
		xorwf	PrevKeyRead, W
		jnz	keyIsNotTheSame
		movf	KeyDebounce, W
		xorlw	0xFF
		jnz	KeepDebouncing
		jb	KEY_IS_HIT, NoKeyTick
		setb	KEY_IS_HIT


		movf	PrevKeyRead, W
		movwf	TEMP
		movlw	4
		movwf	ANS_L

key_start:
		rrf	TEMP, F
		jc	GoodKeyRead	
		decfsz	ANS_L, F
		jmp	key_start
GoodKeyRead:
		movf	ANS_L, W
		btfsc	PORTE, 0	; KEY_ROW1
		addlw	5
		return			








	
	
	
	
			

KeepDebouncing:
		decf	KeyDebounce, F
		jmp	NoKeyTick

NoKeyAtThisTime:
		jb	KEY_ROW1, TestRow2
		setb	KEY_ROW1
		clr	KEY_ROW2
		jmp	keyIsNotTheSame
TestRow2:
		jb	KEY_ROW2, SetUpRows
		setb	KEY_ROW1
		setb	KEY_ROW2
		jmp	keyIsNotTheSame
SetUpRows:	
		clr	KEY_ROW1
	       ;setb	KEY_ROW2



keyIsNotTheSame:
		movf	TEMP, W
		movwf	PrevKeyRead
		movlw	D'10'			; 10ms debounce time...
		movwf	KeyDebounce
		clr	KEY_IS_HIT


NoKeyTick:
		movlw	D'10'
	#endasm
}






void	KeyFunc	( void )
{
  if ( !KEY_ROW1 )
  {
    ReadKeyPad ();
	#asm
		jc	BadRead1
		jz	GoodKey1
		return
GoodKey1:
		call	SetTheKey
		jmp	Key1Table

BadRead1:
		setb	KEY_ROW1
		clr	KEY_ROW2
		return	
	#endasm
  }
  
  if ( !KEY_ROW2 )
  {
    ReadKeyPad ();
	#asm
		jc	BadRead2
		jz	GoodKey2
		return

GoodKey2:
		call	SetTheKey
		jmp	Key2Table


BadRead2:
		setb	KEY_ROW1
		setb	KEY_ROW2
		return	
	#endasm
  }

  if ( KEY_TIME_FLAG )
  {
    KEY_ROW1 = NO;
    KEY_ROW2 = YES;
    KEY_TIME_FLAG = NO;
  }
	#asm
		movlw	D'10'
	#endasm
}


