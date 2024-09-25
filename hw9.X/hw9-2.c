#include <xc.h>
#include <pic18f4520.h>

#pragma config OSC = INTIO67 // Oscillator Selection bits
#pragma config WDT = OFF     // Watchdog Timer Enable bit 
#pragma config PWRT = OFF    // Power-up Enable bit
#pragma config BOREN = ON   // Brown-out Reset Enable bit
#pragma config PBADEN = OFF     // Watchdog Timer Enable bit 
#pragma config LVP = OFF     // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF 

void __interrupt(high_priority) Hi_ISR(void){    

    int a= ADRESH * 256 + ADRESL;
    int arr[10]={3,1,4,1,5,9,2,6,5,3};
    if(a<102)
    {
         LATD = arr[0]; 
    }
    else if(a<204)
    {
        LATD = arr[1]; 
    
    }
    else if(a<306)
    {
         LATD = arr[2];
    }
    else if(a<408)
    {
         LATD = arr[3];
    }
    else if(a<510)
    {
         LATD = arr[4];
    }
    else if(a<612)
    {
         LATD = arr[5];
    }
    else if(a<714)
    {
         LATD = arr[6];
    }
    else if(a<816)
    {
         LATD = arr[7];
    }
    else if(a<918)
    {
         LATD = arr[8];
    }
    else 
    {
         LATD = arr[9];
    }
    PIR1bits.ADIF = 0;
    ADCON0bits.GODONE = 1;
    return;
}

void main(void) {
    
    RCONbits.IPEN = 1;
    INTCONbits.GIE = 1;
    
    //for input
    TRISAbits.RA0 = 1;
    
    // for output
    TRISDbits.RD0 = 0;
    TRISDbits.RD1 = 0;
    TRISDbits.RD2 = 0;
    TRISDbits.RD3 = 0;
    
    // 8M hz
    OSCCONbits.IRCF2 = 1;
    OSCCONbits.IRCF1 = 1;
    OSCCONbits.IRCF0 = 0;
    
    ADCON0bits.ADON = 1; //for ADON AN0
    ADCON0bits.CHS = 0b0000;
    ADCON1bits.PCFG = 0b1110; // A for AN0
    ADCON1bits.VCFG = 0b00;
    ADCON2bits.ADFM = 1;
    ADCON2bits.ACQT = 0b010;
    ADCON2bits.ADCS = 0b001;
    // right , 4tad , fosc/8
    
    PIR1bits.ADIF = 0;
    PIE1bits.ADIE = 1;
    IPR1bits.ADIP = 1;
    
    ADCON0bits.GO = 1;
    
    while(1);
    
    return;
}