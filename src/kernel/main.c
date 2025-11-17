#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "include/vga.h"

void kernel_main(void) 
{
	volatile unsigned short* vga = (volatile unsigned short*) (0xB8000);
	unsigned short blank = 0x0F00 | ' ';

	// Clear screen
	for (int i = 0; i < 80 * 25; i++) {
		vga[i] = blank;
	}
	


	vga[0] = 0x0F00 | 'H';
	vga[1] = 0x0F00 | 'i';
	for(;;) {__asm__ __volatile__("hlt");}
}


