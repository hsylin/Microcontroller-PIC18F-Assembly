#include <xc.h>
#include <pic18f4520.h>

#pragma config OSC = INTIO67 // Oscillator Selection bits
#pragma config WDT = OFF     // Watchdog Timer Enable bit 
#pragma config PWRT = OFF    // Power-up Enable bit
#pragma config BOREN = ON   // Brown-out Reset Enable bit
#pragma config PBADEN = OFF     // Watchdog Timer Enable bit 
#pragma config LVP = OFF     // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF     // Data EEPROM??Memory Code Protection bit (Data EEPROM code protection off)

void __interrupt() Rotate(void)             // High priority interrupt
{


    CCPR1L = 0x04;
    CCP1CONbits.DC1B = 0b00;
    
    for(int i = 0; i < 20; i++){
        for(int j = 0; j < 3; j++){
            CCP1CONbits.DC1B++;
            for(int k = 0; k < 20; k++);
        }
        CCPR1L++;
        CCP1CONbits.DC1B = 0b00;
    }        
  
        CCPR1L = 0x04;
        CCP1CONbits.DC1B = 0b00;
    
    
    
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