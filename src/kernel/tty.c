#include <stddef.h>
#include <stdint.h>
#include <string.h>

#include "include/tty.h"

#include "include/vga.h"

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;
static uint16_t* const VGA_MEMORY = (uint16_t*) 0xB8000;

static size_t terminal_row;
static size_t terminal_column;
static uint8_t terminal_color;
static uint16_t* terminal_buffer;

void terminal_initialize(void) {
	terminal_row = 0;
	terminal_column = 0;
	terminal_color = vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
	terminal_buffer = VGA_MEMORY;
	for (size_t y = 0; y < VGA_HEIGHT; y++) {
		for (size_t x = 0; x < VGA_WIDTH; x++) {
			const size_t index = y * VGA_WIDTH + x;
			terminal_buffer[index] = vga_entry(' ', terminal_color);
		}
	}
}

void terminal_setcolor(uint8_t color) {
	terminal_color = color;
}

void terminal_putentryat(unsigned char c, uint8_t color, size_t x, size_t y) {
	const size_t index = y * VGA_WIDTH + x;
	terminal_buffer[index] = vga_entry(c, color);
}

bool is_esc_char(char c) {
	static bool esc_table[256] = {
		[EC_ALERT] = true,
		[EC_BACKSPACE] = true,
		[EC_HTAB] = true,
		[EC_NEWLINE] = true,
		[EC_VTAB] = true,
		[EC_PAGE_BREAK] = true,
		[EC_CARRIAGE_RETURN] = true,
		[EC_ESC_CHAR] = true,
		[EC_DQUOTE] = true,
		[EC_QUOTE] = true,
		[EC_QMARK] = true,
		[EC_BACKSLASH] = true
	};
	return esc_table[c];
}

void terminal_putescchar(char c) {
	switch (c) {
		case EC_ALERT:
			break;
		case EC_BACKSPACE:
			break;
		case EC_HTAB:
			terminal_column += 4;
			break;
		case EC_NEWLINE:
			terminal_column = 0;
			terminal_row += 1;
			break;
		case EC_VTAB:
			break;
		case EC_PAGE_BREAK:
			break;
		case EC_CARRIAGE_RETURN:
			break;
		case EC_ESC_CHAR:
			break;
		case EC_DQUOTE:
			terminal_column++;
			terminal_putentryat(0x22, terminal_color, terminal_column-1, terminal_row);
			break;
		case EC_QUOTE:
			terminal_column++;
			terminal_putentryat(0x27, terminal_color, terminal_column-1, terminal_row);
			break;
		case EC_QMARK:
			break;
		case EC_BACKSLASH:
			terminal_column++;
			terminal_putentryat(0x5C, terminal_color, terminal_column-1, terminal_row);
			break;
	}	
}

void terminal_putchar(char c) {
	if (is_esc_char(c)) { terminal_putescchar(c); return; };	
	unsigned char uc = c;
	terminal_putentryat(uc, terminal_color, terminal_column, terminal_row);
	if (++terminal_column == VGA_WIDTH) {
		terminal_column = 0;
		if (++terminal_row == VGA_HEIGHT)
			terminal_row = 0;
	}
}

void terminal_write(const char* data, size_t size) {
	for (size_t i = 0; i < size; i++)
		terminal_putchar(data[i]);
}

int _strlen(const char* input){
	int count = 0;
	while (*input) {
		count += 1;
		input++;
	}
    return count;
}

void terminal_writestring(const char* data) {
	terminal_write(data, _strlen(data));
}

