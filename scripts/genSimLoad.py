#!/usr/bin/python
import os
import sys
import re
from collections import defaultdict

prelude = """
    localparam				TimeWidth =				32;

    localparam				HGAWidth =				12; // # slots in histogram (-> no access should take > 2^HGAWidth cycles

    localparam				UARTWidth = 			8;

`ifdef SIMULATION
    localparam				UARTBaud =				1500000; // unrealistically high
`else
    localparam				UARTBaud =				115200;
`endif

    localparam THPWidth = 8 + 32 + 512;

    wire [UARTWidth-1:0]        UARTDataIn;
    wire                        UARTDataInValid, UARTDataInReady;

    wire                        uart_txd, uart_rxd;

    wire [TimeWidth-1:0]        CmdCount;
    wire [THPWidth-1:0]         UARTShftDataIn;
    wire                        UARTShftDataInValid, UARTShftDataInReady;

    wire [UARTWidth-1:0]        UARTDataOut;
    wire                        UARTDataOutValid, UARTDataOutReady;

    reg [31:0]                  InitWait = 0;
    reg                         Start = 1'b0;

    wire                        oram_rst;

    always @(posedge SlowClock) begin
        InitWait <= InitWait + 1;
        if (InitWait == 5) Start <= 1'b1;
    end

    Counter             #(                      .Width(                                 TimeWidth))
    rd_ret_cnt( .Clock(                                 SlowClock),
                .Reset(                                 ~oram_rst),
                .Set(                                   1'b0),
                .Load(                                  1'b0),
                .Enable(                                UARTShftDataInValid & UARTShftDataInReady),
                .In(                                    {TimeWidth{1'bx}}),
                .Count(                                 CmdCount));

    assign UARTShftDataIn =
"""

epilogue = """
                         {8'hff, 32'h0, 512'h0};

    assign      UARTShftDataInValid =                                   Start & CmdCount < 4;

    FIFOShiftRound #(.IWidth(				THPWidth),
		     .OWidth(				UARTWidth),
		     .Reverse(				0))
    uart_I_shft(.Clock(					SlowClock),
		.Reset(					~oram_rst),
		.InData(				UARTShftDataIn),
		.InValid(				UARTShftDataInValid),
		.InAccept(				UARTShftDataInReady),
		.OutData(				UARTDataIn),
		.OutValid(				UARTDataInValid),
		.OutReady(				UARTDataInReady));

    UART#(.ClockFreq(				100_000_000),
	  .Baud(				UARTBaud),
	  .Width(				UARTWidth))
    uart(.Clock(				SlowClock),
	 .Reset(				~oram_rst),
	 .DataIn(				UARTDataIn),
	 .DataInValid(			UARTDataInValid),
	 .DataInReady(			UARTDataInReady),
	 .DataOut(				UARTDataOut),
	 .DataOutValid(			UARTDataOutValid),
	 .DataOutReady(			UARTDataOutReady),
	 .SIn(					uart_txd),
	 .SOut(					uart_rxd));
"""

asm = open(sys.argv[1], 'r')
lines = asm.readlines()

mem = defaultdict(list)

for l in lines:
    g = re.match("([0-9A-Fa-f]+):\s+([0-9A-Fa-f]+).*", l)
    if not g:
        continue
    if g.group(1)[0] == '8':
        mem[(int(g.group(1),16) & 0x7FFFFFFF) >> 5].append(int(g.group(2), 16))

#tty = os.open('/dev/ttyUSB1', os.O_RDWR)
tty = open('code.vh', 'w')
cmd = 0
cmd_count = 0

bottom = 1
line_size = 7

tty.write(prelude)
for m in mem:
    tty.write("(CmdCount == " + str(cmd_count) + ") ? {")
    while len(mem[m]) < 8:
        mem[m].append(0)
    if m % 1 == 0:
        while len(mem[m]) < 8:
            mem[m].append(0)
    else:
        while len(mem[m]) < 8:
            mem[m].insert(0,0)
    a = map(lambda y : format(y, '02x'), map(lambda x: (m >> (x*8)) & 0xFF, range(4)))
    a.reverse()
    addr = ''.join(a)
    tty.write("8'h" + format(cmd, '02x') + ", ")
    tty.write("32'h" + addr + ", ")
    count = 0
    if bottom:
        tty.write("256'h0, ")
    for d in mem[m]:
        tty.write("32'h")
        for i in range(4):
            tty.write(format((d >> ((3-i)*8)) & 0xFF, '02x'))
        if count == line_size and bottom:
            tty.write("} :")
        else:
            tty.write(", ")
        count += 1
    if not bottom:
        tty.write("256'h0} :")
    tty.write("\n")
    cmd_count += 1
tty.write(epilogue)
