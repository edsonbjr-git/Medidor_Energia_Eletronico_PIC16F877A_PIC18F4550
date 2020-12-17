 // LCD module connections
sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D4 at RB4_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D7 at RB7_bit;

sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;
// End LCD module connections


unsigned int i = 0;
float voltage=0, aux = 0, soma=0, max1=0, min1=1000;
int vout_corrente[40];
float Irms =0;
float valor_final=0;
unsigned char txt[8];
float raiz;

void main()
{

  TRISA = 0XFF;// All input
  TRISB = 0X00;
  PORTB = 0;
  TRISB0_bit = 1;//set as input
  TRISB1_bit = 1;//set as input

  // ADC initialization...
  ADCON0 = 0x00;// AN0 analog input
  ADCON1 = 0xF0;
  //ADCON1 = 0b11110000;

  // Initialize LCD configuration...
  Lcd_Init();         
  delay_ms(25);
  Lcd_Cmd(_LCD_CLEAR);
   delay_ms(25);               // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
  delay_ms(25);
  Lcd_Out(1,1,"I RMS");
   delay_ms(25);
  Lcd_Out(2,1,"Irms=");

     // inicializa o UART
   //  UART1_Init(19200);
while (1)
{ //  Inicio Laço Infinito
        max1 =0;
        min1 =99999;
        ADCON0.ADON=1;
        Irms = 0;
             for (i=0;i<=39;i++)           //(Somando Sinais Discretos)
            {
                  vout_corrente[i] = 100.0*(115.0/15.0)*(((ADC_Read(0)*5.0/1024.0)-2.5)/0.0667);
                  Irms = Irms + (vout_corrente[i]/100.0)*(vout_corrente[i]/100.0);
        }
         ADCON0.ADON=0;


      Irms = sqrt(Irms/40.0);
      //vrms = sqrt(((((soma/500.0)-5)*77.71106*1.414214))/40.0);
      //  quant = quant +1;
      floatToStr(Irms,txt);
      txt[6] = 0;
      delay_ms(200);
      Lcd_Out (2,6,txt);
      } // Fim Laço Infinito
}