LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67 ; 1 MHZ
	CONFIG WDT = OFF
	CONFIG LVP = OFF
	
	L1	EQU 0x14
	L2	EQU 0x15
	org 0x00
DELAY macro num1, num2 
    local LOOP1 
    local LOOP2
    MOVLW num2
    MOVWF L2
    LOOP2:
	MOVLW num1
	MOVWF L1
    LOOP1:
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	DECFSZ L1, 1
	BRA LOOP1
	DECFSZ L2, 1
	BRA LOOP2
endm
start:
int:
; let pin can receive digital signal 
MOVLW 0x0f
MOVWF ADCON1   
CLRF PORTB
BSF TRISB, 0;input
CLRF LATA
BCF TRISA, 0;output
BCF TRISA, 1;output
BCF TRISA, 2;output  
BCF TRISA, 3;output   

 CLRF 0x03   
    
check_process:
   BTFSC PORTB, 0
   GOTO check_process
   open1:
   MOVLW 0x00
   CPFSEQ 0x03
   GOTO open2
     BTG LATA, 0
     DELAY d'80', d'100'
     INCF 0x03
      GOTO check_process
      
   open2:
       MOVLW 0x01
   CPFSEQ 0x03
   GOTO open3
     BTG LATA, 1
     DELAY d'80', d'100'
      INCF 0x03
      GOTO check_process
      
    open3:
    MOVLW 0x02
   CPFSEQ 0x03
   GOTO open4
     BTG LATA, 2
     DELAY d'80', d'100'
      INCF 0x03
      GOTO check_process
      
      open4:
        MOVLW 0x03
   CPFSEQ 0x03
   GOTO closeall
     BTG LATA, 3
     DELAY d'80', d'100'
      INCF 0x03
      GOTO check_process
      
   closeall:
    CLRF LATA
end


