
`timescale 1ps/100fs

//==============================================================================
//	Section:	Includes
//==============================================================================
`include "Const.vh"
//==============================================================================

module testDRAMTestbench;

	localparam RESET_PERIOD = 	200000; //in pSec  
	parameter CLKIN_PERIOD = 	5000;

	//**************************************************************************//
	// Wire Declarations
	//**************************************************************************//

	reg                                sys_rst_n;
	wire                               sys_rst;


	reg								sys_clk_i;
	wire                               sys_clk_p;
	wire                               sys_clk_n;

	wire								uart_txd;


	wire	[7:0]			UARTDataOut;
	wire					UARTDataOutValid;

  
	//**************************************************************************//
	// Reset Generation
	//**************************************************************************//

	initial begin
		sys_rst_n = 1'b0;
		#RESET_PERIOD
		sys_rst_n = 1'b1;
	end

	assign sys_rst = ~sys_rst_n;

	//**************************************************************************//
	// Clock Generation
	//**************************************************************************//

	initial
	sys_clk_i = 1'b0;
	always
	sys_clk_i = #(CLKIN_PERIOD/2.0) ~sys_clk_i;

	assign sys_clk_p = sys_clk_i;
	assign sys_clk_n = ~sys_clk_i;

	UART		#(			.ClockFreq(				cut.ClockFreq),
							.Baud(					9600),
							.Width(					8))
				uart(		.Clock(					sys_clk_p), 
							.Reset(					sys_rst), 
							.DataIn(				), 
							.DataInValid(			1'b0), 
							.DataInReady(			), 
							.DataOut(				UARTDataOut), 
							.DataOutValid(			UARTDataOutValid), 
							.DataOutReady(			1'b1), 
							.SIn(					uart_txd), 
							.SOut(					));
	
	always @(posedge sys_clk_p) begin
		if (UARTDataOutValid) $display("Terminal: %s", UARTDataOut);
	end
	
	//--------------------------------------------------------------------------
	//	CUT
	//--------------------------------------------------------------------------
	
	testDRAMTop cut(	    .sys_clk_p(				sys_clk_p),
							.sys_clk_n(				sys_clk_n),
							.sys_rst(				sys_rst),
							.GPIO_SW_C(				1'b0),
							.uart_txd(				uart_txd));

	//--------------------------------------------------------------------------
endmodule
//--------------------------------------------------------------------------
