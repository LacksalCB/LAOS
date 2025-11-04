.code16gcc
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
	movw $0x7C00, %sp
	sti

	mov $hello, %si
	call print

	mov $0x1000, %bx
	mov $0x02, %ah
	mov $0x01, %al
	mov $0x00, %ch
	mov $0x02, %cl
	mov $0x00, %dh
	mov $0x00, %dl
	int $0x13

	ljmp $0x0000, $0x1000

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
