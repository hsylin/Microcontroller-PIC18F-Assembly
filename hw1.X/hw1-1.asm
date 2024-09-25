LIST p=18f4520

    #include<p18f4520.inc>

	CONFIG OSC = INTIO67

	CONFIG WDT = OFF

	org 0x00

	

initial:
    CLRF  WREG
    MOVLW 0x01
    MOVWF 0x002
    MOVLW 0x7C
    MOVWF 0x000
    MOVLW 0x04
    MOVWF 0x001
    COMF   0x000
    INCF    0x000
    CPFSEQ 0x000
    GOTO ii
   MOVLW 0xFF
   MOVWF 0x002   
 ii:   
end


