#include "p18f4520.inc"

CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
  CONFIG  LVP = OFF

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


nop
goto initial
  
ISR:
  org 0x08
  INCF 0x03
  MOVLW 0x03
  CPFSEQ 0x03
  GOTO i
  CLRF 0x03
  i:
    btg 0x00,0
    bcf INTCON,INT0IF ; (must be cleared in software) 
    retfie
    
initial:
    clrf 0x03
    bsf TRISB,0
    clrf 0x000
    bsf 0x000,0
    clrf TRISA
    clrf LATA
    clrf WREG
    movlw B'00000000'
    movwf TRISA
    movlw B'00000001'
    movwf LATA   
    
    
    bcf RCON,IPEN
    movlw B'11010000'
    movwf INTCON
    movlw B'01110001'
    movwf INTCON2 
  DELAY D'200',D'45'
  DELAY D'200',D'45'
  DELAY D'200',D'45'
  DELAY D'200',D'45'
    
main:
    btfss 0x000,0
    goto opposite
    rlncf LATA
    btfss LATA,4
    goto conti
    rlncf LATA
    rlncf LATA
    rlncf LATA
    rlncf LATA
    goto conti
opposite:
    rrncf LATA
    btfss LATA,7
    goto conti
    rrncf LATA
    rrncf LATA
    rrncf LATA
    rrncf LATA
    
conti:
   open1:
   MOVLW 0x00
   CPFSEQ 0x03
   GOTO open2
   DELAY D'200',D'45'
  DELAY D'200',D'45'
  DELAY D'200',D'45'
  DELAY D'200',D'45'
    goto main    
      
   open2:
       MOVLW 0x01
   CPFSEQ 0x03
   GOTO open3
DELAY D'200',D'45'
DELAY D'200',D'45'
    goto main    
      
    open3:
DELAY D'200',D'45'
goto main
    
end


