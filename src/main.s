	.file	"main.c"
	.arch attiny44
__SREG__ = 0x3f
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__tmp_reg__ = 0
__zero_reg__ = 1
	.global __do_copy_data
	.global __do_clear_bss
.global	lightCycleOver
	.section	.data.lightCycleOver,"aw",@progbits
	.type	lightCycleOver, @object
	.size	lightCycleOver, 1
lightCycleOver:
	.byte	0
.global	lightCounter
	.section	.data.lightCounter,"aw",@progbits
	.type	lightCounter, @object
	.size	lightCounter, 2
lightCounter:
	.word	0
.global	referenceCapacitance
	.section	.data.referenceCapacitance,"aw",@progbits
	.type	referenceCapacitance, @object
	.size	referenceCapacitance, 2
referenceCapacitance:
	.word	-1
	.section	.text.initBuzzer,"ax",@progbits
.global	initBuzzer
	.type	initBuzzer, @function
initBuzzer:
/* prologue: frame size=0 */
/* prologue end (size=0) */
	out 80-0x20,__zero_reg__
	out 83-0x20,__zero_reg__
	in r24,80-0x20
	ori r24,lo8(32)
	out 80-0x20,r24
	in r24,80-0x20
	ori r24,lo8(1)
	out 80-0x20,r24
	in r24,83-0x20
	ori r24,lo8(1)
	out 83-0x20,r24
/* epilogue: frame size=0 */
	ret
/* epilogue end (size=1) */
/* function initBuzzer size 12 (11) */
	.size	initBuzzer, .-initBuzzer
	.section	.text.beep,"ax",@progbits
.global	beep
	.type	beep, @function
beep:
/* prologue: frame size=0 */
/* prologue end (size=0) */
	out 80-0x20,__zero_reg__
	out 83-0x20,__zero_reg__
	in r24,80-0x20
	ori r24,lo8(32)
	out 80-0x20,r24
	in r24,80-0x20
	ori r24,lo8(1)
	out 80-0x20,r24
	in r24,83-0x20
	ori r24,lo8(1)
	out 83-0x20,r24
	ldi r24,lo8(8)
	out 92-0x20,r24
	ldi r24,lo8(4250)
	ldi r25,hi8(4250)
/* #APP */
	1: sbiw r24,1
	brne 1b
/* #NOAPP */
	out 83-0x20,__zero_reg__
	cbi 59-0x20,7
/* epilogue: frame size=0 */
	ret
/* epilogue end (size=1) */
/* function beep size 22 (21) */
	.size	beep, .-beep
	.section	.text.ledOn,"ax",@progbits
.global	ledOn
	.type	ledOn, @function
ledOn:
/* prologue: frame size=0 */
/* prologue end (size=0) */
	in r24,55-0x20
	ori r24,lo8(3)
	out 55-0x20,r24
	cbi 56-0x20,0
	sbi 56-0x20,1
/* epilogue: frame size=0 */
	ret
/* epilogue end (size=1) */
/* function ledOn size 6 (5) */
	.size	ledOn, .-ledOn
	.section	.text.ledOff,"ax",@progbits
.global	ledOff
	.type	ledOff, @function
ledOff:
/* prologue: frame size=0 */
/* prologue end (size=0) */
	in r24,55-0x20
	andi r24,lo8(-4)
	out 55-0x20,r24
	in r24,56-0x20
	andi r24,lo8(-4)
	out 56-0x20,r24
/* epilogue: frame size=0 */
	ret
/* epilogue end (size=1) */
/* function ledOff size 7 (6) */
	.size	ledOff, .-ledOff
	.section	.text.chirp,"ax",@progbits
.global	chirp
	.type	chirp, @function
chirp:
/* prologue: frame size=0 */
	push r28
	push r29
/* prologue end (size=2) */
	cbi 32-0x20,2
	mov r18,r24
	subi r18,lo8(-(-1))
	cpi r18,lo8(-1)
	breq .L51
	ldi r19,lo8(8)
	ldi r20,lo8(4250)
	ldi r21,hi8(4250)
	ldi r22,hlo8(4250)
	ldi r23,hhi8(4250)
	ldi r26,lo8(5000)
	ldi r27,hi8(5000)
	ldi r28,hlo8(5000)
	ldi r29,hhi8(5000)
.L49:
	out 80-0x20,__zero_reg__
	out 83-0x20,__zero_reg__
	in r24,80-0x20
	ori r24,lo8(32)
	out 80-0x20,r24
	in r24,80-0x20
	ori r24,lo8(1)
	out 80-0x20,r24
	in r24,83-0x20
	ori r24,lo8(1)
	out 83-0x20,r24
	out 92-0x20,r19
	mov r25,r21
	mov r24,r20
/* #APP */
	1: sbiw r24,1
	brne 1b
/* #NOAPP */
	out 83-0x20,__zero_reg__
	cbi 59-0x20,7
	mov r24,r26
	mov r25,r27
/* #APP */
	1: sbiw r24,1
	brne 1b
/* #NOAPP */
	subi r18,1
	brcc .L49
.L51:
	sbi 32-0x20,2
/* epilogue: frame size=0 */
	pop r29
	pop r28
	ret
/* epilogue end (size=3) */
/* function chirp size 49 (44) */
	.size	chirp, .-chirp
	.section	.text.spiTransfer16,"ax",@progbits
.global	spiTransfer16
	.type	spiTransfer16, @function
spiTransfer16:
/* prologue: frame size=0 */
/* prologue end (size=0) */
	mov r18,r24
	mov r19,r25
	cbi 32-0x20,1
	mov r24,r19
	clr r25
	out 47-0x20,r24
	cbi 59-0x20,6
	ldi r24,lo8(7)
	ldi r20,lo8(17)
	ldi r25,lo8(19)
.L59:
	out 45-0x20,r20
	out 45-0x20,r25
	subi r24,1
	brcc .L59
	out 47-0x20,r18
	ldi r24,lo8(7)
	ldi r18,lo8(17)
	ldi r25,lo8(19)
.L62:
	out 45-0x20,r18
	out 45-0x20,r25
	subi r24,1
	brcc .L62
	sbi 59-0x20,6
	sbi 32-0x20,1
/* epilogue: frame size=0 */
	ret
/* epilogue end (size=1) */
/* function spiTransfer16 size 27 (26) */
	.size	spiTransfer16, .-spiTransfer16
	.section	.text.__vector_4,"ax",@progbits
.global	__vector_4
	.type	__vector_4, @function
__vector_4:
/* prologue: frame size=0 */
	push __zero_reg__
	push __tmp_reg__
	in __tmp_reg__,__SREG__
	push __tmp_reg__
	clr __zero_reg__
/* prologue end (size=5) */
/* epilogue: frame size=0 */
	pop __tmp_reg__
	out __SREG__,__tmp_reg__
	pop __tmp_reg__
	pop __zero_reg__
	reti
/* epilogue end (size=5) */
/* function __vector_4 size 10 (0) */
	.size	__vector_4, .-__vector_4
	.section	.text.initWatchdog,"ax",@progbits
.global	initWatchdog
	.type	initWatchdog, @function
initWatchdog:
/* prologue: frame size=0 */
/* prologue end (size=0) */
	in r24,65-0x20
	ori r24,lo8(16)
	out 65-0x20,r24
	in r24,65-0x20
	andi r24,lo8(-9)
	out 65-0x20,r24
	in r24,65-0x20
	ori r24,lo8(64)
	out 65-0x20,r24
	in r24,65-0x20
	ori r24,lo8(6)
	out 65-0x20,r24
/* epilogue: frame size=0 */
	ret
/* epilogue end (size=1) */
/* function initWatchdog size 13 (12) */
	.size	initWatchdog, .-initWatchdog
	.section	.text.setupGPIO,"ax",@progbits
.global	setupGPIO
	.type	setupGPIO, @function
setupGPIO:
/* prologue: frame size=0 */
/* prologue end (size=0) */
	sbi 59-0x20,0
	cbi 59-0x20,0
	sbi 59-0x20,2
	cbi 59-0x20,2
	sbi 59-0x20,3
	cbi 59-0x20,3
	in r24,58-0x20
	ori r24,lo8(112)
	out 58-0x20,r24
	sbi 59-0x20,6
	sbi 58-0x20,7
	cbi 59-0x20,7
	sbi 55-0x20,0
	cbi 56-0x20,0
	sbi 55-0x20,1
	cbi 56-0x20,1
	sbi 55-0x20,2
	cbi 56-0x20,2
/* epilogue: frame size=0 */
	ret
/* epilogue end (size=1) */
/* function setupGPIO size 19 (18) */
	.size	setupGPIO, .-setupGPIO
	.section	.text.setupPowerSaving,"ax",@progbits
.global	setupPowerSaving
	.type	setupPowerSaving, @function
setupPowerSaving:
/* prologue: frame size=0 */
/* prologue end (size=0) */
	sbi 33-0x20,1
	sbi 32-0x20,3
	sbi 32-0x20,2
	cbi 38-0x20,7
	sbi 32-0x20,0
	sbi 32-0x20,1
/* epilogue: frame size=0 */
	ret
/* epilogue end (size=1) */
/* function setupPowerSaving size 7 (6) */
	.size	setupPowerSaving, .-setupPowerSaving
	.section	.text.sleep,"ax",@progbits
.global	sleep
	.type	sleep, @function
sleep:
/* prologue: frame size=0 */
/* prologue end (size=0) */
	in r24,85-0x20
	andi r24,lo8(-25)
	ori r24,lo8(16)
	out 85-0x20,r24
	in r24,85-0x20
	ori r24,lo8(32)
	out 85-0x20,r24
	in r24,85-0x20
	ori r24,lo8(-124)
	out 85-0x20,r24
	in r24,85-0x20
	andi r24,lo8(-5)
	out 85-0x20,r24
/* #APP */
	sleep
	
/* #NOAPP */
	in r24,85-0x20
	andi r24,lo8(-33)
	out 85-0x20,r24
/* epilogue: frame size=0 */
	ret
/* epilogue end (size=1) */
/* function sleep size 21 (20) */
	.size	sleep, .-sleep
	.section	.text.sleepWhileADC,"ax",@progbits
.global	sleepWhileADC
	.type	sleepWhileADC, @function
sleepWhileADC:
/* prologue: frame size=0 */
/* prologue end (size=0) */
	in r24,85-0x20
	andi r24,lo8(-25)
	ori r24,lo8(8)
	out 85-0x20,r24
	in r24,85-0x20
	ori r24,lo8(32)
	out 85-0x20,r24
/* #APP */
	sleep
	
/* #NOAPP */
	in r24,85-0x20
	andi r24,lo8(-33)
	out 85-0x20,r24
/* epilogue: frame size=0 */
	ret
/* epilogue end (size=1) */
/* function sleepWhileADC size 15 (14) */
	.size	sleepWhileADC, .-sleepWhileADC
	.section	.text.__vector_13,"ax",@progbits
.global	__vector_13
	.type	__vector_13, @function
__vector_13:
/* prologue: frame size=0 */
	push __zero_reg__
	push __tmp_reg__
	in __tmp_reg__,__SREG__
	push __tmp_reg__
	clr __zero_reg__
/* prologue end (size=5) */
/* epilogue: frame size=0 */
	pop __tmp_reg__
	out __SREG__,__tmp_reg__
	pop __tmp_reg__
	pop __zero_reg__
	reti
/* epilogue end (size=5) */
/* function __vector_13 size 10 (0) */
	.size	__vector_13, .-__vector_13
	.section	.text.getCapacitance,"ax",@progbits
.global	getCapacitance
	.type	getCapacitance, @function
getCapacitance:
/* prologue: frame size=0 */
/* prologue end (size=0) */
	sbi 38-0x20,2
	sbi 38-0x20,3
	sbi 39-0x20,0
	sbi 38-0x20,6
	in r24,85-0x20
	andi r24,lo8(-25)
	ori r24,lo8(8)
	out 85-0x20,r24
	in r24,85-0x20
	ori r24,lo8(32)
	out 85-0x20,r24
/* #APP */
	sleep
	
/* #NOAPP */
	in r24,85-0x20
	andi r24,lo8(-33)
	out 85-0x20,r24
	in r24,36-0x20
	mov r18,r24
	clr r19
	in r24,37-0x20
	clr r25
	mov r25,r24
	clr r24
	or r18,r24
	or r19,r25
	ldi r24,lo8(1023)
	ldi r25,hi8(1023)
	sub r24,r18
	sbc r25,r19
/* epilogue: frame size=0 */
	ret
/* epilogue end (size=1) */
/* function getCapacitance size 32 (31) */
	.size	getCapacitance, .-getCapacitance
	.section	.text.getCapacitanceRounded,"ax",@progbits
.global	getCapacitanceRounded
	.type	getCapacitanceRounded, @function
getCapacitanceRounded:
/* prologue: frame size=0 */
/* prologue end (size=0) */
	ldi r24,lo8(-128)
	out 70-0x20,r24
	ldi r24,lo8(2)
	out 70-0x20,r24
	cbi 32-0x20,0
	sbi 38-0x20,7
	cbi 32-0x20,2
	out 86-0x20,__zero_reg__
	ldi r24,lo8(66)
	out 80-0x20,r24
	ldi r24,lo8(1)
	out 83-0x20,r24
	ldi r24,lo8(250)
	ldi r25,hi8(250)
/* #APP */
	1: sbiw r24,1
	brne 1b
/* #NOAPP */
	rcall getCapacitance
	ldi r18,lo8(10000)
	ldi r19,hi8(10000)
.L111:
	ldi r24,lo8(25)
	ldi r25,hi8(25)
/* #APP */
	1: sbiw r24,1
	brne 1b
/* #NOAPP */
	subi r18,lo8(-(-1))
	sbci r19,hi8(-(-1))
	brne .L111
	rcall getCapacitance
	out 83-0x20,__zero_reg__
	out 80-0x20,__zero_reg__
	cbi 56-0x20,2
	sbi 32-0x20,2
	cbi 38-0x20,7
	sbi 32-0x20,0
	ldi r18,lo8(-128)
	out 70-0x20,r18
	ldi r18,lo8(3)
	out 70-0x20,r18
/* epilogue: frame size=0 */
	ret
/* epilogue end (size=1) */
/* function getCapacitanceRounded size 44 (43) */
	.size	getCapacitanceRounded, .-getCapacitanceRounded
	.section	.text.__vector_3,"ax",@progbits
.global	__vector_3
	.type	__vector_3, @function
__vector_3:
/* prologue: frame size=0 */
	push __zero_reg__
	push __tmp_reg__
	in __tmp_reg__,__SREG__
	push __tmp_reg__
	clr __zero_reg__
	push r24
	push r25
/* prologue end (size=7) */
	out 78-0x20,__zero_reg__
	in r24,76-0x20
	in r25,(76)+1-0x20
	sts (lightCounter)+1,r25
	sts lightCounter,r24
	ldi r24,lo8(1)
	sts lightCycleOver,r24
/* epilogue: frame size=0 */
	pop r25
	pop r24
	pop __tmp_reg__
	out __SREG__,__tmp_reg__
	pop __tmp_reg__
	pop __zero_reg__
	reti
/* epilogue end (size=7) */
/* function __vector_3 size 24 (10) */
	.size	__vector_3, .-__vector_3
	.section	.text.__vector_8,"ax",@progbits
.global	__vector_8
	.type	__vector_8, @function
__vector_8:
/* prologue: frame size=0 */
	push __zero_reg__
	push __tmp_reg__
	in __tmp_reg__,__SREG__
	push __tmp_reg__
	clr __zero_reg__
	push r24
	push r25
/* prologue end (size=7) */
	ldi r24,lo8(-1)
	ldi r25,hi8(-1)
	sts (lightCounter)+1,r25
	sts lightCounter,r24
	ldi r24,lo8(1)
	sts lightCycleOver,r24
/* epilogue: frame size=0 */
	pop r25
	pop r24
	pop __tmp_reg__
	out __SREG__,__tmp_reg__
	pop __tmp_reg__
	pop __zero_reg__
	reti
/* epilogue end (size=7) */
/* function __vector_8 size 23 (9) */
	.size	__vector_8, .-__vector_8
	.section	.text.getLight,"ax",@progbits
.global	getLight
	.type	getLight, @function
getLight:
/* prologue: frame size=0 */
/* prologue end (size=0) */
	cbi 32-0x20,3
	sbi 44-0x20,0
	in r24,55-0x20
	ori r24,lo8(3)
	out 55-0x20,r24
	cbi 56-0x20,0
	sbi 56-0x20,1
	sbi 56-0x20,0
	cbi 56-0x20,1
	in r24,55-0x20
	andi r24,lo8(-4)
	out 55-0x20,r24
	in r24,56-0x20
	andi r24,lo8(-4)
	out 56-0x20,r24
	out (76)+1-0x20,__zero_reg__
	out 76-0x20,__zero_reg__
	out 79-0x20,__zero_reg__
	ldi r24,lo8(3)
	out 78-0x20,r24
	in r24,64-0x20
	ori r24,lo8(1)
	out 64-0x20,r24
	in r24,91-0x20
	ori r24,lo8(32)
	out 91-0x20,r24
	sts lightCycleOver,__zero_reg__
.L132:
	lds r24,lightCycleOver
	tst r24
	brne .L131
	in r24,85-0x20
	andi r24,lo8(-25)
	out 85-0x20,r24
	in r24,85-0x20
	ori r24,lo8(32)
	out 85-0x20,r24
/* #APP */
	sleep
	
/* #NOAPP */
	in r24,85-0x20
	andi r24,lo8(-33)
	out 85-0x20,r24
	rjmp .L132
.L131:
	out 78-0x20,__zero_reg__
	in r24,91-0x20
	andi r24,lo8(-33)
	out 91-0x20,r24
	in r24,64-0x20
	andi r24,lo8(-2)
	out 64-0x20,r24
	cbi 44-0x20,0
	sbi 32-0x20,3
	lds r24,lightCounter
	lds r25,(lightCounter)+1
/* epilogue: frame size=0 */
	ret
/* epilogue end (size=1) */
/* function getLight size 60 (59) */
	.size	getLight, .-getLight
	.section	.text.wakeUpInterval8s,"ax",@progbits
.global	wakeUpInterval8s
	.type	wakeUpInterval8s, @function
wakeUpInterval8s:
/* prologue: frame size=0 */
/* prologue end (size=0) */
	in r24,65-0x20
	andi r24,lo8(-3)
	out 65-0x20,r24
	in r24,65-0x20
	andi r24,lo8(-5)
	out 65-0x20,r24
	in r24,65-0x20
	ori r24,lo8(33)
	out 65-0x20,r24
/* epilogue: frame size=0 */
	ret
/* epilogue end (size=1) */
/* function wakeUpInterval8s size 10 (9) */
	.size	wakeUpInterval8s, .-wakeUpInterval8s
	.section	.text.wakeUpInterval1s,"ax",@progbits
.global	wakeUpInterval1s
	.type	wakeUpInterval1s, @function
wakeUpInterval1s:
/* prologue: frame size=0 */
/* prologue end (size=0) */
	in r24,65-0x20
	andi r24,lo8(-33)
	out 65-0x20,r24
	in r24,65-0x20
	andi r24,lo8(-2)
	out 65-0x20,r24
	in r24,65-0x20
	ori r24,lo8(6)
	out 65-0x20,r24
/* epilogue: frame size=0 */
	ret
/* epilogue end (size=1) */
/* function wakeUpInterval1s size 10 (9) */
	.size	wakeUpInterval1s, .-wakeUpInterval1s
	.section	.text.chirpIfLight,"ax",@progbits
.global	chirpIfLight
	.type	chirpIfLight, @function
chirpIfLight:
/* prologue: frame size=0 */
/* prologue end (size=0) */
	rcall getLight
	lds r24,lightCounter
	lds r25,(lightCounter)+1
	subi r24,lo8(-6)
	sbci r25,hi8(-6)
	brsh .L135
	ldi r24,lo8(3)
	rcall chirp
.L135:
	ret
/* epilogue: frame size=0 */
/* epilogue: noreturn */
/* epilogue end (size=0) */
/* function chirpIfLight size 12 (12) */
	.size	chirpIfLight, .-chirpIfLight
	.section	.text.main,"ax",@progbits
.global	main
	.type	main, @function
main:
/* prologue: frame size=0 */
	ldi r28,lo8(__stack - 0)
	ldi r29,hi8(__stack - 0)
	out __SP_H__,r29
	out __SP_L__,r28
/* prologue end (size=4) */
	sbi 59-0x20,0
	cbi 59-0x20,0
	sbi 59-0x20,2
	cbi 59-0x20,2
	sbi 59-0x20,3
	cbi 59-0x20,3
	in r24,58-0x20
	ori r24,lo8(112)
	out 58-0x20,r24
	sbi 59-0x20,6
	sbi 58-0x20,7
	cbi 59-0x20,7
	sbi 55-0x20,0
	cbi 56-0x20,0
	sbi 55-0x20,1
	cbi 56-0x20,1
	sbi 55-0x20,2
	cbi 56-0x20,2
	sbi 33-0x20,1
	sbi 32-0x20,3
	sbi 32-0x20,2
	cbi 38-0x20,7
	sbi 32-0x20,0
	sbi 32-0x20,1
	ldi r24,lo8(-128)
	out 70-0x20,r24
	ldi r24,lo8(3)
	out 70-0x20,r24
/* #APP */
	sei
/* #NOAPP */
	ldi r24,lo8(2)
	rcall chirp
	in r24,55-0x20
	ori r24,lo8(3)
	out 55-0x20,r24
	cbi 56-0x20,0
	sbi 56-0x20,1
	ldi r24,lo8(2500)
	ldi r25,hi8(2500)
/* #APP */
	1: sbiw r24,1
	brne 1b
/* #NOAPP */
	in r24,55-0x20
	andi r24,lo8(-4)
	out 55-0x20,r24
	in r24,56-0x20
	andi r24,lo8(-4)
	out 56-0x20,r24
	ldi r24,lo8(25000)
	ldi r25,hi8(25000)
/* #APP */
	1: sbiw r24,1
	brne 1b
/* #NOAPP */
	rcall getCapacitanceRounded
	sts (referenceCapacitance)+1,r25
	sts referenceCapacitance,r24
	rcall getLight
	ldi r24,lo8(2)
	rcall chirp
	cbi 32-0x20,1
	out 47-0x20,__zero_reg__
	cbi 59-0x20,6
	ldi r24,lo8(7)
	ldi r18,lo8(17)
	ldi r25,lo8(19)
.L168:
	out 45-0x20,r18
	out 45-0x20,r25
	subi r24,1
	brcc .L168
	out 47-0x20,__zero_reg__
	ldi r24,lo8(7)
	ldi r18,lo8(17)
	ldi r25,lo8(19)
.L171:
	out 45-0x20,r18
	out 45-0x20,r25
	subi r24,1
	brcc .L171
	sbi 59-0x20,6
	sbi 32-0x20,1
	cbi 32-0x20,1
	out 47-0x20,__zero_reg__
	cbi 59-0x20,6
	ldi r24,lo8(7)
	ldi r18,lo8(17)
	ldi r25,lo8(19)
.L175:
	out 45-0x20,r18
	out 45-0x20,r25
	subi r24,1
	brcc .L175
	out 47-0x20,__zero_reg__
	ldi r24,lo8(7)
	ldi r18,lo8(17)
	ldi r25,lo8(19)
.L178:
	out 45-0x20,r18
	out 45-0x20,r25
	subi r24,1
	brcc .L178
	sbi 59-0x20,6
	sbi 32-0x20,1
	lds r18,referenceCapacitance
	lds r19,(referenceCapacitance)+1
	cbi 32-0x20,1
	mov r24,r19
	clr r25
	out 47-0x20,r24
	cbi 59-0x20,6
	ldi r24,lo8(7)
	ldi r20,lo8(17)
	ldi r25,lo8(19)
.L182:
	out 45-0x20,r20
	out 45-0x20,r25
	subi r24,1
	brcc .L182
	out 47-0x20,r18
	ldi r24,lo8(7)
	ldi r18,lo8(17)
	ldi r25,lo8(19)
.L185:
	out 45-0x20,r18
	out 45-0x20,r25
	subi r24,1
	brcc .L185
	sbi 59-0x20,6
	sbi 32-0x20,1
	in r24,65-0x20
	ori r24,lo8(16)
	out 65-0x20,r24
	in r24,65-0x20
	andi r24,lo8(-9)
	out 65-0x20,r24
	in r24,65-0x20
	ori r24,lo8(64)
	out 65-0x20,r24
	in r24,65-0x20
	ori r24,lo8(6)
	out 65-0x20,r24
	clr r15
	mov r14,r15
	ldi r17,lo8(4)
	mov r16,r15
.L275:
	cp r14,r16
	brsh .L190
	in r24,85-0x20
	andi r24,lo8(-25)
	ori r24,lo8(16)
	out 85-0x20,r24
	in r24,85-0x20
	ori r24,lo8(32)
	out 85-0x20,r24
	in r24,85-0x20
	ori r24,lo8(-124)
	out 85-0x20,r24
	in r24,85-0x20
	andi r24,lo8(-5)
	out 85-0x20,r24
/* #APP */
	sleep
	
/* #NOAPP */
	in r24,85-0x20
	andi r24,lo8(-33)
	out 85-0x20,r24
	inc r14
	rjmp .L275
.L190:
	clr r14
	rcall getCapacitanceRounded
	mov r18,r24
	mov r19,r25
	lds r28,referenceCapacitance
	lds r29,(referenceCapacitance)+1
	sub r28,r24
	sbc r29,r25
	cbi 32-0x20,1
	mov r24,r25
	clr r25
	out 47-0x20,r24
	cbi 59-0x20,6
	ldi r24,lo8(7)
	ldi r20,lo8(17)
	ldi r25,lo8(19)
.L199:
	out 45-0x20,r20
	out 45-0x20,r25
	subi r24,1
	brcc .L199
	out 47-0x20,r18
	ldi r24,lo8(7)
	ldi r18,lo8(17)
	ldi r25,lo8(19)
.L202:
	out 45-0x20,r18
	out 45-0x20,r25
	subi r24,1
	brcc .L202
	sbi 59-0x20,6
	sbi 32-0x20,1
	ldi r18,hi8(-50)
	cpi r28,lo8(-50)
	cpc r29,r18
	brge .L204
	tst r15
	brne .L204
	ldi r24,lo8(9)
	rcall chirp
	ldi r18,lo8(3500)
	ldi r19,hi8(3500)
.L213:
	ldi r24,lo8(25)
	ldi r25,hi8(25)
/* #APP */
	1: sbiw r24,1
	brne 1b
/* #NOAPP */
	subi r18,lo8(-(-1))
	sbci r19,hi8(-(-1))
	brne .L213
	ldi r24,lo8(1)
	rcall chirp
	ldi r24,lo8(12500)
	ldi r25,hi8(12500)
/* #APP */
	1: sbiw r24,1
	brne 1b
/* #NOAPP */
	ldi r24,lo8(1)
	rcall chirp
	ldi r21,lo8(1)
	mov r15,r21
.L204:
	ldi r24,hi8(-20)
	cpi r28,lo8(-20)
	cpc r29,r24
	brge .L229
	cpi r17,lo8(1)
	breq .L230
	in r24,65-0x20
	andi r24,lo8(-3)
	out 65-0x20,r24
	in r24,65-0x20
	andi r24,lo8(-5)
	out 65-0x20,r24
	in r24,65-0x20
	ori r24,lo8(33)
	out 65-0x20,r24
.L230:
	ldi r16,lo8(20)
	ldi r17,lo8(1)
	rjmp .L275
.L229:
	ldi r18,hi8(-9)
	cpi r28,lo8(-9)
	cpc r29,r18
	brlt .L233
	rcall getLight
	lds r24,lightCounter
	lds r25,(lightCounter)+1
	subi r24,lo8(-6)
	sbci r25,hi8(-6)
	brsh .L235
	ldi r24,lo8(3)
	rcall chirp
.L235:
	clr r15
.L233:
	ldi r24,hi8(-5)
	cpi r28,lo8(-5)
	cpc r29,r24
	brge .L236
	ldi r18,hi8(-9)
	cpi r28,lo8(-9)
	cpc r29,r18
	brlt .L236
	cpi r17,lo8(2)
	breq .L237
	in r24,65-0x20
	andi r24,lo8(-3)
	out 65-0x20,r24
	in r24,65-0x20
	andi r24,lo8(-5)
	out 65-0x20,r24
	in r24,65-0x20
	ori r24,lo8(33)
	out 65-0x20,r24
.L237:
	ldi r16,lo8(10)
	ldi r17,lo8(2)
	rjmp .L275
.L236:
	sbrs r29,7
	rjmp .L240
	ldi r24,hi8(-4)
	cpi r28,lo8(-4)
	cpc r29,r24
	brlt .L240
	cpi r17,lo8(3)
	breq .L241
	in r24,65-0x20
	andi r24,lo8(-3)
	out 65-0x20,r24
	in r24,65-0x20
	andi r24,lo8(-5)
	out 65-0x20,r24
	in r24,65-0x20
	ori r24,lo8(33)
	out 65-0x20,r24
.L241:
	ldi r17,lo8(3)
	rjmp .L274
.L240:
	sbrc r29,7
	rjmp .L275
	cpi r17,lo8(4)
	breq .L245
	in r24,65-0x20
	andi r24,lo8(-33)
	out 65-0x20,r24
	in r24,65-0x20
	andi r24,lo8(-2)
	out 65-0x20,r24
	in r24,65-0x20
	ori r24,lo8(6)
	out 65-0x20,r24
.L245:
	ldi r17,lo8(4)
.L274:
	ldi r16,lo8(1)
	rjmp .L275
/* epilogue: frame size=0 */
/* epilogue: noreturn */
/* epilogue end (size=0) */
/* function main size 337 (333) */
	.size	main, .-main
/* File "main.c": code  770 = 0x0302 ( 698), prologues  30, epilogues  42 */
