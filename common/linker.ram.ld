ENTRY(start_)

MEMORY
{
	ram : ORIGIN = 0x20000000, LENGTH = 20k
}

SECTIONS
{
	.text : {
		*(.text.startup_);
		*(.text*);
	} > ram
	.rodata : {
		*(.rodata*);
	} > ram
	.bss : {
		*(.bss*);
	} > ram
}
