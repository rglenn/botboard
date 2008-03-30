#define _16F877
#include <pic1687x.h>

//macro to set up IO pins
#define	PORTBIT(adr, bit)	((unsigned)(&adr)*8+(bit))

//IO pins
static bit	Motor1Power @	PORTBIT(PORTB, 5);
static bit	Motor2Power @	PORTBIT(PORTB, 3);
static bit	Motor3Power @	PORTBIT(PORTB, 1);
static bit	Motor4Power @	PORTBIT(PORTD, 7);
static bit	Motor1Dir @	PORTBIT(PORTB, 4);
static bit	Motor2Dir @	PORTBIT(PORTB, 2);
static bit	Motor3Dir @	PORTBIT(PORTB, 0);
static bit	Motor4Dir @	PORTBIT(PORTD, 6);

//this translates as:
//Motor 1 on J3
//Motor 2 on J4
//Motor 3 on J6
//Motor 4 on J7

//variables for speeds and pwm counter
unsigned char Motor1Speed;
unsigned char Motor2Speed;
unsigned char Motor3Speed;
unsigned char Motor4Speed;
unsigned char pwmCount;

//interrupt code
void proc_interrupt(void);

//this is where it gets interesting - this section jumps to the
//main code, in concert with the linker instructions to make
//room for the bootloader jump
#asm
psect reserved,class=CODE, delta=2
GOTO 0x20; Jump to init code
#endasm 

//main code
void main(void)
{
    ADCON1 = 0b00000110; // PORT A is digital in this program
    PORTB = 0;		// all port B off
    PORTD = 0;		// all port D off
    TRISB = 0b00000000; // all port B outputs
	TRISD = 0b00000000; // all port D outputs
    OPTION = 0b00001000; // prescaler assigned to WDT, TMR0 is 1:1
    T0IE = 1;			// enable timer interrupts
    GIE = 1;			// enable interrupts
    
    Motor1Speed = 50;	// 1/5th motor duty cycle
    Motor2Speed = 50;	
    Motor3Speed = 255;	// full motor duty cycle
    Motor4Speed = 255;
    pwmCount = 0;		// reset PWM counter

    Motor1Dir = 1;		// motor 1 forwards
    Motor2Dir = 1;		// motor 2 backwards
    Motor3Dir = 1;		// motor 3 forwards
    Motor4Dir = 1;		// motor 4 backwards
    
    while(1) {			// execute nothing forever - all motor timing in ISR above
    }
}

//this is the actual isr - in order to ensure that the code
//is put into proper places by the linker, and that everything
//executes nicely, this just calls out to the proc_interrupt
//function to do the actual interrupt processing
static void interrupt isr(void)
{
	proc_interrupt();
	return;
}

//this code actually handles the interrupt processing
void proc_interrupt(void)
{
    if(T0IF) {		// if Timer0 overflowed (happens every 256 clock cycles)
        pwmCount++;
        if(pwmCount >=Motor1Speed) {Motor1Power = 0;} else Motor1Power = 1;		// if the PWM counter exceeds the speed value, line is low, otherwise line is high
        if(pwmCount >=Motor2Speed) {Motor2Power = 0;} else Motor2Power = 1;
        if(pwmCount >=Motor3Speed) {Motor3Power = 0;} else Motor3Power = 1;
        if(pwmCount >=Motor4Speed) {Motor4Power = 0;} else Motor4Power = 1;
        T0IF = 0;	// reset interrupt flag
    }
	return;
}
