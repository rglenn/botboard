
; CC5X Version 3.1I, Copyright (c) B Knudsen Data
; C compiler for the PICmicro family
; ************  16. Jun 2004   9:08  *************

	processor  16F876A
	radix  DEC

INDF        EQU   0x00
PCL         EQU   0x02
FSR         EQU   0x04
PORTA       EQU   0x05
TRISA       EQU   0x85
PORTB       EQU   0x06
TRISB       EQU   0x86
PCLATH      EQU   0x0A
PA0         EQU   3
PA1         EQU   4
Carry       EQU   0
Zero_       EQU   2
RP0         EQU   5
RP1         EQU   6
IRP         EQU   7
PORTC       EQU   0x07
TMR1L       EQU   0x0E
TMR1H       EQU   0x0F
RCSTA       EQU   0x18
TXREG       EQU   0x19
RCREG       EQU   0x1A
TRISC       EQU   0x87
TXSTA       EQU   0x98
SPBRG       EQU   0x99
EEDATA      EQU   0x10C
EEADR       EQU   0x10D
EEDATH      EQU   0x10E
EEADRH      EQU   0x10F
EECON2      EQU   0x18D
TMR1IF      EQU   0
TXIF        EQU   4
RCIF        EQU   5
TMR1ON      EQU   0
CREN        EQU   4
TXEN        EQU   5
WR          EQU   1
WREN        EQU   2
EEPGD       EQU   7
x           EQU   0x20
y           EQU   0x21
z           EQU   0x22
memory_address EQU   0x37
record_length EQU   0x39
i           EQU   0x23
temp        EQU   0x24
check_sum   EQU   0x25
i_2         EQU   0x26
nate        EQU   0x26

	ORG 0x0003
	GOTO main

  ; FILE D:\Pics\code\16F876\Bloader\Bloader-876A-4MHz.c
			;/*
			;    1-4-04
			;    Copyright Spark Fun Electronics© 2004
			;    
			;    Boot loader for the 16F876A
			;    
			;    See updates.txt for version updates
			;*/
			;//Where the restricted area starts
			;#define BLOADER_START 0x1F40
			;#define BLOADER_START_HIGH 0x1F
			;#define BLOADER_START_LOW 0x40
			;
			;#include "d:\Pics\c\16F876A.h"  //Device definitions
			;
			;#pragma config |= 0x3F32 //HS Oscillator, No WDT, MCLR Enabled
			;
			;//These set the first three code words of the program
			;//Jump to bloader on reset or power on
			;#pragma cdata[0] = /*BSF*/0x1400 + /*PCLATH*/10 + (/*bit*/3 << 7)
			;#pragma cdata[1] = /*BSF*/0x1400 + /*PCLATH*/10 + (/*bit*/4 << 7)
			;#pragma cdata[2] = /*GOTO*/0x2800 + (BLOADER_START & 0x7FF)
			;
			;#pragma resetVector 3
			;
			;void bloader(void);
			;void onboard_program_write(void);
			;void putc(uns8 nate);
			;uns8 getc(void);
			;
			;void main()
			;{
main
			;    uns8 x, y, z;
			;
			;    //Setup the ports
			;    //=============================================================
			;    PORTA = 0b.0000.0000;
	BCF   0x03,RP0
	BCF   0x03,RP1
	CLRF  PORTA
			;    TRISA = 0b.0000.0000;  //0 = Output, 1 = Input
	BSF   0x03,RP0
	CLRF  TRISA
			;    PORTB = 0b.0000.0000;
	BCF   0x03,RP0
	CLRF  PORTB
			;    TRISB = 0b.0000.0000;  //0 = Output, 1 = Input
	BSF   0x03,RP0
	CLRF  TRISB
			;    PORTC = 0b.0000.0000;
	BCF   0x03,RP0
	CLRF  PORTC
			;    TRISC = 0b.1000.0000;  //0 = Output, 1 = Input RC7 - Incoming Data RX
	MOVLW .128
	BSF   0x03,RP0
	MOVWF TRISC
			;    //=============================================================
			;
			;    TXEN = 1; //Enable transmission
	BSF   0x98,TXEN
			;    
			;    //Standard blinky program @ 20MHz
			;    while(1)
			;    {
			;        PORTA = 0xFF;
	BCF   0x03,RP0
m001	MOVLW .255
	MOVWF PORTA
			;        PORTB = 0xFF;
	MOVWF PORTB
			;        for(x = 0 ; x < 5 ; x++)
	CLRF  x
m002	MOVLW .5
	SUBWF x,W
	BTFSC 0x03,Carry
	GOTO  m007
			;            for(y = 0 ; y < 255 ; y++)
	CLRF  y
m003	INCF  y,W
	BTFSC 0x03,Zero_
	GOTO  m006
			;                for (z = 0 ; z < 255 ; z++);
	CLRF  z
m004	INCF  z,W
	BTFSC 0x03,Zero_
	GOTO  m005
	INCF  z,1
	GOTO  m004
m005	INCF  y,1
	GOTO  m003
m006	INCF  x,1
	GOTO  m002
			;
			;        PORTA = 0x00;
m007	CLRF  PORTA
			;        PORTB = 0x00;
	CLRF  PORTB
			;        for(x = 0 ; x < 5 ; x++)
	CLRF  x
m008	MOVLW .5
	SUBWF x,W
	BTFSC 0x03,Carry
	GOTO  m013
			;            for(y = 0 ; y < 255 ; y++)
	CLRF  y
m009	INCF  y,W
	BTFSC 0x03,Zero_
	GOTO  m012
			;                for (z = 0 ; z < 255 ; z++);
	CLRF  z
m010	INCF  z,W
	BTFSC 0x03,Zero_
	GOTO  m011
	INCF  z,1
	GOTO  m010
m011	INCF  y,1
	GOTO  m009
m012	INCF  x,1
	GOTO  m008
			;
			;        putc('O');
m013	MOVLW .79
	BSF   0x0A,PA0
	BSF   0x0A,PA1
	CALL  putc
			;        putc('k');
	MOVLW .107
	CALL  putc
	BCF   0x0A,PA0
	BCF   0x0A,PA1
			;                
			;    }
	GOTO  m001
			;    
			;    while(1);
m014	GOTO  m014
			;    
			;    //This is just here so that we can see the memory address to jump to 
			;    //under ICProg. It never gets executed and will get written over upon 
			;    //new program loading.
			;    //It also forces the compiler to correctly allocate variable space needed
			;    //for the bloader
			;    bloader();
	BSF   0x0A,PA0
	BSF   0x0A,PA1
	CALL  bloader
	BCF   0x0A,PA0
	BCF   0x0A,PA1
			;
			;}//End Main
	SLEEP
	GOTO main
			;  
			;#pragma origin BLOADER_START
	ORG 0x1F40
			;
			;//Here are the global variables for the boot loader.
			;//These are destroyed once the user's program starts.
			;uns8 incoming_buffer[16]; //Presume no record will be longer than 16 bytes
			;uns16 memory_address;
			;uns8 record_length;
			;
			;void onboard_program_write(void);
			;void putc(uns8 nate);
			;uns8 getc(void);
			;
			;//The PIC sends ASC(5)-enquiry out and waits for return ASC(6)-ack from computer.
			;//If ACK is seen, PIC goes into load mode, otherwise, returns to main 
			;//The PIC will transmit a 'T' and wait for a ':' to start listening
			;void bloader(void)
			;{
bloader
			;    uns8 i, temp;
			;    uns8 check_sum = 0;
	CLRF  check_sum
			;
			;    //Sets up the various I/O ports and UART for serial comm
			;    //=============================================================
			;    PORTC = 0b.0000.0000;
	CLRF  PORTC
			;    TRISC = 0b.1000.0000;  //0 = Output, 1 = Input RC7 - Incoming Data RX
	MOVLW .128
	BSF   0x03,RP0
	MOVWF TRISC
			;
			;    //Setup the hardware UART module
			;    //SPBRG = 129; //20MHz for 9600 inital communication baud rate
			;    SPBRG = 25; //4MHz for 9600 inital communication baud rate - Not yet tested
	MOVLW .25
	MOVWF SPBRG
			;    TXSTA = 0b.0010.0100; //8-bit asych mode, high speed uart enabled
	MOVLW .36
	MOVWF TXSTA
			;    RCSTA = 0b.1001.0000; //Serial port enable, 8-bit asych continous receive mode
	MOVLW .144
	BCF   0x03,RP0
	MOVWF RCSTA
			;    //=============================================================
			;
			;    for(i = 0 ; i < 255 ; i++);
	CLRF  i
m015	INCF  i,W
	BTFSC 0x03,Zero_
	GOTO  m016
	INCF  i,1
	GOTO  m015
			;
			;    putc(5); //PIC tells the world it can be loaded, by broadcasting an Enquiry
m016	MOVLW .5
	CALL  putc
			;
			;    TMR1H = 0; TMR1L = 0; TMR1ON = 1; //Setup and turn on hardware timer1
	CLRF  TMR1H
	CLRF  TMR1L
	BSF   0x10,TMR1ON
			;
			;    while(RCIF == 0) //Check to see if the computer responded
m017	BTFSC 0x0C,RCIF
	GOTO  m018
			;        if (TMR1IF) break; //If timer1 rolls over, go to normal boot up
	BTFSS 0x0C,TMR1IF
	GOTO  m017
			;    TMR1ON = 0; //Turn off timer1
m018	BCF   0x10,TMR1ON
			;
			;    if (RCREG != 6) goto JUMP_VECTOR; //If the computer did not respond correctly with a ACK, we go into normal boot up mode
	MOVF  RCREG,W
	XORLW .6
	BTFSS 0x03,Zero_
	GOTO  m031
			;
			;    while(RCIF == 0); //Wait for computer to transmit UART speed
m019	BTFSS 0x0C,RCIF
	GOTO  m019
			;    SPBRG = RCREG; //Setup the hardware UART module
	MOVF  RCREG,W
	BSF   0x03,RP0
	MOVWF SPBRG
			;    
			;    //Short delay while computer re-adjusts the port speed under VB
			;    for(i = 0 ; i < 255 ; i++)
	BCF   0x03,RP0
	CLRF  i
m020	INCF  i,W
	BTFSC 0x03,Zero_
	GOTO  m023
			;        for(temp = 0 ; temp < 255 ; temp++);
	CLRF  temp
m021	INCF  temp,W
	BTFSC 0x03,Zero_
	GOTO  m022
	INCF  temp,1
	GOTO  m021
m022	INCF  i,1
	GOTO  m020
			;
			;    //Send out the starting memory location of the Bloader
			;    putc(BLOADER_START_HIGH); //This will tell the computer how to remap the boot vector
m023	MOVLW .31
	CALL  putc
			;    putc(BLOADER_START_LOW); //This will avoid writing into restricted bloader code space
	MOVLW .64
	CALL  putc
			;
			;    while(1)
			;    {
			;        //Determine if the last received data was good or bad
			;        if (check_sum != 0) //If the check sum does not compute, tell computer to resend same line
m024	MOVF  check_sum,1
	BTFSC 0x03,Zero_
	GOTO  m025
			;            putc(7); //Ascii character BELL
	MOVLW .7
	CALL  putc
			;        else            
	GOTO  m026
			;            putc('T'); //Tell the computer that we are ready for the next line
m025	MOVLW .84
	CALL  putc
			;        
			;        while(getc() != ':'); //Wait for the computer to initiate transfer
m026	CALL  getc
	XORLW .58
	BTFSS 0x03,Zero_
	GOTO  m026
			;
			;        record_length = getc(); //Get the length of this block
	CALL  getc
	MOVWF record_length
			;
			;        if (record_length == 'S') goto JUMP_VECTOR; //Check to see if we are done - new boot vector
	XORLW .83
	BTFSC 0x03,Zero_
	GOTO  m031
			;
			;        memory_address.high8 = getc(); //Get the memory address at which to store this block of data
	CALL  getc
	MOVWF memory_address+1
			;        memory_address.low8 = getc();
	CALL  getc
	MOVWF memory_address
			;        
			;        check_sum = getc(); //Pick up the check sum for error dectection
	CALL  getc
	MOVWF check_sum
			;        
			;        for(i = 0 ; i < record_length ; i++) //Read the program data
	CLRF  i
m027	MOVF  record_length,W
	SUBWF i,W
	BTFSC 0x03,Carry
	GOTO  m028
			;        {
			;            temp = getc();
	CALL  getc
	MOVWF temp
			;            incoming_buffer[i] = temp;
	MOVLW .39
	ADDWF i,W
	MOVWF FSR
	BCF   0x03,IRP
	MOVF  temp,W
	MOVWF INDF
			;        }
	INCF  i,1
	GOTO  m027
			;        
			;        for(i = 0 ; i < record_length ; i++) //Check sum calculations
m028	CLRF  i
m029	MOVF  record_length,W
	SUBWF i,W
	BTFSC 0x03,Carry
	GOTO  m030
			;            check_sum = check_sum + incoming_buffer[i];
	MOVLW .39
	ADDWF i,W
	MOVWF FSR
	BCF   0x03,IRP
	MOVF  INDF,W
	ADDWF check_sum,1
	INCF  i,1
	GOTO  m029
			;        
			;        check_sum = check_sum + record_length;
m030	MOVF  record_length,W
	ADDWF check_sum,1
			;        check_sum = check_sum + memory_address.high8;
	MOVF  memory_address+1,W
	ADDWF check_sum,1
			;        check_sum = check_sum + memory_address.low8;
	MOVF  memory_address,W
	ADDWF check_sum,1
			;        
			;        if(check_sum == 0) //If we have a good transmission, put it in ink
	BTFSS 0x03,Zero_
	GOTO  m024
			;            onboard_program_write();
	BSF   0x03,RP0
	BSF   0x03,RP1
	CALL  onboard_program_write
			;            
			;    }
	BCF   0x03,RP0
	BCF   0x03,RP1
	GOTO  m024
			;
			;JUMP_VECTOR:
			;
			;    TXEN = 0; //Disable transmission
m031	BSF   0x03,RP0
	BCF   0x98,TXEN
			;    CREN = 0; //Disable receiver
	BCF   0x03,RP0
	BCF   0x18,CREN
			;    
			;    //Now do a hard jump to program location 3
			;    //Where the user's 'goto main' command resides
			;    PCLATH = 0x00;
	CLRF  PCLATH
			;    PCL = 0x03;
	MOVLW .3
	MOVWF PCL
			;}
	RETURN
			;
			;//Write e_data to the onboard eeprom at e_address
			;void onboard_program_write(void)
			;{
onboard_program_write
			;    uns8 i;
			;    
			;    EEPGD = 1; //Point to Program data block
	BSF   0x18C,EEPGD
			;    WREN = 1; //Enable EE Writes
	BSF   0x18C,WREN
			;
			;    EEADRH = memory_address.high8; //Set the address
	BCF   0x03,RP0
	BCF   0x03,RP1
	MOVF  memory_address+1,W
	BSF   0x03,RP1
	MOVWF EEADRH
			;    EEADR = memory_address.low8; //Set the address
	BCF   0x03,RP1
	MOVF  memory_address,W
	BSF   0x03,RP1
	MOVWF EEADR
			;    EEADR = EEADR & 0b.1111.1100; //Make sure address is 0 of four bytes
	MOVLW .252
	ANDWF EEADR,1
			;
			;    for(i = 0 ; i < record_length ; i += 2)
	BCF   0x03,RP1
	CLRF  i_2
m032	MOVF  record_length,W
	SUBWF i_2,W
	BTFSC 0x03,Carry
	GOTO  m033
			;    {
			;        EEDATH = incoming_buffer[i]; //Give it the data
	MOVLW .39
	ADDWF i_2,W
	MOVWF FSR
	BCF   0x03,IRP
	MOVF  INDF,W
	BSF   0x03,RP1
	MOVWF EEDATH
			;        EEDATA = incoming_buffer[i+1]; //Give it the data
	MOVLW .40
	BCF   0x03,RP1
	ADDWF i_2,W
	MOVWF FSR
	BCF   0x03,IRP
	MOVF  INDF,W
	BSF   0x03,RP1
	MOVWF EEDATA
			;
			;        //Specific EEPROM write steps
			;        EECON2 = 0x55;
	MOVLW .85
	BSF   0x03,RP0
	MOVWF EECON2
			;        EECON2 = 0xAA;
	MOVLW .170
	MOVWF EECON2
			;        WR = 1;
	BSF   0x18C,WR
			;        //Specific EEPROM write steps
			;    
			;        //Processor stalls and resumes after second NOP
			;        nop();
	NOP  
			;        nop();
	NOP  
			;        
			;        EEADR++; //Go to next buffer spot
	BCF   0x03,RP0
	INCF  EEADR,1
			;        if (EEADR == 0) EEADRH++;
	MOVF  EEADR,W
	BTFSC 0x03,Zero_
	INCF  EEADRH,1
			;    }
	MOVLW .2
	BCF   0x03,RP1
	ADDWF i_2,1
	GOTO  m032
			;    
			;    WREN = 0; //Disable EEPROM Writes
m033	BSF   0x03,RP0
	BSF   0x03,RP1
	BCF   0x18C,WREN
			;}  
	RETURN
			;
			;//Sends out RS232 characters
			;//Speed is controller by UART setup registers
			;void putc(uns8 nate)
			;{
putc
	MOVWF nate
			;    while(TXIF == 0);
m034	BTFSS 0x0C,TXIF
	GOTO  m034
			;    TXREG = nate;
	MOVF  nate,W
	MOVWF TXREG
			;}
	RETURN
			;
			;//Reads in RS232 characters
			;//Speed is controller by UART setup registers
			;uns8 getc(void)
			;{
getc
			;    //Remember, you cannot clear RCIF, it is cleared
			;    //by reading the RCREG register. In this case
			;    //we read it by returning it.
			;    while(RCIF == 0);
m035	BTFSS 0x0C,RCIF
	GOTO  m035
			;    return(RCREG);
	MOVF  RCREG,W
	RETURN

	ORG 0x0000
	DATA 158AH
	DATA 160AH
	DATA 2F40H
	ORG 0x2007
	DATA 3F32H
	END


; *** KEY INFO ***

; 0x0004 P0   76 word(s)  3 % : main

; 0x1F40 P3  127 word(s)  6 % : bloader
; 0x1FBF P3   55 word(s)  2 % : onboard_program_write
; 0x1FF6 P3    6 word(s)  0 % : putc
; 0x1FFC P3    4 word(s)  0 % : getc

; RAM usage: 26 bytes (7 local), 342 bytes free
; Maximum call level: 2
;  Codepage 0 has   80 word(s) :   3 %
;  Codepage 1 has    0 word(s) :   0 %
;  Codepage 2 has    0 word(s) :   0 %
;  Codepage 3 has  192 word(s) :   9 %
; Total of 272 code words (3 %)
