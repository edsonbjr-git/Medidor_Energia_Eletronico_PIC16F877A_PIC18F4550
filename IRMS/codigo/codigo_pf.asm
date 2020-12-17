
_main:

;codigo_pf.c,26 :: 		void main()
;codigo_pf.c,29 :: 		TRISA = 0XFF;// All input
	MOVLW       255
	MOVWF       TRISA+0 
;codigo_pf.c,30 :: 		TRISB = 0X00;
	CLRF        TRISB+0 
;codigo_pf.c,31 :: 		PORTB = 0;
	CLRF        PORTB+0 
;codigo_pf.c,32 :: 		TRISB0_bit = 1;//set as input
	BSF         TRISB0_bit+0, BitPos(TRISB0_bit+0) 
;codigo_pf.c,33 :: 		TRISB1_bit = 1;//set as input
	BSF         TRISB1_bit+0, BitPos(TRISB1_bit+0) 
;codigo_pf.c,36 :: 		ADCON0 = 0x00;// AN0 analog input
	CLRF        ADCON0+0 
;codigo_pf.c,37 :: 		ADCON1 = 0xF0;
	MOVLW       240
	MOVWF       ADCON1+0 
;codigo_pf.c,41 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;codigo_pf.c,42 :: 		delay_ms(25);
	MOVLW       163
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main0:
	DECFSZ      R13, 1, 1
	BRA         L_main0
	DECFSZ      R12, 1, 1
	BRA         L_main0
;codigo_pf.c,43 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;codigo_pf.c,44 :: 		delay_ms(25);               // Clear display
	MOVLW       163
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main1:
	DECFSZ      R13, 1, 1
	BRA         L_main1
	DECFSZ      R12, 1, 1
	BRA         L_main1
;codigo_pf.c,45 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;codigo_pf.c,46 :: 		delay_ms(25);
	MOVLW       163
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main2:
	DECFSZ      R13, 1, 1
	BRA         L_main2
	DECFSZ      R12, 1, 1
	BRA         L_main2
;codigo_pf.c,47 :: 		Lcd_Out(1,1,"I RMS");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_codigo_pf+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_codigo_pf+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;codigo_pf.c,48 :: 		delay_ms(25);
	MOVLW       163
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
;codigo_pf.c,49 :: 		Lcd_Out(2,1,"Irms=");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_codigo_pf+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_codigo_pf+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;codigo_pf.c,53 :: 		while (1)
L_main4:
;codigo_pf.c,55 :: 		max1 =0;
	CLRF        _max1+0 
	CLRF        _max1+1 
	CLRF        _max1+2 
	CLRF        _max1+3 
;codigo_pf.c,56 :: 		min1 =99999;
	MOVLW       128
	MOVWF       _min1+0 
	MOVLW       79
	MOVWF       _min1+1 
	MOVLW       67
	MOVWF       _min1+2 
	MOVLW       143
	MOVWF       _min1+3 
;codigo_pf.c,57 :: 		ADCON0.ADON=1;
	BSF         ADCON0+0, 0 
;codigo_pf.c,58 :: 		Irms = 0;
	CLRF        _Irms+0 
	CLRF        _Irms+1 
	CLRF        _Irms+2 
	CLRF        _Irms+3 
;codigo_pf.c,59 :: 		for (i=0;i<=39;i++)           //(Somando Sinais Discretos)
	CLRF        _i+0 
	CLRF        _i+1 
L_main6:
	MOVLW       0
	MOVWF       R0 
	MOVF        _i+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main11
	MOVF        _i+0, 0 
	SUBLW       39
L__main11:
	BTFSS       STATUS+0, 0 
	GOTO        L_main7
;codigo_pf.c,61 :: 		vout_corrente[i] = 100.0*(115.0/15.0)*(((ADC_Read(0)*5.0/1024.0)-2.5)/0.0667);
	MOVF        _i+0, 0 
	MOVWF       R0 
	MOVF        _i+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _vout_corrente+0
	ADDWF       R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(_vout_corrente+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__main+1 
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	CALL        _word2double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       129
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       137
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       128
	MOVWF       R7 
	CALL        _Sub_32x32_FP+0, 0
	MOVLW       2
	MOVWF       R4 
	MOVLW       154
	MOVWF       R5 
	MOVLW       8
	MOVWF       R6 
	MOVLW       123
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVLW       170
	MOVWF       R4 
	MOVLW       170
	MOVWF       R5 
	MOVLW       63
	MOVWF       R6 
	MOVLW       136
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _double2int+0, 0
	MOVFF       FLOC__main+0, FSR1
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;codigo_pf.c,62 :: 		Irms = Irms + (vout_corrente[i]/100.0)*(vout_corrente[i]/100.0);
	MOVF        _i+0, 0 
	MOVWF       R0 
	MOVF        _i+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _vout_corrente+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_vout_corrente+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	CALL        _int2double+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__main+4 
	MOVF        R1, 0 
	MOVWF       FLOC__main+5 
	MOVF        R2, 0 
	MOVWF       FLOC__main+6 
	MOVF        R3, 0 
	MOVWF       FLOC__main+7 
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       72
	MOVWF       R6 
	MOVLW       133
	MOVWF       R7 
	MOVF        FLOC__main+4, 0 
	MOVWF       R0 
	MOVF        FLOC__main+5, 0 
	MOVWF       R1 
	MOVF        FLOC__main+6, 0 
	MOVWF       R2 
	MOVF        FLOC__main+7, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__main+0 
	MOVF        R1, 0 
	MOVWF       FLOC__main+1 
	MOVF        R2, 0 
	MOVWF       FLOC__main+2 
	MOVF        R3, 0 
	MOVWF       FLOC__main+3 
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       72
	MOVWF       R6 
	MOVLW       133
	MOVWF       R7 
	MOVF        FLOC__main+4, 0 
	MOVWF       R0 
	MOVF        FLOC__main+5, 0 
	MOVWF       R1 
	MOVF        FLOC__main+6, 0 
	MOVWF       R2 
	MOVF        FLOC__main+7, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVF        FLOC__main+0, 0 
	MOVWF       R4 
	MOVF        FLOC__main+1, 0 
	MOVWF       R5 
	MOVF        FLOC__main+2, 0 
	MOVWF       R6 
	MOVF        FLOC__main+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        _Irms+0, 0 
	MOVWF       R4 
	MOVF        _Irms+1, 0 
	MOVWF       R5 
	MOVF        _Irms+2, 0 
	MOVWF       R6 
	MOVF        _Irms+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _Irms+0 
	MOVF        R1, 0 
	MOVWF       _Irms+1 
	MOVF        R2, 0 
	MOVWF       _Irms+2 
	MOVF        R3, 0 
	MOVWF       _Irms+3 
;codigo_pf.c,59 :: 		for (i=0;i<=39;i++)           //(Somando Sinais Discretos)
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;codigo_pf.c,63 :: 		}
	GOTO        L_main6
L_main7:
;codigo_pf.c,64 :: 		ADCON0.ADON=0;
	BCF         ADCON0+0, 0 
;codigo_pf.c,67 :: 		Irms = sqrt(Irms/40.0);
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       132
	MOVWF       R7 
	MOVF        _Irms+0, 0 
	MOVWF       R0 
	MOVF        _Irms+1, 0 
	MOVWF       R1 
	MOVF        _Irms+2, 0 
	MOVWF       R2 
	MOVF        _Irms+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_sqrt_x+0 
	MOVF        R1, 0 
	MOVWF       FARG_sqrt_x+1 
	MOVF        R2, 0 
	MOVWF       FARG_sqrt_x+2 
	MOVF        R3, 0 
	MOVWF       FARG_sqrt_x+3 
	CALL        _sqrt+0, 0
	MOVF        R0, 0 
	MOVWF       _Irms+0 
	MOVF        R1, 0 
	MOVWF       _Irms+1 
	MOVF        R2, 0 
	MOVWF       _Irms+2 
	MOVF        R3, 0 
	MOVWF       _Irms+3 
;codigo_pf.c,70 :: 		floatToStr(Irms,txt);
	MOVF        R0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        R1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        R2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        R3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _txt+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;codigo_pf.c,71 :: 		txt[6] = 0;
	CLRF        _txt+6 
;codigo_pf.c,72 :: 		delay_ms(200);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main9:
	DECFSZ      R13, 1, 1
	BRA         L_main9
	DECFSZ      R12, 1, 1
	BRA         L_main9
	DECFSZ      R11, 1, 1
	BRA         L_main9
	NOP
	NOP
;codigo_pf.c,73 :: 		Lcd_Out (2,6,txt);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _txt+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;codigo_pf.c,74 :: 		} // Fim Laço Infinito
	GOTO        L_main4
;codigo_pf.c,75 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
