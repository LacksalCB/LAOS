#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "include/LAOS_tty.h"

void kernel_main(void) 
{
	terminal_initialize();
	terminal_writestring("Hello, world!\n");
	terminal_writestring("Keyboard input will be interesting.");		

	for(;;) {__asm__ __volatile__("hlt");}
}

