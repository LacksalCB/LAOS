#ifndef _KERNEL_TTY_H
#define _KERNEL_TTY_H

#include <stddef.h>
#include <stdbool.h>

// Taken from C escape character list
enum esc_chars {
	EC_ALERT = 				0x07,
	EC_BACKSPACE = 			0x08,
	EC_HTAB = 				0x09,
	EC_NEWLINE = 			0x0A,
	EC_VTAB = 				0X0B,
	EC_PAGE_BREAK =			0X0C,
	EC_CARRIAGE_RETURN = 	0X0D,
	EC_ESC_CHAR = 			0X1B,
	EC_DQUOTE = 			0X22,
	EC_QUOTE = 				0X27,
	EC_QMARK = 				0X3F,
	EC_BACKSLASH = 			0X5C,
};

void terminal_initialize(void);
bool is_esc_char(char c);
void terminal_putescchar(char c);
void terminal_putchar(char c);
void terminal_write(const char* data, size_t size);
void terminal_writestring(const char* data);

#endif

