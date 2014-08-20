
#include <SWTestHarnessDriver.h>

//------------------------------------------------------------------------------
// UART driver
//------------------------------------------------------------------------------

int set_interface_attribs(int fd, int speed, int parity) {
	struct termios tty;
	memset (&tty, 0, sizeof tty);
	if (tcgetattr (fd, &tty) != 0) {
		printf("error %d from tcgetattr", errno);
		return -1;
	}

	cfsetospeed (&tty, speed);
	cfsetispeed (&tty, speed);

	tty.c_cflag = (tty.c_cflag & ~CSIZE) | CS8; // 8-bit chars
	// disable IGNBRK for mismatched speed tests; otherwise receive break
	// as \000 chars
	tty.c_iflag &= ~IGNBRK;         // ignore break signal
	tty.c_lflag = 0;                // no signaling chars, no echo,
									// no canonical processing
	tty.c_oflag = 0;                // no remapping, no delays
	tty.c_cc[VMIN]  = 0;            // read doesn't block
	tty.c_cc[VTIME] = 5;            // 0.5 seconds read timeout

	tty.c_iflag &= ~(IXON | IXOFF | IXANY); // shut off xon/xoff ctrl

	tty.c_cflag |= (CLOCAL | CREAD);// ignore modem controls,
									// enable reading
	tty.c_cflag &= ~(PARENB | PARODD); // shut off parity
	tty.c_cflag |= parity;
	tty.c_cflag &= ~CSTOPB;
	tty.c_cflag &= ~CRTSCTS;

	if (tcsetattr(fd, TCSANOW, &tty) != 0) {
		printf("error %d from tcsetattr", errno);
		return -1;
	}
	return 0;
}

void set_blocking(int fd, int should_block) {
	struct termios tty;
	memset (&tty, 0, sizeof tty);
	if (tcgetattr (fd, &tty) != 0) {
		printf ("error %d from tggetattr", errno);
		return;
	}

	tty.c_cc[VMIN]  = should_block ? 1 : 0;
	tty.c_cc[VTIME] = 100; // 0.5 seconds read timeout

	if (tcsetattr (fd, TCSANOW, &tty) != 0)
		printf ("error %d setting term attributes", errno);
}

//------------------------------------------------------------------------------
// HWTestHarness interface
//------------------------------------------------------------------------------

int initialize_uart(char * portname, int baud /* must match TestHarnessLocal.vh */) {
	int fd = open(portname, O_RDWR | O_NOCTTY | O_SYNC);

	if (fd < 0) {
		printf("error %d opening %s: %s", errno, portname, strerror (errno));
		return;
	}

	set_interface_attribs(fd, baud, 0); // set speed to 115,200 bps, 8n1 (no parity)
	set_blocking(fd, 1); // set blocking
	
	return fd;
}

/* Send a new command to TinyORAMCore */
void send_cmd(int fd, cmd_t cmd, paddr_t paddr, datab_t datab, timed_t timed) {
	write(fd, &timed, sizeof(timed_t));
	write(fd, &datab, sizeof(datab_t));
	write(fd, &paddr, sizeof(paddr_t));
	write(fd, &cmd, sizeof(cmd_t));
}

/* Send the start command to TinyORAMCore */
void request_histogram(int fd) {
	send_cmd(fd, 	CMD_Start, 
					0xdeadbeef /* don't care */, 
					0xba5eba11 /* don't care */, 
					0);
}

/* Poll UART until FPGA sends data back and interpret this data as an access-latency histogram */
void print_histogram(int fd) {
	char buf[4];
	int i = 0;
	int total = 0;
	while (1) {
		read(fd, buf, 4);
		unsigned int cast = *((datab_t *) buf);
		unsigned int temp;
		temp = (cast << 24) | (0x00ff0000 & (cast << 8)) | (0x0000ff00 & (cast >> 8)) | (cast >> 24);
		if (temp) 
			printf("%d,\t%u\n", i, temp);
		total += temp;
		i++;
		if (i >= HISTOGRAM_SIZE - 1) break;
	}
	printf("Total accesses = %d\n", total);
}

void oram_write(int fd, int addr) { send_cmd(fd, CMD_Update, addr, 0, 0); }
void oram_read(int fd, int addr) { send_cmd(fd, CMD_Read, addr, 0, 0); }

