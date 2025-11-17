#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

//#include "include/vga.h"
 
void kernel_main(void) 
{
	volatile unsigned short* VGA_MEMORY = (volatile unsigned short*) (0xB8000);
	VGA_MEMORY[0] = 'K';
	VGA_MEMORY[1] = 0x07;
	for(;;) {__asm__ __volatile__("hlt");}

	/* Initialize terminal interface */
	//terminal_initialize();
 
	/* Newline support is left as an exercise. */
	//terminal_writestring("Hello, kernel World!\n");
	//uint8_t* terminal_buffer = (uint8_t*) 0xb8000;
	//terminal_buffer[0] = 0x0044;
	//terminal_buffer[1] = 0x0046;
}


