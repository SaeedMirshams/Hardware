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
#define STATE_MENU   1

#define STATE_CLOCK  10
#define STATE_MATEMP 20
#define STATE_MITEMP 30
#define STATE_ROTATT 40
#define STATE_ROTATP 50
#define STATE_SYCHK  60
#define STATE_ATEMP1 70
#define STATE_ATEMP2 80

#define OK 1
#define CANCEL 2
#define UP 4
#define DOWN 8


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
#define OFF   0
#define LEFT  1
#define RIGHT 2

#define ON 1

int tick;
long int clock=0;
int currentTemperature;
byte lastdirection=OFF;
byte heaterstate=OFF;

eeprom int temp1;
eeprom int temp1analog;
eeprom int temp2;
eeprom int temp2analog;
eeprom int Mintemp=0;
eeprom int Maxtemp=1;
eeprom long int rotTime=30;//15*60;
eeprom long int rotperiod=60;//3600;
flash char *MenuItems[]={
"Clock",
"Max Temperature",
"Min Temperature",
"Rotation Time",
"Rotation Period",
"System Check",
"adj Temp.1",
"adj Temp.2",
};


void translateTime(long int clock,char* timstr)
{
int day,hour,minut,second;
long int tim=clock;
second=tim%60;
  tim=tim/60;
  minut=tim%60;
  tim=tim/60;
  hour=tim%24;
  tim=tim/24;
  day=tim;
 sprintf(timstr,"%2d %2d:%2d:%2d ",day,hour,minut,second);
}

void translateTemp(int temp,char* str)
{
float degtemp= (float)(temp- temp1analog)*(temp2-temp1)/(float)(temp2analog-temp1analog)-temp1;

ftoa(degtemp,2,str);

}

void clearLine(byte i)
{
lcd_gotoxy(0,i);
lcd_putsf("                ");
lcd_gotoxy(0,i);
}


void showNormalLine1()
{
char timstr[]="99 24:60:60";
translateTime(clock,timstr);
lcd_gotoxy(0,0);
lcd_puts(timstr);

translateTemp(currentTemperature,timstr);
lcd_puts(timstr);
lcd_puts(" C");
lcd_gotoxy(0,1);

}


void showNormalLine2()
{
clearLine(1);
switch(lastdirection)
{
 case OFF:
  lcd_puts("R:OFF ");
  break;
 case LEFT:
  lcd_puts("R:LEF ");
  break;
 case RIGHT:
  lcd_puts("R:RIG ");
  break;
}

switch(heaterstate)
{
 case OFF:
  lcd_puts("H:OF ");
  break;
 case ON:
  lcd_puts("H:ON ");
  break;
}


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


void Heater(byte state)
{
 heaterstate=state;
 PORTD.1=state;
}



flash long int clockratios[]={24*3600,3600,60,1};


void turn(byte direction)
{
 if(lastdirection!=direction)
  {
    PORTD.2=0;
    PORTD.3=0;
    delay_ms(1000); 
  }
  
switch(direction)
{
 case OFF:
    PORTD.2=0;
    PORTD.3=0;
 break;
 case LEFT:
    PORTD.2=1;
    PORTD.3=0;
 break;
 case RIGHT:
    PORTD.2=0;
    PORTD.3=1;
 break;
}  
lastdirection=direction;

}

void main(void)
{
int state=STATE_NORMAL;

temp1=0;
temp1analog=0;
temp2=500;
temp2analog=1024;
Mintemp=73;
Maxtemp=75;
rotTime=30;//15*60;
rotperiod=60;//3600;



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
lcd_init(16);
// Global enable interrupts
lcd_clear();
     
#asm("sei")
 _lcd_write_data (LCD_CURSOR_OFF);
while (1)
      {
      byte key;
      byte menuindex;
      long pasang;
      char str[16];
      

      PORTD.0=!PORTD.0;
      currentTemperature=read_adc(0);
      if(currentTemperature>Maxtemp)
      {
      Heater(OFF);
      }
      else if(currentTemperature<Mintemp)
      {
      Heater(ON);
      }
      
      if(rotperiod<=0)
       rotperiod=3600;
       

     { 
       int r= clock%rotperiod;
       int d=clock/rotperiod%2;
       if(r<rotTime)
       {
        if(d==0)
         {
          turn(RIGHT);
         }
         else
         {
           turn(LEFT);
         }
       }
       else
       {
        turn(OFF);
       }
      } 
      key=readkey();
      switch(state)
      {
      case STATE_NORMAL:
       showNormalLine1();
       showNormalLine2();
       if(key==OK)
       {
       state=STATE_MENU;
       menuindex=0;        
       }
       break;
       case STATE_MENU:
        showNormalLine1();
        clearLine(1);
        lcd_putsf(MenuItems[menuindex]);
       switch(key)
       {
       case OK:
        state=10*(menuindex+1);
        menuindex=0;
        pasang=0;
        _lcd_write_data (LCD_CURSOR_ON);
        break;
        case CANCEL:
        state=STATE_NORMAL;
        _lcd_write_data (LCD_CURSOR_OFF);
        break;        
       case UP:
        if(menuindex==0)
         menuindex=7;
        else
         menuindex--;
        break;
       case DOWN:
        menuindex++;
        if(menuindex>7)
        menuindex=0;
        break;        
       }
       break;
       
       case STATE_CLOCK:
        showNormalLine1();
        clearLine(1);
        translateTime(clock+pasang,str);
        lcd_puts(str);
        lcd_gotoxy(menuindex*3+1,1);
       switch(key)
       {
       case OK:
        menuindex++;
        if(menuindex>3)
        menuindex=0;
        clock+=pasang;
        pasang=0;
        break;
        case CANCEL:
        menuindex=0;
        state=STATE_MENU;
       _lcd_write_data (LCD_CURSOR_OFF);        
        break;        
       case UP:
        pasang+=clockratios[menuindex];
        break;        
       case DOWN:
        pasang-=clockratios[menuindex];
        break;
       }
       
       break;
       case STATE_MATEMP:
        showNormalLine1();
        clearLine(1);
        translateTemp(Maxtemp+pasang,str);
        lcd_puts(str);
       switch(key)
       {
       case OK:
       if(pasang!=0)
       {
        Maxtemp+=pasang;
       }
       case CANCEL:
        state=STATE_MENU;
        menuindex=STATE_MATEMP/10-1;
        _lcd_write_data (LCD_CURSOR_OFF);        
        break;        
       case UP:
        pasang++;
        break;        
       case DOWN:
        pasang--;
        break;
       }
        
       break;

       case STATE_MITEMP:
        showNormalLine1();
        clearLine(1);
        translateTemp(Mintemp+pasang,str);
        lcd_puts(str);
       switch(key)
       {
       case OK:
       if(pasang!=0)
       {
        Mintemp+=pasang;
       }
        pasang=0;
        case CANCEL:
        state=STATE_MENU;
        menuindex=STATE_MITEMP/10-1;
        break;        
       case UP:
        pasang++;
        break;        
       case DOWN:
        pasang--;
        break;
       }
        
       break;

       case STATE_ROTATT:
        showNormalLine1();
        clearLine(1);
        translateTime(rotTime+pasang,str);
        lcd_puts(str);
        lcd_gotoxy(menuindex*3+1,1);
       switch(key)
       {
       case OK:
        menuindex++;
        if(menuindex>3)
         menuindex=0;
        if(pasang!=0)
         rotTime+=pasang;
        pasang=0;
        break;
        case CANCEL:
        menuindex=STATE_ROTATT/10-1;
        state=STATE_MENU;
        break;        
       case UP:
        pasang+=clockratios[menuindex];
        break;        
       case DOWN:
        pasang-=clockratios[menuindex];
        break;
       }
       break;
       case STATE_ROTATP:
        showNormalLine1();
        clearLine(1);
        translateTime(rotperiod+pasang,str);
        lcd_puts(str);
        lcd_gotoxy(menuindex*3+1,1);
       switch(key)
       {
       case OK:
        menuindex++;
        if(menuindex>3)
         menuindex=0;
        if(pasang!=0)
         rotperiod+=pasang;
        pasang=0;
        break;
        case CANCEL:
        menuindex=STATE_ROTATP/10-1;
        state=STATE_MENU;
        break;        
       case UP:
        pasang+=clockratios[menuindex];
        break;        
       case DOWN:
        pasang-=clockratios[menuindex];
        break;
       }
       break;
       
       case STATE_SYCHK:
        PORTD=0;
        clearLine(1);
        clearLine(0);
        lcd_puts("OK or CANCEL");
       switch(key)
       {
       case OK:
        clearLine(0);
        lcd_puts("Heater ON");
        Heater(ON);
        delay_ms(10000);
        clearLine(0);
        lcd_puts("Heater OFF");
        Heater(OFF);
        delay_ms(10000);
        clearLine(0);
        lcd_puts("rotation Left");
        turn(LEFT);
        delay_ms(10000);
        clearLine(0);
        lcd_puts("rotation Right");
        turn(RIGHT);
        delay_ms(10000);
        clearLine(0);
        lcd_puts("rotation Off");
        turn(OFF);
        delay_ms(10000);
        
        case CANCEL:
        menuindex=STATE_SYCHK/10-1;
        state=STATE_MENU;
        break;        
       case UP:
        lcd_gotoxy(0,0);
        lcd_puts("Invalid key");
        break;        
       case DOWN:
        lcd_gotoxy(0,0);
        lcd_puts("Invalid key");
        break;
       }
       break;
       
       case STATE_ATEMP1:
        showNormalLine1();
        clearLine(1);
        itoa(temp1+(menuindex==0?pasang:0),str);
        lcd_puts(str);  
        
        lcd_gotoxy(8,1);
        itoa(temp1analog+(menuindex==1?pasang:0),str);
        lcd_puts(str);
        lcd_gotoxy(menuindex*8,1);
       switch(key)
       {
       case OK:
        if(pasang!=0)
        {
         if(menuindex==0)
          temp1 +=pasang;
         else
          temp1analog +=pasang;
        }
        menuindex++;
        if(menuindex>1)
         menuindex=0;
        pasang=0;
        break;
        case CANCEL:
        menuindex=STATE_ATEMP1/10-1;
        state=STATE_MENU;
        break;        
       case UP:
        pasang++;
        break;        
       case DOWN:
        pasang--;
        break;
       }
       break;
       case STATE_ATEMP2:
        showNormalLine1();
        clearLine(1);
        itoa(temp2+(menuindex==0?pasang:0),str);
        lcd_puts(str);  
        
        lcd_gotoxy(8,1);
        itoa(temp2analog+(menuindex==1?pasang:0),str);
        lcd_puts(str);
        lcd_gotoxy(menuindex*8,1);
       switch(key)
       {
       case OK:
        if(pasang!=0)
        {
         if(menuindex==0)
          temp2 +=pasang;
         else
          temp2analog +=pasang;
        }
        menuindex++;
        if(menuindex>1)
         menuindex=0;
        pasang=0;
        break;
        case CANCEL:
        menuindex=STATE_ATEMP1/10-1;
        state=STATE_MENU;
        break;        
       case UP:
        pasang++;
        break;        
       case DOWN:
        pasang--;
        break;
       }
       break;
       
       default:
      }

      delay_ms(200);
      }
}
