



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


	
	
	CBLOCK	0x00
	W_TEMP
	STATUS_TEMP
	BSR_TEMP


	ENDC
;*********************************************************************************
;****************** ORIGEN DE EJECUCION POSTERIOR AL RESET ***********************
;*********************************************************************************
	ORG	0x000			; ORIGEN INICIO RESET
 	GOTO	INICIO
	
;*********************************************************************************
;**************************CONFIGURACIÓN DE PUERTOS ******************************
;*********************************************************************************
INICIO:

	BSF	OSCCON,IRCF2			;CONFIGURO EL OSCILADOR INTERNO
	BSF	OSCCON,IRCF1			;A 16MHZ
	BSF	OSCCON,IRCF0
	BSF	OSCTUNE,PLLEN
	BSF	SSPSTAT,7		
	
	movlw 0x0f
	movwf ADCON1

	
	
	CLRF	PORTA			; LIMPIO EL PUERTO A
	CLRF	PORTB			; LIMPIO EL PUERTO B
	CLRF	PORTC			; LIMPIO EL PUERTO C
	

	CLRF	TRISA			; SALIDAS DIGITALES PUERTO A
	CLRF	TRISB			; SALIDAS DIGITALES PUERTO B
	CLRF	TRISC			; SALIDAS DIGITALES PUERTO C

	MOVLW	B'11111111'
	MOVWF	TRISA
	
;*********************************************************************************
;**************************CONFIGURACIÓN DE RETARDOS *****************************
;*********************************************************************************

;*********************************************************************************
;**************************  ZONA DE CODIGO USUARIO  *****************************
;*********************************************************************************
    

	#DEFINE	MOV_CW_X    PORTA,0
	#DEFINE	MOV_CCW_X   PORTA,1
	
	#DEFINE STEP_X	    LATC,5
	#DEFINE DIR_X	    LATC,4
	#DEFINE	ENABLE_X    LATC,6
	
	
	

PRINCIPAL_X:
	BTFSC	MOV_CW_X
	GOTO	DIR_CW_X
	BTFSC	MOV_CCW_X
	GOTO	DIR_CCW_X
	BSF	ENABLE_X
	GOTO	PRINCIPAL_X	
DIR_CW_X:	
	BCF	ENABLE_X	
	BCF	DIR_X
	BSF	STEP_X
	CALL	RET_500us
	BCF	STEP_X
	CALL	RET_500us
	BCF MOV_CW_X
	GOTO	PRINCIPAL_X
DIR_CCW_X:
	BCF	ENABLE_X	
	BSF	DIR_X
	BSF	STEP_X
	CALL	RET_500us
	BCF	STEP_X
	CALL	RET_500us
	BCF MOV_CCW_X
	GOTO	PRINCIPAL_X	




RET_SERVO:
	MOVLW	B'00000011'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XFF
	MOVWF	TMR0H
	MOVLW	0XFA
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO		

RET_1s:
	MOVLW	B'00000111'		; TIMER 0 16 BITS
	MOVWF	T0CON			; PREESCALER 256
	BCF	INTCON,TMR0IF
	MOVLW	0X0B
	MOVWF	TMR0H
	MOVLW	0XDB
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
	
RET_500ms:
	MOVLW	B'00000111'		; TIMER 0 16 BITS
	MOVWF	T0CON			; PREESCALER 256
	BCF	INTCON,TMR0IF
	MOVLW	0X85
	MOVWF	TMR0H
	MOVLW	0XED
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_100ms:
	MOVLW	B'00000100'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0X3C
	MOVWF	TMR0H
	MOVLW	0XAF
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_50ms:
	MOVLW	B'00000100'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0X9E
	MOVWF	TMR0H
	MOVLW	0X57
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_33ms:
	MOVLW	B'00000100'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XBF
	MOVWF	TMR0H
	MOVLW	0X8B
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_16ms:
	MOVLW	B'00000100'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XE0
	MOVWF	TMR0H
	MOVLW	0XBF
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_18ms:
	MOVLW	B'00000100'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XDC
	MOVWF	TMR0H
	MOVLW	0XD7
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_10ms:
	MOVLW	B'00000011'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XD8
	MOVWF	TMR0H
	MOVLW	0XF0
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO	
RET_5ms:
	MOVLW	B'00000000'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	.99
	MOVWF	TMR0H
	MOVLW	.82
	MOVWF	TMR0L	
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO
RET_500us:
	MOVLW	B'00000100'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XFF
	MOVWF	TMR0H
	MOVLW	0X05
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO
RET_250us:
	MOVLW	B'00000100'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XFF
	MOVWF	TMR0H
	MOVLW	0X82
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO
RET_1ms:
	MOVLW	B'00000100'		; TIMER 0 16 BITS
	MOVWF	T0CON	
	BCF	INTCON,TMR0IF
	MOVLW	0XFE
	MOVWF	TMR0H
	MOVLW	0X0D
	MOVWF	TMR0L
	BSF	T0CON,TMR0ON
	GOTO	CICLO_RETARDO
CICLO_RETARDO:	
	BTFSS	INTCON,TMR0IF
	GOTO	CICLO_RETARDO
	BCF	INTCON,TMR0IF
	BCF	T0CON,TMR0ON
	RETURN




	END





