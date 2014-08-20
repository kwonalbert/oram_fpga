#!/usr/bin/python
import re

#acquired from the oram xilinx vivado project
source_files = [
"axi/axi_oram.v",
"axi/AXI2ORAM.v",
"gatelib/UDCounter.v",
"gatelib/SynthesizedRandDRAM.v",
"gatelib/SynthesizedDRAM.v",
"gatelib/ShiftRegister.v",
"gatelib/Reverse.v",
"gatelib/Register.v",
"gatelib/RAM.v",
"gatelib/Pipeline.v",
"gatelib/OneHot2Bin.v",
"gatelib/Mux.v",
"gatelib/Gray2Bin.v",
"gatelib/FIFOShiftRound.v",
"gatelib/FIFORegister.v",
"gatelib/FIFORegControl.v",
"gatelib/FIFORAM.v",
"gatelib/FIFOControl.v",
"gatelib/DRAM2RAM.v",
"gatelib/Arbiter.v",
"gatelib/RoundRobinSelect.v",
"gatelib/PrioritySelect.v",
"gatelib/Counter.v",
"gatelib/CountCompare.v",
"gatelib/CountAlarm.v",
"gatelib/Bin2Gray.v",
"gatelib/IORegister.v",
"gatelib/Reverse.v",
"gatelib/ParityGen.v",
"gatelib/UAReceiver.v",
"gatelib/UATransmitter.v",
"gatelib/UART.v",
"oram/integrity/Keccak_WF.v",
"oram/integrity/IntegrityVerifier.v",
"oram/stash/StashTop.v",
"oram/stash/StashScanTable.v",
"oram/stash/StashCore.v",
"oram/stash/Stash.v",
"oram/backend/BackendController.v",
"oram/backend/REWStatCtr.v",
"oram/backend/PathORAMBackendInner.v",
"oram/backend/PathORAMBackend.v",
"oram/backend/CoherenceController.v",
"oram/frontend/UORamDataPath.v",
"oram/frontend/UORamController.v",
"oram/frontend/PosMapPLB.v",
"oram/frontend/DM_Cache.v",
"oram/aes/rew/REWAESCore.v",
"oram/aes/rew/ROISeedGenerator.v",
"oram/aes/rew/GentrySeedGenerator.v",
"oram/aes/rew/AESREWORAM.v",
"oram/aes/basic/PRNG.v",
"oram/aes/basic/AES_DW.v",
"oram/aes/basic/AESPathORAM.v",
"oram/aes/rew/core_ip/tiny_aes/table.v",
"oram/aes/rew/core_ip/tiny_aes/round.v",
"oram/aes/rew/core_ip/tiny_aes/aes_128.v",
"oram/aes/basic/core_ip/rtl/verilog/aes_sbox.v",
"oram/aes/basic/core_ip/rtl/verilog/aes_rcon.v",
"oram/aes/basic/core_ip/rtl/verilog/aes_key_expand_128.v",
"oram/aes/basic/core_ip/rtl/verilog/aes_cipher_top.v",
"oram/addr_gen/PathGen.v",
"oram/addr_gen/DRAMInitializer.v",
"oram/addr_gen/BktIDGen.v",
"oram/addr_gen/AddrGenBktHead.v",
"oram/addr_gen/AddrGen.v",
"oram/integrity/core_ip/Keccak512/round2in1.v",
"oram/integrity/core_ip/Keccak512/rconst2in1.v",
"oram/integrity/core_ip/Keccak512/padder1.v",
"oram/integrity/core_ip/Keccak512/padder.v",
"oram/integrity/core_ip/Keccak512/keccak.v",
"oram/integrity/core_ip/Keccak512/f_permutation.v",
"oram/tracegen_hw/ProgramLoader.v",
#"oram/backend/BackendInnerControl.v",
"oram/PathORamTop.v"
]

const_vh = "gatelib/Const.vh"
not_vh_includes = [
"gatelib/DRAM.constants",
"oram/aes/basic/core_ip/rtl/verilog/timescale.v",
]
all_includes = [
"gatelib/Const.vh",
"oram/integrity/SHA3Local.vh",
"oram/integrity/IVCCLocal.vh",
"oram/include/UORAM.vh",
"oram/include/SecurityLocal.vh",
"oram/include/PathORAMBackendLocal.vh",
"oram/include/PathORAM.vh",
"oram/include/DDR3SDRAMLocal.vh",
"oram/include/BucketLocal.vh",
"oram/include/BucketDRAMLocal.vh",
"oram/stash/StashTopLocal.vh",
"oram/stash/StashLocal.vh",
"oram/stash/Stash.vh",
"oram/frontend/PLBLocal.vh",
"oram/frontend/PLB.vh",
"oram/frontend/CacheLocal.vh",
"oram/frontend/CacheCmdLocal.vh",
"oram/aes/rew/REWAESLocal.vh",
"oram/addr_gen/SubTreeLocal.vh",
"oram/tracegen_hw/TestHarnessLocal.vh"
]


verilog = []

include_txt_dict = {}
include_file_dict = {}
include_filenames = []

#remove all const.vh includes; one include to rule them all
def replace_const(str_list):
    for s in str_list:
        if s.count('"Const.vh"'):
            str_list.remove(s)
            break

#replace all includes with corresponding text fromt the include files
def replace_includes(str_list):
    new_list = []
    for s in str_list:
        for fn in include_filenames:
            if s.count('"' + fn + '"'):
                s = ''.join(include_txt_dict[include_file_dict[fn]])
                break
        new_list.append(s)
    return new_list

#create a mapping between filenames and paths, and paths to text
for include in all_includes:
    f = open(include, "r")
    txt_list = f.readlines()
    txt_list.append('\n')
    replace_const(txt_list)
    include_txt_dict[include] = txt_list
    m = re.match('.*/(.*\.vh)', include)
    fn = m.group(1)
    include_file_dict[fn] = include
    include_filenames.append(fn)
    f.close()

f = open("gatelib/DRAM.constants", "r")
txt_list = f.readlines()
txt_list.append('\n')
replace_const(txt_list)
include_txt_dict["gatelib/DRAM.constants"] = txt_list
include_file_dict["DRAM.constants"] = "gatelib/DRAM.constants"
include_filenames.append("DRAM.constants")
f.close()

f = open("oram/aes/basic/core_ip/rtl/verilog/timescale.v", "r")
txt_list = f.readlines()
txt_list.append('\n')
replace_const(txt_list)
include_txt_dict["oram/aes/basic/core_ip/rtl/verilog/timescale.v"] = txt_list
include_file_dict["timescale.v"] = "oram/aes/basic/core_ip/rtl/verilog/timescale.v"
include_filenames.append("timescale.v")
f.close()

#get const.vh
f = open(const_vh, "r")
txt_list = ["`define MACROSAFE\n"]
txt_list.extend(f.readlines())
verilog.extend(txt_list)
f.close()

#process all the source file
for source_file in source_files:
    f = open(source_file, "r")
    txt_list = f.readlines()
    txt_list.append('\n')
    replace_const(txt_list)
    txt_list = replace_includes(txt_list)
    verilog.extend(txt_list)

f = open("PathORAM.v", "w")
text = ''.join(verilog)
text = text.replace('\r', '')
text = text.replace('\t', '    ')
f.write(text)
f.close()
