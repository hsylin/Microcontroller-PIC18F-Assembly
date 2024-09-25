#INCLUDE <p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF 
	org 0x10 


MOVLW 0xF5;A
MOVWF 0x10	
MOVLW 0x5A;B
MOVWF 0x11	
	
;AB??
MULWF 0x10,0
MOVFF PRODH , 0x30
MOVFF PRODL , 0x31
	
MOVLW 0x80	
CPFSLT 0x10
INCF 0x13		
	
MOVLW 0x80	
CPFSLT 0x11
INCF 0x13

MOVFF 0x10 , WREG
CPFSGT 0x11
GOTO switch
MOVFF 0x10 , 0x15
MOVFF 0x11 , 0x10
MOVFF 0x15 , 0x11   

switch:
    MOVLW 0x00
    CPFSEQ 0x13
    GOTO ii
    GOTO loop
    
    
    ii:
    MOVLW 0x01
    CPFSEQ 0x13
    GOTO iii
    BCF 0x10,7
    GOTO loop


    
    iii:
    MOVFF 0x11 , WREG
    SUBWF 0x10 , 1
    MOVFF 0x10 , 0x15
    MOVFF 0x11 , 0x10
    MOVFF 0x15 , 0x11   
    DECF 0x13
    BCF 0x10,7
    GOTO loop	
	

BCF 0x10,7
;A,B?????
; while( b!=0 )
 ;{
    ;t = b;
     ; b = a%b;
     ;a = t;
    ;}
	
loop:
    MOVFF 0x11 , 0x12;Temp=B
    
    loop2:
    MOVFF 0x11 , WREG
    SUBWF 0x10 , 1;A=A-B??A
    BN negative0x10
    GOTO loop2
    
 negative0x10: 
    TSTFSZ 0x13
    GOTO one13
    GOTO zero13
one13:
    DECF 0x13
    BCF 0x10,7
    GOTO loop2
zero13:   
    ADDWF 0x10 , 0
    MOVWF 0x11
    MOVFF 0x12 , 0x10;A=Temp
    TSTFSZ 0x11
    GOTO loop

    
    ;0x31=[0x14]*128+0x31
    MOVLW 0x80	
    CPFSLT 0x31
    INCF 0x14
    BCF 0x31,7  
    ;0x10=[0x13]*128+0x10
    CPFSLT 0x10
    INCF 0x13
    BCF 0x10,7  
    
  for:
    MOVFF 0x10 ,WREG
    SUBWF 0x31 , 1
    BNN positive0x31
    
    TSTFSZ 0x14
    GOTO one14
    GOTO zero14 
    zero14:
    DECF 0x30
    INCF 0x14
    BCF 0x31,7
    GOTO positive0x31
    one14:
    DECF 0x14
     BCF 0x31,7
  positive0x31:
    MOVLW 0xFF
    CPFSLT  0x01
    INCF 0x00
    INCF 0x01
    
    MOVLW 0x001
    CPFSEQ 0x13
    GOTO finish
    GOTO next
    
    next:
    INCF 0x16
    MOVLW 0x02
    CPFSEQ 0x16
    GOTO finish
    GOTO neg0x30
   
    neg0x30:
    DECF 0x30
    CLRF 0x16
    
    finish:
    TSTFSZ 0x30
    GOTO for
    TSTFSZ 0x31
    GOTO for
    TSTFSZ 0x14
    GOTO for
    nop 
end


