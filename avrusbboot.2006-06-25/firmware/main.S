	.file	"main.c"
__SREG__ = 0x3f
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__CCP__  = 0x34
__tmp_reg__ = 0
__zero_reg__ = 1
	.global __do_copy_data
	.global __do_clear_bss
	.text
.global	leaveBootloader
	.type	leaveBootloader, @function
leaveBootloader:
/* prologue: function */
/* frame size = 0 */
/* #APP */
 ;  49 "main.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	ldi r24,lo8(17)
/* #APP */
 ;  50 "main.c" 1
	sts 87, r24
	spm
	
 ;  0 "" 2
/* #NOAPP */
	ldi r24,lo8(1)
	out 91-32,r24
	out 91-32,__zero_reg__
	lds r30,jump_to_app
	lds r31,(jump_to_app)+1
	icall
/* epilogue start */
	ret
	.size	leaveBootloader, .-leaveBootloader
.global	usbFunctionSetup
	.type	usbFunctionSetup, @function
usbFunctionSetup:
/* prologue: function */
/* frame size = 0 */
	movw r30,r24
	ldd r24,Z+1
	cpi r24,lo8(1)
	brne .L4
	rcall leaveBootloader
	rjmp .L13
.L4:
	cpi r24,lo8(2)
	brne .L6
	ldi r24,lo8(1)
	sts state,r24
	ldd r25,Z+3
	ldi r24,lo8(0)
	ldd r18,Z+2
	mov r30,r18
	ldi r31,lo8(0)
	or r30,r24
	or r31,r25
	sts (page_address)+1,r31
	sts page_address,r30
	sts (page_offset)+1,__zero_reg__
	sts page_offset,__zero_reg__
.L7:
	sbic 60-32,1
	rjmp .L7
/* #APP */
 ;  70 "main.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	ldi r24,lo8(3)
/* #APP */
 ;  71 "main.c" 1
	sts 87, r24
	spm
	
 ;  0 "" 2
 ;  72 "main.c" 1
	sei
 ;  0 "" 2
/* #NOAPP */
.L8:
	in __tmp_reg__,87-32
	sbrc __tmp_reg__,0
	rjmp .L8
	ldi r18,lo8(-1)
	rjmp .L5
.L6:
	cpi r24,lo8(3)
	breq .L9
.L13:
	ldi r18,lo8(0)
	rjmp .L5
.L9:
	sts replyBuffer,__zero_reg__
	ldi r24,lo8(64)
	sts replyBuffer+1,r24
	ldi r18,lo8(2)
.L5:
	ldi r24,lo8(replyBuffer)
	ldi r25,hi8(replyBuffer)
	sts (usbMsgPtr)+1,r25
	sts usbMsgPtr,r24
	mov r24,r18
/* epilogue start */
	ret
	.size	usbFunctionSetup, .-usbFunctionSetup
.global	usbFunctionWrite
	.type	usbFunctionWrite, @function
usbFunctionWrite:
	push r15
	push r16
	push r17
	push r28
	push r29
/* prologue: function */
/* frame size = 0 */
	movw r16,r24
	lds r24,state
	cpi r24,lo8(1)
	breq .L15
	ldi r24,lo8(-1)
	rjmp .L16
.L15:
	lds r28,page_address
	lds r29,(page_address)+1
	lds r20,page_offset
	lds r21,(page_offset)+1
	movw r26,r20
	add r26,r28
	adc r27,r29
	ldi r23,lo8(0)
	clr r15
	inc r15
	rjmp .L17
.L20:
/* #APP */
 ;  102 "main.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	movw r30,r16
	add r30,r23
	adc r31,__zero_reg__
	ldd r19,Z+1
	ldi r18,lo8(0)
	ld r24,Z
	ldi r25,lo8(0)
	or r24,r18
	or r25,r19
	movw r30,r26
/* #APP */
 ;  103 "main.c" 1
	movw  r0, r24
	sts 87, r15
	spm
	clr  r1
	
 ;  0 "" 2
 ;  104 "main.c" 1
	sei
 ;  0 "" 2
/* #NOAPP */
	subi r20,lo8(-(2))
	sbci r21,hi8(-(2))
	adiw r26,2
	cpi r20,64
	cpc r21,__zero_reg__
	brlo .L18
	sts (page_offset)+1,r21
	sts page_offset,r20
/* #APP */
 ;  111 "main.c" 1
	cli
 ;  0 "" 2
/* #NOAPP */
	ldi r24,lo8(5)
	movw r30,r28
/* #APP */
 ;  112 "main.c" 1
	sts 87, r24
	spm
	
 ;  0 "" 2
 ;  113 "main.c" 1
	sei
 ;  0 "" 2
/* #NOAPP */
.L19:
	in __tmp_reg__,87-32
	sbrc __tmp_reg__,0
	rjmp .L19
	sts state,__zero_reg__
	ldi r24,lo8(1)
	rjmp .L16
.L18:
	subi r23,lo8(-(2))
.L17:
	cp r23,r22
	brlo .L20
	sts (page_offset)+1,r21
	sts page_offset,r20
	ldi r24,lo8(0)
.L16:
/* epilogue start */
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	ret
	.size	usbFunctionWrite, .-usbFunctionWrite
.global	main
	.type	main, @function
main:
/* prologue: function */
/* frame size = 0 */
	ldi r24,lo8(-1)
	out 56-32,r24
	out 55-32,__zero_reg__
	out 53-32,r24
	out 52-32,__zero_reg__
	ldi r24,lo8(-6)
	out 50-32,r24
	ldi r24,lo8(2)
	out 49-32,r24
	sbic 51-32,2
	rcall leaveBootloader
.L24:
	ldi r24,lo8(1)
	out 91-32,r24
	ldi r24,lo8(2)
	out 91-32,r24
	rcall usbInit
/* #APP */
 ;  139 "main.c" 1
	sei
 ;  0 "" 2
/* #NOAPP */
.L25:
	rcall usbPoll
	rjmp .L25
	.size	main, .-main
.global	jump_to_app
.global	jump_to_app
	.section .bss
	.type	jump_to_app, @object
	.size	jump_to_app, 2
jump_to_app:
	.skip 2,0
	.lcomm state,1
	.lcomm replyBuffer,8
	.lcomm page_address,2
	.lcomm page_offset,2
