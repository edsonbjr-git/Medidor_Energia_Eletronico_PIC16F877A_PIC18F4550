//=====================================================================
// codigo_final.c
// autor: Edson Beraldo Jr. -------- Projeto Medidor Eletrônico AC
//=====================================================================

// LCD module connections
sbit LCD_RS at RB1_bit;
sbit LCD_EN at RB2_bit;
sbit LCD_D4 at RB3_bit;
sbit LCD_D5 at RB4_bit;
sbit LCD_D6 at RB5_bit;
sbit LCD_D7 at RB6_bit;

sbit LCD_RS_Direction at TRISB1_bit;
sbit LCD_EN_Direction at TRISB2_bit;
sbit LCD_D4_Direction at TRISB3_bit;
sbit LCD_D5_Direction at TRISB4_bit;
sbit LCD_D6_Direction at TRISB5_bit;
sbit LCD_D7_Direction at TRISB6_bit;
// End LCD module connections

//=============== VARIAVEIS FREQUENCIA ============
unsigned char FlagReg;
sbit ZC at FlagReg.B0;
char txt[8];
unsigned int t_counter =0, tempo_counter =0, t_counter_final =0;
float tempo_total = 0;
float final_total = 0;
float freq = 0;

//=============== VARIAVEIS IRMS ==================
unsigned int i = 0;
//float aux = 0, soma=0, max1=0, min=1000;
int vout_corrente[40];
float Irms =0;
//float valor_final=0;
unsigned char corrente_txt[8];
//float raiz;

//=============== VARIAVEIS VRMS ==================
//unsigned int i = 0;
unsigned int quant = 0,  max1=0, min1=999999;
unsigned int vet_voltage[40];
float voltage = 0;
float vrms =0;
unsigned char voltage_txt[8];


void interrupt()
{
//=============== interrupção por estouro do timer0
     if(INTCON.TMR0IF)       //interrupção por overflow timer0
     {
      t_counter++;           // incrementa a soma de overflows
      INTCON.TMR0IF = 0;     // zero o bit overflow
      TMR0=0;                // zera o timer0
     }

//===============  interrupção por borda de subida do sinal
     if (INTCON.INTF)
     {          //INTF flag raised, so external interrupt occured
        tempo_total += t_counter*(256 - TMR0)*4*4/20000000.0; // tempo segundos
        tempo_counter++;

       if(tempo_counter == 150)
       {
            final_total = tempo_total/20.0;
            tempo_counter =0;
            t_counter_final = t_counter;
            t_counter = 0;
       }
        INTCON.INTF = 0;        // deixa flag zero novamente
     }
}

//=================== MAIN ==========================
void main()
{
     PORTB = 0;
     TRISB = 0x01;              //RB0 input for interrupt
     PORTD = 0;
     TRISD = 0;                 //PORTD all output
     TRISD.TRISD0 = 1;         // RD0 como entrada para o botão
     TRISD.TRISD1 = 1;         // RD1 como entrada para o botão
     TRISD.TRISD2 = 1;         // RD2 como entrada para o botão
     OPTION_REG.INTEDG = 0;      //interrupt on falling edge

     //timer0 configuration
     OPTION_REG.T0CS = 0;        // T0CS_bit = 0;
     OPTION_REG.T0SE = 0;        //  T0SE_bit = 0;
     OPTION_REG.PSA = 0;         //PSA_bit = 0;
     OPTION_REG.PS2 = 0;         //prescale 1:4
     OPTION_REG.PS1 = 0;         //prescale 1:4
     OPTION_REG.PS0 = 1;         //prescale 1:4
     OPTION_REG.NOT_RBPU = 1;    //Desabilita resistores pullup

     Lcd_Init();                   // Inicializar LCD
     Lcd_Cmd(_LCD_CLEAR);          // Limpar display
     Lcd_Cmd(_LCD_CURSOR_OFF);     // Cursor off
     delay_us(500);
     Lcd_Out(1,1,"MEDIDOR ELETRONICO");
     Lcd_Out(2,1,"Vrms=");
     delay_us(500);
     Lcd_Out(3,1,"Irms=");
     Lcd_Out(4,1,"FREQ:");
     Lcd_Out(4,12,"hz");
     delay_us(500);



    INTCON.GIE        = 1;   // bit 7 - enable global interrupt
    INTCON.PEIE       = 1;   // bit 6 -  enable all unmasked peripheral interrupts
    INTCON.TMR0IE     = 1;   // bit 5 - habilita interrupcao por overflow do TIMER0
    INTCON.INTE       = 1;   // bit 4 - enable external interrupt
    INTCON.TMR0IF     = 0;   // bit 2 - ZERO O FLAG DO overflow
    INTCON.INTF       = 0;   // bit 1 - clear interrupt flag

     TMR0 = 0; // zera a contagem
     //========================= BOTAO RD2 ACIONADO -- FREQUENCIA =========
     while (RD0_bit == 1 && RD1_bit == 1 && RD2_bit == 0 )
     {
               INTCON.GIE        = 0;
               freq = (1.0/((t_counter_final/150.0)*(256 -0)*4*4/20000000.0));
               //freq = 1.0/(final_total/2.0);
                if(freq <100 && freq >30)
                {
                  floatToStr(freq,txt);
                  t_counter_final=0;
                  txt[5] = 0;
                  delay_ms(400);
                  Lcd_Out(4,6,txt);
                 }
     }
     //========================= BOTAO RD1 ACIONADO -- IRMS =========
     while (RD0_bit == 1 && RD1_bit == 0 && RD2_bit == 1 )
     {
     INTCON.GIE        = 0;
      ADCON0 = 0b00001001; // Ativado An1 - Canal Analógico
      ADCON1 = 0b11001001; // Verificar datasheet

      max1 =0;      min1 =99999;      ADCON0.ADON=1;      Irms = 0;
      for (i=0;i<=39;i++)           //(Somando Sinais Discretos)
      {
          vout_corrente[i] = 100.0*(115.0/15.0)*(((ADC_Read(1)*5.0/1024.0)-2.5)/0.0667);
          Irms = Irms + (vout_corrente[i]/100.0)*(vout_corrente[i]/100.0);
      }
      ADCON0.ADON=0;

      Irms = sqrt(Irms/40.0);
      floatToStr(Irms,corrente_txt);
      txt[6] = 0;
      delay_ms(400);
      Lcd_Out (3,8,corrente_txt);
     }
     //========================= BOTAO RD0 ACIONADO -- VRMS =========
     while (RD0_bit == 0 && RD1_bit == 1 && RD2_bit == 1 )
     {
     INTCON.GIE        = 0;
      ADCON0 = 0b00000001; // Ativado An0 - Canal Analógico
      ADCON1 = 0b11001001; // Verificar datasheet

      max1 =0;      min1 =999999;      ADCON0.ADON=1;      vrms =0;
      for (i=0;i<=39;i++)           //(Somando Sinais Discretos)
      {
            vet_voltage[i] = 1000.0*ADC_Read(0)*5.0/1024.0; // Leitura da porta e conversão de 0 à 5V
            vrms = vrms + (((vet_voltage[i]/500.0)-5)*109.9)*(((vet_voltage[i]/500.0)-5)*109.9);
      }
      ADCON0.ADON=0;

      vrms = sqrt(vrms/40.0);
      floatToStr(vrms,voltage_txt);
      voltage_txt[6] = 0;
      delay_ms(400);
      Lcd_Out (2,8,voltage_txt);
      } // Fim Laço Infinito

}