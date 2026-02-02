/* src/kernel/link.ld */
ENTRY(_start)
OUTPUT("elf_i386")
SECTIONS {
  . = 0x10000;
  .text : { 
  	*(.text.start)
	*(.text*)
  }
  .rodata : { *(.rodata*) }
  .data : { *(.data*) }
  .bss : { *(.bss*) }
}

