
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

./oram/README.txt: 	Gives an overview for the Tiny ORAM architecture, code 
					organization and conventions.

./tests/README.txt:	Gives instructions on how to test Tiny ORAM in simulation 
					and also verify that your FPGA board isn't broken. 

./scripts/README.txt: Gives some scripts to automate tedious tasks (such as 
                      creating Xilinx projects)

--------------------------------------------------------------------------------
What to do next
--------------------------------------------------------------------------------

1.)	Go through & familiarize yourself with the code.

Refer to ./oram/README.txt for code structure and naming conventions.
	
2.)	Test the code.
	
Feel free to create an FPGA project (e.g., Xilinx Vivado or ISE) to test the 
code yourself.  We have included some automated tests as well.  See 
./tests/README.txt for more information.
	
3.) Test your board.

If you plan to only work in software/RTL simulation, you can skip this step.

Before creating a bitstream and running Tiny ORAM on your board, you should make 
sure the hardware (e.g., the DRAM) on your board works correctly.  We have 
designed some out-of-the-box sanity checks to test your board's hardware.  See 
./tests/README.txt for more information.
	
4.) Create a Vivado project and create a bitstream.

TODD Refer to ./scripts/README.txt for some useful scripts to automate this process.

--------------------------------------------------------------------------------
Expected performance/area figures
--------------------------------------------------------------------------------

TODO quote some performance / expected area stats