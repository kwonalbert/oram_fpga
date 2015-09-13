
*** NOTE: the testORAMSystem test is a bit out of date and won't compile right 
    now.  The problems are minor: it would be great for someone to bring it 
	back to life :-) 
	
	For now, please see the top level readme (quick installation) on running 
	the code in simulation. ***

This README describes how to verify that 

(a) Tiny ORAM works out-of-the-box in RTL simulation,

(b) your FPGA board's hardware (e.g., DRAM) is working.

and states 

(c) what parameterizations have been tested by the TinyORAM developers.

The README assumes the ./tests directory is the working directory.

==============================================================================
Software simulation tests: testORAMSystem.v
==============================================================================

This section will explain how to set up your host machine (a laptop or desktop) 
to run Tiny ORAM batch simulations.  The goal by the end will be to have stress 
tested the Tiny ORAM code over many ORAM parameter settings (e.g., block size).

---------------------------------------	
Required software
---------------------------------------	

Python	(tested on Python 3.3 and 3.4. Should work for most 2.x 3.x version)
Vivado	(tested on Vivado 2013.4 and 2014.1)	

Tested platform: Windows 7

---------------------------------------	
Run simulation with /software/simulate.py
---------------------------------------	

1.) Open ./simulate.py in your favorite text editor.

1.)	Indicate system paths to Vivado and Tiny ORAM by modifying 'PATH_TO_VIVADO' 
	and 'PATH_TO_CHIP'.

2.) Choose a testbench (modify 'TestBench')

We currently support a testbench called 'testORAMSystem' (source Verilog is under 
./software/testORAMSystem.v), which tests TinyORAMCore, its interface to a fake 
DRAM, and a traffic generator.

You are welcome to write & incorporate your own testbench.  Be sure to add a 
*.prj file in /software directory listing all the source files.

3.)	Specify the parameter space over which you will run the tests by modifying 
	the last section of the script (called 'Parameter space').  
	
T tests, where T is the Cartesian product of the parameters you are sweeping, 
will be run automatically.
	
4.)	Run python simulate.py.

If any compilation fails, the most recent compile log will be in 
  /software/run/most_recent_compile.log.  
Simulation output will be in 
  /software/results/[testbench]_[per_config].log

For each test that runs, the terminal will print 'simulation passed' if the test 
passes and 'simulation FAILED' otherwise.
  
---------------------------------------	
Troubleshooting
---------------------------------------	

- If the simulation FAILS: 

1.) Open the log under /software/results/ to see what happened.  The code has many 
assertions and triggering a single assertion will cause a failure.

2.) Open your favorite simulator (e.g., Vivado xsim or Modelsim), reproduce the 
assertion failure, and debug.  To help with debugging, open simulate.py and 
uncomment the compile flags 'SIMULATION_VERBOSE_STASH' and 
'SIMULATION_VERBOSE_AES' for additional visibility.

- If you make a change to the Tiny ORAM source code and that change seems to 
have no effect, it's most likely that the compilation failed, and the tool 
silently ran some old compiled version.

Solution: delete the entire 'run' directory and run simulate.py again.

- When running simulations in parallel, the shell usually dies. 

Solution: Don't close the shell since that will terminate the simulation.

==============================================================================
FPGA board hardware tests: testUART and testDRAM
==============================================================================

To verify that your FPGA board works correctly:

1.)	cd to ./boards/YOUR-BOARD.

YOUR-BOARD will be the Xilinx vc707, kc705 or vc709.

2.) You will see two FPGA bitstreams: testUART.bit and testDRAM.bit.

Follow the instructions below, one for each of these bitstreams, to test the 
serial/UART and DRAM capabilities on your board.	

---------------------------------------	
testUART
---------------------------------------	

A simple UART loopback test.  This test will make sure that your terminal (on 
your host machine) is configured correctly and that the USB-UART chip on your 
board is working.

Test procedure:

1.) Load bitfile to FPGA.

2.) Open serial terminal and set the baud rate to 9600 (other serial parameters: 
	8b data, no parity).
	
3.) Type some characters in the terminal using your keyboard.

If your UART is working, you will see the characters that you type on 
your UART terminal.  If the UART is not working, you will see nothing appear.

Troubleshooting:

- You type and see no response: You are likely talking on the wrong terminal/COM 
channel.  This may also indicate a problem with your hardware.  If you are 
certain your terminal is set correctly, see the 'HELP' section at the bottom.

- You type and see incorrect characters: Your terminal baud is set incorrectly 
(it is probably set too high).

---------------------------------------	
testDRAM
---------------------------------------	
	
A DRAM stress test that sends ORAM-like accesses to the DDR3 DRAM on the VC707.  
This test will figure out what your DRAM's bit error rate is, and exactly what 
types of bit errors your DRAM produces.

***READ*** In our experience, the Xilinx evaluation boards that don't have 
built-in ECC (e.g., the VC707) have minor defects that lead to DRAM bit error 
rates of about 1 bit error / 10^(-9) DQ transfers.  Some boards additionally 
ship with bad DRAM DIMMs which exacerbate these problems.  These DRAM error 
rates _will_ cause ORAM to crash after several million ORAM accesses.  To get 
around these bit error issues, we are planning to add an ECC layer to the 
boards.  We will update this README when it is complete.

Test procedure:

1.) Load bitfile to FPGA.

2.) Verify that LED[7] is lit.  This indicates that DRAM has calibrated.

3.) Verify that LED[6] is lit (but dim).  This indicates that data is being 
	transferred between DRAM/FPGA.
	
** If step 2 or 3 don't work as expected, see the 'HELP' section at the bottom.

4.) Wait patiently.  When the FPGA detects a DRAM error, it will light up 
	LED[0].  If the FPGA detects 2+ bit errors in a single DRAM burst, it will 
	light up LED[1].  You should let the design run overnight to collect a good 
	number of errors (e.g., our boards detect ~500 errors when run overnight).
	
5.) When LED[0] lights up, you can see information on the DRAM errors over UART.  
	For this, make sure serial is connected to the FPGA and your terminal is 
	configured to baud = 9600 (see the UART.bit tutorial above).  To dump DRAM 
	error statistics, push SW6 (center user push button) on the FPGA board.  If 
	serial is configured correctly, you will see a stream of 29 x (# errors) hex 
	characters over on your terminal.  Each 29 characters are statistics for 
	each error.  The statistics can be read as follows (ordered as they appear 
	in the serial terminal):
	
	- [3 hex characters] 	How many bit errors occurred in the DRAM burst (1 - 
							512).  Use this to determine how broken DRAM is / 
							what type of ECC is needed by your application to 
							fix it.
	
	Note: 	If the # of bit errors is close to 256, it may be because an AES 
			initialization vector bit was corrupted.  In this case, the # of 
			bit errors is probably 1.  If the # of bit errors is > 1 but < 10, 
			that means your DRAM is very broken (i.e., has a legitimate > 1 bit
			/ burst error rate).  We have never seen > 1 but < 10 bit errors per 
			burst in any of our tests.

	- [3 hex characters] 	If the # of bit errors == 1, what was the bit 
							position where the error occurred (0 - 511).  Use 
							this to diagnose bad pins/traces on the FPGA board.  
							In our experience, each board has a _different_ 
							faulty DQ pin and errors always occur to the bit 
							position % 64 (where 64 = DQ width). 
							
	- [16 hex characters]	The number of DRAM bursts (512 bits each) that have 
							been checked so far.  Use this to determine the bit 
							error rate.
							
	- [7 hex characters]	The DRAM address where the error occurred.  

	Note: Unfortunately, testDRAM.bit makes Path ORAM accesses.  So, some 
	addresses (e.g., address 0, which stores the root bucket) are touched more 
	frequently than others.  Unfortunately, this means it is difficult to tell 
	if there is a 'bad' location in DRAM by checking the correlation of bit 
	errors to DRAM address.  If the same address repeatedly sees errors, while 
	other addresses that are close to it (e.g., 10 and 16) do not see errors, 
	however, that is suspicious of a bad DRAM address.										
							
	Example output: 00102C000000002C195DA3000069800102C000000006B3DEEAB0015008
	This indicates two errors:
		00102C000000002C195DA30000698 	-> 001 02C 000000002C195DA3 0000698 
										-> 	1 bit error
											at bit position 0x2c = 44 decimal 
											at DRAM burst address 0x698 = 1688.  
											739859875 bursts have been checked total.
		00102C000000006B3DEEAB0015008 	-> .. you should be able to figure it out :) 
		
	The current bitfile tracks up to 8K errors.

---------------------------------------	
testORAM
---------------------------------------	
		
TODO		
		
---------------------------------------
HELP: What to do if board tests fail
---------------------------------------	

If there is a serious problem with a board test, you may have to do some 
hardware debugging.  To help, we have included all of the Verilog needed to 
rebuild testUART.bit and testDRAM.bit under ./hardware.

==============================================================================
Tested parameterizations
==============================================================================

TODO