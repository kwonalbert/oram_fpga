#set DESIGN_TOPLEVEL  "UORAMController"
set DESIGN_TOPLEVEL  "TinyORAMCore"

# read rtl src files
set fp [open "rtl_src.txt" r]
set DESIGN_RTL [read $fp]
close $fp

set DESIGN_RTL_DIR [list]
set INC_DIR [list ../gatelib/ ./ include/ frontend stash addr encryption encryption/basic/core_ip/rtl/verilog encryption/rew integrity]
foreach item $INC_DIR {
	lappend DESIGN_RTL_DIR ../../oram/$item
}

set SRAM_DIR "/u/ibm/ibm_32soi/memory/lib /u/ibm/ibm_32soi/1406757501/lib /u/ibm/ibm_32soi/1406757855/lib "
set search_path [concat $SRAM_DIR $DESIGN_RTL_DIR $search_path ]

echo "================================="
echo ${DESIGN_RTL_DIR} "\n"
echo ${DESIGN_RTL} "\n"
echo ${DESIGN_TOPLEVEL}
echo "================================="

# SYNOPSIS set target_library "class.db"
set target_library "/u/arm/ibm/32soi/sc9_base_svt/r2p0/db/sc9_32soi_base_svt_tt_nominal_max_0p90v_50c_mns.db"
# SYNOPSIS set synthetic_library "standard.sldb"
set synthetic_library "dw_foundation.sldb"

read_lib -no_warnings RF1DFCMN00256X064D02C064_tt_0p800v-0p950v-VDD-VCS_m40c_mns.lib
read_lib -no_warnings RF1DFCMN00256X128D02C064_tt_0p800v-0p950v-VDD-VCS_m40c_mns.lib
read_lib -no_warnings RF2DFCMN00256X008D04C064_tt_0p800v-0p950v-VDD-VCS_m40c_mns.lib

read_lib -no_warnings SRAM1DFCMN01024X128D04C128_tt_0p800v-0p950v-VDD-VCS_m40c_mns.lib
read_lib -no_warnings SRAM1DFCMN01024X064D04C128_tt_0p800v-0p950v-VDD-VCS_m40c_mns.lib

read_lib -no_warnings SRAM1DFCMN02048X032D08C128_tt_0p800v-0p950v-VDD-VCS_m40c_mns.lib

set link_library [list $target_library $synthetic_library 	\
	RF1DFCMN00256X064D02C064_tt_0p800v-0p950v-VDD-VCS_m40c 	\ 
	RF1DFCMN00256X128D02C064_tt_0p800v-0p950v-VDD-VCS_m40c	\
	RF2DFCMN00256X008D04C064_tt_0p800v-0p950v-VDD-VCS_m40c  \
	SRAM1DFCMN01024X128D04C128_tt_0p800v-0p950v-VDD-VCS_m40c \
	SRAM1DFCMN01024X064D04C128_tt_0p800v-0p950v-VDD-VCS_m40c \
	SRAM1DFCMN02048X032D08C128_tt_0p800v-0p950v-VDD-VCS_m40c    
]
#lappend  link_library {*}$sram_library

define_design_lib WORK -path analyzed

echo "======START ANALYSIS===========================\n"
# read verilog source and elaborate it
set my_define {synthesis ASIC}
analyze -format verilog ${DESIGN_RTL} -define ${my_define}  > analysis.rpt
elaborate -library WORK ${DESIGN_TOPLEVEL} -update > elaborate.rpt
link
echo "======END ANALYSIS===========================\n"

# This command will check your design for any errors
current_design ${DESIGN_TOPLEVEL}
check_design -multiple_designs > check_design.rpt

source synth_test.sdc

echo "======START COMPILATION===========================\n"
#compile -map_effort medium > compile.rpt
#compile -map_effort high
#compile_ultra > compile.rpt
compile_ultra -gate_clock -no_autoungroup > compile.rpt
#compile_ultra -timing_high_effort_script -no_autoungroup
echo "======END COMPILATION=============================\n"

set current_design  ${DESIGN_TOPLEVEL}
change_names -rules verilog -hierarchy -verbose

file mkdir ${DESIGN_TOPLEVEL}

# We write out the results as a verilog netlist
write -format verilog -hierarchy -output [format "%s//%s%s" ${DESIGN_TOPLEVEL} ${DESIGN_TOPLEVEL} ".gate.v"]

# Write out the delay information to the sdf file
write_sdf [format "%s//%s%s" ${DESIGN_TOPLEVEL}  ${DESIGN_TOPLEVEL} ".gate.sdf"]  
write_sdc [format "%s//%s%s" ${DESIGN_TOPLEVEL}  ${DESIGN_TOPLEVEL} ".gate.sdc"]

# We create a timing report for the worst case timing path, 
# an area report for each reference in the heirachy and a DRC report
report_timing > [format "%s//%s%s" ${DESIGN_TOPLEVEL}  ${DESIGN_TOPLEVEL} ".timing.rpt"]
report_area -hierarchy > [format "%s//%s%s" ${DESIGN_TOPLEVEL}  ${DESIGN_TOPLEVEL} ".area.rpt"]
report_power -hier -hier_level 2 > [format "%s//%s%s" ${DESIGN_TOPLEVEL}  ${DESIGN_TOPLEVEL} ".power.rpt"]

report_resources -hierarchy > [format "%s//%s%s" ${DESIGN_TOPLEVEL}  ${DESIGN_TOPLEVEL} ".resource.rpt"]

quit



