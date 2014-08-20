
#include <SWTestHarnessDriver.h>
#include <LocalSettings.h>

void main() {
	int fd = initialize_uart(UART_PORT, UART_BAUD);

	//request_histogram(fd);
	print_histogram(fd);
}
