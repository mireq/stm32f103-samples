int main(void) {
	for (;;) {
		__asm__ volatile ("bkpt #0xAB");
	}
	return 0;
}
