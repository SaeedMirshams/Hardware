/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
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

#include <delay.h>

// Alphanumeric LCD functions
#include <alcd.h>

#define STATE_NORMAL 0

typedef unsigned char byte;

// table for the user defined character
// arrow that points to the top right corner
flash byte char_table[6][8]={
{
0b10000000,
0b10000000,
0b10000000,
0b10000000,
0b10000000,
0b10000000,
0b10010101,
0b10111111
},{
0b10000000,
0b11111111,
0b10001110,
0b10000100,
0b10000000,
0b10000000,
0b10000000,
0b10000000
},{
0b10000000,
0b10000000,
0b11111111,
0b10001110,
0b10000100,
0b10000000,
0b10000000,
0b10000000
},{
0b10000000,
0b10000000,
0b10000000,
0b11111111,
0b10001110,
0b10000100,
0b10000000,
0b10000000
},{
0b10000000,
0b10000000,
0b10000000,
0b10000000,
0b11111111,
0b10001110,
0b10000100,
0b10000000
}
}
;

void showNormal()
{
lcd_puts("Normal");
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
TCNT0=0x27;

}


int test()
{
return 100;
}

// function used to define user characters
void define_char(byte flash *pc,byte char_code)
{
byte i,address;
address=(char_code<<3)|0x40;
for (i=0; i<8; i++) lcd_write_byte(address++,*pc++);
}


#define ADC_VREF_TYPE 0x40

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

long int clock=0;
eeprom long int start_date=0;
eeprom int temp1=0;
eeprom int temp1analog=0;
eeprom int temp2=10;
eeprom int temp2analog=2048;

int readkey()
{


return PINC;
}


void main(void)
{
int i;
int state=STATE_NORMAL;
// Input/Output Ports initialization
// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=T State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xF7;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

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
#asm("sei")

for(i=0;i<32;i++)
{
 define_char(char_table[i%6],i);
}
while (1)
      { 
      i++;
      if(i>50)
      i=0;
      PORTD.0=0;
      delay_ms(500);
      switch(state)
      {
      case STATE_NORMAL:
       showNormal();
       break;
       default:
       
      }
      
      lcd_gotoxy(0,0);
      lcd_puts("SALAM");
        lcd_putchar(i);
      //for(i=0;i<100;i++)      

      PORTD.0=1;
      delay_ms(500);
      }
}
