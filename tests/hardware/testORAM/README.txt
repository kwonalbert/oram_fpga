==== 1.) Make sure your UART is working and check your UART port.

a.) Check your UART port with the linux command "dmesg | grep tty".  Look for the last entry called something like

"cp210x converter now attached to ttyUSB0" --- in this case, the port is ttyUSB0

b.) Make sure the UART works.  Follow testUART for the VC707.

==== 2.) Program the board with /private/data/bitfiles/ascend_vc707_L20_unified_rew.bit.

You may also try the other bitfiles in this directory but this one works fine.

==== 3.) Run the demo.

a.) cd to /tests/hardware/testORAM

b.) Open demo.c and set UART_PORT to the UART port from step 1.

c.) Run the command "sh build.sh ; sudo ./demo"

It should pause for a few seconds (as it sends commands to ORAM) and then print out the histogram.  If you want to run the demo 2x times, reprogram the board each time.  This old bitfile has reset issues.
