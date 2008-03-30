#include <16F877A.H>

#pragma origin 4            //"code bumping" -  make room for the bootloader

bit LED @ PORTC.0;          //pin our LED is connected to

void delay_10ms(char);      //10ms delay function

void main(void)
{
    TRISA = 255;            //configure PORTA as inputs
    TRISB = 0b00000000;     //configure PORTB as outputs
    TRISC = 0b00000000;     //configure PORTC as outputs
    ADCON1 = 7;             //disasble the ADC
    
    while (1)
    {
        LED = !LED;         //invert the LED
        delay_10ms(50);     //wait 500ms
    }                       //loop forever
}

void delay_10ms(char repetitions)
{
    char i;
    char d1;
    char d2;
    
    for(i=0;i<repetitions;i++)
    {
        // following code from PICLIST delay generator
        #asm
        			;49998 cycles	movlw	0x0F	movwf	d1	movlw	0x28	movwf	d2Delay_0	decfsz	d1, f	goto	$+2	decfsz	d2, f	goto	Delay_0			;2 cycles	goto	$+1
        #endasm
    }
}