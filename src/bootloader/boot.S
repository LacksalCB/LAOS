.code16
.org 0

.text

.global _start
_start:
	cli

	xorw %ax, %ax
	mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss

	movw $0x3000, %sp	

	sti

	movw $hello, %si
	call print	

print:
	xorb %bh, %bh
	movb $0x0E, %ah

	lodsb

	cmpb $0, %al
	je 1f

	int $0x10;
	jmp print
	ret

1: ret

hello:
	.asciz "Hello World!\n"	


.fill 510-(.-_start), 1, 0
.org 510
.word 0xAA55
