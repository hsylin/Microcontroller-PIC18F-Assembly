#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x10 
	
 DIST macro x1, y1, x2, y2, F1 ,F2
 MOVLW  x1
 MOVWF 0x10
 MOVLW  y1
 MOVWF 0x11
 MOVLW  x2
 MOVWF 0x12
 MOVLW y2
 MOVWF 0x13
 
 MOVFF 0x12,WREG
 SUBWF 0x10,0
 MULWF WREG
 MOVFF PRODH ,F1
 MOVFF PRODL ,F2
 
 MOVFF 0x13,WREG
 SUBWF 0x11,0
 MULWF WREG
 MOVFF PRODL ,WREG
 
 ADDWF F2 , 1
 BC carry
 GOTO nocarry
 carry:
    INCF F1
 nocarry:
    MOVFF PRODH ,WREG 
    ADDWF F1 , 1
 endm
 		
Initial:	 
  DIST 0x05,0x07,0x02,0x03,0x00,0x01  
 end



