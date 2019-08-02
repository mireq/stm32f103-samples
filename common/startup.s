.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.section .text.startup_

;@ ====
.thumb_func
.global start_
start_:
	ldr r0, stacktop
	mov sp, r0
	bl main
	b hang

.thumb_func
hang:
	b .

.align
stacktop: .word 0x20005000

.end
