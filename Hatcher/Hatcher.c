/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
� Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Hatcher
Version : 1.0
Date    : 2017/1/25
Author  : Saeed
Company : Mirshams
Comments: 
For Hatching


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>
#include <stdio.h>
#include <stdlib.h>

#include <delay.h>

// Alphanumeric LCD functions
#include <alcd.h>

#define STATE_NORMAL 0

typedef unsigned char byte;
/*

// table for the user defined character
// arrow that points to the top right corner
flash byte char_table[]={
0b10000000,
0b10000000,
0b10000000,
0b10000000,
0b10000000,
0b10010101,
0b10111111,
0b10000000
};
// function used to define user characters
void define_char(byte flash *pc,byte char_code)
{
byte i,address;
address=(char_code<<3)|0x40;
for (i=0; i<8; i++) lcd_write_byte(address++,*pc++);
}
*/
int tick;
long int clock=0;
int currentTemperature;
eeprom long int start_date=0;
eeprom int temp1;
eeprom int temp1analog;
eeprom int temp2;
eeprom int temp2analog;
eeprom int Mintemp=36;
eeprom int Maxtemp=37;

void showNormal()
{
int day,hour,minut,second;
int tim=clock;
float degtemp=0.0;
char timstr[]="99 24:60:60";
second=tim%60;
  tim=tim/60;
  minut=tim%60;
  tim=tim/60;
  hour=tim%24;
  tim=tim/24;
  day=tim;
degtemp= (float)(currentTemperature- temp1analog)*(temp2-temp1)/(float)(temp2analog-temp1analog)-temp1;

sprintf(timstr,"%2d %2d:%2d:%2d ",day,hour,minut,second);

lcd_gotoxy(0,0);
lcd_puts(timstr);

ftoa(degtemp,2,timstr);
lcd_puts(timstr);
lcd_puts(" C");
lcd_gotoxy(0,1);

}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
 tick++;
 if(tick>18)
 {
   tick-=18;
   clock++;
 }
 TCNT0=0x27;
}



#define ADC_VREF_TYPE 0x40

#define	LCD_CONTROL	0x08
#define	LCD_DISPLAY	0x04
#define	LCD_CURSOR	0x02
#define	LCD_BLINK	0x01

#define	LCD_CURSOR_ON	(LCD_CONTROL | LCD_DISPLAY | LCD_CURSOR | LCD_BLINK)
#define	LCD_CURSOR_OFF	(LCD_CONTROL | LCD_DISPLAY)

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

// Declare your global variables here


int lastkey=15;
byte readkey()
{
byte result=0;
byte newkey = ~(PINC>>3)&0b00001111;
if(newkey==lastkey)
{
 result=0;
}
else
{
 result=newkey;
}
lastkey=newkey;
return result;
}


void main(void)
{
int state=STATE_NORMAL;

start_date=0;
temp1=0;
temp1analog=0;
temp2=500;
temp2analog=1024;


// Input/Output Ports initialization
// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=T State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xF7;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=(1 << 6) | (1 << 5) | (1 << 4) | (1 << 3);
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0xFF;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 3.906 kHz
TCCR0=0x05;
TCNT0=0x27;

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
TIMSK=0x01;

// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AVCC pin
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x82;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTB Bit 0
// RD - PORTB Bit 1
// EN - PORTB Bit 2
// D4 - PORTB Bit 4
// D5 - PORTB Bit 5
// D6 - PORTB Bit 6
// D7 - PORTB Bit 7
// Characters/line: 16
lcd_init(16*2);
// Global enable interrupts
lcd_clear();
_lcd_write_data (LCD_CURSOR_ON);
     
      
#asm("sei")

while (1)
      {
      int key;
      char str[]="00000000";
      currentTemperature=read_adc(0); 
      PORTD.0=!PORTD.0;
      
      switch(state)
      {
      case STATE_NORMAL:
       showNormal();
       break;
       default:
      }       
      key=readkey();
      sprintf(str,"%x",key);
      lcd_gotoxy(10,1);
      lcd_puts(str);
      lcd_puts("   ");
      delay_ms(500);
      }
}
