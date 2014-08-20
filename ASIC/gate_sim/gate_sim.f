+incdir+../../gatelib/
+incdir+../../oram/
+incdir+../../oram/include/
+incdir+../../oram/frontend/
+incdir+../../oram/stash/
+incdir+../../oram/addr/
+incdir+../../oram/encryption/basic/core_ip/rtl/verilog/
+incdir+../../oram/encryption/rew/
+incdir+../../oram/integrity
+incdir+/u/synopsys/syn/H-2013.03-SP2/doc/syn/dft_tutorial/LIB/

+define+MODELSIM
+define+ASIC+SIMULATION_ASIC
+nospecify
-timescale=1ns/1ns

../../oram/frontend/test/testUORAM.v

-v ../synthesis/TinyORAMCore/TinyORAMCore.gate.v
-v /u/synopsys/syn/H-2013.03-SP2/doc/syn/dft_tutorial/LIB/class.v

-v ../../gatelib/ClockSource.v
-v ../../gatelib/Counter.v
-v ../../gatelib/CountCompare.v
-v ../../gatelib/CountAlarm.v
-v ../../gatelib/FIFOControl.v
-v ../../gatelib/FIFORAM.v
-v ../../gatelib/FIFORegControl.v
-v ../../gatelib/FIFOLinear.v
-v ../../gatelib/FIFORegister.v
-v ../../gatelib/FIFOShiftRound.v
-v ../../gatelib/Mux.v
-v ../../gatelib/OneHot2Bin.v
-v ../../gatelib/RAM.v
-v ../../gatelib/Pipeline.v
-v ../../gatelib/Register.v
-v ../../gatelib/Reverse.v
-v ../../gatelib/ShiftRegister.v
-v ../../gatelib/UDCounter.v
-v ../../gatelib/DRAM2RAM.v
-v ../../gatelib/SynthesizedDRAM.v
-v ../../gatelib/SynthesizedRandDRAM.v

-v /u/ibm/ibm_32soi/memory/verilog/beh/RF1DFCMN00256X064D02C064.v
-v /u/ibm/ibm_32soi/memory/verilog/beh/RF1DFCMN00256X128D02C064.v
-v /u/ibm/ibm_32soi/memory/verilog/beh/SRAM1DFCMN01024X128D04C128.v
-v /u/ibm/ibm_32soi/1406757501/verilog/beh/SRAM1DFCMN01024X064D04C128.v
-v /u/ibm/ibm_32soi/memory/verilog/beh/SRAM1DFCMN02048X032D08C128.v
-v /u/ibm/ibm_32soi/memory/verilog/beh/RF2DFCMN00256X008D04C064.v
