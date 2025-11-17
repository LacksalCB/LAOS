/* src/kernel/link.ld */
ENTRY(kernel_main)
OUTPUT("elf32-i386")
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

