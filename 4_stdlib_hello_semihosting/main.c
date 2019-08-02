#include <stdio.h>
#include <stdlib.h>


extern void initialise_monitor_handles(void);


void SystemInit (void) {
}


int main(void) {
	initialise_monitor_handles();
	puts("Hello semihosting\n");
	for (;;) {
		//void *a = malloc(1);
		//__asm__ volatile ("bkpt #0xAB");
		//free(a);
	}
	return 0;
}
