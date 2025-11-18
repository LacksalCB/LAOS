#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "include/tty.h"

void kernel_main(void) 
{
	// TODO:
	// Handle user input (as a step towards finishing a basic shell) (much harder than expected)
	// Clear screen from QEMU output and bootloader output
	terminal_initialize();
	terminal_writestring("Hello, world!\n");
	terminal_writestring("Keyboard input will be a monster.");		

	for(;;) {__asm__ __volatile__("hlt");}
}

