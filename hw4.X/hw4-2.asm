#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x10 
		
Initial:
    MOVLW 0x01
    MOVWF 0x00
    MOVLW 0x03
    MOVWF 0x01
    MOVLW 0x03
    MOVWF 0x03
    rcall s
    rcall finish
    
    
    s:
    MOVFF 0x00,WREG
    ADDWF 0X02,1
    MULWF 0X01
    MOVFF PRODL ,0X00
    MOVLW s
    DECFSZ 0x03
    MOVWF PCL 
    RETURN
    
    
 finish:
 NOP
 end


