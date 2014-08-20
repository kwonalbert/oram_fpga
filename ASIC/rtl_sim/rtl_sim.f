+incdir+../../gatelib/
+incdir+../../oram/
+incdir+../../oram/include/
+incdir+../../oram/frontend/
+incdir+../../oram/stash/
+incdir+../../oram/addr/
+incdir+../../oram/encryption/basic/core_ip/rtl/verilog/
+incdir+../../oram/encryption/rew/
+incdir+../../oram/integrity

+define+MODELSIM
+define+ASIC+SIMULATION_ASIC
+nospecify
-timescale=1ns/1ns

../../oram/frontend/test/testUORAM.v

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

-v ../../oram/encryption/basic/core_ip/rtl/verilog/aes_cipher_top.v
-v ../../oram/encryption/basic/core_ip/rtl/verilog/aes_key_expand_128.v
-v ../../oram/encryption/basic/core_ip/rtl/verilog/aes_rcon.v
-v ../../oram/encryption/basic/core_ip/rtl/verilog/aes_sbox.v
-v ../../oram/encryption/basic/AES_DW.v
-v ../../oram/encryption/basic/PRNG.v
-v ../../oram/encryption/basic/AESPathORAMModel.v

-v ../../oram/frontend/DM_Cache.v
-v ../../oram/frontend/PosMapPLB.v
-v ../../oram/frontend/UORAMDataPath.v
-v ../../oram/frontend/UORAMController.v
-v ../../oram/frontend/Frontend.v

-v ../../oram/addr/PathGen.v
-v ../../oram/addr/BktIDGen.v
-v ../../oram/addr/AddrGenBktHead.v
-v ../../oram/addr/AddrGen.v
-v ../../oram/addr/DRAMInitializer.v

-v ../../oram/stash/StashScanTable.v
-v ../../oram/stash/StashCore.v
-v ../../oram/stash/Stash.v
-v ../../oram/stash/StashTop.v
-v ../../oram/stash/DRAMToStash.v
-v ../../oram/stash/StashToDRAM.v

-v ../../oram/backend/PathORAMBackendCore.v
-v ../../oram/backend/BackendCoreController.v
-v ../../oram/backend/PathORAMBackend.v
-v ../../oram/backend/REWStatCtr.v

-v ../../oram/encryption/rew/core_ip/tiny_aes/aes_128.v
-v ../../oram/encryption/rew/core_ip/tiny_aes/round.v
-v ../../oram/encryption/rew/core_ip/tiny_aes/table.v
-v ../../oram/encryption/basic/AES_DW.v
-v ../../oram/encryption/basic/AES_W.v
-v ../../oram/encryption/basic/PRNG.v
-v ../../oram/encryption/basic/AESPathORAM.v

-v ../../oram/integrity/core_ip/Keccak512/padder1.v
-v ../../oram/integrity/core_ip/Keccak512/padder.v
-v ../../oram/integrity/core_ip/Keccak512/rconst2in1.v
-v ../../oram/integrity/core_ip/Keccak512/round2in1.v
-v ../../oram/integrity/core_ip/Keccak512/f_permutation.v
-v ../../oram/integrity/core_ip/Keccak512/keccak.v
-v ../../oram/integrity/IntegrityVerifier.v
-v ../../oram/integrity/Keccak_WF.v

-v ../../oram/TinyORAMCore.v

-v ../sram_wrap/SRAM_WRAP.v
-v ../sram_wrap/RF1DFCMN00256X064D02C064_WRAP.v
-v ../sram_wrap/RF1DFCMN00256X128D02C064_WRAP.v
-v ../sram_wrap/SRAM1DFCMN01024X128D04C128_WRAP.v
-v ../sram_wrap/SRAM1DFCMN01024X064D04C128_WRAP.v
-v ../sram_wrap/SRAM1DFCMN02048X032D08C128_WRAP.v
-v ../sram_wrap/RF2DFCMN00256X008D04C064_WRAP.v
-v ../sram_wrap/SRAM2SFCMN00128X032D04C064_WRAP.v

-v /u/ibm/ibm_32soi/memory/verilog/beh/RF1DFCMN00256X064D02C064.v
-v /u/ibm/ibm_32soi/memory/verilog/beh/RF1DFCMN00256X128D02C064.v
-v /u/ibm/ibm_32soi/memory/verilog/beh/SRAM1DFCMN01024X128D04C128.v
-v /u/ibm/ibm_32soi/1406757501/verilog/beh/SRAM1DFCMN01024X064D04C128.v
-v /u/ibm/ibm_32soi/memory/verilog/beh/SRAM1DFCMN02048X032D08C128.v
-v /u/ibm/ibm_32soi/memory/verilog/beh/RF2DFCMN00256X008D04C064.v
-v /u/ibm/ibm_32soi/1406757855/verilog/beh/SRAM2SFCMN00128X032D04C064.v

