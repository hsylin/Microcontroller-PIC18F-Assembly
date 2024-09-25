LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67 ; 1 MHZ
	CONFIG WDT = OFF
	CONFIG LVP = OFF
	
	L1	EQU 0x14
	L2	EQU 0x15
	org 0x00
	
; Total 2 + (2 + 7 * num1 + 2) * num2 cycles = C
; num1 = 200, num2 = 180, C = 252360
; Total delay ~= C/1M = 0.25s
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
     BSF LATA, 0
     INCF 0x03
      DELAY d'283', d'255'
      GOTO check_process
      
   open2:
       MOVLW 0x01
   CPFSEQ 0x03
   GOTO open3
      BSF LATA, 1
      INCF 0x03
      DELAY d'283', d'255'
      GOTO check_process
      
    open3:
    MOVLW 0x02
   CPFSEQ 0x03
   GOTO open4
     BSF LATA, 2
      INCF 0x03
      DELAY d'283', d'255'
      GOTO check_process
      
      open4:
        MOVLW 0x03
   CPFSEQ 0x03
   GOTO closeall
     BSF LATA, 3
      INCF 0x03
      DELAY d'283', d'255'
      GOTO check_process
      
   closeall:
    CLRF LATA
    CLRF 0x03
    DELAY d'283', d'255'
     GOTO check_process
end


