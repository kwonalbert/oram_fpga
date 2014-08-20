
# Performs batch simulations over a parameter space

import sys, os, shutil

# ------------------------------------------------------------------------------
# 	Paths: 	Change PATH_TO_VIVADO to your Vivado installation directory 
#			and PATH_TO_CHIP to where your code lives
# ------------------------------------------------------------------------------

#PATH_TO_VIVADO = "D:/Research/Xilinx/Vivado/2013.4/"
#PATH_TO_CHIP = "D:/Research/Ascend/tags/chip/"
PATH_TO_VIVADO = "C:/Xilinx/Vivado/2013.4/"
PATH_TO_CHIP = "C:/chip/"

shutil.copyfile(PATH_TO_VIVADO + "/data/verilog/src/glbl.v", "./glbl.v")
PATH_TO_OUTPUT = PATH_TO_CHIP + "/tests/software/results/" 
if not os.path.exists(PATH_TO_OUTPUT):
	os.makedirs(PATH_TO_OUTPUT)
PATH_TO_RUN	= PATH_TO_CHIP + "/tests/software/run/" 
if not os.path.exists(PATH_TO_RUN):
	os.makedirs(PATH_TO_RUN)	

# ------------------------------------------------------------------------------
# 	Testbench
# ------------------------------------------------------------------------------

TestBench = "testORAMSystem"	# The testbench you want to run; we provide {testORAMSystem} out of the box

SimInParallel = 0				# whether or not to launch jobs in parallel

# ------------------------------------------------------------------------------
# 	Compile and simulate flags
# ------------------------------------------------------------------------------

DIR_TO_INCLUDE = ["../gatelib", "include", "addr", "backend", "frontend", "stash", "integrity", "aes/rew", "../tests/hardware/testORAM"]
DIR_TO_INCLUDE = ["/oram/" + item for item in DIR_TO_INCLUDE]
PRJ_FILE = "../" + TestBench + ".prj"

COMPILE_OPTIONS = \
[	
	"--relax",
	"--debug typical",
	"--prj " + PRJ_FILE,
	"-m64",
	"-L work",
	"-L fifo_generator_v11_0",
	"-L unisims_ver",
	"-L unimacro_ver",
	"-d \"MACROSAFE=1\" ",
#	"-d \"SIMULATION_VERBOSE_STASH=1\" ",
#	"-d \"SIMULATION_VERBOSE_AES=1\" ",
]
LIBS = ["work.glbl", "work." + TestBench]

TCL_FILE = "../LongRun.tcl"
SIMULATE_OPTIONS = [ "-t " + TCL_FILE, "-onfinish quit"]
SNAPSHOT = []

# ------------------------------------------------------------------------------
# Compile & Simulate
# ------------------------------------------------------------------------------

def compile_xelab(MACRO):
	path_to_include = ["--include " + PATH_TO_CHIP + item for item in DIR_TO_INCLUDE]
	MACRO = ["-d " + macro for macro in MACRO]
	compile_bin = PATH_TO_VIVADO + "bin/xelab "
	compile_log = "most_recent_compile.log"
	compile_command = compile_bin + " ".join(COMPILE_OPTIONS + path_to_include + MACRO + SNAPSHOT + LIBS ) + " > " + compile_log
	#print(compile_command)
	os.system(compile_command)

	# check xsim result
	logfile = open(compile_log)
	Lines = logfile.readlines()
	Lines = "".join(Lines[-5:])
	logfile.close()
	if "Built simulation snapshot" not in Lines:
		print("compilation FAILED")

def simulate_xsim(logFileName):
	simlulate_bin = PATH_TO_VIVADO + "bin/xsim "
	simlulate_command = simlulate_bin + " ".join(SIMULATE_OPTIONS + SNAPSHOT) + " > " + logFileName + ".log"
	#print(simlulate_command)
	
	if SimInParallel == 0:
		os.system(simlulate_command)
		# check xsim result
		logfile = open(logFileName + ".log")
		Lines = logfile.readlines()
		Lines = "".join(Lines[-5:])
		logfile.close()
		if "ALL TESTS PASSED" in Lines:
			print("simulation passed")
		else:
			print("simulation FAILED")
	else:
		batFile = open(logFileName + ".bat", 'w')
		batFile.write(simlulate_command)
		batFile.close()
		os.system("START /B " + logFileName + ".bat") 
		print("simulation launched")
	
quote = "\""
def cleanMacro(MACRO):
	return	[macro.replace('=', '').replace(quote, '')	for macro in MACRO]
	
def run_test(MACRO):
	print("Start run " + TestBench + "\twith config ", MACRO);
	
	compile_xelab(MACRO);
	logFileName = "_".join([TestBench] + cleanMacro(MACRO))
	logFileName = PATH_TO_OUTPUT + '/' + logFileName		
	simulate_xsim(logFileName)

# ------------------------------------------------------------------------------
# 	Parameter space
# ------------------------------------------------------------------------------

os.chdir(PATH_TO_RUN)
	
Prefix = ["Prefix", [2]]
Param0 = ["EnableIV", [0]]
Param1 = ["ORAMZ", [3]]
Param2 = ["ORAML", [10]]
Param3 = ["FEDWidth", [64]]

for param0 in Param0[1]:
	for param1 in Param1[1]:
		for param2 in Param2[1]:
			for param3 in Param3[1]:
				MACRO = []
				MACRO.append(quote + Prefix[0] + '=' + str(Prefix[1][0]) + quote)
				
				MACRO.append(quote + Param0[0] + '=' + str(param0) + quote)
				MACRO.append(quote + Param1[0] + '=' + str(param1) + quote)
				MACRO.append(quote + Param2[0] + '=' + str(param2) + quote)
				MACRO.append(quote + Param3[0] + '=' + str(param3) + quote)
				
				snapshot = "_".join([TestBench] + cleanMacro(MACRO))			
				SNAPSHOT = ["--snapshot " + snapshot]
			
				run_test(MACRO)