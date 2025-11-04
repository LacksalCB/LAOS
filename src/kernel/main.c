#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "include/vga.h"
 
/* Hardware text mode color constants. */
 
size_t strlen(const char* str) 
{
	size_t len = 0;
	while (str[len])
		len++;
	return len;
}
 
extern void kernel_main(void) 
{
	/* Initialize terminal interface */
	//terminal_initialize();
 
	/* Newline support is left as an exercise. */
	//terminal_writestring("Hello, kernel World!\n");
	//uint8_t* terminal_buffer = (uint8_t*) 0xb8000;
	//terminal_buffer[0] = 0x0044;
	//terminal_buffer[1] = 0x0046;

	unsigned char* VGA_MEMORY = (unsigned char*) (0xB8000);
	VGA_MEMORY[0] = 'K';
	VGA_MEMORY[0] = 0x07;
	for(;;) {}
}
