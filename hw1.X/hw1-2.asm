LIST p=18f4520

    #include<p18f4520.inc>

	CONFIG OSC = INTIO67

	CONFIG WDT = OFF

	org 0x00
initial:
    CLRF 0x002
    MOVLW 0x08
    MOVWF 0x00
    MOVLW  b'00010111'
    MOVWF 0x10
start:
    
    MOVLW 0x01
    ANDWF 0x10,0
     RRNCF 0x10
    ADDWF 0x002,1
    DECFSZ 0x00
    GOTO start
 
end


