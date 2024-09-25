#include "setting_hardaware/setting.h"
#include <stdlib.h>
#include "stdio.h"
#include "string.h"

// using namespace std;

char str[20];
int count=0;
void Mode1(){   // Todo : Mode1 
    while(1)
    {
        strcpy(str,GetString());
        if(str[0] == 'e'){
            
           
            LATA= 0;
             ClearBuffer();
		count=0;
            break;
        }
        for(int i=0;i<250;i++)
            for(int j=0;j<255;j++);
        if(count==0)
        {
            TRISA=0;
            LATA= 5;
            count=1;
        }
        else if(count==1)
        {
            TRISA=0;
            LATA= 10;
            count=0;
        }
        
        
    }
    
    return ;
}
void Mode2(){   // Todo : Mode2 
    while(1)
    {
        strcpy(str,GetString());
        if(str[0] == 'e'){
            
            LATA= 0;
            ClearBuffer();
		count=0;
            break;
        }
        for(int i=0;i<250;i++)
            for(int j=0;j<255;j++);
        if(count==0)
        {
            TRISA=0;
            LATA= 8;
            count=1;
        }
        else if(count==1)
        {
            TRISA=0;
            LATA= 4;
            count=2;
        }
        else if(count==2)
        {
            TRISA=0;
            LATA= 2;
            count=3;
        }
        else if(count==3)
        {
            TRISA=0;
            LATA= 1;
            count=0;
        }
        
    }
    
    return ;
}
void main(void) 
{
    
    SYSTEM_Initialize() ;
   while(1) {
        // TODO 
        strcpy(str,GetString());
        if(str[0] == 'm' && str[1] == '1' )
        {
            Mode1();
            
        }
        else if(str[0] == 'm' && str[1] == '2' )
        {
            Mode2();
            
        }
    }
   
    return;
}



uart

#include <xc.h>
    //setting TX/RX

char mystring[20];
int lenStr = 0;
int ans = 0;
void UART_Initialize() {
           
    /*       TODObasic   
           Serial Setting      
        1.   Setting Baud rate
        2.   choose sync/async mode 
        3.   enable Serial port (configures RX/DT and TX/CK pins as serial port pins)
        3.5  enable Tx, Rx Interrupt(optional)
        4.   Enable Tx & RX*/
           
    TRISCbits.TRISC6 = 1;            
    TRISCbits.TRISC7 = 1;            
    
    //  Setting baud rate
    TXSTAbits.SYNC = 0;           
    BAUDCONbits.BRG16 = 0;          
    TXSTAbits.BRGH = 0;
    SPBRG = 51;      
    
   //   Serial enable
    RCSTAbits.SPEN = 1;              
    PIR1bits.TXIF = 1;
    PIR1bits.RCIF = 0;
    TXSTAbits.TXEN = 1;           
    RCSTAbits.CREN = 1;             
    PIE1bits.TXIE = 0;       
    IPR1bits.TXIP = 0;             
    PIE1bits.RCIE = 1;              
    IPR1bits.RCIP = 0;    
              
    }

void UART_Write(unsigned char data)  // Output on Terminal
{
    while(!TXSTAbits.TRMT);
    TXREG = data;              //write to TXREG will send data 
}


void UART_Write_Text(char* text) { // Output on Terminal, limit:10 chars
    for(int i=0;text[i]!='\0';i++)
        UART_Write(text[i]);
}

void ClearBuffer(){
    for(int i = 0; i < 10 ; i++)
        mystring[i] = '\0';
    for(int i = 0; i < lenStr ; i++)
        UART_Write('\b');
    lenStr = 0;
}

void MyusartRead()
{
     
    mystring[lenStr] = RCREG;
   
    if (mystring[lenStr] == '\r')
    {
    for(int i = 0; i < lenStr ; i++)
        UART_Write('\b');
    UART_Write('\n');
    
    lenStr = 0;
    
    }
    else
    {
    UART_Write(mystring[lenStr]);
    lenStr++;
    lenStr %= 10;
    }
    
    return ;
}

char *GetString(){
    return mystring;
}


// void interrupt low_priority Lo_ISR(void)
void __interrupt(low_priority)  Lo_ISR(void)
{
    if(RCIF)
    {
        MyusartRead();
    }
    
   // process other interrupt sources here, if required
    return;
}