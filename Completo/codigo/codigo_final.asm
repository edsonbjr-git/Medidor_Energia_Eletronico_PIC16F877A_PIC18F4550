
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;codigo_final.c,49 :: 		void interrupt()
;codigo_final.c,52 :: 		if(INTCON.TMR0IF)       //interrupção por overflow timer0
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;codigo_final.c,54 :: 		t_counter++;           // incrementa a soma de overflows
	INCF       _t_counter+0, 1
	BTFSC      STATUS+0, 2
	INCF       _t_counter+1, 1
;codigo_final.c,55 :: 		INTCON.TMR0IF = 0;     // zero o bit overflow
	BCF        INTCON+0, 2
;codigo_final.c,56 :: 		TMR0=0;                // zera o timer0
	CLRF       TMR0+0
;codigo_final.c,57 :: 		}
L_interrupt0:
;codigo_final.c,60 :: 		if (INTCON.INTF)
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt1
;codigo_final.c,62 :: 		tempo_total += t_counter*(256 - TMR0)*4*4/20000000.0; // tempo segundos
	MOVF       TMR0+0, 0
	SUBLW      0
	MOVWF      R0+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      1
	MOVWF      R0+1
	MOVF       _t_counter+0, 0
	MOVWF      R4+0
	MOVF       _t_counter+1, 0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      R3+0
	MOVF       R0+1, 0
	MOVWF      R3+1
	RLF        R3+0, 1
	RLF        R3+1, 1
	BCF        R3+0, 0
	RLF        R3+0, 1
	RLF        R3+1, 1
	BCF        R3+0, 0
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	CALL       _word2double+0
	MOVLW      128
	MOVWF      R4+0
	MOVLW      150
	MOVWF      R4+1
	MOVLW      24
	MOVWF      R4+2
	MOVLW      151
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVF       _tempo_total+0, 0
	MOVWF      R4+0
	MOVF       _tempo_total+1, 0
	MOVWF      R4+1
	MOVF       _tempo_total+2, 0
	MOVWF      R4+2
	MOVF       _tempo_total+3, 0
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _tempo_total+0
	MOVF       R0+1, 0
	MOVWF      _tempo_total+1
	MOVF       R0+2, 0
	MOVWF      _tempo_total+2
	MOVF       R0+3, 0
	MOVWF      _tempo_total+3
;codigo_final.c,63 :: 		tempo_counter++;
	INCF       _tempo_counter+0, 1
	BTFSC      STATUS+0, 2
	INCF       _tempo_counter+1, 1
;codigo_final.c,65 :: 		if(tempo_counter == 150)
	MOVLW      0
	XORWF      _tempo_counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt36
	MOVLW      150
	XORWF      _tempo_counter+0, 0
L__interrupt36:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt2
;codigo_final.c,67 :: 		final_total = tempo_total/20.0;
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      131
	MOVWF      R4+3
	MOVF       _tempo_total+0, 0
	MOVWF      R0+0
	MOVF       _tempo_total+1, 0
	MOVWF      R0+1
	MOVF       _tempo_total+2, 0
	MOVWF      R0+2
	MOVF       _tempo_total+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _final_total+0
	MOVF       R0+1, 0
	MOVWF      _final_total+1
	MOVF       R0+2, 0
	MOVWF      _final_total+2
	MOVF       R0+3, 0
	MOVWF      _final_total+3
;codigo_final.c,68 :: 		tempo_counter =0;
	CLRF       _tempo_counter+0
	CLRF       _tempo_counter+1
;codigo_final.c,69 :: 		t_counter_final = t_counter;
	MOVF       _t_counter+0, 0
	MOVWF      _t_counter_final+0
	MOVF       _t_counter+1, 0
	MOVWF      _t_counter_final+1
;codigo_final.c,70 :: 		t_counter = 0;
	CLRF       _t_counter+0
	CLRF       _t_counter+1
;codigo_final.c,71 :: 		}
L_interrupt2:
;codigo_final.c,72 :: 		INTCON.INTF = 0;        // deixa flag zero novamente
	BCF        INTCON+0, 1
;codigo_final.c,73 :: 		}
L_interrupt1:
;codigo_final.c,74 :: 		}
L_end_interrupt:
L__interrupt35:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;codigo_final.c,77 :: 		void main()
;codigo_final.c,79 :: 		PORTB = 0;
	CLRF       PORTB+0
;codigo_final.c,80 :: 		TRISB = 0x01;              //RB0 input for interrupt
	MOVLW      1
	MOVWF      TRISB+0
;codigo_final.c,81 :: 		PORTD = 0;
	CLRF       PORTD+0
;codigo_final.c,82 :: 		TRISD = 0;                 //PORTD all output
	CLRF       TRISD+0
;codigo_final.c,83 :: 		TRISD.TRISD0 = 1;         // RD0 como entrada para o botão
	BSF        TRISD+0, 0
;codigo_final.c,84 :: 		TRISD.TRISD1 = 1;         // RD1 como entrada para o botão
	BSF        TRISD+0, 1
;codigo_final.c,85 :: 		TRISD.TRISD2 = 1;         // RD2 como entrada para o botão
	BSF        TRISD+0, 2
;codigo_final.c,86 :: 		OPTION_REG.INTEDG = 0;      //interrupt on falling edge
	BCF        OPTION_REG+0, 6
;codigo_final.c,89 :: 		OPTION_REG.T0CS = 0;        // T0CS_bit = 0;
	BCF        OPTION_REG+0, 5
;codigo_final.c,90 :: 		OPTION_REG.T0SE = 0;        //  T0SE_bit = 0;
	BCF        OPTION_REG+0, 4
;codigo_final.c,91 :: 		OPTION_REG.PSA = 0;         //PSA_bit = 0;
	BCF        OPTION_REG+0, 3
;codigo_final.c,92 :: 		OPTION_REG.PS2 = 0;         //prescale 1:4
	BCF        OPTION_REG+0, 2
;codigo_final.c,93 :: 		OPTION_REG.PS1 = 0;         //prescale 1:4
	BCF        OPTION_REG+0, 1
;codigo_final.c,94 :: 		OPTION_REG.PS0 = 1;         //prescale 1:4
	BSF        OPTION_REG+0, 0
;codigo_final.c,95 :: 		OPTION_REG.NOT_RBPU = 1;    //Desabilita resistores pullup
	BSF        OPTION_REG+0, 7
;codigo_final.c,97 :: 		Lcd_Init();                   // Inicializar LCD
	CALL       _Lcd_Init+0
;codigo_final.c,98 :: 		Lcd_Cmd(_LCD_CLEAR);          // Limpar display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;codigo_final.c,99 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);     // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;codigo_final.c,100 :: 		delay_us(500);
	MOVLW      4
	MOVWF      R12+0
	MOVLW      61
	MOVWF      R13+0
L_main3:
	DECFSZ     R13+0, 1
	GOTO       L_main3
	DECFSZ     R12+0, 1
	GOTO       L_main3
	NOP
	NOP
;codigo_final.c,101 :: 		Lcd_Out(1,1,"MEDIDOR ELETRONICO");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_codigo_final+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;codigo_final.c,102 :: 		Lcd_Out(2,1,"Vrms=");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_codigo_final+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;codigo_final.c,103 :: 		delay_us(500);
	MOVLW      4
	MOVWF      R12+0
	MOVLW      61
	MOVWF      R13+0
L_main4:
	DECFSZ     R13+0, 1
	GOTO       L_main4
	DECFSZ     R12+0, 1
	GOTO       L_main4
	NOP
	NOP
;codigo_final.c,104 :: 		Lcd_Out(3,1,"Irms=");
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_codigo_final+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;codigo_final.c,105 :: 		Lcd_Out(4,1,"FREQ:");
	MOVLW      4
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_codigo_final+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;codigo_final.c,106 :: 		Lcd_Out(4,12,"hz");
	MOVLW      4
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_codigo_final+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;codigo_final.c,107 :: 		delay_us(500);
	MOVLW      4
	MOVWF      R12+0
	MOVLW      61
	MOVWF      R13+0
L_main5:
	DECFSZ     R13+0, 1
	GOTO       L_main5
	DECFSZ     R12+0, 1
	GOTO       L_main5
	NOP
	NOP
;codigo_final.c,111 :: 		INTCON.GIE        = 1;   // bit 7 - enable global interrupt
	BSF        INTCON+0, 7
;codigo_final.c,112 :: 		INTCON.PEIE       = 1;   // bit 6 -  enable all unmasked peripheral interrupts
	BSF        INTCON+0, 6
;codigo_final.c,113 :: 		INTCON.TMR0IE     = 1;   // bit 5 - habilita interrupcao por overflow do TIMER0
	BSF        INTCON+0, 5
;codigo_final.c,114 :: 		INTCON.INTE       = 1;   // bit 4 - enable external interrupt
	BSF        INTCON+0, 4
;codigo_final.c,115 :: 		INTCON.TMR0IF     = 0;   // bit 2 - ZERO O FLAG DO overflow
	BCF        INTCON+0, 2
;codigo_final.c,116 :: 		INTCON.INTF       = 0;   // bit 1 - clear interrupt flag
	BCF        INTCON+0, 1
;codigo_final.c,118 :: 		TMR0 = 0; // zera a contagem
	CLRF       TMR0+0
;codigo_final.c,120 :: 		while (RD0_bit == 1 && RD1_bit == 1 && RD2_bit == 0 )
L_main6:
	BTFSS      RD0_bit+0, BitPos(RD0_bit+0)
	GOTO       L_main7
	BTFSS      RD1_bit+0, BitPos(RD1_bit+0)
	GOTO       L_main7
	BTFSC      RD2_bit+0, BitPos(RD2_bit+0)
	GOTO       L_main7
L__main33:
;codigo_final.c,122 :: 		INTCON.GIE        = 0;
	BCF        INTCON+0, 7
;codigo_final.c,123 :: 		freq = (1.0/((t_counter_final/150.0)*(256 -0)*4*4/20000000.0));
	MOVF       _t_counter_final+0, 0
	MOVWF      R0+0
	MOVF       _t_counter_final+1, 0
	MOVWF      R0+1
	CALL       _word2double+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      22
	MOVWF      R4+2
	MOVLW      134
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      135
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      129
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      129
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      128
	MOVWF      R4+0
	MOVLW      150
	MOVWF      R4+1
	MOVLW      24
	MOVWF      R4+2
	MOVLW      151
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	MOVF       R0+2, 0
	MOVWF      R4+2
	MOVF       R0+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      0
	MOVWF      R0+2
	MOVLW      127
	MOVWF      R0+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _freq+0
	MOVF       R0+1, 0
	MOVWF      _freq+1
	MOVF       R0+2, 0
	MOVWF      _freq+2
	MOVF       R0+3, 0
	MOVWF      _freq+3
;codigo_final.c,125 :: 		if(freq <100 && freq >30)
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      72
	MOVWF      R4+2
	MOVLW      133
	MOVWF      R4+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main12
	MOVF       _freq+0, 0
	MOVWF      R4+0
	MOVF       _freq+1, 0
	MOVWF      R4+1
	MOVF       _freq+2, 0
	MOVWF      R4+2
	MOVF       _freq+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      112
	MOVWF      R0+2
	MOVLW      131
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main12
L__main32:
;codigo_final.c,127 :: 		floatToStr(freq,txt);
	MOVF       _freq+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       _freq+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       _freq+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       _freq+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      _txt+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;codigo_final.c,128 :: 		t_counter_final=0;
	CLRF       _t_counter_final+0
	CLRF       _t_counter_final+1
;codigo_final.c,129 :: 		txt[5] = 0;
	CLRF       _txt+5
;codigo_final.c,130 :: 		delay_ms(400);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main13:
	DECFSZ     R13+0, 1
	GOTO       L_main13
	DECFSZ     R12+0, 1
	GOTO       L_main13
	DECFSZ     R11+0, 1
	GOTO       L_main13
	NOP
	NOP
;codigo_final.c,131 :: 		Lcd_Out(4,6,txt);
	MOVLW      4
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;codigo_final.c,132 :: 		}
L_main12:
;codigo_final.c,133 :: 		}
	GOTO       L_main6
L_main7:
;codigo_final.c,135 :: 		while (RD0_bit == 1 && RD1_bit == 0 && RD2_bit == 1 )
L_main14:
	BTFSS      RD0_bit+0, BitPos(RD0_bit+0)
	GOTO       L_main15
	BTFSC      RD1_bit+0, BitPos(RD1_bit+0)
	GOTO       L_main15
	BTFSS      RD2_bit+0, BitPos(RD2_bit+0)
	GOTO       L_main15
L__main31:
;codigo_final.c,137 :: 		INTCON.GIE        = 0;
	BCF        INTCON+0, 7
;codigo_final.c,138 :: 		ADCON0 = 0b00001001; // Ativado An1 - Canal Analógico
	MOVLW      9
	MOVWF      ADCON0+0
;codigo_final.c,139 :: 		ADCON1 = 0b11001001; // Verificar datasheet
	MOVLW      201
	MOVWF      ADCON1+0
;codigo_final.c,141 :: 		max1 =0;      min1 =99999;      ADCON0.ADON=1;      Irms = 0;
	CLRF       _max1+0
	CLRF       _max1+1
	MOVLW      159
	MOVWF      _min1+0
	MOVLW      134
	MOVWF      _min1+1
	BSF        ADCON0+0, 0
	CLRF       _Irms+0
	CLRF       _Irms+1
	CLRF       _Irms+2
	CLRF       _Irms+3
;codigo_final.c,142 :: 		for (i=0;i<=39;i++)           //(Somando Sinais Discretos)
	CLRF       _i+0
	CLRF       _i+1
L_main18:
	MOVF       _i+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main38
	MOVF       _i+0, 0
	SUBLW      39
L__main38:
	BTFSS      STATUS+0, 0
	GOTO       L_main19
;codigo_final.c,144 :: 		vout_corrente[i] = 100.0*(115.0/15.0)*(((ADC_Read(1)*5.0/1024.0)-2.5)/0.0667);
	MOVF       _i+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _vout_corrente+0
	MOVWF      FLOC__main+0
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	CALL       _word2double+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      129
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      137
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      128
	MOVWF      R4+3
	CALL       _Sub_32x32_FP+0
	MOVLW      2
	MOVWF      R4+0
	MOVLW      154
	MOVWF      R4+1
	MOVLW      8
	MOVWF      R4+2
	MOVLW      123
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVLW      170
	MOVWF      R4+0
	MOVLW      170
	MOVWF      R4+1
	MOVLW      63
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	CALL       _double2int+0
	MOVF       FLOC__main+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	MOVF       R0+1, 0
	INCF       FSR, 1
	MOVWF      INDF+0
;codigo_final.c,145 :: 		Irms = Irms + (vout_corrente[i]/100.0)*(vout_corrente[i]/100.0);
	MOVF       _i+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _vout_corrente+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	INCF       FSR, 1
	MOVF       INDF+0, 0
	MOVWF      R0+1
	CALL       _int2double+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+4
	MOVF       R0+1, 0
	MOVWF      FLOC__main+5
	MOVF       R0+2, 0
	MOVWF      FLOC__main+6
	MOVF       R0+3, 0
	MOVWF      FLOC__main+7
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      72
	MOVWF      R4+2
	MOVLW      133
	MOVWF      R4+3
	MOVF       FLOC__main+4, 0
	MOVWF      R0+0
	MOVF       FLOC__main+5, 0
	MOVWF      R0+1
	MOVF       FLOC__main+6, 0
	MOVWF      R0+2
	MOVF       FLOC__main+7, 0
	MOVWF      R0+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	MOVF       R0+1, 0
	MOVWF      FLOC__main+1
	MOVF       R0+2, 0
	MOVWF      FLOC__main+2
	MOVF       R0+3, 0
	MOVWF      FLOC__main+3
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      72
	MOVWF      R4+2
	MOVLW      133
	MOVWF      R4+3
	MOVF       FLOC__main+4, 0
	MOVWF      R0+0
	MOVF       FLOC__main+5, 0
	MOVWF      R0+1
	MOVF       FLOC__main+6, 0
	MOVWF      R0+2
	MOVF       FLOC__main+7, 0
	MOVWF      R0+3
	CALL       _Div_32x32_FP+0
	MOVF       FLOC__main+0, 0
	MOVWF      R4+0
	MOVF       FLOC__main+1, 0
	MOVWF      R4+1
	MOVF       FLOC__main+2, 0
	MOVWF      R4+2
	MOVF       FLOC__main+3, 0
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       _Irms+0, 0
	MOVWF      R4+0
	MOVF       _Irms+1, 0
	MOVWF      R4+1
	MOVF       _Irms+2, 0
	MOVWF      R4+2
	MOVF       _Irms+3, 0
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _Irms+0
	MOVF       R0+1, 0
	MOVWF      _Irms+1
	MOVF       R0+2, 0
	MOVWF      _Irms+2
	MOVF       R0+3, 0
	MOVWF      _Irms+3
;codigo_final.c,142 :: 		for (i=0;i<=39;i++)           //(Somando Sinais Discretos)
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;codigo_final.c,146 :: 		}
	GOTO       L_main18
L_main19:
;codigo_final.c,147 :: 		ADCON0.ADON=0;
	BCF        ADCON0+0, 0
;codigo_final.c,149 :: 		Irms = sqrt(Irms/40.0);
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      132
	MOVWF      R4+3
	MOVF       _Irms+0, 0
	MOVWF      R0+0
	MOVF       _Irms+1, 0
	MOVWF      R0+1
	MOVF       _Irms+2, 0
	MOVWF      R0+2
	MOVF       _Irms+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      FARG_sqrt_x+0
	MOVF       R0+1, 0
	MOVWF      FARG_sqrt_x+1
	MOVF       R0+2, 0
	MOVWF      FARG_sqrt_x+2
	MOVF       R0+3, 0
	MOVWF      FARG_sqrt_x+3
	CALL       _sqrt+0
	MOVF       R0+0, 0
	MOVWF      _Irms+0
	MOVF       R0+1, 0
	MOVWF      _Irms+1
	MOVF       R0+2, 0
	MOVWF      _Irms+2
	MOVF       R0+3, 0
	MOVWF      _Irms+3
;codigo_final.c,150 :: 		floatToStr(Irms,corrente_txt);
	MOVF       R0+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       R0+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       R0+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       R0+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      _corrente_txt+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;codigo_final.c,151 :: 		txt[6] = 0;
	CLRF       _txt+6
;codigo_final.c,152 :: 		delay_ms(400);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main21:
	DECFSZ     R13+0, 1
	GOTO       L_main21
	DECFSZ     R12+0, 1
	GOTO       L_main21
	DECFSZ     R11+0, 1
	GOTO       L_main21
	NOP
	NOP
;codigo_final.c,153 :: 		Lcd_Out (3,8,corrente_txt);
	MOVLW      3
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _corrente_txt+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;codigo_final.c,154 :: 		}
	GOTO       L_main14
L_main15:
;codigo_final.c,156 :: 		while (RD0_bit == 0 && RD1_bit == 1 && RD2_bit == 1 )
L_main22:
	BTFSC      RD0_bit+0, BitPos(RD0_bit+0)
	GOTO       L_main23
	BTFSS      RD1_bit+0, BitPos(RD1_bit+0)
	GOTO       L_main23
	BTFSS      RD2_bit+0, BitPos(RD2_bit+0)
	GOTO       L_main23
L__main30:
;codigo_final.c,158 :: 		INTCON.GIE        = 0;
	BCF        INTCON+0, 7
;codigo_final.c,159 :: 		ADCON0 = 0b00000001; // Ativado An0 - Canal Analógico
	MOVLW      1
	MOVWF      ADCON0+0
;codigo_final.c,160 :: 		ADCON1 = 0b11001001; // Verificar datasheet
	MOVLW      201
	MOVWF      ADCON1+0
;codigo_final.c,162 :: 		max1 =0;      min1 =999999;      ADCON0.ADON=1;      vrms =0;
	CLRF       _max1+0
	CLRF       _max1+1
	MOVLW      63
	MOVWF      _min1+0
	MOVLW      66
	MOVWF      _min1+1
	BSF        ADCON0+0, 0
	CLRF       _vrms+0
	CLRF       _vrms+1
	CLRF       _vrms+2
	CLRF       _vrms+3
;codigo_final.c,163 :: 		for (i=0;i<=39;i++)           //(Somando Sinais Discretos)
	CLRF       _i+0
	CLRF       _i+1
L_main26:
	MOVF       _i+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main39
	MOVF       _i+0, 0
	SUBLW      39
L__main39:
	BTFSS      STATUS+0, 0
	GOTO       L_main27
;codigo_final.c,165 :: 		vet_voltage[i] = 1000.0*ADC_Read(0)*5.0/1024.0; // Leitura da porta e conversão de 0 à 5V
	MOVF       _i+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _vet_voltage+0
	MOVWF      FLOC__main+0
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	CALL       _word2double+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      122
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      129
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      0
	MOVWF      R4+2
	MOVLW      137
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	CALL       _double2word+0
	MOVF       FLOC__main+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	MOVF       R0+1, 0
	INCF       FSR, 1
	MOVWF      INDF+0
;codigo_final.c,166 :: 		vrms = vrms + (((vet_voltage[i]/500.0)-5)*109.9)*(((vet_voltage[i]/500.0)-5)*109.9);
	MOVF       _i+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _vet_voltage+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	INCF       FSR, 1
	MOVF       INDF+0, 0
	MOVWF      R0+1
	CALL       _word2double+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+4
	MOVF       R0+1, 0
	MOVWF      FLOC__main+5
	MOVF       R0+2, 0
	MOVWF      FLOC__main+6
	MOVF       R0+3, 0
	MOVWF      FLOC__main+7
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      122
	MOVWF      R4+2
	MOVLW      135
	MOVWF      R4+3
	MOVF       FLOC__main+4, 0
	MOVWF      R0+0
	MOVF       FLOC__main+5, 0
	MOVWF      R0+1
	MOVF       FLOC__main+6, 0
	MOVWF      R0+2
	MOVF       FLOC__main+7, 0
	MOVWF      R0+3
	CALL       _Div_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      129
	MOVWF      R4+3
	CALL       _Sub_32x32_FP+0
	MOVLW      205
	MOVWF      R4+0
	MOVLW      204
	MOVWF      R4+1
	MOVLW      91
	MOVWF      R4+2
	MOVLW      133
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	MOVF       R0+1, 0
	MOVWF      FLOC__main+1
	MOVF       R0+2, 0
	MOVWF      FLOC__main+2
	MOVF       R0+3, 0
	MOVWF      FLOC__main+3
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      122
	MOVWF      R4+2
	MOVLW      135
	MOVWF      R4+3
	MOVF       FLOC__main+4, 0
	MOVWF      R0+0
	MOVF       FLOC__main+5, 0
	MOVWF      R0+1
	MOVF       FLOC__main+6, 0
	MOVWF      R0+2
	MOVF       FLOC__main+7, 0
	MOVWF      R0+3
	CALL       _Div_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      129
	MOVWF      R4+3
	CALL       _Sub_32x32_FP+0
	MOVLW      205
	MOVWF      R4+0
	MOVLW      204
	MOVWF      R4+1
	MOVLW      91
	MOVWF      R4+2
	MOVLW      133
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       FLOC__main+0, 0
	MOVWF      R4+0
	MOVF       FLOC__main+1, 0
	MOVWF      R4+1
	MOVF       FLOC__main+2, 0
	MOVWF      R4+2
	MOVF       FLOC__main+3, 0
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       _vrms+0, 0
	MOVWF      R4+0
	MOVF       _vrms+1, 0
	MOVWF      R4+1
	MOVF       _vrms+2, 0
	MOVWF      R4+2
	MOVF       _vrms+3, 0
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _vrms+0
	MOVF       R0+1, 0
	MOVWF      _vrms+1
	MOVF       R0+2, 0
	MOVWF      _vrms+2
	MOVF       R0+3, 0
	MOVWF      _vrms+3
;codigo_final.c,163 :: 		for (i=0;i<=39;i++)           //(Somando Sinais Discretos)
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;codigo_final.c,167 :: 		}
	GOTO       L_main26
L_main27:
;codigo_final.c,168 :: 		ADCON0.ADON=0;
	BCF        ADCON0+0, 0
;codigo_final.c,170 :: 		vrms = sqrt(vrms/40.0);
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      132
	MOVWF      R4+3
	MOVF       _vrms+0, 0
	MOVWF      R0+0
	MOVF       _vrms+1, 0
	MOVWF      R0+1
	MOVF       _vrms+2, 0
	MOVWF      R0+2
	MOVF       _vrms+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      FARG_sqrt_x+0
	MOVF       R0+1, 0
	MOVWF      FARG_sqrt_x+1
	MOVF       R0+2, 0
	MOVWF      FARG_sqrt_x+2
	MOVF       R0+3, 0
	MOVWF      FARG_sqrt_x+3
	CALL       _sqrt+0
	MOVF       R0+0, 0
	MOVWF      _vrms+0
	MOVF       R0+1, 0
	MOVWF      _vrms+1
	MOVF       R0+2, 0
	MOVWF      _vrms+2
	MOVF       R0+3, 0
	MOVWF      _vrms+3
;codigo_final.c,171 :: 		floatToStr(vrms,voltage_txt);
	MOVF       R0+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       R0+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       R0+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       R0+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      _voltage_txt+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;codigo_final.c,172 :: 		voltage_txt[6] = 0;
	CLRF       _voltage_txt+6
;codigo_final.c,173 :: 		delay_ms(400);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main29:
	DECFSZ     R13+0, 1
	GOTO       L_main29
	DECFSZ     R12+0, 1
	GOTO       L_main29
	DECFSZ     R11+0, 1
	GOTO       L_main29
	NOP
	NOP
;codigo_final.c,174 :: 		Lcd_Out (2,8,voltage_txt);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _voltage_txt+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;codigo_final.c,175 :: 		} // Fim Laço Infinito
	GOTO       L_main22
L_main23:
;codigo_final.c,177 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
