	.file	"usbdrv.c"
__SREG__ = 0x3f
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__CCP__  = 0x34
__tmp_reg__ = 0
__zero_reg__ = 1
	.global __do_copy_data
	.global __do_clear_bss
	.text
.global	usbInit
	.type	usbInit, @function
usbInit:
/* prologue: function */
/* frame size = 0 */
	ldi r24,lo8(usbRxBuf)
	ldi r25,hi8(usbRxBuf)
	sts usbInputBuf,r24
	adiw r24,11
	sts usbAppBuf,r24
	in r24,85-32
	ori r24,lo8(3)
	out 85-32,r24
	in r24,91-32
	ori r24,lo8(64)
	out 91-32,r24
/* epilogue start */
	ret
	.size	usbInit, .-usbInit
.global	usbPoll
	.type	usbPoll, @function
usbPoll:
	push r16
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
	lds r22,usbRxLen
	tst r22
	brne .+2
	rjmp .L4
	subi r22,lo8(-(-3))
	sbrc r22,7
	rjmp .L5
	ldi r18,lo8(usbRxBuf)
	ldi r19,hi8(usbRxBuf)
	lds r25,usbAppBuf
	subi r25,lo8(-(1))
	lds r24,usbRxToken
	cpi r24,lo8(45)
	breq .+2
	rjmp .L6
	cpi r22,lo8(8)
	breq .+2
	rjmp .L7
	mov r28,r25
	mov r29,r19
	ld r24,Y
	andi r24,lo8(96)
	breq .+2
	rjmp .L8
	sts usbTxBuf+9,__zero_reg__
	ldd r24,Y+1
	tst r24
	brne .L9
	sts usbTxBuf+10,__zero_reg__
	ldi r24,lo8(usbTxBuf+9)
	ldi r25,hi8(usbTxBuf+9)
	ldi r19,lo8(-128)
	ldi r18,lo8(2)
	rjmp .L10
.L9:
	cpi r24,lo8(5)
	brne .L11
	ldd r24,Y+2
	sts usbNewDeviceAddr,r24
	rjmp .L21
.L11:
	cpi r24,lo8(6)
	brne .L12
	ldd r24,Y+3
	cpi r24,lo8(1)
	brne .L13
	ldi r24,lo8(usbDescrDevice)
	ldi r25,hi8(usbDescrDevice)
	rjmp .L44
.L13:
	cpi r24,lo8(2)
	brne .L14
	ldi r24,lo8(usbDescrConfig)
	ldi r25,hi8(usbDescrConfig)
.L44:
	ldi r19,lo8(-64)
	ldi r18,lo8(18)
	rjmp .L10
.L14:
	cpi r24,lo8(3)
	brne .L50
.L15:
	ldd r24,Y+2
	tst r24
	brne .L16
	ldi r24,lo8(usbDescrString0)
	ldi r25,hi8(usbDescrString0)
	ldi r19,lo8(-64)
	ldi r18,lo8(4)
	rjmp .L10
.L16:
	cpi r24,lo8(1)
	brne .L17
	ldi r24,lo8(usbDescrString1)
	ldi r25,hi8(usbDescrString1)
	ldi r19,lo8(-64)
	ldi r18,lo8(28)
	rjmp .L10
.L17:
	cpi r24,lo8(2)
	breq .L18
.L50:
	ldi r24,lo8(usbTxBuf+9)
	ldi r25,hi8(usbTxBuf+9)
	ldi r19,lo8(-64)
	rjmp .L46
.L18:
	ldi r24,lo8(usbDescrString2)
	ldi r25,hi8(usbDescrString2)
	ldi r19,lo8(-64)
	ldi r18,lo8(22)
	rjmp .L10
.L12:
	cpi r24,lo8(8)
	brne .L19
	ldi r24,lo8(usbConfiguration)
	ldi r25,hi8(usbConfiguration)
	rjmp .L45
.L19:
	cpi r24,lo8(9)
	brne .L20
	ldd r24,Y+2
	sts usbConfiguration,r24
	rjmp .L21
.L20:
	cpi r24,lo8(10)
	brne .L21
	ldi r24,lo8(usbTxBuf+9)
	ldi r25,hi8(usbTxBuf+9)
.L45:
	ldi r19,lo8(-128)
	ldi r18,lo8(1)
	rjmp .L10
.L21:
	ldi r24,lo8(usbTxBuf+9)
	ldi r25,hi8(usbTxBuf+9)
	ldi r19,lo8(-128)
.L46:
	ldi r18,lo8(0)
.L10:
	sts (usbMsgPtr)+1,r25
	sts usbMsgPtr,r24
	ldd r24,Y+7
	tst r24
	brne .L22
	ldd r25,Y+6
	cp r25,r18
	brlo .L23
	rjmp .L22
.L8:
	mov r24,r25
	mov r25,r19
	rcall usbFunctionSetup
	mov r25,r24
	cpi r24,lo8(-1)
	breq .L24
	ldi r19,lo8(-128)
	rjmp .L23
.L24:
	ld r24,Y
	sbrc r24,7
.L25:
	ldd r25,Y+6
.L47:
	ldi r19,lo8(0)
	rjmp .L23
.L6:
	lds r24,usbMsgFlags
	sbrc r24,7
	rjmp .L7
	mov r24,r25
	mov r25,r19
	rcall usbFunctionWrite
	cpi r24,lo8(-1)
	brne .L26
	ldi r24,lo8(30)
	sts usbTxBuf,r24
	ldi r24,lo8(2)
	sts usbTxLen,r24
	rjmp .L27
.L26:
	tst r24
	breq .L27
	ldi r19,lo8(0)
	rjmp .L48
.L27:
	ldi r19,lo8(0)
	ldi r25,lo8(-1)
	rjmp .L23
.L7:
	ldi r19,lo8(-128)
.L48:
	ldi r25,lo8(0)
	rjmp .L23
.L22:
	mov r25,r18
.L23:
	sts usbMsgFlags,r19
	sts usbMsgLen,r25
.L5:
	sts usbRxLen,__zero_reg__
.L4:
	lds r25,usbMsgLen
	cpi r25,lo8(-1)
	brne .+2
	rjmp .L28
	lds r24,usbTxLen
	sbrs r24,7
	rjmp .L28
	mov r17,r25
	cpi r25,lo8(9)
	brlo .L29
	ldi r17,lo8(8)
.L29:
	sub r25,r17
	sts usbMsgLen,r25
	lds r24,usbMsgFlags
	sbrc r24,0
	rjmp .L30
	ldi r16,lo8(75)
	rjmp .L31
.L30:
	ldi r16,lo8(-61)
.L31:
	subi r24,lo8(-(1))
	sts usbMsgFlags,r24
	lds r18,usbMsgPtr
	lds r19,(usbMsgPtr)+1
	sbrc r24,6
	rjmp .L32
	movw r26,r18
	mov r25,r17
	ldi r30,lo8(usbTxBuf+1)
	ldi r31,hi8(usbTxBuf+1)
	rjmp .L33
.L32:
	ldi r26,lo8(usbTxBuf+1)
	ldi r27,hi8(usbTxBuf+1)
	ldi r24,lo8(0)
	ldi r25,hi8(0)
	rjmp .L34
.L35:
	movw r30,r18
	add r30,r24
	adc r31,r25
/* #APP */
 ;  237 "usbdrv/usbdrv.c" 1
	lpm r30, Z
	
 ;  0 "" 2
/* #NOAPP */
	st X+,r30
	adiw r24,1
.L34:
	cp r17,r24
	brne .L35
	rjmp .L49
.L37:
	ld r24,X+
	st Z+,r24
	subi r25,lo8(-(-1))
.L33:
	tst r25
	brne .L37
.L49:
	movw r30,r18
	add r30,r17
	adc r31,__zero_reg__
	sts (usbMsgPtr)+1,r31
	sts usbMsgPtr,r30
	ldi r24,lo8(usbTxBuf+1)
	ldi r25,hi8(usbTxBuf+1)
	mov r22,r17
	rcall usbCrc16Append
	cpi r17,lo8(8)
	breq .L38
	ldi r24,lo8(-1)
	sts usbMsgLen,r24
.L38:
	sts usbTxBuf,r16
	subi r17,lo8(-(4))
	sts usbTxLen,r17
.L28:
	in r24,48-32
	andi r24,lo8(5)
	breq .L39
	sts usbIsReset,__zero_reg__
	rjmp .L42
.L39:
	lds r24,usbIsReset
	tst r24
	brne .L42
	ldi r25,lo8(100)
.L41:
	in r24,48-32
	andi r24,lo8(5)
	brne .L42
	subi r25,lo8(-(-1))
	brne .L41
	ldi r24,lo8(1)
	sts usbIsReset,r24
	sts usbNewDeviceAddr,__zero_reg__
	sts usbDeviceAddr,__zero_reg__
.L40:
.L42:
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
	ret
	.size	usbPoll, .-usbPoll
.global	usbMsgLen
	.data
	.type	usbMsgLen, @object
	.size	usbMsgLen, 1
usbMsgLen:
	.byte	-1
.global	usbTxLen
	.type	usbTxLen, @object
	.size	usbTxLen, 1
usbTxLen:
	.byte	-1
.global	usbAckBuf
	.type	usbAckBuf, @object
	.size	usbAckBuf, 1
usbAckBuf:
	.byte	-46
.global	usbNakBuf
	.type	usbNakBuf, @object
	.size	usbNakBuf, 1
usbNakBuf:
	.byte	90
	.section	.progmem.data,"a",@progbits
	.type	usbDescrDevice, @object
	.size	usbDescrDevice, 18
usbDescrDevice:
	.byte	18
	.byte	1
	.byte	1
	.byte	1
	.byte	-1
	.byte	0
	.byte	0
	.byte	8
	.byte	-64
	.byte	22
	.byte	-36
	.byte	5
	.byte	0
	.byte	1
	.byte	1
	.byte	2
	.byte	0
	.byte	1
	.type	usbDescrConfig, @object
	.size	usbDescrConfig, 18
usbDescrConfig:
	.byte	9
	.byte	2
	.byte	18
	.byte	0
	.byte	1
	.byte	1
	.byte	0
	.byte	-128
	.byte	10
	.byte	9
	.byte	4
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.type	usbDescrString0, @object
	.size	usbDescrString0, 4
usbDescrString0:
	.byte	4
	.byte	3
	.byte	9
	.byte	4
	.type	usbDescrString1, @object
	.size	usbDescrString1, 28
usbDescrString1:
	.word	796
	.word	119
	.word	119
	.word	119
	.word	46
	.word	102
	.word	105
	.word	115
	.word	99
	.word	104
	.word	108
	.word	46
	.word	100
	.word	101
	.type	usbDescrString2, @object
	.size	usbDescrString2, 22
usbDescrString2:
	.word	790
	.word	65
	.word	86
	.word	82
	.word	85
	.word	83
	.word	66
	.word	66
	.word	111
	.word	111
	.word	116
	.lcomm usbMsgFlags,1
	.lcomm usbIsReset,1
	.comm usbMsgPtr,2,1
	.comm usbConfiguration,1,1
.global	usbRxBuf
	.section	.bss,"aw",@nobits
	.type	usbRxBuf, @object
	.size	usbRxBuf, 22
usbRxBuf:
	.skip 22,0
	.comm usbDeviceAddr,1,1
	.comm usbNewDeviceAddr,1,1
	.comm usbInputBuf,1,1
	.comm usbAppBuf,1,1
	.comm usbRxLen,1,1
	.comm usbCurrentTok,1,1
	.comm usbRxToken,1,1
	.comm usbTxBuf,11,1
