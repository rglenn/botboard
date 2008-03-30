
; CC5X Version 3.1I, Copyright (c) B Knudsen Data
; C compiler for the PICmicro family
; ************  16. Jun 2004   9:18  *************

	processor  16F873A
	radix  DEC

INDF        EQU   0x00
PCL         EQU   0x02
FSR         EQU   0x04
PCLATH      EQU   0x0A
Carry       EQU   0
Zero_       EQU   2
RP0         EQU   5
RP1         EQU   6
GIE         EQU   7
PORTC       EQU   0x07
RCSTA       EQU   0x18
TXREG       EQU   0x19
RCREG       EQU   0x1A
TRISC       EQU   0x87
TXSTA       EQU   0x98
SPBRG       EQU   0x99
PEIE        EQU   6
TXIF        EQU   4
RCIF        EQU   5
CREN        EQU   4
SPEN        EQU   7
TXIE        EQU   4
RCIE        EQU   5
BRGH        EQU   2
SYNC        EQU   4
TXEN        EQU   5
want_ints   EQU   0
want_ints_2 EQU   0
nate        EQU   0x31
x           EQU   0x31
nate_2      EQU   0x21
my_byte     EQU   0x22
i           EQU   0x24
k           EQU   0x25
m           EQU   0x26
temp        EQU   0x27
high_byte   EQU   0x28
low_byte    EQU   0x29
C1cnt       EQU   0x31
C2tmp       EQU   0x32
C3cnt       EQU   0x31
C4tmp       EQU   0x32
C5rem       EQU   0x34
command     EQU   0x20
ci          EQU   0x31

	GOTO main

  ; FILE D:\Pics\code\16F873\Serial Test\SerialTest-873A-4MHz.c
			;/*
			;    5-11-04
			;    Copyright Spark Fun Electronics© 2004
			;    
			;    16F873A
			;    
			;    Takes input from the user and displays it in hyperterminal 9600 8-N-1.
			;    
			;    Uses onboard UART at 9600.
			;*/
			;#include "d:\Pics\c\16F873A.h"
			;
			;#pragma origin 4
	ORG 0x0004

  ; FILE d:\Pics\code\Stdio.c
			;/*
			;    5/21/02
			;    Nathan Seidle
			;    nathan.seidle@colorado.edu
			;    
			;    Serial Out Started on 5-21
			;    rs_out Perfected on 5-24
			;    
			;    1Wire Serial Comm works with 4MHz Xtal
			;    Connect Serial_Out to Pin2 on DB9 Serial Connector
			;    Connect Pin5 on DB9 Connector to Signal Ground
			;    9600 Baud 8-N-1
			;    
			;    5-21 My first real C and Pic program.
			;    5-24 Attempting 20MHz implementation
			;    5-25 20MHz works
			;    5-25 Serial In works at 4MHz
			;    5-25 Passing Strings 9:20
			;    5-25 Option Selection 9:45
			;
			;    6-9  'Stdio.c' created. Printf working with %d and %h
			;    7-20 Added a longer delay after rs_out
			;         Trying to get 20MHz on the 16F873 - I think the XTal is bad.
			;         20MHz also needs 5V Vdd. Something I dont have.
			;    2-9-03 Overhauled the 4MHz timing. Serial out works very well now.
			;    
			;    6-16-03 Discovered how to pass string in cc5x
			;        void test(const char *str);
			;        test("zbcdefghij"); TXREG = str[1];
			;        
			;        Moved to hardware UART. Old STDIO will be in goodworks.
			;        
			;        Works great! Even got the special print characters (\n, \r, \0) to work.
			;    
			;    4-25-04 Added new %d routine to print 16 bit signed decimal numbers without leading 0s.
			;        
			;
			;*/
			;
			;//Setup the hardware UART TX module
			;void enable_uart_TX(bit want_ints)
			;{
_const1
	MOVWF ci
	MOVLW .26
	SUBWF ci,W
	BTFSC 0x03,Carry
	RETLW .0
	CLRF  PCLATH
	MOVF  ci,W
	ADDWF PCL,1
	RETLW .87
	RETLW .97
	RETLW .105
	RETLW .116
	RETLW .105
	RETLW .110
	RETLW .103
	RETLW .32
	RETLW .102
	RETLW .111
	RETLW .114
	RETLW .32
	RETLW .105
	RETLW .110
	RETLW .112
	RETLW .117
	RETLW .116
	RETLW .58
	RETLW .32
	RETLW .0
	RETLW .37
	RETLW .117
	RETLW .32
	RETLW .10
	RETLW .13
	RETLW .0
enable_uart_TX
			;
			;#ifdef Clock_4MHz
			;    #ifdef Baud_9600
			;    SPBRG = 6; //4MHz for 9600 Baud
			;    #endif
			;#endif
			;
			;#ifdef Clock_8MHz
			;    #ifdef Baud_4800
			;    SPBRG = 25; //8MHz for 4800 Baud
			;    #endif
			;    #ifdef Baud_9600
			;    SPBRG = 12; //8MHz for 9600 Baud
			;    #endif
			;#endif
			;
			;#ifdef Crazy_Osc
			;    #ifdef Baud_9600
			;    SPBRG = 32; //20MHz for 9600 Baud
			;    #endif
			;#endif
			;
			;#ifdef Clock_20MHz
			;    #ifdef Baud_9600
			;    SPBRG = 31; //20MHz for 9600 Baud
			;    #endif
			;
			;    #ifdef Baud_4800
			;    SPBRG = 64; //20MHz for 4800 Baud
			;    #endif
			;#endif
			;
			;    BRGH = 0; //Normal speed UART
	BSF   0x03,RP0
	BCF   0x03,RP1
	BCF   0x98,BRGH
			;
			;    SYNC = 0;
	BCF   0x98,SYNC
			;    SPEN = 1;
	BCF   0x03,RP0
	BSF   0x18,SPEN
			;
			;    if(want_ints) //Check if we want to turn on interrupts
	BTFSS 0x7F,want_ints
	GOTO  m001
			;    {
			;        TXIE = 1;
	BSF   0x03,RP0
	BSF   0x8C,TXIE
			;        PEIE = 1;
	BSF   0x0B,PEIE
			;        GIE = 1;
	BSF   0x0B,GIE
			;    }
			;
			;    TXEN = 1; //Enable transmission
m001	BSF   0x03,RP0
	BSF   0x98,TXEN
			;}    
	RETURN
			;
			;//Setup the hardware UART RX module
			;void enable_uart_RX(bit want_ints)
			;{
enable_uart_RX
			;
			;#ifdef Clock_4MHz
			;    #ifdef Baud_9600
			;    SPBRG = 6; //4MHz for 9600 Baud
			;    #endif
			;#endif
			;
			;#ifdef Clock_20MHz
			;    #ifdef Baud_9600
			;    SPBRG = 31; //20MHz for 9600 Baud
			;    #endif
			;
			;    #ifdef Baud_4800
			;    SPBRG = 64; //20MHz for 4800 Baud
			;    #endif
			;#endif
			;
			;    BRGH = 0; //Normal speed UART
	BSF   0x03,RP0
	BCF   0x03,RP1
	BCF   0x98,BRGH
			;
			;    SYNC = 0;
	BCF   0x98,SYNC
			;    SPEN = 1;
	BCF   0x03,RP0
	BSF   0x18,SPEN
			;
			;    CREN = 1;
	BSF   0x18,CREN
			;
			;    //WREN = 1;
			;
			;    if(want_ints) //Check if we want to turn on interrupts
	BTFSS 0x7F,want_ints_2
	GOTO  m002
			;    {
			;        RCIE = 1;
	BSF   0x03,RP0
	BSF   0x8C,RCIE
			;        PEIE = 1;
	BSF   0x0B,PEIE
			;        GIE = 1;
	BSF   0x0B,GIE
			;    }
			;
			;}    
m002	BCF   0x03,RP0
	RETURN
			;
			;//Sends nate to the Transmit Register
			;void putc(uns8 nate)
			;{
putc
	MOVWF nate
			;    while(TXIF == 0);
m003	BTFSS 0x0C,TXIF
	GOTO  m003
			;    TXREG = nate;
	MOVF  nate,W
	MOVWF TXREG
			;}
	RETURN
			;
			;uns8 getc(void)
			;{
getc
			;    while(RCIF == 0);
m004	BTFSS 0x0C,RCIF
	GOTO  m004
			;    return (RCREG);
	MOVF  RCREG,W
	RETURN
			;}    
			;
			;//Returns ASCII Decimal and Hex values
			;uns8 bin2Hex(char x)
			;{
bin2Hex
	MOVWF x
			;   skip(x);
	CLRF  PCLATH
	MOVF  x,W
	ADDWF PCL,1
			;   #pragma return[16] = "0123456789ABCDEF"
	RETLW .48
	RETLW .49
	RETLW .50
	RETLW .51
	RETLW .52
	RETLW .53
	RETLW .54
	RETLW .55
	RETLW .56
	RETLW .57
	RETLW .65
	RETLW .66
	RETLW .67
	RETLW .68
	RETLW .69
	RETLW .70
			;}
			;
			;//Prints a string including variables
			;void printf(const char *nate, int16 my_byte)
			;{
printf
			;  
			;    uns8 i, k, m, temp;
			;    uns8 high_byte = 0, low_byte = 0;
	CLRF  high_byte
	CLRF  low_byte
			;    uns8 y, z;
			;    
			;    uns8 decimal_output[5];
			;    
			;    for(i = 0 ; ; i++)
	CLRF  i
			;    {
			;        k = nate[i];
m005	MOVF  i,W
	ADDWF nate_2,W
	CALL  _const1
	MOVWF k
			;
			;        if (k == '\0') 
	MOVF  k,1
	BTFSC 0x03,Zero_
			;            break;
	GOTO  m027
			;
			;        else if (k == '%') //Print var
	XORLW .37
	BTFSS 0x03,Zero_
	GOTO  m025
			;        {
			;            i++;
	INCF  i,1
			;            k = nate[i];
	MOVF  i,W
	ADDWF nate_2,W
	CALL  _const1
	MOVWF k
			;
			;            if (k == '\0') 
	MOVF  k,1
	BTFSC 0x03,Zero_
			;                break;
	GOTO  m027
			;            else if (k == '\\') //Print special characters
	XORLW .92
	BTFSS 0x03,Zero_
	GOTO  m006
			;            {
			;                i++;
	INCF  i,1
			;                k = nate[i];
	MOVF  i,W
	ADDWF nate_2,W
	CALL  _const1
	MOVWF k
			;                
			;                putc(k);
	CALL  putc
			;                
			;
			;            } //End Special Characters
			;            else if (k == 'b') //Print Binary
	GOTO  m026
m006	MOVF  k,W
	XORLW .98
	BTFSS 0x03,Zero_
	GOTO  m011
			;            {
			;                for( m = 0 ; m < 8 ; m++ )
	CLRF  m
m007	MOVLW .8
	SUBWF m,W
	BTFSC 0x03,Carry
	GOTO  m026
			;                {
			;                    if (my_byte.7 == 1) putc('1');
	BTFSS my_byte,7
	GOTO  m008
	MOVLW .49
	CALL  putc
			;                    if (my_byte.7 == 0) putc('0');
m008	BTFSC my_byte,7
	GOTO  m009
	MOVLW .48
	CALL  putc
			;                    if (m == 3) putc(' ');
m009	MOVF  m,W
	XORLW .3
	BTFSS 0x03,Zero_
	GOTO  m010
	MOVLW .32
	CALL  putc
			;                    
			;                    my_byte = my_byte << 1;
m010	BCF   0x03,Carry
	RLF   my_byte,1
	RLF   my_byte+1,1
			;                }
	INCF  m,1
	GOTO  m007
			;            } //End Binary               
			;            else if (k == 'd') //Print Decimal
m011	MOVF  k,W
	XORLW .100
	BTFSS 0x03,Zero_
	GOTO  m021
			;            {
			;                //Print negative sign and take 2's compliment
			;                /*
			;                if(my_byte < 0)
			;                {
			;                    putc('-');
			;                    my_byte ^= 0xFFFF;
			;                    my_byte++;
			;                }
			;                */
			;                
			;                //Divide number by a series of 10s
			;                for(m = 4 ; my_byte > 0 ; m--)
	MOVLW .4
	MOVWF m
m012	BTFSC my_byte+1,7
	GOTO  m019
	MOVF  my_byte,W
	IORWF my_byte+1,W
	BTFSC 0x03,Zero_
	GOTO  m019
			;                {
			;                    temp = my_byte % (uns16)10;
	MOVF  my_byte,W
	MOVWF C2tmp
	MOVF  my_byte+1,W
	MOVWF C2tmp+1
	CLRF  temp
	MOVLW .16
	MOVWF C1cnt
m013	RLF   C2tmp,1
	RLF   C2tmp+1,1
	RLF   temp,1
	BTFSC 0x03,Carry
	GOTO  m014
	MOVLW .10
	SUBWF temp,W
	BTFSS 0x03,Carry
	GOTO  m015
m014	MOVLW .10
	SUBWF temp,1
m015	DECFSZ C1cnt,1
	GOTO  m013
			;                    decimal_output[m] = temp;
	MOVLW .44
	ADDWF m,W
	MOVWF FSR
	MOVF  temp,W
	MOVWF INDF
			;                    my_byte = my_byte / (uns16)10;               
	MOVF  my_byte,W
	MOVWF C4tmp
	MOVF  my_byte+1,W
	MOVWF C4tmp+1
	CLRF  C5rem
	MOVLW .16
	MOVWF C3cnt
m016	RLF   C4tmp,1
	RLF   C4tmp+1,1
	RLF   C5rem,1
	BTFSC 0x03,Carry
	GOTO  m017
	MOVLW .10
	SUBWF C5rem,W
	BTFSS 0x03,Carry
	GOTO  m018
m017	MOVLW .10
	SUBWF C5rem,1
	BSF   0x03,Carry
m018	RLF   my_byte,1
	RLF   my_byte+1,1
	DECFSZ C3cnt,1
	GOTO  m016
			;                }
	DECF  m,1
	GOTO  m012
			;                
			;                for(m++ ; m < 5 ; m++)
m019	INCF  m,1
m020	MOVLW .5
	SUBWF m,W
	BTFSC 0x03,Carry
	GOTO  m026
			;                    putc(bin2Hex(decimal_output[m]));
	MOVLW .44
	ADDWF m,W
	MOVWF FSR
	MOVF  INDF,W
	CALL  bin2Hex
	CALL  putc
	INCF  m,1
	GOTO  m020
			;    
			;            } //End Decimal
			;            else if (k == 'h') //Print Hex
m021	MOVF  k,W
	XORLW .104
	BTFSS 0x03,Zero_
	GOTO  m023
			;            {
			;                //New trick 3-15-04
			;                putc('0');
	MOVLW .48
	CALL  putc
			;                putc('x');
	MOVLW .120
	CALL  putc
			;                
			;                if(my_byte > 0x00FF)
	BTFSC my_byte+1,7
	GOTO  m022
	MOVF  my_byte+1,1
	BTFSC 0x03,Zero_
	GOTO  m022
			;                {
			;                    putc(bin2Hex(my_byte.high8 >> 4));
	SWAPF my_byte+1,W
	ANDLW .15
	CALL  bin2Hex
	CALL  putc
			;                    putc(bin2Hex(my_byte.high8 & 0b.0000.1111));
	MOVLW .15
	ANDWF my_byte+1,W
	CALL  bin2Hex
	CALL  putc
			;                }
			;
			;                putc(bin2Hex(my_byte.low8 >> 4));
m022	SWAPF my_byte,W
	ANDLW .15
	CALL  bin2Hex
	CALL  putc
			;                putc(bin2Hex(my_byte.low8 & 0b.0000.1111));
	MOVLW .15
	ANDWF my_byte,W
	CALL  bin2Hex
	CALL  putc
			;
			;                /*high_byte.3 = my_byte.7;
			;                high_byte.2 = my_byte.6;
			;                high_byte.1 = my_byte.5;
			;                high_byte.0 = my_byte.4;
			;            
			;                low_byte.3 = my_byte.3;
			;                low_byte.2 = my_byte.2;
			;                low_byte.1 = my_byte.1;
			;                low_byte.0 = my_byte.0;
			;        
			;                putc('0');
			;                putc('x');
			;            
			;                putc(bin2Hex(high_byte));
			;                putc(bin2Hex(low_byte));*/
			;            } //End Hex
			;            else if (k == 'f') //Print Float
	GOTO  m026
m023	MOVF  k,W
	XORLW .102
	BTFSS 0x03,Zero_
	GOTO  m024
			;            {
			;                putc('!');
	MOVLW .33
	CALL  putc
			;            } //End Float
			;            else if (k == 'u') //Print Direct Character
	GOTO  m026
m024	MOVF  k,W
	XORLW .117
	BTFSS 0x03,Zero_
	GOTO  m026
			;            {
			;                //All ascii characters below 20 are special and screwy characters
			;                //if(my_byte > 20) 
			;                    putc(my_byte);
	MOVF  my_byte,W
	CALL  putc
			;            } //End Direct
			;                        
			;        } //End Special Chars           
			;
			;        else
	GOTO  m026
			;            putc(k);
m025	MOVF  k,W
	CALL  putc
			;    }    
m026	INCF  i,1
	GOTO  m005

  ; FILE D:\Pics\code\16F873\Serial Test\SerialTest-873A-4MHz.c
			;
			;#include "d:\Pics\code\Stdio.c"     // Basic Serial IO
m027	RETURN
			;
			;void main()
			;{
main
			;    uns8 command; //Declare the variable
			;    
			;    PORTC = 0b.0000.0000;
	BCF   0x03,RP0
	BCF   0x03,RP1
	CLRF  PORTC
			;    TRISC = 0b.1000.0000;  //0 = Output, 1 = Input RC7 - Incoming Data RX
	MOVLW .128
	BSF   0x03,RP0
	MOVWF TRISC
			;
			;    SPBRG = 25; //4MHz for 9600 baud rate
	MOVLW .25
	MOVWF SPBRG
			;    TXSTA = 0b.0010.0100; //8-bit asych mode, high speed uart enabled
	MOVLW .36
	MOVWF TXSTA
			;    RCSTA = 0b.1001.0000; //Serial port enable, 8-bit asych continous receive mode
	MOVLW .144
	BCF   0x03,RP0
	MOVWF RCSTA
			;
			;    while(1)
			;    {
			;        printf("Waiting for input: ", 0);
m028	CLRF  nate_2
	CLRF  my_byte
	CLRF  my_byte+1
	CALL  printf
			;        command = getc(); //It will sit here for ever until the PIC receives a character
	CALL  getc
	MOVWF command
			;        
			;        printf("%u \n\r", command); //Print what you typed
	MOVLW .20
	MOVWF nate_2
	MOVF  command,W
	MOVWF my_byte
	CLRF  my_byte+1
	CALL  printf
			;    }
	GOTO  m028

	END


; *** KEY INFO ***

; 0x0026 P0   15 word(s)  0 % : enable_uart_TX
; 0x0035 P0   15 word(s)  0 % : enable_uart_RX
; 0x0044 P0    6 word(s)  0 % : putc
; 0x004A P0    4 word(s)  0 % : getc
; 0x004E P0   20 word(s)  0 % : bin2Hex
; 0x0062 P0  183 word(s)  8 % : printf
; 0x0004 P0   34 word(s)  1 % : _const1
; 0x0119 P0   26 word(s)  1 % : main

; RAM usage: 22 bytes (22 local), 170 bytes free
; Maximum call level: 2
;  Codepage 0 has  304 word(s) :  14 %
;  Codepage 1 has    0 word(s) :   0 %
; Total of 304 code words (7 %)
