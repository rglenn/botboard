#define XTAL_FREQ 20MHZ

#include "delay.h"
#include <pic1687x.h>

#define	PORTBIT(adr, bit)	((unsigned)(&adr)*8+(bit))

static bit	LED @	PORTBIT(PORTC, 0);

#asm
psect reserved,class=CODE, delta=2
GOTO 0x10; Jump to init code
#endasm 

void main(void)
{
	TRISA = 0b00000000;
	TRISB = 0b00000000;
	TRISC = 0b00000000;
//	TRISD = 0b00000000;
//	TRISE = 0b00000000;

	PORTA = 0b00000000;
	PORTB = 0b00000000;
	PORTC = 0b00000000;
//	PORTD = 0b00000000;
//	PORTE = 0b00000000;

	ADCON1 = 7;


	while(1) {
		LED = !LED;
		DelayBigMs(500);
	}
}

static void interrupt isr(void)
{
	return;
}
