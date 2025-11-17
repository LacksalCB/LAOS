#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "include/tty.h"

#define WIDTH 80
#define HEIGHT 25

void kernel_main(void) 
{
	// Clear screen from QEMU output and bootloader output
	terminal_initialize();
	terminal_writestring("Hello, world!");
	terminal_putchar(10);
	terminal_writestring("Oh, no!");
	for(;;) {__asm__ __volatile__("hlt");}
}

