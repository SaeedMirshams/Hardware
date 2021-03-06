/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
� Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 12/19/2016
Author  : Saeed
Company : 
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 1.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>
#include <stdlib.h>
#include <string.h>

#include <delay.h>

#define ADC_VREF_TYPE 0x00

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;    
}

#define Disp1 PORTC.2
#define Disp2 PORTC.3
#define Disp3 PORTC.4
#define Disp4 PORTC.5

int translate(char x)
{
int result=0x0;

switch(x){
case '0':
  result=0x3F;
break;
case '1':
 result=0x06;
 break;
case '2':
 result=0x5B;
 break;
case '3':
 result=0x4F;
 break;
case '4':
 result=0x66;
 break;
case '5':
 result=0x6D;
 break;
case '6':
 result=0x7D;
 break;
case '7':
 result=0x07;
 break;
case '8':
 result=0x7F;
 break;
case '9':
 result=0x6F;
 break;
}

return result;
}

void displayData(char* number)
{
int v=0;

Disp1=0;
v=translate(number[0]);
PORTB=v;
delay_ms(10);
Disp1=1;

Disp2=0;
v=translate(number[1]);
PORTB=v;
PORTB.7=1;
delay_ms(10);
Disp2=1;

Disp3=0;
v=translate(number[2]);
PORTB=v;
delay_ms(10);
Disp3=1;

Disp4=0;
v=translate(number[3]);
PORTB=v;
delay_ms(10);
Disp4=1;


return;
}

// Declare your global variables here

void main(void)
{
      char str[10]={'1','2','3','4','5','6',' ',' ',' ','\0'};
      int value=0;

// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0xFF;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x3C;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0 
PORTD=0x00;
DDRD=0x0F;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 500.000 kHz
// ADC Voltage Reference: AREF pin
ADMUX=ADC_VREF_TYPE & 0xff;

ADCSRA=0x81;
ADCSRA = (1<<ADEN) | (1<<ADPS2) | (1<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

while (1)
      {
      // Place your code here
      
      long k=read_adc(1);
      long l= k * 50000;
      value= l >> 10 ;
      if(value>3800)
       PORTD.0=0;
      else
      if(value<3600)
      {
       PORTD.0=1;
       }
      
        itoa(value,str);
        while(strlen(str)<4)
        {
         str[3]=str[2];
         str[2]=str[1];
         str[1]=str[0];
         str[0]='0';
        }
        
       
        displayData(str );
        PORTD.1=1-PIND.1;
        

      }
}
