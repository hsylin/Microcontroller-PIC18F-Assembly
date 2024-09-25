
#include <xc.h>
#include <pic18f4520.h>

#pragma config OSC = INTIO67 // Oscillator Selection bits
#pragma config WDT = OFF     // Watchdog Timer Enable bit 
#pragma config PWRT = OFF    // Power-up Enable bit
#pragma config BOREN = ON   // Brown-out Reset Enable bit
#pragma config PBADEN = OFF     // Watchdog Timer Enable bit 
#pragma config LVP = OFF     // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF     // Data EEPROM??Memory Code Protection bit (Data EEPROM code protection off)
int num=0;
void __interrupt() Rotate(void)             // High priority interrupt
{
	
	 if(num==0)//0
	{	
		 CCPR1L =  0x0b;
    		CCP1CONbits.DC1B = 0b01;
		num++;
	 } 
	 else	if(num==1)//90
	{	
		 CCPR1L = 0x12;
    		CCP1CONbits.DC1B = 0b11;
		num++;
	 } 
  
	else 	 if(num==2)//0
	{	
		 CCPR1L =  0x0b;
    		CCP1CONbits.DC1B = 0b01;
		num++;
	 } 
	 
else	if(num==3)//-90
	{	
		 CCPR1L = 0x04;
    		CCP1CONbits.DC1B = 0b00;
		num=0;
	 } 	
	  	 INTCONbits.INT0IF = 0;
}

void main(void) {
    T2CON = 0b01111101;
    OSCCONbits.IRCF = 0b001;
    CCP1CONbits.CCP1M = 0b1100;
    TRISC = 0;
    LATC = 0;
    PR2 = 0x9b;
    
    RCONbits.IPEN = 1;
    INTCON = 0b11010000;
    INTCON2 = 0b01110001;
    
    CCPR1L = 0x04;
    CCP1CONbits.DC1B = 0b00;
    
    while(1);

}
