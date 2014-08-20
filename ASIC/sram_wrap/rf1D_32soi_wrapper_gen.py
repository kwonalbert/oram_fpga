import os, sys
from math import *

if len(sys.argv) >= 5:
	NWords, NBits, NDec, NCPBL = (int(arg) for arg in sys.argv[1:6])
else:
	print("Not enough arguments")	
	exit()

# generate SRAM name
SRAM_name = "RF1DFCMN" # Must use F (latency = 1). TODO: other configs less relevent

SRAM_name += "%05d" % NWords + "X%03d" % NBits + "D%02d" % NDec + "C%03d" % NCPBL

print("generating wrapper for %s.v" % SRAM_name)

# generate file
f = open(SRAM_name + "_WRAP.v", 'w')

f.write("// auto generated SRAM wrapper by rf1D_32soi_wrap_gen.py\n\n")

# parameters and IO declaration
_Addr = "_Addr"
_DIn = "_DIn"
_DOut = "_DOut"

DWidth = NBits
AWidth = int(log(NWords, 2))

Upper_IO = ["Clock", "Enable", "Write", _Addr, _DIn, _DOut]
f.write("module " + SRAM_name + "_WRAP ({0});\n\n".format(", ".join(Upper_IO)))

f.write("\tinput {0};\n".format(", ".join(Upper_IO[0:3])))
f.write("\tinput [{0}-1:0] {1};\n".format(AWidth, _Addr))
f.write("\tinput [{0}-1:0] {1};\n".format(DWidth, _DIn))
f.write("\toutput [{0}-1:0] {1};\n\n".format(DWidth, _DOut))


# ---- SRAM paramter and ports ----
# control ports
Connection = [
	("CLK", "Clock"),
	("CE", "Enable"),
	("RDWEN", "!Write"),
	("DEEPSLEEP", "1'b0"),
]

divider = [('\n', 0)]
Connection += divider

def generatePorts(PortAndWidth):
	Ports = []
	for port in PortAndWidth:
		if len(port) == 2:
			port_name, port_width = port
			ports = [port_name] * port_width
			Ports += [ports[i] + str(i) for i in range(port_width)]
		elif len(port) == 3:
			port_name, port_width1, port_width2 = port
			ports = [port_name] * port_width1 * port_width2
			Ports += [ports[i] + str(i) + str(j) for i in range(port_width1) for j in range(port_width2)]
	return Ports

# addr ports
ABW = 1
ACW = 1
ADW = int(log(NDec/2, 2))
AWW = AWidth - ABW - ACW - ADW
AddrPorts = [("AB", ABW), ("AC", ACW), ("AD", ADW), ("AW", AWW)]
AddrPorts = generatePorts(AddrPorts)

Connection += [( AddrPorts[i], "{0}[{1}]".format(_Addr, str(i))) for i in range(AWidth)]
Connection += divider

# data ports
Connection += [( 'D' + str(i), "{0}[{1}]".format(_DIn, str(i))) for i in range(DWidth)]
Connection += [( 'Q' + str(i), "{0}[{1}]".format(_DOut, str(i))) for i in range(DWidth)]
Connection += [( 'BW' + str(i), "1'b1") for i in range(DWidth)]
Connection += divider

# test ports
Col_redundancy = int(ceil(log(ceil(NBits * NDec / 4), 2)))

Connection += divider
TestPorts = [
	("TAB", ABW),
	("TAC", ACW),
	("TAD", ADW),
	("TAW", AWW),
	("TQ",  DWidth),
	("TBW",  DWidth),
	("MIEMAT",  2),
	("MIEMAW",  2),
	("MIEMAWASS",  2),
	("MIEMASASS",  3),
	("CR0", Col_redundancy),
]

TestPorts = generatePorts(TestPorts)

TestPorts += [
	"TCE",
	"TRDWEN",
	"TDEEPSLEEP",
	"MITESTM1",
	"MITESTM3",
	"MICLKMODE",
	"MILSMODE",
	"MIPIPEMODE",
	"MISTM",
	"MISASSD",
	"MIWASSD",
	"MIWRTM",
	"MIFLOOD",
	"CRE0",
]

Connection += [ ( TestPorts[i], "1'b0") for i in range(len(TestPorts))]

# ---- instantiate the SRAM ----
f.write("\t" + SRAM_name + ' SRAM (\n')

for connect in Connection[0:len(Connection)-1]:
	if connect[0] == '\n':
		f.write('\n')
	else:
		f.write("\t\t.{0}(\t{1}),\n".format(connect[0], connect[1]))		
connect = Connection[-1]
f.write("\t\t.{0}(\t{1}));\n".format(connect[0], connect[1]))


f.write("endmodule\n")
f.close()
