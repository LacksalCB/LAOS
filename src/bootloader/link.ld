OUTPUT_FORMAT("elf_i386")

ENTRY(_start)

SECTIONS
{
	.image 0x7C00 :
	{
		*(.text)
	}
}


