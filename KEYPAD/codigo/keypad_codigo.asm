
_main:

;keypad_codigo.c,1 :: 		void main()
;keypad_codigo.c,3 :: 		PORTD =0x00;
	CLRF       PORTD+0
;keypad_codigo.c,5 :: 		TRISD.TRISD1 = 1;
	BSF        TRISD+0, 1
;keypad_codigo.c,6 :: 		TRISD.TRISD2 = 1;
	BSF        TRISD+0, 2
;keypad_codigo.c,7 :: 		TRISD.TRISD0 = 1;
	BSF        TRISD+0, 0
;keypad_codigo.c,9 :: 		UART1_Init(19200);
	MOVLW      64
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;keypad_codigo.c,10 :: 		while(1)
L_main0:
;keypad_codigo.c,12 :: 		while(RD0_bit ==0)
L_main2:
	BTFSC      RD0_bit+0, BitPos(RD0_bit+0)
	GOTO       L_main3
;keypad_codigo.c,14 :: 		delay_ms(1000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main4:
	DECFSZ     R13+0, 1
	GOTO       L_main4
	DECFSZ     R12+0, 1
	GOTO       L_main4
	DECFSZ     R11+0, 1
	GOTO       L_main4
	NOP
;keypad_codigo.c,15 :: 		UART1_Write_Text(" TESTE");
	MOVLW      ?lstr1_keypad_codigo+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;keypad_codigo.c,16 :: 		UART1_Write(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;keypad_codigo.c,18 :: 		}
	GOTO       L_main2
L_main3:
;keypad_codigo.c,19 :: 		delay_ms(1000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main5:
	DECFSZ     R13+0, 1
	GOTO       L_main5
	DECFSZ     R12+0, 1
	GOTO       L_main5
	DECFSZ     R11+0, 1
	GOTO       L_main5
	NOP
;keypad_codigo.c,20 :: 		UART1_Write_Text(" BIT ==1");
	MOVLW      ?lstr2_keypad_codigo+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;keypad_codigo.c,21 :: 		UART1_Write(13);
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;keypad_codigo.c,22 :: 		}
	GOTO       L_main0
;keypad_codigo.c,24 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
