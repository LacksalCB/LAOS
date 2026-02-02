[BITS 32]
global _start
extern kernel_main

section .text.start
_start:
    ; stack set by bootloader is OK, but let's own it
    mov esp, stack_top
    call kernel_main

.hang:
    cli
    hlt
    jmp .hang

section .bss
align 16
stack_bottom:
    resb 16384
stack_top:

