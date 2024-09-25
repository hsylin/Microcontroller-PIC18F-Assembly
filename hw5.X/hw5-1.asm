#include "xc.inc"
GLOBAL _isprime
    
PSECT mytext, local, class=CODE, reloc=2

_isprime:
    
MOVLW 0x01
MOVWF 0x03	
MOVFF 0x01,0x05
    
MOVLW 0x02
CPFSEQ 0x01
GOTO fun
MOVLW 0x01
MOVFF WREG,0x01
RETURN    

fun:
MOVFF 0x05,0x01
INCF 0X03
    
    
for:
 MOVFF 0x03,WREG  
 SUBWF 0x01,1
 BNC negative
 INCF 0x20
GOTO for 
 
negative: 

 ADDWF 0x01,0
 MOVWF 0x21
 
 finish:
    TSTFSZ   0x21
    GOTO pirme
    GOTO notprime
    pirme:
	MOVLW 0x01
	MOVFF WREG,0x01
	MOVFF 0x05,WREG
	DECF WREG
	CPFSEQ 0x03
	GOTO fun
	GOTO enddd
    notprime:
    MOVLW 0xFF
    MOVFF WREG,0x01
    
    enddd:
    RETURN


