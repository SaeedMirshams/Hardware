
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _tick=R4
	.DEF _currentTemperature=R6
	.DEF _lastdirection=R9
	.DEF _heaterstate=R8
	.DEF _lastkey=R10
	.DEF __lcd_x=R13
	.DEF __lcd_y=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_clockratios:
	.DB  0x80,0x51,0x1,0x0,0x10,0xE,0x0,0x0
	.DB  0x3C,0x0,0x0,0x0,0x1,0x0,0x0,0x0
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  LOW(_0x0*2),HIGH(_0x0*2),LOW(_0x0*2+6),HIGH(_0x0*2+6),LOW(_0x0*2+22),HIGH(_0x0*2+22),LOW(_0x0*2+38),HIGH(_0x0*2+38)
	.DB  LOW(_0x0*2+52),HIGH(_0x0*2+52),LOW(_0x0*2+68),HIGH(_0x0*2+68),LOW(_0x0*2+81),HIGH(_0x0*2+81),LOW(_0x0*2+92),HIGH(_0x0*2+92)
_0x4:
	.DB  0x39,0x39,0x20,0x32,0x34,0x3A,0x36,0x30
	.DB  0x3A,0x36,0x30,0x0
_0xBE:
	.DB  0x0,0x0,0xF,0x0
_0x0:
	.DB  0x43,0x6C,0x6F,0x63,0x6B,0x0,0x4D,0x61
	.DB  0x78,0x20,0x54,0x65,0x6D,0x70,0x65,0x72
	.DB  0x61,0x74,0x75,0x72,0x65,0x0,0x4D,0x69
	.DB  0x6E,0x20,0x54,0x65,0x6D,0x70,0x65,0x72
	.DB  0x61,0x74,0x75,0x72,0x65,0x0,0x52,0x6F
	.DB  0x74,0x61,0x74,0x69,0x6F,0x6E,0x20,0x54
	.DB  0x69,0x6D,0x65,0x0,0x52,0x6F,0x74,0x61
	.DB  0x74,0x69,0x6F,0x6E,0x20,0x50,0x65,0x72
	.DB  0x69,0x6F,0x64,0x0,0x53,0x79,0x73,0x74
	.DB  0x65,0x6D,0x20,0x43,0x68,0x65,0x63,0x6B
	.DB  0x0,0x61,0x64,0x6A,0x20,0x54,0x65,0x6D
	.DB  0x70,0x2E,0x31,0x0,0x61,0x64,0x6A,0x20
	.DB  0x54,0x65,0x6D,0x70,0x2E,0x32,0x0,0x25
	.DB  0x32,0x64,0x20,0x25,0x32,0x64,0x3A,0x25
	.DB  0x32,0x64,0x3A,0x25,0x32,0x64,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x43,0x0,0x52,0x3A,0x4F,0x46
	.DB  0x46,0x20,0x0,0x52,0x3A,0x4C,0x45,0x46
	.DB  0x20,0x0,0x52,0x3A,0x52,0x49,0x47,0x20
	.DB  0x0,0x48,0x3A,0x4F,0x46,0x20,0x0,0x48
	.DB  0x3A,0x4F,0x4E,0x20,0x0,0x4F,0x4B,0x20
	.DB  0x6F,0x72,0x20,0x43,0x41,0x4E,0x43,0x45
	.DB  0x4C,0x0,0x48,0x65,0x61,0x74,0x65,0x72
	.DB  0x20,0x4F,0x4E,0x0,0x48,0x65,0x61,0x74
	.DB  0x65,0x72,0x20,0x4F,0x46,0x46,0x0,0x72
	.DB  0x6F,0x74,0x61,0x74,0x69,0x6F,0x6E,0x20
	.DB  0x4C,0x65,0x66,0x74,0x0,0x72,0x6F,0x74
	.DB  0x61,0x74,0x69,0x6F,0x6E,0x20,0x52,0x69
	.DB  0x67,0x68,0x74,0x0,0x72,0x6F,0x74,0x61
	.DB  0x74,0x69,0x6F,0x6E,0x20,0x4F,0x66,0x66
	.DB  0x0,0x49,0x6E,0x76,0x61,0x6C,0x69,0x64
	.DB  0x20,0x6B,0x65,0x79,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2040003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x10
	.DW  _MenuItems
	.DW  _0x3*2

	.DW  0x03
	.DW  _0x5
	.DW  _0x0*2+137

	.DW  0x07
	.DW  _0xA
	.DW  _0x0*2+140

	.DW  0x07
	.DW  _0xA+7
	.DW  _0x0*2+147

	.DW  0x07
	.DW  _0xA+14
	.DW  _0x0*2+154

	.DW  0x06
	.DW  _0xA+21
	.DW  _0x0*2+161

	.DW  0x06
	.DW  _0xA+27
	.DW  _0x0*2+167

	.DW  0x0D
	.DW  _0x80
	.DW  _0x0*2+173

	.DW  0x0A
	.DW  _0x80+13
	.DW  _0x0*2+186

	.DW  0x0B
	.DW  _0x80+23
	.DW  _0x0*2+196

	.DW  0x0E
	.DW  _0x80+34
	.DW  _0x0*2+207

	.DW  0x0F
	.DW  _0x80+48
	.DW  _0x0*2+221

	.DW  0x0D
	.DW  _0x80+63
	.DW  _0x0*2+236

	.DW  0x0C
	.DW  _0x80+76
	.DW  _0x0*2+249

	.DW  0x0C
	.DW  _0x80+88
	.DW  _0x0*2+249

	.DW  0x04
	.DW  0x08
	.DW  _0xBE*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : Hatcher
;Version : 1.0
;Date    : 2017/1/25
;Author  : Saeed
;Company : Mirshams
;Comments:
;For Hatching
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include <stdlib.h>
;
;#include <delay.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;#define STATE_NORMAL 0
;#define STATE_MENU   1
;
;#define STATE_CLOCK  10
;#define STATE_MATEMP 20
;#define STATE_MITEMP 30
;#define STATE_ROTATT 40
;#define STATE_ROTATP 50
;#define STATE_SYCHK  60
;#define STATE_ATEMP1 70
;#define STATE_ATEMP2 80
;
;#define OK 1
;#define CANCEL 2
;#define UP 4
;#define DOWN 8
;
;
;typedef unsigned char byte;
;/*
;
;// table for the user defined character
;// arrow that points to the top right corner
;flash byte char_table[]={
;0b10000000,
;0b10000000,
;0b10000000,
;0b10000000,
;0b10000000,
;0b10010101,
;0b10111111,
;0b10000000
;};
;// function used to define user characters
;void define_char(byte flash *pc,byte char_code)
;{
;byte i,address;
;address=(char_code<<3)|0x40;
;for (i=0; i<8; i++) lcd_write_byte(address++,*pc++);
;}
;*/
;#define OFF   0
;#define LEFT  1
;#define RIGHT 2
;
;#define ON 1
;
;int tick;
;long int clock=0;
;int currentTemperature;
;byte lastdirection=OFF;
;byte heaterstate=OFF;
;
;eeprom int temp1;
;eeprom int temp1analog;
;eeprom int temp2;
;eeprom int temp2analog;
;eeprom int Mintemp=0;
;eeprom int Maxtemp=1;
;eeprom long int rotTime=30;//15*60;
;eeprom long int rotperiod=60;//3600;
;flash char *MenuItems[]={
;"Clock",
;"Max Temperature",
;"Min Temperature",
;"Rotation Time",
;"Rotation Period",
;"System Check",
;"adj Temp.1",
;"adj Temp.2",
;};

	.DSEG
;
;
;void translateTime(long int clock,char* timstr)
; 0000 006C {

	.CSEG
_translateTime:
; 0000 006D int day,hour,minut,second;
; 0000 006E long int tim=clock;
; 0000 006F second=tim%60;
	RCALL SUBOPT_0x0
	SBIW R28,6
	RCALL __SAVELOCR6
;	clock -> Y+14
;	*timstr -> Y+12
;	day -> R16,R17
;	hour -> R18,R19
;	minut -> R20,R21
;	second -> Y+10
;	tim -> Y+6
	__GETD1S 14
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
; 0000 0070   tim=tim/60;
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x1
; 0000 0071   minut=tim%60;
	MOVW R20,R30
; 0000 0072   tim=tim/60;
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
; 0000 0073   hour=tim%24;
	RCALL SUBOPT_0x5
	RCALL __MODD21
	MOVW R18,R30
; 0000 0074   tim=tim/24;
	RCALL SUBOPT_0x5
	RCALL __DIVD21
	RCALL SUBOPT_0x4
; 0000 0075   day=tim;
	__GETWRS 16,17,6
; 0000 0076  sprintf(timstr,"%2d %2d:%2d:%2d ",day,hour,minut,second);
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	RCALL SUBOPT_0x6
	__POINTW1FN _0x0,103
	RCALL SUBOPT_0x6
	MOVW R30,R16
	RCALL SUBOPT_0x7
	MOVW R30,R18
	RCALL SUBOPT_0x7
	MOVW R30,R20
	RCALL SUBOPT_0x7
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	RCALL SUBOPT_0x7
	LDI  R24,16
	RCALL _sprintf
	ADIW R28,20
; 0000 0077 }
	RCALL __LOADLOCR6
	ADIW R28,18
	RET
;
;void translateTemp(int temp,char* str)
; 0000 007A {
_translateTemp:
; 0000 007B float degtemp= (float)(temp- temp1analog)*(temp2-temp1)/(float)(temp2analog-temp1analog)-temp1;
; 0000 007C 
; 0000 007D ftoa(degtemp,2,str);
	RCALL SUBOPT_0x0
	SBIW R28,4
;	temp -> Y+6
;	*str -> Y+4
;	degtemp -> Y+0
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RCALL __SWAPW12
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
	MOVW R26,R30
	MOVW R30,R0
	RCALL SUBOPT_0xA
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0xB
	RCALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x8
	MOVW R26,R30
	MOVW R30,R0
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xE
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0xB
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	RCALL __PUTPARD1
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	RCALL _ftoa
; 0000 007E 
; 0000 007F }
	ADIW R28,8
	RET
;
;void clearLine(byte i)
; 0000 0082 {
_clearLine:
; 0000 0083 lcd_gotoxy(0,i);
	ST   -Y,R26
;	i -> Y+0
	RCALL SUBOPT_0x12
; 0000 0084 lcd_putsf("                ");
	__POINTW2FN _0x0,120
	RCALL _lcd_putsf
; 0000 0085 lcd_gotoxy(0,i);
	RCALL SUBOPT_0x12
; 0000 0086 }
	RJMP _0x20C0002
;
;
;void showNormalLine1()
; 0000 008A {
_showNormalLine1:
; 0000 008B char timstr[]="99 24:60:60";
; 0000 008C translateTime(clock,timstr);
	SBIW R28,12
	LDI  R24,12
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x4*2)
	LDI  R31,HIGH(_0x4*2)
	RCALL __INITLOCB
;	timstr -> Y+0
	LDS  R30,_clock
	LDS  R31,_clock+1
	LDS  R22,_clock+2
	LDS  R23,_clock+3
	RCALL SUBOPT_0x13
; 0000 008D lcd_gotoxy(0,0);
	RCALL SUBOPT_0x14
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 008E lcd_puts(timstr);
	RCALL SUBOPT_0x15
; 0000 008F 
; 0000 0090 translateTemp(currentTemperature,timstr);
	ST   -Y,R7
	ST   -Y,R6
	RCALL SUBOPT_0x16
; 0000 0091 lcd_puts(timstr);
; 0000 0092 lcd_puts(" C");
	__POINTW2MN _0x5,0
	RCALL _lcd_puts
; 0000 0093 lcd_gotoxy(0,1);
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x17
; 0000 0094 
; 0000 0095 }
	ADIW R28,12
	RET

	.DSEG
_0x5:
	.BYTE 0x3
;
;
;void showNormalLine2()
; 0000 0099 {

	.CSEG
_showNormalLine2:
; 0000 009A clearLine(1);
	RCALL SUBOPT_0x18
; 0000 009B switch(lastdirection)
	MOV  R30,R9
	RCALL SUBOPT_0x19
; 0000 009C {
; 0000 009D  case OFF:
	BRNE _0x9
; 0000 009E   lcd_puts("R:OFF ");
	__POINTW2MN _0xA,0
	RJMP _0xAF
; 0000 009F   break;
; 0000 00A0  case LEFT:
_0x9:
	RCALL SUBOPT_0x1A
	BRNE _0xB
; 0000 00A1   lcd_puts("R:LEF ");
	__POINTW2MN _0xA,7
	RJMP _0xAF
; 0000 00A2   break;
; 0000 00A3  case RIGHT:
_0xB:
	RCALL SUBOPT_0x1B
	BRNE _0x8
; 0000 00A4   lcd_puts("R:RIG ");
	__POINTW2MN _0xA,14
_0xAF:
	RCALL _lcd_puts
; 0000 00A5   break;
; 0000 00A6 }
_0x8:
; 0000 00A7 
; 0000 00A8 switch(heaterstate)
	MOV  R30,R8
	RCALL SUBOPT_0x19
; 0000 00A9 {
; 0000 00AA  case OFF:
	BRNE _0x10
; 0000 00AB   lcd_puts("H:OF ");
	__POINTW2MN _0xA,21
	RJMP _0xB0
; 0000 00AC   break;
; 0000 00AD  case ON:
_0x10:
	RCALL SUBOPT_0x1A
	BRNE _0xF
; 0000 00AE   lcd_puts("H:ON ");
	__POINTW2MN _0xA,27
_0xB0:
	RCALL _lcd_puts
; 0000 00AF   break;
; 0000 00B0 }
_0xF:
; 0000 00B1 
; 0000 00B2 
; 0000 00B3 }
	RET

	.DSEG
_0xA:
	.BYTE 0x21
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 00B8 {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00B9  tick++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 00BA  if(tick>18)
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x12
; 0000 00BB  {
; 0000 00BC    tick-=18;
	MOVW R30,R4
	SBIW R30,18
	MOVW R4,R30
; 0000 00BD    clock++;
	LDI  R26,LOW(_clock)
	LDI  R27,HIGH(_clock)
	RCALL __GETD1P_INC
	RCALL SUBOPT_0x1C
	RCALL __PUTDP1_DEC
; 0000 00BE  }
; 0000 00BF  TCNT0=0x27;
_0x12:
	LDI  R30,LOW(39)
	OUT  0x32,R30
; 0000 00C0 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
;
;
;
;#define ADC_VREF_TYPE 0x40
;
;#define	LCD_CONTROL	0x08
;#define	LCD_DISPLAY	0x04
;#define	LCD_CURSOR	0x02
;#define	LCD_BLINK	0x01
;
;#define	LCD_CURSOR_ON	(LCD_CONTROL | LCD_DISPLAY | LCD_CURSOR | LCD_BLINK)
;#define	LCD_CURSOR_OFF	(LCD_CONTROL | LCD_DISPLAY)
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 00D0 {
_read_adc:
; 0000 00D1 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 00D2 // Delay needed for the stabilization of the ADC input voltage
; 0000 00D3 delay_us(10);
	__DELAY_USB 27
; 0000 00D4 // Start the AD conversion
; 0000 00D5 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 00D6 // Wait for the AD conversion to complete
; 0000 00D7 while ((ADCSRA & 0x10)==0);
_0x13:
	SBIS 0x6,4
	RJMP _0x13
; 0000 00D8 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 00D9 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x20C0002
; 0000 00DA }
;
;
;// Declare your global variables here
;
;
;int lastkey=15;
;byte readkey()
; 0000 00E2 {
_readkey:
; 0000 00E3 byte result=0;
; 0000 00E4 byte newkey = ~(PINC>>3)&0b00001111;
; 0000 00E5 if(newkey==lastkey)
	RCALL __SAVELOCR2
;	result -> R17
;	newkey -> R16
	LDI  R17,0
	IN   R30,0x13
	RCALL SUBOPT_0x1D
	RCALL __ASRW3
	COM  R30
	ANDI R30,LOW(0xF)
	MOV  R16,R30
	MOVW R30,R10
	MOV  R26,R16
	RCALL SUBOPT_0x1E
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x16
; 0000 00E6 {
; 0000 00E7  result=0;
	LDI  R17,LOW(0)
; 0000 00E8 }
; 0000 00E9 else
	RJMP _0x17
_0x16:
; 0000 00EA {
; 0000 00EB  result=newkey;
	MOV  R17,R16
; 0000 00EC }
_0x17:
; 0000 00ED lastkey=newkey;
	MOV  R10,R16
	CLR  R11
; 0000 00EE return result;
	MOV  R30,R17
	RCALL __LOADLOCR2P
	RET
; 0000 00EF }
;
;
;void Heater(byte state)
; 0000 00F3 {
_Heater:
; 0000 00F4  heaterstate=state;
	ST   -Y,R26
;	state -> Y+0
	LDD  R8,Y+0
; 0000 00F5  PORTD.1=state;
	LD   R30,Y
	CPI  R30,0
	BRNE _0x18
	CBI  0x12,1
	RJMP _0x19
_0x18:
	SBI  0x12,1
_0x19:
; 0000 00F6 }
	RJMP _0x20C0002
;
;
;
;flash long int clockratios[]={24*3600,3600,60,1};
;
;
;void turn(byte direction)
; 0000 00FE {
_turn:
; 0000 00FF  if(lastdirection!=direction)
	ST   -Y,R26
;	direction -> Y+0
	LD   R30,Y
	CP   R30,R9
	BREQ _0x1A
; 0000 0100   {
; 0000 0101     PORTD.2=0;
	CBI  0x12,2
; 0000 0102     PORTD.3=0;
	CBI  0x12,3
; 0000 0103     delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0104   }
; 0000 0105 
; 0000 0106 switch(direction)
_0x1A:
	LD   R30,Y
	RCALL SUBOPT_0x19
; 0000 0107 {
; 0000 0108  case OFF:
	BRNE _0x22
; 0000 0109     PORTD.2=0;
	CBI  0x12,2
; 0000 010A     PORTD.3=0;
	CBI  0x12,3
; 0000 010B  break;
	RJMP _0x21
; 0000 010C  case LEFT:
_0x22:
	RCALL SUBOPT_0x1A
	BRNE _0x27
; 0000 010D     PORTD.2=1;
	SBI  0x12,2
; 0000 010E     PORTD.3=0;
	CBI  0x12,3
; 0000 010F  break;
	RJMP _0x21
; 0000 0110  case RIGHT:
_0x27:
	RCALL SUBOPT_0x1B
	BRNE _0x21
; 0000 0111     PORTD.2=0;
	CBI  0x12,2
; 0000 0112     PORTD.3=1;
	SBI  0x12,3
; 0000 0113  break;
; 0000 0114 }
_0x21:
; 0000 0115 lastdirection=direction;
	LDD  R9,Y+0
; 0000 0116 
; 0000 0117 }
	RJMP _0x20C0002
;
;void main(void)
; 0000 011A {
_main:
; 0000 011B int state=STATE_NORMAL;
; 0000 011C 
; 0000 011D temp1=0;
;	state -> R16,R17
	__GETWRN 16,17,0
	LDI  R26,LOW(_temp1)
	LDI  R27,HIGH(_temp1)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL __EEPROMWRW
; 0000 011E temp1analog=0;
	LDI  R26,LOW(_temp1analog)
	LDI  R27,HIGH(_temp1analog)
	RCALL SUBOPT_0x1F
	RCALL __EEPROMWRW
; 0000 011F temp2=500;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL __EEPROMWRW
; 0000 0120 temp2analog=1024;
	RCALL SUBOPT_0xF
	LDI  R30,LOW(1024)
	LDI  R31,HIGH(1024)
	RCALL __EEPROMWRW
; 0000 0121 Mintemp=73;
	RCALL SUBOPT_0x20
	LDI  R30,LOW(73)
	LDI  R31,HIGH(73)
	RCALL __EEPROMWRW
; 0000 0122 Maxtemp=75;
	RCALL SUBOPT_0x21
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	RCALL __EEPROMWRW
; 0000 0123 rotTime=30;//15*60;
	RCALL SUBOPT_0x22
	__GETD1N 0x1E
	RCALL __EEPROMWRD
; 0000 0124 rotperiod=60;//3600;
	RCALL SUBOPT_0x23
	__GETD1N 0x3C
	RCALL __EEPROMWRD
; 0000 0125 
; 0000 0126 
; 0000 0127 
; 0000 0128 // Input/Output Ports initialization
; 0000 0129 // Port B initialization
; 0000 012A // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=Out Func1=Out Func0=Out
; 0000 012B // State7=0 State6=0 State5=0 State4=0 State3=T State2=0 State1=0 State0=0
; 0000 012C PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 012D DDRB=0xF7;
	LDI  R30,LOW(247)
	OUT  0x17,R30
; 0000 012E 
; 0000 012F // Port C initialization
; 0000 0130 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0131 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0132 PORTC=(1 << 6) | (1 << 5) | (1 << 4) | (1 << 3);
	LDI  R30,LOW(120)
	OUT  0x15,R30
; 0000 0133 DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0134 
; 0000 0135 // Port D initialization
; 0000 0136 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0137 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0138 PORTD=0x00;
	OUT  0x12,R30
; 0000 0139 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 013A 
; 0000 013B // Timer/Counter 0 initialization
; 0000 013C // Clock source: System Clock
; 0000 013D // Clock value: 3.906 kHz
; 0000 013E TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 013F TCNT0=0x27;
	LDI  R30,LOW(39)
	OUT  0x32,R30
; 0000 0140 
; 0000 0141 // Timer/Counter 1 initialization
; 0000 0142 // Clock source: System Clock
; 0000 0143 // Clock value: Timer1 Stopped
; 0000 0144 // Mode: Normal top=0xFFFF
; 0000 0145 // OC1A output: Discon.
; 0000 0146 // OC1B output: Discon.
; 0000 0147 // Noise Canceler: Off
; 0000 0148 // Input Capture on Falling Edge
; 0000 0149 // Timer1 Overflow Interrupt: Off
; 0000 014A // Input Capture Interrupt: Off
; 0000 014B // Compare A Match Interrupt: Off
; 0000 014C // Compare B Match Interrupt: Off
; 0000 014D TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 014E TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 014F TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0150 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0151 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0152 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0153 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0154 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0155 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0156 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0157 
; 0000 0158 // Timer/Counter 2 initialization
; 0000 0159 // Clock source: System Clock
; 0000 015A // Clock value: Timer2 Stopped
; 0000 015B // Mode: Normal top=0xFF
; 0000 015C // OC2 output: Disconnected
; 0000 015D ASSR=0x00;
	OUT  0x22,R30
; 0000 015E TCCR2=0x00;
	OUT  0x25,R30
; 0000 015F TCNT2=0x00;
	OUT  0x24,R30
; 0000 0160 OCR2=0x00;
	OUT  0x23,R30
; 0000 0161 
; 0000 0162 // External Interrupt(s) initialization
; 0000 0163 // INT0: Off
; 0000 0164 // INT1: Off
; 0000 0165 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0166 
; 0000 0167 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0168 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0169 
; 0000 016A // USART initialization
; 0000 016B // USART disabled
; 0000 016C UCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 016D 
; 0000 016E // Analog Comparator initialization
; 0000 016F // Analog Comparator: Off
; 0000 0170 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0171 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0172 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0173 
; 0000 0174 // ADC initialization
; 0000 0175 // ADC Clock frequency: 1000.000 kHz
; 0000 0176 // ADC Voltage Reference: AVCC pin
; 0000 0177 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 0178 ADCSRA=0x82;
	LDI  R30,LOW(130)
	OUT  0x6,R30
; 0000 0179 
; 0000 017A // SPI initialization
; 0000 017B // SPI disabled
; 0000 017C SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 017D 
; 0000 017E // TWI initialization
; 0000 017F // TWI disabled
; 0000 0180 TWCR=0x00;
	OUT  0x36,R30
; 0000 0181 
; 0000 0182 // Alphanumeric LCD initialization
; 0000 0183 // Connections are specified in the
; 0000 0184 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0185 // RS - PORTB Bit 0
; 0000 0186 // RD - PORTB Bit 1
; 0000 0187 // EN - PORTB Bit 2
; 0000 0188 // D4 - PORTB Bit 4
; 0000 0189 // D5 - PORTB Bit 5
; 0000 018A // D6 - PORTB Bit 6
; 0000 018B // D7 - PORTB Bit 7
; 0000 018C // Characters/line: 16
; 0000 018D lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 018E // Global enable interrupts
; 0000 018F lcd_clear();
	RCALL _lcd_clear
; 0000 0190 
; 0000 0191 #asm("sei")
	sei
; 0000 0192  _lcd_write_data (LCD_CURSOR_OFF);
	RCALL SUBOPT_0x24
; 0000 0193 while (1)
_0x31:
; 0000 0194       {
; 0000 0195       byte key;
; 0000 0196       byte menuindex;
; 0000 0197       long pasang;
; 0000 0198       char str[16];
; 0000 0199 
; 0000 019A 
; 0000 019B       PORTD.0=!PORTD.0;
	SBIW R28,22
;	key -> Y+21
;	menuindex -> Y+20
;	pasang -> Y+16
;	str -> Y+0
	SBIS 0x12,0
	RJMP _0x34
	CBI  0x12,0
	RJMP _0x35
_0x34:
	SBI  0x12,0
_0x35:
; 0000 019C       currentTemperature=read_adc(0);
	LDI  R26,LOW(0)
	RCALL _read_adc
	MOVW R6,R30
; 0000 019D       if(currentTemperature>Maxtemp)
	RCALL SUBOPT_0x21
	RCALL __EEPROMRDW
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x36
; 0000 019E       {
; 0000 019F       Heater(OFF);
	LDI  R26,LOW(0)
	RJMP _0xB1
; 0000 01A0       }
; 0000 01A1       else if(currentTemperature<Mintemp)
_0x36:
	RCALL SUBOPT_0x20
	RCALL __EEPROMRDW
	CP   R6,R30
	CPC  R7,R31
	BRGE _0x38
; 0000 01A2       {
; 0000 01A3       Heater(ON);
	LDI  R26,LOW(1)
_0xB1:
	RCALL _Heater
; 0000 01A4       }
; 0000 01A5 
; 0000 01A6       if(rotperiod<=0)
_0x38:
	RCALL SUBOPT_0x25
	MOVW R26,R30
	MOVW R24,R22
	RCALL __CPD02
	BRLT _0x39
; 0000 01A7        rotperiod=3600;
	RCALL SUBOPT_0x23
	__GETD1N 0xE10
	RCALL __EEPROMWRD
; 0000 01A8 
; 0000 01A9 
; 0000 01AA      {
_0x39:
; 0000 01AB        int r= clock%rotperiod;
; 0000 01AC        int d=clock/rotperiod%2;
; 0000 01AD        if(r<rotTime)
	SBIW R28,4
;	key -> Y+25
;	menuindex -> Y+24
;	pasang -> Y+20
;	str -> Y+4
;	r -> Y+2
;	d -> Y+0
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x26
	RCALL __MODD21
	STD  Y+2,R30
	STD  Y+2+1,R31
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x26
	RCALL __DIVD21
	ANDI R30,LOW(0x1)
	ANDI R31,HIGH(0x1)
	ST   Y,R30
	STD  Y+1,R31
	RCALL SUBOPT_0x22
	RCALL __EEPROMRDD
	RCALL SUBOPT_0x27
	RCALL __CWD2
	RCALL __CPD21
	BRGE _0x3A
; 0000 01AE        {
; 0000 01AF         if(d==0)
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x3B
; 0000 01B0          {
; 0000 01B1           turn(RIGHT);
	LDI  R26,LOW(2)
	RJMP _0xB2
; 0000 01B2          }
; 0000 01B3          else
_0x3B:
; 0000 01B4          {
; 0000 01B5            turn(LEFT);
	LDI  R26,LOW(1)
_0xB2:
	RCALL _turn
; 0000 01B6          }
; 0000 01B7        }
; 0000 01B8        else
	RJMP _0x3D
_0x3A:
; 0000 01B9        {
; 0000 01BA         turn(OFF);
	LDI  R26,LOW(0)
	RCALL _turn
; 0000 01BB        }
_0x3D:
; 0000 01BC       }
	ADIW R28,4
; 0000 01BD       key=readkey();
	RCALL _readkey
	STD  Y+21,R30
; 0000 01BE       switch(state)
	MOVW R30,R16
; 0000 01BF       {
; 0000 01C0       case STATE_NORMAL:
	SBIW R30,0
	BRNE _0x41
; 0000 01C1        showNormalLine1();
	RCALL _showNormalLine1
; 0000 01C2        showNormalLine2();
	RCALL _showNormalLine2
; 0000 01C3        if(key==OK)
	LDD  R26,Y+21
	CPI  R26,LOW(0x1)
	BRNE _0x42
; 0000 01C4        {
; 0000 01C5        state=STATE_MENU;
	RCALL SUBOPT_0x28
; 0000 01C6        menuindex=0;
	RCALL SUBOPT_0x29
; 0000 01C7        }
; 0000 01C8        break;
_0x42:
	RJMP _0x40
; 0000 01C9        case STATE_MENU:
_0x41:
	RCALL SUBOPT_0x1A
	BRNE _0x43
; 0000 01CA         showNormalLine1();
	RCALL SUBOPT_0x2A
; 0000 01CB         clearLine(1);
; 0000 01CC         lcd_putsf(MenuItems[menuindex]);
	LDD  R30,Y+20
	LDI  R26,LOW(_MenuItems)
	LDI  R27,HIGH(_MenuItems)
	RCALL SUBOPT_0x1D
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	MOVW R26,R30
	RCALL _lcd_putsf
; 0000 01CD        switch(key)
	RCALL SUBOPT_0x2B
; 0000 01CE        {
; 0000 01CF        case OK:
	BRNE _0x47
; 0000 01D0         state=10*(menuindex+1);
	LDD  R30,Y+20
	RCALL SUBOPT_0x1D
	ADIW R30,1
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12
	MOVW R16,R30
; 0000 01D1         menuindex=0;
	RCALL SUBOPT_0x29
; 0000 01D2         pasang=0;
	RCALL SUBOPT_0x2C
; 0000 01D3         _lcd_write_data (LCD_CURSOR_ON);
	LDI  R26,LOW(15)
	RCALL __lcd_write_data
; 0000 01D4         break;
	RJMP _0x46
; 0000 01D5         case CANCEL:
_0x47:
	RCALL SUBOPT_0x1B
	BRNE _0x48
; 0000 01D6         state=STATE_NORMAL;
	__GETWRN 16,17,0
; 0000 01D7         _lcd_write_data (LCD_CURSOR_OFF);
	RCALL SUBOPT_0x24
; 0000 01D8         break;
	RJMP _0x46
; 0000 01D9        case UP:
_0x48:
	RCALL SUBOPT_0x2D
	BRNE _0x49
; 0000 01DA         if(menuindex==0)
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x4A
; 0000 01DB          menuindex=7;
	LDI  R30,LOW(7)
	RJMP _0xB3
; 0000 01DC         else
_0x4A:
; 0000 01DD          menuindex--;
	LDD  R30,Y+20
	SUBI R30,LOW(1)
_0xB3:
	STD  Y+20,R30
; 0000 01DE         break;
	RJMP _0x46
; 0000 01DF        case DOWN:
_0x49:
	RCALL SUBOPT_0x2E
	BRNE _0x46
; 0000 01E0         menuindex++;
	RCALL SUBOPT_0x2F
; 0000 01E1         if(menuindex>7)
	CPI  R26,LOW(0x8)
	BRLO _0x4D
; 0000 01E2         menuindex=0;
	RCALL SUBOPT_0x29
; 0000 01E3         break;
_0x4D:
; 0000 01E4        }
_0x46:
; 0000 01E5        break;
	RJMP _0x40
; 0000 01E6 
; 0000 01E7        case STATE_CLOCK:
_0x43:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x4E
; 0000 01E8         showNormalLine1();
	RCALL SUBOPT_0x2A
; 0000 01E9         clearLine(1);
; 0000 01EA         translateTime(clock+pasang,str);
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x13
; 0000 01EB         lcd_puts(str);
	RCALL SUBOPT_0x15
; 0000 01EC         lcd_gotoxy(menuindex*3+1,1);
	RCALL SUBOPT_0x31
; 0000 01ED        switch(key)
	RCALL SUBOPT_0x2B
; 0000 01EE        {
; 0000 01EF        case OK:
	BRNE _0x52
; 0000 01F0         menuindex++;
	RCALL SUBOPT_0x2F
; 0000 01F1         if(menuindex>3)
	CPI  R26,LOW(0x4)
	BRLO _0x53
; 0000 01F2         menuindex=0;
	RCALL SUBOPT_0x29
; 0000 01F3         clock+=pasang;
_0x53:
	RCALL SUBOPT_0x30
	STS  _clock,R30
	STS  _clock+1,R31
	STS  _clock+2,R22
	STS  _clock+3,R23
; 0000 01F4         pasang=0;
	RCALL SUBOPT_0x2C
; 0000 01F5         break;
	RJMP _0x51
; 0000 01F6         case CANCEL:
_0x52:
	RCALL SUBOPT_0x1B
	BRNE _0x54
; 0000 01F7         menuindex=0;
	RCALL SUBOPT_0x29
; 0000 01F8         state=STATE_MENU;
	RCALL SUBOPT_0x28
; 0000 01F9        _lcd_write_data (LCD_CURSOR_OFF);
	RCALL SUBOPT_0x24
; 0000 01FA         break;
	RJMP _0x51
; 0000 01FB        case UP:
_0x54:
	RCALL SUBOPT_0x2D
	BRNE _0x55
; 0000 01FC         pasang+=clockratios[menuindex];
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x33
	RJMP _0xB4
; 0000 01FD         break;
; 0000 01FE        case DOWN:
_0x55:
	RCALL SUBOPT_0x2E
	BRNE _0x51
; 0000 01FF         pasang-=clockratios[menuindex];
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x34
_0xB4:
	__PUTD1S 16
; 0000 0200         break;
; 0000 0201        }
_0x51:
; 0000 0202 
; 0000 0203        break;
	RJMP _0x40
; 0000 0204        case STATE_MATEMP:
_0x4E:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0x57
; 0000 0205         showNormalLine1();
	RCALL SUBOPT_0x2A
; 0000 0206         clearLine(1);
; 0000 0207         translateTemp(Maxtemp+pasang,str);
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x16
; 0000 0208         lcd_puts(str);
; 0000 0209        switch(key)
	RCALL SUBOPT_0x2B
; 0000 020A        {
; 0000 020B        case OK:
	BRNE _0x5B
; 0000 020C        if(pasang!=0)
	RCALL SUBOPT_0x36
	RCALL __CPD10
	BREQ _0x5C
; 0000 020D        {
; 0000 020E         Maxtemp+=pasang;
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x21
	RCALL __EEPROMWRW
; 0000 020F        }
; 0000 0210        case CANCEL:
_0x5C:
	RJMP _0x5D
_0x5B:
	RCALL SUBOPT_0x1B
	BRNE _0x5E
_0x5D:
; 0000 0211         state=STATE_MENU;
	RCALL SUBOPT_0x28
; 0000 0212         menuindex=STATE_MATEMP/10-1;
	LDI  R30,LOW(1)
	STD  Y+20,R30
; 0000 0213         _lcd_write_data (LCD_CURSOR_OFF);
	RCALL SUBOPT_0x24
; 0000 0214         break;
	RJMP _0x5A
; 0000 0215        case UP:
_0x5E:
	RCALL SUBOPT_0x2D
	BRNE _0x5F
; 0000 0216         pasang++;
	RCALL SUBOPT_0x37
	RJMP _0xB5
; 0000 0217         break;
; 0000 0218        case DOWN:
_0x5F:
	RCALL SUBOPT_0x2E
	BRNE _0x5A
; 0000 0219         pasang--;
	RCALL SUBOPT_0x38
_0xB5:
	__PUTD1S 16
; 0000 021A         break;
; 0000 021B        }
_0x5A:
; 0000 021C 
; 0000 021D        break;
	RJMP _0x40
; 0000 021E 
; 0000 021F        case STATE_MITEMP:
_0x57:
	CPI  R30,LOW(0x1E)
	LDI  R26,HIGH(0x1E)
	CPC  R31,R26
	BRNE _0x61
; 0000 0220         showNormalLine1();
	RCALL SUBOPT_0x2A
; 0000 0221         clearLine(1);
; 0000 0222         translateTemp(Mintemp+pasang,str);
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x16
; 0000 0223         lcd_puts(str);
; 0000 0224        switch(key)
	RCALL SUBOPT_0x2B
; 0000 0225        {
; 0000 0226        case OK:
	BRNE _0x65
; 0000 0227        if(pasang!=0)
	RCALL SUBOPT_0x3A
	BREQ _0x66
; 0000 0228        {
; 0000 0229         Mintemp+=pasang;
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x20
	RCALL __EEPROMWRW
; 0000 022A        }
; 0000 022B         pasang=0;
_0x66:
	RCALL SUBOPT_0x2C
; 0000 022C         case CANCEL:
	RJMP _0x67
_0x65:
	RCALL SUBOPT_0x1B
	BRNE _0x68
_0x67:
; 0000 022D         state=STATE_MENU;
	RCALL SUBOPT_0x28
; 0000 022E         menuindex=STATE_MITEMP/10-1;
	LDI  R30,LOW(2)
	STD  Y+20,R30
; 0000 022F         break;
	RJMP _0x64
; 0000 0230        case UP:
_0x68:
	RCALL SUBOPT_0x2D
	BRNE _0x69
; 0000 0231         pasang++;
	RCALL SUBOPT_0x37
	RJMP _0xB6
; 0000 0232         break;
; 0000 0233        case DOWN:
_0x69:
	RCALL SUBOPT_0x2E
	BRNE _0x64
; 0000 0234         pasang--;
	RCALL SUBOPT_0x38
_0xB6:
	__PUTD1S 16
; 0000 0235         break;
; 0000 0236        }
_0x64:
; 0000 0237 
; 0000 0238        break;
	RJMP _0x40
; 0000 0239 
; 0000 023A        case STATE_ROTATT:
_0x61:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0x6B
; 0000 023B         showNormalLine1();
	RCALL SUBOPT_0x2A
; 0000 023C         clearLine(1);
; 0000 023D         translateTime(rotTime+pasang,str);
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x13
; 0000 023E         lcd_puts(str);
	RCALL SUBOPT_0x15
; 0000 023F         lcd_gotoxy(menuindex*3+1,1);
	RCALL SUBOPT_0x31
; 0000 0240        switch(key)
	RCALL SUBOPT_0x2B
; 0000 0241        {
; 0000 0242        case OK:
	BRNE _0x6F
; 0000 0243         menuindex++;
	RCALL SUBOPT_0x2F
; 0000 0244         if(menuindex>3)
	CPI  R26,LOW(0x4)
	BRLO _0x70
; 0000 0245          menuindex=0;
	RCALL SUBOPT_0x29
; 0000 0246         if(pasang!=0)
_0x70:
	RCALL SUBOPT_0x3A
	BREQ _0x71
; 0000 0247          rotTime+=pasang;
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x22
	RCALL __EEPROMWRD
; 0000 0248         pasang=0;
_0x71:
	RCALL SUBOPT_0x2C
; 0000 0249         break;
	RJMP _0x6E
; 0000 024A         case CANCEL:
_0x6F:
	RCALL SUBOPT_0x1B
	BRNE _0x72
; 0000 024B         menuindex=STATE_ROTATT/10-1;
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x3C
; 0000 024C         state=STATE_MENU;
; 0000 024D         break;
	RJMP _0x6E
; 0000 024E        case UP:
_0x72:
	RCALL SUBOPT_0x2D
	BRNE _0x73
; 0000 024F         pasang+=clockratios[menuindex];
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x33
	RJMP _0xB7
; 0000 0250         break;
; 0000 0251        case DOWN:
_0x73:
	RCALL SUBOPT_0x2E
	BRNE _0x6E
; 0000 0252         pasang-=clockratios[menuindex];
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x34
_0xB7:
	__PUTD1S 16
; 0000 0253         break;
; 0000 0254        }
_0x6E:
; 0000 0255        break;
	RJMP _0x40
; 0000 0256        case STATE_ROTATP:
_0x6B:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x75
; 0000 0257         showNormalLine1();
	RCALL SUBOPT_0x2A
; 0000 0258         clearLine(1);
; 0000 0259         translateTime(rotperiod+pasang,str);
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x13
; 0000 025A         lcd_puts(str);
	RCALL SUBOPT_0x15
; 0000 025B         lcd_gotoxy(menuindex*3+1,1);
	RCALL SUBOPT_0x31
; 0000 025C        switch(key)
	RCALL SUBOPT_0x2B
; 0000 025D        {
; 0000 025E        case OK:
	BRNE _0x79
; 0000 025F         menuindex++;
	RCALL SUBOPT_0x2F
; 0000 0260         if(menuindex>3)
	CPI  R26,LOW(0x4)
	BRLO _0x7A
; 0000 0261          menuindex=0;
	RCALL SUBOPT_0x29
; 0000 0262         if(pasang!=0)
_0x7A:
	RCALL SUBOPT_0x3A
	BREQ _0x7B
; 0000 0263          rotperiod+=pasang;
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x23
	RCALL __EEPROMWRD
; 0000 0264         pasang=0;
_0x7B:
	RCALL SUBOPT_0x2C
; 0000 0265         break;
	RJMP _0x78
; 0000 0266         case CANCEL:
_0x79:
	RCALL SUBOPT_0x1B
	BRNE _0x7C
; 0000 0267         menuindex=STATE_ROTATP/10-1;
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x3C
; 0000 0268         state=STATE_MENU;
; 0000 0269         break;
	RJMP _0x78
; 0000 026A        case UP:
_0x7C:
	RCALL SUBOPT_0x2D
	BRNE _0x7D
; 0000 026B         pasang+=clockratios[menuindex];
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x33
	RJMP _0xB8
; 0000 026C         break;
; 0000 026D        case DOWN:
_0x7D:
	RCALL SUBOPT_0x2E
	BRNE _0x78
; 0000 026E         pasang-=clockratios[menuindex];
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x34
_0xB8:
	__PUTD1S 16
; 0000 026F         break;
; 0000 0270        }
_0x78:
; 0000 0271        break;
	RJMP _0x40
; 0000 0272 
; 0000 0273        case STATE_SYCHK:
_0x75:
	CPI  R30,LOW(0x3C)
	LDI  R26,HIGH(0x3C)
	CPC  R31,R26
	BRNE _0x7F
; 0000 0274         PORTD=0;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0275         clearLine(1);
	RCALL SUBOPT_0x18
; 0000 0276         clearLine(0);
	RCALL SUBOPT_0x3E
; 0000 0277         lcd_puts("OK or CANCEL");
	__POINTW2MN _0x80,0
	RCALL _lcd_puts
; 0000 0278        switch(key)
	RCALL SUBOPT_0x2B
; 0000 0279        {
; 0000 027A        case OK:
	BRNE _0x84
; 0000 027B         clearLine(0);
	RCALL SUBOPT_0x3E
; 0000 027C         lcd_puts("Heater ON");
	__POINTW2MN _0x80,13
	RCALL _lcd_puts
; 0000 027D         Heater(ON);
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x3F
; 0000 027E         delay_ms(10000);
; 0000 027F         clearLine(0);
; 0000 0280         lcd_puts("Heater OFF");
	__POINTW2MN _0x80,23
	RCALL _lcd_puts
; 0000 0281         Heater(OFF);
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x3F
; 0000 0282         delay_ms(10000);
; 0000 0283         clearLine(0);
; 0000 0284         lcd_puts("rotation Left");
	__POINTW2MN _0x80,34
	RCALL _lcd_puts
; 0000 0285         turn(LEFT);
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x40
; 0000 0286         delay_ms(10000);
; 0000 0287         clearLine(0);
; 0000 0288         lcd_puts("rotation Right");
	__POINTW2MN _0x80,48
	RCALL _lcd_puts
; 0000 0289         turn(RIGHT);
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x40
; 0000 028A         delay_ms(10000);
; 0000 028B         clearLine(0);
; 0000 028C         lcd_puts("rotation Off");
	__POINTW2MN _0x80,63
	RCALL _lcd_puts
; 0000 028D         turn(OFF);
	LDI  R26,LOW(0)
	RCALL _turn
; 0000 028E         delay_ms(10000);
	LDI  R26,LOW(10000)
	LDI  R27,HIGH(10000)
	RCALL _delay_ms
; 0000 028F 
; 0000 0290         case CANCEL:
	RJMP _0x85
_0x84:
	RCALL SUBOPT_0x1B
	BRNE _0x86
_0x85:
; 0000 0291         menuindex=STATE_SYCHK/10-1;
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x3C
; 0000 0292         state=STATE_MENU;
; 0000 0293         break;
	RJMP _0x83
; 0000 0294        case UP:
_0x86:
	RCALL SUBOPT_0x2D
	BRNE _0x87
; 0000 0295         lcd_gotoxy(0,0);
	RCALL SUBOPT_0x14
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 0296         lcd_puts("Invalid key");
	__POINTW2MN _0x80,76
	RJMP _0xB9
; 0000 0297         break;
; 0000 0298        case DOWN:
_0x87:
	RCALL SUBOPT_0x2E
	BRNE _0x83
; 0000 0299         lcd_gotoxy(0,0);
	RCALL SUBOPT_0x14
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 029A         lcd_puts("Invalid key");
	__POINTW2MN _0x80,88
_0xB9:
	RCALL _lcd_puts
; 0000 029B         break;
; 0000 029C        }
_0x83:
; 0000 029D        break;
	RJMP _0x40
; 0000 029E 
; 0000 029F        case STATE_ATEMP1:
_0x7F:
	CPI  R30,LOW(0x46)
	LDI  R26,HIGH(0x46)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x89
; 0000 02A0         showNormalLine1();
	RCALL SUBOPT_0x2A
; 0000 02A1         clearLine(1);
; 0000 02A2         itoa(temp1+(menuindex==0?pasang:0),str);
	LDI  R26,LOW(_temp1)
	LDI  R27,HIGH(_temp1)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x41
	SBIW R26,0
	BRNE _0x8A
	RCALL SUBOPT_0x42
	RJMP _0x8B
_0x8A:
	RCALL SUBOPT_0x1F
_0x8B:
	RCALL SUBOPT_0x43
; 0000 02A3         lcd_puts(str);
; 0000 02A4 
; 0000 02A5         lcd_gotoxy(8,1);
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x44
; 0000 02A6         itoa(temp1analog+(menuindex==1?pasang:0),str);
	RCALL SUBOPT_0x8
	MOVW R0,R30
	RCALL SUBOPT_0x41
	SBIW R26,1
	BRNE _0x8D
	RCALL SUBOPT_0x42
	RJMP _0x8E
_0x8D:
	RCALL SUBOPT_0x1F
_0x8E:
	RCALL SUBOPT_0x43
; 0000 02A7         lcd_puts(str);
; 0000 02A8         lcd_gotoxy(menuindex*8,1);
	RCALL SUBOPT_0x45
; 0000 02A9        switch(key)
	RCALL SUBOPT_0x2B
; 0000 02AA        {
; 0000 02AB        case OK:
	BRNE _0x93
; 0000 02AC         if(pasang!=0)
	RCALL SUBOPT_0x3A
	BREQ _0x94
; 0000 02AD         {
; 0000 02AE          if(menuindex==0)
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x95
; 0000 02AF           temp1 +=pasang;
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x46
	LDI  R26,LOW(_temp1)
	LDI  R27,HIGH(_temp1)
	RJMP _0xBA
; 0000 02B0          else
_0x95:
; 0000 02B1           temp1analog +=pasang;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x46
	LDI  R26,LOW(_temp1analog)
	LDI  R27,HIGH(_temp1analog)
_0xBA:
	RCALL __EEPROMWRW
; 0000 02B2         }
; 0000 02B3         menuindex++;
_0x94:
	RCALL SUBOPT_0x2F
; 0000 02B4         if(menuindex>1)
	CPI  R26,LOW(0x2)
	BRLO _0x97
; 0000 02B5          menuindex=0;
	RCALL SUBOPT_0x29
; 0000 02B6         pasang=0;
_0x97:
	RCALL SUBOPT_0x2C
; 0000 02B7         break;
	RJMP _0x92
; 0000 02B8         case CANCEL:
_0x93:
	RCALL SUBOPT_0x1B
	BRNE _0x98
; 0000 02B9         menuindex=STATE_ATEMP1/10-1;
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x3C
; 0000 02BA         state=STATE_MENU;
; 0000 02BB         break;
	RJMP _0x92
; 0000 02BC        case UP:
_0x98:
	RCALL SUBOPT_0x2D
	BRNE _0x99
; 0000 02BD         pasang++;
	RCALL SUBOPT_0x37
	RJMP _0xBB
; 0000 02BE         break;
; 0000 02BF        case DOWN:
_0x99:
	RCALL SUBOPT_0x2E
	BRNE _0x92
; 0000 02C0         pasang--;
	RCALL SUBOPT_0x38
_0xBB:
	__PUTD1S 16
; 0000 02C1         break;
; 0000 02C2        }
_0x92:
; 0000 02C3        break;
	RJMP _0x40
; 0000 02C4        case STATE_ATEMP2:
_0x89:
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BRNE _0xAD
; 0000 02C5         showNormalLine1();
	RCALL SUBOPT_0x2A
; 0000 02C6         clearLine(1);
; 0000 02C7         itoa(temp2+(menuindex==0?pasang:0),str);
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x41
	SBIW R26,0
	BRNE _0x9C
	RCALL SUBOPT_0x42
	RJMP _0x9D
_0x9C:
	RCALL SUBOPT_0x1F
_0x9D:
	RCALL SUBOPT_0x43
; 0000 02C8         lcd_puts(str);
; 0000 02C9 
; 0000 02CA         lcd_gotoxy(8,1);
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x44
; 0000 02CB         itoa(temp2analog+(menuindex==1?pasang:0),str);
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x41
	SBIW R26,1
	BRNE _0x9F
	RCALL SUBOPT_0x42
	RJMP _0xA0
_0x9F:
	RCALL SUBOPT_0x1F
_0xA0:
	RCALL SUBOPT_0x43
; 0000 02CC         lcd_puts(str);
; 0000 02CD         lcd_gotoxy(menuindex*8,1);
	RCALL SUBOPT_0x45
; 0000 02CE        switch(key)
	RCALL SUBOPT_0x2B
; 0000 02CF        {
; 0000 02D0        case OK:
	BRNE _0xA5
; 0000 02D1         if(pasang!=0)
	RCALL SUBOPT_0x3A
	BREQ _0xA6
; 0000 02D2         {
; 0000 02D3          if(menuindex==0)
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0xA7
; 0000 02D4           temp2 +=pasang;
	RCALL SUBOPT_0xC
	RCALL __EEPROMRDW
	RCALL SUBOPT_0x46
	RCALL SUBOPT_0xC
	RJMP _0xBC
; 0000 02D5          else
_0xA7:
; 0000 02D6           temp2analog +=pasang;
	RCALL SUBOPT_0xF
	RCALL __EEPROMRDW
	RCALL SUBOPT_0x46
	RCALL SUBOPT_0xF
_0xBC:
	RCALL __EEPROMWRW
; 0000 02D7         }
; 0000 02D8         menuindex++;
_0xA6:
	RCALL SUBOPT_0x2F
; 0000 02D9         if(menuindex>1)
	CPI  R26,LOW(0x2)
	BRLO _0xA9
; 0000 02DA          menuindex=0;
	RCALL SUBOPT_0x29
; 0000 02DB         pasang=0;
_0xA9:
	RCALL SUBOPT_0x2C
; 0000 02DC         break;
	RJMP _0xA4
; 0000 02DD         case CANCEL:
_0xA5:
	RCALL SUBOPT_0x1B
	BRNE _0xAA
; 0000 02DE         menuindex=STATE_ATEMP1/10-1;
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x3C
; 0000 02DF         state=STATE_MENU;
; 0000 02E0         break;
	RJMP _0xA4
; 0000 02E1        case UP:
_0xAA:
	RCALL SUBOPT_0x2D
	BRNE _0xAB
; 0000 02E2         pasang++;
	RCALL SUBOPT_0x37
	RJMP _0xBD
; 0000 02E3         break;
; 0000 02E4        case DOWN:
_0xAB:
	RCALL SUBOPT_0x2E
	BRNE _0xA4
; 0000 02E5         pasang--;
	RCALL SUBOPT_0x38
_0xBD:
	__PUTD1S 16
; 0000 02E6         break;
; 0000 02E7        }
_0xA4:
; 0000 02E8        break;
; 0000 02E9 
; 0000 02EA        default:
_0xAD:
; 0000 02EB       }
_0x40:
; 0000 02EC 
; 0000 02ED       delay_ms(200);
	LDI  R26,LOW(200)
	RCALL SUBOPT_0x47
; 0000 02EE       }
	ADIW R28,22
	RJMP _0x31
; 0000 02EF }
_0xAE:
	RJMP _0xAE

	.DSEG
_0x80:
	.BYTE 0x64
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
	RCALL SUBOPT_0x0
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x27
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x48
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	RCALL SUBOPT_0x27
	ADIW R26,2
	RCALL SUBOPT_0x49
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	RCALL SUBOPT_0x27
	RCALL __GETW1P
	TST  R31
	BRMI _0x2000014
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x49
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	RCALL SUBOPT_0x27
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
__print_G100:
	RCALL SUBOPT_0x0
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL SUBOPT_0x1F
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0x4A
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0x4A
	RJMP _0x20000C9
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x42
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x4C
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x4D
	STD  Y+6,R30
	STD  Y+6+1,R31
	RCALL SUBOPT_0x9
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x4D
	RCALL SUBOPT_0x4E
	RCALL SUBOPT_0x9
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	RCALL SUBOPT_0x4E
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	RCALL SUBOPT_0x4E
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x4D
	RCALL SUBOPT_0x2
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x2
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x4D
	RCALL SUBOPT_0x2
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	RCALL SUBOPT_0x4A
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	RCALL SUBOPT_0x4F
	LPM  R18,Z+
	RCALL SUBOPT_0x4E
	RJMP _0x2000054
_0x2000053:
	RCALL SUBOPT_0x9
	LD   R18,X+
	RCALL SUBOPT_0x50
_0x2000054:
	RCALL SUBOPT_0x4A
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	RCALL SUBOPT_0x4F
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	RCALL SUBOPT_0x4F
	ADIW R30,2
	RCALL SUBOPT_0x4E
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x2
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CA
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x4C
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0x4A
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x4C
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x51
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0006
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x4E
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x6
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	RCALL SUBOPT_0x6
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	RCALL SUBOPT_0x9
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0006:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG
_itoa:
	RCALL SUBOPT_0x0
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret
_ftoa:
	RCALL SUBOPT_0x0
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	RCALL __SAVELOCR2
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x202000D
	RCALL SUBOPT_0x4F
	RCALL SUBOPT_0x6
	__POINTW2FN _0x2020000,0
	RCALL _strcpyf
	RJMP _0x20C0005
_0x202000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x202000C
	RCALL SUBOPT_0x4F
	RCALL SUBOPT_0x6
	__POINTW2FN _0x2020000,1
	RCALL _strcpyf
	RJMP _0x20C0005
_0x202000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x202000F
	RCALL SUBOPT_0x52
	RCALL __ANEGF1
	RCALL SUBOPT_0x53
	RCALL SUBOPT_0x54
	LDI  R30,LOW(45)
	ST   X,R30
_0x202000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2020010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2020010:
	LDD  R17,Y+8
_0x2020011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2020013
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x56
	RCALL SUBOPT_0x57
	RJMP _0x2020011
_0x2020013:
	RCALL SUBOPT_0x58
	RCALL __ADDF12
	RCALL SUBOPT_0x53
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x57
_0x2020014:
	RCALL SUBOPT_0x58
	RCALL __CMPF12
	BRLO _0x2020016
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x59
	RCALL SUBOPT_0x57
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2020017
	RCALL SUBOPT_0x4F
	RCALL SUBOPT_0x6
	__POINTW2FN _0x2020000,5
	RCALL _strcpyf
	RJMP _0x20C0005
_0x2020017:
	RJMP _0x2020014
_0x2020016:
	CPI  R17,0
	BRNE _0x2020018
	RCALL SUBOPT_0x54
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2020019
_0x2020018:
_0x202001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x202001C
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x56
	__GETD2N 0x3F000000
	RCALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL _floor
	RCALL SUBOPT_0x57
	RCALL SUBOPT_0x58
	RCALL __DIVF21
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x5A
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0xB
	RCALL __MULF12
	RCALL SUBOPT_0x5B
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x53
	RJMP _0x202001A
_0x202001C:
_0x2020019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0004
	RCALL SUBOPT_0x54
	LDI  R30,LOW(46)
	ST   X,R30
_0x202001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2020020
	RCALL SUBOPT_0x5B
	RCALL SUBOPT_0x59
	RCALL SUBOPT_0x53
	RCALL SUBOPT_0x52
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x5A
	RCALL SUBOPT_0x5B
	RCALL SUBOPT_0xB
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x53
	RJMP _0x202001E
_0x2020020:
_0x20C0004:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0005:
	RCALL __LOADLOCR2
	ADIW R28,13
	RET

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G102:
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 5
	SBI  0x18,2
	__DELAY_USB 13
	CBI  0x18,2
	__DELAY_USB 13
	RJMP _0x20C0002
__lcd_write_data:
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
	__DELAY_USB 133
	RJMP _0x20C0002
_lcd_gotoxy:
	ST   -Y,R26
	LD   R30,Y
	RCALL SUBOPT_0x1D
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R13,Y+1
	LDD  R12,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x24
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x47
	LDI  R30,LOW(0)
	MOV  R12,R30
	MOV  R13,R30
	RET
_lcd_putchar:
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040005
	LDS  R30,__lcd_maxx
	CP   R13,R30
	BRLO _0x2040004
_0x2040005:
	RCALL SUBOPT_0x14
	INC  R12
	MOV  R26,R12
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2040007
	RJMP _0x20C0002
_0x2040007:
_0x2040004:
	INC  R13
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x20C0002
_lcd_puts:
	RCALL SUBOPT_0x0
	ST   -Y,R17
_0x2040008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x204000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2040008
_0x204000A:
	RJMP _0x20C0003
_lcd_putsf:
	RCALL SUBOPT_0x0
	ST   -Y,R17
_0x204000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x204000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x204000B
_0x204000D:
_0x20C0003:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	ST   -Y,R26
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G102,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G102,3
	LDI  R26,LOW(20)
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x5C
	RCALL SUBOPT_0x5C
	RCALL SUBOPT_0x5C
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0002:
	ADIW R28,1
	RET

	.CSEG

	.CSEG
_strcpyf:
	RCALL SUBOPT_0x0
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
_strlen:
	RCALL SUBOPT_0x0
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
	RCALL SUBOPT_0x0
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG
_ftrunc:
	RCALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	RCALL __PUTPARD2
	RCALL __GETD2S0
	RCALL _ftrunc
	RCALL SUBOPT_0x10
    brne __floor1
__floor0:
	RCALL SUBOPT_0x11
	RJMP _0x20C0001
__floor1:
    brtc __floor0
	RCALL SUBOPT_0x11
	__GETD2N 0x3F800000
	RCALL __SUBF12
_0x20C0001:
	ADIW R28,4
	RET

	.DSEG
_clock:
	.BYTE 0x4

	.ESEG
_temp1:
	.BYTE 0x2
_temp1analog:
	.BYTE 0x2
_temp2:
	.BYTE 0x2
_temp2analog:
	.BYTE 0x2
_Mintemp:
	.DB  0x0,0x0
_Maxtemp:
	.DB  0x1,0x0
_rotTime:
	.DB  0x1E,0x0,0x0,0x0
_rotperiod:
	.DB  0x3C,0x0,0x0,0x0

	.DSEG
_MenuItems:
	.BYTE 0x10
__seed_G101:
	.BYTE 0x4
__base_y_G102:
	.BYTE 0x4
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x0:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1:
	__PUTD1S 6
	__GETD2S 6
	__GETD1N 0x3C
	RCALL __MODD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	__GETD2S 6
	__GETD1N 0x3C
	RCALL __DIVD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	__GETD2S 6
	__GETD1N 0x18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x6:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	RCALL __CWD1
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(_temp1analog)
	LDI  R27,HIGH(_temp1analog)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xB:
	RCALL __CWD1
	RCALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(_temp2)
	LDI  R27,HIGH(_temp2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	RCALL __EEPROMRDW
	MOVW R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(_temp1)
	LDI  R27,HIGH(_temp1)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(_temp2analog)
	LDI  R27,HIGH(_temp2analog)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	RCALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R26,Y+1
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x13:
	RCALL __PUTPARD1
	MOVW R26,R28
	ADIW R26,4
	RJMP _translateTime

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x15:
	MOVW R26,R28
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x16:
	MOVW R26,R28
	ADIW R26,2
	RCALL _translateTemp
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(1)
	RJMP _clearLine

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x19:
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x1A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1C:
	__SUBD1N -1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:38 WORDS
SUBOPT_0x1D:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x1E:
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	LDI  R26,LOW(_Mintemp)
	LDI  R27,HIGH(_Mintemp)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(_Maxtemp)
	LDI  R27,HIGH(_Maxtemp)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	LDI  R26,LOW(_rotTime)
	LDI  R27,HIGH(_rotTime)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	LDI  R26,LOW(_rotperiod)
	LDI  R27,HIGH(_rotperiod)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x24:
	LDI  R26,LOW(12)
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x25:
	RCALL SUBOPT_0x23
	RCALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x26:
	LDS  R26,_clock
	LDS  R27,_clock+1
	LDS  R24,_clock+2
	LDS  R25,_clock+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x27:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x28:
	__GETWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(0)
	STD  Y+20,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2A:
	RCALL _showNormalLine1
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x2B:
	LDD  R30,Y+21
	RCALL SUBOPT_0x1D
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(0)
	__CLRD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x2D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x2E:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2F:
	LDD  R30,Y+20
	SUBI R30,-LOW(1)
	STD  Y+20,R30
	LDD  R26,Y+20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	__GETD1S 16
	RCALL SUBOPT_0x26
	RCALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x31:
	LDD  R30,Y+20
	LDI  R26,LOW(3)
	MULS R30,R26
	MOVW R30,R0
	SUBI R30,-LOW(1)
	ST   -Y,R30
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x32:
	LDD  R30,Y+20
	LDI  R26,LOW(_clockratios*2)
	LDI  R27,HIGH(_clockratios*2)
	RCALL SUBOPT_0x1D
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x33:
	RCALL __GETD1PF
	__GETD2S 16
	RCALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x34:
	RCALL __GETD2PF
	__GETD1S 16
	RCALL __SUBD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x35:
	RCALL SUBOPT_0x21
	RCALL __EEPROMRDW
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x36:
	__GETD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	RCALL SUBOPT_0x36
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x38:
	RCALL SUBOPT_0x36
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x39:
	RCALL SUBOPT_0x20
	RCALL __EEPROMRDW
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3A:
	RCALL SUBOPT_0x36
	RCALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3B:
	RCALL SUBOPT_0x22
	RCALL __EEPROMRDD
	__GETD2S 16
	RCALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3C:
	STD  Y+20,R30
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3D:
	__GETD2S 16
	RCALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	LDI  R26,LOW(0)
	RJMP _clearLine

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3F:
	RCALL _Heater
	LDI  R26,LOW(10000)
	LDI  R27,HIGH(10000)
	RCALL _delay_ms
	RJMP SUBOPT_0x3E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x40:
	RCALL _turn
	LDI  R26,LOW(10000)
	LDI  R27,HIGH(10000)
	RCALL _delay_ms
	RJMP SUBOPT_0x3E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	LDD  R26,Y+20
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x42:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x43:
	ADD  R30,R0
	ADC  R31,R1
	RCALL SUBOPT_0x6
	MOVW R26,R28
	ADIW R26,2
	RCALL _itoa
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	ST   -Y,R30
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x45:
	LDD  R30,Y+20
	LSL  R30
	LSL  R30
	LSL  R30
	RJMP SUBOPT_0x44

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x46:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	RCALL SUBOPT_0x1E
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x48:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x49:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x4A:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x4B:
	RCALL SUBOPT_0x42
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4C:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4D:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x48

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4E:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4F:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x50:
	STD  Y+6,R26
	STD  Y+6+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x51:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x52:
	__GETD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x53:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x54:
	RCALL SUBOPT_0x9
	ADIW R26,1
	RCALL SUBOPT_0x50
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x55:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x56:
	__GETD1N 0x3DCCCCCD
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x57:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x58:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x59:
	__GETD1N 0x41200000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5A:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5B:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x5C:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__MODD21:
	CLT
	SBRS R25,7
	RJMP __MODD211
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	SUBI R26,-1
	SBCI R27,-1
	SBCI R24,-1
	SBCI R25,-1
	SET
__MODD211:
	SBRC R23,7
	RCALL __ANEGD1
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	BRTC __MODD212
	RCALL __ANEGD1
__MODD212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1PF:
	LPM  R0,Z+
	LPM  R1,Z+
	LPM  R22,Z+
	LPM  R23,Z
	MOVW R30,R0
	RET

__GETD2PF:
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R24,Z+
	LPM  R25,Z
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDD:
	ADIW R26,2
	RCALL __EEPROMRDW
	MOVW R22,R30
	SBIW R26,2

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRD:
	RCALL __EEPROMWRW
	ADIW R26,2
	MOVW R0,R30
	MOVW R30,R22
	RCALL __EEPROMWRW
	MOVW R30,R0
	SBIW R26,2
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
