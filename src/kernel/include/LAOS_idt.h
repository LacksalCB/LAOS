#ifndef LAOS_IDT_H
#define LAOS_IDT_H

#include <stdint.h>

// OS DEV STUFF
typedef struct {
	uint16_t 	offset_low;
	uint16_t 	cs_selector;
	uint8_t 	zero;
	uint8_t 	attributes;
	uint16_t 	offset_high;
}idt_entry_t;

__attribute__((aligned(0x08)))
static idt_entry_t* idt[256];

#endif /* LAOS_IDT_H */
