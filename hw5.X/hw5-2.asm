#include "xc.inc"
GLOBAL _divide_signed
    
PSECT mytext, local, class=CODE, reloc=2
 
_divide_signed:	

MOVFF 0x01 , 0x03
MOVWF 0x01
BTFSC 0x01,7
GOTO i
GOTO input2   
i:
 INCF 0x30    
 COMF 0x01
 INCF 0x01
 
 
input2:
BTFSC 0x03,7
GOTO ii
GOTO for       
 ii:   
INCF 0x31 
COMF 0x03
INCF 0x03
    

    
for:
 MOVFF 0x03,WREG  
 SUBWF 0x01,1
 BNC negative
 INCF 0x20
GOTO for 
 
negative: 

 ADDWF 0x01,0
 MOVWF 0x21
    
 
MOVFF 0x30,WREG  
XORWF 0x31,0
TSTFSZ WREG  
GOTO  complent
GOTO remainder
complent:
    COMF 0X20
    INCF 0X20
    
remainder:
    
TSTFSZ 0x30  
GOTO  complent2
GOTO finish
complent2:
    COMF 0X21
    INCF 0X21    
 finish:
    MOVFF 0x21,0x01
    MOVFF 0x20,0x02
    NOP
  RETURN


