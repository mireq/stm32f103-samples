int svc_call(int command, const void *message) {
	int output;
	__asm volatile
	(
		"mov r0, %[com] \n"
		"mov r1, %[msg] \n"
		"bkpt #0xAB \n"
		"mov %[out], r0"
		: [out] "=r" (output)
		: [com] "r" (command), [msg] "r" (message)
		: "r0", "r1"
	);
	return output;
}


void svc_write0(const char *message) {
	svc_call(0x04, message);
}


int main(void) {
	for (;;) {
		svc_write0("Hello semihosting!\n");
	}
	return 0;
}
