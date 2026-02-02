#ifndef LAOS_IDT_H
#define LAOS_IDT_H

#include <stdint.h>

// OS DEV STUFF
typedef struct {
	uint16_t isr_low;
	uint16_t kernel_cs;
	uint8_t reserved;
	uint8_t attributes;
	uint16_t isr_high;
}idt_entry_t;

__attribute__((aligned(0x10)))
static idt_entry_t* idt[256];

#endif /* LAOS_IDT_H */
