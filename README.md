
================================================================================
================================================================================
      Tiny ORAM: A low-latency, low-area hardware ORAM controller 
	                  with integrity verification

        by:       Chris Fletcher, Ling Ren, Albert Kwon, 
		    Marten van Dijk, Emil Stefanov and Srinivas Devadas
================================================================================
================================================================================

This README describes the tiny ORAM directory structure and gives some 
performance/area statistics to sanity check your tools.

***NOTE*** All files in this project assume that tabs = 4 spaces.  Configure 
your text editor accordingly!

--------------------------------------------------------------------------------
Directory tree
--------------------------------------------------------------------------------

./oram		The ORAM core, platform-independent code only.
./gatelib	Library modules used by the ORAM core.
./boards	FPGA board specific code, constraint files, test bitstreams and 
			Xilinx IP (Intellectual Property).
./tests		Verilog testbenches for behavioural simulation and Verilog for the 
			FPGA board tests found in /boards.
./scripts	TODO.

For further explanations and instructions, we have included additional README 
files:

./oram/README.txt:
	Gives an overview for the Tiny ORAM architecture, code organization and 
	conventions.

./tests/README.txt:	
	Infrastructure for doing sophisticated unit tests on the ORAM (a bit out 
	of date -- for how to run the code in simulation, see below "Quick 
	Installation").  Gives infrastructure for how to verify that your FPGA board 
	isn't broken. 

--------------------------------------------------------------------------------
Quick installation
--------------------------------------------------------------------------------

1.)	Test the code.
	
1a.) 	Create an FPGA project (e.g., Xilinx Vivado or ISE).

1b.) 	Add all verilog (including *.vh files) from ./oram/* and ./gatelib/*.

1c.)	Add these flags/macros when simulating/synthesizing:
		MACROSAFE=1
		SIMULATION=1
		SIMULATION_VIVADO=1
		FPGA_MEMORY=1
		
1d.) 	Use ./oram/frontend/test/testUORAM.v as the top level testbench.
		Run this simulation for a while and inspect the waveforms to see how it 
		works.

There are also some more sophisticated/automated testbenches but they are a bit 
out of date: See ./tests/README.txt for more information.
	
2.) Test your board.

If you plan to only work in software/RTL simulation, you can skip this step.

Before creating a bitstream and running Tiny ORAM on your board, you should make 
sure the hardware (e.g., the DRAM) on your board works correctly.  We have 
designed some out-of-the-box sanity checks to test your board's hardware.  See 
./tests/README.txt for more information.
	
--------------------------------------------------------------------------------
Expected performance/area figures
--------------------------------------------------------------------------------

See this paper:

Christopher W. Fletcher, Ling Ren, Albert Kwon, Marten van Dijk, Emil Stefanov, 
Dimitrios Serpanos, Srinivas Devadas. 2015.  A Low-Latency, Low-Area Hardware 
Oblivious RAM Controller.  In Proceedings of FCCM'15.
