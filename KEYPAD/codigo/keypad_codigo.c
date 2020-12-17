void main() 
{
PORTD =0x00;
//TRISD = 0xFF;  // portas como entradas
TRISD.TRISD1 = 1;
TRISD.TRISD2 = 1;
TRISD.TRISD0 = 1;

UART1_Init(19200);
while(1)
{
        while(RD0_bit ==0)
        {
        delay_ms(1000);
        UART1_Write_Text(" TESTE");
        UART1_Write(13);
        
        }
        delay_ms(1000);
        UART1_Write_Text(" BIT ==1");
        UART1_Write(13);
}

}