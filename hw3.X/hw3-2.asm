#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x10 
Initial:	   
BCF STATUS, OV      
MOVLW 0x008
MOVWF 0x005
MOVLW 0x17
MOVWF 0x000;Q 
MOVLW 0x000
MOVWF 0x001;A 
MOVLW 0x006
MOVWF 0x002;M

;Restoring Division Algorithm
for: 
    ;shift left AQ
    RLCF 0x001
    BCF 0x001,0
    BTFSC 0x000,7
    INCF 0x001
    RLCF  0x000
    BCF 0x000,0
    ;A=A-M
    MOVFF 0x002,WREG
    SUBWF 0x001,0
    MOVWF 0x001
    
    BN i
    BSF 0x000,0
    BNOV ii
    ;A is negative
   i:
    BCF 0x000,0
    MOVFF 0x002,WREG
    ADDWF 0x001,0
    MOVWF 0x001
    ;A is postive
    ii:
    DECFSZ 0x005
    BNOV for
end


