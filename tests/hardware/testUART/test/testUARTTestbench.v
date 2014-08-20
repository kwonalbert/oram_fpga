
//==============================================================================
//	Section:	Includes
//==============================================================================
`include "Const.vh"
//==============================================================================

`timescale		1 ns/1 ps		// Display things in ns, compute them in ps

//==============================================================================
//	Module:		testUARTTestbench
//==============================================================================
module testUARTTestbench;
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------

	parameter				UARTWidth =			cut.cut.Width,
							UARTBaud =			cut.cut.Baud;

	localparam				BWidth =			UARTWidth * 3;
							
	localparam				Freq =				200_000_000,
							Cycle = 			1000000000/Freq;	
	
	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------	
	
	reg						sys_rst;
	wire					sys_clk_p, sys_clk_n;
	wire					uart_txd, uart_rxd;
	
	wire	[UARTWidth-1:0]	UARTDataIn;
	wire					UARTDataInValid, UARTDataInReady;
	
	reg						UARTShftDataInValid;
	wire					UARTShftDataInReady;
	
	wire	[UARTWidth-1:0]	UARTDataOut;
	wire					UARTDataOutValid, UARTDataOutReady;
	
	wire	[BWidth-1:0] 	RecvData;
	wire					RecvDataValid;

	reg		[31:0]			InitWait = 0;
	reg						Start = 1'b0;
	
	//--------------------------------------------------------------------------
	//	Clocking & Reset
	//--------------------------------------------------------------------------

	ClockSource #(Freq) ClockF200Gen(.Enable(1'b1), .Clock(sys_clk_p));
	assign	sys_clk_n = 							~sys_clk_p;

	initial begin
		UARTShftDataInValid = 1'b0;
		
		sys_rst = 1'b1;
		#(Cycle*150);
		sys_rst = 1'b0;
		
		UARTShftDataInValid = 1'b1;
		#(Cycle);
		UARTShftDataInValid = 1'b0;
	end

	//--------------------------------------------------------------------------
	//	Send characters
	//--------------------------------------------------------------------------
	
	FIFOShiftRound #(		.IWidth(				BWidth),
							.OWidth(				UARTWidth))
				uart_I_shft(.Clock(					sys_clk_p),
							.Reset(					sys_rst),
							.InData(				"foo"),
							.InValid(				UARTShftDataInValid),
							.InAccept(				UARTShftDataInReady),
							.OutData(				UARTDataIn),
							.OutValid(				UARTDataInValid),
							.OutReady(				UARTDataInReady));
	
	UART		#(			.ClockFreq(				200_000_000), // this much match sys_clk_p freq
							.Baud(					UARTBaud),
							.Width(					UARTWidth))
				uart(		.Clock(					sys_clk_p), 
							.Reset(					sys_rst), 
							.DataIn(				UARTDataIn), 
							.DataInValid(			UARTDataInValid), 
							.DataInReady(			UARTDataInReady), 
							.DataOut(				UARTDataOut), 
							.DataOutValid(			UARTDataOutValid), 
							.DataOutReady(			UARTDataOutReady), 
							.SIn(					uart_txd), 
							.SOut(					uart_rxd));
				
	FIFOShiftRound #(		.IWidth(				UARTWidth),
							.OWidth(				BWidth))
				uart_O_shft(.Clock(					sys_clk_p),
							.Reset(					sys_rst),
							.InData(				UARTDataOut),
							.InValid(				UARTDataOutValid),
							.InAccept(				UARTDataOutReady),
							.OutData(				RecvData),
							.OutValid(				RecvDataValid),
							.OutReady(				1'b1));		
				
	always @(posedge sys_clk_p) begin
		if (RecvDataValid)
			$display("[%m @ %t] Received data = %s", $time, RecvData);
	end
	
	//--------------------------------------------------------------------------
	//	Circuit under test
	//--------------------------------------------------------------------------
	
	testUARTTop	cut(		.sys_clk_p(				sys_clk_p),
							.sys_clk_n(				sys_clk_n),

							.sys_rst(				sys_rst),

							.uart_txd(				uart_txd),
							.uart_rxd(				uart_rxd));

	//--------------------------------------------------------------------------
endmodule
//--------------------------------------------------------------------------
