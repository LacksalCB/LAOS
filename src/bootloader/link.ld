OUTPUT_FORMAT("binary")

ENTRY(_start)

SECTIONS
{
	.image 0x7C00 :
	{
		*(.text)
	}
}


