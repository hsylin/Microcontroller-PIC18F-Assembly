#include "p18f4520.inc"
; CONFIG1H
  CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3             ; Brown Out Reset Voltage bits (Minimum setting)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)


	ORG	0x000			
	GOTO	INICIO
INICIO:
	; Internal Oscillator Frequency: 8 MHz	
	BSF	OSCCON,IRCF2		
	BSF	OSCCON,IRCF1			
	BSF	OSCCON,IRCF0
	;PLL enabled for INTOSC 
	BSF	OSCTUNE,PLLEN 
	
	;A/D Port Configuration Control bits:1111 
	MOVLW 0x0F
	MOVWF ADCON1
	
	; configure  all bits of PORTA as an input bit
	SETF	TRISA	
	; configure  all bits of PORTB PORTC as an output bit
	CLRF	TRISB			
	CLRF	TRISC	
	
	CLRF	PORTA			
	CLRF	PORTB			
	CLRF	PORTC			
	
	#DEFINE	MOV_CW_X    PORTA,0
	#DEFINE	MOV_CCW_X   PORTA,1
	#DEFINE STEP_X	    LATC,5
	#DEFINE DIR_X	    LATC,4
	#DEFINE	ENABLE_X    LATC,6
	
	
	

PRINCIPAL_X:
	;check if press the botton connected to PORTA,0
	BTFSS	MOV_CW_X 
	GOTO	DIR_CW_X
	;check if press the botton connected to PORTA,1
	BTFSS	MOV_CCW_X
	GOTO	DIR_CCW_X
	;resume initial configuration
	BSF	ENABLE_X
	GOTO	PRINCIPAL_X	
	
DIR_CW_X:	
        ; a4988 enable bit=0
	BCF	ENABLE_X	
	;a4988 dir bit=0 (clockwise)
	BCF	DIR_X
	;drive stepper motor
	BSF	STEP_X
	CALL	RET_500us
	BCF	STEP_X
	CALL	RET_500us
	;resume initial configuration
	BCF    MOV_CW_X

	GOTO	PRINCIPAL_X
DIR_CCW_X:
     ; a4988 enable bit=0
	BCF	ENABLE_X	
	;a4988 dir bit=1 (counterclockwise)
	BSF	DIR_X
	;drive stepper motor
	BSF	STEP_X
	CALL	RET_500us
	BCF	STEP_X
	CALL	RET_500us
	;resume initial configuration
	BCF    MOV_CCW_X
	GOTO	PRINCIPAL_X	




RET_SERVO:
	; timer0 16 bits, Prescale value1:16
	MOVLW	B'00000011'		
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XFF
	MOVWF	TMR0H
	MOVLW	0XFA
	MOVWF	TMR0L
	;staet timer
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO		

RET_1s:
    ; timer0 16 bits, Prescale value1:256
	MOVLW	B'00000111'		
	MOVWF	T0CON			
	BCF	INTCON,TMR0IF
	MOVLW	0X0B
	MOVWF	TMR0H
	MOVLW	0XDB
	MOVWF	TMR0L
	;staet timer
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
	
RET_500ms:
     ; timer0 16 bits, Prescale value1:256
	MOVLW	B'00000111'		
	MOVWF	T0CON			
	BCF	INTCON,TMR0IF
	MOVLW	0X85
	MOVWF	TMR0H
	MOVLW	0XED
	MOVWF	TMR0L
	;staet timer
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_100ms:
     ; timer0 16 bits, Prescale value1:32
	MOVLW	B'00000100'		
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0X3C
	MOVWF	TMR0H
	MOVLW	0XAF
	MOVWF	TMR0L
	;staet timer
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_50ms:
     ; timer0 16 bits, Prescale value1:32
	MOVLW	B'00000100'		
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0X9E
	MOVWF	TMR0H
	MOVLW	0X57
	MOVWF	TMR0L
	;staet timer
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_33ms:
     ; timer0 16 bits, Prescale value1:32
	MOVLW	B'00000100'		
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XBF
	MOVWF	TMR0H
	MOVLW	0X8B
	MOVWF	TMR0L
	;staet timer
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_16ms:
      ; timer0 16 bits, Prescale value1:32
	MOVLW	B'00000100'		
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XE0
	MOVWF	TMR0H
	MOVLW	0XBF
	MOVWF	TMR0L
	;staet timer
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_18ms:
      ; timer0 16 bits, Prescale value1:32
	MOVLW	B'00000100'		
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XDC
	MOVWF	TMR0H
	MOVLW	0XD7
	MOVWF	TMR0L
	;staet timer
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_10ms:
      ; timer0 16 bits, Prescale value1:16
	MOVLW	B'00000011'		
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XD8
	MOVWF	TMR0H
	MOVLW	0XF0
	MOVWF	TMR0L
	;staet timer
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_5ms:
      ; timer0 16 bits, Prescale value1:2
	MOVLW	B'00000000'		
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	.99
	MOVWF	TMR0H
	MOVLW	.82
	MOVWF	TMR0L	
	;staet timer
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO
RET_500us:
      ; timer0 16 bits, Prescale value1:32
	MOVLW	B'00000100'		
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XFF
	MOVWF	TMR0H
	MOVLW	0X05
	MOVWF	TMR0L
	;staet timer
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO
RET_250us:
      ; timer0 16 bits, Prescale value1:32
	MOVLW	B'00000100'		
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XFF
	MOVWF	TMR0H
	MOVLW	0X82
	MOVWF	TMR0L
	;staet timer
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO
RET_1ms:
      ; timer0 16 bits, Prescale value1:32
	MOVLW	B'00000100'		
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XFE
	MOVWF	TMR0H
	MOVLW	0X0D
	MOVWF	TMR0L
	;staet timer
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO
	
CICLO_RETARDO:	
	;busy waiting
	BTFSS	INTCON,TMR0IF
	GOTO	CICLO_RETARDO
	;set TMR0 Overflow Interrupt Flag bit=0
	BCF	INTCON,TMR0IF
	;stop timer
	BCF	T0CON,TMR0ON
	RETURN

	END



