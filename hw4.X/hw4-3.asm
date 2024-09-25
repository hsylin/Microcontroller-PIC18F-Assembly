#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x10 
		
Initial:
        MOVLW 0x08
	MOVWF 0x10
	MOVFF 0x10 , WREG
	
	LFSR 0,0x10
	MOVFF 0x10 , INDF0
	LFSR 1,0x11
	TSTFSZ 0x10
	rcall Hanoitower
	rcall fin
	
	
  Hanoitower:
    MOVLW 0x01
    CPFSEQ INDF0
    GOTO i
    GOTO ii
   i:
    DECF INDF0
    CPFSEQ INDF0
    MOVFF POSTINC0 ,POSTINC1
    rcall Hanoitower
   ii:
    finish:
    RLNCF INDF1
    INCF INDF1
    MOVFF POSTDEC1 ,POSTDEC0
    RETURN  
   fin:
    MOVFF POSTDEC1 ,0x00
    NOP
 end


