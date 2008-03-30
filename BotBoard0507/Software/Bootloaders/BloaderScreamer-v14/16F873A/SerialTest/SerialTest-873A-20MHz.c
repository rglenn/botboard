/*
    5-11-04
    Copyright Spark Fun Electronics© 2004
    
    16F873A
    
    Takes input from the user and displays it in hyperterminal 9600 8-N-1.
    
    Uses onboard UART at 9600.
*/
#include "d:\Pics\c\16F873A.h"

#pragma origin 4

#include "d:\Pics\code\Stdio.c"     // Basic Serial IO

void main()
{
    uns8 command; //Declare the variable
    
    PORTC = 0b.0000.0000;
    TRISC = 0b.1000.0000;  //0 = Output, 1 = Input RC7 - Incoming Data RX

    SPBRG = 129; //20MHz for 9600 baud rate
    TXSTA = 0b.0010.0100; //8-bit asych mode, high speed uart enabled
    RCSTA = 0b.1001.0000; //Serial port enable, 8-bit asych continous receive mode

    while(1)
    {
        printf("Waiting for input: ", 0);
        command = getc(); //It will sit here for ever until the PIC receives a character
        
        printf("%u \n\r", command); //Print what you typed
    }
}

