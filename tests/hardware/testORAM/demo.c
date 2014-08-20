
#include <SWTestHarnessDriver.h>
#include <LocalSettings.h>
#include <stdlib.h>

void main() {
	srand(0);

	int fd = initialize_uart(UART_PORT, UART_BAUD);

	int Nwrite = 1 << 10;
    int Nread = Nwrite << 1;
    int i;

	// Fill memory
    for (i = 0; i < Nwrite; i++) {
		oram_write(fd, i);
    }

	// Do some random reads
    for (i = 0; i < Nread; i++) {
		oram_read(fd, rand() % Nwrite);
    }

	//request_histogram(fd);
	//print_histogram(fd);
}
