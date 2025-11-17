[BITS 32]
GLOBAL start

extern kernel_main

start:
	call kernel_main

.hang:
	cli
	hlt 
	jmp .hang
