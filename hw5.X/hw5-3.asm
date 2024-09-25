#include "xc.inc"
GLOBAL _mypow
    
PSECT mytext, local, class=CODE, reloc=2

_mypow:	


    
    
 TSTFSZ 0x03
 GOTO bnotzero
 GOTO bzero
 
 bzero:
   MOVLW 0x00
    MOVWF 0x01
   MOVLW 0x01
   MOVWF 0x02
  GOTO fin2
    
    
 
bnotzero:   

 
MOVFF 0x01,0x40
DECF 0x40  ;a-1
MOVFF 0x03,0x41
 DECF 0x41 ;b-1  
 MOVFF 0x01,0x06
 MOVFF 0x01,0x16
 
 MOVLW 0x02
MOVWF 0x07 ;16bit counter
 
 
plus:
     LFSR 0, 0x06
    LFSR 1, 0x16
    LFSR 2, 0x26  

for:

    
    ;wreg=fsr0+fsr1
    MOVFF POSTDEC0 ,WREG
    ADDWF POSTDEC1 , 0
     CLRF INDF2
    BNC finish
    
    INCF INDF0
    
    finish:
    MOVWF POSTDEC2
    DECFSZ 0x07
    GOTO for
    
    MOVFF 0x25 , 0x05
    MOVFF 0x26 , 0x06
    
 
    
    MOVLW 0x02
    MOVWF 0x07   

    
DECF 0x40   
TSTFSZ  0x40
GOTO  plus
GOTO change
change:
    MOVFF 0x25,0x15
    MOVFF 0x26,0x16
    MOVFF 0x01,0x40
    DECF 0x40 
    DECF 0x41
    TSTFSZ 0x41
    GOTO plus
    GOTO fin
    
    fin:
    MOVFF 0x25,0x02
    MOVFF 0x26,0x01
    
    fin2:
    
RETURN


