/*
    1-4-04
    Copyright Spark Fun Electronics© 2004
    
    Boot loader for the 16F88
    
    See updates.txt for version updates
*/
//Where the restricted area starts
#define BLOADER_START 0x0F00
#define BLOADER_START_HIGH 0x0F
#define BLOADER_START_LOW 0x00

#include "d:\Pics\c\16F88.H"  //Device definitions

//#pragma config |= 0x3F22 //HS Oscillator, No WDT, MCLR Enabled
#pragma config |= 0x3F30 //Internal Oscillator, No WDT, MCLR Enabled

//These set the first three code words of the program
//Jump to bloader on reset or power on
#pragma cdata[0] = /*BSF*/0x1400 + /*PCLATH*/10 + (/*bit*/3 << 7)
#pragma cdata[1] = /*BSF*/0x1400 + /*PCLATH*/10 + (/*bit*/4 << 7)
#pragma cdata[2] = /*GOTO*/0x2800 + (BLOADER_START & 0x7FF)

#pragma resetVector 3

void bloader(void);
void onboard_program_write(void);
void putc(uns8 nate);
uns8 getc(void);

void main()
{
    //Setup the ports
    //=============================================================
    PORTA = 0b.0000.0000;
    TRISA = 0b.0000.0000;  //0 = Output, 1 = Input
    PORTB = 0b.0000.0000;
    TRISB = 0b.0000.0000;  //0 = Output, 1 = Input
    //=============================================================

    TXEN = 1; //Enable transmission

    uns8 x, y, z;
    
    //Standard blinky program @ 20MHz
    while(1)
    {
        PORTA = 0xFF;
        PORTB = 0xFF;
        for(x = 0 ; x < 5 ; x++)
            for(y = 0 ; y < 255 ; y++)
                for (z = 0 ; z < 255 ; z++);

        PORTA = 0x00;
        PORTB = 0x00;
        for(x = 0 ; x < 5 ; x++)
            for(y = 0 ; y < 255 ; y++)
                for (z = 0 ; z < 255 ; z++);
                
        putc('O');
        putc('k');
    }
    
    while(1);
    
    //This is just here so that we can see the memory address to jump to 
    //under ICProg. It never gets executed and will get written over upon 
    //new program loading.
    //It also forces the compiler to correctly allocate variable space needed
    //for the bloader
    bloader();

}//End Main
  
#pragma origin BLOADER_START

//Here are the global variables for the boot loader.
//These are destroyed once the user's program starts.
uns8 incoming_buffer[16]; //Presume no record will be longer than 16 bytes
uns16 memory_address;
uns8 record_length;

void onboard_program_erase(uns16 program_address);
void onboard_program_write(void);
void putc(uns8 nate);
uns8 getc(void);

//The PIC sends ASC(5)-enquiry out and waits for return ASC(6)-ack from computer.
//If ACK is seen, PIC goes into load mode, otherwise, returns to main 
//The PIC will transmit a 'T' and wait for a ':' to start listening
void bloader(void)
{
    uns8 i, temp;
    uns8 check_sum = 0;

    OSCCON = 0b.0111.0000; //Setup internal oscillator for 8MHz
    //OSCCON = 0b.0110.0000; //Setup internal oscillator for 4MHz
    while(OSCCON.2 == 0); //Wait for frequency to stabilize

    //Sets up the various I/O ports and UART for serial comm
    //=============================================================
    PORTB = 0b.0000.0000;
    TRISB = 0b.0000.0100;  //0 = Output, 1 = Input RB2 - Incoming Data RX

    //Setup the hardware UART module
    //SPBRG = 129; //20MHz for 9600 inital communication baud rate
    SPBRG = 51; //8MHz for 9600 inital communication baud rate
    //SPBRG = 25; //4MHz for 9600 inital communication baud rate
    TXSTA = 0b.0010.0100; //8-bit asych mode, high speed uart enabled
    RCSTA = 0b.1001.0000; //Serial port enable, 8-bit asych continous receive mode
    //=============================================================

    for(i = 0 ; i < 255 ; i++);
        //for(temp = 0 ; temp < 255 ; temp++);

    putc(5); //PIC tells the world it can be loaded, by broadcasting an Enquiry

    TMR1H = 0; TMR1L = 0; TMR1ON = 1; //Setup and turn on hardware timer1

    while(RCIF == 0) //Check to see if the computer responded
        if (TMR1IF) break; //If timer1 rolls over, go to normal boot up
    TMR1ON = 0; //Turn off timer1

    if (RCREG != 6) goto JUMP_VECTOR; //If the computer did not respond correctly with a ACK, we go into normal boot up mode

    while(RCIF == 0); //Wait for computer to transmit UART speed
    SPBRG = RCREG; //Setup the hardware UART module
    
    //Short delay while computer re-adjusts the port speed under VB
    //for(i = 0 ; i < 255 ; i++)
    //    for(temp = 0 ; temp < 255 ; temp++);

    //Erase memory block -> 0 to the start of the boot loader
    for(memory_address = 0x0000 ; memory_address < (BLOADER_START - 32) ; memory_address += 32)
        onboard_program_erase(memory_address);
        
    //Write boot load vector - Added 5-18-04
    //=====================================================
    //The boot vector has been erased, so write it back!
    incoming_buffer[0] = 0x15; // - This sets the far jump
    incoming_buffer[1] = 0x8A;

    incoming_buffer[2] = 0x16; // - More far jump
    incoming_buffer[3] = 0x0A;

    incoming_buffer[4] = 0x2F; // - This is the actual jump
    incoming_buffer[5] = BLOADER_START_LOW; //Declared at top of this program

    //PIC Program memory is flash based. So set the actual jump vector to all 1s. That way when 
    //the actualy boot vector gets written, it gets 'anded' with 0x1111.1111 and gets saved!
    incoming_buffer[6] = 0x3F;
    incoming_buffer[7] = 0xFF; 

    memory_address = 0;
    record_length = 8;
    onboard_program_write();
    //=====================================================

    //Send out the starting memory location of the Bloader
    putc(BLOADER_START_HIGH); //This will tell the computer how to remap the boot vector
    putc(BLOADER_START_LOW); //This will avoid writing into restricted bloader code space

    while(1)
    {
        //Determine if the last received data was good or bad
        if (check_sum != 0) //If the check sum does not compute, tell computer to resend same line
            putc(7); //Ascii character BELL
        else            
            putc('T'); //Tell the computer that we are ready for the next line
        
        while(getc() != ':'); //Wait for the computer to initiate transfer

        record_length = getc(); //Get the length of this block

        if (record_length == 'S') goto JUMP_VECTOR; //Check to see if we are done - new boot vector

        memory_address.high8 = getc(); //Get the memory address at which to store this block of data
        memory_address.low8 = getc();
        
        check_sum = getc(); //Pick up the check sum for error dectection
        
        for(i = 0 ; i < record_length ; i++) //Read the program data
        {
            temp = getc();
            incoming_buffer[i] = temp;
        }
        
        for(i = 0 ; i < record_length ; i++) //Check sum calculations
            check_sum = check_sum + incoming_buffer[i];
        
        check_sum = check_sum + record_length;
        check_sum = check_sum + memory_address.high8;
        check_sum = check_sum + memory_address.low8;
        
        if(check_sum == 0) //If we have a good transmission, put it in ink
            onboard_program_write();
            
    }

JUMP_VECTOR:

    TXEN = 0; //Disable transmission
    CREN = 0; //Disable receiver
    
    //Now do a hard jump to program location 3
    //Where the user's 'goto main' command resides
    PCLATH = 0x00;
    PCL = 0x03;
}


//Erase one block of program memory
void onboard_program_erase(uns16 program_address)
{
    EEADRH = program_address.high8; //Set the address
    EEADR = program_address.low8; //Set the address

    EEPGD = 1; //Point to Program data block
    WREN = 1; //Enable EE Writes
    FREE = 1; //Allow program memory changes
    
    //Specific Program Erase/EEPROM write steps
    EECON2 = 0x55;
    EECON2 = 0xAA;
    WR = 1;

    //Processor stalls and resumes after second NOP
    nop();
    nop();

    WREN = 0;
} 

//Write e_data to the onboard eeprom at e_address
void onboard_program_write(void)
{
    uns8 i;
    
    FREE = 0;
    EEPGD = 1; //Point to Program data block
    WREN = 1; //Enable EE Writes

    EEADRH = memory_address.high8; //Set the address
    EEADR = memory_address.low8; //Set the address
    //EEADR = EEADR & 0b.1111.1100; //Make sure address is 0 of four bytes

    for(i = 0 ; i < record_length ; i += 2)
    {
        EEDATH = incoming_buffer[i]; //Give it the data
        EEDATA = incoming_buffer[i+1]; //Give it the data

        //Specific EEPROM write steps
        EECON2 = 0x55;
        EECON2 = 0xAA;
        WR = 1;
        //Specific EEPROM write steps
    
        //Processor stalls and resumes after second NOP
        nop();
        nop();
        
        EEADR++; //Go to next buffer spot
        if (EEADR == 0) EEADRH++;
    }
    
    WREN = 0; //Disable EEPROM Writes
}  

//Sends out RS232 characters
//Speed is controller by UART setup registers
void putc(uns8 nate)
{
    while(TXIF == 0);
    TXREG = nate;
}

//Reads in RS232 characters
//Speed is controller by UART setup registers
uns8 getc(void)
{
    while(RCIF == 0);
    return(RCREG);
}


