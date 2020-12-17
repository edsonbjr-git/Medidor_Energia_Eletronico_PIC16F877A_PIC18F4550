#line 1 "C:/Users/edson/Documents/AULAS_PROTEUS/______PROJETO_FINAL/Completo/codigo/codigo_final.c"






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



unsigned char FlagReg;
sbit ZC at FlagReg.B0;
char txt[8];
unsigned int t_counter =0, tempo_counter =0, t_counter_final =0;
float tempo_total = 0;
float final_total = 0;
float freq = 0;


unsigned int i = 0;

int vout_corrente[40];
float Irms =0;

unsigned char corrente_txt[8];




unsigned int quant = 0, max1=0, min1=999999;
unsigned int vet_voltage[40];
float voltage = 0;
float vrms =0;
unsigned char voltage_txt[8];


void interrupt()
{

 if(INTCON.TMR0IF)
 {
 t_counter++;
 INTCON.TMR0IF = 0;
 TMR0=0;
 }


 if (INTCON.INTF)
 {
 tempo_total += t_counter*(256 - TMR0)*4*4/20000000.0;
 tempo_counter++;

 if(tempo_counter == 150)
 {
 final_total = tempo_total/20.0;
 tempo_counter =0;
 t_counter_final = t_counter;
 t_counter = 0;
 }
 INTCON.INTF = 0;
 }
}


void main()
{
 PORTB = 0;
 TRISB = 0x01;
 PORTD = 0;
 TRISD = 0;
 TRISD.TRISD0 = 1;
 TRISD.TRISD1 = 1;
 TRISD.TRISD2 = 1;
 OPTION_REG.INTEDG = 0;


 OPTION_REG.T0CS = 0;
 OPTION_REG.T0SE = 0;
 OPTION_REG.PSA = 0;
 OPTION_REG.PS2 = 0;
 OPTION_REG.PS1 = 0;
 OPTION_REG.PS0 = 1;
 OPTION_REG.NOT_RBPU = 1;

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 delay_us(500);
 Lcd_Out(1,1,"MEDIDOR ELETRONICO");
 Lcd_Out(2,1,"Vrms=");
 delay_us(500);
 Lcd_Out(3,1,"Irms=");
 Lcd_Out(4,1,"FREQ:");
 Lcd_Out(4,12,"hz");
 delay_us(500);



 INTCON.GIE = 1;
 INTCON.PEIE = 1;
 INTCON.TMR0IE = 1;
 INTCON.INTE = 1;
 INTCON.TMR0IF = 0;
 INTCON.INTF = 0;

 TMR0 = 0;

 while (RD0_bit == 1 && RD1_bit == 1 && RD2_bit == 0 )
 {
 INTCON.GIE = 0;
 freq = (1.0/((t_counter_final/150.0)*(256 -0)*4*4/20000000.0));

 if(freq <100 && freq >30)
 {
 floatToStr(freq,txt);
 t_counter_final=0;
 txt[5] = 0;
 delay_ms(400);
 Lcd_Out(4,6,txt);
 }
 }

 while (RD0_bit == 1 && RD1_bit == 0 && RD2_bit == 1 )
 {
 INTCON.GIE = 0;
 ADCON0 = 0b00001001;
 ADCON1 = 0b11001001;

 max1 =0; min1 =99999; ADCON0.ADON=1; Irms = 0;
 for (i=0;i<=39;i++)
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

 while (RD0_bit == 0 && RD1_bit == 1 && RD2_bit == 1 )
 {
 INTCON.GIE = 0;
 ADCON0 = 0b00000001;
 ADCON1 = 0b11001001;

 max1 =0; min1 =999999; ADCON0.ADON=1; vrms =0;
 for (i=0;i<=39;i++)
 {
 vet_voltage[i] = 1000.0*ADC_Read(0)*5.0/1024.0;
 vrms = vrms + (((vet_voltage[i]/500.0)-5)*109.9)*(((vet_voltage[i]/500.0)-5)*109.9);
 }
 ADCON0.ADON=0;

 vrms = sqrt(vrms/40.0);
 floatToStr(vrms,voltage_txt);
 voltage_txt[6] = 0;
 delay_ms(400);
 Lcd_Out (2,8,voltage_txt);
 }

}
